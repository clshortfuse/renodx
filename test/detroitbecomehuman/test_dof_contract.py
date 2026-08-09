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


def validate_edge_bokeh_mapping_math():
    def mapping(width_pixels, far_coc=16.0):
        radius = width_pixels
        # Positive Far CoC gates candidate validity and authored color only;
        # the pixel control itself is an exact geometric reach.
        local_width = width_pixels if far_coc > 0.0 else 0.0
        opacity = 0.0 if width_pixels <= 0.0 else 0.60
        coverage = min(max(far_coc, 0.0), 1.0) * opacity
        return radius, local_width, coverage

    expected = {
        0.0: (0.0, 0.0, 0.0),
        8.0: (8.0, 8.0, 0.60),
        16.0: (16.0, 16.0, 0.60),
    }
    for width_pixels, values in expected.items():
        actual = mapping(width_pixels)
        if any(
            not math.isclose(value, target, rel_tol=0.0, abs_tol=1.0e-12)
            for value, target in zip(actual, values)
        ):
            raise AssertionError("Edge Bokeh 0/8/16 px mapping changed")

    previous = mapping(0.0)
    for width_pixels in range(1, 17):
        current = mapping(float(width_pixels))
        if any(value < prior for value, prior in zip(current, previous)):
            raise AssertionError("Edge Bokeh mapping must remain monotonic")
        previous = current

    for far_coc in (0.25, 1.0, 4.0, 8.0, 16.0, 32.0):
        default_width = mapping(8.0, far_coc)[1]
        maximum_width = mapping(16.0, far_coc)[1]
        if not math.isclose(default_width, 8.0):
            raise AssertionError("default Edge width must remain exactly 8 px")
        if not math.isclose(maximum_width, 16.0):
            raise AssertionError("maximum Edge width must remain exactly 16 px")

    def radial_coverage(width_pixels, sample_distance):
        effective_distance = max(sample_distance - 0.5, 0.0)
        t = min(
            max(
                effective_distance / max(width_pixels, 1.0),
                0.0,
            ),
            1.0,
        )
        smooth = t * t * (3.0 - 2.0 * t)
        return 1.0 - smooth

    for width_pixels in (1.0, 8.0):
        if radial_coverage(width_pixels, width_pixels) <= 0.0:
            raise AssertionError("Edge width must reach its final pixel-center ring")
        if radial_coverage(width_pixels, width_pixels + 1.0) != 0.0:
            raise AssertionError("Edge width must stop before the next pixel ring")

    # Sixteen equal-angle directions cover the circle at 22.5-degree steps.
    directions = [
        (math.cos(index * math.tau / 16.0), math.sin(index * math.tau / 16.0))
        for index in range(16)
    ]
    for index, direction in enumerate(directions):
        opposite = directions[(index + 8) % 16]
        if not math.isclose(math.hypot(*direction), 1.0, abs_tol=1.0e-12):
            raise AssertionError("Edge Bokeh directions must stay normalized")
        if not (
            math.isclose(direction[0], -opposite[0], abs_tol=1.0e-12)
            and math.isclose(direction[1], -opposite[1], abs_tol=1.0e-12)
        ):
            raise AssertionError("Edge Bokeh directions must stay isotropic")

    balanced_neighbors = {
        (round(direction[0]), round(direction[1]))
        for index, direction in enumerate(directions)
        if index % 2 == 0
    }
    expected_neighbors = {
        (x, y)
        for x in (-1, 0, 1)
        for y in (-1, 0, 1)
        if x != 0 or y != 0
    }
    if balanced_neighbors != expected_neighbors:
        raise AssertionError(
            "Balanced Edge rays must cover all eight adjacent pixels at step one"
        )

    balanced_candidate_bound = 8 * 16
    high_candidate_bound = 16 * 16
    if balanced_candidate_bound != 128 or high_candidate_bound != 256:
        raise AssertionError("Edge Bokeh candidate bounds changed")

    def trace_edge_ray(
        center_depth,
        samples,
        center_far_coc=0.0,
        threshold=0.01,
        coc_threshold=0.5,
        ramp_start_coc=0.0625,
        ramp_confirm_coc=1.0,
        ramp_minimum_coc_slope=0.25,
        ramp_depth_backtrack=0.001,
        ramp_coc_backtrack=0.0625,
    ):
        previous_depth = center_depth
        previous_far_coc = center_far_coc
        previous_ramp_valid = False
        previous_ramp_distance = 0.0
        previous_ramp_coc = 0.0
        sample_distance = 0.0
        for sample_index, (
            sample_depth,
            sample_far_coc,
            step_distance,
        ) in enumerate(samples):
            sample_distance += max(step_distance, 1.0)
            local_gradient = (sample_depth - previous_depth) / (
                max(abs(sample_depth), abs(previous_depth), 1.0e-4)
                * max(step_distance, 1.0)
            )
            cumulative_gap = (sample_depth - center_depth) / max(
                abs(sample_depth), abs(center_depth), 1.0e-4
            )
            if local_gradient < -threshold:
                return "nearer-occluder", sample_index, sample_distance, False
            if cumulative_gap <= 0.0025:
                previous_ramp_valid = False
                previous_depth = sample_depth
                previous_far_coc = sample_far_coc
                continue
            far_coc_jump = sample_far_coc - previous_far_coc
            depth_boundary = local_gradient > threshold
            coc_boundary = (
                local_gradient > 0.0 and far_coc_jump >= coc_threshold
            )
            if depth_boundary or coc_boundary:
                return (
                    (
                        "far-background"
                        if sample_far_coc > 0.0
                        else "midground-block"
                    ),
                    sample_index,
                    sample_distance,
                    False,
                )
            ramp_positive = sample_far_coc >= ramp_start_coc
            ramp_not_nearer = local_gradient >= -ramp_depth_backtrack
            ramp_coc_monotonic = (
                sample_far_coc + ramp_coc_backtrack >= previous_ramp_coc
            )
            ramp_coc_steep = (
                sample_far_coc - center_far_coc
                >= ramp_minimum_coc_slope * sample_distance
            )
            confirmed_ramp = (
                previous_ramp_valid
                and ramp_positive
                and ramp_not_nearer
                and ramp_coc_monotonic
                and ramp_coc_steep
                and sample_far_coc >= ramp_confirm_coc
            )
            if confirmed_ramp:
                return (
                    "far-background",
                    sample_index,
                    previous_ramp_distance,
                    True,
                )
            previous_ramp_valid = ramp_positive and ramp_not_nearer
            previous_ramp_distance = sample_distance
            previous_ramp_coc = sample_far_coc
            previous_depth = sample_depth
            previous_far_coc = sample_far_coc
        return "no-discontinuity", None, None, False

    curved_foreground = [
        (1.004, 0.0, 1.0),
        (1.009, 0.0, 1.0),
        (1.015, 0.0, 1.0),
        (2.0, 8.0, 1.0),
    ]
    if trace_edge_ray(1.0, curved_foreground)[0] != "far-background":
        raise AssertionError(
            "smooth curved foreground must not hide the farther DOF background"
        )

    diagonal_curved_foreground = [
        (1.011, 0.0, math.sqrt(2.0)),
        (1.022, 0.0, math.sqrt(2.0)),
        (2.0, 8.0, 1.0),
    ]
    if trace_edge_ray(1.0, diagonal_curved_foreground)[0] != "far-background":
        raise AssertionError(
            "diagonal ray spacing must not turn smooth curvature into a layer"
        )

    close_positive_background = [
        (1.002, 0.0, 1.0),
        (1.008, 1.0, 1.0),
    ]
    if trace_edge_ray(1.0, close_positive_background)[0] != "far-background":
        raise AssertionError(
            "a material Far CoC jump must reveal a close blurred background"
        )

    gradual_coc_drift = [
        (1.004, 0.0, 1.0),
        (1.009, 0.2, 1.0),
        (1.015, 0.4, 1.0),
        (1.022, 0.6, 1.0),
    ]
    if trace_edge_ray(1.0, gradual_coc_drift)[0] != "no-discontinuity":
        raise AssertionError(
            "gradual CoC drift on a curved surface must not become a silhouette"
        )

    in_focus_midground = [
        (1.004, 0.0, 1.0),
        (1.009, 0.0, 1.0),
        (1.20, 0.0, 1.0),
        (2.0, 8.0, 1.0),
    ]
    if trace_edge_ray(1.0, in_focus_midground)[0] != "midground-block":
        raise AssertionError(
            "real in-focus midground discontinuity must block deeper bokeh"
        )

    confirmed_temporal_ramp = [
        (1.004, 0.1, 1.0),
        (1.009, 0.4, 1.0),
        (1.015, 0.8, 1.0),
        (1.022, 1.05, 1.0),
    ]
    ramp_result = trace_edge_ray(1.0, confirmed_temporal_ramp)
    if ramp_result != ("far-background", 3, 3.0, True):
        raise AssertionError(
            "a confirmed temporal Far CoC ramp must use the preceding boundary distance"
        )

    isolated_positive = [
        (1.004, 0.2, 1.0),
        (1.004, 0.0, 1.0),
        (1.004, 1.2, 1.0),
    ]
    if trace_edge_ray(1.0, isolated_positive)[0] != "no-discontinuity":
        raise AssertionError(
            "an isolated positive Far CoC sample must not establish an edge"
        )

    nearer_occluder = [
        (0.98, 0.0, 1.0),
        (2.0, 8.0, 1.0),
    ]
    if trace_edge_ray(1.0, nearer_occluder)[0] != "nearer-occluder":
        raise AssertionError("a nearer surface must stop the temporal ramp search")

    hard_far_boundary = [(1.20, 8.0, 1.0)]
    if trace_edge_ray(1.0, hard_far_boundary) != (
        "far-background",
        0,
        1.0,
        False,
    ):
        raise AssertionError("a hard Far boundary must remain an immediate result")

    coc_regression = [
        (1.004, 0.2, 1.0),
        (1.009, 0.6, 1.0),
        (1.014, 0.4, 1.0),
        (1.019, 0.85, 1.0),
        (1.024, 1.3, 1.0),
    ]
    regression_result = trace_edge_ray(1.0, coc_regression)
    if regression_result != ("far-background", 4, 4.0, True):
        raise AssertionError(
            "a CoC regression must discard the old ramp and start a new adjacent pair"
        )

    long_shallow_drift = [
        (1.004, 0.1, 1.0),
        (1.009, 0.2, 1.0),
        (1.014, 0.3, 1.0),
        (1.019, 0.4, 1.0),
        (1.024, 0.8, 1.0),
        (1.029, 1.05, 1.0),
    ]
    drift_result = trace_edge_ray(1.0, long_shallow_drift)
    if drift_result[0] != "no-discontinuity":
        raise AssertionError(
            "a long shallow CoC drift across a curved surface must not become a silhouette"
        )

    def relative_edge_support(center_far_coc, background_far_coc):
        return max(
            0.0,
            min(
                1.0,
                (background_far_coc - center_far_coc)
                / max(background_far_coc, 1.0),
            ),
        )

    relative_support_cases = (
        (0.0, 16.0, 1.0),
        (1.0, 16.0, 0.9375),
        (8.0, 16.0, 0.5),
        (16.0, 16.0, 0.0),
        (8.0, 4.0, 0.0),
    )
    for center_far_coc, background_far_coc, expected in relative_support_cases:
        actual = relative_edge_support(center_far_coc, background_far_coc)
        if not math.isclose(actual, expected, rel_tol=0.0, abs_tol=1.0e-12):
            raise AssertionError(
                "candidate-relative Edge support no longer protects equally "
                "defocused background"
            )

    # Sector count and additional radial probes must not change opacity after
    # the nearest validated background establishes the distance field.
    for width_pixels in (8.0, 16.0):
        expected_coverage = mapping(width_pixels)[2]
        for supported_sector_count in (1, 2, 4, 8):
            actual_coverage = max([1.0] * supported_sector_count) * 0.60
            if not math.isclose(
                actual_coverage,
                expected_coverage,
                rel_tol=0.0,
                abs_tol=1.0e-12,
            ):
                raise AssertionError(
                    "Edge Bokeh sectors and rings must not multiply opacity"
                )


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
        r"PackRuntimePayload\([\s\S]*?focus_distance_percent[\s\S]*?blur_radius_percent[\s\S]*?far_strength_percent[\s\S]*?edge_bokeh_width_pixels",
        "remaining DOF controls must be packed into the existing 112-byte payload",
    )
    if "near_strength_percent" in dof_runtime or "near_strength_percent" in addon:
        raise AssertionError("authored foreground bokeh must not be runtime-configurable")
    if "DepthOfFieldNearStrength" in addon or "Foreground Bokeh" in addon:
        raise AssertionError("Foreground Bokeh must not be exposed in RenoDX settings")
    require(
        dof_runtime,
        r"kEdgeWidthShift\s*=\s*16u[\s\S]*?kEdgeWidthMask\s*=\s*0x1Fu"
        r"[\s\S]*?kEdgeWidthDefault\s*=\s*8u[\s\S]*?kEdgeWidthMaximum\s*=\s*16u"
        r"[\s\S]*?kReservedEdgeShift\s*=\s*26u[\s\S]*?kReservedEdgeMask\s*=\s*0xFu"
        r"[\s\S]*?QuantizeEdgeWidthPixels\(controls\.edge_bokeh_width_pixels\)"
        r"[\s\S]*?<<\s*kEdgeWidthShift",
        "former foreground-control bits must encode exact Edge pixels while old Edge bits remain reserved",
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
        r'\.key\s*=\s*"DepthOfFieldEdgeBokehWidth"'
        r"[\s\S]*?SettingValueType::INTEGER"
        r"[\s\S]*?\.default_value\s*=\s*8\.f"
        r"[\s\S]*?\.min\s*=\s*0\.f[\s\S]*?\.max\s*=\s*16\.f"
        r"[\s\S]*?\.format\s*=\s*\"%\.0f px\""
        r"[\s\S]*?\.is_enabled\s*=\s*\[\]\(\)\s*\{\s*return\s+dof_mode\s*>=\s*1\.5f",
        "Edge Bokeh Width UI must expose exact 0..16 px with an 8 px default",
    )
    require(
        addon,
        r'\.key\s*=\s*"DepthOfFieldEdgeBokehWidth"'
        r"[\s\S]*?maximum full-resolution reach",
        "Edge Bokeh tooltip must identify the full-resolution pixel reach",
    )
    if re.search(r'\.key\s*=\s*"DepthOfFieldEdgeBokeh"\s*,', addon):
        raise AssertionError("legacy percentage Edge Bokeh key must not remain active")
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
        r"farFillRadiusScale\s*=\s*CUSTOM_DOF_RUNTIME_MODE\s*>=\s*0\.5[\s\S]*?sNativePrepassCoc\.x\s*\*\s*8\.0\)\s*>\s*3\.0[\s\S]*?FilterNear\(uv,\s*sNativePrepassCoc\.x\)[\s\S]*?texelFetch\(dofAlphaMapNear[\s\S]*?sNativePrepassCoc\.y\s*\*\s*farFillRadiusScale\s*\*\s*8\.0\)\s*>\s*3\.0",
        "fill must preserve native near radius/alpha while scaling only Enhanced far fill",
    )
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
        r"farLayer\.xyz[\s\S]*?farSupport[\s\S]*?smoothstep\(5\.0,\s*8\.0,\s*farCoc\)",
        "Cinematic must restore authored hidden-background and deep-bokeh color",
    )
    if "expandedEdgeBlur" in sources["0xAC7A8193"] or re.search(
        r"1\.0\s*\+\s*0\.5\s*\*\s*edgeFactor\s*\*\s*edgeScale",
        sources["0xAC7A8193"],
    ):
        raise AssertionError(
            "Edge Bokeh must alter final coverage, not rerun or resize the aperture"
        )
    require(
        sources["0xAC7A8193"],
        r"ResolveFarEdgeIntrusion\([\s\S]*?float\s+centerFarCoc"
        r"[\s\S]*?previousDepth\s*=\s*centerDepth"
        r"[\s\S]*?previousFarCoc\s*=\s*centerFarCoc"
        r"[\s\S]*?length\(vec2\(offset\)\)"
        r"[\s\S]*?sampleDepth\s*-\s*previousDepth"
        r"[\s\S]*?localDepthGap\s*<\s*-kFarEdgeSurfaceDiscontinuity"
        r"[\s\S]*?break"
        r"[\s\S]*?cumulativeCenterDepthGap\s*<=\s*0\.0025"
        r"[\s\S]*?previousDepth\s*=\s*sampleDepth"
        r"[\s\S]*?continue"
        r"[\s\S]*?ComputeFarCoc16\(sampleDepth\)"
        r"[\s\S]*?farCocJump\s*=\s*sampleFarCoc\s*-\s*previousFarCoc"
        r"[\s\S]*?if\s*\(depthBoundary\s*\|\|\s*cocBoundary\)"
        r"[\s\S]*?sampleFarCoc\s*<=\s*0\.0"
        r"[\s\S]*?break"
        r"[\s\S]*?ComputeFarEdgeCandidateCoverage\("
        r"[\s\S]*?ClassifyFarEdgeSector\(offset\)"
        r"[\s\S]*?sampleDistance\s*\+\s*1\.0e-4"
        r"[\s\S]*?<\s*bestDistance\[sector\]"
        r"[\s\S]*?authoredFar\.w\s*<=\s*0\.0"
        r"[\s\S]*?ResolveFarEdgeFallbackColor\("
        r"[\s\S]*?farColorWeight\s*\+=\s*sectorCoverage"
        r"[\s\S]*?nearestCoverage\s*=\s*max\(nearestCoverage,\s*sectorCoverage\)"
        r"[\s\S]*?directionalSupport\s*=\s*clamp\(nearestCoverage",
        "Edge Bokeh rays must cross smooth curvature locally, stop at real occluders, and use the nearest farther sample per sector",
    )
    require(
        sources["0xAC7A8193"],
        r"CoarseFarMayReach\([\s\S]*?dofPrepassCocMap"
        r"[\s\S]*?\.y\s*>\s*0\.0[\s\S]*?return\s+true"
        r"[\s\S]*?!CoarseFarMayReach",
        "coarse Far CoC may only provide a conservative Edge Bokeh early-out",
    )
    require(
        sources["0xAC7A8193"],
        r"nativeFocusClassification\s*=\s*"
        r"[\s\S]*?CUSTOM_DOF_FOCUS_SCALE\s*-\s*1\.0"
        r"[\s\S]*?if\s*\(nativeFocusClassification"
        r"[\s\S]*?&&\s*!CoarseFarMayReach",
        "native coarse CoC may reject Edge Bokeh only at the authored focus distance",
    )
    require(
        sources["0xAC7A8193"],
        r"ComputeFarEdgeCandidateCoverage\([\s\S]*?farActivation\s*=\s*clamp\(sampleFarCoc,\s*0\.0,\s*1\.0\)"
        r"[\s\S]*?localEdgeWidth\s*=\s*edgeWidthPixels"
        r"[\s\S]*?effectiveDistance\s*=\s*max\(sampleDistance\s*-\s*0\.5,\s*0\.0\)"
        r"[\s\S]*?normalizedDistance\s*=\s*clamp\("
        r"[\s\S]*?effectiveDistance\s*/\s*max\(localEdgeWidth,\s*1\.0\)"
        r"[\s\S]*?radialCoverage\s*=\s*1\.0\s*-\s*smoothstep\("
        r"[\s\S]*?return\s+farActivation\s*\*\s*radialCoverage"
        r"[\s\S]*?maximumSearchRadius\s*=\s*edgeWidthPixels"
        r"[\s\S]*?const\s+float\s+edgeOpacity\s*=\s*0\.60",
        "Edge Bokeh Width must use nearest-background coverage with a full-width smooth fade",
    )
    for forbidden in (
        "kFarEdgeDenseNearRadius",
        "kFarEdgeDenseNearSearchRadius",
    ):
        if forbidden in sources["0xAC7A8193"]:
            raise AssertionError(
                "unordered dense Edge dilation must not bypass first-surface occlusion"
            )
    require(
        sources["0xAC7A8193"],
        r"kFarEdgeUnitDirections\[16\]"
        r"[\s\S]*?kFarEdgeMaximumRadialSteps\s*=\s*16"
        r"[\s\S]*?directionIndex\s*=\s*0"
        r"[\s\S]*?directionIndex\s*<\s*16"
        r"[\s\S]*?!highQuality\s*&&\s*\(directionIndex\s*&\s*1\)"
        r"[\s\S]*?radialStep\s*=\s*1"
        r"[\s\S]*?radialStep\s*<=\s*kFarEdgeMaximumRadialSteps",
        "Edge Bokeh search must remain bounded to 128 Balanced or 256 High ordered probes",
    )
    require(
        sources["0xAC7A8193"],
        r"kFarEdgeSurfaceDiscontinuity\s*=\s*0\.01"
        r"[\s\S]*?kFarEdgeCocDiscontinuity\s*=\s*0\.5"
        r"[\s\S]*?localStepDistance\s*=\s*max\("
        r"[\s\S]*?length\(vec2\(offset\s*-\s*previousOffset\)\),\s*1\.0\)"
        r"[\s\S]*?localDepthGap\s*=\s*\(sampleDepth\s*-\s*previousDepth\)"
        r"[\s\S]*?\*\s*localStepDistance"
        r"[\s\S]*?cumulativeCenterDepthGap\s*=\s*\(sampleDepth\s*-\s*centerDepth\)"
        r"[\s\S]*?cumulativeCenterDepthGap\s*<=\s*0\.0025"
        r"[\s\S]*?sampleFarCoc\s*=\s*ComputeFarCoc16\(sampleDepth\)"
        r"[\s\S]*?farCocJump\s*=\s*sampleFarCoc\s*-\s*previousFarCoc"
        r"[\s\S]*?depthBoundary\s*="
        r"[\s\S]*?localDepthGap\s*>\s*kFarEdgeSurfaceDiscontinuity"
        r"[\s\S]*?cocBoundary\s*=\s*localDepthGap\s*>\s*0\.0"
        r"[\s\S]*?farCocJump\s*>=\s*kFarEdgeCocDiscontinuity"
        r"[\s\S]*?if\s*\(depthBoundary\s*\|\|\s*cocBoundary\)"
        r"[\s\S]*?previousDepth\s*=\s*sampleDepth"
        r"[\s\S]*?previousFarCoc\s*=\s*sampleFarCoc",
        "Edge rays must cross smooth depth and CoC drift while detecting real discontinuities",
    )
    require(
        sources["0xAC7A8193"],
        r"if\s*\(depthBoundary\s*\|\|\s*cocBoundary\)"
        r"[\s\S]*?if\s*\(sampleFarCoc\s*<=\s*0\.0\)"
        r"[\s\S]*?break;"
        r"[\s\S]*?candidateCoverage\s*>\s*0\.0"
        r"[\s\S]*?bestCoverage\[sector\]"
        r"[\s\S]*?\}\s*break;",
        "each real Edge discontinuity must stop at its first in-focus or blurred surface",
    )
    require(
        sources["0xAC7A8193"],
        r"kFarEdgeRampStartCoc\s*=\s*0\.0625"
        r"[\s\S]*?kFarEdgeRampConfirmCoc\s*=\s*1\.0"
        r"[\s\S]*?kFarEdgeRampMinimumCocSlope\s*=\s*0\.25"
        r"[\s\S]*?kFarEdgeRampDepthBacktrackTolerance\s*=\s*0\.001"
        r"[\s\S]*?kFarEdgeRampCocBacktrackTolerance\s*=\s*0\.0625"
        r"[\s\S]*?previousRampValid\s*=\s*false"
        r"[\s\S]*?cumulativeCenterDepthGap\s*<=\s*0\.0025"
        r"[\s\S]*?previousRampValid\s*=\s*false"
        r"[\s\S]*?if\s*\(depthBoundary\s*\|\|\s*cocBoundary\)"
        r"[\s\S]*?bool\s+rampPositive\s*=\s*sampleFarCoc\s*>=\s*kFarEdgeRampStartCoc"
        r"[\s\S]*?localDepthGap\s*>=\s*-kFarEdgeRampDepthBacktrackTolerance"
        r"[\s\S]*?sampleFarCoc[\s\S]*?\+\s*kFarEdgeRampCocBacktrackTolerance\s*>=\s*previousRampCoc"
        r"[\s\S]*?rampCocSteep\s*=\s*sampleFarCoc\s*-\s*centerFarCoc"
        r"[\s\S]*?>=\s*kFarEdgeRampMinimumCocSlope\s*\*\s*sampleDistance"
        r"[\s\S]*?previousRampValid[\s\S]*?rampCocSteep"
        r"[\s\S]*?sampleFarCoc\s*>=\s*kFarEdgeRampConfirmCoc"
        r"[\s\S]*?candidateDistance\s*=\s*previousRampDistance"
        r"[\s\S]*?bestPixel\[sector\]\s*=\s*samplePixel"
        r"[\s\S]*?bestFarCoc\[sector\]\s*=\s*sampleFarCoc"
        r"[\s\S]*?bestDistance\[sector\]\s*=\s*candidateDistance"
        r"[\s\S]*?previousRampValid\s*=\s*rampPositive\s*&&\s*rampNotNearer",
        "TAA-smoothed Far ramps must use a bounded sliding two-sample confirmation",
    )
    require(
        sources["0xAC7A8193"],
        r"if\s*\(cinematic\s*&&\s*edgeWidthPixels\s*>\s*0\.0\)"
        r"[\s\S]*?ResolveFarEdgeIntrusion\("
        r"[\s\S]*?centerDepth,\s*farCoc,\s*edgeWidthPixels"
        r"[\s\S]*?farCoverage\s*=\s*clamp"
        r"[\s\S]*?edgeIntrusion\.w\s*\*\s*CUSTOM_DOF_FAR_STRENGTH"
        r"[\s\S]*?farResult\s*=\s*mix",
        "Cinematic must apply far-only Edge Bokeh to final coverage after its depth-aware resolve",
    )
    if "focusedCenter" in sources["0xAC7A8193"]:
        raise AssertionError(
            "absolute center CoC must not detach Edge Bokeh from a filtered silhouette"
        )
    require(
        sources["0xAC7A8193"],
        r"relativeCocSupport\s*=\s*clamp\("
        r"[\s\S]*?bestFarCoc\[sector\]\s*-\s*centerFarCoc"
        r"[\s\S]*?/\s*max\(bestFarCoc\[sector\],\s*1\.0\)"
        r"[\s\S]*?sectorCoverage\s*=\s*bestCoverage\[sector\]\s*\*\s*relativeCocSupport"
        r"[\s\S]*?nearestCoverage\s*=\s*max\(nearestCoverage,\s*sectorCoverage\)",
        "Edge Bokeh must suppress equal-depth background per selected Far candidate",
    )
    require(
        sources["0xAC7A8193"],
        r"farLayer\s*=\s*cinematic\s*\?\s*\(highQuality"
        r"[\s\S]*?ResolveFarHigh\(dofPosition,\s*farCoc,\s*sharpColor\)"
        r"[\s\S]*?:\s*ResolveFarBalanced\(dofPosition,\s*farCoc,\s*sharpColor\)",
        "Cinematic High must use the High far-layer resolve",
    )
    if "directionCoverageSum" in sources["0xAC7A8193"]:
        raise AssertionError(
            "Edge coverage must not depend on the number of visible sectors"
        )
    if "centerNearCoc" in sources["0xAC7A8193"]:
        raise AssertionError("near CoC must not suppress farther Edge Bokeh intrusion")
    require(
        sources["0xAC7A8193"],
        r"out\s+float\s+finalEdgeCoverage"
        r"[\s\S]*?finalEdgeCoverage\s*=\s*0\.0"
        r"[\s\S]*?farCoverage\s*=\s*clamp"
        r"[\s\S]*?finalEdgeCoverage\s*=\s*farCoverage"
        r"[\s\S]*?RENDER_DEBUG_SOURCE_DOF_EDGE_CONTROL"
        r"[\s\S]*?CUSTOM_DOF_EDGE_WIDTH_PIXELS"
        r"[\s\S]*?RENDER_DEBUG_SOURCE_DOF_EDGE_COVERAGE"
        r"[\s\S]*?debugValue\.x\s*=\s*finalEdgeCoverage",
        "Render Debug must expose decoded Edge Bokeh and the exact final mix coverage without recomputing it",
    )
    require(
        sources["0xAC7A8193"],
        r"authoredFar\s*=\s*highQuality"
        r"[\s\S]*?ResolveFarHigh\([\s\S]*?:\s*ResolveFarBalanced\("
        r"[\s\S]*?farColorSum\s*\+=\s*directionColor",
        "Edge Bokeh must stably combine every supported direction with the selected depth-aware upsample",
    )
    for forbidden in ("strongestPixel", "farCoverageSum"):
        if forbidden in sources["0xAC7A8193"]:
            raise AssertionError(
                f"Edge Bokeh must not use winner-take-all or ring-count coverage: {forbidden}"
            )
    edge_start = sources["0xAC7A8193"].index("vec4 ResolveFarEdgeIntrusion")
    edge_end = sources["0xAC7A8193"].index("vec3 CompositeVanilla", edge_start)
    edge_source = sources["0xAC7A8193"][edge_start:edge_end]
    hard_boundary_index = edge_source.index("if (depthBoundary || cocBoundary)")
    ramp_fallback_index = edge_source.index("bool confirmedRamp")
    if hard_boundary_index >= ramp_fallback_index:
        raise AssertionError(
            "hard first-surface occlusion must run before the temporal ramp fallback"
        )
    if edge_source.count("texelFetch(depthMap, samplePixel, 0)") != 1:
        raise AssertionError(
            "temporal ramp confirmation must not add another depth texture fetch"
        )
    if "farSample.w" in edge_source:
        raise AssertionError(
            "Edge coverage must not depend on R8 availability"
        )
    selection_end = edge_source.index("vec3 farColorSum")
    if ".w" in edge_source[:selection_end]:
        raise AssertionError(
            "Edge candidate selection and coverage must not read any layer alpha"
        )
    if "ResolveFullResolutionFar" in edge_source:
        raise AssertionError(
            "Edge color fallback must not repeat the full 49x4 aperture resolve per sector"
        )
    require(
        sources["0xAC7A8193"],
        r"ClassifyFarEdgeSector\([\s\S]*?kTanHalfSector\s*=\s*0\.41421356237"
        r"[\s\S]*?ResolveFarEdgeFallbackColor\("
        r"[\s\S]*?offsetY\s*=\s*-1[\s\S]*?offsetY\s*<=\s*1"
        r"[\s\S]*?CocCompatibility\(sourceCoc,\s*sampleFarCoc\)",
        "Edge sectors must have equal angular width and a bounded 3x3 full-resolution fallback",
    )
    validate_edge_bokeh_mapping_math()
    if "farLayer.w" in sources["0xAC7A8193"]:
        raise AssertionError("Cinematic must not restore the low-resolution far alpha mask")

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
        r"FindDevice\(vk_command_buffer\)",
        "Retinal barriers must resolve the device from the exact command buffer",
    )

    print("PASS: Detroit native DOF v2 source contract")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (AssertionError, OSError) as error:
        print(f"FAIL: {error}")
        raise SystemExit(1)
