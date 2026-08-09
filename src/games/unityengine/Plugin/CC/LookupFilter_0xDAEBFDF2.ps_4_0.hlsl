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
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float3 preCG = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(preCG);
  if(injectedData.toneMapType != 0.f){
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(sdrColor) : sdrColor;
  }
  r0.xyzw = saturate(r0.xyzw);
  r1.x = 63 * r0.z;
  r1.y = ceil(r1.x);
  r1.z = 0.125 * r1.y;
  r1.z = floor(r1.z);
  r1.y = -r1.z * 8 + r1.y;
  r2.xy = r0.xy * float2(0.123046875,0.123046875) + float2(0.0009765625,0.0009765625);
  r3.x = r1.y * 0.125 + r2.x;
  r1.y = r1.z * 0.125 + r2.y;
  r3.y = -r1.y;
  r3.xyzw = t1.Sample(s1_s, r3.xy).xyzw;
  r1.y = floor(r1.x);
  r1.x = frac(r1.x);
  r1.z = 0.125 * r1.y;
  r1.z = floor(r1.z);
  r1.y = -r1.z * 8 + r1.y;
  r1.z = r1.z * 0.125 + r2.y;
  r2.x = r1.y * 0.125 + r2.x;
  r2.y = -r1.z;
  r2.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
  r1.yzw = r3.xyz + -r2.xyz;
  r1.xyz = r1.xxx * r1.yzw + r2.xyz;
  r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
  if(injectedData.toneMapType == 0.f){
    r1.xyz = lerp(preCG, r1.xyz, injectedData.colorGradeUserLUTStrength);
  } else {
    r1.xyz = RestoreSaturationLoss(sdrColor, r1.xyz);
    r1.xyz = renodx::tonemap::UpgradeToneMap(preCG, sdrColor, r1.xyz, injectedData.colorGradeUserLUTStrength);
  }
  r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  /*r1.xyz = r1.xyz + -r0.xyz;
  r1.w = 0;
  o0.xyzw = cb0[2].xxxx * r1.xyzw + r0.xyzw;*/
  r0.xyz = preCG;
  r1.xyz = r1.xyz + -r0.xyz;
  r1.w = 0;
  o0.xyzw = cb0[2].xxxx * r1.xyzw + r0.xyzw;
  o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
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