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
  float tone_map_white_clip;
  float tone_map_hue_processor;
  float gamma_correction;
  float custom_hue_shift;
  float custom_random;
  float custom_grain_strength;
  float custom_bloom;
  float custom_hero_light;
  float custom_blur_fix;
  float custom_hdr_videos;
  float custom_vignette;
  float custom_saturation_clip;
  float custom_bloom_clip;
  float custom_hue_clip;
  float swap_chain_output_preset;
  float swap_chain_output_dither_bits;
  float swap_chain_output_dither_seed;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                          shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                        shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS                     shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS                    shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION                       shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_PROCESSOR                 shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_EXPOSURE                      shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS                    shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                       shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                      shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION                    shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION          shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                       shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                         shader_injection.tone_map_flare
#define RENODX_TONE_MAP_CLAMP_PEAK                    -1.f
#define RENODX_COLOR_GRADE_STRENGTH                   shader_injection.color_grade_strength
#define RENODX_RENO_DRT_TONE_MAP_METHOD               renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_TONE_MAP_HUE_CORRECTION                0.f
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET               shader_injection.swap_chain_output_preset
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_BITS          shader_injection.swap_chain_output_dither_bits
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_SEED          shader_injection.swap_chain_output_dither_seed
#define RENODX_RENO_DRT_WHITE_CLIP                    shader_injection.tone_map_white_clip
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK        -1
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE -1
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define CUSTOM_GRAIN_STRENGTH                         shader_injection.custom_grain_strength
#define CUSTOM_BLOOM                                  shader_injection.custom_bloom
#define CUSTOM_RANDOM                                 shader_injection.custom_random
#define CUSTOM_HERO_LIGHT                             shader_injection.custom_hero_light
#define CUSTOM_BLUR_FIX                               shader_injection.custom_blur_fix
#define CUSTOM_HDR_VIDEOS                             shader_injection.custom_hdr_videos
#define CUSTOM_VIGNETTE                               shader_injection.custom_vignette
#define CUSTOM_SATURATION_CLIP                        shader_injection.custom_saturation_clip
#define CUSTOM_BLOOM_CLIP                             shader_injection.custom_bloom_clip
#define CUSTOM_HUE_CLIP                               shader_injection.custom_hue_clip

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
