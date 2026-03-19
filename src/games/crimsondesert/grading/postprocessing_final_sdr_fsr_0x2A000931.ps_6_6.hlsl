#include "../common.hlsl"

Texture2D<float4> __3__36__0__0__g_sceneColor : register(t29, space36);

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

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointBlackBorder : register(s11, space4);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _13 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticPointBlackBorder, float2(TEXCOORD.x, TEXCOORD.y));
  float _36;
  float _37;
  float _81;
  float _82;
  float _83;
  float _143;
  float _144;
  float _145;
  float _202;
  float _203;
  float _204;
  if (_postProcessParams.w > 0.0f) {
    float4 _30 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_postProcessParams.w * ((TEXCOORD.x * 0.003000000026077032f) + -0.001500000013038516f)) + TEXCOORD.x), TEXCOORD.y), 0.0f);
    float4 _33 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(TEXCOORD.x, ((_postProcessParams.w * ((TEXCOORD.y * 0.003000000026077032f) + -0.001500000013038516f)) + TEXCOORD.y)), 0.0f);
    _36 = _30.x;
    _37 = _33.z;
  } else {
    _36 = _13.x;
    _37 = _13.z;
  }

  _36 = lerp(_13.x, _36, CUSTOM_CHROMATIC_ABERRATION);
  _37 = lerp(_13.z, _37, CUSTOM_CHROMATIC_ABERRATION);

  bool vanilla_film_grain = (_slopeParams.w > 0.0f) && CUSTOM_FILM_GRAIN_TYPE == 0;
  if (vanilla_film_grain) {
    float _47 = ((TEXCOORD.y + 4.0f) * (TEXCOORD.x + 4.0f)) * _time.x;
    float _48 = _47 * 0.7692307829856873f;
    float _52 = frac(abs(_48));
    float _57 = _47 * 0.08130080997943878f;
    float _61 = frac(abs(_57));
    float _66 = ((select((_57 >= (-0.0f - _57)), _61, (-0.0f - _61)) * 1230.0f) + 10.0f) * ((select((_48 >= (-0.0f - _48)), _52, (-0.0f - _52)) * 13.0f) + 1.0f);
    float _70 = frac(abs(_66));
    float _76 = ((0.007500052452087402f - (select((_66 >= (-0.0f - _66)), _70, (-0.0f - _70)) * 0.15000000596046448f)) * _slopeParams.w) + 1.0f;
    _81 = (_76 * _36);
    _82 = (_76 * _13.y);
    _83 = (_76 * _37);
  } else {
    _81 = _36;
    _82 = _13.y;
    _83 = _37;
  }

  if (CUSTOM_FILM_GRAIN_TYPE != 0 || CUSTOM_SHARPENING_TYPE != 0) {
    float3 color_bt709 = float3(_81, _82, _83);
    color_bt709 = renodx::color::srgb::Decode(color_bt709);
    color_bt709 = CustomPostProcessing(color_bt709, TEXCOORD, __3__36__0__0__g_sceneColor, __0__4__0__0__g_staticBilinearClamp, 1);
    color_bt709 = renodx::color::srgb::Encode(color_bt709);
    _81 = color_bt709.x;
    _82 = color_bt709.y;
    _83 = color_bt709.z;
  }

  float _114 = 1.0f - abs(_etcParams.w);
  float _118 = saturate(_etcParams.w);
  float _119 = (_114 * saturate(select((_81 < 0.040449999272823334f), (_81 * 0.07739938050508499f), exp2(log2((_81 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)))) + _118;
  float _120 = (_114 * saturate(select((_82 < 0.040449999272823334f), (_82 * 0.07739938050508499f), exp2(log2((_82 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)))) + _118;
  float _121 = (_114 * saturate(select((_83 < 0.040449999272823334f), (_83 * 0.07739938050508499f), exp2(log2((_83 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)))) + _118;
  if (_colorGradingParams.w > 0.0f) {
    float _126 = saturate(_colorGradingParams.w);
    _143 = (((max(0.0f, (1.0f - _119)) - _119) * _126) + _119);
    _144 = (((max(0.0f, (1.0f - _120)) - _120) * _126) + _120);
    _145 = (((max(0.0f, (1.0f - _121)) - _121) * _126) + _121);
  } else {
    _143 = _119;
    _144 = _120;
    _145 = _121;
  }
  float _152 = _userImageAdjust.y + 1.0f;
  float _156 = _userImageAdjust.x + 0.5f;
  float _168 = 2.200000047683716f / ((min(max(_userImageAdjust.w, -1.0f), 1.0f) * 0.800000011920929f) + 2.200000047683716f);
  float _183 = abs((TEXCOORD.x * 2.0f) + -1.0f);
  float _184 = abs((TEXCOORD.y * 2.0f) + -1.0f);
  float _188 = saturate(1.0f - (dot(float2(_183, _184), float2(_183, _184)) * (_postProcessParams.x * CUSTOM_VIGNETTE)));
  if (!(SV_Position.y < _viewDir.w)) {
    if (!(SV_Position.y >= (_screenSizeAndInvSize.y - _viewDir.w))) {
      _202 = (_188 * exp2(log2(saturate((_152 * (_143 + -0.5f)) + _156)) * _168));
      _203 = (_188 * exp2(log2(saturate((_152 * (_144 + -0.5f)) + _156)) * _168));
      _204 = (_188 * exp2(log2(saturate((_152 * (_145 + -0.5f)) + _156)) * _168));
    } else {
      _202 = 0.0f;
      _203 = 0.0f;
      _204 = 0.0f;
    }
  } else {
    _202 = 0.0f;
    _203 = 0.0f;
    _204 = 0.0f;
  }
  SV_Target.x = _202;
  SV_Target.y = _203;
  SV_Target.z = _204;

  SV_Target.xyz = CUSTOM_SDR_BLACK_CRUSH_FIX == 1 ? renodx::color::correct::Gamma(SV_Target.xyz, true) : SV_Target.xyz;

  SV_Target.w = _13.w;
  return SV_Target;
}
