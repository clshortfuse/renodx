#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Sun Jan 25 22:10:23 2026

SamplerState sSam0_s : register(s0);
Texture2D<float4> sColor0 : register(t0);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float midgray = 0.18 * RENODX_DIFFUSE_WHITE_NITS;
  float4 output = midgray * pow(sColor0.Sample(sSam0_s, v1.xy).xyzw / midgray, 1.0 + CUSTOM_BLOOM_THRESHOLD * 0.1);
  /*
  if (RENODX_TONE_MAP_TYPE <= 0.f) {
    o0.xyzw = sColor0.Sample(sSam0_s, v1.xy).xyzw;
  } else {
    o0.xyzw = output;
  }
  */
  o0.xyzw = output;
  return;
}