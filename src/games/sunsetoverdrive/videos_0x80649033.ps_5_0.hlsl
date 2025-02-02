#include "./common.hlsl"

SamplerState g_BinkMap0Sampler_s : register(s5);
SamplerState g_BinkMap1Sampler_s : register(s6);
SamplerState g_BinkMap2Sampler_s : register(s7);
Texture2D<float4> g_BinkMap0 : register(t5);
Texture2D<float4> g_BinkMap1 : register(t6);
Texture2D<float4> g_BinkMap2 : register(t7);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_BinkMap2.Sample(g_BinkMap2Sampler_s, v1.xy).w;
  r0.xyz = float3(0,-0.391448975,2.01782227) * r0.xxx;
  r0.w = g_BinkMap1.Sample(g_BinkMap1Sampler_s, v1.xy).w;
  r0.xyz = r0.www * float3(1.59579468,-0.813476562,0) + r0.xyz;
  r0.w = g_BinkMap0.Sample(g_BinkMap0Sampler_s, v1.xy).w;
  r0.xyz = r0.www * float3(1.16412354,1.16412354,1.16412354) + r0.xyz;
  o0.xyz = float3(-0.87065506,0.529705048,-1.08166885) + r0.xyz;
  o0.w = 1;
  o0.rgb = saturate(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}