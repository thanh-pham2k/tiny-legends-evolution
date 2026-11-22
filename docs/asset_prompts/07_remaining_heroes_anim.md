# 07 — Bộ Hoạt Ảnh 8 Hero MVP Còn Lại (Paladin, Berserker, Assassin, Sniper, Enchanter, Druid, Samurai, Ninja) — Asset Prompts

- **Danh mục:** Bộ 3 animation cốt lõi (`idle` `2×2`, `attack` `3×2`, `skill` `3×2`) cho 8 Hero còn lại của MVP v0.1 (`paladin`, `berserker`, `assassin`, `sniper`, `enchanter`, `druid`, `samurai`, `ninja`) — (24 prompts)
- **Thư mục nhận raw:** `inbox/`
- **Thư mục đích sau adapt:** `assets/sprites/heroes/` (ô `192×192 px`, chuẩn hóa chiều cao thân `~104 px`)
- **Tối ưu 60 FPS trên điện thoại:** Mỗi Hero chỉ cần 3 sheet cốt lõi (`idle`, `attack`, `skill`) để giữ tổng VRAM trận 5v5 luôn nhẹ (~1–2 MB); 3 trạng thái còn lại (`run`, `hit`, `death`) do `UnitVisual` nội suy 60 FPS trực tiếp trong Godot (nghiêng chạy + bụi chân, chớp trắng shader + knockback, đổ `90°` + mờ dần). Tuyệt đối không vẽ bóng đổ dưới chân lên nền trắng.

---

## 1. Paladin (Tank — Light)

### 1.1 Paladin — Idle (`paladin_idle.png`) — [P0]
```
Output file: inbox/paladin_idle.png
Asset: Paladin — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Gentle silver-pink long-haired female chibi Paladin in white, crimson-and-gold sacred plate armor with white cape, holding a tall ornate crimson-and-gold royal battle-staff/halberd, facing RIGHT (matching Paladin in base_assetsheet.jpg).
Animation (4 seamless breathing idle frames):
- Frame 1 (r1c1): Balanced guard stance, ornate crimson-gold battle-staff held upright in front.
- Frame 2 (r1c2): Subtle inhale bob upward, white cape and silver-pink hair fluttering gently.
- Frame 3 (r2c1): Peak gentle breath with soft eye blink.
- Frame 4 (r2c2): Smooth settle returning cleanly to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical character scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark-brown/black ink outlines (~3px), vibrant cel-shaded anime coloring matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no oval drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 1.2 Paladin — Attack (`paladin_attack.png`) — [P0]
```
Output file: inbox/paladin_attack.png
Asset: Paladin — Sacred Halberd Thrust Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Silver-pink long-haired female chibi Paladin in white, crimson-and-gold sacred armor with white cape, wielding an ornate crimson-and-gold royal battle-staff/halberd, facing RIGHT.
Animation (6 crisp spear-halberd strike frames):
- Frames 1–2: Pulls crimson-gold royal halberd back behind shoulder bracing front foot.
- Frames 3–4: Forward lunge thrusting halberd straight RIGHT with a crisp bright golden-white crescent strike arc.
- Frames 5–6: Smooth weapon pull-back returning cleanly into Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins keeping strike arc inside cell.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 1.3 Paladin — Skill (`paladin_skill.png`) — [P0]
```
Output file: inbox/paladin_skill.png
Asset: Paladin — Aegis Holy Barrier Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero barrier skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Silver-pink long-haired female chibi Paladin in white, crimson-and-gold armor with white cape and ornate crimson-gold royal battle-staff/halberd, facing RIGHT.
Animation (6 radiant holy-shield cast frames):
- Frames 1–2: Raises royal crimson-gold battle-staff skyward as radiant warm golden holy light swirls around her.
- Frames 3–4: Sweeps battle-staff forward to the RIGHT conjuring a luminous translucent golden-amber sacred barrier shield dome wave with sparkles.
- Frames 5–6: Graceful recovery back into poised Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## 2. Berserker (Warrior — Fire)

### 2.1 Berserker — Idle (`berserker_idle.png`) — [P0]
```
Output file: inbox/berserker_idle.png
Asset: Berserker — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Fierce crimson-haired young chibi Berserker in dark charcoal-and-gold chest armor with red waist sash, gripping a giant heavy serrated battleaxe with both hands, facing RIGHT (matching Berserker in base_assetsheet.jpg).
Animation (4 seamless combat-ready idle frames):
- Frames 1–2: Heavy confident breathing rise, giant battleaxe resting across shoulder/front, crimson hair tufts bouncing slightly.
- Frames 3–4: Fierce grin/blink and smooth settle back to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 2.2 Berserker — Attack (`berserker_attack.png`) — [P0]
```
Output file: inbox/berserker_attack.png
Asset: Berserker — Heavy Greataxe Cleave Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Crimson-haired chibi Berserker in dark charcoal-gold armor with giant serrated battleaxe, facing RIGHT.
Animation (6 heavy battleaxe cleave frames):
- Frames 1–2: Hoists giant battleaxe far back over head with coiled power.
- Frames 3–4: Heavy forward chop to the RIGHT unleashing a fierce fiery-orange crescent axe slash arc.
- Frames 5–6: Lifts axe from follow-through back to Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 2.3 Berserker — Skill (`berserker_skill.png`) — [P0]
```
Output file: inbox/berserker_skill.png
Asset: Berserker — Crimson Whirlwind Smash Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Crimson-haired chibi Berserker in dark charcoal-gold armor wielding giant serrated battleaxe, facing RIGHT.
Animation (6 explosive rage-slam frames):
- Frames 1–2: Leaps mid-air blazing with crimson-orange fury aura around axe and hair.
- Frames 3–4: Slams giant axe violently forward-right unleashing a huge blazing crimson-gold flame shockwave crescent burst.
- Frames 5–6: Heavy landing crouch with flying ember sparks returning smoothly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## 3. Assassin (Assassin — Dark)

### 3.1 Assassin — Idle (`assassin_idle.png`) — [P0]
```
Output file: inbox/assassin_idle.png
Asset: Assassin — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Agile dark-violet ponytail female chibi Assassin in sleek plum-and-emerald stealth tunic with twin curved violet-edged daggers, facing RIGHT (matching Assassin in base_assetsheet.jpg).
Animation (4 nimble stealth idle frames):
- Frames 1–2: Light agile bounce on toes, twin daggers poised, ponytail swaying subtly.
- Frames 3–4: Sharp confident wink/blink and smooth settle back to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 3.2 Assassin — Attack (`assassin_attack.png`) — [P0]
```
Output file: inbox/assassin_attack.png
Asset: Assassin — Twin Dagger Slash Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Dark-violet ponytail female chibi Assassin in plum-emerald stealth tunic wielding twin curved daggers, facing RIGHT.
Animation (6 swift twin-dagger strike frames):
- Frames 1–2: Crouches low dashing forward with daggers drawn back.
- Frames 3–4: Twin crossed violet-magenta dagger slash arcs slicing sharply to the RIGHT.
- Frames 5–6: Agile backstep spin recovery returning cleanly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 3.3 Assassin — Skill (`assassin_skill.png`) — [P0]
```
Output file: inbox/assassin_skill.png
Asset: Assassin — Shadow Blitz Cross-Slash Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Dark-violet ponytail female chibi Assassin in plum-emerald stealth tunic with twin curved daggers, facing RIGHT.
Animation (6 lethal shadow-cross burst frames):
- Frames 1–2: Envelops daggers in dark violet-purple shadow wisps while leaping low.
- Frames 3–4: Unleashes a dazzling X-shaped violet-magenta shadow slash wave bursting forward-right with purple sparks.
- Frames 5–6: Graceful crouched landing rising smoothly back into Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## 4. Sniper (Ranger — Earth / Wind)

### 4.1 Sniper — Idle (`sniper_idle.png`) — [P0]
```
Output file: inbox/sniper_idle.png
Asset: Sniper — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Confident orange-amber high-ponytail chibi Sniper girl with teal-green hair ribbon in brown-and-green hunter outfit aiming a sleek wooden-and-gold hunting rifle/crossbow, facing RIGHT (matching Sniper in base_assetsheet.jpg).
Animation (4 seamless sharpshooter idle frames):
- Frames 1–2: Subtle steady breathing bob, high ponytail swaying slightly, rifle/crossbow lowered at ready angle.
- Frames 3–4: Confident eye blink and smooth settle back to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 4.2 Sniper — Attack (`sniper_attack.png`) — [P0]
```
Output file: inbox/sniper_attack.png
Asset: Sniper — Rapid Bolt Shot Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ranged attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Orange-amber high-ponytail chibi Sniper girl with teal-green hair ribbon in brown-and-green hunter outfit with wooden-gold rifle/crossbow, facing RIGHT.
Animation (6 crisp sharpshooter shot frames):
- Frames 1–2: Raises hunting rifle/crossbow to eye level locking aim straight RIGHT.
- Frames 3–4: Fires crisp golden-amber muzzle spark flash straight RIGHT with snappy shoulder recoil.
- Frames 5–6: Smooth recoil recovery returning cleanly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 4.3 Sniper — Skill (`sniper_skill.png`) — [P0]
```
Output file: inbox/sniper_skill.png
Asset: Sniper — Piercing Golden Snipe Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Orange-amber high-ponytail chibi Sniper girl with teal-green hair ribbon in brown-and-green hunter outfit with wooden-gold rifle/crossbow, facing RIGHT.
Animation (6 charged piercing-snipe frames):
- Frames 1–2: Kneels low bracing hunting rifle/crossbow as glowing golden-orange energy coils tightly around the barrel tip.
- Frames 3–4: Blasts a radiant golden-amber laser-piercing shock cone straight RIGHT with dramatic recoil wind.
- Frames 5–6: Stands smoothly back up returning into Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## 5. Enchanter (Mage — Water / Arcane)

### 5.1 Enchanter — Idle (`enchanter_idle.png`) — [P0]
```
Output file: inbox/enchanter_idle.png
Asset: Enchanter — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Bright pastel-pink haired chibi Enchanter sorceress wearing an ornate violet witch hat with golden crescent charm and violet-gold tunic, holding a golden-crystal star staff, facing RIGHT (matching Enchanter in base_assetsheet.jpg).
Animation (4 seamless magical idle frames):
- Frames 1–2: Cheerful subtle bobbing breath, star staff floating lightly with golden shimmer.
- Frames 3–4: Sweet blink and smooth settle back to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 5.2 Enchanter — Attack (`enchanter_attack.png`) — [P0]
```
Output file: inbox/enchanter_attack.png
Asset: Enchanter — Starlight Spark Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero spell-attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Pastel-pink haired chibi Enchanter in violet witch hat and tunic with golden-crystal star staff, facing RIGHT.
Animation (6 crisp arcane-spark cast frames):
- Frames 1–2: Twirls star staff back charging bright magenta-gold starlight.
- Frames 3–4: Points star staff RIGHT releasing a twinkling magenta-gold magic flare burst.
- Frames 5–6: Smooth cloak swirl returning cleanly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 5.3 Enchanter — Skill (`enchanter_skill.png`) — [P0]
```
Output file: inbox/enchanter_skill.png
Asset: Enchanter — Frost & Arcane Rune Circle Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Pastel-pink haired chibi Enchanter in violet witch hat and tunic with golden-crystal star staff, facing RIGHT.
Animation (6 radiant enchantment-circle cast frames):
- Frames 1–2: Hovers slightly upward raising star staff high as glowing violet-cyan rune rings spin around her staff.
- Frames 3–4: Sweeps staff forward-right unleashing radiant violet-gold enchanted starlight ribbons.
- Frames 5–6: Floats gracefully back down into Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## 6. Druid (Support — Earth)

### 6.1 Druid — Idle (`druid_idle.png`) — [P0]
```
Output file: inbox/druid_idle.png
Asset: Druid — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Serene golden-blonde elf-eared chibi Druid girl with leaf hair ornaments and moss-green floral dress holding a golden-leaved nature spear-staff, facing RIGHT (matching Druid in base_assetsheet.jpg).
Animation (4 seamless nature idle frames):
- Frames 1–2: Gentle swaying breath, leaf dress hems rustling softly, nature staff bobbing lightly.
- Frames 3–4: Gentle blink and smooth settle back to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 6.2 Druid — Attack (`druid_attack.png`) — [P0]
```
Output file: inbox/druid_attack.png
Asset: Druid — Nature Bolt Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero spell-attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Golden-blonde elf chibi Druid girl in moss-green floral dress with golden-leaved nature staff, facing RIGHT.
Animation (6 crisp nature-cast frames):
- Frames 1–2: Draws nature staff back as emerald leaf sparks swirl around the golden leaf tip.
- Frames 3–4: Thrusts staff forward-right releasing a bright emerald-gold leaf energy burst.
- Frames 5–6: Smooth poise recovery back into Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 6.3 Druid — Skill (`druid_skill.png`) — [P0]
```
Output file: inbox/druid_skill.png
Asset: Druid — Emerald Bloom Blessing Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero nature-blessing skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Golden-blonde elf chibi Druid girl in moss-green floral dress with golden-leaved nature staff, facing RIGHT.
Animation (6 radiant forest-blessing cast frames):
- Frames 1–2: Plants staff firmly raising one hand upward as glowing green leaves and golden pollen spiral around her.
- Frames 3–4: Sweeps staff outward unleashing a lush emerald-gold nature bloom wave and floating leaves.
- Frames 5–6: Gentle bow returning smoothly into Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## 7. Samurai (Warrior — Fire / Wind)

### 7.1 Samurai — Idle (`samurai_idle.png`) — [P0]
```
Output file: inbox/samurai_idle.png
Asset: Samurai — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Proud crimson-ponytail chibi Samurai warrior in crimson-and-gold lacquered Edo armor plates, carrying a curved katana and scabbard, facing RIGHT (matching Samurai in base_assetsheet.jpg).
Animation (4 disciplined samurai idle frames):
- Frames 1–2: Calm steady combat breathing, ponytail and armor tassels swaying lightly, katana gripped ready.
- Frames 3–4: Focused eye blink and smooth return to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 7.2 Samurai — Attack (`samurai_attack.png`) — [P0]
```
Output file: inbox/samurai_attack.png
Asset: Samurai — Quick Katana Slash Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Crimson-ponytail chibi Samurai warrior in crimson-gold Edo armor wielding a curved katana, facing RIGHT.
Animation (6 crisp iaijutsu katana frames):
- Frames 1–2: Crouches into coiled iaido draw stance gripping katana at hip.
- Frames 3–4: Lightning-fast forward slash to the RIGHT leaving a sharp crimson-white crescent sword arc.
- Frames 5–6: Crisp katana flourish returning cleanly into Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 7.3 Samurai — Skill (`samurai_skill.png`) — [P0]
```
Output file: inbox/samurai_skill.png
Asset: Samurai — Blazing Tempest Double-Cut Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Crimson-ponytail chibi Samurai warrior in crimson-gold Edo armor with curved katana, facing RIGHT.
Animation (6 dramatic dual-flame slash frames):
- Frames 1–2: Charges blazing crimson-orange flame along katana blade in deep lunge crouch.
- Frames 3–4: Unleashes a massive twin crimson-gold crescent fire slash wave surging forward-right.
- Frames 5–6: Heroic sheathing/poised follow-through returning smoothly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## 8. Ninja (Assassin — Dark / Wind)

### 8.1 Ninja — Idle (`ninja_idle.png`) — [P0]
```
Output file: inbox/ninja_idle.png
Asset: Ninja — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Cool dark-purple masked chibi Ninja wearing deep-violet shinobi cowl, trailing scarf, gold-trimmed outfit, holding a kunai dagger, facing RIGHT (matching Ninja in base_assetsheet.jpg).
Animation (4 nimble shinobi idle frames):
- Frames 1–2: Low springy shinobi bounce, trailing dark-violet scarf rippling gently, kunai poised.
- Frames 3–4: Sharp eye blink and smooth return to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 8.2 Ninja — Attack (`ninja_attack.png`) — [P0]
```
Output file: inbox/ninja_attack.png
Asset: Ninja — Shuriken & Kunai Strike Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero swift attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Dark-purple masked chibi Ninja in deep-violet shinobi attire with trailing scarf and kunai, facing RIGHT.
Animation (6 crisp shinobi strike frames):
- Frames 1–2: Pulls arm back aiming forward toward the RIGHT in swift crouch.
- Frames 3–4: Lunges forward slashing/throwing with a sharp violet-cyan speed streak arc straight RIGHT.
- Frames 5–6: Snaps cleanly back into poised Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 8.3 Ninja — Skill (`ninja_skill.png`) — [P0]
```
Output file: inbox/ninja_skill.png
Asset: Ninja — Phantom Shuriken Storm Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Dark-purple masked chibi Ninja in deep-violet shinobi attire with trailing scarf, facing RIGHT.
Animation (6 dramatic shadow-shuriken burst frames):
- Frames 1–2: Mid-air acrobatic somersault spin glowing with dark-violet phantom energy.
- Frames 3–4: Unleashes a spinning volley of glowing violet-magenta giant shuriken star blades toward the RIGHT.
- Frames 5–6: Agile crouched landing rising cleanly back into Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```
