#ifndef SRC_MHWILDS_SHARED_H_
#define SRC_MHWILDS_SHARED_H_

#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_PER_CHANNEL            0.f  // shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
#define RENODX_SWAP_CHAIN_DECODING             renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     renodx::draw::GAMMA_CORRECTION_NONE
//#define RENODX_SWAP_CHAIN_SCALING_NITS         100.f * RENODX_DIFFUSE_WHITE_NITS / 203.f
#define RENODX_SWAP_CHAIN_SCALING_NITS         RENODX_DIFFUSE_WHITE_NITS
#define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING             renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_SEED   shader_injection.swap_chain_output_dither_seed
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_BITS   shader_injection.swap_chain_output_dither_bits
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_WHITE_CLIP             100.f
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                          shader_injection.custom_random
#define CUSTOM_VIGNETTE                        shader_injection.custom_vignette
#define CUSTOM_LENS_DISTORTION                 shader_injection.custom_lens_distortion
#define CUSTOM_LUT_COLOR_STRENGTH              shader_injection.custom_lut_color_strength
#define CUSTOM_ABERRATION                      1.f
//#define CUSTOM_EXPOSURE_TYPE                   shader_injection.custom_exposure_type

#define CUSTOM_LOCAL_EXPOSURE_HIGHLIGHTS       shader_injection.custom_local_exposure_highlights
#define CUSTOM_LOCAL_EXPOSURE_SHADOWS          shader_injection.custom_local_exposure_shadows
#define CUSTOM_LOCAL_EXPOSURE_DETAIL           shader_injection.custom_local_exposure_detail
#define CUSTOM_LOCAL_EXPOSURE_MID_GREY         shader_injection.custom_local_exposure_mid_grey

#define CUSTOM_EXPOSURE_STRENGTH               shader_injection.custom_exposure_strength
#define CUSTOM_FLAT_EXPOSURE_DEFAULT           1.f
#define CUSTOM_LUT_EXPOSURE_REVERSE            shader_injection.custom_lut_exposure_reverse
#define CUSTOM_EXPOSURE_SHADER_DRAW            shader_injection.custom_exposure_shader_draw
#define CUSTOM_TONE_MAP_PARAMETERS             shader_injection.custom_tone_map_parameters
#define CUSTOM_SHARPNESS                       shader_injection.custom_sharpness
#define CUSTOM_FOG_AMOUNT                      shader_injection.custom_fog_amount
#define CUSTOM_LUT_SCALING                     shader_injection.custom_lut_scaling
#define CUSTOM_SATURATION_CORRECTION           shader_injection.custom_saturation_correction

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
  float swap_chain_custom_color_space;
  float custom_lut_color_strength;
  float custom_film_grain;
  float custom_vignette;
  float custom_lens_distortion;
  float custom_random;
  //float custom_exposure_type;
  float custom_local_exposure_highlights;
  float custom_local_exposure_shadows;
  float custom_local_exposure_detail;
  float custom_local_exposure_mid_grey;
  float custom_exposure_strength;
  float custom_lut_exposure_reverse;
  float custom_exposure_shader_draw;
  float custom_tone_map_parameters;
  float custom_sharpness;
  float custom_fog_amount;
  float custom_lut_scaling;
  float custom_saturation_correction;
  float swap_chain_output_dither_seed;
  float swap_chain_output_dither_bits;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injectedBuffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injectedBuffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_MHWILDS_SHARED_H_
