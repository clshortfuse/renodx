// ---- Created with 3Dmigoto v1.3.16 on Mon Jun 15 20:45:48 2026

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
  float OffsetU_1 : packoffset(c128);
  float AboveWaterTrue1_2 : packoffset(c129);
  float CubeMapMultiplier_3 : packoffset(c130);
  float3x3 UVLayer0_4_matrix : packoffset(c131);
  float NormalIntensity_5 : packoffset(c134);
  float WatarColorMaxDepth_6 : packoffset(c135);
  float UVFrequency_7 : packoffset(c136);
  float DepthFade_8 : packoffset(c137);
  float RefractionIntensity_9 : packoffset(c138);
  float FresnelExponent_10 : packoffset(c139);
  float MaterialAlpha_11 : packoffset(c140);
  float AlphaRimInvert_12 : packoffset(c141);
  float AlphaRim_13 : packoffset(c142);
  float AlphaRimCoeff_14 : packoffset(c143);
  float4 WaterDeepColor_15 : packoffset(c144);
  bool g_HasSunOther : packoffset(c202);
}

SamplerState CubeMap_0_s : register(s0);
SamplerState NormalMap_0_s : register(s1);
SamplerState DepthSurface_s : register(s8);
SamplerState g_RefractionSampler_s : register(s12);

TextureCube<float4> CubeMap_0 : register(t0);
Texture2D<float4> NormalMap_0 : register(t1);
Texture2D<float4> DepthSurface : register(t8);
Texture2D<float4> g_RefractionSampler : register(t12);

#define cmp -

#ifndef WATER_HDR_SOFT_CAP
#define WATER_HDR_SOFT_CAP 2.25
#endif

#ifndef WATER_HDR_HARD_CAP
#define WATER_HDR_HARD_CAP 6.0
#endif

float SafeDiv(float x)
{
  return abs(x) < 0.000001 ? 0.000001 : x;
}

float SafeRSqrt(float x)
{
  return rsqrt(max(x, 0.000001));
}

float3 SoftWaterHDRClamp(float3 color)
{
  color = max(color, 0.0);

  float3 over = max(color - 1.0, 0.0);
  color = min(color, 1.0) + over / (1.0 + over / max(WATER_HDR_SOFT_CAP - 1.0, 0.0001));

  return min(color, WATER_HDR_HARD_CAP);
}

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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = sin(UVFrequency_7);
  r1.xy = v2.xy;
  r1.z = 1;
  r0.y = dot(r1.xyz, UVLayer0_4_matrix._m00_m10_m20);
  r1.y = dot(r1.xyz, UVLayer0_4_matrix._m01_m11_m21);
  r1.x = r0.x * OffsetU_1 + r0.y;

  r0.xyzw = NormalMap_0.Sample(NormalMap_0_s, r1.xy).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,1) + float4(-1,-1,-1,0);

  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;

  r0.w = dot(r1.xyzw, r1.xyzw);
  r0.w = SafeRSqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;

  r1.xyz = AboveWaterTrue1_2 * float3(0,0,2) + float3(0,0,-1);
  r0.xyz = r0.xyz * r1.zzz + -r1.yyz;
  r0.xyz = NormalIntensity_5 * r0.xyz + r1.xyz;

  r1.xyz = v6.xyz * r0.yyy;
  r1.xyz = r0.xxx * v5.xyz + r1.xyz;
  r1.xyz = r0.zzz * v7.xyz + r1.xyz;

  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = SafeRSqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;

  r2.xyz = -g_EyePosition.xzy + v4.xzy;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = SafeRSqrt(r0.z);
  r2.xyz = r2.xyz * r0.zzz;

  r0.z = dot(r2.xzy, r1.xyz);
  r0.z = r0.z + r0.z;
  r2.xyz = r1.xzy * -r0.zzz + r2.xyz;

  r2.xyz = CubeMap_0.Sample(CubeMap_0_s, r2.xyz).xyz;

  r0.zw = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r0.xy = r0.zw + r0.xy;
  r3.xy = r0.zw + -r0.xy;

  r0.z = DepthSurface.SampleLevel(DepthSurface_s, r0.zw, 0).x;
  r0.z = g_ReverseProjectionParams.z + r0.z;
  r0.z = g_ReverseProjectionParams.w / SafeDiv(r0.z);
  r0.z = -v1.w + -r0.z;
  r0.z = saturate(DepthFade_8 * abs(r0.z));
  r0.z = v3.w * r0.z;

  r0.w = DepthSurface.SampleLevel(DepthSurface_s, r0.xy, 0).x;
  r0.w = g_ReverseProjectionParams.z + r0.w;
  r0.w = g_ReverseProjectionParams.w / SafeDiv(r0.w);
  r0.w = -v1.w + -r0.w;
  r0.w = cmp(0 >= r0.w);
  r0.w = r0.w ? 1.000000 : 0;

  r0.xy = r0.ww * r3.xy + r0.xy;

  r0.w = DepthSurface.SampleLevel(DepthSurface_s, r0.xy, 0).x;
  r0.w = g_ReverseProjectionParams.z + r0.w;
  r3.z = g_ReverseProjectionParams.w / SafeDiv(r0.w);

  r4.xy = float2(-0.5,-0.5) + r0.xy;

  r0.xyw = g_RefractionSampler.Sample(g_RefractionSampler_s, r0.xy).xyz;
  r0.xyw = RefractionIntensity_9 * r0.xyw;

  r4.xy = r4.xy * float2(2,-2) + g_ReverseProjectionParams2.xy;
  r4.xy = g_ReverseProjectionParams.xy * r4.xy;
  r3.xy = r4.xy * r3.zz;
  r3.w = 1;

  r4.x = dot(r3.xyzw, g_ViewToWorld._m00_m10_m20_m30);
  r4.y = dot(r3.xyzw, g_ViewToWorld._m01_m11_m21_m31);
  r4.z = dot(r3.xyzw, g_ViewToWorld._m02_m12_m22_m32);
  r4.w = dot(r3.xyzw, g_ViewToWorld._m03_m13_m23_m33);

  r3.xyz = v4.xyz;
  r3.w = 0;

  r4.xyzw = r4.xyzw + -r3.xyzw;
  r3.xyzw = g_EyePosition.xyzw + -r3.xyzw;

  r1.w = dot(r4.xyzw, r4.xyzw);
  r1.w = sqrt(max(r1.w, 0.0));
  r1.w = saturate(r1.w / max(WatarColorMaxDepth_6, 0.000001));

  r4.xyz = WaterDeepColor_15.xyz * r1.www + -r0.xyw;
  r0.xyw = r1.www * r4.xyz + r0.xyw;

  r1.w = dot(r3.xyzw, r3.xyzw);
  r1.w = SafeRSqrt(r1.w);
  r3.xyz = r3.xyz * r1.www;

  r1.w = saturate(dot(r3.xyz, r1.xyz));

  r1.x = dot(r1.xyz, g_EyeDirection.xyz);
  r1.x = log2(max(abs(r1.x), 0.000001));
  r1.x = AlphaRimCoeff_14 * r1.x;
  r1.x = exp2(r1.x);
  r1.x = -1 + r1.x;
  r1.x = AlphaRim_13 * r1.x + 1;

  r1.y = log2(max(r1.w, 0.000001));
  r1.y = FresnelExponent_10 * r1.y;
  r1.y = exp2(r1.y);
  r1.y = CubeMapMultiplier_3 * r1.y;

  r0.xyw = r2.xyz * r1.yyy + r0.xyw;

  r0.xyw = SoftWaterHDRClamp(r0.xyw);

  r1.yzw = g_EyePosition.xyz + -v4.xyz;
  r2.x = dot(r1.yzw, r1.yzw);
  r2.y = SafeRSqrt(r2.x);
  r2.x = sqrt(max(r2.x, 0.0));
  r1.yzw = r2.yyy * r1.yzw;

  r1.y = dot(g_SunDirection.xyz, r1.yzw);
  r1.y = 1 + r1.y;
  r1.y = -r1.y * 0.5 + 1;
  r1.y = r1.y * r1.y;

  r2.yzw = -g_FogSunBackColor.xyz + g_FogColor.xyz;
  r1.yzw = r1.yyy * r2.yzw + g_FogSunBackColor.xyz;
  r1.yzw = r1.yzw + -r0.xyw;

  r2.y = -g_FogParams.x + r2.x;
  r2.x = -20 + r2.x;
  r2.x = saturate(0.0700000003 * r2.x);
  r2.x = 1 + -r2.x;
  r2.x = -r2.x * r2.x + 1;
  r2.x = g_FogWeatherParams.x * r2.x;

  r2.z = g_FogParams.y + -g_FogParams.x;
  r2.y = saturate(r2.y / SafeDiv(r2.z));
  r2.y = 1 + -r2.y;
  r2.y = r2.y * r2.y;
  r2.y = -r2.y * r2.y + 1;

  r2.z = g_EyePosition.z + g_FogParams.z;
  r2.z = v4.z + -r2.z;
  r2.z = min(g_FogParams.z, r2.z);
  r2.z = saturate(-r2.z * g_FogParams.w + 1);

  r2.x = saturate(r2.y * r2.z + r2.x);
  r0.xyw = r2.xxx * r1.yzw + r0.xyw;

  r1.y = 1 + -r2.x;

  o0.xyz = SoftWaterHDRClamp(g_SelectionOverlayCol.xyz + r0.xyw);

  r0.x = saturate(r1.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.x + -r1.x;
  r0.x = AlphaRimInvert_12 * r0.x + r1.x;
  r0.x = r0.z * r0.x;
  r0.x = MaterialAlpha_11 * r0.x;
  r0.x = r0.x * r1.y;

  o0.w = saturate(r0.x);
  o1.w = saturate(r0.x);
  o1.xyz = v1.zzz / SafeDiv(v1.www);

  return;
}