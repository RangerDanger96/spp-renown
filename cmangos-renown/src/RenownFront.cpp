// Barrens Front, "front life": everything that makes the tier 1 RvR lake feel alive on top of the capture rules in
// RenownRvR.cpp.
//
//   * Announcer: first blood, streaks and shut-downs, capture / assault / siege / victory calls with battleground sounds
//     (shown big on screen by the RenownBar addon, RENOWNFX messages)
//   * Session summary when a player leaves the front, MVPs (kills, healing, objectives) when a side wins the front
//   * Underdog bonus: the side behind by two objectives earns more Renown, captures faster and gets more bots
//   * Spawn protection after a spirit wave
//   * Field orders every few minutes (hold an objective / kill the enemy standard-bearer)
//   * Supply caravans that walk from each base to its front line and fortify the objective they reach
//   * Hero bots: named champions with buffs and a bounty on their heads
//   * Nemesis: whoever keeps killing you; take revenge for a bonus
//   * Town criers shouting the state of the front in the cities and starting areas
//   * Warbands: ".renown warband" puts front bots in your party to fight at your side

#include "RenownModule.h"

#include "Chat/Chat.h"
#include "Entities/Creature.h"
#include "Entities/Player.h"
#include "Globals/ObjectAccessor.h"
#include "Globals/ObjectMgr.h"
#include "Groups/Group.h"
#include "Log/Log.h"
#include "Maps/Map.h"
#include "MotionGenerators/MotionMaster.h"
#include "Server/WorldPacket.h"
#include "Server/WorldSession.h"
#include "World/World.h"

#include <algorithm>
#include <cmath>
#include <ctime>
#include <sstream>

#ifdef ENABLE_PLAYERBOTS
// Defined in the playerbots patch (RandomPlayerbotMgr.cpp)
bool RenownBotJoinWarband(Player* bot, Player* leader);
bool RenownBotLeaveWarband(Player* bot);
#endif

namespace cmangos_module
{
    namespace
    {
        const uint32 FRONT_MAP = 1;
        const uint32 FRONT_ZONE = 17;

        // Command posts (must match RenownRvR.cpp)
        const float HORDE_CMD[3]    = { -680.0f, -2740.0f, 92.5f };
        const float ALLIANCE_CMD[3] = { -1965.0f, -3395.0f, 56.4f };

        const uint32 NPC_SUPPLY_KODO_HORDE   = 190840;
        const uint32 NPC_SUPPLY_MULE_ALLIANCE = 190841;
        const uint32 NPC_BEARER_HORDE        = 190842;
        const uint32 NPC_BEARER_ALLIANCE     = 190843;
        const uint32 NPC_ESCORT_ALLIANCE     = 190810;   // the front's objective guards
        const uint32 NPC_ESCORT_HORDE        = 190811;

        const uint32 SOUND_CAPTURED_ALLIANCE = 8173, SOUND_CAPTURED_HORDE = 8213;
        const uint32 SOUND_ASSAULT_ALLIANCE = 8212, SOUND_ASSAULT_HORDE = 8174;
        const uint32 SOUND_NEAR_VICTORY_ALLIANCE = 8457, SOUND_NEAR_VICTORY_HORDE = 8456;
        const uint32 SOUND_WIN_ALLIANCE = 8455, SOUND_WIN_HORDE = 8454;
        const uint32 SOUND_FLAG_RETURNED = 8192;

        const uint32 SPELL_HERO_DAMAGE = 23768;    // Sayge's Dark Fortune of Damage (+10% damage)
        const uint32 SPELL_HERO_STAMINA = 23737;   // Sayge's Dark Fortune of Stamina (+10% stamina)

        const time_t ORDER_INTERVAL = 8 * MINUTE;
        const time_t ORDER_LENGTH = 5 * MINUTE;
        const time_t CARAVAN_INTERVAL = 7 * MINUTE;
        const time_t CARAVAN_TIMEOUT = 15 * MINUTE;
        const time_t FORTIFY_TIME = 10 * MINUTE;
        const time_t CRIER_INTERVAL = 15 * MINUTE;
        const time_t PROTECT_TIME = 6;

        int Side(uint32 team) { return team == ALLIANCE ? 0 : 1; }
        uint32 TeamOf(int side) { return side == 0 ? ALLIANCE : HORDE; }
        const char* TeamColored(uint32 team) { return team == ALLIANCE ? "|cff3399ffAlliance|r" : (team == HORDE ? "|cffff3333Horde|r" : "nobody"); }
        const char* HeroTitle(int side) { return side == 0 ? "Champion of Northwatch" : "Champion of the Crossroads"; }

        void SendAddonMsg(Player* player, const std::string& message)
        {
            if (!player || !player->GetSession())
            {
                return;
            }

            WorldPacket packet;
            ChatHandler::BuildChatPacket(packet, CHAT_MSG_PARTY, message.c_str(), LANG_ADDON, CHAT_TAG_NONE, player->GetObjectGuid(), player->GetName());
            player->GetSession()->SendPacket(packet);
        }

        float Dist2(float ax, float ay, float bx, float by) { return (ax - bx) * (ax - bx) + (ay - by) * (ay - by); }

        bool OnFront(const Player* player)
        {
            return player && player->IsInWorld() && player->GetMapId() == FRONT_MAP && player->GetZoneId() == FRONT_ZONE;
        }

        void BotEmote(Player* bot, std::initializer_list<uint32> emotes, uint32 chance)
        {
            if (bot && !bot->isRealPlayer() && bot->IsAlive() && urand(1, 100) <= chance)
            {
                std::vector<uint32> list(emotes);
                bot->HandleEmoteCommand(list[urand(0, uint32(list.size() - 1))]);
            }
        }
    }

    // ------------------------------------------------------------------ announcer
    void RenownModule::FrontFX(const std::string& text, uint32 team, uint32 soundAlliance, uint32 soundHorde, bool chat)
    {
        // Big on-screen text (addon), a chat line for players without it, and a sound
        HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
        for (const auto& entry : sObjectAccessor.GetPlayers())
        {
            Player* player = entry.second;
            if (!player || !player->isRealPlayer() || !player->IsInWorld())
            {
                continue;
            }

            if (!OnFront(player) && !RvRIsMember(player->GetObjectGuid().GetCounter()))
            {
                continue;
            }

            if (team && player->GetTeam() != team)
            {
                continue;
            }

            SendAddonMsg(player, "RENOWNFX\t" + text);
            if (chat)
            {
                ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r %s", text.c_str());
            }
            const uint32 sound = player->GetTeam() == ALLIANCE ? soundAlliance : soundHorde;
            if (sound)
            {
                player->PlayDirectSound(sound, PlayPacketParameters(PlayPacketSettings::TARGET, player));
            }
        }
    }

    // ------------------------------------------------------------------ sessions
    void RenownModule::FrontEnter(Player* player)
    {
        if (!player->isRealPlayer())
        {
            return;
        }

        std::lock_guard<std::mutex> lock(m_frontMutex);
        FrontSession& session = m_frontSessions[player->GetObjectGuid().GetCounter()];
        if (!session.start)
        {
            session = FrontSession();
            session.start = time(nullptr);
            session.startLevel = player->GetLevel();
        }
    }

    void RenownModule::FrontLeave(Player* player)
    {
        const uint32 playerId = player->GetObjectGuid().GetCounter();
        if (player->isRealPlayer())
        {
            FrontSessionSummary(player, true);
            std::lock_guard<std::mutex> lock(m_frontMutex);
            m_frontSessions.erase(playerId);
        }

        // A warband stays with its leader only on the front
        bool leads = false;
        {
            std::lock_guard<std::mutex> lock(m_frontMutex);
            leads = m_frontWarbands.count(playerId) > 0;
        }

        if (leads && !OnFront(player) && !(player->GetMapId() == 0 && player->GetZoneId() == 139))
        {
            FrontDismissWarband(playerId, player, true);
        }
    }

    void RenownModule::FrontSessionSummary(Player* player, bool final)
    {
        FrontSession session;
        {
            std::lock_guard<std::mutex> lock(m_frontMutex);
            auto it = m_frontSessions.find(player->GetObjectGuid().GetCounter());
            if (it == m_frontSessions.end())
            {
                if (!final)
                {
                    ChatHandler(player).PSendSysMessage("|cffffd100[Barrens Front]|r You are not on the front right now.");
                }
                return;
            }

            session = it->second;
        }

        const time_t minutes = (time(nullptr) - session.start) / MINUTE;
        if (final && minutes < 1 && !session.kills && !session.captures)
        {
            return;
        }

        const int levels = int(player->GetLevel()) - int(session.startLevel);
        std::ostringstream text;
        text << "|cffffd100[Barrens Front]|r " << (final ? "Session report" : "This session") << " (" << minutes << " min): "
             << session.kills << " kills, " << session.deaths << " deaths, " << session.captures << " captures, best streak "
             << session.bestStreak << ", " << session.renown << " Renown";
        if (levels > 0)
        {
            text << ", +" << levels << (levels == 1 ? " level" : " levels");
        }

        text << ".";
        ChatHandler(player).PSendSysMessage("%s", text.str().c_str());
    }

    bool RenownModule::HandleSessionCommand(WorldSession* session, const std::string& /*args*/)
    {
        Player* player = session ? session->GetPlayer() : nullptr;
        if (!player || !GetConfig()->enabled)
        {
            return false;
        }

        FrontSessionSummary(player, false);
        return true;
    }

    void RenownModule::FrontOnRenown(Player* player, uint32 gained)
    {
        if (!player->isRealPlayer())
        {
            return;
        }

        std::lock_guard<std::mutex> lock(m_frontMutex);
        auto it = m_frontSessions.find(player->GetObjectGuid().GetCounter());
        if (it != m_frontSessions.end())
        {
            it->second.renown += gained;
        }
    }

    uint32 RenownModule::FrontRenownBonus(Player* player, uint32 gained) const
    {
        // Underdog: +25% on the front for the side that is behind
        if (m_frontUnderdog && player->GetTeam() == m_frontUnderdog && RvRIsMember(player->GetObjectGuid().GetCounter()))
        {
            return gained + gained / 4;
        }

        return gained;
    }

    float RenownModule::FrontCaptureRate(size_t index, uint32 team) const
    {
        float rate = 1.0f;
        const RvRObjective& o = m_rvrObjectives[index];
        if (o.owner && o.owner != team && o.fortifiedUntil > time(nullptr))
        {
            rate *= 0.5f;   // a supply caravan fortified it
        }

        if (team == m_frontUnderdog)
        {
            rate *= 1.5f;
        }

        return rate;
    }

    // ------------------------------------------------------------------ kills
    void RenownModule::FrontOnKill(Player* killer, Player* victim, uint32 oldStreak, uint32 newStreak)
    {
        const uint32 killerId = killer->GetObjectGuid().GetCounter();
        const uint32 victimId = victim->GetObjectGuid().GetCounter();
        const bool onFront = RvRIsMember(killerId) || RvRIsMember(victimId);
        if (!onFront)
        {
            return;
        }

        bool firstBlood = false, revenge = false, newNemesis = false, heroDown = false;
        int heroSide = 0;
        {
            std::lock_guard<std::mutex> lock(m_frontMutex);

            // Sessions and the front cycle
            auto ks = m_frontSessions.find(killerId);
            if (ks != m_frontSessions.end())
            {
                ++ks->second.kills;
                ks->second.bestStreak = std::max(ks->second.bestStreak, newStreak);
            }

            auto vs = m_frontSessions.find(victimId);
            if (vs != m_frontSessions.end())
            {
                ++vs->second.deaths;
            }

            FrontCycle& cycle = m_frontCycle[killerId];
            cycle.name = killer->GetName();
            cycle.team = killer->GetTeam();
            cycle.real = killer->isRealPlayer();
            ++cycle.kills;

            if (!m_frontFirstBlood)
            {
                m_frontFirstBlood = true;
                firstBlood = true;
            }

            // Nemesis: the player who has killed you the most (at least 3 times)
            const uint32 count = ++m_frontKillCount[(uint64(victimId) << 32) | killerId];
            auto nem = m_frontNemesis.find(victimId);
            const uint32 current = nem != m_frontNemesis.end() ? nem->second : 0;
            if (count >= 3 && current != killerId)
            {
                const uint32 currentCount = current ? m_frontKillCount[(uint64(victimId) << 32) | current] : 0;
                if (count > currentCount)
                {
                    m_frontNemesis[victimId] = killerId;
                    newNemesis = true;
                }
            }

            // Revenge: killing your own nemesis
            auto mine = m_frontNemesis.find(killerId);
            if (mine != m_frontNemesis.end() && mine->second == victimId)
            {
                revenge = true;
                m_frontNemesis.erase(mine);
                m_frontKillCount.erase((uint64(killerId) << 32) | victimId);
            }

            auto hero = m_frontHeroes.find(victimId);
            if (hero != m_frontHeroes.end())
            {
                heroDown = true;
                heroSide = hero->second;
            }
        }

        if (firstBlood)
        {
            FrontFX(std::string(killer->GetName()) + " draws First Blood!", 0, SOUND_FLAG_RETURNED, SOUND_FLAG_RETURNED);
        }

        // Big streak calls on screen (the chat lines come from the streak system)
        const char* call = nullptr;
        switch (newStreak)
        {
            case 3:  call = "Killing Spree!"; break;
            case 5:  call = "Rampage!"; break;
            case 8:  call = "Dominating!"; break;
            case 12: call = "Unstoppable!"; break;
            case 20: call = "Godlike!"; break;
            default: break;
        }

        if (call)
        {
            FrontFX(std::string(killer->GetName()) + ": " + call, 0, 0, 0, false);
        }

        if (oldStreak >= 5)
        {
            FrontFX(std::string(killer->GetName()) + " shut down " + victim->GetName() + "! (" + std::to_string(oldStreak) + " kills)", 0, 0, 0, false);
        }

        if (newNemesis && victim->isRealPlayer())
        {
            ChatHandler(victim).PSendSysMessage("|cffff4040[Nemesis]|r %s has killed you again and is now your Nemesis. Get revenge for bonus Renown!", killer->GetName());
            SendAddonMsg(victim, std::string("RENOWNFX\t") + killer->GetName() + " is now your Nemesis!");
        }

        if (revenge)
        {
            AddRenown(killer, GetConfig()->pointsHonorableKill * 3);
            if (killer->isRealPlayer())
            {
                SendAddonMsg(killer, std::string("RENOWNFX\tRevenge! You slew your Nemesis, ") + victim->GetName() + "!");
            }
            Announce(killer, std::string("|cffff4040[Nemesis]|r ") + killer->GetName() + " took revenge on " + victim->GetName() + "!");
        }

        if (heroDown && Side(killer->GetTeam()) != heroSide)
        {
            AddRenown(killer, 150);
            if (killer->isRealPlayer())
            {
                GiveLootBag(killer, BAG_PURPLE);
            }

            FrontFX(std::string(killer->GetName()) + " has slain " + victim->GetName() + ", " + HeroTitle(heroSide) + "!", 0,
                    heroSide == 0 ? SOUND_ASSAULT_HORDE : SOUND_ASSAULT_ALLIANCE, heroSide == 0 ? SOUND_ASSAULT_HORDE : SOUND_ASSAULT_ALLIANCE);
        }

        // Bots react
        BotEmote(killer, { EMOTE_ONESHOT_LAUGH, EMOTE_ONESHOT_ROAR, EMOTE_ONESHOT_CHEER, EMOTE_ONESHOT_FLEX }, 35);
    }

    void RenownModule::FrontOnHealAssist(Player* healer)
    {
        if (!RvRIsMember(healer->GetObjectGuid().GetCounter()))
        {
            return;
        }

        std::lock_guard<std::mutex> lock(m_frontMutex);
        FrontCycle& cycle = m_frontCycle[healer->GetObjectGuid().GetCounter()];
        cycle.name = healer->GetName();
        cycle.team = healer->GetTeam();
        cycle.real = healer->isRealPlayer();
        ++cycle.heals;
    }

    // ------------------------------------------------------------------ objectives
    void RenownModule::FrontOnCapture(size_t index, uint32 team, uint32 previous, const std::vector<Player*>& capturers)
    {
        {
            std::lock_guard<std::mutex> lock(m_frontMutex);
            for (Player* player : capturers)
            {
                const uint32 id = player->GetObjectGuid().GetCounter();
                auto s = m_frontSessions.find(id);
                if (s != m_frontSessions.end())
                {
                    ++s->second.captures;
                }

                FrontCycle& cycle = m_frontCycle[id];
                cycle.name = player->GetName();
                cycle.team = player->GetTeam();
                cycle.real = player->isRealPlayer();
                ++cycle.objectives;
            }
        }

        for (Player* player : capturers)
        {
            BotEmote(player, { EMOTE_ONESHOT_CHEER, EMOTE_ONESHOT_ROAR }, 60);
        }

        std::string text = std::string(team == ALLIANCE ? "The Alliance" : "The Horde") + " captured " + m_rvrObjectives[index].name + "!";
        if (previous)
        {
            text = std::string(team == ALLIANCE ? "The Alliance" : "The Horde") + " took " + m_rvrObjectives[index].name + " from the " +
                   (previous == ALLIANCE ? "Alliance" : "Horde") + "!";
        }

        FrontFX(text, 0, team == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE, team == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE);
    }

    void RenownModule::FrontOnAssault(size_t index, uint32 attacker)
    {
        // Warn the defenders
        const uint32 defender = m_rvrObjectives[index].owner;
        if (!defender || defender == attacker)
        {
            return;
        }

        const uint32 sound = attacker == ALLIANCE ? SOUND_ASSAULT_ALLIANCE : SOUND_ASSAULT_HORDE;
        FrontFX(std::string(m_rvrObjectives[index].name) + " is under attack!", defender, sound, sound);
    }

    void RenownModule::FrontOnSiege(uint32 team)
    {
        const uint32 sound = team == ALLIANCE ? SOUND_NEAR_VICTORY_ALLIANCE : SOUND_NEAR_VICTORY_HORDE;
        FrontFX(team == ALLIANCE ? "Siege! Storm the Crossroads and kill the Warlord!" : "Siege! Storm Northwatch Hold and kill the Field Commander!", team, sound, sound);
        FrontFX(team == ALLIANCE ? "The Alliance is besieging the Crossroads! Defend the Warlord!" : "The Horde is besieging Northwatch Hold! Defend the Field Commander!",
                team == ALLIANCE ? HORDE : ALLIANCE, sound, sound);
    }

    void RenownModule::FrontOnVictory(uint32 team)
    {
        FrontFX(std::string(team == ALLIANCE ? "The Alliance" : "The Horde") + " has won the Barrens Front!", 0, team == ALLIANCE ? SOUND_WIN_ALLIANCE : SOUND_WIN_HORDE,
                team == ALLIANCE ? SOUND_WIN_ALLIANCE : SOUND_WIN_HORDE);

        // MVPs of the cycle, per side
        std::vector<std::pair<uint32, FrontCycle>> cycle;
        {
            std::lock_guard<std::mutex> lock(m_frontMutex);
            cycle.assign(m_frontCycle.begin(), m_frontCycle.end());
            m_frontCycle.clear();
            m_frontFirstBlood = false;
        }

        std::ostringstream text;
        text << "|cffffd100[Barrens Front] MVPs:|r";
        bool any = false;
        for (int side = 0; side < 2; ++side)
        {
            const char* labels[3] = { "kills", "healing", "objectives" };
            for (int stat = 0; stat < 3; ++stat)
            {
                const std::pair<uint32, FrontCycle>* best = nullptr;
                uint32 bestValue = 0;
                for (const auto& entry : cycle)
                {
                    if (Side(entry.second.team) != side)
                    {
                        continue;
                    }

                    const uint32 value = stat == 0 ? entry.second.kills : (stat == 1 ? entry.second.heals : entry.second.objectives);
                    if (value > bestValue)
                    {
                        bestValue = value;
                        best = &entry;
                    }
                }

                if (!best)
                {
                    continue;
                }

                any = true;
                text << " " << (side == 0 ? "|cff3399ff" : "|cffff3333") << best->second.name << "|r (" << labels[stat] << " " << bestValue << ")";
                if (best->second.real)
                {
                    if (Player* mvp = sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, best->first)))
                    {
                        AddRenown(mvp, 100, false);
                        ChatHandler(mvp).PSendSysMessage("|cffffd100[Barrens Front]|r You were an MVP (%s)! +100 Renown.", labels[stat]);
                    }
                }
            }
        }

        if (any)
        {
            RvRAnnounce(text.str());
        }
    }

    // ------------------------------------------------------------------ spawn protection
    void RenownModule::FrontProtect(Player* player)
    {
        player->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PLAYER);
        std::lock_guard<std::mutex> lock(m_frontMutex);
        m_frontProtect[player->GetObjectGuid().GetCounter()] = time(nullptr) + PROTECT_TIME;
    }

    // ------------------------------------------------------------------ main update (once a second)
    Map* RenownModule::FrontMap(const std::vector<Player*>& members) const
    {
        for (Player* player : members)
        {
            if (!RenownPlayerOk(player))
                continue;
            if (player->IsInWorld() && player->GetMapId() == FRONT_MAP && player->GetMap())
            {
                return player->GetMap();
            }
        }

        return nullptr;
    }

    void RenownModule::FrontUpdate(uint32 diff, const std::vector<Player*>& players, const std::vector<Player*>& members)
    {
        const time_t now = time(nullptr);

        // Spawn protection ends
        {
            std::vector<uint32> expired;
            {
                std::lock_guard<std::mutex> lock(m_frontMutex);
                for (auto it = m_frontProtect.begin(); it != m_frontProtect.end();)
                {
                    if (it->second <= now)
                    {
                        expired.push_back(it->first);
                        it = m_frontProtect.erase(it);
                    }
                    else
                    {
                        ++it;
                    }
                }
            }

            for (uint32 id : expired)
            {
                if (Player* player = sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, id)))
                {
                    player->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PLAYER);
                }
            }
        }

        // Underdog: two objectives behind
        if (m_rvrObjectives.size() == 3)
        {
            const uint32 a = RvROwnedBy(ALLIANCE), h = RvROwnedBy(HORDE);
            uint32 underdog = 0;
            if (!m_rvrLockTeam && h >= a + 2)
            {
                underdog = ALLIANCE;
            }
            else if (!m_rvrLockTeam && a >= h + 2)
            {
                underdog = HORDE;
            }

            if (underdog != m_frontUnderdog)
            {
                m_frontUnderdog = underdog;
                m_rvrDirty = true;
                if (underdog)
                {
                    FrontFX(std::string(underdog == ALLIANCE ? "The Alliance" : "The Horde") + " rallies! +25% Renown and faster captures until the front is even.", underdog, 0, 0);
                }
            }
        }

        m_frontTimer += diff;
        if (m_frontTimer < 2 * IN_MILLISECONDS)
        {
            return;
        }
        m_frontTimer = 0;

        // Warbands: dismiss when the leader is gone or left the front; drop members that left the group
        {
            std::vector<uint32> dismiss;
            {
                std::lock_guard<std::mutex> lock(m_frontMutex);
                for (auto& band : m_frontWarbands)
                {
                    Player* leader = sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, band.first));
                    const bool barrens = leader && (OnFront(leader) || RvRIsMember(band.first)) && leader->GetLevel() <= GetConfig()->rvrMaxLevel;
                    const bool plaguelands = leader && leader->IsInWorld() && leader->GetMapId() == 0 && leader->GetZoneId() == 139 && leader->GetLevel() >= GetConfig()->t4MinLevel;
                    if (!leader || !leader->IsInWorld() || (!barrens && !plaguelands))
                    {
                        dismiss.push_back(band.first);
                        continue;
                    }

                    band.second.erase(std::remove_if(band.second.begin(), band.second.end(), [&](uint32 botId)
                    {
                        Player* bot = sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, botId));
                        return !bot || !bot->GetGroup() || bot->GetGroup() != leader->GetGroup();
                    }), band.second.end());
                }
            }

            for (uint32 leaderId : dismiss)
            {
                FrontDismissWarband(leaderId, sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, leaderId)), true);
            }
        }

        bool watched = false;
        for (Player* player : players)
        {
            if (!RenownPlayerOk(player))
                continue;
            if (player->isRealPlayer() && (OnFront(player) || RvRIsMember(player->GetObjectGuid().GetCounter())))
            {
                watched = true;
                break;
            }
        }

        if (watched && m_rvrObjectives.size() == 3)
        {
            FrontUpdateOrders(members);
            FrontUpdateCaravans(members);
            if (now >= m_frontHeroCheck)
            {
                m_frontHeroCheck = now + 20;
                FrontUpdateHeroes(members);
            }
        }

        if (now >= m_frontNextCrier)
        {
            if (m_frontNextCrier)
            {
                FrontCrier();
            }
            m_frontNextCrier = now + CRIER_INTERVAL;
        }
    }

    // ------------------------------------------------------------------ field orders
    void RenownModule::FrontUpdateOrders(const std::vector<Player*>& members)
    {
        const time_t now = time(nullptr);
        FieldOrder& order = m_frontOrder;
        Map* map = FrontMap(members);

        if (!order.type)
        {
            if (!m_frontNextOrder)
            {
                m_frontNextOrder = now + 3 * MINUTE;   // first one shortly after someone arrives
                return;
            }

            if (now < m_frontNextOrder || m_rvrLockTeam || m_rvrSiegeTeam || !map || members.empty())
            {
                return;
            }

            order = FieldOrder();
            order.type = urand(1, 2);
            order.ends = now + ORDER_LENGTH;
            if (order.type == 1)
            {
                // Hold an objective: prefer one that is owned (so there is something to defend or to take)
                std::vector<uint8> owned;
                for (uint8 i = 0; i < 3; ++i)
                {
                    if (m_rvrObjectives[i].owner)
                    {
                        owned.push_back(i);
                    }
                }

                order.objective = owned.empty() ? 1 : owned[urand(0, uint32(owned.size() - 1))];
                FrontFX(std::string("Field orders: hold ") + m_rvrObjectives[order.objective].name + " when the horn sounds in 5 minutes!", 0, SOUND_FLAG_RETURNED, SOUND_FLAG_RETURNED);
            }
            else
            {
                // Standard-bearers: one per side, near its foremost objective (or base)
                Player* summoner = nullptr;
                for (Player* p : members)
                {
                    if (!RenownPlayerOk(p))
                        continue;
                    if (p->IsInWorld() && p->GetMapId() == FRONT_MAP)
                    {
                        summoner = p;
                        break;
                    }
                }

                for (int side = 0; side < 2 && summoner; ++side)
                {
                    const uint32 team = TeamOf(side);
                    const float* base = side == 0 ? ALLIANCE_CMD : HORDE_CMD;
                    float x = base[0], y = base[1], z = base[2];
                    for (int k = 2; k >= 0; --k)
                    {
                        // own-side order: horde 0,1,2 / alliance 2,1,0 -> foremost held = furthest from home
                        const int idx = side == 1 ? k : 2 - k;
                        if (m_rvrObjectives[idx].owner == team)
                        {
                            x = m_rvrObjectives[idx].x; y = m_rvrObjectives[idx].y; z = m_rvrObjectives[idx].z;
                            break;
                        }
                    }

                    const float a = frand(0.0f, 6.28f);
                    x += std::cos(a) * 10.0f;
                    y += std::sin(a) * 10.0f;
                    summoner->UpdateAllowedPositionZ(x, y, z);
                    if (Creature* bearer = summoner->SummonCreature(side == 0 ? NPC_BEARER_ALLIANCE : NPC_BEARER_HORDE, x, y, z, a,
                                                                    TEMPSPAWN_TIMED_OR_DEAD_DESPAWN, uint32(ORDER_LENGTH + 30) * IN_MILLISECONDS, true))
                    {
                        order.bearer[side] = bearer->GetObjectGuid();
                        order.bearerPos[side][0] = x; order.bearerPos[side][1] = y; order.bearerPos[side][2] = z;
                    }
                }

                FrontFX("Field orders: kill the enemy standard-bearer, and keep yours alive!", 0, SOUND_FLAG_RETURNED, SOUND_FLAG_RETURNED);
            }
            return;
        }

        // Running order
        if (order.type == 2 && map)
        {
            for (int side = 0; side < 2; ++side)
            {
                if (order.bearerDown[side] || order.bearer[side].IsEmpty())
                {
                    continue;
                }

                Creature* bearer = map->GetCreature(order.bearer[side]);
                if (bearer && bearer->IsAlive())
                {
                    order.bearerPos[side][0] = bearer->GetPositionX();
                    order.bearerPos[side][1] = bearer->GetPositionY();
                    continue;
                }

                if (!bearer && now < order.ends)
                {
                    continue;   // grid not loaded right now
                }

                // Down: reward the other side's fighters nearby
                order.bearerDown[side] = true;
                const uint32 winner = TeamOf(1 - side);
                for (Player* p : members)
                {
                    if (!RenownPlayerOk(p))
                        continue;
                    if (p->GetTeam() == winner && p->IsAlive() && Dist2(p->GetPositionX(), p->GetPositionY(), order.bearerPos[side][0], order.bearerPos[side][1]) <= 50.0f * 50.0f)
                    {
                        AddRenown(p, 120);
                        if (p->isRealPlayer() && urand(1, 100) <= 30)
                        {
                            GiveLootBag(p, BAG_BLUE);
                        }
                    }
                }

                FrontFX(std::string(side == 0 ? "The Alliance" : "The Horde") + " standard-bearer has fallen!", 0,
                        winner == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE, winner == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE);
            }

            if (order.bearerDown[0] && order.bearerDown[1])
            {
                order.ends = now;   // both down: order over
            }
        }

        if (now < order.ends)
        {
            return;
        }

        // Order ends
        if (order.type == 1)
        {
            const RvRObjective& o = m_rvrObjectives[order.objective];
            if (o.owner)
            {
                uint32 count = 0;
                for (Player* p : members)
                {
                    if (!RenownPlayerOk(p))
                        continue;
                    if (p->GetTeam() == o.owner && p->IsAlive() && Dist2(p->GetPositionX(), p->GetPositionY(), o.x, o.y) <= 60.0f * 60.0f)
                    {
                        AddRenown(p, 100);
                        if (p->isRealPlayer() && urand(1, 100) <= 25)
                        {
                            GiveLootBag(p, BAG_BLUE);
                        }
                        ++count;
                    }
                }

                FrontFX(std::string(o.owner == ALLIANCE ? "The Alliance" : "The Horde") + " held " + o.name + "! Field orders complete.", 0,
                        o.owner == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE, o.owner == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE);
            }
            else
            {
                FrontFX(std::string("Nobody held ") + o.name + ". The field orders expire.", 0, 0, 0);
            }
        }
        else if (order.type == 2 && map)
        {
            for (int side = 0; side < 2; ++side)
            {
                if (order.bearerDown[side] || order.bearer[side].IsEmpty())
                {
                    continue;
                }

                // Survived: its side's fighters nearby are rewarded, then the bearer leaves
                const uint32 team = TeamOf(side);
                for (Player* p : members)
                {
                    if (!RenownPlayerOk(p))
                        continue;
                    if (p->GetTeam() == team && p->IsAlive() && Dist2(p->GetPositionX(), p->GetPositionY(), order.bearerPos[side][0], order.bearerPos[side][1]) <= 60.0f * 60.0f)
                    {
                        AddRenown(p, 50);
                    }
                }

                if (Creature* bearer = map->GetCreature(order.bearer[side]))
                {
                    bearer->ForcedDespawn(1000);
                }

                FrontFX(std::string(side == 0 ? "The Alliance" : "The Horde") + " standard-bearer survived!", team, 0, 0);
            }
        }

        order = FieldOrder();
        m_frontNextOrder = now + ORDER_INTERVAL;
    }

    // ------------------------------------------------------------------ supply caravans
    void RenownModule::FrontUpdateCaravans(const std::vector<Player*>& members)
    {
        const time_t now = time(nullptr);
        Map* map = FrontMap(members);
        if (!map)
        {
            return;
        }

        for (int side = 0; side < 2; ++side)
        {
            Caravan& caravan = m_frontCaravans[side];
            const uint32 team = TeamOf(side);

            if (!caravan.active)
            {
                if (!m_frontNextCaravan[side])
                {
                    m_frontNextCaravan[side] = now + (side == 0 ? 2 : 4) * MINUTE;
                    continue;
                }

                if (now < m_frontNextCaravan[side] || m_rvrLockTeam)
                {
                    continue;
                }

                m_frontNextCaravan[side] = now + CARAVAN_INTERVAL;

                // Destination: the side's foremost held objective, at most two objectives out
                int dest = -1;
                for (int k = 0; k < 2; ++k)
                {
                    const int idx = side == 1 ? k : 2 - k;
                    if (m_rvrObjectives[idx].owner == team)
                    {
                        dest = idx;
                    }
                    else
                    {
                        break;
                    }
                }

                if (dest < 0)
                {
                    continue;   // nothing to supply
                }

                // A summoner of the side near its base keeps the spawn in a loaded area
                const float* base = side == 0 ? ALLIANCE_CMD : HORDE_CMD;
                Player* summoner = nullptr;
                for (Player* p : members)
                {
                    if (!RenownPlayerOk(p))
                        continue;
                    if (p->GetTeam() == team && p->IsInWorld() && p->GetMapId() == FRONT_MAP)
                    {
                        summoner = p;
                        break;
                    }
                }

                if (!summoner)
                {
                    continue;
                }

                float x = base[0], y = base[1], z = base[2];
                summoner->UpdateAllowedPositionZ(x, y, z);
                Creature* kodo = summoner->SummonCreature(side == 0 ? NPC_SUPPLY_MULE_ALLIANCE : NPC_SUPPLY_KODO_HORDE, x, y, z, 0.0f,
                                                          TEMPSPAWN_TIMED_OR_DEAD_DESPAWN, uint32(CARAVAN_TIMEOUT + 60) * IN_MILLISECONDS, true);
                if (!kodo)
                {
                    continue;
                }

                caravan = Caravan();
                caravan.active = true;
                caravan.kodo = kodo->GetObjectGuid();
                caravan.dest = uint8(dest);
                caravan.started = now;
                for (int k = 0; k < 3; ++k)
                {
                    const int idx = side == 1 ? k : 2 - k;
                    caravan.path.push_back({ m_rvrObjectives[idx].x, m_rvrObjectives[idx].y, m_rvrObjectives[idx].z });
                    if (idx == dest)
                    {
                        break;
                    }
                }

                for (int e = 0; e < 2; ++e)
                {
                    if (Creature* escort = summoner->SummonCreature(side == 0 ? NPC_ESCORT_ALLIANCE : NPC_ESCORT_HORDE, x + (e ? 3.0f : -3.0f), y, z, 0.0f,
                                                                     TEMPSPAWN_TIMED_OR_DEAD_DESPAWN, uint32(CARAVAN_TIMEOUT + 60) * IN_MILLISECONDS, true))
                    {
                        caravan.escorts[e] = escort->GetObjectGuid();
                        escort->GetMotionMaster()->MoveFollow(kodo, 3.0f, e ? 1.5707963f : -1.5707963f);
                    }
                }

                kodo->GetMotionMaster()->MovePoint(1, caravan.path[0][0], caravan.path[0][1], caravan.path[0][2], FORCED_MOVEMENT_WALK);
                FrontFX(std::string("A ") + (side == 0 ? "Northwatch supply mule" : "Crossroads supply kodo") + " sets out for " +
                        m_rvrObjectives[dest].name + ". Escort it to fortify the objective, or ambush it!", 0, 0, 0);
                continue;
            }

            Creature* kodo = map->GetCreature(caravan.kodo);
            const bool timedOut = now - caravan.started > CARAVAN_TIMEOUT;
            if (kodo && kodo->IsAlive() && !timedOut)
            {
                caravan.lastPos[0] = kodo->GetPositionX();
                caravan.lastPos[1] = kodo->GetPositionY();
                caravan.lastPos[2] = kodo->GetPositionZ();
                const std::array<float, 3>& wp = caravan.path[caravan.next];
                if (Dist2(caravan.lastPos[0], caravan.lastPos[1], wp[0], wp[1]) <= 6.0f * 6.0f)
                {
                    if (++caravan.next >= caravan.path.size())
                    {
                        // Delivered
                        RvRObjective& o = m_rvrObjectives[caravan.dest];
                        if (o.owner == team)
                        {
                            o.fortifiedUntil = now + FORTIFY_TIME;
                            m_rvrDirty = true;
                        }

                        for (Player* p : members)
                        {
                            if (!RenownPlayerOk(p))
                                continue;
                            if (p->GetTeam() == team && p->IsAlive() && Dist2(p->GetPositionX(), p->GetPositionY(), caravan.lastPos[0], caravan.lastPos[1]) <= 50.0f * 50.0f)
                            {
                                AddRenown(p, 60);
                            }
                        }

                        FrontFX(std::string("Supplies delivered! ") + o.name + " is fortified for 10 minutes.", 0,
                                team == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE, team == ALLIANCE ? SOUND_CAPTURED_ALLIANCE : SOUND_CAPTURED_HORDE);
                        kodo->ForcedDespawn(3000);
                        for (const ObjectGuid& guid : caravan.escorts)
                        {
                            if (Creature* escort = map->GetCreature(guid))
                            {
                                escort->ForcedDespawn(3000);
                            }
                        }

                        caravan = Caravan();
                        continue;
                    }
                }

                // Keep walking (after a fight it would otherwise go home)
                if (!kodo->IsInCombat() && kodo->GetMotionMaster()->GetCurrentMovementGeneratorType() != POINT_MOTION_TYPE)
                {
                    const std::array<float, 3>& next = caravan.path[caravan.next];
                    kodo->GetMotionMaster()->MovePoint(1, next[0], next[1], next[2], FORCED_MOVEMENT_WALK);
                }
                continue;
            }

            if (!kodo && !timedOut)
            {
                continue;   // not loaded right now
            }

            // Killed (or lost)
            if (!timedOut)
            {
                const uint32 enemy = TeamOf(1 - side);
                for (Player* p : members)
                {
                    if (!RenownPlayerOk(p))
                        continue;
                    if (p->GetTeam() == enemy && p->IsAlive() && Dist2(p->GetPositionX(), p->GetPositionY(), caravan.lastPos[0], caravan.lastPos[1]) <= 50.0f * 50.0f)
                    {
                        AddRenown(p, 80);
                        if (p->isRealPlayer() && urand(1, 100) <= 25)
                        {
                            GiveLootBag(p, BAG_BLUE);
                        }
                    }
                }

                FrontFX(std::string("The ") + (side == 0 ? "Northwatch supply mule" : "Crossroads supply kodo") + " was ambushed!", 0,
                        enemy == ALLIANCE ? SOUND_ASSAULT_ALLIANCE : SOUND_ASSAULT_HORDE, enemy == ALLIANCE ? SOUND_ASSAULT_ALLIANCE : SOUND_ASSAULT_HORDE);
            }

            if (kodo)
            {
                kodo->ForcedDespawn(1000);
            }

            for (const ObjectGuid& guid : caravan.escorts)
            {
                if (Creature* escort = map->GetCreature(guid))
                {
                    escort->ForcedDespawn(5000);
                }
            }

            caravan = Caravan();
        }
    }

    // ------------------------------------------------------------------ hero bots
    void RenownModule::FrontUpdateHeroes(const std::vector<Player*>& members)
    {
        uint32 count[2] = { 0, 0 };
        {
            std::lock_guard<std::mutex> lock(m_frontMutex);
            for (auto it = m_frontHeroes.begin(); it != m_frontHeroes.end();)
            {
                Player* hero = sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, it->first));
                if (!hero || !hero->IsInWorld() || !m_rvrRoster.count(it->first))
                {
                    it = m_frontHeroes.erase(it);
                    continue;
                }

                ++count[it->second];
                if (hero->IsAlive() && !hero->HasAura(SPELL_HERO_DAMAGE))
                {
                    hero->CastSpell(hero, SPELL_HERO_DAMAGE, TRIGGERED_OLD_TRIGGERED);
                    hero->CastSpell(hero, SPELL_HERO_STAMINA, TRIGGERED_OLD_TRIGGERED);
                }
                ++it;
            }
        }

        for (int side = 0; side < 2; ++side)
        {
            if (count[side] >= 2)
            {
                continue;
            }

            // Promote an enlisted bot of the side that is alive in the lake, preferring the highest level
            Player* best = nullptr;
            for (Player* p : members)
            {
                if (!RenownPlayerOk(p))
                    continue;
                const uint32 id = p->GetObjectGuid().GetCounter();
                if (p->isRealPlayer() || Side(p->GetTeam()) != side || !p->IsAlive() || !m_rvrRoster.count(id))
                {
                    continue;
                }

                {
                    std::lock_guard<std::mutex> lock(m_frontMutex);
                    if (m_frontHeroes.count(id))
                    {
                        continue;
                    }
                }

                if (!best || p->GetLevel() > best->GetLevel())
                {
                    best = p;
                }
            }

            if (!best)
            {
                continue;
            }

            {
                std::lock_guard<std::mutex> lock(m_frontMutex);
                m_frontHeroes[best->GetObjectGuid().GetCounter()] = uint8(side);
            }

            best->CastSpell(best, SPELL_HERO_DAMAGE, TRIGGERED_OLD_TRIGGERED);
            best->CastSpell(best, SPELL_HERO_STAMINA, TRIGGERED_OLD_TRIGGERED);
            FrontFX(std::string(best->GetName()) + ", " + HeroTitle(side) + ", has joined the front! Bounty: 150 Renown.", 0, 0, 0);
            return;   // one announcement at a time
        }
    }

    // ------------------------------------------------------------------ town criers
    void RenownModule::FrontCrier()
    {
        if (m_rvrObjectives.size() != 3 || !GetConfig()->rvrEnabled)
        {
            return;
        }

        const uint32 a = RvROwnedBy(ALLIANCE), h = RvROwnedBy(HORDE);
        auto message = [&](uint32 team) -> std::string
        {
            const bool alliance = team == ALLIANCE;
            const uint32 mine = alliance ? a : h, theirs = alliance ? h : a;
            std::ostringstream text;
            text << "Hear ye! News from the Barrens Front! ";
            if (m_rvrLockTeam)
            {
                text << (m_rvrLockTeam == team ? "Our forces have won the field! Glory to the victors!" : "The enemy has won the field, but the war is not over. Prepare the counterattack!");
            }
            else if (m_rvrSiegeTeam)
            {
                text << (m_rvrSiegeTeam == team ? "Our army is besieging the enemy commander! Every blade is needed!" : "The enemy is besieging our commander! Defenders, to arms!");
            }
            else if (mine > theirs)
            {
                text << "We hold " << mine << " of 3 objectives. Press the advantage!";
            }
            else if (theirs > mine)
            {
                text << "The enemy holds " << theirs << " of 3 objectives. " << (alliance ? "Northwatch Hold" : "The Crossroads") << " calls for aid!";
            }
            else
            {
                text << "The front is evenly matched. Fresh soldiers could tip the balance!";
            }

            text << " (Levels 1-" << GetConfig()->rvrMaxLevel << ": open the PvP panel or type /front.)";
            return text.str();
        };

        static const uint32 hordeZones[] = { 1637, 1638, 1497, 14, 215, 85, 17 };
        static const uint32 allianceZones[] = { 1519, 1537, 1657, 12, 1, 141 };
        const std::string hordeText = message(HORDE), allianceText = message(ALLIANCE);

        HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
        for (const auto& entry : sObjectAccessor.GetPlayers())
        {
            Player* player = entry.second;
            if (!player || !player->isRealPlayer() || !player->IsInWorld() || player->InBattleGround())
            {
                continue;
            }

            const bool alliance = player->GetTeam() == ALLIANCE;
            const uint32 zone = player->GetZoneId();
            bool hears = false;
            if (alliance)
            {
                hears = std::find(std::begin(allianceZones), std::end(allianceZones), zone) != std::end(allianceZones);
            }
            else
            {
                hears = std::find(std::begin(hordeZones), std::end(hordeZones), zone) != std::end(hordeZones);
            }

            if (!hears)
            {
                continue;
            }

            WorldPacket data;
            const std::string& text = alliance ? allianceText : hordeText;
            ChatHandler::BuildChatPacket(data, CHAT_MSG_MONSTER_YELL, text.c_str(), LANG_UNIVERSAL, CHAT_TAG_NONE, ObjectGuid(), "Town Crier");
            player->GetSession()->SendPacket(data);
        }
    }

    // ------------------------------------------------------------------ warbands
    bool RenownModule::FrontIsWarbandBot(uint32 botId) const
    {
        for (const auto& band : m_frontWarbands)
        {
            if (std::find(band.second.begin(), band.second.end(), botId) != band.second.end())
            {
                return true;
            }
        }

        return false;
    }

    void RenownModule::FrontDismissWarband(uint32 leaderId, Player* leader, bool announce)
    {
        std::vector<uint32> bots;
        {
            std::lock_guard<std::mutex> lock(m_frontMutex);
            auto it = m_frontWarbands.find(leaderId);
            if (it == m_frontWarbands.end())
            {
                return;
            }

            bots = it->second;
            m_frontWarbands.erase(it);
        }

        for (uint32 botId : bots)
        {
            Player* bot = sObjectMgr.GetPlayer(ObjectGuid(HIGHGUID_PLAYER, botId));
            if (!bot)
            {
                continue;
            }

#ifdef ENABLE_PLAYERBOTS
            RenownBotLeaveWarband(bot);
#endif
            // Back to the front's roster if it is still there
            if (RvRIsMember(botId) && bot->GetLevel() <= GetConfig()->rvrMaxLevel)
            {
                m_rvrRoster.insert(botId);
            }
            else if (T4IsMember(botId) && bot->GetLevel() >= GetConfig()->t4MinLevel)
            {
                m_t4Roster.insert(botId);
            }
        }

        if (announce && leader && leader->isRealPlayer())
        {
            ChatHandler(leader).PSendSysMessage("|cffffd100[Barrens Front]|r Your warband returns to the front lines.");
        }
    }

    bool RenownModule::HandleWarbandCommand(WorldSession* session, const std::string& args)
    {
        Player* player = session ? session->GetPlayer() : nullptr;
        if (!player || !GetConfig()->enabled)
        {
            return false;
        }

        ChatHandler handler(player);
        const uint32 leaderId = player->GetObjectGuid().GetCounter();
        if (args == "dismiss" || args == "disband")
        {
            bool had = false;
            {
                std::lock_guard<std::mutex> lock(m_frontMutex);
                had = m_frontWarbands.count(leaderId) > 0;
            }

            if (!had)
            {
                handler.PSendSysMessage("|cffffd100[Barrens Front]|r You don't lead a warband.");
                return true;
            }

            FrontDismissWarband(leaderId, player, true);
            return true;
        }

#ifndef ENABLE_PLAYERBOTS
        handler.PSendSysMessage("Warbands need playerbots.");
        return true;
#else
        const bool onBarrens = GetConfig()->rvrEnabled && m_rvrObjectives.size() == 3 && (RvRIsMember(leaderId) || OnFront(player));
        const bool onPlaguelands = m_t4Ready && player->GetMapId() == 0 && player->GetZoneId() == 139;
        if (!onBarrens && !onPlaguelands)
        {
            handler.PSendSysMessage("|cffffd100[Renown]|r Warbands can only be raised on the Barrens Front (levels 1-%u, /front) or the Plaguelands Front (levels %u-60, /t4).",
                                    GetConfig()->rvrMaxLevel, GetConfig()->t4MinLevel);
            return true;
        }

        if ((onBarrens && player->GetLevel() > GetConfig()->rvrMaxLevel) || (onPlaguelands && player->GetLevel() < GetConfig()->t4MinLevel))
        {
            handler.PSendSysMessage("|cffffd100[Renown]|r Your level doesn't fit this front.");
            return true;
        }

        std::unordered_set<uint32>& roster = onPlaguelands ? m_t4Roster : m_rvrRoster;

        Group* group = player->GetGroup();
        if (group && (group->IsRaidGroup() || group->GetLeaderGuid() != player->GetObjectGuid()))
        {
            handler.PSendSysMessage("|cffffd100[Barrens Front]|r You need to lead your party (not a raid) to raise a warband.");
            return true;
        }

        uint32 space = group ? (group->IsFull() ? 0 : uint32(MAX_GROUP_SIZE - group->GetMembersCount())) : uint32(MAX_GROUP_SIZE - 1);
        if (!space)
        {
            handler.PSendSysMessage("|cffffd100[Barrens Front]|r Your party is full.");
            return true;
        }

        // Nearest enlisted bots of your side in the lake, not busy
        std::vector<std::pair<float, Player*>> candidates;
        {
            HashMapHolder<Player>::ReadGuard guard(HashMapHolder<Player>::GetLock());
            for (const auto& entry : sObjectAccessor.GetPlayers())
            {
                Player* bot = entry.second;
                if (!bot || bot->isRealPlayer() || !bot->IsInWorld() || bot->GetTeam() != player->GetTeam() || !bot->IsAlive() ||
                    bot->IsInCombat() || bot->GetGroup() || bot->GetMapId() != FRONT_MAP || bot->IsBeingTeleported())
                {
                    continue;
                }

                const uint32 botId = bot->GetObjectGuid().GetCounter();
                if (!roster.count(botId))
                {
                    continue;
                }

                candidates.emplace_back(bot->GetDistance(player), bot);
            }
        }

        std::sort(candidates.begin(), candidates.end(), [](const auto& l, const auto& r) { return l.first < r.first; });
        std::vector<uint32> joined;
        std::ostringstream names;
        for (const auto& candidate : candidates)
        {
            if (joined.size() >= space)
            {
                break;
            }

            Player* bot = candidate.second;
            const uint32 botId = bot->GetObjectGuid().GetCounter();
            if (!RenownBotJoinWarband(bot, player))
            {
                continue;
            }

            roster.erase(botId);
            m_rvrBotOrders.erase(botId);
            m_rvrDirectedBots.erase(botId);
            m_t4Orders.erase(botId);
            m_t4Directed.erase(botId);
            if (candidate.first > 60.0f)
            {
                // Ride over: appear beside the leader
                bot->TeleportTo(player->GetMapId(), player->GetPositionX() + frand(-3.0f, 3.0f), player->GetPositionY() + frand(-3.0f, 3.0f),
                                player->GetPositionZ(), player->GetOrientation());
            }

            names << (joined.empty() ? "" : ", ") << bot->GetName();
            joined.push_back(botId);
        }

        if (joined.empty())
        {
            handler.PSendSysMessage("|cffffd100[Barrens Front]|r No soldiers of your side are free right now. Try again in a minute.");
            return true;
        }

        {
            std::lock_guard<std::mutex> lock(m_frontMutex);
            std::vector<uint32>& band = m_frontWarbands[leaderId];
            band.insert(band.end(), joined.begin(), joined.end());
        }

        handler.PSendSysMessage("|cffffd100[Barrens Front]|r Your warband rallies to you: %s. They follow you while you are on the front (.renown warband dismiss to send them back).",
                                names.str().c_str());
        return true;
#endif
    }
}
