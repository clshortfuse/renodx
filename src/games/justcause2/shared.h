#ifndef SRC_GAMES_JUSTCAUSE2_SHARED_H_
#define SRC_GAMES_JUSTCAUSE2_SHARED_H_

struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float output_mode;
  float tone_map_type;
  float exposure;
  float saturation;
  float contrast;
  float swap_chain_output_preset;
  float resource_upgrade;
  float reserved0;
  float reserved1;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS             shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS          shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS         shader_injection.graphics_white_nits
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET    shader_injection.swap_chain_output_preset
#define RENODX_SWAP_CHAIN_DECODING         renodx::draw::ENCODING_SRGB
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION 0.f
#include "../../shaders/renodx.hlsl"
#endif

#endif
