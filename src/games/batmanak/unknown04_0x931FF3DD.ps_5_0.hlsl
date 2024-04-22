#include "../../shaders/color.hlsl"
#include "./shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[42];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : TEXCOORD10, float4 v1 : TEXCOORD11, float2 v2 : TEXCOORD0, float2 w2 : TEXCOORD7, float4 v3 : TEXCOORD1, float4 v4 : TEXCOORD2, float4 v5 : TEXCOORD5, float3 v6 : TEXCOORD6, out float4 o0 : SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v6.xyz, v6.xyz);
  r0.x = sqrt(r0.x);
  r0.x = cmp(0 < r0.x);
  r0.yzw = cb0[39].xyz + -v5.xyz;
  r1.x = dot(r0.yzw, r0.yzw);
  r0.yzw = r0.yzw / cb0[40].www;
  r0.y = dot(r0.yzw, r0.yzw);
  r0.y = min(1, r0.y);
  r0.y = 1 + -r0.y;
  r0.z = sqrt(r1.x);
  r0.z = cmp(r0.z < cb0[41].x);
  r0.x = r0.x ? r0.z : 0;
  r0.x = r0.x ? r0.y : 0;
  o0.xyz = cb0[41].yzw * r0.xxx;
  o0.w = r0.x;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
