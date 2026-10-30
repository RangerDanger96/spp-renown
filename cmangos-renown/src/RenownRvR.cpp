// The Barrens Front: a Warhammer style tier 1 RvR lake for the Renown module.
//
// Horde stage at the Crossroads, the Alliance at Northwatch Hold. Three battlefield objectives lie between
// them: Kolkar Watch (Horde side), the Stagnant Oasis (center) and the Raptor Grounds (Alliance side). They are
// taken in order along the lane: your own tower, then the Oasis, then the enemy tower. Objectives, kills,
// battlegrounds and war boards push a domination bar; a full bar opens a siege on the enemy field commander; killing the
// commander locks the lake for the winners, hands out loot bags and resets it after a cooldown.
//
// Banners, objective guards and the commanders are world database spawns linked to server-side game events
// (zz_rvr.sql), so the core takes care of spawning them in loaded and unloaded grids.

#include "RenownModule.h"

#include "Chat/Chat.h"
#include "Entities/Creature.h"
#include "Entities/Player.h"
#include "GameEvents/GameEventMgr.h"
#include "Globals/ObjectAccessor.h"
#include "Globals/ObjectMgr.h"
#include "Groups/Group.h"
#include "Log/Log.h"
#include "Maps/Map.h"
#include "Server/Opcodes.h"
#include "Spells/SpellMgr.h"
#include "Server/SQLStorages.h"
#include "Server/WorldPacket.h"
#include "Server/WorldSession.h"
#include "World/World.h"

#include <algorithm>
#include <cmath>
#include <ctime>
#include <sstream>

#ifdef ENABLE_PLAYERBOTS
// Defined in the playerbots patch (RandomPlayerbotMgr.cpp), compiled with the playerbots' own settings
bool RenownBotFrontMode(Player* bot, bool on);
#endif

namespace cmangos_module
{
    namespace
    {
        void RvRBotFrontMode(Player* bot, bool on)
        {
#ifdef ENABLE_PLAYERBOTS
            RenownBotFrontMode(bot, on);
#else
            (void)bot; (void)on;
#endif
        }

        const uint32 RVR_MAP = 1;
        const uint16 RVR_EVENT_WILDLIFE = 1112;         // active = the lake's wildlife and centaurs are despawned
        const uint16 RVR_EVENT_BASE = 1100;            // + objective * 3 + state (0 neutral, 1 alliance, 2 horde)
        const uint16 RVR_EVENT_SIEGE_NORTHWATCH = 1110; // alliance commander out (horde attacks)
        const uint16 RVR_EVENT_SIEGE_CROSSROADS = 1111; // horde commander out (alliance attacks)
        const uint32 RVR_COMMANDER_ALLIANCE = 190812;
        const uint32 RVR_COMMANDER_HORDE = 190813;
        const uint32 RVR_CHICKEN_DISPLAY = 304;
        const float RVR_LAKE_RADIUS = 200.0f;

        struct Point { float x, y, z; };
        const Point RVR_HORDE_COMMAND    = { -680.0f, -2740.0f, 92.5f };
        const Point RVR_ALLIANCE_COMMAND = { -1965.0f, -3395.0f, 56.4f };
        const Point RVR_HORDE_ARRIVAL    = { -450.0f, -2630.0f, 96.0f };   // the Crossroads
        const Point RVR_ALLIANCE_ARRIVAL = { -2093.0f, -3639.0f, 62.0f };  // Northwatch Hold
        const float RVR_HORDE_ARRIVAL_O = 3.8f;
        const float RVR_ALLIANCE_ARRIVAL_O = 0.8f;

        uint32 TeamState(uint32 team) { return team == ALLIANCE ? 1 : (team == HORDE ? 2 : 0); }
        const char* TeamName(uint32 team) { return team == ALLIANCE ? "|cff3399ffAlliance|r" : (team == HORDE ? "|cffff3333Horde|r" : "nobody"); }
        uint32 Enemy(uint32 team) { return team == ALLIANCE ? HORDE : ALLIANCE; }

        float DistToSegment(float px, float py, float ax, float ay, float bx, float by)
        {
            const float dx = bx - ax, dy = by - ay;
            const float len = dx * dx + dy * dy;
            float t = len > 0.0f ? ((px - ax) * dx + (py - ay) * dy) / len : 0.0f;
            t = std::max(0.0f, std::min(1.0f, t));
            const float cx = ax + t * dx, cy = ay + t * dy;
            return std::sqrt((px - cx) * (px - cx) + (py - cy) * (py - cy));
        }

        void SendAddon(Player* player, const std::string& message)
        {
            if (!player || !player->GetSession())
            {
                return;
            }

            WorldPacket packet;
            ChatHandler::BuildChatPacket(packet, CHAT_MSG_PARTY, message.c_str(), LANG_ADDON, CHAT_TAG_NONE, player->GetObjectGuid(), player->GetName());
            player->GetSession()->SendPacket(packet);
        }
    }

    void RenownModule::RvRInit()
    {
        m_rvrObjectives.clear();
        RvRObjective kolkar;  kolkar.name = "Kolkar Watch";    kolkar.x = -849.0f;  kolkar.y = -2858.0f; kolkar.z = 92.0f; kolkar.tower = true;
        RvRObjective oasis;   oasis.name = "Stagnant Oasis";   oasis.x = -1255.0f;  oasis.y = -3150.0f;  oasis.z = 91.8f;  oasis.tower = false;
        RvRObjective raptor;  raptor.name = "Raptor Grounds";  raptor.x = -1790.0f; raptor.y = -3280.0f; raptor.z = 93.2f; raptor.tower = true;
        m_rvrObjectives.push_back(kolkar);
        m_rvrObjectives.push_back(oasis);
        m_rvrObjectives.push_back(raptor);

        if (!GetConfig()->rvrEnabled)
        {
            return;
        }

        std::vector<uint16> events = { RVR_EVENT_SIEGE_NORTHWATCH, RVR_EVENT_SIEGE_CROSSROADS };
        for (uint16 e = RVR_EVENT_BASE; e < RVR_EVENT_BASE + 9; ++e)
        {
            events.push_back(e);
        }

        for (uint16 e : events)
        {
            if (!sGameEventMgr.IsValidEvent(e))
            {
                sLog.outError("Renown: RvR game event %u is missing (zz_rvr.sql not applied?), the Barrens Front is disabled", e);
                m_rvrObjectives.clear();
                return;
            }
        }

        RvRReset();

        // Clear the lake of wildlife so low levels fight each other, not raptors (zz_rvr.sql links the spawns)
        if (sGameEventMgr.IsValidEvent(RVR_EVENT_WILDLIFE) && !sGameEventMgr.IsActiveEvent(RVR_EVENT_WILDLIFE))
        {
            sGameEventMgr.StartEvent(RVR_EVENT_WILDLIFE, true);
        }

        sLog.outString("Renown: the Barrens Front RvR lake is open");
    }

    // ------------------------------------------------------------------ state changes
    void RenownModule::RvRSetOwner(size_t index, uint32 team, bool force)
    {
        RvRObjective& objective = m_rvrObjectives[index];
        if (objective.owner == team && !force)
        {
            return;
        }

        objective.owner = team;
        objective.capTeam = 0;
        objective.progress = 0;

        const uint16 base = RVR_EVENT_BASE + uint16(index * 3);
        const uint32 state = TeamState(team);
        for (uint32 s = 0; s < 3; ++s)
        {
            if (s != state && sGameEventMgr.IsActiveEvent(base + s))
            {
                sGameEventMgr.StopEvent(base + s, true);
            }
        }

        if (!sGameEventMgr.IsActiveEvent(base + state))
        {
            sGameEventMgr.StartEvent(base + state, true);
        }

        m_rvrDirty = true;
    }

    void RenownModule::RvRReset()
    {
        {
            std::lock_guard<std::mutex> lock(m_frontMutex);
            m_frontCycle.clear();
            m_frontFirstBlood = false;
        }

        RvRStopSiege();
        m_rvrLockTeam = 0;
        m_rvrLockUntil = 0;
        m_rvrHoldTeam = 0;
        m_rvrHoldTime = 0;
        m_rvrDom = 0;
        for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
        {
            RvRSetOwner(i, 0, true);
        }

        std::lock_guard<std::mutex> lock(m_dataMutex);
        for (auto& entry : m_data)
        {
            entry.second.lakeEarned = 0;
        }
    }

    void RenownModule::RvRStartSiege(uint32 team)
    {
        if (m_rvrSiegeTeam == team)
        {
            return;
        }

        RvRStopSiege();
        m_rvrSiegeTeam = team;
        sGameEventMgr.StartEvent(team == HORDE ? RVR_EVENT_SIEGE_NORTHWATCH : RVR_EVENT_SIEGE_CROSSROADS, true);
        m_rvrSiegeLog.push_back(time(nullptr));
        FrontOnSiege(team);

        std::ostringstream text;
        text << "|cffffd100[Barrens Front]|r The " << TeamName(team) << " holds the whole front! "
             << (team == HORDE ? "The Northwatch Field Commander has taken the field near Northwatch Hold. Kill him!"
                               : "The Crossroads Warlord has taken the field outside the Crossroads. Kill him!");
        RvRAnnounce(text.str(), true);
        m_rvrDirty = true;
    }

    void RenownModule::RvRStopSiege()
    {
        if (sGameEventMgr.IsActiveEvent(RVR_EVENT_SIEGE_NORTHWATCH))
        {
            sGameEventMgr.StopEvent(RVR_EVENT_SIEGE_NORTHWATCH, true);
        }

        if (sGameEventMgr.IsActiveEvent(RVR_EVENT_SIEGE_CROSSROADS))
        {
            sGameEventMgr.StopEvent(RVR_EVENT_SIEGE_CROSSROADS, true);
        }

        m_rvrSiegeTeam = 0;
        m_rvrDirty = true;
    }

    void RenownModule::RvRLock(uint32 team)
    {
        RvRStopSiege();
        for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
        {
            RvRSetOwner(i, team);
        }

        m_rvrLockTeam = team;
        m_rvrLockUntil = time(nullptr) + GetConfig()->rvrLockMinutes * MINUTE;
        m_rvrDom = team == ALLIANCE ? 10000 : -10000;   // shown full for the winner while locked; reset clears it

        std::ostringstream text;
        text << "|cffffd100[Barrens Front]|r The " << TeamName(team) << " has won the Barrens Front! The front is locked for "
             << GetConfig()->rvrLockMinutes << " minutes.";
        RvRAnnounce(text.str(), true);

        RvRAwardBags(team);
        FrontOnVictory(team);
        m_rvrDirty = true;
    }

    void RenownModule::RvRAwardBags(uint32 winner)
    {
        struct Entry { Player* player; uint32 score; };
        std::vector<Entry> winners;
        std::vector<Entry> losers;
        std::vector<std::pair<uint32, uint32>> earned;   // guid, lakeEarned
        {
            std::lock_guard<std::mutex> lock(m_dataMutex);
            for (auto& entry : m_data)
            {
                if (entry.second.lakeEarned > 0)
                {
                    earned.emplace_back(entry.first, entry.second.lakeEarned);
                }

                entry.second.lakeEarned = 0;
            }
        }

        for (const auto& entry : earned)
        {
            Player* player = sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, entry.first));
            if (!player || !player->IsInWorld())
            {
                continue;
            }

            const uint32 score = entry.second * urand(80, 120);
            (player->GetTeam() == winner ? winners : losers).push_back({ player, score });
            if (player->GetTeam() == winner)
            {
                QuestCredit(player, 190829);   // war board weekly: win the front
            }
        }

        auto byScore = [](const Entry& a, const Entry& b) { return a.score > b.score; };
        std::sort(winners.begin(), winners.end(), byScore);
        std::sort(losers.begin(), losers.end(), byScore);

        std::ostringstream summary;
        summary << "|cffffd100[Barrens Front] Loot bags:|r";
        static const char* colors[] = { "|cffff8000Gold|r", "|cffa335eePurple|r", "|cff0070ddBlue|r" };
        auto give = [&](const Entry& entry, BagType bag)
        {
            summary << " " << entry.player->GetName() << " (" << colors[bag] << ")";
            if (entry.player->isRealPlayer())
            {
                GiveLootBag(entry.player, bag);
            }
        };

        for (size_t i = 0; i < winners.size() && i < 8; ++i)
        {
            give(winners[i], i == 0 ? BAG_GOLD : (i < 3 ? BAG_PURPLE : BAG_BLUE));
        }

        for (size_t i = 0; i < losers.size() && i < 3; ++i)
        {
            give(losers[i], i == 0 ? BAG_PURPLE : BAG_BLUE);
        }

        if (!winners.empty() || !losers.empty())
        {
            RvRAnnounce(summary.str());
        }
    }

    // ------------------------------------------------------------------ helpers
    void RenownModule::RvRAnnounce(const std::string& text, bool worldwide) const
    {
        HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
        for (const auto& entry : sObjectAccessor.GetPlayers())
        {
            Player* player = entry.second;
            if (!player || !player->IsInWorld() || !player->isRealPlayer())
            {
                continue;
            }

            // The lake, the rest of the Barrens, or everyone for the big moments
            if (worldwide || (player->GetMapId() == RVR_MAP && player->GetZoneId() == 17) || RvRIsMember(player->GetObjectGuid().GetCounter()))
            {
                ChatHandler(player).PSendSysMessage("%s", text.c_str());
            }
        }
    }

    void RenownModule::RvRSendStatus(Player* player) const
    {
        // RENOWNRVR<tab>owner,capTeam,pct;owner,capTeam,pct;owner,capTeam,pct/siegeTeam/lockTeam/lockSeconds/inLake
        std::ostringstream message;
        message << "RENOWNRVR\t";
        for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
        {
            const RvRObjective& o = m_rvrObjectives[i];
            const uint32 pct = std::min<uint32>(100, o.progress * 100 / std::max<uint32>(1, GetConfig()->rvrCaptureTime * IN_MILLISECONDS));
            message << (i ? ";" : "") << TeamState(o.owner) << "," << TeamState(o.capTeam) << "," << pct;
        }

        const time_t now = time(nullptr);
        message << "/" << TeamState(m_rvrSiegeTeam) << "/" << TeamState(m_rvrLockTeam) << "/"
                << (m_rvrLockUntil > now ? uint32(m_rvrLockUntil - now) : 0) << "/"
                << (RvRIsMember(player->GetObjectGuid().GetCounter()) ? 1 : 0);

        // Front life: underdog side and fortified objectives (bit mask)
        uint32 fortified = 0;
        for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
        {
            if (m_rvrObjectives[i].fortifiedUntil > now)
            {
                fortified |= 1u << i;
            }
        }

        message << "/" << TeamState(m_frontUnderdog) << "/" << fortified;
        message << "/" << int32(m_rvrDom) / 100 << "/" << RvRNearObjective(player);
        SendAddon(player, message.str());
    }

    uint32 RenownModule::RvRNearObjective(const Player* player) const
    {
        if (!RenownPlayerOk(player) || player->GetMapId() != RVR_MAP)
        {
            return 0;
        }

        const float radius = (float)GetConfig()->rvrCaptureRadius;
        for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
        {
            const RvRObjective& o = m_rvrObjectives[i];
            const float dx = player->GetPositionX() - o.x, dy = player->GetPositionY() - o.y;
            if (dx * dx + dy * dy <= radius * radius && std::fabs(player->GetPositionZ() - o.z) < 20.0f)
            {
                return uint32(i + 1);
            }
        }

        return 0;
    }

    void RenownModule::RvRDominate(uint32 team, int32 amount)
    {
        if (!GetConfig()->rvrEnabled || m_rvrLockTeam || (team != ALLIANCE && team != HORDE) || amount <= 0)
        {
            return;
        }

        const int32 delta = team == ALLIANCE ? amount : -amount;
        int32 current = m_rvrDom.load();
        int32 next;
        do
        {
            next = std::max<int32>(-10000, std::min<int32>(10000, current + delta));
        } while (!m_rvrDom.compare_exchange_weak(current, next));
    }

    bool RenownModule::RvRInLakeArea(const Player* player) const
    {
        if (m_rvrObjectives.size() != 3 || player->GetMapId() != RVR_MAP)
        {
            return false;
        }

        const float px = player->GetPositionX();
        const float py = player->GetPositionY();
        const Point path[] = { RVR_HORDE_COMMAND,
                               { m_rvrObjectives[0].x, m_rvrObjectives[0].y, m_rvrObjectives[0].z },
                               { m_rvrObjectives[1].x, m_rvrObjectives[1].y, m_rvrObjectives[1].z },
                               { m_rvrObjectives[2].x, m_rvrObjectives[2].y, m_rvrObjectives[2].z },
                               RVR_ALLIANCE_COMMAND };
        for (size_t i = 0; i + 1 < sizeof(path) / sizeof(path[0]); ++i)
        {
            if (DistToSegment(px, py, path[i].x, path[i].y, path[i + 1].x, path[i + 1].y) <= RVR_LAKE_RADIUS)
            {
                return true;
            }
        }

        return false;
    }

    bool RenownModule::RvRIsMember(uint32 playerId) const
    {
        return m_rvrMembers.find(playerId) != m_rvrMembers.end();
    }

    uint32 RenownModule::RvROwnedBy(uint32 team) const
    {
        uint32 count = 0;
        for (const RvRObjective& o : m_rvrObjectives)
        {
            if (o.owner == team)
            {
                ++count;
            }
        }

        return count;
    }

    void RenownModule::RvRFrontPoint(uint32 team, float& x, float& y, float& z) const
    {
        // First objective (counted from the team's own side) that the team does not hold yet
        const bool alliance = team == ALLIANCE;
        const Point home = alliance ? RVR_ALLIANCE_COMMAND : RVR_HORDE_COMMAND;
        Point target = alliance ? RVR_HORDE_COMMAND : RVR_ALLIANCE_COMMAND;   // siege: the enemy commander
        std::vector<Point> open;
        for (int k = 0; k < 3; ++k)
        {
            const RvRObjective& o = m_rvrObjectives[alliance ? 2 - k : k];
            if (o.owner != team)
            {
                open.push_back({ o.x, o.y, o.z });
            }
        }

        if (!open.empty())
        {
            // Mostly the nearest objective to take, sometimes the next one
            target = open[(open.size() > 1 && urand(0, 2) == 0) ? 1 : 0];
        }

        // Stage a little on the team's own side of the target
        const float dx = home.x - target.x, dy = home.y - target.y;
        const float len = std::max(1.0f, std::sqrt(dx * dx + dy * dy));
        const float back = std::min(30.0f, len);
        const float angle = frand(0.0f, 6.2831853f);
        const float spread = frand(0.0f, 15.0f);
        x = target.x + dx / len * back + std::cos(angle) * spread;
        y = target.y + dy / len * back + std::sin(angle) * spread;
        z = target.z + 2.0f;
    }

    // ------------------------------------------------------------------ enter / leave
    void RenownModule::RvREnterLake(Player* player)
    {
        const uint32 playerId = player->GetObjectGuid().GetCounter();
        m_rvrMembers.insert(playerId);

        const uint32 cap = GetConfig()->rvrMaxLevel;
        if (player->GetLevel() > cap && !player->IsGameMaster())
        {
            m_rvrChickens.insert(playerId);
            player->RemoveSpellsCausingAura(SPELL_AURA_MOUNTED);
            player->SetDisplayId(RVR_CHICKEN_DISPLAY);
            player->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PACIFIED | UNIT_FLAG_SILENCED);
            if (player->isRealPlayer())
            {
                ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r You are too powerful for this tier 1 battlefield (max level %u) and have been turned into a chicken!", cap);
            }
        }
        else if (player->GetLevel() < cap && GetConfig()->bolsterEnabled && !player->InBattleGround())
        {
            {
                std::lock_guard<std::mutex> lock(m_bolsterMutex);
                m_bolster[playerId] = cap;
            }

            ApplyLevelStats(player, cap);
            if (player->isRealPlayer())
            {
                ChatHandler(player).PSendSysMessage("|cff00ccffBolster:|r you fight as a level %u on the Barrens Front (stats, health, mana, skills and hit chance). New spells still come from leveling.", cap);
            }
        }

        player->UpdatePvP(true, true);
        FrontEnter(player);
        if (player->isRealPlayer())
        {
            ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r You entered the tier 1 RvR lake. Capture Kolkar Watch, the Stagnant Oasis and the Raptor Grounds!");
            RvRSendStatus(player);
        }
    }

    void RenownModule::RvRLeaveLake(Player* player)
    {
        const uint32 playerId = player->GetObjectGuid().GetCounter();
        m_rvrMembers.erase(playerId);

        if (m_rvrChickens.erase(playerId))
        {
            player->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PACIFIED | UNIT_FLAG_SILENCED);
            player->DeMorph();
        }

        if (!player->InBattleGround())
        {
            bool wasBolstered = false;
            {
                std::lock_guard<std::mutex> lock(m_bolsterMutex);
                wasBolstered = m_bolster.erase(playerId) > 0;
            }

            if (wasBolstered)
            {
                ApplyLevelStats(player, player->GetLevel());
            }
        }

        FrontLeave(player);
        if (player->isRealPlayer())
        {
            RvRSendStatus(player);
        }
    }

    // ------------------------------------------------------------------ bots
    void RenownModule::RvRReinforce(const std::vector<Player*>& players)
    {
        // The front keeps an enlisted roster of bots per side: about FrontBotsActive while real players are in the
        // Barrens, FrontBotsIdle while nobody is watching. New bots arrive at their own base in small squads and
        // ride out from there; when the front is over strength, spare bots are sent home.
        const RenownModuleConfig* config = GetConfig();
        const uint32 share = std::min<uint32>(config->rvrBotShare, 100);
        if (!share)
        {
            return;
        }

        bool watched = false;
        uint32 present[2] = { 0, 0 };
        std::vector<Player*> enlisted[2];
        for (Player* player : players)
        {
            if (!RenownPlayerOk(player))
                continue;
            if (player->isRealPlayer())
            {
                if (player->GetMapId() == RVR_MAP && (player->GetZoneId() == 17 || RvRIsMember(player->GetObjectGuid().GetCounter())))
                {
                    watched = true;
                }
                continue;
            }

            if (m_rvrRoster.count(player->GetObjectGuid().GetCounter()))
            {
                const int side = player->GetTeam() == ALLIANCE ? 0 : 1;
                ++present[side];
                enlisted[side].push_back(player);
            }
        }

        uint32 target = watched ? config->rvrFrontBotsActive : config->rvrFrontBotsIdle;
        if (config->rvrBotsPerSide)
        {
            target = std::min(target, config->rvrBotsPerSide);
        }

        const uint32 wave = std::max<uint32>(1, config->rvrBotsPerWave);
        for (int side = 0; side < 2; ++side)
        {
            const uint32 team = side == 0 ? ALLIANCE : HORDE;

            // Over strength (players left, or the lake is locked): send a few spare bots home each time
            uint32 limit = m_rvrLockTeam ? std::min<uint32>(target, config->rvrFrontBotsIdle) : target;
            if (team == m_frontUnderdog)
            {
                limit += 5;   // underdog: a few more soldiers for the side that is behind
            }
            if (present[side] > limit + 4)
            {
                uint32 release = std::min<uint32>(present[side] - limit, wave);
                for (Player* bot : enlisted[side])
                {
                    if (!release)
                    {
                        break;
                    }

                    if (bot->IsAlive() && !bot->IsInCombat() && !bot->IsTaxiFlying() && !bot->IsBeingTeleported())
                    {
                        const uint32 botId = bot->GetObjectGuid().GetCounter();
                        m_rvrRoster.erase(botId);
                        m_rvrBotOrders.erase(botId);
                        if (m_rvrDirectedBots.erase(botId))
                        {
                            RvRBotFrontMode(bot, false);
                        }
                        bot->TeleportToHomebind();
                        --release;
                    }
                }
                continue;
            }

            if (m_rvrLockTeam || present[side] >= limit)
            {
                continue;
            }

            // Don't let one side snowball: stop sending once it is a full wave ahead of the other
            if (team != m_frontUnderdog && present[side] >= present[1 - side] + wave)
            {
                continue;
            }

            std::vector<Player*> candidates;
            for (Player* player : players)
            {
                if (!RenownPlayerOk(player))
                    continue;
                const uint32 botId = player->GetObjectGuid().GetCounter();
                if (player->isRealPlayer() || player->GetTeam() != team || player->GetLevel() > config->rvrMaxLevel ||
                    botId % 100 >= share || m_rvrRoster.count(botId) || RvRIsMember(botId))
                {
                    continue;
                }

                if (!player->IsAlive() || player->IsInCombat() || player->InBattleGround() || player->InBattleGroundQueue() ||
                    player->GetGroup() || player->IsTaxiFlying() || player->IsBeingTeleported() || !player->GetMap() ||
                    player->GetMap()->Instanceable())
                {
                    continue;
                }

                candidates.push_back(player);
            }

            // Arrive in squads of about four at the side's own base
            uint32 need = std::min<uint32>(wave, limit - present[side]);
            const Point& base = team == ALLIANCE ? RVR_ALLIANCE_ARRIVAL : RVR_HORDE_ARRIVAL;
            float sx = base.x, sy = base.y;
            for (uint32 n = 0; need > 0 && !candidates.empty(); ++n, --need)
            {
                if (n % 4 == 0)
                {
                    const float a = frand(0.0f, 6.28f), d = frand(0.0f, 12.0f);
                    sx = base.x + std::cos(a) * d;
                    sy = base.y + std::sin(a) * d;
                }

                const size_t pick = urand(0, uint32(candidates.size() - 1));
                Player* bot = candidates[pick];
                candidates.erase(candidates.begin() + pick);

                m_rvrRoster.insert(bot->GetObjectGuid().GetCounter());
                float x = sx + frand(-2.5f, 2.5f), y = sy + frand(-2.5f, 2.5f), z = base.z;
                bot->UpdateAllowedPositionZ(x, y, z);
                bot->TeleportTo(RVR_MAP, x, y, z + 0.5f, frand(0.0f, 6.28f));
            }
        }
    }

    // ------------------------------------------------------------------ front bots
    // The front's share of bots stop questing/travelling while they are in the Barrens (otherwise they wander off
    // to Ratchet and their quest hubs) and are walked from objective to objective instead.
    void RenownModule::RvRDirectBots(const std::vector<Player*>& players)
    {
        // Orders: 0-2 = objective, 3 = own command post, 4 = enemy command post
        enum { ORDER_HOME = 3, ORDER_ENEMY_BASE = 4, ORDER_NONE = 255 };
        const RenownModuleConfig* config = GetConfig();
        if (m_rvrObjectives.size() != 3)
        {
            return;
        }

        // ---- one plan per side, so its bots push together instead of scattering
        struct Plan
        {
            uint8 attack = ORDER_NONE;      // where most of the side goes
            std::vector<uint8> urgent;      // own objectives the enemy is taking right now / own base under siege
            std::vector<uint8> held;        // own objectives to guard
        };

        auto makePlan = [&](uint32 team) -> Plan
        {
            Plan plan;
            const uint32 enemy = team == ALLIANCE ? HORDE : ALLIANCE;
            const uint8 ownTower = team == HORDE ? 0 : 2, enemyTower = team == HORDE ? 2 : 0, center = 1;
            for (uint8 i = 0; i < 3; ++i)
            {
                const RvRObjective& o = m_rvrObjectives[i];
                if (o.owner == team)
                {
                    plan.held.push_back(i);
                    if (o.capTeam == enemy && o.progress > 0)
                    {
                        plan.urgent.push_back(i);
                    }
                }
            }

            if (m_rvrSiegeTeam == enemy)
            {
                plan.urgent.push_back(ORDER_HOME);      // the commander is out: protect him
            }

            if (m_rvrLockTeam)
            {
                plan.attack = ORDER_HOME;               // lake locked after a siege: regroup at home
            }
            else if (m_rvrSiegeTeam == team)
            {
                plan.attack = ORDER_ENEMY_BASE;         // siege open: storm the enemy commander
            }
            else if (m_rvrObjectives[ownTower].owner != team)
            {
                plan.attack = ownTower;                 // first secure our tower
            }
            else if (m_rvrObjectives[center].owner != team)
            {
                plan.attack = center;                   // then push to the Oasis
            }
            else if (m_rvrObjectives[enemyTower].owner != team)
            {
                plan.attack = enemyTower;               // and finally the enemy's tower
            }
            // else: all three held, waiting for the siege to open, everyone guards

            return plan;
        };

        const Plan plans[2] = { makePlan(ALLIANCE), makePlan(HORDE) };
        std::unordered_set<uint32> seen;

        auto orderPoint = [&](uint32 team, uint8 order) -> Point
        {
            if (order < 3)
            {
                return { m_rvrObjectives[order].x, m_rvrObjectives[order].y, m_rvrObjectives[order].z };
            }

            const bool home = order == ORDER_HOME;
            return (team == ALLIANCE) == home ? RVR_ALLIANCE_COMMAND : RVR_HORDE_COMMAND;
        };

        for (Player* bot : players)
        {
            if (!RenownPlayerOk(bot))
                continue;
            if (bot->isRealPlayer())
            {
                continue;
            }

            const uint32 botId = bot->GetObjectGuid().GetCounter();
            seen.insert(botId);
            const bool frontBot = m_rvrRoster.count(botId) && bot->GetLevel() <= config->rvrMaxLevel &&
                                  !bot->InBattleGround() && bot->GetMapId() == RVR_MAP &&
                                  (RvRIsMember(botId) || bot->GetZoneId() == 17 || bot->IsBeingTeleported());
            if (!frontBot)
            {
                if (m_rvrRoster.count(botId) && !bot->IsBeingTeleported())
                {
                    m_rvrRoster.erase(botId);   // left the front (levelled out, battleground, wandered off...)
                }

                if (m_rvrDirectedBots.erase(botId))
                {
                    m_rvrBotOrders.erase(botId);
                    RvRBotFrontMode(bot, false);
                }
                continue;
            }

            m_rvrDirectedBots.insert(botId);
            RvRBotFrontMode(bot, true);

            // Leave bots alone while they fight, eat/drink, recover or are otherwise busy
            if (!bot->IsAlive() || bot->IsInCombat() || bot->IsTaxiFlying() || bot->GetGroup() || !bot->IsStandState() ||
                bot->GetHealthPercent() < 50.0f || (bot->GetPowerType() == POWER_MANA && bot->GetMaxPower(POWER_MANA) > 0 &&
                bot->GetPower(POWER_MANA) * 100 < bot->GetMaxPower(POWER_MANA) * 30))
            {
                continue;
            }

            // Pick this bot's order. Its role (fixed per bot) decides whether it attacks, defends or answers alarms.
            const Plan& plan = plans[bot->GetTeam() == ALLIANCE ? 0 : 1];
            const uint32 role = (botId / 100) % 10;
            uint8 order = ORDER_NONE;
            if (!plan.urgent.empty() && role < 4)
            {
                order = plan.urgent[botId % plan.urgent.size()];
            }
            else if (plan.attack != ORDER_NONE && (role < 8 || plan.held.empty()))
            {
                order = plan.attack;
            }
            else if (!plan.held.empty())
            {
                order = plan.held[botId % plan.held.size()];
            }
            else
            {
                order = ORDER_HOME;
            }

            const Point target = orderPoint(bot->GetTeam(), order);
            const float dx = bot->GetPositionX() - target.x, dy = bot->GetPositionY() - target.y;
            const bool arrived = dx * dx + dy * dy <= 20.0f * 20.0f;
            auto it = m_rvrBotOrders.find(botId);
            const bool changed = it == m_rvrBotOrders.end() || it->second != order;
            const bool idle = bot->GetMotionMaster()->GetCurrentMovementGeneratorType() == IDLE_MOTION_TYPE;
            if (!changed && (arrived || !idle))
            {
                continue;   // on its way, or holding the position
            }

            m_rvrBotOrders[botId] = order;
            const float angle = frand(0.0f, 6.28f), dist = frand(3.0f, 14.0f);
            float x = target.x + std::cos(angle) * dist, y = target.y + std::sin(angle) * dist, z = target.z;
            bot->UpdateAllowedPositionZ(x, y, z);
            bot->GetMotionMaster()->MovePoint(0, x, y, z, FORCED_MOVEMENT_RUN);
        }

        // Bots that logged out leave the roster
        for (auto it = m_rvrRoster.begin(); it != m_rvrRoster.end();)
        {
            if (!seen.count(*it))
            {
                m_rvrDirectedBots.erase(*it);
                m_rvrBotOrders.erase(*it);
                it = m_rvrRoster.erase(it);
            }
            else
            {
                ++it;
            }
        }
    }

    // ------------------------------------------------------------------ stats (GM): .renown rvr stats
    void RenownModule::RvRStats(ChatHandler& handler)
    {
        const time_t now = time(nullptr);
        for (std::vector<time_t>* log : { &m_rvrCaptureLog, &m_rvrSiegeLog })
        {
            log->erase(std::remove_if(log->begin(), log->end(), [now](time_t t) { return now - t > HOUR; }), log->end());
        }

        uint32 roster[2] = { 0, 0 }, inLake[2] = { 0, 0 }, dead[2] = { 0, 0 }, fighting[2] = { 0, 0 }, players[2] = { 0, 0 };
        uint32 orders[2][5] = {};
        bool watched = false;
        {
            HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
            for (const auto& entry : sObjectAccessor.GetPlayers())
            {
                Player* p = entry.second;
                if (!p || !p->IsInWorld())
                {
                    continue;
                }

                const int side = p->GetTeam() == ALLIANCE ? 0 : 1;
                const uint32 id = p->GetObjectGuid().GetCounter();
                if (p->isRealPlayer())
                {
                    if (p->GetMapId() == RVR_MAP && (p->GetZoneId() == 17 || RvRIsMember(id)))
                    {
                        watched = true;
                        ++players[side];
                    }
                    continue;
                }

                if (!m_rvrRoster.count(id))
                {
                    continue;
                }

                ++roster[side];
                if (RvRIsMember(id)) ++inLake[side];
                if (!p->IsAlive()) ++dead[side];
                if (p->IsInCombat()) ++fighting[side];
                auto it = m_rvrBotOrders.find(id);
                if (it != m_rvrBotOrders.end() && it->second < 5) ++orders[side][it->second];
            }
        }

        const RenownModuleConfig* config = GetConfig();
        handler.PSendSysMessage("|cffffd100[Barrens Front stats]|r %s - target %u bots per side",
                                watched ? "players present" : "nobody watching",
                                watched ? config->rvrFrontBotsActive : config->rvrFrontBotsIdle);
        for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
        {
            const RvRObjective& o = m_rvrObjectives[i];
            const uint32 pct = std::min<uint32>(100, o.progress * 100 / std::max<uint32>(1, config->rvrCaptureTime * IN_MILLISECONDS));
            handler.PSendSysMessage("  %s: %s%s", o.name, TeamName(o.owner),
                                    o.capTeam && o.capTeam != o.owner ? (std::string(" (") + TeamName(o.capTeam) + " capturing " + std::to_string(pct) + "%)").c_str() : "");
        }

        const char* orderNames[5] = { "Kolkar", "Oasis", "Raptor", "home", "enemy base" };
        for (int side = 0; side < 2; ++side)
        {
            handler.PSendSysMessage("  %s: %u players, %u bots (%u in lake, %u fighting, %u dead) - orders: %s %u, %s %u, %s %u, %s %u, %s %u",
                                    TeamName(side == 0 ? ALLIANCE : HORDE), players[side], roster[side], inLake[side], fighting[side], dead[side],
                                    orderNames[0], orders[side][0], orderNames[1], orders[side][1], orderNames[2], orders[side][2],
                                    orderNames[3], orders[side][3], orderNames[4], orders[side][4]);
        }

        handler.PSendSysMessage("  Domination: %d%% (%s)", std::abs(int32(m_rvrDom)) / 100, m_rvrDom > 0 ? "Alliance" : (m_rvrDom < 0 ? "Horde" : "even"));
        handler.PSendSysMessage("  Siege: %s  Lock: %s (%us)  Last hour: %u captures, %u sieges",
                                TeamName(m_rvrSiegeTeam), TeamName(m_rvrLockTeam), m_rvrLockUntil > now ? uint32(m_rvrLockUntil - now) : 0,
                                uint32(m_rvrCaptureLog.size()), uint32(m_rvrSiegeLog.size()));
    }

    // ------------------------------------------------------------------ spirit waves
    void RenownModule::RvRSpiritWave(const std::vector<Player*>& players)
    {
        for (Player* player : players)
        {
            if (!RenownPlayerOk(player))
                continue;
            const bool frontZone = (player->GetMapId() == RVR_MAP && player->GetZoneId() == 17) || (player->GetMapId() == 0 && player->GetZoneId() == 139);
            if (!frontZone || player->IsAlive() ||
                !player->HasFlag(PLAYER_FLAGS, PLAYER_FLAGS_GHOST) || !player->GetMap())
            {
                continue;
            }

            const WorldSafeLocsEntry* graveyard = player->GetMap()->GetGraveyardManager().GetClosestGraveYard(
                player->GetPositionX(), player->GetPositionY(), player->GetPositionZ(), player->GetMapId(), player->GetTeam());
            if (!graveyard)
            {
                continue;
            }

            // Front bots don't wait at the spirit healer on their own (they run back to their corpse), so the wave
            // collects them wherever their ghost is and brings them back at their side's graveyard, like in a battleground
            bool frontBot = !player->isRealPlayer() && (m_rvrDirectedBots.count(player->GetObjectGuid().GetCounter()) || m_t4Directed.count(player->GetObjectGuid().GetCounter()));
            if (!frontBot && !player->isRealPlayer())
            {
                std::lock_guard<std::mutex> lock(m_frontMutex);
                frontBot = FrontIsWarbandBot(player->GetObjectGuid().GetCounter());
            }
            const float dx = player->GetPositionX() - graveyard->x, dy = player->GetPositionY() - graveyard->y;
            if (!frontBot && dx * dx + dy * dy > 25.0f * 25.0f)
            {
                continue;
            }

            player->ResurrectPlayer(1.0f, false);
            player->SpawnCorpseBones();
            FrontProtect(player);
            if (frontBot && dx * dx + dy * dy > 25.0f * 25.0f)
            {
                player->TeleportTo(graveyard->map_id, graveyard->x, graveyard->y, graveyard->z, player->GetOrientation());
            }
            if (player->isRealPlayer())
            {
                ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r The spirit healer returns you to the fight.");
            }
        }
    }

    // ------------------------------------------------------------------ field mounts
    uint32 RenownModule::FieldMountSpell(const Player* player)
    {
        switch (player->getRace())
        {
            case RACE_HUMAN:    return 458;     // Brown Horse
            case RACE_ORC:      return 580;     // Timber Wolf
            case RACE_DWARF:    return 6777;    // Gray Ram
            case RACE_NIGHTELF: return 10789;   // Spotted Frostsaber
            case RACE_UNDEAD:   return 8980;    // Skeletal Horse
            case RACE_TAUREN:   return 18990;   // Brown Kodo
            case RACE_GNOME:    return 10873;   // Red Mechanostrider
            case RACE_TROLL:    return 10796;   // Turquoise Raptor
            default:            return 458;
        }
    }

    bool RenownModule::CastFieldMount(Player* player, bool instant)
    {
        const uint32 spellId = FieldMountSpell(player);
        if (!sSpellTemplate.LookupEntry<SpellEntry>(spellId))
        {
            return false;
        }

        // Same mount spell, but +X% speed instead of the normal 60% (the speed effect is index 1)
        const int32 speed = int32(GetConfig()->fieldMountSpeed) - 1;
        return player->CastCustomSpell(player, spellId, nullptr, &speed, nullptr, instant ? TRIGGERED_OLD_TRIGGERED : TRIGGERED_NONE) == SPELL_CAST_OK;
    }

    void RenownModule::UpdateBotMounts(const std::vector<Player*>& players)
    {
        if (!GetConfig()->fieldMountBots)
        {
            return;
        }

        for (Player* player : players)
        {
            if (!RenownPlayerOk(player))
                continue;
            if (player->isRealPlayer() || player->GetLevel() > GetConfig()->fieldMountMaxLevel || player->GetMapId() != RVR_MAP)
            {
                continue;
            }

            if (player->GetZoneId() != 17 && !RvRIsMember(player->GetObjectGuid().GetCounter()))
            {
                continue;   // the Barrens only
            }

            if (!player->IsAlive() || player->IsInCombat() || player->IsMounted() || !player->IsMoving() || player->IsInWater() ||
                player->InBattleGround() || player->IsTaxiFlying() || m_rvrChickens.count(player->GetObjectGuid().GetCounter()))
            {
                continue;
            }

            CastFieldMount(player, true);
        }
    }

    bool RenownModule::HandleMountCommand(WorldSession* session, const std::string& args)
    {
        Player* player = session ? session->GetPlayer() : nullptr;
        if (!player || !GetConfig()->enabled)
        {
            return false;
        }

        ChatHandler handler(player);
        if (player->IsMounted())
        {
            player->RemoveSpellsCausingAura(SPELL_AURA_MOUNTED);
            return true;
        }

        if (!GetConfig()->fieldMount)
        {
            handler.PSendSysMessage("Field mounts are disabled.");
            return true;
        }

        if (player->GetLevel() > GetConfig()->fieldMountMaxLevel && !player->IsGameMaster())
        {
            handler.PSendSysMessage("|cffffd100[Renown]|r The field mount is for levels 1-%u. Visit a mount vendor for a real one!", GetConfig()->fieldMountMaxLevel);
            return true;
        }

        if (m_rvrChickens.count(player->GetObjectGuid().GetCounter()))
        {
            handler.PSendSysMessage("|cffffd100[Renown]|r Chickens can't ride.");
            return true;
        }

        if (player->IsInCombat() || !player->IsAlive() || player->IsTaxiFlying())
        {
            handler.PSendSysMessage("|cffffd100[Renown]|r You can't mount right now.");
            return true;
        }

        CastFieldMount(player, false);   // normal cast: cast bar, outdoors only (errors come from the spell itself)
        return true;
    }

    // ------------------------------------------------------------------ main loop
    void RenownModule::OnUpdate(uint32 elapsed)
    {
        if (!GetConfig()->enabled || !GetConfig()->rvrEnabled || m_rvrObjectives.size() != 3)
        {
            return;
        }

        m_rvrTimer += elapsed;
        if (m_rvrTimer < IN_MILLISECONDS)
        {
            return;
        }

        const uint32 diff = m_rvrTimer;
        m_rvrTimer = 0;
        if (m_rvrResetRequested)
        {
            m_rvrResetRequested = false;
            RvRReset();
        }

        QuestsUpdate(diff);
        RvRUpdate(diff);
        T4Update(diff);
    }

    void RenownModule::RvRUpdate(uint32 diff)
    {
        const RenownModuleConfig* config = GetConfig();

        std::vector<Player*> players;
        {
            HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
            players.reserve(sObjectAccessor.GetPlayers().size());
            for (const auto& entry : sObjectAccessor.GetPlayers())
            {
                if (entry.second && entry.second->IsInWorld() && !entry.second->IsBeingTeleported())
                {
                    players.push_back(entry.second);
                }
            }
        }

        // Membership: who is inside the lake
        std::unordered_set<uint32> seen;
        std::vector<Player*> members;
        for (Player* player : players)
        {
            if (!RenownPlayerOk(player))
                continue;
            const uint32 playerId = player->GetObjectGuid().GetCounter();
            const bool inside = RvRInLakeArea(player);
            const bool member = RvRIsMember(playerId);
            if (inside && !member)
            {
                RvREnterLake(player);
            }
            else if (!inside && member)
            {
                RvRLeaveLake(player);
            }

            if (inside)
            {
                seen.insert(playerId);
                members.push_back(player);
                if (player->isRealPlayer() && m_questsReady && player->IsAlive())
                {
                    // war board: scout the three objectives
                    for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
                    {
                        const float dx = player->GetPositionX() - m_rvrObjectives[i].x, dy = player->GetPositionY() - m_rvrObjectives[i].y;
                        if (dx * dx + dy * dy <= 30.0f * 30.0f)
                        {
                            QuestCredit(player, 190825 + uint32(i));
                        }
                    }
                }

                if (!player->IsPvP())
                {
                    player->UpdatePvP(true, true);   // always flagged on the front
                }

                if (m_rvrChickens.count(playerId))
                {
                    // keep the chicken a chicken (other effects may clear these)
                    if (player->GetDisplayId() != RVR_CHICKEN_DISPLAY)
                    {
                        player->SetDisplayId(RVR_CHICKEN_DISPLAY);
                    }

                    player->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PACIFIED | UNIT_FLAG_SILENCED);
                }
            }
        }

        // Players that logged out or vanished while inside
        for (auto itr = m_rvrMembers.begin(); itr != m_rvrMembers.end();)
        {
            if (!seen.count(*itr))
            {
                m_rvrChickens.erase(*itr);
                {
                    std::lock_guard<std::mutex> lock(m_frontMutex);
                    m_frontSessions.erase(*itr);
                }
                itr = m_rvrMembers.erase(itr);
            }
            else
            {
                ++itr;
            }
        }

        // Locked: wait for the reset
        if (m_rvrLockTeam)
        {
            if (time(nullptr) >= m_rvrLockUntil)
            {
                RvRReset();
                RvRAnnounce("|cffffd100[Barrens Front]|r The front is open again. All objectives are neutral.", true);
            }
        }
        else
        {
            // Captures
            const float radius = (float)config->rvrCaptureRadius;
            const uint32 captureMs = config->rvrCaptureTime * IN_MILLISECONDS;
            for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
            {
                RvRObjective& o = m_rvrObjectives[i];
                std::vector<Player*> nearby[2];
                for (Player* player : members)
                {
                    if (!RenownPlayerOk(player))
                        continue;
                    if (!player->IsAlive() || m_rvrChickens.count(player->GetObjectGuid().GetCounter()) || player->IsGameMaster())
                    {
                        continue;
                    }

                    const float dx = player->GetPositionX() - o.x, dy = player->GetPositionY() - o.y;
                    if (dx * dx + dy * dy <= radius * radius && std::fabs(player->GetPositionZ() - o.z) < 20.0f)
                    {
                        nearby[player->GetTeam() == ALLIANCE ? 0 : 1].push_back(player);
                    }
                }

                uint32 team = 0;
                if (!nearby[0].empty() && nearby[1].empty())
                {
                    team = ALLIANCE;
                }
                else if (nearby[0].empty() && !nearby[1].empty())
                {
                    team = HORDE;
                }

                // The lane is taken in order: own tower -> Oasis -> enemy tower
                const size_t ownTower = team == HORDE ? 0 : 2;
                const size_t needs = !team || i == ownTower ? i : (i == 1 ? ownTower : 1);
                const bool allowed = team && (needs == i || m_rvrObjectives[needs].owner == team);
                if (team && team != o.owner && !allowed)
                {
                    // Tell players why nothing happens (at most every 30 seconds each)
                    const time_t now = time(nullptr);
                    for (Player* player : nearby[team == ALLIANCE ? 0 : 1])
                    {
                        time_t& last = m_rvrHintTime[player->GetObjectGuid().GetCounter()];
                        if (player->isRealPlayer() && now - last >= 30)
                        {
                            last = now;
                            ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r Push along the lane: the %s must hold %s before it can capture %s.",
                                                                TeamName(team), m_rvrObjectives[needs].name, o.name);
                        }
                    }
                }

                if (team && team != o.owner && allowed)
                {
                    if (o.capTeam != team)
                    {
                        o.capTeam = team;
                        o.progress = 0;
                        FrontOnAssault(i, team);
                    }

                    o.progress += uint32(diff * FrontCaptureRate(i, team));
                    m_rvrDirty = true;
                    if (o.progress >= captureMs)
                    {
                        const uint32 previous = o.owner;
                        RvRSetOwner(i, team);
                        m_rvrCaptureLog.push_back(time(nullptr));
                        FrontOnCapture(i, team, previous, nearby[team == ALLIANCE ? 0 : 1]);
                        RvRDominate(team, 500);

                        for (Player* player : nearby[team == ALLIANCE ? 0 : 1])
                        {
                            AddRenown(player, config->rvrCapturePoints);
                            QuestCredit(player, 190820);   // war board: capture
                        }
                    }
                }
                else if (!nearby[0].empty() && !nearby[1].empty())
                {
                    // contested: progress holds
                }
                else if (o.progress > 0)
                {
                    o.progress = o.progress > diff ? o.progress - diff : 0;
                    if (!o.progress)
                    {
                        o.capTeam = 0;
                    }

                    m_rvrDirty = true;
                }
            }

            // Domination: every held objective pushes the bar (towers 0.4%, the Oasis 0.6% every 5 seconds)
            m_rvrDomTimer += diff;
            if (m_rvrDomTimer >= 5 * IN_MILLISECONDS)
            {
                m_rvrDomTimer = 0;
                for (size_t i = 0; i < m_rvrObjectives.size(); ++i)
                {
                    if (m_rvrObjectives[i].owner)
                    {
                        RvRDominate(m_rvrObjectives[i].owner, m_rvrObjectives[i].tower ? 40 : 60);
                    }
                }
            }

            // A full bar opens the siege; the siege breaks if the enemy pushes the bar back below 75%
            const int32 dom = m_rvrDom;
            const uint32 full = dom >= 10000 ? ALLIANCE : (dom <= -10000 ? HORDE : 0);
            if (!m_rvrSiegeTeam && full)
            {
                RvRStartSiege(full);
            }
            else if (m_rvrSiegeTeam && (m_rvrSiegeTeam == ALLIANCE ? dom : -dom) < 7500)
            {
                std::ostringstream text;
                text << "|cffffd100[Barrens Front]|r The " << TeamName(m_rvrSiegeTeam) << " siege has been broken. The commander retreats.";
                RvRStopSiege();
                RvRAnnounce(text.str());
            }

            if (dom / 100 != m_rvrDomSent)
            {
                m_rvrDomSent = dom / 100;
                m_rvrDirty = true;
            }

            // Renown ticks for holding objectives
            m_rvrTickTimer += diff;
            if (m_rvrTickTimer >= MINUTE * IN_MILLISECONDS)
            {
                m_rvrTickTimer = 0;
                for (Player* player : members)
                {
                    if (!RenownPlayerOk(player))
                        continue;
                    if (m_rvrChickens.count(player->GetObjectGuid().GetCounter()))
                    {
                        continue;
                    }

                    const uint32 owned = RvROwnedBy(player->GetTeam());
                    if (owned && config->rvrTickPoints)
                    {
                        AddRenown(player, config->rvrTickPoints * owned);
                    }
                }
            }

            // Bots keep the front busy
            m_rvrMountTimer += diff;
            if (m_rvrMountTimer >= 5 * IN_MILLISECONDS)
            {
                m_rvrMountTimer = 0;
                UpdateBotMounts(players);
                RvRDirectBots(players);
            }

            m_rvrBotTimer += diff;
            if (m_rvrBotTimer >= 30 * IN_MILLISECONDS)
            {
                m_rvrBotTimer = 0;
                RvRReinforce(players);
            }
        }

        // Battleground-style resurrection waves at the Barrens graveyards
        if (config->rvrSpiritWave)
        {
            m_rvrSpiritTimer += diff;
            if (m_rvrSpiritTimer >= config->rvrSpiritWave * IN_MILLISECONDS)
            {
                m_rvrSpiritTimer = 0;
                RvRSpiritWave(players);
            }
        }

        // Field orders, caravans, heroes, underdog, warbands, criers...
        FrontUpdate(diff, players, members);

        // Status for the addon
        m_rvrStatusTimer += diff;
        if (m_rvrDirty || m_rvrStatusTimer >= 3 * IN_MILLISECONDS)
        {
            m_rvrDirty = false;
            m_rvrStatusTimer = 0;
            // Everyone on the front plus the rest of the Barrens (for the world map banners)
            for (Player* player : players)
            {
                if (!RenownPlayerOk(player))
                    continue;
                if (player->isRealPlayer() && player->GetMapId() == RVR_MAP &&
                    (player->GetZoneId() == 17 || RvRIsMember(player->GetObjectGuid().GetCounter())))
                {
                    RvRSendStatus(player);
                }
            }
        }
    }

    void RenownModule::OnKill(Unit* unit, Unit* victim)
    {
        if (!victim || victim->GetTypeId() != TYPEID_UNIT || !m_rvrSiegeTeam || m_rvrLockTeam)
        {
            return;
        }

        const uint32 entry = victim->GetEntry();
        if ((entry == RVR_COMMANDER_ALLIANCE && m_rvrSiegeTeam == HORDE) || (entry == RVR_COMMANDER_HORDE && m_rvrSiegeTeam == ALLIANCE))
        {
            if (Player* player = unit ? unit->GetBeneficiaryPlayer() : nullptr)
            {
                AddRenown(player, 100);
            }

            RvRLock(m_rvrSiegeTeam);
        }
    }

    // ------------------------------------------------------------------ commands
    bool RenownModule::HandleRvRCommand(WorldSession* session, const std::string& args)
    {
        Player* player = session ? session->GetPlayer() : nullptr;
        if (!player || !GetConfig()->enabled)
        {
            return false;
        }

        ChatHandler handler(player);
        if (!GetConfig()->rvrEnabled || m_rvrObjectives.size() != 3)
        {
            handler.PSendSysMessage("The Barrens Front is not available.");
            return true;
        }

        const uint32 playerId = player->GetObjectGuid().GetCounter();
        if (args == "join" || args.empty())
        {
            if (player->GetLevel() > GetConfig()->rvrMaxLevel && !player->IsGameMaster())
            {
                handler.PSendSysMessage("|cffffd100[Barrens Front]|r This tier 1 battlefield is for levels 1-%u.", GetConfig()->rvrMaxLevel);
                return true;
            }

            if (player->InBattleGround() || player->IsInCombat() || !player->IsAlive() || player->IsTaxiFlying() || player->GetMap()->Instanceable())
            {
                handler.PSendSysMessage("|cffffd100[Barrens Front]|r You can't travel to the front right now (in combat, dead, flying, in a battleground or an instance).");
                return true;
            }

            if (!RvRIsMember(playerId) && !RvRInLakeArea(player))
            {
                std::lock_guard<std::mutex> lock(m_rvrReturnMutex);
                m_rvrReturn[playerId] = WorldLocation(player->GetMapId(), player->GetPositionX(), player->GetPositionY(), player->GetPositionZ(), player->GetOrientation());
            }

            const bool alliance = player->GetTeam() == ALLIANCE;
            const Point& p = alliance ? RVR_ALLIANCE_ARRIVAL : RVR_HORDE_ARRIVAL;
            player->TeleportTo(RVR_MAP, p.x, p.y, p.z, alliance ? RVR_ALLIANCE_ARRIVAL_O : RVR_HORDE_ARRIVAL_O);
            handler.PSendSysMessage("|cffffd100[Barrens Front]|r Off to %s. The front lies %s.", alliance ? "Northwatch Hold" : "the Crossroads",
                                    alliance ? "to the north, past the Raptor Grounds" : "to the southeast, past Kolkar Watch");
            return true;
        }

        if (args == "stats")
        {
            if (session->GetSecurity() < SEC_GAMEMASTER)
            {
                return false;
            }

            RvRStats(handler);
            return true;
        }

        if (args == "leave")
        {
            if (player->IsInCombat() || player->InBattleGround() || player->IsTaxiFlying())
            {
                handler.PSendSysMessage("|cffffd100[Barrens Front]|r You can't leave right now.");
                return true;
            }

            bool found = false;
            WorldLocation loc;
            {
                std::lock_guard<std::mutex> lock(m_rvrReturnMutex);
                auto itr = m_rvrReturn.find(playerId);
                if (itr != m_rvrReturn.end())
                {
                    loc = itr->second;
                    m_rvrReturn.erase(itr);
                    found = true;
                }
            }

            if (found)
            {
                player->TeleportTo(loc.mapid, loc.coord_x, loc.coord_y, loc.coord_z, loc.orientation);
            }
            else
            {
                player->TeleportToHomebind();
            }

            return true;
        }

        if (args == "status")
        {
            std::ostringstream text;
            text << "|cffffd100[Barrens Front]|r";
            for (const RvRObjective& o : m_rvrObjectives)
            {
                text << " " << o.name << ": " << TeamName(o.owner) << ".";
            }

            if (m_rvrSiegeTeam)
            {
                text << " Siege by the " << TeamName(m_rvrSiegeTeam) << "!";
            }

            if (m_rvrLockTeam)
            {
                text << " Locked by the " << TeamName(m_rvrLockTeam) << " for " << uint32((m_rvrLockUntil - time(nullptr)) / MINUTE + 1) << " more minutes.";
            }

            handler.PSendSysMessage("%s", text.str().c_str());
            RvRSendStatus(player);
            return true;
        }

        if (args == "reset" && session->GetSecurity() >= SEC_GAMEMASTER)
        {
            m_rvrResetRequested = true;   // done on the world thread
            handler.PSendSysMessage("Barrens Front will reset in a moment.");
            return true;
        }

        handler.PSendSysMessage("Usage: .renown rvr join | leave | status");
        return true;
    }

    bool RenownModule::HandleQueueCommand(WorldSession* session, const std::string& args)
    {
        Player* player = session ? session->GetPlayer() : nullptr;
        if (!player || !GetConfig()->enabled)
        {
            return false;
        }

        uint32 mapId = 0;
        if (args == "wsg" || args == "warsong")
        {
            mapId = 489;
        }
        else if (args == "ab" || args == "arathi")
        {
            mapId = 529;
        }
        else if (args == "av" || args == "alterac")
        {
            mapId = 30;
        }

        if (!mapId)
        {
            ChatHandler(player).PSendSysMessage("Usage: .renown queue wsg | ab | av");
            return true;
        }

        if (player->InBattleGround())
        {
            ChatHandler(player).PSendSysMessage("You are already in a battleground.");
            return true;
        }

        const Group* group = player->GetGroup();
        const uint8 asGroup = (group && group->IsLeader(player->GetObjectGuid())) ? 1 : 0;

        // The same request the client sends from a battlemaster, with the player's own guid (allowed by the core patch)
        WorldPacket data(CMSG_BATTLEMASTER_JOIN, 8 + 4 + 4 + 1);
        data << player->GetObjectGuid();
        data << uint32(mapId);
        data << uint32(0);
        data << uint8(asGroup);
        session->HandleBattlemasterJoinOpcode(data);
        return true;
    }
}
