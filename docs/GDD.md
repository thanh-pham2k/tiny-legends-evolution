# Tiny Legends: Evolution — Game Design Document (GDD)

> **Tài liệu liên quan:** [ASSET_SPEC.md](ASSET_SPEC.md) · [base_assetsheet.jpg](references/base_assetsheet.jpg)

**TL;DR:** **Tiny Legends: Evolution** là game **2D Japanese Kawaii Fantasy Idle Gacha RPG**, nơi người chơi triệu hồi, sưu tập, nâng cấp và tiến hóa tướng để xây dựng đội hình **5v5 chiến đấu hoàn toàn tự động**. Chiến thuật nằm ở việc xây dựng đội hình, không phải điều khiển trong trận.

---

## 1. Core Gameplay

```text
Summon Heroes (Gacha)
         ↓
Collect & Upgrade Heroes
         ↓
Build Team (5 Heroes)
         ↓
Full Auto Battle (PvE)
         ↓
Earn Rewards (Gold / EXP / Gems)
         ↓
Level Up / Star Up / Evolution
         ↓
Unlock New Stages & Heroes
         ↺
```

---

## 2. Cơ chế chính

| Hệ thống | Gameplay |
| :--- | :--- |
| **Gacha** | Triệu hồi tướng R / SR / SSR / UR bằng Gems hoặc vé |
| **Hero Collection** | Sưu tập tướng, mỗi tướng có hệ, vai trò, kỹ năng riêng |
| **Team Formation** | Chọn 5 tướng, bố trí 2 trước + 3 sau |
| **Full Auto Battle** | Tướng tự di chuyển, chọn mục tiêu, đánh thường và dùng Ultimate |
| **Combat AI** | Tank bảo vệ, Assassin đánh hàng sau, Healer tự hồi máu |
| **Hero Level** | Dùng Gold + EXP tăng chỉ số |
| **Star Upgrade** | Dùng mảnh tướng tăng sao |
| **Hero Evolution** | Thay đổi ngoại hình, kỹ năng và hành vi AI |
| **Faction Synergy** | Kết hợp tướng cùng hệ để nhận buff |
| **PvE Campaign** | Vượt màn, đánh Boss, mở khóa nội dung |
| **Idle Rewards** | Nhận tài nguyên tự động, kể cả khi offline |
| **Battle Speed** | x1 / x2, không điều khiển thủ công |

---

## 3. Điểm khác biệt (USP)

**Evolution Changes Combat AI:** Tiến hóa không chỉ tăng chỉ số mà thay đổi cách tướng tự chiến đấu.

Ví dụ:

```text
Little Knight
     │
     ▼
Iron Knight
     │
     ├──► Fire Knight
     │     AoE Damage
     │
     └──► Holy Guardian
           Protect Allies
```

---

## 4. MVP v0.1

| Thành phần | Phạm vi |
| :--- | :--- |
| **Heroes** | 12 tướng, 6 hệ |
| **Combat** | 5v5 Full Auto |
| **Progression** | Level 1–50, Star 1–3, Evolution |
| **Campaign** | 20 màn, 3 Boss |
| **Gacha** | x1/x10, Pity System |
| **Game Modes** | Campaign + Idle Rewards |
| **Platform** | Android, màn hình dọc |
| **Engine** | Godot 4 |
| **Monetization** | Rewarded Ads + Cosmetic IAP (giai đoạn sau) |

**Nguyên tắc thiết kế:** Người chơi đưa ra quyết định **trước trận**; trong trận chỉ quan sát. Sức hấp dẫn đến từ sưu tập tướng, xây dựng đội hình, tương tác kỹ năng và các dạng tiến hóa.
