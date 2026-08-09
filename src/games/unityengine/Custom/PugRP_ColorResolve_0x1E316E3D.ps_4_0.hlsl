#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[171];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  r0.xyz = cb0[170].xxx * r0.xyz;
  o0.w = max(cb0[169].w, r0.w);
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xy = v1.xy * cb0[162].zw + cb0[131].xy;
  r1.xy = cb0[130].xy * r1.xy;
  r1.xyzw = t0.SampleBias(s0_s, r1.xy, cb0[5].x).xyzw;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = cb0[167].xxx * r1.xyz * injectedData.fxNoise;
  r0.xyz = r1.xyz * (1.0 / 255.0) + r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyz = cb0[169].xyz + -r0.xyz;
  r0.xyz = cb0[169].www * r1.xyz + r0.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.xyz = r0.xyz;
  return;
}