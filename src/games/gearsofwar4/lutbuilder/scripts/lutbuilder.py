#!/usr/bin/env python3
"""ue-extended lutbuilder workflow: check injections, fix LUT weights, convert temp shaders."""

from __future__ import annotations

import argparse
import re
import shutil
import sys
from pathlib import Path

LUTBUILDER = Path(__file__).resolve().parents[1]
TEMP_SM6 = LUTBUILDER.parent / "temp" / "sm6"
DEST_SM6 = LUTBUILDER / "sm6"

CB_CONFIG_NAMED = """\
  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = {film_black};
  cb_config.ue_filmtoe = {film_toe};
  cb_config.ue_filmshoulder = {film_shoulder};
  cb_config.ue_filmslope = {film_slope};
  cb_config.ue_filmwhiteclip = {film_white};
  cb_config.ue_tonecurveammount = {tone_curve};
  cb_config.ue_mappingpolynomial = {mapping};
  cb_config.ue_overlaycolor = {overlay};
  cb_config.ue_bluecorrection = {blue};
  cb_config.ue_colorscale = {color_scale};
{lutweights_line}\
{process_line}\
{return_line}"""


def iter_shaders() -> list[Path]:
    paths: list[Path] = []
    for sub in ("sm6", "sm5"):
        folder = LUTBUILDER / sub
        if folder.exists():
            paths.extend(sorted(folder.glob("lutbuilder_*.hlsl")))
    return paths


def declared_cb0(text: str) -> set[str]:
    if "cbuffer cb0" not in text:
        return set()
    block = text.split("cbuffer cb0", 1)[1].split("};", 1)[0]
    return set(re.findall(r"\bcb0_\d+[xyzw]\b", block))


def injection_cb0(text: str) -> set[str]:
    if "cb_config.ue_filmblackclip" not in text:
        return set()
    chunk = text.split("cb_config.ue_filmblackclip", 1)[1]
    chunk = re.split(
        r"\n\s*(?:o0 = ProcessLutbuilder|SV_Target = ProcessLutbuilder|float4 output = ProcessLutbuilder)",
        chunk,
        1,
    )[0]
    return set(re.findall(r"\bcb0_\d+[xyzw]\b", chunk))


def process_output_cb0(text: str) -> str | None:
    m = re.search(
        r"(?:SV_Target = ProcessLutbuilder|float4 output = ProcessLutbuilder)\([^\n]+,\s*(cb0_\d+[xyzw])\)",
        text,
    )
    return m.group(1) if m else None


def count_named_textures(text: str) -> int:
    """Count 2D SDR LUT textures only — not Texture3D volume LUTs."""
    n = len(re.findall(r"Texture2D<float4>\s+Textures_\d+", text))
    if n:
        return n
    return len(re.findall(r"Texture2D<float4>\s+t\d+", text))


def detect_cb0_005_weights(text: str, lut_count: int) -> bool:
    if lut_count == 1:
        return bool(
            "cb0_005x" in text
            and "cb0_005y" in text
            and re.search(r"\* \(cb0_005y\)", text)
        )
    if lut_count == 2:
        return "cb0_005z" in text and re.search(r"\* \(cb0_005y\)", text)
    if lut_count >= 3:
        return "cb0_005w" in text
    return False


def detect_cb0_038_039_weights(text: str) -> bool:
    return bool(re.search(r"\* cb0_039x\) \+ \(cb0_038x", text))


def has_sdr_lut_weight_lerp(text: str) -> bool:
    if detect_cb0_038_039_weights(text):
        return True
    lut_count = count_named_textures(text)
    return detect_cb0_005_weights(text, max(lut_count, 1))


def uses_lut_process(text: str) -> bool:
    return bool(re.search(r"ProcessLutbuilder\([^\n]*(Samplers_1|\bs0\b)", text))


def has_lutweights(text: str) -> bool:
    return "ue_lutweights" in text


def lut_process_sampler_texture_args(text: str, lut_count: int) -> str | None:
    if lut_count == 1:
        if "Texture2D<float4> Textures_1" in text:
            return "Samplers_1, Textures_1"
        if "Texture2D<float4> t0" in text:
            return "s0, t0"
    if lut_count == 2:
        if "Textures_2" in text:
            return "Samplers_1, Samplers_2, Textures_1, Textures_2"
        if "t1" in text and "Texture2D<float4> t0" in text:
            return "s0, s1, t0, t1"
    if lut_count == 3 and "Textures_3" in text:
        return "Samplers_1, Samplers_2, Samplers_3, Textures_1, Textures_2, Textures_3"
    return None


def lutweights_block(text: str) -> str | None:
    lut_count = count_named_textures(text)
    if lut_count == 0 or not has_sdr_lut_weight_lerp(text):
        return None
    if has_lutweights(text):
        return None
    if "LUTWeights[2]" in text or ("float LUTWeights[5]" in text and lut_count == 4):
        if "float LUTWeights[5]" in text:
            return (
                "  float4 lutweights[2] = {\n"
                "    float4(asfloat(LUTWeights[0]), asfloat(LUTWeights[1]), asfloat(LUTWeights[2]), asfloat(LUTWeights[3])),\n"
                "    float4(0.f, 0.f, 0.f, 0.f)\n"
                "  };\n"
                "  cb_config.ue_lutweights = lutweights;\n"
            )
        return "  cb_config.ue_lutweights = LUTWeights;\n"
    if detect_cb0_038_039_weights(text) and lut_count == 1:
        return (
            "  float4 lutweights[2] = { float4(cb0_038x, cb0_039x, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };\n"
            "  cb_config.ue_lutweights = lutweights;\n"
        )
    if not detect_cb0_005_weights(text, lut_count):
        return None
    if lut_count == 1:
        return (
            "  float4 lutweights[2] = { float4(asfloat(cb0_005x), asfloat(cb0_005y), 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };\n"
            "  cb_config.ue_lutweights = lutweights;\n"
        )
    if lut_count == 2:
        return (
            "  float4 lutweights[2] = { float4(asfloat(cb0_005x), asfloat(cb0_005y), asfloat(cb0_005z), 0.f), float4(0.f, 0.f, 0.f, 0.f) };\n"
            "  cb_config.ue_lutweights = lutweights;\n"
        )
    if lut_count == 3:
        return (
            "  float4 lutweights[2] = { float4(asfloat(cb0_005x), asfloat(cb0_005y), asfloat(cb0_005z), asfloat(cb0_005w)), float4(0.f, 0.f, 0.f, 0.f) };\n"
            "  cb_config.ue_lutweights = lutweights;\n"
        )
    return None


def needs_lut_wiring(text: str) -> bool:
    lut_count = count_named_textures(text)
    if lut_count == 0 or not has_sdr_lut_weight_lerp(text):
        return False
    if not has_lutweights(text):
        return True
    return not uses_lut_process(text)


def audit_issue(text: str) -> str | None:
    if not needs_lut_wiring(text):
        return None
    lut_count = count_named_textures(text)
    if not has_lutweights(text):
        src = lutweights_block(text)
        if src:
            return f"missing ue_lutweights ({lut_count} LUT(s); dead code supports auto-fix)"
        return f"missing ue_lutweights ({lut_count} LUT(s); needs manual weight trace)"
    return f"missing LUT ProcessLutbuilder overload ({lut_count} LUT(s); has weights but no s0/t0 or Samplers_1)"


def upgrade_process_lutbuilder(text: str) -> tuple[str, bool]:
    lut_count = count_named_textures(text)
    args = lut_process_sampler_texture_args(text, lut_count)
    if not args or uses_lut_process(text):
        return text, False
    pattern = re.compile(
        r"(ProcessLutbuilder\(\s*float3\([^)]+\),\s*)"
        r"(cb_config,\s*(?:SV_Target|float4 output|[a-zA-Z_][\w\[\].,\s]+)),"
    )

    def repl(m: re.Match[str]) -> str:
        return f"{m.group(1)}{args}, {m.group(2)},"

    new_text, n = pattern.subn(repl, text, count=1)
    return new_text, n > 0


def insert_lutweights(text: str) -> tuple[str, bool]:
    block = lutweights_block(text)
    changed = False
    if block and not has_lutweights(text):
        pattern = re.compile(
            r"(\n\s*(?:cb_config\.ue_colorscale = [^\n]+\n))"
            r"(\s*(?:SV_Target = ProcessLutbuilder|float4 output = ProcessLutbuilder))",
        )
        m = pattern.search(text)
        if m:
            text = text[: m.start()] + m.group(1) + block + m.group(2) + text[m.end() :]
            changed = True
    text, upgraded = upgrade_process_lutbuilder(text)
    return text, changed or upgraded


def cmd_check(_args: argparse.Namespace) -> int:
    cb0_failures = 0
    lut_failures = 0
    for path in iter_shaders():
        text = path.read_text(encoding="utf-8", errors="replace")
        rel = path.relative_to(LUTBUILDER)

        if "cb_config.ue_filmblackclip" in text and "cbuffer cb0" in text:
            decl = declared_cb0(text)
            used = injection_cb0(text)
            out = process_output_cb0(text)
            missing = sorted(used - decl)
            out_missing = out is not None and out not in decl
            if missing or out_missing:
                cb0_failures += 1
                print(f"FAIL {rel} (cb0)")
                if missing:
                    print(f"  undeclared in cb_config: {missing}")
                if out_missing:
                    print(f"  undeclared output device: {out}")

        lut_issue = audit_issue(text)
        if lut_issue:
            lut_failures += 1
            print(f"FAIL {rel} (lutweights): {lut_issue}")

    if cb0_failures or lut_failures:
        print(
            f"\n{cb0_failures} cb0 issue(s), {lut_failures} lutweights issue(s)"
        )
        print("Scripts check structural wiring only — blue/tone fingerprints require manual verification (see SKILL.md).")
        return 1

    print("All injections pass cb0 and lutweights checks")
    return 0


def cmd_fix_weights(args: argparse.Namespace) -> int:
    failures = 0
    fixed = 0
    for path in iter_shaders():
        text = path.read_text(encoding="utf-8", errors="replace")
        issue = audit_issue(text)
        if not issue:
            continue
        failures += 1
        rel = path.relative_to(LUTBUILDER)
        if args.fix:
            new_text, changed = insert_lutweights(text)
            if changed:
                path.write_text(new_text, encoding="utf-8")
                fixed += 1
                print(f"FIX  {rel}: {issue}")
            else:
                print(f"FAIL {rel}: {issue} (auto-fix failed — map manually from dead code)")
        else:
            print(f"FAIL {rel}: {issue}")

    if args.fix and fixed:
        print(f"\nFixed {fixed} file(s). Re-run `check` and verify dead code manually.")
        return 0

    if failures:
        print(f"\n{failures} file(s) with LUT weight issues")
        if not args.fix:
            print("Run `fix-weights --fix` to auto-insert where dead code allows.")
        return 1

    print("All LUT-enabled ProcessLutbuilder shaders have ue_lutweights")
    return 0


def count_textures(text: str) -> int:
    return len(re.findall(r"Texture2D<float4>\s+Textures_\d+", text))


def detect_style(text: str) -> str:
    if "FilmBlackClip" in text:
        return "named"
    if "cb0_008x" in text or "cbuffer cb0" in text:
        return "cb0"
    if "$Globals" in text or "OutputDevice : packoffset(c000.x)" in text:
        return "minimal"
    return "unknown"


def detect_output_device(text: str, style: str) -> str:
    if style == "named":
        if "OutputDevice : packoffset(c040.w)" in text:
            return "OutputDevice"
        if "OutputDevice : packoffset(c041.x)" in text:
            return "OutputDevice"
    if "cb0_040w" in text:
        return "cb0_040w"
    if "cb0_042w" in text:
        return "cb0_042w"
    if "cb0_065z" in text:
        return "cb0_065z"
    return "OutputDevice"


def has_field(text: str, field: str) -> bool:
    return bool(re.search(rf"\b{re.escape(field)}\b", text))


def blue_field(text: str, style: str) -> str:
    if style == "named" and has_field(text, "BlueCorrection"):
        return "BlueCorrection"
    if "cb0_038z" in text:
        return "cb0_038z"
    if "cb0_036z" in text:
        return "cb0_036z"
    return "0.f"


def tone_curve_field(text: str, style: str) -> str:
    if style == "named" and has_field(text, "ToneCurveAmount"):
        return "ToneCurveAmount"
    if "cb0_037x" in text:
        return "cb0_037x"
    return "1.f"


def lutweights_line(style: str, lut_count: int, text: str) -> str:
    if lut_count == 0:
        return ""
    block = lutweights_block(text)
    if block:
        return block
    if style == "named" and "LUTWeights[2]" in text:
        return "  cb_config.ue_lutweights = LUTWeights;\n"
    if style == "named" and "float LUTWeights[5]" in text:
        return (
            "  float4 lutweights[2] = { float4(asfloat(LUTWeights[0]), asfloat(LUTWeights[1]), asfloat(LUTWeights[2]), asfloat(LUTWeights[3])), float4(0.f, 0.f, 0.f, 0.f) };\n"
            "  cb_config.ue_lutweights = lutweights;\n"
        )
    return ""


def process_call(
    triplet: tuple[str, str, str],
    lut_count: int,
    is_cs: bool,
    output: str,
    text: str,
) -> tuple[str, str]:
    v = f"float3({triplet[0]}, {triplet[1]}, {triplet[2]})"
    if is_cs:
        rw = "RWOutputTexture" if "RWOutputTexture" in text else "u0"
        idx = f"{rw}[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))]"
        if lut_count == 0:
            pl = f"  float4 output = ProcessLutbuilder({v}, cb_config, {idx}, {output});\n"
        elif lut_count == 1:
            pl = f"  float4 output = ProcessLutbuilder({v}, Samplers_1, Textures_1, cb_config, {idx}, {output});\n"
        elif lut_count == 2:
            pl = f"  float4 output = ProcessLutbuilder({v}, Samplers_1, Samplers_2, Textures_1, Textures_2, cb_config, {idx}, {output});\n"
        elif lut_count == 3:
            pl = f"  float4 output = ProcessLutbuilder({v}, Samplers_1, Samplers_2, Samplers_3, Textures_1, Textures_2, Textures_3, cb_config, {idx}, {output});\n"
        else:
            pl = f"  float4 output = ProcessLutbuilder({v}, Samplers_1, Samplers_2, Samplers_3, Samplers_4, Textures_1, Textures_2, Textures_3, Textures_4, cb_config, {idx}, {output});\n"
        rl = f"  {rw}[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;\n  return;\n"
        return pl, rl
    if lut_count == 0:
        pl = f"  SV_Target = ProcessLutbuilder({v}, cb_config, SV_Target, {output});\n"
    elif lut_count == 1:
        pl = f"  SV_Target = ProcessLutbuilder({v}, Samplers_1, Textures_1, cb_config, SV_Target, {output});\n"
    elif lut_count == 2:
        pl = f"  SV_Target = ProcessLutbuilder({v}, Samplers_1, Samplers_2, Textures_1, Textures_2, cb_config, SV_Target, {output});\n"
    elif lut_count == 3:
        pl = f"  SV_Target = ProcessLutbuilder({v}, Samplers_1, Samplers_2, Samplers_3, Textures_1, Textures_2, Textures_3, cb_config, SV_Target, {output});\n"
    else:
        pl = f"  SV_Target = ProcessLutbuilder({v}, Samplers_1, Samplers_2, Samplers_3, Samplers_4, Textures_1, Textures_2, Textures_3, Textures_4, cb_config, SV_Target, {output});\n"
    return pl, "  return SV_Target;\n"


def fix_expand_gamut(text: str) -> str:
    pattern = re.compile(
        r"^(\s*)float (\w+) = \(1\.0f - exp2\(\(\(_\w+ \* _\w+\) \* -4\.0f\) \* ExpandGamut\)\)"
        r" \* \(1\.0f - exp2\(dot\(float3\([^)]+\), float3\([^)]+\)\) \* -4\.0f\)\);",
        re.MULTILINE,
    )

    def repl(m: re.Match[str]) -> str:
        indent, var = m.group(1), m.group(2)
        original = m.group(0).strip()
        fixed = original.replace("ExpandGamut", "0.f")
        return f"{indent}// {original}\n{indent}{fixed}"

    return pattern.sub(repl, text)


def strip_generic_hooks(text: str) -> str:
    text = re.sub(r'#include "../../common\.hlsl"\s*\n', '#include "../lutbuilderoutput.hlsli"\n\n', text)
    text = re.sub(r"^\s*SetUngradedAP1\([^\n]+\);\s*\n", "", text, flags=re.MULTILINE)
    text = re.sub(r"^\s*SetTonemappedAP1\([^\n]+\);\s*\n", "", text, flags=re.MULTILINE)
    text = re.sub(
        r"\s*if \(RENODX_TONE_MAP_TYPE != 0(?:\.f)?\) \{[\s\S]*?\n\s*\}\n",
        "\n",
        text,
    )
    return text


def inject_at_untonemapped(text: str, style: str) -> str:
    m = re.search(
        r"SetUntonemappedAP1\(float3\(([^,]+),\s*([^,]+),\s*([^)]+)\)\);",
        text,
    )
    if not m:
        raise ValueError("SetUntonemappedAP1 anchor not found")
    triplet = (m.group(1).strip(), m.group(2).strip(), m.group(3).strip())
    lut_count = count_textures(text)
    is_cs = ".cs_" in text or "RWTexture3D" in text or "u0 : register" in text
    output = detect_output_device(text, style)
    lw = lutweights_line(style, lut_count, text)
    pl, rl = process_call(triplet, lut_count, is_cs, output, text)

    if style == "named":
        block = CB_CONFIG_NAMED.format(
            film_black="FilmBlackClip",
            film_toe="FilmToe",
            film_shoulder="FilmShoulder",
            film_slope="FilmSlope",
            film_white="FilmWhiteClip",
            tone_curve=tone_curve_field(text, style),
            mapping="MappingPolynomial",
            overlay="OverlayColor",
            blue=blue_field(text, style),
            color_scale="ColorScale",
            lutweights_line=lw,
            process_line=pl,
            return_line=rl,
        )
    elif style == "cb0":
        raise ValueError(
            "cb0 cbuffer requires manual cb_config mapping from dead code "
            "(see SKILL.md Unnamed cbuffers). Strip hooks in temp/, map fields, "
            "run `lutbuilder.py check`, then move to sm6/."
        )
    else:
        raise ValueError(f"unsupported style for injection: {style}")

    return text.replace(m.group(0), block, 1)


def convert_file(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    style = detect_style(text)
    if style == "minimal":
        raise ValueError("minimal HDR-only shader needs manual conversion")
    if style == "unknown":
        raise ValueError("unknown cbuffer style")

    text = strip_generic_hooks(text)
    text = fix_expand_gamut(text)
    text = inject_at_untonemapped(text, style)
    path.write_text(text, encoding="utf-8")


def cmd_convert_temp(_args: argparse.Namespace) -> int:
    if not TEMP_SM6.exists():
        print(f"No temp folder: {TEMP_SM6}")
        return 1

    failures: list[tuple[str, str]] = []
    for path in sorted(TEMP_SM6.glob("*.hlsl")):
        try:
            convert_file(path)
            dest = DEST_SM6 / path.name
            shutil.move(str(path), str(dest))
            print(f"OK {path.name}")
        except Exception as exc:  # noqa: BLE001
            failures.append((path.name, str(exc)))
            print(f"FAIL {path.name}: {exc}")

    if failures:
        print("\nFailures:")
        for name, err in failures:
            print(f"  {name}: {err}")
        return 1

    print("Done. Manually verify cb0 shaders and run `check`.")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        epilog="Manual dead-code verification is always mandatory (see SKILL.md).",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser(
        "check",
        help="Verify cb0 declarations, bracket wiring, blue/tone fingerprints, extended 074 pairing, LUT weights (sm5 + sm6)",
    )

    fix_p = sub.add_parser("fix-weights", help="Audit or auto-fix missing ue_lutweights")
    fix_p.add_argument(
        "--fix",
        action="store_true",
        help="Insert lutweights where dead code supports auto-fix",
    )

    sub.add_parser(
        "convert-temp",
        help="Convert ue-generic temp/sm6 shaders to ProcessLutbuilder form (named cbuffers only)",
    )

    args = parser.parse_args()
    if args.command == "check":
        return cmd_check(args)
    if args.command == "fix-weights":
        return cmd_fix_weights(args)
    if args.command == "convert-temp":
        return cmd_convert_temp(args)
    return 1


if __name__ == "__main__":
    sys.exit(main())
