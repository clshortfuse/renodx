#include "../common.hlsl"

Texture3D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : VAR_UV0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r1.xy = cb0[2].yy * r0.xy;
  r0.xy = r1.xy * r0.zz + r0.xy;
  r0.xy = r0.xy * cb0[2].zz + float2(0.5,0.5);
  r1.xyz = t1.Sample(s1_s, r0.xy).xyz;
  r1.xyz = cb0[0].xxx * r1.xyz * injectedData.fxBloom;
  r1.xyz = float3(8,8,8) * r1.xyz;
  r2.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r1.xyz = r2.xyz * float3(8,8,8) + r1.xyz;
  r1.xyz = cb0[0].www * r1.xyz;
  r1.xyz = lutShaper(r1.xyz);
  r1.xyz = r1.xyz * cb0[0].yyy + cb0[0].zzz;
  r1.xyz = t2.SampleLevel(s1_s, r1.xyz, 0).xyz;
  r0.zw = r0.xy * r0.xy + float2(-1,-1);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = saturate(r0.x * cb0[1].w + cb0[2].x);
  r0.yz = saturate(float2(33.3333664,33.3333664) * r0.zw);
  r2.xy = r0.yz * float2(-2,-2) + float2(3,3);
  r0.yz = r0.yz * r0.yz;
  r0.yz = -r2.xy * r0.yz + float2(1,1);
  r0.yzw = r0.yyy * r0.zzz + -cb0[1].xyz;
  r1.w = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r1.w * r0.x;
  r0.xyz = r0.xxx * r0.yzw + cb0[1].xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = r0.xyz * cb0[6].www + cb0[6].xyz;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}