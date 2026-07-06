"""Deterministic HDR source pattern helpers for RenoDX analysis.

Keep source-domain metadata and stats beside generated patterns. Write EXR or
PQ PNG outputs through the repository's existing analysis helpers when possible.
"""

from __future__ import annotations

from pathlib import Path
import json

import numpy as np


def make_stop_ramp(width: int, height: int, min_stops: float = -8.0, max_stops: float = 4.0) -> np.ndarray:
    """Return a horizontal scene-linear RGB ramp in stops around diffuse white."""
    stops = np.linspace(min_stops, max_stops, width, dtype=np.float32)
    values = np.power(np.float32(2.0), stops).astype(np.float32)
    ramp = np.repeat(values[None, :, None], height, axis=0)
    return np.repeat(ramp, 3, axis=2)


def make_bt709_hue_sweep(width: int, height: int, value: float = 1.0) -> np.ndarray:
    """Return an HSV-style hue sweep in nominal BT.709/sRGB linear primaries."""
    hue = np.linspace(0.0, 1.0, width, endpoint=False, dtype=np.float32)
    h6 = hue * 6.0
    c = np.full_like(h6, value, dtype=np.float32)
    x = c * (1.0 - np.abs((h6 % 2.0) - 1.0))
    zeros = np.zeros_like(c)
    rgb = np.stack(
        [
            np.select([h6 < 1, h6 < 2, h6 < 3, h6 < 4, h6 < 5], [c, x, zeros, zeros, x], default=c),
            np.select([h6 < 1, h6 < 2, h6 < 3, h6 < 4, h6 < 5], [x, c, c, x, zeros], default=zeros),
            np.select([h6 < 1, h6 < 2, h6 < 3, h6 < 4, h6 < 5], [zeros, zeros, x, c, c], default=x),
        ],
        axis=1,
    )
    return np.repeat(rgb[None, :, :], height, axis=0).astype(np.float32)


def write_stats(path: str | Path, image: np.ndarray, metadata: dict[str, object]) -> None:
    arr = np.asarray(image)
    stats = {
        **metadata,
        "shape": list(arr.shape),
        "dtype": str(arr.dtype),
        "finite": bool(np.isfinite(arr).all()),
        "min": float(np.nanmin(arr)),
        "max": float(np.nanmax(arr)),
        "negative_channels": int(np.count_nonzero(arr < 0)),
        "over_one_channels": int(np.count_nonzero(arr > 1)),
    }
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(stats, indent=2) + "\n")