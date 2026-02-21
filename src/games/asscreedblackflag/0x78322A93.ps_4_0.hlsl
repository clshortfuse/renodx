// ---- Created with 3Dmigoto v1.4.1 on Mon Dec  1 16:43:25 2025

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
  float3x3 Operator374_1_matrix : packoffset(c128);
  float3x3 Operator485_2_matrix : packoffset(c131);
  float3x3 Operator328_3_matrix : packoffset(c134);
  float3x3 Operator329_4_matrix : packoffset(c137);
  float Alpha_5 : packoffset(c140);
}

SamplerState WaveTexture_0_s : register(s0);
SamplerState g_ReflectionSampler_s : register(s7);
SamplerState DepthSurface_s : register(s8);
Texture2D<float4> WaveTexture_0 : register(t0);
Texture2D<float4> g_ReflectionSampler : register(t7);
Texture2D<float4> DepthSurface : register(t8);


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
  float3 v9 : TEXCOORD6,
  uint v10 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float2 o3 : SV_Target3)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r1.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r0.xy, 0).xyzw;
  r0.z = g_ReverseProjectionParams.z + r1.x;
  r0.z = g_ReverseProjectionParams.w / r0.z;
  r0.z = -v1.w + -r0.z;
  r0.z = saturate(0.5 * r0.z);
  r0.z = 1 + -r0.z;
  r0.z = r0.z * r0.z;
  r1.xy = v5.yx;
  r1.z = 1;
  r2.x = dot(r1.yxz, Operator374_1_matrix._m00_m10_m20);
  r2.y = dot(r1.yxz, Operator374_1_matrix._m01_m11_m21);
  r2.xyzw = WaveTexture_0.Sample(WaveTexture_0_s, r2.xy).xyzw;
  r0.w = r2.x * r2.x;
  r0.w = v4.y * r0.w;
  r1.w = r0.w * 8 + r0.z;
  r0.w = 8 * r0.w;
  r2.x = dot(r1.yxz, Operator328_3_matrix._m00_m10_m20);
  r2.y = dot(r1.yxz, Operator328_3_matrix._m01_m11_m21);
  r2.xyzw = WaveTexture_0.Sample(WaveTexture_0_s, r2.xy).xyzw;
  r2.yz = float2(-0.5,-0.5) + r2.xy;
  r2.yz = r2.yz + r2.yz;
  r3.x = dot(r1.yxz, Operator485_2_matrix._m00_m10_m20);
  r3.y = dot(r1.yxz, Operator485_2_matrix._m01_m11_m21);
  r3.xy = r2.yz * v4.zz + r3.xy;
  r3.xyzw = WaveTexture_0.Sample(WaveTexture_0_s, r3.xy).xyzw;
  r0.z = r3.w * r1.w + -r0.z;
  r0.z = 1.10000002 + r0.z;
  r0.z = v3.w * r0.z;
  r2.w = r0.z * Alpha_5 + -g_AlphaTestValue;
  r0.z = Alpha_5 * r0.z;
  r2.w = cmp(r2.w < 0);
  if (r2.w != 0) discard;
  r3.x = dot(r1.xyz, Operator329_4_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, Operator329_4_matrix._m01_m11_m21);
  r1.xy = r2.yz * v4.zz + r3.xy;
  r4.xyzw = WaveTexture_0.Sample(WaveTexture_0_s, r1.xy).xyzw;
  r1.xy = float2(-0.5,-0.5) + r4.xy;
  r1.xy = r1.xy * r2.xx;
  r1.xy = r1.xy * float2(2,2) + r2.yz;
  r1.xy = r1.xy * r0.ww;
  r0.w = dot(v7.xyz, v7.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v7.xyz * r0.www;
  r2.xyz = r2.xyz * r1.yyy;
  r0.w = dot(v6.xyz, v6.xyz);
  r0.w = rsqrt(r0.w);
  r3.xyz = v6.xyz * r0.www;
  r1.xyz = r1.xxx * r3.xyz + r2.xyz;
  r0.w = dot(v8.xyz, v8.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v8.xyz * r0.www;
  r1.xyz = r2.xyz * float3(4,4,4) + r1.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r2.xyz = v5.xyz;
  r2.w = 0;
  r2.xyzw = g_EyePosition.xyzw + -r2.xyzw;
  r0.w = dot(r2.xyzw, r2.xyzw);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r0.w = dot(r1.xyz, r2.xyz);
  o1.xyz = saturate(r1.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));
  r0.w = 1 + -r0.w;
  r0.w = r0.w * r0.w + 0.100000001;
  r0.w = min(1, r0.w);
  r1.x = 1 + -r0.w;
  r2.xyz = r3.www * r1.www + v3.xyz;
  r1.y = -r3.w * r1.w + 1;
  r0.w = r1.y * r0.w;
  o0.xyz = r2.xyz * r1.xxx + g_SelectionOverlayCol.xyz;
  o0.w = r0.z;
  o1.w = r0.z;
  o2.w = r0.z;
  r1.xy = v5.xy * float2(0.300000012,0.300000012) + r0.xy;
  r0.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r1.xyzw = g_ReflectionSampler.Sample(g_ReflectionSampler_s, r1.xy).xyzw;
  o2.xyz = r1.xyz * r0.www;
  r0.zw = v9.xy / v9.zz;
  r0.xy = r0.xy + -r0.zw;
  o3.xy = saturate(r0.xy * float2(4,4) + float2(0.497999996,0.497999996));

  o0 = max(0, o0);
  o0.w = saturate(o0.w);
  o1.w = saturate(o1.w);
  o2.w = saturate(o2.w);
  return;
}