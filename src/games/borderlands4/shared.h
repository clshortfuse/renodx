#ifndef SRC_BORDERLANDS4_SHARED_H_
#define SRC_BORDERLANDS4_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float gamma_correction_ui;
  float tone_map_hue_correction;
  float override_black_clip;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_per_channel;
  float custom_lut_strength;
  float custom_lut_scaling;

  float processing_use_scrgb;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injected_buffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injected_buffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type  // 0 - Vanilla, 1 - None, 2 - ACES, 3 - RenoDRT, 4 - SDR
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_HUE_CORRECTION         0.f
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection.tone_map_per_channel
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING             renodx::draw::ENCODING_PQ
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION    1.f
#define RENODX_GAMMA_CORRECTION_UI             1.f
#define RENODX_GAMMA_CORRECTION                1.f
#define CUSTOM_LUT_STRENGTH                    shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                     shader_injection.custom_lut_scaling
#define OVERRIDE_BLACK_CLIP                    shader_injection.override_black_clip  // 0 - Off, 1 - 0.0001 nits

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_BORDERLANDS4_SHARED_H_
