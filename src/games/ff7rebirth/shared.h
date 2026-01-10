#ifndef SRC_FF7REBIRTH_SHARED_H_
#define SRC_FF7REBIRTH_SHARED_H_

// #define RENODX_PEAK_WHITE_NITS               1000.f
// #define RENODX_DIFFUSE_WHITE_NITS            250.f
// #define RENODX_GRAPHICS_WHITE_NITS           250.f
// #define RENODX_TONE_MAP_TYPE                 1.f  // 0 = ACES, 1 = RenoDRT
// #define RENODX_TONE_MAP_EXPOSURE             1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS           1.f
// #define RENODX_TONE_MAP_SHADOWS              1.f
// #define RENODX_TONE_MAP_CONTRAST             1.f
// #define RENODX_TONE_MAP_SATURATION           1.f
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
// #define RENODX_TONE_MAP_BLOWOUT              0.f
// #define RENODX_TONE_MAP_FLARE                0.f
// #define RENODX_TONE_MAP_HUE_SHIFT            0.5f
// #define RENODX_TONE_MAP_WORKING_COLOR_SPACE  2u
// #define RENODX_TONE_MAP_HUE_PROCESSOR        0u
// #define RENODX_TONE_MAP_PER_CHANNEL          0.f
// #define CUSTOM_LUT_STRENGTH                  1.f
// #define CUSTOM_HDR_VIDEOS                    1.f
// #define COLOR_GRADE_COLOR_SPACE              0.f

#define RENODX_PEAK_WHITE_NITS               shader_injection.tone_map_peak_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.tone_map_game_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.tone_map_ui_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type  // 0 = ACES, 1 = RenoDRT
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.color_grade_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.color_grade_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.color_grade_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.color_grade_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.color_grade_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.color_grade_blowout
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.color_grade_dechroma
#define RENODX_TONE_MAP_FLARE                shader_injection.color_grade_flare
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  2u
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define COLOR_GRADE_COLOR_SPACE              shader_injection.color_grade_color_space
#define CUSTOM_LUT_STRENGTH                  shader_injection.color_grade_lut_strength
#define CUSTOM_HDR_VIDEOS                    shader_injection.custom_hdr_videos
#define CUSTOM_FILM_GRAIN_STRENGTH           shader_injection.custom_film_grain_strength
#define CUSTOM_RANDOM                        shader_injection.random_1

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float tone_map_peak_nits;
  float tone_map_game_nits;
  float tone_map_ui_nits;
  float tone_map_hue_processor;
  float tone_map_hue_shift_method;
  float tone_map_hue_shift;
  float tone_map_per_channel;
  float color_grade_exposure;
  float color_grade_highlights;
  float color_grade_shadows;
  float color_grade_contrast;
  float color_grade_saturation;
  float color_grade_blowout;
  float color_grade_dechroma;
  float color_grade_color_space;
  float color_grade_flare;
  float color_grade_lut_strength;
  float custom_bloom;
  float custom_vignette;
  float custom_film_grain_strength;
  float custom_hdr_videos;
  float random_1;
  float random_2;
  float random_3;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b0, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_FF7REBIRTH_SHARED_H_
