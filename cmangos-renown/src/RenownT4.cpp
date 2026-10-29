// Plaguelands Front: tier 4 RvR at level 60 in the Eastern Plaguelands.
//
// The four towers are the 1.12 world PvP towers run by the core (outdoor PvP "EP"): capture bars, tower perks and
// the Echoes of Lordaeron buff all come from there. This file adds the Renown war on top:
//   * Renown for captures nearby and for every tower held (each minute)
//   * Keeps: Darrowshire (Alliance) and Northdale (Horde). Hold three towers for SiegeHold seconds and the enemy keep
//     lord takes the field; kill him to win the Plaguelands
//   * Victory: loot bags, a lock of LockMinutes, and Darkness Falls: Stratholme opens only to the winning side until
//     the other side wins it back (game events 1130/1131 + the area trigger condition in zz_t4.sql)
//   * Bots: an enlisted roster of level 55-60 bots per side that follows a side plan (own towers, enemy towers,
//     siege, defend the keep), like the Barrens Front
//   * 55-59 are bolstered to 60, PvP is always on, spirit waves at the front graveyards (RenownRvR.cpp)
//   * In Stratholme the holders earn Renown for kills and loot bags from bosses

#include "RenownModule.h"

#include "Chat/Chat.h"
#include "Database/DatabaseEnv.h"
#include "Entities/Creature.h"
#include "Entities/Player.h"
#include "GameEvents/GameEventMgr.h"
#include "Globals/ObjectAccessor.h"
#include "Globals/ObjectMgr.h"
#include "Log/Log.h"
#include "Maps/Map.h"
#include "MotionGenerators/MotionMaster.h"
#include "OutdoorPvP/OutdoorPvPEP.h"
#include "OutdoorPvP/OutdoorPvPMgr.h"
#include "Server/WorldPacket.h"
#include "Server/WorldSession.h"
#include "World/World.h"

#include <algorithm>
#include <cmath>
#include <ctime>
#include <sstream>

#ifdef ENABLE_PLAYERBOTS
bool RenownBotFrontMode(Player* bot, bool on);   // playerbots patch
#endif

namespace cmangos_module
{
    namespace
    {
        const uint32 T4_MAP = 0;
        const uint32 T4_ZONE = 139;          // Eastern Plaguelands
        const uint32 T4_STRATHOLME = 329;
        const uint16 T4_EVENT_HELD_ALLIANCE = 1130;
        const uint16 T4_EVENT_HELD_HORDE = 1131;
        const uint16 T4_EVENT_KEEPS_CLEARED = 1132;
        const uint32 T4_LORD_ALLIANCE = 190850;   // Marshal of Darrowshire
        const uint32 T4_LORD_HORDE = 190851;      // Warlord of Northdale

        struct T4Point { const char* name; float x, y, z; };

        // Core tower ids: 0 Northpass, 1 Crown Guard, 2 Eastwall, 3 Plaguewood (capture flags' centre)
        const T4Point T4_TOWERS[4] =
        {
            { "Northpass Tower",   3168.0f, -4362.0f, 145.0f },
            { "Crown Guard Tower", 1858.0f, -3710.0f, 167.0f },
            { "Eastwall Tower",    2555.0f, -4787.0f, 115.0f },
            { "Plaguewood Tower",  2984.0f, -3041.0f, 125.0f },
        };

        // Order in which each side pushes: its own side of the zone first
        const uint32 T4_ORDER_ALLIANCE[4] = { 1, 3, 2, 0 };
        const uint32 T4_ORDER_HORDE[4] = { 0, 2, 3, 1 };

        const T4Point T4_KEEP_ALLIANCE = { "Darrowshire", 1467.0f, -3717.0f, 80.2f };
        const T4Point T4_KEEP_HORDE    = { "Northdale",   2992.0f, -5005.0f, 104.7f };

        const uint32 SOUND_CAPTURED_ALLIANCE = 8173, SOUND_CAPTURED_HORDE = 8213;
        const uint32 SOUND_NEAR_VICTORY_ALLIANCE = 8457, SOUND_NEAR_VICTORY_HORDE = 8456;
        const uint32 SOUND_WIN_ALLIANCE = 8455, SOUND_WIN_HORDE = 8454;

        enum { ORDER_HOME = 4, ORDER_ENEMY_KEEP = 5, ORDER_NONE = 255 };

        const char* SideName(uint32 team) { return team == ALLIANCE ? "the Alliance" : (team == HORDE ? "the Horde" : "nobody"); }
        const char* SideNameCap(uint32 team) { return team == ALLIANCE ? "The Alliance" : "The Horde"; }
        const T4Point& KeepOf(uint32 team) { return team == ALLIANCE ? T4_KEEP_ALLIANCE : T4_KEEP_HORDE; }

        bool InPlaguelands(const Player* player)
        {
            return player && player->IsInWorld() && player->GetMapId() == T4_MAP && player->GetZoneId() == T4_ZONE;
        }

        void BotFrontMode(Player* bot, bool on)
        {
#ifdef ENABLE_PLAYERBOTS
            RenownBotFrontMode(bot, on);
#else
            (void)bot; (void)on;
#endif
        }

        void SendAddonText(Player* player, const std::string& message)
        {
            WorldPacket packet;
            ChatHandler::BuildChatPacket(packet, CHAT_MSG_PARTY, message.c_str(), LANG_ADDON, CHAT_TAG_NONE, player->GetObjectGuid(), player->GetName());
            player->GetSession()->SendPacket(packet);
        }

        float Dist2(float ax, float ay, float bx, float by) { return (ax - bx) * (ax - bx) + (ay - by) * (ay - by); }
    }

    // ------------------------------------------------------------------ setup
    void RenownModule::T4Init()
    {
        m_t4Ready = false;
        if (!GetConfig()->t4Enabled)
        {
            return;
        }

        for (uint16 e : { T4_EVENT_HELD_ALLIANCE, T4_EVENT_HELD_HORDE, T4_EVENT_KEEPS_CLEARED })
        {
            if (!sGameEventMgr.IsValidEvent(e))
            {
                sLog.outError("Renown: game event %u is missing (zz_t4.sql not applied?), the Plaguelands Front is disabled", e);
                return;
            }
        }

        if (!sOutdoorPvPMgr.GetScript(T4_ZONE))
        {
            sLog.outError("Renown: Eastern Plaguelands outdoor PvP is off (OutdoorPvp.EPEnabled), the Plaguelands Front is disabled");
            return;
        }

        if (!sGameEventMgr.IsActiveEvent(T4_EVENT_KEEPS_CLEARED))
        {
            sGameEventMgr.StartEvent(T4_EVENT_KEEPS_CLEARED, true);
        }

        // Who holds the Plaguelands (Darkness Falls) survives restarts
        uint32 holder = 0;
        if (auto result = CharacterDatabase.Query("SELECT `value` FROM `custom_renown_state` WHERE `name` = 't4_holder'"))
        {
            holder = result->Fetch()[0].GetUInt32();
        }

        m_t4Ready = true;
        T4SetHolder(holder == ALLIANCE || holder == HORDE ? holder : 0);
        sLog.outString("Renown: the Plaguelands Front is open (Darkness Falls held by %s)", SideName(m_t4Holder));
    }

    uint32 RenownModule::T4TowerOwner(uint32 tower) const
    {
        OutdoorPvPEP* ep = static_cast<OutdoorPvPEP*>(sOutdoorPvPMgr.GetScript(T4_ZONE));
        if (!ep)
        {
            return 0;
        }

        const Team team = ep->GetTowerOwner(tower);
        return team == ALLIANCE ? ALLIANCE : (team == HORDE ? HORDE : 0);
    }

    uint32 RenownModule::T4OwnedBy(uint32 team) const
    {
        uint32 count = 0;
        for (uint32 i = 0; i < 4; ++i)
        {
            if (T4TowerOwner(i) == team)
            {
                ++count;
            }
        }

        return count;
    }

    void RenownModule::T4SetHolder(uint32 team)
    {
        m_t4Holder = team;
        if (team == ALLIANCE && !sGameEventMgr.IsActiveEvent(T4_EVENT_HELD_ALLIANCE))
        {
            sGameEventMgr.StartEvent(T4_EVENT_HELD_ALLIANCE, true);
        }
        else if (team != ALLIANCE && sGameEventMgr.IsActiveEvent(T4_EVENT_HELD_ALLIANCE))
        {
            sGameEventMgr.StopEvent(T4_EVENT_HELD_ALLIANCE, true);
        }

        if (team == HORDE && !sGameEventMgr.IsActiveEvent(T4_EVENT_HELD_HORDE))
        {
            sGameEventMgr.StartEvent(T4_EVENT_HELD_HORDE, true);
        }
        else if (team != HORDE && sGameEventMgr.IsActiveEvent(T4_EVENT_HELD_HORDE))
        {
            sGameEventMgr.StopEvent(T4_EVENT_HELD_HORDE, true);
        }

        CharacterDatabase.PExecute("REPLACE INTO `custom_renown_state` (`name`, `value`) VALUES ('t4_holder', '%u')", team);
    }

    // ------------------------------------------------------------------ announcements
    void RenownModule::T4FX(const std::string& text, uint32 team, uint32 sound)
    {
        HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
        for (const auto& entry : sObjectAccessor.GetPlayers())
        {
            Player* player = entry.second;
            if (!player || !player->isRealPlayer() || !InPlaguelands(player) || (team && player->GetTeam() != team))
            {
                continue;
            }

            SendAddonText(player, "RENOWNFX\t" + text);
            ChatHandler(player).PSendSysMessage("|cffffd100[Plaguelands Front]|r %s", text.c_str());
            if (sound)
            {
                player->PlayDirectSound(sound, PlayPacketParameters(PlayPacketSettings::TARGET, player));
            }
        }
    }

    // ------------------------------------------------------------------ entering / leaving
    void RenownModule::T4Enter(Player* player)
    {
        const uint32 playerId = player->GetObjectGuid().GetCounter();
        m_t4Members.insert(playerId);
        player->UpdatePvP(true, true);

        const uint32 level = player->GetLevel();
        if (level >= GetConfig()->t4MinLevel && level < 60 && GetConfig()->bolsterEnabled && !player->InBattleGround())
        {
            {
                std::lock_guard<std::mutex> lock(m_bolsterMutex);
                m_bolster[playerId] = 60;
            }

            ApplyLevelStats(player, 60);
            if (player->isRealPlayer())
            {
                ChatHandler(player).PSendSysMessage("|cff00ccffBolster:|r you fight as a level 60 on the Plaguelands Front.");
            }
        }

        if (player->isRealPlayer())
        {
            ChatHandler(player).PSendSysMessage("|cffffd100[Plaguelands Front]|r Tier 4 RvR: take the towers, hold three to besiege the enemy keep (%s holds Darrowshire, the Horde Northdale). Darkness Falls is held by %s.",
                                                "the Alliance", SideName(m_t4Holder));
        }
    }

    void RenownModule::T4Leave(Player* player)
    {
        const uint32 playerId = player->GetObjectGuid().GetCounter();
        m_t4Members.erase(playerId);
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
    }

    // ------------------------------------------------------------------ update (once a second, from RvRUpdate's timer)
    void RenownModule::T4Update(uint32 diff)
    {
        if (!m_t4Ready)
        {
            // First update after the world is up (outdoor PvP and game events are loaded by then)
            if (!m_t4Tried)
            {
                m_t4Tried = true;
                T4Init();
            }

            if (!m_t4Ready)
            {
                return;
            }
        }

        const RenownModuleConfig* config = GetConfig();
        const time_t now = time(nullptr);

        std::vector<Player*> players, members;
        {
            HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
            for (const auto& entry : sObjectAccessor.GetPlayers())
            {
                if (entry.second && entry.second->IsInWorld() && !entry.second->IsBeingTeleported())
                {
                    players.push_back(entry.second);
                }
            }
        }

        // Membership
        bool watched = false;
        std::unordered_set<uint32> seen;
        for (Player* player : players)
        {
            const uint32 id = player->GetObjectGuid().GetCounter();
            const bool inside = InPlaguelands(player);
            if (inside && !T4IsMember(id))
            {
                T4Enter(player);
            }
            else if (!inside && T4IsMember(id))
            {
                T4Leave(player);
            }

            if (inside)
            {
                seen.insert(id);
                members.push_back(player);
                if (!player->IsPvP())
                {
                    player->UpdatePvP(true, true);
                }

                if (player->isRealPlayer())
                {
                    watched = true;
                }
            }
        }

        for (auto it = m_t4Members.begin(); it != m_t4Members.end();)
        {
            it = seen.count(*it) ? std::next(it) : m_t4Members.erase(it);
        }

        // Tower changes (the core runs the capture)
        for (uint32 i = 0; i < 4; ++i)
        {
            const uint32 owner = T4TowerOwner(i);
            if (owner == m_t4LastOwner[i])
            {
                continue;
            }

            m_t4LastOwner[i] = owner;
            if (!owner)
            {
                continue;
            }

            const T4Point& t = T4_TOWERS[i];
            for (Player* p : members)
            {
                if (p->GetTeam() == owner && p->IsAlive() && Dist2(p->GetPositionX(), p->GetPositionY(), t.x, t.y) <= 80.0f * 80.0f)
                {
                    AddRenown(p, config->t4CapturePoints);
                }
            }

            T4FX(std::string(SideNameCap(owner)) + " has taken " + t.name + "!", 0, owner == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE);
        }

        // Lock after a victory
        if (m_t4LockTeam && now >= m_t4LockUntil)
        {
            m_t4LockTeam = 0;
            T4FX("The Plaguelands Front is open again. Darkness Falls stays with " + std::string(SideName(m_t4Holder)) + " until the other side wins it.", 0, 0);
        }

        // Siege
        if (!m_t4LockTeam)
        {
            const uint32 a = T4OwnedBy(ALLIANCE), h = T4OwnedBy(HORDE);
            const uint32 dominant = a >= 3 ? ALLIANCE : (h >= 3 ? HORDE : 0);
            if (m_t4SiegeTeam)
            {
                if (dominant != m_t4SiegeTeam)
                {
                    T4StopSiege(true);
                }
                else if (Map* map = members.empty() ? nullptr : members.front()->GetMap())
                {
                    Creature* lord = m_t4Lord.IsEmpty() ? nullptr : map->GetCreature(m_t4Lord);
                    if (lord)
                    {
                        m_t4LordPos[0] = lord->GetPositionX();
                        m_t4LordPos[1] = lord->GetPositionY();
                        if (!lord->IsAlive())
                        {
                            T4Victory(m_t4SiegeTeam, members);
                        }
                    }
                }
            }
            else if (dominant)
            {
                if (m_t4HoldTeam != dominant)
                {
                    m_t4HoldTeam = dominant;
                    m_t4HoldTime = 0;
                }

                m_t4HoldTime += diff;
                if (m_t4HoldTime >= config->t4SiegeHold * IN_MILLISECONDS)
                {
                    T4StartSiege(dominant, members);
                }
            }
            else
            {
                m_t4HoldTeam = 0;
                m_t4HoldTime = 0;
            }
        }

        // Renown for holding towers
        m_t4TickTimer += diff;
        if (m_t4TickTimer >= MINUTE * IN_MILLISECONDS)
        {
            m_t4TickTimer = 0;
            const uint32 owned[2] = { T4OwnedBy(ALLIANCE), T4OwnedBy(HORDE) };
            for (Player* p : members)
            {
                const uint32 n = owned[p->GetTeam() == ALLIANCE ? 0 : 1];
                if (n && config->t4TickPoints && p->GetLevel() >= config->t4MinLevel)
                {
                    AddRenown(p, config->t4TickPoints * n);
                }
            }
        }

        // Bots
        m_t4DirectTimer += diff;
        if (m_t4DirectTimer >= 5 * IN_MILLISECONDS)
        {
            m_t4DirectTimer = 0;
            T4Direct(players);
        }

        m_t4BotTimer += diff;
        if (m_t4BotTimer >= 30 * IN_MILLISECONDS)
        {
            m_t4BotTimer = 0;
            T4Reinforce(players, watched);
        }
    }

    // ------------------------------------------------------------------ siege and victory
    void RenownModule::T4StartSiege(uint32 team, const std::vector<Player*>& members)
    {
        // The enemy keep's lord takes the field
        const uint32 enemy = team == ALLIANCE ? HORDE : ALLIANCE;
        const T4Point& keep = KeepOf(enemy);
        Player* summoner = nullptr;
        for (Player* p : members)
        {
            if (p->GetMapId() == T4_MAP)
            {
                summoner = p;
                break;
            }
        }

        if (!summoner)
        {
            return;
        }

        float x = keep.x, y = keep.y, z = keep.z;
        summoner->UpdateAllowedPositionZ(x, y, z);
        Creature* lord = summoner->SummonCreature(enemy == ALLIANCE ? T4_LORD_ALLIANCE : T4_LORD_HORDE, x, y, z, 0.0f,
                                                  TEMPSPAWN_TIMED_OR_DEAD_DESPAWN, 3 * HOUR * IN_MILLISECONDS, true);
        if (!lord)
        {
            return;
        }

        m_t4Lord = lord->GetObjectGuid();
        m_t4SiegeTeam = team;
        m_t4SiegeStart = time(nullptr);
        m_t4HoldTeam = 0;
        m_t4HoldTime = 0;

        const uint32 sound = team == ALLIANCE ? SOUND_NEAR_VICTORY_ALLIANCE : SOUND_NEAR_VICTORY_HORDE;
        T4FX(std::string("Siege! Storm ") + keep.name + " and kill the " + (enemy == ALLIANCE ? "Marshal of Darrowshire" : "Warlord of Northdale") + "!", team, sound);
        T4FX(std::string(SideNameCap(team)) + " is besieging " + keep.name + "! Defend your keep lord!", enemy, sound);
        RvRAnnounce(std::string("|cffffd100[Plaguelands Front]|r ") + SideNameCap(team) + " is besieging " + keep.name + " in the Eastern Plaguelands!", true);
    }

    void RenownModule::T4StopSiege(bool announce)
    {
        if (!m_t4Lord.IsEmpty())
        {
            HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
            for (const auto& entry : sObjectAccessor.GetPlayers())
            {
                Player* p = entry.second;
                if (p && p->IsInWorld() && p->GetMapId() == T4_MAP && p->GetMap())
                {
                    if (Creature* lord = p->GetMap()->GetCreature(m_t4Lord))
                    {
                        lord->ForcedDespawn(1000);
                    }
                    break;
                }
            }
        }

        if (announce && m_t4SiegeTeam)
        {
            T4FX(std::string(SideNameCap(m_t4SiegeTeam)) + "'s siege is broken. The keep lord withdraws.", 0, 0);
        }

        m_t4Lord.Clear();
        m_t4SiegeTeam = 0;
    }

    void RenownModule::T4Victory(uint32 team, const std::vector<Player*>& members)
    {
        m_t4Lord.Clear();
        m_t4SiegeTeam = 0;
        m_t4LockTeam = team;
        m_t4LockUntil = time(nullptr) + GetConfig()->t4LockMinutes * MINUTE;
        T4SetHolder(team);

        T4FX(std::string(SideNameCap(team)) + " has won the Plaguelands! Darkness Falls: Stratholme now opens only to " + SideName(team) + ".", 0,
             team == ALLIANCE ? SOUND_WIN_ALLIANCE : SOUND_WIN_HORDE);
        RvRAnnounce(std::string("|cffffd100[Plaguelands Front]|r ") + SideNameCap(team) + " has won the Eastern Plaguelands! Stratholme is theirs (Darkness Falls).", true);

        // Every winner on the front gets a bag; those at the kill a better one
        for (Player* p : members)
        {
            if (p->GetTeam() != team || !p->isRealPlayer())
            {
                continue;
            }

            const bool atKill = Dist2(p->GetPositionX(), p->GetPositionY(), m_t4LordPos[0], m_t4LordPos[1]) <= 80.0f * 80.0f;
            GiveLootBag(p, atKill ? BAG_GOLD : BAG_PURPLE);
            AddRenown(p, atKill ? 300 : 150, false);
        }
    }

    // ------------------------------------------------------------------ bots
    void RenownModule::T4Reinforce(const std::vector<Player*>& players, bool watched)
    {
        const RenownModuleConfig* config = GetConfig();
        const uint32 share = std::min<uint32>(config->rvrBotShare, 100);
        if (!share)
        {
            return;
        }

        uint32 present[2] = { 0, 0 };
        std::vector<Player*> enlisted[2];
        for (Player* p : players)
        {
            if (!p->isRealPlayer() && m_t4Roster.count(p->GetObjectGuid().GetCounter()))
            {
                const int side = p->GetTeam() == ALLIANCE ? 0 : 1;
                ++present[side];
                enlisted[side].push_back(p);
            }
        }

        uint32 target = watched ? config->t4BotsActive : config->t4BotsIdle;
        if (m_t4LockTeam)
        {
            target = std::min(target, config->t4BotsIdle);
        }

        const uint32 wave = std::max<uint32>(1, config->rvrBotsPerWave);
        for (int side = 0; side < 2; ++side)
        {
            const uint32 team = side == 0 ? ALLIANCE : HORDE;
            if (present[side] > target + 4)
            {
                uint32 release = std::min<uint32>(present[side] - target, wave);
                for (Player* bot : enlisted[side])
                {
                    if (!release)
                    {
                        break;
                    }

                    if (bot->IsAlive() && !bot->IsInCombat() && !bot->IsTaxiFlying())
                    {
                        const uint32 id = bot->GetObjectGuid().GetCounter();
                        m_t4Roster.erase(id);
                        m_t4Orders.erase(id);
                        if (m_t4Directed.erase(id))
                        {
                            BotFrontMode(bot, false);
                        }
                        bot->TeleportToHomebind();
                        --release;
                    }
                }
                continue;
            }

            if (present[side] >= target || present[side] >= present[1 - side] + wave)
            {
                continue;
            }

            std::vector<Player*> candidates;
            for (Player* p : players)
            {
                const uint32 id = p->GetObjectGuid().GetCounter();
                if (p->isRealPlayer() || p->GetTeam() != team || p->GetLevel() < config->t4MinLevel || id % 100 >= share ||
                    m_t4Roster.count(id) || T4IsMember(id) || !p->IsAlive() || p->IsInCombat() || p->InBattleGround() ||
                    p->InBattleGroundQueue() || p->GetGroup() || p->IsTaxiFlying() || p->IsBeingTeleported() || !p->GetMap() ||
                    p->GetMap()->Instanceable())
                {
                    continue;
                }

                candidates.push_back(p);
            }

            const T4Point& base = KeepOf(team);
            uint32 need = std::min<uint32>(wave, target - present[side]);
            float sx = base.x, sy = base.y;
            for (uint32 n = 0; need > 0 && !candidates.empty(); ++n, --need)
            {
                if (n % 4 == 0)
                {
                    const float a = frand(0.0f, 6.28f), d = frand(4.0f, 14.0f);
                    sx = base.x + std::cos(a) * d;
                    sy = base.y + std::sin(a) * d;
                }

                const size_t pick = urand(0, uint32(candidates.size() - 1));
                Player* bot = candidates[pick];
                candidates.erase(candidates.begin() + pick);
                m_t4Roster.insert(bot->GetObjectGuid().GetCounter());
                float x = sx + frand(-2.5f, 2.5f), y = sy + frand(-2.5f, 2.5f), z = base.z;
                bot->UpdateAllowedPositionZ(x, y, z);
                bot->TeleportTo(T4_MAP, x, y, z + 0.5f, frand(0.0f, 6.28f));
            }
        }
    }

    void RenownModule::T4Direct(const std::vector<Player*>& players)
    {
        const RenownModuleConfig* config = GetConfig();
        uint32 owner[4];
        for (uint32 i = 0; i < 4; ++i)
        {
            owner[i] = T4TowerOwner(i);
        }

        // One plan per side
        uint8 attack[2] = { ORDER_NONE, ORDER_NONE };
        std::vector<uint8> held[2];
        bool homeUnderSiege[2] = { false, false };
        for (int side = 0; side < 2; ++side)
        {
            const uint32 team = side == 0 ? ALLIANCE : HORDE;
            const uint32* order = side == 0 ? T4_ORDER_ALLIANCE : T4_ORDER_HORDE;
            for (uint32 k = 0; k < 4; ++k)
            {
                if (owner[order[k]] == team)
                {
                    held[side].push_back(uint8(order[k]));
                }
                else if (attack[side] == ORDER_NONE)
                {
                    attack[side] = uint8(order[k]);
                }
            }

            if (m_t4LockTeam)
            {
                attack[side] = ORDER_HOME;
            }
            else if (m_t4SiegeTeam == team)
            {
                attack[side] = ORDER_ENEMY_KEEP;
            }

            homeUnderSiege[side] = m_t4SiegeTeam && m_t4SiegeTeam != team;
        }

        auto point = [&](uint32 team, uint8 order) -> T4Point
        {
            if (order < 4)
            {
                return T4_TOWERS[order];
            }

            return KeepOf(order == ORDER_HOME ? team : (team == ALLIANCE ? HORDE : ALLIANCE));
        };

        std::unordered_set<uint32> seen;
        for (Player* bot : players)
        {
            if (bot->isRealPlayer())
            {
                continue;
            }

            const uint32 id = bot->GetObjectGuid().GetCounter();
            seen.insert(id);
            const bool frontBot = m_t4Roster.count(id) && bot->GetLevel() >= config->t4MinLevel && !bot->InBattleGround() &&
                                  (InPlaguelands(bot) || bot->IsBeingTeleported());
            if (!frontBot)
            {
                if (m_t4Roster.count(id) && !bot->IsBeingTeleported())
                {
                    m_t4Roster.erase(id);
                }

                if (m_t4Directed.erase(id))
                {
                    m_t4Orders.erase(id);
                    BotFrontMode(bot, false);
                }
                continue;
            }

            m_t4Directed.insert(id);
            BotFrontMode(bot, true);

            if (!bot->IsAlive() || bot->IsInCombat() || bot->IsTaxiFlying() || bot->GetGroup() || !bot->IsStandState() ||
                bot->GetHealthPercent() < 50.0f || (bot->GetPowerType() == POWER_MANA && bot->GetMaxPower(POWER_MANA) > 0 &&
                bot->GetPower(POWER_MANA) * 100 < bot->GetMaxPower(POWER_MANA) * 30))
            {
                continue;
            }

            const int side = bot->GetTeam() == ALLIANCE ? 0 : 1;
            const uint32 role = (id / 100) % 10;
            uint8 order = ORDER_HOME;
            if (homeUnderSiege[side] && role < 4)
            {
                order = ORDER_HOME;                                       // defend the keep lord
            }
            else if (attack[side] != ORDER_NONE && (role < 8 || held[side].empty()))
            {
                order = attack[side];
            }
            else if (!held[side].empty())
            {
                order = held[side][id % held[side].size()];               // guard a tower
            }

            const T4Point target = point(bot->GetTeam(), order);
            const bool arrived = Dist2(bot->GetPositionX(), bot->GetPositionY(), target.x, target.y) <= 20.0f * 20.0f;
            auto it = m_t4Orders.find(id);
            const bool changed = it == m_t4Orders.end() || it->second != order;
            const bool idle = bot->GetMotionMaster()->GetCurrentMovementGeneratorType() == IDLE_MOTION_TYPE;
            if (!changed && (arrived || !idle))
            {
                continue;
            }

            m_t4Orders[id] = order;
            const float a = frand(0.0f, 6.28f), d = frand(3.0f, 14.0f);
            float x = target.x + std::cos(a) * d, y = target.y + std::sin(a) * d, z = target.z;
            bot->UpdateAllowedPositionZ(x, y, z);
            bot->GetMotionMaster()->MovePoint(0, x, y, z, FORCED_MOVEMENT_RUN);
        }

        for (auto it = m_t4Roster.begin(); it != m_t4Roster.end();)
        {
            if (!seen.count(*it))
            {
                m_t4Directed.erase(*it);
                m_t4Orders.erase(*it);
                it = m_t4Roster.erase(it);
            }
            else
            {
                ++it;
            }
        }
    }

    // ------------------------------------------------------------------ Darkness Falls rewards
    void RenownModule::OnRewardPlayerAtKill(Player* player, Unit* victim)
    {
        if (!player || !victim || !m_t4Ready || !m_t4Holder || victim->GetTypeId() != TYPEID_UNIT || !GetConfig()->enabled)
        {
            return;
        }

        if (player->GetMapId() != T4_STRATHOLME || player->GetTeam() != m_t4Holder || !player->isRealPlayer())
        {
            return;
        }

        const Creature* creature = static_cast<const Creature*>(victim);
        const CreatureInfo* info = creature->GetCreatureInfo();
        if (!info || info->Rank == CREATURE_ELITE_NORMAL)
        {
            return;
        }

        const bool boss = info->Rank == CREATURE_ELITE_WORLDBOSS || info->Rank == CREATURE_ELITE_RAREELITE || creature->GetLevel() >= 61;
        if (boss)
        {
            AddRenown(player, 40, false);
            ChatHandler(player).PSendSysMessage("|cffffd100[Darkness Falls]|r %s falls: +40 Renown for the masters of the Plaguelands.", creature->GetName());
            if (urand(1, 100) <= 25)
            {
                GiveLootBag(player, urand(0, 3) ? BAG_BLUE : BAG_PURPLE);
            }
        }
        else
        {
            AddRenown(player, 3, false);
        }
    }

    // ------------------------------------------------------------------ commands: .renown t4 [join|leave|status|stats]
    void RenownModule::T4Stats(ChatHandler& handler)
    {
        uint32 bots[2] = { 0, 0 }, players[2] = { 0, 0 }, orders[2][6] = {};
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
                    players[side] += InPlaguelands(p) ? 1 : 0;
                    continue;
                }

                if (m_t4Roster.count(id))
                {
                    ++bots[side];
                    auto it = m_t4Orders.find(id);
                    if (it != m_t4Orders.end() && it->second < 6)
                    {
                        ++orders[side][it->second];
                    }
                }
            }
        }

        handler.PSendSysMessage("|cffffd100[Plaguelands Front stats]|r Darkness Falls: %s. Siege: %s. Lock: %s (%us).", SideName(m_t4Holder), SideName(m_t4SiegeTeam),
                                SideName(m_t4LockTeam), m_t4LockUntil > time(nullptr) ? uint32(m_t4LockUntil - time(nullptr)) : 0);
        for (uint32 i = 0; i < 4; ++i)
        {
            handler.PSendSysMessage("  %s: %s", T4_TOWERS[i].name, SideName(T4TowerOwner(i)));
        }

        for (int side = 0; side < 2; ++side)
        {
            handler.PSendSysMessage("  %s: %u players, %u bots - Northpass %u, Crown Guard %u, Eastwall %u, Plaguewood %u, home %u, enemy keep %u",
                                    side == 0 ? "Alliance" : "Horde", players[side], bots[side], orders[side][0], orders[side][1], orders[side][2], orders[side][3],
                                    orders[side][4], orders[side][5]);
        }
    }

    bool RenownModule::HandleT4Command(WorldSession* session, const std::string& args)
    {
        Player* player = session ? session->GetPlayer() : nullptr;
        if (!player || !GetConfig()->enabled)
        {
            return false;
        }

        ChatHandler handler(player);
        if (!m_t4Ready)
        {
            handler.PSendSysMessage("The Plaguelands Front is not available.");
            return true;
        }

        if (args == "stats")
        {
            if (session->GetSecurity() < SEC_GAMEMASTER)
            {
                return false;
            }

            T4Stats(handler);
            return true;
        }

        if (args == "status")
        {
            std::ostringstream text;
            text << "|cffffd100[Plaguelands Front]|r";
            for (uint32 i = 0; i < 4; ++i)
            {
                text << " " << T4_TOWERS[i].name << ": " << SideName(T4TowerOwner(i)) << ".";
            }

            text << " Darkness Falls: " << SideName(m_t4Holder) << ".";
            if (m_t4SiegeTeam)
            {
                text << " Siege by " << SideName(m_t4SiegeTeam) << "!";
            }

            handler.PSendSysMessage("%s", text.str().c_str());
            return true;
        }

        if (args == "leave")
        {
            if (player->IsInCombat() || player->InBattleGround() || player->IsTaxiFlying())
            {
                handler.PSendSysMessage("|cffffd100[Plaguelands Front]|r You can't leave right now.");
                return true;
            }

            player->TeleportToHomebind();
            return true;
        }

        // join (default)
        if (player->GetLevel() < GetConfig()->t4MinLevel && !player->IsGameMaster())
        {
            handler.PSendSysMessage("|cffffd100[Plaguelands Front]|r The Plaguelands Front is for levels %u-60.", GetConfig()->t4MinLevel);
            return true;
        }

        if (player->InBattleGround() || player->IsInCombat() || !player->IsAlive() || player->IsTaxiFlying() || player->GetMap()->Instanceable())
        {
            handler.PSendSysMessage("|cffffd100[Plaguelands Front]|r You can't travel to the front right now (in combat, dead, flying, in a battleground or an instance).");
            return true;
        }

        const T4Point& keep = KeepOf(player->GetTeam());
        player->TeleportTo(T4_MAP, keep.x + frand(-3.0f, 3.0f), keep.y + frand(-3.0f, 3.0f), keep.z + 1.0f, 0.0f);
        handler.PSendSysMessage("|cffffd100[Plaguelands Front]|r Off to %s. Take the towers and hold three to besiege the enemy keep.", keep.name);
        return true;
    }
}
