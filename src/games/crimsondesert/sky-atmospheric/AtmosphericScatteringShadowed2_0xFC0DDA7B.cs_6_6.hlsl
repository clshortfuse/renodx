#include "sky_spectral_common.hlsl"

Texture2D<float4> __3__36__0__0__g_terrainShadowDepth : register(t40, space36);

Texture2DArray<float4> __3__36__0__0__g_shadowDepthArray : register(t82, space36);

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

Texture2D<float> __3__36__0__0__g_depthHalf : register(t26, space36);

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

cbuffer __3__35__0__0__ShadowConstantBuffer : register(b4, space35) {
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

SamplerComparisonState __3__40__0__0__g_samplerShadow : register(s0, space40);

static const int _global_0[4] = { 0, 1, 3, 2 };

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  float _36[4];
  int _42 = _global_0[(((int)(((uint)(int4(_frameNumber).x)) + SV_DispatchThreadID.x)) & 3)];
  uint _47 = ((uint)(_42 % 2)) + (SV_DispatchThreadID.x << 1);
  uint _48 = ((uint)(_42 / 2)) + (SV_DispatchThreadID.y << 1);
  float _49 = float((int)(_47));
  float _50 = float((int)(_48));
  float _61 = __3__36__0__0__g_depthHalf.Load(int3(_47, _48, 0));
  float _66 = (((_49 + 0.5f) / (_bufferSizeAndInvSize.x * 0.5f)) * 2.0f) + -1.0f;
  float _67 = ((1.0f - ((_50 + 0.5f) / (_bufferSizeAndInvSize.y * 0.5f))) * 2.0f) + -1.0f;
  float _68 = max(1.0000000116860974e-07f, _61.x);
  float _104 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _68, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _67, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _66))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
  float _105 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _68, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _67, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _66))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _104;
  float _106 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _68, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _67, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _66))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _104;
  float _107 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _68, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _67, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _66))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _104;
  float _113 = sqrt(((_106 * _106) + (_105 * _105)) + (_107 * _107));
  float _114 = _105 / _113;
  float _115 = _106 / _113;
  float _116 = _107 / _113;
  float _121 = float((uint)((uint)(((uint)((uint)(int4(_frameNumber).x)) >> 2) & 1023)));
  float _129 = frac(frac(dot(float2(((_121 * 32.665000915527344f) + _49), ((_121 * 11.8149995803833f) + _50)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
  bool _130 = (_61.x < 1.0000000116860974e-07f);
  float _143 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
  float _144 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _viewPos.y;
  float _145 = dot(float3(_114, _115, _116), float3(_114, _115, _116));
  float _147 = dot(float3(0.0f, _144, 0.0f), float3(_114, _115, _116)) * 2.0f;
  float _148 = dot(float3(0.0f, _144, 0.0f), float3(0.0f, _144, 0.0f));
  float _151 = _147 * _147;
  float _152 = _145 * 4.0f;
  float _154 = _151 - ((_148 - (_143 * _143)) * _152);
  float _162;
  int _225;
  float _226;
  float _227;
  float _228;
  float _229;
  float _230;
  float _231;
  float _232;
  float _233;
  float _234;
  float _235;
  float _236;
  int _237;
  int _238;
  float _239;
  float _439;
  float _451;
  float _546;
  float _560;
  float _561;
  float _562;
  float _625;
  float _626;
  float _627;
  float _628;
  int _629;
  float _683;
  float _684;
  float _685;
  float _686;
  int _687;
  int _688;
  float _700;
  float _747;
  float _753;
  float _891;
  float _901;
  float _983;
  float _984;
  float _985;
  float _1010;
  float _1011;
  float _1012;
  float _1070;
  float _1082;
  float _1083;
  float _1084;
  float _1085;
  float _1086;
  float _1087;
  float _1088;
  float _1089;
  int _1090;
  float _1261;
  float _1262;
  float _1289;
  float _1473;
  float _1485;
  float _1611;
  float _1621;
  float _1629;
  float _1630;
  float _1675;
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
  int _2016;
  int _2017;
  float _2044;
  float _2056;
  float _2105;
  float _2208;
  float _2223;
  float _2224;
  float _2225;
  float _2375;
  float _2387;
  float _2456;
  float _2457;
  float _2458;
  float _2483;
  float _2484;
  float _2485;
  float _2544;
  float _2556;
  float _2557;
  float _2558;
  float _2559;
  float _2560;
  float _2561;
  float _2562;
  float _2563;
  int _2564;
  float _2735;
  float _2736;
  float _2763;
  float _2947;
  float _2959;
  float _3085;
  float _3095;
  float _3103;
  float _3104;
  float _3149;
  float _3402;
  float _3403;
  float _3404;
  float _3405;
  float _3406;
  float _3407;
  float _3408;
  float _3409;
  float _3410;
  float _3411;
  float _3412;
  float _3414;
  float _3415;
  float _3416;
  float _3417;
  float _3418;
  float _3419;
  float _3420;
  float _3421;
  float _3422;
  float _3423;
  float _3424;
  float _3495;
  float _3602;
  float _3697;
  float _3703;
  float _3825;
  float _3826;
  float _3827;
  float _3828;
  float _3829;
  float _3830;
  float _3831;
  float _3832;
  float _3833;
  float _3834;
  float _3835;
  float _3836;
  float _3837;
  float _3838;
  float _3918;
  float _4025;
  float _4121;
  float _4127;
  float _4248;
  float _4249;
  float _4250;
  float _4251;
  float _4252;
  float _4253;
  float _4344;
  float _4345;
  float _4346;
  float _4347;
  float _4348;
  float _4349;
  if (!(_154 < 0.0f)) {
    _162 = ((sqrt(_154) - _147) / (_145 * 2.0f));
  } else {
    _162 = -1.0f;
  }
  if (!(_162 <= 0.0f)) {
    float _171 = dot(float3(_114, _115, _116), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
    float _174 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y);
    float _181 = (_171 * _171) + 1.0f;
    float _183 = _171 * 2.0f;
    float _191 = ((((1.0f - _174) * 3.0f) / ((_174 + 2.0f) * 2.0f)) * 0.07957746833562851f) * (_181 / exp2(log2((_174 + 1.0f) - ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * _183)) * 1.5f));
    float _193 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z) * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z);
    float _209 = (((((1.0f - _193) * 3.0f) / ((_193 + 2.0f) * 2.0f)) * 0.039788734167814255f) * (_181 / exp2(log2((_193 + 1.0f) - ((_171 * -2.0f) * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z))) * 1.5f))) + _191;
    float _212 = min((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y), (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y));
    float _213 = select(_130, _162, _113);
    bool __defer_164_3401 = false;
    if (_renderFlags.x > 0.5f) {
      float _220 = log2(exp2(log2(max(1.0f, ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y) * 0.00033333332976326346f))) * 0.0033333334140479565f));
      _225 = 1;
      _226 = 0.0f;
      _227 = 0.0f;
      _228 = 0.0f;
      _229 = 0.0f;
      _230 = 0.0f;
      _231 = 0.0f;
      _232 = 0.0f;
      _233 = 0.0f;
      _234 = 0.0f;
      _235 = 0.0f;
      _236 = 0.0f;
      _237 = 0;
      _238 = 0;
      _239 = 128.0f;
      while(true) {
        float _241 = float((int)(_237));
        float _251 = (((exp2(select(((uint)_237 < (uint)12), (_241 * 0.33000001311302185f), (_241 + -8.039999008178711f)) * _220) + -1.0f) * (_212 + -128.0f)) / (exp2(_220 * 300.0f) + -1.0f)) + 128.0f;
        float _252 = min(_251, _213);
        float _254 = max(0.0f, (_252 - _239));
        float _256 = (_254 * _129) + _239;
        float _259 = (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * _254;
        float _260 = _256 * _114;
        float _262 = _256 * _116;
        float _263 = _260 + _viewPos.x;
        float _264 = (_256 * _115) + _viewPos.y;
        float _265 = _262 + _viewPos.z;
        float4 _287 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_263 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_265 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
        float _294 = (_252 * _114) + _viewPos.x;
        float _295 = (_252 * _115) + _viewPos.y;
        float _296 = (_252 * _116) + _viewPos.z;
        float _300 = _294 - _viewPos.x;
        float _301 = _296 - _viewPos.z;
        float _304 = (_300 * _300) + (_301 * _301);
        float _305 = sqrt(_304);
        float _312 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_305 * _305) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
        float _315 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
        float _318 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
        float _323 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _295;
        float _329 = ((sqrt(_304 + (_323 * _323)) - _312) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
        if (!(((int)(_329 < 0.0f)) | ((int)(_329 > 1.0f)))) {
          float _353 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
          float _354 = _295 - _312;
          float _365 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_318 * (_294 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_318 * _354) - _353), (_318 * (_296 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _370 = _315 / _318;
          float _371 = _370 * _318;
          float _373 = _370 * _353;
          float _379 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_315 * _294) - (_371 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_354 * _315) - _373), ((_315 * _296) - (_371 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _385 = saturate(max((_305 + -2500.0f), 0.0f) * 0.05000000074505806f);
          float _389 = (4.0f - (_385 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
          float _393 = _371 * 4.355000019073486f;
          float _400 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_389 * _294) - (_393 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_389 * _354) - (_373 * 4.355000019073486f)), ((_389 * _296) - (_393 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _410 = 1.0f - sqrt(saturate((1.0f - _329) * 1.4285714626312256f));
          float _432 = ((((1.0f - _379.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_385 * 0.4000000059604645f) + 0.10000000149011612f)) * _400.x) * ((saturate(_329 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
          _439 = (saturate(((saturate(saturate(((_287.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_365.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_410 * 0.5f), ((_410 * _410) * _410))) * saturate(_329 * 10.0f)) - _432) / (1.0f - _432)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
        } else {
          _439 = 0.0f;
        }
        bool _441 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
        if (_441) {
          _451 = saturate((((1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z)) * _305) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
        } else {
          _451 = 1.0f;
        }
        bool _453 = ((_451 * _439) > 0.0010000000474974513f);
        if (((int)(_238 != 0)) & (_453)) {
          _2002 = _239;
          _2003 = 0;
          _2004 = ((int)(_237 + -2u));
          _2005 = _236;
          _2006 = _235;
          _2007 = _234;
          _2008 = _233;
          _2009 = _232;
          _2010 = _231;
          _2011 = _230;
          _2012 = _229;
          _2013 = _228;
          _2014 = _227;
          _2015 = _226;
          _2016 = _225;
          _2017 = 0;
        } else {
          bool _459 = ((uint)_237 < (uint)298);
          int _461 = ((int)(uint)(_453)) ^ 1;
          uint _464 = _237 + (uint)(select(_459, _461, 0));
          float _466 = (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x) + (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
          float _479 = saturate((_256 + -4000.0f) * 0.0010000000474974513f);
          float _486 = _264 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          float _492 = sqrt(((_262 * _262) + (_260 * _260)) + (_486 * _486));
          float _493 = _260 / _492;
          float _494 = _486 / _492;
          float _495 = _262 / _492;
          float _496 = _492 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          if (_496 > 0.0f) {
            float _499 = dot(float3(_493, _494, _495), float3(_114, _115, _116));
            float _508 = min(max(_496, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
            float _516 = max(_508, 0.0f);
            float _523 = (-0.0f - sqrt((_516 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _516)) / (_516 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            if (_499 > _523) {
              _546 = ((exp2(log2(saturate((_499 - _523) / (1.0f - _523))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _546 = ((exp2(log2(saturate((_523 - _499) / (_523 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float4 _555 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(((exp2(log2(saturate((_508 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _546, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_493, _494, _495), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
            _560 = _555.x;
            _561 = _555.y;
            _562 = _555.z;
          } else {
            _560 = 0.0f;
            _561 = 0.0f;
            _562 = 0.0f;
          }
          float _564 = _263 - _viewPos.x;
          float _565 = _265 - _viewPos.z;
          if (_479 < 0.9998999834060669f) {
            float _568 = _264 - _viewPos.y;
            float _575 = _263 - ((_staticShadowPosition[1]).x);
            float _576 = _264 - ((_staticShadowPosition[1]).y);
            float _577 = _265 - ((_staticShadowPosition[1]).z);
            float _597 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).x), _577, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).x), _576, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).x) * _575))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).x);
            float _601 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).y), _577, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).y), _576, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).y) * _575))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).y);
            float _605 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).z), _577, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).z), _576, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).z) * _575))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).z);
            float _606 = 2.0f / _shadowSizeAndInvSize.y;
            float _607 = 1.0f - _606;
            if (!((((int)((((int)(!(_597 <= _607)))) | (((int)(!(_597 >= _606))))))) | (((int)(!(_601 <= _607)))))) {
              bool _618 = ((int)(_605 >= 9.999999747378752e-05f)) & (((int)(((int)(_605 <= 1.0f)) & ((int)(_601 >= _606)))));
              _625 = select(_618, _597, 0.0f);
              _626 = select(_618, _601, 0.0f);
              _627 = select(_618, _605, 0.0f);
              _628 = select(_618, 0.00019999999494757503f, 0.0f);
              _629 = ((int)(uint)(_618));
            } else {
              _625 = 0.0f;
              _626 = 0.0f;
              _627 = 0.0f;
              _628 = 0.0f;
              _629 = 0;
            }
            float _634 = _263 - ((_staticShadowPosition[0]).x);
            float _635 = _264 - ((_staticShadowPosition[0]).y);
            float _636 = _265 - ((_staticShadowPosition[0]).z);
            float _656 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).x), _636, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).x), _635, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).x) * _634))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).x);
            float _660 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).y), _636, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).y), _635, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).y) * _634))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).y);
            float _664 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).z), _636, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).z), _635, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).z) * _634))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).z);
            if (!((((int)((((int)(!(_656 >= _606)))) | (((int)(!(_656 <= _607))))))) | (((int)(!(_660 <= _607)))))) {
              bool _675 = ((int)(_664 >= 9.999999747378752e-05f)) & (((int)(((int)(_660 >= _606)) & ((int)(_664 <= 1.0f)))));
              _683 = select(_675, _656, _625);
              _684 = select(_675, _660, _626);
              _685 = select(_675, _664, _627);
              _686 = select(_675, 0.00019999999494757503f, _628);
              _687 = select(_675, 1, _629);
              _688 = select(_675, 0, _629);
            } else {
              _683 = _625;
              _684 = _626;
              _685 = _627;
              _686 = _628;
              _687 = _629;
              _688 = _629;
            }
            [branch]
            if (!(_687 == 0)) {
              float4 _695 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_683, _684, float((uint)_688)), (_685 - _686));
              _700 = saturate(1.0f - _695.x);
            } else {
              _700 = 1.0f;
            }
            float _720 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).x), _565, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).x), _568, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).x) * _564))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).x);
            float _724 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).y), _565, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).y), _568, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).y) * _564))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).y);
            float _728 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).z), _565, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).z), _568, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).z) * _564))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).z);
            if (saturate(_720) == _720) {
              if (((int)(_728 >= 9.999999747378752e-05f)) & (((int)(((int)(_728 <= 1.0f)) & ((int)(saturate(_724) == _724)))))) {
                float4 _742 = __3__36__0__0__g_terrainShadowDepth.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float2(_720, _724), (_728 + -0.004999999888241291f));
                _747 = saturate(1.0f - _742.x);
              } else {
                _747 = 1.0f;
              }
            } else {
              _747 = 1.0f;
            }
            float _748 = min(_700, _747);
            _753 = (lerp(_748, 1.0f, _479));
          } else {
            _753 = 1.0f;
          }
          float _758 = max(_496, 0.009999999776482582f);
          float _759 = -0.0f - _758;
          float _767 = exp2((_759 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f);
          float _768 = exp2((_759 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f);
          float _771 = (_564 * _564) + (_565 * _565);
          float _772 = sqrt(_771);
          float _776 = max(((_772 * _772) + -4e+05f), 0.0f) * 9.999999974752427e-07f;
          float _777 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - _776;
          float _778 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _264;
          float _784 = ((sqrt(_771 + (_778 * _778)) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _777) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
          if (!(((int)(_784 < 0.0f)) | ((int)(_784 > 1.0f)))) {
            float _808 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
            float _809 = _264 - _777;
            float _820 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_318 * (_263 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_809 * _318) - _808), (_318 * (_265 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _825 = _315 / _318;
            float _826 = _825 * _318;
            float _828 = _825 * _808;
            float _834 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_315 * _263) - (_826 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_809 * _315) - _828), ((_315 * _265) - (_826 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _844 = (4.0f - (saturate(max((_772 + -2500.0f), 0.0f) * 0.05000000074505806f) * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
            float _848 = _826 * 4.355000019073486f;
            float _855 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_844 * _263) - (_848 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_844 * _809) - (_828 * 4.355000019073486f)), ((_844 * _265) - (_848 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _865 = 1.0f - sqrt(saturate((1.0f - _784) * 1.4285714626312256f));
            float _884 = (((1.0f - _834.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * _855.x) * ((saturate(_784 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
            _891 = (saturate(((saturate(saturate(((_287.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_820.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_865 * 0.5f), ((_865 * _865) * _865))) * saturate(_784 * 10.0f)) - _884) / (1.0f - _884)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
          } else {
            _891 = 0.0f;
          }
          if (_441) {
            _901 = saturate(((_772 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
          } else {
            _901 = 1.0f;
          }
          float _902 = _901 * _891;
          float _904 = _264 - _viewPos.y;
          float _907 = sqrt(_771 + (_904 * _904));
          float _913 = max(9.999999974752427e-07f, ((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).z) * 0.0024999999441206455f));
          float _916 = _913 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z);
          float _917 = _913 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w);
          float _918 = _913 * _263;
          float _919 = _913 * _264;
          float _920 = _913 * _265;
          float _933 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_918 * 0.5127000212669373f) - _916), (_919 * 0.5127000212669373f), ((_920 * 0.5127000212669373f) - _917)), 0.0f);
          float _946 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_918 * 6.393881797790527f) - (_916 * 1.871000051498413f)), (_919 * 6.393881797790527f), ((_920 * 6.393881797790527f) - (_917 * 1.871000051498413f))), 0.0f);
          float _955 = (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).y) * -0.14426951110363007f;
          float _970 = (((saturate(_907 * 0.0078125f) * 2.0f) * (1.0f - _933.x)) * (((0.5f - _946.x) * saturate((_907 + -300.0f) * 0.0024999999441206455f)) + _946.x)) * ((exp2(_955 * max(0.0010000000474974513f, (_758 - (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).x)))) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).w)) + (exp2(_955 * max(0.0010000000474974513f, ((_758 - (float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).z)) - (((float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).w) - (float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).z)) * _287.z)))) * _287.y));
          float _971 = _264 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
          float _973 = (_776 + _971) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
          if (!(_sunDirection.y > 0.0f)) {
            if (!(_sunDirection.y > _moonDirection.y)) {
              _983 = _moonDirection.x;
              _984 = _moonDirection.y;
              _985 = _moonDirection.z;
            } else {
              _983 = _sunDirection.x;
              _984 = _sunDirection.y;
              _985 = _sunDirection.z;
            }
          } else {
            _983 = _sunDirection.x;
            _984 = _sunDirection.y;
            _985 = _sunDirection.z;
          }
          bool _986 = (_984 > 0.0f);
          float _995 = ((0.5f - (float((int)(((int)(uint)(_986)) - ((int)(uint)((int)(_984 < 0.0f))))) * 0.5f)) * (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) + _777;
          if (_264 < _777) {
            float _998 = dot(float3(0.0f, 1.0f, 0.0f), float3(_983, _984, _985));
            float _1004 = select((abs(_998) < 9.99999993922529e-09f), 1e+08f, ((_995 - dot(float3(0.0f, 1.0f, 0.0f), float3(_263, _264, _265))) / _998));
            _1010 = ((_1004 * _983) + _263);
            _1011 = _995;
            _1012 = ((_1004 * _985) + _265);
          } else {
            _1010 = _263;
            _1011 = _264;
            _1012 = _265;
          }
          float _1023 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3((((_1010 - _viewPos.x) * 4.999999873689376e-05f) + 0.5f), ((_1011 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)), (((_1012 - _viewPos.z) * 4.999999873689376e-05f) + 0.5f)), 0.0f);
          float _1026 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _1031 = abs(_984);
          float _1033 = saturate(_1031 * 4.0f);
          float _1035 = (_1033 * _1033) * exp2((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * -1.4426950216293335f) * _1023.x) * _1026);
          float _1041 = ((1.0f - _1035) * saturate((_971 - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) * 0.10000000149011612f)) + _1035;
          float _1044 = -0.0f - _1026;
          float _1045 = (log2(_1041) * 0.6931471824645996f) / _1044;
          if (((int)(_902 > 0.0010000000474974513f)) & (((int)(((int)(_973 >= 0.0f)) & ((int)(_973 <= 1.0f)))))) {
            float _1057 = (_264 - _777) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_1057 < 0.0f)) | ((int)(_1057 > 1.0f)))) {
              if (_1031 > 0.0010000000474974513f) {
                _1070 = min(300.0f, (((_777 - _264) + select(_986, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x), 0.0f)) / _984));
              } else {
                _1070 = 300.0f;
              }
              float _1071 = _1070 * 0.20000000298023224f;
              float _1072 = _1071 * _983;
              float _1073 = _1071 * _984;
              float _1074 = _1071 * _985;
              _1082 = 0.0f;
              _1083 = _1071;
              _1084 = _1072;
              _1085 = _1073;
              _1086 = _1074;
              _1087 = ((_1072 * 0.5f) + _263);
              _1088 = ((_1073 * 0.5f) + _264);
              _1089 = ((_1074 * 0.5f) + _265);
              _1090 = 0;
              while(true) {
                float _1096 = _1087 - _viewPos.x;
                float _1097 = _1089 - _viewPos.z;
                float _1100 = (_1096 * _1096) + (_1097 * _1097);
                float _1101 = sqrt(_1100);
                float _1108 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_1101 * _1101) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                float _1113 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
                float _1115 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
                float _1120 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _1088;
                float _1126 = ((sqrt(_1100 + (_1120 * _1120)) - _1108) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                if (!(((int)(_1126 < 0.0f)) | ((int)(_1126 > 1.0f)))) {
                  float4 _1159 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((((_1087 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - (((_1089 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                  float _1170 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                  float _1171 = _1088 - _1108;
                  float _1182 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_1115 * (_1087 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1115 * _1171) - _1170), (_1115 * (_1089 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1187 = _1113 / _1115;
                  float _1188 = _1187 * _1115;
                  float _1190 = _1187 * _1170;
                  float _1196 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1113 * _1087) - (_1188 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1113 * _1171) - _1190), ((_1113 * _1089) - (_1188 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1202 = saturate(max((_1101 + -2500.0f), 0.0f) * 0.05000000074505806f);
                  float _1206 = (4.0f - (_1202 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                  float _1210 = _1188 * 4.355000019073486f;
                  float _1217 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1206 * _1087) - (_1210 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1206 * _1171) - (_1190 * 4.355000019073486f)), ((_1206 * _1089) - (_1210 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1229 = 1.0f - sqrt(saturate((1.0f - _1126) * 1.4285714626312256f));
                  float _1245 = saturate(saturate((((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + _1159.x) + ((_1182.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1229 * 0.5f), ((_1229 * _1229) * _1229))) * saturate(_1126 * 10.0f);
                  float _1248 = ((_1217.x * (1.0f - _1196.x)) * ((saturate(_1126 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f)) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x);
                  float _1249 = _1248 * ((_1202 * 0.4000000059604645f) + 0.10000000149011612f);
                  _1261 = (saturate((_1245 - _1248) / (1.0f - _1248)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                  _1262 = (saturate((_1245 - _1249) / (1.0f - _1249)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                } else {
                  _1261 = 0.0f;
                  _1262 = 0.0f;
                }
                float _1276 = (((exp2((((_1082 * -0.007213474716991186f) * _1083) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z))) * (_1261 - _1262)) + _1262) * _1083) + _1082;
                int _1284 = _1090 + 1;
                if (!(_1284 == 6)) {
                  _1082 = _1276;
                  _1083 = (_1083 * 1.2999999523162842f);
                  _1084 = (_1084 * 1.2999999523162842f);
                  _1085 = (_1085 * 1.2999999523162842f);
                  _1086 = (_1086 * 1.2999999523162842f);
                  _1087 = (_1087 + _1084);
                  _1088 = (_1088 + _1085);
                  _1089 = (_1089 + _1086);
                  _1090 = _1284;
                  continue;
                }
                _1289 = (_1276 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
                break;
              }
              if (__loop_jump_target == 224) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
            } else {
              _1289 = 0.0f;
            }
            float _1290 = max(_1045, _1289);
            float _1294 = _263 - _viewPos.x;
            float _1295 = _265 - _viewPos.z;
            float _1296 = _1294 * _1294;
            float _1297 = _1295 * _1295;
            float _1299 = sqrt(_1296 + _1297);
            float _1310 = ((_264 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) + (max(((_1299 * _1299) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_1310 < 0.0f)) | ((int)(_1310 > 1.0f)))) {
              float4 _1336 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_263 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_265 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
              float _1338 = _263 + 50.0f;
              float _1339 = _264 + 200.0f;
              float _1340 = _1338 - _viewPos.x;
              float _1342 = (_1340 * _1340) + _1297;
              float _1343 = sqrt(_1342);
              float _1348 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_1343 * _1343) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
              float _1351 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
              float _1354 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
              float _1357 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _1339;
              float _1358 = _1357 * _1357;
              float _1363 = ((sqrt(_1342 + _1358) - _1348) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_1363 < 0.0f)) | ((int)(_1363 > 1.0f)))) {
                float _1387 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                float _1388 = _1339 - _1348;
                float _1399 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_1354 * (_1338 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1354 * _1388) - _1387), (_1354 * (_265 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1404 = _1351 / _1354;
                float _1405 = _1404 * _1354;
                float _1407 = _1404 * _1387;
                float _1413 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1351 * _1338) - (_1405 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1388 * _1351) - _1407), ((_1351 * _265) - (_1405 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1419 = saturate(max((_1343 + -2500.0f), 0.0f) * 0.05000000074505806f);
                float _1423 = (4.0f - (_1419 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                float _1427 = _1405 * 4.355000019073486f;
                float _1434 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1423 * _1338) - (_1427 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1423 * _1388) - (_1407 * 4.355000019073486f)), ((_1423 * _265) - (_1427 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1444 = 1.0f - sqrt(saturate((1.0f - _1363) * 1.4285714626312256f));
                float _1466 = ((((1.0f - _1413.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_1419 * 0.4000000059604645f) + 0.10000000149011612f)) * _1434.x) * ((saturate(_1363 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                _1473 = (saturate(((saturate(saturate(((_1336.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_1399.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1444 * 0.5f), ((_1444 * _1444) * _1444))) * saturate(_1363 * 10.0f)) - _1466) / (1.0f - _1466)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
              } else {
                _1473 = 0.0f;
              }
              bool _1475 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
              if (_1475) {
                _1485 = saturate(((_1343 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
              } else {
                _1485 = 1.0f;
              }
              float _1487 = _265 + -50.0f;
              float _1488 = _1487 - _viewPos.z;
              float _1490 = _1296 + (_1488 * _1488);
              float _1491 = sqrt(_1490);
              float _1496 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_1491 * _1491) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
              float _1501 = ((sqrt(_1490 + _1358) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _1496) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_1501 < 0.0f)) | ((int)(_1501 > 1.0f)))) {
                float _1525 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                float _1526 = _1339 - _1496;
                float _1537 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_1354 * (_263 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1526 * _1354) - _1525), (_1354 * (_1487 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1542 = _1351 / _1354;
                float _1543 = _1542 * _1354;
                float _1545 = _1542 * _1525;
                float _1551 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1351 * _263) - (_1543 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1526 * _1351) - _1545), ((_1351 * _1487) - (_1543 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1557 = saturate(max((_1491 + -2500.0f), 0.0f) * 0.05000000074505806f);
                float _1561 = (4.0f - (_1557 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                float _1565 = _1543 * 4.355000019073486f;
                float _1572 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1561 * _263) - (_1565 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1561 * _1526) - (_1545 * 4.355000019073486f)), ((_1561 * _1487) - (_1565 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1582 = 1.0f - sqrt(saturate((1.0f - _1501) * 1.4285714626312256f));
                float _1604 = ((((1.0f - _1551.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_1557 * 0.4000000059604645f) + 0.10000000149011612f)) * _1572.x) * ((saturate(_1501 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                _1611 = (saturate(((saturate(saturate(((_1336.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_1537.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1582 * 0.5f), ((_1582 * _1582) * _1582))) * saturate(_1501 * 10.0f)) - _1604) / (1.0f - _1604)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
              } else {
                _1611 = 0.0f;
              }
              if (_1475) {
                _1621 = saturate(((_1491 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
              } else {
                _1621 = 1.0f;
              }
              _1629 = _1290;
              _1630 = ((((_1621 * _1611) + (_1485 * _1473)) * 20.0f) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
            } else {
              _1629 = _1290;
              _1630 = 0.0f;
            }
          } else {
            _1629 = _1045;
            _1630 = ((log2(max(_1041, 0.5f)) * 0.6931471824645996f) / _1044);
          }
          float _1631 = dot(float3(_493, _494, _495), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
          float _1636 = min(max(_758, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
          float _1644 = max(_1636, 0.0f);
          float _1652 = (-0.0f - sqrt((_1644 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _1644)) / (_1644 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
          if (_1631 > _1652) {
            _1675 = ((exp2(log2(saturate((_1631 - _1652) / (1.0f - _1652))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _1675 = ((exp2(log2(saturate((_1652 - _1631) / (_1652 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float2 _1680 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_1636 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _1675), 0.0f);
          float _1683 = _902 * saturate((1.0f - saturate(_256 / _212)) * 10.0f);
          float _1688 = _259 * 0.5f;
          float _1693 = ((_767 + _229) * _1688) + _233;
          float _1694 = ((_768 + _228) * _1688) + _232;
          float _1695 = ((_1683 + _227) * _1688) + _231;
          float _1696 = ((_970 + _226) * _1688) + _230;
          float _1697 = _1696 + _1695;
          float _1698 = _1680.x + _1693;
          float _1705 = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255)));
          float _1708 = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255)));
          float _1710 = float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255)));
          if (SKY_SCATTERING) { float _skyRef1 = _1710; _1705 = _skyRef1 * SKY_RAYLEIGH_CH1; _1708 = _skyRef1 * SKY_RAYLEIGH_CH2; }
          float _1717 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f;
          float _1718 = _1717 * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f);
          float _1719 = _1718 * (_1680.y + _1694);
          float _1728 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _1730 = (_1705 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
          float _1731 = _1730 * _1698;
          float _1732 = (_1728 * (_1629 + _1697)) + _1719;
          float _1734 = (_1708 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
          float _1735 = _1734 * _1698;
          float _1737 = (_1710 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
          float _1738 = _1737 * _1698;
          float _1743 = exp2((_1731 + _1732) * -1.4426950216293335f);
          float _1744 = exp2((_1735 + _1732) * -1.4426950216293335f);
          float _1745 = exp2((_1738 + _1732) * -1.4426950216293335f);
          float _1758 = ((_1744 * _sky_mtx[0][1]) + (_1743 * _sky_mtx[0][0])) + (_1745 * _sky_mtx[0][2]);
          float _1759 = ((_1744 * _sky_mtx[1][1]) + (_1743 * _sky_mtx[1][0])) + (_1745 * _sky_mtx[1][2]);
          float _1760 = ((_1744 * _sky_mtx[2][1]) + (_1743 * _sky_mtx[2][0])) + (_1745 * _sky_mtx[2][2]);
          float _1761 = _1758 * _753;
          float _1762 = _1761 * _768;
          float _1763 = _1759 * _753;
          float _1764 = _1763 * _768;
          float _1765 = _1760 * _753;
          float _1766 = _1765 * _768;
          float _1767 = _1728 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _1774 = exp2(log2(1.0f - exp2((_1767 * -14.426950454711914f) * _1683)) * 1.25f);
          float _1778 = 1.0f - exp2((_1767 * -288.53900146484375f) * _970);
          float _1780 = _767 * 1.960784317134312e-07f;
          float _1782 = ((_181 * 0.05968310311436653f) * _753) * _1780;
          float _1790 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
          float _1809 = (((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.591549334989395e-06f) * (((1.0f - _1790) * 3.0f) / ((_1790 + 2.0f) * 2.0f))) * (_181 / exp2(log2((_1790 + 1.0f) - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _183)) * 1.5f));
          float _1819 = _1774 * (((_191 * 64.0f) * _753) * _1683);
          float _1828 = (_209 * 2.0f) * _970;
          float _1831 = ((_1828 * _1761) * _1778) * _volumeFogScatterColor.x;
          float _1834 = ((_1828 * _1763) * _1778) * _volumeFogScatterColor.y;
          float _1837 = ((_1828 * _1765) * _1778) * _volumeFogScatterColor.z;
          float _1867 = (_1728 * (_1630 + _1697)) + (_1718 * _1694);
          float _1876 = exp2(((_1730 * _1693) + _1867) * -1.4426950216293335f);
          float _1877 = exp2(((_1734 * _1693) + _1867) * -1.4426950216293335f);
          float _1878 = exp2(((_1737 * _1693) + _1867) * -1.4426950216293335f);
          float _1898 = _768 * _1717;
          float _1902 = _1728 * (_970 + _1683);
          float _1910 = (((((_1809 * _1762) * _mieScatterColor.x) + ((_1705 * _1782) * _1758)) + ((_1831 + (_1819 * _1758)) * _1728)) + (SKY_SCATTERING
            ? (_560 * SKY_RAY_INSCATTER(0, _1876,_1877,_1878, _1705,_1708,_1710, _1780) + _560 * SKY_VAN_DOT(0, _1876,_1877,_1878) * (_1902 + _mieScatterColor.x * _1898))
            : (((((_1705 * _1780) + _1902) + (_mieScatterColor.x * _1898)) * _560) * (((_1877 * _sky_mtx[0][1]) + (_1876 * _sky_mtx[0][0])) + (_1878 * _sky_mtx[0][2]))))) * _259;
          float _1918 = (((((_1809 * _1764) * _mieScatterColor.y) + ((_1708 * _1782) * _1759)) + ((_1834 + (_1819 * _1759)) * _1728)) + (SKY_SCATTERING
            ? (_561 * SKY_RAY_INSCATTER(1, _1876,_1877,_1878, _1705,_1708,_1710, _1780) + _561 * SKY_VAN_DOT(1, _1876,_1877,_1878) * (_1902 + _mieScatterColor.y * _1898))
            : (((((_1708 * _1780) + _1902) + (_mieScatterColor.y * _1898)) * _561) * (((_1877 * _sky_mtx[1][1]) + (_1876 * _sky_mtx[1][0])) + (_1878 * _sky_mtx[1][2]))))) * _259;
          float _1926 = (((((_1809 * _1766) * _mieScatterColor.z) + ((_1710 * _1782) * _1760)) + ((_1837 + (_1819 * _1760)) * _1728)) + (SKY_SCATTERING
            ? (_562 * SKY_RAY_INSCATTER(2, _1876,_1877,_1878, _1705,_1708,_1710, _1780) + _562 * SKY_VAN_DOT(2, _1876,_1877,_1878) * (_1902 + _mieScatterColor.z * _1898))
            : ((((_1902 + (_1710 * _1780)) + (_mieScatterColor.z * _1898)) * _562) * (((_1877 * _sky_mtx[2][1]) + (_1876 * _sky_mtx[2][0])) + (_1878 * _sky_mtx[2][2]))))) * _259;
          if (_1683 > 0.0010000000474974513f) {
            float _1930 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * 0.5f;
            float _1931 = _1930 * _1930;
            float _1947 = (_1728 * ((_1629 * 0.20000000298023224f) + _1697)) + _1719;
            float _1954 = exp2((_1731 + _1947) * -1.4426950216293335f);
            float _1955 = exp2((_1735 + _1947) * -1.4426950216293335f);
            float _1956 = exp2((_1738 + _1947) * -1.4426950216293335f);
            float _1978 = (_1774 * _1728) * (((((_1683 * _753) * 4.074366569519043f) * _259) * (((1.0f - _1931) * 3.0f) / ((_1931 + 2.0f) * 2.0f))) * (_181 / exp2(log2((1.0f - ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * _171)) + _1931) * 1.5f)));
            _1986 = ((_1978 * (((_1955 * _sky_mtx[0][1]) + (_1954 * _sky_mtx[0][0])) + (_1956 * _sky_mtx[0][2]))) + _1910);
            _1987 = ((_1978 * (((_1955 * _sky_mtx[1][1]) + (_1954 * _sky_mtx[1][0])) + (_1956 * _sky_mtx[1][2]))) + _1918);
            _1988 = ((_1978 * (((_1955 * _sky_mtx[2][1]) + (_1954 * _sky_mtx[2][0])) + (_1956 * _sky_mtx[2][2]))) + _1926);
          } else {
            _1986 = _1910;
            _1987 = _1918;
            _1988 = _1926;
          }
          float _1989 = saturate(float((int)(int(float((uint)_464) * 0.33000001311302185f))) + _129) * _precomputedAmbient7.y;
          _2002 = _252;
          _2003 = select(_459, _461, 0);
          _2004 = _464;
          _2005 = ((((((_precomputedAmbients[48]).x) * _259) * (_1831 + (_1762 * _1717))) + _236) + (_1986 * _1989));
          _2006 = ((((((_precomputedAmbients[48]).y) * _259) * (_1834 + (_1764 * _1717))) + _235) + (_1987 * _1989));
          _2007 = ((((((_precomputedAmbients[48]).z) * _259) * (_1837 + (_1766 * _1717))) + _234) + (_1988 * _1989));
          _2008 = _1693;
          _2009 = _1694;
          _2010 = _1695;
          _2011 = _1696;
          _2012 = _767;
          _2013 = _768;
          _2014 = _1683;
          _2015 = _970;
          _2016 = ((int)(uint)((int)((((int)(((int)(_251 < _213)) & ((int)(_264 < _466))))) | ((int)(_viewPos.y > _466)))));
          _2017 = ((int)(uint)((int)(exp2((_1697 * -1.4426950216293335f) * _1728) < 0.0010000000474974513f)));
        }
        uint _2018 = _2004 + 1u;
        if ((((int)(((int)((uint)_2018 < (uint)300)) & ((int)(_2016 != 0))))) & ((int)(_2017 == 0))) {
          _225 = _2016;
          _226 = _2015;
          _227 = _2014;
          _228 = _2013;
          _229 = _2012;
          _230 = _2011;
          _231 = _2010;
          _232 = _2009;
          _233 = _2008;
          _234 = _2007;
          _235 = _2006;
          _236 = _2005;
          _237 = _2018;
          _238 = _2003;
          _239 = _2002;
          continue;
        }
        float _2026 = select((_2017 != 0), 1e+06f, _2010);
        if (_130) {
          float _2032 = (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).x) + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          float _2036 = _151 - ((_148 - (_2032 * _2032)) * _152);
          if (!(_2036 < 0.0f)) {
            _2044 = ((sqrt(_2036) - _147) / (_145 * 2.0f));
          } else {
            _2044 = -1.0f;
          }
          float _2048 = _151 - ((_148 - ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x))) * _152);
          if (!(_2048 < 0.0f)) {
            _2056 = ((sqrt(_2048) - _147) / (_145 * 2.0f));
          } else {
            _2056 = -1.0f;
          }
          if (((int)(_2044 >= 0.0f)) & ((int)(_2056 <= 0.0f))) {
            float _2062 = (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).z) * 4.999999873689376e-05f;
            float _2063 = _2044 * _114;
            float _2065 = _2044 * _116;
            float _2066 = _2063 + _viewPos.x;
            float _2067 = (_2044 * _115) + _viewPos.y;
            float _2068 = _2065 + _viewPos.z;
            float _2076 = (_2066 * _2062) - ((float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w) * 0.0003000000142492354f);
            float _2077 = (_2068 * _2062) - ((float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z) * 0.0003000000142492354f);
            float4 _2081 = __3__36__0__0__g_texCirrus.SampleBias(__0__95__0__0__g_samplerAnisotropicWrap, float2(_2076, _2077), -1.0f, int2(0, 0));
            _36[0] = _2081.x;
            _36[1] = _2081.y;
            _36[2] = _2081.z;
            _36[3] = _2081.w;
            float _2093 = max(0.009999999776482582f, ((3.0f - (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).y)) * 20000.0f));
            float _2096 = (_2063 * _2063) + (_2065 * _2065);
            float _2097 = sqrt(_2096);
            if (!(_2097 > _2093)) {
              _2105 = (1.0f - cos((1.5707963705062866f / _2093) * _2097));
            } else {
              _2105 = 1.0f;
            }
            float _2106 = _2105 * (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).y);
            _36[0] = ((_2081.x * (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).w)) * _2106);
            _36[1] = ((_2106 * _2081.y) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).x));
            _36[2] = ((_2106 * _2081.z) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).y));
            float _2135 = ((((sin(mad(_2077, -0.6000000238418579f, (_2076 * 0.800000011920929f)) * 3.0299999713897705f) * 0.25f) * sin(mad(_2077, 0.800000011920929f, (_2076 * 0.6000000238418579f)) * 3.0299999713897705f)) + ((sin(_2076 * 1.5f) * 0.5f) * sin(_2077 * 1.5f))) * 1.6000001430511475f) + 1.5f;
            int _2138 = int(min(max(_2135, 0.0f), 2.0f));
            float _2147 = _36[_2138];
            float _2150 = (((_36[((_2138 + 1) % 3)]) - _2147) * saturate(_2135 - float((int)(_2138)))) + _2147;
            float _2151 = _2067 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
            float _2154 = sqrt((_2151 * _2151) + _2096);
            float _2155 = _2063 / _2154;
            float _2156 = _2151 / _2154;
            float _2157 = _2065 / _2154;
            float _2158 = _2154 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
            if (_2158 > 0.0f) {
              float _2161 = dot(float3(_2155, _2156, _2157), float3(_114, _115, _116));
              float _2170 = min(max(_2158, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
              float _2178 = max(_2170, 0.0f);
              float _2185 = (-0.0f - sqrt((_2178 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _2178)) / (_2178 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
              if (_2161 > _2185) {
                _2208 = ((exp2(log2(saturate((_2161 - _2185) / (1.0f - _2185))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
              } else {
                _2208 = ((exp2(log2(saturate((_2185 - _2161) / (_2185 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
              }
              float4 _2218 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(((exp2(log2(saturate((_2170 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _2208, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_2155, _2156, _2157), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
              _2223 = _2218.x;
              _2224 = _2218.y;
              _2225 = _2218.z;
            } else {
              _2223 = 0.0f;
              _2224 = 0.0f;
              _2225 = 0.0f;
            }
            float _2230 = max(_2158, 0.009999999776482582f);
            float _2231 = -0.0f - _2230;
            float _2239 = exp2((_2231 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f);
            float _2240 = exp2((_2231 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f);
            float _2244 = _2066 - _viewPos.x;
            float _2245 = _2068 - _viewPos.z;
            float _2248 = (_2244 * _2244) + (_2245 * _2245);
            float _2249 = sqrt(_2248);
            float _2255 = max(((_2249 * _2249) + -4e+05f), 0.0f) * 9.999999974752427e-07f;
            float _2256 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - _2255;
            float _2259 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
            float _2262 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
            float _2265 = _2067 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
            float _2272 = (((-0.0f - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _2256) + sqrt(_2248 + (_2265 * _2265))) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_2272 < 0.0f)) | ((int)(_2272 > 1.0f)))) {
              float _2295 = ((((float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z) * 0.0010000000474974513f) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
              float _2296 = _2067 - _2256;
              float _2305 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2262 * (_2066 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2262 * _2296) - _2295), (_2262 * (_2068 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
              float _2310 = _2259 / _2262;
              float _2311 = _2310 * _2262;
              float _2313 = _2310 * _2295;
              float _2319 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2259 * _2066) - (_2311 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2296 * _2259) - _2313), ((_2259 * _2068) - (_2311 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
              float _2329 = (4.0f - (saturate(max((_2249 + -2500.0f), 0.0f) * 0.05000000074505806f) * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
              float _2333 = _2311 * 4.355000019073486f;
              float _2340 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2329 * _2066) - (_2333 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2329 * _2296) - (_2313 * 4.355000019073486f)), ((_2329 * _2068) - (_2333 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
              float _2350 = 1.0f - sqrt(saturate((1.0f - _2272) * 1.4285714626312256f));
              float _2368 = (((1.0f - _2319.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * _2340.x) * ((saturate(_2272 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
              _2375 = (saturate(((saturate(saturate(((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + ((_2305.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_2350 * 0.5f), ((_2350 * _2350) * _2350))) * saturate(_2272 * 10.0f)) - _2368) / (1.0f - _2368)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
            } else {
              _2375 = 0.0f;
            }
            if ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f) {
              _2387 = saturate((((1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z)) * _2249) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
            } else {
              _2387 = 1.0f;
            }
            float _2390 = _2067 - _viewPos.y;
            float _2393 = sqrt(_2248 + (_2390 * _2390));
            float _2399 = max(9.999999974752427e-07f, ((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).z) * 0.0024999999441206455f));
            float _2400 = _2399 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z);
            float _2401 = _2399 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w);
            float _2402 = _2399 * _2066;
            float _2403 = _2399 * _2067;
            float _2404 = _2399 * _2068;
            float _2412 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2402 * 0.5127000212669373f) - _2400), (_2403 * 0.5127000212669373f), ((_2404 * 0.5127000212669373f) - _2401)), 0.0f);
            float _2425 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2402 * 6.393881797790527f) - (_2400 * 1.871000051498413f)), (_2403 * 6.393881797790527f), ((_2404 * 6.393881797790527f) - (_2401 * 1.871000051498413f))), 0.0f);
            float _2443 = ((((saturate(_2393 * 0.0078125f) * 2.0f) * (1.0f - _2412.x)) * exp2(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).y) * -0.14426951110363007f) * max(0.0010000000474974513f, (_2230 - (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).x))))) * (((0.5f - _2425.x) * saturate((_2393 + -300.0f) * 0.0024999999441206455f)) + _2425.x)) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).w);
            float _2444 = _2067 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
            float _2446 = (_2444 + _2255) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(_sunDirection.y > 0.0f)) {
              if (!(_sunDirection.y > _moonDirection.y)) {
                _2456 = _moonDirection.x;
                _2457 = _moonDirection.y;
                _2458 = _moonDirection.z;
              } else {
                _2456 = _sunDirection.x;
                _2457 = _sunDirection.y;
                _2458 = _sunDirection.z;
              }
            } else {
              _2456 = _sunDirection.x;
              _2457 = _sunDirection.y;
              _2458 = _sunDirection.z;
            }
            bool _2459 = (_2457 > 0.0f);
            float _2468 = ((0.5f - (float((int)(((int)(uint)(_2459)) - ((int)(uint)((int)(_2457 < 0.0f))))) * 0.5f)) * (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) + _2256;
            if (_2067 < _2256) {
              float _2471 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2456, _2457, _2458));
              float _2477 = select((abs(_2471) < 9.99999993922529e-09f), 1e+08f, ((_2468 - dot(float3(0.0f, 1.0f, 0.0f), float3(_2066, _2067, _2068))) / _2471));
              _2483 = ((_2477 * _2456) + _2066);
              _2484 = _2468;
              _2485 = ((_2477 * _2458) + _2068);
            } else {
              _2483 = _2066;
              _2484 = _2067;
              _2485 = _2068;
            }
            float _2496 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3((((_2483 - _viewPos.x) * 4.999999873689376e-05f) + 0.5f), ((_2484 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)), (((_2485 - _viewPos.z) * 4.999999873689376e-05f) + 0.5f)), 0.0f);
            float _2500 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
            float _2505 = abs(_2457);
            float _2507 = saturate(_2505 * 4.0f);
            float _2509 = (_2507 * _2507) * exp2((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * -1.4426950216293335f) * _2496.x) * _2500);
            float _2515 = ((1.0f - _2509) * saturate((_2444 - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) * 0.10000000149011612f)) + _2509;
            float _2518 = -0.0f - _2500;
            float _2519 = (log2(_2515) * 0.6931471824645996f) / _2518;
            if (((int)((_2387 * _2375) > 0.0010000000474974513f)) & (((int)(((int)(_2446 >= 0.0f)) & ((int)(_2446 <= 1.0f)))))) {
              float _2531 = (_2067 - _2256) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_2531 < 0.0f)) | ((int)(_2531 > 1.0f)))) {
                if (_2505 > 0.0010000000474974513f) {
                  _2544 = min(300.0f, (((_2256 - _2067) + select(_2459, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x), 0.0f)) / _2457));
                } else {
                  _2544 = 300.0f;
                }
                float _2545 = _2544 * 0.20000000298023224f;
                float _2546 = _2545 * _2456;
                float _2547 = _2545 * _2457;
                float _2548 = _2545 * _2458;
                _2556 = 0.0f;
                _2557 = _2545;
                _2558 = _2546;
                _2559 = _2547;
                _2560 = _2548;
                _2561 = ((_2546 * 0.5f) + _2066);
                _2562 = ((_2547 * 0.5f) + _2067);
                _2563 = ((_2548 * 0.5f) + _2068);
                _2564 = 0;
                while(true) {
                  float _2570 = _2561 - _viewPos.x;
                  float _2571 = _2563 - _viewPos.z;
                  float _2574 = (_2570 * _2570) + (_2571 * _2571);
                  float _2575 = sqrt(_2574);
                  float _2582 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_2575 * _2575) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                  float _2587 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
                  float _2589 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
                  float _2594 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _2562;
                  float _2600 = ((sqrt(_2574 + (_2594 * _2594)) - _2582) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                  if (!(((int)(_2600 < 0.0f)) | ((int)(_2600 > 1.0f)))) {
                    float4 _2633 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((((_2561 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - (((_2563 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                    float _2644 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                    float _2645 = _2562 - _2582;
                    float _2656 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2589 * (_2561 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2589 * _2645) - _2644), (_2589 * (_2563 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                    float _2661 = _2587 / _2589;
                    float _2662 = _2661 * _2589;
                    float _2664 = _2661 * _2644;
                    float _2670 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2587 * _2561) - (_2662 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2587 * _2645) - _2664), ((_2587 * _2563) - (_2662 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                    float _2676 = saturate(max((_2575 + -2500.0f), 0.0f) * 0.05000000074505806f);
                    float _2680 = (4.0f - (_2676 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                    float _2684 = _2662 * 4.355000019073486f;
                    float _2691 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2680 * _2561) - (_2684 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2680 * _2645) - (_2664 * 4.355000019073486f)), ((_2680 * _2563) - (_2684 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                    float _2703 = 1.0f - sqrt(saturate((1.0f - _2600) * 1.4285714626312256f));
                    float _2719 = saturate(saturate((((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + _2633.x) + ((_2656.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_2703 * 0.5f), ((_2703 * _2703) * _2703))) * saturate(_2600 * 10.0f);
                    float _2722 = ((_2691.x * (1.0f - _2670.x)) * ((saturate(_2600 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f)) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x);
                    float _2723 = _2722 * ((_2676 * 0.4000000059604645f) + 0.10000000149011612f);
                    _2735 = (saturate((_2719 - _2722) / (1.0f - _2722)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                    _2736 = (saturate((_2719 - _2723) / (1.0f - _2723)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                  } else {
                    _2735 = 0.0f;
                    _2736 = 0.0f;
                  }
                  float _2750 = (((exp2((((_2556 * -0.007213474716991186f) * _2557) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z))) * (_2735 - _2736)) + _2736) * _2557) + _2556;
                  int _2758 = _2564 + 1;
                  if (!(_2758 == 6)) {
                    _2556 = _2750;
                    _2557 = (_2557 * 1.2999999523162842f);
                    _2558 = (_2558 * 1.2999999523162842f);
                    _2559 = (_2559 * 1.2999999523162842f);
                    _2560 = (_2560 * 1.2999999523162842f);
                    _2561 = (_2561 + _2558);
                    _2562 = (_2562 + _2559);
                    _2563 = (_2563 + _2560);
                    _2564 = _2758;
                    continue;
                  }
                  _2763 = (_2750 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
                  break;
                }
                if (__loop_jump_target == 224) {
                  __loop_jump_target = -1;
                  continue;
                }
                if (__loop_jump_target != -1) {
                  break;
                }
              } else {
                _2763 = 0.0f;
              }
              float _2764 = max(_2519, _2763);
              float _2768 = _2066 - _viewPos.x;
              float _2769 = _2068 - _viewPos.z;
              float _2770 = _2768 * _2768;
              float _2771 = _2769 * _2769;
              float _2773 = sqrt(_2770 + _2771);
              float _2784 = ((_2067 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) + (max(((_2773 * _2773) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_2784 < 0.0f)) | ((int)(_2784 > 1.0f)))) {
                float4 _2810 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_2066 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_2068 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                float _2812 = _2066 + 50.0f;
                float _2813 = _2067 + 200.0f;
                float _2814 = _2812 - _viewPos.x;
                float _2816 = (_2814 * _2814) + _2771;
                float _2817 = sqrt(_2816);
                float _2822 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_2817 * _2817) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                float _2825 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
                float _2828 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
                float _2831 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _2813;
                float _2832 = _2831 * _2831;
                float _2837 = ((sqrt(_2816 + _2832) - _2822) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                if (!(((int)(_2837 < 0.0f)) | ((int)(_2837 > 1.0f)))) {
                  float _2861 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                  float _2862 = _2813 - _2822;
                  float _2873 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2828 * (_2812 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2828 * _2862) - _2861), (_2828 * (_2068 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _2878 = _2825 / _2828;
                  float _2879 = _2878 * _2828;
                  float _2881 = _2878 * _2861;
                  float _2887 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2825 * _2812) - (_2879 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2862 * _2825) - _2881), ((_2825 * _2068) - (_2879 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _2893 = saturate(max((_2817 + -2500.0f), 0.0f) * 0.05000000074505806f);
                  float _2897 = (4.0f - (_2893 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                  float _2901 = _2879 * 4.355000019073486f;
                  float _2908 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2897 * _2812) - (_2901 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2897 * _2862) - (_2881 * 4.355000019073486f)), ((_2897 * _2068) - (_2901 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _2918 = 1.0f - sqrt(saturate((1.0f - _2837) * 1.4285714626312256f));
                  float _2940 = ((((1.0f - _2887.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_2893 * 0.4000000059604645f) + 0.10000000149011612f)) * _2908.x) * ((saturate(_2837 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                  _2947 = (saturate(((saturate(saturate(((_2810.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_2873.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_2918 * 0.5f), ((_2918 * _2918) * _2918))) * saturate(_2837 * 10.0f)) - _2940) / (1.0f - _2940)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                } else {
                  _2947 = 0.0f;
                }
                bool _2949 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
                if (_2949) {
                  _2959 = saturate(((_2817 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
                } else {
                  _2959 = 1.0f;
                }
                float _2961 = _2068 + -50.0f;
                float _2962 = _2961 - _viewPos.z;
                float _2964 = _2770 + (_2962 * _2962);
                float _2965 = sqrt(_2964);
                float _2970 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_2965 * _2965) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                float _2975 = ((sqrt(_2964 + _2832) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _2970) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                if (!(((int)(_2975 < 0.0f)) | ((int)(_2975 > 1.0f)))) {
                  float _2999 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                  float _3000 = _2813 - _2970;
                  float _3011 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2828 * (_2066 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3000 * _2828) - _2999), (_2828 * (_2961 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3016 = _2825 / _2828;
                  float _3017 = _3016 * _2828;
                  float _3019 = _3016 * _2999;
                  float _3025 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2825 * _2066) - (_3017 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3000 * _2825) - _3019), ((_2825 * _2961) - (_3017 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3031 = saturate(max((_2965 + -2500.0f), 0.0f) * 0.05000000074505806f);
                  float _3035 = (4.0f - (_3031 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                  float _3039 = _3017 * 4.355000019073486f;
                  float _3046 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_3035 * _2066) - (_3039 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3035 * _3000) - (_3019 * 4.355000019073486f)), ((_3035 * _2961) - (_3039 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3056 = 1.0f - sqrt(saturate((1.0f - _2975) * 1.4285714626312256f));
                  float _3078 = ((((1.0f - _3025.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_3031 * 0.4000000059604645f) + 0.10000000149011612f)) * _3046.x) * ((saturate(_2975 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                  _3085 = (saturate(((saturate(saturate(((_2810.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_3011.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_3056 * 0.5f), ((_3056 * _3056) * _3056))) * saturate(_2975 * 10.0f)) - _3078) / (1.0f - _3078)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                } else {
                  _3085 = 0.0f;
                }
                if (_2949) {
                  _3095 = saturate(((_2965 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
                } else {
                  _3095 = 1.0f;
                }
                _3103 = _2764;
                _3104 = ((((_3095 * _3085) + (_2959 * _2947)) * 20.0f) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
              } else {
                _3103 = _2764;
                _3104 = 0.0f;
              }
            } else {
              _3103 = _2519;
              _3104 = ((log2(max(_2515, 0.5f)) * 0.6931471824645996f) / _2518);
            }
            float _3105 = dot(float3(_2155, _2156, _2157), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
            float _3110 = min(max(_2230, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
            float _3118 = max(_3110, 0.0f);
            float _3126 = (-0.0f - sqrt((_3118 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _3118)) / (_3118 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            if (_3105 > _3126) {
              _3149 = ((exp2(log2(saturate((_3105 - _3126) / (1.0f - _3126))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _3149 = ((exp2(log2(saturate((_3126 - _3105) / (_3126 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float2 _3154 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_3110 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _3149), 0.0f);
            float _3165 = ((_2239 + _2012) * 12.5f) + _2008;
            float _3166 = ((_2240 + _2013) * 12.5f) + _2009;
            float _3167 = ((_2150 + _2014) * 12.5f) + _2026;
            float _3168 = ((_2443 + _2015) * 12.5f) + _2011;
            float _3169 = _3168 + _3167;
            float _3170 = _3154.x + _3165;
            float _3177 = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255)));
            float _3180 = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255)));
            float _3182 = float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255)));
            float _3189 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f;
            float _3190 = _3189 * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f);
            float _3200 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
            float _3202 = (_3177 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
            float _3204 = (_3200 * (_3103 + _3169)) + (_3190 * (_3154.y + _3166));
            float _3206 = (_3180 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
            float _3209 = (_3182 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
            float _3215 = exp2(((_3202 * _3170) + _3204) * -1.4426950216293335f);
            float _3216 = exp2(((_3206 * _3170) + _3204) * -1.4426950216293335f);
            float _3217 = exp2(((_3209 * _3170) + _3204) * -1.4426950216293335f);
            float _3230 = ((_3216 * _sky_mtx[0][1]) + (_3215 * _sky_mtx[0][0])) + (_3217 * _sky_mtx[0][2]);
            float _3231 = ((_3216 * _sky_mtx[1][1]) + (_3215 * _sky_mtx[1][0])) + (_3217 * _sky_mtx[1][2]);
            float _3232 = ((_3216 * _sky_mtx[2][1]) + (_3215 * _sky_mtx[2][0])) + (_3217 * _sky_mtx[2][2]);
            float _3233 = _3230 * _2240;
            float _3234 = _3231 * _2240;
            float _3235 = _3232 * _2240;
            float _3236 = _3200 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
            float _3248 = (1.0f - exp2((_3236 * -288.53900146484375f) * _2443)) * _2443;
            float _3252 = _181 * 0.05968310311436653f;
            float _3257 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
            float _3276 = (((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.591549334989395e-06f) * (((1.0f - _3257) * 3.0f) / ((_3257 + 2.0f) * 2.0f))) * (_181 / exp2(log2((_3257 + 1.0f) - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _183)) * 1.5f));
            float _3285 = exp2(log2(1.0f - exp2((_3236 * -14.426950454711914f) * _2150)) * 1.25f) * ((_191 * 64.0f) * _2150);
            float _3293 = _209 * 2.0f;
            float _3294 = _volumeFogScatterColor.x * (_3248 * _3230);
            float _3296 = _volumeFogScatterColor.y * (_3248 * _3231);
            float _3298 = _volumeFogScatterColor.z * (_3248 * _3232);
            float _3306 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 0.0004999999655410647f;
            float _3310 = _209 * 50.0f;
            float _3331 = (_3200 * (_3104 + _3169)) + (_3190 * _3166);
            float _3340 = exp2(((_3202 * _3165) + _3331) * -1.4426950216293335f);
            float _3341 = exp2(((_3206 * _3165) + _3331) * -1.4426950216293335f);
            float _3342 = exp2(((_3209 * _3165) + _3331) * -1.4426950216293335f);
            float _3359 = (((_3341 * _sky_mtx[0][1]) + (_3340 * _sky_mtx[0][0])) + (_3342 * _sky_mtx[0][2])) * _2223;
            float _3360 = (((_3341 * _sky_mtx[1][1]) + (_3340 * _sky_mtx[1][0])) + (_3342 * _sky_mtx[1][2])) * _2224;
            float _3361 = (((_3341 * _sky_mtx[2][1]) + (_3340 * _sky_mtx[2][0])) + (_3342 * _sky_mtx[2][2])) * _2225;
            float _3362 = _2240 * _3189;
            float _3366 = _3200 * (_2443 + _2150);
            float _3373 = _2239 * 4.901960892311763e-06f;
            _3402 = (((((_precomputedAmbients[48]).x) * ((_3294 * _3310) + (_3233 * _3306))) + _2005) + ((((_3373 * _3177) * (_3359 + (_3230 * _3252))) + (((((_3276 * _3233) * _mieScatterColor.x) + (((_3294 * _3293) + (_3285 * _3230)) * _3200)) + (_3359 * ((_mieScatterColor.x * _3362) + _3366))) * 25.0f)) * _precomputedAmbient7.y));
            _3403 = (((((_precomputedAmbients[48]).y) * ((_3296 * _3310) + (_3234 * _3306))) + _2006) + ((((_3373 * _3180) * (_3360 + (_3231 * _3252))) + (((((_3276 * _3234) * _mieScatterColor.y) + (((_3296 * _3293) + (_3285 * _3231)) * _3200)) + (_3360 * ((_mieScatterColor.y * _3362) + _3366))) * 25.0f)) * _precomputedAmbient7.y));
            _3404 = (((((_precomputedAmbients[48]).z) * ((_3298 * _3310) + (_3235 * _3306))) + _2007) + ((((_3373 * _3182) * (_3361 + (_3232 * _3252))) + (((((_3276 * _3235) * _mieScatterColor.z) + (((_3298 * _3293) + (_3285 * _3232)) * _3200)) + (_3361 * ((_mieScatterColor.z * _3362) + _3366))) * 25.0f)) * _precomputedAmbient7.y));
            _3405 = _3165;
            _3406 = _3166;
            _3407 = _3167;
            _3408 = _3168;
            _3409 = _263;
            _3410 = _264;
            _3411 = _265;
            _3412 = _251;
          } else {
            _3402 = _2005;
            _3403 = _2006;
            _3404 = _2007;
            _3405 = _2008;
            _3406 = _2009;
            _3407 = _2026;
            _3408 = _2011;
            _3409 = _263;
            _3410 = _264;
            _3411 = _265;
            _3412 = _251;
          }
          __defer_164_3401 = true;
        } else {
          _3414 = _251;
          _3415 = _263;
          _3416 = _264;
          _3417 = _265;
          _3418 = _2008;
          _3419 = _2009;
          _3420 = _2026;
          _3421 = _2011;
          _3422 = _2005;
          _3423 = _2006;
          _3424 = _2007;
          if (_212 < _113) {
            float _3430 = _viewPos.x + (_114 * _113);
            float _3431 = _viewPos.y + (_115 * _113);
            float _3432 = _viewPos.z + (_116 * _113);
            float _3439 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3416;
            float _3445 = sqrt(((_3417 * _3417) + (_3415 * _3415)) + (_3439 * _3439));
            float _3446 = _3415 / _3445;
            float _3447 = _3439 / _3445;
            float _3448 = _3417 / _3445;
            float _3451 = dot(float3(_3446, _3447, _3448), float3(_114, _115, _116));
            float _3453 = dot(float3(_114, _115, _116), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
            float _3455 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f;
            float _3457 = min(max(max((_3445 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3455);
            float _3459 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f;
            float _3465 = max(_3457, 0.0f);
            float _3466 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f;
            float _3472 = (-0.0f - sqrt((_3465 + _3466) * _3465)) / (_3465 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            if (_3451 > _3472) {
              _3495 = ((exp2(log2(saturate((_3451 - _3472) / (1.0f - _3472))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _3495 = ((exp2(log2(saturate((_3472 - _3451) / (_3472 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _3497 = (exp2(log2(saturate((_3457 + -16.0f) / _3459)) * 0.5f) * 0.96875f) + 0.015625f;
            float _3502 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3446, _3447, _3448), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
            float4 _3505 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3497, _3495, _3502), 0.0f);
            float4 _3510 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3497, _3495, _3502), 0.0f);
            float _3517 = (_3453 * _3453) + 1.0f;
            float _3518 = _3517 * 0.05968310311436653f;
            float _3522 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
            float _3537 = ((((1.0f - _3522) * 3.0f) / ((_3522 + 2.0f) * 2.0f)) * 0.07957746833562851f) * (_3517 / exp2(log2((_3522 + 1.0f) - ((_3453 * 2.0f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w))) * 1.5f));
            float4 _3542 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3497, _3495, _3502), 0.0f);
            float4 _3547 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3497, _3495, _3502), 0.0f);
            float _3551 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3431;
            float _3557 = sqrt(((_3432 * _3432) + (_3430 * _3430)) + (_3551 * _3551));
            float _3558 = _3430 / _3557;
            float _3559 = _3551 / _3557;
            float _3560 = _3432 / _3557;
            float _3563 = dot(float3(_3558, _3559, _3560), float3(_114, _115, _116));
            float _3566 = min(max(max((_3557 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3455);
            float _3573 = max(_3566, 0.0f);
            float _3579 = (-0.0f - sqrt((_3573 + _3466) * _3573)) / (_3573 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            if (_3563 > _3579) {
              _3602 = ((exp2(log2(saturate((_3563 - _3579) / (1.0f - _3579))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _3602 = ((exp2(log2(saturate((_3579 - _3563) / (_3579 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _3604 = (exp2(log2(saturate((_3566 + -16.0f) / _3459)) * 0.5f) * 0.96875f) + 0.015625f;
            float _3609 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3558, _3559, _3560), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
            float4 _3610 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3604, _3602, _3609), 0.0f);
            float4 _3614 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3604, _3602, _3609), 0.0f);
            float4 _3624 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3604, _3602, _3609), 0.0f);
            float4 _3628 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3604, _3602, _3609), 0.0f);
            float _3641 = dot(float3(_3415, _3439, _3417), float3(_114, _115, _116));
            float _3642 = _3641 / _3445;
            float _3643 = _3415 - _3430;
            float _3644 = _3416 - _3431;
            float _3645 = _3417 - _3432;
            float _3651 = sqrt(((_3644 * _3644) + (_3643 * _3643)) + (_3645 * _3645));
            float _3658 = sqrt((0.5f / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * _3445);
            float _3659 = sqrt((0.5f / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * _3445);
            float _3661 = (_3651 + _3641) / _3445;
            float _3662 = _3658 * _3642;
            float _3663 = _3661 * _3658;
            float _3664 = _3659 * _3642;
            float _3665 = _3661 * _3659;
            float _3686 = float((int)(((int)(uint)((int)(_3662 > 0.0f))) - ((int)(uint)((int)(_3662 < 0.0f)))));
            float _3687 = float((int)(((int)(uint)((int)(_3663 > 0.0f))) - ((int)(uint)((int)(_3663 < 0.0f)))));
            float _3688 = float((int)(((int)(uint)((int)(_3664 > 0.0f))) - ((int)(uint)((int)(_3664 < 0.0f)))));
            float _3689 = float((int)(((int)(uint)((int)(_3665 > 0.0f))) - ((int)(uint)((int)(_3665 < 0.0f)))));
            float _3690 = _3662 * _3662;
            float _3691 = _3664 * _3664;
            if (_3687 > _3686) {
              _3697 = exp2(_3690 * 1.4426950216293335f);
            } else {
              _3697 = 0.0f;
            }
            if (_3689 > _3688) {
              _3703 = exp2(_3691 * 1.4426950216293335f);
            } else {
              _3703 = 0.0f;
            }
            float _3734 = -0.0f - _3651;
            float _3740 = ((_3651 / (_3445 * 2.0f)) + _3642) * 1.4426950216293335f;
            float _3747 = _3445 * 6.283100128173828f;
            float _3752 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) - _3445;
            float _3764 = (exp2((_3752 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f) * sqrt(_3747 * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (dot(float2((_3686 / (sqrt((_3690 * 1.5199999809265137f) + 4.0f) + (abs(_3662) * 2.3192999362945557f))), (exp2(_3740 * (_3734 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (_3687 / (sqrt(((_3663 * _3663) * 1.5199999809265137f) + 4.0f) + (abs(_3663) * 2.3192999362945557f))))), float2(1.0f, -1.0f)) + _3697);
            float _3785 = (((((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f) * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f)) * sqrt((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x) * _3747)) * exp2((_3752 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f)) * (dot(float2((_3688 / (sqrt((_3691 * 1.5199999809265137f) + 4.0f) + (abs(_3664) * 2.3192999362945557f))), (exp2(_3740 * (_3734 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x))) * (_3689 / (sqrt(((_3665 * _3665) * 1.5199999809265137f) + 4.0f) + (abs(_3665) * 2.3192999362945557f))))), float2(1.0f, -1.0f)) + _3703);
            float _3803 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1)) * _3764) + _3785) * -1.4426950216293335f);
            float _3804 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2)) * _3764) + _3785) * -1.4426950216293335f);
            float _3805 = exp2(((((float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3)) * _3764) + _3785) * -1.4426950216293335f);
            _3825 = _3414;
            _3826 = _3418;
            _3827 = _3419;
            _3828 = _3420;
            _3829 = _3421;
            _3830 = _3422;
            _3831 = _3423;
            _3832 = _3424;
            _3833 = _3803;
            _3834 = _3804;
            _3835 = _3805;
            _3836 = max(0.0f, (((((_3537 * _3510.x) + (_3505.x * _3518)) + _3542.x) + _3547.x) - (_3803 * ((((_3614.x * _3537) + (_3610.x * _3518)) + _3624.x) + _3628.x))));
            _3837 = max(0.0f, (((((_3537 * _3510.y) + (_3505.y * _3518)) + _3542.y) + _3547.y) - (_3804 * ((((_3614.y * _3537) + (_3610.y * _3518)) + _3624.y) + _3628.y))));
            _3838 = max(0.0f, (((((_3537 * _3510.z) + (_3505.z * _3518)) + _3542.z) + _3547.z) - (_3805 * ((((_3614.z * _3537) + (_3610.z * _3518)) + _3624.z) + _3628.z))));
          } else {
            _3825 = _3414;
            _3826 = _3418;
            _3827 = _3419;
            _3828 = _3420;
            _3829 = _3421;
            _3830 = _3422;
            _3831 = _3423;
            _3832 = _3424;
            _3833 = 1.0f;
            _3834 = 1.0f;
            _3835 = 1.0f;
            _3836 = 0.0f;
            _3837 = 0.0f;
            _3838 = 0.0f;
          }
        }
        break;
      }
    } else {
      _3402 = 0.0f;
      _3403 = 0.0f;
      _3404 = 0.0f;
      _3405 = 0.0f;
      _3406 = 0.0f;
      _3407 = 0.0f;
      _3408 = 0.0f;
      _3409 = _viewPos.x;
      _3410 = _viewPos.y;
      _3411 = _viewPos.z;
      _3412 = 0.0f;
      __defer_164_3401 = true;
    }
    if (__defer_164_3401) {
      if (!_130) {
        _3414 = _3412;
        _3415 = _3409;
        _3416 = _3410;
        _3417 = _3411;
        _3418 = _3405;
        _3419 = _3406;
        _3420 = _3407;
        _3421 = _3408;
        _3422 = _3402;
        _3423 = _3403;
        _3424 = _3404;
        if (_212 < _113) {
          float _3430 = _viewPos.x + (_114 * _113);
          float _3431 = _viewPos.y + (_115 * _113);
          float _3432 = _viewPos.z + (_116 * _113);
          float _3439 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3416;
          float _3445 = sqrt(((_3417 * _3417) + (_3415 * _3415)) + (_3439 * _3439));
          float _3446 = _3415 / _3445;
          float _3447 = _3439 / _3445;
          float _3448 = _3417 / _3445;
          float _3451 = dot(float3(_3446, _3447, _3448), float3(_114, _115, _116));
          float _3453 = dot(float3(_114, _115, _116), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
          float _3455 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f;
          float _3457 = min(max(max((_3445 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3455);
          float _3459 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f;
          float _3465 = max(_3457, 0.0f);
          float _3466 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f;
          float _3472 = (-0.0f - sqrt((_3465 + _3466) * _3465)) / (_3465 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
          if (_3451 > _3472) {
            _3495 = ((exp2(log2(saturate((_3451 - _3472) / (1.0f - _3472))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _3495 = ((exp2(log2(saturate((_3472 - _3451) / (_3472 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _3497 = (exp2(log2(saturate((_3457 + -16.0f) / _3459)) * 0.5f) * 0.96875f) + 0.015625f;
          float _3502 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3446, _3447, _3448), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
          float4 _3505 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3497, _3495, _3502), 0.0f);
          float4 _3510 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3497, _3495, _3502), 0.0f);
          float _3517 = (_3453 * _3453) + 1.0f;
          float _3518 = _3517 * 0.05968310311436653f;
          float _3522 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
          float _3537 = ((((1.0f - _3522) * 3.0f) / ((_3522 + 2.0f) * 2.0f)) * 0.07957746833562851f) * (_3517 / exp2(log2((_3522 + 1.0f) - ((_3453 * 2.0f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w))) * 1.5f));
          float4 _3542 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3497, _3495, _3502), 0.0f);
          float4 _3547 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3497, _3495, _3502), 0.0f);
          float _3551 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3431;
          float _3557 = sqrt(((_3432 * _3432) + (_3430 * _3430)) + (_3551 * _3551));
          float _3558 = _3430 / _3557;
          float _3559 = _3551 / _3557;
          float _3560 = _3432 / _3557;
          float _3563 = dot(float3(_3558, _3559, _3560), float3(_114, _115, _116));
          float _3566 = min(max(max((_3557 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3455);
          float _3573 = max(_3566, 0.0f);
          float _3579 = (-0.0f - sqrt((_3573 + _3466) * _3573)) / (_3573 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
          if (_3563 > _3579) {
            _3602 = ((exp2(log2(saturate((_3563 - _3579) / (1.0f - _3579))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _3602 = ((exp2(log2(saturate((_3579 - _3563) / (_3579 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _3604 = (exp2(log2(saturate((_3566 + -16.0f) / _3459)) * 0.5f) * 0.96875f) + 0.015625f;
          float _3609 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3558, _3559, _3560), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
          float4 _3610 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3604, _3602, _3609), 0.0f);
          float4 _3614 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3604, _3602, _3609), 0.0f);
          float4 _3624 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3604, _3602, _3609), 0.0f);
          float4 _3628 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3604, _3602, _3609), 0.0f);
          float _3641 = dot(float3(_3415, _3439, _3417), float3(_114, _115, _116));
          float _3642 = _3641 / _3445;
          float _3643 = _3415 - _3430;
          float _3644 = _3416 - _3431;
          float _3645 = _3417 - _3432;
          float _3651 = sqrt(((_3644 * _3644) + (_3643 * _3643)) + (_3645 * _3645));
          float _3658 = sqrt((0.5f / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * _3445);
          float _3659 = sqrt((0.5f / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * _3445);
          float _3661 = (_3651 + _3641) / _3445;
          float _3662 = _3658 * _3642;
          float _3663 = _3661 * _3658;
          float _3664 = _3659 * _3642;
          float _3665 = _3661 * _3659;
          float _3686 = float((int)(((int)(uint)((int)(_3662 > 0.0f))) - ((int)(uint)((int)(_3662 < 0.0f)))));
          float _3687 = float((int)(((int)(uint)((int)(_3663 > 0.0f))) - ((int)(uint)((int)(_3663 < 0.0f)))));
          float _3688 = float((int)(((int)(uint)((int)(_3664 > 0.0f))) - ((int)(uint)((int)(_3664 < 0.0f)))));
          float _3689 = float((int)(((int)(uint)((int)(_3665 > 0.0f))) - ((int)(uint)((int)(_3665 < 0.0f)))));
          float _3690 = _3662 * _3662;
          float _3691 = _3664 * _3664;
          if (_3687 > _3686) {
            _3697 = exp2(_3690 * 1.4426950216293335f);
          } else {
            _3697 = 0.0f;
          }
          if (_3689 > _3688) {
            _3703 = exp2(_3691 * 1.4426950216293335f);
          } else {
            _3703 = 0.0f;
          }
          float _3734 = -0.0f - _3651;
          float _3740 = ((_3651 / (_3445 * 2.0f)) + _3642) * 1.4426950216293335f;
          float _3747 = _3445 * 6.283100128173828f;
          float _3752 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) - _3445;
          float _3764 = (exp2((_3752 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f) * sqrt(_3747 * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (dot(float2((_3686 / (sqrt((_3690 * 1.5199999809265137f) + 4.0f) + (abs(_3662) * 2.3192999362945557f))), (exp2(_3740 * (_3734 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (_3687 / (sqrt(((_3663 * _3663) * 1.5199999809265137f) + 4.0f) + (abs(_3663) * 2.3192999362945557f))))), float2(1.0f, -1.0f)) + _3697);
          float _3785 = (((((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f) * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f)) * sqrt((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x) * _3747)) * exp2((_3752 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f)) * (dot(float2((_3688 / (sqrt((_3691 * 1.5199999809265137f) + 4.0f) + (abs(_3664) * 2.3192999362945557f))), (exp2(_3740 * (_3734 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x))) * (_3689 / (sqrt(((_3665 * _3665) * 1.5199999809265137f) + 4.0f) + (abs(_3665) * 2.3192999362945557f))))), float2(1.0f, -1.0f)) + _3703);
          float _3803 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1)) * _3764) + _3785) * -1.4426950216293335f);
          float _3804 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2)) * _3764) + _3785) * -1.4426950216293335f);
          float _3805 = exp2(((((float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3)) * _3764) + _3785) * -1.4426950216293335f);
          _3825 = _3414;
          _3826 = _3418;
          _3827 = _3419;
          _3828 = _3420;
          _3829 = _3421;
          _3830 = _3422;
          _3831 = _3423;
          _3832 = _3424;
          _3833 = _3803;
          _3834 = _3804;
          _3835 = _3805;
          _3836 = max(0.0f, (((((_3537 * _3510.x) + (_3505.x * _3518)) + _3542.x) + _3547.x) - (_3803 * ((((_3614.x * _3537) + (_3610.x * _3518)) + _3624.x) + _3628.x))));
          _3837 = max(0.0f, (((((_3537 * _3510.y) + (_3505.y * _3518)) + _3542.y) + _3547.y) - (_3804 * ((((_3614.y * _3537) + (_3610.y * _3518)) + _3624.y) + _3628.y))));
          _3838 = max(0.0f, (((((_3537 * _3510.z) + (_3505.z * _3518)) + _3542.z) + _3547.z) - (_3805 * ((((_3614.z * _3537) + (_3610.z * _3518)) + _3624.z) + _3628.z))));
        } else {
          _3825 = _3414;
          _3826 = _3418;
          _3827 = _3419;
          _3828 = _3420;
          _3829 = _3421;
          _3830 = _3422;
          _3831 = _3423;
          _3832 = _3424;
          _3833 = 1.0f;
          _3834 = 1.0f;
          _3835 = 1.0f;
          _3836 = 0.0f;
          _3837 = 0.0f;
          _3838 = 0.0f;
        }
      } else {
        _3825 = _3412;
        _3826 = _3405;
        _3827 = _3406;
        _3828 = _3407;
        _3829 = _3408;
        _3830 = _3402;
        _3831 = _3403;
        _3832 = _3404;
        _3833 = 1.0f;
        _3834 = 1.0f;
        _3835 = 1.0f;
        _3836 = 0.0f;
        _3837 = 0.0f;
        _3838 = 0.0f;
      }
    }
    if (_3825 < _213) {
      float _3844 = (_213 * _114) + _viewPos.x;
      float _3845 = (_213 * _116) + _viewPos.z;
      float _3849 = min(((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * _3825), _213);
      float _3853 = (_3849 * _114) + _viewPos.x;
      float _3854 = (_3849 * _116) + _viewPos.z;
      float _3861 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _viewPos.y;
      float _3862 = _3861 + (_3849 * _115);
      float _3868 = sqrt(((_3854 * _3854) + (_3853 * _3853)) + (_3862 * _3862));
      float _3869 = _3853 / _3868;
      float _3870 = _3862 / _3868;
      float _3871 = _3854 / _3868;
      float _3874 = dot(float3(_3869, _3870, _3871), float3(_114, _115, _116));
      float _3876 = dot(float3(_114, _115, _116), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
      float _3878 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f;
      float _3880 = min(max(max((_3868 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3878);
      float _3882 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f;
      float _3888 = max(_3880, 0.0f);
      float _3889 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f;
      float _3895 = (-0.0f - sqrt((_3888 + _3889) * _3888)) / (_3888 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
      if (_3874 > _3895) {
        _3918 = ((exp2(log2(saturate((_3874 - _3895) / (1.0f - _3895))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _3918 = ((exp2(log2(saturate((_3895 - _3874) / (_3895 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _3920 = (exp2(log2(saturate((_3880 + -16.0f) / _3882)) * 0.5f) * 0.96875f) + 0.015625f;
      float _3925 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3869, _3870, _3871), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _3928 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3920, _3918, _3925), 0.0f);
      float4 _3933 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3920, _3918, _3925), 0.0f);
      float _3940 = (_3876 * _3876) + 1.0f;
      float _3941 = _3940 * 0.05968310311436653f;
      float _3945 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
      float _3960 = ((((1.0f - _3945) * 3.0f) / ((_3945 + 2.0f) * 2.0f)) * 0.07957746833562851f) * (_3940 / exp2(log2((_3945 + 1.0f) - ((_3876 * 2.0f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w))) * 1.5f));
      float4 _3965 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3920, _3918, _3925), 0.0f);
      float4 _3970 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3920, _3918, _3925), 0.0f);
      float _3974 = _3861 + (_213 * _115);
      float _3980 = sqrt(((_3845 * _3845) + (_3844 * _3844)) + (_3974 * _3974));
      float _3981 = _3844 / _3980;
      float _3982 = _3974 / _3980;
      float _3983 = _3845 / _3980;
      float _3986 = dot(float3(_3981, _3982, _3983), float3(_114, _115, _116));
      float _3989 = min(max(max((_3980 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3878);
      float _3996 = max(_3989, 0.0f);
      float _4002 = (-0.0f - sqrt((_3996 + _3889) * _3996)) / (_3996 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
      if (_3986 > _4002) {
        _4025 = ((exp2(log2(saturate((_3986 - _4002) / (1.0f - _4002))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _4025 = ((exp2(log2(saturate((_4002 - _3986) / (_4002 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _4027 = (exp2(log2(saturate((_3989 + -16.0f) / _3882)) * 0.5f) * 0.96875f) + 0.015625f;
      float _4032 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3981, _3982, _3983), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _4033 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4027, _4025, _4032), 0.0f);
      float4 _4037 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4027, _4025, _4032), 0.0f);
      float4 _4047 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4027, _4025, _4032), 0.0f);
      float4 _4051 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4027, _4025, _4032), 0.0f);
      float _4064 = dot(float3(_3853, _3862, _3854), float3(_114, _115, _116));
      float _4065 = _4064 / _3868;
      float _4066 = _3849 - _213;
      float _4067 = _4066 * _114;
      float _4068 = _4066 * _115;
      float _4069 = _4066 * _116;
      float _4075 = sqrt(((_4067 * _4067) + (_4068 * _4068)) + (_4069 * _4069));
      float _4082 = sqrt((0.5f / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * _3868);
      float _4083 = sqrt((0.5f / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * _3868);
      float _4085 = (_4075 + _4064) / _3868;
      float _4086 = _4082 * _4065;
      float _4087 = _4085 * _4082;
      float _4088 = _4083 * _4065;
      float _4089 = _4085 * _4083;
      float _4110 = float((int)(((int)(uint)((int)(_4086 > 0.0f))) - ((int)(uint)((int)(_4086 < 0.0f)))));
      float _4111 = float((int)(((int)(uint)((int)(_4087 > 0.0f))) - ((int)(uint)((int)(_4087 < 0.0f)))));
      float _4112 = float((int)(((int)(uint)((int)(_4088 > 0.0f))) - ((int)(uint)((int)(_4088 < 0.0f)))));
      float _4113 = float((int)(((int)(uint)((int)(_4089 > 0.0f))) - ((int)(uint)((int)(_4089 < 0.0f)))));
      float _4114 = _4086 * _4086;
      float _4115 = _4088 * _4088;
      if (_4111 > _4110) {
        _4121 = exp2(_4114 * 1.4426950216293335f);
      } else {
        _4121 = 0.0f;
      }
      if (_4113 > _4112) {
        _4127 = exp2(_4115 * 1.4426950216293335f);
      } else {
        _4127 = 0.0f;
      }
      float _4158 = -0.0f - _4075;
      float _4164 = ((_4075 / (_3868 * 2.0f)) + _4065) * 1.4426950216293335f;
      float _4171 = _3868 * 6.283100128173828f;
      float _4176 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) - _3868;
      float _4188 = (exp2((_4176 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f) * sqrt(_4171 * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (dot(float2((_4110 / (sqrt((_4114 * 1.5199999809265137f) + 4.0f) + (abs(_4086) * 2.3192999362945557f))), (exp2(_4164 * (_4158 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (_4111 / (sqrt(((_4087 * _4087) * 1.5199999809265137f) + 4.0f) + (abs(_4087) * 2.3192999362945557f))))), float2(1.0f, -1.0f)) + _4121);
      float _4209 = (((((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f) * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f)) * sqrt((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x) * _4171)) * exp2((_4176 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f)) * (dot(float2((_4112 / (sqrt((_4115 * 1.5199999809265137f) + 4.0f) + (abs(_4088) * 2.3192999362945557f))), (exp2(_4164 * (_4158 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x))) * (_4113 / (sqrt(((_4089 * _4089) * 1.5199999809265137f) + 4.0f) + (abs(_4089) * 2.3192999362945557f))))), float2(1.0f, -1.0f)) + _4127);
      float _4226 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1)) * _4188) + _4209) * -1.4426950216293335f);
      float _4227 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2)) * _4188) + _4209) * -1.4426950216293335f);
      float _4228 = exp2(((((float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3)) * _4188) + _4209) * -1.4426950216293335f);
      _4248 = _4226;
      _4249 = _4227;
      _4250 = _4228;
      _4251 = max(0.0f, (((((_3960 * _3933.x) + (_3928.x * _3941)) + _3965.x) + _3970.x) - (_4226 * ((((_4037.x * _3960) + (_4033.x * _3941)) + _4047.x) + _4051.x))));
      _4252 = max(0.0f, (((((_3960 * _3933.y) + (_3928.y * _3941)) + _3965.y) + _3970.y) - (_4227 * ((((_4037.y * _3960) + (_4033.y * _3941)) + _4047.y) + _4051.y))));
      _4253 = max(0.0f, (((((_3960 * _3933.z) + (_3928.z * _3941)) + _3965.z) + _3970.z) - (_4228 * ((((_4037.z * _3960) + (_4033.z * _3941)) + _4047.z) + _4051.z))));
    } else {
      _4248 = _3833;
      _4249 = _3834;
      _4250 = _3835;
      _4251 = _3836;
      _4252 = _3837;
      _4253 = _3838;
    }
    float _4287 = (((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * (_3829 + _3828)) + (((_3827 * 1.9999999494757503e-05f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f));
    float _4298 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1)) * _3826) + _4287) * -1.4426950216293335f);
    float _4299 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2)) * _3826) + _4287) * -1.4426950216293335f);
    float _4300 = exp2((_4287 + ((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3) + (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f)) * _3826)) * -1.4426950216293335f);
    float _4307 = ((_4251 * _precomputedAmbient7.y) * _4298) + _3830;
    float _4308 = ((_4252 * _precomputedAmbient7.y) * _4299) + _3831;
    float _4309 = ((_4253 * _precomputedAmbient7.y) * _4300) + _3832;
    float _4310 = _4298 * _4248;
    float _4311 = _4299 * _4249;
    float _4312 = _4300 * _4250;
    _4344 = (((_4311 * _sky_mtx[0][1]) + (_4310 * _sky_mtx[0][0])) + (_4312 * _sky_mtx[0][2]));
    _4345 = (((_4311 * _sky_mtx[1][1]) + (_4310 * _sky_mtx[1][0])) + (_4312 * _sky_mtx[1][2]));
    _4346 = (((_4311 * _sky_mtx[2][1]) + (_4310 * _sky_mtx[2][0])) + (_4312 * _sky_mtx[2][2]));
    _4347 = (((_4308 * _sky_mtx[0][1]) + (_4307 * _sky_mtx[0][0])) + (_4309 * _sky_mtx[0][2]));
    _4348 = (((_4308 * _sky_mtx[1][1]) + (_4307 * _sky_mtx[1][0])) + (_4309 * _sky_mtx[1][2]));
    _4349 = (((_4308 * _sky_mtx[2][1]) + (_4307 * _sky_mtx[2][0])) + (_4309 * _sky_mtx[2][2]));
  } else {
    _4344 = 1.0f;
    _4345 = 1.0f;
    _4346 = 1.0f;
    _4347 = 0.0f;
    _4348 = 0.0f;
    _4349 = 0.0f;
  }
  __3__38__0__1__g_texSkyInscatterUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_4347, _4348, _4349, _61.x);
  __3__38__0__1__g_texSkyExtinctionUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_4344, _4345, _4346, 0.0f);
}
