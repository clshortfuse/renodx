// ---- Created with 3Dmigoto v1.4.1 on Mon Dec  1 14:31:16 2025

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
  float3x3 Alpha2UV_1_matrix : packoffset(c128);
  float3x3 DiffuseUV_2_matrix : packoffset(c131);
  float Alpha_3 : packoffset(c134);
  float UseAlpha2_4 : packoffset(c135);
  bool g_HasSunOther : packoffset(c136);
}

SamplerState Alpha2_0_s : register(s0);
SamplerState Border_1_s : register(s1);
SamplerState DepthSurface_s : register(s8);
Texture2D<float4> Alpha2_0 : register(t0);
Texture2D<float4> Border_1 : register(t1);
Texture2D<float4> DepthSurface : register(t8);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v4.w < 0);
  if (r0.x != 0) discard;
  r0.xy = v2.xy;
  r0.z = 1;
  r1.x = dot(r0.xyz, Alpha2UV_1_matrix._m00_m10_m20);
  r1.y = dot(r0.xyz, Alpha2UV_1_matrix._m01_m11_m21);
  r1.xyzw = Alpha2_0.Sample(Alpha2_0_s, r1.xy).xyzw;
  r0.w = -1 + r1.y;
  r0.w = UseAlpha2_4 * r0.w + 1;
  r0.w = v3.w * r0.w;
  r1.x = dot(r0.xyz, DiffuseUV_2_matrix._m00_m10_m20);
  r1.y = dot(r0.xyz, DiffuseUV_2_matrix._m01_m11_m21);
  r1.xyzw = Border_1.Sample(Border_1_s, r1.xy).xyzw;
  r0.x = r1.x * 0.252999991 + r1.y;
  r0.x = r0.w * r0.x;
  r0.x = Alpha_3 * r0.x;
  r0.yz = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r1.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r0.yz, 0).xyzw;
  r0.y = g_ReverseProjectionParams.z + r1.x;
  r0.y = g_ReverseProjectionParams.w / r0.y;
  r0.y = saturate(-v1.w + -r0.y);
  r0.z = r0.y * r0.x + -g_AlphaTestValue;
  r0.x = r0.y * r0.x;
  r0.y = cmp(r0.z < 0);
  if (r0.y != 0) discard;
  o0.w = r0.x;
  o1.w = r0.x;
  o0.xyz = g_SelectionOverlayCol.xyz + float3(1,1,1);
  o1.xyz = v1.zzz / v1.www;

  o0.w = saturate(o0.w);
  o1.w = saturate(o1.w);
  return;
}