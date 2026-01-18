#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun May  4 18:31:14 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[4];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[131];
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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[130].y / cb1[130].x;
  r0.y = -cb2[2].y * r0.x + 1;
  r0.z = -cb2[2].y * r0.x + r0.y;
  r0.x = cb2[2].y * r0.x;
  r1.xyzw = asuint(cb0[37].xxyy);
  r1.xyzw = v0.xxyy + -r1.xyzw;
  r0.w = r1.y * cb0[38].z + -r0.x;
  r0.z = r0.w / r0.z;
  r0.z = r0.z * 0.333333999 + 0.333332986;
  r0.w = 1 + -r0.y;
  r0.y = r1.y * cb0[38].z + -r0.y;
  r0.y = r0.y / r0.w;
  r0.y = r0.y * 0.333333015 + 0.666666985;
  r2.xyzw = cb0[38].zzww * r1.xyzw;
  r1.xy = r1.ww * cb0[38].ww + -cb2[2].zy;
  r3.xyzw = cmp(r2.xyzw >= cb2[2].zyzy);
  r0.y = r3.x ? r0.y : r0.z;
  r0.x = r2.y / r0.x;
  r0.x = 0.333332986 * r0.x;
  r0.z = r1.x / cb2[2].w;
  r0.w = r1.y / cb2[3].x;
  r0.w = r0.w * 0.333333999 + 0.333332986;
  r0.z = r0.z * 0.333333015 + 0.666666985;
  r0.xz = r3.yz ? r0.yz : r0.xw;
  r0.w = r2.w / cb2[3].y;
  r1.xy = r2.yw * cb0[5].xy + cb0[4].xy;
  r0.w = 0.333332986 * r0.w;
  r0.y = r3.w ? r0.z : r0.w;
  r0.x = t0.Sample(s0_s, r0.xy).w;
  r0.x = cb2[3].z * r0.x;
  r0.yzw = t1.Sample(s1_s, r1.xy).xyz;
  r2.xw = cb0[3].zw;
  r2.yz = float2(0,0);
  r3.xyzw = r2.xyzw + r1.xyxy;
  r1.xyzw = -r2.xyzw + r1.xyxy;
  r2.xyz = t1.Sample(s1_s, r3.xy).xyz;
  r3.xyz = t1.Sample(s1_s, r3.zw).xyz;
  r2.xyz = r0.yzw * float3(4,4,4) + -r2.xyz;
  r4.xyz = t1.Sample(s1_s, r1.xy).xyz;
  r1.xyz = t1.Sample(s1_s, r1.zw).xyz;
  r2.xyz = -r4.xyz + r2.xyz;
  r2.xyz = r2.xyz + -r3.xyz;
  r1.xyz = r2.xyz + -r1.xyz;
  r1.xyz = cb2[2].xxx * r1.xyz;
  r1.xyz = float3(0.25,0.25,0.25) * r1.xyz;
  r1.x = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  
  //r0.yzw = saturate(r1.xxx + r0.yzw);
  r0.yzw = (r1.xxx + r0.yzw);
  
  r0.xyz = r0.xxx * -r0.yzw + r0.yzw;
  r1.xyz = cb2[1].xyz + -r0.xyz;
  r0.xyz = cb2[3].www * r1.xyz + r0.xyz;
  
  //o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.xyz = r0.xyz;
  
  o0.w = 1;
  return;
}