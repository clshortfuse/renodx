#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[131];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[130].xy + cb0[130].zw;
  r0.x = t1.SampleBias(s1_s, r0.xy, cb0[19].x).w;
  r0.yzw = t0.SampleBias(s0_s, v1.xy, cb0[19].x).xyz;
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.x = -0.5 + r0.x;
  r0.x = r0.x + r0.x;
  r1.xyz = r0.yzw * r0.xxx;
  r1.xyz = cb0[129].xxx * r1.xyz * injectedData.fxFilmGrain;
  r0.x = renodx::color::y::from::BT709(saturate(r0.yzw));
  r0.x = sqrt(r0.x);
  r0.x = cb0[129].y * -r0.x + 1;
  r0.xyz = r1.xyz * r0.xxx + r0.yzw;
  } else {
    r0.yzw = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.yzw) : r0.yzw;
    r0.xyz = applyFilmGrain(r0.yzw, v1);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}