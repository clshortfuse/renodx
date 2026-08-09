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


def full_detroit_round_trip(
    psychov_bt709: tuple[float, float, float], game_nits: float
) -> tuple[
    tuple[float, float, float],
    tuple[float, float, float],
]:
    """Model PsychoV's direct Detroit intermediate, Rec.2020 and PQ."""
    display_bt709 = tuple(
        detroit_display_light_scale(channel, game_nits)
        for channel in psychov_bt709
    )
    display_bt2020 = multiply_matrix(BT709_TO_BT2020, display_bt709)
    pq = tuple(pq_encode(channel * 300.0 / 10000.0) for channel in display_bt2020)
    decoded_bt2020 = tuple(pq_decode(channel) * 10000.0 / 300.0 for channel in pq)
    decoded_bt709 = multiply_matrix(BT2020_TO_BT709, decoded_bt2020)
    return pq, decoded_bt709


def detroit_display_light_scale(value: float, game_nits: float) -> float:
    """Literal model of Detroit's common gamma-2.2 scale."""
    return (
        max(value, 0.0) ** 2.2 * max(game_nits, 0.0) / 300.0
    ) ** (1.0 / 2.2)


class PsychoVContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.scene = SCENE_SOURCE.read_text(encoding="utf-8")
        cls.addon = ADDON_SOURCE.read_text(encoding="utf-8")

    def test_both_psychov_modes_feed_common_intermediate_directly(self):
        assignments = re.findall(
            r"renodx_tonemapped\s*=\s*max\(\s*"
            r"renodx_psychov_output\s*,\s*vec3\(0\.0\)\s*\)\s*;",
            self.scene,
        )
        self.assertEqual(len(assignments), 2)
        self.assertNotRegex(
            self.scene,
            r"pow\(\s*max\(\s*renodx_psychov_output",
        )

    def test_peak_matches_detroit_gamma_intermediate_representation(self):
        self.assertRegex(
            self.scene,
            r"renodx_psychov_peak_linear\s*=\s*"
            r"RENODX_PEAK_WHITE_NITS\s*/\s*"
            r"max\(RENODX_DIFFUSE_WHITE_NITS,\s*1e-6\)",
        )
        self.assertRegex(
            self.scene,
            r"renodx_psychov_peak\s*=\s*"
            r"renodx::color::correct::GammaSafe\(\s*"
            r"renodx_psychov_peak_linear\s*,\s*true\s*,\s*2\.2\s*\)",
        )

    def test_extra_gamma_encoding_collapses_headroom(self):
        peak_nits = 1068.0
        game_nits = 203.0
        psychov_peak = peak_nits / game_nits
        direct = detroit_display_light_scale(psychov_peak, game_nits)
        extra_gamma = detroit_display_light_scale(
            psychov_peak ** (1.0 / 2.2), game_nits
        )
        self.assertLess(extra_gamma, direct * 0.55)

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

    def test_both_versions_keep_user_gamut_and_compression_parameters(self):
        test17 = self.scene[
            self.scene.index("psychotm_test17") : self.scene.index(
                "psychotm_test22"
            )
        ]
        test22 = self.scene[self.scene.index("psychotm_test22") :]
        for call in (test17, test22):
            self.assertIn("RENODX_PSYCHOV_GAMUT_COMPRESSION", call)
            self.assertIn("int(RENODX_PSYCHOV_GAMUT_MODE)", call)
        self.assertIn("RENODX_PSYCHOV22_COMPRESSION", test22)

    def test_both_versions_share_highlight_color_restoration(self):
        helper = self.scene[
            self.scene.index("vec3 RestorePsychoVHighlightColor") :
            self.scene.index("void main()")
        ]
        self.assertIn("renodx::draw::ApplyPerChannelCorrection", helper)
        self.assertRegex(
            helper,
            r"ApplyPerChannelCorrection\(\s*"
            r"scene_linear_bt709\s*,\s*psychov_bt709\s*,\s*"
            r"0\.5\s*,\s*1\.0\s*,\s*1\.0\s*,\s*0\.0\s*\)",
        )
        self.assertIn("renodx::color::bt709::clamp::BT2020", helper)
        self.assertRegex(
            helper,
            r"highlight_signal\s*<=\s*1\.0",
        )

        call = self.scene.index("RestorePsychoVHighlightColor(", self.scene.index("void main()"))
        test22 = self.scene.index("psychotm_test22")
        scale = self.scene.index("renodx_game_scale", test22)
        self.assertLess(test22, call)
        self.assertLess(call, scale)
        self.assertRegex(
            self.scene[test22:scale],
            r"CUSTOM_PSYCHOV17_ACTIVE\s*\|\|\s*CUSTOM_PSYCHOV22_ACTIVE",
        )

    def test_highlight_color_restore_control_is_common_to_both_modes(self):
        setting = re.search(
            r'\.key\s*=\s*"PsychoV17HueRestore"(?P<body>.*?)'
            r'\.key\s*=\s*"PsychoV22Compression"',
            self.addon,
            re.DOTALL,
        )
        self.assertIsNotNone(setting)
        body = setting.group("body")
        self.assertIn('.label = "Highlight Color Restore"', body)
        self.assertIn('.section = "PsychoV"', body)
        self.assertRegex(body, r"tone_map_type\s*>=\s*3\.f")
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
                expected_sum = sum(swatch)
                actual_sum = sum(decoded)
                for expected, actual in zip(swatch, decoded):
                    self.assertAlmostEqual(
                        actual / actual_sum,
                        expected / expected_sum,
                        delta=5.0e-5,
                    )

    def test_extra_gamma_encoding_compresses_cool_tint_channel_ratios(self):
        swatch = (0.05, 1.20, 1.50)
        direct = tuple(detroit_display_light_scale(value, 203.0) for value in swatch)
        extra_gamma = tuple(
            detroit_display_light_scale(value ** (1.0 / 2.2), 203.0)
            for value in swatch
        )
        self.assertGreater(direct[2] / direct[1], extra_gamma[2] / extra_gamma[1])
        self.assertGreater(direct[1] / direct[0], extra_gamma[1] / extra_gamma[0])

    def test_hdr_gamut_boundary_is_the_default(self):
        setting = re.search(
            r'\.key\s*=\s*"PsychoVGamut"(?P<body>.*?)'
            r'\.labels\s*=\s*\{"BT\.709",\s*"BT\.2020"\}',
            self.addon,
            re.DOTALL,
        )
        self.assertIsNotNone(setting)
        self.assertRegex(setting.group("body"), r"\.default_value\s*=\s*1\.f")
        self.assertIn('{"PsychoVGamut", 1.f}', self.addon)


if __name__ == "__main__":
    unittest.main()
