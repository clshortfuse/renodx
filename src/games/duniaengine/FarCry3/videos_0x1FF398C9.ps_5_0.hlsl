#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s1_s, v2.xy).w;
  r0.xyz = float3(1.59579468,-0.813476562,0) * r0.xxx;
  r0.w = t0.Sample(s0_s, v2.xy).w;
  r0.xyz = r0.www * float3(1.16412354,1.16412354,1.16412354) + r0.xyz;
  r0.w = t2.Sample(s2_s, v2.xy).w;
  r0.xyz = r0.www * float3(0,-0.391448975,2.01782227) + r0.xyz;
  r0.xyz = float3(-0.87065506,0.529705048,-1.08166885) + r0.xyz;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = v1.xyz * r0.xyz;
  r0.xyz = saturate(r0.xyz);
  r0.w = 1;
  r1.xyz = v1.www * r0.www + -r0.xyz;
  r0.w = saturate(cb0[14].x);
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[19].zzz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = saturate(cb0[19].xxx + r0.xyz);
  r0.xyz = cb0[19].yyy * r0.xyz;
  o0.xyz = PostToneMapScale(r0.xyz);
  o0.w = v1.w;
  return;
}