#ifndef SRC_GHOSTS_SHARED_H_
#define SRC_GHOSTS_SHARED_H_

#define RENODX_GHOSTS_TONEMAPPER_LAYOUT_VERSION 3

// Must be 32-bit aligned.
// Existing fields stay in their original order; custom controls are appended.
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
  float fxSceneFilter;
  float fxBloom;
  float fxAutoExposure;
  float swap_chain_gamma_correction;
  float swap_chain_custom_color_space;
  float swap_chain_clamp_color_space;
  float swap_chain_encoding;
  float swap_chain_encoding_color_space;
  float custom_flip_uv_y;

  // Legacy PsychoV24 storage retained only to keep all later injected
  // constant-buffer offsets unchanged. Pragmap V2 does not use these fields.
  float psychov24_compression;
  float psychov24_gamut_compression;
  float psychov24_gamut_mode;
  float psychov24_cone_response;
  float psychov24_highlight_saturation;
  float psychov24_gamut_hue_restore;
  float psychov24_padding0;
  float psychov24_padding1;

  // Custom Ghosts effect controls.
  // Appended so every pre-existing injected field keeps the same offset.
  float blur_strength;
  float blur_padding0;

  // Pragmap V2 controls.
  //
  // These are appended AFTER all existing fields so every previous injected
  // constant-buffer offset remains unchanged.
  float pragmap_hue_strength;
  float pragmap_blowout_strength;
  float pragmap_shoulder;
  float pragmap_shoulder_compression;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                  shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS             shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS            shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION               shader_injection.gamma_correction
#define RENODX_TONE_MAP_PER_CHANNEL           shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE   shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR         shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION        shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT             shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE     shader_injection.tone_map_clamp_color_space
#define RENODX_TONE_MAP_CLAMP_PEAK            shader_injection.tone_map_clamp_peak
#define RENODX_TONE_MAP_EXPOSURE              shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS            shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS               shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST              shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION            shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION  shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT               shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                 shader_injection.tone_map_flare

#ifndef RENODX_TONE_MAP_TYPE_PRAGMAPV2
#define RENODX_TONE_MAP_TYPE_PRAGMAPV2 4.f
#endif

#ifndef RENODX_PRAGMAP_HUE_STRENGTH
#define RENODX_PRAGMAP_HUE_STRENGTH shader_injection.pragmap_hue_strength
#endif

#ifndef RENODX_PRAGMAP_BLOWOUT_STRENGTH
#define RENODX_PRAGMAP_BLOWOUT_STRENGTH shader_injection.pragmap_blowout_strength
#endif

#ifndef RENODX_PRAGMAP_SHOULDER
#define RENODX_PRAGMAP_SHOULDER shader_injection.pragmap_shoulder
#endif

#ifndef RENODX_PRAGMAP_SHOULDER_COMPRESSION
#define RENODX_PRAGMAP_SHOULDER_COMPRESSION shader_injection.pragmap_shoulder_compression
#endif

#ifndef RENODX_BLUR_STRENGTH
#define RENODX_BLUR_STRENGTH shader_injection.blur_strength
#endif

#define RENODX_COLOR_GRADE_STRENGTH            shader_injection.color_grade_strength
#define RENODX_INTERMEDIATE_ENCODING           shader_injection.intermediate_encoding
#define RENODX_SWAP_CHAIN_DECODING             shader_injection.swap_chain_decoding
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     shader_injection.swap_chain_gamma_correction
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    shader_injection.swap_chain_clamp_color_space
#define RENODX_SWAP_CHAIN_ENCODING             shader_injection.swap_chain_encoding
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE shader_injection.swap_chain_encoding_color_space
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GHOSTS_SHARED_H_
