#include "../common.hlsl"

Texture2D<float4> __3__36__0__0__g_sceneColor : register(t29, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t30, space36);

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
  // Base scene sample for this fullscreen pixel.
  float4 _14 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticPointBlackBorder, float2(TEXCOORD.x, TEXCOORD.y));
  float _37;
  float _38;
  float _82;
  float _83;
  float _84;
  float _184;
  float _185;
  float _186;
  float _243;
  float _244;
  float _245;
  // Optional chromatic-style offset: read shifted R and B channels.
  if (_postProcessParams.w > 0.0f) {
    float4 _31 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_postProcessParams.w * ((TEXCOORD.x * 0.003000000026077032f) + -0.001500000013038516f)) + TEXCOORD.x), TEXCOORD.y), 0.0f);
    float4 _34 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(TEXCOORD.x, ((_postProcessParams.w * ((TEXCOORD.y * 0.003000000026077032f) + -0.001500000013038516f)) + TEXCOORD.y)), 0.0f);
    _37 = _31.x;
    _38 = _34.z;
  } else {
    _37 = _14.x;
    _38 = _14.z;
  }

  _37 = lerp(_14.x, _37, CUSTOM_CHROMATIC_ABERRATION);
  _38 = lerp(_14.z, _38, CUSTOM_CHROMATIC_ABERRATION);

  // Optional animated film-grain multiplier.
  bool vanilla_film_grain = (_slopeParams.w > 0.0f) && CUSTOM_FILM_GRAIN_TYPE == 0;
  if (vanilla_film_grain) {
    float _48 = ((TEXCOORD.y + 4.0f) * (TEXCOORD.x + 4.0f)) * _time.x;
    float _49 = _48 * 0.7692307829856873f;
    float _53 = frac(abs(_49));
    float _58 = _48 * 0.08130080997943878f;
    float _62 = frac(abs(_58));
    float _67 = ((select((_58 >= (-0.0f - _58)), _62, (-0.0f - _62)) * 1230.0f) + 10.0f) * ((select((_49 >= (-0.0f - _49)), _53, (-0.0f - _53)) * 13.0f) + 1.0f);
    float _71 = frac(abs(_67));
    float _77 = ((0.007500052452087402f - (select((_67 >= (-0.0f - _67)), _71, (-0.0f - _71)) * 0.15000000596046448f)) * _slopeParams.w) + 1.0f;
    _82 = (_77 * _37);
    _83 = (_77 * _14.y);
    _84 = (_77 * _38);
  } else {
    _82 = _37;
    _83 = _14.y;
    _84 = _38;
  }

  if (CUSTOM_FILM_GRAIN_TYPE != 0 || CUSTOM_SHARPENING_TYPE != 0) {
    float3 color_pq = float3(_82, _83, _84);

    float scaling = RENODX_TONE_MAP_TYPE == 0 ? 100.0f : RENODX_DIFFUSE_WHITE_NITS;
    float3 color_bt2020 = renodx::color::pq::DecodeSafe(color_pq, scaling);
    float3 color_bt709 = renodx::color::bt709::from::BT2020(color_bt2020);
    color_bt709 = CustomPostProcessing(color_bt709, TEXCOORD, __3__36__0__0__g_sceneColor, __0__4__0__0__g_staticBilinearClamp, 0, scaling);
    color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
    color_pq = renodx::color::pq::EncodeSafe(color_bt2020, scaling);
    
    _82 = color_pq.x;
    _83 = color_pq.y;
    _84 = color_pq.z;
  }

  uint _90 = uint(_screenSizeAndInvSize.x * TEXCOORD.x);
  uint _91 = uint(_screenSizeAndInvSize.y * TEXCOORD.y);
  float _93 = __3__36__0__0__g_depth.Sample(__0__4__0__0__g_staticPointBlackBorder, float2(TEXCOORD.x, TEXCOORD.y));



  // Depth-gated local filter (cross neighborhood) that attenuates itself near strong contrast.
  if (!(((bool)(_93.x < 1.0000000116860974e-07f)) | ((bool)(_93.x == 1.0f))) && CUSTOM_SHARPENING_TYPE == 0) {
    float _101 = select((_postProcessParams.z >= 1.0f), 1.0f, 0.25f);
    float4 _108 = __3__36__0__0__g_sceneColor.Load(int3(_90, ((uint)(_91 + -1u)), 0));
    float4 _113 = __3__36__0__0__g_sceneColor.Load(int3(((uint)(_90 + -1u)), _91, 0));
    float4 _118 = __3__36__0__0__g_sceneColor.Load(int3(((uint)(_90 + 1u)), _91, 0));
    float4 _123 = __3__36__0__0__g_sceneColor.Load(int3(_90, ((uint)(_91 + 1u)), 0));
    float _134 = max(max(_83, _108.y), max(max(_113.y, _118.y), _123.y));
    float _141 = sqrt(saturate(min(min(min(_83, _108.y), min(min(_113.y, _118.y), _123.y)), (1.0f - _134)) * (1.0f / _134))) * (-1.0f / (((1.0f - _101) * 8.0f) + (_101 * 5.0f)));
    float _144 = 1.0f / ((_141 * 4.0f) + 1.0f);
    float _166 = saturate(((_141 * (((_113.x + _108.x) + _118.x) + _123.x)) + _82) * _144) - _82;
    float _167 = saturate(((_141 * (((_113.y + _108.y) + _118.y) + _123.y)) + _83) * _144) - _83;
    float _168 = saturate(((_141 * (((_113.z + _108.z) + _118.z) + _123.z)) + _84) * _144) - _84;
    float _173 = 1.0f - dot(float3(abs(_166), abs(_167), abs(_168)), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _174 = _173 * _173;
    float _175 = _174 * _174;
    float _176 = _175 * _175;
    _184 = ((_176 * _166 * CUSTOM_SHARPENING) + _82);
    _185 = ((_176 * _167 * CUSTOM_SHARPENING) + _83);
    _186 = ((_176 * _168 * CUSTOM_SHARPENING) + _84);

  } else {
    _184 = _82;
    _185 = _83;
    _186 = _84;
 }

  // sRGB-to-linear style decode, blended with a constant bias via _etcParams.w.
  float _214 = 1.0f - abs(_etcParams.w);
  float _218 = saturate(_etcParams.w);
#if 0
  float _219 = (_214 * select((_184 < 0.040449999272823334f), (_184 * 0.07739938050508499f), exp2(log2((_184 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f))) + _218;
  float _220 = (_214 * select((_185 < 0.040449999272823334f), (_185 * 0.07739938050508499f), exp2(log2((_185 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f))) + _218;
  float _221 = (_214 * select((_186 < 0.040449999272823334f), (_186 * 0.07739938050508499f), exp2(log2((_186 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f))) + _218;
#else 
  float _219 = _214 * _184 + _218;
  float _220 = _214 * _185 + _218;
  float _221 = _214 * _186 + _218;
#endif

  // Optional invert blend controlled by _colorGradingParams.w.
  if (_colorGradingParams.w > 0.0f) {
    float _226 = saturate(_colorGradingParams.w);
    _243 = (((max(0.0f, (1.0f - _219)) - _219) * _226) + _219);
    _244 = (((max(0.0f, (1.0f - _220)) - _220) * _226) + _220);
    _245 = (((max(0.0f, (1.0f - _221)) - _221) * _226) + _221);
  } else {
    _243 = _219;
    _244 = _220;
    _245 = _221;
  }
  // Radial mask from center. _postProcessParams.x controls edge falloff strength.
  float _284 = abs((TEXCOORD.x * 2.0f) + -1.0f);
  float _285 = abs((TEXCOORD.y * 2.0f) + -1.0f);
  float _289 = saturate(1.0f - (dot(float2(_284, _285), float2(_284, _285)) * (_postProcessParams.x * CUSTOM_VIGNETTE)));
#if 0 // Experimenting with changing encodeing
  // Apply radial mask directly in linear domain (input is already linear BT.709).
  float _299 = _289 * _243;
  float _300 = _289 * _244;
  float _301 = _289 * _245;
  // Letterbox gate: black out top/bottom bands defined by _viewDir.w.
  bool _334 = (((bool)(!(SV_Position.y < _viewDir.w)))) & (((bool)(!(SV_Position.y >= (_screenSizeAndInvSize.y - _viewDir.w)))));
  SV_Target.x = select(_334, _299, 0.0f);
  SV_Target.y = select(_334, _300, 0.0f);
  SV_Target.z = select(_334, _301, 0.0f);

  SV_Target.xyz = renodx::color::bt2020::from::BT709(SV_Target.xyz);
  float scaling = RENODX_TONE_MAP_TYPE == 0 ? 1.f : RENODX_DIFFUSE_WHITE_NITS;
  SV_Target.xyz = renodx::color::pq::EncodeSafe(SV_Target.xyz, scaling);

#else
  float _252 = (pow(_243, 0.012683313339948654f));
  float _253 = (pow(_244, 0.012683313339948654f));
  float _254 = (pow(_245, 0.012683313339948654f));
  // Apply radial mask in PQ-like domain, then map back.
  float _299 = exp2(log2(_289 * exp2(log2(max(0.0f, (_252 + -0.8359375f)) / (18.8515625f - (_252 * 18.6875f))) * 6.277394771575928f)) * 0.1593017578125f);
  float _300 = exp2(log2(_289 * exp2(log2(max(0.0f, (_253 + -0.8359375f)) / (18.8515625f - (_253 * 18.6875f))) * 6.277394771575928f)) * 0.1593017578125f);
  float _301 = exp2(log2(_289 * exp2(log2(max(0.0f, (_254 + -0.8359375f)) / (18.8515625f - (_254 * 18.6875f))) * 6.277394771575928f)) * 0.1593017578125f);
  // Letterbox gate: black out top/bottom bands defined by _viewDir.w.
  bool _334 = (((bool)(!(SV_Position.y < _viewDir.w)))) & (((bool)(!(SV_Position.y >= (_screenSizeAndInvSize.y - _viewDir.w)))));
  SV_Target.x = select(_334, exp2(log2((1.0f / ((_299 * 18.6875f) + 1.0f)) * ((_299 * 18.8515625f) + 0.8359375f)) * 78.84375f), 0.0f);
  SV_Target.y = select(_334, exp2(log2((1.0f / ((_300 * 18.6875f) + 1.0f)) * ((_300 * 18.8515625f) + 0.8359375f)) * 78.84375f), 0.0f);
  SV_Target.z = select(_334, exp2(log2((1.0f / ((_301 * 18.6875f) + 1.0f)) * ((_301 * 18.8515625f) + 0.8359375f)) * 78.84375f), 0.0f);
#endif
  // Preserve source alpha.
  SV_Target.w = _14.w;
  return SV_Target;
}
