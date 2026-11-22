#!/usr/bin/env python3
"""Adapt raw asset sheets from inbox/ into normalized RGBA sprites in assets/sprites/
and move processed raw files to archive/.

Usage:
    python3 tools/adapt_assets.py              # Process inbox/ -> assets/sprites/ -> archive/
    python3 tools/adapt_assets.py --dry-run    # Preview matched files and target outputs
    python3 tools/adapt_assets.py --from-archive  # Re-adapt raw files stored in archive/
"""

import argparse
import glob
import os
import re
import shutil
import sys
import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INBOX_DIR = os.path.join(ROOT, "inbox")
ARCHIVE_DIR = os.path.join(ROOT, "archive")
SPRITES_DIR = os.path.join(ROOT, "assets", "sprites")

SPRITE_SUBDIRS = [
    "heroes",
    "enemies",
    "bosses",
    "vfx",
    "icons",
    "items",
    "backgrounds",
    "ui",
    "cards",
    "decor",
]

# White regions inside dark ink outlines (e.g., gaps between legs/arches/fence rails)
HOLE_BY_DARK_OUTLINE = {
    "heroes_row1_pack.png",
    "heroes_row2_pack.png",
    "knight_evolution_pack.png",
    "knight_branch_evolution_pack.png",
    "enemies_mobs_base_pack.png",
    "bosses_base_pack.png",
    "decor_system_props_pack.png",
    "bg_parallax_props_pack.png",
}

# Preserve bright interior fills on UI badges, frames, parchment panels, and cards
UI_PRESERVE_INTERIOR = {
    "icons_status_buffs_pack.png",
    "icons_status_debuffs_pack.png",
    "icons_elements_pack.png",
    "items_equipment_pack.png",
    "ui_hud_nav_pack.png",
    "ui_panels_buttons_pack.png",
    "ui_hero_cards_rarity_pack.png",
    "ui_currency_stars_pack.png",
    "ui_rank_emblems_pack.png",
    "ui_class_tags_pack.png",
    "ui_campaign_battle_hud_pack.png",
    "ui_small_nav_icons_pack.png",
    "ui_gacha_and_skill_icons_pack.png",
}

ANIM_GRIDS = {
    "idle": (2, 2, "bottom-center"),
    "run": (3, 2, "bottom-center"),
    "attack": (3, 2, "bottom-center"),
    "skill": (3, 2, "bottom-center"),
    "hit": (3, 1, "bottom-center"),
    "death": (2, 2, "bottom-center"),
}

KNOWN_MOBS = {"goblin", "skeleton", "wolf", "boar", "dark_knight", "dark_mage"}

PACK_SPECS = {
    "heroes_row1_pack.png": {
        "grid": (3, 2),
        "dir": "heroes",
        "names": [
            "knight_base.png", "paladin_base.png", "berserker_base.png",
            "assassin_base.png", "archer_base.png", "sniper_base.png",
        ],
        "size": 128,
        "anchor": "bottom-center",
        "hole_cells": {0, 1, 2, 3, 4, 5},
    },
    "heroes_row2_pack.png": {
        "grid": (3, 2),
        "dir": "heroes",
        "names": [
            "mage_base.png", "enchanter_base.png", "priest_base.png",
            "druid_base.png", "samurai_base.png", "ninja_base.png",
        ],
        "size": 128,
        "anchor": "bottom-center",
        "hole_cells": {0, 1, 2, 3, 4, 5},
    },
    "heroes_portraits_row1.png": {
        "grid": (3, 2),
        "dir": "heroes",
        "names": [
            "knight_portrait.png", "paladin_portrait.png", "berserker_portrait.png",
            "assassin_portrait.png", "archer_portrait.png", "sniper_portrait.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "heroes_portraits_row2.png": {
        "grid": (3, 2),
        "dir": "heroes",
        "names": [
            "mage_portrait.png", "enchanter_portrait.png", "priest_portrait.png",
            "druid_portrait.png", "samurai_portrait.png", "ninja_portrait.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "knight_evolution_pack.png": {
        "grid": (3, 1),
        "dir": "heroes",
        "names": [
            "knight_evo_basic.png", "knight_evo_advance.png", "knight_evo_awaken.png",
        ],
        "size": 128,
        "anchor": "bottom-center",
        "hole_cells": {0, 1, 2},
    },
    "enemies_mobs_base_pack.png": {
        "grid": (3, 2),
        "dir": "enemies",
        "names": [
            "goblin_base.png", "skeleton_base.png", "wolf_base.png",
            "boar_base.png", "dark_knight_base.png", "dark_mage_base.png",
        ],
        "size": 128,
        "anchor": "bottom-center",
        "hole_cells": {0, 1, 2, 3, 4, 5},
    },
    "bosses_base_pack.png": {
        "grid": (3, 1),
        "dir": "bosses",
        "names": [
            "boss_golem_base.png", "boss_ice_dragon_base.png", "boss_demon_lord_base.png",
        ],
        "size": 256,
        "anchor": "bottom-center",
        "hole_cells": {0, 1, 2},
    },
    "vfx_offensive_pack.png": {
        "grid": (4, 2),
        "dir": "vfx",
        "names": [
            "vfx_fire_slash_single.png", "vfx_fire_slash_double.png",
            "vfx_fire_explosion.png", "vfx_ice_spikes.png",
            "vfx_ice_shards.png", "vfx_wind_tornado.png",
            "vfx_lightning_pillar.png", "vfx_arcane_circle.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "vfx_buff_dark_pack.png": {
        "grid": (3, 2),
        "dir": "vfx",
        "names": [
            "vfx_holy_shield.png", "vfx_ice_nova.png", "vfx_heal_aura.png",
            "vfx_lotus_bloom.png", "vfx_shadow_wolf.png", "vfx_dark_vortex.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "icons_status_buffs_pack.png": {
        "grid": (4, 2),
        "dir": "icons",
        "names": [
            "icon_buff_atk.png", "icon_buff_def.png", "icon_buff_hp.png", "icon_buff_heal.png",
            "icon_buff_spd.png", "icon_buff_crit.png", "icon_buff_star.png", "icon_buff_shield.png",
        ],
        "size": 96,
        "anchor": "center",
    },
    "icons_status_debuffs_pack.png": {
        "grid": (4, 2),
        "dir": "icons",
        "names": [
            "icon_debuff_burn.png", "icon_debuff_freeze.png", "icon_debuff_shock.png", "icon_debuff_poison.png",
            "icon_debuff_bleed.png", "icon_debuff_curse.png", "icon_debuff_mark.png", "icon_debuff_stun.png",
        ],
        "size": 96,
        "anchor": "center",
    },
    "icons_elements_pack.png": {
        "grid": (3, 2),
        "dir": "icons",
        "names": [
            "elem_fire.png", "elem_water.png", "elem_wind.png",
            "elem_earth.png", "elem_light.png", "elem_dark.png",
        ],
        "size": 96,
        "anchor": "center",
    },
    "items_equipment_pack.png": {
        "grid": (3, 2),
        "dir": "items",
        "names": [
            "equip_sword.png", "equip_armor.png", "equip_helmet.png",
            "equip_boots.png", "equip_ring.png", "equip_shield.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "items_loot_resources_pack.png": {
        "grid": (4, 2),
        "dir": "items",
        "names": [
            "item_gold_coin.png", "item_purple_gem.png", "item_hp_potion.png", "item_skill_scroll.png",
            "item_spellbook.png", "item_golden_key.png", "item_treasure_chest.png", "item_summon_ticket.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "ui_hud_nav_pack.png": {
        "grid": (3, 2),
        "dir": "ui",
        "names": [
            "ui_nav_heroes.png", "ui_nav_summon.png", "ui_nav_campaign.png",
            "ui_nav_tower.png", "ui_nav_events.png", "ui_nav_shop.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "ui_panels_buttons_pack.png": {
        "grid": (4, 2),
        "dir": "ui",
        "names": [
            "ui_avatar_frame.png", "ui_currency_bar.png", "ui_ribbon_red.png", "ui_parchment_panel.png",
            "ui_btn_gold.png", "ui_btn_red.png", "ui_btn_blue.png", "ui_utility_icons_strip.png",
        ],
        "size": 0,  # Save trimmed native proportional widgets
        "anchor": "center",
    },
    "ui_rank_emblems_pack.png": {
        "grid": (3, 2),
        "dir": "ui",
        "names": [
            "rank_bronze.png", "rank_silver.png", "rank_gold.png",
            "rank_platinum.png", "rank_diamond.png", "rank_legend.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "ui_class_tags_pack.png": {
        "grid": (3, 2),
        "dir": "ui",
        "names": [
            "class_tank.png", "class_warrior.png", "class_ranger.png",
            "class_mage.png", "class_support.png", "class_assassin.png",
        ],
        "size": 96,
        "anchor": "center",
    },
    "ui_campaign_battle_hud_pack.png": {
        "grid": (4, 2),
        "dir": "ui",
        "names": [
            "ui_pin_stage_active.png", "ui_pin_stage_normal.png",
            "ui_pin_stage_boss.png", "ui_btn_back.png",
            "ui_btn_speed_x2.png", "ui_btn_pause.png",
            "ui_battle_portrait_frame.png", "ui_battle_ult_ready_glow.png",
        ],
        "size": 128,
        "anchor": "center",
    },
    "ui_small_nav_icons_pack.png": {
        "grid": (4, 2),
        "dir": "ui",
        "names": [
            "ui_icon_mail.png", "ui_icon_quests.png",
            "ui_icon_events.png", "ui_icon_bag.png",
            "ui_icon_guild.png", "ui_icon_achieve.png",
            "ui_icon_settings.png", "ui_icon_idle_chest.png",
        ],
        "size": 96,
        "anchor": "center",
    },
    "knight_branch_evolution_pack.png": {
        "grid": (2, 1),
        "dir": "heroes",
        "names": [
            "knight_evo_fire.png", "knight_evo_holy.png",
        ],
        "size": 128,
        "anchor": "bottom-center",
        "hole_cells": {0, 1},
    },
    "ui_gacha_and_skill_icons_pack.png": {
        "grid": (4, 3),
        "dir": "ui",
        "names": [
            "ui_gacha_card_back.png", "ui_gacha_beam.png",
            "ui_evo_arrow.png", "ui_banner_victory.png",
            "ui_banner_defeat.png", "skill_icon_slash.png",
            "skill_icon_shield.png", "skill_icon_axe.png",
            "skill_icon_dagger.png", "skill_icon_arrow.png",
            "skill_icon_arcane.png", "skill_icon_heal.png",
        ],
        "size": 128,
        "anchor": "center",
    },
}


def resolve_canonical_name(filename: str) -> str:
    """Normalize batch-prefixed filenames like 01-output-file-inbox-knight-idle-png-asset-... to knight_idle.png."""
    m = re.match(r"^\d+-output-file-inbox-([a-z0-9-]+)-png-asset-", filename)
    if m:
        return m.group(1).replace("-", "_") + ".png"
    return filename


def _best_valley(density: np.ndarray, nom: int, win: int, limit: int) -> int:
    lo = max(1, nom - win)
    hi = min(limit - 1, nom + win)
    sub = density[lo:hi]
    if len(sub) == 0:
        return nom
    min_val = int(sub.min())
    indices = np.where(sub <= min_val + 1)[0]
    if len(indices) == 0:
        return nom
    splits = np.where(np.diff(indices) > 1)[0] + 1
    runs = np.split(indices, splits)
    best_run = max(runs, key=lambda r: (len(r), -abs((lo + int(r.mean())) - nom)))
    return lo + int(round(best_run.mean()))


def find_grid_cuts(arr: np.ndarray, cols: int, rows: int, per_row_cols: bool = False):
    h, w = arr.shape[:2]
    is_fg = (arr.min(axis=2) < 236) | ((arr.max(axis=2) - arr.min(axis=2)) > 20)
    row_density = is_fg.sum(axis=1)

    ys = [0]
    row_win = max(16, int(h / rows * 0.28))
    for r in range(1, rows):
        nom = int(round(r * h / rows))
        ys.append(_best_valley(row_density, nom, row_win, h))
    ys.append(h)

    col_win = max(16, int(w / cols * 0.28))
    if not per_row_cols:
        col_density = is_fg.sum(axis=0)
        xs = [0]
        for c in range(1, cols):
            nom = int(round(c * w / cols))
            xs.append(_best_valley(col_density, nom, col_win, w))
        xs.append(w)
        return [xs for _ in range(rows)], ys

    row_xs = []
    for r in range(rows):
        row_fg = is_fg[ys[r]:ys[r + 1], :]
        col_density = row_fg.sum(axis=0)
        xs = [0]
        for c in range(1, cols):
            nom = int(round(c * w / cols))
            xs.append(_best_valley(col_density, nom, col_win, w))
        xs.append(w)
        row_xs.append(xs)
    return row_xs, ys


def remove_background(cell_rgb: np.ndarray, canonical_name: str, force_holes: bool = False) -> np.ndarray:
    r = cell_rgb[:, :, 0].astype(np.int16)
    g = cell_rgb[:, :, 1].astype(np.int16)
    b = cell_rgb[:, :, 2].astype(np.int16)
    mx = np.maximum(np.maximum(r, g), b)
    mn = np.minimum(np.minimum(r, g), b)
    chroma = mx - mn

    if canonical_name in UI_PRESERVE_INTERIOR:
        bg_cand = (mn >= 240) & (chroma <= 16)
    else:
        bg_cand = (mn >= 237) & (chroma <= 18)

    struct4 = np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]], dtype=np.int32)
    lbl, _ = ndimage.label(bg_cand, structure=struct4)

    border_mask = np.zeros_like(bg_cand)
    border_mask[:2, :] = True
    border_mask[-2:, :] = True
    border_mask[:, :2] = True
    border_mask[:, -2:] = True
    border_labels = set(np.unique(lbl[border_mask])) - {0}
    bg = np.isin(lbl, list(border_labels))

    if force_holes or canonical_name in HOLE_BY_DARK_OUTLINE:
        pure = (mn >= 247) & (chroma <= 8)
        plbl, pn = ndimage.label(pure, structure=struct4)
        pborder = set(np.unique(plbl[border_mask])) - {0}
        counts = np.bincount(plbl.ravel())
        dark = mx < 145
        for i in range(1, pn + 1):
            if i not in pborder and counts[i] >= 80:
                comp = plbl == i
                ring = ndimage.binary_dilation(comp, iterations=2) & (~comp)
                if ring.sum() > 0 and (dark[ring].sum() / ring.sum()) >= 0.45:
                    bg |= comp

    alpha = np.where(bg, 0, 255).astype(np.uint8)
    edge = ndimage.binary_dilation(bg, iterations=1) & (~bg)
    neutral_edge = edge & (chroma <= 22) & (mn >= 205)
    if np.any(neutral_edge):
        mean_val = (r + g + b) / 3.0
        soft_a = np.clip((248.0 - mean_val) / 43.0 * 255.0, 0, 255).astype(np.uint8)
        alpha = np.where(neutral_edge, np.minimum(alpha, soft_a), alpha)

    return np.dstack([cell_rgb, alpha])


def trim_alpha_bbox(rgba: np.ndarray, alpha_thresh: int = 12):
    ys, xs = np.where(rgba[:, :, 3] > alpha_thresh)
    if len(xs) == 0 or len(ys) == 0:
        return None
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def body_bbox_from_ink(rgba: np.ndarray):
    """Bounding box of dark-ink character outlines, ignoring bright/cyan VFX and soft shadows."""
    dark_ink = (rgba[:, :, 3] > 200) & (rgba[:, :, :3].max(axis=2) < 95)
    ys, xs = np.where(dark_ink)
    if len(xs) < 25 or len(ys) < 25:
        return trim_alpha_bbox(rgba)
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def normalize_sheet(
    cells_rgba,
    cols: int,
    rows: int,
    cell_size: int,
    anchor: str = "bottom-center",
    max_content_ratio: float = 0.88,
    margin_bottom: int = 6,
    uniform_scale: bool = True,
    target_body_h: int = 0,
):
    bboxes = [trim_alpha_bbox(c) for c in cells_rgba]
    ink_bboxes = [body_bbox_from_ink(c) for c in cells_rgba]
    valid = [(i, b) for i, b in enumerate(bboxes) if b is not None]

    target = int(round(cell_size * max_content_ratio))
    global_scale = 1.0
    if valid and target_body_h > 0:
        valid_ink_hs = [
            ink_bboxes[i][3] - ink_bboxes[i][1]
            for i, _ in valid
            if ink_bboxes[i] is not None
        ]
        ref_body_h = float(np.median(valid_ink_hs)) if valid_ink_hs else float(target_body_h)
        global_scale = float(target_body_h) / max(1.0, ref_body_h)
        max_w = max(b[2] - b[0] for _, b in valid)
        max_h = max(b[3] - b[1] for _, b in valid)
        fit_cap = min((cell_size - 4) / max(1, max_w), (cell_size - margin_bottom - 4) / max(1, max_h))
        global_scale = min(global_scale, fit_cap)
    elif valid and uniform_scale:
        max_w = max(b[2] - b[0] for _, b in valid)
        max_h = max(b[3] - b[1] for _, b in valid)
        global_scale = min(target / max(1, max_w), target / max(1, max_h))

    sheet = Image.new("RGBA", (cols * cell_size, rows * cell_size), (0, 0, 0, 0))
    for idx, cell in enumerate(cells_rgba):
        canvas = Image.new("RGBA", (cell_size, cell_size), (0, 0, 0, 0))
        b = bboxes[idx]
        if b is not None:
            crop = Image.fromarray(cell[b[1]:b[3], b[0]:b[2]])
            cw, ch = crop.size
            sc = global_scale if (uniform_scale or target_body_h > 0) else min(target / max(1, cw), target / max(1, ch))
            nw = max(1, int(round(cw * sc)))
            nh = max(1, int(round(ch * sc)))
            resized = crop.resize((nw, nh), Image.Resampling.LANCZOS)
            ib = ink_bboxes[idx]
            if anchor == "bottom-center" and target_body_h > 0 and ib is not None:
                ink_cx = ((ib[0] + ib[2]) * 0.5 - b[0]) * sc
                ink_bot = (ib[3] - b[1]) * sc
                px = int(round(cell_size * 0.5 - ink_cx))
                py = int(round((cell_size - margin_bottom) - ink_bot))
                px = max(2, min(cell_size - nw - 2, px))
                py = max(2, min(cell_size - nh - 2, py))
            elif anchor == "bottom-center":
                px = (cell_size - nw) // 2
                py = cell_size - margin_bottom - nh
            else:
                px = (cell_size - nw) // 2
                py = (cell_size - nh) // 2
            canvas.paste(resized, (px, py), resized)
        col = idx % cols
        row = idx // cols
        sheet.paste(canvas, (col * cell_size, row * cell_size), canvas)
    return sheet


def extract_cells(
    img_arr: np.ndarray,
    cols: int,
    rows: int,
    canonical_name: str,
    per_row: bool = None,
    hole_cells: set = None,
):
    if per_row is None:
        per_row = canonical_name.endswith("_pack.png") or canonical_name.startswith(("items_", "icons_", "ui_", "heroes_"))
    row_xs, ys = find_grid_cuts(img_arr, cols, rows, per_row_cols=per_row)
    cells = []
    idx = 0
    for r in range(rows):
        xs = row_xs[r]
        for c in range(cols):
            sub = img_arr[ys[r]:ys[r + 1], xs[c]:xs[c + 1]]
            use_holes = bool(hole_cells and idx in hole_cells)
            cells.append(remove_background(sub, canonical_name, force_holes=use_holes))
            idx += 1
    return cells


def save_single_trimmed(rgba: np.ndarray, out_path: str, size: int = 0, anchor: str = "center"):
    b = trim_alpha_bbox(rgba)
    if b is None:
        Image.new("RGBA", (size or 64, size or 64), (0, 0, 0, 0)).save(out_path)
        return
    crop = Image.fromarray(rgba[b[1]:b[3], b[0]:b[2]])
    if size > 0:
        canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        target = int(round(size * 0.90))
        sc = min(target / max(1, crop.width), target / max(1, crop.height))
        nw, nh = max(1, int(round(crop.width * sc))), max(1, int(round(crop.height * sc)))
        resized = crop.resize((nw, nh), Image.Resampling.LANCZOS)
        px = (size - nw) // 2
        py = (size - nh - int(size * 0.04)) if anchor == "bottom-center" else (size - nh) // 2
        canvas.paste(resized, (px, py), resized)
        canvas.save(out_path)
    else:
        crop.save(out_path)


def save_proportional_trimmed(rgba: np.ndarray, out_path: str, target_height: int = 0, max_dim: int = 0):
    b = trim_alpha_bbox(rgba)
    if b is None:
        Image.new("RGBA", (64, target_height or 64), (0, 0, 0, 0)).save(out_path)
        return
    crop = Image.fromarray(rgba[b[1]:b[3], b[0]:b[2]])
    sc = 1.0
    if target_height > 0:
        sc = target_height / max(1, crop.height)
    elif max_dim > 0 and max(crop.width, crop.height) > max_dim:
        sc = max_dim / max(crop.width, crop.height)
    if abs(sc - 1.0) > 1e-3:
        nw = max(1, int(round(crop.width * sc)))
        nh = max(1, int(round(crop.height * sc)))
        crop = crop.resize((nw, nh), Image.Resampling.LANCZOS)
    crop.save(out_path)


def adapt_full_bleed_panels(img_arr: np.ndarray, out_names: list, panel_w: int = 1280, panel_h: int = 720):
    cols, rows = 2, 2
    row_xs, ys = find_grid_cuts(img_arr, cols, rows, per_row_cols=True)
    out_dir = os.path.join(SPRITES_DIR, "backgrounds")
    for r in range(rows):
        xs = row_xs[r]
        for c in range(cols):
            idx = r * cols + c
            if idx >= len(out_names):
                break
            sub = img_arr[ys[r]:ys[r + 1], xs[c]:xs[c + 1]]
            mx = sub.max(axis=2)
            mn = sub.min(axis=2)
            white_mask = (mn >= 242) & ((mx - mn) <= 14)

            sh, sw = sub.shape[:2]
            top = 0
            while top < sh - 10 and white_mask[top, :].mean() >= 0.78:
                top += 1
            bottom = sh
            while bottom > top + 10 and white_mask[bottom - 1, :].mean() >= 0.78:
                bottom -= 1
            left = 0
            while left < sw - 10 and white_mask[:, left].mean() >= 0.78:
                left += 1
            right = sw
            while right > left + 10 and white_mask[:, right - 1].mean() >= 0.78:
                right -= 1

            pad_x = 2 if (right - left) > 40 else 0
            pad_y = 2 if (bottom - top) > 40 else 0
            core = sub[top + pad_y:bottom - pad_y, left + pad_x:right - pad_x]
            rgba_core = np.dstack([core, np.full(core.shape[:2], 255, dtype=np.uint8)])
            panel_img = Image.fromarray(rgba_core).resize((panel_w, panel_h), Image.Resampling.LANCZOS)
            panel_img.save(os.path.join(out_dir, out_names[idx]))


def classify_anim_sheet(cname: str):
    """Detect <entity>_<anim>.png and return (sub_dir, cols, rows, cell_size, target_body_h, margin_bottom, anchor)."""
    m = re.match(r"^([a-z0-9_]+)_(idle|run|attack|skill|hit|death)\.png$", cname)
    if not m:
        return None
    entity, anim = m.group(1), m.group(2)
    cols, rows, anchor = ANIM_GRIDS[anim]
    if entity.startswith("boss_"):
        return ("bosses", cols, rows, 256, 164, 14, anchor)
    if entity in KNOWN_MOBS:
        return ("enemies", cols, rows, 192, 104, 12, anchor)
    return ("heroes", cols, rows, 192, 104, 12, anchor)


def process_file(raw_path: str, cname: str, dry_run: bool = False) -> bool:
    """Process one raw PNG sheet. Returns True if handled, False if unrecognized."""
    # 1. Standard pack lookup
    if cname in PACK_SPECS:
        spec = PACK_SPECS[cname]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/{spec['dir']}/ ({len(spec['names'])} files)")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cols, rows = spec["grid"]
        cells = extract_cells(img_arr, cols, rows, cname, hole_cells=spec.get("hole_cells"))
        out_dir = os.path.join(SPRITES_DIR, spec["dir"])
        for cell_rgba, out_name in zip(cells, spec["names"]):
            save_single_trimmed(
                cell_rgba,
                os.path.join(out_dir, out_name),
                size=spec["size"],
                anchor=spec["anchor"],
            )
        return True

    # 2. Dynamic hero evolution packs (<hero>_evolution_pack.png)
    evo_match = re.match(r"^([a-z0-9_]+)_evolution_pack\.png$", cname)
    if evo_match:
        hero = evo_match.group(1)
        out_names = [f"{hero}_evo_basic.png", f"{hero}_evo_advance.png", f"{hero}_evo_awaken.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/heroes/ ({', '.join(out_names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 3, 1, cname, hole_cells={0, 1, 2})
        out_dir = os.path.join(SPRITES_DIR, "heroes")
        for cell_rgba, out_name in zip(cells, out_names):
            save_single_trimmed(cell_rgba, os.path.join(out_dir, out_name), size=128, anchor="bottom-center")
        return True

    # 3. Battle backgrounds & UI scene backdrops (full-bleed)
    if cname == "bg_battle_vistas_pack.png":
        names = [
            "bg_plains_kingdom.png",
            "bg_desert_oasis.png",
            "bg_frozen_tundra.png",
            "bg_demon_castle.png",
        ]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/backgrounds/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        adapt_full_bleed_panels(img_arr, names, panel_w=1280, panel_h=720)
        return True

    if cname == "bg_ui_scenes_pack.png":
        names = [
            "bg_summon_portal.png",
            "bg_evolution_stage.png",
            "bg_hero_detail_starry.png",
            "bg_idle_rewards_stage.png",
        ]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/backgrounds/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        adapt_full_bleed_panels(img_arr, names, panel_w=1024, panel_h=1024)
        return True

    if cname in {"bg_lobby_town.png", "bg_campaign_map.png", "bg_title_splash.png"}:
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/backgrounds/{cname}")
            return True
        img = Image.open(raw_path).convert("RGBA")
        max_dim = 1280
        if max(img.width, img.height) > max_dim:
            sc = max_dim / max(img.width, img.height)
            img = img.resize((int(round(img.width * sc)), int(round(img.height * sc))), Image.Resampling.LANCZOS)
        img.save(os.path.join(SPRITES_DIR, "backgrounds", cname))
        return True

    # 4. Parallax prop strips
    if cname == "bg_parallax_props_pack.png":
        names = [
            "bg_plains_props.png",
            "bg_desert_props.png",
            "bg_tundra_props.png",
            "bg_demon_props.png",
        ]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/backgrounds/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 2, 2, cname, hole_cells={0, 1, 2, 3})
        out_dir = os.path.join(SPRITES_DIR, "backgrounds")
        for cell_rgba, out_name in zip(cells, names):
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=220)
        return True

    # 5. Hero Card Rarity Frames (proportional 3:4 cards)
    if cname == "ui_hero_cards_rarity_pack.png":
        names = ["card_frame_r.png", "card_frame_sr.png", "card_frame_ssr.png", "card_frame_ur.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/cards/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 2, 2, cname)
        out_dir = os.path.join(SPRITES_DIR, "cards")
        for cell_rgba, out_name in zip(cells, names):
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=256)
        return True

    # 6. Currency + Stars/Toggle split across items/ and ui/
    if cname == "ui_currency_stars_pack.png":
        targets = [
            ("items", "res_gold_pile.png", 128),
            ("items", "res_gem_cluster.png", 128),
            ("items", "res_mana_crystals.png", 128),
            ("ui", "ui_star_filled.png", 96),
            ("ui", "ui_star_empty.png", 96),
            ("ui", "ui_toggle_switch.png", 0),
        ]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> items/ & ui/ (6 assets)")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 3, 2, cname)
        for cell_rgba, (sub_dir, out_name, sz) in zip(cells, targets):
            save_single_trimmed(cell_rgba, os.path.join(SPRITES_DIR, sub_dir, out_name), size=sz, anchor="center")
        return True

    # 7. System Decor Props (mixed center vs bottom-center anchors)
    if cname == "decor_system_props_pack.png":
        specs = [
            ("decor_banner_red.png", 128, "center"),
            ("decor_banner_blue.png", 128, "center"),
            ("decor_banner_green.png", 128, "center"),
            ("decor_laurel_wreath.png", 128, "center"),
            ("decor_crown.png", 128, "center"),
            ("decor_hanging_lantern.png", 128, "center"),
            ("decor_torii_gate.png", 160, "bottom-center"),
            ("decor_sakura_tree.png", 160, "bottom-center"),
            ("decor_magic_crystal.png", 160, "bottom-center"),
            ("decor_stone_lantern.png", 128, "bottom-center"),
            ("decor_wood_fence.png", 128, "bottom-center"),
            ("decor_garden_cluster.png", 128, "bottom-center"),
        ]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/decor/ (12 assets)")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 4, 3, cname, hole_cells={3, 6, 7, 10})
        out_dir = os.path.join(SPRITES_DIR, "decor")
        for cell_rgba, (out_name, sz, anchor) in zip(cells, specs):
            save_single_trimmed(cell_rgba, os.path.join(out_dir, out_name), size=sz, anchor=anchor)
        return True

    # 8. Dynamic Hero / Mob / Boss Animation Sheets (<entity>_<anim>.png)
    anim_spec = classify_anim_sheet(cname)
    if anim_spec is not None:
        sub_dir, cols, rows, cell_size, target_body_h, margin_bottom, anchor = anim_spec
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/{sub_dir}/{cname} ({cols}x{rows} @ {cell_size}px, body={target_body_h}px)")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        hole_set = set(range(cols * rows))
        cells = extract_cells(img_arr, cols, rows, cname, per_row=True, hole_cells=hole_set)
        sheet = normalize_sheet(
            cells,
            cols,
            rows,
            cell_size,
            anchor=anchor,
            margin_bottom=margin_bottom,
            target_body_h=target_body_h,
        )
        sheet.save(os.path.join(SPRITES_DIR, sub_dir, cname))
        return True

    return False


def adapt_all(from_archive: bool = False, dry_run: bool = False):
    for sub in SPRITE_SUBDIRS:
        os.makedirs(os.path.join(SPRITES_DIR, sub), exist_ok=True)
    os.makedirs(ARCHIVE_DIR, exist_ok=True)

    src_dir = ARCHIVE_DIR if from_archive else INBOX_DIR
    raw_files = sorted(glob.glob(os.path.join(src_dir, "*.png")))
    print(f"Found {len(raw_files)} PNG file(s) in {'archive/' if from_archive else 'inbox/'}")

    adapted_count = 0
    for raw_path in raw_files:
        raw_name = os.path.basename(raw_path)
        cname = resolve_canonical_name(raw_name)
        handled = process_file(raw_path, cname, dry_run=dry_run)
        if not handled:
            print(f"WARNING: Unhandled file {raw_name} -> {cname}")
            continue

        if not from_archive and not dry_run:
            shutil.move(raw_path, os.path.join(ARCHIVE_DIR, raw_name))
        adapted_count += 1
        if not dry_run:
            print(f"Adapted [{adapted_count}/{len(raw_files)}]: {cname} (archived raw -> archive/{raw_name})")

    print(f"Done! {'Matched' if dry_run else 'Adapted'} {adapted_count} sheet(s).")


def main():
    parser = argparse.ArgumentParser(description="Adapt raw assets from inbox/ to assets/sprites/ and archive/.")
    parser.add_argument("--from-archive", action="store_true", help="Re-process raw PNGs from archive/")
    parser.add_argument("--dry-run", action="store_true", help="List detected assets without writing or moving files")
    args = parser.parse_args()
    adapt_all(from_archive=args.from_archive, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
