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
    , insigniaRanks({ 5, 10, 15, 20, 25, 30 })
    , insigniaItems({ 190520, 190521, 190522, 190523, 190524, 190525 })
    , quartermasters({ 190100, 190101 })
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

        const std::vector<uint32> ranks = ParseList(config.GetStringDefault("Renown.InsigniaRanks", "5,10,15,20,25,30"));
        const std::vector<uint32> items = ParseList(config.GetStringDefault("Renown.InsigniaItems", "190520,190521,190522,190523,190524,190525"));
        if (!ranks.empty() && ranks.size() == items.size())
        {
            insigniaRanks = ranks;
            insigniaItems = items;
        }

        const std::vector<uint32> npcs = ParseList(config.GetStringDefault("Renown.Quartermasters", "190100,190101"));
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
