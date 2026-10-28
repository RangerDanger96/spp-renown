#include "RenownModule.h"

#include "BattleGround/BattleGround.h"
#include "Chat/Chat.h"
#include "Database/DatabaseEnv.h"
#include "Entities/Creature.h"
#include "Entities/Player.h"
#include "Globals/ObjectMgr.h"
#include "Log/Log.h"
#include "Server/WorldSession.h"
#include "Tools/Formulas.h"
#include "World/World.h"

#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <sstream>

namespace cmangos_module
{
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

        sLog.outString("Renown module initialized (max rank %u)", GetConfig()->maxRank);
    }

    void RenownModule::OnLoadFromDB(Player* player)
    {
        if (!player || !GetConfig()->enabled)
        {
            return;
        }

        const uint32 playerId = player->GetObjectGuid().GetCounter();

        RenownData data;
        auto result = CharacterDatabase.PQuery("SELECT `points` FROM `custom_renown` WHERE `guid` = '%u'", playerId);
        if (result)
        {
            Field* fields = result->Fetch();
            data.points = fields[0].GetUInt32();
        }

        data.rank = GetConfig()->GetRankForPoints(data.points);

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

        if (data.points > 0)
        {
            CharacterDatabase.PExecute("REPLACE INTO `custom_renown` (`guid`, `points`, `rank`) VALUES ('%u', '%u', '%u')", playerId, data.points, data.rank);
        }
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

        // Make sure the latest value is written before the cache entry goes away
        OnSaveToDB(player);

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
            oldRank = data.rank;
            newRank = GetConfig()->GetRankForPoints(data.points);
            data.rank = newRank;
        }

        if (newRank != oldRank)
        {
            OnRankChanged(player, oldRank, newRank);
        }
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
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            RenownData& data = m_data[playerId];
            data.points = points;
            oldRank = data.rank;
            newRank = GetConfig()->GetRankForPoints(points);
            data.rank = newRank;
        }

        CharacterDatabase.PExecute("REPLACE INTO `custom_renown` (`guid`, `points`, `rank`) VALUES ('%u', '%u', '%u')", playerId, points, newRank);

        if (newRank != oldRank)
        {
            OnRankChanged(player, oldRank, newRank);
        }
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
            { "add", std::bind(&RenownModule::HandleAddCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_GAMEMASTER },
            { "set", std::bind(&RenownModule::HandleSetCommand, this, std::placeholders::_1, std::placeholders::_2), SEC_GAMEMASTER }
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

        Player* about = ResolveCommandTarget(session, args);
        SendStatus(self, about ? about : self);
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
