#ifndef SRC_ASSCREEDORIGINS_ODYSSEY_SHARED_H_
#define SRC_ASSCREEDORIGINS_ODYSSEY_SHARED_H_

#define RENODX_GAME_GAMMA_CORRECTION 1u

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float tone_map_peak_nits;
  float tone_map_game_nits;
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

  float custom_color_filter_strength;

  float exposure_compensation;
  float contrast_compensation;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE           shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS         shader_injection.tone_map_peak_nits
#define RENODX_DIFFUSE_WHITE_NITS      shader_injection.tone_map_game_nits
#define RENODX_TONE_MAP_HUE_CORRECTION shader_injection.tone_map_hue_correction

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define CUSTOM_COLOR_FILTER_STRENGTH         shader_injection.custom_color_filter_strength

#define CUSTOM_EXPOSURE_COMPENSATION shader_injection.exposure_compensation
#define CUSTOM_CONTRAST_COMPENSATION shader_injection.contrast_compensation

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_ASSCREEDORIGINS_ODYSSEY_SHARED_H_
