#include "./common.hlsl"

RWTexture2D<float4> u0 : register(u0);
// ---- Created with 3Dmigoto v1.3.16 on Sat Nov 21 20:57:07 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[28];
}




// 3Dmigoto declarations
#define cmp -


[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 8, 8, 1
  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xy = cb0[27].zw * r0.xy;
  r1.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r0.xyz = t2.SampleLevel(s2_s, r0.xy, 0).xyz;
  if (GEARS5_CUSTOM_HDR_ENABLED) {
    u0[vThreadID.xy] = float4(Gears5CompositeHDR(r0.xyz, r1), 1.f);
    return;
  }

  r1.xyz = saturate(r1.xyz);
  r2.xyz = saturate(-cb0[14].www + r1.xyz);
  r0.w = 1 + -cb0[14].w;
  r2.xyz = r2.xyz / r0.www;
  r2.xyz = log2(abs(r2.xyz));
  r2.xyz = cb0[14].zzz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * r0.www + cb0[14].www;
  r0.w = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.w = cmp(r0.w >= cb0[14].w);
  r1.xyz = r0.www ? r2.xyz : r1.xyz;
  r1.xyz = cb0[14].xxx * r1.xyz;
  r1.xyz = min(cb0[14].yyy, r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.212670997,0.715160012,0.0721689984));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[7].www * r0.xyz + r0.www;
  r0.xyz = rsqrt(r0.xyz);
  r0.xyz = float3(1,1,1) / r0.xyz;
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = t0.SampleLevel(s0_s, r0.xyz, 0).xyz;
  r0.w = 1;
// No code for instruction (needs manual fix):
u0[vThreadID.xy] = r0;
  return;
}
