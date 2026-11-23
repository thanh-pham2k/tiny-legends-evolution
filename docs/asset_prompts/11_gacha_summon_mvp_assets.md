# 11 — Gacha Summon MVP Asset Spec & Prompts

> **TL;DR:** Với bản MVP của *Tiny Legends: Evolution*, bạn chỉ cần **6 nhóm asset Gacha**, ưu tiên tái sử dụng cổng triệu hồi và hình nhân vật hiện có.

---

## 1. Bảng Tổng Hợp 6 Nhóm Asset Gacha MVP (Khoảng 12 Asset / Bộ)

| # | Asset | Số lượng | Ưu tiên | Tình trạng hiện tại trong repo |
| - | ----- | -------- | ------- | ------------------------------ |
| 1 | **Hero Showcase** – Artwork nhân vật `R/SR/SSR/UR`, dùng lại sprite hiện có | 4 | **P0** | Đã có đủ 12 Hero (`assets/sprites/heroes/` + `*_portrait.png`) |
| 2 | **Summon Banner** – Nền giới thiệu nhân vật, phong cách fantasy | 1 | **P0** | Có thể tạo mới (`inbox/gacha_summon_banner.png`) |
| 3 | **Rarity Frames** – Khung thẻ `R/SR/SSR/UR` | 4 | **P0** | Đã có (`assets/sprites/cards/card_frame_{r,sr,ssr,ur}.png`) |
| 4 | **Summon VFX** – Ánh sáng, vòng phép, hiệu ứng xuất hiện nhân vật | 1 sprite sheet | **P0** | Đã có `ui_gacha_beam.png`, `vfx_arcane_circle.png`; có thể bổ sung `inbox/gacha_summon_vfx_sheet.png` |
| 5 | **Result Background** – Nền hiển thị kết quả triệu hồi | 1 | **P1** | Hiện dùng chung `bg_summon_portal.png`; có thể tạo riêng (`inbox/gacha_result_bg.png`) |
| 6 | **UI Decorations** – Viền panel, nút Summon, thanh pity | 1 bộ | **P1** | Đã có `ui_btn_blue.png`, `ui_btn_gold.png`, `ui_gacha_card_back.png` + dựng trực tiếp bằng Godot |

---

## 2. Nguyên Tắc MVP & Phạm Vi

- **Có thể bỏ qua ở MVP:** Banner giới hạn, nhiều loại cổng triệu hồi, animation phức tạp, hiệu ứng 3D và hệ thống trang trí cao cấp.
- **Lưu ý triển khai:** Khi đã có sẵn sprite nhân vật, khung rarity (`card_frame_{r,sr,ssr,ur}.png`) và cổng triệu hồi (`bg_summon_portal.png`), chỉ cần tạo thêm **2–3 asset** (`Summon Banner`, `Summon VFX`, `Result Background`). Các nút, thanh pity và panel dựng trực tiếp trong Godot để dễ chỉnh sửa.
- **Ưu tiên cao nhất:** Hiển thị chính xác nhân vật được triệu hồi, tên, độ hiếm, trạng thái `NEW` và cập nhật bộ sưu tập trước khi bổ sung hiệu ứng đẹp mắt.

---

## 3. Prompt Tạo Thêm 3 Asset Gacha (Tùy Chọn Nâng Cấp)

#### 1. `inbox/gacha_summon_banner.png` — Nền Summon Banner Giới Thiệu Tướng (`[P0]`)
```text
Output file: inbox/gacha_summon_banner.png
Asset: Fantasy Gacha Summon Banner Backdrop
Grid: 1 single scenic widescreen banner (16:9 aspect ratio)

Prompt:
Create a 2D Japanese anime-fantasy chibi RPG gacha summon banner backdrop filling the entire canvas cleanly edge-to-edge, 16:9 widescreen aspect ratio.
Scene: Radiant celestial twilight temple shrine framing an ornate golden-and-violet arcane summoning arch on the left and subtle swirling starlight energy streaks sweeping softly across a calm open indigo-purple space on the center-right so a featured hero sprite and banner title text can be overlaid cleanly in Godot.
Art Style: Vibrant pastel Japanese anime-fantasy cel-shaded art matching ui_screens_mockup.jpg, glowing golden highlights and soft sakura petals drifting gently at the outer edges.
Clean Output: Full-bleed artwork edge-to-edge, strictly NO characters, NO UI buttons, NO text, NO numbers, NO watermarks.
```

#### 2. `inbox/gacha_summon_vfx_sheet.png` — Summon VFX Sprite Sheet (`[P0]`)
```text
Output file: inbox/gacha_summon_vfx_sheet.png
Asset: 4 Gacha Summon Reveal VFX Sprites (Golden Burst Ring, Prismatic UR Starburst, Arcane Summoning Seal, Rising Starlight Pillar)
Grid: 2 columns × 2 rows on a pure solid white background (#FFFFFF), 1:1 square layout, generous white margin around each VFX

Prompt:
Create a 2D Japanese anime-fantasy gacha RPG summon reveal VFX asset sheet arranged in a strict 2 columns by 2 rows grid on a pure solid white background (#FFFFFF), 1:1 square layout, crisp cel-shaded game VFX art with glowing edges and NO overlapping frames:
Row 1 Col 1 (Golden SSR Burst Ring): Radiant golden-amber circular shockwave ring with crisp anime star sparks.
Row 1 Col 2 (Prismatic UR Starburst): Vibrant rainbow-gold crystalline starburst halo flare suitable for ultra-rare card reveal.
Row 2 Col 1 (Arcane Summoning Seal): Intricate luminous violet-and-gold fantasy magic circle sigil viewed flat head-on.
Row 2 Col 2 (Rising Starlight Pillar): Vertical glowing celestial cyan-and-gold light beam trail with tiny ascending four-point stars.
Clean Output: Pure solid white background (#FFFFFF), NO characters, NO cards, NO text, NO watermarks.
```

#### 3. `inbox/gacha_result_bg.png` — Nền Màn Hình Kết Quả Triệu Hồi (`[P1]`)
```text
Output file: inbox/gacha_result_bg.png
Asset: Gacha Summon Result Screen Starlit Celestial Backdrop
Grid: 1 single scenic widescreen backdrop (16:9 aspect ratio)

Prompt:
Create a 2D Japanese anime-fantasy gacha RPG summon result backdrop filling the entire canvas cleanly edge-to-edge, 16:9 wide aspect ratio.
Scene: Deep calm midnight-indigo and velvet-violet starry cosmos with soft aurora ribbons along the top corners, faint golden dust motes in the distant background, and a clean uncluttered dark center stage designed so 1x and 10x summoned rarity hero cards pop vibrantly on top without visual clutter.
Art Style: Clean painterly anime-fantasy celestial illustration matching bg_hero_detail_starry.png.
Clean Output: Full-bleed artwork edge-to-edge, strictly NO characters, NO cards, NO UI frames, NO text, NO watermarks.
```
