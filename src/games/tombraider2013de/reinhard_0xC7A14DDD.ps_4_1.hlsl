#include "./shared.h"

cbuffer SceneBuffer : register(b2) {
  row_major float4x4 View : packoffset(c0);
  row_major float4x4 ScreenMatrix : packoffset(c4);
  float2 DepthExportScale : packoffset(c8);
  float4 FogParams : packoffset(c9);
  float3 __CameraPosition : packoffset(c10);
  float3 CameraDirection : packoffset(c11);
  float3 DepthFactors : packoffset(c12);
  float2 ShadowDepthBias : packoffset(c13);
  float4 SubframeViewport : packoffset(c14);
  row_major float3x4 DepthToWorld : packoffset(c15);
  float4 DepthToView : packoffset(c18);
  float4 OneOverDepthToView : packoffset(c19);
  float4 DepthToW : packoffset(c20);
  float4 ClipPlane : packoffset(c21);
  float2 ViewportDepthScaleOffset : packoffset(c22);
  float2 ColorDOFDepthScaleOffset : packoffset(c23);
  float2 TimeVector : packoffset(c24);
  float3 FogParams2 : packoffset(c25);
  float3 GlobalAmbient : packoffset(c26);
  float4 GlobalParams[16] : packoffset(c27);
  float4 ViewToFogH : packoffset(c43);
  float4 ScreenExtents : packoffset(c44);
  float2 ScreenResolution : packoffset(c45);
  float4 PSSMToMap1Lin : packoffset(c46);
  float4 PSSMToMap1Const : packoffset(c47);
  float4 PSSMToMap2Lin : packoffset(c48);
  float4 PSSMToMap2Const : packoffset(c49);
  float4 PSSMToMap3Lin : packoffset(c50);
  float4 PSSMToMap3Const : packoffset(c51);
  float4 PSSMDistances : packoffset(c52);
  row_major float4x4 WorldToPSSM0 : packoffset(c53);
  row_major float4x4 PrevViewProject : packoffset(c57);
  row_major float4x4 PrevWorld : packoffset(c61);
  row_major float4x4 ViewT : packoffset(c65);
  float4 PSSMExtents : packoffset(c69);
  float4 ShadowAtlasResolution : packoffset(c70);
  float4 UnitRimData[3] : packoffset(c71);
  float3 __CameraPositionForCorrection : packoffset(c74);
  row_major float4x4 InverseProjection : packoffset(c80);
  float4 StereoOffset : packoffset(c84);
}

cbuffer InstanceBuffer : register(b5) {
  struct
  {
    float4 InstanceParams[8];
    float4 ExtendedInstanceParams[16];
  }
  InstanceParameters[12] : packoffset(c0);
}

SamplerState p_default_Material_2E2B083C22834586_cp1_BackBufferTexture_sampler_s : register(s0);
SamplerState p_default_Material_2E2AB03422834586_cp3_Param_sampler_s : register(s1);
Texture2D<float4> p_default_Material_2E2B083C22834586_cp1_BackBufferTexture_texture : register(t0);
Texture2D<float4> p_default_Material_2E2AB03422834586_cp3_Param_texture : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    nointerpolation uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    float v2: SV_ClipDistance0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = p_default_Material_2E2AB03422834586_cp3_Param_texture.Sample(p_default_Material_2E2AB03422834586_cp3_Param_sampler_s, float2(0.5, 0.5)).x;

  r0.x = max(0, r0.x);

  r0.x = 0.00100000005 + r0.x;
  r0.y = (int)v0.x * 24;
  r0.zw = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r1.xyzw = p_default_Material_2E2B083C22834586_cp1_BackBufferTexture_texture.Sample(p_default_Material_2E2B083C22834586_cp1_BackBufferTexture_sampler_s, r0.zw).xyzw;

  r1 = max(0, r1);

  r0.yzw = InstanceParameters[r0.y].InstanceParams[0].xxx * r1.xyz;
  r0.xyz = r0.yzw / r0.xxx;

  // Reinhard (x / (x + 1))
  // r2.xyz = float3(1, 1, 1) + r0.xyz;
  // r0.xyz = r0.xyz / r2.xyz;

  o0.xyz = r1.xyz + r0.xyz;
  o0.w = r1.w;
  return;
}
