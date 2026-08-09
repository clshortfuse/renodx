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
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float3 source = r1.xyz;
  float3 preCG = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(preCG);
  float3 lutInput = injectedData.toneMapType <= 1.f ? preCG : sdrColor;
    r1.xyz = lutInput;
  r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  r0.xz = r1.xy;
  r2.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r2.xyz = float3(0,1,0) * r2.xyz;
  r0.xyz = r0.xyz * float3(1,0,0) + r2.xyz;
  r2.y = 0.625;
  r2.x = r1.z;
  r2.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
  r0.xyz = r2.xyz * float3(0,0,1) + r0.xyz;
  if(injectedData.toneMapType != 0.f){
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = RestoreSaturationLoss(lutInput, r0.xyz);
    r0.xyz = renodx::tonemap::UpgradeToneMap(preCG, lutInput, r0.xyz, 1.f);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r0.w = dot(r0.xyz, float3(0.0396819152,0.45802179,0.00609653955));
  //r2.xyz = r1.yxx + r1.zzy;
  r2.xyz = source.yxx + source.zzy;
  //r1.xyz = -r2.xyz * cb0[4].xxx + r1.xyz;
  r1.xyz = -r2.xyz * cb0[4].xxx + source.xyz;
  o0.w = r1.w;
  r1.xyz = r1.xyz * cb0[3].xyz + r0.www;
  r0.xyz = -r1.xyz + r0.xyz;
  o0.xyz = cb0[2].xxx * r0.xyz + r1.xyz;
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