# Grid-A-Iron Dungeon — Levels 1–10 Enemy & Loot Ramp

## Goals
- One distinct *new* (or returning) stronger enemy comes online every dungeon level (1–10).
- Phase weaker enemies *out* as the floor count rises so combat stays fresh and dangerous.
- Phase low-tier weapons / shields out the same way; introduce **Diamond Shield (lvl 7+)** and **Diamond Sword (lvl 9+)**.
- A handful of harder enemies get a *first strike* — they attack in the same turn the player enters their cell.

## New enemies introduced (mandates + picks)
- **Bunny** *(mandate)* — comically weak, nips. Mostly there as a low-floor curiosity.
- **Floating Eyeball** *(mandate)* — gaze-strike: **first strike on entry**.
- **Evil Vendor** *(mandate)* — palette-swapped vendor sprite (dark clothes), looks like the friendly NPC but attacks; **first strike**.
- **Shadow Fiend** *(my pick — ASCII-art enemy)* — rendered as canvas-text glyphs, no PNG.
- **Vampire Bat** *(my pick)* — small, fast, lvl 7+.
- **Demon Lord** *(my pick)* — heavy mid-late, lvl 9+.
- **Dragon** *(my pick)* — boss, lvl 10, **first strike**.

## Enemy table (HP / Atk / minLvl / maxLvl / firstStrike)

| Enemy            | HP  | Atk | min | max | First strike | Notes |
|------------------|-----|-----|-----|-----|--------------|-------|
| Bunny            | 3   | 1   | 1   | 4   | no  | Filler tutorial mob |
| Giant Rat        | 5   | 2   | 1   | 5   | no  | Existing |
| Slime            | 6   | 2   | 1   | 5   | no  | Existing |
| Goblin           | 8   | 3   | 1   | 6   | no  | Existing |
| Skeleton         | 12  | 4   | 2   | 7   | no  | Existing (HP +2) |
| Floating Eyeball | 10  | 4   | 3   | 8   | **yes** | Gaze-strike |
| Cave Troll       | 22  | 6   | 4   | 9   | no  | HP +4 from before |
| Lich             | 30  | 7   | **5**| 10 | no  | Moved from L6→L5 |
| Shadow Fiend     | 28  | 8   | 6   | 10  | no  | ASCII-art enemy |
| Vampire Bat      | 18  | 7   | 7   | 10  | no  | Fast / low HP for tier |
| Evil Vendor      | 40  | 9   | 8   | 10  | **yes** | Surprise attack |
| Demon Lord       | 55  | 11  | 9   | 10  | no  | Heavy |
| Dragon           | 90  | 14  | 10  | 10  | **yes** | Final boss |

“max” means the enemy is removed from the spawn pool *after* that floor.
A pool filter `minLevel <= level <= maxLevel` controls eligibility.

## Weapon / shield ramp

| Item           | Dmg | Min lvl | Max lvl |
|----------------|-----|---------|---------|
| Rusty Sword    | 3   | 1       | 3       |
| Iron Sword     | 5   | 4       | 6       |
| Steel Sword    | 7   | 6       | 8       |
| Diamond Sword  | 10  | 9       | 10      |

| Item           | DR  | Min lvl | Max lvl |
|----------------|-----|---------|---------|
| Rusty Shield   | 1   | 1       | 3       |
| Iron Shield    | 2   | 4       | 6       |
| Steel Shield   | 3   | 6       | 8       |
| Diamond Shield | 4   | 7       | 10      |

(Picked weapon / shield each floor uses the table; tiers overlap by one floor for variety.)

## First-strike rule
Inside `enterCell()`, after `state.combat` is set, if `c.enemy.firstStrike` is true, run one enemy turn immediately before the player can act. Damage is computed exactly as the existing enemy turn (no special bonus). Net effect: player loses the “you-go-first” free round on these enemies.

## Sprite policy
- Existing six enemies keep PNG sprites unchanged.
- Bunny, Floating Eyeball, Vampire Bat, Demon Lord, Dragon: **canvas-rendered emoji/text sprite** (so we don’t need new PNGs to ship). Falls back to a shared canvas-billboard helper.
- Shadow Fiend: same canvas helper, but rendered as multi-line ASCII art block.
- Evil Vendor: existing `npc_vendor.png` reused with a CSS-equivalent material `color` darkening (multiplicative tint via `SpriteMaterial.color`).

## Verbatim user requirement
> Build out a new stronger enemy every level. Move lich to lvl 5, new enemy every level through 10. Add a diamond sword on lvl 9 diamond shield lvl 7, phase out weaker enemies and low lvl weapons as dungeon level goes up. First, make a document laying out plan of phasing enemies in and out, and ramp up of enemies hp and attack. Make a couple harder enemies attack just for entering their space. (They get first attack). One enemy should be an evil vendor same as vendor but dark clothes. One should be a little bunny. One a floating eyeball, you pick the other two. ... Fill in gaps copying what game already does or best judgement. One enemy should be ascii art.
