#include "../shared.h"
#include "../sky-atmospheric/sky_dawn_dusk_common.hlsli"
#include "diffuse_brdf.hlsli"

Texture2D<float4> __3__36__0__0__g_puddleMask : register(t87, space36);

Texture2D<float4> __3__36__0__0__g_climateSandTex : register(t165, space36);

Texture2D<uint16_t> __3__36__0__0__g_sceneDecalMask : register(t166, space36);

Texture2D<float2> __3__36__0__0__g_texNetDensity : register(t19, space36);

Texture3D<float> __3__36__0__0__g_texCloudVolumeShadow : register(t195, space36);

Texture3D<float2> __3__36__0__0__g_hairDualScatteringLUT : register(t214, space36);

Texture2D<float4> __3__36__0__0__g_blueNoise : register(t88, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t0, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t152, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t79, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormalPrev : register(t91, space36);

Texture2D<float2> __3__36__0__0__g_velocity : register(t92, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t39, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaque : register(t49, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaquePrev : register(t94, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t50, space36);

Texture2D<float4> __3__36__0__0__g_bentCone : register(t25, space36);

Texture2D<float4> __3__36__0__0__g_character : register(t76, space36);

Texture2D<float4> __3__36__0__0__g_specularResult : register(t97, space36);

Texture2D<float> __3__36__0__0__g_specularRayHitDistance : register(t180, space36);

Texture2D<float4> __3__36__0__0__g_manyLightsMoments : register(t160, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t98, space36);

Texture2D<float2> __3__36__0__0__g_hairBrdfLookup : register(t100, space36);

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

cbuffer __3__35__0__0__MaterialParameterPresetTableConstantBuffer : register(b42, space35) {
  float4 _clothLightingCategory : packoffset(c000.x);
  float4 _clothLightingParameter[8] : packoffset(c001.x);
  float4 _colorPresetInfo : packoffset(c009.x);
  uint4 _colorPresetParameter[16] : packoffset(c010.x);
  float4 _debugOption : packoffset(c026.x);
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

SamplerState __3__40__0__0__g_samplerClamp : register(s3, space40);

SamplerState __3__40__0__0__g_samplerPoint : register(s4, space40);

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
  int _55[4];
  int _69 = (int)(SV_GroupID.x) & 15;
  int _70 = (uint)((uint)(_69)) >> 2;
  _55[0] = ((g_tileIndex[(SV_GroupID.x) >> 6]).x);
  _55[1] = ((g_tileIndex[(SV_GroupID.x) >> 6]).y);
  _55[2] = ((g_tileIndex[(SV_GroupID.x) >> 6]).z);
  _55[3] = ((g_tileIndex[(SV_GroupID.x) >> 6]).w);
  int _88 = _55[(((uint)(SV_GroupID.x) >> 4) & 3)];
  float _97 = float((uint)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3))));
  float _98 = float((uint)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5))));
  float _99 = _97 + 0.5f;
  float _100 = _98 + 0.5f;
  float _104 = _bufferSizeAndInvSize.z * _99;
  float _105 = _100 * _bufferSizeAndInvSize.w;
  float _107 = __3__36__0__0__g_depth.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
  uint2 _110 = __3__36__0__0__g_stencil.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
  int _112 = _110.x & 127;
  float _115 = max(1.0000000116860974e-07f, _107.x);
  float _116 = _nearFarProj.x / _115;
  half _289;
  half _290;
  half _291;
  half _292;
  float _317;
  float _318;
  float _319;
  bool _335;
  float _416;
  float _417;
  float _418;
  float _419;
  float _442;
  float _443;
  float _444;
  float _445;
  float _446;
  int _452;
  half _453;
  float _454;
  float _455;
  float _456;
  float _457;
  float _458;
  float _487;
  half _488;
  float _490;
  float _503;
  float _504;
  float _505;
  float _506;
  half _507;
  float _547;
  half _911;
  float _912;
  float _913;
  float _914;
  int _915;
  float _916;
  float _917;
  float _918;
  float _919;
  bool _941;
  bool _944;
  bool _945;
  float _963;
  float _974;
  float _975;
  float _985;
  float _986;
  half _987;
  half _988;
  half _989;
  half _990;
  half _991;
  float _1003;
  bool _1026;
  float _1035;
  float _1076;
  float _1077;
  float _1163;
  float _1241;
  bool _1346;
  float _1418;
  float _1419;
  float _1420;
  float _1421;
  float _1584;
  int _1585;
  float _1642;
  float _1762;
  float _1763;
  float _1764;
  float _1765;
  float _1792;
  half _1817;
  bool _1829;
  half _1860;
  int _1861;
  float _1862;
  float _1863;
  float _1864;
  float _2151;
  float _2170;
  float _2174;
  float _2206;
  float _2252;
  float _2253;
  float _2254;
  float _2255;
  float _2261;
  float _2262;
  float _2263;
  float _2264;
  float _2267;
  float _2268;
  float _2269;
  float _2270;
  half _2271;
  float _2388;
  int _2389;
  int _2390;
  float _2391;
  float _2392;
  float _2393;
  float _2394;
  float _2523;
  float _2524;
  float _2525;
  float _2588;
  float _2598;
  float _2599;
  float _2600;
  float _2645;
  float _2646;
  float _2778;
  float _2779;
  float _2780;
  float _2795;
  float _2796;
  float _2797;
  float _2798;
  float _2799;
  bool _2865;
  bool _2866;
  float _2902;
  float _2903;
  float _2904;
  float _2905;
  float _2971;
  float _2974;
  float _2975;
  float _2976;
  float _2977;
  float _3012;
  float _3013;
  float _3014;
  float _3029;
  float _3058;
  float _3059;
  float _3060;
  float _3061;
  float _3062;
  half _3069;
  half _3070;
  half _3071;
  half _3072;
  half _3073;
  float _3074;
  float _3080;
  half _3081;
  half _3082;
  half _3083;
  half _3084;
  half _3085;
  float _3086;
  float _3087;
  float _3088;
  float _3089;
  float _3090;
  float _3091;
  half _3128;
  half _3129;
  half _3130;
  float _3145;
  float _3146;
  float _3147;
  float _3167;
  float _3227;
  float _3325;
  float _3326;
  float _3327;
  bool _3395;
  bool _3417;
  bool _3419;
  bool _3420;
  float _3437;
  int _3438;
  float _3439;
  float _3440;
  float _3441;
  float _3442;
  float _3443;
  float _3482;
  float _3519;
  float _3526;
  float _3527;
  float _3528;
  bool _3549;
  bool _3551;
  bool _3555;
  int _3556;
  float _3557;
  bool _3566;
  int _3567;
  float _3568;
  float _3571;
  int _3572;
  bool _3573;
  bool _3574;
  float _3591;
  float _3592;
  float _3593;
  float _3633;
  float _3904;
  float _3905;
  float _3906;
  float _3907;
  float _3908;
  float _3909;
  float _3910;
  float _3911;
  float _3912;
  float _4082;
  float _4083;
  float _4084;
  float _4085;
  float _4086;
  float _4087;
  float _4088;
  float _4089;
  float _4090;
  float _4180;
  float _4181;
  float _4182;
  float _4249;
  float _4250;
  float _4251;
  float _4252;
  float _4253;
  float _4254;
  float _4299;
  float _4300;
  float _4301;
  float _4302;
  float _4303;
  float _4304;
  float _4305;
  float _4306;
  float _4307;
  float _4322;
  float _4323;
  float _4324;
  float _4325;
  float _4326;
  float _4327;
  float _4328;
  float _4329;
  float _4330;
  float _4342;
  float _4343;
  float _4344;
  float _4646;
  float _4662;
  float _4663;
  float _4664;
  float _4665;
  float _4666;
  float _4667;
  float _4668;
  float _4669;
  float _4670;
  float _4681;
  float _4682;
  float _4683;
  float _4695;
  float _4696;
  float _4697;
  float _4698;
  float _4699;
  float _4700;
  float _4701;
  float _4702;
  float _4703;
  float _4704;
  float _4705;
  float _4706;
  float _4709;
  float _4710;
  float _4711;
  float _4712;
  float _4713;
  float _4714;
  float _4715;
  float _4716;
  float _4717;
  float _4718;
  float _4719;
  float _4720;
  float _4734;
  float _4735;
  float _4854;
  float _4855;
  float _4856;
  float _4857;
  float _4858;
  float _4859;
  float _4860;
  float _4861;
  float _4862;
  float _4906;
  // RenoDX: Foliage transmission accumulator
  float foliageTransR = 0.0f;
  float foliageTransG = 0.0f;
  float foliageTransB = 0.0f;
  half _4955;
  half _4956;
  half _4957;
  float _4970;
  float _5002;
  float _5003;
  float _5096;
  float _5097;
  float _5098;
  float _5168;
  float _5169;
  float _5170;
  bool _5227;
  float _5260;
  float _5261;
  float _5262;
  float _5283;
  float _5284;
  float _5285;
  float _5299;
  float _5300;
  float _5301;
  float _5320;
  float _5321;
  float _5322;
  if (!(((((_107.x < 1.0000000116860974e-07f)) || ((_107.x == 1.0f)))) || ((_112 == 10)))) {
    uint4 _124 = __3__36__0__0__g_baseColor.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
    float4 _130 = __3__36__0__0__g_normal.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
    half _139 = half(float((uint)((uint)(((uint)((uint)(_124.x)) >> 8) & 255))) * 0.003921568859368563f);
    half _143 = half(float((uint)((uint)(_124.x & 255))) * 0.003921568859368563f);
    half _148 = half(float((uint)((uint)(((uint)((uint)(_124.y)) >> 8) & 255))) * 0.003921568859368563f);
    half _152 = half(float((uint)((uint)(_124.y & 255))) * 0.003921568859368563f);
    half _157 = half(float((uint)((uint)(((uint)((uint)(_124.z)) >> 8) & 255))) * 0.003921568859368563f);
    half _161 = half(float((uint)((uint)(_124.z & 255))) * 0.003921568859368563f);
    uint _173 = uint((_130.w * 3.0f) + 0.5f);
    bool _174 = ((int)(_173) == 1);
    bool _175 = ((int)(_173) == 3);
    float _185 = (saturate(_130.x * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _186 = (saturate(_130.y * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _187 = (saturate(_130.z * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _189 = rsqrt(dot(float3(_185, _186, _187), float3(_185, _186, _187)));
    half _193 = half(_189 * _185);
    half _194 = half(_189 * _186);
    half _195 = half(_187 * _189);
    half _198 = (half(float((uint)((uint)(((uint)((uint)(_124.w)) >> 8) & 255))) * 0.003921568859368563f) * 2.0h) + -1.0h;
    half _199 = (half(float((uint)((uint)(_124.w & 255))) * 0.003921568859368563f) * 2.0h) + -1.0h;
    float _204 = float(_198 + _199) * 0.5f;
    float _205 = float(_198 - _199) * 0.5f;
    float _209 = (1.0f - abs(_204)) - abs(_205);
    float _211 = rsqrt(dot(float3(_204, _205, _209), float3(_204, _205, _209)));
    float _218 = float(_193);
    float _219 = float(_194);
    float _220 = float(_195);
    float _222 = select((_195 >= 0.0h), 1.0f, -1.0f);
    float _225 = -0.0f - (1.0f / (_222 + _220));
    float _226 = _219 * _225;
    float _227 = _226 * _218;
    float _228 = _222 * _218;
    float _234 = -0.0f - _219;
    float _235 = float(half(_211 * _204));
    float _236 = float(half(_211 * _205));
    float _237 = float(half(_211 * _209));
    half _249 = half(mad(_237, _218, mad(_236, _227, (_235 * (((_228 * _218) * _225) + 1.0f)))));
    half _250 = half(mad(_237, _219, mad(_236, ((_226 * _219) + _222), ((_235 * _222) * _227))));
    half _251 = half(mad(_237, _220, mad(_236, _234, (-0.0f - (_228 * _235)))));
    half _253 = rsqrt(dot(half3(_249, _250, _251), half3(_249, _250, _251)));
    half _257 = saturate(_139 * _139);
    half _258 = saturate(_143 * _143);
    half _259 = saturate(_148 * _148);
    half _275 = saturate(((_258 * 0.3395996h) + (_257 * 0.61328125h)) + (_259 * 0.04736328h));
    half _276 = saturate(((_258 * 0.9165039h) + (_257 * 0.07019043h)) + (_259 * 0.013450623h));
    half _277 = saturate(((_258 * 0.109558105h) + (_257 * 0.020614624h)) + (_259 * 0.8696289h));
    if (!((uint)(_112 + -65) < (uint)2)) {
      _289 = (_253 * _249);
      _290 = (_253 * _250);
      _291 = (_253 * _251);
      _292 = select((((_112 == 24)) || ((_112 == 29))), 0.0h, _152);
    } else {
      _289 = _193;
      _290 = _194;
      _291 = _195;
      _292 = _152;
    }
    half4 _294 = __3__36__0__0__g_diffuseResult.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
    float _298 = float(_294.x);
    float _299 = float(_294.y);
    float _300 = float(_294.z);
    [branch]
    if (_renderParams2.y > 0.0f) {
      half4 _306 = __3__36__0__0__g_sceneDiffuse.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
      _317 = (float(_306.x) + _298);
      _318 = (float(_306.y) + _299);
      _319 = (float(_306.z) + _300);
    } else {
      _317 = _298;
      _318 = _299;
      _319 = _300;
    }
    float4 _321 = __3__36__0__0__g_specularResult.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
    if ((uint)_112 > (uint)11) {
      if (!((((uint)_112 < (uint)21)) || ((_112 == 107)))) {
        _335 = (_112 == 7);
      } else {
        _335 = true;
      }
    } else {
      if (!(_112 == 6)) {
        _335 = (_112 == 7);
      } else {
        _335 = true;
      }
    }
    bool _345 = ((_112 == 38)) || (((((uint)(_112 + -27) < (uint)2)) || ((((_112 == 26)) || (((((uint)(_112 + -105) < (uint)2)) || (_175)))))));
    float _346 = float(_289);
    float _347 = float(_290);
    float _348 = float(_291);
    float _350 = (_104 * 2.0f) + -1.0f;
    float _352 = 1.0f - (_105 * 2.0f);
    float _388 = mad((_invViewProjRelative[3].z), _115, mad((_invViewProjRelative[3].y), _352, ((_invViewProjRelative[3].x) * _350))) + (_invViewProjRelative[3].w);
    float _389 = (mad((_invViewProjRelative[0].z), _115, mad((_invViewProjRelative[0].y), _352, ((_invViewProjRelative[0].x) * _350))) + (_invViewProjRelative[0].w)) / _388;
    float _390 = (mad((_invViewProjRelative[1].z), _115, mad((_invViewProjRelative[1].y), _352, ((_invViewProjRelative[1].x) * _350))) + (_invViewProjRelative[1].w)) / _388;
    float _391 = (mad((_invViewProjRelative[2].z), _115, mad((_invViewProjRelative[2].y), _352, ((_invViewProjRelative[2].x) * _350))) + (_invViewProjRelative[2].w)) / _388;
    float _393 = rsqrt(dot(float3(_389, _390, _391), float3(_389, _390, _391)));
    float _394 = _393 * _389;
    float _395 = _393 * _390;
    float _396 = _393 * _391;
    int _397 = _110.x & 126;
    bool _400 = ((_397 == 66)) || ((_112 == 54));
    bool _401 = (_112 == 33);
    bool _403 = (_112 == 55);
    if (((_397 == 64)) || (((((_401) || (_400))) || (((_403) || (_345)))))) {
      float4 _410 = __3__36__0__0__g_character.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
      _416 = _410.x;
      _417 = _410.y;
      _418 = _410.z;
      _419 = _410.w;
    } else {
      _416 = 0.0f;
      _417 = 0.0f;
      _418 = 0.0f;
      _419 = 0.0f;
    }
    if (_401) {
      uint _428 = uint((_clothLightingCategory.x * _416) + 0.5f);
      if (((_418 > 0.0f)) && (((uint)(int)(_428) < (uint)(int)(uint(_clothLightingCategory.x))))) {
        _442 = _418;
        _443 = min((1.0f - ((_clothLightingParameter[_428]).y)), ((_clothLightingParameter[_428]).x));
        _444 = saturate(_417);
        _445 = ((_clothLightingParameter[_428]).y);
        _446 = ((_clothLightingParameter[_428]).x);
      } else {
        _442 = 0.0f;
        _443 = 0.0f;
        _444 = 0.0f;
        _445 = 0.0f;
        _446 = 0.0f;
      }
      _452 = _112;
      _453 = half(_effectiveMetallicForVelvet * _446);
      _454 = _442;
      _455 = _443;
      _456 = _444;
      _457 = _445;
      _458 = _446;
    } else {
      if (_403) {
        if (!(_418 < 0.0010000000474974513f)) {
          uint _428 = uint((_clothLightingCategory.x * _416) + 0.5f);
          if (((_418 > 0.0f)) && (((uint)(int)(_428) < (uint)(int)(uint(_clothLightingCategory.x))))) {
            _442 = _418;
            _443 = min((1.0f - ((_clothLightingParameter[_428]).y)), ((_clothLightingParameter[_428]).x));
            _444 = saturate(_417);
            _445 = ((_clothLightingParameter[_428]).y);
            _446 = ((_clothLightingParameter[_428]).x);
          } else {
            _442 = 0.0f;
            _443 = 0.0f;
            _444 = 0.0f;
            _445 = 0.0f;
            _446 = 0.0f;
          }
          _452 = _112;
          _453 = half(_effectiveMetallicForVelvet * _446);
          _454 = _442;
          _455 = _443;
          _456 = _444;
          _457 = _445;
          _458 = _446;
        } else {
          _452 = 53;
          _453 = _292;
          _454 = 0.0f;
          _455 = 0.0f;
          _456 = 0.0f;
          _457 = 0.0f;
          _458 = 0.0f;
        }
      } else {
        _452 = _112;
        _453 = _292;
        _454 = 0.0f;
        _455 = 0.0f;
        _456 = 0.0f;
        _457 = 0.0f;
        _458 = 0.0f;
      }
    }
    bool __defer_451_489 = false;
    if (_452 == 66) {
      _490 = float(_453);
      __defer_451_489 = true;
    } else {
      bool _462 = (_452 == 54);
      bool __defer_460_486 = false;
      if (((_452 == 67)) || (_462)) {
        float _469 = float((uint)((uint)(((int)(_frameNumber.x * 73)) & 127)));
        if (!(float(_453) > (frac(frac(dot(float2(((_469 * 32.665000915527344f) + _97), ((_469 * 11.8149995803833f) + _98)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 0.20000000298023224f))) {
          bool __branch_chain_483;
          if ((_452 & 126) == 66) {
            _490 = 1.0f;
            __branch_chain_483 = true;
          } else {
            _487 = 1.0f;
            _488 = 0.0h;
            if (_462) {
              _490 = _487;
              __branch_chain_483 = true;
            } else {
              _503 = _487;
              _504 = _346;
              _505 = _347;
              _506 = _348;
              _507 = _488;
              __branch_chain_483 = false;
            }
          }
          if (__branch_chain_483) {
            __defer_451_489 = true;
          }
          bool _510 = (_452 == 54);
          if ((_510) || (((_452 & 126) == 66))) {
            float4 _514 = __3__36__0__0__g_bentCone.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
            float _521 = (_514.x * 2.0f) + -1.0f;
            float _522 = (_514.y * 2.0f) + -1.0f;
            float _523 = (_514.z * 2.0f) + -1.0f;
            float _525 = rsqrt(dot(float3(_521, _522, _523), float3(_521, _522, _523)));
            float _526 = _521 * _525;
            float _527 = _522 * _525;
            float _528 = _523 * _525;
            float _532 = float(saturate((_157 * 1.25h) + 0.25h));
            if (_510) {
              _547 = (((asfloat(_globalLightParams.z) * _532) + _bevelParams.y) + (asfloat(_globalLightParams.w) * float(_161)));
            } else {
              _547 = _bevelParams.y;
            }
            float _548 = float(_275);
            float _549 = float(_276);
            float _550 = float(_277);
            float _551 = dot(float3(_504, _505, _506), float3(_526, _527, _528));
            float _552 = -0.0f - _394;
            float _553 = -0.0f - _395;
            float _554 = -0.0f - _396;
            float _555 = dot(float3(_504, _505, _506), float3(_552, _553, _554));
            float _561 = cos(abs(asin(_555) - asin(_551)) * 0.5f);
            float _565 = _526 - (_551 * _504);
            float _566 = _527 - (_551 * _505);
            float _567 = _528 - (_551 * _506);
            float _571 = _552 - (_555 * _504);
            float _572 = _553 - (_555 * _505);
            float _573 = _554 - (_555 * _506);
            float _580 = rsqrt((dot(float3(_571, _572, _573), float3(_571, _572, _573)) * dot(float3(_565, _566, _567), float3(_565, _566, _567))) + 9.999999747378752e-05f) * dot(float3(_565, _566, _567), float3(_571, _572, _573));
            float _590 = min(max(_532, 0.09803921729326248f), 1.0f);
            float _591 = _590 * _590;
            float _592 = _591 * 0.5f;
            float _593 = _591 * 2.0f;
            float _594 = _555 + _551;
            float _595 = _594 - _547;
            float _604 = 1.0f / ((1.190000057220459f / _561) + (_561 * 0.36000001430511475f));
            float _609 = ((_604 * (0.6000000238418579f - (_580 * 0.800000011920929f))) + 1.0f) * sqrt(saturate((_580 * 0.5f) + 0.5f));
            float _615 = 1.0f - (sqrt(saturate(1.0f - (_609 * _609))) * _561);
            float _616 = _615 * _615;
            float _620 = 0.9534794092178345f - ((_616 * _616) * (_615 * 0.9534794092178345f));
            float _621 = _604 * _609;
            float _626 = (sqrt(1.0f - (_621 * _621)) * 0.5f) / _561;
            float _627 = log2(_548);
            float _628 = log2(_549);
            float _629 = log2(_550);
            float _641 = ((_620 * _620) * (exp2((((_595 * _595) * -0.5f) / (_592 * _592)) * 1.4426950216293335f) / (_591 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_580 * 5.2658371925354f));
            float _645 = _594 - (_547 * 4.0f);
            float _655 = 1.0f - (_561 * 0.5f);
            float _656 = _655 * _655;
            float _660 = (_656 * _656) * (0.9534794092178345f - (_561 * 0.47673970460891724f));
            float _662 = 0.9534794092178345f - _660;
            float _663 = 0.800000011920929f / _561;
            float _676 = (((_662 * _662) * (_660 + 0.04652056470513344f)) * (exp2((((_645 * _645) * -0.5f) / (_593 * _593)) * 1.4426950216293335f) / (_591 * 5.013256549835205f))) * exp2((_580 * 24.525815963745117f) + -24.208423614501953f);
            float _686 = min(0.0f, (-0.0f - ((_641 * exp2(_627 * _626)) + (_676 * exp2(_663 * _627)))));
            float _687 = min(0.0f, (-0.0f - ((_641 * exp2(_628 * _626)) + (_676 * exp2(_663 * _628)))));
            float _688 = min(0.0f, (-0.0f - ((_641 * exp2(_629 * _626)) + (_676 * exp2(_663 * _629)))));
            float _697 = saturate(abs(dot(float3(_526, _527, _528), float3(_504, _505, _506))));
            float2 _706 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_627 * 1.5f)))), 0.0f);
            float2 _709 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_628 * 1.5f)))), 0.0f);
            float2 _712 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_629 * 1.5f)))), 0.0f);
            float _719 = min(0.9900000095367432f, _706.x);
            float _720 = min(0.9900000095367432f, _709.x);
            float _721 = min(0.9900000095367432f, _712.x);
            float _722 = min(0.9900000095367432f, _706.y);
            float _723 = min(0.9900000095367432f, _709.y);
            float _724 = min(0.9900000095367432f, _712.y);
            float _725 = _719 * _719;
            float _726 = _720 * _720;
            float _727 = _721 * _721;
            float _728 = _722 * _722;
            float _729 = _723 * _723;
            float _730 = _724 * _724;
            float _731 = _728 * _722;
            float _732 = _729 * _723;
            float _733 = _730 * _724;
            float _734 = 1.0f - _725;
            float _735 = 1.0f - _726;
            float _736 = 1.0f - _727;
            float _746 = _734 * _734;
            float _747 = _735 * _735;
            float _748 = _736 * _736;
            float _749 = _746 * _734;
            float _750 = _747 * _735;
            float _751 = _748 * _736;
            float _759 = min(max(_532, 0.18000000715255737f), 0.6000000238418579f);
            float _760 = _759 * _759;
            float _761 = _760 * 0.25f;
            float _762 = _760 * 4.0f;
            float _764 = (_720 + _719) + _721;
            float _765 = _719 / _764;
            float _766 = _720 / _764;
            float _767 = _721 / _764;
            float _768 = dot(float3(_760, _761, _762), float3(_765, _766, _767));
            float _769 = _768 * _768;
            float _772 = asin(min(max(_555, -1.0f), 1.0f)) + asin(min(max(_551, -1.0f), 1.0f));
            float _773 = _772 * 0.5f;
            float _774 = dot(float3(-0.07000000029802322f, 0.03500000014901161f, 0.14000000059604645f), float3(_765, _766, _767));
            float _784 = _774 * _774;
            float _807 = (_723 + _722) + _724;
            float _811 = dot(float3(_760, _761, _762), float3((_722 / _807), (_723 / _807), (_724 / _807)));
            float _815 = sqrt((_811 * _811) + (_769 * 2.0f));
            float _833 = (_811 * 3.0f) + (_768 * 2.0f);
            float _840 = (((_731 + _722) * ((_725 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _731) + _722);
            float _841 = (((_732 + _723) * ((_726 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _732) + _723);
            float _842 = (((_733 + _724) * ((_727 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _733) + _724);
            float _851 = _773 - (((_784 * (((_725 * 4.0f) * _728) + (_746 * 2.0f))) * (1.0f - ((_728 * 2.0f) / _746))) / _749);
            float _858 = _773 - (((_784 * (((_726 * 4.0f) * _729) + (_747 * 2.0f))) * (1.0f - ((_729 * 2.0f) / _747))) / _750);
            float _865 = _773 - (((_784 * (((_727 * 4.0f) * _730) + (_748 * 2.0f))) * (1.0f - ((_730 * 2.0f) / _748))) / _751);
            float _893 = exp2((((_772 * -0.25f) * _773) / _769) * 1.4426950216293335f) * 1.399999976158142f;
            float _894 = ((((((_731 * _725) / _749) + ((_722 * _725) / _734)) * 4.398229598999023f) * exp2((((_851 * _851) * -0.5f) / ((_840 * _840) + _769)) * 1.4426950216293335f)) + ((((_706.x + _686) * 0.25f) - _686) * 6.2831854820251465f)) * _893;
            float _895 = ((((((_732 * _726) / _750) + ((_723 * _726) / _735)) * 4.398229598999023f) * exp2((((_858 * _858) * -0.5f) / ((_841 * _841) + _769)) * 1.4426950216293335f)) + ((((_709.x + _687) * 0.25f) - _687) * 6.2831854820251465f)) * _893;
            float _896 = ((((((_733 * _727) / _751) + ((_724 * _727) / _736)) * 4.398229598999023f) * exp2((((_865 * _865) * -0.5f) / ((_842 * _842) + _769)) * 1.4426950216293335f)) + ((((_712.x + _688) * 0.25f) - _688) * 6.2831854820251465f)) * _893;
            float _897 = max(0.125f, _503);
            _911 = _507;
            _912 = _504;
            _913 = _505;
            _914 = _506;
            _915 = _452;
            _916 = _503;
            _917 = max(0.009999999776482582f, ((_897 * (_548 - _894)) + _894));
            _918 = max(0.009999999776482582f, (lerp(_895, _549, _897)));
            _919 = max(0.009999999776482582f, (lerp(_896, _550, _897)));
          } else {
            _911 = _507;
            _912 = _504;
            _913 = _505;
            _914 = _506;
            _915 = _452;
            _916 = _503;
            _917 = 0.0f;
            _918 = 0.0f;
            _919 = 0.0f;
          }
        } else {
          _911 = 0.0h;
          _912 = _346;
          _913 = _347;
          _914 = _348;
          _915 = 53;
          _916 = 1.0f;
          _917 = 0.0f;
          _918 = 0.0f;
          _919 = 0.0f;
        }
      } else {
        _487 = 0.0f;
        _488 = _453;
        __defer_460_486 = true;
      }
      if (__defer_460_486) {
        if (_462) {
          _490 = _487;
          __defer_451_489 = true;
        } else {
          _503 = _487;
          _504 = _346;
          _505 = _347;
          _506 = _348;
          _507 = _488;
        }
        bool _510 = (_452 == 54);
        if ((_510) || (((_452 & 126) == 66))) {
          float4 _514 = __3__36__0__0__g_bentCone.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
          float _521 = (_514.x * 2.0f) + -1.0f;
          float _522 = (_514.y * 2.0f) + -1.0f;
          float _523 = (_514.z * 2.0f) + -1.0f;
          float _525 = rsqrt(dot(float3(_521, _522, _523), float3(_521, _522, _523)));
          float _526 = _521 * _525;
          float _527 = _522 * _525;
          float _528 = _523 * _525;
          float _532 = float(saturate((_157 * 1.25h) + 0.25h));
          if (_510) {
            _547 = (((asfloat(_globalLightParams.z) * _532) + _bevelParams.y) + (asfloat(_globalLightParams.w) * float(_161)));
          } else {
            _547 = _bevelParams.y;
          }
          float _548 = float(_275);
          float _549 = float(_276);
          float _550 = float(_277);
          float _551 = dot(float3(_504, _505, _506), float3(_526, _527, _528));
          float _552 = -0.0f - _394;
          float _553 = -0.0f - _395;
          float _554 = -0.0f - _396;
          float _555 = dot(float3(_504, _505, _506), float3(_552, _553, _554));
          float _561 = cos(abs(asin(_555) - asin(_551)) * 0.5f);
          float _565 = _526 - (_551 * _504);
          float _566 = _527 - (_551 * _505);
          float _567 = _528 - (_551 * _506);
          float _571 = _552 - (_555 * _504);
          float _572 = _553 - (_555 * _505);
          float _573 = _554 - (_555 * _506);
          float _580 = rsqrt((dot(float3(_571, _572, _573), float3(_571, _572, _573)) * dot(float3(_565, _566, _567), float3(_565, _566, _567))) + 9.999999747378752e-05f) * dot(float3(_565, _566, _567), float3(_571, _572, _573));
          float _590 = min(max(_532, 0.09803921729326248f), 1.0f);
          float _591 = _590 * _590;
          float _592 = _591 * 0.5f;
          float _593 = _591 * 2.0f;
          float _594 = _555 + _551;
          float _595 = _594 - _547;
          float _604 = 1.0f / ((1.190000057220459f / _561) + (_561 * 0.36000001430511475f));
          float _609 = ((_604 * (0.6000000238418579f - (_580 * 0.800000011920929f))) + 1.0f) * sqrt(saturate((_580 * 0.5f) + 0.5f));
          float _615 = 1.0f - (sqrt(saturate(1.0f - (_609 * _609))) * _561);
          float _616 = _615 * _615;
          float _620 = 0.9534794092178345f - ((_616 * _616) * (_615 * 0.9534794092178345f));
          float _621 = _604 * _609;
          float _626 = (sqrt(1.0f - (_621 * _621)) * 0.5f) / _561;
          float _627 = log2(_548);
          float _628 = log2(_549);
          float _629 = log2(_550);
          float _641 = ((_620 * _620) * (exp2((((_595 * _595) * -0.5f) / (_592 * _592)) * 1.4426950216293335f) / (_591 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_580 * 5.2658371925354f));
          float _645 = _594 - (_547 * 4.0f);
          float _655 = 1.0f - (_561 * 0.5f);
          float _656 = _655 * _655;
          float _660 = (_656 * _656) * (0.9534794092178345f - (_561 * 0.47673970460891724f));
          float _662 = 0.9534794092178345f - _660;
          float _663 = 0.800000011920929f / _561;
          float _676 = (((_662 * _662) * (_660 + 0.04652056470513344f)) * (exp2((((_645 * _645) * -0.5f) / (_593 * _593)) * 1.4426950216293335f) / (_591 * 5.013256549835205f))) * exp2((_580 * 24.525815963745117f) + -24.208423614501953f);
          float _686 = min(0.0f, (-0.0f - ((_641 * exp2(_627 * _626)) + (_676 * exp2(_663 * _627)))));
          float _687 = min(0.0f, (-0.0f - ((_641 * exp2(_628 * _626)) + (_676 * exp2(_663 * _628)))));
          float _688 = min(0.0f, (-0.0f - ((_641 * exp2(_629 * _626)) + (_676 * exp2(_663 * _629)))));
          float _697 = saturate(abs(dot(float3(_526, _527, _528), float3(_504, _505, _506))));
          float2 _706 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_627 * 1.5f)))), 0.0f);
          float2 _709 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_628 * 1.5f)))), 0.0f);
          float2 _712 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_629 * 1.5f)))), 0.0f);
          float _719 = min(0.9900000095367432f, _706.x);
          float _720 = min(0.9900000095367432f, _709.x);
          float _721 = min(0.9900000095367432f, _712.x);
          float _722 = min(0.9900000095367432f, _706.y);
          float _723 = min(0.9900000095367432f, _709.y);
          float _724 = min(0.9900000095367432f, _712.y);
          float _725 = _719 * _719;
          float _726 = _720 * _720;
          float _727 = _721 * _721;
          float _728 = _722 * _722;
          float _729 = _723 * _723;
          float _730 = _724 * _724;
          float _731 = _728 * _722;
          float _732 = _729 * _723;
          float _733 = _730 * _724;
          float _734 = 1.0f - _725;
          float _735 = 1.0f - _726;
          float _736 = 1.0f - _727;
          float _746 = _734 * _734;
          float _747 = _735 * _735;
          float _748 = _736 * _736;
          float _749 = _746 * _734;
          float _750 = _747 * _735;
          float _751 = _748 * _736;
          float _759 = min(max(_532, 0.18000000715255737f), 0.6000000238418579f);
          float _760 = _759 * _759;
          float _761 = _760 * 0.25f;
          float _762 = _760 * 4.0f;
          float _764 = (_720 + _719) + _721;
          float _765 = _719 / _764;
          float _766 = _720 / _764;
          float _767 = _721 / _764;
          float _768 = dot(float3(_760, _761, _762), float3(_765, _766, _767));
          float _769 = _768 * _768;
          float _772 = asin(min(max(_555, -1.0f), 1.0f)) + asin(min(max(_551, -1.0f), 1.0f));
          float _773 = _772 * 0.5f;
          float _774 = dot(float3(-0.07000000029802322f, 0.03500000014901161f, 0.14000000059604645f), float3(_765, _766, _767));
          float _784 = _774 * _774;
          float _807 = (_723 + _722) + _724;
          float _811 = dot(float3(_760, _761, _762), float3((_722 / _807), (_723 / _807), (_724 / _807)));
          float _815 = sqrt((_811 * _811) + (_769 * 2.0f));
          float _833 = (_811 * 3.0f) + (_768 * 2.0f);
          float _840 = (((_731 + _722) * ((_725 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _731) + _722);
          float _841 = (((_732 + _723) * ((_726 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _732) + _723);
          float _842 = (((_733 + _724) * ((_727 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _733) + _724);
          float _851 = _773 - (((_784 * (((_725 * 4.0f) * _728) + (_746 * 2.0f))) * (1.0f - ((_728 * 2.0f) / _746))) / _749);
          float _858 = _773 - (((_784 * (((_726 * 4.0f) * _729) + (_747 * 2.0f))) * (1.0f - ((_729 * 2.0f) / _747))) / _750);
          float _865 = _773 - (((_784 * (((_727 * 4.0f) * _730) + (_748 * 2.0f))) * (1.0f - ((_730 * 2.0f) / _748))) / _751);
          float _893 = exp2((((_772 * -0.25f) * _773) / _769) * 1.4426950216293335f) * 1.399999976158142f;
          float _894 = ((((((_731 * _725) / _749) + ((_722 * _725) / _734)) * 4.398229598999023f) * exp2((((_851 * _851) * -0.5f) / ((_840 * _840) + _769)) * 1.4426950216293335f)) + ((((_706.x + _686) * 0.25f) - _686) * 6.2831854820251465f)) * _893;
          float _895 = ((((((_732 * _726) / _750) + ((_723 * _726) / _735)) * 4.398229598999023f) * exp2((((_858 * _858) * -0.5f) / ((_841 * _841) + _769)) * 1.4426950216293335f)) + ((((_709.x + _687) * 0.25f) - _687) * 6.2831854820251465f)) * _893;
          float _896 = ((((((_733 * _727) / _751) + ((_724 * _727) / _736)) * 4.398229598999023f) * exp2((((_865 * _865) * -0.5f) / ((_842 * _842) + _769)) * 1.4426950216293335f)) + ((((_712.x + _688) * 0.25f) - _688) * 6.2831854820251465f)) * _893;
          float _897 = max(0.125f, _503);
          _911 = _507;
          _912 = _504;
          _913 = _505;
          _914 = _506;
          _915 = _452;
          _916 = _503;
          _917 = max(0.009999999776482582f, ((_897 * (_548 - _894)) + _894));
          _918 = max(0.009999999776482582f, (lerp(_895, _549, _897)));
          _919 = max(0.009999999776482582f, (lerp(_896, _550, _897)));
        } else {
          _911 = _507;
          _912 = _504;
          _913 = _505;
          _914 = _506;
          _915 = _452;
          _916 = _503;
          _917 = 0.0f;
          _918 = 0.0f;
          _919 = 0.0f;
        }
      }
    }
    if (__defer_451_489) {
      float _494 = (_416 * 2.0f) + -1.0f;
      float _495 = (_417 * 2.0f) + -1.0f;
      float _496 = (_418 * 2.0f) + -1.0f;
      float _498 = rsqrt(dot(float3(_494, _495, _496), float3(_494, _495, _496)));
      _503 = _490;
      _504 = (_498 * _494);
      _505 = (_498 * _495);
      _506 = (_498 * _496);
      _507 = 0.0h;
      bool _510 = (_452 == 54);
      if ((_510) || (((_452 & 126) == 66))) {
        float4 _514 = __3__36__0__0__g_bentCone.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
        float _521 = (_514.x * 2.0f) + -1.0f;
        float _522 = (_514.y * 2.0f) + -1.0f;
        float _523 = (_514.z * 2.0f) + -1.0f;
        float _525 = rsqrt(dot(float3(_521, _522, _523), float3(_521, _522, _523)));
        float _526 = _521 * _525;
        float _527 = _522 * _525;
        float _528 = _523 * _525;
        float _532 = float(saturate((_157 * 1.25h) + 0.25h));
        if (_510) {
          _547 = (((asfloat(_globalLightParams.z) * _532) + _bevelParams.y) + (asfloat(_globalLightParams.w) * float(_161)));
        } else {
          _547 = _bevelParams.y;
        }
        float _548 = float(_275);
        float _549 = float(_276);
        float _550 = float(_277);
        float _551 = dot(float3(_504, _505, _506), float3(_526, _527, _528));
        float _552 = -0.0f - _394;
        float _553 = -0.0f - _395;
        float _554 = -0.0f - _396;
        float _555 = dot(float3(_504, _505, _506), float3(_552, _553, _554));
        float _561 = cos(abs(asin(_555) - asin(_551)) * 0.5f);
        float _565 = _526 - (_551 * _504);
        float _566 = _527 - (_551 * _505);
        float _567 = _528 - (_551 * _506);
        float _571 = _552 - (_555 * _504);
        float _572 = _553 - (_555 * _505);
        float _573 = _554 - (_555 * _506);
        float _580 = rsqrt((dot(float3(_571, _572, _573), float3(_571, _572, _573)) * dot(float3(_565, _566, _567), float3(_565, _566, _567))) + 9.999999747378752e-05f) * dot(float3(_565, _566, _567), float3(_571, _572, _573));
        float _590 = min(max(_532, 0.09803921729326248f), 1.0f);
        float _591 = _590 * _590;
        float _592 = _591 * 0.5f;
        float _593 = _591 * 2.0f;
        float _594 = _555 + _551;
        float _595 = _594 - _547;
        float _604 = 1.0f / ((1.190000057220459f / _561) + (_561 * 0.36000001430511475f));
        float _609 = ((_604 * (0.6000000238418579f - (_580 * 0.800000011920929f))) + 1.0f) * sqrt(saturate((_580 * 0.5f) + 0.5f));
        float _615 = 1.0f - (sqrt(saturate(1.0f - (_609 * _609))) * _561);
        float _616 = _615 * _615;
        float _620 = 0.9534794092178345f - ((_616 * _616) * (_615 * 0.9534794092178345f));
        float _621 = _604 * _609;
        float _626 = (sqrt(1.0f - (_621 * _621)) * 0.5f) / _561;
        float _627 = log2(_548);
        float _628 = log2(_549);
        float _629 = log2(_550);
        float _641 = ((_620 * _620) * (exp2((((_595 * _595) * -0.5f) / (_592 * _592)) * 1.4426950216293335f) / (_591 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_580 * 5.2658371925354f));
        float _645 = _594 - (_547 * 4.0f);
        float _655 = 1.0f - (_561 * 0.5f);
        float _656 = _655 * _655;
        float _660 = (_656 * _656) * (0.9534794092178345f - (_561 * 0.47673970460891724f));
        float _662 = 0.9534794092178345f - _660;
        float _663 = 0.800000011920929f / _561;
        float _676 = (((_662 * _662) * (_660 + 0.04652056470513344f)) * (exp2((((_645 * _645) * -0.5f) / (_593 * _593)) * 1.4426950216293335f) / (_591 * 5.013256549835205f))) * exp2((_580 * 24.525815963745117f) + -24.208423614501953f);
        float _686 = min(0.0f, (-0.0f - ((_641 * exp2(_627 * _626)) + (_676 * exp2(_663 * _627)))));
        float _687 = min(0.0f, (-0.0f - ((_641 * exp2(_628 * _626)) + (_676 * exp2(_663 * _628)))));
        float _688 = min(0.0f, (-0.0f - ((_641 * exp2(_629 * _626)) + (_676 * exp2(_663 * _629)))));
        float _697 = saturate(abs(dot(float3(_526, _527, _528), float3(_504, _505, _506))));
        float2 _706 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_627 * 1.5f)))), 0.0f);
        float2 _709 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_628 * 1.5f)))), 0.0f);
        float2 _712 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_697, _532, saturate(sqrt(exp2(_629 * 1.5f)))), 0.0f);
        float _719 = min(0.9900000095367432f, _706.x);
        float _720 = min(0.9900000095367432f, _709.x);
        float _721 = min(0.9900000095367432f, _712.x);
        float _722 = min(0.9900000095367432f, _706.y);
        float _723 = min(0.9900000095367432f, _709.y);
        float _724 = min(0.9900000095367432f, _712.y);
        float _725 = _719 * _719;
        float _726 = _720 * _720;
        float _727 = _721 * _721;
        float _728 = _722 * _722;
        float _729 = _723 * _723;
        float _730 = _724 * _724;
        float _731 = _728 * _722;
        float _732 = _729 * _723;
        float _733 = _730 * _724;
        float _734 = 1.0f - _725;
        float _735 = 1.0f - _726;
        float _736 = 1.0f - _727;
        float _746 = _734 * _734;
        float _747 = _735 * _735;
        float _748 = _736 * _736;
        float _749 = _746 * _734;
        float _750 = _747 * _735;
        float _751 = _748 * _736;
        float _759 = min(max(_532, 0.18000000715255737f), 0.6000000238418579f);
        float _760 = _759 * _759;
        float _761 = _760 * 0.25f;
        float _762 = _760 * 4.0f;
        float _764 = (_720 + _719) + _721;
        float _765 = _719 / _764;
        float _766 = _720 / _764;
        float _767 = _721 / _764;
        float _768 = dot(float3(_760, _761, _762), float3(_765, _766, _767));
        float _769 = _768 * _768;
        float _772 = asin(min(max(_555, -1.0f), 1.0f)) + asin(min(max(_551, -1.0f), 1.0f));
        float _773 = _772 * 0.5f;
        float _774 = dot(float3(-0.07000000029802322f, 0.03500000014901161f, 0.14000000059604645f), float3(_765, _766, _767));
        float _784 = _774 * _774;
        float _807 = (_723 + _722) + _724;
        float _811 = dot(float3(_760, _761, _762), float3((_722 / _807), (_723 / _807), (_724 / _807)));
        float _815 = sqrt((_811 * _811) + (_769 * 2.0f));
        float _833 = (_811 * 3.0f) + (_768 * 2.0f);
        float _840 = (((_731 + _722) * ((_725 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _731) + _722);
        float _841 = (((_732 + _723) * ((_726 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _732) + _723);
        float _842 = (((_733 + _724) * ((_727 * 0.699999988079071f) + 1.0f)) * _815) / ((_833 * _733) + _724);
        float _851 = _773 - (((_784 * (((_725 * 4.0f) * _728) + (_746 * 2.0f))) * (1.0f - ((_728 * 2.0f) / _746))) / _749);
        float _858 = _773 - (((_784 * (((_726 * 4.0f) * _729) + (_747 * 2.0f))) * (1.0f - ((_729 * 2.0f) / _747))) / _750);
        float _865 = _773 - (((_784 * (((_727 * 4.0f) * _730) + (_748 * 2.0f))) * (1.0f - ((_730 * 2.0f) / _748))) / _751);
        float _893 = exp2((((_772 * -0.25f) * _773) / _769) * 1.4426950216293335f) * 1.399999976158142f;
        float _894 = ((((((_731 * _725) / _749) + ((_722 * _725) / _734)) * 4.398229598999023f) * exp2((((_851 * _851) * -0.5f) / ((_840 * _840) + _769)) * 1.4426950216293335f)) + ((((_706.x + _686) * 0.25f) - _686) * 6.2831854820251465f)) * _893;
        float _895 = ((((((_732 * _726) / _750) + ((_723 * _726) / _735)) * 4.398229598999023f) * exp2((((_858 * _858) * -0.5f) / ((_841 * _841) + _769)) * 1.4426950216293335f)) + ((((_709.x + _687) * 0.25f) - _687) * 6.2831854820251465f)) * _893;
        float _896 = ((((((_733 * _727) / _751) + ((_724 * _727) / _736)) * 4.398229598999023f) * exp2((((_865 * _865) * -0.5f) / ((_842 * _842) + _769)) * 1.4426950216293335f)) + ((((_712.x + _688) * 0.25f) - _688) * 6.2831854820251465f)) * _893;
        float _897 = max(0.125f, _503);
        _911 = _507;
        _912 = _504;
        _913 = _505;
        _914 = _506;
        _915 = _452;
        _916 = _503;
        _917 = max(0.009999999776482582f, ((_897 * (_548 - _894)) + _894));
        _918 = max(0.009999999776482582f, (lerp(_895, _549, _897)));
        _919 = max(0.009999999776482582f, (lerp(_896, _550, _897)));
      } else {
        _911 = _507;
        _912 = _504;
        _913 = _505;
        _914 = _506;
        _915 = _452;
        _916 = _503;
        _917 = 0.0f;
        _918 = 0.0f;
        _919 = 0.0f;
      }
    }
    float _926 = -0.0f - min(0.0f, (-0.0f - _317));
    float _927 = -0.0f - min(0.0f, (-0.0f - _318));
    float _928 = -0.0f - min(0.0f, (-0.0f - _319));
    half2 _930 = __3__36__0__0__g_sceneAO.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
    if ((uint)_915 > (uint)11) {
      bool _938 = ((uint)_915 < (uint)19);
      if (!((uint)_915 < (uint)20)) {
        _941 = _938;
        _944 = _941;
        _945 = (_915 == 107);
      } else {
        _944 = _938;
        _945 = true;
      }
    } else {
      if (!((uint)_915 > (uint)10)) {
        _941 = false;
        _944 = _941;
        _945 = (_915 == 107);
      } else {
        _944 = false;
        _945 = true;
      }
    }
    bool _950 = (_915 == 65);
    bool _951 = (_950) || (((_944) || ((((_915 == 96)) || (_945)))));
    float _953 = select(_951, float(_911), 0.0f);
    bool _956 = ((uint)(_915 & 24) > (uint)23);
    if (_956) {
      bool _958 = (_915 == 29);
      if (_958) {
        _963 = float(saturate(_157));
      } else {
        _963 = 0.0f;
      }
      uint _965 = uint((float)(_161 * 255.0h));
      if (_174) {
        _974 = select((((int)(_965) & 128) != 0), 1.0f, 0.0f);
        _975 = (float((uint)((uint)((int)(_965) & 127))) * 0.007874015718698502f);
      } else {
        _974 = 0.0f;
        _975 = 0.0f;
      }
      half _976 = half(_975);
      bool _980 = (_976 > 0.99902344h);
      _985 = _974;
      _986 = _963;
      _987 = _976;
      _988 = select((((_915 == 24)) || (_958)), 0.010002136h, _157);
      _989 = select(_980, 1.0h, _275);
      _990 = select(_980, 1.0h, _276);
      _991 = select(_980, 1.0h, _277);
    } else {
      _985 = 0.0f;
      _986 = 0.0f;
      _987 = select(_951, 0.0h, _911);
      _988 = _157;
      _989 = _275;
      _990 = _276;
      _991 = _277;
    }
    // RenoDX: Foliage green desaturation
    if (FOLIAGE_GREEN_DESAT > 0.0f && ((uint)(_112 - 12) < 7u)) {
      float _fdr = float(_989);
      float _fdg = float(_990);
      float _fdb = float(_991);
      float _fdLum = renodx::color::y::from::BT709(float3(_fdr, _fdg, _fdb));
      float _fdGreenExcess = saturate((_fdg - max(_fdr, _fdb)) * 2.0f);
      float _fdAmount = FOLIAGE_GREEN_DESAT * _fdGreenExcess;
      _fdr = lerp(_fdr, _fdLum, _fdAmount);
      _fdg = lerp(_fdg, _fdLum, _fdAmount);
      _fdb = lerp(_fdb, _fdLum, _fdAmount);
      float _fdDim = lerp(1.0f, 0.90f, _fdAmount);
      _989 = half(_fdr * _fdDim);
      _990 = half(_fdg * _fdDim);
      _991 = half(_fdb * _fdDim);
    }
    int _992 = _915 & -2;
    bool _993 = (_992 == 66);
    bool _994 = (_915 == 54);
    bool _995 = (_994) || (_993);
    float _996 = -0.0f - _394;
    float _997 = -0.0f - _395;
    float _998 = -0.0f - _396;
    float _999 = dot(float3(_996, _997, _998), float3(_346, _347, _348));
    if (_995) {
      _1003 = abs(_999);
    } else {
      _1003 = _999;
    }
    float _1004 = saturate(_1003);
    bool _1006 = ((_110.x & 128) == 0);
    if (_1006) {
      if ((uint)_112 > (uint)52) {
        if (!((((_110.x & 125) == 105)) || (((uint)_112 < (uint)68)))) {
          _1026 = (_112 == 98);
        } else {
          _1026 = true;
        }
      } else {
        if ((uint)_112 > (uint)10) {
          if ((uint)_112 < (uint)20) {
            if (_397 == 14) {
              _1026 = (_112 == 98);
            } else {
              _1026 = true;
            }
          } else {
            if (!((_110.x & 125) == 105)) {
              _1026 = (_112 == 98);
            } else {
              _1026 = true;
            }
          }
        } else {
          _1026 = (_112 == 98);
        }
      }
    } else {
      _1026 = true;
    }
    [branch]
    if (_956) {
      uint _1029 = __3__36__0__0__g_depthOpaque.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
      _1035 = (float((uint)((uint)(_1029.x & 16777215))) * 5.960465188081798e-08f);
    } else {
      _1035 = _107.x;
    }
    float _1063 = mad((_projToPrevProj[3].z), _1035, mad((_projToPrevProj[3].y), _352, ((_projToPrevProj[3].x) * _350))) + (_projToPrevProj[3].w);
    if (_1026) {
      float2 _1070 = __3__36__0__0__g_velocity.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
      _1076 = (_1070.x * 2.0f);
      _1077 = (_1070.y * 2.0f);
    } else {
      _1076 = (((mad((_projToPrevProj[0].z), _1035, mad((_projToPrevProj[0].y), _352, ((_projToPrevProj[0].x) * _350))) + (_projToPrevProj[0].w)) / _1063) - _350);
      _1077 = (((mad((_projToPrevProj[1].z), _1035, mad((_projToPrevProj[1].y), _352, ((_projToPrevProj[1].x) * _350))) + (_projToPrevProj[1].w)) / _1063) - _352);
    }
    float _1079 = _nearFarProj.x / max(1.0000000116860974e-07f, _1035);
    float _1082 = (_1076 * 0.5f) + _104;
    float _1083 = _105 - (_1077 * 0.5f);
    float _1091 = select((((((_1082 < 0.0f)) || ((_1082 > 1.0f)))) || ((((_1083 < 0.0f)) || ((_1083 > 1.0f))))), 1.0f, 0.0f);
    float _1096 = (_1082 * _bufferSizeAndInvSize.x) + -0.5f;
    float _1097 = (_1083 * _bufferSizeAndInvSize.y) + -0.5f;
    int _1100 = int(floor(_1096));
    int _1101 = int(floor(_1097));
    float _1102 = float((int)(_1100));
    float _1103 = float((int)(_1101));
    float _1106 = (_1102 + 0.5f) * _bufferSizeAndInvSize.z;
    float _1107 = (_1103 + 0.5f) * _bufferSizeAndInvSize.w;
    int4 _1110 = __3__36__0__0__g_depthOpaquePrev.GatherRed(__3__40__0__0__g_samplerPoint, float2(_1106, _1107));
    int _1133 = asint(((((uint)((uint)((uint)(_1110.w)) >> 24))) * (16777216u)) + ((uint)(asint(((((uint)((uint)((uint)(_1110.z)) >> 24))) * (65536u)) + ((uint)(asint(((((uint)((uint)((uint)(_1110.y)) >> 24))) * (256u)) + (((uint)((uint)((uint)(_1110.x)) >> 24))))))))));
    if (_1006) {
      if ((uint)_112 > (uint)52) {
        if (!(((_112 == 98)) || (((((_110.x & 125) == 105)) || (((uint)_112 < (uint)68)))))) {
          _1163 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z));
        } else {
          _1163 = 0.0f;
        }
      } else {
        if ((uint)_112 > (uint)10) {
          if ((uint)_112 < (uint)20) {
            if (_397 == 14) {
              _1163 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z));
            } else {
              _1163 = 0.0f;
            }
          } else {
            if (!((_110.x & 125) == 105)) {
              _1163 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z));
            } else {
              _1163 = 0.0f;
            }
          }
        } else {
          _1163 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z));
        }
      }
    } else {
      _1163 = 0.0f;
    }
    float _1171 = _screenPercentage.x * 2.0f;
    float _1172 = _1171 * abs(_104 + -0.5f);
    float _1173 = _screenPercentage.y * 2.0f;
    float _1174 = _1173 * abs(_105 + -0.5f);
    float _1178 = sqrt(dot(float2(_1172, _1174), float2(_1172, _1174)) + 1.0f) * _1079;
    float _1195 = _1171 * abs(_1082 + -0.5f);
    float _1196 = _1173 * abs(_1083 + -0.5f);
    float _1199 = sqrt(dot(float2(_1195, _1196), float2(_1195, _1196)) + 1.0f);
    bool _1214 = (_335) || (((uint)(_915 + -97) < (uint)2));
    float _1216 = _1079 * _1079;
    float _1218 = (_1216 * select(_1214, 0.5f, 0.20000000298023224f)) + 1.0f;
    bool _1222 = ((uint)(_915 + -53) < (uint)15);
    if (_1222) {
      _1241 = (1000.0f - (saturate(float((bool)(uint)((sqrt(((_diffViewPosAccurate.x * _diffViewPosAccurate.x) + (_diffViewPosAccurate.y * _diffViewPosAccurate.y)) + (_diffViewPosAccurate.z * _diffViewPosAccurate.z)) * 50.0f) > 1.0f))) * 875.0f));
    } else {
      _1241 = 50.0f;
    }
    float _1251 = select((((_915 == 57)) || (_1222)), 0.0f, ((max(0.0f, (_1079 + -1.0f)) * 0.10000000149011612f) * _temporalReprojectionParams.y));
    float _1256 = max(0.0f, (abs(_1178 - (_1199 * ((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_1110.x & 16777215))) * 5.960465188081798e-08f))) - _1163))) - _1251));
    float _1257 = max(0.0f, (abs(_1178 - (_1199 * ((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_1110.y & 16777215))) * 5.960465188081798e-08f))) - _1163))) - _1251));
    float _1258 = max(0.0f, (abs(_1178 - (_1199 * ((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_1110.z & 16777215))) * 5.960465188081798e-08f))) - _1163))) - _1251));
    float _1259 = max(0.0f, (abs(_1178 - (_1199 * ((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_1110.w & 16777215))) * 5.960465188081798e-08f))) - _1163))) - _1251));
    float _1260 = _1256 * _1256;
    float _1261 = _1257 * _1257;
    float _1262 = _1258 * _1258;
    float _1263 = _1259 * _1259;
    float _1265 = (-1.4426950216293335f / ((_1216 * 0.10000000149011612f) + 1.0f)) * select(_1214, 0.20000000298023224f, _1241);
    float _1278 = select((_1260 > _1218), 0.0f, exp2(_1260 * _1265));
    float _1279 = select((_1261 > _1218), 0.0f, exp2(_1261 * _1265));
    float _1280 = select((_1262 > _1218), 0.0f, exp2(_1262 * _1265));
    float _1281 = select((_1263 > _1218), 0.0f, exp2(_1263 * _1265));
    if (!_956) {
      int _1283 = _1133 & 127;
      int _1284 = _1133 & 32512;
      int _1285 = _1133 & 8323072;
      int _1286 = _1133 & 2130706432;
      bool _1325 = ((_1283 == 57)) || (((uint)(_1283 + -53) < (uint)15));
      bool _1326 = ((_1284 == 14592)) || (((uint)((((uint)((uint)(_1133)) >> 8) & 127) + -53) < (uint)15));
      bool _1327 = ((_1285 == 3735552)) || (((uint)((((uint)((uint)(_1133)) >> 16) & 127) + -53) < (uint)15));
      bool _1328 = ((_1286 == 956301312)) || (((uint)((((uint)((uint)(_1133)) >> 24) & 127) + -53) < (uint)15));
      if (_1006) {
        _1346 = (((_112 == 57)) || (((uint)(_112 + -53) < (uint)15)));
      } else {
        _1346 = true;
      }
      bool _1355 = (_915 == 6);
      bool _1377 = ((uint)(_915 + -105) < (uint)3);
      bool _1384 = ((_112 == 57)) || (((uint)(_112 + -53) < (uint)15));
      _1418 = (float((bool)((uint)((((_400) || ((((_1283 != 54)) && (((_1133 & 126) != 66)))))) && ((!(((((((_1133 & 128) != 0)) || (_1325)) ^ _1346)) || ((((_1355 ^ (_1283 == 6))) || ((((_1377 ^ (((_1283 == 107)) || (((uint)(_1283 + -105) < (uint)2))))) || ((_1325 ^ _1384)))))))))))) * _1278);
      _1419 = (float((bool)((uint)((((_400) || ((((_1284 != 13824)) && (((_1133 & 32256) != 16896)))))) && ((!(((((((_1133 & 32768) != 0)) || (_1326)) ^ _1346)) || ((((_1355 ^ (_1284 == 1536))) || ((((_1377 ^ ((((_1133 & 32000) == 26880)) || ((_1284 == 27136))))) || ((_1326 ^ _1384)))))))))))) * _1279);
      _1420 = (float((bool)((uint)((((_400) || ((((_1285 != 3538944)) && (((_1133 & 8257536) != 4325376)))))) && ((!(((((((_1133 & 8388608) != 0)) || (_1327)) ^ _1346)) || ((((_1355 ^ (_1285 == 393216))) || ((((_1377 ^ ((((_1133 & 8192000) == 6881280)) || ((_1285 == 6946816))))) || ((_1327 ^ _1384)))))))))))) * _1280);
      _1421 = (float((bool)((uint)((((_400) || ((((_1286 != 905969664)) && (((_1133 & 2113929216) != 1107296256)))))) && ((!(((((((int)_1133 < (int)0)) || (_1328)) ^ _1346)) || ((((_1355 ^ (_1286 == 100663296))) || ((((_1377 ^ ((((_1133 & 2097152000) == 1761607680)) || ((_1286 == 1778384896))))) || ((_1328 ^ _1384)))))))))))) * _1281);
    } else {
      _1418 = _1278;
      _1419 = _1279;
      _1420 = _1280;
      _1421 = _1281;
    }
    int4 _1423 = __3__36__0__0__g_sceneNormalPrev.GatherRed(__3__40__0__0__g_samplerPoint, float2(_1106, _1107));
    float _1442 = min(1.0f, ((float((uint)((uint)(_1423.w & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1443 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1423.w)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1444 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1423.w)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1446 = rsqrt(dot(float3(_1442, _1443, _1444), float3(_1442, _1443, _1444)));
    float _1451 = saturate(dot(float3(_346, _347, _348), float3((_1446 * _1442), (_1446 * _1443), (_1446 * _1444))));
    float _1466 = min(1.0f, ((float((uint)((uint)(_1423.z & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1467 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1423.z)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1468 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1423.z)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1470 = rsqrt(dot(float3(_1466, _1467, _1468), float3(_1466, _1467, _1468)));
    float _1475 = saturate(dot(float3(_346, _347, _348), float3((_1470 * _1466), (_1470 * _1467), (_1470 * _1468))));
    float _1490 = min(1.0f, ((float((uint)((uint)(_1423.x & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1491 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1423.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1492 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1423.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1494 = rsqrt(dot(float3(_1490, _1491, _1492), float3(_1490, _1491, _1492)));
    float _1499 = saturate(dot(float3(_346, _347, _348), float3((_1494 * _1490), (_1494 * _1491), (_1494 * _1492))));
    float _1514 = min(1.0f, ((float((uint)((uint)(_1423.y & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1515 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1423.y)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1516 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_1423.y)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _1518 = rsqrt(dot(float3(_1514, _1515, _1516), float3(_1514, _1515, _1516)));
    float _1523 = saturate(dot(float3(_346, _347, _348), float3((_1518 * _1514), (_1518 * _1515), (_1518 * _1516))));
    float _1526 = select(((_994) || (((_993) || (_1214)))), 0.009999999776482582f, 1.0f);
    float _1543 = _1096 - _1102;
    float _1544 = _1097 - _1103;
    float _1545 = 1.0f - _1543;
    float _1546 = 1.0f - _1544;
    float _1551 = (_1545 * _1544) * _1418;
    float _1553 = (_1544 * _1543) * _1419;
    float _1555 = (_1546 * _1543) * _1420;
    float _1557 = (_1546 * _1545) * _1421;
    float _1559 = saturate(select(_956, 1.0f, (pow(_1499, _1526))) * _1551);
    float _1560 = saturate(select(_956, 1.0f, (pow(_1523, _1526))) * _1553);
    float _1561 = saturate(select(_956, 1.0f, (pow(_1475, _1526))) * _1555);
    float _1562 = saturate(select(_956, 1.0f, (pow(_1451, _1526))) * _1557);
    int4 _1564 = asint(__3__37__0__0__g_structureCounterBuffer.Load4(8));
    [branch]
    if (!(WaveReadLaneFirst(_1564.x) == 0)) {
      uint _1572 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(((int)(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))) >> 5)), ((int)(((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))) >> 5)), 0));
      int _1574 = _1572.x & 4;
      int _1576 = (uint)((uint)(_1574)) >> 2;
      if (!(_1574 == 0)) {
        _1584 = max((saturate(dot(float3(_926, _927, _928), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.009999999776482582f) * 0.875f), _1091);
        _1585 = _1576;
      } else {
        _1584 = _1091;
        _1585 = _1576;
      }
    } else {
      _1584 = _1091;
      _1585 = 0;
    }
    float _1595 = saturate(max(_1584, (((_environmentLightingHistory[1].w) + _temporalReprojectionParams.w) + _renderParams.y)));
    half4 _1598 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_1100, ((int)((uint)(_1101) + 1u)), 0));
    half4 _1604 = __3__36__0__0__g_diffuseResultPrev.Load(int3(((int)((uint)(_1100) + 1u)), ((int)((uint)(_1101) + 1u)), 0));
    half4 _1609 = __3__36__0__0__g_diffuseResultPrev.Load(int3(((int)((uint)(_1100) + 1u)), _1101, 0));
    half4 _1614 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_1100, _1101, 0));
    float _1619 = dot(float4(_1559, _1560, _1561, _1562), float4(1.0f, 1.0f, 1.0f, 1.0f));
    float _1628 = saturate(dot(float4(_1559, _1560, _1561, _1562), float4(float(_1598.w), float(_1604.w), float(_1609.w), float(_1614.w))) * (1.0f / max(1.0f, _1619)));
    float _1632 = sqrt((_1077 * _1077) + (_1076 * _1076));
    float _1633 = _1632 * 50.0f;
    if (_1222) {
      _1642 = saturate(1.0f - _1633);
    } else {
      _1642 = (1.0f - (saturate(_1633) * 0.5f));
    }
    float _1646 = max(1.0f, (_bufferSizeAndInvSize.w * 2160.0f));
    float _1651 = (_1628 * _1628) * 4.0f;
    float4 _1662 = __3__36__0__0__g_manyLightsMoments.SampleLevel(__3__40__0__0__g_sampler, float2(_104, _105), 0.0f);
    float _1666 = saturate(_1662.w);
    float _1668 = 1.0f / max(9.999999974752427e-07f, _1619);
    float _1669 = _1668 * _1559;
    float _1670 = _1668 * _1560;
    float _1671 = _1668 * _1561;
    float _1672 = _1668 * _1562;
    float _1673 = saturate(saturate(max(_1595, (1.0f / ((saturate(_1651) * min(31.0f, ((_1642 * 15.0f) * _1646))) + 1.0f))) + _renderParams.z));
    float _1715 = 1.0f / _exposure4.x;
    float _1732 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1672 * float(_1614.x)) + ((_1671 * float(_1609.x)) + ((_1669 * float(_1598.x)) + (_1670 * float(_1604.x))))))) * _exposure4.y)))));
    float _1733 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1672 * float(_1614.y)) + ((_1671 * float(_1609.y)) + ((_1669 * float(_1598.y)) + (_1670 * float(_1604.y))))))) * _exposure4.y)))));
    float _1734 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1672 * float(_1614.z)) + ((_1671 * float(_1609.z)) + ((_1669 * float(_1598.z)) + (_1670 * float(_1604.z))))))) * _exposure4.y)))));
    if (((_915 != 54)) && ((((_992 != 66)) && ((_renderParams.y == 0.0f))))) {
      float _1742 = dot(float3(_1732, _1733, _1734), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _1757 = ((min(_1742, _1662.y) / max(9.999999974752427e-07f, _1742)) * _1666) + saturate(1.0f - _1666);
      _1762 = saturate((saturate(((_1662.x - _1742) * 5.0f) / max(9.999999974752427e-07f, _1662.x)) * 0.5f) + _1673);
      _1763 = (_1757 * _1732);
      _1764 = (_1757 * _1733);
      _1765 = (_1757 * _1734);
    } else {
      _1762 = _1673;
      _1763 = _1732;
      _1764 = _1733;
      _1765 = _1734;
    }
    float _1774 = ((_926 - _1763) * _1762) + _1763;
    float _1775 = ((_927 - _1764) * _1762) + _1764;
    float _1776 = ((_928 - _1765) * _1762) + _1765;
    __3__38__0__1__g_diffuseResultUAV[int2(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))))] = half4(half(_1774), half(_1775), half(_1776), half(saturate(_1628 + 0.0625f)));
    float _1783 = float(_989);
    float _1784 = float(_990);
    float _1785 = float(_991);
    if (_915 == 53) {
      _1792 = saturate(((_1784 + _1783) + _1785) * 1.2000000476837158f);
    } else {
      _1792 = 1.0f;
    }
    float _1793 = float(_987);
    float _1799 = (0.699999988079071f / min(max(max(max(_1783, _1784), _1785), 0.009999999776482582f), 0.699999988079071f)) * _1792;
    float _1809 = (((_1799 * _1783) + -0.03999999910593033f) * _1793) + 0.03999999910593033f;
    float _1810 = (((_1799 * _1784) + -0.03999999910593033f) * _1793) + 0.03999999910593033f;
    float _1811 = (((_1799 * _1785) + -0.03999999910593033f) * _1793) + 0.03999999910593033f;
    if (!_956) {
      _1817 = saturate(1.0h - _930.x);
    } else {
      _1817 = 1.0h;
    }
    bool _1821 = ((_915 == 98)) || ((_992 == 96));
    if (!_1821) {
      bool __branch_chain_1822;
      if ((uint)(_915 + -105) < (uint)2) {
        _1829 = _174;
        __branch_chain_1822 = true;
      } else {
        if (!((uint)(_915 + -11) < (uint)9)) {
          _1829 = false;
          __branch_chain_1822 = true;
        } else {
          _1860 = 0.0h;
          _1861 = _915;
          _1862 = 0.0f;
          _1863 = 0.0f;
          _1864 = 0.0f;
          __branch_chain_1822 = false;
        }
      }
      if (__branch_chain_1822) {
        _1829 = _174;
      }
      bool _1831 = ((_915 == 107)) || (_1829);
      half _1834 = select(_1831, 0.0h, _987);
      if ((_1831) || ((!_950))) {
        if (_915 == 33) {
          uint _1846 = uint((_clothLightingCategory.x * _416) + 0.5f);
          if (((_418 > 0.0f)) && (((uint)(int)(_1846) < (uint)(int)(uint(_clothLightingCategory.x))))) {
            _1860 = _1834;
            _1861 = _915;
            _1862 = min((1.0f - ((_clothLightingParameter[_1846]).y)), ((_clothLightingParameter[_1846]).x));
            _1863 = saturate(_417);
            _1864 = ((_clothLightingParameter[_1846]).x);
          } else {
            _1860 = _1834;
            _1861 = _915;
            _1862 = 0.0f;
            _1863 = 0.0f;
            _1864 = 0.0f;
          }
        } else {
          if (_915 == 55) {
            if (!(_418 < 0.0010000000474974513f)) {
              uint _1846 = uint((_clothLightingCategory.x * _416) + 0.5f);
              if (((_418 > 0.0f)) && (((uint)(int)(_1846) < (uint)(int)(uint(_clothLightingCategory.x))))) {
                _1860 = _1834;
                _1861 = _915;
                _1862 = min((1.0f - ((_clothLightingParameter[_1846]).y)), ((_clothLightingParameter[_1846]).x));
                _1863 = saturate(_417);
                _1864 = ((_clothLightingParameter[_1846]).x);
              } else {
                _1860 = _1834;
                _1861 = _915;
                _1862 = 0.0f;
                _1863 = 0.0f;
                _1864 = 0.0f;
              }
            } else {
              _1860 = _1834;
              _1861 = 53;
              _1862 = 0.0f;
              _1863 = 0.0f;
              _1864 = 0.0f;
            }
          } else {
            _1860 = _1834;
            _1861 = _915;
            _1862 = 0.0f;
            _1863 = 0.0f;
            _1864 = 0.0f;
          }
        }
      } else {
        _1860 = 0.0h;
        _1861 = 65;
        _1862 = 0.0f;
        _1863 = 0.0f;
        _1864 = 0.0f;
      }
    } else {
      _1860 = 0.0h;
      _1861 = _915;
      _1862 = 0.0f;
      _1863 = 0.0f;
      _1864 = 0.0f;
    }
    float _1866 = dot(float3(_394, _395, _396), float3(_346, _347, _348)) * 2.0f;
    float _1870 = _394 - (_1866 * _346);
    float _1871 = _395 - (_1866 * _347);
    float _1872 = _396 - (_1866 * _348);
    float _1874 = rsqrt(dot(float3(_1870, _1871, _1872), float3(_1870, _1871, _1872)));
    float _1875 = _1870 * _1874;
    float _1876 = _1871 * _1874;
    float _1877 = _1872 * _1874;
    float _1879 = abs(dot(float3(_346, _347, _348), float3(_218, _219, _220)));
    float _1885 = __3__36__0__0__g_specularRayHitDistance.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_104, _105), 0.0f);
    float _1887 = float(_988);
    float _1889 = ddx_coarse(_218);
    float _1890 = ddx_coarse(_219);
    float _1891 = ddx_coarse(_220);
    float _1892 = ddy_coarse(_218);
    float _1893 = ddy_coarse(_219);
    float _1894 = ddy_coarse(_220);
    float _1908 = select((((_1887 < 0.800000011920929f)) && (((1.0f / ((((sqrt(max(dot(float3(_1889, _1890, _1891), float3(_1889, _1890, _1891)), dot(float3(_1892, _1893, _1894), float3(_1892, _1893, _1894)))) * 10.0f) + saturate(1.0f - (_1879 * _1879))) * (10.0f / (_116 + 0.10000000149011612f))) + 1.0f)) > 0.9900000095367432f))), _1885.x, 0.0f);
    float _1909 = _1908 * _1875;
    float _1910 = _1908 * _1876;
    float _1911 = _1908 * _1877;
    float _1916 = dot(float3(_1909, _1910, _1911), float3((-0.0f - _346), (-0.0f - _347), (-0.0f - _348))) * 2.0f;
    float _1921 = ((_1916 * _346) + _389) + _1909;
    float _1923 = ((_1916 * _347) + _390) + _1910;
    float _1925 = ((_1916 * _348) + _391) + _1911;
    float _1949 = mad((_viewProjRelative[0].z), _1925, mad((_viewProjRelative[0].y), _1923, (_1921 * (_viewProjRelative[0].x)))) + (_viewProjRelative[0].w);
    float _1953 = mad((_viewProjRelative[1].z), _1925, mad((_viewProjRelative[1].y), _1923, (_1921 * (_viewProjRelative[1].x)))) + (_viewProjRelative[1].w);
    float _1957 = mad((_viewProjRelative[2].z), _1925, mad((_viewProjRelative[2].y), _1923, (_1921 * (_viewProjRelative[2].x)))) + (_viewProjRelative[2].w);
    float _1961 = mad((_viewProjRelative[3].z), _1925, mad((_viewProjRelative[3].y), _1923, (_1921 * (_viewProjRelative[3].x)))) + (_viewProjRelative[3].w);
    float _1999 = mad((_projToPrevProj[3].w), _1961, mad((_projToPrevProj[3].z), _1957, mad((_projToPrevProj[3].y), _1953, ((_projToPrevProj[3].x) * _1949))));
    float _2000 = mad((_projToPrevProj[0].w), _1961, mad((_projToPrevProj[0].z), _1957, mad((_projToPrevProj[0].y), _1953, ((_projToPrevProj[0].x) * _1949)))) / _1999;
    float _2001 = mad((_projToPrevProj[1].w), _1961, mad((_projToPrevProj[1].z), _1957, mad((_projToPrevProj[1].y), _1953, ((_projToPrevProj[1].x) * _1949)))) / _1999;
    float _2005 = max(1.0000000116860974e-07f, (mad((_projToPrevProj[2].w), _1961, mad((_projToPrevProj[2].z), _1957, mad((_projToPrevProj[2].y), _1953, ((_projToPrevProj[2].x) * _1949)))) / _1999));
    float _2041 = mad((_invViewProjRelativePrev[3].z), _2005, mad((_invViewProjRelativePrev[3].y), _2001, ((_invViewProjRelativePrev[3].x) * _2000))) + (_invViewProjRelativePrev[3].w);
    float _2045 = ((mad((_invViewProjRelativePrev[0].z), _2005, mad((_invViewProjRelativePrev[0].y), _2001, ((_invViewProjRelativePrev[0].x) * _2000))) + (_invViewProjRelativePrev[0].w)) / _2041) - _1921;
    float _2046 = ((mad((_invViewProjRelativePrev[1].z), _2005, mad((_invViewProjRelativePrev[1].y), _2001, ((_invViewProjRelativePrev[1].x) * _2000))) + (_invViewProjRelativePrev[1].w)) / _2041) - _1923;
    float _2047 = ((mad((_invViewProjRelativePrev[2].z), _2005, mad((_invViewProjRelativePrev[2].y), _2001, ((_invViewProjRelativePrev[2].x) * _2000))) + (_invViewProjRelativePrev[2].w)) / _2041) - _1925;
    float _2048 = dot(float3(_2045, _2046, _2047), float3(_1875, _1876, _1877));
    float _2052 = _2045 - (_2048 * _1875);
    float _2053 = _2046 - (_2048 * _1876);
    float _2054 = _2047 - (_2048 * _1877);
    float _2073 = exp2(log2((saturate(_1908 * 0.125f) * (sqrt(1.0f - saturate(sqrt(((_2052 * _2052) + (_2053 * _2053)) + (_2054 * _2054)) / max(0.0010000000474974513f, _1908))) + -1.0f)) + 1.0f) * 8.0f);
    float _2074 = _2073 * _1499;
    float _2075 = _2073 * _1523;
    float _2076 = _2073 * _1475;
    float _2077 = _2073 * _1451;
    bool _2080 = (_renderParams.z > 0.0f);
    float _2082 = float(1.0h - _988);
    float _2086 = (_2000 - (_1949 / _1961)) - _1076;
    float _2087 = (_2001 - (_1953 / _1961)) - _1077;
    float _2096 = saturate((((_2082 * _2082) * (1.0f - (_1004 * 0.8999999761581421f))) * sqrt((_2087 * _2087) + (_2086 * _2086))) * select(_2080, 2000.0f, 500.0f));
    int _2101 = _1861 & -2;
    bool _2104 = (_1861 == 29);
    float _2107 = select(((((_956) || (_2104))) || ((((_2101 == 24)) || ((_renderParams.y > 0.0f))))), 1.0f, float(_930.y));
    float _2111 = float(_1860);
    float _2116 = min(max((_cavityParams.y + -1.0f), 0.0f), 2.0f);
    float _2142 = saturate(saturate(1.0f - (((_2111 * _116) / max(0.0010000000474974513f, _1004)) * 0.0010000000474974513f)) * 1.25f) * saturate(((((-0.05000000074505806f - (_2116 * 0.07500000298023224f)) + max(0.019999999552965164f, _1887)) + (saturate(_116 * 0.02500000037252903f) * 0.10000000149011612f)) * min(max((_116 + 1.0f), 5.0f), 50.0f)) * (1.0f - (saturate(_2111) * 0.75f)));
    if (_1861 == 64) {
      _2151 = ((saturate(_116 * 0.25f) * (_2142 + -0.39990234375f)) + 0.39990234375f);
    } else {
      _2151 = _2142;
    }
    float _2153 = (_2116 * 16.0f) + 16.0f;
    float _2159 = select((_2116 > 1.0f), 0.0f, saturate((1.0f / _2153) * (_116 - _2153)));
    do {
    if (_1861 == 105) {
      _2170 = 1.0f;
      _2174 = select((_1861 == 65), 0.0f, _2170);
      break;
    } else {
      if (!((uint)(_1861 & 24) > (uint)23)) {
        _2170 = select((_1861 == 107), 1.0f, ((_2159 + _2151) - (_2159 * _2151)));
        _2174 = select((_1861 == 65), 0.0f, _2170);
        break;
      } else {
        _2174 = 0.0f;
      }
    }
    } while(false);
    float _2178 = select((_lightingParams.y == 0.0f), 0.0f, _2174);
    float _2188 = select((((_1861 == 57)) || (((uint)((int)((uint)(_1861) + (uint)(-53))) < (uint)15))), 31.0f, 63.0f);
    float _2196 = (saturate((float((saturate(_988 * 4.0h) * 1900.0h) + 100.0h) * _1632) * (1.0f - (_2178 * 0.75f))) * (7.0f - _2188)) + _2188;
    if ((uint)((int)((uint)(_1861) + (uint)(-12))) < (uint)9) {
      _2206 = ((saturate(_116 * 0.004999999888241291f) * (_2196 + -2.0f)) + 2.0f);
    } else {
      _2206 = _2196;
    }
    half _2210 = max(0.040008545h, _988);
    float _2228 = saturate(max(max(_1595, select(_2080, _2096, 0.0f)), (1.0f / (((saturate((_1646 * _1646) * _1651) * min(64.0f, ((_2206 + 1.0f) * _1646))) * ((saturate((_2178 + (_116 * 0.0078125f)) + float((_2210 * _2210) * 64.0h)) * 0.9375f) + 0.0625f)) + 1.0f))));
    bool __defer_2205_2251 = false;
    if ((uint)_1861 > (uint)52) {
      if ((uint)_1861 < (uint)68) {
        if (_2101 == 66) {
          _2261 = _2074;
          _2262 = _2075;
          _2263 = _2076;
          _2264 = _2077;
          _2267 = _2261;
          _2268 = _2262;
          _2269 = _2263;
          _2270 = _2264;
          _2271 = max(0.89990234h, _988);
        } else {
          if (!(_1861 == 54)) {
            float _2239 = _2074 * _2074;
            float _2240 = _2075 * _2075;
            float _2241 = _2076 * _2076;
            float _2242 = _2077 * _2077;
            float _2243 = _2239 * _2239;
            float _2244 = _2240 * _2240;
            float _2245 = _2241 * _2241;
            float _2246 = _2242 * _2242;
            _2252 = (_2243 * _2243);
            _2253 = (_2244 * _2244);
            _2254 = (_2245 * _2245);
            _2255 = (_2246 * _2246);
          } else {
            _2252 = _2074;
            _2253 = _2075;
            _2254 = _2076;
            _2255 = _2077;
          }
          __defer_2205_2251 = true;
        }
      } else {
        _2267 = _2074;
        _2268 = _2075;
        _2269 = _2076;
        _2270 = _2077;
        _2271 = max(0.099975586h, _988);
      }
    } else {
      _2252 = _2074;
      _2253 = _2075;
      _2254 = _2076;
      _2255 = _2077;
      __defer_2205_2251 = true;
    }
    if (__defer_2205_2251) {
      if (((_1861 == 54)) || ((_2101 == 66))) {
        _2261 = _2252;
        _2262 = _2253;
        _2263 = _2254;
        _2264 = _2255;
        _2267 = _2261;
        _2268 = _2262;
        _2269 = _2263;
        _2270 = _2264;
        _2271 = max(0.89990234h, _988);
      } else {
        _2267 = _2252;
        _2268 = _2253;
        _2269 = _2254;
        _2270 = _2255;
        _2271 = max(0.099975586h, _988);
      }
    }
    float _2272 = float(_2271);
    float _2273 = _2272 * _2272;
    float _2274 = _2273 * _2273;
    float _2287 = (((_2274 * _2267) - _2267) * _2267) + 1.0f;
    float _2288 = (((_2274 * _2268) - _2268) * _2268) + 1.0f;
    float _2289 = (((_2274 * _2269) - _2269) * _2269) + 1.0f;
    float _2290 = (((_2274 * _2270) - _2270) * _2270) + 1.0f;
    float _2315 = saturate(select(_2104, 1.0f, saturate((_2274 / (_2287 * _2287)) * _2267)) * _1551);
    float _2316 = saturate(select(_2104, 1.0f, saturate((_2274 / (_2288 * _2288)) * _2268)) * _1553);
    float _2317 = saturate(select(_2104, 1.0f, saturate((_2274 / (_2289 * _2289)) * _2269)) * _1555);
    float _2318 = saturate(select(_2104, 1.0f, saturate((_2274 / (_2290 * _2290)) * _2270)) * _1557);
    bool _2320 = ((uint)(_1861 & 24) > (uint)23);
    if (((_1861 != 29)) && (_2320)) {
      float _2337 = mad((_projToPrevProj[3].z), _107.x, mad((_projToPrevProj[3].y), _352, ((_projToPrevProj[3].x) * _350))) + (_projToPrevProj[3].w);
      float _2340 = ((mad((_projToPrevProj[0].z), _107.x, mad((_projToPrevProj[0].y), _352, ((_projToPrevProj[0].x) * _350))) + (_projToPrevProj[0].w)) / _2337) - _350;
      float _2341 = ((mad((_projToPrevProj[1].z), _107.x, mad((_projToPrevProj[1].y), _352, ((_projToPrevProj[1].x) * _350))) + (_projToPrevProj[1].w)) / _2337) - _352;
      float _2349 = (((_2340 * 0.5f) + _104) * _bufferSizeAndInvSize.x) + -0.5f;
      float _2350 = ((_105 - (_2341 * 0.5f)) * _bufferSizeAndInvSize.y) + -0.5f;
      int _2353 = int(floor(_2349));
      int _2354 = int(floor(_2350));
      float _2357 = _2349 - float((int)(_2353));
      float _2358 = _2350 - float((int)(_2354));
      float _2359 = 1.0f - _2357;
      float _2360 = 1.0f - _2358;
      _2388 = saturate((sqrt((_2341 * _2341) + (_2340 * _2340)) * 100.0f) + 0.125f);
      _2389 = _2353;
      _2390 = _2354;
      _2391 = (_2359 * _2358);
      _2392 = (_2358 * _2357);
      _2393 = (_2360 * _2357);
      _2394 = (_2360 * _2359);
    } else {
      float _2374 = saturate(_bufferSizeAndInvSize.y * 0.0006944444612599909f);
      if (_2104) {
        _2388 = saturate((_2228 + (_2096 * 0.5f)) + min(0.5f, (((_2374 * _2374) * _986) / (((_116 * _116) * 0.004999999888241291f) + 1.0f))));
        _2389 = _1100;
        _2390 = _1101;
        _2391 = _2315;
        _2392 = _2316;
        _2393 = _2317;
        _2394 = _2318;
      } else {
        _2388 = _2228;
        _2389 = _1100;
        _2390 = _1101;
        _2391 = _2315;
        _2392 = _2316;
        _2393 = _2317;
        _2394 = _2318;
      }
    }
    bool _2395 = (_2111 > 0.20000000298023224f);
    half4 _2398 = __3__36__0__0__g_specularResultPrev.Load(int3(_2389, ((int)((uint)(_2390) + 1u)), 0));
    float _2411 = float((bool)((uint)(!(_2395 ^ (_2398.w < 0.0h))))) * _2391;
    half4 _2418 = __3__36__0__0__g_specularResultPrev.Load(int3(((int)((uint)(_2389) + 1u)), ((int)((uint)(_2390) + 1u)), 0));
    float _2431 = float((bool)((uint)(!(_2395 ^ (_2418.w < 0.0h))))) * _2392;
    half4 _2441 = __3__36__0__0__g_specularResultPrev.Load(int3(((int)((uint)(_2389) + 1u)), _2390, 0));
    float _2454 = float((bool)((uint)(!(_2395 ^ (_2441.w < 0.0h))))) * _2393;
    half4 _2464 = __3__36__0__0__g_specularResultPrev.Load(int3(_2389, _2390, 0));
    float _2477 = float((bool)((uint)(!(_2395 ^ (_2464.w < 0.0h))))) * _2394;
    float _2497 = 1.0f / max(1.0000000168623835e-16f, dot(float4(_2411, _2431, _2454, _2477), float4(1.0f, 1.0f, 1.0f, 1.0f)));
    float _2499 = -0.0f - (min(0.0f, (-0.0f - ((((_2411 * float(_2398.x)) + (_2431 * float(_2418.x))) + (_2454 * float(_2441.x))) + (_2477 * float(_2464.x))))) * _2497);
    float _2501 = -0.0f - (min(0.0f, (-0.0f - ((((_2411 * float(_2398.y)) + (_2431 * float(_2418.y))) + (_2454 * float(_2441.y))) + (_2477 * float(_2464.y))))) * _2497);
    float _2503 = -0.0f - (min(0.0f, (-0.0f - ((((_2411 * float(_2398.z)) + (_2431 * float(_2418.z))) + (_2454 * float(_2441.z))) + (_2477 * float(_2464.z))))) * _2497);
    float _2504 = _2497 * min(0.0f, (-0.0f - ((((_2411 * abs(float(_2398.w))) + (_2431 * abs(float(_2418.w)))) + (_2454 * abs(float(_2441.w)))) + (_2477 * abs(float(_2464.w))))));
    if (((_1861 != 54)) && ((((_2101 != 66)) && ((_renderParams.y == 0.0f))))) {
      float _2511 = dot(float3(_2499, _2501, _2503), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _2518 = ((min(_2511, _1662.z) / max(9.999999717180685e-10f, _2511)) * _1666) + saturate(1.0f - _1666);
      _2523 = (_2518 * _2499);
      _2524 = (_2518 * _2501);
      _2525 = (_2518 * _2503);
    } else {
      _2523 = _2499;
      _2524 = _2501;
      _2525 = _2503;
    }
    float _2526 = _2523 * _exposure4.y;
    float _2527 = _2524 * _exposure4.y;
    float _2528 = _2525 * _exposure4.y;
    float _2531 = saturate(_2388 + _renderParams.z);
    float _2543 = ((max(0.0010000000474974513f, float(_1817)) + _2504) * _2388) - _2504;
    float _2553 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_2531 * ((_2107 * _321.x) - _2526)) + _2526))));
    float _2554 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_2531 * ((_2107 * _321.y) - _2527)) + _2527))));
    float _2555 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_2531 * ((_2107 * _321.z) - _2528)) + _2528))));
    __3__38__0__1__g_specularResultUAV[int2(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))))] = half4(half(_2553), half(_2554), half(_2555), half(select(_2395, (-0.0f - _2543), _2543)));
    float _2563 = select(_2320, 0.0f, _2543);
    float _2568 = float(half(lerp(_2563, 1.0f, _1887)));
    bool _2569 = (_2101 == 64);
    int _2571 = ((int)(uint)((int)(_175))) ^ 1;
    if ((((int)(uint)((int)(_2569))) & _2571) == 0) {
      _2588 = saturate(exp2((_2568 * _2568) * (_116 * -0.005770780146121979f)));
    } else {
      _2588 = select((_cavityParams.z > 0.0f), select(_175, 0.0f, _417), 1.0f);
    }
    bool _2591 = (_cavityParams.x == 0.0f);
    float _2592 = select(_2591, 1.0f, _2588);
    if (_2569) {
      _2598 = (_2592 * _1809);
      _2599 = (_2592 * _1810);
      _2600 = (_2592 * _1811);
    } else {
      _2598 = _1809;
      _2599 = _1810;
      _2600 = _1811;
    }
    if (((_1861 == 54)) || ((_2101 == 66))) {
      float2 _2615 = __3__36__0__0__g_hairBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, (1.0f - saturate(abs(dot(float3(_912, _913, _914), float3(_394, _395, _396)))))), (1.0f - max(0.75f, (_2568 * 2.0f)))), 0.0f);
      float2 _2621 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1004), (1.0f - _2568)), 0.0f);
      float _2628 = ((_2621.x - _2615.x) * _916) + _2615.x;
      float _2629 = ((_2621.y - _2615.y) * _916) + _2615.y;
      float _2631 = (_2628 * 0.009999999776482582f) + _2629;
      _2795 = _2628;
      _2796 = _2629;
      _2797 = _2631;
      _2798 = _2631;
      _2799 = _2631;
    } else {
      if ((uint)((int)((uint)(_1861) + (uint)(-97))) < (uint)2) {
        if (!(abs(_219) > 0.9900000095367432f)) {
          float _2639 = -0.0f - _220;
          float _2641 = rsqrt(dot(float3(_2639, 0.0f, _218), float3(_2639, 0.0f, _218)));
          _2645 = (_2641 * _2639);
          _2646 = (_2641 * _218);
        } else {
          _2645 = 1.0f;
          _2646 = 0.0f;
        }
        float _2648 = -0.0f - (_219 * _2646);
        float _2651 = (_2646 * _218) - (_2645 * _220);
        float _2652 = _2645 * _219;
        float _2654 = rsqrt(dot(float3(_2648, _2651, _2652), float3(_2648, _2651, _2652)));
        float _2662 = _viewPos.x + _389;
        float _2663 = _viewPos.y + _390;
        float _2664 = _viewPos.z + _391;
        float4 _2669 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_2645, 0.0f, _2646), float3(_2662, _2663, _2664)), dot(float3((_2654 * _2648), (_2651 * _2654), (_2654 * _2652)), float3(_2662, _2663, _2664))), 0.0f);
        float _2673 = _2669.x + -0.5f;
        float _2674 = _2669.y + -0.5f;
        float _2675 = _2669.z + -0.5f;
        float _2677 = rsqrt(dot(float3(_2673, _2674, _2675), float3(_2673, _2674, _2675)));
        float _2681 = (_2673 * _2677) + _346;
        float _2682 = (_2674 * _2677) + _347;
        float _2683 = (_2675 * _2677) + _348;
        float _2685 = rsqrt(dot(float3(_2681, _2682, _2683), float3(_2681, _2682, _2683)));
        float2 _2698 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1004), (1.0f - _2568)), 0.0f);
        float _2705 = _2698.y + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3((_2681 * _2685), (_2682 * _2685), (_2683 * _2685))))) * 512.0f) * 20.0f);
        _2795 = _2698.x;
        _2796 = _2698.y;
        _2797 = (_2705 + (_2698.x * _2598));
        _2798 = (_2705 + (_2698.x * _2599));
        _2799 = (_2705 + (_2698.x * _2600));
      } else {
        if (_2569) {
          if (_1861 == 65) {
            _2778 = _2598;
            _2779 = _2599;
            _2780 = _2600;
            float2 _2785 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1004), (1.0f - _2568)), 0.0f);
            _2795 = _2785.x;
            _2796 = _2785.y;
            _2797 = ((_2785.x * _2778) + _2785.y);
            _2798 = ((_2785.x * _2779) + _2785.y);
            _2799 = ((_2785.x * _2780) + _2785.y);
          } else {
            float _2715 = min(0.9900000095367432f, _1004);
            float2 _2720 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_2715, saturate(1.0f - (_2568 * 1.3300000429153442f))), 0.0f);
            float2 _2725 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_2715, saturate(1.0f - (_2568 * 0.47998046875f))), 0.0f);
            float _2729 = (_2725.x + _2720.x) * 0.5f;
            float _2731 = (_2725.y + _2720.y) * 0.5f;
            _2795 = _2729;
            _2796 = _2731;
            _2797 = ((_2729 * _2598) + _2731);
            _2798 = ((_2729 * _2599) + _2731);
            _2799 = ((_2729 * _2600) + _2731);
          }
        } else {
          if (((_1861 == 33)) || ((_1861 == 55))) {
            float _2748 = max(dot(float3(_1783, _1784, _1785), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)), 0.03999999910593033f);
            float _2752 = sqrt(_1783) - _2748;
            float _2753 = sqrt(_1784) - _2748;
            float _2754 = sqrt(_1785) - _2748;
            float _2761 = saturate(1.0f - (pow(_1004, 4.0f)));
            _2778 = ((((_2752 * _1862) + _2748) + (_2761 * (_2752 * (_1864 - _1862)))) * _1863);
            _2779 = ((((_2753 * _1862) + _2748) + ((_2753 * (_1864 - _1862)) * _2761)) * _1863);
            _2780 = ((((_2754 * _1862) + _2748) + ((_2754 * (_1864 - _1862)) * _2761)) * _1863);
          } else {
            _2778 = _2598;
            _2779 = _2599;
            _2780 = _2600;
          }
          float2 _2785 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1004), (1.0f - _2568)), 0.0f);
          _2795 = _2785.x;
          _2796 = _2785.y;
          _2797 = ((_2785.x * _2778) + _2785.y);
          _2798 = ((_2785.x * _2779) + _2785.y);
          _2799 = ((_2785.x * _2780) + _2785.y);
        }
      }
    }
    float _2802 = select(((_2569) || (_2320)), 1.0f, _2592) * _1715;
    float _2809 = _1774 * _1715;
    float _2810 = _1775 * _1715;
    float _2811 = _1776 * _1715;
    bool __defer_2794_3068 = false;
    if ((uint)_915 > (uint)52) {
      if ((((uint)_915 < (uint)68)) || (_956)) {
        _3069 = _987;
        _3070 = _988;
        _3071 = _989;
        _3072 = _990;
        _3073 = _991;
        _3074 = _2563;
        __defer_2794_3068 = true;
      } else {
        if (!(((_915 == 6)) || ((((_992 == 106)) || (((((uint)(_915 + -27) < (uint)2)) || ((((_915 == 105)) || ((_915 == 26)))))))))) {
          if (!(_915 == 7)) {
            float _2836 = exp2(log2(_2563) * (saturate(_116 * 0.03125f) + 1.0f));
            float4 _2846 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_104, _105), 0.0f);
            bool __defer_2830_2864 = false;
            bool __branch_chain_2830;
            if (((_915 == 15)) || ((((_992 == 12)) || (((_915 & -4) == 16))))) {
              _2865 = false;
              _2866 = true;
              __branch_chain_2830 = true;
            } else {
              if (!((uint)_915 > (uint)10)) {
                _2865 = true;
                _2866 = false;
                __branch_chain_2830 = true;
              } else {
                if ((uint)_915 < (uint)20) {
                  _2865 = false;
                  _2866 = false;
                  __branch_chain_2830 = true;
                } else {
                  if (!(_915 == 97)) {
                    _2865 = (_915 != 107);
                    _2866 = false;
                    __branch_chain_2830 = true;
                  } else {
                    _3058 = _1793;
                    _3059 = _1887;
                    _3060 = _1783;
                    _3061 = _1784;
                    _3062 = _1785;
                    __branch_chain_2830 = false;
                  }
                }
              }
            }
            if (__branch_chain_2830) {
              __defer_2830_2864 = true;
            }
            if (__defer_2830_2864) {
              if (_2846.w < 1.0f) {
                if ((_weatherCheckFlag & 5) == 5) {
                  bool _2876 = (_915 == 36);
                  if (!_2876) {
                    float4 _2896 = __3__36__0__0__g_climateSandTex.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((((_viewPos.x + _389) / _climateTextureOnePixelMeter.x) + float((int)((int)(_climateTextureSize.x >> 1)))) / float((int)(_climateTextureSize.x))), (1.0f - ((((_viewPos.z + _391) / _climateTextureOnePixelMeter.y) + float((int)((int)(_climateTextureSize.y >> 1)))) / float((int)(_climateTextureSize.y))))), 0.0f);
                    _2902 = _2896.x;
                    _2903 = _2896.y;
                    _2904 = _2896.z;
                    _2905 = _2896.w;
                  } else {
                    _2902 = 0.11999999731779099f;
                    _2903 = 0.11999999731779099f;
                    _2904 = 0.10000000149011612f;
                    _2905 = 0.5f;
                  }
                  float _2912 = 1.0f - saturate(((_viewPos.y + _390) - _paramGlobalSand.x) / _paramGlobalSand.y);
                  if (!(_2912 <= 0.0f)) {
                    float _2915 = saturate(_2836);
                    float _2928 = ((_2903 * 0.3395099937915802f) + (_2902 * 0.6131200194358826f)) + (_2904 * 0.047370001673698425f);
                    float _2929 = ((_2903 * 0.9163600206375122f) + (_2902 * 0.07020000368356705f)) + (_2904 * 0.013450000435113907f);
                    float _2930 = ((_2903 * 0.10958000272512436f) + (_2902 * 0.02061999961733818f)) + (_2904 * 0.8697999715805054f);
                    float _2935 = select(_2866, 1.0f, float((bool)(uint)(saturate(dot(float3(_346, _347, _348), float3(0.0f, 1.0f, 0.0f))) > 0.5f)));
                    if (_enableSandAO == 1) {
                      float _2940 = 1.0f - _2846.x;
                      if (_2876) {
                        _2971 = ((((_2940 * 10.0f) * _2905) * _2912) * _2915);
                        _2974 = _2928;
                        _2975 = _2929;
                        _2976 = _2930;
                        _2977 = saturate(_2971);
                      } else {
                        float _2951 = saturate(_2905 + -0.5f);
                        _2974 = _2928;
                        _2975 = _2929;
                        _2976 = _2930;
                        _2977 = ((((_2951 * 2.0f) * max((_2935 * _2846.x), min((_2915 * ((_2846.x * 7.0f) + 3.0f)), (_2951 * 40.0f)))) + (((_2940 * 10.0f) * _2915) * saturate((0.5f - _2905) * 2.0f))) * _2912);
                      }
                    } else {
                      float _2969 = ((_2912 * _2905) * _2846.x) * _2935;
                      if (_2876) {
                        _2971 = _2969;
                        _2974 = _2928;
                        _2975 = _2929;
                        _2976 = _2930;
                        _2977 = saturate(_2971);
                      } else {
                        _2974 = _2928;
                        _2975 = _2929;
                        _2976 = _2930;
                        _2977 = _2969;
                      }
                    }
                  } else {
                    _2974 = 0.0f;
                    _2975 = 0.0f;
                    _2976 = 0.0f;
                    _2977 = 0.0f;
                  }
                  float _2981 = ((1.0f - _2846.w) * (1.0f - _2846.y)) * _2977;
                  bool _2982 = (_2981 > 9.999999747378752e-05f);
                  if (_2982) {
                    if (_2866) {
                      float _2985 = saturate(_2981);
                      _3012 = (((sqrt(_2974 * _1783) - _1783) * _2985) + _1783);
                      _3013 = (((sqrt(_2975 * _1784) - _1784) * _2985) + _1784);
                      _3014 = (((sqrt(_2976 * _1785) - _1785) * _2985) + _1785);
                    } else {
                      _3012 = ((_2981 * (_2974 - _1783)) + _1783);
                      _3013 = ((_2981 * (_2975 - _1784)) + _1784);
                      _3014 = ((_2981 * (_2976 - _1785)) + _1785);
                    }
                  } else {
                    _3012 = _1783;
                    _3013 = _1784;
                    _3014 = _1785;
                  }
                  if ((_2876) && (_2982)) {
                    if (_2866) {
                      _3029 = (((sqrt(_1887 * 0.25f) - _1887) * saturate(_2981)) + _1887);
                    } else {
                      _3029 = ((_2981 * (0.25f - _1887)) + _1887);
                    }
                  } else {
                    _3029 = _1887;
                  }
                  float _3030 = saturate(_3012);
                  float _3031 = saturate(_3013);
                  float _3032 = saturate(_3014);
                  float _3037 = (_3029 * (1.0f - _2836)) + _2836;
                  float _3040 = ((_3029 - _3037) * _2846.y) + _3037;
                  float _3047 = (((_2836 * _2836) * _2846.z) * float((bool)(uint)(_2865))) * saturate(dot(float3(_346, _347, _348), float3(0.0f, 1.0f, 0.0f)));
                  float _3048 = _3047 * -0.5f;
                  _3058 = (_1793 - (_2836 * _1793));
                  _3059 = (_3040 - (_3047 * _3040));
                  _3060 = ((_3048 * _3030) + _3030);
                  _3061 = ((_3048 * _3031) + _3031);
                  _3062 = ((_3048 * _3032) + _3032);
                } else {
                  _3058 = _1793;
                  _3059 = _1887;
                  _3060 = _1783;
                  _3061 = _1784;
                  _3062 = _1785;
                }
              } else {
                _3058 = _1793;
                _3059 = _1887;
                _3060 = _1783;
                _3061 = _1784;
                _3062 = _1785;
              }
            }
            _3069 = half(_3058);
            _3070 = half(_3059);
            _3071 = half(_3060);
            _3072 = half(_3061);
            _3073 = half(_3062);
            _3074 = _2836;
          } else {
            _3069 = _987;
            _3070 = _988;
            _3071 = _989;
            _3072 = _990;
            _3073 = _991;
            _3074 = _2563;
          }
          __defer_2794_3068 = true;
        } else {
          _3080 = _2563;
          _3081 = _989;
          _3082 = _990;
          _3083 = _991;
          _3084 = _988;
          _3085 = _987;
          _3086 = _2809;
          _3087 = _2810;
          _3088 = _2811;
          _3089 = 0.0f;
          _3090 = 0.0f;
          _3091 = 0.0f;
        }
      }
    } else {
      if (_956) {
        _3069 = _987;
        _3070 = _988;
        _3071 = _989;
        _3072 = _990;
        _3073 = _991;
        _3074 = _2563;
        __defer_2794_3068 = true;
      } else {
        if (!(((_915 == 6)) || ((((_992 == 106)) || (((((uint)(_915 + -27) < (uint)2)) || ((((_915 == 105)) || ((_915 == 26)))))))))) {
          if (!(_915 == 7)) {
            float _2836 = exp2(log2(_2563) * (saturate(_116 * 0.03125f) + 1.0f));
            float4 _2846 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_104, _105), 0.0f);
            bool __defer_2830_2864 = false;
            bool __branch_chain_2830;
            if (((_915 == 15)) || ((((_992 == 12)) || (((_915 & -4) == 16))))) {
              _2865 = false;
              _2866 = true;
              __branch_chain_2830 = true;
            } else {
              if (!((uint)_915 > (uint)10)) {
                _2865 = true;
                _2866 = false;
                __branch_chain_2830 = true;
              } else {
                if ((uint)_915 < (uint)20) {
                  _2865 = false;
                  _2866 = false;
                  __branch_chain_2830 = true;
                } else {
                  if (!(_915 == 97)) {
                    _2865 = (_915 != 107);
                    _2866 = false;
                    __branch_chain_2830 = true;
                  } else {
                    _3058 = _1793;
                    _3059 = _1887;
                    _3060 = _1783;
                    _3061 = _1784;
                    _3062 = _1785;
                    __branch_chain_2830 = false;
                  }
                }
              }
            }
            if (__branch_chain_2830) {
              __defer_2830_2864 = true;
            }
            if (__defer_2830_2864) {
              if (_2846.w < 1.0f) {
                if ((_weatherCheckFlag & 5) == 5) {
                  bool _2876 = (_915 == 36);
                  if (!_2876) {
                    float4 _2896 = __3__36__0__0__g_climateSandTex.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((((_viewPos.x + _389) / _climateTextureOnePixelMeter.x) + float((int)((int)(_climateTextureSize.x >> 1)))) / float((int)(_climateTextureSize.x))), (1.0f - ((((_viewPos.z + _391) / _climateTextureOnePixelMeter.y) + float((int)((int)(_climateTextureSize.y >> 1)))) / float((int)(_climateTextureSize.y))))), 0.0f);
                    _2902 = _2896.x;
                    _2903 = _2896.y;
                    _2904 = _2896.z;
                    _2905 = _2896.w;
                  } else {
                    _2902 = 0.11999999731779099f;
                    _2903 = 0.11999999731779099f;
                    _2904 = 0.10000000149011612f;
                    _2905 = 0.5f;
                  }
                  float _2912 = 1.0f - saturate(((_viewPos.y + _390) - _paramGlobalSand.x) / _paramGlobalSand.y);
                  if (!(_2912 <= 0.0f)) {
                    float _2915 = saturate(_2836);
                    float _2928 = ((_2903 * 0.3395099937915802f) + (_2902 * 0.6131200194358826f)) + (_2904 * 0.047370001673698425f);
                    float _2929 = ((_2903 * 0.9163600206375122f) + (_2902 * 0.07020000368356705f)) + (_2904 * 0.013450000435113907f);
                    float _2930 = ((_2903 * 0.10958000272512436f) + (_2902 * 0.02061999961733818f)) + (_2904 * 0.8697999715805054f);
                    float _2935 = select(_2866, 1.0f, float((bool)(uint)(saturate(dot(float3(_346, _347, _348), float3(0.0f, 1.0f, 0.0f))) > 0.5f)));
                    if (_enableSandAO == 1) {
                      float _2940 = 1.0f - _2846.x;
                      if (_2876) {
                        _2971 = ((((_2940 * 10.0f) * _2905) * _2912) * _2915);
                        _2974 = _2928;
                        _2975 = _2929;
                        _2976 = _2930;
                        _2977 = saturate(_2971);
                      } else {
                        float _2951 = saturate(_2905 + -0.5f);
                        _2974 = _2928;
                        _2975 = _2929;
                        _2976 = _2930;
                        _2977 = ((((_2951 * 2.0f) * max((_2935 * _2846.x), min((_2915 * ((_2846.x * 7.0f) + 3.0f)), (_2951 * 40.0f)))) + (((_2940 * 10.0f) * _2915) * saturate((0.5f - _2905) * 2.0f))) * _2912);
                      }
                    } else {
                      float _2969 = ((_2912 * _2905) * _2846.x) * _2935;
                      if (_2876) {
                        _2971 = _2969;
                        _2974 = _2928;
                        _2975 = _2929;
                        _2976 = _2930;
                        _2977 = saturate(_2971);
                      } else {
                        _2974 = _2928;
                        _2975 = _2929;
                        _2976 = _2930;
                        _2977 = _2969;
                      }
                    }
                  } else {
                    _2974 = 0.0f;
                    _2975 = 0.0f;
                    _2976 = 0.0f;
                    _2977 = 0.0f;
                  }
                  float _2981 = ((1.0f - _2846.w) * (1.0f - _2846.y)) * _2977;
                  bool _2982 = (_2981 > 9.999999747378752e-05f);
                  if (_2982) {
                    if (_2866) {
                      float _2985 = saturate(_2981);
                      _3012 = (((sqrt(_2974 * _1783) - _1783) * _2985) + _1783);
                      _3013 = (((sqrt(_2975 * _1784) - _1784) * _2985) + _1784);
                      _3014 = (((sqrt(_2976 * _1785) - _1785) * _2985) + _1785);
                    } else {
                      _3012 = ((_2981 * (_2974 - _1783)) + _1783);
                      _3013 = ((_2981 * (_2975 - _1784)) + _1784);
                      _3014 = ((_2981 * (_2976 - _1785)) + _1785);
                    }
                  } else {
                    _3012 = _1783;
                    _3013 = _1784;
                    _3014 = _1785;
                  }
                  if ((_2876) && (_2982)) {
                    if (_2866) {
                      _3029 = (((sqrt(_1887 * 0.25f) - _1887) * saturate(_2981)) + _1887);
                    } else {
                      _3029 = ((_2981 * (0.25f - _1887)) + _1887);
                    }
                  } else {
                    _3029 = _1887;
                  }
                  float _3030 = saturate(_3012);
                  float _3031 = saturate(_3013);
                  float _3032 = saturate(_3014);
                  float _3037 = (_3029 * (1.0f - _2836)) + _2836;
                  float _3040 = ((_3029 - _3037) * _2846.y) + _3037;
                  float _3047 = (((_2836 * _2836) * _2846.z) * float((bool)(uint)(_2865))) * saturate(dot(float3(_346, _347, _348), float3(0.0f, 1.0f, 0.0f)));
                  float _3048 = _3047 * -0.5f;
                  _3058 = (_1793 - (_2836 * _1793));
                  _3059 = (_3040 - (_3047 * _3040));
                  _3060 = ((_3048 * _3030) + _3030);
                  _3061 = ((_3048 * _3031) + _3031);
                  _3062 = ((_3048 * _3032) + _3032);
                } else {
                  _3058 = _1793;
                  _3059 = _1887;
                  _3060 = _1783;
                  _3061 = _1784;
                  _3062 = _1785;
                }
              } else {
                _3058 = _1793;
                _3059 = _1887;
                _3060 = _1783;
                _3061 = _1784;
                _3062 = _1785;
              }
            }
            _3069 = half(_3058);
            _3070 = half(_3059);
            _3071 = half(_3060);
            _3072 = half(_3061);
            _3073 = half(_3062);
            _3074 = _2836;
          } else {
            _3069 = _987;
            _3070 = _988;
            _3071 = _989;
            _3072 = _990;
            _3073 = _991;
            _3074 = _2563;
          }
          __defer_2794_3068 = true;
        } else {
          _3080 = _2563;
          _3081 = _989;
          _3082 = _990;
          _3083 = _991;
          _3084 = _988;
          _3085 = _987;
          _3086 = _2809;
          _3087 = _2810;
          _3088 = _2811;
          _3089 = 0.0f;
          _3090 = 0.0f;
          _3091 = 0.0f;
        }
      }
    }
    if (__defer_2794_3068) {
      if (_995) {
        _3080 = _3074;
        _3081 = _3071;
        _3082 = _3072;
        _3083 = _3073;
        _3084 = _3070;
        _3085 = _3069;
        _3086 = 0.0f;
        _3087 = 0.0f;
        _3088 = 0.0f;
        _3089 = (_2809 * _917);
        _3090 = (_2810 * _918);
        _3091 = (_2811 * _919);
      } else {
        _3080 = _3074;
        _3081 = _3071;
        _3082 = _3072;
        _3083 = _3073;
        _3084 = _3070;
        _3085 = _3069;
        _3086 = _2809;
        _3087 = _2810;
        _3088 = _2811;
        _3089 = 0.0f;
        _3090 = 0.0f;
        _3091 = 0.0f;
      }
    }
    half4 _3093 = __3__36__0__0__g_sceneShadowColor.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
    [branch]
    if (_956) {
      uint _3100 = __3__36__0__0__g_sceneNormal.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
      float _3116 = min(1.0f, ((float((uint)((uint)(_3100.x & 1023))) * 0.001956947147846222f) + -1.0f));
      float _3117 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_3100.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
      float _3118 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_3100.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
      float _3120 = rsqrt(dot(float3(_3116, _3117, _3118), float3(_3116, _3117, _3118)));
      _3128 = half(_3120 * _3116);
      _3129 = half(_3120 * _3117);
      _3130 = half(_3120 * _3118);
    } else {
      _3128 = _289;
      _3129 = _290;
      _3130 = _291;
    }
    bool _3133 = (_sunDirection.y > 0.0f);
    if ((_3133) || ((!(_3133)) && (_sunDirection.y > _moonDirection.y))) {
      _3145 = _sunDirection.x;
      _3146 = _sunDirection.y;
      _3147 = _sunDirection.z;
    } else {
      _3145 = _moonDirection.x;
      _3146 = _moonDirection.y;
      _3147 = _moonDirection.z;
    }
    if ((_3133) || ((!(_3133)) && (_sunDirection.y > _moonDirection.y))) {
      _3167 = _precomputedAmbient7.y;
    } else {
      _3167 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
    }
    float _3172 = _viewPos.y + _390;
    float _3173 = _3172 + _earthRadius;
    float _3177 = (_391 * _391) + (_389 * _389);
    float _3179 = sqrt((_3173 * _3173) + _3177);
    float _3184 = dot(float3((_389 / _3179), (_3173 / _3179), (_391 / _3179)), float3(_3145, _3146, _3147));
    float _3189 = min(max(((_3179 - _earthRadius) / _atmosphereThickness), 16.0f), (_atmosphereThickness + -16.0f));
    float _3197 = max(_3189, 0.0f);
    float _3204 = (-0.0f - sqrt((_3197 + (_earthRadius * 2.0f)) * _3197)) / (_3197 + _earthRadius);
    if (_3184 > _3204) {
      _3227 = ((exp2(log2(saturate((_3184 - _3204) / (1.0f - _3204))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
    } else {
      _3227 = ((exp2(log2(saturate((_3204 - _3184) / (_3204 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
    }
    float2 _3232 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_3189 + -16.0f) / (_atmosphereThickness + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _3227), 0.0f);
    float _3254 = ((_3232.y * 1.9999999494757503e-05f) * _mieAerosolDensity) * (_mieAerosolAbsorption + 1.0f);
    float _3272 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 2.05560013455397e-06f)) * _3232.x) + _3254) * -1.4426950216293335f);
    float _3273 = exp2(((((float((uint)((uint)(((uint)((uint)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f) + (_ozoneRatio * 4.978800461685751e-06f)) * _3232.x) + _3254) * -1.4426950216293335f);
    float _3274 = exp2(((((_ozoneRatio * 2.1360001767334325e-07f) + (float((uint)((uint)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f)) * _3232.x) + _3254) * -1.4426950216293335f);
    float _3290 = sqrt(_3177);
    float _3298 = (_cloudAltitude - (max(((_3290 * _3290) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
    float _3310 = (_cloudThickness * (0.5f - (float((int)(((int)(uint)((int)(_3146 > 0.0f))) - ((int)(uint)((int)(_3146 < 0.0f))))) * 0.5f))) + _3298;
    if (_390 < _3298) {
      float _3313 = dot(float3(0.0f, 1.0f, 0.0f), float3(_3145, _3146, _3147));
      float _3319 = select((abs(_3313) < 9.99999993922529e-09f), 1e+08f, ((_3310 - dot(float3(0.0f, 1.0f, 0.0f), float3(_389, _390, _391))) / _3313));
      _3325 = ((_3319 * _3145) + _389);
      _3326 = _3310;
      _3327 = ((_3319 * _3147) + _391);
    } else {
      _3325 = _389;
      _3326 = _390;
      _3327 = _391;
    }
    float _3336 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3325 * 4.999999873689376e-05f) + 0.5f), ((_3326 - _3298) / _cloudThickness), ((_3327 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
    float _3347 = saturate(abs(_3146) * 4.0f);
    float _3349 = (_3347 * _3347) * exp2(((_distanceScale * -1.4426950216293335f) * _3336.x) * (_cloudScatteringCoefficient / _distanceScale));
    float _3356 = ((1.0f - _3349) * saturate(((_390 - _cloudThickness) - _3298) * 0.10000000149011612f)) + _3349;
    float _3357 = _3356 * (((_3273 * 0.3395099937915802f) + (_3272 * 0.6131200194358826f)) + (_3274 * 0.047370001673698425f));
    float _3358 = _3356 * (((_3273 * 0.9163600206375122f) + (_3272 * 0.07020000368356705f)) + (_3274 * 0.013450000435113907f));
    float _3359 = _3356 * (((_3273 * 0.10958000272512436f) + (_3272 * 0.02061999961733818f)) + (_3274 * 0.8697999715805054f));
    float _3375 = (((_3357 * 0.6131200194358826f) + (_3358 * 0.3395099937915802f)) + (_3359 * 0.047370001673698425f)) * _3167;
    float _3376 = (((_3357 * 0.07020000368356705f) + (_3358 * 0.9163600206375122f)) + (_3359 * 0.013450000435113907f)) * _3167;
    float _3377 = (((_3357 * 0.02061999961733818f) + (_3358 * 0.10958000272512436f)) + (_3359 * 0.8697999715805054f)) * _3167;
    // [DAWN_DUSK_GI] SH ambient directional boost
    if (DAWN_DUSK_IMPROVEMENTS == 1.f) {
      float _ddFactor = DawnDuskFactor(_sunDirection.y);
      float3 _ddAmbient = DawnDuskAmbientBoost(
        float3(_3375, _3376, _3377),
        float3(float(_3128), float(_3129), float(_3130)),
        _sunDirection.xyz,
        _ddFactor,
        _precomputedAmbient0.xyz);
      _3375 = _ddAmbient.x;
      _3376 = _ddAmbient.y;
      _3377 = _ddAmbient.z;
    }
    float _3383 = float(_930.x);
    float _3384 = float(_3093.x);
    float _3385 = float(_3093.y);
    float _3386 = float(_3093.z);
    float _3387 = float(_3081);
    float _3388 = float(_3082);
    float _3389 = float(_3083);
    if (!_1821) {
      _3395 = ((_174) && (((uint)(_915 + -105) < (uint)2)));
    } else {
      _3395 = true;
    }
    float _3397 = float(max(0.010002136h, _3084));
    float _3398 = float(_3085);
    bool _3401 = (_915 == 107);
    bool _3404 = (_950) || (((((uint)(_915 + -11) < (uint)9)) || (((_3401) || (_3395)))));
    float _3405 = select(_3404, 0.0f, _3398);
    do {
    if (((_992 == 26)) || ((((_915 == 105)) || ((_915 == 28))))) {
      _3417 = true;
      _3419 = _3417;
      _3420 = _3401;
      break;
    } else {
      bool _3414 = (_915 == 106);
      if (!(_915 == 19)) {
        _3417 = _3414;
        _3419 = _3417;
        _3420 = _3401;
        break;
      } else {
        _3419 = _3414;
        _3420 = true;
      }
    }
    } while(false);
    float _3421 = float(_3128);
    float _3422 = float(_3129);
    float _3423 = float(_3130);
    uint16_t _3425 = __3__36__0__0__g_sceneDecalMask.Load(int3(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))), 0));
    if (_915 == 97) {
      _3437 = (float((uint16_t)((uint)((uint16_t)((uint)(_3425.x)) >> 3))) * 0.032258063554763794f);
      _3438 = (((uint)((uint)((int)(min16uint)((int)((int)(_3425.x) & 4)))) >> 2) + 97);
      _3439 = 0.0f;
      _3440 = 0.0f;
      _3441 = 0.0f;
      _3442 = 0.0f;
      _3443 = 0.0f;
    } else {
      _3437 = select(_3404, _3398, 0.0f);
      _3438 = _915;
      _3439 = _454;
      _3440 = _455;
      _3441 = _456;
      _3442 = _457;
      _3443 = _458;
    }
    float _3448 = float(saturate(_194));
    float _3449 = _3448 * _3448;
    float _3450 = _3449 * _3449;
    float _3451 = _3450 * _3450;
    float4 _3458 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((_bufferSizeAndInvSize.z * _99), (_bufferSizeAndInvSize.w * _100)), 0.0f);
    float _3462 = ((_3451 * _3451) * select((((_915 == 29)) || (((_3419) || (_3420)))), 0.0f, 1.0f)) * _3458.y;
    float _3467 = _3421 - (_3462 * _3421);
    float _3468 = (_3462 * (1.0f - _3422)) + _3422;
    float _3469 = _3423 - (_3462 * _3423);
    float _3471 = rsqrt(dot(float3(_3467, _3468, _3469), float3(_3467, _3468, _3469)));
    float _3472 = _3467 * _3471;
    float _3473 = _3468 * _3471;
    float _3474 = _3469 * _3471;
    bool _3475 = (_3438 == 53);
    if (_3475) {
      _3482 = saturate(((_3388 + _3387) + _3389) * 1.2000000476837158f);
    } else {
      _3482 = 1.0f;
    }
    float _3488 = (0.699999988079071f / min(max(max(max(_3387, _3388), _3389), 0.009999999776482582f), 0.699999988079071f)) * _3482;
    float _3498 = (((_3488 * _3387) + -0.03999999910593033f) * _3405) + 0.03999999910593033f;
    float _3499 = (((_3488 * _3388) + -0.03999999910593033f) * _3405) + 0.03999999910593033f;
    float _3500 = (((_3488 * _3389) + -0.03999999910593033f) * _3405) + 0.03999999910593033f;
    float _3501 = float(_3084);
    int _3502 = _3438 & -2;
    bool _3503 = (_3502 == 64);
    bool _3506 = ((((int)(uint)((int)(_3503))) & _2571) == 0);
    if (_3506) {
      _3519 = saturate(exp2((_3501 * _3501) * (_116 * -0.005770780146121979f)));
    } else {
      _3519 = select((_cavityParams.z > 0.0f), select(_175, 0.0f, _417), 1.0f);
    }
    float _3520 = select(_2591, 1.0f, _3519);
    if (_3503) {
      _3526 = (_3520 * _3498);
      _3527 = (_3520 * _3499);
      _3528 = (_3520 * _3500);
    } else {
      _3526 = _3498;
      _3527 = _3499;
      _3528 = _3500;
    }
    // RenoDX: Geometric Specular AA
    float _rndx_spec_rough = _3397;
    if (SPECULAR_AA > 0.0f) {
      _rndx_spec_rough = NDFFilterRoughnessCS(float3(_3472, _3473, _3474), _3397, SPECULAR_AA);
    }
    float _3529 = _rndx_spec_rough * _rndx_spec_rough;
    float _3530 = _3529 * _3529;
    bool _3532 = ((uint)(_3438 + -97) < (uint)2);
    float _3534 = select(_3532, 0.5f, (_rndx_spec_rough * 0.60009765625f));
    float _3535 = _3534 * _3534;
    float _3536 = _3535 * _3535;
    bool _3537 = (_3438 == 33);
    bool __defer_3525_3550 = false;
    if (!_3537) {
      bool _3539 = (_3438 == 55);
      int _3540 = (int)(uint)((int)(_3539));
      bool __defer_3538_3548 = false;
      if (((_3438 == 98)) || ((_3502 == 96))) {
        _3549 = true;
        __defer_3538_3548 = true;
      } else {
        if ((uint)(_3438 + -105) < (uint)2) {
          if (_3539) {
            _3551 = _174;
            __defer_3525_3550 = true;
          } else {
            _3566 = _174;
            _3567 = _3540;
            _3568 = 0.0f;
            _3571 = _3568;
            _3572 = _3567;
            _3573 = _3566;
            _3574 = (_3438 == 7);
          }
        } else {
          _3549 = false;
          __defer_3538_3548 = true;
        }
      }
      if (__defer_3538_3548) {
        if (_3539) {
          _3551 = _3549;
          __defer_3525_3550 = true;
        } else {
          _3555 = _3549;
          _3556 = _3540;
          _3557 = 0.0f;
        }
        if ((uint)_3438 > (uint)11) {
          if (!((((uint)_3438 < (uint)21)) || ((_3438 == 107)))) {
            _3566 = _3555;
            _3567 = _3556;
            _3568 = _3557;
            _3571 = _3568;
            _3572 = _3567;
            _3573 = _3566;
            _3574 = (_3438 == 7);
          } else {
            _3571 = _3557;
            _3572 = _3556;
            _3573 = _3555;
            _3574 = true;
          }
        } else {
          if (!(_3438 == 6)) {
            _3566 = _3555;
            _3567 = _3556;
            _3568 = _3557;
            _3571 = _3568;
            _3572 = _3567;
            _3573 = _3566;
            _3574 = (_3438 == 7);
          } else {
            _3571 = _3557;
            _3572 = _3556;
            _3573 = _3555;
            _3574 = true;
          }
        }
      }
    } else {
      _3551 = false;
      __defer_3525_3550 = true;
    }
    if (__defer_3525_3550) {
      _3555 = _3551;
      _3556 = ((int)(uint)((int)(_3439 > 0.0f)));
      _3557 = _3439;
      if ((uint)_3438 > (uint)11) {
        if (!((((uint)_3438 < (uint)21)) || ((_3438 == 107)))) {
          _3566 = _3555;
          _3567 = _3556;
          _3568 = _3557;
          _3571 = _3568;
          _3572 = _3567;
          _3573 = _3566;
          _3574 = (_3438 == 7);
        } else {
          _3571 = _3557;
          _3572 = _3556;
          _3573 = _3555;
          _3574 = true;
        }
      } else {
        if (!(_3438 == 6)) {
          _3566 = _3555;
          _3567 = _3556;
          _3568 = _3557;
          _3571 = _3568;
          _3572 = _3567;
          _3573 = _3566;
          _3574 = (_3438 == 7);
        } else {
          _3571 = _3557;
          _3572 = _3556;
          _3573 = _3555;
          _3574 = true;
        }
      }
    }
    float _3579 = exp2(log2(float(_3093.w)) * 2.200000047683716f) * 1000.0f;
    if ((_3133) || ((!(_3133)) && (_sunDirection.y > _moonDirection.y))) {
      _3591 = _sunDirection.x;
      _3592 = _sunDirection.y;
      _3593 = _sunDirection.z;
    } else {
      _3591 = _moonDirection.x;
      _3592 = _moonDirection.y;
      _3593 = _moonDirection.z;
    }
    float _3594 = _3375 * _lightingParams.x;
    float _3595 = _3376 * _lightingParams.x;
    float _3596 = _3377 * _lightingParams.x;
    float _3597 = _3591 - _394;
    float _3598 = _3592 - _395;
    float _3599 = _3593 - _396;
    float _3601 = rsqrt(dot(float3(_3597, _3598, _3599), float3(_3597, _3598, _3599)));
    float _3602 = _3601 * _3597;
    float _3603 = _3601 * _3598;
    float _3604 = _3601 * _3599;
    float _3605 = dot(float3(_3421, _3422, _3423), float3(_3591, _3592, _3593));
    float _3606 = dot(float3(_3472, _3473, _3474), float3(_3591, _3592, _3593));
    float _3608 = saturate(dot(float3(_3421, _3422, _3423), float3(_996, _997, _998)));
    float _3610 = saturate(dot(float3(_3472, _3473, _3474), float3(_3602, _3603, _3604)));
    float _3611 = dot(float3(_996, _997, _998), float3(_3602, _3603, _3604));
    float _3613 = saturate(dot(float3(_3591, _3592, _3593), float3(_3602, _3603, _3604)));
    bool _3614 = (_3502 == 66);
    bool _3615 = (_3438 == 54);
    bool _3616 = (_3615) || (_3614);
    if (_3616) {
      if (_3615) {
        _3633 = (((asfloat(_globalLightParams.z) * _3397) + _bevelParams.y) + (asfloat(_globalLightParams.w) * float(_161)));
      } else {
        _3633 = _bevelParams.y;
      }
      float _3651 = (sqrt(_3177 + (_390 * _390)) * 2.0f) + 1.0f;
      float _3655 = (_916 * 7.0f) + 1.0f;
      float4 _3660 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2((((dot(float3(_389, _390, _391), float3(((_914 * _219) - (_913 * _220)), ((_912 * _220) - (_914 * _218)), ((_913 * _218) - (_912 * _219)))) * 2.0f) / _3651) * _3655), (((dot(float3(_389, _390, _391), float3(_912, _913, _914)) * 0.5f) / _3651) * _3655)), 0.0f);
      float _3664 = _916 * 0.5f;
      float _3665 = _3660.x * 2.0f;
      float _3666 = _3660.y * 2.0f;
      float _3667 = _3660.z * 2.0f;
      float _3678 = dot(float3(_912, _913, _914), float3(_3591, _3592, _3593));
      float _3679 = dot(float3(_912, _913, _914), float3(_996, _997, _998));
      float _3685 = cos(abs(asin(_3679) - asin(_3678)) * 0.5f);
      float _3689 = _3591 - (_3678 * _912);
      float _3690 = _3592 - (_3678 * _913);
      float _3691 = _3593 - (_3678 * _914);
      float _3695 = _996 - (_3679 * _912);
      float _3696 = _997 - (_3679 * _913);
      float _3697 = _998 - (_3679 * _914);
      float _3704 = rsqrt((dot(float3(_3695, _3696, _3697), float3(_3695, _3696, _3697)) * dot(float3(_3689, _3690, _3691), float3(_3689, _3690, _3691))) + 9.999999747378752e-05f) * dot(float3(_3689, _3690, _3691), float3(_3695, _3696, _3697));
      float _3708 = sqrt(saturate((_3704 * 0.5f) + 0.5f));
      float _3715 = min(max(max(0.05000000074505806f, _3397), 0.09803921729326248f), 1.0f);
      float _3716 = _3715 * _3715;
      float _3717 = _3716 * 0.5f;
      float _3718 = _3716 * 2.0f;
      float _3719 = _3679 + _3678;
      float _3720 = _3719 + (_3633 * 2.0f);
      float _3722 = (_3708 * 1.4142135381698608f) * _3716;
      float _3736 = 1.0f - sqrt(saturate((dot(float3(_996, _997, _998), float3(_3591, _3592, _3593)) * 0.5f) + 0.5f));
      float _3737 = _3736 * _3736;
      float _3744 = _3719 - _3633;
      float _3753 = 1.0f / ((1.190000057220459f / _3685) + (_3685 * 0.36000001430511475f));
      float _3758 = ((_3753 * (0.6000000238418579f - (_3704 * 0.800000011920929f))) + 1.0f) * _3708;
      float _3764 = 1.0f - (sqrt(saturate(1.0f - (_3758 * _3758))) * _3685);
      float _3765 = _3764 * _3764;
      float _3769 = 0.9534794092178345f - ((_3765 * _3765) * (_3764 * 0.9534794092178345f));
      float _3770 = _3753 * _3758;
      float _3775 = (sqrt(1.0f - (_3770 * _3770)) * 0.5f) / _3685;
      float _3776 = log2(_3387);
      float _3777 = log2(_3388);
      float _3778 = log2(_3389);
      float _3790 = ((_3769 * _3769) * (exp2((((_3744 * _3744) * -0.5f) / (_3717 * _3717)) * 1.4426950216293335f) / (_3716 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3704 * 5.2658371925354f));
      float _3794 = _3719 - (_3633 * 4.0f);
      float _3804 = 1.0f - (_3685 * 0.5f);
      float _3805 = _3804 * _3804;
      float _3809 = (_3805 * _3805) * (0.9534794092178345f - (_3685 * 0.47673970460891724f));
      float _3811 = 0.9534794092178345f - _3809;
      float _3812 = 0.800000011920929f / _3685;
      float _3825 = (((_3811 * _3811) * (_3809 + 0.04652056470513344f)) * (exp2((((_3794 * _3794) * -0.5f) / (_3718 * _3718)) * 1.4426950216293335f) / (_3716 * 5.013256549835205f))) * exp2((_3704 * 24.525815963745117f) + -24.208423614501953f);
      float _3832 = saturate(_3606);
      float _3833 = (((_3708 * 0.25f) * (exp2((((_3720 * _3720) * -0.5f) / (_3722 * _3722)) * 1.4426950216293335f) / (_3722 * 2.5066282749176025f))) * (((_3737 * _3737) * (_3736 * 0.9534794092178345f)) + 0.04652056470513344f)) * _3832;
      float _3843 = -0.0f - _3832;
      float _3854 = saturate((_3606 + 1.0f) * 0.25f);
      float _3859 = max(0.0010000000474974513f, dot(float3(_3387, _3388, _3389), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)));
      float _3878 = ((((1.0f - abs(_3606)) - _3854) * 0.33000001311302185f) + _3854) * 0.07957746833562851f;
      float _3880 = (exp2(log2(_3387 / _3859) * (1.0f - _3384)) * _3878) * sqrt(_3387);
      float _3882 = (exp2(log2(_3388 / _3859) * (1.0f - _3385)) * _3878) * sqrt(_3388);
      float _3884 = (exp2(log2(_3389 / _3859) * (1.0f - _3386)) * _3878) * sqrt(_3389);
      float _3891 = min(2048.0f, (-0.0f - min(0.0f, min(0.0f, (((_3825 * exp2(_3812 * _3776)) + (_3790 * exp2(_3776 * _3775))) * _3843)))));
      float _3892 = min(2048.0f, (-0.0f - min(0.0f, min(0.0f, (((_3825 * exp2(_3812 * _3777)) + (_3790 * exp2(_3777 * _3775))) * _3843)))));
      float _3893 = min(2048.0f, (-0.0f - min(0.0f, min(0.0f, (((_3825 * exp2(_3812 * _3778)) + (_3790 * exp2(_3778 * _3775))) * _3843)))));
      float _3900 = -0.0f - min(0.0f, (min(0.0f, (-0.0f - ((lerp(_3665, 1.0f, _3664)) * _3833))) * _3384));
      float _3901 = -0.0f - min(0.0f, (min(0.0f, (-0.0f - ((lerp(_3666, 1.0f, _3664)) * _3833))) * _3385));
      float _3902 = -0.0f - min(0.0f, (min(0.0f, (-0.0f - ((lerp(_3667, 1.0f, _3664)) * _3833))) * _3386));
      if (!_3614) {
        _3904 = _3891;
        _3905 = _3892;
        _3906 = _3893;
        _3907 = _3900;
        _3908 = _3901;
        _3909 = _3902;
        _3910 = _3880;
        _3911 = _3882;
        _3912 = _3884;
      } else {
        _4322 = _3891;
        _4323 = _3892;
        _4324 = _3893;
        _4325 = _3900;
        _4326 = _3901;
        _4327 = _3902;
        _4328 = _3880;
        _4329 = _3882;
        _4330 = _3884;
      }
    } else {
      _3904 = 0.0f;
      _3905 = 0.0f;
      _3906 = 0.0f;
      _3907 = 0.0f;
      _3908 = 0.0f;
      _3909 = 0.0f;
      _3910 = 0.0f;
      _3911 = 0.0f;
      _3912 = 0.0f;
    }
    if (!_3615) {
      bool _3914 = (_3572 == 0);
      // RenoDX: Foliage stencil detection (stencil 12..18 inclusive)
      bool isFoliage = ((uint)(_112 - 12) < 7u);
      bool __defer_3913_4081 = false;
      if (_3914) {
        if (((_3605 > 0.0f)) || ((_3606 > 0.0f))) {
          _4082 = 0.0f;
          _4083 = 0.0f;
          _4084 = 0.0f;
          _4085 = 0.0f;
          _4086 = 0.0f;
          _4087 = 0.0f;
          _4088 = 0.0f;
          _4089 = 0.0f;
          _4090 = 0.0f;
          __defer_3913_4081 = true;
        } else {
          _4322 = _3904;
          _4323 = _3905;
          _4324 = _3906;
          _4325 = _3907;
          _4326 = _3908;
          _4327 = _3909;
          _4328 = _3910;
          _4329 = _3911;
          _4330 = _3912;
        }
      } else {
        float _3929 = (saturate(_3605) * 0.31830987334251404f) * (((saturate(1.0f - _effectiveMetallicForVelvet) + -1.0f) * _3443) + 1.0f);
        float _3935 = max(dot(float3(_3387, _3388, _3389), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)), 0.03999999910593033f);
        float _3936 = sqrt(_3387);
        float _3937 = sqrt(_3388);
        float _3938 = sqrt(_3389);
        float _3939 = _3936 - _3935;
        float _3940 = _3937 - _3935;
        float _3941 = _3938 - _3935;
        float _3948 = saturate(1.0f - (pow(_3608, 4.0f)));
        float _3961 = (((_3940 * _3440) + _3935) + ((_3940 * (_3443 - _3440)) * _3948)) * _3441;
        float _3964 = saturate(1.0f - saturate(_3611));
        float _3965 = _3964 * _3964;
        float _3967 = (_3965 * _3965) * _3964;
        float _3970 = _3967 * saturate(_3961 * 50.0f);
        float _3971 = 1.0f - _3967;
        float _3972 = _3971 * _3441;
        float _3976 = (_3972 * (((_3939 * _3440) + _3935) + (_3948 * (_3939 * (_3443 - _3440))))) + _3970;
        float _3977 = (_3971 * _3961) + _3970;
        float _3978 = (_3972 * (((_3941 * _3440) + _3935) + ((_3941 * (_3443 - _3440)) * _3948))) + _3970;
        float _3979 = min(_3610, 0.9998999834060669f);
        float _3980 = _3979 * _3979;
        float _3981 = 1.0f - _3980;
        float _3993 = (((exp2(((-0.0f - _3980) / (_3981 * _3530)) * 1.4426950216293335f) * 4.0f) / (_3981 * _3981)) + 1.0f) / ((_3530 * 12.566370964050293f) + 3.1415927410125732f);
        float _3997 = ((_3608 + _3606) - (_3608 * _3606)) * 4.0f;
        float _4001 = (_3976 * _3993) / _3997;
        float _4002 = (_3977 * _3993) / _3997;
        float _4003 = (_3978 * _3993) / _3997;
        float _4004 = 1.0f - _3529;
        float _4016 = (((_3610 * _3530) - _3610) * _3610) + 1.0f;
        float _4020 = (_3530 / ((_4016 * _4016) * 3.1415927410125732f)) * (0.5f / ((((_3608 * _4004) + _3529) * _3605) + (_3608 * ((_3605 * _4004) + _3529))));
        float _4036 = saturate(_3606);
        float _4041 = (_3442 * 1.5f) + 2.5f;
        float _4042 = _4041 * _4041;
        float _4052 = (max(0.0f, (0.30000001192092896f - _3605)) * 0.25f) * ((exp2(_4042 * -0.48089835047721863f) * 3.0f) + exp2(_4042 * -1.4426950216293335f));
        float _4077 = (((1.0f - _3443) * 0.47746479511260986f) * saturate(_3442)) * saturate((pow(_3610, 4.0f)) * exp2(log2(saturate(1.0f - abs(_3605))) * 3.0f));
        _4082 = (_4077 * _3936);
        _4083 = (_4077 * _3937);
        _4084 = (_4077 * _3938);
        _4085 = ((((max((_4020 * _3976), 0.0f) - _4001) * _3440) + _4001) * _4036);
        _4086 = ((((max((_4020 * _3977), 0.0f) - _4002) * _3440) + _4002) * _4036);
        _4087 = ((((max((_4020 * _3978), 0.0f) - _4003) * _3440) + _4003) * _4036);
        _4088 = (((_3936 * _3384) * _4052) + _3929);
        _4089 = (((_3937 * _3385) * _4052) + _3929);
        _4090 = (((_3938 * _3386) * _4052) + _3929);
        __defer_3913_4081 = true;
      }
      if (__defer_3913_4081) {
        if (!(_3439 > 0.9900000095367432f)) {
          float _4093 = saturate(_3605);
          float _4094 = 1.0f - _3530;
          float _4095 = 1.0f - _3613;
          float _4096 = _4095 * _4095;
          float _4099 = ((_4096 * _4096) * _4095) + _3613;
          float _4100 = 1.0f - _4093;
          float _4101 = _4100 * _4100;
          float _4106 = 1.0f - _3608;
          float _4107 = _4106 * _4106;
          float _4134;
          if (DIFFUSE_BRDF_MODE >= 2.0f) {
            // EON Diffuse
            float _eon_LdotV = dot(float3(_3591, _3592, _3593), float3(_996, _997, _998));
            _4134 = _4093 * EON_DiffuseScalar(_4093, _3608, _eon_LdotV, _3397);
          } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
            // Hammon Diffuse
            _4134 = _4093 * HammonDiffuseScalar(_4093, _3608, _3610, _3613, _3397);
          } else {
            // Vanilla Burley Diffuse
            _4134 = (_4093 * 0.31830987334251404f) * ((((_3613 * ((((_4094 * 34.5f) + -59.0f) * _4094) + 24.5f)) * exp2(-0.0f - (max(((_4094 * 73.19999694824219f) + -21.200000762939453f), 8.899999618530273f) * sqrt(_3610)))) + _4099) + ((((1.0f - ((_4101 * _4101) * (_4100 * 0.75f))) * (1.0f - ((_4107 * _4107) * (_4106 * 0.75f)))) - _4099) * saturate((_4094 * 2.200000047683716f) + -0.5f)));
          }
          float _4137 = saturate(1.0f - saturate(_3611));
          float _4138 = _4137 * _4137;
          float _4140 = (_4138 * _4138) * _4137;
          float _4143 = _4140 * saturate(_3527 * 50.0f);
          float _4144 = 1.0f - _4140;
          float _4148 = (_4144 * _3526) + _4143;
          float _4149 = (_4144 * _3527) + _4143;
          float _4150 = (_4144 * _3528) + _4143;
          if (!(_3438 == 29)) {
            float _4152 = saturate(_3606);
            float _4153 = 1.0f - _3529;
            float _4165 = (((_3610 * _3530) - _3610) * _3610) + 1.0f;
            float _4169 = (_3530 / ((_4165 * _4165) * 3.1415927410125732f)) * (0.5f / ((((_3608 * _4153) + _3529) * _3606) + (_3608 * ((_3606 * _4153) + _3529))));
            _4180 = (max((_4169 * _4148), 0.0f) * _4152);
            _4181 = (max((_4169 * _4149), 0.0f) * _4152);
            _4182 = (max((_4169 * _4150), 0.0f) * _4152);
          } else {
            _4180 = 0.0f;
            _4181 = 0.0f;
            _4182 = 0.0f;
          }
          // RenoDX: Diffraction on Rough Surfaces
          if (DIFFRACTION > 0.0f && _3405 > 0.0f) {
            float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
              _3610, _3608, _rndx_spec_rough,
              float2(_104, _105), _116,
              float3(_3602, _3603, _3604),
              float3(_3472, _3473, _3474),
              float3(_3387, _3388, _3389)
            );
            float3 _rndx_dMod = lerp(1.0f, _rndx_dShift, DIFFRACTION * _3405);
            _4180 *= _rndx_dMod.x;
            _4181 *= _rndx_dMod.y;
            _4182 *= _rndx_dMod.z;
          }
          // RenoDX: Callisto Smooth Terminator
          if (SMOOTH_TERMINATOR > 0.0f) {
            float _rndx_c2 = CallistoSmoothTerminator(_4093, _3613, _3610, SMOOTH_TERMINATOR, 0.5f);
            _4134 *= _rndx_c2;
            _4180 *= _rndx_c2;
            _4181 *= _rndx_c2;
            _4182 *= _rndx_c2;
          }
          // RenoDX: Foliage Transmission (first instance — standard path)
          if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
            float thickness = 0.5f;
            float wrap = 0.3f * FOLIAGE_TRANSMISSION;
            float energyScale = 1.0f - thickness * FOLIAGE_TRANSMISSION;
            float wrappedNdotL = max(0.0f, (_3605 + wrap) / (1.0f + wrap));
            float vanillaNdotL = saturate(_3605);
            if (vanillaNdotL > 0.01f) {
              _4134 *= (wrappedNdotL / vanillaNdotL) * energyScale;
            } else {
              _4134 = wrappedNdotL * 0.31830987334251404f * energyScale;
            }
            float transmissionNdotL = pow(saturate(-_3605), 1.5f) * 0.5f;
            foliageTransR = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3387 * _3357 * _3594;
            foliageTransG = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3388 * _3358 * _3595;
            foliageTransB = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3389 * _3359 * _3596;
          }
          // RenoDX: Foliage diffuse energy compensation
          if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
            float _fNdotV = max(_3608, 0.001);
            float _fNdotL = saturate(_3605);
            float _fOneMinusV = 1.0 - _fNdotV;
            float _fOneMinusL = 1.0 - _fNdotL;
            float _fGrazingBoost = _fOneMinusV * _fOneMinusV * _fOneMinusL;
            float _fRoughFactor = _3397 * _3397;
            float _fCompensation = _fGrazingBoost * _fRoughFactor * 10.0;
            _4134 += _fCompensation * _fNdotL * RDXL_INV_PI;
          }
          bool _4183 = (_3438 == 65);
          if (_3503) {
            if (_4183) {
              float _4226 = max(9.999999974752427e-07f, _exposure2.x);
              float _4235 = ((_4093 * 50.26548385620117f) * exp2(log2(saturate(dot(float3(_3472, _3473, _3474), float3(_996, _997, _998)))) * 16.0f)) / (((_4226 * _4226) * 1e+06f) + 1.0f);
              _4249 = _4180;
              _4250 = _4181;
              _4251 = _4182;
              _4252 = ((((_4235 * _3387) - _4134) * _3437) + _4134);
              _4253 = ((((_4235 * _3388) - _4134) * _3437) + _4134);
              _4254 = ((((_4235 * _3389) - _4134) * _3437) + _4134);
            } else {
              float _4190 = 1.0f - _3535;
              float _4202 = (((_3610 * _3536) - _3610) * _3610) + 1.0f;
              float _4206 = (_3536 / ((_4202 * _4202) * 3.1415927410125732f)) * (0.5f / ((((_3608 * _4190) + _3535) * _3606) + (_3608 * ((_3606 * _4190) + _3535))));
              float _4213 = saturate(_3606) * 0.39990234375f;
              _4249 = ((max((_4206 * _4148), 0.0f) * _4213) + (_4180 * 0.60009765625f));
              _4250 = ((max((_4206 * _4149), 0.0f) * _4213) + (_4181 * 0.60009765625f));
              _4251 = ((max((_4206 * _4150), 0.0f) * _4213) + (_4182 * 0.60009765625f));
              _4252 = _4134;
              _4253 = _4134;
              _4254 = _4134;
            }
          } else {
            if (_4183) {
              float _4226 = max(9.999999974752427e-07f, _exposure2.x);
              float _4235 = ((_4093 * 50.26548385620117f) * exp2(log2(saturate(dot(float3(_3472, _3473, _3474), float3(_996, _997, _998)))) * 16.0f)) / (((_4226 * _4226) * 1e+06f) + 1.0f);
              _4249 = _4180;
              _4250 = _4181;
              _4251 = _4182;
              _4252 = ((((_4235 * _3387) - _4134) * _3437) + _4134);
              _4253 = ((((_4235 * _3388) - _4134) * _3437) + _4134);
              _4254 = ((((_4235 * _3389) - _4134) * _3437) + _4134);
            } else {
              _4249 = _4180;
              _4250 = _4181;
              _4251 = _4182;
              _4252 = _4134;
              _4253 = _4134;
              _4254 = _4134;
            }
          }
        } else {
          _4249 = _3907;
          _4250 = _3908;
          _4251 = _3909;
          _4252 = _3910;
          _4253 = _3911;
          _4254 = _3912;
        }
        float _4258 = min(-0.0f, (-0.0f - _4252));
        float _4259 = min(-0.0f, (-0.0f - _4253));
        float _4260 = min(-0.0f, (-0.0f - _4254));
        float _4261 = -0.0f - _4258;
        float _4262 = -0.0f - _4259;
        float _4263 = -0.0f - _4260;
        if (_3914) {
          _4322 = _3904;
          _4323 = _3905;
          _4324 = _3906;
          _4325 = (_4249 * _3384);
          _4326 = (_4250 * _3385);
          _4327 = (_4251 * _3386);
          _4328 = (_3384 * _4261);
          _4329 = (_3385 * _4262);
          _4330 = (_3386 * _4263);
        } else {
          bool _4265 = (_3439 > 0.0f);
          if (_4265) {
            _4299 = (_3904 - (_3904 * _3571));
            _4300 = (_3905 - (_3905 * _3571));
            _4301 = (_3906 - (_3906 * _3571));
            _4302 = (lerp(_4249, _4085, _3571));
            _4303 = (lerp(_4250, _4086, _3571));
            _4304 = (lerp(_4251, _4087, _3571));
            _4305 = (((_4258 + _4088) * _3571) - _4258);
            _4306 = (((_4259 + _4089) * _3571) - _4259);
            _4307 = (((_4260 + _4090) * _3571) - _4260);
          } else {
            _4299 = _3904;
            _4300 = _3905;
            _4301 = _3906;
            _4302 = _4249;
            _4303 = _4250;
            _4304 = _4251;
            _4305 = _4261;
            _4306 = _4262;
            _4307 = _4263;
          }
          float _4308 = _4305 * _3384;
          float _4309 = _4306 * _3385;
          float _4310 = _4307 * _3386;
          float _4311 = _4302 * _3384;
          float _4312 = _4303 * _3385;
          float _4313 = _4304 * _3386;
          if (_4265) {
            _4322 = _4299;
            _4323 = _4300;
            _4324 = _4301;
            _4325 = (_4311 + (_4082 * _3571));
            _4326 = (_4312 + (_4083 * _3571));
            _4327 = (_4313 + (_4084 * _3571));
            _4328 = _4308;
            _4329 = _4309;
            _4330 = _4310;
          } else {
            _4322 = _4299;
            _4323 = _4300;
            _4324 = _4301;
            _4325 = _4311;
            _4326 = _4312;
            _4327 = _4313;
            _4328 = _4308;
            _4329 = _4309;
            _4330 = _4310;
          }
        }
      }
    } else {
      _4322 = _3904;
      _4323 = _3905;
      _4324 = _3906;
      _4325 = _3907;
      _4326 = _3908;
      _4327 = _3909;
      _4328 = _3910;
      _4329 = _3911;
      _4330 = _3912;
    }
    if (_3574) {
      float _4334 = max(0.0f, (0.30000001192092896f - _3605)) * 0.23190687596797943f;
      _4342 = ((_4334 * _3384) + _4328);
      _4343 = ((_4334 * _3385) + _4329);
      _4344 = ((_4334 * _3386) + _4330);
    } else {
      _4342 = _4328;
      _4343 = _4329;
      _4344 = _4330;
    }
    float _4346 = 1.0f - (_3611 * 0.8500000238418579f);
    bool __defer_4341_4680 = false;
    if (_3503) {
      float _4350 = max(4.0f, _3579);
      float _4351 = _4350 * _4350;
      float _4353 = exp2(_4351 * -225.4210968017578f);
      float _4358 = exp2(_4351 * -29.807748794555664f);
      float _4366 = exp2(_4351 * -7.714946269989014f);
      float _4372 = exp2(_4351 * -2.544435739517212f);
      float _4374 = _4372 * 0.007000000216066837f;
      float _4379 = exp2(_4351 * -0.7249723672866821f);
      float _4393 = saturate(dot(float3(_3591, _3592, _3593), float3((-0.0f - _218), _234, (-0.0f - _220))) + 0.30000001192092896f) * 0.31830987334251404f;
      _4681 = ((_4393 * ((((((_4358 * 0.10000000149011612f) + (_4353 * 0.2329999953508377f)) + (_4366 * 0.11800000071525574f)) + (_4372 * 0.11299999803304672f)) + (_4379 * 0.3580000102519989f)) + (exp2(_4351 * -0.19469568133354187f) * 0.07800000160932541f))) + _4342);
      _4682 = ((_4393 * (((((_4358 * 0.335999995470047f) + (_4353 * 0.45500001311302185f)) + (_4366 * 0.1979999989271164f)) + _4374) + (_4379 * 0.004000000189989805f))) + _4343);
      _4683 = ((_4393 * (((_4358 * 0.3440000116825104f) + (_4353 * 0.6489999890327454f)) + _4374)) + _4344);
      __defer_4341_4680 = true;
    } else {
      bool __defer_4400_4661 = false;
      if (_3616) {
        float _4403 = dot(float3(_3387, _3388, _3389), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * _renderParams2.w;
        float _4406 = _4403 + (_3383 - (_4403 * _3383));
        float _4413 = (pow(_3384, 1.2000000476837158f));
        float _4414 = (pow(_3385, 1.2000000476837158f));
        float _4415 = (pow(_3386, 1.2000000476837158f));
        float _4421 = saturate(abs(dot(float3(_3591, _3592, _3593), float3(_912, _913, _914))));
        float2 _4430 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_4421, _3397, saturate(sqrt(sqrt(_3387)))), 0.0f);
        float2 _4433 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_4421, _3397, saturate(sqrt(sqrt(_3388)))), 0.0f);
        float2 _4436 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_4421, _3397, saturate(sqrt(sqrt(_3389)))), 0.0f);
        float _4445 = min(0.9900000095367432f, _4430.x);
        float _4446 = min(0.9900000095367432f, _4433.x);
        float _4447 = min(0.9900000095367432f, _4436.x);
        float _4448 = min(0.9900000095367432f, _4430.y);
        float _4449 = min(0.9900000095367432f, _4433.y);
        float _4450 = min(0.9900000095367432f, _4436.y);
        float _4451 = _4445 * _4445;
        float _4452 = _4446 * _4446;
        float _4453 = _4447 * _4447;
        float _4454 = _4448 * _4448;
        float _4455 = _4449 * _4449;
        float _4456 = _4450 * _4450;
        float _4457 = _4454 * _4448;
        float _4458 = _4455 * _4449;
        float _4459 = _4456 * _4450;
        float _4460 = 1.0f - _4451;
        float _4461 = 1.0f - _4452;
        float _4462 = 1.0f - _4453;
        float _4472 = _4460 * _4460;
        float _4473 = _4461 * _4461;
        float _4474 = _4462 * _4462;
        float _4475 = _4472 * _4460;
        float _4476 = _4473 * _4461;
        float _4477 = _4474 * _4462;
        float _4485 = min(max(_3397, 0.18000000715255737f), 0.6000000238418579f);
        float _4486 = _4485 * _4485;
        float _4487 = _4486 * 0.25f;
        float _4488 = _4486 * 4.0f;
        float _4490 = (_4446 + _4445) + _4447;
        float _4491 = _4445 / _4490;
        float _4492 = _4446 / _4490;
        float _4493 = _4447 / _4490;
        float _4494 = dot(float3(_4486, _4487, _4488), float3(_4491, _4492, _4493));
        float _4495 = _4494 * _4494;
        float _4499 = (asin(min(max(dot(float3(_912, _913, _914), float3(_996, _997, _998)), -1.0f), 1.0f)) + asin(min(max(dot(float3(_912, _913, _914), float3(_3591, _3592, _3593)), -1.0f), 1.0f))) * 0.5f;
        float _4500 = dot(float3(-0.07000000029802322f, 0.03500000014901161f, 0.14000000059604645f), float3(_4491, _4492, _4493));
        float _4510 = _4500 * _4500;
        float _4533 = (_4449 + _4448) + _4450;
        float _4537 = dot(float3(_4486, _4487, _4488), float3((_4448 / _4533), (_4449 / _4533), (_4450 / _4533)));
        float _4541 = sqrt((_4537 * _4537) + (_4495 * 2.0f));
        float _4559 = (_4537 * 3.0f) + (_4494 * 2.0f);
        float _4566 = (((_4457 + _4448) * ((_4451 * 0.699999988079071f) + 1.0f)) * _4541) / ((_4559 * _4457) + _4448);
        float _4567 = (((_4458 + _4449) * ((_4452 * 0.699999988079071f) + 1.0f)) * _4541) / ((_4559 * _4458) + _4449);
        float _4568 = (((_4459 + _4450) * ((_4453 * 0.699999988079071f) + 1.0f)) * _4541) / ((_4559 * _4459) + _4450);
        float _4572 = _4499 - (((_4510 * (((_4451 * 4.0f) * _4454) + (_4472 * 2.0f))) * (1.0f - ((_4454 * 2.0f) / _4472))) / _4475);
        float _4579 = _4499 - (((_4510 * (((_4452 * 4.0f) * _4455) + (_4473 * 2.0f))) * (1.0f - ((_4455 * 2.0f) / _4473))) / _4476);
        float _4586 = _4499 - (((_4510 * (((_4453 * 4.0f) * _4456) + (_4474 * 2.0f))) * (1.0f - ((_4456 * 2.0f) / _4474))) / _4477);
        float _4594 = (1.0f - _916) * 2.0999999046325684f;
        float _4615 = (_916 * 0.31830987334251404f) * saturate(_3605);
        _4662 = _4413;
        _4663 = _4414;
        _4664 = _4415;
        _4665 = (((_4406 * _3594) * _4413) * ((((((_4457 * _4451) / _4475) + ((_4448 * _4451) / _4460)) * _4594) * exp2((((_4572 * _4572) * -0.5f) / ((_4566 * _4566) + _4495)) * 1.4426950216293335f)) + _4322));
        _4666 = (((_4406 * _3595) * _4414) * ((((((_4458 * _4452) / _4476) + ((_4449 * _4452) / _4461)) * _4594) * exp2((((_4579 * _4579) * -0.5f) / ((_4567 * _4567) + _4495)) * 1.4426950216293335f)) + _4323));
        _4667 = (((_4406 * _3596) * _4415) * ((((((_4459 * _4453) / _4477) + ((_4450 * _4453) / _4462)) * _4594) * exp2((((_4586 * _4586) * -0.5f) / ((_4568 * _4568) + _4495)) * 1.4426950216293335f)) + _4324));
        _4668 = (_4615 * _4413);
        _4669 = (_4615 * _4414);
        _4670 = (_4615 * _4415);
        __defer_4400_4661 = true;
      } else {
        if (_3573) {
          if (_3438 == 97) {
            _4709 = ((_4325 * _3594) * _3384);
            _4710 = ((_4326 * _3595) * _3385);
            _4711 = ((_4327 * _3596) * _3386);
            _4712 = (_4342 * _3594);
            _4713 = (_4343 * _3595);
            _4714 = (_4344 * _3596);
            _4715 = _4322;
            _4716 = _4323;
            _4717 = _4324;
            _4718 = _3384;
            _4719 = _3385;
            _4720 = _3386;
            if (((_116 < 1000.0f)) && ((_3085 == 0.0h))) {
              if (!(abs(_219) > 0.9900000095367432f)) {
                float _4728 = -0.0f - _220;
                float _4730 = rsqrt(dot(float3(_4728, 0.0f, _218), float3(_4728, 0.0f, _218)));
                _4734 = (_4730 * _4728);
                _4735 = (_4730 * _218);
              } else {
                _4734 = 1.0f;
                _4735 = 0.0f;
              }
              float _4737 = -0.0f - (_219 * _4735);
              float _4740 = (_4735 * _218) - (_4734 * _220);
              float _4741 = _4734 * _219;
              float _4743 = rsqrt(dot(float3(_4737, _4740, _4741), float3(_4737, _4740, _4741)));
              float _4749 = _viewPos.x + _389;
              float _4750 = _viewPos.z + _391;
              float4 _4755 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4734, 0.0f, _4735), float3(_4749, _3172, _4750)), dot(float3((_4743 * _4737), (_4740 * _4743), (_4743 * _4741)), float3(_4749, _3172, _4750))), 0.0f);
              float _4759 = _4755.x + -0.5f;
              float _4760 = _4755.y + -0.5f;
              float _4761 = _4755.z + -0.5f;
              float _4763 = rsqrt(dot(float3(_4759, _4760, _4761), float3(_4759, _4760, _4761)));
              float _4767 = (_4759 * _4763) + _3472;
              float _4768 = (_4760 * _4763) + _3473;
              float _4769 = (_4761 * _4763) + _3474;
              float _4771 = rsqrt(dot(float3(_4767, _4768, _4769), float3(_4767, _4768, _4769)));
              float _4772 = _4767 * _4771;
              float _4773 = _4768 * _4771;
              float _4774 = _4769 * _4771;
              float _4786 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
              float _4787 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
              float _4790 = saturate(_4786 * _4786);
              float _4791 = saturate(_4787 * _4787);
              float _4805 = dot(float3((-0.0f - _4772), (-0.0f - _4773), (-0.0f - _4774)), float3(_3591, _3592, _3593));
              float _4807 = saturate(dot(float3(_4772, _4773, _4774), float3(_996, _997, _998)));
              float _4809 = saturate(1.0f - _3611);
              float _4810 = _4809 * _4809;
              float _4812 = (_4810 * _4810) * _4809;
              float _4828 = 1.0f - ((_3610 * _3610) * 0.9998999834060669f);
              float _4835 = (max((((3.18309866997879e-05f / (_4828 * _4828)) * (0.5f / ((((_4807 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4805) + (_4807 * ((_4805 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4812, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4805)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4772, _4773, _4774)))) * 1024.0f) * 50.0f);
              float _4840 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4791 * _4791) * (3.0f - (_4791 * 2.0f)))) * (1.0f - ((_4790 * _4790) * (3.0f - (_4790 * 2.0f)))));
              _4854 = _4712;
              _4855 = _4713;
              _4856 = _4714;
              _4857 = _4715;
              _4858 = _4716;
              _4859 = _4717;
              _4860 = ((((_4840 * _3594) * _4718) * _4835) + _4709);
              _4861 = ((((_4840 * _3595) * _4719) * _4835) + _4710);
              _4862 = ((((_4840 * _3596) * _4720) * _4835) + _4711);
            } else {
              _4854 = _4712;
              _4855 = _4713;
              _4856 = _4714;
              _4857 = _4715;
              _4858 = _4716;
              _4859 = _4717;
              _4860 = _4709;
              _4861 = _4710;
              _4862 = _4711;
            }
          } else {
            if ((uint)(_3438 + -105) < (uint)2) {
              _4662 = _3384;
              _4663 = _3385;
              _4664 = _3386;
              _4665 = _4322;
              _4666 = _4323;
              _4667 = _4324;
              _4668 = _4342;
              _4669 = _4343;
              _4670 = _4344;
              __defer_4400_4661 = true;
            } else {
              if (!(_3579 >= 999.9000244140625f)) {
                _4646 = ((max(0.0020000000949949026f, _3579) * 0.4000000059604645f) / ((_3437 * 100.0f) + 0.10000000149011612f));
              } else {
                _4646 = 1000.0f;
              }
              float _4647 = _4646 * _4646;
              float _4657 = (((_3437 * 0.25f) * (0.022082746028900146f / (_4346 * _4346))) * max(0.0f, (0.30000001192092896f - _3605))) * ((exp2(_4647 * -0.48089835047721863f) * 3.0f) + exp2(_4647 * -1.4426950216293335f));
              _4681 = (_4657 + _4342);
              _4682 = (_4657 + _4343);
              _4683 = (_4657 + _4344);
              __defer_4341_4680 = true;
            }
          }
        } else {
          _4681 = _4342;
          _4682 = _4343;
          _4683 = _4344;
          __defer_4341_4680 = true;
        }
      }
      if (__defer_4400_4661) {
        _4695 = ((_4325 * _3594) * _4662);
        _4696 = ((_4326 * _3595) * _4663);
        _4697 = ((_4327 * _3596) * _4664);
        _4698 = (_4668 * _3594);
        _4699 = (_4669 * _3595);
        _4700 = (_4670 * _3596);
        _4701 = _4665;
        _4702 = _4666;
        _4703 = _4667;
        _4704 = _4662;
        _4705 = _4663;
        _4706 = _4664;
        if (_3438 == 98) {
          _4709 = _4695;
          _4710 = _4696;
          _4711 = _4697;
          _4712 = _4698;
          _4713 = _4699;
          _4714 = _4700;
          _4715 = _4701;
          _4716 = _4702;
          _4717 = _4703;
          _4718 = _4704;
          _4719 = _4705;
          _4720 = _4706;
          if (((_116 < 1000.0f)) && ((_3085 == 0.0h))) {
            if (!(abs(_219) > 0.9900000095367432f)) {
              float _4728 = -0.0f - _220;
              float _4730 = rsqrt(dot(float3(_4728, 0.0f, _218), float3(_4728, 0.0f, _218)));
              _4734 = (_4730 * _4728);
              _4735 = (_4730 * _218);
            } else {
              _4734 = 1.0f;
              _4735 = 0.0f;
            }
            float _4737 = -0.0f - (_219 * _4735);
            float _4740 = (_4735 * _218) - (_4734 * _220);
            float _4741 = _4734 * _219;
            float _4743 = rsqrt(dot(float3(_4737, _4740, _4741), float3(_4737, _4740, _4741)));
            float _4749 = _viewPos.x + _389;
            float _4750 = _viewPos.z + _391;
            float4 _4755 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4734, 0.0f, _4735), float3(_4749, _3172, _4750)), dot(float3((_4743 * _4737), (_4740 * _4743), (_4743 * _4741)), float3(_4749, _3172, _4750))), 0.0f);
            float _4759 = _4755.x + -0.5f;
            float _4760 = _4755.y + -0.5f;
            float _4761 = _4755.z + -0.5f;
            float _4763 = rsqrt(dot(float3(_4759, _4760, _4761), float3(_4759, _4760, _4761)));
            float _4767 = (_4759 * _4763) + _3472;
            float _4768 = (_4760 * _4763) + _3473;
            float _4769 = (_4761 * _4763) + _3474;
            float _4771 = rsqrt(dot(float3(_4767, _4768, _4769), float3(_4767, _4768, _4769)));
            float _4772 = _4767 * _4771;
            float _4773 = _4768 * _4771;
            float _4774 = _4769 * _4771;
            float _4786 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
            float _4787 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
            float _4790 = saturate(_4786 * _4786);
            float _4791 = saturate(_4787 * _4787);
            float _4805 = dot(float3((-0.0f - _4772), (-0.0f - _4773), (-0.0f - _4774)), float3(_3591, _3592, _3593));
            float _4807 = saturate(dot(float3(_4772, _4773, _4774), float3(_996, _997, _998)));
            float _4809 = saturate(1.0f - _3611);
            float _4810 = _4809 * _4809;
            float _4812 = (_4810 * _4810) * _4809;
            float _4828 = 1.0f - ((_3610 * _3610) * 0.9998999834060669f);
            float _4835 = (max((((3.18309866997879e-05f / (_4828 * _4828)) * (0.5f / ((((_4807 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4805) + (_4807 * ((_4805 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4812, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4805)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4772, _4773, _4774)))) * 1024.0f) * 50.0f);
            float _4840 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4791 * _4791) * (3.0f - (_4791 * 2.0f)))) * (1.0f - ((_4790 * _4790) * (3.0f - (_4790 * 2.0f)))));
            _4854 = _4712;
            _4855 = _4713;
            _4856 = _4714;
            _4857 = _4715;
            _4858 = _4716;
            _4859 = _4717;
            _4860 = ((((_4840 * _3594) * _4718) * _4835) + _4709);
            _4861 = ((((_4840 * _3595) * _4719) * _4835) + _4710);
            _4862 = ((((_4840 * _3596) * _4720) * _4835) + _4711);
          } else {
            _4854 = _4712;
            _4855 = _4713;
            _4856 = _4714;
            _4857 = _4715;
            _4858 = _4716;
            _4859 = _4717;
            _4860 = _4709;
            _4861 = _4710;
            _4862 = _4711;
          }
        } else {
          _4854 = _4698;
          _4855 = _4699;
          _4856 = _4700;
          _4857 = _4701;
          _4858 = _4702;
          _4859 = _4703;
          _4860 = _4695;
          _4861 = _4696;
          _4862 = _4697;
        }
      }
    }
    if (__defer_4341_4680) {
      float _4684 = _4681 * _3594;
      float _4685 = _4682 * _3595;
      float _4686 = _4683 * _3596;
      float _4688 = (_4325 * _3594) * _3384;
      float _4690 = (_4326 * _3595) * _3385;
      float _4692 = (_4327 * _3596) * _3386;
      bool __branch_chain_4680;
      if (_3438 == 97) {
        _4709 = _4688;
        _4710 = _4690;
        _4711 = _4692;
        _4712 = _4684;
        _4713 = _4685;
        _4714 = _4686;
        _4715 = _4322;
        _4716 = _4323;
        _4717 = _4324;
        _4718 = _3384;
        _4719 = _3385;
        _4720 = _3386;
        __branch_chain_4680 = true;
      } else {
        _4695 = _4688;
        _4696 = _4690;
        _4697 = _4692;
        _4698 = _4684;
        _4699 = _4685;
        _4700 = _4686;
        _4701 = _4322;
        _4702 = _4323;
        _4703 = _4324;
        _4704 = _3384;
        _4705 = _3385;
        _4706 = _3386;
        if (_3438 == 98) {
          _4709 = _4695;
          _4710 = _4696;
          _4711 = _4697;
          _4712 = _4698;
          _4713 = _4699;
          _4714 = _4700;
          _4715 = _4701;
          _4716 = _4702;
          _4717 = _4703;
          _4718 = _4704;
          _4719 = _4705;
          _4720 = _4706;
          __branch_chain_4680 = true;
        } else {
          _4854 = _4698;
          _4855 = _4699;
          _4856 = _4700;
          _4857 = _4701;
          _4858 = _4702;
          _4859 = _4703;
          _4860 = _4695;
          _4861 = _4696;
          _4862 = _4697;
          __branch_chain_4680 = false;
        }
      }
      if (__branch_chain_4680) {
        if (((_116 < 1000.0f)) && ((_3085 == 0.0h))) {
          if (!(abs(_219) > 0.9900000095367432f)) {
            float _4728 = -0.0f - _220;
            float _4730 = rsqrt(dot(float3(_4728, 0.0f, _218), float3(_4728, 0.0f, _218)));
            _4734 = (_4730 * _4728);
            _4735 = (_4730 * _218);
          } else {
            _4734 = 1.0f;
            _4735 = 0.0f;
          }
          float _4737 = -0.0f - (_219 * _4735);
          float _4740 = (_4735 * _218) - (_4734 * _220);
          float _4741 = _4734 * _219;
          float _4743 = rsqrt(dot(float3(_4737, _4740, _4741), float3(_4737, _4740, _4741)));
          float _4749 = _viewPos.x + _389;
          float _4750 = _viewPos.z + _391;
          float4 _4755 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4734, 0.0f, _4735), float3(_4749, _3172, _4750)), dot(float3((_4743 * _4737), (_4740 * _4743), (_4743 * _4741)), float3(_4749, _3172, _4750))), 0.0f);
          float _4759 = _4755.x + -0.5f;
          float _4760 = _4755.y + -0.5f;
          float _4761 = _4755.z + -0.5f;
          float _4763 = rsqrt(dot(float3(_4759, _4760, _4761), float3(_4759, _4760, _4761)));
          float _4767 = (_4759 * _4763) + _3472;
          float _4768 = (_4760 * _4763) + _3473;
          float _4769 = (_4761 * _4763) + _3474;
          float _4771 = rsqrt(dot(float3(_4767, _4768, _4769), float3(_4767, _4768, _4769)));
          float _4772 = _4767 * _4771;
          float _4773 = _4768 * _4771;
          float _4774 = _4769 * _4771;
          float _4786 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
          float _4787 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
          float _4790 = saturate(_4786 * _4786);
          float _4791 = saturate(_4787 * _4787);
          float _4805 = dot(float3((-0.0f - _4772), (-0.0f - _4773), (-0.0f - _4774)), float3(_3591, _3592, _3593));
          float _4807 = saturate(dot(float3(_4772, _4773, _4774), float3(_996, _997, _998)));
          float _4809 = saturate(1.0f - _3611);
          float _4810 = _4809 * _4809;
          float _4812 = (_4810 * _4810) * _4809;
          float _4828 = 1.0f - ((_3610 * _3610) * 0.9998999834060669f);
          float _4835 = (max((((3.18309866997879e-05f / (_4828 * _4828)) * (0.5f / ((((_4807 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4805) + (_4807 * ((_4805 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4812, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4805)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4772, _4773, _4774)))) * 1024.0f) * 50.0f);
          float _4840 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4791 * _4791) * (3.0f - (_4791 * 2.0f)))) * (1.0f - ((_4790 * _4790) * (3.0f - (_4790 * 2.0f)))));
          _4854 = _4712;
          _4855 = _4713;
          _4856 = _4714;
          _4857 = _4715;
          _4858 = _4716;
          _4859 = _4717;
          _4860 = ((((_4840 * _3594) * _4718) * _4835) + _4709);
          _4861 = ((((_4840 * _3595) * _4719) * _4835) + _4710);
          _4862 = ((((_4840 * _3596) * _4720) * _4835) + _4711);
        } else {
          _4854 = _4712;
          _4855 = _4713;
          _4856 = _4714;
          _4857 = _4715;
          _4858 = _4716;
          _4859 = _4717;
          _4860 = _4709;
          _4861 = _4710;
          _4862 = _4711;
        }
      }
    }
    float _4869 = _4854 + _3086 + foliageTransR;
    float _4870 = _4855 + _3087 + foliageTransG;
    float _4871 = _4856 + _3088 + foliageTransB;
    uint _4874 = _frameNumber.x * 13;
    [branch]
    if (((((int)(_4874 + ((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3))))) | ((int)(_4874 + ((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))))) & 31) == 0) {
      __3__38__0__1__g_sceneColorLightingOnlyForAwbUAV[int2(((int)(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))) >> 5)), ((int)(((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))) >> 5)))] = half4(half(_4869), half(_4870), half(_4871), 1.0h);
    }
    bool _4889 = ((uint)(_3438 & 24) > (uint)23);
    if (_3506) {
      _4906 = saturate(exp2((_3501 * _3501) * (_116 * -0.005770780146121979f)));
    } else {
      _4906 = select((_cavityParams.z > 0.0f), select(_175, 0.0f, _985), 1.0f);
    }
    float _4921 = select(_3503, 1.0f, (select((_cavityParams.x == 0.0f), 1.0f, _4906) * select(((_174) && (_4889)), (1.0f - _985), 1.0f)));
    float _4925 = min(60000.0f, (_4921 * (((_2797 * _2553) * _2802) - min(0.0f, (-0.0f - _4860)))));
    float _4926 = min(60000.0f, (_4921 * (((_2798 * _2554) * _2802) - min(0.0f, (-0.0f - _4861)))));
    float _4927 = min(60000.0f, (_4921 * (((_2799 * _2555) * _2802) - min(0.0f, (-0.0f - _4862)))));
    float _4930 = 1.0f - _renderParams.x;
    half _4937 = half((_renderParams.x * _3387) + _4930);
    half _4938 = half((_renderParams.x * _3388) + _4930);
    half _4939 = half((_renderParams.x * _3389) + _4930);
    if ((_3503) && ((_renderParams2.x == 0.0f))) {
      _4955 = (pow(_4937, 0.5h));
      _4956 = (pow(_4938, 0.5h));
      _4957 = (pow(_4939, 0.5h));
    } else {
      _4955 = _4937;
      _4956 = _4938;
      _4957 = _4939;
    }
    bool _4959 = (_3537) || ((_3438 == 55));
    half _4960 = select(_4959, 0.0h, _3085);
    float _4961 = float(_4955);
    float _4962 = float(_4956);
    float _4963 = float(_4957);
    if (_3475) {
      _4970 = saturate(((_4962 + _4961) + _4963) * 1.2000000476837158f);
    } else {
      _4970 = 1.0f;
    }
    float _4971 = float(_4960);
    float _4977 = (0.699999988079071f / min(max(max(max(_4961, _4962), _4963), 0.009999999776482582f), 0.699999988079071f)) * _4970;
    float _4984 = ((_4977 * _4961) + -0.03999999910593033f) * _4971;
    float _4985 = ((_4977 * _4962) + -0.03999999910593033f) * _4971;
    float _4986 = ((_4977 * _4963) + -0.03999999910593033f) * _4971;
    float _4987 = _4984 + 0.03999999910593033f;
    float _4988 = _4985 + 0.03999999910593033f;
    float _4989 = _4986 + 0.03999999910593033f;
    if ((_3532) || (((_3615) || (((_3614) || (_4959)))))) {
      float2 _4998 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__3__40__0__0__g_samplerClamp, float2(min(0.9900000095367432f, _1004), (1.0f - max(0.019999999552965164f, float(_157)))), 0.0f);
      _5002 = _4998.x;
      _5003 = _4998.y;
    } else {
      _5002 = _2795;
      _5003 = _2796;
    }
    float _5007 = (_5002 * _4987) + _5003;
    float _5008 = (_5002 * _4988) + _5003;
    float _5009 = (_5002 * _4989) + _5003;
    float _5011 = (1.0f - _5002) - _5003;
    float _5018 = ((0.9599999785423279f - _4984) * 0.0476190485060215f) + _4987;
    float _5019 = ((0.9599999785423279f - _4985) * 0.0476190485060215f) + _4988;
    float _5020 = ((0.9599999785423279f - _4986) * 0.0476190485060215f) + _4989;
    float _5037 = saturate(1.0f - _3080);
    float _5038 = (((_5007 * _5018) / (1.0f - (_5011 * _5018))) * _5011) * _5037;
    float _5039 = (((_5008 * _5019) / (1.0f - (_5011 * _5019))) * _5011) * _5037;
    float _5040 = (((_5009 * _5020) / (1.0f - (_5011 * _5020))) * _5011) * _5037;
    float _5051 = float(1.0h - _4960);
    half _5061 = half(((_4961 * _5051) * saturate((1.0f - _5007) - _5038)) + _5038);
    half _5062 = half(((_4962 * _5051) * saturate((1.0f - _5008) - _5039)) + _5039);
    half _5063 = half(((_4963 * _5051) * saturate((1.0f - _5009) - _5040)) + _5040);
    float _5065 = float(_5061);
    float _5066 = float(_5062);
    float _5067 = float(_5063);
    if (_3438 == 65) {
      float _5071 = max(9.999999974752427e-07f, _exposure2.x);
      float _5079 = ((pow(_3608, 16.0f)) * 50.26548385620117f) / (((_5071 * _5071) * 1e+06f) + 1.0f);
      _5096 = (((((_5065 * _4869) * _5079) - _4869) * _953) + _4869);
      _5097 = (((((_5066 * _4870) * _5079) - _4870) * _953) + _4870);
      _5098 = (((((_5067 * _4871) * _5079) - _4871) * _953) + _4871);
    } else {
      _5096 = _4869;
      _5097 = _4870;
      _5098 = _4871;
    }
    float _5101 = __3__36__0__0__g_caustic.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_104, _105), 0.0f);
    float _5103 = _5101.x * 0.31830987334251404f;
    float _5113 = (min(65535.0f, _4857) + _3089) + (((_5103 * _3375) + _5096) * _5065);
    float _5114 = (min(65535.0f, _4858) + _3090) + (((_5103 * _3376) + _5097) * _5066);
    float _5115 = (min(65535.0f, _4859) + _3091) + (((_5103 * _3377) + _5098) * _5067);
    float _5144 = exp2((saturate(_419) * 20.0f) + -8.0f) + -0.00390625f;
    float _5145 = _5144 * select((_416 < 0.040449999272823334f), (_416 * 0.07739938050508499f), exp2(log2((_416 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    float _5146 = _5144 * select((_417 < 0.040449999272823334f), (_417 * 0.07739938050508499f), exp2(log2((_417 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    float _5147 = _5144 * select((_418 < 0.040449999272823334f), (_418 * 0.07739938050508499f), exp2(log2((_418 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    float _5160 = ((_5145 * 0.6131200194358826f) + (_5146 * 0.3395099937915802f)) + (_5147 * 0.047370001673698425f);
    float _5161 = ((_5145 * 0.07020000368356705f) + (_5146 * 0.9163600206375122f)) + (_5147 * 0.013450000435113907f);
    float _5162 = ((_5145 * 0.02061999961733818f) + (_5146 * 0.10958000272512436f)) + (_5147 * 0.8697999715805054f);
    if (_345) {
      _5168 = (_5160 + _5113);
      _5169 = (_5161 + _5114);
      _5170 = (_5162 + _5115);
    } else {
      _5168 = _5113;
      _5169 = _5114;
      _5170 = _5115;
    }
    float _5174 = _5168 + (_4925 * _4971);
    float _5175 = _5169 + (_4926 * _4971);
    float _5176 = _5170 + (_4927 * _4971);
    float _5198 = (((QuadReadLaneAt(_5174,1) + QuadReadLaneAt(_5174,0)) + QuadReadLaneAt(_5174,2)) + QuadReadLaneAt(_5174,3)) * 0.25f;
    float _5199 = (((QuadReadLaneAt(_5175,1) + QuadReadLaneAt(_5175,0)) + QuadReadLaneAt(_5175,2)) + QuadReadLaneAt(_5175,3)) * 0.25f;
    float _5200 = (((QuadReadLaneAt(_5176,1) + QuadReadLaneAt(_5176,0)) + QuadReadLaneAt(_5176,2)) + QuadReadLaneAt(_5176,3)) * 0.25f;
    [branch]
    if (((((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))) | ((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3))))) & 1) == 0) {
      float _5205 = dot(float3(_5198, _5199, _5200), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      __3__38__0__1__g_diffuseHalfPrevUAV[int2(((int)(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))) >> 1)), ((int)(((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))) >> 1)))] = float4(min(60000.0f, _5198), min(60000.0f, _5199), min(60000.0f, _5200), min(60000.0f, select((_1585 != 0), (-0.0f - _5205), _5205)));
    }
    if (_4889) {
      _5227 = (((_4960 == 0.0h)) && ((!(((((!(_5061 == 0.0h))) && ((!(_5062 == 0.0h))))) && ((!(_5063 == 0.0h)))))));
    } else {
      _5227 = false;
    }
    if ((((_4889) || ((((_3438 == 96)) || (((_3615) || (((_3438 & -4) == 64)))))))) || ((((_116 <= 10.0f)) && (_3532)))) {
      __3__38__0__1__g_sceneSpecularUAV[int2(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))))] = half4((-0.0h - half(min(0.0f, (-0.0f - _4925)))), (-0.0h - half(min(0.0f, (-0.0f - _4926)))), (-0.0h - half(min(0.0f, (-0.0f - _4927)))), (-0.0h - half(min(0.0f, (-0.0f - _2563)))));
      _5260 = _5168;
      _5261 = _5169;
      _5262 = _5170;
    } else {
      _5260 = (_5168 + _4925);
      _5261 = (_5169 + _4926);
      _5262 = (_5170 + _4927);
    }
    if (!((((uint)(_3438 + -53) < (uint)15)) || ((!_345)))) {
      float _5268 = dot(float3(_5160, _5161, _5162), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _5272 = max((max(_5268, 1.0f) / max(_5268, 0.10000000149011612f)), 0.0f);
      _5283 = ((_5260 - _5160) + (_5272 * _5160));
      _5284 = ((_5261 - _5161) + (_5272 * _5161));
      _5285 = ((_5262 - _5162) + (_5272 * _5162));
    } else {
      _5283 = _5260;
      _5284 = _5261;
      _5285 = _5262;
    }
    float _5286 = min(60000.0f, _5283);
    float _5287 = min(60000.0f, _5284);
    float _5288 = min(60000.0f, _5285);
    [branch]
    if (_5227) {
      float4 _5291 = __3__38__0__1__g_sceneColorUAV.Load(int2(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5))))));
      _5299 = (_5291.x + _5286);
      _5300 = (_5291.y + _5287);
      _5301 = (_5291.z + _5288);
    } else {
      _5299 = _5286;
      _5300 = _5287;
      _5301 = _5288;
    }
    if (!(_renderParams.y == 0.0f)) {
      float _5310 = dot(float3(_5299, _5300, _5301), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _5311 = min((max(0.009999999776482582f, _exposure3.w) * 4096.0f), _5310);
      float _5315 = max(9.999999717180685e-10f, _5310);
      _5320 = ((_5311 * _5299) / _5315);
      _5321 = ((_5311 * _5300) / _5315);
      _5322 = ((_5311 * _5301) / _5315);
    } else {
      _5320 = _5299;
      _5321 = _5300;
      _5322 = _5301;
    }
    __3__38__0__1__g_sceneColorUAV[int2(((int)((((uint)(((int)((uint)(_88) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3)))), ((int)((((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_88)) >> 16) << 5)))))] = float4(_5320, _5321, _5322, 1.0f);
  }
}