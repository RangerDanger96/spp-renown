#include "RenownModule.h"

#include "BattleGround/BattleGround.h"
#include "BattleGround/BattleGroundMgr.h"
#include "Chat/Chat.h"
#include "Database/DatabaseEnv.h"
#include "Entities/Creature.h"
#include "Entities/Item.h"
#include "Entities/Player.h"
#include "Globals/ObjectMgr.h"
#include "Log/Log.h"
#include "Maps/Map.h"
#include "Mails/Mail.h"
#include "Server/WorldSession.h"
#include "Tools/Formulas.h"
#include "World/World.h"

#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <sstream>

namespace cmangos_module
{
    bool RenownPlayerOk(const Player* player)
    {
        return player && player->IsInWorld() && player->GetMap() && !player->IsBeingTeleported();
    }

    RenownModule::RenownModule()
    : Module("Renown", new RenownModuleConfig())
    {

    }

    const RenownModuleConfig* RenownModule::GetConfig() const
    {
        return (RenownModuleConfig*)Module::GetConfig();
    }

    void RenownModule::OnInitialize()
    {
        TalentsInit();

        if (!GetConfig()->enabled)
        {
            return;
        }

        // Create the storage table on first run so no manual SQL import is needed
        CharacterDatabase.DirectExecute(
            "CREATE TABLE IF NOT EXISTS `custom_renown` ("
            "`guid` INT UNSIGNED NOT NULL COMMENT 'Character guid',"
            "`points` INT UNSIGNED NOT NULL DEFAULT '0',"
            "`rank` TINYINT UNSIGNED NOT NULL DEFAULT '1',"
            "PRIMARY KEY (`guid`)"
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Renown PvP progression'");

        // Spendable Renown points (added with the Renown vendor currency). Existing characters start with
        // everything they have earned so far.
        auto column = CharacterDatabase.Query("SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'custom_renown' AND COLUMN_NAME = 'spendable'");
        if (!column)
        {
            CharacterDatabase.DirectExecute("ALTER TABLE `custom_renown` ADD COLUMN `spendable` INT UNSIGNED NOT NULL DEFAULT '0' AFTER `points`");
            CharacterDatabase.DirectExecute("UPDATE `custom_renown` SET `spendable` = `points`");
        }

        LoadVendorCosts();
        LoadDungeonLoot();
        RvRInit();
        QuestsInit();

        sLog.outString("Renown module initialized (max rank %u, %u items cost Renown)", GetConfig()->maxRank, (uint32)m_vendorCosts.size());
    }

    void RenownModule::OnLoadFromDB(Player* player)
    {
        if (!player || !GetConfig()->enabled)
        {
            return;
        }

        const uint32 playerId = player->GetObjectGuid().GetCounter();

        RenownData data;
        auto result = CharacterDatabase.PQuery("SELECT `points`, `spendable` FROM `custom_renown` WHERE `guid` = '%u'", playerId);
        if (result)
        {
            Field* fields = result->Fetch();
            data.points = fields[0].GetUInt32();
            data.spendable = fields[1].GetUInt32();
        }

        data.rank = GetConfig()->GetRankForPoints(data.points);

        QuestsLoad(player);

        std::lock_guard<std::mutex> lock(m_dataMutex);
        m_data[playerId] = data;
    }

    void RenownModule::OnSaveToDB(Player* player)
    {
        if (!player || !GetConfig()->enabled)
        {
            return;
        }

        const uint32 playerId = player->GetObjectGuid().GetCounter();

        RenownData data;
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            auto it = m_data.find(playerId);
            if (it == m_data.end())
            {
                return;
            }

            data = it->second;
        }

        if (data.points > 0 || data.spendable > 0)
        {
            SaveData(playerId, data);
        }

        if (!player->GetDailyQuests().empty())
        {
            QuestsSave(player);
        }
    }

    void RenownModule::SaveData(uint32 playerId, const RenownData& data)
    {
        CharacterDatabase.PExecute("REPLACE INTO `custom_renown` (`guid`, `points`, `spendable`, `rank`) VALUES ('%u', '%u', '%u', '%u')", playerId, data.points, data.spendable, data.rank);
    }

    void RenownModule::OnDeleteFromDB(uint32 playerId)
    {
        CharacterDatabase.PExecute("DELETE FROM `custom_renown` WHERE `guid` = '%u'", playerId);

        std::lock_guard<std::mutex> lock(m_dataMutex);
        m_data.erase(playerId);
    }

    void RenownModule::OnLogOut(Player* player)
    {
        if (!player)
        {
            return;
        }

        TalentsOnLogout(player);

        // Make sure the latest value is written before the cache entry goes away
        OnSaveToDB(player);

        {
            std::lock_guard<std::mutex> bolsterLock(m_bolsterMutex);
            m_bolster.erase(player->GetObjectGuid().GetCounter());
        }

        {
            std::lock_guard<std::mutex> combatLock(m_combatMutex);
            m_attackers.erase(player->GetObjectGuid().GetCounter());
            m_healers.erase(player->GetObjectGuid().GetCounter());
        }

        std::lock_guard<std::mutex> lock(m_dataMutex);
        m_data.erase(player->GetObjectGuid().GetCounter());
    }

    void RenownModule::OnRewardHonor(Player* player, Unit* victim)
    {
        // Battleground kills are counted through the scoreboard instead
        if (!player || !victim || !GetConfig()->enabled || player->InBattleGround())
        {
            return;
        }

        if (victim->GetTypeId() != TYPEID_PLAYER || victim == player)
        {
            return;
        }

        const Player* victimPlayer = (const Player*)victim;
        if (victimPlayer->GetTeam() == player->GetTeam())
        {
            return;
        }

        if (MaNGOS::XP::IsTrivialLevelDifference(player->GetLevel(), victimPlayer->GetLevel()))
        {
            return;
        }

        // The honor hook can fire more than once for the same kill, ignore repeats
        const uint32 playerId = player->GetObjectGuid().GetCounter();
        const uint64 victimGuid = victim->GetObjectGuid().GetRawValue();
        const time_t now = time(nullptr);
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            RenownData& data = m_data[playerId];
            if (data.lastVictim == victimGuid && (now - data.lastVictimTime) < 5)
            {
                return;
            }

            data.lastVictim = victimGuid;
            data.lastVictimTime = now;
        }

        AddRenown(player, GetConfig()->pointsWorldKill);
    }

    void RenownModule::OnUpdatePlayerScore(BattleGround* battleground, Player* player, uint8 scoreType, uint32 value)
    {
        if (!battleground || !player || !GetConfig()->enabled || value == 0)
        {
            return;
        }

        const RenownModuleConfig* config = GetConfig();
        uint32 points = 0;
        switch (scoreType)
        {
            case SCORE_HONORABLE_KILLS:      points = config->pointsHonorableKill; break;
            case SCORE_KILLING_BLOWS:        points = config->pointsKillingBlow; break;
            case SCORE_FLAG_CAPTURES:        points = config->pointsFlagCapture; break;
            case SCORE_FLAG_RETURNS:         points = config->pointsFlagReturn; break;
            case SCORE_BASES_ASSAULTED:      points = config->pointsBaseAssault; break;
            case SCORE_BASES_DEFENDED:       points = config->pointsBaseDefend; break;
            case SCORE_GRAVEYARDS_ASSAULTED: points = config->pointsGraveyardAssault; break;
            case SCORE_GRAVEYARDS_DEFENDED:  points = config->pointsGraveyardDefend; break;
            case SCORE_TOWERS_ASSAULTED:     points = config->pointsTowerAssault; break;
            case SCORE_TOWERS_DEFENDED:      points = config->pointsTowerDefend; break;
            case SCORE_SECONDARY_OBJECTIVES: points = config->pointsSecondaryObjective; break;
            default: break;
        }

        if (points)
        {
            // Score updates are usually +1, guard against odd batch values
            AddRenown(player, points * std::min<uint32>(value, 10));
        }
    }

    void RenownModule::OnEndBattleGround(BattleGround* battleground, uint32 winnerTeam)
    {
        if (!battleground || !GetConfig()->enabled)
        {
            return;
        }

        // Rank by what was earned during the match, before the win/loss renown is added
        AwardLootBags(battleground, winnerTeam);

        // Barrens domination: tier 1 battleground wins push the front
        if (winnerTeam != TEAM_NONE && battleground->GetMaxLevel() <= GetConfig()->rvrMaxLevel)
        {
            RvRDominate(winnerTeam, 1000);
        }

        for (const auto& entry : battleground->GetPlayers())
        {
            Player* player = sObjectMgr.GetPlayer(entry.first);
            if (!player)
            {
                continue;
            }

            const bool won = winnerTeam != TEAM_NONE && (uint32)entry.second.playerTeam == winnerTeam;
            AddRenown(player, won ? GetConfig()->pointsWin : GetConfig()->pointsLoss);
        }
    }

    uint32 RenownModule::CalculateBolsterLevel(BattleGround* battleground, Player* player) const
    {
        if (!battleground || !player || !GetConfig()->enabled || !GetConfig()->bolsterEnabled)
        {
            return 0;
        }

        const BattleGroundBracketId bracketId = battleground->GetBracketId();
        if (bracketId == BG_BRACKET_ID_TEMPLATE)
        {
            return 0;
        }

        uint32 target = sBattleGroundMgr.GetMaxLevelForBattleGroundBracketId(bracketId, battleground->GetTypeId());
        target = std::min(target, sWorld.getConfig(CONFIG_UINT32_MAX_PLAYER_LEVEL));
        return target > player->GetLevel() ? target : 0;
    }

    uint32 RenownModule::GetBolsterLevel(const Player* player) const
    {
        if (!player)
        {
            return 0;
        }

        std::lock_guard<std::mutex> lock(m_bolsterMutex);
        auto itr = m_bolster.find(player->GetObjectGuid().GetCounter());
        return itr != m_bolster.end() ? itr->second : 0;
    }

    void RenownModule::ApplyLevelStats(Player* player, uint32 level)
    {
        if (!player || !player->IsInWorld())
        {
            return;
        }

        // Combat formulas (hit, skills, attack power, spell resists) use the bolster level too (core patch)
        player->SetBolsterLevel(level > player->GetLevel() ? level : 0);

        PlayerLevelInfo info;
        sObjectMgr.GetPlayerLevelInfo(player->getRace(), player->getClass(), level, &info);

        PlayerClassLevelInfo classInfo;
        sObjectMgr.GetPlayerClassLevelInfo(player->getClass(), level, &classInfo);

        const bool alive = player->IsAlive();
        const float healthPct = player->GetMaxHealth() ? player->GetHealthPercent() : 100.0f;
        const float manaPct = player->GetPowerPercent(POWER_MANA);

        player->_RemoveAllStatBonuses();

        for (int i = STAT_STRENGTH; i < MAX_STATS; ++i)
        {
            player->SetCreateStat(Stats(i), info.stats[i]);
            player->SetStat(Stats(i), info.stats[i]);
        }

        player->SetCreateHealth(classInfo.basehealth);
        player->SetCreateMana(classInfo.basemana);

        player->_ApplyAllStatBonuses();

        if (alive)
        {
            const uint32 health = std::max<uint32>(1, uint32(player->GetMaxHealth() * healthPct / 100.0f));
            player->SetHealth(health);

            if (player->GetMaxPower(POWER_MANA) > 0)
            {
                player->SetPower(POWER_MANA, uint32(player->GetMaxPower(POWER_MANA) * manaPct / 100.0f));
            }
        }
    }

    void RenownModule::OnJoinBattleGround(BattleGround* battleground, Player* player)
    {
        if (player)
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            m_data[player->GetObjectGuid().GetCounter()].bgEarned = 0;
        }

        const uint32 target = CalculateBolsterLevel(battleground, player);
        if (!target)
        {
            return;
        }

        {
            std::lock_guard<std::mutex> lock(m_bolsterMutex);
            m_bolster[player->GetObjectGuid().GetCounter()] = target;
        }

        ApplyLevelStats(player, target);

        if (player->isRealPlayer())
        {
            ChatHandler(player).PSendSysMessage("|cff00ccffBolster:|r you fight as a level %u in this battleground (stats, health, mana, skills and hit chance).", target);
        }
    }

    void RenownModule::OnLeaveBattleGround(BattleGround* battleground, Player* player)
    {
        if (!player)
        {
            return;
        }

        bool wasBolstered = false;
        {
            std::lock_guard<std::mutex> lock(m_bolsterMutex);
            wasBolstered = m_bolster.erase(player->GetObjectGuid().GetCounter()) > 0;
        }

        if (wasBolstered)
        {
            ApplyLevelStats(player, player->GetLevel());
        }
    }

    void RenownModule::OnGetPlayerLevelInfo(Player* player, PlayerLevelInfo& info)
    {
        // Keeps the bolster if the core rebuilds stats while inside the battleground (e.g. .reset stats)
        const uint32 target = GetBolsterLevel(player);
        if (target && (player->InBattleGround() || RvRIsMember(player->GetObjectGuid().GetCounter())))
        {
            sObjectMgr.GetPlayerLevelInfo(player->getRace(), player->getClass(), target, &info);
        }
    }

    void RenownModule::OnGetPlayerClassLevelInfo(Player* player, PlayerClassLevelInfo& info)
    {
        const uint32 target = GetBolsterLevel(player);
        if (target && (player->InBattleGround() || RvRIsMember(player->GetObjectGuid().GetCounter())))
        {
            sObjectMgr.GetPlayerClassLevelInfo(player->getClass(), target, &info);
        }
    }

    void RenownModule::LoadVendorCosts()
    {
        std::unordered_map<uint32, uint32> costs;
        std::unordered_map<uint32, uint32> tiers;
        auto hasTier = WorldDatabase.Query("SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'custom_renown_vendor' AND COLUMN_NAME = 'tier'");
        auto result = WorldDatabase.Query(hasTier ? "SELECT `item`, `cost`, `tier` FROM `custom_renown_vendor`" : "SELECT `item`, `cost`, 0 FROM `custom_renown_vendor`");
        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                if (fields[1].GetUInt32() > 0)
                {
                    costs[fields[0].GetUInt32()] = fields[1].GetUInt32();
                    tiers[fields[0].GetUInt32()] = fields[2].GetUInt32();
                }
            }
            while (result->NextRow());
        }
        else
        {
            sLog.outString("Renown: table custom_renown_vendor is missing or empty, all vendor items cost gold");
        }

        std::lock_guard<std::mutex> lock(m_vendorMutex);
        m_vendorCosts.swap(costs);
        m_vendorTiers.swap(tiers);
    }

    uint32 RenownModule::GetRenownCost(uint32 itemId) const
    {
        std::lock_guard<std::mutex> lock(m_vendorMutex);
        auto itr = m_vendorCosts.find(itemId);
        return itr != m_vendorCosts.end() ? itr->second : 0;
    }

    bool RenownModule::OnPreBuyItem(Player* player, Creature* vendor, uint32 itemId, uint32 count, uint32& price)
    {
        if (!player || !GetConfig()->enabled)
        {
            return false;
        }

        const uint32 cost = GetRenownCost(itemId) * std::max<uint32>(count, 1);
        if (!cost)
        {
            return false;   // normal gold item
        }

        const RenownData data = GetData(player->GetObjectGuid().GetCounter());
        if (data.spendable < cost)
        {
            ChatHandler(player).PSendSysMessage("|cffffd100[Renown]|r That costs %u Renown points. You have %u.", cost, data.spendable);
            player->SendBuyError(BUY_ERR_NOT_ENOUGHT_MONEY, vendor, itemId, 0);
            return true;
        }

        price = 0;          // paid with Renown in OnBuyItem once the item is in the bags
        return false;
    }

    void RenownModule::OnBuyItem(Player* player, Creature* vendor, Item* item, uint32 count)
    {
        if (!player || !item || !GetConfig()->enabled)
        {
            return;
        }

        const uint32 cost = GetRenownCost(item->GetEntry()) * std::max<uint32>(count, 1);
        if (!cost)
        {
            return;
        }

        const uint32 playerId = player->GetObjectGuid().GetCounter();
        uint32 left = 0;
        RenownData saved;
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            RenownData& data = m_data[playerId];
            data.spendable = data.spendable > cost ? data.spendable - cost : 0;
            left = data.spendable;
            saved = data;
        }

        SaveData(playerId, saved);
        ChatHandler(player).PSendSysMessage("|cffffd100[Renown]|r Spent %u Renown points. %u left.", cost, left);
        SendAddonUpdate(player);
    }

    void RenownModule::SendAddonPrices(Player* player) const
    {
        if (!player || !player->isRealPlayer() || !player->GetSession())
        {
            return;
        }

        std::vector<std::pair<uint32, uint32>> costs;
        {
            std::lock_guard<std::mutex> lock(m_vendorMutex);
            costs.assign(m_vendorCosts.begin(), m_vendorCosts.end());
        }

        // Format: RENOWNP<tab>item=cost,item=cost,...  (several messages, each well below the 255 character limit)
        auto flush = [player](const std::string& body)
        {
            const std::string message = "RENOWNP\t" + body;
            WorldPacket packet;
            ChatHandler::BuildChatPacket(packet, CHAT_MSG_PARTY, message.c_str(), LANG_ADDON, CHAT_TAG_NONE, player->GetObjectGuid(), player->GetName());
            player->GetSession()->SendPacket(packet);
        };

        std::string body;
        for (const auto& entry : costs)
        {
            const std::string part = std::to_string(entry.first) + "=" + std::to_string(entry.second);
            if (body.size() + part.size() + 1 > 200)
            {
                flush(body);
                body.clear();
            }

            body += (body.empty() ? "" : ",") + part;
        }

        if (!body.empty())
        {
            flush(body);
        }
    }

    bool RenownModule::HandleGiveCommand(WorldSession* session, const std::string& args)
    {
        Player* self = session ? session->GetPlayer() : nullptr;
        if (!self || !GetConfig()->enabled)
        {
            return false;
        }

        const std::vector<std::string> arguments = helper::SplitString(args, " ");
        if (arguments.empty() || !helper::IsValidNumberString(arguments[0]))
        {
            ChatHandler(self).PSendSysMessage("Usage: .renown give <points> [character name]  (spendable points only, rank unchanged)");
            return true;
        }

        Player* target = ResolveCommandTarget(session, arguments.size() > 1 ? arguments[1] : "");
        if (!target)
        {
            ChatHandler(self).PSendSysMessage("That character is not online.");
            return true;
        }

        const long amount = std::strtol(arguments[0].c_str(), nullptr, 10);
        const uint32 playerId = target->GetObjectGuid().GetCounter();
        RenownData saved;
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            RenownData& data = m_data[playerId];
            data.spendable = (uint32)std::max<long>(0, (long)data.spendable + amount);
            saved = data;
        }

        SaveData(playerId, saved);
        SendAddonUpdate(target);
        SendStatus(self, target);
        return true;
    }

    bool RenownModule::HandleReloadCommand(WorldSession* session, const std::string& args)
    {
        LoadVendorCosts();
        LoadDungeonLoot();
        if (Player* self = session ? session->GetPlayer() : nullptr)
        {
            ChatHandler(self).PSendSysMessage("Renown vendor prices reloaded (%u items).", (uint32)m_vendorCosts.size());
            SendAddonPrices(self);
        }

        return true;
    }

    // ------------------------------------------------------------------ loot bags
    uint32 RenownModule::GetRenownTier(Player* player) const
    {
        const RenownData data = const_cast<RenownModule*>(this)->GetData(player->GetObjectGuid().GetCounter());
        const std::vector<uint32>& ranks = GetConfig()->insigniaRanks;
        uint32 tier = 0;
        for (size_t i = 0; i < ranks.size(); ++i)
        {
            if (data.rank >= ranks[i])
            {
                tier = (uint32)i + 1;
            }
        }

        return tier;
    }

    static uint32 RenownBracketForLevel(uint32 level)
    {
        if (level < 10)
        {
            return 0;
        }

        return std::min<uint32>(level / 10, 6);
    }

    static const char* DungeonName(uint32 map)
    {
        switch (map)
        {
            case 389: return "Ragefire Chasm";
            case 36:  return "the Deadmines";
            case 43:  return "the Wailing Caverns";
            case 33:  return "Shadowfang Keep";
            case 48:  return "Blackfathom Deeps";
            case 34:  return "the Stockade";
            case 90:  return "Gnomeregan";
            case 47:  return "Razorfen Kraul";
            case 189: return "the Scarlet Monastery";
            case 129: return "Razorfen Downs";
            case 70:  return "Uldaman";
            case 209: return "Zul'Farrak";
            case 349: return "Maraudon";
            case 109: return "the Sunken Temple";
            case 230: return "Blackrock Depths";
            case 229: return "Blackrock Spire";
            case 429: return "Dire Maul";
            case 289: return "Scholomance";
            case 329: return "Stratholme";
            default:  return "a dungeon";
        }
    }

    void RenownModule::LoadDungeonLoot()
    {
        std::vector<DungeonLoot> loot;
        if (auto result = WorldDatabase.Query("SELECT `item`, `map`, `reqlevel`, `quality` FROM `custom_renown_dungeon_loot`"))
        {
            do
            {
                Field* fields = result->Fetch();
                DungeonLoot entry;
                entry.item = fields[0].GetUInt32();
                entry.map = fields[1].GetUInt32();
                entry.reqLevel = fields[2].GetUInt32();
                entry.quality = fields[3].GetUInt32();
                if (ObjectMgr::GetItemPrototype(entry.item))
                {
                    loot.push_back(entry);
                }
            }
            while (result->NextRow());
        }

        std::lock_guard<std::mutex> lock(m_vendorMutex);
        m_dungeonLoot.swap(loot);
        sLog.outString("Renown: %u dungeon items for loot bags", uint32(m_dungeonLoot.size()));
    }

    uint32 RenownModule::PickDungeonItem(Player* player, BagType bag, uint32& map) const
    {
        // Quality by bag: gold = blue with a good chance at epic, purple = blue, blue = mostly green
        uint32 wanted = ITEM_QUALITY_RARE;
        if (bag == BAG_GOLD && urand(1, 100) <= 35)
        {
            wanted = ITEM_QUALITY_EPIC;
        }
        else if ((bag == BAG_BLUE && urand(1, 100) <= 70) || bag == BAG_GREEN)
        {
            wanted = ITEM_QUALITY_UNCOMMON;
        }

        uint32 armorType = ITEM_SUBCLASS_ARMOR_CLOTH;
        if (player->HasSkill(SKILL_PLATE_MAIL))
        {
            armorType = ITEM_SUBCLASS_ARMOR_PLATE;
        }
        else if (player->HasSkill(SKILL_MAIL))
        {
            armorType = ITEM_SUBCLASS_ARMOR_MAIL;
        }
        else if (player->HasSkill(SKILL_LEATHER))
        {
            armorType = ITEM_SUBCLASS_ARMOR_LEATHER;
        }

        const uint32 playerClass = player->getClass();
        const bool physical = playerClass == CLASS_WARRIOR || playerClass == CLASS_ROGUE || playerClass == CLASS_HUNTER;
        const bool caster = playerClass == CLASS_MAGE || playerClass == CLASS_PRIEST || playerClass == CLASS_WARLOCK;
        const uint32 level = player->GetLevel();

        std::vector<DungeonLoot> pool;
        {
            std::lock_guard<std::mutex> lock(m_vendorMutex);
            pool = m_dungeonLoot;
        }

        // Try the wanted quality first, then step down one quality at a time
        for (uint32 quality = wanted; quality >= ITEM_QUALITY_UNCOMMON; --quality)
        {
            std::vector<const DungeonLoot*> candidates;
            for (const DungeonLoot& entry : pool)
            {
                if (entry.quality != quality || entry.reqLevel > level || entry.reqLevel + 6 < level)
                {
                    continue;
                }

                ItemPrototype const* proto = ObjectMgr::GetItemPrototype(entry.item);
                if (!proto || player->CanUseItem(proto, false) != EQUIP_ERR_OK || player->HasItemCount(entry.item, 1, true))
                {
                    continue;
                }

                // Armor: only the best type the player wears (cloaks, rings, necks, trinkets and shields are fine)
                if (proto->Class == ITEM_CLASS_ARMOR && proto->SubClass >= ITEM_SUBCLASS_ARMOR_CLOTH && proto->SubClass <= ITEM_SUBCLASS_ARMOR_PLATE &&
                    proto->InventoryType != INVTYPE_CLOAK && proto->SubClass != armorType)
                {
                    continue;
                }

                // Stats that suit the class
                int physicalStats = 0, casterStats = 0;
                for (uint32 s = 0; s < MAX_ITEM_PROTO_STATS; ++s)
                {
                    switch (proto->ItemStat[s].ItemStatType)
                    {
                        case ITEM_MOD_STRENGTH: case ITEM_MOD_AGILITY: physicalStats += proto->ItemStat[s].ItemStatValue; break;
                        case ITEM_MOD_INTELLECT: case ITEM_MOD_SPIRIT: casterStats += proto->ItemStat[s].ItemStatValue; break;
                        default: break;
                    }
                }

                if ((physical && casterStats > physicalStats) || (caster && physicalStats > casterStats))
                {
                    continue;
                }

                candidates.push_back(&entry);
            }

            if (!candidates.empty())
            {
                const DungeonLoot* pick = candidates[urand(0, uint32(candidates.size() - 1))];
                map = pick->map;
                return pick->item;
            }

            if (quality == ITEM_QUALITY_UNCOMMON)
            {
                break;
            }
        }

        return 0;
    }

    uint32 RenownModule::PickRewardItem(Player* player) const
    {
        std::vector<std::pair<uint32, uint32>> items;   // item, tier
        {
            std::lock_guard<std::mutex> lock(m_vendorMutex);
            for (const auto& entry : m_vendorTiers)
            {
                items.emplace_back(entry.first, entry.second);
            }
        }

        const uint32 unlocked = GetRenownTier(player);
        const uint32 playerBracket = RenownBracketForLevel(player->GetLevel());

        // Best armor type the player can wear: plate > mail > leather > cloth
        uint32 armorType = ITEM_SUBCLASS_ARMOR_CLOTH;
        if (player->HasSkill(SKILL_PLATE_MAIL))
        {
            armorType = ITEM_SUBCLASS_ARMOR_PLATE;
        }
        else if (player->HasSkill(SKILL_MAIL))
        {
            armorType = ITEM_SUBCLASS_ARMOR_MAIL;
        }
        else if (player->HasSkill(SKILL_LEATHER))
        {
            armorType = ITEM_SUBCLASS_ARMOR_LEATHER;
        }

        const uint32 playerClass = player->getClass();
        const bool physical = playerClass == CLASS_WARRIOR || playerClass == CLASS_ROGUE || playerClass == CLASS_HUNTER;
        const bool caster = playerClass == CLASS_MAGE || playerClass == CLASS_PRIEST || playerClass == CLASS_WARLOCK;

        // Look in the player's own level bracket first, then fall back one bracket at a time
        for (int bracket = (int)playerBracket; bracket >= 0; --bracket)
        {
            std::vector<uint32> candidates;
            for (const auto& entry : items)
            {
                if (entry.second > unlocked)
                {
                    continue;
                }

                ItemPrototype const* proto = ObjectMgr::GetItemPrototype(entry.first);
                if (!proto || (proto->Class != ITEM_CLASS_WEAPON && proto->Class != ITEM_CLASS_ARMOR))
                {
                    continue;
                }

                if ((int)RenownBracketForLevel(std::max<uint32>(proto->RequiredLevel, 1)) != bracket)
                {
                    continue;
                }

                if (player->CanUseItem(proto, false) != EQUIP_ERR_OK)
                {
                    continue;
                }

                if (proto->Class == ITEM_CLASS_ARMOR && proto->SubClass >= ITEM_SUBCLASS_ARMOR_CLOTH &&
                    proto->SubClass <= ITEM_SUBCLASS_ARMOR_PLATE && proto->SubClass != armorType &&
                    proto->InventoryType != INVTYPE_CLOAK)
                {
                    continue;
                }

                bool hasPhysical = false;
                bool hasCaster = false;
                for (uint32 i = 0; i < MAX_ITEM_PROTO_STATS; ++i)
                {
                    if (!proto->ItemStat[i].ItemStatValue)
                    {
                        continue;
                    }

                    switch (proto->ItemStat[i].ItemStatType)
                    {
                        case ITEM_MOD_STRENGTH:
                        case ITEM_MOD_AGILITY:   hasPhysical = true; break;
                        case ITEM_MOD_INTELLECT:
                        case ITEM_MOD_SPIRIT:    hasCaster = true; break;
                        default: break;
                    }
                }

                if ((physical && hasCaster && !hasPhysical) || (caster && hasPhysical && !hasCaster))
                {
                    continue;
                }

                candidates.push_back(entry.first);
            }

            if (!candidates.empty())
            {
                return candidates[urand(0, (uint32)candidates.size() - 1)];
            }
        }

        return 0;
    }

    // Bonus enchantments live in the last random-property slot, so the normal enchanting slot stays free
    static const EnchantmentSlot BAG_ENCHANT_SLOT = PROP_ENCHANTMENT_SLOT_3;

    void RenownModule::GiveItem(Player* player, uint32 itemId, const std::string& subject, uint32 enchantId)
    {
        ItemPosCountVec dest;
        if (player->CanStoreNewItem(INVENTORY_SLOT_BAG_0, NULL_SLOT, dest, itemId, 1) == EQUIP_ERR_OK)
        {
            if (Item* item = player->StoreNewItem(dest, itemId, true, Item::GenerateItemRandomPropertyId(itemId)))
            {
                if (enchantId)
                {
                    item->SetEnchantment(BAG_ENCHANT_SLOT, enchantId, 0, 0);
                }
                return;
            }
        }

        // Bags full: send it by mail
        if (Item* item = Item::CreateItem(itemId, 1, player))
        {
            if (const int32 randomProperty = Item::GenerateItemRandomPropertyId(itemId))
            {
                item->SetItemRandomProperties(randomProperty);
            }
            if (enchantId)
            {
                item->SetEnchantment(BAG_ENCHANT_SLOT, enchantId, 0, 0);
            }

            CharacterDatabase.BeginTransaction();
            item->SaveToDB();
            CharacterDatabase.CommitTransaction();
            MailDraft(subject, "Your bags were full, so your loot bag reward was sent by mail.").AddItem(item).SendMailTo(player, MailSender(player, MAIL_STATIONERY_GM), MAIL_CHECK_MASK_COPIED);
            ChatHandler(player).PSendSysMessage("|cffffd100[Renown]|r Your bags are full, the item was sent to your mailbox.");
        }
    }

    uint32 RenownModule::RollBagEnchant(Player* player, uint32 itemId, BagType bag) const
    {
        ItemPrototype const* proto = ObjectMgr::GetItemPrototype(itemId);
        if (!proto || !player || (proto->Class != ITEM_CLASS_WEAPON && proto->Class != ITEM_CLASS_ARMOR))
        {
            return 0;
        }

        // Chance and size by bag: green 25% minor, blue 50%, purple always, gold always and bigger
        static const uint32 chance[] = { 100, 100, 50, 25 };
        static const float scale[] = { 1.2f, 1.0f, 0.85f, 0.6f };
        if (urand(1, 100) > chance[bag])
        {
            return 0;
        }

        // Rare weapon procs: purple 10%, gold 25% (melee weapons only)
        const bool melee = proto->Class == ITEM_CLASS_WEAPON && proto->SubClass != ITEM_SUBCLASS_WEAPON_BOW &&
                           proto->SubClass != ITEM_SUBCLASS_WEAPON_GUN && proto->SubClass != ITEM_SUBCLASS_WEAPON_CROSSBOW &&
                           proto->SubClass != ITEM_SUBCLASS_WEAPON_WAND && proto->SubClass != ITEM_SUBCLASS_WEAPON_THROWN;
        const uint32 procChance = bag == BAG_GOLD ? 25 : (bag == BAG_PURPLE ? 10 : 0);
        if (melee && procChance && urand(1, 100) <= procChance)
        {
            const uint8 cls = player->getClass();
            const bool caster = cls == CLASS_MAGE || cls == CLASS_PRIEST || cls == CLASS_WARLOCK;
            if (caster)
            {
                return 2504;                                   // Spell Damage +30
            }
            static const uint32 procs[] = { 1900, 803, 1898, 1894 };   // Crusader, Fiery Weapon, Lifestealing, Icy Weapon
            return procs[urand(0, 3)];
        }

        // Stat bonus sized by item level
        int32 value = int32(std::round(std::max<uint32>(proto->ItemLevel, 6) / 6.0f * scale[bag]));
        value = std::max<int32>(1, std::min<int32>(30, value + irand(-1, 1)));

        // Spell item enchantment ids for +1..+30 of each stat (the random-suffix enchantments of the client)
        static const uint32 STR[] = { 68, 69, 70, 106, 107, 108, 109, 352, 357, 362, 367, 372, 410, 412, 684, 1043, 1044, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1056, 1057 };
        static const uint32 AGI[] = { 74, 75, 76, 90, 91, 92, 93, 343, 349, 358, 363, 368, 403, 404, 883, 983, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107 };
        static const uint32 STA[] = { 71, 72, 73, 102, 103, 104, 105, 353, 356, 361, 366, 371, 409, 411, 1068, 1069, 1070, 1071, 1072, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083 };
        static const uint32 INT[] = { 79, 80, 81, 94, 95, 96, 97, 350, 354, 359, 364, 369, 405, 406, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 1133 };
        static const uint32 SPI[] = { 82, 83, 84, 98, 99, 100, 101, 351, 355, 360, 365, 370, 407, 408, 1144, 1145, 1146, 1147, 1148, 1149, 1150, 1151, 1152, 1153, 1154, 1155, 1156, 1157, 1158, 1159 };

        // Stats that fit the class: first 50%, second 30%, third 20%
        const uint32* pool[3];
        switch (player->getClass())
        {
            case CLASS_WARRIOR: pool[0] = STR; pool[1] = STA; pool[2] = AGI; break;
            case CLASS_PALADIN: pool[0] = STR; pool[1] = STA; pool[2] = INT; break;
            case CLASS_HUNTER:  pool[0] = AGI; pool[1] = STA; pool[2] = INT; break;
            case CLASS_ROGUE:   pool[0] = AGI; pool[1] = STA; pool[2] = STR; break;
            case CLASS_DRUID:
            case CLASS_SHAMAN:  pool[0] = INT; pool[1] = STA; pool[2] = AGI; break;
            default:            pool[0] = INT; pool[1] = STA; pool[2] = SPI; break;
        }
        const uint32 roll = urand(1, 100);
        const uint32* table = roll <= 50 ? pool[0] : (roll <= 80 ? pool[1] : pool[2]);
        return table[value - 1];
    }

    void RenownModule::RollKillBags(Player* killer, Player* victim, const std::vector<uint32>& contributors)
    {
        const RenownModuleConfig* config = GetConfig();
        if (!config->lootBags || !config->lootBagKillChance || !killer || !victim || killer->InBattleGround())
        {
            return;
        }

        const uint32 victimId = victim->GetObjectGuid().GetCounter();
        const time_t now = time(nullptr);
        for (uint32 id : contributors)
        {
            Player* looter = id == killer->GetObjectGuid().GetCounter() ? killer : sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, id));
            if (!looter || !looter->isRealPlayer() || !looter->IsInWorld() || looter->GetMap() != killer->GetMap() ||
                    looter->InBattleGround() || looter->GetTeam() == victim->GetTeam() ||
                    MaNGOS::XP::IsTrivialLevelDifference(looter->GetLevel(), victim->GetLevel()))
            {
                continue;
            }

            // No farming the same victim: one roll per looter and victim every 5 minutes
            {
                std::lock_guard<std::mutex> lock(m_killBagMutex);
                time_t& last = m_killBagLast[(uint64(id) << 32) | victimId];
                if (now - last < 5 * MINUTE)
                {
                    continue;
                }
                last = now;
                if (m_killBagLast.size() > 20000)
                {
                    m_killBagLast.clear();
                }
            }

            if (urand(1, 100) > config->lootBagKillChance)
            {
                continue;
            }

            const uint32 roll = urand(1, 100);
            GiveLootBag(looter, roll <= 80 ? BAG_GREEN : (roll <= 98 ? BAG_BLUE : BAG_PURPLE));
        }
    }

    void RenownModule::GiveLootBag(Player* player, BagType bag)
    {
        const RenownModuleConfig* config = GetConfig();
        static const char* names[] = { "|cffff8000Gold Loot Bag|r", "|cffa335eePurple Loot Bag|r", "|cff0070ddBlue Loot Bag|r", "|cff1eff00Green Loot Bag|r" };
        const uint32 points[] = { config->lootBagPointsGold, config->lootBagPointsPurple, config->lootBagPointsBlue, config->lootBagPointsGreen };
        const uint32 chances[] = { config->lootBagItemChanceGold, config->lootBagItemChancePurple, config->lootBagItemChanceBlue, 100 };

        std::ostringstream message;
        message << "|cffffd100[Renown]|r You won a " << names[bag] << "!";

        uint32 itemId = 0, dungeon = 0;
        if (urand(1, 100) <= chances[bag])
        {
            if (config->lootBagDungeonLoot)
            {
                itemId = PickDungeonItem(player, bag, dungeon);
            }

            if (!itemId)
            {
                itemId = PickRewardItem(player);
            }
        }

        uint32 renown = points[bag];
        if (itemId)
        {
            ItemPrototype const* proto = ObjectMgr::GetItemPrototype(itemId);
            static const char* qualityColor[] = { "ff9d9d9d", "ffffffff", "ff1eff00", "ff0070dd", "ffa335ee", "ffff8000" };
            const uint32 quality = proto ? std::min<uint32>(proto->Quality, 5) : 1;
            message << " It holds |c" << qualityColor[quality] << "|Hitem:" << itemId << ":0:0:0|h[" << (proto ? proto->Name1 : "item") << "]|h|r";
            const uint32 enchantId = config->lootBagEnchants ? RollBagEnchant(player, itemId, bag) : 0;
            if (enchantId)
            {
                SpellItemEnchantmentEntry const* ench = sSpellItemEnchantmentStore.LookupEntry(enchantId);
                if (ench && ench->description[0] && *ench->description[0])
                {
                    message << " |cff1eff00(" << ench->description[0] << ")|r";
                }
            }
            if (dungeon)
            {
                message << " from " << DungeonName(dungeon);
            }
            GiveItem(player, itemId, "Loot bag reward", enchantId);
            message << " and " << renown << " Renown.";
        }
        else
        {
            if (urand(1, 100) <= chances[bag])
            {
                renown += renown / 2;   // no fitting gear unlocked yet: extra Renown instead
            }

            message << " It holds " << renown << " Renown.";
        }

        ChatHandler(player).PSendSysMessage("%s", message.str().c_str());
        AddRenown(player, renown, false);
    }

    void RenownModule::AwardLootBags(BattleGround* battleground, uint32 winnerTeam)
    {
        if (!GetConfig()->lootBags)
        {
            return;
        }

        struct Entry { Player* player; uint32 score; bool won; };
        std::vector<Entry> winners;
        std::vector<Entry> losers;
        for (const auto& entry : battleground->GetPlayers())
        {
            Player* player = sObjectMgr.GetPlayer(entry.first);
            if (!player)
            {
                continue;
            }

            const RenownData data = GetData(player->GetObjectGuid().GetCounter());
            if (data.bgEarned == 0)
            {
                continue;   // no contribution, no bag
            }

            // Contribution with a small random factor, like the Warhammer roll
            const uint32 score = data.bgEarned * urand(80, 120);
            const bool won = winnerTeam != TEAM_NONE && (uint32)entry.second.playerTeam == winnerTeam;
            (won ? winners : losers).push_back({ player, score, won });
        }

        auto byScore = [](const Entry& a, const Entry& b) { return a.score > b.score; };
        std::sort(winners.begin(), winners.end(), byScore);
        std::sort(losers.begin(), losers.end(), byScore);

        std::ostringstream summary;
        summary << "|cffffd100[Renown] Loot bags:|r";
        bool any = false;

        auto give = [&](const Entry& entry, BagType bag)
        {
            static const char* colors[] = { "|cffff8000Gold|r", "|cffa335eePurple|r", "|cff0070ddBlue|r" };
            summary << " " << entry.player->GetName() << " (" << colors[bag] << ")";
            any = true;
            if (entry.player->isRealPlayer())
            {
                GiveLootBag(entry.player, bag);
            }
        };

        for (size_t i = 0; i < winners.size() && i < 6; ++i)
        {
            give(winners[i], i == 0 ? BAG_GOLD : (i < 3 ? BAG_PURPLE : BAG_BLUE));
        }

        for (size_t i = 0; i < losers.size() && i < 3; ++i)
        {
            give(losers[i], i == 0 ? BAG_PURPLE : BAG_BLUE);
        }

        if (any)
        {
            for (const auto& entry : battleground->GetPlayers())
            {
                Player* player = sObjectMgr.GetPlayer(entry.first);
                if (player && player->isRealPlayer())
                {
                    ChatHandler(player).PSendSysMessage("%s", summary.str().c_str());
                }
            }
        }
    }

    // ------------------------------------------------------------------ streaks, bounties, assists
    void RenownModule::Announce(Player* source, const std::string& text) const
    {
        if (!source || !source->IsInWorld())
        {
            return;
        }

        const uint32 zone = source->GetZoneId();
        for (const auto& ref : source->GetMap()->GetPlayers())
        {
            Player* player = ref.getSource();
            if (player && player->isRealPlayer() && player->GetZoneId() == zone)
            {
                ChatHandler(player).PSendSysMessage("%s", text.c_str());
            }
        }
    }

    void RenownModule::RecordRecent(std::unordered_map<uint32, std::vector<std::pair<uint32, time_t>>>& map, uint32 key, uint32 who, time_t now)
    {
        std::vector<std::pair<uint32, time_t>>& list = map[key];
        const time_t window = (time_t)GetConfig()->assistWindow;
        list.erase(std::remove_if(list.begin(), list.end(), [&](const std::pair<uint32, time_t>& e) { return now - e.second > window || e.first == who; }), list.end());
        if (list.size() < 40)
        {
            list.emplace_back(who, now);
        }
    }

    void RenownModule::OnDealDamage(Unit* unit, Unit* victim, uint32 health, uint32 damage)
    {
        if (victim && damage)
            TalentsOnDealDamage(unit, victim, damage);

        if (!unit || !victim || damage == 0 || victim->GetTypeId() != TYPEID_PLAYER || !GetConfig()->enabled)
        {
            return;
        }

        Player* attacker = unit->GetBeneficiaryPlayer();
        if (!attacker || attacker == victim || attacker->GetTeam() == ((Player*)victim)->GetTeam())
        {
            return;
        }

        std::lock_guard<std::mutex> lock(m_combatMutex);
        RecordRecent(m_attackers, victim->GetObjectGuid().GetCounter(), attacker->GetObjectGuid().GetCounter(), time(nullptr));
    }

    void RenownModule::OnDealHeal(Unit* unit, Unit* victim, int32 gain, uint32 addHealth)
    {
        if (!unit || !victim || gain <= 0 || unit == victim || victim->GetTypeId() != TYPEID_PLAYER || !GetConfig()->enabled)
        {
            return;
        }

        Player* healer = unit->GetBeneficiaryPlayer();
        if (!healer || healer == victim || healer->GetTeam() != ((Player*)victim)->GetTeam() || !victim->IsInCombat())
        {
            return;
        }

        std::lock_guard<std::mutex> lock(m_combatMutex);
        RecordRecent(m_healers, victim->GetObjectGuid().GetCounter(), healer->GetObjectGuid().GetCounter(), time(nullptr));
    }

    void RenownModule::OnDeath(Player* victim, Unit* killer)
    {
        if (!victim || !killer || !GetConfig()->enabled)
        {
            return;
        }

        Player* player = killer->GetBeneficiaryPlayer();
        const uint32 victimId = victim->GetObjectGuid().GetCounter();

        // Barrens domination: enemy kills on the front
        if (player && player != victim && player->GetTeam() != victim->GetTeam() && victim->IsInWorld() &&
                victim->GetMapId() == 1 && victim->GetZoneId() == 17 && victim->GetLevel() <= GetConfig()->rvrMaxLevel)
        {
            RvRDominate(player->GetTeam(), player->isRealPlayer() ? 100 : 50);
        }

        // Any death ends the victim's streak
        uint32 oldStreak = 0;
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            auto itr = m_data.find(victimId);
            if (itr != m_data.end())
            {
                oldStreak = itr->second.streak;
                itr->second.streak = 0;
            }
        }

        if (!player || player == victim || player->GetTeam() == victim->GetTeam() ||
            MaNGOS::XP::IsTrivialLevelDifference(player->GetLevel(), victim->GetLevel()))
        {
            std::lock_guard<std::mutex> lock(m_combatMutex);
            m_attackers.erase(victimId);
            return;
        }

        const RenownModuleConfig* config = GetConfig();
        uint32 newStreak = 0;
        if (config->streaks)
        {
            // Bounty for ending a streak
            if (oldStreak >= config->bountyMinStreak && config->bountyPerKill)
            {
                const uint32 bounty = std::min(config->bountyPerKill * oldStreak, config->bountyMax);
                std::ostringstream text;
                text << "|cffff4040[Bounty]|r " << player->GetName() << " ended " << victim->GetName() << "'s killing spree of "
                     << oldStreak << " and claims " << bounty << " Renown!";
                Announce(player, text.str());
                AddRenown(player, bounty);
            }

            uint32 streak = 0;
            {
                std::lock_guard<std::mutex> lock(m_dataMutex);
                streak = ++m_data[player->GetObjectGuid().GetCounter()].streak;
            }
            newStreak = streak;

            if (streak >= 3)
            {
                AddRenown(player, std::min(config->streakBonusPerKill * streak, config->streakBonusMax));

                const char* label = nullptr;
                switch (streak)
                {
                    case 3:  label = "is on a killing spree"; break;
                    case 5:  label = "is on a rampage"; break;
                    case 10: label = "is unstoppable"; break;
                    case 15: label = "is godlike"; break;
                    default: if (streak >= 20 && streak % 5 == 0) label = "is legendary"; break;
                }

                if (label)
                {
                    std::ostringstream text;
                    text << "|cffff8000[Streak]|r " << player->GetName() << " " << label << " (" << streak << " kills)!";
                    if (streak >= config->bountyMinStreak)
                    {
                        text << " Bounty: " << std::min(config->bountyPerKill * streak, config->bountyMax) << " Renown.";
                    }

                    Announce(player, text.str());
                }
            }
        }

        // Announcer, nemesis, heroes, sessions, MVP tally
        FrontOnKill(player, victim, oldStreak, newStreak);

        // War board credits for kills on the front
        if (RvRIsMember(player->GetObjectGuid().GetCounter()))
        {
            QuestCredit(player, 190822);           // enemy player defeated
            if (oldStreak >= 3)
            {
                QuestCredit(player, 190824);       // killing spree ended
            }

            if (m_rvrObjectives.size() == 3)
            {
                const float dx = victim->GetPositionX() - m_rvrObjectives[1].x, dy = victim->GetPositionY() - m_rvrObjectives[1].y;
                if (dx * dx + dy * dy <= 60.0f * 60.0f)
                {
                    QuestCredit(player, 190828);   // fight at the Oasis
                }
            }
        }

        // RvR lake: killing an enemy near an objective your side holds
        if (config->rvrDefendPoints && RvRIsMember(player->GetObjectGuid().GetCounter()))
        {
            for (const RvRObjective& o : m_rvrObjectives)
            {
                const float dx = victim->GetPositionX() - o.x, dy = victim->GetPositionY() - o.y;
                if (o.owner == player->GetTeam() && dx * dx + dy * dy <= 40.0f * 40.0f)
                {
                    AddRenown(player, config->rvrDefendPoints);
                    QuestCredit(player, 190821);   // war board: defend
                    break;
                }
            }
        }

        // Healing assists: healers who kept any of the attackers alive
        std::vector<uint32> contributors = { player->GetObjectGuid().GetCounter() };
        if (config->pointsHealAssist)
        {
            std::vector<uint32> healers;
            {
                std::lock_guard<std::mutex> lock(m_combatMutex);
                const time_t now = time(nullptr);
                std::vector<uint32> attackers = { player->GetObjectGuid().GetCounter() };
                auto itr = m_attackers.find(victimId);
                if (itr != m_attackers.end())
                {
                    for (const auto& e : itr->second)
                    {
                        if (now - e.second <= (time_t)config->assistWindow && e.first != attackers[0])
                        {
                            attackers.push_back(e.first);
                        }
                    }

                    m_attackers.erase(itr);
                }
                contributors = attackers;

                for (uint32 attacker : attackers)
                {
                    auto h = m_healers.find(attacker);
                    if (h == m_healers.end())
                    {
                        continue;
                    }

                    for (const auto& e : h->second)
                    {
                        if (now - e.second <= (time_t)config->assistWindow &&
                            std::find(attackers.begin(), attackers.end(), e.first) == attackers.end() &&
                            std::find(healers.begin(), healers.end(), e.first) == healers.end())
                        {
                            healers.push_back(e.first);
                        }
                    }
                }
            }

            for (uint32 healerId : healers)
            {
                Player* healer = sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, healerId));
                if (healer && healer->IsInWorld() && healer->GetMap() == player->GetMap())
                {
                    if (RvRIsMember(healerId))
                    {
                        QuestCredit(healer, 190823);   // war board: healing assist
                    }

                    AddRenown(healer, config->pointsHealAssist);
                    FrontOnHealAssist(healer);
                }
            }

            contributors.insert(contributors.end(), healers.begin(), healers.end());
        }

        // Loot bags for enemy player kills on the fronts and in the open world
        RollKillBags(player, victim, contributors);
    }

    bool RenownModule::OnPreGossipHello(Player* player, Creature* creature)
    {
        if (!player || !creature || !GetConfig()->enabled)
        {
            return false;
        }

        const std::vector<uint32>& npcs = GetConfig()->quartermasters;
        if (std::find(npcs.begin(), npcs.end(), creature->GetEntry()) != npcs.end())
        {
            SendStatus(player, player);

            const RenownData data = GetData(player->GetObjectGuid().GetCounter());
            GrantMissingInsignias(player, data.rank, false);
        }

        // Never replace the normal gossip menu
        return false;
    }

    bool RenownModule::CanEarnRenown(const Player* player) const
    {
        if (!player || !GetConfig()->enabled)
        {
            return false;
        }

        return player->isRealPlayer() || GetConfig()->botsEarnRenown;
    }

    RenownModule::RenownData RenownModule::GetData(uint32 playerId)
    {
        std::lock_guard<std::mutex> lock(m_dataMutex);
        auto it = m_data.find(playerId);
        return it != m_data.end() ? it->second : RenownData();
    }

    void RenownModule::AddRenown(Player* player, uint32 basePoints, bool applyRate)
    {
        if (!CanEarnRenown(player) || basePoints == 0)
        {
            return;
        }

        uint32 gained = basePoints;
        if (applyRate)
        {
            gained = (uint32)(basePoints * GetConfig()->rate + 0.5f);
            gained = FrontRenownBonus(player, gained);
        }

        if (gained == 0)
        {
            return;
        }

        const uint32 playerId = player->GetObjectGuid().GetCounter();
        uint32 oldRank = 1;
        uint32 newRank = 1;
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            RenownData& data = m_data[playerId];
            const uint64 total = (uint64)data.points + gained;
            data.points = total > 4000000000ULL ? 4000000000U : (uint32)total;
            const uint64 spendable = (uint64)data.spendable + gained;
            data.spendable = spendable > 4000000000ULL ? 4000000000U : (uint32)spendable;
            if (player->InBattleGround())
            {
                data.bgEarned += gained;
            }

            if (RvRIsMember(playerId))
            {
                data.lakeEarned += gained;
            }
            oldRank = data.rank;
            newRank = GetConfig()->GetRankForPoints(data.points);
            data.rank = newRank;
        }

        FrontOnRenown(player, gained);

        if (newRank != oldRank)
        {
            OnRankChanged(player, oldRank, newRank);
        }

        // PvP experience: Renown from fighting (applyRate) also levels the character, so PvP alone is a way to level.
        // Quests and loot bags pass applyRate = false and give their own rewards.
        if (applyRate && player->isRealPlayer() && GetConfig()->pvpXPPercent)
        {
            const uint64 xp = (uint64)sObjectMgr.GetXPForLevel(player->GetLevel()) * gained * GetConfig()->pvpXPPercent / 10000;
            if (xp)
            {
                player->GiveXP((uint32)std::min<uint64>(xp, 4000000000ULL), nullptr);
            }
        }

        SendAddonUpdate(player);
    }

    void RenownModule::SetRenownPoints(Player* player, uint32 points)
    {
        if (!player)
        {
            return;
        }

        const uint32 playerId = player->GetObjectGuid().GetCounter();
        uint32 oldRank = 1;
        uint32 newRank = 1;
        RenownData saved;
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            RenownData& data = m_data[playerId];
            if (points > data.points)
            {
                data.spendable += points - data.points;   // raising renown also gives the difference to spend
            }

            data.points = points;
            oldRank = data.rank;
            newRank = GetConfig()->GetRankForPoints(points);
            data.rank = newRank;
            saved = data;
        }

        SaveData(playerId, saved);

        if (newRank != oldRank)
        {
            OnRankChanged(player, oldRank, newRank);
        }

        SendAddonUpdate(player);
    }

    void RenownModule::OnRankChanged(Player* player, uint32 oldRank, uint32 newRank)
    {
        // Bots rank up silently
        if (!player->isRealPlayer() || newRank <= oldRank)
        {
            return;
        }

        const std::string title = GetRankTitle(newRank);
        ChatHandler(player).PSendSysMessage("|cffffd100[Renown]|r You have reached |cff00ff00Renown Rank %u|r: %s!", newRank, title.c_str());

        const uint32 every = GetConfig()->announceEvery;
        if (every > 0)
        {
            for (uint32 rank = oldRank + 1; rank <= newRank; ++rank)
            {
                if (rank % every == 0 || rank == GetConfig()->maxRank)
                {
                    std::ostringstream message;
                    message << "|cffffd100[Renown]|r " << player->GetName() << " has reached Renown Rank " << rank << " (" << GetRankTitle(rank) << ")!";

                    WorldPacket data;
                    ChatHandler::BuildChatPacket(data, CHAT_MSG_SYSTEM, message.str().c_str());
                    sWorld.SendGlobalMessage(data);
                    break;
                }
            }
        }

        GrantMissingInsignias(player, newRank, false);
    }

    void RenownModule::GrantMissingInsignias(Player* player, uint32 rank, bool silent)
    {
        if (!player || !player->isRealPlayer())
        {
            return;
        }

        const std::vector<uint32>& ranks = GetConfig()->insigniaRanks;
        const std::vector<uint32>& items = GetConfig()->insigniaItems;
        for (size_t i = 0; i < ranks.size() && i < items.size(); ++i)
        {
            if (rank < ranks[i] || !items[i] || player->HasItemCount(items[i], 1, true))
            {
                continue;
            }

            if (!ObjectMgr::GetItemPrototype(items[i]))
            {
                continue;
            }

            if (player->StoreNewItemInBestSlots(items[i], 1))
            {
                if (!silent)
                {
                    ChatHandler(player).PSendSysMessage("|cffffd100[Renown]|r You earned a new Renown Insignia. More rewards are unlocked at the Battleground Quartermaster.");
                }
            }
            else if (!silent)
            {
                ChatHandler(player).PSendSysMessage("|cffffd100[Renown]|r Your bags are full. Talk to a Battleground Quartermaster to collect your Renown Insignia.");
            }
        }
    }

    void RenownModule::SendStatus(Player* target, Player* about) const
    {
        if (!target || !about)
        {
            return;
        }

        RenownData data;
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            auto it = m_data.find(about->GetObjectGuid().GetCounter());
            if (it != m_data.end())
            {
                data = it->second;
            }
        }

        const RenownModuleConfig* config = GetConfig();
        ChatHandler handler(target);
        if (data.rank >= config->maxRank)
        {
            handler.PSendSysMessage("|cffffd100[Renown]|r %s: Renown Rank %u (%s), %u renown. Maximum rank reached!",
                about->GetName(), data.rank, GetRankTitle(data.rank).c_str(), data.points);
        }
        else
        {
            const uint32 current = config->GetPointsForRank(data.rank);
            const uint32 next = config->GetPointsForRank(data.rank + 1);
            handler.PSendSysMessage("|cffffd100[Renown]|r %s: Renown Rank %u (%s). %u / %u renown to rank %u.",
                about->GetName(), data.rank, GetRankTitle(data.rank).c_str(), data.points - current, next - current, data.rank + 1);
        }

        handler.PSendSysMessage("|cffffd100[Renown]|r %u Renown points to spend.", data.spendable);
    }

    void RenownModule::SendAddonUpdate(Player* player) const
    {
        if (!player || !player->isRealPlayer() || !player->GetSession())
        {
            return;
        }

        RenownData data;
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            auto it = m_data.find(player->GetObjectGuid().GetCounter());
            if (it != m_data.end())
            {
                data = it->second;
            }
        }

        const RenownModuleConfig* config = GetConfig();
        const bool maxed = data.rank >= config->maxRank;
        const uint32 current = config->GetPointsForRank(data.rank);
        const uint32 next = maxed ? current : config->GetPointsForRank(data.rank + 1);

        // Format: RENOWN<tab>rank:progress:needed:nextRank:total:maxed:spendable:title
        std::ostringstream message;
        message << "RENOWN\t" << data.rank << ":" << (data.points - current) << ":" << (next - current) << ":"
                << (maxed ? data.rank : data.rank + 1) << ":" << data.points << ":" << (maxed ? 1 : 0) << ":"
                << data.spendable << ":" << GetRankTitle(data.rank);

        // A party addon message from the player to themself: the 1.12 client raises CHAT_MSG_ADDON and shows nothing in chat
        WorldPacket packet;
        ChatHandler::BuildChatPacket(packet, CHAT_MSG_PARTY, message.str().c_str(), LANG_ADDON, CHAT_TAG_NONE, player->GetObjectGuid(), player->GetName());
        player->GetSession()->SendPacket(packet);
    }

    std::string RenownModule::GetRankTitle(uint32 rank)
    {
        if (rank >= 40) return "Legend";
        if (rank >= 35) return "Conqueror";
        if (rank >= 30) return "Warlord";
        if (rank >= 25) return "Champion";
        if (rank >= 20) return "Sergeant";
        if (rank >= 15) return "Veteran";
        if (rank >= 10) return "Soldier";
        if (rank >= 5)  return "Skirmisher";
        return "Recruit";
    }

    std::vector<ModuleChatCommand>* RenownModule::GetCommandTable()
    {
        static std::vector<ModuleChatCommand> commandTable =
        {
            { "info", std::bind(&RenownModule::HandleInfoCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "top", std::bind(&RenownModule::HandleTopCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "sync", std::bind(&RenownModule::HandleSyncCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "add", std::bind(&RenownModule::HandleAddCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_GAMEMASTER },
            { "set", std::bind(&RenownModule::HandleSetCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_GAMEMASTER },
            { "give", std::bind(&RenownModule::HandleGiveCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_GAMEMASTER },
            { "queue", std::bind(&RenownModule::HandleQueueCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "rvr", std::bind(&RenownModule::HandleRvRCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "mount", std::bind(&RenownModule::HandleMountCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "t4", std::bind(&RenownModule::HandleT4Command, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "warband", std::bind(&RenownModule::HandleWarbandCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "session", std::bind(&RenownModule::HandleSessionCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_PLAYER },
            { "reload", std::bind(&RenownModule::HandleReloadCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_ADMINISTRATOR }
        };

        return &commandTable;
    }

    Player* RenownModule::ResolveCommandTarget(WorldSession* session, const std::string& name) const
    {
        if (!name.empty())
        {
            return ObjectMgr::GetPlayer(name.c_str());
        }

        Player* self = session ? session->GetPlayer() : nullptr;
        if (!self)
        {
            return nullptr;
        }

        const ObjectGuid selection = self->GetSelectionGuid();
        if (selection.IsPlayer())
        {
            if (Player* selected = ObjectMgr::GetPlayer(selection))
            {
                return selected;
            }
        }

        return self;
    }

    bool RenownModule::HandleInfoCommand(WorldSession* session, const std::string& args)
    {
        Player* self = session ? session->GetPlayer() : nullptr;
        if (!self || !GetConfig()->enabled)
        {
            return false;
        }

        // Players see their own renown; GMs can also look at their target or a named player
        Player* about = self;
        if (session->GetSecurity() >= SEC_GAMEMASTER)
        {
            about = ResolveCommandTarget(session, args);
        }
        else if (!args.empty())
        {
            about = ObjectMgr::GetPlayer(args.c_str());
        }

        SendStatus(self, about ? about : self);
        SendAddonUpdate(self);
        return true;
    }

    bool RenownModule::HandleSyncCommand(WorldSession* session, const std::string& args)
    {
        Player* self = session ? session->GetPlayer() : nullptr;
        if (!self || !GetConfig()->enabled)
        {
            return false;
        }

        // Silent: only the addon data is sent
        SendAddonUpdate(self);
        SendAddonPrices(self);
        return true;
    }

    bool RenownModule::HandleTopCommand(WorldSession* session, const std::string& args)
    {
        Player* self = session ? session->GetPlayer() : nullptr;
        if (!self || !GetConfig()->enabled)
        {
            return false;
        }

        // Make sure online players' latest renown is reflected
        OnSaveToDB(self);

        ChatHandler handler(self);
        handler.PSendSysMessage("|cffffd100[Renown]|r Top 10 renown:");
        auto result = CharacterDatabase.Query(
            "SELECT c.`name`, r.`rank`, r.`points` FROM `custom_renown` r JOIN `characters` c ON c.`guid` = r.`guid` ORDER BY r.`points` DESC LIMIT 10");
        if (result)
        {
            uint32 position = 1;
            do
            {
                Field* fields = result->Fetch();
                const std::string name = fields[0].GetCppString();
                const uint32 rank = fields[1].GetUInt32();
                const uint32 points = fields[2].GetUInt32();
                handler.PSendSysMessage("%u. %s - Rank %u (%s), %u renown", position++, name.c_str(), rank, GetRankTitle(rank).c_str(), points);
            }
            while (result->NextRow());
        }

        return true;
    }

    bool RenownModule::HandleAddCommand(WorldSession* session, const std::string& args)
    {
        Player* self = session ? session->GetPlayer() : nullptr;
        if (!self || !GetConfig()->enabled)
        {
            return false;
        }

        const std::vector<std::string> arguments = helper::SplitString(args, " ");
        if (arguments.empty() || !helper::IsValidNumberString(arguments[0]))
        {
            ChatHandler(self).PSendSysMessage("Usage: .renown add <points> [character name]");
            return true;
        }

        Player* target = ResolveCommandTarget(session, arguments.size() > 1 ? arguments[1] : "");
        if (!target)
        {
            ChatHandler(self).PSendSysMessage("That character is not online.");
            return true;
        }

        const long amount = std::strtol(arguments[0].c_str(), nullptr, 10);
        const RenownData data = GetData(target->GetObjectGuid().GetCounter());
        const long total = std::max<long>(0, (long)data.points + amount);
        SetRenownPoints(target, (uint32)total);
        SendStatus(self, target);
        return true;
    }

    bool RenownModule::HandleSetCommand(WorldSession* session, const std::string& args)
    {
        Player* self = session ? session->GetPlayer() : nullptr;
        if (!self || !GetConfig()->enabled)
        {
            return false;
        }

        const std::vector<std::string> arguments = helper::SplitString(args, " ");
        if (arguments.empty() || !helper::IsValidNumberString(arguments[0]))
        {
            ChatHandler(self).PSendSysMessage("Usage: .renown set <rank> [character name]");
            return true;
        }

        Player* target = ResolveCommandTarget(session, arguments.size() > 1 ? arguments[1] : "");
        if (!target)
        {
            ChatHandler(self).PSendSysMessage("That character is not online.");
            return true;
        }

        uint32 rank = (uint32)std::strtoul(arguments[0].c_str(), nullptr, 10);
        rank = std::max<uint32>(1, std::min<uint32>(rank, GetConfig()->maxRank));
        SetRenownPoints(target, GetConfig()->GetPointsForRank(rank));
        SendStatus(self, target);
        return true;
    }
}
