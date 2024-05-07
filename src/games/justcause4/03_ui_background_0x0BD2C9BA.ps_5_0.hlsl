#include "./shared.h"
#include "../../shaders/color.hlsl"

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float4 v1 : COLOR1, out float4 o0 : SV_Target0) {
  o0.w = v1.w * v0.w;
  o0.xyz = v0.xyz;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
