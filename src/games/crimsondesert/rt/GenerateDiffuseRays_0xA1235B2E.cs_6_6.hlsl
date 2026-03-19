#include "../shared.h"

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t50, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t31, space36);

Texture2D<float4> __3__36__0__0__g_tiledRadianceCachePlanePrev : register(t94, space36);

Texture2D<float> __3__36__0__0__g_tiledRadianceCachePDFPrev : register(t126, space36);

RWTexture2D<float4> __3__38__0__1__g_raytracingHitResultUAV : register(u43, space38);

RWTexture2D<float> __3__38__0__1__g_raytracingDiffuseRayInversePDFUAV : register(u44, space38);

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

cbuffer __3__1__0__0__RenderVoxelConstants : register(b0, space1) {
  float4 _renderParams : packoffset(c000.x);
  float4 _renderParams2 : packoffset(c001.x);
  float4 _cubemapViewPosRelative : packoffset(c002.x);
  float4 _lightingParams : packoffset(c003.x);
  float4 _tiledRadianceCacheParams : packoffset(c004.x);
  float _rtaoIntensity : packoffset(c005.x);
};

// RenoDX: R2 noise (doesnt seem to do much)
uint _rndx_pcg(uint v) {
  uint state = v * 747796405u + 2891336453u;
  uint word  = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
  return (word >> 22u) ^ word;
}
float2 _rndx_sample_noise(uint2 pixelCoord, float frameIndex, uint streamIndex = 0u) {
  uint h = _rndx_pcg(pixelCoord.x + pixelCoord.y * 8192u + streamIndex * 65537u);
  float off1 = float(h) * (1.0f / 4294967296.0f);
  float off2 = float(_rndx_pcg(h)) * (1.0f / 4294967296.0f);
  float n = frameIndex;
  return frac(float2(off1 + n * 0.7548776662466927f,
                     off2 + n * 0.5698402909980532f));
}

static const int _global_0[32] = { -7, -8, 0, -7, -4, -6, 3, -5, 7, -4, -1, -3, -5, -2, 4, -1, -8, 0, 1, 1, -3, 2, 5, 3, -6, 4, 2, 5, -2, 6, 6, 7 };
groupshared float _global_1[256];
groupshared float _global_2[192];

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int _16 = (int)(SV_GroupIndex) & 7;
  int _17 = (uint)(SV_GroupIndex) >> 3;
  _global_1[((int)(0u + (((int)(_16 + (_17 * 8))) * 4)))] = 0.0f;
  _global_1[((int)(1u + (((int)(_16 + (_17 * 8))) * 4)))] = 0.0f;
  _global_1[((int)(2u + (((int)(_16 + (_17 * 8))) * 4)))] = 0.0f;
  _global_1[((int)(3u + (((int)(_16 + (_17 * 8))) * 4)))] = 0.0f;
  _global_2[((int)(0u + (((int)(_16 + (_17 * 8))) * 3)))] = 0.0f;
  _global_2[((int)(1u + (((int)(_16 + (_17 * 8))) * 3)))] = 0.0f;
  _global_2[((int)(2u + (((int)(_16 + (_17 * 8))) * 3)))] = 0.0f;
  GroupMemoryBarrierWithGroupSync();

  float _57 = (float4(g_screenSpaceScale.x, g_screenSpaceScale.y, __padding.x, __padding.y).x) * _bufferSizeAndInvSize.x;
  uint _59 = __3__36__0__0__g_depthStencil.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
  float _64 = float((uint)((uint)(_59.x & 16777215))) * 5.960465188081798e-08f;
  int _65 = ((uint)((uint)(_59.x)) >> 24) & 127;
  uint _67 = __3__36__0__0__g_sceneNormal.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
  float _83 = min(1.0f, ((float((uint)((uint)(_67.x & 1023))) * 0.001956947147846222f) + -1.0f));
  float _84 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_67.x)) >> 10) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _85 = min(1.0f, ((float((uint)((uint)(((uint)((uint)(_67.x)) >> 20) & 1023))) * 0.001956947147846222f) + -1.0f));
  float _87 = rsqrt(dot(float3(_83, _84, _85), float3(_83, _84, _85)));
  float _88 = _87 * _83;
  float _89 = _87 * _84;
  float _90 = _87 * _85;
  float _91 = float((uint)SV_DispatchThreadID.x);
  float _92 = float((uint)SV_DispatchThreadID.y);
  float _97 = _bufferSizeAndInvSize.z * (_91 + 0.5f);
  float _98 = _bufferSizeAndInvSize.w * (_92 + 0.5f);
  float _101 = max(1.0000000116860974e-07f, _64);
  float _102 = _nearFarProj.x / _101;
  bool _163;
  int _452;
  int _667;
  int _879;
  int _1091;
  int _1457;
  int _1671;
  float _1679;
  int _1680;
  float _1685;
  int _1686;
  float _1737;
  int _1738;
  float _1739;
  int _1740;
  int _1741;
  int _1744;
  float _1745;
  bool _1802;
  int _1803;
  int _1804;
  float _1805;
  int _1992;
  int _2020;
  int _2157;
  float _2201;
  float _2202;
  float _2203;
  float _2204;
  float _2231;
  float _2232;
  float _2233;
  float _2234;
  if (!((((int)(!(_64 < 1.0000000116860974e-07f)))) & (((int)(!(_64 == 1.0f)))))) {
    __3__38__0__1__g_raytracingHitResultUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(-1.0f, -1.0f, -1.0f, -1.0f);
    __3__38__0__1__g_raytracingDiffuseRayInversePDFUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = 0.0f;
  } else {
    float _111 = (_97 * 2.0f) + -1.0f;
    float _113 = 1.0f - (_98 * 2.0f);
    float _149 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _101, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _113, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _111))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
    float _150 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _101, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _113, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _111))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _149;
    float _151 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _101, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _113, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _111))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _149;
    float _152 = (mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _101, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _113, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _111))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _149;
    bool __defer_109_160 = false;
    if ((uint)_65 > (uint)11) {
      if (!(((int)((uint)_65 < (uint)21)) | ((int)(_65 == 107)))) {
        __defer_109_160 = true;
      } else {
        _163 = true;
      }
    } else {
      if (!(_65 == 6)) {
        __defer_109_160 = true;
      } else {
        _163 = true;
      }
    }
    if (__defer_109_160) {
      _163 = (_65 == 7);
    }
    float _166 = float((uint)((uint)(int4(_frameNumber).x)));
    float _177 = (frac(((_166 * 92.0f) + _91) * 0.0078125f) * 128.0f) + -64.34062194824219f;
    float _178 = (frac(((_166 * 71.0f) + _92) * 0.0078125f) * 128.0f) + -72.46562194824219f;
    float _183 = frac(dot(float3((_177 * _177), (_178 * _178), (_178 * _177)), float3(20.390625f, 60.703125f, 2.4281208515167236f)));
    uint _186 = uint(_183 * 51540816.0f);
    uint _187 = uint(_183 * 287478368.0f);
    float _215 = mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).w), _64, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).w), _113, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).w) * _111))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).w);
    float _223 = (((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).x), _64, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).x), _113, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).x) * _111))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).x)) / _215) - _111) * 0.5f;
    float _224 = (((mad((float4(_projToPrevProj[0].z, _projToPrevProj[1].z, _projToPrevProj[2].z, _projToPrevProj[3].z).y), _64, mad((float4(_projToPrevProj[0].y, _projToPrevProj[1].y, _projToPrevProj[2].y, _projToPrevProj[3].y).y), _113, ((float4(_projToPrevProj[0].x, _projToPrevProj[1].x, _projToPrevProj[2].x, _projToPrevProj[3].x).y) * _111))) + (float4(_projToPrevProj[0].w, _projToPrevProj[1].w, _projToPrevProj[2].w, _projToPrevProj[3].w).y)) / _215) - _113) * 0.5f;
    float _225 = _223 + _97;
    float _226 = _98 - _224;
    if (!((((int)(((int)(_225 >= 0.0f)) & ((int)(_225 <= 1.0f))))) & (((int)(((int)(_226 >= 0.0f)) & ((int)(_226 <= 1.0f))))))) {
      _2020 = ((((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524));
      uint _2024 = _2020 + uint((_57 * _92) + _91);
      uint _2032 = ((uint)((((int)((_2024 << 4) + -1383041155u)) ^ ((int)(_2024 + -1640531527u))) ^ ((int)(((uint)((uint)(_2024) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
      uint _2040 = ((uint)((((int)((_2032 << 4) + -1556008596u)) ^ ((int)(_2032 + 1013904242u))) ^ (((uint)(_2032) >> 5) + -939442524))) + _2024;
      uint _2048 = ((uint)((((int)((_2040 << 4) + -1383041155u)) ^ ((int)(_2040 + 1013904242u))) ^ ((int)(((uint)((uint)(_2040) >> 5)) + 2123724318u)))) + _2032;
      uint _2056 = ((uint)((((int)((_2048 << 4) + -1556008596u)) ^ ((int)(_2048 + -626627285u))) ^ (((uint)(_2048) >> 5) + -939442524))) + _2040;
      uint _2064 = ((uint)((((int)((_2056 << 4) + -1383041155u)) ^ ((int)(_2056 + -626627285u))) ^ ((int)(((uint)((uint)(_2056) >> 5)) + 2123724318u)))) + _2048;
      uint _2072 = ((uint)((((int)((_2064 << 4) + -1556008596u)) ^ ((int)(_2064 + 2027808484u))) ^ (((uint)(_2064) >> 5) + -939442524))) + _2056;
      uint _2080 = ((uint)((((int)((_2072 << 4) + -1383041155u)) ^ ((int)(_2072 + 2027808484u))) ^ ((int)(((uint)((uint)(_2072) >> 5)) + 2123724318u)))) + _2064;
      uint _2088 = ((uint)((((int)((_2080 << 4) + -1556008596u)) ^ ((int)(_2080 + 387276957u))) ^ (((uint)(_2080) >> 5) + -939442524))) + _2072;
      uint _2096 = ((uint)((((int)((_2088 << 4) + -1383041155u)) ^ ((int)(_2088 + 387276957u))) ^ ((int)(((uint)((uint)(_2088) >> 5)) + 2123724318u)))) + _2080;
      uint _2104 = ((uint)((((int)((_2096 << 4) + -1556008596u)) ^ ((int)(_2096 + -1253254570u))) ^ (((uint)(_2096) >> 5) + -939442524))) + _2088;
      uint _2112 = ((uint)((((int)((_2104 << 4) + -1383041155u)) ^ ((int)(_2104 + -1253254570u))) ^ ((int)(((uint)((uint)(_2104) >> 5)) + 2123724318u)))) + _2096;
      uint _2120 = ((uint)((((int)((_2112 << 4) + -1556008596u)) ^ ((int)(_2112 + 1401181199u))) ^ (((uint)(_2112) >> 5) + -939442524))) + _2104;
      uint _2128 = ((uint)((((int)((_2120 << 4) + -1383041155u)) ^ ((int)(_2120 + 1401181199u))) ^ ((int)(((uint)((uint)(_2120) >> 5)) + 2123724318u)))) + _2112;
      uint _2136 = ((uint)((((int)((_2128 << 4) + -1556008596u)) ^ ((int)(_2128 + -239350328u))) ^ (((uint)(_2128) >> 5) + -939442524))) + _2120;
      uint _2144 = ((uint)((((int)((_2136 << 4) + -1383041155u)) ^ ((int)(_2136 + -239350328u))) ^ ((int)(((uint)((uint)(_2136) >> 5)) + 2123724318u)))) + _2128;
      if ((_2136 & 16777215) == 0) {
        _2157 = ((int)(((uint)((((int)((_2144 << 4) + -1556008596u)) ^ ((int)(_2144 + -1879881855u))) ^ (((uint)(_2144) >> 5) + -939442524))) + _2136));
      } else {
        _2157 = _2136;
      }
      // RenoDX: R2 noise (doesnt seem to do much)
      float _2169;
      float _2172;
      if (RT_QUALITY > 0.5f) {
        float2 _isfast = _rndx_sample_noise(SV_DispatchThreadID.xy, _frameNumber.x);
        _2169 = _isfast.x;
        _2172 = _isfast.y * 4294967296.0;
      } else {
        uint _2162 = uint(float((uint)((uint)(((int)(_2157 * 48271)) & 16777215))) * 3.8146913539094385e-06f);
        _2169 = frac((float((uint)_2162) * 0.015625f) + (float((uint)((uint)(_186 & 65535))) * 1.52587890625e-05f));
        _2172 = float((uint)((uint)(reversebits(_2162) ^ _187)));
      }
      bool __defer_2156_2189 = false;
      if (!(_163) || ((_163) && (!(_renderParams.w == 0.0f)))) {
        __defer_2156_2189 = true;
      } else {
        float _2179 = _2169 * 6.2831854820251465f;
        float _2181 = 1.0f - (_2172 * 4.656612873077393e-10f);
        float _2184 = sqrt(1.0f - (_2181 * _2181));
        _2201 = 0.5f;
        _2202 = (cos(_2179) * _2184);
        _2203 = (sin(_2179) * _2184);
        _2204 = _2181;
      }
      if (__defer_2156_2189) {
        float _2190 = _2169 * 6.2831854820251465f;
        float _2191 = sqrt(_2172 * 2.3283064365386963e-10f);
        float _2194 = sqrt(1.0f - (_2191 * _2191));
        _2201 = (_2191 * 2.0f);
        _2202 = (cos(_2190) * _2194);
        _2203 = (sin(_2190) * _2194);
        _2204 = _2191;
      }
      float _2206 = select((_90 >= 0.0f), 1.0f, -1.0f);
      float _2209 = -0.0f - (1.0f / (_2206 + _90));
      float _2210 = _89 * _2209;
      float _2211 = _2210 * _88;
      float _2212 = _2206 * _88;
      _2231 = mad(_2204, _88, mad(_2203, _2211, ((((_2212 * _88) * _2209) + 1.0f) * _2202)));
      _2232 = mad(_2204, _89, mad(_2203, (_2206 + (_2210 * _89)), ((_2202 * _2206) * _2211)));
      _2233 = mad(_2204, _90, mad(_2203, (-0.0f - _89), (-0.0f - (_2212 * _2202))));
      _2234 = _2201;
    } else {
      uint _246 = (uint)(int(_tiledRadianceCacheParams.z)) + -1u;
      uint _247 = (uint)(int(_tiledRadianceCacheParams.w)) + -1u;
      int _249 = (int)(uint(_tiledRadianceCacheParams.y)) & 31;
      float _270 = ((((float((uint)((uint)(((int)((uint)(min(max(((uint)(SV_DispatchThreadID.x) >> _249), 0), _246)) << 5)) | 16))) + 0.5f) * _bufferSizeAndInvSize.z) + _223) * _tiledRadianceCacheParams.z) + -0.5f;
      float _271 = ((((float((uint)((uint)(((int)((uint)(min(max(((uint)(SV_DispatchThreadID.y) >> _249), 0), _247)) << 5)) | 16))) + 0.5f) * _bufferSizeAndInvSize.w) - _224) * _tiledRadianceCacheParams.w) + -0.5f;
      int _274 = int(floor(_270));
      int _275 = int(floor(_271));
      float _278 = _270 - float((int)(_274));
      float _279 = _271 - float((int)(_275));
      float _280 = 1.0f - _278;
      float _281 = 1.0f - _279;
      int _286 = min(max(((int)(_274 + 1u)), 0), _246);
      int _287 = min(max(((int)(_275 + 1u)), 0), _247);
      int _288 = max(0, _274);
      int _289 = max(0, _275);
      float _290 = _281 * _280;
      float _291 = _281 * _278;
      float _292 = _280 * _279;
      float _293 = _279 * _278;
      float4 _295 = __3__36__0__0__g_tiledRadianceCachePlanePrev.Load(int3(_288, _287, 0));
      float4 _297 = __3__36__0__0__g_tiledRadianceCachePlanePrev.Load(int3(_286, _287, 0));
      float4 _299 = __3__36__0__0__g_tiledRadianceCachePlanePrev.Load(int3(_286, _275, 0));
      float4 _301 = __3__36__0__0__g_tiledRadianceCachePlanePrev.Load(int3(_288, _289, 0));
      float _303 = _nearFarProj.x / _295.w;
      float _304 = _nearFarProj.x / _297.w;
      float _305 = _nearFarProj.x / _299.w;
      float _306 = _nearFarProj.x / _301.w;
      uint _307 = ((uint)(int4(_frameNumber).x)) + -1u;
      int _317 = (((int)((_307 << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531528u))) ^ (((uint)(_307) >> 5) + -939442524);
      uint _318 = _288 + _317;
      uint _319 = _318 + (_287 * ((uint)(uint(_bufferSizeAndInvSize.x)) >> 5));
      uint _327 = ((uint)((((int)((_319 << 4) + -1383041155u)) ^ ((int)(_319 + -1640531527u))) ^ ((int)(((uint)((uint)(_319) >> 5)) + 2123724318u)))) + _307;
      uint _335 = ((uint)((((int)((_327 << 4) + -1556008596u)) ^ ((int)(_327 + 1013904242u))) ^ (((uint)(_327) >> 5) + -939442524))) + _319;
      uint _343 = ((uint)((((int)((_335 << 4) + -1383041155u)) ^ ((int)(_335 + 1013904242u))) ^ ((int)(((uint)((uint)(_335) >> 5)) + 2123724318u)))) + _327;
      uint _351 = ((uint)((((int)((_343 << 4) + -1556008596u)) ^ ((int)(_343 + -626627285u))) ^ (((uint)(_343) >> 5) + -939442524))) + _335;
      uint _359 = ((uint)((((int)((_351 << 4) + -1383041155u)) ^ ((int)(_351 + -626627285u))) ^ ((int)(((uint)((uint)(_351) >> 5)) + 2123724318u)))) + _343;
      uint _367 = ((uint)((((int)((_359 << 4) + -1556008596u)) ^ ((int)(_359 + 2027808484u))) ^ (((uint)(_359) >> 5) + -939442524))) + _351;
      uint _375 = ((uint)((((int)((_367 << 4) + -1383041155u)) ^ ((int)(_367 + 2027808484u))) ^ ((int)(((uint)((uint)(_367) >> 5)) + 2123724318u)))) + _359;
      uint _383 = ((uint)((((int)((_375 << 4) + -1556008596u)) ^ ((int)(_375 + 387276957u))) ^ (((uint)(_375) >> 5) + -939442524))) + _367;
      uint _391 = ((uint)((((int)((_383 << 4) + -1383041155u)) ^ ((int)(_383 + 387276957u))) ^ ((int)(((uint)((uint)(_383) >> 5)) + 2123724318u)))) + _375;
      uint _399 = ((uint)((((int)((_391 << 4) + -1556008596u)) ^ ((int)(_391 + -1253254570u))) ^ (((uint)(_391) >> 5) + -939442524))) + _383;
      uint _407 = ((uint)((((int)((_399 << 4) + -1383041155u)) ^ ((int)(_399 + -1253254570u))) ^ ((int)(((uint)((uint)(_399) >> 5)) + 2123724318u)))) + _391;
      uint _415 = ((uint)((((int)((_407 << 4) + -1556008596u)) ^ ((int)(_407 + 1401181199u))) ^ (((uint)(_407) >> 5) + -939442524))) + _399;
      uint _423 = ((uint)((((int)((_415 << 4) + -1383041155u)) ^ ((int)(_415 + 1401181199u))) ^ ((int)(((uint)((uint)(_415) >> 5)) + 2123724318u)))) + _407;
      uint _431 = ((uint)((((int)((_423 << 4) + -1556008596u)) ^ ((int)(_423 + -239350328u))) ^ (((uint)(_423) >> 5) + -939442524))) + _415;
      uint _439 = ((uint)((((int)((_431 << 4) + -1383041155u)) ^ ((int)(_431 + -239350328u))) ^ ((int)(((uint)((uint)(_431) >> 5)) + 2123724318u)))) + _423;
      if ((_431 & 16777215) == 0) {
        _452 = ((int)(((uint)((((int)((_439 << 4) + -1556008596u)) ^ ((int)(_439 + -1879881855u))) ^ (((uint)(_439) >> 5) + -939442524))) + _431));
      } else {
        _452 = _431;
      }
      int _459 = (int)(uint(floor(float((uint)((uint)(((int)(_452 * 48271)) & 16777215))) * 9.53614687659865e-07f))) & 15;
      int _472 = ((int)(_288 << 5)) | 16;
      int _473 = ((int)(_287 << 5)) | 16;
      float _485 = ((_bufferSizeAndInvSize.z * 2.0f) * (float((uint)((((uint)(_global_0[((int)(0u + (_459 * 2)))])) << 1) + _472)) + 0.5f)) + -1.0f;
      float _488 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (float((uint)((((uint)(_global_0[((int)(1u + (_459 * 2)))])) << 1) + _473)) + 0.5f));
      float _489 = max(1.0000000116860974e-07f, _303);
      float _525 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _489, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _488, (_485 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
      uint _533 = _286 + _317;
      uint _534 = (((uint)(uint(_bufferSizeAndInvSize.x)) >> 5) * _287) + _533;
      uint _542 = ((uint)((((int)((_534 << 4) + -1383041155u)) ^ ((int)(_534 + -1640531527u))) ^ ((int)(((uint)((uint)(_534) >> 5)) + 2123724318u)))) + _307;
      uint _550 = ((uint)((((int)((_542 << 4) + -1556008596u)) ^ ((int)(_542 + 1013904242u))) ^ (((uint)(_542) >> 5) + -939442524))) + _534;
      uint _558 = ((uint)((((int)((_550 << 4) + -1383041155u)) ^ ((int)(_550 + 1013904242u))) ^ ((int)(((uint)((uint)(_550) >> 5)) + 2123724318u)))) + _542;
      uint _566 = ((uint)((((int)((_558 << 4) + -1556008596u)) ^ ((int)(_558 + -626627285u))) ^ (((uint)(_558) >> 5) + -939442524))) + _550;
      uint _574 = ((uint)((((int)((_566 << 4) + -1383041155u)) ^ ((int)(_566 + -626627285u))) ^ ((int)(((uint)((uint)(_566) >> 5)) + 2123724318u)))) + _558;
      uint _582 = ((uint)((((int)((_574 << 4) + -1556008596u)) ^ ((int)(_574 + 2027808484u))) ^ (((uint)(_574) >> 5) + -939442524))) + _566;
      uint _590 = ((uint)((((int)((_582 << 4) + -1383041155u)) ^ ((int)(_582 + 2027808484u))) ^ ((int)(((uint)((uint)(_582) >> 5)) + 2123724318u)))) + _574;
      uint _598 = ((uint)((((int)((_590 << 4) + -1556008596u)) ^ ((int)(_590 + 387276957u))) ^ (((uint)(_590) >> 5) + -939442524))) + _582;
      uint _606 = ((uint)((((int)((_598 << 4) + -1383041155u)) ^ ((int)(_598 + 387276957u))) ^ ((int)(((uint)((uint)(_598) >> 5)) + 2123724318u)))) + _590;
      uint _614 = ((uint)((((int)((_606 << 4) + -1556008596u)) ^ ((int)(_606 + -1253254570u))) ^ (((uint)(_606) >> 5) + -939442524))) + _598;
      uint _622 = ((uint)((((int)((_614 << 4) + -1383041155u)) ^ ((int)(_614 + -1253254570u))) ^ ((int)(((uint)((uint)(_614) >> 5)) + 2123724318u)))) + _606;
      uint _630 = ((uint)((((int)((_622 << 4) + -1556008596u)) ^ ((int)(_622 + 1401181199u))) ^ (((uint)(_622) >> 5) + -939442524))) + _614;
      uint _638 = ((uint)((((int)((_630 << 4) + -1383041155u)) ^ ((int)(_630 + 1401181199u))) ^ ((int)(((uint)((uint)(_630) >> 5)) + 2123724318u)))) + _622;
      uint _646 = ((uint)((((int)((_638 << 4) + -1556008596u)) ^ ((int)(_638 + -239350328u))) ^ (((uint)(_638) >> 5) + -939442524))) + _630;
      uint _654 = ((uint)((((int)((_646 << 4) + -1383041155u)) ^ ((int)(_646 + -239350328u))) ^ ((int)(((uint)((uint)(_646) >> 5)) + 2123724318u)))) + _638;
      if ((_646 & 16777215) == 0) {
        _667 = ((int)(((uint)((((int)((_654 << 4) + -1556008596u)) ^ ((int)(_654 + -1879881855u))) ^ (((uint)(_654) >> 5) + -939442524))) + _646));
      } else {
        _667 = _646;
      }
      int _674 = (int)(uint(floor(float((uint)((uint)(((int)(_667 * 48271)) & 16777215))) * 9.53614687659865e-07f))) & 15;
      int _686 = ((int)(_286 << 5)) | 16;
      float _698 = ((_bufferSizeAndInvSize.z * 2.0f) * (float((uint)((((uint)(_global_0[((int)(0u + (_674 * 2)))])) << 1) + _686)) + 0.5f)) + -1.0f;
      float _701 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (float((uint)((((uint)(_global_0[((int)(1u + (_674 * 2)))])) << 1) + _473)) + 0.5f));
      float _702 = max(1.0000000116860974e-07f, _304);
      float _738 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _702, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _701, (_698 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
      uint _746 = (((uint)(uint(_bufferSizeAndInvSize.x)) >> 5) * _275) + _533;
      uint _754 = ((uint)((((int)((_746 << 4) + -1383041155u)) ^ ((int)(_746 + -1640531527u))) ^ ((int)(((uint)((uint)(_746) >> 5)) + 2123724318u)))) + _307;
      uint _762 = ((uint)((((int)((_754 << 4) + -1556008596u)) ^ ((int)(_754 + 1013904242u))) ^ (((uint)(_754) >> 5) + -939442524))) + _746;
      uint _770 = ((uint)((((int)((_762 << 4) + -1383041155u)) ^ ((int)(_762 + 1013904242u))) ^ ((int)(((uint)((uint)(_762) >> 5)) + 2123724318u)))) + _754;
      uint _778 = ((uint)((((int)((_770 << 4) + -1556008596u)) ^ ((int)(_770 + -626627285u))) ^ (((uint)(_770) >> 5) + -939442524))) + _762;
      uint _786 = ((uint)((((int)((_778 << 4) + -1383041155u)) ^ ((int)(_778 + -626627285u))) ^ ((int)(((uint)((uint)(_778) >> 5)) + 2123724318u)))) + _770;
      uint _794 = ((uint)((((int)((_786 << 4) + -1556008596u)) ^ ((int)(_786 + 2027808484u))) ^ (((uint)(_786) >> 5) + -939442524))) + _778;
      uint _802 = ((uint)((((int)((_794 << 4) + -1383041155u)) ^ ((int)(_794 + 2027808484u))) ^ ((int)(((uint)((uint)(_794) >> 5)) + 2123724318u)))) + _786;
      uint _810 = ((uint)((((int)((_802 << 4) + -1556008596u)) ^ ((int)(_802 + 387276957u))) ^ (((uint)(_802) >> 5) + -939442524))) + _794;
      uint _818 = ((uint)((((int)((_810 << 4) + -1383041155u)) ^ ((int)(_810 + 387276957u))) ^ ((int)(((uint)((uint)(_810) >> 5)) + 2123724318u)))) + _802;
      uint _826 = ((uint)((((int)((_818 << 4) + -1556008596u)) ^ ((int)(_818 + -1253254570u))) ^ (((uint)(_818) >> 5) + -939442524))) + _810;
      uint _834 = ((uint)((((int)((_826 << 4) + -1383041155u)) ^ ((int)(_826 + -1253254570u))) ^ ((int)(((uint)((uint)(_826) >> 5)) + 2123724318u)))) + _818;
      uint _842 = ((uint)((((int)((_834 << 4) + -1556008596u)) ^ ((int)(_834 + 1401181199u))) ^ (((uint)(_834) >> 5) + -939442524))) + _826;
      uint _850 = ((uint)((((int)((_842 << 4) + -1383041155u)) ^ ((int)(_842 + 1401181199u))) ^ ((int)(((uint)((uint)(_842) >> 5)) + 2123724318u)))) + _834;
      uint _858 = ((uint)((((int)((_850 << 4) + -1556008596u)) ^ ((int)(_850 + -239350328u))) ^ (((uint)(_850) >> 5) + -939442524))) + _842;
      uint _866 = ((uint)((((int)((_858 << 4) + -1383041155u)) ^ ((int)(_858 + -239350328u))) ^ ((int)(((uint)((uint)(_858) >> 5)) + 2123724318u)))) + _850;
      if ((_858 & 16777215) == 0) {
        _879 = ((int)(((uint)((((int)((_866 << 4) + -1556008596u)) ^ ((int)(_866 + -1879881855u))) ^ (((uint)(_866) >> 5) + -939442524))) + _858));
      } else {
        _879 = _858;
      }
      int _886 = (int)(uint(floor(float((uint)((uint)(((int)(_879 * 48271)) & 16777215))) * 9.53614687659865e-07f))) & 15;
      float _910 = ((_bufferSizeAndInvSize.z * 2.0f) * (float((uint)((((uint)(_global_0[((int)(0u + (_886 * 2)))])) << 1) + _686)) + 0.5f)) + -1.0f;
      float _913 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (float((uint)((((uint)(_global_0[((int)(1u + (_886 * 2)))])) << 1) + ((uint)(((int)(_275 << 5)) | 16)))) + 0.5f));
      float _914 = max(1.0000000116860974e-07f, _305);
      float _950 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _914, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _913, (_910 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
      uint _958 = (((uint)(uint(_bufferSizeAndInvSize.x)) >> 5) * _289) + _318;
      uint _966 = ((uint)((((int)((_958 << 4) + -1383041155u)) ^ ((int)(_958 + -1640531527u))) ^ ((int)(((uint)((uint)(_958) >> 5)) + 2123724318u)))) + _307;
      uint _974 = ((uint)((((int)((_966 << 4) + -1556008596u)) ^ ((int)(_966 + 1013904242u))) ^ (((uint)(_966) >> 5) + -939442524))) + _958;
      uint _982 = ((uint)((((int)((_974 << 4) + -1383041155u)) ^ ((int)(_974 + 1013904242u))) ^ ((int)(((uint)((uint)(_974) >> 5)) + 2123724318u)))) + _966;
      uint _990 = ((uint)((((int)((_982 << 4) + -1556008596u)) ^ ((int)(_982 + -626627285u))) ^ (((uint)(_982) >> 5) + -939442524))) + _974;
      uint _998 = ((uint)((((int)((_990 << 4) + -1383041155u)) ^ ((int)(_990 + -626627285u))) ^ ((int)(((uint)((uint)(_990) >> 5)) + 2123724318u)))) + _982;
      uint _1006 = ((uint)((((int)((_998 << 4) + -1556008596u)) ^ ((int)(_998 + 2027808484u))) ^ (((uint)(_998) >> 5) + -939442524))) + _990;
      uint _1014 = ((uint)((((int)((_1006 << 4) + -1383041155u)) ^ ((int)(_1006 + 2027808484u))) ^ ((int)(((uint)((uint)(_1006) >> 5)) + 2123724318u)))) + _998;
      uint _1022 = ((uint)((((int)((_1014 << 4) + -1556008596u)) ^ ((int)(_1014 + 387276957u))) ^ (((uint)(_1014) >> 5) + -939442524))) + _1006;
      uint _1030 = ((uint)((((int)((_1022 << 4) + -1383041155u)) ^ ((int)(_1022 + 387276957u))) ^ ((int)(((uint)((uint)(_1022) >> 5)) + 2123724318u)))) + _1014;
      uint _1038 = ((uint)((((int)((_1030 << 4) + -1556008596u)) ^ ((int)(_1030 + -1253254570u))) ^ (((uint)(_1030) >> 5) + -939442524))) + _1022;
      uint _1046 = ((uint)((((int)((_1038 << 4) + -1383041155u)) ^ ((int)(_1038 + -1253254570u))) ^ ((int)(((uint)((uint)(_1038) >> 5)) + 2123724318u)))) + _1030;
      uint _1054 = ((uint)((((int)((_1046 << 4) + -1556008596u)) ^ ((int)(_1046 + 1401181199u))) ^ (((uint)(_1046) >> 5) + -939442524))) + _1038;
      uint _1062 = ((uint)((((int)((_1054 << 4) + -1383041155u)) ^ ((int)(_1054 + 1401181199u))) ^ ((int)(((uint)((uint)(_1054) >> 5)) + 2123724318u)))) + _1046;
      uint _1070 = ((uint)((((int)((_1062 << 4) + -1556008596u)) ^ ((int)(_1062 + -239350328u))) ^ (((uint)(_1062) >> 5) + -939442524))) + _1054;
      uint _1078 = ((uint)((((int)((_1070 << 4) + -1383041155u)) ^ ((int)(_1070 + -239350328u))) ^ ((int)(((uint)((uint)(_1070) >> 5)) + 2123724318u)))) + _1062;
      if ((_1070 & 16777215) == 0) {
        _1091 = ((int)(((uint)((((int)((_1078 << 4) + -1556008596u)) ^ ((int)(_1078 + -1879881855u))) ^ (((uint)(_1078) >> 5) + -939442524))) + _1070));
      } else {
        _1091 = _1070;
      }
      int _1098 = (int)(uint(floor(float((uint)((uint)(((int)(_1091 * 48271)) & 16777215))) * 9.53614687659865e-07f))) & 15;
      float _1122 = ((_bufferSizeAndInvSize.z * 2.0f) * (float((uint)((((uint)(_global_0[((int)(0u + (_1098 * 2)))])) << 1) + _472)) + 0.5f)) + -1.0f;
      float _1125 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (float((uint)((((uint)(_global_0[((int)(1u + (_1098 * 2)))])) << 1) + ((uint)(((int)(_289 << 5)) | 16)))) + 0.5f));
      float _1126 = max(1.0000000116860974e-07f, _306);
      float _1162 = mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w), _1126, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _1125, (_1122 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w);
      float _1166 = _102 * _102;
      float _1169 = (_1166 * 0.009999999776482582f) + 0.25f;
      float _1177 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x) + (_150 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _489, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _488, (_485 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _525));
      float _1178 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y) + (_151 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _489, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _488, (_485 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _525));
      float _1179 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z) + (_152 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _489, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _488, (_485 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _525));
      float _1186 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x) + (_150 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _702, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _701, (_698 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _738));
      float _1187 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y) + (_151 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _702, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _701, (_698 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _738));
      float _1188 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z) + (_152 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _702, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _701, (_698 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _738));
      float _1195 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x) + (_150 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _914, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _913, (_910 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _950));
      float _1196 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y) + (_151 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _914, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _913, (_910 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _950));
      float _1197 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z) + (_152 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _914, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _913, (_910 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _950));
      float _1204 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).x) + (_150 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x), _1126, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _1125, (_1122 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _1162));
      float _1205 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).y) + (_151 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y), _1126, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _1125, (_1122 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y)) / _1162));
      float _1206 = (float4(_diffViewPosAccurate.x, _diffViewPosAccurate.y, _diffViewPosAccurate.z, _isAllowBlood).z) + (_152 - ((mad((float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z), _1126, mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _1125, (_1122 * (float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z)))) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z)) / _1162));
      bool _1214 = ((int)((int)_288 < (int)0)) | ((int)((int)_288 >= (int)_246));
      bool _1215 = ((int)((int)_287 < (int)0)) | ((int)((int)_287 >= (int)_247));
      bool _1220 = ((int)((int)_286 < (int)0)) | ((int)((int)_286 >= (int)_246));
      float _1233 = _102 * 0.05000000074505806f;
      float _1238 = max(0.0f, (select(((_1215) | (_1214)), 0.0f, dot(float3(_1177, _1178, _1179), float3(_1177, _1178, _1179))) - _1233));
      float _1239 = max(0.0f, (select(((_1220) | (_1215)), 0.0f, dot(float3(_1186, _1187, _1188), float3(_1186, _1187, _1188))) - _1233));
      float _1240 = max(0.0f, (select(((((int)(((int)((int)_275 < (int)0)) | ((int)((int)_275 >= (int)_247))))) | (_1220)), 0.0f, dot(float3(_1195, _1196, _1197), float3(_1195, _1196, _1197))) - _1233));
      float _1241 = max(0.0f, (select(((_1214) | (((int)(((int)((int)_289 < (int)0)) | ((int)((int)_289 >= (int)_247)))))), 0.0f, dot(float3(_1204, _1205, _1206), float3(_1204, _1205, _1206))) - _1233));
      float _1250 = min(0.0f, (-0.0f - (abs(dot(float3(_88, _89, _90), float3(_1177, _1178, _1179))) - _1233)));
      float _1251 = min(0.0f, (-0.0f - (abs(dot(float3(_88, _89, _90), float3(_1186, _1187, _1188))) - _1233)));
      float _1252 = min(0.0f, (-0.0f - (abs(dot(float3(_88, _89, _90), float3(_1195, _1196, _1197))) - _1233)));
      float _1253 = min(0.0f, (-0.0f - (abs(dot(float3(_88, _89, _90), float3(_1204, _1205, _1206))) - _1233)));
      float _1254 = _1250 * _1250;
      float _1255 = _1251 * _1251;
      float _1256 = _1252 * _1252;
      float _1257 = _1253 * _1253;
      float _1278 = 1.4426950216293335f / (_1166 + 1.0f);
      float _1307 = min((select((_1238 > _1169), 0.0f, exp2(((max(0.0f, (_1238 - _1254)) * -5.0f) - (_1254 * 50.0f)) * _1278)) * float((bool)(uint)(_303 > 4.0000000467443897e-07f))), _292);
      float _1308 = min((select((_1239 > _1169), 0.0f, exp2(((max(0.0f, (_1239 - _1255)) * -5.0f) - (_1255 * 50.0f)) * _1278)) * float((bool)(uint)(_304 > 4.0000000467443897e-07f))), _293);
      float _1309 = min((select((_1240 > _1169), 0.0f, exp2(((max(0.0f, (_1240 - _1256)) * -5.0f) - (_1256 * 50.0f)) * _1278)) * float((bool)(uint)(_305 > 4.0000000467443897e-07f))), _291);
      float _1310 = min((select((_1241 > _1169), 0.0f, exp2(((max(0.0f, (_1241 - _1257)) * -5.0f) - (_1257 * 50.0f)) * _1278)) * float((bool)(uint)(_306 > 4.0000000467443897e-07f))), _290);
      float _1313 = 1.0f / max(9.999999974752427e-07f, dot(float4(_1307, _1308, _1309, _1310), float4(1.0f, 1.0f, 1.0f, 1.0f)));
      int _1324 = (((int)((((uint)(int4(_frameNumber).x)) << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531527u))) ^ (((uint)((uint)(int4(_frameNumber).x)) >> 5) + -939442524);
      uint _1332 = ((uint)((((int)((_1324 << 4) + -1383041155u)) ^ ((int)(_1324 + -1640531527u))) ^ ((int)(((uint)((uint)(_1324) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
      uint _1340 = ((uint)((((int)((_1332 << 4) + -1556008596u)) ^ ((int)(_1332 + 1013904242u))) ^ (((uint)(_1332) >> 5) + -939442524))) + _1324;
      uint _1348 = ((uint)((((int)((_1340 << 4) + -1383041155u)) ^ ((int)(_1340 + 1013904242u))) ^ ((int)(((uint)((uint)(_1340) >> 5)) + 2123724318u)))) + _1332;
      uint _1356 = ((uint)((((int)((_1348 << 4) + -1556008596u)) ^ ((int)(_1348 + -626627285u))) ^ (((uint)(_1348) >> 5) + -939442524))) + _1340;
      uint _1364 = ((uint)((((int)((_1356 << 4) + -1383041155u)) ^ ((int)(_1356 + -626627285u))) ^ ((int)(((uint)((uint)(_1356) >> 5)) + 2123724318u)))) + _1348;
      uint _1372 = ((uint)((((int)((_1364 << 4) + -1556008596u)) ^ ((int)(_1364 + 2027808484u))) ^ (((uint)(_1364) >> 5) + -939442524))) + _1356;
      uint _1380 = ((uint)((((int)((_1372 << 4) + -1383041155u)) ^ ((int)(_1372 + 2027808484u))) ^ ((int)(((uint)((uint)(_1372) >> 5)) + 2123724318u)))) + _1364;
      uint _1388 = ((uint)((((int)((_1380 << 4) + -1556008596u)) ^ ((int)(_1380 + 387276957u))) ^ (((uint)(_1380) >> 5) + -939442524))) + _1372;
      uint _1396 = ((uint)((((int)((_1388 << 4) + -1383041155u)) ^ ((int)(_1388 + 387276957u))) ^ ((int)(((uint)((uint)(_1388) >> 5)) + 2123724318u)))) + _1380;
      uint _1404 = ((uint)((((int)((_1396 << 4) + -1556008596u)) ^ ((int)(_1396 + -1253254570u))) ^ (((uint)(_1396) >> 5) + -939442524))) + _1388;
      uint _1412 = ((uint)((((int)((_1404 << 4) + -1383041155u)) ^ ((int)(_1404 + -1253254570u))) ^ ((int)(((uint)((uint)(_1404) >> 5)) + 2123724318u)))) + _1396;
      uint _1420 = ((uint)((((int)((_1412 << 4) + -1556008596u)) ^ ((int)(_1412 + 1401181199u))) ^ (((uint)(_1412) >> 5) + -939442524))) + _1404;
      uint _1428 = ((uint)((((int)((_1420 << 4) + -1383041155u)) ^ ((int)(_1420 + 1401181199u))) ^ ((int)(((uint)((uint)(_1420) >> 5)) + 2123724318u)))) + _1412;
      uint _1436 = ((uint)((((int)((_1428 << 4) + -1556008596u)) ^ ((int)(_1428 + -239350328u))) ^ (((uint)(_1428) >> 5) + -939442524))) + _1420;
      uint _1444 = ((uint)((((int)((_1436 << 4) + -1383041155u)) ^ ((int)(_1436 + -239350328u))) ^ ((int)(((uint)((uint)(_1436) >> 5)) + 2123724318u)))) + _1428;
      if ((_1436 & 16777215) == 0) {
        _1457 = ((int)(((uint)((((int)((_1444 << 4) + -1556008596u)) ^ ((int)(_1444 + -1879881855u))) ^ (((uint)(_1444) >> 5) + -939442524))) + _1436));
      } else {
        _1457 = _1436;
      }
      float _1465 = ((float((uint)((uint)(((int)(_1457 * 48271)) & 16777215))) * 5.851672479906256e-09f) + -0.04908738657832146f) * _terrainNormalParams.z;
      float _1466 = sin(_1465);
      float _1467 = cos(_1465);
      int _1470 = ((int)(_288 << 3)) | _16;
      uint _1471 = (_287 << 3) + _17;
      float _1473 = __3__36__0__0__g_tiledRadianceCachePDFPrev.Load(int3(_1470, _1471, 0));
      int _1476 = ((int)(_286 << 3)) | _16;
      float _1477 = __3__36__0__0__g_tiledRadianceCachePDFPrev.Load(int3(_1476, _1471, 0));
      float _1481 = __3__36__0__0__g_tiledRadianceCachePDFPrev.Load(int3(_1476, ((int)((_275 << 3) + _17)), 0));
      float _1485 = __3__36__0__0__g_tiledRadianceCachePDFPrev.Load(int3(_1470, ((int)((_289 << 3) + _17)), 0));
      _global_1[((int)(0u + (((int)(_16 + (_17 * 8))) * 4)))] = _1473.x;
      _global_1[((int)(1u + (((int)(_16 + (_17 * 8))) * 4)))] = _1477.x;
      _global_1[((int)(2u + (((int)(_16 + (_17 * 8))) * 4)))] = _1481.x;
      _global_1[((int)(3u + (((int)(_16 + (_17 * 8))) * 4)))] = _1485.x;
      float _1493 = ((float((uint)_16) + 0.5f) * 0.25f) + -1.0f;
      float _1494 = ((float((uint)_17) + 0.5f) * 0.25f) + -1.0f;
      float _1498 = (1.0f - abs(_1493)) - abs(_1494);
      float _1500 = saturate(-0.0f - _1498);
      float _1501 = -0.0f - _1500;
      float _1506 = select((_1493 >= 0.0f), _1501, _1500) + _1493;
      float _1507 = select((_1494 >= 0.0f), _1501, _1500) + _1494;
      float _1509 = rsqrt(dot(float3(_1506, _1498, _1507), float3(_1506, _1498, _1507)));
      float _1510 = _1506 * _1509;
      float _1511 = _1509 * _1498;
      float _1512 = _1507 * _1509;
      float _1515 = (_1510 * _1467) + (_1512 * _1466);
      float _1518 = (_1512 * _1467) - (_1510 * _1466);
      float _1520 = rsqrt(dot(float3(_1515, _1511, _1518), float3(_1515, _1511, _1518)));
      _global_2[((int)(0u + (((int)(_16 + (_17 * 8))) * 3)))] = (_1515 * _1520);
      _global_2[((int)(1u + (((int)(_16 + (_17 * 8))) * 3)))] = (_1520 * _1511);
      _global_2[((int)(2u + (((int)(_16 + (_17 * 8))) * 3)))] = (_1518 * _1520);
      GroupMemoryBarrierWithGroupSync();
      float _1527 = _1313 * (((_1308 + _1307) + _1309) + _1310);
      bool _1528 = (_1527 > 1.0f);
      float _1529 = select(_1528, _292, (_1313 * _1307));
      float _1530 = select(_1528, _293, (_1313 * _1308));
      float _1531 = select(_1528, _291, (_1313 * _1309));
      float _1532 = select(_1528, _290, (_1313 * _1310));
      if (!(!(_1527 >= 0.03125f))) {
        uint _1538 = _1324 + uint((_57 * _92) + _91);
        uint _1546 = ((uint)((((int)((_1538 << 4) + -1383041155u)) ^ ((int)(_1538 + -1640531527u))) ^ ((int)(((uint)((uint)(_1538) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
        uint _1554 = ((uint)((((int)((_1546 << 4) + -1556008596u)) ^ ((int)(_1546 + 1013904242u))) ^ (((uint)(_1546) >> 5) + -939442524))) + _1538;
        uint _1562 = ((uint)((((int)((_1554 << 4) + -1383041155u)) ^ ((int)(_1554 + 1013904242u))) ^ ((int)(((uint)((uint)(_1554) >> 5)) + 2123724318u)))) + _1546;
        uint _1570 = ((uint)((((int)((_1562 << 4) + -1556008596u)) ^ ((int)(_1562 + -626627285u))) ^ (((uint)(_1562) >> 5) + -939442524))) + _1554;
        uint _1578 = ((uint)((((int)((_1570 << 4) + -1383041155u)) ^ ((int)(_1570 + -626627285u))) ^ ((int)(((uint)((uint)(_1570) >> 5)) + 2123724318u)))) + _1562;
        uint _1586 = ((uint)((((int)((_1578 << 4) + -1556008596u)) ^ ((int)(_1578 + 2027808484u))) ^ (((uint)(_1578) >> 5) + -939442524))) + _1570;
        uint _1594 = ((uint)((((int)((_1586 << 4) + -1383041155u)) ^ ((int)(_1586 + 2027808484u))) ^ ((int)(((uint)((uint)(_1586) >> 5)) + 2123724318u)))) + _1578;
        uint _1602 = ((uint)((((int)((_1594 << 4) + -1556008596u)) ^ ((int)(_1594 + 387276957u))) ^ (((uint)(_1594) >> 5) + -939442524))) + _1586;
        uint _1610 = ((uint)((((int)((_1602 << 4) + -1383041155u)) ^ ((int)(_1602 + 387276957u))) ^ ((int)(((uint)((uint)(_1602) >> 5)) + 2123724318u)))) + _1594;
        uint _1618 = ((uint)((((int)((_1610 << 4) + -1556008596u)) ^ ((int)(_1610 + -1253254570u))) ^ (((uint)(_1610) >> 5) + -939442524))) + _1602;
        uint _1626 = ((uint)((((int)((_1618 << 4) + -1383041155u)) ^ ((int)(_1618 + -1253254570u))) ^ ((int)(((uint)((uint)(_1618) >> 5)) + 2123724318u)))) + _1610;
        uint _1634 = ((uint)((((int)((_1626 << 4) + -1556008596u)) ^ ((int)(_1626 + 1401181199u))) ^ (((uint)(_1626) >> 5) + -939442524))) + _1618;
        uint _1642 = ((uint)((((int)((_1634 << 4) + -1383041155u)) ^ ((int)(_1634 + 1401181199u))) ^ ((int)(((uint)((uint)(_1634) >> 5)) + 2123724318u)))) + _1626;
        uint _1650 = ((uint)((((int)((_1642 << 4) + -1556008596u)) ^ ((int)(_1642 + -239350328u))) ^ (((uint)(_1642) >> 5) + -939442524))) + _1634;
        uint _1658 = ((uint)((((int)((_1650 << 4) + -1383041155u)) ^ ((int)(_1650 + -239350328u))) ^ ((int)(((uint)((uint)(_1650) >> 5)) + 2123724318u)))) + _1642;
        if ((_1650 & 16777215) == 0) {
          _1671 = ((int)(((uint)((((int)((_1658 << 4) + -1556008596u)) ^ ((int)(_1658 + -1879881855u))) ^ (((uint)(_1658) >> 5) + -939442524))) + _1650));
        } else {
          _1671 = _1650;
        }
        _1679 = 0.0f;
        _1680 = 0;
        while(true) {
          _1685 = _1679;
          _1686 = 0;
          while(true) {
            float _1733 = (saturate(dot(float3(_88, _89, _90), float3((_global_2[((int)(0u + (((int)(_1686 + (_1680 * 8))) * 3)))]), (_global_2[((int)(1u + (((int)(_1686 + (_1680 * 8))) * 3)))]), (_global_2[((int)(2u + (((int)(_1686 + (_1680 * 8))) * 3)))])))) * dot(float4((_global_1[((int)(0u + (((int)(_1686 + (_1680 * 8))) * 4)))]), (_global_1[((int)(1u + (((int)(_1686 + (_1680 * 8))) * 4)))]), (_global_1[((int)(2u + (((int)(_1686 + (_1680 * 8))) * 4)))]), (_global_1[((int)(3u + (((int)(_1686 + (_1680 * 8))) * 4)))])), float4(_1529, _1530, _1531, _1532))) + _1685;
            int _1734 = _1686 + 1;
            if (!(_1734 == 8)) {
              _1685 = _1733;
              _1686 = _1734;
              continue;
            }
            int _1682 = _1680 + 1;
            if (!(_1682 == 8)) {
              _1679 = _1733;
              _1680 = _1682;
              __loop_jump_target = 1678;
              break;
            }
            _1737 = 1.0f;
            _1738 = 0;
            _1739 = 0.0f;
            _1740 = 0;
            _1741 = 0;
            while(true) {
              _1744 = 0;
              _1745 = _1739;
              while(true) {
                float _1791 = saturate(dot(float3(_88, _89, _90), float3((_global_2[((int)(0u + (((int)(_1744 + (_1738 * 8))) * 3)))]), (_global_2[((int)(1u + (((int)(_1744 + (_1738 * 8))) * 3)))]), (_global_2[((int)(2u + (((int)(_1744 + (_1738 * 8))) * 3)))])))) * dot(float4((_global_1[((int)(0u + (((int)(_1744 + (_1738 * 8))) * 4)))]), (_global_1[((int)(1u + (((int)(_1744 + (_1738 * 8))) * 4)))]), (_global_1[((int)(2u + (((int)(_1744 + (_1738 * 8))) * 4)))]), (_global_1[((int)(3u + (((int)(_1744 + (_1738 * 8))) * 4)))])), float4(_1529, _1530, _1531, _1532));
                float _1792 = _1791 + _1745;
                if (!(((float((uint)((uint)(((int)(_1671 * 48271)) & 16777215))) * 5.960464477539063e-08f) * _1733) < _1792)) {
                  int _1795 = _1744 + 1;
                  if ((uint)_1795 < (uint)8) {
                    _1744 = _1795;
                    _1745 = _1792;
                    continue;
                  } else {
                    _1802 = true;
                    _1803 = _1741;
                    _1804 = _1740;
                    _1805 = _1737;
                  }
                } else {
                  _1802 = false;
                  _1803 = _1744;
                  _1804 = _1738;
                  _1805 = ((_1791 * 32.0f) / _1733);
                }
                int _1806 = _1738 + 1;
                if (((int)((uint)_1806 < (uint)8)) & (_1802)) {
                  _1737 = _1805;
                  _1738 = _1806;
                  _1739 = _1792;
                  _1740 = _1804;
                  _1741 = _1803;
                  __loop_jump_target = 1736;
                  break;
                }
                if (!_1802) {
                  uint _1814 = uint(float((uint)((uint)(((int)(_1671 * -1964877855)) & 16777215))) * 3.8141013192216633e-06f);
                  uint _1835 = ((uint)(int4(_frameNumber).x)) + -1u;
                  float _1838 = ((frac((float((uint)_1814) * 0.015625f) + (float((uint)((uint)(_186 & 65535))) * 1.52587890625e-05f)) + float((uint)_1803)) * 0.25f) + -1.0f;
                  float _1839 = (((((float((uint)_1804) + 0.5f) * 0.125f) + -0.0625f) + (float((uint)((uint)(reversebits(_1814) ^ _187))) * 2.9103830456733704e-11f)) * 2.0f) + -1.0f;
                  float _1843 = (1.0f - abs(_1838)) - abs(_1839);
                  float _1845 = saturate(-0.0f - _1843);
                  float _1846 = -0.0f - _1845;
                  float _1851 = select((_1838 >= 0.0f), _1846, _1845) + _1838;
                  float _1852 = select((_1839 >= 0.0f), _1846, _1845) + _1839;
                  int _1859 = (((int)((_1835 << 4) + -1556008596u)) ^ ((int)(((uint)(int4(_frameNumber).x)) + -1640531528u))) ^ (((uint)(_1835) >> 5) + -939442524);
                  uint _1867 = ((uint)((((int)((_1859 << 4) + -1383041155u)) ^ ((int)(_1859 + -1640531527u))) ^ ((int)(((uint)((uint)(_1859) >> 5)) + 2123724318u)))) + _1835;
                  uint _1875 = ((uint)((((int)((_1867 << 4) + -1556008596u)) ^ ((int)(_1867 + 1013904242u))) ^ (((uint)(_1867) >> 5) + -939442524))) + _1859;
                  uint _1883 = ((uint)((((int)((_1875 << 4) + -1383041155u)) ^ ((int)(_1875 + 1013904242u))) ^ ((int)(((uint)((uint)(_1875) >> 5)) + 2123724318u)))) + _1867;
                  uint _1891 = ((uint)((((int)((_1883 << 4) + -1556008596u)) ^ ((int)(_1883 + -626627285u))) ^ (((uint)(_1883) >> 5) + -939442524))) + _1875;
                  uint _1899 = ((uint)((((int)((_1891 << 4) + -1383041155u)) ^ ((int)(_1891 + -626627285u))) ^ ((int)(((uint)((uint)(_1891) >> 5)) + 2123724318u)))) + _1883;
                  uint _1907 = ((uint)((((int)((_1899 << 4) + -1556008596u)) ^ ((int)(_1899 + 2027808484u))) ^ (((uint)(_1899) >> 5) + -939442524))) + _1891;
                  uint _1915 = ((uint)((((int)((_1907 << 4) + -1383041155u)) ^ ((int)(_1907 + 2027808484u))) ^ ((int)(((uint)((uint)(_1907) >> 5)) + 2123724318u)))) + _1899;
                  uint _1923 = ((uint)((((int)((_1915 << 4) + -1556008596u)) ^ ((int)(_1915 + 387276957u))) ^ (((uint)(_1915) >> 5) + -939442524))) + _1907;
                  uint _1931 = ((uint)((((int)((_1923 << 4) + -1383041155u)) ^ ((int)(_1923 + 387276957u))) ^ ((int)(((uint)((uint)(_1923) >> 5)) + 2123724318u)))) + _1915;
                  uint _1939 = ((uint)((((int)((_1931 << 4) + -1556008596u)) ^ ((int)(_1931 + -1253254570u))) ^ (((uint)(_1931) >> 5) + -939442524))) + _1923;
                  uint _1947 = ((uint)((((int)((_1939 << 4) + -1383041155u)) ^ ((int)(_1939 + -1253254570u))) ^ ((int)(((uint)((uint)(_1939) >> 5)) + 2123724318u)))) + _1931;
                  uint _1955 = ((uint)((((int)((_1947 << 4) + -1556008596u)) ^ ((int)(_1947 + 1401181199u))) ^ (((uint)(_1947) >> 5) + -939442524))) + _1939;
                  uint _1963 = ((uint)((((int)((_1955 << 4) + -1383041155u)) ^ ((int)(_1955 + 1401181199u))) ^ ((int)(((uint)((uint)(_1955) >> 5)) + 2123724318u)))) + _1947;
                  uint _1971 = ((uint)((((int)((_1963 << 4) + -1556008596u)) ^ ((int)(_1963 + -239350328u))) ^ (((uint)(_1963) >> 5) + -939442524))) + _1955;
                  uint _1979 = ((uint)((((int)((_1971 << 4) + -1383041155u)) ^ ((int)(_1971 + -239350328u))) ^ ((int)(((uint)((uint)(_1971) >> 5)) + 2123724318u)))) + _1963;
                  if ((_1971 & 16777215) == 0) {
                    _1992 = ((int)(((uint)((((int)((_1979 << 4) + -1556008596u)) ^ ((int)(_1979 + -1879881855u))) ^ (((uint)(_1979) >> 5) + -939442524))) + _1971));
                  } else {
                    _1992 = _1971;
                  }
                  float _2000 = ((float((uint)((uint)(((int)(_1992 * 48271)) & 16777215))) * 5.851672479906256e-09f) + -0.04908738657832146f) * _terrainNormalParams.z;
                  float _2001 = sin(_2000);
                  float _2002 = cos(_2000);
                  float _2004 = rsqrt(dot(float3(_1851, _1843, _1852), float3(_1851, _1843, _1852)));
                  float _2005 = _2004 * _1851;
                  float _2006 = _2004 * _1843;
                  float _2007 = _2004 * _1852;
                  float _2010 = (_2005 * _2002) + (_2007 * _2001);
                  float _2013 = (_2007 * _2002) - (_2005 * _2001);
                  float _2015 = rsqrt(dot(float3(_2010, _2006, _2013), float3(_2010, _2006, _2013)));
                  if (_163) {
                    _2020 = _1324;
                    uint _2024 = _2020 + uint((_57 * _92) + _91);
                    uint _2032 = ((uint)((((int)((_2024 << 4) + -1383041155u)) ^ ((int)(_2024 + -1640531527u))) ^ ((int)(((uint)((uint)(_2024) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
                    uint _2040 = ((uint)((((int)((_2032 << 4) + -1556008596u)) ^ ((int)(_2032 + 1013904242u))) ^ (((uint)(_2032) >> 5) + -939442524))) + _2024;
                    uint _2048 = ((uint)((((int)((_2040 << 4) + -1383041155u)) ^ ((int)(_2040 + 1013904242u))) ^ ((int)(((uint)((uint)(_2040) >> 5)) + 2123724318u)))) + _2032;
                    uint _2056 = ((uint)((((int)((_2048 << 4) + -1556008596u)) ^ ((int)(_2048 + -626627285u))) ^ (((uint)(_2048) >> 5) + -939442524))) + _2040;
                    uint _2064 = ((uint)((((int)((_2056 << 4) + -1383041155u)) ^ ((int)(_2056 + -626627285u))) ^ ((int)(((uint)((uint)(_2056) >> 5)) + 2123724318u)))) + _2048;
                    uint _2072 = ((uint)((((int)((_2064 << 4) + -1556008596u)) ^ ((int)(_2064 + 2027808484u))) ^ (((uint)(_2064) >> 5) + -939442524))) + _2056;
                    uint _2080 = ((uint)((((int)((_2072 << 4) + -1383041155u)) ^ ((int)(_2072 + 2027808484u))) ^ ((int)(((uint)((uint)(_2072) >> 5)) + 2123724318u)))) + _2064;
                    uint _2088 = ((uint)((((int)((_2080 << 4) + -1556008596u)) ^ ((int)(_2080 + 387276957u))) ^ (((uint)(_2080) >> 5) + -939442524))) + _2072;
                    uint _2096 = ((uint)((((int)((_2088 << 4) + -1383041155u)) ^ ((int)(_2088 + 387276957u))) ^ ((int)(((uint)((uint)(_2088) >> 5)) + 2123724318u)))) + _2080;
                    uint _2104 = ((uint)((((int)((_2096 << 4) + -1556008596u)) ^ ((int)(_2096 + -1253254570u))) ^ (((uint)(_2096) >> 5) + -939442524))) + _2088;
                    uint _2112 = ((uint)((((int)((_2104 << 4) + -1383041155u)) ^ ((int)(_2104 + -1253254570u))) ^ ((int)(((uint)((uint)(_2104) >> 5)) + 2123724318u)))) + _2096;
                    uint _2120 = ((uint)((((int)((_2112 << 4) + -1556008596u)) ^ ((int)(_2112 + 1401181199u))) ^ (((uint)(_2112) >> 5) + -939442524))) + _2104;
                    uint _2128 = ((uint)((((int)((_2120 << 4) + -1383041155u)) ^ ((int)(_2120 + 1401181199u))) ^ ((int)(((uint)((uint)(_2120) >> 5)) + 2123724318u)))) + _2112;
                    uint _2136 = ((uint)((((int)((_2128 << 4) + -1556008596u)) ^ ((int)(_2128 + -239350328u))) ^ (((uint)(_2128) >> 5) + -939442524))) + _2120;
                    uint _2144 = ((uint)((((int)((_2136 << 4) + -1383041155u)) ^ ((int)(_2136 + -239350328u))) ^ ((int)(((uint)((uint)(_2136) >> 5)) + 2123724318u)))) + _2128;
                    if ((_2136 & 16777215) == 0) {
                      _2157 = ((int)(((uint)((((int)((_2144 << 4) + -1556008596u)) ^ ((int)(_2144 + -1879881855u))) ^ (((uint)(_2144) >> 5) + -939442524))) + _2136));
                    } else {
                      _2157 = _2136;
                    }
                    // RenoDX: R2 noise (doesnt seem to do much)
                    float _2169;
                    float _2172;
                    if (RT_QUALITY > 0.5f) {
                      float2 _isfast = _rndx_sample_noise(SV_DispatchThreadID.xy, _frameNumber.x);
                      _2169 = _isfast.x;
                      _2172 = _isfast.y * 4294967296.0;
                    } else {
                      uint _2162 = uint(float((uint)((uint)(((int)(_2157 * 48271)) & 16777215))) * 3.8146913539094385e-06f);
                      _2169 = frac((float((uint)_2162) * 0.015625f) + (float((uint)((uint)(_186 & 65535))) * 1.52587890625e-05f));
                      _2172 = float((uint)((uint)(reversebits(_2162) ^ _187)));
                    }
                    if (_renderParams.w == 0.0f) {
                      float _2179 = _2169 * 6.2831854820251465f;
                      float _2181 = 1.0f - (_2172 * 4.656612873077393e-10f);
                      float _2184 = sqrt(1.0f - (_2181 * _2181));
                      _2201 = 0.5f;
                      _2202 = (cos(_2179) * _2184);
                      _2203 = (sin(_2179) * _2184);
                      _2204 = _2181;
                    } else {
                      float _2190 = _2169 * 6.2831854820251465f;
                      float _2191 = sqrt(_2172 * 2.3283064365386963e-10f);
                      float _2194 = sqrt(1.0f - (_2191 * _2191));
                      _2201 = (_2191 * 2.0f);
                      _2202 = (cos(_2190) * _2194);
                      _2203 = (sin(_2190) * _2194);
                      _2204 = _2191;
                    }
                    float _2206 = select((_90 >= 0.0f), 1.0f, -1.0f);
                    float _2209 = -0.0f - (1.0f / (_2206 + _90));
                    float _2210 = _89 * _2209;
                    float _2211 = _2210 * _88;
                    float _2212 = _2206 * _88;
                    _2231 = mad(_2204, _88, mad(_2203, _2211, ((((_2212 * _88) * _2209) + 1.0f) * _2202)));
                    _2232 = mad(_2204, _89, mad(_2203, (_2206 + (_2210 * _89)), ((_2202 * _2206) * _2211)));
                    _2233 = mad(_2204, _90, mad(_2203, (-0.0f - _89), (-0.0f - (_2212 * _2202))));
                    _2234 = _2201;
                  } else {
                    _2231 = (_2010 * _2015);
                    _2232 = (_2015 * _2006);
                    _2233 = (_2013 * _2015);
                    _2234 = _1805;
                  }
                } else {
                  _2020 = _1324;
                  uint _2024 = _2020 + uint((_57 * _92) + _91);
                  uint _2032 = ((uint)((((int)((_2024 << 4) + -1383041155u)) ^ ((int)(_2024 + -1640531527u))) ^ ((int)(((uint)((uint)(_2024) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
                  uint _2040 = ((uint)((((int)((_2032 << 4) + -1556008596u)) ^ ((int)(_2032 + 1013904242u))) ^ (((uint)(_2032) >> 5) + -939442524))) + _2024;
                  uint _2048 = ((uint)((((int)((_2040 << 4) + -1383041155u)) ^ ((int)(_2040 + 1013904242u))) ^ ((int)(((uint)((uint)(_2040) >> 5)) + 2123724318u)))) + _2032;
                  uint _2056 = ((uint)((((int)((_2048 << 4) + -1556008596u)) ^ ((int)(_2048 + -626627285u))) ^ (((uint)(_2048) >> 5) + -939442524))) + _2040;
                  uint _2064 = ((uint)((((int)((_2056 << 4) + -1383041155u)) ^ ((int)(_2056 + -626627285u))) ^ ((int)(((uint)((uint)(_2056) >> 5)) + 2123724318u)))) + _2048;
                  uint _2072 = ((uint)((((int)((_2064 << 4) + -1556008596u)) ^ ((int)(_2064 + 2027808484u))) ^ (((uint)(_2064) >> 5) + -939442524))) + _2056;
                  uint _2080 = ((uint)((((int)((_2072 << 4) + -1383041155u)) ^ ((int)(_2072 + 2027808484u))) ^ ((int)(((uint)((uint)(_2072) >> 5)) + 2123724318u)))) + _2064;
                  uint _2088 = ((uint)((((int)((_2080 << 4) + -1556008596u)) ^ ((int)(_2080 + 387276957u))) ^ (((uint)(_2080) >> 5) + -939442524))) + _2072;
                  uint _2096 = ((uint)((((int)((_2088 << 4) + -1383041155u)) ^ ((int)(_2088 + 387276957u))) ^ ((int)(((uint)((uint)(_2088) >> 5)) + 2123724318u)))) + _2080;
                  uint _2104 = ((uint)((((int)((_2096 << 4) + -1556008596u)) ^ ((int)(_2096 + -1253254570u))) ^ (((uint)(_2096) >> 5) + -939442524))) + _2088;
                  uint _2112 = ((uint)((((int)((_2104 << 4) + -1383041155u)) ^ ((int)(_2104 + -1253254570u))) ^ ((int)(((uint)((uint)(_2104) >> 5)) + 2123724318u)))) + _2096;
                  uint _2120 = ((uint)((((int)((_2112 << 4) + -1556008596u)) ^ ((int)(_2112 + 1401181199u))) ^ (((uint)(_2112) >> 5) + -939442524))) + _2104;
                  uint _2128 = ((uint)((((int)((_2120 << 4) + -1383041155u)) ^ ((int)(_2120 + 1401181199u))) ^ ((int)(((uint)((uint)(_2120) >> 5)) + 2123724318u)))) + _2112;
                  uint _2136 = ((uint)((((int)((_2128 << 4) + -1556008596u)) ^ ((int)(_2128 + -239350328u))) ^ (((uint)(_2128) >> 5) + -939442524))) + _2120;
                  uint _2144 = ((uint)((((int)((_2136 << 4) + -1383041155u)) ^ ((int)(_2136 + -239350328u))) ^ ((int)(((uint)((uint)(_2136) >> 5)) + 2123724318u)))) + _2128;
                  if ((_2136 & 16777215) == 0) {
                    _2157 = ((int)(((uint)((((int)((_2144 << 4) + -1556008596u)) ^ ((int)(_2144 + -1879881855u))) ^ (((uint)(_2144) >> 5) + -939442524))) + _2136));
                  } else {
                    _2157 = _2136;
                  }
                  // RenoDX: R2 noise (doesnt seem to do much)
                  float _2169;
                  float _2172;
                  if (RT_QUALITY > 0.5f) {
                    float2 _isfast = _rndx_sample_noise(SV_DispatchThreadID.xy, _frameNumber.x);
                    _2169 = _isfast.x;
                    _2172 = _isfast.y * 4294967296.0;
                  } else {
                    uint _2162 = uint(float((uint)((uint)(((int)(_2157 * 48271)) & 16777215))) * 3.8146913539094385e-06f);
                    _2169 = frac((float((uint)_2162) * 0.015625f) + (float((uint)((uint)(_186 & 65535))) * 1.52587890625e-05f));
                    _2172 = float((uint)((uint)(reversebits(_2162) ^ _187)));
                  }
                  bool __defer_2156_2189 = false;
                  if (!(_163) || ((_163) && (!(_renderParams.w == 0.0f)))) {
                    __defer_2156_2189 = true;
                  } else {
                    float _2179 = _2169 * 6.2831854820251465f;
                    float _2181 = 1.0f - (_2172 * 4.656612873077393e-10f);
                    float _2184 = sqrt(1.0f - (_2181 * _2181));
                    _2201 = 0.5f;
                    _2202 = (cos(_2179) * _2184);
                    _2203 = (sin(_2179) * _2184);
                    _2204 = _2181;
                  }
                  if (__defer_2156_2189) {
                    float _2190 = _2169 * 6.2831854820251465f;
                    float _2191 = sqrt(_2172 * 2.3283064365386963e-10f);
                    float _2194 = sqrt(1.0f - (_2191 * _2191));
                    _2201 = (_2191 * 2.0f);
                    _2202 = (cos(_2190) * _2194);
                    _2203 = (sin(_2190) * _2194);
                    _2204 = _2191;
                  }
                  float _2206 = select((_90 >= 0.0f), 1.0f, -1.0f);
                  float _2209 = -0.0f - (1.0f / (_2206 + _90));
                  float _2210 = _89 * _2209;
                  float _2211 = _2210 * _88;
                  float _2212 = _2206 * _88;
                  _2231 = mad(_2204, _88, mad(_2203, _2211, ((((_2212 * _88) * _2209) + 1.0f) * _2202)));
                  _2232 = mad(_2204, _89, mad(_2203, (_2206 + (_2210 * _89)), ((_2202 * _2206) * _2211)));
                  _2233 = mad(_2204, _90, mad(_2203, (-0.0f - _89), (-0.0f - (_2212 * _2202))));
                  _2234 = _2201;
                }
                break;
              }
              if (__loop_jump_target == 1736) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
              break;
            }
            if (__loop_jump_target == 1684) {
              __loop_jump_target = -1;
              continue;
            }
            if (__loop_jump_target != -1) {
              break;
            }
            break;
          }
          if (__loop_jump_target == 1678) {
            __loop_jump_target = -1;
            continue;
          }
          if (__loop_jump_target != -1) {
            break;
          }
          break;
        }
      } else {
        _2020 = _1324;
        uint _2024 = _2020 + uint((_57 * _92) + _91);
        uint _2032 = ((uint)((((int)((_2024 << 4) + -1383041155u)) ^ ((int)(_2024 + -1640531527u))) ^ ((int)(((uint)((uint)(_2024) >> 5)) + 2123724318u)))) + ((uint)(int4(_frameNumber).x));
        uint _2040 = ((uint)((((int)((_2032 << 4) + -1556008596u)) ^ ((int)(_2032 + 1013904242u))) ^ (((uint)(_2032) >> 5) + -939442524))) + _2024;
        uint _2048 = ((uint)((((int)((_2040 << 4) + -1383041155u)) ^ ((int)(_2040 + 1013904242u))) ^ ((int)(((uint)((uint)(_2040) >> 5)) + 2123724318u)))) + _2032;
        uint _2056 = ((uint)((((int)((_2048 << 4) + -1556008596u)) ^ ((int)(_2048 + -626627285u))) ^ (((uint)(_2048) >> 5) + -939442524))) + _2040;
        uint _2064 = ((uint)((((int)((_2056 << 4) + -1383041155u)) ^ ((int)(_2056 + -626627285u))) ^ ((int)(((uint)((uint)(_2056) >> 5)) + 2123724318u)))) + _2048;
        uint _2072 = ((uint)((((int)((_2064 << 4) + -1556008596u)) ^ ((int)(_2064 + 2027808484u))) ^ (((uint)(_2064) >> 5) + -939442524))) + _2056;
        uint _2080 = ((uint)((((int)((_2072 << 4) + -1383041155u)) ^ ((int)(_2072 + 2027808484u))) ^ ((int)(((uint)((uint)(_2072) >> 5)) + 2123724318u)))) + _2064;
        uint _2088 = ((uint)((((int)((_2080 << 4) + -1556008596u)) ^ ((int)(_2080 + 387276957u))) ^ (((uint)(_2080) >> 5) + -939442524))) + _2072;
        uint _2096 = ((uint)((((int)((_2088 << 4) + -1383041155u)) ^ ((int)(_2088 + 387276957u))) ^ ((int)(((uint)((uint)(_2088) >> 5)) + 2123724318u)))) + _2080;
        uint _2104 = ((uint)((((int)((_2096 << 4) + -1556008596u)) ^ ((int)(_2096 + -1253254570u))) ^ (((uint)(_2096) >> 5) + -939442524))) + _2088;
        uint _2112 = ((uint)((((int)((_2104 << 4) + -1383041155u)) ^ ((int)(_2104 + -1253254570u))) ^ ((int)(((uint)((uint)(_2104) >> 5)) + 2123724318u)))) + _2096;
        uint _2120 = ((uint)((((int)((_2112 << 4) + -1556008596u)) ^ ((int)(_2112 + 1401181199u))) ^ (((uint)(_2112) >> 5) + -939442524))) + _2104;
        uint _2128 = ((uint)((((int)((_2120 << 4) + -1383041155u)) ^ ((int)(_2120 + 1401181199u))) ^ ((int)(((uint)((uint)(_2120) >> 5)) + 2123724318u)))) + _2112;
        uint _2136 = ((uint)((((int)((_2128 << 4) + -1556008596u)) ^ ((int)(_2128 + -239350328u))) ^ (((uint)(_2128) >> 5) + -939442524))) + _2120;
        uint _2144 = ((uint)((((int)((_2136 << 4) + -1383041155u)) ^ ((int)(_2136 + -239350328u))) ^ ((int)(((uint)((uint)(_2136) >> 5)) + 2123724318u)))) + _2128;
        if ((_2136 & 16777215) == 0) {
          _2157 = ((int)(((uint)((((int)((_2144 << 4) + -1556008596u)) ^ ((int)(_2144 + -1879881855u))) ^ (((uint)(_2144) >> 5) + -939442524))) + _2136));
        } else {
          _2157 = _2136;
        }
        // RenoDX: R2 noise (doesnt seem to do much)
        float _2169;
        float _2172;
        if (RT_QUALITY > 0.5f) {
          float2 _isfast = _rndx_sample_noise(SV_DispatchThreadID.xy, _frameNumber.x);
          _2169 = _isfast.x;
          _2172 = _isfast.y * 4294967296.0;
        } else {
          uint _2162 = uint(float((uint)((uint)(((int)(_2157 * 48271)) & 16777215))) * 3.8146913539094385e-06f);
          _2169 = frac((float((uint)_2162) * 0.015625f) + (float((uint)((uint)(_186 & 65535))) * 1.52587890625e-05f));
          _2172 = float((uint)((uint)(reversebits(_2162) ^ _187)));
        }
        bool __defer_2156_2189 = false;
        if (!(_163) || ((_163) && (!(_renderParams.w == 0.0f)))) {
          __defer_2156_2189 = true;
        } else {
          float _2179 = _2169 * 6.2831854820251465f;
          float _2181 = 1.0f - (_2172 * 4.656612873077393e-10f);
          float _2184 = sqrt(1.0f - (_2181 * _2181));
          _2201 = 0.5f;
          _2202 = (cos(_2179) * _2184);
          _2203 = (sin(_2179) * _2184);
          _2204 = _2181;
        }
        if (__defer_2156_2189) {
          float _2190 = _2169 * 6.2831854820251465f;
          float _2191 = sqrt(_2172 * 2.3283064365386963e-10f);
          float _2194 = sqrt(1.0f - (_2191 * _2191));
          _2201 = (_2191 * 2.0f);
          _2202 = (cos(_2190) * _2194);
          _2203 = (sin(_2190) * _2194);
          _2204 = _2191;
        }
        float _2206 = select((_90 >= 0.0f), 1.0f, -1.0f);
        float _2209 = -0.0f - (1.0f / (_2206 + _90));
        float _2210 = _89 * _2209;
        float _2211 = _2210 * _88;
        float _2212 = _2206 * _88;
        _2231 = mad(_2204, _88, mad(_2203, _2211, ((((_2212 * _88) * _2209) + 1.0f) * _2202)));
        _2232 = mad(_2204, _89, mad(_2203, (_2206 + (_2210 * _89)), ((_2202 * _2206) * _2211)));
        _2233 = mad(_2204, _90, mad(_2203, (-0.0f - _89), (-0.0f - (_2212 * _2202))));
        _2234 = _2201;
      }
    }
    __3__38__0__1__g_raytracingHitResultUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_2231, _2232, _2233, 0.0f);
    __3__38__0__1__g_raytracingDiffuseRayInversePDFUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = (1.0f / max(0.009999999776482582f, _2234));
  }
}
