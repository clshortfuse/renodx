// Some UI effects

#include "../common/color.hlsl"
#include "./shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

void main(float4 v0 : COLOR0, float4 v1 : COLOR1, out float4 outputColor : SV_TARGET0) {
  float4 r0;

  r0.xyz = saturate(v0.xyz);
  r0.xyz = v0.xyz;
  r0.xyz = pow(r0.xyz, cb0[5].w);  // Usually 1
  outputColor.a = v1.a * v0.a;
  outputColor.rgb = r0.rgb;

  outputColor.rgb = pow(outputColor.rgb, 2.2f);
  outputColor.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
