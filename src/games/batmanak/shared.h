#ifndef SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_
#define SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT            0
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  0
#define RENODX_TONE_MAP_HUE_PROCESSOR        0
#define RENODX_TONE_MAP_PER_CHANNEL          0
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define CUSTOM_TONE_MAP_STRATEGY             shader_injection.custom_tone_map_strategy
#define CUSTOM_LUT_STRENGTH                  shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                   0
#define CUSTOM_LUT_TETRAHEDRAL               shader_injection.custom_lut_tetrahedral
#define CUSTOM_LENS_FLARE                    shader_injection.custom_lens_flare
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_VIGNETTE                      shader_injection.custom_vignette
#define CUSTOM_FILM_GRAIN_TYPE               shader_injection.custom_film_grain_type
#define CUSTOM_FILM_GRAIN_STRENGTH           shader_injection.custom_film_grain_strength
#define CUSTOM_HAS_DRAWN_MENU                shader_injection.custom_has_drawn_menu

#define RENODX_RENO_DRT_TONE_MAP_METHOD               renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK        -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP        20.f

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
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_hue_correction;
  float gamma_correction;
  float custom_tone_map_strategy;
  float custom_lut_strength;
  float custom_lut_tetrahedral;
  float custom_lens_flare;
  float custom_bloom;
  float custom_vignette;
  float custom_film_grain_type;
  float custom_film_grain_strength;
  float custom_has_drawn_menu;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_
