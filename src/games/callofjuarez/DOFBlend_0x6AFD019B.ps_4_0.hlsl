#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Sat Jan 24 00:40:17 2026

SamplerState samScreen_s : register(s0);
SamplerState samScreen_Blurred_s : register(s1);
Texture2D<float4> sScreen : register(t0);
Texture2D<float4> sScreen_Blurred : register(t1);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sScreen_Blurred.Sample(samScreen_Blurred_s, v1.xy).xyzw;

  r1.xyzw = sScreen.Sample(samScreen_s, v1.xy).xyzw;
  if (RENODX_TONE_MAP_TYPE <= 0.f) {
    r0.xyzw = saturate(r0.xyzw);
    r1.xyzw = saturate(r1.xyzw);
  }
  r1.xyzw = max(0, r1.xyzw);
  r0.xyz = max(0, -r1.xyz + r0.xyz);
  //r0.w = max(0, r0.w);
  r0.w = r1.w * 2 + -1;
  r0.w = max(0, r0.w);

  if (RENODX_TONE_MAP_TYPE <= 0.f) {
    o0.xyz = saturate(r0.www * r0.xyz + r1.xyz);
  }
  else {
    o0.xyz = max(0, r0.www * r0.xyz + r1.xyz);
  }
  r0.x = r1.w * -2 + 1;
  o0.w = max(0, r0.x); // Alpha clamp

  return;
}