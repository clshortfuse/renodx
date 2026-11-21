#ifndef SRC_GAMES_ZELDA_OOT_OZ_SHARED_H_
#define SRC_GAMES_ZELDA_OOT_OZ_SHARED_H_
// CUSTOM FILE: Added addon/shader settings ABI; native shader interfaces are separate.

#define RENODX_TONE_MAP_TYPE_VANILLA 0.f
#define RENODX_TONE_MAP_TYPE_PSYCHOV35 9.f
#define RENODX_ADAPTATION_GENERATION_COUNT 1048576u

struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_cone_contrast;
  float bloom_strength;
  float custom_hue_clip;
  float custom_flags;
  float local_exposure;
  float tone_map_exposure;
  float adaptation_target;
  float adaptation_min_stops;
  float adaptation_max_stops;
};

#ifdef __cplusplus
static_assert(sizeof(ShaderInjectData) == 17u * sizeof(float));
#else
// CUSTOM: Native graphics/compute layouts have different push ranges. Keep
// settings independent of their offsets and preserve every native push byte.
layout(set = 1, binding = 4, scalar) uniform ZeldaShaderConstants {
  ShaderInjectData shader_injection;
} zelda_constants;
#define shader_injection zelda_constants.shader_injection
#define RENODX_TONE_MAP_TYPE shader_injection.tone_map_type
// CUSTOM: PsychoV35 uses global eye adaptation, never native local exposure.
#define RENODX_LOCAL_EXPOSURE (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV35 ? 0.f : shader_injection.local_exposure)
#define RENODX_PEAK_WHITE_NITS shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits
#ifdef RENODX_ZELDA_SDR
// CUSTOM: SDR comparison has fixed peak/diffuse/graphics white, independent of HDR UI.
#undef RENODX_PEAK_WHITE_NITS
#undef RENODX_DIFFUSE_WHITE_NITS
#undef RENODX_GRAPHICS_WHITE_NITS
#define RENODX_PEAK_WHITE_NITS 203.f
#define RENODX_DIFFUSE_WHITE_NITS 203.f
#define RENODX_GRAPHICS_WHITE_NITS 203.f
#endif
#define RENODX_TONE_MAP_EXPOSURE shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_CONE_CONTRAST shader_injection.tone_map_cone_contrast
#define RENODX_PSYCHOV_GAMUT_COMPRESSION 1.f
#define RENODX_PSYCHOV_COMPRESSION 1.f
#define RENODX_VANILLA_MIDGRAY ((asuint(shader_injection.custom_flags) & 1u) != 0u)
#define RENODX_ADAPTED_MIDGRAY ((asuint(shader_injection.custom_flags) & 16u) != 0u)
#define RENODX_VANILLA_SLOPE ((asuint(shader_injection.custom_flags) & 2u) != 0u)
#define RENODX_GLOBAL_COLOR_SPACE ((asuint(shader_injection.custom_flags) >> 2u) & 3u)
#include "../../shaders/renodx.hlsl"
#endif

#endif