#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD2,
  uint v4 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s0_s, v1.xy).w;
  r0.y = t1.Sample(s1_s, v1.zw).w;
  r0.xyz = r0.yyy * float3(1.40199995,-0.714139998,0) + r0.xxx;
  r0.w = t2.Sample(s2_s, v1.zw).w;
  r0.xyz = r0.www * float3(0,-0.344139993,1.77199996) + r0.xyz;
  r0.xyz = float3(-0.700999975,0.529139996,-0.885999978) + r0.xyz;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = v2.xyz * r0.xyz;
  r0.xyz = saturate(r0.xyz);
  r0.w = 1;
  r1.xyz = v2.www * r0.www + -r0.xyz;
  r0.w = v2.w * r0.w + -1;
  o0.w = cb0[8].w * r0.w + 1;
  r0.w = saturate(cb0[8].z);
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = cb0[6].zzz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = saturate(r0.xyz * cb0[6].yyy + cb0[6].xxx);
  r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
  r1.xyz = float3(0.947867274,0.947867274,0.947867274) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  r0.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  o0.xyz = PostToneMapScale(r0.xyz);
  return;
}