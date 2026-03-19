#include "../shared.h"

// ── Foliage Contact Shadow Material ID Reference ─────────────────────
// ID 12 = Tree leaves + larger bushes (close/medium range)
// ID 13 = Small-scale foliage (close/medium range)
// ID 14 = Small-scale foliage (close/medium range)
// ID 15 = Distant tree LODs + larger bushes (medium/long range)
// ID 16 = Same Larger bushes as ID 15 + smaller bushes (close/medium range, no trees)
// ID 17 = Grass, flowers, small foliage (close/medium range)
// ID 18 = Very small bushes + grass not covered by other IDs (close/medium range)
// ─────────────────────────────────────────────────────────────────────

#define SHADOW_DBG_CONTACT_INV  _2595
#define SHADOW_DBG_OUT_R        _2610
#define SHADOW_DBG_OUT_G        _2611
#define SHADOW_DBG_OUT_B        _2612
#define SHADOW_DBG_OUT_A        _2613

Texture2D<float4> __3__36__0__0__g_terrainShadowDepth : register(t155, space36);

Texture2DArray<float4> __3__36__0__0__g_dynamicShadowDepthArray : register(t229, space36);

Texture2DArray<half4> __3__36__0__0__g_dynamicShadowColorArray : register(t231, space36);

Texture2DArray<float4> __3__36__0__0__g_shadowDepthArray : register(t232, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t14, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t31, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t50, space36);

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
  int __loop_jump_target = -1;
  int _16[4];
  float _24[2];
  float _25[2];
  float _26[2];
  _16[0] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).x));
  _16[1] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).y));
  _16[2] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).z));
  _16[3] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).w));
  int _40 = _16[(((uint)(SV_GroupID.x) >> 4) & 3)];
  uint _52 = ((uint)(((((int)(_40 << 2)) & 262140) | ((int)(SV_GroupID.x) & 3)) << 3)) + SV_GroupThreadID.x;
  uint _53 = ((uint)(((((uint)(_40) >> 16) << 2) | (((uint)(SV_GroupID.x) >> 2) & 3)) << 3)) + SV_GroupThreadID.y;
  float _54 = float((uint)_52);
  float _55 = float((uint)_53);
  float _63 = ((_bufferSizeAndInvSize.z * 2.0f) * (_54 + 0.5f)) + -1.0f;
  float _66 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (_55 + 0.5f));
  uint _68 = __3__36__0__0__g_depthStencil.Load(int3(_52, _53, 0));
  int _70 = (uint)((uint)(_68.x)) >> 24;
  float _73 = float((uint)((uint)(_68.x & 16777215))) * 5.960465188081798e-08f;
  int _74 = _70 & 127;
  uint _76 = __3__36__0__0__g_sceneNormal.Load(int3(_52, _53, 0));
  float _92 = min(1.0f, ((float((uint)((uint)(_76.x & 1023))) * 0.001956947147846222f) + -1.0f));
  float _93 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_76.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _94 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_76.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _96 = rsqrt(dot(float3(_92, _93, _94), float3(_92, _93, _94)));
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
  float _1731;
  float _1735;
  float _1739;
  int _1977;
  float _1978;
  float _1979;
  float _1980;
  float _1981;
  float _1982;
  int _1983;
  float _1984;
  float _1985;
  bool _2048;
  int _2055;
  float _2078;
  float _2094;
  int _2101;
  float _2102;
  float _2124;
  float _2125;
  float _2126;
  float _2127;
  float _2128;
  float _2132;
  int _2259;
  float _2260;
  float _2261;
  float _2262;
  float _2263;
  float _2264;
  int _2265;
  float _2266;
  float _2267;
  bool _2330;
  int _2337;
  float _2360;
  float _2376;
  int _2383;
  float _2384;
  float _2406;
  float _2407;
  float _2408;
  float _2409;
  float _2410;
  float _2414;
  int _2424;
  float _2425;
  float _2426;
  float _2427;
  float _2428;
  float _2429;
  float _2490;
  float _2492;
  float _2515;
  float _2588;
  float _2591;
  float _2595;
  float _2610;
  float _2611;
  float _2612;
  float _2613;
  if (((int)(_73 < 1.0000000116860974e-07f)) | (_101)) {
    float _104 = select(_101, 0.0f, 1.0f);
    _2610 = _104;
    _2611 = _104;
    _2612 = _104;
    _2613 = _104;
  } else {
    float _108 = max(1.0000000116860974e-07f, _73);
    float _109 = _nearFarProj.x / _108;
    float _145 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _108, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _66, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _63))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
    float _146 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _108, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _66, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _63))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _145;
    float _147 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _108, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _66, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _63))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _145;
    float _148 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _108, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _66, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _63))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _145;
    float _150 = rsqrt(dot(float3(_146, _147, _148), float3(_146, _147, _148)));
    _24[0] = 0.0f;
    _25[0] = 0.0f;
    _26[0] = 0.0f;
    _24[1] = 0.0f;
    _25[1] = 0.0f;
    _26[1] = 0.0f;
    bool _166 = ((int)(_74 == 57)) | ((int)((uint)(_74 + -53) < (uint)15));
    float _186 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).x), _148, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).x), _147, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).x) * _146))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).x);
    float _190 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).y), _148, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).y), _147, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).y) * _146))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).y);
    float _194 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).z), _148, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).z), _147, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).z) * _146))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).z);
    if (saturate(_186) == _186) {
      if (((int)(_194 >= 9.999999747378752e-05f)) & (((int)(((int)(_194 <= 1.0f)) & ((int)(saturate(_190) == _190)))))) {
        float _205 = float((uint)((uint)(int4(_frameNumber).x)));
        float _216 = (frac(((_205 * 92.0f) + _54) * 0.0078125f) * 128.0f) + -64.34062194824219f;
        float _217 = (frac(((_205 * 71.0f) + _55) * 0.0078125f) * 128.0f) + -72.46562194824219f;
        float _222 = frac(dot(float3((_216 * _216), (_217 * _217), (_217 * _216)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
        uint _238 = ((uint)((((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54);
        uint _246 = ((uint)((((int)((_238 << 4) + -1383041155u)) ^ ((int)(_238 + -1640531527u))) ^ ((int)(((uint)((uint)(_238) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
        uint _254 = ((uint)((((int)((_246 << 4) + -1556008596u)) ^ ((int)(_246 + 1013904242u))) ^ (((uint)(_246) >> 5) + -939442524))) + _238;
        uint _262 = ((uint)((((int)((_254 << 4) + -1383041155u)) ^ ((int)(_254 + 1013904242u))) ^ ((int)(((uint)((uint)(_254) >> 5)) + 2123724318u)))) + _246;
        uint _270 = ((uint)((((int)((_262 << 4) + -1556008596u)) ^ ((int)(_262 + -626627285u))) ^ (((uint)(_262) >> 5) + -939442524))) + _254;
        uint _278 = ((uint)((((int)((_270 << 4) + -1383041155u)) ^ ((int)(_270 + -626627285u))) ^ ((int)(((uint)((uint)(_270) >> 5)) + 2123724318u)))) + _262;
        uint _286 = ((uint)((((int)((_278 << 4) + -1556008596u)) ^ ((int)(_278 + 2027808484u))) ^ (((uint)(_278) >> 5) + -939442524))) + _270;
        uint _294 = ((uint)((((int)((_286 << 4) + -1383041155u)) ^ ((int)(_286 + 2027808484u))) ^ ((int)(((uint)((uint)(_286) >> 5)) + 2123724318u)))) + _278;
        uint _302 = ((uint)((((int)((_294 << 4) + -1556008596u)) ^ ((int)(_294 + 387276957u))) ^ (((uint)(_294) >> 5) + -939442524))) + _286;
        uint _310 = ((uint)((((int)((_302 << 4) + -1383041155u)) ^ ((int)(_302 + 387276957u))) ^ ((int)(((uint)((uint)(_302) >> 5)) + 2123724318u)))) + _294;
        uint _318 = ((uint)((((int)((_310 << 4) + -1556008596u)) ^ ((int)(_310 + -1253254570u))) ^ (((uint)(_310) >> 5) + -939442524))) + _302;
        uint _326 = ((uint)((((int)((_318 << 4) + -1383041155u)) ^ ((int)(_318 + -1253254570u))) ^ ((int)(((uint)((uint)(_318) >> 5)) + 2123724318u)))) + _310;
        uint _334 = ((uint)((((int)((_326 << 4) + -1556008596u)) ^ ((int)(_326 + 1401181199u))) ^ (((uint)(_326) >> 5) + -939442524))) + _318;
        uint _342 = ((uint)((((int)((_334 << 4) + -1383041155u)) ^ ((int)(_334 + 1401181199u))) ^ ((int)(((uint)((uint)(_334) >> 5)) + 2123724318u)))) + _326;
        uint _350 = ((uint)((((int)((_342 << 4) + -1556008596u)) ^ ((int)(_342 + -239350328u))) ^ (((uint)(_342) >> 5) + -939442524))) + _334;
        uint _358 = ((uint)((((int)((_350 << 4) + -1383041155u)) ^ ((int)(_350 + -239350328u))) ^ ((int)(((uint)((uint)(_350) >> 5)) + 2123724318u)))) + _342;
        if ((_350 & 16777215) == 0) {
          _371 = ((int)(((uint)((((int)((_358 << 4) + -1556008596u)) ^ ((int)(_358 + -1879881855u))) ^ (((uint)(_358) >> 5) + -939442524))) + _350));
        } else {
          _371 = _350;
        }
        uint _376 = uint(float((uint)((uint)(((int)(_371 * 48271)) & 16777215))) * 3.814637693722034e-06f);
        float _383 = frac((float((uint)_376) * 0.015625f) + (float((uint)((uint)((int)(uint(_222 * 51540816.0f)) & 65535))) * 1.52587890625e-05f));
        float _389 = (_383 * 2.0f) + -1.0f;
        float _390 = (float((uint)((uint)(reversebits(_376) ^ (int)(uint(_222 * 287478368.0f))))) * 4.656612873077393e-10f) + -1.0f;
        float _392 = rsqrt(dot(float2(_389, _390), float2(_389, _390)));
        float _399 = ((_383 * 0.0009765625f) + -0.00048828125f) * _392;
        float _401 = (_390 * _392) * 0.00048828125f;
        float _403 = (_399 * ((_jitterOffset[0]).x)) + _186;
        float _404 = (_401 * ((_jitterOffset[0]).y)) + _190;
        float _409 = frac((_403 * 1024.0f) + -0.5f);
        float4 _413 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_403, _404));
        float _418 = _194 + -0.004999999888241291f;
        float _423 = select((_413.w > _418), 1.0f, 0.0f);
        float _425 = select((_413.x > _418), 1.0f, 0.0f);
        float _432 = ((select((_413.z > _418), 1.0f, 0.0f) - _423) * _409) + _423;
        float _442 = (((_jitterOffset[1]).x) * _399) + _186;
        float _443 = (((_jitterOffset[1]).y) * _401) + _190;
        float _448 = frac((_442 * 1024.0f) + -0.5f);
        float4 _450 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_442, _443));
        float _459 = select((_450.w > _418), 1.0f, 0.0f);
        float _461 = select((_450.x > _418), 1.0f, 0.0f);
        float _468 = ((select((_450.z > _418), 1.0f, 0.0f) - _459) * _448) + _459;
        float _479 = (((_jitterOffset[2]).x) * _399) + _186;
        float _480 = (((_jitterOffset[2]).y) * _401) + _190;
        float _485 = frac((_479 * 1024.0f) + -0.5f);
        float4 _487 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_479, _480));
        float _496 = select((_487.w > _418), 1.0f, 0.0f);
        float _498 = select((_487.x > _418), 1.0f, 0.0f);
        float _505 = ((select((_487.z > _418), 1.0f, 0.0f) - _496) * _485) + _496;
        float _516 = (((_jitterOffset[3]).x) * _399) + _186;
        float _517 = (((_jitterOffset[3]).y) * _401) + _190;
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
    float _578 = mad((float4(_dynamicShadowProjRelativeTexScale[1][0].z, _dynamicShadowProjRelativeTexScale[1][1].z, _dynamicShadowProjRelativeTexScale[1][2].z, _dynamicShadowProjRelativeTexScale[1][3].z).x), _148, mad((float4(_dynamicShadowProjRelativeTexScale[1][0].y, _dynamicShadowProjRelativeTexScale[1][1].y, _dynamicShadowProjRelativeTexScale[1][2].y, _dynamicShadowProjRelativeTexScale[1][3].y).x), _147, ((float4(_dynamicShadowProjRelativeTexScale[1][0].x, _dynamicShadowProjRelativeTexScale[1][1].x, _dynamicShadowProjRelativeTexScale[1][2].x, _dynamicShadowProjRelativeTexScale[1][3].x).x) * _146))) + (float4(_dynamicShadowProjRelativeTexScale[1][0].w, _dynamicShadowProjRelativeTexScale[1][1].w, _dynamicShadowProjRelativeTexScale[1][2].w, _dynamicShadowProjRelativeTexScale[1][3].w).x);
    float _582 = mad((float4(_dynamicShadowProjRelativeTexScale[1][0].z, _dynamicShadowProjRelativeTexScale[1][1].z, _dynamicShadowProjRelativeTexScale[1][2].z, _dynamicShadowProjRelativeTexScale[1][3].z).y), _148, mad((float4(_dynamicShadowProjRelativeTexScale[1][0].y, _dynamicShadowProjRelativeTexScale[1][1].y, _dynamicShadowProjRelativeTexScale[1][2].y, _dynamicShadowProjRelativeTexScale[1][3].y).y), _147, ((float4(_dynamicShadowProjRelativeTexScale[1][0].x, _dynamicShadowProjRelativeTexScale[1][1].x, _dynamicShadowProjRelativeTexScale[1][2].x, _dynamicShadowProjRelativeTexScale[1][3].x).y) * _146))) + (float4(_dynamicShadowProjRelativeTexScale[1][0].w, _dynamicShadowProjRelativeTexScale[1][1].w, _dynamicShadowProjRelativeTexScale[1][2].w, _dynamicShadowProjRelativeTexScale[1][3].w).y);
    float _586 = mad((float4(_dynamicShadowProjRelativeTexScale[1][0].z, _dynamicShadowProjRelativeTexScale[1][1].z, _dynamicShadowProjRelativeTexScale[1][2].z, _dynamicShadowProjRelativeTexScale[1][3].z).z), _148, mad((float4(_dynamicShadowProjRelativeTexScale[1][0].y, _dynamicShadowProjRelativeTexScale[1][1].y, _dynamicShadowProjRelativeTexScale[1][2].y, _dynamicShadowProjRelativeTexScale[1][3].y).z), _147, ((float4(_dynamicShadowProjRelativeTexScale[1][0].x, _dynamicShadowProjRelativeTexScale[1][1].x, _dynamicShadowProjRelativeTexScale[1][2].x, _dynamicShadowProjRelativeTexScale[1][3].x).z) * _146))) + (float4(_dynamicShadowProjRelativeTexScale[1][0].w, _dynamicShadowProjRelativeTexScale[1][1].w, _dynamicShadowProjRelativeTexScale[1][2].w, _dynamicShadowProjRelativeTexScale[1][3].w).z);
    float _587 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
    float _588 = 1.0f - _587;
    if (!((((int)((((int)(!(_578 <= _588)))) | (((int)(!(_578 >= _587))))))) | (((int)(!(_582 <= _588)))))) {
      if (((int)(_558 < 128.0f)) & (((int)(((int)(_586 >= -1.0f)) & (((int)(((int)(_586 <= 1.0f)) & ((int)(_582 >= _587))))))))) {
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
    float _646 = mad((float4(_dynamicShadowProjRelativeTexScale[0][0].z, _dynamicShadowProjRelativeTexScale[0][1].z, _dynamicShadowProjRelativeTexScale[0][2].z, _dynamicShadowProjRelativeTexScale[0][3].z).x), _148, mad((float4(_dynamicShadowProjRelativeTexScale[0][0].y, _dynamicShadowProjRelativeTexScale[0][1].y, _dynamicShadowProjRelativeTexScale[0][2].y, _dynamicShadowProjRelativeTexScale[0][3].y).x), _147, ((float4(_dynamicShadowProjRelativeTexScale[0][0].x, _dynamicShadowProjRelativeTexScale[0][1].x, _dynamicShadowProjRelativeTexScale[0][2].x, _dynamicShadowProjRelativeTexScale[0][3].x).x) * _146))) + (float4(_dynamicShadowProjRelativeTexScale[0][0].w, _dynamicShadowProjRelativeTexScale[0][1].w, _dynamicShadowProjRelativeTexScale[0][2].w, _dynamicShadowProjRelativeTexScale[0][3].w).x);
    float _650 = mad((float4(_dynamicShadowProjRelativeTexScale[0][0].z, _dynamicShadowProjRelativeTexScale[0][1].z, _dynamicShadowProjRelativeTexScale[0][2].z, _dynamicShadowProjRelativeTexScale[0][3].z).y), _148, mad((float4(_dynamicShadowProjRelativeTexScale[0][0].y, _dynamicShadowProjRelativeTexScale[0][1].y, _dynamicShadowProjRelativeTexScale[0][2].y, _dynamicShadowProjRelativeTexScale[0][3].y).y), _147, ((float4(_dynamicShadowProjRelativeTexScale[0][0].x, _dynamicShadowProjRelativeTexScale[0][1].x, _dynamicShadowProjRelativeTexScale[0][2].x, _dynamicShadowProjRelativeTexScale[0][3].x).y) * _146))) + (float4(_dynamicShadowProjRelativeTexScale[0][0].w, _dynamicShadowProjRelativeTexScale[0][1].w, _dynamicShadowProjRelativeTexScale[0][2].w, _dynamicShadowProjRelativeTexScale[0][3].w).y);
    float _654 = mad((float4(_dynamicShadowProjRelativeTexScale[0][0].z, _dynamicShadowProjRelativeTexScale[0][1].z, _dynamicShadowProjRelativeTexScale[0][2].z, _dynamicShadowProjRelativeTexScale[0][3].z).z), _148, mad((float4(_dynamicShadowProjRelativeTexScale[0][0].y, _dynamicShadowProjRelativeTexScale[0][1].y, _dynamicShadowProjRelativeTexScale[0][2].y, _dynamicShadowProjRelativeTexScale[0][3].y).z), _147, ((float4(_dynamicShadowProjRelativeTexScale[0][0].x, _dynamicShadowProjRelativeTexScale[0][1].x, _dynamicShadowProjRelativeTexScale[0][2].x, _dynamicShadowProjRelativeTexScale[0][3].x).z) * _146))) + (float4(_dynamicShadowProjRelativeTexScale[0][0].w, _dynamicShadowProjRelativeTexScale[0][1].w, _dynamicShadowProjRelativeTexScale[0][2].w, _dynamicShadowProjRelativeTexScale[0][3].w).z);
    if (!((((int)((((int)(!(_646 >= _587)))) | (((int)(!(_646 <= _588))))))) | (((int)(!(_650 <= _588)))))) {
      if (((int)(_558 < 128.0f)) & (((int)(((int)(_654 >= -1.0f)) & (((int)(((int)(_650 >= _587)) & ((int)(_654 <= 1.0f))))))))) {
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
      float _709 = _702 - ((_staticShadowPosition[1]).x);
      float _710 = _703 - ((_staticShadowPosition[1]).y);
      float _711 = _704 - ((_staticShadowPosition[1]).z);
      float _731 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).x), _711, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).x), _710, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).x) * _709))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).x);
      float _735 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).y), _711, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).y), _710, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).y) * _709))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).y);
      float _739 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).z), _711, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).z), _710, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).z) * _709))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).z);
      float _740 = 2.0f / _shadowSizeAndInvSize.y;
      float _741 = 1.0f - _740;
      if (!((((int)((((int)(!(_731 <= _741)))) | (((int)(!(_731 >= _740))))))) | (((int)(!(_735 <= _741)))))) {
        if (((int)(_739 >= 9.999999747378752e-05f)) & (((int)(((int)(_739 <= 1.0f)) & ((int)(_735 >= _740)))))) {
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
      float _762 = _702 - ((_staticShadowPosition[0]).x);
      float _763 = _703 - ((_staticShadowPosition[0]).y);
      float _764 = _704 - ((_staticShadowPosition[0]).z);
      float _784 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).x), _764, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).x), _763, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).x) * _762))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).x);
      float _788 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).y), _764, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).y), _763, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).y) * _762))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).y);
      float _792 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).z), _764, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).z), _763, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).z) * _762))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).z);
      if (!((((int)((((int)(!(_784 >= _740)))) | (((int)(!(_784 <= _741))))))) | (((int)(!(_788 <= _741)))))) {
        if (((int)(_792 >= 9.999999747378752e-05f)) & (((int)(((int)(_788 >= _740)) & ((int)(_792 <= 1.0f)))))) {
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
    uint _824 = ((uint)((((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524))) + uint((_55 * _bufferSizeAndInvSize.x) + _54);
    uint _832 = ((uint)((((int)((_824 << 4) + -1383041155u)) ^ ((int)(_824 + -1640531527u))) ^ ((int)(((uint)((uint)(_824) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
    uint _840 = ((uint)((((int)((_832 << 4) + -1556008596u)) ^ ((int)(_832 + 1013904242u))) ^ (((uint)(_832) >> 5) + -939442524))) + _824;
    uint _848 = ((uint)((((int)((_840 << 4) + -1383041155u)) ^ ((int)(_840 + 1013904242u))) ^ ((int)(((uint)((uint)(_840) >> 5)) + 2123724318u)))) + _832;
    uint _856 = ((uint)((((int)((_848 << 4) + -1556008596u)) ^ ((int)(_848 + -626627285u))) ^ (((uint)(_848) >> 5) + -939442524))) + _840;
    uint _864 = ((uint)((((int)((_856 << 4) + -1383041155u)) ^ ((int)(_856 + -626627285u))) ^ ((int)(((uint)((uint)(_856) >> 5)) + 2123724318u)))) + _848;
    uint _872 = ((uint)((((int)((_864 << 4) + -1556008596u)) ^ ((int)(_864 + 2027808484u))) ^ (((uint)(_864) >> 5) + -939442524))) + _856;
    uint _880 = ((uint)((((int)((_872 << 4) + -1383041155u)) ^ ((int)(_872 + 2027808484u))) ^ ((int)(((uint)((uint)(_872) >> 5)) + 2123724318u)))) + _864;
    uint _888 = ((uint)((((int)((_880 << 4) + -1556008596u)) ^ ((int)(_880 + 387276957u))) ^ (((uint)(_880) >> 5) + -939442524))) + _872;
    uint _896 = ((uint)((((int)((_888 << 4) + -1383041155u)) ^ ((int)(_888 + 387276957u))) ^ ((int)(((uint)((uint)(_888) >> 5)) + 2123724318u)))) + _880;
    uint _904 = ((uint)((((int)((_896 << 4) + -1556008596u)) ^ ((int)(_896 + -1253254570u))) ^ (((uint)(_896) >> 5) + -939442524))) + _888;
    uint _912 = ((uint)((((int)((_904 << 4) + -1383041155u)) ^ ((int)(_904 + -1253254570u))) ^ ((int)(((uint)((uint)(_904) >> 5)) + 2123724318u)))) + _896;
    uint _920 = ((uint)((((int)((_912 << 4) + -1556008596u)) ^ ((int)(_912 + 1401181199u))) ^ (((uint)(_912) >> 5) + -939442524))) + _904;
    uint _928 = ((uint)((((int)((_920 << 4) + -1383041155u)) ^ ((int)(_920 + 1401181199u))) ^ ((int)(((uint)((uint)(_920) >> 5)) + 2123724318u)))) + _912;
    uint _936 = ((uint)((((int)((_928 << 4) + -1556008596u)) ^ ((int)(_928 + -239350328u))) ^ (((uint)(_928) >> 5) + -939442524))) + _920;
    uint _944 = ((uint)((((int)((_936 << 4) + -1383041155u)) ^ ((int)(_936 + -239350328u))) ^ ((int)(((uint)((uint)(_936) >> 5)) + 2123724318u)))) + _928;
    bool _946 = ((_936 & 16777215) == 0);
    [branch]
    if (!_694) {
      float _950 = _24[_808];
      float _951 = _25[_808];
      float _952 = _26[_808];
      float _954 = select((_808 == 0), 2.5f, 1.25f);
      if (_946) {
        _967 = ((int)(((uint)((((int)((_944 << 4) + -1556008596u)) ^ ((int)(_944 + -1879881855u))) ^ (((uint)(_944) >> 5) + -939442524))) + _936));
      } else {
        _967 = _936;
      }
      float _968 = select(_166, (_954 * 0.75f), _954) * 0.6600000262260437f;
      float _969 = _968 * _dynmaicShadowSizeAndInvSize.z;
      float _970 = _968 * _dynmaicShadowSizeAndInvSize.w;
      float _977 = _969 * 1.1920928955078125e-07f;
      float _979 = _970 * 1.1920928955078125e-07f;
      float _983 = ((float((uint)((uint)(((int)(_967 * 48271)) & 16777215))) * _977) - _969) + _950;
      float _984 = ((float((uint)((uint)(((int)(_967 * -1964877855)) & 16777215))) * _979) - _970) + _951;
      float _985 = float((uint)_808);
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
      half _1449 = half(float(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)((float)(_1023.x) + (float)(_999.x))) + (float)(_1049.x))) + (float)(_1075.x))) + (float)(_1101.x))) + (float)(_1127.x))) + (float)(_1153.x))) + (float)(_1179.x))) + (float)(_1205.x))) + (float)(_1231.x))) + (float)(_1257.x))) + (float)(_1283.x))) + (float)(_1309.x))) + (float)(_1335.x))) + (float)(_1361.x))) + ((float)((float)(_1387.x) * 2.0h))) * 0.05882352963089943f);
      half _1450 = half(float(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)((float)(_1023.y) + (float)(_999.y))) + (float)(_1049.y))) + (float)(_1075.y))) + (float)(_1101.y))) + (float)(_1127.y))) + (float)(_1153.y))) + (float)(_1179.y))) + (float)(_1205.y))) + (float)(_1231.y))) + (float)(_1257.y))) + (float)(_1283.y))) + (float)(_1309.y))) + (float)(_1335.y))) + (float)(_1361.y))) + ((float)((float)(_1387.y) * 2.0h))) * 0.05882352963089943f);
      half _1451 = half(float(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)((float)(_1023.z) + (float)(_999.z))) + (float)(_1049.z))) + (float)(_1075.z))) + (float)(_1101.z))) + (float)(_1127.z))) + (float)(_1153.z))) + (float)(_1179.z))) + (float)(_1205.z))) + (float)(_1231.z))) + (float)(_1257.z))) + (float)(_1283.z))) + (float)(_1309.z))) + (float)(_1335.z))) + (float)(_1361.z))) + ((float)((float)(_1387.z) * 2.0h))) * 0.05882352963089943f);
      if (_808 == 1) {
        float _1454 = float(_1449);
        float _1455 = float(_1450);
        float _1456 = float(_1451);
        float _1457 = -0.0f - _693;
        _1590 = _1393;
        _1591 = _1394;
        _1592 = (float)(half((_1454 + _693) + (_1454 * _1457)));
        _1593 = (float)(half((_1455 + _693) + (_1455 * _1457)));
        _1594 = (float)(half((_1456 + _693) + (_1456 * _1457)));
      } else {
        _1590 = _1393;
        _1591 = _1394;
        _1592 = _1449;
        _1593 = _1450;
        _1594 = _1451;
      }
    } else {
      float _1474 = _24[_808];
      float _1475 = _25[_808];
      float _1476 = _26[_808];
      if (_946) {
        _1487 = ((int)(((uint)((((int)((_944 << 4) + -1556008596u)) ^ ((int)(_944 + -1879881855u))) ^ (((uint)(_944) >> 5) + -939442524))) + _936));
      } else {
        _1487 = _936;
      }
      float _1488 = _shadowSizeAndInvSize.z * 2.0f;
      float _1489 = _shadowSizeAndInvSize.w * 2.0f;
      float _1496 = _shadowSizeAndInvSize.z * 2.384185791015625e-07f;
      float _1498 = _shadowSizeAndInvSize.w * 2.384185791015625e-07f;
      float _1502 = ((float((uint)((uint)(((int)(_1487 * 48271)) & 16777215))) * _1496) - _1488) + _1474;
      float _1503 = ((float((uint)((uint)(((int)(_1487 * -1964877855)) & 16777215))) * _1498) - _1489) + _1475;
      float _1504 = float((uint)_808);
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
    }
    bool _1595 = (_807 != 0);
    float _1597 = min(_550, select(_1595, _1590, 1.0f));
    float _1601 = select((_691 != 0), select(_1595, (_1591 * 400.0f), 4e+06f), 1.0f);
    float _1616 = (_1597 - (_shadowAOParams.x * _1597)) + _shadowAOParams.x;
    [branch]
    if (_1616 > 0.0f) {
      int _1626 = _70 & 126;
      bool _1628 = (_74 == 66);
      bool _1629 = ((int)(_1626 == 64)) | (_1628);
      float _1630 = select(_1629, 2.0f, 4.0f);
      bool __defer_1625_1639 = false;
      if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
        __defer_1625_1639 = true;
      } else {
        _1646 = _moonDirection.x;
        _1647 = _moonDirection.y;
        _1648 = _moonDirection.z;
      }
      if (__defer_1625_1639) {
        _1646 = _sunDirection.x;
        _1647 = _sunDirection.y;
        _1648 = _sunDirection.z;
      }
      int _1649 = _52 & 3;
      int _1653 = _53 & 3;
      uint _1659 = ((int4(_frameNumber).x) * 1551) + ((uint)(((((_1653 << 1) | _1653) << 1) & 10) | (((_1649 << 1) | _1649) & 5)));
      int _1664 = (((int)(_1659 << 2)) & -858993460) | (((uint)(_1659) >> 2) & 858993459);
      int _1669 = (((int)(_1664 << 1)) & 10) | (((uint)(_1664) >> 1) & 21);
      float _1670 = float((uint)((uint)(int4(_frameNumber).x)));
      float _1681 = (frac(((_1670 * 92.0f) + _54) * 0.0078125f) * 128.0f) + -64.34062194824219f;
      float _1682 = (frac(((_1670 * 71.0f) + _55) * 0.0078125f) * 128.0f) + -72.46562194824219f;
      float _1687 = frac(dot(float3((_1681 * _1681), (_1682 * _1682), (_1682 * _1681)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
      float _1703 = frac((float((uint)((uint)((int)(uint(_1687 * 51540816.0f)) & 65535))) * 1.52587890625e-05f) + (float((uint)_1669) * 0.03125f)) * 6.2831854820251465f;
      float _1707 = (((1.0f - _shadowAOParams.z) * 2.3283064365386963e-10f) * float((uint)((uint)(reversebits(_1669) ^ (int)(uint(_1687 * 287478368.0f)))))) + _shadowAOParams.z;
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
      float _1762 = saturate(((_109 * 0.009999999776482582f) * (1.0f - saturate(dot(float3((_96 * _92), (_96 * _93), (_96 * _94)), float3((-0.0f - (_146 * _150)), (-0.0f - (_147 * _150)), (-0.0f - (_148 * _150))))))) + 0.009999999776482582f);
      if (_terrainNormalParams.z > 0.0f) {
        float _1773 = float((uint)((uint)(((int)((int4(_frameNumber).x) * 73)) & 255)));
        _1799 = frac(frac(dot(float2(((_1773 * 32.665000915527344f) + _54), ((_1773 * 11.8149995803833f) + _55)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
      } else {
        if (_946) {
          _1793 = ((int)(((uint)((((int)((_944 << 4) + -1556008596u)) ^ ((int)(_944 + -1879881855u))) ^ (((uint)(_944) >> 5) + -939442524))) + _936));
        } else {
          _1793 = _936;
        }
        _1799 = (float((uint)((uint)(((int)(_1793 * 48271)) & 16777215))) * 5.960464477539063e-08f);
      }
      if ((_1628) | (((int)(((int)(_74 != 15)) & ((int)((uint)(_74 + -12) < (uint)7)))))) {
        _1812 = (_1799 * select(CONTACT_SHADOW_QUALITY > 0.5f, 3.0f, 10.0f));
      } else {
        if (_74 == 15) {
          _1812 = ((select(CONTACT_SHADOW_QUALITY > 0.5f, 3.0f, 10.0f) - (saturate(_109 * 0.0010000000474974513f) * (select(CONTACT_SHADOW_QUALITY > 0.5f, 3.0f, 10.0f) - 1.0f))) * _1799);
        } else {
          _1812 = _1799;
        }
      }
      bool __defer_1811_1823 = false;
      if (!(_1626 == 12)) {
        if ((uint)_74 > (uint)15) {
          if (((int)((uint)_74 < (uint)20)) | ((int)(_74 == 107))) {
            __defer_1811_1823 = true;
          } else {
            _1825 = 0.0f;
          }
        } else {
          _1825 = 0.0f;
        }
      } else {
        __defer_1811_1823 = true;
      }
      if (__defer_1811_1823) {
        _1825 = (0.10000000149011612f - (abs(_1735) * 0.05000000074505806f));
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
      float _1850 = mad((float4(_viewRelative[0].z, _viewRelative[1].z, _viewRelative[2].z, _viewRelative[3].z).z), _1837, mad((float4(_viewRelative[0].y, _viewRelative[1].y, _viewRelative[2].y, _viewRelative[3].y).z), _1836, ((float4(_viewRelative[0].x, _viewRelative[1].x, _viewRelative[2].x, _viewRelative[3].x).z) * _1835))) + (float4(_viewRelative[0].w, _viewRelative[1].w, _viewRelative[2].w, _viewRelative[3].w).z);
      float _1853 = mad((float4(_viewRelative[0].z, _viewRelative[1].z, _viewRelative[2].z, _viewRelative[3].z).z), _1739, mad((float4(_viewRelative[0].y, _viewRelative[1].y, _viewRelative[2].y, _viewRelative[3].y).z), _1735, ((float4(_viewRelative[0].x, _viewRelative[1].x, _viewRelative[2].x, _viewRelative[3].x).z) * _1731)));
      bool _1856 = (((_1853 * _1756) + _1850) < _nearFarProj.x);
      if (_109 < select(CONTACT_SHADOW_QUALITY > 0.5f, 64.0f, 8.0f)) {
        float _1860 = select(_1856, ((_nearFarProj.x - _1850) / _1853), _1756);
        float _1892 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _1837, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _1836, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z) * _1835))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z);
        float _1896 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _1837, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _1836, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w) * _1835))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
        float _1900 = (_1860 * _1731) + _1835;
        float _1901 = (_1860 * _1735) + _1836;
        float _1902 = (_1860 * _1739) + _1837;
        float _1918 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _1902, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _1901, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w) * _1900))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
        float _1919 = (mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _1837, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _1836, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x) * _1835))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x)) / _1896;
        float _1920 = (mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _1837, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _1836, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y) * _1835))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y)) / _1896;
        float _1921 = _1892 / _1896;
        float _1925 = ((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _1902, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _1901, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x) * _1900))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x)) / _1918) - _1919;
        float _1926 = ((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _1902, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _1901, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y) * _1900))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y)) / _1918) - _1920;
        float _1938 = max(0.125f, (1.0f / min(1.0f, (max(((_bufferSizeAndInvSize.x * 0.5f) * abs(_1925)), ((_bufferSizeAndInvSize.y * 0.5f) * abs(_1926))) * 0.125f))));
        float _1939 = _1938 * (((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _1902, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _1901, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z) * _1900))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z)) / _1918) - _1921);
        float _1956 = (_1742 * 0.125f) * max(abs(_1939), (_1921 - ((mad((float4(_proj[0].z, _proj[1].z, _proj[2].z, _proj[3].z).z), _109, 0.0f) + _1892) / (mad((float4(_proj[0].z, _proj[1].z, _proj[2].z, _proj[3].z).w), _109, 0.0f) + _1896))));
        float _1958 = (_1925 * 0.0625f) * _1938;
        float _1960 = (_1926 * -0.0625f) * _1938;
        float _1961 = _1939 * 0.125f;
        float _1968 = max(_1812, (1.0f / max((abs(_1958) * _bufferSizeAndInvSize.x), (abs(_1960) * _bufferSizeAndInvSize.y))));
        float _1975 = 0.5f / _bufferSizeAndInvSize.x;
        _1977 = 0;
        _1978 = (((_1919 * 0.5f) + 0.5f) + (_1968 * _1958));
        _1979 = ((0.5f - (_1920 * 0.5f)) + (_1968 * _1960));
        _1980 = ((_1968 * _1961) + _1921);
        _1981 = _1812;
        _1982 = _1762;
        _1983 = 0;
        _1984 = 1.0f;
        _1985 = 0.0f;
        while(true) {
          uint _1994 = __3__36__0__0__g_depthStencil.Load(int3(int(min(max(_1978, _1975), (1.0f - _1975)) * _bufferSizeAndInvSize.x), int(_1979 * _bufferSizeAndInvSize.y), 0));
          int _1996 = (uint)((uint)(_1994.x)) >> 24;
          float _1999 = float((uint)((uint)(_1994.x & 16777215))) * 5.960465188081798e-08f;
          int _2000 = _1996 & 127;
          bool _2001 = (_1983 == 0);
          float _2002 = select(_2001, 1.0f, _1982);
          float _2006 = _nearFarProj.x / max(1.0000000116860974e-07f, _1999);
          float _2007 = _1980 - _1999;
          float _2010 = _2006 - (_nearFarProj.x / max(1.0000000116860974e-07f, _1980));
          bool _2013 = (abs(_2007 + _1956) < _1956);
          int _2014 = (int)(uint)(_2013);
          if (_2013) {
            bool __defer_2015_2047 = false;
            if (!(((int)(_2000 == 7)) | (((int)(((int)(_2000 == 54)) | (((int)(((int)((_1996 & 126) == 66)) | (((int)(((int)((uint)(_2000 + -5) < (uint)2)) | (((int)(((int)(_2000 == 107)) | (((int)(((int)(_2000 == 26)) | (((int)(((int)((uint)(_2000 + -27) < (uint)2)) | (((int)(((int)(_2000 == 106)) | (((int)(((int)((_1996 & 125) == 105)) | (((int)(((int)(_2000 == 18)) | ((int)((uint)(_2000 + -19) < (uint)2))))))))))))))))))))))))))))))) {
              if ((uint)(_2000 + -53) < (uint)14) {
                _2048 = (_2006 < 32.0f);
                __defer_2015_2047 = true;
              } else {
                _2055 = _2014;
              }
            } else {
              _2048 = true;
              __defer_2015_2047 = true;
            }
            if (__defer_2015_2047) {
              _2055 = ((int)(uint)((int)(((int)(_2010 < 0.0f)) & ((int)(_2010 > select(_2048, -0.07999999821186066f, -1.0f))))));
            }
          } else {
            _2055 = _2014;
          }
          if (!(_2055 == 0)) {
            bool __defer_2057_2076 = false;
            if ((uint)_2000 > (uint)11) {
              if (!(((int)((uint)_2000 < (uint)16)) | ((int)(_2000 == 17)))) {
                if (!(_2000 == 16)) {
                  if (!(((int)(_2000 == 18)) | (((int)(((int)(_2000 == 107)) | ((int)((uint)(_2000 + -19) < (uint)2))))))) {
                    if (!(_2000 == 66)) {
                      __defer_2057_2076 = true;
                    } else {
                      _2078 = 0.10000000149011612f;
                    }
                  } else {
                    _2078 = select(CONTACT_SHADOW_QUALITY > 0.5f, 0.18f, 0.4000000059604645f);
                  }
                } else {
                  _2078 = 0.10000000149011612f;
                }
              } else {
                // RenoDX: Weather adaptive grass occluder thickness
                if (_2000 == 17) {
                  float _grassWeather = saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY);
                  _2078 = select(CONTACT_SHADOW_QUALITY > 0.5f, lerp(0.018f, 0.05f, _grassWeather), 0.09f);
                } else {
                  _2078 = select(CONTACT_SHADOW_QUALITY > 0.5f, 0.12f, 0.30000001192092896f);
                }
              }
            } else {
              if (!(_2000 == 11)) {
                __defer_2057_2076 = true;
              } else {
                _2078 = 0.10000000149011612f;
              }
            }
            if (__defer_2057_2076) {
              _2078 = 0.0f;
            }
            float _2080 = saturate(_2006 * 0.015625f);
            float _2083 = (1.0f - _2080) + (_2080 * _2078);
            if (_166) {
              _2094 = saturate((-0.0f - _2010) / (_1981 * 0.004654859658330679f));
            } else {
              _2094 = 1.0f;
            }
            _2101 = _2000;
            _2102 = saturate(((saturate(1.0f - ((_2083 * _2083) * _2078)) * (1.0f - _1985)) * _2094) + _1985);
            // RenoDX: Weather adaptive grass shadow contribution
            if (CONTACT_SHADOW_QUALITY > 0.5f && _2000 == 17) {
              float _grassContrib = lerp(0.3f, 0.65f, saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY));
              _2102 = lerp(_1985, _2102, _grassContrib);
            }
          } else {
            _2101 = _1977;
            _2102 = _1985;
          }
          [branch]
          if (_2102 > 0.949999988079071f) {
            if (!_2001) {
              _2132 = (saturate(_1984 / (_1984 - _2007)) - min(_1981, _2002));
            } else {
              _2132 = 0.0f;
            }
            _2424 = _2000;
            _2425 = _2102;
            _2426 = ((_2132 * _1958) + _1978);
            _2427 = ((_2132 * _1960) + _1979);
            _2428 = ((_2132 * _1961) + _1980);
            _2429 = _1999;
          } else {
            if ((uint)_1983 < ((uint)7)) {
              _2124 = ((_2002 * _1958) + _1978);
              _2125 = ((_2002 * _1960) + _1979);
              _2126 = ((_2002 * _1961) + _1980);
              _2127 = (_2002 + _1981);
              _2128 = min(abs(_1961), _2007);
            } else {
              _2124 = _1978;
              _2125 = _1979;
              _2126 = _1980;
              _2127 = _1981;
              _2128 = _1984;
            }
            int _2129 = _1983 + 1;
            if ((uint)_2129 < ((uint)8)) {
              _1977 = _2101;
              _1978 = _2124;
              _1979 = _2125;
              _1980 = _2126;
              _1981 = _2127;
              _1982 = _2002;
              _1983 = _2129;
              _1984 = _2128;
              _1985 = _2102;
              continue;
            } else {
              _2424 = _2101;
              _2425 = _2102;
              _2426 = _1978;
              _2427 = _1979;
              _2428 = _1980;
              _2429 = _1999;
            }
          }
          break;
        }
      } else {
        float _2142 = select(_1856, ((_nearFarProj.x - _1850) / _1853), _1756);
        float _2174 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _1837, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _1836, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z) * _1835))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z);
        float _2178 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _1837, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _1836, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w) * _1835))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
        float _2182 = (_2142 * _1731) + _1835;
        float _2183 = (_2142 * _1735) + _1836;
        float _2184 = (_2142 * _1739) + _1837;
        float _2200 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _2184, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _2183, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w) * _2182))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
        float _2201 = (mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _1837, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _1836, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x) * _1835))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x)) / _2178;
        float _2202 = (mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _1837, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _1836, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y) * _1835))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y)) / _2178;
        float _2203 = _2174 / _2178;
        float _2207 = ((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _2184, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _2183, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x) * _2182))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x)) / _2200) - _2201;
        float _2208 = ((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _2184, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _2183, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y) * _2182))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y)) / _2200) - _2202;
        float _2220 = max(0.125f, (1.0f / min(1.0f, (max(((_bufferSizeAndInvSize.x * 0.5f) * abs(_2207)), ((_bufferSizeAndInvSize.y * 0.5f) * abs(_2208))) * 0.125f))));
        float _2221 = _2220 * (((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _2184, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _2183, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z) * _2182))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z)) / _2200) - _2203);
        float _2238 = (_1742 * 0.0625f) * max(abs(_2221), (_2203 - ((mad((float4(_proj[0].z, _proj[1].z, _proj[2].z, _proj[3].z).z), _109, 0.0f) + _2174) / (mad((float4(_proj[0].z, _proj[1].z, _proj[2].z, _proj[3].z).w), _109, 0.0f) + _2178))));
        float _2240 = (_2207 * 0.0625f) * _2220;
        float _2242 = (_2208 * -0.0625f) * _2220;
        float _2243 = _2221 * 0.125f;
        float _2250 = max(_1812, (1.0f / max((abs(_2240) * _bufferSizeAndInvSize.x), (abs(_2242) * _bufferSizeAndInvSize.y))));
        float _2257 = 0.5f / _bufferSizeAndInvSize.x;
        _2259 = 0;
        _2260 = _1762;
        _2261 = _1812;
        _2262 = (((_2201 * 0.5f) + 0.5f) + (_2250 * _2240));
        _2263 = ((0.5f - (_2202 * 0.5f)) + (_2250 * _2242));
        _2264 = ((_2250 * _2243) + _2203);
        _2265 = 0;
        _2266 = 1.0f;
        _2267 = 0.0f;
        while(true) {
          uint _2276 = __3__36__0__0__g_depthStencil.Load(int3(int(min(max(_2262, _2257), (1.0f - _2257)) * _bufferSizeAndInvSize.x), int(_2263 * _bufferSizeAndInvSize.y), 0));
          int _2278 = (uint)((uint)(_2276.x)) >> 24;
          float _2281 = float((uint)((uint)(_2276.x & 16777215))) * 5.960465188081798e-08f;
          int _2282 = _2278 & 127;
          bool _2283 = (_2259 == 0);
          float _2284 = select(_2283, 1.0f, _2260);
          float _2285 = _2264 - _2281;
          float _2289 = _nearFarProj.x / max(1.0000000116860974e-07f, _2281);
          float _2292 = _2289 - (_nearFarProj.x / max(1.0000000116860974e-07f, _2264));
          bool _2295 = (abs(_2285 + _2238) < _2238);
          int _2296 = (int)(uint)(_2295);
          if (_2295) {
            bool __defer_2297_2329 = false;
            if (!(((int)(_2282 == 7)) | (((int)(((int)(_2282 == 54)) | (((int)(((int)((_2278 & 126) == 66)) | (((int)(((int)((uint)(_2282 + -5) < (uint)2)) | (((int)(((int)(_2282 == 107)) | (((int)(((int)(_2282 == 26)) | (((int)(((int)((uint)(_2282 + -27) < (uint)2)) | (((int)(((int)(_2282 == 106)) | (((int)(((int)((_2278 & 125) == 105)) | (((int)(((int)(_2282 == 18)) | ((int)((uint)(_2282 + -19) < (uint)2))))))))))))))))))))))))))))))) {
              if ((uint)(_2282 + -53) < (uint)14) {
                _2330 = (_2289 < 32.0f);
                __defer_2297_2329 = true;
              } else {
                _2337 = _2296;
              }
            } else {
              _2330 = true;
              __defer_2297_2329 = true;
            }
            if (__defer_2297_2329) {
              _2337 = ((int)(uint)((int)(((int)(_2292 < 0.0f)) & ((int)(_2292 > select(_2330, -0.07999999821186066f, -1.0f))))));
            }
          } else {
            _2337 = _2296;
          }
          if (!(_2337 == 0)) {
            bool __defer_2339_2358 = false;
            if ((uint)_2282 > (uint)11) {
              if (!(((int)((uint)_2282 < (uint)16)) | ((int)(_2282 == 17)))) {
                if (!(_2282 == 16)) {
                  if (!(((int)(_2282 == 18)) | (((int)(((int)(_2282 == 107)) | ((int)((uint)(_2282 + -19) < (uint)2))))))) {
                    if (!(_2282 == 66)) {
                      __defer_2339_2358 = true;
                    } else {
                      _2360 = 0.10000000149011612f;
                    }
                  } else {
                    _2360 = select(CONTACT_SHADOW_QUALITY > 0.5f, 0.18f, 0.4000000059604645f);
                  }
                } else {
                  _2360 = 0.10000000149011612f;
                }
              } else {
                // RenoDX: Weather adaptive grass occluder thickness
                if (_2282 == 17) {
                  float _grassWeather2 = saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY);
                  _2360 = select(CONTACT_SHADOW_QUALITY > 0.5f, lerp(0.018f, 0.05f, _grassWeather2), 0.09f);
                } else {
                  _2360 = select(CONTACT_SHADOW_QUALITY > 0.5f, 0.12f, 0.30000001192092896f);
                }
              }
            } else {
              if (!(_2282 == 11)) {
                __defer_2339_2358 = true;
              } else {
                _2360 = 0.10000000149011612f;
              }
            }
            if (__defer_2339_2358) {
              _2360 = 0.0f;
            }
            float _2362 = saturate(_2289 * 0.015625f);
            float _2365 = (1.0f - _2362) + (_2362 * _2360);
            if (_166) {
              _2376 = saturate((-0.0f - _2292) / (_2261 * 0.004654859658330679f));
            } else {
              _2376 = 1.0f;
            }
            _2383 = _2282;
            _2384 = saturate(((saturate(1.0f - ((_2365 * _2365) * _2360)) * (1.0f - _2267)) * _2376) + _2267);
            // RenoDX: Weather adaptive grass shadow contribution
            if (CONTACT_SHADOW_QUALITY > 0.5f && _2282 == 17) {
              float _grassContrib2 = lerp(0.3f, 0.65f, saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY));
              _2384 = lerp(_2267, _2384, _grassContrib2);
            }
          } else {
            _2383 = _2265;
            _2384 = _2267;
          }
          [branch]
          if (_2384 > 0.949999988079071f) {
            if (!_2283) {
              _2414 = (saturate(_2266 / (_2266 - _2285)) - min(_2261, _2284));
            } else {
              _2414 = 0.0f;
            }
            _2424 = _2282;
            _2425 = _2384;
            _2426 = ((_2414 * _2240) + _2262);
            _2427 = ((_2414 * _2242) + _2263);
            _2428 = ((_2414 * _2243) + _2264);
            _2429 = _2281;
          } else {
            if ((uint)_2259 < ((uint)7)) {
              _2406 = (_2261 + _2284);
              _2407 = (_2262 + (_2284 * _2240));
              _2408 = (_2263 + (_2284 * _2242));
              _2409 = (_2264 + (_2284 * _2243));
              _2410 = min(abs(_2243), _2285);
            } else {
              _2406 = _2261;
              _2407 = _2262;
              _2408 = _2263;
              _2409 = _2264;
              _2410 = _2266;
            }
            int _2411 = _2259 + 1;
            if ((uint)_2411 < ((uint)8)) {
              _2259 = _2411;
              _2260 = _2284;
              _2261 = _2406;
              _2262 = _2407;
              _2263 = _2408;
              _2264 = _2409;
              _2265 = _2383;
              _2266 = _2410;
              _2267 = _2384;
              continue;
            } else {
              _2424 = _2383;
              _2425 = _2384;
              _2426 = 0.0f;
              _2427 = 0.0f;
              _2428 = -1.0f;
              _2429 = 0.0f;
            }
          }
          break;
        }
      }
      bool _2433 = (_2425 > 0.0f);
      if (_2428 > 0.0f) {
        if ((_2433) | (((int)((((int)(((int)(_2426 >= 0.0f)) & ((int)(_2426 <= 1.0f))))) & (((int)(((int)(_2427 >= 0.0f)) & ((int)(_2427 <= 1.0f))))))))) {
          float _2447 = (_2426 * 2.0f) + -1.0f;
          float _2448 = 1.0f - (_2427 * 2.0f);
          float _2464 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _2428, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _2448, (_2447 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
          bool __defer_2444_2489 = false;
          if (!(_2424 == 2)) {
            if (!(_2424 == 3)) {
              if (!(_2424 == 21)) {
                bool _2483 = (_2424 == 22);
                if (!(((int)(_74 == 22)) & (_2483))) {
                  _2490 = select(_2483, 0.0f, 1.0f);
                  __defer_2444_2489 = true;
                } else {
                  _2492 = 20.0f;
                }
              } else {
                if (!(_74 == 21)) {
                  _2490 = 0.0f;
                  __defer_2444_2489 = true;
                } else {
                  _2492 = 20.0f;
                }
              }
            } else {
              _2490 = 0.0f;
              __defer_2444_2489 = true;
            }
          } else {
            if (!(_74 == 2)) {
              _2490 = 0.0f;
              __defer_2444_2489 = true;
            } else {
              _2492 = 20.0f;
            }
          }
          if (__defer_2444_2489) {
            _2492 = _2490;
          }
          if (_2425 == 1.0f) {
            _2515 = saturate(((((_1756 * 0.9375f) - max(0.0f, dot(float3(_1731, _1735, _1739), float3((((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _2428, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _2448, (_2447 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _2464) - _1835), (((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _2428, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _2448, (_2447 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _2464) - _1836), (((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _2428, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _2448, (_2447 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _2464) - _1837))))) * ((_109 * 0.015625f) + 1.5f)) / _1756) * 0.9375f);
          } else {
            _2515 = _2425;
          }
          float _2516 = _2515 * saturate(exp2(min(0.0f, (((_109 * 0.01899999938905239f) + 0.10000000149011612f) + (_2492 * ((_nearFarProj.x / max(1.0000000116860974e-07f, _2429)) - (_nearFarProj.x / max(1.0000000116860974e-07f, _2428)))))) * 1.4426950216293335f));
          int _2517 = _2424 & -2;
          bool __defer_2514_2527 = false;
          if (!(_2517 == 6)) {
            bool __defer_2519_2529 = false;
            if ((((_74 == 33) && (_2424 == 33)) || (!(_74 == 33) && (((int)(_74 == 55)) & ((int)(_2424 == 55)))))) {
              __defer_2514_2527 = true;
            } else {
              __defer_2519_2529 = true;
            }
            if (__defer_2519_2529) {
              bool __defer_2529_2580 = false;
              if (!(((int)(_2424 == 54)) | ((int)(_2517 == 66))) || ((((int)(_2424 == 54)) | ((int)(_2517 == 66))) && (!(((int)(_1626 == 66)) | ((int)(_74 == 54)))))) {
                __defer_2529_2580 = true;
              } else {
                uint4 _2543 = __3__36__0__0__g_baseColor.Load(int3(int(_2426 * _bufferSizeAndInvSize.x), int(_2427 * _bufferSizeAndInvSize.y), 0));
                float _2549 = float((uint)((uint)(((uint)((uint)(_2543.x)) >> 8) & 255))) * 0.003921568859368563f;
                float _2552 = float((uint)((uint)(_2543.x & 255))) * 0.003921568859368563f;
                float _2556 = float((uint)((uint)(((uint)((uint)(_2543.y)) >> 8) & 255))) * 0.003921568859368563f;
                float _2557 = _2549 * _2549;
                float _2558 = _2552 * _2552;
                float _2559 = _2556 * _2556;
                _2591 = (saturate(1.0f - (dot(float3((((_2557 * 0.6131200194358826f) + (_2558 * 0.3395099937915802f)) + (_2559 * 0.047370001673698425f)), (((_2557 * 0.07020000368356705f) + (_2558 * 0.9163600206375122f)) + (_2559 * 0.013450000435113907f)), (((_2557 * 0.02061999961733818f) + (_2558 * 0.10958000272512436f)) + (_2559 * 0.8697999715805054f))), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.875f)) * _2516);
              }
              if (__defer_2529_2580) {
                if (!_166) {
                  if ((uint)((int)(_2424 + -53u)) < (uint)15) {
                    _2588 = saturate(_109 * 0.03125f);
                  } else {
                    _2588 = 1.0f;
                  }
                  _2591 = (_2588 * _2516);
                } else {
                  _2591 = _2516;
                }
              }
            }
          } else {
            __defer_2514_2527 = true;
          }
          if (__defer_2514_2527) {
            _2591 = (_2516 * 0.009999999776482582f);
          }
        } else {
          _2591 = 0.0f;
        }
      } else {
        if (_2433) {
          float _2447 = (_2426 * 2.0f) + -1.0f;
          float _2448 = 1.0f - (_2427 * 2.0f);
          float _2464 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _2428, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _2448, (_2447 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
          bool __defer_2444_2489 = false;
          if (!(_2424 == 2)) {
            if (!(_2424 == 3)) {
              if (!(_2424 == 21)) {
                bool _2483 = (_2424 == 22);
                if (!(((int)(_74 == 22)) & (_2483))) {
                  _2490 = select(_2483, 0.0f, 1.0f);
                  __defer_2444_2489 = true;
                } else {
                  _2492 = 20.0f;
                }
              } else {
                if (!(_74 == 21)) {
                  _2490 = 0.0f;
                  __defer_2444_2489 = true;
                } else {
                  _2492 = 20.0f;
                }
              }
            } else {
              _2490 = 0.0f;
              __defer_2444_2489 = true;
            }
          } else {
            if (!(_74 == 2)) {
              _2490 = 0.0f;
              __defer_2444_2489 = true;
            } else {
              _2492 = 20.0f;
            }
          }
          if (__defer_2444_2489) {
            _2492 = _2490;
          }
          if (_2425 == 1.0f) {
            _2515 = saturate(((((_1756 * 0.9375f) - max(0.0f, dot(float3(_1731, _1735, _1739), float3((((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _2428, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _2448, (_2447 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _2464) - _1835), (((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _2428, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _2448, (_2447 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _2464) - _1836), (((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _2428, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _2448, (_2447 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _2464) - _1837))))) * ((_109 * 0.015625f) + 1.5f)) / _1756) * 0.9375f);
          } else {
            _2515 = _2425;
          }
          float _2516 = _2515 * saturate(exp2(min(0.0f, (((_109 * 0.01899999938905239f) + 0.10000000149011612f) + (_2492 * ((_nearFarProj.x / max(1.0000000116860974e-07f, _2429)) - (_nearFarProj.x / max(1.0000000116860974e-07f, _2428)))))) * 1.4426950216293335f));
          int _2517 = _2424 & -2;
          bool __defer_2514_2527 = false;
          if (!(_2517 == 6)) {
            bool __defer_2519_2529 = false;
            if ((((_74 == 33) && (_2424 == 33)) || (!(_74 == 33) && (((int)(_74 == 55)) & ((int)(_2424 == 55)))))) {
              __defer_2514_2527 = true;
            } else {
              __defer_2519_2529 = true;
            }
            if (__defer_2519_2529) {
              bool __defer_2529_2580 = false;
              if (!(((int)(_2424 == 54)) | ((int)(_2517 == 66))) || ((((int)(_2424 == 54)) | ((int)(_2517 == 66))) && (!(((int)(_1626 == 66)) | ((int)(_74 == 54)))))) {
                __defer_2529_2580 = true;
              } else {
                uint4 _2543 = __3__36__0__0__g_baseColor.Load(int3(int(_2426 * _bufferSizeAndInvSize.x), int(_2427 * _bufferSizeAndInvSize.y), 0));
                float _2549 = float((uint)((uint)(((uint)((uint)(_2543.x)) >> 8) & 255))) * 0.003921568859368563f;
                float _2552 = float((uint)((uint)(_2543.x & 255))) * 0.003921568859368563f;
                float _2556 = float((uint)((uint)(((uint)((uint)(_2543.y)) >> 8) & 255))) * 0.003921568859368563f;
                float _2557 = _2549 * _2549;
                float _2558 = _2552 * _2552;
                float _2559 = _2556 * _2556;
                _2591 = (saturate(1.0f - (dot(float3((((_2557 * 0.6131200194358826f) + (_2558 * 0.3395099937915802f)) + (_2559 * 0.047370001673698425f)), (((_2557 * 0.07020000368356705f) + (_2558 * 0.9163600206375122f)) + (_2559 * 0.013450000435113907f)), (((_2557 * 0.02061999961733818f) + (_2558 * 0.10958000272512436f)) + (_2559 * 0.8697999715805054f))), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.875f)) * _2516);
              }
              if (__defer_2529_2580) {
                if (!_166) {
                  if ((uint)((int)(_2424 + -53u)) < (uint)15) {
                    _2588 = saturate(_109 * 0.03125f);
                  } else {
                    _2588 = 1.0f;
                  }
                  _2591 = (_2588 * _2516);
                } else {
                  _2591 = _2516;
                }
              }
            }
          } else {
            __defer_2514_2527 = true;
          }
          if (__defer_2514_2527) {
            _2591 = (_2516 * 0.009999999776482582f);
          }
        } else {
          _2591 = 0.0f;
        }
      }
      _2595 = saturate(1.0f - _2591);
    } else {
      _2595 = 1.0f;
    }

    // ── Micro Detail Depth-Bias Shadows ───────────────────────────────
    #define MICRO_PIXEL_X_FLOAT   _54
    #define MICRO_PIXEL_Y_FLOAT   _55
    #define MICRO_LINEAR_DEPTH    _109
    #define MICRO_CONTACT_SHADOW  _2595
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
    //
    // We fade contact shadows near screen edges to hide the abrupt cutoff
    // that causes screenspace artefacts
    if (CONTACT_SHADOW_QUALITY > 0.5f && _2595 < 1.0f) {
      float2 _screenUV = float2((_54 + 0.5f) * _bufferSizeAndInvSize.z,
                                 (_55 + 0.5f) * _bufferSizeAndInvSize.w);
      float2 _edgeDist = min(_screenUV, 1.0f - _screenUV);
      float _edgeFade = saturate(min(_edgeDist.x, _edgeDist.y) * 10.0f);
      _2595 = lerp(lerp(1.0f, _2595, 0.5f), _2595, _edgeFade);
    }

    float _2596 = min(_1616, _2595);
    _2610 = float(half(_2596 * float(_1592)));
    _2611 = float(half(_2596 * float(_1593)));
    _2612 = float(half(_2596 * float(_1594)));
    _2613 = saturate((1.0f - _550) + (exp2(log2(saturate(select(_166, (_1601 + 0.9800000190734863f), _1601))) * 0.45454543828964233f) * _550));
    // ── RenoDX Shadow Debug ──────────────────────────────────────────────
    #include "shadow_debug_night.hlsli"
    // ────────────────────────────────────────────────────────────────────
  }
  __3__38__0__1__g_shadowColorResultUAV[int2(_52, _53)] = half4((float)(half(_2610)), (float)(half(_2611)), (float)(half(_2612)), (float)(half(_2613)));
}
