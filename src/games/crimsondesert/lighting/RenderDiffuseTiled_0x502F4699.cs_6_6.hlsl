#include "../shared.h"
#include "diffuse_brdf.hlsli"

Texture2D<float4> __3__36__0__0__g_puddleMask : register(t79, space36);

Texture2D<float4> __3__36__0__0__g_climateSandTex : register(t171, space36);

Texture2D<uint16_t> __3__36__0__0__g_sceneDecalMask : register(t172, space36);

Texture2D<float2> __3__36__0__0__g_texNetDensity : register(t140, space36);

Texture3D<float> __3__36__0__0__g_texCloudVolumeShadow : register(t195, space36);

Texture3D<float2> __3__36__0__0__g_hairDualScatteringLUT : register(t214, space36);

Texture2D<float4> __3__36__0__0__g_blueNoise : register(t0, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t14, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t119, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t50, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormalPrev : register(t81, space36);

Texture2D<float2> __3__36__0__0__g_velocity : register(t82, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t40, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaque : register(t49, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaquePrev : register(t84, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t33, space36);

Texture2D<float4> __3__36__0__0__g_bentCone : register(t17, space36);

Texture2D<float4> __3__36__0__0__g_character : register(t108, space36);

Texture2D<float4> __3__36__0__0__g_specularResult : register(t87, space36);

Texture2D<float> __3__36__0__0__g_specularRayHitDistance : register(t124, space36);

Texture2D<float4> __3__36__0__0__g_manyLightsMoments : register(t113, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t90, space36);

Texture2D<float2> __3__36__0__0__g_hairBrdfLookup : register(t92, space36);

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
  int _70 = (uint)(_69) >> 2;
  _55[0] = (g_tileIndex[(uint)(SV_GroupID.x) >> 6]).x;
  _55[1] = (g_tileIndex[(uint)(SV_GroupID.x) >> 6]).y;
  _55[2] = (g_tileIndex[(uint)(SV_GroupID.x) >> 6]).z;
  _55[3] = (g_tileIndex[(uint)(SV_GroupID.x) >> 6]).w;
  int _88 = _55[(((uint)(SV_GroupID.x) >> 4) & 3)];
  uint _94 = (((uint)(((int)(_88 << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_69 - (_70 << 2)) << 3));
  uint _96 = (((uint)(_70 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)(_88) >> 16) << 5));
  float _97 = float((uint)_94);
  float _98 = float((uint)_96);
  float _99 = _97 + 0.5f;
  float _100 = _98 + 0.5f;
  float _104 = _bufferSizeAndInvSize.z * _99;
  float _105 = _100 * _bufferSizeAndInvSize.w;
  float _107 = __3__36__0__0__g_depth.Load(int3(_94, _96, 0));
  uint2 _110 = __3__36__0__0__g_stencil.Load(int3(_94, _96, 0));
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
  float _1761;
  float _1762;
  float _1763;
  float _1764;
  float _1791;
  half _1816;
  bool _1828;
  half _1859;
  int _1860;
  float _1861;
  float _1862;
  float _1863;
  float _2150;
  float _2169;
  float _2173;
  float _2200;
  float _2243;
  float _2244;
  float _2245;
  float _2246;
  float _2252;
  float _2253;
  float _2254;
  float _2255;
  float _2258;
  float _2259;
  float _2260;
  float _2261;
  half _2262;
  float _2379;
  int _2380;
  int _2381;
  float _2382;
  float _2383;
  float _2384;
  float _2385;
  float _2514;
  float _2515;
  float _2516;
  float _2579;
  float _2589;
  float _2590;
  float _2591;
  float _2636;
  float _2637;
  float _2769;
  float _2770;
  float _2771;
  float _2786;
  float _2787;
  float _2788;
  float _2789;
  float _2790;
  bool _2856;
  bool _2857;
  float _2893;
  float _2894;
  float _2895;
  float _2896;
  float _2962;
  float _2965;
  float _2966;
  float _2967;
  float _2968;
  float _3003;
  float _3004;
  float _3005;
  float _3020;
  float _3049;
  float _3050;
  float _3051;
  float _3052;
  float _3053;
  half _3060;
  half _3061;
  half _3062;
  half _3063;
  half _3064;
  float _3065;
  float _3071;
  half _3072;
  half _3073;
  half _3074;
  half _3075;
  half _3076;
  float _3077;
  float _3078;
  float _3079;
  float _3080;
  float _3081;
  float _3082;
  half _3119;
  half _3120;
  half _3121;
  float _3136;
  float _3137;
  float _3138;
  float _3158;
  float _3218;
  float _3316;
  float _3317;
  float _3318;
  bool _3386;
  bool _3408;
  bool _3410;
  bool _3411;
  float _3428;
  int _3429;
  float _3430;
  float _3431;
  float _3432;
  float _3433;
  float _3434;
  float _3473;
  float _3510;
  float _3517;
  float _3518;
  float _3519;
  bool _3540;
  bool _3542;
  bool _3546;
  int _3547;
  float _3548;
  bool _3557;
  int _3558;
  float _3559;
  float _3562;
  int _3563;
  bool _3564;
  bool _3565;
  float _3582;
  float _3583;
  float _3584;
  float _3624;
  float _3895;
  float _3896;
  float _3897;
  float _3898;
  float _3899;
  float _3900;
  float _3901;
  float _3902;
  float _3903;
  float _4073;
  float _4074;
  float _4075;
  float _4076;
  float _4077;
  float _4078;
  float _4079;
  float _4080;
  float _4081;
  float _4171;
  float _4172;
  float _4173;
  float _4240;
  float _4241;
  float _4242;
  float _4243;
  float _4244;
  float _4245;
  float _4290;
  float _4291;
  float _4292;
  float _4293;
  float _4294;
  float _4295;
  float _4296;
  float _4297;
  float _4298;
  float _4313;
  float _4314;
  float _4315;
  float _4316;
  float _4317;
  float _4318;
  float _4319;
  float _4320;
  float _4321;
  float _4333;
  float _4334;
  float _4335;
  float _4637;
  float _4653;
  float _4654;
  float _4655;
  float _4656;
  float _4657;
  float _4658;
  float _4659;
  float _4660;
  float _4661;
  float _4672;
  float _4673;
  float _4674;
  float _4686;
  float _4687;
  float _4688;
  float _4689;
  float _4690;
  float _4691;
  float _4692;
  float _4693;
  float _4694;
  float _4695;
  float _4696;
  float _4697;
  float _4700;
  float _4701;
  float _4702;
  float _4703;
  float _4704;
  float _4705;
  float _4706;
  float _4707;
  float _4708;
  float _4709;
  float _4710;
  float _4711;
  float _4725;
  float _4726;
  float _4845;
  float _4846;
  float _4847;
  float _4848;
  float _4849;
  float _4850;
  float _4851;
  float _4852;
  float _4853;
  float _4897;
  // RenoDX: Foliage transmission accumulator
  float foliageTransR = 0.0f;
  float foliageTransG = 0.0f;
  float foliageTransB = 0.0f;
  half _4946;
  half _4947;
  half _4948;
  float _4961;
  float _4993;
  float _4994;
  float _5087;
  float _5088;
  float _5089;
  float _5159;
  float _5160;
  float _5161;
  bool _5218;
  float _5251;
  float _5252;
  float _5253;
  float _5274;
  float _5275;
  float _5276;
  float _5290;
  float _5291;
  float _5292;
  float _5311;
  float _5312;
  float _5313;
  if (!((((int)(((int)(_107.x < 1.0000000116860974e-07f)) | ((int)(_107.x == 1.0f))))) | ((int)(_112 == 10)))) {
    uint4 _124 = __3__36__0__0__g_baseColor.Load(int3(_94, _96, 0));
    float4 _130 = __3__36__0__0__g_normal.Load(int3(_94, _96, 0));
    half _139 = half(float((uint)((uint)(((uint)((uint)(_124.x)) >> 8) & 255))) * 0.003921568859368563f);
    half _143 = half(float((uint)((uint)(_124.x & 255))) * 0.003921568859368563f);
    half _148 = half(float((uint)((uint)(((uint)((uint)(_124.y)) >> 8) & 255))) * 0.003921568859368563f);
    half _152 = half(float((uint)((uint)(_124.y & 255))) * 0.003921568859368563f);
    half _157 = half(float((uint)((uint)(((uint)((uint)(_124.z)) >> 8) & 255))) * 0.003921568859368563f);
    half _161 = half(float((uint)((uint)(_124.z & 255))) * 0.003921568859368563f);
    uint _173 = uint((_130.w * 3.0f) + 0.5f);
    bool _174 = (_173 == 1);
    bool _175 = (_173 == 3);
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
      _292 = select((((int)(_112 == 24)) | ((int)(_112 == 29))), 0.0f, _152);
    } else {
      _289 = _193;
      _290 = _194;
      _291 = _195;
      _292 = _152;
    }
    half4 _294 = __3__36__0__0__g_diffuseResult.Load(int3(_94, _96, 0));
    float _298 = float(_294.x);
    float _299 = float(_294.y);
    float _300 = float(_294.z);
    [branch]
    if (_renderParams2.y > 0.0f) {
      half4 _306 = __3__36__0__0__g_sceneDiffuse.Load(int3(_94, _96, 0));
      _317 = (float(_306.x) + _298);
      _318 = (float(_306.y) + _299);
      _319 = (float(_306.z) + _300);
    } else {
      _317 = _298;
      _318 = _299;
      _319 = _300;
    }
    float4 _321 = __3__36__0__0__g_specularResult.Load(int3(_94, _96, 0));
    bool __defer_316_332 = false;
    if ((uint)_112 > (uint)11) {
      if (!(((int)((uint)_112 < (uint)21)) | ((int)(_112 == 107)))) {
        __defer_316_332 = true;
      } else {
        _335 = true;
      }
    } else {
      if (!(_112 == 6)) {
        __defer_316_332 = true;
      } else {
        _335 = true;
      }
    }
    if (__defer_316_332) {
      _335 = (_112 == 7);
    }
    bool _345 = ((int)(_112 == 38)) | (((int)(((int)((uint)(_112 + -27) < (uint)2)) | (((int)(((int)(_112 == 26)) | (((int)(((int)((uint)(_112 + -105) < (uint)2)) | (_175))))))))));
    float _346 = float(_289);
    float _347 = float(_290);
    float _348 = float(_291);
    float _350 = (_104 * 2.0f) + -1.0f;
    float _352 = 1.0f - (_105 * 2.0f);
    float _388 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _115, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _352, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _350))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
    float _389 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _115, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _352, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _350))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _388;
    float _390 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _115, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _352, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _350))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _388;
    float _391 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _115, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _352, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _350))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _388;
    float _393 = rsqrt(dot(float3(_389, _390, _391), float3(_389, _390, _391)));
    float _394 = _393 * _389;
    float _395 = _393 * _390;
    float _396 = _393 * _391;
    int _397 = _110.x & 126;
    bool _400 = ((int)(_397 == 66)) | ((int)(_112 == 54));
    bool _401 = (_112 == 33);
    bool _403 = (_112 == 55);
    if (((int)(_397 == 64)) | (((int)((((int)((_401) | (_400)))) | (((int)((_403) | (_345)))))))) {
      float4 _410 = __3__36__0__0__g_character.Load(int3(_94, _96, 0));
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
    if (!_401) {
      if (_403) {
        if (!(_418 < 0.0010000000474974513f)) {
          uint _428 = uint((_clothLightingCategory.x * _416) + 0.5f);
          if (((int)(_418 > 0.0f)) & ((int)((uint)_428 < (uint)(int)(uint(_clothLightingCategory.x))))) {
            float4 _matParam = _clothLightingParameter[_428];
            _442 = _418;
            _443 = min((1.0f - _matParam.y), _matParam.x);
            _444 = saturate(_417);
            _445 = _matParam.y;
            _446 = _matParam.x;
          } else {
            _442 = 0.0f;
            _443 = 0.0f;
            _444 = 0.0f;
            _445 = 0.0f;
            _446 = 0.0f;
          }
          _452 = _112;
          _453 = half((float4(_effectiveMetallicForVelvet, _debugCharacterSnowRate, _systemRandomSeed, _skinnedMeshDebugFlag).x) * _446);
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
    } else {
      uint _428 = uint((_clothLightingCategory.x * _416) + 0.5f);
      if (((int)(_418 > 0.0f)) & ((int)((uint)_428 < (uint)(int)(uint(_clothLightingCategory.x))))) {
        float4 _matParam = _clothLightingParameter[_428];
        _442 = _418;
        _443 = min((1.0f - _matParam.y), _matParam.x);
        _444 = saturate(_417);
        _445 = _matParam.y;
        _446 = _matParam.x;
      } else {
        _442 = 0.0f;
        _443 = 0.0f;
        _444 = 0.0f;
        _445 = 0.0f;
        _446 = 0.0f;
      }
      _452 = _112;
      _453 = half((float4(_effectiveMetallicForVelvet, _debugCharacterSnowRate, _systemRandomSeed, _skinnedMeshDebugFlag).x) * _446);
      _454 = _442;
      _455 = _443;
      _456 = _444;
      _457 = _445;
      _458 = _446;
    }
    if (!(_452 == 66)) {
      bool _462 = (_452 == 54);
      if (((int)(_452 == 67)) | (_462)) {
        float _469 = float((uint)((uint)(((int)((int4(_frameNumber).x) * 73)) & 127)));
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
            float _494 = (_416 * 2.0f) + -1.0f;
            float _495 = (_417 * 2.0f) + -1.0f;
            float _496 = (_418 * 2.0f) + -1.0f;
            float _498 = rsqrt(dot(float3(_494, _495, _496), float3(_494, _495, _496)));
            _503 = _490;
            _504 = (_498 * _494);
            _505 = (_498 * _495);
            _506 = (_498 * _496);
            _507 = 0.0h;
          }
          bool _510 = (_452 == 54);
          if ((_510) | ((int)((_452 & 126) == 66))) {
            float4 _514 = __3__36__0__0__g_bentCone.Load(int3(_94, _96, 0));
            float _521 = (_514.x * 2.0f) + -1.0f;
            float _522 = (_514.y * 2.0f) + -1.0f;
            float _523 = (_514.z * 2.0f) + -1.0f;
            float _525 = rsqrt(dot(float3(_521, _522, _523), float3(_521, _522, _523)));
            float _526 = _521 * _525;
            float _527 = _522 * _525;
            float _528 = _523 * _525;
            float _532 = float(saturate((_157 * 1.25h) + 0.25h));
            if (_510) {
              _547 = (((asfloat((int4(_globalLightParams).z)) * _532) + _bevelParams.y) + (asfloat((int4(_globalLightParams).w)) * float(_161)));
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
        if (_462) {
          _490 = _487;
          float _494 = (_416 * 2.0f) + -1.0f;
          float _495 = (_417 * 2.0f) + -1.0f;
          float _496 = (_418 * 2.0f) + -1.0f;
          float _498 = rsqrt(dot(float3(_494, _495, _496), float3(_494, _495, _496)));
          _503 = _490;
          _504 = (_498 * _494);
          _505 = (_498 * _495);
          _506 = (_498 * _496);
          _507 = 0.0h;
        } else {
          _503 = _487;
          _504 = _346;
          _505 = _347;
          _506 = _348;
          _507 = _488;
        }
        bool _510 = (_452 == 54);
        if ((_510) | ((int)((_452 & 126) == 66))) {
          float4 _514 = __3__36__0__0__g_bentCone.Load(int3(_94, _96, 0));
          float _521 = (_514.x * 2.0f) + -1.0f;
          float _522 = (_514.y * 2.0f) + -1.0f;
          float _523 = (_514.z * 2.0f) + -1.0f;
          float _525 = rsqrt(dot(float3(_521, _522, _523), float3(_521, _522, _523)));
          float _526 = _521 * _525;
          float _527 = _522 * _525;
          float _528 = _523 * _525;
          float _532 = float(saturate((_157 * 1.25h) + 0.25h));
          if (_510) {
            _547 = (((asfloat((int4(_globalLightParams).z)) * _532) + _bevelParams.y) + (asfloat((int4(_globalLightParams).w)) * float(_161)));
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
    } else {
      _490 = float(_453);
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
      if ((_510) | ((int)((_452 & 126) == 66))) {
        float4 _514 = __3__36__0__0__g_bentCone.Load(int3(_94, _96, 0));
        float _521 = (_514.x * 2.0f) + -1.0f;
        float _522 = (_514.y * 2.0f) + -1.0f;
        float _523 = (_514.z * 2.0f) + -1.0f;
        float _525 = rsqrt(dot(float3(_521, _522, _523), float3(_521, _522, _523)));
        float _526 = _521 * _525;
        float _527 = _522 * _525;
        float _528 = _523 * _525;
        float _532 = float(saturate((_157 * 1.25h) + 0.25h));
        if (_510) {
          _547 = (((asfloat((int4(_globalLightParams).z)) * _532) + _bevelParams.y) + (asfloat((int4(_globalLightParams).w)) * float(_161)));
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
    half2 _930 = __3__36__0__0__g_sceneAO.Load(int3(_94, _96, 0));
    bool __defer_910_940 = false;
    if (!((uint)_915 > (uint)11)) {
      if (!((uint)_915 > (uint)10)) {
        _941 = false;
        __defer_910_940 = true;
      } else {
        _944 = false;
        _945 = true;
      }
    } else {
      bool _938 = ((uint)_915 < (uint)19);
      if (!((uint)_915 < (uint)20)) {
        _941 = _938;
        __defer_910_940 = true;
      } else {
        _944 = _938;
        _945 = true;
      }
    }
    if (__defer_910_940) {
      _944 = _941;
      _945 = (_915 == 107);
    }
    bool _950 = (_915 == 65);
    bool _951 = (_950) | (((int)((_944) | (((int)(((int)(_915 == 96)) | (_945)))))));
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
        _974 = select(((_965 & 128) != 0), 1.0f, 0.0f);
        _975 = (float((uint)((uint)(_965 & 127))) * 0.007874015718698502f);
      } else {
        _974 = 0.0f;
        _975 = 0.0f;
      }
      half _976 = half(_975);
      bool _980 = (_976 > 0.99902344h);
      _985 = _974;
      _986 = _963;
      _987 = _976;
      _988 = select((((int)(_915 == 24)) | (_958)), 0.010002136f, _157);
      _989 = select(_980, 1.0f, _275);
      _990 = select(_980, 1.0f, _276);
      _991 = select(_980, 1.0f, _277);
    } else {
      _985 = 0.0f;
      _986 = 0.0f;
      _987 = select(_951, 0.0f, _911);
      _988 = _157;
      _989 = _275;
      _990 = _276;
      _991 = _277;
    }
    int _992 = _915 & -2;
    bool _993 = (_992 == 66);
    bool _994 = (_915 == 54);
    bool _995 = (_994) | (_993);
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
      bool __defer_1007_1023 = false;
      if ((uint)_112 > (uint)52) {
        if (!(((int)((_110.x & 125) == 105)) | ((int)((uint)_112 < (uint)68)))) {
          __defer_1007_1023 = true;
        } else {
          _1026 = true;
        }
      } else {
        if ((uint)_112 > (uint)10) {
          if ((uint)_112 < (uint)20) {
            if (_397 == 14) {
              __defer_1007_1023 = true;
            } else {
              _1026 = true;
            }
          } else {
            if (!((_110.x & 125) == 105)) {
              __defer_1007_1023 = true;
            } else {
              _1026 = true;
            }
          }
        } else {
          __defer_1007_1023 = true;
        }
      }
      if (__defer_1007_1023) {
        _1026 = (_112 == 98);
      }
    } else {
      _1026 = true;
    }
    [branch]
    if (_956) {
      uint _1029 = __3__36__0__0__g_depthOpaque.Load(int3(_94, _96, 0));
      _1035 = (float((uint)((uint)(_1029.x & 16777215))) * 5.960465188081798e-08f);
    } else {
      _1035 = _107.x;
    }
    float _1063 = mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).w), _1035, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).w), _352, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).w) * _350))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).w);
    if (_1026) {
      float2 _1070 = __3__36__0__0__g_velocity.Load(int3(_94, _96, 0));
      _1076 = (_1070.x * 2.0f);
      _1077 = (_1070.y * 2.0f);
    } else {
      _1076 = (((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).x), _1035, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).x), _352, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).x) * _350))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).x)) / _1063) - _350);
      _1077 = (((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).y), _1035, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).y), _352, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).y) * _350))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).y)) / _1063) - _352);
    }
    float _1079 = _nearFarProj.x / max(1.0000000116860974e-07f, _1035);
    float _1082 = (_1076 * 0.5f) + _104;
    float _1083 = _105 - (_1077 * 0.5f);
    float _1091 = select(((((int)(((int)(_1082 < 0.0f)) | ((int)(_1082 > 1.0f))))) | (((int)(((int)(_1083 < 0.0f)) | ((int)(_1083 > 1.0f)))))), 1.0f, 0.0f);
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
      bool __defer_1134_1152 = false;
      if ((uint)_112 > (uint)52) {
        if (!(((int)(_112 == 98)) | (((int)(((int)((_110.x & 125) == 105)) | ((int)((uint)_112 < (uint)68))))))) {
          __defer_1134_1152 = true;
        } else {
          _1163 = 0.0f;
        }
      } else {
        if ((uint)_112 > (uint)10) {
          if ((uint)_112 < (uint)20) {
            if (_397 == 14) {
              __defer_1134_1152 = true;
            } else {
              _1163 = 0.0f;
            }
          } else {
            if (!((_110.x & 125) == 105)) {
              __defer_1134_1152 = true;
            } else {
              _1163 = 0.0f;
            }
          }
        } else {
          __defer_1134_1152 = true;
        }
      }
      if (__defer_1134_1152) {
        _1163 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3((float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x), (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y), (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z)));
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
    bool _1214 = (_335) | ((int)((uint)(_915 + -97) < (uint)2));
    float _1216 = _1079 * _1079;
    float _1218 = (_1216 * select(_1214, 0.5f, 0.20000000298023224f)) + 1.0f;
    bool _1222 = ((uint)(_915 + -53) < (uint)15);
    if (_1222) {
      _1241 = (1000.0f - (saturate(float((bool)(uint)((sqrt((((float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x) * (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x)) + ((float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y) * (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y))) + ((float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z) * (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z))) * 50.0f) > 1.0f))) * 875.0f));
    } else {
      _1241 = 50.0f;
    }
    float _1251 = select((((int)(_915 == 57)) | (_1222)), 0.0f, ((max(0.0f, (_1079 + -1.0f)) * 0.10000000149011612f) * _temporalReprojectionParams.y));
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
      bool _1325 = ((int)(_1283 == 57)) | ((int)((uint)(_1283 + -53) < (uint)15));
      bool _1326 = ((int)(_1284 == 14592)) | ((int)((uint)((((uint)(_1133) >> 8) & 127) + -53) < (uint)15));
      bool _1327 = ((int)(_1285 == 3735552)) | ((int)((uint)((((uint)(_1133) >> 16) & 127) + -53) < (uint)15));
      bool _1328 = ((int)(_1286 == 956301312)) | ((int)((uint)((((uint)(_1133) >> 24) & 127) + -53) < (uint)15));
      int _1340 = _112 + -53;
      if (_1006) {
        _1346 = (((int)(_112 == 57)) | ((int)((uint)_1340 < (uint)15)));
      } else {
        _1346 = true;
      }
      bool _1355 = (_915 == 6);
      bool _1377 = ((uint)(_915 + -105) < (uint)3);
      bool _1384 = ((int)(_112 == 57)) | ((int)((uint)_1340 < (uint)15));
      _1418 = (float((bool)((uint)((((int)((_400) | (((int)(((int)(_1283 != 54)) & ((int)((_1133 & 126) != 66)))))))) & (((int)(!((((int)((((int)((_1133 & 128) != 0)) | (_1325)) ^ _1346))) | (((int)((((int)(_1355 ^ (_1283 == 6)))) | (((int)((((int)(_1377 ^ (((int)(_1283 == 107)) | ((int)((uint)(_1283 + -105) < (uint)2)))))) | (((int)(_1325 ^ _1384)))))))))))))))) * _1278);
      _1419 = (float((bool)((uint)((((int)((_400) | (((int)(((int)(_1284 != 13824)) & ((int)((_1133 & 32256) != 16896)))))))) & (((int)(!((((int)((((int)((_1133 & 32768) != 0)) | (_1326)) ^ _1346))) | (((int)((((int)(_1355 ^ (_1284 == 1536)))) | (((int)((((int)(_1377 ^ (((int)((_1133 & 32000) == 26880)) | ((int)(_1284 == 27136)))))) | (((int)(_1326 ^ _1384)))))))))))))))) * _1279);
      _1420 = (float((bool)((uint)((((int)((_400) | (((int)(((int)(_1285 != 3538944)) & ((int)((_1133 & 8257536) != 4325376)))))))) & (((int)(!((((int)((((int)((_1133 & 8388608) != 0)) | (_1327)) ^ _1346))) | (((int)((((int)(_1355 ^ (_1285 == 393216)))) | (((int)((((int)(_1377 ^ (((int)((_1133 & 8192000) == 6881280)) | ((int)(_1285 == 6946816)))))) | (((int)(_1327 ^ _1384)))))))))))))))) * _1280);
      _1421 = (float((bool)((uint)((((int)((_400) | (((int)(((int)(_1286 != 905969664)) & ((int)((_1133 & 2113929216) != 1107296256)))))))) & (((int)(!((((int)((((int)((int)_1133 < (int)0)) | (_1328)) ^ _1346))) | (((int)((((int)(_1355 ^ (_1286 == 100663296)))) | (((int)((((int)(_1377 ^ (((int)((_1133 & 2097152000) == 1761607680)) | ((int)(_1286 == 1778384896)))))) | (((int)(_1328 ^ _1384)))))))))))))))) * _1281);
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
    float _1526 = select(((_994) | (((int)((_993) | (_1214))))), 0.009999999776482582f, 1.0f);
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
    int _1564 = asint(__3__37__0__0__g_structureCounterBuffer.Load(8));
    [branch]
    if (!(WaveReadLaneFirst(_1564) == 0)) {
      uint _1572 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(((int)(_94 >> 5)), ((int)(_96 >> 5)), 0));
      int _1574 = _1572.x & 4;
      int _1576 = (uint)(_1574) >> 2;
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
    float _1595 = saturate(max(_1584, ((((_environmentLightingHistory[1]).w) + _temporalReprojectionParams.w) + _renderParams.y)));
    uint _1596 = _1101 + 1u;
    half4 _1598 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_1100, _1596, 0));
    uint _1603 = _1100 + 1u;
    half4 _1604 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_1603, _1596, 0));
    half4 _1609 = __3__36__0__0__g_diffuseResultPrev.Load(int3(_1603, _1101, 0));
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
    float _1645 = _bufferSizeAndInvSize.w * 2160.0f;
    float _1651 = saturate((_1628 * _1628) * 4.0f);
    float4 _1661 = __3__36__0__0__g_manyLightsMoments.SampleLevel(__3__40__0__0__g_sampler, float2(_104, _105), 0.0f);
    float _1665 = saturate(_1661.w);
    float _1667 = 1.0f / max(9.999999974752427e-07f, _1619);
    float _1668 = _1667 * _1559;
    float _1669 = _1667 * _1560;
    float _1670 = _1667 * _1561;
    float _1671 = _1667 * _1562;
    float _1672 = saturate(saturate(max(_1595, (1.0f / ((_1651 * min(31.0f, ((_1642 * 15.0f) * _1645))) + 1.0f))) + _renderParams.z));
    float _1714 = 1.0f / _exposure4.x;
    float _1731 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1671 * float(_1614.x)) + ((_1670 * float(_1609.x)) + ((_1668 * float(_1598.x)) + (_1669 * float(_1604.x))))))) * _exposure4.y)))));
    float _1732 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1671 * float(_1614.y)) + ((_1670 * float(_1609.y)) + ((_1668 * float(_1598.y)) + (_1669 * float(_1604.y))))))) * _exposure4.y)))));
    float _1733 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, (-0.0f - (min(0.0f, (-0.0f - ((_1671 * float(_1614.z)) + ((_1670 * float(_1609.z)) + ((_1668 * float(_1598.z)) + (_1669 * float(_1604.z))))))) * _exposure4.y)))));
    if (((int)(_915 != 54)) & (((int)(((int)(_992 != 66)) & ((int)(_renderParams.y == 0.0f)))))) {
      float _1741 = dot(float3(_1731, _1732, _1733), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _1756 = ((min(_1741, _1661.y) / max(9.999999974752427e-07f, _1741)) * _1665) + saturate(1.0f - _1665);
      _1761 = saturate((saturate(((_1661.x - _1741) * 5.0f) / max(9.999999974752427e-07f, _1661.x)) * 0.5f) + _1672);
      _1762 = (_1756 * _1731);
      _1763 = (_1756 * _1732);
      _1764 = (_1756 * _1733);
    } else {
      _1761 = _1672;
      _1762 = _1731;
      _1763 = _1732;
      _1764 = _1733;
    }
    float _1773 = ((_926 - _1762) * _1761) + _1762;
    float _1774 = ((_927 - _1763) * _1761) + _1763;
    float _1775 = ((_928 - _1764) * _1761) + _1764;
    __3__38__0__1__g_diffuseResultUAV[int2(_94, _96)] = half4(half(_1773), half(_1774), half(_1775), half(saturate(_1628 + 0.0625f)));
    float _1782 = float(_989);
    float _1783 = float(_990);
    float _1784 = float(_991);
    if (_915 == 53) {
      _1791 = saturate(((_1783 + _1782) + _1784) * 1.2000000476837158f);
    } else {
      _1791 = 1.0f;
    }
    float _1792 = float(_987);
    float _1798 = (0.699999988079071f / min(max(max(max(_1782, _1783), _1784), 0.009999999776482582f), 0.699999988079071f)) * _1791;
    float _1808 = (((_1798 * _1782) + -0.03999999910593033f) * _1792) + 0.03999999910593033f;
    float _1809 = (((_1798 * _1783) + -0.03999999910593033f) * _1792) + 0.03999999910593033f;
    float _1810 = (((_1798 * _1784) + -0.03999999910593033f) * _1792) + 0.03999999910593033f;
    if (!_956) {
      _1816 = saturate(1.0h - _930.x);
    } else {
      _1816 = 1.0h;
    }
    bool _1820 = ((int)(_915 == 98)) | ((int)(_992 == 96));
    if (!_1820) {
      bool __defer_1821_1827 = false;
      bool __branch_chain_1821;
      if ((uint)(_915 + -105) < (uint)2) {
        _1828 = _174;
        __branch_chain_1821 = true;
      } else {
        if (!((uint)(_915 + -11) < (uint)9)) {
          _1828 = false;
          __branch_chain_1821 = true;
        } else {
          _1859 = 0.0h;
          _1860 = _915;
          _1861 = 0.0f;
          _1862 = 0.0f;
          _1863 = 0.0f;
          __branch_chain_1821 = false;
        }
      }
      if (__branch_chain_1821) {
        __defer_1821_1827 = true;
      }
      if (__defer_1821_1827) {
        bool _1830 = ((int)(_915 == 107)) | (_1828);
        half _1833 = select(_1830, 0.0f, _987);
        if ((_1830) | (((int)(!_950)))) {
          bool __defer_1834_1840 = false;
          if (!(_915 == 33)) {
            if (_915 == 55) {
              if (!(_418 < 0.0010000000474974513f)) {
                __defer_1834_1840 = true;
              } else {
                _1859 = _1833;
                _1860 = 53;
                _1861 = 0.0f;
                _1862 = 0.0f;
                _1863 = 0.0f;
              }
            } else {
              _1859 = _1833;
              _1860 = _915;
              _1861 = 0.0f;
              _1862 = 0.0f;
              _1863 = 0.0f;
            }
          } else {
            __defer_1834_1840 = true;
          }
          if (__defer_1834_1840) {
            uint _1845 = uint((_clothLightingCategory.x * _416) + 0.5f);
            if (((int)(_418 > 0.0f)) & ((int)((uint)_1845 < (uint)(int)(uint(_clothLightingCategory.x))))) {
              float4 _matParam = _clothLightingParameter[_1845];
              _1859 = _1833;
              _1860 = _915;
              _1861 = min((1.0f - _matParam.y), _matParam.x);
              _1862 = saturate(_417);
              _1863 = _matParam.x;
            } else {
              _1859 = _1833;
              _1860 = _915;
              _1861 = 0.0f;
              _1862 = 0.0f;
              _1863 = 0.0f;
            }
          }
        } else {
          _1859 = 0.0h;
          _1860 = 65;
          _1861 = 0.0f;
          _1862 = 0.0f;
          _1863 = 0.0f;
        }
      }
    } else {
      _1859 = 0.0h;
      _1860 = _915;
      _1861 = 0.0f;
      _1862 = 0.0f;
      _1863 = 0.0f;
    }
    float _1865 = dot(float3(_394, _395, _396), float3(_346, _347, _348)) * 2.0f;
    float _1869 = _394 - (_1865 * _346);
    float _1870 = _395 - (_1865 * _347);
    float _1871 = _396 - (_1865 * _348);
    float _1873 = rsqrt(dot(float3(_1869, _1870, _1871), float3(_1869, _1870, _1871)));
    float _1874 = _1869 * _1873;
    float _1875 = _1870 * _1873;
    float _1876 = _1871 * _1873;
    float _1878 = abs(dot(float3(_346, _347, _348), float3(_218, _219, _220)));
    float _1884 = __3__36__0__0__g_specularRayHitDistance.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_104, _105), 0.0f);
    float _1886 = float(_988);
    float _1888 = ddx_coarse(_218);
    float _1889 = ddx_coarse(_219);
    float _1890 = ddx_coarse(_220);
    float _1891 = ddy_coarse(_218);
    float _1892 = ddy_coarse(_219);
    float _1893 = ddy_coarse(_220);
    float _1907 = select((((int)(_1886 < 0.800000011920929f)) & ((int)((1.0f / ((((sqrt(max(dot(float3(_1888, _1889, _1890), float3(_1888, _1889, _1890)), dot(float3(_1891, _1892, _1893), float3(_1891, _1892, _1893)))) * 10.0f) + saturate(1.0f - (_1878 * _1878))) * (10.0f / (_116 + 0.10000000149011612f))) + 1.0f)) > 0.9900000095367432f))), _1884.x, 0.0f);
    float _1908 = _1907 * _1874;
    float _1909 = _1907 * _1875;
    float _1910 = _1907 * _1876;
    float _1915 = dot(float3(_1908, _1909, _1910), float3((-0.0f - _346), (-0.0f - _347), (-0.0f - _348))) * 2.0f;
    float _1920 = ((_1915 * _346) + _389) + _1908;
    float _1922 = ((_1915 * _347) + _390) + _1909;
    float _1924 = ((_1915 * _348) + _391) + _1910;
    float _1948 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).x), _1924, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).x), _1922, (_1920 * (float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).x)))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).x);
    float _1952 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).y), _1924, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).y), _1922, (_1920 * (float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).y)))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).y);
    float _1956 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).z), _1924, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).z), _1922, (_1920 * (float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).z)))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).z);
    float _1960 = mad((float4(_viewProjRelative[0].z, _viewProjRelative[1].z, _viewProjRelative[2].z, _viewProjRelative[3].z).w), _1924, mad((float4(_viewProjRelative[0].y, _viewProjRelative[1].y, _viewProjRelative[2].y, _viewProjRelative[3].y).w), _1922, (_1920 * (float4(_viewProjRelative[0].x, _viewProjRelative[1].x, _viewProjRelative[2].x, _viewProjRelative[3].x).w)))) + (float4(_viewProjRelative[0].w, _viewProjRelative[1].w, _viewProjRelative[2].w, _viewProjRelative[3].w).w);
    float _1998 = mad((float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).w), _1960, mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).w), _1956, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).w), _1952, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).w) * _1948))));
    float _1999 = mad((float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).x), _1960, mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).x), _1956, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).x), _1952, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).x) * _1948)))) / _1998;
    float _2000 = mad((float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).y), _1960, mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).y), _1956, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).y), _1952, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).y) * _1948)))) / _1998;
    float _2004 = max(1.0000000116860974e-07f, (mad((float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).z), _1960, mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).z), _1956, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).z), _1952, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).z) * _1948)))) / _1998));
    float _2040 = mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).w), _2004, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).w), _2000, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).w) * _1999))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).w);
    float _2044 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).x), _2004, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).x), _2000, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).x) * _1999))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).x)) / _2040) - _1920;
    float _2045 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).y), _2004, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).y), _2000, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).y) * _1999))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).y)) / _2040) - _1922;
    float _2046 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).z), _2004, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).z), _2000, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).z) * _1999))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).z)) / _2040) - _1924;
    float _2047 = dot(float3(_2044, _2045, _2046), float3(_1874, _1875, _1876));
    float _2051 = _2044 - (_2047 * _1874);
    float _2052 = _2045 - (_2047 * _1875);
    float _2053 = _2046 - (_2047 * _1876);
    float _2072 = exp2(log2((saturate(_1907 * 0.125f) * (sqrt(1.0f - saturate(sqrt(((_2051 * _2051) + (_2052 * _2052)) + (_2053 * _2053)) / max(0.0010000000474974513f, _1907))) + -1.0f)) + 1.0f) * 8.0f);
    float _2073 = _2072 * _1499;
    float _2074 = _2072 * _1523;
    float _2075 = _2072 * _1475;
    float _2076 = _2072 * _1451;
    bool _2079 = (_renderParams.z > 0.0f);
    float _2081 = float(1.0h - _988);
    float _2085 = (_1999 - (_1948 / _1960)) - _1076;
    float _2086 = (_2000 - (_1952 / _1960)) - _1077;
    float _2095 = saturate((((_2081 * _2081) * (1.0f - (_1004 * 0.8999999761581421f))) * sqrt((_2086 * _2086) + (_2085 * _2085))) * select(_2079, 2000.0f, 500.0f));
    int _2100 = _1860 & -2;
    bool _2103 = (_1860 == 29);
    float _2106 = select(((((int)((_956) | (_2103)))) | (((int)(((int)(_2100 == 24)) | ((int)(_renderParams.y > 0.0f)))))), 1.0f, float(_930.y));
    float _2110 = float(_1859);
    float _2115 = min(max((_cavityParams.y + -1.0f), 0.0f), 2.0f);
    float _2141 = saturate(saturate(1.0f - (((_2110 * _116) / max(0.0010000000474974513f, _1004)) * 0.0010000000474974513f)) * 1.25f) * saturate(((((-0.05000000074505806f - (_2115 * 0.07500000298023224f)) + max(0.019999999552965164f, _1886)) + (saturate(_116 * 0.02500000037252903f) * 0.10000000149011612f)) * min(max((_116 + 1.0f), 5.0f), 50.0f)) * (1.0f - (saturate(_2110) * 0.75f)));
    if (_1860 == 64) {
      _2150 = ((saturate(_116 * 0.25f) * (_2141 + -0.39990234375f)) + 0.39990234375f);
    } else {
      _2150 = _2141;
    }
    float _2152 = (_2115 * 16.0f) + 16.0f;
    float _2158 = select((_2115 > 1.0f), 0.0f, saturate((1.0f / _2152) * (_116 - _2152)));
    bool __defer_2149_2168 = false;
    bool __branch_chain_2149;
    if (_1860 == 105) {
      _2169 = 1.0f;
      __branch_chain_2149 = true;
    } else {
      if (!((uint)(_1860 & 24) > (uint)23)) {
        _2169 = select((_1860 == 107), 1.0f, ((_2158 + _2150) - (_2158 * _2150)));
        __branch_chain_2149 = true;
      } else {
        _2173 = 0.0f;
        __branch_chain_2149 = false;
      }
    }
    if (__branch_chain_2149) {
      __defer_2149_2168 = true;
    }
    if (__defer_2149_2168) {
      _2173 = select((_1860 == 65), 0.0f, _2169);
    }
    float _2177 = select((_lightingParams.y == 0.0f), 0.0f, _2173);
    float _2182 = select((((int)(_1860 == 57)) | ((int)((uint)((int)(_1860 + -53u)) < (uint)15))), 31.0f, 63.0f);
    float _2190 = (saturate((_1632 * 2000.0f) * (1.0f - (_2177 * 0.75f))) * (7.0f - _2182)) + _2182;
    if ((uint)((int)(_1860 + -12u)) < (uint)9) {
      _2200 = ((saturate(_116 * 0.004999999888241291f) * (_2190 + -2.0f)) + 2.0f);
    } else {
      _2200 = _2190;
    }
    half _2204 = max(0.040008545h, _988);
    float _2219 = saturate(max(max(_1595, select(_2079, _2095, 0.0f)), (1.0f / (((min(64.0f, ((_2200 + 1.0f) * _1645)) * _1651) * ((saturate((_2177 + (_116 * 0.0078125f)) + float((_2204 * _2204) * 64.0h)) * 0.9375f) + 0.0625f)) + 1.0f))));
    bool __defer_2199_2242 = false;
    if ((uint)_1860 > (uint)52) {
      if (!((uint)_1860 < (uint)68)) {
        _2258 = _2073;
        _2259 = _2074;
        _2260 = _2075;
        _2261 = _2076;
        _2262 = max(0.099975586h, _988);
      } else {
        if (!(_2100 == 66)) {
          if (!(_1860 == 54)) {
            float _2230 = _2073 * _2073;
            float _2231 = _2074 * _2074;
            float _2232 = _2075 * _2075;
            float _2233 = _2076 * _2076;
            float _2234 = _2230 * _2230;
            float _2235 = _2231 * _2231;
            float _2236 = _2232 * _2232;
            float _2237 = _2233 * _2233;
            _2243 = (_2234 * _2234);
            _2244 = (_2235 * _2235);
            _2245 = (_2236 * _2236);
            _2246 = (_2237 * _2237);
          } else {
            _2243 = _2073;
            _2244 = _2074;
            _2245 = _2075;
            _2246 = _2076;
          }
          __defer_2199_2242 = true;
        } else {
          _2252 = _2073;
          _2253 = _2074;
          _2254 = _2075;
          _2255 = _2076;
          _2258 = _2252;
          _2259 = _2253;
          _2260 = _2254;
          _2261 = _2255;
          _2262 = max(0.89990234h, _988);
        }
      }
    } else {
      _2243 = _2073;
      _2244 = _2074;
      _2245 = _2075;
      _2246 = _2076;
      __defer_2199_2242 = true;
    }
    if (__defer_2199_2242) {
      if (((int)(_1860 == 54)) | ((int)(_2100 == 66))) {
        _2252 = _2243;
        _2253 = _2244;
        _2254 = _2245;
        _2255 = _2246;
        _2258 = _2252;
        _2259 = _2253;
        _2260 = _2254;
        _2261 = _2255;
        _2262 = max(0.89990234h, _988);
      } else {
        _2258 = _2243;
        _2259 = _2244;
        _2260 = _2245;
        _2261 = _2246;
        _2262 = max(0.099975586h, _988);
      }
    }
    float _2263 = float(_2262);
    float _2264 = _2263 * _2263;
    float _2265 = _2264 * _2264;
    float _2278 = (((_2265 * _2258) - _2258) * _2258) + 1.0f;
    float _2279 = (((_2265 * _2259) - _2259) * _2259) + 1.0f;
    float _2280 = (((_2265 * _2260) - _2260) * _2260) + 1.0f;
    float _2281 = (((_2265 * _2261) - _2261) * _2261) + 1.0f;
    float _2306 = saturate(select(_2103, 1.0f, saturate((_2265 / (_2278 * _2278)) * _2258)) * _1551);
    float _2307 = saturate(select(_2103, 1.0f, saturate((_2265 / (_2279 * _2279)) * _2259)) * _1553);
    float _2308 = saturate(select(_2103, 1.0f, saturate((_2265 / (_2280 * _2280)) * _2260)) * _1555);
    float _2309 = saturate(select(_2103, 1.0f, saturate((_2265 / (_2281 * _2281)) * _2261)) * _1557);
    bool _2311 = ((uint)(_1860 & 24) > (uint)23);
    if (((int)(_1860 != 29)) & (_2311)) {
      float _2328 = mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).w), _107.x, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).w), _352, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).w) * _350))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).w);
      float _2331 = ((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).x), _107.x, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).x), _352, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).x) * _350))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).x)) / _2328) - _350;
      float _2332 = ((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).y), _107.x, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).y), _352, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).y) * _350))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).y)) / _2328) - _352;
      float _2340 = (((_2331 * 0.5f) + _104) * _bufferSizeAndInvSize.x) + -0.5f;
      float _2341 = ((_105 - (_2332 * 0.5f)) * _bufferSizeAndInvSize.y) + -0.5f;
      int _2344 = int(floor(_2340));
      int _2345 = int(floor(_2341));
      float _2348 = _2340 - float((int)(_2344));
      float _2349 = _2341 - float((int)(_2345));
      float _2350 = 1.0f - _2348;
      float _2351 = 1.0f - _2349;
      _2379 = saturate((sqrt((_2332 * _2332) + (_2331 * _2331)) * 100.0f) + 0.125f);
      _2380 = _2344;
      _2381 = _2345;
      _2382 = (_2350 * _2349);
      _2383 = (_2349 * _2348);
      _2384 = (_2351 * _2348);
      _2385 = (_2351 * _2350);
    } else {
      float _2365 = saturate(_bufferSizeAndInvSize.y * 0.0006944444612599909f);
      if (_2103) {
        _2379 = saturate((_2219 + (_2095 * 0.5f)) + min(0.5f, (((_2365 * _2365) * _986) / (((_116 * _116) * 0.004999999888241291f) + 1.0f))));
        _2380 = _1100;
        _2381 = _1101;
        _2382 = _2306;
        _2383 = _2307;
        _2384 = _2308;
        _2385 = _2309;
      } else {
        _2379 = _2219;
        _2380 = _1100;
        _2381 = _1101;
        _2382 = _2306;
        _2383 = _2307;
        _2384 = _2308;
        _2385 = _2309;
      }
    }
    bool _2386 = (_2110 > 0.20000000298023224f);
    uint _2387 = _2381 + 1u;
    half4 _2389 = __3__36__0__0__g_specularResultPrev.Load(int3(_2380, _2387, 0));
    float _2402 = float((bool)((uint)(!(_2386 ^ (_2389.w < 0.0h))))) * _2382;
    uint _2408 = _2380 + 1u;
    half4 _2409 = __3__36__0__0__g_specularResultPrev.Load(int3(_2408, _2387, 0));
    float _2422 = float((bool)((uint)(!(_2386 ^ (_2409.w < 0.0h))))) * _2383;
    half4 _2432 = __3__36__0__0__g_specularResultPrev.Load(int3(_2408, _2381, 0));
    float _2445 = float((bool)((uint)(!(_2386 ^ (_2432.w < 0.0h))))) * _2384;
    half4 _2455 = __3__36__0__0__g_specularResultPrev.Load(int3(_2380, _2381, 0));
    float _2468 = float((bool)((uint)(!(_2386 ^ (_2455.w < 0.0h))))) * _2385;
    float _2488 = 1.0f / max(1.0000000168623835e-16f, dot(float4(_2402, _2422, _2445, _2468), float4(1.0f, 1.0f, 1.0f, 1.0f)));
    float _2490 = -0.0f - (min(0.0f, (-0.0f - ((((_2402 * float(_2389.x)) + (_2422 * float(_2409.x))) + (_2445 * float(_2432.x))) + (_2468 * float(_2455.x))))) * _2488);
    float _2492 = -0.0f - (min(0.0f, (-0.0f - ((((_2402 * float(_2389.y)) + (_2422 * float(_2409.y))) + (_2445 * float(_2432.y))) + (_2468 * float(_2455.y))))) * _2488);
    float _2494 = -0.0f - (min(0.0f, (-0.0f - ((((_2402 * float(_2389.z)) + (_2422 * float(_2409.z))) + (_2445 * float(_2432.z))) + (_2468 * float(_2455.z))))) * _2488);
    float _2495 = _2488 * min(0.0f, (-0.0f - ((((_2402 * abs(float(_2389.w))) + (_2422 * abs(float(_2409.w)))) + (_2445 * abs(float(_2432.w)))) + (_2468 * abs(float(_2455.w))))));
    if (((int)(_1860 != 54)) & (((int)(((int)(_2100 != 66)) & ((int)(_renderParams.y == 0.0f)))))) {
      float _2502 = dot(float3(_2490, _2492, _2494), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _2509 = ((min(_2502, _1661.z) / max(9.999999717180685e-10f, _2502)) * _1665) + saturate(1.0f - _1665);
      _2514 = (_2509 * _2490);
      _2515 = (_2509 * _2492);
      _2516 = (_2509 * _2494);
    } else {
      _2514 = _2490;
      _2515 = _2492;
      _2516 = _2494;
    }
    float _2517 = _2514 * _exposure4.y;
    float _2518 = _2515 * _exposure4.y;
    float _2519 = _2516 * _exposure4.y;
    float _2522 = saturate(_2379 + _renderParams.z);
    float _2534 = ((max(0.0010000000474974513f, float(_1816)) + _2495) * _2379) - _2495;
    float _2544 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_2522 * ((_2106 * _321.x) - _2517)) + _2517))));
    float _2545 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_2522 * ((_2106 * _321.y) - _2518)) + _2518))));
    float _2546 = -0.0f - min(0.0f, (-0.0f - min(30000.0f, ((_2522 * ((_2106 * _321.z) - _2519)) + _2519))));
    __3__38__0__1__g_specularResultUAV[int2(_94, _96)] = half4(half(_2544), half(_2545), half(_2546), half(select(_2386, (-0.0f - _2534), _2534)));
    float _2554 = select(_2311, 0.0f, _2534);
    float _2559 = float(half(lerp(_2554, 1.0f, _1886)));
    bool _2560 = (_2100 == 64);
    int _2562 = ((int)(uint)(_175)) ^ 1;
    if (!((((int)(uint)(_2560)) & _2562) == 0)) {
      _2579 = select((_cavityParams.z > 0.0f), select(_175, 0.0f, _417), 1.0f);
    } else {
      _2579 = saturate(exp2((_2559 * _2559) * (_116 * -0.005770780146121979f)));
    }
    bool _2582 = (_cavityParams.x == 0.0f);
    float _2583 = select(_2582, 1.0f, _2579);
    if (_2560) {
      _2589 = (_2583 * _1808);
      _2590 = (_2583 * _1809);
      _2591 = (_2583 * _1810);
    } else {
      _2589 = _1808;
      _2590 = _1809;
      _2591 = _1810;
    }
    if (((int)(_1860 == 54)) | ((int)(_2100 == 66))) {
      float2 _2606 = __3__36__0__0__g_hairBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, (1.0f - saturate(abs(dot(float3(_912, _913, _914), float3(_394, _395, _396)))))), (1.0f - max(0.75f, (_2559 * 2.0f)))), 0.0f);
      float2 _2612 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1004), (1.0f - _2559)), 0.0f);
      float _2619 = ((_2612.x - _2606.x) * _916) + _2606.x;
      float _2620 = ((_2612.y - _2606.y) * _916) + _2606.y;
      float _2622 = (_2619 * 0.009999999776482582f) + _2620;
      _2786 = _2619;
      _2787 = _2620;
      _2788 = _2622;
      _2789 = _2622;
      _2790 = _2622;
    } else {
      if ((uint)((int)(_1860 + -97u)) < (uint)2) {
        if (!(abs(_219) > 0.9900000095367432f)) {
          float _2630 = -0.0f - _220;
          float _2632 = rsqrt(dot(float3(_2630, 0.0f, _218), float3(_2630, 0.0f, _218)));
          _2636 = (_2632 * _2630);
          _2637 = (_2632 * _218);
        } else {
          _2636 = 1.0f;
          _2637 = 0.0f;
        }
        float _2639 = -0.0f - (_219 * _2637);
        float _2642 = (_2637 * _218) - (_2636 * _220);
        float _2643 = _2636 * _219;
        float _2645 = rsqrt(dot(float3(_2639, _2642, _2643), float3(_2639, _2642, _2643)));
        float _2653 = _viewPos.x + _389;
        float _2654 = _viewPos.y + _390;
        float _2655 = _viewPos.z + _391;
        float4 _2660 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_2636, 0.0f, _2637), float3(_2653, _2654, _2655)), dot(float3((_2645 * _2639), (_2642 * _2645), (_2645 * _2643)), float3(_2653, _2654, _2655))), 0.0f);
        float _2664 = _2660.x + -0.5f;
        float _2665 = _2660.y + -0.5f;
        float _2666 = _2660.z + -0.5f;
        float _2668 = rsqrt(dot(float3(_2664, _2665, _2666), float3(_2664, _2665, _2666)));
        float _2672 = (_2664 * _2668) + _346;
        float _2673 = (_2665 * _2668) + _347;
        float _2674 = (_2666 * _2668) + _348;
        float _2676 = rsqrt(dot(float3(_2672, _2673, _2674), float3(_2672, _2673, _2674)));
        float2 _2689 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1004), (1.0f - _2559)), 0.0f);
        float _2696 = _2689.y + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3((_2672 * _2676), (_2673 * _2676), (_2674 * _2676))))) * 512.0f) * 20.0f);
        _2786 = _2689.x;
        _2787 = _2689.y;
        _2788 = (_2696 + (_2689.x * _2589));
        _2789 = (_2696 + (_2689.x * _2590));
        _2790 = (_2696 + (_2689.x * _2591));
      } else {
        bool __defer_2700_2768 = false;
        if (_2560) {
          if (!(_1860 == 65)) {
            float _2706 = min(0.9900000095367432f, _1004);
            float2 _2711 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_2706, saturate(1.0f - (_2559 * 1.3300000429153442f))), 0.0f);
            float2 _2716 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_2706, saturate(1.0f - (_2559 * 0.47998046875f))), 0.0f);
            float _2720 = (_2716.x + _2711.x) * 0.5f;
            float _2722 = (_2716.y + _2711.y) * 0.5f;
            _2786 = _2720;
            _2787 = _2722;
            _2788 = ((_2720 * _2589) + _2722);
            _2789 = ((_2720 * _2590) + _2722);
            _2790 = ((_2720 * _2591) + _2722);
          } else {
            _2769 = _2589;
            _2770 = _2590;
            _2771 = _2591;
            __defer_2700_2768 = true;
          }
        } else {
          if (((int)(_1860 == 33)) | ((int)(_1860 == 55))) {
            float _2739 = max(dot(float3(_1782, _1783, _1784), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)), 0.03999999910593033f);
            float _2743 = sqrt(_1782) - _2739;
            float _2744 = sqrt(_1783) - _2739;
            float _2745 = sqrt(_1784) - _2739;
            float _2752 = saturate(1.0f - (pow(_1004, 4.0f)));
            _2769 = ((((_2743 * _1861) + _2739) + (_2752 * (_2743 * (_1863 - _1861)))) * _1862);
            _2770 = ((((_2744 * _1861) + _2739) + ((_2744 * (_1863 - _1861)) * _2752)) * _1862);
            _2771 = ((((_2745 * _1861) + _2739) + ((_2745 * (_1863 - _1861)) * _2752)) * _1862);
          } else {
            _2769 = _2589;
            _2770 = _2590;
            _2771 = _2591;
          }
          __defer_2700_2768 = true;
        }
        if (__defer_2700_2768) {
          float2 _2776 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1004), (1.0f - _2559)), 0.0f);
          _2786 = _2776.x;
          _2787 = _2776.y;
          _2788 = ((_2776.x * _2769) + _2776.y);
          _2789 = ((_2776.x * _2770) + _2776.y);
          _2790 = ((_2776.x * _2771) + _2776.y);
        }
      }
    }
    float _2793 = select(((_2560) | (_2311)), 1.0f, _2583) * _1714;
    float _2800 = _1773 * _1714;
    float _2801 = _1774 * _1714;
    float _2802 = _1775 * _1714;
    bool __defer_2785_3059 = false;
    if ((uint)_915 > (uint)52) {
      if (!(((int)((uint)_915 < (uint)68)) | (_956))) {
        if (!(((int)(_915 == 6)) | (((int)(((int)(_992 == 106)) | (((int)(((int)((uint)(_915 + -27) < (uint)2)) | (((int)(((int)(_915 == 105)) | ((int)(_915 == 26))))))))))))) {
          if (!(_915 == 7)) {
            float _2827 = exp2(log2(_2554) * (saturate(_116 * 0.03125f) + 1.0f));
            float4 _2837 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_104, _105), 0.0f);
            bool __defer_2821_2855 = false;
            bool __branch_chain_2821;
            if (((int)(_915 == 15)) | (((int)(((int)(_992 == 12)) | ((int)((_915 & -4) == 16)))))) {
              _2856 = false;
              _2857 = true;
              __branch_chain_2821 = true;
            } else {
              if (!((uint)_915 > (uint)10)) {
                _2856 = true;
                _2857 = false;
                __branch_chain_2821 = true;
              } else {
                if ((uint)_915 < (uint)20) {
                  _2856 = false;
                  _2857 = false;
                  __branch_chain_2821 = true;
                } else {
                  if (!(_915 == 97)) {
                    _2856 = (_915 != 107);
                    _2857 = false;
                    __branch_chain_2821 = true;
                  } else {
                    _3049 = _1792;
                    _3050 = _1886;
                    _3051 = _1782;
                    _3052 = _1783;
                    _3053 = _1784;
                    __branch_chain_2821 = false;
                  }
                }
              }
            }
            if (__branch_chain_2821) {
              __defer_2821_2855 = true;
            }
            if (__defer_2821_2855) {
              if (_2837.w < 1.0f) {
                if (((int4(_snowDetail, _iceRate, _snowRate, _weatherCheckFlag).w) & 5) == 5) {
                  bool _2867 = (_915 == 36);
                  if (!_2867) {
                    float4 _2887 = __3__36__0__0__g_climateSandTex.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((((_viewPos.x + _389) / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((((_viewPos.z + _391) / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                    _2893 = _2887.x;
                    _2894 = _2887.y;
                    _2895 = _2887.z;
                    _2896 = _2887.w;
                  } else {
                    _2893 = 0.11999999731779099f;
                    _2894 = 0.11999999731779099f;
                    _2895 = 0.10000000149011612f;
                    _2896 = 0.5f;
                  }
                  float _2903 = 1.0f - saturate(((_viewPos.y + _390) - (float4(_paramGlobalSand.x, _paramGlobalSand.y, __3__1__0__0__WeatherShadingConstants_005z, __3__1__0__0__WeatherShadingConstants_005w).x)) / (float4(_paramGlobalSand.x, _paramGlobalSand.y, __3__1__0__0__WeatherShadingConstants_005z, __3__1__0__0__WeatherShadingConstants_005w).y));
                  if (!(_2903 <= 0.0f)) {
                    float _2906 = saturate(_2827);
                    float _2919 = ((_2894 * 0.3395099937915802f) + (_2893 * 0.6131200194358826f)) + (_2895 * 0.047370001673698425f);
                    float _2920 = ((_2894 * 0.9163600206375122f) + (_2893 * 0.07020000368356705f)) + (_2895 * 0.013450000435113907f);
                    float _2921 = ((_2894 * 0.10958000272512436f) + (_2893 * 0.02061999961733818f)) + (_2895 * 0.8697999715805054f);
                    float _2926 = select(_2857, 1.0f, float((bool)(uint)(saturate(dot(float3(_346, _347, _348), float3(0.0f, 1.0f, 0.0f))) > 0.5f)));
                    bool __defer_2905_2961 = false;
                    if ((int4(_readBackBufferSize.x, _readBackBufferSize.y, _readBackFieldSize, _enableSandAO).w) == 1) {
                      float _2931 = 1.0f - _2837.x;
                      if (_2867) {
                        _2962 = ((((_2931 * 10.0f) * _2896) * _2903) * _2906);
                        __defer_2905_2961 = true;
                      } else {
                        float _2942 = saturate(_2896 + -0.5f);
                        _2965 = _2919;
                        _2966 = _2920;
                        _2967 = _2921;
                        _2968 = ((((_2942 * 2.0f) * max((_2926 * _2837.x), min((_2906 * ((_2837.x * 7.0f) + 3.0f)), (_2942 * 40.0f)))) + (((_2931 * 10.0f) * _2906) * saturate((0.5f - _2896) * 2.0f))) * _2903);
                      }
                    } else {
                      float _2960 = ((_2903 * _2896) * _2837.x) * _2926;
                      if (_2867) {
                        _2962 = _2960;
                        __defer_2905_2961 = true;
                      } else {
                        _2965 = _2919;
                        _2966 = _2920;
                        _2967 = _2921;
                        _2968 = _2960;
                      }
                    }
                    if (__defer_2905_2961) {
                      _2965 = _2919;
                      _2966 = _2920;
                      _2967 = _2921;
                      _2968 = saturate(_2962);
                    }
                  } else {
                    _2965 = 0.0f;
                    _2966 = 0.0f;
                    _2967 = 0.0f;
                    _2968 = 0.0f;
                  }
                  float _2972 = ((1.0f - _2837.w) * (1.0f - _2837.y)) * _2968;
                  bool _2973 = (_2972 > 9.999999747378752e-05f);
                  if (_2973) {
                    if (_2857) {
                      float _2976 = saturate(_2972);
                      _3003 = (((sqrt(_2965 * _1782) - _1782) * _2976) + _1782);
                      _3004 = (((sqrt(_2966 * _1783) - _1783) * _2976) + _1783);
                      _3005 = (((sqrt(_2967 * _1784) - _1784) * _2976) + _1784);
                    } else {
                      _3003 = ((_2972 * (_2965 - _1782)) + _1782);
                      _3004 = ((_2972 * (_2966 - _1783)) + _1783);
                      _3005 = ((_2972 * (_2967 - _1784)) + _1784);
                    }
                  } else {
                    _3003 = _1782;
                    _3004 = _1783;
                    _3005 = _1784;
                  }
                  if ((_2867) & (_2973)) {
                    if (_2857) {
                      _3020 = (((sqrt(_1886 * 0.25f) - _1886) * saturate(_2972)) + _1886);
                    } else {
                      _3020 = ((_2972 * (0.25f - _1886)) + _1886);
                    }
                  } else {
                    _3020 = _1886;
                  }
                  float _3021 = saturate(_3003);
                  float _3022 = saturate(_3004);
                  float _3023 = saturate(_3005);
                  float _3028 = (_3020 * (1.0f - _2827)) + _2827;
                  float _3031 = ((_3020 - _3028) * _2837.y) + _3028;
                  float _3038 = (((_2827 * _2827) * _2837.z) * float((bool)_2856)) * saturate(dot(float3(_346, _347, _348), float3(0.0f, 1.0f, 0.0f)));
                  float _3039 = _3038 * -0.5f;
                  _3049 = (_1792 - (_2827 * _1792));
                  _3050 = (_3031 - (_3038 * _3031));
                  _3051 = ((_3039 * _3021) + _3021);
                  _3052 = ((_3039 * _3022) + _3022);
                  _3053 = ((_3039 * _3023) + _3023);
                } else {
                  _3049 = _1792;
                  _3050 = _1886;
                  _3051 = _1782;
                  _3052 = _1783;
                  _3053 = _1784;
                }
              } else {
                _3049 = _1792;
                _3050 = _1886;
                _3051 = _1782;
                _3052 = _1783;
                _3053 = _1784;
              }
            }
            _3060 = half(_3049);
            _3061 = half(_3050);
            _3062 = half(_3051);
            _3063 = half(_3052);
            _3064 = half(_3053);
            _3065 = _2827;
          } else {
            _3060 = _987;
            _3061 = _988;
            _3062 = _989;
            _3063 = _990;
            _3064 = _991;
            _3065 = _2554;
          }
          __defer_2785_3059 = true;
        } else {
          _3071 = _2554;
          _3072 = _989;
          _3073 = _990;
          _3074 = _991;
          _3075 = _988;
          _3076 = _987;
          _3077 = _2800;
          _3078 = _2801;
          _3079 = _2802;
          _3080 = 0.0f;
          _3081 = 0.0f;
          _3082 = 0.0f;
        }
      } else {
        _3060 = _987;
        _3061 = _988;
        _3062 = _989;
        _3063 = _990;
        _3064 = _991;
        _3065 = _2554;
        __defer_2785_3059 = true;
      }
    } else {
      if (!_956) {
        if (!(((int)(_915 == 6)) | (((int)(((int)(_992 == 106)) | (((int)(((int)((uint)(_915 + -27) < (uint)2)) | (((int)(((int)(_915 == 105)) | ((int)(_915 == 26))))))))))))) {
          if (!(_915 == 7)) {
            float _2827 = exp2(log2(_2554) * (saturate(_116 * 0.03125f) + 1.0f));
            float4 _2837 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_104, _105), 0.0f);
            bool __defer_2821_2855 = false;
            bool __branch_chain_2821;
            if (((int)(_915 == 15)) | (((int)(((int)(_992 == 12)) | ((int)((_915 & -4) == 16)))))) {
              _2856 = false;
              _2857 = true;
              __branch_chain_2821 = true;
            } else {
              if (!((uint)_915 > (uint)10)) {
                _2856 = true;
                _2857 = false;
                __branch_chain_2821 = true;
              } else {
                if ((uint)_915 < (uint)20) {
                  _2856 = false;
                  _2857 = false;
                  __branch_chain_2821 = true;
                } else {
                  if (!(_915 == 97)) {
                    _2856 = (_915 != 107);
                    _2857 = false;
                    __branch_chain_2821 = true;
                  } else {
                    _3049 = _1792;
                    _3050 = _1886;
                    _3051 = _1782;
                    _3052 = _1783;
                    _3053 = _1784;
                    __branch_chain_2821 = false;
                  }
                }
              }
            }
            if (__branch_chain_2821) {
              __defer_2821_2855 = true;
            }
            if (__defer_2821_2855) {
              if (_2837.w < 1.0f) {
                if (((int4(_snowDetail, _iceRate, _snowRate, _weatherCheckFlag).w) & 5) == 5) {
                  bool _2867 = (_915 == 36);
                  if (!_2867) {
                    float4 _2887 = __3__36__0__0__g_climateSandTex.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((((_viewPos.x + _389) / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).x)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).x))), (1.0f - ((((_viewPos.z + _391) / (float4(_climateTextureOnePixelMeter.x, _climateTextureOnePixelMeter.y, _cloudScroll.x, _cloudScroll.y).y)) + float((int)((int)((int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y) >> 1)))) / float((int)(int4(_climateTextureSize.x, _climateTextureSize.y, _heightScaleMin, _heightScaleMax).y))))), 0.0f);
                    _2893 = _2887.x;
                    _2894 = _2887.y;
                    _2895 = _2887.z;
                    _2896 = _2887.w;
                  } else {
                    _2893 = 0.11999999731779099f;
                    _2894 = 0.11999999731779099f;
                    _2895 = 0.10000000149011612f;
                    _2896 = 0.5f;
                  }
                  float _2903 = 1.0f - saturate(((_viewPos.y + _390) - (float4(_paramGlobalSand.x, _paramGlobalSand.y, __3__1__0__0__WeatherShadingConstants_005z, __3__1__0__0__WeatherShadingConstants_005w).x)) / (float4(_paramGlobalSand.x, _paramGlobalSand.y, __3__1__0__0__WeatherShadingConstants_005z, __3__1__0__0__WeatherShadingConstants_005w).y));
                  if (!(_2903 <= 0.0f)) {
                    float _2906 = saturate(_2827);
                    float _2919 = ((_2894 * 0.3395099937915802f) + (_2893 * 0.6131200194358826f)) + (_2895 * 0.047370001673698425f);
                    float _2920 = ((_2894 * 0.9163600206375122f) + (_2893 * 0.07020000368356705f)) + (_2895 * 0.013450000435113907f);
                    float _2921 = ((_2894 * 0.10958000272512436f) + (_2893 * 0.02061999961733818f)) + (_2895 * 0.8697999715805054f);
                    float _2926 = select(_2857, 1.0f, float((bool)(uint)(saturate(dot(float3(_346, _347, _348), float3(0.0f, 1.0f, 0.0f))) > 0.5f)));
                    bool __defer_2905_2961 = false;
                    if ((int4(_readBackBufferSize.x, _readBackBufferSize.y, _readBackFieldSize, _enableSandAO).w) == 1) {
                      float _2931 = 1.0f - _2837.x;
                      if (_2867) {
                        _2962 = ((((_2931 * 10.0f) * _2896) * _2903) * _2906);
                        __defer_2905_2961 = true;
                      } else {
                        float _2942 = saturate(_2896 + -0.5f);
                        _2965 = _2919;
                        _2966 = _2920;
                        _2967 = _2921;
                        _2968 = ((((_2942 * 2.0f) * max((_2926 * _2837.x), min((_2906 * ((_2837.x * 7.0f) + 3.0f)), (_2942 * 40.0f)))) + (((_2931 * 10.0f) * _2906) * saturate((0.5f - _2896) * 2.0f))) * _2903);
                      }
                    } else {
                      float _2960 = ((_2903 * _2896) * _2837.x) * _2926;
                      if (_2867) {
                        _2962 = _2960;
                        __defer_2905_2961 = true;
                      } else {
                        _2965 = _2919;
                        _2966 = _2920;
                        _2967 = _2921;
                        _2968 = _2960;
                      }
                    }
                    if (__defer_2905_2961) {
                      _2965 = _2919;
                      _2966 = _2920;
                      _2967 = _2921;
                      _2968 = saturate(_2962);
                    }
                  } else {
                    _2965 = 0.0f;
                    _2966 = 0.0f;
                    _2967 = 0.0f;
                    _2968 = 0.0f;
                  }
                  float _2972 = ((1.0f - _2837.w) * (1.0f - _2837.y)) * _2968;
                  bool _2973 = (_2972 > 9.999999747378752e-05f);
                  if (_2973) {
                    if (_2857) {
                      float _2976 = saturate(_2972);
                      _3003 = (((sqrt(_2965 * _1782) - _1782) * _2976) + _1782);
                      _3004 = (((sqrt(_2966 * _1783) - _1783) * _2976) + _1783);
                      _3005 = (((sqrt(_2967 * _1784) - _1784) * _2976) + _1784);
                    } else {
                      _3003 = ((_2972 * (_2965 - _1782)) + _1782);
                      _3004 = ((_2972 * (_2966 - _1783)) + _1783);
                      _3005 = ((_2972 * (_2967 - _1784)) + _1784);
                    }
                  } else {
                    _3003 = _1782;
                    _3004 = _1783;
                    _3005 = _1784;
                  }
                  if ((_2867) & (_2973)) {
                    if (_2857) {
                      _3020 = (((sqrt(_1886 * 0.25f) - _1886) * saturate(_2972)) + _1886);
                    } else {
                      _3020 = ((_2972 * (0.25f - _1886)) + _1886);
                    }
                  } else {
                    _3020 = _1886;
                  }
                  float _3021 = saturate(_3003);
                  float _3022 = saturate(_3004);
                  float _3023 = saturate(_3005);
                  float _3028 = (_3020 * (1.0f - _2827)) + _2827;
                  float _3031 = ((_3020 - _3028) * _2837.y) + _3028;
                  float _3038 = (((_2827 * _2827) * _2837.z) * float((bool)_2856)) * saturate(dot(float3(_346, _347, _348), float3(0.0f, 1.0f, 0.0f)));
                  float _3039 = _3038 * -0.5f;
                  _3049 = (_1792 - (_2827 * _1792));
                  _3050 = (_3031 - (_3038 * _3031));
                  _3051 = ((_3039 * _3021) + _3021);
                  _3052 = ((_3039 * _3022) + _3022);
                  _3053 = ((_3039 * _3023) + _3023);
                } else {
                  _3049 = _1792;
                  _3050 = _1886;
                  _3051 = _1782;
                  _3052 = _1783;
                  _3053 = _1784;
                }
              } else {
                _3049 = _1792;
                _3050 = _1886;
                _3051 = _1782;
                _3052 = _1783;
                _3053 = _1784;
              }
            }
            _3060 = half(_3049);
            _3061 = half(_3050);
            _3062 = half(_3051);
            _3063 = half(_3052);
            _3064 = half(_3053);
            _3065 = _2827;
          } else {
            _3060 = _987;
            _3061 = _988;
            _3062 = _989;
            _3063 = _990;
            _3064 = _991;
            _3065 = _2554;
          }
          __defer_2785_3059 = true;
        } else {
          _3071 = _2554;
          _3072 = _989;
          _3073 = _990;
          _3074 = _991;
          _3075 = _988;
          _3076 = _987;
          _3077 = _2800;
          _3078 = _2801;
          _3079 = _2802;
          _3080 = 0.0f;
          _3081 = 0.0f;
          _3082 = 0.0f;
        }
      } else {
        _3060 = _987;
        _3061 = _988;
        _3062 = _989;
        _3063 = _990;
        _3064 = _991;
        _3065 = _2554;
        __defer_2785_3059 = true;
      }
    }
    if (__defer_2785_3059) {
      if (_995) {
        _3071 = _3065;
        _3072 = _3062;
        _3073 = _3063;
        _3074 = _3064;
        _3075 = _3061;
        _3076 = _3060;
        _3077 = 0.0f;
        _3078 = 0.0f;
        _3079 = 0.0f;
        _3080 = (_2800 * _917);
        _3081 = (_2801 * _918);
        _3082 = (_2802 * _919);
      } else {
        _3071 = _3065;
        _3072 = _3062;
        _3073 = _3063;
        _3074 = _3064;
        _3075 = _3061;
        _3076 = _3060;
        _3077 = _2800;
        _3078 = _2801;
        _3079 = _2802;
        _3080 = 0.0f;
        _3081 = 0.0f;
        _3082 = 0.0f;
      }
    }
    half4 _3084 = __3__36__0__0__g_sceneShadowColor.Load(int3(_94, _96, 0));
    [branch]
    if (_956) {
      uint _3091 = __3__36__0__0__g_sceneNormal.Load(int3(_94, _96, 0));
      float _3107 = min(1.0f, ((float((uint)((uint)(_3091.x & 1023))) * 0.001956947147846222f) + -1.0f));
      float _3108 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_3091.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
      float _3109 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_3091.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
      float _3111 = rsqrt(dot(float3(_3107, _3108, _3109), float3(_3107, _3108, _3109)));
      _3119 = half(_3111 * _3107);
      _3120 = half(_3111 * _3108);
      _3121 = half(_3111 * _3109);
    } else {
      _3119 = _289;
      _3120 = _290;
      _3121 = _291;
    }
    bool _3124 = (_sunDirection.y > 0.0f);
    bool __defer_3118_3129 = false;
    if ((_3124) || ((!(_3124)) && (_sunDirection.y > _moonDirection.y))) {
      __defer_3118_3129 = true;
    } else {
      _3136 = _moonDirection.x;
      _3137 = _moonDirection.y;
      _3138 = _moonDirection.z;
    }
    if (__defer_3118_3129) {
      _3136 = _sunDirection.x;
      _3137 = _sunDirection.y;
      _3138 = _sunDirection.z;
    }
    bool __defer_3135_3143 = false;
    if ((_3124) || ((!(_3124)) && (_sunDirection.y > _moonDirection.y))) {
      __defer_3135_3143 = true;
    } else {
      _3158 = ((0.5f - (dot(float3(_sunDirection.x, _sunDirection.y, _sunDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z)) * 0.5f)) * _precomputedAmbient7.w);
    }
    if (__defer_3135_3143) {
      _3158 = _precomputedAmbient7.y;
    }
    float _3163 = _viewPos.y + _390;
    float _3164 = _3163 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x);
    float _3168 = (_391 * _391) + (_389 * _389);
    float _3170 = sqrt((_3164 * _3164) + _3168);
    float _3175 = dot(float3((_389 / _3170), (_3164 / _3170), (_391 / _3170)), float3(_3136, _3137, _3138));
    float _3180 = min(max(((_3170 - (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x)) / (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y)), 16.0f), ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -16.0f));
    float _3188 = max(_3180, 0.0f);
    float _3195 = (-0.0f - sqrt((_3188 + ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x) * 2.0f)) * _3188)) / (_3188 + (float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).x));
    if (_3175 > _3195) {
      _3218 = ((exp2(log2(saturate((_3175 - _3195) / (1.0f - _3195))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
    } else {
      _3218 = ((exp2(log2(saturate((_3195 - _3175) / (_3195 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
    }
    float2 _3223 = __3__36__0__0__g_texNetDensity.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((exp2(log2(saturate((_3180 + -16.0f) / ((float4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).y) + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _3218), 0.0f);
    float _3245 = ((_3223.y * 1.9999999494757503e-05f) * (float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).y)) * ((float4(_mieScaledHeight, _mieAerosolDensity, _mieAerosolAbsorption, _miePhaseConst).z) + 1.0f);
    float _3263 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 16) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * 2.05560013455397e-06f)) * _3223.x) + _3245) * -1.4426950216293335f);
    float _3264 = exp2(((((float((uint)((uint)(((uint)((uint)(int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w)) >> 8) & 255))) * 1.960784317134312e-07f) + ((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * 4.978800461685751e-06f)) * _3223.x) + _3245) * -1.4426950216293335f);
    float _3265 = exp2((((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).x) * 2.1360001767334325e-07f) + (float((uint)((uint)((int4(_earthRadius, _atmosphereThickness, _rayleighScaledHeight, _rayleighScatteringColor).w) & 255))) * 1.960784317134312e-07f)) * _3223.x) + _3245) * -1.4426950216293335f);
    float _3281 = sqrt(_3168);
    float _3289 = ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).w) - (max(((_3281 * _3281) + -4e+05f), 0.0f) * 9.999999974752427e-07f)) - _viewPos.y;
    float _3301 = ((float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x) * (0.5f - (float((int)(((int)(uint)((int)(_3137 > 0.0f))) - ((int)(uint)((int)(_3137 < 0.0f))))) * 0.5f))) + _3289;
    if (_390 < _3289) {
      float _3304 = dot(float3(0.0f, 1.0f, 0.0f), float3(_3136, _3137, _3138));
      float _3310 = select((abs(_3304) < 9.99999993922529e-09f), 1e+08f, ((_3301 - dot(float3(0.0f, 1.0f, 0.0f), float3(_389, _390, _391))) / _3304));
      _3316 = ((_3310 * _3136) + _389);
      _3317 = _3301;
      _3318 = ((_3310 * _3138) + _391);
    } else {
      _3316 = _389;
      _3317 = _390;
      _3318 = _391;
    }
    float _3327 = __3__36__0__0__g_texCloudVolumeShadow.SampleLevel(__0__4__0__0__g_staticBilinearWrapUWClampV, float3(((_3316 * 4.999999873689376e-05f) + 0.5f), ((_3317 - _3289) / (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)), ((_3318 * 4.999999873689376e-05f) + 0.5f)), 0.0f);
    float _3338 = saturate(abs(_3137) * 4.0f);
    float _3340 = (_3338 * _3338) * exp2((((float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z) * -1.4426950216293335f) * _3327.x) * ((float4(_cloudScatteringCoefficient, _cloudPhaseConstFront, _cloudPhaseConstBack, _cloudAltitude).x) / (float4(_ozoneRatio, _directionalLightLuminanceScale, _distanceScale, _heightFogDensity).z)));
    float _3347 = ((1.0f - _3340) * saturate(((_390 - (float4(_cloudThickness, _cloudVisibleRange, _cloudNear, _cloudFadeRange).x)) - _3289) * 0.10000000149011612f)) + _3340;
    float _3348 = _3347 * (((_3264 * 0.3395099937915802f) + (_3263 * 0.6131200194358826f)) + (_3265 * 0.047370001673698425f));
    float _3349 = _3347 * (((_3264 * 0.9163600206375122f) + (_3263 * 0.07020000368356705f)) + (_3265 * 0.013450000435113907f));
    float _3350 = _3347 * (((_3264 * 0.10958000272512436f) + (_3263 * 0.02061999961733818f)) + (_3265 * 0.8697999715805054f));
    float _3366 = (((_3348 * 0.6131200194358826f) + (_3349 * 0.3395099937915802f)) + (_3350 * 0.047370001673698425f)) * _3158;
    float _3367 = (((_3348 * 0.07020000368356705f) + (_3349 * 0.9163600206375122f)) + (_3350 * 0.013450000435113907f)) * _3158;
    float _3368 = (((_3348 * 0.02061999961733818f) + (_3349 * 0.10958000272512436f)) + (_3350 * 0.8697999715805054f)) * _3158;
    float _3374 = float(_930.x);
    float _3375 = float(_3084.x);
    float _3376 = float(_3084.y);
    float _3377 = float(_3084.z);
    float _3378 = float(_3072);
    float _3379 = float(_3073);
    float _3380 = float(_3074);
    if (!_1820) {
      _3386 = ((_174) & ((int)((uint)(_915 + -105) < (uint)2)));
    } else {
      _3386 = true;
    }
    float _3388 = float(max(0.010002136h, _3075));
    float _3389 = float(_3076);
    bool _3392 = (_915 == 107);
    bool _3395 = (_950) | (((int)(((int)((uint)(_915 + -11) < (uint)9)) | (((int)((_3392) | (_3386)))))));
    float _3396 = select(_3395, 0.0f, _3389);
    bool __defer_3385_3407 = false;
    bool __branch_chain_3385;
    if (((int)(_992 == 26)) | (((int)(((int)(_915 == 105)) | ((int)(_915 == 28)))))) {
      _3408 = true;
      __branch_chain_3385 = true;
    } else {
      bool _3405 = (_915 == 106);
      if (!(_915 == 19)) {
        _3408 = _3405;
        __branch_chain_3385 = true;
      } else {
        _3410 = _3405;
        _3411 = true;
        __branch_chain_3385 = false;
      }
    }
    if (__branch_chain_3385) {
      __defer_3385_3407 = true;
    }
    if (__defer_3385_3407) {
      _3410 = _3408;
      _3411 = _3392;
    }
    float _3412 = float(_3119);
    float _3413 = float(_3120);
    float _3414 = float(_3121);
    uint16_t _3416 = __3__36__0__0__g_sceneDecalMask.Load(int3(_94, _96, 0));
    if (_915 == 97) {
      _3428 = (float((uint16_t)((uint)((uint16_t)((uint)(_3416.x)) >> 3))) * 0.032258063554763794f);
      _3429 = (((uint)((uint)((int)(min16uint)((int)((int)(_3416.x) & 4)))) >> 2) + 97);
      _3430 = 0.0f;
      _3431 = 0.0f;
      _3432 = 0.0f;
      _3433 = 0.0f;
      _3434 = 0.0f;
    } else {
      _3428 = select(_3395, _3389, 0.0f);
      _3429 = _915;
      _3430 = _454;
      _3431 = _455;
      _3432 = _456;
      _3433 = _457;
      _3434 = _458;
    }
    float _3439 = float(saturate(_194));
    float _3440 = _3439 * _3439;
    float _3441 = _3440 * _3440;
    float _3442 = _3441 * _3441;
    float4 _3449 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((_bufferSizeAndInvSize.z * _99), (_bufferSizeAndInvSize.w * _100)), 0.0f);
    float _3453 = ((_3442 * _3442) * select((((int)(_915 == 29)) | (((int)((_3410) | (_3411))))), 0.0f, 1.0f)) * _3449.y;
    float _3458 = _3412 - (_3453 * _3412);
    float _3459 = (_3453 * (1.0f - _3413)) + _3413;
    float _3460 = _3414 - (_3453 * _3414);
    float _3462 = rsqrt(dot(float3(_3458, _3459, _3460), float3(_3458, _3459, _3460)));
    float _3463 = _3458 * _3462;
    float _3464 = _3459 * _3462;
    float _3465 = _3460 * _3462;
    bool _3466 = (_3429 == 53);
    if (_3466) {
      _3473 = saturate(((_3379 + _3378) + _3380) * 1.2000000476837158f);
    } else {
      _3473 = 1.0f;
    }
    float _3479 = (0.699999988079071f / min(max(max(max(_3378, _3379), _3380), 0.009999999776482582f), 0.699999988079071f)) * _3473;
    float _3489 = (((_3479 * _3378) + -0.03999999910593033f) * _3396) + 0.03999999910593033f;
    float _3490 = (((_3479 * _3379) + -0.03999999910593033f) * _3396) + 0.03999999910593033f;
    float _3491 = (((_3479 * _3380) + -0.03999999910593033f) * _3396) + 0.03999999910593033f;
    float _3492 = float(_3075);
    int _3493 = _3429 & -2;
    bool _3494 = (_3493 == 64);
    bool _3497 = ((((int)(uint)(_3494)) & _2562) == 0);
    if (!_3497) {
      _3510 = select((_cavityParams.z > 0.0f), select(_175, 0.0f, _417), 1.0f);
    } else {
      _3510 = saturate(exp2((_3492 * _3492) * (_116 * -0.005770780146121979f)));
    }
    float _3511 = select(_2582, 1.0f, _3510);
    if (_3494) {
      _3517 = (_3511 * _3489);
      _3518 = (_3511 * _3490);
      _3519 = (_3511 * _3491);
    } else {
      _3517 = _3489;
      _3518 = _3490;
      _3519 = _3491;
    }
    // RenoDX: Geometric Specular AA
    float _rndx_spec_rough = _3388;
    if (SPECULAR_AA > 0.0f) {
      _rndx_spec_rough = NDFFilterRoughnessCS(float3(_3463, _3464, _3465), _3388, SPECULAR_AA);
    }
    float _3520 = _rndx_spec_rough * _rndx_spec_rough;
    float _3521 = _3520 * _3520;
    bool _3523 = ((uint)(_3429 + -97) < (uint)2);
    float _3525 = select(_3523, 0.5f, (_rndx_spec_rough * 0.60009765625f));
    float _3526 = _3525 * _3525;
    float _3527 = _3526 * _3526;
    bool _3528 = (_3429 == 33);
    if (!_3528) {
      bool _3530 = (_3429 == 55);
      int _3531 = (int)(uint)(_3530);
      if (!(((int)(_3429 == 98)) | ((int)(_3493 == 96)))) {
        if ((uint)(_3429 + -105) < (uint)2) {
          if (_3530) {
            _3542 = _174;
            _3546 = _3542;
            _3547 = ((int)(uint)((int)(_3430 > 0.0f)));
            _3548 = _3430;
            if ((uint)_3429 > (uint)11) {
              if (!(((int)((uint)_3429 < (uint)21)) | ((int)(_3429 == 107)))) {
                _3557 = _3546;
                _3558 = _3547;
                _3559 = _3548;
                _3562 = _3559;
                _3563 = _3558;
                _3564 = _3557;
                _3565 = (_3429 == 7);
              } else {
                _3562 = _3548;
                _3563 = _3547;
                _3564 = _3546;
                _3565 = true;
              }
            } else {
              if (!(_3429 == 6)) {
                _3557 = _3546;
                _3558 = _3547;
                _3559 = _3548;
                _3562 = _3559;
                _3563 = _3558;
                _3564 = _3557;
                _3565 = (_3429 == 7);
              } else {
                _3562 = _3548;
                _3563 = _3547;
                _3564 = _3546;
                _3565 = true;
              }
            }
          } else {
            _3557 = _174;
            _3558 = _3531;
            _3559 = 0.0f;
            _3562 = _3559;
            _3563 = _3558;
            _3564 = _3557;
            _3565 = (_3429 == 7);
          }
        } else {
          _3540 = false;
          if (_3530) {
            _3542 = _3540;
            _3546 = _3542;
            _3547 = ((int)(uint)((int)(_3430 > 0.0f)));
            _3548 = _3430;
          } else {
            _3546 = _3540;
            _3547 = _3531;
            _3548 = 0.0f;
          }
          if ((uint)_3429 > (uint)11) {
            if (!(((int)((uint)_3429 < (uint)21)) | ((int)(_3429 == 107)))) {
              _3557 = _3546;
              _3558 = _3547;
              _3559 = _3548;
              _3562 = _3559;
              _3563 = _3558;
              _3564 = _3557;
              _3565 = (_3429 == 7);
            } else {
              _3562 = _3548;
              _3563 = _3547;
              _3564 = _3546;
              _3565 = true;
            }
          } else {
            if (!(_3429 == 6)) {
              _3557 = _3546;
              _3558 = _3547;
              _3559 = _3548;
              _3562 = _3559;
              _3563 = _3558;
              _3564 = _3557;
              _3565 = (_3429 == 7);
            } else {
              _3562 = _3548;
              _3563 = _3547;
              _3564 = _3546;
              _3565 = true;
            }
          }
        }
      } else {
        _3540 = true;
        if (_3530) {
          _3542 = _3540;
          _3546 = _3542;
          _3547 = ((int)(uint)((int)(_3430 > 0.0f)));
          _3548 = _3430;
        } else {
          _3546 = _3540;
          _3547 = _3531;
          _3548 = 0.0f;
        }
        if ((uint)_3429 > (uint)11) {
          if (!(((int)((uint)_3429 < (uint)21)) | ((int)(_3429 == 107)))) {
            _3557 = _3546;
            _3558 = _3547;
            _3559 = _3548;
            _3562 = _3559;
            _3563 = _3558;
            _3564 = _3557;
            _3565 = (_3429 == 7);
          } else {
            _3562 = _3548;
            _3563 = _3547;
            _3564 = _3546;
            _3565 = true;
          }
        } else {
          if (!(_3429 == 6)) {
            _3557 = _3546;
            _3558 = _3547;
            _3559 = _3548;
            _3562 = _3559;
            _3563 = _3558;
            _3564 = _3557;
            _3565 = (_3429 == 7);
          } else {
            _3562 = _3548;
            _3563 = _3547;
            _3564 = _3546;
            _3565 = true;
          }
        }
      }
    } else {
      _3542 = false;
      _3546 = _3542;
      _3547 = ((int)(uint)((int)(_3430 > 0.0f)));
      _3548 = _3430;
      if ((uint)_3429 > (uint)11) {
        if (!(((int)((uint)_3429 < (uint)21)) | ((int)(_3429 == 107)))) {
          _3557 = _3546;
          _3558 = _3547;
          _3559 = _3548;
          _3562 = _3559;
          _3563 = _3558;
          _3564 = _3557;
          _3565 = (_3429 == 7);
        } else {
          _3562 = _3548;
          _3563 = _3547;
          _3564 = _3546;
          _3565 = true;
        }
      } else {
        if (!(_3429 == 6)) {
          _3557 = _3546;
          _3558 = _3547;
          _3559 = _3548;
          _3562 = _3559;
          _3563 = _3558;
          _3564 = _3557;
          _3565 = (_3429 == 7);
        } else {
          _3562 = _3548;
          _3563 = _3547;
          _3564 = _3546;
          _3565 = true;
        }
      }
    }
    float _3570 = exp2(log2(float(_3084.w)) * 2.200000047683716f) * 1000.0f;
    bool __defer_3561_3575 = false;
    if ((_3124) || ((!(_3124)) && (_sunDirection.y > _moonDirection.y))) {
      __defer_3561_3575 = true;
    } else {
      _3582 = _moonDirection.x;
      _3583 = _moonDirection.y;
      _3584 = _moonDirection.z;
    }
    if (__defer_3561_3575) {
      _3582 = _sunDirection.x;
      _3583 = _sunDirection.y;
      _3584 = _sunDirection.z;
    }
    float _3585 = _3366 * _lightingParams.x;
    float _3586 = _3367 * _lightingParams.x;
    float _3587 = _3368 * _lightingParams.x;
    float _3588 = _3582 - _394;
    float _3589 = _3583 - _395;
    float _3590 = _3584 - _396;
    float _3592 = rsqrt(dot(float3(_3588, _3589, _3590), float3(_3588, _3589, _3590)));
    float _3593 = _3592 * _3588;
    float _3594 = _3592 * _3589;
    float _3595 = _3592 * _3590;
    float _3596 = dot(float3(_3412, _3413, _3414), float3(_3582, _3583, _3584));
    float _3597 = dot(float3(_3463, _3464, _3465), float3(_3582, _3583, _3584));
    float _3599 = saturate(dot(float3(_3412, _3413, _3414), float3(_996, _997, _998)));
    float _3601 = saturate(dot(float3(_3463, _3464, _3465), float3(_3593, _3594, _3595)));
    float _3602 = dot(float3(_996, _997, _998), float3(_3593, _3594, _3595));
    float _3604 = saturate(dot(float3(_3582, _3583, _3584), float3(_3593, _3594, _3595)));
    bool _3605 = (_3493 == 66);
    bool _3606 = (_3429 == 54);
    bool _3607 = (_3606) | (_3605);
    bool __defer_3581_3894 = false;
    if (_3607) {
      if (_3606) {
        _3624 = (((asfloat((int4(_globalLightParams).z)) * _3388) + _bevelParams.y) + (asfloat((int4(_globalLightParams).w)) * float(_161)));
      } else {
        _3624 = _bevelParams.y;
      }
      float _3642 = (sqrt(_3168 + (_390 * _390)) * 2.0f) + 1.0f;
      float _3646 = (_916 * 7.0f) + 1.0f;
      float4 _3651 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2((((dot(float3(_389, _390, _391), float3(((_914 * _219) - (_913 * _220)), ((_912 * _220) - (_914 * _218)), ((_913 * _218) - (_912 * _219)))) * 2.0f) / _3642) * _3646), (((dot(float3(_389, _390, _391), float3(_912, _913, _914)) * 0.5f) / _3642) * _3646)), 0.0f);
      float _3655 = _916 * 0.5f;
      float _3656 = _3651.x * 2.0f;
      float _3657 = _3651.y * 2.0f;
      float _3658 = _3651.z * 2.0f;
      float _3669 = dot(float3(_912, _913, _914), float3(_3582, _3583, _3584));
      float _3670 = dot(float3(_912, _913, _914), float3(_996, _997, _998));
      float _3676 = cos(abs(asin(_3670) - asin(_3669)) * 0.5f);
      float _3680 = _3582 - (_3669 * _912);
      float _3681 = _3583 - (_3669 * _913);
      float _3682 = _3584 - (_3669 * _914);
      float _3686 = _996 - (_3670 * _912);
      float _3687 = _997 - (_3670 * _913);
      float _3688 = _998 - (_3670 * _914);
      float _3695 = rsqrt((dot(float3(_3686, _3687, _3688), float3(_3686, _3687, _3688)) * dot(float3(_3680, _3681, _3682), float3(_3680, _3681, _3682))) + 9.999999747378752e-05f) * dot(float3(_3680, _3681, _3682), float3(_3686, _3687, _3688));
      float _3699 = sqrt(saturate((_3695 * 0.5f) + 0.5f));
      float _3706 = min(max(max(0.05000000074505806f, _3388), 0.09803921729326248f), 1.0f);
      float _3707 = _3706 * _3706;
      float _3708 = _3707 * 0.5f;
      float _3709 = _3707 * 2.0f;
      float _3710 = _3670 + _3669;
      float _3711 = _3710 + (_3624 * 2.0f);
      float _3713 = (_3699 * 1.4142135381698608f) * _3707;
      float _3727 = 1.0f - sqrt(saturate((dot(float3(_996, _997, _998), float3(_3582, _3583, _3584)) * 0.5f) + 0.5f));
      float _3728 = _3727 * _3727;
      float _3735 = _3710 - _3624;
      float _3744 = 1.0f / ((1.190000057220459f / _3676) + (_3676 * 0.36000001430511475f));
      float _3749 = ((_3744 * (0.6000000238418579f - (_3695 * 0.800000011920929f))) + 1.0f) * _3699;
      float _3755 = 1.0f - (sqrt(saturate(1.0f - (_3749 * _3749))) * _3676);
      float _3756 = _3755 * _3755;
      float _3760 = 0.9534794092178345f - ((_3756 * _3756) * (_3755 * 0.9534794092178345f));
      float _3761 = _3744 * _3749;
      float _3766 = (sqrt(1.0f - (_3761 * _3761)) * 0.5f) / _3676;
      float _3767 = log2(_3378);
      float _3768 = log2(_3379);
      float _3769 = log2(_3380);
      float _3781 = ((_3760 * _3760) * (exp2((((_3735 * _3735) * -0.5f) / (_3708 * _3708)) * 1.4426950216293335f) / (_3707 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3695 * 5.2658371925354f));
      float _3785 = _3710 - (_3624 * 4.0f);
      float _3795 = 1.0f - (_3676 * 0.5f);
      float _3796 = _3795 * _3795;
      float _3800 = (_3796 * _3796) * (0.9534794092178345f - (_3676 * 0.47673970460891724f));
      float _3802 = 0.9534794092178345f - _3800;
      float _3803 = 0.800000011920929f / _3676;
      float _3816 = (((_3802 * _3802) * (_3800 + 0.04652056470513344f)) * (exp2((((_3785 * _3785) * -0.5f) / (_3709 * _3709)) * 1.4426950216293335f) / (_3707 * 5.013256549835205f))) * exp2((_3695 * 24.525815963745117f) + -24.208423614501953f);
      float _3823 = saturate(_3597);
      float _3824 = (((_3699 * 0.25f) * (exp2((((_3711 * _3711) * -0.5f) / (_3713 * _3713)) * 1.4426950216293335f) / (_3713 * 2.5066282749176025f))) * (((_3728 * _3728) * (_3727 * 0.9534794092178345f)) + 0.04652056470513344f)) * _3823;
      float _3834 = -0.0f - _3823;
      float _3845 = saturate((_3597 + 1.0f) * 0.25f);
      float _3850 = max(0.0010000000474974513f, dot(float3(_3378, _3379, _3380), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)));
      float _3869 = ((((1.0f - abs(_3597)) - _3845) * 0.33000001311302185f) + _3845) * 0.07957746833562851f;
      float _3871 = (exp2(log2(_3378 / _3850) * (1.0f - _3375)) * _3869) * sqrt(_3378);
      float _3873 = (exp2(log2(_3379 / _3850) * (1.0f - _3376)) * _3869) * sqrt(_3379);
      float _3875 = (exp2(log2(_3380 / _3850) * (1.0f - _3377)) * _3869) * sqrt(_3380);
      float _3882 = min(2048.0f, (-0.0f - min(0.0f, min(0.0f, (((_3816 * exp2(_3803 * _3767)) + (_3781 * exp2(_3767 * _3766))) * _3834)))));
      float _3883 = min(2048.0f, (-0.0f - min(0.0f, min(0.0f, (((_3816 * exp2(_3803 * _3768)) + (_3781 * exp2(_3768 * _3766))) * _3834)))));
      float _3884 = min(2048.0f, (-0.0f - min(0.0f, min(0.0f, (((_3816 * exp2(_3803 * _3769)) + (_3781 * exp2(_3769 * _3766))) * _3834)))));
      float _3891 = -0.0f - min(0.0f, (min(0.0f, (-0.0f - ((lerp(_3656, 1.0f, _3655)) * _3824))) * _3375));
      float _3892 = -0.0f - min(0.0f, (min(0.0f, (-0.0f - ((lerp(_3657, 1.0f, _3655)) * _3824))) * _3376));
      float _3893 = -0.0f - min(0.0f, (min(0.0f, (-0.0f - ((lerp(_3658, 1.0f, _3655)) * _3824))) * _3377));
      if (!_3605) {
        _3895 = _3882;
        _3896 = _3883;
        _3897 = _3884;
        _3898 = _3891;
        _3899 = _3892;
        _3900 = _3893;
        _3901 = _3871;
        _3902 = _3873;
        _3903 = _3875;
        __defer_3581_3894 = true;
      } else {
        _4313 = _3882;
        _4314 = _3883;
        _4315 = _3884;
        _4316 = _3891;
        _4317 = _3892;
        _4318 = _3893;
        _4319 = _3871;
        _4320 = _3873;
        _4321 = _3875;
      }
    } else {
      _3895 = 0.0f;
      _3896 = 0.0f;
      _3897 = 0.0f;
      _3898 = 0.0f;
      _3899 = 0.0f;
      _3900 = 0.0f;
      _3901 = 0.0f;
      _3902 = 0.0f;
      _3903 = 0.0f;
      __defer_3581_3894 = true;
    }
    if (__defer_3581_3894) {
      if (!_3606) {
        bool _3905 = (_3563 == 0);
        // RenoDX: Foliage stencil detection (stencil 12..18 inclusive)
        bool isFoliage = ((uint)(_112 - 12) < 7u);
        if (_3905) {
          if (((int)(_3596 > 0.0f)) | ((int)(_3597 > 0.0f))) {
            _4073 = 0.0f;
            _4074 = 0.0f;
            _4075 = 0.0f;
            _4076 = 0.0f;
            _4077 = 0.0f;
            _4078 = 0.0f;
            _4079 = 0.0f;
            _4080 = 0.0f;
            _4081 = 0.0f;
            if (!(_3430 > 0.9900000095367432f)) {
              float _4084 = saturate(_3596);
              float _4085 = 1.0f - _3521;
              float _4086 = 1.0f - _3604;
              float _4087 = _4086 * _4086;
              float _4090 = ((_4087 * _4087) * _4086) + _3604;
              float _4091 = 1.0f - _4084;
              float _4092 = _4091 * _4091;
              float _4097 = 1.0f - _3599;
              float _4098 = _4097 * _4097;
              float _4125;
              if (DIFFUSE_BRDF_MODE >= 2.0f) {
                // EON 2025 Diffuse
                float _eon_LdotV = dot(float3(_3582, _3583, _3584), float3(_996, _997, _998));
                _4125 = _4084 * EON_DiffuseScalar(_4084, _3599, _eon_LdotV, _3388);
              } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
                // Hammon 2017 Diffuse
                _4125 = _4084 * HammonDiffuseScalar(_4084, _3599, _3601, _3604, _3388);
              } else {
                // Vanilla Burley Diffuse
                _4125 = (_4084 * 0.31830987334251404f) * ((((_3604 * ((((_4085 * 34.5f) + -59.0f) * _4085) + 24.5f)) * exp2(-0.0f - (max(((_4085 * 73.19999694824219f) + -21.200000762939453f), 8.899999618530273f) * sqrt(_3601)))) + _4090) + ((((1.0f - ((_4092 * _4092) * (_4091 * 0.75f))) * (1.0f - ((_4098 * _4098) * (_4097 * 0.75f)))) - _4090) * saturate((_4085 * 2.200000047683716f) + -0.5f)));
              }
              float _4128 = saturate(1.0f - saturate(_3602));
              float _4129 = _4128 * _4128;
              float _4131 = (_4129 * _4129) * _4128;
              float _4134 = _4131 * saturate(_3518 * 50.0f);
              float _4135 = 1.0f - _4131;
              float _4139 = (_4135 * _3517) + _4134;
              float _4140 = (_4135 * _3518) + _4134;
              float _4141 = (_4135 * _3519) + _4134;
              if (!(_3429 == 29)) {
                float _4143 = saturate(_3597);
                float _4144 = 1.0f - _3520;
                float _4156 = (((_3601 * _3521) - _3601) * _3601) + 1.0f;
                float _4160 = (_3521 / ((_4156 * _4156) * 3.1415927410125732f)) * (0.5f / ((((_3599 * _4144) + _3520) * _3597) + (_3599 * ((_3597 * _4144) + _3520))));
                _4171 = (max((_4160 * _4139), 0.0f) * _4143);
                _4172 = (max((_4160 * _4140), 0.0f) * _4143);
                _4173 = (max((_4160 * _4141), 0.0f) * _4143);
              } else {
                _4171 = 0.0f;
                _4172 = 0.0f;
                _4173 = 0.0f;
              }
              // RenoDX: Diffraction on Rough Surfaces
              if (DIFFRACTION > 0.0f && _3396 > 0.0f) {
                float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
                  _3601, _3599, _rndx_spec_rough,
                  float2(_104, _105), _116,
                  float3(_3593, _3594, _3595),
                  float3(_3463, _3464, _3465),
                  float3(_3378, _3379, _3380)
                );
                float3 _rndx_dMod = lerp(float3(1.0f, 1.0f, 1.0f), _rndx_dShift, DIFFRACTION * _3396);
                _4171 *= _rndx_dMod.x;
                _4172 *= _rndx_dMod.y;
                _4173 *= _rndx_dMod.z;
              }
              // RenoDX: Callisto Smooth Terminator
              if (SMOOTH_TERMINATOR > 0.0f) {
                float _rndx_c2 = CallistoSmoothTerminator(_4084, _3604, _3601, SMOOTH_TERMINATOR, 0.5f);
                _4125 *= _rndx_c2;
                _4171 *= _rndx_c2;
                _4172 *= _rndx_c2;
                _4173 *= _rndx_c2;
              }
              // RenoDX: Foliage Transmission (first instance — standard path)
              if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
                float thickness = 0.5f;
                float wrap = 0.3f * FOLIAGE_TRANSMISSION;
                float energyScale = 1.0f - thickness * FOLIAGE_TRANSMISSION;
                float wrappedNdotL = max(0.0f, (_3596 + wrap) / (1.0f + wrap));
                float vanillaNdotL = saturate(_3596);
                if (vanillaNdotL > 0.01f) {
                  _4125 *= (wrappedNdotL / vanillaNdotL) * energyScale;
                } else {
                  _4125 = wrappedNdotL * 0.31830987334251404f * energyScale;
                }
                float transmissionNdotL = pow(saturate(-_3596), 1.5f);
                foliageTransR = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3378 * _3348 * _3585;
                foliageTransG = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3379 * _3349 * _3586;
                foliageTransB = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3380 * _3350 * _3587;
              }
              // RenoDX: Foliage diffuse energy compensation
              if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
                float _fNdotV = max(_3599, 0.001);
                float _fNdotL = saturate(_3596);
                float _fOneMinusV = 1.0 - _fNdotV;
                float _fOneMinusL = 1.0 - _fNdotL;
                float _fGrazingBoost = _fOneMinusV * _fOneMinusV * _fOneMinusL;
                float _fRoughFactor = _3388 * _3388;
                float _fCompensation = _fGrazingBoost * _fRoughFactor * 10.0;
                _4125 += _fCompensation * _fNdotL * RDXL_INV_PI;
              }
              bool _4174 = (_3429 == 65);
              bool __defer_4170_4212 = false;
              if (_3494) {
                if (!_4174) {
                  float _4181 = 1.0f - _3526;
                  float _4193 = (((_3601 * _3527) - _3601) * _3601) + 1.0f;
                  float _4197 = (_3527 / ((_4193 * _4193) * 3.1415927410125732f)) * (0.5f / ((((_3599 * _4181) + _3526) * _3597) + (_3599 * ((_3597 * _4181) + _3526))));
                  float _4204 = saturate(_3597) * 0.39990234375f;
                  _4240 = ((max((_4197 * _4139), 0.0f) * _4204) + (_4171 * 0.60009765625f));
                  _4241 = ((max((_4197 * _4140), 0.0f) * _4204) + (_4172 * 0.60009765625f));
                  _4242 = ((max((_4197 * _4141), 0.0f) * _4204) + (_4173 * 0.60009765625f));
                  _4243 = _4125;
                  _4244 = _4125;
                  _4245 = _4125;
                } else {
                  __defer_4170_4212 = true;
                }
              } else {
                if (_4174) {
                  __defer_4170_4212 = true;
                } else {
                  _4240 = _4171;
                  _4241 = _4172;
                  _4242 = _4173;
                  _4243 = _4125;
                  _4244 = _4125;
                  _4245 = _4125;
                }
              }
              if (__defer_4170_4212) {
                float _4217 = max(9.999999974752427e-07f, _exposure2.x);
                float _4226 = ((_4084 * 50.26548385620117f) * exp2(log2(saturate(dot(float3(_3463, _3464, _3465), float3(_996, _997, _998)))) * 16.0f)) / (((_4217 * _4217) * 1e+06f) + 1.0f);
                _4240 = _4171;
                _4241 = _4172;
                _4242 = _4173;
                _4243 = ((((_4226 * _3378) - _4125) * _3428) + _4125);
                _4244 = ((((_4226 * _3379) - _4125) * _3428) + _4125);
                _4245 = ((((_4226 * _3380) - _4125) * _3428) + _4125);
              }
            } else {
              _4240 = _3898;
              _4241 = _3899;
              _4242 = _3900;
              _4243 = _3901;
              _4244 = _3902;
              _4245 = _3903;
            }
            float _4249 = min(-0.0f, (-0.0f - _4243));
            float _4250 = min(-0.0f, (-0.0f - _4244));
            float _4251 = min(-0.0f, (-0.0f - _4245));
            float _4252 = -0.0f - _4249;
            float _4253 = -0.0f - _4250;
            float _4254 = -0.0f - _4251;
            _4313 = _3895;
            _4314 = _3896;
            _4315 = _3897;
            _4316 = (_4240 * _3375);
            _4317 = (_4241 * _3376);
            _4318 = (_4242 * _3377);
            _4319 = (_3375 * _4252);
            _4320 = (_3376 * _4253);
            _4321 = (_3377 * _4254);
          } else {
            _4313 = _3895;
            _4314 = _3896;
            _4315 = _3897;
            _4316 = _3898;
            _4317 = _3899;
            _4318 = _3900;
            _4319 = _3901;
            _4320 = _3902;
            _4321 = _3903;
          }
        } else {
          float _3920 = (saturate(_3596) * 0.31830987334251404f) * (((saturate(1.0f - (float4(_effectiveMetallicForVelvet, _debugCharacterSnowRate, _systemRandomSeed, _skinnedMeshDebugFlag).x)) + -1.0f) * _3434) + 1.0f);
          float _3926 = max(dot(float3(_3378, _3379, _3380), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)), 0.03999999910593033f);
          float _3927 = sqrt(_3378);
          float _3928 = sqrt(_3379);
          float _3929 = sqrt(_3380);
          float _3930 = _3927 - _3926;
          float _3931 = _3928 - _3926;
          float _3932 = _3929 - _3926;
          float _3939 = saturate(1.0f - (pow(_3599, 4.0f)));
          float _3952 = (((_3931 * _3431) + _3926) + ((_3931 * (_3434 - _3431)) * _3939)) * _3432;
          float _3955 = saturate(1.0f - saturate(_3602));
          float _3956 = _3955 * _3955;
          float _3958 = (_3956 * _3956) * _3955;
          float _3961 = _3958 * saturate(_3952 * 50.0f);
          float _3962 = 1.0f - _3958;
          float _3963 = _3962 * _3432;
          float _3967 = (_3963 * (((_3930 * _3431) + _3926) + (_3939 * (_3930 * (_3434 - _3431))))) + _3961;
          float _3968 = (_3962 * _3952) + _3961;
          float _3969 = (_3963 * (((_3932 * _3431) + _3926) + ((_3932 * (_3434 - _3431)) * _3939))) + _3961;
          float _3970 = min(_3601, 0.9998999834060669f);
          float _3971 = _3970 * _3970;
          float _3972 = 1.0f - _3971;
          float _3984 = (((exp2(((-0.0f - _3971) / (_3972 * _3521)) * 1.4426950216293335f) * 4.0f) / (_3972 * _3972)) + 1.0f) / ((_3521 * 12.566370964050293f) + 3.1415927410125732f);
          float _3988 = ((_3599 + _3597) - (_3599 * _3597)) * 4.0f;
          float _3992 = (_3967 * _3984) / _3988;
          float _3993 = (_3968 * _3984) / _3988;
          float _3994 = (_3969 * _3984) / _3988;
          float _3995 = 1.0f - _3520;
          float _4007 = (((_3601 * _3521) - _3601) * _3601) + 1.0f;
          float _4011 = (_3521 / ((_4007 * _4007) * 3.1415927410125732f)) * (0.5f / ((((_3599 * _3995) + _3520) * _3596) + (_3599 * ((_3596 * _3995) + _3520))));
          float _4027 = saturate(_3597);
          float _4032 = (_3433 * 1.5f) + 2.5f;
          float _4033 = _4032 * _4032;
          float _4043 = (max(0.0f, (0.30000001192092896f - _3596)) * 0.25f) * ((exp2(_4033 * -0.48089835047721863f) * 3.0f) + exp2(_4033 * -1.4426950216293335f));
          float _4068 = (((1.0f - _3434) * 0.47746479511260986f) * saturate(_3433)) * saturate((pow(_3601, 4.0f)) * exp2(log2(saturate(1.0f - abs(_3596))) * 3.0f));
          _4073 = (_4068 * _3927);
          _4074 = (_4068 * _3928);
          _4075 = (_4068 * _3929);
          _4076 = ((((max((_4011 * _3967), 0.0f) - _3992) * _3431) + _3992) * _4027);
          _4077 = ((((max((_4011 * _3968), 0.0f) - _3993) * _3431) + _3993) * _4027);
          _4078 = ((((max((_4011 * _3969), 0.0f) - _3994) * _3431) + _3994) * _4027);
          _4079 = (((_3927 * _3375) * _4043) + _3920);
          _4080 = (((_3928 * _3376) * _4043) + _3920);
          _4081 = (((_3929 * _3377) * _4043) + _3920);
          if (!(_3430 > 0.9900000095367432f)) {
            float _4084 = saturate(_3596);
            float _4085 = 1.0f - _3521;
            float _4086 = 1.0f - _3604;
            float _4087 = _4086 * _4086;
            float _4090 = ((_4087 * _4087) * _4086) + _3604;
            float _4091 = 1.0f - _4084;
            float _4092 = _4091 * _4091;
            float _4097 = 1.0f - _3599;
            float _4098 = _4097 * _4097;
            float _4125;
            if (DIFFUSE_BRDF_MODE >= 2.0f) {
              // EON 2025 Diffuse
              float _eon_LdotV = dot(float3(_3582, _3583, _3584), float3(_996, _997, _998));
              _4125 = _4084 * EON_DiffuseScalar(_4084, _3599, _eon_LdotV, _3388);
            } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
              // Hammon 2017 Diffuse
              _4125 = _4084 * HammonDiffuseScalar(_4084, _3599, _3601, _3604, _3388);
            } else {
              // Vanilla Burley Diffuse
              _4125 = (_4084 * 0.31830987334251404f) * ((((_3604 * ((((_4085 * 34.5f) + -59.0f) * _4085) + 24.5f)) * exp2(-0.0f - (max(((_4085 * 73.19999694824219f) + -21.200000762939453f), 8.899999618530273f) * sqrt(_3601)))) + _4090) + ((((1.0f - ((_4092 * _4092) * (_4091 * 0.75f))) * (1.0f - ((_4098 * _4098) * (_4097 * 0.75f)))) - _4090) * saturate((_4085 * 2.200000047683716f) + -0.5f)));
            }
            float _4128 = saturate(1.0f - saturate(_3602));
            float _4129 = _4128 * _4128;
            float _4131 = (_4129 * _4129) * _4128;
            float _4134 = _4131 * saturate(_3518 * 50.0f);
            float _4135 = 1.0f - _4131;
            float _4139 = (_4135 * _3517) + _4134;
            float _4140 = (_4135 * _3518) + _4134;
            float _4141 = (_4135 * _3519) + _4134;
            if (!(_3429 == 29)) {
              float _4143 = saturate(_3597);
              float _4144 = 1.0f - _3520;
              float _4156 = (((_3601 * _3521) - _3601) * _3601) + 1.0f;
              float _4160 = (_3521 / ((_4156 * _4156) * 3.1415927410125732f)) * (0.5f / ((((_3599 * _4144) + _3520) * _3597) + (_3599 * ((_3597 * _4144) + _3520))));
              _4171 = (max((_4160 * _4139), 0.0f) * _4143);
              _4172 = (max((_4160 * _4140), 0.0f) * _4143);
              _4173 = (max((_4160 * _4141), 0.0f) * _4143);
            } else {
              _4171 = 0.0f;
              _4172 = 0.0f;
              _4173 = 0.0f;
            }
            // RenoDX: Diffraction on Rough Surfaces
            if (DIFFRACTION > 0.0f && _3396 > 0.0f) {
              float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
                _3601, _3599, _rndx_spec_rough,
                float2(_104, _105), _116,
                float3(_3593, _3594, _3595),
                float3(_3463, _3464, _3465),
                float3(_3378, _3379, _3380)
              );
              float3 _rndx_dMod = lerp(float3(1.0f, 1.0f, 1.0f), _rndx_dShift, DIFFRACTION * _3396);
              _4171 *= _rndx_dMod.x;
              _4172 *= _rndx_dMod.y;
              _4173 *= _rndx_dMod.z;
            }
            // RenoDX: Callisto Smooth Terminator
            if (SMOOTH_TERMINATOR > 0.0f) {
              float _rndx_c2 = CallistoSmoothTerminator(_4084, _3604, _3601, SMOOTH_TERMINATOR, 0.5f);
              _4125 *= _rndx_c2;
              _4171 *= _rndx_c2;
              _4172 *= _rndx_c2;
              _4173 *= _rndx_c2;
            }
            // RenoDX: Foliage Transmission (second instance — character/special path)
            if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
              float thickness = 0.5f;
              float wrap = 0.3f * FOLIAGE_TRANSMISSION;
              float energyScale = 1.0f - thickness * FOLIAGE_TRANSMISSION;
              float wrappedNdotL = max(0.0f, (_3596 + wrap) / (1.0f + wrap));
              float vanillaNdotL = saturate(_3596);
              if (vanillaNdotL > 0.01f) {
                _4125 *= (wrappedNdotL / vanillaNdotL) * energyScale;
              } else {
                _4125 = wrappedNdotL * 0.31830987334251404f * energyScale;
              }
              float transmissionNdotL = pow(saturate(-_3596), 1.5f);
              foliageTransR = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3378 * _3348 * _3585;
              foliageTransG = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3379 * _3349 * _3586;
              foliageTransB = transmissionNdotL * thickness * FOLIAGE_TRANSMISSION * _3380 * _3350 * _3587;
            }
            // RenoDX: Foliage diffuse energy compensation (second path)
            if (FOLIAGE_TRANSMISSION > 0.0f && isFoliage) {
              float _fNdotV2 = max(_3599, 0.001);
              float _fNdotL2 = saturate(_3596);
              float _fOneMinusV2 = 1.0 - _fNdotV2;
              float _fOneMinusL2 = 1.0 - _fNdotL2;
              float _fGrazingBoost2 = _fOneMinusV2 * _fOneMinusV2 * _fOneMinusL2;
              float _fRoughFactor2 = _3388 * _3388;
              float _fCompensation2 = _fGrazingBoost2 * _fRoughFactor2 * 10.0;
              _4125 += _fCompensation2 * _fNdotL2 * RDXL_INV_PI;
            }
            bool _4174 = (_3429 == 65);
            bool __defer_4170_4212 = false;
            if (_3494) {
              if (!_4174) {
                float _4181 = 1.0f - _3526;
                float _4193 = (((_3601 * _3527) - _3601) * _3601) + 1.0f;
                float _4197 = (_3527 / ((_4193 * _4193) * 3.1415927410125732f)) * (0.5f / ((((_3599 * _4181) + _3526) * _3597) + (_3599 * ((_3597 * _4181) + _3526))));
                float _4204 = saturate(_3597) * 0.39990234375f;
                _4240 = ((max((_4197 * _4139), 0.0f) * _4204) + (_4171 * 0.60009765625f));
                _4241 = ((max((_4197 * _4140), 0.0f) * _4204) + (_4172 * 0.60009765625f));
                _4242 = ((max((_4197 * _4141), 0.0f) * _4204) + (_4173 * 0.60009765625f));
                _4243 = _4125;
                _4244 = _4125;
                _4245 = _4125;
              } else {
                __defer_4170_4212 = true;
              }
            } else {
              if (_4174) {
                __defer_4170_4212 = true;
              } else {
                _4240 = _4171;
                _4241 = _4172;
                _4242 = _4173;
                _4243 = _4125;
                _4244 = _4125;
                _4245 = _4125;
              }
            }
            if (__defer_4170_4212) {
              float _4217 = max(9.999999974752427e-07f, _exposure2.x);
              float _4226 = ((_4084 * 50.26548385620117f) * exp2(log2(saturate(dot(float3(_3463, _3464, _3465), float3(_996, _997, _998)))) * 16.0f)) / (((_4217 * _4217) * 1e+06f) + 1.0f);
              _4240 = _4171;
              _4241 = _4172;
              _4242 = _4173;
              _4243 = ((((_4226 * _3378) - _4125) * _3428) + _4125);
              _4244 = ((((_4226 * _3379) - _4125) * _3428) + _4125);
              _4245 = ((((_4226 * _3380) - _4125) * _3428) + _4125);
            }
          } else {
            _4240 = _3898;
            _4241 = _3899;
            _4242 = _3900;
            _4243 = _3901;
            _4244 = _3902;
            _4245 = _3903;
          }
          float _4249 = min(-0.0f, (-0.0f - _4243));
          float _4250 = min(-0.0f, (-0.0f - _4244));
          float _4251 = min(-0.0f, (-0.0f - _4245));
          float _4252 = -0.0f - _4249;
          float _4253 = -0.0f - _4250;
          float _4254 = -0.0f - _4251;
          bool _4256 = (_3430 > 0.0f);
          if (_4256) {
            _4290 = (_3895 - (_3895 * _3562));
            _4291 = (_3896 - (_3896 * _3562));
            _4292 = (_3897 - (_3897 * _3562));
            _4293 = (lerp(_4240, _4076, _3562));
            _4294 = (lerp(_4241, _4077, _3562));
            _4295 = (lerp(_4242, _4078, _3562));
            _4296 = (((_4249 + _4079) * _3562) - _4249);
            _4297 = (((_4250 + _4080) * _3562) - _4250);
            _4298 = (((_4251 + _4081) * _3562) - _4251);
          } else {
            _4290 = _3895;
            _4291 = _3896;
            _4292 = _3897;
            _4293 = _4240;
            _4294 = _4241;
            _4295 = _4242;
            _4296 = _4252;
            _4297 = _4253;
            _4298 = _4254;
          }
          float _4299 = _4296 * _3375;
          float _4300 = _4297 * _3376;
          float _4301 = _4298 * _3377;
          float _4302 = _4293 * _3375;
          float _4303 = _4294 * _3376;
          float _4304 = _4295 * _3377;
          if (_4256) {
            _4313 = _4290;
            _4314 = _4291;
            _4315 = _4292;
            _4316 = (_4302 + (_4073 * _3562));
            _4317 = (_4303 + (_4074 * _3562));
            _4318 = (_4304 + (_4075 * _3562));
            _4319 = _4299;
            _4320 = _4300;
            _4321 = _4301;
          } else {
            _4313 = _4290;
            _4314 = _4291;
            _4315 = _4292;
            _4316 = _4302;
            _4317 = _4303;
            _4318 = _4304;
            _4319 = _4299;
            _4320 = _4300;
            _4321 = _4301;
          }
        }
      } else {
        _4313 = _3895;
        _4314 = _3896;
        _4315 = _3897;
        _4316 = _3898;
        _4317 = _3899;
        _4318 = _3900;
        _4319 = _3901;
        _4320 = _3902;
        _4321 = _3903;
      }
    }
    if (_3565) {
      float _4325 = max(0.0f, (0.30000001192092896f - _3596)) * 0.23190687596797943f;
      _4333 = ((_4325 * _3375) + _4319);
      _4334 = ((_4325 * _3376) + _4320);
      _4335 = ((_4325 * _3377) + _4321);
    } else {
      _4333 = _4319;
      _4334 = _4320;
      _4335 = _4321;
    }
    float _4337 = 1.0f - (_3602 * 0.8500000238418579f);
    if (_3494) {
      float _4341 = max(4.0f, _3570);
      float _4342 = _4341 * _4341;
      float _4344 = exp2(_4342 * -225.4210968017578f);
      float _4349 = exp2(_4342 * -29.807748794555664f);
      float _4357 = exp2(_4342 * -7.714946269989014f);
      float _4363 = exp2(_4342 * -2.544435739517212f);
      float _4365 = _4363 * 0.007000000216066837f;
      float _4370 = exp2(_4342 * -0.7249723672866821f);
      float _4384 = saturate(dot(float3(_3582, _3583, _3584), float3((-0.0f - _218), _234, (-0.0f - _220))) + 0.30000001192092896f) * 0.31830987334251404f;
      _4672 = ((_4384 * ((((((_4349 * 0.10000000149011612f) + (_4344 * 0.2329999953508377f)) + (_4357 * 0.11800000071525574f)) + (_4363 * 0.11299999803304672f)) + (_4370 * 0.3580000102519989f)) + (exp2(_4342 * -0.19469568133354187f) * 0.07800000160932541f))) + _4333);
      _4673 = ((_4384 * (((((_4349 * 0.335999995470047f) + (_4344 * 0.45500001311302185f)) + (_4357 * 0.1979999989271164f)) + _4365) + (_4370 * 0.004000000189989805f))) + _4334);
      _4674 = ((_4384 * (((_4349 * 0.3440000116825104f) + (_4344 * 0.6489999890327454f)) + _4365)) + _4335);
      float _4675 = _4672 * _3585;
      float _4676 = _4673 * _3586;
      float _4677 = _4674 * _3587;
      float _4679 = (_4316 * _3585) * _3375;
      float _4681 = (_4317 * _3586) * _3376;
      float _4683 = (_4318 * _3587) * _3377;
      bool __branch_chain_4671;
      if (_3429 == 97) {
        _4700 = _4679;
        _4701 = _4681;
        _4702 = _4683;
        _4703 = _4675;
        _4704 = _4676;
        _4705 = _4677;
        _4706 = _4313;
        _4707 = _4314;
        _4708 = _4315;
        _4709 = _3375;
        _4710 = _3376;
        _4711 = _3377;
        __branch_chain_4671 = true;
      } else {
        _4686 = _4679;
        _4687 = _4681;
        _4688 = _4683;
        _4689 = _4675;
        _4690 = _4676;
        _4691 = _4677;
        _4692 = _4313;
        _4693 = _4314;
        _4694 = _4315;
        _4695 = _3375;
        _4696 = _3376;
        _4697 = _3377;
        if (_3429 == 98) {
          _4700 = _4686;
          _4701 = _4687;
          _4702 = _4688;
          _4703 = _4689;
          _4704 = _4690;
          _4705 = _4691;
          _4706 = _4692;
          _4707 = _4693;
          _4708 = _4694;
          _4709 = _4695;
          _4710 = _4696;
          _4711 = _4697;
          __branch_chain_4671 = true;
        } else {
          _4845 = _4689;
          _4846 = _4690;
          _4847 = _4691;
          _4848 = _4692;
          _4849 = _4693;
          _4850 = _4694;
          _4851 = _4686;
          _4852 = _4687;
          _4853 = _4688;
          __branch_chain_4671 = false;
        }
      }
      if (__branch_chain_4671) {
        if (((int)(_116 < 1000.0f)) & ((int)(_3076 == 0.0h))) {
          if (!(abs(_219) > 0.9900000095367432f)) {
            float _4719 = -0.0f - _220;
            float _4721 = rsqrt(dot(float3(_4719, 0.0f, _218), float3(_4719, 0.0f, _218)));
            _4725 = (_4721 * _4719);
            _4726 = (_4721 * _218);
          } else {
            _4725 = 1.0f;
            _4726 = 0.0f;
          }
          float _4728 = -0.0f - (_219 * _4726);
          float _4731 = (_4726 * _218) - (_4725 * _220);
          float _4732 = _4725 * _219;
          float _4734 = rsqrt(dot(float3(_4728, _4731, _4732), float3(_4728, _4731, _4732)));
          float _4740 = _viewPos.x + _389;
          float _4741 = _viewPos.z + _391;
          float4 _4746 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4725, 0.0f, _4726), float3(_4740, _3163, _4741)), dot(float3((_4734 * _4728), (_4731 * _4734), (_4734 * _4732)), float3(_4740, _3163, _4741))), 0.0f);
          float _4750 = _4746.x + -0.5f;
          float _4751 = _4746.y + -0.5f;
          float _4752 = _4746.z + -0.5f;
          float _4754 = rsqrt(dot(float3(_4750, _4751, _4752), float3(_4750, _4751, _4752)));
          float _4758 = (_4750 * _4754) + _3463;
          float _4759 = (_4751 * _4754) + _3464;
          float _4760 = (_4752 * _4754) + _3465;
          float _4762 = rsqrt(dot(float3(_4758, _4759, _4760), float3(_4758, _4759, _4760)));
          float _4763 = _4758 * _4762;
          float _4764 = _4759 * _4762;
          float _4765 = _4760 * _4762;
          float _4777 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
          float _4778 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
          float _4781 = saturate(_4777 * _4777);
          float _4782 = saturate(_4778 * _4778);
          float _4796 = dot(float3((-0.0f - _4763), (-0.0f - _4764), (-0.0f - _4765)), float3(_3582, _3583, _3584));
          float _4798 = saturate(dot(float3(_4763, _4764, _4765), float3(_996, _997, _998)));
          float _4800 = saturate(1.0f - _3602);
          float _4801 = _4800 * _4800;
          float _4803 = (_4801 * _4801) * _4800;
          float _4819 = 1.0f - ((_3601 * _3601) * 0.9998999834060669f);
          float _4826 = (max((((3.18309866997879e-05f / (_4819 * _4819)) * (0.5f / ((((_4798 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4796) + (_4798 * ((_4796 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4803, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4796)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4763, _4764, _4765)))) * 1024.0f) * 50.0f);
          float _4831 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4782 * _4782) * (3.0f - (_4782 * 2.0f)))) * (1.0f - ((_4781 * _4781) * (3.0f - (_4781 * 2.0f)))));
          _4845 = _4703;
          _4846 = _4704;
          _4847 = _4705;
          _4848 = _4706;
          _4849 = _4707;
          _4850 = _4708;
          _4851 = ((((_4831 * _3585) * _4709) * _4826) + _4700);
          _4852 = ((((_4831 * _3586) * _4710) * _4826) + _4701);
          _4853 = ((((_4831 * _3587) * _4711) * _4826) + _4702);
        } else {
          _4845 = _4703;
          _4846 = _4704;
          _4847 = _4705;
          _4848 = _4706;
          _4849 = _4707;
          _4850 = _4708;
          _4851 = _4700;
          _4852 = _4701;
          _4853 = _4702;
        }
      }
    } else {
      if (_3607) {
        float _4394 = dot(float3(_3378, _3379, _3380), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * _renderParams2.w;
        float _4397 = _4394 + (_3374 - (_4394 * _3374));
        float _4404 = (pow(_3375, 1.2000000476837158f));
        float _4405 = (pow(_3376, 1.2000000476837158f));
        float _4406 = (pow(_3377, 1.2000000476837158f));
        float _4412 = saturate(abs(dot(float3(_3582, _3583, _3584), float3(_912, _913, _914))));
        float2 _4421 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_4412, _3388, saturate(sqrt(sqrt(_3378)))), 0.0f);
        float2 _4424 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_4412, _3388, saturate(sqrt(sqrt(_3379)))), 0.0f);
        float2 _4427 = __3__36__0__0__g_hairDualScatteringLUT.SampleLevel(__3__40__0__0__g_samplerClamp, float3(_4412, _3388, saturate(sqrt(sqrt(_3380)))), 0.0f);
        float _4436 = min(0.9900000095367432f, _4421.x);
        float _4437 = min(0.9900000095367432f, _4424.x);
        float _4438 = min(0.9900000095367432f, _4427.x);
        float _4439 = min(0.9900000095367432f, _4421.y);
        float _4440 = min(0.9900000095367432f, _4424.y);
        float _4441 = min(0.9900000095367432f, _4427.y);
        float _4442 = _4436 * _4436;
        float _4443 = _4437 * _4437;
        float _4444 = _4438 * _4438;
        float _4445 = _4439 * _4439;
        float _4446 = _4440 * _4440;
        float _4447 = _4441 * _4441;
        float _4448 = _4445 * _4439;
        float _4449 = _4446 * _4440;
        float _4450 = _4447 * _4441;
        float _4451 = 1.0f - _4442;
        float _4452 = 1.0f - _4443;
        float _4453 = 1.0f - _4444;
        float _4463 = _4451 * _4451;
        float _4464 = _4452 * _4452;
        float _4465 = _4453 * _4453;
        float _4466 = _4463 * _4451;
        float _4467 = _4464 * _4452;
        float _4468 = _4465 * _4453;
        float _4476 = min(max(_3388, 0.18000000715255737f), 0.6000000238418579f);
        float _4477 = _4476 * _4476;
        float _4478 = _4477 * 0.25f;
        float _4479 = _4477 * 4.0f;
        float _4481 = (_4437 + _4436) + _4438;
        float _4482 = _4436 / _4481;
        float _4483 = _4437 / _4481;
        float _4484 = _4438 / _4481;
        float _4485 = dot(float3(_4477, _4478, _4479), float3(_4482, _4483, _4484));
        float _4486 = _4485 * _4485;
        float _4490 = (asin(min(max(dot(float3(_912, _913, _914), float3(_996, _997, _998)), -1.0f), 1.0f)) + asin(min(max(dot(float3(_912, _913, _914), float3(_3582, _3583, _3584)), -1.0f), 1.0f))) * 0.5f;
        float _4491 = dot(float3(-0.07000000029802322f, 0.03500000014901161f, 0.14000000059604645f), float3(_4482, _4483, _4484));
        float _4501 = _4491 * _4491;
        float _4524 = (_4440 + _4439) + _4441;
        float _4528 = dot(float3(_4477, _4478, _4479), float3((_4439 / _4524), (_4440 / _4524), (_4441 / _4524)));
        float _4532 = sqrt((_4528 * _4528) + (_4486 * 2.0f));
        float _4550 = (_4528 * 3.0f) + (_4485 * 2.0f);
        float _4557 = (((_4448 + _4439) * ((_4442 * 0.699999988079071f) + 1.0f)) * _4532) / ((_4550 * _4448) + _4439);
        float _4558 = (((_4449 + _4440) * ((_4443 * 0.699999988079071f) + 1.0f)) * _4532) / ((_4550 * _4449) + _4440);
        float _4559 = (((_4450 + _4441) * ((_4444 * 0.699999988079071f) + 1.0f)) * _4532) / ((_4550 * _4450) + _4441);
        float _4563 = _4490 - (((_4501 * (((_4442 * 4.0f) * _4445) + (_4463 * 2.0f))) * (1.0f - ((_4445 * 2.0f) / _4463))) / _4466);
        float _4570 = _4490 - (((_4501 * (((_4443 * 4.0f) * _4446) + (_4464 * 2.0f))) * (1.0f - ((_4446 * 2.0f) / _4464))) / _4467);
        float _4577 = _4490 - (((_4501 * (((_4444 * 4.0f) * _4447) + (_4465 * 2.0f))) * (1.0f - ((_4447 * 2.0f) / _4465))) / _4468);
        float _4585 = (1.0f - _916) * 2.0999999046325684f;
        float _4606 = (_916 * 0.31830987334251404f) * saturate(_3596);
        _4653 = _4404;
        _4654 = _4405;
        _4655 = _4406;
        _4656 = (((_4397 * _3585) * _4404) * ((((((_4448 * _4442) / _4466) + ((_4439 * _4442) / _4451)) * _4585) * exp2((((_4563 * _4563) * -0.5f) / ((_4557 * _4557) + _4486)) * 1.4426950216293335f)) + _4313));
        _4657 = (((_4397 * _3586) * _4405) * ((((((_4449 * _4443) / _4467) + ((_4440 * _4443) / _4452)) * _4585) * exp2((((_4570 * _4570) * -0.5f) / ((_4558 * _4558) + _4486)) * 1.4426950216293335f)) + _4314));
        _4658 = (((_4397 * _3587) * _4406) * ((((((_4450 * _4444) / _4468) + ((_4441 * _4444) / _4453)) * _4585) * exp2((((_4577 * _4577) * -0.5f) / ((_4559 * _4559) + _4486)) * 1.4426950216293335f)) + _4315));
        _4659 = (_4606 * _4404);
        _4660 = (_4606 * _4405);
        _4661 = (_4606 * _4406);
        _4686 = ((_4316 * _3585) * _4653);
        _4687 = ((_4317 * _3586) * _4654);
        _4688 = ((_4318 * _3587) * _4655);
        _4689 = (_4659 * _3585);
        _4690 = (_4660 * _3586);
        _4691 = (_4661 * _3587);
        _4692 = _4656;
        _4693 = _4657;
        _4694 = _4658;
        _4695 = _4653;
        _4696 = _4654;
        _4697 = _4655;
        if (_3429 == 98) {
          _4700 = _4686;
          _4701 = _4687;
          _4702 = _4688;
          _4703 = _4689;
          _4704 = _4690;
          _4705 = _4691;
          _4706 = _4692;
          _4707 = _4693;
          _4708 = _4694;
          _4709 = _4695;
          _4710 = _4696;
          _4711 = _4697;
          if (((int)(_116 < 1000.0f)) & ((int)(_3076 == 0.0h))) {
            if (!(abs(_219) > 0.9900000095367432f)) {
              float _4719 = -0.0f - _220;
              float _4721 = rsqrt(dot(float3(_4719, 0.0f, _218), float3(_4719, 0.0f, _218)));
              _4725 = (_4721 * _4719);
              _4726 = (_4721 * _218);
            } else {
              _4725 = 1.0f;
              _4726 = 0.0f;
            }
            float _4728 = -0.0f - (_219 * _4726);
            float _4731 = (_4726 * _218) - (_4725 * _220);
            float _4732 = _4725 * _219;
            float _4734 = rsqrt(dot(float3(_4728, _4731, _4732), float3(_4728, _4731, _4732)));
            float _4740 = _viewPos.x + _389;
            float _4741 = _viewPos.z + _391;
            float4 _4746 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4725, 0.0f, _4726), float3(_4740, _3163, _4741)), dot(float3((_4734 * _4728), (_4731 * _4734), (_4734 * _4732)), float3(_4740, _3163, _4741))), 0.0f);
            float _4750 = _4746.x + -0.5f;
            float _4751 = _4746.y + -0.5f;
            float _4752 = _4746.z + -0.5f;
            float _4754 = rsqrt(dot(float3(_4750, _4751, _4752), float3(_4750, _4751, _4752)));
            float _4758 = (_4750 * _4754) + _3463;
            float _4759 = (_4751 * _4754) + _3464;
            float _4760 = (_4752 * _4754) + _3465;
            float _4762 = rsqrt(dot(float3(_4758, _4759, _4760), float3(_4758, _4759, _4760)));
            float _4763 = _4758 * _4762;
            float _4764 = _4759 * _4762;
            float _4765 = _4760 * _4762;
            float _4777 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
            float _4778 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
            float _4781 = saturate(_4777 * _4777);
            float _4782 = saturate(_4778 * _4778);
            float _4796 = dot(float3((-0.0f - _4763), (-0.0f - _4764), (-0.0f - _4765)), float3(_3582, _3583, _3584));
            float _4798 = saturate(dot(float3(_4763, _4764, _4765), float3(_996, _997, _998)));
            float _4800 = saturate(1.0f - _3602);
            float _4801 = _4800 * _4800;
            float _4803 = (_4801 * _4801) * _4800;
            float _4819 = 1.0f - ((_3601 * _3601) * 0.9998999834060669f);
            float _4826 = (max((((3.18309866997879e-05f / (_4819 * _4819)) * (0.5f / ((((_4798 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4796) + (_4798 * ((_4796 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4803, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4796)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4763, _4764, _4765)))) * 1024.0f) * 50.0f);
            float _4831 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4782 * _4782) * (3.0f - (_4782 * 2.0f)))) * (1.0f - ((_4781 * _4781) * (3.0f - (_4781 * 2.0f)))));
            _4845 = _4703;
            _4846 = _4704;
            _4847 = _4705;
            _4848 = _4706;
            _4849 = _4707;
            _4850 = _4708;
            _4851 = ((((_4831 * _3585) * _4709) * _4826) + _4700);
            _4852 = ((((_4831 * _3586) * _4710) * _4826) + _4701);
            _4853 = ((((_4831 * _3587) * _4711) * _4826) + _4702);
          } else {
            _4845 = _4703;
            _4846 = _4704;
            _4847 = _4705;
            _4848 = _4706;
            _4849 = _4707;
            _4850 = _4708;
            _4851 = _4700;
            _4852 = _4701;
            _4853 = _4702;
          }
        } else {
          _4845 = _4689;
          _4846 = _4690;
          _4847 = _4691;
          _4848 = _4692;
          _4849 = _4693;
          _4850 = _4694;
          _4851 = _4686;
          _4852 = _4687;
          _4853 = _4688;
        }
      } else {
        if (_3564) {
          if (_3429 == 97) {
            _4700 = ((_4316 * _3585) * _3375);
            _4701 = ((_4317 * _3586) * _3376);
            _4702 = ((_4318 * _3587) * _3377);
            _4703 = (_4333 * _3585);
            _4704 = (_4334 * _3586);
            _4705 = (_4335 * _3587);
            _4706 = _4313;
            _4707 = _4314;
            _4708 = _4315;
            _4709 = _3375;
            _4710 = _3376;
            _4711 = _3377;
            if (((int)(_116 < 1000.0f)) & ((int)(_3076 == 0.0h))) {
              if (!(abs(_219) > 0.9900000095367432f)) {
                float _4719 = -0.0f - _220;
                float _4721 = rsqrt(dot(float3(_4719, 0.0f, _218), float3(_4719, 0.0f, _218)));
                _4725 = (_4721 * _4719);
                _4726 = (_4721 * _218);
              } else {
                _4725 = 1.0f;
                _4726 = 0.0f;
              }
              float _4728 = -0.0f - (_219 * _4726);
              float _4731 = (_4726 * _218) - (_4725 * _220);
              float _4732 = _4725 * _219;
              float _4734 = rsqrt(dot(float3(_4728, _4731, _4732), float3(_4728, _4731, _4732)));
              float _4740 = _viewPos.x + _389;
              float _4741 = _viewPos.z + _391;
              float4 _4746 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4725, 0.0f, _4726), float3(_4740, _3163, _4741)), dot(float3((_4734 * _4728), (_4731 * _4734), (_4734 * _4732)), float3(_4740, _3163, _4741))), 0.0f);
              float _4750 = _4746.x + -0.5f;
              float _4751 = _4746.y + -0.5f;
              float _4752 = _4746.z + -0.5f;
              float _4754 = rsqrt(dot(float3(_4750, _4751, _4752), float3(_4750, _4751, _4752)));
              float _4758 = (_4750 * _4754) + _3463;
              float _4759 = (_4751 * _4754) + _3464;
              float _4760 = (_4752 * _4754) + _3465;
              float _4762 = rsqrt(dot(float3(_4758, _4759, _4760), float3(_4758, _4759, _4760)));
              float _4763 = _4758 * _4762;
              float _4764 = _4759 * _4762;
              float _4765 = _4760 * _4762;
              float _4777 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
              float _4778 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
              float _4781 = saturate(_4777 * _4777);
              float _4782 = saturate(_4778 * _4778);
              float _4796 = dot(float3((-0.0f - _4763), (-0.0f - _4764), (-0.0f - _4765)), float3(_3582, _3583, _3584));
              float _4798 = saturate(dot(float3(_4763, _4764, _4765), float3(_996, _997, _998)));
              float _4800 = saturate(1.0f - _3602);
              float _4801 = _4800 * _4800;
              float _4803 = (_4801 * _4801) * _4800;
              float _4819 = 1.0f - ((_3601 * _3601) * 0.9998999834060669f);
              float _4826 = (max((((3.18309866997879e-05f / (_4819 * _4819)) * (0.5f / ((((_4798 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4796) + (_4798 * ((_4796 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4803, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4796)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4763, _4764, _4765)))) * 1024.0f) * 50.0f);
              float _4831 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4782 * _4782) * (3.0f - (_4782 * 2.0f)))) * (1.0f - ((_4781 * _4781) * (3.0f - (_4781 * 2.0f)))));
              _4845 = _4703;
              _4846 = _4704;
              _4847 = _4705;
              _4848 = _4706;
              _4849 = _4707;
              _4850 = _4708;
              _4851 = ((((_4831 * _3585) * _4709) * _4826) + _4700);
              _4852 = ((((_4831 * _3586) * _4710) * _4826) + _4701);
              _4853 = ((((_4831 * _3587) * _4711) * _4826) + _4702);
            } else {
              _4845 = _4703;
              _4846 = _4704;
              _4847 = _4705;
              _4848 = _4706;
              _4849 = _4707;
              _4850 = _4708;
              _4851 = _4700;
              _4852 = _4701;
              _4853 = _4702;
            }
          } else {
            if (!((uint)(_3429 + -105) < (uint)2)) {
              if (!(_3570 >= 999.9000244140625f)) {
                _4637 = ((max(0.0020000000949949026f, _3570) * 0.4000000059604645f) / ((_3428 * 100.0f) + 0.10000000149011612f));
              } else {
                _4637 = 1000.0f;
              }
              float _4638 = _4637 * _4637;
              float _4648 = (((_3428 * 0.25f) * (0.022082746028900146f / (_4337 * _4337))) * max(0.0f, (0.30000001192092896f - _3596))) * ((exp2(_4638 * -0.48089835047721863f) * 3.0f) + exp2(_4638 * -1.4426950216293335f));
              _4672 = (_4648 + _4333);
              _4673 = (_4648 + _4334);
              _4674 = (_4648 + _4335);
              float _4675 = _4672 * _3585;
              float _4676 = _4673 * _3586;
              float _4677 = _4674 * _3587;
              float _4679 = (_4316 * _3585) * _3375;
              float _4681 = (_4317 * _3586) * _3376;
              float _4683 = (_4318 * _3587) * _3377;
              bool __branch_chain_4671;
              if (_3429 == 97) {
                _4700 = _4679;
                _4701 = _4681;
                _4702 = _4683;
                _4703 = _4675;
                _4704 = _4676;
                _4705 = _4677;
                _4706 = _4313;
                _4707 = _4314;
                _4708 = _4315;
                _4709 = _3375;
                _4710 = _3376;
                _4711 = _3377;
                __branch_chain_4671 = true;
              } else {
                _4686 = _4679;
                _4687 = _4681;
                _4688 = _4683;
                _4689 = _4675;
                _4690 = _4676;
                _4691 = _4677;
                _4692 = _4313;
                _4693 = _4314;
                _4694 = _4315;
                _4695 = _3375;
                _4696 = _3376;
                _4697 = _3377;
                if (_3429 == 98) {
                  _4700 = _4686;
                  _4701 = _4687;
                  _4702 = _4688;
                  _4703 = _4689;
                  _4704 = _4690;
                  _4705 = _4691;
                  _4706 = _4692;
                  _4707 = _4693;
                  _4708 = _4694;
                  _4709 = _4695;
                  _4710 = _4696;
                  _4711 = _4697;
                  __branch_chain_4671 = true;
                } else {
                  _4845 = _4689;
                  _4846 = _4690;
                  _4847 = _4691;
                  _4848 = _4692;
                  _4849 = _4693;
                  _4850 = _4694;
                  _4851 = _4686;
                  _4852 = _4687;
                  _4853 = _4688;
                  __branch_chain_4671 = false;
                }
              }
              if (__branch_chain_4671) {
                if (((int)(_116 < 1000.0f)) & ((int)(_3076 == 0.0h))) {
                  if (!(abs(_219) > 0.9900000095367432f)) {
                    float _4719 = -0.0f - _220;
                    float _4721 = rsqrt(dot(float3(_4719, 0.0f, _218), float3(_4719, 0.0f, _218)));
                    _4725 = (_4721 * _4719);
                    _4726 = (_4721 * _218);
                  } else {
                    _4725 = 1.0f;
                    _4726 = 0.0f;
                  }
                  float _4728 = -0.0f - (_219 * _4726);
                  float _4731 = (_4726 * _218) - (_4725 * _220);
                  float _4732 = _4725 * _219;
                  float _4734 = rsqrt(dot(float3(_4728, _4731, _4732), float3(_4728, _4731, _4732)));
                  float _4740 = _viewPos.x + _389;
                  float _4741 = _viewPos.z + _391;
                  float4 _4746 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4725, 0.0f, _4726), float3(_4740, _3163, _4741)), dot(float3((_4734 * _4728), (_4731 * _4734), (_4734 * _4732)), float3(_4740, _3163, _4741))), 0.0f);
                  float _4750 = _4746.x + -0.5f;
                  float _4751 = _4746.y + -0.5f;
                  float _4752 = _4746.z + -0.5f;
                  float _4754 = rsqrt(dot(float3(_4750, _4751, _4752), float3(_4750, _4751, _4752)));
                  float _4758 = (_4750 * _4754) + _3463;
                  float _4759 = (_4751 * _4754) + _3464;
                  float _4760 = (_4752 * _4754) + _3465;
                  float _4762 = rsqrt(dot(float3(_4758, _4759, _4760), float3(_4758, _4759, _4760)));
                  float _4763 = _4758 * _4762;
                  float _4764 = _4759 * _4762;
                  float _4765 = _4760 * _4762;
                  float _4777 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
                  float _4778 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
                  float _4781 = saturate(_4777 * _4777);
                  float _4782 = saturate(_4778 * _4778);
                  float _4796 = dot(float3((-0.0f - _4763), (-0.0f - _4764), (-0.0f - _4765)), float3(_3582, _3583, _3584));
                  float _4798 = saturate(dot(float3(_4763, _4764, _4765), float3(_996, _997, _998)));
                  float _4800 = saturate(1.0f - _3602);
                  float _4801 = _4800 * _4800;
                  float _4803 = (_4801 * _4801) * _4800;
                  float _4819 = 1.0f - ((_3601 * _3601) * 0.9998999834060669f);
                  float _4826 = (max((((3.18309866997879e-05f / (_4819 * _4819)) * (0.5f / ((((_4798 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4796) + (_4798 * ((_4796 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4803, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4796)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4763, _4764, _4765)))) * 1024.0f) * 50.0f);
                  float _4831 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4782 * _4782) * (3.0f - (_4782 * 2.0f)))) * (1.0f - ((_4781 * _4781) * (3.0f - (_4781 * 2.0f)))));
                  _4845 = _4703;
                  _4846 = _4704;
                  _4847 = _4705;
                  _4848 = _4706;
                  _4849 = _4707;
                  _4850 = _4708;
                  _4851 = ((((_4831 * _3585) * _4709) * _4826) + _4700);
                  _4852 = ((((_4831 * _3586) * _4710) * _4826) + _4701);
                  _4853 = ((((_4831 * _3587) * _4711) * _4826) + _4702);
                } else {
                  _4845 = _4703;
                  _4846 = _4704;
                  _4847 = _4705;
                  _4848 = _4706;
                  _4849 = _4707;
                  _4850 = _4708;
                  _4851 = _4700;
                  _4852 = _4701;
                  _4853 = _4702;
                }
              }
            } else {
              _4653 = _3375;
              _4654 = _3376;
              _4655 = _3377;
              _4656 = _4313;
              _4657 = _4314;
              _4658 = _4315;
              _4659 = _4333;
              _4660 = _4334;
              _4661 = _4335;
              _4686 = ((_4316 * _3585) * _4653);
              _4687 = ((_4317 * _3586) * _4654);
              _4688 = ((_4318 * _3587) * _4655);
              _4689 = (_4659 * _3585);
              _4690 = (_4660 * _3586);
              _4691 = (_4661 * _3587);
              _4692 = _4656;
              _4693 = _4657;
              _4694 = _4658;
              _4695 = _4653;
              _4696 = _4654;
              _4697 = _4655;
              if (_3429 == 98) {
                _4700 = _4686;
                _4701 = _4687;
                _4702 = _4688;
                _4703 = _4689;
                _4704 = _4690;
                _4705 = _4691;
                _4706 = _4692;
                _4707 = _4693;
                _4708 = _4694;
                _4709 = _4695;
                _4710 = _4696;
                _4711 = _4697;
                if (((int)(_116 < 1000.0f)) & ((int)(_3076 == 0.0h))) {
                  if (!(abs(_219) > 0.9900000095367432f)) {
                    float _4719 = -0.0f - _220;
                    float _4721 = rsqrt(dot(float3(_4719, 0.0f, _218), float3(_4719, 0.0f, _218)));
                    _4725 = (_4721 * _4719);
                    _4726 = (_4721 * _218);
                  } else {
                    _4725 = 1.0f;
                    _4726 = 0.0f;
                  }
                  float _4728 = -0.0f - (_219 * _4726);
                  float _4731 = (_4726 * _218) - (_4725 * _220);
                  float _4732 = _4725 * _219;
                  float _4734 = rsqrt(dot(float3(_4728, _4731, _4732), float3(_4728, _4731, _4732)));
                  float _4740 = _viewPos.x + _389;
                  float _4741 = _viewPos.z + _391;
                  float4 _4746 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4725, 0.0f, _4726), float3(_4740, _3163, _4741)), dot(float3((_4734 * _4728), (_4731 * _4734), (_4734 * _4732)), float3(_4740, _3163, _4741))), 0.0f);
                  float _4750 = _4746.x + -0.5f;
                  float _4751 = _4746.y + -0.5f;
                  float _4752 = _4746.z + -0.5f;
                  float _4754 = rsqrt(dot(float3(_4750, _4751, _4752), float3(_4750, _4751, _4752)));
                  float _4758 = (_4750 * _4754) + _3463;
                  float _4759 = (_4751 * _4754) + _3464;
                  float _4760 = (_4752 * _4754) + _3465;
                  float _4762 = rsqrt(dot(float3(_4758, _4759, _4760), float3(_4758, _4759, _4760)));
                  float _4763 = _4758 * _4762;
                  float _4764 = _4759 * _4762;
                  float _4765 = _4760 * _4762;
                  float _4777 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
                  float _4778 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
                  float _4781 = saturate(_4777 * _4777);
                  float _4782 = saturate(_4778 * _4778);
                  float _4796 = dot(float3((-0.0f - _4763), (-0.0f - _4764), (-0.0f - _4765)), float3(_3582, _3583, _3584));
                  float _4798 = saturate(dot(float3(_4763, _4764, _4765), float3(_996, _997, _998)));
                  float _4800 = saturate(1.0f - _3602);
                  float _4801 = _4800 * _4800;
                  float _4803 = (_4801 * _4801) * _4800;
                  float _4819 = 1.0f - ((_3601 * _3601) * 0.9998999834060669f);
                  float _4826 = (max((((3.18309866997879e-05f / (_4819 * _4819)) * (0.5f / ((((_4798 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4796) + (_4798 * ((_4796 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4803, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4796)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4763, _4764, _4765)))) * 1024.0f) * 50.0f);
                  float _4831 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4782 * _4782) * (3.0f - (_4782 * 2.0f)))) * (1.0f - ((_4781 * _4781) * (3.0f - (_4781 * 2.0f)))));
                  _4845 = _4703;
                  _4846 = _4704;
                  _4847 = _4705;
                  _4848 = _4706;
                  _4849 = _4707;
                  _4850 = _4708;
                  _4851 = ((((_4831 * _3585) * _4709) * _4826) + _4700);
                  _4852 = ((((_4831 * _3586) * _4710) * _4826) + _4701);
                  _4853 = ((((_4831 * _3587) * _4711) * _4826) + _4702);
                } else {
                  _4845 = _4703;
                  _4846 = _4704;
                  _4847 = _4705;
                  _4848 = _4706;
                  _4849 = _4707;
                  _4850 = _4708;
                  _4851 = _4700;
                  _4852 = _4701;
                  _4853 = _4702;
                }
              } else {
                _4845 = _4689;
                _4846 = _4690;
                _4847 = _4691;
                _4848 = _4692;
                _4849 = _4693;
                _4850 = _4694;
                _4851 = _4686;
                _4852 = _4687;
                _4853 = _4688;
              }
            }
          }
        } else {
          _4672 = _4333;
          _4673 = _4334;
          _4674 = _4335;
          float _4675 = _4672 * _3585;
          float _4676 = _4673 * _3586;
          float _4677 = _4674 * _3587;
          float _4679 = (_4316 * _3585) * _3375;
          float _4681 = (_4317 * _3586) * _3376;
          float _4683 = (_4318 * _3587) * _3377;
          bool __branch_chain_4671;
          if (_3429 == 97) {
            _4700 = _4679;
            _4701 = _4681;
            _4702 = _4683;
            _4703 = _4675;
            _4704 = _4676;
            _4705 = _4677;
            _4706 = _4313;
            _4707 = _4314;
            _4708 = _4315;
            _4709 = _3375;
            _4710 = _3376;
            _4711 = _3377;
            __branch_chain_4671 = true;
          } else {
            _4686 = _4679;
            _4687 = _4681;
            _4688 = _4683;
            _4689 = _4675;
            _4690 = _4676;
            _4691 = _4677;
            _4692 = _4313;
            _4693 = _4314;
            _4694 = _4315;
            _4695 = _3375;
            _4696 = _3376;
            _4697 = _3377;
            if (_3429 == 98) {
              _4700 = _4686;
              _4701 = _4687;
              _4702 = _4688;
              _4703 = _4689;
              _4704 = _4690;
              _4705 = _4691;
              _4706 = _4692;
              _4707 = _4693;
              _4708 = _4694;
              _4709 = _4695;
              _4710 = _4696;
              _4711 = _4697;
              __branch_chain_4671 = true;
            } else {
              _4845 = _4689;
              _4846 = _4690;
              _4847 = _4691;
              _4848 = _4692;
              _4849 = _4693;
              _4850 = _4694;
              _4851 = _4686;
              _4852 = _4687;
              _4853 = _4688;
              __branch_chain_4671 = false;
            }
          }
          if (__branch_chain_4671) {
            if (((int)(_116 < 1000.0f)) & ((int)(_3076 == 0.0h))) {
              if (!(abs(_219) > 0.9900000095367432f)) {
                float _4719 = -0.0f - _220;
                float _4721 = rsqrt(dot(float3(_4719, 0.0f, _218), float3(_4719, 0.0f, _218)));
                _4725 = (_4721 * _4719);
                _4726 = (_4721 * _218);
              } else {
                _4725 = 1.0f;
                _4726 = 0.0f;
              }
              float _4728 = -0.0f - (_219 * _4726);
              float _4731 = (_4726 * _218) - (_4725 * _220);
              float _4732 = _4725 * _219;
              float _4734 = rsqrt(dot(float3(_4728, _4731, _4732), float3(_4728, _4731, _4732)));
              float _4740 = _viewPos.x + _389;
              float _4741 = _viewPos.z + _391;
              float4 _4746 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_4725, 0.0f, _4726), float3(_4740, _3163, _4741)), dot(float3((_4734 * _4728), (_4731 * _4734), (_4734 * _4732)), float3(_4740, _3163, _4741))), 0.0f);
              float _4750 = _4746.x + -0.5f;
              float _4751 = _4746.y + -0.5f;
              float _4752 = _4746.z + -0.5f;
              float _4754 = rsqrt(dot(float3(_4750, _4751, _4752), float3(_4750, _4751, _4752)));
              float _4758 = (_4750 * _4754) + _3463;
              float _4759 = (_4751 * _4754) + _3464;
              float _4760 = (_4752 * _4754) + _3465;
              float _4762 = rsqrt(dot(float3(_4758, _4759, _4760), float3(_4758, _4759, _4760)));
              float _4763 = _4758 * _4762;
              float _4764 = _4759 * _4762;
              float _4765 = _4760 * _4762;
              float _4777 = abs(((_97 * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f);
              float _4778 = abs(1.0f - ((_98 * 2.0f) * _bufferSizeAndInvSize.w));
              float _4781 = saturate(_4777 * _4777);
              float _4782 = saturate(_4778 * _4778);
              float _4796 = dot(float3((-0.0f - _4763), (-0.0f - _4764), (-0.0f - _4765)), float3(_3582, _3583, _3584));
              float _4798 = saturate(dot(float3(_4763, _4764, _4765), float3(_996, _997, _998)));
              float _4800 = saturate(1.0f - _3602);
              float _4801 = _4800 * _4800;
              float _4803 = (_4801 * _4801) * _4800;
              float _4819 = 1.0f - ((_3601 * _3601) * 0.9998999834060669f);
              float _4826 = (max((((3.18309866997879e-05f / (_4819 * _4819)) * (0.5f / ((((_4798 * 0.9998999834060669f) + 9.999999747378752e-05f) * _4796) + (_4798 * ((_4796 * 0.9998999834060669f) + 9.999999747378752e-05f))))) * (lerp(_4803, 1.0f, 0.07999999821186066f))), 0.0f) * saturate(_4796)) + (exp2(log2(saturate(dot(float3(_996, _997, _998), float3(_4763, _4764, _4765)))) * 1024.0f) * 50.0f);
              float _4831 = saturate(1.0f - (_116 * 0.0010000000474974513f)) * ((1.0f - ((_4782 * _4782) * (3.0f - (_4782 * 2.0f)))) * (1.0f - ((_4781 * _4781) * (3.0f - (_4781 * 2.0f)))));
              _4845 = _4703;
              _4846 = _4704;
              _4847 = _4705;
              _4848 = _4706;
              _4849 = _4707;
              _4850 = _4708;
              _4851 = ((((_4831 * _3585) * _4709) * _4826) + _4700);
              _4852 = ((((_4831 * _3586) * _4710) * _4826) + _4701);
              _4853 = ((((_4831 * _3587) * _4711) * _4826) + _4702);
            } else {
              _4845 = _4703;
              _4846 = _4704;
              _4847 = _4705;
              _4848 = _4706;
              _4849 = _4707;
              _4850 = _4708;
              _4851 = _4700;
              _4852 = _4701;
              _4853 = _4702;
            }
          }
        }
      }
    }
    float _4860 = _4845 + _3077 + foliageTransR;
    float _4861 = _4846 + _3078 + foliageTransG;
    float _4862 = _4847 + _3079 + foliageTransB;
    uint _4865 = (int4(_frameNumber).x) * 13;
    [branch]
    if (((((int)(_4865 + _94)) | ((int)(_4865 + _96))) & 31) == 0) {
      __3__38__0__1__g_sceneColorLightingOnlyForAwbUAV[int2(((int)(_94 >> 5)), ((int)(_96 >> 5)))] = half4(half(_4860), half(_4861), half(_4862), 1.0h);
    }
    bool _4880 = ((uint)(_3429 & 24) > (uint)23);
    if (!_3497) {
      _4897 = select((_cavityParams.z > 0.0f), select(_175, 0.0f, _985), 1.0f);
    } else {
      _4897 = saturate(exp2((_3492 * _3492) * (_116 * -0.005770780146121979f)));
    }
    float _4912 = select(_3494, 1.0f, (select((_cavityParams.x == 0.0f), 1.0f, _4897) * select(((_174) & (_4880)), (1.0f - _985), 1.0f)));
    float _4916 = min(60000.0f, (_4912 * (((_2788 * _2544) * _2793) - min(0.0f, (-0.0f - _4851)))));
    float _4917 = min(60000.0f, (_4912 * (((_2789 * _2545) * _2793) - min(0.0f, (-0.0f - _4852)))));
    float _4918 = min(60000.0f, (_4912 * (((_2790 * _2546) * _2793) - min(0.0f, (-0.0f - _4853)))));
    float _4921 = 1.0f - _renderParams.x;
    half _4928 = half((_renderParams.x * _3378) + _4921);
    half _4929 = half((_renderParams.x * _3379) + _4921);
    half _4930 = half((_renderParams.x * _3380) + _4921);
    if ((_3494) & ((int)(_renderParams2.x == 0.0f))) {
      _4946 = (pow(_4928, 0.5h));
      _4947 = (pow(_4929, 0.5h));
      _4948 = (pow(_4930, 0.5h));
    } else {
      _4946 = _4928;
      _4947 = _4929;
      _4948 = _4930;
    }
    bool _4950 = (_3528) | ((int)(_3429 == 55));
    half _4951 = select(_4950, 0.0f, _3076);
    float _4952 = float(_4946);
    float _4953 = float(_4947);
    float _4954 = float(_4948);
    if (_3466) {
      _4961 = saturate(((_4953 + _4952) + _4954) * 1.2000000476837158f);
    } else {
      _4961 = 1.0f;
    }
    float _4962 = float(_4951);
    float _4968 = (0.699999988079071f / min(max(max(max(_4952, _4953), _4954), 0.009999999776482582f), 0.699999988079071f)) * _4961;
    float _4975 = ((_4968 * _4952) + -0.03999999910593033f) * _4962;
    float _4976 = ((_4968 * _4953) + -0.03999999910593033f) * _4962;
    float _4977 = ((_4968 * _4954) + -0.03999999910593033f) * _4962;
    float _4978 = _4975 + 0.03999999910593033f;
    float _4979 = _4976 + 0.03999999910593033f;
    float _4980 = _4977 + 0.03999999910593033f;
    if ((_3523) | (((int)((_3606) | (((int)((_3605) | (_4950)))))))) {
      float2 _4989 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__3__40__0__0__g_samplerClamp, float2(min(0.9900000095367432f, _1004), (1.0f - max(0.019999999552965164f, float(_157)))), 0.0f);
      _4993 = _4989.x;
      _4994 = _4989.y;
    } else {
      _4993 = _2786;
      _4994 = _2787;
    }
    float _4998 = (_4993 * _4978) + _4994;
    float _4999 = (_4993 * _4979) + _4994;
    float _5000 = (_4993 * _4980) + _4994;
    float _5002 = (1.0f - _4993) - _4994;
    float _5009 = ((0.9599999785423279f - _4975) * 0.0476190485060215f) + _4978;
    float _5010 = ((0.9599999785423279f - _4976) * 0.0476190485060215f) + _4979;
    float _5011 = ((0.9599999785423279f - _4977) * 0.0476190485060215f) + _4980;
    float _5028 = saturate(1.0f - _3071);
    float _5029 = (((_4998 * _5009) / (1.0f - (_5002 * _5009))) * _5002) * _5028;
    float _5030 = (((_4999 * _5010) / (1.0f - (_5002 * _5010))) * _5002) * _5028;
    float _5031 = (((_5000 * _5011) / (1.0f - (_5002 * _5011))) * _5002) * _5028;
    float _5042 = float(1.0h - _4951);
    half _5052 = half(((_4952 * _5042) * saturate((1.0f - _4998) - _5029)) + _5029);
    half _5053 = half(((_4953 * _5042) * saturate((1.0f - _4999) - _5030)) + _5030);
    half _5054 = half(((_4954 * _5042) * saturate((1.0f - _5000) - _5031)) + _5031);
    float _5056 = float(_5052);
    float _5057 = float(_5053);
    float _5058 = float(_5054);
    if (_3429 == 65) {
      float _5062 = max(9.999999974752427e-07f, _exposure2.x);
      float _5070 = ((pow(_3599, 16.0f)) * 50.26548385620117f) / (((_5062 * _5062) * 1e+06f) + 1.0f);
      _5087 = (((((_5056 * _4860) * _5070) - _4860) * _953) + _4860);
      _5088 = (((((_5057 * _4861) * _5070) - _4861) * _953) + _4861);
      _5089 = (((((_5058 * _4862) * _5070) - _4862) * _953) + _4862);
    } else {
      _5087 = _4860;
      _5088 = _4861;
      _5089 = _4862;
    }
    float _5092 = __3__36__0__0__g_caustic.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_104, _105), 0.0f);
    float _5094 = _5092.x * 0.31830987334251404f;
    float _5104 = (min(65535.0f, _4848) + _3080) + (((_5094 * _3366) + _5087) * _5056);
    float _5105 = (min(65535.0f, _4849) + _3081) + (((_5094 * _3367) + _5088) * _5057);
    float _5106 = (min(65535.0f, _4850) + _3082) + (((_5094 * _3368) + _5089) * _5058);
    float _5135 = exp2((saturate(_419) * 20.0f) + -8.0f) + -0.00390625f;
    float _5136 = _5135 * select((_416 < 0.040449999272823334f), (_416 * 0.07739938050508499f), exp2(log2((_416 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    float _5137 = _5135 * select((_417 < 0.040449999272823334f), (_417 * 0.07739938050508499f), exp2(log2((_417 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    float _5138 = _5135 * select((_418 < 0.040449999272823334f), (_418 * 0.07739938050508499f), exp2(log2((_418 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    float _5151 = ((_5136 * 0.6131200194358826f) + (_5137 * 0.3395099937915802f)) + (_5138 * 0.047370001673698425f);
    float _5152 = ((_5136 * 0.07020000368356705f) + (_5137 * 0.9163600206375122f)) + (_5138 * 0.013450000435113907f);
    float _5153 = ((_5136 * 0.02061999961733818f) + (_5137 * 0.10958000272512436f)) + (_5138 * 0.8697999715805054f);
    if (_345) {
      _5159 = (_5151 + _5104);
      _5160 = (_5152 + _5105);
      _5161 = (_5153 + _5106);
    } else {
      _5159 = _5104;
      _5160 = _5105;
      _5161 = _5106;
    }
    float _5165 = _5159 + (_4916 * _4962);
    float _5166 = _5160 + (_4917 * _4962);
    float _5167 = _5161 + (_4918 * _4962);
    float _5189 = (((QuadReadLaneAt(_5165,1) + QuadReadLaneAt(_5165,0)) + QuadReadLaneAt(_5165,2)) + QuadReadLaneAt(_5165,3)) * 0.25f;
    float _5190 = (((QuadReadLaneAt(_5166,1) + QuadReadLaneAt(_5166,0)) + QuadReadLaneAt(_5166,2)) + QuadReadLaneAt(_5166,3)) * 0.25f;
    float _5191 = (((QuadReadLaneAt(_5167,1) + QuadReadLaneAt(_5167,0)) + QuadReadLaneAt(_5167,2)) + QuadReadLaneAt(_5167,3)) * 0.25f;
    [branch]
    if (((_96 | _94) & 1) == 0) {
      float _5196 = dot(float3(_5189, _5190, _5191), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      __3__38__0__1__g_diffuseHalfPrevUAV[int2(((int)(_94 >> 1)), ((int)(_96 >> 1)))] = float4(min(60000.0f, _5189), min(60000.0f, _5190), min(60000.0f, _5191), min(60000.0f, select((_1585 != 0), (-0.0f - _5196), _5196)));
    }
    if (_4880) {
      _5218 = (((int)(_4951 == 0.0h)) & (((int)(!((((int)((((int)(!(_5052 == 0.0h)))) & (((int)(!(_5053 == 0.0h))))))) & (((int)(!(_5054 == 0.0h)))))))));
    } else {
      _5218 = false;
    }
    if ((((int)((_4880) | (((int)(((int)(_3429 == 96)) | (((int)((_3606) | ((int)((_3429 & -4) == 64))))))))))) | (((int)(((int)(_116 <= 10.0f)) & (_3523))))) {
      __3__38__0__1__g_sceneSpecularUAV[int2(_94, _96)] = half4((-0.0h - half(min(0.0f, (-0.0f - _4916)))), (-0.0h - half(min(0.0f, (-0.0f - _4917)))), (-0.0h - half(min(0.0f, (-0.0f - _4918)))), (-0.0h - half(min(0.0f, (-0.0f - _2554)))));
      _5251 = _5159;
      _5252 = _5160;
      _5253 = _5161;
    } else {
      _5251 = (_5159 + _4916);
      _5252 = (_5160 + _4917);
      _5253 = (_5161 + _4918);
    }
    if (!(((int)((uint)(_3429 + -53) < (uint)15)) | (((int)(!_345))))) {
      float _5259 = dot(float3(_5151, _5152, _5153), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _5263 = max((max(_5259, 1.0f) / max(_5259, 0.10000000149011612f)), 0.0f);
      _5274 = ((_5251 - _5151) + (_5263 * _5151));
      _5275 = ((_5252 - _5152) + (_5263 * _5152));
      _5276 = ((_5253 - _5153) + (_5263 * _5153));
    } else {
      _5274 = _5251;
      _5275 = _5252;
      _5276 = _5253;
    }
    float _5277 = min(60000.0f, _5274);
    float _5278 = min(60000.0f, _5275);
    float _5279 = min(60000.0f, _5276);
    [branch]
    if (_5218) {
      float4 _5282 = __3__38__0__1__g_sceneColorUAV.Load(int2(_94, _96));
      _5290 = (_5282.x + _5277);
      _5291 = (_5282.y + _5278);
      _5292 = (_5282.z + _5279);
    } else {
      _5290 = _5277;
      _5291 = _5278;
      _5292 = _5279;
    }
    if (!(_renderParams.y == 0.0f)) {
      float _5301 = dot(float3(_5290, _5291, _5292), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _5302 = min((max(0.009999999776482582f, _exposure3.w) * 4096.0f), _5301);
      float _5306 = max(9.999999717180685e-10f, _5301);
      _5311 = ((_5302 * _5290) / _5306);
      _5312 = ((_5302 * _5291) / _5306);
      _5313 = ((_5302 * _5292) / _5306);
    } else {
      _5311 = _5290;
      _5312 = _5291;
      _5313 = _5292;
    }
    __3__38__0__1__g_sceneColorUAV[int2(_94, _96)] = float4(_5311, _5312, _5313, 1.0f);
  }
}
