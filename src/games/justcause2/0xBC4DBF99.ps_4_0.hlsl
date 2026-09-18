#include "shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Sep 09 00:22:30 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Preserve the original bounded exposure statistics without clipping scene HDR.
  bool preserve_sdr_exposure = shader_injection.peak_white_nits >= 48.f
      && shader_injection.resource_upgrade != 0.f;

  r0.xy = cb1[0].xy + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if (preserve_sdr_exposure) r0.xyz = saturate(r0.xyz);
  r0.x = dot(r0.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r0.yz = cb1[1].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  if (preserve_sdr_exposure) r1.xyz = saturate(r1.xyz);
  r0.y = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r0.x = r0.x + r0.y;
  r0.yz = cb1[2].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  if (preserve_sdr_exposure) r1.xyz = saturate(r1.xyz);
  r0.y = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r0.x = r0.x + r0.y;
  r0.yz = cb1[3].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  if (preserve_sdr_exposure) r1.xyz = saturate(r1.xyz);
  r0.y = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r0.x = r0.x + r0.y;
  o0.xyz = float3(0.25,0.25,0.25) * r0.xxx;
  o0.w = 1;
  return;
}