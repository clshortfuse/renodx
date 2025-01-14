#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 11 03:31:30 2025

SamplerState tex_s : register(s0);
Texture2D<float4> tex : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0;

  r0.xyzw = tex.Sample(tex_s, v2.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;

  o0.rgb = FinalizeOutput(o0.rgb);
  return;
}
