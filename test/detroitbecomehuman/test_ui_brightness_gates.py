#!/usr/bin/env python3
"""Regression tests for Detroit's production UI brightness gates."""

from __future__ import annotations

import argparse
import math
from pathlib import Path
import re
import struct
import sys
import unittest


OUTPUT_MODE_AUTO = 0.0
OUTPUT_MODE_SDR = 1.0
OUTPUT_MODE_HDR10 = 2.0
NATIVE_UI_WHITE_NITS = 300.0
PRE_PQ_GAMMA = 2.2000000476837158203125
INV_PRE_PQ_GAMMA = 0.454545438289642333984375


def _parse_arguments() -> Path:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--source-dir", type=Path, required=True)
    args, remaining = parser.parse_known_args()
    sys.argv = [sys.argv[0], *remaining]
    return args.source_dir.resolve()


SOURCE_DIR = _parse_arguments()


def float32(value: float) -> float:
    return struct.unpack("<f", struct.pack("<f", float(value)))[0]


def float32_bits(value: float) -> bytes:
    return struct.pack("<f", float32(value))


def uses_hdr_output(output_mode: float, output_is_hdr: float) -> bool:
    return output_is_hdr >= 0.5 and output_mode != OUTPUT_MODE_SDR


def should_scale_ui(
    output_mode: float, output_is_hdr: float, graphics_white_nits: float
) -> bool:
    return uses_hdr_output(output_mode, output_is_hdr) and (
        graphics_white_nits != NATIVE_UI_WHITE_NITS
    )


def scale_ui_rgb(rgb: tuple[float, float, float], target_nits: float):
    light_scale = float32(max(float32(target_nits), 0.0) / NATIVE_UI_WHITE_NITS)
    result = []
    for original in rgb:
        channel = float32(original)
        if channel < 0.0:
            result.append(channel)
            continue
        display_light = float32(math.pow(max(channel, 0.0), PRE_PQ_GAMMA))
        scaled_light = float32(display_light * light_scale)
        result.append(
            float32(math.pow(max(scaled_light, 0.0), INV_PRE_PQ_GAMMA))
        )
    return tuple(result)


def shade_ui(
    rgba: tuple[float, float, float, float],
    output_mode: float,
    output_is_hdr: float,
    graphics_white_nits: float,
):
    source = tuple(float32(component) for component in rgba)
    if not should_scale_ui(output_mode, output_is_hdr, graphics_white_nits):
        return source
    return (*scale_ui_rgb(source[:3], graphics_white_nits), source[3])


class UIBrightnessGateTests(unittest.TestCase):
    rgba = (0.125, 0.5, 1.0, 0.375)

    def assert_exact_bypass(
        self, output_mode: float, output_is_hdr: float, target_nits: float
    ) -> None:
        expected = tuple(float32(component) for component in self.rgba)
        actual = shade_ui(self.rgba, output_mode, output_is_hdr, target_nits)
        self.assertEqual(
            tuple(float32_bits(component) for component in actual),
            tuple(float32_bits(component) for component in expected),
        )

    def test_hdr10_mode_cannot_force_ui_math_on_an_sdr_swapchain(self):
        self.assertFalse(uses_hdr_output(OUTPUT_MODE_HDR10, 0.0))
        self.assert_exact_bypass(OUTPUT_MODE_HDR10, 0.0, 203.0)

    def test_sdr_mode_bypasses_ui_math_on_an_hdr_swapchain(self):
        self.assertFalse(uses_hdr_output(OUTPUT_MODE_SDR, 1.0))
        self.assert_exact_bypass(OUTPUT_MODE_SDR, 1.0, 203.0)

    def test_auto_follows_the_measured_swapchain(self):
        self.assert_exact_bypass(OUTPUT_MODE_AUTO, 0.0, 203.0)
        self.assertNotEqual(
            shade_ui(self.rgba, OUTPUT_MODE_AUTO, 1.0, 203.0),
            tuple(float32(component) for component in self.rgba),
        )

    def test_native_reference_value_is_an_exact_hdr_bypass(self):
        for output_mode in (OUTPUT_MODE_AUTO, OUTPUT_MODE_HDR10):
            with self.subTest(output_mode=output_mode):
                self.assert_exact_bypass(output_mode, 1.0, 300.0)

    def test_requested_white_maps_in_display_light(self):
        for target_nits in (80.0, 203.0, 600.0, 1000.0):
            with self.subTest(target_nits=target_nits):
                code = scale_ui_rgb((1.0, 1.0, 1.0), target_nits)[0]
                reconstructed = float32(
                    math.pow(max(code, 0.0), PRE_PQ_GAMMA)
                    * NATIVE_UI_WHITE_NITS
                )
                self.assertAlmostEqual(
                    reconstructed,
                    target_nits,
                    delta=max(0.001, target_nits * 2e-6),
                )

    def test_alpha_is_float32_bit_invariant(self):
        for alpha in (0.0, 0.125, 0.5, 1.0):
            with self.subTest(alpha=alpha):
                rgba = (*self.rgba[:3], alpha)
                actual = shade_ui(rgba, OUTPUT_MODE_AUTO, 1.0, 203.0)
                self.assertEqual(float32_bits(actual[3]), float32_bits(alpha))

    def test_negative_rgb_components_are_preserved(self):
        rgba = (-0.25, 0.5, 1.0, 0.75)
        actual = shade_ui(rgba, OUTPUT_MODE_AUTO, 1.0, 203.0)
        self.assertEqual(float32_bits(actual[0]), float32_bits(rgba[0]))

    def test_ui_slider_visibility_requires_a_confirmed_ui_path(self):
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")
        for shader_crc in ("0x2892BFCA", "0x8808E4CC", "0x9827B559"):
            with self.subTest(shader_crc=shader_crc):
                entry_start = addon.index(f"{{{shader_crc}, {{")
                entry_end = addon.index("}},", entry_start)
                registration = addon[entry_start:entry_end]
                self.assertIn(f".crc32 = {shader_crc}", registration)
                self.assertIn(f".code = __{shader_crc}", registration)
                self.assertIn(".on_drawn = &OnUiDrawn", registration)

        self.assertRegex(
            addon,
            r'\{"ToneMapUINits",[\s\S]*?\.is_visible\s*=\s*\[\]\(\)\s*\{\s*'
            r"return\s+shader_injection\.ui_path_active\s*!=\s*0\.f\s*;",
        )
        self.assertIn(".on_drawn = &OnUiDrawn", addon)
        self.assertRegex(
            addon,
            r"shader_injection\.ui_path_active\s*=\s*"
            r"ui_path_seen\.load\([\s\S]*?\?\s*1\.f\s*:\s*0\.f\s*;",
        )

    def test_production_ui_shaders_keep_the_same_gate_contract(self):
        helper = (SOURCE_DIR / "ui_brightness.slang").read_text(encoding="utf-8")
        compact_helper = re.sub(r"\s+", " ", helper)
        self.assertIn(
            "const float DETROIT_NATIVE_UI_WHITE_NITS = 300.0;",
            compact_helper,
        )
        self.assertIn(
            "return CUSTOM_OUTPUT_IS_HDR >= 0.5 && CUSTOM_OUTPUT_MODE != 1.0;",
            compact_helper,
        )
        self.assertIn(
            "return DetroitUsesHdrOutput() && "
            "(RENODX_GRAPHICS_WHITE_NITS != DETROIT_NATIVE_UI_WHITE_NITS);",
            compact_helper,
        )

        wrappers = (
            "ui_solid_0x2892BFCA.frag.slang",
            "ui_alpha_mask_0x8808E4CC.frag.slang",
            "ui_textured_0x9827B559.frag.slang",
        )
        for wrapper in wrappers:
            with self.subTest(wrapper=wrapper):
                source = (SOURCE_DIR / wrapper).read_text(encoding="utf-8")
                self.assertEqual(source.count("if (DetroitShouldScaleUi())"), 1)
                self.assertEqual(
                    source.count("fcolor.xyz = DetroitScaleUiRgb(fcolor.xyz);"), 1
                )
                scaled_block = re.search(
                    r"if\s*\(DetroitShouldScaleUi\(\)\)\s*\{(?P<body>[\s\S]*?)\}",
                    source,
                )
                self.assertIsNotNone(scaled_block)
                self.assertNotRegex(scaled_block.group("body"), r"fcolor\.(w|a)\s*=")


if __name__ == "__main__":
    unittest.main(verbosity=2)
