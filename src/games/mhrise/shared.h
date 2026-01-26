#ifndef SRC_MHRISE_SHARED_H_
#define SRC_MHRISE_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float gamma_correction;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_adjust;
  float tone_map_per_channel_blowout_restoration;
  float tone_map_hue_shift;
  float tone_map_highlight_contrast;
  float tone_map_toe_adjustment_type;
  float tone_map_shadow_toe;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float color_grade_lut_strength;
  float color_grade_lut_scaling;

  float custom_sharpening;
  float custom_sharpening_strength;
  float custom_random;
  float custom_film_grain;

};

#ifndef __cplusplus
cbuffer injectedBuffer : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define TONE_MAP_TYPE                          shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_PER_CHANNEL_BLOWOUT_RESTORATION shader_injection.tone_map_per_channel_blowout_restoration
#define RENODX_TONE_MAP_HUE_SHIFT              shader_injection.tone_map_hue_shift
#define RENODX_GAMMA_CORRECTION                shader_injection.gamma_correction
#define RENODX_GAMMA_ADJUST                    shader_injection.gamma_adjust
#define RENODX_TONE_MAP_HIGHLIGHT_CONTRAST     shader_injection.tone_map_highlight_contrast
#define RENODX_TONE_MAP_TOE_ADJUSTMENT_TYPE    shader_injection.tone_map_toe_adjustment_type
#define RENODX_TONE_MAP_SHADOW_TOE             shader_injection.tone_map_shadow_toe

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define COLOR_GRADE_LUT_STRENGTH             shader_injection.color_grade_lut_strength
#define COLOR_GRADE_LUT_SCALING              shader_injection.color_grade_lut_scaling

#define CUSTOM_SHARPENING          shader_injection.custom_sharpening
#define CUSTOM_SHARPENING_STRENGTH shader_injection.custom_sharpening_strength
#define CUSTOM_RANDOM              shader_injection.custom_random
#define CUSTOM_FILM_GRAIN          shader_injection.custom_film_grain

#include "../../shaders/renodx.hlsl"

#endif


#endif  // SRC_MHRISE_SHARED_H_
