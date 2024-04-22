#include "../../common/color.hlsl"
#include "./shared.h"

// Letterbox/fade

cbuffer Buff1 : register(b1) {
  float4 GenericTint1 : packoffset(c0);
  float AlphaFade : packoffset(c11);
}

cbuffer HardCodedConstants : register(b12) {
  float4 g_SampleCoverageULLRegister : packoffset(c0);
}

cbuffer DX11Internal : register(b13) {
  int ClipPlaneBits : packoffset(c0);
  float4 ClipPlanes[8] : packoffset(c1);
  int4 AlphaTest : packoffset(c9);
}

SamplerState _RotatedPoissonTexture_Sampler_s : register(s8);
Texture2D<float4> _RotatedPoissonTexture_Tex : register(t8);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float4 v1 : CLIP_SPACE_POSITION0, float4 v2 : SV_ClipDistance0, float4 v3 : SV_ClipDistance1, out float4 o0 : SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.03125, 0.03125) * v0.xy;
  r0.xyzw = _RotatedPoissonTexture_Tex.Sample(_RotatedPoissonTexture_Sampler_s, r0.xy).xyzw;
  r0.xy = r0.xx * float2(1, -1) + float2(0, 1);
  r0.xy = -g_SampleCoverageULLRegister.xy + r0.xy;
  r0.xy = g_SampleCoverageULLRegister.zw * r0.xy;
  r0.x = r0.x + r0.y;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = AlphaFade * GenericTint1.w;
  r0.y = cmp((int)AlphaTest.x == 1);
  if (r0.y != 0) {
    r0.y = (int)AlphaTest.z;
    r0.y = 0.00392156886 * r0.y;
    r0.z = cmp((int)AlphaTest.y == 5);
    if (r0.z != 0) {
      r0.z = cmp(r0.y >= r0.x);
      if (r0.z != 0) discard;
    } else {
      r0.z = cmp((int)AlphaTest.y == 7);
      if (r0.z != 0) {
        r0.z = cmp(r0.x < r0.y);
        if (r0.z != 0) discard;
      } else {
        r0.z = cmp((int)AlphaTest.y == 4);
        if (r0.z != 0) {
          r0.z = cmp(r0.y < r0.x);
          if (r0.z != 0) discard;
        } else {
          r0.z = cmp((int)AlphaTest.y == 1);
          if (r0.z != 0) {
            if (-1 != 0) discard;
          } else {
            r1.xyz = cmp((int3)AlphaTest.yyy == int3(2, 3, 6));
            r0.z = cmp(r0.x >= r0.y);
            r0.z = r0.z ? r1.x : 0;
            if (r0.z != 0) discard;
            r0.zw = ~(int2)r1.xy;
            r1.x = r1.y ? r0.z : 0;
            r1.y = cmp(r0.x != r0.y);
            r1.x = r1.y ? r1.x : 0;
            if (r1.x != 0) discard;
            r0.z = r0.z ? r0.w : 0;
            r0.z = r1.z ? r0.z : 0;
            r0.y = cmp(r0.x == r0.y);
            r0.y = r0.y ? r0.z : 0;
            if (r0.y != 0) discard;
          }
        }
      }
    }
  }
  o0.xyz = GenericTint1.xyz;
  o0.w = r0.x;
  o0 = saturate(o0);
  o0 = injectedData.toneMapGammaCorrection ? pow(o0, 2.2f) : linearFromSRGBA(o0);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
