// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 00:15:00 2025

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
  float4 CausticParams_00 : packoffset(c149);
  float4 CausticParams_01 : packoffset(c150);
  float4 CausticParams_02 : packoffset(c151);
  float4x4 WorldToCausticTransform : packoffset(c152);
  float4 CausticFadeParams : packoffset(c158);
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

SamplerState NormalMap_s : register(s0);
SamplerState WaveFoamRamp_s : register(s1);
SamplerState WaveFoamMap_s : register(s2);
SamplerState DepthFalloffRamp_s : register(s3);
SamplerState FoamMaskMap_s : register(s4);
SamplerState TopologyFoamShallowMask_s : register(s5);
SamplerState g_CloudShadowSampler_s : register(s6);
SamplerState g_ReflectionSampler_s : register(s7);
SamplerState DepthSurface_s : register(s8);
SamplerState WindPocketMapSampler_s : register(s9);
SamplerState CausticMapSampler_s : register(s10);
SamplerState GBufferNormalSampler_s : register(s11);
SamplerState g_RefractionSampler_s : register(s12);
SamplerState SourceRippleHeightTexture_s : register(s13);
SamplerState g_ShadowNoiseSampler_s : register(s14);
SamplerComparisonState g_ShadowSampler_s : register(s15);
Texture2D<float4> NormalMap : register(t0);
Texture2D<float4> WaveFoamRamp : register(t1);
Texture2D<float4> WaveFoamMap : register(t2);
Texture2D<float4> DepthFalloffRamp : register(t3);
Texture2D<float4> FoamMaskMap : register(t4);
Texture2D<float4> TopologyFoamShallowMask : register(t5);
Texture2D<float4> g_CloudShadowSampler : register(t6);
Texture2D<float4> g_ReflectionSampler : register(t7);
Texture2D<float4> DepthSurface : register(t8);
Texture2D<float4> WindPocketMapSampler : register(t9);
Texture2D<float4> CausticMapSampler : register(t10);
Texture2D<float4> GBufferNormalSampler : register(t11);
Texture2D<float4> g_RefractionSampler : register(t12);
Texture2D<float4> SourceRippleHeightTexture : register(t13);
Texture2D<float4> g_ShadowNoiseSampler : register(t14);
Texture2D<float4> g_ShadowTexture : register(t15);


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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;
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

  //r4.rgb = saturate(r4.rgb);

  r4.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = sqrt(r0.w);
  r5.x = v3.x;
  r5.z = 1;
  r4.xyz = r5.xxz * r4.xyz;
  r2.xyz = r4.yyy * r2.xyz;
  r1.xyz = r4.xxx * r1.xyz + r2.xyz;
  r1.xyz = r4.zzz * r3.xyz + r1.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r1.xyz * r1.www;
  r3.xyz = g_EyePosition.xyz + -v5.xyz;
  r1.x = dot(r3.xyz, r3.xyz);
  r1.y = rsqrt(r1.x);
  r4.xyz = r3.xyz * r1.yyy;
  r5.xyzw = OceanConstants.xxzz * r2.xyxy;
  r6.x = 1;
  r6.z = v3.x * 0.850000024 + 0.150000006;
  r5.xyzw = r5.xyzw * r6.xxzz + r0.xyxy;
  r5.xyzw = float4(0,0,0,0.0149999997) + r5.xyzw;
  r6.xyzw = g_ReflectionSampler.SampleLevel(g_ReflectionSampler_s, r5.zw, 0).xyzw;

  //r6 = saturate(r6);

  r6.xyz = OceanConstants.yyy * r6.xyz;
  r6.xyz = saturate(r6.xyz * ColorGradingParams1.xyz + ColorGradingParams2.xyz);
  r5.zw = r0.xy * float2(2,-2) + float2(-1,1);
  r7.xy = v10.xy / v10.zz;
  r5.zw = -r7.xy + r5.zw;
  o1.xy = saturate(r5.zw * float2(4,4) + float2(0.497999996,0.497999996));
  r5.zw = v9.zw * FoamMaskParams.xy + FoamMaskParams.zw;
  r7.xyzw = FoamMaskMap.Sample(FoamMaskMap_s, r5.zw).xyzw;

 // r7 = saturate(r7);

  r5.zw = v5.xy * OceanTopologyMapScaleBias.xy + OceanTopologyMapScaleBias.zw;
  r8.xyzw = TopologyFoamShallowMask.Sample(TopologyFoamShallowMask_s, r5.zw).xyzw;

 // r8 = saturate(r8);

  r2.w = saturate(r8.y + r8.y);
  r9.z = v3.z * r7.z + v4.w;
  r3.w = AmbientFoam * r7.y;
  r7.xyzw = WaveFoamMap.Sample(WaveFoamMap_s, v2.zw).xyzw;

//  r7 = saturate(r7);

  r9.x = r3.w * r2.w + r9.z;
  r9.yw = float2(0,0);
  r10.xyzw = WaveFoamRamp.Sample(WaveFoamRamp_s, r9.xy).xyzw;



  r7.xyz = r10.xyz * r7.xyz;
  r2.w = saturate(dot(r7.xyz, float3(1,1,1)));
  r7.xyzw = WaveFoamRamp.Sample(WaveFoamRamp_s, r9.zw).xyzw;
  r5.zw = v9.zw * FoamChurnParams.xy + FoamChurnParams.zw;
  r9.xyzw = WaveFoamMap.Sample(WaveFoamMap_s, r5.zw).xyzw;
  r3.w = FoamChurnTint.w * r7.w;
  r3.w = r3.w * r9.w;
  r7.xyz = FoamChurnTint.xyz * r3.www;
  r7.xyz = r2.www * FoamTint.xyz + r7.xyz;
  r9.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r5.xy, 0).xyzw;

//  r9 = saturate(r9);

  r3.w = g_ReverseProjectionParams.z + r9.x;
  r9.z = g_ReverseProjectionParams.w / r3.w;
  r5.zw = g_ReverseProjectionParams2.xy + float2(-1,1);
  r8.xy = r5.xy * float2(2,-2) + r5.zw;
  r8.xy = g_ReverseProjectionParams.xy * r8.xy;
  r9.xy = r8.xy * r9.zz;
  r9.w = 1;
  r10.z = dot(r9.xyzw, g_ViewToWorld._m02_m12_m22_m32);
  r3.w = -v1.w + -r9.z;
  r3.w = cmp(0 >= r3.w);
  r3.w = r3.w ? 1.000000 : 0;
  r8.xy = -r5.xy + r0.xy;
  r8.xy = r3.ww * r8.xy + r5.xy;
  r11.xyzw = g_RefractionSampler.Sample(g_RefractionSampler_s, r8.xy).xyzw;
  r12.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r0.xy, 0).xyzw;
  r4.w = g_ReverseProjectionParams.z + r12.x;
  r12.z = g_ReverseProjectionParams.w / r4.w;
  r0.xy = r0.xy * float2(2,-2) + r5.zw;
  r0.xy = g_ReverseProjectionParams.xy * r0.xy;
  r12.xy = r0.xy * r12.zz;
  r12.w = 1;
  r0.x = dot(r12.xyzw, g_ViewToWorld._m02_m12_m22_m32);
  r0.y = -v1.w + -r12.z;
  r0.x = r0.x + -r10.z;
  r0.x = r3.w * r0.x + r10.z;
  r8.x = DepthFalloffDistance * -r0.x;
  r8.y = 0;
  r12.xyzw = DepthFalloffRamp.Sample(DepthFalloffRamp_s, r8.xy).xyzw;
  r0.x = 1 + -r12.w;
  r0.x = max(v3.y, r0.x);
  r3.w = r0.y / WaterOpacity;
  r13.w = saturate(max(r3.w, r0.x));
  r8.xyw = r12.xyz * r11.xyz;
  r14.xyz = WaterShallowColor.xyz + -WaterDeepColor.xyz;
  r14.xyz = r8.zzz * r14.xyz + WaterDeepColor.xyz;
  r11.xyz = -r11.xyz * r12.xyz + r14.xyz;
  r8.xyz = r13.www * r11.xyz + r8.xyw;
  r13.xyz = r8.xyz + r7.xyz;
  r0.x = cmp(9.99999975e-05 < g_OceanConsts.m_RippleParamsSet1.w);
  if (r0.x != 0) {
    r0.x = sqrt(r1.x);
    r5.zw = g_OceanConsts.m_OceanViewOffset.xy + v9.zw;
    r1.x = saturate(r1.z * r1.w + -0.100000001);
    r1.x = dot(r1.xx, r1.xx);
    r1.z = 1 / g_OceanConsts.m_RippleParamsSet1.x;
    r7.xy = r5.zw * r1.zz;
    r8.xw = r5.zw * r1.zz + -g_OceanConsts.m_RippleImpactSurfaceInvSize.xy;
    r8.yz = r7.yx;
    r11.xyzw = SourceRippleHeightTexture.Sample(SourceRippleHeightTexture_s, r8.xy).xyzw;
    r8.xyzw = SourceRippleHeightTexture.Sample(SourceRippleHeightTexture_s, r8.zw).xyzw;
    r14.yz = g_OceanConsts.m_RippleParamsSet3.ww * r5.wz;
    r14.xw = r5.zw * g_OceanConsts.m_RippleParamsSet3.ww + -g_OceanConsts.m_RippleImpactSurfaceInvSize.xy;
    r15.xyzw = SourceRippleHeightTexture.Sample(SourceRippleHeightTexture_s, r14.xy).xyzw;
    r14.xyzw = SourceRippleHeightTexture.Sample(SourceRippleHeightTexture_s, r14.zw).xyzw;
    r1.zw = float2(0.0500000007,0.0399999991) * r0.xx;
    r1.xzw = min(float3(1,1,1), r1.xzw);
    r0.x = r15.x + -r11.x;
    r11.x = r1.z * r0.x + r11.x;
    r0.x = r14.x + -r8.x;
    r11.y = r1.z * r0.x + r8.x;
    r5.zw = r7.xy * g_OceanConsts.m_WindPocketMapUVScaleAndBias.xy + g_OceanConsts.m_WindPocketMapUVScrolling.xy;
    r7.xyzw = WindPocketMapSampler.Sample(WindPocketMapSampler_s, r5.zw).xyzw;
    r0.x = g_OceanConsts.m_WindPocketMapUVScaleAndBias.z + r7.x;
    r1.z = 1 + -r1.w;
    r0.x = r1.z * r0.x;
    r1.z = r13.w * -0.400000006 + 0.800000012;
    r0.x = r1.z * r0.x;
    r11.z = 1;
    r1.xzw = r11.xyz * r1.xxx;
    r1.xzw = g_OceanConsts.m_RippleParamsSet1.www * r1.xzw;
    r1.xzw = r1.xzw * r0.xxx + r2.xyz;
    r0.x = dot(r1.xzw, r1.xzw);
    r0.x = rsqrt(r0.x);
    r2.xyz = r1.xzw * r0.xxx;
  }
  r0.x = abs(r0.y) * AlphaFadeParams.x + AlphaFadeParams.y;
  r0.y = AlphaFadeParams.z * r2.w;
  r1.x = 1 + -r0.x;
  o0.w = r0.y * r1.x + r0.x;
  r0.x = 1 + -r2.w;
  r0.y = dot(r4.xyz, r2.xyz);
  r0.y = 1 + -r0.y;
  r0.y = min(1, abs(r0.y));
  r0.y = log2(r0.y);
  r1.x = log2(r0.x);
  r0.y = r0.y * FresnelPower + r1.x;
  r0.y = exp2(r0.y);
  r0.x = v3.w * r0.x;
  r1.xzw = r0.xxx * OceanSSSColor.xyz + v4.xyz;
  r7.xy = v5.xy + r2.xy;
  r7.z = v5.z;
  r7.w = 1;
  r8.y = dot(r7.xyzw, g_Shadows.m_WorldToLightProj._m00_m10_m20_m30);
  r8.z = dot(r7.xyzw, g_Shadows.m_WorldToLightProj._m01_m11_m21_m31);
  r8.w = dot(r7.xyzw, g_Shadows.m_WorldToLightProj._m02_m12_m22_m32);
  r11.xyz = r8.yzw * g_Shadows.m_ScalesX.xyz + g_Shadows.m_OffsetsX.xyz;
  r14.xyz = r8.yzw * g_Shadows.m_ScalesY.xyz + g_Shadows.m_OffsetsY.xyz;
  r15.xyz = r8.yzw * g_Shadows.m_ScalesZ.xyz + g_Shadows.m_OffsetsZ.xyz;
  r8.xyz = r8.yzw * g_Shadows.m_ScalesW.xyz + g_Shadows.m_OffsetsW.xyz;
  r5.zw = cmp(abs(r14.xy) < g_Shadows.m_CascadesRangesMax.yy);
  r0.x = r5.w ? r5.z : 0;
  r5.zw = cmp(abs(r15.xy) < g_Shadows.m_CascadesRangesMax.zz);
  r2.w = r5.w ? r5.z : 0;
  r5.zw = cmp(abs(r8.xy) < g_Shadows.m_CascadesRangesMax.ww);
  r3.w = r5.w ? r5.z : 0;
  r11.xyz = r0.xxx ? r14.xyz : r11.xyz;
  r11.xyz = r2.www ? r15.xyz : r11.xyz;
  r8.xyz = r3.www ? r8.xyz : r11.xyz;
  r0.x = r0.x ? g_Shadows.m_OffsetsY.w : g_Shadows.m_OffsetsX.w;
  r0.x = r2.w ? g_Shadows.m_OffsetsZ.w : r0.x;
  r0.x = r3.w ? g_Shadows.m_OffsetsW.w : r0.x;
  r8.yzw = float3(0.5,0.5,0.5) + r8.xyz;
  r8.x = r8.y * g_Shadows.m_ScalesX.w + r0.x;
  r5.zw = float2(0.015625,0.015625) * v0.xy;
  r11.xyzw = g_ShadowNoiseSampler.Sample(g_ShadowNoiseSampler_s, r5.zw).xyzw;
  r5.zw = float2(-0.5,-0.5) + r11.yx;
  r5.zw = g_Shadows.m_NoiseScale.xx * r5.zw;
  r11.xy = float2(-0.124001242,0.389028013) * r5.zz;
  r11.xy = r5.ww * float2(1.29911542,-0.504198194) + -r11.xy;
  r11.z = dot(r5.wz, float2(-0.124001242,1.29911542));
  r11.xz = r11.xz * g_Shadows.m_ShadowMapSize.xy + r8.xz;
  r0.x = g_ShadowTexture.SampleCmpLevelZero(g_ShadowSampler_s, r11.xz, r8.w).x;
  r11.w = dot(r5.wz, float2(0.389028013,-0.504198194));
  r11.xy = r11.yw * g_Shadows.m_ShadowMapSize.xy + r8.xz;
  r2.w = g_ShadowTexture.SampleCmpLevelZero(g_ShadowSampler_s, r11.xy, r8.w).x;
  r0.x = r2.w + r0.x;
  r11.xy = float2(-1.20522106,1.9759326) * r5.zz;
  r11.xy = r5.ww * float2(-0.335031986,0.160125375) + -r11.xy;
  r11.z = dot(r5.wz, float2(-1.20522106,-0.335031986));
  r11.xz = r11.xz * g_Shadows.m_ShadowMapSize.xy + r8.xz;
  r2.w = g_ShadowTexture.SampleCmpLevelZero(g_ShadowSampler_s, r11.xz, r8.w).x;
  r0.x = r2.w + r0.x;
  r11.w = dot(r5.wz, float2(1.9759326,0.160125375));
  r5.zw = r11.yw * g_Shadows.m_ShadowMapSize.xy + r8.xz;
  r2.w = g_ShadowTexture.SampleCmpLevelZero(g_ShadowSampler_s, r5.zw, r8.w).x;
  r0.x = r2.w + r0.x;
  r8.xyz = -g_EyePosition.xyz + r7.xyz;
  r2.w = dot(r8.xyz, r8.xyz);
  r2.w = saturate(r2.w * OverrideFadeParams.x + OverrideFadeParams.y);
  r0.x = r0.x * 0.25 + r2.w;
  r0.xw = min(float2(1,1), r0.xw);
  r5.zw = r7.xy * g_Shadows.m_CloudUVScaleOffset.xy + g_Shadows.m_CloudUVScaleOffset.zw;
  r7.xyzw = g_CloudShadowSampler.SampleLevel(g_CloudShadowSampler_s, r5.zw, 0).xyzw;
  r2.w = saturate(-g_Shadows.m_CloudShadowsParams.y + r7.x);
  r2.w = saturate(g_Shadows.m_CloudShadowsParams.x + r2.w);
  r3.w = r13.w * r13.w;
  r0.x = r0.x * r2.w + -r3.w;
  r0.x = 1 + r0.x;
  r0.x = min(1, r0.x);
  r2.w = dot(CausticParams_02.xyz, CausticParams_02.xyz);
  r2.w = cmp(r2.w == 0.000000);
  if (r2.w != 0) {
    r7.xyzw = float4(0,0,0,0);
  }
  if (r2.w == 0) {
    r10.x = dot(r9.xyzw, g_ViewToWorld._m00_m10_m20_m30);
    r10.y = dot(r9.xyzw, g_ViewToWorld._m01_m11_m21_m31);
    r10.w = dot(r9.xyzw, g_ViewToWorld._m03_m13_m23_m33);
    r8.x = dot(r10.xyzw, WorldToCausticTransform._m00_m10_m20_m30);
    r8.y = dot(r10.xyzw, WorldToCausticTransform._m01_m11_m21_m31);
    r5.zw = r8.xy / CausticParams_00.zw;
    r2.w = saturate(abs(r10.z) / CausticParams_00.x);
    r2.w = 1 + -r2.w;
    r3.w = 1 + -r2.w;
    r3.w = CausticParams_01.x * r3.w;
    r3.w = round(r3.w);
    r8.xy = g_OceanConsts.m_WindPocketMapUVScrolling.xy + r5.zw;
    r8.xyzw = CausticMapSampler.SampleLevel(CausticMapSampler_s, r8.xy, r3.w).xyzw;
    r11.xyzw = GBufferNormalSampler.Sample(GBufferNormalSampler_s, r5.xy).xyzw;
    r10.xyw = r11.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r3.w = dot(r10.xyw, r10.xyw);
    r3.w = rsqrt(r3.w);
    r3.w = r10.w * r3.w;
    r5.xy = r5.zw * g_OceanConsts.m_WindPocketMapUVScaleAndBias.xy + g_OceanConsts.m_WindPocketMapUVScrolling.xy;
    r5.xyzw = WindPocketMapSampler.Sample(WindPocketMapSampler_s, r5.xy).xyzw;
    r4.w = g_OceanConsts.m_WindPocketMapUVScaleAndBias.z + r5.x;
    r3.w = abs(r3.w) * abs(r3.w);
    r3.w = r3.w * r3.w;
    r3.w = r3.w * r3.w;
    r5.xyz = r8.xyz * r3.www;
    r5.xyz = r5.xyz * r0.xxx;
    r3.w = abs(r10.z) * CausticFadeParams.x + CausticFadeParams.y;
    r2.w = r3.w * r2.w;
    r5.xyz = r5.xyz * r2.www;
    r2.w = dot(r9.xyz, r9.xyz);
    r2.w = sqrt(r2.w);
    r2.w = saturate(r2.w / CausticParams_00.y);
    r2.w = 1 + -r2.w;
    r5.xyz = r5.xyz * r2.www;
    r5.xyz = CausticParams_01.yyy * r5.xyz;
    r5.xyz = r5.xyz * r4.www;
    r7.xyz = CausticParams_02.xyz * r5.xyz;
    r7.w = 0;
  }
  r2.w = 1 + -r13.w;
  r5.xyzw = r2.wwww * r7.xyzw;
  r5.xyzw = r5.xyzw * r12.xyzw + r13.xyzw;
  r3.xyz = r3.xyz * r1.yyy + g_OceanConsts.m_OceanSunDirection.xyz;
  r1.y = dot(r3.xyz, r3.xyz);
  r1.y = rsqrt(r1.y);
  r3.xyz = r3.xyz * r1.yyy;
  r7.x = SpecularNormalScaler;
  r7.z = 1;
  r7.xyz = r7.xxz * r2.xyz;
  r1.y = dot(r7.xyz, r7.xyz);
  r1.y = rsqrt(r1.y);
  r7.xyz = r7.xyz * r1.yyy;
  r1.y = saturate(dot(r7.xyz, g_OceanConsts.m_OceanSunDirection.xyz));
  r2.w = saturate(dot(r7.xyz, r3.xyz));
  r3.w = saturate(dot(r7.xyz, r4.xyz));
  r3.x = saturate(dot(g_OceanConsts.m_OceanSunDirection.xyz, r3.xyz));
  r3.y = -g_SunSpecularParams.x + 1;
  r3.y = r0.w * r3.y + g_SunSpecularParams.x;
  r0.w = r0.w / r3.y;
  r0.z = r0.z / NormalMapParams.z;
  r0.w = -1 + r0.w;
  r0.z = r0.z * r0.w + 1;
  r0.w = g_SunSpecularParams.x * r0.z;
  r0.z = g_SunSpecularParams.x * r0.z + 2;
  r0.z = r0.z * r1.y;
  r3.x = 1 + -r3.x;
  r3.y = r3.x * r3.x;
  r3.y = r3.y * r3.y;
  r3.x = r3.x * r3.y;
  r3.x = r3.x * 0.980000019 + 0.0199999996;
  r3.y = r0.w * 0.785398126 + 1.57079625;
  r3.y = sqrt(r3.y);
  r3.y = 1 / r3.y;
  r3.z = 1 + -r3.y;
  r1.y = r1.y * r3.z + r3.y;
  r3.y = r3.w * r3.z + r3.y;
  r1.y = r3.y * r1.y;
  r1.y = 1 / r1.y;
  r0.z = 0.125 * r0.z;
  r2.w = log2(r2.w);
  r0.w = r2.w * r0.w;
  r0.w = exp2(r0.w);
  r0.z = r0.z * r0.w;
  r0.z = r0.z * r1.y;
  r0.z = r0.z * r0.x;
  r0.z = r0.z * r3.x;
  r0.z = 0.400000006 * r0.z;
  r3.xyz = g_SunSpecularColor.xyz * r0.zzz;
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r0.z = saturate(dot(r2.xyz, g_SunDirection.xyz));
  r4.xyz = g_OceanConsts.m_OceanSunColor.xyz * r0.zzz;
  r0.x = r0.x * 0.699999988 + 0.300000012;
  r4.xyz = r5.xyz * r4.xyz;
  r0.xzw = r4.xyz * r0.xxx + r3.xyz;
  r3.xyz = r6.xyz + -r0.xzw;
  r0.xyz = r0.yyy * r3.xyz + r0.xzw;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r2.xyw = r2.xyz * r2.xyz;
  r0.w = cmp(r2.z >= 0);
  r1.y = r0.w ? 1.000000 : 0;
  r0.w = r0.w ? 0 : 1;
  r2.x = r2.x + r2.y;
  r1.y = r2.w * r1.y;
  r3.xyzw = g_AmbientCube[1].xyzw * r1.yyyy;
  r3.xyzw = r2.xxxx * g_AmbientCube[0].xyzw + r3.xyzw;
  r0.w = r2.w * r0.w;
  r2.xyzw = r0.wwww * g_AmbientCube[2].xyzw + r3.xyzw;
  r2.xyz = r2.xyz * r2.www;
  r2.xyz = r2.xyz * r5.xyz;
  r0.xyz = r2.xyz * r5.www + r0.xyz;
  o0.xyz = r0.xyz + r1.xzw;

  o0.w = saturate(o0.w);

  return;
}