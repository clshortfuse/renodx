// ---- Created with 3Dmigoto v1.3.16 on Tue Jul 28 15:55:15 2026

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
  float AlphaMult_1 : packoffset(c128);
  bool g_HasSunOther : packoffset(c202);
}

SamplerState Layer0Diffuse_0_s : register(s0);
SamplerState Layer0Normal_1_s : register(s1);
SamplerState g_AmbientCubeTexture_s : register(s13);
Texture2D<float4> Layer0Diffuse_0 : register(t0);
Texture2D<float4> Layer0Normal_1 : register(t1);
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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_EyePosition.z + g_FogParams.z;
  r0.x = v4.z + -r0.x;
  r0.x = min(g_FogParams.z, r0.x);
  r0.x = saturate(-r0.x * g_FogParams.w + 1);
  r0.y = g_FogParams.y + -g_FogParams.x;
  r1.xyz = g_EyePosition.xyz + -v4.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.w = sqrt(r0.z);
  r0.z = rsqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r0.z = dot(g_SunDirection.xyz, r1.xyz);
  r0.z = 1 + r0.z;
  r0.z = -r0.z * 0.5 + 1;
  r1.x = -g_FogParams.x + r0.w;
  r0.w = -20 + r0.w;
  r0.w = saturate(0.0700000003 * r0.w);
  r0.w = 1 + -r0.w;
  r0.w = -r0.w * r0.w + 1;
  r0.w = g_FogWeatherParams.x * r0.w;
  r0.y = saturate(r1.x / r0.y);
  r0.y = 1 + -r0.y;
  r0.yz = r0.yz * r0.yz;
  r0.y = -r0.y * r0.y + 1;
  r0.x = saturate(r0.y * r0.x + r0.w);
  r0.y = 1 + -r0.x;
  r1.xyzw = Layer0Diffuse_0.Sample(Layer0Diffuse_0_s, v2.xy).xyzw;
  r1.xyzw = v3.xyzw * r1.xyzw;
  r0.w = AlphaMult_1 * r1.w;
  r1.xyz = r1.xyz * r1.xyz;
  r1.w = r0.w * r0.y + -g_AlphaTestValue;
  r0.y = r0.w * r0.y;
  r0.w = cmp(r1.w < 0);
  if (r0.w != 0) discard;
  r2.xyz = -g_FogSunBackColor.xyz + g_FogColor.xyz;
  r2.xyz = r0.zzz * r2.xyz + g_FogSunBackColor.xyz;
  r3.xyz = Layer0Normal_1.Sample(Layer0Normal_1_s, v2.xy).xyz;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r3.xyz;
  r3.xyz = r3.xyz + r3.xyz;
  r4.xyz = v6.xyz * r3.yyy;
  r3.xyw = r3.xxx * v5.xyz + r4.xyz;
  r3.xyz = r3.zzz * v7.xyz + r3.xyw;
  r0.z = dot(r3.xyz, r3.xyz);
  r0.z = rsqrt(r0.z);
  r3.xyz = r3.xyz * r0.zzz;
  r4.x = dot(r3.xyz, float3(-0.408248007,-0.707107008,0.577350318));
  r4.y = dot(r3.xzy, float3(-0.408248007,0.577350318,0.707107008));
  r4.z = dot(r3.xz, float2(0.816497028,0.577350318));
  r4.w = r3.z;
  r3.xyz = g_AmbientCubeTexture.SampleLevel(g_AmbientCubeTexture_s, r3.xyz, 0).xyz;
  r4.xyzw = r4.xyzw * float4(1,1,1,-0.5) + float4(0,0,0,0.5);
  r5.xyz = saturate(r4.xyz);
  r4.xyz = r5.xyz * r4.xyz;
  r5.x = dot(r4.xyzw, g_LightingIrradianceCoeffsR.xyzw);
  r5.y = dot(r4.xyzw, g_LightingIrradianceCoeffsG.xyzw);
  r5.z = dot(r4.xyzw, g_LightingIrradianceCoeffsB.xyzw);
  r3.xyz = r5.xyz + r3.xyz;
  r1.xyz = r3.xyz * r1.xyz + r1.xyz;
  r1.xyz = sqrt(r1.xyz);
  r1.xyz = min(float3(1,1,1), r1.xyz);
  r2.xyz = r2.xyz + -r1.xyz;
  r0.xzw = r0.xxx * r2.xyz + r1.xyz;
  o0.xyz = g_SelectionOverlayCol.xyz + r0.xzw;
  o0.w = r0.y;
  o1.w = r0.y;
  o1.xyz = v1.zzz / v1.www;
  return;
}