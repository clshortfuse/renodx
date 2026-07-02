"""Small BT.2020 PQ RGB16 PNG writer with a native cICP chunk.

Input arrays are absolute display nits in BT.2020 D65 RGB unless the caller has
already quantized to uint16 PQ. This template intentionally avoids Pillow paths
that often downcast or mishandle 16-bit RGB data.
"""

from __future__ import annotations

from pathlib import Path
import struct
import zlib

import numpy as np


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
PNG_CICP_BT2020_PQ_RGB_FULL = bytes([9, 16, 0, 1])


def pq_oetf_st2084(nits: np.ndarray, pq_max_nits: float = 10000.0) -> np.ndarray:
    """Encode absolute nits to normalized ST 2084 PQ code values."""
    m1 = 2610 / 16384
    m2 = 2523 / 32
    c1 = 3424 / 4096
    c2 = 2413 / 128
    c3 = 2392 / 128

    normalized = np.clip(np.asarray(nits, dtype=np.float64), 0.0, pq_max_nits) / pq_max_nits
    powered = np.power(normalized, m1)
    return np.power((c1 + c2 * powered) / (1 + c3 * powered), m2)


def quantize_pq_rgb16(nits_rgb: np.ndarray) -> np.ndarray:
    """Convert absolute BT.2020 RGB nits to big-endian uint16 PQ samples."""
    pq = np.clip(pq_oetf_st2084(nits_rgb), 0.0, 1.0)
    return np.rint(pq * 65535.0).astype(">u2")


def png_chunk(kind: bytes, data: bytes) -> bytes:
    return (
        struct.pack(">I", len(data))
        + kind
        + data
        + struct.pack(">I", zlib.crc32(kind + data) & 0xFFFFFFFF)
    )


def write_rgb16_png_with_cicp(path: str | Path, rgb16: np.ndarray) -> None:
    """Write an RGB16 PNG with cICP=(9,16,0,full)."""
    arr = np.asarray(rgb16)
    if arr.ndim != 3 or arr.shape[2] != 3:
        raise ValueError("Expected an array shaped (height, width, 3).")
    if arr.dtype != np.dtype(">u2"):
        arr = arr.astype(">u2")

    height, width, _ = arr.shape
    ihdr = struct.pack(">IIBBBBB", width, height, 16, 2, 0, 0, 0)
    raw_rows = bytearray()
    for row in arr:
        raw_rows.append(0)  # PNG filter type 0.
        raw_rows.extend(row.tobytes())

    png = b"".join(
        [
            PNG_SIGNATURE,
            png_chunk(b"IHDR", ihdr),
            png_chunk(b"cICP", PNG_CICP_BT2020_PQ_RGB_FULL),
            png_chunk(b"IDAT", zlib.compress(bytes(raw_rows), level=9)),
            png_chunk(b"IEND", b""),
        ]
    )

    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png)


def write_bt2020_pq_png(path: str | Path, bt2020_rgb_nits: np.ndarray) -> None:
    write_rgb16_png_with_cicp(path, quantize_pq_rgb16(bt2020_rgb_nits))