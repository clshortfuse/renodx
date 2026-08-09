#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyzw = cb0[3].xyzw + -r0.xyzw;
  o0.xyzw = cb0[4].xxxx * r1.xyzw + r0.xyzw;
  if (injectedData.toneMapType == 0.f) {
    o0.xyz = saturate(o0.xyz);
  }
  if (injectedData.gammaSpace != 0.f) {
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if (injectedData.gammaSpace != 0.f) {
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  o0.w = saturate(o0.w);
  return;
}