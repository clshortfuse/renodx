#ifndef SRC_ROUTINE_SHARED_H_
#define SRC_ROUTINE_SHARED_H_

#define ENABLE_SLIDERS 1

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float override_black_clip;
  float tone_map_hue_processor;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float reno_drt_white_clip;
  float color_grade_color_space;

  float tone_map_hue_correction;
  float color_grade_saturation_correction;
  float color_grade_blowout_restoration;
  float color_grade_hue_shift;

  float custom_lut_strength;
  float custom_lut_scaling;
  float custom_lut_gamut_restoration;

  float custom_sharpening_type;
  float custom_sharpness;

  float tone_map_hue_correction_type;
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

#define RENODX_TONE_MAP_TYPE          shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS        shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS     shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS    shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION       1.f
#define RENODX_TONE_MAP_HUE_PROCESSOR shader_injection.tone_map_hue_processor
#define OVERRIDE_BLACK_CLIP           shader_injection.override_black_clip  // 0 - Off, 1 - 0 nits

#define RENODX_TONE_MAP_EXPOSURE                 shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS               shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                  shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                 shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION               shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION     shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                  shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                    shader_injection.tone_map_flare
#define RENODX_RENO_DRT_WHITE_CLIP               65.f
#define RENODX_TONE_MAP_HUE_CORRECTION           shader_injection.tone_map_hue_correction
#define CUSTOM_COLOR_GRADE_SATURATION_CORRECTION shader_injection.color_grade_saturation_correction
#define CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION   shader_injection.color_grade_blowout_restoration
#define CUSTOM_COLOR_GRADE_HUE_SHIFT             shader_injection.color_grade_hue_shift

#define CUSTOM_GRAIN_TYPE                   0.f
#define CUSTOM_GRAIN_STRENGTH               1.f
#define CUSTOM_RANDOM                       0.f
#define CUSTOM_SHARPENING_TYPE              shader_injection.custom_sharpening_type
#define CUSTOM_SHARPNESS                    shader_injection.custom_sharpness
#define CUSTOM_LUT_STRENGTH                 shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                  shader_injection.custom_lut_scaling
#define CUSTOM_LUT_GAMUT_RESTORATION        shader_injection.custom_lut_gamut_restoration
#define RENODX_TONE_MAP_HUE_CORRECTION_TYPE shader_injection.tone_map_hue_correction_type

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_ROUTINE_SHARED_H_
