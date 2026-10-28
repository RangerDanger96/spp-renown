#ifndef CMANGOS_MODULE_RENOWN_H
#define CMANGOS_MODULE_RENOWN_H

#include "Module.h"
#include "RenownModuleConfig.h"

#include <mutex>
#include <string>
#include <unordered_map>

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

        // Player hooks
        void OnLoadFromDB(Player* player) override;
        void OnSaveToDB(Player* player) override;
        void OnDeleteFromDB(uint32 playerId) override;
        void OnLogOut(Player* player) override;
        void OnRewardHonor(Player* player, Unit* victim) override;

        // Battleground hooks
        void OnUpdatePlayerScore(BattleGround* battleground, Player* player, uint8 scoreType, uint32 value) override;
        void OnEndBattleGround(BattleGround* battleground, uint32 winnerTeam) override;

        // Gossip hooks
        bool OnPreGossipHello(Player* player, Creature* creature) override;

        // Chat commands: .renown info | .renown top | .renown add <points> [name] | .renown set <rank> [name]
        const char* GetChatCommandPrefix() const override { return "renown"; }
        std::vector<ModuleChatCommand>* GetCommandTable() override;

    private:
        struct RenownData
        {
            uint32 points = 0;
            uint32 rank = 1;
            uint64 lastVictim = 0;
            time_t lastVictimTime = 0;
        };

        // Adds (scaled) renown points to a player and handles rank ups
        void AddRenown(Player* player, uint32 basePoints, bool applyRate = true);
        void SetRenownPoints(Player* player, uint32 points);
        void OnRankChanged(Player* player, uint32 oldRank, uint32 newRank);

        // Gives the player every insignia they have earned but don't own yet
        void GrantMissingInsignias(Player* player, uint32 rank, bool silent);
        void SendStatus(Player* target, Player* about) const;

        bool CanEarnRenown(const Player* player) const;
        static std::string GetRankTitle(uint32 rank);
        RenownData GetData(uint32 playerId);

        bool HandleInfoCommand(WorldSession* session, const std::string& args);
        bool HandleTopCommand(WorldSession* session, const std::string& args);
        bool HandleAddCommand(WorldSession* session, const std::string& args);
        bool HandleSetCommand(WorldSession* session, const std::string& args);
        Player* ResolveCommandTarget(WorldSession* session, const std::string& name) const;

    private:
        std::unordered_map<uint32, RenownData> m_data;
        mutable std::mutex m_dataMutex;
    };
}

#endif
