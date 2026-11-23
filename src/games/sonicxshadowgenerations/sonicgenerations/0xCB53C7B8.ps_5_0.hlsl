// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 19 05:03:48 2026

#include "./common.hlsli"  // RenoDX

cbuffer _Globals : register(b0)
{
  row_major float4x4 g_MtxProjection : packoffset(c16);
  row_major float4x4 g_MtxInvProjection : packoffset(c20);
  row_major float4x4 g_MtxView : packoffset(c89);
  row_major float4x4 g_MtxInvView : packoffset(c93);
  float4 g_Diffuse : packoffset(c24);
  float4 g_Ambient : packoffset(c25);
  float4 g_Specular : packoffset(c26);
  float4 g_Emission : packoffset(c27);
  float4 g_PowerGlossLevel : packoffset(c28);
  float4 g_OpacityReflectionRefractionSpectype : packoffset(c29);
  float4 g_EyePosition : packoffset(c30);
  float4 g_EyeDirection : packoffset(c31);
  float4 g_ViewportSize : packoffset(c32);
  float3 g_CameraNearFarAspect : packoffset(c33);
  float4 mrgTexcoordIndex[4] : packoffset(c34);
  float4 mrgAmbientColor : packoffset(c38);
  float4 mrgGroundColor : packoffset(c39);
  float4 mrgSkyColor : packoffset(c40);
  float4 mrgPowerGlossLevel : packoffset(c41);
  float4 mrgEmissionPower : packoffset(c42);
  float4 mrgGlobalLight_Direction : packoffset(c43);
  float4 mrgGlobalLight_Direction_View : packoffset(c44);
  float4 mrgGlobalLight_Diffuse : packoffset(c45);
  float4 mrgGlobalLight_Specular : packoffset(c46);
  float4 mrgEyeLight_Diffuse : packoffset(c55);
  float4 mrgEyeLight_Specular : packoffset(c56);
  float4 mrgEyeLight_Range : packoffset(c57);
  float4 mrgEyeLight_Attribute : packoffset(c58);
  float2 mrgFresnelParam : packoffset(c59);
  float4 mrgLuminanceRange : packoffset(c60);
  float4 mrgInShadowScale : packoffset(c61);
  float4 g_ShadowMapParams : packoffset(c62);
  float4 mrgVsmEpsilon : packoffset(c87);
  float g_BackGroundScale : packoffset(c64);
  float4 g_TimeParam : packoffset(c65);
  float4 g_GIModeParam : packoffset(c66);
  float4 g_GI0Scale : packoffset(c67);
  float4 g_GI1Scale : packoffset(c68);
  float4 g_LightScattering_Ray_Mie_Ray2_Mie2 : packoffset(c69);
  float4 g_LightScattering_ConstG_FogDensity : packoffset(c70);
  float4 g_LightScatteringFarNearScale : packoffset(c71);
  float4 g_LightScatteringColor : packoffset(c72);
  float g_LightScatteringMode : packoffset(c73);
  float4 g_aLightField[6] : packoffset(c74);
  float4 g_MotionBlur_AlphaRef_VelocityLimit_VelocityCutoff_BlurMagnitude : packoffset(c82);
  float4 mrgPlayableParam : packoffset(c83);
  float4 mrgDebugDistortionParam : packoffset(c84);
  float4 mrgEdgeEmissionParam : packoffset(c85);
  float4 g_DebugValue : packoffset(c88);
  row_major float4x4 g_MtxLightViewProjection : packoffset(c97);
  row_major float4x4 g_MtxVerticalLightViewProjection : packoffset(c101);
  float4 g_ForceAlphaColor : packoffset(c86);
  float4 g_MiddleGray_Scale_LuminanceLow_LuminanceHigh : packoffset(c105);
  float4 g_DepthOfFieldFocusNearFarRange : packoffset(c106);
  float4 g_dofLerpScaleBias[2] : packoffset(c107);
}

SamplerState s0_sampler_s : register(s0);
SamplerState s1_sampler_s : register(s1);
SamplerState s4_sampler_s : register(s4);
Texture2D<float4> s0_NedSmpignorenametexture : register(t0);
Texture2D<float4> s1_NedSmpignorenametexture : register(t1);
Texture2D<float4> s4_NedSmpignorenametexture : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_DepthOfFieldFocusNearFarRange.x + -g_DepthOfFieldFocusNearFarRange.w;
  r0.yz = g_MtxInvProjection._m12_m13 * v1.yy;
  r0.yz = v1.xx * g_MtxInvProjection._m02_m03 + r0.yz;
  r0.w = s1_NedSmpignorenametexture.Sample(s1_sampler_s, v2.xy).x;
  r0.yz = r0.ww * g_MtxInvProjection._m22_m23 + r0.yz;
  r0.w = cmp(r0.w >= 0.999984741);
  r0.w = r0.w ? 1.000000 : 0;
  r0.yz = g_MtxInvProjection._m32_m33 + r0.yz;
  r0.y = r0.y / r0.z;
  r0.x = max(-r0.y, r0.x);
  r0.z = r0.x + r0.y;
  r0.x = -g_DepthOfFieldFocusNearFarRange.y + r0.x;
  r0.x = saturate(r0.z / r0.x);
  r0.z = g_DepthOfFieldFocusNearFarRange.x + g_DepthOfFieldFocusNearFarRange.w;
  r0.z = min(-r0.y, r0.z);
  r1.x = -r0.y + -r0.z;
  r0.z = g_DepthOfFieldFocusNearFarRange.z + -r0.z;
  r0.z = saturate(r1.x / r0.z);
  r0.y = cmp(-r0.y < g_DepthOfFieldFocusNearFarRange.x);
  r0.x = r0.y ? r0.x : r0.z;
  r0.xyz = saturate(r0.xxx * g_dofLerpScaleBias[0].yzw + g_dofLerpScaleBias[1].yzw);
  r0.x = 1 + -r0.x;
  r0.x = min(r0.y, r0.x);
  r0.x = r0.x + r0.z;
  r0.x = min(0.996078432, r0.x);
  r0.y = 1 + -r0.x;
  o0.w = saturate(r0.w * r0.y + r0.x);  // RenoDX: emulate the RGBA8 UNORM clamp on the DOF CoC
  r0.x = s4_NedSmpignorenametexture.Sample(s4_sampler_s, float2(0.5,0.5)).x;
  // RenoDX: auto exposure mode (vanilla division in mode 1)
  r0.x = SGAutoExposure(g_MiddleGray_Scale_LuminanceLow_LuminanceHigh.x, r0.x);
  r0.yzw = s0_NedSmpignorenametexture.Sample(s0_sampler_s, v2.xy).xyz;
  // o0.xyz = r0.yzw * r0.xxx;
  o0.xyz = min(r0.yzw * r0.xxx, 1000.f);  // RenoDX: keep fp16 finite
  return;
}