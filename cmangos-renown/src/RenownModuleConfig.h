#ifndef CMANGOS_MODULE_RENOWN_CONFIG_H
#define CMANGOS_MODULE_RENOWN_CONFIG_H

#include "ModuleConfig.h"
#include "Platform/Define.h"

#include <vector>

namespace cmangos_module
{
    class RenownModuleConfig : public ModuleConfig
    {
    public:
        RenownModuleConfig();
        bool OnLoad() override;

        // Total renown points required to reach a rank (rank 1 = 0 points)
        uint32 GetPointsForRank(uint32 rank) const;
        // Rank for a given total of renown points
        uint32 GetRankForPoints(uint32 points) const;

    public:
        bool enabled;
        bool botsEarnRenown;
        uint32 maxRank;
        float rankBase;
        float rankExponent;
        float rate;
        uint32 announceEvery;
        bool bolsterEnabled;

        bool lootBags;
        uint32 lootBagPointsGold;
        uint32 lootBagPointsPurple;
        uint32 lootBagPointsBlue;
        uint32 lootBagItemChanceGold;
        uint32 lootBagItemChancePurple;
        uint32 lootBagItemChanceBlue;
        bool lootBagDungeonLoot;

        bool streaks;
        uint32 streakBonusPerKill;
        uint32 streakBonusMax;
        uint32 bountyMinStreak;
        uint32 bountyPerKill;
        uint32 bountyMax;

        uint32 pointsHealAssist;
        uint32 assistWindow;

        bool rvrEnabled;
        uint32 rvrMaxLevel;
        uint32 rvrCaptureTime;
        uint32 rvrCaptureRadius;
        uint32 rvrCapturePoints;
        uint32 rvrTickPoints;
        uint32 rvrDefendPoints;
        uint32 rvrSiegeHold;
        uint32 rvrLockMinutes;
        uint32 rvrBotsPerSide;
        uint32 rvrBotShare;
        uint32 rvrBotsPerWave;

        bool fieldMount;
        bool fieldMountBots;
        uint32 fieldMountSpeed;
        uint32 fieldMountMaxLevel;

        bool questsEnabled;
        uint32 questsPerDay;
        uint32 questResetHour;
        uint32 questDailyRenown;
        uint32 questWeeklyRenown;
        uint32 questDailyXPPercent;
        uint32 questWeeklyXPPercent;
        uint32 questDailyBagChance;
        uint32 pvpXPPercent;
        uint32 rvrSpiritWave;
        uint32 rvrFrontBotsActive;
        uint32 rvrFrontBotsIdle;

        uint32 pointsHonorableKill;
        uint32 pointsKillingBlow;
        uint32 pointsWorldKill;
        uint32 pointsFlagCapture;
        uint32 pointsFlagReturn;
        uint32 pointsBaseAssault;
        uint32 pointsBaseDefend;
        uint32 pointsGraveyardAssault;
        uint32 pointsGraveyardDefend;
        uint32 pointsTowerAssault;
        uint32 pointsTowerDefend;
        uint32 pointsSecondaryObjective;
        uint32 pointsWin;
        uint32 pointsLoss;

        std::vector<uint32> insigniaRanks;
        std::vector<uint32> insigniaItems;
        std::vector<uint32> quartermasters;
    };
}

#endif
