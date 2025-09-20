#include "./common.hlsl"
#include "./lilium_rcas.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (injectedData.stateCheck == 2.f) {
    r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = ApplyRCAS(r0.xyz, v0, t0, s0_s);
    r0.xyz = applyFilmGrain(r0.xyz, v0, injectedData.fxFilmGrainType != 0.f);
    r0.xyz = PostToneMapScale(r0.xyz);
  } else {
    r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  }
  o0.xyzw = r0.xyzw;
  return;
}