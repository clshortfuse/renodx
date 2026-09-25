#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  }
  return;
}