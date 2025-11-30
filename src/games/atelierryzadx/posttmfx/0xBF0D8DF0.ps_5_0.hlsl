#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 12:47:48 2025

cbuffer _Globals : register(b0)
{
  float4 g_f4ColorRate : packoffset(c0);
  float g_fVelocity : packoffset(c1);
  float g_fTime : packoffset(c1.y);
  float g_fWaveLength : packoffset(c1.z);
  float g_fAmplitude : packoffset(c1.w);
  float g_fReflaction : packoffset(c2);
}

SamplerState smplScene_s : register(s0);
SamplerState smplCapture_s : register(s1);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplCapture_Tex : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.w = sqrt(r0.z);
  r0.z = rsqrt(r0.z);
  r0.xy = r0.xy * r0.zz;
  r0.z = r0.w / g_fWaveLength;
  r0.z = g_fVelocity * g_fTime + -r0.z;
  r1.x = 0.707106769 + -r0.w;
  r0.w = g_fVelocity * g_fTime + -r0.w;
  r0.w = r0.w / g_fWaveLength;
  r0.w = r0.w * r0.w;
  r0.w = -1.44269502 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = g_fAmplitude * r0.w;
  r1.yz = float2(2,6.28318548) / g_fWaveLength;
  r1.yz = r1.yz * r1.xx;
  r1.x = r0.w * r1.x;
  r1.y = r1.y * r0.z;
  r0.z = 6.28318548 * r0.z;
  r1.w = sin(-r0.z);
  sincos(r0.z, r2.x, r3.x);
  r0.z = r1.y * r2.x + r1.w;
  r0.z = r1.z * r2.x + r0.z;
  r1.x = r3.x * r1.x;
  r0.z = r0.w * r0.z;
  r0.xz = r0.zz * r0.xy;
  r0.y = 1;
  r0.z = dot(r0.xyz, r0.xyz);
  r0.z = rsqrt(r0.z);
  r0.xy = r0.xy * r0.zz;
  r0.xy = r1.xx * r0.xy;
  r0.xy = r0.xy * g_fReflaction + v1.xy;
  r1.xyzw = smplCapture_Tex.Sample(smplCapture_s, r0.xy).xyzw;
  r0.xyz = smplScene_Tex.Sample(smplScene_s, r0.xy).xyz;

  PostTmFxSampleScene(r0.xyz, true);

  r0.w = 1;
  r2.xyzw = g_f4ColorRate.xyzw * r0.xyzw;
  r0.x = -r0.w * g_f4ColorRate.w + 1;
  r2.xyzw = r2.xyzw * r2.wwww;
  o0.xyzw = r1.xyzw * r0.xxxx + r2.xyzw;
  return;
}