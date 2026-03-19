#include "../shared.h"

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t31, space36);

Texture2D<float2> __3__36__0__0__g_sceneAO : register(t166, space36);

Texture2D<float4> __3__36__0__0__g_tiledRadianceCachePlane : register(t57, space36);

Texture2D<float4> __3__36__0__0__g_tiledRadianceCacheOctahedron : register(t65, space36);

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

cbuffer __3__35__0__0__VoxelGlobalIlluminationConstantBuffer : register(b2, space35) {
  float4 _voxelParams : packoffset(c000.x);
  float4 _invClipmapExtent : packoffset(c001.x);
  float4 _wrappedViewPosForInject : packoffset(c002.x);
  float4 _clipmapOffsetsForInject[8] : packoffset(c003.x);
  float4 _clipmapRelativeIndexOffsetsForInject[8] : packoffset(c011.x);
  float4 _wrappedViewPos : packoffset(c019.x);
  float4 _clipmapOffsets[8] : packoffset(c020.x);
  float4 _clipmapOffsetsPrev[8] : packoffset(c028.x);
  float4 _clipmapRelativeIndexOffsets[8] : packoffset(c036.x);
  float4 _clipmapUVParams[2] : packoffset(c044.x);
  float4 _clipmapUVRelativeOffset : packoffset(c046.x);
  uint4 _surfelTimestamps : packoffset(c047.x);
};

cbuffer __3__1__0__0__FilteringConstants : register(b0, space1) {
  float4 _filteringParams : packoffset(c000.x);
  float4 _reconstructParams : packoffset(c001.x);
  float4 _tiledRadianceCacheParams : packoffset(c002.x);
};

// RenoDX: R2 noise 
uint _rndx_pcg(uint v) {
  uint state = v * 747796405u + 2891336453u;
  uint word  = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
  return (word >> 22u) ^ word;
}
float2 _rndx_sample_noise(uint2 pixelCoord, float frameIndex, uint streamIndex = 0u) {
  // streamIndex decorrelates different sampling uses across pipeline stages
  uint h = _rndx_pcg(pixelCoord.x + pixelCoord.y * 8192u + streamIndex * 65537u);
  float off1 = float(h) * (1.0f / 4294967296.0f);
  float off2 = float(_rndx_pcg(h)) * (1.0f / 4294967296.0f);
  float n = frameIndex;
  return frac(float2(off1 + n * 0.7548776662466927f,
                     off2 + n * 0.5698402909980532f));
}

static const int _global_0[32] = { -7, -8, 0, -7, -4, -6, 3, -5, 7, -4, -1, -3, -5, -2, 4, -1, -8, 0, 1, 1, -3, 2, 5, 3, -6, 4, 2, 5, -2, 6, 6, 7 };

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int _11[4];
  int _20[4];
  int _21[4];
  int _22 = (int)(SV_GroupID.x) & 15;
  int _23 = (uint)(_22) >> 2;
  _11[0] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).x));
  _11[1] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).y));
  _11[2] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).z));
  _11[3] = ((float)((g_tileIndex[(uint)(SV_GroupID.x) >> 6]).w));
  int _41 = _11[(((uint)(SV_GroupID.x) >> 4) & 3)];
  uint _47 = (((uint)((_22 - (_23 << 2)) << 3)) + SV_GroupThreadID.x) + ((uint)(((int)(_41 << 5)) & 2097120));
  uint _49 = (((uint)(_23 << 3)) + SV_GroupThreadID.y) + ((uint)(((uint)(_41) >> 16) << 5));
  uint _54 = __3__36__0__0__g_depthStencil.Load(int3(_47, _49, 0));
  int _56 = (uint)((uint)(_54.x)) >> 24;
  float _59 = float((uint)((uint)(_54.x & 16777215))) * 5.960465188081798e-08f;

  // RenoDX Debug: visualise stream indexed R2 noise when rt_quality == 2 (Debug Noise)
  // R = stream 0 (ray gen), G = stream 1 (bilateral octahedron), B = stream 3 (spatial neighbor)
  if (RT_QUALITY > 1.5f) {
    float2 s0 = _rndx_sample_noise(uint2(_47, _49), _frameNumber.x, 0u);
    float2 s1 = _rndx_sample_noise(uint2(_47, _49), _frameNumber.x, 1u);
    float2 s3 = _rndx_sample_noise(uint2(_47, _49), _frameNumber.x, 3u);
    __3__38__0__1__g_textureResultUAV[int2(_47, _49)] = float4(s0.x, s1.x, s3.x, 0.0f);
    return;
  }
  bool _151;
  int _153;
  int _211;
  int _428;
  int _476;
  int _477;
  int _478;
  float _479;
  float _480;
  float _481;
  float _482;
  int _483;
  int _657;
  float _781;
  float _782;
  float _783;
  if (!(((int)(_59 < 1.0000000116860974e-07f)) | ((int)(_59 == 1.0f)))) {
    float _64 = float((int)(_49));
    float _68 = float((int)(_47));
    int _72 = _56 & 127;
    float _82 = ((_bufferSizeAndInvSize.z * 2.0f) * (float((int)((int)(uint(_68 / (float4(g_screenSpaceScale.x, g_screenSpaceScale.y, __padding.x, __padding.y).x))))) + 0.5f)) + -1.0f;
    float _85 = 1.0f - (((float((int)((int)(uint(_64 / (float4(g_screenSpaceScale.x, g_screenSpaceScale.y, __padding.x, __padding.y).y))))) + 0.5f) * 2.0f) * _bufferSizeAndInvSize.w);
    float _86 = max(1.0000000116860974e-07f, _59);
    float _122 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _86, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _85, (_82 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
    float _123 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _86, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _85, (_82 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _122;
    float _124 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _86, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _85, (_82 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _122;
    float _125 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _86, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _85, (_82 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _122;
    float _128 = _nearFarProj.x / _86;
    if ((uint)_72 > (uint)11) {
      if (!(((int)(_72 == 97)) | (((int)(((int)(_72 == 55)) | (((int)(((int)(_72 == 33)) | (((int)(((int)((uint)_72 < (uint)21)) | ((int)(_72 == 107))))))))))))) {
        _151 = (((int)(_72 == 105)) | (((int)(((int)((_56 & 95) == 66)) | ((int)(_72 == 54))))));
      } else {
        _151 = true;
      }
    } else {
      _151 = ((_56 & 126) == 6);
    }
    _153 = 0;
    while(true) {
      int _193 = int(floor(((_wrappedViewPos.x + _123) * ((_clipmapOffsets[_153]).w)) + ((_clipmapRelativeIndexOffsets[_153]).x)));
      int _194 = int(floor(((_wrappedViewPos.y + _124) * ((_clipmapOffsets[_153]).w)) + ((_clipmapRelativeIndexOffsets[_153]).y)));
      int _195 = int(floor(((_wrappedViewPos.z + _125) * ((_clipmapOffsets[_153]).w)) + ((_clipmapRelativeIndexOffsets[_153]).z)));
      if (!((((int)((((int)(((int)((int)_193 >= (int)int(((_clipmapOffsets[_153]).x) + -63.0f))) & ((int)((int)_193 < (int)int(((_clipmapOffsets[_153]).x) + 63.0f)))))) & (((int)(((int)((int)_194 >= (int)int(((_clipmapOffsets[_153]).y) + -31.0f))) & ((int)((int)_194 < (int)int(((_clipmapOffsets[_153]).y) + 31.0f))))))))) & (((int)(((int)((int)_195 >= (int)int(((_clipmapOffsets[_153]).z) + -63.0f))) & ((int)((int)_195 < (int)int(((_clipmapOffsets[_153]).z) + 63.0f)))))))) {
        int _208 = _153 + 1;
        if ((uint)_208 < (uint)8) {
          _153 = _208;
          continue;
        } else {
          _211 = -10000;
        }
      } else {
        _211 = _153;
      }
      int _216 = (uint)(uint(_viewPos.w)) >> 5;
      uint _222 = (uint)(int(_reconstructParams.z)) + -1u;
      uint _224 = (uint)(int(_reconstructParams.w)) + ((uint)(_216 ^ -1));
      float _227 = (_bufferSizeAndInvSize.x * _64) + _68;
      uint _232 = uint(_227 + float((uint)((uint)(((int)((int4(_frameNumber).x) * 73)) & 1023))));
      int _233 = (uint)(_232) >> 1;
      int _235 = (uint)(_232) >> 3;
      float _247 = float((uint)_232);
      float _250 = 0.33676624298095703f / sqrt(_247 + -0.30000001192092896f);
      float _255 = (_250 + (_247 * 0.7548776268959045f)) * ((float((uint)((uint)(((int)(_233 * -1029531031)) ^ _235))) * 2.3283064365386963e-10f) + -0.5f);
      float _256 = (_250 + (_247 * 0.5698402523994446f)) * ((float((uint)((uint)(((int)((((int)(_233 * 1103515245)) ^ 1) * 1103515245)) ^ _235))) * 2.3283064365386963e-10f) + -0.5f);
      int _282 = int(min(max(float((int)((int)((uint)(int(floor(((_255 - floor(_255)) * 31.999000549316406f) + -16.0f))) + _47))), 1.0f), ((_bufferSizeAndInvSize.x * (float4(g_screenSpaceScale.x, g_screenSpaceScale.y, __padding.x, __padding.y).x)) + -1.0f)));
      int _283 = int(min(max(float((int)((int)((uint)(int(floor(((_256 - floor(_256)) * 31.999000549316406f) + -16.0f))) + _49))), 1.0f), ((_bufferSizeAndInvSize.y * (float4(g_screenSpaceScale.x, g_screenSpaceScale.y, __padding.x, __padding.y).y)) + -1.0f)));
      [branch]
      if (_151) {
        int _294 = (((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524);
        uint _295 = uint(_227) + _294;
        uint _303 = ((uint)((((int)((_295 << 4) + -1383041155u)) ^ ((int)(_295 + -1640531527u))) ^ ((int)(((uint)((uint)(_295) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
        uint _311 = ((uint)((((int)((_303 << 4) + -1556008596u)) ^ ((int)(_303 + 1013904242u))) ^ (((uint)(_303) >> 5) + -939442524))) + _295;
        uint _319 = ((uint)((((int)((_311 << 4) + -1383041155u)) ^ ((int)(_311 + 1013904242u))) ^ ((int)(((uint)((uint)(_311) >> 5)) + 2123724318u)))) + _303;
        uint _327 = ((uint)((((int)((_319 << 4) + -1556008596u)) ^ ((int)(_319 + -626627285u))) ^ (((uint)(_319) >> 5) + -939442524))) + _311;
        uint _335 = ((uint)((((int)((_327 << 4) + -1383041155u)) ^ ((int)(_327 + -626627285u))) ^ ((int)(((uint)((uint)(_327) >> 5)) + 2123724318u)))) + _319;
        uint _343 = ((uint)((((int)((_335 << 4) + -1556008596u)) ^ ((int)(_335 + 2027808484u))) ^ (((uint)(_335) >> 5) + -939442524))) + _327;
        uint _351 = ((uint)((((int)((_343 << 4) + -1383041155u)) ^ ((int)(_343 + 2027808484u))) ^ ((int)(((uint)((uint)(_343) >> 5)) + 2123724318u)))) + _335;
        uint _359 = ((uint)((((int)((_351 << 4) + -1556008596u)) ^ ((int)(_351 + 387276957u))) ^ (((uint)(_351) >> 5) + -939442524))) + _343;
        uint _367 = ((uint)((((int)((_359 << 4) + -1383041155u)) ^ ((int)(_359 + 387276957u))) ^ ((int)(((uint)((uint)(_359) >> 5)) + 2123724318u)))) + _351;
        uint _375 = ((uint)((((int)((_367 << 4) + -1556008596u)) ^ ((int)(_367 + -1253254570u))) ^ (((uint)(_367) >> 5) + -939442524))) + _359;
        uint _383 = ((uint)((((int)((_375 << 4) + -1383041155u)) ^ ((int)(_375 + -1253254570u))) ^ ((int)(((uint)((uint)(_375) >> 5)) + 2123724318u)))) + _367;
        uint _391 = ((uint)((((int)((_383 << 4) + -1556008596u)) ^ ((int)(_383 + 1401181199u))) ^ (((uint)(_383) >> 5) + -939442524))) + _375;
        uint _399 = ((uint)((((int)((_391 << 4) + -1383041155u)) ^ ((int)(_391 + 1401181199u))) ^ ((int)(((uint)((uint)(_391) >> 5)) + 2123724318u)))) + _383;
        uint _407 = ((uint)((((int)((_399 << 4) + -1556008596u)) ^ ((int)(_399 + -239350328u))) ^ (((uint)(_399) >> 5) + -939442524))) + _391;
        uint _415 = ((uint)((((int)((_407 << 4) + -1383041155u)) ^ ((int)(_407 + -239350328u))) ^ ((int)(((uint)((uint)(_407) >> 5)) + 2123724318u)))) + _399;
        if ((_407 & 16777215) == 0) {
          _428 = ((int)(((uint)((((int)((_415 << 4) + -1556008596u)) ^ ((int)(_415 + -1879881855u))) ^ (((uint)(_415) >> 5) + -939442524))) + _407));
        } else {
          _428 = _407;
        }
        int _440 = min(max((((uint)(_282 + 16u) >> 5) + -1), 0), _222);
        int _441 = min(max((((uint)(_283 + 16u) >> 5) + -1), _216), _224);
        int _446 = min(max(((int)(_440 + 1u)), 0), _222);
        int _447 = min(max(((int)(_441 + 1u)), _216), _224);
        bool _450 = ((uint)((int)(_211 + 9999u)) < (uint)10003);
        int _455 = select(((_450) & ((int)(_440 == _446))), ((int)(_446 + -1u)), _440);
        int _456 = select(((_450) & ((int)(_441 == _447))), ((int)(_447 + -1u)), _441);
        _20[0] = _455;
        _21[0] = _456;
        _20[1] = _446;
        _21[1] = _456;
        _20[2] = _455;
        _21[2] = _447;
        _20[3] = _446;
        _21[3] = _447;
        _476 = _456;
        _477 = _455;
        _478 = _428;
        _479 = 0.0f;
        _480 = 0.0f;
        _481 = 0.0f;
        _482 = 0.0f;
        _483 = 0;
        while(true) {
          float4 _485 = __3__36__0__0__g_tiledRadianceCachePlane.Load(int3(_477, _476, 0));
          uint _495 = _478 * -1964877855;
          // RenoDX: R2+CP blue noise for octahedron sub-sample selection
          int _rndx_octX, _rndx_octY;
          if (RT_QUALITY > 0.5f) {
            float2 _rndx_oct = _rndx_sample_noise(SV_DispatchThreadID.xy, _frameNumber.x, 1u + (uint)_483);
            _rndx_octX = (int)(uint(_rndx_oct.x * 8.0f) + ((uint)_477 << 3));
            _rndx_octY = (int)(uint(_rndx_oct.y * 8.0f) + ((uint)_476 << 3));
          } else {
            _rndx_octX = ((int)(uint(float((uint)((uint)(((int)(_478 * 48271)) & 16777215))) * 4.7624109811295057e-07f) + (_477 << 3)));
            _rndx_octY = ((int)(uint(float((uint)((uint)(_495 & 16777215))) * 4.7624109811295057e-07f) + (_476 << 3)));
          }
          float4 _505 = __3__36__0__0__g_tiledRadianceCacheOctahedron.Load(int3(_rndx_octX, _rndx_octY, 0));
          uint _524 = (_477 + _294) + (((uint)(uint(_bufferSizeAndInvSize.x)) >> 5) * _476);
          uint _532 = ((uint)((((int)((_524 << 4) + -1383041155u)) ^ ((int)(_524 + -1640531527u))) ^ ((int)(((uint)((uint)(_524) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
          uint _540 = ((uint)((((int)((_532 << 4) + -1556008596u)) ^ ((int)(_532 + 1013904242u))) ^ (((uint)(_532) >> 5) + -939442524))) + _524;
          uint _548 = ((uint)((((int)((_540 << 4) + -1383041155u)) ^ ((int)(_540 + 1013904242u))) ^ ((int)(((uint)((uint)(_540) >> 5)) + 2123724318u)))) + _532;
          uint _556 = ((uint)((((int)((_548 << 4) + -1556008596u)) ^ ((int)(_548 + -626627285u))) ^ (((uint)(_548) >> 5) + -939442524))) + _540;
          uint _564 = ((uint)((((int)((_556 << 4) + -1383041155u)) ^ ((int)(_556 + -626627285u))) ^ ((int)(((uint)((uint)(_556) >> 5)) + 2123724318u)))) + _548;
          uint _572 = ((uint)((((int)((_564 << 4) + -1556008596u)) ^ ((int)(_564 + 2027808484u))) ^ (((uint)(_564) >> 5) + -939442524))) + _556;
          uint _580 = ((uint)((((int)((_572 << 4) + -1383041155u)) ^ ((int)(_572 + 2027808484u))) ^ ((int)(((uint)((uint)(_572) >> 5)) + 2123724318u)))) + _564;
          uint _588 = ((uint)((((int)((_580 << 4) + -1556008596u)) ^ ((int)(_580 + 387276957u))) ^ (((uint)(_580) >> 5) + -939442524))) + _572;
          uint _596 = ((uint)((((int)((_588 << 4) + -1383041155u)) ^ ((int)(_588 + 387276957u))) ^ ((int)(((uint)((uint)(_588) >> 5)) + 2123724318u)))) + _580;
          uint _604 = ((uint)((((int)((_596 << 4) + -1556008596u)) ^ ((int)(_596 + -1253254570u))) ^ (((uint)(_596) >> 5) + -939442524))) + _588;
          uint _612 = ((uint)((((int)((_604 << 4) + -1383041155u)) ^ ((int)(_604 + -1253254570u))) ^ ((int)(((uint)((uint)(_604) >> 5)) + 2123724318u)))) + _596;
          uint _620 = ((uint)((((int)((_612 << 4) + -1556008596u)) ^ ((int)(_612 + 1401181199u))) ^ (((uint)(_612) >> 5) + -939442524))) + _604;
          uint _628 = ((uint)((((int)((_620 << 4) + -1383041155u)) ^ ((int)(_620 + 1401181199u))) ^ ((int)(((uint)((uint)(_620) >> 5)) + 2123724318u)))) + _612;
          uint _636 = ((uint)((((int)((_628 << 4) + -1556008596u)) ^ ((int)(_628 + -239350328u))) ^ (((uint)(_628) >> 5) + -939442524))) + _620;
          uint _644 = ((uint)((((int)((_636 << 4) + -1383041155u)) ^ ((int)(_636 + -239350328u))) ^ ((int)(((uint)((uint)(_636) >> 5)) + 2123724318u)))) + _628;
          if ((_636 & 16777215) == 0) {
            _657 = ((int)(((uint)((((int)((_644 << 4) + -1556008596u)) ^ ((int)(_644 + -1879881855u))) ^ (((uint)(_644) >> 5) + -939442524))) + _636));
          } else {
            _657 = _636;
          }
          // RenoDX: Bilateral jitter: R2 blue noise with reduced range (±4px vs vanilla ±16px)
          // Vanilla ±16px pulls samples from different geometry at boundaries, causing shimmer.
          // skip the table entirely, map R2 directly to ±4px offset.
          uint _675 = _477 << 5;
          uint _676 = _476 << 5;
          float _690, _693;
          if (RT_QUALITY > 0.5f) {
            float2 _rndx_jitter2d = _rndx_sample_noise(SV_DispatchThreadID.xy, _frameNumber.x, 5u + (uint)_483);
            int _rndx_jX = (int)(_rndx_jitter2d.x * 8.0f) - 4;  // [-4, +3]
            int _rndx_jY = (int)(_rndx_jitter2d.y * 8.0f) - 4;  // [-4, +3]
            _690 = ((_bufferSizeAndInvSize.z * 2.0f) * (float((uint)((uint)(_rndx_jX) + (_675 | 16u))) + 0.5f)) + -1.0f;
            _693 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (float((uint)((uint)(_rndx_jY) + (_676 | 16u))) + 0.5f));
          } else {
            int _664 = (int)(uint(floor(float((uint)((uint)(((int)(_657 * 48271)) & 16777215))) * 9.53614687659865e-07f))) & 15;
            _690 = ((_bufferSizeAndInvSize.z * 2.0f) * (float((uint)((((uint)(_global_0[((int)(0u + (_664 * 2)))])) << 1) + ((uint)(_675 | 16)))) + 0.5f)) + -1.0f;
            _693 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (float((uint)((((uint)(_global_0[((int)(1u + (_664 * 2)))])) << 1) + ((uint)(_676 | 16)))) + 0.5f));
          }
          float _694 = max(1.0000000116860974e-07f, (_nearFarProj.x / _485.w));
          float _730 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _694, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _693, (_690 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
          float _734 = _123 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _694, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _693, (_690 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _730);
          float _735 = _124 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _694, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _693, (_690 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _730);
          float _736 = _125 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _694, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _693, (_690 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _730);
          float _738 = dot(float3(_485.x, _485.y, _485.z), float3(_734, _735, _736));
          float _739 = _738 * _738;
          float _765 = select((_485.w > 1e+06f), 0.0f, min(exp2((-0.14426951110363007f / (((_128 * _128) * 0.10000000149011612f) + 0.004999999888241291f)) * (max(0.0f, (dot(float3(_734, _735, _736), float3(_734, _735, _736)) - _739)) + _739)), ((1.0f - saturate(abs((float((int)((int)(_283 + -16u))) + 0.5f) - float((int)(_676))) * 0.03125f)) * (1.0f - saturate(abs((float((int)((int)(_282 + -16u))) + 0.5f) - float((int)(_675))) * 0.03125f)))));
          float _769 = _479 - (_765 * min(0.0f, (-0.0f - _505.x)));
          float _770 = _480 - (_765 * min(0.0f, (-0.0f - _505.y)));
          float _771 = _481 - (_765 * min(0.0f, (-0.0f - _505.z)));
          float _772 = _765 + _482;
          int _773 = _483 + 1;
          if (!(_773 == 4)) {
            _476 = (_21[_773]);
            _477 = (_20[_773]);
            _478 = _495;
            _479 = _769;
            _480 = _770;
            _481 = _771;
            _482 = _772;
            _483 = _773;
            continue;
          }
          float _468 = max(9.999999974752427e-07f, _772);
          _781 = ((_769 / _468) * 3.1415927410125732f);
          _782 = ((_770 / _468) * 3.1415927410125732f);
          _783 = ((_771 / _468) * 3.1415927410125732f);
          break;
        }
        if (__loop_jump_target == 152) {
          __loop_jump_target = -1;
          continue;
        }
        if (__loop_jump_target != -1) {
          break;
        }
      } else {
        _781 = 0.0f;
        _782 = 0.0f;
        _783 = 0.0f;
      }
      float4 _785 = __3__38__0__1__g_textureResultUAV.Load(int2(_47, _49));
      float2 _793 = __3__36__0__0__g_sceneAO.Load(int3(_47, _49, 0));
      float _802 = select((((int)(_72 == 98)) | (((int)(((int)((_56 & 126) == 96)) & ((int)((uint)(_72 + -53) > (uint)14)))))), 0.20000000298023224f, 0.8999999761581421f);
      float _805 = (_793.x * _802) + (1.0f - _802);
      __3__38__0__1__g_textureResultUAV[int2(_47, _49)] = float4((_805 * (_785.x + _781)), (_805 * (_785.y + _782)), (_805 * (_785.z + _783)), 0.0f);
      break;
    }
  }
}
