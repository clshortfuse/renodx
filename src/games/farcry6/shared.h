#ifndef SRC_FARCRY6_SHARED_H
#define SRC_FARCRY6_SHARED_H

// #define RENODX_TONE_MAP_TYPE           2.f
// #define RENODX_PEAK_WHITE_NITS         400.f
// #define RENODX_DIFFUSE_WHITE_NITS      100.f
// #define RENODX_GRAPHICS_WHITE_NITS     140.f
// #define RENODX_TONE_MAP_HUE_CORRECTION 0.f
// #define RENODX_GAMMA_CORRECTION        1u
// #define RENODX_TONE_MAP_EXPOSURE       1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS     1.f
// #define RENODX_TONE_MAP_SHADOWS        1.f
// #define RENODX_TONE_MAP_CONTRAST       1.f
// #define RENODX_TONE_MAP_SATURATION     1.f
// #define RENODX_TONE_MAP_BLOWOUT        0.f

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_hue_correction;
  float gamma_correction;
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

#define RENODX_TONE_MAP_TYPE           shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS         shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS      shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS     shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_HUE_CORRECTION shader_injection.tone_map_hue_correction
#define RENODX_GAMMA_CORRECTION        shader_injection.gamma_correction
#define RENODX_TONE_MAP_EXPOSURE       shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS     shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS        shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST       shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION     shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_BLOWOUT        shader_injection.tone_map_blowout

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_FARCRY6_SHARED_H
