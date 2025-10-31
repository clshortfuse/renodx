#ifndef SRC_SMASH_BROS_ULTIMATE_SHARED_H_
#define SRC_SMASH_BROS_ULTIMATE_SHARED_H_

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

  float gamma_correction;
  float custom_bloom;
  float custom_dof;
  float swap_chain_output_dither_bits;

  float swap_chain_output_dither_seed;
};

#define RENODX_PEAK_WHITE_NITS                        shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS                     shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS                    shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                          shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE                      shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS                    shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                       shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                      shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION                    shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION          shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                       shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                         shader_injection.tone_map_flare
#define RENODX_RENO_DRT_WHITE_CLIP                    100.f
#define RENODX_RENO_DRT_TONE_MAP_METHOD               renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK        -1.0f
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE -1.0f
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET               SWAP_CHAIN_OUTPUT_PRESET_SCRGB
#define RENODX_GAMMA_CORRECTION                       shader_injection.gamma_correction
#define CUSTOM_BLOOM                                  shader_injection.custom_bloom
#define CUSTOM_DOF                                    shader_injection.custom_dof
#define RENODX_INTERMEDIATE_ENCODING                  renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_DECODING                    renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION            RENODX_GAMMA_CORRECTION
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION           1.f

#ifndef __cplusplus
#ifdef __SLANG__
layout(push_constant) uniform PushData {
  ShaderInjectData shader_injection;
}
#else
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injected_buffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injected_buffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}
#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_SMASH_BROS_ULTIMATE_SHARED_H_
