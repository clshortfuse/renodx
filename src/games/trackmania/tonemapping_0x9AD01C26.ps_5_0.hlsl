#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Apr 11 13:17:40 2025

cbuffer SceneP : register(b13)
{
  float4 GbxP_Fog_LinearRGB : packoffset(c0);
  float4x3 GbxP_WorldToCamera : packoffset(c1);
  float4 GbxP_EyeInWorld : packoffset(c4);
  float4 GbxP_CameraPrRangeW : packoffset(c5);
  float4 GbxP_RasterPos_SxyTwz_TexCoord : packoffset(c6);
  float4 GbxP_RasterPos_SxyTzw_HPos : packoffset(c7);
  float4 GbxP_iPixelFull_SxyTzw_Render01 : packoffset(c8);
  float4 GbxP_RasterFaceSign_Alpha01Ref : packoffset(c9);
  float4 GbxP_Fog_ZNearFar : packoffset(c10);
  float4 GbxP_DisplaysActivation[2] : packoffset(c11);
  float4x4 GbxP_Pssm_WorldPw01Shadow[7] : packoffset(c13);
  float4 GbxP_Pssm_SplitZcMax4s[2] : packoffset(c41);
  int4 GbxP_Pssm_cShadow : packoffset(c43);
  float4 GbxP_Pssm_SplitTcMins[8] : packoffset(c44);
  float4 GbxP_Pssm_SplitTcMaxs[8] : packoffset(c52);
  float4 GbxP_LightAmbientLinear : packoffset(c60);
  float4 GbxP_LightDirRgbLinear0 : packoffset(c61);
  float4 GbxP_LightDirDirInWorld0 : packoffset(c62);
  float4 GbxP_LightGenPHdrScale_SelfIllumScale_SpecMaxExp_SpecScale : packoffset(c63);
  float4 GbxP_LightGenP_HBasisHdrScales3_Bumpiness : packoffset(c64);
  float4 GbxP_LightGenP_LocalDirectScale01_00 : packoffset(c65);
  float4 GbxP_LocalSpecularScale_ScaleExp : packoffset(c66);
  float4 GbxP_TmFilmCurve_A_B_BC_OutScale : packoffset(c67);
  float4 GbxP_TmFilmCurve_DE_DF_EoverF : packoffset(c68);
  float4 GbxP_TmAutoExposureUV : packoffset(c69);
  float4 GbxP_T3HdrScales_Block_Particle_Player : packoffset(c70);
  float4 GbxP_CloudsX2minRGB_Half : packoffset(c71);
  float4 GbxP_CloudsX2maxRGB_FREE : packoffset(c72);
  float4 GbxP_LmComputeScaleNoAcc : packoffset(c73);
  float4x3 GbxP_Projector_EyePz01 : packoffset(c74);
  float4 GbxP_Projector_PosInEye : packoffset(c77);
  float4 GbxP_Projector_Rgb : packoffset(c78);
  float4 GbxP_TexelSxyTwzUV_LightPosIRad : packoffset(c79);
  float4 GbxP_TexelSizeUVW_Half_LightList : packoffset(c80);
  float4 GbxP_DayTime : packoffset(c81);
  int4 GbxP__cTileX_cMaxIdxPerTile : packoffset(c82);
  float4 GbxP_WorldXZ_ST_MapTc : packoffset(c83);
  float4 GbxP_FrustumCluster_cBitTile_L2zST : packoffset(c84);
  float4x3 GbxP_ShadowLDir0_Texture0To1 : packoffset(c85);
  float4 GbxP_CubeFake_Scale0_Scale1_Id0_Id1 : packoffset(c88);
  float4 GbxP_DayTime_Id0_Id1_Weight1_IllumScale : packoffset(c89);
  float4 GbxP_NightOnlySI_GlobalScale_Free3 : packoffset(c90);
  float4 GbxP_LM1_HBasisHdrScales4 : packoffset(c91);
  float4 GbxP_MSAA_SamplePositions[4] : packoffset(c92);
  float4 GbxP_GridProbe_WorldPos_ST_I3VMap_SxTx_SyTy : packoffset(c96);
  float4 GbxP_GridProbe_WorldPos_ST_I3VMap_SzTz_HdrScale_SH1y : packoffset(c97);
  float4 GbxP_GridProbe_VirtualScaleTc : packoffset(c98);
  float4x3 GbxP_WorldTo01ShadowLDir0 : packoffset(c99);

  struct
  {
    float TcFullRange_Scale_TcClipSlice0;
    float TcClipRadiusSubLen_Scale_Intens;
    float2 TcClipMap0_Eye;
    uint cSlice;
    float3 Pad0;
    float4 Slices_TcClip0Radius;
  } GbxP_ClipMapShadowLDir0 : packoffset(c102);

  float4 GbxP_VoxelKillMesh_WorldTransVoxelMin : packoffset(c105);
  int4 GbxP_DebugValue : packoffset(c106);
  int GbxP_ForwardAO : packoffset(c107);
  int GbxP_EyeUnderWater : packoffset(c107.y);
  float GbxP_WaterTopLDir0_ToAddFromMap : packoffset(c107.z);
  float GbxP_WaterFogMaxDepthInverse : packoffset(c107.w);
  float GbxP_VoxelKillMesh_WorldScaleVoxelMin : packoffset(c108);
  float GbxP_PbrSpecAttExpAtR0 : packoffset(c108.y);
  float GbxP_LM1_LDirectScale : packoffset(c108.z);
  bool GbxP_LM1_LDirectTcInvertY : packoffset(c108.w);
  bool GbxP_OutputIsLinear : packoffset(c109);
  bool GbxP_ToneMapInShader : packoffset(c109.y);
  int GbxP_LmBumpTxTyTz : packoffset(c109.z);
  int GbxP_LmLocals : packoffset(c109.w);
  bool GbxP_LmHBasis_IsFloat : packoffset(c110);
  int GbxP_ShadingModel : packoffset(c110.y);
  int GbxP_DeferSpecularAmbient : packoffset(c110.z);
  int GbxP_DynaAmbient : packoffset(c110.w);
  int GbxP_VehicleEnvLayer : packoffset(c111);
  int GbxP_Fog_SlicesCount : packoffset(c111.y);
  int GbxP_Deferred_IsEnabled : packoffset(c111.z);
  float GbxP_LmLightId_FramePos : packoffset(c111.w);
  int GbxP_MsaaSampleCount : packoffset(c112);
}

cbuffer ShaderP : register(b0)
{

  struct
  {

    struct
    {
      float2 TcAutoScale;
      float EdColorWeight;
      float Pad0;
    } Base;

    float4 A_B_BC_OutScale;
    float4 DE_DF_EoverF_GrayScale;
    float3 OutScale_GrayScale_WeightAlt;
    float Pad0;
  } LoadFx_CB : packoffset(c0);

}

SamplerState SGbxClamp_Point_s : register(s0);
Texture2D<float4> TMapCopy : register(t0);
Texture2D<float4> TMapAvgLumi_KeyValue : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * GbxP_RasterPos_SxyTwz_TexCoord.xy + GbxP_RasterPos_SxyTwz_TexCoord.wz;
  r1.xyzw = TMapCopy.Sample(SGbxClamp_Point_s, r0.xy).xyzw;
  r1.xyzw = min(float4(50000,50000,50000,50000), r1.xyzw);
  r0.z = cmp(LoadFx_CB.Base.TcAutoScale.x >= 0);
  if (r0.z != 0) {
    r0.z = TMapAvgLumi_KeyValue.Sample(SGbxClamp_Point_s, LoadFx_CB.Base.TcAutoScale.xy).z;
    // r1.xyz = r1.xyz * r0.zzz;
    // r1.xyz = r1.xyz * (r0.zzz * CUSTOM_AUTO_EXPOSURE);
    r1.xyz = r1.xyz * lerp(1.f, r0.zzz, CUSTOM_AUTO_EXPOSURE);
  }

  float3 untonemapped = r1.rgb;

  r0.z = cmp(0 < LoadFx_CB.OutScale_GrayScale_WeightAlt.z);
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r0.y = 1.20000005 * r0.y;
  r0.xy = r0.xy * r0.xy;
  r0.x = r0.x * 1.5 + r0.y;
  r0.x = saturate(-0.0500000007 + r0.x);
  r0.x = 1 + -r0.x;
  r0.y = r0.x * r0.x;
  r0.x = -r0.x * r0.y + 1;
  r0.x = LoadFx_CB.OutScale_GrayScale_WeightAlt.z * r0.x;
  r0.y = LoadFx_CB.OutScale_GrayScale_WeightAlt.x + -LoadFx_CB.A_B_BC_OutScale.w;
  r2.x = r0.x * r0.y + LoadFx_CB.A_B_BC_OutScale.w;
  r0.y = LoadFx_CB.OutScale_GrayScale_WeightAlt.y + -LoadFx_CB.DE_DF_EoverF_GrayScale.w;
  r2.y = r0.x * r0.y + LoadFx_CB.DE_DF_EoverF_GrayScale.w;
  r0.x = LoadFx_CB.A_B_BC_OutScale.w;
  r0.y = LoadFx_CB.DE_DF_EoverF_GrayScale.w;
  r0.xy = r0.zz ? r2.xy : r0.xy;
  r2.xyz = LoadFx_CB.A_B_BC_OutScale.xxx * r1.xyz + LoadFx_CB.A_B_BC_OutScale.zzz;
  r2.xyz = r1.xyz * r2.xyz + LoadFx_CB.DE_DF_EoverF_GrayScale.xxx;
  r3.xyz = LoadFx_CB.A_B_BC_OutScale.xxx * r1.xyz + LoadFx_CB.A_B_BC_OutScale.yyy;
  r1.xyz = r1.xyz * r3.xyz + LoadFx_CB.DE_DF_EoverF_GrayScale.yyy;
  r1.xyz = r2.xyz / r1.xyz;
  r1.xyz = -LoadFx_CB.DE_DF_EoverF_GrayScale.zzz + r1.xyz;
  r0.y = dot(r1.xyz, r0.yyy);
  o0.xyz = r1.xyz * r0.xxx + r0.yyy;
  o0.w = r1.w;

  float3 tonemapped_bt709 = o0.rgb;

  float3 outputColor;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = tonemapped_bt709;
  } 
  else {
    outputColor = renodx::draw::ToneMapPass(untonemapped, tonemapped_bt709);
  }
  o0.rgb = renodx::draw::RenderIntermediatePass(outputColor);
  //o0.rgb = renodx::draw::RenderIntermediatePass(untonemapped);
  return;
}