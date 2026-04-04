#include "../common.hlsl"
#include "./tonemap.hlsli"

Texture2D<float4> __0__7__0__0__g_bindlessTextures[] : register(t0, space7);

Texture2D<float4> __3__36__0__0__g_noiseTex : register(t23, space36);

Texture2D<float4> __3__36__0__0__g_postProcessSizeColor : register(t45, space36);

Texture2D<float4> __3__36__0__0__g_sceneColor : register(t29, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t30, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t26, space36);

Texture2D<uint4> __3__36__0__0__g_gbufferBaseColor : register(t60, space36);

Texture2D<float4> __3__36__0__0__g_gbufferNormal : register(t61, space36);

Texture2D<uint> __3__36__0__0__g_CustomRenderPassValue : register(t62, space36);

Texture2D<float4> __3__36__0__0__g_CustomRenderPassDepth : register(t63, space36);

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

struct PostProcessUber_CDStruct {
  uint _noiseTex;
  float _itemRatio;
  float _borderRatio;
  float _borderWidth;
  float _borderSmoothness;
  float _borderEdgeNoiseRatio;
  float2 _borderEdgeNoiseOffset;
  float2 _borderEdgeNoiseTile;
  uint _borderColor;
  uint _borderEdgeNoiseTexture;
  float _borderFlickerSpeed;
  float _borderFlickerIntensity;
  float2 _borderFlickerOpacityMinMax;
  float _dropItemFakeLightIntensity;
  float _dropItemBlurWidth;
  float _dropItemBlurIntensity;
  float3 _channelBrightness;
  float _contrast;
  float3 _saturation;
  float _fishEyeMaxPower;
  uint _enemyMaskColor;
  uint _objectiveMaskColor;
  float _uiMainMenuEffect;
  float _uiQuickSlotEffect;
  uint _detectColorBase;
  float _detectModeG;
  float _detectModeR;
  float _detectModeB;
  float _detectModeKnowledge;
  float _detectModeInterrupt;
  uint _detectLiftColor;
  float _statusVignetteRatio1;
  float _statusVignetteRadius1;
  float _statusVignettePower1;
  float _statusVignetteChromaticShift1;
  uint _statusVignetteColor1;
  float _statusVignetteRatio2;
  float _statusVignetteRadius2;
  float _statusVignettePower2;
  float _statusVignetteChromaticShift2;
  uint _statusVignetteColor2;
  float _statusVignetteRatio3;
  float _statusVignetteRadius3;
  float _statusVignettePower3;
  float _statusVignetteChromaticShift3;
  uint _statusVignetteColor3;
  uint _temperatureWarningTex;
  uint _electrocutionTex;
  uint _enemyAlertTex;
  uint _wantedRegionColor;
  float _chromaticAberrationRatio;
  float _chromaticAberrationShiftValue;
  float2 _chromaticAberrationShiftPosition;
  float _invertColor;
  uint _followLearningColor;
  uint _followLearningSaturationTone;
  uint _followLearningNoiseTex;
  float _isBloodEffect;
  float _testEffectRatio;
};

ConstantBuffer<PostProcessUber_CDStruct> BindlessParameters_PostProcessUber_CD[] : register(b0, space100);

SamplerState __0__4__0__0__g_staticBilinearWrap : register(s0, space4);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointWrap : register(s8, space4);

float3 ConvertAP1ToBT709(float3 scene_ap1) {
  return float3(
      max(0.0f, (((scene_ap1.x * 1.705049991607666f) - (scene_ap1.y * 0.6217899918556213f)) - (scene_ap1.z * 0.08325999975204468f))),
      max(0.0f, (((scene_ap1.y * 1.1407999992370605f) - (scene_ap1.x * 0.13026000559329987f)) - (scene_ap1.z * 0.01054999977350235f))),
      max(0.0f, (((scene_ap1.x * -0.024000000208616257f) - (scene_ap1.y * 0.12896999716758728f)) + (scene_ap1.z * 1.1529699563980103f))));
}

float3 ApplyDisplayCurvesAndSaturation(float3 bt709, bool clamp = true) {
  float3 graded_components = ((bt709)*_slopeParams.xyz) + _offsetParams.xyz;
  if (clamp) {
    graded_components = max(0.0f, graded_components);
  }
  float3 curved = exp2(log2(graded_components) * _powerParams.xyz);
  float display_transform_luminance = dot(curved, float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  return lerp(display_transform_luminance.xxx, curved, _powerParams.w);
}

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  // Read post-process material parameters once per wave for this pixel.
  float _34 = _srcTargetSizeAndInv.x / _srcTargetSizeAndInv.y;
  int _40 = WaveReadLaneFirst(_materialIndex);
  float _48 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_40 < (uint)170000), _40, 0)) + 0u))]._statusVignetteRatio1);
  int _49 = WaveReadLaneFirst(_materialIndex);
  float _57 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_49 < (uint)170000), _49, 0)) + 0u))]._statusVignetteRatio2);
  int _58 = WaveReadLaneFirst(_materialIndex);
  float _66 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_58 < (uint)170000), _58, 0)) + 0u))]._statusVignetteRatio3);
  int _67 = WaveReadLaneFirst(_materialIndex);
  float _75 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_67 < (uint)170000), _67, 0)) + 0u))]._statusVignetteChromaticShift1);
  int _76 = WaveReadLaneFirst(_materialIndex);
  float _84 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_76 < (uint)170000), _76, 0)) + 0u))]._statusVignetteChromaticShift2);
  int _85 = WaveReadLaneFirst(_materialIndex);
  float _93 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_85 < (uint)170000), _85, 0)) + 0u))]._statusVignetteChromaticShift3);
  int _94 = WaveReadLaneFirst(_materialIndex);
  float _102 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_94 < (uint)170000), _94, 0)) + 0u))]._chromaticAberrationRatio);
  int _103 = WaveReadLaneFirst(_materialIndex);
  float _111 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_103 < (uint)170000), _103, 0)) + 0u))]._chromaticAberrationShiftValue);
  int _112 = WaveReadLaneFirst(_materialIndex);
  int _121 = WaveReadLaneFirst(_materialIndex);
  float _129 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_121 < (uint)170000), _121, 0)) + 0u))]._fishEyeMaxPower);
  float _156;
  float _195;
  float _196;
  float _199;
  float _200;
  float _221;
  float _222;
  float _292;
  float _293;
  float _294;
  float _329;
  float _414;
  float _415;
  float _416;
  float _457;
  float _458;
  float _459;
  float _510;
  float _511;
  float _512;
  float _574;
  float _575;
  float _576;
  float _577;
  float _578;
  float _579;
  float _649;
  float _650;
  float _651;
  float _705;
  float _706;
  float _901;
  float _902;
  float _903;
  float _936;
  float _937;
  float _938;
  int _939;
  float _1116;
  float _1117;
  float _1118;
  float _1181;
  float _1182;
  float _1183;
  float _1223;
  float _1224;
  float _1225;
  float _1359;
  float _1360;
  float _1361;
  float _1422;
  float _1423;
  float _1424;
  float _1425;
  float _1426;
  float _1427;
  float _1626;
  float _1712;
  float _1713;
  float _1714;
  float _1835;
  float _1836;
  float _1837;
  float _1955;
  float _1956;
  float _1957;
  float _2074;
  float _2075;
  float _2076;
  float _2137;
  float _2138;
  float _2139;
  bool _2491;
  bool _2507;
  float _2554;
  float _2555;
  float _2556;
  float _2557;
  float _2690;
  float _2691;
  float _2692;
  float _2722;
  float _2723;
  float _2724;
  float _2866;
  float _2867;
  float _2868;
  float _2882;
  float _3128;
  float _3129;
  float _3130;
  float _3163;
  float _3164;
  float _3165;
  float _3184;
  float _3185;
  float _3186;
  float _3216;
  float _3217;
  float _3218;
  float _3232;
  float _3233;
  float _3234;
  // Optional lens/fisheye warp (also reused by follow-learning mode).
  [branch]
  if ((((bool)(_129 > 0.0010000000474974513f)) | ((bool)(_129 < -0.0010000000474974513f))) || (_followLearning > 0.0010000000474974513f)) {
    float _138 = 0.5f / _34;
    float _143 = ((_srcTargetSizeAndInv.x * TEXCOORD.x) / _srcTargetSizeAndInv.x) + -0.5f;
    float _144 = ((_srcTargetSizeAndInv.y * TEXCOORD.y) / _srcTargetSizeAndInv.x) - _138;
    float _145 = dot(float2(_143, _144), float2(_143, _144));
    float _146 = sqrt(_145);
    if (_followLearning > 0.0010000000474974513f) {
      _156 = ((pow(_followLearning, 0.25f)) * 1.5f);
    } else {
      _156 = _129;
    }
    if (_156 > 0.0f) {
      float _160 = sqrt(dot(float2(0.5f, _138), float2(0.5f, _138)));
      float _165 = tan(_156 * _146) * (rsqrt(_145) * _160);
      float _169 = tan(_160 * _156);
      _195 = (((_165 * _143) / _169) + 0.5f);
      _196 = (((_165 * _144) / _169) + _138);
    } else {
      if (_156 < 0.0f) {
        float _178 = select((_34 < 1.0f), 0.5f, _138);
        float _184 = atan((_156 * _146) * -10.0f) * (rsqrt(_145) * _178);
        float _189 = atan((_156 * -10.0f) * _178);
        _195 = (((_184 * _143) / _189) + 0.5f);
        _196 = (((_184 * _144) / _189) + _138);
      } else {
        _195 = 0.0f;
        _196 = 0.0f;
      }
    }
    _199 = _195;
    _200 = (_196 * _34);
  } else {
    _199 = TEXCOORD.x;
    _200 = TEXCOORD.y;
  }

  // _199 = TEXCOORD.x;
  // _200 = TEXCOORD.y;

  // UI quick-slot effect applies an additional UV shift.
  int _201 = WaveReadLaneFirst(_materialIndex);
  float _209 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_201 < (uint)170000), _201, 0)) + 0u))]._uiQuickSlotEffect);
  if (!(!(_209 >= 0.0010000000474974513f))) {
    _221 = ((_209 * (0.029999999329447746f - (_199 * 0.06000000238418579f))) + _199);
    _222 = ((_209 * (0.029999999329447746f - (_200 * 0.06000000238418579f))) + _200);
  } else {
    _221 = _199;
    _222 = _200;
  }
  // Base scene color sample for the post chain.
  float4 _225 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearWrap, float2(_221, _222));
  int _229 = WaveReadLaneFirst(_materialIndex);
  int _237 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_229 < (uint)170000), _229, 0)) + 0u))]._noiseTex);
  [branch]
  if (!(!(_fleeCount >= 0.0010000000474974513f))) {
    float4 _261 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_237 < (uint)65000), _237, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2((TEXCOORD.x * 4.0f), ((((_fleeCount * 0.0010000000474974513f) + -0.10000000149011612f) + ((TEXCOORD.y / _34) * 4.0f)) + (_time.x * 0.019999999552965164f))));
    float _270 = (TEXCOORD.x + -0.5f) + ((_261.x + -0.5f) * 0.15000000596046448f);
    float _271 = (TEXCOORD.y + -0.5f) + ((_261.y + -0.5f) * 0.15000000596046448f);
    float _284 = saturate(_fleeCount * 0.20000000298023224f) * saturate((((_fleeCount * 0.004999999888241291f) + -0.6000000238418579f) + sqrt((_270 * _270) + (_271 * _271))) / ((_fleeCount * 0.004000000189989805f) + 0.10000000149011612f));
    _292 = (_225.x - (_284 * _225.x));
    _293 = (_225.y - (_284 * _225.y));
    _294 = (_225.z - (_284 * _225.z));
  } else {
    _292 = _225.x;
    _293 = _225.y;
    _294 = _225.z;
  }
  // Main menu style effect (color remap and vignette shaping).
  int _295 = WaveReadLaneFirst(_materialIndex);
  if (((bool)(_209 >= 0.0010000000474974513f)) | ((bool)(WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_295 < (uint)170000), _295, 0)) + 0u))]._uiMainMenuEffect) >= 0.0010000000474974513f))) {
    int _308 = WaveReadLaneFirst(_materialIndex);
    if (WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_308 < (uint)170000), _308, 0)) + 0u))]._uiMainMenuEffect) > _209) {
      int _319 = WaveReadLaneFirst(_materialIndex);
      _329 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_319 < (uint)170000), _319, 0)) + 0u))]._uiMainMenuEffect);
    } else {
      _329 = _209;
    }
    float _337 = _329 * 0.5f;
    float4 _361 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_237 < (uint)65000), _237, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2(((TEXCOORD.x * 2.0f) * _34), (TEXCOORD.y * 2.0f)));
    int _366 = WaveReadLaneFirst(_materialIndex);
    bool _376 = (_209 < 0.0010000000474974513f);
    bool _377 = (_376) & ((bool)(WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_366 < (uint)170000), _366, 0)) + 0u))]._uiMainMenuEffect) >= 0.0010000000474974513f));
    int _379 = WaveReadLaneFirst(_materialIndex);
    float _397 = (TEXCOORD.y - select(_377, 0.550000011920929f, 0.5f)) - ((_361.y + -0.5f) * 0.05000000074505806f);
    float _398 = ((TEXCOORD.x - ((_361.x + -0.5f) * 0.05000000074505806f)) + select(_377, -0.41999998688697815f, -0.5f)) * _34;
    float _409 = ((_329 * -0.8999999761581421f) * (1.0f - saturate((select(((_376) & ((bool)(WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_379 < (uint)170000), _379, 0)) + 0u))]._uiMainMenuEffect) >= 0.0010000000474974513f))), 0.3499999940395355f, 0.4000000059604645f) - sqrt((_398 * _398) + (_397 * _397))) * 1.4285714626312256f))) + 1.0f;
    _414 = (_409 * ((_337 * (((_293 * 0.75f) - (_292 * 0.6069999933242798f)) + (_294 * 0.1889999955892563f))) + _292));
    _415 = (_409 * ((_337 * (((_292 * 0.3490000069141388f) - (_293 * 0.3140000104904175f)) + (_294 * 0.1679999977350235f))) + _293));
    _416 = (_409 * ((_337 * (((_292 * 0.2720000147819519f) + (_293 * 0.5339999794960022f)) - (_294 * 0.8690000176429749f))) + _294));
  } else {
    _414 = _292;
    _415 = _293;
    _416 = _294;
  }
  // Status-vignette chromatic shift.
  if ((((bool)(_48 >= 0.0010000000474974513f)) & ((bool)(_75 >= 0.0010000000474974513f))) || (((bool)(_57 >= 0.0010000000474974513f)) & ((bool)(_84 >= 0.0010000000474974513f))) || (((bool)(_66 >= 0.0010000000474974513f)) & ((bool)(_93 >= 0.0010000000474974513f)))) {
    float _431 = _221 + -0.5f;
    float _432 = _222 + -0.5f;
    float _441 = rsqrt(dot(float2(_431, _432), float2(_431, _432))) * ((max(max(_75, _84), _93) * 0.009999999776482582f) * sqrt((_432 * _432) + (_431 * _431)));
    float _442 = _441 * _431;
    float _444 = _441 * _432;
    float4 _450 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2((_221 - _442), (_222 - _444)));
    float4 _452 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2(_221, _222));
    float4 _454 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2((_442 + _221), (_444 + _222)));
    _457 = _450.x;
    _458 = _452.y;
    _459 = _454.z;
  } else {
    _457 = _414;
    _458 = _415;
    _459 = _416;
  }

  float3 pre_vignette = float3(_414, _415, _416);
  float3 vignette = float3(_457, _458, _459);
  float3 blend_vignette = lerp(pre_vignette, vignette, CUSTOM_VIGNETTE);
  _457 = blend_vignette.x;
  _458 = blend_vignette.y;
  _459 = blend_vignette.z;

  // Global chromatic aberration around a configurable center.
  if (((bool)(_102 >= 0.0010000000474974513f)) & ((bool)(_111 >= 0.0010000000474974513f))) {
    int _464 = WaveReadLaneFirst(_materialIndex);
    float _475 = _221 - WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_464 < (uint)170000), _464, 0)) + 0u))]._chromaticAberrationShiftPosition.x);
    float _476 = _222 - WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_464 < (uint)170000), _464, 0)) + 0u))]._chromaticAberrationShiftPosition.y);
    float _485 = rsqrt(dot(float2(_475, _476), float2(_475, _476))) * ((_111 * 0.009999999776482582f) * sqrt((_476 * _476) + (_475 * _475)));
    float _486 = _485 * _475;
    float _488 = _485 * _476;
    float4 _494 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2((_221 - _486), (_222 - _488)));
    float4 _496 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2(_221, _222));
    float4 _498 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2((_486 + _221), (_488 + _222)));
    _510 = (lerp(_457, _494.x, _102));
    _511 = (lerp(_458, _496.y, _102));
    _512 = (lerp(_459, _498.z, _102));
  } else {
    _510 = _414;
    _511 = _415;
    _512 = _416;
  }
  
  float3 pre_CA = float3(_414, _415, _416);
  float3 CA = float3(_510, _511, _512);
  float3 blend_CA = lerp(pre_CA, CA, CUSTOM_CHROMATIC_ABERRATION);
  _510 = blend_CA.x;
  _511 = blend_CA.y;
  _512 = blend_CA.z;

  // Detect mode tinting and contrast boosts.
  int _513 = WaveReadLaneFirst(_materialIndex);
  float _521 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_513 < (uint)170000), _513, 0)) + 0u))]._detectModeG);
  int _522 = WaveReadLaneFirst(_materialIndex);
  float _530 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_522 < (uint)170000), _522, 0)) + 0u))]._detectModeR);
  int _531 = WaveReadLaneFirst(_materialIndex);
  float _539 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_531 < (uint)170000), _531, 0)) + 0u))]._detectModeB);
  int _540 = WaveReadLaneFirst(_materialIndex);
  float _548 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_540 < (uint)170000), _540, 0)) + 0u))]._detectModeKnowledge);
  int _549 = WaveReadLaneFirst(_materialIndex);
  float _557 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_549 < (uint)170000), _549, 0)) + 0u))]._detectModeInterrupt);
  float _562 = saturate((((_530 + _521) + _539) + _548) + _557);
  [branch]
  if (_562 > 0.0f) {
    if (!(_521 >= 0.0010000000474974513f)) {
      if (!(_530 >= 0.0010000000474974513f)) {
        if (!(_539 >= 0.0010000000474974513f)) {
          if (!(!(_548 >= 0.0010000000474974513f))) {
            _574 = 0.6000000238418579f;
            _575 = 0.6000000238418579f;
            _576 = 0.800000011920929f;
            _577 = 0.5f;
            _578 = 0.44999998807907104f;
            _579 = 0.949999988079071f;
          } else {
            _574 = 0.0f;
            _575 = 0.0f;
            _576 = 0.0f;
            _577 = 0.0f;
            _578 = 0.0f;
            _579 = 0.0f;
          }
        } else {
          _574 = 0.6000000238418579f;
          _575 = 0.699999988079071f;
          _576 = 0.699999988079071f;
          _577 = 0.6000000238418579f;
          _578 = 0.699999988079071f;
          _579 = 0.800000011920929f;
        }
      } else {
        _574 = 0.699999988079071f;
        _575 = 0.6000000238418579f;
        _576 = 0.6000000238418579f;
        _577 = 0.800000011920929f;
        _578 = 0.699999988079071f;
        _579 = 0.6000000238418579f;
      }
    } else {
      _574 = 0.6000000238418579f;
      _575 = 0.699999988079071f;
      _576 = 0.6000000238418579f;
      _577 = 0.6000000238418579f;
      _578 = 0.800000011920929f;
      _579 = 0.699999988079071f;
    }
    bool _580 = (_557 >= 0.0010000000474974513f);
    float _584 = select(_580, 0.800000011920929f, _577);
    float _585 = select(_580, 0.6000000238418579f, _578);
    float _586 = select(_580, 0.20000000298023224f, _579);
    float _593 = (1.0f - _584) * 0.3086000084877014f;
    float _595 = (1.0f - _585) * 0.6093999743461609f;
    float _597 = (1.0f - _586) * 0.0820000022649765f;
    float _599 = select(_580, 2.0f, _574) * _510;
    float _600 = select(_580, 2.0f, _575) * _511;
    float _601 = select(_580, 2.0f, _576) * _512;
    float _605 = _593 * _599;
    float _610 = 0.009999999776482582f / max(0.0010000000474974513f, _exposure0.x);
    float _620 = max((abs(TEXCOORD.x + -0.5f) + -0.07500000298023224f), 0.0f);
    float _621 = max((abs(TEXCOORD.y + -0.5f) + -0.07500000298023224f), 0.0f);
    float _629 = (_562 * 0.75f) * saturate(sqrt((_621 * _621) + (_620 * _620)) * 2.0f);
    float _636 = ((mad(_601, _597, mad(_600, _595, ((_593 + _584) * _599))) - _510) * _562) + _510;
    float _637 = ((mad(_601, _597, mad(_600, (_595 + _585), _605)) - _511) * _562) + _511;
    float _638 = ((mad(_601, (_597 + _586), mad(_600, _595, _605)) - _512) * _562) + _512;
    _649 = ((_629 * ((_610 * _584) - _636)) + _636);
    _650 = ((_629 * ((_610 * _585) - _637)) + _637);
    _651 = ((_629 * ((_610 * _586) - _638)) + _638);
  } else {
    _649 = _510;
    _650 = _511;
    _651 = _512;
  }
  // Render-pass driven overlays (targets, NPC highlights, interaction effects).
  if ((((bool)(_highLightForVision > 0.0f)) | ((bool)(_characterHighlight > 0.0f))) || (_followLearning > 0.0010000000474974513f)) {
    uint2 _664; __3__36__0__0__g_CustomRenderPassValue.GetDimensions(_664.x, _664.y);
    uint _679 = __3__36__0__0__g_CustomRenderPassValue.Load(int3(int((float((int)(int(float((int)((uint)(_664.x)))))) + 0.5f) * _221), int((float((int)(int(float((int)((uint)(_664.y)))))) + 0.5f) * _222), 0));
    int _681 = _679.x & 255;
    float _689 = (float((uint)((int)((uint)((int)(_679.x)) >> 20))) * 0.0004884005174972117f) + -1.0f;
    float _690 = (float((uint)((int)(((uint)((int)(_679.x)) >> 8) & 4095))) * 0.0004884005174972117f) + -1.0f;
    float _692 = 1.0f - abs(_689);
    float _693 = abs(_690);
    float _694 = _692 - _693;
    if (!(_694 >= 0.0f)) {
      _705 = (select((_689 >= 0.0f), 1.0f, -1.0f) * (1.0f - _693));
      _706 = (select((_690 >= 0.0f), 1.0f, -1.0f) * _692);
    } else {
      _705 = _689;
      _706 = _690;
    }
    float _708 = rsqrt(dot(float3(_705, _706, _694), float3(_705, _706, _694)));
    float _709 = _708 * _705;
    float _710 = _708 * _706;
    float _711 = _708 * _694;
    float _713 = rsqrt(dot(float3(_709, _710, _711), float3(_709, _710, _711)));
    float4 _719 = __3__36__0__0__g_postProcessSizeColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2(_221, _222));
    [branch]
    if (_681 == _renderPassTest) {
      int _732 = WaveReadLaneFirst(_materialIndex);
      float _741 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_732 < (uint)170000), _732, 0)) + 0u))]._testEffectRatio) * (1.0f / max(0.0010000000474974513f, _exposure0.x));
      _936 = (_741 + _649);
      _937 = _650;
      _938 = (_741 + _651);
      _939 = _681;
    } else {
      if (!(_681 == _renderPassDetectObjective)) {
        if (_681 == _renderPassKnowledgeNPC) {
          float4 _763 = __3__36__0__0__g_noiseTex.SampleLevel(__0__4__0__0__g_staticPointWrap, float2(frac((TEXCOORD.x * 0.015625f) * _bufferSizeAndInvSize.x), frac((TEXCOORD.y * 0.015625f) * _bufferSizeAndInvSize.y)), 0.0f);
          float _766 = (_763.x * 0.5f) + 0.5f;
          _936 = ((((_766 * _719.x) - _649) * _719.w) + _649);
          _937 = ((((_766 * _719.y) - _650) * _719.w) + _650);
          _938 = ((((_766 * _719.z) - _651) * _719.w) + _651);
          _939 = _681;
        } else {
          if ((_681 == _renderPassDetectRemoteCatch) && (WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)(WaveReadLaneFirst(_materialIndex)) < (uint)170000), (WaveReadLaneFirst(_materialIndex)), 0)) + 0u))]._itemRatio) > 0.0010000000474974513f) && (_highLightForVision > 0.0f)) {
            int _799 = WaveReadLaneFirst(_materialIndex);
            int _807 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_799 < (uint)170000), _799, 0)) + 0u))]._detectColorBase);
            float _810 = float((uint)((int)(((uint)(_807) >> 16) & 255)));
            float _813 = float((uint)((int)(((uint)(_807) >> 8) & 255)));
            float _815 = float((uint)((int)(_807 & 255)));
            float _848 = max(0.0010000000474974513f, _exposure0.x);
            _936 = ((((select(((_810 * 0.003921568859368563f) < 0.040449999272823334f), (_810 * 0.0003035269910469651f), exp2(log2((_810 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) * 10.0f) / _848) * _719.w) + _649);
            _937 = ((((select(((_813 * 0.003921568859368563f) < 0.040449999272823334f), (_813 * 0.0003035269910469651f), exp2(log2((_813 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) * 10.0f) / _848) * _719.w) + _650);
            _938 = ((((select(((_815 * 0.003921568859368563f) < 0.040449999272823334f), (_815 * 0.0003035269910469651f), exp2(log2((_815 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) * 10.0f) / _848) * _719.w) + _651);
            _939 = _681;
          } else {
            bool _861 = (_681 == _renderPassSelfPlayer);
            if ((_861) || (((bool)(_681 == _renderPassTest)) | ((bool)(_681 == _renderPassEnemy))) || (_681 == _renderPassDetectPickedRemoteCatch)) {
              if (_characterHighlight > 0.0010000000474974513f) {
                float _887 = 1.0f - saturate(dot(float3((_713 * _709), (_713 * _710), (_713 * _711)), float3((-0.0f - _viewDir.x), (-0.0f - _viewDir.y), (-0.0f - _viewDir.z))));
                float _888 = _887 * _887;
                float _889 = _888 * _888;
                if (!_861) {
                  if (!(_681 == _renderPassTest)) {
                    bool _896 = (_681 == _renderPassEnemy);
                    _901 = select(_896, 1.0f, 0.20000000298023224f);
                    _902 = select(_896, 0.30000001192092896f, 0.4000000059604645f);
                    _903 = select(_896, 0.30000001192092896f, 1.0f);
                  } else {
                    _901 = 1.0f;
                    _902 = 1.0f;
                    _903 = 1.0f;
                  }
                } else {
                  _901 = 1.0f;
                  _902 = 1.0f;
                  _903 = 1.0f;
                }
                float _910 = 1.0f / max(0.0010000000474974513f, _exposure0.x);
                _936 = ((((_719.x - _649) + ((((_910 + (_649 * 10.0f)) * _901) - _719.x) * _889)) * _719.w) + _649);
                _937 = ((((_719.y - _650) + ((((_910 + (_650 * 10.0f)) * _902) - _719.y) * _889)) * _719.w) + _650);
                _938 = ((((_719.z - _651) + ((((_910 + (_651 * 10.0f)) * _903) - _719.z) * _889)) * _719.w) + _651);
                _939 = _681;
              } else {
                _936 = _649;
                _937 = _650;
                _938 = _651;
                _939 = _681;
              }
            } else {
              _936 = _649;
              _937 = _650;
              _938 = _651;
              _939 = _681;
            }
          }
        }
      } else {
        float4 _763 = __3__36__0__0__g_noiseTex.SampleLevel(__0__4__0__0__g_staticPointWrap, float2(frac((TEXCOORD.x * 0.015625f) * _bufferSizeAndInvSize.x), frac((TEXCOORD.y * 0.015625f) * _bufferSizeAndInvSize.y)), 0.0f);
        float _766 = (_763.x * 0.5f) + 0.5f;
        _936 = ((((_766 * _719.x) - _649) * _719.w) + _649);
        _937 = ((((_766 * _719.y) - _650) * _719.w) + _650);
        _938 = ((((_766 * _719.z) - _651) * _719.w) + _651);
        _939 = _681;
      }
    }
  } else {
    _936 = _649;
    _937 = _650;
    _938 = _651;
    _939 = 0;
  }
  // World-space wanted-region overlay and blend.
  if (!(!(_wantedRegionRatio >= 0.0010000000474974513f))) {
    [branch]
    if (!(!(_wantedRegionOpacity >= 0.0010000000474974513f))) {
      int _948 = WaveReadLaneFirst(_materialIndex);
      int _956 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_948 < (uint)170000), _948, 0)) + 0u))]._wantedRegionColor);
      float _959 = float((uint)((int)(((uint)(_956) >> 16) & 255)));
      float _962 = float((uint)((int)(((uint)(_956) >> 8) & 255)));
      float _964 = float((uint)((int)(_956 & 255)));
      float _997 = max(0.0010000000474974513f, _exposure0.x);
      float _1005 = _wantedRegionRadius * _wantedRegionRatio;
      float _1007 = saturate(_1005) * 4.0f;
      float _1010 = __3__36__0__0__g_depth.Sample(__0__4__0__0__g_staticBilinearClamp, float2(_221, _222));
      float _1013 = (_221 * 2.0f) + -1.0f;
      float _1015 = 1.0f - (_222 * 2.0f);
      float _1016 = max(1.0000000116860974e-07f, _1010.x);
      float _1044 = mad((_invViewProj[3].z), _1016, mad((_invViewProj[3].y), _1015, ((_invViewProj[3].x) * _1013))) + (_invViewProj[3].w);
      float _1050 = ((mad((_invViewProj[0].z), _1016, mad((_invViewProj[0].y), _1015, ((_invViewProj[0].x) * _1013))) + (_invViewProj[0].w)) / _1044) - _wantedRegionPosition.x;
      float _1051 = ((mad((_invViewProj[2].z), _1016, mad((_invViewProj[2].y), _1015, ((_invViewProj[2].x) * _1013))) + (_invViewProj[2].w)) / _1044) - _wantedRegionPosition.z;
      float _1055 = sqrt((_1050 * _1050) + (_1051 * _1051));
      float _1062 = saturate(floor(_1055 / _1005));
      float _1064 = (1.0f - _1062) * saturate(((_1007 - _1005) + _1055) / _1007);
      float _1071 = (1.0f - saturate((_1055 - _1005) / _1007)) * _1062;
      float _1075 = saturate(((_1071 * _1071) * _1071) + ((_1064 * _1064) * _1064));
      float _1078 = saturate((_1075 * 5.0f) + -4.0f);
      float _1079 = _1078 * _1078;
      float _1082 = ((_1079 * _1079) * 9.0f) + 1.0f;
      uint2 _1095 = __3__36__0__0__g_stencil.Load(int3((uint)(uint(_bufferSizeAndInvSize.x * _221)), (uint)(uint(_bufferSizeAndInvSize.y * _222)), 0));
      int _1097 = _1095.x & 127;
      float _1105 = (((float((uint)((int)((uint)(_956) >> 24))) * 0.003921568859368563f) * _wantedRegionOpacity) * _1075) * float((bool)((bool)(((bool)(_1097 != 57)) & ((bool)((uint)(_1097 + -53) > (uint)14)))));
      _1116 = ((_1105 * ((_1082 * (select(((_959 * 0.003921568859368563f) < 0.040449999272823334f), (_959 * 0.0003035269910469651f), exp2(log2((_959 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) / _997)) - _936)) + _936);
      _1117 = ((_1105 * ((_1082 * (select(((_962 * 0.003921568859368563f) < 0.040449999272823334f), (_962 * 0.0003035269910469651f), exp2(log2((_962 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) / _997)) - _937)) + _937);
      _1118 = ((_1105 * ((_1082 * (select(((_964 * 0.003921568859368563f) < 0.040449999272823334f), (_964 * 0.0003035269910469651f), exp2(log2((_964 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) / _997)) - _938)) + _938);
    } else {
      _1116 = _936;
      _1117 = _937;
      _1118 = _938;
    }
  } else {
    _1116 = _936;
    _1117 = _937;
    _1118 = _938;
  }
  // Temperature/electrocution screen effects.
  if ((((bool)(((bool)(_temperatureWarning <= -0.009999999776482582f)) | ((bool)(_temperatureWarning >= 0.009999999776482582f))))) | ((bool)(_electrocutionWarning > 0.0010000000474974513f))) {
    float4 _1130 = __3__36__0__0__g_postProcessSizeColor.Sample(__0__4__0__0__g_staticBilinearClamp, float2(_221, _222));
    float _1136 = _temperatureWarning * 0.009999999776482582f;
    if (_temperatureWarning > 0.0f) {
      float _1139 = saturate(saturate(_1136));
      float _1140 = TEXCOORD.x + -0.5f;
      float _1141 = TEXCOORD.y + -0.6000000238418579f;
      float _1149 = saturate((_1139 + -0.5f) + sqrt((_1141 * _1141) + (_1140 * _1140))) * _1139;
      float _1154 = (1.0f - (_1149 * 0.30000001192092896f)) * _1117;
      float _1155 = (1.0f - (_1149 * 0.699999988079071f)) * _1118;
      _1181 = ((_1130.x - _1116) * _1130.w);
      _1182 = (lerp(_1154, _1130.y, _1130.w));
      _1183 = (lerp(_1155, _1130.z, _1130.w));
    } else {
      float _1170 = (_1130.w * (1.0f - TEXCOORD.y)) * saturate(abs(_1136) * 2.0f);
      _1181 = (_1170 * (_1130.x - (_1116 * 0.30000001192092896f)));
      _1182 = ((_1170 * (_1130.y - (_1117 * 0.10000002384185791f))) + _1117);
      _1183 = ((_1170 * _1130.z) + _1118);
    }
    float _1184 = _1116 + _1181;
    if (!(_electrocutionWarning == 0.0f)) {
      float _1190 = max(0.0010000000474974513f, _exposure0.x);
      float _1194 = TEXCOORD.x + -0.5f;
      float _1195 = TEXCOORD.y + -0.6000000238418579f;
      float _1203 = (_electrocutionWarning * 0.5f) * saturate(sqrt((_1195 * _1195) + (_1194 * _1194)) + -0.30000001192092896f);
      float _1210 = (_1203 * ((0.05000000074505806f / _1190) - _1184)) + _1184;
      float _1211 = (_1203 * ((0.10000000149011612f / _1190) - _1182)) + _1182;
      float _1212 = (_1203 * ((0.5f / _1190) - _1183)) + _1183;
      _1223 = (lerp(_1210, _1130.x, _1130.w));
      _1224 = (lerp(_1211, _1130.y, _1130.w));
      _1225 = (lerp(_1212, _1130.z, _1130.w));
    } else {
      _1223 = _1184;
      _1224 = _1182;
      _1225 = _1183;
    }
  } else {
    _1223 = _1116;
    _1224 = _1117;
    _1225 = _1118;
  }
  // Low-health blood/vignette treatment.
  [branch]
  if (!(!(_hpPercentage <= 20.0f))) {
    float _1231 = 1.0f - (_hpPercentage * 0.009999999776482582f);
    if ((((bool)(!(_hpPercentage <= 0.0f)))) & ((bool)(_1231 >= 0.0010000000474974513f))) {
      float _1246 = _time.x * 0.30000001192092896f;
      float4 _1255 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_237 < (uint)65000), _237, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2((_1246 + (TEXCOORD.x * 12.0f)), (_1246 + (TEXCOORD.y * 6.0f))));
      float _1257 = _1255.w * 0.10000000149011612f;
      int _1260 = WaveReadLaneFirst(_materialIndex);
      int _1268 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1260 < (uint)170000), _1260, 0)) + 0u))]._borderEdgeNoiseTexture);
      float4 _1275 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_1268 < (uint)65000), _1268, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2((((TEXCOORD.x * 2.0f) + 0.30000001192092896f) + _1257), (_1257 + TEXCOORD.y)));
      float _1282 = (_hpPercentage * 0.0020000000949949026f) + 0.36000001430511475f;
      float _1285 = max((abs(TEXCOORD.x + -0.5f) - _1282), 0.0f);
      float _1286 = max((abs(TEXCOORD.y + -0.5f) - _1282), 0.0f);
      float _1298 = sin(frac(_time.x * (2.0f - (_hpPercentage * 0.05000000074505806f))) * 3.1415927410125732f);
      float _1310 = 1.0f - _222;
      float _1313 = saturate((_1310 * _1310) * 2.0f);
      float _1314 = saturate(_1298);
      bool _1321 = (_isAllowBlood != 0);
      float _1323 = (_1314 * 0.0112674031406641f) + 0.022386489436030388f;
      float _1332 = 1.0f / max(0.0010000000474974513f, _exposure0.x);
      float _1334 = select(_1321, 0.006995410192757845f, 0.04317210242152214f) * _1332;
      float _1338 = (min(max(_1231, 0.0f), 1.0f) * saturate((saturate(((_1298 * 0.19999998807907104f) + 0.800000011920929f) * saturate(sqrt((_1286 * _1286) + (_1285 * _1285)) * 3.846153974533081f)) * 2.0f) - (_1275.x * 1.440000057220459f))) * _1313;
      float _1339 = _1313 * (0.12999999523162842f - (_hpPercentage * 0.006000000052154064f));
      float _1346 = (((select(_1321, 0.215860515832901f, 0.04317210242152214f) * _1332) - _1223) * _1339) + _1223;
      float _1347 = ((_1334 - _1224) * _1339) + _1224;
      float _1348 = ((_1334 - _1225) * _1339) + _1225;
      _1359 = ((((_1332 * select(_1321, ((_1314 * 0.056337013840675354f) + 0.11193244159221649f), _1323)) - _1346) * _1338) + _1346);
      _1360 = ((((_1332 * select(_1321, ((_1314 * 0.0053743417374789715f) + 0.0021246890537440777f), _1323)) - _1347) * _1338) + _1347);
      _1361 = ((((_1332 * select(_1321, 0.0021246890537440777f, _1323)) - _1348) * _1338) + _1348);
    } else {
      _1359 = _1223;
      _1360 = _1224;
      _1361 = _1225;
    }
  } else {
    _1359 = _1223;
    _1360 = _1224;
    _1361 = _1225;
  }

  float3 pre_grading = float3(_1359, _1360, _1361);

  // Core post color grading: channel gain, saturation, contrast, invert.
  int _1362 = WaveReadLaneFirst(_materialIndex);
  float _1372 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1362 < (uint)170000), _1362, 0)) + 0u))]._channelBrightness.x);
  float _1373 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1362 < (uint)170000), _1362, 0)) + 0u))]._channelBrightness.y);
  float _1374 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1362 < (uint)170000), _1362, 0)) + 0u))]._channelBrightness.z);
  int _1375 = WaveReadLaneFirst(_materialIndex);
  float _1385 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1375 < (uint)170000), _1375, 0)) + 0u))]._saturation.x);
  float _1386 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1375 < (uint)170000), _1375, 0)) + 0u))]._saturation.y);
  float _1387 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1375 < (uint)170000), _1375, 0)) + 0u))]._saturation.z);
  int _1388 = WaveReadLaneFirst(_materialIndex);
  bool _1400 = (WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_112 < (uint)170000), _112, 0)) + 0u))]._isBloodEffect) > 0.0010000000474974513f);
  if ((_1400) & ((bool)(_isAllowBlood == 0))) {
    bool _1407 = ((bool)(_1372 > (_1373 + 0.05000000074505806f))) & ((bool)(_1372 > (_1374 + 0.05000000074505806f)));
    float _1408 = _1372 * 0.4000000059604645f;
    bool _1416 = ((bool)(_1385 > (_1386 + 0.05000000074505806f))) & ((bool)(_1385 > (_1387 + 0.05000000074505806f)));
    float _1417 = _1385 * 0.4000000059604645f;
    _1422 = select(_1407, _1408, _1372);
    _1423 = select(_1407, _1408, _1373);
    _1424 = select(_1407, _1408, _1374);
    _1425 = select(_1416, _1417, _1385);
    _1426 = select(_1416, _1417, _1386);
    _1427 = select(_1416, _1417, _1387);
  } else {
    _1422 = _1372;
    _1423 = _1373;
    _1424 = _1374;
    _1425 = _1385;
    _1426 = _1386;
    _1427 = _1387;
  }
  float _1428 = _1422 * _1359;
  float _1429 = _1423 * _1360;
  float _1430 = _1424 * _1361;
  float _1434 = (1.0f - _1425) * 0.3086000084877014f;
  float _1436 = (1.0f - _1426) * 0.6093999743461609f;
  float _1438 = (1.0f - _1427) * 0.0820000022649765f;
  float _1443 = _1434 * _1428;
  int _1448 = WaveReadLaneFirst(_materialIndex);
  float _1456 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1448 < (uint)170000), _1448, 0)) + 0u))]._contrast);
  float _1460 = max(WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1388 < (uint)170000), _1388, 0)) + 0u))]._contrast), 0.0f);
  float _1467 = max(0.0f, ((_1460 * (mad(_1430, _1438, mad(_1429, _1436, ((_1434 + _1425) * _1428))) + -0.5f)) + 0.5f));
  float _1468 = max(0.0f, ((_1460 * (mad(_1430, _1438, mad(_1429, (_1436 + _1426), _1443)) + -0.5f)) + 0.5f));
  float _1469 = max(0.0f, ((_1460 * (mad(_1430, (_1438 + _1427), mad(_1429, _1436, _1443)) + -0.5f)) + 0.5f));
  int _1470 = WaveReadLaneFirst(_materialIndex);
  float _1478 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1470 < (uint)170000), _1470, 0)) + 0u))]._invertColor);
  float _1481 = _exposure2.x * 4.0f;
  float _1491 = ((_1481 - (_1467 * 2.0f)) * _1478) + _1467;
  float _1492 = ((_1481 - (_1468 * 2.0f)) * _1478) + _1468;
  float _1493 = ((_1481 - (_1469 * 2.0f)) * _1478) + _1469;

  // float3 post_grading = float3(_1491, _1492, _1493);
  // float3 final_grading = lerp(pre_grading, post_grading, 0.f);
  // _1491 = final_grading.x;
  // _1492 = final_grading.y;
  // _1493 = final_grading.z;

  int _1494 = WaveReadLaneFirst(_materialIndex);
  float _1502 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1494 < (uint)170000), _1494, 0)) + 0u))]._borderRatio);
  // Border mask and border color composition.
  [branch]
  if (!(!(_1502 >= 0.0010000000474974513f))) {
    int _1505 = WaveReadLaneFirst(_materialIndex);
    int _1518 = WaveReadLaneFirst(_materialIndex);
    int _1531 = WaveReadLaneFirst(_materialIndex);
    int _1539 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1531 < (uint)170000), _1531, 0)) + 0u))]._borderEdgeNoiseTexture);
    float4 _1546 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_1539 < (uint)65000), _1539, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2((WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1518 < (uint)170000), _1518, 0)) + 0u))]._borderEdgeNoiseOffset.x) + (WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1505 < (uint)170000), _1505, 0)) + 0u))]._borderEdgeNoiseTile.x) * TEXCOORD.x)), (WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1518 < (uint)170000), _1518, 0)) + 0u))]._borderEdgeNoiseOffset.y) + (WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1505 < (uint)170000), _1505, 0)) + 0u))]._borderEdgeNoiseTile.y) * TEXCOORD.y))));
    int _1548 = WaveReadLaneFirst(_materialIndex);
    int _1557 = WaveReadLaneFirst(_materialIndex);
    float _1571 = (1.0f - WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1557 < (uint)170000), _1557, 0)) + 0u))]._borderWidth)) * 0.5f;
    float _1574 = max((abs(TEXCOORD.x + -0.5f) - _1571), 0.0f);
    float _1575 = max((abs(TEXCOORD.y + -0.5f) - _1571), 0.0f);
    float _1584 = 1.0f - ((1.0f - saturate(sqrt((_1575 * _1575) + (_1574 * _1574)) / WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1548 < (uint)170000), _1548, 0)) + 0u))]._borderSmoothness))) * 2.0f);
    int _1585 = WaveReadLaneFirst(_materialIndex);
    float _1593 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1585 < (uint)170000), _1585, 0)) + 0u))]._borderFlickerSpeed);
    if (_1593 > 0.0010000000474974513f) {
      int _1596 = WaveReadLaneFirst(_materialIndex);
      int _1614 = WaveReadLaneFirst(_materialIndex);
      _1626 = ((min(max(sin((_1593 * 3.1415927410125732f) * _time.x), WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1596 < (uint)170000), _1596, 0)) + 0u))]._borderFlickerOpacityMinMax.x)), WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1596 < (uint)170000), _1596, 0)) + 0u))]._borderFlickerOpacityMinMax.y)) * _1584) * WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1614 < (uint)170000), _1614, 0)) + 0u))]._borderFlickerIntensity));
    } else {
      _1626 = _1584;
    }
    int _1628 = WaveReadLaneFirst(_materialIndex);
    float _1642 = min(max(_1502, 0.0f), 1.0f) * saturate(saturate(_1626) - (WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1628 < (uint)170000), _1628, 0)) + 0u))]._borderEdgeNoiseRatio) * _1546.x));
    int _1643 = WaveReadLaneFirst(_materialIndex);
    int _1651 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1643 < (uint)170000), _1643, 0)) + 0u))]._borderColor);
    float _1654 = float((uint)((int)(((uint)(_1651) >> 16) & 255)));
    float _1657 = float((uint)((int)(((uint)(_1651) >> 8) & 255)));
    float _1659 = float((uint)((int)(_1651 & 255)));
    float _1684 = select(((_1654 * 0.003921568859368563f) < 0.040449999272823334f), (_1654 * 0.0003035269910469651f), exp2(log2((_1654 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
    bool _1690 = (_1400) & ((bool)(_isAllowBlood == 0));
    float _1691 = _1684 * 0.4000000059604645f;
    float _1698 = 1.0f / max(0.0010000000474974513f, _exposure0.x);
    _1712 = ((((select(_1690, _1691, _1684) * _1698) - _1491) * _1642) + _1491);
    _1713 = ((((select(_1690, _1691, select(((_1657 * 0.003921568859368563f) < 0.040449999272823334f), (_1657 * 0.0003035269910469651f), exp2(log2((_1657 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f))) * _1698) - _1492) * _1642) + _1492);
    _1714 = ((((select(_1690, _1691, select(((_1659 * 0.003921568859368563f) < 0.040449999272823334f), (_1659 * 0.0003035269910469651f), exp2(log2((_1659 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f))) * _1698) - _1493) * _1642) + _1493);
  } else {
    _1712 = _1491;
    _1713 = _1492;
    _1714 = _1493;
  }
  // Additional status-vignette color overlays.
  [branch]
  if (!(!(_57 >= 0.0010000000474974513f))) {
    float _1717 = TEXCOORD.x + -0.5f;
    float _1718 = TEXCOORD.y + -0.5f;
    int _1723 = WaveReadLaneFirst(_materialIndex);
    int _1737 = WaveReadLaneFirst(_materialIndex);
    float _1750 = saturate(exp2(log2(abs(0.5f - TEXCOORD.x)) * WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1737 < (uint)170000), _1737, 0)) + 0u))]._statusVignettePower2)) * (sqrt((_1718 * _1718) + (_1717 * _1717)) / max(0.0010000000474974513f, (1.0f - WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1723 < (uint)170000), _1723, 0)) + 0u))]._statusVignetteRadius2)))));
    float _1755 = saturate(_57 * 10.0f) * saturate(_1750 * 2.0f);
    float _1762 = (_1755 * (_457 - _1712)) + _1712;
    float _1763 = (_1755 * (_458 - _1713)) + _1713;
    float _1764 = (_1755 * (_459 - _1714)) + _1714;
    int _1765 = WaveReadLaneFirst(_materialIndex);
    int _1773 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1765 < (uint)170000), _1765, 0)) + 0u))]._statusVignetteColor2);
    float _1776 = float((uint)((int)(((uint)(_1773) >> 16) & 255)));
    float _1779 = float((uint)((int)(((uint)(_1773) >> 8) & 255)));
    float _1781 = float((uint)((int)(_1773 & 255)));
    float _1806 = select(((_1776 * 0.003921568859368563f) < 0.040449999272823334f), (_1776 * 0.0003035269910469651f), exp2(log2((_1776 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
    bool _1812 = (_1400) & ((bool)(_isAllowBlood == 0));
    float _1813 = _1806 * 0.20000000298023224f;
    float _1820 = max(0.0010000000474974513f, _exposure0.x);
    float _1827 = saturate(_1750) * _57;
    _1835 = ((((select(_1812, _1813, _1806) / _1820) - _1762) * _1827) + _1762);
    _1836 = ((((select(_1812, _1813, select(((_1779 * 0.003921568859368563f) < 0.040449999272823334f), (_1779 * 0.0003035269910469651f), exp2(log2((_1779 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f))) / _1820) - _1763) * _1827) + _1763);
    _1837 = ((((select(_1812, _1813, select(((_1781 * 0.003921568859368563f) < 0.040449999272823334f), (_1781 * 0.0003035269910469651f), exp2(log2((_1781 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f))) / _1820) - _1764) * _1827) + _1764);
  } else {
    _1835 = _1712;
    _1836 = _1713;
    _1837 = _1714;
  }
  [branch]
  if (!(!(_48 >= 0.0010000000474974513f))) {
    float _1840 = TEXCOORD.x + -0.5f;
    float _1841 = TEXCOORD.y + -0.5f;
    int _1846 = WaveReadLaneFirst(_materialIndex);
    int _1859 = WaveReadLaneFirst(_materialIndex);
    float _1872 = saturate(exp2(log2(1.0f - TEXCOORD.y) * WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1859 < (uint)170000), _1859, 0)) + 0u))]._statusVignettePower1)) * (sqrt((_1841 * _1841) + (_1840 * _1840)) / max(0.0010000000474974513f, (1.0f - WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1846 < (uint)170000), _1846, 0)) + 0u))]._statusVignetteRadius1)))));
    float _1875 = saturate(_48 * 10.0f) * _1872;
    float _1882 = (_1875 * (_457 - _1835)) + _1835;
    float _1883 = (_1875 * (_458 - _1836)) + _1836;
    float _1884 = (_1875 * (_459 - _1837)) + _1837;
    int _1885 = WaveReadLaneFirst(_materialIndex);
    int _1893 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1885 < (uint)170000), _1885, 0)) + 0u))]._statusVignetteColor1);
    float _1896 = float((uint)((int)(((uint)(_1893) >> 16) & 255)));
    float _1899 = float((uint)((int)(((uint)(_1893) >> 8) & 255)));
    float _1901 = float((uint)((int)(_1893 & 255)));
    float _1926 = select(((_1896 * 0.003921568859368563f) < 0.040449999272823334f), (_1896 * 0.0003035269910469651f), exp2(log2((_1896 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
    bool _1932 = (_1400) & ((bool)(_isAllowBlood == 0));
    float _1933 = _1926 * 0.20000000298023224f;
    float _1940 = max(0.0010000000474974513f, _exposure0.x);
    float _1947 = saturate(_1872) * _48;
    _1955 = ((((select(_1932, _1933, _1926) / _1940) - _1882) * _1947) + _1882);
    _1956 = ((((select(_1932, _1933, select(((_1899 * 0.003921568859368563f) < 0.040449999272823334f), (_1899 * 0.0003035269910469651f), exp2(log2((_1899 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f))) / _1940) - _1883) * _1947) + _1883);
    _1957 = ((((select(_1932, _1933, select(((_1901 * 0.003921568859368563f) < 0.040449999272823334f), (_1901 * 0.0003035269910469651f), exp2(log2((_1901 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f))) / _1940) - _1884) * _1947) + _1884);
  } else {
    _1955 = _1835;
    _1956 = _1836;
    _1957 = _1837;
  }
  [branch]
  if (!(!(_66 >= 0.0010000000474974513f))) {
    float _1960 = TEXCOORD.x + -0.5f;
    float _1961 = TEXCOORD.y + -0.5f;
    int _1966 = WaveReadLaneFirst(_materialIndex);
    int _1978 = WaveReadLaneFirst(_materialIndex);
    float _1991 = saturate(exp2(log2(TEXCOORD.y) * WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1978 < (uint)170000), _1978, 0)) + 0u))]._statusVignettePower3)) * (sqrt((_1961 * _1961) + (_1960 * _1960)) / max(0.0010000000474974513f, (1.0f - WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_1966 < (uint)170000), _1966, 0)) + 0u))]._statusVignetteRadius3)))));
    float _1994 = saturate(_66 * 10.0f) * _1991;
    float _2001 = (_1994 * (_457 - _1955)) + _1955;
    float _2002 = (_1994 * (_458 - _1956)) + _1956;
    float _2003 = (_1994 * (_459 - _1957)) + _1957;
    int _2004 = WaveReadLaneFirst(_materialIndex);
    int _2012 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_2004 < (uint)170000), _2004, 0)) + 0u))]._statusVignetteColor3);
    float _2015 = float((uint)((int)(((uint)(_2012) >> 16) & 255)));
    float _2018 = float((uint)((int)(((uint)(_2012) >> 8) & 255)));
    float _2020 = float((uint)((int)(_2012 & 255)));
    float _2045 = select(((_2015 * 0.003921568859368563f) < 0.040449999272823334f), (_2015 * 0.0003035269910469651f), exp2(log2((_2015 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
    bool _2051 = (_1400) & ((bool)(_isAllowBlood == 0));
    float _2052 = _2045 * 0.20000000298023224f;
    float _2059 = max(0.0010000000474974513f, _exposure0.x);
    float _2066 = saturate(_1991) * _66;
    _2074 = ((((select(_2051, _2052, _2045) / _2059) - _2001) * _2066) + _2001);
    _2075 = ((((select(_2051, _2052, select(((_2018 * 0.003921568859368563f) < 0.040449999272823334f), (_2018 * 0.0003035269910469651f), exp2(log2((_2018 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f))) / _2059) - _2002) * _2066) + _2002);
    _2076 = ((((select(_2051, _2052, select(((_2020 * 0.003921568859368563f) < 0.040449999272823334f), (_2020 * 0.0003035269910469651f), exp2(log2((_2020 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f))) / _2059) - _2003) * _2066) + _2003);
  } else {
    _2074 = _1955;
    _2075 = _1956;
    _2076 = _1957;
  }
  // Hide-state desaturation/fade.
  [branch]
  if (!(!(_hideStateRatio >= 0.0010000000474974513f))) {
    float _2081 = _hideStateRatio * 0.5f;
    float _2082 = TEXCOORD.x + -0.5f;
    float _2083 = TEXCOORD.y + -0.5f;
    float _2091 = saturate(((_2081 + -0.5f) + sqrt((_2083 * _2083) + (_2082 * _2082))) * 2.0f);
    float _2099 = saturate(((saturate(abs(0.5f - TEXCOORD.y) * 2.0f) - _2091) * 0.5f) + _2091);
    float _2107 = (((_2099 * _2099) * 0.8999999761581421f) * saturate(_hideStateRatio * 4.0f)) * (3.0f - (_2099 * 2.0f));
    float _2110 = dot(float3(_2074, _2075, _2076), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) * (1.0f - _2081);
    float _2113 = (pow(_2107, 0.5f));
    float _2120 = ((_2110 - _2074) * _2113) + _2074;
    float _2121 = ((_2110 - _2075) * _2113) + _2075;
    float _2122 = ((_2110 - _2076) * _2113) + _2076;
    float _2126 = 0.0010000000474974513f / max(0.0010000000474974513f, _exposure0.x);
    _2137 = (lerp(_2120, _2126, _2107));
    _2138 = (lerp(_2121, _2126, _2107));
    _2139 = (lerp(_2122, _2126, _2107));
  } else {
    _2137 = _2074;
    _2138 = _2075;
    _2139 = _2076;
  }
  // Follow-learning effect stack and edge glow logic.
  if (_followLearning > 0.0010000000474974513f) {
    int _2144 = WaveReadLaneFirst(_materialIndex);
    int _2152 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_2144 < (uint)170000), _2144, 0)) + 0u))]._followLearningColor);
    float _2155 = float((uint)((int)(((uint)(_2152) >> 16) & 255)));
    float _2158 = float((uint)((int)(((uint)(_2152) >> 8) & 255)));
    float _2160 = float((uint)((int)(_2152 & 255)));
    float _2190 = max(0.0010000000474974513f, _exposure0.x);
    float _2191 = select(((_2155 * 0.003921568859368563f) < 0.040449999272823334f), (_2155 * 0.0003035269910469651f), exp2(log2((_2155 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) / _2190;
    float _2192 = select(((_2158 * 0.003921568859368563f) < 0.040449999272823334f), (_2158 * 0.0003035269910469651f), exp2(log2((_2158 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) / _2190;
    float _2193 = select(((_2160 * 0.003921568859368563f) < 0.040449999272823334f), (_2160 * 0.0003035269910469651f), exp2(log2((_2160 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)) / _2190;
    int _2194 = WaveReadLaneFirst(_materialIndex);
    int _2202 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_2194 < (uint)170000), _2194, 0)) + 0u))]._followLearningNoiseTex);
    float4 _2213 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_237 < (uint)65000), _237, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2(_221, ((_time.x * 0.20000000298023224f) + _222)));
    float _2220 = __3__36__0__0__g_depth.Sample(__0__4__0__0__g_staticBilinearClamp, float2(_221, _222));
    float _2223 = (_221 * 2.0f) + -1.0f;
    float _2225 = 1.0f - (_222 * 2.0f);
    float _2226 = max(1.0000000116860974e-07f, _2220.x);
    float _2262 = mad((_invViewProj[3].z), _2226, mad((_invViewProj[3].y), _2225, ((_invViewProj[3].x) * _2223))) + (_invViewProj[3].w);
    uint _2271 = uint(_bufferSizeAndInvSize.x * _221);
    uint _2272 = uint(_bufferSizeAndInvSize.y * _222);
    uint4 _2274 = __3__36__0__0__g_gbufferBaseColor.Load(int3(_2271, _2272, 0));
    float4 _2277 = __3__36__0__0__g_gbufferNormal.Load(int3(_2271, _2272, 0));
    float _2295 = (saturate(_2277.x * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _2296 = (saturate(_2277.y * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _2297 = (saturate(_2277.z * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _2299 = rsqrt(dot(float3(_2295, _2296, _2297), float3(_2295, _2296, _2297)));
    float _2300 = _2299 * _2295;
    float _2301 = _2299 * _2296;
    float _2302 = _2297 * _2299;
    float _2305 = (float((uint)((int)(((uint)((int)(_2274.w)) >> 8) & 255))) * 0.007843137718737125f) + -1.0f;
    float _2306 = (float((uint)((int)(_2274.w & 255))) * 0.007843137718737125f) + -1.0f;
    float _2309 = (_2305 + _2306) * 0.5f;
    float _2310 = (_2305 - _2306) * 0.5f;
    float _2314 = (1.0f - abs(_2309)) - abs(_2310);
    float _2316 = rsqrt(dot(float3(_2309, _2310, _2314), float3(_2309, _2310, _2314)));
    float _2317 = _2316 * _2309;
    float _2318 = _2316 * _2310;
    float _2319 = _2316 * _2314;
    float _2321 = select((_2302 >= 0.0f), 1.0f, -1.0f);
    float _2324 = -0.0f - (1.0f / (_2321 + _2302));
    float _2325 = _2301 * _2324;
    float _2326 = _2325 * _2300;
    float _2327 = _2321 * _2300;
    float _2336 = mad(_2319, _2300, mad(_2318, _2326, ((((_2327 * _2300) * _2324) + 1.0f) * _2317)));
    float _2340 = mad(_2319, _2301, mad(_2318, (_2321 + (_2325 * _2301)), ((_2317 * _2321) * _2326)));
    float _2344 = mad(_2319, _2302, mad(_2318, (-0.0f - _2301), (-0.0f - (_2327 * _2317))));
    float _2346 = rsqrt(dot(float3(_2336, _2340, _2344), float3(_2336, _2340, _2344)));
    float _2348 = _2346 * _2340;
    float _2349 = _2346 * _2344;
    float _2352 = _time.x * 0.5f;
    float _2355 = (((mad((_invViewProj[2].z), _2226, mad((_invViewProj[2].y), _2225, ((_invViewProj[2].x) * _2223))) + (_invViewProj[2].w)) / _2262) - _2352) * 0.20000000298023224f;
    float _2356 = (((mad((_invViewProj[1].z), _2226, mad((_invViewProj[1].y), _2225, ((_invViewProj[1].x) * _2223))) + (_invViewProj[1].w)) / _2262) - _2352) * 0.20000000298023224f;
    float4 _2363 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_2202 < (uint)65000), _2202, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2(_2355, _2356));
    float _2366 = (((mad((_invViewProj[0].z), _2226, mad((_invViewProj[0].y), _2225, ((_invViewProj[0].x) * _2223))) + (_invViewProj[0].w)) / _2262) - _2352) * 0.20000000298023224f;
    float4 _2367 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_2202 < (uint)65000), _2202, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2(_2366, _2355));
    float4 _2369 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_2202 < (uint)65000), _2202, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2(_2366, _2356));
    float _2375 = (abs(_2348) * (_2367.w - _2363.w)) + _2363.w;
    float _2378 = ((_2369.w - _2375) * abs(_2349)) + _2375;
    float _2379 = _2213.z + -0.5f;
    float _2384 = _221 + -0.5f;
    float _2386 = _222 + -0.5f;
    float _2391 = 0.375f - (_2379 * 0.25f);
    float _2394 = max((abs(((_2213.x + -0.5f) * 0.10000000149011612f) + _2384) - _2391), 0.0f);
    float _2395 = max((abs(((_2213.y + -0.5f) * 0.10000000149011612f) + _2386) - _2391), 0.0f);
    float _2400 = saturate(sqrt((_2395 * _2395) + (_2394 * _2394)));
    float _2404 = saturate(_followLearning * 2.0f);
    float _2410 = saturate(((((_2220.x * 100.0f) * _2404) - _2378) * 2.0f) + -0.5f);
    float _2420 = sqrt((_2386 * _2386) + (_2384 * _2384));
    float _2423 = ((saturate((_2404 * 2.0f) + -1.0f) * (1.0f - _2410)) + _2410) * saturate(_2420 + 0.5f);
    float _2425 = atan(_2386 / _2384);
    bool _2428 = (_2384 < 0.0f);
    bool _2429 = (_2384 == 0.0f);
    bool _2430 = (_2386 >= 0.0f);
    bool _2431 = (_2386 < 0.0f);
    float _2443 = _2378 * 0.5f;
    float4 _2456 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_2202 < (uint)65000), _2202, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2(((((_2379 * -0.5f) - _2443) - (_time.x * 0.20000000298023224f)) + select(((_2429) & (_2430)), 7.5f, select(((_2429) & (_2431)), -7.5f, (select(((_2428) & (_2431)), (_2425 + -3.1415927410125732f), select(((_2428) & (_2430)), (_2425 + 3.1415927410125732f), _2425)) * 4.774648189544678f)))), (((((_2213.w + -0.5f) * -0.5f) - _2443) + (_2420 * 2.0f)) - (_time.x * 1.5f))));
    float4 _2466 = __3__36__0__0__g_CustomRenderPassDepth.Load(int3(int(_customRenderPassSizeInvSize.x * _221), int(_customRenderPassSizeInvSize.y * _222), 0));
    float _2470 = __3__36__0__0__g_depth.Sample(__0__4__0__0__g_staticBilinearClamp, float2(_221, _222));
    if (!(_939 == _renderPassSelfPlayer)) {
      _2491 = (_939 != _renderPassTest);
    } else {
      _2491 = false;
    }
    bool _2492 = !((1.0f - saturate(ceil(((_nearFarProj.x / max(1.0000000116860974e-07f, _2470.x)) + 0.5f) - (_nearFarProj.x / max(1.0000000116860974e-07f, _2466.x))))) == 0.0f);
    bool _2493 = (_2492) | (_2491);
    if (!(_939 == _renderPassTargetFocus)) {
      if ((_2492) | ((bool)(_939 != _renderPassLearning))) {
        _2507 = (_939 != _renderPassAimHighlight);
      } else {
        _2507 = false;
      }
    } else {
      if (_2492) {
        _2507 = (_939 != _renderPassAimHighlight);
      } else {
        _2507 = false;
      }
    }
    float _2509 = saturate(_followLearning * 4.0f);
    float _2516 = (_2509 * (_225.x - _2137)) + _2137;
    float _2517 = (_2509 * (_225.y - _2138)) + _2138;
    float _2518 = (_2509 * (_225.z - _2139)) + _2139;
    bool _2519 = (_2493) & (_2507);
    if (_2519) {
      float _2526 = ((_followLearning * 0.25f) * _2456.w) * saturate(_2420 - (_2509 * 0.20000000298023224f));
      float4 _2530 = __3__36__0__0__g_sceneColor.Sample(__0__4__0__0__g_staticBilinearWrap, float2((_2526 + _221), (_2526 + _222)));
      float _2544 = 1.0f - (_followLearning * 0.75f);
      _2554 = ((lerp(_2516, _2530.x, _2509)) * _2544);
      _2555 = ((lerp(_2517, _2530.y, _2509)) * _2544);
      _2556 = ((lerp(_2518, _2530.z, _2509)) * _2544);
      _2557 = _2423;
    } else {
      if (!_2493) {
        _2554 = _2516;
        _2555 = _2517;
        _2556 = _2518;
        _2557 = (_2423 * 0.4000000059604645f);
      } else {
        _2554 = _2516;
        _2555 = _2517;
        _2556 = _2518;
        _2557 = select(_2507, _2423, 0.0f);
      }
    }
    float _2558 = dot(float3(_2554, _2555, _2556), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    float _2565 = ((_2558 - _2554) * _2557) + _2554;
    float _2566 = ((_2558 - _2555) * _2557) + _2555;
    float _2567 = ((_2558 - _2556) * _2557) + _2556;
    float _2569 = _2378 * (_2213.z * 0.30000001192092896f);
    float _2575 = saturate(_2557 * 5.0f) * 0.8999999761581421f;
    float _2582 = (((_2569 * _2191) - _2565) * _2575) + _2565;
    float _2583 = (((_2569 * _2192) - _2566) * _2575) + _2566;
    float _2584 = (((_2569 * _2193) - _2567) * _2575) + _2567;
    int _2585 = WaveReadLaneFirst(_materialIndex);
    int _2593 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_2585 < (uint)170000), _2585, 0)) + 0u))]._followLearningSaturationTone);
    float _2596 = float((uint)((int)(((uint)(_2593) >> 16) & 255)));
    float _2599 = float((uint)((int)(((uint)(_2593) >> 8) & 255)));
    float _2601 = float((uint)((int)(_2593 & 255)));
    float _2626 = select(((_2596 * 0.003921568859368563f) < 0.040449999272823334f), (_2596 * 0.0003035269910469651f), exp2(log2((_2596 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
    float _2627 = select(((_2599 * 0.003921568859368563f) < 0.040449999272823334f), (_2599 * 0.0003035269910469651f), exp2(log2((_2599 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
    float _2628 = select(((_2601 * 0.003921568859368563f) < 0.040449999272823334f), (_2601 * 0.0003035269910469651f), exp2(log2((_2601 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f));
    float _2632 = (1.0f - _2626) * 0.3086000084877014f;
    float _2634 = (1.0f - _2627) * 0.6093999743461609f;
    float _2636 = (1.0f - _2628) * 0.0820000022649765f;
    float _2641 = _2632 * _2582;
    float _2654 = (_followLearning * (mad(_2584, _2636, mad(_2583, _2634, ((_2632 + _2626) * _2582))) - _2582)) + _2582;
    float _2655 = (_followLearning * (mad(_2584, _2636, mad(_2583, (_2634 + _2627), _2641)) - _2583)) + _2583;
    float _2656 = (_followLearning * (mad(_2584, (_2636 + _2628), mad(_2583, _2634, _2641)) - _2584)) + _2584;
    if (!_2519) {
      float _2670 = saturate(1.0f - dot(float3((_2443 + (_2346 * _2336)), (_2443 + _2348), (_2443 + _2349)), float3((-0.0f - _viewDir.x), (-0.0f - _viewDir.y), (-0.0f - _viewDir.z))));
      float _2675 = select(_2493, ((_2670 * _2670) * 6.0f), (_2670 * 0.25f)) * _2670;
      float _2679 = (_followLearning * _followLearning) * saturate(_2378 * 10.0f);
      _2690 = (((_2679 * _2191) * _2675) + _2654);
      _2691 = (((_2679 * _2192) * _2675) + _2655);
      _2692 = (((_2679 * _2193) * _2675) + _2656);
    } else {
      _2690 = _2654;
      _2691 = _2655;
      _2692 = _2656;
    }
    float _2693 = _followLearning * _2400;
    float _2697 = 0.0010000000474974513f / max(0.0010000000474974513f, _exposure0.x);
    float _2704 = ((_2697 - _2690) * _2693) + _2690;
    float _2705 = ((_2697 - _2691) * _2693) + _2691;
    float _2706 = ((_2697 - _2692) * _2693) + _2692;
    float _2711 = saturate(((_2456.w * _2456.w) * 20.0f) * _followLearning) * _2400;
    _2722 = (lerp(_2704, _2191, _2711));
    _2723 = (lerp(_2705, _2192, _2711));
    _2724 = (lerp(_2706, _2193, _2711));
  } else {
    _2722 = _2137;
    _2723 = _2138;
    _2724 = _2139;
  }
  // Enemy alert overlay.
  [branch]
  if ((dot(float4(_enemyAlert1.x, _enemyAlert1.y, _enemyAlert1.z, _enemyAlert1.w), float4(1.0f, 1.0f, 1.0f, 1.0f)) > 0.0f) || (dot(float4(_enemyAlert2.x, _enemyAlert2.y, _enemyAlert2.z, _enemyAlert2.w), float4(1.0f, 1.0f, 1.0f, 1.0f)) > 0.0f)) {
    bool _2743 = (_isAllowBlood != 0);
    float _2749 = max(0.0010000000474974513f, _exposure0.x);
    float4 _2766 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_237 < (uint)65000), _237, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearWrap, float2(((TEXCOORD.x * 2.0f) * _34), ((_time.x * 0.10000000149011612f) + (TEXCOORD.y * 2.0f))));
    float _2769 = _2766.x + -0.5f;
    float _2770 = _2766.y + -0.5f;
    float _2780 = 0.44999998807907104f - (_2769 * 0.004999999888241291f);
    float _2783 = max((abs((TEXCOORD.x + -0.5f) + (_2769 * 0.019999999552965164f)) - _2780), 0.0f);
    float _2784 = max((abs((TEXCOORD.y + -0.5f) + (_2770 * 0.019999999552965164f)) - _2780), 0.0f);
    int _2795 = WaveReadLaneFirst(_materialIndex);
    int _2803 = WaveReadLaneFirst(BindlessParameters_PostProcessUber_CD[((uint)((int)(select(((uint)_2795 < (uint)170000), _2795, 0)) + 0u))]._enemyAlertTex);
    float4 _2810 = __0__7__0__0__g_bindlessTextures[((uint)((int)(select(((uint)_2803 < (uint)65000), _2803, 0)) + 0u))].Sample(__0__4__0__0__g_staticBilinearClamp, float2((TEXCOORD.x - (_2770 * 0.029999999329447746f)), (TEXCOORD.y - (_2769 * 0.029999999329447746f))));
    bool _2815 = (TEXCOORD.y > 0.5f);
    bool _2817 = (TEXCOORD.x < 0.5f);
    bool _2821 = (TEXCOORD.y < 0.5f);
    bool _2829 = (TEXCOORD.x > 0.5f);
    float _2853 = saturate(dot(float4((_2810.x * float((bool)_2821)), (_2810.y * float((bool)((bool)((_2829) & (_2821))))), (_2810.z * float((bool)_2829)), (_2810.w * float((bool)((bool)((_2829) & (_2815)))))), float4(_enemyAlert2.x, _enemyAlert2.y, _enemyAlert2.z, _enemyAlert2.w)) + dot(float4((_2810.x * float((bool)_2815)), (_2810.y * float((bool)((bool)((_2817) & (_2815))))), (_2810.z * float((bool)_2817)), (_2810.w * float((bool)((bool)((_2817) & (_2821)))))), float4(_enemyAlert1.x, _enemyAlert1.y, _enemyAlert1.z, _enemyAlert1.w))) * saturate(sqrt((_2784 * _2784) + (_2783 * _2783)) * 20.0f);
    float _2855 = (_2853 * _2853) * _2853;
    _2866 = ((_2855 * ((select(_2743, 0.09989875555038452f, 0.08437622338533401f) / _2749) - _2722)) + _2722);
    _2867 = ((_2855 * ((select(_2743, 0.027320895344018936f, 0.030713455751538277f) / _2749) - _2723)) + _2723);
    _2868 = ((_2855 * ((select(_2743, 0.04817182570695877f, 0.07036010921001434f) / _2749) - _2724)) + _2724);
  } else {
    _2866 = _2722;
    _2867 = _2723;
    _2868 = _2724;
  }
  uint _2869 = uint(SV_Position.y);
  if (_etcParams.y == 1.0f) {
    uint2 _2876 = __3__36__0__0__g_stencil.Load(int3((uint)(uint(SV_Position.x)), _2869, 0));
    _2882 = (float((uint)((int)(_2876.x & 127))) + 0.5f);
  } else {
    _2882 = 1.0f;
  }

  float3 pre_localexposure = float3(_2866, _2867, _2868);

  // Tone mapping
  bool _2885 = (_localToneMappingParams.w > 0.0f);
  if (_2885) {
    float new_exposure = _exposure0.x;
    //if (IMPROVED_AUTO_EXPOSURE_V2 == 1) new_exposure = min(_exposure0.x, 2.0f * IMPROVED_AUTO_EXPOSURE_V2_FLOOR);

    float _2891 = _userImageAdjust.z * new_exposure;

    float _2940 = exp2(log2(max(0.0f, (((_2891 * max(0.0f, (((_2866 * 1.705049991607666f) - (_2867 * 0.6217899918556213f)) - (_2868 * 0.08325999975204468f)))) * _slopeParams.x) + _offsetParams.x))) * _powerParams.x);
    float _2941 = exp2(log2(max(0.0f, (((max(0.0f, (((_2867 * 1.1407999992370605f) - (_2866 * 0.13026000559329987f)) - (_2868 * 0.01054999977350235f))) * _2891) * _slopeParams.y) + _offsetParams.y))) * _powerParams.y);
    float _2942 = exp2(log2(max(0.0f, (((max(0.0f, (((_2866 * -0.024000000208616257f) - (_2867 * 0.12896999716758728f)) + (_2868 * 1.1529699563980103f))) * _2891) * _slopeParams.z) + _offsetParams.z))) * _powerParams.z);
    float _2944 = dot(float3(_2940, _2941, _2942), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _2951 = ((_2940 - _2944) * _powerParams.w) + _2944;
    float _2952 = ((_2941 - _2944) * _powerParams.w) + _2944;
    float _2953 = ((_2942 - _2944) * _powerParams.w) + _2944;

    if (RENODX_TONE_MAP_TYPE != 0) {
      float3 untonemapped_bt709 = float3(_2951, _2952, _2953);
      // float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(float3(_2866, _2867, _2868) * _2891); // test color

      const float mid_gray = 0.18f;
      float mid_gray_adjusted = SDRToneMap(mid_gray).x;
      float mid_gray_scale = mid_gray_adjusted / mid_gray;
      //untonemapped_bt709 *= mid_gray_scale;

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

      float3 output_color = CustomTonemapSDR(untonemapped_bt709, mid_gray_scale, histogram_mean * _2891, histogram_target_mean * _2891);
      _3163 = output_color.r;
      _3164 = output_color.g;
      _3165 = output_color.b;
    }
    else {
      // float3 ungraded = float3(_2951, _2952, _2953);
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
      // _2951 = graded.r;
      // _2952 = graded.g;
      // _2953 = graded.b;

    float _2972 = min(max(log2(mad(_2953, 0.07922374457120895f, mad(_2952, 0.07843360304832458f, (_2951 * 0.8424790501594543f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
    float _2973 = min(max(log2(mad(_2953, 0.07916612923145294f, mad(_2952, 0.8784686326980591f, (_2951 * 0.04232824221253395f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
    float _2974 = min(max(log2(mad(_2953, 0.8791429996490479f, mad(_2952, 0.07843360304832458f, (_2951 * 0.042375653982162476f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
    float _2975 = _2972 * 0.06060606241226196f;
    float _2976 = _2973 * 0.06060606241226196f;
    float _2977 = _2974 * 0.06060606241226196f;
    float _2978 = _2975 * _2975;
    float _2979 = _2976 * _2976;
    float _2980 = _2977 * _2977;
    float _3026 = min(0.0f, (-0.0f - (((_2972 * 0.007218181621283293f) + ((_2978 * 0.42980000376701355f) + (((_2978 * _2978) * ((31.959999084472656f - (_2972 * 2.432727336883545f)) + (_2978 * 15.5f))) - ((_2972 * 0.41624245047569275f) * _2978)))) + -0.002319999970495701f)));
    float _3027 = min(0.0f, (-0.0f - (((_2973 * 0.007218181621283293f) + ((_2979 * 0.42980000376701355f) + (((_2979 * _2979) * ((31.959999084472656f - (_2973 * 2.432727336883545f)) + (_2979 * 15.5f))) - ((_2973 * 0.41624245047569275f) * _2979)))) + -0.002319999970495701f)));
    float _3028 = min(0.0f, (-0.0f - (((_2974 * 0.007218181621283293f) + ((_2980 * 0.42980000376701355f) + (((_2980 * _2980) * ((31.959999084472656f - (_2974 * 2.432727336883545f)) + (_2980 * 15.5f))) - ((_2974 * 0.41624245047569275f) * _2980)))) + -0.002319999970495701f)));
    float _3029 = -0.0f - _3026;
    float _3030 = -0.0f - _3027;
    float _3031 = -0.0f - _3028;
    float _3032 = dot(float3(_3029, _3030, _3031), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    float _3038 = saturate((_exposure2.x + -3.0f) * 0.1428571492433548f) * 0.20000004768371582f;
    float _3039 = _3038 + 1.0f;
    float _3070 = ((exp2(log2((_3039 - (_3038 * saturate((_3026 * _3026) * _3029))) * _3029)) - _3032) * 1.399999976158142f) + _3032;
    float _3071 = ((exp2(log2((_3039 - (saturate((_3027 * _3027) * _3030) * _3038)) * _3030)) - _3032) * 1.399999976158142f) + _3032;
    float _3072 = ((exp2(log2((_3039 - (saturate((_3028 * _3028) * _3031) * _3038)) * _3031)) - _3032) * 1.399999976158142f) + _3032;
    float _3091 = saturate(exp2(log2(mad(_3072, -0.09902974218130112f, mad(_3071, -0.09802088141441345f, (_3070 * 1.1968790292739868f)))) * 2.200000047683716f));
    float _3092 = saturate(exp2(log2(mad(_3072, -0.09896117448806763f, mad(_3071, 1.1519031524658203f, (_3070 * -0.052896853536367416f)))) * 2.200000047683716f));
    float _3093 = saturate(exp2(log2(mad(_3072, 1.151073694229126f, mad(_3071, -0.09804344922304153f, (_3070 * -0.05297163501381874f)))) * 2.200000047683716f));
    if (_etcParams.z == 0.0f) {
      float _3099 = 1.0f - abs(_etcParams.w);
      float _3103 = saturate(_etcParams.w);
      float _3104 = (_3099 * _3091) + _3103;
      float _3105 = (_3099 * _3092) + _3103;
      float _3106 = (_3099 * _3093) + _3103;
      if (_colorGradingParams.w > 0.0f) {
        float _3111 = saturate(_colorGradingParams.w);
        _3128 = (((max(0.0f, (1.0f - _3104)) - _3104) * _3111) + _3104);
        _3129 = (((max(0.0f, (1.0f - _3105)) - _3105) * _3111) + _3105);
        _3130 = (((max(0.0f, (1.0f - _3106)) - _3106) * _3111) + _3106);
      } else {
        _3128 = _3104;
        _3129 = _3105;
        _3130 = _3106;
      }
      float _3136 = _userImageAdjust.y + 1.0f;
      float _3140 = _userImageAdjust.x + 0.5f;
      float _3152 = 2.200000047683716f / ((min(max(_userImageAdjust.w, -1.0f), 1.0f) * 0.800000011920929f) + 2.200000047683716f);
      _3163 = exp2(log2(saturate(((_3128 + -0.5f) * _3136) + _3140)) * _3152);
      _3164 = exp2(log2(saturate(((_3129 + -0.5f) * _3136) + _3140)) * _3152);
      _3165 = exp2(log2(saturate(((_3130 + -0.5f) * _3136) + _3140)) * _3152);
    
    } else {
      _3163 = _3091;
      _3164 = _3092;
      _3165 = _3093;
    }
    }
  } 
  // else if (_2885 && RENODX_TONE_MAP_TYPE != 0) {
  //   float _2891 = _userImageAdjust.z * _exposure0.x;

  //   float3 untonemapped_ap1 = _2891 * float3(_2866, _2867, _2868);
  //   float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
  //   untonemapped_bt709 = ApplyDisplayCurvesAndSaturation(untonemapped_bt709);
  //   float3 tonemapped_bt709 = CustomTonemap(untonemapped_bt709, true);
  //   _3163 = tonemapped_bt709.x;
  //   _3164 = tonemapped_bt709.y;
  //   _3165 = tonemapped_bt709.z;
  // }
  else {
    _3163 = _2866;
    _3164 = _2867;
    _3165 = _2868;
  }

  // float3 post_localexposure = float3(_3163, _3164, _3165);
  // float3 final_localexposure = lerp(pre_localexposure, post_localexposure, 0.f);
  // _3163 = final_localexposure.x;
  // _3164 = final_localexposure.y;
  // _3165 = final_localexposure.z;

  // Extra radial mask/fade used by special display modes.
  if (_etcParams.y > 1.0f) {
    float _3174 = abs((TEXCOORD.x * 2.0f) + -1.0f);
    float _3175 = abs((TEXCOORD.y * 2.0f) + -1.0f);
    float _3179 = saturate(1.0f - (dot(float2(_3174, _3175), float2(_3174, _3175)) * saturate(_etcParams.y + -1.0f)));
    _3184 = (_3179 * _3163);
    _3185 = (_3179 * _3164);
    _3186 = (_3179 * _3165);
  } else {
    _3184 = _3163;
    _3185 = _3164;
    _3186 = _3165;
  }
  if ((_2885) & ((bool)(_etcParams.z > 0.0f))) {
    _3216 = select((_3184 <= 0.0031308000907301903f), (_3184 * 12.920000076293945f), (((pow(_3184, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _3217 = select((_3185 <= 0.0031308000907301903f), (_3185 * 12.920000076293945f), (((pow(_3185, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _3218 = select((_3186 <= 0.0031308000907301903f), (_3186 * 12.920000076293945f), (((pow(_3186, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _3216 = _3184;
    _3217 = _3185;
    _3218 = _3186;
  }
  // Final top/bottom letterbox clipping.
  if (!(!(_etcParams.y >= 1.0f))) {
    float _3223 = float((uint)_2869);
    if (!(_3223 < _viewDir.w)) {
      if (!(_3223 >= (_screenSizeAndInvSize.y - _viewDir.w))) {
        _3232 = _3216;
        _3233 = _3217;
        _3234 = _3218;
      } else {
        _3232 = 0.0f;
        _3233 = 0.0f;
        _3234 = 0.0f;
      }
    } else {
      _3232 = 0.0f;
      _3233 = 0.0f;
      _3234 = 0.0f;
    }
  } else {
    _3232 = _3216;
    _3233 = _3217;
    _3234 = _3218;
  }
  SV_Target.x = _3232;
  SV_Target.y = _3233;
  SV_Target.z = _3234;

  SV_Target.w = _2882;
  return SV_Target;
}
