#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
import re
from pathlib import Path


P30_ORIGINAL_SHA256 = (
    "01E075AB1E9FD79469E160FCD05F54277DE8B47C76CC3C4A425E4DAA7F164F58"
)
P30_ORIGINAL_NORMALIZED_SHA256 = (
    "5C20BD6A89A8281678553E302C9DAB23FDA185C325DA167E2292C7A34A2A0BAF"
)
TLOU_COMMIT = "4f0a278d"
TLOU_SHA256 = {
    "psychov_test24.hlsli":
        "FE71577D87665B76DB7E0DBCEC9B920530036A86B35715B2AEF24F52615CCFF1",
    "psychov_test25.hlsli":
        "3DFFEDCA8D6953A275574B1CC58D19C89C8F96CC38DF9BF7D48AADA1FE5D6A10",
    "psychov_test25_nrg.hlsli":
        "F6CB5AC90CF0BE7E2D79C05EAD73694FF7364B502FCBE359484B40405D9A1C7B",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def normalized_bytes(path: Path) -> bytes:
    return path.read_bytes().replace(b"\r\n", b"\n")


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest().upper()


def reconstruct_nrg_source(data: bytes) -> bytes:
    return data.replace(
        b"SRC_GAMES_DOOM2016_PSYCHOV_TEST25_NRG_HLSLI_",
        b"SRC_GAMES_DISHONORED2_TEST25_NRG_HLSLI_",
    )


def reconstruct_p30_source(data: bytes) -> bytes:
    reconstructed = data.replace(
        b'#include "../../shaders/color/rgb.hlsl"',
        b'#include "../../color/rgb.hlsl"',
        1,
    )
    # apply_patch normalizes the touched line and adds a terminal newline. The
    # supplied source used CRLF and no final newline; compare normalized source
    # text while keeping its exact raw SHA above as the provenance identifier.
    return reconstructed[:-1] if reconstructed.endswith(b"\n") else reconstructed


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-dir", required=True, type=Path)
    args = parser.parse_args()
    source_dir = args.source_dir.resolve()

    addon = (source_dir / "addon.cpp").read_text(encoding="utf-8")
    shared = (source_dir / "shared.h").read_text(encoding="utf-8")
    common = (source_dir / "postprocess_common.hlsli").read_text(
        encoding="utf-8"
    )
    output = (source_dir / "viewcolor_output.frag.slang").read_text(
        encoding="utf-8"
    )
    cache = (source_dir / "pipeline_variants.hpp").read_text(encoding="utf-8")
    supported = (source_dir / "supported_build.hpp").read_text(encoding="utf-8")

    require("A32DF8FFA042090F14FE0A200F1C5D7DDDF9C947FAC223916C252F826F1ECF11" in supported,
            "supported executable SHA-256 is missing")
    require("0xF600527E" in supported and "0x49CBC37F" in supported,
            "captured shader CRC inventory is missing")

    expected_modes = [
        ("DOOM2016_TONEMAP_VANILLA", "0.f", "Vanilla"),
        ("DOOM2016_TONEMAP_PSYCHOV_17", "1.f", "PsychoV-17"),
        ("DOOM2016_TONEMAP_PSYCHOV_22", "2.f", "PsychoV-22"),
        ("DOOM2016_TONEMAP_PSYCHOV_24", "3.f", "PsychoV-24"),
        ("DOOM2016_TONEMAP_PSYCHOV_25", "4.f", "PsychoV-25"),
        ("DOOM2016_TONEMAP_PSYCHOV_30", "5.f", "PsychoV-30"),
        ("DOOM2016_TONEMAP_RENO_DRT", "6.f", "RenoDRT"),
    ]
    for symbol, value, label in expected_modes:
        require(re.search(rf"#define\s+{symbol}\s+{re.escape(value)}", shared) is not None,
                f"stable mode ID missing for {symbol}")
        require(f'"{label}"' in addon, f"setting label missing: {label}")

    expected_keys = [
        "OutputMode", "ToneMapType", "ToneMapPeakNits", "ToneMapGameNits",
        "ToneMapUINits", "ColorGradeExposure", "ColorGradeHighlights",
        "ColorGradeShadows", "ColorGradeContrast", "ColorGradeSaturation",
        "ColorGradeHighlightSaturation", "ColorGradeConeResponse",
        "ToneMapPsychoVExposureMatch", "ToneMapPsychoVVanillaHDRSlope",
    ]
    for key in expected_keys:
        require(f'"{key}"' in addon, f"stable setting key missing: {key}")

    expected_members = [
        "peak_white_nits", "diffuse_white_nits", "graphics_white_nits",
        "output_mode", "tone_map_type", "tone_map_exposure",
        "tone_map_highlights", "tone_map_shadows", "tone_map_contrast",
        "tone_map_saturation", "tone_map_highlight_saturation",
        "psychov_cone_response", "psychov_exposure_match",
        "psychov_vanilla_slope", "scene_path_active", "scene_bt2020",
    ]
    positions = [shared.index(f"float {member};") for member in expected_members]
    require(positions == sorted(positions), "ShaderInjectData member order drifted")
    require("static_assert(sizeof(ShaderInjectData) == 64u)" in shared,
            "64-byte C++ ABI assertion is missing")
    require("static_assert(alignof(ShaderInjectData) == 16u)" in shared,
            "16-byte C++ ABI alignment assertion is missing")
    require("layout(push_constant) uniform PushData" in shared,
            "Vulkan push-constant transport is missing")

    wrappers = {
        "postprocess_vanilla.frag.slang": 0,
        "postprocess_psychov17.frag.slang": 1,
        "postprocess_psychov22.frag.slang": 2,
        "postprocess_psychov24.frag.slang": 3,
        "postprocess_psychov25.frag.slang": 4,
        "postprocess_psychov30.frag.slang": 5,
        "postprocess_renodrt.frag.slang": 6,
    }
    for filename, mode in wrappers.items():
        text = (source_dir / filename).read_text(encoding="utf-8")
        require(f"#define DOOM2016_TONEMAP_VARIANT {mode}" in text,
                f"compile-time mapper selection drifted in {filename}")
        require('#include "./postprocess_common.hlsli"' in text,
                f"shared postprocess include missing in {filename}")

    require('#include "../../shaders/tonemap/psychov/test17.hlsl"' in common,
            "PsychoV-17 must use the shared implementation")
    require('#include "../../shaders/tonemap/psychov/test22.hlsl"' in common,
            "PsychoV-22 must use the shared implementation")
    require('#include "./psychov_test24.hlsli"' in common,
            "game-local PsychoV-24 include is missing")
    require('#include "./psychov_test25.hlsli"' in common,
            "game-local PsychoV-25 include is missing")
    require('#include "./psychov_test30.hlsli"' in common,
            "game-local PsychoV-30 include is missing")

    for filename in ("psychov_test24.hlsli", "psychov_test25.hlsli"):
        require(sha256(normalized_bytes(source_dir / filename)) == TLOU_SHA256[filename],
                f"{filename} no longer matches TLOU commit {TLOU_COMMIT}")
    nrg = normalized_bytes(source_dir / "psychov_test25_nrg.hlsli")
    require(sha256(reconstruct_nrg_source(nrg)) == TLOU_SHA256["psychov_test25_nrg.hlsli"],
            "P25 NRG changed beyond the approved include-guard correction")
    require(b"DISHONORED2" not in nrg and b"DOOM2016" in nrg,
            "P25 NRG include guard was not corrected game-locally")

    p30 = normalized_bytes(source_dir / "psychov_test30.hlsli")
    require(P30_ORIGINAL_SHA256 in (source_dir / "README.md").read_text(encoding="utf-8"),
            "PsychoV-30 supplied raw source SHA is not recorded")
    require(sha256(reconstruct_p30_source(p30)) == P30_ORIGINAL_NORMALIZED_SHA256,
            "PsychoV-30 changed beyond the approved game-local include path")
    require(b"SPDX-License-Identifier: MIT" in p30,
            "PsychoV-30 MIT notice is missing")
    require(re.search(
        r"psychotm_test30\([\s\S]*?\n\s*0\.0\);",
        common,
    ) is not None, "PsychoV-30 auto-compression must be explicit 0.f/0.0")

    require("kToneMapVariantCount = 7u" in cache,
            "pipeline cache must contain seven independent tone-map variants")
    require("VkGraphicsPipelineCreateInfo variant = original" in cache
            and "variant.pStages = stages.data()" in cache
            and "create_graphics_pipelines(" in cache,
            "exact-native VkGraphicsPipelineCreateInfo variant creation is missing")
    require("device->create_pipeline" not in cache,
            "DOOM must not reconstruct Vulkan pipelines through ReShade subobjects")
    require("vkGetInstanceProcAddr" in cache
            and "vkGetDeviceProcAddr" in cache
            and "HookCreateShaderModule" in cache,
            "early native Vulkan shader/pipeline hooks are missing")
    require("IsSupportedExecutable()" in cache
            and "kExecutableSize = 101520384ull" in supported,
            "native Vulkan variants are not gated to the inspected executable")
    require("PFN_vkDestroyPipeline" in cache
            and "data->destroy_pipeline" in cache,
            "native variant destruction must flow through ReShade tracking")
    require("AddRuntimeReplacement" not in addon + cache,
            "DOOM must not use the live pipeline-destruction path")
    require("RemoveRuntimeReplacements" not in addon + cache,
            "Preset Off must select originals without destroying live pipelines")
    require(re.search(
        r"void\s+OnPresetChanged\(\)\s*\{[\s\S]*?"
        r"HandleOutputModeSetting\(requested_output_mode\);[\s\S]*?"
        r"OnPeakBrightnessSettingsChanged\(\);[\s\S]*?\}",
        addon,
    ) is not None,
            "preset changes must resynchronize output status and effective peak")
    require(re.search(
        r"on_preset_changed_callbacks\.emplace_back\(\s*"
        r"&OnPresetChanged\s*\);",
        addon,
    ) is not None,
            "DOOM must register its post-load preset synchronization callback")
    require(re.search(
        r"void\s+OnPeakBrightnessSettingsChanged\(\)\s*\{[\s\S]*?"
        r"RefreshDetectedPeak\(swapchain\);[\s\S]*?"
        r"ResolvePeakBrightness\(\);[\s\S]*?\}",
        addon,
    ) is not None,
            "Auto/Manual peak settings must resolve immediately after preset load")
    require("inverse_tonemap" not in (common + output).lower(),
            "final-frame inverse tone mapping is forbidden")
    require("scene_path_active" in output and "samp_tex0" in output,
            "scene/UI final-output gating is missing")
    require("pq::EncodeSafe" in output,
            "final HDR10 PQ encoder is missing")
    proxy = (source_dir / "swap_chain_proxy_pixel_shader.frag.slang").read_text(
        encoding="utf-8"
    )
    require("SwapChainPass" not in proxy and "renodx::" not in proxy,
            "proxy must only copy already encoded PQ values")
    require("use_resource_cloning = true" in addon,
            "HDR10 must preserve DOOM's game-facing backbuffer through a clone")
    require("swap_chain_proxy_format" in addon and "r16g16b16a16_float" in addon,
            "RGBA16F proxy format contract is missing")

    print("DOOM 2016 source/provenance contract: PASS")


if __name__ == "__main__":
    main()
