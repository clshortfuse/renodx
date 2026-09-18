#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Sep 09 00:36:16 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[5];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0,
  out float o1 : SV_Target1)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v1.z < 0);
  if (r0.x != 0) discard;
  r0.x = cmp(asint(cb4[3].w) != 0);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.y = -cb4[4].x + r1.w;
  o0.w = r1.w;
  r0.y = cmp(r0.y < 0);
  r0.x = r0.x ? r0.y : 0;
  if (r0.x != 0) discard;
  r0.xy = v2.xy / v2.ww;
  r0.zw = v3.xy / v3.ww;
  r0.xy = r0.xy + -r0.zw;
  o0.xy = r0.xy * float2(-8,8) + float2(0.5,0.5);
  o0.z = 0.00999999978 * v2.w;
  o1.x = v0.z;
  // Preserve packed motion/depth data limits before MSAA resolve and filtering.
  if (shader_injection.peak_white_nits >= 48.f && shader_injection.resource_upgrade != 0.f) {
    o0.xyz = saturate(o0.xyz);
  }
  return;
}