/*
 * Copyright (C) 2026 megazeban
 * SPDX-License-Identifier: MIT
 */

#ifndef SRC_OKAMI_SHARED_H_
#define SRC_OKAMI_SHARED_H_

// Drive the shared renodx::draw HDR config from runtime-injected settings. Only
// the fields exposed in the UI are mapped here; everything else in
// renodx::draw::BuildConfig() falls back to its compile-time default (scRGB
// swap-chain encode, BT.709 working space, etc.), except where overridden below.
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
// UI/graphics white is tied to game white: all HDR conversion runs on the final
// composite (including the baked-in HUD), so there is no separately-composited UI
// layer to scale, and a single global brightness is what the game wants.
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.diffuse_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
// RenoDRT tone-map curve. The renodx::draw default is Daniele, but the
// handle-sdr-tonemap-lut skill prefers the current methods (Neutwo / Reinhard)
// and says not to use Daniele/Hermite as new choices. Fixed, not exposed - one
// curve is plenty for Okami's sparse, near-white over-range.
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::NEUTWO
// Hue correction (strength + processor), working color space, and per-channel
// scaling are NOT exposed: Okami's HDR over-range is near-white, so there is no
// bright saturated content for them to act on differently. They fall back to
// renodx::draw::BuildConfig() defaults (hue correction on / OKLab, BT709,
// luminance scaling).

struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float gamma_correction;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_OKAMI_SHARED_H_
