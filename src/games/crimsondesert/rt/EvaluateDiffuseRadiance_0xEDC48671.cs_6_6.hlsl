#include "../shared.h"
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
  int _106 = (uint)((uint)(_104.x)) >> 24;
  int _110 = _106 & 127;
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
  float _188 = float((uint)((uint)(((int)(((uint)((uint)(_frameNumber.x)) >> 2) * 71)) & 31)));
  bool _205;
  int _258;
  int _316;
  int _337;
  int _400;
  int _401;
  int _402;
  int _403;
  float _460;
  float _461;
  float _462;
  float _463;
  float _464;
  float _465;
  float _466;
  int _467;
  float _679;
  float _680;
  float _681;
  float _682;
  float _699;
  float _700;
  float _701;
  float _741;
  float _742;
  float _743;
  float _750;
  float _751;
  float _752;
  float _753;
  float _754;
  float _755;
  float _756;
  float _757;
  int _758;
  float _759;
  float _760;
  float _761;
  float _762;
  float _763;
  bool _778;
  float _949;
  float _950;
  float _951;
  float _952;
  float _963;
  float _964;
  float _965;
  float _966;
  float _967;
  float _968;
  float _969;
  float _970;
  float _971;
  int _972;
  int _974;
  int _1035;
  int _1036;
  float _1043;
  float _1103;
  float _1104;
  float _1105;
  float _1106;
  int _1112;
  int _1170;
  int _1207;
  float _1208;
  float _1209;
  float _1210;
  float _1211;
  float _1212;
  int _1214;
  float _1431;
  float _1432;
  float _1451;
  float _1452;
  float _1453;
  float _1454;
  float _1455;
  float _1457;
  float _1458;
  float _1459;
  float _1460;
  float _1461;
  float _1462;
  int _1479;
  int _1542;
  int _1543;
  int _1544;
  int _1545;
  int _1561;
  int _1562;
  int _1563;
  int _1564;
  int _1570;
  int _1633;
  int _1634;
  int _1635;
  int _1636;
  int _1641;
  int _1642;
  int _1643;
  int _1644;
  int _1645;
  int _1648;
  int _1649;
  int _1650;
  int _1651;
  int _1654;
  int _1655;
  int _1656;
  int _1657;
  int _1658;
  bool _1681;
  int _1682;
  int _1683;
  int _1684;
  int _1685;
  int _1686;
  int _1695;
  int _1696;
  int _1697;
  int _1698;
  int _1699;
  float _1758;
  float _1759;
  float _1760;
  float _1761;
  int _1762;
  float _1963;
  float _1964;
  float _1965;
  float _1966;
  float _1983;
  float _1984;
  float _1985;
  float _1986;
  float _2014;
  float _2015;
  float _2016;
  float _2017;
  float _2018;
  bool _2032;
  float _2055;
  float _2056;
  float _2057;
  float _2058;
  float _2140;
  float _2141;
  float _2142;
  float _2285;
  float _2286;
  float _2287;
  float _2288;
  half _2289;
  half _2290;
  half _2291;
  half _2292;
  float _2430;
  float _2431;
  float _2432;
  float _2433;
  float _2434;
  float _2435;
  float _2436;
  float _2437;
  half _2438;
  half _2439;
  half _2440;
  half _2441;
  float _2492;
  float _2493;
  float _2494;
  float _2495;
  int _2496;
  int _2497;
  float _2544;
  float _2545;
  float _2546;
  float _2547;
  int _2548;
  int _2549;
  float _2579;
  float _2580;
  float _2581;
  float _2582;
  float _2701;
  float _2702;
  float _2703;
  float _2722;
  float _2723;
  float _2724;
  float _2725;
  float _2807;
  float _2842;
  float _2843;
  float _2844;
  float _2864;
  float _2921;
  float _3019;
  float _3020;
  float _3021;
  float _3089;
  float _3090;
  float _3091;
  float _3092;
  half _3093;
  half _3094;
  half _3095;
  float _3096;
  float _3097;
  float _3098;
  float _3099;
  float _3100;
  float _3232;
  float _3233;
  float _3234;
  float _3338;
  float _3339;
  float _3340;
  float _3341;
  float _3479;
  float _3480;
  float _3481;
  float _3482;
  float _3483;
  float _3514;
  float _3515;
  float _3516;
  float _3517;
  int _3518;
  int _3519;
  float _3550;
  float _3551;
  float _3552;
  float _3553;
  int _3554;
  int _3555;
  float _3585;
  float _3586;
  float _3587;
  float _3588;
  float _3600;
  float _3601;
  float _3602;
  float _3621;
  float _3680;
  float _3737;
  float _3789;
  float _3855;
  float _3856;
  float _3857;
  float _3910;
  float _3911;
  float _3912;
  float _3932;
  float _3933;
  float _3934;
  float _3935;
  int _3946;
  int _4004;
  float _4045;
  float _4071;
  float _4072;
  float _4073;
  float _4130;
  float _4131;
  float _4132;
  int _4235;
  int _4293;
  int _4306;
  float _4307;
  float _4308;
  float _4309;
  float _4310;
  float _4311;
  float _4312;
  float _4313;
  float _4314;
  int _4316;
  int _4366;
  int _4429;
  int _4430;
  int _4431;
  int _4432;
  int _4450;
  int _4451;
  int _4452;
  int _4453;
  int _4460;
  int _4523;
  int _4524;
  int _4525;
  int _4526;
  int _4531;
  int _4532;
  int _4533;
  int _4534;
  int _4535;
  int _4538;
  int _4539;
  int _4540;
  int _4541;
  int _4544;
  int _4545;
  int _4546;
  int _4547;
  int _4548;
  bool _4571;
  int _4572;
  int _4573;
  int _4574;
  int _4575;
  int _4576;
  int _4585;
  int _4586;
  int _4587;
  int _4588;
  int _4589;
  float _4648;
  float _4649;
  float _4650;
  float _4651;
  int _4652;
  float _4847;
  float _4848;
  float _4849;
  float _4850;
  float _4867;
  float _4868;
  float _4869;
  float _4895;
  float _4896;
  float _4897;
  float _4898;
  float _4900;
  float _4901;
  float _4902;
  float _4903;
  float _4932;
  float _4933;
  float _4934;
  float _4954;
  float _5014;
  float _5112;
  float _5113;
  float _5114;
  float _5297;
  float _5298;
  float _5299;
  float _5300;
  float _5438;
  float _5439;
  float _5440;
  float _5441;
  float _5442;
  int _5493;
  int _5494;
  float _5495;
  float _5496;
  float _5497;
  float _5498;
  int _5545;
  int _5546;
  float _5547;
  float _5548;
  float _5549;
  float _5550;
  float _5580;
  float _5581;
  float _5582;
  float _5583;
  float _5595;
  float _5596;
  float _5597;
  float _5616;
  float _5698;
  float _5716;
  float _5717;
  float _5718;
  float _5732;
  float _5733;
  float _5734;
  bool _5764;
  int _5765;
  int _5766;
  int _5767;
  int _5768;
  int _5769;
  bool _5778;
  int _5779;
  int _5780;
  int _5781;
  int _5782;
  int _5783;
  if (!((uint)_110 > (uint)11) | !((((uint)_110 < (uint)20)) || ((_110 == 107)))) {
    _205 = (_110 == 20);
  } else {
    _205 = true;
  }
  float4 _207 = __3__38__0__1__g_raytracingHitResultUAV.Load(int2(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5))))));
  float _213 = rsqrt(dot(float3(_207.x, _207.y, _207.z), float3(_207.x, _207.y, _207.z)));
  float _214 = _213 * _207.x;
  float _215 = _213 * _207.y;
  float _216 = _213 * _207.z;
  bool _217 = (_207.w < 0.0f);
  float _218 = abs(_207.w);
  if (((_218 > 0.0f)) && ((_218 < 10000.0f))) {
    float4 _224 = __3__36__0__0__g_raytracingBaseColor.Load(int3(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))), 0));
    float4 _230 = __3__36__0__0__g_raytracingNormal.Load(int3(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))), 0));
    float _238 = (_230.x * 2.0f) + -1.0f;
    float _239 = (_230.y * 2.0f) + -1.0f;
    float _240 = (_230.z * 2.0f) + -1.0f;
    float _242 = rsqrt(dot(float3(_238, _239, _240), float3(_238, _239, _240)));
    float _243 = _238 * _242;
    float _244 = _239 * _242;
    float _245 = _240 * _242;
    float _246 = select(_217, 0.0f, _243);
    float _247 = select(_217, 0.0f, _244);
    float _248 = select(_217, 0.0f, _245);
    int _250 = (int)(uint)((int)(_224.w > 0.0f));
    float _251 = _214 * _218;
    float _252 = _215 * _218;
    float _253 = _216 * _218;
    float _254 = _251 + _173;
    float _255 = _252 + _174;
    float _256 = _253 + _175;
    _258 = 0;
    while(true) {
      int _298 = int(floor(((_wrappedViewPos.x + _254) * ((_clipmapOffsets[_258]).w)) + ((_clipmapRelativeIndexOffsets[_258]).x)));
      int _299 = int(floor(((_wrappedViewPos.y + _255) * ((_clipmapOffsets[_258]).w)) + ((_clipmapRelativeIndexOffsets[_258]).y)));
      int _300 = int(floor(((_wrappedViewPos.z + _256) * ((_clipmapOffsets[_258]).w)) + ((_clipmapRelativeIndexOffsets[_258]).z)));
      if (!((((((((int)_298 >= (int)int(((_clipmapOffsets[_258]).x) + -63.0f))) && (((int)_298 < (int)int(((_clipmapOffsets[_258]).x) + 63.0f))))) && (((((int)_299 >= (int)int(((_clipmapOffsets[_258]).y) + -31.0f))) && (((int)_299 < (int)int(((_clipmapOffsets[_258]).y) + 31.0f))))))) && (((((int)_300 >= (int)int(((_clipmapOffsets[_258]).z) + -63.0f))) && (((int)_300 < (int)int(((_clipmapOffsets[_258]).z) + 63.0f))))))) {
        if ((uint)(_258 + 1) < (uint)8) {
          _258 = (_258 + 1);
          continue;
        } else {
          _316 = -10000;
        }
      } else {
        _316 = _258;
      }
      float _323 = -0.0f - _214;
      float _324 = -0.0f - _215;
      float _325 = -0.0f - _216;
      float _329 = min(_218, (float((int)((int)(1u << (_316 & 31)))) * _voxelParams.x));
      _337 = 0;
      while(true) {
        int _377 = int(floor(((((_329 * select(_217, _323, _243)) + _254) + _wrappedViewPos.x) * ((_clipmapOffsets[_337]).w)) + ((_clipmapRelativeIndexOffsets[_337]).x)));
        int _378 = int(floor(((((_329 * select(_217, _324, _244)) + _255) + _wrappedViewPos.y) * ((_clipmapOffsets[_337]).w)) + ((_clipmapRelativeIndexOffsets[_337]).y)));
        int _379 = int(floor(((((_329 * select(_217, _325, _245)) + _256) + _wrappedViewPos.z) * ((_clipmapOffsets[_337]).w)) + ((_clipmapRelativeIndexOffsets[_337]).z)));
        if ((((((((int)_377 >= (int)int(((_clipmapOffsets[_337]).x) + -63.0f))) && (((int)_377 < (int)int(((_clipmapOffsets[_337]).x) + 63.0f))))) && (((((int)_378 >= (int)int(((_clipmapOffsets[_337]).y) + -31.0f))) && (((int)_378 < (int)int(((_clipmapOffsets[_337]).y) + 31.0f))))))) && (((((int)_379 >= (int)int(((_clipmapOffsets[_337]).z) + -63.0f))) && (((int)_379 < (int)int(((_clipmapOffsets[_337]).z) + 63.0f)))))) {
          _400 = (_377 & 127);
          _401 = (_378 & 63);
          _402 = (_379 & 127);
          _403 = _337;
        } else {
          if ((uint)(_337 + 1) < (uint)8) {
            _337 = (_337 + 1);
            continue;
          } else {
            _400 = -10000;
            _401 = -10000;
            _402 = -10000;
            _403 = -10000;
          }
        }
        if (((_403 != -10000)) && (((int)_403 < (int)4))) {
          if ((uint)_403 < (uint)6) {
            uint _410 = _403 * 130;
            uint _414 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_400, _401, ((int)(((uint)((int)(_410) | 1)) + (uint)(_402))), 0));
            int _416 = _414.x & 4194303;
            [branch]
            if (!(_416 == 0)) {
              float _422 = float((int)((int)(1u << (_403 & 31)))) * _voxelParams.x;
              _460 = 0.0f;
              _461 = 0.0f;
              _462 = 0.0f;
              _463 = _246;
              _464 = _247;
              _465 = _248;
              _466 = 0.0f;
              _467 = 0;
              while(true) {
                int _472 = __3__37__0__0__g_surfelDataBuffer[((_416 + -1) + _467)]._baseColor;
                int _474 = __3__37__0__0__g_surfelDataBuffer[((_416 + -1) + _467)]._normal;
                int16_t _477 = __3__37__0__0__g_surfelDataBuffer[((_416 + -1) + _467)]._radius;
                if (!(_472 == 0)) {
                  half _480 = __3__37__0__0__g_surfelDataBuffer[((_416 + -1) + _467)]._radiance.z;
                  half _481 = __3__37__0__0__g_surfelDataBuffer[((_416 + -1) + _467)]._radiance.y;
                  half _482 = __3__37__0__0__g_surfelDataBuffer[((_416 + -1) + _467)]._radiance.x;
                  float _488 = float((uint)((uint)(_472 & 255)));
                  float _489 = float((uint)((uint)(((uint)((uint)(_472)) >> 8) & 255)));
                  float _490 = float((uint)((uint)(((uint)((uint)(_472)) >> 16) & 255)));
                  float _515 = select(((_488 * 0.003921568859368563f) < 0.040449999272823334f), (_488 * 0.0003035269910469651f), exp2(log2((_488 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _516 = select(((_489 * 0.003921568859368563f) < 0.040449999272823334f), (_489 * 0.0003035269910469651f), exp2(log2((_489 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _517 = select(((_490 * 0.003921568859368563f) < 0.040449999272823334f), (_490 * 0.0003035269910469651f), exp2(log2((_490 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                  float _529 = (float((uint)((uint)(_474 & 255))) * 0.007874015718698502f) + -1.0f;
                  float _530 = (float((uint)((uint)(((uint)((uint)(_474)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                  float _531 = (float((uint)((uint)(((uint)((uint)(_474)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                  float _533 = rsqrt(dot(float3(_529, _530, _531), float3(_529, _530, _531)));
                  bool _538 = ((_474 & 16777215) == 0);
                  float _542 = float(_482);
                  float _543 = float(_481);
                  float _544 = float(_480);
                  float _548 = (_422 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_477) & 255)));
                  float _564 = (((float((uint)((uint)((uint)((uint)(_472)) >> 24))) * 0.003937007859349251f) + -0.5f) * _422) + ((((((_clipmapOffsets[_403]).x) + -63.5f) + float((int)(((int)(((uint)(_400 + 64)) - (uint)(int((_clipmapOffsets[_403]).x)))) & 127))) * _422) - _viewPos.x);
                  float _565 = (((float((uint)((uint)((uint)((uint)(_474)) >> 24))) * 0.003937007859349251f) + -0.5f) * _422) + ((((((_clipmapOffsets[_403]).y) + -31.5f) + float((int)(((int)(((uint)(_401 + 32)) - (uint)(int((_clipmapOffsets[_403]).y)))) & 63))) * _422) - _viewPos.y);
                  float _566 = (((float((uint16_t)((uint)((uint16_t)((uint)(_477)) >> 8))) * 0.003937007859349251f) + -0.5f) * _422) + ((((((_clipmapOffsets[_403]).z) + -63.5f) + float((int)(((int)(((uint)(_402 + 64)) - (uint)(int((_clipmapOffsets[_403]).z)))) & 127))) * _422) - _viewPos.z);
                  bool _584 = (_230.w == 0.0f);
                  float _585 = select(_584, _323, _463);
                  float _586 = select(_584, _324, _464);
                  float _587 = select(_584, _325, _465);
                  float _590 = ((-0.0f - _173) - _251) + _564;
                  float _593 = ((-0.0f - _174) - _252) + _565;
                  float _596 = ((-0.0f - _175) - _253) + _566;
                  float _597 = dot(float3(_590, _593, _596), float3(_585, _586, _587));
                  float _601 = _590 - (_597 * _585);
                  float _602 = _593 - (_597 * _586);
                  float _603 = _596 - (_597 * _587);
                  float _629 = 1.0f / float((uint)(1u << (_403 & 31)));
                  float _633 = frac(((_invClipmapExtent.z * _566) + _clipmapUVRelativeOffset.z) * _629);
                  float _644 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _564) + _clipmapUVRelativeOffset.x) * _629), (((_invClipmapExtent.y * _565) + _clipmapUVRelativeOffset.y) * _629), (((float((uint)_410) + 1.0f) + ((select((_633 < 0.0f), 1.0f, 0.0f) + _633) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                  float _658 = select(((int)_403 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_323, _324, _325), float3(select(_538, _323, (_533 * _529)), select(_538, _324, (_533 * _530)), select(_538, _325, (_533 * _531))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_601, _602, _603), float3(_601, _602, _603)) < ((_548 * _548) * 16.0f)))) * float((bool)(uint)(_644.x > ((_422 * 0.25f) * (saturate((dot(float3(_542, _543, _544), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                  bool _662 = ((!(_224.w > 0.0f))) || (((_472 & 16777215) == 16777215));
                  float _672 = ((select(_662, (((_516 * 0.3395099937915802f) + (_515 * 0.6131200194358826f)) + (_517 * 0.047370001673698425f)), _224.x) * _542) * _658) + _460;
                  float _673 = ((select(_662, (((_516 * 0.9163600206375122f) + (_515 * 0.07020000368356705f)) + (_517 * 0.013450000435113907f)), _224.y) * _543) * _658) + _461;
                  float _674 = ((select(_662, (((_516 * 0.10958000272512436f) + (_515 * 0.02061999961733818f)) + (_517 * 0.8697999715805054f)), _224.z) * _544) * _658) + _462;
                  float _675 = _658 + _466;
                  if ((uint)(_467 + 1) < (uint)(RT_QUALITY > 0.5f ? 8 : 4)) {
                    _460 = _672;
                    _461 = _673;
                    _462 = _674;
                    _463 = _585;
                    _464 = _586;
                    _465 = _587;
                    _466 = _675;
                    _467 = (_467 + 1);
                    continue;
                  } else {
                    _679 = _672;
                    _680 = _673;
                    _681 = _674;
                    _682 = _675;
                  }
                } else {
                  _679 = _460;
                  _680 = _461;
                  _681 = _462;
                  _682 = _466;
                }
                if (_682 > 0.0f) {
                  float _685 = 1.0f / _682;
                  _699 = (-0.0f - min(0.0f, (-0.0f - (_679 * _685))));
                  _700 = (-0.0f - min(0.0f, (-0.0f - (_680 * _685))));
                  _701 = (-0.0f - min(0.0f, (-0.0f - (_681 * _685))));
                } else {
                  _699 = _679;
                  _700 = _680;
                  _701 = _681;
                }
                break;
              }
            } else {
              _699 = 0.0f;
              _700 = 0.0f;
              _701 = 0.0f;
            }
          } else {
            _699 = 0.0f;
            _700 = 0.0f;
            _701 = 0.0f;
          }
          float _705 = max(9.999999974752427e-07f, (_exposure3.w * 0.0010000000474974513f));
          float _706 = max(_705, _699);
          float _707 = max(_705, _700);
          float _708 = max(_705, _701);
          float _711 = dot(float3(_706, _707, _708), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
          float _712 = min((max(0.0005000000237487257f, _exposure3.w) * 512.0f), _711);
          float _716 = max(9.999999717180685e-10f, _711);
          float _717 = (_712 * _706) / _716;
          float _718 = (_712 * _707) / _716;
          float _719 = (_712 * _708) / _716;
          if (saturate(_230.w) == 0.0f) {
            float _733 = (exp2((saturate(saturate(_224.w)) * 20.0f) + -8.0f) + -0.00390625f) * (1.0f / (((_218 * _218) * 0.10000000149011612f) + 1.0f));
            _741 = ((_733 * _224.x) + _717);
            _742 = ((_733 * _224.y) + _718);
            _743 = ((_733 * _224.z) + _719);
          } else {
            _741 = _717;
            _742 = _718;
            _743 = _719;
          }
          _750 = _246;
          _751 = _247;
          _752 = _248;
          _753 = _230.w;
          _754 = _224.x;
          _755 = _224.y;
          _756 = _224.z;
          _757 = _224.w;
          _758 = _250;
          _759 = (_renderParams2.y * _741);
          _760 = (_renderParams2.y * _742);
          _761 = (_renderParams2.y * _743);
          _762 = 1.0f;
          _763 = _218;
        } else {
          _750 = _246;
          _751 = _247;
          _752 = _248;
          _753 = _230.w;
          _754 = _224.x;
          _755 = _224.y;
          _756 = _224.z;
          _757 = _224.w;
          _758 = _250;
          _759 = 0.0f;
          _760 = 0.0f;
          _761 = 0.0f;
          _762 = 1.0f;
          _763 = _218;
        }
        break;
      }
      break;
    }
  } else {
    _750 = 0.0f;
    _751 = 0.0f;
    _752 = 0.0f;
    _753 = 0.0f;
    _754 = 0.0f;
    _755 = 0.0f;
    _756 = 0.0f;
    _757 = 0.0f;
    _758 = 0;
    _759 = 0.0f;
    _760 = 0.0f;
    _761 = 0.0f;
    _762 = 0.0f;
    _763 = 0.0f;
  }
  bool _765 = (_763 > 0.0f);
  if (((_178 > (_lightingParams.z * 0.875f))) && ((!_765))) {
    _778 = (_178 < (_voxelParams.x * 11585.1259765625f));
  } else {
    _778 = false;
  }
  float _782 = (_763 * _214) + _173;
  float _783 = (_763 * _215) + _174;
  float _784 = (_763 * _216) + _175;
  float _820 = mad((_viewProjRelativePrev[3].z), _784, mad((_viewProjRelativePrev[3].y), _783, ((_viewProjRelativePrev[3].x) * _782))) + (_viewProjRelativePrev[3].w);
  float _823 = (mad((_viewProjRelativePrev[2].z), _784, mad((_viewProjRelativePrev[2].y), _783, ((_viewProjRelativePrev[2].x) * _782))) + (_viewProjRelativePrev[2].w)) / _820;
  float _826 = (((mad((_viewProjRelativePrev[0].z), _784, mad((_viewProjRelativePrev[0].y), _783, ((_viewProjRelativePrev[0].x) * _782))) + (_viewProjRelativePrev[0].w)) / _820) * 0.5f) + 0.5f;
  float _827 = 0.5f - (((mad((_viewProjRelativePrev[1].z), _784, mad((_viewProjRelativePrev[1].y), _783, ((_viewProjRelativePrev[1].x) * _782))) + (_viewProjRelativePrev[1].w)) / _820) * 0.5f);
  bool __defer_777_840 = false;
  if (_217) {
    if (_765) {
      __defer_777_840 = true;
    } else {
      _963 = _763;
      _964 = _750;
      _965 = _751;
      _966 = _752;
      _967 = _753;
      _968 = 0.0f;
      _969 = 0.0f;
      _970 = 0.0f;
      _971 = 0.0f;
      _972 = 0;
    }
  } else {
    if ((_765) && ((((_823 > 0.0f)) && ((((((_826 >= 0.0f)) && ((_826 <= 1.0f)))) && ((((_827 >= 0.0f)) && ((_827 <= 1.0f))))))))) {
      __defer_777_840 = true;
    } else {
      _963 = _763;
      _964 = _750;
      _965 = _751;
      _966 = _752;
      _967 = _753;
      _968 = 0.0f;
      _969 = 0.0f;
      _970 = 0.0f;
      _971 = 0.0f;
      _972 = 0;
    }
  }
  if (__defer_777_840) {
    float _843 = _826 * _bufferSizeAndInvSize.x;
    float _844 = _827 * _bufferSizeAndInvSize.y;
    uint _848 = __3__36__0__0__g_depthOpaquePrev.Load(int3(int(_843), int(_844), 0));
    float _854 = _nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_848.x & 16777215))) * 5.960465188081798e-08f));
    if (((_823 > 0.0f)) && ((((((_826 >= 0.0f)) && ((_826 <= 1.0f)))) && ((((_827 >= 0.0f)) && ((_827 <= 1.0f))))))) {
      if ((((_854 - dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z))) > 0.0f)) && ((abs(_854 - _820) < max(0.5f, (_820 * 0.05000000074505806f))))) {
        float4 _885 = __3__36__0__0__g_sceneColor.SampleLevel(__3__40__0__0__g_samplerClamp, float2(_826, _827), 0.0f);
        if (!(!(_885.w >= 0.0f))) {
          uint _896 = uint(_843);
          uint _897 = uint(_844);
          uint _898 = __3__36__0__0__g_depthOpaque.Load(int3((int)(_896), (int)(_897), 0));
          uint _900 = __3__36__0__0__g_sceneNormal.Load(int3((int)(_896), (int)(_897), 0));
          float _916 = min(1.0f, ((float((uint)((uint)(_900.x & 1023))) * 0.001956947147846222f) + -1.0f));
          float _917 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_900.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _918 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_900.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
          float _920 = rsqrt(dot(float3(_916, _917, _918), float3(_916, _917, _918)));
          float _921 = _920 * _916;
          float _922 = _920 * _917;
          float _923 = _920 * _918;
          float _932 = select((dot(float3((-0.0f - _214), (-0.0f - _215), (-0.0f - _216)), float3(_921, _922, _923)) > 0.20000000298023224f), 1.0f, 0.0f);
          float _934 = saturate(_178 * 0.009999999776482582f);
          float _939 = _nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_898.x & 16777215))) * 5.960465188081798e-08f));
          if (_217) {
            _949 = _921;
            _950 = _922;
            _951 = _923;
            _952 = 0.800000011920929f;
          } else {
            _949 = _750;
            _950 = _751;
            _951 = _752;
            _952 = _753;
          }
          float _953 = _renderParams2.x * _renderParams2.x;
          float _954 = float((bool)(uint)(abs(_nearFarProj.x - _939) < (_939 * 0.5f))) * ((_932 - (_932 * _934)) + _934);
          _963 = ((_763 * 0.9998999834060669f) * _renderParams2.x);
          _964 = _949;
          _965 = _950;
          _966 = _951;
          _967 = _952;
          _968 = ((_954 * min(10000.0f, _885.x)) * _953);
          _969 = ((_954 * min(10000.0f, _885.y)) * _953);
          _970 = ((_954 * min(10000.0f, _885.z)) * _953);
          _971 = _953;
          _972 = 1;
        } else {
          _963 = _763;
          _964 = _750;
          _965 = _751;
          _966 = _752;
          _967 = _753;
          _968 = 0.0f;
          _969 = 0.0f;
          _970 = 0.0f;
          _971 = 0.0f;
          _972 = 0;
        }
      } else {
        _963 = _763;
        _964 = _750;
        _965 = _751;
        _966 = _752;
        _967 = _753;
        _968 = 0.0f;
        _969 = 0.0f;
        _970 = 0.0f;
        _971 = 0.0f;
        _972 = 0;
      }
    } else {
      _963 = _763;
      _964 = _750;
      _965 = _751;
      _966 = _752;
      _967 = _753;
      _968 = 0.0f;
      _969 = 0.0f;
      _970 = 0.0f;
      _971 = 0.0f;
      _972 = 0;
    }
  }
  _974 = 0;
  while(true) {
    int _1014 = int(floor(((_wrappedViewPos.x + _173) * ((_clipmapOffsets[_974]).w)) + ((_clipmapRelativeIndexOffsets[_974]).x)));
    int _1015 = int(floor(((_wrappedViewPos.y + _174) * ((_clipmapOffsets[_974]).w)) + ((_clipmapRelativeIndexOffsets[_974]).y)));
    int _1016 = int(floor(((_wrappedViewPos.z + _175) * ((_clipmapOffsets[_974]).w)) + ((_clipmapRelativeIndexOffsets[_974]).z)));
    if ((((((((int)_1014 >= (int)int(((_clipmapOffsets[_974]).x) + -63.0f))) && (((int)_1014 < (int)int(((_clipmapOffsets[_974]).x) + 63.0f))))) && (((((int)_1015 >= (int)int(((_clipmapOffsets[_974]).y) + -31.0f))) && (((int)_1015 < (int)int(((_clipmapOffsets[_974]).y) + 31.0f))))))) && (((((int)_1016 >= (int)int(((_clipmapOffsets[_974]).z) + -63.0f))) && (((int)_1016 < (int)int(((_clipmapOffsets[_974]).z) + 63.0f)))))) {
      _1035 = (_1014 & 127);
      _1036 = _974;
    } else {
      if ((uint)(_974 + 1) < (uint)8) {
        _974 = (_974 + 1);
        continue;
      } else {
        _1035 = -10000;
        _1036 = -10000;
      }
    }
    if (!(_1035 == -10000)) {
      _1043 = float((int)((int)(1u << (_1036 & 31))));
    } else {
      _1043 = 1.0f;
    }
    float _1049 = select(_205, (((frac(frac(dot(float2(((_188 * 32.665000915527344f) + _81), ((_188 * 11.8149995803833f) + _82)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 2.0f) * _1043) * _voxelParams.x), 0.0f);
    if (_778) {
      float _1051 = _lightingParams.z * 1.3434898853302002f;
      float _1052 = -0.0f - _1051;
      if (((((_175 > _1052)) && ((_175 < _1051)))) && ((((((_173 > _1052)) && ((_173 < _1051)))) && ((((_174 > _1052)) && ((_174 < _1051))))))) {
        float _1065 = 1.0f / _214;
        float _1066 = 1.0f / _215;
        float _1067 = 1.0f / _216;
        float _1071 = _1065 * (_1052 - _173);
        float _1072 = _1066 * (_1052 - _174);
        float _1073 = _1067 * (_1052 - _175);
        float _1077 = _1065 * (_1051 - _173);
        float _1078 = _1066 * (_1051 - _174);
        float _1079 = _1067 * (_1051 - _175);
        float _1089 = min(min(max(_1071, _1077), max(_1072, _1078)), max(_1073, _1079));
        if (((_1089 > 0.0f)) && ((((_1089 >= 0.0f)) && ((max(max(min(_1071, _1077), min(_1072, _1078)), min(_1073, _1079)) <= _1089))))) {
          _1103 = _1089;
          _1104 = ((_1089 * _214) + _173);
          _1105 = ((_1089 * _215) + _174);
          _1106 = ((_1089 * _216) + _175);
        } else {
          _1103 = 0.0f;
          _1104 = _173;
          _1105 = _174;
          _1106 = _175;
        }
      } else {
        _1103 = 0.0f;
        _1104 = _173;
        _1105 = _174;
        _1106 = _175;
      }
      float _1110 = select((((_963 > 0.0f)) && ((_971 >= 1.0f))), _963, 256.0f);
      _1112 = 0;
      while(true) {
        int _1152 = int(floor(((_wrappedViewPos.x + _1104) * ((_clipmapOffsets[_1112]).w)) + ((_clipmapRelativeIndexOffsets[_1112]).x)));
        int _1153 = int(floor(((_wrappedViewPos.y + _1105) * ((_clipmapOffsets[_1112]).w)) + ((_clipmapRelativeIndexOffsets[_1112]).y)));
        int _1154 = int(floor(((_wrappedViewPos.z + _1106) * ((_clipmapOffsets[_1112]).w)) + ((_clipmapRelativeIndexOffsets[_1112]).z)));
        if (!((((((((int)_1152 >= (int)int(((_clipmapOffsets[_1112]).x) + -63.0f))) && (((int)_1152 < (int)int(((_clipmapOffsets[_1112]).x) + 63.0f))))) && (((((int)_1153 >= (int)int(((_clipmapOffsets[_1112]).y) + -31.0f))) && (((int)_1153 < (int)int(((_clipmapOffsets[_1112]).y) + 31.0f))))))) && (((((int)_1154 >= (int)int(((_clipmapOffsets[_1112]).z) + -63.0f))) && (((int)_1154 < (int)int(((_clipmapOffsets[_1112]).z) + 63.0f))))))) {
          if ((uint)(_1112 + 1) < (uint)8) {
            _1112 = (_1112 + 1);
            continue;
          } else {
            _1170 = -10000;
          }
        } else {
          _1170 = _1112;
        }
        if (!(((_1170 == -10000)) || (((int)_1170 > (int)4)))) {
          float _1180 = _1104 + (_1049 * _214);
          float _1181 = _1105 + (_1049 * _215);
          float _1182 = _1106 + (_1049 * _216);
          bool _1186 = (_214 == 0.0f);
          bool _1187 = (_215 == 0.0f);
          bool _1188 = (_216 == 0.0f);
          float _1189 = select(_1186, 0.0f, (1.0f / _214));
          float _1190 = select(_1187, 0.0f, (1.0f / _215));
          float _1191 = select(_1188, 0.0f, (1.0f / _216));
          bool _1192 = (_214 > 0.0f);
          bool _1193 = (_215 > 0.0f);
          bool _1194 = (_216 > 0.0f);
          if (_1110 > 0.0f) {
            _1207 = 0;
            _1208 = 0.0f;
            _1209 = 0.0f;
            _1210 = _1182;
            _1211 = _1181;
            _1212 = _1180;
            while(true) {
              _1214 = 0;
              while(true) {
                float _1239 = ((_wrappedViewPos.x + _1212) * ((_clipmapOffsets[_1214]).w)) + ((_clipmapRelativeIndexOffsets[_1214]).x);
                float _1240 = ((_wrappedViewPos.y + _1211) * ((_clipmapOffsets[_1214]).w)) + ((_clipmapRelativeIndexOffsets[_1214]).y);
                float _1241 = ((_wrappedViewPos.z + _1210) * ((_clipmapOffsets[_1214]).w)) + ((_clipmapRelativeIndexOffsets[_1214]).z);
                bool __defer_1213_1256 = false;
                if (!(((_1241 >= (((_clipmapOffsets[_1214]).z) + -63.0f))) && ((((_1239 >= (((_clipmapOffsets[_1214]).x) + -63.0f))) && ((_1240 >= (((_clipmapOffsets[_1214]).y) + -31.0f)))))) || ((((_1241 >= (((_clipmapOffsets[_1214]).z) + -63.0f))) && ((((_1239 >= (((_clipmapOffsets[_1214]).x) + -63.0f))) && ((_1240 >= (((_clipmapOffsets[_1214]).y) + -31.0f)))))) && (!(((_1241 < (((_clipmapOffsets[_1214]).z) + 63.0f))) && ((((_1239 < (((_clipmapOffsets[_1214]).x) + 63.0f))) && ((_1240 < (((_clipmapOffsets[_1214]).y) + 31.0f))))))))) {
                  __defer_1213_1256 = true;
                } else {
                  if (_1214 == -10000) {
                    _1451 = _1209;
                    _1452 = _1210;
                    _1453 = _1211;
                    _1454 = _1212;
                    _1455 = _1208;
                    _1457 = _1451;
                    _1458 = _1452;
                    _1459 = _1453;
                    _1460 = _1454;
                    _1461 = _1455;
                    _1462 = -10000.0f;
                  } else {
                    float _1264 = float((int)((int)(1u << (_1214 & 31))));
                    float _1265 = _1264 * _voxelParams.x;
                    float _1266 = 1.0f / _1264;
                    float _1267 = _voxelParams.y * 0.0078125f;
                    float _1276 = _1266 * ((_1212 * _1267) + _clipmapUVRelativeOffset.x);
                    float _1277 = _1266 * (((_voxelParams.y * 0.015625f) * _1211) + _clipmapUVRelativeOffset.y);
                    float _1278 = _1266 * ((_1210 * _1267) + _clipmapUVRelativeOffset.z);
                    float _1279 = _1276 * 64.0f;
                    float _1280 = _1277 * 32.0f;
                    float _1281 = _1278 * 64.0f;
                    int _1285 = int(floor(_1279));
                    int _1286 = int(floor(_1280));
                    int _1287 = int(floor(_1281));
                    uint4 _1294 = __3__36__0__0__g_axisAlignedDistanceTextures.Load(int4((_1285 & 63), (_1286 & 31), ((_1287 & 63) | (_1214 << 6)), 0));
                    float _1311 = saturate(float((uint)((uint)((uint)((uint)(_1294.w)) >> 2))) * 0.01587301678955555f);
                    float _1334 = _1279 - float((int)(_1285));
                    float _1335 = _1280 - float((int)(_1286));
                    float _1336 = _1281 - float((int)(_1287));
                    float _1367 = max(((_1265 * 0.5f) * min(min(select(_1186, 999999.0f, ((select(_1192, 1.0f, 0.0f) - frac(_1276 * 256.0f)) * _1189)), select(_1187, 999999.0f, ((select(_1193, 1.0f, 0.0f) - frac(_1277 * 128.0f)) * _1190))), select(_1188, 999999.0f, ((select(_1194, 1.0f, 0.0f) - frac(_1278 * 256.0f)) * _1191)))), ((_1265 * 2.0f) * min(min(select(_1186, 999999.0f, (select(_1192, ((0.009999999776482582f - _1334) + float((uint)((uint)(((uint)((uint)(_1294.x)) >> 4) & 15)))), ((0.9900000095367432f - _1334) - float((uint)((uint)(_1294.x & 15))))) * _1189)), select(_1187, 999999.0f, (select(_1193, ((0.009999999776482582f - _1335) + float((uint)((uint)(((uint)((uint)(_1294.y)) >> 4) & 15)))), ((0.9900000095367432f - _1335) - float((uint)((uint)(_1294.y & 15))))) * _1190))), select(_1188, 999999.0f, (select(_1194, ((0.009999999776482582f - _1336) + float((uint)((uint)(((uint)((uint)(_1294.z)) >> 4) & 15)))), ((0.9900000095367432f - _1336) - float((uint)((uint)(_1294.z & 15))))) * _1191)))));
                    float _1369 = float((bool)(uint)(_1311 > 0.0f));
                    if ((((uint)_1207 < (uint)16)) || ((_1209 < min(32.0f, (_1265 * 32.0f))))) {
                      float _1376 = frac(_1278);
                      float _1388 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_1276, _1277, (((float((uint)(_1214 * 130)) + 1.0f) + ((select((_1376 < 0.0f), 1.0f, 0.0f) + _1376) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                      float _1394 = _1209 * 0.009999999776482582f;
                      float _1395 = 1.0f / _1265;
                      float _1411 = (_1388.x + ((_178 * _178) * 0.00019999999494757503f)) / (((max(((_1265 * 1.0606600046157837f) * saturate((_1209 * 0.5f) + 0.5f)), _1394) - _1394) * saturate(((max(1.0f, (_1395 * 0.5f)) * _1395) * min(_1209, max(0.0f, (_1110 - _1209)))) + -1.0f)) + _1394);
                      float _1417 = saturate((saturate(1.0f - (_1411 * _1411)) * _1369) + _1208);
                      if (!((((int)_1214 > (int)2)) || ((_1388.x > _1265)))) {
                        _1431 = _1417;
                        _1432 = min(_1367, _1388.x);
                      } else {
                        _1431 = _1417;
                        _1432 = _1367;
                      }
                    } else {
                      if (!((_1294.w & 1) == 0)) {
                        _1431 = saturate((_1369 * 0.5f) + _1208);
                        _1432 = _1367;
                      } else {
                        _1431 = _1208;
                        _1432 = _1367;
                      }
                    }
                    if (!(_1431 >= 0.5f)) {
                      float _1437 = max(_1432, (_voxelParams.x * 0.05000000074505806f));
                      float _1438 = _1437 + _1209;
                      float _1442 = (_1437 * _214) + _1212;
                      float _1443 = (_1437 * _215) + _1211;
                      float _1444 = (_1437 * _216) + _1210;
                      if ((((uint)(_1207 + 1) < (uint)192)) && ((_1438 < _1110))) {
                        _1207 = (_1207 + 1);
                        _1208 = _1431;
                        _1209 = _1438;
                        _1210 = _1444;
                        _1211 = _1443;
                        _1212 = _1442;
                        __loop_jump_target = 1206;
                        break;
                      } else {
                        _1451 = _1438;
                        _1452 = _1444;
                        _1453 = _1443;
                        _1454 = _1442;
                        _1455 = _1431;
                        _1457 = _1451;
                        _1458 = _1452;
                        _1459 = _1453;
                        _1460 = _1454;
                        _1461 = _1455;
                        _1462 = -10000.0f;
                      }
                    } else {
                      _1457 = _1209;
                      _1458 = _1210;
                      _1459 = _1211;
                      _1460 = _1212;
                      _1461 = _1311;
                      _1462 = float((int)(_1214));
                    }
                  }
                }
                if (__defer_1213_1256) {
                  if ((int)(_1214 + 1) < (int)8) {
                    _1214 = (_1214 + 1);
                    continue;
                  } else {
                    _1457 = _1209;
                    _1458 = _1210;
                    _1459 = _1211;
                    _1460 = _1212;
                    _1461 = _1208;
                    _1462 = -10000.0f;
                  }
                }
                break;
              }
              if (__loop_jump_target == 1206) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
              break;
            }
          } else {
            _1457 = 0.0f;
            _1458 = _1182;
            _1459 = _1181;
            _1460 = _1180;
            _1461 = 0.0f;
            _1462 = -10000.0f;
          }
          int _1463 = int(_1462);
          if ((uint)_1463 < (uint)8) {
            float _1466 = _voxelParams.x * 0.5f;
            float _1470 = _1460 - (_1466 * _214);
            float _1471 = _1459 - (_1466 * _215);
            float _1472 = _1458 - (_1466 * _216);
            if ((int)_1463 < (int)6) {
              _1479 = 0;
              while(true) {
                int _1519 = int(floor(((_wrappedViewPos.x + _1470) * ((_clipmapOffsets[_1479]).w)) + ((_clipmapRelativeIndexOffsets[_1479]).x)));
                int _1520 = int(floor(((_wrappedViewPos.y + _1471) * ((_clipmapOffsets[_1479]).w)) + ((_clipmapRelativeIndexOffsets[_1479]).y)));
                int _1521 = int(floor(((_wrappedViewPos.z + _1472) * ((_clipmapOffsets[_1479]).w)) + ((_clipmapRelativeIndexOffsets[_1479]).z)));
                if ((((((((int)_1519 >= (int)int(((_clipmapOffsets[_1479]).x) + -63.0f))) && (((int)_1519 < (int)int(((_clipmapOffsets[_1479]).x) + 63.0f))))) && (((((int)_1520 >= (int)int(((_clipmapOffsets[_1479]).y) + -31.0f))) && (((int)_1520 < (int)int(((_clipmapOffsets[_1479]).y) + 31.0f))))))) && (((((int)_1521 >= (int)int(((_clipmapOffsets[_1479]).z) + -63.0f))) && (((int)_1521 < (int)int(((_clipmapOffsets[_1479]).z) + 63.0f)))))) {
                  _1542 = (_1519 & 127);
                  _1543 = (_1520 & 63);
                  _1544 = (_1521 & 127);
                  _1545 = _1479;
                } else {
                  if ((uint)(_1479 + 1) < (uint)8) {
                    _1479 = (_1479 + 1);
                    continue;
                  } else {
                    _1542 = -10000;
                    _1543 = -10000;
                    _1544 = -10000;
                    _1545 = -10000;
                  }
                }
                if (!((uint)_1545 > (uint)5)) {
                  uint _1555 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1542, _1543, ((int)(((uint)(((int)(_1545 * 130)) | 1)) + (uint)(_1544))), 0));
                  bool _1558 = ((_1555.x & 4194303) == 0);
                  [branch]
                  if (!_1558) {
                    _1561 = _1542;
                    _1562 = _1543;
                    _1563 = _1544;
                    _1564 = _1545;
                  } else {
                    _1561 = -10000;
                    _1562 = -10000;
                    _1563 = -10000;
                    _1564 = -10000;
                  }
                  float _1565 = _1466 * float((int)((int)(1u << (_1545 & 31))));
                  _1570 = 0;
                  while(true) {
                    int _1610 = int(floor((((_1470 - _1565) + _wrappedViewPos.x) * ((_clipmapOffsets[_1570]).w)) + ((_clipmapRelativeIndexOffsets[_1570]).x)));
                    int _1611 = int(floor((((_1471 - _1565) + _wrappedViewPos.y) * ((_clipmapOffsets[_1570]).w)) + ((_clipmapRelativeIndexOffsets[_1570]).y)));
                    int _1612 = int(floor((((_1472 - _1565) + _wrappedViewPos.z) * ((_clipmapOffsets[_1570]).w)) + ((_clipmapRelativeIndexOffsets[_1570]).z)));
                    if ((((((((int)_1610 >= (int)int(((_clipmapOffsets[_1570]).x) + -63.0f))) && (((int)_1610 < (int)int(((_clipmapOffsets[_1570]).x) + 63.0f))))) && (((((int)_1611 >= (int)int(((_clipmapOffsets[_1570]).y) + -31.0f))) && (((int)_1611 < (int)int(((_clipmapOffsets[_1570]).y) + 31.0f))))))) && (((((int)_1612 >= (int)int(((_clipmapOffsets[_1570]).z) + -63.0f))) && (((int)_1612 < (int)int(((_clipmapOffsets[_1570]).z) + 63.0f)))))) {
                      _1633 = (_1610 & 127);
                      _1634 = (_1611 & 63);
                      _1635 = (_1612 & 127);
                      _1636 = _1570;
                    } else {
                      if ((uint)(_1570 + 1) < (uint)8) {
                        _1570 = (_1570 + 1);
                        continue;
                      } else {
                        _1633 = -10000;
                        _1634 = -10000;
                        _1635 = -10000;
                        _1636 = -10000;
                      }
                    }
                    if (!((uint)_1636 > (uint)5)) {
                      if (_1558) {
                        _1641 = 0;
                        _1642 = _1564;
                        _1643 = _1563;
                        _1644 = _1562;
                        _1645 = _1561;
                        while(true) {
                          _1654 = 0;
                          _1655 = _1642;
                          _1656 = _1643;
                          _1657 = _1644;
                          _1658 = _1645;
                          while(true) {
                            if (!((((uint)(_1654 + _1634) > (uint)63)) || (((uint)(_1633 | (_1641 + _1635)) > (uint)127)))) {
                              uint _1676 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1633, (_1654 + _1634), ((int)(((uint)(_1641 + _1635)) + ((uint)(((int)(_1636 * 130)) | 1)))), 0));
                              int _1678 = _1676.x & 4194303;
                              _1681 = (_1678 != 0);
                              _1682 = _1678;
                              _1683 = _1636;
                              _1684 = (_1641 + _1635);
                              _1685 = (_1654 + _1634);
                              _1686 = _1633;
                            } else {
                              _1681 = false;
                              _1682 = 0;
                              _1683 = 0;
                              _1684 = 0;
                              _1685 = 0;
                              _1686 = 0;
                            }
                            if (!_1681) {
                              if (!((((uint)(_1654 + _1634) > (uint)63)) || (((uint)((_1633 + 1) | (_1641 + _1635)) > (uint)127)))) {
                                uint _5773 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((_1633 + 1), (_1654 + _1634), ((int)(((uint)(_1641 + _1635)) + ((uint)(((int)(_1636 * 130)) | 1)))), 0));
                                int _5775 = _5773.x & 4194303;
                                _5778 = (_5775 != 0);
                                _5779 = _5775;
                                _5780 = _1636;
                                _5781 = (_1641 + _1635);
                                _5782 = (_1654 + _1634);
                                _5783 = (_1633 + 1);
                              } else {
                                _5778 = false;
                                _5779 = 0;
                                _5780 = 0;
                                _5781 = 0;
                                _5782 = 0;
                                _5783 = 0;
                              }
                              if (!_5778) {
                                _1695 = _1658;
                                _1696 = _1657;
                                _1697 = _1656;
                                _1698 = _1655;
                                _1699 = 0;
                              } else {
                                _1695 = _5783;
                                _1696 = _5782;
                                _1697 = _5781;
                                _1698 = _5780;
                                _1699 = _5779;
                              }
                            } else {
                              _1695 = _1686;
                              _1696 = _1685;
                              _1697 = _1684;
                              _1698 = _1683;
                              _1699 = _1682;
                            }
                            if ((((int)(_1654 + 1) < (int)2)) && ((_1699 == 0))) {
                              _1654 = (_1654 + 1);
                              _1655 = _1698;
                              _1656 = _1697;
                              _1657 = _1696;
                              _1658 = _1695;
                              continue;
                            }
                            if ((((int)(_1641 + 1) < (int)2)) && ((_1699 == 0))) {
                              _1641 = (_1641 + 1);
                              _1642 = _1698;
                              _1643 = _1697;
                              _1644 = _1696;
                              _1645 = _1695;
                              __loop_jump_target = 1640;
                              break;
                            }
                            _1648 = _1698;
                            _1649 = _1697;
                            _1650 = _1696;
                            _1651 = _1695;
                            break;
                          }
                          if (__loop_jump_target == 1640) {
                            __loop_jump_target = -1;
                            continue;
                          }
                          if (__loop_jump_target != -1) {
                            break;
                          }
                          break;
                        }
                      } else {
                        _1648 = _1564;
                        _1649 = _1563;
                        _1650 = _1562;
                        _1651 = _1561;
                      }
                      if ((uint)_1648 < (uint)6) {
                        uint _1705 = _1648 * 130;
                        uint _1709 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_1651, _1650, ((int)(((uint)((int)(_1705) | 1)) + (uint)(_1649))), 0));
                        int _1711 = _1709.x & 4194303;
                        [branch]
                        if (!(_1711 == 0)) {
                          float _1717 = float((int)((int)(1u << (_1648 & 31)))) * _voxelParams.x;
                          float _1754 = -0.0f - _214;
                          float _1755 = -0.0f - _215;
                          float _1756 = -0.0f - _216;
                          _1758 = 0.0f;
                          _1759 = 0.0f;
                          _1760 = 0.0f;
                          _1761 = 0.0f;
                          _1762 = 0;
                          while(true) {
                            int _1767 = __3__37__0__0__g_surfelDataBuffer[((_1711 + -1) + _1762)]._baseColor;
                            int _1769 = __3__37__0__0__g_surfelDataBuffer[((_1711 + -1) + _1762)]._normal;
                            int16_t _1772 = __3__37__0__0__g_surfelDataBuffer[((_1711 + -1) + _1762)]._radius;
                            if (!(_1767 == 0)) {
                              half _1775 = __3__37__0__0__g_surfelDataBuffer[((_1711 + -1) + _1762)]._radiance.z;
                              half _1776 = __3__37__0__0__g_surfelDataBuffer[((_1711 + -1) + _1762)]._radiance.y;
                              half _1777 = __3__37__0__0__g_surfelDataBuffer[((_1711 + -1) + _1762)]._radiance.x;
                              float _1783 = float((uint)((uint)(_1767 & 255)));
                              float _1784 = float((uint)((uint)(((uint)((uint)(_1767)) >> 8) & 255)));
                              float _1785 = float((uint)((uint)(((uint)((uint)(_1767)) >> 16) & 255)));
                              float _1810 = select(((_1783 * 0.003921568859368563f) < 0.040449999272823334f), (_1783 * 0.0003035269910469651f), exp2(log2((_1783 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1811 = select(((_1784 * 0.003921568859368563f) < 0.040449999272823334f), (_1784 * 0.0003035269910469651f), exp2(log2((_1784 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1812 = select(((_1785 * 0.003921568859368563f) < 0.040449999272823334f), (_1785 * 0.0003035269910469651f), exp2(log2((_1785 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                              float _1824 = (float((uint)((uint)(_1769 & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1825 = (float((uint)((uint)(((uint)((uint)(_1769)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1826 = (float((uint)((uint)(((uint)((uint)(_1769)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                              float _1828 = rsqrt(dot(float3(_1824, _1825, _1826), float3(_1824, _1825, _1826)));
                              bool _1833 = ((_1769 & 16777215) == 0);
                              float _1837 = float(_1777);
                              float _1838 = float(_1776);
                              float _1839 = float(_1775);
                              float _1843 = (_1717 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_1772) & 255)));
                              float _1859 = (((float((uint)((uint)((uint)((uint)(_1767)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1717) + ((((((_clipmapOffsets[_1648]).x) + -63.5f) + float((int)(((int)(((uint)(_1651) + 64u) - (uint)(int((_clipmapOffsets[_1648]).x)))) & 127))) * _1717) - _viewPos.x);
                              float _1860 = (((float((uint)((uint)((uint)((uint)(_1769)) >> 24))) * 0.003937007859349251f) + -0.5f) * _1717) + ((((((_clipmapOffsets[_1648]).y) + -31.5f) + float((int)(((int)(((uint)(_1650) + 32u) - (uint)(int((_clipmapOffsets[_1648]).y)))) & 63))) * _1717) - _viewPos.y);
                              float _1861 = (((float((uint16_t)((uint)((uint16_t)((uint)(_1772)) >> 8))) * 0.003937007859349251f) + -0.5f) * _1717) + ((((((_clipmapOffsets[_1648]).z) + -63.5f) + float((int)(((int)(((uint)(_1649) + 64u) - (uint)(int((_clipmapOffsets[_1648]).z)))) & 127))) * _1717) - _viewPos.z);
                              float _1881 = ((-0.0f - _1104) - (_1457 * _214)) + _1859;
                              float _1884 = ((-0.0f - _1105) - (_1457 * _215)) + _1860;
                              float _1887 = ((-0.0f - _1106) - (_1457 * _216)) + _1861;
                              float _1888 = dot(float3(_1881, _1884, _1887), float3(_1754, _1755, _1756));
                              float _1892 = _1881 - (_1888 * _1754);
                              float _1893 = _1884 - (_1888 * _1755);
                              float _1894 = _1887 - (_1888 * _1756);
                              float _1920 = 1.0f / float((uint)(1u << (_1648 & 31)));
                              float _1924 = frac(((_invClipmapExtent.z * _1861) + _clipmapUVRelativeOffset.z) * _1920);
                              float _1935 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _1859) + _clipmapUVRelativeOffset.x) * _1920), (((_invClipmapExtent.y * _1860) + _clipmapUVRelativeOffset.y) * _1920), (((float((uint)_1705) + 1.0f) + ((select((_1924 < 0.0f), 1.0f, 0.0f) + _1924) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                              float _1949 = select(((int)_1648 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_1754, _1755, _1756), float3(select(_1833, _1754, (_1828 * _1824)), select(_1833, _1755, (_1828 * _1825)), select(_1833, _1756, (_1828 * _1826))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_1892, _1893, _1894), float3(_1892, _1893, _1894)) < ((_1843 * _1843) * 16.0f)))) * float((bool)(uint)(_1935.x > ((_1717 * 0.25f) * (saturate((dot(float3(_1837, _1838, _1839), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                              float _1956 = (((((_1811 * 0.3395099937915802f) + (_1810 * 0.6131200194358826f)) + (_1812 * 0.047370001673698425f)) * _1837) * _1949) + _1758;
                              float _1957 = (((((_1811 * 0.9163600206375122f) + (_1810 * 0.07020000368356705f)) + (_1812 * 0.013450000435113907f)) * _1838) * _1949) + _1759;
                              float _1958 = (((((_1811 * 0.10958000272512436f) + (_1810 * 0.02061999961733818f)) + (_1812 * 0.8697999715805054f)) * _1839) * _1949) + _1760;
                              float _1959 = _1949 + _1761;
                              if ((uint)(_1762 + 1) < (uint)(RT_QUALITY > 0.5f ? 8 : 4)) {
                                _1758 = _1956;
                                _1759 = _1957;
                                _1760 = _1958;
                                _1761 = _1959;
                                _1762 = (_1762 + 1);
                                continue;
                              } else {
                                _1963 = _1956;
                                _1964 = _1957;
                                _1965 = _1958;
                                _1966 = _1959;
                              }
                            } else {
                              _1963 = _1758;
                              _1964 = _1759;
                              _1965 = _1760;
                              _1966 = _1761;
                            }
                            if (_1966 > 0.0f) {
                              float _1969 = 1.0f / _1966;
                              _1983 = 1.0f;
                              _1984 = (-0.0f - min(0.0f, (-0.0f - (_1963 * _1969))));
                              _1985 = (-0.0f - min(0.0f, (-0.0f - (_1964 * _1969))));
                              _1986 = (-0.0f - min(0.0f, (-0.0f - (_1965 * _1969))));
                            } else {
                              _1983 = 0.0f;
                              _1984 = _1963;
                              _1985 = _1964;
                              _1986 = _1965;
                            }
                            break;
                          }
                        } else {
                          _1983 = 0.0f;
                          _1984 = 0.0f;
                          _1985 = 0.0f;
                          _1986 = 0.0f;
                        }
                      } else {
                        _1983 = 0.0f;
                        _1984 = 0.0f;
                        _1985 = 0.0f;
                        _1986 = 0.0f;
                      }
                    } else {
                      _1983 = 1.0f;
                      _1984 = 0.0f;
                      _1985 = 0.0f;
                      _1986 = 0.0f;
                    }
                    break;
                  }
                } else {
                  _1983 = 1.0f;
                  _1984 = 0.0f;
                  _1985 = 0.0f;
                  _1986 = 0.0f;
                }
                break;
              }
            } else {
              _1983 = 1.0f;
              _1984 = 0.0f;
              _1985 = 0.0f;
              _1986 = 0.0f;
            }
            float _1994 = saturate((_1457 * 0.25f) / (float((int)((int)(1u << (_1170 & 31)))) * _voxelParams.x)) * _1983;
            float _2004 = -0.0f - min(0.0f, (-0.0f - (_1984 * _1994)));
            float _2005 = -0.0f - min(0.0f, (-0.0f - (_1985 * _1994)));
            float _2006 = -0.0f - min(0.0f, (-0.0f - (_1986 * _1994)));
            float _2008 = select(((int)_1463 > (int)-1), 1.0f, 0.0f);
            float _2009 = max(9.999999974752427e-07f, _1457);
            if (_2009 > 0.0f) {
              _2014 = (_2009 + _1103);
              _2015 = _2004;
              _2016 = _2005;
              _2017 = _2006;
              _2018 = _2008;
            } else {
              _2014 = _2009;
              _2015 = _2004;
              _2016 = _2005;
              _2017 = _2006;
              _2018 = _2008;
            }
          } else {
            _2014 = 0.0f;
            _2015 = 0.0f;
            _2016 = 0.0f;
            _2017 = 0.0f;
            _2018 = _1461;
          }
        } else {
          _2014 = 0.0f;
          _2015 = 0.0f;
          _2016 = 0.0f;
          _2017 = 0.0f;
          _2018 = 0.0f;
        }
        break;
      }
    } else {
      _2014 = _763;
      _2015 = _759;
      _2016 = _760;
      _2017 = _761;
      _2018 = _762;
    }
    float _2021 = saturate(5.000000476837158f - (_178 * 0.01953125186264515f));
    bool _2022 = (_972 != 0);
    if (((_971 > 0.0f)) && ((((_963 > 0.0f)) && (_2022)))) {
      if (!(_963 < _2014)) {
        _2032 = (_2014 <= 0.0f);
      } else {
        _2032 = true;
      }
    } else {
      _2032 = false;
    }
    float _2036 = saturate(max(select(_2032, 1.0f, 0.0f), (1.0f - _2021)));
    float _2037 = _2036 * _971;
    float _2040 = min(_2021, saturate(1.0f - _2037));
    if (!(_2018 == 0.0f)) {
      _2055 = ((_2040 * _2015) + (_2036 * _968));
      _2056 = ((_2040 * _2016) + (_2036 * _969));
      _2057 = ((_2040 * _2017) + (_2036 * _970));
      _2058 = ((_2040 * _2018) + _2037);
    } else {
      _2055 = _968;
      _2056 = _969;
      _2057 = _970;
      _2058 = _971;
    }
    float _2061 = 1.0f / max(9.999999974752427e-07f, (_2040 + _2036));
    float _2065 = _2061 * ((_2040 * _2014) + (_2036 * _963));
    float _2067 = _2061 * _2036;
    float _2071 = (_2065 * _214) + _173;
    float _2072 = (_2065 * _215) + _174;
    float _2073 = (_2065 * _216) + _175;
    [branch]
    if (!(_2065 <= 0.0f)) {
      float _2103 = mad((_viewProjRelative[3].z), _2073, mad((_viewProjRelative[3].y), _2072, ((_viewProjRelative[3].x) * _2071))) + (_viewProjRelative[3].w);
      float _2108 = (((mad((_viewProjRelative[0].z), _2073, mad((_viewProjRelative[0].y), _2072, ((_viewProjRelative[0].x) * _2071))) + (_viewProjRelative[0].w)) / _2103) * 0.5f) + 0.5f;
      float _2109 = 0.5f - (((mad((_viewProjRelative[1].z), _2073, mad((_viewProjRelative[1].y), _2072, ((_viewProjRelative[1].x) * _2071))) + (_viewProjRelative[1].w)) / _2103) * 0.5f);
      if (((((_2108 >= 0.0f)) && ((_2108 <= 1.0f)))) && ((((_2109 >= 0.0f)) && ((_2109 <= 1.0f))))) {
        if ((_2022) && ((((mad((_viewProjRelative[2].z), _2073, mad((_viewProjRelative[2].y), _2072, ((_viewProjRelative[2].x) * _2071))) + (_viewProjRelative[2].w)) / _2103) > 0.0f))) {
          half4 _2132 = __3__36__0__0__g_sceneShadowColor.SampleLevel(__3__40__0__0__g_sampler, float2(_2108, _2109), 0.0f);
          _2140 = float(_2132.x);
          _2141 = float(_2132.y);
          _2142 = float(_2132.z);
        } else {
          _2140 = 1.0f;
          _2141 = 1.0f;
          _2142 = 1.0f;
        }
      } else {
        _2140 = 1.0f;
        _2141 = 1.0f;
        _2142 = 1.0f;
      }
      float _2149 = _viewPos.x + _2071;
      float _2150 = _viewPos.y + _2072;
      float _2151 = _viewPos.z + _2073;
      float _2156 = _2149 - (_staticShadowPosition[1].x);
      float _2157 = _2150 - (_staticShadowPosition[1].y);
      float _2158 = _2151 - (_staticShadowPosition[1].z);
      float _2178 = mad((_shadowProjRelativeTexScale[1][0].z), _2158, mad((_shadowProjRelativeTexScale[1][0].y), _2157, ((_shadowProjRelativeTexScale[1][0].x) * _2156))) + (_shadowProjRelativeTexScale[1][0].w);
      float _2182 = mad((_shadowProjRelativeTexScale[1][1].z), _2158, mad((_shadowProjRelativeTexScale[1][1].y), _2157, ((_shadowProjRelativeTexScale[1][1].x) * _2156))) + (_shadowProjRelativeTexScale[1][1].w);
      float _2189 = 2.0f / _shadowSizeAndInvSize.y;
      float _2190 = 1.0f - _2189;
      bool _2197 = ((((((!(_2178 <= _2190))) || ((!(_2178 >= _2189))))) || ((!(_2182 <= _2190))))) || ((!(_2182 >= _2189)));
      float _2206 = _2149 - (_staticShadowPosition[0].x);
      float _2207 = _2150 - (_staticShadowPosition[0].y);
      float _2208 = _2151 - (_staticShadowPosition[0].z);
      float _2228 = mad((_shadowProjRelativeTexScale[0][0].z), _2208, mad((_shadowProjRelativeTexScale[0][0].y), _2207, ((_shadowProjRelativeTexScale[0][0].x) * _2206))) + (_shadowProjRelativeTexScale[0][0].w);
      float _2232 = mad((_shadowProjRelativeTexScale[0][1].z), _2208, mad((_shadowProjRelativeTexScale[0][1].y), _2207, ((_shadowProjRelativeTexScale[0][1].x) * _2206))) + (_shadowProjRelativeTexScale[0][1].w);
      bool _2243 = ((((((!(_2228 <= _2190))) || ((!(_2228 >= _2189))))) || ((!(_2232 <= _2190))))) || ((!(_2232 >= _2189)));
      float _2244 = select(_2243, select(_2197, 0.0f, _2178), _2228);
      float _2245 = select(_2243, select(_2197, 0.0f, _2182), _2232);
      float _2246 = select(_2243, select(_2197, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _2158, mad((_shadowProjRelativeTexScale[1][2].y), _2157, ((_shadowProjRelativeTexScale[1][2].x) * _2156))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _2208, mad((_shadowProjRelativeTexScale[0][2].y), _2207, ((_shadowProjRelativeTexScale[0][2].x) * _2206))) + (_shadowProjRelativeTexScale[0][2].w)));
      int _2247 = select(_2243, select(_2197, -1, 1), 0);
      [branch]
      if (!(_2247 == -1)) {
        float _2253 = (_2244 * _shadowSizeAndInvSize.x) + -0.5f;
        float _2254 = (_2245 * _shadowSizeAndInvSize.y) + -0.5f;
        int _2257 = int(floor(_2253));
        int _2258 = int(floor(_2254));
        if (!((((uint)_2257 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_2258 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
          float4 _2268 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2257, _2258, _2247, 0));
          float4 _2270 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2257) + 1u)), _2258, _2247, 0));
          float4 _2272 = __3__36__0__0__g_shadowDepthArray.Load(int4(_2257, ((int)((uint)(_2258) + 1u)), _2247, 0));
          float4 _2274 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_2257) + 1u)), ((int)((uint)(_2258) + 1u)), _2247, 0));
          half4 _2279 = __3__36__0__0__g_shadowColorArray.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2244, _2245, float((uint)(uint)(_2247))), 0.0f);
          _2285 = _2268.x;
          _2286 = _2270.x;
          _2287 = _2272.x;
          _2288 = _2274.x;
          _2289 = _2279.x;
          _2290 = _2279.y;
          _2291 = _2279.z;
          _2292 = _2279.w;
        } else {
          _2285 = 0.0f;
          _2286 = 0.0f;
          _2287 = 0.0f;
          _2288 = 0.0f;
          _2289 = 1.0h;
          _2290 = 1.0h;
          _2291 = 1.0h;
          _2292 = 1.0h;
        }
        float _2318 = (float4(_invShadowViewProj[_2247][0][0], _invShadowViewProj[_2247][1][0], _invShadowViewProj[_2247][2][0], _invShadowViewProj[_2247][3][0]).x) * _2244;
        float _2322 = (float4(_invShadowViewProj[_2247][0][0], _invShadowViewProj[_2247][1][0], _invShadowViewProj[_2247][2][0], _invShadowViewProj[_2247][3][0]).y) * _2244;
        float _2326 = (float4(_invShadowViewProj[_2247][0][0], _invShadowViewProj[_2247][1][0], _invShadowViewProj[_2247][2][0], _invShadowViewProj[_2247][3][0]).z) * _2244;
        float _2330 = (float4(_invShadowViewProj[_2247][0][0], _invShadowViewProj[_2247][1][0], _invShadowViewProj[_2247][2][0], _invShadowViewProj[_2247][3][0]).w) * _2244;
        float _2333 = mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).w), _2285, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).w), _2245, _2330)) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).w);
        float _2334 = (mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).x), _2285, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).x), _2245, _2318)) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).x)) / _2333;
        float _2335 = (mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).y), _2285, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).y), _2245, _2322)) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).y)) / _2333;
        float _2336 = (mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).z), _2285, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).z), _2245, _2326)) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).z)) / _2333;
        float _2339 = _2244 + (_shadowSizeAndInvSize.z * 4.0f);
        float _2355 = mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).w), _2286, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).w), _2245, ((float4(_invShadowViewProj[_2247][0][0], _invShadowViewProj[_2247][1][0], _invShadowViewProj[_2247][2][0], _invShadowViewProj[_2247][3][0]).w) * _2339))) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).w);
        float _2361 = _2245 - (_shadowSizeAndInvSize.w * 2.0f);
        float _2373 = mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).w), _2287, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).w), _2361, _2330)) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).w);
        float _2377 = ((mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).x), _2287, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).x), _2361, _2318)) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).x)) / _2373) - _2334;
        float _2378 = ((mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).y), _2287, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).y), _2361, _2322)) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).y)) / _2373) - _2335;
        float _2379 = ((mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).z), _2287, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).z), _2361, _2326)) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).z)) / _2373) - _2336;
        float _2380 = ((mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).x), _2286, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).x), _2245, ((float4(_invShadowViewProj[_2247][0][0], _invShadowViewProj[_2247][1][0], _invShadowViewProj[_2247][2][0], _invShadowViewProj[_2247][3][0]).x) * _2339))) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).x)) / _2355) - _2334;
        float _2381 = ((mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).y), _2286, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).y), _2245, ((float4(_invShadowViewProj[_2247][0][0], _invShadowViewProj[_2247][1][0], _invShadowViewProj[_2247][2][0], _invShadowViewProj[_2247][3][0]).y) * _2339))) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).y)) / _2355) - _2335;
        float _2382 = ((mad((float4(_invShadowViewProj[_2247][0][2], _invShadowViewProj[_2247][1][2], _invShadowViewProj[_2247][2][2], _invShadowViewProj[_2247][3][2]).z), _2286, mad((float4(_invShadowViewProj[_2247][0][1], _invShadowViewProj[_2247][1][1], _invShadowViewProj[_2247][2][1], _invShadowViewProj[_2247][3][1]).z), _2245, ((float4(_invShadowViewProj[_2247][0][0], _invShadowViewProj[_2247][1][0], _invShadowViewProj[_2247][2][0], _invShadowViewProj[_2247][3][0]).z) * _2339))) + (float4(_invShadowViewProj[_2247][0][3], _invShadowViewProj[_2247][1][3], _invShadowViewProj[_2247][2][3], _invShadowViewProj[_2247][3][3]).z)) / _2355) - _2336;
        float _2385 = (_2379 * _2381) - (_2378 * _2382);
        float _2388 = (_2377 * _2382) - (_2379 * _2380);
        float _2391 = (_2378 * _2380) - (_2377 * _2381);
        float _2393 = rsqrt(dot(float3(_2385, _2388, _2391), float3(_2385, _2388, _2391)));
        float _2394 = _2385 * _2393;
        float _2395 = _2388 * _2393;
        float _2396 = _2391 * _2393;
        float _2397 = frac(_2253);
        float _2402 = (saturate(dot(float3(_214, _215, _216), float3(_2394, _2395, _2396))) * 0.0020000000949949026f) + _2246;
        float _2415 = saturate(exp2((_2285 - _2402) * 1442695.0f));
        float _2417 = saturate(exp2((_2287 - _2402) * 1442695.0f));
        float _2423 = ((saturate(exp2((_2286 - _2402) * 1442695.0f)) - _2415) * _2397) + _2415;
        _2430 = _2394;
        _2431 = _2395;
        _2432 = _2396;
        _2433 = saturate((((_2417 - _2423) + ((saturate(exp2((_2288 - _2402) * 1442695.0f)) - _2417) * _2397)) * frac(_2254)) + _2423);
        _2434 = _2285;
        _2435 = _2286;
        _2436 = _2287;
        _2437 = _2288;
        _2438 = _2289;
        _2439 = _2290;
        _2440 = _2291;
        _2441 = _2292;
      } else {
        _2430 = 0.0f;
        _2431 = 0.0f;
        _2432 = 0.0f;
        _2433 = 0.0f;
        _2434 = 0.0f;
        _2435 = 0.0f;
        _2436 = 0.0f;
        _2437 = 0.0f;
        _2438 = 0.0h;
        _2439 = 0.0h;
        _2440 = 0.0h;
        _2441 = 0.0h;
      }
      float _2461 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _2073, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _2072, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _2071))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
      float _2465 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _2073, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _2072, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _2071))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
      float _2469 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _2073, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _2072, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _2071))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
      float _2472 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
      float _2473 = 1.0f - _2472;
      if (!(((((!(_2461 <= _2473))) || ((!(_2461 >= _2472))))) || ((!(_2465 <= _2473))))) {
        bool _2484 = ((_2469 >= -1.0f)) && ((((_2469 <= 1.0f)) && ((_2465 >= _2472))));
        _2492 = select(_2484, 9.999999747378752e-06f, -9.999999747378752e-05f);
        _2493 = select(_2484, _2461, _2244);
        _2494 = select(_2484, _2465, _2245);
        _2495 = select(_2484, _2469, _2246);
        _2496 = select(_2484, 1, _2247);
        _2497 = ((int)(uint)((int)(_2484)));
      } else {
        _2492 = -9.999999747378752e-05f;
        _2493 = _2244;
        _2494 = _2245;
        _2495 = _2246;
        _2496 = _2247;
        _2497 = 0;
      }
      float _2517 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _2073, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _2072, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _2071))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
      float _2521 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _2073, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _2072, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _2071))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
      float _2525 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _2073, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _2072, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _2071))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
      if (!(((((!(_2517 <= _2473))) || ((!(_2517 >= _2472))))) || ((!(_2521 <= _2473))))) {
        bool _2536 = ((_2525 >= -1.0f)) && ((((_2521 >= _2472)) && ((_2525 <= 1.0f))));
        _2544 = select(_2536, 9.999999747378752e-06f, _2492);
        _2545 = select(_2536, _2517, _2493);
        _2546 = select(_2536, _2521, _2494);
        _2547 = select(_2536, _2525, _2495);
        _2548 = select(_2536, 0, _2496);
        _2549 = select(_2536, 1, _2497);
      } else {
        _2544 = _2492;
        _2545 = _2493;
        _2546 = _2494;
        _2547 = _2495;
        _2548 = _2496;
        _2549 = _2497;
      }
      [branch]
      if (!(_2549 == 0)) {
        int _2559 = int(floor((_2545 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
        int _2560 = int(floor((_2546 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
        if (!((((uint)_2559 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_2560 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
          float4 _2570 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2559, _2560, _2548, 0));
          float4 _2572 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2559) + 1u)), _2560, _2548, 0));
          float4 _2574 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_2559, ((int)((uint)(_2560) + 1u)), _2548, 0));
          float4 _2576 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_2559) + 1u)), ((int)((uint)(_2560) + 1u)), _2548, 0));
          _2579 = _2570.x;
          _2580 = _2572.x;
          _2581 = _2574.x;
          _2582 = _2576.x;
        } else {
          _2579 = _2434;
          _2580 = _2435;
          _2581 = _2436;
          _2582 = _2437;
        }
        float _2608 = (float4(_invDynamicShadowViewProj[_2548][0][0], _invDynamicShadowViewProj[_2548][1][0], _invDynamicShadowViewProj[_2548][2][0], _invDynamicShadowViewProj[_2548][3][0]).x) * _2545;
        float _2612 = (float4(_invDynamicShadowViewProj[_2548][0][0], _invDynamicShadowViewProj[_2548][1][0], _invDynamicShadowViewProj[_2548][2][0], _invDynamicShadowViewProj[_2548][3][0]).y) * _2545;
        float _2616 = (float4(_invDynamicShadowViewProj[_2548][0][0], _invDynamicShadowViewProj[_2548][1][0], _invDynamicShadowViewProj[_2548][2][0], _invDynamicShadowViewProj[_2548][3][0]).z) * _2545;
        float _2620 = (float4(_invDynamicShadowViewProj[_2548][0][0], _invDynamicShadowViewProj[_2548][1][0], _invDynamicShadowViewProj[_2548][2][0], _invDynamicShadowViewProj[_2548][3][0]).w) * _2545;
        float _2623 = mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).w), _2579, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).w), _2546, _2620)) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).w);
        float _2624 = (mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).x), _2579, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).x), _2546, _2608)) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).x)) / _2623;
        float _2625 = (mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).y), _2579, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).y), _2546, _2612)) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).y)) / _2623;
        float _2626 = (mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).z), _2579, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).z), _2546, _2616)) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).z)) / _2623;
        float _2629 = _2545 + (_dynmaicShadowSizeAndInvSize.z * 8.0f);
        float _2645 = mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).w), _2580, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).w), _2546, ((float4(_invDynamicShadowViewProj[_2548][0][0], _invDynamicShadowViewProj[_2548][1][0], _invDynamicShadowViewProj[_2548][2][0], _invDynamicShadowViewProj[_2548][3][0]).w) * _2629))) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).w);
        float _2651 = _2546 - (_dynmaicShadowSizeAndInvSize.w * 4.0f);
        float _2663 = mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).w), _2581, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).w), _2651, _2620)) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).w);
        float _2667 = ((mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).x), _2581, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).x), _2651, _2608)) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).x)) / _2663) - _2624;
        float _2668 = ((mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).y), _2581, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).y), _2651, _2612)) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).y)) / _2663) - _2625;
        float _2669 = ((mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).z), _2581, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).z), _2651, _2616)) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).z)) / _2663) - _2626;
        float _2670 = ((mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).x), _2580, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).x), _2546, ((float4(_invDynamicShadowViewProj[_2548][0][0], _invDynamicShadowViewProj[_2548][1][0], _invDynamicShadowViewProj[_2548][2][0], _invDynamicShadowViewProj[_2548][3][0]).x) * _2629))) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).x)) / _2645) - _2624;
        float _2671 = ((mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).y), _2580, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).y), _2546, ((float4(_invDynamicShadowViewProj[_2548][0][0], _invDynamicShadowViewProj[_2548][1][0], _invDynamicShadowViewProj[_2548][2][0], _invDynamicShadowViewProj[_2548][3][0]).y) * _2629))) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).y)) / _2645) - _2625;
        float _2672 = ((mad((float4(_invDynamicShadowViewProj[_2548][0][2], _invDynamicShadowViewProj[_2548][1][2], _invDynamicShadowViewProj[_2548][2][2], _invDynamicShadowViewProj[_2548][3][2]).z), _2580, mad((float4(_invDynamicShadowViewProj[_2548][0][1], _invDynamicShadowViewProj[_2548][1][1], _invDynamicShadowViewProj[_2548][2][1], _invDynamicShadowViewProj[_2548][3][1]).z), _2546, ((float4(_invDynamicShadowViewProj[_2548][0][0], _invDynamicShadowViewProj[_2548][1][0], _invDynamicShadowViewProj[_2548][2][0], _invDynamicShadowViewProj[_2548][3][0]).z) * _2629))) + (float4(_invDynamicShadowViewProj[_2548][0][3], _invDynamicShadowViewProj[_2548][1][3], _invDynamicShadowViewProj[_2548][2][3], _invDynamicShadowViewProj[_2548][3][3]).z)) / _2645) - _2626;
        float _2675 = (_2669 * _2671) - (_2668 * _2672);
        float _2678 = (_2667 * _2672) - (_2669 * _2670);
        float _2681 = (_2668 * _2670) - (_2667 * _2671);
        float _2683 = rsqrt(dot(float3(_2675, _2678, _2681), float3(_2675, _2678, _2681)));
        if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
          _2701 = _sunDirection.x;
          _2702 = _sunDirection.y;
          _2703 = _sunDirection.z;
        } else {
          _2701 = _moonDirection.x;
          _2702 = _moonDirection.y;
          _2703 = _moonDirection.z;
        }
        float _2709 = (_2544 - (saturate(-0.0f - dot(float3(_2701, _2702, _2703), float3(_214, _215, _216))) * 9.999999747378752e-05f)) + _2547;
        _2722 = (_2675 * _2683);
        _2723 = (_2678 * _2683);
        _2724 = (_2681 * _2683);
        _2725 = min(float((bool)(uint)(_2579 > _2709)), min(min(float((bool)(uint)(_2580 > _2709)), float((bool)(uint)(_2581 > _2709))), float((bool)(uint)(_2582 > _2709))));
      } else {
        _2722 = _2430;
        _2723 = _2431;
        _2724 = _2432;
        _2725 = _2433;
      }
      float _2730 = _viewPos.x - _shadowRelativePosition.x;
      float _2731 = _viewPos.y - _shadowRelativePosition.y;
      float _2732 = _viewPos.z - _shadowRelativePosition.z;
      float _2733 = _2730 + _2071;
      float _2734 = _2731 + _2072;
      float _2735 = _2732 + _2073;
      float _2755 = mad((_terrainShadowProjRelativeTexScale[0].z), _2735, mad((_terrainShadowProjRelativeTexScale[0].y), _2734, (_2733 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
      float _2759 = mad((_terrainShadowProjRelativeTexScale[1].z), _2735, mad((_terrainShadowProjRelativeTexScale[1].y), _2734, (_2733 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
      float _2763 = mad((_terrainShadowProjRelativeTexScale[2].z), _2735, mad((_terrainShadowProjRelativeTexScale[2].y), _2734, (_2733 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
      if (saturate(_2755) == _2755) {
        if (((_2763 >= 9.999999747378752e-05f)) && ((((_2763 <= 1.0f)) && ((saturate(_2759) == _2759))))) {
          float _2778 = frac((_2755 * 1024.0f) + -0.5f);
          float4 _2782 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_2755, _2759));
          float _2787 = _2763 + -0.004999999888241291f;
          float _2792 = select((_2782.w > _2787), 1.0f, 0.0f);
          float _2794 = select((_2782.x > _2787), 1.0f, 0.0f);
          float _2801 = ((select((_2782.z > _2787), 1.0f, 0.0f) - _2792) * _2778) + _2792;
          _2807 = saturate((((((select((_2782.y > _2787), 1.0f, 0.0f) - _2794) * _2778) + _2794) - _2801) * frac((_2759 * 1024.0f) + -0.5f)) + _2801);
        } else {
          _2807 = 1.0f;
        }
      } else {
        _2807 = 1.0f;
      }
      float _2808 = min(_2725, _2807);
      half _2809 = saturate(_2438);
      half _2810 = saturate(_2439);
      half _2811 = saturate(_2440);
      half _2825 = ((_2810 * 0.3395996h) + (_2809 * 0.61328125h)) + (_2811 * 0.04736328h);
      half _2826 = ((_2810 * 0.9165039h) + (_2809 * 0.07019043h)) + (_2811 * 0.013450623h);
      half _2827 = ((_2810 * 0.109558105h) + (_2809 * 0.020614624h)) + (_2811 * 0.8696289h);
      bool _2830 = (_sunDirection.y > 0.0f);
      if ((_2830) || ((!(_2830)) && (_sunDirection.y > _moonDirection.y))) {
        _2842 = _sunDirection.x;
        _2843 = _sunDirection.y;
        _2844 = _sunDirection.z;
      } else {
        _2842 = _moonDirection.x;
        _2843 = _moonDirection.y;
        _2844 = _moonDirection.z;
      }
      if ((_2830) || ((!(_2830)) && (_sunDirection.y > _moonDirection.y))) {
        _2864 = _precomputedAmbient7.y;
      } else {
        _2864 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
      }
      float _2867 = _2150 + _earthRadius;
      float _2871 = (_2073 * _2073) + (_2071 * _2071);
      float _2873 = sqrt((_2867 * _2867) + _2871);
      float _2878 = dot(float3((_2071 / _2873), (_2867 / _2873), (_2073 / _2873)), float3(_2842, _2843, _2844));
      float _2881 = _atmosphereThickness + -16.0f;
      float _2883 = min(max(((_2873 - _earthRadius) / _atmosphereThickness), 16.0f), _2881);
      float _2885 = _atmosphereThickness + -32.0f;
      float _2891 = max(_2883, 0.0f);
      float _2892 = _earthRadius * 2.0f;
      float _2898 = (-0.0f - sqrt((_2891 + _2892) * _2891)) / (_2891 + _earthRadius);
      if (_2878 > _2898) {
        _2921 = ((exp2(log2(saturate((_2878 - _2898) / (1.0f - _2898))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _2921 = ((exp2(log2(saturate((_2898 - _2878) / (_2898 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float2 _2926 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_2883 + -16.0f) / _2885)) * 0.5f) * 0.96875f) + 0.015625f), _2921), 0.0f);
      float _2945 = _mieAerosolAbsorption + 1.0f;
      float _2946 = _mieAerosolDensity * 1.9999999494757503e-05f;
      float _2948 = (_2946 * _2926.y) * _2945;
      float _2954 = (float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f);
      float _2957 = (float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f);
      float _2960 = (_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f);
      float _2966 = exp2(((_2954 * _2926.x) + _2948) * -1.4426950216293335f);
      float _2967 = exp2(((_2957 * _2926.x) + _2948) * -1.4426950216293335f);
      float _2968 = exp2(((_2960 * _2926.x) + _2948) * -1.4426950216293335f);
      float _2984 = sqrt(_2871);
      float _2992 = (_cloudAltitude - (max(((_2984 * _2984) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
      float _3004 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_2843 > 0.0f))) - ((int)(uint)((int)(_2843 < 0.0f))))) * 0.5f))) + _2992;
      if (_2072 < _2992) {
        float _3007 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2842, _2843, _2844));
        float _3013 = select((abs(_3007) < 9.99999993922529e-09f), 1e+08f, ((_3004 - dot(float3(0.0f, 1.0f, 0.0f), float3(_2071, _2072, _2073))) / _3007));
        _3019 = ((_3013 * _2842) + _2071);
        _3020 = _3004;
        _3021 = ((_3013 * _2844) + _2073);
      } else {
        _3019 = _2071;
        _3020 = _2072;
        _3021 = _2073;
      }
      float _3030 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3019 * 4.999999873689376e-05f) + 0.5f), ((_3020 - _2992) / _cloudThickness), ((_3021 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
      float _3034 = _cloudScatteringCoefficient / _distanceScale;
      float _3035 = _distanceScale * -1.4426950216293335f;
      float _3041 = saturate(abs(_2843) * 4.0f);
      float _3043 = (_3041 * _3041) * exp2((_3035 * _3030.x) * _3034);
      float _3050 = ((1.0f - _3043) * saturate(((_2072 - _cloudThickness) - _2992) * 0.10000000149011612f)) + _3043;
      float _3051 = _3050 * (((_2967 * 0.3395099937915802f) + (_2966 * 0.6131200194358826f)) + (_2968 * 0.047370001673698425f));
      float _3052 = _3050 * (((_2967 * 0.9163600206375122f) + (_2966 * 0.07020000368356705f)) + (_2968 * 0.013450000435113907f));
      float _3053 = _3050 * (((_2967 * 0.10958000272512436f) + (_2966 * 0.02061999961733818f)) + (_2968 * 0.8697999715805054f));
      float _3072 = float(saturate(_2441));
      if (((_758 != 0)) && ((!_778))) {
        bool _3074 = (_967 > 0.0f);
        float _3075 = select(_3074, _964, _2722);
        float _3076 = select(_3074, _965, _2723);
        float _3077 = select(_3074, _966, _2724);
        float _3078 = select(_3074, _967, 0.800000011920929f);
        if (_757 > 0.0f) {
          half _3081 = half(_754);
          half _3082 = half(_755);
          half _3083 = half(_756);
          _3089 = _3078;
          _3090 = _3075;
          _3091 = _3076;
          _3092 = _3077;
          _3093 = _3081;
          _3094 = _3082;
          _3095 = _3083;
          _3096 = _757;
          _3097 = float(_3081);
          _3098 = float(_3082);
          _3099 = float(_3083);
          _3100 = dot(float3(_3075, _3076, _3077), float3(_2842, _2843, _2844));
        } else {
          _3089 = _3078;
          _3090 = _3075;
          _3091 = _3076;
          _3092 = _3077;
          _3093 = _2825;
          _3094 = _2826;
          _3095 = _2827;
          _3096 = 0.10000000149011612f;
          _3097 = 1.0f;
          _3098 = 1.0f;
          _3099 = 1.0f;
          _3100 = _3072;
        }
      } else {
        _3089 = 0.800000011920929f;
        _3090 = _2722;
        _3091 = _2723;
        _3092 = _2724;
        _3093 = _2825;
        _3094 = _2826;
        _3095 = _2827;
        _3096 = 0.10000000149011612f;
        _3097 = 1.0f;
        _3098 = 1.0f;
        _3099 = 1.0f;
        _3100 = _3072;
      }
      float _3108 = float(half(saturate(_3100) * 0.31830987334251404f)) * _2808;
      float _3116 = 0.699999988079071f / min(max(max(max(_3097, _3098), _3099), 0.009999999776482582f), 0.699999988079071f);
      float _3127 = (((_3116 * _3098) + -0.03999999910593033f) * _3096) + 0.03999999910593033f;
      float _3129 = _2842 - _214;
      float _3130 = _2843 - _215;
      float _3131 = _2844 - _216;
      float _3133 = rsqrt(dot(float3(_3129, _3130, _3131), float3(_3129, _3130, _3131)));
      float _3134 = _3133 * _3129;
      float _3135 = _3133 * _3130;
      float _3136 = _3133 * _3131;
      float _3137 = -0.0f - _214;
      float _3138 = -0.0f - _215;
      float _3139 = -0.0f - _216;
      float _3144 = saturate(max(9.999999747378752e-06f, dot(float3(_3137, _3138, _3139), float3(_3090, _3091, _3092))));
      float _3146 = saturate(dot(float3(_3090, _3091, _3092), float3(_3134, _3135, _3136)));
      float _3149 = saturate(1.0f - saturate(saturate(dot(float3(_3137, _3138, _3139), float3(_3134, _3135, _3136)))));
      float _3150 = _3149 * _3149;
      float _3152 = (_3150 * _3150) * _3149;
      float _3155 = _3152 * saturate(_3127 * 50.0f);
      float _3156 = 1.0f - _3152;
      float _3164 = saturate(_3100 * _2808);
      float _3165 = _3089 * _3089;
      float _3166 = _3165 * _3165;
      float _3167 = 1.0f - _3165;
      float _3179 = (((_3146 * _3166) - _3146) * _3146) + 1.0f;
      float _3183 = (_3166 / ((_3179 * _3179) * 3.1415927410125732f)) * (0.5f / ((((_3144 * _3167) + _3165) * _3100) + (_3144 * ((_3100 * _3167) + _3165))));
      float _3194 = ((((_3051 * 0.6131200194358826f) + (_3052 * 0.3395099937915802f)) + (_3053 * 0.047370001673698425f)) * _2864) * ((max((((_3156 * ((((_3116 * _3097) + -0.03999999910593033f) * _3096) + 0.03999999910593033f)) + _3155) * _3183), 0.0f) * _3164) + (_3108 * float(_3093)));
      float _3196 = ((((_3051 * 0.07020000368356705f) + (_3052 * 0.9163600206375122f)) + (_3053 * 0.013450000435113907f)) * _2864) * ((max((((_3156 * _3127) + _3155) * _3183), 0.0f) * _3164) + (_3108 * float(_3094)));
      float _3198 = ((((_3051 * 0.02061999961733818f) + (_3052 * 0.10958000272512436f)) + (_3053 * 0.8697999715805054f)) * _2864) * ((max((((_3156 * ((((_3116 * _3099) + -0.03999999910593033f) * _3096) + 0.03999999910593033f)) + _3155) * _3183), 0.0f) * _3164) + (_3108 * float(_3095)));
      float _3203 = dot(float3(_3194, _3196, _3198), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _3204 = min((max(0.0005000000237487257f, _exposure3.w) * 4096.0f), _3203);
      float _3208 = max(9.999999717180685e-10f, _3203);
      float _3209 = (_3204 * _3194) / _3208;
      float _3210 = (_3204 * _3196) / _3208;
      float _3211 = (_3204 * _3198) / _3208;
      if (((_110 == 33)) || ((_110 == 55))) {
        if ((_2830) || ((!(_2830)) && (_sunDirection.y > _moonDirection.y))) {
          _3232 = _sunDirection.x;
          _3233 = _sunDirection.y;
          _3234 = _sunDirection.z;
        } else {
          _3232 = _moonDirection.x;
          _3233 = _moonDirection.y;
          _3234 = _moonDirection.z;
        }
        float _3239 = rsqrt(dot(float3(_173, _174, _175), float3(_173, _174, _175)));
        float _3240 = _3239 * _173;
        float _3241 = _3239 * _174;
        float _3242 = _3239 * _175;
        float _3246 = _173 - (_133 * 0.03999999910593033f);
        float _3247 = _174 - (_134 * 0.03999999910593033f);
        float _3248 = _175 - (_135 * 0.03999999910593033f);
        float _3252 = (_viewPos.x - (_staticShadowPosition[1].x)) + _3246;
        float _3253 = (_viewPos.y - (_staticShadowPosition[1].y)) + _3247;
        float _3254 = (_viewPos.z - (_staticShadowPosition[1].z)) + _3248;
        float _3258 = mad((_shadowProjRelativeTexScale[1][0].z), _3254, mad((_shadowProjRelativeTexScale[1][0].y), _3253, (_3252 * (_shadowProjRelativeTexScale[1][0].x)))) + (_shadowProjRelativeTexScale[1][0].w);
        float _3262 = mad((_shadowProjRelativeTexScale[1][1].z), _3254, mad((_shadowProjRelativeTexScale[1][1].y), _3253, (_3252 * (_shadowProjRelativeTexScale[1][1].x)))) + (_shadowProjRelativeTexScale[1][1].w);
        bool _3273 = ((((((!(_3258 <= _2190))) || ((!(_3258 >= _2189))))) || ((!(_3262 <= _2190))))) || ((!(_3262 >= _2189)));
        float _3281 = (_viewPos.x - (_staticShadowPosition[0].x)) + _3246;
        float _3282 = (_viewPos.y - (_staticShadowPosition[0].y)) + _3247;
        float _3283 = (_viewPos.z - (_staticShadowPosition[0].z)) + _3248;
        float _3287 = mad((_shadowProjRelativeTexScale[0][0].z), _3283, mad((_shadowProjRelativeTexScale[0][0].y), _3282, (_3281 * (_shadowProjRelativeTexScale[0][0].x)))) + (_shadowProjRelativeTexScale[0][0].w);
        float _3291 = mad((_shadowProjRelativeTexScale[0][1].z), _3283, mad((_shadowProjRelativeTexScale[0][1].y), _3282, (_3281 * (_shadowProjRelativeTexScale[0][1].x)))) + (_shadowProjRelativeTexScale[0][1].w);
        bool _3302 = ((((((!(_3287 <= _2190))) || ((!(_3287 >= _2189))))) || ((!(_3291 <= _2190))))) || ((!(_3291 >= _2189)));
        float _3304 = select(((_3302) && (_3273)), 0.0f, 0.0010000000474974513f);
        float _3305 = select(_3302, select(_3273, 0.0f, _3258), _3287);
        float _3306 = select(_3302, select(_3273, 0.0f, _3262), _3291);
        float _3307 = select(_3302, select(_3273, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _3254, mad((_shadowProjRelativeTexScale[1][2].y), _3253, (_3252 * (_shadowProjRelativeTexScale[1][2].x)))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _3283, mad((_shadowProjRelativeTexScale[0][2].y), _3282, (_3281 * (_shadowProjRelativeTexScale[0][2].x)))) + (_shadowProjRelativeTexScale[0][2].w)));
        int _3308 = select(_3302, select(_3273, -1, 1), 0);
        [branch]
        if (!(_3308 == -1)) {
          float _3314 = (_3305 * _shadowSizeAndInvSize.x) + -0.5f;
          float _3315 = (_3306 * _shadowSizeAndInvSize.y) + -0.5f;
          int _3318 = int(floor(_3314));
          int _3319 = int(floor(_3315));
          if (!((((uint)_3318 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_3319 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
            float4 _3329 = __3__36__0__0__g_shadowDepthArray.Load(int4(_3318, _3319, _3308, 0));
            float4 _3331 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_3318) + 1u)), _3319, _3308, 0));
            float4 _3333 = __3__36__0__0__g_shadowDepthArray.Load(int4(_3318, ((int)((uint)(_3319) + 1u)), _3308, 0));
            float4 _3335 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_3318) + 1u)), ((int)((uint)(_3319) + 1u)), _3308, 0));
            _3338 = _3329.x;
            _3339 = _3331.x;
            _3340 = _3333.x;
            _3341 = _3335.x;
          } else {
            _3338 = 0.0f;
            _3339 = 0.0f;
            _3340 = 0.0f;
            _3341 = 0.0f;
          }
          float _3367 = (float4(_invShadowViewProj[_3308][0][0], _invShadowViewProj[_3308][1][0], _invShadowViewProj[_3308][2][0], _invShadowViewProj[_3308][3][0]).x) * _3305;
          float _3371 = (float4(_invShadowViewProj[_3308][0][0], _invShadowViewProj[_3308][1][0], _invShadowViewProj[_3308][2][0], _invShadowViewProj[_3308][3][0]).y) * _3305;
          float _3375 = (float4(_invShadowViewProj[_3308][0][0], _invShadowViewProj[_3308][1][0], _invShadowViewProj[_3308][2][0], _invShadowViewProj[_3308][3][0]).z) * _3305;
          float _3379 = (float4(_invShadowViewProj[_3308][0][0], _invShadowViewProj[_3308][1][0], _invShadowViewProj[_3308][2][0], _invShadowViewProj[_3308][3][0]).w) * _3305;
          float _3382 = mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).w), _3338, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).w), _3306, _3379)) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).w);
          float _3383 = (mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).x), _3338, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).x), _3306, _3367)) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).x)) / _3382;
          float _3384 = (mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).y), _3338, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).y), _3306, _3371)) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).y)) / _3382;
          float _3385 = (mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).z), _3338, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).z), _3306, _3375)) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).z)) / _3382;
          float _3388 = _3305 + (_shadowSizeAndInvSize.z * 4.0f);
          float _3404 = mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).w), _3339, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).w), _3306, ((float4(_invShadowViewProj[_3308][0][0], _invShadowViewProj[_3308][1][0], _invShadowViewProj[_3308][2][0], _invShadowViewProj[_3308][3][0]).w) * _3388))) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).w);
          float _3410 = _3306 - (_shadowSizeAndInvSize.w * 2.0f);
          float _3422 = mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).w), _3340, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).w), _3410, _3379)) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).w);
          float _3426 = ((mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).x), _3340, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).x), _3410, _3367)) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).x)) / _3422) - _3383;
          float _3427 = ((mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).y), _3340, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).y), _3410, _3371)) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).y)) / _3422) - _3384;
          float _3428 = ((mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).z), _3340, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).z), _3410, _3375)) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).z)) / _3422) - _3385;
          float _3429 = ((mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).x), _3339, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).x), _3306, ((float4(_invShadowViewProj[_3308][0][0], _invShadowViewProj[_3308][1][0], _invShadowViewProj[_3308][2][0], _invShadowViewProj[_3308][3][0]).x) * _3388))) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).x)) / _3404) - _3383;
          float _3430 = ((mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).y), _3339, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).y), _3306, ((float4(_invShadowViewProj[_3308][0][0], _invShadowViewProj[_3308][1][0], _invShadowViewProj[_3308][2][0], _invShadowViewProj[_3308][3][0]).y) * _3388))) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).y)) / _3404) - _3384;
          float _3431 = ((mad((float4(_invShadowViewProj[_3308][0][2], _invShadowViewProj[_3308][1][2], _invShadowViewProj[_3308][2][2], _invShadowViewProj[_3308][3][2]).z), _3339, mad((float4(_invShadowViewProj[_3308][0][1], _invShadowViewProj[_3308][1][1], _invShadowViewProj[_3308][2][1], _invShadowViewProj[_3308][3][1]).z), _3306, ((float4(_invShadowViewProj[_3308][0][0], _invShadowViewProj[_3308][1][0], _invShadowViewProj[_3308][2][0], _invShadowViewProj[_3308][3][0]).z) * _3388))) + (float4(_invShadowViewProj[_3308][0][3], _invShadowViewProj[_3308][1][3], _invShadowViewProj[_3308][2][3], _invShadowViewProj[_3308][3][3]).z)) / _3404) - _3385;
          float _3434 = (_3428 * _3430) - (_3427 * _3431);
          float _3437 = (_3426 * _3431) - (_3428 * _3429);
          float _3440 = (_3427 * _3429) - (_3426 * _3430);
          float _3442 = rsqrt(dot(float3(_3434, _3437, _3440), float3(_3434, _3437, _3440)));
          float _3446 = frac(_3314);
          float _3451 = (saturate(dot(float3(_3240, _3241, _3242), float3((_3434 * _3442), (_3437 * _3442), (_3440 * _3442)))) * 0.0020000000949949026f) + _3307;
          float _3464 = saturate(exp2((_3338 - _3451) * 1442695.0f));
          float _3466 = saturate(exp2((_3340 - _3451) * 1442695.0f));
          float _3472 = ((saturate(exp2((_3339 - _3451) * 1442695.0f)) - _3464) * _3446) + _3464;
          _3479 = saturate((((_3466 - _3472) + ((saturate(exp2((_3341 - _3451) * 1442695.0f)) - _3466) * _3446)) * frac(_3315)) + _3472);
          _3480 = _3338;
          _3481 = _3339;
          _3482 = _3340;
          _3483 = _3341;
        } else {
          _3479 = 1.0f;
          _3480 = 0.0f;
          _3481 = 0.0f;
          _3482 = 0.0f;
          _3483 = 0.0f;
        }
        float _3487 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _3248, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _3247, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _3246))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
        float _3491 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _3248, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _3247, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _3246))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
        float _3495 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _3248, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _3247, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _3246))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
        if (!(((((!(_3487 <= _2473))) || ((!(_3487 >= _2472))))) || ((!(_3491 <= _2473))))) {
          bool _3506 = ((_3495 >= -1.0f)) && ((((_3491 >= _2472)) && ((_3495 <= 1.0f))));
          _3514 = select(_3506, 9.999999747378752e-06f, _3304);
          _3515 = select(_3506, _3487, _3305);
          _3516 = select(_3506, _3491, _3306);
          _3517 = select(_3506, _3495, _3307);
          _3518 = select(_3506, 1, _3308);
          _3519 = ((int)(uint)((int)(_3506)));
        } else {
          _3514 = _3304;
          _3515 = _3305;
          _3516 = _3306;
          _3517 = _3307;
          _3518 = _3308;
          _3519 = 0;
        }
        float _3523 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _3248, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _3247, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _3246))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
        float _3527 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _3248, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _3247, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _3246))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
        float _3531 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _3248, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _3247, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _3246))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
        if (!(((((!(_3523 <= _2473))) || ((!(_3523 >= _2472))))) || ((!(_3527 <= _2473))))) {
          bool _3542 = ((_3531 >= -1.0f)) && ((((_3527 >= _2472)) && ((_3531 <= 1.0f))));
          _3550 = select(_3542, 9.999999747378752e-06f, _3514);
          _3551 = select(_3542, _3523, _3515);
          _3552 = select(_3542, _3527, _3516);
          _3553 = select(_3542, _3531, _3517);
          _3554 = select(_3542, 0, _3518);
          _3555 = select(_3542, 1, _3519);
        } else {
          _3550 = _3514;
          _3551 = _3515;
          _3552 = _3516;
          _3553 = _3517;
          _3554 = _3518;
          _3555 = _3519;
        }
        [branch]
        if (!(_3555 == 0)) {
          int _3565 = int(floor((_3551 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
          int _3566 = int(floor((_3552 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
          if (!((((uint)_3565 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_3566 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
            float4 _3576 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_3565, _3566, _3554, 0));
            float4 _3578 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_3565) + 1u)), _3566, _3554, 0));
            float4 _3580 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_3565, ((int)((uint)(_3566) + 1u)), _3554, 0));
            float4 _3582 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_3565) + 1u)), ((int)((uint)(_3566) + 1u)), _3554, 0));
            _3585 = _3576.x;
            _3586 = _3578.x;
            _3587 = _3580.x;
            _3588 = _3582.x;
          } else {
            _3585 = _3480;
            _3586 = _3481;
            _3587 = _3482;
            _3588 = _3483;
          }
          if ((_2830) || ((!(_2830)) && (_sunDirection.y > _moonDirection.y))) {
            _3600 = _sunDirection.x;
            _3601 = _sunDirection.y;
            _3602 = _sunDirection.z;
          } else {
            _3600 = _moonDirection.x;
            _3601 = _moonDirection.y;
            _3602 = _moonDirection.z;
          }
          float _3608 = (_3550 - (saturate(-0.0f - dot(float3(_3600, _3601, _3602), float3(_3240, _3241, _3242))) * 9.999999747378752e-05f)) + _3553;
          _3621 = min(float((bool)(uint)(_3585 > _3608)), min(min(float((bool)(uint)(_3586 > _3608)), float((bool)(uint)(_3587 > _3608))), float((bool)(uint)(_3588 > _3608))));
        } else {
          _3621 = _3479;
        }
        float _3622 = _2730 + _3246;
        float _3623 = _2731 + _3247;
        float _3624 = _2732 + _3248;
        float _3628 = mad((_terrainShadowProjRelativeTexScale[0].z), _3624, mad((_terrainShadowProjRelativeTexScale[0].y), _3623, (_3622 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
        float _3632 = mad((_terrainShadowProjRelativeTexScale[1].z), _3624, mad((_terrainShadowProjRelativeTexScale[1].y), _3623, (_3622 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
        float _3636 = mad((_terrainShadowProjRelativeTexScale[2].z), _3624, mad((_terrainShadowProjRelativeTexScale[2].y), _3623, (_3622 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
        if (saturate(_3628) == _3628) {
          if (((_3636 >= 9.999999747378752e-05f)) && ((((_3636 <= 1.0f)) && ((saturate(_3632) == _3632))))) {
            float _3651 = frac((_3628 * 1024.0f) + -0.5f);
            float4 _3655 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_3628, _3632));
            float _3660 = _3636 + -0.004999999888241291f;
            float _3665 = select((_3655.w > _3660), 1.0f, 0.0f);
            float _3667 = select((_3655.x > _3660), 1.0f, 0.0f);
            float _3674 = ((select((_3655.z > _3660), 1.0f, 0.0f) - _3665) * _3651) + _3665;
            _3680 = saturate((((((select((_3655.y > _3660), 1.0f, 0.0f) - _3667) * _3651) + _3667) - _3674) * frac((_3632 * 1024.0f) + -0.5f)) + _3674);
          } else {
            _3680 = 1.0f;
          }
        } else {
          _3680 = 1.0f;
        }
        uint4 _3686 = __3__36__0__0__g_baseColor.Load(int3((int)(uint(_81 * (1.0f / g_screenSpaceScale.x))), (int)(uint(_82 * (1.0f / g_screenSpaceScale.y))), 0));
        float _3692 = float((uint)((uint)(((uint)((uint)(_3686.x)) >> 8) & 255))) * 0.003921568859368563f;
        float _3695 = float((uint)((uint)(_3686.x & 255))) * 0.003921568859368563f;
        float _3699 = float((uint)((uint)(((uint)((uint)(_3686.y)) >> 8) & 255))) * 0.003921568859368563f;
        float _3700 = _3692 * _3692;
        float _3701 = _3695 * _3695;
        float _3702 = _3699 * _3699;
        if ((_2830) || ((!(_2830)) && (_sunDirection.y > _moonDirection.y))) {
          _3737 = _precomputedAmbient7.y;
        } else {
          _3737 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
        }
        float _3739 = (_earthRadius + _viewPos.y) + _174;
        float _3743 = (_175 * _175) + (_173 * _173);
        float _3745 = sqrt((_3739 * _3739) + _3743);
        float _3750 = dot(float3((_173 / _3745), (_3739 / _3745), (_175 / _3745)), float3(_3232, _3233, _3234));
        float _3753 = min(max(((_3745 - _earthRadius) / _atmosphereThickness), 16.0f), _2881);
        float _3760 = max(_3753, 0.0f);
        float _3766 = (-0.0f - sqrt((_3760 + _2892) * _3760)) / (_3760 + _earthRadius);
        if (_3750 > _3766) {
          _3789 = ((exp2(log2(saturate((_3750 - _3766) / (1.0f - _3766))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
        } else {
          _3789 = ((exp2(log2(saturate((_3766 - _3750) / (_3766 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
        }
        float2 _3792 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_3753 + -16.0f) / _2885)) * 0.5f) * 0.96875f) + 0.015625f), _3789), 0.0f);
        float _3796 = (_2946 * _2945) * _3792.y;
        float _3806 = exp2((_3796 + (_3792.x * _2954)) * -1.4426950216293335f);
        float _3807 = exp2((_3796 + (_3792.x * _2957)) * -1.4426950216293335f);
        float _3808 = exp2((_3796 + (_3792.x * _2960)) * -1.4426950216293335f);
        float _3824 = sqrt(_3743);
        float _3830 = (_cloudAltitude - (max(((_3824 * _3824) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
        float _3840 = _3830 + ((0.5f - (float((int)(((int)(uint)((int)(_3233 > 0.0f))) - ((int)(uint)((int)(_3233 < 0.0f))))) * 0.5f)) * _cloudThickness);
        if (_174 < _3830) {
          float _3843 = dot(float3(0.0f, 1.0f, 0.0f), float3(_3232, _3233, _3234));
          float _3849 = select((abs(_3843) < 9.99999993922529e-09f), 1e+08f, ((_3840 - dot(float3(0.0f, 1.0f, 0.0f), float3(_173, _174, _175))) / _3843));
          _3855 = ((_3849 * _3232) + _173);
          _3856 = _3840;
          _3857 = ((_3849 * _3234) + _175);
        } else {
          _3855 = _173;
          _3856 = _174;
          _3857 = _175;
        }
        float _3864 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3855 * 4.999999873689376e-05f) + 0.5f), ((_3856 - _3830) / _cloudThickness), ((_3857 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
        float _3871 = saturate(abs(_3233) * 4.0f);
        float _3873 = (_3871 * _3871) * exp2((_3035 * _3034) * _3864.x);
        float _3880 = ((1.0f - _3873) * saturate(((_174 - _cloudThickness) - _3830) * 0.10000000149011612f)) + _3873;
        float _3881 = _3880 * (((_3807 * 0.3395099937915802f) + (_3806 * 0.6131200194358826f)) + (_3808 * 0.047370001673698425f));
        float _3882 = _3880 * (((_3807 * 0.9163600206375122f) + (_3806 * 0.07020000368356705f)) + (_3808 * 0.013450000435113907f));
        float _3883 = _3880 * (((_3807 * 0.10958000272512436f) + (_3806 * 0.02061999961733818f)) + (_3808 * 0.8697999715805054f));
        float _3899 = ((max(0.0f, (0.30000001192092896f - dot(float3(_133, _134, _135), float3(_3232, _3233, _3234)))) * 0.1573420912027359f) * saturate(min(_3621, _3680))) * _3737;
        _3910 = (((_3899 * (((_3700 * 0.6131200194358826f) + (_3701 * 0.3395099937915802f)) + (_3702 * 0.047370001673698425f))) * (((_3881 * 0.6131200194358826f) + (_3882 * 0.3395099937915802f)) + (_3883 * 0.047370001673698425f))) + _3209);
        _3911 = (((_3899 * (((_3700 * 0.07020000368356705f) + (_3701 * 0.9163600206375122f)) + (_3702 * 0.013450000435113907f))) * (((_3881 * 0.07020000368356705f) + (_3882 * 0.9163600206375122f)) + (_3883 * 0.013450000435113907f))) + _3210);
        _3912 = (((_3899 * (((_3700 * 0.02061999961733818f) + (_3701 * 0.10958000272512436f)) + (_3702 * 0.8697999715805054f))) * (((_3881 * 0.02061999961733818f) + (_3882 * 0.10958000272512436f)) + (_3883 * 0.8697999715805054f))) + _3211);
      } else {
        _3910 = _3209;
        _3911 = _3210;
        _3912 = _3211;
      }
      float _3913 = (_renderParams2.z * _2140) * _3910;
      float _3914 = (_renderParams2.z * _2141) * _3911;
      float _3915 = (_renderParams2.z * _2142) * _3912;
      float _3919 = _3913 + _2055;
      float _3920 = _3914 + _2056;
      float _3921 = _3915 + _2057;
      _3932 = _2065;
      _3933 = (((max(_2055, _3913) - _3919) * _2067) + _3919);
      _3934 = (((max(_2056, _3914) - _3920) * _2067) + _3920);
      _3935 = (((max(_2057, _3915) - _3921) * _2067) + _3921);
    } else {
      _3932 = 1000.0f;
      _3933 = _2055;
      _3934 = _2056;
      _3935 = _2057;
    }
    if (!_765) {
      __3__38__0__1__g_raytracingHitResultUAV[int2(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))))] = float4(_207.x, _207.y, _207.z, select((_3932 <= 0.0f), 1000.0f, _3932));
    }
    if (((_3932 > 128.0f)) && ((dot(float3(_3933, _3934, _3935), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) == 0.0f))) {
      _3946 = 1;
      while(true) {
        int _3986 = int(floor(((_wrappedViewPos.x + _2071) * ((_clipmapOffsets[_3946]).w)) + ((_clipmapRelativeIndexOffsets[_3946]).x)));
        int _3987 = int(floor(((_wrappedViewPos.y + _2072) * ((_clipmapOffsets[_3946]).w)) + ((_clipmapRelativeIndexOffsets[_3946]).y)));
        int _3988 = int(floor(((_wrappedViewPos.z + _2073) * ((_clipmapOffsets[_3946]).w)) + ((_clipmapRelativeIndexOffsets[_3946]).z)));
        if (!((((((((int)_3986 >= (int)int(((_clipmapOffsets[_3946]).x) + -63.0f))) && (((int)_3986 < (int)int(((_clipmapOffsets[_3946]).x) + 63.0f))))) && (((((int)_3987 >= (int)int(((_clipmapOffsets[_3946]).y) + -31.0f))) && (((int)_3987 < (int)int(((_clipmapOffsets[_3946]).y) + 31.0f))))))) && (((((int)_3988 >= (int)int(((_clipmapOffsets[_3946]).z) + -63.0f))) && (((int)_3988 < (int)int(((_clipmapOffsets[_3946]).z) + 63.0f))))))) {
          if ((uint)(_3946 + 1) < (uint)8) {
            _3946 = (_3946 + 1);
            continue;
          } else {
            _4004 = -10000;
          }
        } else {
          _4004 = _3946;
        }
        if (!((uint)_4004 > (uint)3)) {
          float _4024 = 1.0f / float((uint)(1u << (_4004 & 31)));
          float _4028 = frac(((_invClipmapExtent.z * _2073) + _clipmapUVRelativeOffset.z) * _4024);
          float _4040 = __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _2071) + _clipmapUVRelativeOffset.x) * _4024), (((_invClipmapExtent.y * _2072) + _clipmapUVRelativeOffset.y) * _4024), (((float((uint)(_4004 * 66)) + 1.0f) + ((select((_4028 < 0.0f), 1.0f, 0.0f) + _4028) * 64.0f)) * 0.0037878789007663727f)), 0.0f);
          _4045 = saturate(1.0f - _4040.x);
        } else {
          _4045 = 1.0f;
        }
        float _4048 = _renderParams.w * _4045;
        bool _4049 = (_757 == 0.0f);
        float4 _4057 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(select(_4049, (-0.0f - _214), _964), select(_4049, _215, _965), select(_4049, (-0.0f - _216), _966)), 4.0f);
        _4071 = ((_4048 * select(_4049, 0.03125f, _754)) * _4057.x);
        _4072 = ((_4048 * select(_4049, 0.03125f, _755)) * _4057.y);
        _4073 = ((_4048 * select(_4049, 0.03125f, _756)) * _4057.z);
        break;
      }
    } else {
      _4071 = _3933;
      _4072 = _3934;
      _4073 = _3935;
    }
    float _4080 = saturate(1.0f - saturate(_2058));
    float _4084 = (_4080 - (_renderParams2.w * _4080)) + _renderParams2.w;
    float4 _4088 = __3__36__0__0__g_environmentColor.SampleLevel(__3__40__0__0__g_samplerTrilinear, float3(_214, _215, _216), 4.0f);
    float _4094 = _renderParams.w * _4084;
    float _4095 = _4094 * _4088.x;
    float _4096 = _4094 * _4088.y;
    float _4097 = _4094 * _4088.z;
    float _4102 = dot(float3(_4095, _4096, _4097), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _4103 = min((max(0.009999999776482582f, _exposure3.w) * 2048.0f), _4102);
    float _4107 = max(9.999999717180685e-10f, _4102);
    float _4115 = __3__36__0__0__g_raytracingDiffuseRayInversePDF.Load(int3(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))), 0));
    float _4117 = _4115.x * 2.0f;
    float _4118 = _4117 * (((_4103 * _4095) / _4107) + (_renderParams2.y * _4071));
    float _4119 = _4117 * (((_4103 * _4096) / _4107) + (_renderParams2.y * _4072));
    float _4120 = _4117 * (((_4103 * _4097) / _4107) + (_renderParams2.y * _4073));
    if (!(_renderParams.y == 0.0f)) {
      float _4125 = saturate(dot(float3(_133, _134, _135), float3(_214, _215, _216)));
      _4130 = (_4125 * _4118);
      _4131 = (_4125 * _4119);
      _4132 = (_4125 * _4120);
    } else {
      _4130 = _4118;
      _4131 = _4119;
      _4132 = _4120;
    }
    if ((((((_106 & 126) == 96)) || ((_110 == 98)))) && ((_178 < 1000.0f))) {
      float _4142 = float((uint)(uint)(_frameNumber.x));
      float _4153 = (frac(((_4142 * 92.0f) + _81) * 0.0078125f) * 128.0f) + -64.34062194824219f;
      float _4154 = (frac(((_4142 * 71.0f) + _82) * 0.0078125f) * 128.0f) + -72.46562194824219f;
      float _4159 = frac(dot(float3((_4153 * _4153), (_4154 * _4154), (_4154 * _4153)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
      float _4166 = float((uint)((uint)(((int)(_frameNumber.x * 91)) & 15)));
      uint _4177 = min((uint)(15), (uint)((int)(uint(frac(frac(dot(float2(((_4166 * 32.665000915527344f) + _81), ((_4166 * 11.8149995803833f) + _82)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 16.0f))));
      float _4190 = 0.2774999737739563f / ((float((uint)((uint)(reversebits(_4177) ^ (int)(uint(_4159 * 287478368.0f))))) * 3.958121053138086e-10f) + 0.1499999761581421f);
      float _4191 = frac((float((uint)_4177) * 0.0625f) + (float((uint)((uint)((int)(uint(_4159 * 51540816.0f)) & 65535))) * 1.52587890625e-05f)) * 6.2831854820251465f;
      float _4194 = saturate((_4190 * _4190) * -0.5882352590560913f);
      float _4197 = sqrt(1.0f - (_4194 * _4194));
      float _4200 = cos(_4191) * _4197;
      float _4201 = sin(_4191) * _4197;
      float _4203 = -0.0f - _134;
      float _4206 = select((_135 <= -0.0f), 1.0f, -1.0f);
      float _4208 = 1.0f / (_4206 - _135);
      float _4209 = -0.0f - _4208;
      float _4211 = (_133 * _4209) * _134;
      float _4212 = _4206 * _133;
      float _4221 = mad(_4194, (-0.0f - _133), mad(_4201, _4211, ((((_4212 * _133) * _4209) + 1.0f) * _4200)));
      float _4225 = mad(_4194, _4203, mad(_4201, (((_134 * _4203) * _4208) + _4206), ((_4200 * _4206) * _4211)));
      float _4228 = mad(_4194, (-0.0f - _135), mad(_4201, _134, (_4212 * _4200)));
      float _4233 = ((frac(frac(dot(float2(_81, _82), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 0.10000000149011612f) + 0.009999999776482582f) * _voxelParams.x;
      _4235 = 0;
      while(true) {
        int _4275 = int(floor(((_wrappedViewPos.x + _173) * ((_clipmapOffsets[_4235]).w)) + ((_clipmapRelativeIndexOffsets[_4235]).x)));
        int _4276 = int(floor(((_wrappedViewPos.y + _174) * ((_clipmapOffsets[_4235]).w)) + ((_clipmapRelativeIndexOffsets[_4235]).y)));
        int _4277 = int(floor(((_wrappedViewPos.z + _175) * ((_clipmapOffsets[_4235]).w)) + ((_clipmapRelativeIndexOffsets[_4235]).z)));
        if (!((((((((int)_4275 >= (int)int(((_clipmapOffsets[_4235]).x) + -63.0f))) && (((int)_4275 < (int)int(((_clipmapOffsets[_4235]).x) + 63.0f))))) && (((((int)_4276 >= (int)int(((_clipmapOffsets[_4235]).y) + -31.0f))) && (((int)_4276 < (int)int(((_clipmapOffsets[_4235]).y) + 31.0f))))))) && (((((int)_4277 >= (int)int(((_clipmapOffsets[_4235]).z) + -63.0f))) && (((int)_4277 < (int)int(((_clipmapOffsets[_4235]).z) + 63.0f))))))) {
          if ((uint)(_4235 + 1) < (uint)8) {
            _4235 = (_4235 + 1);
            continue;
          } else {
            _4293 = -10000;
          }
        } else {
          _4293 = _4235;
        }
        if (!(((_4293 == -10000)) || (((int)_4293 > (int)4)))) {
          _4306 = 0;
          _4307 = 1.0f;
          _4308 = 0.0f;
          _4309 = 0.0f;
          _4310 = 0.0f;
          _4311 = 0.05000000074505806f;
          _4312 = ((_4233 * _4228) + _175);
          _4313 = ((_4233 * _4225) + _174);
          _4314 = ((_4233 * _4221) + _173);
          while(true) {
            _4316 = 0;
            while(true) {
              float _4341 = ((_wrappedViewPos.x + _4314) * ((_clipmapOffsets[_4316]).w)) + ((_clipmapRelativeIndexOffsets[_4316]).x);
              float _4342 = ((_wrappedViewPos.y + _4313) * ((_clipmapOffsets[_4316]).w)) + ((_clipmapRelativeIndexOffsets[_4316]).y);
              float _4343 = ((_wrappedViewPos.z + _4312) * ((_clipmapOffsets[_4316]).w)) + ((_clipmapRelativeIndexOffsets[_4316]).z);
              bool __defer_4315_4358 = false;
              if (!(((_4343 >= (((_clipmapOffsets[_4316]).z) + -63.0f))) && ((((_4341 >= (((_clipmapOffsets[_4316]).x) + -63.0f))) && ((_4342 >= (((_clipmapOffsets[_4316]).y) + -31.0f)))))) || ((((_4343 >= (((_clipmapOffsets[_4316]).z) + -63.0f))) && ((((_4341 >= (((_clipmapOffsets[_4316]).x) + -63.0f))) && ((_4342 >= (((_clipmapOffsets[_4316]).y) + -31.0f)))))) && (!(((_4343 < (((_clipmapOffsets[_4316]).z) + 63.0f))) && ((((_4341 < (((_clipmapOffsets[_4316]).x) + 63.0f))) && ((_4342 < (((_clipmapOffsets[_4316]).y) + 31.0f))))))))) {
                __defer_4315_4358 = true;
              } else {
                if ((uint)_4316 > (uint)3) {
                  _4895 = _4310;
                  _4896 = _4309;
                  _4897 = _4308;
                  _4898 = 0.0f;
                  _4900 = _4895;
                  _4901 = _4896;
                  _4902 = _4897;
                  _4903 = _4898;
                } else {
                  float _4364 = max(0.05000000074505806f, (_voxelParams.x * 0.05000000074505806f));
                  _4366 = 0;
                  while(true) {
                    int _4406 = int(floor(((_wrappedViewPos.x + _4314) * ((_clipmapOffsets[_4366]).w)) + ((_clipmapRelativeIndexOffsets[_4366]).x)));
                    int _4407 = int(floor(((_wrappedViewPos.y + _4313) * ((_clipmapOffsets[_4366]).w)) + ((_clipmapRelativeIndexOffsets[_4366]).y)));
                    int _4408 = int(floor(((_wrappedViewPos.z + _4312) * ((_clipmapOffsets[_4366]).w)) + ((_clipmapRelativeIndexOffsets[_4366]).z)));
                    if ((((((((int)_4406 >= (int)int(((_clipmapOffsets[_4366]).x) + -63.0f))) && (((int)_4406 < (int)int(((_clipmapOffsets[_4366]).x) + 63.0f))))) && (((((int)_4407 >= (int)int(((_clipmapOffsets[_4366]).y) + -31.0f))) && (((int)_4407 < (int)int(((_clipmapOffsets[_4366]).y) + 31.0f))))))) && (((((int)_4408 >= (int)int(((_clipmapOffsets[_4366]).z) + -63.0f))) && (((int)_4408 < (int)int(((_clipmapOffsets[_4366]).z) + 63.0f)))))) {
                      _4429 = (_4406 & 127);
                      _4430 = (_4407 & 63);
                      _4431 = (_4408 & 127);
                      _4432 = _4366;
                    } else {
                      if ((uint)(_4366 + 1) < (uint)8) {
                        _4366 = (_4366 + 1);
                        continue;
                      } else {
                        _4429 = -10000;
                        _4430 = -10000;
                        _4431 = -10000;
                        _4432 = -10000;
                      }
                    }
                    if (!((uint)_4432 > (uint)5)) {
                      uint _4444 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4429, _4430, ((int)(((uint)(((int)(_4432 * 130)) | 1)) + (uint)(_4431))), 0));
                      bool _4447 = ((_4444.x & 4194303) == 0);
                      [branch]
                      if (!_4447) {
                        _4450 = _4429;
                        _4451 = _4430;
                        _4452 = _4431;
                        _4453 = _4432;
                      } else {
                        _4450 = -10000;
                        _4451 = -10000;
                        _4452 = -10000;
                        _4453 = -10000;
                      }
                      float _4455 = (float((int)((int)(1u << (_4432 & 31)))) * 0.5f) * _voxelParams.x;
                      _4460 = 0;
                      while(true) {
                        int _4500 = int(floor((((_4314 - _4455) + _wrappedViewPos.x) * ((_clipmapOffsets[_4460]).w)) + ((_clipmapRelativeIndexOffsets[_4460]).x)));
                        int _4501 = int(floor((((_4313 - _4455) + _wrappedViewPos.y) * ((_clipmapOffsets[_4460]).w)) + ((_clipmapRelativeIndexOffsets[_4460]).y)));
                        int _4502 = int(floor((((_4312 - _4455) + _wrappedViewPos.z) * ((_clipmapOffsets[_4460]).w)) + ((_clipmapRelativeIndexOffsets[_4460]).z)));
                        if ((((((((int)_4500 >= (int)int(((_clipmapOffsets[_4460]).x) + -63.0f))) && (((int)_4500 < (int)int(((_clipmapOffsets[_4460]).x) + 63.0f))))) && (((((int)_4501 >= (int)int(((_clipmapOffsets[_4460]).y) + -31.0f))) && (((int)_4501 < (int)int(((_clipmapOffsets[_4460]).y) + 31.0f))))))) && (((((int)_4502 >= (int)int(((_clipmapOffsets[_4460]).z) + -63.0f))) && (((int)_4502 < (int)int(((_clipmapOffsets[_4460]).z) + 63.0f)))))) {
                          _4523 = (_4500 & 127);
                          _4524 = (_4501 & 63);
                          _4525 = (_4502 & 127);
                          _4526 = _4460;
                        } else {
                          if ((uint)(_4460 + 1) < (uint)8) {
                            _4460 = (_4460 + 1);
                            continue;
                          } else {
                            _4523 = -10000;
                            _4524 = -10000;
                            _4525 = -10000;
                            _4526 = -10000;
                          }
                        }
                        if (!((uint)_4526 > (uint)5)) {
                          if (_4447) {
                            _4531 = 0;
                            _4532 = _4453;
                            _4533 = _4452;
                            _4534 = _4451;
                            _4535 = _4450;
                            while(true) {
                              _4544 = 0;
                              _4545 = _4532;
                              _4546 = _4533;
                              _4547 = _4534;
                              _4548 = _4535;
                              while(true) {
                                if (!((((uint)(_4544 + _4524) > (uint)63)) || (((uint)(_4523 | (_4531 + _4525)) > (uint)127)))) {
                                  uint _4566 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4523, (_4544 + _4524), ((int)(((uint)(_4531 + _4525)) + ((uint)(((int)(_4526 * 130)) | 1)))), 0));
                                  int _4568 = _4566.x & 4194303;
                                  _4571 = (_4568 != 0);
                                  _4572 = _4568;
                                  _4573 = _4526;
                                  _4574 = (_4531 + _4525);
                                  _4575 = (_4544 + _4524);
                                  _4576 = _4523;
                                } else {
                                  _4571 = false;
                                  _4572 = 0;
                                  _4573 = 0;
                                  _4574 = 0;
                                  _4575 = 0;
                                  _4576 = 0;
                                }
                                if (!_4571) {
                                  if (!((((uint)(_4544 + _4524) > (uint)63)) || (((uint)((_4523 + 1) | (_4531 + _4525)) > (uint)127)))) {
                                    uint _5759 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((_4523 + 1), (_4544 + _4524), ((int)(((uint)(_4531 + _4525)) + ((uint)(((int)(_4526 * 130)) | 1)))), 0));
                                    int _5761 = _5759.x & 4194303;
                                    _5764 = (_5761 != 0);
                                    _5765 = _5761;
                                    _5766 = _4526;
                                    _5767 = (_4531 + _4525);
                                    _5768 = (_4544 + _4524);
                                    _5769 = (_4523 + 1);
                                  } else {
                                    _5764 = false;
                                    _5765 = 0;
                                    _5766 = 0;
                                    _5767 = 0;
                                    _5768 = 0;
                                    _5769 = 0;
                                  }
                                  if (!_5764) {
                                    _4585 = _4548;
                                    _4586 = _4547;
                                    _4587 = _4546;
                                    _4588 = _4545;
                                    _4589 = 0;
                                  } else {
                                    _4585 = _5769;
                                    _4586 = _5768;
                                    _4587 = _5767;
                                    _4588 = _5766;
                                    _4589 = _5765;
                                  }
                                } else {
                                  _4585 = _4576;
                                  _4586 = _4575;
                                  _4587 = _4574;
                                  _4588 = _4573;
                                  _4589 = _4572;
                                }
                                if ((((int)(_4544 + 1) < (int)2)) && ((_4589 == 0))) {
                                  _4544 = (_4544 + 1);
                                  _4545 = _4588;
                                  _4546 = _4587;
                                  _4547 = _4586;
                                  _4548 = _4585;
                                  continue;
                                }
                                if ((((int)(_4531 + 1) < (int)2)) && ((_4589 == 0))) {
                                  _4531 = (_4531 + 1);
                                  _4532 = _4588;
                                  _4533 = _4587;
                                  _4534 = _4586;
                                  _4535 = _4585;
                                  __loop_jump_target = 4530;
                                  break;
                                }
                                _4538 = _4588;
                                _4539 = _4587;
                                _4540 = _4586;
                                _4541 = _4585;
                                break;
                              }
                              if (__loop_jump_target == 4530) {
                                __loop_jump_target = -1;
                                continue;
                              }
                              if (__loop_jump_target != -1) {
                                break;
                              }
                              break;
                            }
                          } else {
                            _4538 = _4453;
                            _4539 = _4452;
                            _4540 = _4451;
                            _4541 = _4450;
                          }
                          if ((uint)_4538 < (uint)6) {
                            uint _4595 = _4538 * 130;
                            uint _4599 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4(_4541, _4540, ((int)(((uint)((int)(_4595) | 1)) + (uint)(_4539))), 0));
                            int _4601 = _4599.x & 4194303;
                            [branch]
                            if (!(_4601 == 0)) {
                              float _4607 = float((int)((int)(1u << (_4538 & 31)))) * _voxelParams.x;
                              float _4644 = -0.0f - _4221;
                              float _4645 = -0.0f - _4225;
                              float _4646 = -0.0f - _4228;
                              _4648 = 0.0f;
                              _4649 = 0.0f;
                              _4650 = 0.0f;
                              _4651 = 0.0f;
                              _4652 = 0;
                              while(true) {
                                int _4657 = __3__37__0__0__g_surfelDataBuffer[((_4601 + -1) + _4652)]._baseColor;
                                int _4659 = __3__37__0__0__g_surfelDataBuffer[((_4601 + -1) + _4652)]._normal;
                                int16_t _4662 = __3__37__0__0__g_surfelDataBuffer[((_4601 + -1) + _4652)]._radius;
                                if (!(_4657 == 0)) {
                                  half _4665 = __3__37__0__0__g_surfelDataBuffer[((_4601 + -1) + _4652)]._radiance.z;
                                  half _4666 = __3__37__0__0__g_surfelDataBuffer[((_4601 + -1) + _4652)]._radiance.y;
                                  half _4667 = __3__37__0__0__g_surfelDataBuffer[((_4601 + -1) + _4652)]._radiance.x;
                                  float _4673 = float((uint)((uint)(_4657 & 255)));
                                  float _4674 = float((uint)((uint)(((uint)((uint)(_4657)) >> 8) & 255)));
                                  float _4675 = float((uint)((uint)(((uint)((uint)(_4657)) >> 16) & 255)));
                                  float _4700 = select(((_4673 * 0.003921568859368563f) < 0.040449999272823334f), (_4673 * 0.0003035269910469651f), exp2(log2((_4673 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                                  float _4701 = select(((_4674 * 0.003921568859368563f) < 0.040449999272823334f), (_4674 * 0.0003035269910469651f), exp2(log2((_4674 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                                  float _4702 = select(((_4675 * 0.003921568859368563f) < 0.040449999272823334f), (_4675 * 0.0003035269910469651f), exp2(log2((_4675 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
                                  float _4714 = (float((uint)((uint)(_4659 & 255))) * 0.007874015718698502f) + -1.0f;
                                  float _4715 = (float((uint)((uint)(((uint)((uint)(_4659)) >> 8) & 255))) * 0.007874015718698502f) + -1.0f;
                                  float _4716 = (float((uint)((uint)(((uint)((uint)(_4659)) >> 16) & 255))) * 0.007874015718698502f) + -1.0f;
                                  float _4718 = rsqrt(dot(float3(_4714, _4715, _4716), float3(_4714, _4715, _4716)));
                                  bool _4723 = ((_4659 & 16777215) == 0);
                                  float _4727 = float(_4667);
                                  float _4728 = float(_4666);
                                  float _4729 = float(_4665);
                                  float _4733 = (_4607 * 0.0019607844296842813f) * float((uint16_t)((uint)((int)(_4662) & 255)));
                                  float _4749 = (((float((uint)((uint)((uint)((uint)(_4657)) >> 24))) * 0.003937007859349251f) + -0.5f) * _4607) + ((((((_clipmapOffsets[_4538]).x) + -63.5f) + float((int)(((int)(((uint)(_4541) + 64u) - (uint)(int((_clipmapOffsets[_4538]).x)))) & 127))) * _4607) - _viewPos.x);
                                  float _4750 = (((float((uint)((uint)((uint)((uint)(_4659)) >> 24))) * 0.003937007859349251f) + -0.5f) * _4607) + ((((((_clipmapOffsets[_4538]).y) + -31.5f) + float((int)(((int)(((uint)(_4540) + 32u) - (uint)(int((_clipmapOffsets[_4538]).y)))) & 63))) * _4607) - _viewPos.y);
                                  float _4751 = (((float((uint16_t)((uint)((uint16_t)((uint)(_4662)) >> 8))) * 0.003937007859349251f) + -0.5f) * _4607) + ((((((_clipmapOffsets[_4538]).z) + -63.5f) + float((int)(((int)(((uint)(_4539) + 64u) - (uint)(int((_clipmapOffsets[_4538]).z)))) & 127))) * _4607) - _viewPos.z);
                                  float _4769 = _4749 - _4314;
                                  float _4770 = _4750 - _4313;
                                  float _4771 = _4751 - _4312;
                                  float _4772 = dot(float3(_4769, _4770, _4771), float3(_4644, _4645, _4646));
                                  float _4776 = _4769 - (_4772 * _4644);
                                  float _4777 = _4770 - (_4772 * _4645);
                                  float _4778 = _4771 - (_4772 * _4646);
                                  float _4804 = 1.0f / float((uint)(1u << (_4538 & 31)));
                                  float _4808 = frac(((_invClipmapExtent.z * _4751) + _clipmapUVRelativeOffset.z) * _4804);
                                  float _4819 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3((((_invClipmapExtent.x * _4749) + _clipmapUVRelativeOffset.x) * _4804), (((_invClipmapExtent.y * _4750) + _clipmapUVRelativeOffset.y) * _4804), (((float((uint)_4595) + 1.0f) + ((select((_4808 < 0.0f), 1.0f, 0.0f) + _4808) * 128.0f)) * 0.000961538462433964f)), 0.0f);
                                  float _4833 = select(((int)_4538 > (int)5), 1.0f, ((saturate((saturate(dot(float3(_4644, _4645, _4646), float3(select(_4723, _4644, (_4718 * _4714)), select(_4723, _4645, (_4718 * _4715)), select(_4723, _4646, (_4718 * _4716))))) + -0.03125f) * 1.0322580337524414f) * float((bool)(uint)(dot(float3(_4776, _4777, _4778), float3(_4776, _4777, _4778)) < ((_4733 * _4733) * 16.0f)))) * float((bool)(uint)(_4819.x > ((_4607 * 0.25f) * (saturate((dot(float3(_4727, _4728, _4729), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 9.999999747378752e-05f) / _exposure3.w) + 1.0f))))));
                                  float _4840 = (((((_4701 * 0.3395099937915802f) + (_4700 * 0.6131200194358826f)) + (_4702 * 0.047370001673698425f)) * _4727) * _4833) + _4648;
                                  float _4841 = (((((_4701 * 0.9163600206375122f) + (_4700 * 0.07020000368356705f)) + (_4702 * 0.013450000435113907f)) * _4728) * _4833) + _4649;
                                  float _4842 = (((((_4701 * 0.10958000272512436f) + (_4700 * 0.02061999961733818f)) + (_4702 * 0.8697999715805054f)) * _4729) * _4833) + _4650;
                                  float _4843 = _4833 + _4651;
                                  if ((uint)(_4652 + 1) < (uint)(RT_QUALITY > 0.5f ? 8 : 4)) {
                                    _4648 = _4840;
                                    _4649 = _4841;
                                    _4650 = _4842;
                                    _4651 = _4843;
                                    _4652 = (_4652 + 1);
                                    continue;
                                  } else {
                                    _4847 = _4840;
                                    _4848 = _4841;
                                    _4849 = _4842;
                                    _4850 = _4843;
                                  }
                                } else {
                                  _4847 = _4648;
                                  _4848 = _4649;
                                  _4849 = _4650;
                                  _4850 = _4651;
                                }
                                if (_4850 > 0.0f) {
                                  float _4853 = 1.0f / _4850;
                                  _4867 = (-0.0f - min(0.0f, (-0.0f - (_4847 * _4853))));
                                  _4868 = (-0.0f - min(0.0f, (-0.0f - (_4848 * _4853))));
                                  _4869 = (-0.0f - min(0.0f, (-0.0f - (_4849 * _4853))));
                                } else {
                                  _4867 = _4847;
                                  _4868 = _4848;
                                  _4869 = _4849;
                                }
                                break;
                              }
                            } else {
                              _4867 = 0.0f;
                              _4868 = 0.0f;
                              _4869 = 0.0f;
                            }
                          } else {
                            _4867 = 0.0f;
                            _4868 = 0.0f;
                            _4869 = 0.0f;
                          }
                        } else {
                          _4867 = 0.0f;
                          _4868 = 0.0f;
                          _4869 = 0.0f;
                        }
                        break;
                      }
                    } else {
                      _4867 = 0.0f;
                      _4868 = 0.0f;
                      _4869 = 0.0f;
                    }
                    float _4870 = _4307 * 0.31830987334251404f;
                    float _4874 = (_4867 * _4870) + _4310;
                    float _4875 = (_4868 * _4870) + _4309;
                    float _4876 = (_4869 * _4870) + _4308;
                    float _4879 = exp2(_4364 * -28.853900909423828f) * _4307;
                    if (_4879 < 0.050000011920928955f) {
                      _4895 = _4874;
                      _4896 = _4875;
                      _4897 = _4876;
                      _4898 = _4311;
                      _4900 = _4895;
                      _4901 = _4896;
                      _4902 = _4897;
                      _4903 = _4898;
                    } else {
                      float _4882 = _4364 + _4311;
                      if ((((uint)(_4306 + 1) < (uint)32)) && ((_4882 < 32.0f))) {
                        _4306 = (_4306 + 1);
                        _4307 = _4879;
                        _4308 = _4876;
                        _4309 = _4875;
                        _4310 = _4874;
                        _4311 = _4882;
                        _4312 = ((_4364 * _4228) + _4312);
                        _4313 = ((_4364 * _4225) + _4313);
                        _4314 = ((_4364 * _4221) + _4314);
                        __loop_jump_target = 4305;
                        break;
                      } else {
                        _4895 = _4874;
                        _4896 = _4875;
                        _4897 = _4876;
                        _4898 = 0.0f;
                        _4900 = _4895;
                        _4901 = _4896;
                        _4902 = _4897;
                        _4903 = _4898;
                      }
                    }
                    break;
                  }
                  if (__loop_jump_target != -1) {
                    break;
                  }
                }
              }
              if (__defer_4315_4358) {
                if ((int)(_4316 + 1) < (int)8) {
                  _4316 = (_4316 + 1);
                  continue;
                } else {
                  _4900 = _4310;
                  _4901 = _4309;
                  _4902 = _4308;
                  _4903 = 0.0f;
                }
              }
              break;
            }
            if (__loop_jump_target == 4305) {
              __loop_jump_target = -1;
              continue;
            }
            if (__loop_jump_target != -1) {
              break;
            }
            break;
          }
        } else {
          _4900 = 0.0f;
          _4901 = 0.0f;
          _4902 = 0.0f;
          _4903 = 0.0f;
        }
        if (_4903 > 0.0f) {
          float _4915 = (_4903 * _4221) + _173;
          float _4916 = (_4903 * _4225) + _174;
          float _4917 = (_4903 * _4228) + _175;
          bool _4920 = (_sunDirection.y > 0.0f);
          if ((_4920) || ((!(_4920)) && (_sunDirection.y > _moonDirection.y))) {
            _4932 = _sunDirection.x;
            _4933 = _sunDirection.y;
            _4934 = _sunDirection.z;
          } else {
            _4932 = _moonDirection.x;
            _4933 = _moonDirection.y;
            _4934 = _moonDirection.z;
          }
          if ((_4920) || ((!(_4920)) && (_sunDirection.y > _moonDirection.y))) {
            _4954 = _precomputedAmbient7.y;
          } else {
            _4954 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
          }
          float _4960 = (_earthRadius + _4916) + _viewPos.y;
          float _4964 = (_4917 * _4917) + (_4915 * _4915);
          float _4966 = sqrt((_4960 * _4960) + _4964);
          float _4971 = dot(float3((_4915 / _4966), (_4960 / _4966), (_4917 / _4966)), float3(_4932, _4933, _4934));
          float _4976 = min(max(((_4966 - _earthRadius) / _atmosphereThickness), 16.0f), (_atmosphereThickness + -16.0f));
          float _4984 = max(_4976, 0.0f);
          float _4991 = (-0.0f - sqrt((_4984 + (_earthRadius * 2.0f)) * _4984)) / (_4984 + _earthRadius);
          if (_4971 > _4991) {
            _5014 = ((exp2(log2(saturate((_4971 - _4991) / (1.0f - _4991))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _5014 = ((exp2(log2(saturate((_4991 - _4971) / (_4991 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float2 _5019 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_4976 + -16.0f) / (_atmosphereThickness + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _5014), 0.0f);
          float _5041 = ((_5019.y * 1.9999999494757503e-05f) * _mieAerosolDensity) * (_mieAerosolAbsorption + 1.0f);
          float _5059 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f)) * _5019.x) + _5041) * -1.4426950216293335f);
          float _5060 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f)) * _5019.x) + _5041) * -1.4426950216293335f);
          float _5061 = exp2(((((_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f)) * _5019.x) + _5041) * -1.4426950216293335f);
          float _5077 = sqrt(_4964);
          float _5085 = (_cloudAltitude - (max(((_5077 * _5077) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
          float _5097 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_4933 > 0.0f))) - ((int)(uint)((int)(_4933 < 0.0f))))) * 0.5f))) + _5085;
          if (_4916 < _5085) {
            float _5100 = dot(float3(0.0f, 1.0f, 0.0f), float3(_4932, _4933, _4934));
            float _5106 = select((abs(_5100) < 9.99999993922529e-09f), 1e+08f, ((_5097 - dot(float3(0.0f, 1.0f, 0.0f), float3(_4915, _4916, _4917))) / _5100));
            _5112 = ((_5106 * _4932) + _4915);
            _5113 = _5097;
            _5114 = ((_5106 * _4934) + _4917);
          } else {
            _5112 = _4915;
            _5113 = _4916;
            _5114 = _4917;
          }
          float _5123 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_5112 * 4.999999873689376e-05f) + 0.5f), ((_5113 - _5085) / _cloudThickness), ((_5114 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
          float _5134 = saturate(abs(_4933) * 4.0f);
          float _5136 = (_5134 * _5134) * exp2(((_distanceScale * -1.4426950216293335f) * _5123.x) * (_cloudScatteringCoefficient / _distanceScale));
          float _5143 = ((1.0f - _5136) * saturate(((_4916 - _cloudThickness) - _5085) * 0.10000000149011612f)) + _5136;
          float _5144 = _5143 * (((_5060 * 0.3395099937915802f) + (_5059 * 0.6131200194358826f)) + (_5061 * 0.047370001673698425f));
          float _5145 = _5143 * (((_5060 * 0.9163600206375122f) + (_5059 * 0.07020000368356705f)) + (_5061 * 0.013450000435113907f));
          float _5146 = _5143 * (((_5060 * 0.10958000272512436f) + (_5059 * 0.02061999961733818f)) + (_5061 * 0.8697999715805054f));
          float _5171 = (_viewPos.x - (_staticShadowPosition[1].x)) + _4915;
          float _5172 = (_viewPos.y - (_staticShadowPosition[1].y)) + _4916;
          float _5173 = (_viewPos.z - (_staticShadowPosition[1].z)) + _4917;
          float _5193 = mad((_shadowProjRelativeTexScale[1][0].z), _5173, mad((_shadowProjRelativeTexScale[1][0].y), _5172, (_5171 * (_shadowProjRelativeTexScale[1][0].x)))) + (_shadowProjRelativeTexScale[1][0].w);
          float _5197 = mad((_shadowProjRelativeTexScale[1][1].z), _5173, mad((_shadowProjRelativeTexScale[1][1].y), _5172, (_5171 * (_shadowProjRelativeTexScale[1][1].x)))) + (_shadowProjRelativeTexScale[1][1].w);
          float _5204 = 2.0f / _shadowSizeAndInvSize.y;
          float _5205 = 1.0f - _5204;
          bool _5212 = ((((((!(_5193 <= _5205))) || ((!(_5193 >= _5204))))) || ((!(_5197 <= _5205))))) || ((!(_5197 >= _5204)));
          float _5224 = (_viewPos.x - (_staticShadowPosition[0].x)) + _4915;
          float _5225 = (_viewPos.y - (_staticShadowPosition[0].y)) + _4916;
          float _5226 = (_viewPos.z - (_staticShadowPosition[0].z)) + _4917;
          float _5246 = mad((_shadowProjRelativeTexScale[0][0].z), _5226, mad((_shadowProjRelativeTexScale[0][0].y), _5225, (_5224 * (_shadowProjRelativeTexScale[0][0].x)))) + (_shadowProjRelativeTexScale[0][0].w);
          float _5250 = mad((_shadowProjRelativeTexScale[0][1].z), _5226, mad((_shadowProjRelativeTexScale[0][1].y), _5225, (_5224 * (_shadowProjRelativeTexScale[0][1].x)))) + (_shadowProjRelativeTexScale[0][1].w);
          bool _5261 = ((((((!(_5246 <= _5205))) || ((!(_5246 >= _5204))))) || ((!(_5250 <= _5205))))) || ((!(_5250 >= _5204)));
          int _5262 = select(_5261, select(_5212, -1, 1), 0);
          float _5263 = select(_5261, select(_5212, 0.0f, _5193), _5246);
          float _5264 = select(_5261, select(_5212, 0.0f, _5197), _5250);
          float _5265 = select(_5261, select(_5212, 0.0f, (mad((_shadowProjRelativeTexScale[1][2].z), _5173, mad((_shadowProjRelativeTexScale[1][2].y), _5172, (_5171 * (_shadowProjRelativeTexScale[1][2].x)))) + (_shadowProjRelativeTexScale[1][2].w))), (mad((_shadowProjRelativeTexScale[0][2].z), _5226, mad((_shadowProjRelativeTexScale[0][2].y), _5225, (_5224 * (_shadowProjRelativeTexScale[0][2].x)))) + (_shadowProjRelativeTexScale[0][2].w)));
          float _5267 = select(((_5261) && (_5212)), 0.0f, 0.0010000000474974513f);
          [branch]
          if (!(_5262 == -1)) {
            float _5273 = (_5263 * _shadowSizeAndInvSize.x) + -0.5f;
            float _5274 = (_5264 * _shadowSizeAndInvSize.y) + -0.5f;
            int _5277 = int(floor(_5273));
            int _5278 = int(floor(_5274));
            if (!((((uint)_5277 > (uint)(int)(uint(_shadowSizeAndInvSize.x)))) || (((uint)_5278 > (uint)(int)(uint(_shadowSizeAndInvSize.y)))))) {
              float4 _5288 = __3__36__0__0__g_shadowDepthArray.Load(int4(_5277, _5278, _5262, 0));
              float4 _5290 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_5277) + 1u)), _5278, _5262, 0));
              float4 _5292 = __3__36__0__0__g_shadowDepthArray.Load(int4(_5277, ((int)((uint)(_5278) + 1u)), _5262, 0));
              float4 _5294 = __3__36__0__0__g_shadowDepthArray.Load(int4(((int)((uint)(_5277) + 1u)), ((int)((uint)(_5278) + 1u)), _5262, 0));
              _5297 = _5288.x;
              _5298 = _5290.x;
              _5299 = _5292.x;
              _5300 = _5294.x;
            } else {
              _5297 = 0.0f;
              _5298 = 0.0f;
              _5299 = 0.0f;
              _5300 = 0.0f;
            }
            float _5326 = (float4(_invShadowViewProj[_5262][0][0], _invShadowViewProj[_5262][1][0], _invShadowViewProj[_5262][2][0], _invShadowViewProj[_5262][3][0]).x) * _5263;
            float _5330 = (float4(_invShadowViewProj[_5262][0][0], _invShadowViewProj[_5262][1][0], _invShadowViewProj[_5262][2][0], _invShadowViewProj[_5262][3][0]).y) * _5263;
            float _5334 = (float4(_invShadowViewProj[_5262][0][0], _invShadowViewProj[_5262][1][0], _invShadowViewProj[_5262][2][0], _invShadowViewProj[_5262][3][0]).z) * _5263;
            float _5338 = (float4(_invShadowViewProj[_5262][0][0], _invShadowViewProj[_5262][1][0], _invShadowViewProj[_5262][2][0], _invShadowViewProj[_5262][3][0]).w) * _5263;
            float _5341 = mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).w), _5297, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).w), _5264, _5338)) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).w);
            float _5342 = (mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).x), _5297, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).x), _5264, _5326)) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).x)) / _5341;
            float _5343 = (mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).y), _5297, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).y), _5264, _5330)) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).y)) / _5341;
            float _5344 = (mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).z), _5297, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).z), _5264, _5334)) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).z)) / _5341;
            float _5347 = _5263 + (_shadowSizeAndInvSize.z * 4.0f);
            float _5363 = mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).w), _5298, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).w), _5264, ((float4(_invShadowViewProj[_5262][0][0], _invShadowViewProj[_5262][1][0], _invShadowViewProj[_5262][2][0], _invShadowViewProj[_5262][3][0]).w) * _5347))) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).w);
            float _5369 = _5264 - (_shadowSizeAndInvSize.w * 2.0f);
            float _5381 = mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).w), _5299, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).w), _5369, _5338)) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).w);
            float _5385 = ((mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).x), _5299, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).x), _5369, _5326)) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).x)) / _5381) - _5342;
            float _5386 = ((mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).y), _5299, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).y), _5369, _5330)) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).y)) / _5381) - _5343;
            float _5387 = ((mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).z), _5299, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).z), _5369, _5334)) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).z)) / _5381) - _5344;
            float _5388 = ((mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).x), _5298, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).x), _5264, ((float4(_invShadowViewProj[_5262][0][0], _invShadowViewProj[_5262][1][0], _invShadowViewProj[_5262][2][0], _invShadowViewProj[_5262][3][0]).x) * _5347))) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).x)) / _5363) - _5342;
            float _5389 = ((mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).y), _5298, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).y), _5264, ((float4(_invShadowViewProj[_5262][0][0], _invShadowViewProj[_5262][1][0], _invShadowViewProj[_5262][2][0], _invShadowViewProj[_5262][3][0]).y) * _5347))) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).y)) / _5363) - _5343;
            float _5390 = ((mad((float4(_invShadowViewProj[_5262][0][2], _invShadowViewProj[_5262][1][2], _invShadowViewProj[_5262][2][2], _invShadowViewProj[_5262][3][2]).z), _5298, mad((float4(_invShadowViewProj[_5262][0][1], _invShadowViewProj[_5262][1][1], _invShadowViewProj[_5262][2][1], _invShadowViewProj[_5262][3][1]).z), _5264, ((float4(_invShadowViewProj[_5262][0][0], _invShadowViewProj[_5262][1][0], _invShadowViewProj[_5262][2][0], _invShadowViewProj[_5262][3][0]).z) * _5347))) + (float4(_invShadowViewProj[_5262][0][3], _invShadowViewProj[_5262][1][3], _invShadowViewProj[_5262][2][3], _invShadowViewProj[_5262][3][3]).z)) / _5363) - _5344;
            float _5393 = (_5387 * _5389) - (_5386 * _5390);
            float _5396 = (_5385 * _5390) - (_5387 * _5388);
            float _5399 = (_5386 * _5388) - (_5385 * _5389);
            float _5401 = rsqrt(dot(float3(_5393, _5396, _5399), float3(_5393, _5396, _5399)));
            float _5405 = frac(_5273);
            float _5410 = (saturate(dot(float3(_4221, _4225, _4228), float3((_5393 * _5401), (_5396 * _5401), (_5399 * _5401)))) * 0.0020000000949949026f) + _5265;
            float _5423 = saturate(exp2((_5297 - _5410) * 1442695.0f));
            float _5425 = saturate(exp2((_5299 - _5410) * 1442695.0f));
            float _5431 = ((saturate(exp2((_5298 - _5410) * 1442695.0f)) - _5423) * _5405) + _5423;
            _5438 = _5297;
            _5439 = _5298;
            _5440 = _5299;
            _5441 = _5300;
            _5442 = saturate((((_5425 - _5431) + ((saturate(exp2((_5300 - _5410) * 1442695.0f)) - _5425) * _5405)) * frac(_5274)) + _5431);
          } else {
            _5438 = 0.0f;
            _5439 = 0.0f;
            _5440 = 0.0f;
            _5441 = 0.0f;
            _5442 = 1.0f;
          }
          float _5462 = mad((_dynamicShadowProjRelativeTexScale[1][0].z), _4917, mad((_dynamicShadowProjRelativeTexScale[1][0].y), _4916, ((_dynamicShadowProjRelativeTexScale[1][0].x) * _4915))) + (_dynamicShadowProjRelativeTexScale[1][0].w);
          float _5466 = mad((_dynamicShadowProjRelativeTexScale[1][1].z), _4917, mad((_dynamicShadowProjRelativeTexScale[1][1].y), _4916, ((_dynamicShadowProjRelativeTexScale[1][1].x) * _4915))) + (_dynamicShadowProjRelativeTexScale[1][1].w);
          float _5470 = mad((_dynamicShadowProjRelativeTexScale[1][2].z), _4917, mad((_dynamicShadowProjRelativeTexScale[1][2].y), _4916, ((_dynamicShadowProjRelativeTexScale[1][2].x) * _4915))) + (_dynamicShadowProjRelativeTexScale[1][2].w);
          float _5473 = 4.0f / _dynmaicShadowSizeAndInvSize.y;
          float _5474 = 1.0f - _5473;
          if (!(((((!(_5462 <= _5474))) || ((!(_5462 >= _5473))))) || ((!(_5466 <= _5474))))) {
            bool _5485 = ((_5470 >= -1.0f)) && ((((_5470 <= 1.0f)) && ((_5466 >= _5473))));
            _5493 = ((int)(uint)((int)(_5485)));
            _5494 = select(_5485, 1, _5262);
            _5495 = select(_5485, _5462, _5263);
            _5496 = select(_5485, _5466, _5264);
            _5497 = select(_5485, _5470, _5265);
            _5498 = select(_5485, 9.999999747378752e-06f, _5267);
          } else {
            _5493 = 0;
            _5494 = _5262;
            _5495 = _5263;
            _5496 = _5264;
            _5497 = _5265;
            _5498 = _5267;
          }
          float _5518 = mad((_dynamicShadowProjRelativeTexScale[0][0].z), _4917, mad((_dynamicShadowProjRelativeTexScale[0][0].y), _4916, ((_dynamicShadowProjRelativeTexScale[0][0].x) * _4915))) + (_dynamicShadowProjRelativeTexScale[0][0].w);
          float _5522 = mad((_dynamicShadowProjRelativeTexScale[0][1].z), _4917, mad((_dynamicShadowProjRelativeTexScale[0][1].y), _4916, ((_dynamicShadowProjRelativeTexScale[0][1].x) * _4915))) + (_dynamicShadowProjRelativeTexScale[0][1].w);
          float _5526 = mad((_dynamicShadowProjRelativeTexScale[0][2].z), _4917, mad((_dynamicShadowProjRelativeTexScale[0][2].y), _4916, ((_dynamicShadowProjRelativeTexScale[0][2].x) * _4915))) + (_dynamicShadowProjRelativeTexScale[0][2].w);
          if (!(((((!(_5518 <= _5474))) || ((!(_5518 >= _5473))))) || ((!(_5522 <= _5474))))) {
            bool _5537 = ((_5526 >= -1.0f)) && ((((_5522 >= _5473)) && ((_5526 <= 1.0f))));
            _5545 = select(_5537, 1, _5493);
            _5546 = select(_5537, 0, _5494);
            _5547 = select(_5537, _5518, _5495);
            _5548 = select(_5537, _5522, _5496);
            _5549 = select(_5537, _5526, _5497);
            _5550 = select(_5537, 9.999999747378752e-06f, _5498);
          } else {
            _5545 = _5493;
            _5546 = _5494;
            _5547 = _5495;
            _5548 = _5496;
            _5549 = _5497;
            _5550 = _5498;
          }
          [branch]
          if (!(_5545 == 0)) {
            int _5560 = int(floor((_5547 * _dynmaicShadowSizeAndInvSize.x) + -0.5f));
            int _5561 = int(floor((_5548 * _dynmaicShadowSizeAndInvSize.y) + -0.5f));
            if (!((((uint)_5560 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.x)))) || (((uint)_5561 > (uint)(int)(uint(_dynmaicShadowSizeAndInvSize.y)))))) {
              float4 _5571 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_5560, _5561, _5546, 0));
              float4 _5573 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_5560) + 1u)), _5561, _5546, 0));
              float4 _5575 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(_5560, ((int)((uint)(_5561) + 1u)), _5546, 0));
              float4 _5577 = __3__36__0__0__g_dynamicShadowDepthArray.Load(int4(((int)((uint)(_5560) + 1u)), ((int)((uint)(_5561) + 1u)), _5546, 0));
              _5580 = _5571.x;
              _5581 = _5573.x;
              _5582 = _5575.x;
              _5583 = _5577.x;
            } else {
              _5580 = _5438;
              _5581 = _5439;
              _5582 = _5440;
              _5583 = _5441;
            }
            if ((_4920) || ((!(_4920)) && (_sunDirection.y > _moonDirection.y))) {
              _5595 = _sunDirection.x;
              _5596 = _sunDirection.y;
              _5597 = _sunDirection.z;
            } else {
              _5595 = _moonDirection.x;
              _5596 = _moonDirection.y;
              _5597 = _moonDirection.z;
            }
            float _5603 = (_5550 - (saturate(-0.0f - dot(float3(_5595, _5596, _5597), float3(_4221, _4225, _4228))) * 9.999999747378752e-05f)) + _5549;
            _5616 = min(float((bool)(uint)(_5580 > _5603)), min(min(float((bool)(uint)(_5581 > _5603)), float((bool)(uint)(_5582 > _5603))), float((bool)(uint)(_5583 > _5603))));
          } else {
            _5616 = _5442;
          }
          float _5624 = (_viewPos.x - _shadowRelativePosition.x) + _4915;
          float _5625 = (_viewPos.y - _shadowRelativePosition.y) + _4916;
          float _5626 = (_viewPos.z - _shadowRelativePosition.z) + _4917;
          float _5646 = mad((_terrainShadowProjRelativeTexScale[0].z), _5626, mad((_terrainShadowProjRelativeTexScale[0].y), _5625, (_5624 * (_terrainShadowProjRelativeTexScale[0].x)))) + (_terrainShadowProjRelativeTexScale[0].w);
          float _5650 = mad((_terrainShadowProjRelativeTexScale[1].z), _5626, mad((_terrainShadowProjRelativeTexScale[1].y), _5625, (_5624 * (_terrainShadowProjRelativeTexScale[1].x)))) + (_terrainShadowProjRelativeTexScale[1].w);
          float _5654 = mad((_terrainShadowProjRelativeTexScale[2].z), _5626, mad((_terrainShadowProjRelativeTexScale[2].y), _5625, (_5624 * (_terrainShadowProjRelativeTexScale[2].x)))) + (_terrainShadowProjRelativeTexScale[2].w);
          if (saturate(_5646) == _5646) {
            if (((_5654 >= 9.999999747378752e-05f)) && ((((_5654 <= 1.0f)) && ((saturate(_5650) == _5650))))) {
              float _5669 = frac((_5646 * 1024.0f) + -0.5f);
              float4 _5673 = __3__36__0__0__g_terrainShadowDepth.GatherRed(__0__4__0__0__g_staticPointClamp, float2(_5646, _5650));
              float _5678 = _5654 + -0.004999999888241291f;
              float _5683 = select((_5673.w > _5678), 1.0f, 0.0f);
              float _5685 = select((_5673.x > _5678), 1.0f, 0.0f);
              float _5692 = ((select((_5673.z > _5678), 1.0f, 0.0f) - _5683) * _5669) + _5683;
              _5698 = saturate((((((select((_5673.y > _5678), 1.0f, 0.0f) - _5685) * _5669) + _5685) - _5692) * frac((_5650 * 1024.0f) + -0.5f)) + _5692);
            } else {
              _5698 = 1.0f;
            }
          } else {
            _5698 = 1.0f;
          }
          float _5701 = _4903 * 20.0f;
          float _5702 = _5701 * _5701;
          float _5711 = (((exp2(_5702 * -0.48089835047721863f) * 3.0f) + exp2(_5702 * -1.4426950216293335f)) * 0.25f) * (saturate(min(_5616, _5698)) * _4954);
          _5716 = (_5711 * (((_5144 * 0.6131200194358826f) + (_5145 * 0.3395099937915802f)) + (_5146 * 0.047370001673698425f)));
          _5717 = (_5711 * (((_5144 * 0.07020000368356705f) + (_5145 * 0.9163600206375122f)) + (_5146 * 0.013450000435113907f)));
          _5718 = (_5711 * (((_5144 * 0.02061999961733818f) + (_5145 * 0.10958000272512436f)) + (_5146 * 0.8697999715805054f)));
        } else {
          _5716 = -0.0f;
          _5717 = -0.0f;
          _5718 = -0.0f;
        }
        float _5724 = saturate(1.0f - (_178 * 0.0010000000474974513f));
        _5732 = ((_5724 * (_5716 - min(0.0f, (-0.0f - _4900)))) + _4130);
        _5733 = ((_5724 * (_5717 - min(0.0f, (-0.0f - _4901)))) + _4131);
        _5734 = (((_5718 - min(0.0f, (-0.0f - _4902))) * _5724) + _4132);
        break;
      }
    } else {
      _5732 = _4130;
      _5733 = _4131;
      _5734 = _4132;
    }
    // RenoDX: Exterior GI energy compensation
    // The improved ReSTIR convergence over accumulates diffuse bounces.
    // Exteriors become way to bright so as a solution we do the following
    //
    // Apply a luminance based soft compression on the raw hit radiance before it
    // enters the reservoir
    if (RT_QUALITY >= 0.5f && RT_GI_STRENGTH > 0.0f) {
      float _rndx_gi_lum = dot(float3(_5732, _5733, _5734), float3(0.2127f, 0.7152f, 0.0722f));
      if (_rndx_gi_lum > RT_GI_KNEE) {
        float _rndx_gi_excess = _rndx_gi_lum - RT_GI_KNEE;
        float _rndx_gi_compressed = RT_GI_KNEE + _rndx_gi_excess / (1.0f + _rndx_gi_excess * RT_GI_STRENGTH);
        float _rndx_gi_scale = _rndx_gi_compressed / max(1e-7f, _rndx_gi_lum);
        _5732 *= _rndx_gi_scale;
        _5733 *= _rndx_gi_scale;
        _5734 *= _rndx_gi_scale;
      }
    }
    __3__38__0__1__g_diffuseResultUAV[int2(((int)((((uint)(((int)((uint)(_72) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_53 - (_54 << 1)) << 4)))), ((int)((((uint)(_54 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_72)) >> 16) << 5)))))] = half4((-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _5732)))))), (-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _5733)))))), (-0.0h - half(min(0.0f, (-0.0f - min(15000.0f, (_exposure4.x * _5734)))))), half(1.0f - _4084));
    break;
  }
}