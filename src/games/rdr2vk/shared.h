#ifndef SRC_GAMES_RDR2VK_SHARED_H_
#define SRC_GAMES_RDR2VK_SHARED_H_

#define RENODX_TONE_MAP_TYPE shader_injection.tone_map_type

struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float sdr_eotf_emulation;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_flare;
  float tone_map_dechroma;
  float custom_lut_strength;
  float custom_vignette;
  float custom_dithering;
  float custom_random;
  float custom_grain_strength;
  float custom_unclamp_highlights;
  float tone_map_contrast_highlights;
  float tone_map_contrast_shadows;
  // Internal pass selection, never a user setting or a CPU-frame latch.
  float scene_brightness_enabled;
};

#ifdef __cplusplus
#include <cstddef>

static_assert(sizeof(ShaderInjectData) == 84u);
static_assert(offsetof(ShaderInjectData, scene_brightness_enabled) == 80u);
#else
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_SDR_EOTF_EMULATION            (RENODX_TONE_MAP_TYPE == 2.f ? 0.f : shader_injection.sdr_eotf_emulation)
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS  shader_injection.tone_map_contrast_highlights
#define RENODX_TONE_MAP_CONTRAST_SHADOWS     shader_injection.tone_map_contrast_shadows
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define CUSTOM_LUT_STRENGTH                  shader_injection.custom_lut_strength
#define CUSTOM_VIGNETTE                      shader_injection.custom_vignette
#define CUSTOM_DITHERING                     shader_injection.custom_dithering
#define CUSTOM_RANDOM                        shader_injection.custom_random
#define CUSTOM_GRAIN_STRENGTH                shader_injection.custom_grain_strength
#define UNCLAMP_HIGHLIGHTS                   shader_injection.custom_unclamp_highlights
#define RENODX_SCENE_BRIGHTNESS_ENABLED      shader_injection.scene_brightness_enabled

#ifdef __SLANG__
#ifdef RENODX_SHADER_INJECTION_UNIFORM
[[vk::binding(1, 0)]]
#else
[[vk::push_constant]]
#endif
ConstantBuffer<ShaderInjectData> shader_injection;

#define RENODX_SWAP_CHAIN_OUTPUT_PRESET        renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_HDR10
// The unedited SDR shaders and subsequent UI composition write encoded BT.709.
#define RENODX_GAMMA_CORRECTION                RENODX_SDR_EOTF_EMULATION
#define RENODX_INTERMEDIATE_ENCODING           renodx::draw::ENCODING_SRGB
#define RENODX_INTERMEDIATE_COLOR_SPACE        color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_DECODING             (RENODX_GAMMA_CORRECTION + 1.f)
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE RENODX_INTERMEDIATE_COLOR_SPACE
#define RENODX_SWAP_CHAIN_SCALING_NITS         RENODX_GRAPHICS_WHITE_NITS
#define RENODX_SWAP_CHAIN_CLAMP_NITS           9999.f
#define RENODX_SWAP_CHAIN_ENCODING             renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020

#include "../../shaders/renodx.hlsl"
#else
layout(push_constant) uniform PushData {
  ShaderInjectData shader_injection;
};
#endif
#endif

#endif  // SRC_GAMES_RDR2VK_SHARED_H_