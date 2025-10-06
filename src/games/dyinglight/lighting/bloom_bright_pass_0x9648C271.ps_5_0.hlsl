#include "./lighting.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:45:17 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.SampleLevel(s1_s, float2(0, 0), 0).x;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  o0.w = r1.w;

  r0.rgb = ToneMapBrightPass(r0.rgb);

  r0.xyz = r0.xyz * r0.xyz;
  o0.xyz = float3(0.0625, 0.0625, 0.0625) * r0.xyz;
  return;
}
