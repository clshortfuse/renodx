#ifndef SRC_DBZSPARK_SHARED_H_
#define SRC_DBZSPARK_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_per_channel;
  float scene_grade_saturation_correction;
  float scene_grade_blowout_restoration;
  float scene_grade_hue_correction;
  float custom_grain_type;
  float custom_grain_strength;
  float custom_random;
  float custom_enable_post_filmgrain;
  float custom_sharpness;
  float custom_lut_strength;
  float custom_lut_scaling;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 3.f
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_PER_CHANNEL          1.f
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_SWAP_CHAIN_DECODING           renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE  renodx::color::convert::COLOR_SPACE_BT2020
#define RENODX_INTERMEDIATE_SCALING          1.f
#define RENODX_TONE_MAP_HUE_CORRECTION       0.75f
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION  1.f
#define RENODX_GAMMA_CORRECTION_UI           1.f
#define RENODX_GAMMA_CORRECTION              1.f
#define CUSTOM_HUE_CORRECTION                0.f
#define CUSTOM_LUT_STRENGTH                  1.f
#define CUSTOM_LUT_SCALING                   0.f
#define OVERRIDE_BLACK_CLIP                  1.f  // 0 - Off, 1 - 0.0001 nits

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_DBZSPARK_SHARED_H_
