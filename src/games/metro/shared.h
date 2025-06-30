#ifndef SRC_METRO_SHARED_H_
#define SRC_METRO_SHARED_H_

#define RENODX_PEAK_WHITE_NITS               10000.f
#define RENODX_DIFFUSE_WHITE_NITS            80.f
#define RENODX_GRAPHICS_WHITE_NITS           80.f
//#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
//#define RENODX_RENO_DRT_WHITE_CLIP           shader_injection.tone_map_white_clip
#define RENODX_TONE_MAP_TYPE                 3 // 0 = Vanilla, 1 = None, 2 = ACES, 3 = RenoDRT
// #define RENODX_TONE_MAP_EXPOSURE             1.0f
// #define RENODX_TONE_MAP_HIGHLIGHTS           50.f * 0.02f
// #define RENODX_TONE_MAP_SHADOWS              50.f * 0.02f
// #define RENODX_TONE_MAP_CONTRAST             50.f * 0.02f
// #define RENODX_TONE_MAP_SATURATION           50.f * 0.02f
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 50.f * 0.02f
#define RENODX_TONE_MAP_BLOWOUT              (50.f * 0.01f)
// #define RENODX_TONE_MAP_FLARE                0.f
#define RENODX_TONE_MAP_HUE_CORRECTION       (100.f * 0.01f)
#define RENODX_TONE_MAP_HUE_SHIFT            (50.f * 0.01f)
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  1 //BT2020
#define RENODX_TONE_MAP_HUE_PROCESSOR        1 // 0 = OKLab, 1 = ICtCp
#define RENODX_TONE_MAP_PER_CHANNEL          1 // 0 = Off, 1 = On
#define RENODX_GAMMA_CORRECTION              1 // 0 = Off, 1 = 2.2, 2 = BT.1886
//#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.tone_map_color_grade_strength
//#define CUSTOM_COLOR_GRADE_TWO               shader_injection.custom_color_grade_two
// #define CUSTOM_FILM_GRAIN_STRENGTH           shader_injection.custom_film_grain_strength
// #define CUSTOM_RANDOM                        shader_injection.custom_random
// #define CUSTOM_BLOOM_STRENGTH                shader_injection.custom_bloom_strength
// #define CUSTOM_LENS_FLARE                    shader_injection.custom_lens_flare
// #define CUSTOM_LENS_DIRT                     shader_injection.custom_lens_dirt
// #define CUSTOM_ANTI_ALIASING                 shader_injection.custom_anti_aliasing

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_white_clip;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_working_color_space;
  float tone_map_hue_processor;
  float tone_map_per_channel;
  float gamma_correction;
  float tone_map_color_grade_strength;
  float custom_color_grading_two;
  float hue_correction_type;
  //float custom_color_grade_two;
  // float custom_film_grain_strength;
  // float custom_random;
  // float custom_bloom_strength;
  // float custom_lens_flare;
  // float custom_lens_dirt;
  // float custom_anti_aliasing;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_METRO_SHARED_H_
