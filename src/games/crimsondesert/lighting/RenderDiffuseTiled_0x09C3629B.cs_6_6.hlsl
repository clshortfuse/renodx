#include "../shared.h"
#include "diffuse_brdf.hlsli"

Texture2D<float4> __3__36__0__0__g_puddleMask : register(t79, space36);

Texture2D<float4> __3__36__0__0__g_climateSandTex : register(t171, space36);

Texture2D<uint16_t> __3__36__0__0__g_sceneDecalMask : register(t172, space36);

Texture2D<float2> __3__36__0__0__g_texNetDensity : register(t140, space36);

Texture3D<float> __3__36__0__0__g_texCloudVolumeShadow : register(t195, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t14, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t119, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t50, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormalPrev : register(t81, space36);

Texture2D<float2> __3__36__0__0__g_velocity : register(t82, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t40, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaque : register(t49, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaquePrev : register(t84, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t33, space36);

Texture2D<float4> __3__36__0__0__g_specularResult : register(t87, space36);

Texture2D<float> __3__36__0__0__g_specularRayHitDistance : register(t124, space36);

Texture2D<float4> __3__36__0__0__g_manyLightsMoments : register(t113, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t90, space36);

Texture2D<half4> __3__36__0__0__g_sceneDiffuse : register(t156, space36);

Texture2D<half4> __3__36__0__0__g_diffuseResult : register(t164, space36);

Texture2D<half4> __3__36__0__0__g_diffuseResultPrev : register(t18, space36);

Texture2D<half4> __3__36__0__0__g_specularResultPrev : register(t19, space36);

Texture2D<half2> __3__36__0__0__g_sceneAO : register(t20, space36);

Texture2D<float> __3__36__0__0__g_caustic : register(t21, space36);

Texture2D<uint> __3__36__0__0__g_tiledManyLightsMasks : register(t129, space36);

ByteAddressBuffer __3__37__0__0__g_structureCounterBuffer : register(t27, space37);

Texture2D<half4> __3__36__0__0__g_sceneShadowColor : register(t130, space36);

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
  float __3__1__0__0__WeatherShadingConstants_005z : packoffset(c005.z);
  float __3__1__0__0__WeatherShadingConstants_005w : packoffset(c005.w);
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
  int _61 = (uint)(_60) >> 2;
  _47[0] = (g_tileIndex[(uint)(SV_GroupID.x) >> 6]).x;
  _47[1] = (g_tileIndex[(uint)(SV_GroupID.x) >> 6]).y;
  _47[2] = (g_tileIndex[(uint)(SV_GroupID.x) >> 6]).z;
  _47[3] = (g_tileIndex[(uint)(SV_GroupID.x) >> 6]).w;
  int _79 = _47[(((uint)(SV_GroupID.x) >> 4) & 3)];
  uint _85 = (((uint)(((int)(_79 << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_60 - (_61 << 2)) << 3));
  uint _87 = (((uint)(_61 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)(_79) >> 16) << 5));
  float _90 = float((uint)_85) + 0.5f;
  float _91 = float((uint)_87) + 0.5f;
  float _95 = _bufferSizeAndInvSize.z * _90;
  float _96 = _91 * _bufferSizeAndInvSize.w;
  float _98 = __3__36__0__0__g_depth.Load(int3(_85, _87, 0));
  uint2 _101 = __3__36__0__0__g_stencil.Load(int3(_85, _87, 0));
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
  float _1190;
  float _1191;
  float _1192;
  float _1193;
  float _1220;
  half _1245;
  bool _1257;
  half _1264;
  float _1549;
  float _1566;
  float _1570;
  float _1593;
  float _1634;
  float _1635;
  float _1636;
  float _1637;
  float _1641;
  float _1642;
  float _1643;
  float _1644;
  float _1647;
  float _1648;
  float _1649;
  float _1650;
  half _1651;
  float _1766;
  int _1767;
  int _1768;
  float _1769;
  float _1770;
  float _1771;
  float _1772;
  float _1897;
  float _1898;
  float _1899;
  float _1961;
  float _1971;
  float _1972;
  float _1973;
  bool _2047;
  bool _2048;
  float _2084;
  float _2085;
  float _2086;
  float _2087;
  float _2153;
  float _2156;
  float _2157;
  float _2158;
  float _2159;
  float _2194;
  float _2195;
  float _2196;
  float _2211;
  float _2240;
  float _2241;
  float _2242;
  float _2243;
  float _2244;
  half _2251;
  half _2252;
  half _2253;
  half _2254;
  half _2255;
  float _2256;
  half _2292;
  half _2293;
  half _2294;
  float _2309;
  float _2310;
  float _2311;
  float _2331;
  float _2391;
  float _2488;
  float _2489;
  float _2490;
  bool _2553;
  bool _2562;
  bool _2565;
  bool _2566;
  int _2580;
  float _2623;
  float _2624;
  float _2625;
  bool _2704;
  float _2712;
  float _2723;
  float _2758;
  float _2765;
  float _2766;
  float _2767;
  float _2816;
  float _2817;
  float _2818;
  float _2827;
  float _2871;
  half _2923;
  half _2924;
  half _2925;
  float _2935;
  bool _3088;
  float _3124;
  float _3125;
  float _3126;
  float _3140;
  float _3141;
  float _3142;
  float _3161;
  float _3162;
  float _3163;
  if (!((((int)(((int)(_98.x < 1.0000000116860974e-07f)) | ((int)(_98.x == 1.0f))))) | ((int)(_103 == 10)))) {
    uint4 _115 = __3__36__0__0__g_baseColor.Load(int3(_85, _87, 0));
    float4 _121 = __3__36__0__0__g_normal.Load(int3(_85, _87, 0));
    half _130 = half(float((uint)((uint)(((uint)((uint)(_115.x)) >> 8) & 255))) * 0.003921568859368563f);
    half _134 = half(float((uint)((uint)(_115.x & 255))) * 0.003921568859368563f);
    half _139 = half(float((uint)((uint)(((uint)((uint)(_115.y)) >> 8) & 255))) * 0.003921568859368563f);
    half _148 = half(float((uint)((uint)(((uint)((uint)(_115.z)) >> 8) & 255))) * 0.003921568859368563f);
    uint _164 = uint((_121.w * 3.0f) + 0.5f);
    bool _165 = (_164 == 1);
    bool _166 = (_164 == 3);
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
    bool _274 = ((int)(_103 == 24)) | (_273);
    half4 _277 = __3__36__0__0__g_diffuseResult.Load(int3(_85, _87, 0));
    float _281 = float(_277.x);
    float _282 = float(_277.y);
    float _283 = float(_277.z);
    [branch]
    if (_renderParams2.y > 0.0f) {
      half4 _289 = __3__36__0__0__g_sceneDiffuse.Load(int3(_85, _87, 0));
      _300 = (float(_289.x) + _281);
      _301 = (float(_289.y) + _282);
      _302 = (float(_289.z) + _283);
    } else {
      _300 = _281;
      _301 = _282;
      _302 = _283;
    }
    float4 _304 = __3__36__0__0__g_specularResult.Load(int3(_85, _87, 0));
    bool _308 = ((uint)_103 > (uint)11);
    bool __defer_299_315 = false;
    if (_308) {
      if (!(((int)((uint)_103 < (uint)21)) | ((int)(_103 == 107)))) {
        __defer_299_315 = true;
      } else {
        _318 = true;
      }
    } else {
      if (!(_103 == 6)) {
        __defer_299_315 = true;
      } else {
        _318 = true;
      }
    }
    if (__defer_299_315) {
      _318 = (_103 == 7);
    }
    float _325 = -0.0f - min(0.0f, (-0.0f - _300));
    float _326 = -0.0f - min(0.0f, (-0.0f - _301));
    float _327 = -0.0f - min(0.0f, (-0.0f - _302));
    half2 _329 = __3__36__0__0__g_sceneAO.Load(int3(_85, _87, 0));
    bool __defer_317_345 = false;
    if (!_308) {
      bool __branch_chain_333;
      if ((uint)_103 > (uint)10) {
        __branch_chain_333 = true;
      } else {
        _339 = false;
        if (((int)(_103 == 65)) | (((int)((((int)(((int)(_103 == 107)) | ((int)(_103 == 96))))) | (_339))))) {
          __branch_chain_333 = true;
        } else {
          _347 = select(_274, 0.0f, (float)(half(float((uint)((uint)(_115.y & 255))) * 0.003921568859368563f)));
          __branch_chain_333 = false;
        }
      }
      if (__branch_chain_333) {
        __defer_317_345 = true;
      }
    } else {
      bool __branch_chain_335;
      if ((uint)_103 < (uint)20) {
        __branch_chain_335 = true;
      } else {
        _339 = ((uint)_103 < (uint)19);
        if (((int)(_103 == 65)) | (((int)((((int)(((int)(_103 == 107)) | ((int)(_103 == 96))))) | (_339))))) {
          __branch_chain_335 = true;
        } else {
          _347 = select(_274, 0.0f, (float)(half(float((uint)((uint)(_115.y & 255))) * 0.003921568859368563f)));
          __branch_chain_335 = false;
        }
      }
      if (__branch_chain_335) {
        __defer_317_345 = true;
      }
    }
    if (__defer_317_345) {
      _347 = 0.0h;
    }
    float _349 = (_95 * 2.0f) + -1.0f;
    float _351 = 1.0f - (_96 * 2.0f);
    float _387 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _106, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _351, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _349))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
    float _388 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _106, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _351, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _349))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _387;
    float _389 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _106, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _351, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _349))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _387;
    float _390 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _106, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _351, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _349))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _387;
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
        _411 = select(((_402 & 128) != 0), 1.0f, 0.0f);
        _412 = (float((uint)((uint)(_402 & 127))) * 0.007874015718698502f);
      } else {
        _411 = 0.0f;
        _412 = 0.0f;
      }
      half _413 = half(_412);
      bool _415 = (_413 > 0.99902344h);
      _420 = _411;
      _421 = _400;
      _422 = _413;
      _423 = select(_274, 0.010002136f, _148);
      _424 = select(_415, 1.0f, _269);
      _425 = select(_415, 1.0f, _270);
      _426 = select(_415, 1.0f, _271);
    } else {
      _420 = 0.0f;
      _421 = 0.0f;
      _422 = _347;
      _423 = _148;
      _424 = _269;
      _425 = _270;
      _426 = _271;
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
      bool __defer_440_457 = false;
      if ((uint)_103 > (uint)52) {
        if (!(((int)((_101.x & 125) == 105)) | ((int)((uint)_103 < (uint)68)))) {
          __defer_440_457 = true;
        } else {
          _460 = true;
        }
      } else {
        if ((uint)_103 > (uint)10) {
          if ((uint)_103 < (uint)20) {
            if ((_101.x & 126) == 14) {
              __defer_440_457 = true;
            } else {
              _460 = true;
            }
          } else {
            if (!((_101.x & 125) == 105)) {
              __defer_440_457 = true;
            } else {
              _460 = true;
            }
          }
        } else {
          __defer_440_457 = true;
        }
      }
      if (__defer_440_457) {
        _460 = (_103 == 98);
      }
    } else {
      _460 = true;
    }
    [branch]
    if (_394) {
      uint _463 = __3__36__0__0__g_depthOpaque.Load(int3(_85, _87, 0));
      _469 = (float((uint)((uint)(_463.x & 16777215))) * 5.960465188081798e-08f);
    } else {
      _469 = _98.x;
    }
    float _497 = mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).w), _469, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).w), _351, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).w) * _349))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).w);
    if (_460) {
      float2 _504 = __3__36__0__0__g_velocity.Load(int3(_85, _87, 0));
      _510 = (_504.x * 2.0f);
      _511 = (_504.y * 2.0f);
    } else {
      _510 = (((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).x), _469, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).x), _351, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).x) * _349))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).x)) / _497) - _349);
      _511 = (((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).y), _469, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).y), _351, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).y) * _349))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).y)) / _497) - _351);
    }
    float _513 = _nearFarProj.x / max(1.0000000116860974e-07f, _469);
    float _516 = (_510 * 0.5f) + _95;
    float _517 = _96 - (_511 * 0.5f);
    float _525 = select(((((int)(((int)(_516 < 0.0f)) | ((int)(_516 > 1.0f))))) | (((int)(((int)(_517 < 0.0f)) | ((int)(_517 > 1.0f)))))), 1.0f, 0.0f);
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
      bool __defer_568_587 = false;
      if ((uint)_103 > (uint)52) {
        if (!(((int)(_103 == 98)) | (((int)(((int)((_101.x & 125) == 105)) | ((int)((uint)_103 < (uint)68))))))) {
          __defer_568_587 = true;
        } else {
          _598 = 0.0f;
        }
      } else {
        if ((uint)_103 > (uint)10) {
          if ((uint)_103 < (uint)20) {
            if ((_101.x & 126) == 14) {
              __defer_568_587 = true;
            } else {
              _598 = 0.0f;
            }
          } else {
            if (!((_101.x & 125) == 105)) {
              __defer_568_587 = true;
            } else {
              _598 = 0.0f;
            }
          }
        } else {
          __defer_568_587 = true;
        }
      }
      if (__defer_568_587) {
        _598 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3((float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x), (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y), (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z)));
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
    bool _649 = ((int)((uint)(_103 + -97) < (uint)2)) | (_318);
    float _651 = _513 * _513;
    float _653 = (_651 * select(_649, 0.5f, 0.20000000298023224f)) + 1.0f;
    bool _657 = ((uint)(_103 + -53) < (uint)15);
    if (_657) {
      _676 = (1000.0f - (saturate(float((bool)(uint)((sqrt((((float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x) * (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x)) + ((float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y) * (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y))) + ((float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z) * (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z))) * 50.0f) > 1.0f))) * 875.0f));
    } else {
      _676 = 50.0f;
    }
    bool _685 = ((int)(_103 == 57)) | (_657);
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
      bool _721 = ((int)(_717 == 66)) | ((int)(_103 == 54));
      int _722 = _567 & 127;
      int _723 = _567 & 32512;
      int _724 = _567 & 8323072;
      int _725 = _567 & 2130706432;
      bool _764 = ((int)(_722 == 57)) | ((int)((uint)(_722 + -53) < (uint)15));
      bool _765 = ((int)(_723 == 14592)) | ((int)((uint)((((uint)(_567) >> 8) & 127) + -53) < (uint)15));
      bool _766 = ((int)(_724 == 3735552)) | ((int)((uint)((((uint)(_567) >> 16) & 127) + -53) < (uint)15));
      bool _767 = ((int)(_725 == 956301312)) | ((int)((uint)((((uint)(_567) >> 24) & 127) + -53) < (uint)15));
      bool _780 = (_685) | (((int)(!_439)));
      bool _789 = (_103 == 6);
      bool _811 = ((uint)(_103 + -105) < (uint)3);
      _849 = (float((bool)((uint)((((int)((_721) | (((int)(((int)(_722 != 54)) & ((int)((_567 & 126) != 66)))))))) & (((int)(!((((int)((((int)(_789 ^ (_722 == 6)))) | (((int)((((int)(_685 ^ _764))) | (((int)(_811 ^ (((int)(_722 == 107)) | ((int)((uint)(_722 + -105) < (uint)2)))))))))))) | (((int)((((int)((_567 & 128) != 0)) | (_764)) ^ _780)))))))))) * _713);
      _850 = (float((bool)((uint)((((int)((_721) | (((int)(((int)(_723 != 13824)) & ((int)((_567 & 32256) != 16896)))))))) & (((int)(!((((int)((((int)(_789 ^ (_723 == 1536)))) | (((int)((((int)(_811 ^ (((int)((_567 & 32000) == 26880)) | ((int)(_723 == 27136)))))) | (((int)(_685 ^ _765))))))))) | (((int)((((int)((_567 & 32768) != 0)) | (_765)) ^ _780)))))))))) * _714);
      _851 = (float((bool)((uint)((((int)((_721) | (((int)(((int)(_724 != 3538944)) & ((int)((_567 & 8257536) != 4325376)))))))) & (((int)(!((((int)((((int)(_789 ^ (_724 == 393216)))) | (((int)((((int)(_811 ^ (((int)((_567 & 8192000) == 6881280)) | ((int)(_724 == 6946816)))))) | (((int)(_685 ^ _766))))))))) | (((int)((((int)((_567 & 8388608) != 0)) | (_766)) ^ _780)))))))))) * _715);
      _852 = (float((bool)((uint)((((int)((_721) | (((int)(((int)(_725 != 905969664)) & ((int)((_567 & 2113929216) != 1107296256)))))))) & (((int)(!((((int)((((int)(_789 ^ (_725 == 100663296)))) | (((int)((((int)(_811 ^ (((int)((_567 & 2097152000) == 1761607680)) | ((int)(_725 == 1778384896)))))) | (((int)(_685 ^ _767))))))))) | (((int)((((int)((int)_567 < (int)0)) | (_767)) ^ _780)))))))))) * _716);
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
    float _959 = select(((_957) | (((int)((_649) | (_955))))), 0.009999999776482582f, 1.0f);
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
    int _997 = asint(__3__37__0__0__g_structureCounterBuffer.Load(8));
    [branch]
    if (!(WaveReadLaneFirst(_997) == 0)) {
      uint _1005 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(((int)(_85 >> 5)), ((int)(_87 >> 5)), 0));
      int _1007 = _1005.x & 4;
      int _1009 = (uint)(_1007) >> 2;
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
    float _1028 = saturate(max(_1017, ((((_environmentLightingHistory[1]).w) + _temporalReprojectionParams.w) + _renderParams.y)));
    uint _1029 = _535 + 1u;
    half4 _1031 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_534, _1029, 0));
    uint _1036 = _534 + 1u;
    half4 _1037 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_1036, _1029, 0));
    half4 _1042 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_1036, _535, 0));
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
    float _1078 = _bufferSizeAndInvSize.w * 2160.0f;
    float _1084 = saturate((_1061 * _1061) * 4.0f);
    float4 _1094 = __3__36__0__0__g_manyLightsMoments.SampleLevel(__3__40__0__0__g_sampler, float2(_95, _96), 0.0f);
    float _1098 = saturate(_1094.w);
    float _1100 = 1.0f / max(9.999999974752427e-07f, _1052);
    float _1101 = _1100 * _992;
    float _1102 = _1100 * _993;
    float _1103 = _1100 * _994;
    float _1104 = _1100 * _995;
    float _1105 = saturate(saturate(max(_1028, (1.0f / ((_1084 * min(31.0f, ((_1075 * 15.0f) * _1078))) + 1.0f))) + _renderParams.z));
    float _1147 = 1.0f / _exposure4.x;
    float _1164 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1104 * float(_1047.x)) + ((_1103 * float(_1042.x)) + ((_1101 * float(_1031.x)) + (_1102 * float(_1037.x))))))) * _exposure4.y)))));
    float _1165 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1104 * float(_1047.y)) + ((_1103 * float(_1042.y)) + ((_1101 * float(_1031.y)) + (_1102 * float(_1037.y))))))) * _exposure4.y)))));
    float _1166 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1104 * float(_1047.z)) + ((_1103 * float(_1042.z)) + ((_1101 * float(_1031.z)) + (_1102 * float(_1037.z))))))) * _exposure4.y)))));
    if (_renderParams.y == 0.0f) {
      float _1170 = dot(float3(_1164, _1165, _1166), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _1185 = ((min(_1170, _1094.y) / max(9.999999974752427e-07f, _1170)) * _1098) + saturate(1.0f - _1098);
      _1190 = saturate((saturate(((_1094.x - _1170) * 5.0f) / max(9.999999974752427e-07f, _1094.x)) * 0.5f) + _1105);
      _1191 = (_1185 * _1164);
      _1192 = (_1185 * _1165);
      _1193 = (_1185 * _1166);
    } else {
      _1190 = _1105;
      _1191 = _1164;
      _1192 = _1165;
      _1193 = _1166;
    }
    float _1202 = ((_325 - _1191) * _1190) + _1191;
    float _1203 = ((_326 - _1192) * _1190) + _1192;
    float _1204 = ((_327 - _1193) * _1190) + _1193;
    __3__38__0__1__g_diffuseResultUAV[int2(_85, _87)] = half4(half(_1202), half(_1203), half(_1204), half(saturate(_1061 + 0.0625f)));
    float _1211 = float(_424);
    float _1212 = float(_425);
    float _1213 = float(_426);
    if (_103 == 53) {
      _1220 = saturate(((_1212 + _1211) + _1213) * 1.2000000476837158f);
    } else {
      _1220 = 1.0f;
    }
    float _1221 = float(_422);
    float _1227 = (0.699999988079071f / min(max(max(max(_1211, _1212), _1213), 0.009999999776482582f), 0.699999988079071f)) * _1220;
    float _1237 = (((_1227 * _1211) + -0.03999999910593033f) * _1221) + 0.03999999910593033f;
    float _1238 = (((_1227 * _1212) + -0.03999999910593033f) * _1221) + 0.03999999910593033f;
    float _1239 = (((_1227 * _1213) + -0.03999999910593033f) * _1221) + 0.03999999910593033f;
    if (!_394) {
      _1245 = saturate(1.0h - _329.x);
    } else {
      _1245 = 1.0h;
    }
    if (!(((int)(_103 == 98)) | ((int)(_717 == 96)))) {
      bool __defer_1250_1256 = false;
      bool __branch_chain_1250;
      if ((uint)(_103 + -105) < (uint)2) {
        _1257 = _165;
        __branch_chain_1250 = true;
      } else {
        if (!((uint)(_103 + -11) < (uint)9)) {
          _1257 = false;
          __branch_chain_1250 = true;
        } else {
          _1264 = 0.0h;
          __branch_chain_1250 = false;
        }
      }
      if (__branch_chain_1250) {
        __defer_1250_1256 = true;
      }
      if (__defer_1250_1256) {
        _1264 = select((((int)(_103 == 65)) | (((int)(((int)(_103 == 107)) | (_1257))))), 0.0f, _422);
      }
    } else {
      _1264 = 0.0h;
    }
    float _1266 = dot(float3(_430, _432, _434), float3(_427, _428, _429)) * 2.0f;
    float _1270 = _430 - (_1266 * _427);
    float _1271 = _432 - (_1266 * _428);
    float _1272 = _434 - (_1266 * _429);
    float _1274 = rsqrt(dot(float3(_1270, _1271, _1272), float3(_1270, _1271, _1272)));
    float _1275 = _1270 * _1274;
    float _1276 = _1271 * _1274;
    float _1277 = _1272 * _1274;
    float _1279 = abs(dot(float3(_427, _428, _429), float3(_209, _210, _211)));
    float _1285 = __3__36__0__0__g_specularRayHitDistance.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_95, _96), 0.0f);
    float _1287 = float(_423);
    float _1289 = ddx_coarse(_209);
    float _1290 = ddx_coarse(_210);
    float _1291 = ddx_coarse(_211);
    float _1292 = ddy_coarse(_209);
    float _1293 = ddy_coarse(_210);
    float _1294 = ddy_coarse(_211);
    float _1308 = select((((int)(_1287 < 0.800000011920929f)) & ((int)((1.0f / ((((sqrt(max(dot(float3(_1289, _1290, _1291), float3(_1289, _1290, _1291)), dot(float3(_1292, _1293, _1294), float3(_1292, _1293, _1294)))) * 10.0f) + saturate(1.0f - (_1279 * _1279))) * (10.0f / (_107 + 0.10000000149011612f))) + 1.0f)) > 0.9900000095367432f))), _1285.x, 0.0f);
    float _1309 = _1308 * _1275;
    float _1310 = _1308 * _1276;
    float _1311 = _1308 * _1277;
    float _1316 = dot(float3(_1309, _1310, _1311), float3((-0.0f - _427), (-0.0f - _428), (-0.0f - _429))) * 2.0f;
    float _1321 = ((_1316 * _427) + _388) + _1309;
    float _1323 = ((_1316 * _428) + _389) + _1310;
    float _1325 = ((_1316 * _429) + _390) + _1311;
    float _1349 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _1325, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _1323, (_1321 * (float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x)))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x);
    float _1353 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _1325, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _1323, (_1321 * (float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y)))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y);
    float _1357 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _1325, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _1323, (_1321 * (float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z)))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z);
    float _1361 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _1325, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _1323, (_1321 * (float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w)))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
    float _1399 = mad((float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).w), _1361, mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).w), _1357, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).w), _1353, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).w) * _1349))));
    float _1400 = mad((float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).x), _1361, mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).x), _1357, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).x), _1353, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).x) * _1349)))) / _1399;
    float _1401 = mad((float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).y), _1361, mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).y), _1357, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).y), _1353, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).y) * _1349)))) / _1399;
    float _1405 = max(1.0000000116860974e-07f, (mad((float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).z), _1361, mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).z), _1357, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).z), _1353, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).z) * _1349)))) / _1399));
    float _1441 = mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).w), _1405, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).w), _1401, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).w) * _1400))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).w);
    float _1445 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).x), _1405, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).x), _1401, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).x) * _1400))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).x)) / _1441) - _1321;
    float _1446 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).y), _1405, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).y), _1401, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).y) * _1400))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).y)) / _1441) - _1323;
    float _1447 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).z), _1405, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).z), _1401, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).z) * _1400))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).z)) / _1441) - _1325;
    float _1448 = dot(float3(_1445, _1446, _1447), float3(_1275, _1276, _1277));
    float _1452 = _1445 - (_1448 * _1275);
    float _1453 = _1446 - (_1448 * _1276);
    float _1454 = _1447 - (_1448 * _1277);
    float _1473 = exp2(log2((saturate(_1308 * 0.125f) * (sqrt(1.0f - saturate(sqrt(((_1452 * _1452) + (_1453 * _1453)) + (_1454 * _1454)) / max(0.0010000000474974513f, _1308))) + -1.0f)) + 1.0f) * 8.0f);
    float _1474 = _1473 * _930;
    float _1475 = _1473 * _954;
    float _1476 = _1473 * _906;
    float _1477 = _1473 * _882;
    bool _1480 = (_renderParams.z > 0.0f);
    float _1482 = float(1.0h - _423);
    float _1486 = (_1400 - (_1349 / _1361)) - _510;
    float _1487 = (_1401 - (_1353 / _1361)) - _511;
    float _1496 = saturate((((_1482 * _1482) * (1.0f - (_437 * 0.8999999761581421f))) * sqrt((_1487 * _1487) + (_1486 * _1486))) * select(_1480, 2000.0f, 500.0f));
    float _1505 = select(((((int)((_273) | (_394)))) | (((int)(((int)(_717 == 24)) | ((int)(_renderParams.y > 0.0f)))))), 1.0f, float(_329.y));
    float _1509 = float(_1264);
    float _1514 = min(max((_cavityParams.y + -1.0f), 0.0f), 2.0f);
    float _1540 = saturate(saturate(1.0f - (((_1509 * _107) / max(0.0010000000474974513f, _437)) * 0.0010000000474974513f)) * 1.25f) * saturate(((((-0.05000000074505806f - (_1514 * 0.07500000298023224f)) + max(0.019999999552965164f, _1287)) + (saturate(_107 * 0.02500000037252903f) * 0.10000000149011612f)) * min(max((_107 + 1.0f), 5.0f), 50.0f)) * (1.0f - (saturate(_1509) * 0.75f)));
    if (_103 == 64) {
      _1549 = ((saturate(_107 * 0.25f) * (_1540 + -0.39990234375f)) + 0.39990234375f);
    } else {
      _1549 = _1540;
    }
    float _1551 = (_1514 * 16.0f) + 16.0f;
    float _1557 = select((_1514 > 1.0f), 0.0f, saturate((1.0f / _1551) * (_107 - _1551)));
    bool _1558 = (_103 == 105);
    bool __defer_1548_1565 = false;
    bool __branch_chain_1548;
    if (_1558) {
      _1566 = 1.0f;
      __branch_chain_1548 = true;
    } else {
      if (!_394) {
        _1566 = select((_103 == 107), 1.0f, ((_1557 + _1549) - (_1557 * _1549)));
        __branch_chain_1548 = true;
      } else {
        _1570 = 0.0f;
        __branch_chain_1548 = false;
      }
    }
    if (__branch_chain_1548) {
      __defer_1548_1565 = true;
    }
    if (__defer_1548_1565) {
      _1570 = select((_103 == 65), 0.0f, _1566);
    }
    float _1574 = select((_lightingParams.y == 0.0f), 0.0f, _1570);
    float _1575 = select(_685, 31.0f, 63.0f);
    float _1583 = (saturate((_1065 * 2000.0f) * (1.0f - (_1574 * 0.75f))) * (7.0f - _1575)) + _1575;
    if ((uint)(_103 + -12) < (uint)9) {
      _1593 = ((saturate(_107 * 0.004999999888241291f) * (_1583 + -2.0f)) + 2.0f);
    } else {
      _1593 = _1583;
    }
    half _1597 = max(0.040008545h, _423);
    float _1612 = saturate(max(max(_1028, select(_1480, _1496, 0.0f)), (1.0f / (((min(64.0f, ((_1593 + 1.0f) * _1078)) * _1084) * ((saturate((_1574 + (_107 * 0.0078125f)) + float((_1597 * _1597) * 64.0h)) * 0.9375f) + 0.0625f)) + 1.0f))));
    bool __defer_1592_1633 = false;
    if ((uint)_103 > (uint)52) {
      if (!((uint)_103 < (uint)68)) {
        _1647 = _1474;
        _1648 = _1475;
        _1649 = _1476;
        _1650 = _1477;
        _1651 = max(0.099975586h, _423);
      } else {
        if (!_955) {
          if (!_957) {
            float _1621 = _1474 * _1474;
            float _1622 = _1475 * _1475;
            float _1623 = _1476 * _1476;
            float _1624 = _1477 * _1477;
            float _1625 = _1621 * _1621;
            float _1626 = _1622 * _1622;
            float _1627 = _1623 * _1623;
            float _1628 = _1624 * _1624;
            _1634 = (_1625 * _1625);
            _1635 = (_1626 * _1626);
            _1636 = (_1627 * _1627);
            _1637 = (_1628 * _1628);
          } else {
            _1634 = _1474;
            _1635 = _1475;
            _1636 = _1476;
            _1637 = _1477;
          }
          __defer_1592_1633 = true;
        } else {
          _1641 = _1474;
          _1642 = _1475;
          _1643 = _1476;
          _1644 = _1477;
          _1647 = _1641;
          _1648 = _1642;
          _1649 = _1643;
          _1650 = _1644;
          _1651 = max(0.89990234h, _423);
        }
      }
    } else {
      _1634 = _1474;
      _1635 = _1475;
      _1636 = _1476;
      _1637 = _1477;
      __defer_1592_1633 = true;
    }
    if (__defer_1592_1633) {
      if ((_957) | (_955)) {
        _1641 = _1634;
        _1642 = _1635;
        _1643 = _1636;
        _1644 = _1637;
        _1647 = _1641;
        _1648 = _1642;
        _1649 = _1643;
        _1650 = _1644;
        _1651 = max(0.89990234h, _423);
      } else {
        _1647 = _1634;
        _1648 = _1635;
        _1649 = _1636;
        _1650 = _1637;
        _1651 = max(0.099975586h, _423);
      }
    }
    float _1652 = float(_1651);
    float _1653 = _1652 * _1652;
    float _1654 = _1653 * _1653;
    float _1667 = (((_1654 * _1647) - _1647) * _1647) + 1.0f;
    float _1668 = (((_1654 * _1648) - _1648) * _1648) + 1.0f;
    float _1669 = (((_1654 * _1649) - _1649) * _1649) + 1.0f;
    float _1670 = (((_1654 * _1650) - _1650) * _1650) + 1.0f;
    float _1695 = saturate(select(_273, 1.0f, saturate((_1654 / (_1667 * _1667)) * _1647)) * _984);
    float _1696 = saturate(select(_273, 1.0f, saturate((_1654 / (_1668 * _1668)) * _1648)) * _986);
    float _1697 = saturate(select(_273, 1.0f, saturate((_1654 / (_1669 * _1669)) * _1649)) * _988);
    float _1698 = saturate(select(_273, 1.0f, saturate((_1654 / (_1670 * _1670)) * _1650)) * _990);
    if ((_394) & ((int)(_103 != 29))) {
      float _1715 = mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).w), _98.x, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).w), _351, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).w) * _349))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).w);
      float _1718 = ((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).x), _98.x, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).x), _351, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).x) * _349))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).x)) / _1715) - _349;
      float _1719 = ((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).y), _98.x, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).y), _351, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).y) * _349))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).y)) / _1715) - _351;
      float _1727 = (((_1718 * 0.5f) + _95) * _bufferSizeAndInvSize.x) + -0.5f;
      float _1728 = ((_96 - (_1719 * 0.5f)) * _bufferSizeAndInvSize.y) + -0.5f;
      int _1731 = int(floor(_1727));
      int _1732 = int(floor(_1728));
      float _1735 = _1727 - float((int)(_1731));
      float _1736 = _1728 - float((int)(_1732));
      float _1737 = 1.0f - _1735;
      float _1738 = 1.0f - _1736;
      _1766 = saturate((sqrt((_1719 * _1719) + (_1718 * _1718)) * 100.0f) + 0.125f);
      _1767 = _1731;
      _1768 = _1732;
      _1769 = (_1737 * _1736);
      _1770 = (_1736 * _1735);
      _1771 = (_1738 * _1735);
      _1772 = (_1738 * _1737);
    } else {
      float _1752 = saturate(_bufferSizeAndInvSize.y * 0.0006944444612599909f);
      if (_273) {
        _1766 = saturate((_1612 + (_1496 * 0.5f)) + min(0.5f, (((_1752 * _1752) * _421) / (((_107 * _107) * 0.004999999888241291f) + 1.0f))));
        _1767 = _534;
        _1768 = _535;
        _1769 = _1695;
        _1770 = _1696;
        _1771 = _1697;
        _1772 = _1698;
      } else {
        _1766 = _1612;
        _1767 = _534;
        _1768 = _535;
        _1769 = _1695;
        _1770 = _1696;
        _1771 = _1697;
        _1772 = _1698;
      }
    }
    bool _1773 = (_1509 > 0.20000000298023224f);
    uint _1774 = _1768 + 1u;
    half4 _1776 = __3__36__0__0__g_specularResultPrev.Load(int3(_1767, _1774, 0));
    float _1789 = float((bool)((uint)(!(_1773 ^ (_1776.w < 0.0h))))) * _1769;
    uint _1795 = _1767 + 1u;
    half4 _1796 = __3__36__0__0__g_specularResultPrev.Load(int3(_1795, _1774, 0));
    float _1809 = float((bool)((uint)(!(_1773 ^ (_1796.w < 0.0h))))) * _1770;
    half4 _1819 = __3__36__0__0__g_specularResultPrev.Load(int3(_1795, _1768, 0));
    float _1832 = float((bool)((uint)(!(_1773 ^ (_1819.w < 0.0h))))) * _1771;
    half4 _1842 = __3__36__0__0__g_specularResultPrev.Load(int3(_1767, _1768, 0));
    float _1855 = float((bool)((uint)(!(_1773 ^ (_1842.w < 0.0h))))) * _1772;
    float _1875 = 1.0f / max(1.0000000168623835e-16f, dot(float4(_1789, _1809, _1832, _1855), float4(1.0f, 1.0f, 1.0f, 1.0f)));
    float _1877 = -0.0f - (min(0.0f, (-0.0f - ((((_1789 * float(_1776.x)) + (_1809 * float(_1796.x))) + (_1832 * float(_1819.x))) + (_1855 * float(_1842.x))))) * _1875);
    float _1879 = -0.0f - (min(0.0f, (-0.0f - ((((_1789 * float(_1776.y)) + (_1809 * float(_1796.y))) + (_1832 * float(_1819.y))) + (_1855 * float(_1842.y))))) * _1875);
    float _1881 = -0.0f - (min(0.0f, (-0.0f - ((((_1789 * float(_1776.z)) + (_1809 * float(_1796.z))) + (_1832 * float(_1819.z))) + (_1855 * float(_1842.z))))) * _1875);
    float _1882 = _1875 * min(0.0f, (-0.0f - ((((_1789 * abs(float(_1776.w))) + (_1809 * abs(float(_1796.w)))) + (_1832 * abs(float(_1819.w)))) + (_1855 * abs(float(_1842.w))))));
    if (_renderParams.y == 0.0f) {
      float _1885 = dot(float3(_1877, _1879, _1881), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _1892 = ((min(_1885, _1094.z) / max(9.999999717180685e-10f, _1885)) * _1098) + saturate(1.0f - _1098);
      _1897 = (_1892 * _1877);
      _1898 = (_1892 * _1879);
      _1899 = (_1892 * _1881);
    } else {
      _1897 = _1877;
      _1898 = _1879;
      _1899 = _1881;
    }
    float _1900 = _1897 * _exposure4.y;
    float _1901 = _1898 * _exposure4.y;
    float _1902 = _1899 * _exposure4.y;
    float _1905 = saturate(_1766 + _renderParams.z);
    float _1917 = ((max(0.0010000000474974513f, float(_1245)) + _1882) * _1766) - _1882;
    float _1927 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_1905 * ((_1505 * _304.x) - _1900)) + _1900))));
    float _1928 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_1905 * ((_1505 * _304.y) - _1901)) + _1901))));
    float _1929 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_1905 * ((_1505 * _304.z) - _1902)) + _1902))));
    __3__38__0__1__g_specularResultUAV[int2(_85, _87)] = half4(half(_1927), half(_1928), half(_1929), half(select(_1773, (-0.0f - _1917), _1917)));
    float _1937 = select(_394, 0.0f, _1917);
    float _1942 = float(half(lerp(_1937, 1.0f, _1287)));
    bool _1943 = (_717 == 64);
    int _1945 = ((int)(uint)(_166)) ^ 1;
    if (!((((int)(uint)(_1943)) & _1945) == 0)) {
      _1961 = select((_cavityParams.z > 0.0f), 0.0f, 1.0f);
    } else {
      _1961 = saturate(exp2((_1942 * _1942) * (_107 * -0.005770780146121979f)));
    }
    bool _1964 = (_cavityParams.x == 0.0f);
    float _1965 = select(_1964, 1.0f, _1961);
    if (_1943) {
      _1971 = (_1965 * _1237);
      _1972 = (_1965 * _1238);
      _1973 = (_1965 * _1239);
    } else {
      _1971 = _1237;
      _1972 = _1238;
      _1973 = _1239;
    }
    float2 _1978 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _437), (1.0f - _1942)), 0.0f);
    float _1989 = select(((_1943) | (_394)), 1.0f, _1965) * _1147;
    if (!_657) {
      if (((int)(_103 != 7)) & (((int)(!(((int)(_103 == 6)) | (((int)((((int)(((int)((uint)(_103 + -27) < (uint)2)) | (((int)(((int)(_103 == 26)) | (((int)((_394) | (_1558)))))))))) | ((int)(_717 == 106)))))))))) {
        float _2019 = exp2(log2(_1937) * (saturate(_107 * 0.03125f) + 1.0f));
        float4 _2028 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_95, _96), 0.0f);
        bool __defer_2013_2046 = false;
        bool __branch_chain_2013;
        if (((int)(_103 == 15)) | (((int)(((int)((_101.x & 124) == 16)) | ((int)(_717 == 12)))))) {
          _2047 = false;
          _2048 = true;
          __branch_chain_2013 = true;
        } else {
          if (!((uint)_103 > (uint)10)) {
            _2047 = true;
            _2048 = _1558;
            __branch_chain_2013 = true;
          } else {
            if ((uint)_103 < (uint)20) {
              _2047 = false;
              _2048 = _1558;
              __branch_chain_2013 = true;
            } else {
              if (!(_103 == 97)) {
                _2047 = (_103 != 107);
                _2048 = _1558;
                __branch_chain_2013 = true;
              } else {
                _2240 = _1221;
                _2241 = _1287;
                _2242 = _1211;
                _2243 = _1212;
                _2244 = _1213;
                __branch_chain_2013 = false;
              }
            }
          }
        }
        if (__branch_chain_2013) {
          __defer_2013_2046 = true;
        }
        if (__defer_2013_2046) {
          if (_2028.w < 1.0f) {
            if (((int4(_snowDetail, _iceRate, _snowRate, _weatherCheckFlag).w) & 5) == 5) {
              bool _2058 = (_103 == 36);
              if (!_2058) {
                float4 _2078 = __3__36__0__0__g_climateSandTex.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((((_viewPos.x + _388) / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((((_viewPos.z + _390) / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                _2084 = _2078.x;
                _2085 = _2078.y;
                _2086 = _2078.z;
                _2087 = _2078.w;
              } else {
                _2084 = 0.11999999731779099f;
                _2085 = 0.11999999731779099f;
                _2086 = 0.10000000149011612f;
                _2087 = 0.5f;
              }
              float _2094 = 1.0f - saturate(((_viewPos.y + _389) - (float4(_paramGlobalSand.x, _paramGlobalSand.y, __3__1__0__0__WeatherShadingConstants_005z, __3__1__0__0__WeatherShadingConstants_005w).x)) / (float4(_paramGlobalSand.x, _paramGlobalSand.y, __3__1__0__0__WeatherShadingConstants_005z, __3__1__0__0__WeatherShadingConstants_005w).y));
              if (!(_2094 <= 0.0f)) {
                float _2097 = saturate(_2019);
                float _2110 = ((_2085 * 0.3395099937915802f) + (_2084 * 0.6131200194358826f)) + (_2086 * 0.047370001673698425f);
                float _2111 = ((_2085 * 0.9163600206375122f) + (_2084 * 0.07020000368356705f)) + (_2086 * 0.013450000435113907f);
                float _2112 = ((_2085 * 0.10958000272512436f) + (_2084 * 0.02061999961733818f)) + (_2086 * 0.8697999715805054f);
                float _2117 = select(_2048, 1.0f, float((bool)(uint)(saturate(dot(float3(_427, _428, _429), float3(0.0f, 1.0f, 0.0f))) > 0.5f)));
                bool __defer_2096_2152 = false;
                if ((int4(_readBackBufferSize.x, _readBackBufferSize.y, _readBackFieldSize, _enableSandAO).w) == 1) {
                  float _2122 = 1.0f - _2028.x;
                  if (_2058) {
                    _2153 = ((((_2122 * 10.0f) * _2087) * _2094) * _2097);
                    __defer_2096_2152 = true;
                  } else {
                    float _2133 = saturate(_2087 + -0.5f);
                    _2156 = _2110;
                    _2157 = _2111;
                    _2158 = _2112;
                    _2159 = ((((_2133 * 2.0f) * max((_2117 * _2028.x), min((_2097 * ((_2028.x * 7.0f) + 3.0f)), (_2133 * 40.0f)))) + (((_2122 * 10.0f) * _2097) * saturate((0.5f - _2087) * 2.0f))) * _2094);
                  }
                } else {
                  float _2151 = ((_2094 * _2087) * _2028.x) * _2117;
                  if (_2058) {
                    _2153 = _2151;
                    __defer_2096_2152 = true;
                  } else {
                    _2156 = _2110;
                    _2157 = _2111;
                    _2158 = _2112;
                    _2159 = _2151;
                  }
                }
                if (__defer_2096_2152) {
                  _2156 = _2110;
                  _2157 = _2111;
                  _2158 = _2112;
                  _2159 = saturate(_2153);
                }
              } else {
                _2156 = 0.0f;
                _2157 = 0.0f;
                _2158 = 0.0f;
                _2159 = 0.0f;
              }
              float _2163 = ((1.0f - _2028.w) * (1.0f - _2028.y)) * _2159;
              bool _2164 = (_2163 > 9.999999747378752e-05f);
              if (_2164) {
                if (_2048) {
                  float _2167 = saturate(_2163);
                  _2194 = (((sqrt(_2156 * _1211) - _1211) * _2167) + _1211);
                  _2195 = (((sqrt(_2157 * _1212) - _1212) * _2167) + _1212);
                  _2196 = (((sqrt(_2158 * _1213) - _1213) * _2167) + _1213);
                } else {
                  _2194 = ((_2163 * (_2156 - _1211)) + _1211);
                  _2195 = ((_2163 * (_2157 - _1212)) + _1212);
                  _2196 = ((_2163 * (_2158 - _1213)) + _1213);
                }
              } else {
                _2194 = _1211;
                _2195 = _1212;
                _2196 = _1213;
              }
              if ((_2058) & (_2164)) {
                if (_2048) {
                  _2211 = (((sqrt(_1287 * 0.25f) - _1287) * saturate(_2163)) + _1287);
                } else {
                  _2211 = ((_2163 * (0.25f - _1287)) + _1287);
                }
              } else {
                _2211 = _1287;
              }
              float _2212 = saturate(_2194);
              float _2213 = saturate(_2195);
              float _2214 = saturate(_2196);
              float _2219 = (_2211 * (1.0f - _2019)) + _2019;
              float _2222 = ((_2211 - _2219) * _2028.y) + _2219;
              float _2229 = (((_2019 * _2019) * _2028.z) * float((bool)_2047)) * saturate(dot(float3(_427, _428, _429), float3(0.0f, 1.0f, 0.0f)));
              float _2230 = _2229 * -0.5f;
              _2240 = (_1221 - (_2019 * _1221));
              _2241 = (_2222 - (_2229 * _2222));
              _2242 = ((_2230 * _2212) + _2212);
              _2243 = ((_2230 * _2213) + _2213);
              _2244 = ((_2230 * _2214) + _2214);
            } else {
              _2240 = _1221;
              _2241 = _1287;
              _2242 = _1211;
              _2243 = _1212;
              _2244 = _1213;
            }
          } else {
            _2240 = _1221;
            _2241 = _1287;
            _2242 = _1211;
            _2243 = _1212;
            _2244 = _1213;
          }
        }
        _2251 = half(_2240);
        _2252 = half(_2241);
        _2253 = half(_2242);
        _2254 = half(_2243);
        _2255 = half(_2244);
        _2256 = _2019;
      } else {
        _2251 = _422;
        _2252 = _423;
        _2253 = _424;
        _2254 = _425;
        _2255 = _426;
        _2256 = _1937;
      }
    } else {
      _2251 = _422;
      _2252 = _423;
      _2253 = _424;
      _2254 = _425;
      _2255 = _426;
      _2256 = _1937;
    }
    half4 _2258 = __3__36__0__0__g_sceneShadowColor.Load(int3(_85, _87, 0));
    [branch]
    if (_394) {
      uint _2264 = __3__36__0__0__g_sceneNormal.Load(int3(_85, _87, 0));
      float _2280 = min(1.0f, ((float((uint)((uint)(_2264.x & 1023))) * 0.001956947147846222f) + -1.0f));
      float _2281 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_2264.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
      float _2282 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_2264.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
      float _2284 = rsqrt(dot(float3(_2280, _2281, _2282), float3(_2280, _2281, _2282)));
      _2292 = half(_2284 * _2280);
      _2293 = half(_2284 * _2281);
      _2294 = half(_2284 * _2282);
    } else {
      _2292 = _245;
      _2293 = _246;
      _2294 = _247;
    }
    bool _2297 = (_sunDirection.y > 0.0f);
    bool __defer_2291_2302 = false;
    if ((_2297) || ((!(_2297)) && (_sunDirection.y > _moonDirection.y))) {
      __defer_2291_2302 = true;
    } else {
      _2309 = _moonDirection.x;
      _2310 = _moonDirection.y;
      _2311 = _moonDirection.z;
    }
    if (__defer_2291_2302) {
      _2309 = _sunDirection.x;
      _2310 = _sunDirection.y;
      _2311 = _sunDirection.z;
    }
    bool __defer_2308_2316 = false;
    if ((_2297) || ((!(_2297)) && (_sunDirection.y > _moonDirection.y))) {
      __defer_2308_2316 = true;
    } else {
      _2331 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
    }
    if (__defer_2308_2316) {
      _2331 = _precomputedAmbient7.y;
    }
    float _2337 = ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _389) + _viewPos.y;
    float _2341 = (_390 * _390) + (_388 * _388);
    float _2343 = sqrt((_2337 * _2337) + _2341);
    float _2348 = dot(float3((_388 / _2343), (_2337 / _2343), (_390 / _2343)), float3(_2309, _2310, _2311));
    float _2353 = min(max(((_2343 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y)), 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
    float _2361 = max(_2353, 0.0f);
    float _2368 = (-0.0f - sqrt((_2361 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _2361)) / (_2361 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
    if (_2348 > _2368) {
      _2391 = ((exp2(log2(saturate((_2348 - _2368) / (1.0f - _2368))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
    } else {
      _2391 = ((exp2(log2(saturate((_2368 - _2348) / (_2368 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
    }
    float2 _2395 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_2353 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _2391), 0.0f);
    float _2417 = ((_2395.y * 1.9999999494757503e-05f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f);
    float _2435 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * 2.05560013455397e-06f)) * _2395.x) + _2417) * -1.4426950216293335f);
    float _2436 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * 4.978800461685751e-06f)) * _2395.x) + _2417) * -1.4426950216293335f);
    float _2437 = exp2((((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * 2.1360001767334325e-07f) + (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f)) * _2395.x) + _2417) * -1.4426950216293335f);
    float _2453 = sqrt(_2341);
    float _2461 = ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_2453 * _2453) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
    float _2473 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x) * (0.5f - (float((int)(((int)(uint)((int)(_2310 > 0.0f))) - ((int)(uint)((int)(_2310 < 0.0f))))) * 0.5f))) + _2461;
    if (_389 < _2461) {
      float _2476 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2309, _2310, _2311));
      float _2482 = select((abs(_2476) < 9.99999993922529e-09f), 1e+08f, ((_2473 - dot(float3(0.0f, 1.0f, 0.0f), float3(_388, _389, _390))) / _2476));
      _2488 = ((_2482 * _2309) + _388);
      _2489 = _2473;
      _2490 = ((_2482 * _2311) + _390);
    } else {
      _2488 = _388;
      _2489 = _389;
      _2490 = _390;
    }
    float _2499 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_2488 * 4.999999873689376e-05f) + 0.5f), ((_2489 - _2461) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)), ((_2490 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
    float _2510 = saturate(abs(_2310) * 4.0f);
    float _2512 = (_2510 * _2510) * exp2((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * -1.4426950216293335f) * _2499.x) * ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)));
    float _2519 = ((1.0f - _2512) * saturate(((_389 - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) - _2461) * 0.10000000149011612f)) + _2512;
    float _2520 = _2519 * (((_2436 * 0.3395099937915802f) + (_2435 * 0.6131200194358826f)) + (_2437 * 0.047370001673698425f));
    float _2521 = _2519 * (((_2436 * 0.9163600206375122f) + (_2435 * 0.07020000368356705f)) + (_2437 * 0.013450000435113907f));
    float _2522 = _2519 * (((_2436 * 0.10958000272512436f) + (_2435 * 0.02061999961733818f)) + (_2437 * 0.8697999715805054f));
    float _2538 = (((_2520 * 0.6131200194358826f) + (_2521 * 0.3395099937915802f)) + (_2522 * 0.047370001673698425f)) * _2331;
    float _2539 = (((_2520 * 0.07020000368356705f) + (_2521 * 0.9163600206375122f)) + (_2522 * 0.013450000435113907f)) * _2331;
    float _2540 = (((_2520 * 0.02061999961733818f) + (_2521 * 0.10958000272512436f)) + (_2522 * 0.8697999715805054f)) * _2331;
    float _2543 = float(_2258.x);
    float _2544 = float(_2258.y);
    float _2545 = float(_2258.z);
    bool __defer_2487_2550 = false;
    if (!(_308) || !(((int)((uint)_103 < (uint)20)) | ((int)(_103 == 107)))) {
      __defer_2487_2550 = true;
    } else {
      _2553 = true;
    }
    if (__defer_2487_2550) {
      _2553 = (_103 == 20);
    }
    bool __defer_2552_2561 = false;
    bool __branch_chain_2552;
    if (_103 == 19) {
      _2562 = true;
      __branch_chain_2552 = true;
    } else {
      bool _2556 = (_103 == 107);
      if (!((((int)((_1558) | ((int)(_103 == 28))))) | ((int)(_717 == 26)))) {
        _2562 = _2556;
        __branch_chain_2552 = true;
      } else {
        _2565 = _2556;
        _2566 = true;
        __branch_chain_2552 = false;
      }
    }
    if (__branch_chain_2552) {
      __defer_2552_2561 = true;
    }
    if (__defer_2552_2561) {
      _2565 = _2562;
      _2566 = (_103 == 106);
    }
    float _2567 = float(_2292);
    float _2568 = float(_2293);
    float _2569 = float(_2294);
    if (_103 == 97) {
      uint16_t _2573 = __3__36__0__0__g_sceneDecalMask.Load(int3(_85, _87, 0));
      _2580 = (((uint)((uint)((int)(min16uint)((int)((int)(_2573.x) & 4)))) >> 2) + 97);
    } else {
      _2580 = _103;
    }
    float _2585 = float(saturate(_185));
    float _2586 = _2585 * _2585;
    float _2587 = _2586 * _2586;
    float _2588 = _2587 * _2587;
    float4 _2595 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((_bufferSizeAndInvSize.z * _90), (_bufferSizeAndInvSize.w * _91)), 0.0f);
    float _2599 = ((_2588 * _2588) * select(((_273) | (((int)((_2565) | (_2566))))), 0.0f, 1.0f)) * _2595.y;
    float _2604 = _2567 - (_2599 * _2567);
    float _2605 = (_2599 * (1.0f - _2568)) + _2568;
    float _2606 = _2569 - (_2599 * _2569);
    float _2608 = rsqrt(dot(float3(_2604, _2605, _2606), float3(_2604, _2605, _2606)));
    float _2609 = _2604 * _2608;
    float _2610 = _2605 * _2608;
    float _2611 = _2606 * _2608;
    bool __defer_2579_2616 = false;
    if ((_2297) || ((!(_2297)) && (_sunDirection.y > _moonDirection.y))) {
      __defer_2579_2616 = true;
    } else {
      _2623 = _moonDirection.x;
      _2624 = _moonDirection.y;
      _2625 = _moonDirection.z;
    }
    if (__defer_2579_2616) {
      _2623 = _sunDirection.x;
      _2624 = _sunDirection.y;
      _2625 = _sunDirection.z;
    }
    float _2626 = _2538 * _lightingParams.x;
    float _2627 = _2539 * _lightingParams.x;
    float _2628 = _2540 * _lightingParams.x;
    float _2629 = _2623 - _430;
    float _2630 = _2624 - _432;
    float _2631 = _2625 - _434;
    float _2633 = rsqrt(dot(float3(_2629, _2630, _2631), float3(_2629, _2630, _2631)));
    float _2634 = _2633 * _2629;
    float _2635 = _2633 * _2630;
    float _2636 = _2633 * _2631;
    float _2637 = dot(float3(_2567, _2568, _2569), float3(_2623, _2624, _2625));
    float _2638 = dot(float3(_2609, _2610, _2611), float3(_2623, _2624, _2625));
    float _2640 = saturate(dot(float3(_2567, _2568, _2569), float3(_431, _433, _435)));
    float _2642 = saturate(dot(float3(_2609, _2610, _2611), float3(_2634, _2635, _2636)));
    float _2645 = saturate(dot(float3(_2623, _2624, _2625), float3(_2634, _2635, _2636)));
    float _2647 = float(max(0.010002136h, _2252));
    float _2648 = saturate(_2637);
    // RenoDX: Geometric Specular AA
    float _rndx_spec_rough = _2647;
    if (SPECULAR_AA > 0.0f) {
      _rndx_spec_rough = NDFFilterRoughnessCS(float3(_2609, _2610, _2611), _2647, SPECULAR_AA);
    }
    float _2649 = _rndx_spec_rough * _rndx_spec_rough;
    float _2650 = _2649 * _2649;
    float _2651 = 1.0f - _2650;
    float _2652 = 1.0f - _2645;
    float _2653 = _2652 * _2652;
    float _2656 = ((_2653 * _2653) * _2652) + _2645;
    float _2657 = 1.0f - _2648;
    float _2658 = _2657 * _2657;
    float _2663 = 1.0f - _2640;
    float _2664 = _2663 * _2663;
    float _2692;
    if (DIFFUSE_BRDF_MODE >= 2.0f) {
      // EON 2025 Diffuse
      float _eon_LdotV = dot(float3(_2623, _2624, _2625), float3(_431, _433, _435));
      _2692 = _2648 * EON_DiffuseScalar(_2648, _2640, _eon_LdotV, _2647);
    } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
      // Hammon 2017 Diffuse
      _2692 = _2648 * HammonDiffuseScalar(_2648, _2640, _2642, _2645, _2647);
    } else {
      // Vanilla Burley Diffuse
      _2692 = saturate((_2648 * 0.31830987334251404f) * ((((((1.0f - ((_2658 * _2658) * (_2657 * 0.75f))) * (1.0f - ((_2664 * _2664) * (_2663 * 0.75f)))) - _2656) * saturate((_2651 * 2.200000047683716f) + -0.5f)) + _2656) + ((exp2(-0.0f - (max(((_2651 * 73.19999694824219f) + -21.200000762939453f), 8.899999618530273f) * sqrt(_2642))) * _2645) * ((((_2651 * 34.5f) + -59.0f) * _2651) + 24.5f))));
    }
    int _2693 = _2580 & 126;
    bool __defer_2622_2703 = false;
    bool __branch_chain_2622;
    if (((int)(_2580 == 98)) | ((int)(_2693 == 96))) {
      _2704 = true;
      __branch_chain_2622 = true;
    } else {
      if ((uint)(_2580 + -105) < (uint)2) {
        _2704 = _165;
        __branch_chain_2622 = true;
      } else {
        if (!((uint)(_2580 + -11) < (uint)9)) {
          _2704 = false;
          __branch_chain_2622 = true;
        } else {
          __branch_chain_2622 = false;
        }
      }
    }
    if (__branch_chain_2622) {
      __defer_2622_2703 = true;
    } else {
      _2712 = 0.0f;
    }
    if (__defer_2622_2703) {
      if (((int)(_2580 == 65)) | (((int)(((int)(_2580 == 107)) | (_2704))))) {
        _2712 = 0.0f;
      } else {
        _2712 = float(_2251);
      }
    }
    bool _2713 = (_2580 == 53);
    float _2714 = float(_2253);
    float _2715 = float(_2254);
    float _2716 = float(_2255);
    if (_2713) {
      _2723 = saturate(((_2715 + _2714) + _2716) * 1.2000000476837158f);
    } else {
      _2723 = 1.0f;
    }
    float _2729 = (0.699999988079071f / min(max(max(max(_2714, _2715), _2716), 0.009999999776482582f), 0.699999988079071f)) * _2723;
    float _2739 = (((_2729 * _2714) + -0.03999999910593033f) * _2712) + 0.03999999910593033f;
    float _2740 = (((_2729 * _2715) + -0.03999999910593033f) * _2712) + 0.03999999910593033f;
    float _2741 = (((_2729 * _2716) + -0.03999999910593033f) * _2712) + 0.03999999910593033f;
    float _2742 = float(_2252);
    bool _2743 = (_2693 == 64);
    bool _2746 = ((((int)(uint)(_2743)) & _1945) == 0);
    if (!_2746) {
      _2758 = select((_cavityParams.z > 0.0f), 0.0f, 1.0f);
    } else {
      _2758 = saturate(exp2((_2742 * _2742) * (_107 * -0.005770780146121979f)));
    }
    float _2759 = select(_1964, 1.0f, _2758);
    if (_2743) {
      _2765 = (_2759 * _2739);
      _2766 = (_2759 * _2740);
      _2767 = (_2759 * _2741);
    } else {
      _2765 = _2739;
      _2766 = _2740;
      _2767 = _2741;
    }
    float _2770 = saturate(1.0f - saturate(dot(float3(_431, _433, _435), float3(_2634, _2635, _2636))));
    float _2771 = _2770 * _2770;
    float _2773 = (_2771 * _2771) * _2770;
    float _2776 = _2773 * saturate(_2766 * 50.0f);
    float _2777 = 1.0f - _2773;
    if (!_273) {
      float _2785 = saturate(_2638);
      float _2786 = 1.0f - _2649;
      float _2798 = (((_2650 * _2642) - _2642) * _2642) + 1.0f;
      float _2802 = (_2650 / ((_2798 * _2798) * 3.1415927410125732f)) * (0.5f / ((((_2786 * _2640) + _2649) * _2638) + (((_2786 * _2638) + _2649) * _2640)));
      _2816 = ((_2785 * _2543) * max((_2802 * ((_2777 * _2765) + _2776)), 0.0f));
      _2817 = ((_2785 * _2544) * max((_2802 * ((_2777 * _2766) + _2776)), 0.0f));
      _2818 = ((_2785 * _2545) * max((_2802 * ((_2777 * _2767) + _2776)), 0.0f));
    } else {
      _2816 = 0.0f;
      _2817 = 0.0f;
      _2818 = 0.0f;
    }
    // RenoDX: Diffraction on Rough Surfaces
    if (DIFFRACTION > 0.0f && _2712 > 0.0f) {
      float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
        _2642,                                    // NdotH
        _2640,                                    // NdotV
        _rndx_spec_rough,                         // roughness
        float2(_95, _96),                         // screen UV
        _107,                                     // linear depth
        float3(_2634, _2635, _2636),              // half vector H
        float3(_2609, _2610, _2611),              // shading normal N
        float3(_2714, _2715, _2716)               // F0 (base reflectance)
      );
      float3 _rndx_dMod = lerp(float3(1.0f, 1.0f, 1.0f), _rndx_dShift, DIFFRACTION * _2712);
      _2816 *= _rndx_dMod.x;
      _2817 *= _rndx_dMod.y;
      _2818 *= _rndx_dMod.z;
    }
    // RenoDX: Callisto Smooth Terminator
    if (SMOOTH_TERMINATOR > 0.0f) {
      float _rndx_c2 = CallistoSmoothTerminator(_2648, _2645, _2642, SMOOTH_TERMINATOR, 0.5f);
      _2692 *= _rndx_c2;
      _2816 *= _rndx_c2;
      _2817 *= _rndx_c2;
      _2818 *= _rndx_c2;
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
      float wrappedNdotL = max(0.0f, (_2637 + wrap) / (1.0f + wrap));
      float vanillaNdotL = saturate(_2637);
      if (vanillaNdotL > 0.01f) {
        _2692 *= (wrappedNdotL / vanillaNdotL) * energyScale;
      } else {
        _2692 = wrappedNdotL * 0.31830987334251404f * energyScale;
      }
      // Back face transmission: multiply by shadow colour (_2543/4/5) and light intensity
      // so shadowed foliage does not transmit unshadowed light
      // Maybe I will figure out a better way
      float transmissionNdotL = pow(saturate(-_2637), 1.5f);
      foliageTransR = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _2714 * _2543 * _2626;
      foliageTransG = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _2715 * _2544 * _2627;
      foliageTransB = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _2716 * _2545 * _2628;
    }
    // RenoDX: Foliage diffuse energy compensation
    if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
      float _fNdotV = max(_2640, 0.001);
      float _fNdotL = saturate(_2637);
      float _fOneMinusV = 1.0 - _fNdotV;
      float _fOneMinusL = 1.0 - _fNdotL;
      float _fGrazingBoost = _fOneMinusV * _fOneMinusV * _fOneMinusL;
      float _fRoughFactor = _2647 * _2647;
      float _fCompensation = _fGrazingBoost * _fRoughFactor * 10.0;
      _2692 += _fCompensation * _fNdotL * RDXL_INV_PI;
    }
    if ((_2553) | ((int)(_2693 == 6))) {
      _2827 = ((max(0.0f, (0.30000001192092896f - _2637)) * 0.23190687596797943f) + _2692);
    } else {
      _2827 = _2692;
    }
    float _2834 = ((_2543 * _2827) * _2626) + (_1202 * _1147) + foliageTransR;
    float _2835 = ((_2544 * _2827) * _2627) + (_1203 * _1147) + foliageTransG;
    float _2836 = ((_2545 * _2827) * _2628) + (_1204 * _1147) + foliageTransB;
    uint _2839 = (int4(_frameNumber).x) * 13;
    [branch]
    if (((((int)(_2839 + _85)) | ((int)(_2839 + _87))) & 31) == 0) {
      __3__38__0__1__g_sceneColorLightingOnlyForAwbUAV[int2(((int)(_85 >> 5)), ((int)(_87 >> 5)))] = half4(half(_2834), half(_2835), half(_2836), 1.0h);
    }
    bool _2854 = ((uint)(_2580 & 24) > (uint)23);
    if (!_2746) {
      _2871 = select((_cavityParams.z > 0.0f), select(_166, 0.0f, _420), 1.0f);
    } else {
      _2871 = saturate(exp2((_2742 * _2742) * (_107 * -0.005770780146121979f)));
    }
    float _2889 = select(_2743, 1.0f, (select((_cavityParams.x == 0.0f), 1.0f, _2871) * select(((_165) & (_2854)), (1.0f - _420), 1.0f)));
    float _2893 = min(60000.0f, (_2889 * (((((_1978.x * _1971) + _1978.y) * _1927) * _1989) - min(0.0f, (-0.0f - (_2626 * _2816))))));
    float _2894 = min(60000.0f, (_2889 * (((((_1978.x * _1972) + _1978.y) * _1928) * _1989) - min(0.0f, (-0.0f - (_2627 * _2817))))));
    float _2895 = min(60000.0f, (_2889 * (((((_1978.x * _1973) + _1978.y) * _1929) * _1989) - min(0.0f, (-0.0f - (_2628 * _2818))))));
    float _2898 = 1.0f - _renderParams.x;
    half _2905 = half((_renderParams.x * _2714) + _2898);
    half _2906 = half((_renderParams.x * _2715) + _2898);
    half _2907 = half((_renderParams.x * _2716) + _2898);
    if ((_2743) & ((int)(_renderParams2.x == 0.0f))) {
      _2923 = (pow(_2905, 0.5h));
      _2924 = (pow(_2906, 0.5h));
      _2925 = (pow(_2907, 0.5h));
    } else {
      _2923 = _2905;
      _2924 = _2906;
      _2925 = _2907;
    }
    float _2926 = float(_2923);
    float _2927 = float(_2924);
    float _2928 = float(_2925);
    if (_2713) {
      _2935 = saturate(((_2927 + _2926) + _2928) * 1.2000000476837158f);
    } else {
      _2935 = 1.0f;
    }
    float _2936 = float(_2251);
    float _2942 = (0.699999988079071f / min(max(max(max(_2926, _2927), _2928), 0.009999999776482582f), 0.699999988079071f)) * _2935;
    float _2949 = ((_2942 * _2926) + -0.03999999910593033f) * _2936;
    float _2950 = ((_2942 * _2927) + -0.03999999910593033f) * _2936;
    float _2951 = ((_2942 * _2928) + -0.03999999910593033f) * _2936;
    float _2952 = _2949 + 0.03999999910593033f;
    float _2953 = _2950 + 0.03999999910593033f;
    float _2954 = _2951 + 0.03999999910593033f;
    float _2958 = (_2952 * _1978.x) + _1978.y;
    float _2959 = (_2953 * _1978.x) + _1978.y;
    float _2960 = (_2954 * _1978.x) + _1978.y;
    float _2962 = (1.0f - _1978.y) - _1978.x;
    float _2969 = ((0.9599999785423279f - _2949) * 0.0476190485060215f) + _2952;
    float _2970 = ((0.9599999785423279f - _2950) * 0.0476190485060215f) + _2953;
    float _2971 = ((0.9599999785423279f - _2951) * 0.0476190485060215f) + _2954;
    float _2988 = saturate(1.0f - _2256);
    float _2989 = (((_2958 * _2969) / (1.0f - (_2969 * _2962))) * _2962) * _2988;
    float _2990 = (((_2959 * _2970) / (1.0f - (_2970 * _2962))) * _2962) * _2988;
    float _2991 = (((_2960 * _2971) / (1.0f - (_2971 * _2962))) * _2962) * _2988;
    float _3002 = float(1.0h - _2251);
    half _3012 = half(((_2926 * _3002) * saturate((1.0f - _2989) - _2958)) + _2989);
    half _3013 = half(((_2927 * _3002) * saturate((1.0f - _2990) - _2959)) + _2990);
    half _3014 = half(((_2928 * _3002) * saturate((1.0f - _2991) - _2960)) + _2991);
    float _3017 = __3__36__0__0__g_caustic.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_95, _96), 0.0f);
    float _3019 = _3017.x * 0.31830987334251404f;
    float _3029 = ((_3019 * _2538) + _2834) * float(_3012);
    float _3030 = ((_3019 * _2539) + _2835) * float(_3013);
    float _3031 = ((_3019 * _2540) + _2836) * float(_3014);
    float _3035 = _3029 + (_2893 * _2936);
    float _3036 = _3030 + (_2894 * _2936);
    float _3037 = _3031 + (_2895 * _2936);
    float _3059 = (((QuadReadLaneAt(_3035,1) + QuadReadLaneAt(_3035,0)) + QuadReadLaneAt(_3035,2)) + QuadReadLaneAt(_3035,3)) * 0.25f;
    float _3060 = (((QuadReadLaneAt(_3036,1) + QuadReadLaneAt(_3036,0)) + QuadReadLaneAt(_3036,2)) + QuadReadLaneAt(_3036,3)) * 0.25f;
    float _3061 = (((QuadReadLaneAt(_3037,1) + QuadReadLaneAt(_3037,0)) + QuadReadLaneAt(_3037,2)) + QuadReadLaneAt(_3037,3)) * 0.25f;
    [branch]
    if (((_87 | _85) & 1) == 0) {
      float _3066 = dot(float3(_3059, _3060, _3061), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      __3__38__0__1__g_diffuseHalfPrevUAV[int2(((int)(_85 >> 1)), ((int)(_87 >> 1)))] = float4(min(60000.0f, _3059), min(60000.0f, _3060), min(60000.0f, _3061), min(60000.0f, select((_1018 != 0), (-0.0f - _3066), _3066)));
    }
    if (_2854) {
      _3088 = (((int)(_2251 == 0.0h)) & (((int)(!((((int)((((int)(!(_3012 == 0.0h)))) & (((int)(!(_3013 == 0.0h))))))) & (((int)(!(_3014 == 0.0h)))))))));
    } else {
      _3088 = false;
    }
    bool __defer_3087_3101 = false;
    if (((_2854) | (((int)(((int)(_2580 == 96)) | (((int)(((int)(_2580 == 54)) | ((int)((_2580 & 124) == 64))))))))) || ((!((_2854) | (((int)(((int)(_2580 == 96)) | (((int)(((int)(_2580 == 54)) | ((int)((_2580 & 124) == 64)))))))))) && (((int)(_107 <= 10.0f)) & ((int)((uint)(_2580 + -97) < (uint)2))))) {
      __defer_3087_3101 = true;
    } else {
      _3124 = (_3029 + _2893);
      _3125 = (_3030 + _2894);
      _3126 = (_3031 + _2895);
    }
    if (__defer_3087_3101) {
      __3__38__0__1__g_sceneSpecularUAV[int2(_85, _87)] = half4((-0.0h - half(min(0.0f, (-0.0f - _2893)))), (-0.0h - half(min(0.0f, (-0.0f - _2894)))), (-0.0h - half(min(0.0f, (-0.0f - _2895)))), (-0.0h - half(min(0.0f, (-0.0f - _1937)))));
      _3124 = _3029;
      _3125 = _3030;
      _3126 = _3031;
    }
    float _3127 = min(60000.0f, _3124);
    float _3128 = min(60000.0f, _3125);
    float _3129 = min(60000.0f, _3126);
    [branch]
    if (_3088) {
      float4 _3132 = __3__38__0__1__g_sceneColorUAV.Load(int2(_85, _87));
      _3140 = (_3132.x + _3127);
      _3141 = (_3132.y + _3128);
      _3142 = (_3132.z + _3129);
    } else {
      _3140 = _3127;
      _3141 = _3128;
      _3142 = _3129;
    }
    if (!(_renderParams.y == 0.0f)) {
      float _3151 = dot(float3(_3140, _3141, _3142), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _3152 = min((max(0.009999999776482582f, _exposure3.w) * 4096.0f), _3151);
      float _3156 = max(9.999999717180685e-10f, _3151);
      _3161 = ((_3152 * _3140) / _3156);
      _3162 = ((_3152 * _3141) / _3156);
      _3163 = ((_3152 * _3142) / _3156);
    } else {
      _3161 = _3140;
      _3162 = _3141;
      _3163 = _3142;
    }
    __3__38__0__1__g_sceneColorUAV[int2(_85, _87)] = float4(_3161, _3162, _3163, 1.0f);
  }
}
