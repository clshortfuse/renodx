#ifndef SRC_ASSCREEDSHADOWS_SHARED_H_
#define SRC_ASSCREEDSHADOWS_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float custom_local_tonemap_strength;
  float custom_color_filter_strength;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_blowout;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_UI_MODE               0u  // 1u = per pixel BT.2020 PQ Conversion
#define RENODX_GRAPHICS_WHITE_NITS   203.f
#define RENODX_TONE_MAP_TYPE         1u
#define RENODX_GAME_GAMMA_CORRECTION 1u

#define CUSTOM_COLOR_FILTER_STRENGTH  shader_injection.custom_color_filter_strength
#define CUSTOM_LOCAL_TONEMAP_STRENGTH shader_injection.custom_local_tonemap_strength
#define RENODX_TONE_MAP_EXPOSURE      shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS    shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS       shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST      shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION    shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_BLOWOUT       shader_injection.tone_map_blowout

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_ASSCREEDSHADOWS_SHARED_H_
