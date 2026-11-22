# 00 — Danh Sách Tổng Hợp Prompt Tạo Asset (MVP v0.1 Checklist)

> **Tham chiếu:** [GDD.md](../GDD.md) · [ASSET_SPEC.md](../ASSET_SPEC.md) · [base_assetsheet.jpg](../references/base_assetsheet.jpg) · [ui_screens_mockup.jpg](../references/ui_screens_mockup.jpg)  
> **Quy trình:** Lấy prompt trong các file bên dưới → Tạo ảnh và đặt vào `inbox/` theo đúng tên `Output file` → Chạy `python3 tools/adapt_assets.py` → Ảnh sạch tự vào `assets/sprites/`, bản gốc tự chuyển sang `archive/`.
>
> **Lưu ý bám sát Base Asset:** Khi sinh ảnh cho các bộ `01..05`, `07`, `08`, luôn đính kèm [base_assetsheet.jpg](../references/base_assetsheet.jpg) làm ảnh tham chiếu phong cách & tạo hình nhân vật; khi sinh bộ màn hình & HUD ở `06`, đính kèm thêm [ui_screens_mockup.jpg](../references/ui_screens_mockup.jpg) để đồng bộ màu sắc và bố cục.

---

## Đã Có Sẵn Trong Dự Án (6 Sheets — Không Cần Tạo Lại)

| Trạng thái | File Raw (`archive/`) | File Sau Adapt (`assets/sprites/`) | Ghi chú |
| :---: | :--- | :--- | :--- |
| [x] | `knight_idle.png` | `heroes/knight_idle.png` | `2×2` (`192×192`/ô, thân `104px`) |
| [x] | `knight_run.png` | `heroes/knight_run.png` | `3×2` (`192×192`/ô) |
| [x] | `knight_attack.png` | `heroes/knight_attack.png` | `3×2` (`192×192`/ô) |
| [x] | `knight_skill.png` | `heroes/knight_skill.png` | `3×2` (`192×192`/ô) |
| [x] | `goblin_run.png` | `enemies/goblin_run.png` | `3×2` (`192×192`/ô, quay TRÁI) |
| [x] | `bg_battle_vistas_pack.png` | `backgrounds/bg_{plains_kingdom,desert_oasis,frozen_tundra,demon_castle}.png` | Đủ cả 4 chương |

---

## Đợt 1 — Ưu Tiên Cao (Khung MVP Chơi Được Từ Lobby → Map → Gacha → Battle 5v5)

### A. Nền Màn Hình & Giao Diện Hệ Thống ([06_screens_lobby_map_gacha_idle.md](06_screens_lobby_map_gacha_idle.md) & [05_backgrounds_ui_cards_decor.md](05_backgrounds_ui_cards_decor.md))
- [ ] `inbox/bg_lobby_town.png` — Nền sảnh chính Thành phố Sakura
- [ ] `inbox/bg_campaign_map.png` — Nền bản đồ Campaign 20 màn
- [ ] `inbox/bg_ui_scenes_pack.png` — 4 nền: Summon Portal, Evolution Stage, Hero Detail, Idle Rewards
- [ ] `inbox/ui_hud_nav_pack.png` — 6 nút điều hướng chính (Heroes, Summon, Campaign, Tower, Events, Shop)
- [ ] `inbox/ui_small_nav_icons_pack.png` — 8 icon phụ (Mail, Quests, Events, Bag, Guild, Achieve, Settings, Idle Chest)
- [ ] `inbox/ui_panels_buttons_pack.png` — Khung Avatar, thanh tiền tệ, ribbon, bảng giấy da, 3 nút bấm
- [ ] `inbox/ui_campaign_battle_hud_pack.png` — 3 ghim bản đồ, Back/Speed x2/Pause, khung thẻ đội hình trận đấu, viền Ult Ready
- [ ] `inbox/ui_gacha_and_skill_icons_pack.png` — Mặt sau thẻ Gacha, tia sáng triệu hồi, mũi tên tiến hóa, Victory/Defeat, 7 icon kỹ năng
- [ ] `inbox/ui_hero_cards_rarity_pack.png` — 4 khung thẻ hiếm `R / SR / SSR / UR`
- [ ] `inbox/ui_currency_stars_pack.png` — Đống vàng, ngọc tím, pha lê, sao vàng/rỗng, nút gạt
- [ ] `inbox/ui_class_tags_pack.png` — 6 huy hiệu vai trò Class

### B. 12 Hero, 6 Quái Thường, 3 Boss & Tiến Hóa Knight ([01_heroes_base_and_evolution.md](01_heroes_base_and_evolution.md), [03_enemies_and_bosses.md](03_enemies_and_bosses.md), [06](06_screens_lobby_map_gacha_idle.md))
- [ ] `inbox/heroes_row1_pack.png` — 6 Hero hàng 1 (`knight`, `paladin`, `berserker`, `assassin`, `archer`, `sniper`)
- [ ] `inbox/heroes_row2_pack.png` — 6 Hero hàng 2 (`mage`, `enchanter`, `priest`, `druid`, `samurai`, `ninja`)
- [ ] `inbox/heroes_portraits_row1.png` — 6 chân dung hàng 1 (cho thẻ bài & HUD)
- [ ] `inbox/heroes_portraits_row2.png` — 6 chân dung hàng 2
- [ ] `inbox/knight_evolution_pack.png` — 3 cấp thẳng (`Basic`, `Advance`, `Awaken`)
- [ ] `inbox/knight_branch_evolution_pack.png` — 2 nhánh USP (`Fire Knight` & `Holy Guardian`)
- [ ] `inbox/enemies_mobs_base_pack.png` — 6 quái thường (`goblin`, `skeleton`, `wolf`, `boar`, `dark_knight`, `dark_mage`)
- [ ] `inbox/bosses_base_pack.png` — 3 Boss (`boss_golem`, `boss_ice_dragon`, `boss_demon_lord`)

### C. VFX, Icon Trạng Thái, Nguyên Tố & Vật Phẩm ([04_vfx_status_elements_items.md](04_vfx_status_elements_items.md))
- [ ] `inbox/vfx_offensive_pack.png` — 8 hiệu ứng kỹ năng tấn công
- [ ] `inbox/vfx_buff_dark_pack.png` — 6 hiệu ứng khiên, hồi máu & bóng tối
- [ ] `inbox/icons_status_buffs_pack.png` — 8 icon Buff
- [ ] `inbox/icons_status_debuffs_pack.png` — 8 icon Debuff
- [ ] `inbox/icons_elements_pack.png` — 6 icon Nguyên tố (`Fire`, `Water`, `Wind`, `Earth`, `Light`, `Dark`)
- [ ] `inbox/items_equipment_pack.png` — 6 icon Trang bị
- [ ] `inbox/items_loot_resources_pack.png` — 8 icon Vật phẩm & Vé Gacha

---

## Đợt 2 — Bộ Hoạt Ảnh Chiến Đấu Đầy Đủ Cho MVP 12 Hero & 3 Boss (Chuẩn 60 FPS Hybrid)

*(Lưu ý: Mỗi Hero dùng 3 sheet cốt lõi `idle` + `attack` + `skill`; chạy/bị đánh/chết do `UnitVisual` nội suy 60 FPS nên vừa nhẹ RAM điện thoại vừa tạo nhanh gấp đôi.)*

- **Đội hình khởi đầu ([02_hero_animations_knight_and_core.md](02_hero_animations_knight_and_core.md)):**
  - [ ] `archer_idle.png`, `archer_attack.png`, `archer_skill.png` (3 prompts)
  - [ ] `mage_idle.png`, `mage_attack.png`, `mage_skill.png` (3 prompts)
  - [ ] `priest_idle.png`, `priest_attack.png`, `priest_skill.png` (3 prompts)
- **8 Hero MVP còn lại ([07_remaining_heroes_anim.md](07_remaining_heroes_anim.md)):**
  - [ ] `paladin_{idle,attack,skill}.png` (3 prompts)
  - [ ] `berserker_{idle,attack,skill}.png` (3 prompts)
  - [ ] `assassin_{idle,attack,skill}.png` (3 prompts)
  - [ ] `sniper_{idle,attack,skill}.png` (3 prompts)
  - [ ] `enchanter_{idle,attack,skill}.png` (3 prompts)
  - [ ] `druid_{idle,attack,skill}.png` (3 prompts)
  - [ ] `samurai_{idle,attack,skill}.png` (3 prompts)
  - [ ] `ninja_{idle,attack,skill}.png` (3 prompts)
- **Hoạt ảnh tiến hóa nhánh Knight ([06_screens_lobby_map_gacha_idle.md](06_screens_lobby_map_gacha_idle.md)):**
  - [ ] `knight_fire_idle.png`, `knight_fire_skill.png` (2 prompts)
  - [ ] `knight_holy_idle.png`, `knight_holy_skill.png` (2 prompts)
- **Goblin, 5 Quái & 3 Boss ([03_enemies_and_bosses.md](03_enemies_and_bosses.md) & [08_remaining_mobs_bosses_anim.md](08_remaining_mobs_bosses_anim.md)):**
  - [ ] `goblin_attack.png`, `goblin_death.png` (2 prompts)
  - [ ] `{skeleton,wolf,boar,dark_knight,dark_mage}_attack.png` (5 prompts)
  - [ ] `boss_golem_{idle,attack,skill}.png` (3 prompts)
  - [ ] `boss_ice_dragon_{idle,attack,skill}.png` (3 prompts)
  - [ ] `boss_demon_lord_{idle,attack,skill}.png` (3 prompts)

---

## Đợt 3 — Hoàn Thiện Mỹ Thuật & Chi Tiết Phụ (Tùy Chọn Bổ Sung)

- [ ] `inbox/bg_title_splash.png` — Màn hình Title Key Art ([06](06_screens_lobby_map_gacha_idle.md))
- [ ] `inbox/bg_parallax_props_pack.png` — Lớp tiền/trung cảnh Parallax 4 chương ([05](05_backgrounds_ui_cards_decor.md))
- [ ] `inbox/ui_rank_emblems_pack.png` — 6 huy hiệu Rank ([05](05_backgrounds_ui_cards_decor.md))
- [ ] `inbox/decor_system_props_pack.png` — 12 vật trang trí Guild & bản đồ ([05](05_backgrounds_ui_cards_decor.md))
- [ ] `inbox/knight_hit.png`, `inbox/knight_death.png` — Bộ Hit/Death riêng cho Knight nếu muốn thay hiệu ứng code ([02](02_hero_animations_knight_and_core.md))
