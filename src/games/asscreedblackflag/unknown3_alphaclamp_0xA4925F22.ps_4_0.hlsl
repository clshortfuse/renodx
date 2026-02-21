// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 23:53:28 2025

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
  float4 g_InvScreenSizeAndAspectRatio : packoffset(c128);
  float4 g_SourcePosition : packoffset(c129);
  float4 g_ColorAndIntensity : packoffset(c130);
  float4 g_MaskParams : packoffset(c131);
  float4 g_MaskParams2 : packoffset(c132);
}

SamplerState Texture_s : register(s0);
Texture2D<float4> Texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_SourcePosition.xyxy + -v1.xyxy;
  r1.x = dot(r0.zw, r0.zw);
  r1.x = sqrt(r1.x);
  r1.y = sqrt(r1.x);
  r1.y = min(r1.y, r1.x);
  r0.xyzw = r0.xyzw / r1.xxxx;
  r0.xyzw = r0.xyzw * r1.yyyy;
  r1.x = g_MaskParams.z * 0.015625;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xyzw = r0.zwzw * float4(0,0,1,1) + v1.xyxy;
  r2.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r2.xxxw + r2.xxxw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.96875,1.96875,1.96875,1.96875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.9375,1.9375,1.9375,1.9375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.90625,1.90625,1.90625,1.90625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.875,1.875,1.875,1.875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.84375,1.84375,1.84375,1.84375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.8125,1.8125,1.8125,1.8125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.78125,1.78125,1.78125,1.78125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.75,1.75,1.75,1.75) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.71875,1.71875,1.71875,1.71875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.6875,1.6875,1.6875,1.6875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.65625,1.65625,1.65625,1.65625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.625,1.625,1.625,1.625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.59375,1.59375,1.59375,1.59375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.5625,1.5625,1.5625,1.5625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.53125,1.53125,1.53125,1.53125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.5,1.5,1.5,1.5) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.46875,1.46875,1.46875,1.46875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.4375,1.4375,1.4375,1.4375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.40625,1.40625,1.40625,1.40625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.375,1.375,1.375,1.375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.34375,1.34375,1.34375,1.34375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.3125,1.3125,1.3125,1.3125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.28125,1.28125,1.28125,1.28125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.25,1.25,1.25,1.25) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.21875,1.21875,1.21875,1.21875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.1875,1.1875,1.1875,1.1875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.15625,1.15625,1.15625,1.15625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.125,1.125,1.125,1.125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.09375,1.09375,1.09375,1.09375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(1.0625,1.0625,1.0625,1.0625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(1.03125,1.03125,1.03125,1.03125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.96875,0.96875,0.96875,0.96875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.9375,0.9375,0.9375,0.9375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.90625,0.90625,0.90625,0.90625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.875,0.875,0.875,0.875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.84375,0.84375,0.84375,0.84375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.8125,0.8125,0.8125,0.8125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.78125,0.78125,0.78125,0.78125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.75,0.75,0.75,0.75) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.71875,0.71875,0.71875,0.71875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.6875,0.6875,0.6875,0.6875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.65625,0.65625,0.65625,0.65625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.625,0.625,0.625,0.625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.59375,0.59375,0.59375,0.59375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.5625,0.5625,0.5625,0.5625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.53125,0.53125,0.53125,0.53125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.5,0.5,0.5,0.5) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.46875,0.46875,0.46875,0.46875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.4375,0.4375,0.4375,0.4375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.40625,0.40625,0.40625,0.40625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.375,0.375,0.375,0.375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.34375,0.34375,0.34375,0.34375) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.3125,0.3125,0.3125,0.3125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.28125,0.28125,0.28125,0.28125) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.25,0.25,0.25,0.25) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.21875,0.21875,0.21875,0.21875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r2.xyzw = r3.xxxw * float4(0.1875,0.1875,0.1875,0.1875) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r0.xyzw = r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r2.xyzw = r3.xxxw * float4(0.15625,0.15625,0.15625,0.15625) + r2.xyzw;
  r3.xyzw = Texture.Sample(Texture_s, r1.xy).xyzw;
  r1.xyzw = Texture.Sample(Texture_s, r1.zw).xyzw;
  r2.xyzw = r3.xxxw * float4(0.125,0.125,0.125,0.125) + r2.xyzw;
  r1.xyzw = r1.xxxw * float4(0.09375,0.09375,0.09375,0.09375) + r2.xyzw;
  r2.xyzw = Texture.Sample(Texture_s, r0.xy).xyzw;
  r0.xyzw = Texture.Sample(Texture_s, r0.zw).xyzw;
  r1.xyzw = r2.xxxw * float4(0.0625,0.0625,0.0625,0.0625) + r1.xyzw;
  r0.xyzw = r0.xxxw * float4(0.03125,0.03125,0.03125,0.03125) + r1.xyzw;

  r0.xyzw = g_ColorAndIntensity.xyzw * r0.xyzw;
  //r0.xyzw = g_ColorAndIntensity.xyzw;

  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  o0.xyzw = min(float4(0.800000012,0.800000012,0.800000012,1), r0.xyzw);

  o0.w = saturate(o0.w);
  return;
}