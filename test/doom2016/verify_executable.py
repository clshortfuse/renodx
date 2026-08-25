#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
from pathlib import Path


EXPECTED_SHA256 = "A32DF8FFA042090F14FE0A200F1C5D7DDDF9C947FAC223916C252F826F1ECF11"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--exe", required=True, type=Path)
    args = parser.parse_args()
    executable = args.exe.resolve()
    if executable.name.lower() != "doomx64vk.exe":
        raise AssertionError(f"unexpected executable name: {executable.name}")
    digest = hashlib.sha256(executable.read_bytes()).hexdigest().upper()
    if digest != EXPECTED_SHA256:
        raise AssertionError(f"unsupported DOOMx64vk.exe SHA-256: {digest}")
    print(f"DOOM 2016 executable contract: PASS ({digest})")


if __name__ == "__main__":
    main()
