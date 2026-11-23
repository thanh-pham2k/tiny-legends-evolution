#!/usr/bin/env python3
"""Measure estimated torso/feet drift in sheet pixels and height changes across clips."""
import argparse
import json
from pathlib import Path

import numpy as np
from PIL import Image

from adapt_assets import SPRITES_DIR, body_landmarks, classify_anim_sheet


def audit(root: Path) -> dict:
    sheets = {}
    heights = {}
    for category in ("heroes", "enemies", "bosses"):
        for path in sorted((root / category).glob("*.png")):
            spec = classify_anim_sheet(path.name)
            if spec is None:
                continue
            unit, state = path.stem.rsplit("_", 1)
            _, cols, rows, *_ = spec
            image = Image.open(path).convert("RGBA")
            if image.width % cols or image.height % rows:
                raise ValueError(f"{path}: dimensions do not match {cols}x{rows} grid")
            w, h = image.width // cols, image.height // rows
            points = []
            border_pixels = []
            for index in range(cols * rows):
                x, y = index % cols * w, index // cols * h
                frame = np.array(image.crop((x, y, x + w, y + h)))
                body = body_landmarks(frame)
                if body is None:
                    raise ValueError(f"{path}: empty frame {index + 1}")
                points.append(body)
                opaque = frame[..., 3] > 12
                border_pixels.append(int(opaque[0].sum() + opaque[-1].sum()
                                         + opaque[1:-1, 0].sum() + opaque[1:-1, -1].sum()))
            values = np.array(points)
            sequence = np.vstack([values, values[0]]) if state in ("idle", "run") else values
            steps = np.diff(sequence[:, :4], axis=0)
            height = float(np.median(values[:, 5]))
            sheets[f"{category}/{path.stem}"] = {
                "cell_px": [w, h],
                "border_pixels_per_frame": border_pixels,
                "frames": [
                    dict(zip(("torso_x", "torso_y", "feet_x", "feet_y", "sole_y", "body_height"), body))
                    for body in points
                ],
                "steps_xy_px": steps.tolist(),
                "rms_step_torso_feet_px": np.round(np.sqrt(np.mean(steps ** 2, axis=0)), 2).tolist(),
                "median_height_px": height,
            }
            if state in ("idle", "run", "attack", "skill"):
                heights.setdefault(unit, {})[state] = height
    comparisons = {
        unit: {"median_height_by_clip_px": states, "spread_px": max(states.values()) - min(states.values())}
        for unit, states in heights.items()
    }
    return {"sheets": sheets, "height_by_unit": comparisons}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(SPRITES_DIR))
    args = parser.parse_args()
    print(json.dumps(audit(args.root), indent=2))


if __name__ == "__main__":
    main()
