#include "./common.hlsl"

cbuffer MultiPerViewportCB : register(b0){
  row_major float4x4 g_VP_WorldToClipMat : packoffset(c0);
  row_major float4x4 g_VP_ViewToWorldMat : packoffset(c4);
  row_major float4x4 g_VP_ViewToClipMat : packoffset(c8);
  float4 g_VP_ViewportToClip : packoffset(c12);
  float4 g_VP_ViewToScreen : packoffset(c13);
  float4 g_VP_ViewVec : packoffset(c14);
  float4 g_VP_VPosMapping : packoffset(c15);
  float4 g_VP_FrustumPlanes[6] : packoffset(c16);
  float4 g_VP_FogConsts[5] : packoffset(c22);
  float2 g_VP_LinearDepthConsts : packoffset(c27);
  float g_VP_SSRScale : packoffset(c27.z);
  float g_VP_Unused : packoffset(c27.w);
  float4 g_VP_FogColorSceneLum : packoffset(c28);
  float3 g_VP_LightGridConsts : packoffset(c29);
  uint g_VP_ReflectionIndices : packoffset(c29.w);
  float3 g_VP_Dimensions : packoffset(c30);
  float g_VP_FOVRatio : packoffset(c30.w);
  float3 g_VP_KeyLightColor : packoffset(c31);
  float g_VP_KeyLightSpec : packoffset(c31.w);
  float3 g_VP_RawKeyLightColor : packoffset(c32);
  float g_VP_SSRStepScale : packoffset(c32.w);
  float3 g_VP_KeyLightVec : packoffset(c33);
  float g_VP_Random : packoffset(c33.w);
  float3 g_VP_DefaultFillColor0 : packoffset(c34);
  uint g_VP_MiscFlags : packoffset(c34.w);
  float3 g_VP_DefaultFillColor1 : packoffset(c35);
  float g_VP_DissolveUvScale : packoffset(c35.w);
  float4 g_VP_KeyLightCsmDists : packoffset(c36);
  float4 g_VP_KeyLightShellPlanesX : packoffset(c37);
  float4 g_VP_KeyLightShellPlanesY : packoffset(c38);
  float4 g_VP_KeyLightShellPlanesZ : packoffset(c39);
  float4 g_VP_KeyLightShellPlanesW : packoffset(c40);
  float g_VP_FarClip : packoffset(c41);
  int g_VP_LLLWidth : packoffset(c41.y);
  int g_VP_LLLHeight : packoffset(c41.z);
  uint g_VP_LLLMaxCount : packoffset(c41.w);
  float4 g_Frame_AmbientAnimationWeightsPrev : packoffset(c42);
  float4 g_Frame_AmbientAnimationWeights : packoffset(c43);
  float g_Frame_NormalMapScale : packoffset(c44);
  float g_Frame_ShaderTimer : packoffset(c44.y);
  float g_Frame_DeltaTime : packoffset(c44.z);
  float g_Frame_Random : packoffset(c44.w);
  float g_VP_TimeOfDay : packoffset(c45);
  float g_VP_ShadowSize : packoffset(c45.y);
  float g_VP_InvShadowSize : packoffset(c45.z);
  float g_VP_ThinLinePixelScale : packoffset(c45.w);
}
cbuffer PSToneMapCB : register(b2){
  float4 g_TM_VignetteParams : packoffset(c0);
  float g_TM_BloomDirtiness : packoffset(c1);
  float g_TM_ColorCorrectionLUTDimension3D : packoffset(c1.y);
  float g_TM_Saturation : packoffset(c1.z);
  float g_TM_PadA : packoffset(c1.w);
  float g_TM_GrainSizeRcp : packoffset(c2);
  float g_TM_GrainStrength : packoffset(c2.y);
  float g_TM_GrainSecondOctaveStrength : packoffset(c2.z);
  float g_TM_ViewportAspectRatio : packoffset(c2.w);
  float g_TM_Brightness : packoffset(c3);
}
SamplerState g_LinearClampSampler_s : register(s2);
SamplerState g_LinearWrapSampler_s : register(s3);
SamplerState g_ToneCurveSampler_s : register(s5);
SamplerState g_RadianceMapSampler_s : register(s6);
Texture1D<float4> g_ToneCurve : register(t5);
Texture2D<float4> g_RadianceMap : register(t6);
StructuredBuffer<float> g_AdaptedLumBuffer : register(t7);
Texture2D<float4> g_BloomMap : register(t8);
Texture2D<float4> g_BloomDirtinessMap : register(t9);
Texture2D<float4> g_BloomLensFlareMap : register(t10);
Texture3D<float4> g_ColorLut3d : register(t12);
Texture2D<float4> g_FilmGrainNoise : register(t13);

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -59 * g_Frame_Random;
  sincos(r0.x, r0.x, r1.x);
  r0.yz = -g_Frame_Random * float2(127,59) + v1.yx;
  r0.xw = r0.yz * r0.xx;
  r2.x = r0.z * r1.x + -r0.x;
  r2.y = r0.y * r1.x + r0.w;
  r0.xy = g_Frame_Random * float2(59,127) + r2.xy;
  r0.xy = g_TM_GrainSizeRcp * r0.xy;
  r0.xy = float2(0.750187576,0.750187576) * r0.xy;
  r0.xyz = g_FilmGrainNoise.Sample(g_LinearWrapSampler_s, r0.xy).xyz;
  r1.y = g_TM_ViewportAspectRatio * v1.x;
  r1.x = v1.y;
  r1.xy = -g_Frame_Random * float2(127,59) + r1.xy;
  sincos(g_Frame_Random, r2.x, r3.x);
  r1.zw = r2.xx * r1.xy;
  r2.x = r1.y * r3.x + -r1.z;
  r2.y = r1.x * r3.x + r1.w;
  r1.xy = g_Frame_Random * float2(59,127) + r2.xy;
  r1.xy = g_TM_GrainSizeRcp * r1.xy;
  r1.xyz = g_FilmGrainNoise.Sample(g_LinearWrapSampler_s, r1.xy).xyz;
  r0.xyz = -r1.xyz + r0.xyz;
  r0.xyz = g_TM_GrainSecondOctaveStrength * r0.xyz + r1.xyz;
  r1.xyz = g_BloomDirtinessMap.Sample(g_LinearClampSampler_s, v1.xy).xyz;
  r1.xyz = r1.xyz * g_TM_BloomDirtiness + float3(1,1,1);
  r2.xyz = g_BloomMap.Sample(g_LinearClampSampler_s, v1.xy).xyz;
  r3.xyz = g_BloomLensFlareMap.Sample(g_LinearClampSampler_s, v1.xy).xyz;
  r1.xyz = r2.xyz * r1.xyz * injectedData.fxBloom + r3.xyz * injectedData.fxLensFlare;
  r2.xyz = g_RadianceMap.Sample(g_RadianceMapSampler_s, v1.xy).xyz;
  r0.w = g_AdaptedLumBuffer[1].x;
  r2.xyz = r2.xyz * lerp(1.f, r0.www, injectedData.fxAutoExposure);
  float3 untonemapped = r2.rgb;
  float3 bloom = r1.rgb;
  r2.xyz = max(float3(0.00390625,0.00390625,0.00390625), r2.xyz);
  r2.xyz = log2(r2.xyz);
  r2.xyz = r2.xyz * float3(0.0769230798,0.0769230798,0.0769230798) + float3(0.615384638,0.615384638,0.615384638);
  r2.xyz = min(float3(1,1,1), r2.xyz);
  r3.x = g_ToneCurve.Sample(g_ToneCurveSampler_s, r2.x).x;
  r3.y = g_ToneCurve.Sample(g_ToneCurveSampler_s, r2.y).x;
  r3.z = g_ToneCurve.Sample(g_ToneCurveSampler_s, r2.z).x;
  float3 vanilla = r3.rgb;
  r2.r = 0.18f;
  r2.x = log2(r2.x);
  r2.x = r2.x * 0.0769230798f + 0.615384638f;
  r3.x = g_ToneCurve.Sample(g_ToneCurveSampler_s, r2.x).x;
  float midGray = renodx::color::y::from::BT709(r3.rrr);
  r1.xyz = saturate(r3.xyz + r1.xyz);
  r2.xyz = log2(r1.xyz);
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r3.xyz = cmp(r1.xyz < float3(0.00313080009,0.00313080009,0.00313080009));
  r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  r1.xyz = r3.xyz ? r1.xyz : r2.xyz;
  r1.xyz = saturate(g_TM_Brightness * r1.xyz);
  r0.w = -1 + g_TM_ColorCorrectionLUTDimension3D;
  r0.w = r0.w / g_TM_ColorCorrectionLUTDimension3D;
  r1.w = g_TM_ColorCorrectionLUTDimension3D + g_TM_ColorCorrectionLUTDimension3D;
  r1.w = 1 / r1.w;
  r1.xyz = r0.www * r1.xyz + r1.www;
  r1.xyz = g_ColorLut3d.Sample(g_LinearClampSampler_s, r1.xyz).xyz;
  r1.rgb = applyUserTonemap(untonemapped, g_ColorLut3d, g_LinearClampSampler_s, vanilla, bloom, midGray);
  if (injectedData.fxFilmGrainType == 1.f) {
  r1.rgb = applyFilmGrain(r1.rgb, v1);
  o0.rgb = renodx::color::srgb::EncodeSafe(r1.rgb);
  } else {
  r1.rgb = renodx::color::srgb::EncodeSafe(r1.rgb);
  r0.xyz = -r1.xyz + r0.xyz;
  o0.xyz = g_TM_GrainStrength * r0.xyz * injectedData.fxFilmGrain + r1.xyz;
  }
  o0.w = 1;
  return;
}