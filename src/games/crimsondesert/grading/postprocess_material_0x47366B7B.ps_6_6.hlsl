#include "../common.hlsl"
#include "./tonemap.hlsli"

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

cbuffer __3__1__0__0__PostProcessSizeConstant : register(b1, space1) {
  float4 _srcTargetSizeAndInv : packoffset(c000.x);
  float4 _destTargetSizAndInv : packoffset(c001.x);
};

cbuffer __3__1__0__0__PostProcessMaterialIndex : register(b2, space1) {
  int _materialIndex : packoffset(c000.x);
  int _passIndex : packoffset(c000.y);
};

struct PostProcessFisheye_DistortionStruct {
  float _maxPower;
};

ConstantBuffer<PostProcessFisheye_DistortionStruct> BindlessParameters_PostProcessFisheye_Distortion[] : register(b0, space100);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _29 = (_destTargetSizAndInv.x * TEXCOORD.x) / _srcTargetSizeAndInv.x;
  float _30 = (_destTargetSizAndInv.y * (1.0f - TEXCOORD.y)) / _srcTargetSizeAndInv.x;
  float _31 = _srcTargetSizeAndInv.x / _srcTargetSizeAndInv.y;
  float _32 = 0.5f / _31;
  float _33 = _29 + -0.5f;
  float _34 = _30 - _32;
  float _35 = dot(float2(_33, _34), float2(_33, _34));
  float _36 = sqrt(_35);
  int _37 = WaveReadLaneFirst(_materialIndex);
  float _45 = WaveReadLaneFirst(BindlessParameters_PostProcessFisheye_Distortion[((uint)((int)(select(((uint)_37 < (uint)170000), _37, 0)) + 0u))]._maxPower);
  bool _46 = (_45 > 0.0f);
  float _54;
  float _92;
  float _93;
  float _115;
  float _361;
  float _362;
  float _363;
  float _396;
  float _397;
  float _398;
  float _417;
  float _418;
  float _419;
  float _449;
  float _450;
  float _451;
  float _465;
  float _466;
  float _467;
  if (_46) {
    _54 = sqrt(dot(float2(0.5f, _32), float2(0.5f, _32)));
  } else {
    if (!(_31 < 1.0f)) {
      _54 = _32;
    } else {
      _54 = 0.5f;
    }
  }
  if (_46) {
    float _56 = rsqrt(_35);
    float _58 = tan(_45 * _36);
    float _66 = tan(_54 * _45);
    _92 = (((((_54 * _33) * _56) * _58) / _66) + 0.5f);
    _93 = (((((_54 * _34) * _56) * _58) / _66) + _32);
  } else {
    if (_45 < 0.0f) {
      float _74 = rsqrt(_35);
      float _77 = atan((_45 * _36) * -10.0f);
      float _86 = atan((_45 * -10.0f) * _54);
      _92 = (((((_54 * _33) * _74) * _77) / _86) + 0.5f);
      _93 = (((((_54 * _34) * _74) * _77) / _86) + _32);
    } else {
      _92 = _29;
      _93 = _30;
    }
  }
  float4 _98 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticPointClamp, float2(_92, (1.0f - (_93 * _31))));
  uint _102 = uint(SV_Position.y);
  if (_etcParams.y == 1.0f) {
    uint2 _109 = __3__36__0__0__g_stencil.Load(int3((uint)(uint(SV_Position.x)), _102, 0));
    _115 = (float((uint)((int)(_109.x & 127))) + 0.5f);
  } else {
    _115 = 1.0f;
  }
  bool _118 = (_localToneMappingParams.w > 0.0f);
  if (_118) {
    float _124 = _userImageAdjust.z * _exposure0.x;
    float _173 = exp2(log2(max(0.0f, (((_124 * max(0.0f, (((_98.x * 1.705049991607666f) - (_98.y * 0.6217899918556213f)) - (_98.z * 0.08325999975204468f)))) * _slopeParams.x) + _offsetParams.x))) * _powerParams.x);
    float _174 = exp2(log2(max(0.0f, (((max(0.0f, (((_98.y * 1.1407999992370605f) - (_98.x * 0.13026000559329987f)) - (_98.z * 0.01054999977350235f))) * _124) * _slopeParams.y) + _offsetParams.y))) * _powerParams.y);
    float _175 = exp2(log2(max(0.0f, (((max(0.0f, (((_98.x * -0.024000000208616257f) - (_98.y * 0.12896999716758728f)) + (_98.z * 1.1529699563980103f))) * _124) * _slopeParams.z) + _offsetParams.z))) * _powerParams.z);
    float _177 = dot(float3(_173, _174, _175), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _184 = ((_173 - _177) * _powerParams.w) + _177;
    float _185 = ((_174 - _177) * _powerParams.w) + _177;
    float _186 = ((_175 - _177) * _powerParams.w) + _177;

    if (RENODX_TONE_MAP_TYPE != 0) {
      float3 untonemapped_bt709 = float3(_184, _185, _186);

      const float mid_gray = 0.18f;
      float mid_gray_adjusted = SDRToneMap(mid_gray).x;
      float mid_gray_scale = mid_gray_adjusted / mid_gray;
      //untonemapped_bt709 *= (mid_gray_adjusted / mid_gray);

      float3 tonemapped_bt709 = CustomTonemapSDR(untonemapped_bt709, mid_gray_scale);
      _396 = tonemapped_bt709.r;
      _397 = tonemapped_bt709.g;
      _398 = tonemapped_bt709.b;
    }
    else {
      // float3 ungraded = float3(_184, _185, _186);
      // float3 graded = psycho_grading_only(
      //     ungraded,
      //     RENODX_TONE_MAP_EXPOSURE,
      //     RENODX_TONE_MAP_HIGHLIGHTS,
      //     RENODX_TONE_MAP_SHADOWS,
      //     RENODX_TONE_MAP_CONTRAST,
      //     RENODX_TONE_MAP_SATURATION,
      //     RENODX_TONE_MAP_ADAPTATION_CONTRAST,
      //     1.f
      // );
      // _184 = graded.r;
      // _185 = graded.g;
      // _186 = graded.b;

    float _205 = min(max(log2(mad(_186, 0.07922374457120895f, mad(_185, 0.07843360304832458f, (_184 * 0.8424790501594543f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
    float _206 = min(max(log2(mad(_186, 0.07916612923145294f, mad(_185, 0.8784686326980591f, (_184 * 0.04232824221253395f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
    float _207 = min(max(log2(mad(_186, 0.8791429996490479f, mad(_185, 0.07843360304832458f, (_184 * 0.042375653982162476f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
    float _208 = _205 * 0.06060606241226196f;
    float _209 = _206 * 0.06060606241226196f;
    float _210 = _207 * 0.06060606241226196f;
    float _211 = _208 * _208;
    float _212 = _209 * _209;
    float _213 = _210 * _210;
    float _259 = min(0.0f, (-0.0f - (((_205 * 0.007218181621283293f) + ((_211 * 0.42980000376701355f) + (((_211 * _211) * ((31.959999084472656f - (_205 * 2.432727336883545f)) + (_211 * 15.5f))) - ((_205 * 0.41624245047569275f) * _211)))) + -0.002319999970495701f)));
    float _260 = min(0.0f, (-0.0f - (((_206 * 0.007218181621283293f) + ((_212 * 0.42980000376701355f) + (((_212 * _212) * ((31.959999084472656f - (_206 * 2.432727336883545f)) + (_212 * 15.5f))) - ((_206 * 0.41624245047569275f) * _212)))) + -0.002319999970495701f)));
    float _261 = min(0.0f, (-0.0f - (((_207 * 0.007218181621283293f) + ((_213 * 0.42980000376701355f) + (((_213 * _213) * ((31.959999084472656f - (_207 * 2.432727336883545f)) + (_213 * 15.5f))) - ((_207 * 0.41624245047569275f) * _213)))) + -0.002319999970495701f)));
    float _262 = -0.0f - _259;
    float _263 = -0.0f - _260;
    float _264 = -0.0f - _261;
    float _265 = dot(float3(_262, _263, _264), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    float _271 = saturate((_exposure2.x + -3.0f) * 0.1428571492433548f) * 0.20000004768371582f;
    float _272 = _271 + 1.0f;
    float _303 = ((exp2(log2((_272 - (_271 * saturate((_259 * _259) * _262))) * _262)) - _265) * 1.399999976158142f) + _265;
    float _304 = ((exp2(log2((_272 - (saturate((_260 * _260) * _263) * _271)) * _263)) - _265) * 1.399999976158142f) + _265;
    float _305 = ((exp2(log2((_272 - (saturate((_261 * _261) * _264) * _271)) * _264)) - _265) * 1.399999976158142f) + _265;
    float _324 = saturate(exp2(log2(mad(_305, -0.09902974218130112f, mad(_304, -0.09802088141441345f, (_303 * 1.1968790292739868f)))) * 2.200000047683716f));
    float _325 = saturate(exp2(log2(mad(_305, -0.09896117448806763f, mad(_304, 1.1519031524658203f, (_303 * -0.052896853536367416f)))) * 2.200000047683716f));
    float _326 = saturate(exp2(log2(mad(_305, 1.151073694229126f, mad(_304, -0.09804344922304153f, (_303 * -0.05297163501381874f)))) * 2.200000047683716f));
    if (_etcParams.z == 0.0f) {
      float _332 = 1.0f - abs(_etcParams.w);
      float _336 = saturate(_etcParams.w);
      float _337 = (_332 * _324) + _336;
      float _338 = (_332 * _325) + _336;
      float _339 = (_332 * _326) + _336;
      if (_colorGradingParams.w > 0.0f) {
        float _344 = saturate(_colorGradingParams.w);
        _361 = (((max(0.0f, (1.0f - _337)) - _337) * _344) + _337);
        _362 = (((max(0.0f, (1.0f - _338)) - _338) * _344) + _338);
        _363 = (((max(0.0f, (1.0f - _339)) - _339) * _344) + _339);
      } else {
        _361 = _337;
        _362 = _338;
        _363 = _339;
      }
      float _369 = _userImageAdjust.y + 1.0f;
      float _373 = _userImageAdjust.x + 0.5f;
      float _385 = 2.200000047683716f / ((min(max(_userImageAdjust.w, -1.0f), 1.0f) * 0.800000011920929f) + 2.200000047683716f);
      _396 = exp2(log2(saturate(((_361 + -0.5f) * _369) + _373)) * _385);
      _397 = exp2(log2(saturate(((_362 + -0.5f) * _369) + _373)) * _385);
      _398 = exp2(log2(saturate(((_363 + -0.5f) * _369) + _373)) * _385);
    } else {
      _396 = _324;
      _397 = _325;
      _398 = _326;
    }
    }
  } else {
    _396 = _98.x;
    _397 = _98.y;
    _398 = _98.z;
  }
  if (_etcParams.y > 1.0f) {
    float _407 = abs((TEXCOORD.x * 2.0f) + -1.0f);
    float _408 = abs((TEXCOORD.y * 2.0f) + -1.0f);
    float _412 = saturate(1.0f - (dot(float2(_407, _408), float2(_407, _408)) * saturate(_etcParams.y + -1.0f)));
    _417 = (_412 * _396);
    _418 = (_412 * _397);
    _419 = (_412 * _398);
  } else {
    _417 = _396;
    _418 = _397;
    _419 = _398;
  }
  if ((_118) & ((bool)(_etcParams.z > 0.0f))) {
    _449 = select((_417 <= 0.0031308000907301903f), (_417 * 12.920000076293945f), (((pow(_417, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _450 = select((_418 <= 0.0031308000907301903f), (_418 * 12.920000076293945f), (((pow(_418, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _451 = select((_419 <= 0.0031308000907301903f), (_419 * 12.920000076293945f), (((pow(_419, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _449 = _417;
    _450 = _418;
    _451 = _419;
  }
  if (!(!(_etcParams.y >= 1.0f))) {
    float _456 = float((uint)_102);
    if (!(_456 < _viewDir.w)) {
      if (!(_456 >= (_screenSizeAndInvSize.y - _viewDir.w))) {
        _465 = _449;
        _466 = _450;
        _467 = _451;
      } else {
        _465 = 0.0f;
        _466 = 0.0f;
        _467 = 0.0f;
      }
    } else {
      _465 = 0.0f;
      _466 = 0.0f;
      _467 = 0.0f;
    }
  } else {
    _465 = _449;
    _466 = _450;
    _467 = _451;
  }
  SV_Target.x = _465;
  SV_Target.y = _466;
  SV_Target.z = _467;
  SV_Target.w = _115;
  return SV_Target;
}
