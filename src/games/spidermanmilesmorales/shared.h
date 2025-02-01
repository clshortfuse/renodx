#ifndef SRC_SPIDERMANMILESMORALES_SHARED_H_
#define SRC_SPIDERMANMILESMORALES_SHARED_H_

#define RENODX_GAMMA_ADJUST_TYPE  shader_injection.tone_map_gamma_adjust_type
#define RENODX_GAMMA_ADJUST_VALUE shader_injection.tone_map_gamma_adjust

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_gamma_adjust_type;
  float tone_map_gamma_adjust;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b0, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_SPIDERMANMILESMORALES_SHARED_H_