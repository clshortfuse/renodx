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
  int _105 = ((uint)((uint)(_98.y)) >> 24) & 127;
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
  float _176 = float((uint)((uint)(((int)(((uint)((uint)(_frameNumber.x)) >> 2) * 71)) & 31)));
  bool _193;
  int _246;
  int _304;
  int _325;
  int _388;
  int _389;
  int _390;
  int _391;
  float _448;
  float _449;
  float _450;
  float _451;
  float _452;
  float _453;
  float _454;
  int _455;
  float _667;
  float _668;
  float _669;
  float _670;
  float _687;
  float _688;
  float _689;
  float _729;
  float _730;
  float _731;
  float _738;
  float _739;
  float _740;
  float _741;
  float _742;
  float _743;
  float _744;
  float _745;
  int _746;
  float _747;
  float _748;
  float _749;
  float _750;
  float _751;
  bool _766;
  float _942;
  float _943;
  float _944;
  float _945;
  float _956;
  float _957;
  float _958;
  float _959;
  float _960;
  float _961;
  float _962;
  float _963;
  float _964;
  int _965;
  int _967;
  int _1028;
  int _1029;
  float _1036;
  float _1096;
  float _1097;
  float _1098;
  float _1099;
  int _1105;
  int _1163;
  int _1200;
  float _1201;
  float _1202;
  float _1203;
  float _1204;
  float _1205;
  int _1207;
  float _1424;
  float _1425;
  float _1444;
  float _1445;
  float _1446;
  float _1447;
  float _1448;
  float _1450;
  float _1451;
  float _1452;
  float _1453;
  float _1454;
  float _1455;
  int _1472;
  int _1535;
  int _1536;
  int _1537;
  int _1538;
  int _1554;
  int _1555;
  int _1556;
  int _1557;
  int _1563;
  int _1626;
  int _1627;
  int _1628;
  int _1629;
  int _1634;
  int _1635;
  int _1636;
  int _1637;
  int _1638;
  int _1641;
  int _1642;
  int _1643;
  int _1644;
  int _1647;
  int _1648;
  int _1649;
  int _1650;
  int _1651;
  bool _1674;
  int _1675;
  int _1676;
  int _1677;
  int _1678;
  int _1679;
  int _1688;
  int _1689;
  int _1690;
  int _1691;
  int _1692;
  float _1751;
  float _1752;
  float _1753;
  float _1754;
  int _1755;
  float _1956;
  float _1957;
  float _1958;
  float _1959;
  float _1976;
  float _1977;
  float _1978;
  float _1979;
  float _2007;
  float _2008;
  float _2009;
  float _2010;
  float _2011;
  bool _2025;
  float _2048;
  float _2049;
  float _2050;
  float _2051;
  float _2133;
  float _2134;
  float _2135;
  float _2278;
  float _2279;
  float _2280;
  float _2281;
  half _2282;
  half _2283;
  half _2284;
  half _2285;
  float _2423;
  float _2424;
  float _2425;
  float _2426;
  float _2427;
  float _2428;
  float _2429;
  float _2430;
  half _2431;
  half _2432;
  half _2433;
  half _2434;
  float _2485;
  float _2486;
  float _2487;
  float _2488;
  int _2489;
  int _2490;
  float _2537;
  float _2538;
  float _2539;
  float _2540;
  int _2541;
  int _2542;
  float _2572;
  float _2573;
  float _2574;
  float _2575;
  float _2694;
  float _2695;
  float _2696;
  float _2715;
  float _2716;
  float _2717;
  float _2718;
  float _2800;
  float _2835;
  float _2836;
  float _2837;
  float _2857;
  float _2914;
  float _3012;
  float _3013;
  float _3014;
  float _3082;
  float _3083;
  float _3084;
  float _3085;
  half _3086;
  half _3087;
  half _3088;
  float _3089;
  float _3090;
  float _3091;
  float _3092;
  float _3093;
  float _3225;
  float _3226;
  float _3227;
  float _3331;
  float _3332;
  float _3333;
  float _3334;
  float _3472;
  float _3473;
  float _3474;
  float _3475;
  float _3476;
  float _3507;
  float _3508;
  float _3509;
  float _3510;
  int _3511;
  int _3512;
  float _3543;
  float _3544;
  float _3545;
  float _3546;
  int _3547;
  int _3548;
  float _3578;
  float _3579;
  float _3580;
  float _3581;
  float _3593;
  float _3594;
  float _3595;
  float _3614;
  float _3673;
  float _3730;
  float _3782;
  float _3848;
  float _3849;
  float _3850;
  float _3903;
  float _3904;
  float _3905;
  float _3925;
  float _3926;
  float _3927;
  float _3928;
  int _3939;
  int _3997;
  float _4038;
  float _4064;
  float _4065;
  float _4066;
  float _4123;
  float _4124;
  float _4125;
  bool _4155;
  int _4156;
  int _4157;
  int _4158;
  int _4159;
  int _4160;
  if (!((uint)_105 > (uint)11) | !((((uint)_105 < (uint)20)) || ((_105 == 107)))) {
    _193 = (_105 == 20);
  } else {
    _193 = true;
  }
  float4 _195 = __3__38__0__1__g_raytracingHitResultUAV.Load(int2(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y))));
  float _201 = rsqrt(dot(float3(_195.x, _195.y, _195.z), float3(_195.x, _195.y, _195.z)));
  float _202 = _201 * _195.x;
  float _203 = _201 * _195.y;
  float _204 = _201 * _195.z;
  bool _205 = (_195.w < 0.0f);
  float _206 = abs(_195.w);
  if (((_206 > 0.0f)) && ((_206 < 10000.0f))) {
    float4 _212 = __3__36__0__0__g_raytracingBaseColor.Load(int3(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)), 0));
    float4 _218 = __3__36__0__0__g_raytracingNormal.Load(int3(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)), 0));
    float _226 = (_218.x * 2.0f) + -1.0f;
    float _227 = (_218.y * 2.0f) + -1.0f;
    float _228 = (_218.z * 2.0f) + -1.0f;
    float _230 = rsqrt(dot(float3(_226, _227, _228), float3(_226, _227, _228)));
    float _231 = _226 * _230;
    float _232 = _227 * _230;
    float _233 = _228 * _230;
    float _234 = select(_205, 0.0f, _231);
    float _235 = select(_205, 0.0f, _232);
    float _236 = select(_205, 0.0f, _233);
    int _238 = (int)(uint)((int)(_212.w > 0.0f));
    float _239 = _202 * _206;
    float _240 = _203 * _206;
    float _241 = _204 * _206;
    float _242 = _239 + _165;
    float _243 = _240 + _166;
    float _244 = _241 + _167;
    _246 = 0;
    while(true) {
      int _286 = int(floor(((_wrappedViewPos.x + _242) * ((_clipmapOffsets[_246]).w)) + ((_clipmapRelativeIndexOffsets[_246]).x)));
      int _287 = int(floor(((_wrappedViewPos.y + _243) * ((_clipmapOffsets[_246]).w)) + ((_clipmapRelativeIndexOffsets[_246]).y)));
      int _288 = int(floor(((_wrappedViewPos.z + _244) * ((_clipmapOffsets[_246]).w)) + ((_clipmapRelativeIndexOffsets[_246]).z)));
      if (!((((((((int)_286 >= (int)int(((_clipmapOffsets[_246]).x) + -63.0f))) && (((int)_286 < (int)int(((_clipmapOffsets[_246]).x) + 63.0f))))) && (((((int)_287 >= (int)int(((_clipmapOffsets[_246]).y) + -31.0f))) && (((int)_287 < (int)int(((_clipmapOffsets[_246]).y) + 31.0f))))))) && (((((int)_288 >= (int)int(((_clipmapOffsets[_246]).z) + -63.0f))) && (((int)_288 < (int)int(((_clipmapOffsets[_246]).z) + 63.0f))))))) {
        if ((uint)(_246 + 1) < (uint)8) {
          _246 = (_246 + 1);
          continue;
        } else {
          _304 = -10000;
        }
      } else {
        _304 = _246;
      }
      float _311 = -0.0f - _202;
      float _312 = -0.0f - _203;
      float _313 = -0.0f - _204;
      float _317 = min(_206, (float((int)((int)(1u << (_304 & 31)))) * _voxelParams.x));
      _325 = 0;
      while(true) {
        int _365 = int(floor(((((_317 * select(_205, _311, _231)) + _242) + _wrappedViewPos.x) * ((_clipmapOffsets[_325]).w)) + ((_clipmapRelativeIndexOffsets[_325]).x)));
        int _366 = int(floor(((((_317 * select(_205, _312, _232)) + _243) + _wrappedViewPos.y) * ((_clipmapOffsets[_325]).w)) + ((_clipmapRelativeIndexOffsets[_325]).y)));
        int _367 = int(floor(((((_317 * select(_205, _313, _233)) + _244) + _wrappedViewPos.z) * ((_clipmapOffsets[_325]).w)) + ((_clipmapRelativeIndexOffsets[_325]).z)));
        if ((((((((int)_365 >= (int)int(((_clipmapOffsets[_325]).x) + -63.0f))) && (((int)_365 < (int)int(((_clipmapOffsets[_325]).x) + 63.0f))))) && (((((int)_366 >= (int)int(((_clipmapOffsets[_325]).y) + -31.0f))) && (((int)_366 < (int)int(((_clipmapOffsets[_325]).y) + 31.0f))))))) && (((((int)_367 >= (int)int(((_clipmapOffsets[_325]).z) + -63.0f))) && (((int)_367 < (int)int(((_clipmapOffsets[_325]).z) + 63.0f)))))) {
          _388 = (_365 & 127);
          _389 = (_366 & 63);
          _390 = (_367 & 127);
          _391 = _325;
        } else {
          if ((uint)(_325 + 1) < (uint)8) {
            _325 = (_325 + 1);
            continue;
          } else {
            _388 = -10000;
            _389 = -10000;
            _390 = -10000;
            _391 = -10000;
          }
        }
        if (((_391 != -10000)) && (((int)_391 < (int)4))) {
          if ((uint)_391 < (uint)6) {
            uint _398 = _391 * 130;
            uint _402 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_388, _389, ((int)(((uint)((int)(_398) | 1)) + (uint)(_390))), 0));
            int _404 = _402.x & 4194303;
            [branch]
            if (!(_404 == 0)) {
              float _410 = float((int)((int)(1u << (_391 & 31)))) * _voxelParams.x;
              _448 = 0.0f;
              _449 = 0.0f;
              _450 = 0.0f;
              _451 = _234;
              _452 = _235;
              _453 = _236;
              _454 = 0.0f;
              _455 = 0;
              while(true) {
                int _460 = __3__37__0__0__g_surfelDataBuffer[((_404 + -1) + _455)]._baseColor;
                int _462 = __3__37__0__0__g_surfelDataBuffer[((_404 + -1) + _455)]._normal;
                int16_t _465 = __3__37__0__0__g_surfelDataBuffer[((_404 + -1) + _455)]._radius;
                if (!(_460 == 0)) {
                  half _468 = __3__37__0__0__g_surfelDataBuffer[((_404 + -1) + _455)]._radiance.z;
                  half _469 = __3__37__0__0__g_surfelDataBuffer[((_404 + -1) + _455)]._radiance.y;
                  half _470 = __3__37__0__0__g_surfelDataBuffer[((_404 + -1) + _455)]._radiance.x;
                  float _476 = float((uint)((uint)(_460 & 255)));
                  float _477 = float((uint)((uint)(((uint)((uint)(_460)) >> 8) & 255)));
                  float _478 = float((uint)((uint)(((uint)((uint)(_460)) >> 16) & 255)));
                  float _503 = select(((_476 * 0.003921568859368563f) < 0.040449999272823334f), (_476 * 0.0003035269910469651f), exp2(log2((_476 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _504 = select(((_477 * 0.003921568859368563f) < 0.040449999272823334f), (_477 * 0.0003035269910469651f), exp2(log2((_477 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _505 = select(((_478 * 0.003921568859368563f) < 0.040449999272823334f), (_478 * 0.0003035269910469651f), exp2(log2((_478 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _517 = (float((uint)((uint)(_462 & 255))) * 0.007874015718698502f) + -1.0f;
                  float _518 = (float((uint)((uint)(((uint)((uint)(_462)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                  float _519 = (float((uint)((uint)(((uint)((uint)(_462)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                  float _521 = rsqrt(dot(float3(_517, _518, _519), float3(_517, _518, _519)));
                  bool _526 = ((_462 & 16777215) == 0);
                  float _530 = float(_470);
                  float _531 = float(_469);
                  float _532 = float(_468);
                  float _536 = (_410 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_465) & 255)));
                  float _552 = (((float((uint)((uint)((uint)((uint)(_460)) >> 24))) * 0.003937007859349251f) + -0.5f) * _410) + ((((((_clipmapOffsets[_391]).x) + -63.5f) + float((int)(((int)(((uint)(_388 + 64)) - (uint)(int((_clipmapOffsets[_391]).x)))) & 127))) * _410) - _viewPos.x);
                  float _553 = (((float((uint)((uint)((uint)((uint)(_462)) >> 24))) * 0.003937007859349251f) + -0.5f) * _410) + ((((((_clipmapOffsets[_391]).y) + -31.5f) + float((int)(((int)(((uint)(_389 + 32)) - (uint)(int((_clipmapOffsets[_391]).y)))) & 63))) * _410) - _viewPos.y);
                  float _554 = (((float((uint16_t)((uint)((uint16_t)((uint)(_465)) >> 8))) * 0.003937007859349251f) + -0.5f) * _410) + ((((((_clipmapOffsets[_391]).z) + -63.5f) + float((int)(((int)(((uint)(_390 + 64)) - (uint)(int((_clipmapOffsets[_391]).z)))) & 127))) * _410) - _viewPos.z);
                  bool _572 = (_218.w == 0.0f);
                  float _573 = select(_572, _311, _451);
                  float _574 = select(_572, _312, _452);
                  float _575 = select(_572, _313, _453);
                  float _578 = ((-0.0f - _165) - _239) + _552;
                  float _581 = ((-0.0f - _166) - _240) + _553;
                  float _584 = ((-0.0f - _167) - _241) + _554;
                  float _585 = dot(float3(_578, _581, _584), float3(_573, _574, _575));
                  float _589 = _578 - (_585 * _573);
                  float _590 = _581 - (_585 * _574);
                  float _591 = _584 - (_585 * _575);
                  float _617 = 1.0f / float((uint)(1u << (_391 & 31)));
                  float _621 = frac(((_invClipmapExtent.z * _554) + _clipmapUVRelativeOffset.z) * _617);
                  float _632 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _552) + _clipmapUVRelativeOffset.x) * _617), (((_invClipmapExtent.y * _553) + _clipmapUVRelativeOffset.y) * _617), (((float((uint)_398) + 1.0f) + ((select((_621 < 0.0f), 1.0f, 0.0f) + _621) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                  float _646 = select(((int)_391 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_311, _312, _313), float3(select(_526, _311, (_521 * _517)), select(_526, _312, (_521 * _518)), select(_526, _313, (_521 * _519))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_589, _590, _591), float3(_589, _590, _591)) < ((_536 * _536) * 16.0f)))) * float((bool)(uint)(_632.x > ((_410 * 0.25f) * (saturate((dot(float3(_530, _531, _532), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                  bool _650 = ((!(_212.w > 0.0f))) || (((_460 & 16777215) == 16777215));
                  float _660 = ((select(_650, (((_504 * 0.3395099937915802f) + (_503 * 0.6131200194358826f)) + (_505 * 0.047370001673698425f)), _212.x) * _530) * _646) + _448;
                  float _661 = ((select(_650, (((_504 * 0.9163600206375122f) + (_503 * 0.07020000368356705f)) + (_505 * 0.013450000435113907f)), _212.y) * _531) * _646) + _449;
                  float _662 = ((select(_650, (((_504 * 0.10958000272512436f) + (_503 * 0.02061999961733818f)) + (_505 * 0.8697999715805054f)), _212.z) * _532) * _646) + _450;
                  float _663 = _646 + _454;
                  if ((uint)(_455 + 1) < (uint)renodx::math::Select(RT_QUALITY >= 1.f, 8.f, 4.f)) {
                    _448 = _660;
                    _449 = _661;
                    _450 = _662;
                    _451 = _573;
                    _452 = _574;
                    _453 = _575;
                    _454 = _663;
                    _455 = (_455 + 1);
                    continue;
                  } else {
                    _667 = _660;
                    _668 = _661;
                    _669 = _662;
                    _670 = _663;
                  }
                } else {
                  _667 = _448;
                  _668 = _449;
                  _669 = _450;
                  _670 = _454;
                }
                if (_670 > 0.0f) {
                  float _673 = 1.0f / _670;
                  _687 = (-0.0f - min(0.0f, (-0.0f - (_667 * _673))));
                  _688 = (-0.0f - min(0.0f, (-0.0f - (_668 * _673))));
                  _689 = (-0.0f - min(0.0f, (-0.0f - (_669 * _673))));
                } else {
                  _687 = _667;
                  _688 = _668;
                  _689 = _669;
                }
                break;
              }
            } else {
              _687 = 0.0f;
              _688 = 0.0f;
              _689 = 0.0f;
            }
          } else {
            _687 = 0.0f;
            _688 = 0.0f;
            _689 = 0.0f;
          }
          float _693 = max(9.999999974752427e-07f, (_exposure3.w * 0.0010000000474974513f));
          float _694 = max(_693, _687);
          float _695 = max(_693, _688);
          float _696 = max(_693, _689);
          float _699 = dot(float3(_694, _695, _696), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
          float _700 = min((max(0.0005000000237487257f, _exposure3.w) * 512.0f), _699);
          float _704 = max(9.999999717180685e-10f, _699);
          float _705 = (_700 * _694) / _704;
          float _706 = (_700 * _695) / _704;
          float _707 = (_700 * _696) / _704;
          if (saturate(_218.w) == 0.0f) {
            float _721 = (exp2((saturate(saturate(_212.w)) * 20.0f) + -8.0f) + -0.00390625f) * (1.0f / (((_206 * _206) * 0.10000000149011612f) + 1.0f));
            _729 = ((_721 * _212.x) + _705);
            _730 = ((_721 * _212.y) + _706);
            _731 = ((_721 * _212.z) + _707);
          } else {
            _729 = _705;
            _730 = _706;
            _731 = _707;
          }
          _738 = _234;
          _739 = _235;
          _740 = _236;
          _741 = _218.w;
          _742 = _212.x;
          _743 = _212.y;
          _744 = _212.z;
          _745 = _212.w;
          _746 = _238;
          _747 = (_renderParams2.y * _729);
          _748 = (_renderParams2.y * _730);
          _749 = (_renderParams2.y * _731);
          _750 = 1.0f;
          _751 = _206;
        } else {
          _738 = _234;
          _739 = _235;
          _740 = _236;
          _741 = _218.w;
          _742 = _212.x;
          _743 = _212.y;
          _744 = _212.z;
          _745 = _212.w;
          _746 = _238;
          _747 = 0.0f;
          _748 = 0.0f;
          _749 = 0.0f;
          _750 = 1.0f;
          _751 = _206;
        }
        break;
      }
      break;
    }
  } else {
    _738 = 0.0f;
    _739 = 0.0f;
    _740 = 0.0f;
    _741 = 0.0f;
    _742 = 0.0f;
    _743 = 0.0f;
    _744 = 0.0f;
    _745 = 0.0f;
    _746 = 0;
    _747 = 0.0f;
    _748 = 0.0f;
    _749 = 0.0f;
    _750 = 0.0f;
    _751 = 0.0f;
  }
  bool _753 = (_751 > 0.0f);
  if (((_170 > (_lightingParams.z * 0.875f))) && ((!_753))) {
    _766 = (_170 < (_voxelParams.x * 11585.1259765625f));
  } else {
    _766 = false;
  }
  float _770 = (_751 * _202) + _165;
  float _771 = (_751 * _203) + _166;
  float _772 = (_751 * _204) + _167;
  float _808 = mad((_viewProjRelativePrev[3].z), _772, mad((_viewProjRelativePrev[3].y), _771, ((_viewProjRelativePrev[3].x) * _770))) + (_viewProjRelativePrev[3].w);
  float _809 = (mad((_viewProjRelativePrev[0].z), _772, mad((_viewProjRelativePrev[0].y), _771, ((_viewProjRelativePrev[0].x) * _770))) + (_viewProjRelativePrev[0].w)) / _808;
  float _810 = (mad((_viewProjRelativePrev[1].z), _772, mad((_viewProjRelativePrev[1].y), _771, ((_viewProjRelativePrev[1].x) * _770))) + (_viewProjRelativePrev[1].w)) / _808;
  float _811 = (mad((_viewProjRelativePrev[2].z), _772, mad((_viewProjRelativePrev[2].y), _771, ((_viewProjRelativePrev[2].x) * _770))) + (_viewProjRelativePrev[2].w)) / _808;
  float _814 = (_809 * 0.5f) + 0.5f;
  float _815 = 0.5f - (_810 * 0.5f);
  bool __defer_765_828 = false;
  if (_205) {
    if (_753) {
      __defer_765_828 = true;
    } else {
      _956 = _751;
      _957 = _738;
      _958 = _739;
      _959 = _740;
      _960 = _741;
      _961 = 0.0f;
      _962 = 0.0f;
      _963 = 0.0f;
      _964 = 0.0f;
      _965 = 0;
    }
  } else {
    if ((_753) && ((((_811 > 0.0f)) && ((((((_814 >= 0.0f)) && ((_814 <= 1.0f)))) && ((((_815 >= 0.0f)) && ((_815 <= 1.0f))))))))) {
      __defer_765_828 = true;
    } else {
      _956 = _751;
      _957 = _738;
      _958 = _739;
      _959 = _740;
      _960 = _741;
      _961 = 0.0f;
      _962 = 0.0f;
      _963 = 0.0f;
      _964 = 0.0f;
      _965 = 0;
    }
  }
  if (__defer_765_828) {
    uint2 _838 = __3__36__0__0__g_normalDepthPrev.Load(int3(int(((_809 * 0.25f) + 0.25f) * _bufferSizeAndInvSize.x), int((0.25f - (_810 * 0.25f)) * _bufferSizeAndInvSize.y), 0));
    float _844 = _nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_838.y & 16777215))) * 5.960465188081798e-08f));
    if (((_811 > 0.0f)) && ((((((_814 >= 0.0f)) && ((_814 <= 1.0f)))) && ((((_815 >= 0.0f)) && ((_815 <= 1.0f))))))) {
      if ((((_844 - dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z))) > 0.0f)) && ((abs(_844 - _808) < max(0.5f, (_808 * 0.05000000074505806f))))) {
        float4 _875 = __3__36__0__0__g_sceneColor.SampleLevel(__3__40__0__0__g_samplerClamp, float2(_814, _815), 0.0f);
        if (!(!(_875.w >= 0.0f))) {
          uint2 _892 = __3__36__0__0__g_normalDepth.Load(int3((int)(uint(((g_screenSpaceScale.x * _bufferSizeAndInvSize.x) * _814) + 0.5f)), (int)(uint(((g_screenSpaceScale.y * _bufferSizeAndInvSize.y) * _815) + 0.5f)), 0));
          float _909 = min(1.0f, ((float((uint)((uint)(_892.x & 1023))) * 0.001956947147846222f) + -1.0f));
          float _910 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_892.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _911 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_892.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _913 = rsqrt(dot(float3(_909, _910, _911), float3(_909, _910, _911)));
          float _914 = _913 * _909;
          float _915 = _913 * _910;
          float _916 = _913 * _911;
          float _925 = select((dot(float3((-0.0f - _202), (-0.0f - _203), (-0.0f - _204)), float3(_914, _915, _916)) > 0.20000000298023224f), 1.0f, 0.0f);
          float _927 = saturate(_170 * 0.009999999776482582f);
          float _932 = _nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_892.y & 16777215))) * 5.960465188081798e-08f));
          if (_205) {
            _942 = _914;
            _943 = _915;
            _944 = _916;
            _945 = 0.800000011920929f;
          } else {
            _942 = _738;
            _943 = _739;
            _944 = _740;
            _945 = _741;
          }
          float _946 = _renderParams2.x * _renderParams2.x;
          float _947 = float((bool)(uint)(abs(_nearFarProj.x - _932) < (_932 * 0.5f))) * ((_925 - (_925 * _927)) + _927);
          _956 = ((_751 * 0.9998999834060669f) * _renderParams2.x);
          _957 = _942;
          _958 = _943;
          _959 = _944;
          _960 = _945;
          _961 = ((_947 * min(10000.0f, _875.x)) * _946);
          _962 = ((_947 * min(10000.0f, _875.y)) * _946);
          _963 = ((_947 * min(10000.0f, _875.z)) * _946);
          _964 = _946;
          _965 = 1;
        } else {
          _956 = _751;
          _957 = _738;
          _958 = _739;
          _959 = _740;
          _960 = _741;
          _961 = 0.0f;
          _962 = 0.0f;
          _963 = 0.0f;
          _964 = 0.0f;
          _965 = 0;
        }
      } else {
        _956 = _751;
        _957 = _738;
        _958 = _739;
        _959 = _740;
        _960 = _741;
        _961 = 0.0f;
        _962 = 0.0f;
        _963 = 0.0f;
        _964 = 0.0f;
        _965 = 0;
      }
    } else {
      _956 = _751;
      _957 = _738;
      _958 = _739;
      _959 = _740;
      _960 = _741;
      _961 = 0.0f;
      _962 = 0.0f;
      _963 = 0.0f;
      _964 = 0.0f;
      _965 = 0;
    }
  }
  _967 = 0;
  while(true) {
    int _1007 = int(floor(((_wrappedViewPos.x + _165) * ((_clipmapOffsets[_967]).w)) + ((_clipmapRelativeIndexOffsets[_967]).x)));
    int _1008 = int(floor(((_wrappedViewPos.y + _166) * ((_clipmapOffsets[_967]).w)) + ((_clipmapRelativeIndexOffsets[_967]).y)));
    int _1009 = int(floor(((_wrappedViewPos.z + _167) * ((_clipmapOffsets[_967]).w)) + ((_clipmapRelativeIndexOffsets[_967]).z)));
    if ((((((((int)_1007 >= (int)int(((_clipmapOffsets[_967]).x) + -63.0f))) && (((int)_1007 < (int)int(((_clipmapOffsets[_967]).x) + 63.0f))))) && (((((int)_1008 >= (int)int(((_clipmapOffsets[_967]).y) + -31.0f))) && (((int)_1008 < (int)int(((_clipmapOffsets[_967]).y) + 31.0f))))))) && (((((int)_1009 >= (int)int(((_clipmapOffsets[_967]).z) + -63.0f))) && (((int)_1009 < (int)int(((_clipmapOffsets[_967]).z) + 63.0f)))))) {
      _1028 = (_1007 & 127);
      _1029 = _967;
    } else {
      if ((uint)(_967 + 1) < (uint)8) {
        _967 = (_967 + 1);
        continue;
      } else {
        _1028 = -10000;
        _1029 = -10000;
      }
    }
    if (!(_1028 == -10000)) {
      _1036 = float((int)((int)(1u << (_1029 & 31))));
    } else {
      _1036 = 1.0f;
    }
    float _1042 = select(_193, (((frac(frac(dot(float2(((_176 * 32.665000915527344f) + _71), ((_176 * 11.8149995803833f) + _72)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 2.0f) * _1036) * _voxelParams.x), 0.0f);
    if (_766) {
      float _1044 = _lightingParams.z * 1.3434898853302002f;
      float _1045 = -0.0f - _1044;
      if (((((_167 > _1045)) && ((_167 < _1044)))) && ((((((_165 > _1045)) && ((_165 < _1044)))) && ((((_166 > _1045)) && ((_166 < _1044))))))) {
        float _1058 = 1.0f / _202;
        float _1059 = 1.0f / _203;
        float _1060 = 1.0f / _204;
        float _1064 = _1058 * (_1045 - _165);
        float _1065 = _1059 * (_1045 - _166);
        float _1066 = _1060 * (_1045 - _167);
        float _1070 = _1058 * (_1044 - _165);
        float _1071 = _1059 * (_1044 - _166);
        float _1072 = _1060 * (_1044 - _167);
        float _1082 = min(min(max(_1064, _1070), max(_1065, _1071)), max(_1066, _1072));
        if (((_1082 > 0.0f)) && ((((_1082 >= 0.0f)) && ((max(max(min(_1064, _1070), min(_1065, _1071)), min(_1066, _1072)) <= _1082))))) {
          _1096 = _1082;
          _1097 = ((_1082 * _202) + _165);
          _1098 = ((_1082 * _203) + _166);
          _1099 = ((_1082 * _204) + _167);
        } else {
          _1096 = 0.0f;
          _1097 = _165;
          _1098 = _166;
          _1099 = _167;
        }
      } else {
        _1096 = 0.0f;
        _1097 = _165;
        _1098 = _166;
        _1099 = _167;
      }
      float _1103 = select((((_956 > 0.0f)) && ((_964 >= 1.0f))), _956, 256.0f);
      _1105 = 0;
      while(true) {
        int _1145 = int(floor(((_wrappedViewPos.x + _1097) * ((_clipmapOffsets[_1105]).w)) + ((_clipmapRelativeIndexOffsets[_1105]).x)));
        int _1146 = int(floor(((_wrappedViewPos.y + _1098) * ((_clipmapOffsets[_1105]).w)) + ((_clipmapRelativeIndexOffsets[_1105]).y)));
        int _1147 = int(floor(((_wrappedViewPos.z + _1099) * ((_clipmapOffsets[_1105]).w)) + ((_clipmapRelativeIndexOffsets[_1105]).z)));
        if (!((((((((int)_1145 >= (int)int(((_clipmapOffsets[_1105]).x) + -63.0f))) && (((int)_1145 < (int)int(((_clipmapOffsets[_1105]).x) + 63.0f))))) && (((((int)_1146 >= (int)int(((_clipmapOffsets[_1105]).y) + -31.0f))) && (((int)_1146 < (int)int(((_clipmapOffsets[_1105]).y) + 31.0f))))))) && (((((int)_1147 >= (int)int(((_clipmapOffsets[_1105]).z) + -63.0f))) && (((int)_1147 < (int)int(((_clipmapOffsets[_1105]).z) + 63.0f))))))) {
          if ((uint)(_1105 + 1) < (uint)8) {
            _1105 = (_1105 + 1);
            continue;
          } else {
            _1163 = -10000;
          }
        } else {
          _1163 = _1105;
        }
        if (!(((_1163 == -10000)) || (((int)_1163 > (int)4)))) {
          float _1173 = _1097 + (_1042 * _202);
          float _1174 = _1098 + (_1042 * _203);
          float _1175 = _1099 + (_1042 * _204);
          bool _1179 = (_202 == 0.0f);
          bool _1180 = (_203 == 0.0f);
          bool _1181 = (_204 == 0.0f);
          float _1182 = select(_1179, 0.0f, (1.0f / _202));
          float _1183 = select(_1180, 0.0f, (1.0f / _203));
          float _1184 = select(_1181, 0.0f, (1.0f / _204));
          bool _1185 = (_202 > 0.0f);
          bool _1186 = (_203 > 0.0f);
          bool _1187 = (_204 > 0.0f);
          if (_1103 > 0.0f) {
            _1200 = 0;
            _1201 = 0.0f;
            _1202 = 0.0f;
            _1203 = _1175;
            _1204 = _1174;
            _1205 = _1173;
            while(true) {
              _1207 = 0;
              while(true) {
                float _1232 = ((_wrappedViewPos.x + _1205) * ((_clipmapOffsets[_1207]).w)) + ((_clipmapRelativeIndexOffsets[_1207]).x);
                float _1233 = ((_wrappedViewPos.y + _1204) * ((_clipmapOffsets[_1207]).w)) + ((_clipmapRelativeIndexOffsets[_1207]).y);
                float _1234 = ((_wrappedViewPos.z + _1203) * ((_clipmapOffsets[_1207]).w)) + ((_clipmapRelativeIndexOffsets[_1207]).z);
                bool __defer_1206_1249 = false;
                if (!(((_1234 >= (((_clipmapOffsets[_1207]).z) + -63.0f))) && ((((_1232 >= (((_clipmapOffsets[_1207]).x) + -63.0f))) && ((_1233 >= (((_clipmapOffsets[_1207]).y) + -31.0f)))))) || ((((_1234 >= (((_clipmapOffsets[_1207]).z) + -63.0f))) && ((((_1232 >= (((_clipmapOffsets[_1207]).x) + -63.0f))) && ((_1233 >= (((_clipmapOffsets[_1207]).y) + -31.0f)))))) && (!(((_1234 < (((_clipmapOffsets[_1207]).z) + 63.0f))) && ((((_1232 < (((_clipmapOffsets[_1207]).x) + 63.0f))) && ((_1233 < (((_clipmapOffsets[_1207]).y) + 31.0f))))))))) {
                  __defer_1206_1249 = true;
                } else {
                  if (_1207 == -10000) {
                    _1444 = _1202;
                    _1445 = _1203;
                    _1446 = _1204;
                    _1447 = _1205;
                    _1448 = _1201;
                    _1450 = _1444;
                    _1451 = _1445;
                    _1452 = _1446;
                    _1453 = _1447;
                    _1454 = _1448;
                    _1455 = -10000.0f;
                  } else {
                    float _1257 = float((int)((int)(1u << (_1207 & 31))));
                    float _1258 = _1257 * _voxelParams.x;
                    float _1259 = 1.0f / _1257;
                    float _1260 = _voxelParams.y * 0.0078125f;
                    float _1269 = _1259 * ((_1205 * _1260) + _clipmapUVRelativeOffset.x);
                    float _1270 = _1259 * (((_voxelParams.y * 0.015625f) * _1204) + _clipmapUVRelativeOffset.y);
                    float _1271 = _1259 * ((_1203 * _1260) + _clipmapUVRelativeOffset.z);
                    float _1272 = _1269 * 64.0f;
                    float _1273 = _1270 * 32.0f;
                    float _1274 = _1271 * 64.0f;
                    int _1278 = int(floor(_1272));
                    int _1279 = int(floor(_1273));
                    int _1280 = int(floor(_1274));
                    uint4 _1287 = __3__36__0__0__g_axisAlignedDistanceTextures.Load(int4((_1278 & 63), (_1279 & 31), ((_1280 & 63) | (_1207 << 6)), 0));
                    float _1304 = saturate(float((uint)((uint)((uint)((uint)(_1287.w)) >> 2))) * 0.01587301678955555f);
                    float _1327 = _1272 - float((int)(_1278));
                    float _1328 = _1273 - float((int)(_1279));
                    float _1329 = _1274 - float((int)(_1280));
                    float _1360 = max(((_1258 * 0.5f) * min(min(select(_1179, 999999.0f, ((select(_1185, 1.0f, 0.0f) - frac(_1269 * 256.0f)) * _1182)), select(_1180, 999999.0f, ((select(_1186, 1.0f, 0.0f) - frac(_1270 * 128.0f)) * _1183))), select(_1181, 999999.0f, ((select(_1187, 1.0f, 0.0f) - frac(_1271 * 256.0f)) * _1184)))), ((_1258 * 2.0f) * min(min(select(_1179, 999999.0f, (select(_1185, ((0.009999999776482582f - _1327) + float((uint)((uint)(((uint)((uint)(_1287.x)) >> 4) & 15)))), ((0.9900000095367432f - _1327) - float((uint)((uint)(_1287.x & 15))))) * _1182)), select(_1180, 999999.0f, (select(_1186, ((0.009999999776482582f - _1328) + float((uint)((uint)(((uint)((uint)(_1287.y)) >> 4) & 15)))), ((0.9900000095367432f - _1328) - float((uint)((uint)(_1287.y & 15))))) * _1183))), select(_1181, 999999.0f, (select(_1187, ((0.009999999776482582f - _1329) + float((uint)((uint)(((uint)((uint)(_1287.z)) >> 4) & 15)))), ((0.9900000095367432f - _1329) - float((uint)((uint)(_1287.z & 15))))) * _1184)))));
                    float _1362 = float((bool)(uint)(_1304 > 0.0f));
                    if ((((uint)_1200 < (uint)16)) || ((_1202 < min(32.0f, (_1258 * 32.0f))))) {
                      float _1369 = frac(_1271);
                      float _1381 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_1269, _1270, (((float((uint)(_1207 * 130)) + 1.0f) + ((select((_1369 < 0.0f), 1.0f, 0.0f) + _1369) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                      float _1387 = _1202 * 0.009999999776482582f;
                      float _1388 = 1.0f / _1258;
                      float _1404 = (_1381.x + ((_170 * _170) * 0.00019999999494757503f)) / (((max(((_1258 * 1.0606600046157837f) * saturate((_1202 * 0.5f) + 0.5f)), _1387) - _1387) * saturate(((max(1.0f, (_1388 * 0.5f)) * _1388) * min(_1202, max(0.0f, (_1103 - _1202)))) + -1.0f)) + _1387);
                      float _1410 = saturate((saturate(1.0f - (_1404 * _1404)) * _1362) + _1201);
                      if (!((((int)_1207 > (int)2)) || ((_1381.x > _1258)))) {
                        _1424 = _1410;
                        _1425 = min(_1360, _1381.x);
                      } else {
                        _1424 = _1410;
                        _1425 = _1360;
                      }
                    } else {
                      if (!((_1287.w & 1) == 0)) {
                        _1424 = saturate((_1362 * 0.5f) + _1201);
                        _1425 = _1360;
                      } else {
                        _1424 = _1201;
                        _1425 = _1360;
                      }
                    }
                    if (!(_1424 >= 0.5f)) {
                      float _1430 = max(_1425, (_voxelParams.x * 0.05000000074505806f));
                      float _1431 = _1430 + _1202;
                      float _1435 = (_1430 * _202) + _1205;
                      float _1436 = (_1430 * _203) + _1204;
                      float _1437 = (_1430 * _204) + _1203;
                      if ((((uint)(_1200 + 1) < (uint)192)) && ((_1431 < _1103))) {
                        _1200 = (_1200 + 1);
                        _1201 = _1424;
                        _1202 = _1431;
                        _1203 = _1437;
                        _1204 = _1436;
                        _1205 = _1435;
                        __loop_jump_target = 1199;
                        break;
                      } else {
                        _1444 = _1431;
                        _1445 = _1437;
                        _1446 = _1436;
                        _1447 = _1435;
                        _1448 = _1424;
                        _1450 = _1444;
                        _1451 = _1445;
                        _1452 = _1446;
                        _1453 = _1447;
                        _1454 = _1448;
                        _1455 = -10000.0f;
                      }
                    } else {
                      _1450 = _1202;
                      _1451 = _1203;
                      _1452 = _1204;
                      _1453 = _1205;
                      _1454 = _1304;
                      _1455 = float((int)(_1207));
                    }
                  }
                }
                if (__defer_1206_1249) {
                  if ((int)(_1207 + 1) < (int)8) {
                    _1207 = (_1207 + 1);
                    continue;
                  } else {
                    _1450 = _1202;
                    _1451 = _1203;
                    _1452 = _1204;
                    _1453 = _1205;
                    _1454 = _1201;
                    _1455 = -10000.0f;
                  }
                }
                break;
              }
              if (__loop_jump_target == 1199) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
              break;
            }
          } else {
            _1450 = 0.0f;
            _1451 = _1175;
            _1452 = _1174;
            _1453 = _1173;
            _1454 = 0.0f;
            _1455 = -10000.0f;
          }
          int _1456 = int(_1455);
          if ((uint)_1456 < (uint)8) {
            float _1459 = _voxelParams.x * 0.5f;
            float _1463 = _1453 - (_1459 * _202);
            float _1464 = _1452 - (_1459 * _203);
            float _1465 = _1451 - (_1459 * _204);
            if ((int)_1456 < (int)6) {
              _1472 = 0;
              while(true) {
                int _1512 = int(floor(((_wrappedViewPos.x + _1463) * ((_clipmapOffsets[_1472]).w)) + ((_clipmapRelativeIndexOffsets[_1472]).x)));
                int _1513 = int(floor(((_wrappedViewPos.y + _1464) * ((_clipmapOffsets[_1472]).w)) + ((_clipmapRelativeIndexOffsets[_1472]).y)));
                int _1514 = int(floor(((_wrappedViewPos.z + _1465) * ((_clipmapOffsets[_1472]).w)) + ((_clipmapRelativeIndexOffsets[_1472]).z)));
                if ((((((((int)_1512 >= (int)int(((_clipmapOffsets[_1472]).x) + -63.0f))) && (((int)_1512 < (int)int(((_clipmapOffsets[_1472]).x) + 63.0f))))) && (((((int)_1513 >= (int)int(((_clipmapOffsets[_1472]).y) + -31.0f))) && (((int)_1513 < (int)int(((_clipmapOffsets[_1472]).y) + 31.0f))))))) && (((((int)_1514 >= (int)int(((_clipmapOffsets[_1472]).z) + -63.0f))) && (((int)_1514 < (int)int(((_clipmapOffsets[_1472]).z) + 63.0f)))))) {
                  _1535 = (_1512 & 127);
                  _1536 = (_1513 & 63);
                  _1537 = (_1514 & 127);
                  _1538 = _1472;
                } else {
                  if ((uint)(_1472 + 1) < (uint)8) {
                    _1472 = (_1472 + 1);
                    continue;
                  } else {
                    _1535 = -10000;
                    _1536 = -10000;
                    _1537 = -10000;
                    _1538 = -10000;
                  }
                }
                if (!((uint)_1538 > (uint)5)) {
                  uint _1548 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1535, _1536, ((int)(((uint)(((int)(_1538 * 130)) | 1)) + (uint)(_1537))), 0));
                  bool _1551 = ((_1548.x & 4194303) == 0);
                  [branch]
                  if (!_1551) {
                    _1554 = _1535;
                    _1555 = _1536;
                    _1556 = _1537;
                    _1557 = _1538;
                  } else {
                    _1554 = -10000;
                    _1555 = -10000;
                    _1556 = -10000;
                    _1557 = -10000;
                  }
                  float _1558 = _1459 * float((int)((int)(1u << (_1538 & 31))));
                  _1563 = 0;
                  while(true) {
                    int _1603 = int(floor((((_1463 - _1558) + _wrappedViewPos.x) * ((_clipmapOffsets[_1563]).w)) + ((_clipmapRelativeIndexOffsets[_1563]).x)));
                    int _1604 = int(floor((((_1464 - _1558) + _wrappedViewPos.y) * ((_clipmapOffsets[_1563]).w)) + ((_clipmapRelativeIndexOffsets[_1563]).y)));
                    int _1605 = int(floor((((_1465 - _1558) + _wrappedViewPos.z) * ((_clipmapOffsets[_1563]).w)) + ((_clipmapRelativeIndexOffsets[_1563]).z)));
                    if ((((((((int)_1603 >= (int)int(((_clipmapOffsets[_1563]).x) + -63.0f))) && (((int)_1603 < (int)int(((_clipmapOffsets[_1563]).x) + 63.0f))))) && (((((int)_1604 >= (int)int(((_clipmapOffsets[_1563]).y) + -31.0f))) && (((int)_1604 < (int)int(((_clipmapOffsets[_1563]).y) + 31.0f))))))) && (((((int)_1605 >= (int)int(((_clipmapOffsets[_1563]).z) + -63.0f))) && (((int)_1605 < (int)int(((_clipmapOffsets[_1563]).z) + 63.0f)))))) {
                      _1626 = (_1603 & 127);
                      _1627 = (_1604 & 63);
                      _1628 = (_1605 & 127);
                      _1629 = _1563;
                    } else {
                      if ((uint)(_1563 + 1) < (uint)8) {
                        _1563 = (_1563 + 1);
                        continue;
                      } else {
                        _1626 = -10000;
                        _1627 = -10000;
                        _1628 = -10000;
                        _1629 = -10000;
                      }
                    }
                    if (!((uint)_1629 > (uint)5)) {
                      if (_1551) {
                        _1634 = 0;
                        _1635 = _1557;
                        _1636 = _1556;
                        _1637 = _1555;
                        _1638 = _1554;
                        while(true) {
                          _1647 = 0;
                          _1648 = _1635;
                          _1649 = _1636;
                          _1650 = _1637;
                          _1651 = _1638;
                          while(true) {
                            if (!((((uint)(_1647 + _1627) > (uint)63)) || (((uint)(_1626 | (_1634 + _1628)) > (uint)127)))) {
                              uint _1669 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1626, (_1647 + _1627), ((int)(((uint)(_1634 + _1628)) + ((uint)(((int)(_1629 * 130)) | 1)))), 0));
                              int _1671 = _1669.x & 4194303;
                              _1674 = (_1671 != 0);
                              _1675 = _1671;
                              _1676 = _1629;
                              _1677 = (_1634 + _1628);
                              _1678 = (_1647 + _1627);
                              _1679 = _1626;
                            } else {
                              _1674 = false;
                              _1675 = 0;
                              _1676 = 0;
                              _1677 = 0;
                              _1678 = 0;
                              _1679 = 0;
                            }
                            if (!_1674) {
                              if (!((((uint)(_1647 + _1627) > (uint)63)) || (((uint)((_1626 + 1) | (_1634 + _1628)) > (uint)127)))) {
                                uint _4150 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((_1626 + 1), (_1647 + _1627), ((int)(((uint)(_1634 + _1628)) + ((uint)(((int)(_1629 * 130)) | 1)))), 0));
                                int _4152 = _4150.x & 4194303;
                                _4155 = (_4152 != 0);
                                _4156 = _4152;
                                _4157 = _1629;
                                _4158 = (_1634 + _1628);
                                _4159 = (_1647 + _1627);
                                _4160 = (_1626 + 1);
                              } else {
                                _4155 = false;
                                _4156 = 0;
                                _4157 = 0;
                                _4158 = 0;
                                _4159 = 0;
                                _4160 = 0;
                              }
                              if (!_4155) {
                                _1688 = _1651;
                                _1689 = _1650;
                                _1690 = _1649;
                                _1691 = _1648;
                                _1692 = 0;
                              } else {
                                _1688 = _4160;
                                _1689 = _4159;
                                _1690 = _4158;
                                _1691 = _4157;
                                _1692 = _4156;
                              }
                            } else {
                              _1688 = _1679;
                              _1689 = _1678;
                              _1690 = _1677;
                              _1691 = _1676;
                              _1692 = _1675;
                            }
                            if ((((int)(_1647 + 1) < (int)2)) && ((_1692 == 0))) {
                              _1647 = (_1647 + 1);
                              _1648 = _1691;
                              _1649 = _1690;
                              _1650 = _1689;
                              _1651 = _1688;
                              continue;
                            }
                            if ((((int)(_1634 + 1) < (int)2)) && ((_1692 == 0))) {
                              _1634 = (_1634 + 1);
                              _1635 = _1691;
                              _1636 = _1690;
                              _1637 = _1689;
                              _1638 = _1688;
                              __loop_jump_target = 1633;
                              break;
                            }
                            _1641 = _1691;
                            _1642 = _1690;
                            _1643 = _1689;
                            _1644 = _1688;
                            break;
                          }
                          if (__loop_jump_target == 1633) {
                            __loop_jump_target = -1;
                            continue;
                          }
                          if (__loop_jump_target != -1) {
                            break;
                          }
                          break;
                        }
                      } else {
                        _1641 = _1557;
                        _1642 = _1556;
                        _1643 = _1555;
                        _1644 = _1554;
                      }
                      if ((uint)_1641 < (uint)6) {
                        uint _1698 = _1641 * 130;
                        uint _1702 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1644, _1643, ((int)(((uint)((int)(_1698) | 1)) + (uint)(_1642))), 0));
                        int _1704 = _1702.x & 4194303;
                        [branch]
                        if (!(_1704 == 0)) {
                          float _1710 = float((int)((int)(1u << (_1641 & 31)))) * _voxelParams.x;
                          float _1747 = -0.0f - _202;
                          float _1748 = -0.0f - _203;
                          float _1749 = -0.0f - _204;
                          _1751 = 0.0f;
                          _1752 = 0.0f;
                          _1753 = 0.0f;
                          _1754 = 0.0f;
                          _1755 = 0;
                          while(true) {
                            int _1760 = __3__37__0__0__g_surfelDataBuffer[((_1704 + -1) + _1755)]._baseColor;
                            int _1762 = __3__37__0__0__g_surfelDataBuffer[((_1704 + -1) + _1755)]._normal;
                            int16_t _1765 = __3__37__0__0__g_surfelDataBuffer[((_1704 + -1) + _1755)]._radius;
                            if (!(_1760 == 0)) {
                              half _1768 = __3__37__0__0__g_surfelDataBuffer[((_1704 + -1) + _1755)]._radiance.z;
                              half _1769 = __3__37__0__0__g_surfelDataBuffer[((_1704 + -1) + _1755)]._radiance.y;
                              half _1770 = __3__37__0__0__g_surfelDataBuffer[((_1704 + -1) + _1755)]._radiance.x;
                              float _1776 = float((uint)((uint)(_1760 & 255)));
                              float _1777 = float((uint)((uint)(((uint)((uint)(_1760)) >> 8) & 255)));
                              float _1778 = float((uint)((uint)(((uint)((uint)(_1760)) >> 16) & 255)));
                              float _1803 = select(((_1776 * 0.003921568859368563f) < 0.040449999272823334f), (_1776 * 0.0003035269910469651f), exp2(log2((_1776 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1804 = select(((_1777 * 0.003921568859368563f) < 0.040449999272823334f), (_1777 * 0.0003035269910469651f), exp2(log2((_1777 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1805 = select(((_1778 * 0.003921568859368563f) < 0.040449999272823334f), (_1778 * 0.0003035269910469651f), exp2(log2((_1778 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1817 = (float((uint)((uint)(_1762 & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1818 = (float((uint)((uint)(((uint)((uint)(_1762)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1819 = (float((uint)((uint)(((uint)((uint)(_1762)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1821 = rsqrt(dot(float3(_1817, _1818, _1819), float3(_1817, _1818, _1819)));
                              bool _1826 = ((_1762 & 16777215) == 0);
                              float _1830 = float(_1770);
                              float _1831 = float(_1769);
                              float _1832 = float(_1768);
                              float _1836 = (_1710 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_1765) & 255)));
                              float _1852 = (((float((uint)((uint)((uint)((uint)(_1760)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1710) + ((((((_clipmapOffsets[_1641]).x) + -63.5f) + float((int)(((int)(((uint)(_1644) + 64u) - (uint)(int((_clipmapOffsets[_1641]).x)))) & 127))) * _1710) - _viewPos.x);
                              float _1853 = (((float((uint)((uint)((uint)((uint)(_1762)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1710) + ((((((_clipmapOffsets[_1641]).y) + -31.5f) + float((int)(((int)(((uint)(_1643) + 32u) - (uint)(int((_clipmapOffsets[_1641]).y)))) & 63))) * _1710) - _viewPos.y);
                              float _1854 = (((float((uint16_t)((uint)((uint16_t)((uint)(_1765)) >> 8))) * 0.003937007859349251f) + -0.5f) * _1710) + ((((((_clipmapOffsets[_1641]).z) + -63.5f) + float((int)(((int)(((uint)(_1642) + 64u) - (uint)(int((_clipmapOffsets[_1641]).z)))) & 127))) * _1710) - _viewPos.z);
                              float _1874 = ((-0.0f - _1097) - (_1450 * _202)) + _1852;
                              float _1877 = ((-0.0f - _1098) - (_1450 * _203)) + _1853;
                              float _1880 = ((-0.0f - _1099) - (_1450 * _204)) + _1854;
                              float _1881 = dot(float3(_1874, _1877, _1880), float3(_1747, _1748, _1749));
                              float _1885 = _1874 - (_1881 * _1747);
                              float _1886 = _1877 - (_1881 * _1748);
                              float _1887 = _1880 - (_1881 * _1749);
                              float _1913 = 1.0f / float((uint)(1u << (_1641 & 31)));
                              float _1917 = frac(((_invClipmapExtent.z * _1854) + _clipmapUVRelativeOffset.z) * _1913);
                              float _1928 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _1852) + _clipmapUVRelativeOffset.x) * _1913), (((_invClipmapExtent.y * _1853) + _clipmapUVRelativeOffset.y) * _1913), (((float((uint)_1698) + 1.0f) + ((select((_1917 < 0.0f), 1.0f, 0.0f) + _1917) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                              float _1942 = select(((int)_1641 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_1747, _1748, _1749), float3(select(_1826, _1747, (_1821 * _1817)), select(_1826, _1748, (_1821 * _1818)), select(_1826, _1749, (_1821 * _1819))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_1885, _1886, _1887), float3(_1885, _1886, _1887)) < ((_1836 * _1836) * 16.0f)))) * float((bool)(uint)(_1928.x > ((_1710 * 0.25f) * (saturate((dot(float3(_1830, _1831, _1832), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                              float _1949 = (((((_1804 * 0.3395099937915802f) + (_1803 * 0.6131200194358826f)) + (_1805 * 0.047370001673698425f)) * _1830) * _1942) + _1751;
                              float _1950 = (((((_1804 * 0.9163600206375122f) + (_1803 * 0.07020000368356705f)) + (_1805 * 0.013450000435113907f)) * _1831) * _1942) + _1752;
                              float _1951 = (((((_1804 * 0.10958000272512436f) + (_1803 * 0.02061999961733818f)) + (_1805 * 0.8697999715805054f)) * _1832) * _1942) + _1753;
                              float _1952 = _1942 + _1754;
                              if ((uint)(_1755 + 1) < (uint)renodx::math::Select(RT_QUALITY >= 1.f, 8.f, 4.f)) {
                                _1751 = _1949;
                                _1752 = _1950;
                                _1753 = _1951;
                                _1754 = _1952;
                                _1755 = (_1755 + 1);
                                continue;
                              } else {
                                _1956 = _1949;
                                _1957 = _1950;
                                _1958 = _1951;
                                _1959 = _1952;
                              }
                            } else {
                              _1956 = _1751;
                              _1957 = _1752;
                              _1958 = _1753;
                              _1959 = _1754;
                            }
                            if (_1959 > 0.0f) {
                              float _1962 = 1.0f / _1959;
                              _1976 = 1.0f;
                              _1977 = (-0.0f - min(0.0f, (-0.0f - (_1956 * _1962))));
                              _1978 = (-0.0f - min(0.0f, (-0.0f - (_1957 * _1962))));
                              _1979 = (-0.0f - min(0.0f, (-0.0f - (_1958 * _1962))));
                            } else {
                              _1976 = 0.0f;
                              _1977 = _1956;
                              _1978 = _1957;
                              _1979 = _1958;
                            }
                            break;
                          }
                        } else {
                          _1976 = 0.0f;
                          _1977 = 0.0f;
                          _1978 = 0.0f;
                          _1979 = 0.0f;
                        }
                      } else {
                        _1976 = 0.0f;
                        _1977 = 0.0f;
                        _1978 = 0.0f;
                        _1979 = 0.0f;
                      }
                    } else {
                      _1976 = 1.0f;
                      _1977 = 0.0f;
                      _1978 = 0.0f;
                      _1979 = 0.0f;
                    }
                    break;
                  }
                } else {
                  _1976 = 1.0f;
                  _1977 = 0.0f;
                  _1978 = 0.0f;
                  _1979 = 0.0f;
                }
                break;
              }
            } else {
              _1976 = 1.0f;
              _1977 = 0.0f;
              _1978 = 0.0f;
              _1979 = 0.0f;
            }
            float _1987 = saturate((_1450 * 0.25f) / (float((int)((int)(1u << (_1163 & 31)))) * _voxelParams.x)) * _1976;
            float _1997 = -0.0f - min(0.0f, (-0.0f - (_1977 * _1987)));
            float _1998 = -0.0f - min(0.0f, (-0.0f - (_1978 * _1987)));
            float _1999 = -0.0f - min(0.0f, (-0.0f - (_1979 * _1987)));
            float _2001 = select(((int)_1456 > (int)-1), 1.0f, 0.0f);
            float _2002 = max(9.999999974752427e-07f, _1450);
            if (_2002 > 0.0f) {
              _2007 = (_2002 + _1096);
              _2008 = _1997;
              _2009 = _1998;
              _2010 = _1999;
              _2011 = _2001;
            } else {
              _2007 = _2002;
              _2008 = _1997;
              _2009 = _1998;
              _2010 = _1999;
              _2011 = _2001;
            }
          } else {
            _2007 = 0.0f;
            _2008 = 0.0f;
            _2009 = 0.0f;
            _2010 = 0.0f;
            _2011 = _1454;
          }
        } else {
          _2007 = 0.0f;
          _2008 = 0.0f;
          _2009 = 0.0f;
          _2010 = 0.0f;
          _2011 = 0.0f;
        }
        break;
      }
    } else {
      _2007 = _751;
      _2008 = _747;
      _2009 = _748;
      _2010 = _749;
      _2011 = _750;
    }
    float _2014 = saturate(5.000000476837158f - (_170 * 0.01953125186264515f));
    bool _2015 = (_965 != 0);
    if (((_964 > 0.0f)) && ((((_956 > 0.0f)) && (_2015)))) {
      if (!(_956 < _2007)) {
        _2025 = (_2007 <= 0.0f);
      } else {
        _2025 = true;
      }
    } else {
      _2025 = false;
    }
    float _2029 = saturate(max(select(_2025, 1.0f, 0.0f), (1.0f - _2014)));
    float _2030 = _2029 * _964;
    float _2033 = min(_2014, saturate(1.0f - _2030));
    if (!(_2011 == 0.0f)) {
      _2048 = ((_2033 * _2008) + (_2029 * _961));
      _2049 = ((_2033 * _2009) + (_2029 * _962));
      _2050 = ((_2033 * _2010) + (_2029 * _963));
      _2051 = ((_2033 * _2011) + _2030);
    } else {
      _2048 = _961;
      _2049 = _962;
      _2050 = _963;
      _2051 = _964;
    }
    float _2054 = 1.0f / max(9.999999974752427e-07f, (_2033 + _2029));
    float _2058 = _2054 * ((_2033 * _2007) + (_2029 * _956));
    float _2060 = _2054 * _2029;
    float _2064 = (_2058 * _202) + _165;
    float _2065 = (_2058 * _203) + _166;
    float _2066 = (_2058 * _204) + _167;
    [branch]
    if (!(_2058 <= 0.0f)) {
      float _2096 = mad((_viewProjRelative[3].z), _2066, mad((_viewProjRelative[3].y), _2065, ((_viewProjRelative[3].x) * _2064))) + (_viewProjRelative[3].w);
      float _2101 = (((mad((_viewProjRelative[0].z), _2066, mad((_viewProjRelative[0].y), _2065, ((_viewProjRelative[0].x) * _2064))) + (_viewProjRelative[0].w)) / _2096) * 0.5f) + 0.5f;
      float _2102 = 0.5f - (((mad((_viewProjRelative[1].z), _2066, mad((_viewProjRelative[1].y), _2065, ((_viewProjRelative[1].x) * _2064))) + (_viewProjRelative[1].w)) / _2096) * 0.5f);
      if (((((_2101 >= 0.0f)) && ((_2101 <= 1.0f)))) && ((((_2102 >= 0.0f)) && ((_2102 <= 1.0f))))) {
        if ((_2015) && ((((mad((_viewProjRelative[2].z), _2066, mad((_viewProjRelative[2].y), _2065, ((_viewProjRelative[2].x) * _2064))) + (_viewProjRelative[2].w)) / _2096) > 0.0f))) {
          half4 _2125 = __3__36__0__0__g_sceneShadowColor.SampleLevel(__3__40__0__0__g_sampler, float2(_2101, _2102), 0.0f);
          _2133 = float(_2125.x);
          _2134 = float(_2125.y);
          _2135 = float(_2125.z);
        } else {
          _2133 = 1.0f;
          _2134 = 1.0f;
          _2135 = 1.0f;
        }
      } else {
        _2133 = 1.0f;
        _2134 = 1.0f;
        _2135 = 1.0f;
      }
      float _2142 = _viewPos.x + _2064;
      float _2143 = _viewPos.y + _2065;
      float _2144 = _viewPos.z + _2066;
      float _2149 = _2142 - (_staticShadowPosition[1].x);
      float _2150 = _2143 - (_staticShadowPosition[1].y);
      float _2151 = _2144 - (_staticShadowPosition[1].z);
      float _2171 = mad((_shadowProjRelativeTexScale[1][0].z), _2151, mad((_shadowProjRelativeTexScale[1][0].y), _2150, ((_shadowProjRelativeTexScale[1][0].x) * _2149))) + (_shadowProjRelativeTexScale[1][0].w);
      float _2175 = mad((_shadowProjRelativeTexScale[1][1].z), _2151, mad((_shadowProjRelativeTexScale[1][1].y), _2150, ((_shadowProjRelativeTexScale[1][1].x) * _2149))) + (_shadowProjRelativeTexScale[1][1].w);
      float _2182 = 2.0f / _shadowSizeAndInvSize.y;
      float _2183 = 1.0f - _2182;
      bool _2190 = ((((((!(_2171 <= _2183))) || ((!(_2171 >= _2182))))) || ((!(_2175 <= _2183))))) || ((!(_2175 >= _2182)));
      float _2199 = _2142 - (_staticShadowPosition[0].x);
      float _2200 = _2143 - (_staticShadowPosition[0].y);
      float _2201 = _2144 - (_staticShadowPosition[0].z);
      float _2221 = mad((_shadowProjRelativeTexScale[0][0].z), _2201, mad((_shadowProjRelativeTexScale[0][0].y), _2200, ((_shadowProjRelativeTexScale[0][0].x) * _2199))) + (_shadowProjRelativeTexScale[0][0].w);
      float _2225 = mad((_shadowProjRelativeTexScale[0][1].z), _2201, mad((_shadowProjRelativeTexScale[0][1].y), _2200, ((_shadowProjRelativeTexScale[0][1].x) * _2199))) + (_shadowProjRelativeTexScale[0][1].w);
      bool _2236 = ((((((!(_2221 <= _2183))) || ((!(_2221 >= _2182))))) || ((!(_2225 <= _2183))))) || ((!(_2225 >= _2182)));
      float _2237 = select(_2236, select(_2190, 0.0f, _2171), _2221);
      float _2238 = select(_2236, select(_2190, 0.0f, _2175), _2225);
      float _2239 = select(_2236, select(_2190, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _2151, mad((_shadowProjRelativeTexScale[1][2].y), _2150, ((_shadowProjRelativeTexScale[1][2].x) * _2149))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _2201, mad((_shadowProjRelativeTexScale[0][2].y), _2200, ((_shadowProjRelativeTexScale[0][2].x) * _2199))) + (_shadowProjRelativeTexScale[0][2].w)));
      int _2240 = select(_2236, select(_2190, -1, 1), 0);
      [branch]
      if (!(_2240 == -1)) {
        float _2246 = (_2237 * _shadowSizeAndInvSize.x) + -0.5f;
        float _2247 = (_2238 * _shadowSizeAndInvSize.y) + -0.5f;
        int _2250 = int(floor(_2246));
        int _2251 = int(floor(_2247));
        if (!((((uint)_2250 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_2251 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
          float4 _2261 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2250, _2251, _2240, 0));
          float4 _2263 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2250) + 1u)), _2251, _2240, 0));
          float4 _2265 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2250, ((int)((uint)(_2251) + 1u)), _2240, 0));
          float4 _2267 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2250) + 1u)), ((int)((uint)(_2251) + 1u)), _2240, 0));
          half4 _2272 = __3__36__0__0__g_shadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2237, _2238, float((uint)(uint)(_2240))), 0.0f);
          _2278 = _2261.x;
          _2279 = _2263.x;
          _2280 = _2265.x;
          _2281 = _2267.x;
          _2282 = _2272.x;
          _2283 = _2272.y;
          _2284 = _2272.z;
          _2285 = _2272.w;
        } else {
          _2278 = 0.0f;
          _2279 = 0.0f;
          _2280 = 0.0f;
          _2281 = 0.0f;
          _2282 = 1.0h;
          _2283 = 1.0h;
          _2284 = 1.0h;
          _2285 = 1.0h;
        }
        float _2311 = (float4(_invShadowViewProj[_2240][0][0], _invShadowViewProj[_2240][1][0], _invShadowViewProj[_2240][2][0], _invShadowViewProj[_2240][3][0]).x) * _2237;
        float _2315 = (float4(_invShadowViewProj[_2240][0][0], _invShadowViewProj[_2240][1][0], _invShadowViewProj[_2240][2][0], _invShadowViewProj[_2240][3][0]).y) * _2237;
        float _2319 = (float4(_invShadowViewProj[_2240][0][0], _invShadowViewProj[_2240][1][0], _invShadowViewProj[_2240][2][0], _invShadowViewProj[_2240][3][0]).z) * _2237;
        float _2323 = (float4(_invShadowViewProj[_2240][0][0], _invShadowViewProj[_2240][1][0], _invShadowViewProj[_2240][2][0], _invShadowViewProj[_2240][3][0]).w) * _2237;
        float _2326 = mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).w), _2278, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).w), _2238, _2323)) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).w);
        float _2327 = (mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).x), _2278, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).x), _2238, _2311)) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).x)) / _2326;
        float _2328 = (mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).y), _2278, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).y), _2238, _2315)) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).y)) / _2326;
        float _2329 = (mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).z), _2278, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).z), _2238, _2319)) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).z)) / _2326;
        float _2332 = _2237 + (_shadowSizeAndInvSize.z * 4.0f);
        float _2348 = mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).w), _2279, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).w), _2238, ((float4(_invShadowViewProj[_2240][0][0], _invShadowViewProj[_2240][1][0], _invShadowViewProj[_2240][2][0], _invShadowViewProj[_2240][3][0]).w) * _2332))) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).w);
        float _2354 = _2238 - (_shadowSizeAndInvSize.w * 2.0f);
        float _2366 = mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).w), _2280, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).w), _2354, _2323)) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).w);
        float _2370 = ((mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).x), _2280, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).x), _2354, _2311)) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).x)) / _2366) - _2327;
        float _2371 = ((mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).y), _2280, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).y), _2354, _2315)) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).y)) / _2366) - _2328;
        float _2372 = ((mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).z), _2280, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).z), _2354, _2319)) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).z)) / _2366) - _2329;
        float _2373 = ((mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).x), _2279, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).x), _2238, ((float4(_invShadowViewProj[_2240][0][0], _invShadowViewProj[_2240][1][0], _invShadowViewProj[_2240][2][0], _invShadowViewProj[_2240][3][0]).x) * _2332))) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).x)) / _2348) - _2327;
        float _2374 = ((mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).y), _2279, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).y), _2238, ((float4(_invShadowViewProj[_2240][0][0], _invShadowViewProj[_2240][1][0], _invShadowViewProj[_2240][2][0], _invShadowViewProj[_2240][3][0]).y) * _2332))) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).y)) / _2348) - _2328;
        float _2375 = ((mad((float4(_invShadowViewProj[_2240][0][2], _invShadowViewProj[_2240][1][2], _invShadowViewProj[_2240][2][2], _invShadowViewProj[_2240][3][2]).z), _2279, mad((float4(_invShadowViewProj[_2240][0][1], _invShadowViewProj[_2240][1][1], _invShadowViewProj[_2240][2][1], _invShadowViewProj[_2240][3][1]).z), _2238, ((float4(_invShadowViewProj[_2240][0][0], _invShadowViewProj[_2240][1][0], _invShadowViewProj[_2240][2][0], _invShadowViewProj[_2240][3][0]).z) * _2332))) + (float4(_invShadowViewProj[_2240][0][3], _invShadowViewProj[_2240][1][3], _invShadowViewProj[_2240][2][3], _invShadowViewProj[_2240][3][3]).z)) / _2348) - _2329;
        float _2378 = (_2372 * _2374) - (_2371 * _2375);
        float _2381 = (_2370 * _2375) - (_2372 * _2373);
        float _2384 = (_2371 * _2373) - (_2370 * _2374);
        float _2386 = rsqrt(dot(float3(_2378, _2381, _2384), float3(_2378, _2381, _2384)));
        float _2387 = _2378 * _2386;
        float _2388 = _2381 * _2386;
        float _2389 = _2384 * _2386;
        float _2390 = frac(_2246);
        float _2395 = (saturate(dot(float3(_202, _203, _204), float3(_2387, _2388, _2389))) * 0.0020000000949949026f) + _2239;
        float _2408 = saturate(exp2((_2278 - _2395) * 1442695.0f));
        float _2410 = saturate(exp2((_2280 - _2395) * 1442695.0f));
        float _2416 = ((saturate(exp2((_2279 - _2395) * 1442695.0f)) - _2408) * _2390) + _2408;
        _2423 = _2387;
        _2424 = _2388;
        _2425 = _2389;
        _2426 = saturate((((_2410 - _2416) + ((saturate(exp2((_2281 - _2395) * 1442695.0f)) - _2410) * _2390)) * frac(_2247)) + _2416);
        _2427 = _2278;
        _2428 = _2279;
        _2429 = _2280;
        _2430 = _2281;
        _2431 = _2282;
        _2432 = _2283;
        _2433 = _2284;
        _2434 = _2285;
      } else {
        _2423 = 0.0f;
        _2424 = 0.0f;
        _2425 = 0.0f;
        _2426 = 0.0f;
        _2427 = 0.0f;
        _2428 = 0.0f;
        _2429 = 0.0f;
        _2430 = 0.0f;
        _2431 = 0.0h;
        _2432 = 0.0h;
        _2433 = 0.0h;
        _2434 = 0.0h;
      }
      float _2454 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _2066, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _2065, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _2064))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
      float _2458 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _2066, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _2065, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _2064))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
      float _2462 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _2066, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _2065, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _2064))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
      float _2465 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
      float _2466 = 1.0f - _2465;
      if (!(((((!(_2454 <= _2466))) || ((!(_2454 >= _2465))))) || ((!(_2458 <= _2466))))) {
        bool _2477 = ((_2462 >= -1.0f)) && ((((_2462 <= 1.0f)) && ((_2458 >= _2465))));
        _2485 = select(_2477, 9.999999747378752e-06f, -9.999999747378752e-05f);
        _2486 = select(_2477, _2454, _2237);
        _2487 = select(_2477, _2458, _2238);
        _2488 = select(_2477, _2462, _2239);
        _2489 = select(_2477, 1, _2240);
        _2490 = ((int)(uint)((int)(_2477)));
      } else {
        _2485 = -9.999999747378752e-05f;
        _2486 = _2237;
        _2487 = _2238;
        _2488 = _2239;
        _2489 = _2240;
        _2490 = 0;
      }
      float _2510 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _2066, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _2065, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _2064))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
      float _2514 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _2066, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _2065, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _2064))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
      float _2518 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _2066, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _2065, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _2064))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
      if (!(((((!(_2510 <= _2466))) || ((!(_2510 >= _2465))))) || ((!(_2514 <= _2466))))) {
        bool _2529 = ((_2518 >= -1.0f)) && ((((_2514 >= _2465)) && ((_2518 <= 1.0f))));
        _2537 = select(_2529, 9.999999747378752e-06f, _2485);
        _2538 = select(_2529, _2510, _2486);
        _2539 = select(_2529, _2514, _2487);
        _2540 = select(_2529, _2518, _2488);
        _2541 = select(_2529, 0, _2489);
        _2542 = select(_2529, 1, _2490);
      } else {
        _2537 = _2485;
        _2538 = _2486;
        _2539 = _2487;
        _2540 = _2488;
        _2541 = _2489;
        _2542 = _2490;
      }
      [branch]
      if (!(_2542 == 0)) {
        int _2552 = int(floor((_2538 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
        int _2553 = int(floor((_2539 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
        if (!((((uint)_2552 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_2553 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
          float4 _2563 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2552, _2553, _2541, 0));
          float4 _2565 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2552) + 1u)), _2553, _2541, 0));
          float4 _2567 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2552, ((int)((uint)(_2553) + 1u)), _2541, 0));
          float4 _2569 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2552) + 1u)), ((int)((uint)(_2553) + 1u)), _2541, 0));
          _2572 = _2563.x;
          _2573 = _2565.x;
          _2574 = _2567.x;
          _2575 = _2569.x;
        } else {
          _2572 = _2427;
          _2573 = _2428;
          _2574 = _2429;
          _2575 = _2430;
        }
        float _2601 = (float4(_invDynamicShadowViewProj[_2541][0][0], _invDynamicShadowViewProj[_2541][1][0], _invDynamicShadowViewProj[_2541][2][0], _invDynamicShadowViewProj[_2541][3][0]).x) * _2538;
        float _2605 = (float4(_invDynamicShadowViewProj[_2541][0][0], _invDynamicShadowViewProj[_2541][1][0], _invDynamicShadowViewProj[_2541][2][0], _invDynamicShadowViewProj[_2541][3][0]).y) * _2538;
        float _2609 = (float4(_invDynamicShadowViewProj[_2541][0][0], _invDynamicShadowViewProj[_2541][1][0], _invDynamicShadowViewProj[_2541][2][0], _invDynamicShadowViewProj[_2541][3][0]).z) * _2538;
        float _2613 = (float4(_invDynamicShadowViewProj[_2541][0][0], _invDynamicShadowViewProj[_2541][1][0], _invDynamicShadowViewProj[_2541][2][0], _invDynamicShadowViewProj[_2541][3][0]).w) * _2538;
        float _2616 = mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).w), _2572, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).w), _2539, _2613)) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).w);
        float _2617 = (mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).x), _2572, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).x), _2539, _2601)) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).x)) / _2616;
        float _2618 = (mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).y), _2572, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).y), _2539, _2605)) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).y)) / _2616;
        float _2619 = (mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).z), _2572, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).z), _2539, _2609)) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).z)) / _2616;
        float _2622 = _2538 + (_dynmaicShadowSizeAndInvSize.z * 8.0f);
        float _2638 = mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).w), _2573, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).w), _2539, ((float4(_invDynamicShadowViewProj[_2541][0][0], _invDynamicShadowViewProj[_2541][1][0], _invDynamicShadowViewProj[_2541][2][0], _invDynamicShadowViewProj[_2541][3][0]).w) * _2622))) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).w);
        float _2644 = _2539 - (_dynmaicShadowSizeAndInvSize.w * 4.0f);
        float _2656 = mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).w), _2574, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).w), _2644, _2613)) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).w);
        float _2660 = ((mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).x), _2574, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).x), _2644, _2601)) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).x)) / _2656) - _2617;
        float _2661 = ((mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).y), _2574, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).y), _2644, _2605)) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).y)) / _2656) - _2618;
        float _2662 = ((mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).z), _2574, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).z), _2644, _2609)) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).z)) / _2656) - _2619;
        float _2663 = ((mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).x), _2573, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).x), _2539, ((float4(_invDynamicShadowViewProj[_2541][0][0], _invDynamicShadowViewProj[_2541][1][0], _invDynamicShadowViewProj[_2541][2][0], _invDynamicShadowViewProj[_2541][3][0]).x) * _2622))) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).x)) / _2638) - _2617;
        float _2664 = ((mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).y), _2573, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).y), _2539, ((float4(_invDynamicShadowViewProj[_2541][0][0], _invDynamicShadowViewProj[_2541][1][0], _invDynamicShadowViewProj[_2541][2][0], _invDynamicShadowViewProj[_2541][3][0]).y) * _2622))) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).y)) / _2638) - _2618;
        float _2665 = ((mad((float4(_invDynamicShadowViewProj[_2541][0][2], _invDynamicShadowViewProj[_2541][1][2], _invDynamicShadowViewProj[_2541][2][2], _invDynamicShadowViewProj[_2541][3][2]).z), _2573, mad((float4(_invDynamicShadowViewProj[_2541][0][1], _invDynamicShadowViewProj[_2541][1][1], _invDynamicShadowViewProj[_2541][2][1], _invDynamicShadowViewProj[_2541][3][1]).z), _2539, ((float4(_invDynamicShadowViewProj[_2541][0][0], _invDynamicShadowViewProj[_2541][1][0], _invDynamicShadowViewProj[_2541][2][0], _invDynamicShadowViewProj[_2541][3][0]).z) * _2622))) + (float4(_invDynamicShadowViewProj[_2541][0][3], _invDynamicShadowViewProj[_2541][1][3], _invDynamicShadowViewProj[_2541][2][3], _invDynamicShadowViewProj[_2541][3][3]).z)) / _2638) - _2619;
        float _2668 = (_2662 * _2664) - (_2661 * _2665);
        float _2671 = (_2660 * _2665) - (_2662 * _2663);
        float _2674 = (_2661 * _2663) - (_2660 * _2664);
        float _2676 = rsqrt(dot(float3(_2668, _2671, _2674), float3(_2668, _2671, _2674)));
        if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
          _2694 = _sunDirection.x;
          _2695 = _sunDirection.y;
          _2696 = _sunDirection.z;
        } else {
          _2694 = _moonDirection.x;
          _2695 = _moonDirection.y;
          _2696 = _moonDirection.z;
        }
        float _2702 = (_2537 - (saturate(-0.0f - dot(float3(_2694, _2695, _2696), float3(_202, _203, _204))) * 9.999999747378752e-05f)) + _2540;
        _2715 = (_2668 * _2676);
        _2716 = (_2671 * _2676);
        _2717 = (_2674 * _2676);
        _2718 = min(float((bool)(uint)(_2572 > _2702)), min(min(float((bool)(uint)(_2573 > _2702)), float((bool)(uint)(_2574 > _2702))), float((bool)(uint)(_2575 > _2702))));
      } else {
        _2715 = _2423;
        _2716 = _2424;
        _2717 = _2425;
        _2718 = _2426;
      }
      float _2723 = _viewPos.x - _shadowRelativePosition.x;
      float _2724 = _viewPos.y - _shadowRelativePosition.y;
      float _2725 = _viewPos.z - _shadowRelativePosition.z;
      float _2726 = _2723 + _2064;
      float _2727 = _2724 + _2065;
      float _2728 = _2725 + _2066;
      float _2748 = mad((_terrainShadowProjRelativeTexScale[0].z), _2728, mad((_terrainShadowProjRelativeTexScale[0].y), _2727, (_2726 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
      float _2752 = mad((_terrainShadowProjRelativeTexScale[1].z), _2728, mad((_terrainShadowProjRelativeTexScale[1].y), _2727, (_2726 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
      float _2756 = mad((_terrainShadowProjRelativeTexScale[2].z), _2728, mad((_terrainShadowProjRelativeTexScale[2].y), _2727, (_2726 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
      if (saturate(_2748) == _2748) {
        if (((_2756 >= 9.999999747378752e-05f)) && ((((_2756 <= 1.0f)) && ((saturate(_2752) == _2752))))) {
          float _2771 = frac((_2748 * 1024.0f) + -0.5f);
          float4 _2775 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_2748, _2752));
          float _2780 = _2756 + -0.004999999888241291f;
          float _2785 = select((_2775.w > _2780), 1.0f, 0.0f);
          float _2787 = select((_2775.x > _2780), 1.0f, 0.0f);
          float _2794 = ((select((_2775.z > _2780), 1.0f, 0.0f) - _2785) * _2771) + _2785;
          _2800 = saturate((((((select((_2775.y > _2780), 1.0f, 0.0f) - _2787) * _2771) + _2787) - _2794) * frac((_2752 * 1024.0f) + -0.5f)) + _2794);
        } else {
          _2800 = 1.0f;
        }
      } else {
        _2800 = 1.0f;
      }
      float _2801 = min(_2718, _2800);
      half _2802 = saturate(_2431);
      half _2803 = saturate(_2432);
      half _2804 = saturate(_2433);
      half _2818 = ((_2803 * 0.3395996h) + (_2802 * 0.61328125h)) + (_2804 * 0.04736328h);
      half _2819 = ((_2803 * 0.9165039h) + (_2802 * 0.07019043h)) + (_2804 * 0.013450623h);
      half _2820 = ((_2803 * 0.109558105h) + (_2802 * 0.020614624h)) + (_2804 * 0.8696289h);
      bool _2823 = (_sunDirection.y > 0.0f);
      if ((_2823) || ((!(_2823)) && (_sunDirection.y > _moonDirection.y))) {
        _2835 = _sunDirection.x;
        _2836 = _sunDirection.y;
        _2837 = _sunDirection.z;
      } else {
        _2835 = _moonDirection.x;
        _2836 = _moonDirection.y;
        _2837 = _moonDirection.z;
      }
      if ((_2823) || ((!(_2823)) && (_sunDirection.y > _moonDirection.y))) {
        _2857 = _precomputedAmbient7.y;
      } else {
        _2857 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
      }
      float _2860 = _2143 + _earthRadius;
      float _2864 = (_2066 * _2066) + (_2064 * _2064);
      float _2866 = sqrt((_2860 * _2860) + _2864);
      float _2871 = dot(float3((_2064 / _2866), (_2860 / _2866), (_2066 / _2866)), float3(_2835, _2836, _2837));
      float _2874 = _atmosphereThickness + -16.0f;
      float _2876 = min(max(((_2866 - _earthRadius) / _atmosphereThickness), 16.0f), _2874);
      float _2878 = _atmosphereThickness + -32.0f;
      float _2884 = max(_2876, 0.0f);
      float _2885 = _earthRadius * 2.0f;
      float _2891 = (-0.0f - sqrt((_2884 + _2885) * _2884)) / (_2884 + _earthRadius);
      if (_2871 > _2891) {
        _2914 = ((exp2(log2(saturate((_2871 - _2891) / (1.0f - _2891))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _2914 = ((exp2(log2(saturate((_2891 - _2871) / (_2891 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float2 _2919 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_2876 + -16.0f) / _2878)) * 0.5f) * 0.96875f) + 0.015625f), _2914), 0.0f);
      float _2938 = _mieAerosolAbsorption + 1.0f;
      float _2939 = _mieAerosolDensity * 1.9999999494757503e-05f;
      float _2941 = (_2939 * _2919.y) * _2938;
      float _2947 = (float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f);
      float _2950 = (float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f);
      float _2953 = (_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f);
      float _2959 = exp2(((_2947 * _2919.x) + _2941) * -1.4426950216293335f);
      float _2960 = exp2(((_2950 * _2919.x) + _2941) * -1.4426950216293335f);
      float _2961 = exp2(((_2953 * _2919.x) + _2941) * -1.4426950216293335f);
      float _2977 = sqrt(_2864);
      float _2985 = (_cloudAltitude - (max(((_2977 * _2977) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
      float _2997 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_2836 > 0.0f))) - ((int)(uint)((int)(_2836 < 0.0f))))) * 0.5f))) + _2985;
      if (_2065 < _2985) {
        float _3000 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2835, _2836, _2837));
        float _3006 = select((abs(_3000) < 9.99999993922529e-09f), 1e+08f, ((_2997 - dot(float3(0.0f, 1.0f, 0.0f), float3(_2064, _2065, _2066))) / _3000));
        _3012 = ((_3006 * _2835) + _2064);
        _3013 = _2997;
        _3014 = ((_3006 * _2837) + _2066);
      } else {
        _3012 = _2064;
        _3013 = _2065;
        _3014 = _2066;
      }
      float _3023 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3012 * 4.999999873689376e-05f) + 0.5f), ((_3013 - _2985) / _cloudThickness), ((_3014 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
      float _3027 = _cloudScatteringCoefficient / _distanceScale;
      float _3028 = _distanceScale * -1.4426950216293335f;
      float _3034 = saturate(abs(_2836) * 4.0f);
      float _3036 = (_3034 * _3034) * exp2((_3028 * _3023.x) * _3027);
      float _3043 = ((1.0f - _3036) * saturate(((_2065 - _cloudThickness) - _2985) * 0.10000000149011612f)) + _3036;
      float _3044 = _3043 * (((_2960 * 0.3395099937915802f) + (_2959 * 0.6131200194358826f)) + (_2961 * 0.047370001673698425f));
      float _3045 = _3043 * (((_2960 * 0.9163600206375122f) + (_2959 * 0.07020000368356705f)) + (_2961 * 0.013450000435113907f));
      float _3046 = _3043 * (((_2960 * 0.10958000272512436f) + (_2959 * 0.02061999961733818f)) + (_2961 * 0.8697999715805054f));
      float _3065 = float(saturate(_2434));
      if (((_746 != 0)) && ((!_766))) {
        bool _3067 = (_960 > 0.0f);
        float _3068 = select(_3067, _957, _2715);
        float _3069 = select(_3067, _958, _2716);
        float _3070 = select(_3067, _959, _2717);
        float _3071 = select(_3067, _960, 0.800000011920929f);
        if (_745 > 0.0f) {
          half _3074 = half(_742);
          half _3075 = half(_743);
          half _3076 = half(_744);
          _3082 = _3071;
          _3083 = _3068;
          _3084 = _3069;
          _3085 = _3070;
          _3086 = _3074;
          _3087 = _3075;
          _3088 = _3076;
          _3089 = _745;
          _3090 = float(_3074);
          _3091 = float(_3075);
          _3092 = float(_3076);
          _3093 = dot(float3(_3068, _3069, _3070), float3(_2835, _2836, _2837));
        } else {
          _3082 = _3071;
          _3083 = _3068;
          _3084 = _3069;
          _3085 = _3070;
          _3086 = _2818;
          _3087 = _2819;
          _3088 = _2820;
          _3089 = 0.10000000149011612f;
          _3090 = 1.0f;
          _3091 = 1.0f;
          _3092 = 1.0f;
          _3093 = _3065;
        }
      } else {
        _3082 = 0.800000011920929f;
        _3083 = _2715;
        _3084 = _2716;
        _3085 = _2717;
        _3086 = _2818;
        _3087 = _2819;
        _3088 = _2820;
        _3089 = 0.10000000149011612f;
        _3090 = 1.0f;
        _3091 = 1.0f;
        _3092 = 1.0f;
        _3093 = _3065;
      }
      float _3101 = float(half(saturate(_3093) * 0.31830987334251404f)) * _2801;
      float _3109 = 0.699999988079071f / min(max(max(max(_3090, _3091), _3092), 0.009999999776482582f), 0.699999988079071f);
      float _3120 = (((_3109 * _3091) + -0.03999999910593033f) * _3089) + 0.03999999910593033f;
      float _3122 = _2835 - _202;
      float _3123 = _2836 - _203;
      float _3124 = _2837 - _204;
      float _3126 = rsqrt(dot(float3(_3122, _3123, _3124), float3(_3122, _3123, _3124)));
      float _3127 = _3126 * _3122;
      float _3128 = _3126 * _3123;
      float _3129 = _3126 * _3124;
      float _3130 = -0.0f - _202;
      float _3131 = -0.0f - _203;
      float _3132 = -0.0f - _204;
      float _3137 = saturate(max(9.999999747378752e-06f, dot(float3(_3130, _3131, _3132), float3(_3083, _3084, _3085))));
      float _3139 = saturate(dot(float3(_3083, _3084, _3085), float3(_3127, _3128, _3129)));
      float _3142 = saturate(1.0f - saturate(saturate(dot(float3(_3130, _3131, _3132), float3(_3127, _3128, _3129)))));
      float _3143 = _3142 * _3142;
      float _3145 = (_3143 * _3143) * _3142;
      float _3148 = _3145 * saturate(_3120 * 50.0f);
      float _3149 = 1.0f - _3145;
      float _3157 = saturate(_3093 * _2801);
      float _3158 = _3082 * _3082;
      float _3159 = _3158 * _3158;
      float _3160 = 1.0f - _3158;
      float _3172 = (((_3139 * _3159) - _3139) * _3139) + 1.0f;
      float _3176 = (_3159 / ((_3172 * _3172) * 3.1415927410125732f)) * (0.5f / ((((_3137 * _3160) + _3158) * _3093) + (_3137 * ((_3093 * _3160) + _3158))));
      float _3187 = ((((_3044 * 0.6131200194358826f) + (_3045 * 0.3395099937915802f)) + (_3046 * 0.047370001673698425f)) * _2857) * ((max((((_3149 * ((((_3109 * _3090) + -0.03999999910593033f) * _3089) + 0.03999999910593033f)) + _3148) * _3176), 0.0f) * _3157) + (_3101 * float(_3086)));
      float _3189 = ((((_3044 * 0.07020000368356705f) + (_3045 * 0.9163600206375122f)) + (_3046 * 0.013450000435113907f)) * _2857) * ((max((((_3149 * _3120) + _3148) * _3176), 0.0f) * _3157) + (_3101 * float(_3087)));
      float _3191 = ((((_3044 * 0.02061999961733818f) + (_3045 * 0.10958000272512436f)) + (_3046 * 0.8697999715805054f)) * _2857) * ((max((((_3149 * ((((_3109 * _3092) + -0.03999999910593033f) * _3089) + 0.03999999910593033f)) + _3148) * _3176), 0.0f) * _3157) + (_3101 * float(_3088)));
      float _3196 = dot(float3(_3187, _3189, _3191), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _3197 = min((max(0.0005000000237487257f, _exposure3.w) * 4096.0f), _3196);
      float _3201 = max(9.999999717180685e-10f, _3196);
      float _3202 = (_3197 * _3187) / _3201;
      float _3203 = (_3197 * _3189) / _3201;
      float _3204 = (_3197 * _3191) / _3201;
      if (((_105 == 33)) || ((_105 == 55))) {
        if ((_2823) || ((!(_2823)) && (_sunDirection.y > _moonDirection.y))) {
          _3225 = _sunDirection.x;
          _3226 = _sunDirection.y;
          _3227 = _sunDirection.z;
        } else {
          _3225 = _moonDirection.x;
          _3226 = _moonDirection.y;
          _3227 = _moonDirection.z;
        }
        float _3232 = rsqrt(dot(float3(_165, _166, _167), float3(_165, _166, _167)));
        float _3233 = _3232 * _165;
        float _3234 = _3232 * _166;
        float _3235 = _3232 * _167;
        float _3239 = _165 - (_125 * 0.03999999910593033f);
        float _3240 = _166 - (_126 * 0.03999999910593033f);
        float _3241 = _167 - (_127 * 0.03999999910593033f);
        float _3245 = (_viewPos.x - (_staticShadowPosition[1].x)) + _3239;
        float _3246 = (_viewPos.y - (_staticShadowPosition[1].y)) + _3240;
        float _3247 = (_viewPos.z - (_staticShadowPosition[1].z)) + _3241;
        float _3251 = mad((_shadowProjRelativeTexScale[1][0].z), _3247, mad((_shadowProjRelativeTexScale[1][0].y), _3246, (_3245 * (_shadowProjRelativeTexScale[1][0].x)))) + (_shadowProjRelativeTexScale[1][0].w);
        float _3255 = mad((_shadowProjRelativeTexScale[1][1].z), _3247, mad((_shadowProjRelativeTexScale[1][1].y), _3246, (_3245 * (_shadowProjRelativeTexScale[1][1].x)))) + (_shadowProjRelativeTexScale[1][1].w);
        bool _3266 = ((((((!(_3251 <= _2183))) || ((!(_3251 >= _2182))))) || ((!(_3255 <= _2183))))) || ((!(_3255 >= _2182)));
        float _3274 = (_viewPos.x - (_staticShadowPosition[0].x)) + _3239;
        float _3275 = (_viewPos.y - (_staticShadowPosition[0].y)) + _3240;
        float _3276 = (_viewPos.z - (_staticShadowPosition[0].z)) + _3241;
        float _3280 = mad((_shadowProjRelativeTexScale[0][0].z), _3276, mad((_shadowProjRelativeTexScale[0][0].y), _3275, (_3274 * (_shadowProjRelativeTexScale[0][0].x)))) + (_shadowProjRelativeTexScale[0][0].w);
        float _3284 = mad((_shadowProjRelativeTexScale[0][1].z), _3276, mad((_shadowProjRelativeTexScale[0][1].y), _3275, (_3274 * (_shadowProjRelativeTexScale[0][1].x)))) + (_shadowProjRelativeTexScale[0][1].w);
        bool _3295 = ((((((!(_3280 <= _2183))) || ((!(_3280 >= _2182))))) || ((!(_3284 <= _2183))))) || ((!(_3284 >= _2182)));
        float _3297 = select(((_3295) && (_3266)), 0.0f, 0.0010000000474974513f);
        float _3298 = select(_3295, select(_3266, 0.0f, _3251), _3280);
        float _3299 = select(_3295, select(_3266, 0.0f, _3255), _3284);
        float _3300 = select(_3295, select(_3266, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _3247, mad((_shadowProjRelativeTexScale[1][2].y), _3246, (_3245 * (_shadowProjRelativeTexScale[1][2].x)))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _3276, mad((_shadowProjRelativeTexScale[0][2].y), _3275, (_3274 * (_shadowProjRelativeTexScale[0][2].x)))) + (_shadowProjRelativeTexScale[0][2].w)));
        int _3301 = select(_3295, select(_3266, -1, 1), 0);
        [branch]
        if (!(_3301 == -1)) {
          float _3307 = (_3298 * _shadowSizeAndInvSize.x) + -0.5f;
          float _3308 = (_3299 * _shadowSizeAndInvSize.y) + -0.5f;
          int _3311 = int(floor(_3307));
          int _3312 = int(floor(_3308));
          if (!((((uint)_3311 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_3312 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
            float4 _3322 = __3__36__0__0__g_shadowDepthArray.Load(int4(_3311, _3312, _3301, 0));
            float4 _3324 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_3311) + 1u)), _3312, _3301, 0));
            float4 _3326 = __3__36__0__0__g_shadowDepthArray.Load(int4(_3311, ((int)((uint)(_3312) + 1u)), _3301, 0));
            float4 _3328 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_3311) + 1u)), ((int)((uint)(_3312) + 1u)), _3301, 0));
            _3331 = _3322.x;
            _3332 = _3324.x;
            _3333 = _3326.x;
            _3334 = _3328.x;
          } else {
            _3331 = 0.0f;
            _3332 = 0.0f;
            _3333 = 0.0f;
            _3334 = 0.0f;
          }
          float _3360 = (float4(_invShadowViewProj[_3301][0][0], _invShadowViewProj[_3301][1][0], _invShadowViewProj[_3301][2][0], _invShadowViewProj[_3301][3][0]).x) * _3298;
          float _3364 = (float4(_invShadowViewProj[_3301][0][0], _invShadowViewProj[_3301][1][0], _invShadowViewProj[_3301][2][0], _invShadowViewProj[_3301][3][0]).y) * _3298;
          float _3368 = (float4(_invShadowViewProj[_3301][0][0], _invShadowViewProj[_3301][1][0], _invShadowViewProj[_3301][2][0], _invShadowViewProj[_3301][3][0]).z) * _3298;
          float _3372 = (float4(_invShadowViewProj[_3301][0][0], _invShadowViewProj[_3301][1][0], _invShadowViewProj[_3301][2][0], _invShadowViewProj[_3301][3][0]).w) * _3298;
          float _3375 = mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).w), _3331, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).w), _3299, _3372)) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).w);
          float _3376 = (mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).x), _3331, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).x), _3299, _3360)) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).x)) / _3375;
          float _3377 = (mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).y), _3331, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).y), _3299, _3364)) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).y)) / _3375;
          float _3378 = (mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).z), _3331, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).z), _3299, _3368)) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).z)) / _3375;
          float _3381 = _3298 + (_shadowSizeAndInvSize.z * 4.0f);
          float _3397 = mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).w), _3332, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).w), _3299, ((float4(_invShadowViewProj[_3301][0][0], _invShadowViewProj[_3301][1][0], _invShadowViewProj[_3301][2][0], _invShadowViewProj[_3301][3][0]).w) * _3381))) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).w);
          float _3403 = _3299 - (_shadowSizeAndInvSize.w * 2.0f);
          float _3415 = mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).w), _3333, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).w), _3403, _3372)) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).w);
          float _3419 = ((mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).x), _3333, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).x), _3403, _3360)) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).x)) / _3415) - _3376;
          float _3420 = ((mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).y), _3333, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).y), _3403, _3364)) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).y)) / _3415) - _3377;
          float _3421 = ((mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).z), _3333, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).z), _3403, _3368)) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).z)) / _3415) - _3378;
          float _3422 = ((mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).x), _3332, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).x), _3299, ((float4(_invShadowViewProj[_3301][0][0], _invShadowViewProj[_3301][1][0], _invShadowViewProj[_3301][2][0], _invShadowViewProj[_3301][3][0]).x) * _3381))) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).x)) / _3397) - _3376;
          float _3423 = ((mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).y), _3332, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).y), _3299, ((float4(_invShadowViewProj[_3301][0][0], _invShadowViewProj[_3301][1][0], _invShadowViewProj[_3301][2][0], _invShadowViewProj[_3301][3][0]).y) * _3381))) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).y)) / _3397) - _3377;
          float _3424 = ((mad((float4(_invShadowViewProj[_3301][0][2], _invShadowViewProj[_3301][1][2], _invShadowViewProj[_3301][2][2], _invShadowViewProj[_3301][3][2]).z), _3332, mad((float4(_invShadowViewProj[_3301][0][1], _invShadowViewProj[_3301][1][1], _invShadowViewProj[_3301][2][1], _invShadowViewProj[_3301][3][1]).z), _3299, ((float4(_invShadowViewProj[_3301][0][0], _invShadowViewProj[_3301][1][0], _invShadowViewProj[_3301][2][0], _invShadowViewProj[_3301][3][0]).z) * _3381))) + (float4(_invShadowViewProj[_3301][0][3], _invShadowViewProj[_3301][1][3], _invShadowViewProj[_3301][2][3], _invShadowViewProj[_3301][3][3]).z)) / _3397) - _3378;
          float _3427 = (_3421 * _3423) - (_3420 * _3424);
          float _3430 = (_3419 * _3424) - (_3421 * _3422);
          float _3433 = (_3420 * _3422) - (_3419 * _3423);
          float _3435 = rsqrt(dot(float3(_3427, _3430, _3433), float3(_3427, _3430, _3433)));
          float _3439 = frac(_3307);
          float _3444 = (saturate(dot(float3(_3233, _3234, _3235), float3((_3427 * _3435), (_3430 * _3435), (_3433 * _3435)))) * 0.0020000000949949026f) + _3300;
          float _3457 = saturate(exp2((_3331 - _3444) * 1442695.0f));
          float _3459 = saturate(exp2((_3333 - _3444) * 1442695.0f));
          float _3465 = ((saturate(exp2((_3332 - _3444) * 1442695.0f)) - _3457) * _3439) + _3457;
          _3472 = saturate((((_3459 - _3465) + ((saturate(exp2((_3334 - _3444) * 1442695.0f)) - _3459) * _3439)) * frac(_3308)) + _3465);
          _3473 = _3331;
          _3474 = _3332;
          _3475 = _3333;
          _3476 = _3334;
        } else {
          _3472 = 1.0f;
          _3473 = 0.0f;
          _3474 = 0.0f;
          _3475 = 0.0f;
          _3476 = 0.0f;
        }
        float _3480 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _3241, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _3240, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _3239))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
        float _3484 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _3241, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _3240, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _3239))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
        float _3488 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _3241, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _3240, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _3239))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
        if (!(((((!(_3480 <= _2466))) || ((!(_3480 >= _2465))))) || ((!(_3484 <= _2466))))) {
          bool _3499 = ((_3488 >= -1.0f)) && ((((_3484 >= _2465)) && ((_3488 <= 1.0f))));
          _3507 = select(_3499, 9.999999747378752e-06f, _3297);
          _3508 = select(_3499, _3480, _3298);
          _3509 = select(_3499, _3484, _3299);
          _3510 = select(_3499, _3488, _3300);
          _3511 = select(_3499, 1, _3301);
          _3512 = ((int)(uint)((int)(_3499)));
        } else {
          _3507 = _3297;
          _3508 = _3298;
          _3509 = _3299;
          _3510 = _3300;
          _3511 = _3301;
          _3512 = 0;
        }
        float _3516 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _3241, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _3240, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _3239))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
        float _3520 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _3241, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _3240, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _3239))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
        float _3524 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _3241, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _3240, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _3239))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
        if (!(((((!(_3516 <= _2466))) || ((!(_3516 >= _2465))))) || ((!(_3520 <= _2466))))) {
          bool _3535 = ((_3524 >= -1.0f)) && ((((_3520 >= _2465)) && ((_3524 <= 1.0f))));
          _3543 = select(_3535, 9.999999747378752e-06f, _3507);
          _3544 = select(_3535, _3516, _3508);
          _3545 = select(_3535, _3520, _3509);
          _3546 = select(_3535, _3524, _3510);
          _3547 = select(_3535, 0, _3511);
          _3548 = select(_3535, 1, _3512);
        } else {
          _3543 = _3507;
          _3544 = _3508;
          _3545 = _3509;
          _3546 = _3510;
          _3547 = _3511;
          _3548 = _3512;
        }
        [branch]
        if (!(_3548 == 0)) {
          int _3558 = int(floor((_3544 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
          int _3559 = int(floor((_3545 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
          if (!((((uint)_3558 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_3559 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
            float4 _3569 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_3558, _3559, _3547, 0));
            float4 _3571 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_3558) + 1u)), _3559, _3547, 0));
            float4 _3573 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_3558, ((int)((uint)(_3559) + 1u)), _3547, 0));
            float4 _3575 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_3558) + 1u)), ((int)((uint)(_3559) + 1u)), _3547, 0));
            _3578 = _3569.x;
            _3579 = _3571.x;
            _3580 = _3573.x;
            _3581 = _3575.x;
          } else {
            _3578 = _3473;
            _3579 = _3474;
            _3580 = _3475;
            _3581 = _3476;
          }
          if ((_2823) || ((!(_2823)) && (_sunDirection.y > _moonDirection.y))) {
            _3593 = _sunDirection.x;
            _3594 = _sunDirection.y;
            _3595 = _sunDirection.z;
          } else {
            _3593 = _moonDirection.x;
            _3594 = _moonDirection.y;
            _3595 = _moonDirection.z;
          }
          float _3601 = (_3543 - (saturate(-0.0f - dot(float3(_3593, _3594, _3595), float3(_3233, _3234, _3235))) * 9.999999747378752e-05f)) + _3546;
          _3614 = min(float((bool)(uint)(_3578 > _3601)), min(min(float((bool)(uint)(_3579 > _3601)), float((bool)(uint)(_3580 > _3601))), float((bool)(uint)(_3581 > _3601))));
        } else {
          _3614 = _3472;
        }
        float _3615 = _2723 + _3239;
        float _3616 = _2724 + _3240;
        float _3617 = _2725 + _3241;
        float _3621 = mad((_terrainShadowProjRelativeTexScale[0].z), _3617, mad((_terrainShadowProjRelativeTexScale[0].y), _3616, (_3615 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
        float _3625 = mad((_terrainShadowProjRelativeTexScale[1].z), _3617, mad((_terrainShadowProjRelativeTexScale[1].y), _3616, (_3615 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
        float _3629 = mad((_terrainShadowProjRelativeTexScale[2].z), _3617, mad((_terrainShadowProjRelativeTexScale[2].y), _3616, (_3615 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
        if (saturate(_3621) == _3621) {
          if (((_3629 >= 9.999999747378752e-05f)) && ((((_3629 <= 1.0f)) && ((saturate(_3625) == _3625))))) {
            float _3644 = frac((_3621 * 1024.0f) + -0.5f);
            float4 _3648 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_3621, _3625));
            float _3653 = _3629 + -0.004999999888241291f;
            float _3658 = select((_3648.w > _3653), 1.0f, 0.0f);
            float _3660 = select((_3648.x > _3653), 1.0f, 0.0f);
            float _3667 = ((select((_3648.z > _3653), 1.0f, 0.0f) - _3658) * _3644) + _3658;
            _3673 = saturate((((((select((_3648.y > _3653), 1.0f, 0.0f) - _3660) * _3644) + _3660) - _3667) * frac((_3625 * 1024.0f) + -0.5f)) + _3667);
          } else {
            _3673 = 1.0f;
          }
        } else {
          _3673 = 1.0f;
        }
        uint4 _3679 = __3__36__0__0__g_baseColor.Load(int3((int)(uint(_71 * (1.0f / g_screenSpaceScale.x))), (int)(uint(_72 * (1.0f / g_screenSpaceScale.y))), 0));
        float _3685 = float((uint)((uint)(((uint)((uint)(_3679.x)) >> 8) & 255))) * 0.003921568859368563f;
        float _3688 = float((uint)((uint)(_3679.x & 255))) * 0.003921568859368563f;
        float _3692 = float((uint)((uint)(((uint)((uint)(_3679.y)) >> 8) & 255))) * 0.003921568859368563f;
        float _3693 = _3685 * _3685;
        float _3694 = _3688 * _3688;
        float _3695 = _3692 * _3692;
        if ((_2823) || ((!(_2823)) && (_sunDirection.y > _moonDirection.y))) {
          _3730 = _precomputedAmbient7.y;
        } else {
          _3730 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
        }
        float _3732 = (_earthRadius + _viewPos.y) + _166;
        float _3736 = (_167 * _167) + (_165 * _165);
        float _3738 = sqrt((_3732 * _3732) + _3736);
        float _3743 = dot(float3((_165 / _3738), (_3732 / _3738), (_167 / _3738)), float3(_3225, _3226, _3227));
        float _3746 = min(max(((_3738 - _earthRadius) / _atmosphereThickness), 16.0f), _2874);
        float _3753 = max(_3746, 0.0f);
        float _3759 = (-0.0f - sqrt((_3753 + _2885) * _3753)) / (_3753 + _earthRadius);
        if (_3743 > _3759) {
          _3782 = ((exp2(log2(saturate((_3743 - _3759) / (1.0f - _3759))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
        } else {
          _3782 = ((exp2(log2(saturate((_3759 - _3743) / (_3759 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
        }
        float2 _3785 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_3746 + -16.0f) / _2878)) * 0.5f) * 0.96875f) + 0.015625f), _3782), 0.0f);
        float _3789 = (_2939 * _2938) * _3785.y;
        float _3799 = exp2((_3789 + (_3785.x * _2947)) * -1.4426950216293335f);
        float _3800 = exp2((_3789 + (_3785.x * _2950)) * -1.4426950216293335f);
        float _3801 = exp2((_3789 + (_3785.x * _2953)) * -1.4426950216293335f);
        float _3817 = sqrt(_3736);
        float _3823 = (_cloudAltitude - (max(((_3817 * _3817) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
        float _3833 = _3823 + ((0.5f - (float((int)(((int)(uint)((int)(_3226 > 0.0f))) - ((int)(uint)((int)(_3226 < 0.0f))))) * 0.5f)) * _cloudThickness);
        if (_166 < _3823) {
          float _3836 = dot(float3(0.0f, 1.0f, 0.0f), float3(_3225, _3226, _3227));
          float _3842 = select((abs(_3836) < 9.99999993922529e-09f), 1e+08f, ((_3833 - dot(float3(0.0f, 1.0f, 0.0f), float3(_165, _166, _167))) / _3836));
          _3848 = ((_3842 * _3225) + _165);
          _3849 = _3833;
          _3850 = ((_3842 * _3227) + _167);
        } else {
          _3848 = _165;
          _3849 = _166;
          _3850 = _167;
        }
        float _3857 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3848 * 4.999999873689376e-05f) + 0.5f), ((_3849 - _3823) / _cloudThickness), ((_3850 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
        float _3864 = saturate(abs(_3226) * 4.0f);
        float _3866 = (_3864 * _3864) * exp2((_3028 * _3027) * _3857.x);
        float _3873 = ((1.0f - _3866) * saturate(((_166 - _cloudThickness) - _3823) * 0.10000000149011612f)) + _3866;
        float _3874 = _3873 * (((_3800 * 0.3395099937915802f) + (_3799 * 0.6131200194358826f)) + (_3801 * 0.047370001673698425f));
        float _3875 = _3873 * (((_3800 * 0.9163600206375122f) + (_3799 * 0.07020000368356705f)) + (_3801 * 0.013450000435113907f));
        float _3876 = _3873 * (((_3800 * 0.10958000272512436f) + (_3799 * 0.02061999961733818f)) + (_3801 * 0.8697999715805054f));
        float _3892 = ((max(0.0f, (0.30000001192092896f - dot(float3(_125, _126, _127), float3(_3225, _3226, _3227)))) * 0.1573420912027359f) * saturate(min(_3614, _3673))) * _3730;
        _3903 = (((_3892 * (((_3693 * 0.6131200194358826f) + (_3694 * 0.3395099937915802f)) + (_3695 * 0.047370001673698425f))) * (((_3874 * 0.6131200194358826f) + (_3875 * 0.3395099937915802f)) + (_3876 * 0.047370001673698425f))) + _3202);
        _3904 = (((_3892 * (((_3693 * 0.07020000368356705f) + (_3694 * 0.9163600206375122f)) + (_3695 * 0.013450000435113907f))) * (((_3874 * 0.07020000368356705f) + (_3875 * 0.9163600206375122f)) + (_3876 * 0.013450000435113907f))) + _3203);
        _3905 = (((_3892 * (((_3693 * 0.02061999961733818f) + (_3694 * 0.10958000272512436f)) + (_3695 * 0.8697999715805054f))) * (((_3874 * 0.02061999961733818f) + (_3875 * 0.10958000272512436f)) + (_3876 * 0.8697999715805054f))) + _3204);
      } else {
        _3903 = _3202;
        _3904 = _3203;
        _3905 = _3204;
      }
      float _3906 = (_renderParams2.z * _2133) * _3903;
      float _3907 = (_renderParams2.z * _2134) * _3904;
      float _3908 = (_renderParams2.z * _2135) * _3905;
      float _3912 = _3906 + _2048;
      float _3913 = _3907 + _2049;
      float _3914 = _3908 + _2050;
      _3925 = _2058;
      _3926 = (((max(_2048, _3906) - _3912) * _2060) + _3912);
      _3927 = (((max(_2049, _3907) - _3913) * _2060) + _3913);
      _3928 = (((max(_2050, _3908) - _3914) * _2060) + _3914);
    } else {
      _3925 = 1000.0f;
      _3926 = _2048;
      _3927 = _2049;
      _3928 = _2050;
    }
    if (!_753) {
      __3__38__0__1__g_raytracingHitResultUAV[int2(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)))] = float4(_195.x, _195.y, _195.z, select((_3925 <= 0.0f), 1000.0f, _3925));
    }
    if (((_3925 > 128.0f)) && ((dot(float3(_3926, _3927, _3928), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) == 0.0f))) {
      _3939 = 1;
      while(true) {
        int _3979 = int(floor(((_wrappedViewPos.x + _2064) * ((_clipmapOffsets[_3939]).w)) + ((_clipmapRelativeIndexOffsets[_3939]).x)));
        int _3980 = int(floor(((_wrappedViewPos.y + _2065) * ((_clipmapOffsets[_3939]).w)) + ((_clipmapRelativeIndexOffsets[_3939]).y)));
        int _3981 = int(floor(((_wrappedViewPos.z + _2066) * ((_clipmapOffsets[_3939]).w)) + ((_clipmapRelativeIndexOffsets[_3939]).z)));
        if (!((((((((int)_3979 >= (int)int(((_clipmapOffsets[_3939]).x) + -63.0f))) && (((int)_3979 < (int)int(((_clipmapOffsets[_3939]).x) + 63.0f))))) && (((((int)_3980 >= (int)int(((_clipmapOffsets[_3939]).y) + -31.0f))) && (((int)_3980 < (int)int(((_clipmapOffsets[_3939]).y) + 31.0f))))))) && (((((int)_3981 >= (int)int(((_clipmapOffsets[_3939]).z) + -63.0f))) && (((int)_3981 < (int)int(((_clipmapOffsets[_3939]).z) + 63.0f))))))) {
          if ((uint)(_3939 + 1) < (uint)8) {
            _3939 = (_3939 + 1);
            continue;
          } else {
            _3997 = -10000;
          }
        } else {
          _3997 = _3939;
        }
        if (!((uint)_3997 > (uint)3)) {
          float _4017 = 1.0f / float((uint)(1u << (_3997 & 31)));
          float _4021 = frac(((_invClipmapExtent.z * _2066) + _clipmapUVRelativeOffset.z) * _4017);
          float _4033 = __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _2064) + _clipmapUVRelativeOffset.x) * _4017), (((_invClipmapExtent.y * _2065) + _clipmapUVRelativeOffset.y) * _4017), (((float((uint)(_3997 * 66)) + 1.0f) + ((select((_4021 < 0.0f), 1.0f, 0.0f) + _4021) * 64.0f)) * 0.0037878789007663727f)), 0.0f);
          _4038 = saturate(1.0f - _4033.x);
        } else {
          _4038 = 1.0f;
        }
        float _4041 = _renderParams.w * _4038;
        bool _4042 = (_745 == 0.0f);
        float4 _4050 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(select(_4042, (-0.0f - _202), _957), select(_4042, _203, _958), select(_4042, (-0.0f - _204), _959)), 4.0f);
        _4064 = ((_4041 * select(_4042, 0.03125f, _742)) * _4050.x);
        _4065 = ((_4041 * select(_4042, 0.03125f, _743)) * _4050.y);
        _4066 = ((_4041 * select(_4042, 0.03125f, _744)) * _4050.z);
        // [DAWN_DUSK_GI] Probe directional boost + energy floor
        if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
          float _ddFactor = DawnDuskFactor(_sunDirection.y);
          float3 _ddAmbient = DawnDuskAmbientBoost(
            float3(_4064, _4065, _4066),
            float3(_125, _126, _127),
            _sunDirection.xyz,
            _ddFactor,
            _precomputedAmbient0.xyz);
          _4064 = _ddAmbient.x;
          _4065 = _ddAmbient.y;
          _4066 = _ddAmbient.z;
        }
        break;
      }
    } else {
      _4064 = _3926;
      _4065 = _3927;
      _4066 = _3928;
    }
    float _4073 = saturate(1.0f - saturate(_2051));
    float _4077 = (_4073 - (_renderParams2.w * _4073)) + _renderParams2.w;
    float4 _4081 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(_202, _203, _204), 4.0f);
    float _4087 = _renderParams.w * _4077;
    float _4088 = _4087 * _4081.x;
    float _4089 = _4087 * _4081.y;
    float _4090 = _4087 * _4081.z;
    // [DAWN_DUSK_GI] Probe directional boost + energy floor
    if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
      float _ddFactor = DawnDuskFactor(_sunDirection.y);
      float3 _ddAmbient = DawnDuskAmbientBoost(
        float3(_4088, _4089, _4090),
        float3(_125, _126, _127),
        _sunDirection.xyz,
        _ddFactor,
        _precomputedAmbient0.xyz);
      _4088 = _ddAmbient.x;
      _4089 = _ddAmbient.y;
      _4090 = _ddAmbient.z;
    }
    float _4095 = dot(float3(_4088, _4089, _4090), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _4096 = min((max(0.009999999776482582f, _exposure3.w) * 2048.0f), _4095);
    float _4100 = max(9.999999717180685e-10f, _4095);
    float _4108 = __3__36__0__0__g_raytracingDiffuseRayInversePDF.Load(int3(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)), 0));
    // [GI_ENERGY_CONSERVATION] Dawn/dusk inverse PDF energy correction
    // vanilla is 2x for whatever reason dunno why. Lowering it slightly
    // for dawn/dusk helps
    float _energyCorrection = 1.0f;
    if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
      float _ddFactor = DawnDuskFactor(_sunDirection.y);
      _energyCorrection = lerp(1.0f, 0.5f, _ddFactor);
    }
    float _4110 = _4108.x * 2.0f * _energyCorrection;
    float _4111 = _4110 * (((_4096 * _4088) / _4100) + (_renderParams2.y * _4064));
    float _4112 = _4110 * (((_4096 * _4089) / _4100) + (_renderParams2.y * _4065));
    float _4113 = _4110 * (((_4096 * _4090) / _4100) + (_renderParams2.y * _4066));
    if (!(_renderParams.y == 0.0f)) {
      float _4118 = saturate(dot(float3(_125, _126, _127), float3(_202, _203, _204)));
      _4123 = (_4118 * _4111);
      _4124 = (_4118 * _4112);
      _4125 = (_4118 * _4113);
    } else {
      _4123 = _4111;
      _4124 = _4112;
      _4125 = _4113;
    }
    // RenoDX: Exterior GI energy compensation
    // The improved ReSTIR convergence over accumulates diffuse bounces.
    // Exteriors become way to bright so as a solution we do the following
    //
    // Apply a luminance based soft compression on the raw hit radiance before it
    // enters the reservoir
    if (RT_QUALITY >= 1.f && RT_GI_STRENGTH > 0.0f) {
      float _rndx_gi_lum = renodx::color::y::from::BT709(float3(_4123, _4124, _4125));
      if (_rndx_gi_lum > RT_GI_KNEE) {
        float _rndx_gi_excess = _rndx_gi_lum - RT_GI_KNEE;
        float _rndx_gi_compressed = RT_GI_KNEE + renodx::math::DivideSafe(_rndx_gi_excess, mad(_rndx_gi_excess, RT_GI_STRENGTH, 1.0f));
        float _rndx_gi_scale = renodx::math::DivideSafe(_rndx_gi_compressed, _rndx_gi_lum, 1.f);
        _4123 *= _rndx_gi_scale;
        _4124 *= _rndx_gi_scale;
        _4125 *= _rndx_gi_scale;
      }
    }
    __3__38__0__1__g_diffuseResultUAV[int2(((int)(((uint)(((int)((uint)(_64) << 4)) & 1048560)) + SV_GroupThreadID.x)), ((int)(((uint)(((uint)((uint)(_64)) >> 16) << 4)) + SV_GroupThreadID.y)))] = half4((-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _4123)))))), (-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _4124)))))), (-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _4125)))))), half(1.0f - _4077));
    break;
  }
}