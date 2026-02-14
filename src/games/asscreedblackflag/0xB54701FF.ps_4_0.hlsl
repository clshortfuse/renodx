// ---- Created with 3Dmigoto v1.4.1 on Mon Dec  1 14:31:17 2025

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
  float LightshaftIntensity_1 : packoffset(c128);
  bool g_HasSunOther : packoffset(c129);
}

SamplerState GodrayTexture_0_s : register(s0);
SamplerState DepthSurface_s : register(s8);
SamplerState g_AmbientCubeTexture_s : register(s13);
Texture2D<float4> GodrayTexture_0 : register(t0);
Texture2D<float4> DepthSurface : register(t8);
TextureCube<float4> g_AmbientCubeTexture : register(t13);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : COLOR0,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float4 v7 : TEXCOORD5,
  float4 v8 : TEXCOORD6,
  uint v9 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v5.w < 0);
  if (r0.x != 0) discard;
  r0.x = dot(v8.xyz, v8.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v8.xyz * r0.xxx;
  r1.x = dot(r0.xyz, float3(-0.408248007,-0.707107008,0.577350318));
  r1.y = dot(r0.xzy, float3(-0.408248007,0.577350318,0.707107008));
  r1.z = dot(r0.xz, float2(0.816497028,0.577350318));
  r1.w = r0.z;
  r0.xyzw = g_AmbientCubeTexture.SampleLevel(g_AmbientCubeTexture_s, r0.xyz, 0).xyzw;
  r1.xyzw = r1.xyzw * float4(1,1,1,-0.5) + float4(0,0,0,0.5);
  r2.xyz = saturate(r1.xyz);
  r1.xyz = r2.xyz * r1.xyz;
  r2.x = dot(r1.xyzw, g_LightingIrradianceCoeffsR.xyzw);
  r2.y = dot(r1.xyzw, g_LightingIrradianceCoeffsG.xyzw);
  r2.z = dot(r1.xyzw, g_LightingIrradianceCoeffsB.xyzw);
  r0.xyz = r2.xyz + r0.xyz;
  r1.xyz = LightshaftIntensity_1 * g_LightShaftColor.xyz;
  r0.xyz = saturate(r0.xyz * r1.xyz + r1.xyz);
  r1.xyz = g_EyePosition.xyz + -v5.xyz;
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
  r2.x = g_FogParams.y + -g_FogParams.x;
  r1.w = saturate(r1.w / r2.x);
  r1.w = 1 + -r1.w;
  r1.w = r1.w * r1.w;
  r1.w = -r1.w * r1.w + 1;
  r2.x = g_EyePosition.z + g_FogParams.z;
  r2.x = v5.z + -r2.x;
  r2.x = min(g_FogParams.z, r2.x);
  r2.x = saturate(-r2.x * g_FogParams.w + 1);
  r2.y = -20 + r0.w;
  r2.zw = -g_LightShaftFade.xz + r0.ww;
  r0.w = saturate(0.0700000003 * r2.y);
  r0.w = 1 + -r0.w;
  r0.w = -r0.w * r0.w + 1;
  r0.w = g_FogWeatherParams.x * r0.w;
  r0.w = saturate(r1.w * r2.x + r0.w);
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.xyz = g_SelectionOverlayCol.xyz + r0.xyz;
  r0.xy = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r1.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r0.xy, 0).xyzw;
  r0.x = g_ReverseProjectionParams.z + r1.x;
  r0.x = g_ReverseProjectionParams.w / r0.x;
  r0.x = -v2.w + -r0.x;
  r0.x = saturate(g_LightShaftFade2.x * r0.x);
  r0.yz = g_LightShaftFade.yw + -g_LightShaftFade.xz;
  r0.yz = saturate(r2.zw / r0.yz);
  r0.x = r0.x * r0.y;
  r0.yw = float2(1,1) + -r0.zw;
  r0.x = r0.x * r0.y;
  r0.x = g_LightShaftColor.w * r0.x;
  r0.yz = float2(1,1) / g_LightShaftFade2.zw;
  r0.y = saturate(v3.y * r0.y);
  r0.x = r0.x * r0.y;
  r0.y = 1 + -v3.y;
  r0.y = saturate(r0.y * r0.z);
  r0.x = r0.x * r0.y;
  r1.xyzw = GodrayTexture_0.Sample(GodrayTexture_0_s, v3.zw).xyzw;
  r2.xyzw = GodrayTexture_0.Sample(GodrayTexture_0_s, v4.xy).xyzw;
  r0.y = r2.y * r1.y;
  r1.xyzw = GodrayTexture_0.Sample(GodrayTexture_0_s, v3.xy).xyzw;
  r0.y = r0.y * r1.z + r1.z;
  r0.x = r0.y * r0.x;
  r0.x = r0.x * r0.w;
  o0.w = r0.x;
  o1.w = r0.x;
  o1.xyz = v2.zzz / v2.www;

  o0.w = saturate(o0.w);
  o1.w = saturate(o1.w);
  return;
}