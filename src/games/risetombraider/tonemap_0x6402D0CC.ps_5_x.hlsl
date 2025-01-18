#include "./shared.h"

cbuffer cbColCor : register(b5) {
  float4 g_VigColIn : packoffset(c0);
  float4 g_VigColOut : packoffset(c1);
  float2 g_vScale0 : packoffset(c2);
  float2 g_vOffs0 : packoffset(c2.z);
  float2 g_vScale1 : packoffset(c3);
  float2 g_vOffs1 : packoffset(c3.z);
  float2 g_vHDRTweakHSVMult : packoffset(c4);
  float g_fHDRSplitScreenSDRMultiply : packoffset(c4.z);
  float g_fDualBlend : packoffset(c4.w);
  float g_fHDRSplitScreenBlackBarSize : packoffset(c5);
  float g_fHDRSplitScreenPosition : packoffset(c5.y);
  float2 g_vPad0 : packoffset(c5.z);
  float4 g_Params : packoffset(c6);
  float4 g_VigParams : packoffset(c7);
  float2 g_vGrainScale : packoffset(c8);
  float2 g_vGrainOffs : packoffset(c8.z);
  float3 g_vLutBlends : packoffset(c9);
  uint g_uLutCount : packoffset(c9.w);
  uint g_uWidthRT : packoffset(c10);
  uint g_uHeightRT : packoffset(c10.y);
  uint g_uLookUpDim : packoffset(c10.z);
  uint g_uLutDim : packoffset(c10.w);
}

SamplerState SamplerGenericPointWrap_s : register(s9);
SamplerState SamplerGenericBilinearClamp_s : register(s13);
Texture2D<float4> colorBuffer : register(t0);
Texture2D<float4> lookupTexture : register(t1);
Texture2D<float4> noiseTexture : register(t2);
Texture3D<float4> combinedLut : register(t3);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0, 0);
  r0.xyzw = colorBuffer.Load(r0.xyz).xyzw;
  float3 untonemapped = r0.xyz;
  // r0.xyz = saturate(r0.xyz);

  if (RENODX_TONE_MAP_TYPE == 0) {
    r0.xyz = saturate(r0.xyz);
  } else {
    r0.xyz = renodx::tonemap::renodrt::NeutralSDR(r0.xyz);
  }

  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = min(r0.x, r0.y);
  r0.w = min(r0.z, r0.w);
  r1.x = max(r0.x, r0.y);
  r1.x = max(r1.x, r0.z);
  r0.w = r1.x + r0.w;
  r0.w = 0.5 * r0.w;
  r1.x = max(1.1920929e-07, r0.w);
  r2.xyzw = g_uWidthRT;
  r1.yz = float2(-1, -1) + r2.zw;
  r1.yz = r1.yz / r2.zw;
  r2.zw = float2(0.5, 0.5) / r2.zw;
  r2.xy = v0.xy / r2.xy;
  r3.x = r0.w * r1.y + r2.z;
  r3.yw = float2(0.25, 0.75);
  r4.xyzw = lookupTexture.SampleLevel(SamplerGenericBilinearClamp_s, r3.xy, 0).xyzw;
  r0.w = r4.w / r1.x;
  r4.xyz = -r0.xyz * r0.www + r4.www;
  r0.xyz = r0.xyz * r0.www;
  r3.z = r4.w * r1.y + r2.z;
  r3.xyzw = lookupTexture.SampleLevel(SamplerGenericBilinearClamp_s, r3.zw, 0).xyzw;
  r0.w = -r3.w * 2 + 1;
  r0.xyz = saturate(r0.www * r4.xyz + r0.xyz);
  r0.w = max(r3.x, r3.y);
  r0.w = max(r0.w, r3.z);
  r1.xyw = r3.xyz * r4.www;
  r2.z = 1 + -r4.w;
  r2.z = r2.z * r2.z;
  r2.z = g_Params.w * r2.z;

  if (CUSTOM_FILM_GRAIN_TYPE) {
    r2.z = 0;
  } else {
    r2.z *= CUSTOM_FILM_GRAIN_STRENGTH;
  }

  r0.w = 1 + -r0.w;
  r0.xyz = r0.xyz * r0.www + r1.xyw;
  r1.xy = r2.xy * g_vGrainScale.xy + g_vGrainOffs.xy;
  r2.xy = -g_VigParams.zw + r2.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = sqrt(r0.w);
  r0.w = -g_VigParams.x + r0.w;
  r0.w = saturate(g_VigParams.y * r0.w);
  r3.xyzw = noiseTexture.SampleLevel(SamplerGenericPointWrap_s, r1.xy, 0).xyzw;
  r1.xyw = r2.zzz * r3.xyz + float3(1, 1, 1);
  r0.xyz = r1.xyw * r0.xyz;
  r0.xyz = r0.xyz * r1.zzz + r2.www;

  // r1.xyzw = combinedLut.SampleLevel(SamplerGenericBilinearClamp_s, r0.xyz, 0).xyzw;
  r1.xyz = lerp(r0.xyz, combinedLut.SampleLevel(SamplerGenericBilinearClamp_s, r0.xyz, 0).xyz, CUSTOM_LUT_STRENGTH);

  // r2.xyzw = g_VigColOut.xyzw + -g_VigColIn.xyzw;
  // r0.xyzw = r0.wwww * r2.xyzw + g_VigColIn.xyzw;
  // (t*(b-a)) + a

  r0.xyzw = lerp(g_VigColIn.xyzw, g_VigColOut.xyzw, r0.w * CUSTOM_VIGNETTE);

  r0.xyz = r0.xyz + -r1.xyz;
  o0.xyz = r0.www * r0.xyz + r1.xyz;

  o0.w = 1;

  if (RENODX_TONE_MAP_TYPE != 0) {
    o0.rgb = renodx::draw::ToneMapPass(untonemapped, o0.rgb);
    o0.rgb = max(0, o0.rgb);
  }

  if (CUSTOM_FILM_GRAIN_TYPE == 1.f) {
    o0.rgb = renodx::effects::ApplyFilmGrain(
        o0.rgb,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  }
  o0.rgb *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  return;
}
