#include "../../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[9];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : TEXCOORD0, float4 v1 : TEXCOORD1, float2 v2 : TEXCOORD2, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0, 0, 0, 0);
  r1.x = -cb0[6].x;
  while (true) {
    r1.z = cmp(cb0[6].x < r1.x);
    if (r1.z != 0) break;
    r2.xyzw = r0.xyzw;
    r1.y = -cb0[6].y;
    while (true) {
      r1.z = cmp(cb0[6].y < r1.y);
      if (r1.z != 0) break;
      r1.zw = r1.xy * cb0[8].xy + v2.xy;
      r3.xyzw = t0.SampleLevel(s0_s, r1.zw, 0).xyzw;
      r3 = saturate(r3); // sdr clamp
      r2.xyzw = r3.xyzw + r2.xyzw;
      r1.y = 1 + r1.y;
    }
    r0.xyzw = r2.xyzw;
    r1.x = 1 + r1.x;
  }
  r0.xyzw = cb0[6].wwww * r0.xyzw;
  r1.xyz = v1.xyz;
  r1.w = 1;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = v1.wwww * r0.xyzw;
  r0.xyzw = v0.xyzw * r0.wwww + r0.xyzw;
  r0.xyz = saturate(r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[7].xxx * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = r0.w;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
