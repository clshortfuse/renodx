// ---- Created with 3Dmigoto v1.4.1 on Mon Dec  1 13:27:38 2025

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
  float Layer0UVScaleSpecular_1 : packoffset(c128);
  float Layer0SpecGloss_2 : packoffset(c129);
  float3x3 Operator47_3_matrix : packoffset(c130);
  float3x3 Operator50_4_matrix : packoffset(c133);
  float NGWaterFlowIntensity_5 : packoffset(c136);
}

SamplerState Layer0Diffuse_0_s : register(s0);
SamplerState Layer0Normal_1_s : register(s1);
SamplerState Layer0Specular_2_s : register(s2);
SamplerState NGDrippingWater_3_s : register(s3);
Texture2D<float4> Layer0Diffuse_0 : register(t0);
Texture2D<float4> Layer0Normal_1 : register(t1);
Texture2D<float4> Layer0Specular_2 : register(t2);
Texture2D<float4> NGDrippingWater_3 : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD1,
  float4 v5 : TEXCOORD2,
  float4 v6 : TEXCOORD3,
  float4 v7 : TEXCOORD4,
  float3 v8 : TEXCOORD5,
  uint v9 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float2 o3 : SV_Target3)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.w = 1;
  r1.xyzw = Layer0Diffuse_0.Sample(Layer0Diffuse_0_s, v1.xy).xyzw;
  r0.xyz = r1.xyz;
  r0.xyzw = v2.xyzw * r0.xyzw;
  r0.w = r1.w * r0.w + -g_AlphaTestValue;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r0.w = 2;
  r0.xyz = r0.www * r0.xyz;
  o0.xyz = r0.xyz * g_EagleVisionColor.www + g_SelectionOverlayCol.xyz;
  o2.xyz = g_EagleVisionColor.xyz * r0.xyz;
  o0.w = v3.y;
  r0.x = dot(v7.xyz, v7.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v7.xyz * r0.xxx;
  r0.w = max(abs(r0.x), abs(r0.y));
  r0.w = max(r0.w, abs(r0.z));
  r1.xyz = cmp(abs(r0.xyz) >= r0.www);
  r1.xyz = r1.xyz ? float3(1,1,1) : 0;
  r2.xyzw = v4.xyyz * r1.zzxx;
  r1.xz = r2.xy + r2.zw;
  r1.xy = v4.xz * r1.yy + r1.xz;
  r1.z = 1;
  r2.x = dot(r1.xyz, Operator47_3_matrix._m00_m10_m20);
  r2.y = dot(r1.xyz, Operator47_3_matrix._m01_m11_m21);
  r2.xyzw = NGDrippingWater_3.Sample(NGDrippingWater_3_s, r2.xy).xyzw;
  r2.xyz = float3(0.5,0.5,0.5) + -r2.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r3.x = dot(r1.xyz, Operator50_4_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, Operator50_4_matrix._m01_m11_m21);
  r1.xyzw = NGDrippingWater_3.Sample(NGDrippingWater_3_s, r3.xy).xyzw;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + -r2.xyz;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + r2.xyz;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = float3(1,1,0) * r1.xyz;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = rsqrt(r0.w);
  r1.xyz = saturate(r1.xyz * r0.www);
  r2.xyzw = Layer0Normal_1.Sample(Layer0Normal_1_s, v1.zw).xyzw;
  r3.xyz = float3(1,1,1) + r2.xyz;
  r1.xyz = r3.xyz * float3(0.5,0.5,0.5) + r1.xyz;
  r1.xyz = r1.xyz + -r2.xyz;
  r0.w = saturate(g_WeatherInfo.y + -0.699999988);
  r0.w = NGWaterFlowIntensity_5 * r0.w;
  r0.w = 0.200000003 * r0.w;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r0.w = dot(v6.xyz, v6.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v6.xyz * r0.www;
  r2.xyz = r2.xyz * r1.yyy;
  r0.w = dot(v5.xyz, v5.xyz);
  r0.w = rsqrt(r0.w);
  r3.xyz = v5.xyz * r0.www;
  r1.xyw = r1.xxx * r3.xyz + r2.xyz;
  r0.xyz = r1.zzz * r0.xyz + r1.xyw;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  o1.xyz = saturate(r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));
  o1.w = 0;
  r0.xy = Layer0UVScaleSpecular_1 * v1.xy;
  r0.xyzw = Layer0Specular_2.Sample(Layer0Specular_2_s, r0.xy).xyzw;
  r0.x = g_WeatherInfo.y * g_WeatherInfo.z;
  o2.w = r0.y * Layer0SpecGloss_2 + r0.x;
  r0.xy = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r0.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r0.zw = v8.xy / v8.zz;
  r0.xy = r0.xy + -r0.zw;
  o3.xy = saturate(r0.xy * float2(4,4) + float2(0.497999996,0.497999996));

  o0.w = saturate(o0.w);
  o2.w = saturate(o2.w);
  return;
}