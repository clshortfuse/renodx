#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.xy = r0.xy + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.xy = cb0[2].yx * r0.xx * injectedData.fxVignette;
  r0.x = saturate(r0.x);
  r0.y = -r0.y * 0.1 + 1;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  r1.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  o0.xyzw = r1.xyzw * r0.yyyy;
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