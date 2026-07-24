// ---- Created with 3Dmigoto v1.3.16 on Mon Jun 15 20:36:25 2026
// HDR-safe 4x4 downscale for r16g16b16a16_float upgrades

cbuffer _Globals : register(b0)
{
  float4 g_AmbientCube[3] : packoffset(c0);
  float4 g_LayeredSkyUserColor : packoffset(c3);
  float4 g_LayeredSkyUserColor1 : packoffset(c4);
  float4 g_LayeredSkyUserColor2 : packoffset(c5);
  float4 g_LayeredSkyUserColor3 : packoffset(c6);
  float4 g_LayeredSkyUserColor4 : packoffset(c7);
  float4 g_CurrentTime : packoffset(c8);
  float4 g_HorizonTextureBlend : packoffset(c9);
  float4 g_SunColor : packoffset(c10);
  float4 g_SunDirection : packoffset(c11);
  float4 g_WorldLoadingRange : packoffset(c12);
  float4 g_GlobalWindPS : packoffset(c13);
  float4 g_SkySpritePosition : packoffset(c14);
  float4 g_VPOSReverseParams : packoffset(c15);
  float4 RainUVScroll : packoffset(c16);
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
  float4 g_EntityUniqueIDCol : packoffset(c46);
  float4 g_MaterialUniqueIDCol : packoffset(c47);
  float4 g_ShaderUniqueIDCol : packoffset(c48);
  float4 g_SelectionOverlayCol : packoffset(c49);
  float4x4 g_ConstDebugReferencePS : packoffset(c50);
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
  float g_TurnOnLights : packoffset(c201);
  float4 g_PickingID : packoffset(c124);
  float4 g_Downscale4x4SampleOffsets[16] : packoffset(c128);
}

SamplerState s0_s : register(s0);
Texture2D<float4> s0 : register(t0);

#define cmp -

#ifndef RENODX_DOWNSCALE_ALPHA_ONE
#define RENODX_DOWNSCALE_ALPHA_ONE 1
#endif

#ifndef RENODX_DOWNSCALE_CLAMP_NEGATIVE
#define RENODX_DOWNSCALE_CLAMP_NEGATIVE 1
#endif

#ifndef RENODX_DOWNSCALE_MAX_VALUE
#define RENODX_DOWNSCALE_MAX_VALUE 65504.0
#endif

float3 SafeHDRColor(float3 color)
{
  color = min(color, RENODX_DOWNSCALE_MAX_VALUE.xxx);

#if RENODX_DOWNSCALE_CLAMP_NEGATIVE
  color = max(color, 0.0.xxx);
#endif

  color = (color == color) ? color : 0.0.xxx;

  return color;
}

float4 SampleHDR(float2 uv)
{
  float4 color = s0.Sample(s0_s, uv);
  color.rgb = SafeHDRColor(color.rgb);
  color.a = (color.a == color.a) ? color.a : 1.0;
  return color;
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 sum = 0.0.xxxx;

  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[0].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[1].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[2].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[3].xy);

  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[4].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[5].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[6].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[7].xy);

  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[8].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[9].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[10].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[11].xy);

  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[12].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[13].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[14].xy);
  sum += SampleHDR(v1.xy + g_Downscale4x4SampleOffsets[15].xy);

  float4 color = sum * 0.0625;

  color.rgb = SafeHDRColor(color.rgb);

#if RENODX_DOWNSCALE_ALPHA_ONE
  color.a = 1.0;
#else
  color.a = saturate(color.a);
#endif

  o0 = color;
}