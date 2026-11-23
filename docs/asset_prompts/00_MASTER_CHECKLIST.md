# 00 — Danh Sách Tổng Hợp Prompt Tạo Asset (Master Checklist)

> **Tham chiếu:** [GDD.md](../GDD.md) · [ASSET_SPEC.md](../ASSET_SPEC.md) · [base_assetsheet.jpg](../references/base_assetsheet.jpg) · [ui_screens_mockup.jpg](../references/ui_screens_mockup.jpg)  
> **Quy trình:** Lấy prompt trong các file bên dưới → Tạo ảnh và đặt vào `inbox/` theo đúng tên `Output file` → Chạy `python3 tools/adapt_assets.py` → Ảnh sạch tự vào `assets/sprites/`, bản gốc tự chuyển sang `archive/`.
>
> **Lưu ý:** Toàn bộ bộ prompt MVP v0.1 (`01`..`08`) đã tạo, adapt sạch và được lưu trữ gọn trong [archive/](archive/). Dưới đây là các gói mở rộng đang chờ tạo tiếp (`09` & `10`).

---

## Đợt 4 — Đang Chờ Tạo (Active Prompts)

### 1. Fantasy Town World Map 3 Khu Vực ([09_fantasy_town_world_map_mvp.md](09_fantasy_town_world_map_mvp.md))
- [ ] `inbox/town_bg_sky_far.png` `[P0]` — Nền trời, mây, núi & lâu đài xa (parallax tầng xa, 16:9 seamless)
- [ ] `inbox/town_bg_mid_horizon.png` `[P0]` — Dải rừng Sakura, mái nhà & thác nước tầng giữa (16:9, nền trắng phía trên)
- [ ] `inbox/town_ground_tiles_pack.png` `[P0]` — Gói `2×2` mặt đất 3 khu vực & viền chuyển tiếp
- [ ] `inbox/town_buildings_core_pack.png` `[P0]` — Gói `2×2` 4 công trình lõi (`Summon Portal`, `Heroes Hall`, `Battle Arena`, `Idle Treasury`)
- [ ] `inbox/town_landmarks_pack.png` `[P0]` — Gói `2×1` điểm nhấn (`Central Hero Fountain` & `Eastern Fantasy Gate`)
- [ ] `inbox/town_decor_trees_pack.png` `[P1]` — Gói `2×2` biến thể cây Sakura, cây Phong & cụm tre/hoa
- [ ] `inbox/town_decor_props_pack.png` `[P1]` — Atlas `3×2` đạo cụ thị trấn (đèn đá, sạp hàng, biển chỉ đường, ghế đá/bồn hoa, thùng gỗ, bậc thang)
- [ ] `inbox/town_npc_and_ui_pack.png` `[P1]` — Gói `3×2` NPC/thú cưng & UI bảng tên/tab khu vực/mũi tên cuộn

### 2. Nâng Cấp Heroes Showcase & RPG UI ([10_heroes_showcase_upgrade.md](10_heroes_showcase_upgrade.md))
- [ ] `inbox/ui_showcase_frames_pack.png` `[P0]` — Khung bảng 9-slice hoa văn vàng, thanh ngăn & nút xanh lá
- [ ] `inbox/showcase_pedestals_pack.png` `[P0]` — Gói `2×2` 4 bệ đứng ma pháp Showcase (`Light`, `Fire`, `Water`, `Dark`)
- [ ] `inbox/bg_showcase_elements_pack.png` `[P0]` — Gói `3×2` 6 nền Showcase theo nguyên tố
- [ ] `inbox/hero_standees_pack_1.png` `[P1]` — Gói `3×2` tranh đứng High-Res 6 Hero hàng 1
- [ ] `inbox/hero_standees_pack_2.png` `[P1]` — Gói `3×2` tranh đứng High-Res 6 Hero hàng 2

### 3. Nâng Cấp Màn Gacha Summon ([11_gacha_summon_mvp_assets.md](11_gacha_summon_mvp_assets.md))
- [ ] `inbox/gacha_summon_banner.png` `[P0]` — Nền Summon Banner giới thiệu tướng (`16:9`)
- [ ] `inbox/gacha_summon_vfx_sheet.png` `[P0]` — Gói `2×2` Summon Reveal VFX (`SSR`, `UR`, vòng phép, cột sáng)
- [ ] `inbox/gacha_result_bg.png` `[P1]` — Nền tối sao trời hiển thị kết quả triệu hồi `x1 / x10` (`16:9`)

---

## Đã Hoàn Thành & Đã Archive (`01`..`08` → `docs/asset_prompts/archive/`)

### Đợt 1 — Khung MVP (Nền, UI, Base Heroes, Quái, Boss, VFX & Items)
- [x] `inbox/bg_battle_vistas_pack.png` — 4 nền chiến đấu theo chương ([archive/05_backgrounds_ui_cards_decor.md](archive/05_backgrounds_ui_cards_decor.md))
- [x] `inbox/bg_lobby_town.png`, `inbox/bg_campaign_map.png`, `inbox/bg_ui_scenes_pack.png` ([archive/06_screens_lobby_map_gacha_idle.md](archive/06_screens_lobby_map_gacha_idle.md))
- [x] `inbox/ui_hud_nav_pack.png`, `inbox/ui_small_nav_icons_pack.png`, `inbox/ui_panels_buttons_pack.png`, `inbox/ui_campaign_battle_hud_pack.png`, `inbox/ui_gacha_and_skill_icons_pack.png` ([archive/05](archive/05_backgrounds_ui_cards_decor.md) & [archive/06](archive/06_screens_lobby_map_gacha_idle.md))
- [x] `inbox/ui_hero_cards_rarity_pack.png`, `inbox/ui_currency_stars_pack.png`, `inbox/ui_class_tags_pack.png` ([archive/05_backgrounds_ui_cards_decor.md](archive/05_backgrounds_ui_cards_decor.md))
- [x] `inbox/heroes_row1_pack.png`, `inbox/heroes_row2_pack.png`, `inbox/heroes_portraits_row1.png`, `inbox/heroes_portraits_row2.png`, `inbox/knight_evolution_pack.png` ([archive/01_heroes_base_and_evolution.md](archive/01_heroes_base_and_evolution.md))
- [x] `inbox/knight_branch_evolution_pack.png` ([archive/06_screens_lobby_map_gacha_idle.md](archive/06_screens_lobby_map_gacha_idle.md))
- [x] `inbox/enemies_mobs_base_pack.png`, `inbox/bosses_base_pack.png` ([archive/03_enemies_and_bosses.md](archive/03_enemies_and_bosses.md))
- [x] `inbox/vfx_offensive_pack.png`, `inbox/vfx_buff_dark_pack.png`, `inbox/icons_status_buffs_pack.png`, `inbox/icons_status_debuffs_pack.png`, `inbox/icons_elements_pack.png`, `inbox/items_equipment_pack.png`, `inbox/items_loot_resources_pack.png` ([archive/04_vfx_status_elements_items.md](archive/04_vfx_status_elements_items.md))

### Đợt 2 — Hoạt Ảnh Chiến Đấu 12 Hero, Quái & 3 Boss
- [x] Đội hình khởi đầu (`knight`, `archer`, `mage`, `priest`) ([archive/02_hero_animations_knight_and_core.md](archive/02_hero_animations_knight_and_core.md))
- [x] 8 Hero MVP còn lại (`paladin`, `berserker`, `assassin`, `sniper`, `enchanter`, `druid`, `samurai`, `ninja`) ([archive/07_remaining_heroes_anim.md](archive/07_remaining_heroes_anim.md))
- [x] Hoạt ảnh tiến hóa nhánh Knight (`knight_fire`, `knight_holy`) ([archive/06_screens_lobby_map_gacha_idle.md](archive/06_screens_lobby_map_gacha_idle.md))
- [x] Goblin, 5 Quái & 3 Boss ([archive/03_enemies_and_bosses.md](archive/03_enemies_and_bosses.md) & [archive/08_remaining_mobs_bosses_anim.md](archive/08_remaining_mobs_bosses_anim.md))

### Đợt 3 — Hoàn Thiện Mỹ Thuật & Chi Tiết Phụ
- [x] `inbox/bg_title_splash.png` ([archive/06_screens_lobby_map_gacha_idle.md](archive/06_screens_lobby_map_gacha_idle.md))
- [x] `inbox/bg_parallax_props_pack.png`, `inbox/ui_rank_emblems_pack.png`, `inbox/decor_system_props_pack.png` ([archive/05_backgrounds_ui_cards_decor.md](archive/05_backgrounds_ui_cards_decor.md))
- [x] `inbox/knight_hit.png`, `inbox/knight_death.png` ([archive/02_hero_animations_knight_and_core.md](archive/02_hero_animations_knight_and_core.md))
