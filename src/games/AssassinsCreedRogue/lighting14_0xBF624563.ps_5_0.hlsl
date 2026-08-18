// ---- Created with 3Dmigoto v1.3.16 on Mon Jul 27 14:52:52 2026

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

cbuffer ShadowConstscb : register(b1)
{

  struct
  {
    float4 m_CloudUVScaleOffset;
    float4 m_CloudShadowsParams;
    float4 m_ShadowMapSize;
    float4 m_OffsetsY;
    float4 m_OffsetsX;
    float4 m_ScalesY;
    float4 m_ScalesX;
    float4 m_OffsetsZ;
    float4 m_ScalesZ;
    float4 m_OffsetsW;
    float4 m_ScalesW;
    float4 m_NoiseScale;
    float4 m_NearFar;
    float4 m_FadeParams;
    float4 m_CascadesRangesMax;
    float4 m_ShadowContrast;
    float4x4 m_WorldToLightProj;
  } g_Shadows : packoffset(c0);

}

SamplerState DepthSurface_s : register(s2);
SamplerState g_PointClampSampler_NG_s : register(s3);
SamplerState g_ProjectorShadow_s : register(s11);
SamplerState g_ShadowNoiseSampler_s : register(s14);
Texture2D<float4> g_Albedo_NG : register(t0);
Texture2D<float4> g_Normals_NG : register(t1);
Texture2D<float4> DepthSurface : register(t2);
Texture2D<float4> g_LightingAccumulation_NG : register(t3);
Texture2D<float4> g_ProjectorShadow : register(t11);
Texture2D<float4> g_ShadowNoiseSampler : register(t14);
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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.zw = r0.xy * g_ViewportScaleOffset.xy + g_ViewportScaleOffset.zw;
  r0.xy = g_ReverseProjectionParams2.xy + r0.xy;
  r0.xy = g_ReverseProjectionParams.xy * r0.xy;
  r1.xyzw = g_Normals_NG.Sample(g_PointClampSampler_NG_s, r0.zw).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.w = r1.w + r1.w;
  r2.x = dot(r1.xyz, r1.xyz);
  r2.x = rsqrt(r2.x);
  r2.xyz = r2.xxx * r1.xyz;
  r2.w = DepthSurface.SampleLevel(DepthSurface_s, r0.zw, 0).x;
  r2.w = g_ReverseProjectionParams.z + r2.w;
  r3.z = g_ReverseProjectionParams.w / r2.w;
  r3.xy = r3.zz * r0.xy;
  r3.w = 1;
  r4.x = dot(r3.xyzw, g_ViewToWorld._m00_m10_m20_m30);
  r4.y = dot(r3.xyzw, g_ViewToWorld._m01_m11_m21_m31);
  r4.z = dot(r3.xyzw, g_ViewToWorld._m02_m12_m22_m32);
  r3.xyz = r2.xyz * g_DeferredProjShadowParams.yyy + r4.xyz;
  r5.xyzw = g_DeferredProjWorldToLight[1].xyzw * r3.yyyy;
  r5.xyzw = r3.xxxx * g_DeferredProjWorldToLight[0].xyzw + r5.xyzw;
  r3.xyzw = r3.zzzz * g_DeferredProjWorldToLight[2].xyzw + r5.xyzw;
  r3.xyzw = g_DeferredProjWorldToLight[3].xyzw + r3.xyzw;
  r3.xyz = saturate(r3.xyz / r3.www);
  r0.x = saturate(g_DeferredProjShadowParams.z + r3.z);
  r0.y = g_Shadows.m_ShadowMapSize.w / g_Shadows.m_ShadowMapSize.z;
  r0.y = trunc(r0.y);
  r0.y = r3.x / r0.y;
  r3.y = 1 + -r3.y;
  r3.x = g_DeferredProjShadowParams.x + r0.y;
  r3.xy = g_Shadows.m_ShadowMapSize.zw * float2(0.5,0.5) + r3.xy;
  r3.zw = float2(0.015625,0.015625) * v0.xy;
  r3.zw = g_ShadowNoiseSampler.Sample(g_ShadowNoiseSampler_s, r3.zw).xy;
  r3.zw = float2(-0.5,-0.5) + r3.wz;
  r3.zw = g_Shadows.m_NoiseScale.xx * r3.zw;
  r5.xy = float2(0.541754603,-0.286856592) * r3.zz;
  r5.xy = r3.ww * float2(-1.35132504,-1.48180664) + -r5.xy;
  r5.z = dot(r3.wz, float2(0.541754603,-1.35132504));
  r5.xz = r5.xz * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r0.y = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xz, 0).x;
  r0.y = cmp(r0.y < r0.x);
  r0.y = r0.y ? 0 : 1;
  r5.w = dot(r3.wz, float2(-0.286856592,-1.48180664));
  r5.xy = r5.yw * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xy, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.xy = float2(1.04466522,-0.378276795) * r3.zz;
  r5.xy = r3.ww * float2(0.0852845609,-0.567544222) + -r5.xy;
  r5.z = dot(r3.wz, float2(1.04466522,0.0852845609));
  r5.xz = r5.xz * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xz, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.w = dot(r3.wz, float2(-0.378276795,-0.567544222));
  r5.xy = r5.yw * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xy, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.xy = float2(0.423478186,1.54405284) * r3.zz;
  r5.xy = r3.ww * float2(0.990938425,-1.16682863) + -r5.xy;
  r5.z = dot(r3.wz, float2(0.423478186,0.990938425));
  r5.xz = r5.xz * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xz, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.w = dot(r3.wz, float2(1.54405284,-1.16682863));
  r5.xy = r5.yw * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xy, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.xy = float2(1.92713404,1.55501103) * r3.zz;
  r5.xy = r3.ww * float2(-0.0387852415,0.957045197) + -r5.xy;
  r5.z = dot(r3.wz, float2(1.92713404,-0.0387852415));
  r5.xz = r5.xz * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xz, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.w = dot(r3.wz, float2(1.55501103,0.957045197));
  r5.xy = r5.yw * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xy, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.xy = float2(-1.77264178,-0.91532582) * r3.zz;
  r5.xy = r3.ww * float2(-0.0350671187,0.835349619) + -r5.xy;
  r5.z = dot(r3.wz, float2(-1.77264178,-0.0350671187));
  r5.xz = r5.xz * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xz, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.w = dot(r3.wz, float2(-0.91532582,0.835349619));
  r5.xy = r5.yw * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xy, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.xy = float2(-1.39283884,-0.166904166) * r3.zz;
  r5.xy = r3.ww * float2(-0.903295398,0.204589799) + -r5.xy;
  r5.z = dot(r3.wz, float2(-1.39283884,-0.903295398));
  r5.xz = r5.xz * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xz, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.w = dot(r3.wz, float2(-0.166904166,0.204589799));
  r5.xy = r5.yw * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xy, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.xy = float2(0.912372172,-0.0419260412) * r3.zz;
  r5.xy = r3.ww * float2(1.63783836,1.65058625) + -r5.xy;
  r5.z = dot(r3.wz, float2(0.912372172,1.63783836));
  r5.xz = r5.xz * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xz, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.w = dot(r3.wz, float2(-0.0419260412,1.65058625));
  r5.xy = r5.yw * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r5.xy, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r5.xy = float2(-0.977074981,-1.74537897) * r3.zz;
  r5.xy = r3.ww * float2(1.71076834,0.945010006) + -r5.xy;
  r5.z = dot(r3.wz, float2(-0.977074981,1.71076834));
  r5.w = dot(r3.wz, float2(-1.74537897,0.945010006));
  r3.zw = r5.yw * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r3.xy = r5.xz * g_Shadows.m_ShadowMapSize.zw + r3.xy;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r3.xy, 0).x;
  r2.w = cmp(r2.w < r0.x);
  r2.w = r2.w ? 0 : 1;
  r0.y = r2.w + r0.y;
  r2.w = g_ProjectorShadow.SampleLevel(g_ProjectorShadow_s, r3.zw, 0).x;
  r0.x = cmp(r2.w < r0.x);
  r0.x = r0.x ? 0 : 1;
  r0.x = r0.y + r0.x;
  r0.x = 0.0625 * r0.x;
  r3.xyz = g_EyePosition.xyz + -r4.xyz;
  r4.xyz = g_DeferredSpotLight.m_PositionFar.xyz + -r4.xyz;
  r0.y = dot(r3.xyz, r3.xyz);
  r0.y = rsqrt(r0.y);
  r2.w = dot(r4.xyz, r4.xyz);
  r3.w = rsqrt(r2.w);
  r2.w = sqrt(r2.w);
  r2.w = g_DeferredSpotLight.m_PositionFar.w * r2.w + 1;
  r2.w = saturate(g_DeferredSpotLight.m_ColorFade.w * r2.w);
  r2.w = r2.w * r2.w;
  r4.xyz = r4.xyz * r3.www;
  r3.xyz = r3.xyz * r0.yyy + r4.xyz;
  r0.y = dot(r3.xyz, r3.xyz);
  r0.y = rsqrt(r0.y);
  r3.xyz = r3.xyz * r0.yyy;
  r0.y = saturate(dot(r2.xyz, r3.xyz));
  r0.y = log2(r0.y);
  r2.x = g_LightingAccumulation_NG.Sample(g_PointClampSampler_NG_s, r0.zw).w;
  r3.xyz = g_Albedo_NG.Sample(g_PointClampSampler_NG_s, r0.zw).xyz;
  r3.xyz = g_DeferredSpotLight.m_ColorFade.xyz * r3.xyz;
  r0.z = 8.47996902 * r2.x;
  o0.w = r2.x;
  r0.z = exp2(r0.z);
  r0.y = r0.z * r0.y;
  r0.z = r0.z * 0.25 + -0.25;
  r0.y = exp2(r0.y);
  r0.w = dot(r4.xyz, r1.xyz);
  r1.x = dot(r4.xyz, g_DeferredSpotLight.m_Direction.xyz);
  r1.x = g_DeferredSpotLight.m_ConeAngles.x + -r1.x;
  r1.x = saturate(g_DeferredSpotLight.m_ConeAngles.y * r1.x);
  r1.x = r1.x * r1.x;
  r1.x = r2.w * r1.x;
  r1.y = saturate(r0.w);
  r0.w = 0.300000012 + -r0.w;
  r0.w = r1.w * r0.w;
  r0.w = max(0, r0.w);
  r0.w = r1.y + r0.w;
  r0.y = r1.y * r0.y;
  r0.y = r0.y * r0.z;
  r1.yzw = g_DeferredSpotLight.m_ColorFade.xyz * r0.yyy;
  r1.yzw = r1.yzw * r1.xxx;
  r2.xyz = r3.xyz * r1.xxx;
  r2.xyz = r2.xyz * r0.xxx;
  r0.xyz = r1.yzw * r0.xxx;
  r0.xyz = float3(0.0199999996,0.0199999996,0.0199999996) * r0.xyz;
  o0.xyz = EncodeSRGBOutput(o0.xyz);
  o0.xyz = r2.xyz * r0.www + r0.xyz;
  return;
}