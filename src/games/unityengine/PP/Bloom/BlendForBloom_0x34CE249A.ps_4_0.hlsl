#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, v2.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyzw = saturate(r0.xyzw);
  r0.xyzw = -r0.xyzw * cb0[2].xxxx * injectedData.fxBloom + float4(1,1,1,1);
  r1.xyzw = float4(1,1,1,1) + -r1.xyzw;
  o0.xyzw = -r0.xyzw * r1.xyzw + float4(1,1,1,1);
  } else {
  r0.w = -r0.w * cb0[2].x + 1.f;
  r1.w = 1.f + -r1.w;
  o0.w = -r0.w * r1.w + 1.f;
  r0.xyz = r0.xyz * cb0[2].xxx * injectedData.fxBloom;
  o0.xyz = r1.xyz + (r0.xyz / (1 + r1.xyz));
  }
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