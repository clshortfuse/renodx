#ifndef SRC_DYING_LIGHT_SHARED_H_
#define SRC_DYING_LIGHT_SHARED_H_

#define ORIGINAL_THRESHOLD   0.999985337
#define SUN_SIZE             5.5
#define SUN_THRESHOLD        (cos(acos(ORIGINAL_THRESHOLD) * SUN_SIZE))
#define SUN_SHIFT_X          0.0185
#define SUN_SHIFT_Y          -0.0125
#define SUN_BRIGHTNESS_BOOST 3.0  // 3x brighter sun

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float tone_map_hue_correction;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float scene_grade_strength;
  float color_grade_gamut_expansion;
  float custom_bloom;
  float custom_lens_flare;
  float custom_lens_flare_2;
  float custom_grain_strength;

  float unclamp_lighting;
  float improved_sun;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.scene_grade_strength
#define RENODX_COLOR_GRADE_GAMUT_EXPANSION   shader_injection.color_grade_gamut_expansion
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_LENS_FLARE                    shader_injection.custom_lens_flare
#define CUSTOM_LENS_FLARE_2                  shader_injection.custom_lens_flare_2
#define CUSTOM_GRAIN_STRENGTH                shader_injection.custom_grain_strength
#define CUSTOM_UNCLAMP_LIGHTING              shader_injection.unclamp_lighting
#define CUSTOM_IMPROVED_SUN                  shader_injection.improved_sun

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_DYING_LIGHT_SHARED_H_
