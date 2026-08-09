#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[2].zw * v0.xy;
  r0.xy = floor(r0.xy);
  r0.zw = float2(0.5,0.5) * cb0[3].xy;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[3].zzz + float3(0.5,0.5,0.5);
  r0.xyz = cb0[3].www * r0.xyz;
  r0.w = asuint(cb0[2].x);
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = (uint3)r0.xyz;
  r0.xyz = (uint3)r0.xyz;
  o0.xyz = r0.xyz / r0.www;
  o0.w = 1;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}