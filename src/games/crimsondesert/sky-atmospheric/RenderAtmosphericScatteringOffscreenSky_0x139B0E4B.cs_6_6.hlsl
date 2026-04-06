#include "sky_spectral_common.hlsli"
#include "sky_dawn_dusk_common.hlsli" 

Texture2D<float4> __3__36__0__0__g_climateTex2 : register(t3, space36);

Texture2D<float2> __3__36__0__0__g_texNetDensity : register(t33, space36);

Texture3D<float> __3__36__0__0__g_texCloudVolumeShadow : register(t72, space36);

Texture3D<float> __3__36__0__0__g_texCloudBase : register(t57, space36);

Texture3D<float> __3__36__0__0__g_texCloudDetail : register(t58, space36);

Texture2D<float4> __3__36__0__0__g_texCirrus : register(t8, space36);

Texture3D<float4> __3__36__0__0__g_texPrecomputedLUTSingleRayleigh : register(t59, space36);

Texture3D<float4> __3__36__0__0__g_texPrecomputedLUTSingleMie : register(t60, space36);

Texture3D<float4> __3__36__0__0__g_texPrecomputedLUTMulti : register(t61, space36);

Texture3D<float4> __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum : register(t64, space36);

Texture3D<float4> __3__36__0__0__g_texPrecomputedLUTMultiMie : register(t65, space36);

RWTexture2D<float4> __3__38__0__1__g_texSkyInscatterUAV : register(u2, space38);

RWTexture2D<float4> __3__38__0__1__g_texSkyExtinctionUAV : register(u3, space38);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b3, space35) {
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

cbuffer __3__35__0__0__WeatherConstantBuffer : register(b23, space35) {
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

cbuffer __3__35__0__0__AtmosphereConstantBuffer : register(b13, space35) {
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

cbuffer __3__35__0__0__PrecomputedAmbientConstantBuffer : register(b14, space35) {
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

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _renderFlags : packoffset(c000.x);
  float4 _skyColor : packoffset(c001.x);
  float4 _volumeSize : packoffset(c002.x);
};

SamplerState __0__95__0__0__g_samplerAnisotropicWrap : register(s8, space95);

SamplerState __0__4__0__0__g_staticBilinearWrap : register(s0, space4);

SamplerState __0__4__0__0__g_staticBilinearWrapUWClampV : register(s1, space4);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  float _30[4];
  float _31 = float((uint)SV_DispatchThreadID.x);
  float _32 = float((uint)SV_DispatchThreadID.y);
  float _53 = ((_bufferSizeAndInvSize.z * 2.0f) * ((((_31 + 0.5f) * 2.0f) + -0.5f) + float((uint)((uint)((int4(_frameNumber).x) & 1))))) + -1.0f;
  float _56 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * ((((_32 + 0.5f) * 2.0f) + -0.5f) + float((uint)((uint)(((uint)((uint)(int4(_frameNumber).x)) >> 1) & 1)))));
  float _92 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), 1.0000000116860974e-07f, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _56, (_53 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
  float _93 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), 1.0000000116860974e-07f, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _56, (_53 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _92;
  float _94 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), 1.0000000116860974e-07f, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _56, (_53 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _92;
  float _95 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), 1.0000000116860974e-07f, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _56, (_53 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _92;
  float _97 = rsqrt(dot(float3(_93, _94, _95), float3(_93, _94, _95)));
  float _98 = _97 * _93;
  float _99 = _97 * _94;
  float _100 = _97 * _95;
  float _103 = float((uint)((uint)(((int)((int4(_frameNumber).x) * 73)) & 255)));
  float _111 = frac(frac(dot(float2(((_103 * 32.665000915527344f) + _31), ((_103 * 11.8149995803833f) + _32)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
  float _129 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
  float _130 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _viewPos.y;
  float _131 = dot(float3(_98, _99, _100), float3(_98, _99, _100));
  float _133 = dot(float3(0.0f, _130, 0.0f), float3(_98, _99, _100)) * 2.0f;
  float _134 = dot(float3(0.0f, _130, 0.0f), float3(0.0f, _130, 0.0f));
  float _137 = _133 * _133;
  float _138 = _131 * 4.0f;
  float _140 = _137 - ((_134 - (_129 * _129)) * _138);
  float _148;
  int _234;
  float _235;
  float _236;
  float _237;
  float _238;
  float _239;
  float _240;
  float _241;
  float _242;
  float _243;
  float _244;
  float _245;
  float _246;
  float _247;
  float _248;
  int _249;
  int _250;
  float _251;
  float _451;
  float _463;
  float _555;
  float _594;
  float _608;
  float _609;
  float _610;
  float _611;
  float _612;
  float _613;
  float _757;
  float _767;
  float _870;
  float _871;
  float _872;
  float _930;
  float _942;
  float _943;
  float _944;
  float _945;
  float _946;
  float _947;
  float _948;
  float _949;
  int _950;
  float _1121;
  float _1122;
  float _1149;
  float _1333;
  float _1345;
  float _1471;
  float _1481;
  float _1489;
  float _1490;
  float _1535;
  float _1566;
  float _1983;
  float _1984;
  float _1985;
  float _1986;
  float _1987;
  float _1988;
  float _2002;
  int _2003;
  int _2004;
  float _2005;
  float _2006;
  float _2007;
  float _2008;
  float _2009;
  float _2010;
  float _2011;
  float _2012;
  float _2013;
  float _2014;
  float _2015;
  float _2016;
  float _2017;
  float _2018;
  int _2019;
  int _2020;
  float _2046;
  float _2058;
  float _2107;
  float _2210;
  float _2250;
  float _2264;
  float _2265;
  float _2266;
  float _2267;
  float _2268;
  float _2269;
  float _2423;
  float _2435;
  float _2525;
  float _2526;
  float _2527;
  float _2586;
  float _2598;
  float _2599;
  float _2600;
  float _2601;
  float _2602;
  float _2603;
  float _2604;
  float _2605;
  int _2606;
  float _2777;
  float _2778;
  float _2805;
  float _2989;
  float _3001;
  float _3127;
  float _3137;
  float _3145;
  float _3146;
  float _3191;
  float _3222;
  float _3557;
  float _3558;
  float _3559;
  float _3560;
  float _3561;
  float _3562;
  float _3563;
  float _3564;
  float _3565;
  float _3566;
  float _3567;
  float _3647;
  float _3754;
  float _3850;
  float _3856;
  float _4003;
  float _4063;
  float _4104;
  float _4109;
  float _4145;
  float _4146;
  float _4147;
  float _4148;
  float _4149;
  float _4150;
  float _4151;
  float _4152;
  float _4153;
  float _4256;
  float _4257;
  float _4258;
  float _4259;
  float _4260;
  float _4261;
  float _4273;
  float _4274;
  float _4275;
  if (!(_140 < 0.0f)) {
    _148 = ((sqrt(_140) - _133) / (_131 * 2.0f));
  } else {
    _148 = -1.0f;
  }
  // [DAWN_DUSK] Mie phase boost
  float _dawnDuskFactor = DawnDuskFactor(_sunDirection.y);
  float _boostedMieG = MiePhaseBoostedG(_miePhaseConst, _dawnDuskFactor);

  if (!(_148 <= 0.0f)) {
    float _157 = dot(float3(_98, _99, _100), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
    float _160 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y);
    float _167 = (_157 * _157) + 1.0f;
    float _168 = _160 + 1.0f;
    float _169 = _157 * 2.0f;
    float _176 = (((1.0f - _160) * 3.0f) / ((_160 + 2.0f) * 2.0f)) * 0.07957746833562851f;
    float _177 = (_167 / exp2(log2(_168 - ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * _169)) * 1.5f)) * _176;
    float _179 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z) * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z);
    float _185 = _179 + 1.0f;
    float _186 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z) * -2.0f;
    float _193 = (((1.0f - _179) * 3.0f) / ((_179 + 2.0f) * 2.0f)) * 0.039788734167814255f;
    float _195 = ((_167 / exp2(log2(_185 - (_186 * _157)) * 1.5f)) * _193) + _177;
    float _201 = dot(float3(_98, _99, _100), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
    float _203 = (_201 * _201) + 1.0f;
    float _204 = _201 * 2.0f;
    float _211 = (_203 / exp2(log2(_168 - (_204 * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y))) * 1.5f)) * _176;
    float _219 = ((_203 / exp2(log2(_185 - (_186 * _201)) * 1.5f)) * _193) + _211;
    float _222 = min((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y), ((((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y) * -0.8999999761581421f) * saturate(_99 * 8.0f)) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y)));
    if (_renderFlags.x > 0.5f) {
      float _229 = log2(exp2(log2(max(1.0f, ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y) * 0.00033333332976326346f))) * 0.015625f));
      _234 = 1;
      _235 = 0.0f;
      _236 = 0.0f;
      _237 = 0.0f;
      _238 = 0.0f;
      _239 = 0.0f;
      _240 = 0.0f;
      _241 = 0.0f;
      _242 = 0.0f;
      _243 = 0.0f;
      _244 = 0.0f;
      _245 = 0.0f;
      _246 = 0.0f;
      _247 = 0.0f;
      _248 = 0.0f;
      _249 = 0;
      _250 = 0;
      _251 = 128.0f;
      while(true) {
        float _253 = float((int)(_249));
        float _263 = (((exp2(select(((uint)_249 < (uint)12), (_253 * 0.33000001311302185f), (_253 + -8.039999008178711f)) * _229) + -1.0f) * (_222 + -128.0f)) / (exp2(_229 * 64.0f) + -1.0f)) + 128.0f;
        float _264 = min(_263, _148);
        float _266 = max(0.0f, (_264 - _251));
        float _268 = (_266 * _111) + _251;
        float _271 = (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * _266;
        float _272 = _268 * _98;
        float _274 = _268 * _100;
        float _275 = _272 + _viewPos.x;
        float _276 = (_268 * _99) + _viewPos.y;
        float _277 = _274 + _viewPos.z;
        float4 _299 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_275 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_277 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
        float _306 = (_264 * _98) + _viewPos.x;
        float _307 = (_264 * _99) + _viewPos.y;
        float _308 = (_264 * _100) + _viewPos.z;
        float _312 = _306 - _viewPos.x;
        float _313 = _308 - _viewPos.z;
        float _316 = (_312 * _312) + (_313 * _313);
        float _317 = sqrt(_316);
        float _324 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_317 * _317) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
        float _327 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
        float _330 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
        float _335 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _307;
        float _341 = ((sqrt(_316 + (_335 * _335)) - _324) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
        if (!(((int)(_341 < 0.0f)) | ((int)(_341 > 1.0f)))) {
          float _365 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
          float _366 = _307 - _324;
          float _377 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_330 * (_306 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_330 * _366) - _365), (_330 * (_308 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _382 = _327 / _330;
          float _383 = _382 * _330;
          float _385 = _382 * _365;
          float _391 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_327 * _306) - (_383 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_366 * _327) - _385), ((_327 * _308) - (_383 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _397 = saturate(max((_317 + -2500.0f), 0.0f) * 0.05000000074505806f);
          float _401 = (4.0f - (_397 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
          float _405 = _383 * 4.355000019073486f;
          float _412 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_401 * _306) - (_405 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_401 * _366) - (_385 * 4.355000019073486f)), ((_401 * _308) - (_405 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _422 = 1.0f - sqrt(saturate((1.0f - _341) * 1.4285714626312256f));
          float _444 = ((((1.0f - _391.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_397 * 0.4000000059604645f) + 0.10000000149011612f)) * _412.x) * ((saturate(_341 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
          _451 = (saturate(((saturate(saturate(((_299.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_377.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_422 * 0.5f), ((_422 * _422) * _422))) * saturate(_341 * 10.0f)) - _444) / (1.0f - _444)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
        } else {
          _451 = 0.0f;
        }
        bool _453 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
        if (_453) {
          _463 = saturate((((1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z)) * _317) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
        } else {
          _463 = 1.0f;
        }
        bool _465 = ((_463 * _451) > 0.0010000000474974513f);
        if (((int)(_250 != 0)) & (_465)) {
          _2002 = _251;
          _2003 = 0;
          _2004 = ((int)(_249 + -2u));
          _2005 = _248;
          _2006 = _247;
          _2007 = _246;
          _2008 = _245;
          _2009 = _244;
          _2010 = _243;
          _2011 = _242;
          _2012 = _241;
          _2013 = _240;
          _2014 = _239;
          _2015 = _238;
          _2016 = _237;
          _2017 = _236;
          _2018 = _235;
          _2019 = _234;
          _2020 = 0;
        } else {
          bool _471 = ((uint)_249 < (uint)62);
          int _473 = ((int)(uint)(_465)) ^ 1;
          uint _476 = _249 + (uint)(select(_471, _473, 0));
          float _478 = (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x) + (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
          float _495 = _276 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          float _501 = sqrt(((_274 * _274) + (_272 * _272)) + (_495 * _495));
          float _502 = _272 / _501;
          float _503 = _495 / _501;
          float _504 = _274 / _501;
          float _505 = _501 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          if (_505 > 0.0f) {
            float _508 = dot(float3(_502, _503, _504), float3(_98, _99, _100));
            float _517 = min(max(_505, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
            float _525 = max(_517, 0.0f);
            float _532 = (-0.0f - sqrt((_525 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _525)) / (_525 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            bool _533 = (_508 > _532);
            if (_533) {
              _555 = ((exp2(log2(saturate((_508 - _532) / (1.0f - _532))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _555 = ((exp2(log2(saturate((_532 - _508) / (_532 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _557 = (exp2(log2(saturate((_517 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
            float4 _564 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_557, _555, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_502, _503, _504), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
            if (_533) {
              _594 = ((exp2(log2(saturate((_508 - _532) / (1.0f - _532))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _594 = ((exp2(log2(saturate((_532 - _508) / (_532 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float4 _600 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_557, _594, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_502, _503, _504), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
            _608 = _564.x;
            _609 = _564.y;
            _610 = _564.z;
            _611 = (_600.x * 0.25f);
            _612 = (_600.y * 0.25f);
            _613 = (_600.z * 0.25f);
          } else {
            _608 = 0.0f;
            _609 = 0.0f;
            _610 = 0.0f;
            _611 = 0.0f;
            _612 = 0.0f;
            _613 = 0.0f;
          }
          float _622 = max(_505, 0.009999999776482582f);
          float _623 = -0.0f - _622;
          float _631 = exp2((_623 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f);
          float _632 = exp2((_623 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f);
          float _633 = _275 - _viewPos.x;
          float _634 = _277 - _viewPos.z;
          float _637 = (_633 * _633) + (_634 * _634);
          float _638 = sqrt(_637);
          float _642 = max(((_638 * _638) + -4e+05f), 0.0f) * 9.999999974752427e-07f;
          float _643 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - _642;
          float _644 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _276;
          float _650 = ((sqrt(_637 + (_644 * _644)) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _643) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
          if (!(((int)(_650 < 0.0f)) | ((int)(_650 > 1.0f)))) {
            float _674 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
            float _675 = _276 - _643;
            float _686 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_330 * (_275 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_675 * _330) - _674), (_330 * (_277 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _691 = _327 / _330;
            float _692 = _691 * _330;
            float _694 = _691 * _674;
            float _700 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_327 * _275) - (_692 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_675 * _327) - _694), ((_327 * _277) - (_692 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _710 = (4.0f - (saturate(max((_638 + -2500.0f), 0.0f) * 0.05000000074505806f) * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
            float _714 = _692 * 4.355000019073486f;
            float _721 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_710 * _275) - (_714 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_710 * _675) - (_694 * 4.355000019073486f)), ((_710 * _277) - (_714 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _731 = 1.0f - sqrt(saturate((1.0f - _650) * 1.4285714626312256f));
            float _750 = (((1.0f - _700.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * _721.x) * ((saturate(_650 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
            _757 = (saturate(((saturate(saturate(((_299.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_686.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_731 * 0.5f), ((_731 * _731) * _731))) * saturate(_650 * 10.0f)) - _750) / (1.0f - _750)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
          } else {
            _757 = 0.0f;
          }
          if (_453) {
            _767 = saturate(((_638 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
          } else {
            _767 = 1.0f;
          }
          float _768 = _767 * _757;
          float _770 = _276 - _viewPos.y;
          float _773 = sqrt(_637 + (_770 * _770));
          float _779 = max(9.999999974752427e-07f, ((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).z) * 0.0024999999441206455f));
          float _782 = _779 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z);
          float _783 = _779 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w);
          float _784 = _779 * _275;
          float _785 = _779 * _276;
          float _786 = _779 * _277;
          float _799 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_784 * 0.5127000212669373f) - _782), (_785 * 0.5127000212669373f), ((_786 * 0.5127000212669373f) - _783)), 0.0f);
          float _812 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_784 * 6.393881797790527f) - (_782 * 1.871000051498413f)), (_785 * 6.393881797790527f), ((_786 * 6.393881797790527f) - (_783 * 1.871000051498413f))), 0.0f);
          float _821 = (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).y) * -0.14426951110363007f;
          float _836 = (((saturate(_773 * 0.0078125f) * 2.0f) * (1.0f - _799.x)) * (((0.5f - _812.x) * saturate((_773 + -300.0f) * 0.0024999999441206455f)) + _812.x)) * ((exp2(_821 * max(0.0010000000474974513f, (_622 - (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).x)))) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).w)) + (exp2(_821 * max(0.0010000000474974513f, ((_622 - (float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).z)) - (((float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).w) - (float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).z)) * _299.z)))) * _299.y));
          float _837 = _276 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
          float _839 = (_642 + _837) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
          bool _842 = ((int)(_sunDirection.y > 0.0f)) | ((int)(_sunDirection.y > _moonDirection.y));
          float _843 = select(_842, _sunDirection.x, _moonDirection.x);
          float _844 = select(_842, _sunDirection.y, _moonDirection.y);
          float _845 = select(_842, _sunDirection.z, _moonDirection.z);
          bool _846 = (_844 > 0.0f);
          float _855 = ((0.5f - (float((int)(((int)(uint)(_846)) - ((int)(uint)((int)(_844 < 0.0f))))) * 0.5f)) * (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) + _643;
          if (_276 < _643) {
            float _858 = dot(float3(0.0f, 1.0f, 0.0f), float3(_843, _844, _845));
            float _864 = select((abs(_858) < 9.99999993922529e-09f), 1e+08f, ((_855 - dot(float3(0.0f, 1.0f, 0.0f), float3(_275, _276, _277))) / _858));
            _870 = ((_864 * _843) + _275);
            _871 = _855;
            _872 = ((_864 * _845) + _277);
          } else {
            _870 = _275;
            _871 = _276;
            _872 = _277;
          }
          float _883 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3((((_870 - _viewPos.x) * 4.999999873689376e-05f) + 0.5f), ((_871 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)), (((_872 - _viewPos.z) * 4.999999873689376e-05f) + 0.5f)), 0.0f);
          float _886 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _891 = abs(_844);
          float _893 = saturate(_891 * 4.0f);
          float _895 = (_893 * _893) * exp2((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * -1.4426950216293335f) * _883.x) * _886);
          float _901 = ((1.0f - _895) * saturate((_837 - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) * 0.10000000149011612f)) + _895;
          float _904 = -0.0f - _886;
          float _905 = (log2(_901) * 0.6931471824645996f) / _904;
          if (((int)(_768 > 0.0010000000474974513f)) & (((int)(((int)(_839 >= 0.0f)) & ((int)(_839 <= 1.0f)))))) {
            float _917 = (_276 - _643) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_917 < 0.0f)) | ((int)(_917 > 1.0f)))) {
              if (_891 > 0.0010000000474974513f) {
                _930 = min(300.0f, (((_643 - _276) + select(_846, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x), 0.0f)) / _844));
              } else {
                _930 = 300.0f;
              }
              float _931 = _930 * 0.20000000298023224f;
              float _932 = _931 * _843;
              float _933 = _931 * _844;
              float _934 = _931 * _845;
              _942 = 0.0f;
              _943 = _931;
              _944 = _932;
              _945 = _933;
              _946 = _934;
              _947 = ((_932 * 0.5f) + _275);
              _948 = ((_933 * 0.5f) + _276);
              _949 = ((_934 * 0.5f) + _277);
              _950 = 0;
              while(true) {
                float _956 = _947 - _viewPos.x;
                float _957 = _949 - _viewPos.z;
                float _960 = (_956 * _956) + (_957 * _957);
                float _961 = sqrt(_960);
                float _968 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_961 * _961) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                float _973 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
                float _975 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
                float _980 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _948;
                float _986 = ((sqrt(_960 + (_980 * _980)) - _968) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                if (!(((int)(_986 < 0.0f)) | ((int)(_986 > 1.0f)))) {
                  float4 _1019 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((((_947 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - (((_949 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                  float _1030 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                  float _1031 = _948 - _968;
                  float _1042 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_975 * (_947 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_975 * _1031) - _1030), (_975 * (_949 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1047 = _973 / _975;
                  float _1048 = _1047 * _975;
                  float _1050 = _1047 * _1030;
                  float _1056 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_973 * _947) - (_1048 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_973 * _1031) - _1050), ((_973 * _949) - (_1048 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1062 = saturate(max((_961 + -2500.0f), 0.0f) * 0.05000000074505806f);
                  float _1066 = (4.0f - (_1062 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                  float _1070 = _1048 * 4.355000019073486f;
                  float _1077 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1066 * _947) - (_1070 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1066 * _1031) - (_1050 * 4.355000019073486f)), ((_1066 * _949) - (_1070 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1089 = 1.0f - sqrt(saturate((1.0f - _986) * 1.4285714626312256f));
                  float _1105 = saturate(saturate((((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + _1019.x) + ((_1042.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1089 * 0.5f), ((_1089 * _1089) * _1089))) * saturate(_986 * 10.0f);
                  float _1108 = ((_1077.x * (1.0f - _1056.x)) * ((saturate(_986 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f)) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x);
                  float _1109 = _1108 * ((_1062 * 0.4000000059604645f) + 0.10000000149011612f);
                  _1121 = (saturate((_1105 - _1108) / (1.0f - _1108)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                  _1122 = (saturate((_1105 - _1109) / (1.0f - _1109)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                } else {
                  _1121 = 0.0f;
                  _1122 = 0.0f;
                }
                float _1136 = (((exp2((((_942 * -0.007213474716991186f) * _943) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z))) * (_1121 - _1122)) + _1122) * _943) + _942;
                int _1144 = _950 + 1;
                if (!(_1144 == 6)) {
                  _942 = _1136;
                  _943 = (_943 * 1.2999999523162842f);
                  _944 = (_944 * 1.2999999523162842f);
                  _945 = (_945 * 1.2999999523162842f);
                  _946 = (_946 * 1.2999999523162842f);
                  _947 = (_947 + _944);
                  _948 = (_948 + _945);
                  _949 = (_949 + _946);
                  _950 = _1144;
                  continue;
                }
                _1149 = (_1136 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
                break;
              }
              if (__loop_jump_target == 233) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
            } else {
              _1149 = 0.0f;
            }
            float _1150 = max(_905, _1149);
            float _1154 = _275 - _viewPos.x;
            float _1155 = _277 - _viewPos.z;
            float _1156 = _1154 * _1154;
            float _1157 = _1155 * _1155;
            float _1159 = sqrt(_1156 + _1157);
            float _1170 = ((_276 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) + (max(((_1159 * _1159) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_1170 < 0.0f)) | ((int)(_1170 > 1.0f)))) {
              float4 _1196 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_275 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_277 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
              float _1198 = _275 + 50.0f;
              float _1199 = _276 + 200.0f;
              float _1200 = _1198 - _viewPos.x;
              float _1202 = (_1200 * _1200) + _1157;
              float _1203 = sqrt(_1202);
              float _1208 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_1203 * _1203) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
              float _1211 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
              float _1214 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
              float _1217 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _1199;
              float _1218 = _1217 * _1217;
              float _1223 = ((sqrt(_1202 + _1218) - _1208) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_1223 < 0.0f)) | ((int)(_1223 > 1.0f)))) {
                float _1247 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                float _1248 = _1199 - _1208;
                float _1259 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_1214 * (_1198 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1214 * _1248) - _1247), (_1214 * (_277 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1264 = _1211 / _1214;
                float _1265 = _1264 * _1214;
                float _1267 = _1264 * _1247;
                float _1273 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1211 * _1198) - (_1265 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1248 * _1211) - _1267), ((_1211 * _277) - (_1265 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1279 = saturate(max((_1203 + -2500.0f), 0.0f) * 0.05000000074505806f);
                float _1283 = (4.0f - (_1279 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                float _1287 = _1265 * 4.355000019073486f;
                float _1294 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1283 * _1198) - (_1287 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1283 * _1248) - (_1267 * 4.355000019073486f)), ((_1283 * _277) - (_1287 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1304 = 1.0f - sqrt(saturate((1.0f - _1223) * 1.4285714626312256f));
                float _1326 = ((((1.0f - _1273.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_1279 * 0.4000000059604645f) + 0.10000000149011612f)) * _1294.x) * ((saturate(_1223 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                _1333 = (saturate(((saturate(saturate(((_1196.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_1259.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1304 * 0.5f), ((_1304 * _1304) * _1304))) * saturate(_1223 * 10.0f)) - _1326) / (1.0f - _1326)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
              } else {
                _1333 = 0.0f;
              }
              bool _1335 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
              if (_1335) {
                _1345 = saturate(((_1203 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
              } else {
                _1345 = 1.0f;
              }
              float _1347 = _277 + -50.0f;
              float _1348 = _1347 - _viewPos.z;
              float _1350 = _1156 + (_1348 * _1348);
              float _1351 = sqrt(_1350);
              float _1356 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_1351 * _1351) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
              float _1361 = ((sqrt(_1350 + _1218) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _1356) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_1361 < 0.0f)) | ((int)(_1361 > 1.0f)))) {
                float _1385 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                float _1386 = _1199 - _1356;
                float _1397 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_1214 * (_275 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1386 * _1214) - _1385), (_1214 * (_1347 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1402 = _1211 / _1214;
                float _1403 = _1402 * _1214;
                float _1405 = _1402 * _1385;
                float _1411 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1211 * _275) - (_1403 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1386 * _1211) - _1405), ((_1211 * _1347) - (_1403 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1417 = saturate(max((_1351 + -2500.0f), 0.0f) * 0.05000000074505806f);
                float _1421 = (4.0f - (_1417 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                float _1425 = _1403 * 4.355000019073486f;
                float _1432 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1421 * _275) - (_1425 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1421 * _1386) - (_1405 * 4.355000019073486f)), ((_1421 * _1347) - (_1425 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1442 = 1.0f - sqrt(saturate((1.0f - _1361) * 1.4285714626312256f));
                float _1464 = ((((1.0f - _1411.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_1417 * 0.4000000059604645f) + 0.10000000149011612f)) * _1432.x) * ((saturate(_1361 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                _1471 = (saturate(((saturate(saturate(((_1196.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_1397.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1442 * 0.5f), ((_1442 * _1442) * _1442))) * saturate(_1361 * 10.0f)) - _1464) / (1.0f - _1464)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
              } else {
                _1471 = 0.0f;
              }
              if (_1335) {
                _1481 = saturate(((_1351 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
              } else {
                _1481 = 1.0f;
              }
              _1489 = _1150;
              _1490 = ((((_1481 * _1471) + (_1345 * _1333)) * 20.0f) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
            } else {
              _1489 = _1150;
              _1490 = 0.0f;
            }
          } else {
            _1489 = _905;
            _1490 = ((log2(max(_901, 0.5f)) * 0.6931471824645996f) / _904);
          }
          float _1491 = dot(float3(_502, _503, _504), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
          float _1496 = min(max(_622, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
          float _1504 = max(_1496, 0.0f);
          float _1512 = (-0.0f - sqrt((_1504 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _1504)) / (_1504 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
          if (_1491 > _1512) {
            _1535 = ((exp2(log2(saturate((_1491 - _1512) / (1.0f - _1512))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _1535 = ((exp2(log2(saturate((_1512 - _1491) / (_1512 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _1537 = (exp2(log2(saturate((_1496 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
          float2 _1540 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1537, _1535), 0.0f);
          float _1543 = dot(float3(_502, _503, _504), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
          if (_1543 > _1512) {
            _1566 = ((exp2(log2(saturate((_1543 - _1512) / (1.0f - _1512))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _1566 = ((exp2(log2(saturate((_1512 - _1543) / (_1512 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float2 _1567 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1537, _1566), 0.0f);
          float _1570 = _768 * saturate((1.0f - saturate(_268 / _222)) * 10.0f);
          float _1575 = _271 * 0.5f;
          float _1580 = ((_631 + _238) * _1575) + _242;
          float _1581 = ((_632 + _237) * _1575) + _241;
          float _1582 = ((_1570 + _236) * _1575) + _240;
          float _1583 = ((_836 + _235) * _1575) + _239;
          float _1584 = _1583 + _1582;
          float _1585 = _1540.x + _1580;
          // [SKY_SPECTRAL] Vanilla β for extinction/transmittance, spectral β for inscatter only
          float _1592_van = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255)));
          float _1595_van = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255)));
          float _1597_van = float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255)));
          float _1592 = _1592_van;
          float _1595 = _1595_van;
          float _1597 = _1597_van;
          if (SKY_SCATTERING) { float _skyRef1 = _1597_van; _1592 = _skyRef1 * SKY_RAYLEIGH_CH1; _1595 = _skyRef1 * SKY_RAYLEIGH_CH2; }
          float _1604 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f;
          float _1605 = _1604 * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f);
          float _1606 = _1605 * (_1540.y + _1581);
          float _1615 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _1616 = _1615 * (_1489 + _1584);
          // [SKY_SPECTRAL] Extinction uses vanilla β to preserve cloud energy
          float _1617 = (_1592_van * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
          float _1618 = _1617 * _1585;
          float _1619 = _1616 + _1606;
          float _1621 = (_1595_van * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
          float _1622 = _1621 * _1585;
          float _1624 = (_1597_van * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
          float _1625 = _1624 * _1585;
          float _1630 = exp2((_1618 + _1619) * -1.4426950216293335f);
          float _1631 = exp2((_1622 + _1619) * -1.4426950216293335f);
          float _1632 = exp2((_1625 + _1619) * -1.4426950216293335f);
          float _1645 = ((_1631 * _sky_mtx[0][1]) + (_1630 * _sky_mtx[0][0])) + (_1632 * _sky_mtx[0][2]);
          float _1646 = ((_1631 * _sky_mtx[1][1]) + (_1630 * _sky_mtx[1][0])) + (_1632 * _sky_mtx[1][2]);
          float _1647 = ((_1631 * _sky_mtx[2][1]) + (_1630 * _sky_mtx[2][0])) + (_1632 * _sky_mtx[2][2]);
          float _1648 = _1645 * _632;
          float _1649 = _1646 * _632;
          float _1650 = _1647 * _632;
          float _1651 = _1615 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _1658 = exp2(log2(1.0f - exp2((_1651 * -14.426950454711914f) * _1570)) * 1.25f);
          float _1662 = 1.0f - exp2((_1651 * -288.53900146484375f) * _836);
          float _1665 = _631 * 1.960784317134312e-07f;
          float _1666 = (_167 * 0.05968310311436653f) * _1665;
          float _1674 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
          float _1680 = _1674 + 1.0f;
          float _1687 = (((1.0f - _1674) * 3.0f) / ((_1674 + 2.0f) * 2.0f)) * 0.07957746833562851f;
          float _1693 = (_1687 * _1604) * (_167 / exp2(log2(_1680 - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _169)) * 1.5f));
          // [DAWN_DUSK] Sun HG uses boosted g — moon HG (_1852) still uses vanilla _1674/_1680/_1687
          float _1674b = _boostedMieG * _boostedMieG;
          float _1680b = _1674b + 1.0f;
          float _1687b = (((1.0f - _1674b) * 3.0f) / ((_1674b + 2.0f) * 2.0f)) * 0.07957746833562851f;
          float _1693b = (_1687b * _1604) * (_167 / exp2(log2(_1680b - (_boostedMieG * _169)) * 1.5f));
          float _1700 = _1570 * 64.0f;
          float _1702 = _1658 * (_1700 * _177);
          float _1710 = (_836 * 2.0f) * _195;
          float _1713 = ((_1710 * _1645) * _1662) * _volumeFogScatterColor.x;
          float _1716 = ((_1710 * _1646) * _1662) * _volumeFogScatterColor.y;
          float _1719 = ((_1710 * _1647) * _1662) * _volumeFogScatterColor.z;
          float _1749 = (_1615 * (_1490 + _1584)) + (_1605 * _1581);
          float _1758 = exp2(((_1617 * _1580) + _1749) * -1.4426950216293335f);
          float _1759 = exp2(((_1621 * _1580) + _1749) * -1.4426950216293335f);
          float _1760 = exp2(((_1624 * _1580) + _1749) * -1.4426950216293335f);
          float _1780 = _632 * _1604;
          float _1784 = _1615 * (_836 + _1570);
          float _1787 = SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(0, _1758,_1759,_1760, _1592,_1595,_1597, _1665) + SKY_VAN_DOT(0, _1758,_1759,_1760) * (_1784 + _mieScatterColor.x * _1780))
            : (((_1759 * _sky_mtx[0][1]) + (_1758 * _sky_mtx[0][0])) + (_1760 * _sky_mtx[0][2])) * (((_1592 * _1665) + _1784) + (_mieScatterColor.x * _1780));
          float _1792 = (((((_1693b * _1648) * _mieScatterColor.x) + ((_1592 * _1666) * _1645)) + ((_1713 + (_1702 * _1645)) * _1615)) + (_1787 * _608)) * _271;
          float _1795 = SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(1, _1758,_1759,_1760, _1592,_1595,_1597, _1665) + SKY_VAN_DOT(1, _1758,_1759,_1760) * (_1784 + _mieScatterColor.y * _1780))
            : (((_1759 * _sky_mtx[1][1]) + (_1758 * _sky_mtx[1][0])) + (_1760 * _sky_mtx[1][2])) * (((_1595 * _1665) + _1784) + (_mieScatterColor.y * _1780));
          float _1800 = (((((_1693b * _1649) * _mieScatterColor.y) + ((_1595 * _1666) * _1646)) + ((_1716 + (_1702 * _1646)) * _1615)) + (_1795 * _609)) * _271;
          float _1803 = SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(2, _1758,_1759,_1760, _1592,_1595,_1597, _1665) + SKY_VAN_DOT(2, _1758,_1759,_1760) * (_1784 + _mieScatterColor.z * _1780))
            : (((_1759 * _sky_mtx[2][1]) + (_1758 * _sky_mtx[2][0])) + (_1760 * _sky_mtx[2][2])) * ((_1784 + (_1597 * _1665)) + (_mieScatterColor.z * _1780));
          float _1808 = (((((_1693b * _1650) * _mieScatterColor.z) + ((_1597 * _1666) * _1647)) + ((_1719 + (_1702 * _1647)) * _1615)) + (_1803 * _610)) * _271;
          float _1809 = _1567.x + _1580;
          float _1811 = _1605 * (_1567.y + _1581);
          float _1812 = _1617 * _1809;
          float _1813 = _1616 + _1811;
          float _1815 = _1621 * _1809;
          float _1817 = _1624 * _1809;
          float _1822 = exp2((_1812 + _1813) * -1.4426950216293335f);
          float _1823 = exp2((_1815 + _1813) * -1.4426950216293335f);
          float _1824 = exp2((_1817 + _1813) * -1.4426950216293335f);
          float _1841 = (_203 * 0.05968310311436653f) * _1665;
          float _1852 = (_1780 * _1687) * (_203 / exp2(log2(_1680 - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _204)) * 1.5f));
          float _1862 = ((((_219 * 2.0f) * _836) * _1662) + ((_1700 * _211) * _1658)) * _1615;
          float _1869 = (((SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(0, _1822,_1823,_1824, _1592,_1595,_1597, _1841) + SKY_VAN_DOT(0, _1822,_1823,_1824) * (_1862 + _1852 * _mieScatterColor.x))
            : ((_1862 + (_1592 * _1841)) + (_1852 * _mieScatterColor.x)) * (((_1823 * _sky_mtx[0][1]) + (_1822 * _sky_mtx[0][0])) + (_1824 * _sky_mtx[0][2])))
            + (_1787 * _611)) * _271) + _248;
          float _1876 = (((SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(1, _1822,_1823,_1824, _1592,_1595,_1597, _1841) + SKY_VAN_DOT(1, _1822,_1823,_1824) * (_1862 + _1852 * _mieScatterColor.y))
            : ((_1862 + (_1595 * _1841)) + (_1852 * _mieScatterColor.y)) * (((_1823 * _sky_mtx[1][1]) + (_1822 * _sky_mtx[1][0])) + (_1824 * _sky_mtx[1][2])))
            + (_1795 * _612)) * _271) + _247;
          float _1883 = (((SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(2, _1822,_1823,_1824, _1592,_1595,_1597, _1841) + SKY_VAN_DOT(2, _1822,_1823,_1824) * (_1862 + _1852 * _mieScatterColor.z))
            : ((_1862 + (_1597 * _1841)) + (_1852 * _mieScatterColor.z)) * (((_1823 * _sky_mtx[2][1]) + (_1822 * _sky_mtx[2][0])) + (_1824 * _sky_mtx[2][2])))
            + (_1803 * _613)) * _271) + _246;
          if (_1570 > 0.0010000000474974513f) {
            float _1887 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * 0.5f;
            float _1888 = _1887 * _1887;
            float _1904 = _1615 * ((_1489 * 0.20000000298023224f) + _1584);
            float _1905 = _1904 + _1606;
            float _1912 = exp2((_1618 + _1905) * -1.4426950216293335f);
            float _1913 = exp2((_1622 + _1905) * -1.4426950216293335f);
            float _1914 = exp2((_1625 + _1905) * -1.4426950216293335f);
            float _1932 = ((((1.0f - _1888) * 3.0f) / ((_1888 + 2.0f) * 2.0f)) * 0.07957746833562851f) * ((_271 * 51.20000076293945f) * _1570);
            float _1934 = _1658 * _1615;
            float _1935 = _1934 * (_1932 * (_167 / exp2(log2((1.0f - ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * _157)) + _1888) * 1.5f)));
            float _1949 = _1904 + _1811;
            float _1956 = exp2((_1812 + _1949) * -1.4426950216293335f);
            float _1957 = exp2((_1815 + _1949) * -1.4426950216293335f);
            float _1958 = exp2((_1817 + _1949) * -1.4426950216293335f);
            float _1975 = _1934 * (_1932 * (_203 / exp2(log2((1.0f - ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * _201)) + _1888) * 1.5f)));
            _1983 = ((_1975 * (((_1957 * _sky_mtx[0][1]) + (_1956 * _sky_mtx[0][0])) + (_1958 * _sky_mtx[0][2]))) + _1869);
            _1984 = ((_1975 * (((_1957 * _sky_mtx[1][1]) + (_1956 * _sky_mtx[1][0])) + (_1958 * _sky_mtx[1][2]))) + _1876);
            _1985 = ((_1975 * (((_1957 * _sky_mtx[2][1]) + (_1956 * _sky_mtx[2][0])) + (_1958 * _sky_mtx[2][2]))) + _1883);
            _1986 = ((_1935 * (((_1913 * _sky_mtx[0][1]) + (_1912 * _sky_mtx[0][0])) + (_1914 * _sky_mtx[0][2]))) + _1792);
            _1987 = ((_1935 * (((_1913 * _sky_mtx[1][1]) + (_1912 * _sky_mtx[1][0])) + (_1914 * _sky_mtx[1][2]))) + _1800);
            _1988 = ((_1935 * (((_1913 * _sky_mtx[2][1]) + (_1912 * _sky_mtx[2][0])) + (_1914 * _sky_mtx[2][2]))) + _1808);
          } else {
            _1983 = _1869;
            _1984 = _1876;
            _1985 = _1883;
            _1986 = _1792;
            _1987 = _1800;
            _1988 = _1808;
          }
          float _1989 = saturate(float((int)(int(float((uint)_476) * 0.33000001311302185f))) + _111) * _precomputedAmbient7.y;
          _2002 = _264;
          _2003 = select(_471, _473, 0);
          _2004 = _476;
          _2005 = _1983;
          _2006 = _1984;
          _2007 = _1985;
          _2008 = ((((((_precomputedAmbients[48]).x) * _271) * (_1713 + (_1648 * _1604))) + _245) + (_1986 * _1989));
          _2009 = ((((((_precomputedAmbients[48]).y) * _271) * (_1716 + (_1649 * _1604))) + _244) + (_1987 * _1989));
          _2010 = ((((((_precomputedAmbients[48]).z) * _271) * (_1719 + (_1650 * _1604))) + _243) + (_1988 * _1989));
          _2011 = _1580;
          _2012 = _1581;
          _2013 = _1582;
          _2014 = _1583;
          _2015 = _631;
          _2016 = _632;
          _2017 = _1570;
          _2018 = _836;
          _2019 = ((int)(uint)((int)((((int)(((int)(_263 < _148)) & ((int)(_276 < _478))))) | ((int)(_viewPos.y > _478)))));
          _2020 = ((int)(uint)((int)(exp2((_1584 * -1.4426950216293335f) * _1615) < 0.0010000000474974513f)));
        }
        uint _2021 = _2004 + 1u;
        if ((((int)(((int)((uint)_2021 < (uint)64)) & ((int)(_2019 != 0))))) & ((int)(_2020 == 0))) {
          _234 = _2019;
          _235 = _2018;
          _236 = _2017;
          _237 = _2016;
          _238 = _2015;
          _239 = _2014;
          _240 = _2013;
          _241 = _2012;
          _242 = _2011;
          _243 = _2010;
          _244 = _2009;
          _245 = _2008;
          _246 = _2007;
          _247 = _2006;
          _248 = _2005;
          _249 = _2021;
          _250 = _2003;
          _251 = _2002;
          continue;
        }
        float _2029 = select((_2020 != 0), 1e+06f, _2013);
        float _2034 = (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).x) + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
        float _2038 = _137 - ((_134 - (_2034 * _2034)) * _138);
        if (!(_2038 < 0.0f)) {
          _2046 = ((sqrt(_2038) - _133) / (_131 * 2.0f));
        } else {
          _2046 = -1.0f;
        }
        float _2050 = _137 - ((_134 - ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x))) * _138);
        if (!(_2050 < 0.0f)) {
          _2058 = ((sqrt(_2050) - _133) / (_131 * 2.0f));
        } else {
          _2058 = -1.0f;
        }
        if (((int)(_2046 >= 0.0f)) & ((int)(_2058 <= 0.0f))) {
          float _2064 = (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).z) * 4.999999873689376e-05f;
          float _2065 = _2046 * _98;
          float _2067 = _2046 * _100;
          float _2068 = _2065 + _viewPos.x;
          float _2069 = (_2046 * _99) + _viewPos.y;
          float _2070 = _2067 + _viewPos.z;
          float _2078 = (_2068 * _2064) - ((float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w) * 0.0003000000142492354f);
          float _2079 = (_2070 * _2064) - ((float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z) * 0.0003000000142492354f);
          float4 _2083 = __3__36__0__0__g_texCirrus.SampleBias(__0__95__0__0__g_samplerAnisotropicWrap, float2(_2078, _2079), -1.0f, int2(0, 0));
          _30[0] = _2083.x;
          _30[1] = _2083.y;
          _30[2] = _2083.z;
          _30[3] = _2083.w;
          float _2095 = max(0.009999999776482582f, ((3.0f - (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).y)) * 20000.0f));
          float _2098 = (_2065 * _2065) + (_2067 * _2067);
          float _2099 = sqrt(_2098);
          if (!(_2099 > _2095)) {
            _2107 = (1.0f - cos((1.5707963705062866f / _2095) * _2099));
          } else {
            _2107 = 1.0f;
          }
          float _2108 = _2107 * (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).y);
          _30[0] = ((_2083.x * (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).w)) * _2108);
          _30[1] = ((_2108 * _2083.y) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).x));
          _30[2] = ((_2108 * _2083.z) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).y));
          float _2137 = ((((sin(mad(_2079, -0.6000000238418579f, (_2078 * 0.800000011920929f)) * 3.0299999713897705f) * 0.25f) * sin(mad(_2079, 0.800000011920929f, (_2078 * 0.6000000238418579f)) * 3.0299999713897705f)) + ((sin(_2078 * 1.5f) * 0.5f) * sin(_2079 * 1.5f))) * 1.6000001430511475f) + 1.5f;
          int _2140 = int(min(max(_2137, 0.0f), 2.0f));
          float _2149 = _30[_2140];
          float _2152 = (((_30[((_2140 + 1) % 3)]) - _2149) * saturate(_2137 - float((int)(_2140)))) + _2149;
          float _2153 = _2069 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          float _2156 = sqrt((_2153 * _2153) + _2098);
          float _2157 = _2065 / _2156;
          float _2158 = _2153 / _2156;
          float _2159 = _2067 / _2156;
          float _2160 = _2156 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          if (_2160 > 0.0f) {
            float _2163 = dot(float3(_2157, _2158, _2159), float3(_98, _99, _100));
            float _2172 = min(max(_2160, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
            float _2180 = max(_2172, 0.0f);
            float _2187 = (-0.0f - sqrt((_2180 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _2180)) / (_2180 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            bool _2188 = (_2163 > _2187);
            if (_2188) {
              _2210 = ((exp2(log2(saturate((_2163 - _2187) / (1.0f - _2187))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _2210 = ((exp2(log2(saturate((_2187 - _2163) / (_2187 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _2212 = (exp2(log2(saturate((_2172 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
            float4 _2220 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2212, _2210, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_2157, _2158, _2159), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
            if (_2188) {
              _2250 = ((exp2(log2(saturate((_2163 - _2187) / (1.0f - _2187))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _2250 = ((exp2(log2(saturate((_2187 - _2163) / (_2187 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float4 _2256 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2212, _2250, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_2157, _2158, _2159), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
            _2264 = _2220.x;
            _2265 = _2220.y;
            _2266 = _2220.z;
            _2267 = (_2256.x * 0.25f);
            _2268 = (_2256.y * 0.25f);
            _2269 = (_2256.z * 0.25f);
          } else {
            _2264 = 0.0f;
            _2265 = 0.0f;
            _2266 = 0.0f;
            _2267 = 0.0f;
            _2268 = 0.0f;
            _2269 = 0.0f;
          }
          float _2278 = max(_2160, 0.009999999776482582f);
          float _2279 = -0.0f - _2278;
          float _2287 = exp2((_2279 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f);
          float _2288 = exp2((_2279 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f);
          float _2292 = _2068 - _viewPos.x;
          float _2293 = _2070 - _viewPos.z;
          float _2296 = (_2292 * _2292) + (_2293 * _2293);
          float _2297 = sqrt(_2296);
          float _2303 = max(((_2297 * _2297) + -4e+05f), 0.0f) * 9.999999974752427e-07f;
          float _2304 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - _2303;
          float _2307 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
          float _2310 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
          float _2313 = _2069 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          float _2320 = (((-0.0f - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _2304) + sqrt(_2296 + (_2313 * _2313))) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
          if (!(((int)(_2320 < 0.0f)) | ((int)(_2320 > 1.0f)))) {
            float _2343 = ((((float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z) * 0.0010000000474974513f) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
            float _2344 = _2069 - _2304;
            float _2353 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2310 * (_2068 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2310 * _2344) - _2343), (_2310 * (_2070 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _2358 = _2307 / _2310;
            float _2359 = _2358 * _2310;
            float _2361 = _2358 * _2343;
            float _2367 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2307 * _2068) - (_2359 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2344 * _2307) - _2361), ((_2307 * _2070) - (_2359 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _2377 = (4.0f - (saturate(max((_2297 + -2500.0f), 0.0f) * 0.05000000074505806f) * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
            float _2381 = _2359 * 4.355000019073486f;
            float _2388 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2377 * _2068) - (_2381 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2377 * _2344) - (_2361 * 4.355000019073486f)), ((_2377 * _2070) - (_2381 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _2398 = 1.0f - sqrt(saturate((1.0f - _2320) * 1.4285714626312256f));
            float _2416 = (((1.0f - _2367.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * _2388.x) * ((saturate(_2320 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
            _2423 = (saturate(((saturate(saturate(((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + ((_2353.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_2398 * 0.5f), ((_2398 * _2398) * _2398))) * saturate(_2320 * 10.0f)) - _2416) / (1.0f - _2416)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
          } else {
            _2423 = 0.0f;
          }
          if ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f) {
            _2435 = saturate((((1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z)) * _2297) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
          } else {
            _2435 = 1.0f;
          }
          float _2438 = _2069 - _viewPos.y;
          float _2441 = sqrt(_2296 + (_2438 * _2438));
          float _2447 = max(9.999999974752427e-07f, ((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).z) * 0.0024999999441206455f));
          float _2448 = _2447 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z);
          float _2449 = _2447 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w);
          float _2450 = _2447 * _2068;
          float _2451 = _2447 * _2069;
          float _2452 = _2447 * _2070;
          float _2460 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2450 * 0.5127000212669373f) - _2448), (_2451 * 0.5127000212669373f), ((_2452 * 0.5127000212669373f) - _2449)), 0.0f);
          float _2473 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2450 * 6.393881797790527f) - (_2448 * 1.871000051498413f)), (_2451 * 6.393881797790527f), ((_2452 * 6.393881797790527f) - (_2449 * 1.871000051498413f))), 0.0f);
          float _2491 = ((((saturate(_2441 * 0.0078125f) * 2.0f) * (1.0f - _2460.x)) * exp2(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).y) * -0.14426951110363007f) * max(0.0010000000474974513f, (_2278 - (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).x))))) * (((0.5f - _2473.x) * saturate((_2441 + -300.0f) * 0.0024999999441206455f)) + _2473.x)) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).w);
          float _2492 = _2069 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
          float _2494 = (_2492 + _2303) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
          bool _2497 = ((int)(_sunDirection.y > 0.0f)) | ((int)(_sunDirection.y > _moonDirection.y));
          float _2498 = select(_2497, _sunDirection.x, _moonDirection.x);
          float _2499 = select(_2497, _sunDirection.y, _moonDirection.y);
          float _2500 = select(_2497, _sunDirection.z, _moonDirection.z);
          bool _2501 = (_2499 > 0.0f);
          float _2510 = ((0.5f - (float((int)(((int)(uint)(_2501)) - ((int)(uint)((int)(_2499 < 0.0f))))) * 0.5f)) * (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) + _2304;
          if (_2069 < _2304) {
            float _2513 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2498, _2499, _2500));
            float _2519 = select((abs(_2513) < 9.99999993922529e-09f), 1e+08f, ((_2510 - dot(float3(0.0f, 1.0f, 0.0f), float3(_2068, _2069, _2070))) / _2513));
            _2525 = ((_2519 * _2498) + _2068);
            _2526 = _2510;
            _2527 = ((_2519 * _2500) + _2070);
          } else {
            _2525 = _2068;
            _2526 = _2069;
            _2527 = _2070;
          }
          float _2538 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3((((_2525 - _viewPos.x) * 4.999999873689376e-05f) + 0.5f), ((_2526 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)), (((_2527 - _viewPos.z) * 4.999999873689376e-05f) + 0.5f)), 0.0f);
          float _2542 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _2547 = abs(_2499);
          float _2549 = saturate(_2547 * 4.0f);
          float _2551 = (_2549 * _2549) * exp2((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * -1.4426950216293335f) * _2538.x) * _2542);
          float _2557 = ((1.0f - _2551) * saturate((_2492 - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) * 0.10000000149011612f)) + _2551;
          float _2560 = -0.0f - _2542;
          float _2561 = (log2(_2557) * 0.6931471824645996f) / _2560;
          if (((int)((_2435 * _2423) > 0.0010000000474974513f)) & (((int)(((int)(_2494 >= 0.0f)) & ((int)(_2494 <= 1.0f)))))) {
            float _2573 = (_2069 - _2304) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_2573 < 0.0f)) | ((int)(_2573 > 1.0f)))) {
              if (_2547 > 0.0010000000474974513f) {
                _2586 = min(300.0f, (((_2304 - _2069) + select(_2501, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x), 0.0f)) / _2499));
              } else {
                _2586 = 300.0f;
              }
              float _2587 = _2586 * 0.20000000298023224f;
              float _2588 = _2587 * _2498;
              float _2589 = _2587 * _2499;
              float _2590 = _2587 * _2500;
              _2598 = 0.0f;
              _2599 = _2587;
              _2600 = _2588;
              _2601 = _2589;
              _2602 = _2590;
              _2603 = ((_2588 * 0.5f) + _2068);
              _2604 = ((_2589 * 0.5f) + _2069);
              _2605 = ((_2590 * 0.5f) + _2070);
              _2606 = 0;
              while(true) {
                float _2612 = _2603 - _viewPos.x;
                float _2613 = _2605 - _viewPos.z;
                float _2616 = (_2612 * _2612) + (_2613 * _2613);
                float _2617 = sqrt(_2616);
                float _2624 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_2617 * _2617) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                float _2629 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
                float _2631 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
                float _2636 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _2604;
                float _2642 = ((sqrt(_2616 + (_2636 * _2636)) - _2624) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                if (!(((int)(_2642 < 0.0f)) | ((int)(_2642 > 1.0f)))) {
                  float4 _2675 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((((_2603 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - (((_2605 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                  float _2686 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                  float _2687 = _2604 - _2624;
                  float _2698 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2631 * (_2603 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2631 * _2687) - _2686), (_2631 * (_2605 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _2703 = _2629 / _2631;
                  float _2704 = _2703 * _2631;
                  float _2706 = _2703 * _2686;
                  float _2712 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2629 * _2603) - (_2704 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2629 * _2687) - _2706), ((_2629 * _2605) - (_2704 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _2718 = saturate(max((_2617 + -2500.0f), 0.0f) * 0.05000000074505806f);
                  float _2722 = (4.0f - (_2718 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                  float _2726 = _2704 * 4.355000019073486f;
                  float _2733 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2722 * _2603) - (_2726 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2722 * _2687) - (_2706 * 4.355000019073486f)), ((_2722 * _2605) - (_2726 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _2745 = 1.0f - sqrt(saturate((1.0f - _2642) * 1.4285714626312256f));
                  float _2761 = saturate(saturate((((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + _2675.x) + ((_2698.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_2745 * 0.5f), ((_2745 * _2745) * _2745))) * saturate(_2642 * 10.0f);
                  float _2764 = ((_2733.x * (1.0f - _2712.x)) * ((saturate(_2642 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f)) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x);
                  float _2765 = _2764 * ((_2718 * 0.4000000059604645f) + 0.10000000149011612f);
                  _2777 = (saturate((_2761 - _2764) / (1.0f - _2764)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                  _2778 = (saturate((_2761 - _2765) / (1.0f - _2765)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                } else {
                  _2777 = 0.0f;
                  _2778 = 0.0f;
                }
                float _2792 = (((exp2((((_2598 * -0.007213474716991186f) * _2599) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z))) * (_2777 - _2778)) + _2778) * _2599) + _2598;
                int _2800 = _2606 + 1;
                if (!(_2800 == 6)) {
                  _2598 = _2792;
                  _2599 = (_2599 * 1.2999999523162842f);
                  _2600 = (_2600 * 1.2999999523162842f);
                  _2601 = (_2601 * 1.2999999523162842f);
                  _2602 = (_2602 * 1.2999999523162842f);
                  _2603 = (_2603 + _2600);
                  _2604 = (_2604 + _2601);
                  _2605 = (_2605 + _2602);
                  _2606 = _2800;
                  continue;
                }
                _2805 = (_2792 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
                break;
              }
              if (__loop_jump_target == 233) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
            } else {
              _2805 = 0.0f;
            }
            float _2806 = max(_2561, _2805);
            float _2810 = _2068 - _viewPos.x;
            float _2811 = _2070 - _viewPos.z;
            float _2812 = _2810 * _2810;
            float _2813 = _2811 * _2811;
            float _2815 = sqrt(_2812 + _2813);
            float _2826 = ((_2069 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) + (max(((_2815 * _2815) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_2826 < 0.0f)) | ((int)(_2826 > 1.0f)))) {
              float4 _2852 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_2068 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_2070 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
              float _2854 = _2068 + 50.0f;
              float _2855 = _2069 + 200.0f;
              float _2856 = _2854 - _viewPos.x;
              float _2858 = (_2856 * _2856) + _2813;
              float _2859 = sqrt(_2858);
              float _2864 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_2859 * _2859) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
              float _2867 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
              float _2870 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
              float _2873 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _2855;
              float _2874 = _2873 * _2873;
              float _2879 = ((sqrt(_2858 + _2874) - _2864) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_2879 < 0.0f)) | ((int)(_2879 > 1.0f)))) {
                float _2903 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                float _2904 = _2855 - _2864;
                float _2915 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2870 * (_2854 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2870 * _2904) - _2903), (_2870 * (_2070 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _2920 = _2867 / _2870;
                float _2921 = _2920 * _2870;
                float _2923 = _2920 * _2903;
                float _2929 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2867 * _2854) - (_2921 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2904 * _2867) - _2923), ((_2867 * _2070) - (_2921 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _2935 = saturate(max((_2859 + -2500.0f), 0.0f) * 0.05000000074505806f);
                float _2939 = (4.0f - (_2935 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                float _2943 = _2921 * 4.355000019073486f;
                float _2950 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2939 * _2854) - (_2943 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2939 * _2904) - (_2923 * 4.355000019073486f)), ((_2939 * _2070) - (_2943 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _2960 = 1.0f - sqrt(saturate((1.0f - _2879) * 1.4285714626312256f));
                float _2982 = ((((1.0f - _2929.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_2935 * 0.4000000059604645f) + 0.10000000149011612f)) * _2950.x) * ((saturate(_2879 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                _2989 = (saturate(((saturate(saturate(((_2852.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_2915.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_2960 * 0.5f), ((_2960 * _2960) * _2960))) * saturate(_2879 * 10.0f)) - _2982) / (1.0f - _2982)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
              } else {
                _2989 = 0.0f;
              }
              bool _2991 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
              if (_2991) {
                _3001 = saturate(((_2859 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
              } else {
                _3001 = 1.0f;
              }
              float _3003 = _2070 + -50.0f;
              float _3004 = _3003 - _viewPos.z;
              float _3006 = _2812 + (_3004 * _3004);
              float _3007 = sqrt(_3006);
              float _3012 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_3007 * _3007) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
              float _3017 = ((sqrt(_3006 + _2874) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _3012) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_3017 < 0.0f)) | ((int)(_3017 > 1.0f)))) {
                float _3041 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                float _3042 = _2855 - _3012;
                float _3053 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2870 * (_2068 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3042 * _2870) - _3041), (_2870 * (_3003 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _3058 = _2867 / _2870;
                float _3059 = _3058 * _2870;
                float _3061 = _3058 * _3041;
                float _3067 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2867 * _2068) - (_3059 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3042 * _2867) - _3061), ((_2867 * _3003) - (_3059 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _3073 = saturate(max((_3007 + -2500.0f), 0.0f) * 0.05000000074505806f);
                float _3077 = (4.0f - (_3073 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                float _3081 = _3059 * 4.355000019073486f;
                float _3088 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_3077 * _2068) - (_3081 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3077 * _3042) - (_3061 * 4.355000019073486f)), ((_3077 * _3003) - (_3081 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _3098 = 1.0f - sqrt(saturate((1.0f - _3017) * 1.4285714626312256f));
                float _3120 = ((((1.0f - _3067.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_3073 * 0.4000000059604645f) + 0.10000000149011612f)) * _3088.x) * ((saturate(_3017 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                _3127 = (saturate(((saturate(saturate(((_2852.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_3053.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_3098 * 0.5f), ((_3098 * _3098) * _3098))) * saturate(_3017 * 10.0f)) - _3120) / (1.0f - _3120)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
              } else {
                _3127 = 0.0f;
              }
              if (_2991) {
                _3137 = saturate(((_3007 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
              } else {
                _3137 = 1.0f;
              }
              _3145 = _2806;
              _3146 = ((((_3137 * _3127) + (_3001 * _2989)) * 20.0f) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
            } else {
              _3145 = _2806;
              _3146 = 0.0f;
            }
          } else {
            _3145 = _2561;
            _3146 = ((log2(max(_2557, 0.5f)) * 0.6931471824645996f) / _2560);
          }
          float _3147 = dot(float3(_2157, _2158, _2159), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
          float _3152 = min(max(_2278, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
          float _3160 = max(_3152, 0.0f);
          float _3168 = (-0.0f - sqrt((_3160 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _3160)) / (_3160 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
          if (_3147 > _3168) {
            _3191 = ((exp2(log2(saturate((_3147 - _3168) / (1.0f - _3168))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _3191 = ((exp2(log2(saturate((_3168 - _3147) / (_3168 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _3193 = (exp2(log2(saturate((_3152 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
          float2 _3196 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_3193, _3191), 0.0f);
          float _3199 = dot(float3(_2157, _2158, _2159), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
          if (_3199 > _3168) {
            _3222 = ((exp2(log2(saturate((_3199 - _3168) / (1.0f - _3168))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _3222 = ((exp2(log2(saturate((_3168 - _3199) / (_3168 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float2 _3223 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_3193, _3222), 0.0f);
          float _3234 = ((_2287 + _2015) * 12.5f) + _2011;
          float _3235 = ((_2288 + _2016) * 12.5f) + _2012;
          float _3236 = ((_2152 + _2017) * 12.5f) + _2029;
          float _3237 = ((_2491 + _2018) * 12.5f) + _2014;
          float _3238 = _3237 + _3236;
          float _3239 = _3196.x + _3234;
          // [SKY_SPECTRAL] Vanilla β for extinction/transmittance, spectral β for inscatter only
          float _3246_van = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255)));
          float _3249_van = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255)));
          float _3251_van = float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255)));
          float _3246 = _3246_van;
          float _3249 = _3249_van;
          float _3251 = _3251_van;
          if (SKY_SCATTERING) { float _skyRef2 = _3251_van; _3246 = _skyRef2 * SKY_RAYLEIGH_CH1; _3249 = _skyRef2 * SKY_RAYLEIGH_CH2; }
          float _3258 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f;
          float _3259 = _3258 * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f);
          float _3269 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _3270 = _3269 * (_3145 + _3238);
          // [SKY_SPECTRAL] Extinction uses vanilla β to preserve cloud energy
          float _3271 = (_3246_van * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
          float _3273 = _3270 + (_3259 * (_3196.y + _3235));
          float _3275 = (_3249_van * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
          float _3278 = (_3251_van * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
          float _3284 = exp2(((_3271 * _3239) + _3273) * -1.4426950216293335f);
          float _3285 = exp2(((_3275 * _3239) + _3273) * -1.4426950216293335f);
          float _3286 = exp2(((_3278 * _3239) + _3273) * -1.4426950216293335f);
          float _3299 = ((_3285 * _sky_mtx[0][1]) + (_3284 * _sky_mtx[0][0])) + (_3286 * _sky_mtx[0][2]);
          float _3300 = ((_3285 * _sky_mtx[1][1]) + (_3284 * _sky_mtx[1][0])) + (_3286 * _sky_mtx[1][2]);
          float _3301 = ((_3285 * _sky_mtx[2][1]) + (_3284 * _sky_mtx[2][0])) + (_3286 * _sky_mtx[2][2]);
          float _3302 = _3299 * _2288;
          float _3303 = _3300 * _2288;
          float _3304 = _3301 * _2288;
          float _3305 = _3269 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _3312 = exp2(log2(1.0f - exp2((_3305 * -14.426950454711914f) * _2152)) * 1.25f);
          float _3316 = 1.0f - exp2((_3305 * -288.53900146484375f) * _2491);
          float _3317 = _3316 * _2491;
          float _3321 = _167 * 0.05968310311436653f;
          float _3326 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
          float _3332 = _3326 + 1.0f;
          float _3339 = (((1.0f - _3326) * 3.0f) / ((_3326 + 2.0f) * 2.0f)) * 0.07957746833562851f;
          float _3345 = (_3339 * _3258) * (_167 / exp2(log2(_3332 - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _169)) * 1.5f));
          // [DAWN_DUSK] Sun HG uses boosted g — moon HG (_3509) still uses vanilla _3326/_3332/_3339
          float _3326b = _boostedMieG * _boostedMieG;
          float _3332b = _3326b + 1.0f;
          float _3339b = (((1.0f - _3326b) * 3.0f) / ((_3326b + 2.0f) * 2.0f)) * 0.07957746833562851f;
          float _3345b = (_3339b * _3258) * (_167 / exp2(log2(_3332b - (_boostedMieG * _169)) * 1.5f));
          float _3352 = _2152 * 64.0f;
          float _3354 = _3312 * (_3352 * _177);
          float _3362 = _195 * 2.0f;
          float _3363 = _volumeFogScatterColor.x * (_3317 * _3299);
          float _3365 = _volumeFogScatterColor.y * (_3317 * _3300);
          float _3367 = _volumeFogScatterColor.z * (_3317 * _3301);
          float _3375 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 0.0004999999655410647f;
          float _3379 = _195 * 50.0f;
          float _3400 = (_3269 * (_3146 + _3238)) + (_3259 * _3235);
          float _3409 = exp2(((_3271 * _3234) + _3400) * -1.4426950216293335f);
          float _3410 = exp2(((_3275 * _3234) + _3400) * -1.4426950216293335f);
          float _3411 = exp2(((_3278 * _3234) + _3400) * -1.4426950216293335f);
          float _3424 = ((_3410 * _sky_mtx[0][1]) + (_3409 * _sky_mtx[0][0])) + (_3411 * _sky_mtx[0][2]);
          float _3425 = ((_3410 * _sky_mtx[1][1]) + (_3409 * _sky_mtx[1][0])) + (_3411 * _sky_mtx[1][2]);
          float _3426 = ((_3410 * _sky_mtx[2][1]) + (_3409 * _sky_mtx[2][0])) + (_3411 * _sky_mtx[2][2]);
          float _3431 = _2288 * _3258;
          float _3435 = _3269 * (_2491 + _2152);
          float _3437 = _3424 * ((_mieScatterColor.x * _3431) + _3435);
          float _3443 = _2287 * 4.901960892311763e-06f;
          float _3444 = _3443 * _3246;
          float _3448 = _3425 * ((_mieScatterColor.y * _3431) + _3435);
          float _3454 = _3443 * _3249;
          float _3458 = _3426 * ((_mieScatterColor.z * _3431) + _3435);
          float _3464 = _3443 * _3251;
          float _3467 = _3223.x + _3234;
          float _3471 = _3270 + (_3259 * (_3223.y + _3235));
          float _3480 = exp2(((_3271 * _3467) + _3471) * -1.4426950216293335f);
          float _3481 = exp2(((_3275 * _3467) + _3471) * -1.4426950216293335f);
          float _3482 = exp2(((_3278 * _3467) + _3471) * -1.4426950216293335f);
          float _3495 = ((_3481 * _sky_mtx[0][1]) + (_3480 * _sky_mtx[0][0])) + (_3482 * _sky_mtx[0][2]);
          float _3496 = ((_3481 * _sky_mtx[1][1]) + (_3480 * _sky_mtx[1][0])) + (_3482 * _sky_mtx[1][2]);
          float _3497 = ((_3481 * _sky_mtx[2][1]) + (_3480 * _sky_mtx[2][0])) + (_3482 * _sky_mtx[2][2]);
          float _3498 = _203 * 0.05968310311436653f;
          float _3509 = (_3431 * _3339) * (_203 / exp2(log2(_3332 - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _204)) * 1.5f));
          float _3519 = ((((_219 * 2.0f) * _2491) * _3316) + ((_3352 * _211) * _3312)) * _3269;
          _3557 = (((_3444 * ((_3495 * _3498) + (_3424 * _2267))) + _2005) + (((((_3509 * _mieScatterColor.x) + _3519) * _3495) + (_3437 * _2267)) * 25.0f));
          _3558 = (((_3454 * ((_3496 * _3498) + (_3425 * _2268))) + _2006) + (((((_3509 * _mieScatterColor.y) + _3519) * _3496) + (_3448 * _2268)) * 25.0f));
          _3559 = (((_3464 * ((_3497 * _3498) + (_3426 * _2269))) + _2007) + (((((_3509 * _mieScatterColor.z) + _3519) * _3497) + (_3458 * _2269)) * 25.0f));
          _3560 = (((((_precomputedAmbients[48]).x) * ((_3363 * _3379) + (_3302 * _3375))) + _2008) + (((_3444 * ((_3424 * _2264) + (_3299 * _3321))) + (((((_3345b * _3302) * _mieScatterColor.x) + (((_3363 * _3362) + (_3354 * _3299)) * _3269)) + (_3437 * _2264)) * 25.0f)) * _precomputedAmbient7.y));
          _3561 = (((((_precomputedAmbients[48]).y) * ((_3365 * _3379) + (_3303 * _3375))) + _2009) + (((_3454 * ((_3425 * _2265) + (_3300 * _3321))) + (((((_3345b * _3303) * _mieScatterColor.y) + (((_3365 * _3362) + (_3354 * _3300)) * _3269)) + (_3448 * _2265)) * 25.0f)) * _precomputedAmbient7.y));
          _3562 = (((((_precomputedAmbients[48]).z) * ((_3367 * _3379) + (_3304 * _3375))) + _2010) + (((_3464 * ((_3426 * _2266) + (_3301 * _3321))) + (((((_3345b * _3304) * _mieScatterColor.z) + (((_3367 * _3362) + (_3354 * _3301)) * _3269)) + (_3458 * _2266)) * 25.0f)) * _precomputedAmbient7.y));
          _3563 = _3234;
          _3564 = _3235;
          _3565 = _3236;
          _3566 = _3237;
          _3567 = _263;
        } else {
          _3557 = _2005;
          _3558 = _2006;
          _3559 = _2007;
          _3560 = _2008;
          _3561 = _2009;
          _3562 = _2010;
          _3563 = _2011;
          _3564 = _2012;
          _3565 = _2029;
          _3566 = _2014;
          _3567 = _263;
        }
        break;
      }
    } else {
      _3557 = 0.0f;
      _3558 = 0.0f;
      _3559 = 0.0f;
      _3560 = 0.0f;
      _3561 = 0.0f;
      _3562 = 0.0f;
      _3563 = 0.0f;
      _3564 = 0.0f;
      _3565 = 0.0f;
      _3566 = 0.0f;
      _3567 = 0.0f;
    }
    if (_3567 < _148) {
      float _3573 = (_148 * _98) + _viewPos.x;
      float _3574 = (_148 * _100) + _viewPos.z;
      float _3578 = min(((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * _3567), _148);
      float _3582 = (_3578 * _98) + _viewPos.x;
      float _3583 = (_3578 * _100) + _viewPos.z;
      float _3590 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _viewPos.y;
      float _3591 = _3590 + (_3578 * _99);
      float _3597 = sqrt(((_3583 * _3583) + (_3582 * _3582)) + (_3591 * _3591));
      float _3598 = _3582 / _3597;
      float _3599 = _3591 / _3597;
      float _3600 = _3583 / _3597;
      float _3603 = dot(float3(_3598, _3599, _3600), float3(_98, _99, _100));
      float _3605 = dot(float3(_98, _99, _100), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
      float _3607 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f;
      float _3609 = min(max(max((_3597 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3607);
      float _3611 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f;
      float _3617 = max(_3609, 0.0f);
      float _3618 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f;
      float _3624 = (-0.0f - sqrt((_3617 + _3618) * _3617)) / (_3617 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
      bool _3625 = (_3603 > _3624);
      if (_3625) {
        _3647 = ((exp2(log2(saturate((_3603 - _3624) / (1.0f - _3624))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _3647 = ((exp2(log2(saturate((_3624 - _3603) / (_3624 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _3649 = (exp2(log2(saturate((_3609 + -16.0f) / _3611)) * 0.5f) * 0.96875f) + 0.015625f;
      float _3654 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3598, _3599, _3600), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _3657 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3649, _3647, _3654), 0.0f);
      float4 _3662 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3649, _3647, _3654), 0.0f);
      float _3669 = (_3605 * _3605) + 1.0f;
      float _3670 = _3669 * 0.05968310311436653f;
      float _3674 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
      float _3680 = _3674 + 1.0f;
      float _3681 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * 2.0f;
      float _3688 = (((1.0f - _3674) * 3.0f) / ((_3674 + 2.0f) * 2.0f)) * 0.07957746833562851f;
      float _3689 = (_3669 / exp2(log2(_3680 - (_3681 * _3605)) * 1.5f)) * _3688;
      // [DAWN_DUSK] Sun HG uses boosted g — moon HG (_4029) still uses vanilla _3674/_3680/_3681/_3688
      float _3674b = _boostedMieG * _boostedMieG;
      float _3680b = _3674b + 1.0f;
      float _3681b = _boostedMieG * 2.0f;
      float _3688b = (((1.0f - _3674b) * 3.0f) / ((_3674b + 2.0f) * 2.0f)) * 0.07957746833562851f;
      float _3689b = (_3669 / exp2(log2(_3680b - (_3681b * _3605)) * 1.5f)) * _3688b;
      float4 _3694 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3649, _3647, _3654), 0.0f);
      float4 _3699 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3649, _3647, _3654), 0.0f);
      float _3703 = _3590 + (_148 * _99);
      float _3709 = sqrt(((_3574 * _3574) + (_3573 * _3573)) + (_3703 * _3703));
      float _3710 = _3573 / _3709;
      float _3711 = _3703 / _3709;
      float _3712 = _3574 / _3709;
      float _3715 = dot(float3(_3710, _3711, _3712), float3(_98, _99, _100));
      float _3718 = min(max(max((_3709 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3607);
      float _3725 = max(_3718, 0.0f);
      float _3731 = (-0.0f - sqrt((_3725 + _3618) * _3725)) / (_3725 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
      bool _3732 = (_3715 > _3731);
      if (_3732) {
        _3754 = ((exp2(log2(saturate((_3715 - _3731) / (1.0f - _3731))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _3754 = ((exp2(log2(saturate((_3731 - _3715) / (_3731 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _3756 = (exp2(log2(saturate((_3718 + -16.0f) / _3611)) * 0.5f) * 0.96875f) + 0.015625f;
      float _3761 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3710, _3711, _3712), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _3762 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3756, _3754, _3761), 0.0f);
      float4 _3766 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3756, _3754, _3761), 0.0f);
      float4 _3776 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3756, _3754, _3761), 0.0f);
      float4 _3780 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3756, _3754, _3761), 0.0f);
      float _3793 = dot(float3(_3582, _3591, _3583), float3(_98, _99, _100));
      float _3794 = _3793 / _3597;
      float _3795 = _3578 - _148;
      float _3796 = _3795 * _98;
      float _3797 = _3795 * _99;
      float _3798 = _3795 * _100;
      float _3804 = sqrt(((_3796 * _3796) + (_3797 * _3797)) + (_3798 * _3798));
      float _3811 = sqrt((0.5f / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * _3597);
      float _3812 = sqrt((0.5f / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * _3597);
      float _3814 = (_3804 + _3793) / _3597;
      float _3815 = _3811 * _3794;
      float _3816 = _3814 * _3811;
      float _3817 = _3812 * _3794;
      float _3818 = _3814 * _3812;
      float _3839 = float((int)(((int)(uint)((int)(_3815 > 0.0f))) - ((int)(uint)((int)(_3815 < 0.0f)))));
      float _3840 = float((int)(((int)(uint)((int)(_3816 > 0.0f))) - ((int)(uint)((int)(_3816 < 0.0f)))));
      float _3841 = float((int)(((int)(uint)((int)(_3817 > 0.0f))) - ((int)(uint)((int)(_3817 < 0.0f)))));
      float _3842 = float((int)(((int)(uint)((int)(_3818 > 0.0f))) - ((int)(uint)((int)(_3818 < 0.0f)))));
      float _3843 = _3815 * _3815;
      float _3844 = _3817 * _3817;
      bool _3845 = (_3840 > _3839);
      if (_3845) {
        _3850 = exp2(_3843 * 1.4426950216293335f);
      } else {
        _3850 = 0.0f;
      }
      bool _3851 = (_3842 > _3841);
      if (_3851) {
        _3856 = exp2(_3844 * 1.4426950216293335f);
      } else {
        _3856 = 0.0f;
      }
      float _3887 = -0.0f - _3804;
      float _3893 = ((_3804 / (_3597 * 2.0f)) + _3794) * 1.4426950216293335f;
      float _3900 = _3597 * 6.283100128173828f;
      float _3905 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) - _3597;
      float _3912 = exp2((_3905 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f) * sqrt(_3900 * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z));
      float _3913 = dot(float2((_3839 / (sqrt((_3843 * 1.5199999809265137f) + 4.0f) + (abs(_3815) * 2.3192999362945557f))), (exp2(_3893 * (_3887 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (_3840 / (sqrt(((_3816 * _3816) * 1.5199999809265137f) + 4.0f) + (abs(_3816) * 2.3192999362945557f))))), float2(1.0f, -1.0f));
      float _3914 = dot(float2((_3841 / (sqrt((_3844 * 1.5199999809265137f) + 4.0f) + (abs(_3817) * 2.3192999362945557f))), (exp2(_3893 * (_3887 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x))) * (_3842 / (sqrt(((_3818 * _3818) * 1.5199999809265137f) + 4.0f) + (abs(_3818) * 2.3192999362945557f))))), float2(1.0f, -1.0f));
      float _3917 = (_3913 + _3850) * _3912;
      float _3937 = (((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((sqrt((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x) * _3900) * 1.9999999494757503e-05f) * exp2((_3905 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f));
      float _3938 = _3937 * (_3914 + _3856);
      float _3943 = (float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
      float _3946 = (float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
      float _3949 = (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
      float _3955 = exp2(((_3943 * _3917) + _3938) * -1.4426950216293335f);
      float _3956 = exp2(((_3946 * _3917) + _3938) * -1.4426950216293335f);
      float _3957 = exp2(((_3949 * _3917) + _3938) * -1.4426950216293335f);
      float _3981 = dot(float3(_98, _99, _100), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
      if (_3625) {
        _4003 = ((exp2(log2(saturate((_3603 - _3624) / (1.0f - _3624))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _4003 = ((exp2(log2(saturate((_3624 - _3603) / (_3624 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _4008 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3598, _3599, _3600), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _4009 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3649, _4003, _4008), 0.0f);
      float4 _4013 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3649, _4003, _4008), 0.0f);
      float _4018 = (_3981 * _3981) + 1.0f;
      float _4019 = _4018 * 0.05968310311436653f;
      float _4029 = (_4018 / exp2(log2(_3680 - (_3681 * _3981)) * 1.5f)) * _3688;
      float4 _4033 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3649, _4003, _4008), 0.0f);
      float4 _4037 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3649, _4003, _4008), 0.0f);
      if (_3732) {
        _4063 = ((exp2(log2(saturate((_3715 - _3731) / (1.0f - _3731))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _4063 = ((exp2(log2(saturate((_3731 - _3715) / (_3731 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _4068 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3710, _3711, _3712), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _4069 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3756, _4063, _4068), 0.0f);
      float4 _4073 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3756, _4063, _4068), 0.0f);
      float4 _4083 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3756, _4063, _4068), 0.0f);
      float4 _4087 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3756, _4063, _4068), 0.0f);
      if (_3845) {
        _4104 = exp2(_3843 * 1.4426950216293335f);
      } else {
        _4104 = 0.0f;
      }
      if (_3851) {
        _4109 = exp2(_3844 * 1.4426950216293335f);
      } else {
        _4109 = 0.0f;
      }
      float _4112 = (_4104 + _3913) * _3912;
      float _4113 = _3937 * (_4109 + _3914);
      _4145 = max(0.0f, (((((_4029 * _4013.x) + (_4009.x * _4019)) + _4033.x) + _4037.x) - (exp2((_4113 + (_4112 * _3943)) * -1.4426950216293335f) * ((((_4073.x * _4029) + (_4069.x * _4019)) + _4083.x) + _4087.x))));
      _4146 = max(0.0f, (((((_4029 * _4013.y) + (_4009.y * _4019)) + _4033.y) + _4037.y) - (exp2((_4113 + (_4112 * _3946)) * -1.4426950216293335f) * ((((_4073.y * _4029) + (_4069.y * _4019)) + _4083.y) + _4087.y))));
      _4147 = max(0.0f, (((((_4029 * _4013.z) + (_4009.z * _4019)) + _4033.z) + _4037.z) - (exp2((_4113 + (_4112 * _3949)) * -1.4426950216293335f) * ((((_4073.z * _4029) + (_4069.z * _4019)) + _4083.z) + _4087.z))));
      _4148 = _3955;
      _4149 = _3956;
      _4150 = _3957;
      _4151 = max(0.0f, (((((_3689b * _3662.x) + (_3657.x * _3670)) + _3694.x) + _3699.x) - (_3955 * ((((_3766.x * _3689b) + (_3762.x * _3670)) + _3776.x) + _3780.x))));
      _4152 = max(0.0f, (((((_3689b * _3662.y) + (_3657.y * _3670)) + _3694.y) + _3699.y) - (_3956 * ((((_3766.y * _3689b) + (_3762.y * _3670)) + _3776.y) + _3780.y))));
      _4153 = max(0.0f, (((((_3689b * _3662.z) + (_3657.z * _3670)) + _3694.z) + _3699.z) - (_3957 * ((((_3766.z * _3689b) + (_3762.z * _3670)) + _3776.z) + _3780.z))));
    } else {
      _4145 = 0.0f;
      _4146 = 0.0f;
      _4147 = 0.0f;
      _4148 = 1.0f;
      _4149 = 1.0f;
      _4150 = 1.0f;
      _4151 = 0.0f;
      _4152 = 0.0f;
      _4153 = 0.0f;
    }
    float _4187 = (((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * (_3566 + _3565)) + (((_3564 * 1.9999999494757503e-05f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f));
    float _4198 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1)) * _3563) + _4187) * -1.4426950216293335f);
    float _4199 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2)) * _3563) + _4187) * -1.4426950216293335f);
    float _4200 = exp2((_4187 + ((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3) + (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f)) * _3563)) * -1.4426950216293335f);
    float _4219 = (((_4151 * _precomputedAmbient7.y) * _4198) + _3560) + (((_4198 * _4145) + _3557) * _precomputedAmbient7.w);
    float _4220 = (((_4152 * _precomputedAmbient7.y) * _4199) + _3561) + (((_4199 * _4146) + _3558) * _precomputedAmbient7.w);
    float _4221 = (((_4153 * _precomputedAmbient7.y) * _4200) + _3562) + (((_4200 * _4147) + _3559) * _precomputedAmbient7.w);
    float _4222 = _4198 * _4148;
    float _4223 = _4199 * _4149;
    float _4224 = _4200 * _4150;
    _4256 = (((_4223 * _sky_mtx[0][1]) + (_4222 * _sky_mtx[0][0])) + (_4224 * _sky_mtx[0][2]));
    _4257 = (((_4223 * _sky_mtx[1][1]) + (_4222 * _sky_mtx[1][0])) + (_4224 * _sky_mtx[1][2]));
    _4258 = (((_4223 * _sky_mtx[2][1]) + (_4222 * _sky_mtx[2][0])) + (_4224 * _sky_mtx[2][2]));
    _4259 = (((_4220 * _sky_mtx[0][1]) + (_4219 * _sky_mtx[0][0])) + (_4221 * _sky_mtx[0][2]));
    _4260 = (((_4220 * _sky_mtx[1][1]) + (_4219 * _sky_mtx[1][0])) + (_4221 * _sky_mtx[1][2]));
    _4261 = (((_4220 * _sky_mtx[2][1]) + (_4219 * _sky_mtx[2][0])) + (_4221 * _sky_mtx[2][2]));
  } else {
    _4256 = 1.0f;
    _4257 = 1.0f;
    _4258 = 1.0f;
    _4259 = 0.0f;
    _4260 = 0.0f;
    _4261 = 0.0f;
  }
  bool __defer_4255_4271 = false;
  if ((_sunDirection.y > 0.0f) || !(((int)(_99 < 0.0f)) & (((int)(!(_sunDirection.y > _moonDirection.y)))))) {
    __defer_4255_4271 = true;
  } else {
    _4273 = 0.0f;
    _4274 = 0.0f;
    _4275 = 0.0f;
  }
  if (__defer_4255_4271) {
    _4273 = _4259;
    _4274 = _4260;
    _4275 = _4261;
  }
  // [DAWN_DUSK] Inscatter colour bias
  float _viewSunDot = dot(float3(_98, _99, _100), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
  float3 _inscatterBias = InscatterColorBias(_viewSunDot, _dawnDuskFactor, float3(_4256, _4257, _4258));
  _4273 *= _inscatterBias.x;
  _4274 *= _inscatterBias.y;
  _4275 *= _inscatterBias.z;

  // clamp inscatter energy proportional to extinction to
  // prevent mie forward scattering from causing massive GI
  // brightness swings in dense fog weather
  //
  // I dunno why they did it like, fix is also a cope but I cant think
  // of a better way to solve this atm
  if (SNOW_FOG_FIX == 1.f) {
    float _ext_lum = dot(float3(_4256, _4257, _4258), float3(0.2126f, 0.7152f, 0.0722f));
    float _max_inscatter = (1.0f - _ext_lum) * 100.0f;
    float _insc_lum = dot(float3(_4273, _4274, _4275), float3(0.2126f, 0.7152f, 0.0722f));
    if (_insc_lum > _max_inscatter && _insc_lum > 0.0001f) {
      float _clamp_scale = _max_inscatter / _insc_lum;
      _4273 *= _clamp_scale;
      _4274 *= _clamp_scale;
      _4275 *= _clamp_scale;
    }
  }

  __3__38__0__1__g_texSkyInscatterUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_4273, _4274, _4275, 0.0f);
  __3__38__0__1__g_texSkyExtinctionUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_4256, _4257, _4258, 1.0f);
}
