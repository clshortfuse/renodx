#ifndef SRC_GOWRAGNAROK_SHARED_H
#define SRC_GOWRAGNAROK_SHARED_H

// #define RENODX_PEAK_WHITE_NITS      1000.f
// #define RENODX_DIFFUSE_WHITE_NITS   203.f
// #define RENODX_OVERRIDE_PEAK_NITS   1u
// #define RENODX_TONE_MAP_TYPE        1u
// #define RENODX_TONE_MAP_EXPOSURE    1.f
// #define CUSTOM_BLOOM                1.f
// #define RENODX_USE_PQ_ENCODING      1u

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float tone_map_override_peak_nits;
  float peak_white_nits;
  float diffuse_white_nits;
  float tone_map_exposure;
  float custom_bloom;
  float custom_hdr10_encoding;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE      shader_injection.tone_map_type
#define RENODX_OVERRIDE_PEAK_NITS shader_injection.tone_map_override_peak_nits
#define RENODX_PEAK_WHITE_NITS    shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS shader_injection.diffuse_white_nits
#define RENODX_TONE_MAP_EXPOSURE  shader_injection.tone_map_exposure
#define CUSTOM_BLOOM              shader_injection.custom_bloom
#define RENODX_USE_PQ_ENCODING    shader_injection.custom_hdr10_encoding

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GOWRAGNAROK_SHARED_H
