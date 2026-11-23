# 05 — Nền Chiến Đấu (Parallax), Bộ Giao Diện (UI Kit), Khung Thẻ, Rank & Trang Trí — Asset Prompts

- **Danh mục:** 4 xa cảnh chiến đấu + lớp tiền cảnh Parallax (`bg_battle_vistas_pack.png`, `bg_parallax_props_pack.png`), nút điều hướng HUD (`ui_hud_nav_pack.png`), bảng & nút UI (`ui_panels_buttons_pack.png`), khung thẻ hiếm R/SR/SSR/UR (`ui_hero_cards_rarity_pack.png`), tài nguyên & sao (`ui_currency_stars_pack.png`), huy hiệu Rank (`ui_rank_emblems_pack.png`), nhãn Class (`ui_class_tags_pack.png`) và vật trang trí (`decor_system_props_pack.png`) — (9 prompts)
- **Thư mục nhận raw:** `inbox/`
- **Thư mục đích sau adapt:** `assets/sprites/backgrounds/`, `assets/sprites/ui/`, `assets/sprites/cards/`, `assets/sprites/items/`, `assets/sprites/decor/`
- **Quy chuẩn chung:** Tất cả UI/Card/Decor không chứa chữ hay số để engine game tự đổ text đa ngôn ngữ; nền trắng `#FFFFFF` (trừ `bg_battle_vistas_pack.png` full-bleed 4 panel), không đường kẻ lưới, không watermark.

---

## 1. Bộ 4 Nền Chiến Đấu Xa Cảnh (`bg_battle_vistas_pack.png`) — [P0]
```
Output file: inbox/bg_battle_vistas_pack.png
Asset: 4 Nền Chiến Đấu Theo Chương (Green Kingdom Plains, Sunset Desert Oasis, Frozen Tundra, Demon Castle)
Grid: 2 columns × 2 rows (4 cleanly separated widescreen 16:9 scenic panels, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG battle background vista pack arranged in a strict 2 columns by 2 rows grid (4 distinct panoramic widescreen 16:9 scenic panels, read left-to-right, top-to-bottom).
Every panel MUST show a wide open horizontal grassy/ground battle lane at the bottom third with scenic layered castles/mountains in the upper two-thirds so chibi heroes and monsters stand clearly in front.
Subimages (4 atmospheric chapter battlegrounds):
- Cell 1 (r1c1, -> bg_plains_kingdom.png): Sunny Green Kingdom Plains — bright cerulean sky with fluffy clouds, rolling emerald meadows, distant white-and-blue storybook castle towers, and clean sunlit grassy battle path.
- Cell 2 (r1c2, -> bg_desert_oasis.png): Golden Sunset Desert Oasis — warm amber sunset sky, sandstone canyons, distant desert fortresses/temples, swaying palm silhouettes, and warm sandy battleground.
- Cell 3 (r2c1, -> bg_frozen_tundra.png): Crisp Frozen Tundra — pale icy blue sky, jagged snow-capped mountain peaks, frosted pine silhouettes, ice crystals, and smooth snowy battle floor.
- Cell 4 (r2c2, -> bg_demon_castle.png): Twilight Demon Castle — dramatic deep violet-indigo sky with glowing crescent moon, dark gothic demon fortress spires with glowing magenta windows, and dark slate battle road.
Art Style: Hand-drawn 2D anime fantasy game background illustration, painterly cel-shaded watercolor with clean atmospheric perspective matching base_assetsheet.jpg.
Clean Output: Strictly NO characters, NO monsters, NO UI, NO text, NO numbers, NO watermarks, thin crisp white separation between the 4 widescreen panels.
```

## 2. Lớp Tiền/Trung Cảnh Parallax Theo 4 Chương (`bg_parallax_props_pack.png`) — [P1]
```
Output file: inbox/bg_parallax_props_pack.png
Asset: 4 Dải Tiền/Trung Cảnh Parallax (Plains Trees, Desert Palms & Rocks, Tundra Pines & Ice, Demon Spires & Ruins)
Grid: 2 columns × 2 rows (4 cleanly separated wide horizontal strips, 16:9 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG parallax foreground/midground prop strip pack arranged in a strict 2 columns by 2 rows grid (4 cleanly separated wide horizontal prop strips, read left-to-right, top-to-bottom).
Subimages (4 horizontal cutout parallax layer strips matching the 4 biomes):
- Cell 1 (r1c1, -> bg_plains_props.png): Lush rounded green meadow trees, flowering bushes, and smooth mossy boulders arranged horizontally for foreground/midground parallax.
- Cell 2 (r1c2, -> bg_desert_props.png): Warm sandstone rock outcrops, desert palm clusters, and ancient carved ruins in a horizontal strip.
- Cell 3 (r2c1, -> bg_tundra_props.png): Snow-laden evergreen pines, translucent cyan ice boulders, and sculpted snowdrifts in a horizontal strip.
- Cell 4 (r2c2, -> bg_demon_props.png): Jagged obsidian-violet crags, twisted leafless dead trees, and glowing purple ruin pillars in a horizontal strip.
Composition & Technical Rules: Each strip centered horizontally inside its cell with generous pure white margins around the edges so background removal produces crisp transparent layers.
Art Style: Hand-drawn 2D anime fantasy game art, clean dark outlines, vibrant cel-shaded watercolor matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO sky fill, NO characters, NO grid lines, NO text, NO watermarks.
```

## 3. Bộ 6 Nút Điều Hướng Chính HUD (`ui_hud_nav_pack.png`) — [P0]
```
Output file: inbox/ui_hud_nav_pack.png
Asset: 6 Nút Điều Hướng Chính (Heroes, Summon, Campaign, Tower, Events, Shop) — Không Chữ
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG main menu navigation button icons pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every icon sits inside an identical warm rounded wooden-and-gold trimmed square fantasy button plaque (blank bottom label area, NO text):
- Cell 1 (r1c1, -> ui_nav_heroes.png): Golden-blue knight helmet emblem inside warm wooden-gold square button (Heroes).
- Cell 2 (r1c2, -> ui_nav_summon.png): Glowing crimson-gold ornate treasure chest / magic summon portal emblem inside warm wooden-gold square button (Summon).
- Cell 3 (r1c3, -> ui_nav_campaign.png): Crossed gleaming swords over golden battle shield emblem inside warm wooden-gold square button (Campaign).
- Cell 4 (r2c1, -> ui_nav_tower.png): Cute stone-and-gold fantasy fortress watchtower emblem inside warm wooden-gold square button (Tower).
- Cell 5 (r2c2, -> ui_nav_events.png): Golden calendar/scroll with shining star seal emblem inside warm wooden-gold square button (Events).
- Cell 6 (r2c3, -> ui_nav_shop.png): Cozy striped red-and-gold fantasy merchant shop awning stall emblem inside warm wooden-gold square button (Shop).
Composition & Technical Rules: Center-aligned identically sized wooden-gold button badges across all 6 cells, generous white margins.
Art Style: Hand-drawn 2D fantasy RPG UI kit art, crisp dark-brown outlines, warm glossy cel-shading matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO letters, NO numbers, NO grid lines, NO watermarks.
```

## 4. Bộ Khung HUD, Bảng Parchment & Nút Bấm (`ui_panels_buttons_pack.png`) — [P0]
```
Output file: inbox/ui_panels_buttons_pack.png
Asset: Khung Avatar, Thanh Tiền Tệ, Ribbon Đỏ, Bảng Giấy Da, 3 Nút Bấm & Dải Icon Nhỏ
Grid: 4 columns × 2 rows (8 cleanly separated cells, 2:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG UI kit components pack arranged in a strict 4 columns by 2 rows grid (8 cleanly separated UI widgets, read left-to-right, top-to-bottom).
Every component MUST be completely BLANK (NO text, NO numbers, NO avatar character inside):
- Cell 1 (r1c1, -> ui_avatar_frame.png): Ornate circular golden-and-bronze player avatar portrait frame with small ruby gem crest and empty dark interior circle.
- Cell 2 (r1c2, -> ui_currency_bar.png): Sleek horizontal dark-brown pill capsule bar with small golden circular plus (+) button on the right end (empty inside).
- Cell 3 (r1c3, -> ui_ribbon_red.png): Elegant folded crimson-red heraldic banner title ribbon with golden trim.
- Cell 4 (r1c4, -> ui_parchment_panel.png): Warm cream parchment dialog box panel framed with golden corner filigree ornaments and soft wood border.
- Cell 5 (r2c1, -> ui_btn_gold.png): Glossy beveled golden-amber rectangular action button (blank).
- Cell 6 (r2c2, -> ui_btn_red.png): Glossy beveled crimson-red rectangular cancel/action button (blank).
- Cell 7 (r2c3, -> ui_btn_blue.png): Glossy beveled sky-blue rectangular summon/action button (blank).
- Cell 8 (r2c4, -> ui_utility_icons_strip.png): Compact glossy dark-indigo ornate header plaque bar framed in gold trim (blank).
Composition & Technical Rules: Center-aligned cleanly inside each cell with generous white margins and zero overlapping.
Art Style: Hand-drawn 2D fantasy RPG UI kit art, crisp dark-brown outlines, warm glossy cel-shading matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO numbers, NO portraits, NO grid lines, NO watermarks.
```

## 5. Bộ 4 Khung Thẻ Hero Theo Độ Hiếm: R, SR, SSR, UR (`ui_hero_cards_rarity_pack.png`) — [P0]
```
Output file: inbox/ui_hero_cards_rarity_pack.png
Asset: 4 Khung Thẻ Tướng Rarity (R Blue, SR Purple, SSR Gold, UR Rainbow Crimson-Gold) — Trống Nhân Vật
Grid: 2 columns × 2 rows (4 cleanly separated vertical rectangular card frames, 3:4 or 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy gacha RPG hero card rarity frames pack arranged in a strict 2 columns by 2 rows grid (4 cleanly separated vertical trading-card frames, read left-to-right, top-to-bottom).
Every card frame MUST have an EMPTY clean inner portrait window (solid soft pale-tint or clean white inner window, NO character inside, NO text letters like R/SR/SSR/UR, NO stars):
- Cell 1 (r1c1, -> card_frame_r.png): Common/Rare (R) Tier — sleek metallic silver-and-cobalt-blue vertical card frame with subtle corner rivets and bottom plate.
- Cell 2 (r1c2, -> card_frame_sr.png): Super Rare (SR) Tier — ornate royal-violet and silver-gold vertical card frame with glowing amethyst gem accents on top corners.
- Cell 3 (r2c1, -> card_frame_ssr.png): Super Super Rare (SSR) Tier — grand gleaming golden vertical card frame with winged gold crown crest at top and warm amber filigree corners.
- Cell 4 (r2c2, -> card_frame_ur.png): Ultra Rare (UR) Tier — mythic crimson-gold and iridescent rainbow-crystal vertical card frame with radiant phoenix-wing gold crest and blazing ruby gems.
Composition & Technical Rules: Center-aligned identical vertical card aspect ratio across all 4 cells, generous white margins around every card.
Art Style: Hand-drawn 2D anime gacha UI art, crisp dark outlines, glossy metallic and gem cel-shading matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO characters inside frames, NO letters, NO numbers, NO stars, NO grid lines, NO watermarks.
```

## 6. Bộ Tài Nguyên, Sao & Công Tắc UI (`ui_currency_stars_pack.png`) — [P1]
```
Output file: inbox/ui_currency_stars_pack.png
Asset: Tài Nguyên (Gold Pile, Purple Gem, Blue Crystals) & Sao/Công Tắc UI
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG resources and HUD widget icons pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Subimages (6 clean UI resource and rating elements):
- Cell 1 (r1c1, -> res_gold_pile.png): Sparkling heap of thick golden RPG coins stacked neatly together.
- Cell 2 (r1c2, -> res_gem_cluster.png): Radiant oversized faceted violet-magenta premium diamond gem with crisp specular shine.
- Cell 3 (r1c3, -> res_mana_crystals.png): Cluster of glowing translucent sky-blue arcane crystal shards growing together.
- Cell 4 (r2c1, -> ui_star_filled.png): Plump glossy golden five-pointed RPG rating star with warm amber outline.
- Cell 5 (r2c2, -> ui_star_empty.png): Matching plump recessed dark-slate/bronze empty five-pointed star socket.
- Cell 6 (r2c3, -> ui_toggle_switch.png): Cute fantasy golden-rimmed capsule toggle switch pill in active glowing position.
Composition & Technical Rules: Center-aligned cleanly inside each square cell with generous white margins.
Art Style: Hand-drawn 2D fantasy RPG UI icon art, crisp dark outlines, glossy cel-shading matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO numbers, NO grid lines, NO watermarks.
```

## 7. Bộ 6 Huy Hiệu Rank (`ui_rank_emblems_pack.png`) — [P1]
```
Output file: inbox/ui_rank_emblems_pack.png
Asset: 6 Huy Hiệu Rank PvP / Tiến Độ (Bronze, Silver, Gold, Platinum, Diamond, Legend)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG competitive rank crest emblems pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Subimages (6 ascending winged shield rank badges, NO text):
- Cell 1 (r1c1, -> rank_bronze.png): Simple warm bronze metallic shield emblem with small riveted wing stubs.
- Cell 2 (r1c2, -> rank_silver.png): Gleaming silver-steel crest shield flanked by crisp silver wings and a small top star.
- Cell 3 (r1c3, -> rank_gold.png): Radiant golden winged crest shield crowned with a bright central gold star and emerald gem.
- Cell 4 (r2c1, -> rank_platinum.png): Sleek platinum-cyan winged crest shield with glowing ice-blue crystal core and silver-gold crown.
- Cell 5 (r2c2, -> rank_diamond.png): Grand royal-sapphire and gold double-winged crest shield with faceted blue diamond centerpiece.
- Cell 6 (r2c3, -> rank_legend.png): Supreme crimson-and-gold phoenix-winged mythic crest shield crowned with radiant gold halo and ruby core.
Composition & Technical Rules: Center-aligned cleanly inside each square cell with generous white margins.
Art Style: Hand-drawn 2D fantasy RPG UI art, crisp dark outlines, glossy metallic cel-shading matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO numbers, NO grid lines, NO watermarks.
```

## 8. Bộ 6 Nhãn Vai Trò Class (`ui_class_tags_pack.png`) — [P0]
```
Output file: inbox/ui_class_tags_pack.png
Asset: 6 Huy Hiệu Class (Tank, Warrior, Ranger, Mage, Support, Assassin) — Không Chữ
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG hero class role circular emblem badges pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every badge MUST be an identical glossy circular metallic-rimmed role icon WITHOUT text:
- Cell 1 (r1c1, -> class_tank.png): Royal-blue circular shield badge with crisp silver-white knight tower shield symbol (Tank).
- Cell 2 (r1c2, -> class_warrior.png): Crimson-red circular badge with crossed silver-white broadswords symbol (Warrior).
- Cell 3 (r1c3, -> class_ranger.png): Emerald-green circular badge with crisp white recurve bow and arrow symbol (Ranger).
- Cell 4 (r2c1, -> class_mage.png): Deep-purple circular badge with glowing white arcane magic staff / star wand symbol (Mage).
- Cell 5 (r2c2, -> class_support.png): Soft sky-violet/pink circular badge with radiant white winged heart / healing cross symbol (Support).
- Cell 6 (r2c3, -> class_assassin.png): Dark-indigo circular badge with sharp crossed twin white daggers symbol (Assassin).
Composition & Technical Rules: Center-aligned identically sized circular badges across all 6 cells, generous white margins, NO pill text boxes.
Art Style: Hand-drawn 2D fantasy RPG UI icon art, crisp dark outlines, glossy cel-shading matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text labels, NO grid lines, NO watermarks.
```

## 9. Bộ 12 Vật Trang Trí, Cờ Guild & Bối Cảnh (`decor_system_props_pack.png`) — [P1]
```
Output file: inbox/decor_system_props_pack.png
Asset: 12 Vật Trang Trí Hệ Thống & Sân Đấu (3 Cờ Guild, Vòng Nguyệt Quế, Vương Miện, Đèn Lồng, Cổng Torii, Cây Anh Đào, Pha Lê, Đèn Đá, Hàng Rào, Bụi Hoa)
Grid: 4 columns × 3 rows (12 cleanly separated equal-sized square cells, 4:3 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG guild emblems and map decoration props pack arranged in a strict 4 columns by 3 rows grid (12 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Subimages (12 crisp game system icons and map props):
- Cell 1 (r1c1, -> decor_banner_red.png): Crimson-red hanging heraldic guild banner with gold lion/shield emblem and gold rod.
- Cell 2 (r1c2, -> decor_banner_blue.png): Royal-blue hanging heraldic guild banner with silver cross emblem and gold rod.
- Cell 3 (r1c3, -> decor_banner_green.png): Emerald-green hanging heraldic guild banner with golden leaf crest emblem and gold rod.
- Cell 4 (r1c4, -> decor_laurel_wreath.png): Ornate golden victory laurel wreath bound at the bottom with a red ribbon.
- Cell 5 (r2c1, -> decor_crown.png): Chunky royal golden king crown studded with ruby and sapphire gems.
- Cell 6 (r2c2, -> decor_hanging_lantern.png): Warm glowing golden-red Edo paper lantern hanging from a dark metal hook.
- Cell 7 (r2c3, -> decor_torii_gate.png): Vibrant vermilion Japanese shrine Torii gate with dark slate top beam.
- Cell 8 (r2c4, -> decor_sakura_tree.png): Lush blooming pink cherry blossom (sakura) tree with sturdy warm brown trunk.
- Cell 9 (r3c1, -> decor_magic_crystal.png): Tall glowing faceted cyan-blue arcane monolith crystal emerging from stone base.
- Cell 10 (r3c2, -> decor_stone_lantern.png): Traditional moss-kissed Japanese stone shrine lantern (toro) with warm amber light inside.
- Cell 11 (r3c3, -> decor_wood_fence.png): Cute rustic wooden garden fence segment with clean warm planks.
- Cell 12 (r3c4, -> decor_garden_cluster.png): Cozy rounded emerald bush accented with pink wildflowers and smooth grey garden pebbles.
Composition & Technical Rules: Center-aligned or bottom-center aligned neatly inside each square cell with generous white margins, zero overlap.
Art Style: Hand-drawn 2D chibi fantasy RPG art, crisp dark-brown outlines, vibrant cel-shaded watercolor coloring matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, strictly NO text, NO grid lines, NO watermarks.
```
