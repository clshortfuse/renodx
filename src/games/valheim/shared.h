#ifndef SRC_VALHEIM_SHARED_H_
#define SRC_VALHEIM_SHARED_H_

#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_RENO_DRT_HIIGHLIGHT

#define RENODX_RENDER_MODE                   shader_injection.render_mode_setting
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define CUSTOM_TONE_MAP_CONFIGURATION        shader_injection.custom_tone_map_configuration
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
//#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR        0.f
#define RENODX_TONE_MAP_HUE_SHIFT            0.f
#define RENODX_TONE_MAP_HUE_CORRECTION       100.f * 0.01f
#define RENODX_TONE_MAP_PER_CHANNEL          0.f
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE  color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_DECODING           0
#define RENODX_INTERMEDIATE_ENCODING         0
#define CUSTOM_LUT_STRENGTH                  shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                   shader_injection.custom_lut_scaling
#define CUSTOM_LUT_TETRAHEDRAL               1.f
// #define CUSTOM_SCENE_GRADE_METHOD              shader_injection.scene_grade_method
// #define CUSTOM_SCENE_GRADE_HUE_CORRECTION      shader_injection.scene_grade_hue_correction
// #define CUSTOM_SCENE_GRADE_SATURATION_CORRECTION shader_injection.scene_grade_saturation_correction
// #define CUSTOM_SCENE_GRADE_BLOWOUT_RESTORATION shader_injection.scene_grade_blowout_restoration
// #define CUSTOM_SCENE_GRADE_HUE_SHIFT           shader_injection.scene_grade_hue_shift
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                   shader_injection.custom_random
#define CUSTOM_CHROMATIC_ABERRATION          shader_injection.custom_chromatic_aberration
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_SUN_SHAFTS                    shader_injection.custom_sun_shafts
#define CUSTOM_LENS_DIRT                     shader_injection.custom_lens_dirt

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float render_mode_setting;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float custom_tone_map_configuration;
  float gamma_correction;
  // float scene_grade_method;
  // float scene_grade_hue_correction;
  // float scene_grade_saturation_correction;
  // float scene_grade_blowout_restoration;
  // float scene_grade_hue_shift;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float custom_lut_strength;
  float custom_lut_scaling;
  //float tone_map_hue_processor;
  float custom_chromatic_aberration;
  float custom_bloom;
  float custom_sun_shafts;
  float custom_lens_dirt;
  float custom_film_grain;
  float custom_random;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_VALHEIM_SHARED_H_
