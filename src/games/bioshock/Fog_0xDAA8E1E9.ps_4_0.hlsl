#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float Base_hlsl_PSMain09_4bits : packoffset(c0) = {0};
  float4 fogColor : packoffset(c1);
  float3 fogTransform : packoffset(c2);
  float4x3 screenDataToCamera : packoffset(c3);
  float globalScale : packoffset(c6);
  float sceneDepthAlphaMask : packoffset(c6.y);
  float globalOpacity : packoffset(c6.z);
  float distortionBufferScale : packoffset(c6.w);
  float2 wToZScaleAndBias : packoffset(c7);
  float4 screenTransform[2] : packoffset(c8);
  float4x4 worldViewProj : packoffset(c10);
  float3 localEyePos : packoffset(c14);
  float4 vertexClipPlane : packoffset(c15);
  float3 beamColor : packoffset(c16);
  float beamBrightness : packoffset(c16.w);
  float backFadeDistance : packoffset(c17);
  float nearClipFadeDistance : packoffset(c17.y);
  float nearClipPlane : packoffset(c17.z);
  float4x2 dustTexTransform : packoffset(c18);
  float4 unlitColor : packoffset(c20);
  row_major float4x3 localToWorld : packoffset(c21);
}

SamplerState s_sceneDepth_s : register(s0);
SamplerState mtbSampleSlot1_s : register(s1);
SamplerState mtbSampleSlot2_s : register(s2);
Texture2D<float4> s_sceneDepth : register(t0);
Texture2D<float4> mtbSampleSlot1 : register(t1);
Texture2D<float4> mtbSampleSlot2 : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD6,
  float4 v1 : TEXCOORD7,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float3 v5 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy / v0.ww;
  r0.xyzw = s_sceneDepth.Sample(s_sceneDepth_s, r0.xy).xyzw;
  r0.x = -wToZScaleAndBias.x + r0.x;
  r0.x = wToZScaleAndBias.y / r0.x;
  r0.x = -v0.w + r0.x;
  r0.x = saturate(r0.x / backFadeDistance);
  r0.y = dot(v1.xyz, v1.xyz);
  r0.y = rsqrt(r0.y);
  r0.yz = v1.xz * r0.yy;
  r0.z = 0.699999988 * abs(r0.z);
  r1.x = r0.y * -0.5 + 0.5;
  r0.y = r0.z * r0.z;
  r0.y = min(1, r0.y);
  r0.y = 1.42857146 * r0.y;
  r1.yw = v2.yz;
  r2.xyzw = mtbSampleSlot1.Sample(mtbSampleSlot1_s, r1.xy).xyzw;
  r1.z = v2.w + r1.x;
  r1.xyzw = mtbSampleSlot2.Sample(mtbSampleSlot2_s, r1.zw).xyzw;
  r2.xyz = beamColor.xyz * r2.xyz;
  r2.xyz = beamBrightness * r2.xyz;
  r0.yzw = r2.xyz * r0.yyy;
  r0.xyz = r0.yzw * r0.xxx;
  r0.w = -nearClipPlane + v0.w;
  r0.w = saturate(r0.w / nearClipFadeDistance);
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r0.xyz * r1.xyz;
  r1.xyz = unlitColor.xyz * r0.xyz;
  r0.xyz = -r0.xyz * unlitColor.xyz + fogColor.xyz;
  r0.xyz = v0.zzz * r0.xyz + r1.xyz;
  o0.xyz = globalScale * injectedData.FogAmount * r0.xyz;
  o0.w = globalOpacity * v1.w;
  return;
}