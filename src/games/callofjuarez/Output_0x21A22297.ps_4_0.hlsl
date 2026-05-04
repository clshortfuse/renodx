#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Sun Jan 25 21:40:22 2026

SamplerState sSam_s : register(s0);
SamplerState sSam1_s : register(s1);
Texture2D<float4> sTex0 : register(t0);
Texture2D<float4> sTex1 : register(t1);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sTex0.Sample(sSam_s, v1.xy).xyzw;
  r1.xyzw = sTex1.Sample(sSam1_s, v1.xy).xyzw;
  // o0.xyzw = r1.xyzw * float4(0.800000012,0.800000012,0.800000012,0.800000012) + r0.xyzw;
  o0.xyzw = r1.xyzw * (0.8 * CUSTOM_VOLUMETRICS_AMOUNT) + r0.xyzw;

  // Normally SDR would be saturated up to this point,
  // but since we got a lot of stuff unclamped,
  // we have to put an explicit one here.
  if (RENODX_TONE_MAP_TYPE <= 0.f) {
    o0.xyzw = saturate(o0.xyzw);
  }
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}