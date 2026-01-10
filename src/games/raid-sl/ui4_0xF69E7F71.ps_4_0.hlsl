#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 08:36:54 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = cb0[4].xyzw + r0.xyzw;
  r1.x = r0.w * v1.w + -0.00100000005;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r1.xy = w2.xy * cb0[2].xy + cb0[2].zw;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r1.z = -1 + r1.z;
  r1.xy = r1.xy * cb0[3].xy + cb0[3].zw;
  r2.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.x = cb0[6].z * r1.z + 1;
  r1.x = cb0[6].y * r1.x;
  o0.xyz = r2.xyz * r1.xxx + r0.xyz;
  o0.w = r0.w;
  o0 *= CUSTOM_UI_ENABLED;
  return;
}