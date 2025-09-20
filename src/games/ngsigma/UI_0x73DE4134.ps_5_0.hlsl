#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Fri Jul 11 23:32:33 2025

cbuffer FParam : register(b1)
{

  struct
  {
    float4 gColorMulComponent_;
    float4 gColorAddComponent_;
    float2 gTextureSize_;
    float2 gTextureSizeR_;
    float gAlpha_;
    float2 gModulateTextureScale_;
  } gFragmentParam : packoffset(c0);

}

SamplerState gSampler_s : register(s0);
Texture2D<float4> gTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = gTexture.Sample(gSampler_s, v1.xy).xyzw;
  r0.xyzw = gFragmentParam.gColorMulComponent_.xyzw * r0.xyzw;
  r0.xyzw = gFragmentParam.gColorAddComponent_.xyzw + r0.xyzw;
  r0.xyzw = gFragmentParam.gAlpha_ * r0.xyzw;
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  r0.xyzw = min(float4(1,1,1,1), r0.xyzw);
  o0.xyzw = r0.xyzw;

  // scale UI instead of game scene, since there's no shader that has the game scene alone
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb); 

  return;
}