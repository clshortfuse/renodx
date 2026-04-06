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

Texture2D<float> __3__36__0__0__g_waterDepthTop : register(t167, space36);

Texture2D<float2> __3__36__0__0__g_texNetDensity : register(t19, space36);

Texture3D<float> __3__36__0__0__g_texCloudVolumeShadow : register(t195, space36);

Texture2D<float4> __3__36__0__0__g_terrainShadowDepth : register(t141, space36);

Texture2DArray<float4> __3__36__0__0__g_dynamicShadowDepthArray : register(t229, space36);

Texture2DArray<float4> __3__36__0__0__g_shadowDepthArray : register(t232, space36);

Texture2DArray<half4> __3__36__0__0__g_shadowColorArray : register(t234, space36);

TextureCube<float4> __3__36__0__0__g_environmentColor : register(t225, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t0, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t152, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t79, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t39, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t50, space36);

Texture2D<float4> __3__36__0__0__g_sceneColor : register(t174, space36);

Texture2D<float4> __3__36__0__0__g_character : register(t76, space36);

Texture2D<float4> __3__36__0__0__g_raytracingHitResult : register(t101, space36);

Texture2D<float4> __3__36__0__0__g_raytracingBaseColor : register(t103, space36);

Texture2D<float4> __3__36__0__0__g_raytracingNormal : register(t104, space36);

StructuredBuffer<SurfelData> __3__37__0__0__g_surfelDataBuffer : register(t24, space37);

Texture2D<float4> __3__36__0__0__g_sceneDiffuseHalfPrev : register(t169, space36);

Texture2D<float2> __3__36__0__0__g_sceneAO : register(t159, space36);

RWTexture2D<float> __3__38__0__1__g_specularRayHitDistanceUAV : register(u41, space38);

RWTexture2D<float4> __3__38__0__1__g_specularResultUAV : register(u8, space38);

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

cbuffer __3__35__0__0__WaterConstantBuffer : register(b3, space35) {
  float4 _waterDepthFieldSize : packoffset(c000.x);
  float4 _waterDepthFieldTextureSize : packoffset(c001.x);
  float4 _waterDepthMinMax : packoffset(c002.x);
  column_major float4x4 _waterDepthViewProjRelative : packoffset(c003.x);
  column_major float4x4 _waterDepthViewProjRelativeInv : packoffset(c007.x);
  float4 _waterDepthFrustumPlanes[6] : packoffset(c011.x);
  float4 _waterReadbackTextureSize : packoffset(c017.x);
  column_major float4x4 _waterReadbackViewProjRelative : packoffset(c018.x);
  column_major float4x4 _waterReadbackViewProjRelativeInv : packoffset(c022.x);
  float4 _ripplePivot : packoffset(c026.x);
  float4 _rippleFieldSize : packoffset(c027.x);
  float4 _rippleFieldTextureSize : packoffset(c028.x);
  float4 _shallowWaterPivot : packoffset(c029.x);
  float4 _shallowWaterFieldSize : packoffset(c030.x);
  float4 _shallowWaterFieldTextureSize : packoffset(c031.x);
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
  float4 _volumeSize : packoffset(c004.x);
  float4 _renderFlags : packoffset(c005.x);
  float4 _tiledRadianceCacheParams : packoffset(c006.x);
};

SamplerState __3__40__0__0__g_sampler : register(s1, space40);

SamplerState __3__40__0__0__g_samplerTrilinear : register(s7, space40);

SamplerState __0__4__0__0__g_staticBilinearWrapUWClampV : register(s1, space4);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

SamplerState __0__4__0__0__g_staticVoxelSampler : register(s12, space4);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int _44[4];
  int _58 = (int)(SV_GroupID.x) & 15;
  int _59 = (uint)((uint)(_58)) >> 2;
  _44[0] = ((g_tileIndex[(SV_GroupID.x) >> 6]).x);
  _44[1] = ((g_tileIndex[(SV_GroupID.x) >> 6]).y);
  _44[2] = ((g_tileIndex[(SV_GroupID.x) >> 6]).z);
  _44[3] = ((g_tileIndex[(SV_GroupID.x) >> 6]).w);
  int _77 = _44[(((uint)(SV_GroupID.x) >> 4) & 3)];
  float _87 = __3__36__0__0__g_depth.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
  uint2 _90 = __3__36__0__0__g_stencil.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
  int _92 = _90.x & 127;
  float _101 = g_screenSpaceScale.x * _bufferSizeAndInvSize.x;
  float _104 = (1.0f / g_screenSpaceScale.x) * _bufferSizeAndInvSize.z;
  float _105 = float((uint)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3))));
  float _106 = float((uint)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5))));
  float _111 = (((_105 + 0.5f) * 2.0f) * _104) + -1.0f;
  float _115 = 1.0f - ((((_106 + 0.5f) * 2.0f) * _bufferSizeAndInvSize.w) * (1.0f / g_screenSpaceScale.y));
  float _118 = max(1.0000000116860974e-07f, _87.x);
  float _119 = _nearFarProj.x / _118;
  float _155 = mad((_invViewProjRelative[3].z), _118, mad((_invViewProjRelative[3].y), _115, ((_invViewProjRelative[3].x) * _111))) + (_invViewProjRelative[3].w);
  float _156 = (mad((_invViewProjRelative[0].z), _118, mad((_invViewProjRelative[0].y), _115, ((_invViewProjRelative[0].x) * _111))) + (_invViewProjRelative[0].w)) / _155;
  float _157 = (mad((_invViewProjRelative[1].z), _118, mad((_invViewProjRelative[1].y), _115, ((_invViewProjRelative[1].x) * _111))) + (_invViewProjRelative[1].w)) / _155;
  float _158 = (mad((_invViewProjRelative[2].z), _118, mad((_invViewProjRelative[2].y), _115, ((_invViewProjRelative[2].x) * _111))) + (_invViewProjRelative[2].w)) / _155;
  float _160 = rsqrt(dot(float3(_156, _157, _158), float3(_156, _157, _158)));
  float _161 = _160 * _156;
  float _162 = _160 * _157;
  float _163 = _160 * _158;
  bool _180;
  bool _181;
  bool _184;
  bool _185;
  bool _188;
  bool _189;
  bool _190;
  float _292;
  float _293;
  float _294;
  float _297;
  float _298;
  float _299;
  bool _300;
  int _326;
  int _329;
  bool _330;
  int _338;
  int _339;
  float _340;
  float _341;
  float _342;
  float _343;
  float _391;
  float _392;
  float _393;
  float _394;
  float _395;
  float _396;
  int _547;
  float _787;
  float _788;
  float _789;
  float _800;
  float _801;
  float _802;
  float _846;
  int _862;
  bool _970;
  float _971;
  float _972;
  float _973;
  float _974;
  float _975;
  float _976;
  float _977;
  float _997;
  float _998;
  float _999;
  float _1123;
  float _1124;
  float _1125;
  float _1126;
  float _1132;
  bool _1199;
  int _1288;
  int _1346;
  int _1368;
  int _1426;
  float _1447;
  int _1493;
  int _1556;
  int _1557;
  int _1558;
  int _1559;
  int _1575;
  int _1576;
  int _1577;
  int _1578;
  int _1584;
  int _1647;
  int _1648;
  int _1649;
  int _1650;
  int _1655;
  int _1656;
  int _1657;
  int _1658;
  int _1659;
  int _1662;
  int _1663;
  int _1664;
  int _1665;
  int _1668;
  int _1669;
  int _1670;
  int _1671;
  int _1672;
  bool _1695;
  int _1696;
  int _1697;
  int _1698;
  int _1699;
  int _1700;
  int _1709;
  int _1710;
  int _1711;
  int _1712;
  int _1713;
  float _1769;
  float _1770;
  float _1771;
  float _1772;
  float _1773;
  float _1774;
  float _1775;
  int _1776;
  float _1988;
  float _1989;
  float _1990;
  float _1991;
  float _2008;
  float _2009;
  float _2010;
  float _2168;
  float _2169;
  float _2170;
  float _2171;
  half _2172;
  half _2173;
  half _2174;
  half _2175;
  float _2313;
  float _2314;
  float _2315;
  float _2316;
  float _2317;
  float _2318;
  float _2319;
  float _2320;
  half _2321;
  half _2322;
  half _2323;
  half _2324;
  float _2375;
  float _2376;
  float _2377;
  float _2378;
  int _2379;
  int _2380;
  float _2427;
  float _2428;
  float _2429;
  float _2430;
  int _2431;
  int _2432;
  float _2462;
  float _2463;
  float _2464;
  float _2465;
  float _2584;
  float _2585;
  float _2586;
  float _2605;
  float _2606;
  float _2607;
  float _2608;
  float _2690;
  float _2725;
  float _2726;
  float _2727;
  float _2747;
  float _2804;
  float _2902;
  float _2903;
  float _2904;
  float _2968;
  float _2969;
  float _2970;
  float _2971;
  half _2972;
  half _2973;
  half _2974;
  float _2975;
  float _2976;
  float _2977;
  float _2978;
  float _2979;
  int _3118;
  int _3176;
  float _3217;
  float _3280;
  float _3281;
  float _3282;
  float _3283;
  float _3284;
  int _3285;
  int _3286;
  float _3287;
  float _3288;
  float _3289;
  float _3290;
  float _3291;
  float _3292;
  float _3293;
  float _3294;
  float _3315;
  float _3316;
  float _3317;
  float _3358;
  float _3359;
  float _3360;
  float _3361;
  int _3377;
  bool _3399;
  bool _3429;
  bool _3437;
  int _3451;
  float _3460;
  float _3464;
  float _3522;
  float _3523;
  float _3524;
  float _3525;
  float _3532;
  int _3536;
  int _3594;
  int _3624;
  float _3625;
  float _3626;
  float _3627;
  float _3628;
  float _3629;
  float _3630;
  int _3632;
  float _3848;
  float _3886;
  float _3915;
  float _3917;
  float _3918;
  float _3919;
  float _3920;
  float _3921;
  float _3981;
  float _3982;
  float _3983;
  float _4002;
  int _4056;
  int _4119;
  int _4120;
  int _4121;
  int _4122;
  int _4138;
  int _4139;
  int _4140;
  int _4141;
  int _4148;
  int _4211;
  int _4212;
  int _4213;
  int _4214;
  int _4219;
  int _4220;
  int _4221;
  int _4222;
  int _4223;
  int _4226;
  int _4227;
  int _4228;
  int _4229;
  int _4232;
  int _4233;
  int _4234;
  int _4235;
  int _4236;
  bool _4259;
  int _4260;
  int _4261;
  int _4262;
  int _4263;
  int _4264;
  int _4273;
  int _4274;
  int _4275;
  int _4276;
  int _4277;
  float _4333;
  float _4334;
  float _4335;
  float _4336;
  int _4337;
  float _4538;
  float _4539;
  float _4540;
  float _4541;
  float _4558;
  float _4559;
  float _4560;
  float _4568;
  float _4569;
  float _4570;
  float _4571;
  float _4572;
  int _4618;
  int _4676;
  float _4697;
  float _4755;
  float _4756;
  float _4757;
  int _4770;
  int _4833;
  int _4834;
  int _4835;
  int _4836;
  float _4859;
  float _4860;
  float _4861;
  float _4863;
  float _4864;
  float _4865;
  float _4866;
  float _4867;
  float _4868;
  float _4869;
  int _4870;
  float _4979;
  float _4980;
  float _4981;
  float _4982;
  float _4983;
  float _4984;
  float _4985;
  float _4996;
  float _4997;
  float _4998;
  float _4999;
  float _5000;
  float _5001;
  float _5002;
  float _5003;
  bool _5004;
  float _5005;
  float _5151;
  float _5152;
  float _5153;
  float _5154;
  half _5155;
  half _5156;
  half _5157;
  half _5158;
  float _5296;
  float _5297;
  float _5298;
  float _5299;
  float _5300;
  float _5301;
  float _5302;
  float _5303;
  half _5304;
  half _5305;
  half _5306;
  half _5307;
  float _5358;
  float _5359;
  float _5360;
  float _5361;
  int _5362;
  int _5363;
  float _5410;
  float _5411;
  float _5412;
  float _5413;
  int _5414;
  int _5415;
  float _5445;
  float _5446;
  float _5447;
  float _5448;
  float _5564;
  float _5565;
  float _5566;
  float _5585;
  float _5586;
  float _5587;
  float _5588;
  float _5670;
  float _5702;
  float _5703;
  float _5704;
  float _5724;
  float _5781;
  float _5878;
  float _5879;
  float _5880;
  half _5941;
  half _5942;
  half _5943;
  float _5944;
  float _5968;
  float _5969;
  float _5970;
  float _5981;
  float _5982;
  float _5983;
  float _5984;
  float _5985;
  float _5986;
  float _5987;
  float _5988;
  float _6009;
  float _6010;
  float _6011;
  float _6012;
  float _6013;
  float _6014;
  float _6015;
  int _6022;
  int _6080;
  float _6121;
  float _6144;
  float _6145;
  float _6146;
  float _6174;
  float _6175;
  float _6176;
  bool _6230;
  int _6231;
  int _6232;
  int _6233;
  int _6234;
  int _6235;
  bool _6244;
  int _6245;
  int _6246;
  int _6247;
  int _6248;
  int _6249;
  if ((uint)_92 > (uint)11) {
    bool __defer_166_179 = false;
    if (!((((uint)_92 < (uint)20)) || ((_92 == 107)))) {
      bool _171 = (_92 == 20);
      if ((_90.x & 126) == 96) {
        _184 = _171;
        _185 = true;
        _188 = _185;
        _189 = _184;
        _190 = (_92 == 54);
      } else {
        bool _177 = (_92 == 98);
        if (!(_92 == 66)) {
          _180 = _177;
          _181 = _171;
          __defer_166_179 = true;
        } else {
          _188 = _177;
          _189 = _171;
          _190 = true;
        }
      }
    } else {
      _180 = (_92 == 98);
      _181 = true;
      __defer_166_179 = true;
    }
    if (__defer_166_179) {
      if (!(_92 == 67)) {
        _184 = _181;
        _185 = _180;
        _188 = _185;
        _189 = _184;
        _190 = (_92 == 54);
      } else {
        _188 = _180;
        _189 = _181;
        _190 = true;
      }
    }
  } else {
    _184 = false;
    _185 = false;
    _188 = _185;
    _189 = _184;
    _190 = (_92 == 54);
  }
  bool _193 = (_92 == 33);
  bool _194 = (_92 == 55);
  bool _195 = (_193) || (_194);
  uint4 _198 = __3__36__0__0__g_baseColor.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
  float4 _203 = __3__36__0__0__g_normal.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
  float _209 = float((uint)((uint)(_198.y & 255))) * 0.003921568859368563f;
  float _213 = float((uint)((uint)(((uint)((uint)(_198.z)) >> 8) & 255))) * 0.003921568859368563f;
  float _228 = (saturate(_203.x * 1.0009784698486328f) * 2.0f) + -1.0f;
  float _229 = (saturate(_203.y * 1.0009784698486328f) * 2.0f) + -1.0f;
  float _230 = (saturate(_203.z * 1.0009784698486328f) * 2.0f) + -1.0f;
  float _232 = rsqrt(dot(float3(_228, _229, _230), float3(_228, _229, _230)));
  float _233 = _232 * _228;
  float _234 = _232 * _229;
  float _235 = _230 * _232;
  float _238 = (float((uint)((uint)(((uint)((uint)(_198.w)) >> 8) & 255))) * 0.007843137718737125f) + -1.0f;
  float _239 = (float((uint)((uint)(_198.w & 255))) * 0.007843137718737125f) + -1.0f;
  float _242 = (_238 + _239) * 0.5f;
  float _243 = (_238 - _239) * 0.5f;
  float _247 = (1.0f - abs(_242)) - abs(_243);
  float _249 = rsqrt(dot(float3(_242, _243, _247), float3(_242, _243, _247)));
  float _250 = _249 * _242;
  float _251 = _249 * _243;
  float _252 = _249 * _247;
  float _254 = select((_235 >= 0.0f), 1.0f, -1.0f);
  float _257 = -0.0f - (1.0f / (_254 + _235));
  float _258 = _234 * _257;
  float _259 = _258 * _233;
  float _260 = _254 * _233;
  float _269 = mad(_252, _233, mad(_251, _259, ((((_260 * _233) * _257) + 1.0f) * _250)));
  float _273 = mad(_252, _234, mad(_251, (_254 + (_258 * _234)), ((_250 * _254) * _259)));
  float _277 = mad(_252, _235, mad(_251, (-0.0f - _234), (-0.0f - (_260 * _250))));
  float _279 = rsqrt(dot(float3(_269, _273, _277), float3(_269, _273, _277)));
  float _280 = _279 * _269;
  float _281 = _279 * _273;
  float _282 = _279 * _277;
  bool _284 = (_92 == 29);
  if (((_92 == 24)) || (_284)) {
    _292 = 0.0f;
    _293 = 0.0f;
    _294 = select(_284, _213, 0.0f);
    _297 = _292;
    _298 = _293;
    _299 = _294;
    _300 = (_92 == 107);
  } else {
    if (!((uint)(_92 + -11) < (uint)9)) {
      _292 = _213;
      _293 = _209;
      _294 = 0.0f;
      _297 = _292;
      _298 = _293;
      _299 = _294;
      _300 = (_92 == 107);
    } else {
      _297 = _213;
      _298 = _209;
      _299 = 0.0f;
      _300 = true;
    }
  }
  float _302 = select(((_188) || (_300)), 0.0f, _298);
  if ((_195) || (_190)) {
    float4 _306 = __3__36__0__0__g_character.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
    float _313 = (_306.x * 2.0f) + -1.0f;
    float _314 = (_306.y * 2.0f) + -1.0f;
    float _315 = (_306.z * 2.0f) + -1.0f;
    float _317 = rsqrt(dot(float3(_313, _314, _315), float3(_313, _314, _315)));
    if (_194) {
      if (_306.z < 0.0010000000474974513f) {
        _326 = 53;
      } else {
        _326 = 55;
      }
      _329 = _326;
      _330 = (_326 == 55);
    } else {
      if (!_193) {
        _326 = _92;
        _329 = _326;
        _330 = (_326 == 55);
      } else {
        _329 = 33;
        _330 = true;
      }
    }
    _338 = _329;
    _339 = ((int)(uint)((int)(_330)));
    _340 = _297;
    _341 = (_313 * _317);
    _342 = (_314 * _317);
    _343 = (_315 * _317);
  } else {
    _338 = _92;
    _339 = ((int)(uint)((int)(_195)));
    _340 = select(((((_90.x & 126) == 64)) && ((_92 != 65))), (_297 * 0.60009765625f), _297);
    _341 = 0.0f;
    _342 = 0.0f;
    _343 = 0.0f;
  }
  float _344 = max(0.019999999552965164f, _340);
  if (((_92 == 19)) || (_190)) {
    float _349 = (_342 * _282) - (_343 * _281);
    float _352 = (_343 * _280) - (_341 * _282);
    float _355 = (_341 * _281) - (_342 * _280);
    float _357 = rsqrt(dot(float3(_349, _352, _355), float3(_349, _352, _355)));
    _391 = _341;
    _392 = _342;
    _393 = _343;
    _394 = (_357 * _349);
    _395 = (_357 * _352);
    _396 = (_357 * _355);
  } else {
    float _364 = (_282 * _162) - (_281 * _163);
    float _367 = (_280 * _163) - (_282 * _161);
    float _370 = (_281 * _161) - (_280 * _162);
    float _372 = rsqrt(dot(float3(_364, _367, _370), float3(_364, _367, _370)));
    float _373 = _372 * _364;
    float _374 = _372 * _367;
    float _375 = _372 * _370;
    float _378 = (_375 * _281) - (_374 * _282);
    float _381 = (_373 * _282) - (_375 * _280);
    float _384 = (_374 * _280) - (_373 * _281);
    float _386 = rsqrt(dot(float3(_378, _381, _384), float3(_378, _381, _384)));
    _391 = (_378 * _386);
    _392 = (_381 * _386);
    _393 = (_384 * _386);
    _394 = _373;
    _395 = _374;
    _396 = _375;
  }
  int _397 = _338 & -2;
  float _400 = _344 * _344;
  float _401 = _400 * select((_397 == 64), 0.5f, 2.0f);
  int _434 = ((int)(((((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) + 1013904242u));
  int _442 = ((int)(((((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) + (uint)(-626627285)));
  uint _446 = ((uint)(_442 ^ (((uint)(((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))) >> 5) + -939442524))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)));
  int _458 = ((int)(((((uint)((((int)((_446 << 4) + (uint)(-1383041155))) ^ ((int)(_446 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_446) >> 5)) + 2123724318u)))) + (((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_446 << 4) + (uint)(-1383041155))) ^ ((int)(_446 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_446) >> 5)) + 2123724318u)))) + (((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) + 2027808484u));
  int _466 = ((int)(((((uint)(_458 ^ (((uint)(((uint)((((int)((_446 << 4) + (uint)(-1383041155))) ^ ((int)(_446 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_446) >> 5)) + 2123724318u)))) + (((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _446) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)(_458 ^ (((uint)(((uint)((((int)((_446 << 4) + (uint)(-1383041155))) ^ ((int)(_446 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_446) >> 5)) + 2123724318u)))) + (((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _446) + 2027808484u));
  uint _470 = ((uint)(_466 ^ ((int)(((uint)((uint)(((uint)(_458 ^ (((uint)(((uint)((((int)((_446 << 4) + (uint)(-1383041155))) ^ ((int)(_446 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_446) >> 5)) + 2123724318u)))) + (((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _446) >> 5)) + 2123724318u)))) + (((uint)((((int)((_446 << 4) + (uint)(-1383041155))) ^ ((int)(_446 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_446) >> 5)) + 2123724318u)))) + (((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x))));
  uint _478 = ((uint)((((int)((_470 << 4) + (uint)(-1556008596))) ^ ((int)(_470 + 387276957u))) ^ (((uint)(_470) >> 5) + -939442524))) + (((uint)(_458 ^ (((uint)(((uint)((((int)((_446 << 4) + (uint)(-1383041155))) ^ ((int)(_446 + (uint)(-626627285)))) ^ ((int)(((uint)((uint)(_446) >> 5)) + 2123724318u)))) + (((uint)(_434 ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) + 1013904242u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)) >> 5) + -939442524))) + (((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105))) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) + (uint)(-1640531527)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((uint)(_frameNumber.x) << 4) + (uint)(-1556008596))) ^ ((int)((uint)(_frameNumber.x) + (uint)(-1640531527)))) ^ (((uint)((uint)(_frameNumber.x)) >> 5) + -939442524))) + uint((_bufferSizeAndInvSize.x * _106) + _105)) >> 5)) + 2123724318u)))) + (uint)(_frameNumber.x)))) >> 5) + -939442524))) + _446);
  int _509 = (((int)(((((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)) + 1401181199u))) ^ (((uint)(((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)) >> 5) + -939442524);
  int _522 = ((int)(((((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470))) + (uint)(-239350328)));
  uint _526 = ((uint)(_522 ^ (((uint)(((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470))) >> 5) + -939442524))) + ((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478));
  bool _536 = (((int)(_526) & 16777215) == 0);
  if (_536) {
    int _541 = ((int)(((((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) + (uint)(-1879881855)));
    _547 = ((int)(((uint)(_541 ^ (((uint)(((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) >> 5) + -939442524))) + _526));
  } else {
    _547 = (int)(_526);
  }
  uint _553 = min((uint)(1023), (uint)((int)(uint(float((uint)((uint)(((int)(_547 * 48271)) & 16777215))) * 6.103515625e-05f))));
  float _555 = float((uint)(uint)(_frameNumber.x));
  float _566 = (frac(((_555 * 92.0f) + _105) * 0.0078125f) * 128.0f) + -64.34062194824219f;
  float _567 = (frac(((_555 * 71.0f) + _106) * 0.0078125f) * 128.0f) + -72.46562194824219f;
  float _572 = frac(dot(float3((_566 * _566), (_567 * _567), (_567 * _566)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
  uint _576 = uint(_572 * 287478368.0f);
  float _581 = float((uint)((uint)((int)(uint(_572 * 51540816.0f)) & 65535))) * 1.52587890625e-05f;
  float _597 = (sqrt((sqrt(1.0f / ((_401 * _401) + 1.0f)) + 1.0f) * 0.5f) * 0.949999988079071f) * ((float((uint)((uint)(reversebits(_553) ^ (int)(_576)))) * 2.3283064365386963e-10f) + -0.5f);
  float _598 = _597 + 0.5f;
  float _599 = dot(float3(_161, _162, _163), float3(_280, _281, _282));
  float _600 = frac(_581 + (float((uint)_553) * 0.0009765625f)) * 6.2831854820251465f;
  float _601 = 0.5f - _597;
  float _602 = sin(_600);
  float _603 = cos(_600);
  if (_339 == 0) {
    if (_190) {
      float _681 = saturate(_344 + 0.5f);
      float _684 = max(0.0f, sqrt(_598 / _601));
      float _686 = (_603 * _400) * _684;
      float _689 = ((_681 * _681) * _602) * _684;
      float _695 = 1.0f / sqrt(((_689 * _689) + 1.0f) + (_686 * _686));
      float _696 = _695 * _686;
      float _697 = _695 * _689;
      _800 = mad(_695, _280, mad(_697, _394, (_696 * _391)));
      _801 = mad(_695, _281, mad(_697, _395, (_696 * _392)));
      _802 = mad(_695, _282, mad(_697, _396, (_696 * _393)));
    } else {
      float _709 = select((_282 >= 0.0f), 1.0f, -1.0f);
      float _712 = -0.0f - (1.0f / (_709 + _282));
      float _714 = (_280 * _281) * _712;
      float _718 = (((_280 * _280) * _709) * _712) + 1.0f;
      float _719 = _714 * _709;
      float _721 = -0.0f - (_709 * _280);
      float _724 = ((_281 * _281) * _712) + _709;
      float _725 = -0.0f - _281;
      float _726 = dot(float3(_161, _162, _163), float3(_718, _719, _721));
      float _727 = dot(float3(_161, _162, _163), float3(_714, _724, _725));
      float _728 = -0.0f - _599;
      float _730 = _400 * _400;
      if (_338 == 29) {
        float _737 = saturate(sqrt(_601 / ((_598 * (_730 + -1.0f)) + 1.0f)));
        float _740 = sqrt(1.0f - (_737 * _737));
        _787 = (_740 * _603);
        _788 = (_740 * _602);
        _789 = _737;
      } else {
        float _744 = -0.0f - _400;
        float _745 = _726 * _744;
        float _746 = _727 * _744;
        float _748 = rsqrt(dot(float3(_745, _746, _728), float3(_745, _746, _728)));
        float _751 = _748 * _728;
        float _756 = sqrt((_727 * _727) + (_726 * _726)) + 1.0f;
        float _757 = _756 * _756;
        float _766 = select((_599 < -0.0f), (((_757 - (_757 * _730)) / (_757 + ((_599 * _599) * _730))) * _751), _751);
        float _769 = mad(_601, (_766 + 1.0f), (-0.0f - _766));
        float _773 = sqrt(saturate(1.0f - (_769 * _769)));
        float _778 = _769 + _751;
        float _779 = ((_773 * _603) + (_748 * _745)) * _400;
        float _780 = ((_773 * _602) + (_748 * _746)) * _400;
        float _782 = rsqrt(dot(float3(_779, _780, _778), float3(_779, _780, _778)));
        _787 = (_779 * _782);
        _788 = (_780 * _782);
        _789 = (_782 * _778);
      }
      _800 = mad(_789, _280, mad(_788, _714, (_787 * _718)));
      _801 = mad(_789, _281, mad(_788, _724, (_787 * _719)));
      _802 = mad(_789, _282, mad(_788, _725, (_787 * _721)));
    }
  } else {
    float _606 = select((_282 >= 0.0f), 1.0f, -1.0f);
    float _609 = -0.0f - (1.0f / (_606 + _282));
    float _611 = (_280 * _281) * _609;
    float _615 = (((_280 * _280) * _606) * _609) + 1.0f;
    float _616 = _611 * _606;
    float _618 = -0.0f - (_606 * _280);
    float _621 = ((_281 * _281) * _609) + _606;
    float _622 = -0.0f - _281;
    float _623 = dot(float3(_161, _162, _163), float3(_615, _616, _618));
    float _624 = dot(float3(_161, _162, _163), float3(_611, _621, _622));
    float _625 = -0.0f - _599;
    float _626 = -0.0f - _400;
    float _627 = _623 * _626;
    float _628 = _624 * _626;
    float _630 = rsqrt(dot(float3(_627, _628, _625), float3(_627, _628, _625)));
    float _633 = _630 * _625;
    float _638 = sqrt((_624 * _624) + (_623 * _623)) + 1.0f;
    float _639 = _400 * _400;
    float _640 = _638 * _638;
    float _649 = select((_599 < -0.0f), (((_640 - (_640 * _639)) / (_640 + ((_599 * _599) * _639))) * _633), _633);
    float _652 = mad(_601, (_649 + 1.0f), (-0.0f - _649));
    float _656 = sqrt(saturate(1.0f - (_652 * _652)));
    float _661 = _652 + _633;
    float _662 = ((_656 * _603) + (_630 * _627)) * _400;
    float _663 = ((_656 * _602) + (_630 * _628)) * _400;
    float _665 = rsqrt(dot(float3(_662, _663, _661), float3(_662, _663, _661)));
    float _666 = _662 * _665;
    float _667 = _663 * _665;
    float _668 = _665 * _661;
    _800 = mad(_668, _280, mad(_667, _611, (_666 * _615)));
    _801 = mad(_668, _281, mad(_667, _621, (_666 * _616)));
    _802 = mad(_668, _282, mad(_667, _622, (_666 * _618)));
  }
  float _807 = dot(float3((-0.0f - _161), (-0.0f - _162), (-0.0f - _163)), float3(_800, _801, _802)) * 2.0f;
  float _811 = (_807 * _800) + _161;
  float _812 = (_807 * _801) + _162;
  float _813 = (_807 * _802) + _163;
  float _814 = _599 * 2.0f;
  float _818 = _161 - (_814 * _280);
  float _819 = _162 - (_814 * _281);
  float _820 = _163 - (_814 * _282);
  float _822 = rsqrt(dot(float3(_818, _819, _820), float3(_818, _819, _820)));
  float _827 = 4096.0f - (_302 * 3072.0f);
  if ((uint)_338 > (uint)11) {
    if (((_397 == 106)) || (((((uint)(_338 + -27) < (uint)2)) || ((((_338 == 26)) || (((((uint)_338 < (uint)21)) || (((_338 & -3) == 105))))))))) {
      _846 = min(256.0f, _827);
    } else {
      _846 = _827;
    }
  } else {
    if (_397 == 6) {
      _846 = min(256.0f, _827);
    } else {
      _846 = _827;
    }
  }
  float _849 = _exposure3.w * _846;
  float _851 = select(_190, (_849 * 0.5f), _849);
  if (_536) {
    int _856 = ((int)(((((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) + (uint)(-1879881855)));
    _862 = ((int)(((uint)(_856 ^ (((uint)(((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) >> 5) + -939442524))) + _526));
  } else {
    _862 = (int)(_526);
  }
  int _868 = (int)(uint(float((uint)((uint)(((int)(_862 * 48271)) & 16777215))) * 1.9067525727223256e-06f)) & 31;
  float _872 = frac((float((uint)(uint)(_868)) * 0.03125f) + _581);
  float _876 = float((uint)((uint)(reversebits(_868) ^ (int)(_576)))) * 2.3283064365386963e-10f;
  float4 _878 = __3__36__0__0__g_raytracingHitResult.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
  float _880 = _878.x * _811;
  float _881 = _878.x * _812;
  float _882 = _878.x * _813;
  float _883 = _880 + _156;
  float _884 = _881 + _157;
  float _885 = _882 + _158;
  float _921 = mad((_viewProjRelative[3].z), _885, mad((_viewProjRelative[3].y), _884, (_883 * (_viewProjRelative[3].x)))) + (_viewProjRelative[3].w);
  float _922 = (mad((_viewProjRelative[0].z), _885, mad((_viewProjRelative[0].y), _884, (_883 * (_viewProjRelative[0].x)))) + (_viewProjRelative[0].w)) / _921;
  float _923 = (mad((_viewProjRelative[1].z), _885, mad((_viewProjRelative[1].y), _884, (_883 * (_viewProjRelative[1].x)))) + (_viewProjRelative[1].w)) / _921;
  float4 _935 = __3__36__0__0__g_raytracingNormal.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
  if (!(((_935.w == 1.0f)) && ((((_935.z == 0.0f)) && ((((_935.x == 0.0f)) && ((_935.y == 0.0f))))))) | !(_renderParams.z > 0.0f)) {
    float4 _953 = __3__36__0__0__g_raytracingBaseColor.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
    float _961 = (_935.x * 2.0f) + -1.0f;
    float _962 = (_935.y * 2.0f) + -1.0f;
    float _963 = (_935.z * 2.0f) + -1.0f;
    float _965 = rsqrt(dot(float3(_961, _962, _963), float3(_961, _962, _963)));
    _970 = false;
    _971 = _953.x;
    _972 = _953.y;
    _973 = _953.z;
    _974 = _953.w;
    _975 = (_965 * _961);
    _976 = (_965 * _962);
    _977 = (_965 * _963);
  } else {
    _970 = true;
    _971 = 0.0f;
    _972 = 0.0f;
    _973 = 0.0f;
    _974 = 0.0f;
    _975 = _935.x;
    _976 = _935.y;
    _977 = _935.z;
  }
  float _978 = select(_970, 0.0f, _975);
  float _979 = select(_970, 0.0f, _976);
  float _980 = select(_970, 0.0f, _977);
  float _981 = saturate(_974);
  float _982 = saturate(_935.w);
  bool _983 = (_982 == 0.0f);
  if (_983) {
    _997 = 0.0f;
    _998 = 1.0f;
    _999 = min((_851 * select((((_338 == 54)) || ((_397 == 66))), 8.0f, 32.0f)), (exp2((saturate(_981) * 20.0f) + -8.0f) + -0.00390625f));
  } else {
    _997 = _981;
    _998 = _982;
    _999 = 0.0f;
  }
  float _1000 = 1.0f - _997;
  float _1001 = _1000 * _971;
  float _1002 = _1000 * _972;
  float _1003 = _1000 * _973;
  int _1005 = ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))) & 3;
  float _1013 = float((uint)((uint)(((int)((uint)(_frameNumber.x) + ((uint)((((_1005 << 1) | _1005) << 1) | (((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))) & 1))))) & 3))) * 0.0416666679084301f;
  float _1014 = _1013 + -1.0f;
  float _1015 = 1.0f - _1013;
  bool _1016 = (((mad((_viewProjRelative[2].z), _885, mad((_viewProjRelative[2].y), _884, (_883 * (_viewProjRelative[2].x)))) + (_viewProjRelative[2].w)) / _921) > 0.0f);
  bool __defer_996_1282 = false;
  [branch]
  if ((((_970) && (_1016)) || (!(_970) && ((_1016) && ((((((_922 > _1014)) && ((_922 < _1015)))) && ((((_923 > _1014)) && ((_923 < _1015)))))))))) {
    float _1029 = _923 * -0.5f;
    float _1031 = _1029 + 0.5f;
    float _1032 = _104 * 0.5f;
    float _1033 = 1.0f - _1032;
    float _1035 = min(max(((_922 * 0.5f) + 0.5f), _1032), _1033);
    float _1036 = _1035 * _bufferSizeAndInvSize.x;
    float _1037 = _1031 * _bufferSizeAndInvSize.y;
    uint _1038 = uint(_1036);
    uint _1039 = uint(_1037);
    float _1040 = __3__36__0__0__g_depth.Load(int3((int)(_1038), (int)(_1039), 0));
    uint2 _1042 = __3__36__0__0__g_stencil.Load(int3((int)(_1038), (int)(_1039), 0));
    int _1044 = _1042.x & 127;
    float _1046 = _nearFarProj.x / max(1.0000000116860974e-07f, _1040.x);
    float _1048 = abs(_921 - _1046);
    bool __defer_1027_1063 = false;
    if ((((_1048 < ((_1046 * 10.0f) + 0.10000000149011612f))) && (((_970) || ((_1048 < ((_1046 * 0.10000000149011612f) + 0.10000000149011612f)))))) || (((!(((_1048 < ((_1046 * 10.0f) + 0.10000000149011612f))) && (((_970) || ((_1048 < ((_1046 * 0.10000000149011612f) + 0.10000000149011612f))))))) && (!(!(_878.x >= 99999.0f)))) && (((_1040.x < 1.0000000116860974e-07f)) || ((_1040.x == 1.0f))))) {
      __defer_1027_1063 = true;
    } else {
      __defer_996_1282 = true;
    }
    if (__defer_1027_1063) {
      if ((((_878.x < 99999.0f) && ((uint)(_1042.x & 24) > (uint)23)) || (!(_878.x < 99999.0f) && !(_1044 == 0)))) {
        __defer_996_1282 = true;
      } else {
        if ((((_878.x < 99999.0f) && (!((uint)(_1042.x & 24) > (uint)23))) && (!(_1044 == 0)))) {
          float _1100 = mad((_viewProjRelativePrev[3].z), _885, mad((_viewProjRelativePrev[3].y), _884, ((_viewProjRelativePrev[3].x) * _883))) + (_viewProjRelativePrev[3].w);
          float4 _1111 = __3__36__0__0__g_sceneDiffuseHalfPrev.SampleLevel(__3__40__0__0__g_sampler, float2(min(max(((((mad((_viewProjRelativePrev[0].z), _885, mad((_viewProjRelativePrev[0].y), _884, ((_viewProjRelativePrev[0].x) * _883))) + (_viewProjRelativePrev[0].w)) / _1100) * 0.5f) + 0.5f), _1032), _1033), (0.5f - (((mad((_viewProjRelativePrev[1].z), _885, mad((_viewProjRelativePrev[1].y), _884, ((_viewProjRelativePrev[1].x) * _883))) + (_viewProjRelativePrev[1].w)) / _1100) * 0.5f))), 0.0f);
          _1123 = _1111.x;
          _1124 = _1111.y;
          _1125 = _1111.z;
          _1126 = 1.0f;
        } else {
          float4 _1118 = __3__36__0__0__g_sceneColor.SampleLevel(__3__40__0__0__g_sampler, float2(_1035, _1031), 0.0f);
          _1123 = _1118.x;
          _1124 = _1118.y;
          _1125 = _1118.z;
          _1126 = 0.0f;
        }
        if (_189) {
          _1132 = saturate(1.0f - (_119 * 0.019999999552965164f));
        } else {
          _1132 = 1.0f;
        }
        float _1148 = dot(float3(_1123, _1124, _1125), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _1149 = min((((_1132 * _851) * (0.1875f - (saturate(_878.x * 0.019999999552965164f) * 0.13750000298023224f))) * saturate(1.0f - (saturate((_344 * 5.0f) * saturate(_878.x * 16.0f)) * 0.9375f))), _1148);
        float _1153 = max(9.999999717180685e-10f, _1148);
        float _1154 = (_1149 * _1123) / _1153;
        float _1155 = (_1149 * _1124) / _1153;
        float _1156 = (_1149 * _1125) / _1153;
        bool _1157 = (_878.x > 0.0f);
        if (_970) {
          bool _1160 = (_878.x >= 99999.0f);
          uint _1165 = uint((_1035 * _101) + 0.5f);
          uint _1166 = uint((_1037 * g_screenSpaceScale.y) + 0.5f);
          uint _1168 = __3__36__0__0__g_sceneNormal.Load(int3((int)(_1165), (int)(_1166), 0));
          float _1184 = min(1.0f, ((float((uint)((uint)(_1168.x & 1023))) * 0.001956947147846222f) + -1.0f));
          float _1185 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1168.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _1186 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1168.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _1188 = rsqrt(dot(float3(_1184, _1185, _1186), float3(_1184, _1185, _1186)));
          if (!_1160) {
            _1199 = (dot(float3((-0.0f - _811), (-0.0f - _812), (-0.0f - _813)), float3((_1188 * _1184), (_1188 * _1185), (_1188 * _1186))) > -0.20000000298023224f);
          } else {
            _1199 = true;
          }
          float _1200 = select(_1199, 1.0f, 0.0f);
          float _1202 = saturate(_119 * 0.009999999776482582f);
          float _1208 = ((_1202 + _1200) - (_1202 * _1200)) * _renderParams.z;
          float _1209 = _1208 * _1154;
          float _1210 = _1208 * _1155;
          float _1211 = _1208 * _1156;
          float _1212 = select(_1160, 10000.0f, _878.x);
          uint _1229 = uint((float((uint)((uint)(((int)(_frameNumber.x * 73)) & 1023))) + (float((uint)_1166) * _101)) + float((uint)_1165));
          int _1230 = (uint)(_1229) >> 1;
          int _1232 = (uint)(_1229) >> 3;
          float _1244 = float((uint)_1229);
          float _1247 = 0.33676624298095703f / sqrt(_1244 + -0.30000001192092896f);
          float _1252 = (_1247 + (_1244 * 0.7548776268959045f)) * ((float((uint)((uint)(((int)(_1230 * -1029531031)) ^ _1232))) * 2.3283064365386963e-10f) + -0.5f);
          float _1253 = (_1247 + (_1244 * 0.5698402523994446f)) * ((float((uint)((uint)(((int)((((int)(_1230 * 1103515245)) ^ 1) * 1103515245)) ^ _1232))) * 2.3283064365386963e-10f) + -0.5f);
          float _1266 = __3__36__0__0__g_depth.Load(int3(int((_1036 + -24.0f) + ((_1252 - floor(_1252)) * 48.0f)), int((_1037 + -24.0f) + ((_1253 - floor(_1253)) * 48.0f)), 0));
          int _1280 = (int)(uint)((int)((_1157) && ((!_1160))));
          _3280 = _1209;
          _3281 = _1210;
          _3282 = _1211;
          _3283 = ((((_renderParams.z * _1126) * saturate(min(_1035, (1.0f - _1035)) * 20.0f)) * saturate(min(_1031, (0.5f - _1029)) * 20.0f)) * (1.0f - (float((bool)((uint)(((_1266.x < 1.0000000116860974e-07f)) || ((_1266.x == 1.0f))))) * 0.75f)));
          _3284 = _1212;
          _3285 = _1280;
          _3286 = _1280;
          _3287 = _1209;
          _3288 = _1210;
          _3289 = _1211;
          _3290 = select(_1160, 0.0f, 1.0f);
          _3291 = _883;
          _3292 = _884;
          _3293 = _885;
          _3294 = _1212;
        } else {
          _3280 = 0.0f;
          _3281 = 0.0f;
          _3282 = 0.0f;
          _3283 = 0.0f;
          _3284 = _878.x;
          _3285 = 0;
          _3286 = ((int)(uint)((int)(_1157)));
          _3287 = _1154;
          _3288 = _1155;
          _3289 = _1156;
          _3290 = _1126;
          _3291 = 0.0f;
          _3292 = 0.0f;
          _3293 = 0.0f;
          _3294 = 0.0f;
        }
      }
    }
  } else {
    __defer_996_1282 = true;
  }
  if (__defer_996_1282) {
    if (((_878.x > 0.0f)) && ((_878.x < 10000.0f))) {
      _1288 = 0;
      while(true) {
        int _1328 = int(floor(((_wrappedViewPos.x + _883) * ((_clipmapOffsets[_1288]).w)) + ((_clipmapRelativeIndexOffsets[_1288]).x)));
        int _1329 = int(floor(((_wrappedViewPos.y + _884) * ((_clipmapOffsets[_1288]).w)) + ((_clipmapRelativeIndexOffsets[_1288]).y)));
        int _1330 = int(floor(((_wrappedViewPos.z + _885) * ((_clipmapOffsets[_1288]).w)) + ((_clipmapRelativeIndexOffsets[_1288]).z)));
        if (!((((((((int)_1328 >= (int)int(((_clipmapOffsets[_1288]).x) + -63.0f))) && (((int)_1328 < (int)int(((_clipmapOffsets[_1288]).x) + 63.0f))))) && (((((int)_1329 >= (int)int(((_clipmapOffsets[_1288]).y) + -31.0f))) && (((int)_1329 < (int)int(((_clipmapOffsets[_1288]).y) + 31.0f))))))) && (((((int)_1330 >= (int)int(((_clipmapOffsets[_1288]).z) + -63.0f))) && (((int)_1330 < (int)int(((_clipmapOffsets[_1288]).z) + 63.0f))))))) {
          if ((uint)(_1288 + 1) < (uint)8) {
            _1288 = (_1288 + 1);
            continue;
          } else {
            _1346 = -10000;
          }
        } else {
          _1346 = _1288;
        }
        float _1352 = float((int)((int)(1u << (_1346 & 31)))) * _voxelParams.x;
        float _1353 = -0.0f - _811;
        float _1354 = -0.0f - _812;
        float _1355 = -0.0f - _813;
        float _1360 = min(_878.x, (_1352 * 0.5f));
        float _1361 = _1360 * select(_970, _1353, _975);
        float _1362 = _1360 * select(_970, _1354, _976);
        float _1363 = _1360 * select(_970, _1355, _977);
        float _1364 = _1361 + _883;
        float _1365 = _1362 + _884;
        float _1366 = _1363 + _885;
        _1368 = 0;
        while(true) {
          int _1408 = int(floor(((_wrappedViewPos.x + _1364) * ((_clipmapOffsets[_1368]).w)) + ((_clipmapRelativeIndexOffsets[_1368]).x)));
          int _1409 = int(floor(((_wrappedViewPos.y + _1365) * ((_clipmapOffsets[_1368]).w)) + ((_clipmapRelativeIndexOffsets[_1368]).y)));
          int _1410 = int(floor(((_wrappedViewPos.z + _1366) * ((_clipmapOffsets[_1368]).w)) + ((_clipmapRelativeIndexOffsets[_1368]).z)));
          if (!((((((((int)_1408 >= (int)int(((_clipmapOffsets[_1368]).x) + -63.0f))) && (((int)_1408 < (int)int(((_clipmapOffsets[_1368]).x) + 63.0f))))) && (((((int)_1409 >= (int)int(((_clipmapOffsets[_1368]).y) + -31.0f))) && (((int)_1409 < (int)int(((_clipmapOffsets[_1368]).y) + 31.0f))))))) && (((((int)_1410 >= (int)int(((_clipmapOffsets[_1368]).z) + -63.0f))) && (((int)_1410 < (int)int(((_clipmapOffsets[_1368]).z) + 63.0f))))))) {
            if ((uint)(_1368 + 1) < (uint)8) {
              _1368 = (_1368 + 1);
              continue;
            } else {
              _1426 = -10000;
            }
          } else {
            _1426 = _1368;
          }
          float _1430 = _voxelParams.x * 0.5f;
          float _1431 = _1430 * float((int)((int)(1u << (_1426 & 31))));
          float _1435 = saturate((_1431 * _1431) / (_878.x * _878.x));
          float _1436 = _872 * 6.2831854820251465f;
          if (_1435 < 0.009999999776482582f) {
            _1447 = (((_1435 * 0.125f) + 0.5f) * _1435);
          } else {
            _1447 = (1.0f - sqrt(1.0f - _1435));
          }
          float _1449 = 1.0f - (_1447 * _876);
          float _1452 = sqrt(1.0f - (_1449 * _1449));
          float _1455 = cos(_1436) * _1452;
          float _1456 = sin(_1436) * _1452;
          float _1458 = select((_813 >= 0.0f), 1.0f, -1.0f);
          float _1461 = -0.0f - (1.0f / (_1458 + _813));
          float _1463 = (_811 * _812) * _1461;
          float _1487 = (_1361 + _156) + (mad(_1449, _811, mad(_1456, _1463, (((((_811 * _811) * _1458) * _1461) + 1.0f) * _1455))) * _878.x);
          float _1489 = (_1362 + _157) + (mad(_1449, _812, mad(_1456, (((_812 * _812) * _1461) + _1458), ((_1455 * _1458) * _1463))) * _878.x);
          float _1491 = (_1363 + _158) + (mad(_1449, _813, mad(_1456, _1354, (-0.0f - ((_1458 * _811) * _1455)))) * _878.x);
          _1493 = 0;
          while(true) {
            int _1533 = int(floor(((_wrappedViewPos.x + _1487) * ((_clipmapOffsets[_1493]).w)) + ((_clipmapRelativeIndexOffsets[_1493]).x)));
            int _1534 = int(floor(((_wrappedViewPos.y + _1489) * ((_clipmapOffsets[_1493]).w)) + ((_clipmapRelativeIndexOffsets[_1493]).y)));
            int _1535 = int(floor(((_wrappedViewPos.z + _1491) * ((_clipmapOffsets[_1493]).w)) + ((_clipmapRelativeIndexOffsets[_1493]).z)));
            if ((((((((int)_1533 >= (int)int(((_clipmapOffsets[_1493]).x) + -63.0f))) && (((int)_1533 < (int)int(((_clipmapOffsets[_1493]).x) + 63.0f))))) && (((((int)_1534 >= (int)int(((_clipmapOffsets[_1493]).y) + -31.0f))) && (((int)_1534 < (int)int(((_clipmapOffsets[_1493]).y) + 31.0f))))))) && (((((int)_1535 >= (int)int(((_clipmapOffsets[_1493]).z) + -63.0f))) && (((int)_1535 < (int)int(((_clipmapOffsets[_1493]).z) + 63.0f)))))) {
              _1556 = (_1533 & 127);
              _1557 = (_1534 & 63);
              _1558 = (_1535 & 127);
              _1559 = _1493;
            } else {
              if ((uint)(_1493 + 1) < (uint)8) {
                _1493 = (_1493 + 1);
                continue;
              } else {
                _1556 = -10000;
                _1557 = -10000;
                _1558 = -10000;
                _1559 = -10000;
              }
            }
            if (!((uint)_1559 > (uint)5)) {
              uint _1569 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1556, _1557, ((int)(((uint)(((int)(_1559 * 130)) | 1)) + (uint)(_1558))), 0));
              bool _1572 = ((_1569.x & 4194303) == 0);
              [branch]
              if (!_1572) {
                _1575 = _1556;
                _1576 = _1557;
                _1577 = _1558;
                _1578 = _1559;
              } else {
                _1575 = -10000;
                _1576 = -10000;
                _1577 = -10000;
                _1578 = -10000;
              }
              float _1579 = _1430 * float((int)((int)(1u << (_1559 & 31))));
              _1584 = 0;
              while(true) {
                int _1624 = int(floor((((_1487 - _1579) + _wrappedViewPos.x) * ((_clipmapOffsets[_1584]).w)) + ((_clipmapRelativeIndexOffsets[_1584]).x)));
                int _1625 = int(floor((((_1489 - _1579) + _wrappedViewPos.y) * ((_clipmapOffsets[_1584]).w)) + ((_clipmapRelativeIndexOffsets[_1584]).y)));
                int _1626 = int(floor((((_1491 - _1579) + _wrappedViewPos.z) * ((_clipmapOffsets[_1584]).w)) + ((_clipmapRelativeIndexOffsets[_1584]).z)));
                if ((((((((int)_1624 >= (int)int(((_clipmapOffsets[_1584]).x) + -63.0f))) && (((int)_1624 < (int)int(((_clipmapOffsets[_1584]).x) + 63.0f))))) && (((((int)_1625 >= (int)int(((_clipmapOffsets[_1584]).y) + -31.0f))) && (((int)_1625 < (int)int(((_clipmapOffsets[_1584]).y) + 31.0f))))))) && (((((int)_1626 >= (int)int(((_clipmapOffsets[_1584]).z) + -63.0f))) && (((int)_1626 < (int)int(((_clipmapOffsets[_1584]).z) + 63.0f)))))) {
                  _1647 = (_1624 & 127);
                  _1648 = (_1625 & 63);
                  _1649 = (_1626 & 127);
                  _1650 = _1584;
                } else {
                  if ((uint)(_1584 + 1) < (uint)8) {
                    _1584 = (_1584 + 1);
                    continue;
                  } else {
                    _1647 = -10000;
                    _1648 = -10000;
                    _1649 = -10000;
                    _1650 = -10000;
                  }
                }
                if (!((uint)_1650 > (uint)5)) {
                  if (_1572) {
                    _1655 = 0;
                    _1656 = _1578;
                    _1657 = _1577;
                    _1658 = _1576;
                    _1659 = _1575;
                    while(true) {
                      _1668 = 0;
                      _1669 = _1656;
                      _1670 = _1657;
                      _1671 = _1658;
                      _1672 = _1659;
                      while(true) {
                        if (!((((uint)(_1668 + _1648) > (uint)63)) || (((uint)(_1647 | (_1655 + _1649)) > (uint)127)))) {
                          uint _1690 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1647, (_1668 + _1648), ((int)(((uint)(_1655 + _1649)) + ((uint)(((int)(_1650 * 130)) | 1)))), 0));
                          int _1692 = _1690.x & 4194303;
                          _1695 = (_1692 != 0);
                          _1696 = _1692;
                          _1697 = _1650;
                          _1698 = (_1655 + _1649);
                          _1699 = (_1668 + _1648);
                          _1700 = _1647;
                        } else {
                          _1695 = false;
                          _1696 = 0;
                          _1697 = 0;
                          _1698 = 0;
                          _1699 = 0;
                          _1700 = 0;
                        }
                        if (!_1695) {
                          if (!((((uint)(_1668 + _1648) > (uint)63)) || (((uint)((_1647 + 1) | (_1655 + _1649)) > (uint)127)))) {
                            uint _6239 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((_1647 + 1), (_1668 + _1648), ((int)(((uint)(_1655 + _1649)) + ((uint)(((int)(_1650 * 130)) | 1)))), 0));
                            int _6241 = _6239.x & 4194303;
                            _6244 = (_6241 != 0);
                            _6245 = _6241;
                            _6246 = _1650;
                            _6247 = (_1655 + _1649);
                            _6248 = (_1668 + _1648);
                            _6249 = (_1647 + 1);
                          } else {
                            _6244 = false;
                            _6245 = 0;
                            _6246 = 0;
                            _6247 = 0;
                            _6248 = 0;
                            _6249 = 0;
                          }
                          if (!_6244) {
                            _1709 = _1672;
                            _1710 = _1671;
                            _1711 = _1670;
                            _1712 = _1669;
                            _1713 = 0;
                          } else {
                            _1709 = _6249;
                            _1710 = _6248;
                            _1711 = _6247;
                            _1712 = _6246;
                            _1713 = _6245;
                          }
                        } else {
                          _1709 = _1700;
                          _1710 = _1699;
                          _1711 = _1698;
                          _1712 = _1697;
                          _1713 = _1696;
                        }
                        if ((((int)(_1668 + 1) < (int)2)) && ((_1713 == 0))) {
                          _1668 = (_1668 + 1);
                          _1669 = _1712;
                          _1670 = _1711;
                          _1671 = _1710;
                          _1672 = _1709;
                          continue;
                        }
                        if ((((int)(_1655 + 1) < (int)2)) && ((_1713 == 0))) {
                          _1655 = (_1655 + 1);
                          _1656 = _1712;
                          _1657 = _1711;
                          _1658 = _1710;
                          _1659 = _1709;
                          __loop_jump_target = 1654;
                          break;
                        }
                        _1662 = _1712;
                        _1663 = _1711;
                        _1664 = _1710;
                        _1665 = _1709;
                        break;
                      }
                      if (__loop_jump_target == 1654) {
                        __loop_jump_target = -1;
                        continue;
                      }
                      if (__loop_jump_target != -1) {
                        break;
                      }
                      break;
                    }
                  } else {
                    _1662 = _1578;
                    _1663 = _1577;
                    _1664 = _1576;
                    _1665 = _1575;
                  }
                  if ((uint)_1662 < (uint)6) {
                    uint _1719 = _1662 * 130;
                    uint _1723 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1665, _1664, ((int)(((uint)((int)(_1719) | 1)) + (uint)(_1663))), 0));
                    int _1725 = _1723.x & 4194303;
                    [branch]
                    if (!(_1725 == 0)) {
                      float _1731 = float((int)((int)(1u << (_1662 & 31)))) * _voxelParams.x;
                      _1769 = 0.0f;
                      _1770 = 0.0f;
                      _1771 = 0.0f;
                      _1772 = _978;
                      _1773 = _979;
                      _1774 = _980;
                      _1775 = 0.0f;
                      _1776 = 0;
                      while(true) {
                        int _1781 = __3__37__0__0__g_surfelDataBuffer[((_1725 + -1) + _1776)]._baseColor;
                        int _1783 = __3__37__0__0__g_surfelDataBuffer[((_1725 + -1) + _1776)]._normal;
                        int16_t _1786 = __3__37__0__0__g_surfelDataBuffer[((_1725 + -1) + _1776)]._radius;
                        if (!(_1781 == 0)) {
                          half _1789 = __3__37__0__0__g_surfelDataBuffer[((_1725 + -1) + _1776)]._radiance.z;
                          half _1790 = __3__37__0__0__g_surfelDataBuffer[((_1725 + -1) + _1776)]._radiance.y;
                          half _1791 = __3__37__0__0__g_surfelDataBuffer[((_1725 + -1) + _1776)]._radiance.x;
                          float _1797 = float((uint)((uint)(_1781 & 255)));
                          float _1798 = float((uint)((uint)(((uint)((uint)(_1781)) >> 8) & 255)));
                          float _1799 = float((uint)((uint)(((uint)((uint)(_1781)) >> 16) & 255)));
                          float _1824 = select(((_1797 * 0.003921568859368563f) < 0.040449999272823334f), (_1797 * 0.0003035269910469651f), exp2(log2((_1797 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                          float _1825 = select(((_1798 * 0.003921568859368563f) < 0.040449999272823334f), (_1798 * 0.0003035269910469651f), exp2(log2((_1798 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                          float _1826 = select(((_1799 * 0.003921568859368563f) < 0.040449999272823334f), (_1799 * 0.0003035269910469651f), exp2(log2((_1799 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                          float _1838 = (float((uint)((uint)(_1783 & 255))) * 0.007874015718698502f) + -1.0f;
                          float _1839 = (float((uint)((uint)(((uint)((uint)(_1783)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                          float _1840 = (float((uint)((uint)(((uint)((uint)(_1783)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                          float _1842 = rsqrt(dot(float3(_1838, _1839, _1840), float3(_1838, _1839, _1840)));
                          bool _1847 = ((_1783 & 16777215) == 0);
                          float _1851 = float(_1791);
                          float _1852 = float(_1790);
                          float _1853 = float(_1789);
                          float _1857 = (_1731 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_1786) & 255)));
                          float _1873 = (((float((uint)((uint)((uint)((uint)(_1781)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1731) + ((((((_clipmapOffsets[_1662]).x) + -63.5f) + float((int)(((int)(((uint)(_1665) + 64u) - (uint)(int((_clipmapOffsets[_1662]).x)))) & 127))) * _1731) - _viewPos.x);
                          float _1874 = (((float((uint)((uint)((uint)((uint)(_1783)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1731) + ((((((_clipmapOffsets[_1662]).y) + -31.5f) + float((int)(((int)(((uint)(_1664) + 32u) - (uint)(int((_clipmapOffsets[_1662]).y)))) & 63))) * _1731) - _viewPos.y);
                          float _1875 = (((float((uint16_t)((uint)((uint16_t)((uint)(_1786)) >> 8))) * 0.003937007859349251f) + -0.5f) * _1731) + ((((((_clipmapOffsets[_1662]).z) + -63.5f) + float((int)(((int)(((uint)(_1663) + 64u) - (uint)(int((_clipmapOffsets[_1662]).z)))) & 127))) * _1731) - _viewPos.z);
                          bool _1893 = (_935.w == 0.0f);
                          float _1894 = select(_1893, _1353, _1772);
                          float _1895 = select(_1893, _1354, _1773);
                          float _1896 = select(_1893, _1355, _1774);
                          float _1899 = ((-0.0f - _156) - _880) + _1873;
                          float _1902 = ((-0.0f - _157) - _881) + _1874;
                          float _1905 = ((-0.0f - _158) - _882) + _1875;
                          float _1906 = dot(float3(_1899, _1902, _1905), float3(_1894, _1895, _1896));
                          float _1910 = _1899 - (_1906 * _1894);
                          float _1911 = _1902 - (_1906 * _1895);
                          float _1912 = _1905 - (_1906 * _1896);
                          float _1938 = 1.0f / float((uint)(1u << (_1662 & 31)));
                          float _1942 = frac(((_invClipmapExtent.z * _1875) + _clipmapUVRelativeOffset.z) * _1938);
                          float _1953 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _1873) + _clipmapUVRelativeOffset.x) * _1938), (((_invClipmapExtent.y * _1874) + _clipmapUVRelativeOffset.y) * _1938), (((float((uint)_1719) + 1.0f) + ((select((_1942 < 0.0f), 1.0f, 0.0f) + _1942) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                          float _1967 = select(((int)_1662 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_1353, _1354, _1355), float3(select(_1847, _1353, (_1842 * _1838)), select(_1847, _1354, (_1842 * _1839)), select(_1847, _1355, (_1842 * _1840))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_1910, _1911, _1912), float3(_1910, _1911, _1912)) < ((_1857 * _1857) * 16.0f)))) * float((bool)(uint)(_1953.x > ((_1731 * 0.25f) * (saturate((dot(float3(_1851, _1852, _1853), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                          bool _1971 = ((!(_974 > 0.0f))) || (((_1781 & 16777215) == 16777215));
                          float _1981 = ((select(_1971, (((_1825 * 0.3395099937915802f) + (_1824 * 0.6131200194358826f)) + (_1826 * 0.047370001673698425f)), _1001) * _1851) * _1967) + _1769;
                          float _1982 = ((select(_1971, (((_1825 * 0.9163600206375122f) + (_1824 * 0.07020000368356705f)) + (_1826 * 0.013450000435113907f)), _1002) * _1852) * _1967) + _1770;
                          float _1983 = ((select(_1971, (((_1825 * 0.10958000272512436f) + (_1824 * 0.02061999961733818f)) + (_1826 * 0.8697999715805054f)), _1003) * _1853) * _1967) + _1771;
                          float _1984 = _1967 + _1775;
                          if ((uint)(_1776 + 1) < (uint)4) {
                            _1769 = _1981;
                            _1770 = _1982;
                            _1771 = _1983;
                            _1772 = _1894;
                            _1773 = _1895;
                            _1774 = _1896;
                            _1775 = _1984;
                            _1776 = (_1776 + 1);
                            continue;
                          } else {
                            _1988 = _1981;
                            _1989 = _1982;
                            _1990 = _1983;
                            _1991 = _1984;
                          }
                        } else {
                          _1988 = _1769;
                          _1989 = _1770;
                          _1990 = _1771;
                          _1991 = _1775;
                        }
                        if (_1991 > 0.0f) {
                          float _1994 = 1.0f / _1991;
                          _2008 = (-0.0f - min(0.0f, (-0.0f - (_1988 * _1994))));
                          _2009 = (-0.0f - min(0.0f, (-0.0f - (_1989 * _1994))));
                          _2010 = (-0.0f - min(0.0f, (-0.0f - (_1990 * _1994))));
                        } else {
                          _2008 = _1988;
                          _2009 = _1989;
                          _2010 = _1990;
                        }
                        break;
                      }
                    } else {
                      _2008 = 0.0f;
                      _2009 = 0.0f;
                      _2010 = 0.0f;
                    }
                  } else {
                    _2008 = 0.0f;
                    _2009 = 0.0f;
                    _2010 = 0.0f;
                  }
                } else {
                  _2008 = 0.0f;
                  _2009 = 0.0f;
                  _2010 = 0.0f;
                }
                break;
              }
            } else {
              _2008 = 0.0f;
              _2009 = 0.0f;
              _2010 = 0.0f;
            }
            float _2015 = saturate(((_878.x - (_1352 * 1.4140000343322754f)) * 2.0f) / _1352);
            float _2020 = min(0.05000000074505806f, (_878.x * 0.019999999552965164f));
            float _2024 = (_2020 * _978) + _883;
            float _2025 = (_2020 * _979) + _884;
            float _2026 = (_2020 * _980) + _885;
            float _2032 = _2024 + _viewPos.x;
            float _2033 = _2025 + _viewPos.y;
            float _2034 = _2026 + _viewPos.z;
            float _2039 = _2032 - (_staticShadowPosition[1].x);
            float _2040 = _2033 - (_staticShadowPosition[1].y);
            float _2041 = _2034 - (_staticShadowPosition[1].z);
            float _2061 = mad((_shadowProjRelativeTexScale[1][0].z), _2041, mad((_shadowProjRelativeTexScale[1][0].y), _2040, ((_shadowProjRelativeTexScale[1][0].x) * _2039))) + (_shadowProjRelativeTexScale[1][0].w);
            float _2065 = mad((_shadowProjRelativeTexScale[1][1].z), _2041, mad((_shadowProjRelativeTexScale[1][1].y), _2040, ((_shadowProjRelativeTexScale[1][1].x) * _2039))) + (_shadowProjRelativeTexScale[1][1].w);
            float _2072 = 2.0f / _shadowSizeAndInvSize.y;
            float _2073 = 1.0f - _2072;
            bool _2080 = ((((((!(_2061 <= _2073))) || ((!(_2061 >= _2072))))) || ((!(_2065 <= _2073))))) || ((!(_2065 >= _2072)));
            float _2089 = _2032 - (_staticShadowPosition[0].x);
            float _2090 = _2033 - (_staticShadowPosition[0].y);
            float _2091 = _2034 - (_staticShadowPosition[0].z);
            float _2111 = mad((_shadowProjRelativeTexScale[0][0].z), _2091, mad((_shadowProjRelativeTexScale[0][0].y), _2090, ((_shadowProjRelativeTexScale[0][0].x) * _2089))) + (_shadowProjRelativeTexScale[0][0].w);
            float _2115 = mad((_shadowProjRelativeTexScale[0][1].z), _2091, mad((_shadowProjRelativeTexScale[0][1].y), _2090, ((_shadowProjRelativeTexScale[0][1].x) * _2089))) + (_shadowProjRelativeTexScale[0][1].w);
            bool _2126 = ((((((!(_2111 <= _2073))) || ((!(_2111 >= _2072))))) || ((!(_2115 <= _2073))))) || ((!(_2115 >= _2072)));
            float _2127 = select(_2126, select(_2080, 0.0f, _2061), _2111);
            float _2128 = select(_2126, select(_2080, 0.0f, _2065), _2115);
            float _2129 = select(_2126, select(_2080, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _2041, mad((_shadowProjRelativeTexScale[1][2].y), _2040, ((_shadowProjRelativeTexScale[1][2].x) * _2039))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _2091, mad((_shadowProjRelativeTexScale[0][2].y), _2090, ((_shadowProjRelativeTexScale[0][2].x) * _2089))) + (_shadowProjRelativeTexScale[0][2].w)));
            int _2130 = select(_2126, select(_2080, -1, 1), 0);
            [branch]
            if (!(_2130 == -1)) {
              float _2136 = (_2127 * _shadowSizeAndInvSize.x) + -0.5f;
              float _2137 = (_2128 * _shadowSizeAndInvSize.y) + -0.5f;
              int _2140 = int(floor(_2136));
              int _2141 = int(floor(_2137));
              if (!((((uint)_2140 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_2141 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
                float4 _2151 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2140, _2141, _2130, 0));
                float4 _2153 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2140) + 1u)), _2141, _2130, 0));
                float4 _2155 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2140, ((int)((uint)(_2141) + 1u)), _2130, 0));
                float4 _2157 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2140) + 1u)), ((int)((uint)(_2141) + 1u)), _2130, 0));
                half4 _2162 = __3__36__0__0__g_shadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2127, _2128, float((uint)(uint)(_2130))), 0.0f);
                _2168 = _2151.x;
                _2169 = _2153.x;
                _2170 = _2155.x;
                _2171 = _2157.x;
                _2172 = _2162.x;
                _2173 = _2162.y;
                _2174 = _2162.z;
                _2175 = _2162.w;
              } else {
                _2168 = 0.0f;
                _2169 = 0.0f;
                _2170 = 0.0f;
                _2171 = 0.0f;
                _2172 = 1.0h;
                _2173 = 1.0h;
                _2174 = 1.0h;
                _2175 = 1.0h;
              }
              float _2201 = (float4(_invShadowViewProj[_2130][0][0], _invShadowViewProj[_2130][1][0], _invShadowViewProj[_2130][2][0], _invShadowViewProj[_2130][3][0]).x) * _2127;
              float _2205 = (float4(_invShadowViewProj[_2130][0][0], _invShadowViewProj[_2130][1][0], _invShadowViewProj[_2130][2][0], _invShadowViewProj[_2130][3][0]).y) * _2127;
              float _2209 = (float4(_invShadowViewProj[_2130][0][0], _invShadowViewProj[_2130][1][0], _invShadowViewProj[_2130][2][0], _invShadowViewProj[_2130][3][0]).z) * _2127;
              float _2213 = (float4(_invShadowViewProj[_2130][0][0], _invShadowViewProj[_2130][1][0], _invShadowViewProj[_2130][2][0], _invShadowViewProj[_2130][3][0]).w) * _2127;
              float _2216 = mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).w), _2168, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).w), _2128, _2213)) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).w);
              float _2217 = (mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).x), _2168, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).x), _2128, _2201)) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).x)) / _2216;
              float _2218 = (mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).y), _2168, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).y), _2128, _2205)) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).y)) / _2216;
              float _2219 = (mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).z), _2168, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).z), _2128, _2209)) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).z)) / _2216;
              float _2222 = _2127 + (_shadowSizeAndInvSize.z * 4.0f);
              float _2238 = mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).w), _2169, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).w), _2128, ((float4(_invShadowViewProj[_2130][0][0], _invShadowViewProj[_2130][1][0], _invShadowViewProj[_2130][2][0], _invShadowViewProj[_2130][3][0]).w) * _2222))) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).w);
              float _2244 = _2128 - (_shadowSizeAndInvSize.w * 2.0f);
              float _2256 = mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).w), _2170, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).w), _2244, _2213)) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).w);
              float _2260 = ((mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).x), _2170, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).x), _2244, _2201)) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).x)) / _2256) - _2217;
              float _2261 = ((mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).y), _2170, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).y), _2244, _2205)) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).y)) / _2256) - _2218;
              float _2262 = ((mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).z), _2170, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).z), _2244, _2209)) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).z)) / _2256) - _2219;
              float _2263 = ((mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).x), _2169, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).x), _2128, ((float4(_invShadowViewProj[_2130][0][0], _invShadowViewProj[_2130][1][0], _invShadowViewProj[_2130][2][0], _invShadowViewProj[_2130][3][0]).x) * _2222))) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).x)) / _2238) - _2217;
              float _2264 = ((mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).y), _2169, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).y), _2128, ((float4(_invShadowViewProj[_2130][0][0], _invShadowViewProj[_2130][1][0], _invShadowViewProj[_2130][2][0], _invShadowViewProj[_2130][3][0]).y) * _2222))) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).y)) / _2238) - _2218;
              float _2265 = ((mad((float4(_invShadowViewProj[_2130][0][2], _invShadowViewProj[_2130][1][2], _invShadowViewProj[_2130][2][2], _invShadowViewProj[_2130][3][2]).z), _2169, mad((float4(_invShadowViewProj[_2130][0][1], _invShadowViewProj[_2130][1][1], _invShadowViewProj[_2130][2][1], _invShadowViewProj[_2130][3][1]).z), _2128, ((float4(_invShadowViewProj[_2130][0][0], _invShadowViewProj[_2130][1][0], _invShadowViewProj[_2130][2][0], _invShadowViewProj[_2130][3][0]).z) * _2222))) + (float4(_invShadowViewProj[_2130][0][3], _invShadowViewProj[_2130][1][3], _invShadowViewProj[_2130][2][3], _invShadowViewProj[_2130][3][3]).z)) / _2238) - _2219;
              float _2268 = (_2262 * _2264) - (_2261 * _2265);
              float _2271 = (_2260 * _2265) - (_2262 * _2263);
              float _2274 = (_2261 * _2263) - (_2260 * _2264);
              float _2276 = rsqrt(dot(float3(_2268, _2271, _2274), float3(_2268, _2271, _2274)));
              float _2277 = _2268 * _2276;
              float _2278 = _2271 * _2276;
              float _2279 = _2274 * _2276;
              float _2280 = frac(_2136);
              float _2285 = (saturate(dot(float3(_811, _812, _813), float3(_2277, _2278, _2279))) * 0.0020000000949949026f) + _2129;
              float _2298 = saturate(exp2((_2168 - _2285) * 1442695.0f));
              float _2300 = saturate(exp2((_2170 - _2285) * 1442695.0f));
              float _2306 = ((saturate(exp2((_2169 - _2285) * 1442695.0f)) - _2298) * _2280) + _2298;
              _2313 = _2277;
              _2314 = _2278;
              _2315 = _2279;
              _2316 = saturate((((_2300 - _2306) + ((saturate(exp2((_2171 - _2285) * 1442695.0f)) - _2300) * _2280)) * frac(_2137)) + _2306);
              _2317 = _2168;
              _2318 = _2169;
              _2319 = _2170;
              _2320 = _2171;
              _2321 = _2172;
              _2322 = _2173;
              _2323 = _2174;
              _2324 = _2175;
            } else {
              _2313 = 0.0f;
              _2314 = 0.0f;
              _2315 = 0.0f;
              _2316 = 0.0f;
              _2317 = 0.0f;
              _2318 = 0.0f;
              _2319 = 0.0f;
              _2320 = 0.0f;
              _2321 = 0.0h;
              _2322 = 0.0h;
              _2323 = 0.0h;
              _2324 = 0.0h;
            }
            float _2344 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _2026, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _2025, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _2024))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
            float _2348 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _2026, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _2025, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _2024))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
            float _2352 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _2026, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _2025, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _2024))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
            float _2355 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
            float _2356 = 1.0f - _2355;
            if (!(((((!(_2344 <= _2356))) || ((!(_2344 >= _2355))))) || ((!(_2348 <= _2356))))) {
              bool _2367 = ((_2352 >= -1.0f)) && ((((_2352 <= 1.0f)) && ((_2348 >= _2355))));
              _2375 = select(_2367, 9.999999747378752e-06f, -9.999999747378752e-05f);
              _2376 = select(_2367, _2344, _2127);
              _2377 = select(_2367, _2348, _2128);
              _2378 = select(_2367, _2352, _2129);
              _2379 = select(_2367, 1, _2130);
              _2380 = ((int)(uint)((int)(_2367)));
            } else {
              _2375 = -9.999999747378752e-05f;
              _2376 = _2127;
              _2377 = _2128;
              _2378 = _2129;
              _2379 = _2130;
              _2380 = 0;
            }
            float _2400 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _2026, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _2025, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _2024))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
            float _2404 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _2026, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _2025, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _2024))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
            float _2408 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _2026, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _2025, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _2024))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
            if (!(((((!(_2400 <= _2356))) || ((!(_2400 >= _2355))))) || ((!(_2404 <= _2356))))) {
              bool _2419 = ((_2408 >= -1.0f)) && ((((_2404 >= _2355)) && ((_2408 <= 1.0f))));
              _2427 = select(_2419, 9.999999747378752e-06f, _2375);
              _2428 = select(_2419, _2400, _2376);
              _2429 = select(_2419, _2404, _2377);
              _2430 = select(_2419, _2408, _2378);
              _2431 = select(_2419, 0, _2379);
              _2432 = select(_2419, 1, _2380);
            } else {
              _2427 = _2375;
              _2428 = _2376;
              _2429 = _2377;
              _2430 = _2378;
              _2431 = _2379;
              _2432 = _2380;
            }
            [branch]
            if (!(_2432 == 0)) {
              int _2442 = int(floor((_2428 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
              int _2443 = int(floor((_2429 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
              if (!((((uint)_2442 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_2443 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
                float4 _2453 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2442, _2443, _2431, 0));
                float4 _2455 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2442) + 1u)), _2443, _2431, 0));
                float4 _2457 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2442, ((int)((uint)(_2443) + 1u)), _2431, 0));
                float4 _2459 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2442) + 1u)), ((int)((uint)(_2443) + 1u)), _2431, 0));
                _2462 = _2453.x;
                _2463 = _2455.x;
                _2464 = _2457.x;
                _2465 = _2459.x;
              } else {
                _2462 = _2317;
                _2463 = _2318;
                _2464 = _2319;
                _2465 = _2320;
              }
              float _2491 = (float4(_invDynamicShadowViewProj[_2431][0][0], _invDynamicShadowViewProj[_2431][1][0], _invDynamicShadowViewProj[_2431][2][0], _invDynamicShadowViewProj[_2431][3][0]).x) * _2428;
              float _2495 = (float4(_invDynamicShadowViewProj[_2431][0][0], _invDynamicShadowViewProj[_2431][1][0], _invDynamicShadowViewProj[_2431][2][0], _invDynamicShadowViewProj[_2431][3][0]).y) * _2428;
              float _2499 = (float4(_invDynamicShadowViewProj[_2431][0][0], _invDynamicShadowViewProj[_2431][1][0], _invDynamicShadowViewProj[_2431][2][0], _invDynamicShadowViewProj[_2431][3][0]).z) * _2428;
              float _2503 = (float4(_invDynamicShadowViewProj[_2431][0][0], _invDynamicShadowViewProj[_2431][1][0], _invDynamicShadowViewProj[_2431][2][0], _invDynamicShadowViewProj[_2431][3][0]).w) * _2428;
              float _2506 = mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).w), _2462, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).w), _2429, _2503)) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).w);
              float _2507 = (mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).x), _2462, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).x), _2429, _2491)) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).x)) / _2506;
              float _2508 = (mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).y), _2462, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).y), _2429, _2495)) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).y)) / _2506;
              float _2509 = (mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).z), _2462, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).z), _2429, _2499)) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).z)) / _2506;
              float _2512 = _2428 + (_dynmaicShadowSizeAndInvSize.z * 8.0f);
              float _2528 = mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).w), _2463, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).w), _2429, ((float4(_invDynamicShadowViewProj[_2431][0][0], _invDynamicShadowViewProj[_2431][1][0], _invDynamicShadowViewProj[_2431][2][0], _invDynamicShadowViewProj[_2431][3][0]).w) * _2512))) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).w);
              float _2534 = _2429 - (_dynmaicShadowSizeAndInvSize.w * 4.0f);
              float _2546 = mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).w), _2464, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).w), _2534, _2503)) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).w);
              float _2550 = ((mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).x), _2464, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).x), _2534, _2491)) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).x)) / _2546) - _2507;
              float _2551 = ((mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).y), _2464, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).y), _2534, _2495)) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).y)) / _2546) - _2508;
              float _2552 = ((mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).z), _2464, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).z), _2534, _2499)) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).z)) / _2546) - _2509;
              float _2553 = ((mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).x), _2463, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).x), _2429, ((float4(_invDynamicShadowViewProj[_2431][0][0], _invDynamicShadowViewProj[_2431][1][0], _invDynamicShadowViewProj[_2431][2][0], _invDynamicShadowViewProj[_2431][3][0]).x) * _2512))) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).x)) / _2528) - _2507;
              float _2554 = ((mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).y), _2463, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).y), _2429, ((float4(_invDynamicShadowViewProj[_2431][0][0], _invDynamicShadowViewProj[_2431][1][0], _invDynamicShadowViewProj[_2431][2][0], _invDynamicShadowViewProj[_2431][3][0]).y) * _2512))) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).y)) / _2528) - _2508;
              float _2555 = ((mad((float4(_invDynamicShadowViewProj[_2431][0][2], _invDynamicShadowViewProj[_2431][1][2], _invDynamicShadowViewProj[_2431][2][2], _invDynamicShadowViewProj[_2431][3][2]).z), _2463, mad((float4(_invDynamicShadowViewProj[_2431][0][1], _invDynamicShadowViewProj[_2431][1][1], _invDynamicShadowViewProj[_2431][2][1], _invDynamicShadowViewProj[_2431][3][1]).z), _2429, ((float4(_invDynamicShadowViewProj[_2431][0][0], _invDynamicShadowViewProj[_2431][1][0], _invDynamicShadowViewProj[_2431][2][0], _invDynamicShadowViewProj[_2431][3][0]).z) * _2512))) + (float4(_invDynamicShadowViewProj[_2431][0][3], _invDynamicShadowViewProj[_2431][1][3], _invDynamicShadowViewProj[_2431][2][3], _invDynamicShadowViewProj[_2431][3][3]).z)) / _2528) - _2509;
              float _2558 = (_2552 * _2554) - (_2551 * _2555);
              float _2561 = (_2550 * _2555) - (_2552 * _2553);
              float _2564 = (_2551 * _2553) - (_2550 * _2554);
              float _2566 = rsqrt(dot(float3(_2558, _2561, _2564), float3(_2558, _2561, _2564)));
              if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
                _2584 = _sunDirection.x;
                _2585 = _sunDirection.y;
                _2586 = _sunDirection.z;
              } else {
                _2584 = _moonDirection.x;
                _2585 = _moonDirection.y;
                _2586 = _moonDirection.z;
              }
              float _2592 = (_2427 - (saturate(-0.0f - dot(float3(_2584, _2585, _2586), float3(_811, _812, _813))) * 9.999999747378752e-05f)) + _2430;
              _2605 = (_2558 * _2566);
              _2606 = (_2561 * _2566);
              _2607 = (_2564 * _2566);
              _2608 = min(float((bool)(uint)(_2462 > _2592)), min(min(float((bool)(uint)(_2463 > _2592)), float((bool)(uint)(_2464 > _2592))), float((bool)(uint)(_2465 > _2592))));
            } else {
              _2605 = _2313;
              _2606 = _2314;
              _2607 = _2315;
              _2608 = _2316;
            }
            float _2616 = (_viewPos.x - _shadowRelativePosition.x) + _2024;
            float _2617 = (_viewPos.y - _shadowRelativePosition.y) + _2025;
            float _2618 = (_viewPos.z - _shadowRelativePosition.z) + _2026;
            float _2638 = mad((_terrainShadowProjRelativeTexScale[0].z), _2618, mad((_terrainShadowProjRelativeTexScale[0].y), _2617, (_2616 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
            float _2642 = mad((_terrainShadowProjRelativeTexScale[1].z), _2618, mad((_terrainShadowProjRelativeTexScale[1].y), _2617, (_2616 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
            float _2646 = mad((_terrainShadowProjRelativeTexScale[2].z), _2618, mad((_terrainShadowProjRelativeTexScale[2].y), _2617, (_2616 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
            if (saturate(_2638) == _2638) {
              if (((_2646 >= 9.999999747378752e-05f)) && ((((_2646 <= 1.0f)) && ((saturate(_2642) == _2642))))) {
                float _2661 = frac((_2638 * 1024.0f) + -0.5f);
                float4 _2665 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_2638, _2642));
                float _2670 = _2646 + -0.004999999888241291f;
                float _2675 = select((_2665.w > _2670), 1.0f, 0.0f);
                float _2677 = select((_2665.x > _2670), 1.0f, 0.0f);
                float _2684 = ((select((_2665.z > _2670), 1.0f, 0.0f) - _2675) * _2661) + _2675;
                _2690 = saturate((((((select((_2665.y > _2670), 1.0f, 0.0f) - _2677) * _2661) + _2677) - _2684) * frac((_2642 * 1024.0f) + -0.5f)) + _2684);
              } else {
                _2690 = 1.0f;
              }
            } else {
              _2690 = 1.0f;
            }
            float _2691 = min(_2608, _2690);
            half _2692 = saturate(_2321);
            half _2693 = saturate(_2322);
            half _2694 = saturate(_2323);
            bool _2713 = (_sunDirection.y > 0.0f);
            if ((_2713) || ((!(_2713)) && (_sunDirection.y > _moonDirection.y))) {
              _2725 = _sunDirection.x;
              _2726 = _sunDirection.y;
              _2727 = _sunDirection.z;
            } else {
              _2725 = _moonDirection.x;
              _2726 = _moonDirection.y;
              _2727 = _moonDirection.z;
            }
            if ((_2713) || ((!(_2713)) && (_sunDirection.y > _moonDirection.y))) {
              _2747 = _precomputedAmbient7.y;
            } else {
              _2747 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
            }
            float _2750 = _2033 + _earthRadius;
            float _2754 = (_2026 * _2026) + (_2024 * _2024);
            float _2756 = sqrt((_2750 * _2750) + _2754);
            float _2761 = dot(float3((_2024 / _2756), (_2750 / _2756), (_2026 / _2756)), float3(_2725, _2726, _2727));
            float _2766 = min(max(((_2756 - _earthRadius) / _atmosphereThickness), 16.0f), (_atmosphereThickness + -16.0f));
            float _2774 = max(_2766, 0.0f);
            float _2781 = (-0.0f - sqrt((_2774 + (_earthRadius * 2.0f)) * _2774)) / (_2774 + _earthRadius);
            if (_2761 > _2781) {
              _2804 = ((exp2(log2(saturate((_2761 - _2781) / (1.0f - _2781))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _2804 = ((exp2(log2(saturate((_2781 - _2761) / (_2781 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float2 _2809 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_2766 + -16.0f) / (_atmosphereThickness + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _2804), 0.0f);
            float _2831 = ((_2809.y * 1.9999999494757503e-05f) * _mieAerosolDensity) * (_mieAerosolAbsorption + 1.0f);
            float _2849 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f)) * _2809.x) + _2831) * -1.4426950216293335f);
            float _2850 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f)) * _2809.x) + _2831) * -1.4426950216293335f);
            float _2851 = exp2(((((_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f)) * _2809.x) + _2831) * -1.4426950216293335f);
            float _2867 = sqrt(_2754);
            float _2875 = (_cloudAltitude - (max(((_2867 * _2867) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
            float _2887 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_2726 > 0.0f))) - ((int)(uint)((int)(_2726 < 0.0f))))) * 0.5f))) + _2875;
            if (_2025 < _2875) {
              float _2890 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2725, _2726, _2727));
              float _2896 = select((abs(_2890) < 9.99999993922529e-09f), 1e+08f, ((_2887 - dot(float3(0.0f, 1.0f, 0.0f), float3(_2024, _2025, _2026))) / _2890));
              _2902 = ((_2896 * _2725) + _2024);
              _2903 = _2887;
              _2904 = ((_2896 * _2727) + _2026);
            } else {
              _2902 = _2024;
              _2903 = _2025;
              _2904 = _2026;
            }
            float _2913 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_2902 * 4.999999873689376e-05f) + 0.5f), ((_2903 - _2875) / _cloudThickness), ((_2904 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
            float _2924 = saturate(abs(_2726) * 4.0f);
            float _2926 = (_2924 * _2924) * exp2(((_distanceScale * -1.4426950216293335f) * _2913.x) * (_cloudScatteringCoefficient / _distanceScale));
            float _2933 = ((1.0f - _2926) * saturate(((_2025 - _cloudThickness) - _2875) * 0.10000000149011612f)) + _2926;
            float _2934 = _2933 * (((_2850 * 0.3395099937915802f) + (_2849 * 0.6131200194358826f)) + (_2851 * 0.047370001673698425f));
            float _2935 = _2933 * (((_2850 * 0.9163600206375122f) + (_2849 * 0.07020000368356705f)) + (_2851 * 0.013450000435113907f));
            float _2936 = _2933 * (((_2850 * 0.10958000272512436f) + (_2849 * 0.02061999961733818f)) + (_2851 * 0.8697999715805054f));
            if (_974 > 0.0f) {
              bool _2955 = (_935.w > 0.0f);
              float _2956 = select(_2955, _978, _2605);
              float _2957 = select(_2955, _979, _2606);
              float _2958 = select(_2955, _980, _2607);
              half _2960 = half(_1001);
              half _2961 = half(_1002);
              half _2962 = half(_1003);
              _2968 = select(_2955, _935.w, 0.800000011920929f);
              _2969 = _2956;
              _2970 = _2957;
              _2971 = _2958;
              _2972 = _2960;
              _2973 = _2961;
              _2974 = _2962;
              _2975 = _974;
              _2976 = float(_2960);
              _2977 = float(_2961);
              _2978 = float(_2962);
              _2979 = dot(float3(_2956, _2957, _2958), float3(_2725, _2726, _2727));
            } else {
              _2968 = 0.800000011920929f;
              _2969 = _2605;
              _2970 = _2606;
              _2971 = _2607;
              _2972 = (((_2693 * 0.3395996h) + (_2692 * 0.61328125h)) + (_2694 * 0.04736328h));
              _2973 = (((_2693 * 0.9165039h) + (_2692 * 0.07019043h)) + (_2694 * 0.013450623h));
              _2974 = (((_2693 * 0.109558105h) + (_2692 * 0.020614624h)) + (_2694 * 0.8696289h));
              _2975 = 0.10000000149011612f;
              _2976 = 1.0f;
              _2977 = 1.0f;
              _2978 = 1.0f;
              _2979 = float(saturate(_2324));
            }
            float _2987 = float(half(saturate(_2979) * 0.31830987334251404f)) * _2691;
            float _2995 = 0.699999988079071f / min(max(max(max(_2976, _2977), _2978), 0.009999999776482582f), 0.699999988079071f);
            float _3006 = (((_2995 * _2977) + -0.03999999910593033f) * _2975) + 0.03999999910593033f;
            float _3008 = _2725 - _811;
            float _3009 = _2726 - _812;
            float _3010 = _2727 - _813;
            float _3012 = rsqrt(dot(float3(_3008, _3009, _3010), float3(_3008, _3009, _3010)));
            float _3013 = _3012 * _3008;
            float _3014 = _3012 * _3009;
            float _3015 = _3012 * _3010;
            float _3020 = saturate(max(9.999999747378752e-06f, dot(float3(_1353, _1354, _1355), float3(_2969, _2970, _2971))));
            float _3022 = saturate(dot(float3(_2969, _2970, _2971), float3(_3013, _3014, _3015)));
            float _3025 = saturate(1.0f - saturate(saturate(dot(float3(_1353, _1354, _1355), float3(_3013, _3014, _3015)))));
            float _3026 = _3025 * _3025;
            float _3028 = (_3026 * _3026) * _3025;
            float _3031 = _3028 * saturate(_3006 * 50.0f);
            float _3032 = 1.0f - _3028;
            float _3040 = saturate(_2979 * _2691);
            float _3041 = _2968 * _2968;
            float _3042 = _3041 * _3041;
            float _3043 = 1.0f - _3041;
            float _3055 = (((_3022 * _3042) - _3022) * _3022) + 1.0f;
            float _3059 = (_3042 / ((_3055 * _3055) * 3.1415927410125732f)) * (0.5f / ((((_3020 * _3043) + _3041) * _2979) + (_3020 * ((_2979 * _3043) + _3041))));
            float _3074 = _renderParams2.z * _2747;
            float _3076 = (_3074 * (((_2934 * 0.6131200194358826f) + (_2935 * 0.3395099937915802f)) + (_2936 * 0.047370001673698425f))) * ((max((((_3032 * ((((_2995 * _2976) + -0.03999999910593033f) * _2975) + 0.03999999910593033f)) + _3031) * _3059), 0.0f) * _3040) + (_2987 * float(_2972)));
            float _3078 = (_3074 * (((_2934 * 0.07020000368356705f) + (_2935 * 0.9163600206375122f)) + (_2936 * 0.013450000435113907f))) * ((max((((_3032 * _3006) + _3031) * _3059), 0.0f) * _3040) + (_2987 * float(_2973)));
            float _3080 = (_3074 * (((_2934 * 0.02061999961733818f) + (_2935 * 0.10958000272512436f)) + (_2936 * 0.8697999715805054f))) * ((max((((_3032 * ((((_2995 * _2978) + -0.03999999910593033f) * _2975) + 0.03999999910593033f)) + _3031) * _3059), 0.0f) * _3040) + (_2987 * float(_2974)));
            float _3081 = dot(float3(_3076, _3078, _3080), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
            float _3082 = min(_851, _3081);
            float _3086 = max(9.999999717180685e-10f, _3081);
            float _3090 = ((_3082 * _3076) / _3086) + (_2015 * _2008);
            float _3091 = ((_3078 * _3082) / _3086) + (_2015 * _2009);
            float _3092 = ((_3080 * _3082) / _3086) + (_2015 * _2010);
            if (_997 == 1.0f) {
              [branch]
              if (((_1003 < 0.009999999776482582f)) && ((((_1001 < 0.009999999776482582f)) && ((_1002 < 0.009999999776482582f))))) {
                float _3105 = dot(float3(_811, _812, _813), float3(_978, _979, _980)) * 2.0f;
                float _3109 = _811 - (_3105 * _978);
                float _3110 = _812 - (_3105 * _979);
                float _3111 = _813 - (_3105 * _980);
                float _3113 = rsqrt(dot(float3(_3109, _3110, _3111), float3(_3109, _3110, _3111)));
                _3118 = 1;
                while(true) {
                  int _3158 = int(floor(((_wrappedViewPos.x + _1364) * ((_clipmapOffsets[_3118]).w)) + ((_clipmapRelativeIndexOffsets[_3118]).x)));
                  int _3159 = int(floor(((_wrappedViewPos.y + _1365) * ((_clipmapOffsets[_3118]).w)) + ((_clipmapRelativeIndexOffsets[_3118]).y)));
                  int _3160 = int(floor(((_wrappedViewPos.z + _1366) * ((_clipmapOffsets[_3118]).w)) + ((_clipmapRelativeIndexOffsets[_3118]).z)));
                  if (!((((((((int)_3158 >= (int)int(((_clipmapOffsets[_3118]).x) + -63.0f))) && (((int)_3158 < (int)int(((_clipmapOffsets[_3118]).x) + 63.0f))))) && (((((int)_3159 >= (int)int(((_clipmapOffsets[_3118]).y) + -31.0f))) && (((int)_3159 < (int)int(((_clipmapOffsets[_3118]).y) + 31.0f))))))) && (((((int)_3160 >= (int)int(((_clipmapOffsets[_3118]).z) + -63.0f))) && (((int)_3160 < (int)int(((_clipmapOffsets[_3118]).z) + 63.0f))))))) {
                    if ((uint)(_3118 + 1) < (uint)8) {
                      _3118 = (_3118 + 1);
                      continue;
                    } else {
                      _3176 = -10000;
                    }
                  } else {
                    _3176 = _3118;
                  }
                  if (!((uint)_3176 > (uint)3)) {
                    float _3196 = 1.0f / float((uint)(1u << (_3176 & 31)));
                    float _3200 = frac(((_invClipmapExtent.z * _1366) + _clipmapUVRelativeOffset.z) * _3196);
                    float _3212 = __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _1364) + _clipmapUVRelativeOffset.x) * _3196), (((_invClipmapExtent.y * _1365) + _clipmapUVRelativeOffset.y) * _3196), (((float((uint)(_3176 * 66)) + 1.0f) + ((select((_3200 < 0.0f), 1.0f, 0.0f) + _3200) * 64.0f)) * 0.0037878789007663727f)), 0.0f);
                    _3217 = saturate(1.0f - _3212.x);
                  } else {
                    _3217 = 1.0f;
                  }
                  float _3219 = saturate(_3217 * 4.0f);
                  float4 _3222 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3((_3109 * _3113), (_3110 * _3113), (_3111 * _3113)), ((log2(_998) * 2.0f) + 9.0f));
                  float _3226 = _3222.x * _3219;
                  float _3227 = _3222.y * _3219;
                  float _3228 = _3222.z * _3219;
                  float _3231 = _998 * _998;
                  float _3232 = abs(saturate(dot(float3(_1353, _1354, _1355), float3(_978, _979, _980))));
                  float _3233 = _3232 * _3232;
                  float _3234 = _3233 * _3232;
                  float _3236 = (_3231 * _3231) * _3231;
                  float _3263 = mad(0.03999999910593033f, max(0.0f, ((1.0f / dot(float3(mad(-1.3677200078964233f, _3234, mad(3.5968499183654785f, _3233, 1.0f)), mad(9.229490280151367f, _3234, mad(-16.317399978637695f, _3233, 9.044010162353516f)), mad(-20.212299346923828f, _3234, mad(19.78860092163086f, _3233, 5.565889835357666f))), float3(1.0f, _3231, _3236))) * dot(float2(mad(3.3270699977874756f, _3232, 0.03654630109667778f), mad(-9.04755973815918f, _3232, 9.063199996948242f)), float2(1.0f, _3231)))), max(0.0f, ((1.0f / dot(float3(mad(59.418800354003906f, _3234, mad(2.923379898071289f, _3232, 1.0f)), mad(222.5919952392578f, _3234, mad(-27.03019905090332f, _3232, 20.322500228881836f)), mad(316.62701416015625f, _3234, mad(626.1300048828125f, _3232, 121.56300354003906f))), float3(1.0f, _3231, _3236))) * dot(float2(mad(-1.285140037536621f, _3232, 0.9904400110244751f), mad(-0.7559069991111755f, _3232, 1.296779990196228f)), float2(1.0f, _3231)))));
                  float _3264 = dot(float3(_3226, _3227, _3228), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
                  float _3265 = min(_851, _3264);
                  float _3269 = max(9.999999717180685e-10f, _3264);
                  _3280 = 0.0f;
                  _3281 = 0.0f;
                  _3282 = 0.0f;
                  _3283 = 0.0f;
                  _3284 = _878.x;
                  _3285 = 0;
                  _3286 = 1;
                  _3287 = ((((_3265 * _3226) / _3269) * _3263) + _3090);
                  _3288 = ((((_3265 * _3227) / _3269) * _3263) + _3091);
                  _3289 = ((((_3265 * _3228) / _3269) * _3263) + _3092);
                  _3290 = 1.0f;
                  _3291 = _1364;
                  _3292 = _1365;
                  _3293 = _1366;
                  _3294 = _878.x;
                  break;
                }
              } else {
                _3280 = 0.0f;
                _3281 = 0.0f;
                _3282 = 0.0f;
                _3283 = 0.0f;
                _3284 = _878.x;
                _3285 = 0;
                _3286 = 1;
                _3287 = _3090;
                _3288 = _3091;
                _3289 = _3092;
                _3290 = 1.0f;
                _3291 = _1364;
                _3292 = _1365;
                _3293 = _1366;
                _3294 = _878.x;
              }
            } else {
              _3280 = 0.0f;
              _3281 = 0.0f;
              _3282 = 0.0f;
              _3283 = 0.0f;
              _3284 = _878.x;
              _3285 = 0;
              _3286 = 1;
              _3287 = _3090;
              _3288 = _3091;
              _3289 = _3092;
              _3290 = 1.0f;
              _3291 = _1364;
              _3292 = _1365;
              _3293 = _1366;
              _3294 = _878.x;
            }
            break;
          }
          break;
        }
        break;
      }
    } else {
      _3280 = 0.0f;
      _3281 = 0.0f;
      _3282 = 0.0f;
      _3283 = 0.0f;
      _3284 = _878.x;
      _3285 = 0;
      _3286 = 0;
      _3287 = 0.0f;
      _3288 = 0.0f;
      _3289 = 0.0f;
      _3290 = 0.0f;
      _3291 = 0.0f;
      _3292 = 0.0f;
      _3293 = 0.0f;
      _3294 = 0.0f;
    }
  }
  if (_983) {
    float _3299 = _1001 * _999;
    float _3300 = _1002 * _999;
    float _3301 = _1003 * _999;
    float _3302 = dot(float3(_3299, _3300, _3301), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _3303 = min((_exposure3.w * 512.0f), _3302);
    float _3307 = max(9.999999717180685e-10f, _3302);
    _3315 = (((_3303 * _3299) / _3307) + _3287);
    _3316 = (((_3303 * _3300) / _3307) + _3288);
    _3317 = (((_3303 * _3301) / _3307) + _3289);
  } else {
    _3315 = _3287;
    _3316 = _3288;
    _3317 = _3289;
  }
  bool _3321 = (_3286 == 0);
  if ((_3321) && ((_renderParams.w > 0.0f))) {
    float4 _3326 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(_811, _812, _813), 0.0f);
    float _3330 = dot(float3(_3326.x, _3326.y, _3326.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _3331 = min(_851, _3330);
    float _3335 = max(9.999999717180685e-10f, _3330);
    float _3339 = ((_3331 * _3326.x) / _3335) * _renderParams.w;
    float _3340 = ((_3331 * _3326.y) / _3335) * _renderParams.w;
    float _3341 = ((_3331 * _3326.z) / _3335) * _renderParams.w;
    float _3342 = _renderParams.w * 1e+06f;
    if (_3283 < 1.0f) {
      _3358 = (lerp(_3339, _3280, _3283));
      _3359 = (lerp(_3340, _3281, _3283));
      _3360 = (lerp(_3341, _3282, _3283));
      _3361 = (lerp(_3342, _3283, _3283));
    } else {
      _3358 = _3280;
      _3359 = _3281;
      _3360 = _3282;
      _3361 = _3283;
    }
  } else {
    _3358 = _3280;
    _3359 = _3281;
    _3360 = _3282;
    _3361 = _3283;
  }
  if (_536) {
    int _3371 = ((int)(((((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) + (uint)(-1879881855)));
    _3377 = ((int)(((uint)(_3371 ^ (((uint)(((uint)((((int)((_526 << 4) + (uint)(-1383041155))) ^ ((int)(_526 + (uint)(-239350328)))) ^ ((int)(((uint)((uint)(_526) >> 5)) + 2123724318u)))) + (((uint)((((int)((((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) << 4) + (uint)(-1383041155))) ^ ((int)(((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) + 1401181199u))) ^ ((int)(((uint)((uint)((uint)(_509) + (((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478)) >> 5)) + 2123724318u)))) + (((uint)((((int)(((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) << 4) + (uint)(-1383041155))) ^ ((int)((((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) + (uint)(-1253254570)))) ^ ((int)(((uint)((uint)(((uint)((((int)(((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) << 4) + (uint)(-1556008596))) ^ ((int)((((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) + (uint)(-1253254570)))) ^ (((uint)(((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470) >> 5) + -939442524))) + _478) >> 5)) + 2123724318u)))) + (((uint)((((int)((_478 << 4) + (uint)(-1383041155))) ^ ((int)(_478 + 387276957u))) ^ ((int)(((uint)((uint)(_478) >> 5)) + 2123724318u)))) + _470)))) >> 5) + -939442524))) + _526));
  } else {
    _3377 = (int)(_526);
  }
  float _3380 = float((uint)((uint)(((int)(_3377 * 48271)) & 16777215)));
  bool _3381 = (_cavityParams.y == 0.0f);
  if (!_3381) {
    if (!(_cavityParams.y <= 1.0f)) {
      bool _3405 = (_119 > ((_3380 * 4.76837158203125e-07f) + 32.0f));
      if (!(!(_cavityParams.y <= 2.0f))) {
        if (_3405) {
          _3429 = (_338 != 29);
        } else {
          if (!(_sunDirection.y > 0.0f)) {
            if (!(_sunDirection.y > _moonDirection.y)) {
              if ((((_297 > 0.20000000298023224f)) || ((_298 < 0.10000000149011612f))) | (_119 > ((_3380 * 2.384185791015625e-07f) + 16.0f))) {
                _3429 = (_338 != 29);
              } else {
                _3429 = false;
              }
            } else {
              _3429 = false;
            }
          } else {
            _3429 = false;
          }
        }
      } else {
        if (_3405) {
          _3429 = (_338 != 29);
        } else {
          _3429 = false;
        }
      }
    } else {
      if (!(_297 > 0.20000000298023224f)) {
        if (!(_119 > ((_3380 * 2.384185791015625e-07f) + 16.0f))) {
          if (!(_sunDirection.y > 0.0f)) {
            _3399 = (_sunDirection.y > _moonDirection.y);
          } else {
            _3399 = true;
          }
          _3429 = (!_3399);
        } else {
          _3429 = true;
        }
      } else {
        _3429 = true;
      }
    }
  } else {
    _3429 = true;
  }
  if (((((_338 != 29)) || ((((_921 < 0.20000000298023224f)) || ((((((_922 < -1.0f)) || ((_922 > 1.0f)))) || ((((_923 < -1.0f)) || ((_923 > 1.0f)))))))))) && (_3321)) {
    _3437 = (((_119 < (_voxelParams.x * 11585.1259765625f))) || (_3429));
  } else {
    _3437 = false;
  }
  if (((_renderParams.y > 0.0f)) && ((((_3285 == 0)) && (_3437)))) {
    if (!_3381) {
      _3451 = (int)(uint((saturate(1.0f - _344) * 64.0f) + 128.0f));
    } else {
      _3451 = 64;
    }
    if (!(((_92 != 29)) || (_3381))) {
      _3460 = min(3072.0f, ((_119 * 8.0f) + 256.0f));
    } else {
      _3460 = select(_3381, 64.0f, 256.0f);
    }
    if (!_3321) {
      _3464 = min(_3460, _3294);
    } else {
      _3464 = _3460;
    }
    float _3466 = min(max(_401, 0.009999999776482582f), 0.03999999910593033f);
    if (!_3429) {
      float _3470 = _lightingParams.z * 1.3434898853302002f;
      float _3471 = -0.0f - _3470;
      if (((((_158 > _3471)) && ((_158 < _3470)))) && ((((((_156 > _3471)) && ((_156 < _3470)))) && ((((_157 > _3471)) && ((_157 < _3470))))))) {
        float _3484 = 1.0f / _811;
        float _3485 = 1.0f / _812;
        float _3486 = 1.0f / _813;
        float _3490 = _3484 * (_3471 - _156);
        float _3491 = _3485 * (_3471 - _157);
        float _3492 = _3486 * (_3471 - _158);
        float _3496 = _3484 * (_3470 - _156);
        float _3497 = _3485 * (_3470 - _157);
        float _3498 = _3486 * (_3470 - _158);
        float _3508 = min(min(max(_3490, _3496), max(_3491, _3497)), max(_3492, _3498));
        if (((_3508 > 0.0f)) && ((((_3508 >= 0.0f)) && ((max(max(min(_3490, _3496), min(_3491, _3497)), min(_3492, _3498)) <= _3508))))) {
          _3522 = ((_3508 * _811) + _156);
          _3523 = ((_3508 * _812) + _157);
          _3524 = ((_3508 * _813) + _158);
          _3525 = _3508;
        } else {
          _3522 = _156;
          _3523 = _157;
          _3524 = _158;
          _3525 = 0.0f;
        }
      } else {
        _3522 = _156;
        _3523 = _157;
        _3524 = _158;
        _3525 = 0.0f;
      }
    } else {
      _3522 = _156;
      _3523 = _157;
      _3524 = _158;
      _3525 = 0.0f;
    }
    if (_338 == 29) {
      _3532 = (min(10.0f, (_119 * 0.10000000149011612f)) + 10.0f);
    } else {
      _3532 = 1.0f;
    }
    _3536 = 0;
    while(true) {
      int _3576 = int(floor(((_wrappedViewPos.x + _3522) * ((_clipmapOffsets[_3536]).w)) + ((_clipmapRelativeIndexOffsets[_3536]).x)));
      int _3577 = int(floor(((_wrappedViewPos.y + _3523) * ((_clipmapOffsets[_3536]).w)) + ((_clipmapRelativeIndexOffsets[_3536]).y)));
      int _3578 = int(floor(((_wrappedViewPos.z + _3524) * ((_clipmapOffsets[_3536]).w)) + ((_clipmapRelativeIndexOffsets[_3536]).z)));
      if (!((((((((int)_3576 >= (int)int(((_clipmapOffsets[_3536]).x) + -63.0f))) && (((int)_3576 < (int)int(((_clipmapOffsets[_3536]).x) + 63.0f))))) && (((((int)_3577 >= (int)int(((_clipmapOffsets[_3536]).y) + -31.0f))) && (((int)_3577 < (int)int(((_clipmapOffsets[_3536]).y) + 31.0f))))))) && (((((int)_3578 >= (int)int(((_clipmapOffsets[_3536]).z) + -63.0f))) && (((int)_3578 < (int)int(((_clipmapOffsets[_3536]).z) + 63.0f))))))) {
        if ((uint)(_3536 + 1) < (uint)8) {
          _3536 = (_3536 + 1);
          continue;
        } else {
          _3594 = -10000;
        }
      } else {
        _3594 = _3536;
      }
      if (!(_3594 == -10000)) {
        uint _3597 = min((uint)(32768), (uint)(_3451));
        bool _3602 = (_811 == 0.0f);
        bool _3603 = (_812 == 0.0f);
        bool _3604 = (_813 == 0.0f);
        float _3605 = select(_3602, 0.0f, (1.0f / _811));
        float _3606 = select(_3603, 0.0f, (1.0f / _812));
        float _3607 = select(_3604, 0.0f, (1.0f / _813));
        bool _3608 = (_811 > 0.0f);
        bool _3609 = (_812 > 0.0f);
        bool _3610 = (_813 > 0.0f);
        float _3617 = saturate(dot(float3(_280, _281, _282), float3(_811, _812, _813))) * 0.4375f;
        if (((_3464 > 0.0f)) && (((int)(_3597) != 0))) {
          _3624 = 0;
          _3625 = 1.0f;
          _3626 = 0.0f;
          _3627 = 0.0f;
          _3628 = _3524;
          _3629 = _3523;
          _3630 = _3522;
          while(true) {
            _3632 = 0;
            while(true) {
              float _3657 = ((_wrappedViewPos.x + _3630) * ((_clipmapOffsets[_3632]).w)) + ((_clipmapRelativeIndexOffsets[_3632]).x);
              float _3658 = ((_wrappedViewPos.y + _3629) * ((_clipmapOffsets[_3632]).w)) + ((_clipmapRelativeIndexOffsets[_3632]).y);
              float _3659 = ((_wrappedViewPos.z + _3628) * ((_clipmapOffsets[_3632]).w)) + ((_clipmapRelativeIndexOffsets[_3632]).z);
              bool __defer_3631_3674 = false;
              if (!(((_3659 >= (((_clipmapOffsets[_3632]).z) + -63.0f))) && ((((_3657 >= (((_clipmapOffsets[_3632]).x) + -63.0f))) && ((_3658 >= (((_clipmapOffsets[_3632]).y) + -31.0f)))))) || ((((_3659 >= (((_clipmapOffsets[_3632]).z) + -63.0f))) && ((((_3657 >= (((_clipmapOffsets[_3632]).x) + -63.0f))) && ((_3658 >= (((_clipmapOffsets[_3632]).y) + -31.0f)))))) && (!(((_3659 < (((_clipmapOffsets[_3632]).z) + 63.0f))) && ((((_3657 < (((_clipmapOffsets[_3632]).x) + 63.0f))) && ((_3658 < (((_clipmapOffsets[_3632]).y) + 31.0f))))))))) {
                __defer_3631_3674 = true;
              } else {
                if (_3632 == -10000) {
                  _3915 = _3627;
                  _3917 = _3915;
                  _3918 = -10000.0f;
                  _3919 = 0.0f;
                  _3920 = 0.0f;
                  _3921 = 0.0f;
                } else {
                  float _3682 = float((int)((int)(1u << (_3632 & 31))));
                  float _3683 = 1.0f / _3682;
                  float _3684 = _3682 * _voxelParams.x;
                  float _3696 = (_invClipmapExtent.x * _3630) + _clipmapUVRelativeOffset.x;
                  float _3697 = (_invClipmapExtent.y * _3629) + _clipmapUVRelativeOffset.y;
                  float _3698 = (_invClipmapExtent.z * _3628) + _clipmapUVRelativeOffset.z;
                  float _3700 = _3696 * _3683;
                  float _3701 = _3697 * _3683;
                  float _3702 = _3698 * _3683;
                  float _3703 = _3700 * 64.0f;
                  float _3704 = _3701 * 32.0f;
                  float _3705 = _3702 * 64.0f;
                  int _3709 = int(floor(_3703));
                  int _3710 = int(floor(_3704));
                  int _3711 = int(floor(_3705));
                  uint4 _3718 = __3__36__0__0__g_axisAlignedDistanceTextures.Load(int4((_3709 & 63), (_3710 & 31), ((_3711 & 63) | (_3632 << 6)), 0));
                  float _3758 = _3703 - float((int)(_3709));
                  float _3759 = _3704 - float((int)(_3710));
                  float _3760 = _3705 - float((int)(_3711));
                  float _3791 = max(((_3684 * 0.5f) * min(min(select(_3602, 999999.0f, ((select(_3608, 1.0f, 0.0f) - frac(_3700 * 256.0f)) * _3605)), select(_3603, 999999.0f, ((select(_3609, 1.0f, 0.0f) - frac(_3701 * 128.0f)) * _3606))), select(_3604, 999999.0f, ((select(_3610, 1.0f, 0.0f) - frac(_3702 * 256.0f)) * _3607)))), ((_3684 * 2.0f) * min(min(select(_3602, 999999.0f, (select(_3608, ((0.009999999776482582f - _3758) + float((uint)((uint)(((uint)((uint)(_3718.x)) >> 4) & 15)))), ((0.9900000095367432f - _3758) - float((uint)((uint)(_3718.x & 15))))) * _3605)), select(_3603, 999999.0f, (select(_3609, ((0.009999999776482582f - _3759) + float((uint)((uint)(((uint)((uint)(_3718.y)) >> 4) & 15)))), ((0.9900000095367432f - _3759) - float((uint)((uint)(_3718.y & 15))))) * _3606))), select(_3604, 999999.0f, (select(_3610, ((0.009999999776482582f - _3760) + float((uint)((uint)(((uint)((uint)(_3718.z)) >> 4) & 15)))), ((0.9900000095367432f - _3760) - float((uint)((uint)(_3718.z & 15))))) * _3607)))));
                  float _3796 = _3627 * 0.125f;
                  float _3801 = frac(_3702);
                  float _3808 = float((uint)(_3632 * 130)) + 1.0f;
                  float _3810 = (((select((_3801 < 0.0f), 1.0f, 0.0f) + _3801) * 128.0f) + _3808) * 0.000961538462433964f;
                  float _3813 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_3700, _3701, _3810), 0.0f);
                  if (_3796 < _3684) {
                    float _3819 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(((_3696 + 0.009999999776482582f) * _3683), _3701, _3810), 0.0f);
                    float _3821 = _3819.x - _3813.x;
                    float _3824 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_3700, ((_3697 + 0.009999999776482582f) * _3683), _3810), 0.0f);
                    float _3826 = _3824.x - _3813.x;
                    float _3829 = frac((_3698 + 0.009999999776482582f) * _3683);
                    float _3836 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_3700, _3701, ((((select((_3829 < 0.0f), 1.0f, 0.0f) + _3829) * 128.0f) + _3808) * 0.000961538462433964f)), 0.0f);
                    float _3838 = _3836.x - _3813.x;
                    float _3840 = rsqrt(dot(float3(_3821, _3826, _3838), float3(_3821, _3826, _3838)));
                    _3848 = (1.0f - saturate(dot(float3(_280, _281, _282), float3((_3840 * _3821), (_3840 * _3826), (_3838 * _3840)))));
                  } else {
                    _3848 = 0.0f;
                  }
                  float _3853 = _3813.x - ((_3684 * 0.707099974155426f) * saturate(_3627 * 0.10000000149011612f));
                  float _3855 = (_3466 * 2.0f) * _3627;
                  float _3858 = ((_3848 * 0.875f) + 0.125f) / _3684;
                  float _3875 = (_3853 + min(4.0f, ((_119 * _119) * 9.999999747378752e-05f))) / min(8.0f, (((max(((_3684 * 2.1213200092315674f) * ((_3617 + 0.0625f) + (saturate(_3796) * (0.4375f - _3617)))), _3855) - _3855) * saturate(((max(1.0f, (_3858 * 0.75f)) * _3858) * min(_3627, max(0.0f, (_3464 - _3627)))) + -1.0f)) + _3855));
                  float _3881 = saturate(((float((bool)(uint)(saturate(float((uint)((uint)((uint)((uint)(_3718.w)) >> 2))) * 0.01587301678955555f) > 0.0f)) * (1.0f - _3626)) * saturate(1.0f - (_3875 * _3875))) + _3626);
                  if (!(_3853 > _3684)) {
                    _3886 = min(_3791, _3853);
                  } else {
                    _3886 = _3791;
                  }
                  if (!(_3881 >= 0.5f)) {
                    float _3894 = _3625 * (((_3466 * 0.20000000298023224f) * _3532) + 1.0f);
                    float _3899 = max((_3684 * 0.10000000149011612f), (max((_voxelParams.x * 0.25f), _3886) * _3894));
                    float _3900 = _3899 + _3627;
                    if ((((((uint)((int)((uint)(_3624) + 1u)) < (uint)(int)(_3597))) && ((_3881 < 0.5f)))) && ((_3900 < _3464))) {
                      _3624 = ((int)((uint)(_3624) + 1u));
                      _3625 = _3894;
                      _3626 = _3881;
                      _3627 = _3900;
                      _3628 = ((_3899 * _813) + _3628);
                      _3629 = ((_3899 * _812) + _3629);
                      _3630 = ((_3899 * _811) + _3630);
                      __loop_jump_target = 3623;
                      break;
                    } else {
                      _3915 = _3900;
                      _3917 = _3915;
                      _3918 = -10000.0f;
                      _3919 = 0.0f;
                      _3920 = 0.0f;
                      _3921 = 0.0f;
                    }
                  } else {
                    _3917 = _3627;
                    _3918 = float((int)(_3632));
                    _3919 = _3696;
                    _3920 = _3697;
                    _3921 = _3698;
                  }
                }
              }
              if (__defer_3631_3674) {
                if ((int)(_3632 + 1) < (int)8) {
                  _3632 = (_3632 + 1);
                  continue;
                } else {
                  _3917 = _3627;
                  _3918 = -10000.0f;
                  _3919 = 0.0f;
                  _3920 = 0.0f;
                  _3921 = 0.0f;
                }
              }
              break;
            }
            if (__loop_jump_target == 3623) {
              __loop_jump_target = -1;
              continue;
            }
            if (__loop_jump_target != -1) {
              break;
            }
            break;
          }
        } else {
          _3917 = 0.0f;
          _3918 = -10000.0f;
          _3919 = 0.0f;
          _3920 = 0.0f;
          _3921 = 0.0f;
        }
        int _3922 = int(_3918);
        if ((uint)_3922 < (uint)8) {
          float _3925 = -0.0f - _811;
          float _3926 = -0.0f - _812;
          float _3927 = -0.0f - _813;
          float _3930 = float((int)((int)(1u << (_3922 & 31))));
          float _3931 = _3930 * _voxelParams.x;
          if (_3917 < (_3931 * 2.0f)) {
            float _3935 = 1.0f / _3930;
            float _3936 = _3935 * _3919;
            float _3937 = _3935 * _3920;
            float _3939 = frac(_3935 * _3921);
            float _3946 = float((uint)(_3922 * 130)) + 1.0f;
            float _3948 = (((select((_3939 < 0.0f), 1.0f, 0.0f) + _3939) * 128.0f) + _3946) * 0.000961538462433964f;
            float _3951 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_3936, _3937, _3948), 0.0f);
            float _3955 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((_3935 * (_3919 + 9.999999747378752e-05f)), _3937, _3948), 0.0f);
            float _3957 = _3955.x - _3951.x;
            float _3960 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_3936, (_3935 * (_3920 + 9.999999747378752e-05f)), _3948), 0.0f);
            float _3962 = _3960.x - _3951.x;
            float _3965 = frac(_3935 * (_3921 + 9.999999747378752e-05f));
            float _3972 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_3936, _3937, ((((select((_3965 < 0.0f), 1.0f, 0.0f) + _3965) * 128.0f) + _3946) * 0.000961538462433964f)), 0.0f);
            float _3974 = _3972.x - _3951.x;
            float _3976 = rsqrt(dot(float3(_3957, _3962, _3974), float3(_3957, _3962, _3974)));
            _3981 = (_3976 * _3957);
            _3982 = (_3976 * _3962);
            _3983 = (_3974 * _3976);
          } else {
            _3981 = _3925;
            _3982 = _3926;
            _3983 = _3927;
          }
          if ((int)_3922 < (int)6) {
            float _3986 = _3931 * 0.5f;
            float _3990 = saturate((_3986 * _3986) / (_3917 * _3917));
            float _3991 = _872 * 6.2831854820251465f;
            if (_3990 < 0.009999999776482582f) {
              _4002 = (((_3990 * 0.125f) + 0.5f) * _3990);
            } else {
              _4002 = (1.0f - sqrt(1.0f - _3990));
            }
            float _4004 = 1.0f - (_4002 * _876);
            float _4007 = sqrt(1.0f - (_4004 * _4004));
            float _4010 = cos(_3991) * _4007;
            float _4011 = sin(_3991) * _4007;
            float _4013 = select((_813 >= 0.0f), 1.0f, -1.0f);
            float _4016 = -0.0f - (1.0f / (_4013 + _813));
            float _4018 = (_811 * _812) * _4016;
            float _4045 = min(_3917, (_3931 * 0.25f));
            float _4049 = ((mad(_4004, _811, mad(_4011, _4018, (((((_811 * _811) * _4013) * _4016) + 1.0f) * _4010))) * _3917) + _3522) + (_4045 * _3981);
            float _4050 = ((mad(_4004, _812, mad(_4011, (((_812 * _812) * _4016) + _4013), ((_4010 * _4013) * _4018))) * _3917) + _3523) + (_4045 * _3982);
            float _4051 = ((mad(_4004, _813, mad(_4011, _3926, (-0.0f - ((_4013 * _811) * _4010)))) * _3917) + _3524) + (_4045 * _3983);
            _4056 = 0;
            while(true) {
              int _4096 = int(floor(((_wrappedViewPos.x + _4049) * ((_clipmapOffsets[_4056]).w)) + ((_clipmapRelativeIndexOffsets[_4056]).x)));
              int _4097 = int(floor(((_wrappedViewPos.y + _4050) * ((_clipmapOffsets[_4056]).w)) + ((_clipmapRelativeIndexOffsets[_4056]).y)));
              int _4098 = int(floor(((_wrappedViewPos.z + _4051) * ((_clipmapOffsets[_4056]).w)) + ((_clipmapRelativeIndexOffsets[_4056]).z)));
              if ((((((((int)_4096 >= (int)int(((_clipmapOffsets[_4056]).x) + -63.0f))) && (((int)_4096 < (int)int(((_clipmapOffsets[_4056]).x) + 63.0f))))) && (((((int)_4097 >= (int)int(((_clipmapOffsets[_4056]).y) + -31.0f))) && (((int)_4097 < (int)int(((_clipmapOffsets[_4056]).y) + 31.0f))))))) && (((((int)_4098 >= (int)int(((_clipmapOffsets[_4056]).z) + -63.0f))) && (((int)_4098 < (int)int(((_clipmapOffsets[_4056]).z) + 63.0f)))))) {
                _4119 = (_4096 & 127);
                _4120 = (_4097 & 63);
                _4121 = (_4098 & 127);
                _4122 = _4056;
              } else {
                if ((uint)(_4056 + 1) < (uint)8) {
                  _4056 = (_4056 + 1);
                  continue;
                } else {
                  _4119 = -10000;
                  _4120 = -10000;
                  _4121 = -10000;
                  _4122 = -10000;
                }
              }
              if (!((uint)_4122 > (uint)5)) {
                uint _4132 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4119, _4120, ((int)(((uint)(((int)(_4122 * 130)) | 1)) + (uint)(_4121))), 0));
                bool _4135 = ((_4132.x & 4194303) == 0);
                [branch]
                if (!_4135) {
                  _4138 = _4119;
                  _4139 = _4120;
                  _4140 = _4121;
                  _4141 = _4122;
                } else {
                  _4138 = -10000;
                  _4139 = -10000;
                  _4140 = -10000;
                  _4141 = -10000;
                }
                float _4143 = (_voxelParams.x * 0.5f) * float((int)((int)(1u << (_4122 & 31))));
                _4148 = 0;
                while(true) {
                  int _4188 = int(floor((((_4049 - _4143) + _wrappedViewPos.x) * ((_clipmapOffsets[_4148]).w)) + ((_clipmapRelativeIndexOffsets[_4148]).x)));
                  int _4189 = int(floor((((_4050 - _4143) + _wrappedViewPos.y) * ((_clipmapOffsets[_4148]).w)) + ((_clipmapRelativeIndexOffsets[_4148]).y)));
                  int _4190 = int(floor((((_4051 - _4143) + _wrappedViewPos.z) * ((_clipmapOffsets[_4148]).w)) + ((_clipmapRelativeIndexOffsets[_4148]).z)));
                  if ((((((((int)_4188 >= (int)int(((_clipmapOffsets[_4148]).x) + -63.0f))) && (((int)_4188 < (int)int(((_clipmapOffsets[_4148]).x) + 63.0f))))) && (((((int)_4189 >= (int)int(((_clipmapOffsets[_4148]).y) + -31.0f))) && (((int)_4189 < (int)int(((_clipmapOffsets[_4148]).y) + 31.0f))))))) && (((((int)_4190 >= (int)int(((_clipmapOffsets[_4148]).z) + -63.0f))) && (((int)_4190 < (int)int(((_clipmapOffsets[_4148]).z) + 63.0f)))))) {
                    _4211 = (_4188 & 127);
                    _4212 = (_4189 & 63);
                    _4213 = (_4190 & 127);
                    _4214 = _4148;
                  } else {
                    if ((uint)(_4148 + 1) < (uint)8) {
                      _4148 = (_4148 + 1);
                      continue;
                    } else {
                      _4211 = -10000;
                      _4212 = -10000;
                      _4213 = -10000;
                      _4214 = -10000;
                    }
                  }
                  if (!((uint)_4214 > (uint)5)) {
                    if (_4135) {
                      _4219 = 0;
                      _4220 = _4141;
                      _4221 = _4140;
                      _4222 = _4139;
                      _4223 = _4138;
                      while(true) {
                        _4232 = 0;
                        _4233 = _4220;
                        _4234 = _4221;
                        _4235 = _4222;
                        _4236 = _4223;
                        while(true) {
                          if (!((((uint)(_4232 + _4212) > (uint)63)) || (((uint)(_4211 | (_4219 + _4213)) > (uint)127)))) {
                            uint _4254 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4211, (_4232 + _4212), ((int)(((uint)(_4219 + _4213)) + ((uint)(((int)(_4214 * 130)) | 1)))), 0));
                            int _4256 = _4254.x & 4194303;
                            _4259 = (_4256 != 0);
                            _4260 = _4256;
                            _4261 = _4214;
                            _4262 = (_4219 + _4213);
                            _4263 = (_4232 + _4212);
                            _4264 = _4211;
                          } else {
                            _4259 = false;
                            _4260 = 0;
                            _4261 = 0;
                            _4262 = 0;
                            _4263 = 0;
                            _4264 = 0;
                          }
                          if (!_4259) {
                            if (!((((uint)(_4232 + _4212) > (uint)63)) || (((uint)((_4211 + 1) | (_4219 + _4213)) > (uint)127)))) {
                              uint _6225 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((_4211 + 1), (_4232 + _4212), ((int)(((uint)(_4219 + _4213)) + ((uint)(((int)(_4214 * 130)) | 1)))), 0));
                              int _6227 = _6225.x & 4194303;
                              _6230 = (_6227 != 0);
                              _6231 = _6227;
                              _6232 = _4214;
                              _6233 = (_4219 + _4213);
                              _6234 = (_4232 + _4212);
                              _6235 = (_4211 + 1);
                            } else {
                              _6230 = false;
                              _6231 = 0;
                              _6232 = 0;
                              _6233 = 0;
                              _6234 = 0;
                              _6235 = 0;
                            }
                            if (!_6230) {
                              _4273 = _4236;
                              _4274 = _4235;
                              _4275 = _4234;
                              _4276 = _4233;
                              _4277 = 0;
                            } else {
                              _4273 = _6235;
                              _4274 = _6234;
                              _4275 = _6233;
                              _4276 = _6232;
                              _4277 = _6231;
                            }
                          } else {
                            _4273 = _4264;
                            _4274 = _4263;
                            _4275 = _4262;
                            _4276 = _4261;
                            _4277 = _4260;
                          }
                          if ((((int)(_4232 + 1) < (int)2)) && ((_4277 == 0))) {
                            _4232 = (_4232 + 1);
                            _4233 = _4276;
                            _4234 = _4275;
                            _4235 = _4274;
                            _4236 = _4273;
                            continue;
                          }
                          if ((((int)(_4219 + 1) < (int)2)) && ((_4277 == 0))) {
                            _4219 = (_4219 + 1);
                            _4220 = _4276;
                            _4221 = _4275;
                            _4222 = _4274;
                            _4223 = _4273;
                            __loop_jump_target = 4218;
                            break;
                          }
                          _4226 = _4276;
                          _4227 = _4275;
                          _4228 = _4274;
                          _4229 = _4273;
                          break;
                        }
                        if (__loop_jump_target == 4218) {
                          __loop_jump_target = -1;
                          continue;
                        }
                        if (__loop_jump_target != -1) {
                          break;
                        }
                        break;
                      }
                    } else {
                      _4226 = _4141;
                      _4227 = _4140;
                      _4228 = _4139;
                      _4229 = _4138;
                    }
                    if ((uint)_4226 < (uint)6) {
                      uint _4283 = _4226 * 130;
                      uint _4287 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4229, _4228, ((int)(((uint)((int)(_4283) | 1)) + (uint)(_4227))), 0));
                      int _4289 = _4287.x & 4194303;
                      [branch]
                      if (!(_4289 == 0)) {
                        float _4295 = float((int)((int)(1u << (_4226 & 31)))) * _voxelParams.x;
                        _4333 = 0.0f;
                        _4334 = 0.0f;
                        _4335 = 0.0f;
                        _4336 = 0.0f;
                        _4337 = 0;
                        while(true) {
                          int _4342 = __3__37__0__0__g_surfelDataBuffer[((_4289 + -1) + _4337)]._baseColor;
                          int _4344 = __3__37__0__0__g_surfelDataBuffer[((_4289 + -1) + _4337)]._normal;
                          int16_t _4347 = __3__37__0__0__g_surfelDataBuffer[((_4289 + -1) + _4337)]._radius;
                          if (!(_4342 == 0)) {
                            half _4350 = __3__37__0__0__g_surfelDataBuffer[((_4289 + -1) + _4337)]._radiance.z;
                            half _4351 = __3__37__0__0__g_surfelDataBuffer[((_4289 + -1) + _4337)]._radiance.y;
                            half _4352 = __3__37__0__0__g_surfelDataBuffer[((_4289 + -1) + _4337)]._radiance.x;
                            float _4358 = float((uint)((uint)(_4342 & 255)));
                            float _4359 = float((uint)((uint)(((uint)((uint)(_4342)) >> 8) & 255)));
                            float _4360 = float((uint)((uint)(((uint)((uint)(_4342)) >> 16) & 255)));
                            float _4385 = select(((_4358 * 0.003921568859368563f) < 0.040449999272823334f), (_4358 * 0.0003035269910469651f), exp2(log2((_4358 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                            float _4386 = select(((_4359 * 0.003921568859368563f) < 0.040449999272823334f), (_4359 * 0.0003035269910469651f), exp2(log2((_4359 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                            float _4387 = select(((_4360 * 0.003921568859368563f) < 0.040449999272823334f), (_4360 * 0.0003035269910469651f), exp2(log2((_4360 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                            float _4399 = (float((uint)((uint)(_4344 & 255))) * 0.007874015718698502f) + -1.0f;
                            float _4400 = (float((uint)((uint)(((uint)((uint)(_4344)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                            float _4401 = (float((uint)((uint)(((uint)((uint)(_4344)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                            float _4403 = rsqrt(dot(float3(_4399, _4400, _4401), float3(_4399, _4400, _4401)));
                            bool _4408 = ((_4344 & 16777215) == 0);
                            float _4412 = float(_4352);
                            float _4413 = float(_4351);
                            float _4414 = float(_4350);
                            float _4418 = (_4295 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_4347) & 255)));
                            float _4434 = (((float((uint)((uint)((uint)((uint)(_4342)) >> 24))) * 0.003937007859349251f) + -0.5f) * _4295) + ((((((_clipmapOffsets[_4226]).x) + -63.5f) + float((int)(((int)(((uint)(_4229) + 64u) - (uint)(int((_clipmapOffsets[_4226]).x)))) & 127))) * _4295) - _viewPos.x);
                            float _4435 = (((float((uint)((uint)((uint)((uint)(_4344)) >> 24))) * 0.003937007859349251f) + -0.5f) * _4295) + ((((((_clipmapOffsets[_4226]).y) + -31.5f) + float((int)(((int)(((uint)(_4228) + 32u) - (uint)(int((_clipmapOffsets[_4226]).y)))) & 63))) * _4295) - _viewPos.y);
                            float _4436 = (((float((uint16_t)((uint)((uint16_t)((uint)(_4347)) >> 8))) * 0.003937007859349251f) + -0.5f) * _4295) + ((((((_clipmapOffsets[_4226]).z) + -63.5f) + float((int)(((int)(((uint)(_4227) + 64u) - (uint)(int((_clipmapOffsets[_4226]).z)))) & 127))) * _4295) - _viewPos.z);
                            float _4456 = ((-0.0f - _3522) - (_3917 * _811)) + _4434;
                            float _4459 = ((-0.0f - _3523) - (_3917 * _812)) + _4435;
                            float _4462 = ((-0.0f - _3524) - (_3917 * _813)) + _4436;
                            float _4463 = dot(float3(_4456, _4459, _4462), float3(_3925, _3926, _3927));
                            float _4467 = _4456 - (_4463 * _3925);
                            float _4468 = _4459 - (_4463 * _3926);
                            float _4469 = _4462 - (_4463 * _3927);
                            float _4495 = 1.0f / float((uint)(1u << (_4226 & 31)));
                            float _4499 = frac(((_invClipmapExtent.z * _4436) + _clipmapUVRelativeOffset.z) * _4495);
                            float _4510 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _4434) + _clipmapUVRelativeOffset.x) * _4495), (((_invClipmapExtent.y * _4435) + _clipmapUVRelativeOffset.y) * _4495), (((float((uint)_4283) + 1.0f) + ((select((_4499 < 0.0f), 1.0f, 0.0f) + _4499) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                            float _4524 = select(((int)_4226 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_3925, _3926, _3927), float3(select(_4408, _3925, (_4403 * _4399)), select(_4408, _3926, (_4403 * _4400)), select(_4408, _3927, (_4403 * _4401))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_4467, _4468, _4469), float3(_4467, _4468, _4469)) < ((_4418 * _4418) * 16.0f)))) * float((bool)(uint)(_4510.x > ((_4295 * 0.25f) * (saturate((dot(float3(_4412, _4413, _4414), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                            float _4531 = (((((_4386 * 0.3395099937915802f) + (_4385 * 0.6131200194358826f)) + (_4387 * 0.047370001673698425f)) * _4412) * _4524) + _4333;
                            float _4532 = (((((_4386 * 0.9163600206375122f) + (_4385 * 0.07020000368356705f)) + (_4387 * 0.013450000435113907f)) * _4413) * _4524) + _4334;
                            float _4533 = (((((_4386 * 0.10958000272512436f) + (_4385 * 0.02061999961733818f)) + (_4387 * 0.8697999715805054f)) * _4414) * _4524) + _4335;
                            float _4534 = _4524 + _4336;
                            if ((uint)(_4337 + 1) < (uint)4) {
                              _4333 = _4531;
                              _4334 = _4532;
                              _4335 = _4533;
                              _4336 = _4534;
                              _4337 = (_4337 + 1);
                              continue;
                            } else {
                              _4538 = _4531;
                              _4539 = _4532;
                              _4540 = _4533;
                              _4541 = _4534;
                            }
                          } else {
                            _4538 = _4333;
                            _4539 = _4334;
                            _4540 = _4335;
                            _4541 = _4336;
                          }
                          if (_4541 > 0.0f) {
                            float _4544 = 1.0f / _4541;
                            _4558 = (-0.0f - min(0.0f, (-0.0f - (_4538 * _4544))));
                            _4559 = (-0.0f - min(0.0f, (-0.0f - (_4539 * _4544))));
                            _4560 = (-0.0f - min(0.0f, (-0.0f - (_4540 * _4544))));
                          } else {
                            _4558 = _4538;
                            _4559 = _4539;
                            _4560 = _4540;
                          }
                          break;
                        }
                      } else {
                        _4558 = 0.0f;
                        _4559 = 0.0f;
                        _4560 = 0.0f;
                      }
                    } else {
                      _4558 = 0.0f;
                      _4559 = 0.0f;
                      _4560 = 0.0f;
                    }
                  } else {
                    _4558 = 0.0f;
                    _4559 = 0.0f;
                    _4560 = 0.0f;
                  }
                  break;
                }
              } else {
                _4558 = 0.0f;
                _4559 = 0.0f;
                _4560 = 0.0f;
              }
              break;
            }
          } else {
            _4558 = 0.0f;
            _4559 = 0.0f;
            _4560 = 0.0f;
          }
          _4568 = min(30000.0f, _4558);
          _4569 = min(30000.0f, _4559);
          _4570 = min(30000.0f, _4560);
          _4571 = 1.0f;
          _4572 = max(9.999999747378752e-05f, _3917);
        } else {
          _4568 = 0.0f;
          _4569 = 0.0f;
          _4570 = 0.0f;
          _4571 = 0.0f;
          _4572 = (-0.0f - _3917);
        }
      } else {
        _4568 = 0.0f;
        _4569 = 0.0f;
        _4570 = 0.0f;
        _4571 = 0.0f;
        _4572 = 0.0f;
      }
      float _4576 = (_4572 * _811) + _3522;
      float _4577 = (_4572 * _812) + _3523;
      float _4578 = (_4572 * _813) + _3524;
      if (_4572 > 0.0f) {
        float _4581 = _4572 + _3525;
        float _4582 = _4568 * _renderParams.y;
        float _4583 = _4569 * _renderParams.y;
        float _4584 = _4570 * _renderParams.y;
        float _4587 = select((_4581 <= 0.0f), 9.999999974752427e-07f, _4581);
        float _4597 = __3__36__0__0__g_waterDepthTop.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_waterDepthFieldSize.z * _4576) + 0.5f), (0.5f - (_waterDepthFieldSize.w * _4578))), 0.0f);
        float _4611 = saturate((((_4577 - _waterDepthMinMax.z) + _waterDepthMinMax.x) + ((_waterDepthMinMax.y - _waterDepthMinMax.x) * _4597.x)) * 0.125f);
        if (_4611 > 0.0f) {
          float _4616 = _renderParams2.z * _4611;
          _4618 = 0;
          while(true) {
            int _4658 = int(floor(((_wrappedViewPos.x + _4576) * ((_clipmapOffsets[_4618]).w)) + ((_clipmapRelativeIndexOffsets[_4618]).x)));
            int _4659 = int(floor(((_wrappedViewPos.y + _4577) * ((_clipmapOffsets[_4618]).w)) + ((_clipmapRelativeIndexOffsets[_4618]).y)));
            int _4660 = int(floor(((_wrappedViewPos.z + _4578) * ((_clipmapOffsets[_4618]).w)) + ((_clipmapRelativeIndexOffsets[_4618]).z)));
            if (!((((((((int)_4658 >= (int)int(((_clipmapOffsets[_4618]).x) + -63.0f))) && (((int)_4658 < (int)int(((_clipmapOffsets[_4618]).x) + 63.0f))))) && (((((int)_4659 >= (int)int(((_clipmapOffsets[_4618]).y) + -31.0f))) && (((int)_4659 < (int)int(((_clipmapOffsets[_4618]).y) + 31.0f))))))) && (((((int)_4660 >= (int)int(((_clipmapOffsets[_4618]).z) + -63.0f))) && (((int)_4660 < (int)int(((_clipmapOffsets[_4618]).z) + 63.0f))))))) {
              if ((uint)(_4618 + 1) < (uint)8) {
                _4618 = (_4618 + 1);
                continue;
              } else {
                _4676 = -10000;
              }
            } else {
              _4676 = _4618;
            }
            float _4680 = float((int)((int)(1u << (_4676 & 31)))) * _voxelParams.x;
            float _4681 = _4680 * 0.5f;
            float _4685 = saturate((_4681 * _4681) / (_4587 * _4587));
            float _4686 = _872 * 6.2831854820251465f;
            if (_4685 < 0.009999999776482582f) {
              _4697 = (((_4685 * 0.125f) + 0.5f) * _4685);
            } else {
              _4697 = (1.0f - sqrt(1.0f - _4685));
            }
            float _4699 = 1.0f - (_4697 * _876);
            float _4702 = sqrt(1.0f - (_4699 * _4699));
            float _4705 = cos(_4686) * _4702;
            float _4706 = sin(_4686) * _4702;
            float _4708 = select((_813 >= 0.0f), 1.0f, -1.0f);
            float _4711 = -0.0f - (1.0f / (_4708 + _813));
            float _4713 = (_811 * _812) * _4711;
            float _4722 = -0.0f - _812;
            float _4734 = _4680 + _4587;
            bool _4743 = (_sunDirection.y > 0.0f);
            if ((_4743) || ((!(_4743)) && (_sunDirection.y > _moonDirection.y))) {
              _4755 = _sunDirection.x;
              _4756 = _sunDirection.y;
              _4757 = _sunDirection.z;
            } else {
              _4755 = _moonDirection.x;
              _4756 = _moonDirection.y;
              _4757 = _moonDirection.z;
            }
            float _4761 = (_4755 * 0.25f) - _811;
            float _4762 = (_4756 * 0.25f) - _812;
            float _4763 = (_4757 * 0.25f) - _813;
            float _4765 = rsqrt(dot(float3(_4761, _4762, _4763), float3(_4761, _4762, _4763)));
            _4770 = 0;
            while(true) {
              int _4810 = int(floor(((((mad(_4699, _811, mad(_4706, _4713, (((((_811 * _811) * _4708) * _4711) + 1.0f) * _4705))) * _4734) + _156) + _wrappedViewPos.x) * ((_clipmapOffsets[_4770]).w)) + ((_clipmapRelativeIndexOffsets[_4770]).x)));
              int _4811 = int(floor(((((mad(_4699, _812, mad(_4706, (((_812 * _812) * _4711) + _4708), ((_4705 * _4708) * _4713))) * _4734) + _157) + _wrappedViewPos.y) * ((_clipmapOffsets[_4770]).w)) + ((_clipmapRelativeIndexOffsets[_4770]).y)));
              int _4812 = int(floor(((((mad(_4699, _813, mad(_4706, _4722, (-0.0f - ((_4708 * _811) * _4705)))) * _4734) + _158) + _wrappedViewPos.z) * ((_clipmapOffsets[_4770]).w)) + ((_clipmapRelativeIndexOffsets[_4770]).z)));
              if ((((((((int)_4810 >= (int)int(((_clipmapOffsets[_4770]).x) + -63.0f))) && (((int)_4810 < (int)int(((_clipmapOffsets[_4770]).x) + 63.0f))))) && (((((int)_4811 >= (int)int(((_clipmapOffsets[_4770]).y) + -31.0f))) && (((int)_4811 < (int)int(((_clipmapOffsets[_4770]).y) + 31.0f))))))) && (((((int)_4812 >= (int)int(((_clipmapOffsets[_4770]).z) + -63.0f))) && (((int)_4812 < (int)int(((_clipmapOffsets[_4770]).z) + 63.0f)))))) {
                _4833 = (_4810 & 127);
                _4834 = (_4811 & 63);
                _4835 = (_4812 & 127);
                _4836 = _4770;
              } else {
                if ((uint)(_4770 + 1) < (uint)8) {
                  _4770 = (_4770 + 1);
                  continue;
                } else {
                  _4833 = -10000;
                  _4834 = -10000;
                  _4835 = -10000;
                  _4836 = -10000;
                }
              }
              if ((uint)_4836 < (uint)6) {
                uint _4843 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4833, _4834, ((int)(((uint)(((int)(_4836 * 130)) | 1)) + (uint)(_4835))), 0));
                int _4845 = _4843.x & 4194303;
                [branch]
                if (!(_4845 == 0)) {
                  if ((_4743) || ((!(_4743)) && (_sunDirection.y > _moonDirection.y))) {
                    _4859 = _sunDirection.x;
                    _4860 = _sunDirection.y;
                    _4861 = _sunDirection.z;
                  } else {
                    _4859 = _moonDirection.x;
                    _4860 = _moonDirection.y;
                    _4861 = _moonDirection.z;
                  }
                  _4863 = 0.0f;
                  _4864 = 0.0f;
                  _4865 = 0.0f;
                  _4866 = 0.0f;
                  _4867 = 0.0f;
                  _4868 = 0.0f;
                  _4869 = 0.0f;
                  _4870 = 0;
                  while(true) {
                    int _4875 = __3__37__0__0__g_surfelDataBuffer[((_4845 + -1) + _4870)]._baseColor;
                    int _4877 = __3__37__0__0__g_surfelDataBuffer[((_4845 + -1) + _4870)]._normal;
                    if (!(_4875 == 0)) {
                      float _4885 = float((uint)((uint)(_4875 & 255)));
                      float _4886 = float((uint)((uint)(((uint)((uint)(_4875)) >> 8) & 255)));
                      float _4887 = float((uint)((uint)(((uint)((uint)(_4875)) >> 16) & 255)));
                      float _4912 = select(((_4885 * 0.003921568859368563f) < 0.040449999272823334f), (_4885 * 0.0003035269910469651f), exp2(log2((_4885 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                      float _4913 = select(((_4886 * 0.003921568859368563f) < 0.040449999272823334f), (_4886 * 0.0003035269910469651f), exp2(log2((_4886 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                      float _4914 = select(((_4887 * 0.003921568859368563f) < 0.040449999272823334f), (_4887 * 0.0003035269910469651f), exp2(log2((_4887 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                      float _4926 = (float((uint)((uint)(_4877 & 255))) * 0.007874015718698502f) + -1.0f;
                      float _4927 = (float((uint)((uint)(((uint)((uint)(_4877)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                      float _4928 = (float((uint)((uint)(((uint)((uint)(_4877)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                      float _4930 = rsqrt(dot(float3(_4926, _4927, _4928), float3(_4926, _4927, _4928)));
                      bool _4935 = ((_4877 & 16777215) == 0);
                      float _4936 = select(_4935, (_4765 * _4761), (_4930 * _4926));
                      float _4937 = select(_4935, (_4765 * _4762), (_4930 * _4927));
                      float _4938 = select(_4935, (_4763 * _4765), (_4930 * _4928));
                      float _4961 = float((bool)(uint)(saturate(dot(float3((-0.0f - _811), _4722, (-0.0f - _813)), float3(_4936, _4937, _4938))) > 0.0f));
                      float _4962 = _4961 * saturate(dot(float3(_4936, _4937, _4938), float3(_4859, _4860, _4861)));
                      float _4966 = (_4962 * (((_4913 * 0.3395099937915802f) + (_4912 * 0.6131200194358826f)) + (_4914 * 0.047370001673698425f))) + _4866;
                      float _4967 = (_4962 * (((_4913 * 0.9163600206375122f) + (_4912 * 0.07020000368356705f)) + (_4914 * 0.013450000435113907f))) + _4867;
                      float _4968 = (_4962 * (((_4913 * 0.10958000272512436f) + (_4912 * 0.02061999961733818f)) + (_4914 * 0.8697999715805054f))) + _4868;
                      float _4972 = (_4961 * _4936) + _4863;
                      float _4973 = (_4961 * _4937) + _4864;
                      float _4974 = (_4961 * _4938) + _4865;
                      float _4975 = _4961 + _4869;
                      if ((uint)(_4870 + 1) < (uint)4) {
                        _4863 = _4972;
                        _4864 = _4973;
                        _4865 = _4974;
                        _4866 = _4966;
                        _4867 = _4967;
                        _4868 = _4968;
                        _4869 = _4975;
                        _4870 = (_4870 + 1);
                        continue;
                      } else {
                        _4979 = _4972;
                        _4980 = _4973;
                        _4981 = _4974;
                        _4982 = _4966;
                        _4983 = _4967;
                        _4984 = _4968;
                        _4985 = _4975;
                      }
                    } else {
                      _4979 = _4863;
                      _4980 = _4864;
                      _4981 = _4865;
                      _4982 = _4866;
                      _4983 = _4867;
                      _4984 = _4868;
                      _4985 = _4869;
                    }
                    if (_4985 > 0.0f) {
                      float _4988 = 1.0f / _4985;
                      _4996 = (_4988 * _4979);
                      _4997 = (_4988 * _4980);
                      _4998 = (_4988 * _4981);
                      _4999 = 0.800000011920929f;
                      _5000 = (_4988 * _4982);
                      _5001 = (_4988 * _4983);
                      _5002 = (_4988 * _4984);
                      _5003 = 0.0010000000474974513f;
                      _5004 = true;
                      _5005 = 1.0f;
                    } else {
                      _4996 = _4979;
                      _4997 = _4980;
                      _4998 = _4981;
                      _4999 = 0.0f;
                      _5000 = _4982;
                      _5001 = _4983;
                      _5002 = _4984;
                      _5003 = 0.0f;
                      _5004 = false;
                      _5005 = _4616;
                    }
                    break;
                  }
                } else {
                  _4996 = 0.0f;
                  _4997 = 0.0f;
                  _4998 = 0.0f;
                  _4999 = 0.0f;
                  _5000 = 0.0f;
                  _5001 = 0.0f;
                  _5002 = 0.0f;
                  _5003 = 0.0f;
                  _5004 = false;
                  _5005 = _4616;
                }
              } else {
                _4996 = 0.0f;
                _4997 = 0.0f;
                _4998 = 0.0f;
                _4999 = 0.0f;
                _5000 = 0.0f;
                _5001 = 0.0f;
                _5002 = 0.0f;
                _5003 = 0.0f;
                _5004 = false;
                _5005 = _4616;
              }
              float _5007 = min(0.05000000074505806f, (_4587 * 0.019999999552965164f));
              float _5011 = (_5007 * _4996) + _4576;
              float _5012 = (_5007 * _4997) + _4577;
              float _5013 = (_5007 * _4998) + _4578;
              float _5016 = _5011 + _viewPos.x;
              float _5017 = _5012 + _viewPos.y;
              float _5018 = _5013 + _viewPos.z;
              float _5023 = _5016 - (_staticShadowPosition[1].x);
              float _5024 = _5017 - (_staticShadowPosition[1].y);
              float _5025 = _5018 - (_staticShadowPosition[1].z);
              float _5045 = mad((_shadowProjRelativeTexScale[1][0].z), _5025, mad((_shadowProjRelativeTexScale[1][0].y), _5024, (_5023 * (_shadowProjRelativeTexScale[1][0].x)))) + (_shadowProjRelativeTexScale[1][0].w);
              float _5049 = mad((_shadowProjRelativeTexScale[1][1].z), _5025, mad((_shadowProjRelativeTexScale[1][1].y), _5024, (_5023 * (_shadowProjRelativeTexScale[1][1].x)))) + (_shadowProjRelativeTexScale[1][1].w);
              float _5056 = 2.0f / _shadowSizeAndInvSize.y;
              float _5057 = 1.0f - _5056;
              bool _5064 = ((((((!(_5045 <= _5057))) || ((!(_5045 >= _5056))))) || ((!(_5049 <= _5057))))) || ((!(_5049 >= _5056)));
              float _5073 = _5016 - (_staticShadowPosition[0].x);
              float _5074 = _5017 - (_staticShadowPosition[0].y);
              float _5075 = _5018 - (_staticShadowPosition[0].z);
              float _5095 = mad((_shadowProjRelativeTexScale[0][0].z), _5075, mad((_shadowProjRelativeTexScale[0][0].y), _5074, ((_shadowProjRelativeTexScale[0][0].x) * _5073))) + (_shadowProjRelativeTexScale[0][0].w);
              float _5099 = mad((_shadowProjRelativeTexScale[0][1].z), _5075, mad((_shadowProjRelativeTexScale[0][1].y), _5074, ((_shadowProjRelativeTexScale[0][1].x) * _5073))) + (_shadowProjRelativeTexScale[0][1].w);
              bool _5110 = ((((((!(_5095 <= _5057))) || ((!(_5095 >= _5056))))) || ((!(_5099 <= _5057))))) || ((!(_5099 >= _5056)));
              float _5111 = select(_5110, select(_5064, 0.0f, _5045), _5095);
              float _5112 = select(_5110, select(_5064, 0.0f, _5049), _5099);
              float _5113 = select(_5110, select(_5064, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _5025, mad((_shadowProjRelativeTexScale[1][2].y), _5024, (_5023 * (_shadowProjRelativeTexScale[1][2].x)))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _5075, mad((_shadowProjRelativeTexScale[0][2].y), _5074, ((_shadowProjRelativeTexScale[0][2].x) * _5073))) + (_shadowProjRelativeTexScale[0][2].w)));
              int _5114 = select(_5110, select(_5064, -1, 1), 0);
              [branch]
              if (!(_5114 == -1)) {
                float _5120 = (_5111 * _shadowSizeAndInvSize.x) + -0.5f;
                float _5121 = (_5112 * _shadowSizeAndInvSize.y) + -0.5f;
                int _5124 = int(floor(_5120));
                int _5125 = int(floor(_5121));
                if (!((((uint)_5124 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_5125 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
                  float4 _5135 = __3__36__0__0__g_shadowDepthArray.Load(int4(_5124, _5125, _5114, 0));
                  float4 _5137 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_5124) + 1u)), _5125, _5114, 0));
                  float4 _5139 = __3__36__0__0__g_shadowDepthArray.Load(int4(_5124, ((int)((uint)(_5125) + 1u)), _5114, 0));
                  float4 _5141 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_5124) + 1u)), ((int)((uint)(_5125) + 1u)), _5114, 0));
                  half4 _5145 = __3__36__0__0__g_shadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_5111, _5112, float((uint)(uint)(_5114))), 0.0f);
                  _5151 = _5135.x;
                  _5152 = _5137.x;
                  _5153 = _5139.x;
                  _5154 = _5141.x;
                  _5155 = _5145.x;
                  _5156 = _5145.y;
                  _5157 = _5145.z;
                  _5158 = _5145.w;
                } else {
                  _5151 = 0.0f;
                  _5152 = 0.0f;
                  _5153 = 0.0f;
                  _5154 = 0.0f;
                  _5155 = 1.0h;
                  _5156 = 1.0h;
                  _5157 = 1.0h;
                  _5158 = 1.0h;
                }
                float _5184 = (float4(_invShadowViewProj[_5114][0][0], _invShadowViewProj[_5114][1][0], _invShadowViewProj[_5114][2][0], _invShadowViewProj[_5114][3][0]).x) * _5111;
                float _5188 = (float4(_invShadowViewProj[_5114][0][0], _invShadowViewProj[_5114][1][0], _invShadowViewProj[_5114][2][0], _invShadowViewProj[_5114][3][0]).y) * _5111;
                float _5192 = (float4(_invShadowViewProj[_5114][0][0], _invShadowViewProj[_5114][1][0], _invShadowViewProj[_5114][2][0], _invShadowViewProj[_5114][3][0]).z) * _5111;
                float _5196 = (float4(_invShadowViewProj[_5114][0][0], _invShadowViewProj[_5114][1][0], _invShadowViewProj[_5114][2][0], _invShadowViewProj[_5114][3][0]).w) * _5111;
                float _5199 = mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).w), _5151, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).w), _5112, _5196)) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).w);
                float _5200 = (mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).x), _5151, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).x), _5112, _5184)) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).x)) / _5199;
                float _5201 = (mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).y), _5151, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).y), _5112, _5188)) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).y)) / _5199;
                float _5202 = (mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).z), _5151, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).z), _5112, _5192)) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).z)) / _5199;
                float _5205 = _5111 + (_shadowSizeAndInvSize.z * 4.0f);
                float _5221 = mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).w), _5152, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).w), _5112, ((float4(_invShadowViewProj[_5114][0][0], _invShadowViewProj[_5114][1][0], _invShadowViewProj[_5114][2][0], _invShadowViewProj[_5114][3][0]).w) * _5205))) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).w);
                float _5227 = _5112 - (_shadowSizeAndInvSize.w * 2.0f);
                float _5239 = mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).w), _5153, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).w), _5227, _5196)) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).w);
                float _5243 = ((mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).x), _5153, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).x), _5227, _5184)) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).x)) / _5239) - _5200;
                float _5244 = ((mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).y), _5153, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).y), _5227, _5188)) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).y)) / _5239) - _5201;
                float _5245 = ((mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).z), _5153, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).z), _5227, _5192)) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).z)) / _5239) - _5202;
                float _5246 = ((mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).x), _5152, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).x), _5112, ((float4(_invShadowViewProj[_5114][0][0], _invShadowViewProj[_5114][1][0], _invShadowViewProj[_5114][2][0], _invShadowViewProj[_5114][3][0]).x) * _5205))) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).x)) / _5221) - _5200;
                float _5247 = ((mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).y), _5152, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).y), _5112, ((float4(_invShadowViewProj[_5114][0][0], _invShadowViewProj[_5114][1][0], _invShadowViewProj[_5114][2][0], _invShadowViewProj[_5114][3][0]).y) * _5205))) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).y)) / _5221) - _5201;
                float _5248 = ((mad((float4(_invShadowViewProj[_5114][0][2], _invShadowViewProj[_5114][1][2], _invShadowViewProj[_5114][2][2], _invShadowViewProj[_5114][3][2]).z), _5152, mad((float4(_invShadowViewProj[_5114][0][1], _invShadowViewProj[_5114][1][1], _invShadowViewProj[_5114][2][1], _invShadowViewProj[_5114][3][1]).z), _5112, ((float4(_invShadowViewProj[_5114][0][0], _invShadowViewProj[_5114][1][0], _invShadowViewProj[_5114][2][0], _invShadowViewProj[_5114][3][0]).z) * _5205))) + (float4(_invShadowViewProj[_5114][0][3], _invShadowViewProj[_5114][1][3], _invShadowViewProj[_5114][2][3], _invShadowViewProj[_5114][3][3]).z)) / _5221) - _5202;
                float _5251 = (_5245 * _5247) - (_5244 * _5248);
                float _5254 = (_5243 * _5248) - (_5245 * _5246);
                float _5257 = (_5244 * _5246) - (_5243 * _5247);
                float _5259 = rsqrt(dot(float3(_5251, _5254, _5257), float3(_5251, _5254, _5257)));
                float _5260 = _5251 * _5259;
                float _5261 = _5254 * _5259;
                float _5262 = _5257 * _5259;
                float _5263 = frac(_5120);
                float _5268 = (saturate(dot(float3(_811, _812, _813), float3(_5260, _5261, _5262))) * 0.0020000000949949026f) + _5113;
                float _5281 = saturate(exp2((_5151 - _5268) * 1442695.0f));
                float _5283 = saturate(exp2((_5153 - _5268) * 1442695.0f));
                float _5289 = ((saturate(exp2((_5152 - _5268) * 1442695.0f)) - _5281) * _5263) + _5281;
                _5296 = _5260;
                _5297 = _5261;
                _5298 = _5262;
                _5299 = saturate((((_5283 - _5289) + ((saturate(exp2((_5154 - _5268) * 1442695.0f)) - _5283) * _5263)) * frac(_5121)) + _5289);
                _5300 = _5151;
                _5301 = _5152;
                _5302 = _5153;
                _5303 = _5154;
                _5304 = _5155;
                _5305 = _5156;
                _5306 = _5157;
                _5307 = _5158;
              } else {
                _5296 = 0.0f;
                _5297 = 0.0f;
                _5298 = 0.0f;
                _5299 = 0.0f;
                _5300 = 0.0f;
                _5301 = 0.0f;
                _5302 = 0.0f;
                _5303 = 0.0f;
                _5304 = 0.0h;
                _5305 = 0.0h;
                _5306 = 0.0h;
                _5307 = 0.0h;
              }
              float _5327 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _5013, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _5012, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _5011))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
              float _5331 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _5013, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _5012, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _5011))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
              float _5335 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _5013, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _5012, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _5011))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
              float _5338 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
              float _5339 = 1.0f - _5338;
              if (!(((((!(_5327 <= _5339))) || ((!(_5327 >= _5338))))) || ((!(_5331 <= _5339))))) {
                bool _5350 = ((_5335 >= -1.0f)) && ((((_5335 <= 1.0f)) && ((_5331 >= _5338))));
                _5358 = select(_5350, 9.999999747378752e-06f, -9.999999747378752e-05f);
                _5359 = select(_5350, _5327, _5111);
                _5360 = select(_5350, _5331, _5112);
                _5361 = select(_5350, _5335, _5113);
                _5362 = select(_5350, 1, _5114);
                _5363 = ((int)(uint)((int)(_5350)));
              } else {
                _5358 = -9.999999747378752e-05f;
                _5359 = _5111;
                _5360 = _5112;
                _5361 = _5113;
                _5362 = _5114;
                _5363 = 0;
              }
              float _5383 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _5013, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _5012, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _5011))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
              float _5387 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _5013, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _5012, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _5011))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
              float _5391 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _5013, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _5012, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _5011))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
              if (!(((((!(_5383 <= _5339))) || ((!(_5383 >= _5338))))) || ((!(_5387 <= _5339))))) {
                bool _5402 = ((_5391 >= -1.0f)) && ((((_5387 >= _5338)) && ((_5391 <= 1.0f))));
                _5410 = select(_5402, 9.999999747378752e-06f, _5358);
                _5411 = select(_5402, _5383, _5359);
                _5412 = select(_5402, _5387, _5360);
                _5413 = select(_5402, _5391, _5361);
                _5414 = select(_5402, 0, _5362);
                _5415 = select(_5402, 1, _5363);
              } else {
                _5410 = _5358;
                _5411 = _5359;
                _5412 = _5360;
                _5413 = _5361;
                _5414 = _5362;
                _5415 = _5363;
              }
              [branch]
              if (!(_5415 == 0)) {
                int _5425 = int(floor((_5411 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
                int _5426 = int(floor((_5412 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
                if (!((((uint)_5425 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_5426 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
                  float4 _5436 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_5425, _5426, _5414, 0));
                  float4 _5438 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_5425) + 1u)), _5426, _5414, 0));
                  float4 _5440 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_5425, ((int)((uint)(_5426) + 1u)), _5414, 0));
                  float4 _5442 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_5425) + 1u)), ((int)((uint)(_5426) + 1u)), _5414, 0));
                  _5445 = _5436.x;
                  _5446 = _5438.x;
                  _5447 = _5440.x;
                  _5448 = _5442.x;
                } else {
                  _5445 = _5300;
                  _5446 = _5301;
                  _5447 = _5302;
                  _5448 = _5303;
                }
                float _5474 = (float4(_invDynamicShadowViewProj[_5414][0][0], _invDynamicShadowViewProj[_5414][1][0], _invDynamicShadowViewProj[_5414][2][0], _invDynamicShadowViewProj[_5414][3][0]).x) * _5411;
                float _5478 = (float4(_invDynamicShadowViewProj[_5414][0][0], _invDynamicShadowViewProj[_5414][1][0], _invDynamicShadowViewProj[_5414][2][0], _invDynamicShadowViewProj[_5414][3][0]).y) * _5411;
                float _5482 = (float4(_invDynamicShadowViewProj[_5414][0][0], _invDynamicShadowViewProj[_5414][1][0], _invDynamicShadowViewProj[_5414][2][0], _invDynamicShadowViewProj[_5414][3][0]).z) * _5411;
                float _5486 = (float4(_invDynamicShadowViewProj[_5414][0][0], _invDynamicShadowViewProj[_5414][1][0], _invDynamicShadowViewProj[_5414][2][0], _invDynamicShadowViewProj[_5414][3][0]).w) * _5411;
                float _5489 = mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).w), _5445, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).w), _5412, _5486)) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).w);
                float _5490 = (mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).x), _5445, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).x), _5412, _5474)) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).x)) / _5489;
                float _5491 = (mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).y), _5445, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).y), _5412, _5478)) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).y)) / _5489;
                float _5492 = (mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).z), _5445, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).z), _5412, _5482)) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).z)) / _5489;
                float _5495 = _5411 + (_dynmaicShadowSizeAndInvSize.z * 8.0f);
                float _5511 = mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).w), _5446, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).w), _5412, ((float4(_invDynamicShadowViewProj[_5414][0][0], _invDynamicShadowViewProj[_5414][1][0], _invDynamicShadowViewProj[_5414][2][0], _invDynamicShadowViewProj[_5414][3][0]).w) * _5495))) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).w);
                float _5517 = _5412 - (_dynmaicShadowSizeAndInvSize.w * 4.0f);
                float _5529 = mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).w), _5447, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).w), _5517, _5486)) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).w);
                float _5533 = ((mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).x), _5447, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).x), _5517, _5474)) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).x)) / _5529) - _5490;
                float _5534 = ((mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).y), _5447, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).y), _5517, _5478)) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).y)) / _5529) - _5491;
                float _5535 = ((mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).z), _5447, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).z), _5517, _5482)) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).z)) / _5529) - _5492;
                float _5536 = ((mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).x), _5446, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).x), _5412, ((float4(_invDynamicShadowViewProj[_5414][0][0], _invDynamicShadowViewProj[_5414][1][0], _invDynamicShadowViewProj[_5414][2][0], _invDynamicShadowViewProj[_5414][3][0]).x) * _5495))) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).x)) / _5511) - _5490;
                float _5537 = ((mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).y), _5446, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).y), _5412, ((float4(_invDynamicShadowViewProj[_5414][0][0], _invDynamicShadowViewProj[_5414][1][0], _invDynamicShadowViewProj[_5414][2][0], _invDynamicShadowViewProj[_5414][3][0]).y) * _5495))) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).y)) / _5511) - _5491;
                float _5538 = ((mad((float4(_invDynamicShadowViewProj[_5414][0][2], _invDynamicShadowViewProj[_5414][1][2], _invDynamicShadowViewProj[_5414][2][2], _invDynamicShadowViewProj[_5414][3][2]).z), _5446, mad((float4(_invDynamicShadowViewProj[_5414][0][1], _invDynamicShadowViewProj[_5414][1][1], _invDynamicShadowViewProj[_5414][2][1], _invDynamicShadowViewProj[_5414][3][1]).z), _5412, ((float4(_invDynamicShadowViewProj[_5414][0][0], _invDynamicShadowViewProj[_5414][1][0], _invDynamicShadowViewProj[_5414][2][0], _invDynamicShadowViewProj[_5414][3][0]).z) * _5495))) + (float4(_invDynamicShadowViewProj[_5414][0][3], _invDynamicShadowViewProj[_5414][1][3], _invDynamicShadowViewProj[_5414][2][3], _invDynamicShadowViewProj[_5414][3][3]).z)) / _5511) - _5492;
                float _5541 = (_5535 * _5537) - (_5534 * _5538);
                float _5544 = (_5533 * _5538) - (_5535 * _5536);
                float _5547 = (_5534 * _5536) - (_5533 * _5537);
                float _5549 = rsqrt(dot(float3(_5541, _5544, _5547), float3(_5541, _5544, _5547)));
                if ((_4743) || ((!(_4743)) && (_sunDirection.y > _moonDirection.y))) {
                  _5564 = _sunDirection.x;
                  _5565 = _sunDirection.y;
                  _5566 = _sunDirection.z;
                } else {
                  _5564 = _moonDirection.x;
                  _5565 = _moonDirection.y;
                  _5566 = _moonDirection.z;
                }
                float _5572 = (_5410 - (saturate(-0.0f - dot(float3(_5564, _5565, _5566), float3(_811, _812, _813))) * 9.999999747378752e-05f)) + _5413;
                _5585 = (_5541 * _5549);
                _5586 = (_5544 * _5549);
                _5587 = (_5547 * _5549);
                _5588 = min(float((bool)(uint)(_5445 > _5572)), min(min(float((bool)(uint)(_5446 > _5572)), float((bool)(uint)(_5447 > _5572))), float((bool)(uint)(_5448 > _5572))));
              } else {
                _5585 = _5296;
                _5586 = _5297;
                _5587 = _5298;
                _5588 = _5299;
              }
              float _5596 = (_viewPos.x - _shadowRelativePosition.x) + _5011;
              float _5597 = (_viewPos.y - _shadowRelativePosition.y) + _5012;
              float _5598 = (_viewPos.z - _shadowRelativePosition.z) + _5013;
              float _5618 = mad((_terrainShadowProjRelativeTexScale[0].z), _5598, mad((_terrainShadowProjRelativeTexScale[0].y), _5597, (_5596 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
              float _5622 = mad((_terrainShadowProjRelativeTexScale[1].z), _5598, mad((_terrainShadowProjRelativeTexScale[1].y), _5597, (_5596 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
              float _5626 = mad((_terrainShadowProjRelativeTexScale[2].z), _5598, mad((_terrainShadowProjRelativeTexScale[2].y), _5597, (_5596 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
              if (saturate(_5618) == _5618) {
                if (((_5626 >= 9.999999747378752e-05f)) && ((((_5626 <= 1.0f)) && ((saturate(_5622) == _5622))))) {
                  float _5641 = frac((_5618 * 1024.0f) + -0.5f);
                  float4 _5645 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_5618, _5622));
                  float _5650 = _5626 + -0.004999999888241291f;
                  float _5655 = select((_5645.w > _5650), 1.0f, 0.0f);
                  float _5657 = select((_5645.x > _5650), 1.0f, 0.0f);
                  float _5664 = ((select((_5645.z > _5650), 1.0f, 0.0f) - _5655) * _5641) + _5655;
                  _5670 = saturate((((((select((_5645.y > _5650), 1.0f, 0.0f) - _5657) * _5641) + _5657) - _5664) * frac((_5622 * 1024.0f) + -0.5f)) + _5664);
                } else {
                  _5670 = 1.0f;
                }
              } else {
                _5670 = 1.0f;
              }
              half _5672 = saturate(_5304);
              half _5673 = saturate(_5305);
              half _5674 = saturate(_5306);
              half _5688 = ((_5673 * 0.3395996h) + (_5672 * 0.61328125h)) + (_5674 * 0.04736328h);
              half _5689 = ((_5673 * 0.9165039h) + (_5672 * 0.07019043h)) + (_5674 * 0.013450623h);
              half _5690 = ((_5673 * 0.109558105h) + (_5672 * 0.020614624h)) + (_5674 * 0.8696289h);
              if ((_4743) || ((!(_4743)) && (_sunDirection.y > _moonDirection.y))) {
                _5702 = _sunDirection.x;
                _5703 = _sunDirection.y;
                _5704 = _sunDirection.z;
              } else {
                _5702 = _moonDirection.x;
                _5703 = _moonDirection.y;
                _5704 = _moonDirection.z;
              }
              if ((_4743) || ((!(_4743)) && (_sunDirection.y > _moonDirection.y))) {
                _5724 = _precomputedAmbient7.y;
              } else {
                _5724 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
              }
              float _5727 = _5017 + _earthRadius;
              float _5731 = (_5013 * _5013) + (_5011 * _5011);
              float _5733 = sqrt((_5727 * _5727) + _5731);
              float _5738 = dot(float3((_5011 / _5733), (_5727 / _5733), (_5013 / _5733)), float3(_5702, _5703, _5704));
              float _5743 = min(max(((_5733 - _earthRadius) / _atmosphereThickness), 16.0f), (_atmosphereThickness + -16.0f));
              float _5751 = max(_5743, 0.0f);
              float _5758 = (-0.0f - sqrt((_5751 + (_earthRadius * 2.0f)) * _5751)) / (_5751 + _earthRadius);
              if (_5738 > _5758) {
                _5781 = ((exp2(log2(saturate((_5738 - _5758) / (1.0f - _5758))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
              } else {
                _5781 = ((exp2(log2(saturate((_5758 - _5738) / (_5758 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
              }
              float2 _5785 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_5743 + -16.0f) / (_atmosphereThickness + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _5781), 0.0f);
              float _5807 = ((_5785.y * 1.9999999494757503e-05f) * _mieAerosolDensity) * (_mieAerosolAbsorption + 1.0f);
              float _5825 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f)) * _5785.x) + _5807) * -1.4426950216293335f);
              float _5826 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f)) * _5785.x) + _5807) * -1.4426950216293335f);
              float _5827 = exp2(((((_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f)) * _5785.x) + _5807) * -1.4426950216293335f);
              float _5843 = sqrt(_5731);
              float _5851 = (_cloudAltitude - (max(((_5843 * _5843) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
              float _5863 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_5703 > 0.0f))) - ((int)(uint)((int)(_5703 < 0.0f))))) * 0.5f))) + _5851;
              if (_5012 < _5851) {
                float _5866 = dot(float3(0.0f, 1.0f, 0.0f), float3(_5702, _5703, _5704));
                float _5872 = select((abs(_5866) < 9.99999993922529e-09f), 1e+08f, ((_5863 - dot(float3(0.0f, 1.0f, 0.0f), float3(_5011, _5012, _5013))) / _5866));
                _5878 = ((_5872 * _5702) + _5011);
                _5879 = _5863;
                _5880 = ((_5872 * _5704) + _5013);
              } else {
                _5878 = _5011;
                _5879 = _5012;
                _5880 = _5013;
              }
              float _5889 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_5878 * 4.999999873689376e-05f) + 0.5f), ((_5879 - _5851) / _cloudThickness), ((_5880 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
              float _5900 = saturate(abs(_5703) * 4.0f);
              float _5902 = (_5900 * _5900) * exp2(((_distanceScale * -1.4426950216293335f) * _5889.x) * (_cloudScatteringCoefficient / _distanceScale));
              float _5909 = ((1.0f - _5902) * saturate(((_5012 - _cloudThickness) - _5851) * 0.10000000149011612f)) + _5902;
              float _5910 = _5909 * (((_5826 * 0.3395099937915802f) + (_5825 * 0.6131200194358826f)) + (_5827 * 0.047370001673698425f));
              float _5911 = _5909 * (((_5826 * 0.9163600206375122f) + (_5825 * 0.07020000368356705f)) + (_5827 * 0.013450000435113907f));
              float _5912 = _5909 * (((_5826 * 0.10958000272512436f) + (_5825 * 0.02061999961733818f)) + (_5827 * 0.8697999715805054f));
              float _5928 = float(saturate(_5307));
              if (_5004) {
                bool _5930 = (_4999 > 0.0f);
                if (_5003 > 0.0f) {
                  _5941 = half(_5000);
                  _5942 = half(_5001);
                  _5943 = half(_5002);
                  _5944 = dot(float3(select(_5930, _4996, _5585), select(_5930, _4997, _5586), select(_5930, _4998, _5587)), float3(_5702, _5703, _5704));
                } else {
                  _5941 = _5688;
                  _5942 = _5689;
                  _5943 = _5690;
                  _5944 = _5928;
                }
              } else {
                _5941 = _5688;
                _5942 = _5689;
                _5943 = _5690;
                _5944 = _5928;
              }
              float _5948 = float(half(saturate(_5944) * 0.31830987334251404f));
              float _5954 = ((min(_5588, _5670) * _5005) * _5724) * _renderParams2.z;
              _5968 = ((((_5954 * (((_5910 * 0.6131200194358826f) + (_5911 * 0.3395099937915802f)) + (_5912 * 0.047370001673698425f))) * float(_5941)) * _5948) + _4582);
              _5969 = ((((_5954 * (((_5910 * 0.07020000368356705f) + (_5911 * 0.9163600206375122f)) + (_5912 * 0.013450000435113907f))) * float(_5942)) * _5948) + _4583);
              _5970 = ((((_5954 * (((_5910 * 0.02061999961733818f) + (_5911 * 0.10958000272512436f)) + (_5912 * 0.8697999715805054f))) * float(_5943)) * _5948) + _4584);
              break;
            }
            break;
          }
        } else {
          _5968 = _4582;
          _5969 = _4583;
          _5970 = _4584;
        }
        float _5971 = dot(float3(_5968, _5969, _5970), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _5972 = min(_851, _5971);
        float _5976 = max(9.999999717180685e-10f, _5971);
        _5981 = ((_5972 * _5968) / _5976);
        _5982 = ((_5972 * _5969) / _5976);
        _5983 = ((_5972 * _5970) / _5976);
        _5984 = (_4571 * _renderParams.y);
        _5985 = _4587;
        _5986 = _4576;
        _5987 = _4577;
        _5988 = _4578;
      } else {
        _5981 = _3315;
        _5982 = _3316;
        _5983 = _3317;
        _5984 = _3290;
        _5985 = _3284;
        _5986 = _3291;
        _5987 = _3292;
        _5988 = _3293;
      }
      break;
    }
  } else {
    _5981 = _3315;
    _5982 = _3316;
    _5983 = _3317;
    _5984 = _3290;
    _5985 = _3284;
    _5986 = _3291;
    _5987 = _3292;
    _5988 = _3293;
  }
  if (((_3361 > 0.0f)) && ((_5984 < 1.0f))) {
    _6009 = ((_5984 * (_5981 - _3358)) + _3358);
    _6010 = ((_5984 * (_5982 - _3359)) + _3359);
    _6011 = ((_5984 * (_5983 - _3360)) + _3360);
    _6012 = 10000.0f;
    _6013 = ((_811 * 10000.0f) + _156);
    _6014 = ((_812 * 10000.0f) + _157);
    _6015 = ((_813 * 10000.0f) + _158);
  } else {
    _6009 = _5981;
    _6010 = _5982;
    _6011 = _5983;
    _6012 = _5985;
    _6013 = _5986;
    _6014 = _5987;
    _6015 = _5988;
  }
  if (((_6012 > 128.0f)) && ((dot(float3(_6009, _6010, _6011), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) == 0.0f))) {
    _6022 = 1;
    while(true) {
      int _6062 = int(floor(((_wrappedViewPos.x + _6013) * ((_clipmapOffsets[_6022]).w)) + ((_clipmapRelativeIndexOffsets[_6022]).x)));
      int _6063 = int(floor(((_wrappedViewPos.y + _6014) * ((_clipmapOffsets[_6022]).w)) + ((_clipmapRelativeIndexOffsets[_6022]).y)));
      int _6064 = int(floor(((_wrappedViewPos.z + _6015) * ((_clipmapOffsets[_6022]).w)) + ((_clipmapRelativeIndexOffsets[_6022]).z)));
      if (!((((((((int)_6062 >= (int)int(((_clipmapOffsets[_6022]).x) + -63.0f))) && (((int)_6062 < (int)int(((_clipmapOffsets[_6022]).x) + 63.0f))))) && (((((int)_6063 >= (int)int(((_clipmapOffsets[_6022]).y) + -31.0f))) && (((int)_6063 < (int)int(((_clipmapOffsets[_6022]).y) + 31.0f))))))) && (((((int)_6064 >= (int)int(((_clipmapOffsets[_6022]).z) + -63.0f))) && (((int)_6064 < (int)int(((_clipmapOffsets[_6022]).z) + 63.0f))))))) {
        if ((uint)(_6022 + 1) < (uint)8) {
          _6022 = (_6022 + 1);
          continue;
        } else {
          _6080 = -10000;
        }
      } else {
        _6080 = _6022;
      }
      if (!((uint)_6080 > (uint)3)) {
        float _6100 = 1.0f / float((uint)(1u << (_6080 & 31)));
        float _6104 = frac(((_invClipmapExtent.z * _6015) + _clipmapUVRelativeOffset.z) * _6100);
        float _6116 = __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _6013) + _clipmapUVRelativeOffset.x) * _6100), (((_invClipmapExtent.y * _6014) + _clipmapUVRelativeOffset.y) * _6100), (((float((uint)(_6080 * 66)) + 1.0f) + ((select((_6104 < 0.0f), 1.0f, 0.0f) + _6104) * 64.0f)) * 0.0037878789007663727f)), 0.0f);
        _6121 = saturate(1.0f - _6116.x);
      } else {
        _6121 = 1.0f;
      }
      bool _6122 = (_974 == 0.0f);
      float4 _6130 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(select(_6122, (-0.0f - _811), _978), select(_6122, _812, _979), select(_6122, (-0.0f - _813), _980)), 4.0f);
      _6144 = ((_6121 * select(_6122, 0.03125f, _1001)) * _6130.x);
      _6145 = ((_6121 * select(_6122, 0.03125f, _1002)) * _6130.y);
      _6146 = ((_6121 * select(_6122, 0.03125f, _1003)) * _6130.z);
      // [DAWN_DUSK_GI] Probe directional boost + energy floor
      if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
        float _ddFactor = DawnDuskFactor(_sunDirection.y);
        float3 _ddAmbient = DawnDuskAmbientBoost(
          float3(_6144, _6145, _6146),
          float3(_800, _801, _802),
          _sunDirection.xyz,
          _ddFactor,
          _precomputedAmbient0.xyz);
        _6144 = _ddAmbient.x;
        _6145 = _ddAmbient.y;
        _6146 = _ddAmbient.z;
      }
      break;
    }
  } else {
    _6144 = _6009;
    _6145 = _6010;
    _6146 = _6011;
  }
  float _6150 = max(0.0f, _6144);
  float _6151 = max(0.0f, _6145);
  float _6152 = max(0.0f, _6146);
  float _6154 = min(-0.0f, (-0.0f - _344));
  bool _6158 = (_338 == 29);
  [branch]
  if (_lightingParams.y > 0.0f) {
    float2 _6165 = __3__36__0__0__g_sceneAO.Load(int3(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))), 0));
    float _6169 = select(((uint)(_338 & 24) > (uint)23), 1.0f, _6165.y);
    _6174 = (_6169 * _6150);
    _6175 = (_6169 * _6151);
    _6176 = (_6169 * _6152);
  } else {
    _6174 = _6150;
    _6175 = _6151;
    _6176 = _6152;
  }
  float4 _6178 = __3__38__0__1__g_specularResultUAV.Load(int2(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5))))));
  float _6185 = min(-9.999999974752427e-07f, (-0.0f - dot(float3(_6174, _6175, _6176), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f))));
  float _6186 = dot(float3(_6178.x, _6178.y, _6178.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _6193 = ((_6186 * _6178.w) - ((saturate(dot(float3((_822 * _818), (_822 * _819), (_822 * _820)), float3(_811, _812, _813))) * _6012) * _6185)) * (1.0f / max(9.999999974752427e-07f, (_6186 - _6185)));
  bool _6195 = ((_338 == 24)) || (_6158);
  __3__38__0__1__g_specularResultUAV[int2(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))))] = float4((-0.0f - min(0.0f, (-0.0f - min(30000.0f, (_exposure4.x * (select(_6195, 0.0f, _6178.x) + _6174)))))), (-0.0f - min(0.0f, (-0.0f - min(30000.0f, (_exposure4.x * (select(_6195, 0.0f, _6178.y) + _6175)))))), (-0.0f - min(0.0f, (-0.0f - min(30000.0f, (_exposure4.x * (select(_6195, 0.0f, _6178.z) + _6176)))))), select((_lightingParams.w > 0.0f), _6193, select(_6158, _299, select((_302 > 0.20000000298023224f), _6154, (-0.0f - _6154)))));
  __3__38__0__1__g_specularRayHitDistanceUAV[int2(((int)((((uint)(((int)((uint)(_77) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_58 - (_59 << 2)) << 3)))), ((int)((((uint)(_59 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_77)) >> 16) << 5)))))] = _6193;
}