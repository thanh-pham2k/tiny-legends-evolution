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
    "town",
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
    "hero_standees_pack_1.png",
    "hero_standees_pack_2.png",
    "town_decor_trees_pack.png",
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
    "town_bg_mid_horizon.png",
    "town_buildings_core_pack.png",
    "town_npc_and_ui_pack.png",
    "ui_showcase_frames_pack.png",
    "gacha_summon_vfx_sheet.png",
}

STANDEE_HOLE_SEEDS = {
    "archer_standee.png": [(0.711, 0.300), (0.739, 0.611), (0.672, 0.727)],
    "paladin_standee.png": [(0.657, 0.553)],
    "druid_standee.png": [(0.663, 0.579)],
}

ANIM_GRIDS = {
    "idle": (2, 2),
    "run": (3, 2),
    "attack": (3, 2),
    "skill": (3, 2),
    "hit": (3, 1),
    "death": (2, 2),
}

GROUND_MARGIN = 48

# Archive cels whose weapon, wing or spell dominates the density estimate.
# Coordinates are measured in the sliced master: torso x, head y, foot y, ground y.
# An airborne foot can sit above the ground pivot.
ARCHIVE_LANDMARKS = {
    "009-output-file-inbox-knight-skill-png-asset-knight-heroic-wave-.png": {
        0: (226, 143, 475, 475), 1: (303, 65, 411, 462),
        2: (267, 128, 455, 455), 3: (183, 88, 398, 398),
        4: (268, 89, 391, 402), 5: (247, 64, 413, 413),
    },
    "003-output-file-inbox-paladin-skill-png-asset-paladin-aegis-holy.png": {
        2: (208, 146, 466, 466), 3: (186, 117, 414, 414),
        4: (214, 112, 421, 421),
    },
    "005-output-file-inbox-berserker-attack-png-asset-berserker-heavy.png": {
        1: (284, 106, 434, 434), 3: (204, 134, 414, 425),
        4: (175, 116, 430, 430),
    },
    "031-output-file-inbox-boss-ice-dragon-attack-png-asset-boss-fros.png": {
        0: (217, 75, 441, 441), 1: (206, 63, 441, 441),
        2: (245, 84, 441, 441), 3: (253, 63, 397, 397),
        4: (205, 59, 410, 410), 5: (205, 60, 418, 418),
    },
    "032-output-file-inbox-boss-ice-dragon-skill-png-asset-boss-frost.png": {
        0: (205, 86, 442, 442), 1: (227, 60, 440, 440),
        2: (227, 56, 436, 436), 3: (300, 60, 436, 436),
        4: (232, 61, 428, 428), 5: (172, 72, 432, 432),
    },
    "030-output-file-inbox-boss-ice-dragon-idle-png-asset-boss-frost-.png": {
        0: (255, 76, 537, 537), 1: (246, 70, 552, 552),
        2: (215, 84, 580, 580), 3: (285, 119, 579, 579),
    },
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


def weighted_quantile(weights: np.ndarray, fraction: float) -> int:
    return int(np.searchsorted(np.cumsum(weights), weights.sum() * fraction))


def body_landmarks(rgba: np.ndarray):
    """Estimate torso center, foot centroid, sole line and head-to-sole height.

    Interior thickness downweights thin blades, contour strokes, and detached
    sparks. Use the lower columns under the torso to locate supporting feet.
    """
    bbox = trim_alpha_bbox(rgba)
    if bbox is None:
        return None
    x0, y0, x1, y1 = bbox
    opaque = rgba[y0:y1, x0:x1, 3] > 160
    depth = ndimage.distance_transform_edt(np.pad(opaque, 1))[1:-1, 1:-1]
    if not depth.any():
        depth = (rgba[y0:y1, x0:x1, 3] > 12).astype(float)
    mass = depth ** 1.7
    rows = mass.sum(axis=1)
    upper, lower = (weighted_quantile(rows, q) for q in (0.02, 0.98))
    span = max(1, lower - upper)
    band_top = upper + round(0.27 * span)
    band_end = max(band_top + 1, upper + round(0.68 * span))
    torso = mass[band_top:band_end]
    x = weighted_quantile(torso.sum(axis=0), 0.5)
    y = band_top + weighted_quantile(torso.sum(axis=1), 0.5)

    xlo = max(0, x - round(span * 0.46))
    xhi = x + round(span * 0.46) + 1
    foot_start = min(depth.shape[0] - 1, upper + round(span * 0.78))
    feet = depth[foot_start:, xlo:xhi] ** 1.15
    if not feet.any():
        xlo = 0
        feet = depth[foot_start:]
    foot_x = xlo + weighted_quantile(feet.sum(axis=0), 0.5)
    foot_y = foot_start + weighted_quantile(feet.sum(axis=1), 0.5)
    sole = min(y1 - y0, foot_start + weighted_quantile(feet.sum(axis=1), 0.98) + 2)
    head = max(0, upper - max(1, round(span * 0.075)))
    return x + x0, y + y0, foot_x + x0, foot_y + y0, sole + y0, max(1, sole - head)


def normalize_sheet(cells_rgba, cols, rows, cell_size, target_body_h, animation, authored):
    frames = []
    landmarks = [body_landmarks(cell) for cell in cells_rgba]
    sizes = [body[5] for body in landmarks if body is not None]
    if not sizes:
        raise ValueError("Animation sheet contains no visible frame")
    # Preserve the falling pose's change in height and the hit pose's recoil.
    fixed_scale = target_body_h / sizes[0] if animation in ("death", "hit") else None
    half_width = cell_size // 2
    above_ground = cell_size - 12
    for index, (cell, body) in enumerate(zip(cells_rgba, landmarks)):
        if body is None:
            raise ValueError("Animation sheet contains an empty frame")
        x0, y0, x1, y1 = trim_alpha_bbox(cell, alpha_thresh=0)
        torso_x, _, _, _, sole, height = body
        if index in authored:
            torso_x, head_y, foot_y, sole = authored[index]
            height = foot_y - head_y
        scale = fixed_scale if fixed_scale is not None else target_body_h / height
        crop = Image.fromarray(cell[y0:y1, x0:x1])
        width = max(1, round(crop.width * scale))
        height = max(1, round(crop.height * scale))
        frame = crop.resize((width, height), Image.Resampling.LANCZOS)
        left = round((x0 - torso_x) * width / crop.width)
        top = round((y0 - sole) * height / crop.height)
        half_width = max(half_width, 3 - left, 3 + width + left)
        above_ground = max(above_ground, 3 - top)
        frames.append((frame, left, top))

    # Extra horizontal and overhead space preserves the authored VFX. The
    # ground margin is part of the runtime sprite-origin contract.
    cell_w = half_width * 2
    cell_h = above_ground + GROUND_MARGIN
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h))
    for index, (frame, left, top) in enumerate(frames):
        if top + frame.height >= GROUND_MARGIN:
            raise ValueError(f"Frame {index + 1} extends below its reserved ground margin")
        sheet.paste(frame, (index % cols * cell_w + half_width + left,
                            index // cols * cell_h + above_ground + top))
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


def clear_enclosed_seeds(rgba: np.ndarray, seeds: list) -> np.ndarray:
    """Flood-fill remove enclosed white background regions starting from normalized (fx, fy) seeds."""
    rgb = rgba[:, :, :3]
    alpha = rgba[:, :, 3].copy()
    r = rgb[:, :, 0].astype(np.int16)
    g = rgb[:, :, 1].astype(np.int16)
    b = rgb[:, :, 2].astype(np.int16)
    mx = np.maximum(np.maximum(r, g), b)
    mn = np.minimum(np.minimum(r, g), b)
    chroma = mx - mn
    bg_cand = (mn >= 238) & (chroma <= 18)
    struct4 = np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]], dtype=np.int32)
    lbl, _ = ndimage.label(bg_cand, structure=struct4)
    h, w = alpha.shape
    seed_labels = set()
    for fx, fy in seeds:
        sx = min(w - 1, max(0, int(round(fx * w))))
        sy = min(h - 1, max(0, int(round(fy * h))))
        lab = int(lbl[sy, sx])
        if lab > 0:
            seed_labels.add(lab)
    if seed_labels:
        clear_mask = np.isin(lbl, list(seed_labels))
        alpha[clear_mask] = 0
        edge = ndimage.binary_dilation(clear_mask, iterations=1) & (~clear_mask)
        neutral_edge = edge & (chroma <= 22) & (mn >= 205)
        if np.any(neutral_edge):
            mean_val = (r + g + b) / 3.0
            soft_a = np.clip((248.0 - mean_val) / 43.0 * 255.0, 0, 255).astype(np.uint8)
            alpha = np.where(neutral_edge, np.minimum(alpha, soft_a), alpha)
    out = rgba.copy()
    out[:, :, 3] = alpha
    return out


def adapt_full_bleed_panels(
    img_arr: np.ndarray,
    out_names: list,
    panel_w: int = 1280,
    panel_h: int = 720,
    cols: int = 2,
    rows: int = 2,
    out_sub: str = "backgrounds",
    extra_pad: int = 2,
):
    row_xs, ys = find_grid_cuts(img_arr, cols, rows, per_row_cols=True)
    out_dir = os.path.join(SPRITES_DIR, out_sub)
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

            pad_x = extra_pad if (right - left) > 40 else 0
            pad_y = extra_pad if (bottom - top) > 40 else 0
            core = sub[top + pad_y:bottom - pad_y, left + pad_x:right - pad_x]
            rgba_core = np.dstack([core, np.full(core.shape[:2], 255, dtype=np.uint8)])
            panel_img = Image.fromarray(rgba_core).resize((panel_w, panel_h), Image.Resampling.LANCZOS)
            panel_img.save(os.path.join(out_dir, out_names[idx]))


def classify_anim_sheet(cname: str):
    """Detect <entity>_<anim>.png and return (sub_dir, cols, rows, cell_size, target_body_h)."""
    m = re.match(r"^([a-z0-9_]+)_(idle|run|attack|skill|hit|death)\.png$", cname)
    if not m:
        return None
    entity, anim = m.group(1), m.group(2)
    cols, rows = ANIM_GRIDS[anim]
    if entity.startswith("boss_"):
        return ("bosses", cols, rows, 256, 164)
    if entity in KNOWN_MOBS:
        return ("enemies", cols, rows, 192, 104)
    return ("heroes", cols, rows, 192, 104)


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
        sub_dir, cols, rows, cell_size, target_body_h = anim_spec
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/{sub_dir}/{cname} ({cols}x{rows} @ {cell_size}px, body={target_body_h}px)")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        hole_set = set(range(cols * rows))
        cells = extract_cells(img_arr, cols, rows, cname, per_row=True, hole_cells=hole_set)
        try:
            authored = ARCHIVE_LANDMARKS.get(os.path.basename(raw_path), {})
            sheet = normalize_sheet(cells, cols, rows, cell_size, target_body_h,
                                    cname.rsplit("_", 1)[1][:-4], authored)
        except ValueError as exc:
            raise ValueError(f"{cname}: {exc}") from exc
        sheet.save(os.path.join(SPRITES_DIR, sub_dir, cname))
        return True

    # 9. Fantasy Town World Map, Showcase Upgrade & Gacha Pack (001-016)
    if cname in {"town_bg_sky_far.png", "gacha_summon_banner.png", "gacha_result_bg.png"}:
        sub = "town" if cname.startswith("town_") else "backgrounds"
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/{sub}/{cname}")
            return True
        img = Image.open(raw_path).convert("RGBA")
        max_dim = 1440
        if max(img.width, img.height) > max_dim:
            sc = max_dim / max(img.width, img.height)
            img = img.resize((int(round(img.width * sc)), int(round(img.height * sc))), Image.Resampling.LANCZOS)
        img.save(os.path.join(SPRITES_DIR, sub, cname))
        return True

    if cname == "town_bg_mid_horizon.png":
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/town/{cname}")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        rgba = remove_background(img_arr, cname, force_holes=False)
        b = trim_alpha_bbox(rgba)
        if b is not None:
            # Crop top & bottom white margins while preserving seamless full horizontal width
            rgba = rgba[b[1]:b[3], :, :]
        out_img = Image.fromarray(rgba)
        if out_img.width > 1600:
            sc = 1600.0 / out_img.width
            out_img = out_img.resize((1600, max(1, int(round(out_img.height * sc)))), Image.Resampling.LANCZOS)
        out_img.save(os.path.join(SPRITES_DIR, "town", cname))
        return True

    if cname == "town_ground_tiles_pack.png":
        names = ["town_ground_plaza.png", "town_ground_sakura.png", "town_ground_road.png", "town_ground_transition.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/town/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        adapt_full_bleed_panels(img_arr, names, panel_w=512, panel_h=512, cols=2, rows=2, out_sub="town", extra_pad=4)
        return True

    if cname == "town_buildings_core_pack.png":
        names = ["town_building_summon.png", "town_building_heroes.png", "town_building_arena.png", "town_building_treasury.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/town/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 2, 2, cname)
        out_dir = os.path.join(SPRITES_DIR, "town")
        for cell_rgba, out_name in zip(cells, names):
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=420)
        return True

    if cname == "town_landmarks_pack.png":
        names = ["town_landmark_fountain.png", "town_landmark_gate.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/town/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 2, 1, cname, hole_cells={1})
        # Clear enclosed archway gap inside Eastern Gate
        cells[1] = clear_enclosed_seeds(cells[1], [(0.50, 0.56)])
        out_dir = os.path.join(SPRITES_DIR, "town")
        for cell_rgba, out_name in zip(cells, names):
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=420)
        return True

    if cname == "town_decor_trees_pack.png":
        names = ["town_tree_sakura_large.png", "town_tree_sakura_weeping.png", "town_tree_maple.png", "town_bush_bamboo.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/town/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 2, 2, cname, hole_cells={0, 1, 2, 3})
        out_dir = os.path.join(SPRITES_DIR, "town")
        for cell_rgba, out_name in zip(cells, names):
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=340)
        return True

    if cname == "town_decor_props_pack.png":
        names = ["town_prop_lantern.png", "town_prop_stall.png", "town_prop_signpost.png",
                 "town_prop_bench.png", "town_prop_barrels.png", "town_prop_stairs.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/town/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 3, 2, cname, per_row=False, hole_cells={1, 2})
        out_dir = os.path.join(SPRITES_DIR, "town")
        for cell_rgba, out_name in zip(cells, names):
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=220)
        return True

    if cname == "town_npc_and_ui_pack.png":
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/town/ & ui/ (7 assets)")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        row_xs, ys = find_grid_cuts(img_arr, 3, 2, per_row_cols=True)
        town_dir = os.path.join(SPRITES_DIR, "town")
        ui_dir = os.path.join(SPRITES_DIR, "ui")
        row1_names = ["town_npc_merchant.png", "town_pet_cat.png", "town_pet_fox.png"]
        for c, out_name in enumerate(row1_names):
            sub = img_arr[ys[0]:ys[1], row_xs[0][c]:row_xs[0][c + 1]]
            rgba = remove_background(sub, cname, force_holes=(c == 0))
            save_proportional_trimmed(rgba, os.path.join(town_dir, out_name), target_height=220)
        for c, out_name in enumerate(["ui_town_nameplate.png", "ui_town_district_tab.png"]):
            sub = img_arr[ys[1]:ys[2], row_xs[1][c]:row_xs[1][c + 1]]
            rgba = remove_background(sub, cname, force_holes=False)
            save_proportional_trimmed(rgba, os.path.join(ui_dir, out_name), target_height=110)
        # Split Row 2 Col 3 horizontally into Arrow Right + Interact Pin
        r2c2 = img_arr[ys[1]:ys[2], row_xs[1][2]:row_xs[1][3]]
        sub_xs, _ = find_grid_cuts(r2c2, 2, 1, per_row_cols=False)
        for idx, out_name in enumerate(["ui_town_arrow_right.png", "ui_town_interact_pin.png"]):
            part = r2c2[:, sub_xs[0][idx]:sub_xs[0][idx + 1]]
            rgba = remove_background(part, cname, force_holes=False)
            save_proportional_trimmed(rgba, os.path.join(ui_dir, out_name), target_height=96)
        return True

    if cname == "ui_showcase_frames_pack.png":
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/ui/ (6 assets)")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        row_xs, ys = find_grid_cuts(img_arr, 2, 2, per_row_cols=True)
        ui_dir = os.path.join(SPRITES_DIR, "ui")
        # Top-Left: ornate 9-slice panel frame; Top-Right: header banner; Bottom-Left: green button
        tl = remove_background(img_arr[ys[0]:ys[1], row_xs[0][0]:row_xs[0][1]], cname, force_holes=False)
        save_proportional_trimmed(tl, os.path.join(ui_dir, "ui_showcase_panel_frame.png"), target_height=380)
        tr = remove_background(img_arr[ys[0]:ys[1], row_xs[0][1]:row_xs[0][2]], cname, force_holes=False)
        save_proportional_trimmed(tr, os.path.join(ui_dir, "ui_showcase_header_banner.png"), target_height=160)
        bl = remove_background(img_arr[ys[1]:ys[2], row_xs[1][0]:row_xs[1][1]], cname, force_holes=False)
        save_proportional_trimmed(bl, os.path.join(ui_dir, "ui_btn_green.png"), target_height=140)
        # Bottom-Right: left = 2 vertical dividers, right = hollow glowing selection frame
        br = img_arr[ys[1]:ys[2], row_xs[1][1]:row_xs[1][2]]
        br_xs, _ = find_grid_cuts(br, 2, 1, per_row_cols=False)
        # Search for wider gap before selection frame (~60% across br)
        is_fg_br = (br.min(axis=2) < 236) | ((br.max(axis=2) - br.min(axis=2)) > 20)
        col_den = is_fg_br.sum(axis=0)
        split_x = _best_valley(col_den, int(br.shape[1] * 0.62), int(br.shape[1] * 0.18), br.shape[1])
        div_strip = br[:, :split_x]
        _, div_ys = find_grid_cuts(div_strip, 1, 2, per_row_cols=False)
        for r_idx, out_name in enumerate(["ui_divider_gem.png", "ui_divider_flower.png"]):
            d_part = remove_background(div_strip[div_ys[r_idx]:div_ys[r_idx + 1], :], cname, force_holes=False)
            save_proportional_trimmed(d_part, os.path.join(ui_dir, out_name), target_height=48)
        sel_raw = remove_background(br[:, split_x:], cname, force_holes=False)
        sel_b = trim_alpha_bbox(sel_raw)
        if sel_b is not None:
            sel_crop = sel_raw[sel_b[1]:sel_b[3], sel_b[0]:sel_b[2]]
            sel_crop = clear_enclosed_seeds(sel_crop, [(0.50, 0.50)])
            save_proportional_trimmed(sel_crop, os.path.join(ui_dir, "ui_selection_glow_frame.png"), target_height=220)
        return True

    if cname == "showcase_pedestals_pack.png":
        names = ["showcase_pedestal_light.png", "showcase_pedestal_fire.png", "showcase_pedestal_water.png", "showcase_pedestal_dark.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/ui/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 2, 2, cname, hole_cells={0, 3})
        cells[0] = clear_enclosed_seeds(cells[0], [(0.50, 0.24)])
        cells[3] = clear_enclosed_seeds(cells[3], [(0.50, 0.26)])
        out_dir = os.path.join(SPRITES_DIR, "ui")
        for cell_rgba, out_name in zip(cells, names):
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=340)
        return True

    if cname == "bg_showcase_elements_pack.png":
        names = [
            "bg_showcase_fire.png", "bg_showcase_water.png", "bg_showcase_wind.png",
            "bg_showcase_earth.png", "bg_showcase_light.png", "bg_showcase_dark.png",
        ]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/backgrounds/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        adapt_full_bleed_panels(img_arr, names, panel_w=800, panel_h=640, cols=3, rows=2, out_sub="backgrounds", extra_pad=4)
        return True

    if cname in {"hero_standees_pack_1.png", "hero_standees_pack_2.png"}:
        names = [
            "knight_standee.png", "paladin_standee.png", "berserker_standee.png",
            "assassin_standee.png", "archer_standee.png", "sniper_standee.png",
        ] if cname == "hero_standees_pack_1.png" else [
            "mage_standee.png", "enchanter_standee.png", "priest_standee.png",
            "druid_standee.png", "samurai_standee.png", "ninja_standee.png",
        ]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/heroes/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 3, 2, cname, per_row=False, hole_cells={0, 1, 2, 3, 4, 5})
        out_dir = os.path.join(SPRITES_DIR, "heroes")
        for cell_rgba, out_name in zip(cells, names):
            # Remove tiny disconnected edge specks (e.g. neighbor cape tip creeping across cell boundary)
            fg = cell_rgba[:, :, 3] > 20
            lbl, n = ndimage.label(fg)
            if n > 1:
                counts = np.bincount(lbl.ravel())
                counts[0] = 0
                main_count = counts.max()
                keep = np.isin(lbl, np.where(counts >= max(120, main_count * 0.01))[0])
                cell_rgba = cell_rgba.copy()
                cell_rgba[~keep, 3] = 0
            seeds = STANDEE_HOLE_SEEDS.get(out_name)
            if seeds:
                b = trim_alpha_bbox(cell_rgba)
                if b is not None:
                    trimmed = cell_rgba[b[1]:b[3], b[0]:b[2]]
                    cell_rgba = clear_enclosed_seeds(trimmed, seeds)
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=512)
        return True

    if cname == "gacha_summon_vfx_sheet.png":
        names = ["vfx_gacha_ssr_ring.png", "vfx_gacha_ur_starburst.png", "vfx_gacha_seal.png", "vfx_gacha_pillar.png"]
        if dry_run:
            print(f"  [DRY-RUN] {cname} -> assets/sprites/vfx/ ({', '.join(names)})")
            return True
        img_arr = np.array(Image.open(raw_path).convert("RGB"))
        cells = extract_cells(img_arr, 2, 2, cname, per_row=False)
        # Clear hollow white center of Golden SSR Burst Ring (cell 0)
        b0 = trim_alpha_bbox(cells[0])
        if b0 is not None:
            c0 = cells[0][b0[1]:b0[3], b0[0]:b0[2]]
            cells[0] = clear_enclosed_seeds(c0, [(0.50, 0.50)])
        # Fill any narrow glow-ray leak inside the core of UR starburst (cell 1)
        b1 = trim_alpha_bbox(cells[1])
        if b1 is not None:
            c1 = cells[1][b1[1]:b1[3], b1[0]:b1[2]].copy()
            ch, cw = c1.shape[:2]
            yy, xx = np.ogrid[:ch, :cw]
            inner_disc = ((xx - cw * 0.5) ** 2 + (yy - ch * 0.5) ** 2) <= (min(cw, ch) * 0.30) ** 2
            leak = inner_disc & (c1[:, :, 3] < 255)
            c1[leak, 3] = 255
            cells[1] = c1
        out_dir = os.path.join(SPRITES_DIR, "vfx")
        for cell_rgba, out_name in zip(cells, names):
            save_proportional_trimmed(cell_rgba, os.path.join(out_dir, out_name), target_height=384)
        return True

    return False


def adapt_all(from_archive: bool = False, dry_run: bool = False, animations_only: bool = False):
    for sub in SPRITE_SUBDIRS:
        os.makedirs(os.path.join(SPRITES_DIR, sub), exist_ok=True)
    os.makedirs(ARCHIVE_DIR, exist_ok=True)

    src_dir = ARCHIVE_DIR if from_archive else INBOX_DIR
    raw_files = sorted(glob.glob(os.path.join(src_dir, "*.png")))
    # Prefer the current batch art for animation master duplicates. The older
    # unprefixed Knight masters use a different design from hit/death.
    if from_archive:
        batch_anims = set()
        for path in raw_files:
            raw_name = os.path.basename(path)
            canonical = resolve_canonical_name(raw_name)
            if canonical != raw_name and classify_anim_sheet(canonical):
                batch_anims.add(canonical)
        raw_files = [path for path in raw_files if os.path.basename(path) not in batch_anims]
    if animations_only:
        raw_files = [path for path in raw_files if classify_anim_sheet(
            resolve_canonical_name(os.path.basename(path)))]
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
    parser.add_argument("--animations-only", action="store_true", help="Skip packs and non-animation sprites")
    args = parser.parse_args()
    adapt_all(from_archive=args.from_archive, dry_run=args.dry_run, animations_only=args.animations_only)


if __name__ == "__main__":
    main()
