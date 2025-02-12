#include "./common.hlsl"

SamplerState s0Sampler_s : register(s0);
Texture2D<float4> s0 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s0.Sample(s0Sampler_s, v1.zw).xyzw;
  o0.w = r0.w;
  r0.rgb = applyUserTonemap(r0.rgb);
  r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  o0.xyz = PostToneMapScale(r0.rgb);
  return;
}