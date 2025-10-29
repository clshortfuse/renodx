#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Oct 27 22:32:17 2025

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float4x4 matFarCloudShadowProjectionTexScale : packoffset(c4);
  float fTextureSampleBias : packoffset(c8) = {0};
  float4 vecTerritoryColor[64] : packoffset(c9);
  float4 vecScaleTranslate : packoffset(c73);
  float4x4 matShadowProjectionTexScale : packoffset(c74);
  float fWaypointMapSectorX : packoffset(c78);
  float fWaypointMapSectorZ : packoffset(c78.y);
  float fWaypointMapSectorSizeX : packoffset(c78.z);
  float fWaypointMapSectorSizeZ : packoffset(c78.w);
  bool isNewSiegeMode : packoffset(c79);
  int arrCycloneSize : packoffset(c79.y) = {0};
  float4 arrCyclone[5] : packoffset(c80);
  float2 shellCountFadeInfo : packoffset(c85);
  bool g_isUseHeight : packoffset(c85.z);
}

cbuffer outdoorScatteringConst : register(b2)
{
  float4 vecSunColorConst : packoffset(c0);
  float4 vecSunGlareColorConst : packoffset(c1);
  float4 vecHorizon0ColorConst : packoffset(c2);
  float4 vecHorizon1ColorConst : packoffset(c3);
  float4 vecSkyBaseColorConst : packoffset(c4);
  float4 vecExtinctionColorConst : packoffset(c5);
  float4 vecReighColorConst : packoffset(c6);
  float4 vecSunScatterColorConst : packoffset(c7);
  float4 vecAmbientColorConst[2] : packoffset(c8);
  float4 vecAmbientOcclusionColorConst : packoffset(c10);
  float4 vecDeepAOColorConst : packoffset(c11);
  float4 vecSkinAmbientColorConst : packoffset(c12);
  float4 vecHairAmbientColorConst : packoffset(c13);
  float4 vecEffectAmbientColorAlphaConst : packoffset(c14);
  float4 vecEffectAmbientColorConst : packoffset(c15);
  float4 vecEffectAmbientColorHit : packoffset(c16);
  float4 vecEffectAmbientColorHitAlpha : packoffset(c17);
  float3 vecSunDirection : packoffset(c18);
  float fSeaHeightConst : packoffset(c18.w);
  float3 vecMoonDirection : packoffset(c19);
  float IndoorRateRegion : packoffset(c19.w);
  float fSunScatterExpConst : packoffset(c20);
  float fSunGlareExpConst : packoffset(c20.y);
  float fSunExpConst : packoffset(c20.z);
  float fScatterDistanceFalloffConst : packoffset(c20.w);
  float fMieDistanceFalloffConst : packoffset(c21);
  float fMieHeightConst : packoffset(c21.y);
  float fReighDistanceFalloffConst : packoffset(c21.z);
  float fEnvIntensityConst : packoffset(c21.w);
  float fHorizonColorExp0Const : packoffset(c22);
  float fHorizonColorExp1Const : packoffset(c22.y);
  float fCharacterLightMultiply : packoffset(c22.z);
  float fCharacterLightMultiply2 : packoffset(c22.w);
  float RainAmount : packoffset(c23);
  float AirTemperature : packoffset(c23.y);
  float AirTemperatureForParticle : packoffset(c23.z);
  float IndoorRateRoof : packoffset(c23.w);
  float3 vecLightDirection : packoffset(c24);
  float fCloudLayer0Const : packoffset(c24.w);
  float fCloudLayer1Const : packoffset(c25);
  float fCloudLayer2Const : packoffset(c25.y);
  float fCloudLayer3Const : packoffset(c25.z);
  float fCloudLayer4Const : packoffset(c25.w);
  float fCloudLayer5Const : packoffset(c26);
  float fCloudLayer6Const : packoffset(c26.y);
  float fCloudLayer7Const : packoffset(c26.z);
  float fCloudLayer8Const : packoffset(c26.w);
  float fCloudLayer9Const : packoffset(c27);
  float fCloudLayer10Const : packoffset(c27.y);
  float fCloudLayer11Const : packoffset(c27.z);
  float fCloudLayer12Const : packoffset(c27.w);
  float4 fShaderTest : packoffset(c28) = {1,1,1,1};
  float4 vecCloudColorConst : packoffset(c29);
  float3 vecColorMultiply : packoffset(c30);
  float fBrightnessMultiply : packoffset(c30.w);
  float fScatteringScale : packoffset(c31);
  float fAerosolDensityScale : packoffset(c31.y);
  float fAerosolPhaseFunG : packoffset(c31.z);
  float fAerosolAbsorbtionScale : packoffset(c31.w);
  float fTurbidity : packoffset(c32);
  float fRayleighHeight : packoffset(c32.y);
  float fMieHeight2 : packoffset(c32.z);
  float fCloudAltitude : packoffset(c32.w);
  float fCloudThickness : packoffset(c33);
  float fCloudDensity : packoffset(c33.y);
  float fCloudDensityContrast : packoffset(c33.z);
  float fCloudBaseScale : packoffset(c33.w);
  float fCloudDetailScale : packoffset(c34);
  bool isSceneScatter : packoffset(c34.y);
  float fRainPoolAmount : packoffset(c34.z);
  float fSnowPoolAmount : packoffset(c34.w);
}

cbuffer HDRConst : register(b3)
{
  float4 MaxEffectOutput : packoffset(c0);
  float MaxEffectColorBrightness : packoffset(c1);
  float hdrEncodeMulti : packoffset(c1.y);
  float hdrEncodeMulti_Effect : packoffset(c1.z);
  float gammaConst : packoffset(c1.w);
}

cbuffer shadowConst : register(b4)
{
  row_major float4x4 matShadowProjectionTexScale0 : packoffset(c0);
  row_major float4x4 matShadowProjectionTexScale1 : packoffset(c4);
  row_major float4x4 matShadowProjectionTexScale2 : packoffset(c8);
  row_major float4x4 matShadowProjectionTexScale3 : packoffset(c12);
  float4 vecShadowViewPosition0 : packoffset(c16);
  float4 vecShadowViewPosition1 : packoffset(c17);
  float4 vecShadowViewPosition2 : packoffset(c18);
  float4 vecShadowViewPosition3 : packoffset(c19);
  float fShadowmapSizeNear : packoffset(c20);
  float fShadowmapSizeFar : packoffset(c20.y);
  float fInvShadowmapSizeNear : packoffset(c20.z);
  float fInvShadowmapSizeFar : packoffset(c20.w);
  float fShadowmapSizeDynamic : packoffset(c21);
  float fInvShadowmapSizeDynamic : packoffset(c21.y);
  float fShadowmapNormalScale : packoffset(c21.z);
  float shadowConstFloatDummy0 : packoffset(c21.w);
}

cbuffer WorldmapCommonConst : register(b5)
{
  float4 vecFarTerrainColorConst : packoffset(c0);
  float4 invScreenSize : packoffset(c1);
  float4 vecWindDirection : packoffset(c2);
  float3 vecCurrentPos : packoffset(c3);
  float totalTime : packoffset(c3.w);
  float3 vecCameraLookAt : packoffset(c4);
  float fBrightnessWorldMap : packoffset(c4.w);
  float3 vecViewPosition : packoffset(c5);
  float fViewDistance : packoffset(c5.w);
  float3 vecLightWorldMap : packoffset(c6);
  float fRenderDeltaTime : packoffset(c6.w);
  bool isCharacterMode : packoffset(c7);
  bool isTownMode : packoffset(c7.y);
  bool isVillageSiege_common : packoffset(c7.z);
  bool doTerrainHide_common : packoffset(c7.w);
  float4 fixedTexCoord_common : packoffset(c8);
  int selectVillageSiegeKey_common : packoffset(c9);
  float fFieldDataResolution_common : packoffset(c9.y);
  float2 dummy_1 : packoffset(c9.z);
}

cbuffer WorldmapTerrainConst : register(b6)
{
  row_major float4x4 matWorldViewProjection : packoffset(c0);
  float4 vecFarTerrainHeightConst : packoffset(c4);
  float4 fixedTexCoord : packoffset(c5);
  float4 StartColorLocationInfo : packoffset(c6);
  float4 EndColorLocationInfo : packoffset(c7);
  float4 MinusColorLocationInfo : packoffset(c8);
  float4 detailTextureInfo : packoffset(c9);
  float fSelectedFieldType : packoffset(c10);
  float fLocationInfoNormalizeMid : packoffset(c10.y);
  float fLocationInfoNormalize : packoffset(c10.z);
  float fFieldDataResolution : packoffset(c10.w);
  bool isLocationInfo : packoffset(c11);
  bool isRegionRender : packoffset(c11.y);
  bool isVillageSiege : packoffset(c11.z);
  bool isOceanSiege : packoffset(c11.w);
  bool doTerrainHide : packoffset(c12);
  bool isGreatSeaMapRender : packoffset(c12.y);
  int selectTerritoryKey : packoffset(c12.z);
  int selectOccupySiegeKey : packoffset(c12.w);
  int selectRegionKey : packoffset(c13);
  int selectOceanSiegeKey : packoffset(c13.y);
  uint territoryDayKey : packoffset(c13.z);
  float dummy : packoffset(c13.w);
}

cbuffer WorldmapObjectConst : register(b7)
{
  row_major float4x4 matRelativeViewProjection : packoffset(c0);
  bool isSelectedLayer : packoffset(c4);
  bool isRoad : packoffset(c4.y);
  bool useFog : packoffset(c4.z);
  bool Dummy : packoffset(c4.w);
  int nRenderMode : packoffset(c5);
  float3 WorldmapObjectConstdummy : packoffset(c5.y);
}

SamplerState PA_LINEAR_WRAP_LODBIAS_FILTER_Minus1_s : register(s0);
SamplerState PA_LINEAR_BORDER_FILTER_1111_s : register(s1);
SamplerState PA_POINT_CLAMP_FILTER_s : register(s2);
SamplerState PA_POINT_WRAP_FILTER_s : register(s3);
SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s4);
Texture2D<float4> texDiffuse : register(t0);
Texture2D<float4> texShadowMap : register(t1);
Texture2D<float4> texShadowResult : register(t2);
Texture2D<float4> texDepth : register(t3);
Texture2D<float4> texTerritoryLayer : register(t4);
Texture2D<float4> texFogTerrainMap : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  nointerpolation float v4 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Reconstruct world-space position and look up terrain fog/fade parameters.
  r0.xyz = vecViewPosition.xyz + v3.xyz;
  r1.xy = -vecFarTerrainHeightConst.xy + r0.xz;
  r1.xy = r1.xy / vecFarTerrainHeightConst.zw;
  r1.x = texFogTerrainMap.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r1.xy, 0).w;
  r1.x = 16 * r1.x;
  r1.x = saturate(r1.x * r1.x);
  r1.yz = -vecCurrentPos.xz + r0.xz;
  r1.y = dot(r1.yz, r1.yz);
  r1.y = sqrt(r1.y);
  r1.z = -r1.y * 9.99999975e-05 + 1;
  r1.z = max(0, r1.z);
  r1.z = r1.z * 0.5 + r1.x;
  r1.z = min(1, r1.z);
  r1.x = isCharacterMode ? r1.z : r1.x;
  r1.z = -0.0199999996 + r1.x;
  r1.z = cmp(r1.z < 0);
  if (r1.z != 0) discard;
  // Fetch albedo/roughness for the world-map terrain patch and apply distance-based fade.
  r2.xyzw = texDiffuse.Sample(PA_LINEAR_WRAP_LODBIAS_FILTER_Minus1_s, v2.xy).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r1.z = saturate(r2.w + r2.w);
  r1.w = -50000 + fViewDistance;
  r1.w = 2.49999994e-06 * r1.w;
  r1.w = max(0.300000012, r1.w);
  r3.xyz = -vecCameraLookAt.xyz + r0.xyz;
  r2.w = dot(r3.xyz, r3.xyz);
  r2.w = sqrt(r2.w);
  r1.w = 700000 * r1.w;
  r1.w = saturate(r2.w / r1.w);
  r1.w = -r1.w * r1.w + 1;
  r1.w = r1.w * r1.w;
  r3.w = r1.z * r1.w;
  r1.z = r1.z * r1.w + -0.200000003;
  r1.z = cmp(r1.z < 0);
  if (r1.z != 0) discard;
  r2.xyz = r2.xyz + r2.xyz;
  r1.zw = invScreenSize.xy * v0.xy;
  r2.w = texDepth.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r1.zw, 0).x;
  // Evaluate cascaded shadow maps and blend near/far lookups for the world map sun lighting.
  r4.x = dot(v3.xyz, v3.xyz);
  r4.y = sqrt(r4.x);
  r4.y = r2.w * 10 + -r4.y;
  r1.zw = texShadowResult.Sample(PA_LINEAR_BORDER_FILTER_1111_s, r1.zw).xz;
  r1.z = saturate(abs(r4.y) * 9.99999975e-05 + r1.z);
  r1.w = 1 + -r1.w;
  r0.w = 1;
  r5.x = dot(r0.xyzw, matShadowProjectionTexScale._m00_m10_m20_m30);
  r5.y = dot(r0.xyzw, matShadowProjectionTexScale._m01_m11_m21_m31);
  r5.z = dot(r0.xyzw, matShadowProjectionTexScale._m02_m12_m22_m32);
  r0.w = dot(r0.xyzw, matShadowProjectionTexScale._m03_m13_m23_m33);
  r5.xyz = r5.xyz / r0.www;
  r6.xyz = r5.xyz * float3(22,22,22) + float3(-11,-11,-11);
  r6.xyz = saturate(float3(-10,-10,-10) + abs(r6.xyz));
  r7.xyz = cmp(float3(0.999000013,0.999000013,0.999000013) < r6.xyz);
  r0.w = (int)r7.y | (int)r7.x;
  r0.w = (int)r7.z | (int)r0.w;
  if (r0.w != 0) {
    r4.z = 1;
  }
  r7.xy = -fInvShadowmapSizeNear + r5.xy;
  r7.zw = fShadowmapSizeNear * r7.xy;
  r7.zw = frac(r7.zw);
  r7.xy = fShadowmapSizeNear * r7.xy + -r7.zw;
  r7.xy = float2(1,1) + r7.xy;
  r7.xy = fInvShadowmapSizeNear * r7.xy;
  r8.xyzw = texShadowMap.Gather(PA_POINT_CLAMP_FILTER_s, r7.xy).xyzw;
  r8.xyzw = abs(r8.wzxy) + -r5.zzzz;
  r8.xyzw = float4(1442.69507,1442.69507,1442.69507,1442.69507) * r8.xyzw;
  r8.xyzw = saturate(exp2(r8.xyzw));
  r7.xy = r8.yw + -r8.xz;
  r7.xy = r7.zz * r7.xy + r8.xz;
  r4.w = r7.y + -r7.x;
  r4.w = saturate(r7.w * r4.w + r7.x);
  r7.xyzw = fInvShadowmapSizeNear * float4(0,-1,-1,0) + r5.xyxy;
  r8.xyzw = fShadowmapSizeNear * r7.xyzw;
  r8.xyzw = frac(r8.xyzw);
  r7.xyzw = fShadowmapSizeNear * r7.xyzw + -r8.xyzw;
  r7.xyzw = float4(1,1,1,1) + r7.xyzw;
  r7.xyzw = fInvShadowmapSizeNear * r7.xyzw;
  r9.xyzw = texShadowMap.Gather(PA_POINT_CLAMP_FILTER_s, r7.xy).xyzw;
  r9.xyzw = abs(r9.wzxy) + -r5.zzzz;
  r9.xyzw = float4(1442.69507,1442.69507,1442.69507,1442.69507) * r9.xyzw;
  r9.xyzw = saturate(exp2(r9.xyzw));
  r7.xy = r9.yw + -r9.xz;
  r7.xy = r8.xx * r7.xy + r9.xz;
  r5.w = r7.y + -r7.x;
  r5.w = saturate(r8.y * r5.w + r7.x);
  r4.w = r5.w + r4.w;
  r7.xyzw = texShadowMap.Gather(PA_POINT_CLAMP_FILTER_s, r7.zw).xyzw;
  r7.xyzw = abs(r7.wzxy) + -r5.zzzz;
  r7.xyzw = float4(1442.69507,1442.69507,1442.69507,1442.69507) * r7.xyzw;
  r7.xyzw = saturate(exp2(r7.xyzw));
  r7.yw = r7.yw + -r7.xz;
  r7.xy = r8.zz * r7.yw + r7.xz;
  r5.w = r7.y + -r7.x;
  r5.w = saturate(r8.w * r5.w + r7.x);
  r4.w = r5.w + r4.w;
  r7.xy = fShadowmapSizeNear * r5.xy;
  r7.xy = frac(r7.xy);
  r5.xy = fShadowmapSizeNear * r5.xy + -r7.xy;
  r5.xy = float2(1,1) + r5.xy;
  r5.xy = fInvShadowmapSizeNear * r5.xy;
  r8.xyzw = texShadowMap.Gather(PA_POINT_CLAMP_FILTER_s, r5.xy).xyzw;
  r5.xyzw = abs(r8.wzxy) + -r5.zzzz;
  r5.xyzw = float4(1442.69507,1442.69507,1442.69507,1442.69507) * r5.xyzw;
  r5.xyzw = saturate(exp2(r5.xyzw));
  r5.yw = r5.yw + -r5.xz;
  r5.xy = r7.xx * r5.yw + r5.xz;
  r5.y = r5.y + -r5.x;
  r5.x = saturate(r7.y * r5.y + r5.x);
  r4.w = r5.x + r4.w;
  r5.x = 0.25 * r4.w;
  r4.w = r4.w * -0.5 + 3;
  r5.x = r5.x * r5.x;
  r5.y = dot(r6.xyz, float3(1,1,1));
  r4.w = r4.w * r5.x + r5.y;
  r4.w = min(1, r4.w);
  r0.w = r0.w ? r4.z : r4.w;
  r0.w = min(r1.z, r0.w);
  r1.z = rsqrt(r4.x);
  r4.xzw = v3.xyz * r1.zzz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(0.600000024,0.600000024,0.600000024) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = float3(0.550000012,0.550000012,0.550000012) * r2.xyz;
  r5.x = dot(v1.xyz, vecLightWorldMap.xyz);
  r5.y = saturate(r5.x * 0.5 + 0.5);
  r6.xyz = saturate(float3(0.400000006,0.449999988,0.400000006) + r0.www);
  r5.yzw = r6.xyz * r5.yyy;
  r6.xyz = rsqrt(vecSunColorConst.xyz);
  r6.xyz = float3(1,1,1) / r6.xyz;
  r7.xyz = float3(0.5,0.5,0.5) * vecAmbientOcclusionColorConst.xyz;
  r5.yzw = r5.yzw * r6.xyz + r7.xyz;
  r6.x = 1 + -vecLightWorldMap.y;
  r6.x = r6.x * r6.x;
  r6.xyz = r6.xxx * r5.yzw;
  r5.yzw = r6.xyz * float3(2,2,2) + r5.yzw;
  r6.xyz = v3.xyz * r1.zzz + v1.xyz;
  r1.z = dot(r6.xyz, r6.xyz);
  r1.z = rsqrt(r1.z);
  r6.xyz = r6.xyz * r1.zzz;
  r7.xyz = float3(1,1,1) + -vecSunColorConst.xyz;
  r1.z = saturate(dot(r4.xzw, r6.xyz));
  r1.z = 1 + -r1.z;
  r4.x = r1.z * r1.z;
  r4.x = r4.x * r4.x;
  r1.z = r4.x * r1.z;
  r4.xzw = r7.xyz * r1.zzz + vecSunColorConst.xyz;
  r0.w = saturate(r5.x * r0.w);
  r4.xzw = r4.xzw * r0.www + r5.yzw;
  r2.xyz = r4.xzw * r2.xyz;
  r2.xyz = fBrightnessWorldMap * r2.xyz;
  r2.xyz = ((RENODX_WORLD_MAP_EXPOSURE - 1.0f) * 0.5f + 1.0f) * r2.xyz;
  r2.xyz = float3(4,4,4) * r2.xyz;
  r0.w = saturate(1.75 + -r1.w);
  r2.xyz = r2.xyz * r0.www;
  r3.xyz = r2.xyz;
  r0.w = cmp(nRenderMode == 1);
  // Special-case draw path overlays siege selection beacons and time-based UI pulses.
  if (r0.w != 0) {
    r0.w = cmp(isVillageSiege_common != 0);
    r1.z = cmp(isNewSiegeMode != 0);
    r1.z = cmp((int)r1.z == 0);
    r0.w = r0.w ? r1.z : 0;
    r1.zw = r0.xz * float2(7.81249983e-05,7.81249983e-05) + -fixedTexCoord_common.zw;
    r2.x = 0.5 / fFieldDataResolution_common;
    r1.zw = r2.xx + r1.zw;
    r1.zw = r1.zw / fixedTexCoord_common.xy;
    r1.z = texTerritoryLayer.SampleLevel(PA_POINT_WRAP_FILTER_s, r1.zw, 0).w;
    r1.w = selectVillageSiegeKey_common;
    r1.z = -r1.z * 255 + r1.w;
    r1.z = cmp(abs(r1.z) < 0.400000006);
    r1.w = r1.y * 4.99999987e-05 + -totalTime;
    r1.w = sin(r1.w);
    r1.w = 1 + r1.w;
    r1.w = 0.5 * r1.w;
    r1.w = max(0, r1.w);
    r2.x = r1.w * r1.w;
    r2.xyz = r2.xxx * float3(0.899999976,0.899999976,-0.100000001) + float3(0,0,1);
    r5.xyz = r2.xyz * r1.www;
    r5.w = 0.5 * r1.w;
    r5.xyzw = saturate(r5.xyzw + r3.xyzw);
    r5.xyzw = r1.zzzz ? r5.xyzw : r3.xyzw;
    r5.xyzw = r0.wwww ? r5.xyzw : r3.xyzw;
    r0.x = dot(r0.xyz, float3(0.00039999999,0.000119999997,-0.000110000001));
    r0.x = sin(r0.x);
    r0.xyz = r0.xxx * float3(0.0500000007,0.0500000007,0.0500000007) + float3(0.949999988,0.949999988,0.949999988);
    r0.w = 0.800000012;
    r3.xyzw = r5.xyzw * r0.xyzw;
    r0.x = 0.560000002 * r5.w;
    r3.w = isTownMode ? r0.x : r3.w;
  }
  r0.x = cmp(isSelectedLayer != 0);
  r0.y = cmp(isRoad != 0);
  r0.z = cmp(v4.x != 0.000000);
  r0.x = (int)r0.z | (int)r0.x;
  // Selection overlays add a time-varying pulse when hovering or toggling layers.
  if (r0.x != 0) {
    r0.xzw = log2(r3.xyz);
    r0.xzw = float3(2.20000005,2.20000005,2.20000005) * r0.xzw;
    r0.xzw = exp2(r0.xzw);
    r0.xzw = float3(3,3,3) * r0.xzw;
    r1.z = totalTime + totalTime;
    r1.z = sin(r1.z);
    r3.xyz = abs(r1.zzz) * r0.xzw + r3.xyz;
  }
  r0.x = cmp(isTownMode != 0);
  r0.z = cmp(doTerrainHide_common != 0);
  r0.w = cmp(isVillageSiege_common != 0);
  r0.x = cmp((int)r0.x == 0);
  r0.x = r0.x ? r0.y : 0;
  // Town mode adds a soft breathing animation over the base shading.
  if (r0.x != 0) {
    r0.x = r1.y * 9.99999975e-06 + -totalTime;
    r0.x = sin(r0.x);
    r0.x = 1 + -abs(r0.x);
    r0.x = max(0, r0.x);
    r0.x = log2(r0.x);
    r0.x = 14 * r0.x;
    r0.x = exp2(r0.x);
    r1.yzw = r3.xyz + r3.xyz;
    r3.xyz = r0.xxx * r1.yzw + r3.xyz;
  }
  r5.xyz = r3.xyz;
  r0.x = saturate(0.00100000005 * r4.y);
  r0.x = 1 + -r0.x;
  r0.x = -r0.x * r0.x + 1;
  r0.y = cmp(0 < r2.w);
  r0.x = r3.w * r0.x;
  r5.w = r0.y ? r0.x : r3.w;
  if (useFog != 0) {
    r5.w = r5.w * r1.x;
  }
  r0.x = cmp(isNewSiegeMode != 0);
  r0.x = cmp((int)r0.x == -1);
  r0.x = r0.x ? r0.w : 0;
  r0.x = (int)r0.x | (int)r0.z;
  r1.xyzw = r5.xyzw * r5.xyzw;
  r1.xyzw = float4(0.300000012,0.300000012,0.300000012,0.300000012) * r1.xyzw;
  o0.xyzw = r0.xxxx ? r1.xyzw : r5.xyzw;
  return;
}