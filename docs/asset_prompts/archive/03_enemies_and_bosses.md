# 03 — Quái Vật (Mobs) & Boss — Asset Prompts

- **Danh mục:** Bộ 6 quái thường (`enemies_mobs_base_pack.png`), bộ 3 Boss (`bosses_base_pack.png`), cùng hoạt ảnh P0 cho `goblin` (`run`, `attack`, `death`) và `boss_golem` (`idle`, `attack`, `skill`) — (8 prompts)
- **Thư mục nhận raw:** `inbox/`
- **Thư mục đích sau adapt:** `assets/sprites/enemies/`, `assets/sprites/bosses/`
- **Quy chuẩn chung:** Tất cả quái vật và Boss đều quay mặt **SANG TRÁI (facing LEFT)** để đối đầu với đội hình Hero; nền trắng phẳng `#FFFFFF`, không đường kẻ lưới, không chữ, không watermark.

---

## 1. Bộ 6 Quái Thường — Base Poses (`enemies_mobs_base_pack.png`) — [P0]
```
Output file: inbox/enemies_mobs_base_pack.png
Asset: Bộ 6 Quái Thường (Goblin, Skeleton, Dire Wolf, Wild Boar, Dark Soldier, Dark Mage) — Facing LEFT
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy monsters pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every monster MUST be drawn in a clear 3/4 combat stance facing LEFT toward the player's heroes, full body visible with generous white margins.
Subimages (6 distinct chibi fantasy monsters):
- Cell 1 (r1c1, -> goblin_base.png): Mischievous green-skinned chibi Goblin raider with pointy ears, ragged brown loincloth and leather belt, holding a rough wooden bone-tipped war club/axe.
- Cell 2 (r1c2, -> skeleton_base.png): Spooky cute chibi Skeleton warrior with round skull, cracked ribcage, holding a rusty short sword and round wooden-rimmed buckler shield.
- Cell 3 (r1c3, -> wolf_base.png): Fierce slate-grey Dire Wolf beast with fluffy silver mane fur, glowing amber eyes, bared fangs, crouched ready to pounce LEFT.
- Cell 4 (r2c1, -> boar_base.png): Sturdy russet-brown Wild Boar monster with sharp white curved tusks, bristly mane, and muscular trot stance.
- Cell 5 (r2c2, -> dark_knight_base.png): Heavy chibi Dark Footman Knight wearing gunmetal-steel helmet with visor slit, slate-blue plate armor, holding a broadsword and dark-rimmed tower shield.
- Cell 6 (r2c3, -> dark_mage_base.png): Sinister cute Dark Cultist Mage wearing a tall dark-indigo pointed wizard hood/hat, glowing yellow eyes hidden under brim, purple-gold robes, holding a glowing amber-orb dark staff.
Composition & Technical Rules: Bottom-center aligned inside each cell at matching chibi monster scale, facing LEFT, zero overlap.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark-brown/black ink outlines (~3px), vibrant cel-shaded anime coloring matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow on background, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 2. Bộ 3 Boss Lớn — Base Poses (`bosses_base_pack.png`) — [P0]
```
Output file: inbox/bosses_base_pack.png
Asset: Bộ 3 Boss Lớn (Stone Golem, Frost Ice Dragon, Inferno Demon Lord) — Facing LEFT
Grid: 3 columns × 1 row (3 cleanly separated equal-sized square cells, 3:1 aspect ratio, read left-to-right)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG boss monsters pack arranged in a strict 3 columns by 1 row horizontal grid (3 cleanly separated equal-sized square cells, read left-to-right).
Every boss MUST be imposing, chunky, high-detail chibi-proportioned, facing LEFT in menacing battle stance with generous white margins.
Subimages (3 iconic chapter bosses):
- Cell 1 (left, -> boss_golem_base.png): Ancient Craggy Stone Golem boss built from heavy ochre-brown jagged boulders, glowing warm amber eyes, mossy shoulder cracks, and massive rocky fists.
- Cell 2 (middle, -> boss_ice_dragon_base.png): Majestic Sapphire Frost Dragon boss with crystalline cyan-blue scales, icy back spines, frosted dragon wings spread wide, horned snout, and glowing ice-blue eyes.
- Cell 3 (right, -> boss_demon_lord_base.png): Fearsome Crimson-Obsidian Inferno Demon Lord boss wearing spiked volcanic black-and-crimson armor, large curved obsidian horns, blazing orange lava chest core, and fiery aura wisps licking his shoulders.
Composition & Technical Rules: Bottom-center aligned inside each cell at consistent large boss scale, facing LEFT, zero overlap between cells.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick clean dark-brown/black ink outlines (~3-4px), rich cel-shaded anime coloring with glowing elemental highlights.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow on background, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 3. Goblin — Run (`goblin_run.png`) — [P0]
```
Output file: inbox/goblin_run.png
Asset: Goblin — Run Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy run-cycle sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Mischievous green-skinned chibi Goblin raider with pointy ears, ragged brown tunic, and wooden club-axe, scurrying LEFT.
Animation (6 seamless energetic goblin run frames):
- Frame 1 (r1c1): Left foot forward, right leg kicked back, hunched forward holding wooden club-axe.
- Frame 2 (r1c2): Mid-stride passing pose, pointy ears bobbing, club swinging low.
- Frame 3 (r1c3): Airborne bouncy hop pushing off toward the LEFT.
- Frame 4 (r2c1): Right foot reaching forward, left foot trailing back.
- Frame 5 (r2c2): Squat landing impact, mischievous grin bouncing.
- Frame 6 (r2c3): Push-off transition looping seamlessly back into Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 4. Goblin — Attack (`goblin_attack.png`) — [P0]
```
Output file: inbox/goblin_attack.png
Asset: Goblin — Club Smash Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Green-skinned chibi Goblin raider in brown ragged tunic wielding a rough wooden club-axe, facing LEFT.
Animation (6 crisp club-swing frames):
- Frame 1 (r1c1): Raises wooden club high behind head in crooked wind-up.
- Frame 2 (r1c2): Lunges forward toward the LEFT swinging club downward.
- Frame 3 (r1c3): Full impact smash toward LEFT with crisp white impact swoosh arc.
- Frame 4 (r2c1): Follow-through crouch with club low in front.
- Frame 5 (r2c2): Recoil lifting heavy club back up.
- Frame 6 (r2c3): Settles smoothly into ready stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 5. Goblin — Death (`goblin_death.png`) — [P0]
```
Output file: inbox/goblin_death.png
Asset: Goblin — Defeat / Death Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy defeat animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Green-skinned chibi Goblin raider in ragged brown tunic with wooden club, facing LEFT.
Animation (4 comical chibi defeat frames):
- Frame 1 (r1c1): Shocked recoil backward with dizzy eyes, dropping wooden club.
- Frame 2 (r1c2): Tumbling backward mid-fall.
- Frame 3 (r2c1): Flopping flat onto back facing up-left.
- Frame 4 (r2c2): Knocked-out flat pose with spiral dizzy eyes and club lying beside him.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no blood, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 6. Boss Stone Golem — Idle (`boss_golem_idle.png`) — [P0]
```
Output file: inbox/boss_golem_idle.png
Asset: Boss Stone Golem — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG boss idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Massive craggy ochre-brown Stone Golem boss with glowing amber eyes, mossy cracks, and giant heavy stone fists, facing LEFT.
Animation (4 heavy rhythmic idle frames):
- Frames 1–2: Subtle heavy chest heave upward, rocky shoulders rising, amber eyes glowing warmly.
- Frames 3–4: Heavy stone settle downward returning seamlessly into Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical imposing scale across all 4 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded watercolor stone coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 7. Boss Stone Golem — Attack (`boss_golem_attack.png`) — [P0]
```
Output file: inbox/boss_golem_attack.png
Asset: Boss Stone Golem — Heavy Fist Smash Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG boss melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Massive craggy ochre-brown Stone Golem boss with glowing amber eyes and giant boulder fists, facing LEFT.
Animation (6 heavy boulder-punch frames):
- Frames 1–2: Winds massive right boulder fist back high above shoulder while bracing forward foot.
- Frames 3–4: Crushing forward haymaker smash toward the LEFT with sharp dust/stone shockwave arc around fist.
- Frames 5–6: Heavy arm retraction returning smoothly to poised Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded stone coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 8. Boss Stone Golem — Skill (`boss_golem_skill.png`) — [P0]
```
Output file: inbox/boss_golem_skill.png
Asset: Boss Stone Golem — Earthshaker Double Slam Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG boss ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Massive craggy ochre-brown Stone Golem boss with glowing amber eyes and giant boulder fists, facing LEFT.
Animation (6 seismic ground-slam frames):
- Frames 1–2: Raises BOTH giant boulder fists high above head as amber rune cracks glow across his chest and arms.
- Frames 3–4: Slams both fists heavily downward onto the ground level sending jagged glowing amber-brown shockwave pebbles flying slightly around his fists.
- Frames 5–6: Heavy rise back up to imposing standing guard matching Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded stone coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```
