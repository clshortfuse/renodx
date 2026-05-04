// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 15:05:05 2025

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
  float Layer0SpecGloss_1 : packoffset(c128);
  float Layer0Translucency_2 : packoffset(c129);
  float3x3 Operator501_3_matrix : packoffset(c130);
  float3x3 Operator47_4_matrix : packoffset(c133);
  float3x3 Operator220_5_matrix : packoffset(c136);
}

SamplerState Layer0Diffuse_0_s : register(s0);
SamplerState Layer0Normal_1_s : register(s1);
SamplerState NGDrippingWater_2_s : register(s2);
Texture2D<float4> Layer0Diffuse_0 : register(t0);
Texture2D<float4> Layer0Normal_1 : register(t1);
Texture2D<float4> NGDrippingWater_2 : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float3 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
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

  // r1.w = saturate(r1.w);

  r0.xyz = r1.xyz;
  r0.xyzw = v2.xyzw * r0.xyzw;
  r0.w = r1.w * r0.w + -g_AlphaTestValue;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r0.w = 2;
  o0.xyz = r0.www * r0.xyz + g_SelectionOverlayCol.xyz;
  o0.w = 0.400000006;
  r0.x = dot(v6.xyz, v6.xyz);
  r0.x = rsqrt(r0.x);
  r1.xyzw = v6.xxyy * r0.xxxx;
  r0.xyz = v6.xyz * r0.xxx;
  r0.w = max(abs(r1.y), abs(r1.w));
  r1.xyzw = cmp(abs(r1.xyzw) >= r0.wwww);
  r1.xyzw = r1.xyzw ? float4(1,1,1,1) : 0;
  r1.xyzw = v3.yzxz * r1.xyzw;
  r1.xy = r1.xy + r1.zw;
  r1.z = 1;
  r2.x = dot(r1.xyz, Operator47_4_matrix._m00_m10_m20);
  r2.y = dot(r1.xyz, Operator47_4_matrix._m01_m11_m21);
  r2.xyzw = NGDrippingWater_2.Sample(NGDrippingWater_2_s, r2.xy).xyzw;
  r2.xyz = float3(0.5,0.5,0.5) + -r2.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r3.x = dot(r1.xyz, Operator501_3_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, Operator501_3_matrix._m01_m11_m21);
  r1.xyzw = NGDrippingWater_2.Sample(NGDrippingWater_2_s, r3.xy).xyzw;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r0.w = g_WeatherInfo.y * r1.w;
  r0.w = 4 * r0.w;
  r1.xyz = r1.xyz * float3(2,2,2) + -r2.xyz;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + r2.xyz;
  r1.xyz = r1.xyz * r0.www;
  r2.xyzw = Layer0Normal_1.Sample(Layer0Normal_1_s, v1.xy).xyzw;
  r3.xyz = float3(1,1,1) + r2.xyz;
  r1.xyz = r3.xyz * float3(0.5,0.5,0) + r1.xyz;
  r1.xyz = r1.xyz + -r2.xyz;
  r0.w = g_WeatherInfo.y * 0.300000012;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r1.w = dot(v5.xyz, v5.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = v5.xyz * r1.www;
  r2.xyz = r2.xyz * r1.yyy;
  r1.y = dot(v4.xyz, v4.xyz);
  r1.y = rsqrt(r1.y);
  r3.xyz = v4.xyz * r1.yyy;
  r1.xyw = r1.xxx * r3.xyz + r2.xyz;
  r0.xyz = r1.zzz * r0.xyz + r1.xyw;
  r1.x = dot(r0.xyz, r0.xyz);
  r1.x = rsqrt(r1.x);
  r0.xyz = r1.xxx * r0.xyz;
  r1.xyz = -g_NormalScale.xxx * r0.xyz;
  r0.xyz = v8.xxx ? r1.xyz : r0.xyz;
  o1.xyz = saturate(r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));
  o1.w = Layer0Translucency_2;
  r0.xy = v1.xy;
  r0.z = 1;
  r1.x = dot(r0.xyz, Operator220_5_matrix._m00_m10_m20);
  r1.y = dot(r0.xyz, Operator220_5_matrix._m01_m11_m21);
  r1.xyzw = NGDrippingWater_2.Sample(NGDrippingWater_2_s, r1.xy).xyzw;
  r0.x = saturate(-g_WeatherInfo.y + 1);
  r0.x = g_WeatherInfo.z * r0.x;
  r0.x = r1.w * r0.x + r0.w;
  o2.w = Layer0SpecGloss_1 + r0.x;
  o2.xyz = float3(0,0,0);
  r0.xy = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r0.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r0.zw = v7.xy / v7.zz;
  r0.xy = r0.xy + -r0.zw;
  o3.xy = saturate(r0.xy * float2(4,4) + float2(0.497999996,0.497999996));

  o0.w = saturate(o0.w);
  o1.w = saturate(o1.w);
  o2.w = saturate(o2.w);
  //o0.rgb = saturate(o0.rgb);
  return;
}