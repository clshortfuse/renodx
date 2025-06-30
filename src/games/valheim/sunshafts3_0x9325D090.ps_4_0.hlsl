#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 29 15:53:31 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[9];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = w1.xy * cb0[8].xy + cb0[8].zw;

  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;

  r0.xyzw = saturate(cb0[3].xyzw * r0.xyzw);

  r0.xyzw = float4(1,1,1,1) + -r0.xyzw;

  r1.xy = v1.xy * cb0[7].xy + cb0[7].zw;

  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;

  // lerp, included in following if statement
  // r1.xyzw = float4(1, 1, 1, 1) + -r1.xyzw;
  // o0.xyzw = -r1.xyzw * r0.xyzw + float4(1,1,1,1);

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.xyzw = lerp(1, r1.xyzw, r0.xyzw);
  }
  else {
    o0.xyzw = lerp(100, r1.xyzw, r0.xyzw);  // adjust brightness of rays
    if (RENODX_DISPLAY_MAP == 1.f) {
      o0.rgb = renodx::tonemap::ExponentialRollOff(o0.rgb, 0.9f, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    }
  }
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}