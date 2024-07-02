#include "./shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(out float4 o0 : SV_Target0) {
  o0.xyzw = cb0[0].xyzw;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::bt709::from::SRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
