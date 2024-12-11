#ifndef SRC_BIOSHOCK_SHARED_H_
#define SRC_BIOSHOCK_SHARED_H_

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float PaperWhiteNits;
  float Padding01;
  float Padding02;
  float Padding03;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_BIOSHOCK_SHARED_H_
