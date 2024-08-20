// ---- Created with 3Dmigoto v1.3.16 on Tue Mar 19 16:32:08 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11)
{
  float4 cb11[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.00100000005 + cb11[0].w;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r0.yz = cb11[0].xx * r1.xy;
  r0.yz = max(float2(-1,-1), r0.yz);
  r0.yz = min(float2(1,1), r0.yz);
  r0.w = dot(r0.yz, r0.yz);
  r0.w = min(1, r0.w);
  r0.w = log2(r0.w);
  r0.x = r0.x * r0.w;
  r0.x = exp2(r0.x);
  r0.xy = r0.yz * r0.xx;
  o0.xy = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.x = cmp(0 < r1.w);
  o0.z = 0.0199999996 * r1.z;
  o0.w = r0.x ? 1.000000 : 0;
  return;
}