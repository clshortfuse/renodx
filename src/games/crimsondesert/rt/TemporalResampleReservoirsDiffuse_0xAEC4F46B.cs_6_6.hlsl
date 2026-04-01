#include "../shared.h"

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t79, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormalPrev : register(t91, space36);

Texture2D<float2> __3__36__0__0__g_velocity : register(t92, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaque : register(t49, space36);

Texture2D<uint> __3__36__0__0__g_depthOpaquePrev : register(t94, space36);

Texture2D<float4> __3__36__0__0__g_raytracingNormal : register(t104, space36);

Texture2D<uint4> __3__36__0__0__g_diffuseGIReservoirHitGeometryPrev : register(t33, space36);

Texture2D<uint2> __3__36__0__0__g_diffuseGIReservoirRadiancePrev : register(t45, space36);

RWTexture2D<float4> __3__38__0__1__g_raytracingHitResultUAV : register(u43, space38);

RWTexture2D<float> __3__38__0__1__g_raytracingDiffuseRayInversePDFUAV : register(u44, space38);

RWTexture2D<half4> __3__38__0__1__g_diffuseResultUAV : register(u12, space38);

RWTexture2D<uint4> __3__38__0__1__g_diffuseGIReservoirHitGeometryUAV : register(u15, space38);

RWTexture2D<uint2> __3__38__0__1__g_diffuseGIReservoirRadianceUAV : register(u16, space38);

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

cbuffer __3__35__0__0__EnvironmentLightingHistoryConstantBuffer : register(b0, space35) {
  float4 _environmentLightingHistory[4] : packoffset(c000.x);
};

cbuffer __3__1__0__0__RenderVoxelConstants : register(b0, space1) {
  float4 _renderParams : packoffset(c000.x);
  float4 _renderParams2 : packoffset(c001.x);
  float4 _cubemapViewPosRelative : packoffset(c002.x);
  float4 _lightingParams : packoffset(c003.x);
  float4 _tiledRadianceCacheParams : packoffset(c004.x);
  float _rtaoIntensity : packoffset(c005.x);
};

// RenoDX: R2 noise
uint _rndx_pcg(uint v) {
  uint state = v * 747796405u + 2891336453u;
  uint word  = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
  return (word >> 22u) ^ word;
}
float2 _rndx_sample_noise(uint2 pixelCoord, float frameIndex, uint streamIndex = 0u) {
  // Stream Index decorrelates different sampling uses across pipeline stages
  uint h = _rndx_pcg(pixelCoord.x + pixelCoord.y * 8192u + streamIndex * 65537u);
  float off1 = float(h) * (1.0f / 4294967296.0f);
  float off2 = float(_rndx_pcg(h)) * (1.0f / 4294967296.0f);
  float n = frameIndex;
  return frac(float2(off1 + n * 0.7548776662466927f,
                     off2 + n * 0.5698402909980532f));
}

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  float _24 = float((uint)SV_DispatchThreadID.x);
  float _25 = float((uint)SV_DispatchThreadID.y);
  float _31 = _bufferSizeAndInvSize.z * (_24 + 0.5f);
  float _32 = (_25 + 0.5f) * _bufferSizeAndInvSize.w;
  int _45 = (((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524);
  uint _46 = _45 + uint((_bufferSizeAndInvSize.x * _25) + _24);
  uint _54 = ((uint)((((int)((_46 << 4) + -1383041155u)) ^ ((int)(_46 + -1640531527u))) ^ ((int)(((uint)((uint)(_46) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
  uint _62 = ((uint)((((int)((_54 << 4) + -1556008596u)) ^ ((int)(_54 + 1013904242u))) ^ (((uint)(_54) >> 5) + -939442524))) + _46;
  uint _70 = ((uint)((((int)((_62 << 4) + -1383041155u)) ^ ((int)(_62 + 1013904242u))) ^ ((int)(((uint)((uint)(_62) >> 5)) + 2123724318u)))) + _54;
  uint _78 = ((uint)((((int)((_70 << 4) + -1556008596u)) ^ ((int)(_70 + -626627285u))) ^ (((uint)(_70) >> 5) + -939442524))) + _62;
  uint _86 = ((uint)((((int)((_78 << 4) + -1383041155u)) ^ ((int)(_78 + -626627285u))) ^ ((int)(((uint)((uint)(_78) >> 5)) + 2123724318u)))) + _70;
  uint _94 = ((uint)((((int)((_86 << 4) + -1556008596u)) ^ ((int)(_86 + 2027808484u))) ^ (((uint)(_86) >> 5) + -939442524))) + _78;
  uint _102 = ((uint)((((int)((_94 << 4) + -1383041155u)) ^ ((int)(_94 + 2027808484u))) ^ ((int)(((uint)((uint)(_94) >> 5)) + 2123724318u)))) + _86;
  uint _110 = ((uint)((((int)((_102 << 4) + -1556008596u)) ^ ((int)(_102 + 387276957u))) ^ (((uint)(_102) >> 5) + -939442524))) + _94;
  uint _118 = ((uint)((((int)((_110 << 4) + -1383041155u)) ^ ((int)(_110 + 387276957u))) ^ ((int)(((uint)((uint)(_110) >> 5)) + 2123724318u)))) + _102;
  uint _126 = ((uint)((((int)((_118 << 4) + -1556008596u)) ^ ((int)(_118 + -1253254570u))) ^ (((uint)(_118) >> 5) + -939442524))) + _110;
  uint _134 = ((uint)((((int)((_126 << 4) + -1383041155u)) ^ ((int)(_126 + -1253254570u))) ^ ((int)(((uint)((uint)(_126) >> 5)) + 2123724318u)))) + _118;
  uint _142 = ((uint)((((int)((_134 << 4) + -1556008596u)) ^ ((int)(_134 + 1401181199u))) ^ (((uint)(_134) >> 5) + -939442524))) + _126;
  uint _150 = ((uint)((((int)((_142 << 4) + -1383041155u)) ^ ((int)(_142 + 1401181199u))) ^ ((int)(((uint)((uint)(_142) >> 5)) + 2123724318u)))) + _134;
  uint _158 = ((uint)((((int)((_150 << 4) + -1556008596u)) ^ ((int)(_150 + -239350328u))) ^ (((uint)(_150) >> 5) + -939442524))) + _142;
  uint _166 = ((uint)((((int)((_158 << 4) + -1383041155u)) ^ ((int)(_158 + -239350328u))) ^ ((int)(((uint)((uint)(_158) >> 5)) + 2123724318u)))) + _150;
  int _179;
  bool _289;
  float _330;
  float _331;
  int _538;
  int _559;
  int _560;
  float _561;
  float _562;
  float _563;
  float _564;
  float _565;
  float _566;
  float _567;
  float _568;
  float _569;
  float _570;
  float _571;
  float _572;
  float _573;
  float _574;
  int _575;
  int _602;
  int _603;
  int _618;
  int _619;
  float _753;
  float _754;
  float _755;
  int _857;
  int _858;
  float _859;
  float _860;
  float _861;
  float _862;
  float _863;
  float _864;
  float _865;
  float _866;
  float _867;
  float _868;
  float _869;
  float _870;
  float _871;
  float _872;
  int _876;
  int _877;
  float _878;
  float _879;
  float _880;
  float _881;
  float _882;
  float _883;
  float _884;
  float _885;
  float _886;
  float _887;
  float _888;
  float _889;
  float _890;
  float _891;
  bool _892;
  float _980;
  float _981;
  float _982;
  float _983;
  float _984;
  float _985;
  float _986;
  float _987;
  float _988;
  float _989;
  float _990;
  float _991;
  float _992;
  int _993;
  float _994;
  bool _995;
  float _1069;
  float _1070;
  float _1071;
  float _1072;
  int _1073;
  int _1074;
  if ((_158 & 16777215) == 0) {
    _179 = ((int)(((uint)((((int)((_166 << 4) + -1556008596u)) ^ ((int)(_166 + -1879881855u))) ^ (((uint)(_166) >> 5) + -939442524))) + _158));
  } else {
    _179 = _158;
  }
  uint _181 = __3__36__0__0__g_depthOpaque.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
  int _183 = (uint)((uint)(_181.x)) >> 24;
  float _186 = float((uint)((uint)(_181.x & 16777215))) * 5.960465188081798e-08f;
  int _187 = _183 & 127;
  uint _189 = __3__36__0__0__g_sceneNormal.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
  float _205 = min(1.0f, ((float((uint)((uint)(_189.x & 1023))) * 0.001956947147846222f) + -1.0f));
  float _206 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_189.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _207 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_189.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _209 = rsqrt(dot(float3(_205, _206, _207), float3(_205, _206, _207)));
  float _210 = _209 * _205;
  float _211 = _209 * _206;
  float _212 = _209 * _207;
  if (((int)(_186 < 1.0000000116860974e-07f)) | ((int)(_186 == 1.0f))) {
    __3__38__0__1__g_diffuseGIReservoirHitGeometryUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = int4(0, 0, 0, 0);
    __3__38__0__1__g_diffuseGIReservoirRadianceUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = int2(0, 0);
  } else {
    float _221 = (_31 * 2.0f) + -1.0f;
    float _223 = 1.0f - (_32 * 2.0f);
    float _224 = max(1.0000000116860974e-07f, _186);
    float _260 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _224, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _223, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _221))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
    float _261 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _224, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _223, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _221))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _260;
    float _262 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _224, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _223, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _221))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _260;
    float _263 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _224, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _223, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _221))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _260;
    float _266 = _nearFarProj.x / _224;
    if ((_183 & 128) == 0) {
      bool __defer_269_286 = false;
      if ((uint)_187 > (uint)52) {
        if (!(((int)((_183 & 125) == 105)) | ((int)((uint)_187 < (uint)68)))) {
          __defer_269_286 = true;
        } else {
          _289 = true;
        }
      } else {
        if ((uint)_187 > (uint)10) {
          if ((uint)_187 < (uint)20) {
            if ((_183 & 126) == 14) {
              __defer_269_286 = true;
            } else {
              _289 = true;
            }
          } else {
            if (!((_183 & 125) == 105)) {
              __defer_269_286 = true;
            } else {
              _289 = true;
            }
          }
        } else {
          __defer_269_286 = true;
        }
      }
      if (__defer_269_286) {
        _289 = (_187 == 98);
      }
    } else {
      _289 = true;
    }
    float _317 = mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).w), _186, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).w), _223, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).w) * _221))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).w);
    if (_289) {
      float2 _324 = __3__36__0__0__g_velocity.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
      _330 = (_324.x * 2.0f);
      _331 = (_324.y * 2.0f);
    } else {
      _330 = (((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).x), _186, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).x), _223, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).x) * _221))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).x)) / _317) - _221);
      _331 = (((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).y), _186, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).y), _223, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).y) * _221))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).y)) / _317) - _223);
    }
    bool _339 = (_renderParams.x > 0.0f);

    // ============================================================
    // RenoDX: Area ReSTIR style subpixel tracking temporal reuse
    //
    // (testing)
    //
    // The vanilla reprojection maps pixel centers between frames but
    // ignores that TAA jitter shifts the subpixel position each frame.
    //
    // This causes temporal samples to be treated as "same pixel" when 
    // they're half a pixel apart, leading to boiling on foliage, 
    // hair and so on. 
    //
    // Area ReSTIR (Zhang et al., SIGGRAPH 2024) solves this by tracking
    // subpixel offsets per reservoir sample.
    //
    // _temporalAAJitter: (jitterX, jitterY, prevJitterX, prevJitterY)
    // in NDC space ([-1,1] range, sub-pixel magnitude).
    // The delta is converted to UV space (*0.5) for the pixel lookup.
    // ============================================================
    float _rndx_jitter_delta_u = 0.0f;
    float _rndx_jitter_delta_v = 0.0f;
    if (RT_QUALITY >= 0.5f) {
      // NDC jitter delta: current minus previous frame's jitter
      // Convert to UV space for the pixel coordinate offset
      _rndx_jitter_delta_u = (_temporalAAJitter.x - _temporalAAJitter.z) * 0.5f;
      _rndx_jitter_delta_v = (_temporalAAJitter.y - _temporalAAJitter.w) * 0.5f;
    }

    int _344 = int(floor(((_330 * 0.5f) + _31 + _rndx_jitter_delta_u) * _bufferSizeAndInvSize.x));
    int _345 = int(floor((_32 - (_331 * 0.5f) + _rndx_jitter_delta_v) * _bufferSizeAndInvSize.y));
    half4 _347 = __3__38__0__1__g_diffuseResultUAV.Load(int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y)));
    float4 _355 = __3__38__0__1__g_raytracingHitResultUAV.Load(int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y)));
    float _361 = rsqrt(dot(float3(_355.x, _355.y, _355.z), float3(_355.x, _355.y, _355.z)));
    float _362 = _361 * _355.x;
    float _363 = _361 * _355.y;
    float _364 = _361 * _355.z;
    float4 _366 = __3__36__0__0__g_raytracingNormal.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
    float _371 = abs(_355.w);
    float _375 = (_366.x * 2.0f) + -1.0f;
    float _376 = (_366.y * 2.0f) + -1.0f;
    float _377 = (_366.z * 2.0f) + -1.0f;
    float _379 = rsqrt(dot(float3(_375, _376, _377), float3(_375, _376, _377)));
    float _380 = _375 * _379;
    float _381 = _376 * _379;
    float _382 = _377 * _379;
    bool _388 = (_355.w < 0.0f) ^ (((int)(_382 == 0.0f)) & (((int)(((int)(_380 == 0.0f)) & ((int)(_381 == 0.0f))))));
    float _392 = select(_388, _380, (-0.0f - _362));
    float _393 = select(_388, _381, (-0.0f - _363));
    float _394 = select(_388, _382, (-0.0f - _364));
    float _395 = _371 * _362;
    float _396 = _371 * _363;
    float _397 = _371 * _364;
    bool _401 = ((int)(_187 == 57)) | ((int)((uint)(_187 + -53) < (uint)15));
    float _404 = max(0.10000000149011612f, (_266 * select(_401, 0.019999999552965164f, 0.10000000149011612f)));

    // ============================================================
    // RenoDX: Subpixel-aware validation threshold relaxation
    //
    // When TAA jitter shifts between frames, the reprojected position
    // is slightly off from the true surface correspondence. 
    //
    // The vanilla world space distance threshold (_404) can reject valid 
    // temporal neighbors that are only displaced by the jitter delta. 
    //
    // We widen the threshold proportionally to the jitter magnitude
    // ============================================================

    float _rndx_validation_threshold = _404;
    if (RT_QUALITY >= 0.5f) {
      float _rndx_jitter_mag = sqrt(_rndx_jitter_delta_u * _rndx_jitter_delta_u
                                  + _rndx_jitter_delta_v * _rndx_jitter_delta_v);
      // Scale jitter from UV to approximate world space at this depth
      // Factor of 2 accounts for NDC→UV halving and bilateral safety margin
      _rndx_validation_threshold = _404 + _266 * _rndx_jitter_mag * 2.0f;
    }
    uint _413 = ((uint)((((int)((_45 << 4) + -1383041155u)) ^ ((int)(_45 + -1640531527u))) ^ ((int)(((uint)((uint)(_45) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
    uint _421 = ((uint)((((int)((_413 << 4) + -1556008596u)) ^ ((int)(_413 + 1013904242u))) ^ (((uint)(_413) >> 5) + -939442524))) + _45;
    uint _429 = ((uint)((((int)((_421 << 4) + -1383041155u)) ^ ((int)(_421 + 1013904242u))) ^ ((int)(((uint)((uint)(_421) >> 5)) + 2123724318u)))) + _413;
    uint _437 = ((uint)((((int)((_429 << 4) + -1556008596u)) ^ ((int)(_429 + -626627285u))) ^ (((uint)(_429) >> 5) + -939442524))) + _421;
    uint _445 = ((uint)((((int)((_437 << 4) + -1383041155u)) ^ ((int)(_437 + -626627285u))) ^ ((int)(((uint)((uint)(_437) >> 5)) + 2123724318u)))) + _429;
    uint _453 = ((uint)((((int)((_445 << 4) + -1556008596u)) ^ ((int)(_445 + 2027808484u))) ^ (((uint)(_445) >> 5) + -939442524))) + _437;
    uint _461 = ((uint)((((int)((_453 << 4) + -1383041155u)) ^ ((int)(_453 + 2027808484u))) ^ ((int)(((uint)((uint)(_453) >> 5)) + 2123724318u)))) + _445;
    uint _469 = ((uint)((((int)((_461 << 4) + -1556008596u)) ^ ((int)(_461 + 387276957u))) ^ (((uint)(_461) >> 5) + -939442524))) + _453;
    uint _477 = ((uint)((((int)((_469 << 4) + -1383041155u)) ^ ((int)(_469 + 387276957u))) ^ ((int)(((uint)((uint)(_469) >> 5)) + 2123724318u)))) + _461;
    uint _485 = ((uint)((((int)((_477 << 4) + -1556008596u)) ^ ((int)(_477 + -1253254570u))) ^ (((uint)(_477) >> 5) + -939442524))) + _469;
    uint _493 = ((uint)((((int)((_485 << 4) + -1383041155u)) ^ ((int)(_485 + -1253254570u))) ^ ((int)(((uint)((uint)(_485) >> 5)) + 2123724318u)))) + _477;
    uint _501 = ((uint)((((int)((_493 << 4) + -1556008596u)) ^ ((int)(_493 + 1401181199u))) ^ (((uint)(_493) >> 5) + -939442524))) + _485;
    uint _509 = ((uint)((((int)((_501 << 4) + -1383041155u)) ^ ((int)(_501 + 1401181199u))) ^ ((int)(((uint)((uint)(_501) >> 5)) + 2123724318u)))) + _493;
    uint _517 = ((uint)((((int)((_509 << 4) + -1556008596u)) ^ ((int)(_509 + -239350328u))) ^ (((uint)(_509) >> 5) + -939442524))) + _501;
    uint _525 = ((uint)((((int)((_517 << 4) + -1383041155u)) ^ ((int)(_517 + -239350328u))) ^ ((int)(((uint)((uint)(_517) >> 5)) + 2123724318u)))) + _509;
    if ((_517 & 16777215) == 0) {
      _538 = ((int)(((uint)((((int)((_525 << 4) + -1556008596u)) ^ ((int)(_525 + -1879881855u))) ^ (((uint)(_525) >> 5) + -939442524))) + _517));
    } else {
      _538 = _517;
    }
    uint _539 = _538 * 48271;
    float _540 = _395 + _261;
    float _541 = _396 + _262;
    float _542 = _397 + _263;
    float _543 = dot(float3(float(_347.x), float(_347.y), float(_347.z)), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _545 = __3__38__0__1__g_raytracingDiffuseRayInversePDFUAV.Load(int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y)));
    float _548 = saturate(_545.x * 2.0f);
    _559 = 0;
    _560 = 1;
    _561 = 1.0f;
    _562 = 0.0f;
    _563 = 0.0f;
    _564 = 0.0f;
    _565 = 0.0f;
    _566 = 0.0f;
    _567 = 0.0f;
    _568 = 0.0f;
    _569 = 0.0f;
    _570 = 0.0f;
    _571 = 0.0f;
    _572 = 0.0f;
    _573 = 0.0f;
    _574 = 0.0f;
    _575 = 0;
    while(true) {
      bool _576 = (_575 == 4);
      if (!_576) {
        if (!(_575 == 0)) {
          uint _580 = _575 + uint(float((uint)((uint)(((int)(_179 * 48271)) & 16777215))) * 4.7624109811295057e-07f);
          int _582 = ((uint)(_580) >> 1) & 1;
          int _585 = (((uint)(_580) >> 2) & 1) ^ 1;
          int _588 = (((int)(_580 << 1)) & 2) + -1;
          _602 = ((int)(((uint)(_588 & (0 - (_585 | _582)))) + _344));
          _603 = ((int)(((uint)(((1 - (_582 << 1)) * _588) & (0 - (_585 | (_582 ^ 1))))) + _345));
        } else {
          _602 = _344;
          _603 = _345;
        }
      } else {
        _602 = (int)(SV_DispatchThreadID.x);
        _603 = (int)(SV_DispatchThreadID.y);
      }
      if ((_339) & ((int)((_575 & -5) == 0))) {
        int _608 = _539 & 3;
        int _610 = ((uint)(_539) >> 2) & 3;
        _618 = ((int)(((uint)(((int)(_602 + _608)) ^ 3)) - _608));
        _619 = ((int)(((uint)(((int)(_603 + _610)) ^ 3)) - _610));
      } else {
        _618 = _602;
        _619 = _603;
      }
      float _620 = float((int)(_618));
      float _621 = float((int)(_619));
      bool __defer_617_856 = false;
      if (!((((int)(((int)((int)_618 < (int)0)) | ((int)(_620 > (_bufferSizeAndInvSize.x + -1.0f)))))) | (((int)(((int)((int)_619 < (int)0)) | ((int)(_621 > (_bufferSizeAndInvSize.y + -1.0f)))))))) {
        uint _633 = __3__36__0__0__g_depthOpaquePrev.Load(int3(_618, _619, 0));
        uint _639 = __3__36__0__0__g_sceneNormalPrev.Load(int3(_618, _619, 0));
        float _655 = min(1.0f, ((float((uint)((uint)(_639.x & 1023))) * 0.001956947147846222f) + -1.0f));
        float _656 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_639.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _657 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_639.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _667 = (((_620 + 0.5f) * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f;
        float _670 = 1.0f - (((_621 + 0.5f) * 2.0f) * _bufferSizeAndInvSize.w);
        float _671 = max(1.0000000116860974e-07f, (float((uint)((uint)(_633.x & 16777215))) * 5.960465188081798e-08f));
        if (_576) {
          float _708 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _671, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _670, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _667))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
          _753 = ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _671, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _670, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _667))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _708);
          _754 = ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _671, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _670, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _667))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _708);
          _755 = ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _671, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _670, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _667))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _708);
        } else {
          float _748 = mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).w), _671, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).w), _670, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).w) * _667))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).w);
          _753 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).x), _671, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).x), _670, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).x) * _667))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).x)) / _748);
          _754 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).y), _671, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).y), _670, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).y) * _667))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).y)) / _748);
          _755 = ((mad((float4(_invViewProjRelativePrev[0].z, _invViewProjRelativePrev[1].z, _invViewProjRelativePrev[2].z, _invViewProjRelativePrev[3].z).z), _671, mad((float4(_invViewProjRelativePrev[0].y, _invViewProjRelativePrev[1].y, _invViewProjRelativePrev[2].y, _invViewProjRelativePrev[3].y).z), _670, ((float4(_invViewProjRelativePrev[0].x, _invViewProjRelativePrev[1].x, _invViewProjRelativePrev[2].x, _invViewProjRelativePrev[3].x).z) * _667))) + (float4(_invViewProjRelativePrev[0].w, _invViewProjRelativePrev[1].w, _invViewProjRelativePrev[2].w, _invViewProjRelativePrev[3].w).z)) / _748);
        }
        float _756 = rsqrt(dot(float3(_655, _656, _657), float3(_655, _656, _657))) * 511.0f;
        uint4 _768 = __3__36__0__0__g_diffuseGIReservoirHitGeometryPrev.Load(int3(_618, _619, 0));
        uint2 _774 = __3__36__0__0__g_diffuseGIReservoirRadiancePrev.Load(int3(_618, _619, 0));
        float _788 = min(1.0f, ((float((uint)((uint)((int)(uint((_756 * _655) + 511.5f)) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _789 = min(1.0f, ((float((uint)((uint)((int)(uint((_756 * _656) + 511.5f)) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _790 = min(1.0f, ((float((uint)((uint)((int)(uint((_756 * _657) + 511.5f)) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _792 = rsqrt(dot(float3(_788, _789, _790), float3(_788, _789, _790)));
        float _793 = _792 * _788;
        float _794 = _792 * _789;
        float _795 = _792 * _790;
        float _813 = min(1.0f, ((float((uint)((uint)(_768.w & 1023))) * 0.001956947147846222f) + -1.0f));
        float _814 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_768.w)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _815 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_768.w)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
        float _817 = rsqrt(dot(float3(_813, _814, _815), float3(_813, _814, _815)));
        float _818 = _817 * _813;
        float _819 = _817 * _814;
        float _820 = _817 * _815;
        float _822 = f16tof32(((uint)((uint)((uint)(_774.x)) >> 16)));
        int _823 = _774.x & 1023;
        int _825 = ((uint)((uint)(_774.x)) >> 10) & 63;
        float _826 = asfloat(_774.y);
        float _827 = _753 - (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x);
        float _828 = _754 - (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y);
        float _829 = _755 - (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z);
        float _830 = asfloat(_768.x) - (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x);
        float _831 = asfloat(_768.y) - (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y);
        float _832 = asfloat(_768.z) - (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z);
        float _833 = _827 - _261;
        float _834 = _828 - _262;
        float _835 = _829 - _263;
        float _842 = dot(float3(_viewDir.x, _viewDir.y, _viewDir.z), float3(_827, _828, _829));
        bool __branch_chain_752;
        if (dot(float3(_833, _834, _835), float3(_833, _834, _835)) > (_rndx_validation_threshold * _rndx_validation_threshold)) {
          _857 = _825;
          _858 = _823;
          _859 = _826;
          _860 = _822;
          _861 = _818;
          _862 = _819;
          _863 = _820;
          _864 = _830;
          _865 = _831;
          _866 = _832;
          _867 = _793;
          _868 = _794;
          _869 = _795;
          _870 = _827;
          _871 = _828;
          _872 = _829;
          __branch_chain_752 = true;
        } else {
          if (((int)(_842 <= 0.20000000298023224f)) | ((int)(abs(_842 - _266) >= max(0.5f, (_266 * 0.019999999552965164f))))) {
            _857 = _825;
            _858 = _823;
            _859 = _826;
            _860 = _822;
            _861 = _818;
            _862 = _819;
            _863 = _820;
            _864 = _830;
            _865 = _831;
            _866 = _832;
            _867 = _793;
            _868 = _794;
            _869 = _795;
            _870 = _827;
            _871 = _828;
            _872 = _829;
            __branch_chain_752 = true;
          } else {
            if (((int)(dot(float3(_793, _794, _795), float3(_210, _211, _212)) <= 0.0f)) & (((int)(!_576)))) {
              _857 = _825;
              _858 = _823;
              _859 = _826;
              _860 = _822;
              _861 = _818;
              _862 = _819;
              _863 = _820;
              _864 = _830;
              _865 = _831;
              _866 = _832;
              _867 = _793;
              _868 = _794;
              _869 = _795;
              _870 = _827;
              _871 = _828;
              _872 = _829;
              __branch_chain_752 = true;
            } else {
              _876 = _825;
              _877 = _823;
              _878 = _826;
              _879 = _822;
              _880 = _818;
              _881 = _819;
              _882 = _820;
              _883 = _830;
              _884 = _831;
              _885 = _832;
              _886 = _793;
              _887 = _794;
              _888 = _795;
              _889 = _827;
              _890 = _828;
              _891 = _829;
              _892 = true;
              __branch_chain_752 = false;
            }
          }
        }
        if (__branch_chain_752) {
          __defer_617_856 = true;
        }
      } else {
        _857 = _559;
        _858 = _560;
        _859 = _561;
        _860 = _562;
        _861 = _563;
        _862 = _564;
        _863 = _565;
        _864 = _566;
        _865 = _567;
        _866 = _568;
        _867 = _569;
        _868 = _570;
        _869 = _571;
        _870 = _572;
        _871 = _573;
        _872 = _574;
        __defer_617_856 = true;
      }
      if (__defer_617_856) {
        int _873 = _575 + 1;
        if ((uint)_873 < (uint)5) {
          _559 = _857;
          _560 = _858;
          _561 = _859;
          _562 = _860;
          _563 = _861;
          _564 = _862;
          _565 = _863;
          _566 = _864;
          _567 = _865;
          _568 = _866;
          _569 = _867;
          _570 = _868;
          _571 = _869;
          _572 = _870;
          _573 = _871;
          _574 = _872;
          _575 = _873;
          continue;
        } else {
          _876 = _857;
          _877 = _858;
          _878 = _859;
          _879 = _860;
          _880 = _861;
          _881 = _862;
          _882 = _863;
          _883 = _864;
          _884 = _865;
          _885 = _866;
          _886 = _867;
          _887 = _868;
          _888 = _869;
          _889 = _870;
          _890 = _871;
          _891 = _872;
          _892 = false;
        }
      }
      // Direction from current surface to hit point
      float _903 = _883 - _261;
      float _904 = _884 - _262;
      float _905 = _885 - _263;
      // Squared distances: prev to hit and current to hit
      float _907 = dot(float3((_883 - _889), (_884 - _890), (_885 - _891)), float3((_883 - _889), (_884 - _890), (_885 - _891)));
      float _909 = dot(float3(_903, _904, _905), float3(_903, _904, _905));
      // Inverse distances
      float _912 = rsqrt(_909);
      float _913 = rsqrt(_907);
      // dist_curr² * cos(hit_normal, normalize(prev_to_hit))  (geometry term for visibility)
      float _914 = _909 * dot(float3(_913 * (_883 - _889), _913 * (_884 - _890), _913 * (_885 - _891)), float3(_880, _881, _882));
      // Normalized direction from current surface to hit (for BRDF)
      float _918 = _912 * _903;
      float _919 = _912 * _904;
      float _920 = _912 * _905;
      // Clamped Jacobian for path reconnection
      float _926 = min(max(((-0.0f - (_907 * dot(float3(_918, _919, _920), float3(_880, _881, _882)))) / (-0.0f - _914)), 0.0f), 1.0f);
      bool __defer_875_1048 = false;
      if (!(_892) || ((_892) && (!(!(((dot(float3((_883 - _261), (_884 - _262), (_885 - _263)), float3((_883 - _261), (_884 - _262), (_885 - _263)))) * dot(float3(((rsqrt((dot(float3((_883 - _889), (_884 - _890), (_885 - _891)), float3((_883 - _889), (_884 - _890), (_885 - _891)))))) * (_883 - _889)), ((rsqrt((dot(float3((_883 - _889), (_884 - _890), (_885 - _891)), float3((_883 - _889), (_884 - _890), (_885 - _891)))))) * (_884 - _890)), ((rsqrt((dot(float3((_883 - _889), (_884 - _890), (_885 - _891)), float3((_883 - _889), (_884 - _890), (_885 - _891)))))) * (_885 - _891))), float3(_880, _881, _882))) >= -0.0f)))) || (((_892) && (!(((dot(float3((_883 - _261), (_884 - _262), (_885 - _263)), float3((_883 - _261), (_884 - _262), (_885 - _263)))) * dot(float3(((rsqrt((dot(float3((_883 - _889), (_884 - _890), (_885 - _891)), float3((_883 - _889), (_884 - _890), (_885 - _891)))))) * (_883 - _889)), ((rsqrt((dot(float3((_883 - _889), (_884 - _890), (_885 - _891)), float3((_883 - _889), (_884 - _890), (_885 - _891)))))) * (_884 - _890)), ((rsqrt((dot(float3((_883 - _889), (_884 - _890), (_885 - _891)), float3((_883 - _889), (_884 - _890), (_885 - _891)))))) * (_885 - _891))), float3(_880, _881, _882))) >= -0.0f))) && ((min(max(((-0.0f - (_907 * dot(float3((_912 * _903), (_912 * _904), (_912 * _905)), float3(_880, _881, _882)))) / (-0.0f - _914)), 0.0f), 1.0f)) == 0.0f))) {
        __defer_875_1048 = true;
      } else {
        float _932 = (_879 * 0.31830987334251404f) * max(0.10000000149011612f, dot(float3(_210, _211, _212), float3(_918, _919, _920)));
        float _938 = rsqrt(dot(float3(_395, _396, _397), float3(_395, _396, _397)));
        float _945 = (_543 * 0.31830987334251404f) * max(0.10000000149011612f, dot(float3(_210, _211, _212), float3((_938 * _395), (_938 * _396), (_938 * _397))));
        float _946 = _945 * _548;
        // RenoDX: Smooth exposure M-cap sigmoid replaces linear cliff
        // Vanilla did 256 - saturate(exp*10)*192 → snaps from 256 to 64 over a tiny range
        // RenoDX does logistic sigmoid with gentle rolloff centered at exposure=0.5
        // cap range stays [64, 256], but transitions smoothly across the full exposure range
        // Seems Pearl Abyss may have used a smooth curve? They gimped bounced lighting to reduce noise
        float _961;
        if (RT_QUALITY > 0.5f) {
          float _rndx_t = 1.0f / (1.0f + exp(-6.0f * (_exposure3.w - 0.5f)));
          _961 = select(((_401) | (_339)), 32.0f, lerp(256.0f, 64.0f, _rndx_t));
        } else {
          _961 = select(((_401) | (_339)), 32.0f, (256.0f - (saturate(_exposure3.w * 10.0f) * 192.0f)));
        }
        bool _970 = ((int)((float((uint)((uint)(((int)(_179 * -856141137)) & 16777215))) * 5.960464477539063e-08f) < (1.0f / _961))) | ((int)(float((uint)_876) > _961));
        int _971 = select(_970, 0, _877);
        float _973 = select(_970, 0.0f, (((float((uint)_877) * _878) * _926) * _932)) + _946;
        if (!((((float((uint)((uint)(((int)(_179 * -1964877855)) & 16777215))) * 5.960464477539063e-08f) * select(_339, 1.0f, (1.0f - saturate(((_environmentLightingHistory[1]).w) + _temporalReprojectionParams.w)))) * _973) <= _946)) {
          _980 = _889;
          _981 = _890;
          _982 = _891;
          _983 = _886;
          _984 = _887;
          _985 = _888;
          _986 = _883;
          _987 = _884;
          _988 = _885;
          _989 = _880;
          _990 = _881;
          _991 = _882;
          _992 = select(_970, 0.0f, _879);
          _993 = _876;
          _994 = _932;
          _995 = false;
        } else {
          _980 = _261;
          _981 = _262;
          _982 = _263;
          _983 = _210;
          _984 = _211;
          _985 = _212;
          _986 = _540;
          _987 = _541;
          _988 = _542;
          _989 = _392;
          _990 = _393;
          _991 = _394;
          _992 = _543;
          _993 = 0;
          _994 = _945;
          _995 = true;
        }
        float _996 = _986 - _980;
        float _997 = _987 - _981;
        float _998 = _988 - _982;
        float _1000 = rsqrt(dot(float3(_996, _997, _998), float3(_996, _997, _998)));
        float _1007 = (_992 * 0.31830987334251404f) * max(0.10000000149011612f, dot(float3(_983, _984, _985), float3((_1000 * _996), (_1000 * _997), (_1000 * _998))));
        float _1012 = ((_1007 * float((uint)_971)) + _994) * _994;
        _1069 = saturate(select((_1012 == 0.0f), 0.0f, ((select(_995, _994, _1007) * _973) / _1012)));
        _1070 = _986;
        _1071 = _987;
        _1072 = _988;
        _1073 = (((((int)(uint((_990 * 511.0f) + 511.5f) << 10)) & 1047552) | ((int)(uint((_989 * 511.0f) + 511.5f)) & 1023)) | (((int)(uint((_991 * 511.0f) + 511.5f) << 20)) & 1072693248));
        _1074 = (((((int)((uint)(min(1023, min(1023, ((int)(_971 + 1u))))) << 10)) & 1047552) | (min(63, ((int)(_993 + 1u))) & 63)) | ((int)(f32tof16((_exposure4.y * _992)) << 16)));
      }
      if (__defer_875_1048) {
        _1069 = _548;
        _1070 = _540;
        _1071 = _541;
        _1072 = _542;
        _1073 = (((((int)(uint((_393 * 511.0f) + 511.5f) << 10)) & 1047552) | ((int)(uint((_392 * 511.0f) + 511.5f)) & 1023)) | (((int)(uint((_394 * 511.0f) + 511.5f) << 20)) & 1072693248));
        _1074 = (((int)(f32tof16(_543) << 16)) | 1025);
      }
      __3__38__0__1__g_diffuseGIReservoirHitGeometryUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = int4(asint(_1070), asint(_1071), asint(_1072), _1073);
      __3__38__0__1__g_diffuseGIReservoirRadianceUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = int2(_1074, asint(_1069));
      break;
    }
  }
}
