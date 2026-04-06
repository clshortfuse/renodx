#include "../shared.h"

#define SHADOW_DBG_CONTACT_INV  _2585
#define SHADOW_DBG_OUT_R        _2600
#define SHADOW_DBG_OUT_G        _2601
#define SHADOW_DBG_OUT_B        _2602
#define SHADOW_DBG_OUT_A        _2603

// ── Foliage Contact Shadow Material ID Reference ─────────────────────
// ID 12 = Tree leaves + larger bushes (close/medium range)
// ID 13 = Small-scale foliage (close/medium range)
// ID 14 = Small-scale foliage (close/medium range)
// ID 15 = Distant tree LODs + larger bushes (medium/long range)
// ID 16 = Same Larger bushes as ID 15 + smaller bushes (close/medium range, no trees)
// ID 17 = Grass, flowers, small foliage (close/medium range)
// ID 18 = Very small bushes + grass not covered by other IDs (close/medium range)
// ─────────────────────────────────────────────────────────────────────

Texture2D<float4> __3__36__0__0__g_terrainShadowDepth : register(t141, space36);

Texture2DArray<float4> __3__36__0__0__g_dynamicShadowDepthArray : register(t229, space36);

Texture2DArray<half4> __3__36__0__0__g_dynamicShadowColorArray : register(t231, space36);

Texture2DArray<float4> __3__36__0__0__g_shadowDepthArray : register(t232, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t0, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t40, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t79, space36);

RWTexture2D<half4> __3__38__0__1__g_shadowColorResultUAV : register(u39, space38);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b20, space35) {
  float4 _time;
  float4 _timeNoScale;
  uint4 _frameNumber;
  float4 _screenSizeAndInvSize;
  float4 _bufferSizeAndInvSize;
  float4 _hiZUVScaleAndInvScale;
  float4 _resolutionScale;
  float4 _temporalReprojectionParams;
  float4 _viewPos;
  float4 _viewDir;
  column_major float4x4 _viewProj;
  column_major float4x4 _viewProjNoJitter;
  column_major float4x4 _viewProjRelative;
  column_major float4x4 _viewProjRelativeNoJitter;
  column_major float4x4 _invViewProj;
  column_major float4x4 _invViewProjRelative;
  column_major float4x4 _invViewProjRelativeNoJitter;
  column_major float4x4 _viewProjRelativeOrtho;
  float4 _sunDirection;
  float4 _moonDirection;
  float4 _moonRight;
  float4 _moonUp;
  float4 _ssaoRandomDirection[16];
  column_major float4x4 _view;
  column_major float4x4 _viewRelative;
  column_major float4x4 _viewRelativePrev;
  column_major float4x4 _proj;
  column_major float4x4 _projNoJitter;
  float4 _viewPosPrev;
  column_major float4x4 _viewProjNoJitterPrev;
  column_major float4x4 _viewProjRelativePrev;
  column_major float4x4 _viewProjRelativeNoJitterPrev;
  column_major float4x4 _invViewProjPrev;
  column_major float4x4 _invViewProjRelativePrev;
  column_major float4x4 _projToPrevProj;
  column_major float4x4 _projToPrevProjNoTranslation;
  column_major float4x4 _viewProjectionTexScale;
  float4 _temporalAAJitter;
  float4 _temporalAAJitterParams;
  float4 _frustumPlanes[6];
  float4 _frustumPlanesPrev[6];
  float4 _frustumCornerDirs[4];
  float4 _screenPercentage;
  float4 _nearFarProj;
  float4 _renderingOriginPos;
  float4 _renderingOriginPosPrev;
  float4 _lodMaskRenderRate;
  float4 _terrainNormalParams;
  int4 _hiZMapInfo;
  int4 _hiZMapInfoCurrent;
  float4 _treeParams;
  uint4 _clusterSize;
  uint4 _globalLightParams;
  float4 _bevelParams;
  float4 _variableRateShadingParams;
  float4 _cavityParams;
  float4 _customRenderPassSizeInvSize;
  uint4 _impostorParams;
  float4 _clusterDecalSizeAndInvSize;
  uint4 _globalWindParams;
  float4 _windFluidVolumeParams;
  float4 _windFluidTextureParams;
  float4 _raytracingAccelerationStructureOrigin;
  float4 _debugBaseColor;
  float4 _debugNormal;
  float4 _debugMaterial;
  float4 _debugMultiplier;
  half4 _debugBaseColor16;
  half4 _debugNormal16;
  half4 _debugMaterial16;
  half4 _debugMultiplier16;
  float4 _debugCursorWorldPos;
  uint4 _debugRenderToggle01;
  uint4 _debugTreeShapeVariation;
  float4 _positionBasedDynamicsParameter;
  float _effectiveMetallicForVelvet;
  float _debugCharacterSnowRate;
  uint _systemRandomSeed;
  uint _skinnedMeshDebugFlag;
  float4 _viewPosShifted;
  float4 _viewPosShiftedPrev;
  float4 _viewTileRelativePos;
  float4 _viewTileRelativePosPrev;
  int2 _viewTileIndex;
  int2 _viewTileIndexPrev;
  float4 _worldVolume;
  float3 _diffViewPosAccurate;
  uint _isAllowBlood;
};

cbuffer __3__35__0__0__ShadowConstantBuffer : register(b21, space35) {
  float4 _shadowDepthRanges : packoffset(c000.x);
  float4 _massiveShadowSizeAndInvSize : packoffset(c001.x);
  uint4 _shadowParam : packoffset(c002.x);
  int4 _updateIndex : packoffset(c003.x);
  float4 _jitterOffset[8] : packoffset(c004.x);
  float4 _shadowRelativePosition : packoffset(c012.x);
  float4 _dynmaicShadowSizeAndInvSize : packoffset(c013.x);
  column_major float4x4 _dynamicShadowProjTexScale[2] : packoffset(c014.x);
  column_major float4x4 _dynamicShadowProjRelativeTexScale[2] : packoffset(c022.x);
  float4 _dynamicShadowFrustumPlanes0[6] : packoffset(c030.x);
  float4 _dynamicShadowFrustumPlanes1[6] : packoffset(c036.x);
  column_major float4x4 _dynamicShadowViewProj[2] : packoffset(c042.x);
  column_major float4x4 _dynamicShadowViewProjPrev[2] : packoffset(c050.x);
  column_major float4x4 _invDynamicShadowViewProj[2] : packoffset(c058.x);
  float4 _dynamicShadowPosition[2] : packoffset(c066.x);
  float4 _shadowSizeAndInvSize : packoffset(c068.x);
  column_major float4x4 _shadowProjTexScale[2] : packoffset(c069.x);
  column_major float4x4 _shadowProjRelativeTexScale[2] : packoffset(c077.x);
  float4 _staticShadowPosition[2] : packoffset(c085.x);
  column_major float4x4 _shadowViewProj[2] : packoffset(c087.x);
  column_major float4x4 _shadowViewProjRelative[2] : packoffset(c095.x);
  column_major float4x4 _invShadowViewProj[2] : packoffset(c103.x);
  float4 _currShadowFrustumPlanes[6] : packoffset(c111.x);
  column_major float4x4 _currShadowViewProjRelative : packoffset(c117.x);
  column_major float4x4 _currInvShadowViewProjRelative : packoffset(c121.x);
  float4 _currStaticShadowPosition : packoffset(c125.x);
  float4 _currTerrainShadowFrustumPlanes[6] : packoffset(c126.x);
  column_major float4x4 _terrainShadowProjTexScale : packoffset(c132.x);
  column_major float4x4 _terrainShadowProjRelativeTexScale : packoffset(c136.x);
  column_major float4x4 _terrainShadowViewProj : packoffset(c140.x);
  column_major float4x4 _nearFieldShadowViewProj : packoffset(c144.x);
  float4 _nearFieldShadowFlag : packoffset(c148.x);
  float4 _nearFieldShadowFrustumPlanes[6] : packoffset(c149.x);
};

cbuffer __3__35__0__0__TileConstantBuffer : register(b33, space35) {
  uint4 g_tileIndex[4096] : packoffset(c000.x);
};

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _shadowAOParams : packoffset(c000.x);
  float4 _tiledRadianceCacheParams : packoffset(c001.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

SamplerComparisonState __3__40__0__0__g_samplerShadow : register(s0, space40);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _16[4];
  float _24[2];
  float _25[2];
  float _26[2];
  _16[0] = ((g_tileIndex[(SV_GroupID.x) >> 6]).x);
  _16[1] = ((g_tileIndex[(SV_GroupID.x) >> 6]).y);
  _16[2] = ((g_tileIndex[(SV_GroupID.x) >> 6]).z);
  _16[3] = ((g_tileIndex[(SV_GroupID.x) >> 6]).w);
  int _40 = _16[(((uint)(SV_GroupID.x) >> 4) & 3)];
  float _54 = float((uint)(((uint)(((((int)((uint)(_40) << 2)) & 262140) | ((int)(SV_GroupID.x) & 3)) << 3)) + SV_GroupThreadID.x));
  float _55 = float((uint)(((uint)(((((uint)((uint)(_40)) >> 16) << 2) | (((uint)(SV_GroupID.x) >> 2) & 3)) << 3)) + SV_GroupThreadID.y));
  float _63 = ((_bufferSizeAndInvSize.z * 2.0f) * (_54 + 0.5f)) + -1.0f;
  float _66 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (_55 + 0.5f));
  uint _68 = __3__36__0__0__g_depthStencil.Load(int3(((int)(((uint)(((((int)((uint)(_40) << 2)) & 262140) | ((int)(SV_GroupID.x) & 3)) << 3)) + SV_GroupThreadID.x)), ((int)(((uint)(((((uint)((uint)(_40)) >> 16) << 2) | (((uint)(SV_GroupID.x) >> 2) & 3)) << 3)) + SV_GroupThreadID.y)), 0));
  int _70 = (uint)((uint)(_68.x)) >> 24;
  float _73 = float((uint)((uint)(_68.x & 16777215))) * 5.960465188081798e-08f;
  int _74 = _70 & 127;
  uint _76 = __3__36__0__0__g_sceneNormal.Load(int3(((int)(((uint)(((((int)((uint)(_40) << 2)) & 262140) | ((int)(SV_GroupID.x) & 3)) << 3)) + SV_GroupThreadID.x)), ((int)(((uint)(((((uint)((uint)(_40)) >> 16) << 2) | (((uint)(SV_GroupID.x) >> 2) & 3)) << 3)) + SV_GroupThreadID.y)), 0));
  float _92 = min(1.0f, ((float((uint)((uint)(_76.x & 1023))) * 0.001956947147846222f) + -1.0f));
  float _93 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_76.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _94 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_76.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _96 = rsqrt(dot(float3(_92, _93, _94), float3(_92, _93, _94)));
  float _97 = _96 * _92;
  float _98 = _96 * _93;
  float _99 = _96 * _94;
  bool _101 = (_73 == 1.0f);
  int _371;
  float _550;
  float _624;
  int _625;
  float _626;
  float _690;
  int _691;
  int _692;
  float _693;
  float _755;
  int _756;
  int _757;
  float _806;
  int _807;
  int _808;
  int _967;
  int _1487;
  float _1590;
  float _1591;
  half _1592;
  half _1593;
  half _1594;
  float _1646;
  float _1647;
  float _1648;
  float _1756;
  int _1793;
  float _1799;
  float _1812;
  float _1825;
  float _1835;
  float _1836;
  float _1837;
  // RenoDX: Forward declarations for light direction
  float _1731;
  float _1735;
  float _1739;
  float _1846;
  float _1847;
  float _1848;
  int _1991;
  float _1992;
  float _1993;
  float _1994;
  float _1995;
  float _1996;
  int _1997;
  float _1998;
  float _1999;
  bool _2062;
  int _2069;
  float _2088;
  int _2103;
  float _2104;
  float _2126;
  float _2127;
  float _2128;
  float _2129;
  float _2130;
  float _2134;
  int _2261;
  float _2262;
  float _2263;
  float _2264;
  float _2265;
  float _2266;
  int _2267;
  float _2268;
  float _2269;
  bool _2332;
  int _2339;
  float _2358;
  int _2373;
  float _2374;
  float _2396;
  float _2397;
  float _2398;
  float _2399;
  float _2400;
  float _2404;
  int _2414;
  float _2415;
  float _2416;
  float _2417;
  float _2418;
  float _2419;
  float _2480;
  float _2482;
  float _2505;
  float _2578;
  float _2581;
  float _2585;
  float _2600;
  float _2601;
  float _2602;
  float _2603;
  if (((_73 < 1.0000000116860974e-07f)) || (_101)) {
    float _104 = select(_101, 0.0f, 1.0f);
    _2600 = _104;
    _2601 = _104;
    _2602 = _104;
    _2603 = _104;
  } else {
    float _108 = max(1.0000000116860974e-07f, _73);
    float _109 = _nearFarProj.x / _108;
    float _145 = mad((_invViewProjRelative[3].z), _108, mad((_invViewProjRelative[3].y), _66, ((_invViewProjRelative[3].x) * _63))) + (_invViewProjRelative[3].w);
    float _146 = (mad((_invViewProjRelative[0].z), _108, mad((_invViewProjRelative[0].y), _66, ((_invViewProjRelative[0].x) * _63))) + (_invViewProjRelative[0].w)) / _145;
    float _147 = (mad((_invViewProjRelative[1].z), _108, mad((_invViewProjRelative[1].y), _66, ((_invViewProjRelative[1].x) * _63))) + (_invViewProjRelative[1].w)) / _145;
    float _148 = (mad((_invViewProjRelative[2].z), _108, mad((_invViewProjRelative[2].y), _66, ((_invViewProjRelative[2].x) * _63))) + (_invViewProjRelative[2].w)) / _145;
    float _150 = rsqrt(dot(float3(_146, _147, _148), float3(_146, _147, _148)));
    _24[0] = 0.0f;
    _25[0] = 0.0f;
    _26[0] = 0.0f;
    _24[1] = 0.0f;
    _25[1] = 0.0f;
    _26[1] = 0.0f;
    bool _166 = ((_74 == 57)) || (((uint)(_74 + -53) < (uint)15));
    float _186 = mad((_terrainShadowProjRelativeTexScale[0].z), _148, mad((_terrainShadowProjRelativeTexScale[0].y), _147, ((_terrainShadowProjRelativeTexScale[0].x) * _146))) + (_terrainShadowProjRelativeTexScale[0].w);
    float _190 = mad((_terrainShadowProjRelativeTexScale[1].z), _148, mad((_terrainShadowProjRelativeTexScale[1].y), _147, ((_terrainShadowProjRelativeTexScale[1].x) * _146))) + (_terrainShadowProjRelativeTexScale[1].w);
    float _194 = mad((_terrainShadowProjRelativeTexScale[2].z), _148, mad((_terrainShadowProjRelativeTexScale[2].y), _147, ((_terrainShadowProjRelativeTexScale[2].x) * _146))) + (_terrainShadowProjRelativeTexScale[2].w);
    if (saturate(_186) == _186) {
      if (((_194 >= 9.999999747378752e-05f)) && ((((_194 <= 1.0f)) && ((saturate(_190) == _190))))) {
        float _205 = float((uint)(uint)(_frameNumber.x));
        float _216 = (frac(((_205 * 92.0f) + _54) * 0.0078125f) * 128.0f) + -64.34062194824219f;
        float _217 = (frac(((_205 * 71.0f) + _55) * 0.0078125f) * 128.0f) + -72.46562194824219f;
        float _222 = frac(dot(float3((_216 * _216), (_217 * _217), (_217 * _216)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
        int _258 = ((int)(((((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) + 1013904242u));
        int _266 = ((int)(((((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) + (uint)(-626627285)));
        uint _270 = ((uint)(_266 ^ (((uint)(((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) >> 5) + -939442524))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)));
        int _282 = ((int)(((((uint)((((int)((_270 << 4) + (uint)(-1383041155))) ^ ((int)(_270 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_270) >> 5)) + 2123724318u)))) + (((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_270 << 4) + (uint)(-1383041155))) ^ ((int)(_270 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_270) >> 5)) + 2123724318u)))) + (((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) + 2027808484u));
        int _290 = ((int)(((((uint)(_282 ^ (((uint)(((uint)((((int)((_270 << 4) + (uint)(-1383041155))) ^ ((int)(_270 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_270) >> 5)) + 2123724318u)))) + (((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _270) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)(_282 ^ (((uint)(((uint)((((int)((_270 << 4) + (uint)(-1383041155))) ^ ((int)(_270 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_270) >> 5)) + 2123724318u)))) + (((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _270) + 2027808484u));
        uint _294 = ((uint)(_290 ^ ((int)(((uint)((uint)(((uint)(_282 ^ (((uint)(((uint)((((int)((_270 << 4) + (uint)(-1383041155))) ^ ((int)(_270 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_270) >> 5)) + 2123724318u)))) + (((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _270) >> 5)) + 2123724318u)))) + (((uint)((((int)((_270 << 4) + (uint)(-1383041155))) ^ ((int)(_270 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_270) >> 5)) + 2123724318u)))) + (((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))));
        uint _302 = ((uint)((((int)((_294 << 4) + (uint)(-1556008596))) ^ ((int)(_294 + 387276957u))) ^ (((uint)(_294) >> 5) + -939442524))) + (((uint)(_282 ^ (((uint)(((uint)((((int)((_270 << 4) + (uint)(-1383041155))) ^ ((int)(_270 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_270) >> 5)) + 2123724318u)))) + (((uint)(_258 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _270);
        int _333 = (((int)(((((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294)) + 1401181199u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294)) >> 5) + -939442524);
        int _346 = ((int)(((((uint)((((int)((((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294))) + (uint)(-239350328)));
        uint _350 = ((uint)(_346 ^ (((uint)(((uint)((((int)((((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294))) >> 5) + -939442524))) + ((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302));
        if (((int)(_350) & 16777215) == 0) {
          int _365 = ((int)(((((uint)((((int)((_350 << 4) + (uint)(-1383041155))) ^ ((int)(_350 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_350) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_350 << 4) + (uint)(-1383041155))) ^ ((int)(_350 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_350) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294)))) + (uint)(-1879881855)));
          _371 = ((int)(((uint)(_365 ^ (((uint)(((uint)((((int)((_350 << 4) + (uint)(-1383041155))) ^ ((int)(_350 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_350) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_333) + (((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294) >> 5) + -939442524))) + _302) >> 5)) + 2123724318u)))) + (((uint)((((int)((_302 << 4) + (uint)(-1383041155))) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294)))) >> 5) + -939442524))) + _350));
        } else {
          _371 = (int)(_350);
        }
        uint _376 = uint(float((uint)((uint)(((int)(_371 * 48271)) & 16777215))) * 3.814637693722034e-06f);
        float _383 = frac((float((uint)_376) * 0.015625f) + (float((uint)((uint)((int)(uint(_222 * 51540816.0f)) & 65535))) * 1.52587890625e-05f));
        float _389 = (_383 * 2.0f) + -1.0f;
        float _390 = (float((uint)((uint)(reversebits(_376) ^ (int)(uint(_222 * 287478368.0f))))) * 4.656612873077393e-10f) + -1.0f;
        float _392 = rsqrt(dot(float2(_389, _390), float2(_389, _390)));
        float _399 = ((_383 * 0.0009765625f) + -0.00048828125f) * _392;
        float _401 = (_390 * _392) * 0.00048828125f;
        float _403 = (_399 * (_jitterOffset[0].x)) + _186;
        float _404 = (_401 * (_jitterOffset[0].y)) + _190;
        float _409 = frac((_403 * 1024.0f) + -0.5f);
        float4 _413 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_403, _404));
        float _418 = _194 + -0.004999999888241291f;
        float _423 = select((_413.w > _418), 1.0f, 0.0f);
        float _425 = select((_413.x > _418), 1.0f, 0.0f);
        float _432 = ((select((_413.z > _418), 1.0f, 0.0f) - _423) * _409) + _423;
        float _442 = ((_jitterOffset[1].x) * _399) + _186;
        float _443 = ((_jitterOffset[1].y) * _401) + _190;
        float _448 = frac((_442 * 1024.0f) + -0.5f);
        float4 _450 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_442, _443));
        float _459 = select((_450.w > _418), 1.0f, 0.0f);
        float _461 = select((_450.x > _418), 1.0f, 0.0f);
        float _468 = ((select((_450.z > _418), 1.0f, 0.0f) - _459) * _448) + _459;
        float _479 = ((_jitterOffset[2].x) * _399) + _186;
        float _480 = ((_jitterOffset[2].y) * _401) + _190;
        float _485 = frac((_479 * 1024.0f) + -0.5f);
        float4 _487 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_479, _480));
        float _496 = select((_487.w > _418), 1.0f, 0.0f);
        float _498 = select((_487.x > _418), 1.0f, 0.0f);
        float _505 = ((select((_487.z > _418), 1.0f, 0.0f) - _496) * _485) + _496;
        float _516 = ((_jitterOffset[3].x) * _399) + _186;
        float _517 = ((_jitterOffset[3].y) * _401) + _190;
        float _522 = frac((_516 * 1024.0f) + -0.5f);
        float4 _524 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_516, _517));
        float _533 = select((_524.w > _418), 1.0f, 0.0f);
        float _535 = select((_524.x > _418), 1.0f, 0.0f);
        float _542 = ((select((_524.z > _418), 1.0f, 0.0f) - _533) * _522) + _533;
        _550 = ((((saturate((((((select((_450.y > _418), 1.0f, 0.0f) - _461) * _448) + _461) - _468) * frac((_443 * 1024.0f) + -0.5f)) + _468) + saturate((((((select((_413.y > _418), 1.0f, 0.0f) - _425) * _409) + _425) - _432) * frac((_404 * 1024.0f) + -0.5f)) + _432)) + saturate((((((select((_487.y > _418), 1.0f, 0.0f) - _498) * _485) + _498) - _505) * frac((_480 * 1024.0f) + -0.5f)) + _505)) + saturate((((((select((_524.y > _418), 1.0f, 0.0f) - _535) * _522) + _535) - _542) * frac((_517 * 1024.0f) + -0.5f)) + _542)) * 0.25f);
      } else {
        _550 = 1.0f;
      }
    } else {
      _550 = 1.0f;
    }
    float _558 = sqrt(((_147 * _147) + (_146 * _146)) + (_148 * _148));
    float _578 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _148, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _147, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _146))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
    float _582 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _148, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _147, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _146))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
    float _586 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _148, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _147, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _146))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
    float _587 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
    float _588 = 1.0f - _587;
    if (!(((((!(_578 <= _588))) || ((!(_578 >= _587))))) || ((!(_582 <= _588))))) {
      if (((_558 < 128.0f)) && ((((_586 >= -1.0f)) && ((((_586 <= 1.0f)) && ((_582 >= _587))))))) {
        float _613 = max(0.0f, ((abs((_578 * 2.0f) + -1.0f) + -0.8999999761581421f) * 10.0f));
        float _614 = max(0.0f, ((abs((_582 * 2.0f) + -1.0f) + -0.8999999761581421f) * 10.0f));
        _24[1] = _578;
        _25[1] = _582;
        _26[1] = _586;
        _624 = select((_terrainNormalParams.y > 0.0f), 1.9999999494757503e-05f, 7.999999797903001e-05f);
        _625 = 1;
        _626 = sqrt((_614 * _614) + (_613 * _613));
      } else {
        _624 = 0.0f;
        _625 = 0;
        _626 = 0.0f;
      }
    } else {
      _624 = 0.0f;
      _625 = 0;
      _626 = 0.0f;
    }
    float _646 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _148, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _147, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _146))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
    float _650 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _148, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _147, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _146))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
    float _654 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _148, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _147, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _146))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
    if (!(((((!(_646 >= _587))) || ((!(_646 <= _588))))) || ((!(_650 <= _588))))) {
      if (((_558 < 128.0f)) && ((((_654 >= -1.0f)) && ((((_650 >= _587)) && ((_654 <= 1.0f))))))) {
        float _679 = max(0.0f, ((abs((_646 * 2.0f) + -1.0f) + -0.8999999761581421f) * 10.0f));
        float _680 = max(0.0f, ((abs((_650 * 2.0f) + -1.0f) + -0.8999999761581421f) * 10.0f));
        _24[0] = _646;
        _25[0] = _650;
        _26[0] = _654;
        _690 = select((_terrainNormalParams.y > 0.0f), 4.999999873689376e-06f, 1.9999999494757503e-05f);
        _691 = 1;
        _692 = 0;
        _693 = sqrt((_680 * _680) + (_679 * _679));
      } else {
        _690 = _624;
        _691 = _625;
        _692 = _625;
        _693 = _626;
      }
    } else {
      _690 = _624;
      _691 = _625;
      _692 = _625;
      _693 = _626;
    }
    bool _694 = (_691 == 0);
    [branch]
    if (_694) {
      float _702 = _viewPos.x + _146;
      float _703 = _viewPos.y + _147;
      float _704 = _viewPos.z + _148;
      float _709 = _702 - (_staticShadowPosition[1].x);
      float _710 = _703 - (_staticShadowPosition[1].y);
      float _711 = _704 - (_staticShadowPosition[1].z);
      float _731 = mad((_shadowProjRelativeTexScale[1][0].z), _711, mad((_shadowProjRelativeTexScale[1][0].y), _710, ((_shadowProjRelativeTexScale[1][0].x) * _709))) + (_shadowProjRelativeTexScale[1][0].w);
      float _735 = mad((_shadowProjRelativeTexScale[1][1].z), _711, mad((_shadowProjRelativeTexScale[1][1].y), _710, ((_shadowProjRelativeTexScale[1][1].x) * _709))) + (_shadowProjRelativeTexScale[1][1].w);
      float _739 = mad((_shadowProjRelativeTexScale[1][2].z), _711, mad((_shadowProjRelativeTexScale[1][2].y), _710, ((_shadowProjRelativeTexScale[1][2].x) * _709))) + (_shadowProjRelativeTexScale[1][2].w);
      float _740 = 2.0f / _shadowSizeAndInvSize.y;
      float _741 = 1.0f - _740;
      if (!(((((!(_731 <= _741))) || ((!(_731 >= _740))))) || ((!(_735 <= _741))))) {
        if (((_739 >= 9.999999747378752e-05f)) && ((((_739 <= 1.0f)) && ((_735 >= _740))))) {
          _24[1] = _731;
          _25[1] = _735;
          _26[1] = _739;
          _755 = 0.00019999999494757503f;
          _756 = 1;
          _757 = 1;
        } else {
          _755 = _690;
          _756 = 0;
          _757 = _692;
        }
      } else {
        _755 = _690;
        _756 = 0;
        _757 = _692;
      }
      float _762 = _702 - (_staticShadowPosition[0].x);
      float _763 = _703 - (_staticShadowPosition[0].y);
      float _764 = _704 - (_staticShadowPosition[0].z);
      float _784 = mad((_shadowProjRelativeTexScale[0][0].z), _764, mad((_shadowProjRelativeTexScale[0][0].y), _763, ((_shadowProjRelativeTexScale[0][0].x) * _762))) + (_shadowProjRelativeTexScale[0][0].w);
      float _788 = mad((_shadowProjRelativeTexScale[0][1].z), _764, mad((_shadowProjRelativeTexScale[0][1].y), _763, ((_shadowProjRelativeTexScale[0][1].x) * _762))) + (_shadowProjRelativeTexScale[0][1].w);
      float _792 = mad((_shadowProjRelativeTexScale[0][2].z), _764, mad((_shadowProjRelativeTexScale[0][2].y), _763, ((_shadowProjRelativeTexScale[0][2].x) * _762))) + (_shadowProjRelativeTexScale[0][2].w);
      if (!(((((!(_784 >= _740))) || ((!(_784 <= _741))))) || ((!(_788 <= _741))))) {
        if (((_792 >= 9.999999747378752e-05f)) && ((((_788 >= _740)) && ((_792 <= 1.0f))))) {
          _24[0] = _784;
          _25[0] = _788;
          _26[0] = _792;
          _806 = 0.00019999999494757503f;
          _807 = 1;
          _808 = 0;
        } else {
          _806 = _755;
          _807 = _756;
          _808 = _757;
        }
      } else {
        _806 = _755;
        _807 = _756;
        _808 = _757;
      }
    } else {
      _806 = _690;
      _807 = 1;
      _808 = _692;
    }
    int _844 = ((int)(((((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) + 1013904242u));
    int _852 = ((int)(((((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) + (uint)(-626627285)));
    uint _856 = ((uint)(_852 ^ (((uint)(((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) >> 5) + -939442524))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)));
    int _868 = ((int)(((((uint)((((int)((_856 << 4) + (uint)(-1383041155))) ^ ((int)(_856 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_856) >> 5)) + 2123724318u)))) + (((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_856 << 4) + (uint)(-1383041155))) ^ ((int)(_856 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_856) >> 5)) + 2123724318u)))) + (((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) + 2027808484u));
    int _876 = ((int)(((((uint)(_868 ^ (((uint)(((uint)((((int)((_856 << 4) + (uint)(-1383041155))) ^ ((int)(_856 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_856) >> 5)) + 2123724318u)))) + (((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _856) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)(_868 ^ (((uint)(((uint)((((int)((_856 << 4) + (uint)(-1383041155))) ^ ((int)(_856 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_856) >> 5)) + 2123724318u)))) + (((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _856) + 2027808484u));
    uint _880 = ((uint)(_876 ^ ((int)(((uint)((uint)(((uint)(_868 ^ (((uint)(((uint)((((int)((_856 << 4) + (uint)(-1383041155))) ^ ((int)(_856 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_856) >> 5)) + 2123724318u)))) + (((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _856) >> 5)) + 2123724318u)))) + (((uint)((((int)((_856 << 4) + (uint)(-1383041155))) ^ ((int)(_856 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_856) >> 5)) + 2123724318u)))) + (((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))));
    uint _888 = ((uint)((((int)((_880 << 4) + (uint)(-1556008596))) ^ ((int)(_880 + 387276957u))) ^ (((uint)(_880) >> 5) + -939442524))) + (((uint)(_868 ^ (((uint)(((uint)((((int)((_856 << 4) + (uint)(-1383041155))) ^ ((int)(_856 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_856) >> 5)) + 2123724318u)))) + (((uint)(_844 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _856);
    int _919 = (((int)(((((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)) + 1401181199u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)) >> 5) + -939442524);
    int _932 = ((int)(((((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880))) + (uint)(-239350328)));
    uint _936 = ((uint)(_932 ^ (((uint)(((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880))) >> 5) + -939442524))) + ((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888));
    bool _946 = (((int)(_936) & 16777215) == 0);
    [branch]
    if (_694) {
      float _1474 = _24[_808];
      float _1475 = _25[_808];
      float _1476 = _26[_808];
      if (_946) {
        int _1481 = ((int)(((((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) + (uint)(-1879881855)));
        _1487 = ((int)(((uint)(_1481 ^ (((uint)(((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) >> 5) + -939442524))) + _936));
      } else {
        _1487 = (int)(_936);
      }
      float _1488 = _shadowSizeAndInvSize.z * 2.0f;
      float _1489 = _shadowSizeAndInvSize.w * 2.0f;
      float _1496 = _shadowSizeAndInvSize.z * 2.384185791015625e-07f;
      float _1498 = _shadowSizeAndInvSize.w * 2.384185791015625e-07f;
      float _1502 = ((float((uint)((uint)(((int)(_1487 * 48271)) & 16777215))) * _1496) - _1488) + _1474;
      float _1503 = ((float((uint)((uint)(((int)(_1487 * -1964877855)) & 16777215))) * _1498) - _1489) + _1475;
      float _1504 = float((uint)(uint)(_808));
      float4 _1507 = __3__36__0__0__g_shadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1502, _1503, _1504), 0.0f);
      float _1511 = _1476 - _806;
      float4 _1513 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1502, _1503, _1504), _1511);
      float _1527 = ((float((uint)((uint)(((int)(_1487 * -856141137)) & 16777215))) * _1496) - _1488) + _1474;
      float _1528 = ((float((uint)((uint)(((int)(_1487 * -613502015)) & 16777215))) * _1498) - _1489) + _1475;
      float4 _1529 = __3__36__0__0__g_shadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1527, _1528, _1504), 0.0f);
      float4 _1533 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1527, _1528, _1504), _1511);
      float _1549 = ((float((uint)((uint)(((int)(_1487 * -556260145)) & 16777215))) * _1496) - _1488) + _1474;
      float _1550 = ((float((uint)((uint)(((int)(_1487 * 902075297)) & 16777215))) * _1498) - _1489) + _1475;
      float4 _1551 = __3__36__0__0__g_shadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1549, _1550, _1504), 0.0f);
      float4 _1555 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1549, _1550, _1504), _1511);
      float _1571 = ((float((uint)((uint)(((int)(_1487 * 1698214639)) & 16777215))) * _1496) - _1488) + _1474;
      float _1572 = ((float((uint)((uint)(((int)(_1487 * 773027713)) & 16777215))) * _1498) - _1489) + _1475;
      float4 _1573 = __3__36__0__0__g_shadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1571, _1572, _1504), 0.0f);
      float4 _1577 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1571, _1572, _1504), _1511);
      float _1583 = (((saturate(1.0f - _1533.x) + saturate(1.0f - _1513.x)) + saturate(1.0f - _1555.x)) + saturate(1.0f - _1577.x)) * 0.25f;
      float _1584 = (((max(0.0f, (_1476 - _1529.x)) + max(0.0f, (_1476 - _1507.x))) + max(0.0f, (_1476 - _1551.x))) + max(0.0f, (_1476 - _1573.x))) * 0.25f;
      _1590 = saturate(_1583 * _1583);
      _1591 = saturate(_1584 * _1584);
      _1592 = 1.0h;
      _1593 = 1.0h;
      _1594 = 1.0h;
    } else {
      float _950 = _24[_808];
      float _951 = _25[_808];
      float _952 = _26[_808];
      float _954 = select((_808 == 0), 2.5f, 0.625f);
      if (_946) {
        int _961 = ((int)(((((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) + (uint)(-1879881855)));
        _967 = ((int)(((uint)(_961 ^ (((uint)(((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) >> 5) + -939442524))) + _936));
      } else {
        _967 = (int)(_936);
      }
      float _968 = select(_166, (_954 * 0.75f), _954) * 0.6600000262260437f;
      float _969 = _968 * _dynmaicShadowSizeAndInvSize.z;
      float _970 = _968 * _dynmaicShadowSizeAndInvSize.w;
      float _977 = _969 * 1.1920928955078125e-07f;
      float _979 = _970 * 1.1920928955078125e-07f;
      float _983 = ((float((uint)((uint)(((int)(_967 * 48271)) & 16777215))) * _977) - _969) + _950;
      float _984 = ((float((uint)((uint)(((int)(_967 * -1964877855)) & 16777215))) * _979) - _970) + _951;
      float _985 = float((uint)(uint)(_808));
      float4 _988 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_983, _984, _985), 0.0f);
      float _992 = _952 - _806;
      float4 _994 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_983, _984, _985), _992);
      half4 _999 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_983, _984, _985), 0.0f);
      float _1013 = ((float((uint)((uint)(((int)(_967 * -856141137)) & 16777215))) * _977) - _969) + _950;
      float _1014 = ((float((uint)((uint)(((int)(_967 * -613502015)) & 16777215))) * _979) - _970) + _951;
      float4 _1015 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1013, _1014, _985), 0.0f);
      float4 _1019 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1013, _1014, _985), _992);
      half4 _1023 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1013, _1014, _985), 0.0f);
      float _1039 = ((float((uint)((uint)(((int)(_967 * -556260145)) & 16777215))) * _977) - _969) + _950;
      float _1040 = ((float((uint)((uint)(((int)(_967 * 902075297)) & 16777215))) * _979) - _970) + _951;
      float4 _1041 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1039, _1040, _985), 0.0f);
      float4 _1045 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1039, _1040, _985), _992);
      half4 _1049 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1039, _1040, _985), 0.0f);
      float _1065 = ((float((uint)((uint)(((int)(_967 * 1698214639)) & 16777215))) * _977) - _969) + _950;
      float _1066 = ((float((uint)((uint)(((int)(_967 * 773027713)) & 16777215))) * _979) - _970) + _951;
      float4 _1067 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1065, _1066, _985), 0.0f);
      float4 _1071 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1065, _1066, _985), _992);
      half4 _1075 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1065, _1066, _985), 0.0f);
      float _1091 = ((float((uint)((uint)(((int)(_967 * 144866575)) & 16777215))) * _977) - _969) + _950;
      float _1092 = ((float((uint)((uint)(((int)(_967 * 647683937)) & 16777215))) * _979) - _970) + _951;
      float4 _1093 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1091, _1092, _985), 0.0f);
      float4 _1097 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1091, _1092, _985), _992);
      half4 _1101 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1091, _1092, _985), 0.0f);
      float _1117 = ((float((uint)((uint)(((int)(_967 * 1284375343)) & 16777215))) * _977) - _969) + _950;
      float _1118 = ((float((uint)((uint)(((int)(_967 * 229264193)) & 16777215))) * _979) - _970) + _951;
      float4 _1119 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1117, _1118, _985), 0.0f);
      float4 _1123 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1117, _1118, _985), _992);
      half4 _1127 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1117, _1118, _985), 0.0f);
      float _1143 = ((float((uint)((uint)(((int)(_967 * -1318861489)) & 16777215))) * _977) - _969) + _950;
      float _1144 = ((float((uint)((uint)(((int)(_967 * 1537293089)) & 16777215))) * _979) - _970) + _951;
      float4 _1145 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1143, _1144, _985), 0.0f);
      float4 _1149 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1143, _1144, _985), _992);
      half4 _1153 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1143, _1144, _985), 0.0f);
      float _1169 = ((float((uint)((uint)(((int)(_967 * -1770241169)) & 16777215))) * _977) - _969) + _950;
      float _1170 = ((float((uint)((uint)(((int)(_967 * 1357852417)) & 16777215))) * _979) - _970) + _951;
      float4 _1171 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1169, _1170, _985), 0.0f);
      float4 _1175 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1169, _1170, _985), _992);
      half4 _1179 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1169, _1170, _985), 0.0f);
      float _1195 = ((float((uint)((uint)(((int)(_967 * -601883249)) & 16777215))) * _977) - _969) + _950;
      float _1196 = ((float((uint)((uint)(((int)(_967 * 1947444961)) & 16777215))) * _979) - _970) + _951;
      float4 _1197 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1195, _1196, _985), 0.0f);
      float4 _1201 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1195, _1196, _985), _992);
      half4 _1205 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1195, _1196, _985), 0.0f);
      float _1221 = ((float((uint)((uint)(((int)(_967 * 1166504879)) & 16777215))) * _977) - _969) + _950;
      float _1222 = ((float((uint)((uint)(((int)(_967 * 1335763649)) & 16777215))) * _979) - _970) + _951;
      float4 _1223 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1221, _1222, _985), 0.0f);
      float4 _1227 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1221, _1222, _985), _992);
      half4 _1231 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1221, _1222, _985), 0.0f);
      float _1247 = ((float((uint)((uint)(((int)(_967 * -1696913969)) & 16777215))) * _977) - _969) + _950;
      float _1248 = ((float((uint)((uint)(((int)(_967 * 1882071713)) & 16777215))) * _979) - _970) + _951;
      float4 _1249 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1247, _1248, _985), 0.0f);
      float4 _1253 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1247, _1248, _985), _992);
      half4 _1257 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1247, _1248, _985), 0.0f);
      float _1273 = ((float((uint)((uint)(((int)(_967 * -1959554065)) & 16777215))) * _977) - _969) + _950;
      float _1274 = ((float((uint)((uint)(((int)(_967 * -1569511807)) & 16777215))) * _979) - _970) + _951;
      float4 _1275 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1273, _1274, _985), 0.0f);
      float4 _1279 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1273, _1274, _985), _992);
      half4 _1283 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1273, _1274, _985), 0.0f);
      float _1299 = ((float((uint)((uint)(((int)(_967 * 1318665743)) & 16777215))) * _977) - _969) + _950;
      float _1300 = ((float((uint)((uint)(((int)(_967 * 1898753633)) & 16777215))) * _979) - _970) + _951;
      float4 _1301 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1299, _1300, _985), 0.0f);
      float4 _1305 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1299, _1300, _985), _992);
      half4 _1309 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1299, _1300, _985), 0.0f);
      float _1325 = ((float((uint)((uint)(((int)(_967 * 134521903)) & 16777215))) * _977) - _969) + _950;
      float _1326 = ((float((uint)((uint)(((int)(_967 * -483771839)) & 16777215))) * _979) - _970) + _951;
      float4 _1327 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1325, _1326, _985), 0.0f);
      float4 _1331 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1325, _1326, _985), _992);
      half4 _1335 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1325, _1326, _985), 0.0f);
      float _1351 = ((float((uint)((uint)(((int)(_967 * -413252017)) & 16777215))) * _977) - _969) + _950;
      float _1352 = ((float((uint)((uint)(((int)(_967 * 2034977313)) & 16777215))) * _979) - _970) + _951;
      float4 _1353 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1351, _1352, _985), 0.0f);
      float4 _1357 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1351, _1352, _985), _992);
      half4 _1361 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1351, _1352, _985), 0.0f);
      float _1377 = ((float((uint)((uint)(((int)(_967 * 192849007)) & 16777215))) * _977) - _969) + _950;
      float _1378 = ((float((uint)((uint)(((int)(_967 * 1820286465)) & 16777215))) * _979) - _970) + _951;
      float4 _1379 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1377, _1378, _985), 0.0f);
      float4 _1383 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1377, _1378, _985), _992);
      half4 _1387 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1377, _1378, _985), 0.0f);
      float _1393 = (((((((((((((((saturate(1.0f - _1019.x) + saturate(1.0f - _994.x)) + saturate(1.0f - _1045.x)) + saturate(1.0f - _1071.x)) + saturate(1.0f - _1097.x)) + saturate(1.0f - _1123.x)) + saturate(1.0f - _1149.x)) + saturate(1.0f - _1175.x)) + saturate(1.0f - _1201.x)) + saturate(1.0f - _1227.x)) + saturate(1.0f - _1253.x)) + saturate(1.0f - _1279.x)) + saturate(1.0f - _1305.x)) + saturate(1.0f - _1331.x)) + saturate(1.0f - _1357.x)) + saturate(1.0f - _1383.x)) * 0.0625f;
      float _1394 = (((((((((((((((max(0.0f, (_952 - _1015.x)) + max(0.0f, (_952 - _988.x))) + max(0.0f, (_952 - _1041.x))) + max(0.0f, (_952 - _1067.x))) + max(0.0f, (_952 - _1093.x))) + max(0.0f, (_952 - _1119.x))) + max(0.0f, (_952 - _1145.x))) + max(0.0f, (_952 - _1171.x))) + max(0.0f, (_952 - _1197.x))) + max(0.0f, (_952 - _1223.x))) + max(0.0f, (_952 - _1249.x))) + max(0.0f, (_952 - _1275.x))) + max(0.0f, (_952 - _1301.x))) + max(0.0f, (_952 - _1327.x))) + max(0.0f, (_952 - _1353.x))) + max(0.0f, (_952 - _1379.x))) * 0.0625f;
      half _1449 = half(float(((((((((((((((_1023.x + _999.x) + _1049.x) + _1075.x) + _1101.x) + _1127.x) + _1153.x) + _1179.x) + _1205.x) + _1231.x) + _1257.x) + _1283.x) + _1309.x) + _1335.x) + _1361.x) + (_1387.x * 2.0h)) * 0.05882352963089943f);
      half _1450 = half(float(((((((((((((((_1023.y + _999.y) + _1049.y) + _1075.y) + _1101.y) + _1127.y) + _1153.y) + _1179.y) + _1205.y) + _1231.y) + _1257.y) + _1283.y) + _1309.y) + _1335.y) + _1361.y) + (_1387.y * 2.0h)) * 0.05882352963089943f);
      half _1451 = half(float(((((((((((((((_1023.z + _999.z) + _1049.z) + _1075.z) + _1101.z) + _1127.z) + _1153.z) + _1179.z) + _1205.z) + _1231.z) + _1257.z) + _1283.z) + _1309.z) + _1335.z) + _1361.z) + (_1387.z * 2.0h)) * 0.05882352963089943f);
      if (_808 == 1) {
        float _1454 = float(_1449);
        float _1455 = float(_1450);
        float _1456 = float(_1451);
        float _1457 = -0.0f - _693;
        _1590 = _1393;
        _1591 = _1394;
        _1592 = half((_1454 + _693) + (_1454 * _1457));
        _1593 = half((_1455 + _693) + (_1455 * _1457));
        _1594 = half((_1456 + _693) + (_1456 * _1457));
      } else {
        _1590 = _1393;
        _1591 = _1394;
        _1592 = _1449;
        _1593 = _1450;
        _1594 = _1451;
      }
    }
    bool _1595 = (_807 != 0);
    float _1597 = min(_550, select(_1595, _1590, 1.0f));
    float _1601 = select((_691 != 0), select(_1595, (_1591 * 400.0f), 4e+06f), 1.0f);
    float _1616 = (_1597 - (_shadowAOParams.x * _1597)) + _shadowAOParams.x;
    [branch]
    if (_1616 > 0.0f) {
      int _1626 = _70 & 126;
      bool _1628 = (_74 == 66);
      bool _1629 = ((_1626 == 64)) || (_1628);
      float _1630 = select(_1629, 2.0f, 4.0f);
      if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
        _1646 = _sunDirection.x;
        _1647 = _sunDirection.y;
        _1648 = _sunDirection.z;
      } else {
        _1646 = _moonDirection.x;
        _1647 = _moonDirection.y;
        _1648 = _moonDirection.z;
      }
      int _1649 = ((int)(((uint)(((((int)((uint)(_40) << 2)) & 262140) | ((int)(SV_GroupID.x) & 3)) << 3)) + SV_GroupThreadID.x)) & 3;
      int _1653 = ((int)(((uint)(((((uint)((uint)(_40)) >> 16) << 2) | (((uint)(SV_GroupID.x) >> 2) & 3)) << 3)) + SV_GroupThreadID.y)) & 3;
      float _1670 = float((uint)(uint)(_frameNumber.x));
      float _1681 = (frac(((_1670 * 92.0f) + _54) * 0.0078125f) * 128.0f) + -64.34062194824219f;
      float _1682 = (frac(((_1670 * 71.0f) + _55) * 0.0078125f) * 128.0f) + -72.46562194824219f;
      float _1687 = frac(dot(float3((_1681 * _1681), (_1682 * _1682), (_1682 * _1681)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
      float _1703 = frac((float((uint)((uint)((int)(uint(_1687 * 51540816.0f)) & 65535))) * 1.52587890625e-05f) + (float((uint)((uint)((((int)(((uint)((((int)(((_frameNumber.x * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)))) << 2)) & -858993460) | (((uint)((_frameNumber.x * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)))) >> 2) & 858993459))) << 1)) & 10) | (((uint)((uint)((((int)(((_frameNumber.x * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)))) << 2)) & -858993460) | (((uint)((_frameNumber.x * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)))) >> 2) & 858993459))) >> 1) & 21)))) * 0.03125f)) * 6.2831854820251465f;
      float _1707 = (((1.0f - _shadowAOParams.z) * 2.3283064365386963e-10f) * float((uint)((uint)(reversebits((float)((((int)(((uint)((((int)(((_frameNumber.x * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)))) << 2)) & -858993460) | (((uint)((_frameNumber.x * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)))) >> 2) & 858993459))) << 1)) & 10) | (((uint)((uint)((((int)(((_frameNumber.x * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)))) << 2)) & -858993460) | (((uint)((_frameNumber.x * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)))) >> 2) & 858993459))) >> 1) & 21))) ^ (int)(uint(_1687 * 287478368.0f)))))) + _shadowAOParams.z;
      float _1710 = sqrt(1.0f - (_1707 * _1707));
      float _1713 = cos(_1703) * _1710;
      float _1714 = sin(_1703) * _1710;
      float _1716 = select((_1648 >= 0.0f), 1.0f, -1.0f);
      float _1719 = -0.0f - (1.0f / (_1716 + _1648));
      float _1720 = _1647 * _1719;
      float _1721 = _1720 * _1646;
      float _1722 = _1716 * _1646;
      _1731 = mad(_1707, _1646, mad(_1714, _1721, ((((_1722 * _1646) * _1719) + 1.0f) * _1713)));
      _1735 = mad(_1707, _1647, mad(_1714, (_1716 + (_1720 * _1647)), ((_1713 * _1716) * _1721)));
      _1739 = mad(_1707, _1648, mad(_1714, (-0.0f - _1647), (-0.0f - (_1722 * _1713))));
      float _1742 = min(0.5f, ((_109 * 0.0024999999441206455f) + 0.25f));
      float _1748 = ((abs(_1647) * (select(_1629, 12.0f, 2.0f) - _1630)) + _1630) * select(_166, 0.009999999776482582f, 0.10000000149011612f);
      if (!_166) {
        _1756 = max((_109 * select(((uint)(_74 + -11) < (uint)9), 0.00800000037997961f, 0.029999999329447746f)), _1748);
      } else {
        _1756 = _1748;
      }
      float _1762 = saturate(((_109 * 0.009999999776482582f) * (1.0f - saturate(dot(float3(_97, _98, _99), float3((-0.0f - (_146 * _150)), (-0.0f - (_147 * _150)), (-0.0f - (_148 * _150))))))) + 0.009999999776482582f);
      bool _1769 = (_terrainNormalParams.z > 0.0f);
      if (_1769) {
        float _1773 = float((uint)((uint)(((int)(_frameNumber.x * 73)) & 255)));
        _1799 = frac(frac(dot(float2(((_1773 * 32.665000915527344f) + _54), ((_1773 * 11.8149995803833f) + _55)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
      } else {
        if (_946) {
          int _1787 = ((int)(((((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) + (uint)(-1879881855)));
          _1793 = ((int)(((uint)(_1787 ^ (((uint)(((uint)((((int)((_936 << 4) + (uint)(-1383041155))) ^ ((int)(_936 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_919) + (((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880) >> 5) + -939442524))) + _888) >> 5)) + 2123724318u)))) + (((uint)((((int)((_888 << 4) + (uint)(-1383041155))) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880)))) >> 5) + -939442524))) + _936));
        } else {
          _1793 = (int)(_936);
        }
        _1799 = (float((uint)((uint)(((int)(_1793 * 48271)) & 16777215))) * 5.960464477539063e-08f);
      }
      if ((_1628) || ((((_74 != 15)) && (((uint)(_74 + -12) < (uint)7))))) {
        _1812 = (_1799 * 10.0f);
      } else {
        if (_74 == 15) {
          _1812 = ((10.0f - (saturate(_109 * 0.0010000000474974513f) * 9.0f)) * _1799);
        } else {
          _1812 = _1799;
        }
      }
      if (_1626 == 12) {
        _1825 = (0.10000000149011612f - (abs(_1735) * 0.05000000074505806f));
      } else {
        if ((uint)_74 > (uint)15) {
          if ((((uint)_74 < (uint)20)) || ((_74 == 107))) {
            _1825 = (0.10000000149011612f - (abs(_1735) * 0.05000000074505806f));
          } else {
            _1825 = 0.0f;
          }
        } else {
          _1825 = 0.0f;
        }
      }
      if (!_166) {
        float _1827 = _1825 * _150;
        _1835 = (_146 - (_1827 * _146));
        _1836 = (_147 - (_1827 * _147));
        _1837 = (_148 - (_1827 * _148));
      } else {
        _1835 = _146;
        _1836 = _147;
        _1837 = _148;
      }
      if (!_1769) {
        float _1841 = saturate(_109 * 0.0625f) * 0.05000000074505806f;
        _1846 = (_1841 * _97);
        _1847 = (_1841 * _98);
        _1848 = (_1841 * _99);
      } else {
        _1846 = 0.0f;
        _1847 = 0.0f;
        _1848 = 0.0f;
      }
      float _1849 = _1846 + _1835;
      float _1850 = _1847 + _1836;
      float _1851 = _1848 + _1837;
      float _1864 = mad((_viewRelative[2].z), _1851, mad((_viewRelative[2].y), _1850, ((_viewRelative[2].x) * _1849))) + (_viewRelative[2].w);
      float _1867 = mad((_viewRelative[2].z), _1739, mad((_viewRelative[2].y), _1735, ((_viewRelative[2].x) * _1731)));
      bool _1870 = (((_1867 * _1756) + _1864) < _nearFarProj.x);
      if (_109 < 8.0f) {
        float _1874 = select(_1870, ((_nearFarProj.x - _1864) / _1867), _1756);
        float _1906 = mad((_viewProjRelative[2].z), _1851, mad((_viewProjRelative[2].y), _1850, ((_viewProjRelative[2].x) * _1849))) + (_viewProjRelative[2].w);
        float _1910 = mad((_viewProjRelative[3].z), _1851, mad((_viewProjRelative[3].y), _1850, ((_viewProjRelative[3].x) * _1849))) + (_viewProjRelative[3].w);
        float _1914 = (_1874 * _1731) + _1849;
        float _1915 = (_1874 * _1735) + _1850;
        float _1916 = (_1874 * _1739) + _1851;
        float _1932 = mad((_viewProjRelative[3].z), _1916, mad((_viewProjRelative[3].y), _1915, ((_viewProjRelative[3].x) * _1914))) + (_viewProjRelative[3].w);
        float _1933 = (mad((_viewProjRelative[0].z), _1851, mad((_viewProjRelative[0].y), _1850, ((_viewProjRelative[0].x) * _1849))) + (_viewProjRelative[0].w)) / _1910;
        float _1934 = (mad((_viewProjRelative[1].z), _1851, mad((_viewProjRelative[1].y), _1850, ((_viewProjRelative[1].x) * _1849))) + (_viewProjRelative[1].w)) / _1910;
        float _1935 = _1906 / _1910;
        float _1939 = ((mad((_viewProjRelative[0].z), _1916, mad((_viewProjRelative[0].y), _1915, ((_viewProjRelative[0].x) * _1914))) + (_viewProjRelative[0].w)) / _1932) - _1933;
        float _1940 = ((mad((_viewProjRelative[1].z), _1916, mad((_viewProjRelative[1].y), _1915, ((_viewProjRelative[1].x) * _1914))) + (_viewProjRelative[1].w)) / _1932) - _1934;
        float _1952 = max(0.125f, (1.0f / min(1.0f, (max(((_bufferSizeAndInvSize.x * 0.5f) * abs(_1939)), ((_bufferSizeAndInvSize.y * 0.5f) * abs(_1940))) * 0.125f))));
        float _1953 = _1952 * (((mad((_viewProjRelative[2].z), _1916, mad((_viewProjRelative[2].y), _1915, ((_viewProjRelative[2].x) * _1914))) + (_viewProjRelative[2].w)) / _1932) - _1935);
        float _1970 = (_1742 * 0.125f) * max(abs(_1953), (_1935 - ((mad((_proj[2].z), _109, 0.0f) + _1906) / (mad((_proj[3].z), _109, 0.0f) + _1910))));
        float _1972 = (_1939 * 0.0625f) * _1952;
        float _1974 = (_1940 * -0.0625f) * _1952;
        float _1975 = _1953 * 0.125f;
        float _1982 = max(_1812, (1.0f / max((abs(_1972) * _bufferSizeAndInvSize.x), (abs(_1974) * _bufferSizeAndInvSize.y))));
        float _1989 = 0.5f / _bufferSizeAndInvSize.x;
        _1991 = 0;
        _1992 = (((_1933 * 0.5f) + 0.5f) + (_1982 * _1972));
        _1993 = ((0.5f - (_1934 * 0.5f)) + (_1982 * _1974));
        _1994 = ((_1982 * _1975) + _1935);
        _1995 = _1812;
        _1996 = _1762;
        _1997 = 0;
        _1998 = 1.0f;
        _1999 = 0.0f;
        while(true) {
          uint _2008 = __3__36__0__0__g_depthStencil.Load(int3(int(min(max(_1992, _1989), (1.0f - _1989)) * _bufferSizeAndInvSize.x), int(_1993 * _bufferSizeAndInvSize.y), 0));
          int _2010 = (uint)((uint)(_2008.x)) >> 24;
          float _2013 = float((uint)((uint)(_2008.x & 16777215))) * 5.960465188081798e-08f;
          int _2014 = _2010 & 127;
          bool _2015 = (_1997 == 0);
          float _2016 = select(_2015, 1.0f, _1996);
          float _2020 = _nearFarProj.x / max(1.0000000116860974e-07f, _2013);
          float _2021 = _1994 - _2013;
          float _2024 = _2020 - (_nearFarProj.x / max(1.0000000116860974e-07f, _1994));
          bool _2027 = (abs(_2021 + _1970) < _1970);
          int _2028 = (int)(uint)((int)(_2027));
          if (_2027) {
            if (((_2014 == 7)) || ((((_2014 == 54)) || (((((_2010 & 126) == 66)) || (((((uint)(_2014 + -5) < (uint)2)) || ((((_2014 == 107)) || ((((_2014 == 26)) || (((((uint)(_2014 + -27) < (uint)2)) || ((((_2014 == 106)) || (((((_2010 & 125) == 105)) || ((((_2014 == 18)) || (((uint)(_2014 + -19) < (uint)2))))))))))))))))))))) {
              _2062 = true;
              _2069 = ((int)(uint)((int)(((_2024 < 0.0f)) && ((_2024 > select(_2062, -0.07999999821186066f, -1.0f))))));
            } else {
              if ((uint)(_2014 + -53) < (uint)14) {
                _2062 = (_2020 < 32.0f);
                _2069 = ((int)(uint)((int)(((_2024 < 0.0f)) && ((_2024 > select(_2062, -0.07999999821186066f, -1.0f))))));
              } else {
                _2069 = _2028;
              }
            }
          } else {
            _2069 = _2028;
          }
          if (!(_2069 == 0)) {
            if ((uint)_2014 > (uint)11) {
              if (!((uint)_2014 < (uint)18)) {
                if (!(((_2014 == 18)) || ((((_2014 == 107)) || (((uint)(_2014 + -19) < (uint)2)))))) {
                  if (!(_2014 == 66)) {
                    _2088 = 0.0f;
                  } else {
                    _2088 = 0.10000000149011612f;
                  }
                } else {
                  _2088 = 0.15000000596046448f;
                }
              } else {
                _2088 = 0.10000000149011612f;
              }
            } else {
              if (!(_2014 == 11)) {
                _2088 = 0.0f;
              } else {
                _2088 = 0.10000000149011612f;
              }
            }
            // RenoDX: Weather adaptive grass occluder thickness
            if (_2014 == 17) {
              float _grassWeather = saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY);
              _2088 = renodx::math::Select(CONTACT_SHADOW_QUALITY == 1.f, lerp(0.018f, 0.05f, _grassWeather), 0.09f);
            }
            float _2090 = saturate(_2020 * 0.015625f);
            float _2093 = (1.0f - _2090) + (_2090 * _2088);
            _2103 = _2014;
            _2104 = saturate((saturate(1.0f - ((_2093 * _2093) * _2088)) * (1.0f - _1999)) + _1999);
            // RenoDX: Weather adaptive grass shadow contribution
            if (CONTACT_SHADOW_QUALITY == 1.f && _2014 == 17) {
              float _grassContrib = lerp(0.3f, 0.65f, saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY));
              _2104 = lerp(_1999, _2104, _grassContrib);
            }
          } else {
            _2103 = _1991;
            _2104 = _1999;
          }
          [branch]
          if (_2104 > 0.949999988079071f) {
            if (!_2015) {
              _2134 = (saturate(_1998 / (_1998 - _2021)) - min(_1995, _2016));
            } else {
              _2134 = 0.0f;
            }
            _2414 = _2014;
            _2415 = _2104;
            _2416 = ((_2134 * _1972) + _1992);
            _2417 = ((_2134 * _1974) + _1993);
            _2418 = ((_2134 * _1975) + _1994);
            _2419 = _2013;
          } else {
            if ((uint)_1997 < (uint)7) {
              _2126 = ((_2016 * _1972) + _1992);
              _2127 = ((_2016 * _1974) + _1993);
              _2128 = ((_2016 * _1975) + _1994);
              _2129 = (_2016 + _1995);
              _2130 = min(abs(_1975), _2021);
            } else {
              _2126 = _1992;
              _2127 = _1993;
              _2128 = _1994;
              _2129 = _1995;
              _2130 = _1998;
            }
            if ((uint)(_1997 + 1) < (uint)8) {
              _1991 = _2103;
              _1992 = _2126;
              _1993 = _2127;
              _1994 = _2128;
              _1995 = _2129;
              _1996 = _2016;
              _1997 = (_1997 + 1);
              _1998 = _2130;
              _1999 = _2104;
              continue;
            } else {
              _2414 = _2103;
              _2415 = _2104;
              _2416 = _1992;
              _2417 = _1993;
              _2418 = _1994;
              _2419 = _2013;
            }
          }
          break;
        }
      } else {
        float _2144 = select(_1870, ((_nearFarProj.x - _1864) / _1867), _1756);
        float _2176 = mad((_viewProjRelative[2].z), _1851, mad((_viewProjRelative[2].y), _1850, ((_viewProjRelative[2].x) * _1849))) + (_viewProjRelative[2].w);
        float _2180 = mad((_viewProjRelative[3].z), _1851, mad((_viewProjRelative[3].y), _1850, ((_viewProjRelative[3].x) * _1849))) + (_viewProjRelative[3].w);
        float _2184 = (_2144 * _1731) + _1849;
        float _2185 = (_2144 * _1735) + _1850;
        float _2186 = (_2144 * _1739) + _1851;
        float _2202 = mad((_viewProjRelative[3].z), _2186, mad((_viewProjRelative[3].y), _2185, ((_viewProjRelative[3].x) * _2184))) + (_viewProjRelative[3].w);
        float _2203 = (mad((_viewProjRelative[0].z), _1851, mad((_viewProjRelative[0].y), _1850, ((_viewProjRelative[0].x) * _1849))) + (_viewProjRelative[0].w)) / _2180;
        float _2204 = (mad((_viewProjRelative[1].z), _1851, mad((_viewProjRelative[1].y), _1850, ((_viewProjRelative[1].x) * _1849))) + (_viewProjRelative[1].w)) / _2180;
        float _2205 = _2176 / _2180;
        float _2209 = ((mad((_viewProjRelative[0].z), _2186, mad((_viewProjRelative[0].y), _2185, ((_viewProjRelative[0].x) * _2184))) + (_viewProjRelative[0].w)) / _2202) - _2203;
        float _2210 = ((mad((_viewProjRelative[1].z), _2186, mad((_viewProjRelative[1].y), _2185, ((_viewProjRelative[1].x) * _2184))) + (_viewProjRelative[1].w)) / _2202) - _2204;
        float _2222 = max(0.125f, (1.0f / min(1.0f, (max(((_bufferSizeAndInvSize.x * 0.5f) * abs(_2209)), ((_bufferSizeAndInvSize.y * 0.5f) * abs(_2210))) * 0.125f))));
        float _2223 = _2222 * (((mad((_viewProjRelative[2].z), _2186, mad((_viewProjRelative[2].y), _2185, ((_viewProjRelative[2].x) * _2184))) + (_viewProjRelative[2].w)) / _2202) - _2205);
        float _2240 = (_1742 * 0.0625f) * max(abs(_2223), (_2205 - ((mad((_proj[2].z), _109, 0.0f) + _2176) / (mad((_proj[3].z), _109, 0.0f) + _2180))));
        float _2242 = (_2209 * 0.0625f) * _2222;
        float _2244 = (_2210 * -0.0625f) * _2222;
        float _2245 = _2223 * 0.125f;
        float _2252 = max(_1812, (1.0f / max((abs(_2242) * _bufferSizeAndInvSize.x), (abs(_2244) * _bufferSizeAndInvSize.y))));
        float _2259 = 0.5f / _bufferSizeAndInvSize.x;
        _2261 = 0;
        _2262 = _1762;
        _2263 = _1812;
        _2264 = (((_2203 * 0.5f) + 0.5f) + (_2252 * _2242));
        _2265 = ((0.5f - (_2204 * 0.5f)) + (_2252 * _2244));
        _2266 = ((_2252 * _2245) + _2205);
        _2267 = 0;
        _2268 = 1.0f;
        _2269 = 0.0f;
        while(true) {
          uint _2278 = __3__36__0__0__g_depthStencil.Load(int3(int(min(max(_2264, _2259), (1.0f - _2259)) * _bufferSizeAndInvSize.x), int(_2265 * _bufferSizeAndInvSize.y), 0));
          int _2280 = (uint)((uint)(_2278.x)) >> 24;
          float _2283 = float((uint)((uint)(_2278.x & 16777215))) * 5.960465188081798e-08f;
          int _2284 = _2280 & 127;
          bool _2285 = (_2261 == 0);
          float _2286 = select(_2285, 1.0f, _2262);
          float _2287 = _2266 - _2283;
          float _2291 = _nearFarProj.x / max(1.0000000116860974e-07f, _2283);
          float _2294 = _2291 - (_nearFarProj.x / max(1.0000000116860974e-07f, _2266));
          bool _2297 = (abs(_2287 + _2240) < _2240);
          int _2298 = (int)(uint)((int)(_2297));
          if (_2297) {
            if (((_2284 == 7)) || ((((_2284 == 54)) || (((((_2280 & 126) == 66)) || (((((uint)(_2284 + -5) < (uint)2)) || ((((_2284 == 107)) || ((((_2284 == 26)) || (((((uint)(_2284 + -27) < (uint)2)) || ((((_2284 == 106)) || (((((_2280 & 125) == 105)) || ((((_2284 == 18)) || (((uint)(_2284 + -19) < (uint)2))))))))))))))))))))) {
              _2332 = true;
              _2339 = ((int)(uint)((int)(((_2294 < 0.0f)) && ((_2294 > select(_2332, -0.07999999821186066f, -1.0f))))));
            } else {
              if ((uint)(_2284 + -53) < (uint)14) {
                _2332 = (_2291 < 32.0f);
                _2339 = ((int)(uint)((int)(((_2294 < 0.0f)) && ((_2294 > select(_2332, -0.07999999821186066f, -1.0f))))));
              } else {
                _2339 = _2298;
              }
            }
          } else {
            _2339 = _2298;
          }
          if (!(_2339 == 0)) {
            if ((uint)_2284 > (uint)11) {
              if (!((uint)_2284 < (uint)18)) {
                if (!(((_2284 == 18)) || ((((_2284 == 107)) || (((uint)(_2284 + -19) < (uint)2)))))) {
                  if (!(_2284 == 66)) {
                    _2358 = 0.0f;
                  } else {
                    _2358 = 0.10000000149011612f;
                  }
                } else {
                  _2358 = 0.15000000596046448f;
                }
              } else {
                _2358 = 0.10000000149011612f;
              }
            } else {
              if (!(_2284 == 11)) {
                _2358 = 0.0f;
              } else {
                _2358 = 0.10000000149011612f;
              }
            }
            // RenoDX: Weather adaptive grass occluder thickness
            if (_2284 == 17) {
              float _grassWeather2 = saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY);
              _2358 = renodx::math::Select(CONTACT_SHADOW_QUALITY == 1.f, lerp(0.018f, 0.05f, _grassWeather2), 0.09f);
            }
            float _2360 = saturate(_2291 * 0.015625f);
            float _2363 = (1.0f - _2360) + (_2360 * _2358);
            _2373 = _2284;
            _2374 = saturate((saturate(1.0f - ((_2363 * _2363) * _2358)) * (1.0f - _2269)) + _2269);
            // RenoDX: Weather adaptive grass shadow contribution
            if (CONTACT_SHADOW_QUALITY == 1.f && _2284 == 17) {
              float _grassContrib2 = lerp(0.3f, 0.65f, saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY));
              _2374 = lerp(_2269, _2374, _grassContrib2);
            }
          } else {
            _2373 = _2267;
            _2374 = _2269;
          }
          [branch]
          if (_2374 > 0.949999988079071f) {
            if (!_2285) {
              _2404 = (saturate(_2268 / (_2268 - _2287)) - min(_2263, _2286));
            } else {
              _2404 = 0.0f;
            }
            _2414 = _2284;
            _2415 = _2374;
            _2416 = ((_2404 * _2242) + _2264);
            _2417 = ((_2404 * _2244) + _2265);
            _2418 = ((_2404 * _2245) + _2266);
            _2419 = _2283;
          } else {
            if ((uint)_2261 < (uint)7) {
              _2396 = (_2263 + _2286);
              _2397 = (_2264 + (_2286 * _2242));
              _2398 = (_2265 + (_2286 * _2244));
              _2399 = (_2266 + (_2286 * _2245));
              _2400 = min(abs(_2245), _2287);
            } else {
              _2396 = _2263;
              _2397 = _2264;
              _2398 = _2265;
              _2399 = _2266;
              _2400 = _2268;
            }
            if ((uint)(_2261 + 1) < (uint)8) {
              _2261 = (_2261 + 1);
              _2262 = _2286;
              _2263 = _2396;
              _2264 = _2397;
              _2265 = _2398;
              _2266 = _2399;
              _2267 = _2373;
              _2268 = _2400;
              _2269 = _2374;
              continue;
            } else {
              _2414 = _2373;
              _2415 = _2374;
              _2416 = 0.0f;
              _2417 = 0.0f;
              _2418 = -1.0f;
              _2419 = 0.0f;
            }
          }
          break;
        }
      }
      bool _2423 = (_2415 > 0.0f);
      if (_2418 > 0.0f) {
        if ((_2423) || ((((((_2416 >= 0.0f)) && ((_2416 <= 1.0f)))) && ((((_2417 >= 0.0f)) && ((_2417 <= 1.0f))))))) {
          float _2437 = (_2416 * 2.0f) + -1.0f;
          float _2438 = 1.0f - (_2417 * 2.0f);
          float _2454 = mad((_invViewProjRelative[3].z), _2418, mad((_invViewProjRelative[3].y), _2438, (_2437 * (_invViewProjRelative[3].x)))) + (_invViewProjRelative[3].w);
          if (!(_2414 == 2)) {
            if (_2414 == 3) {
              _2480 = 0.0f;
              _2482 = _2480;
            } else {
              if (_2414 == 21) {
                if (!(_74 == 21)) {
                  _2480 = 0.0f;
                  _2482 = _2480;
                } else {
                  _2482 = 20.0f;
                }
              } else {
                bool _2473 = (_2414 == 22);
                if (!(((_74 == 22)) && (_2473))) {
                  _2480 = select(_2473, 0.0f, 1.0f);
                  _2482 = _2480;
                } else {
                  _2482 = 20.0f;
                }
              }
            }
          } else {
            if (!(_74 == 2)) {
              _2480 = 0.0f;
              _2482 = _2480;
            } else {
              _2482 = 20.0f;
            }
          }
          if (_2415 == 1.0f) {
            _2505 = saturate(((((_1756 * 0.9375f) - max(0.0f, dot(float3(_1731, _1735, _1739), float3((((mad((_invViewProjRelative[0].z), _2418, mad((_invViewProjRelative[0].y), _2438, (_2437 * (_invViewProjRelative[0].x)))) + (_invViewProjRelative[0].w)) / _2454) - _1849), (((mad((_invViewProjRelative[1].z), _2418, mad((_invViewProjRelative[1].y), _2438, (_2437 * (_invViewProjRelative[1].x)))) + (_invViewProjRelative[1].w)) / _2454) - _1850), (((mad((_invViewProjRelative[2].z), _2418, mad((_invViewProjRelative[2].y), _2438, (_2437 * (_invViewProjRelative[2].x)))) + (_invViewProjRelative[2].w)) / _2454) - _1851))))) * ((_109 * 0.015625f) + 1.5f)) / _1756) * 0.9375f);
          } else {
            _2505 = _2415;
          }
          float _2506 = _2505 * saturate(exp2(min(0.0f, (((_109 * 0.01899999938905239f) + 0.10000000149011612f) + (_2482 * ((_nearFarProj.x / max(1.0000000116860974e-07f, _2419)) - (_nearFarProj.x / max(1.0000000116860974e-07f, _2418)))))) * 1.4426950216293335f));
          int _2507 = _2414 & -2;
          if (!(_2507 == 6)) {
            bool __defer_2509_2519 = false;
            if ((((_74 == 33) && (_2414 == 33)) || (!(_74 == 33) && (((_74 == 55)) && ((_2414 == 55)))))) {
              _2581 = (_2506 * 0.009999999776482582f);
            } else {
              __defer_2509_2519 = true;
            }
            if (__defer_2509_2519) {
              if (!(((_2414 == 54)) || ((_2507 == 66))) || ((((_2414 == 54)) || ((_2507 == 66))) && (!(((_1626 == 66)) || ((_74 == 54)))))) {
                if (!_166) {
                  if ((uint)((int)((uint)(_2414) + (uint)(-53))) < (uint)15) {
                    _2578 = saturate(_109 * 0.03125f);
                  } else {
                    _2578 = 1.0f;
                  }
                  _2581 = (_2578 * _2506);
                } else {
                  _2581 = _2506;
                }
              } else {
                uint4 _2533 = __3__36__0__0__g_baseColor.Load(int3(int(_2416 * _bufferSizeAndInvSize.x), int(_2417 * _bufferSizeAndInvSize.y), 0));
                float _2539 = float((uint)((uint)(((uint)((uint)(_2533.x)) >> 8) & 255))) * 0.003921568859368563f;
                float _2542 = float((uint)((uint)(_2533.x & 255))) * 0.003921568859368563f;
                float _2546 = float((uint)((uint)(((uint)((uint)(_2533.y)) >> 8) & 255))) * 0.003921568859368563f;
                float _2547 = _2539 * _2539;
                float _2548 = _2542 * _2542;
                float _2549 = _2546 * _2546;
                _2581 = (saturate(1.0f - (dot(float3((((_2547 * 0.6131200194358826f) + (_2548 * 0.3395099937915802f)) + (_2549 * 0.047370001673698425f)), (((_2547 * 0.07020000368356705f) + (_2548 * 0.9163600206375122f)) + (_2549 * 0.013450000435113907f)), (((_2547 * 0.02061999961733818f) + (_2548 * 0.10958000272512436f)) + (_2549 * 0.8697999715805054f))), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.875f)) * _2506);
              }
            }
          } else {
            _2581 = (_2506 * 0.009999999776482582f);
          }
        } else {
          _2581 = 0.0f;
        }
      } else {
        if (_2423) {
          float _2437 = (_2416 * 2.0f) + -1.0f;
          float _2438 = 1.0f - (_2417 * 2.0f);
          float _2454 = mad((_invViewProjRelative[3].z), _2418, mad((_invViewProjRelative[3].y), _2438, (_2437 * (_invViewProjRelative[3].x)))) + (_invViewProjRelative[3].w);
          if (!(_2414 == 2)) {
            if (_2414 == 3) {
              _2480 = 0.0f;
              _2482 = _2480;
            } else {
              if (_2414 == 21) {
                if (!(_74 == 21)) {
                  _2480 = 0.0f;
                  _2482 = _2480;
                } else {
                  _2482 = 20.0f;
                }
              } else {
                bool _2473 = (_2414 == 22);
                if (!(((_74 == 22)) && (_2473))) {
                  _2480 = select(_2473, 0.0f, 1.0f);
                  _2482 = _2480;
                } else {
                  _2482 = 20.0f;
                }
              }
            }
          } else {
            if (!(_74 == 2)) {
              _2480 = 0.0f;
              _2482 = _2480;
            } else {
              _2482 = 20.0f;
            }
          }
          if (_2415 == 1.0f) {
            _2505 = saturate(((((_1756 * 0.9375f) - max(0.0f, dot(float3(_1731, _1735, _1739), float3((((mad((_invViewProjRelative[0].z), _2418, mad((_invViewProjRelative[0].y), _2438, (_2437 * (_invViewProjRelative[0].x)))) + (_invViewProjRelative[0].w)) / _2454) - _1849), (((mad((_invViewProjRelative[1].z), _2418, mad((_invViewProjRelative[1].y), _2438, (_2437 * (_invViewProjRelative[1].x)))) + (_invViewProjRelative[1].w)) / _2454) - _1850), (((mad((_invViewProjRelative[2].z), _2418, mad((_invViewProjRelative[2].y), _2438, (_2437 * (_invViewProjRelative[2].x)))) + (_invViewProjRelative[2].w)) / _2454) - _1851))))) * ((_109 * 0.015625f) + 1.5f)) / _1756) * 0.9375f);
          } else {
            _2505 = _2415;
          }
          float _2506 = _2505 * saturate(exp2(min(0.0f, (((_109 * 0.01899999938905239f) + 0.10000000149011612f) + (_2482 * ((_nearFarProj.x / max(1.0000000116860974e-07f, _2419)) - (_nearFarProj.x / max(1.0000000116860974e-07f, _2418)))))) * 1.4426950216293335f));
          int _2507 = _2414 & -2;
          if (!(_2507 == 6)) {
            bool __defer_2509_2519 = false;
            if ((((_74 == 33) && (_2414 == 33)) || (!(_74 == 33) && (((_74 == 55)) && ((_2414 == 55)))))) {
              _2581 = (_2506 * 0.009999999776482582f);
            } else {
              __defer_2509_2519 = true;
            }
            if (__defer_2509_2519) {
              if (!(((_2414 == 54)) || ((_2507 == 66))) || ((((_2414 == 54)) || ((_2507 == 66))) && (!(((_1626 == 66)) || ((_74 == 54)))))) {
                if (!_166) {
                  if ((uint)((int)((uint)(_2414) + (uint)(-53))) < (uint)15) {
                    _2578 = saturate(_109 * 0.03125f);
                  } else {
                    _2578 = 1.0f;
                  }
                  _2581 = (_2578 * _2506);
                } else {
                  _2581 = _2506;
                }
              } else {
                uint4 _2533 = __3__36__0__0__g_baseColor.Load(int3(int(_2416 * _bufferSizeAndInvSize.x), int(_2417 * _bufferSizeAndInvSize.y), 0));
                float _2539 = float((uint)((uint)(((uint)((uint)(_2533.x)) >> 8) & 255))) * 0.003921568859368563f;
                float _2542 = float((uint)((uint)(_2533.x & 255))) * 0.003921568859368563f;
                float _2546 = float((uint)((uint)(((uint)((uint)(_2533.y)) >> 8) & 255))) * 0.003921568859368563f;
                float _2547 = _2539 * _2539;
                float _2548 = _2542 * _2542;
                float _2549 = _2546 * _2546;
                _2581 = (saturate(1.0f - (dot(float3((((_2547 * 0.6131200194358826f) + (_2548 * 0.3395099937915802f)) + (_2549 * 0.047370001673698425f)), (((_2547 * 0.07020000368356705f) + (_2548 * 0.9163600206375122f)) + (_2549 * 0.013450000435113907f)), (((_2547 * 0.02061999961733818f) + (_2548 * 0.10958000272512436f)) + (_2549 * 0.8697999715805054f))), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.875f)) * _2506);
              }
            }
          } else {
            _2581 = (_2506 * 0.009999999776482582f);
          }
        } else {
          _2581 = 0.0f;
        }
      }
      _2585 = saturate(1.0f - _2581);
    } else {
      _2585 = 1.0f;
    }
    float _2586 = min(_1616, _2585);

    // ── Micro Detail Depth-Bias Shadows ───────────────────────────────
    #define MICRO_PIXEL_X_FLOAT   _54
    #define MICRO_PIXEL_Y_FLOAT   _55
    #define MICRO_LINEAR_DEPTH    _109
    #define MICRO_CONTACT_SHADOW  _2585
    #define MICRO_LIGHT_DIR_X     _1731
    #define MICRO_LIGHT_DIR_Y     _1735
    #define MICRO_LIGHT_DIR_Z     _1739
    #define MICRO_WORLD_POS_X     _1835
    #define MICRO_WORLD_POS_Y     _1836
    #define MICRO_WORLD_POS_Z     _1837
    #include "micro_detail_shadows.hlsli"
    #undef MICRO_PIXEL_X_FLOAT
    #undef MICRO_PIXEL_Y_FLOAT
    #undef MICRO_LINEAR_DEPTH
    #undef MICRO_CONTACT_SHADOW
    #undef MICRO_LIGHT_DIR_X
    #undef MICRO_LIGHT_DIR_Y
    #undef MICRO_LIGHT_DIR_Z
    #undef MICRO_WORLD_POS_X
    #undef MICRO_WORLD_POS_Y
    #undef MICRO_WORLD_POS_Z
    // ──────────────────────────────────────────────────────────────────

    // ────────────────── Screen edge contact shadow fade ───────────────
    if (CONTACT_SHADOW_QUALITY == 1.f && _2585 < 1.0f) {
      float2 _screenUV = float2((_54 + 0.5f) * _bufferSizeAndInvSize.z,
                                 (_55 + 0.5f) * _bufferSizeAndInvSize.w);
      float2 _edgeDist = min(_screenUV, 1.0f - _screenUV);
      float _edgeFade = saturate(min(_edgeDist.x, _edgeDist.y) * 10.0f);
      _2585 = lerp(lerp(1.0f, _2585, 0.5f), _2585, _edgeFade);
    }

    _2586 = min(_1616, _2585);
    _2600 = float(half(_2586 * float(_1592)));
    _2601 = float(half(_2586 * float(_1593)));
    _2602 = float(half(_2586 * float(_1594)));
    _2603 = saturate((1.0f - _550) + (exp2(log2(saturate(select(_166, (_1601 + 0.9800000190734863f), _1601))) * 0.45454543828964233f) * _550));
    // ── RenoDX Shadow Debug ──────────────────────────────────────────────
    #include "shadow_debug_night.hlsli"
    // ────────────────────────────────────────────────────────────────────
  }
  __3__38__0__1__g_shadowColorResultUAV[int2(((int)(((uint)(((((int)((uint)(_40) << 2)) & 262140) | ((int)(SV_GroupID.x) & 3)) << 3)) + SV_GroupThreadID.x)), ((int)(((uint)(((((uint)((uint)(_40)) >> 16) << 2) | (((uint)(SV_GroupID.x) >> 2) & 3)) << 3)) + SV_GroupThreadID.y)))] = half4(half(_2600), half(_2601), half(_2602), half(_2603));
}