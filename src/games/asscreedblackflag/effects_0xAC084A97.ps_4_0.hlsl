// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 14:58:11 2025

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
  float3x3 UVFireB_1_matrix : packoffset(c128);
  float AlphaPower_2 : packoffset(c131);
  float3x3 UVFireA_3_matrix : packoffset(c132);
  float3x3 UVAlpha_4_matrix : packoffset(c135);
  float3x3 UVDisto_5_matrix : packoffset(c138);
  float DistoMultiplier_6 : packoffset(c141);
  float4 ColorB_7 : packoffset(c142);
  float4 ColorA_8 : packoffset(c143);
  float VertexAlphaMul_9 : packoffset(c144);
  float DistoOnlyV_10 : packoffset(c145);
  float UseDepth_11 : packoffset(c146);
  bool g_HasSunOther : packoffset(c147);
}

SamplerState TexFire_0_s : register(s0);
SamplerState TexAlpha_1_s : register(s1);
SamplerState TexDisto_2_s : register(s2);
SamplerState DepthSurface_s : register(s8);
SamplerState g_AmbientCubeTexture_s : register(s13);
Texture2D<float4> TexFire_0 : register(t0);
Texture2D<float4> TexAlpha_1 : register(t1);
Texture2D<float4> TexDisto_2 : register(t2);
Texture2D<float4> DepthSurface : register(t8);
TextureCube<float4> g_AmbientCubeTexture : register(t13);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  float4 v4 : COLOR1,
  float4 v5 : TEXCOORD2,
  float4 v6 : TEXCOORD3,
  float4 v7 : TEXCOORD4,
  float4 v8 : TEXCOORD5,
  uint v9 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v5.w < 0);
  if (r0.x != 0) discard;
  r0.xy = v2.zw;
  r0.z = 1;
  r1.x = dot(r0.xyz, UVDisto_5_matrix._m00_m10_m20);
  r1.y = dot(r0.xyz, UVDisto_5_matrix._m01_m11_m21);
  r0.xyzw = TexDisto_2.Sample(TexDisto_2_s, r1.xy).xyzw;
  r1.y = r0.y;
  r1.x = 0;
  r0.zw = r1.xy + -r0.xy;
  r0.xy = DistoOnlyV_10 * r0.zw + r0.xy;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r0.xy = r0.xy * DistoMultiplier_6 + v4.xy;
  r0.z = 1;
  r1.x = dot(r0.xyz, UVAlpha_4_matrix._m00_m10_m20);
  r1.y = dot(r0.xyz, UVAlpha_4_matrix._m01_m11_m21);
  r0.xyzw = TexAlpha_1.Sample(TexAlpha_1_s, r1.xy).xyzw;
  r0.x = log2(abs(r0.y));
  r0.x = AlphaPower_2 * r0.x;
  r0.x = exp2(r0.x);
  r0.z = VertexAlphaMul_9 * v3.w;
  r0.x = r0.z * r0.x;
  r0.zw = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r1.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r0.zw, 0).xyzw;
  r0.z = g_ReverseProjectionParams.z + r1.x;
  r0.z = g_ReverseProjectionParams.w / r0.z;
  r0.z = saturate(-v1.w + -r0.z);
  r0.z = r0.z * r0.x + -r0.x;
  r0.x = UseDepth_11 * r0.z + r0.x;
  r0.z = -g_AlphaTestValue + r0.x;
  r0.z = cmp(r0.z < 0);
  if (r0.z != 0) discard;
  r1.xy = v2.xy;
  r1.z = 1;
  r2.x = dot(r1.xyz, UVFireA_3_matrix._m00_m10_m20);
  r2.y = dot(r1.xyz, UVFireA_3_matrix._m01_m11_m21);
  r2.xyzw = TexFire_0.Sample(TexFire_0_s, r2.xy).xyzw;
  r3.x = dot(r1.xyz, UVFireB_1_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, UVFireB_1_matrix._m01_m11_m21);
  r1.xyzw = TexFire_0.Sample(TexFire_0_s, r3.xy).xyzw;
  r0.z = r2.y * r1.y;
  r0.y = r0.y * r0.z;
  r1.xyz = -ColorA_8.xyz + ColorB_7.xyz;
  r0.yzw = r0.yyy * r1.xyz + ColorA_8.xyz;
  r1.x = dot(v8.xyz, v8.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = v8.xyz * r1.xxx;
  r2.xyz = -g_NormalScale.xxx * r1.xyz;
  r1.xyz = v9.xxx ? r2.xyz : r1.xyz;
  r2.x = dot(r1.xyz, float3(-0.408248007,-0.707107008,0.577350318));
  r2.y = dot(r1.xzy, float3(-0.408248007,0.577350318,0.707107008));
  r2.z = dot(r1.xz, float2(0.816497028,0.577350318));
  r2.w = r1.z;
  r1.xyzw = g_AmbientCubeTexture.SampleLevel(g_AmbientCubeTexture_s, r1.xyz, 0).xyzw;
  r2.xyzw = r2.xyzw * float4(1,1,1,-0.5) + float4(0,0,0,0.5);
  r3.xyz = saturate(r2.xyz);
  r2.xyz = r3.xyz * r2.xyz;
  r3.x = dot(r2.xyzw, g_LightingIrradianceCoeffsR.xyzw);
  r3.y = dot(r2.xyzw, g_LightingIrradianceCoeffsG.xyzw);
  r3.z = dot(r2.xyzw, g_LightingIrradianceCoeffsB.xyzw);
  r1.xyz = r3.xyz + r1.xyz;
  r0.yzw = r1.xyz * r0.yzw + r0.yzw;
  o0.xyz = g_SelectionOverlayCol.xyz + r0.yzw;
  o0.w = r0.x;
  o1.w = r0.x;
  o1.xyz = v1.zzz / v1.www;

  o0.w = saturate(o0.w);
  o1.w = saturate(o1.w);
  return;
}