#include "./shared.h"
#include "./lilium_rcas.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 25 03:07:17 2025

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float fTextureSampleBias : packoffset(c4) = {0};
  float4x4 matFarCloudShadowProjectionTexScale : packoffset(c5);
  float3 vecScreenSize : packoffset(c9);
  float4 vecInvScreenSize : packoffset(c10);
  float2 vecBlurSize : packoffset(c11);
  float4 srcTargetSize : packoffset(c12);
  float4 dstTargetSize : packoffset(c13);
  float2 sharpenWeight : packoffset(c14);
  float2 viewportJitter : packoffset(c14.z);
  float hdrDisplayGamma : packoffset(c15) = {1};
  float hdrDisplayMiddle : packoffset(c15.y) = {0.800000012};
  float hdrDisplayMaxNits : packoffset(c15.z) = {1000};
  float hdrDisplayWhiteNits : packoffset(c15.w) = {200};
  float3 vecViewPosition : packoffset(c16);
  float4 vecBlurDirection : packoffset(c17);
  float2 fIntensityScale : packoffset(c18);
  float2 g_InvRTSize : packoffset(c18.z);
  float4x4 g_invViewProjTM : packoffset(c19);
  float4x4 g_preInvViewProjTM : packoffset(c23);
  float4x4 g_preViewProjTM : packoffset(c27);
  float g_Roughness : packoffset(c31) = {0.5};
  int g_MaxMipMap : packoffset(c31.y) = {6};
  int g_CurrentMipmap : packoffset(c31.z) = {0};
}

cbuffer GraphicUltraConst : register(b2)
{
  bool isGraphicUltra : packoffset(c0);
  bool isTAA : packoffset(c0.y);
  uint uFrameCount : packoffset(c0.z);
  float GraphicUltraConstFloatDummy : packoffset(c0.w);
}

cbuffer copyConst : register(b3)
{
  float blurDepthRate : packoffset(c0);
  float blurDepthBias : packoffset(c0.y) = {0};
  float fContrast : packoffset(c0.z) = {1};
  float fTime : packoffset(c0.w);
  float vignettingRate : packoffset(c1) = {0};
  bool isLUT : packoffset(c1.y);
  bool isPostFilter : packoffset(c1.z);
  float blurScale : packoffset(c1.w) = {1};
  float4 texCropScale : packoffset(c2) = {1,1,0,0};
  bool isRenderCharacterBlur : packoffset(c3);
  float3 translateAndScale : packoffset(c3.y) = {1,1,1};
  float2 copyToBackBufferDynamicResolution : packoffset(c4) = {1,1};
  float2 dynamicResolutionNormalizeRatio : packoffset(c4.z) = {1,1};
  float2 dynamicResolutionSharpenWeight : packoffset(c5) = {1,1};
  float lutLerp : packoffset(c5.z);
  float dummyFloat : packoffset(c5.w);
}

SamplerState PA_POINT_CLAMP_FILTER_s : register(s0);
SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s1);
Texture2D<float4> texDepthRaw : register(t0);
Texture2D<float4> texNormalSmall : register(t1);
Texture2D<float4> texHDR : register(t2);
Texture3D<float4> texLut : register(t3);
Texture2D<float4> texBackBuffer : register(t4);


// 3Dmigoto declarations
#define cmp -


// Composite pass that reprojects history, applies optional character blur, and final post fixes.
void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Handle UI scaling and crop adjustments before sampling.
  r0.x = cmp(translateAndScale.x != 1.000000);
  if (r0.x != 0) {
    r0.xy = v1.xy * translateAndScale.zz + translateAndScale.xy;
    o0.w = 1;
  } else {
    r0.zw = cmp(float2(1,1) < texCropScale.xy);
    r0.z = (int)r0.w | (int)r0.z;
    r1.xy = v1.xy * texCropScale.xy + texCropScale.zw;
    r1.zw = cmp(r1.xy < float2(0,0));
    r0.w = (int)r1.w | (int)r1.z;
    r1.zw = cmp(float2(1,1) < r1.xy);
    r0.w = (int)r0.w | (int)r1.z;
    r0.w = (int)r1.w | (int)r0.w;
    if (r0.w != 0) {
      r1.zw = float2(-0.5,-0.5) + r1.xy;
      r1.zw = saturate(float2(-0.5,-0.5) + abs(r1.zw));
      r0.w = max(r1.z, r1.w);
      r0.w = log2(r0.w);
      r0.w = 0.25 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = 0.25 + r0.w;
      r0.w = min(1, r0.w);
      o0.xyz = float3(0.200000003,0.200000003,0.200000003) * r0.www;
      o0.w = 1;
      if (r0.z != 0) return;
    }
    r0.xy = r0.zz ? r1.xy : v1.xy;
    o0.w = translateAndScale.z;
  }
  // Convert UV to pixel space so jitter and normalization align with dispatch resolution.
  r0.zw = vecScreenSize.xy * r0.xy;
  r0.zw = trunc(r0.zw);
  r0.xy = r0.xy * vecScreenSize.xy + -r0.zw;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r1.xy = r0.xy + r0.xy;
  r1.zw = cmp(float2(0,0) < r0.xy);
  r0.xy = cmp(r0.xy < float2(0,0));
  r0.xy = (int2)r0.xy + (int2)-r1.zw;
  r0.xy = (int2)r0.xy;
  r1.zw = float2(1,1) + -dynamicResolutionNormalizeRatio.xy;
  r1.xy = abs(r1.xy) * r1.zw;
  r0.xy = r0.xy * r1.xy + float2(1,1);
  r0.xy = r0.xy * float2(0.5,0.5) + r0.zw;
  r0.zw = vecInvScreenSize.xy * r0.xy;
  float2 rcas_uv = r0.zw / copyToBackBufferDynamicResolution.xy;
  r1.xyz = texBackBuffer.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, rcas_uv, 0).xyz;
  // Reproject jittered history depth to stabilize TAA / reconstruction.
  r2.xy = viewportJitter.xy * vecInvScreenSize.xy + r0.zw;
  r3.xyzw = texDepthRaw.Gather(PA_LINEAR_CLAMP_FILTER_s, r2.xy).xyzw;
  r2.zw = -vecInvScreenSize.xy + r2.xy;
  r4.xyzw = texDepthRaw.Gather(PA_LINEAR_CLAMP_FILTER_s, r2.zw).xyzw;
  r1.w = r3.x + r3.y;
  r1.w = r1.w + r3.z;
  r1.w = r1.w + r3.w;
  r1.w = r1.w + r4.x;
  r1.w = r1.w + r4.y;
  r1.w = r1.w + r4.z;
  r1.w = r1.w + r4.w;
  r1.w = 0.125 * r1.w;
  r2.z = texDepthRaw.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r2.xy, 0).x;
  r1.w = isTAA ? r1.w : r2.z;
  // Quantize surface roughness to pick a bilateral radius preset.
  r2.z = texNormalSmall.SampleLevel(PA_POINT_CLAMP_FILTER_s, r0.zw, 0).w;
  r2.z = 16 * r2.z;
  r2.z = floor(r2.z);
  r2.z = (int)r2.z;
  r2.w = cmp(9 < (int)r2.z);
  r2.w = r2.w ? 0.75999999 : 0.600000024;
  r2.z = cmp((int)r2.z >= 13);
  r2.z = r2.z ? 1 : r2.w;
  r2.w = 1 + sharpenWeight.x;
  r2.w = 0.25 * r2.w;
  // Character blur path keeps alpha-driven blur when characters need extra separation.
  r2.z = cmp(isRenderCharacterBlur != 0);
  if (r2.z == 0) {
    r3.xyz = texBackBuffer.SampleLevel(PA_POINT_CLAMP_FILTER_s, r0.zw, 0).xyz;
    r2.z = texHDR.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r0.zw, 0).w;
    r3.xyz = r3.xyz + -r1.xyz;
    r3.xyz = r2.zzz * r3.xyz + r1.xyz;
  } else {
    r4.xyz = texBackBuffer.SampleLevel(PA_POINT_CLAMP_FILTER_s, r0.zw, 0).xyz;
    r0.z = texHDR.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r0.zw, 0).w;
    r0.z = 0.5 * r0.z;
    r4.xyz = r4.xyz + -r1.xyz;
    r4.xyz = r0.zzz * r4.xyz + r1.xyz;
    r3.xyz = isRenderCharacterBlur ? r4.xyz : r1.xyz;
  }
  r1.xyz = isGraphicUltra ? r1.xyz : r3.xyz;
  // Depth-dependent blur softly blends history when high depth variance detected.
  r0.z = 8.69999981 * blurDepthRate;
  r0.w = log2(r1.w);
  r0.z = r0.z * r0.w;
  r0.z = exp2(r0.z);
  r0.w = cmp(0.00100000005 < r0.z);
  r2.zw = cmp(float2(0.5,9.99999975e-05) < blurScale);
  r0.w = r0.w ? r2.z : 0;
  if (r0.w != 0) {
    r3.xw = vecInvScreenSize.xy;
    r3.yz = float2(0,0);
    r4.xyzw = blurScale * r3.xyzw;
    r2.xy = r3.xy * blurScale + r2.xy;
    r3.xy = r2.xy / copyToBackBufferDynamicResolution.xy;
    r3.xyz = texBackBuffer.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r3.xy, 0).xyz;
    r0.w = texDepthRaw.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r2.xy, 0).x;
    r0.w = r1.w + r0.w;
    r2.xy = r0.xy * vecInvScreenSize.xy + r4.zw;
    r5.xy = r2.xy / copyToBackBufferDynamicResolution.xy;
    r5.xyz = texBackBuffer.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r5.xy, 0).xyz;
    r3.xyz = r5.xyz + r3.xyz;
    r1.w = texDepthRaw.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r2.xy, 0).x;
    r0.w = r1.w + r0.w;
    r4.xyzw = r0.xyxy * vecInvScreenSize.xyxy + -r4.xyzw;
    r5.xyzw = r4.xyzw / copyToBackBufferDynamicResolution.xyxy;
    r2.xyz = texBackBuffer.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r5.xy, 0).xyz;
    r2.xyz = r3.xyz + r2.xyz;
    r1.w = texDepthRaw.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r4.xy, 0).x;
    r0.w = r1.w + r0.w;
    r3.xyz = texBackBuffer.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r5.zw, 0).xyz;
    r2.xyz = r3.xyz + r2.xyz;
    r1.w = texDepthRaw.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r4.zw, 0).x;
    r0.w = r1.w + r0.w;
    r3.xyz = float3(0.25,0.25,0.25) * r2.xyz;
    r0.w = cmp(4.99999523 < r0.w);
    r2.xyz = r2.xyz * float3(0.25,0.25,0.25) + -r1.xyz;
    r2.xyz = r2.xyz * float3(0.5,0.5,0.5) + r1.xyz;
    r2.xyz = r0.www ? r2.xyz : r3.xyz;
    r0.w = r0.z + r0.z;
    r0.z = saturate(r0.z * blurDepthBias + r0.w);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = r0.zzz * r2.xyz + r1.xyz;
  }
  r1.xyz = max(float3(0,0,0), r1.xyz);
  float3 linear_untonemapped = r1.xyz;
  if (CUSTOM_SHARPNESS > 0.f) {
    float3 sharpened_linear = ApplyRCAS(linear_untonemapped, rcas_uv, texBackBuffer, PA_LINEAR_CLAMP_FILTER_s);
    r1.xyz = sharpened_linear;
    linear_untonemapped = sharpened_linear;
  }
  // Apply contrast, LUT, and vignette shaping as final post-processing.
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r1.xyz * fContrast + float3(0.5,0.5,0.5);
  // Skip the game LUT here so the upstream tone-map removal actually takes effect.
  if (false) {
    r2.xyz = texLut.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r1.xyz, 0).xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = lutLerp * r2.xyz + r1.xyz;
  }
  if (r2.w != 0) {
    r0.xy = r0.xy * vecInvScreenSize.xy + float2(-0.5,-0.5);
    r0.x = dot(r0.xy, r0.xy);
    r0.x = sqrt(r0.x);
    r0.x = saturate(-r0.x * 0.400000006 + 1.14999998);
    r0.x = r0.x * r0.x;
    r0.y = r0.x * r0.x;
    r0.x = r0.x * r0.y;
    r0.y = r0.x * -2 + 3;
    r0.x = r0.x * r0.x;
    r0.x = r0.y * r0.x + -1;
    r0.x = vignettingRate * r0.x + 1;
    r1.xyz = r1.xyz * r0.xxx;
  }
  const float3 graded_sdr = r1.xyz;
  o0.xyz = graded_sdr;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    const float3 graded_linear = renodx::color::srgb::DecodeSafe(graded_sdr);
    o0.xyz = renodx::draw::ToneMapPass(linear_untonemapped, graded_linear);
    o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
    o0.xyz = renodx::effects::ApplyFilmGrain(
        o0.xyz,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f);
    o0.xyz = max(float3(0,0,0), o0.xyz);
  } else {
    o0.xyz = saturate(o0.xyz);
  }
  return;
}