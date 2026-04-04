#include "../common.hlsl"
#include "./tonemap.hlsli"

struct PostProcessWorldLoadingStruct {
  float _radius;
  float _squareSize;
  float _maskThreshold;
  float _ringRatio;
  float _cubeSpaceGradientRatio;
  float _cubeSpaceEffectRatio;
  float _depthOuterMaskRadius;
  uint _invertDepthMask;
  float _depthIntensity;
  float _depthContrast;
  float _voronoiDotDensity;
  float _voronoiMovementSpeed;
  float _voronoiOffset;
  float3 _voronoiScrollSpeed;
  float _voronoiDotThreshold;
  float _voronoiDotRatio;
  float _rippleIntensity;
  float _rippleWidth;
  float _rippleCount;
  float _rippleContrast;
  float _rippleSpeed;
  float3 _ripplePosOffset;
  uint _noiseTex;
  float _bigRippleIntensity;
  float _bigRippleWidth;
  float _bigRipplePhaseOffset;
  float _bigRippleSpeed;
  float _bigRippleDistortionIntensity;
  float _bigRippleContrast;
  float _starburstIntensity;
  float _vignetteIntensity;
  uint _excludePlayer;
  float _ppWorldLoadingRatio;
};


Texture2D<float4> __3__36__0__0__g_sceneColor : register(t29, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t30, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t26, space36);

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

#if 0
cbuffer __3__35__0__0__ExposureConstantBuffer : register(b31, space35) {
  float4 _exposure0 : packoffset(c000.x);
  float4 _exposure1 : packoffset(c001.x);
  float4 _exposure2 : packoffset(c002.x);
  float4 _exposure3 : packoffset(c003.x);
  float4 _exposure4 : packoffset(c004.x);
};

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _postProcessParams : packoffset(c000.x);
  float4 _postProcessParams1 : packoffset(c001.x);
  float4 _toneMapParams0 : packoffset(c002.x);
  float4 _toneMapParams1 : packoffset(c003.x);
  float4 _colorGradingParams : packoffset(c004.x);
  float4 _colorCorrectionParams : packoffset(c005.x);
  float4 _localToneMappingParams : packoffset(c006.x);
  float4 _etcParams : packoffset(c007.x);
  float4 _userImageAdjust : packoffset(c008.x);
  float4 _slopeParams : packoffset(c009.x);
  float4 _offsetParams : packoffset(c010.x);
  float4 _powerParams : packoffset(c011.x);
};
#endif

cbuffer __3__1__0__0__PostProcessMaterialIndex : register(b2, space1) {
  int _materialIndex : packoffset(c000.x);
  int _passIndex : packoffset(c000.y);
};

cbuffer GlobalMaterialGlobalParameter_Common : register(b50, space98) {
  float3 _mainPosition : packoffset(c000.x);
  float3 _mainPositionPrev : packoffset(c001.x);
  float3 _targetFocusPosition : packoffset(c002.x);
  float _hpPercentage : packoffset(c002.w);
  uint _skinnedMeshNoiseTexture : packoffset(c003.x);
  float _highLightForVision : packoffset(c003.y);
  float _characterHighlight : packoffset(c003.z);
  uint _specialModeType : packoffset(c003.w);
  float _visionRadius : packoffset(c004.x);
  float _interactionTime : packoffset(c004.y);
  float3 _questGuideWorldPosition : packoffset(c005.x);
  float3 _detectModeUp : packoffset(c006.x);
  float3 _detectModeLook : packoffset(c007.x);
  float3 _detectModePosition : packoffset(c008.x);
  float2 _detectModeLightProfileOffset : packoffset(c009.x);
  uint _detectModeLightProfileIndex : packoffset(c009.z);
  float _detectModeAngle : packoffset(c009.w);
  float _detectModeRadius : packoffset(c010.x);
  uint _useHatMode : packoffset(c010.y);
  uint4 _oreVeinBitMask : packoffset(c011.x);
  uint _oreVeinDissolveIndex : packoffset(c012.x);
  float _oreVeinDissolveRatio : packoffset(c012.y);
  float _hideStateRatio : packoffset(c012.z);
  float3 _hazardAlertPosition : packoffset(c013.x);
  float _wantedRegionRatio : packoffset(c013.w);
  float _wantedRegionOpacity : packoffset(c014.x);
  float _wantedRegionRadius : packoffset(c014.y);
  float3 _wantedRegionPosition : packoffset(c015.x);
  float _elementActivateDuration : packoffset(c015.w);
  float _temperatureWarning : packoffset(c016.x);
  float _electrocutionWarning : packoffset(c016.y);
  float _fleeCount : packoffset(c016.z);
  float _followLearning : packoffset(c016.w);
  float4 _enemyAlert1 : packoffset(c017.x);
  float4 _enemyAlert2 : packoffset(c018.x);
  float _pullingEffectAttractionOffRadius : packoffset(c019.x);
  float _pullingEffectPushFromCharacter : packoffset(c019.y);
  float _pullingEffectPushScale : packoffset(c019.z);
  float _pullingEffectAttractionScale : packoffset(c019.w);
  float _pullingEffectExternalScale : packoffset(c020.x);
  float _pullingEffectVectorFieldScale : packoffset(c020.y);
  float _pullingEffectHeightOffset : packoffset(c020.z);
  float _housingPreviewState : packoffset(c020.w);
  float _customEffectOpacity : packoffset(c021.x);
  uint _renderPassInteraction : packoffset(c021.y);
  uint _renderPassSelfPlayer : packoffset(c021.z);
  uint _renderPassEnemy : packoffset(c021.w);
  uint _renderPassTargetFocus : packoffset(c022.x);
  uint _renderPassLearning : packoffset(c022.y);
  uint _renderPassTest : packoffset(c022.z);
  uint _renderPassDetectObjective : packoffset(c022.w);
  uint _renderPassDetectItem : packoffset(c023.x);
  uint _renderPassDetectGimmick : packoffset(c023.y);
  uint _renderPassDetectRemoteCatch : packoffset(c023.z);
  uint _renderPassDetectPickedRemoteCatch : packoffset(c023.w);
  uint _renderPassDetectLift : packoffset(c024.x);
  uint _renderPassKnowledgeNPC : packoffset(c024.y);
  uint _renderPassKnowledgeGain : packoffset(c024.z);
  uint _renderPassAnamorphicMural : packoffset(c024.w);
  uint _renderPassMemoryBackground : packoffset(c025.x);
  uint _renderPassMemory : packoffset(c025.y);
  uint _renderPassEnemyBoss : packoffset(c025.z);
  uint _renderPassAimHighlight : packoffset(c025.w);
  float4 _aimHighlightPosition : packoffset(c026.x);
  uint _renderPassNPCGhost : packoffset(c027.x);
  uint _renderPassHousing : packoffset(c027.y);
};

ConstantBuffer<PostProcessWorldLoadingStruct> BindlessParameters_PostProcessWorldLoading[] : register(b0, space100);

SamplerState __0__4__0__0__g_staticBilinearWrap : register(s0, space4);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  int __loop_jump_target = -1;
  float4 _24 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearWrap, float2(TEXCOORD.x, TEXCOORD.y));
  float _28 = __3__36__0__0__g_depth.Sample(__0__4__0__0__g_staticBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _31 = (TEXCOORD.x * 2.0f) + -1.0f;
  float _32 = TEXCOORD.y * 2.0f;
  float _33 = 1.0f - _32;
  float _34 = max(1.0000000116860974e-07f, _28.x);
  float _70 = mad((_invViewProj[3].z), _34, mad((_invViewProj[3].y), _33, ((_invViewProj[3].x) * _31))) + (_invViewProj[3].w);
  float _71 = (mad((_invViewProj[0].z), _34, mad((_invViewProj[0].y), _33, ((_invViewProj[0].x) * _31))) + (_invViewProj[0].w)) / _70;
  float _72 = (mad((_invViewProj[1].z), _34, mad((_invViewProj[1].y), _33, ((_invViewProj[1].x) * _31))) + (_invViewProj[1].w)) / _70;
  float _73 = (mad((_invViewProj[2].z), _34, mad((_invViewProj[2].y), _33, ((_invViewProj[2].x) * _31))) + (_invViewProj[2].w)) / _70;
  int _74 = WaveReadLaneFirst(_materialIndex);
  float _82 = WaveReadLaneFirst(BindlessParameters_PostProcessWorldLoading[((int)((uint)(select(((uint)_74 < (uint)170000), _74, 0)) + 0u))]._squareSize);
  float _83 = _82 * _71;
  float _84 = _82 * _72;
  float _85 = _82 * _73;
  float _86 = floor(_83);
  float _87 = floor(_84);
  float _88 = floor(_85);
  float _90;
  float _91;
  float _92;
  float _93;
  int _94;
  float _99;
  float _100;
  float _101;
  float _102;
  int _103;
  float _108;
  float _109;
  float _110;
  float _111;
  int _112;
  float _264;
  float _510;
  float _511;
  float _512;
  float _545;
  float _546;
  float _547;
  float _563;
  float _564;
  float _565;
  float _595;
  float _596;
  float _597;
  float _611;
  float _612;
  float _613;
  _90 = 10.0f;
  _91 = 0.0f;
  _92 = 0.0f;
  _93 = 0.0f;
  _94 = -1;
  while(true) {
    _99 = _90;
    _100 = _91;
    _101 = _92;
    _102 = _93;
    _103 = -1;
    while(true) {
      _108 = _99;
      _109 = _100;
      _110 = _101;
      _111 = _102;
      _112 = -1;
      while(true) {
        float _113 = float((int)(_112));
        float _114 = float((int)(_103));
        float _115 = float((int)(_94));
        float _119 = sin(_113 + _86);
        float _120 = sin(_114 + _87);
        float _121 = sin(_115 + _88);
        float _136 = _time.x * 0.20000000298023224f;
        float _143 = sin(_136 * frac(sin(dot(float3(_119, _120, _121), float3(12.98900032043457f, 78.23300170898438f, 37.71900177001953f))) * 143758.546875f)) + _113;
        float _144 = sin(_136 * frac(sin(dot(float3(_119, _120, _121), float3(39.34600067138672f, 11.135000228881836f, 83.15499877929688f))) * 143758.546875f)) + _114;
        float _145 = sin(_136 * frac(sin(dot(float3(_119, _120, _121), float3(73.15599822998047f, 52.23500061035156f, 9.151000022888184f))) * 143758.546875f)) + _115;
        float _156 = max(abs((_86 - _83) + _143), max(abs((_87 - _84) + _144), abs((_88 - _85) + _145)));
        bool _157 = (_156 < _108);
        float _158 = select(_157, _156, _108);
        float _159 = select(_157, _143, _109);
        float _160 = select(_157, _144, _110);
        float _161 = select(_157, _145, _111);
        bool __defer_107_610 = false;
        if (!((_112 + 1) == 2)) {
          _108 = _158;
          _109 = _159;
          _110 = _160;
          _111 = _161;
          _112 = (_112 + 1);
          continue;
        }
        if (__defer_107_610) {
          SV_Target.x = _611;
          SV_Target.y = _612;
          SV_Target.z = _613;
          SV_Target.w = _264;
        }
        bool __defer_104_610 = false;
        if (!((_103 + 1) == 2)) {
          _99 = _158;
          _100 = _159;
          _101 = _160;
          _102 = _161;
          _103 = (_103 + 1);
          __loop_jump_target = 98;
          break;
        }
        if (__defer_104_610) {
          SV_Target.x = _611;
          SV_Target.y = _612;
          SV_Target.z = _613;
          SV_Target.w = _264;
        }
        bool __defer_95_610 = false;
        if (!((_94 + 1) == 2)) {
          _90 = _158;
          _91 = _159;
          _92 = _160;
          _93 = _161;
          _94 = (_94 + 1);
          __loop_jump_target = 89;
          break;
        }
        if (__defer_95_610) {
          SV_Target.x = _611;
          SV_Target.y = _612;
          SV_Target.z = _613;
          SV_Target.w = _264;
        }
        int _177 = WaveReadLaneFirst(_materialIndex);
        float _190 = ((_159 + _86) / _82) - _mainPosition.x;
        float _191 = ((_160 + _87) / _82) - _mainPosition.y;
        float _192 = ((_161 + _88) / _82) - _mainPosition.z;
        int _203 = WaveReadLaneFirst(_materialIndex);
        float _217 = _71 - _mainPosition.x;
        float _218 = _72 - _mainPosition.y;
        float _219 = _73 - _mainPosition.z;
        int _234 = WaveReadLaneFirst(_materialIndex);
        float _244 = ((1.0f - saturate(exp2(log2(abs(((1.0f - ((1.0f / max(9.999999747378752e-06f, (WaveReadLaneFirst(BindlessParameters_PostProcessWorldLoading[((int)((uint)(select(((uint)_203 < (uint)170000), _203, 0)) + 0u))]._radius) * 0.8333333134651184f))) * sqrt(dot(float3(_217, _218, _219), float3(_217, _218, _219))))) * 2.500000238418579f) + -0.5f) * 0.6666666865348816f)))) * (1.0f / max(0.0010000000474974513f, _exposure0.x))) * WaveReadLaneFirst(BindlessParameters_PostProcessWorldLoading[((int)((uint)(select(((uint)_234 < (uint)170000), _234, 0)) + 0u))]._ringRatio);
        float _248 = (_244 * 0.800000011920929f) + _24.x;
        float _249 = (_244 * 0.4000000059604645f) + _24.y;
        float _250 = (_244 * 0.20000000298023224f) + _24.z;
        uint _251 = uint(SV_Position.y);
        if (_etcParams.y == 1.0f) {
          uint2 _258 = __3__36__0__0__g_stencil.Load(int3((int)(uint(SV_Position.x)), (int)(_251), 0));
          _264 = (float((uint)((uint)(_258.x & 127))) + 0.5f);
        } else {
          _264 = saturate((_158 + 1.0f) - ((1.0f - ((1.0f / max(9.999999747378752e-06f, WaveReadLaneFirst(BindlessParameters_PostProcessWorldLoading[((int)((uint)(select(((uint)_177 < (uint)170000), _177, 0)) + 0u))]._radius))) * sqrt(dot(float3(_190, _191, _192), float3(_190, _191, _192))))) * 1.470588207244873f));
        }
        bool _267 = (_localToneMappingParams.w > 0.0f);
        if (_267) {
          float _273 = _userImageAdjust.z * _exposure0.x;
          float _322 = exp2(log2(max(0.0f, (((_273 * max(0.0f, (((_248 * 1.705049991607666f) - (_249 * 0.6217899918556213f)) - (_250 * 0.08325999975204468f)))) * _slopeParams.x) + _offsetParams.x))) * _powerParams.x);
          float _323 = exp2(log2(max(0.0f, (((max(0.0f, (((_249 * 1.1407999992370605f) - (_248 * 0.13026000559329987f)) - (_250 * 0.01054999977350235f))) * _273) * _slopeParams.y) + _offsetParams.y))) * _powerParams.y);
          float _324 = exp2(log2(max(0.0f, (((max(0.0f, (((_248 * -0.024000000208616257f) - (_249 * 0.12896999716758728f)) + (_250 * 1.1529699563980103f))) * _273) * _slopeParams.z) + _offsetParams.z))) * _powerParams.z);
          float _326 = dot(float3(_322, _323, _324), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
          float _333 = ((_322 - _326) * _powerParams.w) + _326;
          float _334 = ((_323 - _326) * _powerParams.w) + _326;
          float _335 = ((_324 - _326) * _powerParams.w) + _326;

          if (RENODX_TONE_MAP_TYPE != 0) {
            float3 untonemapped_bt709 = float3(_333, _334, _335);

            const float mid_gray = 0.18f;
            float mid_gray_adjusted = SDRToneMap(mid_gray).x;
            float mid_gray_scale = mid_gray_adjusted / mid_gray;
            // untonemapped_bt709 *= (mid_gray_adjusted / mid_gray);

            float histogram_mean = 0.18f;
            float histogram_target_mean = 0.18f;
            float histogram_target = 0.18f;
            if (IMPROVED_AUTO_EXPOSURE == 2) {
              if (_exposure2.w > 0.0f) {
                histogram_mean = _exposure2.w;
              } else if (_exposure2.z > 0.0f) {
                histogram_mean = _exposure2.z;
              } else {
                histogram_mean = _exposure2.x;
              }

              if (_exposure2.z > 0.0f) {
                histogram_target_mean = _exposure2.z;
              } else {
                histogram_target_mean = histogram_mean;
              }
            }

            float3 output_color = CustomTonemapSDR(untonemapped_bt709, mid_gray_scale, histogram_mean * _273, histogram_target_mean * _273);
            _545 = output_color.r;
            _546 = output_color.g;
            _547 = output_color.b;
          }
    else {

          float _354 = min(max(log2(mad(_335, 0.07922374457120895f, mad(_334, 0.07843360304832458f, (_333 * 0.8424790501594543f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
          float _355 = min(max(log2(mad(_335, 0.07916612923145294f, mad(_334, 0.8784686326980591f, (_333 * 0.04232824221253395f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
          float _356 = min(max(log2(mad(_335, 0.8791429996490479f, mad(_334, 0.07843360304832458f, (_333 * 0.042375653982162476f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
          float _357 = _354 * 0.06060606241226196f;
          float _358 = _355 * 0.06060606241226196f;
          float _359 = _356 * 0.06060606241226196f;
          float _360 = _357 * _357;
          float _361 = _358 * _358;
          float _362 = _359 * _359;
          float _408 = min(0.0f, (-0.0f - (((_354 * 0.007218181621283293f) + ((_360 * 0.42980000376701355f) + (((_360 * _360) * ((31.959999084472656f - (_354 * 2.432727336883545f)) + (_360 * 15.5f))) - ((_354 * 0.41624245047569275f) * _360)))) + -0.002319999970495701f)));
          float _409 = min(0.0f, (-0.0f - (((_355 * 0.007218181621283293f) + ((_361 * 0.42980000376701355f) + (((_361 * _361) * ((31.959999084472656f - (_355 * 2.432727336883545f)) + (_361 * 15.5f))) - ((_355 * 0.41624245047569275f) * _361)))) + -0.002319999970495701f)));
          float _410 = min(0.0f, (-0.0f - (((_356 * 0.007218181621283293f) + ((_362 * 0.42980000376701355f) + (((_362 * _362) * ((31.959999084472656f - (_356 * 2.432727336883545f)) + (_362 * 15.5f))) - ((_356 * 0.41624245047569275f) * _362)))) + -0.002319999970495701f)));
          float _411 = -0.0f - _408;
          float _412 = -0.0f - _409;
          float _413 = -0.0f - _410;
          float _414 = dot(float3(_411, _412, _413), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
          float _420 = saturate((_exposure2.x + -3.0f) * 0.1428571492433548f) * 0.20000004768371582f;
          float _421 = _420 + 1.0f;
          float _452 = ((exp2(log2((_421 - (_420 * saturate((_408 * _408) * _411))) * _411)) - _414) * 1.399999976158142f) + _414;
          float _453 = ((exp2(log2((_421 - (saturate((_409 * _409) * _412) * _420)) * _412)) - _414) * 1.399999976158142f) + _414;
          float _454 = ((exp2(log2((_421 - (saturate((_410 * _410) * _413) * _420)) * _413)) - _414) * 1.399999976158142f) + _414;
          float _473 = saturate(exp2(log2(mad(_454, -0.09902974218130112f, mad(_453, -0.09802088141441345f, (_452 * 1.1968790292739868f)))) * 2.200000047683716f));
          float _474 = saturate(exp2(log2(mad(_454, -0.09896117448806763f, mad(_453, 1.1519031524658203f, (_452 * -0.052896853536367416f)))) * 2.200000047683716f));
          float _475 = saturate(exp2(log2(mad(_454, 1.151073694229126f, mad(_453, -0.09804344922304153f, (_452 * -0.05297163501381874f)))) * 2.200000047683716f));
          if (_etcParams.z == 0.0f) {
            float _481 = 1.0f - abs(_etcParams.w);
            float _485 = saturate(_etcParams.w);
            float _486 = (_481 * _473) + _485;
            float _487 = (_481 * _474) + _485;
            float _488 = (_481 * _475) + _485;
            if (_colorGradingParams.w > 0.0f) {
              float _493 = saturate(_colorGradingParams.w);
              _510 = (((max(0.0f, (1.0f - _486)) - _486) * _493) + _486);
              _511 = (((max(0.0f, (1.0f - _487)) - _487) * _493) + _487);
              _512 = (((max(0.0f, (1.0f - _488)) - _488) * _493) + _488);
            } else {
              _510 = _486;
              _511 = _487;
              _512 = _488;
            }
            float _518 = _userImageAdjust.y + 1.0f;
            float _522 = _userImageAdjust.x + 0.5f;
            float _534 = 2.200000047683716f / ((min(max(_userImageAdjust.w, -1.0f), 1.0f) * 0.800000011920929f) + 2.200000047683716f);
            _545 = exp2(log2(saturate(((_510 + -0.5f) * _518) + _522)) * _534);
            _546 = exp2(log2(saturate(((_511 + -0.5f) * _518) + _522)) * _534);
            _547 = exp2(log2(saturate(((_512 + -0.5f) * _518) + _522)) * _534);
          } else {
            _545 = _473;
            _546 = _474;
            _547 = _475;
          }
          }
        } else {
          _545 = _248;
          _546 = _249;
          _547 = _250;
        }
        
        if (_etcParams.y > 1.0f) {
          float _553 = abs(_31);
          float _554 = abs(_32 + -1.0f);
          float _558 = saturate(1.0f - (dot(float2(_553, _554), float2(_553, _554)) * saturate(_etcParams.y + -1.0f)));
          _563 = (_558 * _545);
          _564 = (_558 * _546);
          _565 = (_558 * _547);
        } else {
          _563 = _545;
          _564 = _546;
          _565 = _547;
        }
        if ((_267) && ((_etcParams.z > 0.0f))) {
          _595 = select((_563 <= 0.0031308000907301903f), (_563 * 12.920000076293945f), (((pow(_563, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
          _596 = select((_564 <= 0.0031308000907301903f), (_564 * 12.920000076293945f), (((pow(_564, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
          _597 = select((_565 <= 0.0031308000907301903f), (_565 * 12.920000076293945f), (((pow(_565, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
        } else {
          _595 = _563;
          _596 = _564;
          _597 = _565;
        }
        if (!(!(_etcParams.y >= 1.0f))) {
          float _602 = float((uint)_251);
          if (!(_602 < _viewDir.w)) {
            if (!(_602 >= (_screenSizeAndInvSize.y - _viewDir.w))) {
              _611 = _595;
              _612 = _596;
              _613 = _597;
            } else {
              _611 = 0.0f;
              _612 = 0.0f;
              _613 = 0.0f;
            }
          } else {
            _611 = 0.0f;
            _612 = 0.0f;
            _613 = 0.0f;
          }
        } else {
          _611 = _595;
          _612 = _596;
          _613 = _597;
        }
        SV_Target.x = _611;
        SV_Target.y = _612;
        SV_Target.z = _613;
        SV_Target.w = _264;
        break;
      }
      if (__loop_jump_target == 98) {
        __loop_jump_target = -1;
        continue;
      }
      if (__loop_jump_target != -1) {
        break;
      }
      break;
    }
    if (__loop_jump_target == 89) {
      __loop_jump_target = -1;
      continue;
    }
    if (__loop_jump_target != -1) {
      break;
    }
    break;
  }
  return SV_Target;
}