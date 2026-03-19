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
  int _249;
  float _250;
  float _251;
  float _252;
  float _253;
  float _254;
  float _255;
  float _256;
  float _257;
  float _258;
  float _259;
  float _260;
  float _261;
  float _262;
  float _263;
  int _264;
  int _265;
  float _266;
  float _466;
  float _478;
  float _573;
  float _612;
  float _626;
  float _627;
  float _628;
  float _629;
  float _630;
  float _631;
  float _694;
  float _695;
  float _696;
  float _697;
  int _698;
  float _752;
  float _753;
  float _754;
  float _755;
  int _756;
  int _757;
  float _769;
  float _816;
  float _822;
  float _964;
  float _974;
  float _1077;
  float _1078;
  float _1079;
  float _1137;
  float _1149;
  float _1150;
  float _1151;
  float _1152;
  float _1153;
  float _1154;
  float _1155;
  float _1156;
  int _1157;
  float _1328;
  float _1329;
  float _1356;
  float _1540;
  float _1552;
  float _1678;
  float _1688;
  float _1696;
  float _1697;
  float _1742;
  float _1773;
  float _2200;
  float _2201;
  float _2202;
  float _2203;
  float _2204;
  float _2205;
  float _2219;
  int _2220;
  int _2221;
  float _2222;
  float _2223;
  float _2224;
  float _2225;
  float _2226;
  float _2227;
  float _2228;
  float _2229;
  float _2230;
  float _2231;
  float _2232;
  float _2233;
  float _2234;
  float _2235;
  int _2236;
  int _2237;
  float _2264;
  float _2276;
  float _2325;
  float _2428;
  float _2468;
  float _2482;
  float _2483;
  float _2484;
  float _2485;
  float _2486;
  float _2487;
  float _2641;
  float _2653;
  float _2743;
  float _2744;
  float _2745;
  float _2804;
  float _2816;
  float _2817;
  float _2818;
  float _2819;
  float _2820;
  float _2821;
  float _2822;
  float _2823;
  int _2824;
  float _2995;
  float _2996;
  float _3023;
  float _3207;
  float _3219;
  float _3345;
  float _3355;
  float _3363;
  float _3364;
  float _3409;
  float _3440;
  float _3776;
  float _3777;
  float _3778;
  float _3779;
  float _3780;
  float _3781;
  float _3782;
  float _3783;
  float _3784;
  float _3785;
  float _3786;
  float _3787;
  float _3788;
  float _3789;
  float _3791;
  float _3792;
  float _3793;
  float _3794;
  float _3795;
  float _3796;
  float _3797;
  float _3798;
  float _3799;
  float _3800;
  float _3801;
  float _3802;
  float _3803;
  float _3804;
  float _3875;
  float _3982;
  float _4077;
  float _4083;
  float _4231;
  float _4291;
  float _4332;
  float _4337;
  float _4373;
  float _4374;
  float _4375;
  float _4376;
  float _4377;
  float _4378;
  float _4379;
  float _4380;
  float _4381;
  float _4382;
  float _4383;
  float _4384;
  float _4385;
  float _4386;
  float _4387;
  float _4388;
  float _4389;
  float _4390;
  float _4391;
  float _4392;
  float _4472;
  float _4579;
  float _4675;
  float _4681;
  float _4828;
  float _4888;
  float _4929;
  float _4934;
  float _4970;
  float _4971;
  float _4972;
  float _4973;
  float _4974;
  float _4975;
  float _4976;
  float _4977;
  float _4978;
  float _5081;
  float _5082;
  float _5083;
  float _5084;
  float _5085;
  float _5086;
  if (!(_154 < 0.0f)) {
    _162 = ((sqrt(_154) - _147) / (_145 * 2.0f));
  } else {
    _162 = -1.0f;
  }
  if (!(_162 <= 0.0f)) {
    float _171 = dot(float3(_114, _115, _116), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
    float _174 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y);
    float _181 = (_171 * _171) + 1.0f;
    float _182 = _174 + 1.0f;
    float _183 = _171 * 2.0f;
    float _190 = (((1.0f - _174) * 3.0f) / ((_174 + 2.0f) * 2.0f)) * 0.07957746833562851f;
    float _191 = (_181 / exp2(log2(_182 - ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * _183)) * 1.5f)) * _190;
    float _193 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z) * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z);
    float _199 = _193 + 1.0f;
    float _200 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).z) * -2.0f;
    float _207 = (((1.0f - _193) * 3.0f) / ((_193 + 2.0f) * 2.0f)) * 0.039788734167814255f;
    float _209 = ((_181 / exp2(log2(_199 - (_200 * _171)) * 1.5f)) * _207) + _191;
    float _215 = dot(float3(_114, _115, _116), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
    float _217 = (_215 * _215) + 1.0f;
    float _218 = _215 * 2.0f;
    float _225 = (_217 / exp2(log2(_182 - (_218 * (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y))) * 1.5f)) * _190;
    float _233 = ((_217 / exp2(log2(_199 - (_200 * _215)) * 1.5f)) * _207) + _225;
    float _236 = min((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y), (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y));
    float _237 = select(_130, _162, _113);
    bool __defer_164_3775 = false;
    if (_renderFlags.x > 0.5f) {
      float _244 = log2(exp2(log2(max(1.0f, ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).y) * 0.00033333332976326346f))) * 0.0033333334140479565f));
      _249 = 1;
      _250 = 0.0f;
      _251 = 0.0f;
      _252 = 0.0f;
      _253 = 0.0f;
      _254 = 0.0f;
      _255 = 0.0f;
      _256 = 0.0f;
      _257 = 0.0f;
      _258 = 0.0f;
      _259 = 0.0f;
      _260 = 0.0f;
      _261 = 0.0f;
      _262 = 0.0f;
      _263 = 0.0f;
      _264 = 0;
      _265 = 0;
      _266 = 128.0f;
      while(true) {
        float _268 = float((int)(_264));
        float _278 = (((exp2(select(((uint)_264 < (uint)12), (_268 * 0.33000001311302185f), (_268 + -8.039999008178711f)) * _244) + -1.0f) * (_236 + -128.0f)) / (exp2(_244 * 300.0f) + -1.0f)) + 128.0f;
        float _279 = min(_278, _237);
        float _281 = max(0.0f, (_279 - _266));
        float _283 = (_281 * _129) + _266;
        float _286 = (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * _281;
        float _287 = _283 * _114;
        float _289 = _283 * _116;
        float _290 = _287 + _viewPos.x;
        float _291 = (_283 * _115) + _viewPos.y;
        float _292 = _289 + _viewPos.z;
        float4 _314 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_290 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_292 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
        float _321 = (_279 * _114) + _viewPos.x;
        float _322 = (_279 * _115) + _viewPos.y;
        float _323 = (_279 * _116) + _viewPos.z;
        float _327 = _321 - _viewPos.x;
        float _328 = _323 - _viewPos.z;
        float _331 = (_327 * _327) + (_328 * _328);
        float _332 = sqrt(_331);
        float _339 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_332 * _332) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
        float _342 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
        float _345 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
        float _350 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _322;
        float _356 = ((sqrt(_331 + (_350 * _350)) - _339) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
        if (!(((int)(_356 < 0.0f)) | ((int)(_356 > 1.0f)))) {
          float _380 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
          float _381 = _322 - _339;
          float _392 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_345 * (_321 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_345 * _381) - _380), (_345 * (_323 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _397 = _342 / _345;
          float _398 = _397 * _345;
          float _400 = _397 * _380;
          float _406 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_342 * _321) - (_398 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_381 * _342) - _400), ((_342 * _323) - (_398 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _412 = saturate(max((_332 + -2500.0f), 0.0f) * 0.05000000074505806f);
          float _416 = (4.0f - (_412 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
          float _420 = _398 * 4.355000019073486f;
          float _427 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_416 * _321) - (_420 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_416 * _381) - (_400 * 4.355000019073486f)), ((_416 * _323) - (_420 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
          float _437 = 1.0f - sqrt(saturate((1.0f - _356) * 1.4285714626312256f));
          float _459 = ((((1.0f - _406.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_412 * 0.4000000059604645f) + 0.10000000149011612f)) * _427.x) * ((saturate(_356 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
          _466 = (saturate(((saturate(saturate(((_314.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_392.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_437 * 0.5f), ((_437 * _437) * _437))) * saturate(_356 * 10.0f)) - _459) / (1.0f - _459)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
        } else {
          _466 = 0.0f;
        }
        bool _468 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
        if (_468) {
          _478 = saturate((((1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z)) * _332) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
        } else {
          _478 = 1.0f;
        }
        bool _480 = ((_478 * _466) > 0.0010000000474974513f);
        if (((int)(_265 != 0)) & (_480)) {
          _2219 = _266;
          _2220 = 0;
          _2221 = ((int)(_264 + -2u));
          _2222 = _263;
          _2223 = _262;
          _2224 = _261;
          _2225 = _260;
          _2226 = _259;
          _2227 = _258;
          _2228 = _257;
          _2229 = _256;
          _2230 = _255;
          _2231 = _254;
          _2232 = _253;
          _2233 = _252;
          _2234 = _251;
          _2235 = _250;
          _2236 = _249;
          _2237 = 0;
        } else {
          bool _486 = ((uint)_264 < (uint)298);
          int _488 = ((int)(uint)(_480)) ^ 1;
          uint _491 = _264 + (uint)(select(_486, _488, 0));
          float _493 = (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x) + (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
          float _506 = saturate((_283 + -4000.0f) * 0.0010000000474974513f);
          float _513 = _291 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          float _519 = sqrt(((_289 * _289) + (_287 * _287)) + (_513 * _513));
          float _520 = _287 / _519;
          float _521 = _513 / _519;
          float _522 = _289 / _519;
          float _523 = _519 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          if (_523 > 0.0f) {
            float _526 = dot(float3(_520, _521, _522), float3(_114, _115, _116));
            float _535 = min(max(_523, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
            float _543 = max(_535, 0.0f);
            float _550 = (-0.0f - sqrt((_543 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _543)) / (_543 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            bool _551 = (_526 > _550);
            if (_551) {
              _573 = ((exp2(log2(saturate((_526 - _550) / (1.0f - _550))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _573 = ((exp2(log2(saturate((_550 - _526) / (_550 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _575 = (exp2(log2(saturate((_535 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
            float4 _582 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_575, _573, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_520, _521, _522), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
            if (_551) {
              _612 = ((exp2(log2(saturate((_526 - _550) / (1.0f - _550))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _612 = ((exp2(log2(saturate((_550 - _526) / (_550 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float4 _618 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_575, _612, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_520, _521, _522), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
            _626 = _582.x;
            _627 = _582.y;
            _628 = _582.z;
            _629 = (_618.x * 0.25f);
            _630 = (_618.y * 0.25f);
            _631 = (_618.z * 0.25f);
          } else {
            _626 = 0.0f;
            _627 = 0.0f;
            _628 = 0.0f;
            _629 = 0.0f;
            _630 = 0.0f;
            _631 = 0.0f;
          }
          float _633 = _290 - _viewPos.x;
          float _634 = _292 - _viewPos.z;
          if (_506 < 0.9998999834060669f) {
            float _637 = _291 - _viewPos.y;
            float _644 = _290 - ((_staticShadowPosition[1]).x);
            float _645 = _291 - ((_staticShadowPosition[1]).y);
            float _646 = _292 - ((_staticShadowPosition[1]).z);
            float _666 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).x), _646, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).x), _645, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).x) * _644))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).x);
            float _670 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).y), _646, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).y), _645, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).y) * _644))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).y);
            float _674 = mad((float4(_shadowProjRelativeTexScale[1][0].z, _shadowProjRelativeTexScale[1][1].z, _shadowProjRelativeTexScale[1][2].z, _shadowProjRelativeTexScale[1][3].z).z), _646, mad((float4(_shadowProjRelativeTexScale[1][0].y, _shadowProjRelativeTexScale[1][1].y, _shadowProjRelativeTexScale[1][2].y, _shadowProjRelativeTexScale[1][3].y).z), _645, ((float4(_shadowProjRelativeTexScale[1][0].x, _shadowProjRelativeTexScale[1][1].x, _shadowProjRelativeTexScale[1][2].x, _shadowProjRelativeTexScale[1][3].x).z) * _644))) + (float4(_shadowProjRelativeTexScale[1][0].w, _shadowProjRelativeTexScale[1][1].w, _shadowProjRelativeTexScale[1][2].w, _shadowProjRelativeTexScale[1][3].w).z);
            float _675 = 2.0f / _shadowSizeAndInvSize.y;
            float _676 = 1.0f - _675;
            if (!((((int)((((int)(!(_666 <= _676)))) | (((int)(!(_666 >= _675))))))) | (((int)(!(_670 <= _676)))))) {
              bool _687 = ((int)(_674 >= 9.999999747378752e-05f)) & (((int)(((int)(_674 <= 1.0f)) & ((int)(_670 >= _675)))));
              _694 = select(_687, _666, 0.0f);
              _695 = select(_687, _670, 0.0f);
              _696 = select(_687, _674, 0.0f);
              _697 = select(_687, 0.00019999999494757503f, 0.0f);
              _698 = ((int)(uint)(_687));
            } else {
              _694 = 0.0f;
              _695 = 0.0f;
              _696 = 0.0f;
              _697 = 0.0f;
              _698 = 0;
            }
            float _703 = _290 - ((_staticShadowPosition[0]).x);
            float _704 = _291 - ((_staticShadowPosition[0]).y);
            float _705 = _292 - ((_staticShadowPosition[0]).z);
            float _725 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).x), _705, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).x), _704, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).x) * _703))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).x);
            float _729 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).y), _705, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).y), _704, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).y) * _703))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).y);
            float _733 = mad((float4(_shadowProjRelativeTexScale[0][0].z, _shadowProjRelativeTexScale[0][1].z, _shadowProjRelativeTexScale[0][2].z, _shadowProjRelativeTexScale[0][3].z).z), _705, mad((float4(_shadowProjRelativeTexScale[0][0].y, _shadowProjRelativeTexScale[0][1].y, _shadowProjRelativeTexScale[0][2].y, _shadowProjRelativeTexScale[0][3].y).z), _704, ((float4(_shadowProjRelativeTexScale[0][0].x, _shadowProjRelativeTexScale[0][1].x, _shadowProjRelativeTexScale[0][2].x, _shadowProjRelativeTexScale[0][3].x).z) * _703))) + (float4(_shadowProjRelativeTexScale[0][0].w, _shadowProjRelativeTexScale[0][1].w, _shadowProjRelativeTexScale[0][2].w, _shadowProjRelativeTexScale[0][3].w).z);
            if (!((((int)((((int)(!(_725 >= _675)))) | (((int)(!(_725 <= _676))))))) | (((int)(!(_729 <= _676)))))) {
              bool _744 = ((int)(_733 >= 9.999999747378752e-05f)) & (((int)(((int)(_729 >= _675)) & ((int)(_733 <= 1.0f)))));
              _752 = select(_744, _725, _694);
              _753 = select(_744, _729, _695);
              _754 = select(_744, _733, _696);
              _755 = select(_744, 0.00019999999494757503f, _697);
              _756 = select(_744, 1, _698);
              _757 = select(_744, 0, _698);
            } else {
              _752 = _694;
              _753 = _695;
              _754 = _696;
              _755 = _697;
              _756 = _698;
              _757 = _698;
            }
            [branch]
            if (!(_756 == 0)) {
              float4 _764 = __3__36__0__0__g_shadowDepthArray.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float3(_752, _753, float((uint)_757)), (_754 - _755));
              _769 = saturate(1.0f - _764.x);
            } else {
              _769 = 1.0f;
            }
            float _789 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).x), _634, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).x), _637, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).x) * _633))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).x);
            float _793 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).y), _634, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).y), _637, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).y) * _633))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).y);
            float _797 = mad((float4(_terrainShadowProjRelativeTexScale[0].z, _terrainShadowProjRelativeTexScale[1].z, _terrainShadowProjRelativeTexScale[2].z, _terrainShadowProjRelativeTexScale[3].z).z), _634, mad((float4(_terrainShadowProjRelativeTexScale[0].y, _terrainShadowProjRelativeTexScale[1].y, _terrainShadowProjRelativeTexScale[2].y, _terrainShadowProjRelativeTexScale[3].y).z), _637, ((float4(_terrainShadowProjRelativeTexScale[0].x, _terrainShadowProjRelativeTexScale[1].x, _terrainShadowProjRelativeTexScale[2].x, _terrainShadowProjRelativeTexScale[3].x).z) * _633))) + (float4(_terrainShadowProjRelativeTexScale[0].w, _terrainShadowProjRelativeTexScale[1].w, _terrainShadowProjRelativeTexScale[2].w, _terrainShadowProjRelativeTexScale[3].w).z);
            if (saturate(_789) == _789) {
              if (((int)(_797 >= 9.999999747378752e-05f)) & (((int)(((int)(_797 <= 1.0f)) & ((int)(saturate(_793) == _793)))))) {
                float4 _811 = __3__36__0__0__g_terrainShadowDepth.SampleCmpLevelZero(__3__40__0__0__g_samplerShadow, float2(_789, _793), (_797 + -0.004999999888241291f));
                _816 = saturate(1.0f - _811.x);
              } else {
                _816 = 1.0f;
              }
            } else {
              _816 = 1.0f;
            }
            float _817 = min(_769, _816);
            _822 = (lerp(_817, 1.0f, _506));
          } else {
            _822 = 1.0f;
          }
          float _831 = max(_523, 0.009999999776482582f);
          float _832 = -0.0f - _831;
          float _840 = exp2((_832 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f);
          float _841 = exp2((_832 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f);
          float _844 = (_633 * _633) + (_634 * _634);
          float _845 = sqrt(_844);
          float _849 = max(((_845 * _845) + -4e+05f), 0.0f) * 9.999999974752427e-07f;
          float _850 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - _849;
          float _851 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _291;
          float _857 = ((sqrt(_844 + (_851 * _851)) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _850) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
          if (!(((int)(_857 < 0.0f)) | ((int)(_857 > 1.0f)))) {
            float _881 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
            float _882 = _291 - _850;
            float _893 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_345 * (_290 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_882 * _345) - _881), (_345 * (_292 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _898 = _342 / _345;
            float _899 = _898 * _345;
            float _901 = _898 * _881;
            float _907 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_342 * _290) - (_899 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_882 * _342) - _901), ((_342 * _292) - (_899 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _917 = (4.0f - (saturate(max((_845 + -2500.0f), 0.0f) * 0.05000000074505806f) * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
            float _921 = _899 * 4.355000019073486f;
            float _928 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_917 * _290) - (_921 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_917 * _882) - (_901 * 4.355000019073486f)), ((_917 * _292) - (_921 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
            float _938 = 1.0f - sqrt(saturate((1.0f - _857) * 1.4285714626312256f));
            float _957 = (((1.0f - _907.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * _928.x) * ((saturate(_857 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
            _964 = (saturate(((saturate(saturate(((_314.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_893.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_938 * 0.5f), ((_938 * _938) * _938))) * saturate(_857 * 10.0f)) - _957) / (1.0f - _957)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
          } else {
            _964 = 0.0f;
          }
          if (_468) {
            _974 = saturate(((_845 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
          } else {
            _974 = 1.0f;
          }
          float _975 = _974 * _964;
          float _977 = _291 - _viewPos.y;
          float _980 = sqrt(_844 + (_977 * _977));
          float _986 = max(9.999999974752427e-07f, ((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).z) * 0.0024999999441206455f));
          float _989 = _986 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z);
          float _990 = _986 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w);
          float _991 = _986 * _290;
          float _992 = _986 * _291;
          float _993 = _986 * _292;
          float _1006 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_991 * 0.5127000212669373f) - _989), (_992 * 0.5127000212669373f), ((_993 * 0.5127000212669373f) - _990)), 0.0f);
          float _1019 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_991 * 6.393881797790527f) - (_989 * 1.871000051498413f)), (_992 * 6.393881797790527f), ((_993 * 6.393881797790527f) - (_990 * 1.871000051498413f))), 0.0f);
          float _1028 = (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).y) * -0.14426951110363007f;
          float _1043 = (((saturate(_980 * 0.0078125f) * 2.0f) * (1.0f - _1006.x)) * (((0.5f - _1019.x) * saturate((_980 + -300.0f) * 0.0024999999441206455f)) + _1019.x)) * ((exp2(_1028 * max(0.0010000000474974513f, (_831 - (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).x)))) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).w)) + (exp2(_1028 * max(0.0010000000474974513f, ((_831 - (float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).z)) - (((float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).w) - (float4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).z)) * _314.z)))) * _314.y));
          float _1044 = _291 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
          float _1046 = (_849 + _1044) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
          bool _1049 = ((int)(_sunDirection.y > 0.0f)) | ((int)(_sunDirection.y > _moonDirection.y));
          float _1050 = select(_1049, _sunDirection.x, _moonDirection.x);
          float _1051 = select(_1049, _sunDirection.y, _moonDirection.y);
          float _1052 = select(_1049, _sunDirection.z, _moonDirection.z);
          bool _1053 = (_1051 > 0.0f);
          float _1062 = ((0.5f - (float((int)(((int)(uint)(_1053)) - ((int)(uint)((int)(_1051 < 0.0f))))) * 0.5f)) * (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) + _850;
          if (_291 < _850) {
            float _1065 = dot(float3(0.0f, 1.0f, 0.0f), float3(_1050, _1051, _1052));
            float _1071 = select((abs(_1065) < 9.99999993922529e-09f), 1e+08f, ((_1062 - dot(float3(0.0f, 1.0f, 0.0f), float3(_290, _291, _292))) / _1065));
            _1077 = ((_1071 * _1050) + _290);
            _1078 = _1062;
            _1079 = ((_1071 * _1052) + _292);
          } else {
            _1077 = _290;
            _1078 = _291;
            _1079 = _292;
          }
          float _1090 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3((((_1077 - _viewPos.x) * 4.999999873689376e-05f) + 0.5f), ((_1078 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)), (((_1079 - _viewPos.z) * 4.999999873689376e-05f) + 0.5f)), 0.0f);
          float _1093 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _1098 = abs(_1051);
          float _1100 = saturate(_1098 * 4.0f);
          float _1102 = (_1100 * _1100) * exp2((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * -1.4426950216293335f) * _1090.x) * _1093);
          float _1108 = ((1.0f - _1102) * saturate((_1044 - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) * 0.10000000149011612f)) + _1102;
          float _1111 = -0.0f - _1093;
          float _1112 = (log2(_1108) * 0.6931471824645996f) / _1111;
          if (((int)(_975 > 0.0010000000474974513f)) & (((int)(((int)(_1046 >= 0.0f)) & ((int)(_1046 <= 1.0f)))))) {
            float _1124 = (_291 - _850) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_1124 < 0.0f)) | ((int)(_1124 > 1.0f)))) {
              if (_1098 > 0.0010000000474974513f) {
                _1137 = min(300.0f, (((_850 - _291) + select(_1053, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x), 0.0f)) / _1051));
              } else {
                _1137 = 300.0f;
              }
              float _1138 = _1137 * 0.20000000298023224f;
              float _1139 = _1138 * _1050;
              float _1140 = _1138 * _1051;
              float _1141 = _1138 * _1052;
              _1149 = 0.0f;
              _1150 = _1138;
              _1151 = _1139;
              _1152 = _1140;
              _1153 = _1141;
              _1154 = ((_1139 * 0.5f) + _290);
              _1155 = ((_1140 * 0.5f) + _291);
              _1156 = ((_1141 * 0.5f) + _292);
              _1157 = 0;
              while(true) {
                float _1163 = _1154 - _viewPos.x;
                float _1164 = _1156 - _viewPos.z;
                float _1167 = (_1163 * _1163) + (_1164 * _1164);
                float _1168 = sqrt(_1167);
                float _1175 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_1168 * _1168) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                float _1180 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
                float _1182 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
                float _1187 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _1155;
                float _1193 = ((sqrt(_1167 + (_1187 * _1187)) - _1175) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                if (!(((int)(_1193 < 0.0f)) | ((int)(_1193 > 1.0f)))) {
                  float4 _1226 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((((_1154 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - (((_1156 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                  float _1237 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                  float _1238 = _1155 - _1175;
                  float _1249 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_1182 * (_1154 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1182 * _1238) - _1237), (_1182 * (_1156 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1254 = _1180 / _1182;
                  float _1255 = _1254 * _1182;
                  float _1257 = _1254 * _1237;
                  float _1263 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1180 * _1154) - (_1255 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1180 * _1238) - _1257), ((_1180 * _1156) - (_1255 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1269 = saturate(max((_1168 + -2500.0f), 0.0f) * 0.05000000074505806f);
                  float _1273 = (4.0f - (_1269 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                  float _1277 = _1255 * 4.355000019073486f;
                  float _1284 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1273 * _1154) - (_1277 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1273 * _1238) - (_1257 * 4.355000019073486f)), ((_1273 * _1156) - (_1277 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _1296 = 1.0f - sqrt(saturate((1.0f - _1193) * 1.4285714626312256f));
                  float _1312 = saturate(saturate((((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + _1226.x) + ((_1249.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1296 * 0.5f), ((_1296 * _1296) * _1296))) * saturate(_1193 * 10.0f);
                  float _1315 = ((_1284.x * (1.0f - _1263.x)) * ((saturate(_1193 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f)) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x);
                  float _1316 = _1315 * ((_1269 * 0.4000000059604645f) + 0.10000000149011612f);
                  _1328 = (saturate((_1312 - _1315) / (1.0f - _1315)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                  _1329 = (saturate((_1312 - _1316) / (1.0f - _1316)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                } else {
                  _1328 = 0.0f;
                  _1329 = 0.0f;
                }
                float _1343 = (((exp2((((_1149 * -0.007213474716991186f) * _1150) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z))) * (_1328 - _1329)) + _1329) * _1150) + _1149;
                int _1351 = _1157 + 1;
                if (!(_1351 == 6)) {
                  _1149 = _1343;
                  _1150 = (_1150 * 1.2999999523162842f);
                  _1151 = (_1151 * 1.2999999523162842f);
                  _1152 = (_1152 * 1.2999999523162842f);
                  _1153 = (_1153 * 1.2999999523162842f);
                  _1154 = (_1154 + _1151);
                  _1155 = (_1155 + _1152);
                  _1156 = (_1156 + _1153);
                  _1157 = _1351;
                  continue;
                }
                _1356 = (_1343 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
                break;
              }
              if (__loop_jump_target == 248) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
            } else {
              _1356 = 0.0f;
            }
            float _1357 = max(_1112, _1356);
            float _1361 = _290 - _viewPos.x;
            float _1362 = _292 - _viewPos.z;
            float _1363 = _1361 * _1361;
            float _1364 = _1362 * _1362;
            float _1366 = sqrt(_1363 + _1364);
            float _1377 = ((_291 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) + (max(((_1366 * _1366) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_1377 < 0.0f)) | ((int)(_1377 > 1.0f)))) {
              float4 _1403 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_290 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_292 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
              float _1405 = _290 + 50.0f;
              float _1406 = _291 + 200.0f;
              float _1407 = _1405 - _viewPos.x;
              float _1409 = (_1407 * _1407) + _1364;
              float _1410 = sqrt(_1409);
              float _1415 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_1410 * _1410) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
              float _1418 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
              float _1421 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
              float _1424 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _1406;
              float _1425 = _1424 * _1424;
              float _1430 = ((sqrt(_1409 + _1425) - _1415) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_1430 < 0.0f)) | ((int)(_1430 > 1.0f)))) {
                float _1454 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                float _1455 = _1406 - _1415;
                float _1466 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_1421 * (_1405 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1421 * _1455) - _1454), (_1421 * (_292 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1471 = _1418 / _1421;
                float _1472 = _1471 * _1421;
                float _1474 = _1471 * _1454;
                float _1480 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1418 * _1405) - (_1472 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1455 * _1418) - _1474), ((_1418 * _292) - (_1472 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1486 = saturate(max((_1410 + -2500.0f), 0.0f) * 0.05000000074505806f);
                float _1490 = (4.0f - (_1486 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                float _1494 = _1472 * 4.355000019073486f;
                float _1501 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1490 * _1405) - (_1494 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1490 * _1455) - (_1474 * 4.355000019073486f)), ((_1490 * _292) - (_1494 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1511 = 1.0f - sqrt(saturate((1.0f - _1430) * 1.4285714626312256f));
                float _1533 = ((((1.0f - _1480.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_1486 * 0.4000000059604645f) + 0.10000000149011612f)) * _1501.x) * ((saturate(_1430 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                _1540 = (saturate(((saturate(saturate(((_1403.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_1466.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1511 * 0.5f), ((_1511 * _1511) * _1511))) * saturate(_1430 * 10.0f)) - _1533) / (1.0f - _1533)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
              } else {
                _1540 = 0.0f;
              }
              bool _1542 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
              if (_1542) {
                _1552 = saturate(((_1410 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
              } else {
                _1552 = 1.0f;
              }
              float _1554 = _292 + -50.0f;
              float _1555 = _1554 - _viewPos.z;
              float _1557 = _1363 + (_1555 * _1555);
              float _1558 = sqrt(_1557);
              float _1563 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_1558 * _1558) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
              float _1568 = ((sqrt(_1557 + _1425) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _1563) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_1568 < 0.0f)) | ((int)(_1568 > 1.0f)))) {
                float _1592 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                float _1593 = _1406 - _1563;
                float _1604 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_1421 * (_290 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1593 * _1421) - _1592), (_1421 * (_1554 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1609 = _1418 / _1421;
                float _1610 = _1609 * _1421;
                float _1612 = _1609 * _1592;
                float _1618 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1418 * _290) - (_1610 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1593 * _1418) - _1612), ((_1418 * _1554) - (_1610 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1624 = saturate(max((_1558 + -2500.0f), 0.0f) * 0.05000000074505806f);
                float _1628 = (4.0f - (_1624 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                float _1632 = _1610 * 4.355000019073486f;
                float _1639 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_1628 * _290) - (_1632 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_1628 * _1593) - (_1612 * 4.355000019073486f)), ((_1628 * _1554) - (_1632 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                float _1649 = 1.0f - sqrt(saturate((1.0f - _1568) * 1.4285714626312256f));
                float _1671 = ((((1.0f - _1618.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_1624 * 0.4000000059604645f) + 0.10000000149011612f)) * _1639.x) * ((saturate(_1568 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                _1678 = (saturate(((saturate(saturate(((_1403.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_1604.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_1649 * 0.5f), ((_1649 * _1649) * _1649))) * saturate(_1568 * 10.0f)) - _1671) / (1.0f - _1671)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
              } else {
                _1678 = 0.0f;
              }
              if (_1542) {
                _1688 = saturate(((_1558 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
              } else {
                _1688 = 1.0f;
              }
              _1696 = _1357;
              _1697 = ((((_1688 * _1678) + (_1552 * _1540)) * 20.0f) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
            } else {
              _1696 = _1357;
              _1697 = 0.0f;
            }
          } else {
            _1696 = _1112;
            _1697 = ((log2(max(_1108, 0.5f)) * 0.6931471824645996f) / _1111);
          }
          float _1698 = dot(float3(_520, _521, _522), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
          float _1703 = min(max(_831, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
          float _1711 = max(_1703, 0.0f);
          float _1719 = (-0.0f - sqrt((_1711 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _1711)) / (_1711 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
          if (_1698 > _1719) {
            _1742 = ((exp2(log2(saturate((_1698 - _1719) / (1.0f - _1719))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _1742 = ((exp2(log2(saturate((_1719 - _1698) / (_1719 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _1744 = (exp2(log2(saturate((_1703 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
          float2 _1747 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1744, _1742), 0.0f);
          float _1750 = dot(float3(_520, _521, _522), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
          if (_1750 > _1719) {
            _1773 = ((exp2(log2(saturate((_1750 - _1719) / (1.0f - _1719))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _1773 = ((exp2(log2(saturate((_1719 - _1750) / (_1719 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float2 _1774 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1744, _1773), 0.0f);
          float _1777 = _975 * saturate((1.0f - saturate(_283 / _236)) * 10.0f);
          float _1782 = _286 * 0.5f;
          float _1787 = ((_840 + _253) * _1782) + _257;
          float _1788 = ((_841 + _252) * _1782) + _256;
          float _1789 = ((_1777 + _251) * _1782) + _255;
          float _1790 = ((_1043 + _250) * _1782) + _254;
          float _1791 = _1790 + _1789;
          float _1792 = _1747.x + _1787;
          float _1799 = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255)));
          float _1802 = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255)));
          float _1804 = float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255)));
          if (SKY_SCATTERING) { float _skyRef1 = _1804; _1799 = _skyRef1 * SKY_RAYLEIGH_CH1; _1802 = _skyRef1 * SKY_RAYLEIGH_CH2; }
          float _1811 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f;
          float _1812 = _1811 * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f);
          float _1813 = _1812 * (_1747.y + _1788);
          float _1822 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _1823 = _1822 * (_1696 + _1791);
          float _1824 = (_1799 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
          float _1825 = _1824 * _1792;
          float _1826 = _1823 + _1813;
          float _1828 = (_1802 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
          float _1829 = _1828 * _1792;
          float _1831 = (_1804 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
          float _1832 = _1831 * _1792;
          float _1837 = exp2((_1825 + _1826) * -1.4426950216293335f);
          float _1838 = exp2((_1829 + _1826) * -1.4426950216293335f);
          float _1839 = exp2((_1832 + _1826) * -1.4426950216293335f);
          float _1852 = ((_1838 * _sky_mtx[0][1]) + (_1837 * _sky_mtx[0][0])) + (_1839 * _sky_mtx[0][2]);
          float _1853 = ((_1838 * _sky_mtx[1][1]) + (_1837 * _sky_mtx[1][0])) + (_1839 * _sky_mtx[1][2]);
          float _1854 = ((_1838 * _sky_mtx[2][1]) + (_1837 * _sky_mtx[2][0])) + (_1839 * _sky_mtx[2][2]);
          float _1855 = _841 * _822;
          float _1856 = _1852 * _1855;
          float _1857 = _1853 * _1855;
          float _1858 = _1854 * _1855;
          float _1859 = _1822 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
          float _1866 = exp2(log2(1.0f - exp2((_1859 * -14.426950454711914f) * _1777)) * 1.25f);
          float _1870 = 1.0f - exp2((_1859 * -288.53900146484375f) * _1043);
          float _1874 = _840 * 1.960784317134312e-07f;
          float _1876 = ((_181 * 0.05968310311436653f) * _822) * _1874;
          float _1884 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
          float _1890 = _1884 + 1.0f;
          float _1897 = (((1.0f - _1884) * 3.0f) / ((_1884 + 2.0f) * 2.0f)) * 0.07957746833562851f;
          float _1903 = (_1897 * _1811) * (_181 / exp2(log2(_1890 - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _183)) * 1.5f));
          float _1913 = _1866 * (((_191 * 64.0f) * _822) * _1777);
          float _1921 = ((_1043 * 2.0f) * _822) * _209;
          float _1924 = ((_1921 * _1852) * _1870) * _volumeFogScatterColor.x;
          float _1927 = ((_1921 * _1853) * _1870) * _volumeFogScatterColor.y;
          float _1930 = ((_1921 * _1854) * _1870) * _volumeFogScatterColor.z;
          float _1960 = (_1822 * (_1697 + _1791)) + (_1812 * _1788);
          float _1969 = exp2(((_1824 * _1787) + _1960) * -1.4426950216293335f);
          float _1970 = exp2(((_1828 * _1787) + _1960) * -1.4426950216293335f);
          float _1971 = exp2(((_1831 * _1787) + _1960) * -1.4426950216293335f);
          float _1991 = _841 * _1811;
          float _1995 = _1822 * (_1043 + _1777);
          float _1998 = SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(0, _1969,_1970,_1971, _1799,_1802,_1804, _1874) + SKY_VAN_DOT(0, _1969,_1970,_1971) * (_1995 + _mieScatterColor.x * _1991))
            : (((_1970 * _sky_mtx[0][1]) + (_1969 * _sky_mtx[0][0])) + (_1971 * _sky_mtx[0][2])) * (((_1799 * _1874) + _1995) + (_mieScatterColor.x * _1991));
          float _2003 = (((((_1903 * _1856) * _mieScatterColor.x) + ((_1799 * _1876) * _1852)) + ((_1924 + (_1913 * _1852)) * _1822)) + (_1998 * _626)) * _286;
          float _2006 = SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(1, _1969,_1970,_1971, _1799,_1802,_1804, _1874) + SKY_VAN_DOT(1, _1969,_1970,_1971) * (_1995 + _mieScatterColor.y * _1991))
            : (((_1970 * _sky_mtx[1][1]) + (_1969 * _sky_mtx[1][0])) + (_1971 * _sky_mtx[1][2])) * (((_1802 * _1874) + _1995) + (_mieScatterColor.y * _1991));
          float _2011 = (((((_1903 * _1857) * _mieScatterColor.y) + ((_1802 * _1876) * _1853)) + ((_1927 + (_1913 * _1853)) * _1822)) + (_2006 * _627)) * _286;
          float _2014 = SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(2, _1969,_1970,_1971, _1799,_1802,_1804, _1874) + SKY_VAN_DOT(2, _1969,_1970,_1971) * (_1995 + _mieScatterColor.z * _1991))
            : (((_1970 * _sky_mtx[2][1]) + (_1969 * _sky_mtx[2][0])) + (_1971 * _sky_mtx[2][2])) * ((_1995 + (_1804 * _1874)) + (_mieScatterColor.z * _1991));
          float _2019 = (((((_1903 * _1858) * _mieScatterColor.z) + ((_1804 * _1876) * _1854)) + ((_1930 + (_1913 * _1854)) * _1822)) + (_2014 * _628)) * _286;
          float _2020 = _1774.x + _1787;
          float _2022 = _1812 * (_1774.y + _1788);
          float _2023 = _1824 * _2020;
          float _2024 = _1823 + _2022;
          float _2026 = _1828 * _2020;
          float _2028 = _1831 * _2020;
          float _2033 = exp2((_2023 + _2024) * -1.4426950216293335f);
          float _2034 = exp2((_2026 + _2024) * -1.4426950216293335f);
          float _2035 = exp2((_2028 + _2024) * -1.4426950216293335f);
          float _2052 = (_217 * 0.05968310311436653f) * _1874;
          float _2063 = (_1991 * _1897) * (_217 / exp2(log2(_1890 - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _218)) * 1.5f));
          float _2075 = (_1822 * _822) * ((((_233 * 2.0f) * _1043) * _1870) + (((_225 * 64.0f) * _1777) * _1866));
          float _2083 = (((SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(0, _2033,_2034,_2035, _1799,_1802,_1804, _2052*_822) + SKY_VAN_DOT(0, _2033,_2034,_2035) * (_2075 + _2063*_822 * _mieScatterColor.x))
            : (((_2063 * _mieScatterColor.x) + (_1799 * _2052)) * _822 + _2075) * (((_2034 * _sky_mtx[0][1]) + (_2033 * _sky_mtx[0][0])) + (_2035 * _sky_mtx[0][2])))
            + (_1998 * _629)) * _286) + _263;
          float _2091 = (((SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(1, _2033,_2034,_2035, _1799,_1802,_1804, _2052*_822) + SKY_VAN_DOT(1, _2033,_2034,_2035) * (_2075 + _2063*_822 * _mieScatterColor.y))
            : (((_2063 * _mieScatterColor.y) + (_1802 * _2052)) * _822 + _2075) * (((_2034 * _sky_mtx[1][1]) + (_2033 * _sky_mtx[1][0])) + (_2035 * _sky_mtx[1][2])))
            + (_2006 * _630)) * _286) + _262;
          float _2099 = (((SKY_SCATTERING
            ? (SKY_RAY_INSCATTER(2, _2033,_2034,_2035, _1799,_1802,_1804, _2052*_822) + SKY_VAN_DOT(2, _2033,_2034,_2035) * (_2075 + _2063*_822 * _mieScatterColor.z))
            : (((_2063 * _mieScatterColor.z) + (_1804 * _2052)) * _822 + _2075) * (((_2034 * _sky_mtx[2][1]) + (_2033 * _sky_mtx[2][0])) + (_2035 * _sky_mtx[2][2])))
            + (_2014 * _631)) * _286) + _261;
          if (_1777 > 0.0010000000474974513f) {
            float _2103 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * 0.5f;
            float _2104 = _2103 * _2103;
            float _2120 = _1822 * ((_1696 * 0.20000000298023224f) + _1791);
            float _2121 = _2120 + _1813;
            float _2128 = exp2((_1825 + _2121) * -1.4426950216293335f);
            float _2129 = exp2((_1829 + _2121) * -1.4426950216293335f);
            float _2130 = exp2((_1832 + _2121) * -1.4426950216293335f);
            float _2149 = ((((1.0f - _2104) * 3.0f) / ((_2104 + 2.0f) * 2.0f)) * 0.07957746833562851f) * (((_1777 * _822) * 51.20000076293945f) * _286);
            float _2151 = _1866 * _1822;
            float _2152 = _2151 * (_2149 * (_181 / exp2(log2((1.0f - ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * _171)) + _2104) * 1.5f)));
            float _2166 = _2120 + _2022;
            float _2173 = exp2((_2023 + _2166) * -1.4426950216293335f);
            float _2174 = exp2((_2026 + _2166) * -1.4426950216293335f);
            float _2175 = exp2((_2028 + _2166) * -1.4426950216293335f);
            float _2192 = _2151 * (_2149 * (_217 / exp2(log2((1.0f - ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).y) * _215)) + _2104) * 1.5f)));
            _2200 = ((_2192 * (((_2174 * _sky_mtx[0][1]) + (_2173 * _sky_mtx[0][0])) + (_2175 * _sky_mtx[0][2]))) + _2083);
            _2201 = ((_2192 * (((_2174 * _sky_mtx[1][1]) + (_2173 * _sky_mtx[1][0])) + (_2175 * _sky_mtx[1][2]))) + _2091);
            _2202 = ((_2192 * (((_2174 * _sky_mtx[2][1]) + (_2173 * _sky_mtx[2][0])) + (_2175 * _sky_mtx[2][2]))) + _2099);
            _2203 = ((_2152 * (((_2129 * _sky_mtx[0][1]) + (_2128 * _sky_mtx[0][0])) + (_2130 * _sky_mtx[0][2]))) + _2003);
            _2204 = ((_2152 * (((_2129 * _sky_mtx[1][1]) + (_2128 * _sky_mtx[1][0])) + (_2130 * _sky_mtx[1][2]))) + _2011);
            _2205 = ((_2152 * (((_2129 * _sky_mtx[2][1]) + (_2128 * _sky_mtx[2][0])) + (_2130 * _sky_mtx[2][2]))) + _2019);
          } else {
            _2200 = _2083;
            _2201 = _2091;
            _2202 = _2099;
            _2203 = _2003;
            _2204 = _2011;
            _2205 = _2019;
          }
          float _2206 = saturate(float((int)(int(float((uint)_491) * 0.33000001311302185f))) + _129) * _precomputedAmbient7.y;
          _2219 = _279;
          _2220 = select(_486, _488, 0);
          _2221 = _491;
          _2222 = _2200;
          _2223 = _2201;
          _2224 = _2202;
          _2225 = ((((((_precomputedAmbients[48]).x) * _286) * (_1924 + (_1856 * _1811))) + _260) + (_2203 * _2206));
          _2226 = ((((((_precomputedAmbients[48]).y) * _286) * (_1927 + (_1857 * _1811))) + _259) + (_2204 * _2206));
          _2227 = ((((((_precomputedAmbients[48]).z) * _286) * (_1930 + (_1858 * _1811))) + _258) + (_2205 * _2206));
          _2228 = _1787;
          _2229 = _1788;
          _2230 = _1789;
          _2231 = _1790;
          _2232 = _840;
          _2233 = _841;
          _2234 = _1777;
          _2235 = _1043;
          _2236 = ((int)(uint)((int)((((int)(((int)(_278 < _237)) & ((int)(_291 < _493))))) | ((int)(_viewPos.y > _493)))));
          _2237 = ((int)(uint)((int)(exp2((_1791 * -1.4426950216293335f) * _1822) < 0.0010000000474974513f)));
        }
        uint _2238 = _2221 + 1u;
        if ((((int)(((int)((uint)_2238 < (uint)300)) & ((int)(_2236 != 0))))) & ((int)(_2237 == 0))) {
          _249 = _2236;
          _250 = _2235;
          _251 = _2234;
          _252 = _2233;
          _253 = _2232;
          _254 = _2231;
          _255 = _2230;
          _256 = _2229;
          _257 = _2228;
          _258 = _2227;
          _259 = _2226;
          _260 = _2225;
          _261 = _2224;
          _262 = _2223;
          _263 = _2222;
          _264 = _2238;
          _265 = _2220;
          _266 = _2219;
          continue;
        }
        float _2246 = select((_2237 != 0), 1e+06f, _2230);
        if (_130) {
          float _2252 = (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).x) + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
          float _2256 = _151 - ((_148 - (_2252 * _2252)) * _152);
          if (!(_2256 < 0.0f)) {
            _2264 = ((sqrt(_2256) - _147) / (_145 * 2.0f));
          } else {
            _2264 = -1.0f;
          }
          float _2268 = _151 - ((_148 - ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x))) * _152);
          if (!(_2268 < 0.0f)) {
            _2276 = ((sqrt(_2268) - _147) / (_145 * 2.0f));
          } else {
            _2276 = -1.0f;
          }
          if (((int)(_2264 >= 0.0f)) & ((int)(_2276 <= 0.0f))) {
            float _2282 = (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).z) * 4.999999873689376e-05f;
            float _2283 = _2264 * _114;
            float _2285 = _2264 * _116;
            float _2286 = _2283 + _viewPos.x;
            float _2287 = (_2264 * _115) + _viewPos.y;
            float _2288 = _2285 + _viewPos.z;
            float _2296 = (_2286 * _2282) - ((float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w) * 0.0003000000142492354f);
            float _2297 = (_2288 * _2282) - ((float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z) * 0.0003000000142492354f);
            float4 _2301 = __3__36__0__0__g_texCirrus.SampleBias(__0__95__0__0__g_samplerAnisotropicWrap, float2(_2296, _2297), -1.0f, int2(0, 0));
            _36[0] = _2301.x;
            _36[1] = _2301.y;
            _36[2] = _2301.z;
            _36[3] = _2301.w;
            float _2313 = max(0.009999999776482582f, ((3.0f - (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).y)) * 20000.0f));
            float _2316 = (_2283 * _2283) + (_2285 * _2285);
            float _2317 = sqrt(_2316);
            if (!(_2317 > _2313)) {
              _2325 = (1.0f - cos((1.5707963705062866f / _2313) * _2317));
            } else {
              _2325 = 1.0f;
            }
            float _2326 = _2325 * (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).y);
            _36[0] = ((_2301.x * (float4(_cloudCirrusAltitude, _cloudCirrusDensity, _cloudCirrusScale, _cloudCirrusWeightR).w)) * _2326);
            _36[1] = ((_2326 * _2301.y) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).x));
            _36[2] = ((_2326 * _2301.z) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).y));
            float _2355 = ((((sin(mad(_2297, -0.6000000238418579f, (_2296 * 0.800000011920929f)) * 3.0299999713897705f) * 0.25f) * sin(mad(_2297, 0.800000011920929f, (_2296 * 0.6000000238418579f)) * 3.0299999713897705f)) + ((sin(_2296 * 1.5f) * 0.5f) * sin(_2297 * 1.5f))) * 1.6000001430511475f) + 1.5f;
            int _2358 = int(min(max(_2355, 0.0f), 2.0f));
            float _2367 = _36[_2358];
            float _2370 = (((_36[((_2358 + 1) % 3)]) - _2367) * saturate(_2355 - float((int)(_2358)))) + _2367;
            float _2371 = _2287 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
            float _2374 = sqrt((_2371 * _2371) + _2316);
            float _2375 = _2283 / _2374;
            float _2376 = _2371 / _2374;
            float _2377 = _2285 / _2374;
            float _2378 = _2374 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
            if (_2378 > 0.0f) {
              float _2381 = dot(float3(_2375, _2376, _2377), float3(_114, _115, _116));
              float _2390 = min(max(_2378, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
              float _2398 = max(_2390, 0.0f);
              float _2405 = (-0.0f - sqrt((_2398 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _2398)) / (_2398 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
              bool _2406 = (_2381 > _2405);
              if (_2406) {
                _2428 = ((exp2(log2(saturate((_2381 - _2405) / (1.0f - _2405))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
              } else {
                _2428 = ((exp2(log2(saturate((_2405 - _2381) / (_2405 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
              }
              float _2430 = (exp2(log2(saturate((_2390 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
              float4 _2438 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2430, _2428, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_2375, _2376, _2377), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
              if (_2406) {
                _2468 = ((exp2(log2(saturate((_2381 - _2405) / (1.0f - _2405))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
              } else {
                _2468 = ((exp2(log2(saturate((_2405 - _2381) / (_2405 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
              }
              float4 _2474 = __3__36__0__0__g_texPrecomputedLUTMultiGatherAccum.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_2430, _2468, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_2375, _2376, _2377), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
              _2482 = _2438.x;
              _2483 = _2438.y;
              _2484 = _2438.z;
              _2485 = (_2474.x * 0.25f);
              _2486 = (_2474.y * 0.25f);
              _2487 = (_2474.z * 0.25f);
            } else {
              _2482 = 0.0f;
              _2483 = 0.0f;
              _2484 = 0.0f;
              _2485 = 0.0f;
              _2486 = 0.0f;
              _2487 = 0.0f;
            }
            float _2496 = max(_2378, 0.009999999776482582f);
            float _2497 = -0.0f - _2496;
            float _2505 = exp2((_2497 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f);
            float _2506 = exp2((_2497 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f);
            float _2510 = _2286 - _viewPos.x;
            float _2511 = _2288 - _viewPos.z;
            float _2514 = (_2510 * _2510) + (_2511 * _2511);
            float _2515 = sqrt(_2514);
            float _2521 = max(((_2515 * _2515) + -4e+05f), 0.0f) * 9.999999974752427e-07f;
            float _2522 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - _2521;
            float _2525 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
            float _2528 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
            float _2531 = _2287 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
            float _2538 = (((-0.0f - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _2522) + sqrt(_2514 + (_2531 * _2531))) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            if (!(((int)(_2538 < 0.0f)) | ((int)(_2538 > 1.0f)))) {
              float _2561 = ((((float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z) * 0.0010000000474974513f) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
              float _2562 = _2287 - _2522;
              float _2571 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2528 * (_2286 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2528 * _2562) - _2561), (_2528 * (_2288 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
              float _2576 = _2525 / _2528;
              float _2577 = _2576 * _2528;
              float _2579 = _2576 * _2561;
              float _2585 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2525 * _2286) - (_2577 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2562 * _2525) - _2579), ((_2525 * _2288) - (_2577 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
              float _2595 = (4.0f - (saturate(max((_2515 + -2500.0f), 0.0f) * 0.05000000074505806f) * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
              float _2599 = _2577 * 4.355000019073486f;
              float _2606 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2595 * _2286) - (_2599 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2595 * _2562) - (_2579 * 4.355000019073486f)), ((_2595 * _2288) - (_2599 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
              float _2616 = 1.0f - sqrt(saturate((1.0f - _2538) * 1.4285714626312256f));
              float _2634 = (((1.0f - _2585.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * _2606.x) * ((saturate(_2538 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
              _2641 = (saturate(((saturate(saturate(((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + ((_2571.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_2616 * 0.5f), ((_2616 * _2616) * _2616))) * saturate(_2538 * 10.0f)) - _2634) / (1.0f - _2634)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
            } else {
              _2641 = 0.0f;
            }
            if ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f) {
              _2653 = saturate((((1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z)) * _2515) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
            } else {
              _2653 = 1.0f;
            }
            float _2656 = _2287 - _viewPos.y;
            float _2659 = sqrt(_2514 + (_2656 * _2656));
            float _2665 = max(9.999999974752427e-07f, ((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).z) * 0.0024999999441206455f));
            float _2666 = _2665 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z);
            float _2667 = _2665 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w);
            float _2668 = _2665 * _2286;
            float _2669 = _2665 * _2287;
            float _2670 = _2665 * _2288;
            float _2678 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2668 * 0.5127000212669373f) - _2666), (_2669 * 0.5127000212669373f), ((_2670 * 0.5127000212669373f) - _2667)), 0.0f);
            float _2691 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2668 * 6.393881797790527f) - (_2666 * 1.871000051498413f)), (_2669 * 6.393881797790527f), ((_2670 * 6.393881797790527f) - (_2667 * 1.871000051498413f))), 0.0f);
            float _2709 = ((((saturate(_2659 * 0.0078125f) * 2.0f) * (1.0f - _2678.x)) * exp2(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).y) * -0.14426951110363007f) * max(0.0010000000474974513f, (_2496 - (float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).x))))) * (((0.5f - _2691.x) * saturate((_2659 + -300.0f) * 0.0024999999441206455f)) + _2691.x)) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).w);
            float _2710 = _2287 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w);
            float _2712 = (_2710 + _2521) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
            bool _2715 = ((int)(_sunDirection.y > 0.0f)) | ((int)(_sunDirection.y > _moonDirection.y));
            float _2716 = select(_2715, _sunDirection.x, _moonDirection.x);
            float _2717 = select(_2715, _sunDirection.y, _moonDirection.y);
            float _2718 = select(_2715, _sunDirection.z, _moonDirection.z);
            bool _2719 = (_2717 > 0.0f);
            float _2728 = ((0.5f - (float((int)(((int)(uint)(_2719)) - ((int)(uint)((int)(_2717 < 0.0f))))) * 0.5f)) * (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) + _2522;
            if (_2287 < _2522) {
              float _2731 = dot(float3(0.0f, 1.0f, 0.0f), float3(_2716, _2717, _2718));
              float _2737 = select((abs(_2731) < 9.99999993922529e-09f), 1e+08f, ((_2728 - dot(float3(0.0f, 1.0f, 0.0f), float3(_2286, _2287, _2288))) / _2731));
              _2743 = ((_2737 * _2716) + _2286);
              _2744 = _2728;
              _2745 = ((_2737 * _2718) + _2288);
            } else {
              _2743 = _2286;
              _2744 = _2287;
              _2745 = _2288;
            }
            float _2756 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3((((_2743 - _viewPos.x) * 4.999999873689376e-05f) + 0.5f), ((_2744 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)), (((_2745 - _viewPos.z) * 4.999999873689376e-05f) + 0.5f)), 0.0f);
            float _2760 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
            float _2765 = abs(_2717);
            float _2767 = saturate(_2765 * 4.0f);
            float _2769 = (_2767 * _2767) * exp2((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * -1.4426950216293335f) * _2756.x) * _2760);
            float _2775 = ((1.0f - _2769) * saturate((_2710 - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) * 0.10000000149011612f)) + _2769;
            float _2778 = -0.0f - _2760;
            float _2779 = (log2(_2775) * 0.6931471824645996f) / _2778;
            if (((int)((_2653 * _2641) > 0.0010000000474974513f)) & (((int)(((int)(_2712 >= 0.0f)) & ((int)(_2712 <= 1.0f)))))) {
              float _2791 = (_2287 - _2522) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_2791 < 0.0f)) | ((int)(_2791 > 1.0f)))) {
                if (_2765 > 0.0010000000474974513f) {
                  _2804 = min(300.0f, (((_2522 - _2287) + select(_2719, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x), 0.0f)) / _2717));
                } else {
                  _2804 = 300.0f;
                }
                float _2805 = _2804 * 0.20000000298023224f;
                float _2806 = _2805 * _2716;
                float _2807 = _2805 * _2717;
                float _2808 = _2805 * _2718;
                _2816 = 0.0f;
                _2817 = _2805;
                _2818 = _2806;
                _2819 = _2807;
                _2820 = _2808;
                _2821 = ((_2806 * 0.5f) + _2286);
                _2822 = ((_2807 * 0.5f) + _2287);
                _2823 = ((_2808 * 0.5f) + _2288);
                _2824 = 0;
                while(true) {
                  float _2830 = _2821 - _viewPos.x;
                  float _2831 = _2823 - _viewPos.z;
                  float _2834 = (_2830 * _2830) + (_2831 * _2831);
                  float _2835 = sqrt(_2834);
                  float _2842 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_2835 * _2835) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                  float _2847 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
                  float _2849 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
                  float _2854 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _2822;
                  float _2860 = ((sqrt(_2834 + (_2854 * _2854)) - _2842) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                  if (!(((int)(_2860 < 0.0f)) | ((int)(_2860 > 1.0f)))) {
                    float4 _2893 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((((_2821 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - (((_2823 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                    float _2904 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                    float _2905 = _2822 - _2842;
                    float _2916 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_2849 * (_2821 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2849 * _2905) - _2904), (_2849 * (_2823 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                    float _2921 = _2847 / _2849;
                    float _2922 = _2921 * _2849;
                    float _2924 = _2921 * _2904;
                    float _2930 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2847 * _2821) - (_2922 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2847 * _2905) - _2924), ((_2847 * _2823) - (_2922 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                    float _2936 = saturate(max((_2835 + -2500.0f), 0.0f) * 0.05000000074505806f);
                    float _2940 = (4.0f - (_2936 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                    float _2944 = _2922 * 4.355000019073486f;
                    float _2951 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_2940 * _2821) - (_2944 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_2940 * _2905) - (_2924 * 4.355000019073486f)), ((_2940 * _2823) - (_2944 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                    float _2963 = 1.0f - sqrt(saturate((1.0f - _2860) * 1.4285714626312256f));
                    float _2979 = saturate(saturate((((saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f) + -1.5f) + _2893.x) + ((_2916.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_2963 * 0.5f), ((_2963 * _2963) * _2963))) * saturate(_2860 * 10.0f);
                    float _2982 = ((_2951.x * (1.0f - _2930.x)) * ((saturate(_2860 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f)) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x);
                    float _2983 = _2982 * ((_2936 * 0.4000000059604645f) + 0.10000000149011612f);
                    _2995 = (saturate((_2979 - _2982) / (1.0f - _2982)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                    _2996 = (saturate((_2979 - _2983) / (1.0f - _2983)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                  } else {
                    _2995 = 0.0f;
                    _2996 = 0.0f;
                  }
                  float _3010 = (((exp2((((_2816 * -0.007213474716991186f) * _2817) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z))) * (_2995 - _2996)) + _2996) * _2817) + _2816;
                  int _3018 = _2824 + 1;
                  if (!(_3018 == 6)) {
                    _2816 = _3010;
                    _2817 = (_2817 * 1.2999999523162842f);
                    _2818 = (_2818 * 1.2999999523162842f);
                    _2819 = (_2819 * 1.2999999523162842f);
                    _2820 = (_2820 * 1.2999999523162842f);
                    _2821 = (_2821 + _2818);
                    _2822 = (_2822 + _2819);
                    _2823 = (_2823 + _2820);
                    _2824 = _3018;
                    continue;
                  }
                  _3023 = (_3010 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
                  break;
                }
                if (__loop_jump_target == 248) {
                  __loop_jump_target = -1;
                  continue;
                }
                if (__loop_jump_target != -1) {
                  break;
                }
              } else {
                _3023 = 0.0f;
              }
              float _3024 = max(_2779, _3023);
              float _3028 = _2286 - _viewPos.x;
              float _3029 = _2288 - _viewPos.z;
              float _3030 = _3028 * _3028;
              float _3031 = _3029 * _3029;
              float _3033 = sqrt(_3030 + _3031);
              float _3044 = ((_2287 - (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w)) + (max(((_3033 * _3033) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
              if (!(((int)(_3044 < 0.0f)) | ((int)(_3044 > 1.0f)))) {
                float4 _3070 = __3__36__0__0__g_climateTex2.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1))) + (_2286 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1))) + (_2288 / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                float _3072 = _2286 + 50.0f;
                float _3073 = _2287 + 200.0f;
                float _3074 = _3072 - _viewPos.x;
                float _3076 = (_3074 * _3074) + _3031;
                float _3077 = sqrt(_3076);
                float _3082 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_3077 * _3077) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                float _3085 = (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.004000000189989805f;
                float _3088 = (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).y) * 0.00039999998989515007f;
                float _3091 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3073;
                float _3092 = _3091 * _3091;
                float _3097 = ((sqrt(_3076 + _3092) - _3082) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                if (!(((int)(_3097 < 0.0f)) | ((int)(_3097 > 1.0f)))) {
                  float _3121 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                  float _3122 = _3073 - _3082;
                  float _3133 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_3088 * (_3072 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3088 * _3122) - _3121), (_3088 * (_2288 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3138 = _3085 / _3088;
                  float _3139 = _3138 * _3088;
                  float _3141 = _3138 * _3121;
                  float _3147 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_3085 * _3072) - (_3139 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3122 * _3085) - _3141), ((_3085 * _2288) - (_3139 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3153 = saturate(max((_3077 + -2500.0f), 0.0f) * 0.05000000074505806f);
                  float _3157 = (4.0f - (_3153 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                  float _3161 = _3139 * 4.355000019073486f;
                  float _3168 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_3157 * _3072) - (_3161 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3157 * _3122) - (_3141 * 4.355000019073486f)), ((_3157 * _2288) - (_3161 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3178 = 1.0f - sqrt(saturate((1.0f - _3097) * 1.4285714626312256f));
                  float _3200 = ((((1.0f - _3147.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_3153 * 0.4000000059604645f) + 0.10000000149011612f)) * _3168.x) * ((saturate(_3097 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                  _3207 = (saturate(((saturate(saturate(((_3070.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_3133.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_3178 * 0.5f), ((_3178 * _3178) * _3178))) * saturate(_3097 * 10.0f)) - _3200) / (1.0f - _3200)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                } else {
                  _3207 = 0.0f;
                }
                bool _3209 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w) > 9.999999747378752e-06f);
                if (_3209) {
                  _3219 = saturate(((_3077 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
                } else {
                  _3219 = 1.0f;
                }
                float _3221 = _2288 + -50.0f;
                float _3222 = _3221 - _viewPos.z;
                float _3224 = _3030 + (_3222 * _3222);
                float _3225 = sqrt(_3224);
                float _3230 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_3225 * _3225) + -4e+05f), 0.0f) * 9.999999974752427e-07f);
                float _3235 = ((sqrt(_3224 + _3092) - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) - _3230) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x);
                if (!(((int)(_3235 < 0.0f)) | ((int)(_3235 > 1.0f)))) {
                  float _3259 = ((((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).w) * 0.0010000000474974513f) * (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).z)) * _time.x) + (float4(_cloudCirrusWeightG, _cloudCirrusWeightB, _cloudFlow, _cloudSeed).w);
                  float _3260 = _3073 - _3230;
                  float _3271 = __3__36__0__0__g_texCloudBase.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3((_3088 * (_2286 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3260 * _3088) - _3259), (_3088 * (_3221 - (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3276 = _3085 / _3088;
                  float _3277 = _3276 * _3088;
                  float _3279 = _3276 * _3259;
                  float _3285 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_3085 * _2286) - (_3277 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3260 * _3085) - _3279), ((_3085 * _3221) - (_3277 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3291 = saturate(max((_3225 + -2500.0f), 0.0f) * 0.05000000074505806f);
                  float _3295 = (4.0f - (_3291 * 3.0f)) * ((float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).y) * 0.0018840000266209245f);
                  float _3299 = _3277 * 4.355000019073486f;
                  float _3306 = __3__36__0__0__g_texCloudDetail.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float3(((_3295 * _2286) - (_3299 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).z))), ((_3295 * _3260) - (_3279 * 4.355000019073486f)), ((_3295 * _3221) - (_3299 * (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).w)))), 0.0f);
                  float _3316 = 1.0f - sqrt(saturate((1.0f - _3235) * 1.4285714626312256f));
                  float _3338 = ((((1.0f - _3285.x) * (float4(_cloudDetailRatio, _cloudDetailScale, _cloudMultiRatio, _cloudBeerPowderRatio).x)) * ((_3291 * 0.4000000059604645f) + 0.10000000149011612f)) * _3306.x) * ((saturate(_3235 * 4.0f) * 0.800000011920929f) + 0.20000000298023224f);
                  _3345 = (saturate(((saturate(saturate(((_3070.x + -1.5f) + (saturate(((float4(_heightFogBaseline, _heightFogFalloff, _heightFogScale, _cloudBaseDensity).w) * 0.5f) + 0.17499999701976776f) * 3.0f)) + ((_3271.x + -0.5f) * (((float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).x) * 10.0f) + 1.0f))) - max((_3316 * 0.5f), ((_3316 * _3316) * _3316))) * saturate(_3235 * 10.0f)) - _3338) / (1.0f - _3338)) * (float4(_cloudBaseContrast, _cloudBaseScale, _cloudAlpha, _cloudScrollMultiplier).z));
                } else {
                  _3345 = 0.0f;
                }
                if (_3209) {
                  _3355 = saturate(((_3225 * (1.0f - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z))) / max(9.999999747378752e-06f, (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).w))) + (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).z));
                } else {
                  _3355 = 1.0f;
                }
                _3363 = _3024;
                _3364 = ((((_3355 * _3345) + (_3219 * _3207)) * 20.0f) * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z));
              } else {
                _3363 = _3024;
                _3364 = 0.0f;
              }
            } else {
              _3363 = _2779;
              _3364 = ((log2(max(_2775, 0.5f)) * 0.6931471824645996f) / _2778);
            }
            float _3365 = dot(float3(_2375, _2376, _2377), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
            float _3370 = min(max(_2496, 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
            float _3378 = max(_3370, 0.0f);
            float _3386 = (-0.0f - sqrt((_3378 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _3378)) / (_3378 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            if (_3365 > _3386) {
              _3409 = ((exp2(log2(saturate((_3365 - _3386) / (1.0f - _3386))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _3409 = ((exp2(log2(saturate((_3386 - _3365) / (_3386 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _3411 = (exp2(log2(saturate((_3370 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
            float2 _3414 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_3411, _3409), 0.0f);
            float _3417 = dot(float3(_2375, _2376, _2377), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
            if (_3417 > _3386) {
              _3440 = ((exp2(log2(saturate((_3417 - _3386) / (1.0f - _3386))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _3440 = ((exp2(log2(saturate((_3386 - _3417) / (_3386 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float2 _3441 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_3411, _3440), 0.0f);
            float _3452 = ((_2505 + _2232) * 12.5f) + _2228;
            float _3453 = ((_2506 + _2233) * 12.5f) + _2229;
            float _3454 = ((_2370 + _2234) * 12.5f) + _2246;
            float _3455 = ((_2709 + _2235) * 12.5f) + _2231;
            float _3456 = _3455 + _3454;
            float _3457 = _3414.x + _3452;
            float _3464 = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255)));
            float _3467 = float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255)));
            float _3469 = float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255)));
            float _3476 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 1.9999999494757503e-05f;
            float _3477 = _3476 * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f);
            float _3487 = (float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
            float _3488 = _3487 * (_3363 + _3456);
            float _3489 = (_3464 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
            float _3491 = _3488 + (_3477 * (_3414.y + _3453));
            float _3493 = (_3467 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
            float _3496 = (_3469 * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
            float _3502 = exp2(((_3489 * _3457) + _3491) * -1.4426950216293335f);
            float _3503 = exp2(((_3493 * _3457) + _3491) * -1.4426950216293335f);
            float _3504 = exp2(((_3496 * _3457) + _3491) * -1.4426950216293335f);
            float _3517 = ((_3503 * _sky_mtx[0][1]) + (_3502 * _sky_mtx[0][0])) + (_3504 * _sky_mtx[0][2]);
            float _3518 = ((_3503 * _sky_mtx[1][1]) + (_3502 * _sky_mtx[1][0])) + (_3504 * _sky_mtx[1][2]);
            float _3519 = ((_3503 * _sky_mtx[2][1]) + (_3502 * _sky_mtx[2][0])) + (_3504 * _sky_mtx[2][2]);
            float _3520 = _3517 * _2506;
            float _3521 = _3518 * _2506;
            float _3522 = _3519 * _2506;
            float _3523 = _3487 * (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z);
            float _3530 = exp2(log2(1.0f - exp2((_3523 * -14.426950454711914f) * _2370)) * 1.25f);
            float _3534 = 1.0f - exp2((_3523 * -288.53900146484375f) * _2709);
            float _3535 = _3534 * _2709;
            float _3539 = _181 * 0.05968310311436653f;
            float _3544 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
            float _3550 = _3544 + 1.0f;
            float _3557 = (((1.0f - _3544) * 3.0f) / ((_3544 + 2.0f) * 2.0f)) * 0.07957746833562851f;
            float _3563 = (_3557 * _3476) * (_181 / exp2(log2(_3550 - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _183)) * 1.5f));
            float _3572 = _3530 * ((_191 * 64.0f) * _2370);
            float _3580 = _209 * 2.0f;
            float _3581 = _volumeFogScatterColor.x * (_3535 * _3517);
            float _3583 = _volumeFogScatterColor.y * (_3535 * _3518);
            float _3585 = _volumeFogScatterColor.z * (_3535 * _3519);
            float _3593 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y) * 0.0004999999655410647f;
            float _3597 = _209 * 50.0f;
            float _3618 = (_3487 * (_3364 + _3456)) + (_3477 * _3453);
            float _3627 = exp2(((_3489 * _3452) + _3618) * -1.4426950216293335f);
            float _3628 = exp2(((_3493 * _3452) + _3618) * -1.4426950216293335f);
            float _3629 = exp2(((_3496 * _3452) + _3618) * -1.4426950216293335f);
            float _3642 = ((_3628 * _sky_mtx[0][1]) + (_3627 * _sky_mtx[0][0])) + (_3629 * _sky_mtx[0][2]);
            float _3643 = ((_3628 * _sky_mtx[1][1]) + (_3627 * _sky_mtx[1][0])) + (_3629 * _sky_mtx[1][2]);
            float _3644 = ((_3628 * _sky_mtx[2][1]) + (_3627 * _sky_mtx[2][0])) + (_3629 * _sky_mtx[2][2]);
            float _3649 = _2506 * _3476;
            float _3653 = _3487 * (_2709 + _2370);
            float _3655 = _3642 * ((_mieScatterColor.x * _3649) + _3653);
            float _3661 = _2505 * 4.901960892311763e-06f;
            float _3662 = _3661 * _3464;
            float _3666 = _3643 * ((_mieScatterColor.y * _3649) + _3653);
            float _3672 = _3661 * _3467;
            float _3676 = _3644 * ((_mieScatterColor.z * _3649) + _3653);
            float _3682 = _3661 * _3469;
            float _3685 = _3441.x + _3452;
            float _3689 = _3488 + (_3477 * (_3441.y + _3453));
            float _3698 = exp2(((_3489 * _3685) + _3689) * -1.4426950216293335f);
            float _3699 = exp2(((_3493 * _3685) + _3689) * -1.4426950216293335f);
            float _3700 = exp2(((_3496 * _3685) + _3689) * -1.4426950216293335f);
            float _3713 = ((_3699 * _sky_mtx[0][1]) + (_3698 * _sky_mtx[0][0])) + (_3700 * _sky_mtx[0][2]);
            float _3714 = ((_3699 * _sky_mtx[1][1]) + (_3698 * _sky_mtx[1][0])) + (_3700 * _sky_mtx[1][2]);
            float _3715 = ((_3699 * _sky_mtx[2][1]) + (_3698 * _sky_mtx[2][0])) + (_3700 * _sky_mtx[2][2]);
            float _3716 = _217 * 0.05968310311436653f;
            float _3727 = (_3649 * _3557) * (_217 / exp2(log2(_3550 - ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * _218)) * 1.5f));
            float _3738 = ((((_233 * 2.0f) * _2709) * _3534) + (((_225 * 64.0f) * _2370) * _3530)) * _3487;
            _3776 = (((_3662 * ((_3713 * _3716) + (_3642 * _2485))) + _2222) + (((((_3727 * _mieScatterColor.x) + _3738) * _3713) + (_3655 * _2485)) * 25.0f));
            _3777 = (((_3672 * ((_3714 * _3716) + (_3643 * _2486))) + _2223) + (((((_3727 * _mieScatterColor.y) + _3738) * _3714) + (_3666 * _2486)) * 25.0f));
            _3778 = (((_3682 * ((_3715 * _3716) + (_3644 * _2487))) + _2224) + (((((_3727 * _mieScatterColor.z) + _3738) * _3715) + (_3676 * _2487)) * 25.0f));
            _3779 = (((((_precomputedAmbients[48]).x) * ((_3581 * _3597) + (_3520 * _3593))) + _2225) + (((_3662 * ((_3642 * _2482) + (_3517 * _3539))) + (((((_3563 * _3520) * _mieScatterColor.x) + (((_3581 * _3580) + (_3572 * _3517)) * _3487)) + (_3655 * _2482)) * 25.0f)) * _precomputedAmbient7.y));
            _3780 = (((((_precomputedAmbients[48]).y) * ((_3583 * _3597) + (_3521 * _3593))) + _2226) + (((_3672 * ((_3643 * _2483) + (_3518 * _3539))) + (((((_3563 * _3521) * _mieScatterColor.y) + (((_3583 * _3580) + (_3572 * _3518)) * _3487)) + (_3666 * _2483)) * 25.0f)) * _precomputedAmbient7.y));
            _3781 = (((((_precomputedAmbients[48]).z) * ((_3585 * _3597) + (_3522 * _3593))) + _2227) + (((_3682 * ((_3644 * _2484) + (_3519 * _3539))) + (((((_3563 * _3522) * _mieScatterColor.z) + (((_3585 * _3580) + (_3572 * _3519)) * _3487)) + (_3676 * _2484)) * 25.0f)) * _precomputedAmbient7.y));
            _3782 = _3452;
            _3783 = _3453;
            _3784 = _3454;
            _3785 = _3455;
            _3786 = _290;
            _3787 = _291;
            _3788 = _292;
            _3789 = _278;
          } else {
            _3776 = _2222;
            _3777 = _2223;
            _3778 = _2224;
            _3779 = _2225;
            _3780 = _2226;
            _3781 = _2227;
            _3782 = _2228;
            _3783 = _2229;
            _3784 = _2246;
            _3785 = _2231;
            _3786 = _290;
            _3787 = _291;
            _3788 = _292;
            _3789 = _278;
          }
          __defer_164_3775 = true;
        } else {
          _3791 = _278;
          _3792 = _290;
          _3793 = _291;
          _3794 = _292;
          _3795 = _2228;
          _3796 = _2229;
          _3797 = _2246;
          _3798 = _2231;
          _3799 = _2225;
          _3800 = _2226;
          _3801 = _2227;
          _3802 = _2222;
          _3803 = _2223;
          _3804 = _2224;
          if (_236 < _113) {
            float _3810 = _viewPos.x + (_114 * _113);
            float _3811 = _viewPos.y + (_115 * _113);
            float _3812 = _viewPos.z + (_116 * _113);
            float _3819 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3793;
            float _3825 = sqrt(((_3794 * _3794) + (_3792 * _3792)) + (_3819 * _3819));
            float _3826 = _3792 / _3825;
            float _3827 = _3819 / _3825;
            float _3828 = _3794 / _3825;
            float _3831 = dot(float3(_3826, _3827, _3828), float3(_114, _115, _116));
            float _3833 = dot(float3(_114, _115, _116), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
            float _3835 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f;
            float _3837 = min(max(max((_3825 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3835);
            float _3839 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f;
            float _3845 = max(_3837, 0.0f);
            float _3846 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f;
            float _3852 = (-0.0f - sqrt((_3845 + _3846) * _3845)) / (_3845 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            bool _3853 = (_3831 > _3852);
            if (_3853) {
              _3875 = ((exp2(log2(saturate((_3831 - _3852) / (1.0f - _3852))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _3875 = ((exp2(log2(saturate((_3852 - _3831) / (_3852 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _3877 = (exp2(log2(saturate((_3837 + -16.0f) / _3839)) * 0.5f) * 0.96875f) + 0.015625f;
            float _3882 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3826, _3827, _3828), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
            float4 _3885 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _3875, _3882), 0.0f);
            float4 _3890 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _3875, _3882), 0.0f);
            float _3897 = (_3833 * _3833) + 1.0f;
            float _3898 = _3897 * 0.05968310311436653f;
            float _3902 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
            float _3908 = _3902 + 1.0f;
            float _3909 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * 2.0f;
            float _3916 = (((1.0f - _3902) * 3.0f) / ((_3902 + 2.0f) * 2.0f)) * 0.07957746833562851f;
            float _3917 = (_3897 / exp2(log2(_3908 - (_3909 * _3833)) * 1.5f)) * _3916;
            float4 _3922 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _3875, _3882), 0.0f);
            float4 _3927 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _3875, _3882), 0.0f);
            float _3931 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3811;
            float _3937 = sqrt(((_3812 * _3812) + (_3810 * _3810)) + (_3931 * _3931));
            float _3938 = _3810 / _3937;
            float _3939 = _3931 / _3937;
            float _3940 = _3812 / _3937;
            float _3943 = dot(float3(_3938, _3939, _3940), float3(_114, _115, _116));
            float _3946 = min(max(max((_3937 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3835);
            float _3953 = max(_3946, 0.0f);
            float _3959 = (-0.0f - sqrt((_3953 + _3846) * _3953)) / (_3953 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
            bool _3960 = (_3943 > _3959);
            if (_3960) {
              _3982 = ((exp2(log2(saturate((_3943 - _3959) / (1.0f - _3959))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _3982 = ((exp2(log2(saturate((_3959 - _3943) / (_3959 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _3984 = (exp2(log2(saturate((_3946 + -16.0f) / _3839)) * 0.5f) * 0.96875f) + 0.015625f;
            float _3989 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3938, _3939, _3940), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
            float4 _3990 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _3982, _3989), 0.0f);
            float4 _3994 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _3982, _3989), 0.0f);
            float4 _4004 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _3982, _3989), 0.0f);
            float4 _4008 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _3982, _3989), 0.0f);
            float _4021 = dot(float3(_3792, _3819, _3794), float3(_114, _115, _116));
            float _4022 = _4021 / _3825;
            float _4023 = _3792 - _3810;
            float _4024 = _3793 - _3811;
            float _4025 = _3794 - _3812;
            float _4031 = sqrt(((_4024 * _4024) + (_4023 * _4023)) + (_4025 * _4025));
            float _4038 = sqrt((0.5f / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * _3825);
            float _4039 = sqrt((0.5f / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * _3825);
            float _4041 = (_4031 + _4021) / _3825;
            float _4042 = _4038 * _4022;
            float _4043 = _4041 * _4038;
            float _4044 = _4039 * _4022;
            float _4045 = _4041 * _4039;
            float _4066 = float((int)(((int)(uint)((int)(_4042 > 0.0f))) - ((int)(uint)((int)(_4042 < 0.0f)))));
            float _4067 = float((int)(((int)(uint)((int)(_4043 > 0.0f))) - ((int)(uint)((int)(_4043 < 0.0f)))));
            float _4068 = float((int)(((int)(uint)((int)(_4044 > 0.0f))) - ((int)(uint)((int)(_4044 < 0.0f)))));
            float _4069 = float((int)(((int)(uint)((int)(_4045 > 0.0f))) - ((int)(uint)((int)(_4045 < 0.0f)))));
            float _4070 = _4042 * _4042;
            float _4071 = _4044 * _4044;
            bool _4072 = (_4067 > _4066);
            if (_4072) {
              _4077 = exp2(_4070 * 1.4426950216293335f);
            } else {
              _4077 = 0.0f;
            }
            bool _4078 = (_4069 > _4068);
            if (_4078) {
              _4083 = exp2(_4071 * 1.4426950216293335f);
            } else {
              _4083 = 0.0f;
            }
            float _4114 = -0.0f - _4031;
            float _4120 = ((_4031 / (_3825 * 2.0f)) + _4022) * 1.4426950216293335f;
            float _4127 = _3825 * 6.283100128173828f;
            float _4132 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) - _3825;
            float _4139 = exp2((_4132 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f) * sqrt(_4127 * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z));
            float _4140 = dot(float2((_4066 / (sqrt((_4070 * 1.5199999809265137f) + 4.0f) + (abs(_4042) * 2.3192999362945557f))), (exp2(_4120 * (_4114 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (_4067 / (sqrt(((_4043 * _4043) * 1.5199999809265137f) + 4.0f) + (abs(_4043) * 2.3192999362945557f))))), float2(1.0f, -1.0f));
            float _4141 = dot(float2((_4068 / (sqrt((_4071 * 1.5199999809265137f) + 4.0f) + (abs(_4044) * 2.3192999362945557f))), (exp2(_4120 * (_4114 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x))) * (_4069 / (sqrt(((_4045 * _4045) * 1.5199999809265137f) + 4.0f) + (abs(_4045) * 2.3192999362945557f))))), float2(1.0f, -1.0f));
            float _4144 = (_4140 + _4077) * _4139;
            float _4164 = (((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((sqrt((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x) * _4127) * 1.9999999494757503e-05f) * exp2((_4132 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f));
            float _4165 = _4164 * (_4141 + _4083);
            float _4171 = (float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
            float _4174 = (float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
            float _4177 = (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
            float _4183 = exp2(((_4171 * _4144) + _4165) * -1.4426950216293335f);
            float _4184 = exp2(((_4174 * _4144) + _4165) * -1.4426950216293335f);
            float _4185 = exp2(((_4177 * _4144) + _4165) * -1.4426950216293335f);
            float _4209 = dot(float3(_114, _115, _116), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
            if (_3853) {
              _4231 = ((exp2(log2(saturate((_3831 - _3852) / (1.0f - _3852))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _4231 = ((exp2(log2(saturate((_3852 - _3831) / (_3852 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _4236 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3826, _3827, _3828), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
            float4 _4237 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _4231, _4236), 0.0f);
            float4 _4241 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _4231, _4236), 0.0f);
            float _4246 = (_4209 * _4209) + 1.0f;
            float _4247 = _4246 * 0.05968310311436653f;
            float _4257 = (_4246 / exp2(log2(_3908 - (_3909 * _4209)) * 1.5f)) * _3916;
            float4 _4261 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _4231, _4236), 0.0f);
            float4 _4265 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _4231, _4236), 0.0f);
            if (_3960) {
              _4291 = ((exp2(log2(saturate((_3943 - _3959) / (1.0f - _3959))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
            } else {
              _4291 = ((exp2(log2(saturate((_3959 - _3943) / (_3959 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
            }
            float _4296 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3938, _3939, _3940), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
            float4 _4297 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _4291, _4296), 0.0f);
            float4 _4301 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _4291, _4296), 0.0f);
            float4 _4311 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _4291, _4296), 0.0f);
            float4 _4315 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _4291, _4296), 0.0f);
            if (_4072) {
              _4332 = exp2(_4070 * 1.4426950216293335f);
            } else {
              _4332 = 0.0f;
            }
            if (_4078) {
              _4337 = exp2(_4071 * 1.4426950216293335f);
            } else {
              _4337 = 0.0f;
            }
            float _4340 = (_4332 + _4140) * _4139;
            float _4341 = _4164 * (_4337 + _4141);
            _4373 = _3791;
            _4374 = _3795;
            _4375 = _3796;
            _4376 = _3797;
            _4377 = _3798;
            _4378 = _3799;
            _4379 = _3800;
            _4380 = _3801;
            _4381 = _3802;
            _4382 = _3803;
            _4383 = _3804;
            _4384 = _4183;
            _4385 = _4184;
            _4386 = _4185;
            _4387 = max(0.0f, (((((_3917 * _3890.x) + (_3885.x * _3898)) + _3922.x) + _3927.x) - (_4183 * ((((_3994.x * _3917) + (_3990.x * _3898)) + _4004.x) + _4008.x))));
            _4388 = max(0.0f, (((((_3917 * _3890.y) + (_3885.y * _3898)) + _3922.y) + _3927.y) - (_4184 * ((((_3994.y * _3917) + (_3990.y * _3898)) + _4004.y) + _4008.y))));
            _4389 = max(0.0f, (((((_3917 * _3890.z) + (_3885.z * _3898)) + _3922.z) + _3927.z) - (_4185 * ((((_3994.z * _3917) + (_3990.z * _3898)) + _4004.z) + _4008.z))));
            _4390 = max(0.0f, (((((_4257 * _4241.x) + (_4237.x * _4247)) + _4261.x) + _4265.x) - (exp2((_4341 + (_4340 * _4171)) * -1.4426950216293335f) * ((((_4301.x * _4257) + (_4297.x * _4247)) + _4311.x) + _4315.x))));
            _4391 = max(0.0f, (((((_4257 * _4241.y) + (_4237.y * _4247)) + _4261.y) + _4265.y) - (exp2((_4341 + (_4340 * _4174)) * -1.4426950216293335f) * ((((_4301.y * _4257) + (_4297.y * _4247)) + _4311.y) + _4315.y))));
            _4392 = max(0.0f, (((((_4257 * _4241.z) + (_4237.z * _4247)) + _4261.z) + _4265.z) - (exp2((_4341 + (_4340 * _4177)) * -1.4426950216293335f) * ((((_4301.z * _4257) + (_4297.z * _4247)) + _4311.z) + _4315.z))));
          } else {
            _4373 = _3791;
            _4374 = _3795;
            _4375 = _3796;
            _4376 = _3797;
            _4377 = _3798;
            _4378 = _3799;
            _4379 = _3800;
            _4380 = _3801;
            _4381 = _3802;
            _4382 = _3803;
            _4383 = _3804;
            _4384 = 1.0f;
            _4385 = 1.0f;
            _4386 = 1.0f;
            _4387 = 0.0f;
            _4388 = 0.0f;
            _4389 = 0.0f;
            _4390 = 0.0f;
            _4391 = 0.0f;
            _4392 = 0.0f;
          }
        }
        break;
      }
    } else {
      _3776 = 0.0f;
      _3777 = 0.0f;
      _3778 = 0.0f;
      _3779 = 0.0f;
      _3780 = 0.0f;
      _3781 = 0.0f;
      _3782 = 0.0f;
      _3783 = 0.0f;
      _3784 = 0.0f;
      _3785 = 0.0f;
      _3786 = _viewPos.x;
      _3787 = _viewPos.y;
      _3788 = _viewPos.z;
      _3789 = 0.0f;
      __defer_164_3775 = true;
    }
    if (__defer_164_3775) {
      if (!_130) {
        _3791 = _3789;
        _3792 = _3786;
        _3793 = _3787;
        _3794 = _3788;
        _3795 = _3782;
        _3796 = _3783;
        _3797 = _3784;
        _3798 = _3785;
        _3799 = _3779;
        _3800 = _3780;
        _3801 = _3781;
        _3802 = _3776;
        _3803 = _3777;
        _3804 = _3778;
        if (_236 < _113) {
          float _3810 = _viewPos.x + (_114 * _113);
          float _3811 = _viewPos.y + (_115 * _113);
          float _3812 = _viewPos.z + (_116 * _113);
          float _3819 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3793;
          float _3825 = sqrt(((_3794 * _3794) + (_3792 * _3792)) + (_3819 * _3819));
          float _3826 = _3792 / _3825;
          float _3827 = _3819 / _3825;
          float _3828 = _3794 / _3825;
          float _3831 = dot(float3(_3826, _3827, _3828), float3(_114, _115, _116));
          float _3833 = dot(float3(_114, _115, _116), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
          float _3835 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f;
          float _3837 = min(max(max((_3825 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3835);
          float _3839 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f;
          float _3845 = max(_3837, 0.0f);
          float _3846 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f;
          float _3852 = (-0.0f - sqrt((_3845 + _3846) * _3845)) / (_3845 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
          bool _3853 = (_3831 > _3852);
          if (_3853) {
            _3875 = ((exp2(log2(saturate((_3831 - _3852) / (1.0f - _3852))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _3875 = ((exp2(log2(saturate((_3852 - _3831) / (_3852 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _3877 = (exp2(log2(saturate((_3837 + -16.0f) / _3839)) * 0.5f) * 0.96875f) + 0.015625f;
          float _3882 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3826, _3827, _3828), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
          float4 _3885 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _3875, _3882), 0.0f);
          float4 _3890 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _3875, _3882), 0.0f);
          float _3897 = (_3833 * _3833) + 1.0f;
          float _3898 = _3897 * 0.05968310311436653f;
          float _3902 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
          float _3908 = _3902 + 1.0f;
          float _3909 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * 2.0f;
          float _3916 = (((1.0f - _3902) * 3.0f) / ((_3902 + 2.0f) * 2.0f)) * 0.07957746833562851f;
          float _3917 = (_3897 / exp2(log2(_3908 - (_3909 * _3833)) * 1.5f)) * _3916;
          float4 _3922 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _3875, _3882), 0.0f);
          float4 _3927 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _3875, _3882), 0.0f);
          float _3931 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _3811;
          float _3937 = sqrt(((_3812 * _3812) + (_3810 * _3810)) + (_3931 * _3931));
          float _3938 = _3810 / _3937;
          float _3939 = _3931 / _3937;
          float _3940 = _3812 / _3937;
          float _3943 = dot(float3(_3938, _3939, _3940), float3(_114, _115, _116));
          float _3946 = min(max(max((_3937 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _3835);
          float _3953 = max(_3946, 0.0f);
          float _3959 = (-0.0f - sqrt((_3953 + _3846) * _3953)) / (_3953 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
          bool _3960 = (_3943 > _3959);
          if (_3960) {
            _3982 = ((exp2(log2(saturate((_3943 - _3959) / (1.0f - _3959))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _3982 = ((exp2(log2(saturate((_3959 - _3943) / (_3959 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _3984 = (exp2(log2(saturate((_3946 + -16.0f) / _3839)) * 0.5f) * 0.96875f) + 0.015625f;
          float _3989 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3938, _3939, _3940), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
          float4 _3990 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _3982, _3989), 0.0f);
          float4 _3994 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _3982, _3989), 0.0f);
          float4 _4004 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _3982, _3989), 0.0f);
          float4 _4008 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _3982, _3989), 0.0f);
          float _4021 = dot(float3(_3792, _3819, _3794), float3(_114, _115, _116));
          float _4022 = _4021 / _3825;
          float _4023 = _3792 - _3810;
          float _4024 = _3793 - _3811;
          float _4025 = _3794 - _3812;
          float _4031 = sqrt(((_4024 * _4024) + (_4023 * _4023)) + (_4025 * _4025));
          float _4038 = sqrt((0.5f / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * _3825);
          float _4039 = sqrt((0.5f / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * _3825);
          float _4041 = (_4031 + _4021) / _3825;
          float _4042 = _4038 * _4022;
          float _4043 = _4041 * _4038;
          float _4044 = _4039 * _4022;
          float _4045 = _4041 * _4039;
          float _4066 = float((int)(((int)(uint)((int)(_4042 > 0.0f))) - ((int)(uint)((int)(_4042 < 0.0f)))));
          float _4067 = float((int)(((int)(uint)((int)(_4043 > 0.0f))) - ((int)(uint)((int)(_4043 < 0.0f)))));
          float _4068 = float((int)(((int)(uint)((int)(_4044 > 0.0f))) - ((int)(uint)((int)(_4044 < 0.0f)))));
          float _4069 = float((int)(((int)(uint)((int)(_4045 > 0.0f))) - ((int)(uint)((int)(_4045 < 0.0f)))));
          float _4070 = _4042 * _4042;
          float _4071 = _4044 * _4044;
          bool _4072 = (_4067 > _4066);
          if (_4072) {
            _4077 = exp2(_4070 * 1.4426950216293335f);
          } else {
            _4077 = 0.0f;
          }
          bool _4078 = (_4069 > _4068);
          if (_4078) {
            _4083 = exp2(_4071 * 1.4426950216293335f);
          } else {
            _4083 = 0.0f;
          }
          float _4114 = -0.0f - _4031;
          float _4120 = ((_4031 / (_3825 * 2.0f)) + _4022) * 1.4426950216293335f;
          float _4127 = _3825 * 6.283100128173828f;
          float _4132 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) - _3825;
          float _4139 = exp2((_4132 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f) * sqrt(_4127 * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z));
          float _4140 = dot(float2((_4066 / (sqrt((_4070 * 1.5199999809265137f) + 4.0f) + (abs(_4042) * 2.3192999362945557f))), (exp2(_4120 * (_4114 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (_4067 / (sqrt(((_4043 * _4043) * 1.5199999809265137f) + 4.0f) + (abs(_4043) * 2.3192999362945557f))))), float2(1.0f, -1.0f));
          float _4141 = dot(float2((_4068 / (sqrt((_4071 * 1.5199999809265137f) + 4.0f) + (abs(_4044) * 2.3192999362945557f))), (exp2(_4120 * (_4114 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x))) * (_4069 / (sqrt(((_4045 * _4045) * 1.5199999809265137f) + 4.0f) + (abs(_4045) * 2.3192999362945557f))))), float2(1.0f, -1.0f));
          float _4144 = (_4140 + _4077) * _4139;
          float _4164 = (((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((sqrt((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x) * _4127) * 1.9999999494757503e-05f) * exp2((_4132 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f));
          float _4165 = _4164 * (_4141 + _4083);
          float _4171 = (float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
          float _4174 = (float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
          float _4177 = (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
          float _4183 = exp2(((_4171 * _4144) + _4165) * -1.4426950216293335f);
          float _4184 = exp2(((_4174 * _4144) + _4165) * -1.4426950216293335f);
          float _4185 = exp2(((_4177 * _4144) + _4165) * -1.4426950216293335f);
          float _4209 = dot(float3(_114, _115, _116), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
          if (_3853) {
            _4231 = ((exp2(log2(saturate((_3831 - _3852) / (1.0f - _3852))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _4231 = ((exp2(log2(saturate((_3852 - _3831) / (_3852 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _4236 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3826, _3827, _3828), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
          float4 _4237 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _4231, _4236), 0.0f);
          float4 _4241 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _4231, _4236), 0.0f);
          float _4246 = (_4209 * _4209) + 1.0f;
          float _4247 = _4246 * 0.05968310311436653f;
          float _4257 = (_4246 / exp2(log2(_3908 - (_3909 * _4209)) * 1.5f)) * _3916;
          float4 _4261 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _4231, _4236), 0.0f);
          float4 _4265 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3877, _4231, _4236), 0.0f);
          if (_3960) {
            _4291 = ((exp2(log2(saturate((_3943 - _3959) / (1.0f - _3959))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
          } else {
            _4291 = ((exp2(log2(saturate((_3959 - _3943) / (_3959 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
          }
          float _4296 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_3938, _3939, _3940), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
          float4 _4297 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _4291, _4296), 0.0f);
          float4 _4301 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _4291, _4296), 0.0f);
          float4 _4311 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _4291, _4296), 0.0f);
          float4 _4315 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_3984, _4291, _4296), 0.0f);
          if (_4072) {
            _4332 = exp2(_4070 * 1.4426950216293335f);
          } else {
            _4332 = 0.0f;
          }
          if (_4078) {
            _4337 = exp2(_4071 * 1.4426950216293335f);
          } else {
            _4337 = 0.0f;
          }
          float _4340 = (_4332 + _4140) * _4139;
          float _4341 = _4164 * (_4337 + _4141);
          _4373 = _3791;
          _4374 = _3795;
          _4375 = _3796;
          _4376 = _3797;
          _4377 = _3798;
          _4378 = _3799;
          _4379 = _3800;
          _4380 = _3801;
          _4381 = _3802;
          _4382 = _3803;
          _4383 = _3804;
          _4384 = _4183;
          _4385 = _4184;
          _4386 = _4185;
          _4387 = max(0.0f, (((((_3917 * _3890.x) + (_3885.x * _3898)) + _3922.x) + _3927.x) - (_4183 * ((((_3994.x * _3917) + (_3990.x * _3898)) + _4004.x) + _4008.x))));
          _4388 = max(0.0f, (((((_3917 * _3890.y) + (_3885.y * _3898)) + _3922.y) + _3927.y) - (_4184 * ((((_3994.y * _3917) + (_3990.y * _3898)) + _4004.y) + _4008.y))));
          _4389 = max(0.0f, (((((_3917 * _3890.z) + (_3885.z * _3898)) + _3922.z) + _3927.z) - (_4185 * ((((_3994.z * _3917) + (_3990.z * _3898)) + _4004.z) + _4008.z))));
          _4390 = max(0.0f, (((((_4257 * _4241.x) + (_4237.x * _4247)) + _4261.x) + _4265.x) - (exp2((_4341 + (_4340 * _4171)) * -1.4426950216293335f) * ((((_4301.x * _4257) + (_4297.x * _4247)) + _4311.x) + _4315.x))));
          _4391 = max(0.0f, (((((_4257 * _4241.y) + (_4237.y * _4247)) + _4261.y) + _4265.y) - (exp2((_4341 + (_4340 * _4174)) * -1.4426950216293335f) * ((((_4301.y * _4257) + (_4297.y * _4247)) + _4311.y) + _4315.y))));
          _4392 = max(0.0f, (((((_4257 * _4241.z) + (_4237.z * _4247)) + _4261.z) + _4265.z) - (exp2((_4341 + (_4340 * _4177)) * -1.4426950216293335f) * ((((_4301.z * _4257) + (_4297.z * _4247)) + _4311.z) + _4315.z))));
        } else {
          _4373 = _3791;
          _4374 = _3795;
          _4375 = _3796;
          _4376 = _3797;
          _4377 = _3798;
          _4378 = _3799;
          _4379 = _3800;
          _4380 = _3801;
          _4381 = _3802;
          _4382 = _3803;
          _4383 = _3804;
          _4384 = 1.0f;
          _4385 = 1.0f;
          _4386 = 1.0f;
          _4387 = 0.0f;
          _4388 = 0.0f;
          _4389 = 0.0f;
          _4390 = 0.0f;
          _4391 = 0.0f;
          _4392 = 0.0f;
        }
      } else {
        _4373 = _3789;
        _4374 = _3782;
        _4375 = _3783;
        _4376 = _3784;
        _4377 = _3785;
        _4378 = _3779;
        _4379 = _3780;
        _4380 = _3781;
        _4381 = _3776;
        _4382 = _3777;
        _4383 = _3778;
        _4384 = 1.0f;
        _4385 = 1.0f;
        _4386 = 1.0f;
        _4387 = 0.0f;
        _4388 = 0.0f;
        _4389 = 0.0f;
        _4390 = 0.0f;
        _4391 = 0.0f;
        _4392 = 0.0f;
      }
    }
    if (_4373 < _237) {
      float _4398 = (_237 * _114) + _viewPos.x;
      float _4399 = (_237 * _116) + _viewPos.z;
      float _4403 = min(((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * _4373), _237);
      float _4407 = (_4403 * _114) + _viewPos.x;
      float _4408 = (_4403 * _116) + _viewPos.z;
      float _4415 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) + _viewPos.y;
      float _4416 = _4415 + (_4403 * _115);
      float _4422 = sqrt(((_4408 * _4408) + (_4407 * _4407)) + (_4416 * _4416));
      float _4423 = _4407 / _4422;
      float _4424 = _4416 / _4422;
      float _4425 = _4408 / _4422;
      float _4428 = dot(float3(_4423, _4424, _4425), float3(_114, _115, _116));
      float _4430 = dot(float3(_114, _115, _116), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
      float _4432 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f;
      float _4434 = min(max(max((_4422 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _4432);
      float _4436 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f;
      float _4442 = max(_4434, 0.0f);
      float _4443 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f;
      float _4449 = (-0.0f - sqrt((_4442 + _4443) * _4442)) / (_4442 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
      bool _4450 = (_4428 > _4449);
      if (_4450) {
        _4472 = ((exp2(log2(saturate((_4428 - _4449) / (1.0f - _4449))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _4472 = ((exp2(log2(saturate((_4449 - _4428) / (_4449 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _4474 = (exp2(log2(saturate((_4434 + -16.0f) / _4436)) * 0.5f) * 0.96875f) + 0.015625f;
      float _4479 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_4423, _4424, _4425), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _4482 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4474, _4472, _4479), 0.0f);
      float4 _4487 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4474, _4472, _4479), 0.0f);
      float _4494 = (_4430 * _4430) + 1.0f;
      float _4495 = _4494 * 0.05968310311436653f;
      float _4499 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w);
      float _4505 = _4499 + 1.0f;
      float _4506 = (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).w) * 2.0f;
      float _4513 = (((1.0f - _4499) * 3.0f) / ((_4499 + 2.0f) * 2.0f)) * 0.07957746833562851f;
      float _4514 = (_4494 / exp2(log2(_4505 - (_4506 * _4430)) * 1.5f)) * _4513;
      float4 _4519 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4474, _4472, _4479), 0.0f);
      float4 _4524 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4474, _4472, _4479), 0.0f);
      float _4528 = _4415 + (_237 * _115);
      float _4534 = sqrt(((_4399 * _4399) + (_4398 * _4398)) + (_4528 * _4528));
      float _4535 = _4398 / _4534;
      float _4536 = _4528 / _4534;
      float _4537 = _4399 / _4534;
      float _4540 = dot(float3(_4535, _4536, _4537), float3(_114, _115, _116));
      float _4543 = min(max(max((_4534 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)), 0.009999999776482582f), 16.0f), _4432);
      float _4550 = max(_4543, 0.0f);
      float _4556 = (-0.0f - sqrt((_4550 + _4443) * _4550)) / (_4550 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
      bool _4557 = (_4540 > _4556);
      if (_4557) {
        _4579 = ((exp2(log2(saturate((_4540 - _4556) / (1.0f - _4556))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _4579 = ((exp2(log2(saturate((_4556 - _4540) / (_4556 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _4581 = (exp2(log2(saturate((_4543 + -16.0f) / _4436)) * 0.5f) * 0.96875f) + 0.015625f;
      float _4586 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_4535, _4536, _4537), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _4587 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4581, _4579, _4586), 0.0f);
      float4 _4591 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4581, _4579, _4586), 0.0f);
      float4 _4601 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4581, _4579, _4586), 0.0f);
      float4 _4605 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4581, _4579, _4586), 0.0f);
      float _4618 = dot(float3(_4407, _4416, _4408), float3(_114, _115, _116));
      float _4619 = _4618 / _4422;
      float _4620 = _4403 - _237;
      float _4621 = _4620 * _114;
      float _4622 = _4620 * _115;
      float _4623 = _4620 * _116;
      float _4629 = sqrt(((_4621 * _4621) + (_4622 * _4622)) + (_4623 * _4623));
      float _4636 = sqrt((0.5f / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * _4422);
      float _4637 = sqrt((0.5f / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * _4422);
      float _4639 = (_4629 + _4618) / _4422;
      float _4640 = _4636 * _4619;
      float _4641 = _4639 * _4636;
      float _4642 = _4637 * _4619;
      float _4643 = _4639 * _4637;
      float _4664 = float((int)(((int)(uint)((int)(_4640 > 0.0f))) - ((int)(uint)((int)(_4640 < 0.0f)))));
      float _4665 = float((int)(((int)(uint)((int)(_4641 > 0.0f))) - ((int)(uint)((int)(_4641 < 0.0f)))));
      float _4666 = float((int)(((int)(uint)((int)(_4642 > 0.0f))) - ((int)(uint)((int)(_4642 < 0.0f)))));
      float _4667 = float((int)(((int)(uint)((int)(_4643 > 0.0f))) - ((int)(uint)((int)(_4643 < 0.0f)))));
      float _4668 = _4640 * _4640;
      float _4669 = _4642 * _4642;
      bool _4670 = (_4665 > _4664);
      if (_4670) {
        _4675 = exp2(_4668 * 1.4426950216293335f);
      } else {
        _4675 = 0.0f;
      }
      bool _4676 = (_4667 > _4666);
      if (_4676) {
        _4681 = exp2(_4669 * 1.4426950216293335f);
      } else {
        _4681 = 0.0f;
      }
      float _4712 = -0.0f - _4629;
      float _4718 = ((_4629 / (_4422 * 2.0f)) + _4619) * 1.4426950216293335f;
      float _4725 = _4422 * 6.283100128173828f;
      float _4730 = (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) - _4422;
      float _4737 = exp2((_4730 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z)) * 1.4426950216293335f) * sqrt(_4725 * (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z));
      float _4738 = dot(float2((_4664 / (sqrt((_4668 * 1.5199999809265137f) + 4.0f) + (abs(_4640) * 2.3192999362945557f))), (exp2(_4718 * (_4712 / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).z))) * (_4665 / (sqrt(((_4641 * _4641) * 1.5199999809265137f) + 4.0f) + (abs(_4641) * 2.3192999362945557f))))), float2(1.0f, -1.0f));
      float _4739 = dot(float2((_4666 / (sqrt((_4669 * 1.5199999809265137f) + 4.0f) + (abs(_4642) * 2.3192999362945557f))), (exp2(_4718 * (_4712 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x))) * (_4667 / (sqrt(((_4643 * _4643) * 1.5199999809265137f) + 4.0f) + (abs(_4643) * 2.3192999362945557f))))), float2(1.0f, -1.0f));
      float _4742 = (_4738 + _4675) * _4737;
      float _4762 = (((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((sqrt((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x) * _4725) * 1.9999999494757503e-05f) * exp2((_4730 / (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).x)) * 1.4426950216293335f));
      float _4763 = _4762 * (_4739 + _4681);
      float _4768 = (float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1);
      float _4771 = (float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2);
      float _4774 = (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3);
      float _4780 = exp2(((_4768 * _4742) + _4763) * -1.4426950216293335f);
      float _4781 = exp2(((_4771 * _4742) + _4763) * -1.4426950216293335f);
      float _4782 = exp2(((_4774 * _4742) + _4763) * -1.4426950216293335f);
      float _4806 = dot(float3(_114, _115, _116), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
      if (_4450) {
        _4828 = ((exp2(log2(saturate((_4428 - _4449) / (1.0f - _4449))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _4828 = ((exp2(log2(saturate((_4449 - _4428) / (_4449 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _4833 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_4423, _4424, _4425), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _4834 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4474, _4828, _4833), 0.0f);
      float4 _4838 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4474, _4828, _4833), 0.0f);
      float _4843 = (_4806 * _4806) + 1.0f;
      float _4844 = _4843 * 0.05968310311436653f;
      float _4854 = (_4843 / exp2(log2(_4505 - (_4506 * _4806)) * 1.5f)) * _4513;
      float4 _4858 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4474, _4828, _4833), 0.0f);
      float4 _4862 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4474, _4828, _4833), 0.0f);
      if (_4557) {
        _4888 = ((exp2(log2(saturate((_4540 - _4556) / (1.0f - _4556))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _4888 = ((exp2(log2(saturate((_4556 - _4540) / (_4556 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _4893 = (1.0f - exp2(-1.1541560888290405f - (dot(float3(_4535, _4536, _4537), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _4894 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4581, _4888, _4893), 0.0f);
      float4 _4898 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4581, _4888, _4893), 0.0f);
      float4 _4908 = __3__36__0__0__g_texPrecomputedLUTMulti.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4581, _4888, _4893), 0.0f);
      float4 _4912 = __3__36__0__0__g_texPrecomputedLUTMultiMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_4581, _4888, _4893), 0.0f);
      if (_4670) {
        _4929 = exp2(_4668 * 1.4426950216293335f);
      } else {
        _4929 = 0.0f;
      }
      if (_4676) {
        _4934 = exp2(_4669 * 1.4426950216293335f);
      } else {
        _4934 = 0.0f;
      }
      float _4937 = (_4929 + _4738) * _4737;
      float _4938 = _4762 * (_4934 + _4739);
      _4970 = _4780;
      _4971 = _4781;
      _4972 = _4782;
      _4973 = max(0.0f, (((((_4514 * _4487.x) + (_4482.x * _4495)) + _4519.x) + _4524.x) - (_4780 * ((((_4591.x * _4514) + (_4587.x * _4495)) + _4601.x) + _4605.x))));
      _4974 = max(0.0f, (((((_4514 * _4487.y) + (_4482.y * _4495)) + _4519.y) + _4524.y) - (_4781 * ((((_4591.y * _4514) + (_4587.y * _4495)) + _4601.y) + _4605.y))));
      _4975 = max(0.0f, (((((_4514 * _4487.z) + (_4482.z * _4495)) + _4519.z) + _4524.z) - (_4782 * ((((_4591.z * _4514) + (_4587.z * _4495)) + _4601.z) + _4605.z))));
      _4976 = max(0.0f, (((((_4854 * _4838.x) + (_4834.x * _4844)) + _4858.x) + _4862.x) - (exp2((_4938 + (_4937 * _4768)) * -1.4426950216293335f) * ((((_4898.x * _4854) + (_4894.x * _4844)) + _4908.x) + _4912.x))));
      _4977 = max(0.0f, (((((_4854 * _4838.y) + (_4834.y * _4844)) + _4858.y) + _4862.y) - (exp2((_4938 + (_4937 * _4771)) * -1.4426950216293335f) * ((((_4898.y * _4854) + (_4894.y * _4844)) + _4908.y) + _4912.y))));
      _4978 = max(0.0f, (((((_4854 * _4838.z) + (_4834.z * _4844)) + _4858.z) + _4862.z) - (exp2((_4938 + (_4937 * _4774)) * -1.4426950216293335f) * ((((_4898.z * _4854) + (_4894.z * _4844)) + _4908.z) + _4912.z))));
    } else {
      _4970 = _4384;
      _4971 = _4385;
      _4972 = _4386;
      _4973 = _4387;
      _4974 = _4388;
      _4975 = _4389;
      _4976 = _4390;
      _4977 = _4391;
      _4978 = _4392;
    }
    float _5012 = (((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)) * (_4377 + _4376)) + (((_4375 * 1.9999999494757503e-05f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f));
    float _5023 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_1)) * _4374) + _5012) * -1.4426950216293335f);
    float _5024 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_2)) * _4374) + _5012) * -1.4426950216293335f);
    float _5025 = exp2((_5012 + ((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * SKY_OZONE_3) + (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f)) * _4374)) * -1.4426950216293335f);
    float _5044 = (((_4973 * _precomputedAmbient7.y) * _5023) + _4378) + (((_5023 * _4976) + _4381) * _precomputedAmbient7.w);
    float _5045 = (((_4974 * _precomputedAmbient7.y) * _5024) + _4379) + (((_5024 * _4977) + _4382) * _precomputedAmbient7.w);
    float _5046 = (((_4975 * _precomputedAmbient7.y) * _5025) + _4380) + (((_5025 * _4978) + _4383) * _precomputedAmbient7.w);
    float _5047 = _5023 * _4970;
    float _5048 = _5024 * _4971;
    float _5049 = _5025 * _4972;
    _5081 = (((_5048 * _sky_mtx[0][1]) + (_5047 * _sky_mtx[0][0])) + (_5049 * _sky_mtx[0][2]));
    _5082 = (((_5048 * _sky_mtx[1][1]) + (_5047 * _sky_mtx[1][0])) + (_5049 * _sky_mtx[1][2]));
    _5083 = (((_5048 * _sky_mtx[2][1]) + (_5047 * _sky_mtx[2][0])) + (_5049 * _sky_mtx[2][2]));
    _5084 = (((_5045 * _sky_mtx[0][1]) + (_5044 * _sky_mtx[0][0])) + (_5046 * _sky_mtx[0][2]));
    _5085 = (((_5045 * _sky_mtx[1][1]) + (_5044 * _sky_mtx[1][0])) + (_5046 * _sky_mtx[1][2]));
    _5086 = (((_5045 * _sky_mtx[2][1]) + (_5044 * _sky_mtx[2][0])) + (_5046 * _sky_mtx[2][2]));
  } else {
    _5081 = 1.0f;
    _5082 = 1.0f;
    _5083 = 1.0f;
    _5084 = 0.0f;
    _5085 = 0.0f;
    _5086 = 0.0f;
  }
  __3__38__0__1__g_texSkyInscatterUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_5084, _5085, _5086, _61.x);
  __3__38__0__1__g_texSkyExtinctionUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_5081, _5082, _5083, 0.0f);
}
