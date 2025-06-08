#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Apr 30 12:21:07 2025

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts[15] : packoffset(c0);
}

SamplerState DepthMap_s : register(s0);
SamplerState DiffuseAlpha_s : register(s1);
SamplerState NormalMap_s : register(s2);
SamplerState MPM_s : register(s3);
SamplerState ExtraMask_s : register(s4);
SamplerState SceneNormalMap_s : register(s5);
Texture2D<float4> DepthMap : register(t0);
Texture2D<float4> DiffuseAlpha : register(t1);
Texture2D<float4> NormalMap : register(t2);
Texture2D<float4> MPM : register(t3);
Texture2D<float4> ExtraMask : register(t4);
Texture2D<float4> SceneNormalMap : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  linear noperspective float3 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.z = DepthMap.Sample(DepthMap_s, r0.xy).x;
  r0.xyw = SceneNormalMap.Sample(SceneNormalMap_s, r0.xy).xyz;
  r0.xyw = r0.xyw * float3(2,2,2) + float3(-1,-1,-1);
  r0.x = saturate(dot(r0.xyw, InstanceConsts[12].xyz));
  r0.x = 1 + -r0.x;
  r0.x = -InstanceConsts[8].x + r0.x;
  r0.x = saturate(-r0.x * InstanceConsts[8].y + 1);
  r0.y = r0.z * InstanceConsts[8].z + InstanceConsts[8].w;
  r0.y = 1 / r0.y;
  r0.yzw = v2.xyz * r0.yyy + -InstanceConsts[4].xyz;
  r1.x = dot(InstanceConsts[13].xyz, r0.yzw);
  r1.y = dot(-InstanceConsts[11].xyz, r0.yzw);
  r1.z = dot(InstanceConsts[12].xyz, r0.yzw);
  r0.yzw = r1.xyz * InstanceConsts[5].yxz + float3(0.5,0.5,0.5);
  r1.xyz = cmp(r0.yzw < float3(0,0,0));
  r1.x = (int)r1.y | (int)r1.x;
  r1.x = (int)r1.z | (int)r1.x;
  if (r1.x != 0) discard;
  r1.xyz = float3(1,1,1) + -r0.yzw;
  r1.xyz = cmp(r1.xyz < float3(0,0,0));
  r1.x = (int)r1.y | (int)r1.x;
  r1.x = (int)r1.z | (int)r1.x;
  if (r1.x != 0) discard;
  r1.x = InstanceConsts[6].y * r0.w;
  r0.w = -InstanceConsts[6].x + r0.w;
  r1.y = cmp(0 < r0.w);
  r0.w = -r0.w * InstanceConsts[6].z + 1;
  r0.w = saturate(r1.y ? r0.w : r1.x);
  r1.xy = r0.yz * InstanceConsts[14].zw + InstanceConsts[14].xy;
  r0.yz = r0.yz * InstanceConsts[7].xy + InstanceConsts[7].zw;
  r1.xyzw = ExtraMask.Sample(ExtraMask_s, r1.xy).xyzw;
  r2.x = 1 + -InstanceConsts[6].w;
  r2.x = r2.x * r1.y;
  r1.w = r1.w * InstanceConsts[6].w + r2.x;
  r2.xyzw = DiffuseAlpha.Sample(DiffuseAlpha_s, r0.yz).wxyz;
  r2.yzw = InstanceConsts[9].xyz * r2.yzw;
  r1.w = r2.x * r1.w;
  r2.x = saturate(InstanceConsts[4].w);
  r1.w = r2.x * r1.w;
  r0.w = r1.w * r0.w;
  r0.w = InstanceConsts[9].w * r0.w;
  r0.x = r0.w * r0.x;
  r3.xyz = saturate(InstanceConsts[10].xyz * r0.xxx);
  o0.w = r3.x;
  r1.xyz = r2.yzw * r1.xyz + -r2.yzw;
  o0.xyz = InstanceConsts[6].www * r1.xyz + r2.yzw;
  r1.xyz = NormalMap.Sample(NormalMap_s, r0.yz).xyz;
  r0.xy = MPM.Sample(MPM_s, r0.yz).yz;
  o2.yz = r0.xy;
  r0.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = InstanceConsts[11].xyz * r0.yyy;
  r0.xyw = r0.xxx * InstanceConsts[13].xyz + r1.xyz;
  r0.xyz = r0.zzz * InstanceConsts[12].xyz + r0.xyw;
  o1.xyz = r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
  o1.w = r3.y;
  o2.w = r3.z;
  o2.x = 0;
  o0.rgb = saturate(o0.rgb);
  return;
}