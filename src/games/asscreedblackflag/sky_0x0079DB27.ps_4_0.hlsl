#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 11:07:45 2025

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
  float SkyCloudTimeOscillator_1 : packoffset(c128);
  float HorizonTextureBlend_2 : packoffset(c129);
  float4 SunriseUVs_3 : packoffset(c130);
}

SamplerState SkyCloudAddBiasTex_0_s : register(s0);
SamplerState SkyDomeColorRampTex_1_s : register(s1);
SamplerState StormTexture_2_s : register(s2);
SamplerState ScatteringGradient1D_3_s : register(s3);
SamplerState SunriseTexture_4_s : register(s4);
SamplerState SunsetTexture_5_s : register(s5);
Texture2D<float4> SkyCloudAddBiasTex_0 : register(t0);
Texture2D<float4> SkyDomeColorRampTex_1 : register(t1);
Texture2D<float4> StormTexture_2 : register(t2);
Texture2D<float4> ScatteringGradient1D_3 : register(t3);
Texture2D<float4> SunriseTexture_4 : register(t4);
Texture2D<float4> SunsetTexture_5 : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  uint v4 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 32 * v1.y;
  r0.y = floor(r0.x);
  r0.x = frac(r0.x);
  r1.z = r0.y * 0.03125 + 0.03125;
  r1.x = 0.03125 * r0.y;
  r1.y = g_CurrentTime.y;
  r2.xyzw = SkyDomeColorRampTex_1.Sample(SkyDomeColorRampTex_1_s, r1.yz).xyzw;
  r1.xyzw = SkyDomeColorRampTex_1.Sample(SkyDomeColorRampTex_1_s, r1.yx).xyzw;
  r0.yzw = r2.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r1.x = SkyCloudTimeOscillator_1 + v1.x;
  r1.y = v1.y;
  r2.xyzw = SkyCloudAddBiasTex_0.Sample(SkyCloudAddBiasTex_0_s, r1.xy).xyzw;
  r1.xyzw = StormTexture_2.Sample(StormTexture_2_s, r1.xy).xyzw;
  r2.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r2.xyz = g_LayeredSkyUserColor3.www * r2.xyz;
  r0.xyz = r2.xyz * float3(2,2,2) + r0.xyz;
  r0.xzw = r0.xyz + -r0.yyy;
  r0.xyz = g_LayeredSkyUserColor4.www * r0.xzw + r0.yyy;
  r2.xyz = g_LayeredSkyUserColor.xyz * r0.xyz;
  r3.xyzw = SunsetTexture_5.Sample(SunsetTexture_5_s, v1.xy).xyzw;
  r4.xy = SunriseUVs_3.xy + v1.xy;
  r4.xyzw = SunriseTexture_4.Sample(SunriseTexture_4_s, r4.xy).xyzw;

  // if (RENODX_TONE_MAP_TYPE != 0) {
  //   r3.rgb = HDRBoost(r3.rgb, 1.f);
  //   r4.rgb = HDRBoost(r4.rgb, 1.f);
  // }

  r0.w = HorizonTextureBlend_2 * g_HorizonTextureBlend.x;
  r1.w = saturate(r0.w);
  r0.w = saturate(-r0.w);
  r4.xyz = r4.xyz * r1.www;
  r1.w = v3.y * r1.w;
  r1.w = v3.x * r0.w + r1.w;
  r3.xyz = r3.xyz * r0.www + r4.xyz;
  r0.xyz = -r0.xyz * g_LayeredSkyUserColor.xyz + r3.xyz;
  r0.xyz = r1.www * r0.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = g_LayeredSkyUserColor.www * r1.xyz + r0.xyz;
  r0.w = dot(v2.xyzw, v2.xyzw);
  r0.w = rsqrt(r0.w);
  r1.xyz = v2.xyz * r0.www;
  r1.x = saturate(dot(r1.xyz, g_SkySpritePosition.xyz));
  r1.y = 0;
  r1.xyzw = ScatteringGradient1D_3.Sample(ScatteringGradient1D_3_s, r1.xy).xyzw;

  // if (RENODX_TONE_MAP_TYPE != 0) {
  //   r1.rgb *= 10.f;
  // }

  r0.xyz = g_LayeredSkyUserColor4.xyz * r1.xxx + r0.xyz;
  o0.xyz = g_SelectionOverlayCol.xyz + r0.xyz;
  o0.w = v3.w;

  //o0.rgb = HDRBoost(o0.rgb, 0.5f);
  return;
}