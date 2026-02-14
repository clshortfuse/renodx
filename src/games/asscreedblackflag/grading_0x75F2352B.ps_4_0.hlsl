#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 00:08:41 2025

cbuffer _Globals : register(b0)
{
  float4 g_AmbientCube[3] : packoffset(c0);
  float4 g_LayeredSkyUserColor : packoffset(c3);
  float4 g_LayeredSkyUserColor3 : packoffset(c4);
  float4 g_LayeredSkyUserColor4 : packoffset(c5);
  float4 g_CurrentTime : packoffset(c6);
  float4 g_HorizonTextureBlend : packoffset(c7);
  float4 g_SunColor : packoffset(c8);
  float4 g_SunDirection : packoffset(c9);
  float4 g_WorldLoadingRange : packoffset(c10);
  float4 g_GlobalWindPS : packoffset(c11);
  float4 g_SkySpritePosition : packoffset(c12);
  float4 g_VPOSReverseParams : packoffset(c13);
  float4 RainUVScroll : packoffset(c15);
  float4 g_RenderingReflections : packoffset(c17);
  float4 g_ViewportScaleOffset : packoffset(c18);
  float4 g_VPosToUV : packoffset(c19);
  float4 g_ReverseProjectionParams : packoffset(c20);
  float2 g_ReverseProjectionParams2 : packoffset(c21);
  float4x4 g_ViewToWorld : packoffset(c22);
  float4x4 g_WorldToView : packoffset(c26);
  float4 g_WorldEntityPosition : packoffset(c30);
  float4 g_EntityRandomSeed : packoffset(c31);
  float4 g_BoundingVolumeSize : packoffset(c32);
  float4 g_EntityToCameraDistance : packoffset(c33);
  float4 g_LODBlendFactor : packoffset(c34);
  float4 g_WeatherInfo : packoffset(c35);
  float4 g_FogWeatherParams : packoffset(c36);
  float4 g_FogParams : packoffset(c37);
  float4 g_MainPlayerPosition : packoffset(c38);
  float4 g_EyeDirection : packoffset(c39);
  float4 g_EyePosition : packoffset(c40);
  float4 g_DisolveFactor : packoffset(c41);
  float4 g_LightShaftColor : packoffset(c42);
  float4 g_LightShaftFade : packoffset(c43);
  float4 g_LightShaftFade2 : packoffset(c44);
  float4 g_EagleVisionColor : packoffset(c45);
  float4 g_FogColor : packoffset(c60);
  float4 g_FogSunBackColor : packoffset(c61);
  float g_AlphaTestValue : packoffset(c62);
  float4 g_NormalScale : packoffset(c63);

  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
  } g_OmniLights[4] : packoffset(c64);


  struct
  {
    float3 m_Direction;
    float4 m_Color;
  } g_DirectLights[2] : packoffset(c72);


  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
    float4 m_Direction;
    float4 m_ConeAngles;
  } g_SpotLights[2] : packoffset(c76);


  struct
  {
    float3 m_Direction;
    float4 m_Color;
    float3 m_SpecularDirection;
  } g_ShadowedDirect : packoffset(c84);

  float4 g_ProjWorldToLight[8] : packoffset(c87);
  float4 g_LightingIrradianceCoeffsR : packoffset(c95);
  float4 g_LightingIrradianceCoeffsG : packoffset(c96);
  float4 g_LightingIrradianceCoeffsB : packoffset(c97);
  float4 g_ProjShadowParams[2] : packoffset(c98);
  float4 g_EntityUniqueIDCol : packoffset(c120);
  float4 g_MaterialUniqueIDCol : packoffset(c121);
  float4 g_ShaderUniqueIDCol : packoffset(c122);
  float4 g_SelectionOverlayCol : packoffset(c123);
  float4 g_ConstDebugReferencePS : packoffset(c124);
  float4 g_PickingID : packoffset(c125);
  float3 g_PreLutScale : packoffset(c128);
  float3 g_PreLutOffset : packoffset(c129);
  float g_Slice : packoffset(c131);
  bool g_AssassinFilterEnabled : packoffset(c132);
  float g_AssassinFilterDesaturateIntensity : packoffset(c133);
  float4 g_AssassinFilterTintOpacity : packoffset(c134);
  float4x4 g_ColourControl : packoffset(c183);
  float g_ColorBalance_R[16] : packoffset(c135);
  float g_ColorBalance_G[16] : packoffset(c151);
  float g_ColorBalance_B[16] : packoffset(c167);
}

SamplerState FrameBuffer_s : register(s0);
SamplerState CombineTexture_s : register(s4);
SamplerState ColorBalanceR_s : register(s5);
SamplerState ColorBalanceG_s : register(s6);
SamplerState ColorBalanceB_s : register(s7);
Texture2D<float4> FrameBuffer : register(t0);
Texture2D<float4> CombineTexture : register(t4);
Texture2D<float4> ColorBalanceR : register(t5);
Texture2D<float4> ColorBalanceG : register(t6);
Texture2D<float4> ColorBalanceB : register(t7);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = FrameBuffer.Sample(FrameBuffer_s, v1.xy).xyzw;
  r1.xyzw = CombineTexture.Sample(CombineTexture_s, v1.xy).xyzw;

  // r0.xyz = saturate(r1.xyz + r0.xyz);
  r0.xyz = r1.xyz + r0.xyz;

  float3 ungraded_color;
  float3 sdr_color;
  float compression_scale;
  if (RENODX_TONE_MAP_TYPE != 0) {
    //r0.xyz = max(r0.xyz, 0);
    ungraded_color = renodx::color::gamma::DecodeSafe(r0.xyz);
    GamutCompression(ungraded_color, compression_scale);
    sdr_color = CustomGradingBegin(ungraded_color);
    r0.xyz = renodx::color::gamma::EncodeSafe(sdr_color);
  }
  else {
    r0.xyz = saturate(r0.xyz);
  }

  r0.xyz = r0.xyz * g_PreLutScale.xyz + g_PreLutOffset.xyz;
  r0.w = 0.5;
  r1.xyzw = ColorBalanceR.SampleLevel(ColorBalanceR_s, r0.xw, 0).xyzw;
  r2.xyzw = ColorBalanceG.SampleLevel(ColorBalanceG_s, r0.yw, 0).xyzw;
  r0.xyzw = ColorBalanceB.SampleLevel(ColorBalanceB_s, r0.zw, 0).yzxw;
  r0.x = r1.x;
  r0.y = r2.x;
  r0.w = 1;
  r1.x = saturate(dot(r0.xyzw, g_ColourControl._m00_m10_m20_m30));
  r1.y = saturate(dot(r0.xyzw, g_ColourControl._m01_m11_m21_m31));
  r1.z = saturate(dot(r0.xyzw, g_ColourControl._m02_m12_m22_m32));
  if (g_AssassinFilterEnabled != 0) {
    r0.x = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
    r0.xyz = r0.xxx + -r1.xyz;
    r0.xyz = g_AssassinFilterDesaturateIntensity * r0.xyz + r1.xyz;
    r2.xyz = g_AssassinFilterTintOpacity.xyz * r0.xyz;
    r2.xyz = r2.xyz * r1.xyz;
    r2.xyz = r2.xyz + r2.xyz;
    r3.xyz = float3(1,1,1) + -r1.xyz;
    r3.xyz = r3.xyz + r3.xyz;
    r0.xyz = -r0.xyz * g_AssassinFilterTintOpacity.xyz + float3(1,1,1);
    r0.xyz = -r3.xyz * r0.xyz + float3(1,1,1);
    r3.xyz = cmp(r1.xyz < float3(0.5,0.5,0.5));
    r4.xyz = r3.xyz ? float3(1,1,1) : 0;
    r3.xyz = r3.xyz ? float3(0,0,0) : float3(1,1,1);
    r0.xyz = r3.xyz * r0.xyz;
    r0.xyz = r2.xyz * r4.xyz + r0.xyz;
    r0.xyz = r0.xyz + -r1.xyz;
    r1.xyz = g_AssassinFilterTintOpacity.www * r0.xyz + r1.xyz;
  }
  o0.xyz = r1.xyz;
  o0.w = 0;

  if (RENODX_TONE_MAP_TYPE != 0) {
    float3 outputColor = renodx::color::gamma::DecodeSafe(o0.rgb);
    outputColor = CustomGradingEnd(ungraded_color, sdr_color, outputColor);
    GamutDecompression(outputColor, compression_scale);
    o0.rgb = renodx::color::gamma::EncodeSafe(outputColor);
  }
  return;
}