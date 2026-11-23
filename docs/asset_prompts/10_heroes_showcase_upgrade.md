# 10 — Heroes Showcase & RPG UI Upgrade — Asset Prompts

- **Mục tiêu:** Nâng cấp chất lượng mỹ thuật của màn **Heroes & Evolution Showcase** (và toàn bộ UI RPG trong game) tiệm cận phong cách thương mại **AFK Arena / Epic Seven / Genshin Impact** với khung hoa văn 9-slice, bệ đứng ma pháp 3/4, nền nguyên tố dịu mắt và tùy chọn bộ tranh đứng High-Res cho 12 tướng.
- **Thư mục nhận raw:** `inbox/`
- **Lưu ý không cần AI tạo:** Bổ sung **1 Font RPG/Fantasy hỗ trợ tiếng Việt** (ví dụ `Baloo 2 Bold` hoặc `Philosopher Bold` đặt vào `assets/fonts/`) để thay font mặc định Godot — giúp toàn bộ UI đậm chất RPG ngay lập tức.

---

## Nhóm 1 — Nên Tạo Ngay (`P0` — Tác Động Mạnh Nhất Lên UI & Showcase)

#### 1. `inbox/ui_showcase_frames_pack.png` — Khung bảng Fantasy 9-slice, Thanh Ngăn & Nút Level Up `[P0]`
```text
Output file: inbox/ui_showcase_frames_pack.png
Asset: Ornate 9-Slice Fantasy UI Panel Frame, Header Banner, Emerald Button & Dividers
Grid: 2x2 loose quadrants on a pure solid white background (#FFFFFF), 16:9 wide layout, generous white spacing and zero overlap

Prompt:
2D Japanese anime-fantasy RPG UI asset sheet on a pure solid white background (#FFFFFF), crisp cel-shaded mobile gacha game UI art style matching AFK Arena and Epic Seven, rich dark navy and ornate brushed gold filigree, neatly arranged with generous white spacing and zero overlap:
Top-left: large dark translucent navy rectangular UI panel frame with ornate golden corner filigree, beveled metallic gold border, and a clean flat dark center suitable for 9-slice scaling.
Top-right: sleek horizontal gold-trimmed header banner frame with subtle gemstone accent at center.
Bottom-left: glossy emerald-green fantasy RPG button with beveled golden metal border and subtle highlight (blank, no text), matching a classic gold RPG button style.
Bottom-right: two ornate horizontal golden divider lines with tiny central diamond gems, and one glowing golden square selection frame with corner sparkles (empty center).
No text, no numbers, no letters, no watermark, clean sharp edges, 16:9 layout.
```

#### 2. `inbox/showcase_pedestals_pack.png` — 4 Bệ Đứng Ma Pháp Showcase (Đặt Dưới Chân Nhân Vật) `[P0]`
```text
Output file: inbox/showcase_pedestals_pack.png
Asset: 4 Elemental Isometric Character Showcase Pedestals (Light, Fire, Water, Dark)
Grid: 2 columns × 2 rows on a pure solid white background (#FFFFFF), 1:1 square layout, generous white margin around each pedestal

Prompt:
2D Japanese anime-fantasy mobile RPG character showcase pedestals sheet, 2x2 grid on a pure solid white background (#FFFFFF), isometric slightly top-down 3/4 view, clean stylized painterly game art with bold crisp outlines, no characters standing on them:
Top-left: Radiant Light & Holy stone dais with carved golden sun runes and soft warm golden glow rim.
Top-right: Fiery volcanic obsidian pedestal with glowing lava cracks and subtle ember runes around the edge.
Bottom-left: Glacial crystal & arcane sapphire stone pedestal with glowing cyan ice runes and frost rim.
Bottom-right: Shadow amethyst & dark marble arcane pedestal with glowing violet moon runes.
Each pedestal centered cleanly in its own quadrant, generous white margin, no text, no shadows outside the base, 1:1 square layout.
```

#### 3. `inbox/bg_showcase_elements_pack.png` — 6 Nền Showcase Theo Nguyên Tố `[P0]`
```text
Output file: inbox/bg_showcase_elements_pack.png
Asset: 6 Atmospheric Elemental Showcase Backdrops (Fire, Water, Wind, Earth, Light, Dark)
Grid: 3 columns × 2 rows cleanly separated with thin crisp borders, 16:9 wide aspect ratio

Prompt:
2D Japanese anime-fantasy RPG character showcase backgrounds pack, 3x2 grid of 6 atmospheric elemental backdrops with thin clean borders between panels, soft painterly depth, calm uncluttered center designed to make a foreground hero stand out:
Row 1 Col 1 (Fire): Warm crimson and ember-gold twilight temple atmosphere with soft rising embers and subtle bokeh.
Row 1 Col 2 (Water): Deep sapphire and glacial cyan starlit cavern with soft aurora light beams and gentle water sparkles.
Row 1 Col 3 (Wind): Emerald and teal sunlit sky-cliff breeze with drifting glowing leaves and soft sun rays.
Row 2 Col 1 (Earth): Warm amber and golden canyon sanctuary with floating golden dust motes and soft ancient stone pillars in far mist.
Row 2 Col 2 (Light): Radiant ivory-gold celestial cathedral sky with soft volumetric god rays and floating feathers.
Row 2 Col 3 (Dark): Deep indigo and violet eclipse night sky with ethereal purple nebula mist and crescent moon glow.
No characters, no UI, no text, 16:9 wide aspect ratio.
```

---

## Nhóm 2 — Tùy Chọn Nâng Cấp Cao Cấp (`P1` — Tranh Đứng High-Res 12 Hero)

*(Chỉ cần tạo nếu bạn muốn màn Showcase hiển thị tranh đứng sắc nét `512px+` thay cho sprite chiến đấu `192×192` đang phóng lớn.)*

#### 4. `inbox/hero_standees_pack_1.png` — 6 Hero Showcase Standee (Hàng 1) `[P1]`
```text
Output file: inbox/hero_standees_pack_1.png
Asset: 6 High-Res Hero Showcase Standees (Little Knight, Paladin, Berserker, Shadow Assassin, Forest Archer, Golden Sniper)
Grid: 3 columns × 2 rows on a pure solid white background (#FFFFFF), 16:9 wide layout, generous white margin around each character

Prompt:
2D Japanese anime-fantasy chibi RPG character full-body showcase illustrations, 3x2 grid on a pure solid white background (#FFFFFF), high-resolution crisp cel-shaded art with glossy highlights, dynamic heroic standing poses facing slightly right, consistent proportions, generous white margin around each character:
Row 1 Col 1: Little Knight — blond spiky-haired chibi boy in silver-blue armor with golden trim, red cape, holding a gleaming broadsword and blue-gold kite shield.
Row 1 Col 2: Paladin — silver-pink haired chibi maiden in white and gold holy plate armor, holding a radiant golden staff-lance.
Row 1 Col 3: Berserker — wild crimson-haired chibi warrior in dark iron armor and fur cloak, wielding a giant blazing battle axe.
Row 2 Col 1: Shadow Assassin — purple-haired chibi kunoichi in dark indigo stealth attire with gold accents, dual-wielding glowing violet daggers.
Row 2 Col 2: Forest Archer — emerald-haired elf chibi girl in forest-green hooded cloak with white flowers, holding an ornate wooden bow and quiver.
Row 2 Col 3: Golden Sniper — blonde chibi sharpshooter in steampunk gold-and-green coat with goggles, holding an ornate brass rifle.
No text, no frames, no pedestals, no background elements, pure white background (#FFFFFF), 16:9 layout.
```

#### 5. `inbox/hero_standees_pack_2.png` — 6 Hero Showcase Standee (Hàng 2) `[P1]`
```text
Output file: inbox/hero_standees_pack_2.png
Asset: 6 High-Res Hero Showcase Standees (Arcane Mage, Elemental Enchanter, Sakura Priest, Nature Druid, Flame Samurai, Shadow Ninja)
Grid: 3 columns × 2 rows on a pure solid white background (#FFFFFF), 16:9 wide layout, generous white margin around each character

Prompt:
2D Japanese anime-fantasy chibi RPG character full-body showcase illustrations, 3x2 grid on a pure solid white background (#FFFFFF), high-resolution crisp cel-shaded art with glossy highlights, dynamic heroic standing poses facing slightly right, consistent proportions, generous white margin around each character:
Row 1 Col 1: Arcane Mage — lavender-haired chibi witch wearing a starry indigo pointed hat and gold-trimmed robes, holding a glowing blue sapphire staff.
Row 1 Col 2: Elemental Enchanter — turquoise-haired chibi mystic in flowing emerald-and-gold robes with floating elemental orbs around her.
Row 1 Col 3: Sakura Priest — pink twin-tailed chibi shrine maiden with cherry blossom hairpins in red-and-white miko kimono, holding a golden bell staff.
Row 2 Col 1: Nature Druid — leafy green-and-gold haired chibi sage in mossy fantasy robe with glowing nature crystal staff and floral crown.
Row 2 Col 2: Flame Samurai — fiery red-and-black armored chibi samurai with horned kabuto crest, drawing a glowing flame katana.
Row 2 Col 3: Shadow Ninja — masked dark-violet chibi shinobi with flowing scarf, golden headband emblem, holding shadow kunai and shuriken.
No text, no frames, no pedestals, no background elements, pure white background (#FFFFFF), 16:9 layout.
```
