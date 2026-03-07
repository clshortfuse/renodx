// ---- Created with 3Dmigoto v1.4.1 on Sat Mar  7 15:40:05 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  //r0 = saturate(r0);
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1 = saturate(r1);
  o0.xyzw = cb0[1].zzzz * r1.xyzw + r0.xyzw;
  return;
}