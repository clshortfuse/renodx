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
  float cb0_079x : packoffset(c079.x);
  float cb0_079y : packoffset(c079.y);
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
  float _396;
  float _397;
  float _398;
  float _430;
  float _431;
  float _432;
  float _480;
  float _481;
  float _482;
  float _555;
  float _558;
  float _559;
  float _560;
  float _584;
  float _587;
  float _588;
  float _589;
  float _624;
  float _625;
  float _626;
  float _739;
  float _740;
  float _741;
  float _748;
  float _762;
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
  float _357 = ((((_296 * (_297 - cb0_073x)) + cb0_073x) * (_253.x + ((_227 * TEXCOORD_1.x) * cb0_070x))) * ((_335 * (_336 - cb0_076x)) + cb0_076x)) * ((cb0_079x * _35) + cb0_079y);
  float _360 = ((((_296 * (_297 - cb0_073y)) + cb0_073y) * (_253.y + ((_228 * TEXCOORD_1.x) * cb0_070y))) * ((_335 * (_336 - cb0_076y)) + cb0_076y)) * ((cb0_079x * _59) + cb0_079y);
  float _363 = ((((_296 * (_297 - cb0_073z)) + cb0_073z) * (_253.z + ((_169.z * TEXCOORD_1.x) * cb0_070z))) * ((_335 * (_336 - cb0_076z)) + cb0_076z)) * ((cb0_079x * _60) + cb0_079y);

  CAPTURE_UNTONEMAPPED(untonemapped, float3(_357, _360, _363));

  [branch]
  // if (!((uint)(cb0_091z) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 1)) {
    // _396 = saturate((((_357 * 1.3600000143051147f) + 0.04699999839067459f) * _357) / ((((_357 * 0.9599999785423279f) + 0.5600000023841858f) * _357) + 0.14000000059604645f));
    // _397 = saturate((((_360 * 1.3600000143051147f) + 0.04699999839067459f) * _360) / ((((_360 * 0.9599999785423279f) + 0.5600000023841858f) * _360) + 0.14000000059604645f));
    // _398 = saturate((((_363 * 1.3600000143051147f) + 0.04699999839067459f) * _363) / ((((_363 * 0.9599999785423279f) + 0.5600000023841858f) * _363) + 0.14000000059604645f));
    _396 = ((((_357 * 1.3600000143051147f) + 0.04699999839067459f) * _357) / ((((_357 * 0.9599999785423279f) + 0.5600000023841858f) * _357) + 0.14000000059604645f));
    _397 = ((((_360 * 1.3600000143051147f) + 0.04699999839067459f) * _360) / ((((_360 * 0.9599999785423279f) + 0.5600000023841858f) * _360) + 0.14000000059604645f));
    _398 = ((((_363 * 1.3600000143051147f) + 0.04699999839067459f) * _363) / ((((_363 * 0.9599999785423279f) + 0.5600000023841858f) * _363) + 0.14000000059604645f));
  } else {
    _396 = _357;
    _397 = _360;
    _398 = _363;
  }
  [branch]
  // if (!((uint)(cb0_091w) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 2)) {
    float _408 = 1.0049500465393066f - (0.16398000717163086f / (_396 + -0.19505000114440918f));
    float _409 = 1.0049500465393066f - (0.16398000717163086f / (_397 + -0.19505000114440918f));
    float _410 = 1.0049500465393066f - (0.16398000717163086f / (_398 + -0.19505000114440918f));
    // _430 = saturate(((_396 - _408) * select((_396 > 0.6000000238418579f), 0.0f, 1.0f)) + _408);
    // _431 = saturate(((_397 - _409) * select((_397 > 0.6000000238418579f), 0.0f, 1.0f)) + _409);
    // _432 = saturate(((_398 - _410) * select((_398 > 0.6000000238418579f), 0.0f, 1.0f)) + _410);
    _430 = (((_396 - _408) * select((_396 > 0.6000000238418579f), 0.0f, 1.0f)) + _408);
    _431 = (((_397 - _409) * select((_397 > 0.6000000238418579f), 0.0f, 1.0f)) + _409);
    _432 = (((_398 - _410) * select((_398 > 0.6000000238418579f), 0.0f, 1.0f)) + _410);
  } else {
    _430 = _396;
    _431 = _397;
    _432 = _398;
  }
  [branch]
  // if (!((uint)(cb0_092x) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 3)) {
    float _439 = cb0_037y * _430;
    float _440 = cb0_037y * _431;
    float _441 = cb0_037y * _432;
    float _444 = cb0_037z * cb0_037w;
    float _454 = cb0_038y * cb0_038x;
    float _465 = cb0_038z * cb0_038x;
    float _472 = cb0_038y / cb0_038z;
    // _480 = saturate(((((_444 + _439) * _430) + _454) / (_465 + ((_439 + cb0_037z) * _430))) - _472);
    // _481 = saturate(((((_444 + _440) * _431) + _454) / (_465 + ((_440 + cb0_037z) * _431))) - _472);
    // _482 = saturate(((((_444 + _441) * _432) + _454) / (_465 + ((_441 + cb0_037z) * _432))) - _472);
    _480 = (((((_444 + _439) * _430) + _454) / (_465 + ((_439 + cb0_037z) * _430))) - _472);
    _481 = (((((_444 + _440) * _431) + _454) / (_465 + ((_440 + cb0_037z) * _431))) - _472);
    _482 = (((((_444 + _441) * _432) + _454) / (_465 + ((_441 + cb0_037z) * _432))) - _472);
  } else {
    _480 = _430;
    _481 = _431;
    _482 = _432;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!((bool)(cb0_090x <= 0.0f) && (bool)(cb0_090y <= 0.0f))) {
      float _494 = dot(float3(_480, _481, _482), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_494 <= 9.999999747378752e-05f)) {
        float _503 = (pow(_480, 0.1593017578125f));
        float _504 = (pow(_481, 0.1593017578125f));
        float _505 = (pow(_482, 0.1593017578125f));
        float _527 = exp2(log2(((_503 * 18.8515625f) + 0.8359375f) / ((_503 * 18.6875f) + 1.0f)) * 78.84375f);
        float _528 = exp2(log2(((_504 * 18.8515625f) + 0.8359375f) / ((_504 * 18.6875f) + 1.0f)) * 78.84375f);
        float _529 = exp2(log2(((_505 * 18.8515625f) + 0.8359375f) / ((_505 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((bool)(cb0_090y > 0.0f) && (bool)((_494 / cb0_090y) > 1.0f)) {
          float _538 = (pow(cb0_090y, 0.1593017578125f));
          float _546 = exp2(log2(((_538 * 18.8515625f) + 0.8359375f) / ((_538 * 18.6875f) + 1.0f)) * 78.84375f);
          if (_527 > _546) {
            float _549 = _527 - _546;
            _555 = ((_549 / ((_549 * cb0_090z) + 1.0f)) + _546);
          } else {
            _555 = _527;
          }
          if (_528 > _546) {
            float _756 = _528 - _546;
            _762 = ((_756 / ((_756 * cb0_090z) + 1.0f)) + _546);
            if (_529 > _546) {
              float _765 = _529 - _546;
              _558 = ((_765 / ((_765 * cb0_090z) + 1.0f)) + _546);
              _559 = _762;
              _560 = _555;
            } else {
              _558 = _529;
              _559 = _762;
              _560 = _555;
            }
          } else {
            _762 = _528;
            if (_529 > _546) {
              float _765 = _529 - _546;
              _558 = ((_765 / ((_765 * cb0_090z) + 1.0f)) + _546);
              _559 = _762;
              _560 = _555;
            } else {
              _558 = _529;
              _559 = _762;
              _560 = _555;
            }
          }
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_494 < cb0_090x) {
                float _568 = (pow(cb0_090x, 0.1593017578125f));
                float _576 = exp2(log2(((_568 * 18.8515625f) + 0.8359375f) / ((_568 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_560 < _576) {
                  _584 = (((cb0_090z * 0.30000001192092896f) * (_576 - _560)) + _560);
                } else {
                  _584 = _560;
                }
                if (_559 < _576) {
                  _748 = (((cb0_090z * 0.30000001192092896f) * (_576 - _559)) + _559);
                  if (_558 < _576) {
                    _587 = (((cb0_090z * 0.30000001192092896f) * (_576 - _558)) + _558);
                    _588 = _748;
                    _589 = _584;
                  } else {
                    _587 = _558;
                    _588 = _748;
                    _589 = _584;
                  }
                } else {
                  _748 = _559;
                  if (_558 < _576) {
                    _587 = (((cb0_090z * 0.30000001192092896f) * (_576 - _558)) + _558);
                    _588 = _748;
                    _589 = _584;
                  } else {
                    _587 = _558;
                    _588 = _748;
                    _589 = _584;
                  }
                }
              } else {
                _587 = _558;
                _588 = _559;
                _589 = _560;
              }
            } else {
              _587 = _558;
              _588 = _559;
              _589 = _560;
            }
            while(true) {
              float _596 = (pow(_589, 0.012683313339948654f));
              float _597 = (pow(_588, 0.012683313339948654f));
              float _598 = (pow(_587, 0.012683313339948654f));
              _624 = exp2(log2(max((_596 + -0.8359375f), 0.0f) / (18.8515625f - (_596 * 18.6875f))) * 6.277394771575928f);
              _625 = exp2(log2(max((_597 + -0.8359375f), 0.0f) / (18.8515625f - (_597 * 18.6875f))) * 6.277394771575928f);
              _626 = exp2(log2(max((_598 + -0.8359375f), 0.0f) / (18.8515625f - (_598 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        } else {
          _558 = _529;
          _559 = _528;
          _560 = _527;
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_494 < cb0_090x) {
                float _568 = (pow(cb0_090x, 0.1593017578125f));
                float _576 = exp2(log2(((_568 * 18.8515625f) + 0.8359375f) / ((_568 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_560 < _576) {
                  _584 = (((cb0_090z * 0.30000001192092896f) * (_576 - _560)) + _560);
                } else {
                  _584 = _560;
                }
                if (_559 < _576) {
                  _748 = (((cb0_090z * 0.30000001192092896f) * (_576 - _559)) + _559);
                  if (_558 < _576) {
                    _587 = (((cb0_090z * 0.30000001192092896f) * (_576 - _558)) + _558);
                    _588 = _748;
                    _589 = _584;
                  } else {
                    _587 = _558;
                    _588 = _748;
                    _589 = _584;
                  }
                } else {
                  _748 = _559;
                  if (_558 < _576) {
                    _587 = (((cb0_090z * 0.30000001192092896f) * (_576 - _558)) + _558);
                    _588 = _748;
                    _589 = _584;
                  } else {
                    _587 = _558;
                    _588 = _748;
                    _589 = _584;
                  }
                }
              } else {
                _587 = _558;
                _588 = _559;
                _589 = _560;
              }
            } else {
              _587 = _558;
              _588 = _559;
              _589 = _560;
            }
            while(true) {
              float _596 = (pow(_589, 0.012683313339948654f));
              float _597 = (pow(_588, 0.012683313339948654f));
              float _598 = (pow(_587, 0.012683313339948654f));
              _624 = exp2(log2(max((_596 + -0.8359375f), 0.0f) / (18.8515625f - (_596 * 18.6875f))) * 6.277394771575928f);
              _625 = exp2(log2(max((_597 + -0.8359375f), 0.0f) / (18.8515625f - (_597 * 18.6875f))) * 6.277394771575928f);
              _626 = exp2(log2(max((_598 + -0.8359375f), 0.0f) / (18.8515625f - (_598 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        }
      } else {
        _624 = _480;
        _625 = _481;
        _626 = _482;
      }
    } else {
      _624 = _480;
      _625 = _481;
      _626 = _482;
    }
  } else {
    _624 = _480;
    _625 = _481;
    _626 = _482;
  }

  CLAMP_IF_SDR(_624); CLAMP_IF_SDR(_625); CLAMP_IF_SDR(_626);
  CAPTURE_TONEMAPPED(tonemapped, float3(_624, _625, _626));

  float4 _648 = t2.Sample(s2, float3(((saturate((log2(_624 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_625 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_626 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _648.rgb = HandleLUTOutput(_648.rgb, untonemapped, tonemapped);

  float _652 = _648.x * 1.0499999523162842f;
  float _653 = _648.y * 1.0499999523162842f;
  float _654 = _648.z * 1.0499999523162842f;
  float _662 = ((_35 * 0.00390625f) + -0.001953125f) + _652;
  float _663 = ((_59 * 0.00390625f) + -0.001953125f) + _653;
  float _664 = ((_60 * 0.00390625f) + -0.001953125f) + _654;
  [branch]
  if (!((uint)(cb0_091y) == 0)) {
    float _676 = (pow(_662, 0.012683313339948654f));
    float _677 = (pow(_663, 0.012683313339948654f));
    float _678 = (pow(_664, 0.012683313339948654f));
    float _711 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_676 + -0.8359375f)) / (18.8515625f - (_676 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _712 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_677 + -0.8359375f)) / (18.8515625f - (_677 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _713 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_678 + -0.8359375f)) / (18.8515625f - (_678 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    _739 = min((_711 * 12.920000076293945f), ((exp2(log2(max(_711, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _740 = min((_712 * 12.920000076293945f), ((exp2(log2(max(_712, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _741 = min((_713 * 12.920000076293945f), ((exp2(log2(max(_713, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _739 = _662;
    _740 = _663;
    _741 = _664;
  }
  SV_Target.x = _739;
  SV_Target.y = _740;
  SV_Target.z = _741;

  // SV_Target.w = saturate(dot(float3(_652, _653, _654), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_652, _653, _654), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
