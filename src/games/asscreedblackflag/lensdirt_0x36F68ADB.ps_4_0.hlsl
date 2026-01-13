#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 23:57:27 2025

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
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = ImageTexture.Sample(ImageTexture_s, v1.xy).xyzw;
  o0.xyzw = (g_LensFlareConsts.m_ColorMul.xyzw * CUSTOM_LENS_DIRT) * r0.xyzw;

  o0.w = saturate(o0.w);
  return;
}