#include "./lilium_rcas.hlsl"
// ---- Created with 3Dmigoto v1.4.1 on Fri Jan 30 01:59:38 2026

cbuffer cbRenewFilterInfo : register(b2) {
  float4 g_cbScreenScale : packoffset(c0);
  float4 g_cbNoiseInfo : packoffset(c1);
  float4 g_cbHPassInfo : packoffset(c2);
  float4 g_cbMinMaxUV : packoffset(c3);
  float4 g_cbColorInfo : packoffset(c4);
}

SamplerState samplePoint_s : register(s8);
Texture2D<float4> g_tTargetHPass : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  o0 = g_tTargetHPass.SampleLevel(samplePoint_s, v1.xy, 0);

  // We skip this shader
  if (CUSTOM_SHARPNESS > 0.f) {
    o0.rgb = ApplyRCAS(o0.rgb, v1.xy, g_tTargetHPass, samplePoint_s);
  }
  return;

  r0.x = cmp(0 < g_cbColorInfo.w);
  r0.yz = -g_cbScreenScale.zw + v1.xy;
  r0.yzw = g_tTargetHPass.SampleLevel(samplePoint_s, r0.yz, 0).xyz;
  r1.xyzw = g_cbScreenScale.zwzw * float4(-1, 1, 1, -1) + v1.xyxy;
  r2.xyz = g_tTargetHPass.SampleLevel(samplePoint_s, r1.xy, 0).xyz;
  r1.xyz = g_tTargetHPass.SampleLevel(samplePoint_s, r1.zw, 0).xyz;
  r0.yzw = r2.xyz + r0.yzw;
  r0.yzw = r0.yzw + r1.xyz;
  r1.xy = g_cbScreenScale.zw + v1.xy;
  r1.xyz = g_tTargetHPass.SampleLevel(samplePoint_s, r1.xy, 0).xyz;
  r0.yzw = r1.xyz + r0.yzw;
  r1.xyzw = g_tTargetHPass.SampleLevel(samplePoint_s, v1.xy, 0).xyzw;
  r0.yzw = -r0.yzw * float3(0.25, 0.25, 0.25) + r1.xyz;
  r0.y = dot(r0.yzw, float3(0.222014993, 0.706655025, 0.0713300034));
  r0.y = 0.5 + r0.y;
  r0.z = saturate(r0.y);
  r0.x = r0.x ? r0.z : r0.y;
  r0.y = 1 + -r0.x;
  r0.xzw = r0.xxx * r1.xyz;
  r0.xzw = r0.xzw + r0.xzw;
  r2.xyz = float3(1, 1, 1) + -r1.xyz;
  r2.xyz = r2.xyz * r0.yyy;
  r2.xyz = -r2.xyz * float3(2, 2, 2) + float3(1, 1, 1);
  r3.xyz = cmp(r1.xyz < float3(0.5, 0.5, 0.5));
  r0.xyz = r3.xyz ? r0.xzw : r2.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = g_cbHPassInfo.xxx * r0.xyz + r1.xyz;
  o0.w = r1.w;
  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = g_cbColorInfo.yyy * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = g_cbColorInfo.zzz * r1.xyz;
  r0.w = floor(g_cbColorInfo.x);
  r0.w = (int)r0.w;
  o0.xyz = r0.www ? r0.xyz : r1.xyz;
  return;
}
