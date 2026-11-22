# 06 — Màn Hình Lobby, Bản Đồ Chiến Dịch, Gacha, Idle Rewards & Tiến Hóa Phân Nhánh — Asset Prompts

- **Danh mục:** Nền Title Splash (`bg_title_splash.png`), nền Lobby Town Hub (`bg_lobby_town.png`), nền Bản Đồ Campaign (`bg_campaign_map.png`), 4 nền phụ Summon / Evolution / Hero Detail / Idle Rewards (`bg_ui_scenes_pack.png`), HUD bản đồ & thanh chiến đấu (`ui_campaign_battle_hud_pack.png`), bộ 8 icon nút phụ (`ui_small_nav_icons_pack.png`), gói Gacha & 7 Skill Icons (`ui_gacha_and_skill_icons_pack.png`), 2 nhánh tiến hóa USP của Knight (`knight_branch_evolution_pack.png`) và hoạt ảnh chiến đấu của `Fire Knight` + `Holy Guardian` — (12 prompts)
- **Thư mục nhận raw:** `inbox/`
- **Thư mục đích sau adapt:** `assets/sprites/backgrounds/`, `assets/sprites/ui/`, `assets/sprites/heroes/`
- **Quy chuẩn 60 FPS & UI:** Toàn bộ nền không dính chữ, không dính nút UI cứng để Godot dựng layout 60 FPS sắc nét ở màn hình dọc `720×1280`; sprite nhân vật không có bóng đổ đất vẽ sẵn (`UnitVisual` tự vẽ bóng động).

---

## 1. Nền Thành Phố Sảnh Chính — Lobby Town Hub (`bg_lobby_town.png`) — [P0]
```
Output file: inbox/bg_lobby_town.png
Asset: Nền Thành Phố Sảnh Chính (Fantasy Sakura Castle Town Hub) — Full-Bleed Scenic Background
Grid: 1 single full-bleed scenic illustration (3:4 portrait-friendly aspect ratio, NO split panels)

Prompt:
Create a lush 2D Japanese anime-fantasy chibi RPG main town hub illustration filling the entire canvas cleanly edge-to-edge.
Scene: A vibrant sunlit fantasy castle plaza framed by blooming pink sakura cherry blossom trees and a central stone fountain courtyard. On the mid-left stands an ornate glowing violet-gold Summon Portal shrine beside cozy timber-and-blue-roof guild/hero cottages; in the upper center rises a majestic white-and-cobalt storybook castle beneath a drifting steampunk airship and soft clouds; on the mid-right stand a tall stone Watchtower and a striped merchant Shop awning.
Composition & Technical Rules: Open inviting sky and upper castle silhouette in the top third, detailed walkable cobblestone fountain plaza across the middle and lower two-thirds so floating Godot UI nav icons can be placed dynamically in code.
Art Style: Hand-drawn 2D anime fantasy game art, crisp painterly cel-shaded watercolor with warm golden-hour sunlight matching ui_screens_mockup.jpg.
Clean Output: Full-bleed artwork edge-to-edge, strictly NO characters, NO UI buttons, NO floating icons, NO text, NO numbers, NO watermarks.
```

## 2. Nền Bản Đồ Chiến Dịch — Campaign World Map (`bg_campaign_map.png`) — [P0]
```
Output file: inbox/bg_campaign_map.png
Asset: Nền Bản Đồ Chiến Dịch (Campaign World Map) — Full-Bleed Illustrated Map
Grid: 1 single full-bleed scenic world map illustration (3:4 portrait-friendly or 4:3 aspect ratio, NO split panels)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG world campaign map illustration filling the entire canvas cleanly edge-to-edge.
Scene: Top-down 3/4 scenic fantasy kingdom adventure map featuring a grand royal castle perched on a sunlit green hill at the top, sparkling blue rivers cascading down twin waterfalls across mossy cliffs, a cozy red-roofed Edo shrine temple on the left ridge, lush emerald forests, pink sakura blossom groves, and a winding dirt-and-cobblestone adventure trail meandering cleanly from bottom-left up toward the northern castle and dark volcanic border cliffs on the upper-right.
Composition & Technical Rules: Clear continuous winding road path with open flat spots along the trail so Godot stage pins and dashed route lines can be overlaid dynamically.
Art Style: Hand-drawn 2D anime fantasy map illustration, vibrant cel-shaded watercolor matching ui_screens_mockup.jpg.
Clean Output: Full-bleed artwork edge-to-edge, strictly NO stage pins, NO numbers, NO dotted UI lines, NO characters, NO boss icons, NO text, NO watermarks.
```

## 3. Bộ 4 Nền Màn Hình Chức Năng (`bg_ui_scenes_pack.png`) — [P0]
```
Output file: inbox/bg_ui_scenes_pack.png
Asset: 4 Nền Chức Năng (Summon Portal, Evolution Stage, Hero Detail Starry Backdrop, Idle Rewards Stage)
Grid: 2 columns × 2 rows (4 cleanly separated widescreen/square scenic panels, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy gacha RPG UI screen scenic backdrops pack arranged in a strict 2 columns by 2 rows grid (4 cleanly separated scenic backdrop panels, read left-to-right, top-to-bottom).
Subimages (4 atmospheric UI backdrops, completely empty of characters and UI buttons):
- Cell 1 (r1c1, -> bg_summon_portal.png): Summon Gacha Altar — magical twilight violet-indigo starry hall with an ornate glowing golden-and-amethyst runic summoning gate arch in the center and floating magic sparkles.
- Cell 2 (r1c2, -> bg_evolution_stage.png): Hero Evolution Altar — luminous pastel-violet and soft rose sky above a sunlit floating marble-and-gold pedestal terrace bathed in warm ascending light rays and sakura petals.
- Cell 3 (r2c1, -> bg_hero_detail_starry.png): Hero Detail Showcase — dramatic glowing twilight lavender-indigo celestial backdrop with soft radial spotlight burst, drifting golden stardust, and subtle sakura silhouettes.
- Cell 4 (r2c2, -> bg_idle_rewards_stage.png): Idle Rewards Shrine — cozy glowing deep-violet treasure sanctuary bathed in warm golden aura sparkles over a clean dark-stone platform pedestal.
Art Style: Hand-drawn 2D anime gacha game background art, rich luminous cel-shaded gradients matching ui_screens_mockup.jpg.
Clean Output: Strictly NO characters, NO treasure chests, NO hero cards, NO buttons, NO text, NO numbers, NO watermarks, thin crisp white separation between the 4 panels.
```

## 4. Bộ Ghim Bản Đồ & HUD Trận Đấu (`ui_campaign_battle_hud_pack.png`) — [P0]
```
Output file: inbox/ui_campaign_battle_hud_pack.png
Asset: 8 Thành Phần Map Pins & Battle HUD (Active Pin, Normal Pin, Boss Pin, Back Btn, Speed x2 Btn, Pause Btn, Battle Portrait Frame, Ult Ready Glow)
Grid: 4 columns × 2 rows (8 cleanly separated equal-sized square cells, 2:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG campaign map pins and battle HUD widgets pack arranged in a strict 4 columns by 2 rows grid (8 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Subimages (8 clean unlabelled UI widgets):
- Cell 1 (r1c1, -> ui_pin_stage_active.png): Active Battle Stage Map Node — radiant circular golden medallion badge featuring crossed steel swords over glowing amber shield (NO text/numbers).
- Cell 2 (r1c2, -> ui_pin_stage_normal.png): Standard Stage Map Node — clean circular bronze-and-cream compass/shield node medallion (empty center).
- Cell 3 (r1c3, -> ui_pin_stage_boss.png): Boss Stage Map Node — menacing crimson-and-gold horned skull crest medallion with dark violet border.
- Cell 4 (r1c4, -> ui_btn_back.png): Back Navigation Button — plump glossy golden-amber circular button with crisp cream left-pointing arrow icon.
- Cell 5 (r2c1, -> ui_btn_speed_x2.png): Speed Toggle Button — glossy golden-amber circular button with crisp white double fast-forward arrows (>>).
- Cell 6 (r2c2, -> ui_btn_pause.png): Pause Button — glossy golden-amber circular button with crisp white double vertical pause bars (||).
- Cell 7 (r2c3, -> ui_battle_portrait_frame.png): Bottom Battle Squad Card Frame — ornate square golden-and-navy hero battle HUD portrait frame with empty center and slim HP/Mana bar socket at bottom.
- Cell 8 (r2c4, -> ui_battle_ult_ready_glow.png): Ultimate Ready Aura Border — glowing golden-cyan radiant starlight square energy frame ring (transparent/white center).
Composition & Technical Rules: Center-aligned cleanly inside each square cell with generous white margins.
Art Style: Hand-drawn 2D fantasy RPG UI art, crisp dark-brown outlines, glossy cel-shading matching ui_screens_mockup.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO letters, NO numbers, NO grid lines, NO watermarks.
```

## 5. Bộ 8 Icon Nút Phụ Sảnh Chính (`ui_small_nav_icons_pack.png`) — [P0]
```
Output file: inbox/ui_small_nav_icons_pack.png
Asset: 8 Icon Nút Phụ (Mail, Quests, Events, Bag, Guild, Achieve, Settings, Idle Chest) — Không Chữ
Grid: 4 columns × 2 rows (8 cleanly separated equal-sized square cells, 2:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy RPG secondary HUD icon buttons pack arranged in a strict 4 columns by 2 rows grid (8 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Every icon sits cleanly inside an identical glossy dark-slate-indigo circular medallion with a warm gold-and-bronze rim (NO text labels):
- Cell 1 (r1c1, -> ui_icon_mail.png): Sealed cream parchment envelope with red wax seal (Mail).
- Cell 2 (r1c2, -> ui_icon_quests.png): Unrolled golden-cream parchment checklist scroll with small quill (Quests).
- Cell 3 (r1c3, -> ui_icon_events.png): Festive crimson-and-gold calendar/bell celebration badge with shining star (Events).
- Cell 4 (r1c4, -> ui_icon_bag.png): Cute chunky brown leather adventurer satchel backpack with gold buckle (Bag).
- Cell 5 (r2c1, -> ui_icon_guild.png): Noble silver-and-gold heraldic shield crest with castle tower emblem (Guild).
- Cell 6 (r2c2, -> ui_icon_achieve.png): Gleaming golden champion trophy cup with small star highlight (Achievements).
- Cell 7 (r2c3, -> ui_icon_settings.png): Polished golden-bronze mechanical gear cogwheel emblem (Settings).
- Cell 8 (r2c4, -> ui_icon_idle_chest.png): Cute glowing gold-and-crimson treasure chest brimming with gold coins (Idle Rewards).
Composition & Technical Rules: Center-aligned identically sized circular medallion buttons across all 8 cells with generous white margins.
Art Style: Hand-drawn 2D fantasy RPG UI icon art, crisp dark outlines, glossy cel-shading matching ui_screens_mockup.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO numbers, NO grid lines, NO watermarks.
```

## 6. Bộ 2 Nhánh Tiến Hóa USP Của Knight: Fire Knight & Holy Guardian (`knight_branch_evolution_pack.png`) — [P0]
```
Output file: inbox/knight_branch_evolution_pack.png
Asset: 2 Nhánh Tiến Hóa Phân Nhánh Của Knight (Fire Knight — AoE Damage & Holy Guardian — Protect Allies)
Grid: 2 columns × 1 row (2 cleanly separated equal-sized square cells, 2:1 aspect ratio, read left-to-right)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG branching hero evolution character pack arranged in a strict 2 columns by 1 row horizontal grid (2 cleanly separated equal-sized square cells, read left-to-right).
Subject: Two distinct Tier-3 branching evolutions of the blonde spiky-haired chibi Knight hero, both facing RIGHT in heroic 3/4 combat stance:
- Cell 1 (left, -> knight_evo_fire.png): Fire Knight (AoE Damage AI Branch) — fierce evolved blonde chibi Knight wearing crimson-and-obsidian dragon-forged plate armor, blazing crimson-gold cape, fiery phoenix shoulder crests, wielding a massive glowing magma-orange flaming greatsword without shield.
- Cell 2 (right, -> knight_evo_holy.png): Holy Guardian (Protect Allies AI Branch) — noble evolved blonde chibi Knight wearing radiant white-and-gold seraphic plate armor, majestic angel-feather golden shoulder wings, halo crest, wielding a luminous golden sacred spear-blade and a huge gleaming golden-sapphire tower greatshield.
Composition & Technical Rules: Bottom-center aligned inside each cell at matching chibi proportions, facing RIGHT, generous white margins, zero overlap.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark-brown/black ink outlines (~3px), vibrant cel-shaded anime coloring matching base_assetsheet.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow on background, strictly NO arrows, NO text, NO grid lines, NO watermarks.
```

## 7. Ảnh Nền Màn Hình Chờ / Title Splash (`bg_title_splash.png`) — [P1]
```
Output file: inbox/bg_title_splash.png
Asset: Nền Màn Hình Khởi Động / Title Key Art — Full-Bleed Scenic Hero Party Splash
Grid: 1 single full-bleed scenic illustration (3:4 portrait-friendly aspect ratio, NO split panels)

Prompt:
Create a vibrant 2D Japanese anime-fantasy chibi RPG title splash key art illustration filling the entire canvas edge-to-edge.
Scene: An energetic heroic party of five adorable chibi heroes standing together beneath a sunlit cerulean sky framed by blooming pink sakura branches and swirling blossoms — blonde Knight in the center raising his sword heroically with fluttering cape, flanked by emerald-haired elf Archer, lavender witch-hat Mage, sakura-pink Priest, and sky-blue shrine Mage. Leave clean bright sakura sky space in the upper-middle and lower-center third so the game title logo and "Tap to Start" button can be overlaid dynamically in Godot.
Art Style: Hand-drawn 2D anime fantasy gacha key art, crisp dark ink outlines, radiant cel-shaded watercolor lighting matching ui_screens_mockup.jpg.
Clean Output: Full-bleed artwork edge-to-edge, strictly NO logo text, NO game title, NO UI buttons, NO watermarks.
```

## 8. Gói Gacha, Kết Quả Trận & 7 Icon Kỹ Năng Hero (`ui_gacha_and_skill_icons_pack.png`) — [P0]
```
Output file: inbox/ui_gacha_and_skill_icons_pack.png
Asset: Gacha Card Back, Summon Light Beam, Evo Arrow, Victory/Defeat Crests & 7 Skill Icons (12 Icons)
Grid: 4 columns × 3 rows (12 cleanly separated equal-sized square cells, 4:3 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy gacha RPG UI emblems and circular skill icons pack arranged in a strict 4 columns by 3 rows grid (12 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Subimages (5 system emblems + 7 circular hero skill emblem icons, NO text):
- Cell 1 (r1c1, -> ui_gacha_card_back.png): Ornate deep-indigo and gold vertical Gacha Summon Card Back featuring a glowing golden celestial star-crest sigil.
- Cell 2 (r1c2, -> ui_gacha_beam.png): Radiant vertical golden-violet Summon Magic Light Pillar beam burst with floating star sparkles.
- Cell 3 (r1c3, -> ui_evo_arrow.png): Sleek glossy golden-orange glowing upgrade/evolution arrow emblem pointing RIGHT.
- Cell 4 (r1c4, -> ui_banner_victory.png): Triumphant golden winged crown & crossed swords Victory emblem crest (no text).
- Cell 5 (r2c1, -> ui_banner_defeat.png): Moody slate-and-crimson cracked knight shield & broken blade Defeat emblem crest (no text).
- Cell 6 (r2c2, -> skill_icon_slash.png): Circular crimson-gold framed skill icon showing a blazing cyan-gold crescent sword slash.
- Cell 7 (r2c3, -> skill_icon_shield.png): Circular royal-gold framed skill icon showing a glowing golden holy barrier shield.
- Cell 8 (r2c4, -> skill_icon_axe.png): Circular fiery crimson-framed skill icon showing a burning magma battleaxe cleave.
- Cell 9 (r3c1, -> skill_icon_dagger.png): Circular dark-violet framed skill icon showing twin crossed violet shadow daggers.
- Cell 10 (r3c2, -> skill_icon_arrow.png): Circular emerald-gold framed skill icon showing a volley of glowing green wind arrows.
- Cell 11 (r3c3, -> skill_icon_arcane.png): Circular indigo-violet framed skill icon showing a radiant cosmic meteor star burst.
- Cell 12 (r3c4, -> skill_icon_heal.png): Circular rose-emerald framed skill icon showing a glowing pink sacred lotus heal aura.
Composition & Technical Rules: Center-aligned cleanly inside each cell with generous white margins.
Art Style: Hand-drawn 2D fantasy RPG UI icon art, crisp dark outlines, glossy cel-shading matching ui_screens_mockup.jpg.
Clean Output: Pure flat solid white background (#FFFFFF), strictly NO text, NO numbers, NO grid lines, NO watermarks.
```

## 9. Fire Knight (Nhánh AoE Damage) — Idle (`knight_fire_idle.png`) — [P1]
```
Output file: inbox/knight_fire_idle.png
Asset: Fire Knight (AoE Branch) — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG evolved hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Fire Knight (AoE Damage evolution branch) — fierce evolved blonde spiky-haired chibi Knight wearing crimson-and-obsidian dragon-forged plate armor, blazing crimson-gold cape, fiery phoenix shoulder crests, wielding a massive glowing magma-orange flaming greatsword (no shield), facing RIGHT.
Animation (4 seamless combat idle frames):
- Frames 1–2: Confident breathing rise, flaming greatsword flickering with warm orange embers, crimson cape fluttering.
- Frames 3–4: Fierce blink and smooth settle back to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no oval drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 10. Fire Knight (Nhánh AoE Damage) — Skill (`knight_fire_skill.png`) — [P1]
```
Output file: inbox/knight_fire_skill.png
Asset: Fire Knight (AoE Branch) — Inferno AoE Greatsword Slam Skill (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG evolved hero skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Fire Knight in crimson-obsidian dragon armor, crimson cape, and massive glowing magma-orange flaming greatsword, facing RIGHT.
Animation (6 explosive AoE fire-slash frames):
- Frames 1–2: Leaps upward raising blazing magma greatsword high above head engulfed in fiery orange-gold flames.
- Frames 3–4: Slams blazing greatsword forward-right unleashing a huge fiery crimson-gold crescent fire shockwave wave.
- Frames 5–6: Heroic landing crouch with rising embers returning smoothly to Idle Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 11. Holy Guardian (Nhánh Protect Allies) — Idle (`knight_holy_idle.png`) — [P1]
```
Output file: inbox/knight_holy_idle.png
Asset: Holy Guardian (Protect Branch) — Idle Animation (4 Frames)
Grid: 2 columns × 2 rows (4 cleanly separated equal-sized square cells, 1:1 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG evolved hero idle animation sprite sheet arranged in a strict 2 columns by 2 rows grid (4 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Holy Guardian (Protect Allies evolution branch) — noble evolved blonde chibi Knight wearing radiant white-and-gold seraphic plate armor, majestic golden angel-feather shoulder wings, halo crest, holding a gleaming golden sacred spear-blade and a massive golden-sapphire tower greatshield, facing RIGHT.
Animation (4 serene guardian idle frames):
- Frames 1–2: Noble steady breathing rise, golden angel-wing crests shimmering subtly, huge tower greatshield braced forward.
- Frames 3–4: Calm blink and smooth settle back to Frame 1.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 4 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no oval drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```

## 12. Holy Guardian (Nhánh Protect Allies) — Skill (`knight_holy_skill.png`) — [P1]
```
Output file: inbox/knight_holy_skill.png
Asset: Holy Guardian (Protect Branch) — Seraphic Bastion Shield Skill (6 Frames)
Grid: 3 columns × 2 rows (6 cleanly separated equal-sized square cells, 3:2 aspect ratio, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG evolved hero skill sprite sheet arranged in a strict 3 columns by 2 rows grid (6 cleanly separated equal-sized square cells, read left-to-right, top-to-bottom).
Character: Holy Guardian in white-gold seraphic armor, golden angel shoulder wings, golden spear-blade, and massive golden-sapphire tower greatshield, facing RIGHT.
Animation (6 radiant protector barrier frames):
- Frames 1–2: Spreads golden wings wide raising glowing tower shield skyward bathed in radiant golden-white light.
- Frames 3–4: Slams huge tower shield forward projecting a majestic luminous golden-cyan holy bastion barrier dome wave.
- Frames 5–6: Serene upright recovery returning smoothly into Idle Frame 1 stance.
Composition & Technical Rules: Bottom-center aligned at identical scale across all 6 cells, facing RIGHT, generous white margins.
Art Style: Hand-drawn 2D chibi fantasy RPG game art, crisp dark ink outlines (~3px), vibrant cel-shaded anime coloring.
Clean Output: Pure flat solid white background (#FFFFFF), no ground patch, no drop shadow beneath feet, strictly NO grid lines, NO borders, NO text, NO numbers, NO watermarks.
```
