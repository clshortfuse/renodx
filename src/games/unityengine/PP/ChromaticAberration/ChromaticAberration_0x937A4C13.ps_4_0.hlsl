#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[7].xx * cb0[6].xy * injectedData.fxCA;
  r0.zw = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.zw + r0.zw;
  r0.xy = r0.xy * r0.zw;
  r0.z = dot(r0.zw, r0.zw);
  r0.xy = -r0.xy * r0.zz + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  o0.y = r0.y;
  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.xzw = r0.xzw;
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