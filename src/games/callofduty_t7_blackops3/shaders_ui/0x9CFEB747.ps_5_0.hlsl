// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 11:48:19 2025

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

cbuffer cb3 : register(b3)
{
  float4 cb3[8];
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

  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r1.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r0.zw = float2(0.5,0.5) * cb3[0].xy;
  r0.xy = r0.zw / r0.xy;
  r2.xyz = r1.xyz;
  r0.z = -3;
  while (true) {
    r0.w = cmp(3 < (int)r0.z);
    if (r0.w != 0) break;
    if (r0.z == 0) {
      r0.z = 1;
      continue;
    }
    r0.w = (int)r0.z;
    r0.w = 0.333333343 * r0.w;
    r3.xy = r0.ww * r0.xy + v2.xy;
    r3.xy = max(cb3[7].xy, r3.xy);
    r3.xy = min(cb3[7].zw, r3.xy);
    r3.xyzw = t0.Sample(s1_s, r3.xy).xyzw;
    r3.xyz = r3.xyz + -r1.xyz;
    r3.xyz = r3.www * r3.xyz + r1.xyz;
    r2.xyz = r3.xyz + r2.xyz;
    r0.z = (int)r0.z + 1;
  }
  o0.xyz = float3(0.142857149,0.142857149,0.142857149) * r2.xyz;
  o0.w = r1.w;
  return;
}