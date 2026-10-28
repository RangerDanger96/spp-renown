// Barrens Front war board: rotating daily quests and a weekly quest for the Renown module.
//
// Each faction has a War Board at its front base (the Crossroads / Northwatch Hold) offering 3 of 8 daily
// quests (the same 3 for both sides) plus a weekly quest. The rotation is controlled by server-side game
// events 1120-1127 that the quests require through conditions. Daily completion is stored per character in
// custom_renown_daily and enforced by the core (Quest::IsDaily, core patch). Rewards: Renown, XP scaled to the
// character's level and a chance at a loot bag.

#include "RenownModule.h"

#include "Chat/Chat.h"
#include "Database/DatabaseEnv.h"
#include "Entities/Player.h"
#include "GameEvents/GameEventMgr.h"
#include "Globals/ObjectAccessor.h"
#include "Globals/ObjectMgr.h"
#include "Log/Log.h"
#include "Quests/QuestDef.h"
#include "World/World.h"

#include <algorithm>
#include <ctime>
#include <sstream>

namespace cmangos_module
{
    namespace
    {
        const uint16 QUEST_EVENT_BASE = 1120;   // + daily quest index 0-7
        const uint32 QUEST_COUNT = 8;
        const uint32 HORDE_DAILY_BASE = 90101;  // 90101-90108, weekly 90109
        const uint32 ALLIANCE_DAILY_BASE = 90111; // 90111-90118, weekly 90119
        const uint32 HORDE_WEEKLY = 90109;
        const uint32 ALLIANCE_WEEKLY = 90119;
    }

    bool RenownModule::IsFrontQuest(uint32 questId, bool& weekly)
    {
        weekly = questId == HORDE_WEEKLY || questId == ALLIANCE_WEEKLY;
        return weekly || (questId >= HORDE_DAILY_BASE && questId < HORDE_DAILY_BASE + QUEST_COUNT) ||
               (questId >= ALLIANCE_DAILY_BASE && questId < ALLIANCE_DAILY_BASE + QUEST_COUNT);
    }

    uint32 RenownModule::QuestDayKey() const
    {
        // A "day" starts at Renown.Quests.ResetHour local server time
        const time_t shifted = time(nullptr) - time_t(GetConfig()->questResetHour) * HOUR;
        tm local;
#ifdef _WIN32
        localtime_s(&local, &shifted);
#else
        localtime_r(&shifted, &local);
#endif
        return uint32(local.tm_year) * 1000 + uint32(local.tm_yday);
    }

    void RenownModule::QuestsInit()
    {
        CharacterDatabase.DirectExecute(
            "CREATE TABLE IF NOT EXISTS `custom_renown_daily` ("
            "`guid` INT UNSIGNED NOT NULL, `quest` INT UNSIGNED NOT NULL, `day` INT UNSIGNED NOT NULL,"
            "PRIMARY KEY (`guid`, `quest`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Renown daily quests done today'");
        CharacterDatabase.DirectExecute(
            "CREATE TABLE IF NOT EXISTS `custom_renown_state` ("
            "`name` VARCHAR(32) NOT NULL, `value` INT UNSIGNED NOT NULL DEFAULT '0',"
            "PRIMARY KEY (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Renown module state'");

        if (!GetConfig()->questsEnabled)
        {
            return;
        }

        for (uint16 e = QUEST_EVENT_BASE; e < QUEST_EVENT_BASE + QUEST_COUNT; ++e)
        {
            if (!sGameEventMgr.IsValidEvent(e))
            {
                sLog.outError("Renown: war board game event %u is missing (zz_rvr.sql not applied?), daily quests are disabled", e);
                m_questsReady = false;
                return;
            }
        }

        m_questsReady = true;

        uint32 savedDay = 0, savedMask = 0;
        if (auto result = CharacterDatabase.Query("SELECT `name`, `value` FROM `custom_renown_state` WHERE `name` IN ('quest_day', 'quest_mask')"))
        {
            do
            {
                Field* fields = result->Fetch();
                const std::string name = fields[0].GetCppString();
                if (name == "quest_day")
                {
                    savedDay = fields[1].GetUInt32();
                }
                else
                {
                    savedMask = fields[1].GetUInt32();
                }
            }
            while (result->NextRow());
        }

        if (savedDay == QuestDayKey() && savedMask)
        {
            m_questDay = savedDay;
            QuestsApplyRotation(savedMask);
        }
        else
        {
            QuestsNewDay();
        }
    }

    void RenownModule::QuestsApplyRotation(uint32 mask)
    {
        m_questMask = mask;
        for (uint32 i = 0; i < QUEST_COUNT; ++i)
        {
            const uint16 e = QUEST_EVENT_BASE + uint16(i);
            const bool active = (mask & (1u << i)) != 0;
            if (active && !sGameEventMgr.IsActiveEvent(e))
            {
                sGameEventMgr.StartEvent(e, true);
            }
            else if (!active && sGameEventMgr.IsActiveEvent(e))
            {
                sGameEventMgr.StopEvent(e, true);
            }
        }
    }

    void RenownModule::QuestsNewDay()
    {
        // Pick today's orders
        std::vector<uint32> pool;
        for (uint32 i = 0; i < QUEST_COUNT; ++i)
        {
            pool.push_back(i);
        }

        uint32 mask = 0;
        const uint32 perDay = std::max<uint32>(1, std::min<uint32>(GetConfig()->questsPerDay, QUEST_COUNT));
        for (uint32 n = 0; n < perDay && !pool.empty(); ++n)
        {
            const size_t pick = urand(0, uint32(pool.size() - 1));
            mask |= 1u << pool[pick];
            pool.erase(pool.begin() + pick);
        }

        m_questDay = QuestDayKey();
        QuestsApplyRotation(mask);

        // Everybody may do the dailies again
        CharacterDatabase.Execute("DELETE FROM `custom_renown_daily`");
        {
            HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
            for (const auto& entry : sObjectAccessor.GetPlayers())
            {
                if (entry.second)
                {
                    entry.second->ResetDailyQuestStatus();
                }
            }
        }

        CharacterDatabase.PExecute("REPLACE INTO `custom_renown_state` (`name`, `value`) VALUES ('quest_day', '%u'), ('quest_mask', '%u')", m_questDay, mask);
        sLog.outString("Renown: new war board orders for the day (mask %u)", mask);
    }

    void RenownModule::QuestsUpdate(uint32 diff)
    {
        if (!m_questsReady)
        {
            return;
        }

        m_questTimer += diff;
        if (m_questTimer < MINUTE * IN_MILLISECONDS)
        {
            return;
        }

        m_questTimer = 0;
        if (QuestDayKey() != m_questDay)
        {
            QuestsNewDay();
            RvRAnnounce("|cffffd100[Barrens Front]|r New orders have been posted on the war boards at the Crossroads and Northwatch Hold.", true);
        }
    }

    void RenownModule::QuestsLoad(Player* player)
    {
        if (!m_questsReady)
        {
            return;
        }

        player->ResetDailyQuestStatus();
        auto result = CharacterDatabase.PQuery("SELECT `quest` FROM `custom_renown_daily` WHERE `guid` = '%u' AND `day` = '%u'",
                                               player->GetObjectGuid().GetCounter(), m_questDay);
        if (result)
        {
            do
            {
                player->SetDailyQuestStatus(result->Fetch()[0].GetUInt32());
            }
            while (result->NextRow());
        }
    }

    void RenownModule::QuestsSave(Player* player)
    {
        if (!m_questsReady)
        {
            return;
        }

        const uint32 playerId = player->GetObjectGuid().GetCounter();
        CharacterDatabase.PExecute("DELETE FROM `custom_renown_daily` WHERE `guid` = '%u'", playerId);
        for (uint32 quest : player->GetDailyQuests())
        {
            CharacterDatabase.PExecute("INSERT INTO `custom_renown_daily` (`guid`, `quest`, `day`) VALUES ('%u', '%u', '%u')", playerId, quest, m_questDay);
        }
    }

    void RenownModule::QuestCredit(Player* player, uint32 creditEntry)
    {
        // Only players take war board orders; KilledMonsterCredit ignores players without a matching quest
        if (player && player->isRealPlayer() && m_questsReady)
        {
            player->KilledMonsterCredit(creditEntry);
        }
    }

    void RenownModule::OnGetQuestXP(Player* player, const Quest* quest, uint32& xp)
    {
        bool weekly = false;
        if (!player || !quest || !IsFrontQuest(quest->GetQuestId(), weekly))
        {
            return;
        }

        // A share of the character's current level, so the reward stays good at every level
        const uint32 pct = weekly ? GetConfig()->questWeeklyXPPercent : GetConfig()->questDailyXPPercent;
        xp = uint32(uint64(sObjectMgr.GetXPForLevel(player->GetLevel())) * pct / 100);
    }

    void RenownModule::OnRewardQuest(Player* player, const Quest* quest)
    {
        bool weekly = false;
        if (!player || !quest || !IsFrontQuest(quest->GetQuestId(), weekly) || !GetConfig()->enabled)
        {
            return;
        }

        if (quest->IsDaily())
        {
            QuestsSave(player);
        }

        AddRenown(player, weekly ? GetConfig()->questWeeklyRenown : GetConfig()->questDailyRenown, false);

        if (weekly)
        {
            GiveLootBag(player, BAG_PURPLE);
        }
        else if (urand(1, 100) <= GetConfig()->questDailyBagChance)
        {
            GiveLootBag(player, BAG_BLUE);
        }
    }
}
