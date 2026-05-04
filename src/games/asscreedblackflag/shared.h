#ifndef SRC_ASSCREEDBLACKFLAG_SHARED_H_
#define SRC_ASSCREEDBLACKFLAG_SHARED_H_

#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#define RENODX_RENDER_MODE                   shader_injection.render_mode_setting
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_WHITE_CLIP           shader_injection.white_clip
#define CUSTOM_HDR_BOOST                     shader_injection.hdr_boost

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare

#define RENODX_GAMMA_CORRECTION               0.f

#define CUSTOM_GRADING_STRENGTH              shader_injection.custom_grading_strength
//#define CUSTOM_SCENE_GRADE_PEAK              shader_injection.scene_grade_peak
#define CUSTOM_SCENE_GRADE_METHOD              shader_injection.scene_grade_method
#define CUSTOM_SCENE_GRADE_PER_CHANNEL_BLOWOUT shader_injection.scene_grade_per_channel_blowout
#define CUSTOM_SCENE_GRADE_HUE_SHIFT           shader_injection.scene_grade_hue_shift
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                        shader_injection.custom_random
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_LENS_DIRT                     shader_injection.custom_lens_dirt
#define CUSTOM_FOG_DENSITY                   shader_injection.custom_fog_density

#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE  color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_DECODING           2.f // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
#define RENODX_INTERMEDIATE_ENCODING         2.f // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
#define RENODX_SWAP_CHAIN_ENCODING             renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float render_mode_setting;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float tone_map_per_channel;
  float white_clip;

  //float scene_grade_peak;
  float scene_grade_method;
  float scene_grade_per_channel_blowout;
  float scene_grade_hue_shift;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float custom_grading_strength;
  float hdr_boost;
  float custom_film_grain;
  float custom_random;
  float custom_bloom;
  float custom_lens_dirt;
  float custom_fog_density;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injectedBuffer : register(b13, space0) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injectedBuffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_ASSCREEDBLACKFLAG_SHARED_H_
