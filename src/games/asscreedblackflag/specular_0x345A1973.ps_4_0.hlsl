// ---- Created with 3Dmigoto v1.4.1 on Mon Nov 24 02:43:07 2025

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
  float Layer0NormalWeight_1 : packoffset(c128);
  float Layer0SpecInt_2 : packoffset(c129);
  float Layer0SpecGlossy_3 : packoffset(c130);
  float4 ReflectionTint_4 : packoffset(c131);
  float FresnelExp_5 : packoffset(c132);
  float FresnelCoef_6 : packoffset(c133);
  float NGReflectionAmount_7 : packoffset(c134);
}

SamplerState ReflectionCubemap_0_s : register(s0);
SamplerState Layer0Diffuse_0_s : register(s1);
SamplerState Layer0Normal_1_s : register(s2);
SamplerState Layer0Specular_2_s : register(s3);
TextureCube<float4> ReflectionCubemap_0 : register(t0);
Texture2D<float4> Layer0Diffuse_0 : register(t1);
Texture2D<float4> Layer0Normal_1 : register(t2);
Texture2D<float4> Layer0Specular_2 : register(t3);


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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(-g_AlphaTestValue < 0);
  if (r0.x != 0) discard;
  r0.x = dot(v4.xyz, v4.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v4.xyz * r0.xxx;
  r0.w = dot(v5.xyz, v5.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v5.xyz * r0.www;
  r2.xyzw = Layer0Normal_1.Sample(Layer0Normal_1_s, v1.xy).xyzw;

  r2.w = saturate(r2.w);

  r2.xyz = float3(-0.5,-0.5,-1) + r2.xyz;
  r2.xyz = Layer0NormalWeight_1 * r2.xyz + float3(0,0,0.5);
  r2.xyz = r2.xyz + r2.xyz;
  r1.xyz = r2.yyy * r1.xyz;
  r0.xyz = r2.xxx * r0.xyz + r1.xyz;
  r0.w = dot(v6.xyz, v6.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v6.xyz * r0.www;
  r0.xyz = r2.zzz * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = -g_EyePosition.xyz + v3.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r0.w = dot(r1.xyz, r0.xyz);
  r0.w = r0.w + r0.w;
  r2.xyz = r0.xzy * -r0.www + r1.xzy;
  r0.w = dot(-r1.xyz, r0.xyz);
  o1.xyz = saturate(r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));
  r0.x = 1 + -r0.w;
  r1.xyzw = ReflectionCubemap_0.Sample(ReflectionCubemap_0_s, r2.xyz).xyzw;

  r1.w = saturate(r1.w);

  r0.yzw = ReflectionTint_4.xyz * r1.xyz;
  r1.xyzw = Layer0Specular_2.Sample(Layer0Specular_2_s, v1.xy).xyzw;

  r1.w = saturate(r1.w);

  r1.x = Layer0SpecInt_2 * r1.x;
  r1.y = Layer0SpecGlossy_3 * r1.y;
  r1.x = r1.x * r1.y;
  r0.yzw = r1.xxx * r0.yzw;
  r1.x = abs(r0.x) * abs(r0.x);
  r1.x = r1.x * r1.x;
  r0.x = r1.x * abs(r0.x);
  r1.x = -FresnelCoef_6 + 1;
  r0.x = r1.x * r0.x + FresnelCoef_6;
  r1.x = log2(abs(FresnelExp_5));
  r0.x = r1.x * r0.x;
  r0.x = exp2(r0.x);
  r0.xyz = r0.yzw * r0.xxx;
  r1.xyzw = Layer0Diffuse_0.Sample(Layer0Diffuse_0_s, v1.xy).xyzw;

  r1.w = saturate(r1.w);

  r0.xyz = v2.xyz * r1.xyz + r0.xyz;
  o0.xyz = g_SelectionOverlayCol.xyz + r0.xyz;
  o0.w = NGReflectionAmount_7;
  o1.w = 0;
  o2.xyzw = float4(0,0,0,0.400000006);
  r0.xy = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r0.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r0.zw = v7.xy / v7.zz;
  r0.xy = r0.xy + -r0.zw;
  o3.xy = saturate(r0.xy * float2(4,4) + float2(0.497999996,0.497999996));

  o0.w = saturate(o0.w);
  o1.w = saturate(o1.w);
  o2.w = saturate(o2.w);

  // o0 = saturate(o0);
  o0 = max(0, o0);
  return;
}