#ifndef SRC_KINGDOM_COME2_SHARED_H_
#define SRC_KINGDOM_COME2_SHARED_H_

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
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float fxBloom;
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
#define RENODX_DIFFUSE_WHITE_NITS                     shader_injection.diffuse_white_nits * 0.35f
#define RENODX_GRAPHICS_WHITE_NITS                    shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_EXPOSURE                      shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS                    shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                       shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                      shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION                    shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION          shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                       shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                         shader_injection.tone_map_flare
#define CUSTOM_BLOOM                                  shader_injection.fxBloom
#define RENODX_RENO_DRT_TONE_MAP_METHOD               renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET               renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_SCRGB
#define RENODX_INTERMEDIATE_ENCODING                  renodx::draw::GAMMA_CORRECTION_NONE
#define RENODX_GAMMA_CORRECTION                       renodx::draw::GAMMA_CORRECTION_GAMMA_2_2
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION           1.f
#define RENODX_RENO_DRT_WHITE_CLIP                    10.f
#define RENODX_TONE_MAP_CLAMP_PEAK                    -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK        -1
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE -1
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_KINGDOM_COME2_SHARED_H_