#ifndef SRC_ASSCREEDSHADOWS_SHARED_H_
#define SRC_ASSCREEDSHADOWS_SHARED_H_

// #define CUSTOM_COLOR_FILTER_STRENGTH  1.f
// #define CUSTOM_LOCAL_TONEMAP_STRENGTH 1.f
// #define CUSTOM_LOCAL_TONEMAP_SHOULDER 0.75f
// #define CUSTOM_LOCAL_TONEMAP_TOE      0.25f
// #define RENODX_TONE_MAP_EXPOSURE      1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS    1.f
// #define RENODX_TONE_MAP_SHADOWS       1.f
// #define RENODX_TONE_MAP_CONTRAST      1.f
// #define RENODX_TONE_MAP_SATURATION    1.f
// #define RENODX_TONE_MAP_BLOWOUT       0.f
// #define CUSTOM_BLOOM                  0.5f

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float custom_local_tonemap_strength;
  float custom_local_tonemap_shoulder;
  float custom_local_tonemap_toe;
  float custom_color_filter_strength;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_blowout;
  float custom_bloom;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_UI_MODE               0  // 1u = per pixel BT.2020 PQ Conversion
#define RENODX_UI_GAMMA_CORRECTION   1
#define RENODX_GRAPHICS_WHITE_NITS   203  // 0 = game default - 269
#define RENODX_TONE_MAP_TYPE         1
#define RENODX_GAME_GAMMA_CORRECTION 1

#define CUSTOM_COLOR_FILTER_STRENGTH  shader_injection.custom_color_filter_strength
#define CUSTOM_LOCAL_TONEMAP_STRENGTH shader_injection.custom_local_tonemap_strength
#define CUSTOM_LOCAL_TONEMAP_SHOULDER shader_injection.custom_local_tonemap_shoulder
#define CUSTOM_LOCAL_TONEMAP_TOE      shader_injection.custom_local_tonemap_toe
#define RENODX_TONE_MAP_EXPOSURE      shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS    shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS       shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST      shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION    shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_BLOWOUT       shader_injection.tone_map_blowout
#define CUSTOM_BLOOM                  shader_injection.custom_bloom

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_ASSCREEDSHADOWS_SHARED_H_
