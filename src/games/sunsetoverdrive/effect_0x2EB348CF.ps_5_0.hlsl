#include "./common.hlsl"

cbuffer PSMiscCB : register(b2){
  float4 g_MiscA : packoffset(c0);
  float4 g_MiscB : packoffset(c1);
  float4 g_MiscC : packoffset(c2);
  float4 g_MiscD : packoffset(c3);
}
SamplerState g_LinearClampSampler_s : register(s2);
Texture2D<float4> g_MiscMap0 : register(t5);
StructuredBuffer<float> g_AdaptedLumBuffer : register(t7);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float3 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = g_MiscMap0.Sample(g_LinearClampSampler_s, v1.xy).xyz;
  r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.xyz = r0.xyz / r0.www;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.x = g_AdaptedLumBuffer[1].x;
  r0.w = lerp(1.f, r1.x, injectedData.fxAutoExposure) * r0.w;
  r0.w = saturate(r0.w * g_MiscA.x + g_MiscA.y);
  r0.w = g_MiscA.z * r0.w;
  o0.xyz = r0.xyz * r0.www;
  return;
}