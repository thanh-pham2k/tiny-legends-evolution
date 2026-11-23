# 08 — Hoạt Ảnh Chiến Đấu Quái Thường & 2 Boss Còn Lại — Asset Prompts

- **Danh mục:** Hoạt ảnh tấn công `attack` (`3×2`) cho 5 quái thường còn lại (`skeleton`, `wolf`, `boar`, `dark_knight`, `dark_mage`) và bộ 3 hoạt ảnh `idle` (`2×2`), `attack` (`3×2`), `skill` (`3×2`) cho 2 Boss chương (`boss_ice_dragon`, `boss_demon_lord`) — (11 prompts)
- **Thư mục nhận raw:** `inbox/`
- **Thư mục đích sau adapt:** `assets/sprites/enemies/` (`192×192 px`/ô) và `assets/sprites/bosses/` (`256×256 px`/ô)
- **Quy chuẩn 60 FPS & hướng nhìn:** Tất cả quái vật và Boss quay mặt **SANG TRÁI (facing LEFT)**; không vẽ bóng đổ đất lên nền trắng; trạng thái `run`/`hit`/`death` dùng lớp Tween + Shader 60 FPS của `UnitVisual` để tiết kiệm VRAM trên điện thoại.

---

## A. 5 Quái Thường Còn Lại (Attack 6 Frames — Facing LEFT)

### 1. Skeleton — Attack (`skeleton_attack.png`) — [P0]
```
Output file: inbox/skeleton_attack.png
Asset: Skeleton — Rusty Sword Slash Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Spooky cute chibi Skeleton warrior with round skull, cracked ribcage, rusty short sword, and round wooden-rimmed buckler shield, facing LEFT (matching Skeleton in base_assetsheet.jpg).
Animation (6 crisp sword-chop frames):
- Frames 1–2: Raises rusty short sword over skull while bracing round buckler shield forward.
- Frames 3–4: Swings rusty sword forward toward the LEFT with a sharp pale-white slash arc.
- Frames 5–6: Quick rattle recovery back into ready guard stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no oval drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 2. Dire Wolf — Attack (`wolf_attack.png`) — [P0]
```
Output file: inbox/wolf_attack.png
Asset: Dire Wolf — Pounce Bite Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy beast attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Fierce slate-grey chibi Dire Wolf beast with fluffy silver mane fur, glowing amber eyes, and bared fangs, facing LEFT (matching Wolf in base_assetsheet.jpg).
Animation (6 agile pounce-bite frames):
- Frames 1–2: Crouches low with ears pinned back coiling to pounce LEFT.
- Frames 3–4: Lunges forward toward the LEFT snapping jaws open with crisp white-silver claw/fang slash streaks.
- Frames 5–6: Lands gracefully back onto all four paws into crouched guard.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 3. Wild Boar — Attack (`boar_attack.png`) — [P0]
```
Output file: inbox/boar_attack.png
Asset: Wild Boar — Tusk Ram Charge Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy beast attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Sturdy russet-brown chibi Wild Boar monster with sharp white curved tusks and bristly mane, facing LEFT (matching Boar in base_assetsheet.jpg).
Animation (6 heavy tusk-gore frames):
- Frames 1–2: Lowers snout and tusks sharply toward the ground preparing to ram LEFT.
- Frames 3–4: Charges violently upward-left tossing tusks forward with crisp white impact wind lines.
- Frames 5–6: Stomps back into steady grumpy stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 4. Dark Knight — Attack (`dark_knight_attack.png`) — [P0]
```
Output file: inbox/dark_knight_attack.png
Asset: Dark Knight — Heavy Broadsword Cleave Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy knight attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Heavy chibi Dark Footman Knight wearing gunmetal-steel helmet with visor slit, slate-blue plate armor, broadsword, and dark-rimmed tower shield, facing LEFT (matching Dark Knight in base_assetsheet.jpg).
Animation (6 heavy armored cleave frames):
- Frames 1–2: Winds broadsword back above visor while stepping forward behind heavy shield.
- Frames 3–4: Heavy downward slash toward the LEFT with a crisp steel-violet crescent sword arc.
- Frames 5–6: Raises shield and sword cleanly back to armored guard stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 5. Dark Mage — Attack (`dark_mage_attack.png`) — [P0]
```
Output file: inbox/dark_mage_attack.png
Asset: Dark Mage — Shadow Orb Cast Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG enemy mage attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Sinister cute Dark Cultist Mage wearing tall dark-indigo pointed wizard hood, glowing yellow eyes under brim, purple-gold robes, and glowing amber-orb dark staff, facing LEFT (matching Dark Mage in base_assetsheet.jpg).
Animation (6 crisp dark-cast frames):
- Frames 1–2: Pulls dark staff back as glowing violet-amber magic sparks gather at the orb tip.
- Frames 3–4: Points staff straight LEFT unleashing a bright violet-amber dark magic flare burst.
- Frames 5–6: Robe settles smoothly back into poised caster stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## B. Boss Frost Ice Dragon (Idle, Attack, Skill — Facing LEFT)

### 6. Boss Ice Dragon — Idle (`boss_ice_dragon_idle.png`) — [P0]
```
Output file: inbox/boss_ice_dragon_idle.png
Asset: Boss Frost Ice Dragon — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG dragon boss idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Majestic Sapphire Frost Dragon boss with crystalline cyan-blue scales, icy back spines, spread frosted dragon wings, horned snout, and glowing ice-blue eyes, facing LEFT (matching Ice Dragon in base_assetsheet.jpg).
Animation (4 menacing idle frames):
- Frames 1–2: Slow deep dragon chest breath, wings lifting slightly, frosty blue shimmer along spines.
- Frames 3–4: Wings settling smoothly back to Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical imposing boss scale across all 4 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 7. Boss Ice Dragon — Attack (`boss_ice_dragon_attack.png`) — [P0]
```
Output file: inbox/boss_ice_dragon_attack.png
Asset: Boss Frost Ice Dragon — Frost Claw & Bite Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG dragon boss melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Majestic Sapphire Frost Dragon boss with crystalline cyan-blue scales, icy spines, and spread wings, facing LEFT.
Animation (6 fierce dragon swipe frames):
- Frames 1–2: Rears front claw and horned head back flapping wings powerfully.
- Frames 3–4: Sweeps huge frosted dragon claw sharply toward the LEFT with an icy cyan-white claw slash arc.
- Frames 5–6: Heavy wing flap recovery returning cleanly to Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical boss scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 8. Boss Ice Dragon — Skill (`boss_ice_dragon_skill.png`) — [P0]
```
Output file: inbox/boss_ice_dragon_skill.png
Asset: Boss Frost Ice Dragon — Glacial Breath Nova Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG dragon boss ultimate breath skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Majestic Sapphire Frost Dragon boss with crystalline cyan-blue scales, icy spines, and wide spread wings, facing LEFT.
Animation (6 dramatic ice-breath cast frames):
- Frames 1–2: Throws horned head back inhaling glowing cyan frost mist inside jaws, wings spread wide.
- Frames 3–4: Blasts a massive roaring cyan-white crystalline ice breath cone straight LEFT with jagged frost sparks.
- Frames 5–6: Closes jaws smoothly and settles back into Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical boss scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## C. Boss Inferno Demon Lord (Idle, Attack, Skill — Facing LEFT)

### 9. Boss Demon Lord — Idle (`boss_demon_lord_idle.png`) — [P0]
```
Output file: inbox/boss_demon_lord_idle.png
Asset: Boss Inferno Demon Lord — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG demon boss idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Fearsome Crimson-Obsidian Inferno Demon Lord boss wearing spiked volcanic black-and-crimson armor, large curved obsidian horns, blazing orange lava chest core, and fiery shoulder wisps, facing LEFT (matching Demon Lord in base_assetsheet.jpg).
Animation (4 intimidating demon idle frames):
- Frames 1–2: Heavy menacing chest rise, magma chest core glowing brighter, shoulder fire wisps flickering upward.
- Frames 3–4: Heavy settle back to Frame 1 guard stance.
Composition & Technical Rules: Bottom-center aligned at identical imposing boss scale across all 4 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 10. Boss Demon Lord — Attack (`boss_demon_lord_attack.png`) — [P0]
```
Output file: inbox/boss_demon_lord_attack.png
Asset: Boss Inferno Demon Lord — Hellfire Claw Smash Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG demon boss melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Crimson-Obsidian Inferno Demon Lord boss in spiked volcanic armor with curved obsidian horns and fiery shoulder wisps, facing LEFT.
Animation (6 brutal hellfire-slash frames):
- Frames 1–2: Pulls massive volcanic gauntleted fist back blazing with crimson-orange magma flames.
- Frames 3–4: Sweeps blazing fist sharply toward the LEFT unleashing a fierce crimson-orange fire claw arc.
- Frames 5–6: Heavy intimidating recoil returning to Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical boss scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 11. Boss Demon Lord — Skill (`boss_demon_lord_skill.png`) — [P0]
```
Output file: inbox/boss_demon_lord_skill.png
Asset: Boss Inferno Demon Lord — Cataclysmic Magma Eruption Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG demon boss ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Crimson-Obsidian Inferno Demon Lord boss in spiked volcanic armor with curved obsidian horns and blazing magma core, facing LEFT.
Animation (6 apocalyptic inferno-eruption frames):
- Frames 1–2: Rears arms skyward roaring as blazing orange-crimson hellfire flares brightly around his body and horns.
- Frames 3–4: Slams both blazing volcanic fists downward-left unleashing a towering crimson-gold magma flame shockwave burst.
- Frames 5–6: Rises ominously back into menacing Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical boss scale across all 6 cells, facing LEFT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, thick dark ink outlines (~3-4px), rich cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```
