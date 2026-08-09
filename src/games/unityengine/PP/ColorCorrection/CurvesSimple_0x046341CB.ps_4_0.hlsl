#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yw = float2(0.125,0.375);
  r1.xyzw = t0.Sample(s0_s, v1.xy).zxyw;
  float3 preCG = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.yzx) : r1.yzx;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(preCG);
  float3 lutInput = injectedData.toneMapType <= 1.f ? preCG : sdrColor;
  if(injectedData.toneMapType >= 2.f){
    r1.yzx = lutInput;
  }
  r0.xz = r1.yz;
  r2.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r2.xyz = float3(0,1,0) * r2.xyz;
  r0.xyz = r0.xyz * float3(1,0,0) + r2.xyz;
  r2.w = log2(r1.w);
  r1.y = 0.625;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.xyz = r1.xyz * float3(0,0,1) + r0.xyz;
  if(injectedData.toneMapType != 0.f){
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = RestoreSaturationLoss(lutInput, r0.xyz);
    r0.xyz = renodx::tonemap::UpgradeToneMap(preCG, min(1.f, lutInput), r0.xyz, 1.f);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  if(injectedData.toneMapType == 0.f){
  r2.xyz = log2(r0.xyz);
  r0.xyzw = cb0[4].zzzz * r2.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  } else {
    r0.xyzw = renodx::math::SignPow(float4(r0.xyz, r2.w), cb0[4].z);
  }
  r0.xyz = r0.xyz * cb0[4].xxx + float3(-0.5,-0.5,-0.5);
  o0.w = r0.w;
  r0.xyz = cb0[4].yyy * r0.xyz + float3(0.5,0.5,0.5);
  r0.w = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r0.xyz = r0.xyz + -r0.www;
  o0.xyz = cb0[2].xxx * r0.xyz + r0.www;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  o0.xyz = lerp(preCG, o0.xyz, injectedData.colorGradeUserLUTStrength);
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