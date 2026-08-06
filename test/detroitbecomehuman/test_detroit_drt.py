#!/usr/bin/env python3
"""Independent numerical and source-contract tests for Detroit DRT."""

from __future__ import annotations

import argparse
import math
from pathlib import Path
import sys
import unittest


BT709_LUMINANCE = (0.2126, 0.7152, 0.0722)
MAX_FINITE_INPUT = 65504.0


def _parse_arguments() -> Path:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--source-dir", type=Path)
    args, remaining = parser.parse_known_args()
    sys.argv = [sys.argv[0], *remaining]
    if args.source_dir is not None:
        return args.source_dir.resolve()
    return (
        Path(__file__).resolve().parents[2]
        / "src"
        / "games"
        / "detroitbecomehuman"
    )


SOURCE_DIR = _parse_arguments()


def clamp(value: float, lower: float, upper: float) -> float:
    return min(max(value, lower), upper)


def map_luminance(scene_luminance: float, peak_ratio: float) -> float:
    """CPU mirror of DetroitDrtMapLuminance in the shader helper."""
    input_luminance = clamp(scene_luminance, 0.0, MAX_FINITE_INPUT)
    output_peak = clamp(peak_ratio, 1.0, MAX_FINITE_INPUT)
    if input_luminance <= 1.0:
        return input_luminance
    if output_peak <= 1.0:
        return 1.0
    headroom = output_peak - 1.0
    highlight_distance = input_luminance - 1.0
    return 1.0 + headroom * (
        1.0 - math.exp(-highlight_distance / headroom)
    )


def detroit_drt(
    scene_linear_bt709: tuple[float, float, float],
    peak_ratio: float,
    highlight_desaturation: float = 0.0,
) -> tuple[float, float, float]:
    """CPU mirror of the linear BT.709 shader operator."""
    nonlinear_input = tuple(
        clamp(channel, 0.0, MAX_FINITE_INPUT)
        for channel in scene_linear_bt709
    )
    input_luminance = sum(
        channel * weight
        for channel, weight in zip(nonlinear_input, BT709_LUMINANCE)
    )
    if input_luminance <= 0.0:
        return (0.0, 0.0, 0.0)

    output_peak = clamp(peak_ratio, 1.0, MAX_FINITE_INPUT)
    mapped_luminance = map_luminance(input_luminance, output_peak)
    scale = mapped_luminance / input_luminance
    mapped_rgb = tuple(channel * scale for channel in nonlinear_input)

    highlight_position = 0.0
    if output_peak > 1.0:
        highlight_position = clamp(
            (mapped_luminance - 1.0) / (output_peak - 1.0),
            0.0,
            1.0,
        )
    smooth_highlight = (
        highlight_position
        * highlight_position
        * (3.0 - 2.0 * highlight_position)
    )
    amount = clamp(highlight_desaturation, 0.0, 1.0) * smooth_highlight
    return tuple(
        mapped + (mapped_luminance - mapped) * amount
        for mapped in mapped_rgb
    )


class DetroitDrtTests(unittest.TestCase):
    def test_exact_neutral_anchors(self):
        peak_ratio = 1000.0 / 203.0
        for anchor in (0.0, 0.18, 1.0):
            with self.subTest(anchor=anchor):
                self.assertEqual(map_luminance(anchor, peak_ratio), anchor)
                self.assertEqual(
                    detroit_drt((anchor, anchor, anchor), peak_ratio),
                    (anchor, anchor, anchor),
                )

    def test_neutral_ramp_is_monotonic_and_peak_bounded(self):
        samples = (
            0.0,
            0.001,
            0.01,
            0.18,
            0.5,
            1.0,
            2.0,
            4.0,
            8.0,
            16.0,
            64.0,
            256.0,
            4096.0,
            MAX_FINITE_INPUT,
        )
        for peak_nits in (600.0, 1000.0, 4000.0):
            peak_ratio = peak_nits / 203.0
            with self.subTest(peak_nits=peak_nits):
                outputs = [map_luminance(value, peak_ratio) for value in samples]
                self.assertTrue(
                    all(left <= right for left, right in zip(outputs, outputs[1:]))
                )
                self.assertTrue(all(0.0 <= value <= peak_ratio for value in outputs))

    def test_peak_selection_changes_only_highlights(self):
        peak_ratios = tuple(peak / 203.0 for peak in (600.0, 1000.0, 4000.0))
        for diffuse in (0.18, 1.0):
            self.assertEqual(
                [map_luminance(diffuse, peak) for peak in peak_ratios],
                [diffuse, diffuse, diffuse],
            )
        highlight_outputs = [map_luminance(8.0, peak) for peak in peak_ratios]
        self.assertTrue(
            all(
                lower < higher
                for lower, higher in zip(
                    highlight_outputs, highlight_outputs[1:]
                )
            )
        )

    def test_zero_desaturation_preserves_positive_color_ratios(self):
        samples = (
            (8.0, 4.0, 2.0),
            (16.0, 1.0, 0.25),
            (2.0, 6.0, 3.0),
            (0.25, 8.0, 1.5),
        )
        for peak_nits in (600.0, 1000.0, 4000.0):
            peak_ratio = peak_nits / 203.0
            for sample in samples:
                with self.subTest(peak_nits=peak_nits, sample=sample):
                    output = detroit_drt(sample, peak_ratio, 0.0)
                    scales = tuple(
                        mapped / original
                        for mapped, original in zip(output, sample)
                    )
                    self.assertAlmostEqual(scales[0], scales[1], places=12)
                    self.assertAlmostEqual(scales[1], scales[2], places=12)

    def test_highlight_desaturation_preserves_luminance(self):
        sample = (16.0, 2.0, 0.5)
        peak_ratio = 1000.0 / 203.0
        neutral = detroit_drt(sample, peak_ratio, 0.0)
        desaturated = detroit_drt(sample, peak_ratio, 1.0)
        neutral_y = sum(
            channel * weight
            for channel, weight in zip(neutral, BT709_LUMINANCE)
        )
        desaturated_y = sum(
            channel * weight
            for channel, weight in zip(desaturated, BT709_LUMINANCE)
        )
        self.assertAlmostEqual(neutral_y, desaturated_y, places=12)
        self.assertLess(
            max(desaturated) - min(desaturated),
            max(neutral) - min(neutral),
        )

    def test_full_finite_domain_and_mixed_negatives_are_safe(self):
        samples = (
            (-MAX_FINITE_INPUT, -1.0, -0.001),
            (-10.0, 4.0, 1.0),
            (MAX_FINITE_INPUT, MAX_FINITE_INPUT, MAX_FINITE_INPUT),
            (MAX_FINITE_INPUT, 0.0, 1.0),
            (0.0, MAX_FINITE_INPUT, 0.0),
            (0.0, 0.0, MAX_FINITE_INPUT),
        )
        for peak_nits in (203.0, 600.0, 1000.0, 4000.0):
            peak_ratio = peak_nits / 203.0
            for desaturation in (-2.0, 0.0, 0.35, 1.0, 2.0):
                for sample in samples:
                    with self.subTest(
                        peak_nits=peak_nits,
                        desaturation=desaturation,
                        sample=sample,
                    ):
                        output = detroit_drt(
                            sample, peak_ratio, desaturation
                        )
                        self.assertTrue(all(math.isfinite(value) for value in output))
                        self.assertTrue(all(value >= 0.0 for value in output))

    def test_shader_source_has_a_linear_math_only_contract(self):
        shader_path = SOURCE_DIR / "detroit_drt.slang"
        source = shader_path.read_text(encoding="utf-8")
        lower = source.lower()

        self.assertIn("vec3 DetroitDrt(", source)
        self.assertIn("DetroitDrtMapLuminance", source)
        self.assertIn("0.2126, 0.7152, 0.0722", source)
        self.assertIn("peak_ratio", source)
        self.assertIn("mapped_luminance / input_luminance", source)
        self.assertIn("exp(-highlight_distance / headroom)", source)

        for forbidden in (
            "inverse",
            "oetf",
            "pq",
            "st2084",
            "texture",
            "sampler",
            "binding",
            "push_constant",
        ):
            with self.subTest(forbidden=forbidden):
                self.assertNotIn(forbidden, lower)


if __name__ == "__main__":
    unittest.main(verbosity=2)
