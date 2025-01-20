#include "./shared.h"

cbuffer DrawableBuffer : register(b1) {
  float4 FogColor : packoffset(c0);
  float4 DebugColor : packoffset(c1);
  float AlphaThreshold : packoffset(c2);
  float4 __InstancedMaterialOpacity[12] : packoffset(c3);
}

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

SamplerState p_default_Material_13BF791C3310755_Param_sampler_s : register(s0);
SamplerState p_default_Material_17689BDC15180309_BackBufferTexture_sampler_s : register(s1);
SamplerState p_default_Material_12826FC4256659_DepthBufferTexture_sampler_s : register(s2);
Texture2D<float4> p_default_Material_13BF791C3310755_Param_texture : register(t0);
Texture2D<float4> p_default_Material_17689BDC15180309_BackBufferTexture_texture : register(t1);
Texture2D<float4> p_default_Material_12826FC4256659_DepthBufferTexture_texture : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(
    nointerpolation uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    float v2: SV_ClipDistance0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = 1;
  r1.xy = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r0.w = p_default_Material_12826FC4256659_DepthBufferTexture_texture.SampleLevel(p_default_Material_12826FC4256659_DepthBufferTexture_sampler_s, r1.xy, 0).x;
  r0.w = r0.w * DepthToW.x + DepthToW.y;
  r0.w = max(9.99999997e-07, r0.w);
  r0.w = 1 / r0.w;
  r0.xy = r1.xy * DepthToView.xy + DepthToView.zw;
  r0.xyz = r0.xyz * r0.www;
  r0.x = dot(r0.xyz, r0.xyz);
  r0.x = sqrt(r0.x);
  r0.y = (int)v0.x * 24;
  r0.z = -InstanceParameters[r0.y].InstanceParams[2].x + r0.x;
  r0.x = InstanceParameters[r0.y].InstanceParams[1].x + -r0.x;
  r0.x = saturate(InstanceParameters[r0.y].InstanceParams[1].y * r0.x);
  r0.x = InstanceParameters[r0.y].InstanceParams[1].z * r0.x;
  r0.z = saturate(InstanceParameters[r0.y].InstanceParams[2].y * r0.z);
  r0.z = InstanceParameters[r0.y].InstanceParams[2].z * r0.z;
  r0.w = sqrt(r0.z);
  r1.z = sqrt(r0.x);
  r0.w = -r1.z + r0.w;
  r1.zw = float2(-0.5, -0.5) + r1.xy;
  r1.z = dot(r1.zw, r1.zw);
  r1.z = sqrt(r1.z);
  r1.z = -InstanceParameters[r0.y].InstanceParams[3].x + r1.z;
  r1.z = saturate(InstanceParameters[r0.y].InstanceParams[3].y * r1.z);
  r1.z = InstanceParameters[r0.y].InstanceParams[3].z * r1.z;
  r0.y = cmp(0 != InstanceParameters[r0.y].InstanceParams[1].w);
  r1.z = max(r1.z, abs(r0.w));
  r1.w = cmp(0 < r0.w);
  r0.w = cmp(r0.w < 0);
  r0.w = (int)-r1.w + (int)r0.w;
  r0.w = (int)r0.w;
  r0.w = r0.w * r1.z;
  r1.z = saturate(100 * r0.w);
  r2.xyzw = p_default_Material_13BF791C3310755_Param_texture.Sample(p_default_Material_13BF791C3310755_Param_sampler_s, r1.xy).xyzw;
  r3.xyzw = p_default_Material_17689BDC15180309_BackBufferTexture_texture.Sample(p_default_Material_17689BDC15180309_BackBufferTexture_sampler_s, r1.xy).xyzw;

  // fix luminance of dof
  r2.xyz = max(0, r2.xyz);
  r3.xyz = max(0, r3.xyz);

  r1.x = r2.w * 2 + -1;
  r1.y = saturate(-100 * r1.x);
  r1.y = r1.z + r1.y;
  r0.w = abs(r1.x) * r1.y + abs(r0.w);
  r1.x = abs(r1.x) * r1.y + 1;
  r0.w = r0.w / r1.x;
  r1.x = r0.z * r0.z;
  r1.y = -r0.z * r0.z + 1;
  r0.z = r0.z * r1.y + r1.x;
  r1.x = r0.x * r0.x;
  r1.y = -r0.x * r0.x + 1;
  r0.x = r0.x * r1.y + r1.x;
  r0.xz = saturate(float2(-0.0500000007, -0.0500000007) + r0.xz);
  r0.x = 5 * r0.x;
  r0.x = max(r2.w, r0.x);
  r0.x = r0.z * 5 + r0.x;
  r0.x = min(1, r0.x);
  r0.x = r0.y ? r0.x : r0.w;
  r0.y = 1 + -r0.x;
  // r0.yzw = r0.yyy * r3.xyz;
  // Add saturate to fix HDR blend
  r0.yzw = saturate(r0.yyy) * r3.xyz;
  o0.xyz = r0.xxx * r2.xyz + r0.yzw;
  o0.rgb = lerp(r3.xyz, o0.rgb, CUSTOM_DOF);
  r0.x = v0.x;
  o0.w = __InstancedMaterialOpacity[r0.x].x * r3.w;
  return;
}
