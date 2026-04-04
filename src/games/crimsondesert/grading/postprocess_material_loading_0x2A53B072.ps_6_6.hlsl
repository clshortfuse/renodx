#include "../common.hlsl"
#include "./tonemap.hlsli"

struct PostProcessChromaticRadialBlurStruct {
  float _ratio;
  float _start;
  float _offsetR;
  float _offsetG;
  float _offsetB;
  float _rangeR;
  float _rangeG;
  float _rangeB;
  float _centerX;
  float _centerY;
};


Texture2D<float4> __3__36__0__0__g_sceneColor : register(t29, space36);

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

ConstantBuffer<PostProcessChromaticRadialBlurStruct> BindlessParameters_PostProcessChromaticRadialBlur[] : register(b0, space100);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  int _16 = WaveReadLaneFirst(_materialIndex);
  int _25 = WaveReadLaneFirst(_materialIndex);
  float _33 = WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_25 < (uint)170000), _25, 0)) + 0u))]._start);
  int _34 = WaveReadLaneFirst(_materialIndex);
  int _43 = WaveReadLaneFirst(_materialIndex);
  int _52 = WaveReadLaneFirst(_materialIndex);
  int _61 = WaveReadLaneFirst(_materialIndex);
  int _70 = WaveReadLaneFirst(_materialIndex);
  int _79 = WaveReadLaneFirst(_materialIndex);
  int _88 = WaveReadLaneFirst(_materialIndex);
  float _96 = WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_88 < (uint)170000), _88, 0)) + 0u))]._centerX);
  int _97 = WaveReadLaneFirst(_materialIndex);
  float _105 = WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_97 < (uint)170000), _97, 0)) + 0u))]._centerY);
  float _106 = TEXCOORD.x - _96;
  float _107 = TEXCOORD.y - _105;
  float _120 = saturate(((sqrt((_107 * _107) + (_106 * _106)) * 2.0f) - (_33 * 1.4142135381698608f)) / max(0.0010000000474974513f, ((1.0f - _33) * 1.4142135381698608f))) * WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_16 < (uint)170000), _16, 0)) + 0u))]._ratio);
  float _122;
  float _123;
  float _124;
  int _125;
  float _197;
  float _443;
  float _444;
  float _445;
  float _478;
  float _479;
  float _480;
  float _499;
  float _500;
  float _501;
  float _531;
  float _532;
  float _533;
  float _547;
  float _548;
  float _549;
  _122 = 0.0f;
  _123 = 0.0f;
  _124 = 0.0f;
  _125 = 0;
  while(true) {
    float _128 = float((int)(_125)) * 0.25f;
    float _130 = (1.0f - WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_61 < (uint)170000), _61, 0)) + 0u))]._offsetR)) + (_128 * WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_34 < (uint)170000), _34, 0)) + 0u))]._rangeR));
    float _133 = (1.0f - WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_70 < (uint)170000), _70, 0)) + 0u))]._offsetG)) + (_128 * WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_43 < (uint)170000), _43, 0)) + 0u))]._rangeG));
    float _136 = (1.0f - WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_79 < (uint)170000), _79, 0)) + 0u))]._offsetB)) + (_128 * WaveReadLaneFirst(BindlessParameters_PostProcessChromaticRadialBlur[((int)((uint)(select(((uint)_52 < (uint)170000), _52, 0)) + 0u))]._rangeB));
    float _139 = _96 - TEXCOORD.x;
    float _141 = _105 - TEXCOORD.y;
    float4 _165 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2(((_120 * ((_106 * _130) + _139)) + TEXCOORD.x), ((_120 * ((_107 * _130) + _141)) + TEXCOORD.y)));
    float _167 = _165.x + _122;
    float4 _168 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2(((_120 * ((_106 * _133) + _139)) + TEXCOORD.x), ((_120 * ((_107 * _133) + _141)) + TEXCOORD.y)));
    float _170 = _168.y + _123;
    float4 _171 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2(((_120 * ((_106 * _136) + _139)) + TEXCOORD.x), ((_120 * ((_107 * _136) + _141)) + TEXCOORD.y)));
    float _173 = _171.z + _124;
    bool __defer_121_546 = false;
    if (!((_125 + 1) == 5)) {
      _122 = _167;
      _123 = _170;
      _124 = _173;
      _125 = (_125 + 1);
      continue;
    }
    if (__defer_121_546) {
      SV_Target.x = _547;
      SV_Target.y = _548;
      SV_Target.z = _549;
      SV_Target.w = _197;
    }
    uint _184 = uint(SV_Position.y);
    if (_etcParams.y == 1.0f) {
      uint2 _191 = __3__36__0__0__g_stencil.Load(int3((int)(uint(SV_Position.x)), (int)(_184), 0));
      _197 = (float((uint)((uint)(_191.x & 127))) + 0.5f);
    } else {
      _197 = _postProcessParams.x;
    }
    bool _200 = (_localToneMappingParams.w > 0.0f);
    if (_200) {
      float _206 = _userImageAdjust.z * _exposure0.x;
      float _255 = exp2(log2(max(0.0f, (((_206 * max(0.0f, (((_167 * 0.3410100042819977f) - (_170 * 0.12435799837112427f)) - (_173 * 0.016652001067996025f)))) * _slopeParams.x) + _offsetParams.x))) * _powerParams.x);
      float _256 = exp2(log2(max(0.0f, (((max(0.0f, (((_170 * 0.22816000878810883f) - (_167 * 0.026052001863718033f)) - (_173 * 0.0021100000012665987f))) * _206) * _slopeParams.y) + _offsetParams.y))) * _powerParams.y);
      float _257 = exp2(log2(max(0.0f, (((max(0.0f, (((_167 * -0.004800000227987766f) - (_170 * 0.025793999433517456f)) + (_173 * 0.2305939942598343f))) * _206) * _slopeParams.z) + _offsetParams.z))) * _powerParams.z);
      float _259 = dot(float3(_255, _256, _257), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _266 = ((_255 - _259) * _powerParams.w) + _259;
      float _267 = ((_256 - _259) * _powerParams.w) + _259;
      float _268 = ((_257 - _259) * _powerParams.w) + _259;

      if (RENODX_TONE_MAP_TYPE != 0) {
        float3 untonemapped_bt709 = float3(_266, _267, _268);

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
          histogram_target_mean *= _206;
          histogram_mean *= _206;
        }

        float3 output_color = CustomTonemapSDR(untonemapped_bt709, mid_gray_scale, histogram_mean, histogram_target_mean);
        _478 = output_color.r;
        _479 = output_color.g;
        _480 = output_color.b;
      }
    else {

      float _287 = min(max(log2(mad(_268, 0.07922374457120895f, mad(_267, 0.07843360304832458f, (_266 * 0.8424790501594543f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
      float _288 = min(max(log2(mad(_268, 0.07916612923145294f, mad(_267, 0.8784686326980591f, (_266 * 0.04232824221253395f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
      float _289 = min(max(log2(mad(_268, 0.8791429996490479f, mad(_267, 0.07843360304832458f, (_266 * 0.042375653982162476f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
      float _290 = _287 * 0.06060606241226196f;
      float _291 = _288 * 0.06060606241226196f;
      float _292 = _289 * 0.06060606241226196f;
      float _293 = _290 * _290;
      float _294 = _291 * _291;
      float _295 = _292 * _292;
      float _341 = min(0.0f, (-0.0f - (((_287 * 0.007218181621283293f) + ((_293 * 0.42980000376701355f) + (((_293 * _293) * ((31.959999084472656f - (_287 * 2.432727336883545f)) + (_293 * 15.5f))) - ((_287 * 0.41624245047569275f) * _293)))) + -0.002319999970495701f)));
      float _342 = min(0.0f, (-0.0f - (((_288 * 0.007218181621283293f) + ((_294 * 0.42980000376701355f) + (((_294 * _294) * ((31.959999084472656f - (_288 * 2.432727336883545f)) + (_294 * 15.5f))) - ((_288 * 0.41624245047569275f) * _294)))) + -0.002319999970495701f)));
      float _343 = min(0.0f, (-0.0f - (((_289 * 0.007218181621283293f) + ((_295 * 0.42980000376701355f) + (((_295 * _295) * ((31.959999084472656f - (_289 * 2.432727336883545f)) + (_295 * 15.5f))) - ((_289 * 0.41624245047569275f) * _295)))) + -0.002319999970495701f)));
      float _344 = -0.0f - _341;
      float _345 = -0.0f - _342;
      float _346 = -0.0f - _343;
      float _347 = dot(float3(_344, _345, _346), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      float _353 = saturate((_exposure2.x + -3.0f) * 0.1428571492433548f) * 0.20000004768371582f;
      float _354 = _353 + 1.0f;
      float _385 = ((exp2(log2((_354 - (_353 * saturate((_341 * _341) * _344))) * _344)) - _347) * 1.399999976158142f) + _347;
      float _386 = ((exp2(log2((_354 - (saturate((_342 * _342) * _345) * _353)) * _345)) - _347) * 1.399999976158142f) + _347;
      float _387 = ((exp2(log2((_354 - (saturate((_343 * _343) * _346) * _353)) * _346)) - _347) * 1.399999976158142f) + _347;
      float _406 = saturate(exp2(log2(mad(_387, -0.09902974218130112f, mad(_386, -0.09802088141441345f, (_385 * 1.1968790292739868f)))) * 2.200000047683716f));
      float _407 = saturate(exp2(log2(mad(_387, -0.09896117448806763f, mad(_386, 1.1519031524658203f, (_385 * -0.052896853536367416f)))) * 2.200000047683716f));
      float _408 = saturate(exp2(log2(mad(_387, 1.151073694229126f, mad(_386, -0.09804344922304153f, (_385 * -0.05297163501381874f)))) * 2.200000047683716f));
      if (_etcParams.z == 0.0f) {
        float _414 = 1.0f - abs(_etcParams.w);
        float _418 = saturate(_etcParams.w);
        float _419 = (_414 * _406) + _418;
        float _420 = (_414 * _407) + _418;
        float _421 = (_414 * _408) + _418;
        if (_colorGradingParams.w > 0.0f) {
          float _426 = saturate(_colorGradingParams.w);
          _443 = (((max(0.0f, (1.0f - _419)) - _419) * _426) + _419);
          _444 = (((max(0.0f, (1.0f - _420)) - _420) * _426) + _420);
          _445 = (((max(0.0f, (1.0f - _421)) - _421) * _426) + _421);
        } else {
          _443 = _419;
          _444 = _420;
          _445 = _421;
        }
        float _451 = _userImageAdjust.y + 1.0f;
        float _455 = _userImageAdjust.x + 0.5f;
        float _467 = 2.200000047683716f / ((min(max(_userImageAdjust.w, -1.0f), 1.0f) * 0.800000011920929f) + 2.200000047683716f);
        _478 = exp2(log2(saturate(((_443 + -0.5f) * _451) + _455)) * _467);
        _479 = exp2(log2(saturate(((_444 + -0.5f) * _451) + _455)) * _467);
        _480 = exp2(log2(saturate(((_445 + -0.5f) * _451) + _455)) * _467);
      } else {
        _478 = _406;
        _479 = _407;
        _480 = _408;
      }
      }
    } else {
      _478 = (_167 * 0.20000000298023224f);
      _479 = (_170 * 0.20000000298023224f);
      _480 = (_173 * 0.20000000298023224f);
    }
    if (_etcParams.y > 1.0f) {
      float _489 = abs((TEXCOORD.x * 2.0f) + -1.0f);
      float _490 = abs((TEXCOORD.y * 2.0f) + -1.0f);
      float _494 = saturate(1.0f - (dot(float2(_489, _490), float2(_489, _490)) * saturate(_etcParams.y + -1.0f)));
      _499 = (_494 * _478);
      _500 = (_494 * _479);
      _501 = (_494 * _480);
    } else {
      _499 = _478;
      _500 = _479;
      _501 = _480;
    }
    if ((_200) && ((_etcParams.z > 0.0f))) {
      _531 = select((_499 <= 0.0031308000907301903f), (_499 * 12.920000076293945f), (((pow(_499, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
      _532 = select((_500 <= 0.0031308000907301903f), (_500 * 12.920000076293945f), (((pow(_500, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
      _533 = select((_501 <= 0.0031308000907301903f), (_501 * 12.920000076293945f), (((pow(_501, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    } else {
      _531 = _499;
      _532 = _500;
      _533 = _501;
    }
    if (!(!(_etcParams.y >= 1.0f))) {
      float _538 = float((uint)_184);
      if (!(_538 < _viewDir.w)) {
        if (!(_538 >= (_screenSizeAndInvSize.y - _viewDir.w))) {
          _547 = _531;
          _548 = _532;
          _549 = _533;
        } else {
          _547 = 0.0f;
          _548 = 0.0f;
          _549 = 0.0f;
        }
      } else {
        _547 = 0.0f;
        _548 = 0.0f;
        _549 = 0.0f;
      }
    } else {
      _547 = _531;
      _548 = _532;
      _549 = _533;
    }
    SV_Target.x = _547;
    SV_Target.y = _548;
    SV_Target.z = _549;
    SV_Target.w = _197;
    break;
  }
  return SV_Target;
}