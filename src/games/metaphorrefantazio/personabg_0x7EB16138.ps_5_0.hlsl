// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:26:06 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

SamplerState diffuseSampler_s : register(s0);
Texture2D<float4> diffuseTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_POSITION0, float4 v1
          : COLOR0, float2 v2
          : TEXCOORD0, out float4 o0
          : SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = diffuseTexture.Sample(diffuseSampler_s, v2.xy).xyzw;
  /* r1.xyz = log2(abs(r0.xyz));
  r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
  r0.xyz = exp2(r1.xyz); */

  r0.rgb = renodx::color::gamma::Decode(r0.rgb);

  // We want this to scale with UI
  r0.rgb = restoreLuminance(r0.rgb);
  o0.xyzw = v1.xyzw * r0.xyzw;
  return;
}