// Sharpen + Clamp
#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11) {
  float4 cb11[1];
}

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb11[0].xyxy * float4(-0.666666687, -1, 0.666666687, -1) + v1.xyxy;
  r1.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r0.xyz = t0.Sample(s0_s, r0.zw).xyz;
  // r0.xyz = saturate(r0.xyz);
  // r1.xyz = saturate(r1.xyz);
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = cb11[0].xyxy * float4(-0.666666687, 0, 0.666666687, 0) + v1.xyxy;
  r2.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r1.xyz = t0.Sample(s0_s, r1.zw).xyz;
  // r1.xyz = saturate(r1.xyz);
  // r2.xyz = saturate(r2.xyz);
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r1.xyzw = cb11[0].xyxy * float4(-0.666666687, 1, 0.666666687, 1) + v1.xyxy;
  r2.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r1.xyz = t0.Sample(s0_s, r1.zw).xyz;
  // r1.xyz = saturate(r1.xyz);
  // r2.xyz = saturate(r2.xyz);
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  // r2.xyz = saturate(r1.xyz);
  r0.xyz = -r0.xyz * float3(0.166666672, 0.166666672, 0.166666672) + r2.xyz;
  // r0.xyz = cb11[0].zzz * r0.xyz + r1.xyz;
  r0.xyz = r1.xyz + (cb11[0].zzz * max(0, r0.xyz) * injectedData.fxSharpen);
  // o0.w = r1.w;
  // o0.xyz = max(float3(0,0,0), r0.xyz);


  return float4(r0.xyz, r1.w);
}
