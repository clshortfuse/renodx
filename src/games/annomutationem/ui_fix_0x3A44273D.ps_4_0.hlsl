#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat May 31 23:11:05 2025

SamplerState _UITex_s : register(s0);
Texture2D<float4> _UITex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = _UITex.Sample(_UITex_s, v0.xy).xyzw;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;

  o0.xyz *= max(0, shader_injection.graphics_white_nits / shader_injection.diffuse_white_nits);
  return;
}