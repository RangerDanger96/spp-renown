#include "RenownModuleConfig.h"
#include "Module.h"

#include <cmath>
#include <cstdlib>

namespace cmangos_module
{
    namespace
    {
        std::vector<uint32> ParseList(const std::string& input)
        {
            std::vector<uint32> values;
            for (const std::string& part : helper::SplitString(input, ","))
            {
                std::string trimmed;
                for (char c : part)
                {
                    if (c != ' ' && c != '\t')
                    {
                        trimmed += c;
                    }
                }

                if (!trimmed.empty() && helper::IsValidNumberString(trimmed))
                {
                    values.push_back((uint32)std::strtoul(trimmed.c_str(), nullptr, 10));
                }
            }

            return values;
        }
    }

    RenownModuleConfig::RenownModuleConfig()
    : ModuleConfig("renown.conf")
    , enabled(true)
    , botsEarnRenown(true)
    , maxRank(40)
    , rankBase(100.0f)
    , rankExponent(1.5f)
    , rate(1.0f)
    , announceEvery(5)
    , bolsterEnabled(true)
    , lootBags(true)
    , lootBagPointsGold(100)
    , lootBagPointsPurple(60)
    , lootBagPointsBlue(30)
    , lootBagItemChanceGold(100)
    , lootBagItemChancePurple(50)
    , lootBagItemChanceBlue(25)
    , lootBagDungeonLoot(true)
    , streaks(true)
    , streakBonusPerKill(2)
    , streakBonusMax(30)
    , bountyMinStreak(5)
    , bountyPerKill(10)
    , bountyMax(250)
    , pointsHealAssist(5)
    , assistWindow(15)
    , rvrEnabled(true)
    , rvrMaxLevel(19)
    , rvrCaptureTime(20)
    , rvrCaptureRadius(25)
    , rvrCapturePoints(40)
    , rvrTickPoints(5)
    , rvrDefendPoints(10)
    , rvrSiegeHold(120)
    , rvrLockMinutes(20)
    , rvrBotsPerSide(0)
    , rvrBotShare(80)
    , rvrBotsPerWave(15)
    , fieldMount(true)
    , fieldMountBots(true)
    , fieldMountSpeed(30)
    , fieldMountMaxLevel(39)
    , questsEnabled(true)
    , questsPerDay(3)
    , questResetHour(6)
    , questDailyRenown(150)
    , questWeeklyRenown(500)
    , questDailyXPPercent(15)
    , questWeeklyXPPercent(50)
    , questDailyBagChance(15)
    , pvpXPPercent(12)
    , rvrSpiritWave(30)
    , rvrFrontBotsActive(30)
    , rvrFrontBotsIdle(8)
    , pointsHonorableKill(10)
    , pointsKillingBlow(5)
    , pointsWorldKill(10)
    , pointsFlagCapture(50)
    , pointsFlagReturn(20)
    , pointsBaseAssault(30)
    , pointsBaseDefend(20)
    , pointsGraveyardAssault(30)
    , pointsGraveyardDefend(20)
    , pointsTowerAssault(40)
    , pointsTowerDefend(30)
    , pointsSecondaryObjective(20)
    , pointsWin(100)
    , pointsLoss(40)
    , insigniaRanks({ 5, 10, 15, 20, 25, 30, 33, 36, 40 })
    , insigniaItems({ 190520, 190521, 190522, 190523, 190524, 190525, 190526, 190527, 190528 })
    , quartermasters({ 190100, 190101, 190108, 190109, 190110, 190111 })
    {

    }

    bool RenownModuleConfig::OnLoad()
    {
        enabled = config.GetBoolDefault("Renown.Enable", true);
        botsEarnRenown = config.GetBoolDefault("Renown.Bots", true);
        maxRank = config.GetIntDefault("Renown.MaxRank", 40);
        rankBase = config.GetFloatDefault("Renown.RankBase", 100.0f);
        rankExponent = config.GetFloatDefault("Renown.RankExponent", 1.5f);
        rate = config.GetFloatDefault("Renown.Rate", 1.0f);
        announceEvery = config.GetIntDefault("Renown.AnnounceEvery", 5);
        bolsterEnabled = config.GetBoolDefault("Renown.Bolster", true);

        lootBags = config.GetBoolDefault("Renown.LootBags", true);
        lootBagPointsGold = config.GetIntDefault("Renown.LootBags.GoldPoints", 100);
        lootBagPointsPurple = config.GetIntDefault("Renown.LootBags.PurplePoints", 60);
        lootBagPointsBlue = config.GetIntDefault("Renown.LootBags.BluePoints", 30);
        lootBagItemChanceGold = config.GetIntDefault("Renown.LootBags.GoldItemChance", 100);
        lootBagItemChancePurple = config.GetIntDefault("Renown.LootBags.PurpleItemChance", 50);
        lootBagItemChanceBlue = config.GetIntDefault("Renown.LootBags.BlueItemChance", 25);
        lootBagDungeonLoot = config.GetBoolDefault("Renown.LootBags.DungeonLoot", true);

        streaks = config.GetBoolDefault("Renown.Streaks", true);
        streakBonusPerKill = config.GetIntDefault("Renown.Streaks.BonusPerKill", 2);
        streakBonusMax = config.GetIntDefault("Renown.Streaks.BonusMax", 30);
        bountyMinStreak = config.GetIntDefault("Renown.Bounty.MinStreak", 5);
        bountyPerKill = config.GetIntDefault("Renown.Bounty.PerKill", 10);
        bountyMax = config.GetIntDefault("Renown.Bounty.Max", 250);

        pointsHealAssist = config.GetIntDefault("Renown.Points.HealAssist", 5);
        assistWindow = config.GetIntDefault("Renown.AssistWindow", 15);

        rvrEnabled = config.GetBoolDefault("Renown.RvR.Enable", true);
        rvrMaxLevel = config.GetIntDefault("Renown.RvR.MaxLevel", 19);
        rvrCaptureTime = config.GetIntDefault("Renown.RvR.CaptureTime", 20);
        rvrCaptureRadius = config.GetIntDefault("Renown.RvR.CaptureRadius", 25);
        rvrCapturePoints = config.GetIntDefault("Renown.RvR.CapturePoints", 40);
        rvrTickPoints = config.GetIntDefault("Renown.RvR.TickPoints", 5);
        rvrDefendPoints = config.GetIntDefault("Renown.RvR.DefendPoints", 10);
        rvrSiegeHold = config.GetIntDefault("Renown.RvR.SiegeHold", 120);
        rvrLockMinutes = config.GetIntDefault("Renown.RvR.LockMinutes", 20);
        rvrBotsPerSide = config.GetIntDefault("Renown.RvR.BotsPerSide", 0);
        rvrBotShare = config.GetIntDefault("Renown.RvR.BotShare", 80);
        rvrBotsPerWave = config.GetIntDefault("Renown.RvR.BotsPerWave", 15);

        fieldMount = config.GetBoolDefault("Renown.FieldMount.Enable", true);
        fieldMountBots = config.GetBoolDefault("Renown.FieldMount.Bots", true);
        fieldMountSpeed = config.GetIntDefault("Renown.FieldMount.Speed", 30);
        fieldMountMaxLevel = config.GetIntDefault("Renown.FieldMount.MaxLevel", 39);

        questsEnabled = config.GetBoolDefault("Renown.Quests.Enable", true);
        questsPerDay = config.GetIntDefault("Renown.Quests.PerDay", 3);
        questResetHour = config.GetIntDefault("Renown.Quests.ResetHour", 6) % 24;
        questDailyRenown = config.GetIntDefault("Renown.Quests.DailyRenown", 150);
        questWeeklyRenown = config.GetIntDefault("Renown.Quests.WeeklyRenown", 500);
        questDailyXPPercent = config.GetIntDefault("Renown.Quests.DailyXPPercent", 15);
        questWeeklyXPPercent = config.GetIntDefault("Renown.Quests.WeeklyXPPercent", 50);
        questDailyBagChance = config.GetIntDefault("Renown.Quests.DailyBagChance", 15);
        pvpXPPercent = config.GetIntDefault("Renown.PvPXP.Percent", 12);
        rvrSpiritWave = config.GetIntDefault("Renown.RvR.SpiritWave", 30);
        rvrFrontBotsActive = config.GetIntDefault("Renown.RvR.FrontBotsActive", 30);
        rvrFrontBotsIdle = config.GetIntDefault("Renown.RvR.FrontBotsIdle", 8);

        pointsHonorableKill = config.GetIntDefault("Renown.Points.HonorableKill", 10);
        pointsKillingBlow = config.GetIntDefault("Renown.Points.KillingBlow", 5);
        pointsWorldKill = config.GetIntDefault("Renown.Points.WorldKill", 10);
        pointsFlagCapture = config.GetIntDefault("Renown.Points.FlagCapture", 50);
        pointsFlagReturn = config.GetIntDefault("Renown.Points.FlagReturn", 20);
        pointsBaseAssault = config.GetIntDefault("Renown.Points.BaseAssault", 30);
        pointsBaseDefend = config.GetIntDefault("Renown.Points.BaseDefend", 20);
        pointsGraveyardAssault = config.GetIntDefault("Renown.Points.GraveyardAssault", 30);
        pointsGraveyardDefend = config.GetIntDefault("Renown.Points.GraveyardDefend", 20);
        pointsTowerAssault = config.GetIntDefault("Renown.Points.TowerAssault", 40);
        pointsTowerDefend = config.GetIntDefault("Renown.Points.TowerDefend", 30);
        pointsSecondaryObjective = config.GetIntDefault("Renown.Points.SecondaryObjective", 20);
        pointsWin = config.GetIntDefault("Renown.Points.Win", 100);
        pointsLoss = config.GetIntDefault("Renown.Points.Loss", 40);

        const std::vector<uint32> ranks = ParseList(config.GetStringDefault("Renown.InsigniaRanks", "5,10,15,20,25,30,33,36,40"));
        const std::vector<uint32> items = ParseList(config.GetStringDefault("Renown.InsigniaItems", "190520,190521,190522,190523,190524,190525,190526,190527,190528"));
        if (!ranks.empty() && ranks.size() == items.size())
        {
            insigniaRanks = ranks;
            insigniaItems = items;
        }

        const std::vector<uint32> npcs = ParseList(config.GetStringDefault("Renown.Quartermasters", "190100,190101,190108,190109,190110,190111"));
        if (!npcs.empty())
        {
            quartermasters = npcs;
        }

        if (maxRank < 1)
        {
            maxRank = 1;
        }

        if (rankBase < 1.0f)
        {
            rankBase = 1.0f;
        }

        if (rankExponent < 0.1f)
        {
            rankExponent = 0.1f;
        }

        if (rate < 0.0f)
        {
            rate = 0.0f;
        }

        return true;
    }

    uint32 RenownModuleConfig::GetPointsForRank(uint32 rank) const
    {
        if (rank <= 1)
        {
            return 0;
        }

        return (uint32)std::lround(rankBase * std::pow((double)(rank - 1), (double)rankExponent));
    }

    uint32 RenownModuleConfig::GetRankForPoints(uint32 points) const
    {
        uint32 rank = 1;
        while (rank < maxRank && points >= GetPointsForRank(rank + 1))
        {
            ++rank;
        }

        return rank;
    }
}
