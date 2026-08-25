#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


def resolve_ref(root: dict[str, Any], reference: str) -> dict[str, Any]:
    if not reference.startswith("#/"):
        raise AssertionError(f"unsupported external schema reference: {reference}")
    value: Any = root
    for token in reference[2:].split("/"):
        token = token.replace("~1", "/").replace("~0", "~")
        value = value[token]
    return value


def type_matches(value: Any, expected: str) -> bool:
    return {
        "null": value is None,
        "object": isinstance(value, dict),
        "array": isinstance(value, list),
        "string": isinstance(value, str),
        "number": isinstance(value, (int, float)) and not isinstance(value, bool),
        "integer": isinstance(value, int) and not isinstance(value, bool),
        "boolean": isinstance(value, bool),
    }[expected]


def validate(value: Any, schema: dict[str, Any], root: dict[str, Any], path: str) -> None:
    if "$ref" in schema:
        validate(value, resolve_ref(root, schema["$ref"]), root, path)
        return
    for subschema in schema.get("allOf", []):
        validate(value, subschema, root, path)
    if "anyOf" in schema:
        failures = []
        for subschema in schema["anyOf"]:
            try:
                validate(value, subschema, root, path)
                break
            except AssertionError as error:
                failures.append(str(error))
        else:
            raise AssertionError(f"{path}: no anyOf branch matched: {failures}")
    if "oneOf" in schema:
        matches = 0
        for subschema in schema["oneOf"]:
            try:
                validate(value, subschema, root, path)
                matches += 1
            except AssertionError:
                pass
        if matches != 1:
            raise AssertionError(f"{path}: expected one oneOf match, got {matches}")

    expected_type = schema.get("type")
    if expected_type is not None:
        choices = expected_type if isinstance(expected_type, list) else [expected_type]
        if not any(type_matches(value, choice) for choice in choices):
            raise AssertionError(f"{path}: expected type {choices}, got {type(value).__name__}")
    if "enum" in schema and value not in schema["enum"]:
        raise AssertionError(f"{path}: {value!r} is not in enum")

    if isinstance(value, dict):
        required = schema.get("required", [])
        missing = [key for key in required if key not in value]
        if missing:
            raise AssertionError(f"{path}: missing required keys {missing}")
        properties = schema.get("properties", {})
        additional = schema.get("additionalProperties", True)
        for key, child in value.items():
            child_path = f"{path}.{key}"
            if key in properties:
                validate(child, properties[key], root, child_path)
            elif additional is False:
                raise AssertionError(f"{child_path}: additional property is forbidden")
            elif isinstance(additional, dict):
                validate(child, additional, root, child_path)
    elif isinstance(value, list):
        if len(value) < schema.get("minItems", 0):
            raise AssertionError(f"{path}: too few items")
        if "maxItems" in schema and len(value) > schema["maxItems"]:
            raise AssertionError(f"{path}: too many items")
        if schema.get("uniqueItems"):
            encoded = [json.dumps(item, sort_keys=True) for item in value]
            if len(encoded) != len(set(encoded)):
                raise AssertionError(f"{path}: duplicate array items")
        if isinstance(schema.get("items"), dict):
            for index, item in enumerate(value):
                validate(item, schema["items"], root, f"{path}[{index}]")
    elif isinstance(value, str):
        if len(value) < schema.get("minLength", 0):
            raise AssertionError(f"{path}: string is too short")
        if "maxLength" in schema and len(value) > schema["maxLength"]:
            raise AssertionError(f"{path}: string is too long")
        if "pattern" in schema and re.search(schema["pattern"], value) is None:
            raise AssertionError(f"{path}: string does not match {schema['pattern']}")
    elif isinstance(value, (int, float)) and not isinstance(value, bool):
        if "minimum" in schema and value < schema["minimum"]:
            raise AssertionError(f"{path}: value is below minimum")
        if "maximum" in schema and value > schema["maximum"]:
            raise AssertionError(f"{path}: value is above maximum")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--metadata", required=True, type=Path)
    parser.add_argument("--schema", required=True, type=Path)
    args = parser.parse_args()
    metadata = json.loads(args.metadata.read_text(encoding="utf-8"))
    schema = json.loads(args.schema.read_text(encoding="utf-8"))
    validate(metadata, schema, schema, "metadata")

    assert metadata["id"] == "doom2016"
    assert metadata["status"] == "experimental"
    deploy = metadata["deploy"]
    assert deploy["reshade_version_range"] == ">=6.8.0 <6.9.0"
    assert deploy["game_exe"] == "DOOMx64vk.exe"
    assert deploy["api"] == "vulkan"
    assert "platform" not in deploy
    assert deploy["steam_appid"] == 379720
    assert deploy["gog_product_id"] == 1390579243
    assert deploy["architecture"] == ["x64"]
    notes = "\n".join(metadata["notes"])
    assert "A32DF8FFA042090F14FE0A200F1C5D7DDDF9C947FAC223916C252F826F1ECF11" in notes
    assert "user-confirmed Steam Vulkan build" in notes
    assert "OpenGL is not supported" in notes
    assert "Preset Off" in notes and "restart" in notes
    assert "VK_EXT_hdr_metadata" in notes
    assert "PsychoV-25" in notes and "provisional" in notes
    assert "RTSS" in notes and "built-in performance statistics" in notes
    print("DOOM 2016 metadata/schema contract: PASS")


if __name__ == "__main__":
    main()
