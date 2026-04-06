#include "../shared.h"
#include "../sky-atmospheric/sky_dawn_dusk_common.hlsli"

struct SurfelData {
  uint _baseColor;
  uint _normal;
  half3 _radiance;
  uint16_t _radius;
};


Texture3D<float> __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav : register(t223, space36);

Texture3D<float> __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav : register(t224, space36);

Texture3D<uint> __3__36__0__0__g_surfelIndicesVoxelsTextures : register(t217, space36);

Texture3D<uint4> __3__36__0__0__g_axisAlignedDistanceTextures : register(t218, space36);

Texture2D<float2> __3__36__0__0__g_texNetDensity : register(t19, space36);

Texture3D<float> __3__36__0__0__g_texCloudVolumeShadow : register(t195, space36);

Texture2D<float4> __3__36__0__0__g_terrainShadowDepth : register(t141, space36);

Texture2DArray<float4> __3__36__0__0__g_dynamicShadowDepthArray : register(t229, space36);

Texture2DArray<float4> __3__36__0__0__g_shadowDepthArray : register(t232, space36);

Texture2DArray<half4> __3__36__0__0__g_shadowColorArray : register(t234, space36);

TextureCube<float4> __3__36__0__0__g_environmentColor : register(t225, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t0, space36);

Texture2D<uint2> __3__36__0__0__g_normalDepth : register(t80, space36);

Texture2D<uint2> __3__36__0__0__g_normalDepthPrev : register(t42, space36);

Texture2D<float4> __3__36__0__0__g_sceneColor : register(t174, space36);

Texture2D<float> __3__36__0__0__g_raytracingDiffuseRayInversePDF : register(t102, space36);

Texture2D<float4> __3__36__0__0__g_raytracingBaseColor : register(t103, space36);

Texture2D<float4> __3__36__0__0__g_raytracingNormal : register(t104, space36);

StructuredBuffer<SurfelData> __3__37__0__0__g_surfelDataBuffer : register(t24, space37);

Texture2D<half4> __3__36__0__0__g_sceneShadowColor : register(t22, space36);

RWTexture2D<float4> __3__38__0__1__g_raytracingHitResultUAV : register(u43, space38);

RWTexture2D<half4> __3__38__0__1__g_diffuseResultUAV : register(u12, space38);

cbuffer __1__3__0__0__PipelineProperty : register(b0, space3) {
  float2 g_screenSpaceScale : packoffset(c000.x);
  float2 __padding : packoffset(c000.z);
};

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

cbuffer __3__35__0__0__VoxelGlobalIlluminationConstantBuffer : register(b2, space35) {
  float4 _voxelParams : packoffset(c000.x);
  float4 _invClipmapExtent : packoffset(c001.x);
  float4 _wrappedViewPosForInject : packoffset(c002.x);
  float4 _clipmapOffsetsForInject[8] : packoffset(c003.x);
  float4 _clipmapRelativeIndexOffsetsForInject[8] : packoffset(c011.x);
  float4 _wrappedViewPos : packoffset(c019.x);
  float4 _clipmapOffsets[8] : packoffset(c020.x);
  float4 _clipmapOffsetsPrev[8] : packoffset(c028.x);
  float4 _clipmapRelativeIndexOffsets[8] : packoffset(c036.x);
  float4 _clipmapUVParams[2] : packoffset(c044.x);
  float4 _clipmapUVRelativeOffset : packoffset(c046.x);
  uint4 _surfelTimestamps : packoffset(c047.x);
};

cbuffer __3__35__0__0__ExposureConstantBuffer : register(b34, space35) {
  float4 _exposure0 : packoffset(c000.x);
  float4 _exposure1 : packoffset(c001.x);
  float4 _exposure2 : packoffset(c002.x);
  float4 _exposure3 : packoffset(c003.x);
  float4 _exposure4 : packoffset(c004.x);
};

cbuffer __3__35__0__0__AtmosphereConstantBuffer : register(b30, space35) {
  float _sunLightIntensity : packoffset(c000.x);
  float _sunLightPreset : packoffset(c000.y);
  float _sunSizeAngle : packoffset(c000.z);
  float _sunDirX : packoffset(c000.w);
  float _sunDirY : packoffset(c001.x);
  float _moonLightIntensity : packoffset(c001.y);
  float _moonLightPreset : packoffset(c001.z);
  float _moonSizeAngle : packoffset(c001.w);
  float _moonDirX : packoffset(c002.x);
  float _moonDirY : packoffset(c002.y);
  float _earthAxisTilt : packoffset(c002.z);
  float _latitude : packoffset(c002.w);
  float _earthRadius : packoffset(c003.x);
  float _atmosphereThickness : packoffset(c003.y);
  float _rayleighScaledHeight : packoffset(c003.z);
  uint _rayleighScatteringColor : packoffset(c003.w);
  float _mieScaledHeight : packoffset(c004.x);
  float _mieAerosolDensity : packoffset(c004.y);
  float _mieAerosolAbsorption : packoffset(c004.z);
  float _miePhaseConst : packoffset(c004.w);
  float _ozoneRatio : packoffset(c005.x);
  float _directionalLightLuminanceScale : packoffset(c005.y);
  float _distanceScale : packoffset(c005.z);
  float _heightFogDensity : packoffset(c005.w);
  float _heightFogBaseline : packoffset(c006.x);
  float _heightFogFalloff : packoffset(c006.y);
  float _heightFogScale : packoffset(c006.z);
  float _cloudBaseDensity : packoffset(c006.w);
  float _cloudBaseContrast : packoffset(c007.x);
  float _cloudBaseScale : packoffset(c007.y);
  float _cloudAlpha : packoffset(c007.z);
  float _cloudScrollMultiplier : packoffset(c007.w);
  float _cloudScatteringCoefficient : packoffset(c008.x);
  float _cloudPhaseConstFront : packoffset(c008.y);
  float _cloudPhaseConstBack : packoffset(c008.z);
  float _cloudAltitude : packoffset(c008.w);
  float _cloudThickness : packoffset(c009.x);
  float _cloudVisibleRange : packoffset(c009.y);
  float _cloudNear : packoffset(c009.z);
  float _cloudFadeRange : packoffset(c009.w);
  float _cloudDetailRatio : packoffset(c010.x);
  float _cloudDetailScale : packoffset(c010.y);
  float _cloudMultiRatio : packoffset(c010.z);
  float _cloudBeerPowderRatio : packoffset(c010.w);
  float _cloudCirrusAltitude : packoffset(c011.x);
  float _cloudCirrusDensity : packoffset(c011.y);
  float _cloudCirrusScale : packoffset(c011.z);
  float _cloudCirrusWeightR : packoffset(c011.w);
  float _cloudCirrusWeightG : packoffset(c012.x);
  float _cloudCirrusWeightB : packoffset(c012.y);
  float _cloudFlow : packoffset(c012.z);
  float _cloudSeed : packoffset(c012.w);
  float4 _volumeFogScatterColor : packoffset(c013.x);
  float4 _mieScatterColor : packoffset(c014.x);
};

cbuffer __3__35__0__0__PrecomputedAmbientConstantBuffer : register(b31, space35) {
  float4 _precomputedAmbient0 : packoffset(c000.x);
  float4 _precomputedAmbient1 : packoffset(c001.x);
  float4 _precomputedAmbient2 : packoffset(c002.x);
  float4 _precomputedAmbient3 : packoffset(c003.x);
  float4 _precomputedAmbient4 : packoffset(c004.x);
  float4 _precomputedAmbient5 : packoffset(c005.x);
  float4 _precomputedAmbient6 : packoffset(c006.x);
  float4 _precomputedAmbient7 : packoffset(c007.x);
  float4 _precomputedAmbients[56] : packoffset(c008.x);
};

cbuffer __3__35__0__0__TileConstantBuffer : register(b33, space35) {
  uint4 g_tileIndex[4096] : packoffset(c000.x);
};

cbuffer __3__1__0__0__RenderVoxelConstants : register(b0, space1) {
  float4 _renderParams : packoffset(c000.x);
  float4 _renderParams2 : packoffset(c001.x);
  float4 _cubemapViewPosRelative : packoffset(c002.x);
  float4 _lightingParams : packoffset(c003.x);
  float4 _tiledRadianceCacheParams : packoffset(c004.x);
  float _rtaoIntensity : packoffset(c005.x);
};

SamplerState __3__40__0__0__g_sampler : register(s1, space40);

SamplerState __3__40__0__0__g_samplerClamp : register(s3, space40);

SamplerState __3__40__0__0__g_samplerTrilinear : register(s7, space40);

SamplerState __0__4__0__0__g_staticBilinearWrapUWClampV : register(s1, space4);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

SamplerState __0__4__0__0__g_staticVoxelSampler : register(s12, space4);

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int _39[4];
  _39[0] = ((g_tileIndex[(SV_GroupID.x) >> 2]).x);
  _39[1] = ((g_tileIndex[(SV_GroupID.x) >> 2]).y);
  _39[2] = ((g_tileIndex[(SV_GroupID.x) >> 2]).z);
  _39[3] = ((g_tileIndex[(SV_GroupID.x) >> 2]).w);
  int _64 = _39[((int)(SV_GroupID.x) & 3)];
  float _71 = float((uint)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x));
  float _72 = float((uint)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y));
  float _89 = ((_bufferSizeAndInvSize.z * 4.0f) * (_71 + 0.5f)) + -1.0f;
  float _92 = 1.0f - ((_bufferSizeAndInvSize.w * 4.0f) * (_72 + 0.5f));
  uint2 _98 = __3__36__0__0__g_normalDepth.Load(int3(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)), 0));
  int _101 = (uint)((uint)(_98.y)) >> 24;
  int _105 = _101 & 127;
  float _120 = min(1.0f, ((float((uint)((uint)(_98.x & 1023))) * 0.001956947147846222f) + -1.0f));
  float _121 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_98.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _122 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_98.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _124 = rsqrt(dot(float3(_120, _121, _122), float3(_120, _121, _122)));
  float _125 = _124 * _120;
  float _126 = _124 * _121;
  float _127 = _124 * _122;
  float _128 = max(1.0000000116860974e-07f, (float((uint)((uint)(_98.y & 16777215))) * 5.960465188081798e-08f));
  float _164 = mad((_invViewProjRelative[3].z), _128, mad((_invViewProjRelative[3].y), _92, ((_invViewProjRelative[3].x) * _89))) + (_invViewProjRelative[3].w);
  float _165 = (mad((_invViewProjRelative[0].z), _128, mad((_invViewProjRelative[0].y), _92, ((_invViewProjRelative[0].x) * _89))) + (_invViewProjRelative[0].w)) / _164;
  float _166 = (mad((_invViewProjRelative[1].z), _128, mad((_invViewProjRelative[1].y), _92, ((_invViewProjRelative[1].x) * _89))) + (_invViewProjRelative[1].w)) / _164;
  float _167 = (mad((_invViewProjRelative[2].z), _128, mad((_invViewProjRelative[2].y), _92, ((_invViewProjRelative[2].x) * _89))) + (_invViewProjRelative[2].w)) / _164;
  float _170 = _nearFarProj.x / _128;
  float _180 = float((uint)((uint)(((int)(((uint)((uint)(_frameNumber.x)) >> 2) * 71)) & 31)));
  bool _197;
  int _250;
  int _308;
  int _329;
  int _392;
  int _393;
  int _394;
  int _395;
  float _452;
  float _453;
  float _454;
  float _455;
  float _456;
  float _457;
  float _458;
  int _459;
  float _671;
  float _672;
  float _673;
  float _674;
  float _691;
  float _692;
  float _693;
  float _733;
  float _734;
  float _735;
  float _742;
  float _743;
  float _744;
  float _745;
  float _746;
  float _747;
  float _748;
  float _749;
  int _750;
  float _751;
  float _752;
  float _753;
  float _754;
  float _755;
  bool _770;
  float _946;
  float _947;
  float _948;
  float _949;
  float _960;
  float _961;
  float _962;
  float _963;
  float _964;
  float _965;
  float _966;
  float _967;
  float _968;
  int _969;
  int _971;
  int _1032;
  int _1033;
  float _1040;
  float _1100;
  float _1101;
  float _1102;
  float _1103;
  int _1109;
  int _1167;
  int _1204;
  float _1205;
  float _1206;
  float _1207;
  float _1208;
  float _1209;
  int _1211;
  float _1428;
  float _1429;
  float _1448;
  float _1449;
  float _1450;
  float _1451;
  float _1452;
  float _1454;
  float _1455;
  float _1456;
  float _1457;
  float _1458;
  float _1459;
  int _1476;
  int _1539;
  int _1540;
  int _1541;
  int _1542;
  int _1558;
  int _1559;
  int _1560;
  int _1561;
  int _1567;
  int _1630;
  int _1631;
  int _1632;
  int _1633;
  int _1638;
  int _1639;
  int _1640;
  int _1641;
  int _1642;
  int _1645;
  int _1646;
  int _1647;
  int _1648;
  int _1651;
  int _1652;
  int _1653;
  int _1654;
  int _1655;
  bool _1678;
  int _1679;
  int _1680;
  int _1681;
  int _1682;
  int _1683;
  int _1692;
  int _1693;
  int _1694;
  int _1695;
  int _1696;
  float _1755;
  float _1756;
  float _1757;
  float _1758;
  int _1759;
  float _1960;
  float _1961;
  float _1962;
  float _1963;
  float _1980;
  float _1981;
  float _1982;
  float _1983;
  float _2011;
  float _2012;
  float _2013;
  float _2014;
  float _2015;
  bool _2029;
  float _2052;
  float _2053;
  float _2054;
  float _2055;
  float _2137;
  float _2138;
  float _2139;
  float _2282;
  float _2283;
  float _2284;
  float _2285;
  half _2286;
  half _2287;
  half _2288;
  half _2289;
  float _2427;
  float _2428;
  float _2429;
  float _2430;
  float _2431;
  float _2432;
  float _2433;
  float _2434;
  half _2435;
  half _2436;
  half _2437;
  half _2438;
  float _2489;
  float _2490;
  float _2491;
  float _2492;
  int _2493;
  int _2494;
  float _2541;
  float _2542;
  float _2543;
  float _2544;
  int _2545;
  int _2546;
  float _2576;
  float _2577;
  float _2578;
  float _2579;
  float _2698;
  float _2699;
  float _2700;
  float _2719;
  float _2720;
  float _2721;
  float _2722;
  float _2804;
  float _2839;
  float _2840;
  float _2841;
  float _2861;
  float _2918;
  float _3016;
  float _3017;
  float _3018;
  float _3086;
  float _3087;
  float _3088;
  float _3089;
  half _3090;
  half _3091;
  half _3092;
  float _3093;
  float _3094;
  float _3095;
  float _3096;
  float _3097;
  float _3229;
  float _3230;
  float _3231;
  float _3335;
  float _3336;
  float _3337;
  float _3338;
  float _3476;
  float _3477;
  float _3478;
  float _3479;
  float _3480;
  float _3511;
  float _3512;
  float _3513;
  float _3514;
  int _3515;
  int _3516;
  float _3547;
  float _3548;
  float _3549;
  float _3550;
  int _3551;
  int _3552;
  float _3582;
  float _3583;
  float _3584;
  float _3585;
  float _3597;
  float _3598;
  float _3599;
  float _3618;
  float _3677;
  float _3734;
  float _3786;
  float _3852;
  float _3853;
  float _3854;
  float _3907;
  float _3908;
  float _3909;
  float _3929;
  float _3930;
  float _3931;
  float _3932;
  int _3943;
  int _4001;
  float _4042;
  float _4068;
  float _4069;
  float _4070;
  float _4127;
  float _4128;
  float _4129;
  int _4232;
  int _4290;
  int _4303;
  float _4304;
  float _4305;
  float _4306;
  float _4307;
  float _4308;
  float _4309;
  float _4310;
  float _4311;
  int _4313;
  int _4363;
  int _4426;
  int _4427;
  int _4428;
  int _4429;
  int _4447;
  int _4448;
  int _4449;
  int _4450;
  int _4457;
  int _4520;
  int _4521;
  int _4522;
  int _4523;
  int _4528;
  int _4529;
  int _4530;
  int _4531;
  int _4532;
  int _4535;
  int _4536;
  int _4537;
  int _4538;
  int _4541;
  int _4542;
  int _4543;
  int _4544;
  int _4545;
  bool _4568;
  int _4569;
  int _4570;
  int _4571;
  int _4572;
  int _4573;
  int _4582;
  int _4583;
  int _4584;
  int _4585;
  int _4586;
  float _4645;
  float _4646;
  float _4647;
  float _4648;
  int _4649;
  float _4844;
  float _4845;
  float _4846;
  float _4847;
  float _4864;
  float _4865;
  float _4866;
  float _4892;
  float _4893;
  float _4894;
  float _4895;
  float _4897;
  float _4898;
  float _4899;
  float _4900;
  float _4929;
  float _4930;
  float _4931;
  float _4951;
  float _5011;
  float _5109;
  float _5110;
  float _5111;
  float _5294;
  float _5295;
  float _5296;
  float _5297;
  float _5435;
  float _5436;
  float _5437;
  float _5438;
  float _5439;
  int _5490;
  int _5491;
  float _5492;
  float _5493;
  float _5494;
  float _5495;
  int _5542;
  int _5543;
  float _5544;
  float _5545;
  float _5546;
  float _5547;
  float _5577;
  float _5578;
  float _5579;
  float _5580;
  float _5592;
  float _5593;
  float _5594;
  float _5613;
  float _5695;
  float _5713;
  float _5714;
  float _5715;
  float _5729;
  float _5730;
  float _5731;
  bool _5761;
  int _5762;
  int _5763;
  int _5764;
  int _5765;
  int _5766;
  bool _5775;
  int _5776;
  int _5777;
  int _5778;
  int _5779;
  int _5780;
  if (!((uint)_105 > (uint)11) | !((((uint)_105 < (uint)20)) || ((_105 == 107)))) {
    _197 = (_105 == 20);
  } else {
    _197 = true;
  }
  float4 _199 = __3__38__0__1__g_raytracingHitResultUAV.Load(int2(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y))));
  float _205 = rsqrt(dot(float3(_199.x, _199.y, _199.z), float3(_199.x, _199.y, _199.z)));
  float _206 = _205 * _199.x;
  float _207 = _205 * _199.y;
  float _208 = _205 * _199.z;
  bool _209 = (_199.w < 0.0f);
  float _210 = abs(_199.w);
  if (((_210 > 0.0f)) && ((_210 < 10000.0f))) {
    float4 _216 = __3__36__0__0__g_raytracingBaseColor.Load(int3(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)), 0));
    float4 _222 = __3__36__0__0__g_raytracingNormal.Load(int3(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)), 0));
    float _230 = (_222.x * 2.0f) + -1.0f;
    float _231 = (_222.y * 2.0f) + -1.0f;
    float _232 = (_222.z * 2.0f) + -1.0f;
    float _234 = rsqrt(dot(float3(_230, _231, _232), float3(_230, _231, _232)));
    float _235 = _230 * _234;
    float _236 = _231 * _234;
    float _237 = _232 * _234;
    float _238 = select(_209, 0.0f, _235);
    float _239 = select(_209, 0.0f, _236);
    float _240 = select(_209, 0.0f, _237);
    int _242 = (int)(uint)((int)(_216.w > 0.0f));
    float _243 = _206 * _210;
    float _244 = _207 * _210;
    float _245 = _208 * _210;
    float _246 = _243 + _165;
    float _247 = _244 + _166;
    float _248 = _245 + _167;
    _250 = 0;
    while(true) {
      int _290 = int(floor(((_wrappedViewPos.x + _246) * ((_clipmapOffsets[_250]).w)) + ((_clipmapRelativeIndexOffsets[_250]).x)));
      int _291 = int(floor(((_wrappedViewPos.y + _247) * ((_clipmapOffsets[_250]).w)) + ((_clipmapRelativeIndexOffsets[_250]).y)));
      int _292 = int(floor(((_wrappedViewPos.z + _248) * ((_clipmapOffsets[_250]).w)) + ((_clipmapRelativeIndexOffsets[_250]).z)));
      if (!((((((((int)_290 >= (int)int(((_clipmapOffsets[_250]).x) + -63.0f))) && (((int)_290 < (int)int(((_clipmapOffsets[_250]).x) + 63.0f))))) && (((((int)_291 >= (int)int(((_clipmapOffsets[_250]).y) + -31.0f))) && (((int)_291 < (int)int(((_clipmapOffsets[_250]).y) + 31.0f))))))) && (((((int)_292 >= (int)int(((_clipmapOffsets[_250]).z) + -63.0f))) && (((int)_292 < (int)int(((_clipmapOffsets[_250]).z) + 63.0f))))))) {
        if ((uint)(_250 + 1) < (uint)8) {
          _250 = (_250 + 1);
          continue;
        } else {
          _308 = -10000;
        }
      } else {
        _308 = _250;
      }
      float _315 = -0.0f - _206;
      float _316 = -0.0f - _207;
      float _317 = -0.0f - _208;
      float _321 = min(_210, (float((int)((int)(1u << (_308 & 31)))) * _voxelParams.x));
      _329 = 0;
      while(true) {
        int _369 = int(floor(((((_321 * select(_209, _315, _235)) + _246) + _wrappedViewPos.x) * ((_clipmapOffsets[_329]).w)) + ((_clipmapRelativeIndexOffsets[_329]).x)));
        int _370 = int(floor(((((_321 * select(_209, _316, _236)) + _247) + _wrappedViewPos.y) * ((_clipmapOffsets[_329]).w)) + ((_clipmapRelativeIndexOffsets[_329]).y)));
        int _371 = int(floor(((((_321 * select(_209, _317, _237)) + _248) + _wrappedViewPos.z) * ((_clipmapOffsets[_329]).w)) + ((_clipmapRelativeIndexOffsets[_329]).z)));
        if ((((((((int)_369 >= (int)int(((_clipmapOffsets[_329]).x) + -63.0f))) && (((int)_369 < (int)int(((_clipmapOffsets[_329]).x) + 63.0f))))) && (((((int)_370 >= (int)int(((_clipmapOffsets[_329]).y) + -31.0f))) && (((int)_370 < (int)int(((_clipmapOffsets[_329]).y) + 31.0f))))))) && (((((int)_371 >= (int)int(((_clipmapOffsets[_329]).z) + -63.0f))) && (((int)_371 < (int)int(((_clipmapOffsets[_329]).z) + 63.0f)))))) {
          _392 = (_369 & 127);
          _393 = (_370 & 63);
          _394 = (_371 & 127);
          _395 = _329;
        } else {
          if ((uint)(_329 + 1) < (uint)8) {
            _329 = (_329 + 1);
            continue;
          } else {
            _392 = -10000;
            _393 = -10000;
            _394 = -10000;
            _395 = -10000;
          }
        }
        if (((_395 != -10000)) && (((int)_395 < (int)4))) {
          if ((uint)_395 < (uint)6) {
            uint _402 = _395 * 130;
            uint _406 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_392, _393, ((int)(((uint)((int)(_402) | 1)) + (uint)(_394))), 0));
            int _408 = _406.x & 4194303;
            [branch]
            if (!(_408 == 0)) {
              float _414 = float((int)((int)(1u << (_395 & 31)))) * _voxelParams.x;
              _452 = 0.0f;
              _453 = 0.0f;
              _454 = 0.0f;
              _455 = _238;
              _456 = _239;
              _457 = _240;
              _458 = 0.0f;
              _459 = 0;
              while(true) {
                int _464 = __3__37__0__0__g_surfelDataBuffer[((_408 + -1) + _459)]._baseColor;
                int _466 = __3__37__0__0__g_surfelDataBuffer[((_408 + -1) + _459)]._normal;
                int16_t _469 = __3__37__0__0__g_surfelDataBuffer[((_408 + -1) + _459)]._radius;
                if (!(_464 == 0)) {
                  half _472 = __3__37__0__0__g_surfelDataBuffer[((_408 + -1) + _459)]._radiance.z;
                  half _473 = __3__37__0__0__g_surfelDataBuffer[((_408 + -1) + _459)]._radiance.y;
                  half _474 = __3__37__0__0__g_surfelDataBuffer[((_408 + -1) + _459)]._radiance.x;
                  float _480 = float((uint)((uint)(_464 & 255)));
                  float _481 = float((uint)((uint)(((uint)((uint)(_464)) >> 8) & 255)));
                  float _482 = float((uint)((uint)(((uint)((uint)(_464)) >> 16) & 255)));
                  float _507 = select(((_480 * 0.003921568859368563f) < 0.040449999272823334f), (_480 * 0.0003035269910469651f), exp2(log2((_480 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _508 = select(((_481 * 0.003921568859368563f) < 0.040449999272823334f), (_481 * 0.0003035269910469651f), exp2(log2((_481 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _509 = select(((_482 * 0.003921568859368563f) < 0.040449999272823334f), (_482 * 0.0003035269910469651f), exp2(log2((_482 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _521 = (float((uint)((uint)(_466 & 255))) * 0.007874015718698502f) + -1.0f;
                  float _522 = (float((uint)((uint)(((uint)((uint)(_466)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                  float _523 = (float((uint)((uint)(((uint)((uint)(_466)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                  float _525 = rsqrt(dot(float3(_521, _522, _523), float3(_521, _522, _523)));
                  bool _530 = ((_466 & 16777215) == 0);
                  float _534 = float(_474);
                  float _535 = float(_473);
                  float _536 = float(_472);
                  float _540 = (_414 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_469) & 255)));
                  float _556 = (((float((uint)((uint)((uint)((uint)(_464)) >> 24))) * 0.003937007859349251f) + -0.5f) * _414) + ((((((_clipmapOffsets[_395]).x) + -63.5f) + float((int)(((int)(((uint)(_392 + 64)) - (uint)(int((_clipmapOffsets[_395]).x)))) & 127))) * _414) - _viewPos.x);
                  float _557 = (((float((uint)((uint)((uint)((uint)(_466)) >> 24))) * 0.003937007859349251f) + -0.5f) * _414) + ((((((_clipmapOffsets[_395]).y) + -31.5f) + float((int)(((int)(((uint)(_393 + 32)) - (uint)(int((_clipmapOffsets[_395]).y)))) & 63))) * _414) - _viewPos.y);
                  float _558 = (((float((uint16_t)((uint)((uint16_t)((uint)(_469)) >> 8))) * 0.003937007859349251f) + -0.5f) * _414) + ((((((_clipmapOffsets[_395]).z) + -63.5f) + float((int)(((int)(((uint)(_394 + 64)) - (uint)(int((_clipmapOffsets[_395]).z)))) & 127))) * _414) - _viewPos.z);
                  bool _576 = (_222.w == 0.0f);
                  float _577 = select(_576, _315, _455);
                  float _578 = select(_576, _316, _456);
                  float _579 = select(_576, _317, _457);
                  float _582 = ((-0.0f - _165) - _243) + _556;
                  float _585 = ((-0.0f - _166) - _244) + _557;
                  float _588 = ((-0.0f - _167) - _245) + _558;
                  float _589 = dot(float3(_582, _585, _588), float3(_577, _578, _579));
                  float _593 = _582 - (_589 * _577);
                  float _594 = _585 - (_589 * _578);
                  float _595 = _588 - (_589 * _579);
                  float _621 = 1.0f / float((uint)(1u << (_395 & 31)));
                  float _625 = frac(((_invClipmapExtent.z * _558) + _clipmapUVRelativeOffset.z) * _621);
                  float _636 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _556) + _clipmapUVRelativeOffset.x) * _621), (((_invClipmapExtent.y * _557) + _clipmapUVRelativeOffset.y) * _621), (((float((uint)_402) + 1.0f) + ((select((_625 < 0.0f), 1.0f, 0.0f) + _625) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                  float _650 = select(((int)_395 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_315, _316, _317), float3(select(_530, _315, (_525 * _521)), select(_530, _316, (_525 * _522)), select(_530, _317, (_525 * _523))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_593, _594, _595), float3(_593, _594, _595)) < ((_540 * _540) * 16.0f)))) * float((bool)(uint)(_636.x > ((_414 * 0.25f) * (saturate((dot(float3(_534, _535, _536), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                  bool _654 = ((!(_216.w > 0.0f))) || (((_464 & 16777215) == 16777215));
                  float _664 = ((select(_654, (((_508 * 0.3395099937915802f) + (_507 * 0.6131200194358826f)) + (_509 * 0.047370001673698425f)), _216.x) * _534) * _650) + _452;
                  float _665 = ((select(_654, (((_508 * 0.9163600206375122f) + (_507 * 0.07020000368356705f)) + (_509 * 0.013450000435113907f)), _216.y) * _535) * _650) + _453;
                  float _666 = ((select(_654, (((_508 * 0.10958000272512436f) + (_507 * 0.02061999961733818f)) + (_509 * 0.8697999715805054f)), _216.z) * _536) * _650) + _454;
                  float _667 = _650 + _458;
                  if ((uint)(_459 + 1) < (uint)renodx::math::Select(RT_QUALITY >= 1.f, 8.f, 4.f)) {
                    _452 = _664;
                    _453 = _665;
                    _454 = _666;
                    _455 = _577;
                    _456 = _578;
                    _457 = _579;
                    _458 = _667;
                    _459 = (_459 + 1);
                    continue;
                  } else {
                    _671 = _664;
                    _672 = _665;
                    _673 = _666;
                    _674 = _667;
                  }
                } else {
                  _671 = _452;
                  _672 = _453;
                  _673 = _454;
                  _674 = _458;
                }
                if (_674 > 0.0f) {
                  float _677 = 1.0f / _674;
                  _691 = (-0.0f - min(0.0f, (-0.0f - (_671 * _677))));
                  _692 = (-0.0f - min(0.0f, (-0.0f - (_672 * _677))));
                  _693 = (-0.0f - min(0.0f, (-0.0f - (_673 * _677))));
                } else {
                  _691 = _671;
                  _692 = _672;
                  _693 = _673;
                }
                break;
              }
            } else {
              _691 = 0.0f;
              _692 = 0.0f;
              _693 = 0.0f;
            }
          } else {
            _691 = 0.0f;
            _692 = 0.0f;
            _693 = 0.0f;
          }
          float _697 = max(9.999999974752427e-07f, (_exposure3.w * 0.0010000000474974513f));
          float _698 = max(_697, _691);
          float _699 = max(_697, _692);
          float _700 = max(_697, _693);
          float _703 = dot(float3(_698, _699, _700), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
          float _704 = min((max(0.0005000000237487257f, _exposure3.w) * 512.0f), _703);
          float _708 = max(9.999999717180685e-10f, _703);
          float _709 = (_704 * _698) / _708;
          float _710 = (_704 * _699) / _708;
          float _711 = (_704 * _700) / _708;
          if (saturate(_222.w) == 0.0f) {
            float _725 = (exp2((saturate(saturate(_216.w)) * 20.0f) + -8.0f) + -0.00390625f) * (1.0f / (((_210 * _210) * 0.10000000149011612f) + 1.0f));
            _733 = ((_725 * _216.x) + _709);
            _734 = ((_725 * _216.y) + _710);
            _735 = ((_725 * _216.z) + _711);
          } else {
            _733 = _709;
            _734 = _710;
            _735 = _711;
          }
          _742 = _238;
          _743 = _239;
          _744 = _240;
          _745 = _222.w;
          _746 = _216.x;
          _747 = _216.y;
          _748 = _216.z;
          _749 = _216.w;
          _750 = _242;
          _751 = (_renderParams2.y * _733);
          _752 = (_renderParams2.y * _734);
          _753 = (_renderParams2.y * _735);
          _754 = 1.0f;
          _755 = _210;
        } else {
          _742 = _238;
          _743 = _239;
          _744 = _240;
          _745 = _222.w;
          _746 = _216.x;
          _747 = _216.y;
          _748 = _216.z;
          _749 = _216.w;
          _750 = _242;
          _751 = 0.0f;
          _752 = 0.0f;
          _753 = 0.0f;
          _754 = 1.0f;
          _755 = _210;
        }
        break;
      }
      break;
    }
  } else {
    _742 = 0.0f;
    _743 = 0.0f;
    _744 = 0.0f;
    _745 = 0.0f;
    _746 = 0.0f;
    _747 = 0.0f;
    _748 = 0.0f;
    _749 = 0.0f;
    _750 = 0;
    _751 = 0.0f;
    _752 = 0.0f;
    _753 = 0.0f;
    _754 = 0.0f;
    _755 = 0.0f;
  }
  bool _757 = (_755 > 0.0f);
  if (((_170 > (_lightingParams.z * 0.875f))) && ((!_757))) {
    _770 = (_170 < (_voxelParams.x * 11585.1259765625f));
  } else {
    _770 = false;
  }
  float _774 = (_755 * _206) + _165;
  float _775 = (_755 * _207) + _166;
  float _776 = (_755 * _208) + _167;
  float _812 = mad((_viewProjRelativePrev[3].z), _776, mad((_viewProjRelativePrev[3].y), _775, ((_viewProjRelativePrev[3].x) * _774))) + (_viewProjRelativePrev[3].w);
  float _813 = (mad((_viewProjRelativePrev[0].z), _776, mad((_viewProjRelativePrev[0].y), _775, ((_viewProjRelativePrev[0].x) * _774))) + (_viewProjRelativePrev[0].w)) / _812;
  float _814 = (mad((_viewProjRelativePrev[1].z), _776, mad((_viewProjRelativePrev[1].y), _775, ((_viewProjRelativePrev[1].x) * _774))) + (_viewProjRelativePrev[1].w)) / _812;
  float _815 = (mad((_viewProjRelativePrev[2].z), _776, mad((_viewProjRelativePrev[2].y), _775, ((_viewProjRelativePrev[2].x) * _774))) + (_viewProjRelativePrev[2].w)) / _812;
  float _818 = (_813 * 0.5f) + 0.5f;
  float _819 = 0.5f - (_814 * 0.5f);
  bool __defer_769_832 = false;
  if (_209) {
    if (_757) {
      __defer_769_832 = true;
    } else {
      _960 = _755;
      _961 = _742;
      _962 = _743;
      _963 = _744;
      _964 = _745;
      _965 = 0.0f;
      _966 = 0.0f;
      _967 = 0.0f;
      _968 = 0.0f;
      _969 = 0;
    }
  } else {
    if ((_757) && ((((_815 > 0.0f)) && ((((((_818 >= 0.0f)) && ((_818 <= 1.0f)))) && ((((_819 >= 0.0f)) && ((_819 <= 1.0f))))))))) {
      __defer_769_832 = true;
    } else {
      _960 = _755;
      _961 = _742;
      _962 = _743;
      _963 = _744;
      _964 = _745;
      _965 = 0.0f;
      _966 = 0.0f;
      _967 = 0.0f;
      _968 = 0.0f;
      _969 = 0;
    }
  }
  if (__defer_769_832) {
    uint2 _842 = __3__36__0__0__g_normalDepthPrev.Load(int3(int(((_813 * 0.25f) + 0.25f) * _bufferSizeAndInvSize.x), int((0.25f - (_814 * 0.25f)) * _bufferSizeAndInvSize.y), 0));
    float _848 = _nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_842.y & 16777215))) * 5.960465188081798e-08f));
    if (((_815 > 0.0f)) && ((((((_818 >= 0.0f)) && ((_818 <= 1.0f)))) && ((((_819 >= 0.0f)) && ((_819 <= 1.0f))))))) {
      if ((((_848 - dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z))) > 0.0f)) && ((abs(_848 - _812) < max(0.5f, (_812 * 0.05000000074505806f))))) {
        float4 _879 = __3__36__0__0__g_sceneColor.SampleLevel(__3__40__0__0__g_samplerClamp, float2(_818, _819), 0.0f);
        if (!(!(_879.w >= 0.0f))) {
          uint2 _896 = __3__36__0__0__g_normalDepth.Load(int3((int)(uint(((g_screenSpaceScale.x * _bufferSizeAndInvSize.x) * _818) + 0.5f)), (int)(uint(((g_screenSpaceScale.y * _bufferSizeAndInvSize.y) * _819) + 0.5f)), 0));
          float _913 = min(1.0f, ((float((uint)((uint)(_896.x & 1023))) * 0.001956947147846222f) + -1.0f));
          float _914 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_896.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _915 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_896.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _917 = rsqrt(dot(float3(_913, _914, _915), float3(_913, _914, _915)));
          float _918 = _917 * _913;
          float _919 = _917 * _914;
          float _920 = _917 * _915;
          float _929 = select((dot(float3((-0.0f - _206), (-0.0f - _207), (-0.0f - _208)), float3(_918, _919, _920)) > 0.20000000298023224f), 1.0f, 0.0f);
          float _931 = saturate(_170 * 0.009999999776482582f);
          float _936 = _nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_896.y & 16777215))) * 5.960465188081798e-08f));
          if (_209) {
            _946 = _918;
            _947 = _919;
            _948 = _920;
            _949 = 0.800000011920929f;
          } else {
            _946 = _742;
            _947 = _743;
            _948 = _744;
            _949 = _745;
          }
          float _950 = _renderParams2.x * _renderParams2.x;
          float _951 = float((bool)(uint)(abs(_nearFarProj.x - _936) < (_936 * 0.5f))) * ((_929 - (_929 * _931)) + _931);
          _960 = ((_755 * 0.9998999834060669f) * _renderParams2.x);
          _961 = _946;
          _962 = _947;
          _963 = _948;
          _964 = _949;
          _965 = ((_951 * min(10000.0f, _879.x)) * _950);
          _966 = ((_951 * min(10000.0f, _879.y)) * _950);
          _967 = ((_951 * min(10000.0f, _879.z)) * _950);
          _968 = _950;
          _969 = 1;
        } else {
          _960 = _755;
          _961 = _742;
          _962 = _743;
          _963 = _744;
          _964 = _745;
          _965 = 0.0f;
          _966 = 0.0f;
          _967 = 0.0f;
          _968 = 0.0f;
          _969 = 0;
        }
      } else {
        _960 = _755;
        _961 = _742;
        _962 = _743;
        _963 = _744;
        _964 = _745;
        _965 = 0.0f;
        _966 = 0.0f;
        _967 = 0.0f;
        _968 = 0.0f;
        _969 = 0;
      }
    } else {
      _960 = _755;
      _961 = _742;
      _962 = _743;
      _963 = _744;
      _964 = _745;
      _965 = 0.0f;
      _966 = 0.0f;
      _967 = 0.0f;
      _968 = 0.0f;
      _969 = 0;
    }
  }
  _971 = 0;
  while(true) {
    int _1011 = int(floor(((_wrappedViewPos.x + _165) * ((_clipmapOffsets[_971]).w)) + ((_clipmapRelativeIndexOffsets[_971]).x)));
    int _1012 = int(floor(((_wrappedViewPos.y + _166) * ((_clipmapOffsets[_971]).w)) + ((_clipmapRelativeIndexOffsets[_971]).y)));
    int _1013 = int(floor(((_wrappedViewPos.z + _167) * ((_clipmapOffsets[_971]).w)) + ((_clipmapRelativeIndexOffsets[_971]).z)));
    if ((((((((int)_1011 >= (int)int(((_clipmapOffsets[_971]).x) + -63.0f))) && (((int)_1011 < (int)int(((_clipmapOffsets[_971]).x) + 63.0f))))) && (((((int)_1012 >= (int)int(((_clipmapOffsets[_971]).y) + -31.0f))) && (((int)_1012 < (int)int(((_clipmapOffsets[_971]).y) + 31.0f))))))) && (((((int)_1013 >= (int)int(((_clipmapOffsets[_971]).z) + -63.0f))) && (((int)_1013 < (int)int(((_clipmapOffsets[_971]).z) + 63.0f)))))) {
      _1032 = (_1011 & 127);
      _1033 = _971;
    } else {
      if ((uint)(_971 + 1) < (uint)8) {
        _971 = (_971 + 1);
        continue;
      } else {
        _1032 = -10000;
        _1033 = -10000;
      }
    }
    if (!(_1032 == -10000)) {
      _1040 = float((int)((int)(1u << (_1033 & 31))));
    } else {
      _1040 = 1.0f;
    }
    float _1046 = select(_197, (((frac(frac(dot(float2(((_180 * 32.665000915527344f) + _71), ((_180 * 11.8149995803833f) + _72)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 2.0f) * _1040) * _voxelParams.x), 0.0f);
    if (_770) {
      float _1048 = _lightingParams.z * 1.3434898853302002f;
      float _1049 = -0.0f - _1048;
      if (((((_167 > _1049)) && ((_167 < _1048)))) && ((((((_165 > _1049)) && ((_165 < _1048)))) && ((((_166 > _1049)) && ((_166 < _1048))))))) {
        float _1062 = 1.0f / _206;
        float _1063 = 1.0f / _207;
        float _1064 = 1.0f / _208;
        float _1068 = _1062 * (_1049 - _165);
        float _1069 = _1063 * (_1049 - _166);
        float _1070 = _1064 * (_1049 - _167);
        float _1074 = _1062 * (_1048 - _165);
        float _1075 = _1063 * (_1048 - _166);
        float _1076 = _1064 * (_1048 - _167);
        float _1086 = min(min(max(_1068, _1074), max(_1069, _1075)), max(_1070, _1076));
        if (((_1086 > 0.0f)) && ((((_1086 >= 0.0f)) && ((max(max(min(_1068, _1074), min(_1069, _1075)), min(_1070, _1076)) <= _1086))))) {
          _1100 = _1086;
          _1101 = ((_1086 * _206) + _165);
          _1102 = ((_1086 * _207) + _166);
          _1103 = ((_1086 * _208) + _167);
        } else {
          _1100 = 0.0f;
          _1101 = _165;
          _1102 = _166;
          _1103 = _167;
        }
      } else {
        _1100 = 0.0f;
        _1101 = _165;
        _1102 = _166;
        _1103 = _167;
      }
      float _1107 = select((((_960 > 0.0f)) && ((_968 >= 1.0f))), _960, 256.0f);
      _1109 = 0;
      while(true) {
        int _1149 = int(floor(((_wrappedViewPos.x + _1101) * ((_clipmapOffsets[_1109]).w)) + ((_clipmapRelativeIndexOffsets[_1109]).x)));
        int _1150 = int(floor(((_wrappedViewPos.y + _1102) * ((_clipmapOffsets[_1109]).w)) + ((_clipmapRelativeIndexOffsets[_1109]).y)));
        int _1151 = int(floor(((_wrappedViewPos.z + _1103) * ((_clipmapOffsets[_1109]).w)) + ((_clipmapRelativeIndexOffsets[_1109]).z)));
        if (!((((((((int)_1149 >= (int)int(((_clipmapOffsets[_1109]).x) + -63.0f))) && (((int)_1149 < (int)int(((_clipmapOffsets[_1109]).x) + 63.0f))))) && (((((int)_1150 >= (int)int(((_clipmapOffsets[_1109]).y) + -31.0f))) && (((int)_1150 < (int)int(((_clipmapOffsets[_1109]).y) + 31.0f))))))) && (((((int)_1151 >= (int)int(((_clipmapOffsets[_1109]).z) + -63.0f))) && (((int)_1151 < (int)int(((_clipmapOffsets[_1109]).z) + 63.0f))))))) {
          if ((uint)(_1109 + 1) < (uint)8) {
            _1109 = (_1109 + 1);
            continue;
          } else {
            _1167 = -10000;
          }
        } else {
          _1167 = _1109;
        }
        if (!(((_1167 == -10000)) || (((int)_1167 > (int)4)))) {
          float _1177 = _1101 + (_1046 * _206);
          float _1178 = _1102 + (_1046 * _207);
          float _1179 = _1103 + (_1046 * _208);
          bool _1183 = (_206 == 0.0f);
          bool _1184 = (_207 == 0.0f);
          bool _1185 = (_208 == 0.0f);
          float _1186 = select(_1183, 0.0f, (1.0f / _206));
          float _1187 = select(_1184, 0.0f, (1.0f / _207));
          float _1188 = select(_1185, 0.0f, (1.0f / _208));
          bool _1189 = (_206 > 0.0f);
          bool _1190 = (_207 > 0.0f);
          bool _1191 = (_208 > 0.0f);
          if (_1107 > 0.0f) {
            _1204 = 0;
            _1205 = 0.0f;
            _1206 = 0.0f;
            _1207 = _1179;
            _1208 = _1178;
            _1209 = _1177;
            while(true) {
              _1211 = 0;
              while(true) {
                float _1236 = ((_wrappedViewPos.x + _1209) * ((_clipmapOffsets[_1211]).w)) + ((_clipmapRelativeIndexOffsets[_1211]).x);
                float _1237 = ((_wrappedViewPos.y + _1208) * ((_clipmapOffsets[_1211]).w)) + ((_clipmapRelativeIndexOffsets[_1211]).y);
                float _1238 = ((_wrappedViewPos.z + _1207) * ((_clipmapOffsets[_1211]).w)) + ((_clipmapRelativeIndexOffsets[_1211]).z);
                bool __defer_1210_1253 = false;
                if (!(((_1238 >= (((_clipmapOffsets[_1211]).z) + -63.0f))) && ((((_1236 >= (((_clipmapOffsets[_1211]).x) + -63.0f))) && ((_1237 >= (((_clipmapOffsets[_1211]).y) + -31.0f)))))) || ((((_1238 >= (((_clipmapOffsets[_1211]).z) + -63.0f))) && ((((_1236 >= (((_clipmapOffsets[_1211]).x) + -63.0f))) && ((_1237 >= (((_clipmapOffsets[_1211]).y) + -31.0f)))))) && (!(((_1238 < (((_clipmapOffsets[_1211]).z) + 63.0f))) && ((((_1236 < (((_clipmapOffsets[_1211]).x) + 63.0f))) && ((_1237 < (((_clipmapOffsets[_1211]).y) + 31.0f))))))))) {
                  __defer_1210_1253 = true;
                } else {
                  if (_1211 == -10000) {
                    _1448 = _1206;
                    _1449 = _1207;
                    _1450 = _1208;
                    _1451 = _1209;
                    _1452 = _1205;
                    _1454 = _1448;
                    _1455 = _1449;
                    _1456 = _1450;
                    _1457 = _1451;
                    _1458 = _1452;
                    _1459 = -10000.0f;
                  } else {
                    float _1261 = float((int)((int)(1u << (_1211 & 31))));
                    float _1262 = _1261 * _voxelParams.x;
                    float _1263 = 1.0f / _1261;
                    float _1264 = _voxelParams.y * 0.0078125f;
                    float _1273 = _1263 * ((_1209 * _1264) + _clipmapUVRelativeOffset.x);
                    float _1274 = _1263 * (((_voxelParams.y * 0.015625f) * _1208) + _clipmapUVRelativeOffset.y);
                    float _1275 = _1263 * ((_1207 * _1264) + _clipmapUVRelativeOffset.z);
                    float _1276 = _1273 * 64.0f;
                    float _1277 = _1274 * 32.0f;
                    float _1278 = _1275 * 64.0f;
                    int _1282 = int(floor(_1276));
                    int _1283 = int(floor(_1277));
                    int _1284 = int(floor(_1278));
                    uint4 _1291 = __3__36__0__0__g_axisAlignedDistanceTextures.Load(int4((_1282 & 63), (_1283 & 31), ((_1284 & 63) | (_1211 << 6)), 0));
                    float _1308 = saturate(float((uint)((uint)((uint)((uint)(_1291.w)) >> 2))) * 0.01587301678955555f);
                    float _1331 = _1276 - float((int)(_1282));
                    float _1332 = _1277 - float((int)(_1283));
                    float _1333 = _1278 - float((int)(_1284));
                    float _1364 = max(((_1262 * 0.5f) * min(min(select(_1183, 999999.0f, ((select(_1189, 1.0f, 0.0f) - frac(_1273 * 256.0f)) * _1186)), select(_1184, 999999.0f, ((select(_1190, 1.0f, 0.0f) - frac(_1274 * 128.0f)) * _1187))), select(_1185, 999999.0f, ((select(_1191, 1.0f, 0.0f) - frac(_1275 * 256.0f)) * _1188)))), ((_1262 * 2.0f) * min(min(select(_1183, 999999.0f, (select(_1189, ((0.009999999776482582f - _1331) + float((uint)((uint)(((uint)((uint)(_1291.x)) >> 4) & 15)))), ((0.9900000095367432f - _1331) - float((uint)((uint)(_1291.x & 15))))) * _1186)), select(_1184, 999999.0f, (select(_1190, ((0.009999999776482582f - _1332) + float((uint)((uint)(((uint)((uint)(_1291.y)) >> 4) & 15)))), ((0.9900000095367432f - _1332) - float((uint)((uint)(_1291.y & 15))))) * _1187))), select(_1185, 999999.0f, (select(_1191, ((0.009999999776482582f - _1333) + float((uint)((uint)(((uint)((uint)(_1291.z)) >> 4) & 15)))), ((0.9900000095367432f - _1333) - float((uint)((uint)(_1291.z & 15))))) * _1188)))));
                    float _1366 = float((bool)(uint)(_1308 > 0.0f));
                    if ((((uint)_1204 < (uint)16)) || ((_1206 < min(32.0f, (_1262 * 32.0f))))) {
                      float _1373 = frac(_1275);
                      float _1385 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_1273, _1274, (((float((uint)(_1211 * 130)) + 1.0f) + ((select((_1373 < 0.0f), 1.0f, 0.0f) + _1373) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                      float _1391 = _1206 * 0.009999999776482582f;
                      float _1392 = 1.0f / _1262;
                      float _1408 = (_1385.x + ((_170 * _170) * 0.00019999999494757503f)) / (((max(((_1262 * 1.0606600046157837f) * saturate((_1206 * 0.5f) + 0.5f)), _1391) - _1391) * saturate(((max(1.0f, (_1392 * 0.5f)) * _1392) * min(_1206, max(0.0f, (_1107 - _1206)))) + -1.0f)) + _1391);
                      float _1414 = saturate((saturate(1.0f - (_1408 * _1408)) * _1366) + _1205);
                      if (!((((int)_1211 > (int)2)) || ((_1385.x > _1262)))) {
                        _1428 = _1414;
                        _1429 = min(_1364, _1385.x);
                      } else {
                        _1428 = _1414;
                        _1429 = _1364;
                      }
                    } else {
                      if (!((_1291.w & 1) == 0)) {
                        _1428 = saturate((_1366 * 0.5f) + _1205);
                        _1429 = _1364;
                      } else {
                        _1428 = _1205;
                        _1429 = _1364;
                      }
                    }
                    if (!(_1428 >= 0.5f)) {
                      float _1434 = max(_1429, (_voxelParams.x * 0.05000000074505806f));
                      float _1435 = _1434 + _1206;
                      float _1439 = (_1434 * _206) + _1209;
                      float _1440 = (_1434 * _207) + _1208;
                      float _1441 = (_1434 * _208) + _1207;
                      if ((((uint)(_1204 + 1) < (uint)192)) && ((_1435 < _1107))) {
                        _1204 = (_1204 + 1);
                        _1205 = _1428;
                        _1206 = _1435;
                        _1207 = _1441;
                        _1208 = _1440;
                        _1209 = _1439;
                        __loop_jump_target = 1203;
                        break;
                      } else {
                        _1448 = _1435;
                        _1449 = _1441;
                        _1450 = _1440;
                        _1451 = _1439;
                        _1452 = _1428;
                        _1454 = _1448;
                        _1455 = _1449;
                        _1456 = _1450;
                        _1457 = _1451;
                        _1458 = _1452;
                        _1459 = -10000.0f;
                      }
                    } else {
                      _1454 = _1206;
                      _1455 = _1207;
                      _1456 = _1208;
                      _1457 = _1209;
                      _1458 = _1308;
                      _1459 = float((int)(_1211));
                    }
                  }
                }
                if (__defer_1210_1253) {
                  if ((int)(_1211 + 1) < (int)8) {
                    _1211 = (_1211 + 1);
                    continue;
                  } else {
                    _1454 = _1206;
                    _1455 = _1207;
                    _1456 = _1208;
                    _1457 = _1209;
                    _1458 = _1205;
                    _1459 = -10000.0f;
                  }
                }
                break;
              }
              if (__loop_jump_target == 1203) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
              break;
            }
          } else {
            _1454 = 0.0f;
            _1455 = _1179;
            _1456 = _1178;
            _1457 = _1177;
            _1458 = 0.0f;
            _1459 = -10000.0f;
          }
          int _1460 = int(_1459);
          if ((uint)_1460 < (uint)8) {
            float _1463 = _voxelParams.x * 0.5f;
            float _1467 = _1457 - (_1463 * _206);
            float _1468 = _1456 - (_1463 * _207);
            float _1469 = _1455 - (_1463 * _208);
            if ((int)_1460 < (int)6) {
              _1476 = 0;
              while(true) {
                int _1516 = int(floor(((_wrappedViewPos.x + _1467) * ((_clipmapOffsets[_1476]).w)) + ((_clipmapRelativeIndexOffsets[_1476]).x)));
                int _1517 = int(floor(((_wrappedViewPos.y + _1468) * ((_clipmapOffsets[_1476]).w)) + ((_clipmapRelativeIndexOffsets[_1476]).y)));
                int _1518 = int(floor(((_wrappedViewPos.z + _1469) * ((_clipmapOffsets[_1476]).w)) + ((_clipmapRelativeIndexOffsets[_1476]).z)));
                if ((((((((int)_1516 >= (int)int(((_clipmapOffsets[_1476]).x) + -63.0f))) && (((int)_1516 < (int)int(((_clipmapOffsets[_1476]).x) + 63.0f))))) && (((((int)_1517 >= (int)int(((_clipmapOffsets[_1476]).y) + -31.0f))) && (((int)_1517 < (int)int(((_clipmapOffsets[_1476]).y) + 31.0f))))))) && (((((int)_1518 >= (int)int(((_clipmapOffsets[_1476]).z) + -63.0f))) && (((int)_1518 < (int)int(((_clipmapOffsets[_1476]).z) + 63.0f)))))) {
                  _1539 = (_1516 & 127);
                  _1540 = (_1517 & 63);
                  _1541 = (_1518 & 127);
                  _1542 = _1476;
                } else {
                  if ((uint)(_1476 + 1) < (uint)8) {
                    _1476 = (_1476 + 1);
                    continue;
                  } else {
                    _1539 = -10000;
                    _1540 = -10000;
                    _1541 = -10000;
                    _1542 = -10000;
                  }
                }
                if (!((uint)_1542 > (uint)5)) {
                  uint _1552 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1539, _1540, ((int)(((uint)(((int)(_1542 * 130)) | 1)) + (uint)(_1541))), 0));
                  bool _1555 = ((_1552.x & 4194303) == 0);
                  [branch]
                  if (!_1555) {
                    _1558 = _1539;
                    _1559 = _1540;
                    _1560 = _1541;
                    _1561 = _1542;
                  } else {
                    _1558 = -10000;
                    _1559 = -10000;
                    _1560 = -10000;
                    _1561 = -10000;
                  }
                  float _1562 = _1463 * float((int)((int)(1u << (_1542 & 31))));
                  _1567 = 0;
                  while(true) {
                    int _1607 = int(floor((((_1467 - _1562) + _wrappedViewPos.x) * ((_clipmapOffsets[_1567]).w)) + ((_clipmapRelativeIndexOffsets[_1567]).x)));
                    int _1608 = int(floor((((_1468 - _1562) + _wrappedViewPos.y) * ((_clipmapOffsets[_1567]).w)) + ((_clipmapRelativeIndexOffsets[_1567]).y)));
                    int _1609 = int(floor((((_1469 - _1562) + _wrappedViewPos.z) * ((_clipmapOffsets[_1567]).w)) + ((_clipmapRelativeIndexOffsets[_1567]).z)));
                    if ((((((((int)_1607 >= (int)int(((_clipmapOffsets[_1567]).x) + -63.0f))) && (((int)_1607 < (int)int(((_clipmapOffsets[_1567]).x) + 63.0f))))) && (((((int)_1608 >= (int)int(((_clipmapOffsets[_1567]).y) + -31.0f))) && (((int)_1608 < (int)int(((_clipmapOffsets[_1567]).y) + 31.0f))))))) && (((((int)_1609 >= (int)int(((_clipmapOffsets[_1567]).z) + -63.0f))) && (((int)_1609 < (int)int(((_clipmapOffsets[_1567]).z) + 63.0f)))))) {
                      _1630 = (_1607 & 127);
                      _1631 = (_1608 & 63);
                      _1632 = (_1609 & 127);
                      _1633 = _1567;
                    } else {
                      if ((uint)(_1567 + 1) < (uint)8) {
                        _1567 = (_1567 + 1);
                        continue;
                      } else {
                        _1630 = -10000;
                        _1631 = -10000;
                        _1632 = -10000;
                        _1633 = -10000;
                      }
                    }
                    if (!((uint)_1633 > (uint)5)) {
                      if (_1555) {
                        _1638 = 0;
                        _1639 = _1561;
                        _1640 = _1560;
                        _1641 = _1559;
                        _1642 = _1558;
                        while(true) {
                          _1651 = 0;
                          _1652 = _1639;
                          _1653 = _1640;
                          _1654 = _1641;
                          _1655 = _1642;
                          while(true) {
                            if (!((((uint)(_1651 + _1631) > (uint)63)) || (((uint)(_1630 | (_1638 + _1632)) > (uint)127)))) {
                              uint _1673 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1630, (_1651 + _1631), ((int)(((uint)(_1638 + _1632)) + ((uint)(((int)(_1633 * 130)) | 1)))), 0));
                              int _1675 = _1673.x & 4194303;
                              _1678 = (_1675 != 0);
                              _1679 = _1675;
                              _1680 = _1633;
                              _1681 = (_1638 + _1632);
                              _1682 = (_1651 + _1631);
                              _1683 = _1630;
                            } else {
                              _1678 = false;
                              _1679 = 0;
                              _1680 = 0;
                              _1681 = 0;
                              _1682 = 0;
                              _1683 = 0;
                            }
                            if (!_1678) {
                              if (!((((uint)(_1651 + _1631) > (uint)63)) || (((uint)((_1630 + 1) | (_1638 + _1632)) > (uint)127)))) {
                                uint _5770 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((_1630 + 1), (_1651 + _1631), ((int)(((uint)(_1638 + _1632)) + ((uint)(((int)(_1633 * 130)) | 1)))), 0));
                                int _5772 = _5770.x & 4194303;
                                _5775 = (_5772 != 0);
                                _5776 = _5772;
                                _5777 = _1633;
                                _5778 = (_1638 + _1632);
                                _5779 = (_1651 + _1631);
                                _5780 = (_1630 + 1);
                              } else {
                                _5775 = false;
                                _5776 = 0;
                                _5777 = 0;
                                _5778 = 0;
                                _5779 = 0;
                                _5780 = 0;
                              }
                              if (!_5775) {
                                _1692 = _1655;
                                _1693 = _1654;
                                _1694 = _1653;
                                _1695 = _1652;
                                _1696 = 0;
                              } else {
                                _1692 = _5780;
                                _1693 = _5779;
                                _1694 = _5778;
                                _1695 = _5777;
                                _1696 = _5776;
                              }
                            } else {
                              _1692 = _1683;
                              _1693 = _1682;
                              _1694 = _1681;
                              _1695 = _1680;
                              _1696 = _1679;
                            }
                            if ((((int)(_1651 + 1) < (int)2)) && ((_1696 == 0))) {
                              _1651 = (_1651 + 1);
                              _1652 = _1695;
                              _1653 = _1694;
                              _1654 = _1693;
                              _1655 = _1692;
                              continue;
                            }
                            if ((((int)(_1638 + 1) < (int)2)) && ((_1696 == 0))) {
                              _1638 = (_1638 + 1);
                              _1639 = _1695;
                              _1640 = _1694;
                              _1641 = _1693;
                              _1642 = _1692;
                              __loop_jump_target = 1637;
                              break;
                            }
                            _1645 = _1695;
                            _1646 = _1694;
                            _1647 = _1693;
                            _1648 = _1692;
                            break;
                          }
                          if (__loop_jump_target == 1637) {
                            __loop_jump_target = -1;
                            continue;
                          }
                          if (__loop_jump_target != -1) {
                            break;
                          }
                          break;
                        }
                      } else {
                        _1645 = _1561;
                        _1646 = _1560;
                        _1647 = _1559;
                        _1648 = _1558;
                      }
                      if ((uint)_1645 < (uint)6) {
                        uint _1702 = _1645 * 130;
                        uint _1706 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1648, _1647, ((int)(((uint)((int)(_1702) | 1)) + (uint)(_1646))), 0));
                        int _1708 = _1706.x & 4194303;
                        [branch]
                        if (!(_1708 == 0)) {
                          float _1714 = float((int)((int)(1u << (_1645 & 31)))) * _voxelParams.x;
                          float _1751 = -0.0f - _206;
                          float _1752 = -0.0f - _207;
                          float _1753 = -0.0f - _208;
                          _1755 = 0.0f;
                          _1756 = 0.0f;
                          _1757 = 0.0f;
                          _1758 = 0.0f;
                          _1759 = 0;
                          while(true) {
                            int _1764 = __3__37__0__0__g_surfelDataBuffer[((_1708 + -1) + _1759)]._baseColor;
                            int _1766 = __3__37__0__0__g_surfelDataBuffer[((_1708 + -1) + _1759)]._normal;
                            int16_t _1769 = __3__37__0__0__g_surfelDataBuffer[((_1708 + -1) + _1759)]._radius;
                            if (!(_1764 == 0)) {
                              half _1772 = __3__37__0__0__g_surfelDataBuffer[((_1708 + -1) + _1759)]._radiance.z;
                              half _1773 = __3__37__0__0__g_surfelDataBuffer[((_1708 + -1) + _1759)]._radiance.y;
                              half _1774 = __3__37__0__0__g_surfelDataBuffer[((_1708 + -1) + _1759)]._radiance.x;
                              float _1780 = float((uint)((uint)(_1764 & 255)));
                              float _1781 = float((uint)((uint)(((uint)((uint)(_1764)) >> 8) & 255)));
                              float _1782 = float((uint)((uint)(((uint)((uint)(_1764)) >> 16) & 255)));
                              float _1807 = select(((_1780 * 0.003921568859368563f) < 0.040449999272823334f), (_1780 * 0.0003035269910469651f), exp2(log2((_1780 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1808 = select(((_1781 * 0.003921568859368563f) < 0.040449999272823334f), (_1781 * 0.0003035269910469651f), exp2(log2((_1781 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1809 = select(((_1782 * 0.003921568859368563f) < 0.040449999272823334f), (_1782 * 0.0003035269910469651f), exp2(log2((_1782 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1821 = (float((uint)((uint)(_1766 & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1822 = (float((uint)((uint)(((uint)((uint)(_1766)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1823 = (float((uint)((uint)(((uint)((uint)(_1766)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1825 = rsqrt(dot(float3(_1821, _1822, _1823), float3(_1821, _1822, _1823)));
                              bool _1830 = ((_1766 & 16777215) == 0);
                              float _1834 = float(_1774);
                              float _1835 = float(_1773);
                              float _1836 = float(_1772);
                              float _1840 = (_1714 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_1769) & 255)));
                              float _1856 = (((float((uint)((uint)((uint)((uint)(_1764)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1714) + ((((((_clipmapOffsets[_1645]).x) + -63.5f) + float((int)(((int)(((uint)(_1648) + 64u) - (uint)(int((_clipmapOffsets[_1645]).x)))) & 127))) * _1714) - _viewPos.x);
                              float _1857 = (((float((uint)((uint)((uint)((uint)(_1766)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1714) + ((((((_clipmapOffsets[_1645]).y) + -31.5f) + float((int)(((int)(((uint)(_1647) + 32u) - (uint)(int((_clipmapOffsets[_1645]).y)))) & 63))) * _1714) - _viewPos.y);
                              float _1858 = (((float((uint16_t)((uint)((uint16_t)((uint)(_1769)) >> 8))) * 0.003937007859349251f) + -0.5f) * _1714) + ((((((_clipmapOffsets[_1645]).z) + -63.5f) + float((int)(((int)(((uint)(_1646) + 64u) - (uint)(int((_clipmapOffsets[_1645]).z)))) & 127))) * _1714) - _viewPos.z);
                              float _1878 = ((-0.0f - _1101) - (_1454 * _206)) + _1856;
                              float _1881 = ((-0.0f - _1102) - (_1454 * _207)) + _1857;
                              float _1884 = ((-0.0f - _1103) - (_1454 * _208)) + _1858;
                              float _1885 = dot(float3(_1878, _1881, _1884), float3(_1751, _1752, _1753));
                              float _1889 = _1878 - (_1885 * _1751);
                              float _1890 = _1881 - (_1885 * _1752);
                              float _1891 = _1884 - (_1885 * _1753);
                              float _1917 = 1.0f / float((uint)(1u << (_1645 & 31)));
                              float _1921 = frac(((_invClipmapExtent.z * _1858) + _clipmapUVRelativeOffset.z) * _1917);
                              float _1932 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _1856) + _clipmapUVRelativeOffset.x) * _1917), (((_invClipmapExtent.y * _1857) + _clipmapUVRelativeOffset.y) * _1917), (((float((uint)_1702) + 1.0f) + ((select((_1921 < 0.0f), 1.0f, 0.0f) + _1921) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                              float _1946 = select(((int)_1645 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_1751, _1752, _1753), float3(select(_1830, _1751, (_1825 * _1821)), select(_1830, _1752, (_1825 * _1822)), select(_1830, _1753, (_1825 * _1823))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_1889, _1890, _1891), float3(_1889, _1890, _1891)) < ((_1840 * _1840) * 16.0f)))) * float((bool)(uint)(_1932.x > ((_1714 * 0.25f) * (saturate((dot(float3(_1834, _1835, _1836), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                              float _1953 = (((((_1808 * 0.3395099937915802f) + (_1807 * 0.6131200194358826f)) + (_1809 * 0.047370001673698425f)) * _1834) * _1946) + _1755;
                              float _1954 = (((((_1808 * 0.9163600206375122f) + (_1807 * 0.07020000368356705f)) + (_1809 * 0.013450000435113907f)) * _1835) * _1946) + _1756;
                              float _1955 = (((((_1808 * 0.10958000272512436f) + (_1807 * 0.02061999961733818f)) + (_1809 * 0.8697999715805054f)) * _1836) * _1946) + _1757;
                              float _1956 = _1946 + _1758;
                              if ((uint)(_1759 + 1) < (uint)renodx::math::Select(RT_QUALITY >= 1.f, 8.f, 4.f)) {
                                _1755 = _1953;
                                _1756 = _1954;
                                _1757 = _1955;
                                _1758 = _1956;
                                _1759 = (_1759 + 1);
                                continue;
                              } else {
                                _1960 = _1953;
                                _1961 = _1954;
                                _1962 = _1955;
                                _1963 = _1956;
                              }
                            } else {
                              _1960 = _1755;
                              _1961 = _1756;
                              _1962 = _1757;
                              _1963 = _1758;
                            }
                            if (_1963 > 0.0f) {
                              float _1966 = 1.0f / _1963;
                              _1980 = 1.0f;
                              _1981 = (-0.0f - min(0.0f, (-0.0f - (_1960 * _1966))));
                              _1982 = (-0.0f - min(0.0f, (-0.0f - (_1961 * _1966))));
                              _1983 = (-0.0f - min(0.0f, (-0.0f - (_1962 * _1966))));
                            } else {
                              _1980 = 0.0f;
                              _1981 = _1960;
                              _1982 = _1961;
                              _1983 = _1962;
                            }
                            break;
                          }
                        } else {
                          _1980 = 0.0f;
                          _1981 = 0.0f;
                          _1982 = 0.0f;
                          _1983 = 0.0f;
                        }
                      } else {
                        _1980 = 0.0f;
                        _1981 = 0.0f;
                        _1982 = 0.0f;
                        _1983 = 0.0f;
                      }
                    } else {
                      _1980 = 1.0f;
                      _1981 = 0.0f;
                      _1982 = 0.0f;
                      _1983 = 0.0f;
                    }
                    break;
                  }
                } else {
                  _1980 = 1.0f;
                  _1981 = 0.0f;
                  _1982 = 0.0f;
                  _1983 = 0.0f;
                }
                break;
              }
            } else {
              _1980 = 1.0f;
              _1981 = 0.0f;
              _1982 = 0.0f;
              _1983 = 0.0f;
            }
            float _1991 = saturate((_1454 * 0.25f) / (float((int)((int)(1u << (_1167 & 31)))) * _voxelParams.x)) * _1980;
            float _2001 = -0.0f - min(0.0f, (-0.0f - (_1981 * _1991)));
            float _2002 = -0.0f - min(0.0f, (-0.0f - (_1982 * _1991)));
            float _2003 = -0.0f - min(0.0f, (-0.0f - (_1983 * _1991)));
            float _2005 = select(((int)_1460 > (int)-1), 1.0f, 0.0f);
            float _2006 = max(9.999999974752427e-07f, _1454);
            if (_2006 > 0.0f) {
              _2011 = (_2006 + _1100);
              _2012 = _2001;
              _2013 = _2002;
              _2014 = _2003;
              _2015 = _2005;
            } else {
              _2011 = _2006;
              _2012 = _2001;
              _2013 = _2002;
              _2014 = _2003;
              _2015 = _2005;
            }
          } else {
            _2011 = 0.0f;
            _2012 = 0.0f;
            _2013 = 0.0f;
            _2014 = 0.0f;
            _2015 = _1458;
          }
        } else {
          _2011 = 0.0f;
          _2012 = 0.0f;
          _2013 = 0.0f;
          _2014 = 0.0f;
          _2015 = 0.0f;
        }
        break;
      }
    } else {
      _2011 = _755;
      _2012 = _751;
      _2013 = _752;
      _2014 = _753;
      _2015 = _754;
    }
    float _2018 = saturate(5.000000476837158f - (_170 * 0.01953125186264515f));
    bool _2019 = (_969 != 0);
    if (((_968 > 0.0f)) && ((((_960 > 0.0f)) && (_2019)))) {
      if (!(_960 < _2011)) {
        _2029 = (_2011 <= 0.0f);
      } else {
        _2029 = true;
      }
    } else {
      _2029 = false;
    }
    float _2033 = saturate(max(select(_2029, 1.0f, 0.0f), (1.0f - _2018)));
    float _2034 = _2033 * _968;
    float _2037 = min(_2018, saturate(1.0f - _2034));
    if (!(_2015 == 0.0f)) {
      _2052 = ((_2037 * _2012) + (_2033 * _965));
      _2053 = ((_2037 * _2013) + (_2033 * _966));
      _2054 = ((_2037 * _2014) + (_2033 * _967));
      _2055 = ((_2037 * _2015) + _2034);
    } else {
      _2052 = _965;
      _2053 = _966;
      _2054 = _967;
      _2055 = _968;
    }
    float _2058 = 1.0f / max(9.999999974752427e-07f, (_2037 + _2033));
    float _2062 = _2058 * ((_2037 * _2011) + (_2033 * _960));
    float _2064 = _2058 * _2033;
    float _2068 = (_2062 * _206) + _165;
    float _2069 = (_2062 * _207) + _166;
    float _2070 = (_2062 * _208) + _167;
    [branch]
    if (!(_2062 <= 0.0f)) {
      float _2100 = mad((_viewProjRelative[3].z), _2070, mad((_viewProjRelative[3].y), _2069, ((_viewProjRelative[3].x) * _2068))) + (_viewProjRelative[3].w);
      float _2105 = (((mad((_viewProjRelative[0].z), _2070, mad((_viewProjRelative[0].y), _2069, ((_viewProjRelative[0].x) * _2068))) + (_viewProjRelative[0].w)) / _2100) * 0.5f) + 0.5f;
      float _2106 = 0.5f - (((mad((_viewProjRelative[1].z), _2070, mad((_viewProjRelative[1].y), _2069, ((_viewProjRelative[1].x) * _2068))) + (_viewProjRelative[1].w)) / _2100) * 0.5f);
      if (((((_2105 >= 0.0f)) && ((_2105 <= 1.0f)))) && ((((_2106 >= 0.0f)) && ((_2106 <= 1.0f))))) {
        if ((_2019) && ((((mad((_viewProjRelative[2].z), _2070, mad((_viewProjRelative[2].y), _2069, ((_viewProjRelative[2].x) * _2068))) + (_viewProjRelative[2].w)) / _2100) > 0.0f))) {
          half4 _2129 = __3__36__0__0__g_sceneShadowColor.SampleLevel(__3__40__0__0__g_sampler, float2(_2105, _2106), 0.0f);
          _2137 = float(_2129.x);
          _2138 = float(_2129.y);
          _2139 = float(_2129.z);
        } else {
          _2137 = 1.0f;
          _2138 = 1.0f;
          _2139 = 1.0f;
        }
      } else {
        _2137 = 1.0f;
        _2138 = 1.0f;
        _2139 = 1.0f;
      }
      float _2146 = _viewPos.x + _2068;
      float _2147 = _viewPos.y + _2069;
      float _2148 = _viewPos.z + _2070;
      float _2153 = _2146 - (_staticShadowPosition[1].x);
      float _2154 = _2147 - (_staticShadowPosition[1].y);
      float _2155 = _2148 - (_staticShadowPosition[1].z);
      float _2175 = mad((_shadowProjRelativeTexScale[1][0].z), _2155, mad((_shadowProjRelativeTexScale[1][0].y), _2154, ((_shadowProjRelativeTexScale[1][0].x) * _2153))) + (_shadowProjRelativeTexScale[1][0].w);
      float _2179 = mad((_shadowProjRelativeTexScale[1][1].z), _2155, mad((_shadowProjRelativeTexScale[1][1].y), _2154, ((_shadowProjRelativeTexScale[1][1].x) * _2153))) + (_shadowProjRelativeTexScale[1][1].w);
      float _2186 = 2.0f / _shadowSizeAndInvSize.y;
      float _2187 = 1.0f - _2186;
      bool _2194 = ((((((!(_2175 <= _2187))) || ((!(_2175 >= _2186))))) || ((!(_2179 <= _2187))))) || ((!(_2179 >= _2186)));
      float _2203 = _2146 - (_staticShadowPosition[0].x);
      float _2204 = _2147 - (_staticShadowPosition[0].y);
      float _2205 = _2148 - (_staticShadowPosition[0].z);
      float _2225 = mad((_shadowProjRelativeTexScale[0][0].z), _2205, mad((_shadowProjRelativeTexScale[0][0].y), _2204, ((_shadowProjRelativeTexScale[0][0].x) * _2203))) + (_shadowProjRelativeTexScale[0][0].w);
      float _2229 = mad((_shadowProjRelativeTexScale[0][1].z), _2205, mad((_shadowProjRelativeTexScale[0][1].y), _2204, ((_shadowProjRelativeTexScale[0][1].x) * _2203))) + (_shadowProjRelativeTexScale[0][1].w);
      bool _2240 = ((((((!(_2225 <= _2187))) || ((!(_2225 >= _2186))))) || ((!(_2229 <= _2187))))) || ((!(_2229 >= _2186)));
      float _2241 = select(_2240, select(_2194, 0.0f, _2175), _2225);
      float _2242 = select(_2240, select(_2194, 0.0f, _2179), _2229);
      float _2243 = select(_2240, select(_2194, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _2155, mad((_shadowProjRelativeTexScale[1][2].y), _2154, ((_shadowProjRelativeTexScale[1][2].x) * _2153))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _2205, mad((_shadowProjRelativeTexScale[0][2].y), _2204, ((_shadowProjRelativeTexScale[0][2].x) * _2203))) + (_shadowProjRelativeTexScale[0][2].w)));
      int _2244 = select(_2240, select(_2194, -1, 1), 0);
      [branch]
      if (!(_2244 == -1)) {
        float _2250 = (_2241 * _shadowSizeAndInvSize.x) + -0.5f;
        float _2251 = (_2242 * _shadowSizeAndInvSize.y) + -0.5f;
        int _2254 = int(floor(_2250));
        int _2255 = int(floor(_2251));
        if (!((((uint)_2254 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_2255 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
          float4 _2265 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2254, _2255, _2244, 0));
          float4 _2267 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2254) + 1u)), _2255, _2244, 0));
          float4 _2269 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2254, ((int)((uint)(_2255) + 1u)), _2244, 0));
          float4 _2271 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2254) + 1u)), ((int)((uint)(_2255) + 1u)), _2244, 0));
          half4 _2276 = __3__36__0__0__g_shadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2241, _2242, float((uint)(uint)(_2244))), 0.0f);
          _2282 = _2265.x;
          _2283 = _2267.x;
          _2284 = _2269.x;
          _2285 = _2271.x;
          _2286 = _2276.x;
          _2287 = _2276.y;
          _2288 = _2276.z;
          _2289 = _2276.w;
        } else {
          _2282 = 0.0f;
          _2283 = 0.0f;
          _2284 = 0.0f;
          _2285 = 0.0f;
          _2286 = 1.0h;
          _2287 = 1.0h;
          _2288 = 1.0h;
          _2289 = 1.0h;
        }
        float _2315 = (float4(_invShadowViewProj[_2244][0][0], _invShadowViewProj[_2244][1][0], _invShadowViewProj[_2244][2][0], _invShadowViewProj[_2244][3][0]).x) * _2241;
        float _2319 = (float4(_invShadowViewProj[_2244][0][0], _invShadowViewProj[_2244][1][0], _invShadowViewProj[_2244][2][0], _invShadowViewProj[_2244][3][0]).y) * _2241;
        float _2323 = (float4(_invShadowViewProj[_2244][0][0], _invShadowViewProj[_2244][1][0], _invShadowViewProj[_2244][2][0], _invShadowViewProj[_2244][3][0]).z) * _2241;
        float _2327 = (float4(_invShadowViewProj[_2244][0][0], _invShadowViewProj[_2244][1][0], _invShadowViewProj[_2244][2][0], _invShadowViewProj[_2244][3][0]).w) * _2241;
        float _2330 = mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).w), _2282, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).w), _2242, _2327)) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).w);
        float _2331 = (mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).x), _2282, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).x), _2242, _2315)) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).x)) / _2330;
        float _2332 = (mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).y), _2282, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).y), _2242, _2319)) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).y)) / _2330;
        float _2333 = (mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).z), _2282, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).z), _2242, _2323)) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).z)) / _2330;
        float _2336 = _2241 + (_shadowSizeAndInvSize.z * 4.0f);
        float _2352 = mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).w), _2283, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).w), _2242, ((float4(_invShadowViewProj[_2244][0][0], _invShadowViewProj[_2244][1][0], _invShadowViewProj[_2244][2][0], _invShadowViewProj[_2244][3][0]).w) * _2336))) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).w);
        float _2358 = _2242 - (_shadowSizeAndInvSize.w * 2.0f);
        float _2370 = mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).w), _2284, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).w), _2358, _2327)) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).w);
        float _2374 = ((mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).x), _2284, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).x), _2358, _2315)) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).x)) / _2370) - _2331;
        float _2375 = ((mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).y), _2284, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).y), _2358, _2319)) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).y)) / _2370) - _2332;
        float _2376 = ((mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).z), _2284, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).z), _2358, _2323)) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).z)) / _2370) - _2333;
        float _2377 = ((mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).x), _2283, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).x), _2242, ((float4(_invShadowViewProj[_2244][0][0], _invShadowViewProj[_2244][1][0], _invShadowViewProj[_2244][2][0], _invShadowViewProj[_2244][3][0]).x) * _2336))) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).x)) / _2352) - _2331;
        float _2378 = ((mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).y), _2283, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).y), _2242, ((float4(_invShadowViewProj[_2244][0][0], _invShadowViewProj[_2244][1][0], _invShadowViewProj[_2244][2][0], _invShadowViewProj[_2244][3][0]).y) * _2336))) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).y)) / _2352) - _2332;
        float _2379 = ((mad((float4(_invShadowViewProj[_2244][0][2], _invShadowViewProj[_2244][1][2], _invShadowViewProj[_2244][2][2], _invShadowViewProj[_2244][3][2]).z), _2283, mad((float4(_invShadowViewProj[_2244][0][1], _invShadowViewProj[_2244][1][1], _invShadowViewProj[_2244][2][1], _invShadowViewProj[_2244][3][1]).z), _2242, ((float4(_invShadowViewProj[_2244][0][0], _invShadowViewProj[_2244][1][0], _invShadowViewProj[_2244][2][0], _invShadowViewProj[_2244][3][0]).z) * _2336))) + (float4(_invShadowViewProj[_2244][0][3], _invShadowViewProj[_2244][1][3], _invShadowViewProj[_2244][2][3], _invShadowViewProj[_2244][3][3]).z)) / _2352) - _2333;
        float _2382 = (_2376 * _2378) - (_2375 * _2379);
        float _2385 = (_2374 * _2379) - (_2376 * _2377);
        float _2388 = (_2375 * _2377) - (_2374 * _2378);
        float _2390 = rsqrt(dot(float3(_2382, _2385, _2388), float3(_2382, _2385, _2388)));
        float _2391 = _2382 * _2390;
        float _2392 = _2385 * _2390;
        float _2393 = _2388 * _2390;
        float _2394 = frac(_2250);
        float _2399 = (saturate(dot(float3(_206, _207, _208), float3(_2391, _2392, _2393))) * 0.0020000000949949026f) + _2243;
        float _2412 = saturate(exp2((_2282 - _2399) * 1442695.0f));
        float _2414 = saturate(exp2((_2284 - _2399) * 1442695.0f));
        float _2420 = ((saturate(exp2((_2283 - _2399) * 1442695.0f)) - _2412) * _2394) + _2412;
        _2427 = _2391;
        _2428 = _2392;
        _2429 = _2393;
        _2430 = saturate((((_2414 - _2420) + ((saturate(exp2((_2285 - _2399) * 1442695.0f)) - _2414) * _2394)) * frac(_2251)) + _2420);
        _2431 = _2282;
        _2432 = _2283;
        _2433 = _2284;
        _2434 = _2285;
        _2435 = _2286;
        _2436 = _2287;
        _2437 = _2288;
        _2438 = _2289;
      } else {
        _2427 = 0.0f;
        _2428 = 0.0f;
        _2429 = 0.0f;
        _2430 = 0.0f;
        _2431 = 0.0f;
        _2432 = 0.0f;
        _2433 = 0.0f;
        _2434 = 0.0f;
        _2435 = 0.0h;
        _2436 = 0.0h;
        _2437 = 0.0h;
        _2438 = 0.0h;
      }
      float _2458 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _2070, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _2069, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _2068))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
      float _2462 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _2070, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _2069, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _2068))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
      float _2466 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _2070, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _2069, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _2068))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
      float _2469 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
      float _2470 = 1.0f - _2469;
      if (!(((((!(_2458 <= _2470))) || ((!(_2458 >= _2469))))) || ((!(_2462 <= _2470))))) {
        bool _2481 = ((_2466 >= -1.0f)) && ((((_2466 <= 1.0f)) && ((_2462 >= _2469))));
        _2489 = select(_2481, 9.999999747378752e-06f, -9.999999747378752e-05f);
        _2490 = select(_2481, _2458, _2241);
        _2491 = select(_2481, _2462, _2242);
        _2492 = select(_2481, _2466, _2243);
        _2493 = select(_2481, 1, _2244);
        _2494 = ((int)(uint)((int)(_2481)));
      } else {
        _2489 = -9.999999747378752e-05f;
        _2490 = _2241;
        _2491 = _2242;
        _2492 = _2243;
        _2493 = _2244;
        _2494 = 0;
      }
      float _2514 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _2070, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _2069, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _2068))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
      float _2518 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _2070, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _2069, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _2068))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
      float _2522 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _2070, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _2069, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _2068))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
      if (!(((((!(_2514 <= _2470))) || ((!(_2514 >= _2469))))) || ((!(_2518 <= _2470))))) {
        bool _2533 = ((_2522 >= -1.0f)) && ((((_2518 >= _2469)) && ((_2522 <= 1.0f))));
        _2541 = select(_2533, 9.999999747378752e-06f, _2489);
        _2542 = select(_2533, _2514, _2490);
        _2543 = select(_2533, _2518, _2491);
        _2544 = select(_2533, _2522, _2492);
        _2545 = select(_2533, 0, _2493);
        _2546 = select(_2533, 1, _2494);
      } else {
        _2541 = _2489;
        _2542 = _2490;
        _2543 = _2491;
        _2544 = _2492;
        _2545 = _2493;
        _2546 = _2494;
      }
      [branch]
      if (!(_2546 == 0)) {
        int _2556 = int(floor((_2542 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
        int _2557 = int(floor((_2543 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
        if (!((((uint)_2556 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_2557 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
          float4 _2567 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2556, _2557, _2545, 0));
          float4 _2569 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2556) + 1u)), _2557, _2545, 0));
          float4 _2571 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2556, ((int)((uint)(_2557) + 1u)), _2545, 0));
          float4 _2573 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2556) + 1u)), ((int)((uint)(_2557) + 1u)), _2545, 0));
          _2576 = _2567.x;
          _2577 = _2569.x;
          _2578 = _2571.x;
          _2579 = _2573.x;
        } else {
          _2576 = _2431;
          _2577 = _2432;
          _2578 = _2433;
          _2579 = _2434;
        }
        float _2605 = (float4(_invDynamicShadowViewProj[_2545][0][0], _invDynamicShadowViewProj[_2545][1][0], _invDynamicShadowViewProj[_2545][2][0], _invDynamicShadowViewProj[_2545][3][0]).x) * _2542;
        float _2609 = (float4(_invDynamicShadowViewProj[_2545][0][0], _invDynamicShadowViewProj[_2545][1][0], _invDynamicShadowViewProj[_2545][2][0], _invDynamicShadowViewProj[_2545][3][0]).y) * _2542;
        float _2613 = (float4(_invDynamicShadowViewProj[_2545][0][0], _invDynamicShadowViewProj[_2545][1][0], _invDynamicShadowViewProj[_2545][2][0], _invDynamicShadowViewProj[_2545][3][0]).z) * _2542;
        float _2617 = (float4(_invDynamicShadowViewProj[_2545][0][0], _invDynamicShadowViewProj[_2545][1][0], _invDynamicShadowViewProj[_2545][2][0], _invDynamicShadowViewProj[_2545][3][0]).w) * _2542;
        float _2620 = mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).w), _2576, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).w), _2543, _2617)) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).w);
        float _2621 = (mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).x), _2576, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).x), _2543, _2605)) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).x)) / _2620;
        float _2622 = (mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).y), _2576, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).y), _2543, _2609)) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).y)) / _2620;
        float _2623 = (mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).z), _2576, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).z), _2543, _2613)) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).z)) / _2620;
        float _2626 = _2542 + (_dynmaicShadowSizeAndInvSize.z * 8.0f);
        float _2642 = mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).w), _2577, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).w), _2543, ((float4(_invDynamicShadowViewProj[_2545][0][0], _invDynamicShadowViewProj[_2545][1][0], _invDynamicShadowViewProj[_2545][2][0], _invDynamicShadowViewProj[_2545][3][0]).w) * _2626))) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).w);
        float _2648 = _2543 - (_dynmaicShadowSizeAndInvSize.w * 4.0f);
        float _2660 = mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).w), _2578, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).w), _2648, _2617)) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).w);
        float _2664 = ((mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).x), _2578, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).x), _2648, _2605)) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).x)) / _2660) - _2621;
        float _2665 = ((mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).y), _2578, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).y), _2648, _2609)) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).y)) / _2660) - _2622;
        float _2666 = ((mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).z), _2578, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).z), _2648, _2613)) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).z)) / _2660) - _2623;
        float _2667 = ((mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).x), _2577, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).x), _2543, ((float4(_invDynamicShadowViewProj[_2545][0][0], _invDynamicShadowViewProj[_2545][1][0], _invDynamicShadowViewProj[_2545][2][0], _invDynamicShadowViewProj[_2545][3][0]).x) * _2626))) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).x)) / _2642) - _2621;
        float _2668 = ((mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).y), _2577, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).y), _2543, ((float4(_invDynamicShadowViewProj[_2545][0][0], _invDynamicShadowViewProj[_2545][1][0], _invDynamicShadowViewProj[_2545][2][0], _invDynamicShadowViewProj[_2545][3][0]).y) * _2626))) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).y)) / _2642) - _2622;
        float _2669 = ((mad((float4(_invDynamicShadowViewProj[_2545][0][2], _invDynamicShadowViewProj[_2545][1][2], _invDynamicShadowViewProj[_2545][2][2], _invDynamicShadowViewProj[_2545][3][2]).z), _2577, mad((float4(_invDynamicShadowViewProj[_2545][0][1], _invDynamicShadowViewProj[_2545][1][1], _invDynamicShadowViewProj[_2545][2][1], _invDynamicShadowViewProj[_2545][3][1]).z), _2543, ((float4(_invDynamicShadowViewProj[_2545][0][0], _invDynamicShadowViewProj[_2545][1][0], _invDynamicShadowViewProj[_2545][2][0], _invDynamicShadowViewProj[_2545][3][0]).z) * _2626))) + (float4(_invDynamicShadowViewProj[_2545][0][3], _invDynamicShadowViewProj[_2545][1][3], _invDynamicShadowViewProj[_2545][2][3], _invDynamicShadowViewProj[_2545][3][3]).z)) / _2642) - _2623;
        float _2672 = (_2666 * _2668) - (_2665 * _2669);
        float _2675 = (_2664 * _2669) - (_2666 * _2667);
        float _2678 = (_2665 * _2667) - (_2664 * _2668);
        float _2680 = rsqrt(dot(float3(_2672, _2675, _2678), float3(_2672, _2675, _2678)));
        if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
          _2698 = _sunDirection.x;
          _2699 = _sunDirection.y;
          _2700 = _sunDirection.z;
        } else {
          _2698 = _moonDirection.x;
          _2699 = _moonDirection.y;
          _2700 = _moonDirection.z;
        }
        float _2706 = (_2541 - (saturate(-0.0f - dot(float3(_2698, _2699, _2700), float3(_206, _207, _208))) * 9.999999747378752e-05f)) + _2544;
        _2719 = (_2672 * _2680);
        _2720 = (_2675 * _2680);
        _2721 = (_2678 * _2680);
        _2722 = min(float((bool)(uint)(_2576 > _2706)), min(min(float((bool)(uint)(_2577 > _2706)), float((bool)(uint)(_2578 > _2706))), float((bool)(uint)(_2579 > _2706))));
      } else {
        _2719 = _2427;
        _2720 = _2428;
        _2721 = _2429;
        _2722 = _2430;
      }
      float _2727 = _viewPos.x - _shadowRelativePosition.x;
      float _2728 = _viewPos.y - _shadowRelativePosition.y;
      float _2729 = _viewPos.z - _shadowRelativePosition.z;
      float _2730 = _2727 + _2068;
      float _2731 = _2728 + _2069;
      float _2732 = _2729 + _2070;
      float _2752 = mad((_terrainShadowProjRelativeTexScale[0].z), _2732, mad((_terrainShadowProjRelativeTexScale[0].y), _2731, (_2730 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
      float _2756 = mad((_terrainShadowProjRelativeTexScale[1].z), _2732, mad((_terrainShadowProjRelativeTexScale[1].y), _2731, (_2730 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
      float _2760 = mad((_terrainShadowProjRelativeTexScale[2].z), _2732, mad((_terrainShadowProjRelativeTexScale[2].y), _2731, (_2730 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
      if (saturate(_2752) == _2752) {
        if (((_2760 >= 9.999999747378752e-05f)) && ((((_2760 <= 1.0f)) && ((saturate(_2756) == _2756))))) {
          float _2775 = frac((_2752 * 1024.0f) + -0.5f);
          float4 _2779 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_2752, _2756));
          float _2784 = _2760 + -0.004999999888241291f;
          float _2789 = select((_2779.w > _2784), 1.0f, 0.0f);
          float _2791 = select((_2779.x > _2784), 1.0f, 0.0f);
          float _2798 = ((select((_2779.z > _2784), 1.0f, 0.0f) - _2789) * _2775) + _2789;
          _2804 = saturate((((((select((_2779.y > _2784), 1.0f, 0.0f) - _2791) * _2775) + _2791) - _2798) * frac((_2756 * 1024.0f) + -0.5f)) + _2798);
        } else {
          _2804 = 1.0f;
        }
      } else {
        _2804 = 1.0f;
      }
      float _2805 = min(_2722, _2804);
      half _2806 = saturate(_2435);
      half _2807 = saturate(_2436);
      half _2808 = saturate(_2437);
      half _2822 = ((_2807 * 0.3395996h) + (_2806 * 0.61328125h)) + (_2808 * 0.04736328h);
      half _2823 = ((_2807 * 0.9165039h) + (_2806 * 0.07019043h)) + (_2808 * 0.013450623h);
      half _2824 = ((_2807 * 0.109558105h) + (_2806 * 0.020614624h)) + (_2808 * 0.8696289h);
      bool _2827 = (_sunDirection.y > 0.0f);
      if ((_2827) || ((!(_2827)) && (_sunDirection.y > _moonDirection.y))) {
        _2839 = _sunDirection.x;
        _2840 = _sunDirection.y;
        _2841 = _sunDirection.z;
      } else {
        _2839 = _moonDirection.x;
        _2840 = _moonDirection.y;
        _2841 = _moonDirection.z;
      }
      if ((_2827) || ((!(_2827)) && (_sunDirection.y > _moonDirection.y))) {
        _2861 = _precomputedAmbient7.y;
      } else {
        _2861 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
      }
      float _2864 = _2147 + _earthRadius;
      float _2868 = (_2070 * _2070) + (_2068 * _2068);
      float _2870 = sqrt((_2864 * _2864) + _2868);
      float _2875 = dot(float3((_2068 / _2870), (_2864 / _2870), (_2070 / _2870)), float3(_2839, _2840, _2841));
      float _2878 = _atmosphereThickness + -16.0f;
      float _2880 = min(max(((_2870 - _earthRadius) / _atmosphereThickness), 16.0f), _2878);
      float _2882 = _atmosphereThickness + -32.0f;
      float _2888 = max(_2880, 0.0f);
      float _2889 = _earthRadius * 2.0f;
      float _2895 = (-0.0f - sqrt((_2888 + _2889) * _2888)) / (_2888 + _earthRadius);
      if (_2875 > _2895) {
        _2918 = ((exp2(log2(saturate((_2875 - _2895) / (1.0f - _2895))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _2918 = ((exp2(log2(saturate((_2895 - _2875) / (_2895 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float2 _2923 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_2880 + -16.0f) / _2882)) * 0.5f) * 0.96875f) + 0.015625f), _2918), 0.0f);
      float _2942 = _mieAerosolAbsorption + 1.0f;
      float _2943 = _mieAerosolDensity * 1.9999999494757503e-05f;
      float _2945 = (_2943 * _2923.y) * _2942;
      float _2951 = (float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f);
      float _2954 = (float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f);
      float _2957 = (_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f);
      float _2963 = exp2(((_2951 * _2923.x) + _2945) * -1.4426950216293335f);
      float _2964 = exp2(((_2954 * _2923.x) + _2945) * -1.4426950216293335f);
      float _2965 = exp2(((_2957 * _2923.x) + _2945) * -1.4426950216293335f);
      float _2981 = sqrt(_2868);
      float _2989 = (_cloudAltitude - (max(((_2981 * _2981) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
      float _3001 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_2840 > 0.0f))) - ((int)(uint)((int)(_2840 < 0.0f))))) * 0.5f))) + _2989;
      if (_2069 < _2989) {
        float _3004 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2839, _2840, _2841));
        float _3010 = select((abs(_3004) < 9.99999993922529e-09f), 1e+08f, ((_3001 - dot(float3(0.0f, 1.0f, 0.0f), float3(_2068, _2069, _2070))) / _3004));
        _3016 = ((_3010 * _2839) + _2068);
        _3017 = _3001;
        _3018 = ((_3010 * _2841) + _2070);
      } else {
        _3016 = _2068;
        _3017 = _2069;
        _3018 = _2070;
      }
      float _3027 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3016 * 4.999999873689376e-05f) + 0.5f), ((_3017 - _2989) / _cloudThickness), ((_3018 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
      float _3031 = _cloudScatteringCoefficient / _distanceScale;
      float _3032 = _distanceScale * -1.4426950216293335f;
      float _3038 = saturate(abs(_2840) * 4.0f);
      float _3040 = (_3038 * _3038) * exp2((_3032 * _3027.x) * _3031);
      float _3047 = ((1.0f - _3040) * saturate(((_2069 - _cloudThickness) - _2989) * 0.10000000149011612f)) + _3040;
      float _3048 = _3047 * (((_2964 * 0.3395099937915802f) + (_2963 * 0.6131200194358826f)) + (_2965 * 0.047370001673698425f));
      float _3049 = _3047 * (((_2964 * 0.9163600206375122f) + (_2963 * 0.07020000368356705f)) + (_2965 * 0.013450000435113907f));
      float _3050 = _3047 * (((_2964 * 0.10958000272512436f) + (_2963 * 0.02061999961733818f)) + (_2965 * 0.8697999715805054f));
      float _3069 = float(saturate(_2438));
      if (((_750 != 0)) && ((!_770))) {
        bool _3071 = (_964 > 0.0f);
        float _3072 = select(_3071, _961, _2719);
        float _3073 = select(_3071, _962, _2720);
        float _3074 = select(_3071, _963, _2721);
        float _3075 = select(_3071, _964, 0.800000011920929f);
        if (_749 > 0.0f) {
          half _3078 = half(_746);
          half _3079 = half(_747);
          half _3080 = half(_748);
          _3086 = _3075;
          _3087 = _3072;
          _3088 = _3073;
          _3089 = _3074;
          _3090 = _3078;
          _3091 = _3079;
          _3092 = _3080;
          _3093 = _749;
          _3094 = float(_3078);
          _3095 = float(_3079);
          _3096 = float(_3080);
          _3097 = dot(float3(_3072, _3073, _3074), float3(_2839, _2840, _2841));
        } else {
          _3086 = _3075;
          _3087 = _3072;
          _3088 = _3073;
          _3089 = _3074;
          _3090 = _2822;
          _3091 = _2823;
          _3092 = _2824;
          _3093 = 0.10000000149011612f;
          _3094 = 1.0f;
          _3095 = 1.0f;
          _3096 = 1.0f;
          _3097 = _3069;
        }
      } else {
        _3086 = 0.800000011920929f;
        _3087 = _2719;
        _3088 = _2720;
        _3089 = _2721;
        _3090 = _2822;
        _3091 = _2823;
        _3092 = _2824;
        _3093 = 0.10000000149011612f;
        _3094 = 1.0f;
        _3095 = 1.0f;
        _3096 = 1.0f;
        _3097 = _3069;
      }
      float _3105 = float(half(saturate(_3097) * 0.31830987334251404f)) * _2805;
      float _3113 = 0.699999988079071f / min(max(max(max(_3094, _3095), _3096), 0.009999999776482582f), 0.699999988079071f);
      float _3124 = (((_3113 * _3095) + -0.03999999910593033f) * _3093) + 0.03999999910593033f;
      float _3126 = _2839 - _206;
      float _3127 = _2840 - _207;
      float _3128 = _2841 - _208;
      float _3130 = rsqrt(dot(float3(_3126, _3127, _3128), float3(_3126, _3127, _3128)));
      float _3131 = _3130 * _3126;
      float _3132 = _3130 * _3127;
      float _3133 = _3130 * _3128;
      float _3134 = -0.0f - _206;
      float _3135 = -0.0f - _207;
      float _3136 = -0.0f - _208;
      float _3141 = saturate(max(9.999999747378752e-06f, dot(float3(_3134, _3135, _3136), float3(_3087, _3088, _3089))));
      float _3143 = saturate(dot(float3(_3087, _3088, _3089), float3(_3131, _3132, _3133)));
      float _3146 = saturate(1.0f - saturate(saturate(dot(float3(_3134, _3135, _3136), float3(_3131, _3132, _3133)))));
      float _3147 = _3146 * _3146;
      float _3149 = (_3147 * _3147) * _3146;
      float _3152 = _3149 * saturate(_3124 * 50.0f);
      float _3153 = 1.0f - _3149;
      float _3161 = saturate(_3097 * _2805);
      float _3162 = _3086 * _3086;
      float _3163 = _3162 * _3162;
      float _3164 = 1.0f - _3162;
      float _3176 = (((_3143 * _3163) - _3143) * _3143) + 1.0f;
      float _3180 = (_3163 / ((_3176 * _3176) * 3.1415927410125732f)) * (0.5f / ((((_3141 * _3164) + _3162) * _3097) + (_3141 * ((_3097 * _3164) + _3162))));
      float _3191 = ((((_3048 * 0.6131200194358826f) + (_3049 * 0.3395099937915802f)) + (_3050 * 0.047370001673698425f)) * _2861) * ((max((((_3153 * ((((_3113 * _3094) + -0.03999999910593033f) * _3093) + 0.03999999910593033f)) + _3152) * _3180), 0.0f) * _3161) + (_3105 * float(_3090)));
      float _3193 = ((((_3048 * 0.07020000368356705f) + (_3049 * 0.9163600206375122f)) + (_3050 * 0.013450000435113907f)) * _2861) * ((max((((_3153 * _3124) + _3152) * _3180), 0.0f) * _3161) + (_3105 * float(_3091)));
      float _3195 = ((((_3048 * 0.02061999961733818f) + (_3049 * 0.10958000272512436f)) + (_3050 * 0.8697999715805054f)) * _2861) * ((max((((_3153 * ((((_3113 * _3096) + -0.03999999910593033f) * _3093) + 0.03999999910593033f)) + _3152) * _3180), 0.0f) * _3161) + (_3105 * float(_3092)));
      float _3200 = dot(float3(_3191, _3193, _3195), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _3201 = min((max(0.0005000000237487257f, _exposure3.w) * 4096.0f), _3200);
      float _3205 = max(9.999999717180685e-10f, _3200);
      float _3206 = (_3201 * _3191) / _3205;
      float _3207 = (_3201 * _3193) / _3205;
      float _3208 = (_3201 * _3195) / _3205;
      if (((_105 == 33)) || ((_105 == 55))) {
        if ((_2827) || ((!(_2827)) && (_sunDirection.y > _moonDirection.y))) {
          _3229 = _sunDirection.x;
          _3230 = _sunDirection.y;
          _3231 = _sunDirection.z;
        } else {
          _3229 = _moonDirection.x;
          _3230 = _moonDirection.y;
          _3231 = _moonDirection.z;
        }
        float _3236 = rsqrt(dot(float3(_165, _166, _167), float3(_165, _166, _167)));
        float _3237 = _3236 * _165;
        float _3238 = _3236 * _166;
        float _3239 = _3236 * _167;
        float _3243 = _165 - (_125 * 0.03999999910593033f);
        float _3244 = _166 - (_126 * 0.03999999910593033f);
        float _3245 = _167 - (_127 * 0.03999999910593033f);
        float _3249 = (_viewPos.x - (_staticShadowPosition[1].x)) + _3243;
        float _3250 = (_viewPos.y - (_staticShadowPosition[1].y)) + _3244;
        float _3251 = (_viewPos.z - (_staticShadowPosition[1].z)) + _3245;
        float _3255 = mad((_shadowProjRelativeTexScale[1][0].z), _3251, mad((_shadowProjRelativeTexScale[1][0].y), _3250, (_3249 * (_shadowProjRelativeTexScale[1][0].x)))) + (_shadowProjRelativeTexScale[1][0].w);
        float _3259 = mad((_shadowProjRelativeTexScale[1][1].z), _3251, mad((_shadowProjRelativeTexScale[1][1].y), _3250, (_3249 * (_shadowProjRelativeTexScale[1][1].x)))) + (_shadowProjRelativeTexScale[1][1].w);
        bool _3270 = ((((((!(_3255 <= _2187))) || ((!(_3255 >= _2186))))) || ((!(_3259 <= _2187))))) || ((!(_3259 >= _2186)));
        float _3278 = (_viewPos.x - (_staticShadowPosition[0].x)) + _3243;
        float _3279 = (_viewPos.y - (_staticShadowPosition[0].y)) + _3244;
        float _3280 = (_viewPos.z - (_staticShadowPosition[0].z)) + _3245;
        float _3284 = mad((_shadowProjRelativeTexScale[0][0].z), _3280, mad((_shadowProjRelativeTexScale[0][0].y), _3279, (_3278 * (_shadowProjRelativeTexScale[0][0].x)))) + (_shadowProjRelativeTexScale[0][0].w);
        float _3288 = mad((_shadowProjRelativeTexScale[0][1].z), _3280, mad((_shadowProjRelativeTexScale[0][1].y), _3279, (_3278 * (_shadowProjRelativeTexScale[0][1].x)))) + (_shadowProjRelativeTexScale[0][1].w);
        bool _3299 = ((((((!(_3284 <= _2187))) || ((!(_3284 >= _2186))))) || ((!(_3288 <= _2187))))) || ((!(_3288 >= _2186)));
        float _3301 = select(((_3299) && (_3270)), 0.0f, 0.0010000000474974513f);
        float _3302 = select(_3299, select(_3270, 0.0f, _3255), _3284);
        float _3303 = select(_3299, select(_3270, 0.0f, _3259), _3288);
        float _3304 = select(_3299, select(_3270, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _3251, mad((_shadowProjRelativeTexScale[1][2].y), _3250, (_3249 * (_shadowProjRelativeTexScale[1][2].x)))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _3280, mad((_shadowProjRelativeTexScale[0][2].y), _3279, (_3278 * (_shadowProjRelativeTexScale[0][2].x)))) + (_shadowProjRelativeTexScale[0][2].w)));
        int _3305 = select(_3299, select(_3270, -1, 1), 0);
        [branch]
        if (!(_3305 == -1)) {
          float _3311 = (_3302 * _shadowSizeAndInvSize.x) + -0.5f;
          float _3312 = (_3303 * _shadowSizeAndInvSize.y) + -0.5f;
          int _3315 = int(floor(_3311));
          int _3316 = int(floor(_3312));
          if (!((((uint)_3315 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_3316 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
            float4 _3326 = __3__36__0__0__g_shadowDepthArray.Load(int4(_3315, _3316, _3305, 0));
            float4 _3328 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_3315) + 1u)), _3316, _3305, 0));
            float4 _3330 = __3__36__0__0__g_shadowDepthArray.Load(int4(_3315, ((int)((uint)(_3316) + 1u)), _3305, 0));
            float4 _3332 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_3315) + 1u)), ((int)((uint)(_3316) + 1u)), _3305, 0));
            _3335 = _3326.x;
            _3336 = _3328.x;
            _3337 = _3330.x;
            _3338 = _3332.x;
          } else {
            _3335 = 0.0f;
            _3336 = 0.0f;
            _3337 = 0.0f;
            _3338 = 0.0f;
          }
          float _3364 = (float4(_invShadowViewProj[_3305][0][0], _invShadowViewProj[_3305][1][0], _invShadowViewProj[_3305][2][0], _invShadowViewProj[_3305][3][0]).x) * _3302;
          float _3368 = (float4(_invShadowViewProj[_3305][0][0], _invShadowViewProj[_3305][1][0], _invShadowViewProj[_3305][2][0], _invShadowViewProj[_3305][3][0]).y) * _3302;
          float _3372 = (float4(_invShadowViewProj[_3305][0][0], _invShadowViewProj[_3305][1][0], _invShadowViewProj[_3305][2][0], _invShadowViewProj[_3305][3][0]).z) * _3302;
          float _3376 = (float4(_invShadowViewProj[_3305][0][0], _invShadowViewProj[_3305][1][0], _invShadowViewProj[_3305][2][0], _invShadowViewProj[_3305][3][0]).w) * _3302;
          float _3379 = mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).w), _3335, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).w), _3303, _3376)) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).w);
          float _3380 = (mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).x), _3335, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).x), _3303, _3364)) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).x)) / _3379;
          float _3381 = (mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).y), _3335, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).y), _3303, _3368)) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).y)) / _3379;
          float _3382 = (mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).z), _3335, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).z), _3303, _3372)) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).z)) / _3379;
          float _3385 = _3302 + (_shadowSizeAndInvSize.z * 4.0f);
          float _3401 = mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).w), _3336, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).w), _3303, ((float4(_invShadowViewProj[_3305][0][0], _invShadowViewProj[_3305][1][0], _invShadowViewProj[_3305][2][0], _invShadowViewProj[_3305][3][0]).w) * _3385))) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).w);
          float _3407 = _3303 - (_shadowSizeAndInvSize.w * 2.0f);
          float _3419 = mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).w), _3337, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).w), _3407, _3376)) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).w);
          float _3423 = ((mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).x), _3337, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).x), _3407, _3364)) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).x)) / _3419) - _3380;
          float _3424 = ((mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).y), _3337, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).y), _3407, _3368)) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).y)) / _3419) - _3381;
          float _3425 = ((mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).z), _3337, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).z), _3407, _3372)) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).z)) / _3419) - _3382;
          float _3426 = ((mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).x), _3336, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).x), _3303, ((float4(_invShadowViewProj[_3305][0][0], _invShadowViewProj[_3305][1][0], _invShadowViewProj[_3305][2][0], _invShadowViewProj[_3305][3][0]).x) * _3385))) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).x)) / _3401) - _3380;
          float _3427 = ((mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).y), _3336, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).y), _3303, ((float4(_invShadowViewProj[_3305][0][0], _invShadowViewProj[_3305][1][0], _invShadowViewProj[_3305][2][0], _invShadowViewProj[_3305][3][0]).y) * _3385))) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).y)) / _3401) - _3381;
          float _3428 = ((mad((float4(_invShadowViewProj[_3305][0][2], _invShadowViewProj[_3305][1][2], _invShadowViewProj[_3305][2][2], _invShadowViewProj[_3305][3][2]).z), _3336, mad((float4(_invShadowViewProj[_3305][0][1], _invShadowViewProj[_3305][1][1], _invShadowViewProj[_3305][2][1], _invShadowViewProj[_3305][3][1]).z), _3303, ((float4(_invShadowViewProj[_3305][0][0], _invShadowViewProj[_3305][1][0], _invShadowViewProj[_3305][2][0], _invShadowViewProj[_3305][3][0]).z) * _3385))) + (float4(_invShadowViewProj[_3305][0][3], _invShadowViewProj[_3305][1][3], _invShadowViewProj[_3305][2][3], _invShadowViewProj[_3305][3][3]).z)) / _3401) - _3382;
          float _3431 = (_3425 * _3427) - (_3424 * _3428);
          float _3434 = (_3423 * _3428) - (_3425 * _3426);
          float _3437 = (_3424 * _3426) - (_3423 * _3427);
          float _3439 = rsqrt(dot(float3(_3431, _3434, _3437), float3(_3431, _3434, _3437)));
          float _3443 = frac(_3311);
          float _3448 = (saturate(dot(float3(_3237, _3238, _3239), float3((_3431 * _3439), (_3434 * _3439), (_3437 * _3439)))) * 0.0020000000949949026f) + _3304;
          float _3461 = saturate(exp2((_3335 - _3448) * 1442695.0f));
          float _3463 = saturate(exp2((_3337 - _3448) * 1442695.0f));
          float _3469 = ((saturate(exp2((_3336 - _3448) * 1442695.0f)) - _3461) * _3443) + _3461;
          _3476 = saturate((((_3463 - _3469) + ((saturate(exp2((_3338 - _3448) * 1442695.0f)) - _3463) * _3443)) * frac(_3312)) + _3469);
          _3477 = _3335;
          _3478 = _3336;
          _3479 = _3337;
          _3480 = _3338;
        } else {
          _3476 = 1.0f;
          _3477 = 0.0f;
          _3478 = 0.0f;
          _3479 = 0.0f;
          _3480 = 0.0f;
        }
        float _3484 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _3245, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _3244, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _3243))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
        float _3488 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _3245, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _3244, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _3243))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
        float _3492 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _3245, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _3244, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _3243))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
        if (!(((((!(_3484 <= _2470))) || ((!(_3484 >= _2469))))) || ((!(_3488 <= _2470))))) {
          bool _3503 = ((_3492 >= -1.0f)) && ((((_3488 >= _2469)) && ((_3492 <= 1.0f))));
          _3511 = select(_3503, 9.999999747378752e-06f, _3301);
          _3512 = select(_3503, _3484, _3302);
          _3513 = select(_3503, _3488, _3303);
          _3514 = select(_3503, _3492, _3304);
          _3515 = select(_3503, 1, _3305);
          _3516 = ((int)(uint)((int)(_3503)));
        } else {
          _3511 = _3301;
          _3512 = _3302;
          _3513 = _3303;
          _3514 = _3304;
          _3515 = _3305;
          _3516 = 0;
        }
        float _3520 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _3245, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _3244, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _3243))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
        float _3524 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _3245, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _3244, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _3243))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
        float _3528 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _3245, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _3244, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _3243))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
        if (!(((((!(_3520 <= _2470))) || ((!(_3520 >= _2469))))) || ((!(_3524 <= _2470))))) {
          bool _3539 = ((_3528 >= -1.0f)) && ((((_3524 >= _2469)) && ((_3528 <= 1.0f))));
          _3547 = select(_3539, 9.999999747378752e-06f, _3511);
          _3548 = select(_3539, _3520, _3512);
          _3549 = select(_3539, _3524, _3513);
          _3550 = select(_3539, _3528, _3514);
          _3551 = select(_3539, 0, _3515);
          _3552 = select(_3539, 1, _3516);
        } else {
          _3547 = _3511;
          _3548 = _3512;
          _3549 = _3513;
          _3550 = _3514;
          _3551 = _3515;
          _3552 = _3516;
        }
        [branch]
        if (!(_3552 == 0)) {
          int _3562 = int(floor((_3548 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
          int _3563 = int(floor((_3549 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
          if (!((((uint)_3562 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_3563 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
            float4 _3573 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_3562, _3563, _3551, 0));
            float4 _3575 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_3562) + 1u)), _3563, _3551, 0));
            float4 _3577 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_3562, ((int)((uint)(_3563) + 1u)), _3551, 0));
            float4 _3579 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_3562) + 1u)), ((int)((uint)(_3563) + 1u)), _3551, 0));
            _3582 = _3573.x;
            _3583 = _3575.x;
            _3584 = _3577.x;
            _3585 = _3579.x;
          } else {
            _3582 = _3477;
            _3583 = _3478;
            _3584 = _3479;
            _3585 = _3480;
          }
          if ((_2827) || ((!(_2827)) && (_sunDirection.y > _moonDirection.y))) {
            _3597 = _sunDirection.x;
            _3598 = _sunDirection.y;
            _3599 = _sunDirection.z;
          } else {
            _3597 = _moonDirection.x;
            _3598 = _moonDirection.y;
            _3599 = _moonDirection.z;
          }
          float _3605 = (_3547 - (saturate(-0.0f - dot(float3(_3597, _3598, _3599), float3(_3237, _3238, _3239))) * 9.999999747378752e-05f)) + _3550;
          _3618 = min(float((bool)(uint)(_3582 > _3605)), min(min(float((bool)(uint)(_3583 > _3605)), float((bool)(uint)(_3584 > _3605))), float((bool)(uint)(_3585 > _3605))));
        } else {
          _3618 = _3476;
        }
        float _3619 = _2727 + _3243;
        float _3620 = _2728 + _3244;
        float _3621 = _2729 + _3245;
        float _3625 = mad((_terrainShadowProjRelativeTexScale[0].z), _3621, mad((_terrainShadowProjRelativeTexScale[0].y), _3620, (_3619 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
        float _3629 = mad((_terrainShadowProjRelativeTexScale[1].z), _3621, mad((_terrainShadowProjRelativeTexScale[1].y), _3620, (_3619 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
        float _3633 = mad((_terrainShadowProjRelativeTexScale[2].z), _3621, mad((_terrainShadowProjRelativeTexScale[2].y), _3620, (_3619 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
        if (saturate(_3625) == _3625) {
          if (((_3633 >= 9.999999747378752e-05f)) && ((((_3633 <= 1.0f)) && ((saturate(_3629) == _3629))))) {
            float _3648 = frac((_3625 * 1024.0f) + -0.5f);
            float4 _3652 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_3625, _3629));
            float _3657 = _3633 + -0.004999999888241291f;
            float _3662 = select((_3652.w > _3657), 1.0f, 0.0f);
            float _3664 = select((_3652.x > _3657), 1.0f, 0.0f);
            float _3671 = ((select((_3652.z > _3657), 1.0f, 0.0f) - _3662) * _3648) + _3662;
            _3677 = saturate((((((select((_3652.y > _3657), 1.0f, 0.0f) - _3664) * _3648) + _3664) - _3671) * frac((_3629 * 1024.0f) + -0.5f)) + _3671);
          } else {
            _3677 = 1.0f;
          }
        } else {
          _3677 = 1.0f;
        }
        uint4 _3683 = __3__36__0__0__g_baseColor.Load(int3((int)(uint(_71 * (1.0f / g_screenSpaceScale.x))), (int)(uint(_72 * (1.0f / g_screenSpaceScale.y))), 0));
        float _3689 = float((uint)((uint)(((uint)((uint)(_3683.x)) >> 8) & 255))) * 0.003921568859368563f;
        float _3692 = float((uint)((uint)(_3683.x & 255))) * 0.003921568859368563f;
        float _3696 = float((uint)((uint)(((uint)((uint)(_3683.y)) >> 8) & 255))) * 0.003921568859368563f;
        float _3697 = _3689 * _3689;
        float _3698 = _3692 * _3692;
        float _3699 = _3696 * _3696;
        if ((_2827) || ((!(_2827)) && (_sunDirection.y > _moonDirection.y))) {
          _3734 = _precomputedAmbient7.y;
        } else {
          _3734 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
        }
        float _3736 = (_earthRadius + _viewPos.y) + _166;
        float _3740 = (_167 * _167) + (_165 * _165);
        float _3742 = sqrt((_3736 * _3736) + _3740);
        float _3747 = dot(float3((_165 / _3742), (_3736 / _3742), (_167 / _3742)), float3(_3229, _3230, _3231));
        float _3750 = min(max(((_3742 - _earthRadius) / _atmosphereThickness), 16.0f), _2878);
        float _3757 = max(_3750, 0.0f);
        float _3763 = (-0.0f - sqrt((_3757 + _2889) * _3757)) / (_3757 + _earthRadius);
        if (_3747 > _3763) {
          _3786 = ((exp2(log2(saturate((_3747 - _3763) / (1.0f - _3763))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
        } else {
          _3786 = ((exp2(log2(saturate((_3763 - _3747) / (_3763 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
        }
        float2 _3789 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_3750 + -16.0f) / _2882)) * 0.5f) * 0.96875f) + 0.015625f), _3786), 0.0f);
        float _3793 = (_2943 * _2942) * _3789.y;
        float _3803 = exp2((_3793 + (_3789.x * _2951)) * -1.4426950216293335f);
        float _3804 = exp2((_3793 + (_3789.x * _2954)) * -1.4426950216293335f);
        float _3805 = exp2((_3793 + (_3789.x * _2957)) * -1.4426950216293335f);
        float _3821 = sqrt(_3740);
        float _3827 = (_cloudAltitude - (max(((_3821 * _3821) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
        float _3837 = _3827 + ((0.5f - (float((int)(((int)(uint)((int)(_3230 > 0.0f))) - ((int)(uint)((int)(_3230 < 0.0f))))) * 0.5f)) * _cloudThickness);
        if (_166 < _3827) {
          float _3840 = dot(float3(0.0f, 1.0f, 0.0f), float3(_3229, _3230, _3231));
          float _3846 = select((abs(_3840) < 9.99999993922529e-09f), 1e+08f, ((_3837 - dot(float3(0.0f, 1.0f, 0.0f), float3(_165, _166, _167))) / _3840));
          _3852 = ((_3846 * _3229) + _165);
          _3853 = _3837;
          _3854 = ((_3846 * _3231) + _167);
        } else {
          _3852 = _165;
          _3853 = _166;
          _3854 = _167;
        }
        float _3861 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3852 * 4.999999873689376e-05f) + 0.5f), ((_3853 - _3827) / _cloudThickness), ((_3854 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
        float _3868 = saturate(abs(_3230) * 4.0f);
        float _3870 = (_3868 * _3868) * exp2((_3032 * _3031) * _3861.x);
        float _3877 = ((1.0f - _3870) * saturate(((_166 - _cloudThickness) - _3827) * 0.10000000149011612f)) + _3870;
        float _3878 = _3877 * (((_3804 * 0.3395099937915802f) + (_3803 * 0.6131200194358826f)) + (_3805 * 0.047370001673698425f));
        float _3879 = _3877 * (((_3804 * 0.9163600206375122f) + (_3803 * 0.07020000368356705f)) + (_3805 * 0.013450000435113907f));
        float _3880 = _3877 * (((_3804 * 0.10958000272512436f) + (_3803 * 0.02061999961733818f)) + (_3805 * 0.8697999715805054f));
        float _3896 = ((max(0.0f, (0.30000001192092896f - dot(float3(_125, _126, _127), float3(_3229, _3230, _3231)))) * 0.1573420912027359f) * saturate(min(_3618, _3677))) * _3734;
        _3907 = (((_3896 * (((_3697 * 0.6131200194358826f) + (_3698 * 0.3395099937915802f)) + (_3699 * 0.047370001673698425f))) * (((_3878 * 0.6131200194358826f) + (_3879 * 0.3395099937915802f)) + (_3880 * 0.047370001673698425f))) + _3206);
        _3908 = (((_3896 * (((_3697 * 0.07020000368356705f) + (_3698 * 0.9163600206375122f)) + (_3699 * 0.013450000435113907f))) * (((_3878 * 0.07020000368356705f) + (_3879 * 0.9163600206375122f)) + (_3880 * 0.013450000435113907f))) + _3207);
        _3909 = (((_3896 * (((_3697 * 0.02061999961733818f) + (_3698 * 0.10958000272512436f)) + (_3699 * 0.8697999715805054f))) * (((_3878 * 0.02061999961733818f) + (_3879 * 0.10958000272512436f)) + (_3880 * 0.8697999715805054f))) + _3208);
      } else {
        _3907 = _3206;
        _3908 = _3207;
        _3909 = _3208;
      }
      float _3910 = (_renderParams2.z * _2137) * _3907;
      float _3911 = (_renderParams2.z * _2138) * _3908;
      float _3912 = (_renderParams2.z * _2139) * _3909;
      float _3916 = _3910 + _2052;
      float _3917 = _3911 + _2053;
      float _3918 = _3912 + _2054;
      _3929 = _2062;
      _3930 = (((max(_2052, _3910) - _3916) * _2064) + _3916);
      _3931 = (((max(_2053, _3911) - _3917) * _2064) + _3917);
      _3932 = (((max(_2054, _3912) - _3918) * _2064) + _3918);
    } else {
      _3929 = 1000.0f;
      _3930 = _2052;
      _3931 = _2053;
      _3932 = _2054;
    }
    if (!_757) {
      __3__38__0__1__g_raytracingHitResultUAV[int2(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)))] = float4(_199.x, _199.y, _199.z, select((_3929 <= 0.0f), 1000.0f, _3929));
    }
    if (((_3929 > 128.0f)) && ((dot(float3(_3930, _3931, _3932), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) == 0.0f))) {
      _3943 = 1;
      while(true) {
        int _3983 = int(floor(((_wrappedViewPos.x + _2068) * ((_clipmapOffsets[_3943]).w)) + ((_clipmapRelativeIndexOffsets[_3943]).x)));
        int _3984 = int(floor(((_wrappedViewPos.y + _2069) * ((_clipmapOffsets[_3943]).w)) + ((_clipmapRelativeIndexOffsets[_3943]).y)));
        int _3985 = int(floor(((_wrappedViewPos.z + _2070) * ((_clipmapOffsets[_3943]).w)) + ((_clipmapRelativeIndexOffsets[_3943]).z)));
        if (!((((((((int)_3983 >= (int)int(((_clipmapOffsets[_3943]).x) + -63.0f))) && (((int)_3983 < (int)int(((_clipmapOffsets[_3943]).x) + 63.0f))))) && (((((int)_3984 >= (int)int(((_clipmapOffsets[_3943]).y) + -31.0f))) && (((int)_3984 < (int)int(((_clipmapOffsets[_3943]).y) + 31.0f))))))) && (((((int)_3985 >= (int)int(((_clipmapOffsets[_3943]).z) + -63.0f))) && (((int)_3985 < (int)int(((_clipmapOffsets[_3943]).z) + 63.0f))))))) {
          if ((uint)(_3943 + 1) < (uint)8) {
            _3943 = (_3943 + 1);
            continue;
          } else {
            _4001 = -10000;
          }
        } else {
          _4001 = _3943;
        }
        if (!((uint)_4001 > (uint)3)) {
          float _4021 = 1.0f / float((uint)(1u << (_4001 & 31)));
          float _4025 = frac(((_invClipmapExtent.z * _2070) + _clipmapUVRelativeOffset.z) * _4021);
          float _4037 = __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _2068) + _clipmapUVRelativeOffset.x) * _4021), (((_invClipmapExtent.y * _2069) + _clipmapUVRelativeOffset.y) * _4021), (((float((uint)(_4001 * 66)) + 1.0f) + ((select((_4025 < 0.0f), 1.0f, 0.0f) + _4025) * 64.0f)) * 0.0037878789007663727f)), 0.0f);
          _4042 = saturate(1.0f - _4037.x);
        } else {
          _4042 = 1.0f;
        }
        float _4045 = _renderParams.w * _4042;
        bool _4046 = (_749 == 0.0f);
        float4 _4054 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(select(_4046, (-0.0f - _206), _961), select(_4046, _207, _962), select(_4046, (-0.0f - _208), _963)), 4.0f);
        _4068 = ((_4045 * select(_4046, 0.03125f, _746)) * _4054.x);
        _4069 = ((_4045 * select(_4046, 0.03125f, _747)) * _4054.y);
        _4070 = ((_4045 * select(_4046, 0.03125f, _748)) * _4054.z);
        // [DAWN_DUSK_GI] Probe directional boost + energy floor
        if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
          float _ddFactor = DawnDuskFactor(_sunDirection.y);
          float3 _ddAmbient = DawnDuskAmbientBoost(
            float3(_4068, _4069, _4070),
            float3(_125, _126, _127),
            _sunDirection.xyz,
            _ddFactor,
            _precomputedAmbient0.xyz);
          _4068 = _ddAmbient.x;
          _4069 = _ddAmbient.y;
          _4070 = _ddAmbient.z;
        }
        break;
      }
    } else {
      _4068 = _3930;
      _4069 = _3931;
      _4070 = _3932;
    }
    float _4077 = saturate(1.0f - saturate(_2055));
    float _4081 = (_4077 - (_renderParams2.w * _4077)) + _renderParams2.w;
    float4 _4085 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(_206, _207, _208), 4.0f);
    float _4091 = _renderParams.w * _4081;
    float _4092 = _4091 * _4085.x;
    float _4093 = _4091 * _4085.y;
    float _4094 = _4091 * _4085.z;
    // [DAWN_DUSK_GI] Probe directional boost + energy floor
    if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
      float _ddFactor = DawnDuskFactor(_sunDirection.y);
      float3 _ddAmbient = DawnDuskAmbientBoost(
        float3(_4092, _4093, _4094),
        float3(_125, _126, _127),
        _sunDirection.xyz,
        _ddFactor,
        _precomputedAmbient0.xyz);
      _4092 = _ddAmbient.x;
      _4093 = _ddAmbient.y;
      _4094 = _ddAmbient.z;
    }
    float _4099 = dot(float3(_4092, _4093, _4094), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _4100 = min((max(0.009999999776482582f, _exposure3.w) * 2048.0f), _4099);
    float _4104 = max(9.999999717180685e-10f, _4099);
    float _4112 = __3__36__0__0__g_raytracingDiffuseRayInversePDF.Load(int3(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)), 0));
    // [GI_ENERGY_CONSERVATION] Dawn/dusk inverse PDF energy correction
    // vanilla is 2x for whatever reason dunno why. Lowering it slightly 
    // for dawn/dusk helps 
    float _energyCorrection = 1.0f;
    if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
      float _ddFactor = DawnDuskFactor(_sunDirection.y);
      _energyCorrection = lerp(1.0f, 0.5f, _ddFactor);
    }
    float _4114 = _4112.x * 2.0f * _energyCorrection;
    float _4115 = _4114 * (((_4100 * _4092) / _4104) + (_renderParams2.y * _4068));
    float _4116 = _4114 * (((_4100 * _4093) / _4104) + (_renderParams2.y * _4069));
    float _4117 = _4114 * (((_4100 * _4094) / _4104) + (_renderParams2.y * _4070));
    if (!(_renderParams.y == 0.0f)) {
      float _4122 = saturate(dot(float3(_125, _126, _127), float3(_206, _207, _208)));
      _4127 = (_4122 * _4115);
      _4128 = (_4122 * _4116);
      _4129 = (_4122 * _4117);
    } else {
      _4127 = _4115;
      _4128 = _4116;
      _4129 = _4117;
    }
    if ((((((_101 & 126) == 96)) || ((_105 == 98)))) && ((_170 < 1000.0f))) {
      float _4139 = float((uint)(uint)(_frameNumber.x));
      float _4150 = (frac(((_4139 * 92.0f) + _71) * 0.0078125f) * 128.0f) + -64.34062194824219f;
      float _4151 = (frac(((_4139 * 71.0f) + _72) * 0.0078125f) * 128.0f) + -72.46562194824219f;
      float _4156 = frac(dot(float3((_4150 * _4150), (_4151 * _4151), (_4151 * _4150)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
      float _4163 = float((uint)((uint)(((int)(_frameNumber.x * 91)) & 15)));
      uint _4174 = min((uint)(15), (uint)((int)(uint(frac(frac(dot(float2(((_4163 * 32.665000915527344f) + _71), ((_4163 * 11.8149995803833f) + _72)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 16.0f))));
      float _4187 = 0.2774999737739563f / ((float((uint)((uint)(reversebits(_4174) ^ (int)(uint(_4156 * 287478368.0f))))) * 3.958121053138086e-10f) + 0.1499999761581421f);
      float _4188 = frac((float((uint)_4174) * 0.0625f) + (float((uint)((uint)((int)(uint(_4156 * 51540816.0f)) & 65535))) * 1.52587890625e-05f)) * 6.2831854820251465f;
      float _4191 = saturate((_4187 * _4187) * -0.5882352590560913f);
      float _4194 = sqrt(1.0f - (_4191 * _4191));
      float _4197 = cos(_4188) * _4194;
      float _4198 = sin(_4188) * _4194;
      float _4200 = -0.0f - _126;
      float _4203 = select((_127 <= -0.0f), 1.0f, -1.0f);
      float _4205 = 1.0f / (_4203 - _127);
      float _4206 = -0.0f - _4205;
      float _4208 = (_125 * _4206) * _126;
      float _4209 = _4203 * _125;
      float _4218 = mad(_4191, (-0.0f - _125), mad(_4198, _4208, ((((_4209 * _125) * _4206) + 1.0f) * _4197)));
      float _4222 = mad(_4191, _4200, mad(_4198, (((_126 * _4200) * _4205) + _4203), ((_4197 * _4203) * _4208)));
      float _4225 = mad(_4191, (-0.0f - _127), mad(_4198, _126, (_4209 * _4197)));
      float _4230 = ((frac(frac(dot(float2(_71, _72), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 0.10000000149011612f) + 0.009999999776482582f) * _voxelParams.x;
      _4232 = 0;
      while(true) {
        int _4272 = int(floor(((_wrappedViewPos.x + _165) * ((_clipmapOffsets[_4232]).w)) + ((_clipmapRelativeIndexOffsets[_4232]).x)));
        int _4273 = int(floor(((_wrappedViewPos.y + _166) * ((_clipmapOffsets[_4232]).w)) + ((_clipmapRelativeIndexOffsets[_4232]).y)));
        int _4274 = int(floor(((_wrappedViewPos.z + _167) * ((_clipmapOffsets[_4232]).w)) + ((_clipmapRelativeIndexOffsets[_4232]).z)));
        if (!((((((((int)_4272 >= (int)int(((_clipmapOffsets[_4232]).x) + -63.0f))) && (((int)_4272 < (int)int(((_clipmapOffsets[_4232]).x) + 63.0f))))) && (((((int)_4273 >= (int)int(((_clipmapOffsets[_4232]).y) + -31.0f))) && (((int)_4273 < (int)int(((_clipmapOffsets[_4232]).y) + 31.0f))))))) && (((((int)_4274 >= (int)int(((_clipmapOffsets[_4232]).z) + -63.0f))) && (((int)_4274 < (int)int(((_clipmapOffsets[_4232]).z) + 63.0f))))))) {
          if ((uint)(_4232 + 1) < (uint)8) {
            _4232 = (_4232 + 1);
            continue;
          } else {
            _4290 = -10000;
          }
        } else {
          _4290 = _4232;
        }
        if (!(((_4290 == -10000)) || (((int)_4290 > (int)4)))) {
          _4303 = 0;
          _4304 = 1.0f;
          _4305 = 0.0f;
          _4306 = 0.0f;
          _4307 = 0.0f;
          _4308 = 0.05000000074505806f;
          _4309 = ((_4230 * _4225) + _167);
          _4310 = ((_4230 * _4222) + _166);
          _4311 = ((_4230 * _4218) + _165);
          while(true) {
            _4313 = 0;
            while(true) {
              float _4338 = ((_wrappedViewPos.x + _4311) * ((_clipmapOffsets[_4313]).w)) + ((_clipmapRelativeIndexOffsets[_4313]).x);
              float _4339 = ((_wrappedViewPos.y + _4310) * ((_clipmapOffsets[_4313]).w)) + ((_clipmapRelativeIndexOffsets[_4313]).y);
              float _4340 = ((_wrappedViewPos.z + _4309) * ((_clipmapOffsets[_4313]).w)) + ((_clipmapRelativeIndexOffsets[_4313]).z);
              bool __defer_4312_4355 = false;
              if (!(((_4340 >= (((_clipmapOffsets[_4313]).z) + -63.0f))) && ((((_4338 >= (((_clipmapOffsets[_4313]).x) + -63.0f))) && ((_4339 >= (((_clipmapOffsets[_4313]).y) + -31.0f)))))) || ((((_4340 >= (((_clipmapOffsets[_4313]).z) + -63.0f))) && ((((_4338 >= (((_clipmapOffsets[_4313]).x) + -63.0f))) && ((_4339 >= (((_clipmapOffsets[_4313]).y) + -31.0f)))))) && (!(((_4340 < (((_clipmapOffsets[_4313]).z) + 63.0f))) && ((((_4338 < (((_clipmapOffsets[_4313]).x) + 63.0f))) && ((_4339 < (((_clipmapOffsets[_4313]).y) + 31.0f))))))))) {
                __defer_4312_4355 = true;
              } else {
                if ((uint)_4313 > (uint)3) {
                  _4892 = _4307;
                  _4893 = _4306;
                  _4894 = _4305;
                  _4895 = 0.0f;
                  _4897 = _4892;
                  _4898 = _4893;
                  _4899 = _4894;
                  _4900 = _4895;
                } else {
                  float _4361 = max(0.05000000074505806f, (_voxelParams.x * 0.05000000074505806f));
                  _4363 = 0;
                  while(true) {
                    int _4403 = int(floor(((_wrappedViewPos.x + _4311) * ((_clipmapOffsets[_4363]).w)) + ((_clipmapRelativeIndexOffsets[_4363]).x)));
                    int _4404 = int(floor(((_wrappedViewPos.y + _4310) * ((_clipmapOffsets[_4363]).w)) + ((_clipmapRelativeIndexOffsets[_4363]).y)));
                    int _4405 = int(floor(((_wrappedViewPos.z + _4309) * ((_clipmapOffsets[_4363]).w)) + ((_clipmapRelativeIndexOffsets[_4363]).z)));
                    if ((((((((int)_4403 >= (int)int(((_clipmapOffsets[_4363]).x) + -63.0f))) && (((int)_4403 < (int)int(((_clipmapOffsets[_4363]).x) + 63.0f))))) && (((((int)_4404 >= (int)int(((_clipmapOffsets[_4363]).y) + -31.0f))) && (((int)_4404 < (int)int(((_clipmapOffsets[_4363]).y) + 31.0f))))))) && (((((int)_4405 >= (int)int(((_clipmapOffsets[_4363]).z) + -63.0f))) && (((int)_4405 < (int)int(((_clipmapOffsets[_4363]).z) + 63.0f)))))) {
                      _4426 = (_4403 & 127);
                      _4427 = (_4404 & 63);
                      _4428 = (_4405 & 127);
                      _4429 = _4363;
                    } else {
                      if ((uint)(_4363 + 1) < (uint)8) {
                        _4363 = (_4363 + 1);
                        continue;
                      } else {
                        _4426 = -10000;
                        _4427 = -10000;
                        _4428 = -10000;
                        _4429 = -10000;
                      }
                    }
                    if (!((uint)_4429 > (uint)5)) {
                      uint _4441 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4426, _4427, ((int)(((uint)(((int)(_4429 * 130)) | 1)) + (uint)(_4428))), 0));
                      bool _4444 = ((_4441.x & 4194303) == 0);
                      [branch]
                      if (!_4444) {
                        _4447 = _4426;
                        _4448 = _4427;
                        _4449 = _4428;
                        _4450 = _4429;
                      } else {
                        _4447 = -10000;
                        _4448 = -10000;
                        _4449 = -10000;
                        _4450 = -10000;
                      }
                      float _4452 = (float((int)((int)(1u << (_4429 & 31)))) * 0.5f) * _voxelParams.x;
                      _4457 = 0;
                      while(true) {
                        int _4497 = int(floor((((_4311 - _4452) + _wrappedViewPos.x) * ((_clipmapOffsets[_4457]).w)) + ((_clipmapRelativeIndexOffsets[_4457]).x)));
                        int _4498 = int(floor((((_4310 - _4452) + _wrappedViewPos.y) * ((_clipmapOffsets[_4457]).w)) + ((_clipmapRelativeIndexOffsets[_4457]).y)));
                        int _4499 = int(floor((((_4309 - _4452) + _wrappedViewPos.z) * ((_clipmapOffsets[_4457]).w)) + ((_clipmapRelativeIndexOffsets[_4457]).z)));
                        if ((((((((int)_4497 >= (int)int(((_clipmapOffsets[_4457]).x) + -63.0f))) && (((int)_4497 < (int)int(((_clipmapOffsets[_4457]).x) + 63.0f))))) && (((((int)_4498 >= (int)int(((_clipmapOffsets[_4457]).y) + -31.0f))) && (((int)_4498 < (int)int(((_clipmapOffsets[_4457]).y) + 31.0f))))))) && (((((int)_4499 >= (int)int(((_clipmapOffsets[_4457]).z) + -63.0f))) && (((int)_4499 < (int)int(((_clipmapOffsets[_4457]).z) + 63.0f)))))) {
                          _4520 = (_4497 & 127);
                          _4521 = (_4498 & 63);
                          _4522 = (_4499 & 127);
                          _4523 = _4457;
                        } else {
                          if ((uint)(_4457 + 1) < (uint)8) {
                            _4457 = (_4457 + 1);
                            continue;
                          } else {
                            _4520 = -10000;
                            _4521 = -10000;
                            _4522 = -10000;
                            _4523 = -10000;
                          }
                        }
                        if (!((uint)_4523 > (uint)5)) {
                          if (_4444) {
                            _4528 = 0;
                            _4529 = _4450;
                            _4530 = _4449;
                            _4531 = _4448;
                            _4532 = _4447;
                            while(true) {
                              _4541 = 0;
                              _4542 = _4529;
                              _4543 = _4530;
                              _4544 = _4531;
                              _4545 = _4532;
                              while(true) {
                                if (!((((uint)(_4541 + _4521) > (uint)63)) || (((uint)(_4520 | (_4528 + _4522)) > (uint)127)))) {
                                  uint _4563 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4520, (_4541 + _4521), ((int)(((uint)(_4528 + _4522)) + ((uint)(((int)(_4523 * 130)) | 1)))), 0));
                                  int _4565 = _4563.x & 4194303;
                                  _4568 = (_4565 != 0);
                                  _4569 = _4565;
                                  _4570 = _4523;
                                  _4571 = (_4528 + _4522);
                                  _4572 = (_4541 + _4521);
                                  _4573 = _4520;
                                } else {
                                  _4568 = false;
                                  _4569 = 0;
                                  _4570 = 0;
                                  _4571 = 0;
                                  _4572 = 0;
                                  _4573 = 0;
                                }
                                if (!_4568) {
                                  if (!((((uint)(_4541 + _4521) > (uint)63)) || (((uint)((_4520 + 1) | (_4528 + _4522)) > (uint)127)))) {
                                    uint _5756 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((_4520 + 1), (_4541 + _4521), ((int)(((uint)(_4528 + _4522)) + ((uint)(((int)(_4523 * 130)) | 1)))), 0));
                                    int _5758 = _5756.x & 4194303;
                                    _5761 = (_5758 != 0);
                                    _5762 = _5758;
                                    _5763 = _4523;
                                    _5764 = (_4528 + _4522);
                                    _5765 = (_4541 + _4521);
                                    _5766 = (_4520 + 1);
                                  } else {
                                    _5761 = false;
                                    _5762 = 0;
                                    _5763 = 0;
                                    _5764 = 0;
                                    _5765 = 0;
                                    _5766 = 0;
                                  }
                                  if (!_5761) {
                                    _4582 = _4545;
                                    _4583 = _4544;
                                    _4584 = _4543;
                                    _4585 = _4542;
                                    _4586 = 0;
                                  } else {
                                    _4582 = _5766;
                                    _4583 = _5765;
                                    _4584 = _5764;
                                    _4585 = _5763;
                                    _4586 = _5762;
                                  }
                                } else {
                                  _4582 = _4573;
                                  _4583 = _4572;
                                  _4584 = _4571;
                                  _4585 = _4570;
                                  _4586 = _4569;
                                }
                                if ((((int)(_4541 + 1) < (int)2)) && ((_4586 == 0))) {
                                  _4541 = (_4541 + 1);
                                  _4542 = _4585;
                                  _4543 = _4584;
                                  _4544 = _4583;
                                  _4545 = _4582;
                                  continue;
                                }
                                if ((((int)(_4528 + 1) < (int)2)) && ((_4586 == 0))) {
                                  _4528 = (_4528 + 1);
                                  _4529 = _4585;
                                  _4530 = _4584;
                                  _4531 = _4583;
                                  _4532 = _4582;
                                  __loop_jump_target = 4527;
                                  break;
                                }
                                _4535 = _4585;
                                _4536 = _4584;
                                _4537 = _4583;
                                _4538 = _4582;
                                break;
                              }
                              if (__loop_jump_target == 4527) {
                                __loop_jump_target = -1;
                                continue;
                              }
                              if (__loop_jump_target != -1) {
                                break;
                              }
                              break;
                            }
                          } else {
                            _4535 = _4450;
                            _4536 = _4449;
                            _4537 = _4448;
                            _4538 = _4447;
                          }
                          if ((uint)_4535 < (uint)6) {
                            uint _4592 = _4535 * 130;
                            uint _4596 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4538, _4537, ((int)(((uint)((int)(_4592) | 1)) + (uint)(_4536))), 0));
                            int _4598 = _4596.x & 4194303;
                            [branch]
                            if (!(_4598 == 0)) {
                              float _4604 = float((int)((int)(1u << (_4535 & 31)))) * _voxelParams.x;
                              float _4641 = -0.0f - _4218;
                              float _4642 = -0.0f - _4222;
                              float _4643 = -0.0f - _4225;
                              _4645 = 0.0f;
                              _4646 = 0.0f;
                              _4647 = 0.0f;
                              _4648 = 0.0f;
                              _4649 = 0;
                              while(true) {
                                int _4654 = __3__37__0__0__g_surfelDataBuffer[((_4598 + -1) + _4649)]._baseColor;
                                int _4656 = __3__37__0__0__g_surfelDataBuffer[((_4598 + -1) + _4649)]._normal;
                                int16_t _4659 = __3__37__0__0__g_surfelDataBuffer[((_4598 + -1) + _4649)]._radius;
                                if (!(_4654 == 0)) {
                                  half _4662 = __3__37__0__0__g_surfelDataBuffer[((_4598 + -1) + _4649)]._radiance.z;
                                  half _4663 = __3__37__0__0__g_surfelDataBuffer[((_4598 + -1) + _4649)]._radiance.y;
                                  half _4664 = __3__37__0__0__g_surfelDataBuffer[((_4598 + -1) + _4649)]._radiance.x;
                                  float _4670 = float((uint)((uint)(_4654 & 255)));
                                  float _4671 = float((uint)((uint)(((uint)((uint)(_4654)) >> 8) & 255)));
                                  float _4672 = float((uint)((uint)(((uint)((uint)(_4654)) >> 16) & 255)));
                                  float _4697 = select(((_4670 * 0.003921568859368563f) < 0.040449999272823334f), (_4670 * 0.0003035269910469651f), exp2(log2((_4670 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                                  float _4698 = select(((_4671 * 0.003921568859368563f) < 0.040449999272823334f), (_4671 * 0.0003035269910469651f), exp2(log2((_4671 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                                  float _4699 = select(((_4672 * 0.003921568859368563f) < 0.040449999272823334f), (_4672 * 0.0003035269910469651f), exp2(log2((_4672 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                                  float _4711 = (float((uint)((uint)(_4656 & 255))) * 0.007874015718698502f) + -1.0f;
                                  float _4712 = (float((uint)((uint)(((uint)((uint)(_4656)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                                  float _4713 = (float((uint)((uint)(((uint)((uint)(_4656)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                                  float _4715 = rsqrt(dot(float3(_4711, _4712, _4713), float3(_4711, _4712, _4713)));
                                  bool _4720 = ((_4656 & 16777215) == 0);
                                  float _4724 = float(_4664);
                                  float _4725 = float(_4663);
                                  float _4726 = float(_4662);
                                  float _4730 = (_4604 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_4659) & 255)));
                                  float _4746 = (((float((uint)((uint)((uint)((uint)(_4654)) >> 24))) * 0.003937007859349251f) + -0.5f) * _4604) + ((((((_clipmapOffsets[_4535]).x) + -63.5f) + float((int)(((int)(((uint)(_4538) + 64u) - (uint)(int((_clipmapOffsets[_4535]).x)))) & 127))) * _4604) - _viewPos.x);
                                  float _4747 = (((float((uint)((uint)((uint)((uint)(_4656)) >> 24))) * 0.003937007859349251f) + -0.5f) * _4604) + ((((((_clipmapOffsets[_4535]).y) + -31.5f) + float((int)(((int)(((uint)(_4537) + 32u) - (uint)(int((_clipmapOffsets[_4535]).y)))) & 63))) * _4604) - _viewPos.y);
                                  float _4748 = (((float((uint16_t)((uint)((uint16_t)((uint)(_4659)) >> 8))) * 0.003937007859349251f) + -0.5f) * _4604) + ((((((_clipmapOffsets[_4535]).z) + -63.5f) + float((int)(((int)(((uint)(_4536) + 64u) - (uint)(int((_clipmapOffsets[_4535]).z)))) & 127))) * _4604) - _viewPos.z);
                                  float _4766 = _4746 - _4311;
                                  float _4767 = _4747 - _4310;
                                  float _4768 = _4748 - _4309;
                                  float _4769 = dot(float3(_4766, _4767, _4768), float3(_4641, _4642, _4643));
                                  float _4773 = _4766 - (_4769 * _4641);
                                  float _4774 = _4767 - (_4769 * _4642);
                                  float _4775 = _4768 - (_4769 * _4643);
                                  float _4801 = 1.0f / float((uint)(1u << (_4535 & 31)));
                                  float _4805 = frac(((_invClipmapExtent.z * _4748) + _clipmapUVRelativeOffset.z) * _4801);
                                  float _4816 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _4746) + _clipmapUVRelativeOffset.x) * _4801), (((_invClipmapExtent.y * _4747) + _clipmapUVRelativeOffset.y) * _4801), (((float((uint)_4592) + 1.0f) + ((select((_4805 < 0.0f), 1.0f, 0.0f) + _4805) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                                  float _4830 = select(((int)_4535 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_4641, _4642, _4643), float3(select(_4720, _4641, (_4715 * _4711)), select(_4720, _4642, (_4715 * _4712)), select(_4720, _4643, (_4715 * _4713))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_4773, _4774, _4775), float3(_4773, _4774, _4775)) < ((_4730 * _4730) * 16.0f)))) * float((bool)(uint)(_4816.x > ((_4604 * 0.25f) * (saturate((dot(float3(_4724, _4725, _4726), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                                  float _4837 = (((((_4698 * 0.3395099937915802f) + (_4697 * 0.6131200194358826f)) + (_4699 * 0.047370001673698425f)) * _4724) * _4830) + _4645;
                                  float _4838 = (((((_4698 * 0.9163600206375122f) + (_4697 * 0.07020000368356705f)) + (_4699 * 0.013450000435113907f)) * _4725) * _4830) + _4646;
                                  float _4839 = (((((_4698 * 0.10958000272512436f) + (_4697 * 0.02061999961733818f)) + (_4699 * 0.8697999715805054f)) * _4726) * _4830) + _4647;
                                  float _4840 = _4830 + _4648;
                                  if ((uint)(_4649 + 1) < (uint)renodx::math::Select(RT_QUALITY >= 1.f, 8.f, 4.f)) {
                                    _4645 = _4837;
                                    _4646 = _4838;
                                    _4647 = _4839;
                                    _4648 = _4840;
                                    _4649 = (_4649 + 1);
                                    continue;
                                  } else {
                                    _4844 = _4837;
                                    _4845 = _4838;
                                    _4846 = _4839;
                                    _4847 = _4840;
                                  }
                                } else {
                                  _4844 = _4645;
                                  _4845 = _4646;
                                  _4846 = _4647;
                                  _4847 = _4648;
                                }
                                if (_4847 > 0.0f) {
                                  float _4850 = 1.0f / _4847;
                                  _4864 = (-0.0f - min(0.0f, (-0.0f - (_4844 * _4850))));
                                  _4865 = (-0.0f - min(0.0f, (-0.0f - (_4845 * _4850))));
                                  _4866 = (-0.0f - min(0.0f, (-0.0f - (_4846 * _4850))));
                                } else {
                                  _4864 = _4844;
                                  _4865 = _4845;
                                  _4866 = _4846;
                                }
                                break;
                              }
                            } else {
                              _4864 = 0.0f;
                              _4865 = 0.0f;
                              _4866 = 0.0f;
                            }
                          } else {
                            _4864 = 0.0f;
                            _4865 = 0.0f;
                            _4866 = 0.0f;
                          }
                        } else {
                          _4864 = 0.0f;
                          _4865 = 0.0f;
                          _4866 = 0.0f;
                        }
                        break;
                      }
                    } else {
                      _4864 = 0.0f;
                      _4865 = 0.0f;
                      _4866 = 0.0f;
                    }
                    float _4867 = _4304 * 0.31830987334251404f;
                    float _4871 = (_4864 * _4867) + _4307;
                    float _4872 = (_4865 * _4867) + _4306;
                    float _4873 = (_4866 * _4867) + _4305;
                    float _4876 = exp2(_4361 * -28.853900909423828f) * _4304;
                    if (_4876 < 0.050000011920928955f) {
                      _4892 = _4871;
                      _4893 = _4872;
                      _4894 = _4873;
                      _4895 = _4308;
                      _4897 = _4892;
                      _4898 = _4893;
                      _4899 = _4894;
                      _4900 = _4895;
                    } else {
                      float _4879 = _4361 + _4308;
                      if ((((uint)(_4303 + 1) < (uint)32)) && ((_4879 < 32.0f))) {
                        _4303 = (_4303 + 1);
                        _4304 = _4876;
                        _4305 = _4873;
                        _4306 = _4872;
                        _4307 = _4871;
                        _4308 = _4879;
                        _4309 = ((_4361 * _4225) + _4309);
                        _4310 = ((_4361 * _4222) + _4310);
                        _4311 = ((_4361 * _4218) + _4311);
                        __loop_jump_target = 4302;
                        break;
                      } else {
                        _4892 = _4871;
                        _4893 = _4872;
                        _4894 = _4873;
                        _4895 = 0.0f;
                        _4897 = _4892;
                        _4898 = _4893;
                        _4899 = _4894;
                        _4900 = _4895;
                      }
                    }
                    break;
                  }
                  if (__loop_jump_target != -1) {
                    break;
                  }
                }
              }
              if (__defer_4312_4355) {
                if ((int)(_4313 + 1) < (int)8) {
                  _4313 = (_4313 + 1);
                  continue;
                } else {
                  _4897 = _4307;
                  _4898 = _4306;
                  _4899 = _4305;
                  _4900 = 0.0f;
                }
              }
              break;
            }
            if (__loop_jump_target == 4302) {
              __loop_jump_target = -1;
              continue;
            }
            if (__loop_jump_target != -1) {
              break;
            }
            break;
          }
        } else {
          _4897 = 0.0f;
          _4898 = 0.0f;
          _4899 = 0.0f;
          _4900 = 0.0f;
        }
        if (_4900 > 0.0f) {
          float _4912 = (_4900 * _4218) + _165;
          float _4913 = (_4900 * _4222) + _166;
          float _4914 = (_4900 * _4225) + _167;
          bool _4917 = (_sunDirection.y > 0.0f);
          if ((_4917) || ((!(_4917)) && (_sunDirection.y > _moonDirection.y))) {
            _4929 = _sunDirection.x;
            _4930 = _sunDirection.y;
            _4931 = _sunDirection.z;
          } else {
            _4929 = _moonDirection.x;
            _4930 = _moonDirection.y;
            _4931 = _moonDirection.z;
          }
          if ((_4917) || ((!(_4917)) && (_sunDirection.y > _moonDirection.y))) {
            _4951 = _precomputedAmbient7.y;
          } else {
            _4951 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
          }
          float _4957 = (_earthRadius + _4913) + _viewPos.y;
          float _4961 = (_4914 * _4914) + (_4912 * _4912);
          float _4963 = sqrt((_4957 * _4957) + _4961);
          float _4968 = dot(float3((_4912 / _4963), (_4957 / _4963), (_4914 / _4963)), float3(_4929, _4930, _4931));
          float _4973 = min(max(((_4963 - _earthRadius) / _atmosphereThickness), 16.0f), (_atmosphereThickness + -16.0f));
          float _4981 = max(_4973, 0.0f);
          float _4988 = (-0.0f - sqrt((_4981 + (_earthRadius * 2.0f)) * _4981)) / (_4981 + _earthRadius);
          if (_4968 > _4988) {
            _5011 = ((exp2(log2(saturate((_4968 - _4988) / (1.0f - _4988))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _5011 = ((exp2(log2(saturate((_4988 - _4968) / (_4988 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float2 _5016 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_4973 + -16.0f) / (_atmosphereThickness + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _5011), 0.0f);
          float _5038 = ((_5016.y * 1.9999999494757503e-05f) * _mieAerosolDensity) * (_mieAerosolAbsorption + 1.0f);
          float _5056 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f)) * _5016.x) + _5038) * -1.4426950216293335f);
          float _5057 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f)) * _5016.x) + _5038) * -1.4426950216293335f);
          float _5058 = exp2(((((_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f)) * _5016.x) + _5038) * -1.4426950216293335f);
          float _5074 = sqrt(_4961);
          float _5082 = (_cloudAltitude - (max(((_5074 * _5074) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
          float _5094 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_4930 > 0.0f))) - ((int)(uint)((int)(_4930 < 0.0f))))) * 0.5f))) + _5082;
          if (_4913 < _5082) {
            float _5097 = dot(float3(0.0f, 1.0f, 0.0f), float3(_4929, _4930, _4931));
            float _5103 = select((abs(_5097) < 9.99999993922529e-09f), 1e+08f, ((_5094 - dot(float3(0.0f, 1.0f, 0.0f), float3(_4912, _4913, _4914))) / _5097));
            _5109 = ((_5103 * _4929) + _4912);
            _5110 = _5094;
            _5111 = ((_5103 * _4931) + _4914);
          } else {
            _5109 = _4912;
            _5110 = _4913;
            _5111 = _4914;
          }
          float _5120 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_5109 * 4.999999873689376e-05f) + 0.5f), ((_5110 - _5082) / _cloudThickness), ((_5111 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
          float _5131 = saturate(abs(_4930) * 4.0f);
          float _5133 = (_5131 * _5131) * exp2(((_distanceScale * -1.4426950216293335f) * _5120.x) * (_cloudScatteringCoefficient / _distanceScale));
          float _5140 = ((1.0f - _5133) * saturate(((_4913 - _cloudThickness) - _5082) * 0.10000000149011612f)) + _5133;
          float _5141 = _5140 * (((_5057 * 0.3395099937915802f) + (_5056 * 0.6131200194358826f)) + (_5058 * 0.047370001673698425f));
          float _5142 = _5140 * (((_5057 * 0.9163600206375122f) + (_5056 * 0.07020000368356705f)) + (_5058 * 0.013450000435113907f));
          float _5143 = _5140 * (((_5057 * 0.10958000272512436f) + (_5056 * 0.02061999961733818f)) + (_5058 * 0.8697999715805054f));
          float _5168 = (_viewPos.x - (_staticShadowPosition[1].x)) + _4912;
          float _5169 = (_viewPos.y - (_staticShadowPosition[1].y)) + _4913;
          float _5170 = (_viewPos.z - (_staticShadowPosition[1].z)) + _4914;
          float _5190 = mad((_shadowProjRelativeTexScale[1][0].z), _5170, mad((_shadowProjRelativeTexScale[1][0].y), _5169, (_5168 * (_shadowProjRelativeTexScale[1][0].x)))) + (_shadowProjRelativeTexScale[1][0].w);
          float _5194 = mad((_shadowProjRelativeTexScale[1][1].z), _5170, mad((_shadowProjRelativeTexScale[1][1].y), _5169, (_5168 * (_shadowProjRelativeTexScale[1][1].x)))) + (_shadowProjRelativeTexScale[1][1].w);
          float _5201 = 2.0f / _shadowSizeAndInvSize.y;
          float _5202 = 1.0f - _5201;
          bool _5209 = ((((((!(_5190 <= _5202))) || ((!(_5190 >= _5201))))) || ((!(_5194 <= _5202))))) || ((!(_5194 >= _5201)));
          float _5221 = (_viewPos.x - (_staticShadowPosition[0].x)) + _4912;
          float _5222 = (_viewPos.y - (_staticShadowPosition[0].y)) + _4913;
          float _5223 = (_viewPos.z - (_staticShadowPosition[0].z)) + _4914;
          float _5243 = mad((_shadowProjRelativeTexScale[0][0].z), _5223, mad((_shadowProjRelativeTexScale[0][0].y), _5222, (_5221 * (_shadowProjRelativeTexScale[0][0].x)))) + (_shadowProjRelativeTexScale[0][0].w);
          float _5247 = mad((_shadowProjRelativeTexScale[0][1].z), _5223, mad((_shadowProjRelativeTexScale[0][1].y), _5222, (_5221 * (_shadowProjRelativeTexScale[0][1].x)))) + (_shadowProjRelativeTexScale[0][1].w);
          bool _5258 = ((((((!(_5243 <= _5202))) || ((!(_5243 >= _5201))))) || ((!(_5247 <= _5202))))) || ((!(_5247 >= _5201)));
          int _5259 = select(_5258, select(_5209, -1, 1), 0);
          float _5260 = select(_5258, select(_5209, 0.0f, _5190), _5243);
          float _5261 = select(_5258, select(_5209, 0.0f, _5194), _5247);
          float _5262 = select(_5258, select(_5209, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _5170, mad((_shadowProjRelativeTexScale[1][2].y), _5169, (_5168 * (_shadowProjRelativeTexScale[1][2].x)))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _5223, mad((_shadowProjRelativeTexScale[0][2].y), _5222, (_5221 * (_shadowProjRelativeTexScale[0][2].x)))) + (_shadowProjRelativeTexScale[0][2].w)));
          float _5264 = select(((_5258) && (_5209)), 0.0f, 0.0010000000474974513f);
          [branch]
          if (!(_5259 == -1)) {
            float _5270 = (_5260 * _shadowSizeAndInvSize.x) + -0.5f;
            float _5271 = (_5261 * _shadowSizeAndInvSize.y) + -0.5f;
            int _5274 = int(floor(_5270));
            int _5275 = int(floor(_5271));
            if (!((((uint)_5274 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_5275 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
              float4 _5285 = __3__36__0__0__g_shadowDepthArray.Load(int4(_5274, _5275, _5259, 0));
              float4 _5287 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_5274) + 1u)), _5275, _5259, 0));
              float4 _5289 = __3__36__0__0__g_shadowDepthArray.Load(int4(_5274, ((int)((uint)(_5275) + 1u)), _5259, 0));
              float4 _5291 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_5274) + 1u)), ((int)((uint)(_5275) + 1u)), _5259, 0));
              _5294 = _5285.x;
              _5295 = _5287.x;
              _5296 = _5289.x;
              _5297 = _5291.x;
            } else {
              _5294 = 0.0f;
              _5295 = 0.0f;
              _5296 = 0.0f;
              _5297 = 0.0f;
            }
            float _5323 = (float4(_invShadowViewProj[_5259][0][0], _invShadowViewProj[_5259][1][0], _invShadowViewProj[_5259][2][0], _invShadowViewProj[_5259][3][0]).x) * _5260;
            float _5327 = (float4(_invShadowViewProj[_5259][0][0], _invShadowViewProj[_5259][1][0], _invShadowViewProj[_5259][2][0], _invShadowViewProj[_5259][3][0]).y) * _5260;
            float _5331 = (float4(_invShadowViewProj[_5259][0][0], _invShadowViewProj[_5259][1][0], _invShadowViewProj[_5259][2][0], _invShadowViewProj[_5259][3][0]).z) * _5260;
            float _5335 = (float4(_invShadowViewProj[_5259][0][0], _invShadowViewProj[_5259][1][0], _invShadowViewProj[_5259][2][0], _invShadowViewProj[_5259][3][0]).w) * _5260;
            float _5338 = mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).w), _5294, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).w), _5261, _5335)) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).w);
            float _5339 = (mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).x), _5294, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).x), _5261, _5323)) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).x)) / _5338;
            float _5340 = (mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).y), _5294, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).y), _5261, _5327)) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).y)) / _5338;
            float _5341 = (mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).z), _5294, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).z), _5261, _5331)) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).z)) / _5338;
            float _5344 = _5260 + (_shadowSizeAndInvSize.z * 4.0f);
            float _5360 = mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).w), _5295, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).w), _5261, ((float4(_invShadowViewProj[_5259][0][0], _invShadowViewProj[_5259][1][0], _invShadowViewProj[_5259][2][0], _invShadowViewProj[_5259][3][0]).w) * _5344))) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).w);
            float _5366 = _5261 - (_shadowSizeAndInvSize.w * 2.0f);
            float _5378 = mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).w), _5296, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).w), _5366, _5335)) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).w);
            float _5382 = ((mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).x), _5296, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).x), _5366, _5323)) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).x)) / _5378) - _5339;
            float _5383 = ((mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).y), _5296, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).y), _5366, _5327)) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).y)) / _5378) - _5340;
            float _5384 = ((mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).z), _5296, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).z), _5366, _5331)) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).z)) / _5378) - _5341;
            float _5385 = ((mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).x), _5295, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).x), _5261, ((float4(_invShadowViewProj[_5259][0][0], _invShadowViewProj[_5259][1][0], _invShadowViewProj[_5259][2][0], _invShadowViewProj[_5259][3][0]).x) * _5344))) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).x)) / _5360) - _5339;
            float _5386 = ((mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).y), _5295, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).y), _5261, ((float4(_invShadowViewProj[_5259][0][0], _invShadowViewProj[_5259][1][0], _invShadowViewProj[_5259][2][0], _invShadowViewProj[_5259][3][0]).y) * _5344))) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).y)) / _5360) - _5340;
            float _5387 = ((mad((float4(_invShadowViewProj[_5259][0][2], _invShadowViewProj[_5259][1][2], _invShadowViewProj[_5259][2][2], _invShadowViewProj[_5259][3][2]).z), _5295, mad((float4(_invShadowViewProj[_5259][0][1], _invShadowViewProj[_5259][1][1], _invShadowViewProj[_5259][2][1], _invShadowViewProj[_5259][3][1]).z), _5261, ((float4(_invShadowViewProj[_5259][0][0], _invShadowViewProj[_5259][1][0], _invShadowViewProj[_5259][2][0], _invShadowViewProj[_5259][3][0]).z) * _5344))) + (float4(_invShadowViewProj[_5259][0][3], _invShadowViewProj[_5259][1][3], _invShadowViewProj[_5259][2][3], _invShadowViewProj[_5259][3][3]).z)) / _5360) - _5341;
            float _5390 = (_5384 * _5386) - (_5383 * _5387);
            float _5393 = (_5382 * _5387) - (_5384 * _5385);
            float _5396 = (_5383 * _5385) - (_5382 * _5386);
            float _5398 = rsqrt(dot(float3(_5390, _5393, _5396), float3(_5390, _5393, _5396)));
            float _5402 = frac(_5270);
            float _5407 = (saturate(dot(float3(_4218, _4222, _4225), float3((_5390 * _5398), (_5393 * _5398), (_5396 * _5398)))) * 0.0020000000949949026f) + _5262;
            float _5420 = saturate(exp2((_5294 - _5407) * 1442695.0f));
            float _5422 = saturate(exp2((_5296 - _5407) * 1442695.0f));
            float _5428 = ((saturate(exp2((_5295 - _5407) * 1442695.0f)) - _5420) * _5402) + _5420;
            _5435 = _5294;
            _5436 = _5295;
            _5437 = _5296;
            _5438 = _5297;
            _5439 = saturate((((_5422 - _5428) + ((saturate(exp2((_5297 - _5407) * 1442695.0f)) - _5422) * _5402)) * frac(_5271)) + _5428);
          } else {
            _5435 = 0.0f;
            _5436 = 0.0f;
            _5437 = 0.0f;
            _5438 = 0.0f;
            _5439 = 1.0f;
          }
          float _5459 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _4914, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _4913, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _4912))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
          float _5463 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _4914, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _4913, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _4912))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
          float _5467 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _4914, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _4913, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _4912))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
          float _5470 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
          float _5471 = 1.0f - _5470;
          if (!(((((!(_5459 <= _5471))) || ((!(_5459 >= _5470))))) || ((!(_5463 <= _5471))))) {
            bool _5482 = ((_5467 >= -1.0f)) && ((((_5467 <= 1.0f)) && ((_5463 >= _5470))));
            _5490 = ((int)(uint)((int)(_5482)));
            _5491 = select(_5482, 1, _5259);
            _5492 = select(_5482, _5459, _5260);
            _5493 = select(_5482, _5463, _5261);
            _5494 = select(_5482, _5467, _5262);
            _5495 = select(_5482, 9.999999747378752e-06f, _5264);
          } else {
            _5490 = 0;
            _5491 = _5259;
            _5492 = _5260;
            _5493 = _5261;
            _5494 = _5262;
            _5495 = _5264;
          }
          float _5515 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _4914, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _4913, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _4912))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
          float _5519 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _4914, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _4913, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _4912))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
          float _5523 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _4914, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _4913, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _4912))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
          if (!(((((!(_5515 <= _5471))) || ((!(_5515 >= _5470))))) || ((!(_5519 <= _5471))))) {
            bool _5534 = ((_5523 >= -1.0f)) && ((((_5519 >= _5470)) && ((_5523 <= 1.0f))));
            _5542 = select(_5534, 1, _5490);
            _5543 = select(_5534, 0, _5491);
            _5544 = select(_5534, _5515, _5492);
            _5545 = select(_5534, _5519, _5493);
            _5546 = select(_5534, _5523, _5494);
            _5547 = select(_5534, 9.999999747378752e-06f, _5495);
          } else {
            _5542 = _5490;
            _5543 = _5491;
            _5544 = _5492;
            _5545 = _5493;
            _5546 = _5494;
            _5547 = _5495;
          }
          [branch]
          if (!(_5542 == 0)) {
            int _5557 = int(floor((_5544 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
            int _5558 = int(floor((_5545 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
            if (!((((uint)_5557 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_5558 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
              float4 _5568 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_5557, _5558, _5543, 0));
              float4 _5570 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_5557) + 1u)), _5558, _5543, 0));
              float4 _5572 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_5557, ((int)((uint)(_5558) + 1u)), _5543, 0));
              float4 _5574 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_5557) + 1u)), ((int)((uint)(_5558) + 1u)), _5543, 0));
              _5577 = _5568.x;
              _5578 = _5570.x;
              _5579 = _5572.x;
              _5580 = _5574.x;
            } else {
              _5577 = _5435;
              _5578 = _5436;
              _5579 = _5437;
              _5580 = _5438;
            }
            if ((_4917) || ((!(_4917)) && (_sunDirection.y > _moonDirection.y))) {
              _5592 = _sunDirection.x;
              _5593 = _sunDirection.y;
              _5594 = _sunDirection.z;
            } else {
              _5592 = _moonDirection.x;
              _5593 = _moonDirection.y;
              _5594 = _moonDirection.z;
            }
            float _5600 = (_5547 - (saturate(-0.0f - dot(float3(_5592, _5593, _5594), float3(_4218, _4222, _4225))) * 9.999999747378752e-05f)) + _5546;
            _5613 = min(float((bool)(uint)(_5577 > _5600)), min(min(float((bool)(uint)(_5578 > _5600)), float((bool)(uint)(_5579 > _5600))), float((bool)(uint)(_5580 > _5600))));
          } else {
            _5613 = _5439;
          }
          float _5621 = (_viewPos.x - _shadowRelativePosition.x) + _4912;
          float _5622 = (_viewPos.y - _shadowRelativePosition.y) + _4913;
          float _5623 = (_viewPos.z - _shadowRelativePosition.z) + _4914;
          float _5643 = mad((_terrainShadowProjRelativeTexScale[0].z), _5623, mad((_terrainShadowProjRelativeTexScale[0].y), _5622, (_5621 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
          float _5647 = mad((_terrainShadowProjRelativeTexScale[1].z), _5623, mad((_terrainShadowProjRelativeTexScale[1].y), _5622, (_5621 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
          float _5651 = mad((_terrainShadowProjRelativeTexScale[2].z), _5623, mad((_terrainShadowProjRelativeTexScale[2].y), _5622, (_5621 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
          if (saturate(_5643) == _5643) {
            if (((_5651 >= 9.999999747378752e-05f)) && ((((_5651 <= 1.0f)) && ((saturate(_5647) == _5647))))) {
              float _5666 = frac((_5643 * 1024.0f) + -0.5f);
              float4 _5670 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_5643, _5647));
              float _5675 = _5651 + -0.004999999888241291f;
              float _5680 = select((_5670.w > _5675), 1.0f, 0.0f);
              float _5682 = select((_5670.x > _5675), 1.0f, 0.0f);
              float _5689 = ((select((_5670.z > _5675), 1.0f, 0.0f) - _5680) * _5666) + _5680;
              _5695 = saturate((((((select((_5670.y > _5675), 1.0f, 0.0f) - _5682) * _5666) + _5682) - _5689) * frac((_5647 * 1024.0f) + -0.5f)) + _5689);
            } else {
              _5695 = 1.0f;
            }
          } else {
            _5695 = 1.0f;
          }
          float _5698 = _4900 * 20.0f;
          float _5699 = _5698 * _5698;
          float _5708 = (((exp2(_5699 * -0.48089835047721863f) * 3.0f) + exp2(_5699 * -1.4426950216293335f)) * 0.25f) * (saturate(min(_5613, _5695)) * _4951);
          _5713 = (_5708 * (((_5141 * 0.6131200194358826f) + (_5142 * 0.3395099937915802f)) + (_5143 * 0.047370001673698425f)));
          _5714 = (_5708 * (((_5141 * 0.07020000368356705f) + (_5142 * 0.9163600206375122f)) + (_5143 * 0.013450000435113907f)));
          _5715 = (_5708 * (((_5141 * 0.02061999961733818f) + (_5142 * 0.10958000272512436f)) + (_5143 * 0.8697999715805054f)));
        } else {
          _5713 = -0.0f;
          _5714 = -0.0f;
          _5715 = -0.0f;
        }
        float _5721 = saturate(1.0f - (_170 * 0.0010000000474974513f));
        _5729 = ((_5721 * (_5713 - min(0.0f, (-0.0f - _4897)))) + _4127);
        _5730 = ((_5721 * (_5714 - min(0.0f, (-0.0f - _4898)))) + _4128);
        _5731 = (((_5715 - min(0.0f, (-0.0f - _4899))) * _5721) + _4129);
        break;
      }
    } else {
      _5729 = _4127;
      _5730 = _4128;
      _5731 = _4129;
    }
    // RenoDX: Exterior GI energy compensation
    // The improved ReSTIR convergence over accumulates diffuse bounces.
    // Exteriors become way to bright so as a solution we do the following
    //
    // Apply a luminance based soft compression on the raw hit radiance before it
    // enters the reservoir
    if (RT_QUALITY >= 1.f && RT_GI_STRENGTH > 0.0f) {
      float _rndx_gi_lum = renodx::color::y::from::BT709(float3(_5729, _5730, _5731));
      if (_rndx_gi_lum > RT_GI_KNEE) {
        float _rndx_gi_excess = _rndx_gi_lum - RT_GI_KNEE;
        float _rndx_gi_compressed = RT_GI_KNEE + renodx::math::DivideSafe(_rndx_gi_excess, mad(_rndx_gi_excess, RT_GI_STRENGTH, 1.0f));
        float _rndx_gi_scale = renodx::math::DivideSafe(_rndx_gi_compressed, _rndx_gi_lum, 1.f);
        _5729 *= _rndx_gi_scale;
        _5730 *= _rndx_gi_scale;
        _5731 *= _rndx_gi_scale;
      }
    }
    __3__38__0__1__g_diffuseResultUAV[int2(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)))] = half4((-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _5729)))))), (-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _5730)))))), (-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _5731)))))), half(1.0f - _4081));
    break;
  }
}