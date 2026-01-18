#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 10 22:49:51 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[29];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[143];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + -cb2[23].x;
  r0.x = cmp(9.99999975e-06 < abs(r0.x));
  r0.yz = asuint(cb0[37].xy);
  r0.yz = v0.xy + -r0.yz;
  r0.yz = cb0[38].zw * r0.yz;
  r1.xy = r0.yz * cb2[5].xy + cb2[7].xy;
  r0.yz = r0.yz / cb2[26].xx;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r0.yz = -cb2[26].yy + r0.yz;
  r0.yz = float2(-0.5,-0.5) + r0.yz;
  r1.xy = cb2[8].xy * cb1[142].zz + r1.xy;
  r1.xy = cb2[9].xy + r1.xy;
  r2.x = dot(r1.xy, cb2[10].xy);
  r2.y = dot(r1.xy, cb2[11].xy);
  r1.xy = cb2[6].xy + r2.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = cmp(1 >= cb2[23].x);
  r0.w = r0.w ? r1.x : r1.z;
  r0.x = r0.x ? r0.w : r1.y;
  r0.w = cmp(cb2[23].x >= 3);
  r0.x = r0.w ? r1.w : r0.x;
  r0.w = -3 + cb2[23].x;
  r0.w = cmp(9.99999975e-06 < abs(r0.w));
  r0.x = r0.w ? r0.x : r1.w;
  r0.x = 1 + -r0.x;
  r0.w = log2(r0.x);
  r0.x = cmp(0 >= r0.x);
  r0.w = cb2[23].w * r0.w;
  r0.w = exp2(r0.w);
  r0.w = saturate(cb2[24].z * r0.w);
  r0.x = r0.x ? 0 : r0.w;
  r0.w = log2(r0.x);
  r0.x = cmp(0 >= r0.x);
  r0.w = cb2[25].x * r0.w;
  r0.w = exp2(r0.w);
  r0.w = saturate(cb2[25].z * r0.w);
  r1.xyz = -cb2[13].xyz + cb2[12].xyz;
  r1.xyz = r1.xyz * r0.www;
  r1.xyz = r0.xxx ? float3(0,0,0) : r1.xyz;
  r1.xyz = cb2[13].xyz + r1.xyz;
  r1.xyz = cb2[15].xyz * r1.xyz;
  r2.x = dot(r0.yz, cb2[16].xy);
  r2.y = dot(r0.yz, cb2[17].xy);
  r0.xy = float2(0.5,0.5) + r2.xy;
  r0.xy = r0.xy * cb0[5].xy + cb0[4].xy;
  r0.xy = max(cb0[6].xy, r0.xy);
  r0.xy = min(cb0[6].zw, r0.xy);
  r0.xyz = t1.Sample(s1_s, r0.xy).xyz; 
  r0.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r2.xyz = r0.www + -r0.xyz;
  r0.xyz = cb2[27].www * r2.xyz + r0.xyz;
  r2.xyz = cmp(float3(0,0,0) >= r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb2[28].xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r2.xyz ? float3(0,0,0) : r0.xyz;
  
  //r0.xyz = saturate(cb2[28].yyy * r0.xyz);
  r0.xyz = (cb2[28].yyy * r0.xyz);
  
  r2.xyz = cb2[25].www * r1.xyz + -r0.xyz;
  r3.xyz = cb2[25].www * r1.xyz + r0.xyz;
  r4.xyz = cb2[25].www * r1.xyz;
  r1.xyz = -cb2[25].www * r1.xyz + float3(1,1,1);
  r5.xyz = r4.xyz * r0.xyz;
  r6.xyz = cmp(float3(1,3,5) >= cb2[28].zzz);
  r3.xyz = r6.xxx ? r3.xyz : r5.xyz;
  r5.xyz = float3(1,3,5) + -cb2[28].zzz;
  r5.xyz = cmp(float3(9.99999975e-06,9.99999975e-06,9.99999975e-06) < abs(r5.xyz));
  r2.xyz = r5.xxx ? r3.xyz : r2.xyz;
  r3.xyz = min(r4.xyz, r0.xyz);
  r2.xyz = r6.yyy ? r2.xyz : r3.xyz;
  r3.xyz = r4.xyz / r0.xyz;
  r4.xyz = max(r4.xyz, r0.xyz);
  r0.xyz = float3(1,1,1) + -r0.xyz;
  r0.xyz = -r0.xyz;
  r0.xyz = -r0.xyz * r1.xyz + float3(1,1,1);
  r1.xyz = r5.yyy ? r2.xyz : r3.xyz;
  r0.xyz = r6.zzz ? r1.xyz : r0.xyz;
  
  //r0.xyz = saturate(r5.zzz ? r0.xyz : r4.xyz);
  r0.xyz = (r5.zzz ? r0.xyz : r4.xyz);
  
  r1.xyz = cb2[18].xyz + -r0.xyz;
  r0.xyz = cb2[28].www * r1.xyz + r0.xyz;
  
  //o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.xyz = r0.xyz;
  
  o0.w = 1;
  
  return;
}