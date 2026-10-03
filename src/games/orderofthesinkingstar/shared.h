#ifndef SRC_GAMES_ORDEROFTHESINKINGSTAR_SHARED_H_
#define SRC_GAMES_ORDEROFTHESINKINGSTAR_SHARED_H_

#define RENODX_TONE_MAP_TYPE_VANILLA   0.f
#define RENODX_TONE_MAP_TYPE_NEUTWO    3.f
#define RENODX_TONE_MAP_TYPE_PSYCHOV17 4.f
#define RENODX_TONE_MAP_TYPE_PSYCHOV30 8.f

#define CUSTOM_SATURATION_SPACE_BT709_NATIVE 0.f
#define CUSTOM_SATURATION_SPACE_OKLAB        1.f
#define CUSTOM_SATURATION_SPACE_LMS_D65      2.f

#define CUSTOM_FLAGS__PSYCHOV_VANILLA_MIDGRAY 0x00000001u
#define CUSTOM_FLAGS__PSYCHOV_VANILLA_SLOPE   0x00000002u
#define CUSTOM_FLAGS__DEBUG_CANVAS            0x00000004u

struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;

  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;

  float tone_map_hue_processor;
  float tone_map_hue_correction;
  float tone_map_working_color_space;
  float gamma_correction;

  float swap_chain_output_preset;
  float tone_map_cone_contrast;
  float psychov_gamut_compression;
  float psychov_compression;

  float custom_fxaa;
  float custom_bloom;
  float custom_saturation_space;
  float custom_lift;

  float custom_gamma;
  float custom_gain;
  float custom_game_saturation;
  float custom_flags;
};

#ifdef __cplusplus
static_assert(sizeof(ShaderInjectData) == 7u * 16u);
#endif

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injected_buffer : register(b13, space50) {
#else
cbuffer injected_buffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space
#define RENODX_GAMMA_CORRECTION              (shader_injection.swap_chain_output_preset == 0.f ? 0.f : shader_injection.gamma_correction)
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION   RENODX_GAMMA_CORRECTION
#define RENODX_TONE_MAP_CONE_CONTRAST        shader_injection.tone_map_cone_contrast
#define RENODX_PSYCHOV_GAMUT_COMPRESSION     shader_injection.psychov_gamut_compression
#define RENODX_PSYCHOV_COMPRESSION           shader_injection.psychov_compression
#define CUSTOM_FLAGS                         shader_injection.custom_flags
#define CUSTOM_FLAGS_AS_UINT                 (asuint(CUSTOM_FLAGS))
#define RENODX_PSYCHOV_VANILLA_MIDGRAY       ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__PSYCHOV_VANILLA_MIDGRAY) != 0u)
#define RENODX_PSYCHOV_VANILLA_SLOPE         ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__PSYCHOV_VANILLA_SLOPE) != 0u)
#define CUSTOM_FXAA                          shader_injection.custom_fxaa
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_GAME_GRADE_SATURATION         shader_injection.custom_game_saturation
#define CUSTOM_GAME_SATURATION_SPACE         shader_injection.custom_saturation_space
#define CUSTOM_GAME_GRADE_LIFT               shader_injection.custom_lift
#define CUSTOM_GAME_GRADE_GAMMA              shader_injection.custom_gamma
#define CUSTOM_GAME_GRADE_GAIN               shader_injection.custom_gain
#ifdef NDEBUG
#define CUSTOM_DEBUG_CANVAS false
#else
#define CUSTOM_DEBUG_CANVAS ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DEBUG_CANVAS) != 0u)
#endif
#define RENODX_INTERMEDIATE_ENCODING    renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_DECODING      renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET shader_injection.swap_chain_output_preset
#define RENODX_RENO_DRT_TONE_MAP_METHOD renodx::tonemap::renodrt::config::tone_map_method::NEUTWO

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_GAMES_ORDEROFTHESINKINGSTAR_SHARED_H_