#ifndef SRC_CODBLOPS_SHARED_H_
#define SRC_CODBLOPS_SHARED_H_

// Tone mapper IDs used by Addon.cpp and HLSL.
#define RENODX_TONE_MAP_TYPE_VANILLA   0.f
#define RENODX_TONE_MAP_TYPE_RENODRT   3.f
#define RENODX_TONE_MAP_TYPE_PSYCHOV22 22.f

// Must be 32-bit aligned.
// Keep the original first 32 float layout stable for the DX9/ps_3_0 c50-c57 path.
// New PsychoV22 controls are appended at c58, not inserted in the middle.
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
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_working_color_space;

  float tone_map_clamp_color_space;
  float tone_map_clamp_peak;
  float tone_map_hue_processor;
  float tone_map_per_channel;

  float gamma_correction;
  float intermediate_scaling;
  float intermediate_encoding;
  float intermediate_color_space;

  float swap_chain_decoding;
  float swap_chain_gamma_correction;
  // float swap_chain_decoding_color_space;
  float swap_chain_custom_color_space;
  // float swap_chain_scaling_nits;
  // float swap_chain_clamp_nits;
  float swap_chain_clamp_color_space;

  float swap_chain_encoding;
  float swap_chain_encoding_color_space;
  float padding1;
  float padding2;

  // Existing extra value used by the swapchain proxy path.
  // This stays at c58.x / float index 32.
  float custom_flip_uv_y;

  // PsychoV22 controls.
  // These are appended so old settings do not move.
  float psychov22_compression;
  float psychov22_gamut_compression;
  float psychov22_gamut_mode;

  // c59
  float psychov22_cone_response;  // x
  float bloom_brightness;         // y
  float bloom_flare_size;         // z
  float hdr_boost;                // w
};

#ifndef __cplusplus

#if (__SHADER_TARGET_MAJOR == 3)

// DX9/SM3 path.
// c50-c57 preserve the original layout.
// c58 adds custom_flip_uv_y plus the first PsychoV22 controls.
// c59 adds PsychoV22 cone response, bloom controls, and HDR Boost.
float4 shader_injection[10] : register(c50);

#define RENODX_PEAK_WHITE_NITS                 shader_injection[0][0]
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection[0][1]
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection[0][2]
#define RENODX_COLOR_GRADE_STRENGTH            shader_injection[0][3]

#define RENODX_TONE_MAP_TYPE                   shader_injection[1][0]
#define RENODX_TONE_MAP_EXPOSURE               shader_injection[1][1]
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection[1][2]
#define RENODX_TONE_MAP_SHADOWS                shader_injection[1][3]

#define RENODX_TONE_MAP_CONTRAST               shader_injection[2][0]
#define RENODX_TONE_MAP_SATURATION             shader_injection[2][1]
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection[2][2]
#define RENODX_TONE_MAP_BLOWOUT                shader_injection[2][3]

#define RENODX_TONE_MAP_FLARE                  shader_injection[3][0]
#define RENODX_TONE_MAP_HUE_CORRECTION         shader_injection[3][1]
#define RENODX_TONE_MAP_HUE_SHIFT              shader_injection[3][2]
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE    shader_injection[3][3]

#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      shader_injection[4][0]
#define RENODX_TONE_MAP_CLAMP_PEAK             shader_injection[4][1]
#define RENODX_TONE_MAP_HUE_PROCESSOR          shader_injection[4][2]
#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection[4][3]

#define RENODX_GAMMA_CORRECTION                shader_injection[5][0]
// #define RENODX_INTERMEDIATE_SCALING          shader_injection[5][1]
#define RENODX_INTERMEDIATE_ENCODING           shader_injection[5][2]
#define RENODX_INTERMEDIATE_COLOR_SPACE        shader_injection[5][3]

#define RENODX_SWAP_CHAIN_DECODING             shader_injection[6][0]
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     shader_injection[6][1]
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    shader_injection[6][2]
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection[6][3]

#define RENODX_SWAP_CHAIN_ENCODING             shader_injection[7][0]
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE shader_injection[7][1]

#define RENODX_CUSTOM_FLIP_UV_Y                shader_injection[8][0]
#define RENODX_PSYCHOV22_COMPRESSION           shader_injection[8][1]
#define RENODX_PSYCHOV22_GAMUT_COMPRESSION     shader_injection[8][2]
#define RENODX_PSYCHOV22_GAMUT_MODE            shader_injection[8][3]
#define RENODX_PSYCHOV22_CONE_RESPONSE         shader_injection[9][0]
#define RENODX_BLOOM_BRIGHTNESS                 shader_injection[9][1]
#define RENODX_BLOOM_FLARE_SIZE                 shader_injection[9][2]
#define RENODX_HDR_BOOST                        shader_injection[9][3]

#else

#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#endif

#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_COLOR_GRADE_STRENGTH            shader_injection.color_grade_strength

#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows

#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout

#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_CORRECTION         shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT              shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE    shader_injection.tone_map_working_color_space

#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      shader_injection.tone_map_clamp_color_space
#define RENODX_TONE_MAP_CLAMP_PEAK             shader_injection.tone_map_clamp_peak
#define RENODX_TONE_MAP_HUE_PROCESSOR          shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection.tone_map_per_channel

#define RENODX_GAMMA_CORRECTION                shader_injection.gamma_correction
// #define RENODX_INTERMEDIATE_SCALING          shader_injection.intermediate_scaling
#define RENODX_INTERMEDIATE_ENCODING           shader_injection.intermediate_encoding
#define RENODX_INTERMEDIATE_COLOR_SPACE        shader_injection.intermediate_color_space

#define RENODX_SWAP_CHAIN_DECODING             shader_injection.swap_chain_decoding
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     shader_injection.swap_chain_gamma_correction
// #define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE shader_injection.swap_chain_decoding_color_space
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection.swap_chain_custom_color_space
// #define RENODX_SWAP_CHAIN_SCALING_NITS       shader_injection.swap_chain_scaling_nits
// #define RENODX_SWAP_CHAIN_CLAMP_NITS         shader_injection.swap_chain_clamp_nits
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    shader_injection.swap_chain_clamp_color_space

#define RENODX_SWAP_CHAIN_ENCODING             shader_injection.swap_chain_encoding
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE shader_injection.swap_chain_encoding_color_space

#define RENODX_CUSTOM_FLIP_UV_Y                shader_injection.custom_flip_uv_y
#define RENODX_PSYCHOV22_COMPRESSION           shader_injection.psychov22_compression
#define RENODX_PSYCHOV22_GAMUT_COMPRESSION     shader_injection.psychov22_gamut_compression
#define RENODX_PSYCHOV22_GAMUT_MODE            shader_injection.psychov22_gamut_mode
#define RENODX_PSYCHOV22_CONE_RESPONSE         shader_injection.psychov22_cone_response
#define RENODX_BLOOM_BRIGHTNESS                 shader_injection.bloom_brightness
#define RENODX_BLOOM_FLARE_SIZE                 shader_injection.bloom_flare_size
#define RENODX_HDR_BOOST                        shader_injection.hdr_boost

#endif

#define RENODX_RENO_DRT_TONE_MAP_METHOD renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#include "../../shaders/renodx.hlsl"

#endif  // !__cplusplus

#endif  // SRC_CODBLOPS_SHARED_H_
