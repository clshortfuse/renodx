#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[12];
}

// 3Dmigoto declarations
#define cmp -

void main(float2 v0 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.x = dot(r0.xyzw, cb0[7].xyzw);
  r1.y = dot(r0.xyzw, cb0[8].xyzw);
  r1.z = dot(r0.xyzw, cb0[9].xyzw);
  r1.w = dot(r0.xyzw, cb0[10].xyzw);
  r0.x = cb0[6].w + r0.w;
  r0.xyzw = cb0[6].xyzw * r0.xxxx + r1.xyzw;
  r0.xyz = saturate(r0.xyz);
  o0.w = r0.w;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[11].xxx * r0.xyz;
  o0.xyz = exp2(r0.xyz);

  o0.rgb = pow(o0.rgb, 2.2f);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
