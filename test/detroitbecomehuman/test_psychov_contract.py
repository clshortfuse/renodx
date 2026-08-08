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


def detroit_display_light_scale(value: float, game_nits: float) -> float:
    """Literal model of the common scale after all tone-map branches."""
    return math.pow(
        math.pow(max(value, 0.0), 2.2) * max(game_nits, 0.0) / 300.0,
        1.0 / 2.2,
    )


class PsychoVContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.scene = SCENE_SOURCE.read_text(encoding="utf-8")
        cls.addon = ADDON_SOURCE.read_text(encoding="utf-8")

    def test_both_psychov_modes_feed_the_common_intermediate_directly(self):
        assignments = re.findall(
            r"renodx_tonemapped\s*=\s*max\(\s*"
            r"renodx_psychov_linear\s*,\s*vec3\(0\.0\)\s*\)\s*;",
            self.scene,
        )
        self.assertEqual(len(assignments), 2)

    def test_psychov_is_not_gamma_encoded_before_common_scaling(self):
        self.assertNotRegex(
            self.scene,
            r"pow\(\s*max\(\s*renodx_psychov_linear",
        )

    def test_extra_gamma_encoding_would_collapse_hdr_headroom(self):
        peak_ratio = 1082.0 / 203.0
        correct = detroit_display_light_scale(peak_ratio, 203.0)
        double_encoded = detroit_display_light_scale(
            math.pow(peak_ratio, 1.0 / 2.2),
            203.0,
        )
        self.assertLess(double_encoded, correct * 0.55)

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
