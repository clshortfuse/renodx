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

Texture2D<float4> __3__36__0__0__g_blueNoise : register(t88, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t0, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t152, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t40, space36);

Texture2D<float4> __3__36__0__0__g_character : register(t76, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t98, space36);

Texture2D<float2> __3__36__0__0__g_hairBrdfLookup : register(t100, space36);

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

cbuffer __3__35__0__0__MaterialParameterPresetTableConstantBuffer : register(b42, space35) {
  float4 _clothLightingCategory : packoffset(c000.x);
  float4 _clothLightingParameter[8] : packoffset(c001.x);
  float4 _colorPresetInfo : packoffset(c009.x);
  uint4 _colorPresetParameter[16] : packoffset(c010.x);
  float4 _debugOption : packoffset(c026.x);
};

cbuffer __3__1__0__0__RenderVoxelConstants : register(b0, space1) {
  float4 _lightingParams : packoffset(c000.x);
  float4 _tiledRadianceCacheParams : packoffset(c001.x);
};

SamplerState __0__4__0__0__g_staticBilinearWrap : register(s0, space4);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _22[4];
  int _30 = (int)(SV_GroupID.x) & 3;
  int _31 = (uint)((uint)(_30)) >> 1;
  _22[0] = ((g_tileIndex[(SV_GroupID.x) >> 4]).x);
  _22[1] = ((g_tileIndex[(SV_GroupID.x) >> 4]).y);
  _22[2] = ((g_tileIndex[(SV_GroupID.x) >> 4]).z);
  _22[3] = ((g_tileIndex[(SV_GroupID.x) >> 4]).w);
  int _49 = _22[(((uint)(SV_GroupID.x) >> 2) & 3)];
  uint _61 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(((uint)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4))) >> 5), ((uint)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5))) >> 5), 0));
  half _333;
  half _337;
  bool _338;
  bool _343;
  half _344;
  bool _347;
  half _348;
  bool _349;
  half _375;
  half _376;
  half _377;
  float _400;
  int _406;
  int _430;
  int _431;
  float _432;
  float _433;
  float _434;
  float _458;
  int _459;
  float _460;
  float _466;
  int _467;
  half _468;
  float _471;
  int _472;
  half _473;
  float _530;
  int _531;
  half _532;
  float _533;
  float _534;
  float _535;
  float _536;
  half _550;
  float _603;
  float _604;
  float _605;
  float _725;
  float _726;
  float _727;
  float _1188;
  float _1189;
  float _1190;
  float _1191;
  float _1245;
  float _1246;
  float _1247;
  float _1248;
  float _1249;
  float _1250;
  float _1251;
  float _1287;
  float _1321;
  float _1322;
  float _1323;
  float _1365;
  float _1366;
  float _1498;
  float _1499;
  float _1500;
  float _1515;
  float _1516;
  float _1517;
  [branch]
  if (!((_61.x & 1) == 0)) {
    if (_lightingParams.z > 0.0f) {
      uint _72 = __3__36__0__0__g_depthStencil.Load(int3(((int)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4)))), ((int)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5)))), 0));
      float _76 = float((uint)((uint)(_72.x & 16777215))) * 5.960465188081798e-08f;
      if (!(((_76 < 1.0000000116860974e-07f)) || ((_76 == 1.0f)))) {
        int _81 = (uint)((uint)(_72.x)) >> 24;
        int _82 = _81 & 127;
        float _85 = max(1.0000000116860974e-07f, _76);
        float _87 = float((uint)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4))));
        float _88 = float((uint)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5))));
        float _94 = _bufferSizeAndInvSize.z * (_87 + 0.5f);
        float _95 = _bufferSizeAndInvSize.w * (_88 + 0.5f);
        float _97 = (_94 * 2.0f) + -1.0f;
        float _99 = 1.0f - (_95 * 2.0f);
        float _135 = mad((_invViewProjRelative[3].z), _85, mad((_invViewProjRelative[3].y), _99, (_97 * (_invViewProjRelative[3].x)))) + (_invViewProjRelative[3].w);
        float _136 = (mad((_invViewProjRelative[0].z), _85, mad((_invViewProjRelative[0].y), _99, (_97 * (_invViewProjRelative[0].x)))) + (_invViewProjRelative[0].w)) / _135;
        float _137 = (mad((_invViewProjRelative[1].z), _85, mad((_invViewProjRelative[1].y), _99, (_97 * (_invViewProjRelative[1].x)))) + (_invViewProjRelative[1].w)) / _135;
        float _138 = (mad((_invViewProjRelative[2].z), _85, mad((_invViewProjRelative[2].y), _99, (_97 * (_invViewProjRelative[2].x)))) + (_invViewProjRelative[2].w)) / _135;
        float _144 = sqrt(((_137 * _137) + (_136 * _136)) + (_138 * _138));
        float _145 = 1.0f / _144;
        uint4 _147 = __3__36__0__0__g_baseColor.Load(int3(((int)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4)))), ((int)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5)))), 0));
        float4 _153 = __3__36__0__0__g_normal.Load(int3(((int)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4)))), ((int)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5)))), 0));
        half _162 = half(float((uint)((uint)(((uint)((uint)(_147.x)) >> 8) & 255))) * 0.003921568859368563f);
        half _166 = half(float((uint)((uint)(_147.x & 255))) * 0.003921568859368563f);
        half _171 = half(float((uint)((uint)(((uint)((uint)(_147.y)) >> 8) & 255))) * 0.003921568859368563f);
        half _180 = half(float((uint)((uint)(((uint)((uint)(_147.z)) >> 8) & 255))) * 0.003921568859368563f);
        uint _196 = uint((_153.w * 3.0f) + 0.5f);
        bool _198 = ((int)(_196) == 3);
        float _208 = (saturate(_153.x * 1.0009784698486328f) * 2.0f) + -1.0f;
        float _209 = (saturate(_153.y * 1.0009784698486328f) * 2.0f) + -1.0f;
        float _210 = (saturate(_153.z * 1.0009784698486328f) * 2.0f) + -1.0f;
        float _212 = rsqrt(dot(float3(_208, _209, _210), float3(_208, _209, _210)));
        half _216 = half(_212 * _208);
        half _217 = half(_212 * _209);
        half _218 = half(_210 * _212);
        half _221 = (half(float((uint)((uint)(((uint)((uint)(_147.w)) >> 8) & 255))) * 0.003921568859368563f) * 2.0h) + -1.0h;
        half _222 = (half(float((uint)((uint)(_147.w & 255))) * 0.003921568859368563f) * 2.0h) + -1.0h;
        float _227 = float(_221 + _222) * 0.5f;
        float _228 = float(_221 - _222) * 0.5f;
        float _232 = (1.0f - abs(_227)) - abs(_228);
        float _234 = rsqrt(dot(float3(_227, _228, _232), float3(_227, _228, _232)));
        float _241 = float(_216);
        float _242 = float(_217);
        float _243 = float(_218);
        float _245 = select((_218 >= 0.0h), 1.0f, -1.0f);
        float _248 = -0.0f - (1.0f / (_245 + _243));
        float _249 = _242 * _248;
        float _250 = _249 * _241;
        float _251 = _245 * _241;
        float _258 = float(half(_234 * _227));
        float _259 = float(half(_234 * _228));
        float _260 = float(half(_234 * _232));
        half _272 = half(mad(_260, _241, mad(_259, _250, (_258 * (((_251 * _241) * _248) + 1.0f)))));
        half _273 = half(mad(_260, _242, mad(_259, ((_249 * _242) + _245), ((_258 * _245) * _250))));
        half _274 = half(mad(_260, _243, mad(_259, (-0.0f - _242), (-0.0f - (_251 * _258)))));
        half _276 = rsqrt(dot(half3(_272, _273, _274), half3(_272, _273, _274)));
        half _277 = _276 * _272;
        half _278 = _276 * _273;
        half _279 = _276 * _274;
        half _283 = saturate(_162 * _162);
        half _284 = saturate(_166 * _166);
        half _285 = saturate(_171 * _171);
        half _304 = saturate(saturate(((_284 * 0.3395996h) + (_283 * 0.61328125h)) + (_285 * 0.04736328h)));
        half _305 = saturate(saturate(((_284 * 0.9165039h) + (_283 * 0.07019043h)) + (_285 * 0.013450623h)));
        half _306 = saturate(saturate(((_284 * 0.109558105h) + (_283 * 0.020614624h)) + (_285 * 0.8696289h)));
        half _307 = max(0.020004272h, _180);
        half _308 = saturate(half(float((uint)((uint)(_147.y & 255))) * 0.003921568859368563f));
        int _310 = _81 & 126;
        if ((uint)_82 > (uint)10) {
          half _315 = select(((((uint)_82 < (uint)20)) || ((_82 == 107))), 0.0h, _308);
          bool __defer_311_332 = false;
          if (!(((_310 == 96)) || ((_82 == 98)))) {
            if ((uint)(_82 + -105) < (uint)2) {
              if ((int)(_196) == 1) {
                _333 = 0.0h;
              } else {
                _333 = _315;
              }
              __defer_311_332 = true;
            } else {
              if (_82 == 65) {
                _333 = 0.0h;
                __defer_311_332 = true;
              } else {
                if (((_82 == 24)) || ((_82 == 29))) {
                  _337 = 0.0h;
                  _338 = (_82 == 19);
                  if (!(((_310 == 26)) || ((_82 == 28)))) {
                    _343 = _338;
                    _344 = _337;
                    _347 = _343;
                    _348 = _344;
                    _349 = (_82 == 107);
                  } else {
                    _347 = _338;
                    _348 = _337;
                    _349 = true;
                  }
                } else {
                  _333 = _315;
                  __defer_311_332 = true;
                }
              }
            }
          } else {
            _333 = 0.0h;
            __defer_311_332 = true;
          }
          if (__defer_311_332) {
            bool _334 = (_82 == 19);
            if (!((uint)(_82 + -105) < (uint)2)) {
              _337 = _333;
              _338 = _334;
              if (!(((_310 == 26)) || ((_82 == 28)))) {
                _343 = _338;
                _344 = _337;
                _347 = _343;
                _348 = _344;
                _349 = (_82 == 107);
              } else {
                _347 = _338;
                _348 = _337;
                _349 = true;
              }
            } else {
              _347 = _334;
              _348 = _333;
              _349 = true;
            }
          }
        } else {
          _343 = false;
          _344 = _308;
          _347 = _343;
          _348 = _344;
          _349 = (_82 == 107);
        }
        bool _351 = (_82 == 33);
        bool _352 = (_82 == 55);
        bool _353 = (_351) || (_352);
        bool _355 = (_82 == 65);
        bool _356 = (_310 == 64);
        if (((((_82 == 54)) || (_356))) || (((_353) || ((_310 == 66))))) {
          float4 _364 = __3__36__0__0__g_character.Load(int3(((int)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4)))), ((int)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5)))), 0));
          _375 = half(saturate(_364.x));
          _376 = half(saturate(_364.y));
          _377 = half(saturate(_364.z));
        } else {
          _375 = 0.0h;
          _376 = 0.0h;
          _377 = 0.0h;
        }
        half _381 = (_375 * 2.0h) + -1.0h;
        half _382 = (_376 * 2.0h) + -1.0h;
        half _383 = (_377 * 2.0h) + -1.0h;
        half _385 = rsqrt(dot(half3(_381, _382, _383), half3(_381, _382, _383)));
        float _389 = float(_385 * _381);
        float _390 = float(_385 * _382);
        float _391 = float(_383 * _385);
        bool _393 = (_lightingParams.x > 0.5f);
        if (_393) {
          float4 _397 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_94, _95), 0.0f);
          _400 = _397.y;
        } else {
          _400 = 0.0f;
        }
        [branch]
        if (_353) {
          bool __defer_401_409 = false;
          if (_352) {
            if (_377 < 0.0010004044h) {
              _406 = 53;
              _430 = _406;
              _431 = ((int)(uint)((int)(_406 == 55)));
              _432 = 0.0f;
              _433 = 0.0f;
              _434 = 0.0f;
            } else {
              __defer_401_409 = true;
            }
          } else {
            if (_351) {
              __defer_401_409 = true;
            } else {
              _406 = _82;
              _430 = _406;
              _431 = ((int)(uint)((int)(_406 == 55)));
              _432 = 0.0f;
              _433 = 0.0f;
              _434 = 0.0f;
            }
          }
          if (__defer_401_409) {
            uint _415 = uint((_clothLightingCategory.x * float(_375)) + 0.5f);
            if (((_377 > 0.0h)) && (((uint)(int)(_415) < (uint)(int)(uint(_clothLightingCategory.x))))) {
              _430 = _82;
              _431 = 1;
              _432 = min((1.0f - ((_clothLightingParameter[_415]).y)), ((_clothLightingParameter[_415]).x));
              _433 = saturate(float(_376));
              _434 = ((_clothLightingParameter[_415]).x);
            } else {
              _430 = _82;
              _431 = 1;
              _432 = 0.0f;
              _433 = 0.0f;
              _434 = 0.0f;
            }
          }
        } else {
          _430 = _82;
          _431 = ((int)(uint)((int)(_353)));
          _432 = 0.0f;
          _433 = 0.0f;
          _434 = 0.0f;
        }
        float _435 = float(_348);
        bool __defer_429_470 = false;
        if (_430 == 66) {
          _471 = _435;
          _472 = 66;
          _473 = 0.0h;
          __defer_429_470 = true;
        } else {
          bool __defer_437_465 = false;
          bool __defer_437_457 = false;
          if (((_430 == 67)) || ((_430 == 54))) {
            float _446 = float((uint)((uint)(((int)(_frameNumber.x * 73)) & 127)));
            if (_435 > (frac(frac(dot(float2(((_446 * 32.665000915527344f) + _87), ((_446 * 11.8149995803833f) + _88)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 0.20000000298023224f)) {
              _458 = 1.0f;
              _459 = 53;
              _460 = 0.0f;
              __defer_437_457 = true;
            } else {
              bool __branch_chain_462;
              if ((_430 & -2) == 66) {
                _471 = 1.0f;
                _472 = _430;
                _473 = 0.0h;
                __branch_chain_462 = true;
              } else {
                _466 = 1.0f;
                _467 = _430;
                _468 = 0.0h;
                if (_467 == 54) {
                  _471 = _466;
                  _472 = 54;
                  _473 = _468;
                  __branch_chain_462 = true;
                } else {
                  _530 = _466;
                  _531 = _467;
                  _532 = _468;
                  _533 = 0.0f;
                  _534 = 0.0f;
                  _535 = 0.0f;
                  _536 = 0.0f;
                  __branch_chain_462 = false;
                }
              }
              if (__branch_chain_462) {
                __defer_429_470 = true;
              }
            }
          } else {
            _458 = 0.0f;
            _459 = _430;
            _460 = _435;
            __defer_437_457 = true;
          }
          if (__defer_437_465) {
            if (_467 == 54) {
              _471 = _466;
              _472 = 54;
              _473 = _468;
              __defer_429_470 = true;
            } else {
              _530 = _466;
              _531 = _467;
              _532 = _468;
              _533 = 0.0f;
              _534 = 0.0f;
              _535 = 0.0f;
              _536 = 0.0f;
            }
          }
          if (__defer_437_457) {
            _466 = _458;
            _467 = _459;
            _468 = half(_460);
            __defer_437_465 = true;
          }
        }
        if (__defer_429_470) {
          float _488 = (_144 * 2.0f) + 1.0f;
          float _492 = (_471 * 7.0f) + 1.0f;
          float4 _497 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2((((dot(float3(_136, _137, _138), float3(((_391 * _242) - (_390 * _243)), ((_389 * _243) - (_391 * _241)), ((_390 * _241) - (_389 * _242)))) * 2.0f) / _488) * _492), (((dot(float3(_136, _137, _138), float3(_389, _390, _391)) * 0.5f) / _488) * _492)), 0.0f);
          float _501 = _471 * 0.5f;
          float _502 = _497.x * 2.0f;
          float _503 = _497.y * 2.0f;
          float _504 = _497.z * 2.0f;
          float _511 = ((1.0f - _502) * _501) + _502;
          float _512 = ((1.0f - _503) * _501) + _503;
          float _513 = ((1.0f - _504) * _501) + _504;
          if (_472 == 54) {
            _530 = _471;
            _531 = 54;
            _532 = _473;
            _533 = _511;
            _534 = _512;
            _535 = _513;
            _536 = (((asfloat(_globalLightParams.z) * float(_307)) + _bevelParams.y) + (asfloat(_globalLightParams.w) * float(half(float((uint)((uint)(_147.z & 255))) * 0.003921568859368563f))));
          } else {
            _530 = _471;
            _531 = _472;
            _532 = _473;
            _533 = _511;
            _534 = _512;
            _535 = _513;
            _536 = _bevelParams.y;
          }
        }
        float _540 = float(select(_355, _216, _277));
        float _541 = float(select(_355, _217, _278));
        float _542 = float(select(_355, _218, _279));
        if (_531 == 53) {
          _550 = saturate(((_305 + _304) + _306) * 1.2001953h);
        } else {
          _550 = 1.0h;
        }
        half _556 = (0.7001953h / min(max(max(max(_304, _305), _306), 0.010002136h), 0.7001953h)) * _550;
        float _569 = float((((_556 * _304) + -0.040008545h) * _532) + 0.040008545h);
        float _570 = float((((_556 * _305) + -0.040008545h) * _532) + 0.040008545h);
        float _571 = float((((_556 * _306) + -0.040008545h) * _532) + 0.040008545h);
        float _572 = float(_277);
        float _573 = float(_278);
        float _574 = float(_279);
        if (_393) {
          float _583 = float(saturate(rsqrt(dot(half3(_216, _217, _218), half3(_216, _217, _218))) * _217));
          float _584 = _583 * _583;
          float _585 = _584 * _584;
          float _586 = _585 * _585;
          float _589 = (_586 * _586) * (_400 * select((((_82 == 29)) || (((_347) || (_349)))), 0.0f, 1.0f));
          float _594 = _572 - (_589 * _572);
          float _595 = (_589 * (1.0f - _573)) + _573;
          float _596 = _574 - (_589 * _574);
          float _598 = rsqrt(dot(float3(_594, _595, _596), float3(_594, _595, _596)));
          _603 = (_594 * _598);
          _604 = (_595 * _598);
          _605 = (_596 * _598);
        } else {
          _603 = _572;
          _604 = _573;
          _605 = _574;
        }
        float _606 = float(_307);
        float _607 = _606 * _606;
        float _608 = _607 * _607;
        float _610 = float(_307 * 0.60009766h);
        float _611 = _610 * _610;
        float _612 = _611 * _611;
        uint2 _614 = __3__36__0__0__g_manyLightsHitData.Load(int3(((int)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4)))), ((int)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5)))), 0));
        int _624 = select(((_614.x | _614.y) != 0), (((uint)((uint)(_614.x)) >> 16) & 32767), 32767);
        float _627 = __3__37__0__0__g_manyLightsDataBuffer[_624]._position.x;
        float _628 = __3__37__0__0__g_manyLightsDataBuffer[_624]._position.y;
        float _629 = __3__37__0__0__g_manyLightsDataBuffer[_624]._position.z;
        float _631 = __3__37__0__0__g_manyLightsDataBuffer[_624]._color.x;
        float _632 = __3__37__0__0__g_manyLightsDataBuffer[_624]._color.y;
        float _633 = __3__37__0__0__g_manyLightsDataBuffer[_624]._color.z;
        // --- Local light hue correction (MB space) ---
        {
          float3 _corrected_color = ApplyLocalLightHueCorrection(
            float3(_631, _632, _633),
            LOCAL_LIGHT_HUE_CORRECTION,
            LOCAL_LIGHT_SATURATION);
          _631 = _corrected_color.x;
          _632 = _corrected_color.y;
          _633 = _corrected_color.z;
        }
        float _634 = __3__37__0__0__g_manyLightsDataBuffer[_624]._color.w;
        int _636 = __3__37__0__0__g_manyLightsDataBuffer[_624]._up.x;
        int _637 = __3__37__0__0__g_manyLightsDataBuffer[_624]._up.y;
        int _639 = __3__37__0__0__g_manyLightsDataBuffer[_624]._look.x;
        int _640 = __3__37__0__0__g_manyLightsDataBuffer[_624]._look.y;
        float _642 = float((bool)(uint)((float((uint)((uint)(_614.x & 65535))) * 0.015609979629516602f) >= 1000.0f));
        float _643 = _627 - _136;
        float _644 = _628 - _137;
        float _645 = _629 - _138;
        float _651 = sqrt(((_643 * _643) + (_644 * _644)) + (_645 * _645));
        float _652 = 1.0f / _651;
        float _653 = _652 * _643;
        float _654 = _652 * _644;
        float _655 = _652 * _645;
        float _660 = f16tof32(((uint)(_636 & 65535)));
        float _661 = f16tof32(((uint)((uint)((uint)(_636)) >> 16)));
        float _662 = f16tof32(((uint)(_637 & 65535)));
        float _663 = f16tof32(((uint)((uint)((uint)(_637)) >> 16)));
        float _665 = rsqrt(dot(float3(_660, _661, _662), float3(_660, _661, _662)));
        float _669 = f16tof32(((uint)(_639 & 65535)));
        float _670 = f16tof32(((uint)((uint)((uint)(_639)) >> 16)));
        float _671 = f16tof32(((uint)(_640 & 65535)));
        float _673 = rsqrt(dot(float3(_669, _670, _671), float3(_669, _670, _671)));
        float _674 = _673 * _669;
        float _675 = _673 * _670;
        float _676 = _673 * _671;
        if (!(!(_663 >= 0.0f))) {
          float _686 = mad(_655, (_665 * _662), mad(_654, (_665 * _661), ((_653 * _660) * _665)));
          float _689 = mad(_655, _676, mad(_654, _675, (_674 * _653)));
          float _697 = atan((-0.0f - _689) / (-0.0f - _686));
          bool _700 = (_686 > -0.0f);
          bool _701 = (_686 == -0.0f);
          bool _702 = (_689 <= -0.0f);
          bool _703 = (_689 > -0.0f);
          float _719 = __3__36__0__0__g_lightProfile.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((asin(dot(float3(_653, _654, _655), float3(_674, _675, _676))) * 0.31830987334251404f) + 0.5f), ((saturate(abs(select(((_701) && (_702)), 0.5f, select(((_701) && (_703)), -0.5f, (select(((_700) && (_703)), (_697 + -3.1415927410125732f), select(((_700) && (_702)), (_697 + 3.1415927410125732f), _697)) * 0.31830987334251404f))))) * f16tof32(((uint)((uint)((uint)(_640)) >> 16)))) + _663)), 0.0f);
          _725 = (_719.x * _631);
          _726 = (_719.x * _632);
          _727 = (_719.x * _633);
        } else {
          _725 = _631;
          _726 = _632;
          _727 = _633;
        }
        float _728 = abs(_634);
        float _737 = _145 * _136;
        float _738 = _145 * _137;
        float _739 = _145 * _138;
        float _740 = _653 * _651;
        float _741 = _654 * _651;
        float _742 = _655 * _651;
        float _743 = -0.0f - _737;
        float _744 = -0.0f - _738;
        float _745 = -0.0f - _739;
        float _747 = dot(float3(_743, _744, _745), float3(_540, _541, _542)) * 2.0f;
        float _751 = _743 - (_747 * _540);
        float _752 = _744 - (_747 * _541);
        float _753 = _745 - (_747 * _542);
        float _754 = dot(float3(_740, _741, _742), float3(_751, _752, _753));
        float _758 = (_751 * _754) - _740;
        float _759 = (_752 * _754) - _741;
        float _760 = (_753 * _754) - _742;
        float _768 = saturate(_728 / sqrt(((_758 * _758) + (_759 * _759)) + (_760 * _760)));
        float _772 = (_758 * _768) + _740;
        float _773 = (_759 * _768) + _741;
        float _774 = (_760 * _768) + _742;
        float _776 = rsqrt(dot(float3(_772, _773, _774), float3(_772, _773, _774)));
        float _777 = _772 * _776;
        float _778 = _773 * _776;
        float _779 = _774 * _776;
        float _780 = _777 - _737;
        float _781 = _778 - _738;
        float _782 = _779 - _739;
        float _784 = rsqrt(dot(float3(_780, _781, _782), float3(_780, _781, _782)));
        float _785 = _780 * _784;
        float _786 = _781 * _784;
        float _787 = _782 * _784;
        float _788 = dot(float3(_540, _541, _542), float3(_777, _778, _779));
        float _789 = dot(float3(_603, _604, _605), float3(_777, _778, _779));
        float _791 = saturate(dot(float3(_540, _541, _542), float3(_743, _744, _745)));
        float _793 = saturate(dot(float3(_603, _604, _605), float3(_785, _786, _787)));
        float _794 = dot(float3(_743, _744, _745), float3(_785, _786, _787));
        int _795 = _531 & -2;
        bool _798 = ((_531 == 54)) || ((_795 == 66));
        if (_798) {
          float _800 = float(_304);
          float _801 = float(_305);
          float _802 = float(_306);
          float _804 = dot(float3(_389, _390, _391), float3(_777, _778, _779));
          float _805 = dot(float3(_389, _390, _391), float3(_743, _744, _745));
          float _811 = cos(abs(asin(_805) - asin(_804)) * 0.5f);
          float _815 = _777 - (_804 * _389);
          float _816 = _778 - (_804 * _390);
          float _817 = _779 - (_804 * _391);
          float _821 = _743 - (_805 * _389);
          float _822 = _744 - (_805 * _390);
          float _823 = _745 - (_805 * _391);
          float _830 = rsqrt((dot(float3(_821, _822, _823), float3(_821, _822, _823)) * dot(float3(_815, _816, _817), float3(_815, _816, _817))) + 9.999999747378752e-05f) * dot(float3(_815, _816, _817), float3(_821, _822, _823));
          float _834 = sqrt(saturate((_830 * 0.5f) + 0.5f));
          float _841 = min(max(_606, 0.09803921729326248f), 1.0f);
          float _842 = _841 * _841;
          float _843 = _842 * 0.5f;
          float _844 = _842 * 2.0f;
          float _845 = _805 + _804;
          float _846 = _845 + (_536 * 2.0f);
          float _848 = (_834 * 1.4142135381698608f) * _842;
          float _862 = 1.0f - sqrt(saturate((dot(float3(_743, _744, _745), float3(_777, _778, _779)) * 0.5f) + 0.5f));
          float _863 = _862 * _862;
          float _870 = _845 - _536;
          float _879 = 1.0f / ((1.190000057220459f / _811) + (_811 * 0.36000001430511475f));
          float _884 = ((_879 * (0.6000000238418579f - (_830 * 0.800000011920929f))) + 1.0f) * _834;
          float _890 = 1.0f - (sqrt(saturate(1.0f - (_884 * _884))) * _811);
          float _891 = _890 * _890;
          float _895 = 0.9534794092178345f - ((_891 * _891) * (_890 * 0.9534794092178345f));
          float _896 = _879 * _884;
          float _901 = (sqrt(1.0f - (_896 * _896)) * 0.5f) / _811;
          float _902 = log2(_800);
          float _903 = log2(_801);
          float _904 = log2(_802);
          float _916 = ((_895 * _895) * (exp2((((_870 * _870) * -0.5f) / (_843 * _843)) * 1.4426950216293335f) / (_842 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_830 * 5.2658371925354f));
          float _920 = _845 - (_536 * 4.0f);
          float _930 = 1.0f - (_811 * 0.5f);
          float _931 = _930 * _930;
          float _935 = (_931 * _931) * (0.9534794092178345f - (_811 * 0.47673970460891724f));
          float _937 = 0.9534794092178345f - _935;
          float _938 = 0.800000011920929f / _811;
          float _951 = (((_937 * _937) * (_935 + 0.04652056470513344f)) * (exp2((((_920 * _920) * -0.5f) / (_844 * _844)) * 1.4426950216293335f) / (_842 * 5.013256549835205f))) * exp2((_830 * 24.525815963745117f) + -24.208423614501953f);
          float _958 = saturate(_789);
          float _959 = (((_834 * 0.25f) * (exp2((((_846 * _846) * -0.5f) / (_848 * _848)) * 1.4426950216293335f) / (_848 * 2.5066282749176025f))) * (((_863 * _863) * (_862 * 0.9534794092178345f)) + 0.04652056470513344f)) * _958;
          float _972 = -0.0f - _958;
          float _983 = saturate((_789 + 1.0f) * 0.25f);
          float _988 = max(0.0010000000474974513f, dot(float3(_800, _801, _802), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)));
          float _989 = 1.0f - _642;
          float _1005 = ((((1.0f - abs(_789)) - _983) * 0.33000001311302185f) + _983) * 0.039788734167814255f;
          _1245 = (((exp2(log2(_800 / _988) * _989) * _1005) * sqrt(_800)) - min(0.0f, (((_951 * exp2(_938 * _902)) + (_916 * exp2(_902 * _901))) * _972)));
          _1246 = (((exp2(log2(_801 / _988) * _989) * _1005) * sqrt(_801)) - min(0.0f, (((_951 * exp2(_938 * _903)) + (_916 * exp2(_903 * _901))) * _972)));
          _1247 = (((exp2(log2(_802 / _988) * _989) * _1005) * sqrt(_802)) - min(0.0f, (((_951 * exp2(_938 * _904)) + (_916 * exp2(_904 * _901))) * _972)));
          _1248 = (-0.0f - min(0.0f, (-0.0f - (_533 * _959))));
          _1249 = (-0.0f - min(0.0f, (-0.0f - (_534 * _959))));
          _1250 = (-0.0f - min(0.0f, (-0.0f - (_535 * _959))));
          _1251 = 0.0f;
        } else {
          if (_431 == 0) {
            if (!(_788 <= 0.0f)) {
              float _1145 = saturate(1.0f - _794);
              float _1146 = _1145 * _1145;
              float _1148 = (_1146 * _1146) * _1145;
              float _1151 = _1148 * saturate(_570 * 50.0f);
              float _1152 = 1.0f - _1148;
              float _1160 = saturate(_789);
              float _1161 = 1.0f - _607;
              float _1173 = (((_793 * _608) - _793) * _793) + 1.0f;
              float _1177 = (_608 / ((_1173 * _1173) * 3.1415927410125732f)) * (0.5f / ((((_791 * _1161) + _607) * _789) + (_791 * ((_789 * _1161) + _607))));
              _1188 = (max((((_1152 * _569) + _1151) * _1177), 0.0f) * _1160);
              _1189 = (max((((_1152 * _570) + _1151) * _1177), 0.0f) * _1160);
              _1190 = (max((((_1152 * _571) + _1151) * _1177), 0.0f) * _1160);
              if (DIFFUSE_BRDF_MODE >= 2.0f) {
                float _sNdotL = saturate(_788);
                float _eon_LdotV = dot(float3(_777, _778, _779), float3(_743, _744, _745));
                _1191 = _sNdotL * EON_DiffuseScalar(_sNdotL, _791, _eon_LdotV, _606);
              } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
                float _sNdotL = saturate(_788);
                _1191 = _sNdotL * HammonDiffuseScalar(_sNdotL, _791, _793, _794, _606);
              } else {
                _1191 = (_788 * 0.31830987334251404f);
              }
            } else {
              _1188 = 0.0f;
              _1189 = 0.0f;
              _1190 = 0.0f;
              _1191 = 0.0f;
            }
            if ((_356) && ((_531 != 65))) {
              float _1199 = saturate(1.0f - _794);
              float _1200 = _1199 * _1199;
              float _1202 = (_1200 * _1200) * _1199;
              float _1205 = _1202 * saturate(_570 * 50.0f);
              float _1206 = 1.0f - _1202;
              float _1214 = 1.0f - _611;
              float _1226 = (((_793 * _612) - _793) * _793) + 1.0f;
              float _1230 = (_612 / ((_1226 * _1226) * 3.1415927410125732f)) * (0.5f / ((((_791 * _1214) + _611) * _789) + (_791 * ((_789 * _1214) + _611))));
              float _1237 = saturate(_789) * 0.39990234375f;
              _1245 = 0.0f;
              _1246 = 0.0f;
              _1247 = 0.0f;
              _1248 = ((max((((_1206 * _569) + _1205) * _1230), 0.0f) * _1237) + (_1188 * 0.60009765625f));
              _1249 = ((max((((_1206 * _570) + _1205) * _1230), 0.0f) * _1237) + (_1189 * 0.60009765625f));
              _1250 = ((max((((_1206 * _571) + _1205) * _1230), 0.0f) * _1237) + (_1190 * 0.60009765625f));
              _1251 = _1191;
            } else {
              _1245 = 0.0f;
              _1246 = 0.0f;
              _1247 = 0.0f;
              _1248 = _1188;
              _1249 = _1189;
              _1250 = _1190;
              _1251 = _1191;
            }
          } else {
            float _1018 = float(_304);
            float _1019 = float(_305);
            float _1020 = float(_306);
            float _1036 = max(dot(float3(_1018, _1019, _1020), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)), 0.03999999910593033f);
            float _1040 = sqrt(_1018) - _1036;
            float _1041 = sqrt(_1019) - _1036;
            float _1042 = sqrt(_1020) - _1036;
            float _1049 = saturate(1.0f - (pow(_791, 4.0f)));
            float _1062 = (((_1041 * _432) + _1036) + ((_1041 * (_434 - _432)) * _1049)) * _433;
            float _1065 = saturate(1.0f - saturate(_794));
            float _1066 = _1065 * _1065;
            float _1068 = (_1066 * _1066) * _1065;
            float _1071 = _1068 * saturate(_1062 * 50.0f);
            float _1072 = 1.0f - _1068;
            float _1073 = _1072 * _433;
            float _1077 = (_1073 * (((_1040 * _432) + _1036) + (_1049 * (_1040 * (_434 - _432))))) + _1071;
            float _1078 = (_1072 * _1062) + _1071;
            float _1079 = (_1073 * (((_1042 * _432) + _1036) + ((_1042 * (_434 - _432)) * _1049))) + _1071;
            float _1080 = min(_793, 0.9998999834060669f);
            float _1081 = _1080 * _1080;
            float _1082 = 1.0f - _1081;
            float _1094 = (((exp2(((-0.0f - _1081) / (_1082 * _608)) * 1.4426950216293335f) * 4.0f) / (_1082 * _1082)) + 1.0f) / ((_608 * 12.566370964050293f) + 3.1415927410125732f);
            float _1098 = ((_791 + _789) - (_791 * _789)) * 4.0f;
            float _1102 = (_1077 * _1094) / _1098;
            float _1103 = (_1078 * _1094) / _1098;
            float _1104 = (_1079 * _1094) / _1098;
            float _1105 = 1.0f - _607;
            float _1117 = (((_793 * _608) - _793) * _793) + 1.0f;
            float _1121 = (_608 / ((_1117 * _1117) * 3.1415927410125732f)) * (0.5f / ((((_791 * _1105) + _607) * _788) + (_791 * ((_788 * _1105) + _607))));
            float _1137 = saturate(_789);
            _1245 = 0.0f;
            _1246 = 0.0f;
            _1247 = 0.0f;
            _1248 = ((((max((_1121 * _1077), 0.0f) - _1102) * _432) + _1102) * _1137);
            _1249 = ((((max((_1121 * _1078), 0.0f) - _1103) * _432) + _1103) * _1137);
            _1250 = ((((max((_1121 * _1079), 0.0f) - _1104) * _432) + _1104) * _1137);
            float _1251_velvet_mod = (((saturate(1.0f - _effectiveMetallicForVelvet) + -1.0f) * _434) + 1.0f);
            // RenoDX: Diffuse
            if (DIFFUSE_BRDF_MODE >= 2.0f) {
              float _sNdotL2 = saturate(_788);
              float _eon_LdotV2 = dot(float3(_777, _778, _779), float3(_743, _744, _745));
              _1251 = (_sNdotL2 * EON_DiffuseScalar(_sNdotL2, _791, _eon_LdotV2, _606)) * _1251_velvet_mod;
            } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
              float _sNdotL2 = saturate(_788);
              _1251 = (_sNdotL2 * HammonDiffuseScalar(_sNdotL2, _791, _793, _794, _606)) * _1251_velvet_mod;
            } else {
              _1251 = ((saturate(_788) * 0.31830987334251404f) * _1251_velvet_mod);
            }
          }
        }
        // RenoDX: Diffraction on Rough Surfaces
        if (DIFFRACTION > 0.0f && float(_532) > 0.0f) {
          float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
            _793, _791, _606,
            float2(_94, _95), (_nearFarProj.x / _85),
            float3(_785, _786, _787),
            float3(_603, _604, _605),
            float3(_569, _570, _571)
          );
          float3 _rndx_dMod = lerp(1.0f, _rndx_dShift, DIFFRACTION * float(_532));
          _1248 *= _rndx_dMod.x;
          _1249 *= _rndx_dMod.y;
          _1250 *= _rndx_dMod.z;
        }
        // RenoDX: Callisto Smooth Terminator
        if (SMOOTH_TERMINATOR > 0.0f) {
          float _rndx_st = CallistoSmoothTerminator(_788, _794, _793, SMOOTH_TERMINATOR, 0.5f);
          _1251 *= _rndx_st;
          _1248 *= _rndx_st;
          _1249 *= _rndx_st;
          _1250 *= _rndx_st;
        }
        float _1253 = saturate(select((_728 > 99999.0f), 1.0f, (1.0f / max((_728 * _728), (_651 * _651))))) * (_642 * asfloat(_614.y));
        float _1254 = _1253 * _725;
        float _1255 = _1253 * _726;
        float _1256 = _1253 * _727;
        float _1266 = float(_180);
        bool _1267 = (_795 == 64);
        if ((((int)(uint)((int)(_1267))) & (((int)(uint)((int)(_198))) ^ 1)) == 0) {
          _1287 = saturate(exp2((_1266 * _1266) * ((_nearFarProj.x / _85) * -0.005770780146121979f)));
        } else {
          _1287 = select((_cavityParams.z > 0.0f), select(_198, 0.0f, float(_376)), 1.0f);
        }
        float _1291 = select((_cavityParams.x == 0.0f), 1.0f, _1287);
        float _1293 = select(_798, 0.0f, float(_532));
        float _1294 = float(_304);
        float _1295 = float(_305);
        float _1296 = float(_306);
        float _1298 = saturate(dot(float3(_743, _744, _745), float3(_603, _604, _605)));
        float _1303 = 0.699999988079071f / min(max(max(max(_1294, _1295), _1296), 0.009999999776482582f), 0.699999988079071f);
        float _1313 = (((_1303 * _1294) + -0.03999999910593033f) * _1293) + 0.03999999910593033f;
        float _1314 = (((_1303 * _1295) + -0.03999999910593033f) * _1293) + 0.03999999910593033f;
        float _1315 = (((_1303 * _1296) + -0.03999999910593033f) * _1293) + 0.03999999910593033f;
        if (_1267) {
          _1321 = (_1313 * _1291);
          _1322 = (_1314 * _1291);
          _1323 = (_1315 * _1291);
        } else {
          _1321 = _1313;
          _1322 = _1314;
          _1323 = _1315;
        }
        if (_798) {
          float2 _1335 = __3__36__0__0__g_hairBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, (1.0f - saturate(abs(dot(float3(select(_798, _389, 0.0f), select(_798, _390, 1.0f), select(_798, _391, 0.0f)), float3(_737, _738, _739)))))), (1.0f - max(0.75f, (_606 * 2.0f)))), 0.0f);
          float2 _1341 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1298), (1.0f - _606)), 0.0f);
          float _1351 = (lerp(_1335.y, _1341.y, _530)) + ((lerp(_1335.x, _1341.x, _530)) * 0.009999999776482582f);
          _1515 = _1351;
          _1516 = _1351;
          _1517 = _1351;
        } else {
          if ((uint)(_531 + -97) < (uint)2) {
            if (!(abs(_242) > 0.9900000095367432f)) {
              float _1359 = -0.0f - _243;
              float _1361 = rsqrt(dot(float3(_1359, 0.0f, _241), float3(_1359, 0.0f, _241)));
              _1365 = (_1361 * _1359);
              _1366 = (_1361 * _241);
            } else {
              _1365 = 1.0f;
              _1366 = 0.0f;
            }
            float _1368 = -0.0f - (_242 * _1366);
            float _1371 = (_1366 * _241) - (_1365 * _243);
            float _1372 = _1365 * _242;
            float _1374 = rsqrt(dot(float3(_1368, _1371, _1372), float3(_1368, _1371, _1372)));
            float _1382 = _viewPos.x + _136;
            float _1383 = _viewPos.y + _137;
            float _1384 = _viewPos.z + _138;
            float4 _1389 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(dot(float3(_1365, 0.0f, _1366), float3(_1382, _1383, _1384)), dot(float3((_1374 * _1368), (_1371 * _1374), (_1374 * _1372)), float3(_1382, _1383, _1384))), 0.0f);
            float _1393 = _1389.x + -0.5f;
            float _1394 = _1389.y + -0.5f;
            float _1395 = _1389.z + -0.5f;
            float _1397 = rsqrt(dot(float3(_1393, _1394, _1395), float3(_1393, _1394, _1395)));
            float _1401 = (_1393 * _1397) + _603;
            float _1402 = (_1394 * _1397) + _604;
            float _1403 = (_1395 * _1397) + _605;
            float _1405 = rsqrt(dot(float3(_1401, _1402, _1403), float3(_1401, _1402, _1403)));
            float2 _1418 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1298), (1.0f - _606)), 0.0f);
            float _1425 = _1418.y + (exp2(log2(saturate(dot(float3(_743, _744, _745), float3((_1401 * _1405), (_1402 * _1405), (_1403 * _1405))))) * 512.0f) * 20.0f);
            _1515 = (_1425 + (_1418.x * _1321));
            _1516 = (_1425 + (_1418.x * _1322));
            _1517 = (_1425 + (_1418.x * _1323));
          } else {
            if (_1267) {
              if (_531 == 65) {
                _1498 = _1321;
                _1499 = _1322;
                _1500 = _1323;
                float2 _1505 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1298), (1.0f - _606)), 0.0f);
                _1515 = ((_1505.x * _1498) + _1505.y);
                _1516 = ((_1505.x * _1499) + _1505.y);
                _1517 = ((_1505.x * _1500) + _1505.y);
              } else {
                float _1435 = min(0.9900000095367432f, _1298);
                float2 _1440 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1435, saturate(1.0f - (_606 * 1.3300000429153442f))), 0.0f);
                float2 _1445 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1435, saturate(1.0f - (_606 * 0.47998046875f))), 0.0f);
                float _1449 = (_1445.x + _1440.x) * 0.5f;
                float _1451 = (_1445.y + _1440.y) * 0.5f;
                _1515 = ((_1449 * _1321) + _1451);
                _1516 = ((_1449 * _1322) + _1451);
                _1517 = ((_1449 * _1323) + _1451);
              }
            } else {
              if (((_531 == 33)) || ((_531 == 55))) {
                float _1468 = max(dot(float3(_1294, _1295, _1296), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)), 0.03999999910593033f);
                float _1472 = sqrt(_1294) - _1468;
                float _1473 = sqrt(_1295) - _1468;
                float _1474 = sqrt(_1296) - _1468;
                float _1481 = saturate(1.0f - (pow(_1298, 4.0f)));
                _1498 = ((((_1472 * _432) + _1468) + (_1481 * (_1472 * (_434 - _432)))) * _433);
                _1499 = ((((_1473 * _432) + _1468) + ((_1473 * (_434 - _432)) * _1481)) * _433);
                _1500 = ((((_1474 * _432) + _1468) + ((_1474 * (_434 - _432)) * _1481)) * _433);
              } else {
                _1498 = _1321;
                _1499 = _1322;
                _1500 = _1323;
              }
              float2 _1505 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(min(0.9900000095367432f, _1298), (1.0f - _606)), 0.0f);
              _1515 = ((_1505.x * _1498) + _1505.y);
              _1516 = ((_1505.x * _1499) + _1505.y);
              _1517 = ((_1505.x * _1500) + _1505.y);
            }
          }
        }
        float _1521 = (_1248 * _1254) / max(0.009999999776482582f, _1515);
        float _1522 = (_1249 * _1255) / max(0.009999999776482582f, _1516);
        float _1523 = (_1250 * _1256) / max(0.009999999776482582f, _1517);
        float _1524 = dot(float3(_1521, _1522, _1523), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _1530 = min((_exposure3.w * 8192.0f), _1524) / max(9.999999974752427e-07f, _1524);
        float _1545 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_1521 * _1530)))));
        float _1546 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_1522 * _1530)))));
        float _1547 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - (_1523 * _1530)))));
        float _1563 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - ((_1254 * (_1251 + _1245)) * _exposure4.x)))));
        float _1564 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - ((_1255 * (_1251 + _1246)) * _exposure4.x)))));
        float _1565 = min(30000.0f, (-0.0f - min(0.0f, (-0.0f - ((_1256 * (_1251 + _1247)) * _exposure4.x)))));
        float _1567 = dot(float3(_1563, _1564, _1565), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) / _exposure4.x;
        __3__38__0__1__g_sceneDiffuseUAV[int2(((int)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4)))), ((int)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5)))))] = float4(_1563, _1564, _1565, 0.0f);
        [branch]
        if (((((((_1545 > 0.0f)) || ((_1546 > 0.0f)))) || ((_1547 > 0.0f)))) || ((_1567 > 0.0f))) {
          __3__38__0__1__g_specularResultUAV[int2(((int)((((uint)(((int)((uint)(_49) << 5)) & 2097120)) + SV_GroupThreadID.x) + ((uint)((_30 - (_31 << 1)) << 4)))), ((int)((((uint)(_31 << 4)) + SV_GroupThreadID.y) + ((uint)(((uint)((uint)(_49)) >> 16) << 5)))))] = float4(_1545, _1546, _1547, _1567);
        }
      }
    }
  }
}