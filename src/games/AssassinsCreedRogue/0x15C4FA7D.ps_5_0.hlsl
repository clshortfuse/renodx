// ---- Created with 3Dmigoto v1.3.16 on Sat Jul 04 19:00:43 2026

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

  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
  } g_DeferredOmniLight : packoffset(c128);


  struct
  {
    float3 m_Direction;
    float4 m_Color;
  } g_DeferredDirectLight : packoffset(c130);


  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
    float4 m_Direction;
    float4 m_ConeAngles;
  } g_DeferredSpotLight : packoffset(c132);

  float4 g_DeferredProjWorldToLight[4] : packoffset(c136);
  float4 g_DeferredProjShadowParams : packoffset(c140);
  float4 g_DeferredBackgroundColor : packoffset(c141);
  float4 g_DepthParams : packoffset(c150);
  float4 g_WorldLightMapParameters1 : packoffset(c155);
  float4 g_WorldLightMapParameters2 : packoffset(c156);
  float4 g_WorldLightMapParameters3 : packoffset(c157);
  float4 g_WorldLightMapUVParameters : packoffset(c158);
  float4 g_WeatherExposedParams : packoffset(c143);
  float4 g_WinterParams : packoffset(c160);
  float4 g_SnowSparklesParams : packoffset(c161);
  float4 g_DebugValue : packoffset(c202) = {0,0,0,0};
}

SamplerState DepthSurface_s : register(s2);
SamplerState g_PointClampSampler_NG_s : register(s3);
Texture2D<float4> g_Albedo_NG : register(t0);
Texture2D<float4> g_Normals_NG : register(t1);
Texture2D<float4> DepthSurface : register(t2);
Texture2D<float4> g_LightingAccumulation_NG : register(t3);


float3 EncodeSRGBOutput(float3 c)
{
#if MANUAL_SRGB_RT_ENCODE
  c = LinearToSRGB(max(c, 0.0));
#endif
  return c;
}
// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float3 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.zw = g_ReverseProjectionParams2.xy + r0.xy;
  r0.xy = r0.xy * g_ViewportScaleOffset.xy + g_ViewportScaleOffset.zw;
  r0.zw = g_ReverseProjectionParams.xy * r0.zw;
  r1.x = DepthSurface.SampleLevel(DepthSurface_s, r0.xy, 0).x;
  r1.x = g_ReverseProjectionParams.z + r1.x;
  r1.z = g_ReverseProjectionParams.w / r1.x;
  r1.xy = r1.zz * r0.zw;
  r1.w = 1;
  r2.x = dot(r1.xyzw, g_ViewToWorld._m00_m10_m20_m30);
  r2.y = dot(r1.xyzw, g_ViewToWorld._m01_m11_m21_m31);
  r2.z = dot(r1.xyzw, g_ViewToWorld._m02_m12_m22_m32);
  r1.xyz = g_EyePosition.xyz + -r2.xyz;
  r2.xyz = g_DeferredOmniLight.m_PositionFar.xyz + -r2.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r0.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = g_DeferredOmniLight.m_PositionFar.w * r0.w + 1;
  r0.w = saturate(g_DeferredOmniLight.m_ColorFade.w * r0.w);
  r0.w = r0.w * r0.w;
  r2.xyz = r2.xyz * r1.www;
  r1.xyz = r1.xyz * r0.zzz + r2.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r3.xyzw = g_Normals_NG.Sample(g_PointClampSampler_NG_s, r0.xy).xyzw;
  r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.z = r3.w + r3.w;
  r1.w = dot(r3.xyz, r3.xyz);
  r1.w = rsqrt(r1.w);
  r4.xyz = r3.xyz * r1.www;
  r1.w = dot(r2.xyz, r3.xyz);
  r1.x = saturate(dot(r4.xyz, r1.xyz));
  r1.x = log2(r1.x);
  r1.y = g_LightingAccumulation_NG.Sample(g_PointClampSampler_NG_s, r0.xy).w;
  r2.xyz = g_Albedo_NG.Sample(g_PointClampSampler_NG_s, r0.xy).xyz;
  r2.xyz = g_DeferredOmniLight.m_ColorFade.xyz * r2.xyz;
  r2.xyz = r2.xyz * r0.www;
  r0.x = 8.47996902 * r1.y;
  o0.w = r1.y;
  r0.x = exp2(r0.x);
  r0.y = r0.x * r1.x;
  r0.x = r0.x * 0.25 + -0.25;
  r0.y = exp2(r0.y);
  r1.x = saturate(r1.w);
  r1.y = 0.300000012 + -r1.w;
  r0.z = r1.y * r0.z;
  r0.z = max(0, r0.z);
  r0.z = r1.x + r0.z;
  r0.y = r1.x * r0.y;
  r0.x = r0.y * r0.x;
  r1.xyz = g_DeferredOmniLight.m_ColorFade.xyz * r0.xxx;
  r0.xyw = r1.xyz * r0.www;
  r0.xyw = float3(0.0199999996,0.0199999996,0.0199999996) * r0.xyw;
  o0.xyz = r2.xyz * r0.zzz + r0.xyw;
    o0.xyz = EncodeSRGBOutput(o0.xyz);
  return;
}