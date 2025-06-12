#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed May 28 01:30:14 2025

SamplerState _MainTex_s : register(s0);
SamplerState _UITex_s : register(s1);
Texture2D<float4> _UITex : register(t0);
Texture2D<float4> _MainTex : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = _UITex.Sample(_UITex_s, v0.xy).xyzw;
  r0.xyz *= shader_injection.graphics_white_nits / shader_injection.diffuse_white_nits;
  r1.xyzw = _MainTex.Sample(_MainTex_s, v0.xy).xyzw;

  r0.w = 1 - r0.w;

  //  r0.xyz = r1.xyz * r0.www + r0.xyz;
  // Fix for invalid colors
  r0.xyz = max(0.0, r1.xyz * r0.www + r0.xyz);
  r0.w = 1;
  o0.xyzw = r0.xyzw;

  return;
}