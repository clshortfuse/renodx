// Lens Flare Texture Overlay

#include "./shared.h"

Texture2DArray<float4> t0 : register(t0);
Buffer<uint4> t1 : register(t1);

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11)
{
  float4 cb11[157];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;
  float4 coord = float4(v1.x, v1.y, w1.x, w1.y);

  r0.x = t1.Load(cb11[136].x).x;
  r0.x = (uint)r0.x;
  r0.y = 0.00999999978 + w1.x;
  r0.y = (int)r0.y;
  r0.y = (uint)r0.y << 1;
  r0.x = saturate(cb11[r0.y+138].x * r0.x);
  r1.xyzw = cb11[r0.y+137].xyzw * cb11[r0.y+137].wwww;
  r0.xyzw = saturate(r1.xyzw * r0.xxxx);
  r1.xyzw = t0.Sample(s0_s, coord.xyzw).xyzw;
  // o0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyzw = r1.xyzw * r0.xyzw * injectedData.fxLensFlare;
  return;
}