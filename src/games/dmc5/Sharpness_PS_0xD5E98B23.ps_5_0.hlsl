#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Aug 22 01:35:14 2025

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c0);
  row_major float3x4 transposeViewMat : packoffset(c4);
  row_major float3x4 transposeViewInvMat : packoffset(c7);
  float4 projElement[2] : packoffset(c10);
  float4 projInvElements[2] : packoffset(c12);
  row_major float4x4 viewProjInvMat : packoffset(c14);
  row_major float4x4 prevViewProjMat : packoffset(c18);
  float3 ZToLinear : packoffset(c22);
  float subdivisionLevel : packoffset(c22.w);
  float2 screenSize : packoffset(c23);
  float2 screenInverseSize : packoffset(c23.z);
  float2 cullingHelper : packoffset(c24);
  float cameraNearPlane : packoffset(c24.z);
  float cameraFarPlane : packoffset(c24.w);
  float4 viewFrustum[6] : packoffset(c25);
  float4 clipplane : packoffset(c31);
}

cbuffer Tonemap : register(b1) {
  float exposureAdjustment : packoffset(c0);
  float tonemapRange : packoffset(c0.y);
  float sharpness : packoffset(c0.z);
  float preTonemapRange : packoffset(c0.w);
  int useAutoExposure : packoffset(c1);
  float echoBlend : packoffset(c1.y);
  float AABlend : packoffset(c1.z);
  float AASubPixel : packoffset(c1.w);
  float ResponsiveAARate : packoffset(c2);
}

SamplerState PointBorder_s : register(s0);
SamplerState BilinearClamp_s : register(s1);
Texture2D<float4> HDRImage : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  o0.w = 0;

  if (CUSTOM_SHARPENING != 0.f) {
    o0.rgb = HDRImage.SampleLevel(PointBorder_s, v1.xy, 0).xyz;
    return;
  }

  r0.xyzw = screenInverseSize.xyxy * float4(0.5, -0.5, 0.5, 0.5) + v1.xyxy;
  r1.xyz = HDRImage.SampleLevel(BilinearClamp_s, r0.zw, 0).xyz;
  r0.xyz = HDRImage.SampleLevel(BilinearClamp_s, r0.xy, 0).xyz;
  r2.xyz = HDRImage.SampleLevel(PointBorder_s, v1.xy, 0).xyz;
  r0.xyz = r2.xyz * float3(5, 5, 5) + -r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r1.xyzw = screenInverseSize.xyxy * float4(-0.5, -0.5, -0.5, 0.5) + v1.xyxy;
  r3.xyz = HDRImage.SampleLevel(BilinearClamp_s, r1.xy, 0).xyz;
  r1.xyz = HDRImage.SampleLevel(BilinearClamp_s, r1.zw, 0).xyz;
  r0.xyz = -r3.xyz + r0.xyz;
  r0.xyz = saturate(r0.xyz + -r1.xyz);
  r0.xyz = r0.xyz + -r2.xyz;
  o0.xyz = sharpness * r0.xyz + r2.xyz;
  return;
}
