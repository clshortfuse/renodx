#ifndef SRC_GAMES_DOOM2016_SHARED_H_
#define SRC_GAMES_DOOM2016_SHARED_H_

#define DOOM2016_OUTPUT_SDR   0.f
#define DOOM2016_OUTPUT_HDR10 1.f

#define DOOM2016_TONEMAP_VANILLA     0.f
#define DOOM2016_TONEMAP_PSYCHOV_17  1.f
#define DOOM2016_TONEMAP_PSYCHOV_22  2.f
#define DOOM2016_TONEMAP_PSYCHOV_24  3.f
#define DOOM2016_TONEMAP_PSYCHOV_25  4.f
#define DOOM2016_TONEMAP_PSYCHOV_30  5.f
#define DOOM2016_TONEMAP_RENO_DRT    6.f

// DOOM's captured Vulkan pipelines have no native push-constant ranges. RenoDX
// appends this pixel-visible payload without changing the game's descriptor ABI.
#ifdef __cplusplus
struct alignas(16) ShaderInjectData {
#else
struct ShaderInjectData {
#endif
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float output_mode;

  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;

  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float psychov_cone_response;

  float psychov_exposure_match;
  float psychov_vanilla_slope;
  float scene_path_active;
  float scene_bt2020;
};

#ifdef __cplusplus
static_assert(sizeof(ShaderInjectData) == 64u);
static_assert(alignof(ShaderInjectData) == 16u);
#else
#ifdef __SLANG__
layout(push_constant) uniform PushData {
  ShaderInjectData shader_injection;
};
#else
#error DOOM 2016 Vulkan replacements must be compiled from Slang.
#endif

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_PSYCHOV_CONE_RESPONSE         shader_injection.psychov_cone_response
#define RENODX_PSYCHOV_EXPOSURE_MATCH        shader_injection.psychov_exposure_match
#define RENODX_PSYCHOV_VANILLA_SLOPE         shader_injection.psychov_vanilla_slope

#include "../../shaders/color.hlsl"
#include "../../shaders/colorgrade.hlsl"
#include "../../shaders/math.hlsl"
#endif

#endif  // SRC_GAMES_DOOM2016_SHARED_H_
