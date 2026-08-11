import argparse
import hashlib
import math
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


def validate_retinal_linear_gaussian_math():
    for sigma in (0.001, 0.125, 0.5, 1.0, 2.75, 8.0):
        radius = min(math.ceil(4.0 * sigma), 32)
        inverse_variance = 1.0 / (sigma * sigma)
        step = math.exp(-0.5 * inverse_variance)
        step_ratio = math.exp(-inverse_variance)
        previous_weight = 1.0
        recurrence = [1.0]
        for first_offset in range(1, radius + 1, 2):
            first_weight = previous_weight * step
            step *= step_ratio
            recurrence.append(first_weight)
            second_offset = first_offset + 1
            if second_offset <= radius:
                second_weight = first_weight * step
                step *= step_ratio
                previous_weight = second_weight
                recurrence.append(second_weight)

                pair_weight = first_weight + second_weight
                paired_offset = (
                    first_offset * first_weight
                    + second_offset * second_weight
                ) / pair_weight
                fraction = paired_offset - first_offset
                first_sample = math.sin(first_offset * 0.37)
                second_sample = math.cos(second_offset * 0.23)
                linear_sample = (
                    first_sample * (1.0 - fraction)
                    + second_sample * fraction
                )
                paired_sum = linear_sample * pair_weight
                direct_sum = (
                    first_sample * first_weight
                    + second_sample * second_weight
                )
                if not math.isclose(
                    paired_sum, direct_sum, rel_tol=1.0e-12, abs_tol=1.0e-12
                ):
                    raise AssertionError(
                        "paired hardware-linear Gaussian taps changed the kernel"
                    )

        direct = [
            math.exp(-(offset * offset) / (2.0 * sigma * sigma))
            for offset in range(radius + 1)
        ]
        if any(
            not math.isclose(actual, expected, rel_tol=1.0e-12, abs_tol=1.0e-15)
            for actual, expected in zip(recurrence, direct)
        ):
            raise AssertionError("Gaussian weight recurrence changed the kernel")

    if 1 + 2 * math.ceil(32 / 2) != 33:
        raise AssertionError("maximum paired Retinal fetch count must remain 33")


def validate_vanilla_transition_blend_math():
    def transition_coverage(far_coc, authored_coverage, control, strength=1.0):
        clean = min(max(far_coc, 0.0), 1.0) * strength
        authored = authored_coverage * strength if far_coc > 1.0 else clean
        return clean + (authored - clean) * control

    for control in (0.0, 0.25, 0.5, 1.0):
        expected = 1.0 + (0.2 - 1.0) * control
        if not math.isclose(
            transition_coverage(4.0, 0.2, control),
            expected,
            rel_tol=0.0,
            abs_tol=1.0e-12,
        ):
            raise AssertionError("Vanilla transition blend must remain linear in the control")

    for control in (0.0, 0.5, 1.0):
        if transition_coverage(0.0, 1.0, control) != 0.0:
            raise AssertionError("zero full-resolution far CoC must remain sharp")
        if transition_coverage(0.5, 0.0, control) != 0.5:
            raise AssertionError("sub-pixel far CoC must use the original continuous CoC blend")

    if transition_coverage(4.0, 0.25, 0.0) != 1.0:
        raise AssertionError("Clean must retain its precise full-resolution coverage")
    if transition_coverage(4.0, 0.25, 1.0) != 0.25:
        raise AssertionError("Cinematic must recover Gather's authored aperture coverage")

    def smoothstep(minimum, maximum, value):
        t = min(max((value - minimum) / (maximum - minimum), 0.0), 1.0)
        return t * t * (3.0 - 2.0 * t)

    def small_coc_weight(far_coc, strength=1.0):
        return min(max(smoothstep(0.35, 1.5, far_coc) * strength, 0.0), 1.0)

    def reduced_resolution_progress(far_coc):
        return smoothstep(1.0, 2.5, far_coc)

    if small_coc_weight(0.35) != 0.0 or small_coc_weight(1.5) != 1.0:
        raise AssertionError("full-resolution small-CoC blur must bridge 0.35..1.5 px")
    if (
        reduced_resolution_progress(1.0) != 0.0
        or reduced_resolution_progress(2.5) != 1.0
    ):
        raise AssertionError("reduced-resolution bokeh must take over across 1.0..2.5 px")

    epsilon = 1.0e-5
    if small_coc_weight(0.35 + epsilon) > 1.0e-8:
        raise AssertionError("small-CoC bridge must start with a zero-slope endpoint")
    if reduced_resolution_progress(1.0 + epsilon) > 1.0e-8:
        raise AssertionError("FarDofMap handoff must start with a zero-slope endpoint")
    if 1.0 - reduced_resolution_progress(2.5 - epsilon) > 1.0e-8:
        raise AssertionError("FarDofMap handoff must end with a zero-slope endpoint")

    corner_weight = 0.5453
    side_weight = 0.9717
    circle_kernel_sum = 1.0 + 4.0 * corner_weight + 4.0 * side_weight
    if not math.isclose(circle_kernel_sum, 7.068, rel_tol=0.0, abs_tol=1.0e-6):
        raise AssertionError("full-resolution 3x3 circle kernel changed")

    def coc_compatibility(center_coc, sample_coc):
        return 1.0 - smoothstep(0.5, 1.5, abs(sample_coc - center_coc))

    def same_far_layer(sample_coc):
        return smoothstep(0.0, 0.25, sample_coc)

    if coc_compatibility(1.0, 1.0) != 1.0:
        raise AssertionError("small-CoC bridge must retain same-layer samples")
    if coc_compatibility(1.0, 8.0) != 0.0:
        raise AssertionError("small-CoC bridge must reject deep-background leakage")
    if same_far_layer(0.0) != 0.0 or same_far_layer(0.25) != 1.0:
        raise AssertionError("small-CoC far-layer membership must feather across 0..0.25 px")
    if not 0.0 < same_far_layer(0.125) < 1.0:
        raise AssertionError("small-CoC far-layer membership must not be binary")

    def high_output(far_coc, sharp, small_blur, far_layer, layer_coverage):
        small_result = sharp + (small_blur - sharp) * small_coc_weight(far_coc)
        authored_result = sharp + (far_layer - sharp) * layer_coverage
        reduced_progress = reduced_resolution_progress(far_coc)
        return small_result + (authored_result - small_result) * reduced_progress

    for far_coc in (0.0, 0.35, 0.5, 1.0):
        a = high_output(far_coc, 0.2, 0.4, 0.0, 1.0)
        b = high_output(far_coc, 0.2, 0.4, 1.0, 1.0)
        if a != b:
            raise AssertionError("FarDofMap RGB leaked into the small-CoC bridge")
    if high_output(1.5, 0.2, 0.4, 0.0, 1.0) == high_output(
        1.5, 0.2, 0.4, 1.0, 1.0
    ):
        raise AssertionError("FarDofMap must overlap the full-resolution bridge")

    for boundary in (0.35, 1.0, 1.5, 2.5):
        epsilon = 1.0e-6
        left = high_output(boundary - epsilon, 0.2, 0.4, 0.8, 0.35)
        right = high_output(boundary + epsilon, 0.2, 0.4, 0.8, 0.35)
        if abs(left - right) > 2.0e-6:
            raise AssertionError("small-CoC to FarDofMap handoff is discontinuous")


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
    require(
        shared,
        r"CUSTOM_DOF_FILL_EDGE_AWARE_COC[\s\S]*?>>\s*26u[\s\S]*?"
        r"CUSTOM_DOF_FILL_ADAPTIVE_TRANSITION[\s\S]*?>>\s*27u[\s\S]*?"
        r"CUSTOM_DOF_FILL_DENSE_RGB[\s\S]*?>>\s*28u",
        "optional High Fill quality flags are not decoded from the packed payload",
    )

    addon = (source_dir / "addon.cpp").read_text(encoding="utf-8")
    dof_runtime = (source_dir / "dof_runtime.hpp").read_text(encoding="utf-8")
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
        r'\.key\s*=\s*"DepthOfFieldMode"[\s\S]*?\.default_value\s*=\s*0\.f[\s\S]*?\.labels\s*=\s*\{"Vanilla",\s*"Clean",\s*"Cinematic",\s*"Retinal"\}',
        "DepthOfFieldMode must expose Vanilla, Clean, Cinematic, and Retinal with Vanilla as default",
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
        r"PackRuntimePayload\([\s\S]*?focus_distance_percent[\s\S]*?blur_radius_percent[\s\S]*?far_strength_percent[\s\S]*?vanilla_transition_percent"
        r"[\s\S]*?fill_edge_aware_coc[\s\S]*?fill_adaptive_transition[\s\S]*?fill_dense_rgb",
        "remaining DOF controls must be packed into the existing 112-byte payload",
    )
    if "near_strength_percent" in dof_runtime or "near_strength_percent" in addon:
        raise AssertionError("authored foreground bokeh must not be runtime-configurable")
    if "DepthOfFieldNearStrength" in addon or "Foreground Bokeh" in addon:
        raise AssertionError("Foreground Bokeh must not be exposed in RenoDX settings")
    require(
        dof_runtime,
        r"kVanillaTransitionShift\s*=\s*16u[\s\S]*?kVanillaTransitionMask\s*=\s*0x1Fu"
        r"[\s\S]*?kVanillaTransitionDefault\s*=[\s\S]*?kVanillaTransitionMask"
        r"[\s\S]*?kFillEdgeAwareCocShift\s*=\s*26u"
        r"[\s\S]*?kFillAdaptiveTransitionShift\s*=\s*27u"
        r"[\s\S]*?kFillDenseRgbShift\s*=\s*28u"
        r"[\s\S]*?kReservedHighShift\s*=\s*29u[\s\S]*?kReservedHighMask\s*=\s*0x7u"
        r"[\s\S]*?QuantizeVanillaTransition\(controls\.vanilla_transition_percent\)"
        r"[\s\S]*?<<\s*kVanillaTransitionShift"
        r"[\s\S]*?fill_edge_aware_coc[\s\S]*?fill_adaptive_transition[\s\S]*?fill_dense_rgb",
        "DOF payload must retain Vanilla transition and pack three optional Fill quality flags",
    )
    for key in (
        "DepthOfFieldFocusDistance",
        "DepthOfFieldBlurRadius",
        "DepthOfFieldFarStrength",
    ):
        require(
            addon,
            rf'\.key\s*=\s*"{key}"[\s\S]*?\.default_value\s*=\s*100\.f',
            f"{key} must exist with a neutral default",
        )
    require(
        addon,
        r'\.key\s*=\s*"DepthOfFieldVanillaTransition"'
        r"[\s\S]*?\.default_value\s*=\s*100\.f"
        r"[\s\S]*?\.min\s*=\s*0\.f[\s\S]*?\.max\s*=\s*100\.f"
        r"[\s\S]*?\.format\s*=\s*\"%\.0f%%\""
        r"[\s\S]*?\.is_enabled\s*=\s*\[\]\(\)\s*\{\s*return\s+dof_mode\s*>=\s*1\.5f",
        "Vanilla Transition Blend UI must expose 0..100 percent with a neutral default",
    )
    require(
        addon,
        r'\.key\s*=\s*"DepthOfFieldVanillaTransition"'
        r"[\s\S]*?authored Gather coverage"
        r"[\s\S]*?fractional R8 alpha preserved by Fill"
        r"[\s\S]*?full-resolution 3x3"
        r"[\s\S]*?full-resolution CoC keeps focused foreground pixels outside the far layer",
        "Vanilla Transition tooltip must describe authored coverage and the small-CoC bridge",
    )
    if re.search(r'\.key\s*=\s*"DepthOfFieldEdgeBokeh"\s*,', addon):
        raise AssertionError("legacy percentage Edge Bokeh key must not remain active")
    if "DepthOfFieldEdgeBokehWidth" in addon:
        raise AssertionError("geometric Edge Bokeh Width must not remain active")
    for key, current_label, enhanced_label in (
        (
            "DepthOfFieldFillCocReconstruction",
            "Bilinear (Current)",
            "Edge-aware 3x3",
        ),
        ("DepthOfFieldFillTransition", "Fixed 2-4 (Current)", "Adaptive"),
        (
            "DepthOfFieldFillRgbReconstruction",
            "3x3 (Current)",
            "Dense 5x5",
        ),
    ):
        require(
            addon,
            rf'\.key\s*=\s*"{key}"[\s\S]*?\.default_value\s*=\s*0\.f'
            rf'[\s\S]*?"{re.escape(current_label)}"[\s\S]*?"{re.escape(enhanced_label)}"'
            r"[\s\S]*?dof_quality\s*>=\s*0\.5f",
            f"{key} must preserve the current High Fill method as its default",
        )
    for key in (
        "RetinalFixationX",
        "RetinalFixationY",
        "RetinalStrength",
        "RetinalHorizontalFov",
        "RetinalMaximumSigma",
    ):
        require(addon, rf'\.key\s*=\s*"{key}"', f"{key} must be exposed")

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

    composite_source = sources["0xAC7A8193"]
    vanilla_start = composite_source.index("vec3 CompositeVanilla")
    vanilla_end = composite_source.index("vec3 CompositeEnhanced", vanilla_start)
    vanilla_digest = hashlib.sha256(
        composite_source[vanilla_start:vanilla_end].encode("utf-8")
    ).hexdigest()
    if vanilla_digest != (
        "5017e52a28e15f3d9a2fc5cbbd3e807bcc26b82d6b37c79f9b6b8446b7d70453"
    ):
        raise AssertionError(
            "CompositeVanilla source/order changed from the accepted exact port"
        )

    require(
        sources["0xE9907978"],
        r"ComputeNativeNearCoc[\s\S]*?refineNear\s*=\s*\(coarseNearMax\s*-\s*coarseNearMin\)\s*>\s*0\.125[\s\S]*?if\s*\(coarseNear\)[\s\S]*?enhanced[\s\S]*?ComputeNativeNearCoc\(depths\[i\]\)[\s\S]*?imageStore\(OutputTexColorNear[\s\S]*?imageStore\(OutputTexCocNear",
        "split must produce authored native near CoC/color in every mode",
    )
    require(
        sources["0xE9907978"],
        r"return\s+coc\s*\*\s*CUSTOM_DOF_RADIUS_SCALE\s*;",
        "enhanced blur radius must scale beyond the native maximum",
    )
    require(
        sources["0x747E19D2"],
        r"if\s*\(hasNear\)[\s\S]*?sampleCoc\s*=\s*sPrepassFlags\.z[\s\S]*?textureLod\(dofCocMapNear[\s\S]*?imageStore\(\s*OutTexColorNear[\s\S]*?imageStore\(\s*OutTexAlphaNear[\s\S]*?farRadius\s*=\s*localFarCoc\s*\*\s*8\.0",
        "gather must preserve authored native near color/alpha in every mode",
    )
    require(
        sources["0x508514FB"],
        r"farFillRadiusScale\s*=\s*CUSTOM_DOF_RUNTIME_MODE\s*>=\s*0\.5"
        r"[\s\S]*?sNativePrepassCoc\.x\s*\*\s*8\.0\)\s*>\s*3\.0"
        r"[\s\S]*?FilterNear\(uv,\s*sNativePrepassCoc\.x\)"
        r"[\s\S]*?texelFetch\(dofAlphaMapNear"
        r"[\s\S]*?if\s*\(highQuality\)"
        r"[\s\S]*?prepassPosition\s*=\s*\(pixelF\s*\+\s*vec2\(0\.5\)\)"
        r"[\s\S]*?_vCoCScaleFactor\.xy\s*-\s*vec2\(0\.5\)"
        r"[\s\S]*?farCoc00\s*=\s*texelFetch\("
        r"[\s\S]*?farCoc10\s*=\s*texelFetch\("
        r"[\s\S]*?farCoc01\s*=\s*texelFetch\("
        r"[\s\S]*?farCoc11\s*=\s*texelFetch\("
        r"[\s\S]*?CUSTOM_DOF_FILL_EDGE_AWARE_COC"
        r"[\s\S]*?cocSum\s*=\s*interpolatedFarCoc\s*\*\s*2\.0"
        r"[\s\S]*?smoothstep\([\s\S]*?abs\(sampleFarCoc\s*-\s*interpolatedFarCoc\)"
        r"[\s\S]*?clamp\([\s\S]*?localMinimum[\s\S]*?localMaximum"
        r"[\s\S]*?CUSTOM_DOF_FILL_ADAPTIVE_TRANSITION"
        r"[\s\S]*?fillWeight\s*=\s*smoothstep\(\s*fillStart,\s*fillEnd,"
        r"[\s\S]*?CUSTOM_DOF_FILL_DENSE_RGB"
        r"[\s\S]*?FilterFarDense5x5\(\s*uv,\s*interpolatedFarCoc\)"
        r"[\s\S]*?FilterFar\(uv,\s*interpolatedFarCoc\)"
        r"[\s\S]*?farColor\s*=\s*mix\(farCenter,\s*filledFarColor,\s*vec3\(fillWeight\)\)"
        r"[\s\S]*?else\s+if\s*\(\(sNativePrepassCoc\.y\s*\*\s*farFillRadiusScale\s*\*\s*8\.0\)\s*>\s*3\.0\)"
        r"[\s\S]*?vec4\(farColor,\s*texelFetch\(dofAlphaMapFar",
        "High Fill must expose current and optional quality paths while preserving native near and authored alpha",
    )
    for forbidden in (
        "kDiagnosticAuthoredFarOnly",
        "Temporary High-quality isolation",
    ):
        if forbidden in sources["0x508514FB"] or forbidden in sources["0xAC7A8193"]:
            raise AssertionError(f"temporary DOF diagnostic must be removed: {forbidden}")
    require(
        sources["0xAC7A8193"],
        r"runtimeMode\s*=\s*uint\(CUSTOM_DOF_RUNTIME_MODE\s*\+\s*0\.5\)[\s\S]*?cinematic\s*=\s*runtimeMode\s*==\s*3u[\s\S]*?runtimeMode\s*==\s*6u[\s\S]*?highQuality\s*=\s*runtimeMode\s*==\s*2u[\s\S]*?runtimeMode\s*==\s*6u[\s\S]*?NearDofMap[\s\S]*?nearSamples\[i\]\.w\s*>\s*0\.0[\s\S]*?return\s+mix\(farResult,\s*resolvedNear\.xyz,\s*vec3\(resolvedNear\.w\)\)",
        "Enhanced modes must retain style/quality predicates and composite authored near color/alpha after far",
    )
    for forbidden in (
        "ResolveNearBalanced",
        "ResolveNearHigh",
        "CUSTOM_DOF_NEAR_STRENGTH",
    ):
        if forbidden in sources["0xAC7A8193"]:
            raise AssertionError(
                f"Enhanced foreground bokeh must remain authored, not custom: {forbidden}"
            )
    require(
        sources["0xAC7A8193"],
        r"else\s+if\s*\(CUSTOM_DOF_RUNTIME_MODE\s*<\s*0\.5\)[\s\S]*?CompositeVanilla",
        "literal-zero Vanilla must retain its original composite branch",
    )
    require(
        sources["0xAC7A8193"],
        r"ResolveFarBalanced\([\s\S]*?authoredCoverage\s*=\s*clamp\(sampleValue\.w,\s*0\.0,\s*1\.0\)"
        r"[\s\S]*?colorWeight\s*=\s*weights\[i\]\s*\*\s*float\(authoredCoverage\s*>\s*0\.0\)"
        r"[\s\S]*?alphaSum\s*\+=\s*authoredCoverage\s*\*\s*weights\[i\]",
        "enhanced resolve must retain Vanilla RGB normalization and fractional alpha",
    )
    require(
        sources["0xAC7A8193"],
        r"ResolveFullResolutionSmallCoc\([\s\S]*?cornerWeight\s*=\s*0\.5453"
        r"[\s\S]*?sideWeight\s*=\s*0\.9717"
        r"[\s\S]*?sampleDepth\s*=\s*LinearizeDepth"
        r"[\s\S]*?sampleFarCoc\s*=\s*ComputeFarCoc16"
        r"[\s\S]*?sameFarLayer\s*=\s*smoothstep\(\s*0\.0,\s*0\.25,\s*sampleFarCoc\s*\)"
        r"[\s\S]*?smoothstep\(\s*0\.5,\s*1\.5,"
        r"[\s\S]*?texelFetch\(accumBufferMap,\s*samplePixel,\s*0\)\.xyz",
        "High must reconstruct small CoC from full-resolution color with CoC rejection",
    )
    small_coc_start = composite_source.index("vec3 ResolveFullResolutionSmallCoc")
    small_coc_end = composite_source.index("vec2 ResolveGatherFillCoverage", small_coc_start)
    if "FarDofMap" in composite_source[small_coc_start:small_coc_end]:
        raise AssertionError("small-CoC bridge must not sample reduced-resolution FarDofMap")
    for forbidden in (
        "ResolveApertureFarTransition",
        "CocCompatibility",
        "FarCocAtDofPixel",
        "filteredCoarseFarCoc",
        "transitionCoc",
        "coarsePosition",
        "ResolveFarCoverageHigh",
    ):
        if forbidden in sources["0xAC7A8193"]:
            raise AssertionError(
                f"Cinematic transition must not spread coarse CoC onto foreground: {forbidden}"
            )
    require(
        sources["0xAC7A8193"],
        r"vanillaTransitionControl\s*=\s*cinematic"
        r"[\s\S]*?CUSTOM_DOF_VANILLA_TRANSITION"
        r"[\s\S]*?if\s*\(farCoc\s*>\s*0\.0\)"
        r"[\s\S]*?farLayer\s*=\s*ResolveFarBalanced\(dofPosition,\s*sharpColor\)"
        r"[\s\S]*?cleanCoverage\s*=\s*clamp\("
        r"[\s\S]*?if\s*\(vanillaTransitionControl\s*>\s*0\.0\)"
        r"[\s\S]*?authoredTransitionCoverage\s*=\s*farCoc\s*>\s*1\.0"
        r"[\s\S]*?farLayer\.w\s*\*\s*CUSTOM_DOF_FAR_STRENGTH"
        r"[\s\S]*?transitionCoverage\s*=\s*mix\("
        r"[\s\S]*?if\s*\(highQuality\)"
        r"[\s\S]*?smoothstep\(\s*0\.35,\s*1\.5,\s*farCoc\s*\)"
        r"[\s\S]*?smoothstep\(\s*1\.0,\s*2\.5,\s*farCoc\s*\)"
        r"[\s\S]*?if\s*\(reducedResolutionProgress\s*<\s*1\.0\)"
        r"[\s\S]*?smallCocColor\s*=\s*ResolveFullResolutionSmallCoc"
        r"[\s\S]*?authoredFarResult\s*=\s*mix\("
        r"[\s\S]*?sharpColor"
        r"[\s\S]*?farLayer\.xyz"
        r"[\s\S]*?vec3\(transitionCoverage\)"
        r"[\s\S]*?farResult\s*=\s*mix\("
        r"[\s\S]*?smallCocResult"
        r"[\s\S]*?authoredFarResult"
        r"[\s\S]*?vec3\(reducedResolutionProgress\)",
        "High must hand off between complete small-CoC and authored far composites",
    )
    if "if (!highQuality || farCoc > 1.5)" in sources["0xAC7A8193"]:
        raise AssertionError("High must not conditionally create FarDofMap at the handoff")
    require(
        sources["0xAC7A8193"],
        r"RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTROL"
        r"[\s\S]*?CUSTOM_DOF_VANILLA_TRANSITION"
        r"[\s\S]*?RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTRIBUTION"
        r"[\s\S]*?debugValue\.x\s*=\s*finalVanillaTransition",
        "Render Debug must expose the decoded Vanilla transition and its final contribution",
    )
    for forbidden in (
        "ResolveFarEdgeIntrusion",
        "ComputeFarEdgeCandidateCoverage",
        "kFarEdge",
        "edgeWidthPixels",
        "CUSTOM_DOF_EDGE_WIDTH_PIXELS",
    ):
        if forbidden in sources["0xAC7A8193"]:
            raise AssertionError(
                f"geometric Edge Bokeh must not remain in Cinematic: {forbidden}"
            )
    validate_vanilla_transition_blend_math()

    for filename in (
        "retinal_horizontal.comp.slang",
        "retinal_vertical.comp.slang",
    ):
        retinal_shader = (source_dir / filename).read_text(encoding="utf-8")
        require(
            retinal_shader,
            r'#include\s+"retinal_filter_common\.slang"',
            f"{filename} must use the shared Watson filter",
        )
    retinal_common = (source_dir / "retinal_filter_common.slang").read_text(
        encoding="utf-8"
    )
    require(
        retinal_common,
        r"local_size_x\s*=\s*8[\s\S]*?local_size_y\s*=\s*8[\s\S]*?"
        r"ComputeRetinalNyquist[\s\S]*?ComputeAxisSigmas[\s\S]*?"
        r"FilterLinearGaussian[\s\S]*?FilterBalanced[\s\S]*?FilterHigh",
        "Retinal shaders must retain 8x8 Watson Balanced and High paths",
    )
    require(
        retinal_common,
        r"weightStep\s*=\s*exp\(-0\.5\s*\*\s*inverseVariance\)"
        r"[\s\S]*?weightStepRatio\s*=\s*exp\(-inverseVariance\)"
        r"[\s\S]*?SampleSource\(pixel,\s*pairedOffset\)"
        r"[\s\S]*?SampleSource\(pixel,\s*-pairedOffset\)",
        "Retinal Gaussian taps must use the two-exp recurrence and linear pairs",
    )
    require(
        retinal_common,
        r"RETINAL_FILTER_HORIZONTAL[\s\S]*?vec4\(result,\s*axisSigmas\.y\)"
        r"[\s\S]*?#else[\s\S]*?vec4\(result,\s*1\.0\)",
        "Retinal scratch alpha must carry vertical sigma and restore alpha one",
    )
    require(
        sources["0xAC7A8193"],
        r"imageStore\(OutputTex,\s*pixel,\s*vec4\(outputColor,\s*1\.0\)\)",
        "Retinal sigma caching requires the composite alpha-one contract",
    )
    validate_retinal_linear_gaussian_math()

    capture = (source_dir / "retinal_capture.hpp").read_text(encoding="utf-8")
    require(
        capture,
        r"push_constant_size\s*!=\s*kShaderInjectDataSize[\s\S]*?"
        r"ReleaseDofCompositeImageSnapshot[\s\S]*?"
        r"RestoreDofCompositeComputeState",
        "Retinal capture must validate and restore the native push payload",
    )
    runtime = (source_dir / "retinal_runtime.hpp").read_text(encoding="utf-8")
    require(
        runtime,
        r"owner_device_\s*!=\s*nullptr[\s\S]*?owner_device_\s*!=\s*device[\s\S]*?"
        r"std::recursive_mutex\s+mutex_",
        "Retinal GPU resources must remain owned by one Vulkan device",
    )
    require(
        runtime,
        r"tan_half_horizontal\s*=\s*std::tan[\s\S]*?"
        r"tan_half_vertical\s*=[\s\S]*?vertical_angle\s*=\s*2\.f\s*\*\s*std::atan"
        r"[\s\S]*?horizontal_pixels_per_degree[\s\S]*?"
        r"vertical_pixels_per_degree",
        "Retinal FOV geometry and pixels-per-degree must be precomputed on CPU",
    )
    require(
        addon,
        r"retinal_effect_strength[\s\S]*?retinal_sigma[\s\S]*?"
        r"kBypassedZeroEffect[\s\S]*?CaptureCompositeOutput",
        "zero Retinal strength or sigma must bypass capture and both dispatches",
    )
    vulkan_layer = (source_dir / "dlss" / "vulkan_layer.cpp").read_text(
        encoding="utf-8"
    )
    require(
        vulkan_layer,
        r"next_cmd_push_constants\([\s\S]*?snapshot\.push_constant_size[\s\S]*?"
        r"push_constant_data\)",
        "native restore must repush the complete ShaderInjectData payload",
    )
    require(
        vulkan_layer,
        r"InsertComputeWriteBarrier\(std::uint64_t\s+command_buffer\)[\s\S]*?"
        r"FindDeviceSharedFast\(vk_command_buffer\)",
        "Retinal barriers must retain the device resolved from the exact command buffer",
    )

    print("PASS: Detroit native DOF v2 source contract")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (AssertionError, OSError) as error:
        print(f"FAIL: {error}")
        raise SystemExit(1)
