// WoW Forever style warrior talents: the custom mechanics behind the new and
// reworked talents (spell data lives in sql/zz_warrior_talents.sql and the
// client patch's Spell.dbc / Talent.dbc).
#include "RenownModule.h"

#if RENOWN_TALENTS

#include "Entities/Player.h"
#include "Entities/Item.h"
#include "Spells/Spell.h"
#include "Spells/SpellAuras.h"
#include "Spells/SpellMgr.h"
#include "Server/DBCStores.h"
#include "Globals/SharedDefines.h"

#include <initializer_list>
#include <mutex>
#include <unordered_map>

namespace cmangos_module
{
    namespace
    {
        // talent rank spells (index = rank - 1)
        const uint32 BLOODTHRILL_TRIGGER = 45001;
        const uint32 WEAPONMASTER_TRIGGER = 45007;
        const uint32 WEAPONMASTER[] = { 45008, 45009, 45010, 45011, 45012 };
        const uint32 LINGERING_RAGE[] = { 45013, 45014, 45015, 45016, 45017 };
        const uint32 FURIOUS_PRECISION[] = { 45018, 45019, 45020 };
        const float FURIOUS_PRECISION_PCT[] = { 4.0f, 7.0f, 10.0f };
        const uint32 RAGING_BLOWS = 45021;
        const uint32 WHIRLWIND_OFFHAND = 45022;
        const uint32 GORE_HEAL = 45023;
        const uint32 GORE_BUFF = 45024;
        const uint32 GORE_DRINKER[] = { 45025, 45026 };
        const uint32 VANGUARD = 45030;
        const uint32 BLOODTHIRST_SPEED = 45034;
        const uint32 SPEARING_STRIKE = 45000;
        const uint32 TACTICAL_MASTERY[] = { 12295, 12676, 12677, 12678, 12679 };
        const uint32 DUAL_WIELD_SPEC[] = { 23584, 23585, 23586, 23587, 23588 };
        const uint32 BLOOD_CRAZE[] = { 16487, 16489, 16492 };
        const uint32 BLOOD_CRAZE_REGEN[] = { 16488, 16490, 16491 };
        const uint32 IMP_BERSERKER_RAGE[] = { 20500, 20501 };
        const uint32 REND[] = { 772, 6546, 6547, 6548, 11572, 11573, 11574 };
        const uint32 SWORD_EXTRA_ATTACK = 16459;

        template <size_t N>
        uint32 TalentRank(Unit const* unit, const uint32 (&ranks)[N])
        {
            if (!unit || unit->GetTypeId() != TYPEID_PLAYER || unit->getClass() != CLASS_WARRIOR)
                return 0;
            for (size_t i = N; i > 0; --i)
                if (unit->HasSpell(ranks[i - 1]))
                    return uint32(i);
            return 0;
        }

        uint32 WeaponSubclass(Unit const* unit, WeaponAttackType att)
        {
            if (!unit || unit->GetTypeId() != TYPEID_PLAYER)
                return uint32(-1);
            Item* item = static_cast<Player const*>(unit)->GetWeaponForAttack(att, true, true);
            if (!item || !item->GetProto() || item->GetProto()->Class != ITEM_CLASS_WEAPON)
                return uint32(-1);
            return item->GetProto()->SubClass;
        }

        bool IsAny(uint32 id, std::initializer_list<uint32> ids)
        {
            for (uint32 x : ids)
                if (x == id)
                    return true;
            return false;
        }

        // ---- core hooks
        float ArmorIgnore(Unit const* attacker, Unit const* /*victim*/)
        {
            uint32 rank = TalentRank(attacker, WEAPONMASTER);
            if (!rank)
                return 0.0f;
            uint32 sub = WeaponSubclass(attacker, BASE_ATTACK);
            if (sub == ITEM_SUBCLASS_WEAPON_MACE || sub == ITEM_SUBCLASS_WEAPON_MACE2 || sub == ITEM_SUBCLASS_WEAPON_STAFF)
                return 0.03f * rank;
            return 0.0f;
        }

        float RageGain(Unit const* player, WeaponAttackType att)
        {
            if (att != OFF_ATTACK)
                return 1.0f;
            return 1.0f + 0.10f * TalentRank(player, DUAL_WIELD_SPEC);
        }

        float WeaponDamage(Unit const* /*caster*/, Unit const* target, SpellEntry const* spell)
        {
            if (!spell || spell->Id != SPEARING_STRIKE || !target)
                return 1.0f;
            uint32 type = target->GetCreatureType();
            if (type == CREATURE_TYPE_GIANT || type == CREATURE_TYPE_DRAGONKIN || target->IsMounted())
                return 1.8f;
            return 1.0f;
        }

        bool AllowForm(Unit const* caster, SpellEntry const* spell, uint32 form)
        {
            // Vanguard: Charge in Defensive Stance
            return spell && spell->SpellFamilyName == SPELLFAMILY_WARRIOR && (spell->SpellFamilyFlags & uint64(0x1)) &&
                   form == FORM_DEFENSIVESTANCE && caster && caster->HasSpell(VANGUARD);
        }

        uint32 StanceRetain(Unit const* caster)
        {
            if (!caster || caster->getClass() != CLASS_WARRIOR)
                return 0;
            // Tactical Mastery is baseline (10 rage); Improved Tactical Mastery adds 3 per rank
            return 100 + 30 * TalentRank(caster, TACTICAL_MASTERY);
        }

        // ---- Lingering Rage bookkeeping (regen only ticks out of combat)
        std::mutex g_rageMutex;
        struct RageTrack { uint32 lastTick = 0; uint32 combatEnd = 0; };
        std::unordered_map<uint32, RageTrack> g_rage;
    }

    void RenownModule::TalentsInit()
    {
        RenownHooks::ArmorIgnorePct = &ArmorIgnore;
        RenownHooks::RageGainMod = &RageGain;
        RenownHooks::WeaponDamageMod = &WeaponDamage;
        RenownHooks::AllowFormCast = &AllowForm;
        RenownHooks::StanceRageRetain = &StanceRetain;
    }

    void RenownModule::OnRegenerate(Player* player, uint8 power, uint32 /*diff*/, float& addedValue)
    {
        if (power != POWER_RAGE || !player || player->getClass() != CLASS_WARRIOR)
            return;
        uint32 rank = TalentRank(player, LINGERING_RAGE);
        if (!rank)
            return;
        uint32 now = WorldTimer::getMSTime();
        std::lock_guard<std::mutex> lock(g_rageMutex);
        RageTrack& t = g_rage[player->GetGUIDLow()];
        // regen ticks every ~2s out of combat; a longer gap means we just came out of combat
        if (!t.lastTick || WorldTimer::getMSTimeDiff(t.lastTick, now) > 3500)
            t.combatEnd = now;
        t.lastTick = now;
        if (WorldTimer::getMSTimeDiff(t.combatEnd, now) < 2000 * rank)
            addedValue = 0.0f;
    }

    bool RenownModule::OnCalculateEffectiveCritChance(const Unit* unit, const Unit* /*victim*/, uint8 attType, const SpellEntry* /*ability*/, float& outChance)
    {
        if (!unit || unit->GetTypeId() != TYPEID_PLAYER || unit->getClass() != CLASS_WARRIOR || attType > OFF_ATTACK)
            return false;
        uint32 rank = TalentRank(unit, WEAPONMASTER);
        if (!rank)
            return false;
        uint32 sub = WeaponSubclass(unit, WeaponAttackType(attType));
        if (sub == ITEM_SUBCLASS_WEAPON_AXE || sub == ITEM_SUBCLASS_WEAPON_AXE2 || sub == ITEM_SUBCLASS_WEAPON_POLEARM)
            outChance += float(rank);
        return false;
    }

    bool RenownModule::OnCalculateEffectiveMissChance(const Unit* unit, const Unit* /*victim*/, uint8 attType, const SpellEntry* ability, const Spell* const* /*currentSpells*/, const SpellPartialResistDistribution& /*dist*/, float& outChance)
    {
        if (ability || attType != OFF_ATTACK || !unit || unit->GetTypeId() != TYPEID_PLAYER || unit->getClass() != CLASS_WARRIOR)
            return false;
        if (uint32 rank = TalentRank(unit, FURIOUS_PRECISION))
            outChance -= FURIOUS_PRECISION_PCT[rank - 1];
        return false;
    }

    void RenownModule::OnHit(Spell* spell, Unit* caster, Unit* victim)
    {
        if (!spell || !caster || !victim || caster->GetTypeId() != TYPEID_PLAYER || caster->getClass() != CLASS_WARRIOR)
            return;
        SpellEntry const* info = spell->m_spellInfo;
        if (!info)
            return;

        switch (info->Id)
        {
            case BLOODTHRILL_TRIGGER:
            {
                for (uint32 rend : REND)
                {
                    if (victim->GetSpellAuraHolder(rend, caster->GetObjectGuid()))
                    {
                        caster->AddComboPoints(victim, 1);
                        caster->StartReactiveTimer(REACTIVE_OVERPOWER);
                        break;
                    }
                }
                return;
            }
            case WEAPONMASTER_TRIGGER:
            {
                uint32 sub = WeaponSubclass(caster, BASE_ATTACK);
                if ((sub == ITEM_SUBCLASS_WEAPON_SWORD || sub == ITEM_SUBCLASS_WEAPON_SWORD2) && victim != caster && victim->IsAlive())
                    caster->CastSpell(victim, SWORD_EXTRA_ATTACK, TRIGGERED_OLD_TRIGGERED);
                return;
            }
            case GORE_HEAL:
            {
                if (uint32 rank = TalentRank(caster, GORE_DRINKER))
                {
                    uint32 heal = std::max<uint32>(1, uint32(caster->GetMaxHealth() * 0.005f * rank));
                    caster->DealHeal(caster, heal, info);
                }
                return;
            }
            case SPEARING_STRIKE:
            {
                if (victim->GetTypeId() == TYPEID_PLAYER && victim->IsMounted())
                    victim->RemoveSpellsCausingAura(SPELL_AURA_MOUNTED);
                return;
            }
            default:
                break;
        }

        // Raging Blows: Whirlwind also strikes with the off-hand weapon
        if (info->SpellFamilyName == SPELLFAMILY_WARRIOR && (info->SpellFamilyFlags & uint64(0x80000000)) &&
                caster->HasSpell(RAGING_BLOWS) && victim != caster && victim->IsAlive() &&
                WeaponSubclass(caster, OFF_ATTACK) != uint32(-1))
            caster->CastSpell(victim, WHIRLWIND_OFFHAND, TRIGGERED_OLD_TRIGGERED);
    }

    void RenownModule::OnCast(Spell* spell, Unit* caster, Unit* /*victim*/)
    {
        if (!spell || !caster || caster->GetTypeId() != TYPEID_PLAYER || caster->getClass() != CLASS_WARRIOR)
            return;
        SpellEntry const* info = spell->m_spellInfo;
        if (!info)
            return;
        uint32 id = info->Id;

        bool bloodthirst = IsAny(id, { 23881, 23892, 23893, 23894 });
        if (bloodthirst)
            caster->CastSpell(caster, BLOODTHIRST_SPEED, TRIGGERED_OLD_TRIGGERED);

        if (id == 18499)
        {
            uint32 rank = TalentRank(caster, IMP_BERSERKER_RAGE);
            if (rank && urand(1, 100) <= 50 * rank)
            {
                caster->RemoveSpellsCausingAura(SPELL_AURA_MOD_DECREASE_SPEED);
                caster->RemoveSpellsCausingAura(SPELL_AURA_MOD_ROOT);
            }
        }

        // Gore Drinker triggers
        if (bloodthirst || IsAny(id, { 12328, 1719, 18499, 12880, 14201, 14202, 14203, 14204 }))
            if (TalentRank(caster, GORE_DRINKER))
                caster->CastSpell(caster, GORE_BUFF, TRIGGERED_OLD_TRIGGERED);
    }

    void RenownModule::TalentsOnDealDamage(Unit* dealer, Unit* victim, uint32 damage)
    {
        // Blood Craze also triggers on hits for more than 20% of maximum health
        if (!victim || victim == dealer || victim->GetTypeId() != TYPEID_PLAYER || victim->getClass() != CLASS_WARRIOR || !victim->IsAlive())
            return;
        if (uint64(damage) * 5 <= victim->GetMaxHealth())
            return;
        if (uint32 rank = TalentRank(victim, BLOOD_CRAZE))
            victim->CastSpell(victim, BLOOD_CRAZE_REGEN[rank - 1], TRIGGERED_OLD_TRIGGERED);
    }

    void RenownModule::TalentsOnLogout(Player* player)
    {
        if (!player)
            return;
        std::lock_guard<std::mutex> lock(g_rageMutex);
        g_rage.erase(player->GetGUIDLow());
    }
}

#else
namespace cmangos_module
{
    void RenownModule::TalentsInit() {}
    void RenownModule::TalentsOnDealDamage(Unit*, Unit*, uint32) {}
    void RenownModule::TalentsOnLogout(Player*) {}
}
#endif // RENOWN_TALENTS
