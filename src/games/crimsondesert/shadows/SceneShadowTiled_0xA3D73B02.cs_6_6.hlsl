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

#define SHADOW_DBG_CONTACT_INV  _3060
#define SHADOW_DBG_OUT_R        _3075
#define SHADOW_DBG_OUT_G        _3076
#define SHADOW_DBG_OUT_B        _3077
#define SHADOW_DBG_OUT_A        _3078

Texture2D<float4> __3__36__0__0__g_terrainShadowDepth : register(t155, space36);

Texture2DArray<float4> __3__36__0__0__g_dynamicShadowDepthArray : register(t229, space36);

Texture2DArray<half4> __3__36__0__0__g_dynamicShadowColorArray : register(t231, space36);

Texture2DArray<float4> __3__36__0__0__g_shadowDepthArray : register(t232, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t14, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t31, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t50, space36);

Texture2D<float> __3__36__0__0__g_nearFieldShadowDepth : register(t73, space36);

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

cbuffer __3__35__0__0__NearFieldShadowConstantBuffer : register(b43, space35) {
  float4 _nearFieldShadowBoundsMin : packoffset(c000.x);
  float4 _nearFieldShadowBoundsMax : packoffset(c001.x);
  column_major float4x4 _nearFieldShadowViewProjCompacted : packoffset(c002.x);
};

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _shadowAOParams : packoffset(c000.x);
  float4 _tiledRadianceCacheParams : packoffset(c001.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

SamplerComparisonState __3__40__0__0__g_samplerShadow : register(s0, space40);

static const float _global_0[32] = { -7.0f, -8.0f, 0.0f, -7.0f, -4.0f, -6.0f, 3.0f, -5.0f, 7.0f, -4.0f, -1.0f, -3.0f, -5.0f, -2.0f, 4.0f, -1.0f, -8.0f, 0.0f, 1.0f, 1.0f, -3.0f, 2.0f, 5.0f, 3.0f, -6.0f, 4.0f, 2.0f, 5.0f, -2.0f, 6.0f, 6.0f, 7.0f };

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int _18[4];
  float _27[2];
  float _28[2];
  float _29[2];
  _18[0] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).x));
  _18[1] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).y));
  _18[2] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).z));
  _18[3] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).w));
  int _43 = _18[(((uint)(SV_GroupID.x) >> 4) & 3)];
  uint _55 = ((uint)(((((int)(_43 << 2)) & 262140) | ((int)(SV_GroupID.x) & 3)) << 3)) + SV_GroupThreadID.x;
  uint _56 = ((uint)(((((uint)(_43) >> 16) << 2) | (((uint)(SV_GroupID.x) >> 2) & 3)) << 3)) + SV_GroupThreadID.y;
  float _57 = float((uint)_55);
  float _58 = float((uint)_56);
  float _66 = ((_bufferSizeAndInvSize.z * 2.0f) * (_57 + 0.5f)) + -1.0f;
  float _69 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (_58 + 0.5f));
  uint _71 = __3__36__0__0__g_depthStencil.Load(int3(_55, _56, 0));
  int _73 = (uint)((uint)(_71.x)) >> 24;
  float _76 = float((uint)((uint)(_71.x & 16777215))) * 5.960465188081798e-08f;
  int _77 = _73 & 127;
  uint _79 = __3__36__0__0__g_sceneNormal.Load(int3(_55, _56, 0));
  float _95 = min(1.0f, ((float((uint)((uint)(_79.x & 1023))) * 0.001956947147846222f) + -1.0f));
  float _96 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_79.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _97 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_79.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _99 = rsqrt(dot(float3(_95, _96, _97), float3(_95, _96, _97)));
  float _100 = _99 * _95;
  float _101 = _99 * _96;
  float _102 = _99 * _97;
  bool _104 = (_76 == 1.0f);
  int _374;
  float _553;
  float _627;
  int _628;
  float _629;
  float _693;
  int _694;
  int _695;
  float _696;
  float _758;
  int _759;
  int _760;
  float _809;
  int _810;
  int _811;
  int _970;
  int _1490;
  float _1593;
  float _1594;
  half _1595;
  half _1596;
  half _1597;
  float _1674;
  float _1675;
  float _1676;
  int _1721;
  int _1757;
  float _1771;
  float _1784;
  int _1785;
  float _1876;
  float _1877;
  float _1878;
  float _1880;
  int _1881;
  float _1921;
  float _1922;
  float _1965;
  float _1966;
  float _1967;
  float _2077;
  int _2249;
  float _2255;
  float _2268;
  float _2281;
  float _2291;
  float _2292;
  float _2293;
  float _2052;
  float _2056;
  float _2060;
  int _2435;
  float _2436;
  float _2437;
  float _2438;
  float _2439;
  float _2440;
  int _2441;
  float _2442;
  float _2443;
  bool _2506;
  int _2513;
  float _2536;
  int _2551;
  float _2552;
  float _2574;
  float _2575;
  float _2576;
  float _2577;
  float _2578;
  float _2582;
  int _2709;
  float _2710;
  float _2711;
  float _2712;
  float _2713;
  float _2714;
  int _2715;
  float _2716;
  float _2717;
  bool _2780;
  int _2787;
  float _2810;
  int _2825;
  float _2826;
  float _2848;
  float _2849;
  float _2850;
  float _2851;
  float _2852;
  float _2856;
  int _2866;
  float _2867;
  float _2868;
  float _2869;
  float _2870;
  float _2871;
  float _2952;
  float _2954;
  float _2977;
  float _3053;
  float _3056;
  float _3060;
  float _3075;
  float _3076;
  float _3077;
  float _3078;
  if (((int)(_76 < 1.0000000116860974e-07f)) | (_104)) {
    float _107 = select(_104, 0.0f, 1.0f);
    _3075 = _107;
    _3076 = _107;
    _3077 = _107;
    _3078 = _107;
  } else {
    float _111 = max(1.0000000116860974e-07f, _76);
    float _112 = _nearFarProj.x / _111;
    float _148 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _111, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _69, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _66))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
    float _149 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _111, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _69, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _66))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _148;
    float _150 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _111, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _69, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _66))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _148;
    float _151 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _111, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _69, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _66))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _148;
    float _153 = rsqrt(dot(float3(_149, _150, _151), float3(_149, _150, _151)));
    _27[0] = 0.0f;
    _28[0] = 0.0f;
    _29[0] = 0.0f;
    _27[1] = 0.0f;
    _28[1] = 0.0f;
    _29[1] = 0.0f;
    bool _169 = ((int)(_77 == 57)) | ((int)((uint)(_77 + -53) < (uint)15));
    float _189 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).x), _151, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).x), _150, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).x) * _149))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).x);
    float _193 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).y), _151, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).y), _150, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).y) * _149))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).y);
    float _197 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).z), _151, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).z), _150, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).z) * _149))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).z);
    if (saturate(_189) == _189) {
      if (((int)(_197 >= 9.999999747378752e-05f)) & (((int)(((int)(_197 <= 1.0f)) & ((int)(saturate(_193) == _193)))))) {
        float _208 = float((uint)((uint)(int4(_frameNumber).x)));
        float _219 = (frac(((_208 * 92.0f) + _57) * 0.0078125f) * 128.0f) + -64.34062194824219f;
        float _220 = (frac(((_208 * 71.0f) + _58) * 0.0078125f) * 128.0f) + -72.46562194824219f;
        float _225 = frac(dot(float3((_219 * _219), (_220 * _220), (_220 * _219)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
        uint _241 = ((uint)((((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524))) + uint((_58 * _bufferSizeAndInvSize.x) + _57);
        uint _249 = ((uint)((((int)((_241 << 4) + -1383041155u)) ^ ((int)(_241 + -1640531527u))) ^ ((int)(((uint)((uint)(_241) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
        uint _257 = ((uint)((((int)((_249 << 4) + -1556008596u)) ^ ((int)(_249 + 1013904242u))) ^ (((uint)(_249) >> 5) + -939442524))) + _241;
        uint _265 = ((uint)((((int)((_257 << 4) + -1383041155u)) ^ ((int)(_257 + 1013904242u))) ^ ((int)(((uint)((uint)(_257) >> 5)) + 2123724318u)))) + _249;
        uint _273 = ((uint)((((int)((_265 << 4) + -1556008596u)) ^ ((int)(_265 + -626627285u))) ^ (((uint)(_265) >> 5) + -939442524))) + _257;
        uint _281 = ((uint)((((int)((_273 << 4) + -1383041155u)) ^ ((int)(_273 + -626627285u))) ^ ((int)(((uint)((uint)(_273) >> 5)) + 2123724318u)))) + _265;
        uint _289 = ((uint)((((int)((_281 << 4) + -1556008596u)) ^ ((int)(_281 + 2027808484u))) ^ (((uint)(_281) >> 5) + -939442524))) + _273;
        uint _297 = ((uint)((((int)((_289 << 4) + -1383041155u)) ^ ((int)(_289 + 2027808484u))) ^ ((int)(((uint)((uint)(_289) >> 5)) + 2123724318u)))) + _281;
        uint _305 = ((uint)((((int)((_297 << 4) + -1556008596u)) ^ ((int)(_297 + 387276957u))) ^ (((uint)(_297) >> 5) + -939442524))) + _289;
        uint _313 = ((uint)((((int)((_305 << 4) + -1383041155u)) ^ ((int)(_305 + 387276957u))) ^ ((int)(((uint)((uint)(_305) >> 5)) + 2123724318u)))) + _297;
        uint _321 = ((uint)((((int)((_313 << 4) + -1556008596u)) ^ ((int)(_313 + -1253254570u))) ^ (((uint)(_313) >> 5) + -939442524))) + _305;
        uint _329 = ((uint)((((int)((_321 << 4) + -1383041155u)) ^ ((int)(_321 + -1253254570u))) ^ ((int)(((uint)((uint)(_321) >> 5)) + 2123724318u)))) + _313;
        uint _337 = ((uint)((((int)((_329 << 4) + -1556008596u)) ^ ((int)(_329 + 1401181199u))) ^ (((uint)(_329) >> 5) + -939442524))) + _321;
        uint _345 = ((uint)((((int)((_337 << 4) + -1383041155u)) ^ ((int)(_337 + 1401181199u))) ^ ((int)(((uint)((uint)(_337) >> 5)) + 2123724318u)))) + _329;
        uint _353 = ((uint)((((int)((_345 << 4) + -1556008596u)) ^ ((int)(_345 + -239350328u))) ^ (((uint)(_345) >> 5) + -939442524))) + _337;
        uint _361 = ((uint)((((int)((_353 << 4) + -1383041155u)) ^ ((int)(_353 + -239350328u))) ^ ((int)(((uint)((uint)(_353) >> 5)) + 2123724318u)))) + _345;
        if ((_353 & 16777215) == 0) {
          _374 = ((int)(((uint)((((int)((_361 << 4) + -1556008596u)) ^ ((int)(_361 + -1879881855u))) ^ (((uint)(_361) >> 5) + -939442524))) + _353));
        } else {
          _374 = _353;
        }
        uint _379 = uint(float((uint)((uint)(((int)(_374 * 48271)) & 16777215))) * 3.814637693722034e-06f);
        float _386 = frac((float((uint)_379) * 0.015625f) + (float((uint)((uint)((int)(uint(_225 * 51540816.0f)) & 65535))) * 1.52587890625e-05f));
        float _392 = (_386 * 2.0f) + -1.0f;
        float _393 = (float((uint)((uint)(reversebits(_379) ^ (int)(uint(_225 * 287478368.0f))))) * 4.656612873077393e-10f) + -1.0f;
        float _395 = rsqrt(dot(float2(_392, _393), float2(_392, _393)));
        float _402 = ((_386 * 0.0009765625f) + -0.00048828125f) * _395;
        float _404 = (_393 * _395) * 0.00048828125f;
        float _406 = (_402 * ((_jitterOffset[0]).x)) + _189;
        float _407 = (_404 * ((_jitterOffset[0]).y)) + _193;
        float _412 = frac((_406 * 1024.0f) + -0.5f);
        float4 _416 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_406, _407));
        float _421 = _197 + -0.004999999888241291f;
        float _426 = select((_416.w > _421), 1.0f, 0.0f);
        float _428 = select((_416.x > _421), 1.0f, 0.0f);
        float _435 = ((select((_416.z > _421), 1.0f, 0.0f) - _426) * _412) + _426;
        float _445 = (((_jitterOffset[1]).x) * _402) + _189;
        float _446 = (((_jitterOffset[1]).y) * _404) + _193;
        float _451 = frac((_445 * 1024.0f) + -0.5f);
        float4 _453 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_445, _446));
        float _462 = select((_453.w > _421), 1.0f, 0.0f);
        float _464 = select((_453.x > _421), 1.0f, 0.0f);
        float _471 = ((select((_453.z > _421), 1.0f, 0.0f) - _462) * _451) + _462;
        float _482 = (((_jitterOffset[2]).x) * _402) + _189;
        float _483 = (((_jitterOffset[2]).y) * _404) + _193;
        float _488 = frac((_482 * 1024.0f) + -0.5f);
        float4 _490 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_482, _483));
        float _499 = select((_490.w > _421), 1.0f, 0.0f);
        float _501 = select((_490.x > _421), 1.0f, 0.0f);
        float _508 = ((select((_490.z > _421), 1.0f, 0.0f) - _499) * _488) + _499;
        float _519 = (((_jitterOffset[3]).x) * _402) + _189;
        float _520 = (((_jitterOffset[3]).y) * _404) + _193;
        float _525 = frac((_519 * 1024.0f) + -0.5f);
        float4 _527 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_519, _520));
        float _536 = select((_527.w > _421), 1.0f, 0.0f);
        float _538 = select((_527.x > _421), 1.0f, 0.0f);
        float _545 = ((select((_527.z > _421), 1.0f, 0.0f) - _536) * _525) + _536;
        _553 = ((((saturate((((((select((_453.y > _421), 1.0f, 0.0f) - _464) * _451) + _464) - _471) * frac((_446 * 1024.0f) + -0.5f)) + _471) + saturate((((((select((_416.y > _421), 1.0f, 0.0f) - _428) * _412) + _428) - _435) * frac((_407 * 1024.0f) + -0.5f)) + _435)) + saturate((((((select((_490.y > _421), 1.0f, 0.0f) - _501) * _488) + _501) - _508) * frac((_483 * 1024.0f) + -0.5f)) + _508)) + saturate((((((select((_527.y > _421), 1.0f, 0.0f) - _538) * _525) + _538) - _545) * frac((_520 * 1024.0f) + -0.5f)) + _545)) * 0.25f);
      } else {
        _553 = 1.0f;
      }
    } else {
      _553 = 1.0f;
    }
    float _561 = sqrt(((_150 * _150) + (_149 * _149)) + (_151 * _151));
    float _581 = mad((float4(_dynamicShadowProjRelativeTexScale[1][0].z, _dynamicShadowProjRelativeTexScale[1][1].z, _dynamicShadowProjRelativeTexScale[1][2].z, _dynamicShadowProjRelativeTexScale[1][3].z).x), _151, mad((float4(_dynamicShadowProjRelativeTexScale[1][0].y, _dynamicShadowProjRelativeTexScale[1][1].y, _dynamicShadowProjRelativeTexScale[1][2].y, _dynamicShadowProjRelativeTexScale[1][3].y).x), _150, ((float4(_dynamicShadowProjRelativeTexScale[1][0].x, _dynamicShadowProjRelativeTexScale[1][1].x, _dynamicShadowProjRelativeTexScale[1][2].x, _dynamicShadowProjRelativeTexScale[1][3].x).x) * _149))) + (float4(_dynamicShadowProjRelativeTexScale[1][0].w, _dynamicShadowProjRelativeTexScale[1][1].w, _dynamicShadowProjRelativeTexScale[1][2].w, _dynamicShadowProjRelativeTexScale[1][3].w).x);
    float _585 = mad((float4(_dynamicShadowProjRelativeTexScale[1][0].z, _dynamicShadowProjRelativeTexScale[1][1].z, _dynamicShadowProjRelativeTexScale[1][2].z, _dynamicShadowProjRelativeTexScale[1][3].z).y), _151, mad((float4(_dynamicShadowProjRelativeTexScale[1][0].y, _dynamicShadowProjRelativeTexScale[1][1].y, _dynamicShadowProjRelativeTexScale[1][2].y, _dynamicShadowProjRelativeTexScale[1][3].y).y), _150, ((float4(_dynamicShadowProjRelativeTexScale[1][0].x, _dynamicShadowProjRelativeTexScale[1][1].x, _dynamicShadowProjRelativeTexScale[1][2].x, _dynamicShadowProjRelativeTexScale[1][3].x).y) * _149))) + (float4(_dynamicShadowProjRelativeTexScale[1][0].w, _dynamicShadowProjRelativeTexScale[1][1].w, _dynamicShadowProjRelativeTexScale[1][2].w, _dynamicShadowProjRelativeTexScale[1][3].w).y);
    float _589 = mad((float4(_dynamicShadowProjRelativeTexScale[1][0].z, _dynamicShadowProjRelativeTexScale[1][1].z, _dynamicShadowProjRelativeTexScale[1][2].z, _dynamicShadowProjRelativeTexScale[1][3].z).z), _151, mad((float4(_dynamicShadowProjRelativeTexScale[1][0].y, _dynamicShadowProjRelativeTexScale[1][1].y, _dynamicShadowProjRelativeTexScale[1][2].y, _dynamicShadowProjRelativeTexScale[1][3].y).z), _150, ((float4(_dynamicShadowProjRelativeTexScale[1][0].x, _dynamicShadowProjRelativeTexScale[1][1].x, _dynamicShadowProjRelativeTexScale[1][2].x, _dynamicShadowProjRelativeTexScale[1][3].x).z) * _149))) + (float4(_dynamicShadowProjRelativeTexScale[1][0].w, _dynamicShadowProjRelativeTexScale[1][1].w, _dynamicShadowProjRelativeTexScale[1][2].w, _dynamicShadowProjRelativeTexScale[1][3].w).z);
    float _590 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
    float _591 = 1.0f - _590;
    if (!((((int)((((int)(!(_581 <= _591)))) | (((int)(!(_581 >= _590))))))) | (((int)(!(_585 <= _591)))))) {
      if (((int)(_561 < 128.0f)) & (((int)(((int)(_589 >= -1.0f)) & (((int)(((int)(_589 <= 1.0f)) & ((int)(_585 >= _590))))))))) {
        float _616 = max(0.0f, ((abs((_581 * 2.0f) + -1.0f) + -0.8999999761581421f) * 10.0f));
        float _617 = max(0.0f, ((abs((_585 * 2.0f) + -1.0f) + -0.8999999761581421f) * 10.0f));
        _27[1] = _581;
        _28[1] = _585;
        _29[1] = _589;
        _627 = select((_terrainNormalParams.y > 0.0f), 1.9999999494757503e-05f, 7.999999797903001e-05f);
        _628 = 1;
        _629 = sqrt((_617 * _617) + (_616 * _616));
      } else {
        _627 = 0.0f;
        _628 = 0;
        _629 = 0.0f;
      }
    } else {
      _627 = 0.0f;
      _628 = 0;
      _629 = 0.0f;
    }
    float _649 = mad((float4(_dynamicShadowProjRelativeTexScale[0][0].z, _dynamicShadowProjRelativeTexScale[0][1].z, _dynamicShadowProjRelativeTexScale[0][2].z, _dynamicShadowProjRelativeTexScale[0][3].z).x), _151, mad((float4(_dynamicShadowProjRelativeTexScale[0][0].y, _dynamicShadowProjRelativeTexScale[0][1].y, _dynamicShadowProjRelativeTexScale[0][2].y, _dynamicShadowProjRelativeTexScale[0][3].y).x), _150, ((float4(_dynamicShadowProjRelativeTexScale[0][0].x, _dynamicShadowProjRelativeTexScale[0][1].x, _dynamicShadowProjRelativeTexScale[0][2].x, _dynamicShadowProjRelativeTexScale[0][3].x).x) * _149))) + (float4(_dynamicShadowProjRelativeTexScale[0][0].w, _dynamicShadowProjRelativeTexScale[0][1].w, _dynamicShadowProjRelativeTexScale[0][2].w, _dynamicShadowProjRelativeTexScale[0][3].w).x);
    float _653 = mad((float4(_dynamicShadowProjRelativeTexScale[0][0].z, _dynamicShadowProjRelativeTexScale[0][1].z, _dynamicShadowProjRelativeTexScale[0][2].z, _dynamicShadowProjRelativeTexScale[0][3].z).y), _151, mad((float4(_dynamicShadowProjRelativeTexScale[0][0].y, _dynamicShadowProjRelativeTexScale[0][1].y, _dynamicShadowProjRelativeTexScale[0][2].y, _dynamicShadowProjRelativeTexScale[0][3].y).y), _150, ((float4(_dynamicShadowProjRelativeTexScale[0][0].x, _dynamicShadowProjRelativeTexScale[0][1].x, _dynamicShadowProjRelativeTexScale[0][2].x, _dynamicShadowProjRelativeTexScale[0][3].x).y) * _149))) + (float4(_dynamicShadowProjRelativeTexScale[0][0].w, _dynamicShadowProjRelativeTexScale[0][1].w, _dynamicShadowProjRelativeTexScale[0][2].w, _dynamicShadowProjRelativeTexScale[0][3].w).y);
    float _657 = mad((float4(_dynamicShadowProjRelativeTexScale[0][0].z, _dynamicShadowProjRelativeTexScale[0][1].z, _dynamicShadowProjRelativeTexScale[0][2].z, _dynamicShadowProjRelativeTexScale[0][3].z).z), _151, mad((float4(_dynamicShadowProjRelativeTexScale[0][0].y, _dynamicShadowProjRelativeTexScale[0][1].y, _dynamicShadowProjRelativeTexScale[0][2].y, _dynamicShadowProjRelativeTexScale[0][3].y).z), _150, ((float4(_dynamicShadowProjRelativeTexScale[0][0].x, _dynamicShadowProjRelativeTexScale[0][1].x, _dynamicShadowProjRelativeTexScale[0][2].x, _dynamicShadowProjRelativeTexScale[0][3].x).z) * _149))) + (float4(_dynamicShadowProjRelativeTexScale[0][0].w, _dynamicShadowProjRelativeTexScale[0][1].w, _dynamicShadowProjRelativeTexScale[0][2].w, _dynamicShadowProjRelativeTexScale[0][3].w).z);
    if (!((((int)((((int)(!(_649 >= _590)))) | (((int)(!(_649 <= _591))))))) | (((int)(!(_653 <= _591)))))) {
      if (((int)(_561 < 128.0f)) & (((int)(((int)(_657 >= -1.0f)) & (((int)(((int)(_653 >= _590)) & ((int)(_657 <= 1.0f))))))))) {
        float _682 = max(0.0f, ((abs((_649 * 2.0f) + -1.0f) + -0.8999999761581421f) * 10.0f));
        float _683 = max(0.0f, ((abs((_653 * 2.0f) + -1.0f) + -0.8999999761581421f) * 10.0f));
        _27[0] = _649;
        _28[0] = _653;
        _29[0] = _657;
        _693 = select((_terrainNormalParams.y > 0.0f), 4.999999873689376e-06f, 1.9999999494757503e-05f);
        _694 = 1;
        _695 = 0;
        _696 = sqrt((_683 * _683) + (_682 * _682));
      } else {
        _693 = _627;
        _694 = _628;
        _695 = _628;
        _696 = _629;
      }
    } else {
      _693 = _627;
      _694 = _628;
      _695 = _628;
      _696 = _629;
    }
    bool _697 = (_694 == 0);
    [branch]
    if (_697) {
      float _705 = _viewPos.x + _149;
      float _706 = _viewPos.y + _150;
      float _707 = _viewPos.z + _151;
      float _712 = _705 - ((_staticShadowPosition[1]).x);
      float _713 = _706 - ((_staticShadowPosition[1]).y);
      float _714 = _707 - ((_staticShadowPosition[1]).z);
      float _734 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).x), _714, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).x), _713, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).x) * _712))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).x);
      float _738 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).y), _714, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).y), _713, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).y) * _712))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).y);
      float _742 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).z), _714, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).z), _713, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).z) * _712))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).z);
      float _743 = 2.0f / _shadowSizeAndInvSize.y;
      float _744 = 1.0f - _743;
      if (!((((int)((((int)(!(_734 <= _744)))) | (((int)(!(_734 >= _743))))))) | (((int)(!(_738 <= _744)))))) {
        if (((int)(_742 >= 9.999999747378752e-05f)) & (((int)(((int)(_742 <= 1.0f)) & ((int)(_738 >= _743)))))) {
          _27[1] = _734;
          _28[1] = _738;
          _29[1] = _742;
          _758 = 0.00019999999494757503f;
          _759 = 1;
          _760 = 1;
        } else {
          _758 = _693;
          _759 = 0;
          _760 = _695;
        }
      } else {
        _758 = _693;
        _759 = 0;
        _760 = _695;
      }
      float _765 = _705 - ((_staticShadowPosition[0]).x);
      float _766 = _706 - ((_staticShadowPosition[0]).y);
      float _767 = _707 - ((_staticShadowPosition[0]).z);
      float _787 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).x), _767, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).x), _766, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).x) * _765))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).x);
      float _791 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).y), _767, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).y), _766, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).y) * _765))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).y);
      float _795 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).z), _767, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).z), _766, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).z) * _765))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).z);
      if (!((((int)((((int)(!(_787 >= _743)))) | (((int)(!(_787 <= _744))))))) | (((int)(!(_791 <= _744)))))) {
        if (((int)(_795 >= 9.999999747378752e-05f)) & (((int)(((int)(_791 >= _743)) & ((int)(_795 <= 1.0f)))))) {
          _27[0] = _787;
          _28[0] = _791;
          _29[0] = _795;
          _809 = 0.00019999999494757503f;
          _810 = 1;
          _811 = 0;
        } else {
          _809 = _758;
          _810 = _759;
          _811 = _760;
        }
      } else {
        _809 = _758;
        _810 = _759;
        _811 = _760;
      }
    } else {
      _809 = _693;
      _810 = 1;
      _811 = _695;
    }
    uint _827 = ((uint)((((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524))) + uint((_58 * _bufferSizeAndInvSize.x) + _57);
    uint _835 = ((uint)((((int)((_827 << 4) + -1383041155u)) ^ ((int)(_827 + -1640531527u))) ^ ((int)(((uint)((uint)(_827) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
    uint _843 = ((uint)((((int)((_835 << 4) + -1556008596u)) ^ ((int)(_835 + 1013904242u))) ^ (((uint)(_835) >> 5) + -939442524))) + _827;
    uint _851 = ((uint)((((int)((_843 << 4) + -1383041155u)) ^ ((int)(_843 + 1013904242u))) ^ ((int)(((uint)((uint)(_843) >> 5)) + 2123724318u)))) + _835;
    uint _859 = ((uint)((((int)((_851 << 4) + -1556008596u)) ^ ((int)(_851 + -626627285u))) ^ (((uint)(_851) >> 5) + -939442524))) + _843;
    uint _867 = ((uint)((((int)((_859 << 4) + -1383041155u)) ^ ((int)(_859 + -626627285u))) ^ ((int)(((uint)((uint)(_859) >> 5)) + 2123724318u)))) + _851;
    uint _875 = ((uint)((((int)((_867 << 4) + -1556008596u)) ^ ((int)(_867 + 2027808484u))) ^ (((uint)(_867) >> 5) + -939442524))) + _859;
    uint _883 = ((uint)((((int)((_875 << 4) + -1383041155u)) ^ ((int)(_875 + 2027808484u))) ^ ((int)(((uint)((uint)(_875) >> 5)) + 2123724318u)))) + _867;
    uint _891 = ((uint)((((int)((_883 << 4) + -1556008596u)) ^ ((int)(_883 + 387276957u))) ^ (((uint)(_883) >> 5) + -939442524))) + _875;
    uint _899 = ((uint)((((int)((_891 << 4) + -1383041155u)) ^ ((int)(_891 + 387276957u))) ^ ((int)(((uint)((uint)(_891) >> 5)) + 2123724318u)))) + _883;
    uint _907 = ((uint)((((int)((_899 << 4) + -1556008596u)) ^ ((int)(_899 + -1253254570u))) ^ (((uint)(_899) >> 5) + -939442524))) + _891;
    uint _915 = ((uint)((((int)((_907 << 4) + -1383041155u)) ^ ((int)(_907 + -1253254570u))) ^ ((int)(((uint)((uint)(_907) >> 5)) + 2123724318u)))) + _899;
    uint _923 = ((uint)((((int)((_915 << 4) + -1556008596u)) ^ ((int)(_915 + 1401181199u))) ^ (((uint)(_915) >> 5) + -939442524))) + _907;
    uint _931 = ((uint)((((int)((_923 << 4) + -1383041155u)) ^ ((int)(_923 + 1401181199u))) ^ ((int)(((uint)((uint)(_923) >> 5)) + 2123724318u)))) + _915;
    uint _939 = ((uint)((((int)((_931 << 4) + -1556008596u)) ^ ((int)(_931 + -239350328u))) ^ (((uint)(_931) >> 5) + -939442524))) + _923;
    uint _947 = ((uint)((((int)((_939 << 4) + -1383041155u)) ^ ((int)(_939 + -239350328u))) ^ ((int)(((uint)((uint)(_939) >> 5)) + 2123724318u)))) + _931;
    bool _949 = ((_939 & 16777215) == 0);
    [branch]
    if (!_697) {
      float _953 = _27[_811];
      float _954 = _28[_811];
      float _955 = _29[_811];
      float _957 = select((_811 == 0), 2.5f, 1.25f);
      if (_949) {
        _970 = ((int)(((uint)((((int)((_947 << 4) + -1556008596u)) ^ ((int)(_947 + -1879881855u))) ^ (((uint)(_947) >> 5) + -939442524))) + _939));
      } else {
        _970 = _939;
      }
      float _971 = select(_169, (_957 * 0.75f), _957) * 0.6600000262260437f;
      float _972 = _971 * _dynmaicShadowSizeAndInvSize.z;
      float _973 = _971 * _dynmaicShadowSizeAndInvSize.w;
      float _980 = _972 * 1.1920928955078125e-07f;
      float _982 = _973 * 1.1920928955078125e-07f;
      float _986 = ((float((uint)((uint)(((int)(_970 * 48271)) & 16777215))) * _980) - _972) + _953;
      float _987 = ((float((uint)((uint)(((int)(_970 * -1964877855)) & 16777215))) * _982) - _973) + _954;
      float _988 = float((uint)_811);
      float4 _991 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_986, _987, _988), 0.0f);
      float _995 = _955 - _809;
      float4 _997 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_986, _987, _988), _995);
      half4 _1002 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_986, _987, _988), 0.0f);
      float _1016 = ((float((uint)((uint)(((int)(_970 * -856141137)) & 16777215))) * _980) - _972) + _953;
      float _1017 = ((float((uint)((uint)(((int)(_970 * -613502015)) & 16777215))) * _982) - _973) + _954;
      float4 _1018 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1016, _1017, _988), 0.0f);
      float4 _1022 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1016, _1017, _988), _995);
      half4 _1026 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1016, _1017, _988), 0.0f);
      float _1042 = ((float((uint)((uint)(((int)(_970 * -556260145)) & 16777215))) * _980) - _972) + _953;
      float _1043 = ((float((uint)((uint)(((int)(_970 * 902075297)) & 16777215))) * _982) - _973) + _954;
      float4 _1044 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1042, _1043, _988), 0.0f);
      float4 _1048 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1042, _1043, _988), _995);
      half4 _1052 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1042, _1043, _988), 0.0f);
      float _1068 = ((float((uint)((uint)(((int)(_970 * 1698214639)) & 16777215))) * _980) - _972) + _953;
      float _1069 = ((float((uint)((uint)(((int)(_970 * 773027713)) & 16777215))) * _982) - _973) + _954;
      float4 _1070 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1068, _1069, _988), 0.0f);
      float4 _1074 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1068, _1069, _988), _995);
      half4 _1078 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1068, _1069, _988), 0.0f);
      float _1094 = ((float((uint)((uint)(((int)(_970 * 144866575)) & 16777215))) * _980) - _972) + _953;
      float _1095 = ((float((uint)((uint)(((int)(_970 * 647683937)) & 16777215))) * _982) - _973) + _954;
      float4 _1096 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1094, _1095, _988), 0.0f);
      float4 _1100 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1094, _1095, _988), _995);
      half4 _1104 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1094, _1095, _988), 0.0f);
      float _1120 = ((float((uint)((uint)(((int)(_970 * 1284375343)) & 16777215))) * _980) - _972) + _953;
      float _1121 = ((float((uint)((uint)(((int)(_970 * 229264193)) & 16777215))) * _982) - _973) + _954;
      float4 _1122 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1120, _1121, _988), 0.0f);
      float4 _1126 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1120, _1121, _988), _995);
      half4 _1130 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1120, _1121, _988), 0.0f);
      float _1146 = ((float((uint)((uint)(((int)(_970 * -1318861489)) & 16777215))) * _980) - _972) + _953;
      float _1147 = ((float((uint)((uint)(((int)(_970 * 1537293089)) & 16777215))) * _982) - _973) + _954;
      float4 _1148 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1146, _1147, _988), 0.0f);
      float4 _1152 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1146, _1147, _988), _995);
      half4 _1156 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1146, _1147, _988), 0.0f);
      float _1172 = ((float((uint)((uint)(((int)(_970 * -1770241169)) & 16777215))) * _980) - _972) + _953;
      float _1173 = ((float((uint)((uint)(((int)(_970 * 1357852417)) & 16777215))) * _982) - _973) + _954;
      float4 _1174 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1172, _1173, _988), 0.0f);
      float4 _1178 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1172, _1173, _988), _995);
      half4 _1182 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1172, _1173, _988), 0.0f);
      float _1198 = ((float((uint)((uint)(((int)(_970 * -601883249)) & 16777215))) * _980) - _972) + _953;
      float _1199 = ((float((uint)((uint)(((int)(_970 * 1947444961)) & 16777215))) * _982) - _973) + _954;
      float4 _1200 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1198, _1199, _988), 0.0f);
      float4 _1204 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1198, _1199, _988), _995);
      half4 _1208 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1198, _1199, _988), 0.0f);
      float _1224 = ((float((uint)((uint)(((int)(_970 * 1166504879)) & 16777215))) * _980) - _972) + _953;
      float _1225 = ((float((uint)((uint)(((int)(_970 * 1335763649)) & 16777215))) * _982) - _973) + _954;
      float4 _1226 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1224, _1225, _988), 0.0f);
      float4 _1230 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1224, _1225, _988), _995);
      half4 _1234 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1224, _1225, _988), 0.0f);
      float _1250 = ((float((uint)((uint)(((int)(_970 * -1696913969)) & 16777215))) * _980) - _972) + _953;
      float _1251 = ((float((uint)((uint)(((int)(_970 * 1882071713)) & 16777215))) * _982) - _973) + _954;
      float4 _1252 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1250, _1251, _988), 0.0f);
      float4 _1256 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1250, _1251, _988), _995);
      half4 _1260 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1250, _1251, _988), 0.0f);
      float _1276 = ((float((uint)((uint)(((int)(_970 * -1959554065)) & 16777215))) * _980) - _972) + _953;
      float _1277 = ((float((uint)((uint)(((int)(_970 * -1569511807)) & 16777215))) * _982) - _973) + _954;
      float4 _1278 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1276, _1277, _988), 0.0f);
      float4 _1282 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1276, _1277, _988), _995);
      half4 _1286 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1276, _1277, _988), 0.0f);
      float _1302 = ((float((uint)((uint)(((int)(_970 * 1318665743)) & 16777215))) * _980) - _972) + _953;
      float _1303 = ((float((uint)((uint)(((int)(_970 * 1898753633)) & 16777215))) * _982) - _973) + _954;
      float4 _1304 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1302, _1303, _988), 0.0f);
      float4 _1308 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1302, _1303, _988), _995);
      half4 _1312 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1302, _1303, _988), 0.0f);
      float _1328 = ((float((uint)((uint)(((int)(_970 * 134521903)) & 16777215))) * _980) - _972) + _953;
      float _1329 = ((float((uint)((uint)(((int)(_970 * -483771839)) & 16777215))) * _982) - _973) + _954;
      float4 _1330 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1328, _1329, _988), 0.0f);
      float4 _1334 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1328, _1329, _988), _995);
      half4 _1338 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1328, _1329, _988), 0.0f);
      float _1354 = ((float((uint)((uint)(((int)(_970 * -413252017)) & 16777215))) * _980) - _972) + _953;
      float _1355 = ((float((uint)((uint)(((int)(_970 * 2034977313)) & 16777215))) * _982) - _973) + _954;
      float4 _1356 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1354, _1355, _988), 0.0f);
      float4 _1360 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1354, _1355, _988), _995);
      half4 _1364 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1354, _1355, _988), 0.0f);
      float _1380 = ((float((uint)((uint)(((int)(_970 * 192849007)) & 16777215))) * _980) - _972) + _953;
      float _1381 = ((float((uint)((uint)(((int)(_970 * 1820286465)) & 16777215))) * _982) - _973) + _954;
      float4 _1382 = __3__36__0__0__g_dynamicShadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1380, _1381, _988), 0.0f);
      float4 _1386 = __3__36__0__0__g_dynamicShadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1380, _1381, _988), _995);
      half4 _1390 = __3__36__0__0__g_dynamicShadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1380, _1381, _988), 0.0f);
      float _1396 = (((((((((((((((saturate(1.0f - _1022.x) + saturate(1.0f - _997.x)) + saturate(1.0f - _1048.x)) + saturate(1.0f - _1074.x)) + saturate(1.0f - _1100.x)) + saturate(1.0f - _1126.x)) + saturate(1.0f - _1152.x)) + saturate(1.0f - _1178.x)) + saturate(1.0f - _1204.x)) + saturate(1.0f - _1230.x)) + saturate(1.0f - _1256.x)) + saturate(1.0f - _1282.x)) + saturate(1.0f - _1308.x)) + saturate(1.0f - _1334.x)) + saturate(1.0f - _1360.x)) + saturate(1.0f - _1386.x)) * 0.0625f;
      float _1397 = (((((((((((((((max(0.0f, (_955 - _1018.x)) + max(0.0f, (_955 - _991.x))) + max(0.0f, (_955 - _1044.x))) + max(0.0f, (_955 - _1070.x))) + max(0.0f, (_955 - _1096.x))) + max(0.0f, (_955 - _1122.x))) + max(0.0f, (_955 - _1148.x))) + max(0.0f, (_955 - _1174.x))) + max(0.0f, (_955 - _1200.x))) + max(0.0f, (_955 - _1226.x))) + max(0.0f, (_955 - _1252.x))) + max(0.0f, (_955 - _1278.x))) + max(0.0f, (_955 - _1304.x))) + max(0.0f, (_955 - _1330.x))) + max(0.0f, (_955 - _1356.x))) + max(0.0f, (_955 - _1382.x))) * 0.0625f;
      half _1452 = half(float(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)((float)(_1026.x) + (float)(_1002.x))) + (float)(_1052.x))) + (float)(_1078.x))) + (float)(_1104.x))) + (float)(_1130.x))) + (float)(_1156.x))) + (float)(_1182.x))) + (float)(_1208.x))) + (float)(_1234.x))) + (float)(_1260.x))) + (float)(_1286.x))) + (float)(_1312.x))) + (float)(_1338.x))) + (float)(_1364.x))) + ((float)((float)(_1390.x) * 2.0h))) * 0.05882352963089943f);
      half _1453 = half(float(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)((float)(_1026.y) + (float)(_1002.y))) + (float)(_1052.y))) + (float)(_1078.y))) + (float)(_1104.y))) + (float)(_1130.y))) + (float)(_1156.y))) + (float)(_1182.y))) + (float)(_1208.y))) + (float)(_1234.y))) + (float)(_1260.y))) + (float)(_1286.y))) + (float)(_1312.y))) + (float)(_1338.y))) + (float)(_1364.y))) + ((float)((float)(_1390.y) * 2.0h))) * 0.05882352963089943f);
      half _1454 = half(float(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)(((float)((float)(_1026.z) + (float)(_1002.z))) + (float)(_1052.z))) + (float)(_1078.z))) + (float)(_1104.z))) + (float)(_1130.z))) + (float)(_1156.z))) + (float)(_1182.z))) + (float)(_1208.z))) + (float)(_1234.z))) + (float)(_1260.z))) + (float)(_1286.z))) + (float)(_1312.z))) + (float)(_1338.z))) + (float)(_1364.z))) + ((float)((float)(_1390.z) * 2.0h))) * 0.05882352963089943f);
      if (_811 == 1) {
        float _1457 = float(_1452);
        float _1458 = float(_1453);
        float _1459 = float(_1454);
        float _1460 = -0.0f - _696;
        _1593 = _1396;
        _1594 = _1397;
        _1595 = (float)(half((_1457 + _696) + (_1457 * _1460)));
        _1596 = (float)(half((_1458 + _696) + (_1458 * _1460)));
        _1597 = (float)(half((_1459 + _696) + (_1459 * _1460)));
      } else {
        _1593 = _1396;
        _1594 = _1397;
        _1595 = _1452;
        _1596 = _1453;
        _1597 = _1454;
      }
    } else {
      float _1477 = _27[_811];
      float _1478 = _28[_811];
      float _1479 = _29[_811];
      if (_949) {
        _1490 = ((int)(((uint)((((int)((_947 << 4) + -1556008596u)) ^ ((int)(_947 + -1879881855u))) ^ (((uint)(_947) >> 5) + -939442524))) + _939));
      } else {
        _1490 = _939;
      }
      float _1491 = _shadowSizeAndInvSize.z * 2.0f;
      float _1492 = _shadowSizeAndInvSize.w * 2.0f;
      float _1499 = _shadowSizeAndInvSize.z * 2.384185791015625e-07f;
      float _1501 = _shadowSizeAndInvSize.w * 2.384185791015625e-07f;
      float _1505 = ((float((uint)((uint)(((int)(_1490 * 48271)) & 16777215))) * _1499) - _1491) + _1477;
      float _1506 = ((float((uint)((uint)(((int)(_1490 * -1964877855)) & 16777215))) * _1501) - _1492) + _1478;
      float _1507 = float((uint)_811);
      float4 _1510 = __3__36__0__0__g_shadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1505, _1506, _1507), 0.0f);
      float _1514 = _1479 - _809;
      float4 _1516 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1505, _1506, _1507), _1514);
      float _1530 = ((float((uint)((uint)(((int)(_1490 * -856141137)) & 16777215))) * _1499) - _1491) + _1477;
      float _1531 = ((float((uint)((uint)(((int)(_1490 * -613502015)) & 16777215))) * _1501) - _1492) + _1478;
      float4 _1532 = __3__36__0__0__g_shadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1530, _1531, _1507), 0.0f);
      float4 _1536 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1530, _1531, _1507), _1514);
      float _1552 = ((float((uint)((uint)(((int)(_1490 * -556260145)) & 16777215))) * _1499) - _1491) + _1477;
      float _1553 = ((float((uint)((uint)(((int)(_1490 * 902075297)) & 16777215))) * _1501) - _1492) + _1478;
      float4 _1554 = __3__36__0__0__g_shadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1552, _1553, _1507), 0.0f);
      float4 _1558 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1552, _1553, _1507), _1514);
      float _1574 = ((float((uint)((uint)(((int)(_1490 * 1698214639)) & 16777215))) * _1499) - _1491) + _1477;
      float _1575 = ((float((uint)((uint)(((int)(_1490 * 773027713)) & 16777215))) * _1501) - _1492) + _1478;
      float4 _1576 = __3__36__0__0__g_shadowDepthArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_1574, _1575, _1507), 0.0f);
      float4 _1580 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_1574, _1575, _1507), _1514);
      float _1586 = (((saturate(1.0f - _1536.x) + saturate(1.0f - _1516.x)) + saturate(1.0f - _1558.x)) + saturate(1.0f - _1580.x)) * 0.25f;
      float _1587 = (((max(0.0f, (_1479 - _1532.x)) + max(0.0f, (_1479 - _1510.x))) + max(0.0f, (_1479 - _1554.x))) + max(0.0f, (_1479 - _1576.x))) * 0.25f;
      _1593 = saturate(_1586 * _1586);
      _1594 = saturate(_1587 * _1587);
      _1595 = 1.0h;
      _1596 = 1.0h;
      _1597 = 1.0h;
    }
    bool _1598 = (_810 != 0);
    float _1600 = min(_553, select(_1598, _1593, 1.0f));
    float _1604 = select((_694 != 0), select(_1598, (_1594 * 400.0f), 4e+06f), 1.0f);
    float _1605 = _1604 + 0.9800000190734863f;
    if (_169) {
      [branch]
      if (_nearFieldShadowFlag.x > 0.0f) {
        bool _1614 = (_shadowAOParams.w > 0.0f);
        if (_1614) {
          _1674 = (mad((float4(_nearFieldShadowViewProjCompacted[0].z, _nearFieldShadowViewProjCompacted[1].z, _nearFieldShadowViewProjCompacted[2].z, _nearFieldShadowViewProjCompacted[3].z).x), _151, mad((float4(_nearFieldShadowViewProjCompacted[0].y, _nearFieldShadowViewProjCompacted[1].y, _nearFieldShadowViewProjCompacted[2].y, _nearFieldShadowViewProjCompacted[3].y).x), _150, ((float4(_nearFieldShadowViewProjCompacted[0].x, _nearFieldShadowViewProjCompacted[1].x, _nearFieldShadowViewProjCompacted[2].x, _nearFieldShadowViewProjCompacted[3].x).x) * _149))) + (float4(_nearFieldShadowViewProjCompacted[0].w, _nearFieldShadowViewProjCompacted[1].w, _nearFieldShadowViewProjCompacted[2].w, _nearFieldShadowViewProjCompacted[3].w).x));
          _1675 = (mad((float4(_nearFieldShadowViewProjCompacted[0].z, _nearFieldShadowViewProjCompacted[1].z, _nearFieldShadowViewProjCompacted[2].z, _nearFieldShadowViewProjCompacted[3].z).y), _151, mad((float4(_nearFieldShadowViewProjCompacted[0].y, _nearFieldShadowViewProjCompacted[1].y, _nearFieldShadowViewProjCompacted[2].y, _nearFieldShadowViewProjCompacted[3].y).y), _150, ((float4(_nearFieldShadowViewProjCompacted[0].x, _nearFieldShadowViewProjCompacted[1].x, _nearFieldShadowViewProjCompacted[2].x, _nearFieldShadowViewProjCompacted[3].x).y) * _149))) + (float4(_nearFieldShadowViewProjCompacted[0].w, _nearFieldShadowViewProjCompacted[1].w, _nearFieldShadowViewProjCompacted[2].w, _nearFieldShadowViewProjCompacted[3].w).y));
          _1676 = (mad((float4(_nearFieldShadowViewProjCompacted[0].z, _nearFieldShadowViewProjCompacted[1].z, _nearFieldShadowViewProjCompacted[2].z, _nearFieldShadowViewProjCompacted[3].z).z), _151, mad((float4(_nearFieldShadowViewProjCompacted[0].y, _nearFieldShadowViewProjCompacted[1].y, _nearFieldShadowViewProjCompacted[2].y, _nearFieldShadowViewProjCompacted[3].y).z), _150, ((float4(_nearFieldShadowViewProjCompacted[0].x, _nearFieldShadowViewProjCompacted[1].x, _nearFieldShadowViewProjCompacted[2].x, _nearFieldShadowViewProjCompacted[3].x).z) * _149))) + (float4(_nearFieldShadowViewProjCompacted[0].w, _nearFieldShadowViewProjCompacted[1].w, _nearFieldShadowViewProjCompacted[2].w, _nearFieldShadowViewProjCompacted[3].w).z));
        } else {
          _1674 = (mad((float4(_nearFieldShadowViewProj[0].z, _nearFieldShadowViewProj[1].z, _nearFieldShadowViewProj[2].z, _nearFieldShadowViewProj[3].z).x), _151, mad((float4(_nearFieldShadowViewProj[0].y, _nearFieldShadowViewProj[1].y, _nearFieldShadowViewProj[2].y, _nearFieldShadowViewProj[3].y).x), _150, ((float4(_nearFieldShadowViewProj[0].x, _nearFieldShadowViewProj[1].x, _nearFieldShadowViewProj[2].x, _nearFieldShadowViewProj[3].x).x) * _149))) + (float4(_nearFieldShadowViewProj[0].w, _nearFieldShadowViewProj[1].w, _nearFieldShadowViewProj[2].w, _nearFieldShadowViewProj[3].w).x));
          _1675 = (mad((float4(_nearFieldShadowViewProj[0].z, _nearFieldShadowViewProj[1].z, _nearFieldShadowViewProj[2].z, _nearFieldShadowViewProj[3].z).y), _151, mad((float4(_nearFieldShadowViewProj[0].y, _nearFieldShadowViewProj[1].y, _nearFieldShadowViewProj[2].y, _nearFieldShadowViewProj[3].y).y), _150, ((float4(_nearFieldShadowViewProj[0].x, _nearFieldShadowViewProj[1].x, _nearFieldShadowViewProj[2].x, _nearFieldShadowViewProj[3].x).y) * _149))) + (float4(_nearFieldShadowViewProj[0].w, _nearFieldShadowViewProj[1].w, _nearFieldShadowViewProj[2].w, _nearFieldShadowViewProj[3].w).y));
          _1676 = (mad((float4(_nearFieldShadowViewProj[0].z, _nearFieldShadowViewProj[1].z, _nearFieldShadowViewProj[2].z, _nearFieldShadowViewProj[3].z).z), _151, mad((float4(_nearFieldShadowViewProj[0].y, _nearFieldShadowViewProj[1].y, _nearFieldShadowViewProj[2].y, _nearFieldShadowViewProj[3].y).z), _150, ((float4(_nearFieldShadowViewProj[0].x, _nearFieldShadowViewProj[1].x, _nearFieldShadowViewProj[2].x, _nearFieldShadowViewProj[3].x).z) * _149))) + (float4(_nearFieldShadowViewProj[0].w, _nearFieldShadowViewProj[1].w, _nearFieldShadowViewProj[2].w, _nearFieldShadowViewProj[3].w).z));
        }
        if (!((((int)((((int)(((int)(_1674 < -1.0f)) | ((int)(_1674 > 1.0f))))) | (((int)(((int)(_1675 < -1.0f)) | ((int)(_1675 > 1.0f)))))))) | (((int)(((int)(_1676 < 0.0f)) | ((int)(_1676 > 1.0f))))))) {
          float _1689 = float((uint)((uint)(int4(_frameNumber).x)));
          float _1700 = (frac(((_1689 * 92.0f) + _57) * 0.0078125f) * 128.0f) + -64.34062194824219f;
          float _1701 = (frac(((_1689 * 71.0f) + _58) * 0.0078125f) * 128.0f) + -72.46562194824219f;
          float _1706 = frac(dot(float3((_1700 * _1700), (_1701 * _1701), (_1701 * _1700)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
          if (_949) {
            _1721 = ((int)(((uint)((((int)((_947 << 4) + -1556008596u)) ^ ((int)(_947 + -1879881855u))) ^ (((uint)(_947) >> 5) + -939442524))) + _939));
          } else {
            _1721 = _939;
          }
          uint _1726 = uint(float((uint)((uint)(((int)(_1721 * 48271)) & 16777215))) * 3.814637693722034e-06f);
          float _1739 = (frac((float((uint)_1726) * 0.015625f) + (float((uint)((uint)((int)(uint(_1706 * 51540816.0f)) & 65535))) * 1.52587890625e-05f)) * 2.0f) + -1.0f;
          float _1740 = (float((uint)((uint)(reversebits(_1726) ^ (int)(uint(_1706 * 287478368.0f))))) * 4.656612873077393e-10f) + -1.0f;
          float _1742 = rsqrt(dot(float2(_1739, _1740), float2(_1739, _1740)));
          float _1743 = _1742 * _1739;
          float _1744 = _1740 * _1742;
          float _1745 = -0.0f - _1744;
          if (_949) {
            _1757 = ((int)(((uint)((((int)((_947 << 4) + -1556008596u)) ^ ((int)(_947 + -1879881855u))) ^ (((uint)(_947) >> 5) + -939442524))) + _939));
          } else {
            _1757 = _939;
          }
          uint _1762 = uint(float((uint)((uint)(((int)(_1757 * 48271)) & 16777215))) * 9.530782563160756e-07f);
          if (_1614) {
            _1771 = max(3.0517578125e-05f, (min(0.0003000000142492354f, (_nearFieldShadowBoundsMax.w * 0.00048828125f)) / _nearFieldShadowBoundsMax.w));
          } else {
            _1771 = 0.00048828125f;
          }
          _1784 = 0.0f;
          _1785 = 0;
          while(true) {
            int _1788 = ((int)((_1785 << 2) + _1762)) & 15;
            float _1797 = (_global_0[((int)(0u + (_1788 * 2)))]) * _1771;
            float _1798 = (_global_0[((int)(1u + (_1788 * 2)))]) * _1771;
            float _1811 = __3__36__0__0__g_nearFieldShadowDepth.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float2((((_1674 * 0.5f) + 0.5f) + mad(_1744, _1798, (_1797 * _1743))), ((0.5f - (_1675 * 0.5f)) + mad(_1743, _1798, (_1797 * _1745)))), (_1676 + -3.9999998989515007e-05f));
            float _1814 = (1.0f - _1811.x) + _1784;
            int _1815 = _1785 + 1;
            if (!(_1815 == 4)) {
              _1784 = _1814;
              _1785 = _1815;
              continue;
            }
            float _1777 = _149 - (_100 * 0.012000000104308128f);
            float _1778 = _150 - (_101 * 0.012000000104308128f);
            float _1779 = _151 - (_102 * 0.012000000104308128f);
            if (_shadowAOParams.w > 0.0f) {
              _1876 = (mad((float4(_nearFieldShadowViewProjCompacted[0].z, _nearFieldShadowViewProjCompacted[1].z, _nearFieldShadowViewProjCompacted[2].z, _nearFieldShadowViewProjCompacted[3].z).x), _1779, mad((float4(_nearFieldShadowViewProjCompacted[0].y, _nearFieldShadowViewProjCompacted[1].y, _nearFieldShadowViewProjCompacted[2].y, _nearFieldShadowViewProjCompacted[3].y).x), _1778, ((float4(_nearFieldShadowViewProjCompacted[0].x, _nearFieldShadowViewProjCompacted[1].x, _nearFieldShadowViewProjCompacted[2].x, _nearFieldShadowViewProjCompacted[3].x).x) * _1777))) + (float4(_nearFieldShadowViewProjCompacted[0].w, _nearFieldShadowViewProjCompacted[1].w, _nearFieldShadowViewProjCompacted[2].w, _nearFieldShadowViewProjCompacted[3].w).x));
              _1877 = (mad((float4(_nearFieldShadowViewProjCompacted[0].z, _nearFieldShadowViewProjCompacted[1].z, _nearFieldShadowViewProjCompacted[2].z, _nearFieldShadowViewProjCompacted[3].z).y), _1779, mad((float4(_nearFieldShadowViewProjCompacted[0].y, _nearFieldShadowViewProjCompacted[1].y, _nearFieldShadowViewProjCompacted[2].y, _nearFieldShadowViewProjCompacted[3].y).y), _1778, ((float4(_nearFieldShadowViewProjCompacted[0].x, _nearFieldShadowViewProjCompacted[1].x, _nearFieldShadowViewProjCompacted[2].x, _nearFieldShadowViewProjCompacted[3].x).y) * _1777))) + (float4(_nearFieldShadowViewProjCompacted[0].w, _nearFieldShadowViewProjCompacted[1].w, _nearFieldShadowViewProjCompacted[2].w, _nearFieldShadowViewProjCompacted[3].w).y));
              _1878 = (mad((float4(_nearFieldShadowViewProjCompacted[0].z, _nearFieldShadowViewProjCompacted[1].z, _nearFieldShadowViewProjCompacted[2].z, _nearFieldShadowViewProjCompacted[3].z).z), _1779, mad((float4(_nearFieldShadowViewProjCompacted[0].y, _nearFieldShadowViewProjCompacted[1].y, _nearFieldShadowViewProjCompacted[2].y, _nearFieldShadowViewProjCompacted[3].y).z), _1778, ((float4(_nearFieldShadowViewProjCompacted[0].x, _nearFieldShadowViewProjCompacted[1].x, _nearFieldShadowViewProjCompacted[2].x, _nearFieldShadowViewProjCompacted[3].x).z) * _1777))) + (float4(_nearFieldShadowViewProjCompacted[0].w, _nearFieldShadowViewProjCompacted[1].w, _nearFieldShadowViewProjCompacted[2].w, _nearFieldShadowViewProjCompacted[3].w).z));
            } else {
              _1876 = (mad((float4(_nearFieldShadowViewProj[0].z, _nearFieldShadowViewProj[1].z, _nearFieldShadowViewProj[2].z, _nearFieldShadowViewProj[3].z).x), _1779, mad((float4(_nearFieldShadowViewProj[0].y, _nearFieldShadowViewProj[1].y, _nearFieldShadowViewProj[2].y, _nearFieldShadowViewProj[3].y).x), _1778, ((float4(_nearFieldShadowViewProj[0].x, _nearFieldShadowViewProj[1].x, _nearFieldShadowViewProj[2].x, _nearFieldShadowViewProj[3].x).x) * _1777))) + (float4(_nearFieldShadowViewProj[0].w, _nearFieldShadowViewProj[1].w, _nearFieldShadowViewProj[2].w, _nearFieldShadowViewProj[3].w).x));
              _1877 = (mad((float4(_nearFieldShadowViewProj[0].z, _nearFieldShadowViewProj[1].z, _nearFieldShadowViewProj[2].z, _nearFieldShadowViewProj[3].z).y), _1779, mad((float4(_nearFieldShadowViewProj[0].y, _nearFieldShadowViewProj[1].y, _nearFieldShadowViewProj[2].y, _nearFieldShadowViewProj[3].y).y), _1778, ((float4(_nearFieldShadowViewProj[0].x, _nearFieldShadowViewProj[1].x, _nearFieldShadowViewProj[2].x, _nearFieldShadowViewProj[3].x).y) * _1777))) + (float4(_nearFieldShadowViewProj[0].w, _nearFieldShadowViewProj[1].w, _nearFieldShadowViewProj[2].w, _nearFieldShadowViewProj[3].w).y));
              _1878 = (mad((float4(_nearFieldShadowViewProj[0].z, _nearFieldShadowViewProj[1].z, _nearFieldShadowViewProj[2].z, _nearFieldShadowViewProj[3].z).z), _1779, mad((float4(_nearFieldShadowViewProj[0].y, _nearFieldShadowViewProj[1].y, _nearFieldShadowViewProj[2].y, _nearFieldShadowViewProj[3].y).z), _1778, ((float4(_nearFieldShadowViewProj[0].x, _nearFieldShadowViewProj[1].x, _nearFieldShadowViewProj[2].x, _nearFieldShadowViewProj[3].x).z) * _1777))) + (float4(_nearFieldShadowViewProj[0].w, _nearFieldShadowViewProj[1].w, _nearFieldShadowViewProj[2].w, _nearFieldShadowViewProj[3].w).z));
            }
            _1880 = 0.0f;
            _1881 = 0;
            while(true) {
              int _1884 = ((int)((_1881 << 2) + _1762)) & 15;
              float _1893 = (_global_0[((int)(0u + (_1884 * 2)))]) * _1771;
              float _1894 = (_global_0[((int)(1u + (_1884 * 2)))]) * _1771;
              float _1907 = __3__36__0__0__g_nearFieldShadowDepth.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((((_1876 * 0.5f) + 0.5f) + mad(_1744, _1894, (_1893 * _1743))), ((0.5f - (_1877 * 0.5f)) + mad(_1743, _1894, (_1893 * _1745)))), 0.0f);
              float _1911 = max(0.0f, (_1878 - _1907.x)) + _1880;
              int _1912 = _1881 + 1;
              if (!(_1912 == 4)) {
                _1880 = _1911;
                _1881 = _1912;
                continue;
              }
              _1921 = min(_1600, (_1814 * 0.25f));
              _1922 = max((select(_169, _1605, _1604) + -0.9800000190734863f), max(0.0020000000949949026f, (_1911 * 25.0f)));
              break;
            }
            if (__loop_jump_target == 1783) {
              __loop_jump_target = -1;
              continue;
            }
            if (__loop_jump_target != -1) {
              break;
            }
            break;
          }
        } else {
          _1921 = _1600;
          _1922 = _1605;
        }
      } else {
        _1921 = _1600;
        _1922 = _1605;
      }
    } else {
      _1921 = _1600;
      _1922 = _1604;
    }
    float _1935 = (_1921 - (_shadowAOParams.x * _1921)) + _shadowAOParams.x;
    [branch]
    if (_1935 > 0.0f) {
      int _1945 = _73 & 126;
      bool _1947 = (_77 == 66);
      bool _1948 = ((int)(_1945 == 64)) | (_1947);
      float _1949 = select(_1948, 2.0f, 4.0f);
      if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
        _1965 = _sunDirection.x;
        _1966 = _sunDirection.y;
        _1967 = _sunDirection.z;
      } else {
        _1965 = _moonDirection.x;
        _1966 = _moonDirection.y;
        _1967 = _moonDirection.z;
      }
      int _1968 = _55 & 3;
      int _1972 = _56 & 3;
      uint _1978 = ((int4(_frameNumber).x) * 1551) + ((uint)(((((_1972 << 1) | _1972) << 1) & 10) | (((_1968 << 1) | _1968) & 5)));
      int _1983 = (((int)(_1978 << 2)) & -858993460) | (((uint)(_1978) >> 2) & 858993459);
      int _1988 = (((int)(_1983 << 1)) & 10) | (((uint)(_1983) >> 1) & 21);
      float _1991 = float((uint)((uint)(int4(_frameNumber).x)));
      float _2002 = (frac(((_1991 * 92.0f) + _57) * 0.0078125f) * 128.0f) + -64.34062194824219f;
      float _2003 = (frac(((_1991 * 71.0f) + _58) * 0.0078125f) * 128.0f) + -72.46562194824219f;
      float _2008 = frac(dot(float3((_2002 * _2002), (_2003 * _2003), (_2003 * _2002)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
      float _2024 = frac((float((uint)((uint)((int)(uint(_2008 * 51540816.0f)) & 65535))) * 1.52587890625e-05f) + (float((uint)_1988) * 0.03125f)) * 6.2831854820251465f;
      float _2028 = (((1.0f - _shadowAOParams.z) * 2.3283064365386963e-10f) * float((uint)((uint)(reversebits(_1988) ^ (int)(uint(_2008 * 287478368.0f)))))) + _shadowAOParams.z;
      float _2031 = sqrt(1.0f - (_2028 * _2028));
      float _2034 = cos(_2024) * _2031;
      float _2035 = sin(_2024) * _2031;
      float _2037 = select((_1967 >= 0.0f), 1.0f, -1.0f);
      float _2040 = -0.0f - (1.0f / (_2037 + _1967));
      float _2041 = _1966 * _2040;
      float _2042 = _2041 * _1965;
      float _2043 = _2037 * _1965;
      _2052 = mad(_2028, _1965, mad(_2035, _2042, ((((_2043 * _1965) * _2040) + 1.0f) * _2034)));
      _2056 = mad(_2028, _1966, mad(_2035, (_2037 + (_2041 * _1966)), ((_2034 * _2037) * _2042)));
      _2060 = mad(_2028, _1967, mad(_2035, (-0.0f - _1966), (-0.0f - (_2043 * _2034))));
      float _2063 = min(0.5f, ((_112 * 0.0024999999441206455f) + 0.25f));
      float _2069 = ((abs(_1966) * (select(_1948, 12.0f, 2.0f) - _1949)) + _1949) * select(_169, 0.009999999776482582f, 0.10000000149011612f);
      if (!_169) {
        _2077 = max((_112 * select(((uint)(_77 + -11) < (uint)9), 0.00800000037997961f, 0.029999999329447746f)), _2069);
      } else {
        _2077 = _2069;
      }
      float _2083 = saturate(((_112 * 0.009999999776482582f) * (1.0f - saturate(dot(float3(_100, _101, _102), float3((-0.0f - (_149 * _153)), (-0.0f - (_150 * _153)), (-0.0f - (_151 * _153))))))) + 0.009999999776482582f);
      if (_terrainNormalParams.z > 0.0f) {
        float _2094 = float((uint)((uint)(((int)((int4(_frameNumber).x) * 73)) & 255)));
        _2255 = frac(frac(dot(float2(((_2094 * 32.665000915527344f) + _57), ((_2094 * 11.8149995803833f) + _58)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
      } else {
        uint _2116 = uint((_bufferSizeAndInvSize.x * _58) + _57) + ((uint)((((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524)));
        uint _2124 = ((uint)((((int)((_2116 << 4) + -1383041155u)) ^ ((int)(_2116 + -1640531527u))) ^ ((int)(((uint)((uint)(_2116) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
        uint _2132 = ((uint)((((int)((_2124 << 4) + -1556008596u)) ^ ((int)(_2124 + 1013904242u))) ^ (((uint)(_2124) >> 5) + -939442524))) + _2116;
        uint _2140 = ((uint)((((int)((_2132 << 4) + -1383041155u)) ^ ((int)(_2132 + 1013904242u))) ^ ((int)(((uint)((uint)(_2132) >> 5)) + 2123724318u)))) + _2124;
        uint _2148 = ((uint)((((int)((_2140 << 4) + -1556008596u)) ^ ((int)(_2140 + -626627285u))) ^ (((uint)(_2140) >> 5) + -939442524))) + _2132;
        uint _2156 = ((uint)((((int)((_2148 << 4) + -1383041155u)) ^ ((int)(_2148 + -626627285u))) ^ ((int)(((uint)((uint)(_2148) >> 5)) + 2123724318u)))) + _2140;
        uint _2164 = ((uint)((((int)((_2156 << 4) + -1556008596u)) ^ ((int)(_2156 + 2027808484u))) ^ (((uint)(_2156) >> 5) + -939442524))) + _2148;
        uint _2172 = ((uint)((((int)((_2164 << 4) + -1383041155u)) ^ ((int)(_2164 + 2027808484u))) ^ ((int)(((uint)((uint)(_2164) >> 5)) + 2123724318u)))) + _2156;
        uint _2180 = ((uint)((((int)((_2172 << 4) + -1556008596u)) ^ ((int)(_2172 + 387276957u))) ^ (((uint)(_2172) >> 5) + -939442524))) + _2164;
        uint _2188 = ((uint)((((int)((_2180 << 4) + -1383041155u)) ^ ((int)(_2180 + 387276957u))) ^ ((int)(((uint)((uint)(_2180) >> 5)) + 2123724318u)))) + _2172;
        uint _2196 = ((uint)((((int)((_2188 << 4) + -1556008596u)) ^ ((int)(_2188 + -1253254570u))) ^ (((uint)(_2188) >> 5) + -939442524))) + _2180;
        uint _2204 = ((uint)((((int)((_2196 << 4) + -1383041155u)) ^ ((int)(_2196 + -1253254570u))) ^ ((int)(((uint)((uint)(_2196) >> 5)) + 2123724318u)))) + _2188;
        uint _2212 = ((uint)((((int)((_2204 << 4) + -1556008596u)) ^ ((int)(_2204 + 1401181199u))) ^ (((uint)(_2204) >> 5) + -939442524))) + _2196;
        uint _2220 = ((uint)((((int)((_2212 << 4) + -1383041155u)) ^ ((int)(_2212 + 1401181199u))) ^ ((int)(((uint)((uint)(_2212) >> 5)) + 2123724318u)))) + _2204;
        uint _2228 = ((uint)((((int)((_2220 << 4) + -1556008596u)) ^ ((int)(_2220 + -239350328u))) ^ (((uint)(_2220) >> 5) + -939442524))) + _2212;
        uint _2236 = ((uint)((((int)((_2228 << 4) + -1383041155u)) ^ ((int)(_2228 + -239350328u))) ^ ((int)(((uint)((uint)(_2228) >> 5)) + 2123724318u)))) + _2220;
        if ((_2228 & 16777215) == 0) {
          _2249 = ((int)(((uint)((((int)((_2236 << 4) + -1556008596u)) ^ ((int)(_2236 + -1879881855u))) ^ (((uint)(_2236) >> 5) + -939442524))) + _2228));
        } else {
          _2249 = _2228;
        }
        _2255 = (float((uint)((uint)(((int)(_2249 * 48271)) & 16777215))) * 5.960464477539063e-08f);
      }
      if ((_1947) | (((int)(((int)(_77 != 15)) & ((int)((uint)(_77 + -12) < (uint)7)))))) {
        _2268 = (_2255 * select(CONTACT_SHADOW_QUALITY > 0.5f, 3.0f, 10.0f));
      } else {
        if (_77 == 15) {
          _2268 = ((select(CONTACT_SHADOW_QUALITY > 0.5f, 3.0f, 10.0f) - (saturate(_112 * 0.0010000000474974513f) * (select(CONTACT_SHADOW_QUALITY > 0.5f, 3.0f, 10.0f) - 1.0f))) * _2255);
        } else {
          _2268 = _2255;
        }
      }
      if (!(_1945 == 12)) {
        if ((uint)_77 > (uint)15) {
          if (((int)((uint)_77 < (uint)20)) | ((int)(_77 == 107))) {
            _2281 = (0.10000000149011612f - (abs(_2056) * 0.05000000074505806f));
          } else {
            _2281 = 0.0f;
          }
        } else {
          _2281 = 0.0f;
        }
      } else {
        _2281 = (0.10000000149011612f - (abs(_2056) * 0.05000000074505806f));
      }
      if (!_169) {
        float _2283 = _2281 * _153;
        _2291 = (_149 - (_2283 * _149));
        _2292 = (_150 - (_2283 * _150));
        _2293 = (_151 - (_2283 * _151));
      } else {
        _2291 = _149;
        _2292 = _150;
        _2293 = _151;
      }
      float _2306 = mad((float4(_viewRelative[0].z, _viewRelative[1].z, _viewRelative[2].z, _viewRelative[3].z).z), _2293, mad((float4(_viewRelative[0].y, _viewRelative[1].y, _viewRelative[2].y, _viewRelative[3].y).z), _2292, ((float4(_viewRelative[0].x, _viewRelative[1].x, _viewRelative[2].x, _viewRelative[3].x).z) * _2291))) + (float4(_viewRelative[0].w, _viewRelative[1].w, _viewRelative[2].w, _viewRelative[3].w).z);
      float _2309 = mad((float4(_viewRelative[0].z, _viewRelative[1].z, _viewRelative[2].z, _viewRelative[3].z).z), _2060, mad((float4(_viewRelative[0].y, _viewRelative[1].y, _viewRelative[2].y, _viewRelative[3].y).z), _2056, ((float4(_viewRelative[0].x, _viewRelative[1].x, _viewRelative[2].x, _viewRelative[3].x).z) * _2052)));
      bool _2314 = (((_2309 * _2077) + _2306) < _nearFarProj.x);
      if (_112 < select(CONTACT_SHADOW_QUALITY > 0.5f, 64.0f, 8.0f)) {
        float _2318 = select(_2314, ((_nearFarProj.x - _2306) / _2309), _2077);
        float _2350 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _2293, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _2292, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z) * _2291))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z);
        float _2354 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _2293, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _2292, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w) * _2291))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
        float _2358 = (_2318 * _2052) + _2291;
        float _2359 = (_2318 * _2056) + _2292;
        float _2360 = (_2318 * _2060) + _2293;
        float _2376 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _2360, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _2359, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w) * _2358))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
        float _2377 = (mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _2293, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _2292, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x) * _2291))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x)) / _2354;
        float _2378 = (mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _2293, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _2292, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y) * _2291))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y)) / _2354;
        float _2379 = _2350 / _2354;
        float _2383 = ((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _2360, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _2359, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x) * _2358))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x)) / _2376) - _2377;
        float _2384 = ((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _2360, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _2359, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y) * _2358))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y)) / _2376) - _2378;
        float _2396 = max(0.125f, (1.0f / min(1.0f, (max(((_bufferSizeAndInvSize.x * 0.5f) * abs(_2383)), ((_bufferSizeAndInvSize.y * 0.5f) * abs(_2384))) * 0.125f))));
        float _2397 = _2396 * (((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _2360, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _2359, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z) * _2358))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z)) / _2376) - _2379);
        float _2414 = (_2063 * 0.125f) * max(abs(_2397), (_2379 - ((mad((float4(_proj[0].z, _proj[1].z, _proj[2].z, _proj[3].z).z), _112, 0.0f) + _2350) / (mad((float4(_proj[0].z, _proj[1].z, _proj[2].z, _proj[3].z).w), _112, 0.0f) + _2354))));
        float _2416 = (_2383 * 0.0625f) * _2396;
        float _2418 = (_2384 * -0.0625f) * _2396;
        float _2419 = _2397 * 0.125f;
        float _2426 = max(_2268, (1.0f / max((abs(_2416) * _bufferSizeAndInvSize.x), (abs(_2418) * _bufferSizeAndInvSize.y))));
        float _2433 = 0.5f / _bufferSizeAndInvSize.x;
        _2435 = 0;
        _2436 = (((_2377 * 0.5f) + 0.5f) + (_2426 * _2416));
        _2437 = ((0.5f - (_2378 * 0.5f)) + (_2426 * _2418));
        _2438 = ((_2426 * _2419) + _2379);
        _2439 = _2268;
        _2440 = _2083;
        _2441 = 0;
        _2442 = 1.0f;
        _2443 = 0.0f;
        while(true) {
          uint _2452 = __3__36__0__0__g_depthStencil.Load(int3(int(min(max(_2436, _2433), (1.0f - _2433)) * _bufferSizeAndInvSize.x), int(_2437 * _bufferSizeAndInvSize.y), 0));
          int _2454 = (uint)((uint)(_2452.x)) >> 24;
          float _2457 = float((uint)((uint)(_2452.x & 16777215))) * 5.960465188081798e-08f;
          int _2458 = _2454 & 127;
          bool _2459 = (_2441 == 0);
          float _2460 = select(_2459, 1.0f, _2440);
          float _2464 = _nearFarProj.x / max(1.0000000116860974e-07f, _2457);
          float _2465 = _2438 - _2457;
          float _2468 = _2464 - (_nearFarProj.x / max(1.0000000116860974e-07f, _2438));
          bool _2471 = (abs(_2465 + _2414) < _2414);
          int _2472 = (int)(uint)(_2471);
          if (_2471) {
            if (!(((int)(_2458 == 7)) | (((int)(((int)(_2458 == 54)) | (((int)(((int)((_2454 & 126) == 66)) | (((int)(((int)((uint)(_2458 + -5) < (uint)2)) | (((int)(((int)(_2458 == 107)) | (((int)(((int)(_2458 == 26)) | (((int)(((int)((uint)(_2458 + -27) < (uint)2)) | (((int)(((int)(_2458 == 106)) | (((int)(((int)((_2454 & 125) == 105)) | (((int)(((int)(_2458 == 18)) | ((int)((uint)(_2458 + -19) < (uint)2))))))))))))))))))))))))))))))) {
              if ((uint)(_2458 + -53) < (uint)14) {
                _2506 = (_2464 < 32.0f);
                _2513 = ((int)(uint)((int)(((int)(_2468 < 0.0f)) & ((int)(_2468 > select(_2506, -0.07999999821186066f, -1.0f))))));
              } else {
                _2513 = _2472;
              }
            } else {
              _2506 = true;
              _2513 = ((int)(uint)((int)(((int)(_2468 < 0.0f)) & ((int)(_2468 > select(_2506, -0.07999999821186066f, -1.0f))))));
            }
          } else {
            _2513 = _2472;
          }
          if (!(_2513 == 0)) {
            if ((uint)_2458 > (uint)11) {
              if (!(((int)((uint)_2458 < (uint)16)) | ((int)(_2458 == 17)))) {
                if (!(_2458 == 16)) {
                  if (!(((int)(_2458 == 18)) | (((int)(((int)(_2458 == 107)) | ((int)((uint)(_2458 + -19) < (uint)2))))))) {
                    if (!(_2458 == 66)) {
                      _2536 = 0.0f;
                    } else {
                      _2536 = 0.10000000149011612f;
                    }
                  } else {
                    _2536 = select(CONTACT_SHADOW_QUALITY > 0.5f, 0.18f, 0.4000000059604645f);
                  }
                } else {
                  _2536 = 0.10000000149011612f;
                }
              } else {
                // RenoDX: Weather adaptive grass occluder thickness
                if (_2458 == 17) {
                  float _grassWeather = saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY);
                  _2536 = select(CONTACT_SHADOW_QUALITY > 0.5f, lerp(0.018f, 0.05f, _grassWeather), 0.09f);
                } else {
                  _2536 = select(CONTACT_SHADOW_QUALITY > 0.5f, 0.12f, 0.30000001192092896f);
                }
              }
            } else {
              if (!(_2458 == 11)) {
                _2536 = 0.0f;
              } else {
                _2536 = 0.10000000149011612f;
              }
            }
            float _2538 = saturate(_2464 * 0.015625f);
            float _2541 = (1.0f - _2538) + (_2538 * _2536);
            _2551 = _2458;
            _2552 = saturate((saturate(1.0f - ((_2541 * _2541) * _2536)) * (1.0f - _2443)) + _2443);
            // RenoDX: Weather adaptive grass shadow contribution
            if (CONTACT_SHADOW_QUALITY > 0.5f && _2458 == 17) {
              float _grassContrib = lerp(0.3f, 0.65f, saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY));
              _2552 = lerp(_2443, _2552, _grassContrib);
            }
          } else {
            _2551 = _2435;
            _2552 = _2443;
          }
          [branch]
          if (_2552 > 0.949999988079071f) {
            if (!_2459) {
              _2582 = (saturate(_2442 / (_2442 - _2465)) - min(_2439, _2460));
            } else {
              _2582 = 0.0f;
            }
            _2866 = _2458;
            _2867 = _2552;
            _2868 = ((_2582 * _2416) + _2436);
            _2869 = ((_2582 * _2418) + _2437);
            _2870 = ((_2582 * _2419) + _2438);
            _2871 = _2457;
          } else {
            if ((uint)_2441 < ((uint)7)) {
              _2574 = ((_2460 * _2416) + _2436);
              _2575 = ((_2460 * _2418) + _2437);
              _2576 = ((_2460 * _2419) + _2438);
              _2577 = (_2460 + _2439);
              _2578 = min(abs(_2419), _2465);
            } else {
              _2574 = _2436;
              _2575 = _2437;
              _2576 = _2438;
              _2577 = _2439;
              _2578 = _2442;
            }
            int _2579 = _2441 + 1;
            if ((uint)_2579 < ((uint)8)) {
              _2435 = _2551;
              _2436 = _2574;
              _2437 = _2575;
              _2438 = _2576;
              _2439 = _2577;
              _2440 = _2460;
              _2441 = _2579;
              _2442 = _2578;
              _2443 = _2552;
              continue;
            } else {
              _2866 = _2551;
              _2867 = _2552;
              _2868 = _2436;
              _2869 = _2437;
              _2870 = _2438;
              _2871 = _2457;
            }
          }
          break;
        }
      } else {
        float _2592 = select(_2314, ((_nearFarProj.x - _2306) / _2309), _2077);
        float _2624 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _2293, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _2292, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z) * _2291))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z);
        float _2628 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _2293, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _2292, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w) * _2291))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
        float _2632 = (_2592 * _2052) + _2291;
        float _2633 = (_2592 * _2056) + _2292;
        float _2634 = (_2592 * _2060) + _2293;
        float _2650 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _2634, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _2633, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w) * _2632))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
        float _2651 = (mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _2293, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _2292, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x) * _2291))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x)) / _2628;
        float _2652 = (mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _2293, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _2292, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y) * _2291))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y)) / _2628;
        float _2653 = _2624 / _2628;
        float _2657 = ((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _2634, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _2633, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x) * _2632))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x)) / _2650) - _2651;
        float _2658 = ((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _2634, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _2633, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y) * _2632))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y)) / _2650) - _2652;
        float _2670 = max(0.125f, (1.0f / min(1.0f, (max(((_bufferSizeAndInvSize.x * 0.5f) * abs(_2657)), ((_bufferSizeAndInvSize.y * 0.5f) * abs(_2658))) * 0.125f))));
        float _2671 = _2670 * (((mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _2634, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _2633, ((float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z) * _2632))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z)) / _2650) - _2653);
        float _2688 = (_2063 * 0.0625f) * max(abs(_2671), (_2653 - ((mad((float4(_proj[0].z, _proj[1].z, _proj[2].z, _proj[3].z).z), _112, 0.0f) + _2624) / (mad((float4(_proj[0].z, _proj[1].z, _proj[2].z, _proj[3].z).w), _112, 0.0f) + _2628))));
        float _2690 = (_2657 * 0.0625f) * _2670;
        float _2692 = (_2658 * -0.0625f) * _2670;
        float _2693 = _2671 * 0.125f;
        float _2700 = max(_2268, (1.0f / max((abs(_2690) * _bufferSizeAndInvSize.x), (abs(_2692) * _bufferSizeAndInvSize.y))));
        float _2707 = 0.5f / _bufferSizeAndInvSize.x;
        _2709 = 0;
        _2710 = _2083;
        _2711 = _2268;
        _2712 = (((_2651 * 0.5f) + 0.5f) + (_2700 * _2690));
        _2713 = ((0.5f - (_2652 * 0.5f)) + (_2700 * _2692));
        _2714 = ((_2700 * _2693) + _2653);
        _2715 = 0;
        _2716 = 1.0f;
        _2717 = 0.0f;
        while(true) {
          uint _2726 = __3__36__0__0__g_depthStencil.Load(int3(int(min(max(_2712, _2707), (1.0f - _2707)) * _bufferSizeAndInvSize.x), int(_2713 * _bufferSizeAndInvSize.y), 0));
          int _2728 = (uint)((uint)(_2726.x)) >> 24;
          float _2731 = float((uint)((uint)(_2726.x & 16777215))) * 5.960465188081798e-08f;
          int _2732 = _2728 & 127;
          bool _2733 = (_2709 == 0);
          float _2734 = select(_2733, 1.0f, _2710);
          float _2735 = _2714 - _2731;
          float _2739 = _nearFarProj.x / max(1.0000000116860974e-07f, _2731);
          float _2742 = _2739 - (_nearFarProj.x / max(1.0000000116860974e-07f, _2714));
          bool _2745 = (abs(_2735 + _2688) < _2688);
          int _2746 = (int)(uint)(_2745);
          if (_2745) {
            if (!(((int)(_2732 == 7)) | (((int)(((int)(_2732 == 54)) | (((int)(((int)((_2728 & 126) == 66)) | (((int)(((int)((uint)(_2732 + -5) < (uint)2)) | (((int)(((int)(_2732 == 107)) | (((int)(((int)(_2732 == 26)) | (((int)(((int)((uint)(_2732 + -27) < (uint)2)) | (((int)(((int)(_2732 == 106)) | (((int)(((int)((_2728 & 125) == 105)) | (((int)(((int)(_2732 == 18)) | ((int)((uint)(_2732 + -19) < (uint)2))))))))))))))))))))))))))))))) {
              if ((uint)(_2732 + -53) < (uint)14) {
                _2780 = (_2739 < 32.0f);
                _2787 = ((int)(uint)((int)(((int)(_2742 < 0.0f)) & ((int)(_2742 > select(_2780, -0.07999999821186066f, -1.0f))))));
              } else {
                _2787 = _2746;
              }
            } else {
              _2780 = true;
              _2787 = ((int)(uint)((int)(((int)(_2742 < 0.0f)) & ((int)(_2742 > select(_2780, -0.07999999821186066f, -1.0f))))));
            }
          } else {
            _2787 = _2746;
          }
          if (!(_2787 == 0)) {
            if ((uint)_2732 > (uint)11) {
              if (!(((int)((uint)_2732 < (uint)16)) | ((int)(_2732 == 17)))) {
                if (!(_2732 == 16)) {
                  if (!(((int)(_2732 == 18)) | (((int)(((int)(_2732 == 107)) | ((int)((uint)(_2732 + -19) < (uint)2))))))) {
                    if (!(_2732 == 66)) {
                      _2810 = 0.0f;
                    } else {
                      _2810 = 0.10000000149011612f;
                    }
                  } else {
                    _2810 = select(CONTACT_SHADOW_QUALITY > 0.5f, 0.18f, 0.4000000059604645f);
                  }
                } else {
                  _2810 = 0.10000000149011612f;
                }
              } else {
                // RenoDX: Weather adaptive grass occluder thickness
                if (_2732 == 17) {
                  float _grassWeather2 = saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY);
                  _2810 = select(CONTACT_SHADOW_QUALITY > 0.5f, lerp(0.018f, 0.05f, _grassWeather2), 0.09f);
                } else {
                  _2810 = select(CONTACT_SHADOW_QUALITY > 0.5f, 0.12f, 0.30000001192092896f);
                }
              }
            } else {
              if (!(_2732 == 11)) {
                _2810 = 0.0f;
              } else {
                _2810 = 0.10000000149011612f;
              }
            }
            float _2812 = saturate(_2739 * 0.015625f);
            float _2815 = (1.0f - _2812) + (_2812 * _2810);
            _2825 = _2732;
            _2826 = saturate((saturate(1.0f - ((_2815 * _2815) * _2810)) * (1.0f - _2717)) + _2717);
            // RenoDX: Weather adaptive grass shadow contribution
            if (CONTACT_SHADOW_QUALITY > 0.5f && _2732 == 17) {
              float _grassContrib2 = lerp(0.3f, 0.65f, saturate(abs(_sunDirection.y) * FOLIAGE_SHADOW_SENSITIVITY));
              _2826 = lerp(_2717, _2826, _grassContrib2);
            }
          } else {
            _2825 = _2715;
            _2826 = _2717;
          }
          [branch]
          if (_2826 > 0.949999988079071f) {
            if (!_2733) {
              _2856 = (saturate(_2716 / (_2716 - _2735)) - min(_2711, _2734));
            } else {
              _2856 = 0.0f;
            }
            _2866 = _2732;
            _2867 = _2826;
            _2868 = ((_2856 * _2690) + _2712);
            _2869 = ((_2856 * _2692) + _2713);
            _2870 = ((_2856 * _2693) + _2714);
            _2871 = _2731;
          } else {
            if ((uint)_2709 < ((uint)7)) {
              _2848 = (_2711 + _2734);
              _2849 = (_2712 + (_2734 * _2690));
              _2850 = (_2713 + (_2734 * _2692));
              _2851 = (_2714 + (_2734 * _2693));
              _2852 = min(abs(_2693), _2735);
            } else {
              _2848 = _2711;
              _2849 = _2712;
              _2850 = _2713;
              _2851 = _2714;
              _2852 = _2716;
            }
            int _2853 = _2709 + 1;
            if ((uint)_2853 < ((uint)8)) {
              _2709 = _2853;
              _2710 = _2734;
              _2711 = _2848;
              _2712 = _2849;
              _2713 = _2850;
              _2714 = _2851;
              _2715 = _2825;
              _2716 = _2852;
              _2717 = _2826;
              continue;
            } else {
              _2866 = _2825;
              _2867 = _2826;
              _2868 = 0.0f;
              _2869 = 0.0f;
              _2870 = -1.0f;
              _2871 = 0.0f;
            }
          }
          break;
        }
      }
      bool _2875 = (_2867 > 0.0f);
      if (_2870 > 0.0f) {
        if ((_2875) | (((int)((((int)(((int)(_2868 >= 0.0f)) & ((int)(_2868 <= 1.0f))))) & (((int)(((int)(_2869 >= 0.0f)) & ((int)(_2869 <= 1.0f))))))))) {
          float _2889 = (_2868 * 2.0f) + -1.0f;
          float _2890 = 1.0f - (_2869 * 2.0f);
          float _2926 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _2870, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _2890, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _2889))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
          if (!(_2866 == 2)) {
            if (!(_2866 == 3)) {
              if (!(_2866 == 21)) {
                bool _2945 = (_2866 == 22);
                if (!(((int)(_77 == 22)) & (_2945))) {
                  _2952 = select(_2945, 0.0f, 1.0f);
                  _2954 = _2952;
                } else {
                  _2954 = 20.0f;
                }
              } else {
                if (!(_77 == 21)) {
                  _2952 = 0.0f;
                  _2954 = _2952;
                } else {
                  _2954 = 20.0f;
                }
              }
            } else {
              _2952 = 0.0f;
              _2954 = _2952;
            }
          } else {
            if (!(_77 == 2)) {
              _2952 = 0.0f;
              _2954 = _2952;
            } else {
              _2954 = 20.0f;
            }
          }
          if (_2867 == 1.0f) {
            _2977 = saturate(((((_2077 * 0.9375f) - max(0.0f, dot(float3(_2052, _2056, _2060), float3((((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _2870, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _2890, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _2889))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _2926) - _2291), (((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _2870, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _2890, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _2889))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _2926) - _2292), (((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _2870, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _2890, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _2889))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _2926) - _2293))))) * ((_112 * 0.015625f) + 1.5f)) / _2077) * 0.9375f);
          } else {
            _2977 = _2867;
          }
          float _2978 = _2977 * saturate(exp2(min(0.0f, (((_112 * 0.01899999938905239f) + 0.10000000149011612f) + (_2954 * ((_nearFarProj.x / max(1.0000000116860974e-07f, _2871)) - (_nearFarProj.x / max(1.0000000116860974e-07f, _2870)))))) * 1.4426950216293335f));
          int _2979 = _2866 & -2;
          if (!(_2979 == 6)) {
            if ((((_77 == 33) && (_2866 == 33)) || (!(_77 == 33) && (((int)(_77 == 55)) & ((int)(_2866 == 55)))))) {
              _3056 = (_2978 * 0.009999999776482582f);
            } else {
              if (!(((int)(_2866 == 54)) | ((int)(_2979 == 66))) || ((((int)(_2866 == 54)) | ((int)(_2979 == 66))) && (!(((int)(_1945 == 66)) | ((int)(_77 == 54)))))) {
                if (!_169) {
                  if ((uint)((int)(_2866 + -53u)) < (uint)15) {
                    _3053 = saturate(_112 * 0.03125f);
                  } else {
                    _3053 = 1.0f;
                  }
                  _3056 = (_3053 * _2978);
                } else {
                  _3056 = _2978;
                }
              } else {
                uint4 _3008 = __3__36__0__0__g_baseColor.Load(int3(int(_bufferSizeAndInvSize.x * _2868), int(_bufferSizeAndInvSize.y * _2869), 0));
                float _3014 = float((uint)((uint)(((uint)((uint)(_3008.x)) >> 8) & 255))) * 0.003921568859368563f;
                float _3017 = float((uint)((uint)(_3008.x & 255))) * 0.003921568859368563f;
                float _3021 = float((uint)((uint)(((uint)((uint)(_3008.y)) >> 8) & 255))) * 0.003921568859368563f;
                float _3022 = _3014 * _3014;
                float _3023 = _3017 * _3017;
                float _3024 = _3021 * _3021;
                _3056 = (saturate(1.0f - (dot(float3((((_3022 * 0.6131200194358826f) + (_3023 * 0.3395099937915802f)) + (_3024 * 0.047370001673698425f)), (((_3022 * 0.07020000368356705f) + (_3023 * 0.9163600206375122f)) + (_3024 * 0.013450000435113907f)), (((_3022 * 0.02061999961733818f) + (_3023 * 0.10958000272512436f)) + (_3024 * 0.8697999715805054f))), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.875f)) * _2978);
              }
            }
          } else {
            _3056 = (_2978 * 0.009999999776482582f);
          }
        } else {
          _3056 = 0.0f;
        }
      } else {
        if (_2875) {
          float _2889 = (_2868 * 2.0f) + -1.0f;
          float _2890 = 1.0f - (_2869 * 2.0f);
          float _2926 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _2870, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _2890, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _2889))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
          if (!(_2866 == 2)) {
            if (!(_2866 == 3)) {
              if (!(_2866 == 21)) {
                bool _2945 = (_2866 == 22);
                if (!(((int)(_77 == 22)) & (_2945))) {
                  _2952 = select(_2945, 0.0f, 1.0f);
                  _2954 = _2952;
                } else {
                  _2954 = 20.0f;
                }
              } else {
                if (!(_77 == 21)) {
                  _2952 = 0.0f;
                  _2954 = _2952;
                } else {
                  _2954 = 20.0f;
                }
              }
            } else {
              _2952 = 0.0f;
              _2954 = _2952;
            }
          } else {
            if (!(_77 == 2)) {
              _2952 = 0.0f;
              _2954 = _2952;
            } else {
              _2954 = 20.0f;
            }
          }
          if (_2867 == 1.0f) {
            _2977 = saturate(((((_2077 * 0.9375f) - max(0.0f, dot(float3(_2052, _2056, _2060), float3((((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _2870, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _2890, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _2889))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _2926) - _2291), (((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _2870, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _2890, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _2889))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _2926) - _2292), (((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _2870, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _2890, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _2889))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _2926) - _2293))))) * ((_112 * 0.015625f) + 1.5f)) / _2077) * 0.9375f);
          } else {
            _2977 = _2867;
          }
          float _2978 = _2977 * saturate(exp2(min(0.0f, (((_112 * 0.01899999938905239f) + 0.10000000149011612f) + (_2954 * ((_nearFarProj.x / max(1.0000000116860974e-07f, _2871)) - (_nearFarProj.x / max(1.0000000116860974e-07f, _2870)))))) * 1.4426950216293335f));
          int _2979 = _2866 & -2;
          if (!(_2979 == 6)) {
            if ((((_77 == 33) && (_2866 == 33)) || (!(_77 == 33) && (((int)(_77 == 55)) & ((int)(_2866 == 55)))))) {
              _3056 = (_2978 * 0.009999999776482582f);
            } else {
              if (!(((int)(_2866 == 54)) | ((int)(_2979 == 66))) || ((((int)(_2866 == 54)) | ((int)(_2979 == 66))) && (!(((int)(_1945 == 66)) | ((int)(_77 == 54)))))) {
                if (!_169) {
                  if ((uint)((int)(_2866 + -53u)) < (uint)15) {
                    _3053 = saturate(_112 * 0.03125f);
                  } else {
                    _3053 = 1.0f;
                  }
                  _3056 = (_3053 * _2978);
                } else {
                  _3056 = _2978;
                }
              } else {
                uint4 _3008 = __3__36__0__0__g_baseColor.Load(int3(int(_bufferSizeAndInvSize.x * _2868), int(_bufferSizeAndInvSize.y * _2869), 0));
                float _3014 = float((uint)((uint)(((uint)((uint)(_3008.x)) >> 8) & 255))) * 0.003921568859368563f;
                float _3017 = float((uint)((uint)(_3008.x & 255))) * 0.003921568859368563f;
                float _3021 = float((uint)((uint)(((uint)((uint)(_3008.y)) >> 8) & 255))) * 0.003921568859368563f;
                float _3022 = _3014 * _3014;
                float _3023 = _3017 * _3017;
                float _3024 = _3021 * _3021;
                _3056 = (saturate(1.0f - (dot(float3((((_3022 * 0.6131200194358826f) + (_3023 * 0.3395099937915802f)) + (_3024 * 0.047370001673698425f)), (((_3022 * 0.07020000368356705f) + (_3023 * 0.9163600206375122f)) + (_3024 * 0.013450000435113907f)), (((_3022 * 0.02061999961733818f) + (_3023 * 0.10958000272512436f)) + (_3024 * 0.8697999715805054f))), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.875f)) * _2978);
              }
            }
          } else {
            _3056 = (_2978 * 0.009999999776482582f);
          }
        } else {
          _3056 = 0.0f;
        }
      }
      _3060 = saturate(1.0f - _3056);
    } else {
      _3060 = 1.0f;
    }

    // ── Micro Detail Depth-Bias Shadows ───────────────────────────────
    #define MICRO_PIXEL_X_FLOAT   _57
    #define MICRO_PIXEL_Y_FLOAT   _58
    #define MICRO_LINEAR_DEPTH    _112
    #define MICRO_CONTACT_SHADOW  _3060
    #define MICRO_LIGHT_DIR_X     _2052
    #define MICRO_LIGHT_DIR_Y     _2056
    #define MICRO_LIGHT_DIR_Z     _2060
    #define MICRO_WORLD_POS_X     _2291
    #define MICRO_WORLD_POS_Y     _2292
    #define MICRO_WORLD_POS_Z     _2293
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
    if (CONTACT_SHADOW_QUALITY > 0.5f && _3060 < 1.0f) {
      float2 _screenUV = float2((_57 + 0.5f) * _bufferSizeAndInvSize.z,
                                 (_58 + 0.5f) * _bufferSizeAndInvSize.w);
      float2 _edgeDist = min(_screenUV, 1.0f - _screenUV);
      float _edgeFade = saturate(min(_edgeDist.x, _edgeDist.y) * 10.0f);
      _3060 = lerp(lerp(1.0f, _3060, 0.5f), _3060, _edgeFade);
    }

    float _3061 = min(_1935, _3060);
    _3075 = float(half(_3061 * float(_1595)));
    _3076 = float(half(_3061 * float(_1596)));
    _3077 = float(half(_3061 * float(_1597)));
    _3078 = saturate((1.0f - _553) + (exp2(log2(saturate(_1922)) * 0.45454543828964233f) * _553));
    // ── RenoDX Shadow Debug ──────────────────────────────────────────────
    #include "shadow_debug.hlsli"
    // ────────────────────────────────────────────────────────────────────
  }
  __3__38__0__1__g_shadowColorResultUAV[int2(_55, _56)] = half4((float)(half(_3075)), (float)(half(_3076)), (float)(half(_3077)), (float)(half(_3078)));
}
