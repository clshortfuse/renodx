#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[134];
}

float getNewPeak(float oldPeak){
  float maxBrightness = max(cb0[133].z, max(cb0[133].x, cb0[133].y));
  float maxContrast = max(cb0[132].z, max(cb0[132].x, cb0[132].y));
  if(maxBrightness <= 1.f && maxContrast <= 1.f){return oldPeak;}
  else {
    return (oldPeak - 0.5f + 0.5f * maxContrast) / (maxContrast * maxBrightness);
  }
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
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = applyUserTonemapNeutral(r0.xyz, getNewPeak(injectedData.toneMapPeakNits));
  r0.xyz = r0.xyz * cb0[133].xyz + float3(-0.5,-0.5,-0.5);
  r0.xyz = r0.xyz * cb0[132].xyz + float3(0.5,0.5,0.5);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}