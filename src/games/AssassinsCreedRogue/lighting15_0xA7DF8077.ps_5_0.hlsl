// ---- Created with 3Dmigoto v1.3.16 on Tue Jun 16 22:40:04 2026

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
  float HairBiasShift_1 : packoffset(c128);
  float4 HairSecondarySpecularColor_2 : packoffset(c129);
  float HairPrimarySpecPower_3 : packoffset(c130);
  float HairSecondarySpecPower_4 : packoffset(c131);
  float4 HairPrimarySpecularColor_5 : packoffset(c132);
  float HairPrimaryBias_6 : packoffset(c133);
  float4 HairColor_7 : packoffset(c134);
  float3x3 HairAnisoUV_8_matrix : packoffset(c135);
  float HairSecondaryBias_9 : packoffset(c138);
  float3x3 HairDiffuseUV_10_matrix : packoffset(c139);
  float4 HairColor2_11 : packoffset(c142);
  bool g_HasSunOther : packoffset(c202);
}

cbuffer ShadowConstscb : register(b1)
{

  struct
  {
    float4 m_CloudUVScaleOffset;
    float4 m_CloudShadowsParams;
    float4 m_ShadowMapSize;
    float4 m_OffsetsY;
    float4 m_OffsetsX;
    float4 m_ScalesY;
    float4 m_ScalesX;
    float4 m_OffsetsZ;
    float4 m_ScalesZ;
    float4 m_OffsetsW;
    float4 m_ScalesW;
    float4 m_NoiseScale;
    float4 m_NearFar;
    float4 m_FadeParams;
    float4 m_CascadesRangesMax;
    float4 m_ShadowContrast;
    float4x4 m_WorldToLightProj;
  } g_Shadows : packoffset(c0);

}

SamplerState Layer0Diffuse_0_s : register(s0);
SamplerState Operator169_1_s : register(s1);
SamplerState Layer0Normal_2_s : register(s2);
SamplerState HairAlpha_3_s : register(s3);
SamplerState g_AmbientCubeTexture_s : register(s13);
SamplerComparisonState g_ShadowSampler_s : register(s15);
Texture2D<float4> Layer0Diffuse_0 : register(t0);
Texture2D<float4> Operator169_1 : register(t1);
Texture2D<float4> Layer0Normal_2 : register(t2);
Texture2D<float4> HairAlpha_3 : register(t3);
TextureCube<float4> g_AmbientCubeTexture : register(t13);
Texture2D<float4> g_ShadowTexture : register(t15);


// 3Dmigoto declarations
#define cmp -

#ifndef MANUAL_SRGB_RT_ENCODE
#define MANUAL_SRGB_RT_ENCODE 0
#endif

float3 LinearToSRGB(float3 c)
{
  float3 lo = c * 12.92;
  float3 hi = 1.055 * pow(max(c, 0.0), 1.0 / 2.4) - 0.055;
  return lerp(lo, hi, step(0.0031308, c));
}

float3 EncodeSRGBOutput(float3 c)
{
#if MANUAL_SRGB_RT_ENCODE
  c = LinearToSRGB(max(c, 0.0));
#endif
  return c;
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
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
  r1.w = -g_FogParams.x + r0.w;
  r0.w = -20 + r0.w;
  r0.w = saturate(0.0700000003 * r0.w);
  r0.w = 1 + -r0.w;
  r0.w = -r0.w * r0.w + 1;
  r0.w = g_FogWeatherParams.x * r0.w;
  r0.y = saturate(r1.w / r0.y);
  r0.y = 1 + -r0.y;
  r0.y = r0.y * r0.y;
  r0.y = -r0.y * r0.y + 1;
  r0.x = saturate(r0.y * r0.x + r0.w);
  r0.y = 1 + -r0.x;
  r0.w = HairAlpha_3.Sample(HairAlpha_3_s, v3.xy).x;
  r2.xy = v2.xy;
  r2.z = 1;
  r3.x = dot(r2.xyz, HairDiffuseUV_10_matrix._m00_m10_m20);
  r3.y = dot(r2.xyz, HairDiffuseUV_10_matrix._m01_m11_m21);
  r3.xyz = Layer0Diffuse_0.Sample(Layer0Diffuse_0_s, r3.xy).xyz;
  r0.w = r3.y * r0.w;
  r1.w = r0.w * r0.y + -g_AlphaTestValue;
  r0.y = r0.w * r0.y;
  r0.w = cmp(r1.w < 0);
  if (r0.w != 0) discard;
  r4.xyz = v4.xyz;
  r4.w = 1;
  r5.y = dot(r4.xyzw, g_Shadows.m_WorldToLightProj._m00_m10_m20_m30);
  r5.z = dot(r4.xyzw, g_Shadows.m_WorldToLightProj._m01_m11_m21_m31);
  r5.w = dot(r4.xyzw, g_Shadows.m_WorldToLightProj._m02_m12_m22_m32);
  r4.xyz = r5.yzw * g_Shadows.m_ScalesY.xyz + g_Shadows.m_OffsetsY.xyz;
  r3.yw = cmp(abs(r4.xy) < g_Shadows.m_CascadesRangesMax.yy);
  r0.w = r3.w ? r3.y : 0;
  r1.w = r0.w ? g_Shadows.m_OffsetsY.w : g_Shadows.m_OffsetsX.w;
  r6.xyz = r5.yzw * g_Shadows.m_ScalesZ.xyz + g_Shadows.m_OffsetsZ.xyz;
  r3.yw = cmp(abs(r6.xy) < g_Shadows.m_CascadesRangesMax.zz);
  r2.w = r3.w ? r3.y : 0;
  r1.w = r2.w ? g_Shadows.m_OffsetsZ.w : r1.w;
  r7.xyz = r5.yzw * g_Shadows.m_ScalesW.xyz + g_Shadows.m_OffsetsW.xyz;
  r5.xyz = r5.yzw * g_Shadows.m_ScalesX.xyz + g_Shadows.m_OffsetsX.xyz;
  r4.xyz = r0.www ? r4.xyz : r5.xyz;
  r4.xyz = r2.www ? r6.xyz : r4.xyz;
  r3.yw = cmp(abs(r7.xy) < g_Shadows.m_CascadesRangesMax.ww);
  r0.w = r3.w ? r3.y : 0;
  r1.w = r0.w ? g_Shadows.m_OffsetsW.w : r1.w;
  r4.xyz = r0.www ? r7.xyz : r4.xyz;
  r4.yzw = float3(0.5,0.5,0.5) + r4.xyz;
  r4.x = r4.y * g_Shadows.m_ScalesX.w + r1.w;
  r3.yw = r4.zx / g_Shadows.m_ShadowMapSize.yx;
  r3.yw = float2(-2.5,-2.5) + r3.yw;
  r4.xy = floor(r3.wy);
  r3.yw = -r4.yx + r3.yw;
  r4.xy = g_Shadows.m_ShadowMapSize.xy * r4.xy;
  r0.w = r3.w + r3.y;
  r0.w = saturate(-1.53553391 + r0.w);
  r0.w = r0.w * r0.w;
  r0.w = -r0.w * 0.5 + 1;
  r5.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(3,1)).xyzw;
  r6.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(1,1)).xyzw;
  r7.xyz = float3(0.535533905,1.53553391,2.53553391) + -r3.yyw;
  r1.w = saturate(r7.z + -r3.y);
  r8.xyzw = float4(0.535533905,1.53553391,1,1) + -r3.wwyw;
  r9.xy = saturate(r8.xy + -r3.yy);
  r2.w = 1 + -r9.y;
  r2.w = min(r2.w, r1.w);
  r4.z = -r2.w * 0.5 + r1.w;
  r2.w = r4.z * r2.w;
  r1.w = r1.w * r9.y + r2.w;
  r9.yz = min(r9.yy, r8.zw);
  r2.w = r9.x * r9.x;
  r2.w = r2.w * r6.w;
  r9.xw = saturate(r8.xy);
  r10.xy = float2(1,1) + -r9.xw;
  r4.z = min(r10.x, r9.y);
  r6.w = -r4.z * 0.5 + r9.y;
  r4.z = r6.w * r4.z;
  r4.z = r9.y * r9.x + r4.z;
  r4.z = r6.z * r4.z;
  r2.w = r2.w * 0.5 + r4.z;
  r7.xy = saturate(r7.xy);
  r4.z = saturate(-r8.z + r7.z);
  r6.zw = float2(1,1) + -r7.xy;
  r7.z = min(r9.z, r6.z);
  r7.w = -r7.z * 0.5 + r9.z;
  r7.z = r7.w * r7.z;
  r7.z = r9.z * r7.x + r7.z;
  r2.w = r6.x * r7.z + r2.w;
  r1.w = r6.y * r1.w + r2.w;
  r2.w = min(r10.y, r8.z);
  r6.x = -r2.w * 0.5 + r8.z;
  r2.w = r6.x * r2.w;
  r2.w = r8.z * r9.w + r2.w;
  r1.w = r5.w * r2.w + r1.w;
  r6.xy = saturate(float2(0.535533905,0.535533905) + r3.wy);
  r7.zw = float2(1,1) + -r6.xy;
  r9.yz = min(r8.zw, r7.zw);
  r10.zw = -r9.yz * float2(0.5,0.5) + r8.zw;
  r9.yz = r10.zw * r9.yz;
  r9.yz = r8.zw * r6.xy + r9.yz;
  r1.w = r5.z * r9.y + r1.w;
  r1.w = r5.x * r0.w + r1.w;
  r5.xz = r8.wz + r3.yw;
  r5.xz = saturate(float2(-1.53553391,-1.53553391) + r5.xz);
  r5.xz = r5.xz * r5.xz;
  r5.xz = -r5.xz * float2(0.5,0.5) + float2(1,1);
  r1.w = r5.y * r5.x + r1.w;
  r11.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(5,1)).xyzw;
  r12.xyzw = float4(0.535533905,1.53553391,1,2.53553391) + -r8.wwww;
  r13.xyz = saturate(r12.xyw + -r3.yyy);
  r2.w = min(r13.y, r8.z);
  r3.y = saturate(r12.x);
  r3.w = 1 + -r3.y;
  r5.y = min(r3.w, r2.w);
  r5.w = -r5.y * 0.5 + r2.w;
  r5.y = r5.w * r5.y;
  r2.w = r2.w * r3.y + r5.y;
  r1.w = r11.w * r2.w + r1.w;
  r5.yw = r13.xz * r13.xy;
  r2.w = r5.y * r11.z;
  r1.w = r2.w * 0.5 + r1.w;
  r2.w = 1 + -r13.y;
  r2.w = min(r13.z, r2.w);
  r5.y = -r2.w * 0.5 + r13.z;
  r2.w = r5.y * r2.w + r5.w;
  r1.w = r11.x * r2.w + r1.w;
  r2.w = min(r13.y, r12.z);
  r5.y = min(r2.w, r6.z);
  r5.w = -r5.y * 0.5 + r2.w;
  r5.y = r5.w * r5.y;
  r2.w = r2.w * r7.x + r5.y;
  r1.w = r11.y * r2.w + r1.w;
  r11.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(1,3)).xyzw;
  r2.w = min(r8.w, r6.w);
  r5.y = min(r12.z, r6.w);
  r5.w = -r2.w * 0.5 + r8.w;
  r2.w = r5.w * r2.w;
  r2.w = r8.w * r7.y + r2.w;
  r1.w = r11.w * r2.w + r1.w;
  r0.w = r11.z * r0.w + r1.w;
  r0.w = r11.x * r9.z + r0.w;
  r0.w = r11.y * r5.z + r0.w;
  r11.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(3,3)).xyzw;
  r0.w = r11.w + r0.w;
  r0.w = r0.w + r11.z;
  r0.w = r0.w + r11.x;
  r0.w = r0.w + r11.y;
  r11.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(5,3)).xyzw;
  r0.w = r11.w * r5.x + r0.w;
  r1.w = -r5.y * 0.5 + r12.z;
  r1.w = r1.w * r5.y;
  r1.w = r12.z * r7.y + r1.w;
  r0.w = r11.z * r1.w + r0.w;
  r1.w = r8.z + r8.w;
  r1.w = saturate(-1.53553391 + r1.w);
  r1.w = r1.w * r1.w;
  r1.w = -r1.w * 0.5 + 1;
  r0.w = r11.x * r1.w + r0.w;
  r2.w = min(r12.z, r7.w);
  r5.x = -r2.w * 0.5 + r12.z;
  r2.w = r5.x * r2.w;
  r2.w = r12.z * r6.y + r2.w;
  r0.w = r11.y * r2.w + r0.w;
  r11.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(1,5)).xyzw;
  r5.xy = saturate(r8.xy + -r8.zz);
  r2.w = min(r8.w, r5.y);
  r6.yz = float2(0.535533905,1) + -r8.zz;
  r7.xyw = saturate(r12.xyw + -r8.zzz);
  r5.w = min(r12.z, r7.y);
  r6.y = saturate(r6.y);
  r6.w = 1 + -r6.y;
  r8.x = min(r6.w, r2.w);
  r6.w = min(r6.w, r5.w);
  r8.y = -r8.x * 0.5 + r2.w;
  r8.x = r8.y * r8.x;
  r2.w = r2.w * r6.y + r8.x;
  r0.w = r11.w * r2.w + r0.w;
  r2.w = 1 + -r5.y;
  r2.w = min(r4.z, r2.w);
  r8.x = -r2.w * 0.5 + r4.z;
  r2.w = r8.x * r2.w;
  r2.w = r4.z * r5.y + r2.w;
  r0.w = r11.z * r2.w + r0.w;
  r2.w = r5.x * r5.x;
  r4.z = min(r6.z, r5.y);
  r2.w = r2.w * r11.x;
  r0.w = r2.w * 0.5 + r0.w;
  r2.w = min(r4.z, r10.x);
  r5.x = min(r6.z, r10.y);
  r5.y = -r2.w * 0.5 + r4.z;
  r2.w = r5.y * r2.w;
  r2.w = r4.z * r9.x + r2.w;
  r0.w = r11.y * r2.w + r0.w;
  r8.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(3,5)).xyzw;
  r4.xyzw = g_ShadowTexture.GatherCmp(g_ShadowSampler_s, r4.xy, r4.w, int2(5,5)).xyzw;
  r0.w = r8.w * r5.z + r0.w;
  r0.w = r8.z * r1.w + r0.w;
  r1.w = -r5.x * 0.5 + r6.z;
  r1.w = r1.w * r5.x;
  r1.w = r6.z * r9.w + r1.w;
  r0.w = r8.x * r1.w + r0.w;
  r1.w = min(r6.z, r7.z);
  r2.w = -r1.w * 0.5 + r6.z;
  r1.w = r2.w * r1.w;
  r1.w = r6.z * r6.x + r1.w;
  r2.w = min(r7.y, r6.z);
  r0.w = r8.y * r1.w + r0.w;
  r1.w = 1 + -r7.y;
  r1.w = min(r7.w, r1.w);
  r5.x = -r1.w * 0.5 + r7.w;
  r5.yz = r7.xw * r7.xy;
  r1.w = r5.x * r1.w + r5.z;
  r4.y = r5.y * r4.y;
  r0.w = r4.w * r1.w + r0.w;
  r1.w = -r6.w * 0.5 + r5.w;
  r1.w = r1.w * r6.w;
  r1.w = r5.w * r6.y + r1.w;
  r0.w = r4.z * r1.w + r0.w;
  r1.w = min(r2.w, r3.w);
  r3.w = -r1.w * 0.5 + r2.w;
  r1.w = r3.w * r1.w;
  r1.w = r2.w * r3.y + r1.w;
  r0.w = r4.x * r1.w + r0.w;
  r0.w = r4.y * 0.5 + r0.w;
  r0.w = g_Shadows.m_ShadowContrast.x * r0.w;
  r1.w = -1 + g_Shadows.m_ShadowContrast.x;
  r1.w = 0.5 * r1.w;
  r0.w = saturate(r0.w * 0.0482842699 + -r1.w);
  r4.xyz = -g_EyePosition.xyz + v4.xyz;
  r1.w = dot(r4.xyz, r4.xyz);
  r1.w = saturate(r1.w * g_Shadows.m_FadeParams.x + g_Shadows.m_FadeParams.y);
  r0.w = r1.w + r0.w;
  r0.w = min(1, r0.w);
  r4.x = dot(r2.xyz, HairAnisoUV_8_matrix._m00_m10_m20);
  r4.y = dot(r2.xyz, HairAnisoUV_8_matrix._m01_m11_m21);
  r2.xy = Operator169_1.Sample(Operator169_1_s, r4.xy).xy;
  r1.w = HairSecondaryBias_9 + r2.y;
  r2.x = HairPrimaryBias_6 + r2.x;
  r2.y = HairBiasShift_1 + -0.5;
  r1.w = r2.y + r1.w;
  r2.x = r2.x + r2.y;
  r2.yzw = Layer0Normal_2.Sample(Layer0Normal_2_s, v2.xy).xyz;
  r2.yzw = float3(-0.5,-0.5,-0.5) + r2.yzw;
  r2.yzw = r2.yzw + r2.yzw;
  r4.xyz = v6.xyz * r2.zzz;
  r4.xyz = r2.yyy * v5.xyz + r4.xyz;
  r2.yzw = r2.www * v7.xyz + r4.xyz;
  r3.y = dot(r2.yzw, r2.yzw);
  r3.y = rsqrt(r3.y);
  r2.yzw = r3.yyy * r2.yzw;
  r4.xyz = -g_NormalScale.xxx * r2.yzw;
  r2.yzw = v8.xxx ? r4.xyz : r2.yzw;
  r4.xyz = r1.www * r2.yzw + v6.xyz;
  r1.w = dot(r4.xyz, r4.xyz);
  r1.w = rsqrt(r1.w);
  r4.xyz = r4.xyz * r1.www;
  r5.xyz = r1.xyz * r0.zzz + g_ShadowedDirect.m_Direction.xyz;
  r1.xyz = r1.xyz * r0.zzz;
  r0.z = dot(g_SunDirection.xyz, r1.xyz);
  r0.z = 1 + r0.z;
  r0.z = -r0.z * 0.5 + 1;
  r0.z = r0.z * r0.z;
  r1.x = dot(r5.xyz, r5.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = r5.xyz * r1.xxx;
  r1.w = dot(r4.xyz, r1.xyz);
  r1.w = -r1.w * r1.w + 1;
  r1.w = sqrt(r1.w);
  r1.w = log2(max(r1.w, 0.000001));
  r1.w = HairSecondarySpecPower_4 * r1.w;
  r1.w = exp2(r1.w);
  r3.y = dot(r2.yzw, g_ShadowedDirect.m_Direction.xyz);
  r3.w = 0.200000003 + r3.y;
  r3.y = saturate(r3.y);
  r4.xyz = g_ShadowedDirect.m_Color.xyz * r3.yyy;
  r4.xyz = r4.xyz * r0.www;
  r3.y = saturate(5 * r3.w);
  r3.w = r3.y * -2 + 3;
  r3.y = r3.y * r3.y;
  r3.y = r3.w * r3.y;
  r1.w = r3.y * r1.w;
  r5.xyz = HairSecondarySpecularColor_2.xyz * v3.www;
  r5.xyz = r5.xyz * r1.www;
  r6.xyz = r2.xxx * r2.yzw + v6.xyz;
  r1.w = dot(r6.xyz, r6.xyz);
  r1.w = rsqrt(r1.w);
  r6.xyz = r6.xyz * r1.www;
  r1.x = dot(r6.xyz, r1.xyz);
  r1.x = -r1.x * r1.x + 1;
  r1.x = sqrt(r1.x);
  r1.x = log2(max(r1.x, 0.000001));
  r1.x = HairPrimarySpecPower_3 * r1.x;
  r1.x = exp2(r1.x);
  r1.x = r3.y * r1.x;
  r1.yzw = HairPrimarySpecularColor_5.xyz * v3.www;
  r1.xyz = r1.yzw * r1.xxx + r5.xyz;
  r1.xyz = g_ShadowedDirect.m_Color.xyz * r1.xyz;
  r1.xyz = r1.xyz * r0.www;
  r3.yzw = HairColor2_11.xyz * r3.zzz;
  r3.xyz = HairColor_7.xyz * r3.xxx + r3.yzw;
  r5.xyz = g_EagleVisionColor.www * r3.xyz;
  r5.xyz = r5.xyz * r5.xyz;
  r1.xyz = r5.xyz * r4.xyz + r1.xyz;
  r4.x = dot(r2.yzw, float3(-0.408248007,-0.707107008,0.577350318));
  r4.y = dot(r2.ywz, float3(-0.408248007,0.577350318,0.707107008));
  r4.z = dot(r2.yw, float2(0.816497028,0.577350318));
  r4.w = r2.w;
  r2.xyz = g_AmbientCubeTexture.SampleLevel(g_AmbientCubeTexture_s, r2.yzw, 0).xyz;
  r4.xyzw = r4.xyzw * float4(1,1,1,-0.5) + float4(0,0,0,0.5);
  r6.xyz = saturate(r4.xyz);
  r4.xyz = r6.xyz * r4.xyz;
  r6.x = dot(r4.xyzw, g_LightingIrradianceCoeffsR.xyzw);
  r6.y = dot(r4.xyzw, g_LightingIrradianceCoeffsG.xyzw);
  r6.z = dot(r4.xyzw, g_LightingIrradianceCoeffsB.xyzw);
  r2.xyz = r6.xyz + r2.xyz;
  r1.xyz = r2.xyz * r5.xyz + r1.xyz;
  r0.w = max(r3.x, r3.y);
  r0.w = max(r0.w, r3.z);
  r0.w = 1.70000005 * r0.w;
  r2.xyz = g_EagleVisionColor.xyz * r0.www;
  r1.xyz = r2.xyz * r2.xyz + r1.xyz;

  r1.xyz = sqrt(max(r1.xyz, 0.0));
  float hair_max = max(max(r1.x, r1.y), r1.z);
  r1.xyz = hair_max > 1.0 ? r1.xyz / hair_max : r1.xyz;

  r2.xyz = -g_FogSunBackColor.xyz + g_FogColor.xyz;
  r2.xyz = r0.zzz * r2.xyz + g_FogSunBackColor.xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r0.xzw = r0.xxx * r2.xyz + r1.xyz;
  o0.xyz = g_SelectionOverlayCol.xyz + r0.xzw;
  o0.xyz = EncodeSRGBOutput(o0.xyz);
  o0.w = r0.y;
  o1.w = r0.y;
  o1.xyz = v1.zzz / v1.www;
  return;
}