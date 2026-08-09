#!/usr/bin/env python3
"""Regression tests for Detroit's production HDR/output-mode/CAS gates."""

from __future__ import annotations

import argparse
import math
from pathlib import Path
import random
import re
import struct
import sys
import unittest


OUTPUT_MODE_AUTO = 0.0
OUTPUT_MODE_SDR = 1.0
OUTPUT_MODE_HDR10 = 2.0

CAS_MODE_VANILLA = 0.0
CAS_MODE_OFF = 1.0
CAS_MODE_RENODX = 2.0

RUNTIME_FLAG_DLSS_OUTPUT = 1 << 0
RUNTIME_FLAG_PSYCHOV_BT2020 = 1 << 1
RUNTIME_FLAG_MASK = RUNTIME_FLAG_DLSS_OUTPUT | RUNTIME_FLAG_PSYCHOV_BT2020


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


def custom_hdr_active(output_mode: float, output_is_hdr: float) -> bool:
    """Literal model of CUSTOM_HDR_ACTIVE in production shared.h."""
    return output_is_hdr >= 0.5 and output_mode != OUTPUT_MODE_SDR


def normalize_runtime_flags(runtime_flags: float | int) -> int:
    if not math.isfinite(float(runtime_flags)):
        return 0
    return min(max(round(float(runtime_flags)), 0), RUNTIME_FLAG_MASK)


def set_runtime_flag(runtime_flags: int, flag: int, enabled: bool) -> int:
    flags = normalize_runtime_flags(runtime_flags)
    return (flags | flag) if enabled else (flags & ~flag)


def custom_dlss_active(runtime_flags: float | int) -> bool:
    return (
        normalize_runtime_flags(runtime_flags) & RUNTIME_FLAG_DLSS_OUTPUT
    ) != 0


def custom_psychov_bt2020_active(runtime_flags: float | int) -> bool:
    return (
        normalize_runtime_flags(runtime_flags) & RUNTIME_FLAG_PSYCHOV_BT2020
    ) != 0


def should_write_psychov_bt2020_intermediate(
    output_mode: float,
    output_is_hdr: float,
    tone_map_type: float,
    render_debug_payload: float,
) -> bool:
    return (
        custom_hdr_active(output_mode, output_is_hdr)
        and tone_map_type in (3.0, 4.0, 5.0)
        and float32_bits(render_debug_payload) == b"\0\0\0\0"
    )


def custom_dlaa_sharpening(strength: float) -> float:
    return min(max(float32(strength), 0.0), 1.0)


def use_hdr_safe_cas(
    output_mode: float,
    output_is_hdr: float,
    cas_mode: float,
    runtime_flags: float = 0.0,
) -> bool:
    return custom_hdr_active(output_mode, output_is_hdr) and (
        cas_mode >= 0.5 or custom_dlss_active(runtime_flags)
    )


def use_display_peak_limit(
    output_mode: float, output_is_hdr: float, tone_map_type: float
) -> bool:
    return custom_hdr_active(output_mode, output_is_hdr) and tone_map_type != 0.0


def effective_sharpness(
    native_sharpness: float,
    output_mode: float,
    output_is_hdr: float,
    cas_mode: float,
    cas_strength: float,
    runtime_flags: float = 0.0,
) -> float:
    """Model only the production branch that may alter native CAS strength."""
    native = float32(native_sharpness)
    if custom_dlss_active(runtime_flags):
        # The pre-DOF adapter pack owns DLAA sharpening; the optional late
        # native CAS pass is disabled to prevent double sharpening.
        return float32(0.0)
    if not use_hdr_safe_cas(
        output_mode, output_is_hdr, cas_mode, runtime_flags
    ):
        return native
    if cas_mode < 1.5:
        return float32(0.0)
    strength = min(max(float32(cas_strength), 0.0), 1.0)
    return float32(native * strength)


def display_peak_cap(
    rgb: tuple[float, float, float], peak_nits: float, active: bool
) -> tuple[float, float, float]:
    """Model the single-scalar cap applied to Detroit's linear display light."""
    if not active:
        return rgb
    configured_peak = max(float32(peak_nits), 0.0) / 300.0
    output_peak = max(rgb)
    if output_peak <= configured_peak:
        return rgb
    scale = configured_peak / max(output_peak, 1.0e-6)
    return tuple(float32(channel * scale) for channel in rgb)


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


class HDRAndCASGateTests(unittest.TestCase):
    native_sharpness = float32(-0.125)

    def assert_native_bypass(
        self, output_mode: float, output_is_hdr: float, cas_mode: float
    ) -> None:
        actual = effective_sharpness(
            self.native_sharpness,
            output_mode,
            output_is_hdr,
            cas_mode,
            0.37,
        )
        self.assertEqual(float32_bits(actual), float32_bits(self.native_sharpness))

    def test_hdr10_mode_cannot_force_hdr_math_on_an_sdr_swapchain(self):
        for cas_mode in (CAS_MODE_VANILLA, CAS_MODE_OFF, CAS_MODE_RENODX):
            with self.subTest(cas_mode=cas_mode):
                self.assertFalse(
                    use_hdr_safe_cas(OUTPUT_MODE_HDR10, 0.0, cas_mode)
                )
                self.assert_native_bypass(OUTPUT_MODE_HDR10, 0.0, cas_mode)

    def test_sdr_mode_bypasses_custom_cas_on_an_hdr_swapchain(self):
        for cas_mode in (CAS_MODE_VANILLA, CAS_MODE_OFF, CAS_MODE_RENODX):
            with self.subTest(cas_mode=cas_mode):
                self.assertFalse(use_hdr_safe_cas(OUTPUT_MODE_SDR, 1.0, cas_mode))
                self.assert_native_bypass(OUTPUT_MODE_SDR, 1.0, cas_mode)

    def test_auto_follows_the_measured_swapchain(self):
        self.assertFalse(custom_hdr_active(OUTPUT_MODE_AUTO, 0.0))
        self.assertTrue(custom_hdr_active(OUTPUT_MODE_AUTO, 1.0))

    def test_scene_draw_sets_wide_carrier_only_for_the_actual_wide_path(self):
        for tone_map_type in (3.0, 4.0, 5.0):
            with self.subTest(tone_map_type=tone_map_type):
                self.assertTrue(
                    should_write_psychov_bt2020_intermediate(
                        OUTPUT_MODE_AUTO,
                        1.0,
                        tone_map_type,
                        0.0,
                    )
                )

        blocked_cases = (
            (OUTPUT_MODE_SDR, 1.0, 4.0, 0.0, "forced SDR"),
            (OUTPUT_MODE_HDR10, 0.0, 4.0, 0.0, "SDR swapchain"),
            (OUTPUT_MODE_AUTO, 1.0, 2.0, 0.0, "RenoDRT"),
            (OUTPUT_MODE_AUTO, 1.0, 4.0, 1.0, "debug view"),
            (OUTPUT_MODE_AUTO, 1.0, 4.0, -0.0, "packed debug"),
        )
        for (
            output_mode,
            output_is_hdr,
            tone_map_type,
            debug_payload,
            reason,
        ) in blocked_cases:
            with self.subTest(reason=reason):
                self.assertFalse(
                    should_write_psychov_bt2020_intermediate(
                        output_mode,
                        output_is_hdr,
                        tone_map_type,
                        debug_payload,
                    )
                )

    def test_no_scene_video_or_loading_frame_falls_back_to_bt709(self):
        previous_frame_flags = (
            RUNTIME_FLAG_DLSS_OUTPUT | RUNTIME_FLAG_PSYCHOV_BT2020
        )
        # OnPresent clears transient state. Settings alone cannot reactivate the
        # carrier when the following video/loading frame has no scene draw.
        next_frame_flags = 0
        self.assertTrue(custom_psychov_bt2020_active(previous_frame_flags))
        self.assertTrue(
            should_write_psychov_bt2020_intermediate(
                OUTPUT_MODE_AUTO, 1.0, 4.0, 0.0
            )
        )
        self.assertFalse(custom_psychov_bt2020_active(next_frame_flags))

    def test_runtime_flag_updates_preserve_dlss_and_wide_carrier_bits(self):
        flags = set_runtime_flag(0, RUNTIME_FLAG_PSYCHOV_BT2020, True)
        flags = set_runtime_flag(flags, RUNTIME_FLAG_DLSS_OUTPUT, True)
        self.assertEqual(flags, RUNTIME_FLAG_MASK)
        self.assertTrue(custom_dlss_active(flags))
        self.assertTrue(custom_psychov_bt2020_active(flags))

        flags = set_runtime_flag(flags, RUNTIME_FLAG_DLSS_OUTPUT, False)
        self.assertEqual(flags, RUNTIME_FLAG_PSYCHOV_BT2020)
        self.assertFalse(custom_dlss_active(flags))
        self.assertTrue(custom_psychov_bt2020_active(flags))

        flags = set_runtime_flag(flags, RUNTIME_FLAG_DLSS_OUTPUT, True)
        flags = set_runtime_flag(flags, RUNTIME_FLAG_PSYCHOV_BT2020, False)
        self.assertEqual(flags, RUNTIME_FLAG_DLSS_OUTPUT)
        self.assertTrue(custom_dlss_active(flags))
        self.assertFalse(custom_psychov_bt2020_active(flags))

    def test_final_basis_gate_uses_the_actual_carrier_bit(self):
        self.assertFalse(custom_psychov_bt2020_active(0))
        self.assertFalse(custom_psychov_bt2020_active(RUNTIME_FLAG_DLSS_OUTPUT))
        self.assertTrue(
            custom_psychov_bt2020_active(RUNTIME_FLAG_PSYCHOV_BT2020)
        )
        self.assertTrue(custom_psychov_bt2020_active(RUNTIME_FLAG_MASK))

    def test_vanilla_is_an_exact_bypass_on_hdr(self):
        for output_mode in (OUTPUT_MODE_AUTO, OUTPUT_MODE_HDR10):
            with self.subTest(output_mode=output_mode):
                self.assert_native_bypass(output_mode, 1.0, CAS_MODE_VANILLA)

    def test_off_and_renodx_strength_apply_only_on_measured_hdr(self):
        for output_mode in (OUTPUT_MODE_AUTO, OUTPUT_MODE_HDR10):
            with self.subTest(output_mode=output_mode):
                self.assertEqual(
                    float32_bits(
                        effective_sharpness(
                            self.native_sharpness,
                            output_mode,
                            1.0,
                            CAS_MODE_OFF,
                            1.0,
                        )
                    ),
                    float32_bits(0.0),
                )
                half = effective_sharpness(
                    self.native_sharpness,
                    output_mode,
                    1.0,
                    CAS_MODE_RENODX,
                    0.5,
                )
                self.assertEqual(
                    float32_bits(half),
                    float32_bits(self.native_sharpness * 0.5),
                )

    def test_renodx_strength_is_clamped(self):
        low = effective_sharpness(
            self.native_sharpness,
            OUTPUT_MODE_AUTO,
            1.0,
            CAS_MODE_RENODX,
            -10.0,
        )
        high = effective_sharpness(
            self.native_sharpness,
            OUTPUT_MODE_AUTO,
            1.0,
            CAS_MODE_RENODX,
            10.0,
        )
        # Multiplying Detroit's negative native lobe by a clamped zero may
        # retain the IEEE-754 sign bit; numerically it is still disabled.
        self.assertEqual(low, 0.0)
        self.assertEqual(float32_bits(high), float32_bits(self.native_sharpness))

    def test_dlaa_sharpening_is_independent_and_clamped(self):
        for output_mode, output_is_hdr, cas_mode in (
            (OUTPUT_MODE_SDR, 0.0, CAS_MODE_VANILLA),
            (OUTPUT_MODE_AUTO, 1.0, CAS_MODE_OFF),
            (OUTPUT_MODE_HDR10, 1.0, CAS_MODE_RENODX),
        ):
            with self.subTest(
                output_mode=output_mode,
                output_is_hdr=output_is_hdr,
                cas_mode=cas_mode,
            ):
                disabled = effective_sharpness(
                    self.native_sharpness,
                    output_mode,
                    output_is_hdr,
                    cas_mode,
                    1.0,
                    runtime_flags=RUNTIME_FLAG_DLSS_OUTPUT,
                )
                half_native_cas = effective_sharpness(
                    self.native_sharpness,
                    output_mode,
                    output_is_hdr,
                    cas_mode,
                    0.0,
                    runtime_flags=RUNTIME_FLAG_DLSS_OUTPUT,
                )
                full_native_cas = effective_sharpness(
                    self.native_sharpness,
                    output_mode,
                    output_is_hdr,
                    cas_mode,
                    0.0,
                    runtime_flags=RUNTIME_FLAG_DLSS_OUTPUT,
                )
                self.assertEqual(disabled, 0.0)
                self.assertEqual(half_native_cas, 0.0)
                self.assertEqual(full_native_cas, 0.0)
                self.assertEqual(custom_dlaa_sharpening(-1.0), 0.0)
                self.assertEqual(custom_dlaa_sharpening(0.5), 0.5)
                self.assertEqual(custom_dlaa_sharpening(9.0), 1.0)

        self.assertFalse(
            use_hdr_safe_cas(
                OUTPUT_MODE_SDR,
                1.0,
                CAS_MODE_VANILLA,
                runtime_flags=RUNTIME_FLAG_DLSS_OUTPUT,
            )
        )
        self.assertTrue(
            use_hdr_safe_cas(
                OUTPUT_MODE_AUTO,
                1.0,
                CAS_MODE_VANILLA,
                runtime_flags=RUNTIME_FLAG_DLSS_OUTPUT,
            )
        )

    def test_peak_cap_has_exact_gate_bypasses(self):
        rgb = tuple(float32(value) for value in (3.0, 2.0, 1.0))
        inactive_cases = (
            (OUTPUT_MODE_AUTO, 1.0, 0.0),
            (OUTPUT_MODE_SDR, 1.0, 2.0),
            (OUTPUT_MODE_HDR10, 0.0, 2.0),
        )
        for output_mode, output_is_hdr, tone_map_type in inactive_cases:
            with self.subTest(
                output_mode=output_mode,
                output_is_hdr=output_is_hdr,
                tone_map_type=tone_map_type,
            ):
                result = display_peak_cap(
                    rgb,
                    600.0,
                    use_display_peak_limit(
                        output_mode, output_is_hdr, tone_map_type
                    ),
                )
                for actual, expected in zip(result, rgb):
                    self.assertEqual(float32_bits(actual), float32_bits(expected))

    def test_peak_cap_is_independent_of_cas_mode(self):
        rgb = (8.0, 4.0, 2.0)
        expected = display_peak_cap(rgb, 600.0, True)
        for cas_mode in (CAS_MODE_VANILLA, CAS_MODE_OFF, CAS_MODE_RENODX):
            with self.subTest(cas_mode=cas_mode):
                active = use_display_peak_limit(
                    OUTPUT_MODE_AUTO, 1.0, tone_map_type=2.0
                )
                self.assertTrue(active)
                self.assertEqual(display_peak_cap(rgb, 600.0, active), expected)

    def test_peak_cap_is_identity_below_the_selected_peak(self):
        rgb = tuple(float32(value) for value in (2.5, 1.25, 0.5))
        result = display_peak_cap(rgb, 1000.0, True)
        for actual, expected in zip(result, rgb):
            self.assertEqual(float32_bits(actual), float32_bits(expected))

    def test_peak_cap_preserves_color_ratios_with_one_scalar(self):
        samples = [(3.0, 2.0, 1.0), (3.0, 0.5, 0.5)]
        rng = random.Random(0x94F97DCF)
        samples.extend(
            tuple(rng.uniform(0.01, 8.0) for _ in range(3))
            for _ in range(32)
        )
        for rgb in samples:
            with self.subTest(rgb=rgb):
                result = display_peak_cap(rgb, 203.0, True)
                self.assertLessEqual(max(result), (203.0 / 300.0) + 1.0e-6)
                scales = [result[i] / rgb[i] for i in range(3)]
                self.assertAlmostEqual(scales[0], scales[1], places=6)
                self.assertAlmostEqual(scales[1], scales[2], places=6)

    def test_peak_cap_matches_the_native_pq_tail_at_1000_nits(self):
        capped = display_peak_cap((8.0, 8.0, 8.0), 1000.0, True)
        # Detroit multiplies _6250 by 0.03 before its unchanged ST.2084 tail.
        encoded = pq_encode(capped[0] * 0.03)
        self.assertAlmostEqual(encoded, 0.751827096, places=8)
        self.assertEqual(round(encoded * 1023.0), 769)

    def test_1033_nit_cap_stays_within_the_next_r10_pq_level(self):
        capped = display_peak_cap((20.0, 20.0, 20.0), 1033.0, True)
        encoded = pq_encode(capped[0] * 0.03)
        quantized = round(encoded * 1023.0) / 1023.0
        decoded_nits = pq_decode(quantized) * 10000.0
        self.assertLessEqual(decoded_nits, 1036.0)

    def test_peak_cap_is_monotonic_for_supported_display_points(self):
        encoded_values = []
        for peak_nits in (203.0, 600.0, 1000.0, 4000.0):
            capped = display_peak_cap((20.0, 20.0, 20.0), peak_nits, True)
            self.assertLessEqual(max(capped), (peak_nits / 300.0) + 1.0e-6)
            encoded_values.append(pq_encode(capped[0] * 0.03))
        self.assertTrue(
            all(lhs < rhs for lhs, rhs in zip(encoded_values, encoded_values[1:]))
        )

    def test_production_sources_keep_the_same_gate_contract(self):
        shared = (SOURCE_DIR / "shared.h").read_text(encoding="utf-8")
        shader = (SOURCE_DIR / "oetf_hdr_cas_0x94F97DCF.frag.slang").read_text(
            encoding="utf-8"
        )
        final_shader = (SOURCE_DIR / "oetf_hdr_0xF478AFEF.frag.slang").read_text(
            encoding="utf-8"
        )
        peak_limiter = (SOURCE_DIR / "display_peak_limiter.hlsli").read_text(
            encoding="utf-8"
        )
        hdr_intermediate = (SOURCE_DIR / "hdr_intermediate.hlsli").read_text(
            encoding="utf-8"
        )
        scene_shader = (SOURCE_DIR / "scene_0xEBFBDDB1.comp.slang").read_text(
            encoding="utf-8"
        )
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")
        temporal_capture = (SOURCE_DIR / "temporal_capture.hpp").read_text(
            encoding="utf-8"
        )
        pack_shader = (
            SOURCE_DIR
            / "dlss"
            / "shaders"
            / "detroit_dlss_pack_color.comp.slang"
        ).read_text(encoding="utf-8")
        adapter_runtime = (
            SOURCE_DIR / "dlss" / "adapter_runtime.cpp"
        ).read_text(encoding="utf-8")
        vulkan_layer = (
            SOURCE_DIR / "dlss" / "vulkan_layer.cpp"
        ).read_text(encoding="utf-8")
        bridge_abi = (SOURCE_DIR / "dlss_bridge_abi.h").read_text(
            encoding="utf-8"
        )

        expected_constants = {
            "OUTPUT_MODE_AUTO": "0.f",
            "OUTPUT_MODE_SDR": "1.f",
            "OUTPUT_MODE_HDR10": "2.f",
            "CAS_MODE_VANILLA": "0.f",
            "CAS_MODE_OFF": "1.f",
            "CAS_MODE_RENODX": "2.f",
        }
        for name, value in expected_constants.items():
            self.assertRegex(
                addon,
                rf"constexpr\s+float\s+{name}\s*=\s*{re.escape(value)}\s*;",
            )

        runtime_helpers = addon[
            addon.index("constexpr std::uint32_t RUNTIME_FLAG_DLSS_OUTPUT") :
            addon.index("bool IsSharedHdrIntermediateTarget(")
        ]
        self.assertRegex(
            runtime_helpers,
            r"RUNTIME_FLAG_DLSS_OUTPUT\s*=\s*1u\s*<<\s*0u\s*;",
        )
        self.assertRegex(
            runtime_helpers,
            r"RUNTIME_FLAG_PSYCHOV_BT2020\s*=\s*1u\s*<<\s*1u\s*;",
        )
        self.assertRegex(
            runtime_helpers,
            r"flags\s*=\s*enabled\s*\?\s*"
            r"\(flags\s*\|\s*flag\)\s*:\s*"
            r"\(flags\s*&\s*~flag\)\s*;",
        )
        self.assertIn(
            "shader_injection.runtime_flags = static_cast<float>(flags);",
            runtime_helpers,
        )
        should_write = runtime_helpers[
            runtime_helpers.index("bool ShouldWritePsychoVBt2020Intermediate()") :
        ]
        for required_gate in (
            "shader_injection.output_is_hdr >= 0.5f",
            "shader_injection.output_mode != OUTPUT_MODE_SDR",
            "shader_injection.scene_path_active",
        ):
            self.assertIn(required_gate, should_write)
        self.assertRegex(
            should_write,
            r"shader_injection\.tone_map_type\s*==\s*3\.f\s*"
            r"\|\|\s*shader_injection\.tone_map_type\s*==\s*4\.f\s*"
            r"\|\|\s*shader_injection\.tone_map_type\s*==\s*5\.f",
        )
        self.assertRegex(
            should_write,
            r"std::bit_cast<std::uint32_t>\(\s*"
            r"shader_injection\.scene_path_active\s*\)\s*==\s*0u",
        )

        peak_setting = re.search(
            r'\{"ToneMapPeakNits",\s*\{(?P<body>[\s\S]*?)\}\},',
            addon,
        )
        self.assertIsNotNone(peak_setting)
        self.assertIn(".binding = &manual_peak_nits", peak_setting.group("body"))
        self.assertNotIn("shader_injection", peak_setting.group("body"))
        self.assertIn('.key = "PeakBrightnessSource"', addon)
        self.assertIn('.labels = {"Auto", "Manual"}', addon)
        self.assertRegex(
            addon,
            r'\.key\s*=\s*"PeakBrightnessSource"[\s\S]*?'
            r"\.default_value\s*=\s*0\.f",
        )
        self.assertIn(
            "shader_injection.peak_white_nits = resolution.effective_peak_nits",
            addon,
        )
        self.assertIn(
            "renodx::utils::swapchain::GetDirectXOutputDesc1(window)", addon
        )
        self.assertIn("output_desc.MaxFullFrameLuminance", addon)

        compact_shared = re.sub(r"\\\s*\n\s*", " ", shared)
        self.assertRegex(
            compact_shared,
            r"#define\s+CUSTOM_HDR_ACTIVE\s+"
            r"\(shader_injection\.output_is_hdr\s*>=\s*0\.5f\s*&&\s*"
            r"shader_injection\.output_mode\s*!=\s*1\.f\)",
        )
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
        self.assertRegex(
            compact_shared,
            r"#define\s+CUSTOM_DLSS_ACTIVE\s+"
            r"\(\(CUSTOM_RUNTIME_FLAGS\s*&\s*0x1u\)\s*!=\s*0u\)",
        )
        self.assertNotIn("CUSTOM_DLAA_SHARPENING", compact_shared)
        self.assertRegex(
            shader,
            r"bool\s+use_hdr_safe_cas_path\s*=\s*CUSTOM_HDR_ACTIVE\s*&&\s*"
            r"\(shader_injection\.cas_mode\s*>=\s*0\.5\s*\|\|\s*"
            r"CUSTOM_DLSS_ACTIVE\)\s*;",
        )
        self.assertRegex(
            peak_limiter,
            r"if\s*\(\s*!CUSTOM_HDR_ACTIVE\s*\|\|\s*"
            r"shader_injection\.tone_map_type\s*==\s*0\.0\s*\)",
        )
        self.assertNotIn("cas_mode", peak_limiter)
        self.assertIn("LimitDisplayLightPeak(_6250)", shader)
        self.assertIn(
            "LimitDisplayLightPeak(display_light_intermediate)", final_shader
        )
        self.assertRegex(
            hdr_intermediate,
            r"if\s*\(CUSTOM_PSYCHOV_BT2020_ACTIVE\)\s*"
            r"\{[\s\S]*?return\s+display_light_intermediate\s*;\s*\}",
        )
        self.assertIn(
            "return bt709_to_bt2020 * display_light_intermediate;",
            hdr_intermediate,
        )
        for name, output_shader, limited_value in (
            ("final", final_shader, "display_light_intermediate"),
            ("cas", shader, "_6250"),
        ):
            with self.subTest(output_path=name):
                limiter = output_shader.index(
                    f"LimitDisplayLightPeak({limited_value})"
                )
                conversion = output_shader.index(
                    "DetroitIntermediateDisplayLightToBt2020(", limiter
                )
                pq_tail = output_shader.index("vec3 pq_power", conversion) \
                    if name == "final" else output_shader.index(
                        "vec3 _6297", conversion
                    )
                self.assertLess(limiter, conversion)
                self.assertLess(conversion, pq_tail)
        self.assertRegex(
            addon,
            r"\{0xF478AFEF,\s*\{[\s\S]*?\.code\s*=\s*__0xF478AFEF",
        )
        self.assertRegex(
            shader,
            r"float\s+sharpening_strength\s*=\s*"
            r"shader_injection\.cas_mode\s*<\s*1\.5\s*\?\s*0\.0\s*:\s*"
            r"clamp\(shader_injection\.cas_strength,\s*0\.0,\s*1\.0\)\s*;",
        )
        self.assertRegex(
            shader,
            r"if\s*\(CUSTOM_DLSS_ACTIVE\)[\s\S]*?"
            r"_4359\s*=\s*0\.0\s*;",
        )
        self.assertNotRegex(
            shader,
            r"_4359\s*\*=\s*CUSTOM_DLAA_SHARPENING\s*;",
        )
        self.assertNotIn("ApplyDlaaRcas", scene_shader)
        self.assertNotIn("CUSTOM_DLSS_ACTIVE", scene_shader)
        self.assertIn("vec3 ApplyDlaaRcas(", pack_shader)
        self.assertIn("layout(set = 0, binding = 2, std140)", pack_shader)
        self.assertRegex(
            pack_shader,
            r"if\s*\(sharpening\s*>\s*0\.0\)[\s\S]*?"
            r"color\s*=\s*ApplyDlaaRcas\(",
        )
        self.assertIn('.key = "DLAASharpening"', addon)
        self.assertIn('.labels = {"Native TAA", "DLAA"}', addon)
        self.assertRegex(
            addon,
            r"SetRuntimeFlag\(\s*RUNTIME_FLAG_DLSS_OUTPUT\s*,\s*"
            r"gate\.active\s*\)\s*;",
        )
        self.assertIn("temporal_capture::SetDlaaSharpening(", addon)
        self.assertIn("before Detroit's DOF", addon)
        self.assertIn("float dlaa_sharpening;", bridge_abi)
        self.assertIn("float dlaa_sharpening_normalization;", bridge_abi)
        self.assertIn(".dlaa_sharpening = inputs->dlaa_sharpening,", vulkan_layer)
        self.assertIn("VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER", adapter_runtime)
        self.assertIn("procedures.cmd_update_buffer(", adapter_runtime)
        self.assertIn("VK_ACCESS_TRANSFER_WRITE_BIT", adapter_runtime)
        self.assertIn("VK_ACCESS_UNIFORM_READ_BIT", adapter_runtime)
        self.assertRegex(
            addon,
            r"\.crc32\s*=\s*0xEBFBDDB1,[\s\S]*?"
            r"\.on_draw\s*=\s*&OnSceneDraw,",
        )
        on_scene_draw = addon[
            addon.index("bool OnSceneDraw(") :
            addon.index("void OnSceneDrawn(")
        ]
        dlss_update = on_scene_draw.index("ApplyDlssOutputMarker(")
        wide_update = on_scene_draw.index(
            "SetRuntimeFlag(\n"
            "      RUNTIME_FLAG_PSYCHOV_BT2020,"
        )
        self.assertLess(dlss_update, wide_update)
        self.assertIn(
            "ShouldWritePsychoVBt2020Intermediate()",
            on_scene_draw[wide_update:],
        )

        on_present = addon[
            addon.index("void OnPresent(") :
            addon.index("}  // namespace", addon.index("void OnPresent("))
        ]
        begin_next_frame = on_present.index(
            "temporal_capture::BeginNextFrame();"
        )
        clear_runtime_flags = on_present.index(
            "shader_injection.runtime_flags = 0.f;"
        )
        self.assertLess(begin_next_frame, clear_runtime_flags)
        self.assertIn(
            "video/loading frame without the scene composite",
            on_present[begin_next_frame:clear_runtime_flags],
        )
        self.assertRegex(
            addon,
            r"const\s+bool\s+active\s*=\s*"
            r"temporal_capture::GetMode\(\)\s*==\s*"
            r"DETROIT_DLSS_MODE_DLAA\s*;",
        )
        sharpening_log_key_start = addon.index(
            "const auto log_key = temporal_capture::MakeTelemetryKey(",
            addon.index("void ApplyDlssOutputMarker("),
        )
        sharpening_log_key_end = addon.index(
            "if (last_dlaa_sharpening_log_key.exchange(",
            sharpening_log_key_start,
        )
        sharpening_log_key = addon[
            sharpening_log_key_start:sharpening_log_key_end
        ]
        self.assertIn("temporal_capture::GetMode()", sharpening_log_key)
        self.assertIn("strength_percent", sharpening_log_key)
        self.assertNotIn("temporal_capture::GetStatus()", sharpening_log_key)
        self.assertNotIn("exact_command_list_match", sharpening_log_key)
        self.assertRegex(
            addon,
            r"bool\s+OnSceneDraw\([^)]*\)\s*\{[\s\S]*?"
            r"MarkMainTemporalCommandList\(command_list->get_native\(\)\)"
            r";[\s\S]*?ApplyDlssOutputMarker\(",
        )
        self.assertIn("ObserveTemporalCommandList(", temporal_capture)
        self.assertRegex(
            temporal_capture,
            r"if\s*\(mode\s*!=\s*DETROIT_DLSS_MODE_NATIVE\s*&&\s*"
            r"!is_main_temporal_command_list\)"
            r"\s*\{[\s\S]*?RuntimeStatus::kWaitingForDispatch[\s\S]*?return;",
        )

        self.assertIn("RequestAuxiliaryTemporalReplacement", temporal_capture)
        self.assertRegex(
            temporal_capture,
            r"native_temporal_pipeline\.handle\s*!=\s*0u\s*&&\s*"
            r"dlss::embedded::CanInsertComputeWriteBarrier\(native_command_list\)"
            r"\s*&&\s*"
            r"IsMainTemporalCommandList\(native_command_list\)\s*&&\s*"
            r"authorization\.authorized",
        )
        self.assertIn("authorization.snapshot.generation", temporal_capture)
        self.assertIn(
            "replacement_generation != mode_snapshot.generation", temporal_capture
        )
        self.assertIn("struct NativeTemporalFallbackGuard", temporal_capture)
        self.assertRegex(
            temporal_capture,
            r"~NativeTemporalFallbackGuard\(\)[\s\S]*?"
            r"bind_pipeline\([\s\S]*?native_pipeline\)[\s\S]*?"
            r"dispatch\(",
        )
        self.assertIn("native_fallback.Disarm();", temporal_capture)
        self.assertIn("InsertComputeWriteBarrier(", temporal_capture)
        self.assertRegex(
            addon,
            r"kTemporalAaShaderCrc,[\s\S]*?\.code\s*=\s*__temporal_aux,[\s\S]*?"
            r"\.on_replace\s*=\s*&OnTemporalAuxiliaryReplace,",
        )

        auxiliary_shader = (SOURCE_DIR / "temporal_aux.comp.vk.glsl").read_text(
            encoding="utf-8"
        )
        self.assertIn(
            "RenderDebugAnySourceAtPass(RENDER_DEBUG_PASS_TEMPORAL)",
            auxiliary_shader,
        )
        self.assertIn("!RenderDebugTemporalUnavailable()", auxiliary_shader)
        self.assertIn("imageStore(\n                OutColorPass", auxiliary_shader)
        for history_output in (
            "imageStore(OutAADepth",
            "imageStore(OutPrevSpeedAndFlagsTex",
            "imageStore(HalfResContours",
        ):
            self.assertIn(history_output, auxiliary_shader)

        adapter_runtime = (
            SOURCE_DIR / "dlss" / "adapter_runtime.cpp"
        ).read_text(encoding="utf-8")
        prepare_shader = (
            SOURCE_DIR
            / "dlss"
            / "shaders"
            / "detroit_dlss_prepare_color_motion.comp.slang"
        ).read_text(encoding="utf-8")
        self.assertIn(
            "bundle.native_motion_vectors = prepare_info.motion_vectors;",
            adapter_runtime,
        )
        self.assertIn(
            "prepared_frame->motion_vectors = bundle.native_motion_vectors;",
            adapter_runtime,
        )
        self.assertNotIn("ImageAllocation motion_vectors", adapter_runtime)
        self.assertNotIn("MotionVectorTex", prepare_shader)
        self.assertNotIn("OutMotionVectors", prepare_shader)

        cap_start = shader.index("vec3 _6250 =")
        cap_end = shader.index("vec3 _6297 =", cap_start)
        cap_source = shader[cap_start:cap_end]
        self.assertIn("_6250 = LimitDisplayLightPeak(_6250);", cap_source)
        self.assertIn("configured_display_peak", peak_limiter)
        self.assertIn("shader_injection.peak_white_nits", peak_limiter)
        self.assertIn("display_light_intermediate *=", peak_limiter)
        self.assertNotIn("min(_6112", shader)

        for color_space in (
            "hdr10_st2084",
            "hdr10_hlg",
            "extended_srgb_linear",
        ):
            self.assertIn(color_space, addon)
        self.assertRegex(
            addon,
            r"shader_injection\.output_is_hdr\s*=\s*"
            r"IsHdrOutputColorSpace\(color_space\)\s*"
            r"\?\s*1\.f\s*:\s*0\.f\s*;",
        )

    def test_preset_off_keeps_ultrawide_compatibility_independent(self):
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")
        preset_off = re.search(
            r"void\s+OnPresetOff\(\)\s*\{(?P<body>[\s\S]*?)\n\}",
            addon,
        )
        self.assertIsNotNone(preset_off)
        body = preset_off.group("body")
        self.assertNotIn('"AspectRatioMode"', body)
        self.assertIn("OnAspectRatioModeChanged();", body)

    def test_runtime_switches_apply_the_post_write_setting_value(self):
        addon = (SOURCE_DIR / "addon.cpp").read_text(encoding="utf-8")

        dlss_setting = re.search(
            r'\.key\s*=\s*"DLSSMode"(?P<body>[\s\S]*?)\n\s*\}\},',
            addon,
        )
        self.assertIsNotNone(dlss_setting)
        self.assertNotIn(".on_change =", dlss_setting.group("body"))
        self.assertRegex(
            dlss_setting.group("body"),
            r"\.on_change_value\s*=\s*\[\]\(float,\s*float\s+current\)\s*"
            r"\{\s*ApplyDlssMode\(current\);\s*\}",
        )

        aspect_setting = re.search(
            r'\.key\s*=\s*"AspectRatioMode"(?P<body>[\s\S]*?)\n\s*\}\},',
            addon,
        )
        self.assertIsNotNone(aspect_setting)
        self.assertNotIn(".on_change =", aspect_setting.group("body"))
        self.assertRegex(
            aspect_setting.group("body"),
            r"\.on_change_value\s*=\s*\[\]\(float,\s*float\s+current\)\s*"
            r"\{\s*ApplyAspectRatioMode\(current\);\s*\}",
        )


if __name__ == "__main__":
    unittest.main(verbosity=2)
