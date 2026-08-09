#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r0.w;
  float3 preCG = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(preCG);
  float3 lutInput = injectedData.toneMapType <= 1.f ? preCG : sdrColor;
  if(injectedData.toneMapType >= 2.f){
    r0.xyz = lutInput;
  }
  r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  r1.xyzw = t1.Sample(s1_s, r0.xx).xyzw;
  o0.x = r1.x;
  r1.xyzw = t1.Sample(s1_s, r0.yy).xyzw;
  o0.y = r1.y;
  r1.xyzw = t1.Sample(s1_s, r0.zz).xyzw;
  o0.z = r1.z;
  if(injectedData.toneMapType != 0.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = RestoreSaturationLoss(lutInput, o0.xyz);
    o0.xyz = renodx::tonemap::UpgradeToneMap(preCG, lutInput, o0.xyz, 1.f);
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