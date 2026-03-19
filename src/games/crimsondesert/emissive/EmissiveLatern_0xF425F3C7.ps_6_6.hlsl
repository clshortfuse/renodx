#include "../shared.h"

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

ConstantBuffer<MaterialOverrideParametersStruct> BindlessParameters_MaterialOverrideParameters[] : register(b0, space101);

ConstantBuffer<EmissiveStruct> BindlessParameters_Emissive[] : register(b0, space100);

SamplerState __0__95__0__0__g_samplerAnisotropicWrap : register(s8, space95);

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
  linear float4 TEXCOORD_4 : TEXCOORD4,
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
  half _26 = rsqrt(dot(half3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z), half3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z)));
  float _33 = select((SV_IsFrontFace != 0), 1.0f, -1.0f);
  float _34 = float(_26 * TEXCOORD_1.x) * _33;
  float _35 = float(_26 * TEXCOORD_1.y) * _33;
  float _36 = float(_26 * TEXCOORD_1.z) * _33;
  half _38 = rsqrt(dot(half3(TEXCOORD_2.x, TEXCOORD_2.y, TEXCOORD_2.z), half3(TEXCOORD_2.x, TEXCOORD_2.y, TEXCOORD_2.z)));
  float _42 = float(_38 * TEXCOORD_2.x);
  float _43 = float(_38 * TEXCOORD_2.y);
  float _44 = float(_38 * TEXCOORD_2.z);
  int _47 = select(((uint)TEXCOORD_5 < (uint)170000), TEXCOORD_5, 0);
  float _55 = float((uint)((uint)(((uint)((uint)(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._tintColor)) >> 16) & 255)));
  float _58 = float((uint)((uint)(((uint)((uint)(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._tintColor)) >> 8) & 255)));
  float _60 = float((uint)((uint)((BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._tintColor) & 255)));
  float _102 = (_time.x * (BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveFlowSpeedU)) + TEXCOORD.x;
  float _103 = (_time.x * (BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveFlowSpeedV)) + TEXCOORD.y;
  int _107 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._baseColorTexture);
  float4 _114 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_107 < (uint)65000), _107, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_102, _103));
  int _122 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._materialTexture);
  float4 _129 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_122 < (uint)65000), _122, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_102, _103));
  float _140 = (1.0f / max(9.999999974752427e-07f, (BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveIntensity))) * min((BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveIntensity), (BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveFlickeringIntensityMin));
  float _159 = float((uint)((uint)(((uint)((uint)(BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveColor)) >> 16) & 255)));
  float _162 = float((uint)((uint)(((uint)((uint)(BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveColor)) >> 8) & 255)));
  float _164 = float((uint)((uint)((BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveColor) & 255)));
  int _195 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._emissiveTexture);
  float4 _202 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_195 < (uint)65000), _195, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_102, _103));
  int _209 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._emissiveIntensityTexture);
  float4 _216 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_209 < (uint)65000), _209, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_102, _103));
  int _230 = WaveReadLaneFirst(WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._heightTexture));
  float4 _237 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_230 < (uint)65000), _230, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_102, _103));
  int _242 = WaveReadLaneFirst(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._normalTexture);
  float4 _249 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_242 < (uint)65000), _242, 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(_102, _103));
  float _254 = (_249.x * 2.0f) + -0.9960784316062927f;
  float _255 = (_249.y * 2.0f) + -0.9960784316062927f;
  float _259 = sqrt(saturate(1.0f - dot(float2(_254, _255), float2(_254, _255))));
  float _300 = _255 * float(TEXCOORD_2.w);
  float _308 = ((_259 * _34) + (_254 * _42)) + (_300 * ((_44 * _35) - (_43 * _36)));
  float _310 = ((_259 * _35) + (_254 * _43)) + (_300 * ((_42 * _36) - (_44 * _34)));
  float _312 = ((_259 * _36) + (_254 * _44)) + (_300 * ((_43 * _34) - (_42 * _35)));
  float _314 = rsqrt(dot(float3(_308, _310, _312), float3(_308, _310, _312)));
  half _318 = half(_314 * _308);
  half _319 = half(_314 * _310);
  half _320 = half(_314 * _312);
  half _321 = half(_114.w);
  half _324 = half(_237.x);
  half _338;
  float _535;
  float _536;
  float _537;
  float _603;
  float _604;
  float _605;
  float _634;
  float _635;
  float _636;
  if (!(_debugRenderToggle01.w == 0)) {
    _338 = saturate(half(TEXCOORD.z) * _324);
  } else {
    _338 = _324;
  }
  uint _344 = uint(SV_Position.y);
  int _345 = (int)(uint(SV_Position.x)) & 3;
  float _355 = float((uint)((uint)(((int)(_frameNumber.x * 73)) & 255)));
  bool _373 = (((float((uint)((uint)((uint)((uint)(TEXCOORD_7.y)) >> 24))) * 0.003921568859368563f) - (opacityFilter[(((int)(uint(frac(frac(dot(float2(((SV_Position.x - float((uint)(uint)(_345))) + (_355 * 32.665000915527344f)), ((SV_Position.y - float((uint)((uint)((int)(_344) & 3)))) + (_355 * 11.8149995803833f))), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 16.0f) + ((uint)(((int)(_344 << 2)) | _345)))) & 15)])) < 0.0f);
  if (_373) discard;
  float _379 = float((uint)((uint)(((int)(_frameNumber.x * 73)) & 255)));
  bool _389 = ((float(_321) - frac(frac(dot(float2(((_379 * 32.665000915527344f) + SV_Position.x), ((_379 * 11.8149995803833f) + SV_Position.y)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f)) < 0.0f);
  if (_389) discard;
  float _403 = ((((1.0f / min(100.0f, max(0.0010000000474974513f, _exposure0.x))) + -1.0f) * select(((BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveLightPreset) < 0.0f), 1.0f, 0.0f)) + 1.0f) * float(half((((BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveIntensity) * select(((BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveFlickeringFreq) == 0.0f), 1.0f, ((((sin(((BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveFlickeringFreq) * 3.1415927410125732f) * _time.x) * 0.5f) + 0.5f) * (1.0f - _140)) + _140))) * saturate(exp2(log2(_216.x) * (BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveIntensityTextureExponent)))) * abs(BindlessParameters_Emissive[((int)((uint)(_47) + 0u))]._emissiveLightPreset)));
  // RenoDX: Reduce lantern emissive intensity when alt bloom is active
  if (ALT_BLOOM > 0.5) _403 *= 0.2;
  half _413 = _debugMultiplier16.w * _debugMultiplier16.w;
  half _418 = rsqrt(dot(half3(_318, _319, _320), half3(_318, _319, _320)));
  bool _457 = (_403 > 0.0f);
  float _461 = rsqrt(dot(float3(_34, _35, _36), float3(_34, _35, _36))) * 0.5f;
  float _480 = float((uint)uint(round(saturate((_461 * _34) + 0.5f) * 1022.0f)));
  float _481 = float((uint)uint(round(saturate((_461 * _35) + 0.5f) * 1022.0f)));
  float _482 = float((uint)uint(round(saturate((_461 * _36) + 0.5f) * 1022.0f)));
  float _495 = (saturate(_480 * 0.000978473573923111f) * 2.0f) + -1.0f;
  float _496 = (saturate(_481 * 0.000978473573923111f) * 2.0f) + -1.0f;
  float _497 = (saturate(_482 * 0.000978473573923111f) * 2.0f) + -1.0f;
  float _499 = rsqrt(dot(float3(_495, _496, _497), float3(_495, _496, _497)));
  float _500 = _499 * _495;
  float _501 = _499 * _496;
  float _502 = _497 * _499;
  float _503 = float(_418 * _318);
  float _504 = float(_418 * _319);
  float _505 = float(_418 * _320);
  float _507 = saturate(dot(float3(_503, _504, _505), float3(_500, _501, _502)));
  float _509 = select((_502 >= 0.0f), 1.0f, -1.0f);
  float _512 = -0.0f - (1.0f / (_509 + _502));
  float _513 = _501 * _512;
  float _514 = _513 * _500;
  if (!(_507 > 0.9999989867210388f)) {
    float _527 = dot(float3(_503, _504, _505), float3(((((_500 * _500) * _512) * _509) + 1.0f), (_514 * _509), (-0.0f - (_509 * _500))));
    float _528 = dot(float3(_503, _504, _505), float3(_514, (_509 + (_513 * _501)), (-0.0f - _501)));
    float _530 = rsqrt(dot(float3(_527, _528, _507), float3(_527, _528, _507)));
    _535 = (_530 * _527);
    _536 = (_530 * _528);
    _537 = (_530 * _507);
  } else {
    _535 = 0.0f;
    _536 = 0.0f;
    _537 = 1.0f;
  }
  float _545 = 0.5f / ((abs(_536) + abs(_535)) + saturate(_537));
  if (_457) {
    float _588 = float(half(saturate(_202.x * select(((_159 * 0.003921568859368563f) < 0.040449999272823334f), (_159 * 0.0003035269910469651f), exp2(log2((_159 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)))));
    float _589 = float(half(saturate(_202.y * select(((_162 * 0.003921568859368563f) < 0.040449999272823334f), (_162 * 0.0003035269910469651f), exp2(log2((_162 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)))));
    float _590 = float(half(saturate(_202.z * select(((_164 * 0.003921568859368563f) < 0.040449999272823334f), (_164 * 0.0003035269910469651f), exp2(log2((_164 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)))));
    float _596 = sqrt(((_589 * _589) + (_588 * _588)) + (_590 * _590));
    if (!(_596 == 0.0f)) {
      _603 = (_588 / _596);
      _604 = (_589 / _596);
      _605 = (_590 / _596);
    } else {
      _603 = _588;
      _604 = _589;
      _605 = _590;
    }
    _634 = saturate(select((_603 <= 0.0031308000907301903f), (_603 * 12.920000076293945f), (((pow(_603, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
    _635 = saturate(select((_604 <= 0.0031308000907301903f), (_604 * 12.920000076293945f), (((pow(_604, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
    _636 = saturate(select((_605 <= 0.0031308000907301903f), (_605 * 12.920000076293945f), (((pow(_605, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
  } else {
    _634 = (float((int)(BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._placementId)) * 0.003921568859368563f);
    _635 = 0.0f;
    _636 = 0.0f;
  }
  SV_Target.x = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(sqrt(max(saturate(_debugMultiplier16.x * (half((_114.y * max(select(((_58 * 0.003921568859368563f) < 0.040449999272823334f), (_58 * 0.0003035269910469651f), exp2(log2((_58 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)), 0.0003035269910469651f)) * (BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._brightness)) / _321)), _413)))) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(sqrt(max(saturate(_debugMultiplier16.x * (half((_114.x * max(select(((_55 * 0.003921568859368563f) < 0.040449999272823334f), (_55 * 0.0003035269910469651f), exp2(log2((_55 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)), 0.0003035269910469651f)) * (BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._brightness)) / _321)), _413)))) * 255.0f))))) << 8))));
  SV_Target.y = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(half(_129.z))) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(sqrt(max(saturate(_debugMultiplier16.x * (half((_114.z * max(select(((_60 * 0.003921568859368563f) < 0.040449999272823334f), (_60 * 0.0003035269910469651f), exp2(log2((_60 * 0.0037171270232647657f) + 0.052132703363895416f) * 2.4000000953674316f)), 0.0003035269910469651f)) * (BindlessParameters_MaterialOverrideParameters[((int)((uint)(_47) + 0u))]._brightness)) / _321)), _413)))) * 255.0f))))) << 8))));
  SV_Target.z = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(select(_457, 0.0f, (float(_338) * 255.0f)))))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(float(saturate(half(_129.y))) * 255.0f))))) << 8))));
  SV_Target.w = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(saturate((_545 * (_535 - _536)) + 0.5f) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(saturate((_545 * (_536 + _535)) + 0.5f) * 255.0f))))) << 8))));
  SV_Target_1.x = (_480 * 0.0009775171056389809f);
  SV_Target_1.y = (_481 * 0.0009775171056389809f);
  SV_Target_1.z = (_482 * 0.0009775171056389809f);
  SV_Target_1.w = select(_457, 1.0f, (float((uint)((uint)(TEXCOORD_7.x & 1))) * 0.3333333432674408f));
  SV_Target_2.x = _634;
  SV_Target_2.y = _635;
  SV_Target_2.z = _636;
  SV_Target_2.w = saturate((log2(min(max((_403 + 0.00390625f), 0.0f), 4096.0f)) * 0.05000000074505806f) + 0.4000000059604645f);
  SV_Target_3.x = ((((TEXCOORD_4.x / TEXCOORD_4.w) - _temporalAAJitterParams.z) - ((SV_Position.x * 2.0f) * _bufferSizeAndInvSize.z)) * 0.5f);
  SV_Target_3.y = ((((TEXCOORD_4.y / TEXCOORD_4.w) - _temporalAAJitterParams.w) + ((SV_Position.y * 2.0f) * _bufferSizeAndInvSize.w)) * 0.5f);
  SV_Target_4.x = 0u;
  SV_Target_4.y = 0u;
  OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4 };
  return output_signature;
}