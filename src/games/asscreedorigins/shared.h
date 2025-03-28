#ifndef SRC_ASSCREEDORIGINS_SHARED_H_
#define SRC_ASSCREEDORIGINS_SHARED_H_

#define RENODX_GAME_GAMMA_CORRECTION 1u

#define RENODX_TONE_MAP_TYPE         shader_injection.tone_map_type
#define CUSTOM_COLOR_FILTER_STRENGTH shader_injection.custom_color_filter_strength
#define RENODX_TONE_MAP_EXPOSURE     shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_TOE          shader_injection.tone_map_toe
#define RENODX_TONE_MAP_SHOULDER     shader_injection.tone_map_shoulder
#define RENODX_TONE_MAP_CONTRAST     shader_injection.tone_map_contrast
#define CUSTOM_EXPOSURE_COMPENSATION shader_injection.exposure_compensation
#define CUSTOM_CONTRAST_COMPENSATION shader_injection.contrast_compensation

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float tone_map_exposure;
  float custom_color_filter_strength;
  float tone_map_toe;
  float tone_map_shoulder;
  float tone_map_contrast;
  float exposure_compensation;
  float contrast_compensation;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_ASSCREEDORIGINS_SHARED_H_
