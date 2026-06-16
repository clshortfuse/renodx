#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

// #define RENODX_PEAK_WHITE_NITS                 1000.f
// #define RENODX_DIFFUSE_WHITE_NITS              renodx::color::bt2408::REFERENCE_WHITE
// #define RENODX_GRAPHICS_WHITE_NITS             renodx::color::bt2408::GRAPHICS_WHITE
// #define RENODX_COLOR_GRADE_STRENGTH            1.f
// #define RENODX_TONE_MAP_TYPE                   TONE_MAP_TYPE_RENO_DRT
// #define RENODX_TONE_MAP_EXPOSURE               1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS             1.f
// #define RENODX_TONE_MAP_SHADOWS                1.f
// #define RENODX_TONE_MAP_CONTRAST               1.f
// #define RENODX_TONE_MAP_SATURATION             1.f
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   1.f
// #define RENODX_TONE_MAP_BLOWOUT                0
// #define RENODX_TONE_MAP_FLARE                  0
// #define RENODX_TONE_MAP_HUE_CORRECTION         1.f
// #define RENODX_TONE_MAP_HUE_SHIFT              0
// #define RENODX_TONE_MAP_WORKING_COLOR_SPACE    color::convert::COLOR_SPACE_BT709
// #define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      color::convert::COLOR_SPACE_NONE
// #define RENODX_TONE_MAP_CLAMP_PEAK             color::convert::COLOR_SPACE_BT709
// #define RENODX_TONE_MAP_HUE_PROCESSOR          HUE_PROCESSOR_OKLAB
// #define RENODX_TONE_MAP_PER_CHANNEL            0
// #define RENODX_GAMMA_CORRECTION                GAMMA_CORRECTION_GAMMA_2_2
// #define RENODX_INTERMEDIATE_SCALING            (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS)
// #define RENODX_INTERMEDIATE_ENCODING           (RENODX_GAMMA_CORRECTION + 1.f)
// #define RENODX_INTERMEDIATE_COLOR_SPACE        color::convert::COLOR_SPACE_BT709
// #define RENODX_SWAP_CHAIN_DECODING             RENODX_INTERMEDIATE_ENCODING
// #define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE RENODX_INTERMEDIATE_COLOR_SPACE
// #define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   COLOR_SPACE_CUSTOM_BT709D65
// #define RENODX_SWAP_CHAIN_SCALING_NITS         RENODX_GRAPHICS_WHITE_NITS
// #define RENODX_SWAP_CHAIN_CLAMP_NITS           RENODX_PEAK_WHITE_NITS
// #define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_UNKNOWN
// #define RENODX_SWAP_CHAIN_ENCODING             ENCODING_SCRGB
// #define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float color_grade_strength;
  float color_grade_hue_correction;
  float color_grade_saturation_correction;
  float color_grade_blowout_restoration;
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
  float tone_map_white_clip;
  float tone_map_hue_processor;
  float gamma_correction;
  float custom_lens_distortion;
  float custom_bloom;
  float custom_chromatic_aberration;
  float custom_sun_bloom;
  float custom_film_grain;
  float custom_dithering;
  // float custom_light_streaks;
  float custom_lens_flare;
  float custom_corona;
  float custom_vignette;
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
#define RENODX_RENO_DRT_WHITE_CLIP               shader_injection.tone_map_white_clip
#define RENODX_TONE_MAP_HUE_PROCESSOR            shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_EXPOSURE                 shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS               shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                  shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                 shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION               shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION     shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                  shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                    shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH              shader_injection.color_grade_strength
#define CUSTOM_LENS_DISTORTION                   shader_injection.custom_lens_distortion
#define CUSTOM_FILM_GRAIN                        shader_injection.custom_film_grain
#define CUSTOM_DITHERING                         shader_injection.custom_dithering
#define CUSTOM_LENS_FLARE                        shader_injection.custom_lens_flare
#define CUSTOM_LIGHT_STREAKS                     1.f
#define CUSTOM_CORONA                            shader_injection.custom_corona
#define CUSTOM_BLOOM                             shader_injection.custom_bloom
#define CUSTOM_RANDOM                            shader_injection.custom_random
#define CUSTOM_SUN_BLOOM                         shader_injection.custom_sun_bloom
#define CUSTOM_VIGNETTE                          shader_injection.custom_vignette
#define CUSTOM_CHROMATIC_ABERRATION              shader_injection.custom_chromatic_aberration
#define CUSTOM_COLOR_GRADE_HUE_CORRECTION        shader_injection.color_grade_hue_correction
#define CUSTOM_COLOR_GRADE_SATURATION_CORRECTION shader_injection.color_grade_saturation_correction
#define CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION   shader_injection.color_grade_blowout_restoration
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE      color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING               renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE   color::convert::COLOR_SPACE_BT2020
#define RENODX_RENO_DRT_TONE_MAP_METHOD          renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
