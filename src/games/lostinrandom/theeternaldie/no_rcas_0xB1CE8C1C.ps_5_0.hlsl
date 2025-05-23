#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyz;
  r0.rgb = renodx::color::pq::Decode(r0.rgb);
  r0.rgb = renodx::color::bt709::from::BT2020(r0.rgb);
  if (injectedData.fxFilmGrain > 0.f) {
    r0.rgb = applyFilmGrain(r0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.xyz = PostToneMapScale(r0.xyz);
  o0.w = 1;
  return;
}