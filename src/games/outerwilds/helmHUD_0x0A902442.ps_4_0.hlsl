#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Dec 20 21:11:42 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[19];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[18].x + cb0[18].y;
  r0.x = cb0[18].z + r0.x;
  r0.x = 0.333333343 * r0.x;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.xyzw = cb0[18].xyzw * r1.xyzw;
  r1.w = saturate(r1.w * r0.x);
  r1.xyz = saturate(r1.xyz);
  r0.xyzw = float4(0.214041144,0.214041144,0.214041144,1) * r1.xyzw;
  r1.x = r0.w * cb0[14].w + -0.00100000005;
  r0.xyzw = cb0[14].xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw;

  r0.x = cmp(r1.x < 0);
  if (r0.x != 0) discard;

  return;
}