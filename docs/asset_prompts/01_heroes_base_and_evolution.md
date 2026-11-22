# 01 — 12 Hero Cơ Bản, Tiến Hóa & Chân Dung (Base Heroes, Evolution & Portraits) — Asset Prompts

- **Danh mục:** 12 Hero cơ bản chia làm 2 hàng (`heroes_row1_pack.png`, `heroes_row2_pack.png`), bộ 3 cấp tiến hóa của Knight (`knight_evolution_pack.png`) và 2 bộ chân dung/avatar thẻ bài 12 Hero (`heroes_portraits_row1.png`, `heroes_portraits_row2.png`) — (5 prompts)
- **Thư mục nhận raw:** `inbox/`
- **Thư mục đích sau adapt:** `assets/sprites/heroes/`
- **Quy chuẩn chung:** Tất cả Hero đều quay mặt **SANG PHẢI (facing RIGHT)**; đứng tách rời trong từng ô trên nền trắng phẳng `#FFFFFF`, không dùng Edit Mode, không đường kẻ lưới, không chữ, không nhãn tên, không watermark.

---

## 1. Bộ 6 Hero Hàng 1: Knight, Paladin, Berserker, Assassin, Archer, Sniper (`heroes_row1_pack.png`) — [P0]
```
Output file: inbox/heroes_row1_pack.png
Asset: Bộ 6 Hero Hàng 1 (Knight, Paladin, Berserker, Assassin, Archer, Sniper) — Standing Base Poses
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero character pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every character MUST stand in a lively heroic 3/4 ready pose facing RIGHT, full body visible from head to boots with generous white margin around each cell.
Subimages (6 distinct chibi heroes):
- Cell 1 (row 1, col 1, -> knight_base.png): Knight (Tank) — cheerful blonde spiky-haired boy hero in silver-blue plate armor and dark-blue cape, wielding a gleaming steel broadsword and a blue-and-gold crest heater shield.
- Cell 2 (row 1, col 2, -> paladin_base.png): Paladin (Tank) — gentle silver-pink long-haired female paladin in white-and-gold sacred plate armor with pink cape, holding a tall golden-tipped royal halberd/staff and a radiant gold shield.
- Cell 3 (row 1, col 3, -> berserker_base.png): Berserker (Warrior) — fierce crimson-haired young warrior in dark charcoal-and-gold chest armor with red waist sash, gripping a giant heavy serrated battleaxe with both hands.
- Cell 4 (row 2, col 1, -> assassin_base.png): Assassin (Assassin) — agile dark-violet ponytail female rogue in sleek plum-and-emerald stealth tunic with leather belt, holding twin curved violet-edged daggers ready to strike.
- Cell 5 (row 2, col 2, -> archer_base.png): Archer (Ranger) — playful emerald-green haired elf-eared archer girl in leafy forest-green ranger cloak and brown boots, holding a curved wooden recurve bow and arrow.
- Cell 6 (row 2, col 3, -> sniper_base.png): Sniper (Ranger) — confident orange-brown twin-tailed sharpshooter girl in amber-gold and brown hunter outfit with leather quiver, aiming a sleek wooden-and-brass crossbow/rifle.
Composition & Technical Rules: Bottom-center aligned inside each cell at matching chibi head-to-body proportions (roughly 1:1.5 chibi ratio), identical scale across all 6 cells, zero overlap.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark-brown/black ink outlines (~3px), vibrant cel-shaded anime watercolor coloring with clean specular highlights.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow on background, strictly NO grid lines, NO borders, NO text, NO class labels, NO watermarks.
```

## 2. Bộ 6 Hero Hàng 2: Mage, Enchanter, Priest, Druid, Samurai, Ninja (`heroes_row2_pack.png`) — [P0]
```
Output file: inbox/heroes_row2_pack.png
Asset: Bộ 6 Hero Hàng 2 (Mage, Enchanter, Priest, Druid, Samurai, Ninja) — Standing Base Poses
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero character pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every character MUST stand in a lively heroic 3/4 ready pose facing RIGHT, full body visible from hat/head to boots with generous white margin around each cell.
Subimages (6 distinct chibi heroes):
- Cell 1 (row 1, col 1, -> mage_base.png): Mage (Mage) — cute lavender-white haired wizard girl wearing a tall indigo-violet pointed witch hat with gold trim and blue-violet starry robe, holding a glowing sapphire-gem wooden magic staff.
- Cell 2 (row 1, col 2, -> enchanter_base.png): Enchanter (Mage) — bright pastel-pink haired arcane sorceress wearing an ornate violet witch hat with golden crescent charm and violet-gold tunic, holding a golden-crystal star staff.
- Cell 3 (row 1, col 3, -> priest_base.png): Priest (Support) — sweet sakura-pink twin-tailed healer girl with ribbon hairbows in a white-and-pink ceremonial shrine dress, holding a pearl-and-gold healing staff.
- Cell 4 (row 2, col 1, -> druid_base.png): Druid (Support) — serene golden-blonde elf-eared nature guardian girl with leaf hair ornaments and moss-green floral dress, holding a living golden-leaved wooden nature spear-staff.
- Cell 5 (row 2, col 2, -> samurai_base.png): Samurai (Warrior) — proud crimson-ponytail chibi samurai warrior in crimson-and-gold lacquered Edo armor plates, carrying a curved katana in one hand and scabbard at the hip.
- Cell 6 (row 2, col 3, -> ninja_base.png): Ninja (Assassin) — cool mysterious dark-purple masked shinobi wearing deep-violet ninja cowl, scarf, and gold-trimmed shinobi garb, poised with a kunai dagger and shuriken pouch.
Composition & Technical Rules: Bottom-center aligned inside each cell at matching chibi proportions and identical scale across all 6 cells, zero overlap.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark-brown/black ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow on background, strictly NO grid lines, NO borders, NO text, NO class labels, NO watermarks.
```

## 3. Bộ Tiến Hóa 3 Cấp Của Knight: Basic → Advance → Awaken (`knight_evolution_pack.png`) — [P0]
```
Output file: inbox/knight_evolution_pack.png
Asset: Bộ 3 Cấp Tiến Hóa Knight (Basic Lv.1 ★ → Advance Lv.30 ★★ → Awaken Lv.60 ★★★)
Grid: 3 columns × 1 row (3 cleanly separated equal-sized square cells, 3:1 aspect ratio, read left-to-right)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG character evolution progression sheet arranged in a strict 3 columns by 1 row horizontal grid (3 cleanly separated equal-sized square cells, read left-to-right).
Subject: The same blonde spiky-haired chibi Knight hero evolving across 3 distinct power tiers, all facing RIGHT in heroic 3/4 stance:
- Cell 1 (left, -> knight_evo_basic.png): Basic Tier (1-Star) — young chibi Knight in simple light silver-blue trainee plate armor, small blue-gold shield, and plain steel short sword.
- Cell 2 (middle, -> knight_evo_advance.png): Advance Tier (2-Star) — upgraded veteran Knight wearing ornate winged golden-blue paladin pauldrons, a golden winged crown-helm crest, a longer glowing cyan-steel broadsword, and a reinforced gold-trimmed royal shield.
- Cell 3 (right, -> knight_evo_awaken.png): Awaken Tier (3-Star) — legendary Awakened Seraph Knight radiating majestic golden-orange phoenix energy wings behind his back, wearing grand gilded silver-gold dragon-crested armor, golden winged crown, blazing runic greatsword, and radiant holy shield.
Composition & Technical Rules: Bottom-center aligned inside each cell at consistent character core scale so the progression of armor and aura reads clearly left-to-right, generous white margins, NO arrows or stars between cells.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark-brown/black ink outlines (~3px), vibrant cel-shaded coloring with luminous golden highlights on tier 3.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow on background, strictly NO arrows, NO star icons, NO text, NO level numbers, NO grid lines, NO watermarks.
```

## 4. Chân Dung Hero Hàng 1 (`heroes_portraits_row1.png`) — [P1]
```
Output file: inbox/heroes_portraits_row1.png
Asset: 6 Chân Dung Hero Hàng 1 (Knight, Paladin, Berserker, Assassin, Archer, Sniper) — Bust Portraits
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero bust portrait pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every portrait is a waist-up dynamic close-up facing slightly RIGHT, designed to fit cleanly inside hero cards and circular HUD avatar frames.
Subimages (6 matching hero portraits):
- Cell 1 (r1c1, -> knight_portrait.png): Blonde spiky-haired Knight smiling heroically in silver-blue armor raising his sword hilt.
- Cell 2 (r1c2, -> paladin_portrait.png): Silver-pink haired Paladin in white-gold armor with serene determined gaze.
- Cell 3 (r1c3, -> berserker_portrait.png): Wild crimson-haired Berserker grinning fiercely with heavy dark-gold shoulder plate.
- Cell 4 (r2c1, -> assassin_portrait.png): Dark-violet ponytail Assassin winking sharply with twin daggers near her shoulder.
- Cell 5 (r2c2, -> archer_portrait.png): Cheerful emerald-haired elf Archer in leafy hood holding her wooden bow.
- Cell 6 (r2c3, -> sniper_portrait.png): Confident orange-brown twin-tailed Sniper aiming past her brass scope/crossbow.
Composition & Technical Rules: Center-aligned bust framing inside each square cell with clean shoulders/weapon framing and generous white outer margins, no card borders.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines, vibrant glossy anime cel-shading.
Clean Output: Pure flat solid white background (#FFFFFF), no frames, no grid lines, no text, no watermarks.
```

## 5. Chân Dung Hero Hàng 2 (`heroes_portraits_row2.png`) — [P1]
```
Output file: inbox/heroes_portraits_row2.png
Asset: 6 Chân Dung Hero Hàng 2 (Mage, Enchanter, Priest, Druid, Samurai, Ninja) — Bust Portraits
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG hero bust portrait pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every portrait is a waist-up dynamic close-up facing slightly RIGHT, designed for hero cards and circular HUD avatar frames.
Subimages (6 matching hero portraits):
- Cell 1 (r1c1, -> mage_portrait.png): Lavender-white haired Mage in pointed indigo witch hat cradling a glowing sapphire staff.
- Cell 2 (r1c2, -> enchanter_portrait.png): Pastel-pink haired Enchanter in ornate violet witch hat with golden crescent gem.
- Cell 3 (r1c3, -> priest_portrait.png): Sakura-pink twin-tailed Priest smiling warmly in white-pink shrine dress with pearl staff.
- Cell 4 (r2c1, -> druid_portrait.png): Golden-blonde elf Druid with leaf ornaments and serene nature smile.
- Cell 5 (r2c2, -> samurai_portrait.png): Crimson-ponytail Samurai warrior in red-gold armor gripping his katana hilt.
- Cell 6 (r2c3, -> ninja_portrait.png): Masked dark-purple Ninja with sharp glowing eyes and twin kunai pose.
Composition & Technical Rules: Center-aligned bust framing inside each square cell with generous white outer margins, no card borders.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines, vibrant glossy anime cel-shading.
Clean Output: Pure flat solid white background (#FFFFFF), no frames, no grid lines, no text, no watermarks.
```
