// UI alpha layer

#include "../../shaders/color.hlsl"
#include "./shared.h"

cbuffer Buff1 : register(b1)
{
  float AlphaFade : packoffset(c11);
}

cbuffer HardCodedConstants : register(b12)
{
  float4 g_SampleCoverageULLRegister : packoffset(c0);
  float4 DiffuseTexture_ULLRegister : packoffset(c1);
}

cbuffer DX11Internal : register(b13)
{
  int ClipPlaneBits : packoffset(c0);
  float4 ClipPlanes[8] : packoffset(c1);
  int4 AlphaTest : packoffset(c9);
}

SamplerState DiffuseTexture_S_s : register(s0);
SamplerState _RotatedPoissonTexture_Sampler_s : register(s8);
Texture2D<float4> DiffuseTexture_T : register(t0);
Texture2D<float4> _RotatedPoissonTexture_Tex : register(t8);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : CLIP_SPACE_POSITION0,
  float4 v2 : SV_ClipDistance0,
  float4 v3 : SV_ClipDistance1,
  float4 v4 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.03125,0.03125) * v0.xy;
  r0.xyzw = _RotatedPoissonTexture_Tex.Sample(_RotatedPoissonTexture_Sampler_s, r0.xy).xyzw;
  r0.xy = r0.xx * float2(1,-1) + float2(0,1);
  r0.xy = -g_SampleCoverageULLRegister.xy + r0.xy;
  r0.xy = g_SampleCoverageULLRegister.zw * r0.xy;
  r0.x = r0.x + r0.y;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyzw = DiffuseTexture_T.Sample(DiffuseTexture_S_s, v4.xy).xyzw;
  r0.xyzw = DiffuseTexture_ULLRegister.xyzw + r0.xyzw;
  r0.w = AlphaFade * r0.w;
  r1.x = cmp((int)AlphaTest.x == 1);
  if (r1.x != 0) {
    r1.x = (int)AlphaTest.z;
    r1.x = 0.00392156886 * r1.x;
    r1.y = cmp((int)AlphaTest.y == 5);
    if (r1.y != 0) {
      r1.y = cmp(r1.x >= r0.w);
      if (r1.y != 0) discard;
    } else {
      r1.y = cmp((int)AlphaTest.y == 7);
      if (r1.y != 0) {
        r1.y = cmp(r0.w < r1.x);
        if (r1.y != 0) discard;
      } else {
        r1.y = cmp((int)AlphaTest.y == 4);
        if (r1.y != 0) {
          r1.y = cmp(r1.x < r0.w);
          if (r1.y != 0) discard;
        } else {
          r1.y = cmp((int)AlphaTest.y == 1);
          if (r1.y != 0) {
            if (-1 != 0) discard;
          } else {
            r1.yzw = cmp((int3)AlphaTest.yyy == int3(2,3,6));
            r2.x = cmp(r0.w >= r1.x);
            r2.x = r1.y ? r2.x : 0;
            if (r2.x != 0) discard;
            r2.xy = ~(int2)r1.yz;
            r1.y = r1.z ? r2.x : 0;
            r1.z = cmp(r0.w != r1.x);
            r1.y = r1.z ? r1.y : 0;
            if (r1.y != 0) discard;
            r1.y = r2.x ? r2.y : 0;
            r1.y = r1.w ? r1.y : 0;
            r1.x = cmp(r0.w == r1.x);
            r1.x = r1.x ? r1.y : 0;
            if (r1.x != 0) discard;
          }
        }
      }
    }
  }
  o0.xyzw = r0.xyzw;

  o0 = saturate(o0);
  o0 = injectedData.toneMapGammaCorrection ? pow(o0, 2.2f) : linearFromSRGBA(o0);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}