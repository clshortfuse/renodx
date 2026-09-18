// ---- Created with 3Dmigoto v1.3.16 on Sat Jul 04 18:35:44 2026

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
  float4 g_WorldAOMapUVParameters : packoffset(c171);
  float4 g_WorldAOParameters : packoffset(c144);
  float4 g_WorldAORangeParameters : packoffset(c145);
  float4 g_WeatherExposedParams : packoffset(c143);
  float4 g_WinterParams : packoffset(c160);
  float4 g_SnowSparklesParams : packoffset(c161);
  float4 g_DebugValue : packoffset(c202) = {0,0,0,0};
}

SamplerState DepthSurface_s : register(s2);
SamplerState g_PointClampSampler_NG_s : register(s3);
SamplerState g_WeatherReflectionCubeMap_s : register(s5);
SamplerState g_WorldLightmapIndirectSampler_s : register(s7);
SamplerState g_WorldLightMapDirectSampler_s : register(s12);
SamplerState g_AmbientTexture_s : register(s13);
Texture2D<float4> g_Albedo_NG : register(t0);
Texture2D<float4> g_Normals_NG : register(t1);
Texture2D<float4> DepthSurface : register(t2);
Texture2D<float4> g_LightingAccumulation_NG : register(t3);
TextureCube<float4> g_WeatherReflectionCubeMap : register(t5);
Texture2D<float4> g_WorldLightmapIndirectSampler : register(t7);
Texture2D<float4> g_WorldLightMapDirectSampler : register(t12);
Texture2D<float4> g_AmbientTexture : register(t13);


// 3Dmigoto declarations
#define cmp -
#ifndef MANUAL_SRGB_RT_ENCODE
#define MANUAL_SRGB_RT_ENCODE 1
#endif

float3 LinearToSRGB(float3 c)
{
  float3 lo = c * 12.92;
  float3 hi = 1.055 * pow(max(c, 0.0), 1.0 / 2.4) - 0.055;
  return lerp(lo, hi, step(0.0031308, c));
}

float3 EncodeSRGBOutput(float3 c)
{
#if MANUAL_SRGB_RT_ENCODE
  c = LinearToSRGB(max(c, 0.0));
#endif
  return c;
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float3 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
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
  r1.xyz = g_Normals_NG.Sample(g_PointClampSampler_NG_s, r0.xy).xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r0.zw = r1.xy * g_WorldLightMapParameters2.xx + r2.xy;
  r0.zw = r0.zw * g_WorldLightMapUVParameters.zw + g_WorldLightMapUVParameters.xy;
  r3.xyzw = g_WorldLightmapIndirectSampler.SampleLevel(g_WorldLightmapIndirectSampler_s, r0.zw, 0).xyzw;
  r0.z = r3.w * g_WorldLightMapParameters1.x + g_WorldLightMapParameters1.y;
  r3.xyz = r3.xyz * r3.xyz;
  r0.z = r0.z + -r2.z;
  r0.z = r1.z * g_WorldLightMapParameters2.y + r0.z;
  r0.z = g_WorldLightMapParameters1.z * abs(r0.z);
  r0.z = -r0.z * r0.z + 1;
  r0.z = max(0, r0.z);
  r0.z = g_WorldLightMapParameters3.w * r0.z;
  r3.xyz = r3.xyz * r0.zzz;
  r4.z = -r2.z;
  r5.xyz = g_EyePosition.xyz + -r2.xyz;
  r0.zw = r2.xy * g_WorldLightMapUVParameters.zw + g_WorldLightMapUVParameters.xy;
  r2.xyzw = g_WorldLightMapDirectSampler.SampleLevel(g_WorldLightMapDirectSampler_s, r0.zw, 0).xyzw;
  r0.zw = r2.xy * float2(2,2) + float2(-1,-1);
  r4.xy = g_WorldLightMapParameters1.ww * r0.zw;
  r2.z = r2.z * g_WorldLightMapParameters1.x + g_WorldLightMapParameters1.y;
  r2.xy = float2(0,0);
  r2.xyz = r2.xyz + r4.xyz;
  r0.z = g_WorldLightMapParameters1.z * abs(r2.z);
  r0.z = -r0.z * r0.z + 1;
  r0.z = saturate(r2.w * r0.z);
  r4.xyz = g_WorldLightMapParameters3.xyz * r0.zzz;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = r2.xyz * r0.zzz;
  r0.z = saturate(dot(r1.xyz, r2.xyz));
  r3.xyz = r0.zzz * r4.xyz + r3.xyz;
  r0.w = dot(r5.xyz, r5.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r5.xyz * r0.www + r2.xyz;
  r5.xyz = r5.xyz * r0.www;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r0.w = saturate(dot(r1.xyz, r2.xyz));
  r0.w = log2(r0.w);
  r2.xyzw = g_LightingAccumulation_NG.Sample(g_PointClampSampler_NG_s, r0.xy).xyzw;
  r1.w = g_WinterParams.w + -r2.w;
  r6.xyzw = g_Albedo_NG.Sample(g_PointClampSampler_NG_s, r0.xy).xyzw;
  r7.xyz = g_AmbientTexture.Sample(g_AmbientTexture_s, r0.xy).xyz;
  r7.xyz = saturate(r7.xyz * r6.xyz);
  r0.x = r6.w * r1.w + r2.w;
  r0.y = 8.47996902 * r0.x;
  r0.y = exp2(r0.y);
  r0.w = r0.y * r0.w;
  r0.y = r0.y * 0.25 + -0.25;
  r0.w = exp2(r0.w);
  r0.z = r0.z * r0.w;
  r0.y = r0.z * r0.y;
  r0.yzw = r0.yyy * r4.xyz;
  r0.yzw = float3(0.0199999996,0.0199999996,0.0199999996) * r0.yzw;
  r0.yzw = r3.xyz * r6.xyz + r0.yzw;
  r0.yzw = r2.xyz + r0.yzw;
  r1.w = dot(-r5.xyz, r1.xyz);
  r1.w = r1.w + r1.w;
  r1.xyz = r1.xzy * -r1.www + -r5.xzy;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r1.w = 1 + -r0.x;
  o0.w = r0.x;
  r0.x = 6 * r1.w;
  r1.xyz = g_WeatherReflectionCubeMap.SampleLevel(g_WeatherReflectionCubeMap_s, r1.xyz, r0.x).xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.xyz = abs(r1.xyz) * float3(0.25,0.25,0.25) + r0.yzw;
  o0.xyz = r7.xyz + r0.xyz;
   o0.xyz = EncodeSRGBOutput(o0.xyz);
  return;
}