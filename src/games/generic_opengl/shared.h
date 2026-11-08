#pragma once
// Derived from the generic addon's proxy constant-buffer convention.
struct ShaderInjectData {
  float peak_white;
  float paper_white;
  float input_encoding;
  float custom_flip_uv_y;
  float output_preset;
  float pad0, pad1, pad2;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#else
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}
#define RENODX_PEAK_WHITE_NITS shader_injection.peak_white
#define RENODX_DIFFUSE_WHITE_NITS shader_injection.paper_white
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.paper_white
#define RENODX_SWAP_CHAIN_SCALING_NITS shader_injection.paper_white
#define RENODX_SWAP_CHAIN_CLAMP_NITS shader_injection.peak_white
#define RENODX_SWAP_CHAIN_DECODING shader_injection.input_encoding
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION 0.f
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET shader_injection.output_preset
#include "../../shaders/renodx.hlsl"
#endif
