#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Mon Nov 23 17:36:33 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[15];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  if (GEARS5_CUSTOM_HDR_ENABLED) {
    o0 = float4(Gears5CompositeHDR(t2.Sample(s2_s, v0.xy).rgb, r0), 1.f);
    return;
  }
  r0.xyz = saturate(r0.xyz);
  r1.xyz = saturate(-cb0[14].www + r0.xyz);
  r1.w = 1 + -cb0[14].w;
  r1.xyz = r1.xyz / r1.www;
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = cb0[14].zzz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * r1.www + cb0[14].www;
  r1.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.w = cmp(r1.w >= cb0[14].w);
  r0.xyz = r1.www ? r1.xyz : r0.xyz;
  r0.xyz = cb0[14].xxx * r0.xyz;
  r0.xyz = min(cb0[14].yyy, r0.xyz);
  r1.xyz = t2.Sample(s2_s, v0.xy).xyz;
  r0.xyz = -r1.xyz + r0.xyz;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.w = dot(r0.xyz, float3(0.212670997,0.715160012,0.0721689984));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[7].www * r0.xyz + r0.www;
  r0.xyz = rsqrt(r0.xyz);
  r0.xyz = float3(1,1,1) / r0.xyz;
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = t0.Sample(s0_s, r0.xyz).xyz;
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}
