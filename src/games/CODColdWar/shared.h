#ifndef SRC_CODCOLDWAR_SHARED_H_
#define SRC_CODCOLDWAR_SHARED_H_


// ============================================================================
// Cold War tone mapper IDs
// ============================================================================

#define COLDWAR_TONE_MAP_TYPE_VANILLA    0.f
#define COLDWAR_TONE_MAP_TYPE_RENODRT    3.f
#define COLDWAR_TONE_MAP_TYPE_PSYCHOV30 30.f
#define COLDWAR_TONE_MAP_TYPE_PRAGMAP   31.f


// ============================================================================
// Shader injection
// ============================================================================
//
// Existing fields remain in their original order.
//
// PsychoV30 and Pragmap controls are appended to the end so existing offsets
// stay stable.
//

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
  float swap_chain_custom_color_space;
  float swap_chain_clamp_color_space;

  float swap_chain_encoding;
  float swap_chain_encoding_color_space;
  float custom_flip_uv_y;


  // --------------------------------------------------------------------------
  // PsychoV30
  // --------------------------------------------------------------------------

  float psychov30_purity_scale;
  float psychov30_cone_response_exponent;
  float psychov30_gamut_compression;
  float psychov30_compression;

  float psychov30_gamut_target;


  // --------------------------------------------------------------------------
  // Pragmap
  // --------------------------------------------------------------------------
  //
  // These are the ONLY two custom parameters exposed by the original
  // pragmap() function.
  //

  float pragmap_hue_strength;
  float pragmap_blowout_strength;


  // Keep the structure on a float4 boundary.
  float _padding0;
  float _padding1;
};


#ifndef __cplusplus

#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)

cbuffer shader_injection : register(b13, space50) {

#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))

cbuffer shader_injection : register(b13) {

#endif

  ShaderInjectData shader_injection : packoffset(c0);
}


// ============================================================================
// RenoDX standard bindings
// ============================================================================

#define RENODX_TONE_MAP_TYPE \
  shader_injection.tone_map_type

#define RENODX_PEAK_WHITE_NITS \
  shader_injection.peak_white_nits

#define RENODX_DIFFUSE_WHITE_NITS \
  shader_injection.diffuse_white_nits

#define RENODX_GRAPHICS_WHITE_NITS \
  shader_injection.graphics_white_nits

#define RENODX_GAMMA_CORRECTION \
  shader_injection.gamma_correction

#define RENODX_TONE_MAP_PER_CHANNEL \
  shader_injection.tone_map_per_channel

#define RENODX_TONE_MAP_WORKING_COLOR_SPACE \
  shader_injection.tone_map_working_color_space

#define RENODX_TONE_MAP_HUE_PROCESSOR \
  shader_injection.tone_map_hue_processor

#define RENODX_TONE_MAP_HUE_CORRECTION \
  shader_injection.tone_map_hue_correction

#define RENODX_TONE_MAP_HUE_SHIFT \
  shader_injection.tone_map_hue_shift

#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE \
  shader_injection.tone_map_clamp_color_space

#define RENODX_TONE_MAP_CLAMP_PEAK \
  shader_injection.tone_map_clamp_peak

#define RENODX_TONE_MAP_EXPOSURE \
  shader_injection.tone_map_exposure

#define RENODX_TONE_MAP_HIGHLIGHTS \
  shader_injection.tone_map_highlights

#define RENODX_TONE_MAP_SHADOWS \
  shader_injection.tone_map_shadows

#define RENODX_TONE_MAP_CONTRAST \
  shader_injection.tone_map_contrast

#define RENODX_TONE_MAP_SATURATION \
  shader_injection.tone_map_saturation

#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION \
  shader_injection.tone_map_highlight_saturation

#define RENODX_TONE_MAP_BLOWOUT \
  shader_injection.tone_map_blowout

#define RENODX_TONE_MAP_FLARE \
  shader_injection.tone_map_flare

#define RENODX_COLOR_GRADE_STRENGTH \
  shader_injection.color_grade_strength
#define RENODX_INTERMEDIATE_SCALING \
    (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS)
#define RENODX_INTERMEDIATE_ENCODING \
  shader_injection.intermediate_encoding

#define RENODX_SWAP_CHAIN_DECODING \
  shader_injection.swap_chain_decoding

#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION \
  shader_injection.swap_chain_gamma_correction

#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE \
  shader_injection.swap_chain_custom_color_space

#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE \
  shader_injection.swap_chain_clamp_color_space

#define RENODX_SWAP_CHAIN_ENCODING \
  shader_injection.swap_chain_encoding

#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE \
  shader_injection.swap_chain_encoding_color_space


// ============================================================================
// PsychoV30 bindings
// ============================================================================

#define RENODX_PSYCHOV30_PURITY_SCALE \
  shader_injection.psychov30_purity_scale

#define RENODX_PSYCHOV30_CONE_RESPONSE \
  shader_injection.psychov30_cone_response_exponent

#define RENODX_PSYCHOV30_GAMUT_COMPRESSION \
  shader_injection.psychov30_gamut_compression

#define RENODX_PSYCHOV30_COMPRESSION \
  shader_injection.psychov30_compression

#define RENODX_PSYCHOV30_GAMUT_TARGET \
  shader_injection.psychov30_gamut_target


// ============================================================================
// Pragmap bindings
// ============================================================================

#define RENODX_PRAGMAP_HUE_STRENGTH \
  shader_injection.pragmap_hue_strength

#define RENODX_PRAGMAP_BLOWOUT_STRENGTH \
  shader_injection.pragmap_blowout_strength


#define RENODX_RENO_DRT_TONE_MAP_METHOD \
  renodx::tonemap::renodrt::config::tone_map_method::REINHARD


#include "../../shaders/renodx.hlsl"

#endif  // __cplusplus

#endif  // SRC_CODCOLDWAR_SHARED_H_