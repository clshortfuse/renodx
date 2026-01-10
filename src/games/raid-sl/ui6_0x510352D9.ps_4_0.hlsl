#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 08:56:30 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[5];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[4].zw + -cb0[4].xy;
  r0.xy = -abs(v4.xy) + r0.xy;
  r0.xy = saturate(v4.zw * r0.xy);
  r0.x = r0.x * r0.y;
  r0.y = 255 * v1.w;
  r0.y = round(r0.y);
  r1.w = 0.00392156886 * r0.y;
  r2.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r2.xyzw = cb0[3].xyzw + r2.xyzw;
  r1.xyz = v1.xyz;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r0.x = r1.w * r0.x;
  o0.xyz = r1.xyz * r0.xxx;
  o0.w = r0.x;
  o0 *= CUSTOM_UI_ENABLED;
  return;
}