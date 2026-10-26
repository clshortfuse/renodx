#ifndef SRC_GAMES_SCCT_SHARED_H_
#define SRC_GAMES_SCCT_SHARED_H_

// Splinter Cell: Chaos Theory (Unreal Engine 2.5, D3D9, SM3.0 path).
//
// Must be 32bit aligned. 4 x float4.
// The composite replacement is ps_3_0, which has c0-c223; the game's own composite uses no float
// constants, so the injection lives in c50-c53 (constant_buffer_offset = 50 * 4 in addon.cpp).
// Tone Mapper values: Vanilla 0, None 1 and RenoDRT 3 are the framework's types; Psycho-V is this
// mod's own.
#define SCCT_TONE_MAP_TYPE_PSYCHO_V 4.f
// Shadows at 100. Both tone mappers lift dark values by adding c * x^(2 - shadows); at 2 that is a
// flat floor under everything above black (blotches, near-black colours blown up), so the slider
// stops at 1.75.
#define SCCT_SHADOWS_MAX 1.75f

struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;

  float gamma_correction;
  float hue_correction;  // strength toward vanilla's (clipped) hue: 0 = off, 1 = vanilla hue
  float saturation;      // 1 = vanilla
  float bloom;           // 1 = vanilla

  float tone_map_exposure;    // 1 = vanilla
  float tone_map_highlights;  // 1 = neutral
  float tone_map_shadows;     // 1 = neutral
  float tone_map_contrast;    // 1 = neutral

  // Computed by the add-on each frame from Peak / Game Brightness: the Psycho-V shadows and
  // highlights that put it on vanilla below white. The sliders apply on top.
  float psycho_shadows_match;
  float psycho_highlights_match;
  float swap_chain_output_preset;  // set by the add-on from Output Mode and HDR Format
  float padding0;
};

#ifndef __cplusplus

#if (__SHADER_TARGET_MAJOR == 3)

float4 shader_injection[4] : register(c50);

#define RENODX_PEAK_WHITE_NITS          shader_injection[0][0]
#define RENODX_DIFFUSE_WHITE_NITS       shader_injection[0][1]
#define RENODX_GRAPHICS_WHITE_NITS      shader_injection[0][2]
#define RENODX_TONE_MAP_TYPE            shader_injection[0][3]
#define RENODX_GAMMA_CORRECTION         shader_injection[1][0]
#define SCCT_HUE_CORRECTION             shader_injection[1][1]
#define RENODX_TONE_MAP_SATURATION      shader_injection[1][2]
#define SCCT_BLOOM                      shader_injection[1][3]
#define RENODX_TONE_MAP_EXPOSURE        shader_injection[2][0]
#define RENODX_TONE_MAP_HIGHLIGHTS      shader_injection[2][1]
#define RENODX_TONE_MAP_SHADOWS         shader_injection[2][2]
#define RENODX_TONE_MAP_CONTRAST        shader_injection[2][3]
#define SCCT_PSYCHO_SHADOWS_MATCH       shader_injection[3][0]
#define SCCT_PSYCHO_HIGHLIGHTS_MATCH    shader_injection[3][1]
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET shader_injection[3][2]

#else

#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#else
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#endif

#define RENODX_PEAK_WHITE_NITS          shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS       shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS      shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE            shader_injection.tone_map_type
#define RENODX_GAMMA_CORRECTION         shader_injection.gamma_correction
#define SCCT_HUE_CORRECTION             shader_injection.hue_correction
#define RENODX_TONE_MAP_SATURATION      shader_injection.saturation
#define SCCT_BLOOM                      shader_injection.bloom
#define RENODX_TONE_MAP_EXPOSURE        shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS      shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS         shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST        shader_injection.tone_map_contrast
#define SCCT_PSYCHO_SHADOWS_MATCH       shader_injection.psycho_shadows_match
#define SCCT_PSYCHO_HIGHLIGHTS_MATCH    shader_injection.psycho_highlights_match
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET shader_injection.swap_chain_output_preset

#endif

// Output: the HDR10 and SDR presets set their own encoding; scRGB uses no preset, so SwapChainPass
// keeps its defaults (scRGB, BT.709, no clamp or gamut compression).

#include "../../shaders/renodx.hlsl"

#endif  // __cplusplus

#endif  // SRC_GAMES_SCCT_SHARED_H_
