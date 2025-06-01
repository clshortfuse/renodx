// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:26:24 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

SamplerState baseSampler_s : register(s0);
Texture2D<float4> baseTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_POSITION0, float3 v1
          : BINORMAL0, float4 v2
          : COLOR0, float4 v3
          : COLOR1, float2 v4
          : TEXCOORD0, out float4 o0
          : SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = baseTexture.Sample(baseSampler_s, v4.xy).xyzw;
  /* r0.xyz = log2(abs(r0.xyz)); */

  r0.w = v2.w * r0.w;
  r0.w = r0.w * v3.w + 0.000500000024;
  o0.w = min(1, r0.w);

  /* r0.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz); */
  r0.rgb = renodx::color::gamma::Decode(r0.rgb);

  r0.xyz = v2.xyz + r0.xyz;
  r0.xyz = v3.xyz * r0.xyz;
  o0.xyz = r0.xyz;

  return;
}