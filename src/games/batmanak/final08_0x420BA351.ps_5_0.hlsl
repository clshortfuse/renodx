// writes to texture or swapchain

#include "../../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[12];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : TEXCOORD0, float4 v1 : TEXCOORD1, float2 v2 : TEXCOORD2, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0;
  r0.y = -cb0[6].x;
  while (true) {
    r0.z = cmp(cb0[6].x < r0.y);
    if (r0.z != 0) break;
    r1.x = cb0[8].x + r0.y;
    r2.x = r0.x;
    r2.y = -cb0[6].y;
    while (true) {
      r0.z = cmp(cb0[6].y < r2.y);
      if (r0.z != 0) break;
      r1.y = cb0[8].y + r2.y;
      r0.zw = r1.xy * cb0[11].xy + v2.xy;
      r0.z = t1.SampleLevel(s1_s, r0.zw, 0).w;
      r0.z = saturate(r0.z); // sdr clamp
      r2.x = r2.x + r0.z;
      r2.y = 1 + r2.y;
    }
    r0.x = r2.x;
    r0.y = 1 + r0.y;
  }
  r0.x = cb0[6].w * r0.x;
  r0.yz = cb0[10].xy * v2.xy;
  r1.xyzw = t0.SampleLevel(s0_s, r0.yz, 0).xyzw;

  r1 = saturate(r1); // SDR Clamp

  r0.y = 1 + -r1.w;
  r0.x = r0.x * r0.y;
  r0.x = saturate(cb0[6].z * r0.x);
  r0.xyzw = cb0[9].xyzw * r0.xxxx + r1.xyzw;
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
