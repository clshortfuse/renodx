// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 10:11:40 2025

SamplerState s0_s : register(s0);
Texture2D<float4> s0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = s0.Sample(s0_s, v1.xy).xyzw;

  o0.w = saturate(o0.w);
  return;
}