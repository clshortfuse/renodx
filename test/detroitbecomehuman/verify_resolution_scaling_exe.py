#!/usr/bin/env python3
"""Validate the exact Detroit render-dimension hook contract."""

from __future__ import annotations

import argparse
import hashlib
from dataclasses import dataclass
from pathlib import Path


EXPECTED_SHA256 = "ECF52321921387E683904E089082D76B973326FC093AF14E524056715519C1CF"
EXPECTED_SIZE = 57_986_328


@dataclass(frozen=True)
class CodeSlice:
    name: str
    file_offset: int
    expected: bytes


CODE_SLICES = (
    CodeSlice(
        "runtime dimension update prologue",
        0x1504B0,
        bytes.fromhex(
            "40 56 48 83 EC 40 0F B7 41 1A 48 8B F1 0F B6 0D 52 63 8C 02 A8 02"
        ),
    ),
    CodeSlice(
        "serialized scale consumer",
        0x1506FE,
        bytes.fromhex("F3 0F 10 8E 08 16 00 00"),
    ),
    CodeSlice(
        "derived dimensions and renderer stores",
        0x150721,
        bytes.fromhex(
            "48 8B 05 F8 EF 8B 02 89 96 D4 11 00 00 F3 0F 59 C1 "
            "F3 0F 2C C8 89 8E D8 11 00 00 89 90 8C 15 00 00 "
            "89 88 90 15 00 00"
        ),
    ),
    CodeSlice(
        "per-frame exact update call site",
        0x1914A5,
        bytes.fromhex("48 8B 0D AC E2 87 02 E8 FF EF FB FF"),
    ),
)


def validate(exe_path: Path) -> list[str]:
    image = exe_path.read_bytes()
    errors: list[str] = []
    if len(image) != EXPECTED_SIZE:
        errors.append(f"file size mismatch: expected {EXPECTED_SIZE}, got {len(image)}")
    actual_sha256 = hashlib.sha256(image).hexdigest().upper()
    if actual_sha256 != EXPECTED_SHA256:
        errors.append(f"SHA-256 mismatch: expected {EXPECTED_SHA256}, got {actual_sha256}")

    for code_slice in CODE_SLICES:
        actual = image[
            code_slice.file_offset : code_slice.file_offset + len(code_slice.expected)
        ]
        if actual != code_slice.expected:
            errors.append(
                f"{code_slice.name} at 0x{code_slice.file_offset:X}: "
                f"expected {code_slice.expected.hex(' ').upper()}, "
                f"got {actual.hex(' ').upper()}"
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
    for code_slice in CODE_SLICES:
        print(f"{code_slice.name}: file offset=0x{code_slice.file_offset:X}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
