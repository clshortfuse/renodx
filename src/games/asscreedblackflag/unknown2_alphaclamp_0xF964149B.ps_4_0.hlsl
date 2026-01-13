// ---- Created with 3Dmigoto v1.4.1 on Mon Nov 24 02:38:19 2025

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
  float3x3 UVLayer1_1_matrix : packoffset(c128);
  float FlashAlpha_2 : packoffset(c131);
  float3x3 UVLayer3_3_matrix : packoffset(c132);
  float4 Layer1Color_4 : packoffset(c135);
  float4 Layer2Color_5 : packoffset(c136);
  float3x3 UVLayer2_6_matrix : packoffset(c137);
  float Layer2Alpha_7 : packoffset(c140);
  float Layer3Alpha_8 : packoffset(c141);
  float4 Layer3Color_9 : packoffset(c142);
  float LineContrast_10 : packoffset(c143);
  float4 ReflectionColor_11 : packoffset(c144);
  float3x3 Main1UVLayer_12_matrix : packoffset(c145);
  float Main1Alpha_13 : packoffset(c148);
  float4 LayerMainTransitionColor_14 : packoffset(c149);
  float3x3 UVLayerMainTransitionMask_15_matrix : packoffset(c150);
  float3x3 FlashUVLayer_16_matrix : packoffset(c153);
  float Main2Alpha_17 : packoffset(c156);
  float Layer3Bias_18 : packoffset(c157);
  float Layer2Bias_19 : packoffset(c158);
  float3x3 Main2UVLayer_20_matrix : packoffset(c159);
  float3x3 DetailMapUV_21_matrix : packoffset(c162);
  float DetailMapDist_22 : packoffset(c165);
  float Main1DistortScale_23 : packoffset(c166);
  float Main2DistortScale_24 : packoffset(c167);
  float4 Main1Color_25 : packoffset(c168);
  float Layer2DistortScale_26 : packoffset(c169);
  float GlowMult_27 : packoffset(c170);
  float4 Main2Color_28 : packoffset(c171);
}

SamplerState Background_0_s : register(s0);
SamplerState ParticlesMask_1_s : register(s1);
SamplerState Main1_2_s : register(s2);
SamplerState Cubemap_0_s : register(s3);
SamplerState Flash_3_s : register(s4);
SamplerState Main2_4_s : register(s5);
SamplerState DetailMap_5_s : register(s6);
SamplerState DistortTexture_6_s : register(s7);
Texture2D<float4> Background_0 : register(t0);
Texture2D<float4> ParticlesMask_1 : register(t1);
Texture2D<float4> Main1_2 : register(t2);
TextureCube<float4> Cubemap_0 : register(t3);
Texture2D<float4> Flash_3 : register(t4);
Texture2D<float4> Main2_4 : register(t5);
Texture2D<float4> DetailMap_5 : register(t6);
Texture2D<float4> DistortTexture_6 : register(t7);


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
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1,-1,1,1) * v7.xyzw;
  r0.x = dot(r0.xyzw, r0.xyzw);
  r0.x = rsqrt(r0.x);
  r0.yz = float2(1,-1) * v7.xy;
  r0.xy = r0.yz * r0.xx;
  r1.xy = v1.xy;
  r1.z = 1;
  r2.x = dot(r1.xyz, UVLayer2_6_matrix._m00_m10_m20);
  r2.y = dot(r1.xyz, UVLayer2_6_matrix._m01_m11_m21);
  r3.xyzw = DistortTexture_6.Sample(DistortTexture_6_s, r2.xy).xyzw;
  r0.z = r3.x * Layer2DistortScale_26 + Layer2Bias_19;
  r0.zw = r0.zz * r0.xy + r2.xy;
  r2.xyzw = ParticlesMask_1.Sample(ParticlesMask_1_s, r0.zw).xyzw;
  r0.z = Layer2Alpha_7 * r2.x;
  r0.z = v2.x * r0.z;
  r2.xyzw = -Layer2Color_5.xyzw * r0.zzzz + float4(1,1,1,1);
  r2.xyzw = float4(1,1,1,1) / r2.xyzw;
  r3.x = dot(r1.xyz, UVLayer1_1_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, UVLayer1_1_matrix._m01_m11_m21);
  r3.xyzw = Background_0.Sample(Background_0_s, r3.xy).xyzw;
  r3.xyzw = Layer1Color_4.xyzw * r3.xyzw;
  r2.xyzw = r3.xyzw * r2.xyzw;
  r3.x = dot(r1.xyz, UVLayer3_3_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, UVLayer3_3_matrix._m01_m11_m21);
  r0.zw = Layer3Bias_18 * r0.xy + r3.xy;
  r3.xyzw = ParticlesMask_1.Sample(ParticlesMask_1_s, r0.zw).xyzw;
  r0.z = Layer3Alpha_8 * r3.y;
  r0.z = v2.y * r0.z;
  r3.xyzw = -Layer3Color_9.xyzw * r0.zzzz + float4(1,1,1,1);
  r3.xyzw = float4(1,1,1,1) / r3.xyzw;
  r2.xyzw = r3.xyzw * r2.xyzw;
  r0.z = Main1DistortScale_23 * -0.5;
  r3.x = dot(r1.xyz, Main1UVLayer_12_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, Main1UVLayer_12_matrix._m01_m11_m21);
  r4.xyzw = DistortTexture_6.Sample(DistortTexture_6_s, r3.xy).xyzw;
  r0.z = r4.x * Main1DistortScale_23 + r0.z;
  r0.zw = r0.zz * r0.xy + r3.xy;
  r3.xyzw = Main1_2.Sample(Main1_2_s, r0.zw).xyzw;
  r4.xyzw = Main1Color_25.xyzw * r3.xyzw + -r2.xyzw;
  r0.z = Main1Alpha_13 * r3.w;
  r2.xyzw = r0.zzzz * r4.xyzw + r2.xyzw;
  r0.z = Main2DistortScale_24 * -0.5;
  r3.x = dot(r1.xyz, Main2UVLayer_20_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, Main2UVLayer_20_matrix._m01_m11_m21);
  r4.xyzw = DistortTexture_6.Sample(DistortTexture_6_s, r3.xy).xyzw;
  r0.z = r4.x * Main2DistortScale_24 + r0.z;
  r0.xy = r0.zz * r0.xy + r3.xy;
  r0.xyzw = Main2_4.Sample(Main2_4_s, r0.xy).xyzw;
  r3.xyzw = Main2Color_28.xyzw * r0.xyzw + -r2.xyzw;
  r0.x = Main2Alpha_17 * r0.w;
  r0.xyzw = r0.xxxx * r3.xyzw + r2.xyzw;
  r2.w = 0;
  r3.x = dot(r1.xyz, FlashUVLayer_16_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, FlashUVLayer_16_matrix._m01_m11_m21);
  r3.xyzw = Flash_3.Sample(Flash_3_s, r3.xy).xyzw;
  r2.xy = r3.xz;
  r1.w = FlashAlpha_2 * r3.y;
  r2.xyzw = r2.xyyw + -r0.xyzw;
  r0.xyzw = r1.wwww * r2.xyzw + r0.xyzw;
  r2.xyz = -g_EyePosition.xzy + v3.xzy;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r1.w = dot(v6.xyz, v6.xyz);
  r1.w = rsqrt(r1.w);
  r3.xyz = v6.xzy * r1.www;
  r1.w = dot(r2.xyz, r3.xyz);
  r1.w = r1.w + r1.w;
  r2.xyz = r3.xyz * -r1.www + r2.xyz;
  r2.xyzw = Cubemap_0.Sample(Cubemap_0_s, r2.xyz).xyzw;
  r0.xyzw = r2.xyzw * ReflectionColor_11.xyzw + r0.xyzw;
  r2.xyz = g_EyePosition.xyz + -v3.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = sqrt(r1.w);
  r2.x = DetailMapDist_22 * 0.100000001;
  r1.w = saturate(r2.x * r1.w);
  r2.x = -LineContrast_10 + 1;
  r1.w = r1.w * r2.x + LineContrast_10;
  r2.xyzw = r1.wwww * r0.xyzw;
  r0.xyzw = -r0.xyzw * r1.wwww + r0.xyzw;
  r3.x = dot(r1.xyz, DetailMapUV_21_matrix._m00_m10_m20);
  r3.y = dot(r1.xyz, DetailMapUV_21_matrix._m01_m11_m21);
  r1.xyzw = DetailMap_5.Sample(DetailMap_5_s, r3.xy).xyzw;
  r1.x = dot(r1.xyzw, r1.xyzw);
  r1.x = sqrt(r1.x);
  r0.xyzw = r1.xxxx * r0.xyzw + r2.xyzw;
  r0.x = dot(r0.xyzw, r0.xyzw);
  r0.x = sqrt(r0.x);
  o0.xyzw = GlowMult_27 * r0.xxxx;

  o0.w = saturate(o0.w);
  return;
}