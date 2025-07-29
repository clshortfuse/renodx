#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Mon Jul 28 23:01:23 2025

cbuffer _Globals : register(b0) {
  float ImageSpace_hlsl_ToneMapPixelShader011_4bits : packoffset(c0) = { 0 };
  float4 fogColor : packoffset(c1);
  float3 fogTransform : packoffset(c2);
  float4x3 screenDataToCamera : packoffset(c3);
  float globalScale : packoffset(c6);
  float sceneDepthAlphaMask : packoffset(c6.y);
  float globalOpacity : packoffset(c6.z);
  float distortionBufferScale : packoffset(c6.w);
  float2 wToZScaleAndBias : packoffset(c7);
  float4 screenTransform[2] : packoffset(c8);
  float4 textureToPixel : packoffset(c10);
  float4 pixelToTexture : packoffset(c11);
  float maxScale : packoffset(c12) = { 0 };
  float bloomAlpha : packoffset(c12.y) = { 0 };
  float sceneBias : packoffset(c12.z) = { 1 };
  float exposure : packoffset(c12.w) = { 0 };
  float deltaExposure : packoffset(c13) = { 0 };
  float4 ColorFill : packoffset(c14);
}

SamplerState s_framebuffer_s : register(s0);
SamplerState s_bloom_s : register(s1);
Texture2D<float4> s_framebuffer : register(t0);
Texture2D<float4> s_bloom : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s_bloom.Sample(s_bloom_s, w1.xy).xyzw;
  r1.xyzw = s_framebuffer.Sample(s_framebuffer_s, v1.xy).xyzw;
  r0.xyz = r0.xyz * bloomAlpha * CUSTOM_BLOOM + r1.xyz;
  o0.w = r1.w;
  // r0.xyz = saturate(sceneBias * r0.xyz);
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = saturate(sceneBias * r0.rgb);
  } else {
    o0.rgb = renodx::draw::ToneMapPass(sceneBias * r0.rgb);
  }
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}
