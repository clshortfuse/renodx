Texture2D<float> __3__36__0__0__g_atmosphericScatteringDepth : register(t6, space36);

Texture2D<float4> __3__36__0__0__g_offScreenParticleAlphaBlendQuarter : register(t8, space36);

Texture2D<float2> __3__36__0__0__g_offscreenParticleDepth : register(t9, space36);

Texture2D<float2> __3__36__0__0__g_offscreenParticleDepthQuarter : register(t10, space36);

Texture2D<uint> __3__36__0__0__g_effectTileCoords : register(t12, space36);

RWTexture2D<float4> __3__38__0__1__g_sceneColorUAV : register(u0, space38);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b4, space35) {
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

cbuffer __3__1__0__0__EffectOffScreenParticleConstants : register(b0, space1) {
  int2 _effectTileDataSize : packoffset(c000.x);
  float2 _effectTileDataSizeInv : packoffset(c000.z);
  int2 _renderTargetSize : packoffset(c001.x);
  float2 _renderTargetSizeInv : packoffset(c001.z);
  int2 _inputTextureSizeForTileData : packoffset(c002.x);
  int _isRenderedOffscreenParticlesHalf : packoffset(c002.z);
  int _isRenderedOffscreenParticlesQuarter : packoffset(c002.w);
  float _compositeAlphaRangeMax : packoffset(c003.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

static const int tileOffset[4] = { 0, 1, 3, 2 };

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  uint _20 = __3__36__0__0__g_effectTileCoords.Load(int3(((int)((int)(SV_GroupID.x) % _effectTileDataSize.x)), ((int)(SV_GroupID.x) / _effectTileDataSize.x), 0));
  float _66;
  float _67;
  int _68;
  int _69;
  int _70;
  float _75;
  float _76;
  int _77;
  int _78;
  int _79;
  float _167;
  if ((((int)_renderTargetSize.x > (int)((int)(((uint)(((uint)((uint)(_20.x)) >> 16) << 3)) + SV_GroupThreadID.x)))) && (((int)_renderTargetSize.y > (int)((int)(((uint)(((int)((uint)(_20.x) << 3)) & 524280)) + SV_GroupThreadID.y))))) {
    float4 _45 = __3__38__0__1__g_sceneColorUAV.Load(int2(((int)(((uint)(((uint)((uint)(_20.x)) >> 16) << 3)) + SV_GroupThreadID.x)), ((int)(((uint)(((int)((uint)(_20.x) << 3)) & 524280)) + SV_GroupThreadID.y))));
    float2 _49 = __3__36__0__0__g_offscreenParticleDepth.Load(int3(((int)(((uint)(((uint)((uint)(_20.x)) >> 16) << 3)) + SV_GroupThreadID.x)), ((int)(((uint)(((int)((uint)(_20.x) << 3)) & 524280)) + SV_GroupThreadID.y)), 0));
    int _50 = ((int)(((uint)(((uint)((uint)(_20.x)) >> 16) << 3)) + SV_GroupThreadID.x)) / 2;
    int _51 = ((int)(((uint)(((int)((uint)(_20.x) << 3)) & 524280)) + SV_GroupThreadID.y)) / 2;
    float _59 = __3__36__0__0__g_atmosphericScatteringDepth.Load(int3(((int)(((uint)(((int)(((uint)(((uint)((uint)(_20.x)) >> 16) << 3)) + SV_GroupThreadID.x)) % 2)) + ((uint)(_50 << 1)))), ((int)(((uint)(((int)(((uint)(((int)((uint)(_20.x) << 3)) & 524280)) + SV_GroupThreadID.y)) % 2)) + ((uint)(_51 << 1)))), 0));
    float _64 = _nearFarProj.x / max(1.0000000116860974e-07f, _59.x);
    _66 = 1.0f;
    _67 = 0.0f;
    _68 = -1;
    _69 = _50;
    _70 = _51;
    while(true) {
      _75 = _66;
      _76 = _67;
      _77 = -1;
      _78 = _69;
      _79 = _70;
      while(true) {
        int _87 = tileOffset[(((int)((uint)(_frameNumber.x) + ((uint)(_77) + (uint)(_50)))) & 3)];
        float _95 = __3__36__0__0__g_atmosphericScatteringDepth.Load(int3(((int)(((uint)(_87 % 2)) + (((uint)(_77) + (uint)(_50)) << 1))), ((int)(((uint)(_87 / 2)) + (((uint)(_68) + (uint)(_51)) << 1))), 0));
        float _100 = _nearFarProj.x / max(1.0000000116860974e-07f, _95.x);
        float _101 = min(_64, _100);
        float _102 = max(_64, _100);
        float _106 = select((_102 > 0.0f), ((_102 - _101) / _102), 0.0f);
        float _107 = max(_76, _106);
        bool _108 = (_106 < _75);
        float _109 = select(_108, _106, _75);
        int _110 = select(_108, ((int)((uint)(_77) + (uint)(_50))), _78);
        int _111 = select(_108, ((int)((uint)(_68) + (uint)(_51))), _79);
        if (!((_77 + 1) == 2)) {
          _75 = _109;
          _76 = _107;
          _77 = (_77 + 1);
          _78 = _110;
          _79 = _111;
          continue;
        }
        if (!((_68 + 1) == 2)) {
          _66 = _109;
          _67 = _107;
          _68 = (_68 + 1);
          _69 = _110;
          _70 = _111;
          __loop_jump_target = 65;
          break;
        }
        int _123 = min(max(_110, 0), _renderTargetSize.x);
        int _124 = min(max(_111, 0), _renderTargetSize.y);
        float4 _127 = __3__36__0__0__g_offScreenParticleAlphaBlendQuarter.Sample(__0__4__0__0__g_staticBilinearClamp, float2(((float((int)((int)(((uint)(((uint)((uint)(_20.x)) >> 16) << 3)) + SV_GroupThreadID.x))) + 0.5f) * _renderTargetSizeInv.x), ((float((int)((int)(((uint)(((int)((uint)(_20.x) << 3)) & 524280)) + SV_GroupThreadID.y))) + 0.5f) * _renderTargetSizeInv.y)));
        float4 _132 = __3__36__0__0__g_offScreenParticleAlphaBlendQuarter.Load(int3(_123, _124, 0));
        float2 _138 = __3__36__0__0__g_offscreenParticleDepthQuarter.Load(int3(_50, _51, 0));
        float2 _140 = __3__36__0__0__g_offscreenParticleDepthQuarter.Load(int3(_123, _124, 0));
        float _142 = max(_140.x, _138.x);
        float _146 = _nearFarProj.x / max(1.0000000116860974e-07f, _142);
        if ((((_nearFarProj.x * 1e+07f) <= _102)) || ((_101 < _146))) {
          _167 = (_107 * 100.0f);
        } else {
          _167 = ((exp2(log2(abs(_127.w - _132.w) * _107) * 0.5f) * 4.0f) * saturate((1.0f - _132.w) + saturate(exp2(_102 * -0.014426949433982372f))));
        }
        float _168 = saturate(_167);
        float _177 = (_168 * (_132.x - _127.x)) + _127.x;
        float _178 = (_168 * (_132.y - _127.y)) + _127.y;
        float _179 = (_168 * (_132.z - _127.z)) + _127.z;
        float _180 = (_168 * (_132.w - _127.w)) + _127.w;
        float _188 = 1.0f - exp2(max(0.0f, abs((_nearFarProj.x / max(1.0000000116860974e-07f, _49.x)) - _146)) * -1.4426950216293335f);
        float _192 = (_177 * _45.w) + _45.x;
        float _193 = (_178 * _45.w) + _45.y;
        float _194 = (_179 * _45.w) + _45.z;
        float _199 = (_180 * _45.x) + _177;
        float _200 = (_180 * _45.y) + _178;
        float _201 = (_180 * _45.z) + _179;
        float _208 = ((_199 - _192) * 0.5f) + _192;
        float _209 = ((_200 - _193) * 0.5f) + _193;
        float _210 = ((_201 - _194) * 0.5f) + _194;
        bool _211 = (_49.x < _142);
        __3__38__0__1__g_sceneColorUAV[int2(((int)(((uint)(((uint)((uint)(_20.x)) >> 16) << 3)) + SV_GroupThreadID.x)), ((int)(((uint)(((int)((uint)(_20.x) << 3)) & 524280)) + SV_GroupThreadID.y)))] = float4((((select(_211, _199, _192) - _208) * _188) + _208), (((select(_211, _200, _193) - _209) * _188) + _209), (((select(_211, _201, _194) - _210) * _188) + _210), (_180 * _45.w));
        break;
      }
      if (__loop_jump_target == 65) {
        __loop_jump_target = -1;
        continue;
      }
      if (__loop_jump_target != -1) {
        break;
      }
      break;
    }
  }
}