// Set to 1 to visualize UV + material type, 0 for normal rendering
#define DEBUG_FOLIAGE_UV 0

#include "../shared.h"

struct IndirectDrawParameters {
  uint16_t _vertexBufferViewIndex;
  uint16_t _staticMeshDataViewIndex;
  uint16_t _staticMeshDataIndex;
  uint16_t _lodData;
  uint _baseVertexLocation;
  uint _bindlessMaterialParametersViewIndex;
  uint _windParams;
};

struct MaterialOverrideParametersTreeStruct {
  uint _baseColorTexture;
  uint _normalTexture;
  uint _materialTexture;
  uint _heightTexture;
  uint _materialInfo;
};


Texture2D<float4> __0__7__0__0__g_bindlessTextures[] : register(t0, space7);

StructuredBuffer<IndirectDrawParameters> __3__37__0__0__g_indirectDrawParametersBuffer : register(t1060, space37);

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

ConstantBuffer<MaterialOverrideParametersTreeStruct> BindlessParameters_MaterialOverrideParametersTree[] : register(b0, space101);

SamplerState __3__40__0__0__g_samplerWrap : register(s2, space40);

SamplerState __0__95__0__0__g_samplerAnisotropicWrap : register(s8, space95);

struct OutputSignature {
  uint4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
  float4 SV_Target_2 : SV_Target2;
  float2 SV_Target_3 : SV_Target3;
  uint2 SV_Target_4 : SV_Target4;
  uint SV_Coverage : SV_Coverage;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1,
  linear half4 NORMAL : NORMAL,
  nointerpolation uint2 TEXCOORD_2 : TEXCOORD2,
  nointerpolation uint SV_ShadingRate : SV_ShadingRate,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace,
  linear float SV_ClipDistance : SV_ClipDistance
) {
  uint4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float2 SV_Target_3;
  uint2 SV_Target_4;
  uint SV_Coverage;
  bool _7 = (SV_IsFrontFace != 0);
  uint _43 = uint(SV_Position.w * 65536.0f);
  float _46 = float((uint)((uint)(((int)(((uint)((((int)(_frameNumber.x * 73)) & 255) * 73)) + _43)) & 255)));
  uint _59 = (TEXCOORD_2.x & 16777215u);
  float _63 = SV_Position.x * 2.0f;
  float _65 = SV_Position.y * 2.0f;
  float _67 = (_bufferSizeAndInvSize.z * _63) + -1.0f;
  float _68 = 1.0f - (_bufferSizeAndInvSize.w * _65);
  float _104 = mad((_invViewProjRelative[3].z), SV_Position.z, mad((_invViewProjRelative[3].y), _68, (_67 * (_invViewProjRelative[3].x)))) + (_invViewProjRelative[3].w);
  float _105 = (mad((_invViewProjRelative[0].z), SV_Position.z, mad((_invViewProjRelative[0].y), _68, (_67 * (_invViewProjRelative[0].x)))) + (_invViewProjRelative[0].w)) / _104;
  float _106 = (mad((_invViewProjRelative[1].z), SV_Position.z, mad((_invViewProjRelative[1].y), _68, (_67 * (_invViewProjRelative[1].x)))) + (_invViewProjRelative[1].w)) / _104;
  float _107 = (mad((_invViewProjRelative[2].z), SV_Position.z, mad((_invViewProjRelative[2].y), _68, (_67 * (_invViewProjRelative[2].x)))) + (_invViewProjRelative[2].w)) / _104;
  int _110 = __3__37__0__0__g_indirectDrawParametersBuffer[_59]._bindlessMaterialParametersViewIndex;
  float _293;
  float _294;
  float _295;
  int _296;
  float _480;
  float _482 = 0.0f;
  float _487;
  float _488;
  float _489;
  float _490;
  float _616;
  float _617;
  float _618;
  if (!(((BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_110 < (uint)170000), _110, 0)) + 0u))]._materialInfo) & 256) == 0)) {
    if (sqrt(((_106 * _106) + (_105 * _105)) + (_107 * _107)) < _bevelParams.z) {
      if (true) discard;
    }
  }
  int _134 = __3__37__0__0__g_indirectDrawParametersBuffer[_59]._bindlessMaterialParametersViewIndex;
  float _154 = ddx_coarse(TEXCOORD.x);
  float _155 = ddx_coarse(TEXCOORD.y);
  float _158 = ddy_coarse(TEXCOORD.x);
  float _159 = ddy_coarse(TEXCOORD.y);
  float _150 = max(((__0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)(BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture) < (uint)65000), (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture), 0)) + 0u))].CalculateLevelOfDetail(__0__95__0__0__g_samplerAnisotropicWrap, float2(TEXCOORD.x, TEXCOORD.y))) + -1.0f), 0.0f);
  float _152 = 1.0f - (float((uint)((uint)((uint)((uint)(TEXCOORD_2.x)) >> 24))) * 0.003921568859368563f);
  [branch]
  if (SV_ShadingRate == 5) {
    float4 _179 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)(BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture) < (uint)65000), (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture), 0)) + 0u))].SampleLevel(__3__40__0__0__g_samplerWrap, float2(((TEXCOORD.x - (_154 * 0.25f)) - (_158 * 0.25f)), ((TEXCOORD.y - (_155 * 0.25f)) - (_159 * 0.25f))), _150);
    float4 _186 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)(BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture) < (uint)65000), (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture), 0)) + 0u))].SampleLevel(__3__40__0__0__g_samplerWrap, float2((lerp(_158, _154, 0.25f)), (lerp(_159, _155, 0.25f))), _150);
    float4 _193 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)(BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture) < (uint)65000), (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture), 0)) + 0u))].SampleLevel(__3__40__0__0__g_samplerWrap, float2((lerp(_154, _158, 0.25f)), (lerp(_155, _159, 0.25f))), _150);
    float4 _200 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)(BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture) < (uint)65000), (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture), 0)) + 0u))].SampleLevel(__3__40__0__0__g_samplerWrap, float2((((_158 + _154) * 0.25f) + TEXCOORD.x), (((_159 + _155) * 0.25f) + TEXCOORD.y)), _150);
    float _212 = float((uint)((uint)(((int)(((uint)((((int)(_frameNumber.x * 73)) & 255) * 73)) + _43)) & 255)));
    float _215 = (_212 * 32.665000915527344f) + SV_Position.x;
    float _216 = _215 + -1.0f;
    float _217 = (_212 * 11.8149995803833f) + SV_Position.y;
    float _218 = _217 + -1.0f;
    float _223 = _215 + 1.0f;
    float _228 = _217 + 1.0f;
    float _237 = _179.w + -0.5f;
    float _244 = _186.w + -0.5f;
    float _252 = _193.w + -0.5f;
    float _260 = _200.w + -0.5f;
    _293 = ((((_186.x + _179.x) + _193.x) + _200.x) * 0.25f);
    _294 = ((((_186.y + _179.y) + _193.y) + _200.y) * 0.25f);
    _295 = ((((_186.z + _179.z) + _193.z) + _200.z) * 0.25f);
    _296 = (((select(((_244 - max(0.0f, ((_244 + _152) - frac(frac(dot(float2(_223, _218), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f)))) >= 0.0f), 4, 0) | select(((_237 - max(0.0f, ((_237 + _152) - frac(frac(dot(float2(_216, _218), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f)))) >= 0.0f), 8, 0)) | select(((_252 - max(0.0f, ((_252 + _152) - frac(frac(dot(float2(_216, _228), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f)))) >= 0.0f), 2, 0)) | ((int)(uint)((int)((_260 - max(0.0f, ((_260 + _152) - frac(frac(dot(float2(_223, _228), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f)))) >= 0.0f))));
  } else {
    float4 _281 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)(BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture) < (uint)65000), (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_134 < (uint)170000), _134, 0)) + 0u))]._baseColorTexture), 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(TEXCOORD.x, TEXCOORD.y));
    float _286 = _281.w + -0.5f;
    bool _291 = ((_286 - max(0.0f, ((_152 - frac(frac(dot(float2(((_46 * 32.665000915527344f) + SV_Position.x), ((_46 * 11.8149995803833f) + SV_Position.y)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f)) + _286))) < 0.0f);
    if (_291) discard;
    _293 = _281.x;
    _294 = _281.y;
    _295 = _281.z;
    _296 = 15;
  }
  float _297 = float(NORMAL.x);
  float _298 = float(NORMAL.y);
  float _299 = float(NORMAL.z);
  float _303 = select(_7, (-0.0f - _297), _297);
  float _304 = select(_7, (-0.0f - _298), _298);
  float _305 = select(_7, (-0.0f - _299), _299);
  float _307 = rsqrt(dot(float3(_303, _304, _305), float3(_303, _304, _305)));
  float _308 = _307 * _303;
  float _309 = _307 * _304;
  float _310 = _307 * _305;
  int _313 = __3__37__0__0__g_indirectDrawParametersBuffer[_59]._bindlessMaterialParametersViewIndex;
  float4 _327 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)(BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_313 < (uint)170000), _313, 0)) + 0u))]._normalTexture) < (uint)65000), (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_313 < (uint)170000), _313, 0)) + 0u))]._normalTexture), 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(TEXCOORD.x, TEXCOORD.y));
  float _332 = (_327.x * 2.0f) + -0.9960784316062927f;
  float _333 = (_327.y * 2.0f) + -0.9960784316062927f;
  float _337 = sqrt(saturate(1.0f - dot(float2(_332, _333), float2(_332, _333))));
  int _340 = __3__37__0__0__g_indirectDrawParametersBuffer[_59]._bindlessMaterialParametersViewIndex;
  float4 _354 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)(BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_340 < (uint)170000), _340, 0)) + 0u))]._materialTexture) < (uint)65000), (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_340 < (uint)170000), _340, 0)) + 0u))]._materialTexture), 0)) + 0u))].Sample(__0__95__0__0__g_samplerAnisotropicWrap, float2(TEXCOORD.x, TEXCOORD.y));
  int _356 = (BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_110 < (uint)170000), _110, 0)) + 0u))]._materialInfo) & 255;
  float _357 = dot(float3(_293, _294, _295), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _361 = sqrt((float((uint)((uint)(((uint)((uint)(TEXCOORD_2.y)) >> 16) & 255))) * 0.003921568859368563f) * _293);
  float _362 = sqrt((float((uint)((uint)(((uint)((uint)(TEXCOORD_2.y)) >> 8) & 255))) * 0.003921568859368563f) * _294);
  float _363 = sqrt((float((uint)((uint)(TEXCOORD_2.y & 255))) * 0.003921568859368563f) * _295);
  float _368 = max(0.0010000000474974513f, dot(float3(_361, _362, _363), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)));
  float _375 = (float((uint)((uint)((uint)((uint)(TEXCOORD_2.y)) >> 24))) * 0.003921568859368563f) * _354.z;
  float _379 = ((((_361 * _357) / _368) - _293) * _375) + _293;
  float _382 = ddx_coarse(_105);
  float _383 = ddx_coarse(_106);
  float _384 = ddx_coarse(_107);
  float _385 = ddy_coarse(_105);
  float _386 = ddy_coarse(_106);
  float _387 = ddy_coarse(_107);
  float _388 = ddx_coarse(TEXCOORD.x);
  float _389 = ddx_coarse(TEXCOORD.y);
  float _390 = ddy_coarse(TEXCOORD.x);
  float _391 = ddy_coarse(TEXCOORD.y);
  float _394 = (_386 * _310) - (_387 * _309);
  float _397 = (_387 * _308) - (_385 * _310);
  float _400 = (_385 * _309) - (_386 * _308);
  float _403 = (_384 * _309) - (_383 * _310);
  float _406 = (_382 * _310) - (_384 * _308);
  float _409 = (_383 * _308) - (_382 * _309);
  float _416 = (_390 * _403) + (_394 * _388);
  float _417 = (_390 * _406) + (_397 * _388);
  float _418 = (_390 * _409) + (_400 * _388);
  float _425 = (_391 * _403) + (_394 * _389);
  float _426 = (_391 * _406) + (_397 * _389);
  float _427 = (_391 * _409) + (_389 * _400);
  float _432 = 1.0f / sqrt(max(dot(float3(_416, _417, _418), float3(_416, _417, _418)), dot(float3(_425, _426, _427), float3(_425, _426, _427))));
  float _444 = (_432 * ((_425 * _333) + (_416 * _332))) + (_337 * _308);
  float _447 = (_432 * ((_426 * _333) + (_417 * _332))) + (_337 * _309);
  float _450 = (_432 * ((_427 * _333) + (_418 * _332))) + (_337 * _310);
  bool _451 = (_337 < 0.0f);
  float _453 = select(_451, (_379 * 100.0f), _379);
  float _454 = select(_451, 0.0f, (((((_362 * _357) / _368) - _294) * _375) + _294));
  float _455 = select(_451, 0.0f, (((((_363 * _357) / _368) - _295) * _375) + _295));
  float _459 = _nearFarProj.x / max(1.0000000116860974e-07f, SV_Position.z);

  if (CONTACT_SHADOW_QUALITY > 0.5f) {
    // --- Grass/foliage AO ---
    // TEXCOORD.y is inverted
    float _grassBladeHeight = 1.0f - saturate(TEXCOORD.y);
    float _grassAOCurve     = pow(_grassBladeHeight, 0.45f);
    float _grassAOScalar    = lerp(0.30f, 1.02f, _grassAOCurve);
    float3 _grassAOTint     = lerp(float3(0.85f, 0.92f, 0.78f), float3(1.0f, 1.0f, 1.0f), _grassAOCurve);

    if (((BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_110 < (uint)170000), _110, 0)) + 0u))]._materialInfo) & 253) == 17) {
      _480 = min(((_459 * 0.004999999888241291f) + 0.44999998807907104f), 0.9900000095367432f);
      float _ao17r = _453 * _grassAOScalar * _grassAOTint.x;
      float _ao17g = _454 * _grassAOScalar * _grassAOTint.y;
      float _ao17b = _455 * _grassAOScalar * _grassAOTint.z;
      if (!_7) {
        _487 = _480;
        _488 = (_ao17r * 1.100000023841858f);
        _489 = (_ao17g * 1.100000023841858f);
        _490 = (_ao17b * 1.100000023841858f);
      } else {
        _487 = _480;
        _488 = _ao17r;
        _489 = _ao17g;
        _490 = _ao17b;
      }
    } else if (_356 == 18) {
      _480 = min(((_459 * 0.0010000000474974513f) + 0.550000011920929f), 0.9900000095367432f);
      float _bushAO = lerp(0.80f, 1.0f, _grassAOCurve);
      float _ao18r = _453 * _bushAO * 0.92f;
      float _ao18g = _454 * _bushAO * 0.92f;
      float _ao18b = _455 * _bushAO * 0.92f;
      if (!_7) {
        _487 = _480;
        _488 = (_ao18r * 1.03f);
        _489 = (_ao18g * 1.03f);
        _490 = (_ao18b * 1.03f);
      } else {
        _487 = _480;
        _488 = _ao18r;
        _489 = _ao18g;
        _490 = _ao18b;
      }
    } else if (_356 == 12) {
      _480 = 0.6000000238418579f;
      float _leafAO = lerp(0.75f, 1.0f, pow(_grassBladeHeight, 0.6f));
      if (!_7) {
        _487 = _480;
        _488 = (_453 * 1.100000023841858f * _leafAO);
        _489 = (_454 * 1.100000023841858f * _leafAO);
        _490 = (_455 * 1.100000023841858f * _leafAO);
      } else {
        _487 = _480;
        _488 = _453 * _leafAO;
        _489 = _454 * _leafAO;
        _490 = _455 * _leafAO;
      }
    } else {
      if (!_7) {
        _482 = min(((_459 * 0.004999999888241291f) + 0.6000000238418579f), 0.9900000095367432f);
        _487 = _482;
        _488 = (_453 * 1.100000023841858f);
        _489 = (_454 * 1.100000023841858f);
        _490 = (_455 * 1.100000023841858f);
      } else {
        _487 = 1.0f;
        _488 = _453;
        _489 = _454;
        _490 = _455;
      }
    }
  } else {
    // Vanilla path — no AO
    bool __defer_vanilla = false;
    if (((BindlessParameters_MaterialOverrideParametersTree[((int)((uint)(select(((uint)_110 < (uint)170000), _110, 0)) + 0u))]._materialInfo) & 253) == 17) {
      _480 = min(((_459 * 0.004999999888241291f) + 0.44999998807907104f), 0.9900000095367432f);
      __defer_vanilla = true;
    } else if (_356 == 18) {
      _480 = min(((_459 * 0.0010000000474974513f) + 0.550000011920929f), 0.9900000095367432f);
      __defer_vanilla = true;
    } else if (_356 == 12) {
      _480 = 0.6000000238418579f;
      __defer_vanilla = true;
    } else {
      if (!_7) {
        _482 = min(((_459 * 0.004999999888241291f) + 0.6000000238418579f), 0.9900000095367432f);
        _487 = _482;
        _488 = (_453 * 1.100000023841858f);
        _489 = (_454 * 1.100000023841858f);
        _490 = (_455 * 1.100000023841858f);
      } else {
        _487 = 1.0f;
        _488 = _453;
        _489 = _454;
        _490 = _455;
      }
    }
    if (__defer_vanilla) {
      if (!_7) {
        _487 = _480;
        _488 = (_453 * 1.100000023841858f);
        _489 = (_454 * 1.100000023841858f);
        _490 = (_455 * 1.100000023841858f);
      } else {
        _487 = _480;
        _488 = _453;
        _489 = _454;
        _490 = _455;
      }
    }
  }
  float _494 = rsqrt(dot(float3(_444, _447, _450), float3(_444, _447, _450)));
  float _495 = _494 * _444;
  float _496 = _494 * _447;
  float _497 = _494 * _450;
  float _507 = _debugMultiplier.w * _debugMultiplier.w;
  float _512 = rsqrt(dot(float3(_495, _496, _497), float3(_495, _496, _497)));
  float _513 = _512 * _495;
  float _514 = _512 * _496;
  float _515 = _512 * _497;
  float _545 = _512 * 0.5f;
  float _564 = float((uint)uint(round(saturate((_545 * _495) + 0.5f) * 1022.0f)));
  float _565 = float((uint)uint(round(saturate((_545 * _496) + 0.5f) * 1022.0f)));
  float _566 = float((uint)uint(round(saturate((_545 * _497) + 0.5f) * 1022.0f)));
  float _579 = (saturate(_564 * 0.000978473573923111f) * 2.0f) + -1.0f;
  float _580 = (saturate(_565 * 0.000978473573923111f) * 2.0f) + -1.0f;
  float _581 = (saturate(_566 * 0.000978473573923111f) * 2.0f) + -1.0f;
  float _583 = rsqrt(dot(float3(_579, _580, _581), float3(_579, _580, _581)));
  float _584 = _583 * _579;
  float _585 = _583 * _580;
  float _586 = _581 * _583;
  float _588 = saturate(dot(float3(_513, _514, _515), float3(_584, _585, _586)));
  float _590 = select((_586 >= 0.0f), 1.0f, -1.0f);
  float _593 = -0.0f - (1.0f / (_590 + _586));
  float _594 = _585 * _593;
  float _595 = _594 * _584;
  if (!(_588 > 0.9999989867210388f)) {
    float _608 = dot(float3(_513, _514, _515), float3(((((_584 * _584) * _593) * _590) + 1.0f), (_595 * _590), (-0.0f - (_590 * _584))));
    float _609 = dot(float3(_513, _514, _515), float3(_595, (_590 + (_594 * _585)), (-0.0f - _585)));
    float _611 = rsqrt(dot(float3(_608, _609, _588), float3(_608, _609, _588)));
    _616 = (_611 * _608);
    _617 = (_611 * _609);
    _618 = (_611 * _588);
  } else {
    _616 = 0.0f;
    _617 = 0.0f;
    _618 = 1.0f;
  }
  float _626 = 0.5f / ((abs(_617) + abs(_616)) + saturate(_618));

#if DEBUG_FOLIAGE_UV
  // Debug: R
  float _dbgR = saturate(TEXCOORD.y);
  _488 = _dbgR;
  _489 = 0.0f;
  _490 = 0.0f;
#endif
  SV_Target.x = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(saturate(sqrt(max(saturate(_debugMultiplier.x * _489), _507))) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(saturate(sqrt(max(saturate(_debugMultiplier.x * _488), _507))) * 255.0f))))) << 8))));
  SV_Target.y = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(saturate(float((uint)(uint)(_356)) * 0.003921568859368563f) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(saturate(sqrt(max(saturate(_debugMultiplier.x * _490), _507))) * 255.0f))))) << 8))));
  SV_Target.z = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(saturate(_487) * 255.0f))))) << 8)));
  SV_Target.w = min((uint)(65535), (uint)((int)(min((uint)(255), (uint)((int)(uint(round(saturate((_626 * (_616 - _617)) + 0.5f) * 255.0f)))))) | ((int)(min((uint)(255), (uint)((int)(uint(round(saturate((_626 * (_617 + _616)) + 0.5f) * 255.0f))))) << 8))));
  SV_Target_1.x = (_564 * 0.0009775171056389809f);
  SV_Target_1.y = (_565 * 0.0009775171056389809f);
  SV_Target_1.z = (_566 * 0.0009775171056389809f);
  SV_Target_1.w = 0.0f;
  SV_Target_2.x = 0.0f;
  SV_Target_2.y = 0.0f;
  SV_Target_2.z = 0.0f;
  SV_Target_2.w = 0.0f;
  SV_Target_3.x = ((((TEXCOORD_1.x / TEXCOORD_1.w) - _temporalAAJitterParams.z) - (_bufferSizeAndInvSize.z * _63)) * 0.5f);
  SV_Target_3.y = ((((TEXCOORD_1.y / TEXCOORD_1.w) - _temporalAAJitterParams.w) + (_bufferSizeAndInvSize.w * _65)) * 0.5f);
  SV_Target_4.x = 0u;
  SV_Target_4.y = 0u;
  SV_Coverage = (uint)(_296);
  OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4, SV_Coverage };
  return output_signature;
}