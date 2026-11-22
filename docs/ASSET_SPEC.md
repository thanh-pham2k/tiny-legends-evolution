# Tiny Legends Evolution — Base Asset Sheet & Asset Pipeline Spec

> **Reference Sheets:** [base_assetsheet.jpg](references/base_assetsheet.jpg) · [ui_screens_mockup.jpg](references/ui_screens_mockup.jpg)  
> **Workflow:** Agent/người tạo asset đặt file raw vào `inbox/` → Chạy `python3 tools/adapt_assets.py` để cắt, xóa nền & chuẩn hóa vào `assets/sprites/...` → File gốc được tự động chuyển từ `inbox/` sang `archive/`.

---

## 1. Quy Trình Xử Lý Asset (`inbox/` → `assets/sprites/` → `archive/`)

1. **`inbox/`**: Nơi nhận toàn bộ ảnh raw / sprite sheet / pack mới sinh ra từ prompt (hỗ trợ cả tên chuẩn `<ten_file>.png` và tên tự động có tiền tố như `01-output-file-inbox-<ten-file>-png-asset-...png`). Thư mục có `.gdignore` để Godot không import file raw chưa xử lý.
2. **`python3 tools/adapt_assets.py`**: Script tự động cắt lưới (valley-based grid cutting), tách nền trắng `#FFFFFF` (giữ khử răng cưa viền, bảo toàn vùng trắng bên trong UI/nhân vật khi cần), căn tâm và chuẩn hóa kích thước ô, sau đó xuất PNG RGBA chuẩn `snake_case` vào `assets/sprites/`.
   - Hỗ trợ `--dry-run` để kiểm tra danh sách file nhận diện trong `inbox/` mà không ghi file hay di chuyển.
   - Hỗ trợ `--from-archive` để chạy lại bước adapt từ các file raw đang lưu trong `archive/`.
3. **`archive/`**: Lưu trữ toàn bộ file raw đã được xử lý từ `inbox/`. Có `.gdignore` để tránh làm nặng bộ nhớ import của Godot. Nếu cần chỉnh sửa thông số cắt/resize trong `tools/adapt_assets.py`, chỉ cần chạy `python3 tools/adapt_assets.py --from-archive`.

---

## 2. Quy Chuẩn Mỹ Thuật & Kỹ Thuật

- **Phong cách mỹ thuật (Art Style):** Chibi 2D Anime Fantasy RPG vẽ tay, nét viền nâu đậm/đen sắc nét (`~3px`), đổ bóng mềm cel-shaded rực rỡ, đồng bộ 100% với [base_assetsheet.jpg](references/base_assetsheet.jpg).
- **Định dạng đầu vào & đầu ra:**
  - Raw đầu vào (`inbox/`): Ảnh PNG đứng riêng (standalone text-to-image, không dùng Edit Mode), nền trắng phẳng `#FFFFFF` (trừ background battle panels), không đường kẻ lưới, không khung viền, không chữ, không watermark.
  - Chuẩn đầu ra (`assets/sprites/`): PNG nền trong suốt (`RGBA`), không dính viền trắng hay nền caro.
- **Hướng nhìn chuẩn (Facing Direction):**
  - **Heroes (12 anh hùng & các cấp tiến hóa):** Quay mặt sang **PHẢI** (`facing RIGHT`).
  - **Enemies (Mobs) & Bosses:** Quay mặt sang **TRÁI** (`facing LEFT`).
  - **Skill VFX / Đạn bay:** Hướng bay/chém sang **PHẢI** (hoặc căn giữa tâm đối với vòng phép/khiên/aura).
- **Chuẩn lưới & kích thước ô (Animation Hero/Mob = `192×192 px` VFX-safe, chuẩn hóa chiều cao thân nhân vật `~104 px`; Base Pose/VFX = `128×128 px`; Boss = `256×256 px` thân `~164 px`):**
  - `idle`: **4 frames** (`2×2` = `384×384 px` cho Hero/Mob, `512×512 px` cho Boss).
  - `run`: **6 frames** (`3×2` = `576×384 px` cho Hero/Mob).
  - `attack`: **6 frames** (`3×2` = `576×384 px` cho Hero/Mob, `768×512 px` cho Boss).
  - `skill`: **6 frames** (`3×2` = `576×384 px` cho Hero/Mob, `768×512 px` cho Boss).
  - `hit`: **3 frames** (`3×1` = `576×192 px`).
  - `death`: **4 frames** (`2×2` = `384×384 px` cho Hero/Mob, `512×512 px` cho Boss).
  - **Portraits / Icons / Items / Badges:** `128×128 px` (tỉ lệ 1:1, căn giữa).
  - **Hero Card Frames (`R`, `SR`, `SSR`, `UR`):** `192×256 px` (tỉ lệ thẻ dọc, bảo toàn nền nội thất khung thẻ).
  - **Battle Backgrounds (`bg_*`):** `640×360 px` hoặc `1280×720 px` (`16:9` full-bleed từng panel).
- **Quy tắc căn tâm (Anchor):**
  - `bottom-center`: Toàn bộ Hero, Evolution tiers, Enemies, Bosses, Decor đứng đất (cây, cổng Torii, đèn đá, hàng rào) — giúp triệt tiêu rung giật khi chuyển frame.
  - `center`: VFX, đạn, icon trạng thái, nguyên tố, trang bị, vật phẩm, thẻ bài, UI buttons.

---

## 3. Danh Mục Asset Từ Base Asset Sheet (15 Nhóm)

### 1. Base Characters — 12 Heroes (`assets/sprites/heroes/`)
| ID | Tên Hero | Vai trò (Class) | File Sheet / Sprite Sau Adapt | Prompt Nguồn |
| :--- | :--- | :--- | :--- | :--- |
| `knight` | Knight | Tank | `knight_base.png`, `knight_portrait.png` | `01_heroes_base_and_evolution.md` |
| `paladin` | Paladin | Tank | `paladin_base.png`, `paladin_portrait.png` | `01_heroes_base_and_evolution.md` |
| `berserker` | Berserker | Warrior | `berserker_base.png`, `berserker_portrait.png` | `01_heroes_base_and_evolution.md` |
| `assassin` | Assassin | Assassin | `assassin_base.png`, `assassin_portrait.png` | `01_heroes_base_and_evolution.md` |
| `archer` | Archer | Ranger | `archer_base.png`, `archer_portrait.png` | `01_heroes_base_and_evolution.md` |
| `sniper` | Sniper | Ranger | `sniper_base.png`, `sniper_portrait.png` | `01_heroes_base_and_evolution.md` |
| `mage` | Mage | Mage | `mage_base.png`, `mage_portrait.png` | `01_heroes_base_and_evolution.md` |
| `enchanter` | Enchanter | Mage | `enchanter_base.png`, `enchanter_portrait.png` | `01_heroes_base_and_evolution.md` |
| `priest` | Priest | Support | `priest_base.png`, `priest_portrait.png` | `01_heroes_base_and_evolution.md` |
| `druid` | Druid | Support | `druid_base.png`, `druid_portrait.png` | `01_heroes_base_and_evolution.md` |
| `samurai` | Samurai | Warrior | `samurai_base.png`, `samurai_portrait.png` | `01_heroes_base_and_evolution.md` |
| `ninja` | Ninja | Assassin | `ninja_base.png`, `ninja_portrait.png` | `01_heroes_base_and_evolution.md` |

### 2. Evolution Tiers (`assets/sprites/heroes/`)
Mỗi hero có 3 bậc tiến hóa chuẩn (`basic` Lv.1 ★, `advance` Lv.30 ★★, `awaken` Lv.60 ★★★). Khởi đầu bằng bộ Knight mẫu:
- `knight_evo_basic.png`, `knight_evo_advance.png`, `knight_evo_awaken.png` (từ `knight_evolution_pack.png`, `3×1`).

### 3. Animation Frames — Sprite Sheet (`assets/sprites/heroes/`)
Quy ước tên file: `<hero_id>_<anim>.png` (hỗ trợ cả `<hero_id>_<tier>_<anim>.png` cho bậc tiến hóa).
- Bộ đầy đủ cho `knight`: `knight_idle.png` (`2×2`), `knight_run.png` (`3×2`), `knight_attack.png` (`3×2`), `knight_skill.png` (`3×2`), `knight_hit.png` (`3×1`), `knight_death.png` (`2×2`).
- Bộ chiến đấu khởi đầu cho `archer`, `mage`, `priest`: `<id>_idle.png` (`2×2`), `<id>_attack.png` (`3×2`), `<id>_skill.png` (`3×2`).
- Các hero còn lại dùng chung template prompt trong `02_hero_animations_knight_and_core.md` và được `tools/adapt_assets.py` tự động nhận diện theo quy ước `<hero_id>_<anim>.png`.

### 4. Skills & Effects — VFX (`assets/sprites/vfx/`)
- **Gói Tấn Công (`vfx_offensive_pack.png`, `4×2`):**
  - `vfx_fire_slash_single.png`, `vfx_fire_slash_double.png`, `vfx_fire_explosion.png`, `vfx_ice_spikes.png`, `vfx_ice_shards.png`, `vfx_wind_tornado.png`, `vfx_lightning_pillar.png`, `vfx_arcane_circle.png`
- **Gói Phòng Thủ, Hồi Phục & Bóng Tối (`vfx_buff_dark_pack.png`, `3×2`):**
  - `vfx_holy_shield.png`, `vfx_ice_nova.png`, `vfx_heal_aura.png`, `vfx_lotus_bloom.png`, `vfx_shadow_wolf.png`, `vfx_dark_vortex.png`

### 5. Status & Buff/Debuff Icons (`assets/sprites/icons/`)
- **Buffs (`icons_status_buffs_pack.png`, `4×2`):**
  - `icon_buff_atk.png`, `icon_buff_def.png`, `icon_buff_hp.png`, `icon_buff_heal.png`, `icon_buff_spd.png`, `icon_buff_crit.png`, `icon_buff_star.png`, `icon_buff_shield.png`
- **Debuffs (`icons_status_debuffs_pack.png`, `4×2`):**
  - `icon_debuff_burn.png`, `icon_debuff_freeze.png`, `icon_debuff_shock.png`, `icon_debuff_poison.png`, `icon_debuff_bleed.png`, `icon_debuff_curse.png`, `icon_debuff_mark.png`, `icon_debuff_stun.png`

### 6. Element / Faction Icons (`assets/sprites/icons/`)
- **`icons_elements_pack.png` (`3×2`):**
  - `elem_fire.png`, `elem_water.png`, `elem_wind.png`, `elem_earth.png`, `elem_light.png`, `elem_dark.png`

### 7. Equipment & Loot Items (`assets/sprites/items/`)
- **Trang bị (`items_equipment_pack.png`, `3×2`):**
  - `equip_sword.png`, `equip_armor.png`, `equip_helmet.png`, `equip_boots.png`, `equip_ring.png`, `equip_shield.png`
- **Vật phẩm & Tài nguyên túi đồ (`items_loot_resources_pack.png`, `4×2`):**
  - `item_gold_coin.png`, `item_purple_gem.png`, `item_hp_potion.png`, `item_skill_scroll.png`, `item_spellbook.png`, `item_golden_key.png`, `item_treasure_chest.png`, `item_summon_ticket.png`

### 8. Enemies — Mobs (`assets/sprites/enemies/`)
- **Base Pack (`enemies_mobs_base_pack.png`, `3×2`, quay mặt TRÁI):**
  - `goblin_base.png`, `skeleton_base.png`, `wolf_base.png`, `boar_base.png`, `dark_knight_base.png`, `dark_mage_base.png`
- **Animation Sheets (`<mob_id>_<anim>.png`):**
  - Khởi đầu P0 cho `goblin`: `goblin_run.png` (`3×2`), `goblin_attack.png` (`3×2`), `goblin_death.png` (`2×2`). Tự động hỗ trợ mọi `<mob_id>_{idle,run,attack,skill,hit,death}.png`.

### 9. Bosses (`assets/sprites/bosses/`)
- **Base Pack (`bosses_base_pack.png`, `3×1`, quay mặt TRÁI):**
  - `boss_golem_base.png`, `boss_ice_dragon_base.png`, `boss_demon_lord_base.png`
- **Animation Sheets (`boss_<id>_<anim>.png`, ô `256×256 px`):**
  - Khởi đầu P0 cho `boss_golem`: `boss_golem_idle.png` (`2×2`), `boss_golem_attack.png` (`3×2`), `boss_golem_skill.png` (`3×2`). Tự động hỗ trợ mọi `boss_<id>_{idle,run,attack,skill,hit,death}.png`.

### 10. Battle Backgrounds — Parallax Layers (`assets/sprites/backgrounds/`)
- **Xa cảnh 16:9 (`bg_battle_vistas_pack.png`, `2×2`):**
  - `bg_plains_kingdom.png`, `bg_desert_oasis.png`, `bg_frozen_tundra.png`, `bg_demon_castle.png`
- **Lớp tiền/trung cảnh Parallax (`bg_parallax_props_pack.png`, `2×2`):**
  - `bg_plains_props.png`, `bg_desert_props.png`, `bg_tundra_props.png`, `bg_demon_props.png`

### 11. UI Components — Game UI Kit (`assets/sprites/ui/`)
- **6 Nút Điều Hướng Chính (`ui_hud_nav_pack.png`, `3×2`):**
  - `ui_nav_heroes.png`, `ui_nav_summon.png`, `ui_nav_campaign.png`, `ui_nav_tower.png`, `ui_nav_events.png`, `ui_nav_shop.png`
- **Khung HUD, Thanh Ribbon, Bảng & Nút Bấm (`ui_panels_buttons_pack.png`, `4×2`):**
  - `ui_avatar_frame.png`, `ui_currency_bar.png`, `ui_ribbon_red.png`, `ui_parchment_panel.png`, `ui_btn_gold.png`, `ui_btn_red.png`, `ui_btn_blue.png`, `ui_utility_icons_strip.png`

### 12. Hero Card Frames — Rarity (`assets/sprites/cards/`)
- **`ui_hero_cards_rarity_pack.png` (`2×2`):**
  - `card_frame_r.png`, `card_frame_sr.png`, `card_frame_ssr.png`, `card_frame_ur.png`

### 13. Resources & Currencies (`assets/sprites/items/` & `assets/sprites/ui/`)
- **`ui_currency_stars_pack.png` (`3×2`):**
  - `res_gold_pile.png`, `res_gem_cluster.png`, `res_mana_crystals.png`, `ui_star_filled.png`, `ui_star_empty.png`, `ui_toggle_switch.png`

### 14. Rank Emblems & Class Role Tags (`assets/sprites/ui/`)
- **Huy hiệu Rank (`ui_rank_emblems_pack.png`, `3×2`):**
  - `rank_bronze.png`, `rank_silver.png`, `rank_gold.png`, `rank_platinum.png`, `rank_diamond.png`, `rank_legend.png`
- **Nhãn Class (`ui_class_tags_pack.png`, `3×2`):**
  - `class_tank.png`, `class_warrior.png`, `class_ranger.png`, `class_mage.png`, `class_support.png`, `class_assassin.png`

### 15. System Icons & Decorations (`assets/sprites/decor/`)
- **`decor_system_props_pack.png` (`4×3`):**
  - `decor_banner_red.png`, `decor_banner_blue.png`, `decor_banner_green.png`, `decor_laurel_wreath.png`, `decor_crown.png`, `decor_hanging_lantern.png`, `decor_torii_gate.png`, `decor_sakura_tree.png`, `decor_magic_crystal.png`, `decor_stone_lantern.png`, `decor_wood_fence.png`, `decor_garden_cluster.png`

### 16. Màn Hình Hệ Thống, Bản Đồ, Tiến Hóa Phân Nhánh & Bộ Animation MVP Đầy Đủ (`06`, `07`, `08`)
- **Nền Sảnh & Bản Đồ (`06_screens_lobby_map_gacha_idle.md` → `assets/sprites/backgrounds/`):**
  - `bg_lobby_town.png`, `bg_campaign_map.png`
  - `bg_ui_scenes_pack.png` (`2×2`) → `bg_summon_portal.png`, `bg_evolution_stage.png`, `bg_hero_detail_starry.png`, `bg_idle_rewards_stage.png`
- **Map Pins, Battle HUD & Icon Nút Phụ (`06_screens_lobby_map_gacha_idle.md` → `assets/sprites/ui/`):**
  - `ui_campaign_battle_hud_pack.png` (`4×2`) → `ui_pin_stage_active.png`, `ui_pin_stage_normal.png`, `ui_pin_stage_boss.png`, `ui_btn_back.png`, `ui_btn_speed_x2.png`, `ui_btn_pause.png`, `ui_battle_portrait_frame.png`, `ui_battle_ult_ready_glow.png`
  - `ui_small_nav_icons_pack.png` (`4×2`) → `ui_icon_mail.png`, `ui_icon_quests.png`, `ui_icon_events.png`, `ui_icon_bag.png`, `ui_icon_guild.png`, `ui_icon_achieve.png`, `ui_icon_settings.png`, `ui_icon_idle_chest.png`
- **Tiến Hóa Phân Nhánh USP (`06_screens_lobby_map_gacha_idle.md` → `assets/sprites/heroes/`):**
  - `knight_branch_evolution_pack.png` (`2×1`) → `knight_evo_fire.png`, `knight_evo_holy.png`
- **Hoạt Ảnh 8 Hero MVP Còn Lại (`07_remaining_heroes_anim.md` → `assets/sprites/heroes/`):**
  - `idle` (`2×2`), `attack` (`3×2`), `skill` (`3×2`) cho `paladin`, `berserker`, `assassin`, `sniper`, `enchanter`, `druid`, `samurai`, `ninja` (24 sheets).
- **Hoạt Ảnh Quái Thường & 2 Boss Còn Lại (`08_remaining_mobs_bosses_anim.md` → `enemies/`, `bosses/`):**
  - `attack` (`3×2`) cho `skeleton`, `wolf`, `boar`, `dark_knight`, `dark_mage`.
  - `idle` (`2×2`), `attack` (`3×2`), `skill` (`3×2`) cho `boss_ice_dragon` và `boss_demon_lord`.

---

## 4. Checklist Tối Ưu 60 FPS Trên Điện Thoại (Android)

1. **Ngân sách VRAM cực nhẹ:** Mỗi sheet `192×192 px`/ô có kích thước `~80–120 KB` trên đĩa (và `~850 KB` VRAM RGBA không nén, thấp hơn nữa với ETC2/ASTC). Một trận **5v5** tối đa 10 nhân vật chỉ tốn **< 10 MB VRAM**, chạy mượt 60 FPS trên cả máy Android phổ thông.
2. **Không bóng đổ vẽ cứng (No baked ground shadows):** Toàn bộ prompt animation cấm vẽ bóng dưới chân trên nền trắng để `UnitVisual` tự vẽ bóng động `Polygon2D` đồng bộ khi nhảy/ngã/xoay.
3. **Tối đa 3 sheet cốt lõi mỗi Hero (`idle`, `attack`, `skill`):** Trạng thái `run`, `hit`, `death` dùng nội suy 60 FPS trong Godot (nghiêng chạy + bụi `CPUParticles2D`, shader chớp trắng `hit_flash.gdshader` + knockback, ngã `90°` + fade), vừa giữ chuyển động 60 FPS mượt, vừa giảm 50% dung lượng tải/RAM.
4. **Cài đặt Engine:** Mặc định **60 FPS** (`GL Compatibility`), kèm tùy chọn **30 FPS** tiết kiệm pin trong Settings cho chế độ treo máy Idle.
