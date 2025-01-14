#ifndef SRC_SCBLACKLIST_SHARED_H_
#define SRC_SCBLACKLIST_SHARED_H_

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

#define RENODX_PEAK_WHITE_NITS     shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection.diffuse_white_nits
#define RENODX_TONE_MAP_TYPE       shader_injection.tone_map_type
#define RENODX_TONE_MAP_SONAR      shader_injection.tone_map_sonar
#define RENODX_TONE_MAP_EXPOSURE   shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS    shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST   shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_BLOWOUT    shader_injection.tone_map_blowout
#define CUSTOM_LUT_STRENGTH        shader_injection.custom_lut_strength
#define CUSTOM_LENS_FLARE          shader_injection.custom_lens_flare
#define CUSTOM_NOISE               shader_injection.custom_noise

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float tone_map_type;
  float tone_map_sonar;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_blowout;
  float custom_lut_strength;
  float custom_lens_flare;
  float custom_noise;
};

#ifndef __cplusplus
cbuffer cb10 : register(b10) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#endif

#endif  // SRC_SCBLACKLIST_SHARED_H_
