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
  float4 _14 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticPointBlackBorder, float2(TEXCOORD.x, TEXCOORD.y));
  float _37;
  float _38;
  float _82;
  float _83;
  float _84;
  float _167;
  float _168;
  float _169;
  float _229;
  float _230;
  float _231;
  float _313;
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
    float3 color_bt709 = float3(_82, _83, _84);
    color_bt709 = renodx::color::srgb::Decode(color_bt709);
    color_bt709 = CustomPostProcessing(color_bt709, TEXCOORD, __3__36__0__0__g_sceneColor, __0__4__0__0__g_staticBilinearClamp, 1);
    color_bt709 = renodx::color::srgb::Encode(color_bt709);
    _82 = color_bt709.x;
    _83 = color_bt709.y;
    _84 = color_bt709.z;
  }
  uint _90 = uint(_screenSizeAndInvSize.x * TEXCOORD.x);
  uint _91 = uint(_screenSizeAndInvSize.y * TEXCOORD.y);
  float _93 = __3__36__0__0__g_depth.Sample(__0__4__0__0__g_staticPointBlackBorder, float2(TEXCOORD.x, TEXCOORD.y));
  if (!(((_93.x < 1.0000000116860974e-07f)) || ((_93.x == 1.0f))) && CUSTOM_SHARPENING_TYPE == 0) {
    float _101 = select((_postProcessParams.z >= 1.0f), 1.0f, 0.25f);
    float4 _108 = __3__36__0__0__g_sceneColor.Load(int3((int)(_90), ((int)(_91 + (uint)(-1))), 0));
    float4 _113 = __3__36__0__0__g_sceneColor.Load(int3(((int)(_90 + (uint)(-1))), (int)(_91), 0));
    float4 _118 = __3__36__0__0__g_sceneColor.Load(int3(((int)(_90 + 1u)), (int)(_91), 0));
    float4 _123 = __3__36__0__0__g_sceneColor.Load(int3((int)(_90), ((int)(_91 + 1u)), 0));
    float _134 = max(max(_83, _108.y), max(max(_113.y, _118.y), _123.y));
    float _141 = sqrt(saturate(min(min(min(_83, _108.y), min(min(_113.y, _118.y), _123.y)), (1.0f - _134)) * (1.0f / _134))) * (-1.0f / (((1.0f - _101) * 8.0f) + (_101 * 5.0f)));
    float _144 = 1.0f / ((_141 * 4.0f) + 1.0f);
    _167 = saturate(((_141 * (((_113.x + _108.x) + _118.x) + _123.x)) + _82) * _144);
    _168 = saturate(((_141 * (((_113.y + _108.y) + _118.y) + _123.y)) + _83) * _144);
    _169 = saturate(((_141 * (((_113.z + _108.z) + _118.z) + _123.z)) + _84) * _144);
    _167 = lerp(_82, _167, CUSTOM_SHARPENING);
    _168 = lerp(_83, _168, CUSTOM_SHARPENING);
    _169 = lerp(_84, _169, CUSTOM_SHARPENING);
  } else {
    _167 = _82;
    _168 = _83;
    _169 = _84;
  }
  float _200 = 1.0f - abs(_etcParams.w);
  float _204 = saturate(_etcParams.w);
  float _205 = (_200 * saturate(select((_167 < 0.040449999272823334f), (_167 * 0.07739938050508499f), exp2(log2((_167 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)))) + _204;
  float _206 = (_200 * saturate(select((_168 < 0.040449999272823334f), (_168 * 0.07739938050508499f), exp2(log2((_168 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)))) + _204;
  float _207 = (_200 * saturate(select((_169 < 0.040449999272823334f), (_169 * 0.07739938050508499f), exp2(log2((_169 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)))) + _204;
  if (_colorGradingParams.w > 0.0f) {
    float _212 = saturate(_colorGradingParams.w);
    _229 = (((max(0.0f, (1.0f - _205)) - _205) * _212) + _205);
    _230 = (((max(0.0f, (1.0f - _206)) - _206) * _212) + _206);
    _231 = (((max(0.0f, (1.0f - _207)) - _207) * _212) + _207);
  } else {
    _229 = _205;
    _230 = _206;
    _231 = _207;
  }
  float _238 = _userImageAdjust.y + 1.0f;
  float _242 = _userImageAdjust.x + 0.5f;
  float _254 = 2.200000047683716f / ((min(max(_userImageAdjust.w, -1.0f), 1.0f) * 0.800000011920929f) + 2.200000047683716f);
  float _265 = (TEXCOORD.x * 2.0f) + -1.0f;
  float _266 = TEXCOORD.y * 2.0f;
  float _267 = 1.0f - _266;
  float _295 = mad((_projToPrevProj[3].z), 1.0000000116860974e-07f, mad((_projToPrevProj[3].y), _267, ((_projToPrevProj[3].x) * _265))) + (_projToPrevProj[3].w);
  float _298 = ((mad((_projToPrevProj[0].z), 1.0000000116860974e-07f, mad((_projToPrevProj[0].y), _267, ((_projToPrevProj[0].x) * _265))) + (_projToPrevProj[0].w)) / _295) - _265;
  float _299 = ((mad((_projToPrevProj[1].z), 1.0000000116860974e-07f, mad((_projToPrevProj[1].y), _267, ((_projToPrevProj[1].x) * _265))) + (_projToPrevProj[1].w)) / _295) - _267;
  if (_localToneMappingParams.w > 0.0f) {
    _313 = saturate(1.0f - (sqrt((_299 * _299) + (_298 * _298)) * 2.0f));
  } else {
    _313 = 1.0f;
  }
  float _316 = abs(_265);
  float _317 = abs(_266 + -1.0f);
  float _321 = saturate(1.0f - ((_313 * _postProcessParams.x * CUSTOM_VIGNETTE) * dot(float2(_316, _317), float2(_316, _317))));
  bool _330 = ((!(SV_Position.y < _viewDir.w))) && ((!(SV_Position.y >= (_screenSizeAndInvSize.y - _viewDir.w))));
  SV_Target.x = select(_330, (_321 * exp2(log2(saturate((_238 * (_229 + -0.5f)) + _242)) * _254)), 0.0f);
  SV_Target.y = select(_330, (_321 * exp2(log2(saturate((_238 * (_230 + -0.5f)) + _242)) * _254)), 0.0f);
  SV_Target.z = select(_330, (_321 * exp2(log2(saturate((_238 * (_231 + -0.5f)) + _242)) * _254)), 0.0f);

  SV_Target.xyz = CUSTOM_SDR_BLACK_CRUSH_FIX == 1 ? renodx::color::correct::Gamma(SV_Target.xyz, true) : SV_Target.xyz;

  SV_Target.w = _14.w;
  return SV_Target;
}