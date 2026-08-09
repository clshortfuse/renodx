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


def _clamp(value: float, minimum: float, maximum: float) -> float:
    return min(max(value, minimum), maximum)


def _smoothstep(edge0: float, edge1: float, value: float) -> float:
    position = _clamp((value - edge0) / (edge1 - edge0), 0.0, 1.0)
    return position * position * (3.0 - 2.0 * position)


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


def restore_psychov_highlight_color(
    scene_linear_bt709: tuple[float, float, float],
    psychov_display_bt709: tuple[float, float, float],
    psychov_peak: float,
    restore_strength: float,
    highlights: float = 1.0,
    shadows: float = 1.0,
    contrast: float = 1.0,
    saturation: float = 1.0,
) -> tuple[float, float, float]:
    """Numeric model of Detroit's finite, peak-safe highlight blend."""
    strength = _clamp(restore_strength, 0.0, 1.0)
    neutral_color_controls = all(
        abs(control - 1.0) <= 1.0e-6
        for control in (highlights, shadows, contrast, saturation)
    )
    if strength <= 0.0 or not neutral_color_controls:
        return psychov_display_bt709

    source = tuple(
        max(0.0 if math.isnan(channel) else channel, 0.0)
        for channel in scene_linear_bt709
    )
    if any(math.isinf(channel) for channel in source):
        return psychov_display_bt709

    source_peak = max(source)
    mapped_peak = max(psychov_display_bt709)
    if source_peak <= 1.0e-6 or mapped_peak <= 1.0e-6:
        return psychov_display_bt709

    source_at_mapped_peak = tuple(
        channel * mapped_peak / source_peak for channel in source
    )
    source_purity = (source_peak - min(source)) / source_peak
    mapped_purity = (
        mapped_peak - min(psychov_display_bt709)
    ) / mapped_peak
    purity_loss = _clamp(
        (source_purity - mapped_purity) / max(source_purity, 1.0e-6),
        0.0,
        1.0,
    )
    highlight_weight = _smoothstep(
        1.0, max(psychov_peak, 1.0001), mapped_peak
    )
    blend = strength * purity_loss * highlight_weight
    return tuple(
        mapped + (source_value - mapped) * blend
        for mapped, source_value in zip(
            psychov_display_bt709, source_at_mapped_peak
        )
    )


def full_detroit_round_trip(
    psychov_display_bt709: tuple[float, float, float], game_nits: float
) -> tuple[
    tuple[float, float, float],
    tuple[float, float, float],
]:
    """Model PsychoV display light -> Detroit native -> Rec.2020/PQ."""
    psychov_native_bt709 = tuple(
        detroit_display_to_native(channel)
        for channel in psychov_display_bt709
    )
    scaled_native_bt709 = tuple(
        detroit_exact_display_light_scale(channel, game_nits)
        for channel in psychov_native_bt709
    )
    display_bt709 = tuple(
        detroit_native_to_display(channel)
        for channel in scaled_native_bt709
    )
    display_bt2020 = multiply_matrix(BT709_TO_BT2020, display_bt709)
    pq = tuple(pq_encode(channel * 300.0 / 10000.0) for channel in display_bt2020)
    decoded_bt2020 = tuple(pq_decode(channel) * 10000.0 / 300.0 for channel in pq)
    decoded_bt709 = multiply_matrix(BT2020_TO_BT709, decoded_bt2020)
    return pq, decoded_bt709


class PsychoVContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.scene = SCENE_SOURCE.read_text(encoding="utf-8")
        cls.addon = ADDON_SOURCE.read_text(encoding="utf-8")
        cls.shared = SHARED_SOURCE.read_text(encoding="utf-8")

    def test_p17_direct_and_p22_restored_are_each_encoded_once(self):
        test17 = self.scene[
            self.scene.index("if (CUSTOM_PSYCHOV17_ACTIVE)") :
            self.scene.index("else if (CUSTOM_PSYCHOV22_ACTIVE)")
        ]
        test22 = self.scene[
            self.scene.index("else if (CUSTOM_PSYCHOV22_ACTIVE)") :
            self.scene.index("else\n            {", self.scene.index(
                "else if (CUSTOM_PSYCHOV22_ACTIVE)"
            ))
        ]
        self.assertRegex(
            test17,
            r"renodx_tonemapped\s*=\s*"
            r"renodx::color::correct::GammaSafe\(\s*"
            r"renodx_psychov_display\s*,\s*"
            r"true\s*,\s*2\.2\s*\)\s*;",
        )
        self.assertNotIn("RestorePsychoVHighlightColor", test17)
        self.assertEqual(
            len(re.findall(r"SanitizePsychoVDisplay\(", test17)),
            1,
        )
        self.assertRegex(
            test22,
            r"renodx_tonemapped\s*=\s*"
            r"renodx::color::correct::GammaSafe\(\s*"
            r"renodx_psychov_restored\s*,\s*"
            r"true\s*,\s*2\.2\s*\)\s*;",
        )
        self.assertEqual(
            len(re.findall(r"RestorePsychoVHighlightColor\(", test22)),
            1,
        )
        self.assertEqual(
            len(re.findall(r"SanitizePsychoVDisplay\(", test22)),
            1,
        )
        self.assertEqual(
            len(re.findall(r"RestorePsychoVHighlightColor\(", self.scene)),
            2,
        )
        self.assertEqual(
            len(re.findall(r"SanitizePsychoVDisplay\(", self.scene)),
            3,
        )

    def test_peak_passed_to_psychov_is_display_linear(self):
        self.assertRegex(
            self.scene,
            r"renodx_psychov_peak\s*=\s*"
            r"RENODX_PEAK_WHITE_NITS\s*/\s*"
            r"max\(RENODX_DIFFUSE_WHITE_NITS,\s*1e-6\)",
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

    def test_scene_grading_still_precedes_both_psychov_calls(self):
        grade = self.scene.index("ComputeUntonemappedGraded")
        test17 = self.scene.index("psychotm_test17", grade)
        test22 = self.scene.index("psychotm_test22", test17)
        self.assertLess(grade, test17)
        self.assertLess(test17, test22)
        self.assertRegex(
            self.scene[grade:test22],
            r"psychotm_test17\(\s*renodx_psychov_input\s*,",
        )
        self.assertRegex(
            self.scene[test22 : test22 + 512],
            r"psychotm_test22\(\s*renodx_psychov_input\s*,",
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

    def test_both_versions_use_strict_psychov_argument_contract(self):
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
                "RENODX_PSYCHOV17_BLEACHING",
                "100.0",
                "RENODX_PSYCHOV17_HUE_RESTORE",
                "1.0",
                "0",
                "1.0",
                "vec3(RENODX_PSYCHOV_INPUT_ADAPTATION)",
                "vec3(RENODX_PSYCHOV_OUTPUT_ADAPTATION)",
                "RENODX_PSYCHOV_GAMUT_COMPRESSION",
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
                "1.0",
                "vec3(RENODX_PSYCHOV_INPUT_ADAPTATION)",
                "vec3(RENODX_PSYCHOV_OUTPUT_ADAPTATION)",
                "RENODX_PSYCHOV_GAMUT_COMPRESSION",
                "renodx_psychov_gamut_mode",
                "1.0",
                "RENODX_PSYCHOV22_COMPRESSION",
            ),
        )
        self.assertRegex(
            self.scene,
            r"const int renodx_psychov_gamut_mode\s*=\s*0\s*;",
        )
        self.assertNotIn("RENODX_PSYCHOV_GAMUT_MODE", self.scene)

    def test_sanitize_and_safe_restore_use_peak_preserving_bt709_math(self):
        sanitizer = self.scene[
            self.scene.index("vec3 SanitizePsychoVDisplay") :
            self.scene.index("vec3 RestorePsychoVHighlightColor")
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

        helper = self.scene[
            self.scene.index("vec3 RestorePsychoVHighlightColor") :
            self.scene.index("void main()")
        ]
        self.assertIn("renodx::math::ZeroNaN(scene_linear_bt709)", helper)
        for control in ("HIGHLIGHTS", "SHADOWS", "CONTRAST", "SATURATION"):
            self.assertRegex(
                helper,
                rf"abs\(RENODX_TONE_MAP_{control}\s*-\s*1\.0\)\s*"
                rf"<=\s*1\.0e-6",
            )
        self.assertRegex(
            helper,
            r"restore_strength\s*<=\s*0\.0\s*\|\|\s*"
            r"!neutral_color_controls",
        )
        self.assertRegex(
            helper,
            r"source_at_mapped_peak\s*=\s*"
            r"source\s*\*\s*\(mapped_peak\s*/\s*source_peak\)",
        )
        self.assertRegex(
            helper,
            r"return mix\(\s*psychov_display_bt709\s*,\s*"
            r"source_at_mapped_peak\s*,",
        )
        executable = "\n".join(
            line for line in helper.splitlines()
            if not line.lstrip().startswith("//")
        )
        self.assertNotIn("ApplyPerChannelCorrection", executable)
        self.assertNotRegex(executable.lower(), r"ictcp|\bpq::")

    def test_no_unsafe_post_psychov_color_correction(self):
        psychov_path = self.scene[self.scene.index("psychotm_test17") :]
        self.assertNotIn("ApplyPerChannelCorrection", psychov_path)
        self.assertNotRegex(psychov_path.lower(), r"ictcp|\bpq::")

    def test_restore_payload_reuses_retired_gamut_slot(self):
        self.assertRegex(
            self.shared,
            re.compile(
                r"float psychov_input_adaptation;\s*"
                r"float psychov_output_adaptation;\s*"
                r"float psychov_gamut_compression;\s*"
                r"float psychov22_highlight_color_restore;",
                re.DOTALL,
            ),
        )
        self.assertNotIn("psychov_gamut_mode", self.shared)
        self.assertIn(
            "#define RENODX_PSYCHOV22_HIGHLIGHT_COLOR_RESTORE",
            self.shared,
        )

    def test_highlight_color_restore_control_is_psychov22_only(self):
        setting = re.search(
            r'\.key\s*=\s*"PsychoV22HighlightColorRestore"(?P<body>.*?)'
            r'\.key\s*=\s*"PsychoV17Bleaching"',
            self.addon,
            re.DOTALL,
        )
        self.assertIsNotNone(setting)
        body = setting.group("body")
        self.assertIn('.label = "Highlight Color Restore"', body)
        self.assertIn('.section = "PsychoV-22"', body)
        self.assertRegex(body, r"tone_map_type\s*==\s*4\.f")
        self.assertRegex(body, r"\.default_value\s*=\s*0\.f")
        self.assertIn("override some Gamut Compression chroma", body)
        self.assertIn(
            '{"PsychoV22HighlightColorRestore", 0.f}', self.addon
        )

    def test_hue_restore_control_remains_internal_to_psychov17(self):
        setting = re.search(
            r'\.key\s*=\s*"PsychoV17HueRestore"(?P<body>.*?)'
            r'\.key\s*=\s*"PsychoV22Compression"',
            self.addon,
            re.DOTALL,
        )
        self.assertIsNotNone(setting)
        body = setting.group("body")
        self.assertIn('.label = "Hue Restore"', body)
        self.assertIn('.section = "PsychoV-17"', body)
        self.assertRegex(body, r"tone_map_type\s*==\s*3\.f")
        self.assertRegex(body, r"\.default_value\s*=\s*100\.f")

    def test_blue_and_cyan_round_trip_preserves_chromaticity(self):
        swatches = {
            "blue": (0.10, 0.40, 2.00),
            "cyan": (0.05, 1.20, 1.50),
        }
        for name, swatch in swatches.items():
            with self.subTest(swatch=name):
                pq, decoded = full_detroit_round_trip(swatch, 203.0)
                self.assertTrue(all(math.isfinite(value) for value in pq))
                self.assertTrue(all(math.isfinite(value) for value in decoded))
                self.assertGreater(decoded[2], decoded[1])
                self.assertGreater(decoded[1], decoded[0])
                self.assertGreater(max(decoded) - min(decoded), 0.25)
                expected_display = tuple(
                    value * 203.0 / 300.0
                    for value in swatch
                )
                expected_sum = sum(expected_display)
                actual_sum = sum(decoded)
                for expected, actual in zip(expected_display, decoded):
                    self.assertAlmostEqual(
                        actual / actual_sum,
                        expected / expected_sum,
                        delta=5.0e-5,
                    )

    def test_bt709_hull_is_hardcoded_not_user_selectable(self):
        self.assertNotIn('.key = "PsychoVGamut"', self.addon)
        self.assertNotIn('{"PsychoVGamut",', self.addon)

    def test_safe_restore_bypasses_zero_strength_and_non_neutral_controls(self):
        mapped = (3.7, 3.6, 4.0)
        zero_strength = restore_psychov_highlight_color(
            (0.1, 4.0, 5.0), mapped, 5.0, 0.0
        )
        self.assertEqual(zero_strength, mapped)

        non_neutral_controls = (
            ("highlights", {"highlights": 0.5}),
            ("shadows", {"shadows": 0.0}),
            ("contrast", {"contrast": 1.5}),
            ("saturation_zero", {"saturation": 0.0}),
            ("saturation_half", {"saturation": 0.5}),
        )
        for name, controls in non_neutral_controls:
            with self.subTest(control=name):
                bypassed = restore_psychov_highlight_color(
                    (0.1, 4.0, 5.0),
                    mapped,
                    5.0,
                    1.0,
                    **controls,
                )
                self.assertEqual(bypassed, mapped)

        # Gamut Compression is already baked into PsychoV's mapped endpoint.
        # The default-zero post-gamut override must preserve every selection;
        # an explicit opt-in may change chroma but must retain the safety bounds.
        gamut_compression_endpoints = {
            0.0: (4.0, 3.0, 0.5),
            0.5: (4.0, 3.4, 1.7),
            1.0: (4.0, 3.8, 3.0),
        }
        source = (5.0, 4.5, 0.1)
        for compression, compressed_mapped in (
            gamut_compression_endpoints.items()
        ):
            with self.subTest(
                gamut_compression=compression,
                restore="default_off",
            ):
                default_result = restore_psychov_highlight_color(
                    source, compressed_mapped, 5.0, 0.0
                )
                self.assertEqual(default_result, compressed_mapped)

            with self.subTest(
                gamut_compression=compression,
                restore="explicit_on",
            ):
                opted_in = restore_psychov_highlight_color(
                    source, compressed_mapped, 5.0, 1.0
                )
                self.assertTrue(
                    all(math.isfinite(channel) for channel in opted_in)
                )
                self.assertTrue(all(channel >= 0.0 for channel in opted_in))
                self.assertLessEqual(
                    max(opted_in), max(compressed_mapped) + 1.0e-12
                )

    def test_sanitize_and_restore_are_finite_nonnegative_and_peak_bounded(self):
        scaled = sanitize_psychov_display((10.0, 5.0, 2.0), 5.0)
        self.assertEqual(scaled, (5.0, 2.5, 1.0))
        self.assertAlmostEqual(scaled[0] / scaled[1], 2.0)
        self.assertAlmostEqual(scaled[1] / scaled[2], 2.5)

        inf_replaced = sanitize_psychov_display(
            (math.inf, 2.0, 1.0), 5.0
        )
        self.assertEqual(inf_replaced, (5.0, 2.0, 1.0))

        cases = (
            ((5.0, 4.0, 0.1), (4.0, 3.7, 3.0)),
            ((0.2, 0.5, 6.0), (3.0, 3.1, 4.0)),
            ((math.nan, 5.0, 2.0), (math.nan, -1.0, math.inf)),
            ((math.inf, 1.0, 0.0), (1.5, 1.2, 2.0)),
            ((0.0, 0.0, 0.0), (0.0, 0.0, 0.0)),
        )
        peak = 5.0
        for scene, raw_mapped in cases:
            mapped = sanitize_psychov_display(raw_mapped, peak)
            for strength in (-1.0, 0.0, 0.5, 1.0, 2.0):
                with self.subTest(
                    scene=scene, mapped=mapped, strength=strength
                ):
                    restored = restore_psychov_highlight_color(
                        scene, mapped, peak, strength
                    )
                    self.assertTrue(
                        all(math.isfinite(channel) for channel in restored)
                    )
                    self.assertTrue(
                        all(channel >= 0.0 for channel in restored)
                    )
                    self.assertLessEqual(
                        max(restored), max(mapped) + 1.0e-12
                    )

    def test_safe_restore_recovers_lost_purity_only_in_highlights(self):
        swatches = {
            "yellow": ((5.0, 4.5, 0.1), (4.0, 3.7, 3.0)),
            "blue": ((0.2, 0.5, 6.0), (3.0, 3.1, 4.0)),
            "cyan": ((0.1, 5.0, 6.0), (2.8, 3.8, 4.0)),
        }
        peak = 5.0
        for name, (source, mapped) in swatches.items():
            with self.subTest(swatch=name, range="highlight"):
                restored = restore_psychov_highlight_color(
                    source, mapped, peak, 1.0
                )
                mapped_purity = (max(mapped) - min(mapped)) / max(mapped)
                restored_purity = (
                    max(restored) - min(restored)
                ) / max(restored)
                self.assertGreater(restored_purity, mapped_purity)
                self.assertLessEqual(max(restored), max(mapped) + 1.0e-12)

            midtone = tuple(channel * 0.2 for channel in mapped)
            with self.subTest(swatch=name, range="midtone"):
                restored_midtone = restore_psychov_highlight_color(
                    source, midtone, peak, 1.0
                )
                self.assertEqual(restored_midtone, midtone)


if __name__ == "__main__":
    unittest.main()
