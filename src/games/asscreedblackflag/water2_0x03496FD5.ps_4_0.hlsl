// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 27 02:38:10 2025

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
  float SpecularNormalScaler : packoffset(c128);
  float WaterOpacity : packoffset(c129);
  float4 OceanConstants : packoffset(c130);
  float4 DepthFalloffMultiplier : packoffset(c131);
  float4 WaterDeepColor : packoffset(c132);
  float FresnelPower : packoffset(c133);
  float AmbientFoam : packoffset(c134);
  float4 FoamTint : packoffset(c135);
  float4 OceanSSSColor : packoffset(c136);
  float DepthFalloffDistance : packoffset(c138);
  float4 AlphaFadeParams : packoffset(c139);
  float4 NormalMapParams : packoffset(c140);
  float4 NormalMapUVScrolling : packoffset(c141);
  float4 WaterShallowColor : packoffset(c142);
  float4 OceanTopologyMapScaleBias : packoffset(c143);
  float4 FoamMaskParams : packoffset(c144);
  float4 FoamChurnParams : packoffset(c145);
  float4 FoamChurnTint : packoffset(c146);
  float4 g_SunSpecularParams : packoffset(c147);
  float4 g_SunSpecularColor : packoffset(c148);
  float4 ColorGradingParams1 : packoffset(c161);
  float4 ColorGradingParams2 : packoffset(c162);
  float4 OverrideFadeParams : packoffset(c170);
}

cbuffer OceanConstscb : register(b5)
{

  struct
  {
    float m_NormalMapScale;
    float m_Bumpiness;
    float m_DistanceFogEnd;
    float m_DistanceFogStart;
    float m_BumpinessFlattenEnd;
    float m_BumpinessFlattenStart;
    float m_WaveFoamScale;
    float4 m_FFTTileParams;
    float4x4 m_OceanCameraViewProj;
    float m_OceanProjectedGridBlendFactor;
    float4 m_NormalFoamOffset;
    float4 m_OceanProjectedCorners[4];
    float4x4 m_OceanProjectorViewProj;
    float4 m_OceanWorldCorners[4];
    float4 m_OceanViewOffset;
    float4 m_OceanSunDirection;
    float4 m_OceanSunColor;
    float4 m_TessellationFactors;
    float4 m_ScreenParams;
    float4 m_RippleImpactSurfaceInvSize;
    float4 m_RippleParamsSet1;
    float4 m_RippleParamsSet3;
    float4 m_WindPocketMapUVScaleAndBias;
    float4 m_WindPocketMapUVScrolling;
  } g_OceanConsts : packoffset(c0);

}

SamplerState NormalMap_s : register(s0);
SamplerState WaveFoamRamp_s : register(s1);
SamplerState WaveFoamMap_s : register(s2);
SamplerState FoamMaskMap_s : register(s4);
SamplerState TopologyFoamShallowMask_s : register(s5);
SamplerState DepthSurface_s : register(s8);
SamplerState g_RefractionSampler_s : register(s12);
Texture2D<float4> NormalMap : register(t0);
Texture2D<float4> WaveFoamRamp : register(t1);
Texture2D<float4> WaveFoamMap : register(t2);
Texture2D<float4> FoamMaskMap : register(t4);
Texture2D<float4> TopologyFoamShallowMask : register(t5);
Texture2D<float4> DepthSurface : register(t8);
Texture2D<float4> g_RefractionSampler : register(t12);


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
  float4 v9 : TEXCOORD6,
  float3 v10 : TEXCOORD7,
  out float4 o0 : SV_Target0,
  out float2 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r0.z = dot(v6.xyz, v6.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = v6.xyz * r0.zzz;
  r0.z = dot(v7.xyz, v7.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = v7.xyz * r0.zzz;
  r0.z = dot(v8.xyz, v8.xyz);
  r0.z = rsqrt(r0.z);
  r3.xyz = v8.xyz * r0.zzz;
  r0.zw = NormalMapParams.xy * v2.xy;
  r4.xy = ddx(r0.zw);
  r0.zw = ddy(r0.zw);
  r0.zw = r0.zw * r0.zw;
  r0.zw = r4.xy * r4.xy + r0.zw;
  r0.zw = sqrt(r0.zw);
  r0.z = max(r0.z, r0.w);
  r0.z = log2(r0.z);
  r0.z = min(NormalMapParams.z, r0.z);
  r4.xy = NormalMapUVScrolling.xy + v2.xy;
  r4.xyzw = NormalMap.SampleLevel(NormalMap_s, r4.xy, r0.z).xyzw;
  r4.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = sqrt(r0.w);
  r0.w = min(1, r0.w);
  r5.x = DepthFalloffMultiplier.w;
  r5.z = 1;
  r4.xyz = r5.xxz * r4.xyz;
  r2.xyz = r4.yyy * r2.xyz;
  r1.xyz = r4.xxx * r1.xyz + r2.xyz;
  r1.xyz = r4.zzz * r3.xyz + r1.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r2.xyz = g_EyePosition.xyz + -v5.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r2.w = rsqrt(r1.w);
  r3.xyz = r2.xyz * r2.www;
  r4.zw = r0.xy * float2(2,-2) + float2(-1,1);
  r5.xy = v10.xy / v10.zz;
  r4.zw = -r5.xy + r4.zw;
  o1.xy = saturate(r4.zw * float2(4,4) + float2(0.497999996,0.497999996));
  r4.zw = v9.zw * FoamMaskParams.xy + FoamMaskParams.zw;
  r5.xyzw = FoamMaskMap.Sample(FoamMaskMap_s, r4.zw).xyzw;
  r4.zw = v5.xy * OceanTopologyMapScaleBias.xy + OceanTopologyMapScaleBias.zw;
  r6.xyzw = TopologyFoamShallowMask.Sample(TopologyFoamShallowMask_s, r4.zw).xyzw;
  r3.w = saturate(r6.y + r6.y);
  r6.z = v3.z * r5.z + v4.w;
  r4.z = AmbientFoam * r5.y;
  r5.xyzw = WaveFoamMap.Sample(WaveFoamMap_s, v2.zw).xyzw;
  r6.x = r4.z * r3.w + r6.z;
  r6.yw = float2(0,0);
  r7.xyzw = WaveFoamRamp.Sample(WaveFoamRamp_s, r6.xy).xyzw;
  r5.xyz = r7.xyz * r5.xyz;
  r3.w = saturate(dot(r5.xyz, float3(1,1,1)));
  r5.xyzw = WaveFoamRamp.Sample(WaveFoamRamp_s, r6.zw).xyzw;
  r4.zw = v9.zw * FoamChurnParams.xy + FoamChurnParams.zw;
  r6.xyzw = WaveFoamMap.Sample(WaveFoamMap_s, r4.zw).xyzw;
  r4.z = FoamChurnTint.w * r5.w;
  r4.z = r4.z * r6.w;
  r5.xyz = FoamChurnTint.xyz * r4.zzz;
  r5.xyz = r3.www * FoamTint.xyz + r5.xyz;
  r4.z = dot(r3.xyz, r1.xyz);
  r4.w = cmp(r4.z >= DepthFalloffMultiplier.x);
  r4.w = r4.w ? 1.000000 : 0;
  r5.xyz = r5.xyz * r4.www + WaterDeepColor.xyz;
  r1.w = sqrt(r1.w);
  r1.w = saturate(r1.w / AlphaFadeParams.w);
  r1.w = -r1.w * r1.w + 1;
  r6.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r0.xy, 0).xyzw;
  r4.w = g_ReverseProjectionParams.z + r6.x;
  r4.w = g_ReverseProjectionParams.w / r4.w;
  r4.w = -v1.w + -r4.w;
  r4.w = abs(r4.w) * AlphaFadeParams.x + AlphaFadeParams.y;
  r5.w = AlphaFadeParams.z * r3.w;
  r6.x = 1 + -r4.w;
  r4.w = r5.w * r6.x + r4.w;
  o0.w = r4.w * r1.w;
  r1.w = 1 + -r3.w;
  r1.w = v3.w * r1.w;
  r6.xyz = r1.www * OceanSSSColor.xyz + v4.xyz;
  r5.xyz = r6.xyz + r5.xyz;
  r6.xy = r2.xy * r2.ww + g_OceanConsts.m_OceanSunDirection.xy;
  r6.z = r2.z * r2.w + -g_OceanConsts.m_OceanSunDirection.z;
  r1.w = dot(r6.xyz, r6.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r6.xyz * r1.www;
  r6.x = SpecularNormalScaler;
  r6.z = 1;
  r1.xyz = r6.xxz * r1.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r6.xyz = float3(1,1,-1) * g_OceanConsts.m_OceanSunDirection.xyz;
  r1.w = saturate(dot(r1.xyz, r6.xyz));
  r2.w = saturate(dot(r1.xyz, r2.xyz));
  r1.x = saturate(dot(r1.xyz, r3.xyz));
  r1.y = saturate(dot(r6.xyz, r2.xyz));
  r1.z = -g_SunSpecularParams.x + 1;
  r1.z = r0.w * r1.z + g_SunSpecularParams.x;
  r0.w = r0.w / r1.z;
  r0.z = r0.z / NormalMapParams.z;
  r0.w = -1 + r0.w;
  r0.z = r0.z * r0.w + 1;
  r0.w = g_SunSpecularParams.x * r0.z;
  r0.z = g_SunSpecularParams.x * r0.z + 2;
  r0.z = r0.z * r1.w;
  r1.y = 1 + -r1.y;
  r1.z = r1.y * r1.y;
  r1.z = r1.z * r1.z;
  r1.y = r1.y * r1.z;
  r1.y = r1.y * 0.980000019 + 0.0199999996;
  r1.z = r0.w * 0.785398126 + 1.57079625;
  r1.z = sqrt(r1.z);
  r1.z = 1 / r1.z;
  r2.x = 1 + -r1.z;
  r1.w = r1.w * r2.x + r1.z;
  r1.x = r1.x * r2.x + r1.z;
  r1.x = r1.w * r1.x;
  r1.x = 1 / r1.x;
  r0.z = 0.125 * r0.z;
  r1.z = log2(r2.w);
  r0.w = r1.z * r0.w;
  r0.w = exp2(r0.w);
  r0.z = r0.z * r0.w;
  r0.z = r0.z * r1.x;
  r0.z = r0.z * r1.y;
  r0.z = 0.400000006 * r0.z;
  r1.xyz = g_SunSpecularColor.xyz * r0.zzz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = r1.xyz + r5.xyz;
  r0.z = cmp(DepthFalloffMultiplier.x < r4.z);
  r2.xy = r4.xy * DepthFalloffMultiplier.zz + r0.xy;
  r3.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r2.xy, 0).xyzw;
  r0.w = g_ReverseProjectionParams.z + r3.x;
  r0.w = g_ReverseProjectionParams.w / r0.w;
  r0.w = -v1.w + -r0.w;
  r0.w = cmp(0 >= r0.w);
  r0.w = r0.w ? 1.000000 : 0;
  r0.xy = -r2.xy + r0.xy;
  r0.xy = r0.ww * r0.xy + r2.xy;
  r2.xyzw = g_RefractionSampler.Sample(g_RefractionSampler_s, r0.xy).xyzw;
  if (r0.z != 0) {
    r0.x = -DepthFalloffMultiplier.x + r4.z;
    r0.y = DepthFalloffMultiplier.y + -DepthFalloffMultiplier.x;
    r0.x = saturate(r0.x / r0.y);
    o0.xyz = r0.xxx * r2.xyz + r1.xyz;
  } else {
    o0.xyz = r1.xyz;
  }

  //o0.rgb = max(0, o0.rgb);
  o0.w = saturate(o0.w);
  return;
}