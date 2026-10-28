# SPP Classics Renown

A Warhammer Online style **Renown** system for an SPP Classics V2 (CMaNGOS Classic + playerbots) server.

- Renown is earned from honorable kills, battleground objectives (flag captures/returns, base and tower
  assaults/defends) and battleground wins/losses. Bots earn it too.
- 40 permanent ranks (Recruit, Skirmisher, Soldier, Veteran, Sergeant, Champion, Warlord, Conqueror, Legend).
- Rank-up messages and server-wide announcements every 5 ranks (real players only).
- Renown Insignias at ranks 5/10/15/20/25/30 unlock tiers of Warsong Gulch reward gear at the
  Battleground Quartermaster, no reputation grind.
- **Renown points are a currency.** Rank comes from lifetime renown; spendable points buy quartermaster gear
  (prices in `custom_renown_vendor`). Consumables keep their gold price.
- **Low-level PvP gear:** Recruit's set (levels 1-9, open) and Skirmisher's set (10-19, tier 1).
- **7 battleground brackets:** 1-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60 (core patch). Warsong Gulch and
  Arathi Basin open at level 1; Alterac Valley stays 51-60.
- **Bolster:** inside a battleground, players get the base stats, health and mana of their bracket's top level.
- Commands: `.renown info`, `.renown top`, GM: `.renown add <points> [name]`, `.renown set <rank> [name]`,
  `.renown give <points> [name]` (spendable only), admin: `.renown reload`.

## Contents

| Path | What it is |
| --- | --- |
| `cmangos-renown/` | The server module (C++) |
| `sql/zz_bg_hub.sql` | Battlemasters + Battleground Quartermaster at every starting area |
| `sql/zz_renown.sql` | Insignia items and the quartermaster's tiered Renown rewards |
| `sql/renown.conf` | Renown settings (copy next to `mangosd.conf`) |
| `patches/` | Small patches to the core, playerbots and module framework (brackets, low-level bot queueing, vendor hooks) |
| `addon/RenownBar/` | Client addon: Renown bar, spendable points, Renown prices in the vendor window |
| `.github/workflows/build-windows.yml` | Builds `mangosd.exe` for Windows, pinned to the exact SPP server version |

## Build

Run the **Build mangosd** workflow from the Actions tab (it also runs on every push to `main`).
Download the artifact, then replace `SPP_Server\Server\Binaries\vanilla\Bin64\mangosd.exe`
(keep a backup of the original).

The build pins core commit `a4e22a9` (celguar/mangos-classic, 2026-10-11), playerbots `da4419a`,
and every module to its state on that date, so the new binary matches the SPP database.
