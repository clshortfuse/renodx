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
  float cb0_090z : packoffset(c090.z);
  uint cb0_090w : packoffset(c090.w);
  uint cb0_091x : packoffset(c091.x);
  uint cb0_091y : packoffset(c091.y);
  uint cb0_091z : packoffset(c091.z);
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
  float _30 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _33 = frac(sin(_30) * 493013.0f);
  float _55;
  float _56;
  float _115;
  float _116;
  float _184;
  float _185;
  float _341;
  float _342;
  float _343;
  float _375;
  float _376;
  float _377;
  float _424;
  float _425;
  float _426;
  float _483;
  float _486;
  float _487;
  float _488;
  float _523;
  float _524;
  float _525;
  float _638;
  float _639;
  float _640;
  float _648;
  if (cb0_080x > 0.0f) {
    _55 = (((frac((sin(_30 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _33) * cb0_080x) + _33);
    _56 = (((frac((sin(_30 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _33) * cb0_080x) + _33);
  } else {
    _55 = _33;
    _56 = _33;
  }
  float _66 = cb0_101z * cb0_100x;
  float _67 = cb0_101z * cb0_100y;
  bool _68 = (cb0_101x == 0.0f);
  float _78 = (cb0_097z * TEXCOORD_3.x) + cb0_097x;
  float _79 = (cb0_097w * TEXCOORD_3.y) + cb0_097y;
  float _98 = float(((int)(uint)((bool)(_78 > 0.0f))) - ((int)(uint)((bool)(_78 < 0.0f)))) * saturate(abs(_78) - cb0_100z);
  float _100 = float(((int)(uint)((bool)(_79 > 0.0f))) - ((int)(uint)((bool)(_79 < 0.0f)))) * saturate(abs(_79) - cb0_100z);
  float _105 = _79 - (_100 * _66);
  float _107 = _79 - (_100 * _67);
  bool _108 = (cb0_101x > 0.0f);
  if (_108) {
    _115 = (_105 - (cb0_101w * 0.4000000059604645f));
    _116 = (_107 - (cb0_101w * 0.20000000298023224f));
  } else {
    _115 = _105;
    _116 = _107;
  }
  float4 _150 = t0.Sample(s0, float2(_27, _28));
  float4 _154 = t0.Sample(s0, float2((((((cb0_098z * (_78 - (_98 * select(_68, _66, cb0_100x)))) + cb0_098x) * cb0_048z) + cb0_049x) * cb0_048x), (((((cb0_098w * _115) + cb0_098y) * cb0_048w) + cb0_049y) * cb0_048y)));
  float4 _156 = t0.Sample(s0, float2((((((cb0_098z * (_78 - (_98 * select(_68, _67, cb0_100y)))) + cb0_098x) * cb0_048z) + cb0_049x) * cb0_048x), (((((cb0_098w * _116) + cb0_098y) * cb0_048w) + cb0_049y) * cb0_048y)));
  if (_108) {
    float _166 = saturate(((((_150.y * 0.5870000123977661f) - cb0_101y) + (_150.x * 0.29899999499320984f)) + (_150.z * 0.11400000005960464f)) * 10.0f);
    float _170 = (_166 * _166) * (3.0f - (_166 * 2.0f));
    _184 = ((((_150.x - _154.x) + (_170 * (_154.x - _150.x))) * cb0_101x) + _154.x);
    _185 = ((((_150.y - _156.y) + (_170 * (_156.y - _150.y))) * cb0_101x) + _156.y);
  } else {
    _184 = _154.x;
    _185 = _156.y;
  }
  float4 _210 = t1.Sample(s1, float2(min(max(((cb0_068z * _27) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _28) + cb0_069y), cb0_060w), cb0_061y)));
  _210.rgb *= RENODX_WUWA_BLOOM;

  float _238 = TEXCOORD_1.z + -1.0f;
  float _240 = TEXCOORD_1.w + -1.0f;
  float _243 = (((cb0_074x * 2.0f) + _238) * cb0_072z) * cb0_072x;
  float _245 = (((cb0_074y * 2.0f) + _240) * cb0_072w) * cb0_072x;
  float _252 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_243, _245), float2(_243, _245))) + 1.0f);
  float _253 = _252 * _252;
  float _254 = cb0_074z + 1.0f;
  float _282 = (((cb0_077x * 2.0f) + _238) * cb0_075z) * cb0_075x;
  float _284 = (((cb0_077y * 2.0f) + _240) * cb0_075w) * cb0_075x;
  float _291 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_282, _284), float2(_282, _284))) + 1.0f);
  float _292 = _291 * _291;
  float _293 = cb0_077z + 1.0f;
  float _304 = (((_253 * (_254 - cb0_073x)) + cb0_073x) * (_210.x + ((_184 * TEXCOORD_1.x) * cb0_070x))) * ((_292 * (_293 - cb0_076x)) + cb0_076x);
  float _306 = (((_253 * (_254 - cb0_073y)) + cb0_073y) * (_210.y + ((_185 * TEXCOORD_1.x) * cb0_070y))) * ((_292 * (_293 - cb0_076y)) + cb0_076y);
  float _308 = (((_253 * (_254 - cb0_073z)) + cb0_073z) * (_210.z + ((_150.z * TEXCOORD_1.x) * cb0_070z))) * ((_292 * (_293 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(float3(_304, _306, _308));

  [branch]
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    _341 = ((((_304 * 1.3600000143051147f) + 0.04699999839067459f) * _304) / ((((_304 * 0.9599999785423279f) + 0.5600000023841858f) * _304) + 0.14000000059604645f));
    _342 = ((((_306 * 1.3600000143051147f) + 0.04699999839067459f) * _306) / ((((_306 * 0.9599999785423279f) + 0.5600000023841858f) * _306) + 0.14000000059604645f));
    _343 = ((((_308 * 1.3600000143051147f) + 0.04699999839067459f) * _308) / ((((_308 * 0.9599999785423279f) + 0.5600000023841858f) * _308) + 0.14000000059604645f));
  } else {
    _341 = _304;
    _342 = _306;
    _343 = _308;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _353 = 1.0049500465393066f - (0.16398000717163086f / (_341 + -0.19505000114440918f));
    float _354 = 1.0049500465393066f - (0.16398000717163086f / (_342 + -0.19505000114440918f));
    float _355 = 1.0049500465393066f - (0.16398000717163086f / (_343 + -0.19505000114440918f));
    _375 = (((_341 - _353) * select((_341 > 0.6000000238418579f), 0.0f, 1.0f)) + _353);
    _376 = (((_342 - _354) * select((_342 > 0.6000000238418579f), 0.0f, 1.0f)) + _354);
    _377 = (((_343 - _355) * select((_343 > 0.6000000238418579f), 0.0f, 1.0f)) + _355);
  } else {
    _375 = _341;
    _376 = _342;
    _377 = _343;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _383 = cb0_037y * _375;
    float _384 = cb0_037y * _376;
    float _385 = cb0_037y * _377;
    float _388 = cb0_037z * cb0_037w;
    float _398 = cb0_038y * cb0_038x;
    float _409 = cb0_038z * cb0_038x;
    float _416 = cb0_038y / cb0_038z;
    _424 = (((((_388 + _383) * _375) + _398) / (((_383 + cb0_037z) * _375) + _409)) - _416);
    _425 = (((((_388 + _384) * _376) + _398) / (((_384 + cb0_037z) * _376) + _409)) - _416);
    _426 = (((((_388 + _385) * _377) + _398) / (((_385 + cb0_037z) * _377) + _409)) - _416);
  } else {
    _424 = _375;
    _425 = _376;
    _426 = _377;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!(cb0_090x == 1.0f)) {
      float _435 = dot(float3(_424, _425, _426), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_435 <= 9.999999747378752e-05f)) {
        float _444 = (pow(_424, 0.1593017578125f));
        float _445 = (pow(_425, 0.1593017578125f));
        float _446 = (pow(_426, 0.1593017578125f));
        float _468 = exp2(log2(((_444 * 18.8515625f) + 0.8359375f) / ((_444 * 18.6875f) + 1.0f)) * 78.84375f);
        float _469 = exp2(log2(((_445 * 18.8515625f) + 0.8359375f) / ((_445 * 18.6875f) + 1.0f)) * 78.84375f);
        float _470 = exp2(log2(((_446 * 18.8515625f) + 0.8359375f) / ((_446 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_435 * 200.0f) > 1.0f) {
          float _474 = 1.0f - cb0_090x;
          do {
            if (_468 > 0.44028136134147644f) {
              float _477 = _468 + -0.44028136134147644f;
              _483 = ((_477 / ((_477 * _474) + 1.0f)) + 0.44028136134147644f);
            } else {
              _483 = _468;
            }
            do {
              if (_469 > 0.44028136134147644f) {
                float _642 = _469 + -0.44028136134147644f;
                _648 = ((_642 / ((_642 * _474) + 1.0f)) + 0.44028136134147644f);
                if (_470 > 0.44028136134147644f) {
                  float _651 = _470 + -0.44028136134147644f;
                  _486 = ((_651 / ((_651 * _474) + 1.0f)) + 0.44028136134147644f);
                  _487 = _648;
                  _488 = _483;
                } else {
                  _486 = _470;
                  _487 = _648;
                  _488 = _483;
                }
              } else {
                _648 = _469;
                if (_470 > 0.44028136134147644f) {
                  float _651 = _470 + -0.44028136134147644f;
                  _486 = ((_651 / ((_651 * _474) + 1.0f)) + 0.44028136134147644f);
                  _487 = _648;
                  _488 = _483;
                } else {
                  _486 = _470;
                  _487 = _648;
                  _488 = _483;
                }
              }
              while(true) {
                float _495 = (pow(_488, 0.012683313339948654f));
                float _496 = (pow(_487, 0.012683313339948654f));
                float _497 = (pow(_486, 0.012683313339948654f));
                _523 = exp2(log2(max((_495 + -0.8359375f), 0.0f) / (18.8515625f - (_495 * 18.6875f))) * 6.277394771575928f);
                _524 = exp2(log2(max((_496 + -0.8359375f), 0.0f) / (18.8515625f - (_496 * 18.6875f))) * 6.277394771575928f);
                _525 = exp2(log2(max((_497 + -0.8359375f), 0.0f) / (18.8515625f - (_497 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _486 = _470;
          _487 = _469;
          _488 = _468;
          while(true) {
            float _495 = (pow(_488, 0.012683313339948654f));
            float _496 = (pow(_487, 0.012683313339948654f));
            float _497 = (pow(_486, 0.012683313339948654f));
            _523 = exp2(log2(max((_495 + -0.8359375f), 0.0f) / (18.8515625f - (_495 * 18.6875f))) * 6.277394771575928f);
            _524 = exp2(log2(max((_496 + -0.8359375f), 0.0f) / (18.8515625f - (_496 * 18.6875f))) * 6.277394771575928f);
            _525 = exp2(log2(max((_497 + -0.8359375f), 0.0f) / (18.8515625f - (_497 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _523 = _424;
        _524 = _425;
        _525 = _426;
      }
    } else {
      _523 = _424;
      _524 = _425;
      _525 = _426;
    }
  } else {
    _523 = _424;
    _524 = _425;
    _525 = _426;
  }

  CLAMP_IF_SDR(_523); CLAMP_IF_SDR(_524); CLAMP_IF_SDR(_525);
  CAPTURE_TONEMAPPED(float3(_523, _524, _525));

  float4 _547 = t2.Sample(s2, float3(((saturate((log2(_523 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_524 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_525 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _547.rgb = HandleLUTOutput(_547.rgb, untonemapped, tonemapped);

  float _551 = _547.x * 1.0499999523162842f;
  float _552 = _547.y * 1.0499999523162842f;
  float _553 = _547.z * 1.0499999523162842f;
  float _561 = ((_33 * 0.00390625f) + -0.001953125f) + _551;
  float _562 = ((_55 * 0.00390625f) + -0.001953125f) + _552;
  float _563 = ((_56 * 0.00390625f) + -0.001953125f) + _553;
  [branch]
  if (!((uint)(cb0_090w) == 0)) {
    float _575 = (pow(_561, 0.012683313339948654f));
    float _576 = (pow(_562, 0.012683313339948654f));
    float _577 = (pow(_563, 0.012683313339948654f));
    float _610 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_575 + -0.8359375f)) / (18.8515625f - (_575 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _611 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_576 + -0.8359375f)) / (18.8515625f - (_576 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _612 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_577 + -0.8359375f)) / (18.8515625f - (_577 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    _638 = min((_610 * 12.920000076293945f), ((exp2(log2(max(_610, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _639 = min((_611 * 12.920000076293945f), ((exp2(log2(max(_611, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _640 = min((_612 * 12.920000076293945f), ((exp2(log2(max(_612, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _638 = _561;
    _639 = _562;
    _640 = _563;
  }
  SV_Target.x = _638;
  SV_Target.y = _639;
  SV_Target.z = _640;
  SV_Target.w = (dot(float3(_551, _552, _553), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));

  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
