// Barrens Front influence (Warhammer style): front activity fills a per-character influence bar with three
// reward tiers, claimed from the Rally Master at your faction's front camp. Tier 3 is the faction tabard.
#include "RenownModule.h"

#include "Entities/Player.h"
#include "Entities/Creature.h"
#include "Entities/GossipDef.h"
#include "Chat/Chat.h"
#include "Database/DatabaseEnv.h"
#include "Globals/ObjectMgr.h"
#include "Server/WorldPacket.h"

#include <sstream>

namespace cmangos_module
{
    namespace
    {
        const uint32 RALLY_ALLIANCE = 190806;
        const uint32 RALLY_HORDE = 190807;
        const uint32 TABARD_ALLIANCE = 191500;
        const uint32 TABARD_HORDE = 191501;
        const uint32 TIER_POINTS[3] = { 300, 900, 1800 };
        const uint32 ACTION_CLAIM = 100;    // + tier index
        const uint32 ACTION_INFO = 200;

        void SendInfAddon(Player* player, const std::string& message)
        {
            if (!player || !player->GetSession())
            {
                return;
            }

            WorldPacket packet;
            ChatHandler::BuildChatPacket(packet, CHAT_MSG_PARTY, message.c_str(), LANG_ADDON, CHAT_TAG_NONE, player->GetObjectGuid(), player->GetName());
            player->GetSession()->SendPacket(packet);
        }

        const char* CampName(Player* player)
        {
            return player->GetTeam() == ALLIANCE ? "Rally Master Thane at Northwatch Hold" : "Rally Master Grosk at the Crossroads";
        }
    }

    void RenownModule::InfluenceInit()
    {
        CharacterDatabase.DirectExecute(
            "CREATE TABLE IF NOT EXISTS `custom_renown_influence` ("
            "`guid` INT UNSIGNED NOT NULL COMMENT 'Character guid',"
            "`barrens` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Barrens Front influence',"
            "`claimed` TINYINT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Claimed reward tiers (bit mask)',"
            "PRIMARY KEY (`guid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Renown: front influence'");
    }

    void RenownModule::InfluenceLoad(Player* player)
    {
        const uint32 id = player->GetObjectGuid().GetCounter();
        InfluenceData data;
        if (auto result = CharacterDatabase.PQuery("SELECT `barrens`, `claimed` FROM `custom_renown_influence` WHERE `guid` = '%u'", id))
        {
            Field* fields = result->Fetch();
            data.points = fields[0].GetUInt32();
            data.claimed = fields[1].GetUInt8();
        }

        std::lock_guard<std::mutex> lock(m_influenceMutex);
        m_influence[id] = data;
    }

    void RenownModule::InfluenceSave(Player* player)
    {
        const uint32 id = player->GetObjectGuid().GetCounter();
        InfluenceData data;
        {
            std::lock_guard<std::mutex> lock(m_influenceMutex);
            auto itr = m_influence.find(id);
            if (itr == m_influence.end() || !itr->second.dirty)
            {
                return;
            }

            itr->second.dirty = false;
            data = itr->second;
        }

        CharacterDatabase.PExecute("REPLACE INTO `custom_renown_influence` (`guid`, `barrens`, `claimed`) VALUES ('%u', '%u', '%u')", id, data.points, uint32(data.claimed));
    }

    void RenownModule::InfluenceForget(uint32 playerId)
    {
        std::lock_guard<std::mutex> lock(m_influenceMutex);
        m_influence.erase(playerId);
    }

    void RenownModule::InfluenceAdd(Player* player, uint32 amount)
    {
        if (!player || !amount || !player->isRealPlayer() || !GetConfig()->rvrEnabled || player->GetLevel() > GetConfig()->rvrMaxLevel)
        {
            return;
        }

        const uint32 id = player->GetObjectGuid().GetCounter();
        uint32 before, after;
        {
            std::lock_guard<std::mutex> lock(m_influenceMutex);
            InfluenceData& data = m_influence[id];
            before = data.points;
            data.points = std::min<uint32>(TIER_POINTS[2], data.points + amount);
            after = data.points;
            data.dirty = data.dirty || after != before;
        }

        if (after == before)
        {
            return;
        }

        for (uint32 tier = 0; tier < 3; ++tier)
        {
            if (before < TIER_POINTS[tier] && after >= TIER_POINTS[tier])
            {
                ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r Influence tier %u reached! Claim your reward from %s.", tier + 1, CampName(player));
                std::ostringstream fx;
                fx << "RENOWNFX\tInfluence tier " << (tier + 1) << " reached!";
                SendInfAddon(player, fx.str());
            }
        }

        InfluenceSendStatus(player);
    }

    void RenownModule::InfluenceSendStatus(Player* player)
    {
        if (!player || !player->isRealPlayer())
        {
            return;
        }

        InfluenceData data;
        {
            std::lock_guard<std::mutex> lock(m_influenceMutex);
            auto itr = m_influence.find(player->GetObjectGuid().GetCounter());
            if (itr != m_influence.end())
            {
                data = itr->second;
            }
        }

        // RENOWNINF<tab>points/claimedMask/tier1/tier2/tier3
        std::ostringstream message;
        message << "RENOWNINF\t" << data.points << "/" << uint32(data.claimed) << "/" << TIER_POINTS[0] << "/" << TIER_POINTS[1] << "/" << TIER_POINTS[2];
        SendInfAddon(player, message.str());
    }

    bool RenownModule::InfluenceIsRallyMaster(const Creature* creature) const
    {
        return creature && (creature->GetEntry() == RALLY_ALLIANCE || creature->GetEntry() == RALLY_HORDE);
    }

    void RenownModule::InfluenceShowMenu(Player* player, Creature* creature)
    {
        InfluenceData data;
        {
            std::lock_guard<std::mutex> lock(m_influenceMutex);
            data = m_influence[player->GetObjectGuid().GetCounter()];
        }

        PlayerMenu* menu = player->GetPlayerMenu();
        menu->ClearMenus();

        std::ostringstream progress;
        uint32 next = 0;
        while (next < 3 && data.points >= TIER_POINTS[next]) ++next;
        progress << "Your influence: " << data.points << " / " << TIER_POINTS[2];
        if (next < 3)
        {
            progress << "  (tier " << (next + 1) << " at " << TIER_POINTS[next] << ")";
        }
        else
        {
            progress << "  (complete)";
        }
        menu->GetGossipMenu().AddMenuItem(GOSSIP_ICON_CHAT, progress.str(), 1, ACTION_INFO, "", false);

        static const char* rewards[3] = {
            "Claim tier 1: 150 Renown and field supplies",
            "Claim tier 2: a Purple Loot Bag",
            nullptr };
        for (uint32 tier = 0; tier < 3; ++tier)
        {
            if (data.points >= TIER_POINTS[tier] && !(data.claimed & (1 << tier)))
            {
                std::string text = rewards[tier] ? rewards[tier] :
                    (player->GetTeam() == ALLIANCE ? "Claim tier 3: Tabard of the Barrens Vanguard" : "Claim tier 3: Tabard of the Barrens Warband");
                menu->GetGossipMenu().AddMenuItem(GOSSIP_ICON_VENDOR, text, 1, ACTION_CLAIM + tier, "", false);
            }
        }

        menu->GetGossipMenu().AddMenuItem(GOSSIP_ICON_TALK, "How do I earn influence?", 1, ACTION_INFO + 1, "", false);
        menu->SendGossipMenu(creature->GetEntry(), creature->GetObjectGuid());   // npc_text uses the creature entry as id
        InfluenceSendStatus(player);
    }

    bool RenownModule::InfluenceGossipSelect(Player* player, Creature* creature, uint32 action)
    {
        if (!InfluenceIsRallyMaster(creature))
        {
            return false;
        }

        if (action == ACTION_INFO + 1)
        {
            ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r Influence comes from the front (levels 1-%u): capturing objectives, defeating enemies, "
                                                "holding objectives, war board orders and winning the front. Tiers at %u, %u and %u.",
                                                GetConfig()->rvrMaxLevel, TIER_POINTS[0], TIER_POINTS[1], TIER_POINTS[2]);
        }
        else if (action >= ACTION_CLAIM && action < ACTION_CLAIM + 3)
        {
            const uint32 tier = action - ACTION_CLAIM;
            bool ok = false;
            {
                std::lock_guard<std::mutex> lock(m_influenceMutex);
                InfluenceData& data = m_influence[player->GetObjectGuid().GetCounter()];
                if (data.points >= TIER_POINTS[tier] && !(data.claimed & (1 << tier)))
                {
                    data.claimed |= (1 << tier);
                    data.dirty = true;
                    ok = true;
                }
            }

            if (ok)
            {
                switch (tier)
                {
                    case 0:
                        AddRenown(player, 150, false);
                        player->StoreNewItemInBestSlots(858, 5);            // Lesser Healing Potion
                        player->StoreNewItemInBestSlots(2581, 5);           // Heavy Linen Bandage
                        ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r Influence tier 1 claimed: 150 Renown and field supplies.");
                        break;
                    case 1:
                        GiveLootBag(player, BAG_PURPLE);
                        break;
                    default:
                    {
                        const uint32 tabard = player->GetTeam() == ALLIANCE ? TABARD_ALLIANCE : TABARD_HORDE;
                        GiveItem(player, tabard, "Barrens Front influence");
                        AddRenown(player, 200, false);
                        ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r You have earned the %s! (+200 Renown)",
                                                            player->GetTeam() == ALLIANCE ? "Tabard of the Barrens Vanguard" : "Tabard of the Barrens Warband");
                        SendInfAddon(player, "RENOWNFX\tBarrens Front tabard earned!");
                        break;
                    }
                }
                InfluenceSave(player);
            }
        }

        InfluenceShowMenu(player, creature);
        return true;
    }
}
