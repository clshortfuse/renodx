#include "./shared.h"

cbuffer SceneBuffer : register(b2)
{
  row_major float4x4 View : packoffset(c0);
  row_major float4x4 ScreenMatrix : packoffset(c4);
  float2 DepthExportScale : packoffset(c8);
  float2 __padding0 : packoffset(c8.z);
  float4 FogParams : packoffset(c9);
  float3 __CameraPosition : packoffset(c10);
  float __padding12 : packoffset(c10.w);
  float3 CameraDirection : packoffset(c11);
  float __padding9 : packoffset(c11.w);
  float3 DepthFactors : packoffset(c12);
  float __padding10 : packoffset(c12.w);
  float3 ShadowDepthBiasAndLightType : packoffset(c13);
  float __padding11 : packoffset(c13.w);
  float4 SubframeViewport : packoffset(c14);
  row_major float3x4 DepthToWorld : packoffset(c15);
  float4 DepthToView : packoffset(c18);
  float4 OneOverDepthToView : packoffset(c19);
  float4 DepthToW : packoffset(c20);
  float4 ClipPlane : packoffset(c21);
  float2 ViewportDepthScaleOffset : packoffset(c22);
  float2 __padding1 : packoffset(c22.z);
  float2 ColorDOFDepthScaleOffset : packoffset(c23);
  float2 __padding2 : packoffset(c23.z);
  float4 TimeVector : packoffset(c24);
  float4 FogParams2 : packoffset(c25);
  float4 FogParams3 : packoffset(c26);
  float3 GlobalAmbient : packoffset(c27);
  float __padding8 : packoffset(c27.w);
  float4 GlobalParams[16] : packoffset(c28);
  float4 ViewToFogH : packoffset(c44);
  float4 ScreenExtents : packoffset(c45);
  float2 ScreenResolution : packoffset(c46);
  float2 __padding3 : packoffset(c46.z);
  float4 PSSMToMap1Lin : packoffset(c47);
  float4 PSSMToMap1Const : packoffset(c48);
  float4 PSSMToMap2Lin : packoffset(c49);
  float4 PSSMToMap2Const : packoffset(c50);
  float4 PSSMToMap3Lin : packoffset(c51);
  float4 PSSMToMap3Const : packoffset(c52);
  float4 PSSMDistances : packoffset(c53);
  row_major float4x4 WorldToPSSM0 : packoffset(c54);
  row_major float4x4 PrevViewProject : packoffset(c58);
  row_major float4x4 PrevWorld : packoffset(c62);
  row_major float4x4 ViewT : packoffset(c66);
  float4 PSSMExtents : packoffset(c70);
  float4 ShadowAtlasResolution : packoffset(c71);
  float4 UnitRimData[3] : packoffset(c72);
  float3 __CameraPositionForCorrection : packoffset(c75);
  float __padding7 : packoffset(c75.w);
  row_major float4x4 CameraViewProject : packoffset(c76);
  float4 BackBufferResolution : packoffset(c80);
  row_major float4x4 InverseProjection : packoffset(c81);
  float4 StereoOffset : packoffset(c85);
  row_major float4x4 Projection : packoffset(c86);
  row_major float4x4 ViewInv : packoffset(c90);
  float4 ColorSSAO : packoffset(c94);
  float4 GlobalFogColor : packoffset(c95);
  float4 VolumetricLightGlobalParams : packoffset(c96);
  float4 SnowParams01 : packoffset(c97);
  float4 SnowParams02 : packoffset(c98);
  float4 SnowParams03 : packoffset(c99);
  int SSREnabled : packoffset(c100);
  int __padding4 : packoffset(c100.y);
  int __padding5 : packoffset(c100.z);
  int __padding6 : packoffset(c100.w);
  float LFAOEnabled : packoffset(c101);
  float LFAODarkening : packoffset(c101.y);
  float LFAODirectionalDarkening : packoffset(c101.z);
  float LFAONormalAdjustStrength : packoffset(c101.w);
  float2 NdcOffset : packoffset(c102);
  float VelocityScale : packoffset(c102.z);
  float __padding13 : packoffset(c102.w);
}

cbuffer MaterialBuffer : register(b3)
{
  float4 MaterialParams[512] : packoffset(c0);
}

cbuffer InstanceBuffer : register(b5)
{

  struct
  {
    float4 InstanceParams[8];
  } InstanceParameters[256] : packoffset(c0);

}

SamplerState SamplerGenericTrilinearWrap_s : register(s11);
Texture2D<float4> p_default_Material_n33_3F51EB7028323377_Param_texture : register(t0);
Texture2D<float4> p_default_Setup_439201D08817918_Param_texture : register(t1);
Texture2D<float4> p_default_Setup_F5BA69F012017724_cp0_Param_texture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  nointerpolation uint v3 : PSIZE0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * ScreenExtents.zw + ScreenExtents.xy;
  r0.xyz = p_default_Material_n33_3F51EB7028323377_Param_texture.Sample(SamplerGenericTrilinearWrap_s, r0.xy).xyz;
  r0.xyz = r0.xyz * MaterialParams[1].xxx + float3(-1,-1,-1);
  r0.w = (uint)v3.x << 3;
  r0.xyz = InstanceParameters[r0.w].InstanceParams[0].yyy * r0.xyz + float3(1,1,1);
  r1.xyzw = p_default_Setup_F5BA69F012017724_cp0_Param_texture.Sample(SamplerGenericTrilinearWrap_s, v2.xy).xyzw;
  r1.xyz = v1.xyz * r1.xyz;
  o0.xyz = r1.xyz * r0.xyz;
  r0.xy = CameraDirection.xy * MaterialParams[0].ww + v2.xy;
  r0.xy = MaterialParams[1].yy * r0.xy;
  r0.x = p_default_Setup_439201D08817918_Param_texture.Sample(SamplerGenericTrilinearWrap_s, r0.xy).x;
  r0.x = r1.w * r0.x;
  o0.w = v1.w * r0.x * CUSTOM_LENS_FLARE;
  return;
}