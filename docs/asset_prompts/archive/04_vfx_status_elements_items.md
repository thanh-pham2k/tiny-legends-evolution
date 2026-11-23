# 04 — Hiệu Ứng Kỹ Năng (VFX), Icon Trạng Thái, Nguyên Tố & Trang Bị/Vật Phẩm — Asset Prompts

- **Danh mục:** Bộ VFX tấn công (`vfx_offensive_pack.png`), VFX phòng thủ/hỗ trợ/bóng tối (`vfx_buff_dark_pack.png`), Icon Buff (`icons_status_buffs_pack.png`), Icon Debuff (`icons_status_debuffs_pack.png`), Icon 6 Nguyên Tố (`icons_elements_pack.png`), Trang bị (`items_equipment_pack.png`) và Vật phẩm/Kho báu (`items_loot_resources_pack.png`) — (7 prompts)
- **Thư mục nhận raw:** `inbox/`
- **Thư mục đích sau adapt:** `assets/sprites/vfx/`, `assets/sprites/icons/`, `assets/sprites/items/`
- **Quy chuẩn chung:** Nền trắng phẳng `#FFFFFF`, mỗi icon/VFX nằm gọn trong ô vuông riêng biệt có khoảng trắng rộng xung quanh, không đường kẻ lưới, không chữ, không watermark.

---

## 1. Bộ 8 Hiệu Ứng Kỹ Năng Tấn Công (`vfx_offensive_pack.png`) — [P0]
```
Output file: inbox/vfx_offensive_pack.png
Asset: Bộ 8 Hiệu Ứng Kỹ Năng Tấn Công (Fire Slashes, Explosion, Ice Spikes/Shards, Tornado, Lightning, Arcane Circle)
Grid: 4 columns × 2 rows (8 cleanly separated equal-sized square cells, 2:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG skill visual effects (VFX) pack arranged in a strict 4 columns by 2 rows grid (8 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Subimages (8 crisp cel-shaded elemental combat VFX, offensive directional arcs aimed RIGHT):
- Cell 1 (r1c1, -> vfx_fire_slash_single.png): Blazing orange-gold crescent fire sword slash arc sweeping toward the RIGHT with trailing ember sparks.
- Cell 2 (r1c2, -> vfx_fire_slash_double.png): Fierce twin crossed crimson-orange flame slash waves surging RIGHT with sharp glowing wind streaks.
- Cell 3 (r1c3, -> vfx_fire_explosion.png): Dynamic spiky starburst impact explosion in bright yellow-orange and crimson flame plumes.
- Cell 4 (r1c4, -> vfx_ice_spikes.png): Jagged cluster of translucent cyan-blue crystal ice spikes erupting upward from an icy frost ring.
- Cell 5 (r2c1, -> vfx_ice_shards.png): Burst of sharp flying diamond ice shards and frosty mist droplets shooting forward-right.
- Cell 6 (r2c2, -> vfx_wind_tornado.png): Swirling cyan-blue spiral wind cyclone vortex spinning upward with crisp air-stream ribbons.
- Cell 7 (r2c3, -> vfx_lightning_pillar.png): Twin jagged golden-violet thunderbolts striking downward into an electric violet ground shock ring.
- Cell 8 (r2c4, -> vfx_arcane_circle.png): Glowing violet-magenta arcane rune magic circle in 3/4 ground perspective with luminous star glyphs.
Composition & Technical Rules: Center-aligned inside each cell with at least 12% clean white margin, zero clipping, zero overlapping between cells.
Art Style: Hand-drawn 2D anime fantasy game VFX, vibrant luminous cel-shaded colors with crisp clean outlines/rims matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO characters, NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 2. Bộ 6 Hiệu Ứng Khiên, Hồi Phục & Bóng Tối (`vfx_buff_dark_pack.png`) — [P0]
```
Output file: inbox/vfx_buff_dark_pack.png
Asset: Bộ 6 Hiệu Ứng Buff / Support / Dark AoE (Holy Shield, Ice Nova, Heal Aura, Lotus Bloom, Shadow Wolf, Dark Vortex)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG buff and AoE skill VFX pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Subimages (6 radiant defensive, healing, and dark magic VFX):
- Cell 1 (r1c1, -> vfx_holy_shield.png): Twin radiant translucent golden-amber sacred barrier shields floating side by side with shimmering light crests.
- Cell 2 (r1c2, -> vfx_ice_nova.png): Radial burst of glowing cyan-white frost crystals and icy ring shockwave erupting outward.
- Cell 3 (r1c3, -> vfx_heal_aura.png): Bright emerald-green healing magic ground ring with glowing floating green plus (+) sparkles rising upward.
- Cell 4 (r2c1, -> vfx_lotus_bloom.png): Radiant pink-gold sacred lotus flower aura blooming over soft magenta healing mist petals.
- Cell 5 (r2c2, -> vfx_shadow_wolf.png): Menacing dark-violet spectral wolf head roaring out of swirling purple shadow flames and magic circle.
- Cell 6 (r2c3, -> vfx_dark_vortex.png): Deep violet-black gravity curse portal vortex on ground with dramatic vertical magenta-purple laser-pillar burst.
Composition & Technical Rules: Center-aligned cleanly inside each square cell with generous white margins and zero overlapping.
Art Style: Hand-drawn 2D anime fantasy game VFX, vibrant luminous cel-shaded colors matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO characters, NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 3. Bộ 8 Icon Trạng Thái Tích Cực — Buffs (`icons_status_buffs_pack.png`) — [P0]
```
Output file: inbox/icons_status_buffs_pack.png
Asset: Bộ 8 Icon Buff (ATK Up, DEF Up, Max HP, Heal, Speed Up, Crit Sword, Star Buff, Shield Barrier)
Grid: 4 columns × 2 rows (8 cleanly separated equal-sized square cells, 2:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG status buff square badge icons pack arranged in a strict 4 columns by 2 rows grid (8 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every icon MUST share an identical rounded-square glossy beveled game icon badge shape with clean dark-brown outline and vibrant colored background:
- Cell 1 (r1c1, -> icon_buff_atk.png): Crimson-red rounded square badge with gleaming silver-white diagonal sword emblem (ATK Up).
- Cell 2 (r1c2, -> icon_buff_def.png): Royal-blue rounded square badge with bright silver-blue knight shield emblem (DEF Up).
- Cell 3 (r1c3, -> icon_buff_hp.png): Deep-purple rounded square badge with glossy rose-pink heart emblem (Max HP).
- Cell 4 (r1c4, -> icon_buff_heal.png): Emerald-green rounded square badge with bright white-green healing plus cross emblem (Regen/Heal).
- Cell 5 (r2c1, -> icon_buff_spd.png): Warm amber-brown rounded square badge with winged golden-tan swift boot emblem (Speed Up).
- Cell 6 (r2c2, -> icon_buff_crit.png): Bright orange-gold rounded square badge with glowing golden power sword emblem (Crit/Power).
- Cell 7 (r2c3, -> icon_buff_star.png): Warm golden-amber rounded square badge with bright yellow 5-point star and small sparkle stars (Ultimate/Inspire).
- Cell 8 (r2c4, -> icon_buff_shield.png): Sky-cyan rounded square badge with luminous golden-white holy barrier aura dome emblem (Immunity/Shield).
Composition & Technical Rules: Center-aligned identically sized rounded-square badges across all 8 cells with crisp readability at small UI scale.
Art Style: Hand-drawn 2D fantasy RPG UI icon art, crisp dark-brown outlines, glossy cel-shaded highlights matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO numbers, NO grid lines, NO watermarks.
```

## 4. Bộ 8 Icon Trạng Thái Bất Lợi — Debuffs (`icons_status_debuffs_pack.png`) — [P0]
```
Output file: inbox/icons_status_debuffs_pack.png
Asset: Bộ 8 Icon Debuff (Burn, Freeze, Shock, Poison, Bleed, Curse, Target Mark, Stun)
Grid: 4 columns × 2 rows (8 cleanly separated equal-sized square cells, 2:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG status debuff square badge icons pack arranged in a strict 4 columns by 2 rows grid (8 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every icon MUST share an identical rounded-square glossy beveled game icon badge shape matching the buff icons:
- Cell 1 (r1c1, -> icon_debuff_burn.png): Fiery orange-red badge with bright yellow-orange flame emblem (Burn).
- Cell 2 (r1c2, -> icon_debuff_freeze.png): Icy blue badge with crisp white-cyan six-point snowflake emblem (Freeze).
- Cell 3 (r1c3, -> icon_debuff_shock.png): Golden-yellow badge with sharp bright yellow lightning bolt emblem (Shock).
- Cell 4 (r1c4, -> icon_debuff_poison.png): Deep toxic-purple badge with pale bone-white chibi skull emblem (Poison).
- Cell 5 (r2c1, -> icon_debuff_bleed.png): Dark crimson badge with glossy bright ruby blood drop emblem (Bleed).
- Cell 6 (r2c2, -> icon_debuff_curse.png): Violet-magenta badge with swirling dark-purple curse vortex spiral emblem (Curse).
- Cell 7 (r2c3, -> icon_debuff_mark.png): Deep maroon-crimson badge with crisp white crosshair target reticle emblem (Target Mark).
- Cell 8 (r2c4, -> icon_debuff_stun.png): Indigo-slate badge with spinning twin golden dizzy stars emblem (Stun).
Composition & Technical Rules: Center-aligned identically sized rounded-square badges across all 8 cells, generous white margins.
Art Style: Hand-drawn 2D fantasy RPG UI icon art, crisp dark-brown outlines, glossy cel-shaded highlights matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO numbers, NO grid lines, NO watermarks.
```

## 5. Bộ 6 Icon Nguyên Tố / Hệ Phái (`icons_elements_pack.png`) — [P0]
```
Output file: inbox/icons_elements_pack.png
Asset: Bộ 6 Icon Nguyên Tố (Fire, Water, Wind, Earth, Light, Dark)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG element faction circular medallion icons pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every icon MUST be a clean circular metallic-rimmed emblem without text labels:
- Cell 1 (r1c1, -> elem_fire.png): Vibrant crimson-red circular gem medallion with bold orange-yellow stylized flame symbol.
- Cell 2 (r1c2, -> elem_water.png): Ocean-blue circular medallion with glossy cyan-white water droplet symbol.
- Cell 3 (r1c3, -> elem_wind.png): Emerald-teal circular medallion with crisp white-mint swirling wind-leaf spiral symbol.
- Cell 4 (r2c1, -> elem_earth.png): Warm ochre-brown circular medallion with rugged golden-amber faceted mountain/stone crest symbol.
- Cell 5 (r2c2, -> elem_light.png): Radiant golden-yellow circular medallion with luminous white eight-ray sun burst symbol.
- Cell 6 (r2c3, -> elem_dark.png): Deep indigo-purple circular medallion with glowing violet-magenta crescent vortex swirl symbol.
Composition & Technical Rules: Center-aligned identically sized circular emblems across all 6 cells, generous white margins, NO text below emblems.
Art Style: Hand-drawn 2D fantasy RPG UI icon art, crisp dark outlines, glossy gem cel-shading matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text labels, NO grid lines, NO borders, NO watermarks.
```

## 6. Bộ 6 Icon Trang Bị (`items_equipment_pack.png`) — [P0]
```
Output file: inbox/items_equipment_pack.png
Asset: Bộ 6 Trang Bị Đeo (Sword, Chestplate, Helmet, Boots, Ruby Ring, Relic Shield)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG equipment slot icons pack arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every equipment icon sits cleanly inside its own glossy purple-gold rounded-square rarity frame with matching clean silhouette:
- Cell 1 (r1c1, -> equip_sword.png): Gleaming silver-steel knight broadsword with golden crossguard inside a purple-bordered square slot.
- Cell 2 (r1c2, -> equip_armor.png): Ornate gold-and-steel paladin chestplate armor inside a purple-bordered square slot.
- Cell 3 (r1c3, -> equip_helmet.png): Winged golden-steel knight helmet inside a purple-bordered square slot.
- Cell 4 (r2c1, -> equip_boots.png): Sturdy steel-and-gold armored greave boots inside a purple-bordered square slot.
- Cell 5 (r2c2, -> equip_ring.png): Polished gold band ring set with a glowing faceted magenta-ruby gemstone inside a purple-bordered square slot.
- Cell 6 (r2c3, -> equip_shield.png): Ornate spiked silver-and-steel round sun emblem buckler/relic shield inside a purple-bordered square slot.
Composition & Technical Rules: Center-aligned identically sized rounded-square equipment icons across all 6 cells, generous white margins.
Art Style: Hand-drawn 2D fantasy RPG UI icon art, crisp dark outlines, vibrant cel-shaded metallic shine matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO stats, NO grid lines, NO watermarks.
```

## 7. Bộ 8 Vật Phẩm, Tiền Tệ & Túi Đồ (`items_loot_resources_pack.png`) — [P0]
```
Output file: inbox/items_loot_resources_pack.png
Asset: Bộ 8 Vật Phẩm & Kho Báu (Gold Coin, Purple Gem, Blue Potion, Skill Scroll, Spellbook, Golden Key, Treasure Chest, Summon Ticket)
Grid: 4 columns × 2 rows (8 cleanly separated equal-sized square cells, 2:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG loot and inventory items pack arranged in a strict 4 columns by 2 rows grid (8 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Subimages (8 freestanding unframed cute fantasy game items):
- Cell 1 (r1c1, -> item_gold_coin.png): Glossy thick golden RPG coin embossed with a five-point star emblem.
- Cell 2 (r1c2, -> item_purple_gem.png): Sparkling faceted violet-magenta diamond crystal gem.
- Cell 3 (r1c3, -> item_hp_potion.png): Round glass flask mana/healing potion filled with glowing sky-blue liquid and cork stopper.
- Cell 4 (r1c4, -> item_skill_scroll.png): Rolled ancient parchment skill scroll tied neatly with red ribbon/seal.
- Cell 5 (r2c1, -> item_spellbook.png): Cute violet leather-bound magic tome spellbook with golden corner clasps and gem cover.
- Cell 6 (r2c2, -> item_golden_key.png): Ornate antique golden dungeon key with clover-shaped bow.
- Cell 7 (r2c3, -> item_treasure_chest.png): Chunky wooden-and-gold trimmed RPG treasure chest with brass lock clasp.
- Cell 8 (r2c4, -> item_summon_ticket.png): Ornate golden-parchment hero summon voucher ticket stamped with a shining star crest.
Composition & Technical Rules: Center-aligned freestanding items inside each square cell with generous white margins, no background boxes.
Art Style: Hand-drawn 2D fantasy RPG icon art, crisp dark-brown outlines, vibrant glossy cel-shading matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO numbers, NO grid lines, NO watermarks.
```
