# 09 — Fantasy Town World Map (3 Khu Vực Cuộn Ngang) — Kiểm Kê & Danh Sách Prompt MVP

- **Mục tiêu:** Nâng cấp Sảnh Chính (`LobbyScreen`) thành **Fantasy Town World Map** cuộn ngang 3 khu vực (**West District · Central Plaza · East District**) theo phong cách *Cookie Run: Kingdom* / *Guardian Tales*, giữ nguyên thẩm mỹ Japanese anime-fantasy chibi pastel.
- **Thư mục nhận raw:** `inbox/`
- **Quy chuẩn đồng bộ:**
  - Nền tách lớp dùng ảnh **16:9** liền mạch theo chiều ngang (`seamless horizontal`).
  - Công trình, cây cối, đồ trang trí, NPC xuất trên nền trắng tinh `#FFFFFF` (không đổ bóng đất cứng vẽ sẵn, không chữ/text/watermark) để Godot tách nền sạch, đặt neo ở chân công trình (`bottom-center anchor`) và vẽ bóng động/parallax.
  - Không tạo lại 153 hạng mục riêng lẻ — toàn bộ nhu cầu MVP được **gom gọn thành 8 file ảnh (5 P0 + 3 P1)** kết hợp tái sử dụng tài nguyên đã có sẵn trong repository.

---

## Phần 1 — Kiểm Kê Tài Nguyên Đã Có Sẵn Trong Repository (Không Cần Tạo Lại)

| Nhóm đề xuất | Đã có sẵn trong `assets/sprites/` & code | Cách tái sử dụng trực tiếp |
|---|---|---|
| **Nhân vật chính & Anh hùng** | 12 Hero đủ `idle / attack / skill` trong `assets/sprites/heroes/` + `UnitVisual` | Dùng `UnitVisual` cho Main Hero (`knight`) và tối đa 3–4 tướng đang sở hữu đi dạo trên quảng trường |
| **Trang trí cơ bản** | `assets/sprites/decor/`: `decor_sakura_tree.png`, `decor_torii_gate.png`, `decor_stone_lantern.png`, `decor_hanging_lantern.png`, `decor_wood_fence.png`, `decor_garden_cluster.png`, `decor_banner_{red,blue,green}.png`, `decor_magic_crystal.png` | Tái sử dụng trực tiếp trên bản đồ; chỉ bổ sung thêm biến thể cây & sạp/đạo cụ thị trấn ở gói P1 |
| **VFX & Particles** | `assets/sprites/vfx/` (`vfx_arcane_circle.png`, `vfx_dark_vortex.png`, `vfx_lotus_bloom.png`, `vfx_heal_aura.png`) + `UiFx.create_ambient_particles()` | Dùng `CPUParticles2D`/`GPUParticles2D` của Godot cho cánh hoa rơi, đom đóm, tia nắng, xoáy cổng phép |
| **HUD & Nút Điều Hướng** | `assets/sprites/ui/`: `ui_avatar_frame.png`, `ui_currency_bar.png`, `ui_btn_{gold,blue,red}.png`, `ui_nav_{heroes,summon,campaign,shop,tower,events}.png`, `ui_icon_{idle_chest,settings,mail,quests,bag,guild,achieve}.png`, `ui_ribbon_red.png`, `ui_pin_stage_active.png` | Tái sử dụng cho Commander HUD, thanh tài nguyên, nút shortcut; chỉ bổ sung bảng tên công trình & tab khu vực |
| **Âm Thanh & Dữ Liệu Map** | `AudioManager` (`scripts/autoload/audio_manager.gd`) + `Camera2D` / `ParallaxBackground` / markers Godot | Lập trình trực tiếp trong Godot, không cần tạo asset ảnh |

> **Còn thiếu cho MVP:** Lớp nền parallax tách rời (`sky + mountains`, `mid sakura/rooftops`), bộ tileset mặt đất 3 khu vực, 4 công trình tương tác lõi (`Summon Portal`, `Heroes Hall`, `Battle Arena`, `Idle Treasury`), 2 công trình điểm nhấn (`Hero Fountain`, `Eastern Gate`), cộng thêm cây/đạo cụ/NPC & bảng tên bản đồ ở mức P1.

---

## Phần 2 — Danh Sách Prompt MVP (8 File Gọn: 5 P0 + 3 P1)

> Tạo xong file nào, bạn lưu đúng tên vào `inbox/` để script adapt xử lý.

### Giai Đoạn P0 — Bản Đồ 3 Khu Vực Hoạt Động Được (5 File Cốt Lõi)

#### 1. `inbox/town_bg_sky_far.png` — Lớp Nền Trời & Núi Lâu Đài Xa (Parallax Tầng Xa) `[P0]`
```text
Output file: inbox/town_bg_sky_far.png
Asset: Seamless Horizontal Far Sky, Clouds, Mountains & Distant Castle Parallax Layer
Grid: 1 single seamless wide scenic layer (16:9 aspect ratio)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG far parallax background layer, 16:9 wide aspect ratio, designed to tile seamlessly horizontally left-to-right.
Scene: Soft sunlit pastel blue and warm ivory sky filled with fluffy painterly cel-shaded cumulus clouds in the upper half. Along the lower horizon stretch gentle distant lavender-blue mountain silhouettes, soft atmospheric haze, and a small storybook white-and-cobalt fantasy castle silhouette nestled calmly on a far ridge near the center-right.
Composition & Technical Rules: Flat even horizon line across the entire bottom edge with NO foreground buildings, NO foreground trees, NO ground floor, so closer midground and town ground layers can scroll cleanly in front of it. Left edge and right edge must connect seamlessly without visible seam.
Art Style: Vibrant pastel Japanese anime-fantasy watercolor cel-shading matching bg_lobby_town.png, soft outlines.
Clean Output: Strictly NO characters, NO UI, NO text, NO numbers, NO watermarks.
```

#### 2. `inbox/town_bg_mid_horizon.png` — Dải Rừng Sakura, Mái Nhà & Thác Nước (Parallax Tầng Giữa) `[P0]`
```text
Output file: inbox/town_bg_mid_horizon.png
Asset: Seamless Horizontal Midground Horizon Strip (Sakura Forest, Rooftops Silhouette & Distant Waterfall)
Grid: 1 single horizontal panorama strip (16:9 aspect ratio) on a pure solid white upper sky (#FFFFFF)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG midground town horizon silhouette strip isolated on a pure solid white background (#FFFFFF) in the upper half, 16:9 wide aspect ratio, designed to repeat seamlessly horizontally.
Scene: A continuous lower-half scenic skyline transitioning softly across three fantasy town zones: blooming pink sakura cherry blossom treetops on the left, cozy timber-and-cobalt Japanese-fantasy gabled rooftops and stone turrets in the middle with a delicate distant blue waterfall cascading down mossy cliffs, and warm stone-walled watchtowers on the right.
Composition & Technical Rules: Keep the entire upper 45% pure solid white (#FFFFFF) with clean crisp silhouettes along the treetops and rooftops so transparency keying cleanly reveals the sky layer behind it. Keep the bottom edge straight and flat for easy grounding behind the playable town plaza.
Art Style: Soft pastel Japanese anime-fantasy cel-shaded art matching bg_lobby_town.png, slightly muted atmospheric depth so foreground buildings pop.
Clean Output: Pure white (#FFFFFF) background above the skyline, strictly NO characters, NO UI, NO text, NO watermarks.
```

#### 3. `inbox/town_ground_tiles_pack.png` — Bộ Nền Mặt Đất 3 Khu Vực & Viền Chuyển Tiếp `[P0]`
```text
Output file: inbox/town_ground_tiles_pack.png
Asset: 4 Seamless Ground Tileset Patches (Central Plaza, Sakura Path, Stone Road, Grass Edge Transition)
Grid: 2 columns × 2 rows (4 square top-down 3/4 walkable ground patches cleanly separated by crisp white borders, read left-to-right, top-to-bottom)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG town ground terrain pack arranged in a strict 2 columns by 2 rows grid (4 evenly sized square panels cleanly separated by solid white dividers, 1:1 square layout).
Perspective: Uniform slightly top-down 3/4 2.5D game ground perspective matching Cookie Run: Kingdom and Guardian Tales, designed so each square tile repeats cleanly.
Row 1 Col 1 (Central Plaza Pavement): Warm sunlit ivory-and-cream cobblestone plaza tiles with subtle golden trim inlays and tiny tufts of grass in crevices.
Row 1 Col 2 (West District Sakura Path): Soft moss-green grass and warm packed-earth garden path scattered lightly with pink sakura petals.
Row 2 Col 1 (East District Stone Road): Warm weathered sandstone and slate flagstone road tiles with crisp stylized beveled stone cracks.
Row 2 Col 2 (Grass & Cobblestone Edge Transition): Lush emerald-green grass border meeting light cobblestone edge with tiny daisies and soft dirt curbing so districts blend naturally.
Art Style: Vibrant pastel anime-fantasy painterly cel-shading, low-contrast readable surface textures so foreground buildings and chibi heroes stand out clearly.
Clean Output: Strictly NO buildings, NO trees, NO characters, NO text, NO labels, NO numbers, NO watermarks.
```

#### 4. `inbox/town_buildings_core_pack.png` — 4 Công Trình Tương Tác Lõi (Summon · Heroes · Battle · Idle) `[P0]`
```text
Output file: inbox/town_buildings_core_pack.png
Asset: 4 Core Interactive Town Buildings (Summon Portal, Heroes Hall, Battle Arena, Idle Treasury)
Grid: 2 columns × 2 rows on a pure solid white background (#FFFFFF), generous white margin between each building, NO dividing lines touching buildings

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG town buildings asset sheet arranged in a strict 2 columns by 2 rows grid on a pure solid white background (#FFFFFF), 1:1 square layout, uniform slightly top-down 3/4 2.5D perspective matching Cookie Run: Kingdom and Guardian Tales. Each building must be fully contained in its quadrant with clean white space all around and NO cut-off roofs:
Row 1 Col 1 (Summon Portal Shrine): Ornate Japanese-fantasy stone archway shrine with glowing violet-and-gold arcane rune pillars, floating crystal lanterns, and an empty glowing purple-blue magical portal frame ready for VFX overlay.
Row 1 Col 2 (Heroes Hall Guildhouse): Cozy two-story fantasy Edo timber-and-white-plaster guild hall with cobalt-blue curved tiled roofs, hanging golden banners, arched wooden double doors, and a warm welcoming entryway.
Row 2 Col 1 (Battle Arena Dojo): Martial fantasy training dojo & mini colosseum pavilion with crimson-and-gold tiled roof, crossed golden sword emblem mounted above the gate, stone training steps, and fluttering war banners.
Row 2 Col 2 (Idle Treasury Vault): Ornate golden-trimmed stone-and-timber treasury house with an open porch holding a gleaming open wooden treasure chest overflowing with gold coins and purple mana crystals.
Art Style: Vibrant pastel Japanese anime-fantasy cel-shading, crisp dark-brown/indigo outlines, warm sunlit highlights from upper-left.
Clean Output: Pure solid white background (#FFFFFF), NO baked drop shadows outside the base footprint, NO ground grass patches attached, NO characters, NO text, NO numbers, NO watermarks.
```

#### 5. `inbox/town_landmarks_pack.png` — Đài Phun Nước Trung Tâm & Cổng Đông `[P0]`
```text
Output file: inbox/town_landmarks_pack.png
Asset: 2 Architectural Town Landmarks (Central Hero Fountain & Eastern Fantasy Gate)
Grid: 2 columns × 1 row side-by-side on a pure solid white background (#FFFFFF), wide 16:9 layout, generous white margin around both structures

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG town architectural landmarks sheet with 2 items placed cleanly side-by-side in a 2 columns by 1 row layout on a pure solid white background (#FFFFFF), 16:9 wide aspect ratio, uniform 3/4 2.5D town perspective:
Left (Central Hero Fountain): Ornate circular tiered white-marble and gold-trimmed fantasy plaza fountain with sparkling azure water basin, carved knight-sword crest spire at the top, and gentle water cascades falling cleanly into the pool.
Right (Eastern Fantasy Gate & Stone Bridge Arch): Grand stylized Japanese-fantasy stone-and-crimson-timber eastern town gatehouse with curved cobalt-and-gold tiled roof, hanging paper lanterns, and small carved stone steps at the base.
Art Style: Vibrant pastel Japanese anime-fantasy cel-shading matching town_buildings_core_pack.png, crisp outlines, warm sunlit highlights.
Clean Output: Pure solid white background (#FFFFFF), NO baked ground shadows, NO characters, NO text, NO numbers, NO watermarks.
```

---

### Giai Đoạn P1 — Cây Cối, Đạo Cụ, NPC & HUD Bản Đồ Thị Trấn (3 File Bổ Sung)

#### 6. `inbox/town_decor_trees_pack.png` — Bộ Cây Anh Đào, Cây Phong & Bụi Tre/Hoa `[P1]`
```text
Output file: inbox/town_decor_trees_pack.png
Asset: 4 Town Foliage & Tree Variants (2 Sakura Trees, Japanese Maple Tree, Bamboo & Flower Cluster)
Grid: 2 columns × 2 rows on a pure solid white background (#FFFFFF), 1:1 square layout, generous white margin around each sprite

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG town foliage & trees sprite sheet arranged in a strict 2 columns by 2 rows grid on a pure solid white background (#FFFFFF), 1:1 square layout, uniform 3/4 2.5D game view:
Row 1 Col 1 (Large Blooming Sakura Tree): Lush full-canopy pink cherry blossom tree with warm curved brown trunk and soft layered pastel-pink blossom clouds.
Row 1 Col 2 (Weeping Young Sakura Tree): Slender graceful cherry blossom tree with drooping pink blossom branches and small moss accent at roots.
Row 2 Col 1 (Autumn Japanese Maple Tree): Vibrant warm amber-orange and crimson Japanese maple tree adding rich seasonal color contrast for the East District.
Row 2 Col 2 (Bamboo & Garden Flowerbed Cluster): Neat cluster of emerald-green bamboo stalks paired with blooming pastel blue hydrangeas and pink garden flowers.
Art Style: Soft painterly Japanese anime-fantasy cel-shading matching bg_lobby_town.png, crisp readable shapes.
Clean Output: Pure solid white background (#FFFFFF), NO ground shadows, NO soil squares around roots, NO characters, NO text, NO watermarks.
```

#### 7. `inbox/town_decor_props_pack.png` — Atlas 6 Nhóm Đạo Cụ Thị Trấn `[P1]`
```text
Output file: inbox/town_decor_props_pack.png
Asset: 6 Town Environment Props (Stone Lantern, Wooden Signpost, Market Stall, Stone Bench & Flowerbed, Barrels & Crates, Stone Stairs)
Grid: 3 columns × 2 rows on a pure solid white background (#FFFFFF), 16:9 wide aspect ratio, generous white margin around each prop

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG town environment props atlas arranged in a strict 3 columns by 2 rows grid on a pure solid white background (#FFFFFF), 16:9 wide aspect ratio, uniform 3/4 2.5D perspective matching the town buildings:
Row 1 Col 1: Ornate traditional Japanese moss-touched stone garden lantern with warm glowing amber paper window.
Row 1 Col 2: Cozy wooden merchant market stall cart with red-and-cream striped fabric awning and neat potion bottles & gold pouches on the counter.
Row 1 Col 3: Fantasy wooden signpost with dual directional arrow boards and a small hanging blue banner (blank boards, NO text).
Row 2 Col 1: Carved cream-stone garden plaza bench beside a small low stone flower planter with colorful blossoms.
Row 2 Col 2: Small cluster of two wooden supply barrels and a strapped fantasy cargo crate.
Row 2 Col 3: Short wide segment of sunlit cream cobblestone plaza stairs (3 steps) with low carved stone side rails.
Art Style: Vibrant pastel Japanese anime-fantasy cel-shading, crisp outlines, clean silhouette per cell.
Clean Output: Pure solid white background (#FFFFFF), NO baked drop shadows, NO characters, NO text, NO letters, NO watermarks.
```

#### 8. `inbox/town_npc_and_ui_pack.png` — NPC Thị Trấn, Thú Cưng & Bảng Tên Bản Đồ `[P1]`
```text
Output file: inbox/town_npc_and_ui_pack.png
Asset: Town NPCs, Cute Critters & Map Navigation UI Elements (Merchant, Cat, Fox Spirit, Building Nameplate, District Tab, Scroll Arrow + Indicator)
Grid: 3 columns × 2 rows on a pure solid white background (#FFFFFF), 16:9 wide aspect ratio, generous white spacing around every item

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG town NPCs & map UI elements sheet arranged in a strict 3 columns by 2 rows grid on a pure solid white background (#FFFFFF), 16:9 wide aspect ratio, cel-shaded chibi proportions matching Tiny Legends: Evolution:
Row 1 Col 1 (Merchant NPC): Cheerful chibi fantasy shopkeeper girl with braided brown hair, green apron, and leather pouch, standing facing slightly right in a friendly welcoming idle pose.
Row 1 Col 2 (Town Calico Cat): Cute plump anime chibi calico cat sitting happily with curled tail, small red collar and tiny golden bell.
Row 1 Col 3 (Floating Fox Spirit): Adorable tiny white-and-gold chibi kitsune fox spirit floating gently with two fluffy tails and soft pastel cyan/gold wisp aura.
Row 2 Col 1 (Building Nameplate Banner): Sleek dark-wood and brushed-gold fantasy UI nameplate plaque with subtle sakura corner trim (blank dark center, NO text).
Row 2 Col 2 (District Navigation Tab Pill): Ornate curved navy-and-gold fantasy RPG horizontal tab pill frame suitable for district switching (blank center, NO text).
Row 2 Col 3 (Map Scroll Arrow & Interaction Pin): One glossy golden fantasy arrow button pointing right paired with one small glowing sky-blue diamond interaction marker floating icon.
Art Style: Crisp cel-shaded Japanese anime-fantasy chibi art and brushed-gold UI polish matching ui_screens_mockup.jpg.
Clean Output: Pure solid white background (#FFFFFF), NO baked ground shadows under characters, NO text, NO numbers, NO letters, NO watermarks.
```
