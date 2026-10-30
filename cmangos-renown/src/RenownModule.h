#ifndef CMANGOS_MODULE_RENOWN_H
#define CMANGOS_MODULE_RENOWN_H

#include "Module.h"
#include "RenownModuleConfig.h"

#include <array>
#include <atomic>
#include <mutex>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include "Entities/Object.h"

class ChatHandler;
class Map;
class Creature;
class Player;

namespace cmangos_module
{
    // true when the player is safely in a map (not logging out / mid far-teleport)
    bool RenownPlayerOk(const Player* player);

    // Warhammer-style Renown: a PvP progression earned from kills, objectives and
    // battleground results. Ranks never decay and are stored per character.
    class RenownModule : public Module
    {
    public:
        RenownModule();
        const RenownModuleConfig* GetConfig() const override;

        // Module hooks
        void OnInitialize() override;
        void OnUpdate(uint32 elapsed) override;
        void OnKill(Unit* unit, Unit* victim) override;

        // Quest hooks (war board)
        void OnGetQuestXP(Player* player, const Quest* quest, uint32& xp) override;
        void OnRewardQuest(Player* player, const Quest* quest) override;

        // Player hooks
        void OnLoadFromDB(Player* player) override;
        void OnSaveToDB(Player* player) override;
        void OnDeleteFromDB(uint32 playerId) override;
        void OnLogOut(Player* player) override;
        void OnRewardHonor(Player* player, Unit* victim) override;
        void OnGetPlayerLevelInfo(Player* player, PlayerLevelInfo& info) override;
        void OnGetPlayerClassLevelInfo(Player* player, PlayerClassLevelInfo& info) override;

        // Vendor hooks: items listed in custom_renown_vendor cost Renown points instead of gold
        bool OnPreBuyItem(Player* player, Creature* vendor, uint32 itemId, uint32 count, uint32& price) override;
        void OnBuyItem(Player* player, Creature* vendor, Item* item, uint32 count) override;

        // Battleground hooks
        void OnUpdatePlayerScore(BattleGround* battleground, Player* player, uint8 scoreType, uint32 value) override;
        void OnEndBattleGround(BattleGround* battleground, uint32 winnerTeam) override;
        void OnJoinBattleGround(BattleGround* battleground, Player* player) override;
        void OnLeaveBattleGround(BattleGround* battleground, Player* player) override;

        // Combat hooks: kill streaks, bounties and healing assists
        void OnDeath(Player* player, Unit* killer) override;
        void OnDealDamage(Unit* unit, Unit* victim, uint32 health, uint32 damage) override;
        void OnDealHeal(Unit* unit, Unit* victim, int32 gain, uint32 addHealth) override;

        // WoW Forever warrior talents (RenownTalents.cpp)
        void OnRegenerate(Player* player, uint8 power, uint32 diff, float& addedValue) override;
        bool OnCalculateEffectiveCritChance(const Unit* unit, const Unit* victim, uint8 attType, const SpellEntry* ability, float& outChance) override;
        bool OnCalculateEffectiveMissChance(const Unit* unit, const Unit* victim, uint8 attType, const SpellEntry* ability, const Spell* const* currentSpells, const SpellPartialResistDistribution& spellPartialResistDistribution, float& outChance) override;
        void OnHit(Spell* spell, Unit* caster, Unit* victim) override;
        void OnCast(Spell* spell, Unit* caster, Unit* victim) override;
        void TalentsInit();
        void TalentsOnDealDamage(Unit* dealer, Unit* victim, uint32 damage);
        void TalentsOnLogout(Player* player);

        // Gossip hooks
        bool OnPreGossipHello(Player* player, Creature* creature) override;

        // Chat commands: .renown info | .renown top | .renown sync | .renown add <points> [name] | .renown set <rank> [name]
        const char* GetChatCommandPrefix() const override { return "renown"; }
        std::vector<ModuleChatCommand>* GetCommandTable() override;

    private:
        struct RenownData
        {
            uint32 points = 0;      // lifetime renown (decides the rank, never goes down)
            uint32 spendable = 0;   // renown points available to spend at vendors
            uint32 rank = 1;
            uint64 lastVictim = 0;
            time_t lastVictimTime = 0;
            uint32 bgEarned = 0;    // renown earned in the current battleground (loot bag ranking)
            uint32 streak = 0;      // player kills since the last death
            uint32 lakeEarned = 0;  // renown earned in the RvR lake since the last lock (loot bag ranking)
        };

        // Adds (scaled) renown points to a player and handles rank ups
        void AddRenown(Player* player, uint32 basePoints, bool applyRate = true);
        void SetRenownPoints(Player* player, uint32 points);
        void OnRankChanged(Player* player, uint32 oldRank, uint32 newRank);

        // Gives the player every insignia they have earned but don't own yet
        void GrantMissingInsignias(Player* player, uint32 rank, bool silent);
        void SendStatus(Player* target, Player* about) const;
        // Pushes the player's renown to the RenownBar addon (hidden addon message, no chat output)
        void SendAddonUpdate(Player* player) const;

        bool CanEarnRenown(const Player* player) const;

        // Bolster: inside a battleground, players below their bracket's top level get that level's
        // base stats, health and mana. Returns 0 when the player should not be bolstered.
        uint32 GetBolsterLevel(const Player* player) const;
        uint32 CalculateBolsterLevel(BattleGround* battleground, Player* player) const;
        // Rebuilds the player's base stats for the given level, keeping health/mana percentages
        void ApplyLevelStats(Player* player, uint32 level);
        static std::string GetRankTitle(uint32 rank);
        RenownData GetData(uint32 playerId);

        bool HandleInfoCommand(WorldSession* session, const std::string& args);
        bool HandleTopCommand(WorldSession* session, const std::string& args);
        bool HandleAddCommand(WorldSession* session, const std::string& args);
        bool HandleSetCommand(WorldSession* session, const std::string& args);
        bool HandleSyncCommand(WorldSession* session, const std::string& args);
        bool HandleGiveCommand(WorldSession* session, const std::string& args);
        bool HandleQueueCommand(WorldSession* session, const std::string& args);
        bool HandleRvRCommand(WorldSession* session, const std::string& args);
        bool HandleMountCommand(WorldSession* session, const std::string& args);

        // Field mount: the racial mount at reduced speed for low-level characters
        static uint32 FieldMountSpell(const Player* player);
        bool CastFieldMount(Player* player, bool instant);
        void UpdateBotMounts(const std::vector<Player*>& players);
        void RvRDirectBots(const std::vector<Player*>& players);
        void RvRSpiritWave(const std::vector<Player*>& players);
        void RvRStats(ChatHandler& handler);
        bool HandleReloadCommand(WorldSession* session, const std::string& args);
        bool HandleWarbandCommand(WorldSession* session, const std::string& args);
        bool HandleSessionCommand(WorldSession* session, const std::string& args);

        // ---- Front life (RenownFront.cpp): announcer, sessions, MVPs, underdog, protection, field orders,
        //      supply caravans, hero bots, nemesis, town criers, warbands
        struct FrontSession { uint32 kills = 0, deaths = 0, captures = 0, renown = 0, bestStreak = 0, startLevel = 0; time_t start = 0; };
        struct FrontCycle { std::string name; uint32 team = 0, kills = 0, heals = 0, objectives = 0; bool real = false; };
        struct FieldOrder { uint8 type = 0; uint8 objective = 0; time_t ends = 0; ObjectGuid bearer[2]; bool bearerDown[2] = { false, false }; float bearerPos[2][3] = {}; };
        struct Caravan { bool active = false; ObjectGuid kodo; ObjectGuid escorts[2]; std::vector<std::array<float, 3>> path; size_t next = 0; uint8 dest = 0; float lastPos[3] = {}; time_t started = 0; };

        void FrontFX(const std::string& text, uint32 team, uint32 soundAlliance, uint32 soundHorde, bool chat = true);
        void FrontEnter(Player* player);
        void FrontLeave(Player* player);
        void FrontOnKill(Player* killer, Player* victim, uint32 oldStreak, uint32 newStreak);
        void FrontOnHealAssist(Player* healer);
        void FrontOnCapture(size_t index, uint32 team, uint32 previous, const std::vector<Player*>& capturers);
        void FrontOnAssault(size_t index, uint32 attacker);
        void FrontOnSiege(uint32 team);
        void FrontOnVictory(uint32 team);
        void FrontOnRenown(Player* player, uint32 gained);
        void FrontProtect(Player* player);
        void FrontUpdate(uint32 diff, const std::vector<Player*>& players, const std::vector<Player*>& members);
        float FrontCaptureRate(size_t index, uint32 team) const;
        uint32 FrontRenownBonus(Player* player, uint32 gained) const;
        bool FrontIsWarbandBot(uint32 botId) const;
        void FrontDismissWarband(uint32 leaderId, Player* leader, bool announce);
        void FrontSessionSummary(Player* player, bool final);
        void FrontUpdateOrders(const std::vector<Player*>& members);
        void FrontUpdateCaravans(const std::vector<Player*>& members);
        void FrontUpdateHeroes(const std::vector<Player*>& members);
        void FrontCrier();
        Map* FrontMap(const std::vector<Player*>& members) const;

        // ---- Plaguelands Front (RenownT4.cpp): tier 4 RvR at level 60 on the Eastern Plaguelands towers
        void OnRewardPlayerAtKill(Player* player, Unit* victim) override;
        void T4Init();
        void T4Update(uint32 diff);
        uint32 T4TowerOwner(uint32 tower) const;
        uint32 T4OwnedBy(uint32 team) const;
        bool T4IsMember(uint32 playerId) const { return m_t4Members.count(playerId) > 0; }
        void T4Enter(Player* player);
        void T4Leave(Player* player);
        void T4FX(const std::string& text, uint32 team, uint32 sound);
        void T4Reinforce(const std::vector<Player*>& players, bool watched);
        void T4Direct(const std::vector<Player*>& players);
        void T4StartSiege(uint32 team, const std::vector<Player*>& members);
        void T4StopSiege(bool announce);
        void T4Victory(uint32 team, const std::vector<Player*>& members);
        void T4SetHolder(uint32 team);
        void T4Stats(ChatHandler& handler);
        bool HandleT4Command(WorldSession* session, const std::string& args);

        void LoadVendorCosts();

        // Loot bags
        enum BagType { BAG_GOLD = 0, BAG_PURPLE = 1, BAG_BLUE = 2 };
        void AwardLootBags(BattleGround* battleground, uint32 winnerTeam);
        void GiveLootBag(Player* player, BagType bag);
        uint32 PickRewardItem(Player* player) const;
        struct DungeonLoot { uint32 item; uint32 map; uint32 reqLevel; uint32 quality; };
        void LoadDungeonLoot();
        uint32 PickDungeonItem(Player* player, BagType bag, uint32& map) const;
        void GiveItem(Player* player, uint32 itemId, const std::string& subject);
        uint32 GetRenownTier(Player* player) const;   // highest unlocked reward tier (0 = none)

        // ---- War board quests
        static bool IsFrontQuest(uint32 questId, bool& weekly);
        uint32 QuestDayKey() const;
        void QuestsInit();
        void QuestsUpdate(uint32 diff);
        void QuestsNewDay();
        void QuestsApplyRotation(uint32 mask);
        void QuestsLoad(Player* player);
        void QuestsSave(Player* player);
        void QuestCredit(Player* player, uint32 creditEntry);

        // ---- RvR lake (Barrens Front, tier 1)
        struct RvRObjective
        {
            const char* name;
            float x, y, z;
            bool tower;
            uint32 owner = 0;         // 0 = neutral, else ALLIANCE / HORDE
            uint32 capTeam = 0;
            uint32 progress = 0;      // ms of uncontested capture
            time_t fortifiedUntil = 0; // supply caravan delivered: enemy captures at half speed
        };

        void RvRInit();
        void RvRUpdate(uint32 diff);
        void RvRSetOwner(size_t index, uint32 team, bool force = false);
        void RvRReset();
        void RvRLock(uint32 team);
        void RvRStartSiege(uint32 team);
        void RvRStopSiege();
        void RvRAnnounce(const std::string& text, bool worldwide = false) const;
        void RvRSendStatus(Player* player) const;
        void RvRReinforce(const std::vector<Player*>& players);
        void RvREnterLake(Player* player);
        void RvRLeaveLake(Player* player);
        bool RvRInLakeArea(const Player* player) const;
        bool RvRIsMember(uint32 playerId) const;
        void RvRFrontPoint(uint32 team, float& x, float& y, float& z) const;
        uint32 RvROwnedBy(uint32 team) const;
        void RvRAwardBags(uint32 winner);

        // Streaks / assists
        void Announce(Player* source, const std::string& text) const;
        void RecordRecent(std::unordered_map<uint32, std::vector<std::pair<uint32, time_t>>>& map, uint32 key, uint32 who, time_t now);
        uint32 GetRenownCost(uint32 itemId) const;
        void SaveData(uint32 playerId, const RenownData& data);
        // Sends the renown item prices to the RenownBar addon so the vendor window can show "X Renown"
        void SendAddonPrices(Player* player) const;
        Player* ResolveCommandTarget(WorldSession* session, const std::string& name) const;

    private:
        std::unordered_map<uint32, RenownData> m_data;
        mutable std::mutex m_dataMutex;

        std::unordered_map<uint32, uint32> m_vendorCosts; // item entry -> renown cost
        std::unordered_map<uint32, uint32> m_vendorTiers; // item entry -> reward tier (0 = open)
        std::vector<DungeonLoot> m_dungeonLoot;          // loot bag gear from 5-player dungeons

        // victim guid -> recent attackers, player guid -> recent healers (guid, time)
        std::unordered_map<uint32, std::vector<std::pair<uint32, time_t>>> m_attackers;
        std::unordered_map<uint32, std::vector<std::pair<uint32, time_t>>> m_healers;
        mutable std::mutex m_combatMutex;
        mutable std::mutex m_vendorMutex;

        std::unordered_map<uint32, uint32> m_bolster;   // player guid -> bolstered level

        std::vector<RvRObjective> m_rvrObjectives;
        std::unordered_set<uint32> m_rvrMembers;         // players inside the lake
        std::unordered_set<uint32> m_rvrChickens;        // over-level players turned into chickens
        std::unordered_map<uint32, WorldLocation> m_rvrReturn;
        uint32 m_rvrTimer = 0;
        uint32 m_rvrTickTimer = 0;
        uint32 m_rvrStatusTimer = 0;
        uint32 m_rvrBotTimer = 0;
        uint32 m_rvrMountTimer = 0;
        std::unordered_set<uint32> m_rvrDirectedBots;
        std::unordered_set<uint32> m_rvrRoster;              // bots enlisted for the front
        std::vector<time_t> m_rvrCaptureLog, m_rvrSiegeLog;  // for .renown rvr stats
        std::unordered_map<uint32, uint8> m_rvrBotOrders;    // front bot -> current order
        uint32 m_rvrSpiritTimer = 0;
        std::unordered_map<uint32, time_t> m_rvrHintTime;   // last "center is locked" hint per player
        uint32 m_rvrHoldTeam = 0;
        // Plaguelands Front (tier 4)
        bool m_t4Ready = false;
        bool m_t4Tried = false;
        uint32 m_t4Timer = 0, m_t4TickTimer = 0, m_t4BotTimer = 0, m_t4DirectTimer = 0;
        uint32 m_t4HoldTeam = 0, m_t4HoldTime = 0, m_t4SiegeTeam = 0, m_t4LockTeam = 0, m_t4Holder = 0;
        time_t m_t4LockUntil = 0, m_t4SiegeStart = 0;
        uint32 m_t4LastOwner[4] = { 0, 0, 0, 0 };
        ObjectGuid m_t4Lord;
        float m_t4LordPos[3] = {};
        std::unordered_set<uint32> m_t4Members, m_t4Roster, m_t4Directed;
        std::unordered_map<uint32, uint8> m_t4Orders;
        // front life
        std::mutex m_frontMutex;                                       // guards the maps below (deaths come from map threads)
        std::unordered_map<uint32, FrontSession> m_frontSessions;      // real players on the front
        std::unordered_map<uint32, FrontCycle> m_frontCycle;           // per front cycle, for MVPs
        std::unordered_map<uint64, uint32> m_frontKillCount;           // (victim << 32 | killer) -> kills
        std::unordered_map<uint32, uint32> m_frontNemesis;             // victim -> nemesis
        std::unordered_map<uint32, uint8> m_frontHeroes;               // hero bot -> side (0 alliance, 1 horde)
        std::unordered_map<uint32, std::vector<uint32>> m_frontWarbands; // leader -> bots
        std::unordered_map<uint32, time_t> m_frontProtect;             // spawn protection until
        bool m_frontFirstBlood = false;
        uint32 m_frontUnderdog = 0;
        uint32 m_frontTimer = 0;
        time_t m_frontNextOrder = 0, m_frontNextCaravan[2] = { 0, 0 }, m_frontNextCrier = 0, m_frontHeroCheck = 0;
        FieldOrder m_frontOrder;
        Caravan m_frontCaravans[2];
        uint32 m_rvrHoldTime = 0;
        uint32 m_rvrSiegeTeam = 0;                       // attacking team during a siege
        uint32 m_rvrLockTeam = 0;
        time_t m_rvrLockUntil = 0;
        bool m_rvrDirty = true;
        // Barrens domination: one tug-of-war bar fed by objectives, kills, battlegrounds and war board quests.
        // Hundredths of a percent, +10000 = Alliance dominates, -10000 = Horde dominates. Full bar opens the siege.
        std::atomic<int32> m_rvrDom{0};
        uint32 m_rvrDomTimer = 0;
        int32 m_rvrDomSent = 0;
    public:
        void RvRDominate(uint32 team, int32 amount);
    private:
        uint32 RvRNearObjective(const Player* player) const;
        bool m_rvrResetRequested = false;

        bool m_questsReady = false;
        uint32 m_questDay = 0;
        uint32 m_questMask = 0;
        uint32 m_questTimer = 0;
        std::mutex m_rvrReturnMutex;
        mutable std::mutex m_bolsterMutex;
    };
}

#endif
