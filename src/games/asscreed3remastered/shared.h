#ifndef SRC_GAMES_ASSCREED3REMASTERED_SHARED_H_
#define SRC_GAMES_ASSCREED3REMASTERED_SHARED_H_

#define RENODX_GAME_GAMMA_CORRECTION 1u

// Must stay 32-bit aligned for shader constant-buffer injection.
struct ShaderInjectData {
  float tone_map_type;
  float tone_map_peak_nits;
  float tone_map_game_nits;
  float tone_map_ui_nits;

  float tone_map_hue_correction;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;

  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;

  float tone_map_flare;
  float custom_color_filter_strength;
  float exposure_compensation;
  float contrast_compensation;

  float custom_film_grain_type;
  float custom_film_grain_strength;
  float custom_random;
  float custom_rcas_strength;
  float custom_chromatic_aberration_type;
  float custom_chromatic_aberration_strength;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE           shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS         shader_injection.tone_map_peak_nits
#define RENODX_DIFFUSE_WHITE_NITS      shader_injection.tone_map_game_nits
#define RENODX_GRAPHICS_WHITE_NITS     shader_injection.tone_map_ui_nits
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
#define CUSTOM_FILM_GRAIN_TYPE       shader_injection.custom_film_grain_type
#define CUSTOM_FILM_GRAIN_STRENGTH   shader_injection.custom_film_grain_strength
#define CUSTOM_RANDOM                shader_injection.custom_random
#define CUSTOM_RCAS_STRENGTH         shader_injection.custom_rcas_strength
#define CUSTOM_CHROMATIC_ABERRATION_TYPE shader_injection.custom_chromatic_aberration_type
#define CUSTOM_CHROMATIC_ABERRATION_STRENGTH shader_injection.custom_chromatic_aberration_strength

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_GAMES_ASSCREED3REMASTERED_SHARED_H_
