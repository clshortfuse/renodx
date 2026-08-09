#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[50];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[45].xy + cb0[45].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r0.xyz = InvertToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r0.xyz = rolloffSdr(r0.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  r0.xyzw = -cb0[49].yyyy + r0.xyzw;
  o0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  return;
}