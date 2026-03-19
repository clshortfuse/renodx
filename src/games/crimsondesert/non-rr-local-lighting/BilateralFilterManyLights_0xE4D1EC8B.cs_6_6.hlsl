#include "../shared.h"
#include "../local-direct-lighting/local_light_common.hlsl"

Texture2D<float4> __3__36__0__0__g_texture : register(t157, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t31, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t50, space36);

Texture2D<uint> __3__36__0__0__g_tiledManyLightsMasks : register(t129, space36);

RWTexture2D<float4> __3__38__0__1__g_textureResultUAV : register(u20, space38);

cbuffer __1__3__0__0__PipelineProperty : register(b0, space3) {
  float2 g_screenSpaceScale : packoffset(c000.x);
  float2 __padding : packoffset(c000.z);
};

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

cbuffer __3__35__0__0__TileConstantBuffer : register(b33, space35) {
  uint4 g_tileIndex[4096] : packoffset(c000.x);
};

cbuffer __3__1__0__0__FilteringConstants : register(b0, space1) {
  float4 _filteringParams : packoffset(c000.x);
  float4 _reconstructParams : packoffset(c001.x);
  float4 _tiledRadianceCacheParams : packoffset(c002.x);
};

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _10[4];
  int _17 = (int)(SV_GroupID.x) & 15;
  int _18 = (uint)((uint)(_17)) >> 2;
  _10[0] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).x);
  _10[1] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).y);
  _10[2] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).z);
  _10[3] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).w);
  int _36 = _10[(((uint)(SV_GroupID.x) >> 4) & 3)];
  uint _48 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(((int)(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))) >> 5)), ((int)(((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5)))) >> 5)), 0));
  float _208;
  float _277;
  float _344;
  float _411;
  float _480;
  float _549;
  [branch]
  if (!((_48.x & 1) == 0)) {
    int _60 = int(_filteringParams.x * _filteringParams.y);
    int _61 = int(_filteringParams.x * _filteringParams.z);
    uint _63 = __3__36__0__0__g_depthStencil.Load(int3(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5)))), 0));
    float _66 = float((uint)((uint)(_63.x & 16777215)));
    float _67 = _66 * 5.960465188081798e-08f;
    uint _69 = __3__36__0__0__g_sceneNormal.Load(int3(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5)))), 0));
    float _85 = min(1.0f, ((float((uint)((uint)(_69.x & 1023))) * 0.001956947147846222f) + -1.0f));
    float _86 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_69.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _87 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_69.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
    float _89 = rsqrt(dot(float3(_85, _86, _87), float3(_85, _86, _87)));
    float _90 = _89 * _85;
    float _91 = _89 * _86;
    float _92 = _89 * _87;
    if (!(((_67 < 1.0000000116860974e-07f)) || ((_67 == 1.0f)))) {
      float4 _98 = __3__36__0__0__g_texture.Load(int3(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5)))), 0));
      float _106 = _nearFarProj.x / max(1.0000000116860974e-07f, _67);
      [branch]
      if (_106 > 64.0f) {
        [branch]
        if (_filteringParams.w > 0.0f) {
          float4 _113 = __3__38__0__1__g_textureResultUAV.Load(int2(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))));
          // RenoDX: Local light hue correction (non RR path, far distance additive)
          float3 _hc_far_add = ApplyLocalLightHueCorrection(float3(_98.x, _98.y, _98.z), LOCAL_LIGHT_HUE_CORRECTION, LOCAL_LIGHT_SATURATION);
          __3__38__0__1__g_textureResultUAV[int2(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5)))))] = float4((_113.x + _hc_far_add.x), (_113.y + _hc_far_add.y), (_113.z + _hc_far_add.z), _113.w);
        } else {
          // RenoDX: Local light hue correction (non RR path, far distance overwrite)
          float3 _hc_far_ow = ApplyLocalLightHueCorrection(float3(_98.x, _98.y, _98.z), LOCAL_LIGHT_HUE_CORRECTION, LOCAL_LIGHT_SATURATION);
          __3__38__0__1__g_textureResultUAV[int2(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5)))))] = float4(_hc_far_ow.x, _hc_far_ow.y, _hc_far_ow.z, _98.w);
        }
      } else {
        float _134 = ((_filteringParams.x * _filteringParams.x) * (1.0f / saturate(((_98.w * _98.w) * 1.9999999494757503e-05f) + 0.015625f))) * (1.0f / (g_screenSpaceScale.x * _filteringParams.x));
        float _136 = (_106 * _106) * 0.009999999776482582f;
        float _144 = max(0.009999999776482582f, (((_134 * 0.8999999761581421f) + 0.10000000149011612f) * (64.0f / ((_106 * 0.019999999552965164f) + 1.0f))));
        float _145 = max(1.0f, _136);
        float _148 = saturate(8.0f - (_66 * 7.450581485102248e-09f));
        float _150 = (20.0f / (_136 + 0.25f)) * _134;
        float4 _158 = __3__36__0__0__g_texture.Load(int3(((int)((_60 * -3) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * -3) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _168 = __3__36__0__0__g_depthStencil.Load(int3(((int)((_60 * -3) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * -3) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _173 = __3__36__0__0__g_sceneNormal.Load(int3(((int)((_60 * -3) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * -3) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        float _189 = min(1.0f, ((float((uint)((uint)(_173.x & 1023))) * 0.001956947147846222f) + -1.0f));
        float _190 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_173.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _191 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_173.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _193 = rsqrt(dot(float3(_189, _190, _191), float3(_189, _190, _191)));
        float _200 = abs((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_168.x & 16777215))) * 5.960465188081798e-08f))) - _106);
        float _201 = _200 * _200;
        if (!(_201 > _145)) {
          _208 = exp2((_150 * -1.4426950216293335f) * _201);
        } else {
          _208 = 0.0f;
        }
        float _215 = (_208 * _148) * exp2(log2(saturate(dot(float3((_193 * _189), (_193 * _190), (_193 * _191)), float3(_90, _91, _92)))) * _144);
        float4 _227 = __3__36__0__0__g_texture.Load(int3(((int)((_60 * -2) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * -2) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _237 = __3__36__0__0__g_depthStencil.Load(int3(((int)((_60 * -2) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * -2) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _242 = __3__36__0__0__g_sceneNormal.Load(int3(((int)((_60 * -2) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * -2) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        float _258 = min(1.0f, ((float((uint)((uint)(_242.x & 1023))) * 0.001956947147846222f) + -1.0f));
        float _259 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_242.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _260 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_242.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _262 = rsqrt(dot(float3(_258, _259, _260), float3(_258, _259, _260)));
        float _269 = abs((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_237.x & 16777215))) * 5.960465188081798e-08f))) - _106);
        float _270 = _269 * _269;
        if (!(_270 > _145)) {
          _277 = exp2((_150 * -1.4426950216293335f) * _270);
        } else {
          _277 = 0.0f;
        }
        float _284 = (_277 * _148) * exp2(log2(saturate(dot(float3((_262 * _258), (_262 * _259), (_262 * _260)), float3(_90, _91, _92)))) * _144);
        uint _292 = ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))) - (uint)(_60);
        uint _293 = ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))) - (uint)(_61);
        float4 _294 = __3__36__0__0__g_texture.Load(int3((int)(_292), (int)(_293), 0));
        uint _304 = __3__36__0__0__g_depthStencil.Load(int3((int)(_292), (int)(_293), 0));
        uint _309 = __3__36__0__0__g_sceneNormal.Load(int3((int)(_292), (int)(_293), 0));
        float _325 = min(1.0f, ((float((uint)((uint)(_309.x & 1023))) * 0.001956947147846222f) + -1.0f));
        float _326 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_309.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _327 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_309.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _329 = rsqrt(dot(float3(_325, _326, _327), float3(_325, _326, _327)));
        float _336 = abs((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_304.x & 16777215))) * 5.960465188081798e-08f))) - _106);
        float _337 = _336 * _336;
        if (!(_337 > _145)) {
          _344 = exp2((_150 * -1.4426950216293335f) * _337);
        } else {
          _344 = 0.0f;
        }
        float _351 = (_344 * _148) * exp2(log2(saturate(dot(float3((_329 * _325), (_329 * _326), (_329 * _327)), float3(_90, _91, _92)))) * _144);
        float4 _361 = __3__36__0__0__g_texture.Load(int3(((int)((uint)(_60) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((uint)(_61) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _371 = __3__36__0__0__g_depthStencil.Load(int3(((int)((uint)(_60) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((uint)(_61) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _376 = __3__36__0__0__g_sceneNormal.Load(int3(((int)((uint)(_60) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((uint)(_61) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        float _392 = min(1.0f, ((float((uint)((uint)(_376.x & 1023))) * 0.001956947147846222f) + -1.0f));
        float _393 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_376.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _394 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_376.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _396 = rsqrt(dot(float3(_392, _393, _394), float3(_392, _393, _394)));
        float _403 = abs((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_371.x & 16777215))) * 5.960465188081798e-08f))) - _106);
        float _404 = _403 * _403;
        if (!(_404 > _145)) {
          _411 = exp2((_150 * -1.4426950216293335f) * _404);
        } else {
          _411 = 0.0f;
        }
        float _418 = (_411 * _148) * exp2(log2(saturate(dot(float3((_396 * _392), (_396 * _393), (_396 * _394)), float3(_90, _91, _92)))) * _144);
        float4 _430 = __3__36__0__0__g_texture.Load(int3(((int)(((uint)(_60) << 1) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)(((uint)(_61) << 1) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _440 = __3__36__0__0__g_depthStencil.Load(int3(((int)(((uint)(_60) << 1) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)(((uint)(_61) << 1) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _445 = __3__36__0__0__g_sceneNormal.Load(int3(((int)(((uint)(_60) << 1) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)(((uint)(_61) << 1) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        float _461 = min(1.0f, ((float((uint)((uint)(_445.x & 1023))) * 0.001956947147846222f) + -1.0f));
        float _462 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_445.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _463 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_445.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _465 = rsqrt(dot(float3(_461, _462, _463), float3(_461, _462, _463)));
        float _472 = abs((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_440.x & 16777215))) * 5.960465188081798e-08f))) - _106);
        float _473 = _472 * _472;
        if (!(_473 > _145)) {
          _480 = exp2((_150 * -1.4426950216293335f) * _473);
        } else {
          _480 = 0.0f;
        }
        float _487 = (_480 * _148) * exp2(log2(saturate(dot(float3((_465 * _461), (_465 * _462), (_465 * _463)), float3(_90, _91, _92)))) * _144);
        float4 _499 = __3__36__0__0__g_texture.Load(int3(((int)((_60 * 3) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * 3) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _509 = __3__36__0__0__g_depthStencil.Load(int3(((int)((_60 * 3) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * 3) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        uint _514 = __3__36__0__0__g_sceneNormal.Load(int3(((int)((_60 * 3) + ((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3))))), ((int)((_61 * 3) + ((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))), 0));
        float _530 = min(1.0f, ((float((uint)((uint)(_514.x & 1023))) * 0.001956947147846222f) + -1.0f));
        float _531 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_514.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _532 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_514.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _534 = rsqrt(dot(float3(_530, _531, _532), float3(_530, _531, _532)));
        float _541 = abs((_nearFarProj.x / max(1.0000000116860974e-07f, (float((uint)((uint)(_509.x & 16777215))) * 5.960465188081798e-08f))) - _106);
        float _542 = _541 * _541;
        if (!(_542 > _145)) {
          _549 = exp2((_150 * -1.4426950216293335f) * _542);
        } else {
          _549 = 0.0f;
        }
        float _556 = (_549 * _148) * exp2(log2(saturate(dot(float3((_534 * _530), (_534 * _531), (_534 * _532)), float3(_90, _91, _92)))) * _144);
        float _565 = 1.0f / max(9.999999717180685e-10f, ((((((_215 + 0.3125f) + _284) + _351) + _418) + _487) + _556));
        float _566 = (((((((_98.x * 0.3125f) - (_215 * min(0.0f, (-0.0f - _158.x)))) - (_284 * min(0.0f, (-0.0f - _227.x)))) - (_351 * min(0.0f, (-0.0f - _294.x)))) - (_418 * min(0.0f, (-0.0f - _361.x)))) - (_487 * min(0.0f, (-0.0f - _430.x)))) - (_556 * min(0.0f, (-0.0f - _499.x)))) * _565;
        float _567 = (((((((_98.y * 0.3125f) - (_215 * min(0.0f, (-0.0f - _158.y)))) - (_284 * min(0.0f, (-0.0f - _227.y)))) - (_351 * min(0.0f, (-0.0f - _294.y)))) - (_418 * min(0.0f, (-0.0f - _361.y)))) - (_487 * min(0.0f, (-0.0f - _430.y)))) - (_556 * min(0.0f, (-0.0f - _499.y)))) * _565;
        float _568 = (((((((_98.z * 0.3125f) - (_215 * min(0.0f, (-0.0f - _158.z)))) - (_284 * min(0.0f, (-0.0f - _227.z)))) - (_351 * min(0.0f, (-0.0f - _294.z)))) - (_418 * min(0.0f, (-0.0f - _361.z)))) - (_487 * min(0.0f, (-0.0f - _430.z)))) - (_556 * min(0.0f, (-0.0f - _499.z)))) * _565;
        [branch]
        if (_filteringParams.w > 0.0f) {
          float4 _573 = __3__38__0__1__g_textureResultUAV.Load(int2(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5))))));
          // RenoDX: Local light hue correction (non RR path, filtered additive)
          float3 _hc_filt_add = ApplyLocalLightHueCorrection(float3(_566, _567, _568), LOCAL_LIGHT_HUE_CORRECTION, LOCAL_LIGHT_SATURATION);
          __3__38__0__1__g_textureResultUAV[int2(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5)))))] = float4((_573.x + _hc_filt_add.x), (_573.y + _hc_filt_add.y), (_573.z + _hc_filt_add.z), dot(_hc_filt_add, float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)));
        } else {
          // RenoDX: Local light hue correction (non RR path, filtered overwrite)
          float3 _hc_filt_ow = ApplyLocalLightHueCorrection(float3(_566, _567, _568), LOCAL_LIGHT_HUE_CORRECTION, LOCAL_LIGHT_SATURATION);
          __3__38__0__1__g_textureResultUAV[int2(((int)((((uint)(((int)((uint)(_36) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_17 - (_18 << 2)) << 3)))), ((int)((((uint)(_18 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_36)) >> 16) << 5)))))] = float4(_hc_filt_ow.x, _hc_filt_ow.y, _hc_filt_ow.z, _98.w);
        }
      }
    }
  }
}