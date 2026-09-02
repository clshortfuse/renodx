#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def run_json(command: list[str]) -> dict:
    completed = subprocess.run(command, check=True, capture_output=True, text=True)
    return json.loads(completed.stdout)


def keyed(items: list[dict], value_key: str) -> dict[str, object]:
    return {f"{item.get('set', 0)}:{item['binding']}": item[value_key]
            for item in items}


def locations(items: list[dict]) -> dict[str, str]:
    return {str(item["location"]): item["type"] for item in items}


def unwrap_push_members(reflection: dict) -> list[dict]:
    pushes = reflection.get("push_constants", [])
    require(len(pushes) == 1, "expected exactly one push-constant block")
    types = reflection["types"]
    block = types[pushes[0]["type"]]
    members = block.get("members", [])
    if len(members) == 1 and members[0].get("type") in types:
        members = types[members[0]["type"]].get("members", [])
    return members


def embedded_bytes(header: Path) -> bytes:
    text = header.read_text(encoding="utf-8")
    match = re.search(r"_base\[\]\s*=\s*\{([\s\S]*?)\};", text)
    require(match is not None, f"embedded byte array missing: {header}")
    return bytes(int(value) for value in re.findall(r"\b\d+\b", match.group(1)))


def validate_group(
    group_name: str,
    group: dict,
    push_contract: list[list[object]],
    embed_dir: Path,
    spirv_val: Path,
    spirv_cross: Path,
    spirv_dis: Path,
) -> list[str]:
    hashes: list[str] = []
    for filename in group["files"]:
        spv = embed_dir / filename
        require(spv.is_file(), f"generated SPIR-V missing: {spv}")
        subprocess.run(
            [str(spirv_val), "--target-env", "vulkan1.1", str(spv)],
            check=True,
        )
        disassembly = subprocess.run(
            [str(spirv_dis), str(spv)],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
        require("; Version: 1.3" in disassembly,
                f"{filename}: expected Vulkan 1.1-compatible SPIR-V 1.3")
        if group_name == "proxy_vertex":
            require("OpCapability DrawParameters" not in disassembly,
                    f"{filename}: proxy requires disabled shaderDrawParameters")
        reflection = run_json([str(spirv_cross), str(spv), "--reflect"])
        entries = reflection.get("entryPoints", [])
        require(entries == [{"name": "main", "mode": group["stage"]}],
                f"{filename}: stage/entry drifted: {entries}")
        require(locations(reflection.get("inputs", [])) == group["inputs"],
                f"{filename}: fragment inputs drifted")
        require(locations(reflection.get("outputs", [])) == group["outputs"],
                f"{filename}: fragment outputs drifted")
        require(keyed(reflection.get("ubos", []), "block_size") == group["ubos"],
                f"{filename}: UBO set/binding/size drifted")
        textures = sorted(
            f"{item.get('set', 0)}:{item['binding']}"
            for item in reflection.get("textures", [])
        )
        require(textures == sorted(group["textures"]),
                f"{filename}: sampled descriptor ABI drifted")
        for category in ("separate_images", "separate_samplers"):
            actual = sorted(
                f"{item.get('set', 0)}:{item['binding']}"
                for item in reflection.get(category, [])
            )
            require(actual == sorted(group.get(category, [])),
                    f"{filename}: {category} ABI drifted")
        if group.get("push", False):
            members = unwrap_push_members(reflection)
            actual_push = [[member.get("name"), member["offset"]] for member in members]
            require(actual_push == push_contract,
                    f"{filename}: 64-byte push ABI drifted: {actual_push}")
            require(members[-1]["offset"] + 4 == 64,
                    f"{filename}: push payload is not 64 bytes")
        else:
            require(not reflection.get("push_constants"),
                    f"{filename}: proxy unexpectedly depends on injected constants")

        header = embed_dir / f"{spv.stem}.h"
        require(embedded_bytes(header) == spv.read_bytes(),
                f"{filename}: generated embed bytes differ from SPIR-V")
        hashes.append(hashlib.sha256(spv.read_bytes()).hexdigest())
    return hashes


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--expected", required=True, type=Path)
    parser.add_argument("--embed-dir", required=True, type=Path)
    parser.add_argument("--spirv-val", required=True, type=Path)
    parser.add_argument("--spirv-cross", required=True, type=Path)
    parser.add_argument("--spirv-dis", required=True, type=Path)
    args = parser.parse_args()

    expected = json.loads(args.expected.read_text(encoding="utf-8"))
    all_hashes: list[str] = []
    for group_name in ("postprocess", "output", "proxy_vertex", "proxy_pixel"):
        all_hashes.extend(validate_group(
            group_name,
            expected[group_name],
            expected["push_constants"],
            args.embed_dir.resolve(),
            args.spirv_val.resolve(),
            args.spirv_cross.resolve(),
            args.spirv_dis.resolve(),
        ))
    require(len(all_hashes) == len(set(all_hashes)),
            "independent mode blobs unexpectedly compiled to duplicate SPIR-V")
    print(f"DOOM 2016 shader/ABI contract: PASS ({len(all_hashes)} SPIR-V modules)")


if __name__ == "__main__":
    main()
