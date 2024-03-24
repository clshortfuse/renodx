#include "./shared.h"

cbuffer ColorConstantBuffer : register(b0) {
  float4 pixelColor : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  o0.xyzw = pixelColor.xyzw;

  if (injectedData.toneMapType == 2) {
    o0.rgb *= injectedData.toneMapUINits / 80.f;
  }
  
  return;
}
