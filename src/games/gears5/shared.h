#ifndef SRC_GAMES_GEARS5_SHARED_H_
#define SRC_GAMES_GEARS5_SHARED_H_

// Gears 5 tone mapper IDs

#define GEARS5_TONE_MAP_TYPE_VANILLA   0.f
#define GEARS5_TONE_MAP_TYPE_RENODRT   3.f
#define GEARS5_TONE_MAP_TYPE_PRISM     31.f
#define GEARS5_TONE_MAP_TYPE_PSYCHOV35 30.f
#define GEARS5_TONE_MAP_TYPE_VANILLA_PLUS 32.f

// Shader injection
//
// Independent Gears 5 layout; no compatibility with Reloaded injection buffers is required.

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
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_working_color_space;
  float tone_map_clamp_color_space;
  float tone_map_clamp_peak;
  float tone_map_hue_processor;
  float tone_map_per_channel;
  float psychov35_purity_scale;
  float psychov35_cone_response_exponent;
  float psychov35_gamut_compression;
  float psychov35_compression;
  float psychov35_gamut_target;
  float graphics_white_nits;
  float padding_2;
  float reserved_sdr_match;
  float padding_0;
  float padding_1;
};

#ifdef __cplusplus
static_assert(sizeof(ShaderInjectData) % 16 == 0);
#endif

#ifndef __cplusplus

#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)

cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))

cbuffer shader_injection : register(b13) {

#endif

  ShaderInjectData shader_injection : packoffset(c0);
}

// RenoDX standard bindings

#define RENODX_TONE_MAP_TYPE \
  shader_injection.tone_map_type

#define RENODX_PEAK_WHITE_NITS \
  shader_injection.peak_white_nits

#define RENODX_DIFFUSE_WHITE_NITS \
  shader_injection.diffuse_white_nits

#define RENODX_GRAPHICS_WHITE_NITS \
  shader_injection.graphics_white_nits

#define RENODX_TONE_MAP_PER_CHANNEL \
  shader_injection.tone_map_per_channel

#define RENODX_TONE_MAP_WORKING_COLOR_SPACE \
  shader_injection.tone_map_working_color_space

#define RENODX_TONE_MAP_HUE_PROCESSOR \
  shader_injection.tone_map_hue_processor

#define RENODX_TONE_MAP_HUE_CORRECTION \
  shader_injection.tone_map_hue_correction

#define RENODX_TONE_MAP_HUE_SHIFT \
  shader_injection.tone_map_hue_shift

#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE \
  shader_injection.tone_map_clamp_color_space

#define RENODX_TONE_MAP_CLAMP_PEAK \
  shader_injection.tone_map_clamp_peak

#define RENODX_TONE_MAP_EXPOSURE \
  shader_injection.tone_map_exposure

#define RENODX_TONE_MAP_HIGHLIGHTS \
  shader_injection.tone_map_highlights

#define RENODX_TONE_MAP_SHADOWS \
  shader_injection.tone_map_shadows

#define RENODX_TONE_MAP_CONTRAST \
  shader_injection.tone_map_contrast

#define RENODX_TONE_MAP_SATURATION \
  shader_injection.tone_map_saturation

#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION \
  shader_injection.tone_map_highlight_saturation

#define RENODX_TONE_MAP_BLOWOUT \
  shader_injection.tone_map_blowout

#define RENODX_TONE_MAP_FLARE \
  shader_injection.tone_map_flare

// PsychoV35 bindings

#define RENODX_PSYCHOV35_PURITY_SCALE \
  shader_injection.psychov35_purity_scale

#define RENODX_PSYCHOV35_CONE_RESPONSE \
  shader_injection.psychov35_cone_response_exponent

#define RENODX_PSYCHOV35_GAMUT_COMPRESSION \
  shader_injection.psychov35_gamut_compression

#define RENODX_PSYCHOV35_COMPRESSION \
  shader_injection.psychov35_compression

#define RENODX_PSYCHOV35_GAMUT_TARGET \
  shader_injection.psychov35_gamut_target

#define RENODX_RENO_DRT_TONE_MAP_METHOD \
  renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#define RENODX_GAMMA_CORRECTION 0.f

#ifndef GEARS5_SDR_CONTRAST_MATCH
#define GEARS5_SDR_CONTRAST_MATCH 1.f
#endif

#include "../../shaders/renodx.hlsl"

#endif  // __cplusplus

#endif  // SRC_GAMES_GEARS5_SHARED_H_
