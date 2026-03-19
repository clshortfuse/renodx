#include "../shared.h"

struct DecalSimpleObject {
  column_major float4x4 _transform;
};

struct EmissiveStruct {
  uint _emissiveColor;
  float _emissiveIntensityTextureExponent;
  float _emissiveIntensity;
  float _emissiveLightPreset;
  float _emissiveAdaptationRatio;
  float _emissiveFlowSpeedU;
  float _emissiveFlowSpeedV;
  float _emissiveFlickeringFreq;
  float _emissiveFlickeringIntensityMin;
};

struct MaterialOverrideParametersStruct {
  uint _baseColorTexture;
  uint _normalTexture;
  uint _materialTexture;
  uint _heightTexture;
  float _brightness;
  uint _tintColor;
  uint _impostorTintColor;
  uint _emissiveTexture;
  uint _emissiveIntensityTexture;
  int _placementId;
  float _terrainBlend;
  uint _excludeWeatherShadeOnlyDynamic;
  uint _materialInfo;
  float _opticalOpacity;
  float _audioObstruction;
  uint _ignoreRaytracing;
  uint _useSpawnOnOwner;
};


Texture2D<float4> __0__7__0__0__g_bindlessTextures[] : register(t0, space7);

ByteAddressBuffer __3__37__0__0__g_decalClusterElementMaskForForward : register(t1066, space37);

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

cbuffer __3__35__0__0__DecalConstantBufferForForward : register(b40, space35) {
  DecalSimpleObject _decalObjectsForForward[256] : packoffset(c000.x);
};

ConstantBuffer<MaterialOverrideParametersStruct> BindlessParameters_MaterialOverrideParameters[] : register(b0, space101);

ConstantBuffer<EmissiveStruct> BindlessParameters_Emissive[] : register(b0, space100);

SamplerState __0__95__0__0__g_samplerAnisotropicWrap : register(s8, space95);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

static const float opacityFilter[16] = { 0.0f, 0.5f, 0.125f, 0.625f, 0.75f, 0.25f, 0.875f, 0.375f, 0.1875f, 0.6875f, 0.0625f, 0.5625f, 0.9375f, 0.4375f, 0.8125f, 0.3125f };

struct OutputSignature {
  uint4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
  float4 SV_Target_2 : SV_Target2;
  float2 SV_Target_3 : SV_Target3;
  uint2 SV_Target_4 : SV_Target4;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear half4 TEXCOORD_1 : TEXCOORD1,
  linear half4 TEXCOORD_2 : TEXCOORD2,
  linear half4 COLOR : COLOR,
  linear half4 TEXCOORD_3 : TEXCOORD3,
  nointerpolation uint TEXCOORD_5 : TEXCOORD5,
  nointerpolation uint TEXCOORD_6 : TEXCOORD6,
  nointerpolation uint2 TEXCOORD_7 : TEXCOORD7,
  nointerpolation float4 TEXCOORD_10 : TEXCOORD10,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) {
  uint4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float2 SV_Target_3;
  uint2 SV_Target_4;
  float _34 = ((SV_Position.x * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f;
  float _35 = 1.0f - ((SV_Position.y * 2.0f) * _bufferSizeAndInvSize.w);
  float _71 = mad((_invViewProjRelative[3].z), SV_Position.z, mad((_invViewProjRelative[3].y), _35, (_34 * (_invViewProjRelative[3].x)))) + (_invViewProjRelative[3].w);
  float _72 = (mad((_invViewProjRelative[0].z), SV_Position.z, mad((_invViewProjRelative[0].y), _35, (_34 * (_invViewProjRelative[0].x)))) + (_invViewProjRelative[0].w)) / _71;
  float _73 = (mad((_invViewProjRelative[1].z), SV_Position.z, mad((_invViewProjRelative[1].y), _35, (_34 * (_invViewProjRelative[1].x)))) + (_invViewProjRelative[1].w)) / _71;
  float _74 = (mad((_invViewProjRelative[2].z), SV_Position.z, mad((_invViewProjRelative[2].y), _35, (_34 * (_invViewProjRelative[2].x)))) + (_invViewProjRelative[2].w)) / _71;
  half _76 = rsqrt(dot(half3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z), half3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z)));
  float _83 = select((SV_IsFrontFace != 0), 1.0f, -1.0f);
  float _84 = float(_76 * TEXCOORD_1.x) * _83;
  float _85 = float(_76 * TEXCOORD_1.y) * _83;
  float _86 = float(_76 * TEXCOORD_1.z) * _83;
  half _88 = rsqrt(dot(half3(TEXCOORD_2.x, TEXCOORD_2.y, TEXCOORD_2.z), half3(TEXCOORD_2.x, TEXCOORD_2.y, TEXCOORD_2.z)));
  float _92 = float(_88 * TEXCOORD_2.x);
  float _93 = float(_88 * TEXCOORD_2.y);
  float _94 = float(_88 * TEXCOORD_2.z);
  int _97 = select(((uint)TEXCOORD_5 < (uint)170000), TEXCOORD_5, 0);
  float _105 = float((uint)((uint)(((uint)((uint)(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._tintColor)) >> 16) & 255)));
  float _108 = float((uint)((uint)(((uint)((uint)(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._tintColor)) >> 8) & 255)));
  float _110 = float((uint)((uint)((BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._tintColor) & 255)));
  float _152 = (_time.x * (BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveFlowSpeedU)) + TEXCOORD.x;
  float _153 = (_time.x * (BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveFlowSpeedV)) + TEXCOORD.y;
  int _157 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._baseColorTexture);
  float4 _164 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_157 < (uint)65000), _157, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_152, _153));
  int _172 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._materialTexture);
  float4 _179 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_172 < (uint)65000), _172, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_152, _153));
  float _190 = (1.0f / max(9.999999974752427e-07f, (BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveIntensity))) * min((BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveIntensity), (BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveFlickeringIntensityMin));
  float _209 = float((uint)((uint)(((uint)((uint)(BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveColor)) >> 16) & 255)));
  float _212 = float((uint)((uint)(((uint)((uint)(BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveColor)) >> 8) & 255)));
  float _214 = float((uint)((uint)((BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveColor) & 255)));
  int _245 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._emissiveTexture);
  float4 _252 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_245 < (uint)65000), _245, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_152, _153));
  int _259 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._emissiveIntensityTexture);
  float4 _266 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_259 < (uint)65000), _259, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_152, _153));
  int _280 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._heightTexture));
  float4 _287 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_280 < (uint)65000), _280, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_152, _153));
  int _292 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._normalTexture);
  float4 _299 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_292 < (uint)65000), _292, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_152, _153));
  float _304 = (_299.x * 2.0f) + -0.9960784316062927f;
  float _305 = (_299.y * 2.0f) + -0.9960784316062927f;
  float _309 = sqrt(saturate(1.0f - dot(float2(_304, _305), float2(_304, _305))));
  float _350 = _305 * float(TEXCOORD_2.w);
  float _358 = ((_309 * _84) + (_304 * _92)) + (_350 * ((_94 * _85) - (_93 * _86)));
  float _360 = ((_309 * _85) + (_304 * _93)) + (_350 * ((_92 * _86) - (_94 * _84)));
  float _362 = ((_309 * _86) + (_304 * _94)) + (_350 * ((_93 * _84) - (_92 * _85)));
  float _364 = rsqrt(dot(float3(_358, _360, _362), float3(_358, _360, _362)));
  half _371 = half(_164.w);
  half _374 = half(_287.x);
  half _388;
  int _470;
  float _471;
  float _472;
  float _473;
  float _474;
  float _475;
  float _476;
  float _477;
  float _478;
  int _479;
  int _489;
  float _490;
  float _491;
  float _492;
  float _493;
  float _494;
  float _495;
  float _496;
  float _497;
  int _498;
  bool _598;
  float _791;
  float _792;
  float _793;
  float _794;
  float _795;
  float _796;
  float _797;
  float _798;
  int _799;
  float _803;
  float _804;
  float _805;
  float _806;
  float _807;
  float _808;
  float _809;
  float _810;
  int _811;
  float _966;
  float _967;
  float _968;
  float _1034;
  float _1035;
  float _1036;
  float _1065;
  float _1066;
  float _1067;
  if (!(_debugRenderToggle01.w == 0)) {
    _388 = saturate(half(TEXCOORD.z) * _374);
  } else {
    _388 = _374;
  }
  uint _392 = uint(SV_Position.x);
  uint _393 = uint(SV_Position.y);
  int _394 = (int)(_392) & 3;
  float _404 = float((uint)((uint)(((int)(_frameNumber.x * 73)) & 255)));
  bool _422 = (((float((uint)((uint)((uint)((uint)(TEXCOORD_7.y)) >> 24))) * 0.003921568859368563f) - (opacityFilter[(((int)(uint(frac(frac(dot(float2(((SV_Position.x - float((uint)(uint)(_394))) + (_404 * 32.665000915527344f)), ((SV_Position.y - float((uint)((uint)((int)(_393) & 3)))) + (_404 * 11.8149995803833f))), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 16.0f) + ((uint)(((int)(_393 << 2)) | _394)))) & 15)])) < 0.0f);
  if (_422) discard;
  float _428 = float((uint)((uint)(((int)(_frameNumber.x * 73)) & 255)));
  bool _438 = ((float(_371) - frac(frac(dot(float2(((_428 * 32.665000915527344f) + SV_Position.x), ((_428 * 11.8149995803833f) + SV_Position.y)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f)) < 0.0f);
  if (_438) discard;
  _470 = 0;
  _471 = float(half((_164.x * max(select(((_105 * 0.003921568859368563f) < 0.040449999272823334f), (_105 * 0.0003035269910469651f), exp2(log2((_105 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)), 0.0003035269910469651f)) * (BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._brightness)) / _371);
  _472 = float(half((_164.y * max(select(((_108 * 0.003921568859368563f) < 0.040449999272823334f), (_108 * 0.0003035269910469651f), exp2(log2((_108 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)), 0.0003035269910469651f)) * (BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._brightness)) / _371);
  _473 = float(half((_164.z * max(select(((_110 * 0.003921568859368563f) < 0.040449999272823334f), (_110 * 0.0003035269910469651f), exp2(log2((_110 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)), 0.0003035269910469651f)) * (BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._brightness)) / _371);
  _474 = float(half(_364 * _358));
  _475 = float(half(_364 * _360));
  _476 = float(half(_364 * _362));
  _477 = float(half(_179.y));
  _478 = float(half(_179.z));
  _479 = (BindlessParameters_MaterialOverrideParameters[((int)((uint)(_97) + 0u))]._placementId);
  while(true) {
    int4 _484 = asint(__3__37__0__0__g_decalClusterElementMaskForForward.Load4(((int)(((uint)(_470 + ((int)(uint((float((uint)uint((_bufferSizeAndInvSize.w * float((uint)_393)) * _clusterDecalSizeAndInvSize.y)) * _clusterDecalSizeAndInvSize.x) + float((uint)uint((_bufferSizeAndInvSize.z * float((uint)_392)) * _clusterDecalSizeAndInvSize.x))) << 3)))) << 2))));
    if (!(_484.x == 0)) {
      _489 = _484.x;
      _490 = _471;
      _491 = _472;
      _492 = _473;
      _493 = _474;
      _494 = _475;
      _495 = _476;
      _496 = _477;
      _497 = _478;
      _498 = _479;
      while(true) {
        int _499 = firstbitlow(_489);
        int _503 = _489 & (((int)(1u << (_499 & 31))) ^ -1);
        int _511 = asint((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).w));
        float _540 = ((_72 - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).x)) - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4]).x)) + _viewPos.x;
        float _543 = ((_73 - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).y)) - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4]).y)) + _viewPos.y;
        float _546 = ((_74 - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).z)) - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4]).z)) + _viewPos.z;
        float _552 = sqrt((((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).x) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).x)) + ((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).y) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).y))) + ((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).z) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).z)));
        float _558 = sqrt((((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).x) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).x)) + ((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).y) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).y))) + ((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).z) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).z)));
        float _564 = sqrt((((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).x) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).x)) + ((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).y) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).y))) + ((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).z) * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).z)));
        float _565 = 1.0f / _552;
        float _566 = _565 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).x);
        float _567 = _565 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).y);
        float _568 = _565 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 2 % 4]).z);
        float _569 = 1.0f / _558;
        float _570 = _569 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).x);
        float _571 = _569 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).y);
        float _572 = _569 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).z);
        float _573 = 1.0f / _564;
        float _574 = _573 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).x);
        float _575 = _573 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).y);
        float _576 = _573 * (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).z);
        float _577 = dot(float3(_566, _567, _568), float3(_540, _543, _546));
        float _580 = ((-0.0f - _577) / _552) + 0.5f;
        float _583 = 0.5f - (dot(float3(_570, _571, _572), float3(_540, _543, _546)) / _558);
        float _587 = ((-0.0f - dot(float3(_574, _575, _576), float3(_540, _543, _546))) / _564) + -0.5f;
        if (saturate(_580) == _580) {
          _598 = (((_587 <= 1.0f)) && ((((_587 >= 0.0f)) && ((saturate(_583) == _583)))));
        } else {
          _598 = false;
        }
        if (_598) {
          if (!((asint((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 1 % 4]).w)) & 15) == 1)) {
            float _611 = rsqrt(dot(float3(_574, _575, _576), float3(_574, _575, _576)));
            [branch]
            if (!(!(dot(float3(_84, _85, _86), float3((_611 * _574), (_611 * _575), (_611 * _576))) >= max(min(((float((uint)((uint)(_511 & 255))) * 0.007843137718737125f) + -1.0f), 1.0f), -1.0f)))) {
              float _626 = ((_72 - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4]).x)) - _574) + _viewPos.x;
              float _627 = _626 + ddx_coarse(_72);
              float _630 = ((_73 - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4]).y)) - _575) + _viewPos.y;
              float _631 = _630 + ddx_coarse(_73);
              float _634 = ((_74 - (float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4]).z)) - _576) + _viewPos.z;
              float _635 = _634 + ddx_coarse(_74);
              float _636 = _626 + ddy_coarse(_72);
              float _637 = _630 + ddy_coarse(_73);
              float _638 = _634 + ddy_coarse(_74);
              float _644 = (_577 - dot(float3(_566, _567, _568), float3(_627, _631, _635))) / _552;
              float _645 = (0.5f - (dot(float3(_570, _571, _572), float3(_627, _631, _635)) / _558)) - _583;
              float _651 = (_577 - dot(float3(_566, _567, _568), float3(_636, _637, _638))) / _552;
              float _652 = (0.5f - (dot(float3(_570, _571, _572), float3(_636, _637, _638)) / _558)) - _583;
              int _654 = asint((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) % 4]).w));
              int _655 = _654 & 65535;
              float4 _663 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_655 < (uint)65000), _655, 0)) + 0u))].SampleGrad(__0__4__0__0__g_staticBilinearClamp, float2(_580, _583), float2(_644, _645), float2(_651, _652), int2(0, 0));
              float4 _671 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_654 < (uint)-35127296), ((uint)((uint)(_654)) >> 16), 0)) + 0u))].SampleGrad(__0__4__0__0__g_staticBilinearClamp, float2(_580, _583), float2(_644, _645), float2(_651, _652), int2(0, 0));
              if (!(_663.w < 0.05000000074505806f)) {
                int _681 = asint((float4(_decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[0][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[1][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[2][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4], _decalObjectsForForward[((int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 / 4)]._transform[3][(int)(((uint)(_499) + ((uint)(_470) << 5)) << 2) + 3 % 4]).w));
                float _694 = (_671.x * 2.0f) + -0.9960784316062927f;
                float _695 = (_671.y * 2.0f) + -0.9960784316062927f;
                float _699 = sqrt(saturate(1.0f - dot(float2(_694, _695), float2(_694, _695))));
                float _700 = -0.0f - _566;
                float _701 = -0.0f - _567;
                float _702 = -0.0f - _568;
                float _705 = (_85 * _702) - (_86 * _701);
                float _708 = (_86 * _700) - (_84 * _702);
                float _711 = (_84 * _701) - (_85 * _700);
                float _713 = rsqrt(dot(float3(_705, _708, _711), float3(_705, _708, _711)));
                float _714 = _713 * _705;
                float _715 = _713 * _708;
                float _716 = _713 * _711;
                float _719 = (_715 * _86) - (_716 * _85);
                float _722 = (_716 * _84) - (_714 * _86);
                float _725 = (_714 * _85) - (_715 * _84);
                float _734 = rsqrt(dot(float3(_719, _722, _725), float3(_719, _722, _725))) * _694;
                float _737 = mad(_699, _84, mad(_695, _714, (_734 * _719)));
                float _740 = mad(_699, _85, mad(_695, _715, (_734 * _722)));
                float _743 = mad(_699, _86, mad(_695, _716, (_734 * _725)));
                float _745 = rsqrt(dot(float3(_737, _740, _743), float3(_737, _740, _743)));
                float _765 = ((_663.w * 0.003921568859368563f) * float((uint)((uint)((uint)((uint)(_681)) >> 24)))) * saturate((1.0f - abs((_587 * 2.0f) + -1.0f)) * (1.0f / max(0.0010000000474974513f, (float((uint)((uint)(((uint)((uint)(_511)) >> 8) & 255))) * 0.009999999776482582f))));
                _791 = ((_765 * (((_663.x * 0.003921568859368563f) * float((uint)((uint)(((uint)((uint)(_681)) >> 16) & 255)))) - _490)) + _490);
                _792 = ((_765 * (((_663.y * 0.003921568859368563f) * float((uint)((uint)(((uint)((uint)(_681)) >> 8) & 255)))) - _491)) + _491);
                _793 = ((_765 * (((_663.z * 0.003921568859368563f) * float((uint)((uint)(_681 & 255)))) - _492)) + _492);
                _794 = ((_765 * ((_745 * _737) - _493)) + _493);
                _795 = ((_765 * ((_745 * _740) - _494)) + _494);
                _796 = ((_765 * ((_745 * _743) - _495)) + _495);
                _797 = ((_765 * ((float((uint)((uint)(((uint)((uint)(_511)) >> 16) & 255))) * 0.003921568859368563f) - _496)) + _496);
                _798 = ((_765 * ((float((uint)((uint)((uint)((uint)(_511)) >> 24))) * 0.003921568859368563f) - _497)) + _497);
                _799 = _498;
              } else {
                _791 = _490;
                _792 = _491;
                _793 = _492;
                _794 = _493;
                _795 = _494;
                _796 = _495;
                _797 = _496;
                _798 = _497;
                _799 = _498;
              }
            } else {
              _791 = _490;
              _792 = _491;
              _793 = _492;
              _794 = _493;
              _795 = _494;
              _796 = _495;
              _797 = _496;
              _798 = _497;
              _799 = _498;
            }
          } else {
            _791 = _490;
            _792 = _491;
            _793 = _492;
            _794 = _493;
            _795 = _494;
            _796 = _495;
            _797 = _496;
            _798 = _497;
            _799 = 0;
          }
        } else {
          _791 = _490;
          _792 = _491;
          _793 = _492;
          _794 = _493;
          _795 = _494;
          _796 = _495;
          _797 = _496;
          _798 = _497;
          _799 = _498;
        }
        if (!(_503 == 0)) {
          _489 = _503;
          _490 = _791;
          _491 = _792;
          _492 = _793;
          _493 = _794;
          _494 = _795;
          _495 = _796;
          _496 = _797;
          _497 = _798;
          _498 = _799;
          continue;
        }
        _803 = _791;
        _804 = _792;
        _805 = _793;
        _806 = _794;
        _807 = _795;
        _808 = _796;
        _809 = _797;
        _810 = _798;
        _811 = _799;
        break;
      }
    } else {
      _803 = _471;
      _804 = _472;
      _805 = _473;
      _806 = _474;
      _807 = _475;
      _808 = _476;
      _809 = _477;
      _810 = _478;
      _811 = _479;
    }
    if (!((_470 + 1) == 8)) {
      _470 = (_470 + 1);
      _471 = _803;
      _472 = _804;
      _473 = _805;
      _474 = _806;
      _475 = _807;
      _476 = _808;
      _477 = _809;
      _478 = _810;
      _479 = _811;
      continue;
    }
    half _819 = half(_806);
    half _820 = half(_807);
    half _821 = half(_808);
    float _834 = ((((1.0f / min(100.0f, max(0.0010000000474974513f, _exposure0.x))) + -1.0f) * select(((BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveLightPreset) < 0.0f), 1.0f, 0.0f)) + 1.0f) * float(half((((BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveIntensity) * select(((BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveFlickeringFreq) == 0.0f), 1.0f, ((((sin(((BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveFlickeringFreq) * 3.1415927410125732f) * _time.x) * 0.5f) + 0.5f) * (1.0f - _190)) + _190))) * saturate(exp2(log2(_266.x) * (BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveIntensityTextureExponent)))) * abs(BindlessParameters_Emissive[((int)((uint)(_97) + 0u))]._emissiveLightPreset)));
    // RenoDX: Reduce lantern emissive intensity when alt bloom is active
    if (ALT_BLOOM > 0.5) _834 *= 0.2;
    half _844 = _debugMultiplier16.w * _debugMultiplier16.w;
    half _849 = rsqrt(dot(half3(_819, _820, _821), half3(_819, _820, _821)));
    bool _888 = (_834 > 0.0f);
    float _892 = rsqrt(dot(float3(_84, _85, _86), float3(_84, _85, _86))) * 0.5f;
    float _911 = float((uint)uint(round(saturate((_892 * _84) + 0.5f) * 1022.0f)));
    float _912 = float((uint)uint(round(saturate((_892 * _85) + 0.5f) * 1022.0f)));
    float _913 = float((uint)uint(round(saturate((_892 * _86) + 0.5f) * 1022.0f)));
    float _926 = (saturate(_911 * 0.000978473573923111f) * 2.0f) + -1.0f;
    float _927 = (saturate(_912 * 0.000978473573923111f) * 2.0f) + -1.0f;
    float _928 = (saturate(_913 * 0.000978473573923111f) * 2.0f) + -1.0f;
    float _930 = rsqrt(dot(float3(_926, _927, _928), float3(_926, _927, _928)));
    float _931 = _930 * _926;
    float _932 = _930 * _927;
    float _933 = _928 * _930;
    float _934 = float(_849 * _819);
    float _935 = float(_849 * _820);
    float _936 = float(_849 * _821);
    float _938 = saturate(dot(float3(_934, _935, _936), float3(_931, _932, _933)));
    float _940 = select((_933 >= 0.0f), 1.0f, -1.0f);
    float _943 = -0.0f - (1.0f / (_940 + _933));
    float _944 = _932 * _943;
    float _945 = _944 * _931;
    if (!(_938 > 0.9999989867210388f)) {
      float _958 = dot(float3(_934, _935, _936), float3(((((_931 * _931) * _943) * _940) + 1.0f), (_945 * _940), (-0.0f - (_940 * _931))));
      float _959 = dot(float3(_934, _935, _936), float3(_945, (_940 + (_944 * _932)), (-0.0f - _932)));
      float _961 = rsqrt(dot(float3(_958, _959, _938), float3(_958, _959, _938)));
      _966 = (_961 * _958);
      _967 = (_961 * _959);
      _968 = (_961 * _938);
    } else {
      _966 = 0.0f;
      _967 = 0.0f;
      _968 = 1.0f;
    }
    float _976 = 0.5f / ((abs(_967) + abs(_966)) + saturate(_968));
    if (_888) {
      float _1019 = float(half(saturate(_252.x * select(((_209 * 0.003921568859368563f) < 0.040449999272823334f), (_209 * 0.0003035269910469651f), exp2(log2((_209 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)))));
      float _1020 = float(half(saturate(_252.y * select(((_212 * 0.003921568859368563f) < 0.040449999272823334f), (_212 * 0.0003035269910469651f), exp2(log2((_212 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)))));
      float _1021 = float(half(saturate(_252.z * select(((_214 * 0.003921568859368563f) < 0.040449999272823334f), (_214 * 0.0003035269910469651f), exp2(log2((_214 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)))));
      float _1027 = sqrt(((_1020 * _1020) + (_1019 * _1019)) + (_1021 * _1021));
      if (!(_1027 == 0.0f)) {
        _1034 = (_1019 / _1027);
        _1035 = (_1020 / _1027);
        _1036 = (_1021 / _1027);
      } else {
        _1034 = _1019;
        _1035 = _1020;
        _1036 = _1021;
      }
      _1065 = saturate(select((_1034 <= 0.0031308000907301903f), (_1034 * 12.920000076293945f), (((pow(_1034, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
      _1066 = saturate(select((_1035 <= 0.0031308000907301903f), (_1035 * 12.920000076293945f), (((pow(_1035, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
      _1067 = saturate(select((_1036 <= 0.0031308000907301903f), (_1036 * 12.920000076293945f), (((pow(_1036, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
    } else {
      _1065 = (float((int)(_811)) * 0.003921568859368563f);
      _1066 = 0.0f;
      _1067 = 0.0f;
    }
    SV_Target.x = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(sqrt(max(saturate(_debugMultiplier16.x * half(_804)), _844)))) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(sqrt(max(saturate(_debugMultiplier16.x * half(_803)), _844)))) * 255.0f))))) << 8))));
    SV_Target.y = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(half(_810))) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(sqrt(max(saturate(_debugMultiplier16.x * half(_805)), _844)))) * 255.0f))))) << 8))));
    SV_Target.z = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(select(_888, 0.0f, (float(_388) * 255.0f)))))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(half(_809))) * 255.0f))))) << 8))));
    SV_Target.w = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(saturate((_976 * (_966 - _967)) + 0.5f) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(saturate((_976 * (_967 + _966)) + 0.5f) * 255.0f))))) << 8))));
    SV_Target_1.x = (_911 * 0.0009775171056389809f);
    SV_Target_1.y = (_912 * 0.0009775171056389809f);
    SV_Target_1.z = (_913 * 0.0009775171056389809f);
    SV_Target_1.w = select(_888, 1.0f, (float((uint)((uint)(TEXCOORD_7.x & 1))) * 0.3333333432674408f));
    SV_Target_2.x = _1065;
    SV_Target_2.y = _1066;
    SV_Target_2.z = _1067;
    SV_Target_2.w = saturate((log2(min(max((_834 + 0.00390625f), 0.0f), 4096.0f)) * 0.05000000074505806f) + 0.4000000059604645f);
    SV_Target_3.x = 0.0f;
    SV_Target_3.y = 0.0f;
    SV_Target_4.x = 0u;
    SV_Target_4.y = 0u;
    break;
  }
  OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4 };
  return output_signature;
}