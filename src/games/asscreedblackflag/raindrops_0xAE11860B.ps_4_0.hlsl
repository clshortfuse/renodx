// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 19:54:39 2025

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
  float Opacity_1 : packoffset(c128);
  float Oscilator_2 : packoffset(c129);
  bool g_HasSunOther : packoffset(c130);
}

SamplerState Diffuse_0_s : register(s0);
SamplerState g_RefractionSampler_s : register(s12);
SamplerState g_AmbientCubeTexture_s : register(s13);
Texture2D<float4> Diffuse_0 : register(t0);
Texture2D<float4> g_RefractionSampler : register(t12);
TextureCube<float4> g_AmbientCubeTexture : register(t13);


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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v4.w < 0);
  if (r0.x != 0) discard;
  r0.x = dot(v7.xyz, v7.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v7.xyz * r0.xxx;
  r1.x = dot(r0.xyz, float3(-0.408248007,-0.707107008,0.577350318));
  r1.y = dot(r0.xyz, float3(-0.408248007,0.707107008,0.577350318));
  r1.z = dot(r0.zx, float2(0.577350318,0.816497028));
  r1.w = r0.z;
  r1.xyzw = r1.xyzw * float4(1,1,1,-0.5) + float4(0,0,0,0.5);
  r2.xyz = saturate(r1.xyz);
  r1.xyz = r2.xyz * r1.xyz;
  r2.x = dot(r1.xyzw, g_LightingIrradianceCoeffsR.xyzw);
  r2.y = dot(r1.xyzw, g_LightingIrradianceCoeffsG.xyzw);
  r2.z = dot(r1.xyzw, g_LightingIrradianceCoeffsB.xyzw);
  r1.xyzw = g_AmbientCubeTexture.SampleLevel(g_AmbientCubeTexture_s, r0.xyz, 0).xyzw;
  r1.xyz = r1.xyz + r2.xyz;
  r0.zw = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r2.xyzw = Diffuse_0.Sample(Diffuse_0_s, v2.xy).xyzw;
  r1.w = 0.0250000004 * r2.y;
  r2.x = g_WeatherInfo.z * r2.y;
  r0.xy = r0.xy * r1.ww + r0.zw;
  r0.xyzw = g_RefractionSampler.Sample(g_RefractionSampler_s, r0.xy).xyzw;
  r0.xyz = saturate(r1.xyz + r0.xyz);
  r1.xyz = g_EyePosition.xyz + -v4.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r0.w);
  r0.w = sqrt(r0.w);
  r1.xyz = r1.xyz * r1.www;
  r1.x = dot(g_SunDirection.xyz, r1.xyz);
  r1.x = 1 + r1.x;
  r1.x = -r1.x * 0.5 + 1;
  r1.x = r1.x * r1.x;
  r1.yzw = -g_FogSunBackColor.xyz + g_FogColor.xyz;
  r1.xyz = r1.xxx * r1.yzw + g_FogSunBackColor.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r1.w = -g_FogParams.x + r0.w;
  r0.w = -20 + r0.w;
  r0.w = saturate(0.0700000003 * r0.w);
  r0.w = 1 + -r0.w;
  r0.w = -r0.w * r0.w + 1;
  r0.w = g_FogWeatherParams.x * r0.w;
  r2.y = g_FogParams.y + -g_FogParams.x;
  r1.w = saturate(r1.w / r2.y);
  r1.w = 1 + -r1.w;
  r1.w = r1.w * r1.w;
  r1.w = -r1.w * r1.w + 1;
  r2.y = g_EyePosition.z + g_FogParams.z;
  r2.y = v4.z + -r2.y;
  r2.y = min(g_FogParams.z, r2.y);
  r2.y = saturate(-r2.y * g_FogParams.w + 1);
  r0.w = saturate(r1.w * r2.y + r0.w);
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.w = 1 + -r0.w;
  o0.xyz = g_SelectionOverlayCol.xyz + r0.xyz;
  r0.x = dot(g_EyeDirection.xyz, g_SunDirection.xyz);
  r0.x = r2.x * r0.x;
  r0.y = v3.z + -v3.y;
  r0.y = saturate(Opacity_1 * r0.y + v3.y);
  r0.z = Opacity_1 * -145 + 150;
  r1.x = 1 / r0.z;
  r1.x = 1 + -r1.x;
  r1.x = r1.x * r0.z;
  r0.y = r1.x * r0.y;
  r0.y = saturate(r0.z * Oscilator_2 + -r0.y);
  r0.x = r0.y * r0.x;
  r0.x = r0.x * r0.w;
  o0.w = r0.x;
  o1.w = r0.x;
  o1.xyz = v1.zzz / v1.www;

  o0.w = saturate(o0.w);
  o1.w = saturate(o1.w);
  return;
}