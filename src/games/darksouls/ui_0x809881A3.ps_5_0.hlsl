#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Jun 04 23:18:24 2024

SamplerState g_TextureSampler_s : register(s0);
Texture2D<float4> g_Texture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_Position0, float4 v1
          : COLOR0, float2 v2
          : TEXCOORD0, out float4 o0
          : SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_Texture.Sample(g_TextureSampler_s, v2.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;

  o0.xyz = saturate(o0.xyz);
  return;
}