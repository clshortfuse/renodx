#ifndef SRC_EXPEDITION33_SHARED_H_
#define SRC_EXPEDITION33_SHARED_H_

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
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_per_channel;
  float scene_grade_saturation_correction;
  float scene_grade_blowout_restoration;
  float scene_grade_hue_correction;
  float custom_grain_type;
  float custom_grain_strength;
  float custom_random;
  float custom_enable_post_filmgrain;
  float custom_sharpness;
  float custom_lut_strength;
  float custom_lut_scaling;
  float custom_is_engine_hdr;
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
#define RENODX_TONE_MAP_PER_CHANNEL              shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_EXPOSURE                 shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS               shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                  shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                 shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION               shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION     shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                  shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                    shader_injection.tone_map_flare
#define RENODX_RENO_DRT_TONE_MAP_METHOD          renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE   color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING               renodx::draw::ENCODING_PQ
#define RENODX_TONE_MAP_HUE_SHIFT                0.f
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION      1.f
#define CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION   0.75f
#define CUSTOM_COLOR_GRADE_HUE_CORRECTION        shader_injection.scene_grade_hue_correction
#define CUSTOM_COLOR_GRADE_SATURATION_CORRECTION shader_injection.scene_grade_saturation_correction
#define CUSTOM_COLOR_GRADE_HUE_SHIFT             0.f
#define CUSTOM_GRAIN_TYPE                        0.f
#define CUSTOM_GRAIN_STRENGTH                    shader_injection.custom_grain_strength
#define CUSTOM_RANDOM                            shader_injection.custom_random
#define CUSTOM_ENABLE_POST_FILMGRAIN             shader_injection.custom_enable_post_filmgrain
#define CUSTOM_DICE_PEAK                         2.f
#define CUSTOM_DICE_SHOULDER                     0.5f
#define CUSTOM_SHARPNESS                         shader_injection.custom_sharpness
#define CUSTOM_UNREAL_HDR                        shader_injection.custom_is_engine_hdr
#define RENODX_GAMMA_CORRECTION_UI               1.f
#define RENODX_GAMMA_CORRECTION                  1.f
#define CUSTOM_LUT_STRENGTH                      1.f
#define CUSTOM_LUT_SCALING                       0.f
#define CUSTOM_IS_ENGINE_HDR                     shader_injection.custom_is_engine_hdr
#define OVERRIDE_BLACK_CLIP                      1.f  // 0 - Off, 1 - 0 nits
#define RENODX_TONE_MAP_HUE_CORRECTION_TYPE      1.f  // 0 - Highlights, Midtones, & Shadows; 1 - Midtones, & Shadows

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_EXPEDITION33_SHARED_H_
