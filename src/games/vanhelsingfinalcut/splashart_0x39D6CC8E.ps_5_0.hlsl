#include "./common.hlsl"

SamplerState g_sTexture_s : register(s0);
Texture2D<float4> g_tTexture : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = g_tTexture.Sample(g_sTexture_s, v1.xy).xyz;
  r0.rgb = renodx::color::gamma::Decode(r0.rgb);
  o0.xyz = PostToneMapScale(r0.xyz);
  o0.w = 1;
  return;
}