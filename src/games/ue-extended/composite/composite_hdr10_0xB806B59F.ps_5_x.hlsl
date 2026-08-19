// Mortal Kombat 1
// UE 4.27.2.0 HDR10 Native HDR

#include "./composite.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 01:22:54 2026
Texture2D<uint4> t3 : register(t3);

Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[14];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.Sample(s1_s, v0.xy).xyz;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;

  if (HandleUICompositing(r1, r0, o0, v0.xy, t1, s1_s)) {
    return;
  }

  r2.xyzw = cmp(r1.xyzw == float4(0,0,0,0));
  r2.xy = r2.zw ? r2.xy : 0;
  r0.w = r2.y ? r2.x : 0;
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  r2.xy = (uint2)v1.xy;
  r2.zw = float2(0,0);
  r0.w = t3.Load(r2.xyz).y;
  r0.w = (int)r0.w & 64;
  r0.w = r0.w ? cb0[13].x : cb0[12].w;
  r1.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r1.xyz);
  r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) < r1.xyz);
  r3.xyz = r1.xyz * float3(0.947867274,0.947867274,0.947867274) + float3(0.0521326996,0.0521326996,0.0521326996);
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r1.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
  r1.xyz = r2.xyz ? r3.xyz : r1.xyz;
  r1.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = r1.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r1.xyz = rcp(r1.xyz);
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(78.84375,78.84375,78.84375) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r1.xyz = t2.SampleLevel(s2_s, r1.xyz, 0).xyz;
  r1.xyz = float3(1.04999995,1.04999995,1.04999995) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r1.xyz;
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r1.xyz = -r1.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r1.xyz = r2.xyz / r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(6.27739477,6.27739477,6.27739477) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r0.xyz;
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r0.xyz = -r0.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r0.xyz = r2.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477,6.27739477,6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(10000,10000,10000) * r0.xyz;
  r2.x = cmp(0 < r1.w);
  r2.y = cmp(r1.w < 1);
  r2.x = r2.y ? r2.x : 0;
  if (r2.x != 0) {
    r2.x = dot(r0.xyz, float3(0.262699991,0.677999973,0.0593000017));
    r2.x = r2.x / r0.w;
    r2.x = 1 + r2.x;
    r2.x = 1 / r2.x;
    r0.w = r2.x * r0.w + -1;
    r0.w = r1.w * r0.w + 1;
    r0.xyz = r0.xyz * r0.www;
  }
  r0.w = 1 + -r1.w;
  r1.xyz = float3(10000,10000,10000) * r1.xyz;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r0.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r0.xyz = rcp(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;
  return;
}