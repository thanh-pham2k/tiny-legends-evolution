# 02 — Sprite Sheet Hoạt Ảnh Hero: Bộ Chuẩn Knight & Đội Hình Khởi Đầu — Asset Prompts

- **Danh mục:** Bộ 6 sprite sheet đầy đủ cho `knight` (`idle` 4f, `run` 6f, `attack` 6f, `skill` 6f, `hit` 3f, `death` 4f), bộ chiến đấu khởi đầu cho `archer`, `mage`, `priest` (`idle` 4f, `attack` 6f, `skill` 6f) và template nhân bản cho các Hero / cấp tiến hóa còn lại — (15 prompts + 1 template)
- **Thư mục nhận raw:** `inbox/`
- **Thư mục đích sau adapt:** `assets/sprites/heroes/`
- **Quy chuẩn chung:** Toàn bộ frame quay mặt **SANG PHẢI (facing RIGHT)**, căn chân **bottom-center** đồng nhất giữa các ô, nền trắng phẳng `#FFFFFF`, không đường kẻ lưới, không chữ, không số thứ tự frame.

---

## A. Bộ Hoạt Ảnh Đầy Đủ Của Knight (Mẫu Chuẩn 6 Trạng Thái)

### 1. Knight — Idle (`knight_idle.png`) — [P0]
```
Output file: inbox/knight_idle.png
Asset: Knight — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Blonde spiky-haired chibi Knight in silver-blue plate armor and dark-blue cape, wielding a steel broadsword and blue-and-gold heater shield, facing RIGHT in ready combat stance.
Animation (4 seamless breathing idle frames):
- Frame 1 (r1c1): Balanced ready stance, sword raised forward at chest angle, shield held steady.
- Frame 2 (r1c2): Subtle inhale squash-and-stretch upward, cape fluttering slightly, sword bobbing up.
- Frame 3 (r2c1): Peak gentle hover/breath, bright eyes blinking softly.
- Frame 4 (r2c2): Smooth exhale settle returning seamlessly into Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical character scale and foot anchor across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark-brown/black ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow on background, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 2. Knight — Run (`knight_run.png`) — [P0]
```
Output file: inbox/knight_run.png
Asset: Knight — Run Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero run-cycle sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Blonde spiky-haired chibi Knight in silver-blue plate armor, dark-blue cape, steel broadsword, and blue-gold shield, sprinting RIGHT.
Animation (6 seamless energetic chibi run cycle frames):
- Frame 1 (r1c1): Right leg driving forward, left leg extended back, shield tucked forward, sword angled back.
- Frame 2 (r1c2): Passing stride, torso leaning forward, cape billowing behind.
- Frame 3 (r1c3): Airborne mid-stride push-off, legs scissor-open, energetic bounce.
- Frame 4 (r2c1): Left leg reaching forward for landing, right leg trailing behind.
- Frame 5 (r2c2): Contact & squash absorption, cape rippling swiftly.
- Frame 6 (r2c3): Push-off transition looping seamlessly back into Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no dust clouds on background, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 3. Knight — Attack (`knight_attack.png`) — [P0]
```
Output file: inbox/knight_attack.png
Asset: Knight — Basic Slash Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero melee attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Blonde spiky-haired chibi Knight in silver-blue plate armor, dark-blue cape, steel broadsword, and blue-gold shield, facing RIGHT.
Animation (6 crisp sword-slash frames):
- Frame 1 (r1c1): Coiled wind-up drawing sword high over shoulder, shield braced.
- Frame 2 (r1c2): Forward step lunge beginning downward diagonal swing.
- Frame 3 (r1c3): Impact peak — full forward extension to the RIGHT with a crisp bright white-silver crescent sword slash arc.
- Frame 4 (r2c1): Follow-through sweep with sword low in front and cape flaring back.
- Frame 5 (r2c2): Weapon recovery raising shield back to guard.
- Frame 6 (r2c3): Smooth settle back into Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical character scale across all 6 cells, facing RIGHT, generous white margins so slash arc stays cleanly inside cell.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no drop shadow on background, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 4. Knight — Skill (`knight_skill.png`) — [P0]
```
Output file: inbox/knight_skill.png
Asset: Knight — Heroic Wave Slash Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Blonde spiky-haired chibi Knight in silver-blue plate armor, dark-blue cape, steel broadsword, and blue-gold shield, facing RIGHT.
Animation (6 dramatic cyan-blue aura wave-slash frames):
- Frame 1 (r1c1): Raises glowing sword high above head charging radiant cyan-blue energy along the blade.
- Frame 2 (r1c2): Leaps slightly upward with glowing blue aura enveloping sword and shield.
- Frame 3 (r1c3): Powerful downward cleave unleashing a huge bright cyan-blue crescent energy slash wave forward to the RIGHT.
- Frame 4 (r2c1): Full energy arc burst sweeping forward with sparkling cyan-white impact flecks.
- Frame 5 (r2c2): Heavy heroic landing crouch as residual cyan sparks fade.
- Frame 6 (r2c3): Smooth rise back into poised ready stance.
Composition & Technical Rules: Bottom-center aligned at identical character scale across all 6 cells, facing RIGHT, generous white margins keeping the slash aura inside each cell.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no drop shadow on background, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 5. Knight — Hit (`knight_hit.png`) — [P0]
```
Output file: inbox/knight_hit.png
Asset: Knight — Hit / Flinch Animation (3 Frames)
Grid: 3 columns × 1 row (3 cleanly separated equal-sized square cells, 3:1 aspect ratio, read left-to-right)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero hit-reaction sprite sheet arranged in a strict 3 columns by 1 row horizontal grid (3 cleanly separated equal-sized square cells, read left-to-right).
Character: Blonde spiky-haired chibi Knight in silver-blue plate armor, dark-blue cape, sword, and shield, facing RIGHT.
Animation (3 crisp recoil frames):
- Frame 1 (left): Sudden backward flinch raising shield instinctively with tight wincing expression.
- Frame 2 (middle): Peak knockback lean backward, feet sliding slightly, cape whipped forward.
- Frame 3 (right): Quick stagger recovery steadying boots back into guard stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 3 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no red overlay flash, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 6. Knight — Death (`knight_death.png`) — [P0]
```
Output file: inbox/knight_death.png
Asset: Knight — Knockdown / Death Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero defeat/knockdown animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Blonde spiky-haired chibi Knight in silver-blue plate armor, dark-blue cape, sword, and shield, facing RIGHT.
Animation (4 cute chibi defeat knockdown frames):
- Frame 1 (r1c1): Dizzy stumble backward with eyes squeezed shut, dropping guard.
- Frame 2 (r1c2): Knees buckling and falling backward/sideways, sword slipping slightly.
- Frame 3 (r2c1): Landing flat onto ground facing up-right, cape spread out, shield resting nearby.
- Frame 4 (r2c2): Settled cute defeated pose lying flat on ground with spiral/closed eyes and sword resting beside him.
Composition & Technical Rules: Bottom-center aligned at identical character scale across all 4 cells, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no blood, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## B. Đội Hình Khởi Đầu (Archer, Mage, Priest — Idle, Attack & Skill)

### 7. Archer — Idle (`archer_idle.png`) — [P0]
```
Output file: inbox/archer_idle.png
Asset: Archer — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Playful emerald-green haired elf-eared chibi Archer girl in leafy forest-green ranger cloak and brown boots, holding a curved wooden recurve bow, facing RIGHT.
Animation (4 seamless breathing idle frames):
- Frames 1–2: Gentle buoyant bounce upward, cloak edges swaying lightly, bow lowered calmly.
- Frames 3–4: Cute blink on frame 3 and smooth settle returning seamlessly into Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 8. Archer — Attack (`archer_attack.png`) — [P0]
```
Output file: inbox/archer_attack.png
Asset: Archer — Bow Shot Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero bow-attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Emerald-green haired elf chibi Archer girl in leafy forest-green cloak with wooden recurve bow and arrow, facing RIGHT.
Animation (6 crisp archery frames):
- Frames 1–2: Nocks arrow and draws bowstring back steadily while leaning slightly back.
- Frames 3–4: Full draw tension then sharp release shooting arrow straight RIGHT with subtle green wind trail on bowstring.
- Frames 5–6: Crisp bow recoil follow-through returning smoothly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 9. Archer — Skill (`archer_skill.png`) — [P0]
```
Output file: inbox/archer_skill.png
Asset: Archer — Emerald Arrow Volley Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero skill-cast sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Emerald-green haired elf chibi Archer girl in forest-green cloak with wooden bow, facing RIGHT.
Animation (6 wind-infused rapid volley frames):
- Frames 1–2: Leaps gracefully while drawing three glowing emerald wind-charged arrows simultaneously.
- Frames 3–4: Releases dazzling emerald-green multi-arrow burst upward-right with swirling leaf-wind ribbons around bow.
- Frames 5–6: Agile landing crouch and smooth return to poised stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 10. Mage — Idle (`mage_idle.png`) — [P0]
```
Output file: inbox/mage_idle.png
Asset: Mage — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Cute lavender-white haired chibi Mage girl wearing an indigo-violet pointed witch hat with gold trim and starry wizard robe, holding a glowing sapphire-gem staff, facing RIGHT.
Animation (4 seamless breathing idle frames):
- Frames 1–2: Gentle bobbing breath, witch hat tip dipping slightly, sapphire gem shimmering softly.
- Frames 3–4: Cute blink on frame 3 and smooth settle back to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 11. Mage — Attack (`mage_attack.png`) — [P0]
```
Output file: inbox/mage_attack.png
Asset: Mage — Arcane Bolt Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero spell-attack sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Lavender-white haired chibi Mage girl in indigo-violet pointed witch hat and starry robe with sapphire magic staff, facing RIGHT.
Animation (6 crisp spell-bolt frames):
- Frames 1–2: Pulls magic staff back slightly as sapphire gem charges bright cyan-blue sparks.
- Frames 3–4: Thrusts staff forward to the RIGHT releasing a luminous cyan-blue arcane energy flare from the crystal tip.
- Frames 5–6: Robe and hat sway gently returning smoothly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 12. Mage — Skill (`mage_skill.png`) — [P0]
```
Output file: inbox/mage_skill.png
Asset: Mage — Starfall Arcane Nova Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero ultimate skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Lavender-white haired chibi Mage girl in indigo-violet witch hat and starry robe with sapphire staff, facing RIGHT.
Animation (6 grand spell-cast frames):
- Frames 1–2: Floats slightly upward raising staff skyward as a bright violet-cyan magic sigil glows around the staff crystal.
- Frames 3–4: Sweeps staff dramatically toward the RIGHT unleashing radiant cyan-violet starry magic ribbons.
- Frames 5–6: Graceful float down back to ground into Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 13. Priest — Idle (`priest_idle.png`) — [P0]
```
Output file: inbox/priest_idle.png
Asset: Priest — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Sweet sakura-pink twin-tailed chibi Priest girl with ribbon bows in white-and-pink ceremonial shrine dress holding a pearl-and-gold healing staff, facing RIGHT.
Animation (4 gentle idle frames):
- Frames 1–2: Cheerful subtle bobbing breath, twin-tails swaying softly, pearl staff glowing warmly.
- Frames 3–4: Sweet closed-eye smile blink on frame 3 and smooth return to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 14. Priest — Attack (`priest_attack.png`) — [P0]
```
Output file: inbox/priest_attack.png
Asset: Priest — Holy Orb Attack Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero basic cast sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Sakura-pink twin-tailed chibi Priest girl in white-and-pink dress with pearl-and-gold healing staff, facing RIGHT.
Animation (6 crisp light-cast frames):
- Frames 1–2: Cradles staff gently as warm golden-pink light sparkles at the pearl tip.
- Frames 3–4: Points staff toward the RIGHT releasing a soft golden-pink holy light spark burst.
- Frames 5–6: Gentle bow and twin-tail bounce returning cleanly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

### 15. Priest — Skill (`priest_skill.png`) — [P0]
```
Output file: inbox/priest_skill.png
Asset: Priest — Sacred Lotus Heal Skill Animation (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero healing skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Sakura-pink twin-tailed chibi Priest girl in white-and-pink shrine dress with pearl-and-gold staff, facing RIGHT.
Animation (6 radiant blessing cast frames):
- Frames 1–2: Clasps staff with both hands lifting it skyward with eyes closed in prayer as emerald-gold and sakura-pink light swirls around her feet.
- Frames 3–4: Opens eyes brightly raising staff high as radiant pink-gold petals and healing light sparkles bloom upward.
- Frames 5–6: Gentle descent and warm smile returning smoothly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

---

## C. Template Nhân Bản Cho Các Hero & Cấp Tiến Hóa Còn Lại

```
Output file: inbox/<hero_id>_<anim>.png
Asset: <Hero Name> — <Animation Name> (<4 or 6 or 3> Frames)
Grid: <2x2 for idle/death | 3x2 for run/attack/skill | 3x1 for hit> (cleanly separated equal-sized square cells, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero <idle / run / attack / skill / hit / death> animation sprite sheet arranged in a strict <C> columns by <R> rows grid (<N> cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: <Exact visual description from 01_heroes_base_and_evolution.md, e.g. Samurai in crimson-gold armor / Ninja in deep-violet garb>, facing RIGHT.
Animation (<N> seamless frames):
- Frame 1..N: <Describe wind-up -> action peak -> recovery looping cleanly back to Frame 1>.
Composition & Technical Rules: Bottom-center aligned at identical scale and foot anchor across all cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark-brown/black ink outlines (~3px), vibrant cel-shaded anime coloring matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow on background, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```
