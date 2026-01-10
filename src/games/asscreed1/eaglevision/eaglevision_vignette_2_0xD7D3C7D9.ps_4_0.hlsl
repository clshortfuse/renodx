#include "../common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar  1 00:56:52 2025

cbuffer SCB_CommonPostEffect : register(b9) {
  float4 g_PlaneConstants : packoffset(c0);
  float4 g_CutoffConstants : packoffset(c1);
  float4 g_ZConstants : packoffset(c2);
}

SamplerState Source_s : register(s0);
SamplerState BlurredSource_s : register(s1);
SamplerState DepthTexture_s : register(s2);
Texture2D<float4> texture0 : register(t0);
Texture2D<float4> texture1 : register(t1);
Texture2D<float4> texture2 : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = texture2.Sample(DepthTexture_s, v1.xy).xyzw;
  r0.x = g_ZConstants.x + r0.x;
  r0.x = g_ZConstants.y / r0.x;
  r0.y = g_PlaneConstants.y + -r0.x;
  r0.zw = g_PlaneConstants.yz + -g_PlaneConstants.xy;
  r0.y = r0.y / r0.z;
  r0.y = max(0, r0.y);
  r0.y = min(g_CutoffConstants.x, r0.y);
  r0.z = -g_PlaneConstants.y + r0.x;
  r0.x = cmp(r0.x < g_PlaneConstants.y);
  r0.z = r0.z / r0.w;
  r0.z = max(0, r0.z);
  r0.z = min(g_CutoffConstants.y, r0.z);
  r0.x = r0.x ? r0.y : r0.z;
  r1.xyzw = texture1.Sample(BlurredSource_s, v1.xy).xyzw;
  r2.xyzw = texture0.Sample(Source_s, v1.xy).xyzw;

  r2.rgb = InvertIntermediatePass(r2.rgb);

  r1.xyzw = -r2.xyzw + r1.xyzw;
  o0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;

  o0.rgb = ClampAndRenderIntermediatePass(o0.rgb);

  return;
}
