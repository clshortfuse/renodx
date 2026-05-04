#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Nov 21 00:09:08 2025

cbuffer LensFlareConstscb : register(b5)
{

  struct
  {
    float4x4 m_flareRot;
    float4 m_ColorMul;
    float4 m_SunCenter;
    float4 m_ColorBias;
  } g_LensFlareConsts : packoffset(c0);

}

SamplerState ImageTexture_s : register(s0);
Texture2D<float4> ImageTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = g_LensFlareConsts.m_SunCenter.xy + -v1.zw;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = -g_LensFlareConsts.m_SunCenter.z + r0.x;
  r0.x = max(0, r0.x);
  r0.xyz = g_LensFlareConsts.m_ColorBias.xyz * r0.xxx;
  r1.xyzw = ImageTexture.Sample(ImageTexture_s, v1.xy).xyzw;
  r1.xyzw = g_LensFlareConsts.m_ColorMul.xyzw * r1.xyzw;
  r0.xyz = -r0.xyz * g_LensFlareConsts.m_SunCenter.www + r1.xyz;
  o0.w = r1.w;
  o0.xyz = max(float3(0,0,0), r0.xyz);

  o0.rgb *= CUSTOM_LENS_DIRT;
  return;
}