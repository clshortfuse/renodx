#ifndef SRC_DEATHSTRANDINGDC_SHARED_H_
#define SRC_DEATHSTRANDINGDC_SHARED_H_

// #define RENODX_TONE_MAP_TYPE           2.f
// #define RENODX_TONE_MAP_HUE_CORRECTION 1.f
// #define RENODX_PEAK_WHITE_NITS         400.f
// #define RENODX_DIFFUSE_WHITE_NITS      100.f
// #define RENODX_GRAPHICS_WHITE_NITS     140.f
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
};

#ifndef __cplusplus
cbuffer shader_injection : register(b0, space9) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE           shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS         shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS      shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS     shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_HUE_CORRECTION shader_injection.tone_map_hue_correction

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_DEATHSTRANDINGDC_SHARED_H_
