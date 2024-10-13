#include "./shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(out float4 o0 : SV_Target0) {
  o0.xyzw = cb0[0].xyzw;

  //o0.rgb = saturate(o0.rgb);
  //o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);  // 2.2 gamma correction
  // o0.a = sign(o0.a) * pow(abs(o0.a), 2.2f); // 2.2 gamma on Alpha
  //o0.rgb *= injectedData.toneMapUINits / 80.f;  // Added ui slider

  return;
}
