#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11)
{
  float4 cb11[17];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;


  r0.xyzw = cb11[16].xyzw + v1.xyxy;
  r1.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.xyzw = t0.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r2.xyzw = -cb11[16].xyzw + v1.xyxy;
  r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
  r2.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
  r1.xyzw = r3.xyzw + r1.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r2.xyzw;
  r0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  r1.x = dot(r0.xyzw, float4(1,1,1,1));
  r1.x = cmp(r1.x != r1.x);
  o0.xyzw = r1.xxxx ? float4(0,0,0,0) : r0.xyzw;

  const float3 originalColor = t0.SampleLevel(s0_s, v1.xy, 0).rgb;
  o0.rgb = lerp(originalColor, o0.rgb, injectedData.fxStencil);
  return;
}