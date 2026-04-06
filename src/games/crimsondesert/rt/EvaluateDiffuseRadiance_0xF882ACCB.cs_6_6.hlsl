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

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t79, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaque : register(t49, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaquePrev : register(t94, space36);

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
  int _40[4];
  int _53 = (int)(SV_GroupID.x) & 3;
  int _54 = (uint)((uint)(_53)) >> 1;
  _40[0] = ((g_tileIndex[(SV_GroupID.x) >> 4]).x);
  _40[1] = ((g_tileIndex[(SV_GroupID.x) >> 4]).y);
  _40[2] = ((g_tileIndex[(SV_GroupID.x) >> 4]).z);
  _40[3] = ((g_tileIndex[(SV_GroupID.x) >> 4]).w);
  int _72 = _40[(((uint)(SV_GroupID.x) >> 2) & 3)];
  float _81 = float((uint)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4))));
  float _82 = float((uint)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5))));
  float _95 = ((_bufferSizeAndInvSize.z * 2.0f) * (_81 + 0.5f)) + -1.0f;
  float _98 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (_82 + 0.5f));
  uint _104 = __3__36__0__0__g_depthOpaque.Load(int3(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))), 0));
  int _110 = ((uint)((uint)(_104.x)) >> 24) & 127;
  uint _112 = __3__36__0__0__g_sceneNormal.Load(int3(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))), 0));
  float _128 = min(1.0f, ((float((uint)((uint)(_112.x & 1023))) * 0.001956947147846222f) + -1.0f));
  float _129 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_112.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _130 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_112.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _132 = rsqrt(dot(float3(_128, _129, _130), float3(_128, _129, _130)));
  float _133 = _132 * _128;
  float _134 = _132 * _129;
  float _135 = _132 * _130;
  float _136 = max(1.0000000116860974e-07f, (float((uint)((uint)(_104.x & 16777215))) * 5.960465188081798e-08f));
  float _172 = mad((_invViewProjRelative[3].z), _136, mad((_invViewProjRelative[3].y), _98, ((_invViewProjRelative[3].x) * _95))) + (_invViewProjRelative[3].w);
  float _173 = (mad((_invViewProjRelative[0].z), _136, mad((_invViewProjRelative[0].y), _98, ((_invViewProjRelative[0].x) * _95))) + (_invViewProjRelative[0].w)) / _172;
  float _174 = (mad((_invViewProjRelative[1].z), _136, mad((_invViewProjRelative[1].y), _98, ((_invViewProjRelative[1].x) * _95))) + (_invViewProjRelative[1].w)) / _172;
  float _175 = (mad((_invViewProjRelative[2].z), _136, mad((_invViewProjRelative[2].y), _98, ((_invViewProjRelative[2].x) * _95))) + (_invViewProjRelative[2].w)) / _172;
  float _178 = _nearFarProj.x / _136;
  float _184 = float((uint)((uint)(((int)(((uint)((uint)(_frameNumber.x)) >> 2) * 71)) & 31)));
  bool _201;
  int _254;
  int _312;
  int _333;
  int _396;
  int _397;
  int _398;
  int _399;
  float _456;
  float _457;
  float _458;
  float _459;
  float _460;
  float _461;
  float _462;
  int _463;
  float _675;
  float _676;
  float _677;
  float _678;
  float _695;
  float _696;
  float _697;
  float _737;
  float _738;
  float _739;
  float _746;
  float _747;
  float _748;
  float _749;
  float _750;
  float _751;
  float _752;
  float _753;
  int _754;
  float _755;
  float _756;
  float _757;
  float _758;
  float _759;
  bool _774;
  float _945;
  float _946;
  float _947;
  float _948;
  float _959;
  float _960;
  float _961;
  float _962;
  float _963;
  float _964;
  float _965;
  float _966;
  float _967;
  int _968;
  int _970;
  int _1031;
  int _1032;
  float _1039;
  float _1099;
  float _1100;
  float _1101;
  float _1102;
  int _1108;
  int _1166;
  int _1203;
  float _1204;
  float _1205;
  float _1206;
  float _1207;
  float _1208;
  int _1210;
  float _1427;
  float _1428;
  float _1447;
  float _1448;
  float _1449;
  float _1450;
  float _1451;
  float _1453;
  float _1454;
  float _1455;
  float _1456;
  float _1457;
  float _1458;
  int _1475;
  int _1538;
  int _1539;
  int _1540;
  int _1541;
  int _1557;
  int _1558;
  int _1559;
  int _1560;
  int _1566;
  int _1629;
  int _1630;
  int _1631;
  int _1632;
  int _1637;
  int _1638;
  int _1639;
  int _1640;
  int _1641;
  int _1644;
  int _1645;
  int _1646;
  int _1647;
  int _1650;
  int _1651;
  int _1652;
  int _1653;
  int _1654;
  bool _1677;
  int _1678;
  int _1679;
  int _1680;
  int _1681;
  int _1682;
  int _1691;
  int _1692;
  int _1693;
  int _1694;
  int _1695;
  float _1754;
  float _1755;
  float _1756;
  float _1757;
  int _1758;
  float _1959;
  float _1960;
  float _1961;
  float _1962;
  float _1979;
  float _1980;
  float _1981;
  float _1982;
  float _2010;
  float _2011;
  float _2012;
  float _2013;
  float _2014;
  bool _2028;
  float _2051;
  float _2052;
  float _2053;
  float _2054;
  float _2136;
  float _2137;
  float _2138;
  float _2281;
  float _2282;
  float _2283;
  float _2284;
  half _2285;
  half _2286;
  half _2287;
  half _2288;
  float _2426;
  float _2427;
  float _2428;
  float _2429;
  float _2430;
  float _2431;
  float _2432;
  float _2433;
  half _2434;
  half _2435;
  half _2436;
  half _2437;
  float _2488;
  float _2489;
  float _2490;
  float _2491;
  int _2492;
  int _2493;
  float _2540;
  float _2541;
  float _2542;
  float _2543;
  int _2544;
  int _2545;
  float _2575;
  float _2576;
  float _2577;
  float _2578;
  float _2697;
  float _2698;
  float _2699;
  float _2718;
  float _2719;
  float _2720;
  float _2721;
  float _2803;
  float _2838;
  float _2839;
  float _2840;
  float _2860;
  float _2917;
  float _3015;
  float _3016;
  float _3017;
  float _3085;
  float _3086;
  float _3087;
  float _3088;
  half _3089;
  half _3090;
  half _3091;
  float _3092;
  float _3093;
  float _3094;
  float _3095;
  float _3096;
  float _3228;
  float _3229;
  float _3230;
  float _3334;
  float _3335;
  float _3336;
  float _3337;
  float _3475;
  float _3476;
  float _3477;
  float _3478;
  float _3479;
  float _3510;
  float _3511;
  float _3512;
  float _3513;
  int _3514;
  int _3515;
  float _3546;
  float _3547;
  float _3548;
  float _3549;
  int _3550;
  int _3551;
  float _3581;
  float _3582;
  float _3583;
  float _3584;
  float _3596;
  float _3597;
  float _3598;
  float _3617;
  float _3676;
  float _3733;
  float _3785;
  float _3851;
  float _3852;
  float _3853;
  float _3906;
  float _3907;
  float _3908;
  float _3928;
  float _3929;
  float _3930;
  float _3931;
  int _3942;
  int _4000;
  float _4041;
  float _4067;
  float _4068;
  float _4069;
  float _4126;
  float _4127;
  float _4128;
  bool _4158;
  int _4159;
  int _4160;
  int _4161;
  int _4162;
  int _4163;
  if (!((uint)_110 > (uint)11) | !((((uint)_110 < (uint)20)) || ((_110 == 107)))) {
    _201 = (_110 == 20);
  } else {
    _201 = true;
  }
  float4 _203 = __3__38__0__1__g_raytracingHitResultUAV.Load(int2(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5))))));
  float _209 = rsqrt(dot(float3(_203.x, _203.y, _203.z), float3(_203.x, _203.y, _203.z)));
  float _210 = _209 * _203.x;
  float _211 = _209 * _203.y;
  float _212 = _209 * _203.z;
  bool _213 = (_203.w < 0.0f);
  float _214 = abs(_203.w);
  if (((_214 > 0.0f)) && ((_214 < 10000.0f))) {
    float4 _220 = __3__36__0__0__g_raytracingBaseColor.Load(int3(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))), 0));
    float4 _226 = __3__36__0__0__g_raytracingNormal.Load(int3(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))), 0));
    float _234 = (_226.x * 2.0f) + -1.0f;
    float _235 = (_226.y * 2.0f) + -1.0f;
    float _236 = (_226.z * 2.0f) + -1.0f;
    float _238 = rsqrt(dot(float3(_234, _235, _236), float3(_234, _235, _236)));
    float _239 = _234 * _238;
    float _240 = _235 * _238;
    float _241 = _236 * _238;
    float _242 = select(_213, 0.0f, _239);
    float _243 = select(_213, 0.0f, _240);
    float _244 = select(_213, 0.0f, _241);
    int _246 = (int)(uint)((int)(_220.w > 0.0f));
    float _247 = _210 * _214;
    float _248 = _211 * _214;
    float _249 = _212 * _214;
    float _250 = _247 + _173;
    float _251 = _248 + _174;
    float _252 = _249 + _175;
    _254 = 0;
    while(true) {
      int _294 = int(floor(((_wrappedViewPos.x + _250) * ((_clipmapOffsets[_254]).w)) + ((_clipmapRelativeIndexOffsets[_254]).x)));
      int _295 = int(floor(((_wrappedViewPos.y + _251) * ((_clipmapOffsets[_254]).w)) + ((_clipmapRelativeIndexOffsets[_254]).y)));
      int _296 = int(floor(((_wrappedViewPos.z + _252) * ((_clipmapOffsets[_254]).w)) + ((_clipmapRelativeIndexOffsets[_254]).z)));
      if (!((((((((int)_294 >= (int)int(((_clipmapOffsets[_254]).x) + -63.0f))) && (((int)_294 < (int)int(((_clipmapOffsets[_254]).x) + 63.0f))))) && (((((int)_295 >= (int)int(((_clipmapOffsets[_254]).y) + -31.0f))) && (((int)_295 < (int)int(((_clipmapOffsets[_254]).y) + 31.0f))))))) && (((((int)_296 >= (int)int(((_clipmapOffsets[_254]).z) + -63.0f))) && (((int)_296 < (int)int(((_clipmapOffsets[_254]).z) + 63.0f))))))) {
        if ((uint)(_254 + 1) < (uint)8) {
          _254 = (_254 + 1);
          continue;
        } else {
          _312 = -10000;
        }
      } else {
        _312 = _254;
      }
      float _319 = -0.0f - _210;
      float _320 = -0.0f - _211;
      float _321 = -0.0f - _212;
      float _325 = min(_214, (float((int)((int)(1u << (_312 & 31)))) * _voxelParams.x));
      _333 = 0;
      while(true) {
        int _373 = int(floor(((((_325 * select(_213, _319, _239)) + _250) + _wrappedViewPos.x) * ((_clipmapOffsets[_333]).w)) + ((_clipmapRelativeIndexOffsets[_333]).x)));
        int _374 = int(floor(((((_325 * select(_213, _320, _240)) + _251) + _wrappedViewPos.y) * ((_clipmapOffsets[_333]).w)) + ((_clipmapRelativeIndexOffsets[_333]).y)));
        int _375 = int(floor(((((_325 * select(_213, _321, _241)) + _252) + _wrappedViewPos.z) * ((_clipmapOffsets[_333]).w)) + ((_clipmapRelativeIndexOffsets[_333]).z)));
        if ((((((((int)_373 >= (int)int(((_clipmapOffsets[_333]).x) + -63.0f))) && (((int)_373 < (int)int(((_clipmapOffsets[_333]).x) + 63.0f))))) && (((((int)_374 >= (int)int(((_clipmapOffsets[_333]).y) + -31.0f))) && (((int)_374 < (int)int(((_clipmapOffsets[_333]).y) + 31.0f))))))) && (((((int)_375 >= (int)int(((_clipmapOffsets[_333]).z) + -63.0f))) && (((int)_375 < (int)int(((_clipmapOffsets[_333]).z) + 63.0f)))))) {
          _396 = (_373 & 127);
          _397 = (_374 & 63);
          _398 = (_375 & 127);
          _399 = _333;
        } else {
          if ((uint)(_333 + 1) < (uint)8) {
            _333 = (_333 + 1);
            continue;
          } else {
            _396 = -10000;
            _397 = -10000;
            _398 = -10000;
            _399 = -10000;
          }
        }
        if (((_399 != -10000)) && (((int)_399 < (int)4))) {
          if ((uint)_399 < (uint)6) {
            uint _406 = _399 * 130;
            uint _410 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_396, _397, ((int)(((uint)((int)(_406) | 1)) + (uint)(_398))), 0));
            int _412 = _410.x & 4194303;
            [branch]
            if (!(_412 == 0)) {
              float _418 = float((int)((int)(1u << (_399 & 31)))) * _voxelParams.x;
              _456 = 0.0f;
              _457 = 0.0f;
              _458 = 0.0f;
              _459 = _242;
              _460 = _243;
              _461 = _244;
              _462 = 0.0f;
              _463 = 0;
              while(true) {
                int _468 = __3__37__0__0__g_surfelDataBuffer[((_412 + -1) + _463)]._baseColor;
                int _470 = __3__37__0__0__g_surfelDataBuffer[((_412 + -1) + _463)]._normal;
                int16_t _473 = __3__37__0__0__g_surfelDataBuffer[((_412 + -1) + _463)]._radius;
                if (!(_468 == 0)) {
                  half _476 = __3__37__0__0__g_surfelDataBuffer[((_412 + -1) + _463)]._radiance.z;
                  half _477 = __3__37__0__0__g_surfelDataBuffer[((_412 + -1) + _463)]._radiance.y;
                  half _478 = __3__37__0__0__g_surfelDataBuffer[((_412 + -1) + _463)]._radiance.x;
                  float _484 = float((uint)((uint)(_468 & 255)));
                  float _485 = float((uint)((uint)(((uint)((uint)(_468)) >> 8) & 255)));
                  float _486 = float((uint)((uint)(((uint)((uint)(_468)) >> 16) & 255)));
                  float _511 = select(((_484 * 0.003921568859368563f) < 0.040449999272823334f), (_484 * 0.0003035269910469651f), exp2(log2((_484 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _512 = select(((_485 * 0.003921568859368563f) < 0.040449999272823334f), (_485 * 0.0003035269910469651f), exp2(log2((_485 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _513 = select(((_486 * 0.003921568859368563f) < 0.040449999272823334f), (_486 * 0.0003035269910469651f), exp2(log2((_486 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _525 = (float((uint)((uint)(_470 & 255))) * 0.007874015718698502f) + -1.0f;
                  float _526 = (float((uint)((uint)(((uint)((uint)(_470)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                  float _527 = (float((uint)((uint)(((uint)((uint)(_470)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                  float _529 = rsqrt(dot(float3(_525, _526, _527), float3(_525, _526, _527)));
                  bool _534 = ((_470 & 16777215) == 0);
                  float _538 = float(_478);
                  float _539 = float(_477);
                  float _540 = float(_476);
                  float _544 = (_418 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_473) & 255)));
                  float _560 = (((float((uint)((uint)((uint)((uint)(_468)) >> 24))) * 0.003937007859349251f) + -0.5f) * _418) + ((((((_clipmapOffsets[_399]).x) + -63.5f) + float((int)(((int)(((uint)(_396 + 64)) - (uint)(int((_clipmapOffsets[_399]).x)))) & 127))) * _418) - _viewPos.x);
                  float _561 = (((float((uint)((uint)((uint)((uint)(_470)) >> 24))) * 0.003937007859349251f) + -0.5f) * _418) + ((((((_clipmapOffsets[_399]).y) + -31.5f) + float((int)(((int)(((uint)(_397 + 32)) - (uint)(int((_clipmapOffsets[_399]).y)))) & 63))) * _418) - _viewPos.y);
                  float _562 = (((float((uint16_t)((uint)((uint16_t)((uint)(_473)) >> 8))) * 0.003937007859349251f) + -0.5f) * _418) + ((((((_clipmapOffsets[_399]).z) + -63.5f) + float((int)(((int)(((uint)(_398 + 64)) - (uint)(int((_clipmapOffsets[_399]).z)))) & 127))) * _418) - _viewPos.z);
                  bool _580 = (_226.w == 0.0f);
                  float _581 = select(_580, _319, _459);
                  float _582 = select(_580, _320, _460);
                  float _583 = select(_580, _321, _461);
                  float _586 = ((-0.0f - _173) - _247) + _560;
                  float _589 = ((-0.0f - _174) - _248) + _561;
                  float _592 = ((-0.0f - _175) - _249) + _562;
                  float _593 = dot(float3(_586, _589, _592), float3(_581, _582, _583));
                  float _597 = _586 - (_593 * _581);
                  float _598 = _589 - (_593 * _582);
                  float _599 = _592 - (_593 * _583);
                  float _625 = 1.0f / float((uint)(1u << (_399 & 31)));
                  float _629 = frac(((_invClipmapExtent.z * _562) + _clipmapUVRelativeOffset.z) * _625);
                  float _640 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _560) + _clipmapUVRelativeOffset.x) * _625), (((_invClipmapExtent.y * _561) + _clipmapUVRelativeOffset.y) * _625), (((float((uint)_406) + 1.0f) + ((select((_629 < 0.0f), 1.0f, 0.0f) + _629) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                  float _654 = select(((int)_399 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_319, _320, _321), float3(select(_534, _319, (_529 * _525)), select(_534, _320, (_529 * _526)), select(_534, _321, (_529 * _527))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_597, _598, _599), float3(_597, _598, _599)) < ((_544 * _544) * 16.0f)))) * float((bool)(uint)(_640.x > ((_418 * 0.25f) * (saturate((dot(float3(_538, _539, _540), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                  bool _658 = ((!(_220.w > 0.0f))) || (((_468 & 16777215) == 16777215));
                  float _668 = ((select(_658, (((_512 * 0.3395099937915802f) + (_511 * 0.6131200194358826f)) + (_513 * 0.047370001673698425f)), _220.x) * _538) * _654) + _456;
                  float _669 = ((select(_658, (((_512 * 0.9163600206375122f) + (_511 * 0.07020000368356705f)) + (_513 * 0.013450000435113907f)), _220.y) * _539) * _654) + _457;
                  float _670 = ((select(_658, (((_512 * 0.10958000272512436f) + (_511 * 0.02061999961733818f)) + (_513 * 0.8697999715805054f)), _220.z) * _540) * _654) + _458;
                  float _671 = _654 + _462;
                  if ((uint)(_463 + 1) < (uint)4) {
                    _456 = _668;
                    _457 = _669;
                    _458 = _670;
                    _459 = _581;
                    _460 = _582;
                    _461 = _583;
                    _462 = _671;
                    _463 = (_463 + 1);
                    continue;
                  } else {
                    _675 = _668;
                    _676 = _669;
                    _677 = _670;
                    _678 = _671;
                  }
                } else {
                  _675 = _456;
                  _676 = _457;
                  _677 = _458;
                  _678 = _462;
                }
                if (_678 > 0.0f) {
                  float _681 = 1.0f / _678;
                  _695 = (-0.0f - min(0.0f, (-0.0f - (_675 * _681))));
                  _696 = (-0.0f - min(0.0f, (-0.0f - (_676 * _681))));
                  _697 = (-0.0f - min(0.0f, (-0.0f - (_677 * _681))));
                } else {
                  _695 = _675;
                  _696 = _676;
                  _697 = _677;
                }
                break;
              }
            } else {
              _695 = 0.0f;
              _696 = 0.0f;
              _697 = 0.0f;
            }
          } else {
            _695 = 0.0f;
            _696 = 0.0f;
            _697 = 0.0f;
          }
          float _701 = max(9.999999974752427e-07f, (_exposure3.w * 0.0010000000474974513f));
          float _702 = max(_701, _695);
          float _703 = max(_701, _696);
          float _704 = max(_701, _697);
          float _707 = dot(float3(_702, _703, _704), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
          float _708 = min((max(0.0005000000237487257f, _exposure3.w) * 512.0f), _707);
          float _712 = max(9.999999717180685e-10f, _707);
          float _713 = (_708 * _702) / _712;
          float _714 = (_708 * _703) / _712;
          float _715 = (_708 * _704) / _712;
          if (saturate(_226.w) == 0.0f) {
            float _729 = (exp2((saturate(saturate(_220.w)) * 20.0f) + -8.0f) + -0.00390625f) * (1.0f / (((_214 * _214) * 0.10000000149011612f) + 1.0f));
            _737 = ((_729 * _220.x) + _713);
            _738 = ((_729 * _220.y) + _714);
            _739 = ((_729 * _220.z) + _715);
          } else {
            _737 = _713;
            _738 = _714;
            _739 = _715;
          }
          _746 = _242;
          _747 = _243;
          _748 = _244;
          _749 = _226.w;
          _750 = _220.x;
          _751 = _220.y;
          _752 = _220.z;
          _753 = _220.w;
          _754 = _246;
          _755 = (_renderParams2.y * _737);
          _756 = (_renderParams2.y * _738);
          _757 = (_renderParams2.y * _739);
          _758 = 1.0f;
          _759 = _214;
        } else {
          _746 = _242;
          _747 = _243;
          _748 = _244;
          _749 = _226.w;
          _750 = _220.x;
          _751 = _220.y;
          _752 = _220.z;
          _753 = _220.w;
          _754 = _246;
          _755 = 0.0f;
          _756 = 0.0f;
          _757 = 0.0f;
          _758 = 1.0f;
          _759 = _214;
        }
        break;
      }
      break;
    }
  } else {
    _746 = 0.0f;
    _747 = 0.0f;
    _748 = 0.0f;
    _749 = 0.0f;
    _750 = 0.0f;
    _751 = 0.0f;
    _752 = 0.0f;
    _753 = 0.0f;
    _754 = 0;
    _755 = 0.0f;
    _756 = 0.0f;
    _757 = 0.0f;
    _758 = 0.0f;
    _759 = 0.0f;
  }
  bool _761 = (_759 > 0.0f);
  if (((_178 > (_lightingParams.z * 0.875f))) && ((!_761))) {
    _774 = (_178 < (_voxelParams.x * 11585.1259765625f));
  } else {
    _774 = false;
  }
  float _778 = (_759 * _210) + _173;
  float _779 = (_759 * _211) + _174;
  float _780 = (_759 * _212) + _175;
  float _816 = mad((_viewProjRelativePrev[3].z), _780, mad((_viewProjRelativePrev[3].y), _779, ((_viewProjRelativePrev[3].x) * _778))) + (_viewProjRelativePrev[3].w);
  float _819 = (mad((_viewProjRelativePrev[2].z), _780, mad((_viewProjRelativePrev[2].y), _779, ((_viewProjRelativePrev[2].x) * _778))) + (_viewProjRelativePrev[2].w)) / _816;
  float _822 = (((mad((_viewProjRelativePrev[0].z), _780, mad((_viewProjRelativePrev[0].y), _779, ((_viewProjRelativePrev[0].x) * _778))) + (_viewProjRelativePrev[0].w)) / _816) * 0.5f) + 0.5f;
  float _823 = 0.5f - (((mad((_viewProjRelativePrev[1].z), _780, mad((_viewProjRelativePrev[1].y), _779, ((_viewProjRelativePrev[1].x) * _778))) + (_viewProjRelativePrev[1].w)) / _816) * 0.5f);
  bool __defer_773_836 = false;
  if (_213) {
    if (_761) {
      __defer_773_836 = true;
    } else {
      _959 = _759;
      _960 = _746;
      _961 = _747;
      _962 = _748;
      _963 = _749;
      _964 = 0.0f;
      _965 = 0.0f;
      _966 = 0.0f;
      _967 = 0.0f;
      _968 = 0;
    }
  } else {
    if ((_761) && ((((_819 > 0.0f)) && ((((((_822 >= 0.0f)) && ((_822 <= 1.0f)))) && ((((_823 >= 0.0f)) && ((_823 <= 1.0f))))))))) {
      __defer_773_836 = true;
    } else {
      _959 = _759;
      _960 = _746;
      _961 = _747;
      _962 = _748;
      _963 = _749;
      _964 = 0.0f;
      _965 = 0.0f;
      _966 = 0.0f;
      _967 = 0.0f;
      _968 = 0;
    }
  }
  if (__defer_773_836) {
    float _839 = _822 * _bufferSizeAndInvSize.x;
    float _840 = _823 * _bufferSizeAndInvSize.y;
    uint _844 = __3__36__0__0__g_depthOpaquePrev.Load(int3(int(_839), int(_840), 0));
    float _850 = _nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_844.x & 16777215))) * 5.960465188081798e-08f));
    if (((_819 > 0.0f)) && ((((((_822 >= 0.0f)) && ((_822 <= 1.0f)))) && ((((_823 >= 0.0f)) && ((_823 <= 1.0f))))))) {
      if ((((_850 - dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z))) > 0.0f)) && ((abs(_850 - _816) < max(0.5f, (_816 * 0.05000000074505806f))))) {
        float4 _881 = __3__36__0__0__g_sceneColor.SampleLevel(__3__40__0__0__g_samplerClamp, float2(_822, _823), 0.0f);
        if (!(!(_881.w >= 0.0f))) {
          uint _892 = uint(_839);
          uint _893 = uint(_840);
          uint _894 = __3__36__0__0__g_depthOpaque.Load(int3((int)(_892), (int)(_893), 0));
          uint _896 = __3__36__0__0__g_sceneNormal.Load(int3((int)(_892), (int)(_893), 0));
          float _912 = min(1.0f, ((float((uint)((uint)(_896.x & 1023))) * 0.001956947147846222f) + -1.0f));
          float _913 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_896.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _914 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_896.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _916 = rsqrt(dot(float3(_912, _913, _914), float3(_912, _913, _914)));
          float _917 = _916 * _912;
          float _918 = _916 * _913;
          float _919 = _916 * _914;
          float _928 = select((dot(float3((-0.0f - _210), (-0.0f - _211), (-0.0f - _212)), float3(_917, _918, _919)) > 0.20000000298023224f), 1.0f, 0.0f);
          float _930 = saturate(_178 * 0.009999999776482582f);
          float _935 = _nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_894.x & 16777215))) * 5.960465188081798e-08f));
          if (_213) {
            _945 = _917;
            _946 = _918;
            _947 = _919;
            _948 = 0.800000011920929f;
          } else {
            _945 = _746;
            _946 = _747;
            _947 = _748;
            _948 = _749;
          }
          float _949 = _renderParams2.x * _renderParams2.x;
          float _950 = float((bool)(uint)(abs(_nearFarProj.x - _935) < (_935 * 0.5f))) * ((_928 - (_928 * _930)) + _930);
          _959 = ((_759 * 0.9998999834060669f) * _renderParams2.x);
          _960 = _945;
          _961 = _946;
          _962 = _947;
          _963 = _948;
          _964 = ((_950 * min(10000.0f, _881.x)) * _949);
          _965 = ((_950 * min(10000.0f, _881.y)) * _949);
          _966 = ((_950 * min(10000.0f, _881.z)) * _949);
          _967 = _949;
          _968 = 1;
        } else {
          _959 = _759;
          _960 = _746;
          _961 = _747;
          _962 = _748;
          _963 = _749;
          _964 = 0.0f;
          _965 = 0.0f;
          _966 = 0.0f;
          _967 = 0.0f;
          _968 = 0;
        }
      } else {
        _959 = _759;
        _960 = _746;
        _961 = _747;
        _962 = _748;
        _963 = _749;
        _964 = 0.0f;
        _965 = 0.0f;
        _966 = 0.0f;
        _967 = 0.0f;
        _968 = 0;
      }
    } else {
      _959 = _759;
      _960 = _746;
      _961 = _747;
      _962 = _748;
      _963 = _749;
      _964 = 0.0f;
      _965 = 0.0f;
      _966 = 0.0f;
      _967 = 0.0f;
      _968 = 0;
    }
  }
  _970 = 0;
  while(true) {
    int _1010 = int(floor(((_wrappedViewPos.x + _173) * ((_clipmapOffsets[_970]).w)) + ((_clipmapRelativeIndexOffsets[_970]).x)));
    int _1011 = int(floor(((_wrappedViewPos.y + _174) * ((_clipmapOffsets[_970]).w)) + ((_clipmapRelativeIndexOffsets[_970]).y)));
    int _1012 = int(floor(((_wrappedViewPos.z + _175) * ((_clipmapOffsets[_970]).w)) + ((_clipmapRelativeIndexOffsets[_970]).z)));
    if ((((((((int)_1010 >= (int)int(((_clipmapOffsets[_970]).x) + -63.0f))) && (((int)_1010 < (int)int(((_clipmapOffsets[_970]).x) + 63.0f))))) && (((((int)_1011 >= (int)int(((_clipmapOffsets[_970]).y) + -31.0f))) && (((int)_1011 < (int)int(((_clipmapOffsets[_970]).y) + 31.0f))))))) && (((((int)_1012 >= (int)int(((_clipmapOffsets[_970]).z) + -63.0f))) && (((int)_1012 < (int)int(((_clipmapOffsets[_970]).z) + 63.0f)))))) {
      _1031 = (_1010 & 127);
      _1032 = _970;
    } else {
      if ((uint)(_970 + 1) < (uint)8) {
        _970 = (_970 + 1);
        continue;
      } else {
        _1031 = -10000;
        _1032 = -10000;
      }
    }
    if (!(_1031 == -10000)) {
      _1039 = float((int)((int)(1u << (_1032 & 31))));
    } else {
      _1039 = 1.0f;
    }
    float _1045 = select(_201, (((frac(frac(dot(float2(((_184 * 32.665000915527344f) + _81), ((_184 * 11.8149995803833f) + _82)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 2.0f) * _1039) * _voxelParams.x), 0.0f);
    if (_774) {
      float _1047 = _lightingParams.z * 1.3434898853302002f;
      float _1048 = -0.0f - _1047;
      if (((((_175 > _1048)) && ((_175 < _1047)))) && ((((((_173 > _1048)) && ((_173 < _1047)))) && ((((_174 > _1048)) && ((_174 < _1047))))))) {
        float _1061 = 1.0f / _210;
        float _1062 = 1.0f / _211;
        float _1063 = 1.0f / _212;
        float _1067 = _1061 * (_1048 - _173);
        float _1068 = _1062 * (_1048 - _174);
        float _1069 = _1063 * (_1048 - _175);
        float _1073 = _1061 * (_1047 - _173);
        float _1074 = _1062 * (_1047 - _174);
        float _1075 = _1063 * (_1047 - _175);
        float _1085 = min(min(max(_1067, _1073), max(_1068, _1074)), max(_1069, _1075));
        if (((_1085 > 0.0f)) && ((((_1085 >= 0.0f)) && ((max(max(min(_1067, _1073), min(_1068, _1074)), min(_1069, _1075)) <= _1085))))) {
          _1099 = _1085;
          _1100 = ((_1085 * _210) + _173);
          _1101 = ((_1085 * _211) + _174);
          _1102 = ((_1085 * _212) + _175);
        } else {
          _1099 = 0.0f;
          _1100 = _173;
          _1101 = _174;
          _1102 = _175;
        }
      } else {
        _1099 = 0.0f;
        _1100 = _173;
        _1101 = _174;
        _1102 = _175;
      }
      float _1106 = select((((_959 > 0.0f)) && ((_967 >= 1.0f))), _959, 256.0f);
      _1108 = 0;
      while(true) {
        int _1148 = int(floor(((_wrappedViewPos.x + _1100) * ((_clipmapOffsets[_1108]).w)) + ((_clipmapRelativeIndexOffsets[_1108]).x)));
        int _1149 = int(floor(((_wrappedViewPos.y + _1101) * ((_clipmapOffsets[_1108]).w)) + ((_clipmapRelativeIndexOffsets[_1108]).y)));
        int _1150 = int(floor(((_wrappedViewPos.z + _1102) * ((_clipmapOffsets[_1108]).w)) + ((_clipmapRelativeIndexOffsets[_1108]).z)));
        if (!((((((((int)_1148 >= (int)int(((_clipmapOffsets[_1108]).x) + -63.0f))) && (((int)_1148 < (int)int(((_clipmapOffsets[_1108]).x) + 63.0f))))) && (((((int)_1149 >= (int)int(((_clipmapOffsets[_1108]).y) + -31.0f))) && (((int)_1149 < (int)int(((_clipmapOffsets[_1108]).y) + 31.0f))))))) && (((((int)_1150 >= (int)int(((_clipmapOffsets[_1108]).z) + -63.0f))) && (((int)_1150 < (int)int(((_clipmapOffsets[_1108]).z) + 63.0f))))))) {
          if ((uint)(_1108 + 1) < (uint)8) {
            _1108 = (_1108 + 1);
            continue;
          } else {
            _1166 = -10000;
          }
        } else {
          _1166 = _1108;
        }
        if (!(((_1166 == -10000)) || (((int)_1166 > (int)4)))) {
          float _1176 = _1100 + (_1045 * _210);
          float _1177 = _1101 + (_1045 * _211);
          float _1178 = _1102 + (_1045 * _212);
          bool _1182 = (_210 == 0.0f);
          bool _1183 = (_211 == 0.0f);
          bool _1184 = (_212 == 0.0f);
          float _1185 = select(_1182, 0.0f, (1.0f / _210));
          float _1186 = select(_1183, 0.0f, (1.0f / _211));
          float _1187 = select(_1184, 0.0f, (1.0f / _212));
          bool _1188 = (_210 > 0.0f);
          bool _1189 = (_211 > 0.0f);
          bool _1190 = (_212 > 0.0f);
          if (_1106 > 0.0f) {
            _1203 = 0;
            _1204 = 0.0f;
            _1205 = 0.0f;
            _1206 = _1178;
            _1207 = _1177;
            _1208 = _1176;
            while(true) {
              _1210 = 0;
              while(true) {
                float _1235 = ((_wrappedViewPos.x + _1208) * ((_clipmapOffsets[_1210]).w)) + ((_clipmapRelativeIndexOffsets[_1210]).x);
                float _1236 = ((_wrappedViewPos.y + _1207) * ((_clipmapOffsets[_1210]).w)) + ((_clipmapRelativeIndexOffsets[_1210]).y);
                float _1237 = ((_wrappedViewPos.z + _1206) * ((_clipmapOffsets[_1210]).w)) + ((_clipmapRelativeIndexOffsets[_1210]).z);
                bool __defer_1209_1252 = false;
                if (!(((_1237 >= (((_clipmapOffsets[_1210]).z) + -63.0f))) && ((((_1235 >= (((_clipmapOffsets[_1210]).x) + -63.0f))) && ((_1236 >= (((_clipmapOffsets[_1210]).y) + -31.0f)))))) || ((((_1237 >= (((_clipmapOffsets[_1210]).z) + -63.0f))) && ((((_1235 >= (((_clipmapOffsets[_1210]).x) + -63.0f))) && ((_1236 >= (((_clipmapOffsets[_1210]).y) + -31.0f)))))) && (!(((_1237 < (((_clipmapOffsets[_1210]).z) + 63.0f))) && ((((_1235 < (((_clipmapOffsets[_1210]).x) + 63.0f))) && ((_1236 < (((_clipmapOffsets[_1210]).y) + 31.0f))))))))) {
                  __defer_1209_1252 = true;
                } else {
                  if (_1210 == -10000) {
                    _1447 = _1205;
                    _1448 = _1206;
                    _1449 = _1207;
                    _1450 = _1208;
                    _1451 = _1204;
                    _1453 = _1447;
                    _1454 = _1448;
                    _1455 = _1449;
                    _1456 = _1450;
                    _1457 = _1451;
                    _1458 = -10000.0f;
                  } else {
                    float _1260 = float((int)((int)(1u << (_1210 & 31))));
                    float _1261 = _1260 * _voxelParams.x;
                    float _1262 = 1.0f / _1260;
                    float _1263 = _voxelParams.y * 0.0078125f;
                    float _1272 = _1262 * ((_1208 * _1263) + _clipmapUVRelativeOffset.x);
                    float _1273 = _1262 * (((_voxelParams.y * 0.015625f) * _1207) + _clipmapUVRelativeOffset.y);
                    float _1274 = _1262 * ((_1206 * _1263) + _clipmapUVRelativeOffset.z);
                    float _1275 = _1272 * 64.0f;
                    float _1276 = _1273 * 32.0f;
                    float _1277 = _1274 * 64.0f;
                    int _1281 = int(floor(_1275));
                    int _1282 = int(floor(_1276));
                    int _1283 = int(floor(_1277));
                    uint4 _1290 = __3__36__0__0__g_axisAlignedDistanceTextures.Load(int4((_1281 & 63), (_1282 & 31), ((_1283 & 63) | (_1210 << 6)), 0));
                    float _1307 = saturate(float((uint)((uint)((uint)((uint)(_1290.w)) >> 2))) * 0.01587301678955555f);
                    float _1330 = _1275 - float((int)(_1281));
                    float _1331 = _1276 - float((int)(_1282));
                    float _1332 = _1277 - float((int)(_1283));
                    float _1363 = max(((_1261 * 0.5f) * min(min(select(_1182, 999999.0f, ((select(_1188, 1.0f, 0.0f) - frac(_1272 * 256.0f)) * _1185)), select(_1183, 999999.0f, ((select(_1189, 1.0f, 0.0f) - frac(_1273 * 128.0f)) * _1186))), select(_1184, 999999.0f, ((select(_1190, 1.0f, 0.0f) - frac(_1274 * 256.0f)) * _1187)))), ((_1261 * 2.0f) * min(min(select(_1182, 999999.0f, (select(_1188, ((0.009999999776482582f - _1330) + float((uint)((uint)(((uint)((uint)(_1290.x)) >> 4) & 15)))), ((0.9900000095367432f - _1330) - float((uint)((uint)(_1290.x & 15))))) * _1185)), select(_1183, 999999.0f, (select(_1189, ((0.009999999776482582f - _1331) + float((uint)((uint)(((uint)((uint)(_1290.y)) >> 4) & 15)))), ((0.9900000095367432f - _1331) - float((uint)((uint)(_1290.y & 15))))) * _1186))), select(_1184, 999999.0f, (select(_1190, ((0.009999999776482582f - _1332) + float((uint)((uint)(((uint)((uint)(_1290.z)) >> 4) & 15)))), ((0.9900000095367432f - _1332) - float((uint)((uint)(_1290.z & 15))))) * _1187)))));
                    float _1365 = float((bool)(uint)(_1307 > 0.0f));
                    if ((((uint)_1203 < (uint)16)) || ((_1205 < min(32.0f, (_1261 * 32.0f))))) {
                      float _1372 = frac(_1274);
                      float _1384 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_1272, _1273, (((float((uint)(_1210 * 130)) + 1.0f) + ((select((_1372 < 0.0f), 1.0f, 0.0f) + _1372) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                      float _1390 = _1205 * 0.009999999776482582f;
                      float _1391 = 1.0f / _1261;
                      float _1407 = (_1384.x + ((_178 * _178) * 0.00019999999494757503f)) / (((max(((_1261 * 1.0606600046157837f) * saturate((_1205 * 0.5f) + 0.5f)), _1390) - _1390) * saturate(((max(1.0f, (_1391 * 0.5f)) * _1391) * min(_1205, max(0.0f, (_1106 - _1205)))) + -1.0f)) + _1390);
                      float _1413 = saturate((saturate(1.0f - (_1407 * _1407)) * _1365) + _1204);
                      if (!((((int)_1210 > (int)2)) || ((_1384.x > _1261)))) {
                        _1427 = _1413;
                        _1428 = min(_1363, _1384.x);
                      } else {
                        _1427 = _1413;
                        _1428 = _1363;
                      }
                    } else {
                      if (!((_1290.w & 1) == 0)) {
                        _1427 = saturate((_1365 * 0.5f) + _1204);
                        _1428 = _1363;
                      } else {
                        _1427 = _1204;
                        _1428 = _1363;
                      }
                    }
                    if (!(_1427 >= 0.5f)) {
                      float _1433 = max(_1428, (_voxelParams.x * 0.05000000074505806f));
                      float _1434 = _1433 + _1205;
                      float _1438 = (_1433 * _210) + _1208;
                      float _1439 = (_1433 * _211) + _1207;
                      float _1440 = (_1433 * _212) + _1206;
                      if ((((uint)(_1203 + 1) < (uint)192)) && ((_1434 < _1106))) {
                        _1203 = (_1203 + 1);
                        _1204 = _1427;
                        _1205 = _1434;
                        _1206 = _1440;
                        _1207 = _1439;
                        _1208 = _1438;
                        __loop_jump_target = 1202;
                        break;
                      } else {
                        _1447 = _1434;
                        _1448 = _1440;
                        _1449 = _1439;
                        _1450 = _1438;
                        _1451 = _1427;
                        _1453 = _1447;
                        _1454 = _1448;
                        _1455 = _1449;
                        _1456 = _1450;
                        _1457 = _1451;
                        _1458 = -10000.0f;
                      }
                    } else {
                      _1453 = _1205;
                      _1454 = _1206;
                      _1455 = _1207;
                      _1456 = _1208;
                      _1457 = _1307;
                      _1458 = float((int)(_1210));
                    }
                  }
                }
                if (__defer_1209_1252) {
                  if ((int)(_1210 + 1) < (int)8) {
                    _1210 = (_1210 + 1);
                    continue;
                  } else {
                    _1453 = _1205;
                    _1454 = _1206;
                    _1455 = _1207;
                    _1456 = _1208;
                    _1457 = _1204;
                    _1458 = -10000.0f;
                  }
                }
                break;
              }
              if (__loop_jump_target == 1202) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
              break;
            }
          } else {
            _1453 = 0.0f;
            _1454 = _1178;
            _1455 = _1177;
            _1456 = _1176;
            _1457 = 0.0f;
            _1458 = -10000.0f;
          }
          int _1459 = int(_1458);
          if ((uint)_1459 < (uint)8) {
            float _1462 = _voxelParams.x * 0.5f;
            float _1466 = _1456 - (_1462 * _210);
            float _1467 = _1455 - (_1462 * _211);
            float _1468 = _1454 - (_1462 * _212);
            if ((int)_1459 < (int)6) {
              _1475 = 0;
              while(true) {
                int _1515 = int(floor(((_wrappedViewPos.x + _1466) * ((_clipmapOffsets[_1475]).w)) + ((_clipmapRelativeIndexOffsets[_1475]).x)));
                int _1516 = int(floor(((_wrappedViewPos.y + _1467) * ((_clipmapOffsets[_1475]).w)) + ((_clipmapRelativeIndexOffsets[_1475]).y)));
                int _1517 = int(floor(((_wrappedViewPos.z + _1468) * ((_clipmapOffsets[_1475]).w)) + ((_clipmapRelativeIndexOffsets[_1475]).z)));
                if ((((((((int)_1515 >= (int)int(((_clipmapOffsets[_1475]).x) + -63.0f))) && (((int)_1515 < (int)int(((_clipmapOffsets[_1475]).x) + 63.0f))))) && (((((int)_1516 >= (int)int(((_clipmapOffsets[_1475]).y) + -31.0f))) && (((int)_1516 < (int)int(((_clipmapOffsets[_1475]).y) + 31.0f))))))) && (((((int)_1517 >= (int)int(((_clipmapOffsets[_1475]).z) + -63.0f))) && (((int)_1517 < (int)int(((_clipmapOffsets[_1475]).z) + 63.0f)))))) {
                  _1538 = (_1515 & 127);
                  _1539 = (_1516 & 63);
                  _1540 = (_1517 & 127);
                  _1541 = _1475;
                } else {
                  if ((uint)(_1475 + 1) < (uint)8) {
                    _1475 = (_1475 + 1);
                    continue;
                  } else {
                    _1538 = -10000;
                    _1539 = -10000;
                    _1540 = -10000;
                    _1541 = -10000;
                  }
                }
                if (!((uint)_1541 > (uint)5)) {
                  uint _1551 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1538, _1539, ((int)(((uint)(((int)(_1541 * 130)) | 1)) + (uint)(_1540))), 0));
                  bool _1554 = ((_1551.x & 4194303) == 0);
                  [branch]
                  if (!_1554) {
                    _1557 = _1538;
                    _1558 = _1539;
                    _1559 = _1540;
                    _1560 = _1541;
                  } else {
                    _1557 = -10000;
                    _1558 = -10000;
                    _1559 = -10000;
                    _1560 = -10000;
                  }
                  float _1561 = _1462 * float((int)((int)(1u << (_1541 & 31))));
                  _1566 = 0;
                  while(true) {
                    int _1606 = int(floor((((_1466 - _1561) + _wrappedViewPos.x) * ((_clipmapOffsets[_1566]).w)) + ((_clipmapRelativeIndexOffsets[_1566]).x)));
                    int _1607 = int(floor((((_1467 - _1561) + _wrappedViewPos.y) * ((_clipmapOffsets[_1566]).w)) + ((_clipmapRelativeIndexOffsets[_1566]).y)));
                    int _1608 = int(floor((((_1468 - _1561) + _wrappedViewPos.z) * ((_clipmapOffsets[_1566]).w)) + ((_clipmapRelativeIndexOffsets[_1566]).z)));
                    if ((((((((int)_1606 >= (int)int(((_clipmapOffsets[_1566]).x) + -63.0f))) && (((int)_1606 < (int)int(((_clipmapOffsets[_1566]).x) + 63.0f))))) && (((((int)_1607 >= (int)int(((_clipmapOffsets[_1566]).y) + -31.0f))) && (((int)_1607 < (int)int(((_clipmapOffsets[_1566]).y) + 31.0f))))))) && (((((int)_1608 >= (int)int(((_clipmapOffsets[_1566]).z) + -63.0f))) && (((int)_1608 < (int)int(((_clipmapOffsets[_1566]).z) + 63.0f)))))) {
                      _1629 = (_1606 & 127);
                      _1630 = (_1607 & 63);
                      _1631 = (_1608 & 127);
                      _1632 = _1566;
                    } else {
                      if ((uint)(_1566 + 1) < (uint)8) {
                        _1566 = (_1566 + 1);
                        continue;
                      } else {
                        _1629 = -10000;
                        _1630 = -10000;
                        _1631 = -10000;
                        _1632 = -10000;
                      }
                    }
                    if (!((uint)_1632 > (uint)5)) {
                      if (_1554) {
                        _1637 = 0;
                        _1638 = _1560;
                        _1639 = _1559;
                        _1640 = _1558;
                        _1641 = _1557;
                        while(true) {
                          _1650 = 0;
                          _1651 = _1638;
                          _1652 = _1639;
                          _1653 = _1640;
                          _1654 = _1641;
                          while(true) {
                            if (!((((uint)(_1650 + _1630) > (uint)63)) || (((uint)(_1629 | (_1637 + _1631)) > (uint)127)))) {
                              uint _1672 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1629, (_1650 + _1630), ((int)(((uint)(_1637 + _1631)) + ((uint)(((int)(_1632 * 130)) | 1)))), 0));
                              int _1674 = _1672.x & 4194303;
                              _1677 = (_1674 != 0);
                              _1678 = _1674;
                              _1679 = _1632;
                              _1680 = (_1637 + _1631);
                              _1681 = (_1650 + _1630);
                              _1682 = _1629;
                            } else {
                              _1677 = false;
                              _1678 = 0;
                              _1679 = 0;
                              _1680 = 0;
                              _1681 = 0;
                              _1682 = 0;
                            }
                            if (!_1677) {
                              if (!((((uint)(_1650 + _1630) > (uint)63)) || (((uint)((_1629 + 1) | (_1637 + _1631)) > (uint)127)))) {
                                uint _4153 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((_1629 + 1), (_1650 + _1630), ((int)(((uint)(_1637 + _1631)) + ((uint)(((int)(_1632 * 130)) | 1)))), 0));
                                int _4155 = _4153.x & 4194303;
                                _4158 = (_4155 != 0);
                                _4159 = _4155;
                                _4160 = _1632;
                                _4161 = (_1637 + _1631);
                                _4162 = (_1650 + _1630);
                                _4163 = (_1629 + 1);
                              } else {
                                _4158 = false;
                                _4159 = 0;
                                _4160 = 0;
                                _4161 = 0;
                                _4162 = 0;
                                _4163 = 0;
                              }
                              if (!_4158) {
                                _1691 = _1654;
                                _1692 = _1653;
                                _1693 = _1652;
                                _1694 = _1651;
                                _1695 = 0;
                              } else {
                                _1691 = _4163;
                                _1692 = _4162;
                                _1693 = _4161;
                                _1694 = _4160;
                                _1695 = _4159;
                              }
                            } else {
                              _1691 = _1682;
                              _1692 = _1681;
                              _1693 = _1680;
                              _1694 = _1679;
                              _1695 = _1678;
                            }
                            if ((((int)(_1650 + 1) < (int)2)) && ((_1695 == 0))) {
                              _1650 = (_1650 + 1);
                              _1651 = _1694;
                              _1652 = _1693;
                              _1653 = _1692;
                              _1654 = _1691;
                              continue;
                            }
                            if ((((int)(_1637 + 1) < (int)2)) && ((_1695 == 0))) {
                              _1637 = (_1637 + 1);
                              _1638 = _1694;
                              _1639 = _1693;
                              _1640 = _1692;
                              _1641 = _1691;
                              __loop_jump_target = 1636;
                              break;
                            }
                            _1644 = _1694;
                            _1645 = _1693;
                            _1646 = _1692;
                            _1647 = _1691;
                            break;
                          }
                          if (__loop_jump_target == 1636) {
                            __loop_jump_target = -1;
                            continue;
                          }
                          if (__loop_jump_target != -1) {
                            break;
                          }
                          break;
                        }
                      } else {
                        _1644 = _1560;
                        _1645 = _1559;
                        _1646 = _1558;
                        _1647 = _1557;
                      }
                      if ((uint)_1644 < (uint)6) {
                        uint _1701 = _1644 * 130;
                        uint _1705 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1647, _1646, ((int)(((uint)((int)(_1701) | 1)) + (uint)(_1645))), 0));
                        int _1707 = _1705.x & 4194303;
                        [branch]
                        if (!(_1707 == 0)) {
                          float _1713 = float((int)((int)(1u << (_1644 & 31)))) * _voxelParams.x;
                          float _1750 = -0.0f - _210;
                          float _1751 = -0.0f - _211;
                          float _1752 = -0.0f - _212;
                          _1754 = 0.0f;
                          _1755 = 0.0f;
                          _1756 = 0.0f;
                          _1757 = 0.0f;
                          _1758 = 0;
                          while(true) {
                            int _1763 = __3__37__0__0__g_surfelDataBuffer[((_1707 + -1) + _1758)]._baseColor;
                            int _1765 = __3__37__0__0__g_surfelDataBuffer[((_1707 + -1) + _1758)]._normal;
                            int16_t _1768 = __3__37__0__0__g_surfelDataBuffer[((_1707 + -1) + _1758)]._radius;
                            if (!(_1763 == 0)) {
                              half _1771 = __3__37__0__0__g_surfelDataBuffer[((_1707 + -1) + _1758)]._radiance.z;
                              half _1772 = __3__37__0__0__g_surfelDataBuffer[((_1707 + -1) + _1758)]._radiance.y;
                              half _1773 = __3__37__0__0__g_surfelDataBuffer[((_1707 + -1) + _1758)]._radiance.x;
                              float _1779 = float((uint)((uint)(_1763 & 255)));
                              float _1780 = float((uint)((uint)(((uint)((uint)(_1763)) >> 8) & 255)));
                              float _1781 = float((uint)((uint)(((uint)((uint)(_1763)) >> 16) & 255)));
                              float _1806 = select(((_1779 * 0.003921568859368563f) < 0.040449999272823334f), (_1779 * 0.0003035269910469651f), exp2(log2((_1779 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1807 = select(((_1780 * 0.003921568859368563f) < 0.040449999272823334f), (_1780 * 0.0003035269910469651f), exp2(log2((_1780 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1808 = select(((_1781 * 0.003921568859368563f) < 0.040449999272823334f), (_1781 * 0.0003035269910469651f), exp2(log2((_1781 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1820 = (float((uint)((uint)(_1765 & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1821 = (float((uint)((uint)(((uint)((uint)(_1765)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1822 = (float((uint)((uint)(((uint)((uint)(_1765)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1824 = rsqrt(dot(float3(_1820, _1821, _1822), float3(_1820, _1821, _1822)));
                              bool _1829 = ((_1765 & 16777215) == 0);
                              float _1833 = float(_1773);
                              float _1834 = float(_1772);
                              float _1835 = float(_1771);
                              float _1839 = (_1713 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_1768) & 255)));
                              float _1855 = (((float((uint)((uint)((uint)((uint)(_1763)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1713) + ((((((_clipmapOffsets[_1644]).x) + -63.5f) + float((int)(((int)(((uint)(_1647) + 64u) - (uint)(int((_clipmapOffsets[_1644]).x)))) & 127))) * _1713) - _viewPos.x);
                              float _1856 = (((float((uint)((uint)((uint)((uint)(_1765)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1713) + ((((((_clipmapOffsets[_1644]).y) + -31.5f) + float((int)(((int)(((uint)(_1646) + 32u) - (uint)(int((_clipmapOffsets[_1644]).y)))) & 63))) * _1713) - _viewPos.y);
                              float _1857 = (((float((uint16_t)((uint)((uint16_t)((uint)(_1768)) >> 8))) * 0.003937007859349251f) + -0.5f) * _1713) + ((((((_clipmapOffsets[_1644]).z) + -63.5f) + float((int)(((int)(((uint)(_1645) + 64u) - (uint)(int((_clipmapOffsets[_1644]).z)))) & 127))) * _1713) - _viewPos.z);
                              float _1877 = ((-0.0f - _1100) - (_1453 * _210)) + _1855;
                              float _1880 = ((-0.0f - _1101) - (_1453 * _211)) + _1856;
                              float _1883 = ((-0.0f - _1102) - (_1453 * _212)) + _1857;
                              float _1884 = dot(float3(_1877, _1880, _1883), float3(_1750, _1751, _1752));
                              float _1888 = _1877 - (_1884 * _1750);
                              float _1889 = _1880 - (_1884 * _1751);
                              float _1890 = _1883 - (_1884 * _1752);
                              float _1916 = 1.0f / float((uint)(1u << (_1644 & 31)));
                              float _1920 = frac(((_invClipmapExtent.z * _1857) + _clipmapUVRelativeOffset.z) * _1916);
                              float _1931 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _1855) + _clipmapUVRelativeOffset.x) * _1916), (((_invClipmapExtent.y * _1856) + _clipmapUVRelativeOffset.y) * _1916), (((float((uint)_1701) + 1.0f) + ((select((_1920 < 0.0f), 1.0f, 0.0f) + _1920) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                              float _1945 = select(((int)_1644 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_1750, _1751, _1752), float3(select(_1829, _1750, (_1824 * _1820)), select(_1829, _1751, (_1824 * _1821)), select(_1829, _1752, (_1824 * _1822))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_1888, _1889, _1890), float3(_1888, _1889, _1890)) < ((_1839 * _1839) * 16.0f)))) * float((bool)(uint)(_1931.x > ((_1713 * 0.25f) * (saturate((dot(float3(_1833, _1834, _1835), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                              float _1952 = (((((_1807 * 0.3395099937915802f) + (_1806 * 0.6131200194358826f)) + (_1808 * 0.047370001673698425f)) * _1833) * _1945) + _1754;
                              float _1953 = (((((_1807 * 0.9163600206375122f) + (_1806 * 0.07020000368356705f)) + (_1808 * 0.013450000435113907f)) * _1834) * _1945) + _1755;
                              float _1954 = (((((_1807 * 0.10958000272512436f) + (_1806 * 0.02061999961733818f)) + (_1808 * 0.8697999715805054f)) * _1835) * _1945) + _1756;
                              float _1955 = _1945 + _1757;
                              if ((uint)(_1758 + 1) < (uint)4) {
                                _1754 = _1952;
                                _1755 = _1953;
                                _1756 = _1954;
                                _1757 = _1955;
                                _1758 = (_1758 + 1);
                                continue;
                              } else {
                                _1959 = _1952;
                                _1960 = _1953;
                                _1961 = _1954;
                                _1962 = _1955;
                              }
                            } else {
                              _1959 = _1754;
                              _1960 = _1755;
                              _1961 = _1756;
                              _1962 = _1757;
                            }
                            if (_1962 > 0.0f) {
                              float _1965 = 1.0f / _1962;
                              _1979 = 1.0f;
                              _1980 = (-0.0f - min(0.0f, (-0.0f - (_1959 * _1965))));
                              _1981 = (-0.0f - min(0.0f, (-0.0f - (_1960 * _1965))));
                              _1982 = (-0.0f - min(0.0f, (-0.0f - (_1961 * _1965))));
                            } else {
                              _1979 = 0.0f;
                              _1980 = _1959;
                              _1981 = _1960;
                              _1982 = _1961;
                            }
                            break;
                          }
                        } else {
                          _1979 = 0.0f;
                          _1980 = 0.0f;
                          _1981 = 0.0f;
                          _1982 = 0.0f;
                        }
                      } else {
                        _1979 = 0.0f;
                        _1980 = 0.0f;
                        _1981 = 0.0f;
                        _1982 = 0.0f;
                      }
                    } else {
                      _1979 = 1.0f;
                      _1980 = 0.0f;
                      _1981 = 0.0f;
                      _1982 = 0.0f;
                    }
                    break;
                  }
                } else {
                  _1979 = 1.0f;
                  _1980 = 0.0f;
                  _1981 = 0.0f;
                  _1982 = 0.0f;
                }
                break;
              }
            } else {
              _1979 = 1.0f;
              _1980 = 0.0f;
              _1981 = 0.0f;
              _1982 = 0.0f;
            }
            float _1990 = saturate((_1453 * 0.25f) / (float((int)((int)(1u << (_1166 & 31)))) * _voxelParams.x)) * _1979;
            float _2000 = -0.0f - min(0.0f, (-0.0f - (_1980 * _1990)));
            float _2001 = -0.0f - min(0.0f, (-0.0f - (_1981 * _1990)));
            float _2002 = -0.0f - min(0.0f, (-0.0f - (_1982 * _1990)));
            float _2004 = select(((int)_1459 > (int)-1), 1.0f, 0.0f);
            float _2005 = max(9.999999974752427e-07f, _1453);
            if (_2005 > 0.0f) {
              _2010 = (_2005 + _1099);
              _2011 = _2000;
              _2012 = _2001;
              _2013 = _2002;
              _2014 = _2004;
            } else {
              _2010 = _2005;
              _2011 = _2000;
              _2012 = _2001;
              _2013 = _2002;
              _2014 = _2004;
            }
          } else {
            _2010 = 0.0f;
            _2011 = 0.0f;
            _2012 = 0.0f;
            _2013 = 0.0f;
            _2014 = _1457;
          }
        } else {
          _2010 = 0.0f;
          _2011 = 0.0f;
          _2012 = 0.0f;
          _2013 = 0.0f;
          _2014 = 0.0f;
        }
        break;
      }
    } else {
      _2010 = _759;
      _2011 = _755;
      _2012 = _756;
      _2013 = _757;
      _2014 = _758;
    }
    float _2017 = saturate(5.000000476837158f - (_178 * 0.01953125186264515f));
    bool _2018 = (_968 != 0);
    if (((_967 > 0.0f)) && ((((_959 > 0.0f)) && (_2018)))) {
      if (!(_959 < _2010)) {
        _2028 = (_2010 <= 0.0f);
      } else {
        _2028 = true;
      }
    } else {
      _2028 = false;
    }
    float _2032 = saturate(max(select(_2028, 1.0f, 0.0f), (1.0f - _2017)));
    float _2033 = _2032 * _967;
    float _2036 = min(_2017, saturate(1.0f - _2033));
    if (!(_2014 == 0.0f)) {
      _2051 = ((_2036 * _2011) + (_2032 * _964));
      _2052 = ((_2036 * _2012) + (_2032 * _965));
      _2053 = ((_2036 * _2013) + (_2032 * _966));
      _2054 = ((_2036 * _2014) + _2033);
    } else {
      _2051 = _964;
      _2052 = _965;
      _2053 = _966;
      _2054 = _967;
    }
    float _2057 = 1.0f / max(9.999999974752427e-07f, (_2036 + _2032));
    float _2061 = _2057 * ((_2036 * _2010) + (_2032 * _959));
    float _2063 = _2057 * _2032;
    float _2067 = (_2061 * _210) + _173;
    float _2068 = (_2061 * _211) + _174;
    float _2069 = (_2061 * _212) + _175;
    [branch]
    if (!(_2061 <= 0.0f)) {
      float _2099 = mad((_viewProjRelative[3].z), _2069, mad((_viewProjRelative[3].y), _2068, ((_viewProjRelative[3].x) * _2067))) + (_viewProjRelative[3].w);
      float _2104 = (((mad((_viewProjRelative[0].z), _2069, mad((_viewProjRelative[0].y), _2068, ((_viewProjRelative[0].x) * _2067))) + (_viewProjRelative[0].w)) / _2099) * 0.5f) + 0.5f;
      float _2105 = 0.5f - (((mad((_viewProjRelative[1].z), _2069, mad((_viewProjRelative[1].y), _2068, ((_viewProjRelative[1].x) * _2067))) + (_viewProjRelative[1].w)) / _2099) * 0.5f);
      if (((((_2104 >= 0.0f)) && ((_2104 <= 1.0f)))) && ((((_2105 >= 0.0f)) && ((_2105 <= 1.0f))))) {
        if ((_2018) && ((((mad((_viewProjRelative[2].z), _2069, mad((_viewProjRelative[2].y), _2068, ((_viewProjRelative[2].x) * _2067))) + (_viewProjRelative[2].w)) / _2099) > 0.0f))) {
          half4 _2128 = __3__36__0__0__g_sceneShadowColor.SampleLevel(__3__40__0__0__g_sampler, float2(_2104, _2105), 0.0f);
          _2136 = float(_2128.x);
          _2137 = float(_2128.y);
          _2138 = float(_2128.z);
        } else {
          _2136 = 1.0f;
          _2137 = 1.0f;
          _2138 = 1.0f;
        }
      } else {
        _2136 = 1.0f;
        _2137 = 1.0f;
        _2138 = 1.0f;
      }
      float _2145 = _viewPos.x + _2067;
      float _2146 = _viewPos.y + _2068;
      float _2147 = _viewPos.z + _2069;
      float _2152 = _2145 - (_staticShadowPosition[1].x);
      float _2153 = _2146 - (_staticShadowPosition[1].y);
      float _2154 = _2147 - (_staticShadowPosition[1].z);
      float _2174 = mad((_shadowProjRelativeTexScale[1][0].z), _2154, mad((_shadowProjRelativeTexScale[1][0].y), _2153, ((_shadowProjRelativeTexScale[1][0].x) * _2152))) + (_shadowProjRelativeTexScale[1][0].w);
      float _2178 = mad((_shadowProjRelativeTexScale[1][1].z), _2154, mad((_shadowProjRelativeTexScale[1][1].y), _2153, ((_shadowProjRelativeTexScale[1][1].x) * _2152))) + (_shadowProjRelativeTexScale[1][1].w);
      float _2185 = 2.0f / _shadowSizeAndInvSize.y;
      float _2186 = 1.0f - _2185;
      bool _2193 = ((((((!(_2174 <= _2186))) || ((!(_2174 >= _2185))))) || ((!(_2178 <= _2186))))) || ((!(_2178 >= _2185)));
      float _2202 = _2145 - (_staticShadowPosition[0].x);
      float _2203 = _2146 - (_staticShadowPosition[0].y);
      float _2204 = _2147 - (_staticShadowPosition[0].z);
      float _2224 = mad((_shadowProjRelativeTexScale[0][0].z), _2204, mad((_shadowProjRelativeTexScale[0][0].y), _2203, ((_shadowProjRelativeTexScale[0][0].x) * _2202))) + (_shadowProjRelativeTexScale[0][0].w);
      float _2228 = mad((_shadowProjRelativeTexScale[0][1].z), _2204, mad((_shadowProjRelativeTexScale[0][1].y), _2203, ((_shadowProjRelativeTexScale[0][1].x) * _2202))) + (_shadowProjRelativeTexScale[0][1].w);
      bool _2239 = ((((((!(_2224 <= _2186))) || ((!(_2224 >= _2185))))) || ((!(_2228 <= _2186))))) || ((!(_2228 >= _2185)));
      float _2240 = select(_2239, select(_2193, 0.0f, _2174), _2224);
      float _2241 = select(_2239, select(_2193, 0.0f, _2178), _2228);
      float _2242 = select(_2239, select(_2193, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _2154, mad((_shadowProjRelativeTexScale[1][2].y), _2153, ((_shadowProjRelativeTexScale[1][2].x) * _2152))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _2204, mad((_shadowProjRelativeTexScale[0][2].y), _2203, ((_shadowProjRelativeTexScale[0][2].x) * _2202))) + (_shadowProjRelativeTexScale[0][2].w)));
      int _2243 = select(_2239, select(_2193, -1, 1), 0);
      [branch]
      if (!(_2243 == -1)) {
        float _2249 = (_2240 * _shadowSizeAndInvSize.x) + -0.5f;
        float _2250 = (_2241 * _shadowSizeAndInvSize.y) + -0.5f;
        int _2253 = int(floor(_2249));
        int _2254 = int(floor(_2250));
        if (!((((uint)_2253 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_2254 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
          float4 _2264 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2253, _2254, _2243, 0));
          float4 _2266 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2253) + 1u)), _2254, _2243, 0));
          float4 _2268 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2253, ((int)((uint)(_2254) + 1u)), _2243, 0));
          float4 _2270 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2253) + 1u)), ((int)((uint)(_2254) + 1u)), _2243, 0));
          half4 _2275 = __3__36__0__0__g_shadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2240, _2241, float((uint)(uint)(_2243))), 0.0f);
          _2281 = _2264.x;
          _2282 = _2266.x;
          _2283 = _2268.x;
          _2284 = _2270.x;
          _2285 = _2275.x;
          _2286 = _2275.y;
          _2287 = _2275.z;
          _2288 = _2275.w;
        } else {
          _2281 = 0.0f;
          _2282 = 0.0f;
          _2283 = 0.0f;
          _2284 = 0.0f;
          _2285 = 1.0h;
          _2286 = 1.0h;
          _2287 = 1.0h;
          _2288 = 1.0h;
        }
        float _2314 = (float4(_invShadowViewProj[_2243][0][0], _invShadowViewProj[_2243][1][0], _invShadowViewProj[_2243][2][0], _invShadowViewProj[_2243][3][0]).x) * _2240;
        float _2318 = (float4(_invShadowViewProj[_2243][0][0], _invShadowViewProj[_2243][1][0], _invShadowViewProj[_2243][2][0], _invShadowViewProj[_2243][3][0]).y) * _2240;
        float _2322 = (float4(_invShadowViewProj[_2243][0][0], _invShadowViewProj[_2243][1][0], _invShadowViewProj[_2243][2][0], _invShadowViewProj[_2243][3][0]).z) * _2240;
        float _2326 = (float4(_invShadowViewProj[_2243][0][0], _invShadowViewProj[_2243][1][0], _invShadowViewProj[_2243][2][0], _invShadowViewProj[_2243][3][0]).w) * _2240;
        float _2329 = mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).w), _2281, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).w), _2241, _2326)) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).w);
        float _2330 = (mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).x), _2281, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).x), _2241, _2314)) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).x)) / _2329;
        float _2331 = (mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).y), _2281, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).y), _2241, _2318)) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).y)) / _2329;
        float _2332 = (mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).z), _2281, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).z), _2241, _2322)) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).z)) / _2329;
        float _2335 = _2240 + (_shadowSizeAndInvSize.z * 4.0f);
        float _2351 = mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).w), _2282, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).w), _2241, ((float4(_invShadowViewProj[_2243][0][0], _invShadowViewProj[_2243][1][0], _invShadowViewProj[_2243][2][0], _invShadowViewProj[_2243][3][0]).w) * _2335))) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).w);
        float _2357 = _2241 - (_shadowSizeAndInvSize.w * 2.0f);
        float _2369 = mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).w), _2283, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).w), _2357, _2326)) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).w);
        float _2373 = ((mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).x), _2283, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).x), _2357, _2314)) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).x)) / _2369) - _2330;
        float _2374 = ((mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).y), _2283, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).y), _2357, _2318)) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).y)) / _2369) - _2331;
        float _2375 = ((mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).z), _2283, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).z), _2357, _2322)) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).z)) / _2369) - _2332;
        float _2376 = ((mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).x), _2282, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).x), _2241, ((float4(_invShadowViewProj[_2243][0][0], _invShadowViewProj[_2243][1][0], _invShadowViewProj[_2243][2][0], _invShadowViewProj[_2243][3][0]).x) * _2335))) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).x)) / _2351) - _2330;
        float _2377 = ((mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).y), _2282, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).y), _2241, ((float4(_invShadowViewProj[_2243][0][0], _invShadowViewProj[_2243][1][0], _invShadowViewProj[_2243][2][0], _invShadowViewProj[_2243][3][0]).y) * _2335))) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).y)) / _2351) - _2331;
        float _2378 = ((mad((float4(_invShadowViewProj[_2243][0][2], _invShadowViewProj[_2243][1][2], _invShadowViewProj[_2243][2][2], _invShadowViewProj[_2243][3][2]).z), _2282, mad((float4(_invShadowViewProj[_2243][0][1], _invShadowViewProj[_2243][1][1], _invShadowViewProj[_2243][2][1], _invShadowViewProj[_2243][3][1]).z), _2241, ((float4(_invShadowViewProj[_2243][0][0], _invShadowViewProj[_2243][1][0], _invShadowViewProj[_2243][2][0], _invShadowViewProj[_2243][3][0]).z) * _2335))) + (float4(_invShadowViewProj[_2243][0][3], _invShadowViewProj[_2243][1][3], _invShadowViewProj[_2243][2][3], _invShadowViewProj[_2243][3][3]).z)) / _2351) - _2332;
        float _2381 = (_2375 * _2377) - (_2374 * _2378);
        float _2384 = (_2373 * _2378) - (_2375 * _2376);
        float _2387 = (_2374 * _2376) - (_2373 * _2377);
        float _2389 = rsqrt(dot(float3(_2381, _2384, _2387), float3(_2381, _2384, _2387)));
        float _2390 = _2381 * _2389;
        float _2391 = _2384 * _2389;
        float _2392 = _2387 * _2389;
        float _2393 = frac(_2249);
        float _2398 = (saturate(dot(float3(_210, _211, _212), float3(_2390, _2391, _2392))) * 0.0020000000949949026f) + _2242;
        float _2411 = saturate(exp2((_2281 - _2398) * 1442695.0f));
        float _2413 = saturate(exp2((_2283 - _2398) * 1442695.0f));
        float _2419 = ((saturate(exp2((_2282 - _2398) * 1442695.0f)) - _2411) * _2393) + _2411;
        _2426 = _2390;
        _2427 = _2391;
        _2428 = _2392;
        _2429 = saturate((((_2413 - _2419) + ((saturate(exp2((_2284 - _2398) * 1442695.0f)) - _2413) * _2393)) * frac(_2250)) + _2419);
        _2430 = _2281;
        _2431 = _2282;
        _2432 = _2283;
        _2433 = _2284;
        _2434 = _2285;
        _2435 = _2286;
        _2436 = _2287;
        _2437 = _2288;
      } else {
        _2426 = 0.0f;
        _2427 = 0.0f;
        _2428 = 0.0f;
        _2429 = 0.0f;
        _2430 = 0.0f;
        _2431 = 0.0f;
        _2432 = 0.0f;
        _2433 = 0.0f;
        _2434 = 0.0h;
        _2435 = 0.0h;
        _2436 = 0.0h;
        _2437 = 0.0h;
      }
      float _2457 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _2069, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _2068, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _2067))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
      float _2461 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _2069, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _2068, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _2067))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
      float _2465 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _2069, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _2068, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _2067))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
      float _2468 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
      float _2469 = 1.0f - _2468;
      if (!(((((!(_2457 <= _2469))) || ((!(_2457 >= _2468))))) || ((!(_2461 <= _2469))))) {
        bool _2480 = ((_2465 >= -1.0f)) && ((((_2465 <= 1.0f)) && ((_2461 >= _2468))));
        _2488 = select(_2480, 9.999999747378752e-06f, -9.999999747378752e-05f);
        _2489 = select(_2480, _2457, _2240);
        _2490 = select(_2480, _2461, _2241);
        _2491 = select(_2480, _2465, _2242);
        _2492 = select(_2480, 1, _2243);
        _2493 = ((int)(uint)((int)(_2480)));
      } else {
        _2488 = -9.999999747378752e-05f;
        _2489 = _2240;
        _2490 = _2241;
        _2491 = _2242;
        _2492 = _2243;
        _2493 = 0;
      }
      float _2513 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _2069, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _2068, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _2067))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
      float _2517 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _2069, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _2068, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _2067))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
      float _2521 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _2069, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _2068, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _2067))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
      if (!(((((!(_2513 <= _2469))) || ((!(_2513 >= _2468))))) || ((!(_2517 <= _2469))))) {
        bool _2532 = ((_2521 >= -1.0f)) && ((((_2517 >= _2468)) && ((_2521 <= 1.0f))));
        _2540 = select(_2532, 9.999999747378752e-06f, _2488);
        _2541 = select(_2532, _2513, _2489);
        _2542 = select(_2532, _2517, _2490);
        _2543 = select(_2532, _2521, _2491);
        _2544 = select(_2532, 0, _2492);
        _2545 = select(_2532, 1, _2493);
      } else {
        _2540 = _2488;
        _2541 = _2489;
        _2542 = _2490;
        _2543 = _2491;
        _2544 = _2492;
        _2545 = _2493;
      }
      [branch]
      if (!(_2545 == 0)) {
        int _2555 = int(floor((_2541 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
        int _2556 = int(floor((_2542 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
        if (!((((uint)_2555 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_2556 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
          float4 _2566 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2555, _2556, _2544, 0));
          float4 _2568 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2555) + 1u)), _2556, _2544, 0));
          float4 _2570 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2555, ((int)((uint)(_2556) + 1u)), _2544, 0));
          float4 _2572 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2555) + 1u)), ((int)((uint)(_2556) + 1u)), _2544, 0));
          _2575 = _2566.x;
          _2576 = _2568.x;
          _2577 = _2570.x;
          _2578 = _2572.x;
        } else {
          _2575 = _2430;
          _2576 = _2431;
          _2577 = _2432;
          _2578 = _2433;
        }
        float _2604 = (float4(_invDynamicShadowViewProj[_2544][0][0], _invDynamicShadowViewProj[_2544][1][0], _invDynamicShadowViewProj[_2544][2][0], _invDynamicShadowViewProj[_2544][3][0]).x) * _2541;
        float _2608 = (float4(_invDynamicShadowViewProj[_2544][0][0], _invDynamicShadowViewProj[_2544][1][0], _invDynamicShadowViewProj[_2544][2][0], _invDynamicShadowViewProj[_2544][3][0]).y) * _2541;
        float _2612 = (float4(_invDynamicShadowViewProj[_2544][0][0], _invDynamicShadowViewProj[_2544][1][0], _invDynamicShadowViewProj[_2544][2][0], _invDynamicShadowViewProj[_2544][3][0]).z) * _2541;
        float _2616 = (float4(_invDynamicShadowViewProj[_2544][0][0], _invDynamicShadowViewProj[_2544][1][0], _invDynamicShadowViewProj[_2544][2][0], _invDynamicShadowViewProj[_2544][3][0]).w) * _2541;
        float _2619 = mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).w), _2575, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).w), _2542, _2616)) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).w);
        float _2620 = (mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).x), _2575, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).x), _2542, _2604)) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).x)) / _2619;
        float _2621 = (mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).y), _2575, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).y), _2542, _2608)) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).y)) / _2619;
        float _2622 = (mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).z), _2575, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).z), _2542, _2612)) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).z)) / _2619;
        float _2625 = _2541 + (_dynmaicShadowSizeAndInvSize.z * 8.0f);
        float _2641 = mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).w), _2576, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).w), _2542, ((float4(_invDynamicShadowViewProj[_2544][0][0], _invDynamicShadowViewProj[_2544][1][0], _invDynamicShadowViewProj[_2544][2][0], _invDynamicShadowViewProj[_2544][3][0]).w) * _2625))) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).w);
        float _2647 = _2542 - (_dynmaicShadowSizeAndInvSize.w * 4.0f);
        float _2659 = mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).w), _2577, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).w), _2647, _2616)) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).w);
        float _2663 = ((mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).x), _2577, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).x), _2647, _2604)) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).x)) / _2659) - _2620;
        float _2664 = ((mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).y), _2577, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).y), _2647, _2608)) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).y)) / _2659) - _2621;
        float _2665 = ((mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).z), _2577, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).z), _2647, _2612)) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).z)) / _2659) - _2622;
        float _2666 = ((mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).x), _2576, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).x), _2542, ((float4(_invDynamicShadowViewProj[_2544][0][0], _invDynamicShadowViewProj[_2544][1][0], _invDynamicShadowViewProj[_2544][2][0], _invDynamicShadowViewProj[_2544][3][0]).x) * _2625))) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).x)) / _2641) - _2620;
        float _2667 = ((mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).y), _2576, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).y), _2542, ((float4(_invDynamicShadowViewProj[_2544][0][0], _invDynamicShadowViewProj[_2544][1][0], _invDynamicShadowViewProj[_2544][2][0], _invDynamicShadowViewProj[_2544][3][0]).y) * _2625))) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).y)) / _2641) - _2621;
        float _2668 = ((mad((float4(_invDynamicShadowViewProj[_2544][0][2], _invDynamicShadowViewProj[_2544][1][2], _invDynamicShadowViewProj[_2544][2][2], _invDynamicShadowViewProj[_2544][3][2]).z), _2576, mad((float4(_invDynamicShadowViewProj[_2544][0][1], _invDynamicShadowViewProj[_2544][1][1], _invDynamicShadowViewProj[_2544][2][1], _invDynamicShadowViewProj[_2544][3][1]).z), _2542, ((float4(_invDynamicShadowViewProj[_2544][0][0], _invDynamicShadowViewProj[_2544][1][0], _invDynamicShadowViewProj[_2544][2][0], _invDynamicShadowViewProj[_2544][3][0]).z) * _2625))) + (float4(_invDynamicShadowViewProj[_2544][0][3], _invDynamicShadowViewProj[_2544][1][3], _invDynamicShadowViewProj[_2544][2][3], _invDynamicShadowViewProj[_2544][3][3]).z)) / _2641) - _2622;
        float _2671 = (_2665 * _2667) - (_2664 * _2668);
        float _2674 = (_2663 * _2668) - (_2665 * _2666);
        float _2677 = (_2664 * _2666) - (_2663 * _2667);
        float _2679 = rsqrt(dot(float3(_2671, _2674, _2677), float3(_2671, _2674, _2677)));
        if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
          _2697 = _sunDirection.x;
          _2698 = _sunDirection.y;
          _2699 = _sunDirection.z;
        } else {
          _2697 = _moonDirection.x;
          _2698 = _moonDirection.y;
          _2699 = _moonDirection.z;
        }
        float _2705 = (_2540 - (saturate(-0.0f - dot(float3(_2697, _2698, _2699), float3(_210, _211, _212))) * 9.999999747378752e-05f)) + _2543;
        _2718 = (_2671 * _2679);
        _2719 = (_2674 * _2679);
        _2720 = (_2677 * _2679);
        _2721 = min(float((bool)(uint)(_2575 > _2705)), min(min(float((bool)(uint)(_2576 > _2705)), float((bool)(uint)(_2577 > _2705))), float((bool)(uint)(_2578 > _2705))));
      } else {
        _2718 = _2426;
        _2719 = _2427;
        _2720 = _2428;
        _2721 = _2429;
      }
      float _2726 = _viewPos.x - _shadowRelativePosition.x;
      float _2727 = _viewPos.y - _shadowRelativePosition.y;
      float _2728 = _viewPos.z - _shadowRelativePosition.z;
      float _2729 = _2726 + _2067;
      float _2730 = _2727 + _2068;
      float _2731 = _2728 + _2069;
      float _2751 = mad((_terrainShadowProjRelativeTexScale[0].z), _2731, mad((_terrainShadowProjRelativeTexScale[0].y), _2730, (_2729 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
      float _2755 = mad((_terrainShadowProjRelativeTexScale[1].z), _2731, mad((_terrainShadowProjRelativeTexScale[1].y), _2730, (_2729 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
      float _2759 = mad((_terrainShadowProjRelativeTexScale[2].z), _2731, mad((_terrainShadowProjRelativeTexScale[2].y), _2730, (_2729 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
      if (saturate(_2751) == _2751) {
        if (((_2759 >= 9.999999747378752e-05f)) && ((((_2759 <= 1.0f)) && ((saturate(_2755) == _2755))))) {
          float _2774 = frac((_2751 * 1024.0f) + -0.5f);
          float4 _2778 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_2751, _2755));
          float _2783 = _2759 + -0.004999999888241291f;
          float _2788 = select((_2778.w > _2783), 1.0f, 0.0f);
          float _2790 = select((_2778.x > _2783), 1.0f, 0.0f);
          float _2797 = ((select((_2778.z > _2783), 1.0f, 0.0f) - _2788) * _2774) + _2788;
          _2803 = saturate((((((select((_2778.y > _2783), 1.0f, 0.0f) - _2790) * _2774) + _2790) - _2797) * frac((_2755 * 1024.0f) + -0.5f)) + _2797);
        } else {
          _2803 = 1.0f;
        }
      } else {
        _2803 = 1.0f;
      }
      float _2804 = min(_2721, _2803);
      half _2805 = saturate(_2434);
      half _2806 = saturate(_2435);
      half _2807 = saturate(_2436);
      half _2821 = ((_2806 * 0.3395996h) + (_2805 * 0.61328125h)) + (_2807 * 0.04736328h);
      half _2822 = ((_2806 * 0.9165039h) + (_2805 * 0.07019043h)) + (_2807 * 0.013450623h);
      half _2823 = ((_2806 * 0.109558105h) + (_2805 * 0.020614624h)) + (_2807 * 0.8696289h);
      bool _2826 = (_sunDirection.y > 0.0f);
      if ((_2826) || ((!(_2826)) && (_sunDirection.y > _moonDirection.y))) {
        _2838 = _sunDirection.x;
        _2839 = _sunDirection.y;
        _2840 = _sunDirection.z;
      } else {
        _2838 = _moonDirection.x;
        _2839 = _moonDirection.y;
        _2840 = _moonDirection.z;
      }
      if ((_2826) || ((!(_2826)) && (_sunDirection.y > _moonDirection.y))) {
        _2860 = _precomputedAmbient7.y;
      } else {
        _2860 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
      }
      float _2863 = _2146 + _earthRadius;
      float _2867 = (_2069 * _2069) + (_2067 * _2067);
      float _2869 = sqrt((_2863 * _2863) + _2867);
      float _2874 = dot(float3((_2067 / _2869), (_2863 / _2869), (_2069 / _2869)), float3(_2838, _2839, _2840));
      float _2877 = _atmosphereThickness + -16.0f;
      float _2879 = min(max(((_2869 - _earthRadius) / _atmosphereThickness), 16.0f), _2877);
      float _2881 = _atmosphereThickness + -32.0f;
      float _2887 = max(_2879, 0.0f);
      float _2888 = _earthRadius * 2.0f;
      float _2894 = (-0.0f - sqrt((_2887 + _2888) * _2887)) / (_2887 + _earthRadius);
      if (_2874 > _2894) {
        _2917 = ((exp2(log2(saturate((_2874 - _2894) / (1.0f - _2894))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _2917 = ((exp2(log2(saturate((_2894 - _2874) / (_2894 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float2 _2922 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_2879 + -16.0f) / _2881)) * 0.5f) * 0.96875f) + 0.015625f), _2917), 0.0f);
      float _2941 = _mieAerosolAbsorption + 1.0f;
      float _2942 = _mieAerosolDensity * 1.9999999494757503e-05f;
      float _2944 = (_2942 * _2922.y) * _2941;
      float _2950 = (float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f);
      float _2953 = (float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f);
      float _2956 = (_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f);
      float _2962 = exp2(((_2950 * _2922.x) + _2944) * -1.4426950216293335f);
      float _2963 = exp2(((_2953 * _2922.x) + _2944) * -1.4426950216293335f);
      float _2964 = exp2(((_2956 * _2922.x) + _2944) * -1.4426950216293335f);
      float _2980 = sqrt(_2867);
      float _2988 = (_cloudAltitude - (max(((_2980 * _2980) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
      float _3000 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_2839 > 0.0f))) - ((int)(uint)((int)(_2839 < 0.0f))))) * 0.5f))) + _2988;
      if (_2068 < _2988) {
        float _3003 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2838, _2839, _2840));
        float _3009 = select((abs(_3003) < 9.99999993922529e-09f), 1e+08f, ((_3000 - dot(float3(0.0f, 1.0f, 0.0f), float3(_2067, _2068, _2069))) / _3003));
        _3015 = ((_3009 * _2838) + _2067);
        _3016 = _3000;
        _3017 = ((_3009 * _2840) + _2069);
      } else {
        _3015 = _2067;
        _3016 = _2068;
        _3017 = _2069;
      }
      float _3026 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3015 * 4.999999873689376e-05f) + 0.5f), ((_3016 - _2988) / _cloudThickness), ((_3017 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
      float _3030 = _cloudScatteringCoefficient / _distanceScale;
      float _3031 = _distanceScale * -1.4426950216293335f;
      float _3037 = saturate(abs(_2839) * 4.0f);
      float _3039 = (_3037 * _3037) * exp2((_3031 * _3026.x) * _3030);
      float _3046 = ((1.0f - _3039) * saturate(((_2068 - _cloudThickness) - _2988) * 0.10000000149011612f)) + _3039;
      float _3047 = _3046 * (((_2963 * 0.3395099937915802f) + (_2962 * 0.6131200194358826f)) + (_2964 * 0.047370001673698425f));
      float _3048 = _3046 * (((_2963 * 0.9163600206375122f) + (_2962 * 0.07020000368356705f)) + (_2964 * 0.013450000435113907f));
      float _3049 = _3046 * (((_2963 * 0.10958000272512436f) + (_2962 * 0.02061999961733818f)) + (_2964 * 0.8697999715805054f));
      float _3068 = float(saturate(_2437));
      if (((_754 != 0)) && ((!_774))) {
        bool _3070 = (_963 > 0.0f);
        float _3071 = select(_3070, _960, _2718);
        float _3072 = select(_3070, _961, _2719);
        float _3073 = select(_3070, _962, _2720);
        float _3074 = select(_3070, _963, 0.800000011920929f);
        if (_753 > 0.0f) {
          half _3077 = half(_750);
          half _3078 = half(_751);
          half _3079 = half(_752);
          _3085 = _3074;
          _3086 = _3071;
          _3087 = _3072;
          _3088 = _3073;
          _3089 = _3077;
          _3090 = _3078;
          _3091 = _3079;
          _3092 = _753;
          _3093 = float(_3077);
          _3094 = float(_3078);
          _3095 = float(_3079);
          _3096 = dot(float3(_3071, _3072, _3073), float3(_2838, _2839, _2840));
        } else {
          _3085 = _3074;
          _3086 = _3071;
          _3087 = _3072;
          _3088 = _3073;
          _3089 = _2821;
          _3090 = _2822;
          _3091 = _2823;
          _3092 = 0.10000000149011612f;
          _3093 = 1.0f;
          _3094 = 1.0f;
          _3095 = 1.0f;
          _3096 = _3068;
        }
      } else {
        _3085 = 0.800000011920929f;
        _3086 = _2718;
        _3087 = _2719;
        _3088 = _2720;
        _3089 = _2821;
        _3090 = _2822;
        _3091 = _2823;
        _3092 = 0.10000000149011612f;
        _3093 = 1.0f;
        _3094 = 1.0f;
        _3095 = 1.0f;
        _3096 = _3068;
      }
      float _3104 = float(half(saturate(_3096) * 0.31830987334251404f)) * _2804;
      float _3112 = 0.699999988079071f / min(max(max(max(_3093, _3094), _3095), 0.009999999776482582f), 0.699999988079071f);
      float _3123 = (((_3112 * _3094) + -0.03999999910593033f) * _3092) + 0.03999999910593033f;
      float _3125 = _2838 - _210;
      float _3126 = _2839 - _211;
      float _3127 = _2840 - _212;
      float _3129 = rsqrt(dot(float3(_3125, _3126, _3127), float3(_3125, _3126, _3127)));
      float _3130 = _3129 * _3125;
      float _3131 = _3129 * _3126;
      float _3132 = _3129 * _3127;
      float _3133 = -0.0f - _210;
      float _3134 = -0.0f - _211;
      float _3135 = -0.0f - _212;
      float _3140 = saturate(max(9.999999747378752e-06f, dot(float3(_3133, _3134, _3135), float3(_3086, _3087, _3088))));
      float _3142 = saturate(dot(float3(_3086, _3087, _3088), float3(_3130, _3131, _3132)));
      float _3145 = saturate(1.0f - saturate(saturate(dot(float3(_3133, _3134, _3135), float3(_3130, _3131, _3132)))));
      float _3146 = _3145 * _3145;
      float _3148 = (_3146 * _3146) * _3145;
      float _3151 = _3148 * saturate(_3123 * 50.0f);
      float _3152 = 1.0f - _3148;
      float _3160 = saturate(_3096 * _2804);
      float _3161 = _3085 * _3085;
      float _3162 = _3161 * _3161;
      float _3163 = 1.0f - _3161;
      float _3175 = (((_3142 * _3162) - _3142) * _3142) + 1.0f;
      float _3179 = (_3162 / ((_3175 * _3175) * 3.1415927410125732f)) * (0.5f / ((((_3140 * _3163) + _3161) * _3096) + (_3140 * ((_3096 * _3163) + _3161))));
      float _3190 = ((((_3047 * 0.6131200194358826f) + (_3048 * 0.3395099937915802f)) + (_3049 * 0.047370001673698425f)) * _2860) * ((max((((_3152 * ((((_3112 * _3093) + -0.03999999910593033f) * _3092) + 0.03999999910593033f)) + _3151) * _3179), 0.0f) * _3160) + (_3104 * float(_3089)));
      float _3192 = ((((_3047 * 0.07020000368356705f) + (_3048 * 0.9163600206375122f)) + (_3049 * 0.013450000435113907f)) * _2860) * ((max((((_3152 * _3123) + _3151) * _3179), 0.0f) * _3160) + (_3104 * float(_3090)));
      float _3194 = ((((_3047 * 0.02061999961733818f) + (_3048 * 0.10958000272512436f)) + (_3049 * 0.8697999715805054f)) * _2860) * ((max((((_3152 * ((((_3112 * _3095) + -0.03999999910593033f) * _3092) + 0.03999999910593033f)) + _3151) * _3179), 0.0f) * _3160) + (_3104 * float(_3091)));
      float _3199 = dot(float3(_3190, _3192, _3194), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _3200 = min((max(0.0005000000237487257f, _exposure3.w) * 4096.0f), _3199);
      float _3204 = max(9.999999717180685e-10f, _3199);
      float _3205 = (_3200 * _3190) / _3204;
      float _3206 = (_3200 * _3192) / _3204;
      float _3207 = (_3200 * _3194) / _3204;
      if (((_110 == 33)) || ((_110 == 55))) {
        if ((_2826) || ((!(_2826)) && (_sunDirection.y > _moonDirection.y))) {
          _3228 = _sunDirection.x;
          _3229 = _sunDirection.y;
          _3230 = _sunDirection.z;
        } else {
          _3228 = _moonDirection.x;
          _3229 = _moonDirection.y;
          _3230 = _moonDirection.z;
        }
        float _3235 = rsqrt(dot(float3(_173, _174, _175), float3(_173, _174, _175)));
        float _3236 = _3235 * _173;
        float _3237 = _3235 * _174;
        float _3238 = _3235 * _175;
        float _3242 = _173 - (_133 * 0.03999999910593033f);
        float _3243 = _174 - (_134 * 0.03999999910593033f);
        float _3244 = _175 - (_135 * 0.03999999910593033f);
        float _3248 = (_viewPos.x - (_staticShadowPosition[1].x)) + _3242;
        float _3249 = (_viewPos.y - (_staticShadowPosition[1].y)) + _3243;
        float _3250 = (_viewPos.z - (_staticShadowPosition[1].z)) + _3244;
        float _3254 = mad((_shadowProjRelativeTexScale[1][0].z), _3250, mad((_shadowProjRelativeTexScale[1][0].y), _3249, (_3248 * (_shadowProjRelativeTexScale[1][0].x)))) + (_shadowProjRelativeTexScale[1][0].w);
        float _3258 = mad((_shadowProjRelativeTexScale[1][1].z), _3250, mad((_shadowProjRelativeTexScale[1][1].y), _3249, (_3248 * (_shadowProjRelativeTexScale[1][1].x)))) + (_shadowProjRelativeTexScale[1][1].w);
        bool _3269 = ((((((!(_3254 <= _2186))) || ((!(_3254 >= _2185))))) || ((!(_3258 <= _2186))))) || ((!(_3258 >= _2185)));
        float _3277 = (_viewPos.x - (_staticShadowPosition[0].x)) + _3242;
        float _3278 = (_viewPos.y - (_staticShadowPosition[0].y)) + _3243;
        float _3279 = (_viewPos.z - (_staticShadowPosition[0].z)) + _3244;
        float _3283 = mad((_shadowProjRelativeTexScale[0][0].z), _3279, mad((_shadowProjRelativeTexScale[0][0].y), _3278, (_3277 * (_shadowProjRelativeTexScale[0][0].x)))) + (_shadowProjRelativeTexScale[0][0].w);
        float _3287 = mad((_shadowProjRelativeTexScale[0][1].z), _3279, mad((_shadowProjRelativeTexScale[0][1].y), _3278, (_3277 * (_shadowProjRelativeTexScale[0][1].x)))) + (_shadowProjRelativeTexScale[0][1].w);
        bool _3298 = ((((((!(_3283 <= _2186))) || ((!(_3283 >= _2185))))) || ((!(_3287 <= _2186))))) || ((!(_3287 >= _2185)));
        float _3300 = select(((_3298) && (_3269)), 0.0f, 0.0010000000474974513f);
        float _3301 = select(_3298, select(_3269, 0.0f, _3254), _3283);
        float _3302 = select(_3298, select(_3269, 0.0f, _3258), _3287);
        float _3303 = select(_3298, select(_3269, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _3250, mad((_shadowProjRelativeTexScale[1][2].y), _3249, (_3248 * (_shadowProjRelativeTexScale[1][2].x)))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _3279, mad((_shadowProjRelativeTexScale[0][2].y), _3278, (_3277 * (_shadowProjRelativeTexScale[0][2].x)))) + (_shadowProjRelativeTexScale[0][2].w)));
        int _3304 = select(_3298, select(_3269, -1, 1), 0);
        [branch]
        if (!(_3304 == -1)) {
          float _3310 = (_3301 * _shadowSizeAndInvSize.x) + -0.5f;
          float _3311 = (_3302 * _shadowSizeAndInvSize.y) + -0.5f;
          int _3314 = int(floor(_3310));
          int _3315 = int(floor(_3311));
          if (!((((uint)_3314 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_3315 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
            float4 _3325 = __3__36__0__0__g_shadowDepthArray.Load(int4(_3314, _3315, _3304, 0));
            float4 _3327 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_3314) + 1u)), _3315, _3304, 0));
            float4 _3329 = __3__36__0__0__g_shadowDepthArray.Load(int4(_3314, ((int)((uint)(_3315) + 1u)), _3304, 0));
            float4 _3331 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_3314) + 1u)), ((int)((uint)(_3315) + 1u)), _3304, 0));
            _3334 = _3325.x;
            _3335 = _3327.x;
            _3336 = _3329.x;
            _3337 = _3331.x;
          } else {
            _3334 = 0.0f;
            _3335 = 0.0f;
            _3336 = 0.0f;
            _3337 = 0.0f;
          }
          float _3363 = (float4(_invShadowViewProj[_3304][0][0], _invShadowViewProj[_3304][1][0], _invShadowViewProj[_3304][2][0], _invShadowViewProj[_3304][3][0]).x) * _3301;
          float _3367 = (float4(_invShadowViewProj[_3304][0][0], _invShadowViewProj[_3304][1][0], _invShadowViewProj[_3304][2][0], _invShadowViewProj[_3304][3][0]).y) * _3301;
          float _3371 = (float4(_invShadowViewProj[_3304][0][0], _invShadowViewProj[_3304][1][0], _invShadowViewProj[_3304][2][0], _invShadowViewProj[_3304][3][0]).z) * _3301;
          float _3375 = (float4(_invShadowViewProj[_3304][0][0], _invShadowViewProj[_3304][1][0], _invShadowViewProj[_3304][2][0], _invShadowViewProj[_3304][3][0]).w) * _3301;
          float _3378 = mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).w), _3334, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).w), _3302, _3375)) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).w);
          float _3379 = (mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).x), _3334, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).x), _3302, _3363)) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).x)) / _3378;
          float _3380 = (mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).y), _3334, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).y), _3302, _3367)) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).y)) / _3378;
          float _3381 = (mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).z), _3334, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).z), _3302, _3371)) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).z)) / _3378;
          float _3384 = _3301 + (_shadowSizeAndInvSize.z * 4.0f);
          float _3400 = mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).w), _3335, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).w), _3302, ((float4(_invShadowViewProj[_3304][0][0], _invShadowViewProj[_3304][1][0], _invShadowViewProj[_3304][2][0], _invShadowViewProj[_3304][3][0]).w) * _3384))) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).w);
          float _3406 = _3302 - (_shadowSizeAndInvSize.w * 2.0f);
          float _3418 = mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).w), _3336, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).w), _3406, _3375)) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).w);
          float _3422 = ((mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).x), _3336, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).x), _3406, _3363)) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).x)) / _3418) - _3379;
          float _3423 = ((mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).y), _3336, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).y), _3406, _3367)) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).y)) / _3418) - _3380;
          float _3424 = ((mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).z), _3336, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).z), _3406, _3371)) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).z)) / _3418) - _3381;
          float _3425 = ((mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).x), _3335, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).x), _3302, ((float4(_invShadowViewProj[_3304][0][0], _invShadowViewProj[_3304][1][0], _invShadowViewProj[_3304][2][0], _invShadowViewProj[_3304][3][0]).x) * _3384))) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).x)) / _3400) - _3379;
          float _3426 = ((mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).y), _3335, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).y), _3302, ((float4(_invShadowViewProj[_3304][0][0], _invShadowViewProj[_3304][1][0], _invShadowViewProj[_3304][2][0], _invShadowViewProj[_3304][3][0]).y) * _3384))) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).y)) / _3400) - _3380;
          float _3427 = ((mad((float4(_invShadowViewProj[_3304][0][2], _invShadowViewProj[_3304][1][2], _invShadowViewProj[_3304][2][2], _invShadowViewProj[_3304][3][2]).z), _3335, mad((float4(_invShadowViewProj[_3304][0][1], _invShadowViewProj[_3304][1][1], _invShadowViewProj[_3304][2][1], _invShadowViewProj[_3304][3][1]).z), _3302, ((float4(_invShadowViewProj[_3304][0][0], _invShadowViewProj[_3304][1][0], _invShadowViewProj[_3304][2][0], _invShadowViewProj[_3304][3][0]).z) * _3384))) + (float4(_invShadowViewProj[_3304][0][3], _invShadowViewProj[_3304][1][3], _invShadowViewProj[_3304][2][3], _invShadowViewProj[_3304][3][3]).z)) / _3400) - _3381;
          float _3430 = (_3424 * _3426) - (_3423 * _3427);
          float _3433 = (_3422 * _3427) - (_3424 * _3425);
          float _3436 = (_3423 * _3425) - (_3422 * _3426);
          float _3438 = rsqrt(dot(float3(_3430, _3433, _3436), float3(_3430, _3433, _3436)));
          float _3442 = frac(_3310);
          float _3447 = (saturate(dot(float3(_3236, _3237, _3238), float3((_3430 * _3438), (_3433 * _3438), (_3436 * _3438)))) * 0.0020000000949949026f) + _3303;
          float _3460 = saturate(exp2((_3334 - _3447) * 1442695.0f));
          float _3462 = saturate(exp2((_3336 - _3447) * 1442695.0f));
          float _3468 = ((saturate(exp2((_3335 - _3447) * 1442695.0f)) - _3460) * _3442) + _3460;
          _3475 = saturate((((_3462 - _3468) + ((saturate(exp2((_3337 - _3447) * 1442695.0f)) - _3462) * _3442)) * frac(_3311)) + _3468);
          _3476 = _3334;
          _3477 = _3335;
          _3478 = _3336;
          _3479 = _3337;
        } else {
          _3475 = 1.0f;
          _3476 = 0.0f;
          _3477 = 0.0f;
          _3478 = 0.0f;
          _3479 = 0.0f;
        }
        float _3483 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _3244, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _3243, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _3242))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
        float _3487 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _3244, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _3243, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _3242))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
        float _3491 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _3244, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _3243, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _3242))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
        if (!(((((!(_3483 <= _2469))) || ((!(_3483 >= _2468))))) || ((!(_3487 <= _2469))))) {
          bool _3502 = ((_3491 >= -1.0f)) && ((((_3487 >= _2468)) && ((_3491 <= 1.0f))));
          _3510 = select(_3502, 9.999999747378752e-06f, _3300);
          _3511 = select(_3502, _3483, _3301);
          _3512 = select(_3502, _3487, _3302);
          _3513 = select(_3502, _3491, _3303);
          _3514 = select(_3502, 1, _3304);
          _3515 = ((int)(uint)((int)(_3502)));
        } else {
          _3510 = _3300;
          _3511 = _3301;
          _3512 = _3302;
          _3513 = _3303;
          _3514 = _3304;
          _3515 = 0;
        }
        float _3519 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _3244, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _3243, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _3242))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
        float _3523 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _3244, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _3243, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _3242))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
        float _3527 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _3244, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _3243, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _3242))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
        if (!(((((!(_3519 <= _2469))) || ((!(_3519 >= _2468))))) || ((!(_3523 <= _2469))))) {
          bool _3538 = ((_3527 >= -1.0f)) && ((((_3523 >= _2468)) && ((_3527 <= 1.0f))));
          _3546 = select(_3538, 9.999999747378752e-06f, _3510);
          _3547 = select(_3538, _3519, _3511);
          _3548 = select(_3538, _3523, _3512);
          _3549 = select(_3538, _3527, _3513);
          _3550 = select(_3538, 0, _3514);
          _3551 = select(_3538, 1, _3515);
        } else {
          _3546 = _3510;
          _3547 = _3511;
          _3548 = _3512;
          _3549 = _3513;
          _3550 = _3514;
          _3551 = _3515;
        }
        [branch]
        if (!(_3551 == 0)) {
          int _3561 = int(floor((_3547 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
          int _3562 = int(floor((_3548 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
          if (!((((uint)_3561 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_3562 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
            float4 _3572 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_3561, _3562, _3550, 0));
            float4 _3574 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_3561) + 1u)), _3562, _3550, 0));
            float4 _3576 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_3561, ((int)((uint)(_3562) + 1u)), _3550, 0));
            float4 _3578 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_3561) + 1u)), ((int)((uint)(_3562) + 1u)), _3550, 0));
            _3581 = _3572.x;
            _3582 = _3574.x;
            _3583 = _3576.x;
            _3584 = _3578.x;
          } else {
            _3581 = _3476;
            _3582 = _3477;
            _3583 = _3478;
            _3584 = _3479;
          }
          if ((_2826) || ((!(_2826)) && (_sunDirection.y > _moonDirection.y))) {
            _3596 = _sunDirection.x;
            _3597 = _sunDirection.y;
            _3598 = _sunDirection.z;
          } else {
            _3596 = _moonDirection.x;
            _3597 = _moonDirection.y;
            _3598 = _moonDirection.z;
          }
          float _3604 = (_3546 - (saturate(-0.0f - dot(float3(_3596, _3597, _3598), float3(_3236, _3237, _3238))) * 9.999999747378752e-05f)) + _3549;
          _3617 = min(float((bool)(uint)(_3581 > _3604)), min(min(float((bool)(uint)(_3582 > _3604)), float((bool)(uint)(_3583 > _3604))), float((bool)(uint)(_3584 > _3604))));
        } else {
          _3617 = _3475;
        }
        float _3618 = _2726 + _3242;
        float _3619 = _2727 + _3243;
        float _3620 = _2728 + _3244;
        float _3624 = mad((_terrainShadowProjRelativeTexScale[0].z), _3620, mad((_terrainShadowProjRelativeTexScale[0].y), _3619, (_3618 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
        float _3628 = mad((_terrainShadowProjRelativeTexScale[1].z), _3620, mad((_terrainShadowProjRelativeTexScale[1].y), _3619, (_3618 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
        float _3632 = mad((_terrainShadowProjRelativeTexScale[2].z), _3620, mad((_terrainShadowProjRelativeTexScale[2].y), _3619, (_3618 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
        if (saturate(_3624) == _3624) {
          if (((_3632 >= 9.999999747378752e-05f)) && ((((_3632 <= 1.0f)) && ((saturate(_3628) == _3628))))) {
            float _3647 = frac((_3624 * 1024.0f) + -0.5f);
            float4 _3651 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_3624, _3628));
            float _3656 = _3632 + -0.004999999888241291f;
            float _3661 = select((_3651.w > _3656), 1.0f, 0.0f);
            float _3663 = select((_3651.x > _3656), 1.0f, 0.0f);
            float _3670 = ((select((_3651.z > _3656), 1.0f, 0.0f) - _3661) * _3647) + _3661;
            _3676 = saturate((((((select((_3651.y > _3656), 1.0f, 0.0f) - _3663) * _3647) + _3663) - _3670) * frac((_3628 * 1024.0f) + -0.5f)) + _3670);
          } else {
            _3676 = 1.0f;
          }
        } else {
          _3676 = 1.0f;
        }
        uint4 _3682 = __3__36__0__0__g_baseColor.Load(int3((int)(uint(_81 * (1.0f / g_screenSpaceScale.x))), (int)(uint(_82 * (1.0f / g_screenSpaceScale.y))), 0));
        float _3688 = float((uint)((uint)(((uint)((uint)(_3682.x)) >> 8) & 255))) * 0.003921568859368563f;
        float _3691 = float((uint)((uint)(_3682.x & 255))) * 0.003921568859368563f;
        float _3695 = float((uint)((uint)(((uint)((uint)(_3682.y)) >> 8) & 255))) * 0.003921568859368563f;
        float _3696 = _3688 * _3688;
        float _3697 = _3691 * _3691;
        float _3698 = _3695 * _3695;
        if ((_2826) || ((!(_2826)) && (_sunDirection.y > _moonDirection.y))) {
          _3733 = _precomputedAmbient7.y;
        } else {
          _3733 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
        }
        float _3735 = (_earthRadius + _viewPos.y) + _174;
        float _3739 = (_175 * _175) + (_173 * _173);
        float _3741 = sqrt((_3735 * _3735) + _3739);
        float _3746 = dot(float3((_173 / _3741), (_3735 / _3741), (_175 / _3741)), float3(_3228, _3229, _3230));
        float _3749 = min(max(((_3741 - _earthRadius) / _atmosphereThickness), 16.0f), _2877);
        float _3756 = max(_3749, 0.0f);
        float _3762 = (-0.0f - sqrt((_3756 + _2888) * _3756)) / (_3756 + _earthRadius);
        if (_3746 > _3762) {
          _3785 = ((exp2(log2(saturate((_3746 - _3762) / (1.0f - _3762))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
        } else {
          _3785 = ((exp2(log2(saturate((_3762 - _3746) / (_3762 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
        }
        float2 _3788 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_3749 + -16.0f) / _2881)) * 0.5f) * 0.96875f) + 0.015625f), _3785), 0.0f);
        float _3792 = (_2942 * _2941) * _3788.y;
        float _3802 = exp2((_3792 + (_3788.x * _2950)) * -1.4426950216293335f);
        float _3803 = exp2((_3792 + (_3788.x * _2953)) * -1.4426950216293335f);
        float _3804 = exp2((_3792 + (_3788.x * _2956)) * -1.4426950216293335f);
        float _3820 = sqrt(_3739);
        float _3826 = (_cloudAltitude - (max(((_3820 * _3820) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
        float _3836 = _3826 + ((0.5f - (float((int)(((int)(uint)((int)(_3229 > 0.0f))) - ((int)(uint)((int)(_3229 < 0.0f))))) * 0.5f)) * _cloudThickness);
        if (_174 < _3826) {
          float _3839 = dot(float3(0.0f, 1.0f, 0.0f), float3(_3228, _3229, _3230));
          float _3845 = select((abs(_3839) < 9.99999993922529e-09f), 1e+08f, ((_3836 - dot(float3(0.0f, 1.0f, 0.0f), float3(_173, _174, _175))) / _3839));
          _3851 = ((_3845 * _3228) + _173);
          _3852 = _3836;
          _3853 = ((_3845 * _3230) + _175);
        } else {
          _3851 = _173;
          _3852 = _174;
          _3853 = _175;
        }
        float _3860 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3851 * 4.999999873689376e-05f) + 0.5f), ((_3852 - _3826) / _cloudThickness), ((_3853 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
        float _3867 = saturate(abs(_3229) * 4.0f);
        float _3869 = (_3867 * _3867) * exp2((_3031 * _3030) * _3860.x);
        float _3876 = ((1.0f - _3869) * saturate(((_174 - _cloudThickness) - _3826) * 0.10000000149011612f)) + _3869;
        float _3877 = _3876 * (((_3803 * 0.3395099937915802f) + (_3802 * 0.6131200194358826f)) + (_3804 * 0.047370001673698425f));
        float _3878 = _3876 * (((_3803 * 0.9163600206375122f) + (_3802 * 0.07020000368356705f)) + (_3804 * 0.013450000435113907f));
        float _3879 = _3876 * (((_3803 * 0.10958000272512436f) + (_3802 * 0.02061999961733818f)) + (_3804 * 0.8697999715805054f));
        float _3895 = ((max(0.0f, (0.30000001192092896f - dot(float3(_133, _134, _135), float3(_3228, _3229, _3230)))) * 0.1573420912027359f) * saturate(min(_3617, _3676))) * _3733;
        _3906 = (((_3895 * (((_3696 * 0.6131200194358826f) + (_3697 * 0.3395099937915802f)) + (_3698 * 0.047370001673698425f))) * (((_3877 * 0.6131200194358826f) + (_3878 * 0.3395099937915802f)) + (_3879 * 0.047370001673698425f))) + _3205);
        _3907 = (((_3895 * (((_3696 * 0.07020000368356705f) + (_3697 * 0.9163600206375122f)) + (_3698 * 0.013450000435113907f))) * (((_3877 * 0.07020000368356705f) + (_3878 * 0.9163600206375122f)) + (_3879 * 0.013450000435113907f))) + _3206);
        _3908 = (((_3895 * (((_3696 * 0.02061999961733818f) + (_3697 * 0.10958000272512436f)) + (_3698 * 0.8697999715805054f))) * (((_3877 * 0.02061999961733818f) + (_3878 * 0.10958000272512436f)) + (_3879 * 0.8697999715805054f))) + _3207);
      } else {
        _3906 = _3205;
        _3907 = _3206;
        _3908 = _3207;
      }
      float _3909 = (_renderParams2.z * _2136) * _3906;
      float _3910 = (_renderParams2.z * _2137) * _3907;
      float _3911 = (_renderParams2.z * _2138) * _3908;
      float _3915 = _3909 + _2051;
      float _3916 = _3910 + _2052;
      float _3917 = _3911 + _2053;
      _3928 = _2061;
      _3929 = (((max(_2051, _3909) - _3915) * _2063) + _3915);
      _3930 = (((max(_2052, _3910) - _3916) * _2063) + _3916);
      _3931 = (((max(_2053, _3911) - _3917) * _2063) + _3917);
    } else {
      _3928 = 1000.0f;
      _3929 = _2051;
      _3930 = _2052;
      _3931 = _2053;
    }
    if (!_761) {
      __3__38__0__1__g_raytracingHitResultUAV[int2(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))))] = float4(_203.x, _203.y, _203.z, select((_3928 <= 0.0f), 1000.0f, _3928));
    }
    if (((_3928 > 128.0f)) && ((dot(float3(_3929, _3930, _3931), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) == 0.0f))) {
      _3942 = 1;
      while(true) {
        int _3982 = int(floor(((_wrappedViewPos.x + _2067) * ((_clipmapOffsets[_3942]).w)) + ((_clipmapRelativeIndexOffsets[_3942]).x)));
        int _3983 = int(floor(((_wrappedViewPos.y + _2068) * ((_clipmapOffsets[_3942]).w)) + ((_clipmapRelativeIndexOffsets[_3942]).y)));
        int _3984 = int(floor(((_wrappedViewPos.z + _2069) * ((_clipmapOffsets[_3942]).w)) + ((_clipmapRelativeIndexOffsets[_3942]).z)));
        if (!((((((((int)_3982 >= (int)int(((_clipmapOffsets[_3942]).x) + -63.0f))) && (((int)_3982 < (int)int(((_clipmapOffsets[_3942]).x) + 63.0f))))) && (((((int)_3983 >= (int)int(((_clipmapOffsets[_3942]).y) + -31.0f))) && (((int)_3983 < (int)int(((_clipmapOffsets[_3942]).y) + 31.0f))))))) && (((((int)_3984 >= (int)int(((_clipmapOffsets[_3942]).z) + -63.0f))) && (((int)_3984 < (int)int(((_clipmapOffsets[_3942]).z) + 63.0f))))))) {
          if ((uint)(_3942 + 1) < (uint)8) {
            _3942 = (_3942 + 1);
            continue;
          } else {
            _4000 = -10000;
          }
        } else {
          _4000 = _3942;
        }
        if (!((uint)_4000 > (uint)3)) {
          float _4020 = 1.0f / float((uint)(1u << (_4000 & 31)));
          float _4024 = frac(((_invClipmapExtent.z * _2069) + _clipmapUVRelativeOffset.z) * _4020);
          float _4036 = __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _2067) + _clipmapUVRelativeOffset.x) * _4020), (((_invClipmapExtent.y * _2068) + _clipmapUVRelativeOffset.y) * _4020), (((float((uint)(_4000 * 66)) + 1.0f) + ((select((_4024 < 0.0f), 1.0f, 0.0f) + _4024) * 64.0f)) * 0.0037878789007663727f)), 0.0f);
          _4041 = saturate(1.0f - _4036.x);
        } else {
          _4041 = 1.0f;
        }
        float _4044 = _renderParams.w * _4041;
        bool _4045 = (_753 == 0.0f);
        float4 _4053 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(select(_4045, (-0.0f - _210), _960), select(_4045, _211, _961), select(_4045, (-0.0f - _212), _962)), 4.0f);
        _4067 = ((_4044 * select(_4045, 0.03125f, _750)) * _4053.x);
        _4068 = ((_4044 * select(_4045, 0.03125f, _751)) * _4053.y);
        _4069 = ((_4044 * select(_4045, 0.03125f, _752)) * _4053.z);
        // [DAWN_DUSK_GI] Cubemap directional boost + energy floor
        if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
          float _ddFactor = DawnDuskFactor(_sunDirection.y);
          float3 _ddAmbient = DawnDuskAmbientBoost(
            float3(_4067, _4068, _4069),
            float3(_133, _134, _135),
            _sunDirection.xyz,
            _ddFactor,
            _precomputedAmbient0.xyz);
          _4067 = _ddAmbient.x;
          _4068 = _ddAmbient.y;
          _4069 = _ddAmbient.z;
        }
        break;
      }
    } else {
      _4067 = _3929;
      _4068 = _3930;
      _4069 = _3931;
    }
    float _4076 = saturate(1.0f - saturate(_2054));
    float _4080 = (_4076 - (_renderParams2.w * _4076)) + _renderParams2.w;
    float4 _4084 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(_210, _211, _212), 4.0f);
    float _4090 = _renderParams.w * _4080;
    float _4091 = _4090 * _4084.x;
    float _4092 = _4090 * _4084.y;
    float _4093 = _4090 * _4084.z;
    // [DAWN_DUSK_GI] Probe directional boost + energy floor
    if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
      float _ddFactor = DawnDuskFactor(_sunDirection.y);
      float3 _ddAmbient = DawnDuskAmbientBoost(
        float3(_4091, _4092, _4093),
        float3(_133, _134, _135),
        _sunDirection.xyz,
        _ddFactor,
        _precomputedAmbient0.xyz);
      _4091 = _ddAmbient.x;
      _4092 = _ddAmbient.y;
      _4093 = _ddAmbient.z;
    }
    float _4098 = dot(float3(_4091, _4092, _4093), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _4099 = min((max(0.009999999776482582f, _exposure3.w) * 2048.0f), _4098);
    float _4103 = max(9.999999717180685e-10f, _4098);
    float _4111 = __3__36__0__0__g_raytracingDiffuseRayInversePDF.Load(int3(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))), 0));
    float _4113 = _4111.x * 2.0f;
    float _4114 = _4113 * (((_4099 * _4091) / _4103) + (_renderParams2.y * _4067));
    float _4115 = _4113 * (((_4099 * _4092) / _4103) + (_renderParams2.y * _4068));
    float _4116 = _4113 * (((_4099 * _4093) / _4103) + (_renderParams2.y * _4069));
    if (!(_renderParams.y == 0.0f)) {
      float _4121 = saturate(dot(float3(_133, _134, _135), float3(_210, _211, _212)));
      _4126 = (_4121 * _4114);
      _4127 = (_4121 * _4115);
      _4128 = (_4121 * _4116);
    } else {
      _4126 = _4114;
      _4127 = _4115;
      _4128 = _4116;
    }
    // RenoDX: Exterior GI energy compensation
    // The improved ReSTIR convergence over accumulates diffuse bounces.
    // Exteriors become way to bright so as a solution we do the following
    //
    // Apply a luminance based soft compression on the raw hit radiance before it
    // enters the reservoir
    if (RT_QUALITY >= 1.f && RT_GI_STRENGTH > 0.0f) {
      float _rndx_gi_lum = renodx::color::y::from::BT709(float3(_4126, _4127, _4128));
      if (_rndx_gi_lum > RT_GI_KNEE) {
        float _rndx_gi_excess = _rndx_gi_lum - RT_GI_KNEE;
        float _rndx_gi_compressed = RT_GI_KNEE + renodx::math::DivideSafe(_rndx_gi_excess, mad(_rndx_gi_excess, RT_GI_STRENGTH, 1.0f));
        float _rndx_gi_scale = renodx::math::DivideSafe(_rndx_gi_compressed, _rndx_gi_lum, 1.f);
        _4126 *= _rndx_gi_scale;
        _4127 *= _rndx_gi_scale;
        _4128 *= _rndx_gi_scale;
      }
    }
    __3__38__0__1__g_diffuseResultUAV[int2(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))))] = half4((-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _4126)))))), (-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _4127)))))), (-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _4128)))))), half(1.0f - _4080));
    break;
  }
}