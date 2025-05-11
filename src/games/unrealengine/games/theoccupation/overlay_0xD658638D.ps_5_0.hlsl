#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu May  8 20:26:13 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[5];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[18];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[17].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = -r0.xy * cb0[16].zw + float2(1,1);
  r0.xy = cb0[16].zw * r0.xy;
  r1.xy = r0.zw * r0.xy;
  r0.z = cb1[2].y * r0.w;
  r0.z = max(0, r0.z);
  r0.z = log2(r0.z);
  r0.z = cb1[2].z * r0.z;
  r0.z = exp2(r0.z);
  r0.w = r1.x * r1.y;
  r0.w = cb1[3].x * r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb1[3].y * r0.w;
  r0.w = exp2(r0.w);
  r0.zw = min(float2(1,1), r0.zw);
  r1.xyz = t3.Sample(s3_s, r0.xy).xyz;  
  r2.xyz = r1.xyz * r0.www + -r1.xyz;
  r2.xyz = cb1[3].zzz * r2.xyz + r1.xyz;
  r3.xyz = r1.xyz * r0.zzz + -r1.xyz;
  r1.xyz = cb1[2].www * r3.xyz + r1.xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = cb1[3].www * r2.xyz + r1.xyz;
  r2.xyz = t2.Sample(s2_s, r0.xy).xyz;
  r2.xyz = r1.xyz * r2.xyz + -r1.xyz;
  
  //r1.xyz = saturate(cb1[4].xxx * r2.xyz + r1.xyz);
  r1.xyz = (cb1[4].xxx * r2.xyz + r1.xyz);
  
  r2.xyz = t1.Sample(s1_s, r0.xy).xyz; 
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = cb1[2].xxx * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz * r1.xyz + cb1[1].xyz;
  
  //o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.xyz = r0.xyz;
  
  o0.w = 1;
  return;
}