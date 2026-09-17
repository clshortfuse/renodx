/*
 * Copyright (C) 2026 RenoDX contributors
 * SPDX-License-Identifier: MIT
 */

#ifndef SRC_GAMES_DISHONORED2_SHARED_H_
#define SRC_GAMES_DISHONORED2_SHARED_H_

struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float color_grade_strength;

  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;

  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;

  float tone_map_flare;
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_working_color_space;

  float tone_map_clamp_color_space;
  float tone_map_clamp_peak;
  float tone_map_hue_processor;
  float tone_map_per_channel;

  float gamma_correction;
  float swap_chain_custom_color_space;
  float swap_chain_output_dither_seed;
  float override_black_clip;

  float bloom_intensity;
  float lens_dirt_amount;
  float sharpening;
  float film_grain;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#else
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                (shader_injection.override_black_clip != 0.f ? 0.f : shader_injection.tone_map_flare)
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define DISHONORED2_BLOOM_INTENSITY          shader_injection.bloom_intensity
#define DISHONORED2_LENS_DIRT_AMOUNT         shader_injection.lens_dirt_amount
#define DISHONORED2_SHARPENING                shader_injection.sharpening
#define DISHONORED2_FILM_GRAIN                shader_injection.film_grain
// VoidEngine's late Iggy UI renders through non-sRGB views and intentionally
// blends in gamma space. Keep the FP16 intermediate sRGB-encoded until every UI
// draw is complete, then decode once in the swap-chain proxy for HDR output.
#define RENODX_INTERMEDIATE_ENCODING         1.f
#define RENODX_SWAP_CHAIN_DECODING           1.f
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_BITS 10.f
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_SEED shader_injection.swap_chain_output_dither_seed
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET      renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_HDR10
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::DANIELE

#include "../../shaders/renodx.hlsl"

float3 Dishonored2RemoveBlackFloor(float3 color, float3 black_point) {
  return saturate(
      max(0.f, color - black_point)
      / max(1e-4f, 1.f - black_point));
}

#endif

#endif  // SRC_GAMES_DISHONORED2_SHARED_H_
