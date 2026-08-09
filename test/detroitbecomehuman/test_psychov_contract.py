#!/usr/bin/env python3
"""Regression tests for Detroit's PsychoV integration contract."""

from __future__ import annotations

import argparse
import math
from pathlib import Path
import re
import sys
import unittest


def _parse_arguments() -> Path:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--source-dir", type=Path, required=True)
    args, remaining = parser.parse_known_args()
    sys.argv = [sys.argv[0], *remaining]
    return args.source_dir.resolve()


SOURCE_DIR = _parse_arguments()
SCENE_SOURCE = SOURCE_DIR / "scene_0xEBFBDDB1.comp.slang"
ADDON_SOURCE = SOURCE_DIR / "addon.cpp"
SHARED_SOURCE = SOURCE_DIR / "shared.h"
TEMPORAL_AUX_SOURCE = SOURCE_DIR / "temporal_aux.comp.vk.glsl"
HDR_INTERMEDIATE_SOURCE = SOURCE_DIR / "hdr_intermediate.hlsli"
PSYCHOV24_SOURCE = (
    SOURCE_DIR.parents[1] / "shaders" / "tonemap" / "psychov" / "test24.hlsl"
)
PSYCHOV_HEADER_SOURCE = SOURCE_DIR.parents[1] / "shaders" / "tonemap" / "psychov.hlsl"


BT709_TO_BT2020 = (
    (0.6273999810, 0.3292999864, 0.0432999991),
    (0.0690999999, 0.9194999933, 0.0114000002),
    (0.0164000001, 0.0879999995, 0.8956000209),
)
BT2020_TO_BT709 = (
    (1.6604910021, -0.5876411388, -0.0728498633),
    (-0.1245504745, 1.1328998971, -0.0083494226),
    (-0.0181507634, -0.1005788980, 1.1187296614),
)


def multiply_matrix(
    matrix: tuple[tuple[float, float, float], ...],
    color: tuple[float, float, float],
) -> tuple[float, float, float]:
    return tuple(
        sum(row[column] * color[column] for column in range(3))
        for row in matrix
    )


def pq_encode(normalized_10000_nits: float) -> float:
    m1 = 2610.0 / 16384.0
    m2 = 2523.0 / 32.0
    c1 = 3424.0 / 4096.0
    c2 = 2413.0 / 128.0
    c3 = 2392.0 / 128.0
    powered = max(normalized_10000_nits, 0.0) ** m1
    return ((c1 + c2 * powered) / (1.0 + c3 * powered)) ** m2


def pq_decode(encoded: float) -> float:
    m1 = 2610.0 / 16384.0
    m2 = 2523.0 / 32.0
    c1 = 3424.0 / 4096.0
    c2 = 2413.0 / 128.0
    c3 = 2392.0 / 128.0
    powered = max(encoded, 0.0) ** (1.0 / m2)
    return (max(powered - c1, 0.0) / (c2 - c3 * powered)) ** (1.0 / m1)


def srgb_encode(linear: float) -> float:
    linear = max(linear, 0.0)
    if linear <= 0.0031308:
        return 12.92 * linear
    return 1.055 * linear ** (1.0 / 2.4) - 0.055


def srgb_decode(encoded: float) -> float:
    encoded = max(encoded, 0.0)
    if encoded <= 0.04045:
        return encoded / 12.92
    return ((encoded + 0.055) / 1.055) ** 2.4


def detroit_native_to_display(value: float) -> float:
    """F(x): gamma-2.2 decode of Detroit's native sRGB encoding."""
    return srgb_encode(max(value, 0.0)) ** 2.2


def detroit_display_to_native(value: float) -> float:
    """F^-1(x): Detroit's native value for gamma-2.2 display light."""
    return srgb_decode(max(value, 0.0) ** (1.0 / 2.2))


def detroit_exact_display_light_scale(value: float, game_nits: float) -> float:
    """F^-1(F(T) * game_nits / 300), matching GammaSafe(false/true)."""
    display_light = detroit_native_to_display(value)
    display_light *= max(game_nits, 0.0) / 300.0
    return detroit_display_to_native(display_light)


def detroit_gamma_only_scale(value: float, game_nits: float) -> float:
    """The former pow-only approximation, retained as a regression oracle."""
    return (
        max(value, 0.0) ** 2.2 * max(game_nits, 0.0) / 300.0
    ) ** (1.0 / 2.2)


def extract_call_arguments(source: str, function_name: str) -> tuple[str, ...]:
    """Split one HLSL call at top-level commas, preserving nested calls."""
    marker = f"{function_name}("
    call_start = source.index(marker) + len(marker)
    depth = 1
    argument_start = call_start
    arguments: list[str] = []
    for index in range(call_start, len(source)):
        character = source[index]
        if character == "(":
            depth += 1
        elif character == ")":
            depth -= 1
            if depth == 0:
                arguments.append(source[argument_start:index].strip())
                return tuple(arguments)
        elif character == "," and depth == 1:
            arguments.append(source[argument_start:index].strip())
            argument_start = index + 1
    raise ValueError(f"Unterminated call to {function_name}")


def strip_shader_comments(source: str) -> str:
    """Remove comments without changing executable token order."""
    source = re.sub(r"/\*.*?\*/", " ", source, flags=re.DOTALL)
    return re.sub(r"//[^\n]*", " ", source)


def extract_setting(source: str, key: str) -> str:
    """Return one C++ setting body up to the next setting key."""
    marker = f'.key = "{key}"'
    start = source.index(marker)
    next_key = source.find('.key = "', start + len(marker))
    return source[start:] if next_key < 0 else source[start:next_key]


def solve_psychov_neutral_reference(
    evaluate,
    unmatched_anchor: float,
) -> tuple[float, float]:
    """Model CP2077's bounded linear-domain sampled-curve inverse."""
    neutral = 0.18
    lower_input = 0.0
    upper_input = max(unmatched_anchor, neutral, 1.0e-4)
    upper_output = evaluate(upper_input)
    for _ in range(8):
        if upper_output >= neutral:
            break
        upper_input *= 2.0
        upper_output = evaluate(upper_input)

    for _ in range(16):
        middle_input = (lower_input + upper_input) * 0.5
        middle_output = evaluate(middle_input)
        if middle_output < neutral:
            lower_input = middle_input
        else:
            upper_input = middle_input
    return upper_input, evaluate(upper_input)


def psychov_log_slope(
    reference_input: float,
    reference_output: float,
    lower_input: float,
    lower_output: float,
    upper_input: float,
    upper_output: float,
) -> float:
    """Model CP2077's exact finite-difference zero handling."""
    input_span = upper_input - lower_input
    linear_slope = (
        0.0
        if input_span == 0.0
        else max((upper_output - lower_output) / input_span, 0.0)
    )
    if reference_output == 0.0:
        return 1.0
    return max(reference_input * linear_slope / reference_output, 0.0)


def sanitize_psychov_display(
    color: tuple[float, float, float], peak: float
) -> tuple[float, float, float]:
    safe_peak = max(peak, 0.0)
    display = tuple(
        max(0.0 if math.isnan(channel) else channel, 0.0)
        for channel in color
    )
    display = tuple(
        safe_peak if math.isinf(channel) else channel
        for channel in display
    )
    output_peak = max(display)
    if output_peak > safe_peak:
        scale = safe_peak / max(output_peak, 1.0e-6)
        display = tuple(channel * scale for channel in display)
    return display


def psychov_raw_to_intermediate(
    psychov_raw_bt709: tuple[float, float, float],
    psychov_peak: float,
    wide_gamut: bool,
) -> tuple[float, float, float]:
    """Model the required conversion before PsychoV's nonnegative sanitize."""
    display_intermediate = psychov_raw_bt709
    if wide_gamut:
        display_intermediate = multiply_matrix(
            BT709_TO_BT2020, display_intermediate
        )
    return sanitize_psychov_display(display_intermediate, psychov_peak)


def full_detroit_round_trip(
    psychov_raw_bt709: tuple[float, float, float],
    game_nits: float,
    psychov_peak: float,
    wide_gamut: bool,
) -> tuple[
    tuple[float, float, float],
    tuple[float, float, float],
]:
    """Model raw PsychoV output through Detroit's intermediate and PQ tail."""
    psychov_display_intermediate = psychov_raw_to_intermediate(
        psychov_raw_bt709, psychov_peak, wide_gamut
    )
    psychov_native_intermediate = tuple(
        detroit_display_to_native(channel)
        for channel in psychov_display_intermediate
    )
    scaled_native_intermediate = tuple(
        detroit_exact_display_light_scale(channel, game_nits)
        for channel in psychov_native_intermediate
    )
    display_intermediate = tuple(
        detroit_native_to_display(channel)
        for channel in scaled_native_intermediate
    )
    display_bt2020 = (
        display_intermediate
        if wide_gamut
        else multiply_matrix(BT709_TO_BT2020, display_intermediate)
    )
    pq = tuple(pq_encode(channel * 300.0 / 10000.0) for channel in display_bt2020)
    decoded_bt2020 = tuple(pq_decode(channel) * 10000.0 / 300.0 for channel in pq)
    return pq, decoded_bt2020


class PsychoVContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.scene = SCENE_SOURCE.read_text(encoding="utf-8")
        cls.addon = ADDON_SOURCE.read_text(encoding="utf-8")
        cls.shared = SHARED_SOURCE.read_text(encoding="utf-8")
        cls.temporal_aux = TEMPORAL_AUX_SOURCE.read_text(encoding="utf-8")
        cls.hdr_intermediate = HDR_INTERMEDIATE_SOURCE.read_text(
            encoding="utf-8"
        )
        cls.psychov24 = PSYCHOV24_SOURCE.read_text(encoding="utf-8")
        cls.psychov_header = PSYCHOV_HEADER_SOURCE.read_text(encoding="utf-8")

    def test_psychov24_library_and_mode_are_registered(self):
        self.assertIn('#include "./psychov/test24.hlsl"', self.psychov_header)
        self.assertIn(
            "RENODX_SHADERS_TONEMAP_PSYCHOV_TEST24_HLSL_",
            self.psychov24,
        )
        self.assertRegex(
            self.psychov24,
            r"float3\s+psychotm_test24\s*\(\s*"
            r"float3\s+bt709_linear_input\s*,\s*"
            r"float\s+peak_value\s*=\s*1000\.f\s*/\s*203\.f",
        )
        self.assertIn(
            '.labels = {"Vanilla", "RenoDRT", "PsychoV-17", '
            '"PsychoV-22", "PsychoV-24"}',
            self.addon,
        )
        self.assertNotIn('"Reinhard"', self.addon)
        self.assertIn('.key = "ToneMapTypeV2"', self.addon)
        self.assertRegex(
            self.addon,
            r'\.key\s*=\s*"ToneMapTypeV2"[\s\S]*?'
            r'\.default_value\s*=\s*1\.f',
        )
        self.assertIn(
            "#define CUSTOM_PSYCHOV24_ACTIVE  "
            "(shader_injection.tone_map_type == 4.f)",
            self.shared,
        )

    def test_removed_reinhard_modes_migrate_without_changing_psychov(self):
        expected_cases = {
            0: 0,
            1: 1,
            2: 1,
            3: 2,
            4: 3,
            5: 4,
        }
        migration = self.addon[
            self.addon.index("constexpr int MigrateLegacyToneMapType") :
            self.addon.index("void MigrateToneMapTypeSettings")
        ]
        for legacy, current in expected_cases.items():
            with self.subTest(legacy=legacy):
                self.assertRegex(
                    migration,
                    rf"case\s+{legacy}\s*:[\s\S]*?return\s+{current}\s*;",
                )
        self.assertIn('"ToneMapType"', self.addon)
        self.assertIn('"ToneMapTypeV2"', self.addon)
        self.assertLess(
            self.addon.index("MigrateToneMapTypeSettings();"),
            self.addon.index("renodx::utils::settings::Use("),
        )
        self.assertNotIn("tone_map_method::REINHARD", self.shared)
        self.assertIn("tone_map_method::DANIELE", self.shared)

    def test_all_versions_convert_wide_output_then_encode_once(self):
        test17 = self.scene[
            self.scene.index("if (CUSTOM_PSYCHOV17_ACTIVE)") :
            self.scene.index("else if (CUSTOM_PSYCHOV22_ACTIVE)")
        ]
        test22 = self.scene[
            self.scene.index("else if (CUSTOM_PSYCHOV22_ACTIVE)") :
            self.scene.index("else if (CUSTOM_PSYCHOV24_ACTIVE)")
        ]
        test24 = self.scene[
            self.scene.index("else if (CUSTOM_PSYCHOV24_ACTIVE)") :
            self.scene.index("else\n            {", self.scene.index(
                "else if (CUSTOM_PSYCHOV24_ACTIVE)"
            ))
        ]
        encoded_once = (
            r"renodx_tonemapped\s*=\s*"
            r"renodx::color::correct::GammaSafe\(\s*"
            r"renodx_psychov_display\s*,\s*"
            r"true\s*,\s*2\.2\s*\)\s*;"
        )
        conversion_before_sanitize = re.compile(
            r"SanitizePsychoVDisplay\(\s*"
            r"CUSTOM_PSYCHOV_BT2020_ACTIVE\s*\?\s*"
            r"renodx::color::bt2020::from::BT709\(\s*"
            r"renodx_psychov_output\s*\)\s*:\s*"
            r"renodx_psychov_output\s*,\s*"
            r"renodx_psychov_peak\s*\)",
            re.DOTALL,
        )
        for name, branch in (
            ("PsychoV-17", test17),
            ("PsychoV-22", test22),
            ("PsychoV-24", test24),
        ):
            with self.subTest(mode=name):
                self.assertRegex(branch, encoded_once)
                self.assertEqual(
                    len(re.findall(r"SanitizePsychoVDisplay\(", branch)), 1
                )
                self.assertRegex(branch, conversion_before_sanitize)
        self.assertNotIn("RestorePsychoVHighlightColor", self.scene)
        self.assertEqual(
            len(re.findall(r"SanitizePsychoVDisplay\(", self.scene)), 4
        )

    def test_peak_passed_to_psychov_is_display_linear(self):
        self.assertRegex(
            self.scene,
            r"renodx_psychov_peak\s*=\s*max\(\s*"
            r"RENODX_PEAK_WHITE_NITS\s*"
            r"/\s*max\(RENODX_DIFFUSE_WHITE_NITS,\s*1\.0\),\s*"
            r"1\.0\s*\)",
        )
        peak = self.scene.index("const float renodx_psychov_peak")
        gamut = self.scene.index("const int renodx_psychov_gamut_mode", peak)
        self.assertNotIn("GammaSafe", self.scene[peak:gamut])

    def test_common_scale_uses_exact_native_transfer_pair(self):
        scale = self.scene.index("const float renodx_game_scale")
        native_color_space = self.scene.index("bool _1398", scale)
        scale_block = self.scene[scale:native_color_space]
        self.assertRegex(
            scale_block,
            r"renodx_display_light\s*=\s*"
            r"renodx::color::correct::GammaSafe\(\s*"
            r"max\(renodx_tonemapped,\s*vec3\(0\.0\)\)\s*,\s*"
            r"false\s*,\s*2\.2\s*\)",
        )
        self.assertRegex(
            scale_block,
            r"_2647\s*=\s*renodx::color::correct::GammaSafe\(\s*"
            r"renodx_display_light\s*\*\s*renodx_game_scale\s*,\s*"
            r"true\s*,\s*2\.2\s*\)",
        )
        executable = "\n".join(
            line for line in scale_block.splitlines()
            if not line.lstrip().startswith("//")
        )
        self.assertNotIn("pow(", executable)

    def test_exact_native_transfer_maps_configured_peaks(self):
        game_nits = 203.0
        for peak_nits in (600.0, 1000.0, 1033.0, 1068.0):
            with self.subTest(peak_nits=peak_nits):
                psychov_peak = peak_nits / game_nits
                native_peak = detroit_display_to_native(
                    psychov_peak
                )
                scaled_native = detroit_exact_display_light_scale(
                    native_peak, game_nits
                )
                final_nits = detroit_native_to_display(scaled_native) * 300.0
                self.assertAlmostEqual(final_nits, peak_nits, places=9)

    def test_pow_only_scale_would_overshoot_configured_peak(self):
        peak_nits = 1033.0
        game_nits = 203.0
        psychov_peak = peak_nits / game_nits
        native_peak = detroit_display_to_native(psychov_peak)
        old_scaled = detroit_gamma_only_scale(native_peak, game_nits)
        old_final_nits = detroit_native_to_display(old_scaled) * 300.0
        self.assertGreater(old_final_nits, peak_nits * 1.2)

    def test_scene_grading_still_precedes_all_psychov_calls(self):
        grade = self.scene.index("ComputeUntonemappedGraded")
        test17 = self.scene.index("psychotm_test17", grade)
        test22 = self.scene.index("psychotm_test22", test17)
        test24 = self.scene.index("psychotm_test24", test22)
        self.assertLess(grade, test17)
        self.assertLess(test17, test22)
        self.assertLess(test22, test24)
        self.assertRegex(
            self.scene[grade:test22],
            r"psychotm_test17\(\s*renodx_psychov_input\s*,",
        )
        self.assertRegex(
            self.scene[test22 : test22 + 512],
            r"psychotm_test22\(\s*renodx_psychov_input\s*,",
        )
        self.assertRegex(
            self.scene[test24 : test24 + 512],
            r"psychotm_test24\(\s*renodx_psychov_input\s*,",
        )

    def test_scene_graded_input_is_clamped_before_lms_conversion(self):
        self.assertRegex(
            self.scene,
            re.compile(
                r"renodx_psychov_input\s*=\s*max\(\s*"
                r"renodx::draw::ComputeUntonemappedGraded\(.*?"
                r"\)\s*,\s*vec3\(0\.0\)\s*\)\s*;",
                re.DOTALL,
            ),
        )

    def test_vanilla_reference_is_evaluated_in_exact_v100_light(self):
        evaluator = self.scene[
            self.scene.index("float DetroitEvalVanillaNeutral") :
            self.scene.index("float DetroitResolvePsychoVNeutralAnchor")
        ]
        self.assertRegex(
            evaluator,
            r"output_value\s*=\s*DetroitApplyNativeHighlightShoulder\(\s*"
            r"max\(output_value,\s*0\.0\)\s*\)\s*;",
        )
        self.assertRegex(
            evaluator,
            r"const float display_light_300\s*=\s*"
            r"renodx::color::correct::GammaSafe\(\s*"
            r"output_value,\s*false,\s*2\.2\s*\)\s*;\s*"
            r"return max\(display_light_300\s*\*\s*3\.0,\s*0\.0\)\s*;",
        )

    def test_neutral_reference_matches_cp2077_contract(self):
        neutral_helper = self.scene[
            self.scene.index("float DetroitResolvePsychoVNeutralAnchor") :
            self.scene.index("vec3 DetroitResolvePsychoVVanillaReference")
        ]
        self.assertRegex(
            neutral_helper,
            re.compile(
                r"const float neutral\s*=\s*0\.18\s*;.*?"
                r"graded\s*=\s*neutral\s*\*\s*"
                r"max\(RENODX_TONE_MAP_EXPOSURE,\s*0\.0\)",
                re.DOTALL,
            ),
        )
        highlights = neutral_helper.index("renodx::color::grade::Highlights")
        shadows = neutral_helper.index("renodx::color::grade::Shadows")
        contrast = neutral_helper.index("renodx::color::grade::ContrastSafe")
        self.assertLess(highlights, shadows)
        self.assertLess(shadows, contrast)
        self.assertNotIn("RENODX_TONE_MAP_SATURATION", neutral_helper)

        resolver = self.scene[
            self.scene.index("vec3 DetroitResolvePsychoVVanillaReference") :
            self.scene.index("vec3 DecodeSceneInput")
        ]
        resolver_executable = strip_shader_comments(resolver)
        self.assertRegex(
            resolver,
            r"const float unmatched_anchor\s*=\s*"
            r"DetroitResolvePsychoVNeutralAnchor\(\)\s*;\s*"
            r"float anchor_input\s*=\s*unmatched_anchor\s*;\s*"
            r"float anchor_output\s*=\s*unmatched_anchor\s*;",
        )
        self.assertRegex(
            resolver,
            r"if\s*\(RENODX_PSYCHOV_EXPOSURE_MATCH\s*>=\s*0\.5\s*"
            r"\|\|\s*RENODX_PSYCHOV_VANILLA_SLOPE\s*>\s*0\.0\)",
        )
        self.assertRegex(
            resolver,
            r"float lower_input\s*=\s*0\.0\s*;\s*"
            r"float upper_input\s*=\s*"
            r"max\(max\(unmatched_anchor,\s*neutral\),\s*1\.0e-4\)\s*;",
        )
        self.assertRegex(
            resolver,
            r"for\s*\(int expansion\s*=\s*0;\s*"
            r"expansion\s*<\s*8\s*&&\s*"
            r"upper_output\s*<\s*neutral;\s*\+\+expansion\)\s*"
            r"\{\s*upper_input\s*\*=\s*2\.0\s*;\s*"
            r"upper_output\s*=\s*"
            r"DetroitEvalVanillaNeutral\(upper_input\)\s*;",
        )
        self.assertRegex(
            resolver,
            r"for\s*\(int iteration\s*=\s*0;\s*"
            r"iteration\s*<\s*16;\s*\+\+iteration\)\s*"
            r"\{\s*const float middle_input\s*=\s*"
            r"\(lower_input\s*\+\s*upper_input\)\s*\*\s*0\.5\s*;\s*"
            r"const float middle_output\s*=\s*"
            r"DetroitEvalVanillaNeutral\(middle_input\)\s*;",
        )
        self.assertRegex(
            resolver,
            r"reference_input\s*=\s*upper_input\s*;\s*"
            r"reference_output\s*=\s*"
            r"DetroitEvalVanillaNeutral\(reference_input\)\s*;",
        )
        self.assertRegex(
            resolver,
            r"anchor_output\s*=\s*reference_output\s*\*\s*100\.0\s*"
            r"/\s*max\(RENODX_DIFFUSE_WHITE_NITS,\s*1\.0e-6\)\s*;",
        )
        self.assertNotIn("bracketed", resolver)
        self.assertNotIn("lower_log2", resolver)
        self.assertNotIn("upper_log2", resolver)
        self.assertNotIn("exp2(", resolver)
        self.assertRegex(
            resolver,
            r"if\s*\(middle_output\s*<\s*neutral\)",
        )
        self.assertRegex(
            resolver_executable,
            r"if\s*\(RENODX_PSYCHOV_EXPOSURE_MATCH\s*>=\s*0\.5\)"
            r"\s*\{\s*anchor_input\s*=\s*reference_input\s*;\s*"
            r"anchor_output\s*=\s*reference_output\s*\*\s*100\.0\s*"
            r"/\s*max\(RENODX_DIFFUSE_WHITE_NITS,\s*1\.0e-6\)\s*;",
        )
        self.assertRegex(
            resolver,
            r"const float delta\s*=\s*"
            r"max\(0\.005,\s*reference_input\s*\*\s*0\.01\)\s*;",
        )
        self.assertRegex(
            resolver,
            r"const float input_span\s*=\s*"
            r"upper_input\s*-\s*lower_input\s*;\s*"
            r"const float linear_slope\s*=\s*input_span\s*==\s*0\.0\s*"
            r"\?\s*0\.0\s*:\s*max\(\s*"
            r"\(upper_output\s*-\s*lower_output\)\s*/\s*input_span,\s*"
            r"0\.0\s*\)\s*;",
        )
        self.assertRegex(
            resolver,
            r"const float candidate\s*=\s*reference_output\s*==\s*0\.0\s*"
            r"\?\s*1\.0\s*:\s*max\(\s*"
            r"\(reference_input\s*\*\s*linear_slope\)\s*"
            r"/\s*reference_output,\s*0\.0\s*\)\s*;",
        )

    def test_cp2077_linear_solver_oracle_expands_and_converges(self):
        reference_input, reference_output = (
            solve_psychov_neutral_reference(
                lambda value: value * 0.01,
                unmatched_anchor=0.18,
            )
        )
        self.assertAlmostEqual(reference_input, 18.0, delta=4.0e-4)
        self.assertAlmostEqual(reference_output, 0.18, delta=4.0e-6)
        self.assertGreaterEqual(reference_output, 0.18)

        identity_input, identity_output = (
            solve_psychov_neutral_reference(
                lambda value: value,
                unmatched_anchor=0.75,
            )
        )
        self.assertAlmostEqual(identity_input, 0.18, delta=1.2e-5)
        self.assertAlmostEqual(identity_output, 0.18, delta=1.2e-5)
        self.assertGreaterEqual(identity_output, 0.18)

        unbracketed_input, unbracketed_output = (
            solve_psychov_neutral_reference(
                lambda value: 0.0,
                unmatched_anchor=0.18,
            )
        )
        self.assertAlmostEqual(unbracketed_input, 0.18 * 256.0)
        self.assertEqual(unbracketed_output, 0.0)

    def test_cp2077_log_slope_oracle_preserves_exact_zero_cases(self):
        self.assertEqual(
            psychov_log_slope(0.18, 0.18, 0.18, 0.1, 0.18, 0.2),
            0.0,
        )
        self.assertEqual(
            psychov_log_slope(0.18, 0.0, 0.17, 0.0, 0.19, 0.1),
            1.0,
        )

    def test_cone_response_is_defined_inside_each_psychov_branch(self):
        executable = strip_shader_comments(self.scene)
        main = executable.index("void main()")
        shared_reference = executable.index(
            "sPsychoVVanillaReference =", main
        )
        barrier = executable.index("barrier();", shared_reference)
        memory_barrier = executable.index("memoryBarrierShared();", barrier)
        tone_output = executable.index("vec3 renodx_tonemapped", memory_barrier)
        branch17 = executable[
            executable.index("if (CUSTOM_PSYCHOV17_ACTIVE)", tone_output) :
            executable.index("else if (CUSTOM_PSYCHOV22_ACTIVE)", tone_output)
        ]
        branch22_start = executable.index(
            "else if (CUSTOM_PSYCHOV22_ACTIVE)", tone_output
        )
        branch22 = executable[
            branch22_start : executable.index(
                "else if (CUSTOM_PSYCHOV24_ACTIVE)", branch22_start
            )
        ]
        branch24_start = executable.index(
            "else if (CUSTOM_PSYCHOV24_ACTIVE)", tone_output
        )
        branch24 = executable[
            branch24_start : executable.index("else", branch24_start + 8)
        ]
        cone_pattern = re.compile(
            r"const float renodx_psychov_cone_response\s*=\s*"
            r"max\(RENODX_PSYCHOV_CONE_RESPONSE,\s*0\.0\)\s*"
            r"\*\s*mix\(\s*1\.0,\s*"
            r"sPsychoVVanillaReference\.z,\s*"
            r"clamp\(RENODX_PSYCHOV_VANILLA_SLOPE,\s*0\.0,\s*1\.0\)\)\s*;"
        )

        self.assertLess(shared_reference, barrier)
        self.assertLess(barrier, memory_barrier)
        self.assertNotIn(
            "renodx_psychov_cone_response",
            executable[memory_barrier:tone_output],
        )
        for name, branch, call in (
            ("PsychoV-17", branch17, "psychotm_test17"),
            ("PsychoV-22", branch22, "psychotm_test22"),
            ("PsychoV-24", branch24, "psychotm_test24"),
        ):
            with self.subTest(mode=name):
                self.assertEqual(len(cone_pattern.findall(branch)), 1)
                self.assertLess(
                    branch.index("renodx_psychov_cone_response"),
                    branch.index(call),
                )

    def test_all_versions_use_strict_psychov_argument_contract(self):
        test17_arguments = extract_call_arguments(
            self.scene,
            "renodx::tonemap::psychov::psychotm_test17",
        )
        self.assertEqual(
            test17_arguments,
            (
                "renodx_psychov_input",
                "renodx_psychov_peak",
                "RENODX_TONE_MAP_EXPOSURE",
                "RENODX_TONE_MAP_HIGHLIGHTS",
                "RENODX_TONE_MAP_SHADOWS",
                "RENODX_TONE_MAP_CONTRAST",
                "RENODX_TONE_MAP_SATURATION",
                "1.0",
                "100.0",
                "1.0",
                "1.0",
                "0",
                "renodx_psychov_cone_response",
                "vec3(sPsychoVVanillaReference.x)",
                "vec3(sPsychoVVanillaReference.y)",
                "1.0",
                "renodx_psychov_gamut_mode",
                "1.0",
            ),
        )

        test22_arguments = extract_call_arguments(
            self.scene,
            "renodx::tonemap::psychov::psychotm_test22",
        )
        self.assertEqual(
            test22_arguments,
            (
                "renodx_psychov_input",
                "renodx_psychov_peak",
                "RENODX_TONE_MAP_EXPOSURE",
                "RENODX_TONE_MAP_HIGHLIGHTS",
                "RENODX_TONE_MAP_SHADOWS",
                "RENODX_TONE_MAP_CONTRAST",
                "RENODX_TONE_MAP_SATURATION",
                "1.0",
                "100.0",
                "1.0",
                "1.0",
                "0",
                "renodx_psychov_cone_response",
                "vec3(sPsychoVVanillaReference.x)",
                "vec3(sPsychoVVanillaReference.y)",
                "1.0",
                "renodx_psychov_gamut_mode",
                "1.0",
                "1.0",
            ),
        )

        test24_arguments = extract_call_arguments(
            self.scene,
            "renodx::tonemap::psychov::psychotm_test24",
        )
        self.assertEqual(
            test24_arguments,
            (
                "renodx_psychov_input",
                "renodx_psychov_peak",
                "RENODX_TONE_MAP_EXPOSURE",
                "RENODX_TONE_MAP_HIGHLIGHTS",
                "RENODX_TONE_MAP_SHADOWS",
                "RENODX_TONE_MAP_CONTRAST",
                "RENODX_TONE_MAP_SATURATION",
                "1.0",
                "100.0",
                "1.0",
                "1.0",
                "0",
                "renodx_psychov_cone_response",
                "vec3(sPsychoVVanillaReference.x)",
                "vec3(sPsychoVVanillaReference.y)",
                "1.0",
                "renodx_psychov_gamut_mode",
                "1.0",
                "1.0",
                "1.0",
                "0.0",
            ),
        )
        self.assertRegex(
            self.scene,
            r"const int renodx_psychov_gamut_mode\s*=\s*"
            r"CUSTOM_PSYCHOV_BT2020_ACTIVE\s*\?\s*1\s*:\s*0\s*;",
        )
        self.assertNotRegex(
            self.scene,
            r"const int renodx_psychov_gamut_mode\s*=\s*1\s*;",
        )
        for obsolete_parameter in (
            "RENODX_PSYCHOV_INPUT_ADAPTATION",
            "RENODX_PSYCHOV_OUTPUT_ADAPTATION",
            "RENODX_PSYCHOV_GAMUT_COMPRESSION",
            "RENODX_PSYCHOV17_BLEACHING",
            "RENODX_PSYCHOV17_HUE_RESTORE",
            "RENODX_PSYCHOV22_COMPRESSION",
        ):
            with self.subTest(obsolete_parameter=obsolete_parameter):
                self.assertNotIn(obsolete_parameter, test17_arguments)
                self.assertNotIn(obsolete_parameter, test22_arguments)
                self.assertNotIn(obsolete_parameter, test24_arguments)

    def test_psychov_operations_keep_the_required_order(self):
        executable = strip_shader_comments(self.scene)
        reference = executable.index(
            "sPsychoVVanillaReference =", executable.index("void main()")
        )
        barrier = executable.index("barrier();", reference)
        grade = executable.index("ComputeUntonemappedGraded", barrier)
        peak = executable.index("const float renodx_psychov_peak", grade)
        fixed_gamut = executable.index(
            "const int renodx_psychov_gamut_mode =", peak
        )
        cone = executable.index(
            "const float renodx_psychov_cone_response", fixed_gamut
        )
        test17 = executable.index("psychotm_test17", cone)
        convert17 = executable.index(
            "renodx::color::bt2020::from::BT709", test17
        )
        sanitize17 = executable.rfind(
            "SanitizePsychoVDisplay", test17, convert17
        )
        gamma17 = executable.index("GammaSafe", convert17)
        test22 = executable.index("psychotm_test22", gamma17)
        convert22 = executable.index(
            "renodx::color::bt2020::from::BT709", test22
        )
        sanitize22 = executable.rfind(
            "SanitizePsychoVDisplay", test22, convert22
        )
        gamma22 = executable.index("GammaSafe", convert22)
        test24 = executable.index("psychotm_test24", gamma22)
        convert24 = executable.index(
            "renodx::color::bt2020::from::BT709", test24
        )
        sanitize24 = executable.rfind(
            "SanitizePsychoVDisplay", test24, convert24
        )
        gamma24 = executable.index("GammaSafe", convert24)
        scale = executable.index("const float renodx_game_scale", gamma24)

        self.assertLess(reference, barrier)
        self.assertLess(barrier, grade)
        self.assertLess(grade, peak)
        self.assertLess(peak, fixed_gamut)
        self.assertLess(fixed_gamut, cone)
        self.assertLess(cone, test17)
        self.assertGreaterEqual(sanitize17, 0)
        self.assertLess(test17, sanitize17)
        self.assertLess(sanitize17, convert17)
        self.assertLess(convert17, gamma17)
        self.assertLess(gamma17, test22)
        self.assertGreaterEqual(sanitize22, 0)
        self.assertLess(test22, sanitize22)
        self.assertLess(sanitize22, convert22)
        self.assertLess(convert22, gamma22)
        self.assertLess(gamma22, test24)
        self.assertGreaterEqual(sanitize24, 0)
        self.assertLess(test24, sanitize24)
        self.assertLess(sanitize24, convert24)
        self.assertLess(convert24, gamma24)
        self.assertLess(gamma24, scale)

    def test_sanitize_is_finite_nonnegative_and_peak_preserving(self):
        sanitizer = self.scene[
            self.scene.index("vec3 SanitizePsychoVDisplay") :
            self.scene.index("void main()")
        ]
        self.assertIn("renodx::math::ZeroNaN(color)", sanitizer)
        self.assertRegex(
            sanitizer,
            r"isinf\(display\.x\)\s*\?\s*safe_peak\s*:\s*display\.x",
        )
        self.assertRegex(
            sanitizer,
            r"display\s*\*=\s*safe_peak\s*/\s*"
            r"max\(output_peak,\s*1\.0e-6\)",
        )
        self.assertNotIn("min(", sanitizer)

    def test_no_unsafe_post_psychov_color_correction(self):
        psychov_path = self.scene[self.scene.index("psychotm_test17") :]
        self.assertNotIn("RestorePsychoVHighlightColor", psychov_path)
        self.assertNotIn("ApplyPerChannelCorrection", psychov_path)
        self.assertNotRegex(psychov_path.lower(), r"ictcp|\bpq::")

    def test_current_frame_carrier_bit_is_the_authoritative_wide_gate(self):
        compact_shared = re.sub(r"\\\s*\n\s*", " ", self.shared)
        self.assertRegex(
            compact_shared,
            r"#define\s+CUSTOM_RUNTIME_FLAGS\s+"
            r"uint\(max\(shader_injection\.runtime_flags,\s*0\.f\)\)",
        )
        self.assertRegex(
            compact_shared,
            r"#define\s+CUSTOM_PSYCHOV_BT2020_ACTIVE\s+"
            r"\(\(CUSTOM_RUNTIME_FLAGS\s*&\s*0x2u\)\s*!=\s*0u\)",
        )
        carrier_macro = re.search(
            r"#define\s+CUSTOM_PSYCHOV_BT2020_ACTIVE\s+([^\n]+)",
            compact_shared,
        )
        self.assertIsNotNone(carrier_macro)
        self.assertNotIn("CUSTOM_HDR_ACTIVE", carrier_macro.group(1))
        self.assertNotIn("RENODX_PSYCHOV_GAMUT_MODE", carrier_macro.group(1))
        self.assertNotIn("CUSTOM_RENDER_DEBUG_PAYLOAD", carrier_macro.group(1))

        self.assertRegex(
            self.scene,
            r"const int renodx_psychov_gamut_mode\s*=\s*"
            r"CUSTOM_PSYCHOV_BT2020_ACTIVE\s*\?\s*1\s*:\s*0\s*;",
        )
        for function_name in (
            "psychotm_test17",
            "psychotm_test22",
            "psychotm_test24",
        ):
            with self.subTest(function=function_name):
                arguments = extract_call_arguments(
                    self.scene,
                    f"renodx::tonemap::psychov::{function_name}",
                )
                self.assertEqual(arguments[16], "renodx_psychov_gamut_mode")

    def test_native_mire_patterns_join_the_active_bt2020_carrier(self):
        self.assertIn(
            '#include "hdr_intermediate.hlsli"',
            self.scene,
        )
        executable_scene = strip_shader_comments(self.scene)
        self.assertRegex(
            executable_scene,
            re.compile(
                r"if\s*\(CUSTOM_PSYCHOV_BT2020_ACTIVE\s*"
                r"&&\s*_541\.g_cbComposite\._viMireSrgb\.x\s*!=\s*0\)"
                r"\s*\{\s*_2706\s*=\s*"
                r"DetroitBt709CodeToBt2020Code\(_2706\)\s*;",
                re.DOTALL,
            ),
        )
        self.assertRegex(
            self.hdr_intermediate,
            re.compile(
                r"DetroitBt709CodeToBt2020Code\(vec3 bt709_code\).*?"
                r"DetroitDisplayLightToIntermediateCode\(\s*"
                r"DetroitBt709ToBt2020\(\s*"
                r"DetroitIntermediateCodeToDisplayLight\(bt709_code\)\s*"
                r"\)\s*\)",
                re.DOTALL,
            ),
        )

        # Saturated native test-pattern code must be converted in display
        # light, not multiplied directly in its gamma-shaped carrier.
        native_blue = (0.0, 0.0, 1.0)
        display_blue = tuple(channel**2.2 for channel in native_blue)
        wide_display = multiply_matrix(BT709_TO_BT2020, display_blue)
        wide_code = tuple(max(channel, 0.0) ** (1.0 / 2.2)
                          for channel in wide_display)
        decoded = tuple(channel**2.2 for channel in wide_code)
        for actual, expected in zip(decoded, wide_display):
            self.assertAlmostEqual(actual, expected, places=12)

    def test_cp2077_controls_reuse_the_existing_psychov_abi_slots(self):
        self.assertRegex(
            self.shared,
            re.compile(
                r"float psychov_cone_response;\s*"
                r"float psychov_exposure_match;\s*"
                r"float psychov_vanilla_slope;\s*"
                r"float psychov_gamut_mode;",
                re.DOTALL,
            ),
        )
        self.assertIn("#define RENODX_PSYCHOV_CONE_RESPONSE", self.shared)
        self.assertIn("#define RENODX_PSYCHOV_EXPOSURE_MATCH", self.shared)
        self.assertIn("#define RENODX_PSYCHOV_VANILLA_SLOPE", self.shared)
        self.assertRegex(
            self.temporal_aux,
            re.compile(
                r"float psychov_cone_response;\s*"
                r"float psychov_exposure_match;\s*"
                r"float psychov_vanilla_slope;\s*"
                r"float psychov_gamut_mode;\s*"
                r"float psychov17_bleaching;",
                re.DOTALL,
            ),
        )
        for field in (
            "psychov_cone_response",
            "psychov_exposure_match",
            "psychov_vanilla_slope",
        ):
            with self.subTest(field=field):
                self.assertIn(
                    f"!isnan(shader_injection.{field})", self.temporal_aux
                )
                self.assertIn(
                    f"!isinf(shader_injection.{field})", self.temporal_aux
                )

    def test_runtime_flags_reuse_offset_76_without_changing_the_112_byte_abi(self):
        expected_slice = (
            "runtime_flags",
            "psychov_cone_response",
            "psychov_exposure_match",
            "psychov_vanilla_slope",
        )
        for name, source in (
            ("shared", self.shared),
            ("temporal auxiliary", self.temporal_aux),
        ):
            with self.subTest(source=name):
                struct_body = re.search(
                    r"struct\s+ShaderInjectData(?:_std140)?\s*"
                    r"\{(?P<body>.*?)\};",
                    source,
                    re.DOTALL,
                )
                self.assertIsNotNone(struct_body)
                fields = tuple(
                    re.findall(r"\bfloat\s+([A-Za-z0-9_]+)\s*;", struct_body.group("body"))
                )
                self.assertEqual(fields[19:23], expected_slice)
                self.assertEqual(fields.index("runtime_flags") * 4, 76)
                self.assertEqual(fields.index("psychov_cone_response") * 4, 80)
                self.assertEqual(fields.index("psychov_exposure_match") * 4, 84)
                self.assertEqual(fields.index("psychov_vanilla_slope") * 4, 88)
                self.assertEqual(len(fields) * 4, 112)
        self.assertIn("static_assert(sizeof(ShaderInjectData) == 112u);", self.shared)
        self.assertIn(
            "!isnan(shader_injection.runtime_flags)", self.temporal_aux
        )
        self.assertIn(
            "!isinf(shader_injection.runtime_flags)", self.temporal_aux
        )
        self.assertNotRegex(self.shared, r"\bfloat\s+reserved\s*;")
        self.assertNotRegex(self.temporal_aux, r"\bfloat\s+reserved\s*;")

    def test_cp2077_psychov_settings_have_exact_defaults_and_parses(self):
        cone = extract_setting(self.addon, "ColorGradeConeResponse")
        self.assertIn(
            ".binding = &shader_injection.psychov_cone_response", cone
        )
        self.assertIn('.label = "Cone Response"', cone)
        self.assertIn('.section = "Color Grading"', cone)
        self.assertRegex(cone, r"\.default_value\s*=\s*50\.f")
        self.assertRegex(cone, r"\.min\s*=\s*0\.f")
        self.assertRegex(cone, r"\.max\s*=\s*100\.f")
        self.assertRegex(
            cone,
            r"\.parse\s*=\s*\[\]\(float value\)\s*"
            r"\{\s*return value \* 0\.02f;\s*\}",
        )
        self.assertRegex(cone, r"tone_map_type\s*>=\s*2\.f")

        exposure_match = extract_setting(
            self.addon, "ToneMapPsychoVExposureMatch"
        )
        self.assertIn(
            ".binding = &shader_injection.psychov_exposure_match",
            exposure_match,
        )
        self.assertIn("SettingValueType::BOOLEAN", exposure_match)
        self.assertIn('.label = "Exposure Match"', exposure_match)
        self.assertIn('.section = "Color Grading"', exposure_match)
        self.assertRegex(exposure_match, r"\.default_value\s*=\s*1\.f")
        self.assertRegex(exposure_match, r"tone_map_type\s*>=\s*2\.f")

        slope = extract_setting(
            self.addon, "ToneMapPsychoVVanillaHDRSlope"
        )
        self.assertIn(
            ".binding = &shader_injection.psychov_vanilla_slope", slope
        )
        self.assertIn('.label = "Vanilla HDR Slope"', slope)
        self.assertIn('.section = "Color Grading"', slope)
        self.assertRegex(slope, r"\.default_value\s*=\s*100\.f")
        self.assertRegex(slope, r"\.min\s*=\s*0\.f")
        self.assertRegex(slope, r"\.max\s*=\s*100\.f")
        self.assertRegex(
            slope,
            r"\.parse\s*=\s*\[\]\(float value\)\s*"
            r"\{\s*return value \* 0\.01f;\s*\}",
        )
        self.assertRegex(slope, r"tone_map_type\s*>=\s*2\.f")

        for key, value in (
            ("ColorGradeConeResponse", "50.f"),
            ("ToneMapPsychoVExposureMatch", "1.f"),
            ("ToneMapPsychoVVanillaHDRSlope", "100.f"),
        ):
            with self.subTest(reset_key=key):
                self.assertIn(f'{{"{key}", {value}}}', self.addon)

    def test_old_manual_psychov_settings_are_absent(self):
        for key in (
            "PsychoVInputAdaptation",
            "PsychoVOutputAdaptation",
            "PsychoVGamutCompression",
            "PsychoVGamut",
            "PsychoV17Bleaching",
            "PsychoV17HueRestore",
            "PsychoV22Compression",
            "PsychoV22HighlightColorRestore",
        ):
            with self.subTest(key=key):
                self.assertNotIn(f'"{key}"', self.addon)

    def test_bt2020_signed_representatives_convert_before_sanitize(self):
        representatives = {
            "red": (1.6604910021, -0.1245504745, -0.0181507634),
            "green": (-0.5876411388, 1.1328998971, -0.1005788980),
            "blue": (-0.0728498633, -0.0083494226, 1.1187296614),
        }
        for index, (name, representative) in enumerate(
            representatives.items()
        ):
            with self.subTest(primary=name):
                converted = psychov_raw_to_intermediate(
                    representative, 1.0, True
                )
                expected = tuple(
                    1.0 if channel == index else 0.0
                    for channel in range(3)
                )
                for actual, target in zip(converted, expected):
                    self.assertAlmostEqual(actual, target, delta=6.0e-5)

                clipped_first = sanitize_psychov_display(
                    representative, 1.0
                )
                wrong_order = multiply_matrix(
                    BT709_TO_BT2020, clipped_first
                )
                self.assertGreater(
                    max(
                        abs(actual - target)
                        for actual, target in zip(wrong_order, expected)
                    ),
                    0.05,
                )

    def test_p3_and_bt2020_chromaticity_survive_the_wide_round_trip(self):
        bt2020_to_p3 = (
            (1.34357821, -0.282179683, -0.0613985806),
            (-0.0652974545, 1.07578790, -0.0104904631),
            (0.00282178726, -0.0195984952, 1.01677668),
        )
        swatches_bt2020 = {
            "p3_red": (0.80, 0.10, 0.02),
            "bt2020_blue": (0.02, 0.10, 1.00),
        }
        p3_as_p3 = multiply_matrix(
            bt2020_to_p3, swatches_bt2020["p3_red"]
        )
        p3_as_bt709 = multiply_matrix(
            BT2020_TO_BT709, swatches_bt2020["p3_red"]
        )
        outer_as_p3 = multiply_matrix(
            bt2020_to_p3, swatches_bt2020["bt2020_blue"]
        )
        self.assertTrue(all(channel >= 0.0 for channel in p3_as_p3))
        self.assertTrue(any(channel < 0.0 for channel in p3_as_bt709))
        self.assertTrue(any(channel < 0.0 for channel in outer_as_p3))

        game_nits = 203.0
        for name, display_bt2020 in swatches_bt2020.items():
            with self.subTest(swatch=name):
                raw_bt709 = multiply_matrix(BT2020_TO_BT709, display_bt2020)
                pq, decoded_bt2020 = full_detroit_round_trip(
                    raw_bt709,
                    game_nits,
                    psychov_peak=2.0,
                    wide_gamut=True,
                )
                self.assertTrue(all(math.isfinite(value) for value in pq))
                self.assertTrue(
                    all(math.isfinite(value) for value in decoded_bt2020)
                )
                expected = tuple(
                    channel * game_nits / 300.0
                    for channel in display_bt2020
                )
                expected_sum = sum(expected)
                decoded_sum = sum(decoded_bt2020)
                for target, actual in zip(expected, decoded_bt2020):
                    self.assertAlmostEqual(
                        actual / decoded_sum,
                        target / expected_sum,
                        delta=5.0e-5,
                    )

    def test_wide_round_trip_preserves_luminance_and_configured_peak(self):
        bt2020_luma = (0.2627002, 0.6779981, 0.0593017)
        game_nits = 203.0
        for peak_nits in (600.0, 1000.0, 1033.0, 1068.0):
            with self.subTest(peak_nits=peak_nits):
                psychov_peak = peak_nits / game_nits
                display_bt2020 = (0.12, 0.35, psychov_peak)
                raw_bt709 = multiply_matrix(BT2020_TO_BT709, display_bt2020)
                transported_bt2020 = psychov_raw_to_intermediate(
                    raw_bt709, psychov_peak, True
                )
                _, decoded_bt2020 = full_detroit_round_trip(
                    raw_bt709,
                    game_nits,
                    psychov_peak,
                    wide_gamut=True,
                )
                self.assertAlmostEqual(
                    max(decoded_bt2020) * 300.0, peak_nits, places=6
                )
                expected_luminance = sum(
                    weight * channel * game_nits
                    for weight, channel in zip(
                        bt2020_luma, transported_bt2020
                    )
                )
                actual_luminance = sum(
                    weight * channel * 300.0
                    for weight, channel in zip(bt2020_luma, decoded_bt2020)
                )
                self.assertAlmostEqual(
                    actual_luminance, expected_luminance, places=6
                )

    def test_sanitize_is_finite_nonnegative_and_peak_bounded(self):
        scaled = sanitize_psychov_display((10.0, 5.0, 2.0), 5.0)
        self.assertEqual(scaled, (5.0, 2.5, 1.0))
        self.assertAlmostEqual(scaled[0] / scaled[1], 2.0)
        self.assertAlmostEqual(scaled[1] / scaled[2], 2.5)

        inf_replaced = sanitize_psychov_display(
            (math.inf, 2.0, 1.0), 5.0
        )
        self.assertEqual(inf_replaced, (5.0, 2.0, 1.0))


if __name__ == "__main__":
    unittest.main()
