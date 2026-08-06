#!/usr/bin/env python3
"""Validate Detroit Build 12158144 before enabling its ultrawide hooks."""

from __future__ import annotations

import argparse
import hashlib
from dataclasses import dataclass
from pathlib import Path


EXPECTED_SHA256 = "ECF52321921387E683904E089082D76B973326FC093AF14E524056715519C1CF"
EXPECTED_SIZE = 57_986_328


@dataclass(frozen=True)
class Signature:
    name: str
    pattern: str
    expected_offset: int
    patch_offset: int
    original_bytes: bytes


SIGNATURES = (
    Signature(
        name="camera aspect getter context",
        pattern=(
            "F3 0F 10 05 3D 0C D4 01 C3 F3 0F 10 05 80 0C D4 01 "
            "C3 CC CC CC"
        ),
        expected_offset=0x15BB03,
        patch_offset=0x15BB0C,
        original_bytes=bytes.fromhex("F3 0F 10 05 80 0C D4 01"),
    ),
    Signature(
        name="Scaleform UI scale context",
        pattern=(
            "48 8B 03 48 8B CB FF 50 10 48 8B 03 48 8B CB "
            "F3 44 0F 10 35 3F B0 2D 01 44 0F 28 C0 F3 45 0F 59 C6"
        ),
        expected_offset=0xBC14F5,
        patch_offset=0xBC1504,
        original_bytes=bytes.fromhex("F3 44 0F 10 35 3F B0 2D 01"),
    ),
)


def parse_pattern(pattern: str) -> tuple[int | None, ...]:
    return tuple(None if token == "??" else int(token, 16) for token in pattern.split())


def find_matches(image: bytes, pattern: tuple[int | None, ...]) -> list[int]:
    if not pattern or len(pattern) > len(image):
        return []

    exact_runs: list[tuple[int, bytes]] = []
    run_start = 0
    while run_start < len(pattern):
        while run_start < len(pattern) and pattern[run_start] is None:
            run_start += 1
        run_end = run_start
        while run_end < len(pattern) and pattern[run_end] is not None:
            run_end += 1
        if run_end > run_start:
            exact_runs.append((run_start, bytes(pattern[run_start:run_end])))
        run_start = run_end

    if not exact_runs:
        return list(range(len(image) - len(pattern) + 1))

    anchor_offset, anchor = max(exact_runs, key=lambda item: len(item[1]))
    matches: list[int] = []
    search_from = 0
    while True:
        anchor_match = image.find(anchor, search_from)
        if anchor_match < 0:
            break
        candidate = anchor_match - anchor_offset
        if candidate >= 0 and candidate + len(pattern) <= len(image) and all(
            expected is None or image[candidate + index] == expected
            for index, expected in enumerate(pattern)
        ):
            matches.append(candidate)
        search_from = anchor_match + 1
    return matches


def validate(exe_path: Path) -> list[str]:
    image = exe_path.read_bytes()
    errors: list[str] = []
    if len(image) != EXPECTED_SIZE:
        errors.append(f"file size mismatch: expected {EXPECTED_SIZE}, got {len(image)}")
    actual_sha256 = hashlib.sha256(image).hexdigest().upper()
    if actual_sha256 != EXPECTED_SHA256:
        errors.append(f"SHA-256 mismatch: expected {EXPECTED_SHA256}, got {actual_sha256}")

    for signature in SIGNATURES:
        matches = find_matches(image, parse_pattern(signature.pattern))
        if matches != [signature.expected_offset]:
            formatted = ", ".join(f"0x{offset:X}" for offset in matches) or "none"
            errors.append(
                f"{signature.name} signature: expected exactly 0x{signature.expected_offset:X}, got {formatted}"
            )
        actual_bytes = image[
            signature.patch_offset : signature.patch_offset + len(signature.original_bytes)
        ]
        if actual_bytes != signature.original_bytes:
            errors.append(
                f"{signature.name} bytes at 0x{signature.patch_offset:X}: "
                f"expected {signature.original_bytes.hex(' ').upper()}, got {actual_bytes.hex(' ').upper()}"
            )

    constants = (
        ("vanilla 16:9 aspect", 0x1E9C194, bytes.fromhex("39 8E E3 3F")),
        ("vanilla UI scale", 0x1E9BF4C, bytes.fromhex("00 00 00 3F")),
    )
    for name, offset, expected in constants:
        actual = image[offset : offset + len(expected)]
        if actual != expected:
            errors.append(
                f"{name} at 0x{offset:X}: expected {expected.hex(' ').upper()}, got {actual.hex(' ').upper()}"
            )

    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--exe", required=True, type=Path)
    args = parser.parse_args()

    if not args.exe.is_file():
        parser.error(f"Detroit executable does not exist: {args.exe}")

    errors = validate(args.exe)
    if errors:
        for error in errors:
            print(f"FAIL: {error}")
        return 1

    print(f"PASS: {args.exe}")
    print(f"SHA-256: {EXPECTED_SHA256}")
    for signature in SIGNATURES:
        print(
            f"{signature.name}: signature=0x{signature.expected_offset:X}, "
            f"patch=0x{signature.patch_offset:X}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
