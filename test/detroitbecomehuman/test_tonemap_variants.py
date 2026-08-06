#!/usr/bin/env python3
"""Numerical and source-contract tests for Detroit tone-map variants."""

from __future__ import annotations

import argparse
import math
from pathlib import Path
import re
import sys
import unittest


TONE_MAP_TYPES = {
    "VANILLA": 0.0,
    "REINHARD": 1.0,
    "RENO_DRT": 2.0,
    "AGX": 3.0,
    "ACES_FITTED": 4.0,
    "LOTTES": 5.0,
    "HABLE": 6.0,
    "KHRONOS_PBR": 7.0,
    "PSYCHOV_22": 8.0,
    "DETROIT_DRT": 9.0,
}


def _parse_arguments() -> Path:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--source-dir", type=Path, required=True)
    args, remaining = parser.parse_known_args()
    sys.argv = [sys.argv[0], *remaining]
    return args.source_dir.resolve()


SOURCE_DIR = _parse_arguments()


def clamp(value: float, low: float, high: float) -> float:
    return min(max(value, low), high)


def pq_encode(normalized_10000_nits: float) -> float:
    m1 = 0.1593017578125
    m2 = 78.84375
    c1 = 0.8359375
    c2 = 18.8515625
    c3 = 18.6875
    powered = max(normalized_10000_nits, 0.0) ** m1
    return ((c1 + c2 * powered) / (1.0 + c3 * powered)) ** m2


def production_scene_to_pq(linear_relative_to_game_white: float) -> float:
    game_nits = 203.0
    gamma_intermediate = max(linear_relative_to_game_white, 0.0) ** (1.0 / 2.2)
    scene_adapter = (
        gamma_intermediate**2.2 * (game_nits / 300.0)
    ) ** (1.0 / 2.2)
    final_linear_300_nits = scene_adapter**2.2
    return pq_encode(final_linear_300_nits * 0.03)


def agx_curve(value: float) -> float:
    min_ev = -12.4739303589
    max_ev = 4.0260691643
    log_value = clamp(math.log2(max(value, 2.0**min_ev)), min_ev, max_ev)
    x = (log_value - min_ev) / (max_ev - min_ev)
    x2 = x * x
    x4 = x2 * x2
    sigmoid = (
        15.5 * x4 * x2
        - 40.14 * x4 * x
        + 31.96 * x4
        - 6.868 * x2 * x
        + 0.4298 * x2
        + 0.1191 * x
        - 0.00232
    )
    return clamp(sigmoid, 0.0, 1.0) ** 2.2


def aces_fitted_curve(value: float) -> float:
    numerator = value * (value + 0.0245786) - 0.000090537
    denominator = value * (0.983729 * value + 0.432951) + 0.238081
    return clamp(numerator / denominator, 0.0, 1.0)


def lottes_curve(value: float) -> float:
    a = 1.6
    d = 0.977
    hdr_max = 8.0
    mid_in = 0.18
    mid_out = 0.267
    b = (-mid_in**a + hdr_max**a * mid_out) / (
        (hdr_max ** (a * d) - mid_in ** (a * d)) * mid_out
    )
    c = (
        hdr_max ** (a * d) * mid_in**a
        - hdr_max**a * mid_in ** (a * d) * mid_out
    ) / ((hdr_max ** (a * d) - mid_in ** (a * d)) * mid_out)
    value = max(value, 0.0)
    return clamp(value**a / (value ** (a * d) * b + c), 0.0, 1.0)


def hable_curve(value: float) -> float:
    a, b, c, d, e, f = 0.22, 0.30, 0.10, 0.20, 0.01, 0.30

    def raw(x: float) -> float:
        return ((x * (a * x + c * b) + d * e) / (
            x * (a * x + b) + d * f
        )) - e / f

    return clamp(raw(max(value, 0.0)) / raw(11.2), 0.0, 1.0)


def pbr_neutral_curve(value: float) -> float:
    value = max(value, 0.0)
    offset = value - 6.25 * value * value if value < 0.08 else 0.04
    color = max(value - offset, 0.0)
    peak = color
    start_compression = 0.76
    if peak >= start_compression:
        compression_size = 1.0 - start_compression
        new_peak = 1.0 - compression_size**2 / (
            peak + compression_size - start_compression
        )
        color *= new_peak / max(peak, 1.0e-6)
        weight = 1.0 - 1.0 / (0.15 * (peak - new_peak) + 1.0)
        color = color + (new_peak - color) * weight
    return clamp(color, 0.0, 1.0)


CURVES = {
    "AGX": (agx_curve, 0.2145190966, 0.5901592450, 1.6944754916),
    "ACES_FITTED": (
        aces_fitted_curve,
        0.1055912472,
        0.6191154269,
        0.9695158459,
    ),
    "LOTTES": (lottes_curve, 0.2670000000, 0.8061527838, 1.5518191997),
    "HABLE": (hable_curve, 0.0998567837, 0.4625261018, 1.1186147858),
    "KHRONOS_PBR": (
        pbr_neutral_curve,
        0.1400000000,
        0.8690909091,
        0.9392011394,
    ),
}


def adapt_bounded_curve(
    curve_value: float,
    curve_white: float,
    toe_power: float,
    peak_ratio: float,
) -> float:
    curve_value = clamp(curve_value, 0.0, 1.0)
    peak_ratio = max(peak_ratio, 1.0)
    white = clamp(curve_white, 1.0e-4, 0.9999)
    toe = clamp(curve_value / white, 0.0, 1.0) ** toe_power
    if peak_ratio <= 1.0001:
        return toe
    coordinate = clamp((curve_value - white) / (1.0 - white), 0.0, 1.0)
    slope = clamp(
        (toe_power / white) * (1.0 - white) / (peak_ratio - 1.0),
        0.0,
        3.0,
    )
    shoulder = (
        coordinate * coordinate * (3.0 - 2.0 * coordinate)
        + slope * coordinate * (1.0 - coordinate) ** 2
    )
    highlight = 1.0 + (peak_ratio - 1.0) * shoulder
    return toe if curve_value < white else highlight


def psychov22_neutral(value: float, peak_ratio: float) -> float:
    """Neutral-axis reduction of the shared PsychoV-22 curve at defaults."""
    anchor = 0.18
    peak_ratio = max(peak_ratio, anchor + 1.0e-6)
    slope_norm = 1.0 - anchor / peak_ratio
    exponent = 1.0 / max(slope_norm, 1.0e-6)
    q = (max(value, 1.0e-6) / anchor) ** exponent
    shoulder = peak_ratio / anchor - 1.0
    return peak_ratio * q / (q + shoulder)


class ToneMapVariantTests(unittest.TestCase):
    def test_persisted_ids_and_labels_are_append_only(self):
        shared = (SOURCE_DIR / "shared.h").read_text(encoding="utf-8")
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")
        for name, value in TONE_MAP_TYPES.items():
            self.assertRegex(
                shared,
                rf"#define\s+DETROIT_TONE_MAP_TYPE_{name}\s+{int(value)}\.f",
            )

        labels = (
            "Vanilla",
            "Reinhard",
            "RenoDRT",
            "AgX (HDR Adapted)",
            "ACES Fitted (HDR Adapted)",
            "Lottes (HDR Adapted)",
            "Hable / Uncharted 2 (HDR Adapted)",
            "Khronos PBR Neutral (HDR Adapted)",
            "PsychoV-22 (Cyberpunk 2077)",
            "Detroit DRT",
        )
        positions = [addon.index(f'"{label}"') for label in labels]
        self.assertEqual(positions, sorted(positions))
        self.assertIn(
            ".default_value = DETROIT_TONE_MAP_TYPE_RENO_DRT", addon
        )
        self.assertIn(
            '{"ToneMapType", DETROIT_TONE_MAP_TYPE_VANILLA}', addon
        )

    def test_selector_parser_rejects_nan_and_out_of_range_values(self):
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")
        self.assertIn("std::isfinite(value)", addon)
        self.assertIn("std::round(value)", addon)
        self.assertIn("rounded > DETROIT_TONE_MAP_TYPE_MAX", addon)
        self.assertGreaterEqual(
            addon.count("return DETROIT_TONE_MAP_TYPE_RENO_DRT"), 2
        )

    def test_bounded_curve_reference_constants_match_formulas(self):
        for name, (curve, expected_mid, expected_white, toe_power) in CURVES.items():
            with self.subTest(name=name):
                actual_mid = curve(0.18)
                actual_white = curve(1.0)
                self.assertAlmostEqual(actual_mid, expected_mid, places=8)
                self.assertAlmostEqual(actual_white, expected_white, places=8)
                expected_power = math.log(0.18) / math.log(
                    actual_mid / actual_white
                )
                self.assertAlmostEqual(toe_power, expected_power, places=8)

    def test_hdr_adapters_preserve_black_mid_gray_and_diffuse_white(self):
        for peak_nits in (600.0, 1000.0, 4000.0):
            peak_ratio = peak_nits / 203.0
            for name, (curve, _, white, toe_power) in CURVES.items():
                with self.subTest(peak_nits=peak_nits, name=name):
                    black = adapt_bounded_curve(curve(0.0), white, toe_power, peak_ratio)
                    mid = adapt_bounded_curve(curve(0.18), white, toe_power, peak_ratio)
                    diffuse = adapt_bounded_curve(curve(1.0), white, toe_power, peak_ratio)
                    self.assertAlmostEqual(black, 0.0, places=8)
                    self.assertAlmostEqual(mid, 0.18, places=7)
                    self.assertAlmostEqual(diffuse, 1.0, places=7)

    def test_hdr_adapters_are_finite_monotonic_and_peak_aware(self):
        ramp = [0.0, *(2.0**step for step in range(-16, 9))]
        for name, (curve, _, white, toe_power) in CURVES.items():
            highlight_by_peak = []
            for peak_nits in (600.0, 1000.0, 4000.0):
                peak_ratio = peak_nits / 203.0
                output = [
                    adapt_bounded_curve(curve(value), white, toe_power, peak_ratio)
                    for value in ramp
                ]
                with self.subTest(name=name, peak_nits=peak_nits):
                    self.assertTrue(all(math.isfinite(value) for value in output))
                    self.assertTrue(all(0.0 <= value <= peak_ratio + 1.0e-7 for value in output))
                    self.assertTrue(
                        all(left <= right + 2.0e-7 for left, right in zip(output, output[1:]))
                    )
                highlight_by_peak.append(
                    adapt_bounded_curve(curve(4.0), white, toe_power, peak_ratio)
                )
            self.assertTrue(
                all(
                    lower < higher
                    for lower, higher in zip(highlight_by_peak, highlight_by_peak[1:])
                ),
                name,
            )

    def test_psychov22_uses_the_shared_peak_aware_operator(self):
        source = (SOURCE_DIR / "tone_mappers.slang").read_text(encoding="utf-8")
        self.assertIn("psychotm_test22(", source)
        self.assertIn("DETROIT_TONE_MAP_TYPE_PSYCHOV_22", source)
        self.assertNotIn("CDPRAcesLookCurve", source)

        for peak_nits in (600.0, 1000.0, 4000.0):
            peak_ratio = peak_nits / 203.0
            self.assertAlmostEqual(psychov22_neutral(0.18, peak_ratio), 0.18, places=7)
            values = [psychov22_neutral(2.0**step, peak_ratio) for step in range(-12, 9)]
            self.assertTrue(all(left < right for left, right in zip(values, values[1:])))
            self.assertTrue(all(0.0 <= value < peak_ratio for value in values))

    def test_khronos_operator_preserves_apache_attribution(self):
        operators = (SOURCE_DIR / "tone_mappers.slang").read_text(
            encoding="utf-8"
        )
        khronos = (SOURCE_DIR / "khronos_pbr_neutral.slang").read_text(
            encoding="utf-8"
        )
        notices = (SOURCE_DIR / "THIRD_PARTY_NOTICES.txt").read_text(
            encoding="utf-8"
        )
        self.assertIn('#include "khronos_pbr_neutral.slang"', operators)
        self.assertIn("SPDX-License-Identifier: Apache-2.0", khronos)
        self.assertIn("Copyright 2024 The Khronos Group, Inc.", khronos)
        self.assertIn("Modified for the Detroit RenoDX add-on", khronos)
        self.assertIn("Apache License, Version 2.0", notices)

    def test_extended_scene_adapter_hits_native_pq_reference_points(self):
        diffuse_pq = production_scene_to_pq(1.0)
        peak_pq = production_scene_to_pq(1000.0 / 203.0)
        self.assertAlmostEqual(diffuse_pq, 0.580688881, places=8)
        self.assertEqual(round(diffuse_pq * 1023.0), 594)
        self.assertAlmostEqual(peak_pq, 0.751827096, places=8)
        self.assertEqual(round(peak_pq * 1023.0), 769)

    def test_scene_dispatch_keeps_one_native_pq_path(self):
        scene = (SOURCE_DIR / "scene_0xEBFBDDB1.comp.slang").read_text(
            encoding="utf-8"
        )
        operators = (SOURCE_DIR / "tone_mappers.slang").read_text(
            encoding="utf-8"
        )
        self.assertIn("CUSTOM_TONE_MAP_IS_EXTENDED", scene)
        ordered_tokens = (
            "ComputeUntonemappedGraded(",
            "UserColorGrading(",
            "detroit::tone_map::Apply(",
            "vec3(1.0 / 2.2)",
        )
        positions = [scene.index(token) for token in ordered_tokens]
        self.assertEqual(positions, sorted(positions))

        self.assertNotRegex(operators, r"renodx::color::pq|ST2084|EncodePQ")
        self.assertNotRegex(operators, r"Texture[123]D|SamplerState|binding\s*\(")
        self.assertIn("peak_nits", operators)
        self.assertIn("game_nits", operators)


if __name__ == "__main__":
    unittest.main(verbosity=2)
