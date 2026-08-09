#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = cb0[3].xyz;
  r1.w = r0.w;
  r0.xyzw = r0.xyzw * cb0[2].xxxx + -r1.xyzw;
  r0.xyzw = r0.xyzw * cb0[2].yyyy + r1.xyzw;
  r0.w = saturate(r0.w);
  if(injectedData.toneMapType == 0.f){
  r0.xyzw = saturate(r0.xyzw);
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = cb0[2].zzzz * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  } else {
    r0.xyzw = renodx::math::SignPow(r0.xyzw, cb0[2].z);
  }
  if(injectedData.gammaSpace != 0.f){
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}