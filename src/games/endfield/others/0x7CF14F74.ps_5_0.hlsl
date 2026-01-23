// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 22:02:47 2025

// Blit shader

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.SampleLevel(s0_s, v1.xy, cb0[2].x).xyz;
  o0.xyz = r0.xyz;
  o0.w = 0;
  return;
}