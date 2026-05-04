#include "../shared.h"
#include "../local-direct-lighting/local_light_common.hlsl"
#include "../lighting/diffuse_brdf.hlsli"

struct ManyLightsData {
  float4 _position;
  float4 _color;
  uint2 _up;
  uint2 _look;
};


Texture2D<float4> __3__36__0__0__g_puddleMask : register(t87, space36);

Texture2D<float> __3__36__0__0__g_lightProfile : register(t21, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t0, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t152, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t40, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t98, space36);

StructuredBuffer<ManyLightsData> __3__37__0__0__g_manyLightsDataBuffer : register(t12, space37);

Texture2D<uint2> __3__36__0__0__g_manyLightsHitData : register(t115, space36);

Texture2D<uint> __3__36__0__0__g_tiledManyLightsMasks : register(t53, space36);

RWTexture2D<float4> __3__38__0__1__g_sceneDiffuseUAV : register(u5, space38);

RWTexture2D<float4> __3__38__0__1__g_specularResultUAV : register(u8, space38);

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

cbuffer __3__35__0__0__TileConstantBuffer : register(b33, space35) {
  uint4 g_tileIndex[4096] : packoffset(c000.x);
};

cbuffer __3__1__0__0__RenderVoxelConstants : register(b0, space1) {
  float4 _lightingParams : packoffset(c000.x);
  float4 _tiledRadianceCacheParams : packoffset(c001.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _17[4];
  int _24 = (int)(SV_GroupID.x) & 3;
  int _25 = (uint)((uint)(_24)) >> 1;
  _17[0] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 4]).x);
  _17[1] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 4]).y);
  _17[2] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 4]).z);
  _17[3] = ((g_tileIndex[(uint)(SV_GroupID.x) >> 4]).w);
  int _43 = _17[(((uint)(SV_GroupID.x) >> 2) & 3)];
  uint _55 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(((uint)((((uint)(((int)((uint)(_43) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_24 - (_25 << 1)) << 4))) >> 5), ((uint)((((uint)(_25 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_43)) >> 16) << 5))) >> 5), 0));
  half _322;
  half _326;
  bool _327;
  bool _332;
  half _333;
  bool _336;
  half _337;
  bool _338;
  float _349;
  half _360;
  float _410;
  float _411;
  float _412;
  float _532;
  float _533;
  float _534;
  float _648;
  float _649;
  float _650;
  float _651;
  float _705;
  float _706;
  float _707;
  float _731;
  float _764;
  float _765;
  float _766;
  [branch]
  if (!((_55.x & 1) == 0)) {
    if (_lightingParams.z > 0.0f) {
      uint _66 = __3__36__0__0__g_depthStencil.Load(int3(((int)((((uint)(((int)((uint)(_43) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_24 - (_25 << 1)) << 4)))), ((int)((((uint)(_25 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_43)) >> 16) << 5)))), 0));
      float _70 = float((uint)((uint)(_66.x & 16777215))) * 5.960465188081798e-08f;
      if (!(((_70 < 1.0000000116860974e-07f)) || ((_70 == 1.0f)))) {
        int _75 = (uint)((uint)(_66.x)) >> 24;
        int _76 = _75 & 127;
        float _79 = max(1.0000000116860974e-07f, _70);
        float _88 = _bufferSizeAndInvSize.z * (float((uint)((((uint)(((int)((uint)(_43) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_24 - (_25 << 1)) << 4)))) + 0.5f);
        float _89 = _bufferSizeAndInvSize.w * (float((uint)((((uint)(_25 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_43)) >> 16) << 5)))) + 0.5f);
        float _91 = (_88 * 2.0f) + -1.0f;
        float _93 = 1.0f - (_89 * 2.0f);
        float _129 = mad((_invViewProjRelative[3].z), _79, mad((_invViewProjRelative[3].y), _93, (_91 * (_invViewProjRelative[3].x)))) + (_invViewProjRelative[3].w);
        float _130 = (mad((_invViewProjRelative[0].z), _79, mad((_invViewProjRelative[0].y), _93, (_91 * (_invViewProjRelative[0].x)))) + (_invViewProjRelative[0].w)) / _129;
        float _131 = (mad((_invViewProjRelative[1].z), _79, mad((_invViewProjRelative[1].y), _93, (_91 * (_invViewProjRelative[1].x)))) + (_invViewProjRelative[1].w)) / _129;
        float _132 = (mad((_invViewProjRelative[2].z), _79, mad((_invViewProjRelative[2].y), _93, (_91 * (_invViewProjRelative[2].x)))) + (_invViewProjRelative[2].w)) / _129;
        float _139 = 1.0f / sqrt(((_131 * _131) + (_130 * _130)) + (_132 * _132));
        uint4 _141 = __3__36__0__0__g_baseColor.Load(int3(((int)((((uint)(((int)((uint)(_43) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_24 - (_25 << 1)) << 4)))), ((int)((((uint)(_25 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_43)) >> 16) << 5)))), 0));
        float4 _147 = __3__36__0__0__g_normal.Load(int3(((int)((((uint)(((int)((uint)(_43) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_24 - (_25 << 1)) << 4)))), ((int)((((uint)(_25 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_43)) >> 16) << 5)))), 0));
        half _156 = half(float((uint)((uint)(((uint)((uint)(_141.x)) >> 8) & 255))) * 0.003921568859368563f);
        half _160 = half(float((uint)((uint)(_141.x & 255))) * 0.003921568859368563f);
        half _165 = half(float((uint)((uint)(((uint)((uint)(_141.y)) >> 8) & 255))) * 0.003921568859368563f);
        half _174 = half(float((uint)((uint)(((uint)((uint)(_141.z)) >> 8) & 255))) * 0.003921568859368563f);
        uint _186 = uint((_147.w * 3.0f) + 0.5f);
        float _197 = (saturate(_147.x * 1.0009784698486328f) * 2.0f) + -1.0f;
        float _198 = (saturate(_147.y * 1.0009784698486328f) * 2.0f) + -1.0f;
        float _199 = (saturate(_147.z * 1.0009784698486328f) * 2.0f) + -1.0f;
        float _201 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
        half _205 = half(_201 * _197);
        half _206 = half(_201 * _198);
        half _207 = half(_199 * _201);
        half _210 = (half(float((uint)((uint)(((uint)((uint)(_141.w)) >> 8) & 255))) * 0.003921568859368563f) * 2.0h) + -1.0h;
        half _211 = (half(float((uint)((uint)(_141.w & 255))) * 0.003921568859368563f) * 2.0h) + -1.0h;
        float _216 = float(_210 + _211) * 0.5f;
        float _217 = float(_210 - _211) * 0.5f;
        float _221 = (1.0f - abs(_216)) - abs(_217);
        float _223 = rsqrt(dot(float3(_216, _217, _221), float3(_216, _217, _221)));
        float _230 = float(_205);
        float _231 = float(_206);
        float _232 = float(_207);
        float _234 = select((_207 >= 0.0h), 1.0f, -1.0f);
        float _237 = -0.0f - (1.0f / (_234 + _232));
        float _238 = _231 * _237;
        float _239 = _238 * _230;
        float _240 = _234 * _230;
        float _247 = float(half(_223 * _216));
        float _248 = float(half(_223 * _217));
        float _249 = float(half(_223 * _221));
        half _261 = half(mad(_249, _230, mad(_248, _239, (_247 * (((_240 * _230) * _237) + 1.0f)))));
        half _262 = half(mad(_249, _231, mad(_248, ((_238 * _231) + _234), ((_247 * _234) * _239))));
        half _263 = half(mad(_249, _232, mad(_248, (-0.0f - _231), (-0.0f - (_240 * _247)))));
        half _265 = rsqrt(dot(half3(_261, _262, _263), half3(_261, _262, _263)));
        half _272 = saturate(_156 * _156);
        half _273 = saturate(_160 * _160);
        half _274 = saturate(_165 * _165);
        half _293 = saturate(saturate(((_273 * 0.3395996h) + (_272 * 0.61328125h)) + (_274 * 0.04736328h)));
        half _294 = saturate(saturate(((_273 * 0.9165039h) + (_272 * 0.07019043h)) + (_274 * 0.013450623h)));
        half _295 = saturate(saturate(((_273 * 0.109558105h) + (_272 * 0.020614624h)) + (_274 * 0.8696289h)));
        half _296 = max(0.020004272h, _174);
        half _297 = saturate(half(float((uint)((uint)(_141.y & 255))) * 0.003921568859368563f));
        int _299 = _75 & 126;
        if ((uint)_76 > (uint)10) {
          half _304 = select(((((uint)_76 < (uint)20)) || ((_76 == 107))), 0.0h, _297);
          bool __defer_300_321 = false;
          if (!(((_299 == 96)) || ((_76 == 98)))) {
            if ((uint)(_76 + -105) < (uint)2) {
              if ((int)(_186) == 1) {
                _322 = 0.0h;
              } else {
                _322 = _304;
              }
              __defer_300_321 = true;
            } else {
              if (_76 == 65) {
                _322 = 0.0h;
                __defer_300_321 = true;
              } else {
                if (((_76 == 24)) || ((_76 == 29))) {
                  _326 = 0.0h;
                  _327 = (_76 == 19);
                  if (!(((_299 == 26)) || ((_76 == 28)))) {
                    _332 = _327;
                    _333 = _326;
                    _336 = _332;
                    _337 = _333;
                    _338 = (_76 == 107);
                  } else {
                    _336 = _327;
                    _337 = _326;
                    _338 = true;
                  }
                } else {
                  _322 = _304;
                  __defer_300_321 = true;
                }
              }
            }
          } else {
            _322 = 0.0h;
            __defer_300_321 = true;
          }
          if (__defer_300_321) {
            bool _323 = (_76 == 19);
            if (!((uint)(_76 + -105) < (uint)2)) {
              _326 = _322;
              _327 = _323;
              if (!(((_299 == 26)) || ((_76 == 28)))) {
                _332 = _327;
                _333 = _326;
                _336 = _332;
                _337 = _333;
                _338 = (_76 == 107);
              } else {
                _336 = _327;
                _337 = _326;
                _338 = true;
              }
            } else {
              _336 = _323;
              _337 = _322;
              _338 = true;
            }
          }
        } else {
          _332 = false;
          _333 = _297;
          _336 = _332;
          _337 = _333;
          _338 = (_76 == 107);
        }
        bool _340 = (_299 == 64);
        bool _342 = (_lightingParams.x > 0.5f);
        if (_342) {
          float4 _346 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_88, _89), 0.0f);
          _349 = _346.y;
        } else {
          _349 = 0.0f;
        }
        float _350 = float(_265 * _261);
        float _351 = float(_265 * _262);
        float _352 = float(_265 * _263);
        if (_76 == 53) {
          _360 = saturate(((_294 + _293) + _295) * 1.2001953h);
        } else {
          _360 = 1.0h;
        }
        half _366 = (0.7001953h / min(max(max(max(_293, _294), _295), 0.010002136h), 0.7001953h)) * _360;
        float _379 = float((((_366 * _293) + -0.040008545h) * _337) + 0.040008545h);
        float _380 = float((((_366 * _294) + -0.040008545h) * _337) + 0.040008545h);
        float _381 = float((((_366 * _295) + -0.040008545h) * _337) + 0.040008545h);
        if (_342) {
          float _390 = float(saturate(rsqrt(dot(half3(_205, _206, _207), half3(_205, _206, _207))) * _206));
          float _391 = _390 * _390;
          float _392 = _391 * _391;
          float _393 = _392 * _392;
          float _396 = (_393 * _393) * (_349 * select((((_76 == 29)) || (((_336) || (_338)))), 0.0f, 1.0f));
          float _401 = _350 - (_396 * _350);
          float _402 = (_396 * (1.0f - _351)) + _351;
          float _403 = _352 - (_396 * _352);
          float _405 = rsqrt(dot(float3(_401, _402, _403), float3(_401, _402, _403)));
          _410 = (_401 * _405);
          _411 = (_402 * _405);
          _412 = (_403 * _405);
        } else {
          _410 = _350;
          _411 = _351;
          _412 = _352;
        }
        float _413 = float(_296);
        float _414 = _413 * _413;
        float _415 = _414 * _414;
        float _417 = float(_296 * 0.60009766h);
        float _418 = _417 * _417;
        float _419 = _418 * _418;
        uint2 _421 = __3__36__0__0__g_manyLightsHitData.Load(int3(((int)((((uint)(((int)((uint)(_43) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_24 - (_25 << 1)) << 4)))), ((int)((((uint)(_25 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_43)) >> 16) << 5)))), 0));
        int _431 = select(((_421.x | _421.y) != 0), (((uint)((uint)(_421.x)) >> 16) & 32767), 32767);
        float _434 = __3__37__0__0__g_manyLightsDataBuffer[_431]._position.x;
        float _435 = __3__37__0__0__g_manyLightsDataBuffer[_431]._position.y;
        float _436 = __3__37__0__0__g_manyLightsDataBuffer[_431]._position.z;
        float _438 = __3__37__0__0__g_manyLightsDataBuffer[_431]._color.x;
        float _439 = __3__37__0__0__g_manyLightsDataBuffer[_431]._color.y;
        float _440 = __3__37__0__0__g_manyLightsDataBuffer[_431]._color.z;
        // --- Local light hue correction (MB space) ---
        {
          float3 _corrected_color = ApplyLocalLightHueCorrection(
            float3(_438, _439, _440),
            LOCAL_LIGHT_HUE_CORRECTION,
            LOCAL_LIGHT_SATURATION);
          _438 = _corrected_color.x;
          _439 = _corrected_color.y;
          _440 = _corrected_color.z;
        }
        float _441 = __3__37__0__0__g_manyLightsDataBuffer[_431]._color.w;
        int _443 = __3__37__0__0__g_manyLightsDataBuffer[_431]._up.x;
        int _444 = __3__37__0__0__g_manyLightsDataBuffer[_431]._up.y;
        int _446 = __3__37__0__0__g_manyLightsDataBuffer[_431]._look.x;
        int _447 = __3__37__0__0__g_manyLightsDataBuffer[_431]._look.y;
        float _450 = _434 - _130;
        float _451 = _435 - _131;
        float _452 = _436 - _132;
        float _458 = sqrt(((_450 * _450) + (_451 * _451)) + (_452 * _452));
        float _459 = 1.0f / _458;
        float _460 = _459 * _450;
        float _461 = _459 * _451;
        float _462 = _459 * _452;
        float _467 = f16tof32(((uint)(_443 & 65535)));
        float _468 = f16tof32(((uint)((uint)((uint)(_443)) >> 16)));
        float _469 = f16tof32(((uint)(_444 & 65535)));
        float _470 = f16tof32(((uint)((uint)((uint)(_444)) >> 16)));
        float _472 = rsqrt(dot(float3(_467, _468, _469), float3(_467, _468, _469)));
        float _476 = f16tof32(((uint)(_446 & 65535)));
        float _477 = f16tof32(((uint)((uint)((uint)(_446)) >> 16)));
        float _478 = f16tof32(((uint)(_447 & 65535)));
        float _480 = rsqrt(dot(float3(_476, _477, _478), float3(_476, _477, _478)));
        float _481 = _480 * _476;
        float _482 = _480 * _477;
        float _483 = _480 * _478;
        if (!(!(_470 >= 0.0f))) {
          float _493 = mad(_462, (_472 * _469), mad(_461, (_472 * _468), ((_460 * _467) * _472)));
          float _496 = mad(_462, _483, mad(_461, _482, (_481 * _460)));
          float _504 = atan((-0.0f - _496) / (-0.0f - _493));
          bool _507 = (_493 > -0.0f);
          bool _508 = (_493 == -0.0f);
          bool _509 = (_496 <= -0.0f);
          bool _510 = (_496 > -0.0f);
          float _526 = __3__36__0__0__g_lightProfile.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((asin(dot(float3(_460, _461, _462), float3(_481, _482, _483))) * 0.31830987334251404f) + 0.5f), ((saturate(abs(select(((_508) && (_509)), 0.5f, select(((_508) && (_510)), -0.5f, (select(((_507) && (_510)), (_504 + -3.1415927410125732f), select(((_507) && (_509)), (_504 + 3.1415927410125732f), _504)) * 0.31830987334251404f))))) * f16tof32(((uint)((uint)((uint)(_447)) >> 16)))) + _470)), 0.0f);
          _532 = (_526.x * _438);
          _533 = (_526.x * _439);
          _534 = (_526.x * _440);
        } else {
          _532 = _438;
          _533 = _439;
          _534 = _440;
        }
        float _535 = abs(_441);
        float _544 = _139 * _130;
        float _545 = _139 * _131;
        float _546 = _139 * _132;
        float _547 = _460 * _458;
        float _548 = _461 * _458;
        float _549 = _462 * _458;
        float _550 = -0.0f - _544;
        float _551 = -0.0f - _545;
        float _552 = -0.0f - _546;
        float _554 = dot(float3(_550, _551, _552), float3(_350, _351, _352)) * 2.0f;
        float _558 = _550 - (_554 * _350);
        float _559 = _551 - (_554 * _351);
        float _560 = _552 - (_554 * _352);
        float _561 = dot(float3(_547, _548, _549), float3(_558, _559, _560));
        float _565 = (_558 * _561) - _547;
        float _566 = (_559 * _561) - _548;
        float _567 = (_560 * _561) - _549;
        float _575 = saturate(_535 / sqrt(((_565 * _565) + (_566 * _566)) + (_567 * _567)));
        float _579 = (_565 * _575) + _547;
        float _580 = (_566 * _575) + _548;
        float _581 = (_567 * _575) + _549;
        float _583 = rsqrt(dot(float3(_579, _580, _581), float3(_579, _580, _581)));
        float _584 = _579 * _583;
        float _585 = _580 * _583;
        float _586 = _581 * _583;
        float _587 = _584 - _544;
        float _588 = _585 - _545;
        float _589 = _586 - _546;
        float _591 = rsqrt(dot(float3(_587, _588, _589), float3(_587, _588, _589)));
        float _592 = _587 * _591;
        float _593 = _588 * _591;
        float _594 = _589 * _591;
        float _595 = dot(float3(_350, _351, _352), float3(_584, _585, _586));
        float _596 = dot(float3(_410, _411, _412), float3(_584, _585, _586));
        float _598 = saturate(dot(float3(_350, _351, _352), float3(_550, _551, _552)));
        float _600 = saturate(dot(float3(_410, _411, _412), float3(_592, _593, _594)));
        float _601 = dot(float3(_550, _551, _552), float3(_592, _593, _594));
        if (!(_595 <= 0.0f)) {
          float _605 = saturate(1.0f - _601);
          float _606 = _605 * _605;
          float _608 = (_606 * _606) * _605;
          float _611 = _608 * saturate(_380 * 50.0f);
          float _612 = 1.0f - _608;
          float _620 = saturate(_596);
          float _621 = 1.0f - _414;
          float _633 = (((_600 * _415) - _600) * _600) + 1.0f;
          float _637 = (_415 / ((_633 * _633) * 3.1415927410125732f)) * (0.5f / ((((_598 * _621) + _414) * _596) + (_598 * ((_596 * _621) + _414))));
          _648 = (max((((_612 * _379) + _611) * _637), 0.0f) * _620);
          _649 = (max((((_612 * _380) + _611) * _637), 0.0f) * _620);
          _650 = (max((((_612 * _381) + _611) * _637), 0.0f) * _620);
          // RenoDX: Diffuse
          if (DIFFUSE_BRDF_MODE >= 2.0f) {
            float _sNdotL = saturate(_595);
            float _eon_LdotV = dot(float3(_584, _585, _586), float3(_550, _551, _552));
            _651 = _sNdotL * EON_DiffuseScalar(_sNdotL, _598, _eon_LdotV, _413);
          } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
            float _sNdotL = saturate(_595);
            _651 = _sNdotL * HammonDiffuseScalar(_sNdotL, _598, _600, _601, _413);
          } else {
            _651 = (_595 * 0.31830987334251404f);
          }
        } else {
          _648 = 0.0f;
          _649 = 0.0f;
          _650 = 0.0f;
          _651 = 0.0f;
        }
        if (((_76 != 65)) && (_340)) {
          float _659 = saturate(1.0f - _601);
          float _660 = _659 * _659;
          float _662 = (_660 * _660) * _659;
          float _665 = _662 * saturate(_380 * 50.0f);
          float _666 = 1.0f - _662;
          float _674 = 1.0f - _418;
          float _686 = (((_600 * _419) - _600) * _600) + 1.0f;
          float _690 = (_419 / ((_686 * _686) * 3.1415927410125732f)) * (0.5f / ((((_598 * _674) + _418) * _596) + (_598 * ((_596 * _674) + _418))));
          float _697 = saturate(_596) * 0.39990234375f;
          _705 = ((max((((_666 * _379) + _665) * _690), 0.0f) * _697) + (_648 * 0.60009765625f));
          _706 = ((max((((_666 * _380) + _665) * _690), 0.0f) * _697) + (_649 * 0.60009765625f));
          _707 = ((max((((_666 * _381) + _665) * _690), 0.0f) * _697) + (_650 * 0.60009765625f));
        } else {
          _705 = _648;
          _706 = _649;
          _707 = _650;
        }
        // RenoDX: Diffraction on Rough Surfaces
        if (DIFFRACTION > 0.0f && float(_337) > 0.0f) {
          float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
            _600, _598, _413,
            float2(_88, _89), (_nearFarProj.x / _79),
            float3(_592, _593, _594),
            float3(_410, _411, _412),
            float3(_379, _380, _381)
          );
          float3 _rndx_dMod = lerp(1.0f, _rndx_dShift, DIFFRACTION * float(_337));
          _705 *= _rndx_dMod.x;
          _706 *= _rndx_dMod.y;
          _707 *= _rndx_dMod.z;
        }
        // RenoDX: Callisto Smooth Terminator
        if (SMOOTH_TERMINATOR > 0.0f) {
          float _rndx_st = CallistoSmoothTerminator(_595, _601, _600, SMOOTH_TERMINATOR, 0.5f);
          _651 *= _rndx_st;
          _705 *= _rndx_st;
          _706 *= _rndx_st;
          _707 *= _rndx_st;
        }
        float _709 = saturate(select((_535 > 99999.0f), 1.0f, (1.0f / max((_535 * _535), (_458 * _458))))) * (float((bool)(uint)((float((uint)((uint)(_421.x & 65535))) * 0.015609979629516602f) >= 1000.0f)) * asfloat(_421.y));
        float _710 = _709 * _532;
        float _711 = _709 * _533;
        float _712 = _709 * _534;
        float _716 = float(_174);
        if ((((int)(_186) != 3)) && (_340)) {
          _731 = select((_cavityParams.z > 0.0f), 0.0f, 1.0f);
        } else {
          _731 = saturate(exp2((_716 * _716) * ((_nearFarProj.x / _79) * -0.005770780146121979f)));
        }
        float _735 = select((_cavityParams.x == 0.0f), 1.0f, _731);
        float _736 = float(_337);
        float _737 = float(_293);
        float _738 = float(_294);
        float _739 = float(_295);
        float _746 = 0.699999988079071f / min(max(max(max(_737, _738), _739), 0.009999999776482582f), 0.699999988079071f);
        float _756 = (((_746 * _737) + -0.03999999910593033f) * _736) + 0.03999999910593033f;
        float _757 = (((_746 * _738) + -0.03999999910593033f) * _736) + 0.03999999910593033f;
        float _758 = (((_746 * _739) + -0.03999999910593033f) * _736) + 0.03999999910593033f;
        if (_340) {
          _764 = (_756 * _735);
          _765 = (_757 * _735);
          _766 = (_758 * _735);
        } else {
          _764 = _756;
          _765 = _757;
          _766 = _758;
        }
        float2 _771 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, saturate(dot(float3(_550, _551, _552), float3(_410, _411, _412)))), (1.0f - _413)), 0.0f);
        float _783 = (_705 * _710) / max(0.009999999776482582f, ((_771.x * _764) + _771.y));
        float _784 = (_706 * _711) / max(0.009999999776482582f, ((_771.x * _765) + _771.y));
        float _785 = (_707 * _712) / max(0.009999999776482582f, ((_771.x * _766) + _771.y));
        float _786 = dot(float3(_783, _784, _785), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _792 = min((_exposure3.w * 8192.0f), _786) / max(9.999999974752427e-07f, _786);
        float _795 = _exposure4.x * _651;
        float _808 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_783 * _792)))));
        float _809 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_784 * _792)))));
        float _810 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_785 * _792)))));
        float _823 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_710 * _795)))));
        float _824 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_711 * _795)))));
        float _825 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_712 * _795)))));
        float _827 = dot(float3(_823, _824, _825), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) / _exposure4.x;
        __3__38__0__1__g_sceneDiffuseUAV[int2(((int)((((uint)(((int)((uint)(_43) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_24 - (_25 << 1)) << 4)))), ((int)((((uint)(_25 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_43)) >> 16) << 5)))))] = float4(_823, _824, _825, 0.0f);
        [branch]
        if (((((((_808 > 0.0f)) || ((_809 > 0.0f)))) || ((_810 > 0.0f)))) || ((_827 > 0.0f))) {
          __3__38__0__1__g_specularResultUAV[int2(((int)((((uint)(((int)((uint)(_43) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_24 - (_25 << 1)) << 4)))), ((int)((((uint)(_25 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_43)) >> 16) << 5)))))] = float4(_808, _809, _810, _827);
        }
      }
    }
  }
}