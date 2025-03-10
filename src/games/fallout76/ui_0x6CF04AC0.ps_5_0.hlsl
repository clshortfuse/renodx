#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:57 2024

cbuffer Constants : register(b0) {
  float4 cxmul : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(out float4 o0 : SV_Target0) {
  o0.xyzw = cxmul.xyzw;

  o0 = saturate(o0);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::srgb::Decode(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  return;
}