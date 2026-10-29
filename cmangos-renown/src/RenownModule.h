#ifndef CMANGOS_MODULE_RENOWN_H
#define CMANGOS_MODULE_RENOWN_H

#include "Module.h"
#include "RenownModuleConfig.h"

#include <mutex>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include "Entities/Object.h"

namespace cmangos_module
{
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
        bool HandleReloadCommand(WorldSession* session, const std::string& args);

        void LoadVendorCosts();

        // Loot bags
        enum BagType { BAG_GOLD = 0, BAG_PURPLE = 1, BAG_BLUE = 2 };
        void AwardLootBags(BattleGround* battleground, uint32 winnerTeam);
        void GiveLootBag(Player* player, BagType bag);
        uint32 PickRewardItem(Player* player) const;
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
        std::unordered_map<uint32, time_t> m_rvrHintTime;   // last "center is locked" hint per player
        uint32 m_rvrHoldTeam = 0;
        uint32 m_rvrHoldTime = 0;
        uint32 m_rvrSiegeTeam = 0;                       // attacking team during a siege
        uint32 m_rvrLockTeam = 0;
        time_t m_rvrLockUntil = 0;
        bool m_rvrDirty = true;
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
