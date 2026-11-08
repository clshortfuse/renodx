#ifndef SRC_GAMES_GEARSOFWARREDUX_SHARED_H_
#define SRC_GAMES_GEARSOFWARREDUX_SHARED_H_

#define GEARS_TONE_MAP_VANILLA 0.f
#define GEARS_TONE_MAP_SIMPLE 1.f
#define GEARS_TONE_MAP_RENODRT 3.f
#define GEARS_TONE_MAP_PSYCHOV30 30.f
#define GEARS_TONE_MAP_PRISM 31.f
#define GEARS_INJECTION_LAYOUT_VERSION 4.f

// Five complete float4 registers, shared by the addon and D3D11 b13.
struct ShaderInjectData {
  float layout_version;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_contrast;
  float tone_map_saturation;
  float psychov_cone_response;
  float psychov_gamut_compression;
  float psychov_compression;
  float padding1;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float color_grade_strength;
  float dlss_linear;
  float swap_chain_output_preset;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_CONTRAST shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHTS shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH shader_injection.color_grade_strength
#define RENODX_GAMMA_CORRECTION renodx::draw::GAMMA_CORRECTION_NONE
#define RENODX_INTERMEDIATE_ENCODING renodx::draw::ENCODING_GAMMA_2_2
#define RENODX_SWAP_CHAIN_DECODING renodx::draw::ENCODING_GAMMA_2_2
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET shader_injection.swap_chain_output_preset
#define RENODX_RENO_DRT_TONE_MAP_METHOD renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_GAMES_GEARSOFWARREDUX_SHARED_H_
