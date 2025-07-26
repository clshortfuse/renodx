#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jul 26 17:44:20 2025

cbuffer GlobalConstants : register(b0)
{
  float4 Globals[17] : packoffset(c0);
  float4 LightPositions[65] : packoffset(c17);
  float4 LightColors[65] : packoffset(c82);
}

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts[2] : packoffset(c0);
}

SamplerState DiffuseTexture_s : register(s0);
SamplerState DepthTexture_s : register(s1);
SamplerState SkyMaskA_s : register(s5);
SamplerState SkyMaskB_s : register(s6);
Texture2D<float4> DiffuseTexture : register(t0);
Texture2D<float4> DepthTexture : register(t1);
TextureCube<float4> SkyMaskA : register(t5);
TextureCube<float4> SkyMaskB : register(t6);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(InstanceConsts[0].xy);
  r0.x = DepthTexture.Sample(DepthTexture_s, r0.xy).x;
  r0.x = cmp(r0.x < InstanceConsts[0].z);
  r0.x = r0.x ? 0.500000 : 0;
  r1.xyzw = saturate(Globals[8].zwzw * float4(-3,3.5,3.5,6) + InstanceConsts[0].xyxy);
  r0.y = DepthTexture.Sample(DepthTexture_s, r1.xy).x;
  r0.z = DepthTexture.Sample(DepthTexture_s, r1.zw).x;
  r0.yz = cmp(r0.yz < InstanceConsts[0].zz);
  r0.yz = r0.yz ? float2(0.125,0.125) : 0;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r0.z;
  r1.xyzw = saturate(Globals[8].zwzw * float4(-5,-3.5,3,-3) + InstanceConsts[0].xyxy);
  r0.y = DepthTexture.Sample(DepthTexture_s, r1.xy).x;
  r0.z = DepthTexture.Sample(DepthTexture_s, r1.zw).x;
  r0.yz = cmp(r0.yz < InstanceConsts[0].zz);
  r0.yz = r0.yz ? float2(0.125,0.125) : 0;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r0.z;
  r0.y = SkyMaskB.Sample(SkyMaskB_s, InstanceConsts[1].xyz).y;
  r0.z = SkyMaskA.Sample(SkyMaskA_s, InstanceConsts[1].xyz).y;
  r0.y = r0.y + -r0.z;
  r0.y = InstanceConsts[1].w * r0.y + r0.z;
  r1.xyzw = DiffuseTexture.Sample(DiffuseTexture_s, v1.xy).xyzw;
  r1.xyz = r1.xyz * CUSTOM_LENS_FLARE;
  r1.xyzw = v2.xyzw * r1.xyzw;
  r0.z = log2(r1.w);
  r1.xyz = float3(4,4,4) * r1.xyz;
  r0.z = 1.17999995 * r0.z;
  r0.z = exp2(r0.z);
  r1.w = r0.z * r0.y;
  o0.xyzw = r1.xyzw * r0.xxxx;
  return;
}