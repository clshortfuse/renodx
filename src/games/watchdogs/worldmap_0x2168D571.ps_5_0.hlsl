#include "./common.hlsl"

SamplerState PostFxSimple__TextureSampler__SampObj___s : register(s0);
Texture2D<float4> PostFxSimple__TextureSampler__TexObj__ : register(t0);

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = PostFxSimple__TextureSampler__TexObj__.Sample(PostFxSimple__TextureSampler__SampObj___s, v0.xy).xyz;
  o0.xyz = r0.xyz;
  o0.w = 1;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}