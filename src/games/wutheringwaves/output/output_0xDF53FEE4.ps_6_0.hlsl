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
  float cb0_092y : packoffset(c092.y);
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
  float cb0_093x : packoffset(c093.x);
  float cb0_093y : packoffset(c093.y);
  float cb0_093z : packoffset(c093.z);
  float cb0_094x : packoffset(c094.x);
  float cb0_094y : packoffset(c094.y);
  float cb0_094z : packoffset(c094.z);
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
  float _27 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _28 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _29 = TEXCOORD_2.w * 543.3099975585938f;
  float _33 = frac(sin(_29 + TEXCOORD_2.z) * 493013.0f);
  float _57;
  float _58;
  float _119;
  float _120;
  float _188;
  float _189;
  float _345;
  float _346;
  float _347;
  float _379;
  float _380;
  float _381;
  float _429;
  float _430;
  float _431;
  float _504;
  float _507;
  float _508;
  float _509;
  float _533;
  float _536;
  float _537;
  float _538;
  float _573;
  float _574;
  float _575;
  float _688;
  float _689;
  float _690;
  float _739;
  float _740;
  float _741;
  float _742;
  float _743;
  float _744;
  float _767;
  float _781;
  if (cb0_080x > 0.0f) {
    _57 = ((cb0_080x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _29) * 493013.0f) + 7.177000045776367f) - _33)) + _33);
    _58 = ((cb0_080x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _29) * 493013.0f) + 14.298999786376953f) - _33)) + _33);
  } else {
    _57 = _33;
    _58 = _33;
  }
  float _68 = cb0_101z * cb0_100x;
  float _69 = cb0_101z * cb0_100y;
  bool _70 = (cb0_101x == 0.0f);
  float _80 = (cb0_097z * TEXCOORD_3.x) + cb0_097x;
  float _81 = (cb0_097w * TEXCOORD_3.y) + cb0_097y;
  float _92 = float(((int)(uint)((bool)(_80 > 0.0f))) - ((int)(uint)((bool)(_80 < 0.0f))));
  float _93 = float(((int)(uint)((bool)(_81 > 0.0f))) - ((int)(uint)((bool)(_81 < 0.0f))));
  float _98 = saturate(abs(_80) - cb0_100z);
  float _99 = saturate(abs(_81) - cb0_100z);
  float _109 = _81 - ((_99 * _68) * _93);
  float _111 = _81 - ((_99 * _69) * _93);
  bool _112 = (cb0_101x > 0.0f);
  if (_112) {
    _119 = (_109 - (cb0_101w * 0.4000000059604645f));
    _120 = (_111 - (cb0_101w * 0.20000000298023224f));
  } else {
    _119 = _109;
    _120 = _111;
  }
  float4 _154 = t0.Sample(s0, float2(_27, _28));
  float4 _158 = t0.Sample(s0, float2((((cb0_048z * ((cb0_098z * (_80 - ((_98 * select(_70, _68, cb0_100x)) * _92))) + cb0_098x)) + cb0_049x) * cb0_048x), (((cb0_048w * ((cb0_098w * _119) + cb0_098y)) + cb0_049y) * cb0_048y)));
  float4 _160 = t0.Sample(s0, float2((((cb0_048z * ((cb0_098z * (_80 - ((_98 * select(_70, _69, cb0_100y)) * _92))) + cb0_098x)) + cb0_049x) * cb0_048x), (((cb0_048w * ((cb0_098w * _120) + cb0_098y)) + cb0_049y) * cb0_048y)));
  if (_112) {
    float _170 = saturate(((((_154.y * 0.5870000123977661f) - cb0_101y) + (_154.x * 0.29899999499320984f)) + (_154.z * 0.11400000005960464f)) * 10.0f);
    float _174 = (_170 * _170) * (3.0f - (_170 * 2.0f));
    // _188 = ((((_154.x - _158.x) + (_174 * (_158.x - _154.x))) * cb0_101x) + _158.x);
    // _189 = ((((_154.y - _160.y) + (_174 * (_160.y - _154.y))) * cb0_101x) + _160.y);
    _188 = (RENODX_WUWA_CA * (((_154.x - _158.x) + (_174 * (_158.x - _154.x))) * cb0_101x) + _158.x);
    _189 = (RENODX_WUWA_CA * (((_154.y - _160.y) + (_174 * (_160.y - _154.y))) * cb0_101x) + _160.y);
  } else {
    _188 = _158.x;
    _189 = _160.y;
  }

  float4 _214 = t1.Sample(s1, float2(min(max(((cb0_068z * _27) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _28) + cb0_069y), cb0_060w), cb0_061y)));
  _214.rgb *= RENODX_WUWA_BLOOM;

  float _242 = TEXCOORD_1.z + -1.0f;
  float _244 = TEXCOORD_1.w + -1.0f;
  float _247 = ((_242 + (cb0_074x * 2.0f)) * cb0_072z) * cb0_072x;
  float _249 = ((_244 + (cb0_074y * 2.0f)) * cb0_072w) * cb0_072x;
  float _256 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_247, _249), float2(_247, _249))) + 1.0f);
  float _257 = _256 * _256;
  float _258 = cb0_074z + 1.0f;
  float _286 = ((_242 + (cb0_077x * 2.0f)) * cb0_075z) * cb0_075x;
  float _288 = ((_244 + (cb0_077y * 2.0f)) * cb0_075w) * cb0_075x;
  float _295 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_286, _288), float2(_286, _288))) + 1.0f);
  float _296 = _295 * _295;
  float _297 = cb0_077z + 1.0f;
  float _308 = (((_257 * (_258 - cb0_073x)) + cb0_073x) * (_214.x + ((_188 * TEXCOORD_1.x) * cb0_070x))) * ((_296 * (_297 - cb0_076x)) + cb0_076x);
  float _310 = (((_257 * (_258 - cb0_073y)) + cb0_073y) * (_214.y + ((_189 * TEXCOORD_1.x) * cb0_070y))) * ((_296 * (_297 - cb0_076y)) + cb0_076y);
  float _312 = (((_257 * (_258 - cb0_073z)) + cb0_073z) * (_214.z + ((_154.z * TEXCOORD_1.x) * cb0_070z))) * ((_296 * (_297 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(untonemapped, float3(_308, _310, _312));

  [branch]
  // if (!((uint)(cb0_091z) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 1)) {
    // _345 = saturate((((_308 * 1.3600000143051147f) + 0.04699999839067459f) * _308) / ((((_308 * 0.9599999785423279f) + 0.5600000023841858f) * _308) + 0.14000000059604645f));
    // _346 = saturate((((_310 * 1.3600000143051147f) + 0.04699999839067459f) * _310) / ((((_310 * 0.9599999785423279f) + 0.5600000023841858f) * _310) + 0.14000000059604645f));
    // _347 = saturate((((_312 * 1.3600000143051147f) + 0.04699999839067459f) * _312) / ((((_312 * 0.9599999785423279f) + 0.5600000023841858f) * _312) + 0.14000000059604645f));
    _345 = ((((_308 * 1.3600000143051147f) + 0.04699999839067459f) * _308) / ((((_308 * 0.9599999785423279f) + 0.5600000023841858f) * _308) + 0.14000000059604645f));
    _346 = ((((_310 * 1.3600000143051147f) + 0.04699999839067459f) * _310) / ((((_310 * 0.9599999785423279f) + 0.5600000023841858f) * _310) + 0.14000000059604645f));
    _347 = ((((_312 * 1.3600000143051147f) + 0.04699999839067459f) * _312) / ((((_312 * 0.9599999785423279f) + 0.5600000023841858f) * _312) + 0.14000000059604645f));
  } else {
    _345 = _308;
    _346 = _310;
    _347 = _312;
  }
  [branch]
  // if (!((uint)(cb0_091w) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 2)) {
    float _357 = 1.0049500465393066f - (0.16398000717163086f / (_345 + -0.19505000114440918f));
    float _358 = 1.0049500465393066f - (0.16398000717163086f / (_346 + -0.19505000114440918f));
    float _359 = 1.0049500465393066f - (0.16398000717163086f / (_347 + -0.19505000114440918f));
    // _379 = saturate(((_345 - _357) * select((_345 > 0.6000000238418579f), 0.0f, 1.0f)) + _357);
    // _380 = saturate(((_346 - _358) * select((_346 > 0.6000000238418579f), 0.0f, 1.0f)) + _358);
    // _381 = saturate(((_347 - _359) * select((_347 > 0.6000000238418579f), 0.0f, 1.0f)) + _359);
    _379 = (((_345 - _357) * select((_345 > 0.6000000238418579f), 0.0f, 1.0f)) + _357);
    _380 = (((_346 - _358) * select((_346 > 0.6000000238418579f), 0.0f, 1.0f)) + _358);
    _381 = (((_347 - _359) * select((_347 > 0.6000000238418579f), 0.0f, 1.0f)) + _359);
  } else {
    _379 = _345;
    _380 = _346;
    _381 = _347;
  }
  [branch]
  // if (!((uint)(cb0_092x) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 3)) {
    float _388 = cb0_037y * _379;
    float _389 = cb0_037y * _380;
    float _390 = cb0_037y * _381;
    float _393 = cb0_037z * cb0_037w;
    float _403 = cb0_038y * cb0_038x;
    float _414 = cb0_038z * cb0_038x;
    float _421 = cb0_038y / cb0_038z;
    // _429 = saturate(((((_393 + _388) * _379) + _403) / (_414 + ((_388 + cb0_037z) * _379))) - _421);
    // _430 = saturate(((((_393 + _389) * _380) + _403) / (_414 + ((_389 + cb0_037z) * _380))) - _421);
    // _431 = saturate(((((_393 + _390) * _381) + _403) / (_414 + ((_390 + cb0_037z) * _381))) - _421);
    _429 = (((((_393 + _388) * _379) + _403) / (_414 + ((_388 + cb0_037z) * _379))) - _421);
    _430 = (((((_393 + _389) * _380) + _403) / (_414 + ((_389 + cb0_037z) * _380))) - _421);
    _431 = (((((_393 + _390) * _381) + _403) / (_414 + ((_390 + cb0_037z) * _381))) - _421);
  } else {
    _429 = _379;
    _430 = _380;
    _431 = _381;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!((bool)(cb0_090x <= 0.0f) && (bool)(cb0_090y <= 0.0f))) {
      float _443 = dot(float3(_429, _430, _431), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_443 <= 9.999999747378752e-05f)) {
        float _452 = (pow(_429, 0.1593017578125f));
        float _453 = (pow(_430, 0.1593017578125f));
        float _454 = (pow(_431, 0.1593017578125f));
        float _476 = exp2(log2(((_452 * 18.8515625f) + 0.8359375f) / ((_452 * 18.6875f) + 1.0f)) * 78.84375f);
        float _477 = exp2(log2(((_453 * 18.8515625f) + 0.8359375f) / ((_453 * 18.6875f) + 1.0f)) * 78.84375f);
        float _478 = exp2(log2(((_454 * 18.8515625f) + 0.8359375f) / ((_454 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((bool)(cb0_090y > 0.0f) && (bool)((_443 / cb0_090y) > 1.0f)) {
          float _487 = (pow(cb0_090y, 0.1593017578125f));
          float _495 = exp2(log2(((_487 * 18.8515625f) + 0.8359375f) / ((_487 * 18.6875f) + 1.0f)) * 78.84375f);
          if (_476 > _495) {
            float _498 = _476 - _495;
            _504 = ((_498 / ((_498 * cb0_090z) + 1.0f)) + _495);
          } else {
            _504 = _476;
          }
          if (_477 > _495) {
            float _775 = _477 - _495;
            _781 = ((_775 / ((_775 * cb0_090z) + 1.0f)) + _495);
            if (_478 > _495) {
              float _784 = _478 - _495;
              _507 = ((_784 / ((_784 * cb0_090z) + 1.0f)) + _495);
              _508 = _781;
              _509 = _504;
            } else {
              _507 = _478;
              _508 = _781;
              _509 = _504;
            }
          } else {
            _781 = _477;
            if (_478 > _495) {
              float _784 = _478 - _495;
              _507 = ((_784 / ((_784 * cb0_090z) + 1.0f)) + _495);
              _508 = _781;
              _509 = _504;
            } else {
              _507 = _478;
              _508 = _781;
              _509 = _504;
            }
          }
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_443 < cb0_090x) {
                float _517 = (pow(cb0_090x, 0.1593017578125f));
                float _525 = exp2(log2(((_517 * 18.8515625f) + 0.8359375f) / ((_517 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_509 < _525) {
                  _533 = (((cb0_090z * 0.30000001192092896f) * (_525 - _509)) + _509);
                } else {
                  _533 = _509;
                }
                if (_508 < _525) {
                  _767 = (((cb0_090z * 0.30000001192092896f) * (_525 - _508)) + _508);
                  if (_507 < _525) {
                    _536 = (((cb0_090z * 0.30000001192092896f) * (_525 - _507)) + _507);
                    _537 = _767;
                    _538 = _533;
                  } else {
                    _536 = _507;
                    _537 = _767;
                    _538 = _533;
                  }
                } else {
                  _767 = _508;
                  if (_507 < _525) {
                    _536 = (((cb0_090z * 0.30000001192092896f) * (_525 - _507)) + _507);
                    _537 = _767;
                    _538 = _533;
                  } else {
                    _536 = _507;
                    _537 = _767;
                    _538 = _533;
                  }
                }
              } else {
                _536 = _507;
                _537 = _508;
                _538 = _509;
              }
            } else {
              _536 = _507;
              _537 = _508;
              _538 = _509;
            }
            while(true) {
              float _545 = (pow(_538, 0.012683313339948654f));
              float _546 = (pow(_537, 0.012683313339948654f));
              float _547 = (pow(_536, 0.012683313339948654f));
              _573 = exp2(log2(max((_545 + -0.8359375f), 0.0f) / (18.8515625f - (_545 * 18.6875f))) * 6.277394771575928f);
              _574 = exp2(log2(max((_546 + -0.8359375f), 0.0f) / (18.8515625f - (_546 * 18.6875f))) * 6.277394771575928f);
              _575 = exp2(log2(max((_547 + -0.8359375f), 0.0f) / (18.8515625f - (_547 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        } else {
          _507 = _478;
          _508 = _477;
          _509 = _476;
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_443 < cb0_090x) {
                float _517 = (pow(cb0_090x, 0.1593017578125f));
                float _525 = exp2(log2(((_517 * 18.8515625f) + 0.8359375f) / ((_517 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_509 < _525) {
                  _533 = (((cb0_090z * 0.30000001192092896f) * (_525 - _509)) + _509);
                } else {
                  _533 = _509;
                }
                if (_508 < _525) {
                  _767 = (((cb0_090z * 0.30000001192092896f) * (_525 - _508)) + _508);
                  if (_507 < _525) {
                    _536 = (((cb0_090z * 0.30000001192092896f) * (_525 - _507)) + _507);
                    _537 = _767;
                    _538 = _533;
                  } else {
                    _536 = _507;
                    _537 = _767;
                    _538 = _533;
                  }
                } else {
                  _767 = _508;
                  if (_507 < _525) {
                    _536 = (((cb0_090z * 0.30000001192092896f) * (_525 - _507)) + _507);
                    _537 = _767;
                    _538 = _533;
                  } else {
                    _536 = _507;
                    _537 = _767;
                    _538 = _533;
                  }
                }
              } else {
                _536 = _507;
                _537 = _508;
                _538 = _509;
              }
            } else {
              _536 = _507;
              _537 = _508;
              _538 = _509;
            }
            while(true) {
              float _545 = (pow(_538, 0.012683313339948654f));
              float _546 = (pow(_537, 0.012683313339948654f));
              float _547 = (pow(_536, 0.012683313339948654f));
              _573 = exp2(log2(max((_545 + -0.8359375f), 0.0f) / (18.8515625f - (_545 * 18.6875f))) * 6.277394771575928f);
              _574 = exp2(log2(max((_546 + -0.8359375f), 0.0f) / (18.8515625f - (_546 * 18.6875f))) * 6.277394771575928f);
              _575 = exp2(log2(max((_547 + -0.8359375f), 0.0f) / (18.8515625f - (_547 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        }
      } else {
        _573 = _429;
        _574 = _430;
        _575 = _431;
      }
    } else {
      _573 = _429;
      _574 = _430;
      _575 = _431;
    }
  } else {
    _573 = _429;
    _574 = _430;
    _575 = _431;
  }

  CLAMP_IF_SDR(_573); CLAMP_IF_SDR(_574); CLAMP_IF_SDR(_575);
  CAPTURE_TONEMAPPED(tonemapped, float3(_573, _574, _575));

  float4 _597 = t2.Sample(s2, float3(((saturate((log2(_573 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_574 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_575 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _597.rgb = HandleLUTOutput(_597.rgb, untonemapped, tonemapped);

  float _601 = _597.x * 1.0499999523162842f;
  float _602 = _597.y * 1.0499999523162842f;
  float _603 = _597.z * 1.0499999523162842f;
  float _611 = ((_33 * 0.00390625f) + -0.001953125f) + _601;
  float _612 = ((_57 * 0.00390625f) + -0.001953125f) + _602;
  float _613 = ((_58 * 0.00390625f) + -0.001953125f) + _603;
  [branch]
  if (!((uint)(cb0_091y) == 0)) {
    float _625 = (pow(_611, 0.012683313339948654f));
    float _626 = (pow(_612, 0.012683313339948654f));
    float _627 = (pow(_613, 0.012683313339948654f));
    float _660 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_625 + -0.8359375f)) / (18.8515625f - (_625 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _661 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_626 + -0.8359375f)) / (18.8515625f - (_626 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _662 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_627 + -0.8359375f)) / (18.8515625f - (_627 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    _688 = min((_660 * 12.920000076293945f), ((exp2(log2(max(_660, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _689 = min((_661 * 12.920000076293945f), ((exp2(log2(max(_661, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _690 = min((_662 * 12.920000076293945f), ((exp2(log2(max(_662, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _688 = _611;
    _689 = _612;
    _690 = _613;
  }

  const float3 inverted = renodx::draw::InvertIntermediatePass(float3(_688, _689, _690));
  _688 = inverted.r; _689 = inverted.g; _690 = inverted.b;

  float _699 = ((((_689 * 587.0f) + (_688 * 299.0f)) + (_690 * 114.0f)) * 0.0010000000474974513f) - cb0_092w;
  float _706 = saturate(float(((int)(uint)((bool)(_699 > 0.0f))) - ((int)(uint)((bool)(_699 < 0.0f)))));
  float _713 = cb0_093x - _688;
  float _714 = cb0_093y - _689;
  float _715 = cb0_093z - _690;

  const float peak_scaling = RENODX_PEAK_NITS / RENODX_GAME_NITS;
  // float _720 = cb0_094x - _688;
  // float _721 = cb0_094y - _689;
  // float _722 = cb0_094z - _690;
  float _720 = peak_scaling * cb0_094x - _688;
  float _721 = peak_scaling * cb0_094y - _689;
  float _722 = peak_scaling * cb0_094z - _690;

  [branch]
  if (cb0_092z > 0.0f) {
    _739 = (_713 * cb0_092z);
    _740 = (_714 * cb0_092z);
    _741 = (_715 * cb0_092z);
    _742 = (_720 * cb0_092z);
    _743 = (_721 * cb0_092z);
    _744 = (_722 * cb0_092z);
  } else {
    float _731 = abs(cb0_092z);
    _739 = (_720 * _731);
    _740 = (_721 * _731);
    _741 = (_722 * _731);
    _742 = (_713 * _731);
    _743 = (_714 * _731);
    _744 = (_715 * _731);
  }
  SV_Target.x = ((cb0_092y * (lerp(_739, _742, _706))) + _688);
  SV_Target.y = ((cb0_092y * (lerp(_740, _743, _706))) + _689);
  SV_Target.z = (((lerp(_741, _744, _706)) * cb0_092y) + _690);

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);

  // SV_Target.w = saturate(dot(float3(_601, _602, _603), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_601, _602, _603), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
