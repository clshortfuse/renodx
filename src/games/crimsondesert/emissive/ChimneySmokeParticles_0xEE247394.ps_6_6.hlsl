#include "../shared.h"

struct EffectLightMap_DisableDepthStruct {
  uint _materialFlags;
  uint _materialFlags2;
  uint _textureBase;
  uint _textureEmissive;
  float _emissiveIntensityExponent;
  float _alphaTest;
  uint _alphaTestSpline;
  float _fresnelAlpha;
  uint _fresnelAlphaSpline;
  float _depthBiasAlpha;
  float _transmission;
  float _clampToBorder;
  uint _textureMask;
  float2 _textureMaskOffset;
  uint _textureMaskOffsetSpline;
  float2 _textureMaskScale;
  uint _textureLightMap;
  uint _textureLightMap2;
  float _roughnessScale;
  float _metallicScale;
  uint _textureTemperature;
  uint _temperatureColor;
  uint _temperatureColorSpline;
  float _temperatureBrightness;
  uint _textureDistortion;
  float _sceneDistortionIntensity;
  uint _sceneDistortionIntensitySpline;
  float _selfDistortionIntensity;
  uint _textureOpticalFlow;
  float _opticalFlowStrength;
  uint _opticalFlowStrengthSpline;
  float _offsetDirScale;
  uint _offsetDirScaleSpline;
  float _rayMarchDistance;
  float _particleDensity;
  float _depthBiasReverseAlpha;
  float _depthOffset;
  uint _useDepthOffsetTexture;
  uint _depthOffsetTexture;
  float _depthOffsetCurvature;
  float _fadeRatioScale;
  uint _fadeRatioScaleSpline;
};


Texture2D<float4> __0__7__0__0__g_bindlessTextures[] : register(t0, space7);

Texture3D<float4> __3__36__0__0__g_texFroxelLight : register(t79, space36);

Texture3D<float4> __3__36__0__0__g_texFroxel : register(t80, space36);

Texture2D<float> __3__36__0__0__g_halfDepth : register(t36, space36);

Texture2D<float4> __3__36__0__0__g_depth : register(t53, space36);

Texture2D<uint2> __3__36__0__0__g_materialID : register(t64, space36);

RWTexture3D<uint> __3__38__0__1__g_texFroxelMediaGatherR : register(u15, space38);

RWTexture3D<uint> __3__38__0__1__g_texFroxelMediaGatherG : register(u16, space38);

RWTexture3D<uint> __3__38__0__1__g_texFroxelMediaGatherB : register(u17, space38);

RWTexture3D<uint> __3__38__0__1__g_texFroxelMediaGatherA : register(u18, space38);

RWByteAddressBuffer __3__39__0__1__gpuEffectRenderCounterUAV : register(u0, space39);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b16, space35) {
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

cbuffer __3__35__0__0__PresetSplineTextureConstBuffer : register(b22, space35) {
  uint _splinePresetTextureIndex : packoffset(c000.x);
  uint _splinePresetReserved1 : packoffset(c000.y);
  uint _splinePresetReserved2 : packoffset(c000.z);
  uint _splinePresetReserved3 : packoffset(c000.w);
};

cbuffer __3__35__0__0__ExposureConstantBuffer : register(b30, space35) {
  float4 _exposure0 : packoffset(c000.x);
  float4 _exposure1 : packoffset(c001.x);
  float4 _exposure2 : packoffset(c002.x);
  float4 _exposure3 : packoffset(c003.x);
  float4 _exposure4 : packoffset(c004.x);
};

cbuffer __3__34__0__0__GPUParticleCommonConstantBuffer : register(b0, space34) {
  float3 _gpuParticleFroxelSize : packoffset(c000.x);
  int _gpuParticleRenderCommonFlags : packoffset(c000.w);
  float4 _invRenderTargetAndViewportSize : packoffset(c001.x);
  float _offScreenParticleViewportRatio : packoffset(c002.x);
  uint _offscreenParticleType : packoffset(c002.y);
  float _emissiveAdaptationRatio : packoffset(c002.z);
  float _globalParticleLightScale : packoffset(c002.w);
  float2 _screenResolutionScale : packoffset(c003.x);
  float _applyScatteringForce : packoffset(c003.z);
  float _minTransmission : packoffset(c003.w);
  uint _useOverdrawCounter : packoffset(c004.x);
  uint _globalShadingRatio : packoffset(c004.y);
  float _pixelRate : packoffset(c004.z);
  float _inverseFadeoutDistance : packoffset(c004.w);
  float _noiseScale : packoffset(c005.x);
  float _noiseScaleFire : packoffset(c005.y);
  float _noiseScaleSmoke : packoffset(c005.z);
  float _fadeoutDistance : packoffset(c005.w);
  float2 _globalNoiseOffset : packoffset(c006.x);
  float _noiseScaleSmokeEdge : packoffset(c006.z);
  float _emissiveScatteringExponent : packoffset(c006.w);
  float4 _dummy128 : packoffset(c007.x);
  column_major float4x4 _dummy192 : packoffset(c008.x);
  column_major float4x4 _dummy256 : packoffset(c012.x);
};

ConstantBuffer<EffectLightMap_DisableDepthStruct> BindlessParameters_EffectLightMap_DisableDepth[] : register(b0, space100);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticTrilinearWrap : register(s5, space4);

SamplerState __0__4__0__0__g_staticTrilinearClamp : register(s6, space4);

static const int tileOffset[4] = { 0, 1, 3, 2 };

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float2 SV_Target_1 : SV_Target1;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD_1 : TEXCOORD1,
  linear float4 TEXCOORD_2 : TEXCOORD2,
  linear float4 TEXCOORD_3 : TEXCOORD3,
  linear float4 TEXCOORD_4 : TEXCOORD4,
  linear half4 TEXCOORD_5 : TEXCOORD5,
  linear float4 TEXCOORD_6 : TEXCOORD6,
  linear half4 TEXCOORD_9 : TEXCOORD9,
  linear half4 TEXCOORD_10 : TEXCOORD10,
  linear half4 TEXCOORD_11 : TEXCOORD11,
  linear half4 TEXCOORD_12 : TEXCOORD12,
  nointerpolation uint4 TEXCOORD_13 : TEXCOORD13,
  nointerpolation float4 TEXCOORD_14 : TEXCOORD14,
  nointerpolation float4 TEXCOORD_15 : TEXCOORD15,
  nointerpolation uint4 TEXCOORD_23 : TEXCOORD23,
  linear float4 TEXCOORD_25 : TEXCOORD25,
  nointerpolation uint SV_ShadingRate : SV_ShadingRate,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) {
  float4 SV_Target;
  float2 SV_Target_1;
  bool _23 = (SV_IsFrontFace != 0);
  float _71[4];
  float _72[4];
  float _73[4];
  float _74[4];
  float _75[4];
  float _76[4];
  float _77[4];
  float _78[4];
  float _79[4];
  float _80[4];
  float _81[4];
  float _82[4];
  float _133;
  int _169;
  int _170;
  int _322;
  float _348;
  float _373;
  float _374;
  float _409;
  float _410;
  float _422;
  float _423;
  float _424;
  float _425;
  float _599;
  float _622;
  float _627;
  int _671;
  float _698;
  float _699;
  float _731;
  float _732;
  float _760;
  float _761;
  float _769;
  float _770;
  float _773;
  float _776;
  float _827;
  float _828;
  float _829;
  float _830;
  int _929;
  float _955;
  float _980;
  float _981;
  float _1016;
  float _1017;
  float _1029;
  float _1030;
  float _1031;
  float _1032;
  float _1081;
  float _1082;
  float _1083;
  float _1096;
  float _1097;
  float _1098;
  float _1099;
  float _1325;
  float _1326;
  float _1327;
  float _1328;
  float _1357;
  float _1358;
  float _1359;
  float _1360;
  float _1374;
  float _1375;
  float _1376;
  float _1377;
  float _1381;
  int _1428;
  float _1455;
  float _1456;
  float _1488;
  float _1489;
  float _1517;
  float _1518;
  float _1526;
  float _1527;
  float _1530;
  float _1536;
  float _1537;
  float _1538;
  float _1539;
  float _1540;
  float _1543;
  float _1544;
  float _1545;
  float _1546;
  int _1688;
  float _1717;
  float _1718;
  float _1719;
  float _1720;
  float _1826;
  float _1930;
  float _1931;
  float _1957;
  float _1958;
  float _1966;
  float _1967;
  float _1970;
  float _1998;
  float _1999;
  float _2000;
  float _2001;
  float _2030;
  float _2031;
  float _2032;
  float _2033;
  float _2047;
  float _2048;
  float _2049;
  float _2050;
  int _2061;
  float _2090;
  float _2091;
  float _2092;
  float _2093;
  float _2126;
  float _2127;
  float _2128;
  float _2155;
  float _2156;
  float _2157;
  float _2158;
  float _2175;
  float _2176;
  float _2177;
  float _2178;
  float _2200;
  float _2201;
  float _2202;
  float _2203;
  float _2281;
  float _2314;
  float _2319;
  float _2338;
  float _2472;
  float _2481;
  float _2482;
  float _2483;
  float _2484;
  float _2631;
  float _2632;
  float _2633;
  float _2720;
  float _2721;
  float _2722;
  float _2723;
  float _2724;
  float _2725;
  float _2726;
  float _2727;
  float _2728;
  float _2844;
  float _2845;
  float _2846;
  float _2847;
  float _2848;
  float _2849;
  float _2908;
  float _2909;
  float _2910;
  float _2911;
  float _2931;
  float _3024;
  float _3025;
  float _3026;
  int _3027;
  float _3096;
  float _3100;
  float _3126;
  float _3131;
  float _3132;
  float _3133;
  float _3134;
  float _3160;
  float _3161;
  float _3162;
  float _3163;
  float _3164;
  float _3165;
  float _3219;
  float _3220;
  float _3221;
  float _3222;
  float _3223;
  float _3224;
  if ((((TEXCOORD_13.y & 2) == 0)) && ((!_23))) {
    if (true) discard;
  }
  [branch]
  if (!(_useOverdrawCounter == 0)) {
    uint _94; __3__39__0__1__gpuEffectRenderCounterUAV.InterlockedAdd(0u, 1, _94);
  }
  uint _96 = uint(SV_Position.x);
  uint _97 = uint(SV_Position.y);
  float _98 = float((uint)_96);
  float _99 = float((uint)_97);
  uint _109 = uint(_screenResolutionScale.x * (_98 / _offScreenParticleViewportRatio));
  uint _110 = uint(_screenResolutionScale.y * (_99 / _offScreenParticleViewportRatio));
  float _116 = _invRenderTargetAndViewportSize.z * (_98 + 0.5f);
  float _117 = _invRenderTargetAndViewportSize.w * (_99 + 0.5f);
  uint2 _119 = __3__36__0__0__g_materialID.Load(int3((int)(_109), (int)(_110), 0));
  int _121 = _119.x & 127;
  if (((_121 == 10)) || (((((_119.x & 123) == 25)) || ((_121 == 24))))) {
    float4 _130 = __3__36__0__0__g_depth.Load(int3((int)(_109), (int)(_110), 0));
    _133 = _130.x;
  } else {
    _133 = 0.0f;
  }
  if (_offscreenParticleType == 2) {
    uint _146 = uint((_offScreenParticleViewportRatio / _screenResolutionScale.x) * float((uint)_109));
    int _159 = tileOffset[(((int)((uint)(_frameNumber.x) + _146)) & 3)];
    _169 = (int)(uint(float((int)(_159 % 2)) + ((_screenResolutionScale.x * 2.0f) * float((uint)_146))));
    _170 = (int)(uint(float((int)(_159 / 2)) + ((_screenResolutionScale.y * 2.0f) * float((uint)uint((_offScreenParticleViewportRatio / _screenResolutionScale.y) * float((uint)_110))))));
  } else {
    _169 = ((uint)(_109) >> 1);
    _170 = ((uint)(_110) >> 1);
  }
  float _172 = __3__36__0__0__g_halfDepth.Load(int3(_169, _170, 0));
  float _174 = max(_133, _172.x);
  float _178 = _nearFarProj.x / max(1.0000000116860974e-07f, _174);
  int _179 = TEXCOORD_13.y & 458752;
  if (_179 == 0) {
    bool _183 = ((_178 - SV_Position.w) < 0.0f);
    if (_183) discard;
  }
  float _186 = rsqrt(dot(float3(TEXCOORD_4.x, TEXCOORD_4.y, TEXCOORD_4.z), float3(TEXCOORD_4.x, TEXCOORD_4.y, TEXCOORD_4.z)));
  float _188 = -0.0f - (TEXCOORD_4.x * _186);
  float _190 = -0.0f - (TEXCOORD_4.y * _186);
  float _192 = -0.0f - (TEXCOORD_4.z * _186);
  float _193 = float(TEXCOORD_5.x);
  float _194 = float(TEXCOORD_5.y);
  int _199 = (int)(uint)((int)(((!(TEXCOORD_1.x == TEXCOORD_1.z))) || ((!(TEXCOORD_1.y == TEXCOORD_1.w)))));
  half _203 = select(_23, TEXCOORD_9.x, (-0.0h - TEXCOORD_9.x));
  half _204 = select(_23, TEXCOORD_9.y, (-0.0h - TEXCOORD_9.y));
  half _205 = select(_23, TEXCOORD_9.z, (-0.0h - TEXCOORD_9.z));
  half _207 = rsqrt(dot(half3(_203, _204, _205), half3(_203, _204, _205)));
  float _211 = float(_207 * _203);
  float _212 = float(_207 * _204);
  float _213 = float(_207 * _205);
  half _215 = rsqrt(dot(half3(TEXCOORD_10.x, TEXCOORD_10.y, TEXCOORD_10.z), half3(TEXCOORD_10.x, TEXCOORD_10.y, TEXCOORD_10.z)));
  float _219 = float(_215 * TEXCOORD_10.x);
  float _220 = float(_215 * TEXCOORD_10.y);
  float _221 = float(_215 * TEXCOORD_10.z);
  half _223 = rsqrt(dot(half3(TEXCOORD_11.x, TEXCOORD_11.y, TEXCOORD_11.z), half3(TEXCOORD_11.x, TEXCOORD_11.y, TEXCOORD_11.z)));
  float _227 = float(_223 * TEXCOORD_11.x);
  float _228 = float(_223 * TEXCOORD_11.y);
  float _229 = float(_223 * TEXCOORD_11.z);
  float _233 = select((abs(TEXCOORD_3.w + -1.0f) < 9.999999747378752e-05f), 1.0f, TEXCOORD_3.w);
  int _234 = TEXCOORD_13.y & 65536;
  float _236 = select((_234 != 0), 0.0f, TEXCOORD_2.w);
  uint _241 = uint(TEXCOORD_14.w);
  uint _242 = uint(TEXCOORD_15.w);
  if (((TEXCOORD_23.y == 6)) || (((TEXCOORD_23.y & -5) == 0))) {
    int _244 = WaveReadLaneFirst(TEXCOORD_23.x);
    float4 _251 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_244 < (uint)65000), _244, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(TEXCOORD_2.x, TEXCOORD_2.y));
    bool _254 = (_199 != 0);
    int _255 = WaveReadLaneFirst(TEXCOORD_13.x);
    int _263 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_255 < (uint)170000), _255, 0)) + 0u))]._materialFlags);
    bool _274 = ((_263 & 32) != 0);
    int _275 = WaveReadLaneFirst(TEXCOORD_13.x);
    if ((((_263 & 131072) != 0)) && ((!(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_275 < (uint)170000), _275, 0)) + 0u))]._opticalFlowStrength) == 0.0f)))) {
      int _289 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _298 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _306 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_298 < (uint)170000), _298, 0)) + 0u))]._textureOpticalFlow);
      int _307 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _315 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_307 < (uint)170000), _307, 0)) + 0u))]._opticalFlowStrengthSpline);
      int _316 = _315 & 128;
      if (!(_316 == 0)) {
        _322 = _splinePresetTextureIndex;
      } else {
        _322 = (int)(_242);
      }
      int _323 = _315 & 127;
      if (((_323 != 127)) && ((_322 != -1))) {
        int2 _336; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_322 < (uint)65000), _322, 0)) + 0u))].GetDimensions(_336.x, _336.y);
        float4 _345 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_322 < (uint)65000), _322, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((TEXCOORD_15.z * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_323) + (uint)(select((_316 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_336.y)))), 0.0f);
        _348 = _345.x;
      } else {
        _348 = 1.0f;
      }
      float _349 = _348 * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_289 < (uint)170000), _289, 0)) + 0u))]._opticalFlowStrength);
      if (_274) {
        int _351 = WaveReadLaneFirst(_306);
        float4 _358 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_351 < (uint)65000), _351, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(TEXCOORD_1.x, TEXCOORD_1.y));
        _373 = _358.x;
        _374 = _358.y;
      } else {
        int _362 = WaveReadLaneFirst(_306);
        float4 _369 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_362 < (uint)65000), _362, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(TEXCOORD_1.x, TEXCOORD_1.y));
        _373 = _369.x;
        _374 = _369.y;
      }
      float _379 = _349 * TEXCOORD_2.z;
      float _382 = TEXCOORD_1.x - (((_373 * 2.0f) + -0.9960784316062927f) * _379);
      float _383 = TEXCOORD_1.y - (((_374 * 2.0f) + -0.9960784316062927f) * _379);
      if (!(TEXCOORD_2.z == 0.0f)) {
        if (_274) {
          int _387 = WaveReadLaneFirst(_306);
          float4 _394 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_387 < (uint)65000), _387, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(TEXCOORD_1.z, TEXCOORD_1.w));
          _409 = _394.x;
          _410 = _394.y;
        } else {
          int _398 = WaveReadLaneFirst(_306);
          float4 _405 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_398 < (uint)65000), _398, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(TEXCOORD_1.z, TEXCOORD_1.w));
          _409 = _405.x;
          _410 = _405.y;
        }
        float _416 = _349 * (1.0f - TEXCOORD_2.z);
        _422 = _382;
        _423 = _383;
        _424 = ((((_409 * 2.0f) + -0.9960784316062927f) * _416) + TEXCOORD_1.z);
        _425 = ((((_410 * 2.0f) + -0.9960784316062927f) * _416) + TEXCOORD_1.w);
      } else {
        _422 = _382;
        _423 = _383;
        _424 = TEXCOORD_1.z;
        _425 = TEXCOORD_1.w;
      }
    } else {
      _422 = TEXCOORD_1.x;
      _423 = TEXCOORD_1.y;
      _424 = TEXCOORD_1.z;
      _425 = TEXCOORD_1.w;
    }
    if (!((_263 & 4) == 0)) {
      bool _445 = (_254) && (((_263 & 268435456) != 0));
      if ((_254) && (((_263 & 1) != 0))) {
        if (!((_263 & 256) == 0)) {
          if (_445) {
            int _465 = WaveReadLaneFirst(TEXCOORD_13.x);
            float _474 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_465 < (uint)170000), _465, 0)) + 0u))]._textureMaskScale.x);
            float _475 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_465 < (uint)170000), _465, 0)) + 0u))]._textureMaskScale.y);
            int _484 = WaveReadLaneFirst(TEXCOORD_13.x);
            int _497 = WaveReadLaneFirst(TEXCOORD_13.x);
            int _506 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_497 < (uint)170000), _497, 0)) + 0u))]._textureMask));
            float4 _513 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_506 < (uint)65000), _506, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(((((TEXCOORD_2.x / _474) + 0.5f) - (0.5f / _474)) + WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_484 < (uint)170000), _484, 0)) + 0u))]._textureMaskOffset.x)), ((((TEXCOORD_2.y / _475) + 0.5f) - (0.5f / _475)) + WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_484 < (uint)170000), _484, 0)) + 0u))]._textureMaskOffset.y))));
            _776 = min(_513.x, _513.w);
          } else {
            int _518 = WaveReadLaneFirst(TEXCOORD_13.x);
            int _526 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_518 < (uint)170000), _518, 0)) + 0u))]._textureMask);
            int _529 = WaveReadLaneFirst(_526);
            float4 _536 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_529 < (uint)65000), _529, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2((_422 * 2.0f), (_423 * 2.0f)), -1.0f, int2(0, 0));
            _81[0] = _536.x;
            _81[1] = _536.y;
            _81[2] = _536.z;
            _81[3] = _536.w;
            float _546 = _81[(select((_423 >= 0.5f), 2, 0) | ((int)(uint)((int)(_422 >= 0.5f))))];
            int _547 = WaveReadLaneFirst(_526);
            float4 _554 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_547 < (uint)65000), _547, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2((_424 * 2.0f), (_425 * 2.0f)), -1.0f, int2(0, 0));
            _82[0] = _554.x;
            _82[1] = _554.y;
            _82[2] = _554.z;
            _82[3] = _554.w;
            _776 = ((((_82[(select((_425 >= 0.5f), 2, 0) | ((int)(uint)((int)(_424 >= 0.5f))))]) - _546) * TEXCOORD_2.z) + _546);
          }
        } else {
          _776 = 1.0f;
        }
      } else {
        int _569 = WaveReadLaneFirst(TEXCOORD_13.x);
        int _577 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_569 < (uint)170000), _569, 0)) + 0u))]._textureBase);
        if (_274) {
          int _579 = WaveReadLaneFirst(_577);
          float4 _586 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_579 < (uint)65000), _579, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_422, _423));
          _599 = _586.w;
        } else {
          int _589 = WaveReadLaneFirst(_577);
          float4 _596 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_589 < (uint)65000), _589, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_422, _423));
          _599 = _596.w;
        }
        if (_254) {
          if (_274) {
            int _602 = WaveReadLaneFirst(_577);
            float4 _609 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_602 < (uint)65000), _602, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_424, _425));
            _622 = _609.w;
          } else {
            int _612 = WaveReadLaneFirst(_577);
            float4 _619 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_612 < (uint)65000), _612, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_424, _425));
            _622 = _619.w;
          }
          _627 = (lerp(_599, _622, TEXCOORD_2.z));
        } else {
          _627 = _599;
        }
        if (!((_263 & 256) == 0)) {
          int _631 = WaveReadLaneFirst(TEXCOORD_13.x);
          bool _643 = ((_263 & 1048576) != 0);
          int _644 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _652 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_644 < (uint)170000), _644, 0)) + 0u))]._textureMask);
          int _653 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _661 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_653 < (uint)170000), _653, 0)) + 0u))]._textureMaskOffsetSpline);
          if (!_445) {
            int _665 = _661 & 128;
            if (!(_665 == 0)) {
              _671 = _splinePresetTextureIndex;
            } else {
              _671 = (int)(_242);
            }
            int _672 = _661 & 127;
            if (((_672 != 127)) && ((_671 != -1))) {
              int2 _685; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_671 < (uint)65000), _671, 0)) + 0u))].GetDimensions(_685.x, _685.y);
              float4 _694 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_671 < (uint)65000), _671, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((TEXCOORD_15.z * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_672) + (uint)(select((_665 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_685.y)))), 0.0f);
              _698 = _694.x;
              _699 = _694.y;
            } else {
              _698 = 1.0f;
              _699 = 1.0f;
            }
          } else {
            _698 = 1.0f;
            _699 = 1.0f;
          }
          float _700 = _698 * select(_445, 0.0f, WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_631 < (uint)170000), _631, 0)) + 0u))]._textureMaskOffset.x));
          float _701 = _699 * select(_445, 0.0f, WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_631 < (uint)170000), _631, 0)) + 0u))]._textureMaskOffset.y));
          float _704 = _700 + select(_643, _422, TEXCOORD_2.x);
          float _705 = _701 + select(_643, _423, TEXCOORD_2.y);
          if ((_263 & 1048608) == 1048608) {
            int _709 = WaveReadLaneFirst(_652);
            float4 _716 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_709 < (uint)65000), _709, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_704, _705));
            _731 = _716.x;
            _732 = _716.w;
          } else {
            int _720 = WaveReadLaneFirst(_652);
            float4 _727 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_720 < (uint)65000), _720, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_704, _705));
            _731 = _727.x;
            _732 = _727.w;
          }
          if ((_254) && (_643)) {
            float _735 = _700 + _424;
            float _736 = _701 + _425;
            if (_274) {
              int _738 = WaveReadLaneFirst(_652);
              float4 _745 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_738 < (uint)65000), _738, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_735, _736));
              _760 = _745.x;
              _761 = _745.w;
            } else {
              int _749 = WaveReadLaneFirst(_652);
              float4 _756 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_749 < (uint)65000), _749, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_735, _736));
              _760 = _756.x;
              _761 = _756.w;
            }
            _769 = (lerp(_731, _760, TEXCOORD_2.z));
            _770 = (lerp(_732, _761, TEXCOORD_2.z));
          } else {
            _769 = _731;
            _770 = _732;
          }
          _773 = min(_769, _770);
        } else {
          _773 = 1.0f;
        }
        _776 = (_773 * _627);
      }
    } else {
      _776 = 1.0f;
    }
    float _787 = (TEXCOORD_2.x * 2.0f) + -1.0f;
    float _788 = (TEXCOORD_2.y * 2.0f) + -1.0f;
    float _797 = (_251.x * 2.0f) + -0.9960784316062927f;
    float _798 = (_251.y * 2.0f) + -0.9960784316062927f;
    float _813 = (((_noiseScaleSmokeEdge + _noiseScaleSmoke) - ((_776 * _776) * _noiseScaleSmokeEdge)) * 0.1599999964237213f) * exp2(log2(saturate(1.0f - sqrt((_788 * _788) + (_787 * _787)))) * 0.5f);
    float _820 = (_813 * ((((_globalNoiseOffset.x * _797) + _globalNoiseOffset.x) * 0.5f) + _797)) / float((uint)max((uint)(1), (uint)(TEXCOORD_13.z)));
    float _821 = (_813 * ((((_globalNoiseOffset.y * _798) + _globalNoiseOffset.y) * 0.5f) + _798)) / float((uint)max((uint)(1), (uint)(TEXCOORD_13.w)));
    _827 = (_422 - _820);
    _828 = (_423 - _821);
    _829 = (_424 - _820);
    _830 = (_425 - _821);
  } else {
    _827 = TEXCOORD_1.x;
    _828 = TEXCOORD_1.y;
    _829 = TEXCOORD_1.z;
    _830 = TEXCOORD_1.w;
  }
  bool _831 = (_199 != 0);
  int _832 = (int)(uint)((int)(_831));
  int _833 = WaveReadLaneFirst(TEXCOORD_13.x);
  int _841 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_833 < (uint)170000), _833, 0)) + 0u))]._materialFlags);
  int _842 = WaveReadLaneFirst(TEXCOORD_13.x);
  int _854 = WaveReadLaneFirst(TEXCOORD_13.x);
  float _863 = max(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_854 < (uint)170000), _854, 0)) + 0u))]._clampToBorder), select(((_841 & 3) != 0), 0.004999999888241291f, 0.0f));
  if (_863 > 0.0f) {
    bool __defer_865_874 = false;
    if ((((TEXCOORD_2.x < _863)) || ((TEXCOORD_2.y < _863))) || ((!(((TEXCOORD_2.x < _863)) || ((TEXCOORD_2.y < _863)))) && ((((1.0f - _863) < TEXCOORD_2.x)) || (((1.0f - _863) < TEXCOORD_2.y))))) {
      __defer_865_874 = true;
    } else {
      bool _877 = ((_841 & 32) != 0);
      bool _881 = ((_841 & 128) != 0);
      int _882 = WaveReadLaneFirst(TEXCOORD_13.x);
      if ((((_841 & 131072) != 0)) && ((!(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_882 < (uint)170000), _882, 0)) + 0u))]._opticalFlowStrength) == 0.0f)))) {
        int _896 = WaveReadLaneFirst(TEXCOORD_13.x);
        int _905 = WaveReadLaneFirst(TEXCOORD_13.x);
        int _913 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_905 < (uint)170000), _905, 0)) + 0u))]._textureOpticalFlow);
        int _914 = WaveReadLaneFirst(TEXCOORD_13.x);
        int _922 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_914 < (uint)170000), _914, 0)) + 0u))]._opticalFlowStrengthSpline);
        int _923 = _922 & 128;
        if (!(_923 == 0)) {
          _929 = _splinePresetTextureIndex;
        } else {
          _929 = (int)(_242);
        }
        int _930 = _922 & 127;
        if (((_930 != 127)) && ((_929 != -1))) {
          int2 _943; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_929 < (uint)65000), _929, 0)) + 0u))].GetDimensions(_943.x, _943.y);
          float4 _952 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_929 < (uint)65000), _929, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((TEXCOORD_15.z * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_930) + (uint)(select((_923 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_943.y)))), 0.0f);
          _955 = _952.x;
        } else {
          _955 = 1.0f;
        }
        float _956 = _955 * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_896 < (uint)170000), _896, 0)) + 0u))]._opticalFlowStrength);
        if (_877) {
          int _958 = WaveReadLaneFirst(_913);
          float4 _965 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_958 < (uint)65000), _958, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_827, _828));
          _980 = _965.x;
          _981 = _965.y;
        } else {
          int _969 = WaveReadLaneFirst(_913);
          float4 _976 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_969 < (uint)65000), _969, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_827, _828));
          _980 = _976.x;
          _981 = _976.y;
        }
        float _986 = _956 * TEXCOORD_2.z;
        float _989 = _827 - (((_980 * 2.0f) + -0.9960784316062927f) * _986);
        float _990 = _828 - (((_981 * 2.0f) + -0.9960784316062927f) * _986);
        if (!(TEXCOORD_2.z == 0.0f)) {
          if (_877) {
            int _994 = WaveReadLaneFirst(_913);
            float4 _1001 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_994 < (uint)65000), _994, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_829, _830));
            _1016 = _1001.x;
            _1017 = _1001.y;
          } else {
            int _1005 = WaveReadLaneFirst(_913);
            float4 _1012 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1005 < (uint)65000), _1005, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_829, _830));
            _1016 = _1012.x;
            _1017 = _1012.y;
          }
          float _1023 = _956 * (1.0f - TEXCOORD_2.z);
          _1029 = _989;
          _1030 = _990;
          _1031 = ((((_1016 * 2.0f) + -0.9960784316062927f) * _1023) + _829);
          _1032 = ((((_1017 * 2.0f) + -0.9960784316062927f) * _1023) + _830);
        } else {
          _1029 = _989;
          _1030 = _990;
          _1031 = _829;
          _1032 = _830;
        }
      } else {
        _1029 = _827;
        _1030 = _828;
        _1031 = _829;
        _1032 = _830;
      }
      int _1033 = WaveReadLaneFirst(TEXCOORD_13.x);
      if ((((_841 & 8192) != 0)) && ((WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1033 < (uint)170000), _1033, 0)) + 0u))]._selfDistortionIntensity) > 0.0f))) {
        int _1047 = WaveReadLaneFirst(TEXCOORD_13.x);
        int _1055 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1047 < (uint)170000), _1047, 0)) + 0u))]._textureDistortion);
        if ((_841 & 16384) == 0) {
          int _1069 = WaveReadLaneFirst(_1055);
          float4 _1076 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1069 < (uint)65000), _1069, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_193, _194));
          _1081 = _1076.x;
          _1082 = _1076.y;
          _1083 = _1076.w;
        } else {
          int _1057 = WaveReadLaneFirst(_1055);
          float4 _1064 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1057 < (uint)65000), _1057, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_193, _194));
          _1081 = _1064.x;
          _1082 = _1064.y;
          _1083 = _1064.w;
        }
        float _1088 = _1083 * float(TEXCOORD_5.w);
        float _1089 = _1088 * ((_1081 * 2.0f) + -0.9960784316062927f);
        float _1090 = _1088 * ((_1082 * 2.0f) + -0.9960784316062927f);
        _1096 = (_1029 - _1089);
        _1097 = (_1030 - _1090);
        _1098 = (_1031 - _1089);
        _1099 = (_1032 - _1090);
      } else {
        _1096 = _1029;
        _1097 = _1030;
        _1098 = _1031;
        _1099 = _1032;
      }
      float _1100 = _1096 * 2.0f;
      float _1101 = _1097 * 2.0f;
      float _1102 = _1098 * 2.0f;
      float _1103 = _1099 * 2.0f;
      if (!((_841 & 4) == 0)) {
        bool _1119 = (_832 != 0);
        bool _1120 = (_1119) && (((_841 & 268435456) != 0));
        if ((_1119) && (((_841 & 1) != 0))) {
          int _1125 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1133 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1125 < (uint)170000), _1125, 0)) + 0u))]._textureBase);
          int _1136 = WaveReadLaneFirst(_1133);
          float4 _1143 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1136 < (uint)65000), _1136, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1100, _1101), -1.0f, int2(0, 0));
          _79[0] = _1143.x;
          _79[1] = _1143.y;
          _79[2] = _1143.z;
          _79[3] = _1143.w;
          float _1153 = _79[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
          int _1154 = WaveReadLaneFirst(_1133);
          float4 _1161 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1154 < (uint)65000), _1154, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1102, _1103), -1.0f, int2(0, 0));
          _80[0] = _1161.x;
          _80[1] = _1161.y;
          _80[2] = _1161.z;
          _80[3] = _1161.w;
          float _1174 = (((_80[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _1153) * TEXCOORD_2.z) + _1153;
          float _1175 = _1174 * TEXCOORD_3.x;
          float _1176 = _1174 * TEXCOORD_3.y;
          float _1177 = _1174 * TEXCOORD_3.z;
          if (!((_841 & 256) == 0)) {
            if (_1120) {
              int _1182 = WaveReadLaneFirst(TEXCOORD_13.x);
              float _1191 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1182 < (uint)170000), _1182, 0)) + 0u))]._textureMaskScale.x);
              float _1192 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1182 < (uint)170000), _1182, 0)) + 0u))]._textureMaskScale.y);
              int _1201 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _1214 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _1223 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1214 < (uint)170000), _1214, 0)) + 0u))]._textureMask));
              float4 _1230 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1223 < (uint)65000), _1223, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(((((TEXCOORD_2.x / _1191) + 0.5f) - (0.5f / _1191)) + WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1201 < (uint)170000), _1201, 0)) + 0u))]._textureMaskOffset.x)), ((((TEXCOORD_2.y / _1192) + 0.5f) - (0.5f / _1192)) + WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1201 < (uint)170000), _1201, 0)) + 0u))]._textureMaskOffset.y))));
              _1536 = min(_1230.x, _1230.w);
              _1537 = _1175;
              _1538 = _1176;
              _1539 = _1177;
              _1540 = _233;
            } else {
              int _1235 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _1243 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1235 < (uint)170000), _1235, 0)) + 0u))]._textureMask);
              int _1246 = WaveReadLaneFirst(_1243);
              float4 _1253 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1246 < (uint)65000), _1246, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1100, _1101), -1.0f, int2(0, 0));
              _77[0] = _1253.x;
              _77[1] = _1253.y;
              _77[2] = _1253.z;
              _77[3] = _1253.w;
              float _1263 = _77[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
              int _1264 = WaveReadLaneFirst(_1243);
              float4 _1271 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1264 < (uint)65000), _1264, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1102, _1103), -1.0f, int2(0, 0));
              _78[0] = _1271.x;
              _78[1] = _1271.y;
              _78[2] = _1271.z;
              _78[3] = _1271.w;
              _1536 = ((((_78[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _1263) * TEXCOORD_2.z) + _1263);
              _1537 = _1175;
              _1538 = _1176;
              _1539 = _1177;
              _1540 = _233;
            }
          } else {
            _1536 = 1.0f;
            _1537 = _1175;
            _1538 = _1176;
            _1539 = _1177;
            _1540 = _233;
          }
        } else {
          int _1289 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1297 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1289 < (uint)170000), _1289, 0)) + 0u))]._textureBase);
          if (_877) {
            int _1299 = WaveReadLaneFirst(_1297);
            float4 _1306 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1299 < (uint)65000), _1299, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1096, _1097));
            _1325 = _1306.x;
            _1326 = _1306.y;
            _1327 = _1306.z;
            _1328 = _1306.w;
          } else {
            int _1312 = WaveReadLaneFirst(_1297);
            float4 _1319 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1312 < (uint)65000), _1312, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
            _1325 = _1319.x;
            _1326 = _1319.y;
            _1327 = _1319.z;
            _1328 = _1319.w;
          }
          if (!(_832 == 0)) {
            if (_877) {
              int _1331 = WaveReadLaneFirst(_1297);
              float4 _1338 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1331 < (uint)65000), _1331, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1098, _1099));
              _1357 = _1338.x;
              _1358 = _1338.y;
              _1359 = _1338.z;
              _1360 = _1338.w;
            } else {
              int _1344 = WaveReadLaneFirst(_1297);
              float4 _1351 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1344 < (uint)65000), _1344, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
              _1357 = _1351.x;
              _1358 = _1351.y;
              _1359 = _1351.z;
              _1360 = _1351.w;
            }
            _1374 = (lerp(_1325, _1357, TEXCOORD_2.z));
            _1375 = (lerp(_1326, _1358, TEXCOORD_2.z));
            _1376 = (lerp(_1327, _1359, TEXCOORD_2.z));
            _1377 = (lerp(_1328, _1360, TEXCOORD_2.z));
          } else {
            _1374 = _1325;
            _1375 = _1326;
            _1376 = _1327;
            _1377 = _1328;
          }
          if (!((_841 & 524288) == 0)) {
            _1381 = max(9.999999747378752e-05f, _1377);
          } else {
            _1381 = 1.0f;
          }
          if (!((_841 & 256) == 0)) {
            int _1388 = WaveReadLaneFirst(TEXCOORD_13.x);
            bool _1400 = ((_841 & 1048576) != 0);
            int _1401 = WaveReadLaneFirst(TEXCOORD_13.x);
            int _1409 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1401 < (uint)170000), _1401, 0)) + 0u))]._textureMask);
            int _1410 = WaveReadLaneFirst(TEXCOORD_13.x);
            int _1418 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1410 < (uint)170000), _1410, 0)) + 0u))]._textureMaskOffsetSpline);
            if (!_1120) {
              int _1422 = _1418 & 128;
              if (!(_1422 == 0)) {
                _1428 = _splinePresetTextureIndex;
              } else {
                _1428 = (int)(_242);
              }
              int _1429 = _1418 & 127;
              if (((_1429 != 127)) && ((_1428 != -1))) {
                int2 _1442; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1428 < (uint)65000), _1428, 0)) + 0u))].GetDimensions(_1442.x, _1442.y);
                float4 _1451 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1428 < (uint)65000), _1428, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((TEXCOORD_15.z * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_1429) + (uint)(select((_1422 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_1442.y)))), 0.0f);
                _1455 = _1451.x;
                _1456 = _1451.y;
              } else {
                _1455 = 1.0f;
                _1456 = 1.0f;
              }
            } else {
              _1455 = 1.0f;
              _1456 = 1.0f;
            }
            float _1457 = _1455 * select(_1120, 0.0f, WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1388 < (uint)170000), _1388, 0)) + 0u))]._textureMaskOffset.x));
            float _1458 = _1456 * select(_1120, 0.0f, WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1388 < (uint)170000), _1388, 0)) + 0u))]._textureMaskOffset.y));
            float _1461 = _1457 + select(_1400, _1096, TEXCOORD_2.x);
            float _1462 = _1458 + select(_1400, _1097, TEXCOORD_2.y);
            if ((_841 & 1048608) == 1048608) {
              int _1466 = WaveReadLaneFirst(_1409);
              float4 _1473 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1466 < (uint)65000), _1466, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1461, _1462));
              _1488 = _1473.x;
              _1489 = _1473.w;
            } else {
              int _1477 = WaveReadLaneFirst(_1409);
              float4 _1484 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1477 < (uint)65000), _1477, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1461, _1462));
              _1488 = _1484.x;
              _1489 = _1484.w;
            }
            if ((_1119) && (_1400)) {
              float _1492 = _1457 + _1098;
              float _1493 = _1458 + _1099;
              if (_877) {
                int _1495 = WaveReadLaneFirst(_1409);
                float4 _1502 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1495 < (uint)65000), _1495, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1492, _1493));
                _1517 = _1502.x;
                _1518 = _1502.w;
              } else {
                int _1506 = WaveReadLaneFirst(_1409);
                float4 _1513 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1506 < (uint)65000), _1506, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1492, _1493));
                _1517 = _1513.x;
                _1518 = _1513.w;
              }
              _1526 = (lerp(_1488, _1517, TEXCOORD_2.z));
              _1527 = (lerp(_1489, _1518, TEXCOORD_2.z));
            } else {
              _1526 = _1488;
              _1527 = _1489;
            }
            _1530 = min(_1526, _1527);
          } else {
            _1530 = 1.0f;
          }
          _1536 = _1530;
          _1537 = ((_1374 / _1381) * TEXCOORD_3.x);
          _1538 = ((_1375 / _1381) * TEXCOORD_3.y);
          _1539 = ((_1376 / _1381) * TEXCOORD_3.z);
          _1540 = (_1377 * _233);
        }
        _1543 = _1537;
        _1544 = _1538;
        _1545 = _1539;
        _1546 = (_1540 * _1536);
      } else {
        _1543 = TEXCOORD_3.x;
        _1544 = TEXCOORD_3.y;
        _1545 = TEXCOORD_3.z;
        _1546 = _233;
      }
      int _1547 = WaveReadLaneFirst(TEXCOORD_13.x);
      if (!((_841 & 64) == 0)) {
        bool _1562 = ((_841 & 1048576) != 0);
        bool _1563 = (_832 != 0);
        if ((_841 & 2) == 0) {
          int _1831 = WaveReadLaneFirst(TEXCOORD_13.x);
          float _1839 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1831 < (uint)170000), _1831, 0)) + 0u))]._emissiveIntensityExponent);
          int _1840 = WaveReadLaneFirst(TEXCOORD_13.x);
          float _1848 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1840 < (uint)170000), _1840, 0)) + 0u))]._temperatureBrightness);
          int _1849 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1857 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1849 < (uint)170000), _1849, 0)) + 0u))]._temperatureColor);
          bool _1861 = ((_841 & 262144) != 0);
          bool _1863 = ((_841 & 512) != 0);
          int _1864 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1872 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1864 < (uint)170000), _1864, 0)) + 0u))]._textureMask);
          int _1882 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1890 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1882 < (uint)170000), _1882, 0)) + 0u))]._textureEmissive);
          int _1891 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1899 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1891 < (uint)170000), _1891, 0)) + 0u))]._temperatureColorSpline);
          if ((_841 & 536871168) == 536871168) {
            float _1905 = select(_1562, _1096, TEXCOORD_2.x);
            float _1906 = select(_1562, _1097, TEXCOORD_2.y);
            if ((_841 & 1048704) == 1048704) {
              int _1908 = WaveReadLaneFirst(_1872);
              float4 _1915 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1908 < (uint)65000), _1908, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1905, _1906));
              _1930 = _1915.x;
              _1931 = _1915.w;
            } else {
              int _1919 = WaveReadLaneFirst(_1872);
              float4 _1926 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1919 < (uint)65000), _1919, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1905, _1906));
              _1930 = _1926.x;
              _1931 = _1926.w;
            }
            if ((_1563) && (_1562)) {
              if (_881) {
                int _1935 = WaveReadLaneFirst(_1872);
                float4 _1942 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1935 < (uint)65000), _1935, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1098, _1099));
                _1957 = _1942.x;
                _1958 = _1942.w;
              } else {
                int _1946 = WaveReadLaneFirst(_1872);
                float4 _1953 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1946 < (uint)65000), _1946, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
                _1957 = _1953.x;
                _1958 = _1953.w;
              }
              _1966 = (lerp(_1930, _1957, TEXCOORD_2.z));
              _1967 = (lerp(_1931, _1958, TEXCOORD_2.z));
            } else {
              _1966 = _1930;
              _1967 = _1931;
            }
            _1970 = min(_1966, _1967);
          } else {
            _1970 = 1.0f;
          }
          if (_881) {
            int _1972 = WaveReadLaneFirst(_1890);
            float4 _1979 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1972 < (uint)65000), _1972, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1096, _1097));
            _1998 = _1979.x;
            _1999 = _1979.y;
            _2000 = _1979.z;
            _2001 = _1979.w;
          } else {
            int _1985 = WaveReadLaneFirst(_1890);
            float4 _1992 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1985 < (uint)65000), _1985, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
            _1998 = _1992.x;
            _1999 = _1992.y;
            _2000 = _1992.z;
            _2001 = _1992.w;
          }
          if (_1563) {
            if (_881) {
              int _2004 = WaveReadLaneFirst(_1890);
              float4 _2011 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2004 < (uint)65000), _2004, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1098, _1099));
              _2030 = _2011.x;
              _2031 = _2011.y;
              _2032 = _2011.z;
              _2033 = _2011.w;
            } else {
              int _2017 = WaveReadLaneFirst(_1890);
              float4 _2024 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2017 < (uint)65000), _2017, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
              _2030 = _2024.x;
              _2031 = _2024.y;
              _2032 = _2024.z;
              _2033 = _2024.w;
            }
            _2047 = (lerp(_1998, _2030, TEXCOORD_2.z));
            _2048 = (lerp(_1999, _2031, TEXCOORD_2.z));
            _2049 = (lerp(_2000, _2032, TEXCOORD_2.z));
            _2050 = (lerp(_2001, _2033, TEXCOORD_2.z));
          } else {
            _2047 = _1998;
            _2048 = _1999;
            _2049 = _2000;
            _2050 = _2001;
          }
          if (!((_841 & 33554432) == 0)) {
            int _2055 = _1899 & 128;
            if (!(_2055 == 0)) {
              _2061 = _splinePresetTextureIndex;
            } else {
              _2061 = (int)(_242);
            }
            int _2062 = _1899 & 127;
            if (((_2062 != 127)) && ((_2061 != -1))) {
              int2 _2075; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2061 < (uint)65000), _2061, 0)) + 0u))].GetDimensions(_2075.x, _2075.y);
              float4 _2084 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2061 < (uint)65000), _2061, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_2047 * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_2062) + (uint)(select((_2055 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_2075.y)))), 0.0f);
              _2090 = _2084.x;
              _2091 = _2084.y;
              _2092 = _2084.z;
              _2093 = _2084.w;
            } else {
              _2090 = 1.0f;
              _2091 = 1.0f;
              _2092 = 1.0f;
              _2093 = 1.0f;
            }
            float _2115 = (_1848 * _1848) * _2093;
            _2126 = (((_2090 * TEXCOORD_6.x) * _2115) * exp2(log2(float((uint)((uint)(((uint)((uint)(_1857)) >> 16) & 255))) * 0.003921568859368563f) * 2.200000047683716f));
            _2127 = (((_2091 * TEXCOORD_6.y) * _2115) * exp2(log2(float((uint)((uint)(((uint)((uint)(_1857)) >> 8) & 255))) * 0.003921568859368563f) * 2.200000047683716f));
            _2128 = (((_2092 * TEXCOORD_6.z) * _2115) * exp2(log2(float((uint)((uint)(_1857 & 255))) * 0.003921568859368563f) * 2.200000047683716f));
          } else {
            _2126 = TEXCOORD_6.x;
            _2127 = TEXCOORD_6.y;
            _2128 = TEXCOORD_6.z;
          }
          float _2129 = select(_1861, _1839, 1.0f);
          float _2147 = saturate(exp2(log2(select(_1863, 1.0f, _2050)) * select(_1861, 1.0f, _1839))) * _1970;
          _2155 = ((saturate(pow(_2047, _2129)) * _2126) * _2147);
          _2156 = ((saturate(exp2(log2(select(_1863, _2047, _2048)) * _2129)) * _2127) * _2147);
          _2157 = ((saturate(exp2(log2(select(_1863, _2047, _2049)) * _2129)) * _2128) * _2147);
          _2158 = _1839;
        } else {
          int _1565 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1576 = WaveReadLaneFirst(TEXCOORD_13.x);
          float _1585 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1576 < (uint)170000), _1576, 0)) + 0u))]._textureMaskScale.x);
          float _1586 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1576 < (uint)170000), _1576, 0)) + 0u))]._textureMaskScale.y);
          int _1587 = WaveReadLaneFirst(TEXCOORD_13.x);
          float _1595 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1587 < (uint)170000), _1587, 0)) + 0u))]._temperatureBrightness);
          int _1596 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1604 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1596 < (uint)170000), _1596, 0)) + 0u))]._temperatureColor);
          int _1605 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1614 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1622 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1614 < (uint)170000), _1614, 0)) + 0u))]._textureMask);
          int _1623 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1631 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1623 < (uint)170000), _1623, 0)) + 0u))]._textureEmissive);
          int _1632 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1640 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1632 < (uint)170000), _1632, 0)) + 0u))]._temperatureColorSpline);
          int _1643 = WaveReadLaneFirst(_1631);
          float4 _1650 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1643 < (uint)65000), _1643, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1100, _1101), -1.0f, int2(0, 0));
          _75[0] = _1650.x;
          _75[1] = _1650.y;
          _75[2] = _1650.z;
          _75[3] = _1650.w;
          float _1660 = _75[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
          int _1661 = WaveReadLaneFirst(_1631);
          float4 _1668 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1661 < (uint)65000), _1661, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1102, _1103), -1.0f, int2(0, 0));
          _76[0] = _1668.x;
          _76[1] = _1668.y;
          _76[2] = _1668.z;
          _76[3] = _1668.w;
          float _1681 = (((_76[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _1660) * TEXCOORD_2.z) + _1660;
          int _1682 = _1640 & 128;
          if (!(_1682 == 0)) {
            _1688 = _splinePresetTextureIndex;
          } else {
            _1688 = (int)(_242);
          }
          int _1689 = _1640 & 127;
          if (((_1689 != 127)) && ((_1688 != -1))) {
            int2 _1702; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1688 < (uint)65000), _1688, 0)) + 0u))].GetDimensions(_1702.x, _1702.y);
            float4 _1711 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1688 < (uint)65000), _1688, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_1681 * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_1689) + (uint)(select((_1682 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_1702.y)))), 0.0f);
            _1717 = _1711.x;
            _1718 = _1711.y;
            _1719 = _1711.z;
            _1720 = _1711.w;
          } else {
            _1717 = 1.0f;
            _1718 = 1.0f;
            _1719 = 1.0f;
            _1720 = 1.0f;
          }
          float _1747 = saturate(exp2(log2(_1681) * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1605 < (uint)170000), _1605, 0)) + 0u))]._emissiveIntensityExponent))) * ((_1595 * _1595) * _1720);
          float _1750 = ((_1747 * TEXCOORD_6.x) * _1717) * exp2(log2(float((uint)((uint)(((uint)((uint)(_1604)) >> 16) & 255))) * 0.003921568859368563f) * 2.200000047683716f);
          float _1753 = ((_1747 * TEXCOORD_6.y) * _1718) * exp2(log2(float((uint)((uint)(((uint)((uint)(_1604)) >> 8) & 255))) * 0.003921568859368563f) * 2.200000047683716f);
          float _1756 = ((_1747 * TEXCOORD_6.z) * _1719) * exp2(log2(float((uint)((uint)(_1604 & 255))) * 0.003921568859368563f) * 2.200000047683716f);
          if ((_841 & 536871168) == 536871168) {
            if ((_1563) && (_1562)) {
              int _1764 = WaveReadLaneFirst(_1622);
              float4 _1771 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1764 < (uint)65000), _1764, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1100, _1101), -1.0f, int2(0, 0));
              _73[0] = _1771.x;
              _73[1] = _1771.y;
              _73[2] = _1771.z;
              _73[3] = _1771.w;
              float _1781 = _73[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
              int _1782 = WaveReadLaneFirst(_1622);
              float4 _1789 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1782 < (uint)65000), _1782, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1102, _1103), -1.0f, int2(0, 0));
              _74[0] = _1789.x;
              _74[1] = _1789.y;
              _74[2] = _1789.z;
              _74[3] = _1789.w;
              _1826 = ((((_74[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _1781) * TEXCOORD_2.z) + _1781);
            } else {
              int _1814 = WaveReadLaneFirst(_1622);
              float4 _1821 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1814 < (uint)65000), _1814, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2((((WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1565 < (uint)170000), _1565, 0)) + 0u))]._textureMaskOffset.x) + 0.5f) + (TEXCOORD_2.x / _1585)) - (0.5f / _1585)), (((WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1565 < (uint)170000), _1565, 0)) + 0u))]._textureMaskOffset.y) + 0.5f) + (TEXCOORD_2.y / _1586)) - (0.5f / _1586))));
              _1826 = min(_1821.x, _1821.w);
            }
            _2155 = (_1826 * _1750);
            _2156 = (_1826 * _1753);
            _2157 = (_1826 * _1756);
            _2158 = 1.0f;
          } else {
            _2155 = _1750;
            _2156 = _1753;
            _2157 = _1756;
            _2158 = 1.0f;
          }
        }
      } else {
        _2155 = 0.0f;
        _2156 = 0.0f;
        _2157 = 0.0f;
        _2158 = 1.0f;
      }
      if (!(TEXCOORD_4.w == 0.0f)) {
        float _2164 = abs(dot(float3(_211, _212, _213), float3(_188, _190, _192)));
        float _2169 = exp2(log2(select((TEXCOORD_4.w < 0.0f), (1.0f - _2164), _2164)) * abs(TEXCOORD_4.w));
        _2175 = (_2169 * _2155);
        _2176 = (_2169 * _2156);
        _2177 = (_2169 * _2157);
        _2178 = (_2169 * _1546);
      } else {
        _2175 = _2155;
        _2176 = _2156;
        _2177 = _2157;
        _2178 = _1546;
      }
      int _2179 = WaveReadLaneFirst(TEXCOORD_13.x);
      float _2187 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2179 < (uint)170000), _2179, 0)) + 0u))]._depthBiasReverseAlpha);
      if (!(_2187 == 0.0f)) {
        float _2194 = 1.0f - saturate(abs(_178 - SV_Position.w) / _2187);
        _2200 = (_2194 * _2175);
        _2201 = (_2194 * _2176);
        _2202 = (_2194 * _2177);
        _2203 = (_2194 * _2178);
      } else {
        _2200 = _2175;
        _2201 = _2176;
        _2202 = _2177;
        _2203 = _2178;
      }
      bool _2212 = (max((_2203 - max(_236, 0.0010000000474974513f)), (dot(float3(_2200, _2201, _2202), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f)) - max(((_236 + -0.004000000189989805f) * TEXCOORD_6.w), 9.999999747378752e-06f))) < 0.0f);
      if (_2212) discard;
      int _2213 = WaveReadLaneFirst(TEXCOORD_13.x);
      float _2221 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2213 < (uint)170000), _2213, 0)) + 0u))]._depthBiasAlpha);
      int _2240 = WaveReadLaneFirst(TEXCOORD_13.x);
      if (!(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2240 < (uint)170000), _2240, 0)) + 0u))]._useDepthOffsetTexture) == 0)) {
        int _2251 = WaveReadLaneFirst(TEXCOORD_13.x);
        int _2259 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2251 < (uint)170000), _2251, 0)) + 0u))]._depthOffsetTexture);
        if (_877) {
          int _2261 = WaveReadLaneFirst(_2259);
          float4 _2268 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2261 < (uint)65000), _2261, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1096, _1097));
          _2281 = _2268.x;
        } else {
          int _2271 = WaveReadLaneFirst(_2259);
          float4 _2278 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2271 < (uint)65000), _2271, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
          _2281 = _2278.x;
        }
        if (!(_832 == 0)) {
          int _2284 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _2292 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2284 < (uint)170000), _2284, 0)) + 0u))]._depthOffsetTexture);
          if (_877) {
            int _2294 = WaveReadLaneFirst(_2292);
            float4 _2301 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2294 < (uint)65000), _2294, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1098, _1099));
            _2314 = _2301.x;
          } else {
            int _2304 = WaveReadLaneFirst(_2292);
            float4 _2311 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2304 < (uint)65000), _2304, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
            _2314 = _2311.x;
          }
          _2319 = (lerp(_2281, _2314, TEXCOORD_2.z));
        } else {
          _2319 = _2281;
        }
      } else {
        _2319 = 1.0f;
      }
      if (!((WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_842 < (uint)170000), _842, 0)) + 0u))]._materialFlags2) & 8) == 0)) {
        int _2323 = WaveReadLaneFirst(TEXCOORD_13.x);
        float _2332 = TEXCOORD_2.x + -0.5f;
        _2338 = (1.0f - (((_2332 * _2332) * 4.0f) * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2323 < (uint)170000), _2323, 0)) + 0u))]._depthOffsetCurvature)));
      } else {
        _2338 = 1.0f;
      }
      int _2339 = WaveReadLaneFirst(TEXCOORD_13.x);
      float _2351 = max(0.0f, _1543);
      float _2352 = max(0.0f, _1544);
      float _2353 = max(0.0f, _1545);
      float _2354 = saturate(_2203);
      float _2355 = max(0.0f, _2200);
      float _2356 = max(0.0f, _2201);
      float _2357 = max(0.0f, _2202);
      float _2358 = SV_Position.w - (((_2319 * TEXCOORD_25.w) * _2338) * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2339 < (uint)170000), _2339, 0)) + 0u))]._depthOffset));
      if (_179 == 393216) {
        bool _2362 = ((_178 - _2358) < 0.0f);
        if (_2362) discard;
      }
      [branch]
      if ((_useOverdrawCounter == 0) || ((!(_useOverdrawCounter == 0)) && (!(_pixelRate > 5.0f)))) {
        float _2435 = ((_2352 * 0.3395099937915802f) + (_2351 * 0.6131200194358826f)) + (_2353 * 0.047370001673698425f);
        float _2436 = ((_2352 * 0.9163600206375122f) + (_2351 * 0.07020000368356705f)) + (_2353 * 0.013450000435113907f);
        float _2437 = ((_2352 * 0.10958000272512436f) + (_2351 * 0.02061999961733818f)) + (_2353 * 0.8697999715805054f);
        float _2450 = ((_2356 * 0.3395099937915802f) + (_2355 * 0.6131200194358826f)) + (_2357 * 0.047370001673698425f);
        float _2451 = ((_2356 * 0.9163600206375122f) + (_2355 * 0.07020000368356705f)) + (_2357 * 0.013450000435113907f);
        float _2452 = ((_2356 * 0.10958000272512436f) + (_2355 * 0.02061999961733818f)) + (_2357 * 0.8697999715805054f);
        bool _2455 = (_234 == 0);
        if ((_2455) && ((abs(_2221) > 0.0010000000474974513f))) {
          float _2461 = abs(_178 - _2358) * _2221;
          if (_2221 < 0.0f) {
            _2472 = saturate(exp2(_2461 * 1.4426950216293335f));
          } else {
            _2472 = (1.0f - saturate(exp2(_2461 * -1.4426950216293335f)));
          }
          float _2476 = (pow(_2472, _2158));
          _2481 = (_2476 * _2450);
          _2482 = (_2476 * _2451);
          _2483 = (_2476 * _2452);
          _2484 = (_2472 * _2354);
        } else {
          _2481 = _2450;
          _2482 = _2451;
          _2483 = _2452;
          _2484 = _2354;
        }
        if (!_2455) {
          float _2519 = mad((_viewProjRelative[3].z), TEXCOORD_4.z, mad((_viewProjRelative[3].y), TEXCOORD_4.y, ((_viewProjRelative[3].x) * TEXCOORD_4.x))) + (_viewProjRelative[3].w);
          float _2540 = float((uint)((uint)(((int)(_frameNumber.x * 3)) & 1023)));
          float _2541 = float((int)(int(((((mad((_viewProjRelative[0].z), TEXCOORD_4.z, mad((_viewProjRelative[0].y), TEXCOORD_4.y, ((_viewProjRelative[0].x) * TEXCOORD_4.x))) + (_viewProjRelative[0].w)) / _2519) * 0.5f) + 0.5f) * _gpuParticleFroxelSize.x)));
          float _2542 = float((int)(int((0.5f - (((mad((_viewProjRelative[1].z), TEXCOORD_4.z, mad((_viewProjRelative[1].y), TEXCOORD_4.y, ((_viewProjRelative[1].x) * TEXCOORD_4.x))) + (_viewProjRelative[1].w)) / _2519) * 0.5f)) * _gpuParticleFroxelSize.y)));
          float _2553 = float((uint)((uint)(((int)(_frameNumber.x * 5)) & 1023)));
          float _2564 = float((uint)((uint)(((int)(_frameNumber.x * 7)) & 1023)));
          int _2583 = int(frac(frac(dot(float2(((_2540 * 32.665000915527344f) + _2541), ((_2540 * 11.8149995803833f) + _2542)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) + _2541);
          int _2584 = int(frac(frac(dot(float2(((_2553 * 32.665000915527344f) + _2541), ((_2553 * 11.8149995803833f) + _2542)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) + _2542);
          int _2585 = int((frac(frac(dot(float2(((_2564 * 32.665000915527344f) + _2541), ((_2564 * 11.8149995803833f) + _2542)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) + -0.5f) + max(0.0f, (log2((max(0.0f, sqrt(((TEXCOORD_4.y * TEXCOORD_4.y) + (TEXCOORD_4.x * TEXCOORD_4.x)) + (TEXCOORD_4.z * TEXCOORD_4.z))) * 0.04351966083049774f) + 1.0f) * 17.673004150390625f)));
          float _2586 = _2484 * 5000.0f;
          uint _2595; InterlockedAdd(__3__38__0__1__g_texFroxelMediaGatherR[int3(_2583, _2584, _2585)], (int)(uint(saturate(_2435) * _2586)), _2595);
          uint _2597; InterlockedAdd(__3__38__0__1__g_texFroxelMediaGatherG[int3(_2583, _2584, _2585)], (int)(uint(saturate(_2436) * _2586)), _2597);
          uint _2599; InterlockedAdd(__3__38__0__1__g_texFroxelMediaGatherB[int3(_2583, _2584, _2585)], (int)(uint(saturate(_2437) * _2586)), _2599);
          uint _2601; InterlockedAdd(__3__38__0__1__g_texFroxelMediaGatherA[int3(_2583, _2584, _2585)], (int)(uint(_2586)), _2601);
          if (true) discard;
        }
        float _2611 = max(0.0f, (log2((max(0.0f, _2358) * 0.04351966083049774f) + 1.0f) * 17.673004150390625f)) / _gpuParticleFroxelSize.z;
        if ((((TEXCOORD_13.y & 1) != 0)) && ((_2484 > 0.0f))) {
          if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
            _2631 = _sunDirection.x;
            _2632 = _sunDirection.y;
            _2633 = _sunDirection.z;
          } else {
            _2631 = _moonDirection.x;
            _2632 = _moonDirection.y;
            _2633 = _moonDirection.z;
          }
          float _2645 = float((uint)((((int)(uint(1.0f / _invRenderTargetAndViewportSize.x)) * (int)(_97)) + _96) + ((uint)(((int)(_frameNumber.x * 71)) & 15))));
          float _2659 = _offScreenParticleViewportRatio * _offScreenParticleViewportRatio;
          float _2661 = (((frac((_2645 * 0.7548776268959045f) + 0.5f) * 2.0f) + -1.0f) * _invRenderTargetAndViewportSize.x) * _2659;
          float _2663 = (((frac((_2645 * 0.5698402523994446f) + 0.5f) * 2.0f) + -1.0f) * _invRenderTargetAndViewportSize.y) * _2659;
          float _2664 = saturate(_2435);
          float4 _2669 = __3__36__0__0__g_texFroxelLight.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_116, _117, _2611), 0.0f);
          int _2680 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _2688 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2680 < (uint)170000), _2680, 0)) + 0u))]._materialFlags);
          if (!((int)(uint(TEXCOORD_15.x)) == 0)) {
            float _2693 = (_221 * _190) - (_220 * _192);
            float _2696 = (_219 * _192) - (_221 * _188);
            float _2699 = (_220 * _188) - (_219 * _190);
            float _2701 = rsqrt(dot(float3(_2693, _2696, _2699), float3(_2693, _2696, _2699)));
            float _2707 = (_228 * _192) - (_229 * _190);
            float _2710 = (_229 * _188) - (_227 * _192);
            float _2713 = (_227 * _190) - (_228 * _188);
            float _2715 = rsqrt(dot(float3(_2707, _2710, _2713), float3(_2707, _2710, _2713)));
            _2720 = _188;
            _2721 = _190;
            _2722 = _192;
            _2723 = (_2701 * _2693);
            _2724 = (_2701 * _2696);
            _2725 = (_2701 * _2699);
            _2726 = (_2715 * _2707);
            _2727 = (_2715 * _2710);
            _2728 = (_2715 * _2713);
          } else {
            _2720 = _211;
            _2721 = _212;
            _2722 = _213;
            _2723 = _219;
            _2724 = _220;
            _2725 = _221;
            _2726 = _227;
            _2727 = _228;
            _2728 = _229;
          }
          float _2729 = dot(float3(_2726, _2727, _2728), float3(_2631, _2632, _2633));
          float _2730 = dot(float3(_2723, _2724, _2725), float3(_2631, _2632, _2633));
          float _2731 = dot(float3(_2720, _2721, _2722), float3(_2631, _2632, _2633));
          if (!((_2688 & 67108864) == 0)) {
            if (((((!(_2729 == 0.0f))) || ((!(_2730 == 0.0f))))) || ((!(_2731 == 0.0f)))) {
              int _2741 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _2750 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2741 < (uint)170000), _2741, 0)) + 0u))]._textureLightMap));
              float4 _2757 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2750 < (uint)65000), _2750, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
              if ((int)_2688 < (int)0) {
                int _2764 = WaveReadLaneFirst(TEXCOORD_13.x);
                int _2773 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2764 < (uint)170000), _2764, 0)) + 0u))]._textureLightMap2));
                float4 _2780 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2773 < (uint)65000), _2773, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
                if (_831) {
                  int _2785 = WaveReadLaneFirst(TEXCOORD_13.x);
                  int _2794 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2785 < (uint)170000), _2785, 0)) + 0u))]._textureLightMap));
                  float4 _2801 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2794 < (uint)65000), _2794, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
                  int _2805 = WaveReadLaneFirst(TEXCOORD_13.x);
                  int _2814 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2805 < (uint)170000), _2805, 0)) + 0u))]._textureLightMap2));
                  float4 _2821 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2814 < (uint)65000), _2814, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
                  _2844 = (lerp(_2757.x, _2801.x, TEXCOORD_2.z));
                  _2845 = (lerp(_2757.y, _2801.y, TEXCOORD_2.z));
                  _2846 = (lerp(_2757.z, _2801.z, TEXCOORD_2.z));
                  _2847 = (lerp(_2780.x, _2821.x, TEXCOORD_2.z));
                  _2848 = (lerp(_2780.y, _2821.y, TEXCOORD_2.z));
                  _2849 = (lerp(_2780.z, _2821.z, TEXCOORD_2.z));
                } else {
                  _2844 = _2757.x;
                  _2845 = _2757.y;
                  _2846 = _2757.z;
                  _2847 = _2780.x;
                  _2848 = _2780.y;
                  _2849 = _2780.z;
                }
                _2931 = dot(float3(((saturate((_2729 * 0.5f) + 0.5f) * (_2844 - _2845)) + _2845), ((saturate((_2730 * 0.5f) + 0.5f) * (_2847 - _2846)) + _2846), ((saturate((_2731 * 0.5f) + 0.5f) * (_2849 - _2848)) + _2848)), float3(abs(_2729), abs(_2730), abs(_2731)));
              } else {
                if (_831) {
                  int _2874 = WaveReadLaneFirst(TEXCOORD_13.x);
                  int _2883 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2874 < (uint)170000), _2874, 0)) + 0u))]._textureLightMap));
                  float4 _2890 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2883 < (uint)65000), _2883, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
                  _2908 = (lerp(_2757.x, _2890.x, TEXCOORD_2.z));
                  _2909 = (lerp(_2757.y, _2890.y, TEXCOORD_2.z));
                  _2910 = (lerp(_2757.z, _2890.z, TEXCOORD_2.z));
                  _2911 = (lerp(_2757.w, _2890.w, TEXCOORD_2.z));
                } else {
                  _2908 = _2757.x;
                  _2909 = _2757.y;
                  _2910 = _2757.z;
                  _2911 = _2757.w;
                }
                _2931 = dot(float3(((saturate((_2729 * 0.5f) + 0.5f) * (_2909 - _2908)) + _2908), ((saturate((_2730 * 0.5f) + 0.5f) * (_2910 - _2911)) + _2911), ((_2731 * 0.5f) + 0.5f)), float3(abs(_2729), abs(_2730), abs(_2731)));
              }
            } else {
              _2931 = 1.0f;
            }
          } else {
            _2931 = 1.0f;
          }
          if (!(_time.w > 22.0f)) {
            if (!(((_2484 < 0.10000000149011612f)) || ((_time.w < 2.0f)))) {
              int _2940 = WaveReadLaneFirst(TEXCOORD_13.x);
              if (WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2940 < (uint)170000), _2940, 0)) + 0u))]._rayMarchDistance) > 0.0f) {
                int _2951 = WaveReadLaneFirst(TEXCOORD_13.x);
                if (WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2951 < (uint)170000), _2951, 0)) + 0u))]._particleDensity) > 0.0f) {
                  uint _2966 = uint((saturate(_2484 * 2.0f) * 3.0f) + 1.0f);
                  int _2967 = WaveReadLaneFirst(TEXCOORD_13.x);
                  int _2976 = WaveReadLaneFirst(TEXCOORD_13.x);
                  float _2986 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2976 < (uint)170000), _2976, 0)) + 0u))]._rayMarchDistance) / float((uint)_2966);
                  int _2991 = WaveReadLaneFirst(TEXCOORD_13.x);
                  int _3000 = WaveReadLaneFirst(TEXCOORD_13.x);
                  bool _3014 = ((int)(_2966) == 0);
                  if ((_831) && (((_2688 & 1) != 0))) {
                    if (!_3014) {
                      float _3017 = exp2(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_3000 < (uint)170000), _3000, 0)) + 0u))]._rayMarchDistance) * 25.968509674072266f) * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2991 < (uint)170000), _2991, 0)) + 0u))]._rayMarchDistance);
                      float _3020 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2967 < (uint)170000), _2967, 0)) + 0u))]._particleDensity) * TEXCOORD_3.w;
                      _3024 = (_3017 * _2661);
                      _3025 = (_3017 * _2663);
                      _3026 = 0.0f;
                      _3027 = 0;
                      while(true) {
                        float _3028 = _3024 + (_2986 * (_2729 + _2661));
                        float _3029 = _3025 + (_2986 * (_2730 + _2663));
                        int _3030 = WaveReadLaneFirst(TEXCOORD_13.x);
                        int _3038 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_3030 < (uint)170000), _3030, 0)) + 0u))]._textureMask);
                        int _3043 = WaveReadLaneFirst(_3038);
                        float4 _3050 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_3043 < (uint)65000), _3043, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2((_3028 + _1100), (_3029 + _1101)), -1.0f, int2(0, 0));
                        _71[0] = _3050.x;
                        _71[1] = _3050.y;
                        _71[2] = _3050.z;
                        _71[3] = _3050.w;
                        float _3060 = _71[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
                        int _3063 = WaveReadLaneFirst(_3038);
                        float4 _3070 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_3063 < (uint)65000), _3063, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2((_3028 + _1102), (_3029 + _1103)), -1.0f, int2(0, 0));
                        _72[0] = _3070.x;
                        _72[1] = _3070.y;
                        _72[2] = _3070.z;
                        _72[3] = _3070.w;
                        float _3087 = (((_3020 * 10.0f) * _2986) * saturate(((((_72[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _3060) * TEXCOORD_2.z) + _3060) * _3020)) + _3026;
                        if (!((_3027 + 1) == (int)(_2966))) {
                          _3024 = _3028;
                          _3025 = _3029;
                          _3026 = _3087;
                          _3027 = (_3027 + 1);
                          continue;
                        }
                        _3096 = (_3087 * -1.4426950216293335f);
                        break;
                      }
                    } else {
                      _3096 = -0.0f;
                    }
                  } else {
                    if (!_3014) {
                      _3096 = -0.0f;
                    } else {
                      _3096 = -0.0f;
                    }
                  }
                  _3100 = (exp2(_3096) * _2931);
                } else {
                  _3100 = _2931;
                }
              } else {
                _3100 = _2931;
              }
            } else {
              _3100 = _2931;
            }
          } else {
            _3100 = _2931;
          }
          float _3101 = max(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1547 < (uint)170000), _1547, 0)) + 0u))]._transmission), _3100);
          _3131 = _2664;
          _3132 = (-0.0f - ((_2664 * min(0.0f, (-0.0f - _2669.x))) * _3101));
          _3133 = (-0.0f - ((saturate(_2436) * min(0.0f, (-0.0f - _2669.y))) * _3101));
          _3134 = (-0.0f - ((saturate(_2437) * min(0.0f, (-0.0f - _2669.z))) * _3101));
        } else {
          if (!((TEXCOORD_13.y & 32768) == 0) | !((_gpuParticleRenderCommonFlags & 2) == 0)) {
            _3126 = (1.0f / min(1e+06f, max(9.999999747378752e-06f, _exposure0.x)));
          } else {
            _3126 = 1.0f;
          }
          _3131 = _2435;
          _3132 = (_3126 * _2435);
          _3133 = (_3126 * _2436);
          _3134 = (_3126 * _2437);
        }
        if (!((TEXCOORD_13.y & 1048576) == 0)) {
          float4 _3140 = __3__36__0__0__g_texFroxel.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_116, _117, _2611), 0.0f);
          float _3155 = (pow(_3140.w, _emissiveScatteringExponent));
          _3160 = (_3155 * _2481);
          _3161 = (_3155 * _2482);
          _3162 = (_3155 * _2483);
          _3163 = ((_3140.w * _3132) + _3140.x);
          _3164 = ((_3140.w * _3133) + _3140.y);
          _3165 = ((_3140.w * _3134) + _3140.z);
        } else {
          _3160 = _2481;
          _3161 = _2482;
          _3162 = _2483;
          _3163 = _3132;
          _3164 = _3133;
          _3165 = _3134;
        }
        bool _3171 = (((TEXCOORD_13.y & 8) != 0)) && ((_isAllowBlood == 0));
        float _3172 = _3131 * 0.4000000059604645f;
        float _3194 = ((((9.999999046325684f - (saturate(0.10000000149011612f / _exposure0.x) * 8.999999046325684f)) * ((20.0f - (saturate(_exposure0.x) * 19.0f)) / min(max(9.999999974752427e-07f, _exposure0.x), 10.0f))) + -1.0f) * TEXCOORD_14.x) + 1.0f;
        float _3201 = (_3194 * select(_3171, 0.0f, _3160)) + (select(_3171, _3172, _3163) * _2484);
        float _3202 = (_3194 * select(_3171, 0.0f, _3161)) + (select(_3171, _3172, _3164) * _2484);
        float _3203 = (_3194 * select(_3171, 0.0f, _3162)) + (select(_3171, _3172, _3165) * _2484);
        float _3207 = saturate(max(_2484, (dot(float3(_3201, _3202, _3203), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.10000000149011612f)));
        _3219 = max(1.0000000116860974e-07f, ((saturate((_3207 * _3207) * 3.0f) * ((_nearFarProj.x / _2358) - _174)) + _174));
        _3220 = 26.0f;
        _3221 = _3201;
        _3222 = _3202;
        _3223 = _3203;
        _3224 = _2484;
      } else {
        float _2378 = float((int)(int(_98 * 0.03999999910593033f))) * 0.5f;
        float _2379 = float((int)(int(_99 * 0.03999999910593033f))) * 0.5f;
        float _2396 = max(select((_2354 > 0.009999999776482582f), 1.0f, 0.0f), max(max(_2355, _2356), _2357));
        float _2415 = ((9.999999046325684f - (saturate(0.10000000149011612f / _exposure0.x) * 8.999999046325684f)) * ((20.0f - (saturate(_exposure0.x) * 19.0f)) / min(max(9.999999974752427e-07f, _exposure0.x), 10.0f))) * (select((_2396 > 0.0010000000474974513f), (_2396 * 0.10000000149011612f), 0.0f) * max(0.009999999776482582f, _2396));
        _3219 = 0.0f;
        _3220 = 0.0f;
        _3221 = ((_2415 * frac(sin(dot(float2(_2378, _2379), float2(127.0999984741211f, 311.70001220703125f))) * 43758.546875f)) + _2355);
        _3222 = ((_2415 * frac(sin(dot(float2(_2378, _2379), float2(269.5f, 183.3000030517578f))) * 43758.546875f)) + _2356);
        _3223 = ((_2415 * frac(sin(dot(float2(_2378, _2379), float2(419.20001220703125f, 371.8999938964844f))) * 43758.546875f)) + _2357);
        _3224 = _2354;
      }
      SV_Target.x = _3221;
      SV_Target.y = _3222;
      SV_Target.z = _3223;
      SV_Target.w = _3224;
      SV_Target_1.x = _3219;
      SV_Target_1.y = _3220;
    }
    if (__defer_865_874) {
      if (true) discard;
    }
  }
  bool _877 = ((_841 & 32) != 0);
  bool _881 = ((_841 & 128) != 0);
  int _882 = WaveReadLaneFirst(TEXCOORD_13.x);
  if ((((_841 & 131072) != 0)) && ((!(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_882 < (uint)170000), _882, 0)) + 0u))]._opticalFlowStrength) == 0.0f)))) {
    int _896 = WaveReadLaneFirst(TEXCOORD_13.x);
    int _905 = WaveReadLaneFirst(TEXCOORD_13.x);
    int _913 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_905 < (uint)170000), _905, 0)) + 0u))]._textureOpticalFlow);
    int _914 = WaveReadLaneFirst(TEXCOORD_13.x);
    int _922 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_914 < (uint)170000), _914, 0)) + 0u))]._opticalFlowStrengthSpline);
    int _923 = _922 & 128;
    if (!(_923 == 0)) {
      _929 = _splinePresetTextureIndex;
    } else {
      _929 = (int)(_242);
    }
    int _930 = _922 & 127;
    if (((_930 != 127)) && ((_929 != -1))) {
      int2 _943; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_929 < (uint)65000), _929, 0)) + 0u))].GetDimensions(_943.x, _943.y);
      float4 _952 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_929 < (uint)65000), _929, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((TEXCOORD_15.z * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_930) + (uint)(select((_923 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_943.y)))), 0.0f);
      _955 = _952.x;
    } else {
      _955 = 1.0f;
    }
    float _956 = _955 * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_896 < (uint)170000), _896, 0)) + 0u))]._opticalFlowStrength);
    if (_877) {
      int _958 = WaveReadLaneFirst(_913);
      float4 _965 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_958 < (uint)65000), _958, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_827, _828));
      _980 = _965.x;
      _981 = _965.y;
    } else {
      int _969 = WaveReadLaneFirst(_913);
      float4 _976 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_969 < (uint)65000), _969, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_827, _828));
      _980 = _976.x;
      _981 = _976.y;
    }
    float _986 = _956 * TEXCOORD_2.z;
    float _989 = _827 - (((_980 * 2.0f) + -0.9960784316062927f) * _986);
    float _990 = _828 - (((_981 * 2.0f) + -0.9960784316062927f) * _986);
    if (!(TEXCOORD_2.z == 0.0f)) {
      if (_877) {
        int _994 = WaveReadLaneFirst(_913);
        float4 _1001 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_994 < (uint)65000), _994, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_829, _830));
        _1016 = _1001.x;
        _1017 = _1001.y;
      } else {
        int _1005 = WaveReadLaneFirst(_913);
        float4 _1012 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1005 < (uint)65000), _1005, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_829, _830));
        _1016 = _1012.x;
        _1017 = _1012.y;
      }
      float _1023 = _956 * (1.0f - TEXCOORD_2.z);
      _1029 = _989;
      _1030 = _990;
      _1031 = ((((_1016 * 2.0f) + -0.9960784316062927f) * _1023) + _829);
      _1032 = ((((_1017 * 2.0f) + -0.9960784316062927f) * _1023) + _830);
    } else {
      _1029 = _989;
      _1030 = _990;
      _1031 = _829;
      _1032 = _830;
    }
  } else {
    _1029 = _827;
    _1030 = _828;
    _1031 = _829;
    _1032 = _830;
  }
  int _1033 = WaveReadLaneFirst(TEXCOORD_13.x);
  if ((((_841 & 8192) != 0)) && ((WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1033 < (uint)170000), _1033, 0)) + 0u))]._selfDistortionIntensity) > 0.0f))) {
    int _1047 = WaveReadLaneFirst(TEXCOORD_13.x);
    int _1055 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1047 < (uint)170000), _1047, 0)) + 0u))]._textureDistortion);
    if ((_841 & 16384) == 0) {
      int _1069 = WaveReadLaneFirst(_1055);
      float4 _1076 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1069 < (uint)65000), _1069, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_193, _194));
      _1081 = _1076.x;
      _1082 = _1076.y;
      _1083 = _1076.w;
    } else {
      int _1057 = WaveReadLaneFirst(_1055);
      float4 _1064 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1057 < (uint)65000), _1057, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_193, _194));
      _1081 = _1064.x;
      _1082 = _1064.y;
      _1083 = _1064.w;
    }
    float _1088 = _1083 * float(TEXCOORD_5.w);
    float _1089 = _1088 * ((_1081 * 2.0f) + -0.9960784316062927f);
    float _1090 = _1088 * ((_1082 * 2.0f) + -0.9960784316062927f);
    _1096 = (_1029 - _1089);
    _1097 = (_1030 - _1090);
    _1098 = (_1031 - _1089);
    _1099 = (_1032 - _1090);
  } else {
    _1096 = _1029;
    _1097 = _1030;
    _1098 = _1031;
    _1099 = _1032;
  }
  float _1100 = _1096 * 2.0f;
  float _1101 = _1097 * 2.0f;
  float _1102 = _1098 * 2.0f;
  float _1103 = _1099 * 2.0f;
  if (!((_841 & 4) == 0)) {
    bool _1119 = (_832 != 0);
    bool _1120 = (_1119) && (((_841 & 268435456) != 0));
    if ((_1119) && (((_841 & 1) != 0))) {
      int _1125 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1133 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1125 < (uint)170000), _1125, 0)) + 0u))]._textureBase);
      int _1136 = WaveReadLaneFirst(_1133);
      float4 _1143 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1136 < (uint)65000), _1136, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1100, _1101), -1.0f, int2(0, 0));
      _79[0] = _1143.x;
      _79[1] = _1143.y;
      _79[2] = _1143.z;
      _79[3] = _1143.w;
      float _1153 = _79[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
      int _1154 = WaveReadLaneFirst(_1133);
      float4 _1161 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1154 < (uint)65000), _1154, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1102, _1103), -1.0f, int2(0, 0));
      _80[0] = _1161.x;
      _80[1] = _1161.y;
      _80[2] = _1161.z;
      _80[3] = _1161.w;
      float _1174 = (((_80[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _1153) * TEXCOORD_2.z) + _1153;
      float _1175 = _1174 * TEXCOORD_3.x;
      float _1176 = _1174 * TEXCOORD_3.y;
      float _1177 = _1174 * TEXCOORD_3.z;
      if (!((_841 & 256) == 0)) {
        if (_1120) {
          int _1182 = WaveReadLaneFirst(TEXCOORD_13.x);
          float _1191 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1182 < (uint)170000), _1182, 0)) + 0u))]._textureMaskScale.x);
          float _1192 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1182 < (uint)170000), _1182, 0)) + 0u))]._textureMaskScale.y);
          int _1201 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1214 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1223 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1214 < (uint)170000), _1214, 0)) + 0u))]._textureMask));
          float4 _1230 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1223 < (uint)65000), _1223, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(((((TEXCOORD_2.x / _1191) + 0.5f) - (0.5f / _1191)) + WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1201 < (uint)170000), _1201, 0)) + 0u))]._textureMaskOffset.x)), ((((TEXCOORD_2.y / _1192) + 0.5f) - (0.5f / _1192)) + WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1201 < (uint)170000), _1201, 0)) + 0u))]._textureMaskOffset.y))));
          _1536 = min(_1230.x, _1230.w);
          _1537 = _1175;
          _1538 = _1176;
          _1539 = _1177;
          _1540 = _233;
        } else {
          int _1235 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _1243 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1235 < (uint)170000), _1235, 0)) + 0u))]._textureMask);
          int _1246 = WaveReadLaneFirst(_1243);
          float4 _1253 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1246 < (uint)65000), _1246, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1100, _1101), -1.0f, int2(0, 0));
          _77[0] = _1253.x;
          _77[1] = _1253.y;
          _77[2] = _1253.z;
          _77[3] = _1253.w;
          float _1263 = _77[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
          int _1264 = WaveReadLaneFirst(_1243);
          float4 _1271 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1264 < (uint)65000), _1264, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1102, _1103), -1.0f, int2(0, 0));
          _78[0] = _1271.x;
          _78[1] = _1271.y;
          _78[2] = _1271.z;
          _78[3] = _1271.w;
          _1536 = ((((_78[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _1263) * TEXCOORD_2.z) + _1263);
          _1537 = _1175;
          _1538 = _1176;
          _1539 = _1177;
          _1540 = _233;
        }
      } else {
        _1536 = 1.0f;
        _1537 = _1175;
        _1538 = _1176;
        _1539 = _1177;
        _1540 = _233;
      }
    } else {
      int _1289 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1297 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1289 < (uint)170000), _1289, 0)) + 0u))]._textureBase);
      if (_877) {
        int _1299 = WaveReadLaneFirst(_1297);
        float4 _1306 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1299 < (uint)65000), _1299, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1096, _1097));
        _1325 = _1306.x;
        _1326 = _1306.y;
        _1327 = _1306.z;
        _1328 = _1306.w;
      } else {
        int _1312 = WaveReadLaneFirst(_1297);
        float4 _1319 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1312 < (uint)65000), _1312, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
        _1325 = _1319.x;
        _1326 = _1319.y;
        _1327 = _1319.z;
        _1328 = _1319.w;
      }
      if (!(_832 == 0)) {
        if (_877) {
          int _1331 = WaveReadLaneFirst(_1297);
          float4 _1338 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1331 < (uint)65000), _1331, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1098, _1099));
          _1357 = _1338.x;
          _1358 = _1338.y;
          _1359 = _1338.z;
          _1360 = _1338.w;
        } else {
          int _1344 = WaveReadLaneFirst(_1297);
          float4 _1351 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1344 < (uint)65000), _1344, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
          _1357 = _1351.x;
          _1358 = _1351.y;
          _1359 = _1351.z;
          _1360 = _1351.w;
        }
        _1374 = (lerp(_1325, _1357, TEXCOORD_2.z));
        _1375 = (lerp(_1326, _1358, TEXCOORD_2.z));
        _1376 = (lerp(_1327, _1359, TEXCOORD_2.z));
        _1377 = (lerp(_1328, _1360, TEXCOORD_2.z));
      } else {
        _1374 = _1325;
        _1375 = _1326;
        _1376 = _1327;
        _1377 = _1328;
      }
      if (!((_841 & 524288) == 0)) {
        _1381 = max(9.999999747378752e-05f, _1377);
      } else {
        _1381 = 1.0f;
      }
      if (!((_841 & 256) == 0)) {
        int _1388 = WaveReadLaneFirst(TEXCOORD_13.x);
        bool _1400 = ((_841 & 1048576) != 0);
        int _1401 = WaveReadLaneFirst(TEXCOORD_13.x);
        int _1409 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1401 < (uint)170000), _1401, 0)) + 0u))]._textureMask);
        int _1410 = WaveReadLaneFirst(TEXCOORD_13.x);
        int _1418 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1410 < (uint)170000), _1410, 0)) + 0u))]._textureMaskOffsetSpline);
        if (!_1120) {
          int _1422 = _1418 & 128;
          if (!(_1422 == 0)) {
            _1428 = _splinePresetTextureIndex;
          } else {
            _1428 = (int)(_242);
          }
          int _1429 = _1418 & 127;
          if (((_1429 != 127)) && ((_1428 != -1))) {
            int2 _1442; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1428 < (uint)65000), _1428, 0)) + 0u))].GetDimensions(_1442.x, _1442.y);
            float4 _1451 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1428 < (uint)65000), _1428, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((TEXCOORD_15.z * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_1429) + (uint)(select((_1422 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_1442.y)))), 0.0f);
            _1455 = _1451.x;
            _1456 = _1451.y;
          } else {
            _1455 = 1.0f;
            _1456 = 1.0f;
          }
        } else {
          _1455 = 1.0f;
          _1456 = 1.0f;
        }
        float _1457 = _1455 * select(_1120, 0.0f, WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1388 < (uint)170000), _1388, 0)) + 0u))]._textureMaskOffset.x));
        float _1458 = _1456 * select(_1120, 0.0f, WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1388 < (uint)170000), _1388, 0)) + 0u))]._textureMaskOffset.y));
        float _1461 = _1457 + select(_1400, _1096, TEXCOORD_2.x);
        float _1462 = _1458 + select(_1400, _1097, TEXCOORD_2.y);
        if ((_841 & 1048608) == 1048608) {
          int _1466 = WaveReadLaneFirst(_1409);
          float4 _1473 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1466 < (uint)65000), _1466, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1461, _1462));
          _1488 = _1473.x;
          _1489 = _1473.w;
        } else {
          int _1477 = WaveReadLaneFirst(_1409);
          float4 _1484 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1477 < (uint)65000), _1477, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1461, _1462));
          _1488 = _1484.x;
          _1489 = _1484.w;
        }
        if ((_1119) && (_1400)) {
          float _1492 = _1457 + _1098;
          float _1493 = _1458 + _1099;
          if (_877) {
            int _1495 = WaveReadLaneFirst(_1409);
            float4 _1502 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1495 < (uint)65000), _1495, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1492, _1493));
            _1517 = _1502.x;
            _1518 = _1502.w;
          } else {
            int _1506 = WaveReadLaneFirst(_1409);
            float4 _1513 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1506 < (uint)65000), _1506, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1492, _1493));
            _1517 = _1513.x;
            _1518 = _1513.w;
          }
          _1526 = (lerp(_1488, _1517, TEXCOORD_2.z));
          _1527 = (lerp(_1489, _1518, TEXCOORD_2.z));
        } else {
          _1526 = _1488;
          _1527 = _1489;
        }
        _1530 = min(_1526, _1527);
      } else {
        _1530 = 1.0f;
      }
      _1536 = _1530;
      _1537 = ((_1374 / _1381) * TEXCOORD_3.x);
      _1538 = ((_1375 / _1381) * TEXCOORD_3.y);
      _1539 = ((_1376 / _1381) * TEXCOORD_3.z);
      _1540 = (_1377 * _233);
    }
    _1543 = _1537;
    _1544 = _1538;
    _1545 = _1539;
    _1546 = (_1540 * _1536);
  } else {
    _1543 = TEXCOORD_3.x;
    _1544 = TEXCOORD_3.y;
    _1545 = TEXCOORD_3.z;
    _1546 = _233;
  }
  int _1547 = WaveReadLaneFirst(TEXCOORD_13.x);
  if (!((_841 & 64) == 0)) {
    bool _1562 = ((_841 & 1048576) != 0);
    bool _1563 = (_832 != 0);
    if ((_841 & 2) == 0) {
      int _1831 = WaveReadLaneFirst(TEXCOORD_13.x);
      float _1839 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1831 < (uint)170000), _1831, 0)) + 0u))]._emissiveIntensityExponent);
      int _1840 = WaveReadLaneFirst(TEXCOORD_13.x);
      float _1848 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1840 < (uint)170000), _1840, 0)) + 0u))]._temperatureBrightness);
      int _1849 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1857 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1849 < (uint)170000), _1849, 0)) + 0u))]._temperatureColor);
      bool _1861 = ((_841 & 262144) != 0);
      bool _1863 = ((_841 & 512) != 0);
      int _1864 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1872 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1864 < (uint)170000), _1864, 0)) + 0u))]._textureMask);
      int _1882 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1890 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1882 < (uint)170000), _1882, 0)) + 0u))]._textureEmissive);
      int _1891 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1899 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1891 < (uint)170000), _1891, 0)) + 0u))]._temperatureColorSpline);
      if ((_841 & 536871168) == 536871168) {
        float _1905 = select(_1562, _1096, TEXCOORD_2.x);
        float _1906 = select(_1562, _1097, TEXCOORD_2.y);
        if ((_841 & 1048704) == 1048704) {
          int _1908 = WaveReadLaneFirst(_1872);
          float4 _1915 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1908 < (uint)65000), _1908, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1905, _1906));
          _1930 = _1915.x;
          _1931 = _1915.w;
        } else {
          int _1919 = WaveReadLaneFirst(_1872);
          float4 _1926 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1919 < (uint)65000), _1919, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1905, _1906));
          _1930 = _1926.x;
          _1931 = _1926.w;
        }
        if ((_1563) && (_1562)) {
          if (_881) {
            int _1935 = WaveReadLaneFirst(_1872);
            float4 _1942 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1935 < (uint)65000), _1935, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1098, _1099));
            _1957 = _1942.x;
            _1958 = _1942.w;
          } else {
            int _1946 = WaveReadLaneFirst(_1872);
            float4 _1953 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1946 < (uint)65000), _1946, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
            _1957 = _1953.x;
            _1958 = _1953.w;
          }
          _1966 = (lerp(_1930, _1957, TEXCOORD_2.z));
          _1967 = (lerp(_1931, _1958, TEXCOORD_2.z));
        } else {
          _1966 = _1930;
          _1967 = _1931;
        }
        _1970 = min(_1966, _1967);
      } else {
        _1970 = 1.0f;
      }
      if (_881) {
        int _1972 = WaveReadLaneFirst(_1890);
        float4 _1979 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1972 < (uint)65000), _1972, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1096, _1097));
        _1998 = _1979.x;
        _1999 = _1979.y;
        _2000 = _1979.z;
        _2001 = _1979.w;
      } else {
        int _1985 = WaveReadLaneFirst(_1890);
        float4 _1992 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1985 < (uint)65000), _1985, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
        _1998 = _1992.x;
        _1999 = _1992.y;
        _2000 = _1992.z;
        _2001 = _1992.w;
      }
      if (_1563) {
        if (_881) {
          int _2004 = WaveReadLaneFirst(_1890);
          float4 _2011 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2004 < (uint)65000), _2004, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1098, _1099));
          _2030 = _2011.x;
          _2031 = _2011.y;
          _2032 = _2011.z;
          _2033 = _2011.w;
        } else {
          int _2017 = WaveReadLaneFirst(_1890);
          float4 _2024 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2017 < (uint)65000), _2017, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
          _2030 = _2024.x;
          _2031 = _2024.y;
          _2032 = _2024.z;
          _2033 = _2024.w;
        }
        _2047 = (lerp(_1998, _2030, TEXCOORD_2.z));
        _2048 = (lerp(_1999, _2031, TEXCOORD_2.z));
        _2049 = (lerp(_2000, _2032, TEXCOORD_2.z));
        _2050 = (lerp(_2001, _2033, TEXCOORD_2.z));
      } else {
        _2047 = _1998;
        _2048 = _1999;
        _2049 = _2000;
        _2050 = _2001;
      }
      if (!((_841 & 33554432) == 0)) {
        int _2055 = _1899 & 128;
        if (!(_2055 == 0)) {
          _2061 = _splinePresetTextureIndex;
        } else {
          _2061 = (int)(_242);
        }
        int _2062 = _1899 & 127;
        if (((_2062 != 127)) && ((_2061 != -1))) {
          int2 _2075; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2061 < (uint)65000), _2061, 0)) + 0u))].GetDimensions(_2075.x, _2075.y);
          float4 _2084 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2061 < (uint)65000), _2061, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_2047 * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_2062) + (uint)(select((_2055 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_2075.y)))), 0.0f);
          _2090 = _2084.x;
          _2091 = _2084.y;
          _2092 = _2084.z;
          _2093 = _2084.w;
        } else {
          _2090 = 1.0f;
          _2091 = 1.0f;
          _2092 = 1.0f;
          _2093 = 1.0f;
        }
        float _2115 = (_1848 * _1848) * _2093;
        _2126 = (((_2090 * TEXCOORD_6.x) * _2115) * exp2(log2(float((uint)((uint)(((uint)((uint)(_1857)) >> 16) & 255))) * 0.003921568859368563f) * 2.200000047683716f));
        _2127 = (((_2091 * TEXCOORD_6.y) * _2115) * exp2(log2(float((uint)((uint)(((uint)((uint)(_1857)) >> 8) & 255))) * 0.003921568859368563f) * 2.200000047683716f));
        _2128 = (((_2092 * TEXCOORD_6.z) * _2115) * exp2(log2(float((uint)((uint)(_1857 & 255))) * 0.003921568859368563f) * 2.200000047683716f));
      } else {
        _2126 = TEXCOORD_6.x;
        _2127 = TEXCOORD_6.y;
        _2128 = TEXCOORD_6.z;
      }
      float _2129 = select(_1861, _1839, 1.0f);
      float _2147 = saturate(exp2(log2(select(_1863, 1.0f, _2050)) * select(_1861, 1.0f, _1839))) * _1970;
      _2155 = ((saturate(pow(_2047, _2129)) * _2126) * _2147);
      _2156 = ((saturate(exp2(log2(select(_1863, _2047, _2048)) * _2129)) * _2127) * _2147);
      _2157 = ((saturate(exp2(log2(select(_1863, _2047, _2049)) * _2129)) * _2128) * _2147);
      _2158 = _1839;
    } else {
      int _1565 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1576 = WaveReadLaneFirst(TEXCOORD_13.x);
      float _1585 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1576 < (uint)170000), _1576, 0)) + 0u))]._textureMaskScale.x);
      float _1586 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1576 < (uint)170000), _1576, 0)) + 0u))]._textureMaskScale.y);
      int _1587 = WaveReadLaneFirst(TEXCOORD_13.x);
      float _1595 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1587 < (uint)170000), _1587, 0)) + 0u))]._temperatureBrightness);
      int _1596 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1604 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1596 < (uint)170000), _1596, 0)) + 0u))]._temperatureColor);
      int _1605 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1614 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1622 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1614 < (uint)170000), _1614, 0)) + 0u))]._textureMask);
      int _1623 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1631 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1623 < (uint)170000), _1623, 0)) + 0u))]._textureEmissive);
      int _1632 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _1640 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1632 < (uint)170000), _1632, 0)) + 0u))]._temperatureColorSpline);
      int _1643 = WaveReadLaneFirst(_1631);
      float4 _1650 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1643 < (uint)65000), _1643, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1100, _1101), -1.0f, int2(0, 0));
      _75[0] = _1650.x;
      _75[1] = _1650.y;
      _75[2] = _1650.z;
      _75[3] = _1650.w;
      float _1660 = _75[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
      int _1661 = WaveReadLaneFirst(_1631);
      float4 _1668 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1661 < (uint)65000), _1661, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1102, _1103), -1.0f, int2(0, 0));
      _76[0] = _1668.x;
      _76[1] = _1668.y;
      _76[2] = _1668.z;
      _76[3] = _1668.w;
      float _1681 = (((_76[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _1660) * TEXCOORD_2.z) + _1660;
      int _1682 = _1640 & 128;
      if (!(_1682 == 0)) {
        _1688 = _splinePresetTextureIndex;
      } else {
        _1688 = (int)(_242);
      }
      int _1689 = _1640 & 127;
      if (((_1689 != 127)) && ((_1688 != -1))) {
        int2 _1702; __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1688 < (uint)65000), _1688, 0)) + 0u))].GetDimensions(_1702.x, _1702.y);
        float4 _1711 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1688 < (uint)65000), _1688, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_1681 * 0.9921875f) + 0.00390625f), ((float((uint)((uint)(_1689) + (uint)(select((_1682 != 0), 0, (int)(_241))))) + 0.5f) / float((uint)(uint)(_1702.y)))), 0.0f);
        _1717 = _1711.x;
        _1718 = _1711.y;
        _1719 = _1711.z;
        _1720 = _1711.w;
      } else {
        _1717 = 1.0f;
        _1718 = 1.0f;
        _1719 = 1.0f;
        _1720 = 1.0f;
      }
      float _1747 = saturate(exp2(log2(_1681) * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1605 < (uint)170000), _1605, 0)) + 0u))]._emissiveIntensityExponent))) * ((_1595 * _1595) * _1720);
      float _1750 = ((_1747 * TEXCOORD_6.x) * _1717) * exp2(log2(float((uint)((uint)(((uint)((uint)(_1604)) >> 16) & 255))) * 0.003921568859368563f) * 2.200000047683716f);
      float _1753 = ((_1747 * TEXCOORD_6.y) * _1718) * exp2(log2(float((uint)((uint)(((uint)((uint)(_1604)) >> 8) & 255))) * 0.003921568859368563f) * 2.200000047683716f);
      float _1756 = ((_1747 * TEXCOORD_6.z) * _1719) * exp2(log2(float((uint)((uint)(_1604 & 255))) * 0.003921568859368563f) * 2.200000047683716f);
      if ((_841 & 536871168) == 536871168) {
        if ((_1563) && (_1562)) {
          int _1764 = WaveReadLaneFirst(_1622);
          float4 _1771 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1764 < (uint)65000), _1764, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1100, _1101), -1.0f, int2(0, 0));
          _73[0] = _1771.x;
          _73[1] = _1771.y;
          _73[2] = _1771.z;
          _73[3] = _1771.w;
          float _1781 = _73[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
          int _1782 = WaveReadLaneFirst(_1622);
          float4 _1789 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1782 < (uint)65000), _1782, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2(_1102, _1103), -1.0f, int2(0, 0));
          _74[0] = _1789.x;
          _74[1] = _1789.y;
          _74[2] = _1789.z;
          _74[3] = _1789.w;
          _1826 = ((((_74[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _1781) * TEXCOORD_2.z) + _1781);
        } else {
          int _1814 = WaveReadLaneFirst(_1622);
          float4 _1821 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_1814 < (uint)65000), _1814, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2((((WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1565 < (uint)170000), _1565, 0)) + 0u))]._textureMaskOffset.x) + 0.5f) + (TEXCOORD_2.x / _1585)) - (0.5f / _1585)), (((WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1565 < (uint)170000), _1565, 0)) + 0u))]._textureMaskOffset.y) + 0.5f) + (TEXCOORD_2.y / _1586)) - (0.5f / _1586))));
          _1826 = min(_1821.x, _1821.w);
        }
        _2155 = (_1826 * _1750);
        _2156 = (_1826 * _1753);
        _2157 = (_1826 * _1756);
        _2158 = 1.0f;
      } else {
        _2155 = _1750;
        _2156 = _1753;
        _2157 = _1756;
        _2158 = 1.0f;
      }
    }
  } else {
    _2155 = 0.0f;
    _2156 = 0.0f;
    _2157 = 0.0f;
    _2158 = 1.0f;
  }
  if (!(TEXCOORD_4.w == 0.0f)) {
    float _2164 = abs(dot(float3(_211, _212, _213), float3(_188, _190, _192)));
    float _2169 = exp2(log2(select((TEXCOORD_4.w < 0.0f), (1.0f - _2164), _2164)) * abs(TEXCOORD_4.w));
    _2175 = (_2169 * _2155);
    _2176 = (_2169 * _2156);
    _2177 = (_2169 * _2157);
    _2178 = (_2169 * _1546);
  } else {
    _2175 = _2155;
    _2176 = _2156;
    _2177 = _2157;
    _2178 = _1546;
  }
  int _2179 = WaveReadLaneFirst(TEXCOORD_13.x);
  float _2187 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2179 < (uint)170000), _2179, 0)) + 0u))]._depthBiasReverseAlpha);
  if (!(_2187 == 0.0f)) {
    float _2194 = 1.0f - saturate(abs(_178 - SV_Position.w) / _2187);
    _2200 = (_2194 * _2175);
    _2201 = (_2194 * _2176);
    _2202 = (_2194 * _2177);
    _2203 = (_2194 * _2178);
  } else {
    _2200 = _2175;
    _2201 = _2176;
    _2202 = _2177;
    _2203 = _2178;
  }
  bool _2212 = (max((_2203 - max(_236, 0.0010000000474974513f)), (dot(float3(_2200, _2201, _2202), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f)) - max(((_236 + -0.004000000189989805f) * TEXCOORD_6.w), 9.999999747378752e-06f))) < 0.0f);
  if (_2212) discard;
  int _2213 = WaveReadLaneFirst(TEXCOORD_13.x);
  float _2221 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2213 < (uint)170000), _2213, 0)) + 0u))]._depthBiasAlpha);
  int _2240 = WaveReadLaneFirst(TEXCOORD_13.x);
  if (!(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2240 < (uint)170000), _2240, 0)) + 0u))]._useDepthOffsetTexture) == 0)) {
    int _2251 = WaveReadLaneFirst(TEXCOORD_13.x);
    int _2259 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2251 < (uint)170000), _2251, 0)) + 0u))]._depthOffsetTexture);
    if (_877) {
      int _2261 = WaveReadLaneFirst(_2259);
      float4 _2268 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2261 < (uint)65000), _2261, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1096, _1097));
      _2281 = _2268.x;
    } else {
      int _2271 = WaveReadLaneFirst(_2259);
      float4 _2278 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2271 < (uint)65000), _2271, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
      _2281 = _2278.x;
    }
    if (!(_832 == 0)) {
      int _2284 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _2292 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2284 < (uint)170000), _2284, 0)) + 0u))]._depthOffsetTexture);
      if (_877) {
        int _2294 = WaveReadLaneFirst(_2292);
        float4 _2301 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2294 < (uint)65000), _2294, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearWrap, float2(_1098, _1099));
        _2314 = _2301.x;
      } else {
        int _2304 = WaveReadLaneFirst(_2292);
        float4 _2311 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2304 < (uint)65000), _2304, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
        _2314 = _2311.x;
      }
      _2319 = (lerp(_2281, _2314, TEXCOORD_2.z));
    } else {
      _2319 = _2281;
    }
  } else {
    _2319 = 1.0f;
  }
  if (!((WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_842 < (uint)170000), _842, 0)) + 0u))]._materialFlags2) & 8) == 0)) {
    int _2323 = WaveReadLaneFirst(TEXCOORD_13.x);
    float _2332 = TEXCOORD_2.x + -0.5f;
    _2338 = (1.0f - (((_2332 * _2332) * 4.0f) * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2323 < (uint)170000), _2323, 0)) + 0u))]._depthOffsetCurvature)));
  } else {
    _2338 = 1.0f;
  }
  int _2339 = WaveReadLaneFirst(TEXCOORD_13.x);
  float _2351 = max(0.0f, _1543);
  float _2352 = max(0.0f, _1544);
  float _2353 = max(0.0f, _1545);
  float _2354 = saturate(_2203);
  float _2355 = max(0.0f, _2200);
  float _2356 = max(0.0f, _2201);
  float _2357 = max(0.0f, _2202);
  float _2358 = SV_Position.w - (((_2319 * TEXCOORD_25.w) * _2338) * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2339 < (uint)170000), _2339, 0)) + 0u))]._depthOffset));
  if (_179 == 393216) {
    bool _2362 = ((_178 - _2358) < 0.0f);
    if (_2362) discard;
  }
  [branch]
  if ((_useOverdrawCounter == 0) || ((!(_useOverdrawCounter == 0)) && (!(_pixelRate > 5.0f)))) {
    float _2435 = ((_2352 * 0.3395099937915802f) + (_2351 * 0.6131200194358826f)) + (_2353 * 0.047370001673698425f);
    float _2436 = ((_2352 * 0.9163600206375122f) + (_2351 * 0.07020000368356705f)) + (_2353 * 0.013450000435113907f);
    float _2437 = ((_2352 * 0.10958000272512436f) + (_2351 * 0.02061999961733818f)) + (_2353 * 0.8697999715805054f);
    float _2450 = ((_2356 * 0.3395099937915802f) + (_2355 * 0.6131200194358826f)) + (_2357 * 0.047370001673698425f);
    float _2451 = ((_2356 * 0.9163600206375122f) + (_2355 * 0.07020000368356705f)) + (_2357 * 0.013450000435113907f);
    float _2452 = ((_2356 * 0.10958000272512436f) + (_2355 * 0.02061999961733818f)) + (_2357 * 0.8697999715805054f);
    bool _2455 = (_234 == 0);
    if ((_2455) && ((abs(_2221) > 0.0010000000474974513f))) {
      float _2461 = abs(_178 - _2358) * _2221;
      if (_2221 < 0.0f) {
        _2472 = saturate(exp2(_2461 * 1.4426950216293335f));
      } else {
        _2472 = (1.0f - saturate(exp2(_2461 * -1.4426950216293335f)));
      }
      float _2476 = (pow(_2472, _2158));
      _2481 = (_2476 * _2450);
      _2482 = (_2476 * _2451);
      _2483 = (_2476 * _2452);
      _2484 = (_2472 * _2354);
    } else {
      _2481 = _2450;
      _2482 = _2451;
      _2483 = _2452;
      _2484 = _2354;
    }
    if (!_2455) {
      float _2519 = mad((_viewProjRelative[3].z), TEXCOORD_4.z, mad((_viewProjRelative[3].y), TEXCOORD_4.y, ((_viewProjRelative[3].x) * TEXCOORD_4.x))) + (_viewProjRelative[3].w);
      float _2540 = float((uint)((uint)(((int)(_frameNumber.x * 3)) & 1023)));
      float _2541 = float((int)(int(((((mad((_viewProjRelative[0].z), TEXCOORD_4.z, mad((_viewProjRelative[0].y), TEXCOORD_4.y, ((_viewProjRelative[0].x) * TEXCOORD_4.x))) + (_viewProjRelative[0].w)) / _2519) * 0.5f) + 0.5f) * _gpuParticleFroxelSize.x)));
      float _2542 = float((int)(int((0.5f - (((mad((_viewProjRelative[1].z), TEXCOORD_4.z, mad((_viewProjRelative[1].y), TEXCOORD_4.y, ((_viewProjRelative[1].x) * TEXCOORD_4.x))) + (_viewProjRelative[1].w)) / _2519) * 0.5f)) * _gpuParticleFroxelSize.y)));
      float _2553 = float((uint)((uint)(((int)(_frameNumber.x * 5)) & 1023)));
      float _2564 = float((uint)((uint)(((int)(_frameNumber.x * 7)) & 1023)));
      int _2583 = int(frac(frac(dot(float2(((_2540 * 32.665000915527344f) + _2541), ((_2540 * 11.8149995803833f) + _2542)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) + _2541);
      int _2584 = int(frac(frac(dot(float2(((_2553 * 32.665000915527344f) + _2541), ((_2553 * 11.8149995803833f) + _2542)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) + _2542);
      int _2585 = int((frac(frac(dot(float2(((_2564 * 32.665000915527344f) + _2541), ((_2564 * 11.8149995803833f) + _2542)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) + -0.5f) + max(0.0f, (log2((max(0.0f, sqrt(((TEXCOORD_4.y * TEXCOORD_4.y) + (TEXCOORD_4.x * TEXCOORD_4.x)) + (TEXCOORD_4.z * TEXCOORD_4.z))) * 0.04351966083049774f) + 1.0f) * 17.673004150390625f)));
      float _2586 = _2484 * 5000.0f;
      uint _2595; InterlockedAdd(__3__38__0__1__g_texFroxelMediaGatherR[int3(_2583, _2584, _2585)], (int)(uint(saturate(_2435) * _2586)), _2595);
      uint _2597; InterlockedAdd(__3__38__0__1__g_texFroxelMediaGatherG[int3(_2583, _2584, _2585)], (int)(uint(saturate(_2436) * _2586)), _2597);
      uint _2599; InterlockedAdd(__3__38__0__1__g_texFroxelMediaGatherB[int3(_2583, _2584, _2585)], (int)(uint(saturate(_2437) * _2586)), _2599);
      uint _2601; InterlockedAdd(__3__38__0__1__g_texFroxelMediaGatherA[int3(_2583, _2584, _2585)], (int)(uint(_2586)), _2601);
      if (true) discard;
    }
    float _2611 = max(0.0f, (log2((max(0.0f, _2358) * 0.04351966083049774f) + 1.0f) * 17.673004150390625f)) / _gpuParticleFroxelSize.z;
    if ((((TEXCOORD_13.y & 1) != 0)) && ((_2484 > 0.0f))) {
      if ((_sunDirection.y > 0.0f) || ((!(_sunDirection.y > 0.0f)) && (_sunDirection.y > _moonDirection.y))) {
        _2631 = _sunDirection.x;
        _2632 = _sunDirection.y;
        _2633 = _sunDirection.z;
      } else {
        _2631 = _moonDirection.x;
        _2632 = _moonDirection.y;
        _2633 = _moonDirection.z;
      }
      float _2645 = float((uint)((((int)(uint(1.0f / _invRenderTargetAndViewportSize.x)) * (int)(_97)) + _96) + ((uint)(((int)(_frameNumber.x * 71)) & 15))));
      float _2659 = _offScreenParticleViewportRatio * _offScreenParticleViewportRatio;
      float _2661 = (((frac((_2645 * 0.7548776268959045f) + 0.5f) * 2.0f) + -1.0f) * _invRenderTargetAndViewportSize.x) * _2659;
      float _2663 = (((frac((_2645 * 0.5698402523994446f) + 0.5f) * 2.0f) + -1.0f) * _invRenderTargetAndViewportSize.y) * _2659;
      float _2664 = saturate(_2435);
      float4 _2669 = __3__36__0__0__g_texFroxelLight.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_116, _117, _2611), 0.0f);
      int _2680 = WaveReadLaneFirst(TEXCOORD_13.x);
      int _2688 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2680 < (uint)170000), _2680, 0)) + 0u))]._materialFlags);
      if (!((int)(uint(TEXCOORD_15.x)) == 0)) {
        float _2693 = (_221 * _190) - (_220 * _192);
        float _2696 = (_219 * _192) - (_221 * _188);
        float _2699 = (_220 * _188) - (_219 * _190);
        float _2701 = rsqrt(dot(float3(_2693, _2696, _2699), float3(_2693, _2696, _2699)));
        float _2707 = (_228 * _192) - (_229 * _190);
        float _2710 = (_229 * _188) - (_227 * _192);
        float _2713 = (_227 * _190) - (_228 * _188);
        float _2715 = rsqrt(dot(float3(_2707, _2710, _2713), float3(_2707, _2710, _2713)));
        _2720 = _188;
        _2721 = _190;
        _2722 = _192;
        _2723 = (_2701 * _2693);
        _2724 = (_2701 * _2696);
        _2725 = (_2701 * _2699);
        _2726 = (_2715 * _2707);
        _2727 = (_2715 * _2710);
        _2728 = (_2715 * _2713);
      } else {
        _2720 = _211;
        _2721 = _212;
        _2722 = _213;
        _2723 = _219;
        _2724 = _220;
        _2725 = _221;
        _2726 = _227;
        _2727 = _228;
        _2728 = _229;
      }
      float _2729 = dot(float3(_2726, _2727, _2728), float3(_2631, _2632, _2633));
      float _2730 = dot(float3(_2723, _2724, _2725), float3(_2631, _2632, _2633));
      float _2731 = dot(float3(_2720, _2721, _2722), float3(_2631, _2632, _2633));
      if (!((_2688 & 67108864) == 0)) {
        if (((((!(_2729 == 0.0f))) || ((!(_2730 == 0.0f))))) || ((!(_2731 == 0.0f)))) {
          int _2741 = WaveReadLaneFirst(TEXCOORD_13.x);
          int _2750 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2741 < (uint)170000), _2741, 0)) + 0u))]._textureLightMap));
          float4 _2757 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2750 < (uint)65000), _2750, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
          if ((int)_2688 < (int)0) {
            int _2764 = WaveReadLaneFirst(TEXCOORD_13.x);
            int _2773 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2764 < (uint)170000), _2764, 0)) + 0u))]._textureLightMap2));
            float4 _2780 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2773 < (uint)65000), _2773, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1096, _1097));
            if (_831) {
              int _2785 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _2794 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2785 < (uint)170000), _2785, 0)) + 0u))]._textureLightMap));
              float4 _2801 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2794 < (uint)65000), _2794, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
              int _2805 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _2814 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2805 < (uint)170000), _2805, 0)) + 0u))]._textureLightMap2));
              float4 _2821 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2814 < (uint)65000), _2814, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
              _2844 = (lerp(_2757.x, _2801.x, TEXCOORD_2.z));
              _2845 = (lerp(_2757.y, _2801.y, TEXCOORD_2.z));
              _2846 = (lerp(_2757.z, _2801.z, TEXCOORD_2.z));
              _2847 = (lerp(_2780.x, _2821.x, TEXCOORD_2.z));
              _2848 = (lerp(_2780.y, _2821.y, TEXCOORD_2.z));
              _2849 = (lerp(_2780.z, _2821.z, TEXCOORD_2.z));
            } else {
              _2844 = _2757.x;
              _2845 = _2757.y;
              _2846 = _2757.z;
              _2847 = _2780.x;
              _2848 = _2780.y;
              _2849 = _2780.z;
            }
            _2931 = dot(float3(((saturate((_2729 * 0.5f) + 0.5f) * (_2844 - _2845)) + _2845), ((saturate((_2730 * 0.5f) + 0.5f) * (_2847 - _2846)) + _2846), ((saturate((_2731 * 0.5f) + 0.5f) * (_2849 - _2848)) + _2848)), float3(abs(_2729), abs(_2730), abs(_2731)));
          } else {
            if (_831) {
              int _2874 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _2883 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2874 < (uint)170000), _2874, 0)) + 0u))]._textureLightMap));
              float4 _2890 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_2883 < (uint)65000), _2883, 0)) + 0u))].Sample(__0__4__0__0__g_staticTrilinearClamp, float2(_1098, _1099));
              _2908 = (lerp(_2757.x, _2890.x, TEXCOORD_2.z));
              _2909 = (lerp(_2757.y, _2890.y, TEXCOORD_2.z));
              _2910 = (lerp(_2757.z, _2890.z, TEXCOORD_2.z));
              _2911 = (lerp(_2757.w, _2890.w, TEXCOORD_2.z));
            } else {
              _2908 = _2757.x;
              _2909 = _2757.y;
              _2910 = _2757.z;
              _2911 = _2757.w;
            }
            _2931 = dot(float3(((saturate((_2729 * 0.5f) + 0.5f) * (_2909 - _2908)) + _2908), ((saturate((_2730 * 0.5f) + 0.5f) * (_2910 - _2911)) + _2911), ((_2731 * 0.5f) + 0.5f)), float3(abs(_2729), abs(_2730), abs(_2731)));
          }
        } else {
          _2931 = 1.0f;
        }
      } else {
        _2931 = 1.0f;
      }
      if (!(_time.w > 22.0f)) {
        if (!(((_2484 < 0.10000000149011612f)) || ((_time.w < 2.0f)))) {
          int _2940 = WaveReadLaneFirst(TEXCOORD_13.x);
          if (WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2940 < (uint)170000), _2940, 0)) + 0u))]._rayMarchDistance) > 0.0f) {
            int _2951 = WaveReadLaneFirst(TEXCOORD_13.x);
            if (WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2951 < (uint)170000), _2951, 0)) + 0u))]._particleDensity) > 0.0f) {
              uint _2966 = uint((saturate(_2484 * 2.0f) * 3.0f) + 1.0f);
              int _2967 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _2976 = WaveReadLaneFirst(TEXCOORD_13.x);
              float _2986 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2976 < (uint)170000), _2976, 0)) + 0u))]._rayMarchDistance) / float((uint)_2966);
              int _2991 = WaveReadLaneFirst(TEXCOORD_13.x);
              int _3000 = WaveReadLaneFirst(TEXCOORD_13.x);
              bool _3014 = ((int)(_2966) == 0);
              if ((_831) && (((_2688 & 1) != 0))) {
                if (!_3014) {
                  float _3017 = exp2(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_3000 < (uint)170000), _3000, 0)) + 0u))]._rayMarchDistance) * 25.968509674072266f) * WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2991 < (uint)170000), _2991, 0)) + 0u))]._rayMarchDistance);
                  float _3020 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_2967 < (uint)170000), _2967, 0)) + 0u))]._particleDensity) * TEXCOORD_3.w;
                  _3024 = (_3017 * _2661);
                  _3025 = (_3017 * _2663);
                  _3026 = 0.0f;
                  _3027 = 0;
                  while(true) {
                    float _3028 = _3024 + (_2986 * (_2729 + _2661));
                    float _3029 = _3025 + (_2986 * (_2730 + _2663));
                    int _3030 = WaveReadLaneFirst(TEXCOORD_13.x);
                    int _3038 = WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_3030 < (uint)170000), _3030, 0)) + 0u))]._textureMask);
                    int _3043 = WaveReadLaneFirst(_3038);
                    float4 _3050 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_3043 < (uint)65000), _3043, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2((_3028 + _1100), (_3029 + _1101)), -1.0f, int2(0, 0));
                    _71[0] = _3050.x;
                    _71[1] = _3050.y;
                    _71[2] = _3050.z;
                    _71[3] = _3050.w;
                    float _3060 = _71[(select((_1097 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1096 >= 0.5f))))];
                    int _3063 = WaveReadLaneFirst(_3038);
                    float4 _3070 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_3063 < (uint)65000), _3063, 0)) + 0u))].SampleBias(__0__4__0__0__g_staticTrilinearWrap, float2((_3028 + _1102), (_3029 + _1103)), -1.0f, int2(0, 0));
                    _72[0] = _3070.x;
                    _72[1] = _3070.y;
                    _72[2] = _3070.z;
                    _72[3] = _3070.w;
                    float _3087 = (((_3020 * 10.0f) * _2986) * saturate(((((_72[(select((_1099 >= 0.5f), 2, 0) | ((int)(uint)((int)(_1098 >= 0.5f))))]) - _3060) * TEXCOORD_2.z) + _3060) * _3020)) + _3026;
                    if (!((_3027 + 1) == (int)(_2966))) {
                      _3024 = _3028;
                      _3025 = _3029;
                      _3026 = _3087;
                      _3027 = (_3027 + 1);
                      continue;
                    }
                    _3096 = (_3087 * -1.4426950216293335f);
                    break;
                  }
                } else {
                  _3096 = -0.0f;
                }
              } else {
                if (!_3014) {
                  _3096 = -0.0f;
                } else {
                  _3096 = -0.0f;
                }
              }
              _3100 = (exp2(_3096) * _2931);
            } else {
              _3100 = _2931;
            }
          } else {
            _3100 = _2931;
          }
        } else {
          _3100 = _2931;
        }
      } else {
        _3100 = _2931;
      }
      float _3101 = max(WaveReadLaneFirst(BindlessParameters_EffectLightMap_DisableDepth[((int)((uint)(select(((uint)_1547 < (uint)170000), _1547, 0)) + 0u))]._transmission), _3100);
      _3131 = _2664;
      _3132 = (-0.0f - ((_2664 * min(0.0f, (-0.0f - _2669.x))) * _3101));
      _3133 = (-0.0f - ((saturate(_2436) * min(0.0f, (-0.0f - _2669.y))) * _3101));
      _3134 = (-0.0f - ((saturate(_2437) * min(0.0f, (-0.0f - _2669.z))) * _3101));
    } else {
      if (!((TEXCOORD_13.y & 32768) == 0) | !((_gpuParticleRenderCommonFlags & 2) == 0)) {
        _3126 = (1.0f / min(1e+06f, max(9.999999747378752e-06f, _exposure0.x)));
      } else {
        _3126 = 1.0f;
      }
      _3131 = _2435;
      _3132 = (_3126 * _2435);
      _3133 = (_3126 * _2436);
      _3134 = (_3126 * _2437);
    }
    if (!((TEXCOORD_13.y & 1048576) == 0)) {
      float4 _3140 = __3__36__0__0__g_texFroxel.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_116, _117, _2611), 0.0f);
      float _3155 = (pow(_3140.w, _emissiveScatteringExponent));
      _3160 = (_3155 * _2481);
      _3161 = (_3155 * _2482);
      _3162 = (_3155 * _2483);
      _3163 = ((_3140.w * _3132) + _3140.x);
      _3164 = ((_3140.w * _3133) + _3140.y);
      _3165 = ((_3140.w * _3134) + _3140.z);
    } else {
      _3160 = _2481;
      _3161 = _2482;
      _3162 = _2483;
      _3163 = _3132;
      _3164 = _3133;
      _3165 = _3134;
    }
    bool _3171 = (((TEXCOORD_13.y & 8) != 0)) && ((_isAllowBlood == 0));
    float _3172 = _3131 * 0.4000000059604645f;
    float _3194 = ((((9.999999046325684f - (saturate(0.10000000149011612f / _exposure0.x) * 8.999999046325684f)) * ((20.0f - (saturate(_exposure0.x) * 19.0f)) / min(max(9.999999974752427e-07f, _exposure0.x), 10.0f))) + -1.0f) * TEXCOORD_14.x) + 1.0f;
    float _3201 = (_3194 * select(_3171, 0.0f, _3160)) + (select(_3171, _3172, _3163) * _2484);
    float _3202 = (_3194 * select(_3171, 0.0f, _3161)) + (select(_3171, _3172, _3164) * _2484);
    float _3203 = (_3194 * select(_3171, 0.0f, _3162)) + (select(_3171, _3172, _3165) * _2484);
    float _3207 = saturate(max(_2484, (dot(float3(_3201, _3202, _3203), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) * 0.10000000149011612f)));
    _3219 = max(1.0000000116860974e-07f, ((saturate((_3207 * _3207) * 3.0f) * ((_nearFarProj.x / _2358) - _174)) + _174));
    _3220 = 26.0f;
    _3221 = _3201;
    _3222 = _3202;
    _3223 = _3203;
    _3224 = _2484;
  } else {
    float _2378 = float((int)(int(_98 * 0.03999999910593033f))) * 0.5f;
    float _2379 = float((int)(int(_99 * 0.03999999910593033f))) * 0.5f;
    float _2396 = max(select((_2354 > 0.009999999776482582f), 1.0f, 0.0f), max(max(_2355, _2356), _2357));
    float _2415 = ((9.999999046325684f - (saturate(0.10000000149011612f / _exposure0.x) * 8.999999046325684f)) * ((20.0f - (saturate(_exposure0.x) * 19.0f)) / min(max(9.999999974752427e-07f, _exposure0.x), 10.0f))) * (select((_2396 > 0.0010000000474974513f), (_2396 * 0.10000000149011612f), 0.0f) * max(0.009999999776482582f, _2396));
    _3219 = 0.0f;
    _3220 = 0.0f;
    _3221 = ((_2415 * frac(sin(dot(float2(_2378, _2379), float2(127.0999984741211f, 311.70001220703125f))) * 43758.546875f)) + _2355);
    _3222 = ((_2415 * frac(sin(dot(float2(_2378, _2379), float2(269.5f, 183.3000030517578f))) * 43758.546875f)) + _2356);
    _3223 = ((_2415 * frac(sin(dot(float2(_2378, _2379), float2(419.20001220703125f, 371.8999938964844f))) * 43758.546875f)) + _2357);
    _3224 = _2354;
  }
  SV_Target.x = _3221;
  SV_Target.y = _3222;
  SV_Target.z = _3223;
  SV_Target.w = _3224;
  SV_Target_1.x = _3219;
  SV_Target_1.y = _3220;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}