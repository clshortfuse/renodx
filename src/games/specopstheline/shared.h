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

  float tone_map_clamp_color_space;
  float tone_map_clamp_peak;
  float tone_map_hue_processor;
  float tone_map_per_channel;

  float gamma_correction;
  float custom_light_shafts;
  float custom_chromatic_aberration;
  float custom_lens_flare;

  float swap_chain_custom_color_space;
  float custom_vignette;
  float custom_dof;
  float custom_bloom;

  float custom_film_grain;
  float custom_random;
  float padding1;
  float padding2;
};

#ifndef __cplusplus
#if (__SHADER_TARGET_MAJOR == 3)

float4 shader_injection[8] : register(c50);

#define RENODX_PEAK_WHITE_NITS                 shader_injection[0][0]
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection[0][1]
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection[0][2]
#define RENODX_COLOR_GRADE_STRENGTH            shader_injection[0][3]
#define RENODX_TONE_MAP_TYPE                   shader_injection[1][0]
#define RENODX_TONE_MAP_EXPOSURE               shader_injection[1][1]
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection[1][2]
#define RENODX_TONE_MAP_SHADOWS                shader_injection[1][3]
#define RENODX_TONE_MAP_CONTRAST               shader_injection[2][0]
#define RENODX_TONE_MAP_SATURATION             shader_injection[2][1]
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection[2][2]
#define RENODX_TONE_MAP_BLOWOUT                shader_injection[2][3]
#define RENODX_TONE_MAP_FLARE                  shader_injection[3][0]
#define RENODX_TONE_MAP_HUE_CORRECTION         shader_injection[3][1]
#define RENODX_TONE_MAP_HUE_SHIFT              shader_injection[3][2]
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE    shader_injection[3][3]
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      shader_injection[4][0]
#define RENODX_TONE_MAP_CLAMP_PEAK             shader_injection[4][1]
#define RENODX_TONE_MAP_HUE_PROCESSOR          shader_injection[4][2]
#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection[4][3]
#define RENODX_GAMMA_CORRECTION                shader_injection[5][0]
#define CUSTOM_LIGHT_SHAFTS                    shader_injection[5][1]
#define CUSTOM_CHROMATIC_ABBERATION            shader_injection[5][2]
#define CUSTOM_LENS_FLARE                      shader_injection[5][3]
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection[6][0]
#define CUSTOM_VIGNETTE                        shader_injection[6][1]
#define CUSTOM_DOF                             shader_injection[6][2]
#define CUSTOM_BLOOM                           shader_injection[6][3]
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection[7][0]
#define CUSTOM_RANDOM                          shader_injection[7][1]

#define RENODX_RENO_DRT_TONE_MAP_METHOD renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#else
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_COLOR_GRADE_STRENGTH            shader_injection.color_grade_strength
#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type
#define RENODX_GAMMA_CORRECTION                shader_injection.gamma_correction
#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE    shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR          shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION         shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT              shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      shader_injection.tone_map_clamp_color_space
#define RENODX_TONE_MAP_CLAMP_PEAK             shader_injection.tone_map_clamp_peak
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
#define CUSTOM_LIGHT_SHAFTS                    shader_injection.custom_light_shafts
#define CUSTOM_CHROMATIC_ABBERATION            shader_injection.custom_chromatic_aberration
#define CUSTOM_LENS_FLARE                      shader_injection.custom_lens_flare
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection.swap_chain_custom_color_space
#define CUSTOM_VIGNETTE                        shader_injection.custom_vignette
#define CUSTOM_DOF                             shader_injection.custom_dof
#define CUSTOM_BLOOM                           shader_injection.custom_bloom
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                          shader_injection.custom_random
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#endif

#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
