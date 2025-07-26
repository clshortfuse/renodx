#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  9 15:57:03 2025

cbuffer _Globals : register(b0)
{
  float cameraNearTimesFar : packoffset(c0);
  float cameraFarMinusNear : packoffset(c0.y);
  float4 cameraNearFar : packoffset(c1);
  float4x4 colorCorrect : packoffset(c2);
}

SamplerState LinearClampSampler_s : register(s9);
Texture2D<float4> texUvOffset : register(t0);
Texture2D<float4> texColor : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = texUvOffset.Sample(LinearClampSampler_s, v1.xy).xy;
  r0.xy = r0.xy;
  //r0.xy = v1.xy + r0.xy;
  
  if (shader_injection.barrel_distortion == 0) {
    r0.xy = v1.xy;
  } else {
    r0.xy = v1.xy + r0.xy;
  }

  r0.xyz = texColor.Sample(LinearClampSampler_s, r0.xy).xyz;
  r0.xyz = r0.xyz;
  r1.xyz = colorCorrect._m00_m10_m20 * r0.xxx;
  r0.xyw = colorCorrect._m01_m11_m21 * r0.yyy;
  r0.xyw = r1.xyz + r0.xyw;
  r1.xyz = colorCorrect._m02_m12_m22 * r0.zzz;
  r0.xyz = r1.xyz + r0.xyw;
  r1.xyz = float3(1,1,1) * colorCorrect._m03_m13_m23;
  r0.xyz = r1.xyz + r0.xyz;
  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
  return;
}