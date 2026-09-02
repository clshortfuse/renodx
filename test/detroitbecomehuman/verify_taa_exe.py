import argparse
import hashlib
import json
import struct
import subprocess
import sys
import zlib
from pathlib import Path


DESCRIPTOR_KINDS = ("textures", "images", "ubos")


def fail(message):
    raise AssertionError(message)


def normalize_descriptors(reflection):
    descriptors = []
    for kind in DESCRIPTOR_KINDS:
        for resource in reflection.get(kind, []):
            descriptor = {
                "kind": kind,
                "set": resource["set"],
                "binding": resource["binding"],
                "name": resource["name"],
            }
            keys = ("format", "block_size") if kind == "ubos" else ("type", "format")
            for key in keys:
                if key in resource:
                    descriptor[key] = resource[key]
            descriptors.append(descriptor)
    return sorted(
        descriptors,
        key=lambda item: (item["set"], item["binding"], item["kind"]),
    )


def normalize_constant_members(reflection, block_type):
    types = reflection.get("types", {})
    result = []
    for member in block_type.get("members", []):
        reflected_type = types.get(member["type"], {}).get("name", member["type"])
        item = {
            "name": member["name"],
            "type": reflected_type,
            "offset": member["offset"],
        }
        for key in ("array", "array_stride"):
            if key in member:
                item[key] = member[key]
        result.append(item)
    return result


def validate_reflection(reflection, expected):
    entry_points = reflection.get("entryPoints", [])
    if len(entry_points) != 1:
        fail(f"expected one entry point, got {len(entry_points)}")
    entry = entry_points[0]
    actual_entry = {
        "name": entry.get("name"),
        "mode": entry.get("mode"),
        "workgroup_size": entry.get("workgroup_size"),
    }
    if actual_entry != expected["entry_point"]:
        fail(f"TAA entry point changed: {actual_entry}")

    descriptors = normalize_descriptors(reflection)
    expected_descriptors = sorted(
        expected["descriptors"],
        key=lambda item: (item["set"], item["binding"], item["kind"]),
    )
    if descriptors != expected_descriptors:
        fail(
            "TAA descriptor interface changed\n"
            f"expected: {expected_descriptors}\n"
            f"actual:   {descriptors}"
        )
    if any(item["binding"] == 9 for item in descriptors):
        fail("inactive sampled binding b9 unexpectedly became active")

    ubo = next(
        item
        for item in reflection["ubos"]
        if item["set"] == 0 and item["binding"] == 52
    )
    types = reflection.get("types", {})
    outer = types.get(ubo["type"])
    if outer is None or outer.get("name") != expected["constant_block"]["outer_name"]:
        fail("b52 outer constant block changed")
    outer_members = outer.get("members", [])
    if len(outer_members) != 1:
        fail("b52 must contain exactly one TAA block")
    outer_member = outer_members[0]
    if (
        outer_member.get("name") != expected["constant_block"]["member_name"]
        or outer_member.get("offset") != 0
    ):
        fail("b52 TAA wrapper member changed")
    block = types.get(outer_member["type"])
    if block is None or block.get("name") != expected["constant_block"]["name"]:
        fail("b52 TAA block type changed")
    if ubo.get("block_size") != expected["constant_block"]["size"]:
        fail(f"b52 size changed to {ubo.get('block_size')}")
    members = normalize_constant_members(reflection, block)
    if members != expected["constant_block"]["members"]:
        fail(
            "b52 member layout changed\n"
            f"expected: {expected['constant_block']['members']}\n"
            f"actual:   {members}"
        )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--exe", required=True, type=Path)
    parser.add_argument("--expected", required=True, type=Path)
    parser.add_argument("--spirv-cross", required=True, type=Path)
    args = parser.parse_args()

    expected = json.loads(args.expected.read_text(encoding="utf-8"))
    executable = args.exe.read_bytes()
    if len(executable) != expected["executable"]["size"]:
        fail(f"unsupported executable size: {len(executable)}")
    digest = hashlib.sha256(executable).hexdigest().upper()
    if digest != expected["executable"]["sha256"]:
        fail(f"unsupported executable SHA-256: {digest}")

    module_expected = expected["module"]
    start = module_expected["offset"]
    end = start + module_expected["size"]
    if start < 0 or end > len(executable):
        fail("TAA SPIR-V slice lies outside the supported executable")
    module = executable[start:end]
    header = struct.unpack_from("<5I", module)
    expected_header = tuple(
        module_expected[key]
        for key in ("magic", "version", "generator", "bound", "schema")
    )
    if header != expected_header:
        fail(f"TAA SPIR-V header changed: {header}")
    crc = f"0x{zlib.crc32(module) & 0xFFFFFFFF:08X}"
    if crc != module_expected["crc32"]:
        fail(f"TAA SPIR-V CRC changed: {crc}")

    result = subprocess.run(
        [str(args.spirv_cross), "-", "--reflect"],
        input=module,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        fail(
            "spirv-cross reflection failed: "
            + result.stderr.decode("utf-8", errors="replace").strip()
        )
    reflection = json.loads(result.stdout.decode("utf-8"))
    validate_reflection(reflection, expected)
    print(
        "PASS: supported Detroit executable contains exact "
        "0xB5506A45 TAA SPIR-V interface"
    )
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (
        AssertionError,
        json.JSONDecodeError,
        KeyError,
        OSError,
        StopIteration,
        struct.error,
        ValueError,
    ) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        sys.exit(1)
