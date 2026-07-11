#ifndef SRC_YAKPIRATE_SHARED_H_
#define SRC_YAKPIRATE_SHARED_H_

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float gamma;
};

#ifndef __cplusplus
cbuffer injectedBuffer : register(b0, space50) {
  ShaderInjectData injectedData : packoffset(c0);
}

#endif

#endif  // SRC_YAKPIRATE_SHARED_H_
