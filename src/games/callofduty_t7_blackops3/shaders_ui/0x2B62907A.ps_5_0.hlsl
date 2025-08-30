// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 11:48:18 2025

#include "../shared.h"


Texture2D<float4> t6 : register(t6);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

cbuffer cb3 : register(b3)
{
  float4 cb3[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  if (!CUSTOM_SHOW_HUD) discard;

  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  t6.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.zw = float2(0.5,0.5) * cb3[0].xy;
  r0.xy = r0.zw / r0.xy;
  r0.zw = cb3[6].xy + v0.xy;
  r1.xyzw = float4(0,0,0,-1);
  while (true) {
    r2.x = cmp(3 < (int)r1.w);
    if (r2.x != 0) break;
    r2.x = (int)r1.w;
    r2.x = 0.333333343 * r2.x;
    r2.xy = r2.xx * r0.xy;
    r2.xy = r0.zw * cb3[6].zw + r2.xy;
    r2.xyz = t6.Sample(s1_s, r2.xy).xyz;
    r3.xyz = (int3)r2.xyz & int3(0x7f800000,0x7f800000,0x7f800000);
    r3.xyz = cmp((int3)r3.xyz != int3(0x7f800000,0x7f800000,0x7f800000));
    r2.xyz = r3.xyz ? r2.xyz : float3(65536,65536,65536);
    r1.xyz = r2.xyz + r1.xyz;
    r1.w = (int)r1.w + 1;
  }
  r0.xyz = float3(4.35965421e-006,4.35965421e-006,4.35965421e-006) * r1.xyz;
  r2.xyz = cmp(float3(718.130371,718.130371,718.130371) >= r1.xyz);
  r1.xyz = float3(5.63267313e-005,5.63267313e-005,5.63267313e-005) * r1.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  o0.xyz = v1.xyz * r0.xyz;
  r0.x = t0.Sample(s1_s, v2.xy).w;
  o0.w = v1.w * r0.x;
  return;
}