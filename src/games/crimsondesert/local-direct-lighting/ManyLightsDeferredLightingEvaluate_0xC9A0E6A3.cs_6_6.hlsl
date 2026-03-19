#include "../shared.h"
#include "../local-direct-lighting/local_light_common.hlsl"
#include "../lighting/diffuse_brdf.hlsli"

struct ManyLightsData {
  float4 _position;
  float4 _color;
  uint2 _up;
  uint2 _look;
};


Texture2D<float4> __3__36__0__0__g_puddleMask : register(t79, space36);

Texture2D<float> __3__36__0__0__g_lightProfile : register(t13, space36);

Texture2D<float4> __3__36__0__0__g_blueNoise : register(t0, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t14, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t119, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t31, space36);

Texture2D<float4> __3__36__0__0__g_character : register(t108, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t90, space36);

Texture2D<float2> __3__36__0__0__g_hairBrdfLookup : register(t92, space36);

StructuredBuffer<ManyLightsData> __3__37__0__0__g_manyLightsDataBuffer : register(t9, space37);

Texture2D<uint2> __3__36__0__0__g_manyLightsHitData : register(t134, space36);

Texture2D<uint> __3__36__0__0__g_tiledManyLightsMasks : register(t129, space36);

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
  int _31 = (uint)(_30) >> 1;
  int _32 = _31 << 1;
  int _33 = _30 - _32;
  int _34 = _33 << 4;
  int _35 = _31 << 4;
  int _36 = (uint)(SV_GroupID.x) >> 2;
  int _37 = (uint)(SV_GroupID.x) >> 4;
  int _38 = _36 & 3;
  _22[0] = (int)((g_tileIndex[_37]).x);
  _22[1] = (int)((g_tileIndex[_37]).y);
  _22[2] = (int)((g_tileIndex[_37]).z);
  _22[3] = (int)((g_tileIndex[_37]).w);
  int _49 = _22[_38];
  int _50 = (uint)(_49) >> 16;
  uint _51 = _49 << 5;
  int _52 = _51 & 2097120;
  int _53 = _50 << 5;
  uint _54 = _52 + SV_GroupThreadID.x;
  uint _55 = _54 + _34;
  uint _56 = _35 + SV_GroupThreadID.y;
  uint _57 = _56 + _53;
  int _58 = (uint)(_55) >> 5;
  int _59 = (uint)(_57) >> 5;
  uint _61 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(_58, _59, 0));
  int _63 = _61.x & 1;
  bool _64 = (_63 == 0);
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
  if (!_64) {
    bool _69 = (_lightingParams.z > 0.0f);
    if (_69) {
      uint _72 = __3__36__0__0__g_depthStencil.Load(int3(_55, _57, 0));
      int _74 = _72.x & 16777215;
      float _75 = float((uint)_74);
      float _76 = _75 * 5.960465188081798e-08f;
      bool _77 = (_76 < 1.0000000116860974e-07f);
      bool _78 = (_76 == 1.0f);
      bool _79 = (_77) | (_78);
      if (!_79) {
        int _81 = (uint)((uint)(_72.x)) >> 24;
        int _82 = _81 & 127;
        float _85 = max(1.0000000116860974e-07f, _76);
        float _86 = _nearFarProj.x / _85;
        float _87 = float((uint)_55);
        float _88 = float((uint)_57);
        float _89 = _87 + 0.5f;
        float _90 = _88 + 0.5f;
        float _94 = _bufferSizeAndInvSize.z * _89;
        float _95 = _bufferSizeAndInvSize.w * _90;
        float _96 = _94 * 2.0f;
        float _97 = _96 + -1.0f;
        float _98 = _95 * 2.0f;
        float _99 = 1.0f - _98;
        float _120 = _97 * (_invViewProjRelative[0].x);
        float _121 = mad((_invViewProjRelative[0].y), _99, _120);
        float _122 = mad((_invViewProjRelative[0].z), _85, _121);
        float _123 = _122 + (_invViewProjRelative[0].w);
        float _124 = _97 * (_invViewProjRelative[1].x);
        float _125 = mad((_invViewProjRelative[1].y), _99, _124);
        float _126 = mad((_invViewProjRelative[1].z), _85, _125);
        float _127 = _126 + (_invViewProjRelative[1].w);
        float _128 = _97 * (_invViewProjRelative[2].x);
        float _129 = mad((_invViewProjRelative[2].y), _99, _128);
        float _130 = mad((_invViewProjRelative[2].z), _85, _129);
        float _131 = _130 + (_invViewProjRelative[2].w);
        float _132 = _97 * (_invViewProjRelative[3].x);
        float _133 = mad((_invViewProjRelative[3].y), _99, _132);
        float _134 = mad((_invViewProjRelative[3].z), _85, _133);
        float _135 = _134 + (_invViewProjRelative[3].w);
        float _136 = _123 / _135;
        float _137 = _127 / _135;
        float _138 = _131 / _135;
        float _139 = _136 * _136;
        float _140 = _137 * _137;
        float _141 = _140 + _139;
        float _142 = _138 * _138;
        float _143 = _141 + _142;
        float _144 = sqrt(_143);
        float _145 = 1.0f / _144;
        uint4 _147 = __3__36__0__0__g_baseColor.Load(int3(_55, _57, 0));
        float4 _153 = __3__36__0__0__g_normal.Load(int3(_55, _57, 0));
        int _158 = (uint)((uint)(_147.x)) >> 8;
        int _159 = _158 & 255;
        float _160 = float((uint)_159);
        float _161 = _160 * 0.003921568859368563f;
        half _162 = half(_161);
        int _163 = _147.x & 255;
        float _164 = float((uint)_163);
        float _165 = _164 * 0.003921568859368563f;
        half _166 = half(_165);
        int _167 = (uint)((uint)(_147.y)) >> 8;
        int _168 = _167 & 255;
        float _169 = float((uint)_168);
        float _170 = _169 * 0.003921568859368563f;
        half _171 = half(_170);
        int _172 = _147.y & 255;
        float _173 = float((uint)_172);
        float _174 = _173 * 0.003921568859368563f;
        half _175 = half(_174);
        int _176 = (uint)((uint)(_147.z)) >> 8;
        int _177 = _176 & 255;
        float _178 = float((uint)_177);
        float _179 = _178 * 0.003921568859368563f;
        half _180 = half(_179);
        int _181 = _147.z & 255;
        float _182 = float((uint)_181);
        float _183 = _182 * 0.003921568859368563f;
        half _184 = half(_183);
        int _185 = (uint)((uint)(_147.w)) >> 8;
        int _186 = _185 & 255;
        float _187 = float((uint)_186);
        float _188 = _187 * 0.003921568859368563f;
        half _189 = half(_188);
        int _190 = _147.w & 255;
        float _191 = float((uint)_190);
        float _192 = _191 * 0.003921568859368563f;
        half _193 = half(_192);
        float _194 = _153.w * 3.0f;
        float _195 = _194 + 0.5f;
        uint _196 = uint(_195);
        bool _197 = (_196 == 1);
        bool _198 = (_196 == 3);
        float _199 = _153.x * 1.0009784698486328f;
        float _200 = _153.y * 1.0009784698486328f;
        float _201 = _153.z * 1.0009784698486328f;
        float _202 = saturate(_199);
        float _203 = saturate(_200);
        float _204 = saturate(_201);
        float _205 = _202 * 2.0f;
        float _206 = _203 * 2.0f;
        float _207 = _204 * 2.0f;
        float _208 = _205 + -1.0f;
        float _209 = _206 + -1.0f;
        float _210 = _207 + -1.0f;
        float _211 = dot(float3(_208, _209, _210), float3(_208, _209, _210));
        float _212 = rsqrt(_211);
        float _213 = _212 * _208;
        float _214 = _212 * _209;
        float _215 = _210 * _212;
        half _216 = half(_213);
        half _217 = half(_214);
        half _218 = half(_215);
        half _219 = _189 * 2.0h;
        half _220 = _193 * 2.0h;
        half _221 = _219 + -1.0h;
        half _222 = _220 + -1.0h;
        half _223 = _221 + _222;
        float _224 = float(_223);
        half _225 = _221 - _222;
        float _226 = float(_225);
        float _227 = _224 * 0.5f;
        float _228 = _226 * 0.5f;
        float _229 = abs(_227);
        float _230 = 1.0f - _229;
        float _231 = abs(_228);
        float _232 = _230 - _231;
        float _233 = dot(float3(_227, _228, _232), float3(_227, _228, _232));
        float _234 = rsqrt(_233);
        float _235 = _234 * _227;
        float _236 = _234 * _228;
        float _237 = _234 * _232;
        half _238 = half(_235);
        half _239 = half(_236);
        half _240 = half(_237);
        float _241 = float(_216);
        float _242 = float(_217);
        float _243 = float(_218);
        bool _244 = (_218 >= 0.0h);
        float _245 = select(_244, 1.0f, -1.0f);
        float _246 = _245 + _243;
        float _247 = 1.0f / _246;
        float _248 = -0.0f - _247;
        float _249 = _242 * _248;
        float _250 = _249 * _241;
        float _251 = _245 * _241;
        float _252 = _251 * _241;
        float _253 = _252 * _248;
        float _254 = _253 + 1.0f;
        float _255 = _249 * _242;
        float _256 = _255 + _245;
        float _257 = -0.0f - _242;
        float _258 = float(_238);
        float _259 = float(_239);
        float _260 = float(_240);
        float _261 = _258 * _254;
        float _262 = mad(_259, _250, _261);
        float _263 = mad(_260, _241, _262);
        float _264 = _258 * _245;
        float _265 = _264 * _250;
        float _266 = mad(_259, _256, _265);
        float _267 = mad(_260, _242, _266);
        float _268 = _251 * _258;
        float _269 = -0.0f - _268;
        float _270 = mad(_259, _257, _269);
        float _271 = mad(_260, _243, _270);
        half _272 = half(_263);
        half _273 = half(_267);
        half _274 = half(_271);
        half _275 = dot(half3(_272, _273, _274), half3(_272, _273, _274));
        half _276 = rsqrt(_275);
        half _277 = _276 * _272;
        half _278 = _276 * _273;
        half _279 = _276 * _274;
        half _280 = _162 * _162;
        half _281 = _166 * _166;
        half _282 = _171 * _171;
        half _283 = saturate(_280);
        half _284 = saturate(_281);
        half _285 = saturate(_282);
        half _286 = _283 * 0.61328125h;
        half _287 = _283 * 0.07019043h;
        half _288 = _283 * 0.020614624h;
        half _289 = _284 * 0.3395996h;
        half _290 = _284 * 0.9165039h;
        half _291 = _284 * 0.109558105h;
        half _292 = _289 + _286;
        half _293 = _290 + _287;
        half _294 = _291 + _288;
        half _295 = _285 * 0.04736328h;
        half _296 = _285 * 0.013450623h;
        half _297 = _285 * 0.8696289h;
        half _298 = _292 + _295;
        half _299 = _293 + _296;
        half _300 = _294 + _297;
        half _301 = saturate(_298);
        half _302 = saturate(_299);
        half _303 = saturate(_300);
        half _304 = saturate(_301);
        half _305 = saturate(_302);
        half _306 = saturate(_303);
        half _307 = max(0.020004272h, _180);
        half _308 = saturate(_175);
        bool _309 = ((uint)_82 > (uint)10);
        int _310 = _81 & 126;
        bool __defer_80_342 = false;
        if (_309) {
          bool _312 = ((uint)_82 < (uint)20);
          bool _313 = (_82 == 107);
          bool _314 = (_312) | (_313);
          half _315 = select(_314, 0.0h, _308);
          bool _316 = (_310 == 96);
          bool _317 = (_82 == 98);
          bool _318 = (_316) | (_317);
          int _319 = _82 + -105;
          bool __defer_311_332 = false;
          if (!_318) {
            bool _321 = ((uint)_319 < (uint)2);
            if (_321) {
              if (_197) {
                _333 = 0.0h;
              } else {
                _333 = _315;
              }
              __defer_311_332 = true;
            } else {
              bool _324 = (_82 == 65);
              if (_324) {
                _333 = 0.0h;
                __defer_311_332 = true;
              } else {
                bool _327 = (_82 == 24);
                bool _328 = (_82 == 29);
                bool _329 = (_327) | (_328);
                if (_329) {
                  bool _331 = (_82 == 19);
                  _337 = 0.0h;
                  _338 = _331;
                  bool _339 = (_82 == 28);
                  bool _340 = (_310 == 26);
                  bool _341 = (_340) | (_339);
                  if (!_341) {
                    _343 = _338;
                    _344 = _337;
                    __defer_80_342 = true;
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
            bool _335 = ((uint)_319 < (uint)2);
            if (!_335) {
              _337 = _333;
              _338 = _334;
              bool _339 = (_82 == 28);
              bool _340 = (_310 == 26);
              bool _341 = (_340) | (_339);
              if (!_341) {
                _343 = _338;
                _344 = _337;
                __defer_80_342 = true;
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
          __defer_80_342 = true;
        }
        if (__defer_80_342) {
          bool _345 = (_82 == 107);
          _347 = _343;
          _348 = _344;
          _349 = _345;
        }
        bool _350 = (_82 == 29);
        bool _351 = (_82 == 33);
        bool _352 = (_82 == 55);
        bool _353 = (_351) | (_352);
        int _354 = (int)(uint)(_353);
        bool _355 = (_82 == 65);
        bool _356 = (_310 == 64);
        bool _357 = (_310 == 66);
        bool _358 = (_353) | (_357);
        bool _359 = (_82 == 54);
        bool _360 = (_359) | (_356);
        bool _361 = (_360) | (_358);
        if (_361) {
          float4 _364 = __3__36__0__0__g_character.Load(int3(_55, _57, 0));
          float _368 = saturate(_364.x);
          float _369 = saturate(_364.y);
          float _370 = saturate(_364.z);
          half _371 = half(_368);
          half _372 = half(_369);
          half _373 = half(_370);
          _375 = _371;
          _376 = _372;
          _377 = _373;
        } else {
          _375 = 0.0h;
          _376 = 0.0h;
          _377 = 0.0h;
        }
        half _378 = _375 * 2.0h;
        half _379 = _376 * 2.0h;
        half _380 = _377 * 2.0h;
        half _381 = _378 + -1.0h;
        half _382 = _379 + -1.0h;
        half _383 = _380 + -1.0h;
        half _384 = dot(half3(_381, _382, _383), half3(_381, _382, _383));
        half _385 = rsqrt(_384);
        half _386 = _385 * _381;
        half _387 = _385 * _382;
        half _388 = _383 * _385;
        float _389 = float(_386);
        float _390 = float(_387);
        float _391 = float(_388);
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
            bool _403 = (_377 < 0.0010004044h);
            if (_403) {
              _406 = 53;
              bool _407 = (_406 == 55);
              int _408 = (int)(uint)(_407);
              _430 = _406;
              _431 = _408;
              _432 = 0.0f;
              _433 = 0.0f;
              _434 = 0.0f;
            } else {
              __defer_401_409 = true;
            }
          } else {
            if (!_351) {
              _406 = _82;
              bool _407 = (_406 == 55);
              int _408 = (int)(uint)(_407);
              _430 = _406;
              _431 = _408;
              _432 = 0.0f;
              _433 = 0.0f;
              _434 = 0.0f;
            } else {
              __defer_401_409 = true;
            }
          }
          if (__defer_401_409) {
            float _410 = float(_375);
            float _413 = _clothLightingCategory.x * _410;
            float _414 = _413 + 0.5f;
            uint _415 = uint(_414);
            bool _416 = (_377 > 0.0h);
            uint _417 = uint(_clothLightingCategory.x);
            bool _418 = ((uint)_415 < (uint)_417);
            bool _419 = (_416) & (_418);
            if (_419) {
              float _421 = float(_376);
              uint _422 = _415 + 1u;
              float4 _423 = _clothLightingParameter[_415];
              float _426 = saturate(_421);
              float _427 = 1.0f - _423.y;
              float _428 = min(_427, _423.x);
              _430 = _82;
              _431 = 1;
              _432 = _428;
              _433 = _426;
              _434 = _423.x;
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
          _431 = _354;
          _432 = 0.0f;
          _433 = 0.0f;
          _434 = 0.0f;
        }
        float _435 = float(_348);
        bool _436 = (_430 == 66);
        bool __defer_429_470 = false;
        if (!_436) {
          bool _438 = (_430 == 67);
          bool _439 = (_430 == 54);
          bool _440 = (_438) | (_439);
          bool __defer_437_465 = false;
          if (_440) {
            uint _444 = _frameNumber.x * 73;
            int _445 = _444 & 127;
            float _446 = float((uint)_445);
            float _447 = _446 * 32.665000915527344f;
            float _448 = _446 * 11.8149995803833f;
            float _449 = _447 + _87;
            float _450 = _448 + _88;
            float _451 = dot(float2(_449, _450), float2(0.0671105608344078f, 0.005837149918079376f));
            float _452 = frac(_451);
            float _453 = _452 * 52.98291778564453f;
            float _454 = frac(_453);
            float _455 = _454 * 0.20000000298023224f;
            bool _456 = (_435 > _455);
            if (_456) {
              _458 = 1.0f;
              _459 = 53;
              _460 = 0.0f;
              half _461 = half(_460);
              _466 = _458;
              _467 = _459;
              _468 = _461;
              __defer_437_465 = true;
            } else {
              int _463 = _430 & -2;
              bool _464 = (_463 == 66);
              bool __branch_chain_462;
              if (_464) {
                _471 = 1.0f;
                _472 = _430;
                _473 = 0.0h;
                __branch_chain_462 = true;
              } else {
                _466 = 1.0f;
                _467 = _430;
                _468 = 0.0h;
                bool _469 = (_467 == 54);
                if (_469) {
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
            half _461 = half(_460);
            _466 = _458;
            _467 = _459;
            _468 = _461;
            __defer_437_465 = true;
          }
          if (__defer_437_465) {
            bool _469 = (_467 == 54);
            if (_469) {
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
        } else {
          _471 = _435;
          _472 = 66;
          _473 = 0.0h;
          __defer_429_470 = true;
        }
        if (__defer_429_470) {
          float _474 = _391 * _242;
          float _475 = _390 * _243;
          float _476 = _474 - _475;
          float _477 = _389 * _243;
          float _478 = _391 * _241;
          float _479 = _477 - _478;
          float _480 = _390 * _241;
          float _481 = _389 * _242;
          float _482 = _480 - _481;
          float _483 = dot(float3(_136, _137, _138), float3(_476, _479, _482));
          float _484 = _483 * 2.0f;
          float _485 = dot(float3(_136, _137, _138), float3(_389, _390, _391));
          float _486 = _485 * 0.5f;
          float _487 = _144 * 2.0f;
          float _488 = _487 + 1.0f;
          float _489 = _484 / _488;
          float _490 = _486 / _488;
          float _491 = _471 * 7.0f;
          float _492 = _491 + 1.0f;
          float _493 = _489 * _492;
          float _494 = _490 * _492;
          float4 _497 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(_493, _494), 0.0f);
          float _501 = _471 * 0.5f;
          float _502 = _497.x * 2.0f;
          float _503 = _497.y * 2.0f;
          float _504 = _497.z * 2.0f;
          float _505 = 1.0f - _502;
          float _506 = 1.0f - _503;
          float _507 = 1.0f - _504;
          float _508 = _505 * _501;
          float _509 = _506 * _501;
          float _510 = _507 * _501;
          float _511 = _508 + _502;
          float _512 = _509 + _503;
          float _513 = _510 + _504;
          bool _514 = (_472 == 54);
          if (_514) {
            float _518 = float(_307);
            float _519 = float(_184);
            float _522 = asfloat(_globalLightParams.z);
            float _523 = _522 * _518;
            float _524 = _523 + _bevelParams.y;
            float _526 = asfloat(_globalLightParams.w);
            float _527 = _526 * _519;
            float _528 = _524 + _527;
            _530 = _471;
            _531 = 54;
            _532 = _473;
            _533 = _511;
            _534 = _512;
            _535 = _513;
            _536 = _528;
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
        half _537 = select(_355, _216, _277);
        half _538 = select(_355, _217, _278);
        half _539 = select(_355, _218, _279);
        float _540 = float(_537);
        float _541 = float(_538);
        float _542 = float(_539);
        bool _543 = (_531 == 53);
        if (_543) {
          half _545 = _305 + _304;
          half _546 = _545 + _306;
          half _547 = _546 * 1.2001953h;
          half _548 = saturate(_547);
          _550 = _548;
        } else {
          _550 = 1.0h;
        }
        half _551 = max(_304, _305);
        half _552 = max(_551, _306);
        half _553 = max(_552, 0.010002136h);
        half _554 = min(_553, 0.7001953h);
        half _555 = 0.7001953h / _554;
        half _556 = _555 * _550;
        half _557 = _556 * _304;
        half _558 = _556 * _305;
        half _559 = _556 * _306;
        half _560 = _557 + -0.040008545h;
        half _561 = _558 + -0.040008545h;
        half _562 = _559 + -0.040008545h;
        half _563 = _560 * _532;
        half _564 = _561 * _532;
        half _565 = _562 * _532;
        half _566 = _563 + 0.040008545h;
        half _567 = _564 + 0.040008545h;
        half _568 = _565 + 0.040008545h;
        float _569 = float(_566);
        float _570 = float(_567);
        float _571 = float(_568);
        float _572 = float(_277);
        float _573 = float(_278);
        float _574 = float(_279);
        if (_393) {
          bool _576 = (_347) | (_349);
          bool _577 = (_350) | (_576);
          float _578 = select(_577, 0.0f, 1.0f);
          half _579 = dot(half3(_216, _217, _218), half3(_216, _217, _218));
          half _580 = rsqrt(_579);
          half _581 = _580 * _217;
          half _582 = saturate(_581);
          float _583 = float(_582);
          float _584 = _583 * _583;
          float _585 = _584 * _584;
          float _586 = _585 * _585;
          float _587 = _400 * _578;
          float _588 = _586 * _586;
          float _589 = _588 * _587;
          float _590 = 1.0f - _573;
          float _591 = _589 * _572;
          float _592 = _589 * _590;
          float _593 = _589 * _574;
          float _594 = _572 - _591;
          float _595 = _592 + _573;
          float _596 = _574 - _593;
          float _597 = dot(float3(_594, _595, _596), float3(_594, _595, _596));
          float _598 = rsqrt(_597);
          float _599 = _594 * _598;
          float _600 = _595 * _598;
          float _601 = _596 * _598;
          _603 = _599;
          _604 = _600;
          _605 = _601;
        } else {
          _603 = _572;
          _604 = _573;
          _605 = _574;
        }
        float _606 = float(_307);
        float _607 = _606 * _606;
        float _608 = _607 * _607;
        half _609 = _307 * 0.60009766h;
        float _610 = float(_609);
        float _611 = _610 * _610;
        float _612 = _611 * _611;
        uint2 _614 = __3__36__0__0__g_manyLightsHitData.Load(int3(_55, _57, 0));
        int _617 = (uint)((uint)(_614.x)) >> 16;
        int _618 = _617 & 32767;
        int _619 = _614.x | _614.y;
        bool _620 = (_619 != 0);
        int _621 = _614.x & 65535;
        float _622 = float((uint)_621);
        float _623 = _622 * 0.015609979629516602f;
        int _624 = select(_620, _618, 32767);
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
        bool _641 = (_623 >= 1000.0f);
        float _642 = float((bool)_641);
        float _643 = _627 - _136;
        float _644 = _628 - _137;
        float _645 = _629 - _138;
        float _646 = _643 * _643;
        float _647 = _644 * _644;
        float _648 = _646 + _647;
        float _649 = _645 * _645;
        float _650 = _648 + _649;
        float _651 = sqrt(_650);
        float _652 = 1.0f / _651;
        float _653 = _652 * _643;
        float _654 = _652 * _644;
        float _655 = _652 * _645;
        int _656 = _636 & 65535;
        int _657 = (uint)(_636) >> 16;
        int _658 = _637 & 65535;
        int _659 = (uint)(_637) >> 16;
        float _660 = f16tof32(_656);
        float _661 = f16tof32(_657);
        float _662 = f16tof32(_658);
        float _663 = f16tof32(_659);
        float _664 = dot(float3(_660, _661, _662), float3(_660, _661, _662));
        float _665 = rsqrt(_664);
        int _666 = _639 & 65535;
        int _667 = (uint)(_639) >> 16;
        int _668 = _640 & 65535;
        float _669 = f16tof32(_666);
        float _670 = f16tof32(_667);
        float _671 = f16tof32(_668);
        float _672 = dot(float3(_669, _670, _671), float3(_669, _670, _671));
        float _673 = rsqrt(_672);
        float _674 = _673 * _669;
        float _675 = _673 * _670;
        float _676 = _673 * _671;
        bool _677 = !(_663 >= 0.0f);
        if (!_677) {
          int _679 = (uint)(_640) >> 16;
          float _680 = f16tof32(_679);
          float _681 = _665 * _662;
          float _682 = _665 * _661;
          float _683 = _653 * _660;
          float _684 = _683 * _665;
          float _685 = mad(_654, _682, _684);
          float _686 = mad(_655, _681, _685);
          float _687 = _674 * _653;
          float _688 = mad(_654, _675, _687);
          float _689 = mad(_655, _676, _688);
          float _690 = dot(float3(_653, _654, _655), float3(_674, _675, _676));
          float _691 = asin(_690);
          float _692 = _691 * 0.31830987334251404f;
          float _693 = _692 + 0.5f;
          float _694 = -0.0f - _686;
          float _695 = -0.0f - _689;
          float _696 = _695 / _694;
          float _697 = atan(_696);
          float _698 = _697 + 3.1415927410125732f;
          float _699 = _697 + -3.1415927410125732f;
          bool _700 = (_686 > -0.0f);
          bool _701 = (_686 == -0.0f);
          bool _702 = (_689 <= -0.0f);
          bool _703 = (_689 > -0.0f);
          bool _704 = (_700) & (_702);
          float _705 = select(_704, _698, _697);
          bool _706 = (_700) & (_703);
          float _707 = select(_706, _699, _705);
          bool _708 = (_701) & (_703);
          bool _709 = (_701) & (_702);
          float _710 = _707 * 0.31830987334251404f;
          float _711 = select(_708, -0.5f, _710);
          float _712 = select(_709, 0.5f, _711);
          float _713 = abs(_712);
          float _714 = saturate(_713);
          float _715 = _714 * _680;
          float _716 = _715 + _663;
          float _719 = __3__36__0__0__g_lightProfile.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_693, _716), 0.0f);
          float _721 = _719.x * _631;
          float _722 = _719.x * _632;
          float _723 = _719.x * _633;
          _725 = _721;
          _726 = _722;
          _727 = _723;
        } else {
          _725 = _631;
          _726 = _632;
          _727 = _633;
        }
        float _728 = abs(_634);
        float _729 = _651 * _651;
        float _730 = _728 * _728;
        float _731 = max(_730, _729);
        bool _732 = (_728 > 99999.0f);
        float _733 = 1.0f / _731;
        float _734 = select(_732, 1.0f, _733);
        float _735 = saturate(_734);
        float _736 = asfloat(_614.y);
        float _737 = _145 * _136;
        float _738 = _145 * _137;
        float _739 = _145 * _138;
        float _740 = _653 * _651;
        float _741 = _654 * _651;
        float _742 = _655 * _651;
        float _743 = -0.0f - _737;
        float _744 = -0.0f - _738;
        float _745 = -0.0f - _739;
        float _746 = dot(float3(_743, _744, _745), float3(_540, _541, _542));
        float _747 = _746 * 2.0f;
        float _748 = _747 * _540;
        float _749 = _747 * _541;
        float _750 = _747 * _542;
        float _751 = _743 - _748;
        float _752 = _744 - _749;
        float _753 = _745 - _750;
        float _754 = dot(float3(_740, _741, _742), float3(_751, _752, _753));
        float _755 = _751 * _754;
        float _756 = _752 * _754;
        float _757 = _753 * _754;
        float _758 = _755 - _740;
        float _759 = _756 - _741;
        float _760 = _757 - _742;
        float _761 = _758 * _758;
        float _762 = _759 * _759;
        float _763 = _761 + _762;
        float _764 = _760 * _760;
        float _765 = _763 + _764;
        float _766 = sqrt(_765);
        float _767 = _728 / _766;
        float _768 = saturate(_767);
        float _769 = _758 * _768;
        float _770 = _759 * _768;
        float _771 = _760 * _768;
        float _772 = _769 + _740;
        float _773 = _770 + _741;
        float _774 = _771 + _742;
        float _775 = dot(float3(_772, _773, _774), float3(_772, _773, _774));
        float _776 = rsqrt(_775);
        float _777 = _772 * _776;
        float _778 = _773 * _776;
        float _779 = _774 * _776;
        float _780 = _777 - _737;
        float _781 = _778 - _738;
        float _782 = _779 - _739;
        float _783 = dot(float3(_780, _781, _782), float3(_780, _781, _782));
        float _784 = rsqrt(_783);
        float _785 = _780 * _784;
        float _786 = _781 * _784;
        float _787 = _782 * _784;
        float _788 = dot(float3(_540, _541, _542), float3(_777, _778, _779));
        float _789 = dot(float3(_603, _604, _605), float3(_777, _778, _779));
        float _790 = dot(float3(_540, _541, _542), float3(_743, _744, _745));
        float _791 = saturate(_790);
        float _792 = dot(float3(_603, _604, _605), float3(_785, _786, _787));
        float _793 = saturate(_792);
        float _794 = dot(float3(_743, _744, _745), float3(_785, _786, _787));
        int _795 = _531 & -2;
        bool _796 = (_795 == 66);
        bool _797 = (_531 == 54);
        bool _798 = (_797) | (_796);
        if (_798) {
          float _800 = float(_304);
          float _801 = float(_305);
          float _802 = float(_306);
          float _803 = dot(float3(_743, _744, _745), float3(_777, _778, _779));
          float _804 = dot(float3(_389, _390, _391), float3(_777, _778, _779));
          float _805 = dot(float3(_389, _390, _391), float3(_743, _744, _745));
          float _806 = asin(_805);
          float _807 = asin(_804);
          float _808 = _806 - _807;
          float _809 = abs(_808);
          float _810 = _809 * 0.5f;
          float _811 = cos(_810);
          float _812 = _804 * _389;
          float _813 = _804 * _390;
          float _814 = _804 * _391;
          float _815 = _777 - _812;
          float _816 = _778 - _813;
          float _817 = _779 - _814;
          float _818 = _805 * _389;
          float _819 = _805 * _390;
          float _820 = _805 * _391;
          float _821 = _743 - _818;
          float _822 = _744 - _819;
          float _823 = _745 - _820;
          float _824 = dot(float3(_815, _816, _817), float3(_821, _822, _823));
          float _825 = dot(float3(_815, _816, _817), float3(_815, _816, _817));
          float _826 = dot(float3(_821, _822, _823), float3(_821, _822, _823));
          float _827 = _826 * _825;
          float _828 = _827 + 9.999999747378752e-05f;
          float _829 = rsqrt(_828);
          float _830 = _829 * _824;
          float _831 = _830 * 0.5f;
          float _832 = _831 + 0.5f;
          float _833 = saturate(_832);
          float _834 = sqrt(_833);
          float _835 = 1.190000057220459f / _811;
          float _836 = _811 * 0.36000001430511475f;
          float _837 = _835 + _836;
          float _838 = _536 * 2.0f;
          float _839 = _536 * 4.0f;
          float _840 = max(_606, 0.09803921729326248f);
          float _841 = min(_840, 1.0f);
          float _842 = _841 * _841;
          float _843 = _842 * 0.5f;
          float _844 = _842 * 2.0f;
          float _845 = _805 + _804;
          float _846 = _845 + _838;
          float _847 = _834 * 1.4142135381698608f;
          float _848 = _847 * _842;
          float _849 = _846 * _846;
          float _850 = _849 * -0.5f;
          float _851 = _848 * _848;
          float _852 = _850 / _851;
          float _853 = _852 * 1.4426950216293335f;
          float _854 = exp2(_853);
          float _855 = _848 * 2.5066282749176025f;
          float _856 = _854 / _855;
          float _857 = _834 * 0.25f;
          float _858 = _803 * 0.5f;
          float _859 = _858 + 0.5f;
          float _860 = saturate(_859);
          float _861 = sqrt(_860);
          float _862 = 1.0f - _861;
          float _863 = _862 * _862;
          float _864 = _862 * 0.9534794092178345f;
          float _865 = _863 * _863;
          float _866 = _865 * _864;
          float _867 = _866 + 0.04652056470513344f;
          float _868 = _857 * _856;
          float _869 = _868 * _867;
          float _870 = _845 - _536;
          float _871 = _870 * _870;
          float _872 = _871 * -0.5f;
          float _873 = _843 * _843;
          float _874 = _872 / _873;
          float _875 = _874 * 1.4426950216293335f;
          float _876 = exp2(_875);
          float _877 = _842 * 1.2533141374588013f;
          float _878 = _876 / _877;
          float _879 = 1.0f / _837;
          float _880 = _830 * 0.800000011920929f;
          float _881 = 0.6000000238418579f - _880;
          float _882 = _879 * _881;
          float _883 = _882 + 1.0f;
          float _884 = _883 * _834;
          float _885 = _884 * _884;
          float _886 = 1.0f - _885;
          float _887 = saturate(_886);
          float _888 = sqrt(_887);
          float _889 = _888 * _811;
          float _890 = 1.0f - _889;
          float _891 = _890 * _890;
          float _892 = _890 * 0.9534794092178345f;
          float _893 = _891 * _891;
          float _894 = _893 * _892;
          float _895 = 0.9534794092178345f - _894;
          float _896 = _879 * _884;
          float _897 = _896 * _896;
          float _898 = 1.0f - _897;
          float _899 = sqrt(_898);
          float _900 = _899 * 0.5f;
          float _901 = _900 / _811;
          float _902 = log2(_800);
          float _903 = log2(_801);
          float _904 = log2(_802);
          float _905 = _902 * _901;
          float _906 = _903 * _901;
          float _907 = _904 * _901;
          float _908 = exp2(_905);
          float _909 = exp2(_906);
          float _910 = exp2(_907);
          float _911 = _830 * 5.2658371925354f;
          float _912 = -5.741926193237305f - _911;
          float _913 = exp2(_912);
          float _914 = _895 * _895;
          float _915 = _914 * _878;
          float _916 = _915 * _913;
          float _917 = _916 * _908;
          float _918 = _916 * _909;
          float _919 = _916 * _910;
          float _920 = _845 - _839;
          float _921 = _920 * _920;
          float _922 = _921 * -0.5f;
          float _923 = _844 * _844;
          float _924 = _922 / _923;
          float _925 = _924 * 1.4426950216293335f;
          float _926 = exp2(_925);
          float _927 = _842 * 5.013256549835205f;
          float _928 = _926 / _927;
          float _929 = _811 * 0.5f;
          float _930 = 1.0f - _929;
          float _931 = _930 * _930;
          float _932 = _811 * 0.47673970460891724f;
          float _933 = 0.9534794092178345f - _932;
          float _934 = _931 * _931;
          float _935 = _934 * _933;
          float _936 = _935 + 0.04652056470513344f;
          float _937 = 0.9534794092178345f - _935;
          float _938 = 0.800000011920929f / _811;
          float _939 = _938 * _902;
          float _940 = _938 * _903;
          float _941 = _938 * _904;
          float _942 = exp2(_939);
          float _943 = exp2(_940);
          float _944 = exp2(_941);
          float _945 = _830 * 24.525815963745117f;
          float _946 = _945 + -24.208423614501953f;
          float _947 = exp2(_946);
          float _948 = _937 * _937;
          float _949 = _948 * _936;
          float _950 = _949 * _928;
          float _951 = _950 * _947;
          float _952 = _951 * _942;
          float _953 = _951 * _943;
          float _954 = _951 * _944;
          float _955 = _952 + _917;
          float _956 = _953 + _918;
          float _957 = _954 + _919;
          float _958 = saturate(_789);
          float _959 = _869 * _958;
          float _960 = _533 * _959;
          float _961 = -0.0f - _960;
          float _962 = _534 * _959;
          float _963 = -0.0f - _962;
          float _964 = _535 * _959;
          float _965 = -0.0f - _964;
          float _966 = min(0.0f, _961);
          float _967 = min(0.0f, _963);
          float _968 = min(0.0f, _965);
          float _969 = -0.0f - _966;
          float _970 = -0.0f - _967;
          float _971 = -0.0f - _968;
          float _972 = -0.0f - _958;
          float _973 = _955 * _972;
          float _974 = _956 * _972;
          float _975 = _957 * _972;
          float _976 = min(0.0f, _973);
          float _977 = min(0.0f, _974);
          float _978 = min(0.0f, _975);
          float _979 = abs(_789);
          float _980 = 1.0f - _979;
          float _981 = _789 + 1.0f;
          float _982 = _981 * 0.25f;
          float _983 = saturate(_982);
          float _984 = _980 - _983;
          float _985 = _984 * 0.33000001311302185f;
          float _986 = _985 + _983;
          float _987 = dot(float3(_800, _801, _802), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
          float _988 = max(0.0010000000474974513f, _987);
          float _989 = 1.0f - _642;
          float _990 = _800 / _988;
          float _991 = _801 / _988;
          float _992 = _802 / _988;
          float _993 = log2(_990);
          float _994 = log2(_991);
          float _995 = log2(_992);
          float _996 = _993 * _989;
          float _997 = _994 * _989;
          float _998 = _995 * _989;
          float _999 = exp2(_996);
          float _1000 = exp2(_997);
          float _1001 = exp2(_998);
          float _1002 = sqrt(_800);
          float _1003 = sqrt(_801);
          float _1004 = sqrt(_802);
          float _1005 = _986 * 0.039788734167814255f;
          float _1006 = _999 * _1005;
          float _1007 = _1006 * _1002;
          float _1008 = _1000 * _1005;
          float _1009 = _1008 * _1003;
          float _1010 = _1001 * _1005;
          float _1011 = _1010 * _1004;
          float _1012 = _1007 - _976;
          float _1013 = _1009 - _977;
          float _1014 = _1011 - _978;
          _1245 = _1012;
          _1246 = _1013;
          _1247 = _1014;
          _1248 = _969;
          _1249 = _970;
          _1250 = _971;
          _1251 = 0.0f;
        } else {
          bool _1016 = (_431 == 0);
          if (!_1016) {
            float _1018 = float(_304);
            float _1019 = float(_305);
            float _1020 = float(_306);
            float _1023 = 1.0f - _effectiveMetallicForVelvet;
            float _1024 = saturate(_1023);
            float _1025 = _1024 + -1.0f;
            float _1026 = _1025 * _434;
            float _1027 = _1026 + 1.0f;
            float _1028 = saturate(_788);
            float _1029;
            if (DIFFUSE_BRDF_MODE >= 2.0f) {
              float _eon_LdotV2 = dot(float3(_777, _778, _779), float3(_743, _744, _745));
              _1029 = _1028 * EON_DiffuseScalar(_1028, _791, _eon_LdotV2, _606);
            } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
              _1029 = _1028 * HammonDiffuseScalar(_1028, _791, _793, _794, _606);
            } else {
              _1029 = _1028 * 0.31830987334251404f;
            }
            float _1030 = _1029 * _1027;
            float _1031 = log2(_791);
            float _1032 = _1031 * 4.0f;
            float _1033 = exp2(_1032);
            float _1034 = 1.0f - _1033;
            float _1035 = dot(float3(_1018, _1019, _1020), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
            float _1036 = max(_1035, 0.03999999910593033f);
            float _1037 = sqrt(_1018);
            float _1038 = sqrt(_1019);
            float _1039 = sqrt(_1020);
            float _1040 = _1037 - _1036;
            float _1041 = _1038 - _1036;
            float _1042 = _1039 - _1036;
            float _1043 = _1040 * _432;
            float _1044 = _1041 * _432;
            float _1045 = _1042 * _432;
            float _1046 = _1043 + _1036;
            float _1047 = _1044 + _1036;
            float _1048 = _1045 + _1036;
            float _1049 = saturate(_1034);
            float _1050 = _434 - _432;
            float _1051 = _1040 * _1050;
            float _1052 = _434 - _432;
            float _1053 = _1041 * _1052;
            float _1054 = _434 - _432;
            float _1055 = _1042 * _1054;
            float _1056 = _1049 * _1051;
            float _1057 = _1053 * _1049;
            float _1058 = _1055 * _1049;
            float _1059 = _1046 + _1056;
            float _1060 = _1047 + _1057;
            float _1061 = _1048 + _1058;
            float _1062 = _1060 * _433;
            float _1063 = saturate(_794);
            float _1064 = 1.0f - _1063;
            float _1065 = saturate(_1064);
            float _1066 = _1065 * _1065;
            float _1067 = _1066 * _1066;
            float _1068 = _1067 * _1065;
            float _1069 = _1062 * 50.0f;
            float _1070 = saturate(_1069);
            float _1071 = _1068 * _1070;
            float _1072 = 1.0f - _1068;
            float _1073 = _1072 * _433;
            float _1074 = _1073 * _1059;
            float _1075 = _1072 * _1062;
            float _1076 = _1073 * _1061;
            float _1077 = _1074 + _1071;
            float _1078 = _1075 + _1071;
            float _1079 = _1076 + _1071;
            float _1080 = min(_793, 0.9998999834060669f);
            float _1081 = _1080 * _1080;
            float _1082 = 1.0f - _1081;
            float _1083 = -0.0f - _1081;
            float _1084 = _1082 * _608;
            float _1085 = _1083 / _1084;
            float _1086 = _1085 * 1.4426950216293335f;
            float _1087 = exp2(_1086);
            float _1088 = _1087 * 4.0f;
            float _1089 = _1082 * _1082;
            float _1090 = _1088 / _1089;
            float _1091 = _1090 + 1.0f;
            float _1092 = _608 * 12.566370964050293f;
            float _1093 = _1092 + 3.1415927410125732f;
            float _1094 = _1091 / _1093;
            float _1095 = _791 + _789;
            float _1096 = _791 * _789;
            float _1097 = _1095 - _1096;
            float _1098 = _1097 * 4.0f;
            float _1099 = _1077 * _1094;
            float _1100 = _1078 * _1094;
            float _1101 = _1079 * _1094;
            float _1102 = _1099 / _1098;
            float _1103 = _1100 / _1098;
            float _1104 = _1101 / _1098;
            float _1105 = 1.0f - _607;
            float _1106 = _791 * _1105;
            float _1107 = _1106 + _607;
            float _1108 = _1107 * _788;
            float _1109 = _788 * _1105;
            float _1110 = _1109 + _607;
            float _1111 = _791 * _1110;
            float _1112 = _1108 + _1111;
            float _1113 = 0.5f / _1112;
            float _1114 = _793 * _608;
            float _1115 = _1114 - _793;
            float _1116 = _1115 * _793;
            float _1117 = _1116 + 1.0f;
            float _1118 = _1117 * _1117;
            float _1119 = _1118 * 3.1415927410125732f;
            float _1120 = _608 / _1119;
            float _1121 = _1120 * _1113;
            float _1122 = _1121 * _1077;
            float _1123 = _1121 * _1078;
            float _1124 = _1121 * _1079;
            float _1125 = max(_1122, 0.0f);
            float _1126 = max(_1123, 0.0f);
            float _1127 = max(_1124, 0.0f);
            float _1128 = _1125 - _1102;
            float _1129 = _1126 - _1103;
            float _1130 = _1127 - _1104;
            float _1131 = _1128 * _432;
            float _1132 = _1129 * _432;
            float _1133 = _1130 * _432;
            float _1134 = _1131 + _1102;
            float _1135 = _1132 + _1103;
            float _1136 = _1133 + _1104;
            float _1137 = saturate(_789);
            float _1138 = _1134 * _1137;
            float _1139 = _1135 * _1137;
            float _1140 = _1136 * _1137;
            _1245 = 0.0f;
            _1246 = 0.0f;
            _1247 = 0.0f;
            _1248 = _1138;
            _1249 = _1139;
            _1250 = _1140;
            _1251 = _1030;
          } else {
            bool _1142 = !(_788 <= 0.0f);
            if (_1142) {
              float _1144 = 1.0f - _794;
              float _1145 = saturate(_1144);
              float _1146 = _1145 * _1145;
              float _1147 = _1146 * _1146;
              float _1148 = _1147 * _1145;
              float _1149 = _570 * 50.0f;
              float _1150 = saturate(_1149);
              float _1151 = _1148 * _1150;
              float _1152 = 1.0f - _1148;
              float _1153 = _1152 * _569;
              float _1154 = _1152 * _570;
              float _1155 = _1152 * _571;
              float _1156 = _1153 + _1151;
              float _1157 = _1154 + _1151;
              float _1158 = _1155 + _1151;
              float _1159;
              if (DIFFUSE_BRDF_MODE >= 2.0f) {
                float _sNdotL = saturate(_788);
                float _eon_LdotV = dot(float3(_777, _778, _779), float3(_743, _744, _745));
                _1159 = _sNdotL * EON_DiffuseScalar(_sNdotL, _791, _eon_LdotV, _606);
              } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
                float _sNdotL = saturate(_788);
                _1159 = _sNdotL * HammonDiffuseScalar(_sNdotL, _791, _793, _794, _606);
              } else {
                _1159 = _788 * 0.31830987334251404f;
              }
              float _1160 = saturate(_789);
              float _1161 = 1.0f - _607;
              float _1162 = _791 * _1161;
              float _1163 = _1162 + _607;
              float _1164 = _1163 * _789;
              float _1165 = _789 * _1161;
              float _1166 = _1165 + _607;
              float _1167 = _791 * _1166;
              float _1168 = _1164 + _1167;
              float _1169 = 0.5f / _1168;
              float _1170 = _793 * _608;
              float _1171 = _1170 - _793;
              float _1172 = _1171 * _793;
              float _1173 = _1172 + 1.0f;
              float _1174 = _1173 * _1173;
              float _1175 = _1174 * 3.1415927410125732f;
              float _1176 = _608 / _1175;
              float _1177 = _1176 * _1169;
              float _1178 = _1156 * _1177;
              float _1179 = _1157 * _1177;
              float _1180 = _1158 * _1177;
              float _1181 = max(_1178, 0.0f);
              float _1182 = max(_1179, 0.0f);
              float _1183 = max(_1180, 0.0f);
              float _1184 = _1181 * _1160;
              float _1185 = _1182 * _1160;
              float _1186 = _1183 * _1160;
              _1188 = _1184;
              _1189 = _1185;
              _1190 = _1186;
              _1191 = _1159;
            } else {
              _1188 = 0.0f;
              _1189 = 0.0f;
              _1190 = 0.0f;
              _1191 = 0.0f;
            }
            bool _1192 = (_531 != 65);
            bool _1193 = (_356) & (_1192);
            if (_1193) {
              float _1195 = _1188 * 0.60009765625f;
              float _1196 = _1189 * 0.60009765625f;
              float _1197 = _1190 * 0.60009765625f;
              float _1198 = 1.0f - _794;
              float _1199 = saturate(_1198);
              float _1200 = _1199 * _1199;
              float _1201 = _1200 * _1200;
              float _1202 = _1201 * _1199;
              float _1203 = _570 * 50.0f;
              float _1204 = saturate(_1203);
              float _1205 = _1202 * _1204;
              float _1206 = 1.0f - _1202;
              float _1207 = _1206 * _569;
              float _1208 = _1206 * _570;
              float _1209 = _1206 * _571;
              float _1210 = _1207 + _1205;
              float _1211 = _1208 + _1205;
              float _1212 = _1209 + _1205;
              float _1213 = saturate(_789);
              float _1214 = 1.0f - _611;
              float _1215 = _791 * _1214;
              float _1216 = _1215 + _611;
              float _1217 = _1216 * _789;
              float _1218 = _789 * _1214;
              float _1219 = _1218 + _611;
              float _1220 = _791 * _1219;
              float _1221 = _1217 + _1220;
              float _1222 = 0.5f / _1221;
              float _1223 = _793 * _612;
              float _1224 = _1223 - _793;
              float _1225 = _1224 * _793;
              float _1226 = _1225 + 1.0f;
              float _1227 = _1226 * _1226;
              float _1228 = _1227 * 3.1415927410125732f;
              float _1229 = _612 / _1228;
              float _1230 = _1229 * _1222;
              float _1231 = _1210 * _1230;
              float _1232 = _1211 * _1230;
              float _1233 = _1212 * _1230;
              float _1234 = max(_1231, 0.0f);
              float _1235 = max(_1232, 0.0f);
              float _1236 = max(_1233, 0.0f);
              float _1237 = _1213 * 0.39990234375f;
              float _1238 = _1234 * _1237;
              float _1239 = _1235 * _1237;
              float _1240 = _1236 * _1237;
              float _1241 = _1238 + _1195;
              float _1242 = _1239 + _1196;
              float _1243 = _1240 + _1197;
              _1245 = 0.0f;
              _1246 = 0.0f;
              _1247 = 0.0f;
              _1248 = _1241;
              _1249 = _1242;
              _1250 = _1243;
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
          }
        }
        // RenoDX: Diffraction on Rough Surfaces
        if (DIFFRACTION > 0.0f && float(_532) > 0.0f) {
          float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
            _793, _791, _606,
            float2(_94, _95), _86,
            float3(_785, _786, _787),
            float3(_603, _604, _605),
            float3(_569, _570, _571)
          );
          float3 _rndx_dMod = lerp(float3(1.0f, 1.0f, 1.0f), _rndx_dShift, DIFFRACTION * float(_532));
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
        float _1252 = _642 * _736;
        float _1253 = _735 * _1252;
        float _1254 = _1253 * _725;
        float _1255 = _1253 * _726;
        float _1256 = _1253 * _727;
        float _1257 = _1251 + _1245;
        float _1258 = _1251 + _1246;
        float _1259 = _1251 + _1247;
        float _1260 = _1248 * _1254;
        float _1261 = _1249 * _1255;
        float _1262 = _1250 * _1256;
        float _1263 = select(_798, _389, 0.0f);
        float _1264 = select(_798, _390, 1.0f);
        float _1265 = select(_798, _391, 0.0f);
        float _1266 = float(_180);
        bool _1267 = (_795 == 64);
        int _1268 = (int)(uint)(_198);
        int _1269 = _1268 ^ 1;
        int _1270 = (int)(uint)(_1267);
        int _1271 = _1270 & _1269;
        bool _1272 = (_1271 == 0);
        if (!_1272) {
          float _1274 = float(_376);
          float _1275 = select(_198, 0.0f, _1274);
          bool _1278 = (_cavityParams.z > 0.0f);
          float _1279 = select(_1278, _1275, 1.0f);
          _1287 = _1279;
        } else {
          float _1281 = _86 * -0.005770780146121979f;
          float _1282 = _1266 * _1266;
          float _1283 = _1282 * _1281;
          float _1284 = exp2(_1283);
          float _1285 = saturate(_1284);
          _1287 = _1285;
        }
        bool _1290 = (_cavityParams.x == 0.0f);
        float _1291 = select(_1290, 1.0f, _1287);
        float _1292 = float(_532);
        float _1293 = select(_798, 0.0f, _1292);
        float _1294 = float(_304);
        float _1295 = float(_305);
        float _1296 = float(_306);
        float _1297 = dot(float3(_743, _744, _745), float3(_603, _604, _605));
        float _1298 = saturate(_1297);
        float _1299 = max(_1294, _1295);
        float _1300 = max(_1299, _1296);
        float _1301 = max(_1300, 0.009999999776482582f);
        float _1302 = min(_1301, 0.699999988079071f);
        float _1303 = 0.699999988079071f / _1302;
        float _1304 = _1303 * _1294;
        float _1305 = _1303 * _1295;
        float _1306 = _1303 * _1296;
        float _1307 = _1304 + -0.03999999910593033f;
        float _1308 = _1305 + -0.03999999910593033f;
        float _1309 = _1306 + -0.03999999910593033f;
        float _1310 = _1307 * _1293;
        float _1311 = _1308 * _1293;
        float _1312 = _1309 * _1293;
        float _1313 = _1310 + 0.03999999910593033f;
        float _1314 = _1311 + 0.03999999910593033f;
        float _1315 = _1312 + 0.03999999910593033f;
        if (_1267) {
          float _1317 = _1313 * _1291;
          float _1318 = _1314 * _1291;
          float _1319 = _1315 * _1291;
          _1321 = _1317;
          _1322 = _1318;
          _1323 = _1319;
        } else {
          _1321 = _1313;
          _1322 = _1314;
          _1323 = _1315;
        }
        if (_798) {
          float _1325 = dot(float3(_1263, _1264, _1265), float3(_737, _738, _739));
          float _1326 = abs(_1325);
          float _1327 = saturate(_1326);
          float _1328 = _606 * 2.0f;
          float _1329 = max(0.75f, _1328);
          float _1330 = 1.0f - _1327;
          float _1331 = min(0.9900000095367432f, _1330);
          float _1332 = 1.0f - _1329;
          float2 _1335 = __3__36__0__0__g_hairBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1331, _1332), 0.0f);
          float _1338 = min(0.9900000095367432f, _1298);
          float _1339 = 1.0f - _606;
          float2 _1341 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1338, _1339), 0.0f);
          float _1344 = _1341.x - _1335.x;
          float _1345 = _1341.y - _1335.y;
          float _1346 = _1344 * _530;
          float _1347 = _1345 * _530;
          float _1348 = _1346 + _1335.x;
          float _1349 = _1347 + _1335.y;
          float _1350 = _1348 * 0.009999999776482582f;
          float _1351 = _1349 + _1350;
          _1515 = _1351;
          _1516 = _1351;
          _1517 = _1351;
        } else {
          int _1353 = _531 + -97;
          bool _1354 = ((uint)_1353 < (uint)2);
          if (_1354) {
            float _1356 = abs(_242);
            bool _1357 = (_1356 > 0.9900000095367432f);
            if (!_1357) {
              float _1359 = -0.0f - _243;
              float _1360 = dot(float3(_1359, 0.0f, _241), float3(_1359, 0.0f, _241));
              float _1361 = rsqrt(_1360);
              float _1362 = _1361 * _1359;
              float _1363 = _1361 * _241;
              _1365 = _1362;
              _1366 = _1363;
            } else {
              _1365 = 1.0f;
              _1366 = 0.0f;
            }
            float _1367 = _242 * _1366;
            float _1368 = -0.0f - _1367;
            float _1369 = _1366 * _241;
            float _1370 = _1365 * _243;
            float _1371 = _1369 - _1370;
            float _1372 = _1365 * _242;
            float _1373 = dot(float3(_1368, _1371, _1372), float3(_1368, _1371, _1372));
            float _1374 = rsqrt(_1373);
            float _1375 = _1374 * _1368;
            float _1376 = _1371 * _1374;
            float _1377 = _1374 * _1372;
            float _1382 = _viewPos.x + _136;
            float _1383 = _viewPos.y + _137;
            float _1384 = _viewPos.z + _138;
            float _1385 = dot(float3(_1365, 0.0f, _1366), float3(_1382, _1383, _1384));
            float _1386 = dot(float3(_1375, _1376, _1377), float3(_1382, _1383, _1384));
            float4 _1389 = __3__36__0__0__g_blueNoise.SampleLevel(__0__4__0__0__g_staticBilinearWrap, float2(_1385, _1386), 0.0f);
            float _1393 = _1389.x + -0.5f;
            float _1394 = _1389.y + -0.5f;
            float _1395 = _1389.z + -0.5f;
            float _1396 = dot(float3(_1393, _1394, _1395), float3(_1393, _1394, _1395));
            float _1397 = rsqrt(_1396);
            float _1398 = _1393 * _1397;
            float _1399 = _1394 * _1397;
            float _1400 = _1395 * _1397;
            float _1401 = _1398 + _603;
            float _1402 = _1399 + _604;
            float _1403 = _1400 + _605;
            float _1404 = dot(float3(_1401, _1402, _1403), float3(_1401, _1402, _1403));
            float _1405 = rsqrt(_1404);
            float _1406 = _1401 * _1405;
            float _1407 = _1402 * _1405;
            float _1408 = _1403 * _1405;
            float _1409 = dot(float3(_743, _744, _745), float3(_1406, _1407, _1408));
            float _1410 = saturate(_1409);
            float _1411 = log2(_1410);
            float _1412 = _1411 * 512.0f;
            float _1413 = exp2(_1412);
            float _1414 = min(0.9900000095367432f, _1298);
            float _1415 = 1.0f - _606;
            float2 _1418 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1414, _1415), 0.0f);
            float _1421 = _1418.x * _1321;
            float _1422 = _1418.x * _1322;
            float _1423 = _1418.x * _1323;
            float _1424 = _1413 * 20.0f;
            float _1425 = _1418.y + _1424;
            float _1426 = _1425 + _1421;
            float _1427 = _1425 + _1422;
            float _1428 = _1425 + _1423;
            _1515 = _1426;
            _1516 = _1427;
            _1517 = _1428;
          } else {
            bool __defer_1429_1497 = false;
            if (_1267) {
              bool _1431 = (_531 == 65);
              if (!_1431) {
                float _1433 = _606 * 1.3300000429153442f;
                float _1434 = _606 * 0.47998046875f;
                float _1435 = min(0.9900000095367432f, _1298);
                float _1436 = 1.0f - _1433;
                float _1437 = saturate(_1436);
                float2 _1440 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1435, _1437), 0.0f);
                float _1443 = 1.0f - _1434;
                float _1444 = saturate(_1443);
                float2 _1445 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1435, _1444), 0.0f);
                float _1448 = _1445.x + _1440.x;
                float _1449 = _1448 * 0.5f;
                float _1450 = _1445.y + _1440.y;
                float _1451 = _1450 * 0.5f;
                float _1452 = _1449 * _1321;
                float _1453 = _1449 * _1322;
                float _1454 = _1449 * _1323;
                float _1455 = _1452 + _1451;
                float _1456 = _1453 + _1451;
                float _1457 = _1454 + _1451;
                _1515 = _1455;
                _1516 = _1456;
                _1517 = _1457;
              } else {
                _1498 = _1321;
                _1499 = _1322;
                _1500 = _1323;
                __defer_1429_1497 = true;
              }
            } else {
              bool _1459 = (_531 == 33);
              bool _1460 = (_531 == 55);
              bool _1461 = (_1459) | (_1460);
              if (_1461) {
                float _1463 = log2(_1298);
                float _1464 = _1463 * 4.0f;
                float _1465 = exp2(_1464);
                float _1466 = 1.0f - _1465;
                float _1467 = dot(float3(_1294, _1295, _1296), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
                float _1468 = max(_1467, 0.03999999910593033f);
                float _1469 = sqrt(_1294);
                float _1470 = sqrt(_1295);
                float _1471 = sqrt(_1296);
                float _1472 = _1469 - _1468;
                float _1473 = _1470 - _1468;
                float _1474 = _1471 - _1468;
                float _1475 = _1472 * _432;
                float _1476 = _1473 * _432;
                float _1477 = _1474 * _432;
                float _1478 = _1475 + _1468;
                float _1479 = _1476 + _1468;
                float _1480 = _1477 + _1468;
                float _1481 = saturate(_1466);
                float _1482 = _434 - _432;
                float _1483 = _1472 * _1482;
                float _1484 = _434 - _432;
                float _1485 = _1473 * _1484;
                float _1486 = _434 - _432;
                float _1487 = _1474 * _1486;
                float _1488 = _1481 * _1483;
                float _1489 = _1485 * _1481;
                float _1490 = _1487 * _1481;
                float _1491 = _1478 + _1488;
                float _1492 = _1479 + _1489;
                float _1493 = _1480 + _1490;
                float _1494 = _1491 * _433;
                float _1495 = _1492 * _433;
                float _1496 = _1493 * _433;
                _1498 = _1494;
                _1499 = _1495;
                _1500 = _1496;
              } else {
                _1498 = _1321;
                _1499 = _1322;
                _1500 = _1323;
              }
              __defer_1429_1497 = true;
            }
            if (__defer_1429_1497) {
              float _1501 = min(0.9900000095367432f, _1298);
              float _1502 = 1.0f - _606;
              float2 _1505 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1501, _1502), 0.0f);
              float _1508 = _1505.x * _1498;
              float _1509 = _1505.x * _1499;
              float _1510 = _1505.x * _1500;
              float _1511 = _1508 + _1505.y;
              float _1512 = _1509 + _1505.y;
              float _1513 = _1510 + _1505.y;
              _1515 = _1511;
              _1516 = _1512;
              _1517 = _1513;
            }
          }
        }
        float _1518 = max(0.009999999776482582f, _1515);
        float _1519 = max(0.009999999776482582f, _1516);
        float _1520 = max(0.009999999776482582f, _1517);
        float _1521 = _1260 / _1518;
        float _1522 = _1261 / _1519;
        float _1523 = _1262 / _1520;
        float _1524 = dot(float3(_1521, _1522, _1523), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _1527 = _exposure3.w * 8192.0f;
        float _1528 = min(_1527, _1524);
        float _1529 = max(9.999999974752427e-07f, _1524);
        float _1530 = _1528 / _1529;
        float _1533 = _1521 * _1530;
        float _1534 = -0.0f - _1533;
        float _1535 = _1522 * _1530;
        float _1536 = -0.0f - _1535;
        float _1537 = _1523 * _1530;
        float _1538 = -0.0f - _1537;
        float _1539 = min(0.0f, _1534);
        float _1540 = min(0.0f, _1536);
        float _1541 = min(0.0f, _1538);
        float _1542 = -0.0f - _1539;
        float _1543 = -0.0f - _1540;
        float _1544 = -0.0f - _1541;
        float _1545 = min(30000.0f, _1542);
        float _1546 = min(30000.0f, _1543);
        float _1547 = min(30000.0f, _1544);
        float _1548 = _1254 * _1257;
        float _1549 = _1548 * _exposure4.x;
        float _1550 = -0.0f - _1549;
        float _1551 = _1255 * _1258;
        float _1552 = _1551 * _exposure4.x;
        float _1553 = -0.0f - _1552;
        float _1554 = _1256 * _1259;
        float _1555 = _1554 * _exposure4.x;
        float _1556 = -0.0f - _1555;
        float _1557 = min(0.0f, _1550);
        float _1558 = min(0.0f, _1553);
        float _1559 = min(0.0f, _1556);
        float _1560 = -0.0f - _1557;
        float _1561 = -0.0f - _1558;
        float _1562 = -0.0f - _1559;
        float _1563 = min(30000.0f, _1560);
        float _1564 = min(30000.0f, _1561);
        float _1565 = min(30000.0f, _1562);
        float _1566 = dot(float3(_1563, _1564, _1565), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _1567 = _1566 / _exposure4.x;
        __3__38__0__1__g_sceneDiffuseUAV[int2(_55, _57)] = float4(_1563, _1564, _1565, 0.0f);
        bool _1569 = (_1545 > 0.0f);
        bool _1570 = (_1546 > 0.0f);
        bool _1571 = (_1547 > 0.0f);
        bool _1572 = (_1567 > 0.0f);
        bool _1573 = (_1569) | (_1570);
        bool _1574 = (_1573) | (_1571);
        bool _1575 = (_1574) | (_1572);
        [branch]
        if (_1575) {
          __3__38__0__1__g_specularResultUAV[int2(_55, _57)] = float4(_1545, _1546, _1547, _1567);
        }
      }
    }
  }
}
