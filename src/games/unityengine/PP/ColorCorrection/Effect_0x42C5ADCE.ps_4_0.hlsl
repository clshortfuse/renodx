#include "../../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float3 preCG = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(preCG);
  float3 lutInput = injectedData.toneMapType <= 1.f ? preCG : sdrColor;
    r0.xyz = lutInput;
  r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  r1.xyzw = t2.Sample(s2_s, r0.xx).xyzw;
  r1.x = 9.99999975e-06 + r1.x;
  r2.xyzw = t2.Sample(s2_s, r0.yy).xyzw;
  r1.y = 1.99999995e-05 + r2.y;
  r2.xyzw = t2.Sample(s2_s, r0.zz).xyzw;
  r1.z = 2.99999992e-05 + r2.z;
  r2.xyzw = t1.Sample(s1_s, r0.xx).xyzw;
  r0.x = 9.99999975e-06 + r2.x;
  r2.xyzw = t1.Sample(s1_s, r0.yy).xyzw;
  r0.y = 1.99999995e-05 + r2.y;
  r2.xyzw = t1.Sample(s1_s, r0.zz).xyzw;
  r0.z = 2.99999992e-05 + r2.z;
  r1.w = r0.w;
  r1.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = cb0[2].xxxx * r1.xyzw + r0.xyzw;
  if(injectedData.toneMapType != 0.f){
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = RestoreSaturationLoss(lutInput, r0.xyz);
    r0.xyz = renodx::tonemap::UpgradeToneMap(preCG, lutInput, r0.xyz, 1.f);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  o0.xyzw = r0.xyzw;
  return;
}