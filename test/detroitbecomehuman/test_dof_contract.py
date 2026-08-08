import argparse
import re
from pathlib import Path


DOF_SHADERS = {
    "0xE9907978": "dof_split_0xE9907978.comp.slang",
    "0x747E19D2": "dof_gather_0x747E19D2.comp.slang",
    "0x508514FB": "dof_fill_0x508514FB.comp.slang",
    "0xAC7A8193": "dof_composite_0xAC7A8193.comp.slang",
}


def require(text, pattern, description):
    if re.search(pattern, text, flags=re.MULTILINE | re.DOTALL) is None:
        raise AssertionError(description)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-dir", required=True, type=Path)
    args = parser.parse_args()
    source_dir = args.source_dir.resolve()

    shared = (source_dir / "shared.h").read_text(encoding="utf-8")
    require(shared, r"float\s+dof_runtime_mode\s*;", "DOF runtime mode field is missing")
    require(
        shared,
        r"static_assert\(sizeof\(ShaderInjectData\)\s*==\s*112u\)",
        "ShaderInjectData must remain 112 bytes",
    )
    require(
        shared,
        r"CUSTOM_DOF_PACKED_BITS[\s\S]*?floatBitsToUint\(shader_injection\.dof_runtime_mode\)[\s\S]*?CUSTOM_DOF_RUNTIME_MODE[\s\S]*?0x7u",
        "packed DOF runtime/control decoder is missing",
    )

    addon = (source_dir / "addon.cpp").read_text(encoding="utf-8")
    for shader_hash in DOF_SHADERS:
        require(
            addon,
            rf"kDof\w+ShaderCrc[\s\S]*?\.code\s*=\s*__{shader_hash}",
            f"{shader_hash} is not embedded in the addon registry",
        )
    if re.search(r"OnDof\w+Replace|kDof\w+ShaderCrc[\s\S]{0,300}\.on_replace", addon):
        raise AssertionError("DOF mode must not toggle replacement pipelines with on_replace")
    require(
        addon,
        r'\.key\s*=\s*"DepthOfFieldMode"[\s\S]*?\.default_value\s*=\s*0\.f[\s\S]*?\.labels\s*=\s*\{"Vanilla",\s*"Clean",\s*"Cinematic"\}',
        "DepthOfFieldMode must expose Vanilla, Clean, and Cinematic with Vanilla as default",
    )
    require(
        addon,
        r'\.key\s*=\s*"DepthOfFieldQuality"[\s\S]*?\.default_value\s*=\s*1\.f',
        "DepthOfFieldQuality must default to High",
    )
    require(
        addon,
        r"VerifySupportedExecutable\(\)[\s\S]*?FinishFrame\([\s\S]*?IsDofSupportedBuild\(\)",
        "Enhanced mode must use the complete-chain supported-build gate",
    )
    require(
        addon,
        r"PackRuntimePayload\([\s\S]*?focus_distance_percent[\s\S]*?blur_radius_percent[\s\S]*?near_strength_percent[\s\S]*?far_strength_percent[\s\S]*?edge_bokeh_percent",
        "DOF controls must be packed into the existing 112-byte payload",
    )
    for key in (
        "DepthOfFieldFocusDistance",
        "DepthOfFieldBlurRadius",
        "DepthOfFieldNearStrength",
        "DepthOfFieldFarStrength",
        "DepthOfFieldEdgeBokeh",
    ):
        require(
            addon,
            rf'\.key\s*=\s*"{key}"[\s\S]*?\.default_value\s*=\s*100\.f',
            f"{key} must exist with a neutral default",
        )

    sources = {}
    for shader_hash, filename in DOF_SHADERS.items():
        source = (source_dir / filename).read_text(encoding="utf-8")
        sources[shader_hash] = source
        require(source, r'#include\s+"shared\.h"', f"{shader_hash} lacks injected settings")
        require(
            source,
            r"local_size_x\s*=\s*8[\s\S]*?local_size_y\s*=\s*8",
            f"{shader_hash} workgroup changed",
        )
        if "TEMP" in source:
            raise AssertionError(f"{shader_hash} still contains a temporary diagnostic")

    require(
        sources["0xE9907978"],
        r"refineNear[\s\S]*?ComputeNearCoc[\s\S]*?refineFar[\s\S]*?ComputeFarCoc",
        "split pass must preserve the native local-depth refinement",
    )
    require(
        sources["0xE9907978"],
        r"return\s+coc\s*\*\s*CUSTOM_DOF_RADIUS_SCALE\s*;",
        "enhanced blur radius must scale beyond the native maximum",
    )
    require(
        sources["0x747E19D2"],
        r"nearRadiusCoc\s*=\s*enhanced[\s\S]*?localNearCoc[\s\S]*?nativeRadiusCoc\.x[\s\S]*?farRadius\s*=\s*localFarCoc\s*\*\s*8\.0",
        "gather pass must use controlled local radii only outside Vanilla",
    )
    require(
        sources["0x508514FB"],
        r"sNativePrepassCoc\.x\s*\*\s*fillRadiusScale\s*\*\s*8\.0\)\s*>\s*3\.0[\s\S]*?sNativePrepassCoc\.y\s*\*\s*fillRadiusScale\s*\*\s*8\.0\)\s*>\s*3\.0",
        "fill pass must preserve the authored threshold while applying the enhanced radius control",
    )
    require(
        sources["0xAC7A8193"],
        r"cinematic\s*=\s*CUSTOM_DOF_RUNTIME_MODE\s*>=\s*2\.5[\s\S]*?if\s*\(!cinematic\)[\s\S]*?return\s+farResult[\s\S]*?ResolveNearBalanced[\s\S]*?nearLayer\.w",
        "Clean must exclude low-resolution near coverage while Cinematic restores it",
    )
    require(
        sources["0xAC7A8193"],
        r"ResolveFullResolutionFar\([\s\S]*?fillOccludedSamples[\s\S]*?occludedFallbackColor[\s\S]*?texelFetch\(depthMap[\s\S]*?texelFetch\(accumBufferMap",
        "Clean and Cinematic must resolve far CoC from full-resolution depth",
    )
    require(
        sources["0xAC7A8193"],
        r"sampleCount\s*=\s*highQuality\s*\?\s*49\s*:\s*4[\s\S]*?interpolationCount\s*=\s*highQuality\s*\?\s*4\s*:\s*1",
        "High must use the complete 49-tap aperture kernel with depth-aware subpixel interpolation",
    )
    require(
        sources["0xAC7A8193"],
        r"farLayer\.xyz[\s\S]*?farSupport[\s\S]*?CUSTOM_DOF_EDGE_BOKEH_SCALE[\s\S]*?smoothstep\(5\.0,\s*8\.0,\s*farCoc\)",
        "Cinematic must restore authored hidden-background and deep-bokeh color",
    )
    if "farLayer.w" in sources["0xAC7A8193"]:
        raise AssertionError("Cinematic must not restore the low-resolution far alpha mask")

    print("PASS: Detroit native DOF v2 source contract")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (AssertionError, OSError) as error:
        print(f"FAIL: {error}")
        raise SystemExit(1)
