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
RUNTIME_FLAG_PSYCHOV_BT2020 = 1 << 1
FORMAT_RGBA8 = "r8g8b8a8_unorm"
FORMAT_RGBA16F = "r16g16b16a16_float"
BT709_TO_BT2020 = (
    (0.6273999810, 0.3292999864, 0.0432999991),
    (0.0690999999, 0.9194999933, 0.0114000002),
    (0.0164000001, 0.0879999995, 0.8956000209),
)


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


def psychov_bt2020_active(runtime_flags: int) -> bool:
    return (runtime_flags & RUNTIME_FLAG_PSYCHOV_BT2020) != 0


def should_replace_shared_hdr_ui(
    target_format: str,
    target_width: int,
    target_height: int,
    output_width: int,
    output_height: int,
) -> bool:
    return (
        target_format == FORMAT_RGBA16F
        and (output_width == 0 or target_width == output_width)
        and (output_height == 0 or target_height == output_height)
    )


def should_transform_ui(
    output_mode: float,
    output_is_hdr: float,
    graphics_white_nits: float,
    runtime_flags: int,
) -> bool:
    return should_scale_ui(
        output_mode, output_is_hdr, graphics_white_nits
    ) or psychov_bt2020_active(runtime_flags)


def bt709_to_bt2020(
    rgb: tuple[float, float, float]
) -> tuple[float, float, float]:
    return tuple(
        float32(sum(row[index] * rgb[index] for index in range(3)))
        for row in BT709_TO_BT2020
    )


def scale_ui_rgb(
    rgb: tuple[float, float, float],
    target_nits: float,
    wide_gamut: bool = False,
):
    light_scale = float32(max(float32(target_nits), 0.0) / NATIVE_UI_WHITE_NITS)
    source = tuple(float32(channel) for channel in rgb)
    display_light = tuple(
        float32(
            math.pow(max(channel, 0.0), PRE_PQ_GAMMA) * light_scale
        )
        for channel in source
    )
    if wide_gamut:
        display_light = bt709_to_bt2020(display_light)
    scaled = tuple(
        float32(math.pow(max(channel, 0.0), INV_PRE_PQ_GAMMA))
        for channel in display_light
    )
    return scaled


def shade_ui(
    rgba: tuple[float, float, float, float],
    output_mode: float,
    output_is_hdr: float,
    graphics_white_nits: float,
    runtime_flags: int = 0,
):
    source = tuple(float32(component) for component in rgba)
    if not should_transform_ui(
        output_mode,
        output_is_hdr,
        graphics_white_nits,
        runtime_flags,
    ):
        return source
    return (
        *scale_ui_rgb(
            source[:3],
            graphics_white_nits,
            psychov_bt2020_active(runtime_flags),
        ),
        source[3],
    )


def shade_premultiplied_ui(
    rgba: tuple[float, float, float, float],
    output_mode: float,
    output_is_hdr: float,
    graphics_white_nits: float,
    runtime_flags: int = 0,
):
    source = tuple(float32(component) for component in rgba)
    if not should_transform_ui(
        output_mode,
        output_is_hdr,
        graphics_white_nits,
        runtime_flags,
    ):
        return source

    alpha = source[3]
    straight_rgb = (
        tuple(float32(channel / alpha) for channel in source[:3])
        if alpha > 1.0e-6
        else (0.0, 0.0, 0.0)
    )
    scaled = scale_ui_rgb(
        straight_rgb,
        graphics_white_nits,
        psychov_bt2020_active(runtime_flags),
    )
    return (
        *(float32(channel * alpha) for channel in scaled),
        alpha,
    )


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

    def test_psychov_bt2020_transforms_ui_at_native_reference_white(self):
        transformed = shade_ui(
            self.rgba,
            OUTPUT_MODE_HDR10,
            1.0,
            300.0,
            RUNTIME_FLAG_PSYCHOV_BT2020,
        )
        self.assertNotEqual(
            tuple(float32_bits(channel) for channel in transformed[:3]),
            tuple(float32_bits(channel) for channel in self.rgba[:3]),
        )
        source_light = tuple(
            float32(math.pow(channel, PRE_PQ_GAMMA))
            for channel in self.rgba[:3]
        )
        expected_bt2020 = bt709_to_bt2020(source_light)
        decoded = tuple(
            float32(math.pow(max(channel, 0.0), PRE_PQ_GAMMA))
            for channel in transformed[:3]
        )
        for actual, expected in zip(decoded, expected_bt2020):
            self.assertAlmostEqual(actual, expected, delta=2.0e-6)

    def test_bt2020_transform_requires_the_actual_frame_runtime_bit(self):
        self.assert_exact_bypass(OUTPUT_MODE_HDR10, 1.0, 300.0)
        for runtime_flags in (0, 1):
            with self.subTest(runtime_flags=runtime_flags):
                actual = shade_ui(
                    self.rgba,
                    OUTPUT_MODE_HDR10,
                    1.0,
                    300.0,
                    runtime_flags,
                )
                self.assertEqual(
                    tuple(float32_bits(channel) for channel in actual),
                    tuple(float32_bits(channel) for channel in self.rgba),
                )
        self.assertTrue(psychov_bt2020_active(2))
        self.assertTrue(psychov_bt2020_active(3))

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

    def test_premultiplied_compositor_preserves_alpha_and_matches_transform(self):
        straight_rgb = (0.125, 0.5, 0.875)
        for runtime_flags in (0, RUNTIME_FLAG_PSYCHOV_BT2020):
            for alpha in (0.0, 0.125, 0.5, 1.0):
                with self.subTest(
                    runtime_flags=runtime_flags, alpha=alpha
                ):
                    premultiplied = (
                        *(float32(channel * alpha) for channel in straight_rgb),
                        float32(alpha),
                    )
                    actual = shade_premultiplied_ui(
                        premultiplied,
                        OUTPUT_MODE_AUTO,
                        1.0,
                        203.0,
                        runtime_flags,
                    )
                    self.assertEqual(
                        float32_bits(actual[3]), float32_bits(alpha)
                    )
                    if alpha <= 1.0e-6:
                        self.assertEqual(actual[:3], (0.0, 0.0, 0.0))
                        continue

                    expected_straight = scale_ui_rgb(
                        straight_rgb,
                        203.0,
                        psychov_bt2020_active(runtime_flags),
                    )
                    actual_straight = tuple(
                        float32(channel / alpha) for channel in actual[:3]
                    )
                    for transformed, expected in zip(
                        actual_straight, expected_straight
                    ):
                        self.assertAlmostEqual(
                            transformed, expected, delta=2.0e-6
                        )

    def test_transformed_negative_rgb_components_are_sanitized(self):
        rgba = (-0.25, 0.5, 1.0, 0.75)
        for runtime_flags in (0, RUNTIME_FLAG_PSYCHOV_BT2020):
            with self.subTest(runtime_flags=runtime_flags):
                actual = shade_ui(
                    rgba,
                    OUTPUT_MODE_AUTO,
                    1.0,
                    203.0,
                    runtime_flags,
                )
                self.assertTrue(all(math.isfinite(channel) for channel in actual))
                self.assertTrue(all(channel >= 0.0 for channel in actual[:3]))

    def test_target_gate_replaces_only_the_full_size_rgba16f_writer(self):
        output_size = (3440, 1440)
        self.assertTrue(
            should_replace_shared_hdr_ui(
                FORMAT_RGBA16F, *output_size, *output_size
            )
        )
        self.assertFalse(
            should_replace_shared_hdr_ui(
                FORMAT_RGBA8, *output_size, *output_size
            )
        )
        self.assertFalse(
            should_replace_shared_hdr_ui(
                FORMAT_RGBA16F, 1720, 720, *output_size
            )
        )

    def test_all_ui_writers_use_the_target_aware_replace_callback(self):
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")
        shader_crcs = (
            "0x2892BFCA",
            "0x8808E4CC",
            "0x9827B559",
            "0x11C1C2C5",
            "0x97874322",
            "0xC5B9F7FA",
            "0xEF606BCD",
        )
        for shader_crc in shader_crcs:
            with self.subTest(shader_crc=shader_crc):
                entry_start = addon.index(f"{{{shader_crc}, {{")
                entry_end = addon.index("}},", entry_start)
                registration = addon[entry_start:entry_end]
                self.assertIn(f".crc32 = {shader_crc}", registration)
                self.assertIn(f".code = __{shader_crc}", registration)
                self.assertIn(
                    ".on_replace = &OnSharedHdrUiReplace", registration
                )
                self.assertNotIn(".on_drawn", registration)

        gate_start = addon.index("bool IsSharedHdrIntermediateTarget(")
        gate_end = addon.index("bool OnSharedHdrUiReplace(", gate_start)
        target_gate = addon[gate_start:gate_end]
        self.assertIn(
            "reshade::api::format::r16g16b16a16_float", target_gate
        )
        self.assertRegex(
            target_gate,
            r"description\.texture\.width\s*==\s*expected_width",
        )
        self.assertRegex(
            target_gate,
            r"description\.texture\.height\s*==\s*expected_height",
        )
        callback_start = gate_end
        callback_end = addon.index("std::string_view", callback_start)
        callback = addon[callback_start:callback_end]
        self.assertIn(
            "const bool replace = IsSharedHdrIntermediateTarget(command_list);",
            callback,
        )
        self.assertIn(
            "if (replace) ui_path_seen.store(true, std::memory_order_relaxed);",
            callback,
        )
        self.assertIn("RGBA8 offscreen textures", callback)

    def test_ui_slider_visibility_requires_a_confirmed_ui_path(self):
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")
        self.assertRegex(
            addon,
            r'\{"ToneMapUINits",[\s\S]*?\.is_visible\s*=\s*\[\]\(\)\s*\{\s*'
            r"return\s+shader_injection\.ui_path_active\s*!=\s*0\.f\s*;",
        )
        self.assertNotIn("OnUiDrawn", addon)
        replace_start = addon.index("bool OnSharedHdrUiReplace(")
        replace_end = addon.index("std::string_view", replace_start)
        replace_callback = addon[replace_start:replace_end]
        self.assertIn(
            "ui_path_seen.store(true, std::memory_order_relaxed);",
            replace_callback,
        )
        self.assertRegex(
            addon,
            r"shader_injection\.ui_path_active\s*=\s*"
            r"ui_path_seen\.load\([\s\S]*?\?\s*1\.f\s*:\s*0\.f\s*;",
        )

    def test_production_ui_shaders_keep_the_same_gate_contract(self):
        helper = (SOURCE_DIR / "hdr" / "ui_brightness.slang").read_text(encoding="utf-8")
        shared = (SOURCE_DIR / "shared.h").read_text(encoding="utf-8")
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")
        compact_helper = re.sub(r"\s+", " ", helper)
        continued_shared = re.sub(r"\\\r?\n\s*", " ", shared)
        compact_shared = re.sub(r"[ \t]+", " ", continued_shared)
        wide_macro = re.search(
            r"#define CUSTOM_PSYCHOV_BT2020_ACTIVE(?P<body>[^\r\n]+)",
            compact_shared,
        )
        self.assertIsNotNone(wide_macro)
        self.assertRegex(
            wide_macro.group("body"),
            r"\(\(CUSTOM_RUNTIME_FLAGS\s*&\s*0x2u\)\s*!=\s*0u\)",
        )
        self.assertNotRegex(
            wide_macro.group("body"),
            r"tone_map_type|psychov_gamut_mode",
        )
        self.assertRegex(
            addon,
            r"SetRuntimeFlag\(\s*RUNTIME_FLAG_PSYCHOV_BT2020,\s*"
            r"ShouldWritePsychoVBt2020Intermediate\(\)\s*\);",
        )
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
        self.assertIn(
            "return DetroitShouldScaleUi() || "
            "CUSTOM_PSYCHOV_BT2020_ACTIVE;",
            compact_helper,
        )
        self.assertRegex(
            compact_helper,
            r"if \(CUSTOM_PSYCHOV_BT2020_ACTIVE\) \{ "
            r".*?display_light = "
            r"DetroitBt709ToBt2020\(display_light\); \}",
        )
        conversion = compact_helper.index(
            "display_light = DetroitBt709ToBt2020(display_light);"
        )
        encode = compact_helper.index(
            "return DetroitDisplayLightToUiCode(display_light);"
        )
        self.assertLess(conversion, encode)

        straight_alpha_wrappers = {
            "ui_solid_0x2892BFCA.frag.slang": "fcolor.w *= factor.w;",
            "ui_alpha_mask_0x8808E4CC.frag.slang": (
                "c.w *= texture(tex, tc0).w;"
            ),
            "ui_textured_0x9827B559.frag.slang": "fcolor.w *= factor.w;",
            "ui_depth_alpha_mask_0x11C1C2C5.frag.slang": (
                "fcolor.w *= depth_alpha;"
            ),
            "ui_depth_textured_0x97874322.frag.slang": (
                "fcolor.w *= depth_alpha;"
            ),
            "ui_depth_solid_0xC5B9F7FA.frag.slang": (
                "fcolor.w *= depth_alpha;"
            ),
        }
        for wrapper, native_alpha_marker in straight_alpha_wrappers.items():
            with self.subTest(wrapper=wrapper):
                source = (SOURCE_DIR / "hdr" / wrapper).read_text(encoding="utf-8")
                self.assertEqual(
                    source.count("if (DetroitShouldTransformUi())"), 1
                )
                self.assertEqual(
                    source.count("fcolor.xyz = DetroitScaleUiRgb(fcolor.xyz);"), 1
                )
                self.assertLess(
                    source.index(native_alpha_marker),
                    source.index(
                        "fcolor.xyz = DetroitScaleUiRgb(fcolor.xyz);"
                    ),
                )
                scaled_block = re.search(
                    r"if\s*\(DetroitShouldTransformUi\(\)\)\s*"
                    r"\{(?P<body>[\s\S]*?)\}",
                    source,
                )
                self.assertIsNotNone(scaled_block)
                self.assertNotRegex(
                    scaled_block.group("body"),
                    r"fcolor\.(w|a)\s*[+\-*/]?=",
                )

        compositor = (
            SOURCE_DIR / "hdr" / "ui_shadow_composite_0xEF606BCD.frag.slang"
        ).read_text(encoding="utf-8")
        compact_compositor = re.sub(r"\s+", " ", compositor)
        native_sequence = (
            "fcolor = (((shadow_color * fcolor.w) + "
            "(shadow_color_2 * fcolor.x)) * "
            "(1.0 - base.w)) + base_value;",
            "fcolor = (fcolor * vec4(fucxmul.xyz, 1.0)) * fucxmul.w;",
            "fcolor += fucxadd * fcolor.w;",
            "fcolor = clamp(fcolor, vec4(0.0), vec4(1.0));",
        )
        previous = -1
        for native_expression in native_sequence:
            expression_index = compact_compositor.index(native_expression)
            self.assertGreater(expression_index, previous)
            previous = expression_index

        self.assertEqual(compositor.count("DetroitScaleUiRgb("), 1)
        compositor_transform = re.search(
            r"if\s*\(DetroitShouldTransformUi\(\)\)\s*"
            r"\{(?P<body>[\s\S]*?)\n\s*\}",
            compositor,
        )
        self.assertIsNotNone(compositor_transform)
        transform_body = re.sub(
            r"\s+", " ", compositor_transform.group("body")
        )
        self.assertIn("float alpha = fcolor.w;", transform_body)
        self.assertRegex(
            transform_body,
            r"vec3 straight_rgb = alpha > 1\.0e-6 \? "
            r"fcolor\.xyz / alpha : vec3\(0\.0\);",
        )
        self.assertIn(
            "fcolor.xyz = DetroitScaleUiRgb(straight_rgb) * alpha;",
            transform_body,
        )
        self.assertNotRegex(
            transform_body, r"fcolor\.(w|a)\s*[+\-*/]?="
        )
        self.assertLess(
            compact_compositor.index(native_sequence[-1]),
            compact_compositor.index(
                "if (DetroitShouldTransformUi())"
            ),
        )


if __name__ == "__main__":
    unittest.main(verbosity=2)
