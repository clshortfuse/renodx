#include "../shared.h"
#include "diffuse_brdf.hlsli"

Texture2D<float4> __3__36__0__0__g_puddleMask : register(t87, space36);

Texture2D<float4> __3__36__0__0__g_climateSandTex : register(t165, space36);

Texture2D<uint16_t> __3__36__0__0__g_sceneDecalMask : register(t166, space36);

Texture2D<float2> __3__36__0__0__g_texNetDensity : register(t19, space36);

Texture3D<float> __3__36__0__0__g_texCloudVolumeShadow : register(t195, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t0, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t152, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t79, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormalPrev : register(t91, space36);

Texture2D<float2> __3__36__0__0__g_velocity : register(t92, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t39, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaque : register(t49, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaquePrev : register(t94, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t50, space36);

Texture2D<float4> __3__36__0__0__g_specularResult : register(t97, space36);

Texture2D<float> __3__36__0__0__g_specularRayHitDistance : register(t180, space36);

Texture2D<float4> __3__36__0__0__g_manyLightsMoments : register(t160, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t98, space36);

Texture2D<half4> __3__36__0__0__g_sceneDiffuse : register(t156, space36);

Texture2D<half4> __3__36__0__0__g_diffuseResult : register(t26, space36);

Texture2D<half4> __3__36__0__0__g_diffuseResultPrev : register(t168, space36);

Texture2D<half4> __3__36__0__0__g_specularResultPrev : register(t27, space36);

Texture2D<half2> __3__36__0__0__g_sceneAO : register(t28, space36);

Texture2D<float> __3__36__0__0__g_caustic : register(t29, space36);

Texture2D<uint> __3__36__0__0__g_tiledManyLightsMasks : register(t53, space36);

ByteAddressBuffer __3__37__0__0__g_structureCounterBuffer : register(t27, space37);

Texture2D<half4> __3__36__0__0__g_sceneShadowColor : register(t22, space36);

RWTexture2D<float4> __3__38__0__1__g_diffuseHalfPrevUAV : register(u40, space38);

RWTexture2D<float4> __3__38__0__1__g_sceneColorUAV : register(u10, space38);

RWTexture2D<half4> __3__38__0__1__g_sceneSpecularUAV : register(u11, space38);

RWTexture2D<half4> __3__38__0__1__g_diffuseResultUAV : register(u12, space38);

RWTexture2D<half4> __3__38__0__1__g_specularResultUAV : register(u13, space38);

RWTexture2D<half4> __3__38__0__1__g_sceneColorLightingOnlyForAwbUAV : register(u18, space38);

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

cbuffer __3__35__0__0__ExposureConstantBuffer : register(b34, space35) {
  float4 _exposure0 : packoffset(c000.x);
  float4 _exposure1 : packoffset(c001.x);
  float4 _exposure2 : packoffset(c002.x);
  float4 _exposure3 : packoffset(c003.x);
  float4 _exposure4 : packoffset(c004.x);
};

cbuffer __3__35__0__0__WeatherConstantBuffer : register(b49, space35) {
  float _rain : packoffset(c000.x);
  float _windSpeed : packoffset(c000.y);
  float _puddleRate : packoffset(c000.z);
  float _humidity : packoffset(c000.w);
  float _puddleScale : packoffset(c001.x);
  float2 _windDir : packoffset(c001.y);
  float _snowAmount : packoffset(c001.w);
  float _snowDetail : packoffset(c002.x);
  float _iceRate : packoffset(c002.y);
  float _snowRate : packoffset(c002.z);
  uint _weatherCheckFlag : packoffset(c002.w);
  float2 _climateTextureOnePixelMeter : packoffset(c003.x);
  float2 _cloudScroll : packoffset(c003.z);
  int2 _climateTextureSize : packoffset(c004.x);
  float _heightScaleMin : packoffset(c004.z);
  float _heightScaleMax : packoffset(c004.w);
  float _temperatureSnowStart : packoffset(c005.x);
  float _temperatureSnowEnd : packoffset(c005.y);
  float _temperatureDeformableSnowStart : packoffset(c005.z);
  float _tempeartureDeformableSnowEnd : packoffset(c005.w);
  float _rainDropletAmount : packoffset(c006.x);
  float _rainDropletRate : packoffset(c006.y);
  float _puddleCloudAltitude : packoffset(c006.z);
  float _puddleCloudThickenss : packoffset(c006.w);
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

cbuffer __3__35__0__0__EnvironmentLightingHistoryConstantBuffer : register(b0, space35) {
  float4 _environmentLightingHistory[4] : packoffset(c000.x);
};

cbuffer __3__1__0__0__WeatherShadingConstants : register(b1, space1) {
  int4 _paramWeather : packoffset(c000.x);
  float4 _paramShading : packoffset(c001.x);
  int2 _readBackBufferSize : packoffset(c002.x);
  float _readBackFieldSize : packoffset(c002.z);
  int _enableSandAO : packoffset(c002.w);
  float4 _blurSourceSize : packoffset(c003.x);
  float4 _blurTargetSize : packoffset(c004.x);
  float2 _paramGlobalSand : packoffset(c005.x);
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

SamplerState __3__40__0__0__g_samplerPoint : register(s4, space40);

SamplerState __0__4__0__0__g_staticBilinearWrapUWClampV : register(s1, space4);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _47[4];
  int _60 = (int)(SV_GroupID.x) & 15;
  int _61 = (uint)((uint)(_60)) >> 2;
  _47[0] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).x);
  _47[1] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).y);
  _47[2] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).z);
  _47[3] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).w);
  int _79 = _47[(((uint)(SV_GroupID.x) >> 4) & 3)];
  float _90 = float((uint)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))) + 0.5f;
  float _91 = float((uint)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))) + 0.5f;
  float _95 = _bufferSizeAndInvSize.z * _90;
  float _96 = _91 * _bufferSizeAndInvSize.w;
  float _98 = __3__36__0__0__g_depth.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
  uint2 _101 = __3__36__0__0__g_stencil.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
  int _103 = _101.x & 127;
  float _106 = max(1.0000000116860974e-07f, _98.x);
  float _107 = _nearFarProj.x / _106;
  float _300;
  float _301;
  float _302;
  bool _318;
  bool _339;
  half _347;
  float _400;
  float _411;
  float _412;
  float _420;
  float _421;
  half _422;
  half _423;
  half _424;
  half _425;
  half _426;
  bool _460;
  float _469;
  float _510;
  float _511;
  float _598;
  float _676;
  float _849;
  float _850;
  float _851;
  float _852;
  float _1017;
  int _1018;
  float _1075;
  float _1191;
  float _1192;
  float _1193;
  float _1194;
  float _1221;
  half _1246;
  bool _1258;
  half _1265;
  float _1550;
  float _1567;
  float _1571;
  float _1599;
  float _1643;
  float _1644;
  float _1645;
  float _1646;
  float _1650;
  float _1651;
  float _1652;
  float _1653;
  float _1656;
  float _1657;
  float _1658;
  float _1659;
  half _1660;
  float _1775;
  int _1776;
  int _1777;
  float _1778;
  float _1779;
  float _1780;
  float _1781;
  float _1906;
  float _1907;
  float _1908;
  float _1970;
  float _1980;
  float _1981;
  float _1982;
  bool _2056;
  bool _2057;
  float _2093;
  float _2094;
  float _2095;
  float _2096;
  float _2162;
  float _2165;
  float _2166;
  float _2167;
  float _2168;
  float _2203;
  float _2204;
  float _2205;
  float _2220;
  float _2249;
  float _2250;
  float _2251;
  float _2252;
  float _2253;
  half _2260;
  half _2261;
  half _2262;
  half _2263;
  half _2264;
  float _2265;
  half _2301;
  half _2302;
  half _2303;
  float _2318;
  float _2319;
  float _2320;
  float _2340;
  float _2400;
  float _2497;
  float _2498;
  float _2499;
  bool _2562;
  bool _2571;
  bool _2574;
  bool _2575;
  int _2589;
  float _2632;
  float _2633;
  float _2634;
  bool _2713;
  float _2721;
  float _2732;
  float _2767;
  float _2774;
  float _2775;
  float _2776;
  float _2825;
  float _2826;
  float _2827;
  float _2836;
  float _2880;
  half _2932;
  half _2933;
  half _2934;
  float _2944;
  bool _3097;
  float _3133;
  float _3134;
  float _3135;
  float _3149;
  float _3150;
  float _3151;
  float _3170;
  float _3171;
  float _3172;
  if (!(((((_98.x < 1.0000000116860974e-07f)) || ((_98.x == 1.0f)))) || ((_103 == 10)))) {
    uint4 _115 = __3__36__0__0__g_baseColor.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
    float4 _121 = __3__36__0__0__g_normal.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
    half _130 = half(float((uint)((uint)(((uint)((uint)(_115.x)) >> 8) & 255))) * 0.003921568859368563f);
    half _134 = half(float((uint)((uint)(_115.x & 255))) * 0.003921568859368563f);
    half _139 = half(float((uint)((uint)(((uint)((uint)(_115.y)) >> 8) & 255))) * 0.003921568859368563f);
    half _148 = half(float((uint)((uint)(((uint)((uint)(_115.z)) >> 8) & 255))) * 0.003921568859368563f);
    uint _164 = uint((_121.w * 3.0f) + 0.5f);
    bool _165 = ((int)(_164) == 1);
    bool _166 = ((int)(_164) == 3);
    float _176 = (saturate(_121.x * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _177 = (saturate(_121.y * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _178 = (saturate(_121.z * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _180 = rsqrt(dot(float3(_176, _177, _178), float3(_176, _177, _178)));
    half _185 = half(_180 * _177);
    half _186 = half(_178 * _180);
    half _189 = (half(float((uint)((uint)(((uint)((uint)(_115.w)) >> 8) & 255))) * 0.003921568859368563f) * 2.0h) + -1.0h;
    half _190 = (half(float((uint)((uint)(_115.w & 255))) * 0.003921568859368563f) * 2.0h) + -1.0h;
    float _195 = float(_189 + _190) * 0.5f;
    float _196 = float(_189 - _190) * 0.5f;
    float _200 = (1.0f - abs(_195)) - abs(_196);
    float _202 = rsqrt(dot(float3(_195, _196, _200), float3(_195, _196, _200)));
    float _209 = float(half(_180 * _176));
    float _210 = float(_185);
    float _211 = float(_186);
    float _213 = select((_186 >= 0.0h), 1.0f, -1.0f);
    float _216 = -0.0f - (1.0f / (_213 + _211));
    float _217 = _210 * _216;
    float _218 = _217 * _209;
    float _219 = _213 * _209;
    float _226 = float(half(_202 * _195));
    float _227 = float(half(_202 * _196));
    float _228 = float(half(_202 * _200));
    half _240 = half(mad(_228, _209, mad(_227, _218, (_226 * (((_219 * _209) * _216) + 1.0f)))));
    half _241 = half(mad(_228, _210, mad(_227, ((_217 * _210) + _213), ((_226 * _213) * _218))));
    half _242 = half(mad(_228, _211, mad(_227, (-0.0f - _210), (-0.0f - (_219 * _226)))));
    half _244 = rsqrt(dot(half3(_240, _241, _242), half3(_240, _241, _242)));
    half _245 = _244 * _240;
    half _246 = _244 * _241;
    half _247 = _244 * _242;
    half _251 = saturate(_130 * _130);
    half _252 = saturate(_134 * _134);
    half _253 = saturate(_139 * _139);
    half _269 = saturate(((_252 * 0.3395996h) + (_251 * 0.61328125h)) + (_253 * 0.04736328h));
    half _270 = saturate(((_252 * 0.9165039h) + (_251 * 0.07019043h)) + (_253 * 0.013450623h));
    half _271 = saturate(((_252 * 0.109558105h) + (_251 * 0.020614624h)) + (_253 * 0.8696289h));
    bool _273 = (_103 == 29);
    bool _274 = ((_103 == 24)) || (_273);
    half4 _277 = __3__36__0__0__g_diffuseResult.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
    float _281 = float(_277.x);
    float _282 = float(_277.y);
    float _283 = float(_277.z);
    [branch]
    if (_renderParams2.y > 0.0f) {
      half4 _289 = __3__36__0__0__g_sceneDiffuse.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
      _300 = (float(_289.x) + _281);
      _301 = (float(_289.y) + _282);
      _302 = (float(_289.z) + _283);
    } else {
      _300 = _281;
      _301 = _282;
      _302 = _283;
    }
    float4 _304 = __3__36__0__0__g_specularResult.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
    bool _308 = ((uint)_103 > (uint)11);
    if (_308) {
      if (!((((uint)_103 < (uint)21)) || ((_103 == 107)))) {
        _318 = (_103 == 7);
      } else {
        _318 = true;
      }
    } else {
      if (!(_103 == 6)) {
        _318 = (_103 == 7);
      } else {
        _318 = true;
      }
    }
    float _325 = -0.0f - min(0.0f, (-0.0f - _300));
    float _326 = -0.0f - min(0.0f, (-0.0f - _301));
    float _327 = -0.0f - min(0.0f, (-0.0f - _302));
    half2 _329 = __3__36__0__0__g_sceneAO.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
    bool __defer_317_338 = false;
    if (_308) {
      if ((uint)_103 < (uint)20) {
        _347 = 0.0h;
      } else {
        _339 = ((uint)_103 < (uint)19);
        if (((_103 == 65)) || ((((((_103 == 107)) || ((_103 == 96)))) || (_339)))) {
          _347 = 0.0h;
        } else {
          _347 = select(_274, 0.0h, half(float((uint)((uint)(_115.y & 255))) * 0.003921568859368563f));
        }
      }
    } else {
      if ((uint)_103 > (uint)10) {
        _347 = 0.0h;
      } else {
        _339 = false;
        if (((_103 == 65)) || ((((((_103 == 107)) || ((_103 == 96)))) || (_339)))) {
          _347 = 0.0h;
        } else {
          _347 = select(_274, 0.0h, half(float((uint)((uint)(_115.y & 255))) * 0.003921568859368563f));
        }
      }
    }
    if (__defer_317_338) {
      if (((_103 == 65)) || ((((((_103 == 107)) || ((_103 == 96)))) || (_339)))) {
      } else {
        _347 = select(_274, 0.0h, half(float((uint)((uint)(_115.y & 255))) * 0.003921568859368563f));
      }
    }
    float _349 = (_95 * 2.0f) + -1.0f;
    float _351 = 1.0f - (_96 * 2.0f);
    float _387 = mad((_invViewProjRelative[3].z), _106, mad((_invViewProjRelative[3].y), _351, ((_invViewProjRelative[3].x) * _349))) + (_invViewProjRelative[3].w);
    float _388 = (mad((_invViewProjRelative[0].z), _106, mad((_invViewProjRelative[0].y), _351, ((_invViewProjRelative[0].x) * _349))) + (_invViewProjRelative[0].w)) / _387;
    float _389 = (mad((_invViewProjRelative[1].z), _106, mad((_invViewProjRelative[1].y), _351, ((_invViewProjRelative[1].x) * _349))) + (_invViewProjRelative[1].w)) / _387;
    float _390 = (mad((_invViewProjRelative[2].z), _106, mad((_invViewProjRelative[2].y), _351, ((_invViewProjRelative[2].x) * _349))) + (_invViewProjRelative[2].w)) / _387;
    float _392 = rsqrt(dot(float3(_388, _389, _390), float3(_388, _389, _390)));
    bool _394 = ((uint)(_101.x & 24) > (uint)23);
    if (_394) {
      if (_273) {
        _400 = float(saturate(_148));
      } else {
        _400 = 0.0f;
      }
      uint _402 = uint((float)(half(float((uint)((uint)(_115.z & 255))) * 0.003921568859368563f) * 255.0h));
      if (_165) {
        _411 = select((((int)(_402) & 128) != 0), 1.0f, 0.0f);
        _412 = (float((uint)((uint)((int)(_402) & 127))) * 0.007874015718698502f);
      } else {
        _411 = 0.0f;
        _412 = 0.0f;
      }
      half _413 = half(_412);
      bool _415 = (_413 > 0.99902344h);
      _420 = _411;
      _421 = _400;
      _422 = _413;
      _423 = select(_274, 0.010002136h, _148);
      _424 = select(_415, 1.0h, _269);
      _425 = select(_415, 1.0h, _270);
      _426 = select(_415, 1.0h, _271);
    } else {
      _420 = 0.0f;
      _421 = 0.0f;
      _422 = _347;
      _423 = _148;
      _424 = _269;
      _425 = _270;
      _426 = _271;
    }
    // RenoDX: Foliage green desaturation
    if (FOLIAGE_GREEN_DESAT > 0.0f && ((uint)(_103 - 12) < 7u)) {
      float _fdr = float(_424);
      float _fdg = float(_425);
      float _fdb = float(_426);
      float _fdLum = dot(float3(_fdr, _fdg, _fdb), float3(0.2127f, 0.7152f, 0.0722f));
      float _fdGreenExcess = saturate((_fdg - max(_fdr, _fdb)) * 2.0f);
      float _fdAmount = FOLIAGE_GREEN_DESAT * _fdGreenExcess;
      _fdr = lerp(_fdr, _fdLum, _fdAmount);
      _fdg = lerp(_fdg, _fdLum, _fdAmount);
      _fdb = lerp(_fdb, _fdLum, _fdAmount);
      float _fdDim = lerp(1.0f, 0.90f, _fdAmount);
      _424 = half(_fdr * _fdDim);
      _425 = half(_fdg * _fdDim);
      _426 = half(_fdb * _fdDim);
    }
    float _427 = float(_245);
    float _428 = float(_246);
    float _429 = float(_247);
    float _430 = _392 * _388;
    float _431 = -0.0f - _430;
    float _432 = _392 * _389;
    float _433 = -0.0f - _432;
    float _434 = _392 * _390;
    float _435 = -0.0f - _434;
    float _437 = saturate(dot(float3(_431, _433, _435), float3(_427, _428, _429)));
    bool _439 = ((_101.x & 128) == 0);
    if (_439) {
      if ((uint)_103 > (uint)52) {
        if (!((((_101.x & 125) == 105)) || (((uint)_103 < (uint)68)))) {
          _460 = (_103 == 98);
        } else {
          _460 = true;
        }
      } else {
        if ((uint)_103 > (uint)10) {
          if ((uint)_103 < (uint)20) {
            if ((_101.x & 126) == 14) {
              _460 = (_103 == 98);
            } else {
              _460 = true;
            }
          } else {
            if (!((_101.x & 125) == 105)) {
              _460 = (_103 == 98);
            } else {
              _460 = true;
            }
          }
        } else {
          _460 = (_103 == 98);
        }
      }
    } else {
      _460 = true;
    }
    [branch]
    if (_394) {
      uint _463 = __3__36__0__0__g_depthOpaque.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
      _469 = (float((uint)((uint)(_463.x & 16777215))) * 5.960465188081798e-08f);
    } else {
      _469 = _98.x;
    }
    float _497 = mad((_projToPrevProj[3].z), _469, mad((_projToPrevProj[3].y), _351, ((_projToPrevProj[3].x) * _349))) + (_projToPrevProj[3].w);
    if (_460) {
      float2 _504 = __3__36__0__0__g_velocity.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
      _510 = (_504.x * 2.0f);
      _511 = (_504.y * 2.0f);
    } else {
      _510 = (((mad((_projToPrevProj[0].z), _469, mad((_projToPrevProj[0].y), _351, ((_projToPrevProj[0].x) * _349))) + (_projToPrevProj[0].w)) / _497) - _349);
      _511 = (((mad((_projToPrevProj[1].z), _469, mad((_projToPrevProj[1].y), _351, ((_projToPrevProj[1].x) * _349))) + (_projToPrevProj[1].w)) / _497) - _351);
    }
    float _513 = _nearFarProj.x / max(1.0000000116860974e-07f, _469);
    float _516 = (_510 * 0.5f) + _95;
    float _517 = _96 - (_511 * 0.5f);
    float _525 = select((((((_516 < 0.0f)) || ((_516 > 1.0f)))) || ((((_517 < 0.0f)) || ((_517 > 1.0f))))), 1.0f, 0.0f);
    float _530 = (_516 * _bufferSizeAndInvSize.x) + -0.5f;
    float _531 = (_517 * _bufferSizeAndInvSize.y) + -0.5f;
    int _534 = int(floor(_530));
    int _535 = int(floor(_531));
    float _536 = float((int)(_534));
    float _537 = float((int)(_535));
    float _540 = (_536 + 0.5f) * _bufferSizeAndInvSize.z;
    float _541 = (_537 + 0.5f) * _bufferSizeAndInvSize.w;
    int4 _544 = __3__36__0__0__g_depthOpaquePrev.GatherRed(__3__40__0__0__g_samplerPoint, float2(_540, _541));
    int _567 = asint(((((uint)((uint)((uint)(_544.w)) >> 24))) * (16777216u)) + ((uint)(asint(((((uint)((uint)((uint)(_544.z)) >> 24))) * (65536u)) + ((uint)(asint(((((uint)((uint)((uint)(_544.y)) >> 24))) * (256u)) + (((uint)((uint)((uint)(_544.x)) >> 24))))))))));
    if (_439) {
      if ((uint)_103 > (uint)52) {
        if (!(((_103 == 98)) || (((((_101.x & 125) == 105)) || (((uint)_103 < (uint)68)))))) {
          _598 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z));
        } else {
          _598 = 0.0f;
        }
      } else {
        if ((uint)_103 > (uint)10) {
          if ((uint)_103 < (uint)20) {
            if ((_101.x & 126) == 14) {
              _598 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z));
            } else {
              _598 = 0.0f;
            }
          } else {
            if (!((_101.x & 125) == 105)) {
              _598 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z));
            } else {
              _598 = 0.0f;
            }
          }
        } else {
          _598 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z));
        }
      }
    } else {
      _598 = 0.0f;
    }
    float _606 = _screenPercentage.x * 2.0f;
    float _607 = _606 * abs(_95 + -0.5f);
    float _608 = _screenPercentage.y * 2.0f;
    float _609 = _608 * abs(_96 + -0.5f);
    float _613 = sqrt(dot(float2(_607, _609), float2(_607, _609)) + 1.0f) * _513;
    float _630 = _606 * abs(_516 + -0.5f);
    float _631 = _608 * abs(_517 + -0.5f);
    float _634 = sqrt(dot(float2(_630, _631), float2(_630, _631)) + 1.0f);
    bool _649 = (((uint)(_103 + -97) < (uint)2)) || (_318);
    float _651 = _513 * _513;
    float _653 = (_651 * select(_649, 0.5f, 0.20000000298023224f)) + 1.0f;
    bool _657 = ((uint)(_103 + -53) < (uint)15);
    if (_657) {
      _676 = (1000.0f - (saturate(float((bool)(uint)((sqrt(((_diffViewPosAccurate.x * _diffViewPosAccurate.x) + (_diffViewPosAccurate.y * _diffViewPosAccurate.y)) + (_diffViewPosAccurate.z * _diffViewPosAccurate.z)) * 50.0f) > 1.0f))) * 875.0f));
    } else {
      _676 = 50.0f;
    }
    bool _685 = ((_103 == 57)) || (_657);
    float _686 = select(_685, 0.0f, ((max(0.0f, (_513 + -1.0f)) * 0.10000000149011612f) * _temporalReprojectionParams.y));
    float _691 = max(0.0f, (abs(_613 - (_634 * ((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_544.x & 16777215))) * 5.960465188081798e-08f))) - _598))) - _686));
    float _692 = max(0.0f, (abs(_613 - (_634 * ((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_544.y & 16777215))) * 5.960465188081798e-08f))) - _598))) - _686));
    float _693 = max(0.0f, (abs(_613 - (_634 * ((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_544.z & 16777215))) * 5.960465188081798e-08f))) - _598))) - _686));
    float _694 = max(0.0f, (abs(_613 - (_634 * ((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_544.w & 16777215))) * 5.960465188081798e-08f))) - _598))) - _686));
    float _695 = _691 * _691;
    float _696 = _692 * _692;
    float _697 = _693 * _693;
    float _698 = _694 * _694;
    float _700 = (-1.4426950216293335f / ((_651 * 0.10000000149011612f) + 1.0f)) * select(_649, 0.20000000298023224f, _676);
    float _713 = select((_695 > _653), 0.0f, exp2(_695 * _700));
    float _714 = select((_696 > _653), 0.0f, exp2(_696 * _700));
    float _715 = select((_697 > _653), 0.0f, exp2(_697 * _700));
    float _716 = select((_698 > _653), 0.0f, exp2(_698 * _700));
    int _717 = _101.x & 126;
    if (!_394) {
      bool _721 = ((_717 == 66)) || ((_103 == 54));
      int _722 = _567 & 127;
      int _723 = _567 & 32512;
      int _724 = _567 & 8323072;
      int _725 = _567 & 2130706432;
      bool _764 = ((_722 == 57)) || (((uint)(_722 + -53) < (uint)15));
      bool _765 = ((_723 == 14592)) || (((uint)((((uint)((uint)(_567)) >> 8) & 127) + -53) < (uint)15));
      bool _766 = ((_724 == 3735552)) || (((uint)((((uint)((uint)(_567)) >> 16) & 127) + -53) < (uint)15));
      bool _767 = ((_725 == 956301312)) || (((uint)((((uint)((uint)(_567)) >> 24) & 127) + -53) < (uint)15));
      bool _780 = (_685) || ((!_439));
      bool _789 = (_103 == 6);
      bool _811 = ((uint)(_103 + -105) < (uint)3);
      _849 = (float((bool)((uint)((((_721) || ((((_722 != 54)) && (((_567 & 126) != 66)))))) && ((!(((((_789 ^ (_722 == 6))) || ((((_685 ^ _764)) || ((_811 ^ (((_722 == 107)) || (((uint)(_722 + -105) < (uint)2))))))))) || ((((((_567 & 128) != 0)) || (_764)) ^ _780)))))))) * _713);
      _850 = (float((bool)((uint)((((_721) || ((((_723 != 13824)) && (((_567 & 32256) != 16896)))))) && ((!(((((_789 ^ (_723 == 1536))) || ((((_811 ^ ((((_567 & 32000) == 26880)) || ((_723 == 27136))))) || ((_685 ^ _765)))))) || ((((((_567 & 32768) != 0)) || (_765)) ^ _780)))))))) * _714);
      _851 = (float((bool)((uint)((((_721) || ((((_724 != 3538944)) && (((_567 & 8257536) != 4325376)))))) && ((!(((((_789 ^ (_724 == 393216))) || ((((_811 ^ ((((_567 & 8192000) == 6881280)) || ((_724 == 6946816))))) || ((_685 ^ _766)))))) || ((((((_567 & 8388608) != 0)) || (_766)) ^ _780)))))))) * _715);
      _852 = (float((bool)((uint)((((_721) || ((((_725 != 905969664)) && (((_567 & 2113929216) != 1107296256)))))) && ((!(((((_789 ^ (_725 == 100663296))) || ((((_811 ^ ((((_567 & 2097152000) == 1761607680)) || ((_725 == 1778384896))))) || ((_685 ^ _767)))))) || ((((((int)_567 < (int)0)) || (_767)) ^ _780)))))))) * _716);
    } else {
      _849 = _713;
      _850 = _714;
      _851 = _715;
      _852 = _716;
    }
    int4 _854 = __3__36__0__0__g_sceneNormalPrev.GatherRed(__3__40__0__0__g_samplerPoint, float2(_540, _541));
    float _873 = min(1.0f, ((float((uint)((uint)(_854.w & 1023))) * 0.001956947147846222f) + -1.0f));
    float _874 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_854.w)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _875 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_854.w)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _877 = rsqrt(dot(float3(_873, _874, _875), float3(_873, _874, _875)));
    float _882 = saturate(dot(float3(_427, _428, _429), float3((_877 * _873), (_877 * _874), (_877 * _875))));
    float _897 = min(1.0f, ((float((uint)((uint)(_854.z & 1023))) * 0.001956947147846222f) + -1.0f));
    float _898 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_854.z)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _899 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_854.z)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _901 = rsqrt(dot(float3(_897, _898, _899), float3(_897, _898, _899)));
    float _906 = saturate(dot(float3(_427, _428, _429), float3((_901 * _897), (_901 * _898), (_901 * _899))));
    float _921 = min(1.0f, ((float((uint)((uint)(_854.x & 1023))) * 0.001956947147846222f) + -1.0f));
    float _922 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_854.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _923 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_854.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _925 = rsqrt(dot(float3(_921, _922, _923), float3(_921, _922, _923)));
    float _930 = saturate(dot(float3(_427, _428, _429), float3((_925 * _921), (_925 * _922), (_925 * _923))));
    float _945 = min(1.0f, ((float((uint)((uint)(_854.y & 1023))) * 0.001956947147846222f) + -1.0f));
    float _946 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_854.y)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _947 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_854.y)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _949 = rsqrt(dot(float3(_945, _946, _947), float3(_945, _946, _947)));
    float _954 = saturate(dot(float3(_427, _428, _429), float3((_949 * _945), (_949 * _946), (_949 * _947))));
    bool _955 = (_717 == 66);
    bool _957 = (_103 == 54);
    float _959 = select(((_957) || (((_649) || (_955)))), 0.009999999776482582f, 1.0f);
    float _976 = _530 - _536;
    float _977 = _531 - _537;
    float _978 = 1.0f - _976;
    float _979 = 1.0f - _977;
    float _984 = (_978 * _977) * _849;
    float _986 = (_977 * _976) * _850;
    float _988 = (_979 * _976) * _851;
    float _990 = (_979 * _978) * _852;
    float _992 = saturate(select(_394, 1.0f, (pow(_930, _959))) * _984);
    float _993 = saturate(select(_394, 1.0f, (pow(_954, _959))) * _986);
    float _994 = saturate(select(_394, 1.0f, (pow(_906, _959))) * _988);
    float _995 = saturate(select(_394, 1.0f, (pow(_882, _959))) * _990);
    int4 _997 = asint(__3__37__0__0__g_structureCounterBuffer.Load4(8));
    [branch]
    if (!(WaveReadLaneFirst(_997.x) == 0)) {
      uint _1005 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(((int)(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))) >> 5)), ((int)(((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))) >> 5)), 0));
      int _1007 = _1005.x & 4;
      int _1009 = (uint)((uint)(_1007)) >> 2;
      if (!(_1007 == 0)) {
        _1017 = max((saturate(dot(float3(_325, _326, _327), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.009999999776482582f) * 0.875f), _525);
        _1018 = _1009;
      } else {
        _1017 = _525;
        _1018 = _1009;
      }
    } else {
      _1017 = _525;
      _1018 = 0;
    }
    float _1028 = saturate(max(_1017, (((_environmentLightingHistory[1].w) + _temporalReprojectionParams.w) + _renderParams.y)));
    half4 _1031 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_534, ((int)((uint)(_535) + 1u)), 0));
    half4 _1037 = __3__36__0__0__g_diffuseResultPrev.Load(int3(((int)((uint)(_534) + 1u)), ((int)((uint)(_535) + 1u)), 0));
    half4 _1042 = __3__36__0__0__g_diffuseResultPrev.Load(int3(((int)((uint)(_534) + 1u)), _535, 0));
    half4 _1047 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_534, _535, 0));
    float _1052 = dot(float4(_992, _993, _994, _995), float4(1.0f, 1.0f, 1.0f, 1.0f));
    float _1061 = saturate(dot(float4(_992, _993, _994, _995), float4(float(_1031.w), float(_1037.w), float(_1042.w), float(_1047.w))) * (1.0f / max(1.0f, _1052)));
    float _1065 = sqrt((_511 * _511) + (_510 * _510));
    float _1066 = _1065 * 50.0f;
    if (_657) {
      _1075 = saturate(1.0f - _1066);
    } else {
      _1075 = (1.0f - (saturate(_1066) * 0.5f));
    }
    float _1079 = max(1.0f, (_bufferSizeAndInvSize.w * 2160.0f));
    float _1084 = (_1061 * _1061) * 4.0f;
    float4 _1095 = __3__36__0__0__g_manyLightsMoments.SampleLevel(__3__40__0__0__g_sampler, float2(_95, _96), 0.0f);
    float _1099 = saturate(_1095.w);
    float _1101 = 1.0f / max(9.999999974752427e-07f, _1052);
    float _1102 = _1101 * _992;
    float _1103 = _1101 * _993;
    float _1104 = _1101 * _994;
    float _1105 = _1101 * _995;
    float _1106 = saturate(saturate(max(_1028, (1.0f / ((saturate(_1084) * min(31.0f, ((_1075 * 15.0f) * _1079))) + 1.0f))) + _renderParams.z));
    float _1148 = 1.0f / _exposure4.x;
    float _1165 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1105 * float(_1047.x)) + ((_1104 * float(_1042.x)) + ((_1102 * float(_1031.x)) + (_1103 * float(_1037.x))))))) * _exposure4.y)))));
    float _1166 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1105 * float(_1047.y)) + ((_1104 * float(_1042.y)) + ((_1102 * float(_1031.y)) + (_1103 * float(_1037.y))))))) * _exposure4.y)))));
    float _1167 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1105 * float(_1047.z)) + ((_1104 * float(_1042.z)) + ((_1102 * float(_1031.z)) + (_1103 * float(_1037.z))))))) * _exposure4.y)))));
    if (_renderParams.y == 0.0f) {
      float _1171 = dot(float3(_1165, _1166, _1167), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _1186 = ((min(_1171, _1095.y) / max(9.999999974752427e-07f, _1171)) * _1099) + saturate(1.0f - _1099);
      _1191 = saturate((saturate(((_1095.x - _1171) * 5.0f) / max(9.999999974752427e-07f, _1095.x)) * 0.5f) + _1106);
      _1192 = (_1186 * _1165);
      _1193 = (_1186 * _1166);
      _1194 = (_1186 * _1167);
    } else {
      _1191 = _1106;
      _1192 = _1165;
      _1193 = _1166;
      _1194 = _1167;
    }
    float _1203 = ((_325 - _1192) * _1191) + _1192;
    float _1204 = ((_326 - _1193) * _1191) + _1193;
    float _1205 = ((_327 - _1194) * _1191) + _1194;
    __3__38__0__1__g_diffuseResultUAV[int2(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))))] = half4(half(_1203), half(_1204), half(_1205), half(saturate(_1061 + 0.0625f)));
    float _1212 = float(_424);
    float _1213 = float(_425);
    float _1214 = float(_426);
    if (_103 == 53) {
      _1221 = saturate(((_1213 + _1212) + _1214) * 1.2000000476837158f);
    } else {
      _1221 = 1.0f;
    }
    float _1222 = float(_422);
    float _1228 = (0.699999988079071f / min(max(max(max(_1212, _1213), _1214), 0.009999999776482582f), 0.699999988079071f)) * _1221;
    float _1238 = (((_1228 * _1212) + -0.03999999910593033f) * _1222) + 0.03999999910593033f;
    float _1239 = (((_1228 * _1213) + -0.03999999910593033f) * _1222) + 0.03999999910593033f;
    float _1240 = (((_1228 * _1214) + -0.03999999910593033f) * _1222) + 0.03999999910593033f;
    if (!_394) {
      _1246 = saturate(1.0h - _329.x);
    } else {
      _1246 = 1.0h;
    }
    if (!(((_103 == 98)) || ((_717 == 96)))) {
      if ((uint)(_103 + -105) < (uint)2) {
        _1258 = _165;
        _1265 = select((((_103 == 65)) || ((((_103 == 107)) || (_1258)))), 0.0h, _422);
      } else {
        if (!((uint)(_103 + -11) < (uint)9)) {
          _1258 = false;
          _1265 = select((((_103 == 65)) || ((((_103 == 107)) || (_1258)))), 0.0h, _422);
        } else {
          _1265 = 0.0h;
        }
      }
    } else {
      _1265 = 0.0h;
    }
    float _1267 = dot(float3(_430, _432, _434), float3(_427, _428, _429)) * 2.0f;
    float _1271 = _430 - (_1267 * _427);
    float _1272 = _432 - (_1267 * _428);
    float _1273 = _434 - (_1267 * _429);
    float _1275 = rsqrt(dot(float3(_1271, _1272, _1273), float3(_1271, _1272, _1273)));
    float _1276 = _1271 * _1275;
    float _1277 = _1272 * _1275;
    float _1278 = _1273 * _1275;
    float _1280 = abs(dot(float3(_427, _428, _429), float3(_209, _210, _211)));
    float _1286 = __3__36__0__0__g_specularRayHitDistance.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_95, _96), 0.0f);
    float _1288 = float(_423);
    float _1290 = ddx_coarse(_209);
    float _1291 = ddx_coarse(_210);
    float _1292 = ddx_coarse(_211);
    float _1293 = ddy_coarse(_209);
    float _1294 = ddy_coarse(_210);
    float _1295 = ddy_coarse(_211);
    float _1309 = select((((_1288 < 0.800000011920929f)) && (((1.0f / ((((sqrt(max(dot(float3(_1290, _1291, _1292), float3(_1290, _1291, _1292)), dot(float3(_1293, _1294, _1295), float3(_1293, _1294, _1295)))) * 10.0f) + saturate(1.0f - (_1280 * _1280))) * (10.0f / (_107 + 0.10000000149011612f))) + 1.0f)) > 0.9900000095367432f))), _1286.x, 0.0f);
    float _1310 = _1309 * _1276;
    float _1311 = _1309 * _1277;
    float _1312 = _1309 * _1278;
    float _1317 = dot(float3(_1310, _1311, _1312), float3((-0.0f - _427), (-0.0f - _428), (-0.0f - _429))) * 2.0f;
    float _1322 = ((_1317 * _427) + _388) + _1310;
    float _1324 = ((_1317 * _428) + _389) + _1311;
    float _1326 = ((_1317 * _429) + _390) + _1312;
    float _1350 = mad((_viewProjRelative[0].z), _1326, mad((_viewProjRelative[0].y), _1324, (_1322 * (_viewProjRelative[0].x)))) + (_viewProjRelative[0].w);
    float _1354 = mad((_viewProjRelative[1].z), _1326, mad((_viewProjRelative[1].y), _1324, (_1322 * (_viewProjRelative[1].x)))) + (_viewProjRelative[1].w);
    float _1358 = mad((_viewProjRelative[2].z), _1326, mad((_viewProjRelative[2].y), _1324, (_1322 * (_viewProjRelative[2].x)))) + (_viewProjRelative[2].w);
    float _1362 = mad((_viewProjRelative[3].z), _1326, mad((_viewProjRelative[3].y), _1324, (_1322 * (_viewProjRelative[3].x)))) + (_viewProjRelative[3].w);
    float _1400 = mad((_projToPrevProj[3].w), _1362, mad((_projToPrevProj[3].z), _1358, mad((_projToPrevProj[3].y), _1354, ((_projToPrevProj[3].x) * _1350))));
    float _1401 = mad((_projToPrevProj[0].w), _1362, mad((_projToPrevProj[0].z), _1358, mad((_projToPrevProj[0].y), _1354, ((_projToPrevProj[0].x) * _1350)))) / _1400;
    float _1402 = mad((_projToPrevProj[1].w), _1362, mad((_projToPrevProj[1].z), _1358, mad((_projToPrevProj[1].y), _1354, ((_projToPrevProj[1].x) * _1350)))) / _1400;
    float _1406 = max(1.0000000116860974e-07f, (mad((_projToPrevProj[2].w), _1362, mad((_projToPrevProj[2].z), _1358, mad((_projToPrevProj[2].y), _1354, ((_projToPrevProj[2].x) * _1350)))) / _1400));
    float _1442 = mad((_invViewProjRelativePrev[3].z), _1406, mad((_invViewProjRelativePrev[3].y), _1402, ((_invViewProjRelativePrev[3].x) * _1401))) + (_invViewProjRelativePrev[3].w);
    float _1446 = ((mad((_invViewProjRelativePrev[0].z), _1406, mad((_invViewProjRelativePrev[0].y), _1402, ((_invViewProjRelativePrev[0].x) * _1401))) + (_invViewProjRelativePrev[0].w)) / _1442) - _1322;
    float _1447 = ((mad((_invViewProjRelativePrev[1].z), _1406, mad((_invViewProjRelativePrev[1].y), _1402, ((_invViewProjRelativePrev[1].x) * _1401))) + (_invViewProjRelativePrev[1].w)) / _1442) - _1324;
    float _1448 = ((mad((_invViewProjRelativePrev[2].z), _1406, mad((_invViewProjRelativePrev[2].y), _1402, ((_invViewProjRelativePrev[2].x) * _1401))) + (_invViewProjRelativePrev[2].w)) / _1442) - _1326;
    float _1449 = dot(float3(_1446, _1447, _1448), float3(_1276, _1277, _1278));
    float _1453 = _1446 - (_1449 * _1276);
    float _1454 = _1447 - (_1449 * _1277);
    float _1455 = _1448 - (_1449 * _1278);
    float _1474 = exp2(log2((saturate(_1309 * 0.125f) * (sqrt(1.0f - saturate(sqrt(((_1453 * _1453) + (_1454 * _1454)) + (_1455 * _1455)) / max(0.0010000000474974513f, _1309))) + -1.0f)) + 1.0f) * 8.0f);
    float _1475 = _1474 * _930;
    float _1476 = _1474 * _954;
    float _1477 = _1474 * _906;
    float _1478 = _1474 * _882;
    bool _1481 = (_renderParams.z > 0.0f);
    float _1483 = float(1.0h - _423);
    float _1487 = (_1401 - (_1350 / _1362)) - _510;
    float _1488 = (_1402 - (_1354 / _1362)) - _511;
    float _1497 = saturate((((_1483 * _1483) * (1.0f - (_437 * 0.8999999761581421f))) * sqrt((_1488 * _1488) + (_1487 * _1487))) * select(_1481, 2000.0f, 500.0f));
    float _1506 = select(((((_273) || (_394))) || ((((_717 == 24)) || ((_renderParams.y > 0.0f))))), 1.0f, float(_329.y));
    float _1510 = float(_1265);
    float _1515 = min(max((_cavityParams.y + -1.0f), 0.0f), 2.0f);
    float _1541 = saturate(saturate(1.0f - (((_1510 * _107) / max(0.0010000000474974513f, _437)) * 0.0010000000474974513f)) * 1.25f) * saturate(((((-0.05000000074505806f - (_1515 * 0.07500000298023224f)) + max(0.019999999552965164f, _1288)) + (saturate(_107 * 0.02500000037252903f) * 0.10000000149011612f)) * min(max((_107 + 1.0f), 5.0f), 50.0f)) * (1.0f - (saturate(_1510) * 0.75f)));
    if (_103 == 64) {
      _1550 = ((saturate(_107 * 0.25f) * (_1541 + -0.39990234375f)) + 0.39990234375f);
    } else {
      _1550 = _1541;
    }
    float _1552 = (_1515 * 16.0f) + 16.0f;
    float _1558 = select((_1515 > 1.0f), 0.0f, saturate((1.0f / _1552) * (_107 - _1552)));
    bool _1559 = (_103 == 105);
    do {
    if (_1559) {
      _1567 = 1.0f;
      _1571 = select((_103 == 65), 0.0f, _1567);
      break;
    } else {
      if (!_394) {
        _1567 = select((_103 == 107), 1.0f, ((_1558 + _1550) - (_1558 * _1550)));
        _1571 = select((_103 == 65), 0.0f, _1567);
        break;
      } else {
        _1571 = 0.0f;
      }
    }
    } while (false);
    float _1575 = select((_lightingParams.y == 0.0f), 0.0f, _1571);
    float _1581 = select(_685, 31.0f, 63.0f);
    float _1589 = (saturate((float((saturate(_423 * 4.0h) * 1900.0h) + 100.0h) * _1065) * (1.0f - (_1575 * 0.75f))) * (7.0f - _1581)) + _1581;
    if ((uint)(_103 + -12) < (uint)9) {
      _1599 = ((saturate(_107 * 0.004999999888241291f) * (_1589 + -2.0f)) + 2.0f);
    } else {
      _1599 = _1589;
    }
    half _1603 = max(0.040008545h, _423);
    float _1621 = saturate(max(max(_1028, select(_1481, _1497, 0.0f)), (1.0f / (((saturate((_1079 * _1079) * _1084) * min(64.0f, ((_1599 + 1.0f) * _1079))) * ((saturate((_1575 + (_107 * 0.0078125f)) + float((_1603 * _1603) * 64.0h)) * 0.9375f) + 0.0625f)) + 1.0f))));
    bool __defer_1598_1642 = false;
    if ((uint)_103 > (uint)52) {
      if ((uint)_103 < (uint)68) {
        if (_955) {
          _1650 = _1475;
          _1651 = _1476;
          _1652 = _1477;
          _1653 = _1478;
          _1656 = _1650;
          _1657 = _1651;
          _1658 = _1652;
          _1659 = _1653;
          _1660 = max(0.89990234h, _423);
        } else {
          if (!_957) {
            float _1630 = _1475 * _1475;
            float _1631 = _1476 * _1476;
            float _1632 = _1477 * _1477;
            float _1633 = _1478 * _1478;
            float _1634 = _1630 * _1630;
            float _1635 = _1631 * _1631;
            float _1636 = _1632 * _1632;
            float _1637 = _1633 * _1633;
            _1643 = (_1634 * _1634);
            _1644 = (_1635 * _1635);
            _1645 = (_1636 * _1636);
            _1646 = (_1637 * _1637);
          } else {
            _1643 = _1475;
            _1644 = _1476;
            _1645 = _1477;
            _1646 = _1478;
          }
          __defer_1598_1642 = true;
        }
      } else {
        _1656 = _1475;
        _1657 = _1476;
        _1658 = _1477;
        _1659 = _1478;
        _1660 = max(0.099975586h, _423);
      }
    } else {
      _1643 = _1475;
      _1644 = _1476;
      _1645 = _1477;
      _1646 = _1478;
      __defer_1598_1642 = true;
    }
    if (__defer_1598_1642) {
      if ((_957) || (_955)) {
        _1650 = _1643;
        _1651 = _1644;
        _1652 = _1645;
        _1653 = _1646;
        _1656 = _1650;
        _1657 = _1651;
        _1658 = _1652;
        _1659 = _1653;
        _1660 = max(0.89990234h, _423);
      } else {
        _1656 = _1643;
        _1657 = _1644;
        _1658 = _1645;
        _1659 = _1646;
        _1660 = max(0.099975586h, _423);
      }
    }
    float _1661 = float(_1660);
    float _1662 = _1661 * _1661;
    float _1663 = _1662 * _1662;
    float _1676 = (((_1663 * _1656) - _1656) * _1656) + 1.0f;
    float _1677 = (((_1663 * _1657) - _1657) * _1657) + 1.0f;
    float _1678 = (((_1663 * _1658) - _1658) * _1658) + 1.0f;
    float _1679 = (((_1663 * _1659) - _1659) * _1659) + 1.0f;
    float _1704 = saturate(select(_273, 1.0f, saturate((_1663 / (_1676 * _1676)) * _1656)) * _984);
    float _1705 = saturate(select(_273, 1.0f, saturate((_1663 / (_1677 * _1677)) * _1657)) * _986);
    float _1706 = saturate(select(_273, 1.0f, saturate((_1663 / (_1678 * _1678)) * _1658)) * _988);
    float _1707 = saturate(select(_273, 1.0f, saturate((_1663 / (_1679 * _1679)) * _1659)) * _990);
    if ((_394) && ((_103 != 29))) {
      float _1724 = mad((_projToPrevProj[3].z), _98.x, mad((_projToPrevProj[3].y), _351, ((_projToPrevProj[3].x) * _349))) + (_projToPrevProj[3].w);
      float _1727 = ((mad((_projToPrevProj[0].z), _98.x, mad((_projToPrevProj[0].y), _351, ((_projToPrevProj[0].x) * _349))) + (_projToPrevProj[0].w)) / _1724) - _349;
      float _1728 = ((mad((_projToPrevProj[1].z), _98.x, mad((_projToPrevProj[1].y), _351, ((_projToPrevProj[1].x) * _349))) + (_projToPrevProj[1].w)) / _1724) - _351;
      float _1736 = (((_1727 * 0.5f) + _95) * _bufferSizeAndInvSize.x) + -0.5f;
      float _1737 = ((_96 - (_1728 * 0.5f)) * _bufferSizeAndInvSize.y) + -0.5f;
      int _1740 = int(floor(_1736));
      int _1741 = int(floor(_1737));
      float _1744 = _1736 - float((int)(_1740));
      float _1745 = _1737 - float((int)(_1741));
      float _1746 = 1.0f - _1744;
      float _1747 = 1.0f - _1745;
      _1775 = saturate((sqrt((_1728 * _1728) + (_1727 * _1727)) * 100.0f) + 0.125f);
      _1776 = _1740;
      _1777 = _1741;
      _1778 = (_1746 * _1745);
      _1779 = (_1745 * _1744);
      _1780 = (_1747 * _1744);
      _1781 = (_1747 * _1746);
    } else {
      float _1761 = saturate(_bufferSizeAndInvSize.y * 0.0006944444612599909f);
      if (_273) {
        _1775 = saturate((_1621 + (_1497 * 0.5f)) + min(0.5f, (((_1761 * _1761) * _421) / (((_107 * _107) * 0.004999999888241291f) + 1.0f))));
        _1776 = _534;
        _1777 = _535;
        _1778 = _1704;
        _1779 = _1705;
        _1780 = _1706;
        _1781 = _1707;
      } else {
        _1775 = _1621;
        _1776 = _534;
        _1777 = _535;
        _1778 = _1704;
        _1779 = _1705;
        _1780 = _1706;
        _1781 = _1707;
      }
    }
    bool _1782 = (_1510 > 0.20000000298023224f);
    half4 _1785 = __3__36__0__0__g_specularResultPrev.Load(int3(_1776, ((int)((uint)(_1777) + 1u)), 0));
    float _1798 = float((bool)((uint)(!(_1782 ^ (_1785.w < 0.0h))))) * _1778;
    half4 _1805 = __3__36__0__0__g_specularResultPrev.Load(int3(((int)((uint)(_1776) + 1u)), ((int)((uint)(_1777) + 1u)), 0));
    float _1818 = float((bool)((uint)(!(_1782 ^ (_1805.w < 0.0h))))) * _1779;
    half4 _1828 = __3__36__0__0__g_specularResultPrev.Load(int3(((int)((uint)(_1776) + 1u)), _1777, 0));
    float _1841 = float((bool)((uint)(!(_1782 ^ (_1828.w < 0.0h))))) * _1780;
    half4 _1851 = __3__36__0__0__g_specularResultPrev.Load(int3(_1776, _1777, 0));
    float _1864 = float((bool)((uint)(!(_1782 ^ (_1851.w < 0.0h))))) * _1781;
    float _1884 = 1.0f / max(1.0000000168623835e-16f, dot(float4(_1798, _1818, _1841, _1864), float4(1.0f, 1.0f, 1.0f, 1.0f)));
    float _1886 = -0.0f - (min(0.0f, (-0.0f - ((((_1798 * float(_1785.x)) + (_1818 * float(_1805.x))) + (_1841 * float(_1828.x))) + (_1864 * float(_1851.x))))) * _1884);
    float _1888 = -0.0f - (min(0.0f, (-0.0f - ((((_1798 * float(_1785.y)) + (_1818 * float(_1805.y))) + (_1841 * float(_1828.y))) + (_1864 * float(_1851.y))))) * _1884);
    float _1890 = -0.0f - (min(0.0f, (-0.0f - ((((_1798 * float(_1785.z)) + (_1818 * float(_1805.z))) + (_1841 * float(_1828.z))) + (_1864 * float(_1851.z))))) * _1884);
    float _1891 = _1884 * min(0.0f, (-0.0f - ((((_1798 * abs(float(_1785.w))) + (_1818 * abs(float(_1805.w)))) + (_1841 * abs(float(_1828.w)))) + (_1864 * abs(float(_1851.w))))));
    if (_renderParams.y == 0.0f) {
      float _1894 = dot(float3(_1886, _1888, _1890), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _1901 = ((min(_1894, _1095.z) / max(9.999999717180685e-10f, _1894)) * _1099) + saturate(1.0f - _1099);
      _1906 = (_1901 * _1886);
      _1907 = (_1901 * _1888);
      _1908 = (_1901 * _1890);
    } else {
      _1906 = _1886;
      _1907 = _1888;
      _1908 = _1890;
    }
    float _1909 = _1906 * _exposure4.y;
    float _1910 = _1907 * _exposure4.y;
    float _1911 = _1908 * _exposure4.y;
    float _1914 = saturate(_1775 + _renderParams.z);
    float _1926 = ((max(0.0010000000474974513f, float(_1246)) + _1891) * _1775) - _1891;
    float _1936 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_1914 * ((_1506 * _304.x) - _1909)) + _1909))));
    float _1937 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_1914 * ((_1506 * _304.y) - _1910)) + _1910))));
    float _1938 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_1914 * ((_1506 * _304.z) - _1911)) + _1911))));
    __3__38__0__1__g_specularResultUAV[int2(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))))] = half4(half(_1936), half(_1937), half(_1938), half(select(_1782, (-0.0f - _1926), _1926)));
    float _1946 = select(_394, 0.0f, _1926);
    float _1951 = float(half(lerp(_1946, 1.0f, _1288)));
    bool _1952 = (_717 == 64);
    int _1954 = ((int)(uint)((int)(_166))) ^ 1;
    if ((((int)(uint)((int)(_1952))) & _1954) == 0) {
      _1970 = saturate(exp2((_1951 * _1951) * (_107 * -0.005770780146121979f)));
    } else {
      _1970 = select((_cavityParams.z > 0.0f), 0.0f, 1.0f);
    }
    bool _1973 = (_cavityParams.x == 0.0f);
    float _1974 = select(_1973, 1.0f, _1970);
    if (_1952) {
      _1980 = (_1974 * _1238);
      _1981 = (_1974 * _1239);
      _1982 = (_1974 * _1240);
    } else {
      _1980 = _1238;
      _1981 = _1239;
      _1982 = _1240;
    }
    float2 _1987 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _437), (1.0f - _1951)), 0.0f);
    float _1998 = select(((_1952) || (_394)), 1.0f, _1974) * _1148;
    if (!_657) {
      if (((_103 != 7)) && ((!(((_103 == 6)) || (((((((uint)(_103 + -27) < (uint)2)) || ((((_103 == 26)) || (((_394) || (_1559))))))) || ((_717 == 106)))))))) {
        float _2028 = exp2(log2(_1946) * (saturate(_107 * 0.03125f) + 1.0f));
        float4 _2037 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_95, _96), 0.0f);
        bool __defer_2022_2055 = false;
        bool __branch_chain_2022;
        if (((_103 == 15)) || (((((_101.x & 124) == 16)) || ((_717 == 12))))) {
          _2056 = false;
          _2057 = true;
          __branch_chain_2022 = true;
        } else {
          if (!((uint)_103 > (uint)10)) {
            _2056 = true;
            _2057 = _1559;
            __branch_chain_2022 = true;
          } else {
            if ((uint)_103 < (uint)20) {
              _2056 = false;
              _2057 = _1559;
              __branch_chain_2022 = true;
            } else {
              if (!(_103 == 97)) {
                _2056 = (_103 != 107);
                _2057 = _1559;
                __branch_chain_2022 = true;
              } else {
                _2249 = _1222;
                _2250 = _1288;
                _2251 = _1212;
                _2252 = _1213;
                _2253 = _1214;
                __branch_chain_2022 = false;
              }
            }
          }
        }
        if (__branch_chain_2022) {
          __defer_2022_2055 = true;
        }
        if (__defer_2022_2055) {
          if (_2037.w < 1.0f) {
            if ((_weatherCheckFlag & 5) == 5) {
              bool _2067 = (_103 == 36);
              if (!_2067) {
                float4 _2087 = __3__36__0__0__g_climateSandTex.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((((_viewPos.x + _388) / _climateTextureOnePixelMeter.x) + float((int)((int)(_climateTextureSize.x >> 1)))) / float((int)(_climateTextureSize.x))), (1.0f - ((((_viewPos.z + _390) / _climateTextureOnePixelMeter.y) + float((int)((int)(_climateTextureSize.y >> 1)))) / float((int)(_climateTextureSize.y))))), 0.0f);
                _2093 = _2087.x;
                _2094 = _2087.y;
                _2095 = _2087.z;
                _2096 = _2087.w;
              } else {
                _2093 = 0.11999999731779099f;
                _2094 = 0.11999999731779099f;
                _2095 = 0.10000000149011612f;
                _2096 = 0.5f;
              }
              float _2103 = 1.0f - saturate(((_viewPos.y + _389) - _paramGlobalSand.x) / _paramGlobalSand.y);
              if (!(_2103 <= 0.0f)) {
                float _2106 = saturate(_2028);
                float _2119 = ((_2094 * 0.3395099937915802f) + (_2093 * 0.6131200194358826f)) + (_2095 * 0.047370001673698425f);
                float _2120 = ((_2094 * 0.9163600206375122f) + (_2093 * 0.07020000368356705f)) + (_2095 * 0.013450000435113907f);
                float _2121 = ((_2094 * 0.10958000272512436f) + (_2093 * 0.02061999961733818f)) + (_2095 * 0.8697999715805054f);
                float _2126 = select(_2057, 1.0f, float((bool)(uint)(saturate(dot(float3(_427, _428, _429), float3(0.0f, 1.0f, 0.0f))) > 0.5f)));
                if (_enableSandAO == 1) {
                  float _2131 = 1.0f - _2037.x;
                  if (_2067) {
                    _2162 = ((((_2131 * 10.0f) * _2096) * _2103) * _2106);
                    _2165 = _2119;
                    _2166 = _2120;
                    _2167 = _2121;
                    _2168 = saturate(_2162);
                  } else {
                    float _2142 = saturate(_2096 + -0.5f);
                    _2165 = _2119;
                    _2166 = _2120;
                    _2167 = _2121;
                    _2168 = ((((_2142 * 2.0f) * max((_2126 * _2037.x), min((_2106 * ((_2037.x * 7.0f) + 3.0f)), (_2142 * 40.0f)))) + (((_2131 * 10.0f) * _2106) * saturate((0.5f - _2096) * 2.0f))) * _2103);
                  }
                } else {
                  float _2160 = ((_2103 * _2096) * _2037.x) * _2126;
                  if (_2067) {
                    _2162 = _2160;
                    _2165 = _2119;
                    _2166 = _2120;
                    _2167 = _2121;
                    _2168 = saturate(_2162);
                  } else {
                    _2165 = _2119;
                    _2166 = _2120;
                    _2167 = _2121;
                    _2168 = _2160;
                  }
                }
              } else {
                _2165 = 0.0f;
                _2166 = 0.0f;
                _2167 = 0.0f;
                _2168 = 0.0f;
              }
              float _2172 = ((1.0f - _2037.w) * (1.0f - _2037.y)) * _2168;
              bool _2173 = (_2172 > 9.999999747378752e-05f);
              if (_2173) {
                if (_2057) {
                  float _2176 = saturate(_2172);
                  _2203 = (((sqrt(_2165 * _1212) - _1212) * _2176) + _1212);
                  _2204 = (((sqrt(_2166 * _1213) - _1213) * _2176) + _1213);
                  _2205 = (((sqrt(_2167 * _1214) - _1214) * _2176) + _1214);
                } else {
                  _2203 = ((_2172 * (_2165 - _1212)) + _1212);
                  _2204 = ((_2172 * (_2166 - _1213)) + _1213);
                  _2205 = ((_2172 * (_2167 - _1214)) + _1214);
                }
              } else {
                _2203 = _1212;
                _2204 = _1213;
                _2205 = _1214;
              }
              if ((_2067) && (_2173)) {
                if (_2057) {
                  _2220 = (((sqrt(_1288 * 0.25f) - _1288) * saturate(_2172)) + _1288);
                } else {
                  _2220 = ((_2172 * (0.25f - _1288)) + _1288);
                }
              } else {
                _2220 = _1288;
              }
              float _2221 = saturate(_2203);
              float _2222 = saturate(_2204);
              float _2223 = saturate(_2205);
              float _2228 = (_2220 * (1.0f - _2028)) + _2028;
              float _2231 = ((_2220 - _2228) * _2037.y) + _2228;
              float _2238 = (((_2028 * _2028) * _2037.z) * float((bool)(uint)(_2056))) * saturate(dot(float3(_427, _428, _429), float3(0.0f, 1.0f, 0.0f)));
              float _2239 = _2238 * -0.5f;
              _2249 = (_1222 - (_2028 * _1222));
              _2250 = (_2231 - (_2238 * _2231));
              _2251 = ((_2239 * _2221) + _2221);
              _2252 = ((_2239 * _2222) + _2222);
              _2253 = ((_2239 * _2223) + _2223);
            } else {
              _2249 = _1222;
              _2250 = _1288;
              _2251 = _1212;
              _2252 = _1213;
              _2253 = _1214;
            }
          } else {
            _2249 = _1222;
            _2250 = _1288;
            _2251 = _1212;
            _2252 = _1213;
            _2253 = _1214;
          }
        }
        _2260 = half(_2249);
        _2261 = half(_2250);
        _2262 = half(_2251);
        _2263 = half(_2252);
        _2264 = half(_2253);
        _2265 = _2028;
      } else {
        _2260 = _422;
        _2261 = _423;
        _2262 = _424;
        _2263 = _425;
        _2264 = _426;
        _2265 = _1946;
      }
    } else {
      _2260 = _422;
      _2261 = _423;
      _2262 = _424;
      _2263 = _425;
      _2264 = _426;
      _2265 = _1946;
    }
    half4 _2267 = __3__36__0__0__g_sceneShadowColor.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
    [branch]
    if (_394) {
      uint _2273 = __3__36__0__0__g_sceneNormal.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
      float _2289 = min(1.0f, ((float((uint)((uint)(_2273.x & 1023))) * 0.001956947147846222f) + -1.0f));
      float _2290 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_2273.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
      float _2291 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_2273.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
      float _2293 = rsqrt(dot(float3(_2289, _2290, _2291), float3(_2289, _2290, _2291)));
      _2301 = half(_2293 * _2289);
      _2302 = half(_2293 * _2290);
      _2303 = half(_2293 * _2291);
    } else {
      _2301 = _245;
      _2302 = _246;
      _2303 = _247;
    }
    bool _2306 = (_sunDirection.y > 0.0f);
    if ((_2306) || ((!(_2306)) && (_sunDirection.y > _moonDirection.y))) {
      _2318 = _sunDirection.x;
      _2319 = _sunDirection.y;
      _2320 = _sunDirection.z;
    } else {
      _2318 = _moonDirection.x;
      _2319 = _moonDirection.y;
      _2320 = _moonDirection.z;
    }
    if ((_2306) || ((!(_2306)) && (_sunDirection.y > _moonDirection.y))) {
      _2340 = _precomputedAmbient7.y;
    } else {
      _2340 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
    }
    float _2346 = (_earthRadius + _389) + _viewPos.y;
    float _2350 = (_390 * _390) + (_388 * _388);
    float _2352 = sqrt((_2346 * _2346) + _2350);
    float _2357 = dot(float3((_388 / _2352), (_2346 / _2352), (_390 / _2352)), float3(_2318, _2319, _2320));
    float _2362 = min(max(((_2352 - _earthRadius) / _atmosphereThickness), 16.0f), (_atmosphereThickness + -16.0f));
    float _2370 = max(_2362, 0.0f);
    float _2377 = (-0.0f - sqrt((_2370 + (_earthRadius * 2.0f)) * _2370)) / (_2370 + _earthRadius);
    if (_2357 > _2377) {
      _2400 = ((exp2(log2(saturate((_2357 - _2377) / (1.0f - _2377))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
    } else {
      _2400 = ((exp2(log2(saturate((_2377 - _2357) / (_2377 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
    }
    float2 _2404 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_2362 + -16.0f) / (_atmosphereThickness + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _2400), 0.0f);
    float _2426 = ((_2404.y * 1.9999999494757503e-05f) * _mieAerosolDensity) * (_mieAerosolAbsorption + 1.0f);
    float _2444 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f)) * _2404.x) + _2426) * -1.4426950216293335f);
    float _2445 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f)) * _2404.x) + _2426) * -1.4426950216293335f);
    float _2446 = exp2(((((_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f)) * _2404.x) + _2426) * -1.4426950216293335f);
    float _2462 = sqrt(_2350);
    float _2470 = (_cloudAltitude - (max(((_2462 * _2462) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
    float _2482 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_2319 > 0.0f))) - ((int)(uint)((int)(_2319 < 0.0f))))) * 0.5f))) + _2470;
    if (_389 < _2470) {
      float _2485 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2318, _2319, _2320));
      float _2491 = select((abs(_2485) < 9.99999993922529e-09f), 1e+08f, ((_2482 - dot(float3(0.0f, 1.0f, 0.0f), float3(_388, _389, _390))) / _2485));
      _2497 = ((_2491 * _2318) + _388);
      _2498 = _2482;
      _2499 = ((_2491 * _2320) + _390);
    } else {
      _2497 = _388;
      _2498 = _389;
      _2499 = _390;
    }
    float _2508 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_2497 * 4.999999873689376e-05f) + 0.5f), ((_2498 - _2470) / _cloudThickness), ((_2499 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
    float _2519 = saturate(abs(_2319) * 4.0f);
    float _2521 = (_2519 * _2519) * exp2(((_distanceScale * -1.4426950216293335f) * _2508.x) * (_cloudScatteringCoefficient / _distanceScale));
    float _2528 = ((1.0f - _2521) * saturate(((_389 - _cloudThickness) - _2470) * 0.10000000149011612f)) + _2521;
    float _2529 = _2528 * (((_2445 * 0.3395099937915802f) + (_2444 * 0.6131200194358826f)) + (_2446 * 0.047370001673698425f));
    float _2530 = _2528 * (((_2445 * 0.9163600206375122f) + (_2444 * 0.07020000368356705f)) + (_2446 * 0.013450000435113907f));
    float _2531 = _2528 * (((_2445 * 0.10958000272512436f) + (_2444 * 0.02061999961733818f)) + (_2446 * 0.8697999715805054f));
    float _2547 = (((_2529 * 0.6131200194358826f) + (_2530 * 0.3395099937915802f)) + (_2531 * 0.047370001673698425f)) * _2340;
    float _2548 = (((_2529 * 0.07020000368356705f) + (_2530 * 0.9163600206375122f)) + (_2531 * 0.013450000435113907f)) * _2340;
    float _2549 = (((_2529 * 0.02061999961733818f) + (_2530 * 0.10958000272512436f)) + (_2531 * 0.8697999715805054f)) * _2340;
    float _2552 = float(_2267.x);
    float _2553 = float(_2267.y);
    float _2554 = float(_2267.z);
    if (!(_308) | !((((uint)_103 < (uint)20)) || ((_103 == 107)))) {
      _2562 = (_103 == 20);
    } else {
      _2562 = true;
    }
    do {
    if (_103 == 19) {
      _2571 = true;
      _2574 = _2571;
      _2575 = (_103 == 106);
      break;
    } else {
      bool _2565 = (_103 == 107);
      if (!((((_1559) || ((_103 == 28)))) || ((_717 == 26)))) {
        _2571 = _2565;
        _2574 = _2571;
        _2575 = (_103 == 106);
        break;
      } else {
        _2574 = _2565;
        _2575 = true;
      }
    }
    } while (false);
    float _2576 = float(_2301);
    float _2577 = float(_2302);
    float _2578 = float(_2303);
    if (_103 == 97) {
      uint16_t _2582 = __3__36__0__0__g_sceneDecalMask.Load(int3(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))), 0));
      _2589 = (((uint)((uint)((int)(uint16_t)((int)((int)(_2582.x) & 4)))) >> 2) + 97);
    } else {
      _2589 = _103;
    }
    float _2594 = float(saturate(_185));
    float _2595 = _2594 * _2594;
    float _2596 = _2595 * _2595;
    float _2597 = _2596 * _2596;
    float4 _2604 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((_bufferSizeAndInvSize.z * _90), (_bufferSizeAndInvSize.w * _91)), 0.0f);
    float _2608 = ((_2597 * _2597) * select(((_273) || (((_2574) || (_2575)))), 0.0f, 1.0f)) * _2604.y;
    float _2613 = _2576 - (_2608 * _2576);
    float _2614 = (_2608 * (1.0f - _2577)) + _2577;
    float _2615 = _2578 - (_2608 * _2578);
    float _2617 = rsqrt(dot(float3(_2613, _2614, _2615), float3(_2613, _2614, _2615)));
    float _2618 = _2613 * _2617;
    float _2619 = _2614 * _2617;
    float _2620 = _2615 * _2617;
    if ((_2306) || ((!(_2306)) && (_sunDirection.y > _moonDirection.y))) {
      _2632 = _sunDirection.x;
      _2633 = _sunDirection.y;
      _2634 = _sunDirection.z;
    } else {
      _2632 = _moonDirection.x;
      _2633 = _moonDirection.y;
      _2634 = _moonDirection.z;
    }
    float _2635 = _2547 * _lightingParams.x;
    float _2636 = _2548 * _lightingParams.x;
    float _2637 = _2549 * _lightingParams.x;
    float _2638 = _2632 - _430;
    float _2639 = _2633 - _432;
    float _2640 = _2634 - _434;
    float _2642 = rsqrt(dot(float3(_2638, _2639, _2640), float3(_2638, _2639, _2640)));
    float _2643 = _2642 * _2638;
    float _2644 = _2642 * _2639;
    float _2645 = _2642 * _2640;
    float _2646 = dot(float3(_2576, _2577, _2578), float3(_2632, _2633, _2634));
    float _2647 = dot(float3(_2618, _2619, _2620), float3(_2632, _2633, _2634));
    float _2649 = saturate(dot(float3(_2576, _2577, _2578), float3(_431, _433, _435)));
    float _2651 = saturate(dot(float3(_2618, _2619, _2620), float3(_2643, _2644, _2645)));
    float _2654 = saturate(dot(float3(_2632, _2633, _2634), float3(_2643, _2644, _2645)));
    float _2656 = float(max(0.010002136h, _2261));
    float _2657 = saturate(_2646);
    // RenoDX: Geometric Specular AA
    float _rndx_spec_rough = _2656;
    if (SPECULAR_AA > 0.0f) {
      _rndx_spec_rough = NDFFilterRoughnessCS(float3(_2618, _2619, _2620), _2656, SPECULAR_AA);
    }
    float _2658 = _rndx_spec_rough * _rndx_spec_rough;
    float _2659 = _2658 * _2658;
    float _2660 = 1.0f - _2659;
    float _2661 = 1.0f - _2654;
    float _2662 = _2661 * _2661;
    float _2665 = ((_2662 * _2662) * _2661) + _2654;
    float _2666 = 1.0f - _2657;
    float _2667 = _2666 * _2666;
    float _2672 = 1.0f - _2649;
    float _2673 = _2672 * _2672;
    float _2701;
    if (DIFFUSE_BRDF_MODE >= 2.0f) {
      // EON Diffuse
      float _eon_LdotV = dot(float3(_2632, _2633, _2634), float3(_431, _433, _435));
      _2701 = _2657 * EON_DiffuseScalar(_2657, _2649, _eon_LdotV, _2656);
    } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
      // Hammon Diffuse
      _2701 = _2657 * HammonDiffuseScalar(_2657, _2649, _2651, _2654, _2656);
    } else {
      // Vanilla Burley Diffuse
      _2701 = saturate((_2657 * 0.31830987334251404f) * ((((((1.0f - ((_2667 * _2667) * (_2666 * 0.75f))) * (1.0f - ((_2673 * _2673) * (_2672 * 0.75f)))) - _2665) * saturate((_2660 * 2.200000047683716f) + -0.5f)) + _2665) + ((exp2(-0.0f - (max(((_2660 * 73.19999694824219f) + -21.200000762939453f), 8.899999618530273f) * sqrt(_2651))) * _2654) * ((((_2660 * 34.5f) + -59.0f) * _2660) + 24.5f))));
    }
    int _2702 = _2589 & 126;
    bool __defer_2631_2712 = false;
    bool __branch_chain_2631;
    if (((_2589 == 98)) || ((_2702 == 96))) {
      _2713 = true;
      __branch_chain_2631 = true;
    } else {
      if ((uint)(_2589 + -105) < (uint)2) {
        _2713 = _165;
        __branch_chain_2631 = true;
      } else {
        if (!((uint)(_2589 + -11) < (uint)9)) {
          _2713 = false;
          __branch_chain_2631 = true;
        } else {
          __branch_chain_2631 = false;
        }
      }
    }
    if (__branch_chain_2631) {
      __defer_2631_2712 = true;
    } else {
      _2721 = 0.0f;
    }
    if (__defer_2631_2712) {
      if (((_2589 == 65)) || ((((_2589 == 107)) || (_2713)))) {
        _2721 = 0.0f;
      } else {
        _2721 = float(_2260);
      }
    }
    bool _2722 = (_2589 == 53);
    float _2723 = float(_2262);
    float _2724 = float(_2263);
    float _2725 = float(_2264);
    if (_2722) {
      _2732 = saturate(((_2724 + _2723) + _2725) * 1.2000000476837158f);
    } else {
      _2732 = 1.0f;
    }
    float _2738 = (0.699999988079071f / min(max(max(max(_2723, _2724), _2725), 0.009999999776482582f), 0.699999988079071f)) * _2732;
    float _2748 = (((_2738 * _2723) + -0.03999999910593033f) * _2721) + 0.03999999910593033f;
    float _2749 = (((_2738 * _2724) + -0.03999999910593033f) * _2721) + 0.03999999910593033f;
    float _2750 = (((_2738 * _2725) + -0.03999999910593033f) * _2721) + 0.03999999910593033f;
    float _2751 = float(_2261);
    bool _2752 = (_2702 == 64);
    bool _2755 = ((((int)(uint)((int)(_2752))) & _1954) == 0);
    if (_2755) {
      _2767 = saturate(exp2((_2751 * _2751) * (_107 * -0.005770780146121979f)));
    } else {
      _2767 = select((_cavityParams.z > 0.0f), 0.0f, 1.0f);
    }
    float _2768 = select(_1973, 1.0f, _2767);
    if (_2752) {
      _2774 = (_2768 * _2748);
      _2775 = (_2768 * _2749);
      _2776 = (_2768 * _2750);
    } else {
      _2774 = _2748;
      _2775 = _2749;
      _2776 = _2750;
    }
    float _2779 = saturate(1.0f - saturate(dot(float3(_431, _433, _435), float3(_2643, _2644, _2645))));
    float _2780 = _2779 * _2779;
    float _2782 = (_2780 * _2780) * _2779;
    float _2785 = _2782 * saturate(_2775 * 50.0f);
    float _2786 = 1.0f - _2782;
    if (!_273) {
      float _2794 = saturate(_2647);
      float _2795 = 1.0f - _2658;
      float _2807 = (((_2659 * _2651) - _2651) * _2651) + 1.0f;
      float _2811 = (_2659 / ((_2807 * _2807) * 3.1415927410125732f)) * (0.5f / ((((_2795 * _2649) + _2658) * _2647) + (((_2795 * _2647) + _2658) * _2649)));
      _2825 = ((_2794 * _2552) * max((_2811 * ((_2786 * _2774) + _2785)), 0.0f));
      _2826 = ((_2794 * _2553) * max((_2811 * ((_2786 * _2775) + _2785)), 0.0f));
      _2827 = ((_2794 * _2554) * max((_2811 * ((_2786 * _2776) + _2785)), 0.0f));
    } else {
      _2825 = 0.0f;
      _2826 = 0.0f;
      _2827 = 0.0f;
    }
    // RenoDX: Diffraction on Rough Surfaces
    if (DIFFRACTION > 0.0f && _2721 > 0.0f) {
      float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
        _2651,                                    // NdotH
        _2649,                                    // NdotV
        _rndx_spec_rough,                         // roughness
        float2(_95, _96),                         // screen UV
        _107,                                     // linear depth
        float3(_2643, _2644, _2645),              // half vector H
        float3(_2618, _2619, _2620),              // shading normal N
        float3(_2723, _2724, _2725)               // F0 (base reflectance)
      );
      float3 _rndx_dMod = lerp(float3(1.0f, 1.0f, 1.0f), _rndx_dShift, DIFFRACTION * _2721);
      _2825 *= _rndx_dMod.x;
      _2826 *= _rndx_dMod.y;
      _2827 *= _rndx_dMod.z;
    }
    // RenoDX: Callisto Smooth Terminator
    if (SMOOTH_TERMINATOR > 0.0f) {
      float _rndx_c2 = CallistoSmoothTerminator(_2657, _2654, _2651, SMOOTH_TERMINATOR, 0.5f);
      _2701 *= _rndx_c2;
      _2825 *= _rndx_c2;
      _2826 *= _rndx_c2;
      _2827 *= _rndx_c2;
    }
    // RenoDX: Foliage Transmission
    bool isFoliage = ((uint)(_103 - 12) < 7u);
    float foliageTransR = 0.0f;
    float foliageTransG = 0.0f;
    float foliageTransB = 0.0f;
    if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
      float thickness = 0.5f;
      float wrap = 0.3f * FOLIAGE_TRANSMISSION;
      float energyScale = 1.0f - thickness * FOLIAGE_TRANSMISSION;
      float wrappedNdotL = max(0.0f, (_2646 + wrap) / (1.0f + wrap));
      float vanillaNdotL = saturate(_2646);
      if (vanillaNdotL > 0.01f) {
        _2701 *= (wrappedNdotL / vanillaNdotL) * energyScale;
      } else {
        _2701 = wrappedNdotL * 0.31830987334251404f * energyScale;
      }
      float transmissionNdotL = pow(saturate(-_2646), 1.5f) * 0.5f;
      foliageTransR = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _2723 * _2552 * _2635;
      foliageTransG = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _2724 * _2553 * _2636;
      foliageTransB = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _2725 * _2554 * _2637;
    }
    // RenoDX: Foliage diffuse energy compensation
    if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
      float _fNdotV = max(_2649, 0.001);
      float _fNdotL = saturate(_2646);
      float _fOneMinusV = 1.0 - _fNdotV;
      float _fOneMinusL = 1.0 - _fNdotL;
      float _fGrazingBoost = _fOneMinusV * _fOneMinusV * _fOneMinusL;
      float _fRoughFactor = _2656 * _2656;
      float _fCompensation = _fGrazingBoost * _fRoughFactor * 10.0;
      _2701 += _fCompensation * _fNdotL * RDXL_INV_PI;
    }
    if ((_2562) || ((_2702 == 6))) {
      _2836 = ((max(0.0f, (0.30000001192092896f - _2646)) * 0.23190687596797943f) + _2701);
    } else {
      _2836 = _2701;
    }
    float _2843 = ((_2552 * _2836) * _2635) + (_1203 * _1148) + foliageTransR;
    float _2844 = ((_2553 * _2836) * _2636) + (_1204 * _1148) + foliageTransG;
    float _2845 = ((_2554 * _2836) * _2637) + (_1205 * _1148) + foliageTransB;
    uint _2848 = _frameNumber.x * 13;
    [branch]
    if (((((int)(_2848 + ((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3))))) | ((int)(_2848 + ((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))))) & 31) == 0) {
      __3__38__0__1__g_sceneColorLightingOnlyForAwbUAV[int2(((int)(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))) >> 5)), ((int)(((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))) >> 5)))] = half4(half(_2843), half(_2844), half(_2845), 1.0h);
    }
    bool _2863 = ((uint)(_2589 & 24) > (uint)23);
    if (_2755) {
      _2880 = saturate(exp2((_2751 * _2751) * (_107 * -0.005770780146121979f)));
    } else {
      _2880 = select((_cavityParams.z > 0.0f), select(_166, 0.0f, _420), 1.0f);
    }
    float _2898 = select(_2752, 1.0f, (select((_cavityParams.x == 0.0f), 1.0f, _2880) * select(((_165) && (_2863)), (1.0f - _420), 1.0f)));
    float _2902 = min(60000.0f, (_2898 * (((((_1987.x * _1980) + _1987.y) * _1936) * _1998) - min(0.0f, (-0.0f - (_2635 * _2825))))));
    float _2903 = min(60000.0f, (_2898 * (((((_1987.x * _1981) + _1987.y) * _1937) * _1998) - min(0.0f, (-0.0f - (_2636 * _2826))))));
    float _2904 = min(60000.0f, (_2898 * (((((_1987.x * _1982) + _1987.y) * _1938) * _1998) - min(0.0f, (-0.0f - (_2637 * _2827))))));
    float _2907 = 1.0f - _renderParams.x;
    half _2914 = half((_renderParams.x * _2723) + _2907);
    half _2915 = half((_renderParams.x * _2724) + _2907);
    half _2916 = half((_renderParams.x * _2725) + _2907);
    if ((_2752) && ((_renderParams2.x == 0.0f))) {
      _2932 = (pow(_2914, 0.5h));
      _2933 = (pow(_2915, 0.5h));
      _2934 = (pow(_2916, 0.5h));
    } else {
      _2932 = _2914;
      _2933 = _2915;
      _2934 = _2916;
    }
    float _2935 = float(_2932);
    float _2936 = float(_2933);
    float _2937 = float(_2934);
    if (_2722) {
      _2944 = saturate(((_2936 + _2935) + _2937) * 1.2000000476837158f);
    } else {
      _2944 = 1.0f;
    }
    float _2945 = float(_2260);
    float _2951 = (0.699999988079071f / min(max(max(max(_2935, _2936), _2937), 0.009999999776482582f), 0.699999988079071f)) * _2944;
    float _2958 = ((_2951 * _2935) + -0.03999999910593033f) * _2945;
    float _2959 = ((_2951 * _2936) + -0.03999999910593033f) * _2945;
    float _2960 = ((_2951 * _2937) + -0.03999999910593033f) * _2945;
    float _2961 = _2958 + 0.03999999910593033f;
    float _2962 = _2959 + 0.03999999910593033f;
    float _2963 = _2960 + 0.03999999910593033f;
    float _2967 = (_2961 * _1987.x) + _1987.y;
    float _2968 = (_2962 * _1987.x) + _1987.y;
    float _2969 = (_2963 * _1987.x) + _1987.y;
    float _2971 = (1.0f - _1987.y) - _1987.x;
    float _2978 = ((0.9599999785423279f - _2958) * 0.0476190485060215f) + _2961;
    float _2979 = ((0.9599999785423279f - _2959) * 0.0476190485060215f) + _2962;
    float _2980 = ((0.9599999785423279f - _2960) * 0.0476190485060215f) + _2963;
    float _2997 = saturate(1.0f - _2265);
    float _2998 = (((_2967 * _2978) / (1.0f - (_2978 * _2971))) * _2971) * _2997;
    float _2999 = (((_2968 * _2979) / (1.0f - (_2979 * _2971))) * _2971) * _2997;
    float _3000 = (((_2969 * _2980) / (1.0f - (_2980 * _2971))) * _2971) * _2997;
    float _3011 = float(1.0h - _2260);
    half _3021 = half(((_2935 * _3011) * saturate((1.0f - _2998) - _2967)) + _2998);
    half _3022 = half(((_2936 * _3011) * saturate((1.0f - _2999) - _2968)) + _2999);
    half _3023 = half(((_2937 * _3011) * saturate((1.0f - _3000) - _2969)) + _3000);
    float _3026 = __3__36__0__0__g_caustic.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_95, _96), 0.0f);
    float _3028 = _3026.x * 0.31830987334251404f;
    float _3038 = ((_3028 * _2547) + _2843) * float(_3021);
    float _3039 = ((_3028 * _2548) + _2844) * float(_3022);
    float _3040 = ((_3028 * _2549) + _2845) * float(_3023);
    float _3044 = _3038 + (_2902 * _2945);
    float _3045 = _3039 + (_2903 * _2945);
    float _3046 = _3040 + (_2904 * _2945);
    float _3068 = (((QuadReadLaneAt(_3044,1) + QuadReadLaneAt(_3044,0)) + QuadReadLaneAt(_3044,2)) + QuadReadLaneAt(_3044,3)) * 0.25f;
    float _3069 = (((QuadReadLaneAt(_3045,1) + QuadReadLaneAt(_3045,0)) + QuadReadLaneAt(_3045,2)) + QuadReadLaneAt(_3045,3)) * 0.25f;
    float _3070 = (((QuadReadLaneAt(_3046,1) + QuadReadLaneAt(_3046,0)) + QuadReadLaneAt(_3046,2)) + QuadReadLaneAt(_3046,3)) * 0.25f;
    [branch]
    if (((((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))) | ((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3))))) & 1) == 0) {
      float _3075 = dot(float3(_3068, _3069, _3070), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      __3__38__0__1__g_diffuseHalfPrevUAV[int2(((int)(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))) >> 1)), ((int)(((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))) >> 1)))] = float4(min(60000.0f, _3068), min(60000.0f, _3069), min(60000.0f, _3070), min(60000.0f, select((_1018 != 0), (-0.0f - _3075), _3075)));
    }
    if (_2863) {
      _3097 = (((_2260 == 0.0h)) && ((!(((((!(_3021 == 0.0h))) && ((!(_3022 == 0.0h))))) && ((!(_3023 == 0.0h)))))));
    } else {
      _3097 = false;
    }
    bool __defer_3096_3110 = false;
    if (((_2863) || ((((_2589 == 96)) || ((((_2589 == 54)) || (((_2589 & 124) == 64))))))) || ((!((_2863) || ((((_2589 == 96)) || ((((_2589 == 54)) || (((_2589 & 124) == 64)))))))) && (((_107 <= 10.0f)) && (((uint)(_2589 + -97) < (uint)2))))) {
      __defer_3096_3110 = true;
    } else {
      _3133 = (_3038 + _2902);
      _3134 = (_3039 + _2903);
      _3135 = (_3040 + _2904);
    }
    if (__defer_3096_3110) {
      __3__38__0__1__g_sceneSpecularUAV[int2(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))))] = half4((-0.0h - half(min(0.0f, (-0.0f - _2902)))), (-0.0h - half(min(0.0f, (-0.0f - _2903)))), (-0.0h - half(min(0.0f, (-0.0f - _2904)))), (-0.0h - half(min(0.0f, (-0.0f - _1946)))));
      _3133 = _3038;
      _3134 = _3039;
      _3135 = _3040;
    }
    float _3136 = min(60000.0f, _3133);
    float _3137 = min(60000.0f, _3134);
    float _3138 = min(60000.0f, _3135);
    [branch]
    if (_3097) {
      float4 _3141 = __3__38__0__1__g_sceneColorUAV.Load(int2(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5))))));
      _3149 = (_3141.x + _3136);
      _3150 = (_3141.y + _3137);
      _3151 = (_3141.z + _3138);
    } else {
      _3149 = _3136;
      _3150 = _3137;
      _3151 = _3138;
    }
    if (!(_renderParams.y == 0.0f)) {
      float _3160 = dot(float3(_3149, _3150, _3151), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _3161 = min((max(0.009999999776482582f, _exposure3.w) * 4096.0f), _3160);
      float _3165 = max(9.999999717180685e-10f, _3160);
      _3170 = ((_3161 * _3149) / _3165);
      _3171 = ((_3161 * _3150) / _3165);
      _3172 = ((_3161 * _3151) / _3165);
    } else {
      _3170 = _3149;
      _3171 = _3150;
      _3172 = _3151;
    }
    __3__38__0__1__g_sceneColorUAV[int2(((int)((((uint)(((int)((uint)(_79) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3)))), ((int)((((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_79)) >> 16) << 5)))))] = float4(_3170, _3171, _3172, 1.0f);
  }
}