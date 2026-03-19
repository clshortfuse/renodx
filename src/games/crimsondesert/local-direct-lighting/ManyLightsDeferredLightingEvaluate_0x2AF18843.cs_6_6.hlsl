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

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t14, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t119, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t31, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t90, space36);

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
  int _25 = (uint)(_24) >> 1;
  int _26 = _25 << 1;
  int _27 = _24 - _26;
  int _28 = _27 << 4;
  int _29 = _25 << 4;
  int _30 = (uint)(SV_GroupID.x) >> 2;
  int _31 = (uint)(SV_GroupID.x) >> 4;
  int _32 = _30 & 3;
  _17[0] = (int)((g_tileIndex[_31]).x);
  _17[1] = (int)((g_tileIndex[_31]).y);
  _17[2] = (int)((g_tileIndex[_31]).z);
  _17[3] = (int)((g_tileIndex[_31]).w);
  int _43 = _17[_32];
  int _44 = (uint)(_43) >> 16;
  uint _45 = _43 << 5;
  int _46 = _45 & 2097120;
  int _47 = _44 << 5;
  uint _48 = _46 + SV_GroupThreadID.x;
  uint _49 = _48 + _28;
  uint _50 = _29 + SV_GroupThreadID.y;
  uint _51 = _50 + _47;
  int _52 = (uint)(_49) >> 5;
  int _53 = (uint)(_51) >> 5;
  uint _55 = __3__36__0__0__g_tiledManyLightsMasks.Load(int3(_52, _53, 0));
  int _57 = _55.x & 1;
  bool _58 = (_57 == 0);
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
  if (!_58) {
    bool _63 = (_lightingParams.z > 0.0f);
    if (_63) {
      uint _66 = __3__36__0__0__g_depthStencil.Load(int3(_49, _51, 0));
      int _68 = _66.x & 16777215;
      float _69 = float((uint)_68);
      float _70 = _69 * 5.960465188081798e-08f;
      bool _71 = (_70 < 1.0000000116860974e-07f);
      bool _72 = (_70 == 1.0f);
      bool _73 = (_71) | (_72);
      if (!_73) {
        int _75 = (uint)((uint)(_66.x)) >> 24;
        int _76 = _75 & 127;
        float _79 = max(1.0000000116860974e-07f, _70);
        float _80 = _nearFarProj.x / _79;
        float _81 = float((uint)_49);
        float _82 = float((uint)_51);
        float _83 = _81 + 0.5f;
        float _84 = _82 + 0.5f;
        float _88 = _bufferSizeAndInvSize.z * _83;
        float _89 = _bufferSizeAndInvSize.w * _84;
        float _90 = _88 * 2.0f;
        float _91 = _90 + -1.0f;
        float _92 = _89 * 2.0f;
        float _93 = 1.0f - _92;
        float _114 = _91 * (_invViewProjRelative[0].x);
        float _115 = mad((_invViewProjRelative[0].y), _93, _114);
        float _116 = mad((_invViewProjRelative[0].z), _79, _115);
        float _117 = _116 + (_invViewProjRelative[0].w);
        float _118 = _91 * (_invViewProjRelative[1].x);
        float _119 = mad((_invViewProjRelative[1].y), _93, _118);
        float _120 = mad((_invViewProjRelative[1].z), _79, _119);
        float _121 = _120 + (_invViewProjRelative[1].w);
        float _122 = _91 * (_invViewProjRelative[2].x);
        float _123 = mad((_invViewProjRelative[2].y), _93, _122);
        float _124 = mad((_invViewProjRelative[2].z), _79, _123);
        float _125 = _124 + (_invViewProjRelative[2].w);
        float _126 = _91 * (_invViewProjRelative[3].x);
        float _127 = mad((_invViewProjRelative[3].y), _93, _126);
        float _128 = mad((_invViewProjRelative[3].z), _79, _127);
        float _129 = _128 + (_invViewProjRelative[3].w);
        float _130 = _117 / _129;
        float _131 = _121 / _129;
        float _132 = _125 / _129;
        float _133 = _130 * _130;
        float _134 = _131 * _131;
        float _135 = _134 + _133;
        float _136 = _132 * _132;
        float _137 = _135 + _136;
        float _138 = sqrt(_137);
        float _139 = 1.0f / _138;
        uint4 _141 = __3__36__0__0__g_baseColor.Load(int3(_49, _51, 0));
        float4 _147 = __3__36__0__0__g_normal.Load(int3(_49, _51, 0));
        int _152 = (uint)((uint)(_141.x)) >> 8;
        int _153 = _152 & 255;
        float _154 = float((uint)_153);
        float _155 = _154 * 0.003921568859368563f;
        half _156 = half(_155);
        int _157 = _141.x & 255;
        float _158 = float((uint)_157);
        float _159 = _158 * 0.003921568859368563f;
        half _160 = half(_159);
        int _161 = (uint)((uint)(_141.y)) >> 8;
        int _162 = _161 & 255;
        float _163 = float((uint)_162);
        float _164 = _163 * 0.003921568859368563f;
        half _165 = half(_164);
        int _166 = _141.y & 255;
        float _167 = float((uint)_166);
        float _168 = _167 * 0.003921568859368563f;
        half _169 = half(_168);
        int _170 = (uint)((uint)(_141.z)) >> 8;
        int _171 = _170 & 255;
        float _172 = float((uint)_171);
        float _173 = _172 * 0.003921568859368563f;
        half _174 = half(_173);
        int _175 = (uint)((uint)(_141.w)) >> 8;
        int _176 = _175 & 255;
        float _177 = float((uint)_176);
        float _178 = _177 * 0.003921568859368563f;
        half _179 = half(_178);
        int _180 = _141.w & 255;
        float _181 = float((uint)_180);
        float _182 = _181 * 0.003921568859368563f;
        half _183 = half(_182);
        float _184 = _147.w * 3.0f;
        float _185 = _184 + 0.5f;
        uint _186 = uint(_185);
        bool _187 = (_186 == 1);
        float _188 = _147.x * 1.0009784698486328f;
        float _189 = _147.y * 1.0009784698486328f;
        float _190 = _147.z * 1.0009784698486328f;
        float _191 = saturate(_188);
        float _192 = saturate(_189);
        float _193 = saturate(_190);
        float _194 = _191 * 2.0f;
        float _195 = _192 * 2.0f;
        float _196 = _193 * 2.0f;
        float _197 = _194 + -1.0f;
        float _198 = _195 + -1.0f;
        float _199 = _196 + -1.0f;
        float _200 = dot(float3(_197, _198, _199), float3(_197, _198, _199));
        float _201 = rsqrt(_200);
        float _202 = _201 * _197;
        float _203 = _201 * _198;
        float _204 = _199 * _201;
        half _205 = half(_202);
        half _206 = half(_203);
        half _207 = half(_204);
        half _208 = _179 * 2.0h;
        half _209 = _183 * 2.0h;
        half _210 = _208 + -1.0h;
        half _211 = _209 + -1.0h;
        half _212 = _210 + _211;
        float _213 = float(_212);
        half _214 = _210 - _211;
        float _215 = float(_214);
        float _216 = _213 * 0.5f;
        float _217 = _215 * 0.5f;
        float _218 = abs(_216);
        float _219 = 1.0f - _218;
        float _220 = abs(_217);
        float _221 = _219 - _220;
        float _222 = dot(float3(_216, _217, _221), float3(_216, _217, _221));
        float _223 = rsqrt(_222);
        float _224 = _223 * _216;
        float _225 = _223 * _217;
        float _226 = _223 * _221;
        half _227 = half(_224);
        half _228 = half(_225);
        half _229 = half(_226);
        float _230 = float(_205);
        float _231 = float(_206);
        float _232 = float(_207);
        bool _233 = (_207 >= 0.0h);
        float _234 = select(_233, 1.0f, -1.0f);
        float _235 = _234 + _232;
        float _236 = 1.0f / _235;
        float _237 = -0.0f - _236;
        float _238 = _231 * _237;
        float _239 = _238 * _230;
        float _240 = _234 * _230;
        float _241 = _240 * _230;
        float _242 = _241 * _237;
        float _243 = _242 + 1.0f;
        float _244 = _238 * _231;
        float _245 = _244 + _234;
        float _246 = -0.0f - _231;
        float _247 = float(_227);
        float _248 = float(_228);
        float _249 = float(_229);
        float _250 = _247 * _243;
        float _251 = mad(_248, _239, _250);
        float _252 = mad(_249, _230, _251);
        float _253 = _247 * _234;
        float _254 = _253 * _239;
        float _255 = mad(_248, _245, _254);
        float _256 = mad(_249, _231, _255);
        float _257 = _240 * _247;
        float _258 = -0.0f - _257;
        float _259 = mad(_248, _246, _258);
        float _260 = mad(_249, _232, _259);
        half _261 = half(_252);
        half _262 = half(_256);
        half _263 = half(_260);
        half _264 = dot(half3(_261, _262, _263), half3(_261, _262, _263));
        half _265 = rsqrt(_264);
        half _266 = _265 * _261;
        half _267 = _265 * _262;
        half _268 = _265 * _263;
        half _269 = _156 * _156;
        half _270 = _160 * _160;
        half _271 = _165 * _165;
        half _272 = saturate(_269);
        half _273 = saturate(_270);
        half _274 = saturate(_271);
        half _275 = _272 * 0.61328125h;
        half _276 = _272 * 0.07019043h;
        half _277 = _272 * 0.020614624h;
        half _278 = _273 * 0.3395996h;
        half _279 = _273 * 0.9165039h;
        half _280 = _273 * 0.109558105h;
        half _281 = _278 + _275;
        half _282 = _279 + _276;
        half _283 = _280 + _277;
        half _284 = _274 * 0.04736328h;
        half _285 = _274 * 0.013450623h;
        half _286 = _274 * 0.8696289h;
        half _287 = _281 + _284;
        half _288 = _282 + _285;
        half _289 = _283 + _286;
        half _290 = saturate(_287);
        half _291 = saturate(_288);
        half _292 = saturate(_289);
        half _293 = saturate(_290);
        half _294 = saturate(_291);
        half _295 = saturate(_292);
        half _296 = max(0.020004272h, _174);
        half _297 = saturate(_169);
        bool _298 = ((uint)_76 > (uint)10);
        int _299 = _75 & 126;
        bool __defer_74_331 = false;
        if (_298) {
          bool _301 = ((uint)_76 < (uint)20);
          bool _302 = (_76 == 107);
          bool _303 = (_301) | (_302);
          half _304 = select(_303, 0.0h, _297);
          bool _305 = (_299 == 96);
          bool _306 = (_76 == 98);
          bool _307 = (_305) | (_306);
          int _308 = _76 + -105;
          bool __defer_300_321 = false;
          if (!_307) {
            bool _310 = ((uint)_308 < (uint)2);
            if (_310) {
              if (_187) {
                _322 = 0.0h;
              } else {
                _322 = _304;
              }
              __defer_300_321 = true;
            } else {
              bool _313 = (_76 == 65);
              if (_313) {
                _322 = 0.0h;
                __defer_300_321 = true;
              } else {
                bool _316 = (_76 == 24);
                bool _317 = (_76 == 29);
                bool _318 = (_316) | (_317);
                if (_318) {
                  bool _320 = (_76 == 19);
                  _326 = 0.0h;
                  _327 = _320;
                  bool _328 = (_76 == 28);
                  bool _329 = (_299 == 26);
                  bool _330 = (_329) | (_328);
                  if (!_330) {
                    _332 = _327;
                    _333 = _326;
                    __defer_74_331 = true;
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
            bool _324 = ((uint)_308 < (uint)2);
            if (!_324) {
              _326 = _322;
              _327 = _323;
              bool _328 = (_76 == 28);
              bool _329 = (_299 == 26);
              bool _330 = (_329) | (_328);
              if (!_330) {
                _332 = _327;
                _333 = _326;
                __defer_74_331 = true;
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
          __defer_74_331 = true;
        }
        if (__defer_74_331) {
          bool _334 = (_76 == 107);
          _336 = _332;
          _337 = _333;
          _338 = _334;
        }
        bool _339 = (_76 == 29);
        bool _340 = (_299 == 64);
        bool _342 = (_lightingParams.x > 0.5f);
        if (_342) {
          float4 _346 = __3__36__0__0__g_puddleMask.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_88, _89), 0.0f);
          _349 = _346.y;
        } else {
          _349 = 0.0f;
        }
        float _350 = float(_266);
        float _351 = float(_267);
        float _352 = float(_268);
        bool _353 = (_76 == 53);
        if (_353) {
          half _355 = _294 + _293;
          half _356 = _355 + _295;
          half _357 = _356 * 1.2001953h;
          half _358 = saturate(_357);
          _360 = _358;
        } else {
          _360 = 1.0h;
        }
        half _361 = max(_293, _294);
        half _362 = max(_361, _295);
        half _363 = max(_362, 0.010002136h);
        half _364 = min(_363, 0.7001953h);
        half _365 = 0.7001953h / _364;
        half _366 = _365 * _360;
        half _367 = _366 * _293;
        half _368 = _366 * _294;
        half _369 = _366 * _295;
        half _370 = _367 + -0.040008545h;
        half _371 = _368 + -0.040008545h;
        half _372 = _369 + -0.040008545h;
        half _373 = _370 * _337;
        half _374 = _371 * _337;
        half _375 = _372 * _337;
        half _376 = _373 + 0.040008545h;
        half _377 = _374 + 0.040008545h;
        half _378 = _375 + 0.040008545h;
        float _379 = float(_376);
        float _380 = float(_377);
        float _381 = float(_378);
        if (_342) {
          bool _383 = (_336) | (_338);
          bool _384 = (_339) | (_383);
          float _385 = select(_384, 0.0f, 1.0f);
          half _386 = dot(half3(_205, _206, _207), half3(_205, _206, _207));
          half _387 = rsqrt(_386);
          half _388 = _387 * _206;
          half _389 = saturate(_388);
          float _390 = float(_389);
          float _391 = _390 * _390;
          float _392 = _391 * _391;
          float _393 = _392 * _392;
          float _394 = _349 * _385;
          float _395 = _393 * _393;
          float _396 = _395 * _394;
          float _397 = 1.0f - _351;
          float _398 = _396 * _350;
          float _399 = _396 * _397;
          float _400 = _396 * _352;
          float _401 = _350 - _398;
          float _402 = _399 + _351;
          float _403 = _352 - _400;
          float _404 = dot(float3(_401, _402, _403), float3(_401, _402, _403));
          float _405 = rsqrt(_404);
          float _406 = _401 * _405;
          float _407 = _402 * _405;
          float _408 = _403 * _405;
          _410 = _406;
          _411 = _407;
          _412 = _408;
        } else {
          _410 = _350;
          _411 = _351;
          _412 = _352;
        }
        float _413 = float(_296);
        float _414 = _413 * _413;
        float _415 = _414 * _414;
        half _416 = _296 * 0.60009766h;
        float _417 = float(_416);
        float _418 = _417 * _417;
        float _419 = _418 * _418;
        uint2 _421 = __3__36__0__0__g_manyLightsHitData.Load(int3(_49, _51, 0));
        int _424 = (uint)((uint)(_421.x)) >> 16;
        int _425 = _424 & 32767;
        int _426 = _421.x | _421.y;
        bool _427 = (_426 != 0);
        int _428 = _421.x & 65535;
        float _429 = float((uint)_428);
        float _430 = _429 * 0.015609979629516602f;
        int _431 = select(_427, _425, 32767);
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
        bool _448 = (_430 >= 1000.0f);
        float _449 = float((bool)_448);
        float _450 = _434 - _130;
        float _451 = _435 - _131;
        float _452 = _436 - _132;
        float _453 = _450 * _450;
        float _454 = _451 * _451;
        float _455 = _453 + _454;
        float _456 = _452 * _452;
        float _457 = _455 + _456;
        float _458 = sqrt(_457);
        float _459 = 1.0f / _458;
        float _460 = _459 * _450;
        float _461 = _459 * _451;
        float _462 = _459 * _452;
        int _463 = _443 & 65535;
        int _464 = (uint)(_443) >> 16;
        int _465 = _444 & 65535;
        int _466 = (uint)(_444) >> 16;
        float _467 = f16tof32(_463);
        float _468 = f16tof32(_464);
        float _469 = f16tof32(_465);
        float _470 = f16tof32(_466);
        float _471 = dot(float3(_467, _468, _469), float3(_467, _468, _469));
        float _472 = rsqrt(_471);
        int _473 = _446 & 65535;
        int _474 = (uint)(_446) >> 16;
        int _475 = _447 & 65535;
        float _476 = f16tof32(_473);
        float _477 = f16tof32(_474);
        float _478 = f16tof32(_475);
        float _479 = dot(float3(_476, _477, _478), float3(_476, _477, _478));
        float _480 = rsqrt(_479);
        float _481 = _480 * _476;
        float _482 = _480 * _477;
        float _483 = _480 * _478;
        bool _484 = !(_470 >= 0.0f);
        if (!_484) {
          int _486 = (uint)(_447) >> 16;
          float _487 = f16tof32(_486);
          float _488 = _472 * _469;
          float _489 = _472 * _468;
          float _490 = _460 * _467;
          float _491 = _490 * _472;
          float _492 = mad(_461, _489, _491);
          float _493 = mad(_462, _488, _492);
          float _494 = _481 * _460;
          float _495 = mad(_461, _482, _494);
          float _496 = mad(_462, _483, _495);
          float _497 = dot(float3(_460, _461, _462), float3(_481, _482, _483));
          float _498 = asin(_497);
          float _499 = _498 * 0.31830987334251404f;
          float _500 = _499 + 0.5f;
          float _501 = -0.0f - _493;
          float _502 = -0.0f - _496;
          float _503 = _502 / _501;
          float _504 = atan(_503);
          float _505 = _504 + 3.1415927410125732f;
          float _506 = _504 + -3.1415927410125732f;
          bool _507 = (_493 > -0.0f);
          bool _508 = (_493 == -0.0f);
          bool _509 = (_496 <= -0.0f);
          bool _510 = (_496 > -0.0f);
          bool _511 = (_507) & (_509);
          float _512 = select(_511, _505, _504);
          bool _513 = (_507) & (_510);
          float _514 = select(_513, _506, _512);
          bool _515 = (_508) & (_510);
          bool _516 = (_508) & (_509);
          float _517 = _514 * 0.31830987334251404f;
          float _518 = select(_515, -0.5f, _517);
          float _519 = select(_516, 0.5f, _518);
          float _520 = abs(_519);
          float _521 = saturate(_520);
          float _522 = _521 * _487;
          float _523 = _522 + _470;
          float _526 = __3__36__0__0__g_lightProfile.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_500, _523), 0.0f);
          float _528 = _526.x * _438;
          float _529 = _526.x * _439;
          float _530 = _526.x * _440;
          _532 = _528;
          _533 = _529;
          _534 = _530;
        } else {
          _532 = _438;
          _533 = _439;
          _534 = _440;
        }
        float _535 = abs(_441);
        float _536 = _458 * _458;
        float _537 = _535 * _535;
        float _538 = max(_537, _536);
        bool _539 = (_535 > 99999.0f);
        float _540 = 1.0f / _538;
        float _541 = select(_539, 1.0f, _540);
        float _542 = saturate(_541);
        float _543 = asfloat(_421.y);
        float _544 = _139 * _130;
        float _545 = _139 * _131;
        float _546 = _139 * _132;
        float _547 = _460 * _458;
        float _548 = _461 * _458;
        float _549 = _462 * _458;
        float _550 = -0.0f - _544;
        float _551 = -0.0f - _545;
        float _552 = -0.0f - _546;
        float _553 = dot(float3(_550, _551, _552), float3(_350, _351, _352));
        float _554 = _553 * 2.0f;
        float _555 = _554 * _350;
        float _556 = _554 * _351;
        float _557 = _554 * _352;
        float _558 = _550 - _555;
        float _559 = _551 - _556;
        float _560 = _552 - _557;
        float _561 = dot(float3(_547, _548, _549), float3(_558, _559, _560));
        float _562 = _558 * _561;
        float _563 = _559 * _561;
        float _564 = _560 * _561;
        float _565 = _562 - _547;
        float _566 = _563 - _548;
        float _567 = _564 - _549;
        float _568 = _565 * _565;
        float _569 = _566 * _566;
        float _570 = _568 + _569;
        float _571 = _567 * _567;
        float _572 = _570 + _571;
        float _573 = sqrt(_572);
        float _574 = _535 / _573;
        float _575 = saturate(_574);
        float _576 = _565 * _575;
        float _577 = _566 * _575;
        float _578 = _567 * _575;
        float _579 = _576 + _547;
        float _580 = _577 + _548;
        float _581 = _578 + _549;
        float _582 = dot(float3(_579, _580, _581), float3(_579, _580, _581));
        float _583 = rsqrt(_582);
        float _584 = _579 * _583;
        float _585 = _580 * _583;
        float _586 = _581 * _583;
        float _587 = _584 - _544;
        float _588 = _585 - _545;
        float _589 = _586 - _546;
        float _590 = dot(float3(_587, _588, _589), float3(_587, _588, _589));
        float _591 = rsqrt(_590);
        float _592 = _587 * _591;
        float _593 = _588 * _591;
        float _594 = _589 * _591;
        float _595 = dot(float3(_350, _351, _352), float3(_584, _585, _586));
        float _596 = dot(float3(_410, _411, _412), float3(_584, _585, _586));
        float _597 = dot(float3(_350, _351, _352), float3(_550, _551, _552));
        float _598 = saturate(_597);
        float _599 = dot(float3(_410, _411, _412), float3(_592, _593, _594));
        float _600 = saturate(_599);
        float _601 = dot(float3(_550, _551, _552), float3(_592, _593, _594));
        bool _602 = !(_595 <= 0.0f);
        if (_602) {
          float _604 = 1.0f - _601;
          float _605 = saturate(_604);
          float _606 = _605 * _605;
          float _607 = _606 * _606;
          float _608 = _607 * _605;
          float _609 = _380 * 50.0f;
          float _610 = saturate(_609);
          float _611 = _608 * _610;
          float _612 = 1.0f - _608;
          float _613 = _612 * _379;
          float _614 = _612 * _380;
          float _615 = _612 * _381;
          float _616 = _613 + _611;
          float _617 = _614 + _611;
          float _618 = _615 + _611;
          float _619;
          if (DIFFUSE_BRDF_MODE >= 2.0f) {
            float _sNdotL = saturate(_595);
            float _eon_LdotV = dot(float3(_584, _585, _586), float3(_550, _551, _552));
            _619 = _sNdotL * EON_DiffuseScalar(_sNdotL, _598, _eon_LdotV, _413);
          } else if (DIFFUSE_BRDF_MODE >= 1.0f) {
            float _sNdotL = saturate(_595);
            _619 = _sNdotL * HammonDiffuseScalar(_sNdotL, _598, _600, _601, _413);
          } else {
            _619 = _595 * 0.31830987334251404f;
          }
          float _620 = saturate(_596);
          float _621 = 1.0f - _414;
          float _622 = _598 * _621;
          float _623 = _622 + _414;
          float _624 = _623 * _596;
          float _625 = _596 * _621;
          float _626 = _625 + _414;
          float _627 = _598 * _626;
          float _628 = _624 + _627;
          float _629 = 0.5f / _628;
          float _630 = _600 * _415;
          float _631 = _630 - _600;
          float _632 = _631 * _600;
          float _633 = _632 + 1.0f;
          float _634 = _633 * _633;
          float _635 = _634 * 3.1415927410125732f;
          float _636 = _415 / _635;
          float _637 = _636 * _629;
          float _638 = _616 * _637;
          float _639 = _617 * _637;
          float _640 = _618 * _637;
          float _641 = max(_638, 0.0f);
          float _642 = max(_639, 0.0f);
          float _643 = max(_640, 0.0f);
          float _644 = _641 * _620;
          float _645 = _642 * _620;
          float _646 = _643 * _620;
          _648 = _644;
          _649 = _645;
          _650 = _646;
          _651 = _619;
        } else {
          _648 = 0.0f;
          _649 = 0.0f;
          _650 = 0.0f;
          _651 = 0.0f;
        }
        bool _652 = (_76 != 65);
        bool _653 = (_652) & (_340);
        if (_653) {
          float _655 = _648 * 0.60009765625f;
          float _656 = _649 * 0.60009765625f;
          float _657 = _650 * 0.60009765625f;
          float _658 = 1.0f - _601;
          float _659 = saturate(_658);
          float _660 = _659 * _659;
          float _661 = _660 * _660;
          float _662 = _661 * _659;
          float _663 = _380 * 50.0f;
          float _664 = saturate(_663);
          float _665 = _662 * _664;
          float _666 = 1.0f - _662;
          float _667 = _666 * _379;
          float _668 = _666 * _380;
          float _669 = _666 * _381;
          float _670 = _667 + _665;
          float _671 = _668 + _665;
          float _672 = _669 + _665;
          float _673 = saturate(_596);
          float _674 = 1.0f - _418;
          float _675 = _598 * _674;
          float _676 = _675 + _418;
          float _677 = _676 * _596;
          float _678 = _596 * _674;
          float _679 = _678 + _418;
          float _680 = _598 * _679;
          float _681 = _677 + _680;
          float _682 = 0.5f / _681;
          float _683 = _600 * _419;
          float _684 = _683 - _600;
          float _685 = _684 * _600;
          float _686 = _685 + 1.0f;
          float _687 = _686 * _686;
          float _688 = _687 * 3.1415927410125732f;
          float _689 = _419 / _688;
          float _690 = _689 * _682;
          float _691 = _670 * _690;
          float _692 = _671 * _690;
          float _693 = _672 * _690;
          float _694 = max(_691, 0.0f);
          float _695 = max(_692, 0.0f);
          float _696 = max(_693, 0.0f);
          float _697 = _673 * 0.39990234375f;
          float _698 = _694 * _697;
          float _699 = _695 * _697;
          float _700 = _696 * _697;
          float _701 = _698 + _655;
          float _702 = _699 + _656;
          float _703 = _700 + _657;
          _705 = _701;
          _706 = _702;
          _707 = _703;
        } else {
          _705 = _648;
          _706 = _649;
          _707 = _650;
        }
        // RenoDX: Diffraction on Rough Surfaces
        if (DIFFRACTION > 0.0f && float(_337) > 0.0f) {
          float3 _rndx_dShift = DiffractionShiftAndSpeckleCS(
            _600, _598, _413,
            float2(_88, _89), _80,
            float3(_592, _593, _594),
            float3(_410, _411, _412),
            float3(_379, _380, _381)
          );
          float3 _rndx_dMod = lerp(float3(1.0f, 1.0f, 1.0f), _rndx_dShift, DIFFRACTION * float(_337));
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
        float _708 = _449 * _543;
        float _709 = _542 * _708;
        float _710 = _709 * _532;
        float _711 = _709 * _533;
        float _712 = _709 * _534;
        float _713 = _705 * _710;
        float _714 = _706 * _711;
        float _715 = _707 * _712;
        float _716 = float(_174);
        bool _717 = (_186 != 3);
        bool _718 = (_717) & (_340);
        if (_718) {
          bool _722 = (_cavityParams.z > 0.0f);
          float _723 = select(_722, 0.0f, 1.0f);
          _731 = _723;
        } else {
          float _725 = _80 * -0.005770780146121979f;
          float _726 = _716 * _716;
          float _727 = _726 * _725;
          float _728 = exp2(_727);
          float _729 = saturate(_728);
          _731 = _729;
        }
        bool _734 = (_cavityParams.x == 0.0f);
        float _735 = select(_734, 1.0f, _731);
        float _736 = float(_337);
        float _737 = float(_293);
        float _738 = float(_294);
        float _739 = float(_295);
        float _740 = dot(float3(_550, _551, _552), float3(_410, _411, _412));
        float _741 = saturate(_740);
        float _742 = max(_737, _738);
        float _743 = max(_742, _739);
        float _744 = max(_743, 0.009999999776482582f);
        float _745 = min(_744, 0.699999988079071f);
        float _746 = 0.699999988079071f / _745;
        float _747 = _746 * _737;
        float _748 = _746 * _738;
        float _749 = _746 * _739;
        float _750 = _747 + -0.03999999910593033f;
        float _751 = _748 + -0.03999999910593033f;
        float _752 = _749 + -0.03999999910593033f;
        float _753 = _750 * _736;
        float _754 = _751 * _736;
        float _755 = _752 * _736;
        float _756 = _753 + 0.03999999910593033f;
        float _757 = _754 + 0.03999999910593033f;
        float _758 = _755 + 0.03999999910593033f;
        if (_340) {
          float _760 = _756 * _735;
          float _761 = _757 * _735;
          float _762 = _758 * _735;
          _764 = _760;
          _765 = _761;
          _766 = _762;
        } else {
          _764 = _756;
          _765 = _757;
          _766 = _758;
        }
        float _767 = min(0.9900000095367432f, _741);
        float _768 = 1.0f - _413;
        float2 _771 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_767, _768), 0.0f);
        float _774 = _771.x * _764;
        float _775 = _771.x * _765;
        float _776 = _771.x * _766;
        float _777 = _774 + _771.y;
        float _778 = _775 + _771.y;
        float _779 = _776 + _771.y;
        float _780 = max(0.009999999776482582f, _777);
        float _781 = max(0.009999999776482582f, _778);
        float _782 = max(0.009999999776482582f, _779);
        float _783 = _713 / _780;
        float _784 = _714 / _781;
        float _785 = _715 / _782;
        float _786 = dot(float3(_783, _784, _785), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _789 = _exposure3.w * 8192.0f;
        float _790 = min(_789, _786);
        float _791 = max(9.999999974752427e-07f, _786);
        float _792 = _790 / _791;
        float _795 = _exposure4.x * _651;
        float _796 = _783 * _792;
        float _797 = -0.0f - _796;
        float _798 = _784 * _792;
        float _799 = -0.0f - _798;
        float _800 = _785 * _792;
        float _801 = -0.0f - _800;
        float _802 = min(0.0f, _797);
        float _803 = min(0.0f, _799);
        float _804 = min(0.0f, _801);
        float _805 = -0.0f - _802;
        float _806 = -0.0f - _803;
        float _807 = -0.0f - _804;
        float _808 = min(30000.0f, _805);
        float _809 = min(30000.0f, _806);
        float _810 = min(30000.0f, _807);
        float _811 = _710 * _795;
        float _812 = -0.0f - _811;
        float _813 = _711 * _795;
        float _814 = -0.0f - _813;
        float _815 = _712 * _795;
        float _816 = -0.0f - _815;
        float _817 = min(0.0f, _812);
        float _818 = min(0.0f, _814);
        float _819 = min(0.0f, _816);
        float _820 = -0.0f - _817;
        float _821 = -0.0f - _818;
        float _822 = -0.0f - _819;
        float _823 = min(30000.0f, _820);
        float _824 = min(30000.0f, _821);
        float _825 = min(30000.0f, _822);
        float _826 = dot(float3(_823, _824, _825), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _827 = _826 / _exposure4.x;
        __3__38__0__1__g_sceneDiffuseUAV[int2(_49, _51)] = float4(_823, _824, _825, 0.0f);
        bool _829 = (_808 > 0.0f);
        bool _830 = (_809 > 0.0f);
        bool _831 = (_810 > 0.0f);
        bool _832 = (_827 > 0.0f);
        bool _833 = (_829) | (_830);
        bool _834 = (_833) | (_831);
        bool _835 = (_834) | (_832);
        [branch]
        if (_835) {
          __3__38__0__1__g_specularResultUAV[int2(_49, _51)] = float4(_808, _809, _810, _827);
        }
      }
    }
  }
}
