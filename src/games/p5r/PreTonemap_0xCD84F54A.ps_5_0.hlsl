#include "../../shaders/color.hlsl"

cbuffer GFD_PSCONST_HDR : register(b11)
{
  float middleGray : packoffset(c0);
  float adaptedLum : packoffset(c0.y);
  float bloomScale : packoffset(c0.z);
  float starScale : packoffset(c0.w);
  float3 gradeColor : packoffset(c1);
  float elapsedTime : packoffset(c1.w);
  float threshold : packoffset(c2);
  float exposure1 : packoffset(c2.y);
  float exposure2 : packoffset(c2.z);
}

SamplerState sampler0_s : register(s0);
Texture2D<float4> texture0 : register(t0);


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

  r0.xyzw = texture0.Sample(sampler0_s, v1.xy).xyzw;
  r0.w = cmp(0.999000013 >= r0.w);
  r0.w = r0.w ? 1 : 0;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = gradeColor.xyz * r0.xyz;
  r0.w = 1;
  r0.xyz = exposure1 * r0.xyz;
  r1.xyz = -threshold;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.w = max(0, r0.w);
  r1.xyz = float3(1,1,1) + r0.xyz;
  r0.xyz = r0.xyz / r1.xyz;
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  return;
}