#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t2 : register(t2);

cbuffer cb0 : register(b0) {
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_053z : packoffset(c053.z);
  float cb0_053w : packoffset(c053.w);
  float cb0_054x : packoffset(c054.x);
  float cb0_054y : packoffset(c054.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_061x : packoffset(c061.x);
  float cb0_061y : packoffset(c061.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_070x : packoffset(c070.x);
  float cb0_070y : packoffset(c070.y);
  float cb0_070z : packoffset(c070.z);
  float cb0_072x : packoffset(c072.x);
  float cb0_072z : packoffset(c072.z);
  float cb0_072w : packoffset(c072.w);
  float cb0_073x : packoffset(c073.x);
  float cb0_073y : packoffset(c073.y);
  float cb0_073z : packoffset(c073.z);
  float cb0_073w : packoffset(c073.w);
  float cb0_074x : packoffset(c074.x);
  float cb0_074y : packoffset(c074.y);
  float cb0_074z : packoffset(c074.z);
  float cb0_075x : packoffset(c075.x);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_077x : packoffset(c077.x);
  float cb0_077y : packoffset(c077.y);
  float cb0_077z : packoffset(c077.z);
  float cb0_079z : packoffset(c079.z);
  float cb0_080x : packoffset(c080.x);
  uint cb0_089w : packoffset(c089.w);
  float cb0_090x : packoffset(c090.x);
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_091x : packoffset(c091.x);
  uint cb0_091y : packoffset(c091.y);
  uint cb0_091z : packoffset(c091.z);
  uint cb0_091w : packoffset(c091.w);
  uint cb0_092x : packoffset(c092.x);
  float cb0_097x : packoffset(c097.x);
  float cb0_097y : packoffset(c097.y);
  float cb0_097z : packoffset(c097.z);
  float cb0_097w : packoffset(c097.w);
  float cb0_098x : packoffset(c098.x);
  float cb0_098y : packoffset(c098.y);
  float cb0_098z : packoffset(c098.z);
  float cb0_098w : packoffset(c098.w);
  float cb0_100x : packoffset(c100.x);
  float cb0_100y : packoffset(c100.y);
  float cb0_100z : packoffset(c100.z);
  float cb0_101x : packoffset(c101.x);
  float cb0_101y : packoffset(c101.y);
  float cb0_101z : packoffset(c101.z);
  float cb0_101w : packoffset(c101.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _29 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _30 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _31 = TEXCOORD_2.w * 543.3099975585938f;
  float _35 = frac(sin(_31 + TEXCOORD_2.z) * 493013.0f);
  float _59;
  float _60;
  float _132;
  float _133;
  float _227;
  float _228;
  float _384;
  float _385;
  float _386;
  float _418;
  float _419;
  float _420;
  float _468;
  float _469;
  float _470;
  float _543;
  float _546;
  float _547;
  float _548;
  float _572;
  float _575;
  float _576;
  float _577;
  float _612;
  float _613;
  float _614;
  float _727;
  float _728;
  float _729;
  float _736;
  float _750;
  if (cb0_080x > 0.0f) {
    _59 = ((cb0_080x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _31) * 493013.0f) + 7.177000045776367f) - _35)) + _35);
    _60 = ((cb0_080x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _31) * 493013.0f) + 14.298999786376953f) - _35)) + _35);
  } else {
    _59 = _35;
    _60 = _35;
  }
  float _65 = cb0_079z * (1.0f - (_35 * _35));
  float _68 = _65 * (TEXCOORD_2.x - _29);
  float _69 = _65 * (TEXCOORD_2.y - _30);
  float _70 = _68 + _29;
  float _71 = _69 + _30;
  float _81 = cb0_101z * cb0_100x;
  float _82 = cb0_101z * cb0_100y;
  bool _83 = (cb0_101x == 0.0f);
  float _93 = (cb0_097z * TEXCOORD_3.x) + cb0_097x;
  float _94 = (cb0_097w * TEXCOORD_3.y) + cb0_097y;
  float _105 = float(((int)(uint)((bool)(_93 > 0.0f))) - ((int)(uint)((bool)(_93 < 0.0f))));
  float _106 = float(((int)(uint)((bool)(_94 > 0.0f))) - ((int)(uint)((bool)(_94 < 0.0f))));
  float _111 = saturate(abs(_93) - cb0_100z);
  float _112 = saturate(abs(_94) - cb0_100z);
  float _122 = _94 - ((_112 * _81) * _106);
  float _124 = _94 - ((_112 * _82) * _106);
  bool _125 = (cb0_101x > 0.0f);
  if (_125) {
    _132 = (_122 - (cb0_101w * 0.4000000059604645f));
    _133 = (_124 - (cb0_101w * 0.20000000298023224f));
  } else {
    _132 = _122;
    _133 = _124;
  }
  float4 _169 = t0.Sample(s0, float2(min(max(_70, cb0_053z), cb0_054x), min(max(_71, cb0_053w), cb0_054y)));
  float4 _185 = t0.Sample(s0, float2(min(max(((((cb0_048z * ((cb0_098z * (_93 - ((_111 * select(_83, _81, cb0_100x)) * _105))) + cb0_098x)) + cb0_049x) * cb0_048x) + _68), cb0_053z), cb0_054x), min(max(((((cb0_048w * ((cb0_098w * _132) + cb0_098y)) + cb0_049y) * cb0_048y) + _69), cb0_053w), cb0_054y)));
  float4 _199 = t0.Sample(s0, float2(min(max(((((cb0_048z * ((cb0_098z * (_93 - ((_111 * select(_83, _82, cb0_100y)) * _105))) + cb0_098x)) + cb0_049x) * cb0_048x) + _68), cb0_053z), cb0_054x), min(max(((((cb0_048w * ((cb0_098w * _133) + cb0_098y)) + cb0_049y) * cb0_048y) + _69), cb0_053w), cb0_054y)));
  if (_125) {
    float _209 = saturate(((((_169.y * 0.5870000123977661f) - cb0_101y) + (_169.x * 0.29899999499320984f)) + (_169.z * 0.11400000005960464f)) * 10.0f);
    float _213 = (_209 * _209) * (3.0f - (_209 * 2.0f));
    // _227 = ((((_169.x - _185.x) + (_213 * (_185.x - _169.x))) * cb0_101x) + _185.x);
    // _228 = ((((_169.y - _199.y) + (_213 * (_199.y - _169.y))) * cb0_101x) + _199.y);
    _227 = (RENODX_WUWA_CA * (((_169.x - _185.x) + (_213 * (_185.x - _169.x))) * cb0_101x) + _185.x);
    _228 = (RENODX_WUWA_CA * (((_169.y - _199.y) + (_213 * (_199.y - _169.y))) * cb0_101x) + _199.y);
  } else {
    _227 = _185.x;
    _228 = _199.y;
  }

  float4 _253 = t1.Sample(s1, float2(min(max(((cb0_068z * _70) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _71) + cb0_069y), cb0_060w), cb0_061y)));
  _253.rgb *= RENODX_WUWA_BLOOM;

  float _281 = TEXCOORD_1.z + -1.0f;
  float _283 = TEXCOORD_1.w + -1.0f;
  float _286 = ((_281 + (cb0_074x * 2.0f)) * cb0_072z) * cb0_072x;
  float _288 = ((_283 + (cb0_074y * 2.0f)) * cb0_072w) * cb0_072x;
  float _295 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_286, _288), float2(_286, _288))) + 1.0f);
  float _296 = _295 * _295;
  float _297 = cb0_074z + 1.0f;
  float _325 = ((_281 + (cb0_077x * 2.0f)) * cb0_075z) * cb0_075x;
  float _327 = ((_283 + (cb0_077y * 2.0f)) * cb0_075w) * cb0_075x;
  float _334 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_325, _327), float2(_325, _327))) + 1.0f);
  float _335 = _334 * _334;
  float _336 = cb0_077z + 1.0f;
  float _347 = (((_296 * (_297 - cb0_073x)) + cb0_073x) * (_253.x + ((_227 * TEXCOORD_1.x) * cb0_070x))) * ((_335 * (_336 - cb0_076x)) + cb0_076x);
  float _349 = (((_296 * (_297 - cb0_073y)) + cb0_073y) * (_253.y + ((_228 * TEXCOORD_1.x) * cb0_070y))) * ((_335 * (_336 - cb0_076y)) + cb0_076y);
  float _351 = (((_296 * (_297 - cb0_073z)) + cb0_073z) * (_253.z + ((_169.z * TEXCOORD_1.x) * cb0_070z))) * ((_335 * (_336 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(float3(_347, _349, _351));

  [branch]
  // if (!((uint)(cb0_091z) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 1)) {
    // _384 = saturate((((_347 * 1.3600000143051147f) + 0.04699999839067459f) * _347) / ((((_347 * 0.9599999785423279f) + 0.5600000023841858f) * _347) + 0.14000000059604645f));
    // _385 = saturate((((_349 * 1.3600000143051147f) + 0.04699999839067459f) * _349) / ((((_349 * 0.9599999785423279f) + 0.5600000023841858f) * _349) + 0.14000000059604645f));
    // _386 = saturate((((_351 * 1.3600000143051147f) + 0.04699999839067459f) * _351) / ((((_351 * 0.9599999785423279f) + 0.5600000023841858f) * _351) + 0.14000000059604645f));
    _384 = ((((_347 * 1.3600000143051147f) + 0.04699999839067459f) * _347) / ((((_347 * 0.9599999785423279f) + 0.5600000023841858f) * _347) + 0.14000000059604645f));
    _385 = ((((_349 * 1.3600000143051147f) + 0.04699999839067459f) * _349) / ((((_349 * 0.9599999785423279f) + 0.5600000023841858f) * _349) + 0.14000000059604645f));
    _386 = ((((_351 * 1.3600000143051147f) + 0.04699999839067459f) * _351) / ((((_351 * 0.9599999785423279f) + 0.5600000023841858f) * _351) + 0.14000000059604645f));
  } else {
    _384 = _347;
    _385 = _349;
    _386 = _351;
  }
  [branch]
  // if (!((uint)(cb0_091w) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 2)) {
    float _396 = 1.0049500465393066f - (0.16398000717163086f / (_384 + -0.19505000114440918f));
    float _397 = 1.0049500465393066f - (0.16398000717163086f / (_385 + -0.19505000114440918f));
    float _398 = 1.0049500465393066f - (0.16398000717163086f / (_386 + -0.19505000114440918f));
    // _418 = saturate(((_384 - _396) * select((_384 > 0.6000000238418579f), 0.0f, 1.0f)) + _396);
    // _419 = saturate(((_385 - _397) * select((_385 > 0.6000000238418579f), 0.0f, 1.0f)) + _397);
    // _420 = saturate(((_386 - _398) * select((_386 > 0.6000000238418579f), 0.0f, 1.0f)) + _398);
    _418 = (((_384 - _396) * select((_384 > 0.6000000238418579f), 0.0f, 1.0f)) + _396);
    _419 = (((_385 - _397) * select((_385 > 0.6000000238418579f), 0.0f, 1.0f)) + _397);
    _420 = (((_386 - _398) * select((_386 > 0.6000000238418579f), 0.0f, 1.0f)) + _398);
  } else {
    _418 = _384;
    _419 = _385;
    _420 = _386;
  }
  [branch]
  // if (!((uint)(cb0_092x) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 3)) {
    float _427 = cb0_037y * _418;
    float _428 = cb0_037y * _419;
    float _429 = cb0_037y * _420;
    float _432 = cb0_037z * cb0_037w;
    float _442 = cb0_038y * cb0_038x;
    float _453 = cb0_038z * cb0_038x;
    float _460 = cb0_038y / cb0_038z;
    // _468 = saturate(((((_432 + _427) * _418) + _442) / (_453 + ((_427 + cb0_037z) * _418))) - _460);
    // _469 = saturate(((((_432 + _428) * _419) + _442) / (_453 + ((_428 + cb0_037z) * _419))) - _460);
    // _470 = saturate(((((_432 + _429) * _420) + _442) / (_453 + ((_429 + cb0_037z) * _420))) - _460);
    _468 = (((((_432 + _427) * _418) + _442) / (_453 + ((_427 + cb0_037z) * _418))) - _460);
    _469 = (((((_432 + _428) * _419) + _442) / (_453 + ((_428 + cb0_037z) * _419))) - _460);
    _470 = (((((_432 + _429) * _420) + _442) / (_453 + ((_429 + cb0_037z) * _420))) - _460);
  } else {
    _468 = _418;
    _469 = _419;
    _470 = _420;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!((bool)(cb0_090x <= 0.0f) && (bool)(cb0_090y <= 0.0f))) {
      float _482 = dot(float3(_468, _469, _470), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_482 <= 9.999999747378752e-05f)) {
        float _491 = (pow(_468, 0.1593017578125f));
        float _492 = (pow(_469, 0.1593017578125f));
        float _493 = (pow(_470, 0.1593017578125f));
        float _515 = exp2(log2(((_491 * 18.8515625f) + 0.8359375f) / ((_491 * 18.6875f) + 1.0f)) * 78.84375f);
        float _516 = exp2(log2(((_492 * 18.8515625f) + 0.8359375f) / ((_492 * 18.6875f) + 1.0f)) * 78.84375f);
        float _517 = exp2(log2(((_493 * 18.8515625f) + 0.8359375f) / ((_493 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((bool)(cb0_090y > 0.0f) && (bool)((_482 / cb0_090y) > 1.0f)) {
          float _526 = (pow(cb0_090y, 0.1593017578125f));
          float _534 = exp2(log2(((_526 * 18.8515625f) + 0.8359375f) / ((_526 * 18.6875f) + 1.0f)) * 78.84375f);
          if (_515 > _534) {
            float _537 = _515 - _534;
            _543 = ((_537 / ((_537 * cb0_090z) + 1.0f)) + _534);
          } else {
            _543 = _515;
          }
          if (_516 > _534) {
            float _744 = _516 - _534;
            _750 = ((_744 / ((_744 * cb0_090z) + 1.0f)) + _534);
            if (_517 > _534) {
              float _753 = _517 - _534;
              _546 = ((_753 / ((_753 * cb0_090z) + 1.0f)) + _534);
              _547 = _750;
              _548 = _543;
            } else {
              _546 = _517;
              _547 = _750;
              _548 = _543;
            }
          } else {
            _750 = _516;
            if (_517 > _534) {
              float _753 = _517 - _534;
              _546 = ((_753 / ((_753 * cb0_090z) + 1.0f)) + _534);
              _547 = _750;
              _548 = _543;
            } else {
              _546 = _517;
              _547 = _750;
              _548 = _543;
            }
          }
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_482 < cb0_090x) {
                float _556 = (pow(cb0_090x, 0.1593017578125f));
                float _564 = exp2(log2(((_556 * 18.8515625f) + 0.8359375f) / ((_556 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_548 < _564) {
                  _572 = (((cb0_090z * 0.30000001192092896f) * (_564 - _548)) + _548);
                } else {
                  _572 = _548;
                }
                if (_547 < _564) {
                  _736 = (((cb0_090z * 0.30000001192092896f) * (_564 - _547)) + _547);
                  if (_546 < _564) {
                    _575 = (((cb0_090z * 0.30000001192092896f) * (_564 - _546)) + _546);
                    _576 = _736;
                    _577 = _572;
                  } else {
                    _575 = _546;
                    _576 = _736;
                    _577 = _572;
                  }
                } else {
                  _736 = _547;
                  if (_546 < _564) {
                    _575 = (((cb0_090z * 0.30000001192092896f) * (_564 - _546)) + _546);
                    _576 = _736;
                    _577 = _572;
                  } else {
                    _575 = _546;
                    _576 = _736;
                    _577 = _572;
                  }
                }
              } else {
                _575 = _546;
                _576 = _547;
                _577 = _548;
              }
            } else {
              _575 = _546;
              _576 = _547;
              _577 = _548;
            }
            while(true) {
              float _584 = (pow(_577, 0.012683313339948654f));
              float _585 = (pow(_576, 0.012683313339948654f));
              float _586 = (pow(_575, 0.012683313339948654f));
              _612 = exp2(log2(max((_584 + -0.8359375f), 0.0f) / (18.8515625f - (_584 * 18.6875f))) * 6.277394771575928f);
              _613 = exp2(log2(max((_585 + -0.8359375f), 0.0f) / (18.8515625f - (_585 * 18.6875f))) * 6.277394771575928f);
              _614 = exp2(log2(max((_586 + -0.8359375f), 0.0f) / (18.8515625f - (_586 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        } else {
          _546 = _517;
          _547 = _516;
          _548 = _515;
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_482 < cb0_090x) {
                float _556 = (pow(cb0_090x, 0.1593017578125f));
                float _564 = exp2(log2(((_556 * 18.8515625f) + 0.8359375f) / ((_556 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_548 < _564) {
                  _572 = (((cb0_090z * 0.30000001192092896f) * (_564 - _548)) + _548);
                } else {
                  _572 = _548;
                }
                if (_547 < _564) {
                  _736 = (((cb0_090z * 0.30000001192092896f) * (_564 - _547)) + _547);
                  if (_546 < _564) {
                    _575 = (((cb0_090z * 0.30000001192092896f) * (_564 - _546)) + _546);
                    _576 = _736;
                    _577 = _572;
                  } else {
                    _575 = _546;
                    _576 = _736;
                    _577 = _572;
                  }
                } else {
                  _736 = _547;
                  if (_546 < _564) {
                    _575 = (((cb0_090z * 0.30000001192092896f) * (_564 - _546)) + _546);
                    _576 = _736;
                    _577 = _572;
                  } else {
                    _575 = _546;
                    _576 = _736;
                    _577 = _572;
                  }
                }
              } else {
                _575 = _546;
                _576 = _547;
                _577 = _548;
              }
            } else {
              _575 = _546;
              _576 = _547;
              _577 = _548;
            }
            while(true) {
              float _584 = (pow(_577, 0.012683313339948654f));
              float _585 = (pow(_576, 0.012683313339948654f));
              float _586 = (pow(_575, 0.012683313339948654f));
              _612 = exp2(log2(max((_584 + -0.8359375f), 0.0f) / (18.8515625f - (_584 * 18.6875f))) * 6.277394771575928f);
              _613 = exp2(log2(max((_585 + -0.8359375f), 0.0f) / (18.8515625f - (_585 * 18.6875f))) * 6.277394771575928f);
              _614 = exp2(log2(max((_586 + -0.8359375f), 0.0f) / (18.8515625f - (_586 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        }
      } else {
        _612 = _468;
        _613 = _469;
        _614 = _470;
      }
    } else {
      _612 = _468;
      _613 = _469;
      _614 = _470;
    }
  } else {
    _612 = _468;
    _613 = _469;
    _614 = _470;
  }

  CLAMP_IF_SDR(_612); CLAMP_IF_SDR(_613); CLAMP_IF_SDR(_614);
  CAPTURE_TONEMAPPED(float3(_612, _613, _614));

  float4 _636 = t2.Sample(s2, float3(((saturate((log2(_612 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_613 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_614 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _636.rgb = HandleLUTOutput(_636.rgb, untonemapped, tonemapped);

  float _640 = _636.x * 1.0499999523162842f;
  float _641 = _636.y * 1.0499999523162842f;
  float _642 = _636.z * 1.0499999523162842f;
  float _650 = ((_35 * 0.00390625f) + -0.001953125f) + _640;
  float _651 = ((_59 * 0.00390625f) + -0.001953125f) + _641;
  float _652 = ((_60 * 0.00390625f) + -0.001953125f) + _642;
  [branch]
  if (!((uint)(cb0_091y) == 0)) {
    float _664 = (pow(_650, 0.012683313339948654f));
    float _665 = (pow(_651, 0.012683313339948654f));
    float _666 = (pow(_652, 0.012683313339948654f));
    float _699 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_664 + -0.8359375f)) / (18.8515625f - (_664 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _700 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_665 + -0.8359375f)) / (18.8515625f - (_665 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _701 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_666 + -0.8359375f)) / (18.8515625f - (_666 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    _727 = min((_699 * 12.920000076293945f), ((exp2(log2(max(_699, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _728 = min((_700 * 12.920000076293945f), ((exp2(log2(max(_700, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _729 = min((_701 * 12.920000076293945f), ((exp2(log2(max(_701, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _727 = _650;
    _728 = _651;
    _729 = _652;
  }
  SV_Target.x = _727;
  SV_Target.y = _728;
  SV_Target.z = _729;

  // SV_Target.w = saturate(dot(float3(_640, _641, _642), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_640, _641, _642), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
