#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

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
  float gamma_correction;
  float scene_grade_strength;
  float scene_grade_hue_correction;
  float scene_grade_saturation_correction;
  float scene_grade_blowout_restoration;
  float scene_grade_hue_shift;
  float custom_auto_exposure;
  float custom_bloom;
  float custom_lut_optimization;
  float custom_chromatic_aberration;
  float custom_eye_adaptation;
  float custom_hdr_videos;
  float custom_grain_type;
  float custom_grain_strength;
  float custom_random;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                     shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                   shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS                shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS               shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION                  shader_injection.gamma_correction
#define RENODX_TONE_MAP_EXPOSURE                 shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS               shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                  shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                 shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION               shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION     shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                  shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                    shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH              shader_injection.scene_grade_strength
#define RENODX_RENO_DRT_TONE_MAP_METHOD          renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE   color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING               ENCODING_PQ
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION      1.f
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE      color::convert::COLOR_SPACE_AP1
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE        -1.f
#define CUSTOM_BLOOM                             shader_injection.custom_bloom
#define CUSTOM_AUTO_EXPOSURE                     shader_injection.custom_auto_exposure
#define CUSTOM_LUT_OPTIMIZATION                  shader_injection.custom_lut_optimization
#define CUSTOM_CHROMATIC_ABERRATION              shader_injection.custom_chromatic_aberration
#define CUSTOM_HDR_VIDEOS                        shader_injection.custom_hdr_videos
#define CUSTOM_EYE_ADAPTATION                    shader_injection.custom_eye_adaptation
#define CUSTOM_SCENE_GRADE_HUE_CORRECTION        shader_injection.scene_grade_hue_correction
#define CUSTOM_SCENE_GRADE_SATURATION_CORRECTION shader_injection.scene_grade_saturation_correction
#define CUSTOM_SCENE_GRADE_BLOWOUT_RESTORATION   shader_injection.scene_grade_blowout_restoration
#define CUSTOM_SCENE_GRADE_HUE_SHIFT             shader_injection.scene_grade_hue_shift
#define CUSTOM_GRAIN_TYPE                        shader_injection.custom_grain_type
#define CUSTOM_GRAIN_STRENGTH                    shader_injection.custom_grain_strength
#define CUSTOM_RANDOM                            shader_injection.custom_random

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
