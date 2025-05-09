#include "./common.hlsl"

SamplerState g_CopyBufferMapSampler_s : register(s6);
Texture2D<float4> g_CopyBufferMap : register(t6);

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  o0.xyzw = g_CopyBufferMap.Sample(g_CopyBufferMapSampler_s, v1.xy).xyzw;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}