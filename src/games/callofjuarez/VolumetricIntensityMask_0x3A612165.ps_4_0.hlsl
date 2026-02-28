#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Sun Jan 25 22:10:11 2026

SamplerState samBackbuffer_s : register(s0);
SamplerState samMask_s : register(s1);
Texture2D<float4> sBackbuffer : register(t0);
Texture2D<float4> sMask : register(t1);


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

  r0.xyzw = sBackbuffer.Sample(samBackbuffer_s, v1.xy).xyzw;
  r1.x = dot(r0.xyz, float3(0.333333343, 0.333333343, 0.333333343));
  // In HDR, we actually have to clamp input to 0.0-1.0 range,
  // otherwise the intensity of volumetric explodes and clips out.
  // If it's clipped, it actually matches SDR, without clipping the overall final HDR output.
  // But, since in SDR, it would naturally clip, even though the vanilla code didn't have an explicit saturate call,
  // we apply saturate to both HDR and SDR for the best simulation of vanilla behavior.
  r0.xyzw = saturate(r1.xxxx * r0.xyzw);
  r1.xyzw = sMask.Sample(samMask_s, v1.zw).xyzw;
  o0.xyzw = r1.xyzw * r0.xyzw;
  return;
}