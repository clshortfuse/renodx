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
  float _29 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _30 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _32 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _35 = frac(sin(_32) * 493013.0f);
  float _57;
  float _58;
  float _128;
  float _129;
  float _223;
  float _224;
  float _392;
  float _393;
  float _394;
  float _426;
  float _427;
  float _428;
  float _475;
  float _476;
  float _477;
  float _534;
  float _537;
  float _538;
  float _539;
  float _574;
  float _575;
  float _576;
  float _689;
  float _690;
  float _691;
  float _699;
  if (cb0_080x > 0.0f) {
    _57 = (((frac((sin(_32 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _35) * cb0_080x) + _35);
    _58 = (((frac((sin(_32 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _35) * cb0_080x) + _35);
  } else {
    _57 = _35;
    _58 = _35;
  }
  float _63 = cb0_079z * (1.0f - (_35 * _35));
  float _66 = _63 * (TEXCOORD_2.x - _29);
  float _67 = _63 * (TEXCOORD_2.y - _30);
  float _68 = _66 + _29;
  float _69 = _67 + _30;
  float _79 = cb0_101z * cb0_100x;
  float _80 = cb0_101z * cb0_100y;
  bool _81 = (cb0_101x == 0.0f);
  float _91 = (cb0_097z * TEXCOORD_3.x) + cb0_097x;
  float _92 = (cb0_097w * TEXCOORD_3.y) + cb0_097y;
  float _111 = float(((int)(uint)((bool)(_91 > 0.0f))) - ((int)(uint)((bool)(_91 < 0.0f)))) * saturate(abs(_91) - cb0_100z);
  float _113 = float(((int)(uint)((bool)(_92 > 0.0f))) - ((int)(uint)((bool)(_92 < 0.0f)))) * saturate(abs(_92) - cb0_100z);
  float _118 = _92 - (_113 * _79);
  float _120 = _92 - (_113 * _80);
  bool _121 = (cb0_101x > 0.0f);
  if (_121) {
    _128 = (_118 - (cb0_101w * 0.4000000059604645f));
    _129 = (_120 - (cb0_101w * 0.20000000298023224f));
  } else {
    _128 = _118;
    _129 = _120;
  }
  float4 _165 = t0.Sample(s0, float2(min(max(_68, cb0_053z), cb0_054x), min(max(_69, cb0_053w), cb0_054y)));
  float4 _181 = t0.Sample(s0, float2(min(max(((((((cb0_098z * (_91 - (_111 * select(_81, _79, cb0_100x)))) + cb0_098x) * cb0_048z) + cb0_049x) * cb0_048x) + _66), cb0_053z), cb0_054x), min(max(((((((cb0_098w * _128) + cb0_098y) * cb0_048w) + cb0_049y) * cb0_048y) + _67), cb0_053w), cb0_054y)));
  float4 _195 = t0.Sample(s0, float2(min(max(((((((cb0_098z * (_91 - (_111 * select(_81, _80, cb0_100y)))) + cb0_098x) * cb0_048z) + cb0_049x) * cb0_048x) + _66), cb0_053z), cb0_054x), min(max(((((((cb0_098w * _129) + cb0_098y) * cb0_048w) + cb0_049y) * cb0_048y) + _67), cb0_053w), cb0_054y)));
  if (_121) {
    float _205 = saturate(((((_165.y * 0.5870000123977661f) - cb0_101y) + (_165.x * 0.29899999499320984f)) + (_165.z * 0.11400000005960464f)) * 10.0f);
    float _209 = (_205 * _205) * (3.0f - (_205 * 2.0f));
    _223 = ((((_165.x - _181.x) + (_209 * (_181.x - _165.x))) * cb0_101x) + _181.x);
    _224 = ((((_165.y - _195.y) + (_209 * (_195.y - _165.y))) * cb0_101x) + _195.y);
  } else {
    _223 = _181.x;
    _224 = _195.y;
  }

  float4 _249 = t1.Sample(s1, float2(min(max(((cb0_068z * _68) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _69) + cb0_069y), cb0_060w), cb0_061y)));
  _249.rgb *= RENODX_WUWA_BLOOM;

  float _277 = TEXCOORD_1.z + -1.0f;
  float _279 = TEXCOORD_1.w + -1.0f;
  float _282 = (((cb0_074x * 2.0f) + _277) * cb0_072z) * cb0_072x;
  float _284 = (((cb0_074y * 2.0f) + _279) * cb0_072w) * cb0_072x;
  float _291 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_282, _284), float2(_282, _284))) + 1.0f);
  float _292 = _291 * _291;
  float _293 = cb0_074z + 1.0f;
  float _321 = (((cb0_077x * 2.0f) + _277) * cb0_075z) * cb0_075x;
  float _323 = (((cb0_077y * 2.0f) + _279) * cb0_075w) * cb0_075x;
  float _330 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_321, _323), float2(_321, _323))) + 1.0f);
  float _331 = _330 * _330;
  float _332 = cb0_077z + 1.0f;
  float _353 = ((((_292 * (_293 - cb0_073x)) + cb0_073x) * (_249.x + ((_223 * TEXCOORD_1.x) * cb0_070x))) * ((_331 * (_332 - cb0_076x)) + cb0_076x)) * ((cb0_079x * _35) + cb0_079y);
  float _356 = ((((_292 * (_293 - cb0_073y)) + cb0_073y) * (_249.y + ((_224 * TEXCOORD_1.x) * cb0_070y))) * ((_331 * (_332 - cb0_076y)) + cb0_076y)) * ((cb0_079x * _57) + cb0_079y);
  float _359 = ((((_292 * (_293 - cb0_073z)) + cb0_073z) * (_249.z + ((_165.z * TEXCOORD_1.x) * cb0_070z))) * ((_331 * (_332 - cb0_076z)) + cb0_076z)) * ((cb0_079x * _58) + cb0_079y);

  CAPTURE_UNTONEMAPPED(float3(_353, _356, _359));

  [branch]
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    _392 = ((((_353 * 1.3600000143051147f) + 0.04699999839067459f) * _353) / ((((_353 * 0.9599999785423279f) + 0.5600000023841858f) * _353) + 0.14000000059604645f));
    _393 = ((((_356 * 1.3600000143051147f) + 0.04699999839067459f) * _356) / ((((_356 * 0.9599999785423279f) + 0.5600000023841858f) * _356) + 0.14000000059604645f));
    _394 = ((((_359 * 1.3600000143051147f) + 0.04699999839067459f) * _359) / ((((_359 * 0.9599999785423279f) + 0.5600000023841858f) * _359) + 0.14000000059604645f));
  } else {
    _392 = _353;
    _393 = _356;
    _394 = _359;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _404 = 1.0049500465393066f - (0.16398000717163086f / (_392 + -0.19505000114440918f));
    float _405 = 1.0049500465393066f - (0.16398000717163086f / (_393 + -0.19505000114440918f));
    float _406 = 1.0049500465393066f - (0.16398000717163086f / (_394 + -0.19505000114440918f));
    _426 = (((_392 - _404) * select((_392 > 0.6000000238418579f), 0.0f, 1.0f)) + _404);
    _427 = (((_393 - _405) * select((_393 > 0.6000000238418579f), 0.0f, 1.0f)) + _405);
    _428 = (((_394 - _406) * select((_394 > 0.6000000238418579f), 0.0f, 1.0f)) + _406);
  } else {
    _426 = _392;
    _427 = _393;
    _428 = _394;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _434 = cb0_037y * _426;
    float _435 = cb0_037y * _427;
    float _436 = cb0_037y * _428;
    float _439 = cb0_037z * cb0_037w;
    float _449 = cb0_038y * cb0_038x;
    float _460 = cb0_038z * cb0_038x;
    float _467 = cb0_038y / cb0_038z;
    _475 = (((((_439 + _434) * _426) + _449) / (((_434 + cb0_037z) * _426) + _460)) - _467);
    _476 = (((((_439 + _435) * _427) + _449) / (((_435 + cb0_037z) * _427) + _460)) - _467);
    _477 = (((((_439 + _436) * _428) + _449) / (((_436 + cb0_037z) * _428) + _460)) - _467);
  } else {
    _475 = _426;
    _476 = _427;
    _477 = _428;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!(cb0_090x == 1.0f)) {
      float _486 = dot(float3(_475, _476, _477), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_486 <= 9.999999747378752e-05f)) {
        float _495 = (pow(_475, 0.1593017578125f));
        float _496 = (pow(_476, 0.1593017578125f));
        float _497 = (pow(_477, 0.1593017578125f));
        float _519 = exp2(log2(((_495 * 18.8515625f) + 0.8359375f) / ((_495 * 18.6875f) + 1.0f)) * 78.84375f);
        float _520 = exp2(log2(((_496 * 18.8515625f) + 0.8359375f) / ((_496 * 18.6875f) + 1.0f)) * 78.84375f);
        float _521 = exp2(log2(((_497 * 18.8515625f) + 0.8359375f) / ((_497 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_486 * 200.0f) > 1.0f) {
          float _525 = 1.0f - cb0_090x;
          do {
            if (_519 > 0.44028136134147644f) {
              float _528 = _519 + -0.44028136134147644f;
              _534 = ((_528 / ((_528 * _525) + 1.0f)) + 0.44028136134147644f);
            } else {
              _534 = _519;
            }
            do {
              if (_520 > 0.44028136134147644f) {
                float _693 = _520 + -0.44028136134147644f;
                _699 = ((_693 / ((_693 * _525) + 1.0f)) + 0.44028136134147644f);
                if (_521 > 0.44028136134147644f) {
                  float _702 = _521 + -0.44028136134147644f;
                  _537 = ((_702 / ((_702 * _525) + 1.0f)) + 0.44028136134147644f);
                  _538 = _699;
                  _539 = _534;
                } else {
                  _537 = _521;
                  _538 = _699;
                  _539 = _534;
                }
              } else {
                _699 = _520;
                if (_521 > 0.44028136134147644f) {
                  float _702 = _521 + -0.44028136134147644f;
                  _537 = ((_702 / ((_702 * _525) + 1.0f)) + 0.44028136134147644f);
                  _538 = _699;
                  _539 = _534;
                } else {
                  _537 = _521;
                  _538 = _699;
                  _539 = _534;
                }
              }
              while(true) {
                float _546 = (pow(_539, 0.012683313339948654f));
                float _547 = (pow(_538, 0.012683313339948654f));
                float _548 = (pow(_537, 0.012683313339948654f));
                _574 = exp2(log2(max((_546 + -0.8359375f), 0.0f) / (18.8515625f - (_546 * 18.6875f))) * 6.277394771575928f);
                _575 = exp2(log2(max((_547 + -0.8359375f), 0.0f) / (18.8515625f - (_547 * 18.6875f))) * 6.277394771575928f);
                _576 = exp2(log2(max((_548 + -0.8359375f), 0.0f) / (18.8515625f - (_548 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _537 = _521;
          _538 = _520;
          _539 = _519;
          while(true) {
            float _546 = (pow(_539, 0.012683313339948654f));
            float _547 = (pow(_538, 0.012683313339948654f));
            float _548 = (pow(_537, 0.012683313339948654f));
            _574 = exp2(log2(max((_546 + -0.8359375f), 0.0f) / (18.8515625f - (_546 * 18.6875f))) * 6.277394771575928f);
            _575 = exp2(log2(max((_547 + -0.8359375f), 0.0f) / (18.8515625f - (_547 * 18.6875f))) * 6.277394771575928f);
            _576 = exp2(log2(max((_548 + -0.8359375f), 0.0f) / (18.8515625f - (_548 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _574 = _475;
        _575 = _476;
        _576 = _477;
      }
    } else {
      _574 = _475;
      _575 = _476;
      _576 = _477;
    }
  } else {
    _574 = _475;
    _575 = _476;
    _576 = _477;
  }

  CLAMP_IF_SDR(_574); CLAMP_IF_SDR(_575); CLAMP_IF_SDR(_576);
  CAPTURE_TONEMAPPED(float3(_574, _575, _576));

  float4 _598 = t2.Sample(s2, float3(((saturate((log2(_574 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_575 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_576 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _598.rgb = HandleLUTOutput(_598.rgb, untonemapped, tonemapped);

  float _602 = _598.x * 1.0499999523162842f;
  float _603 = _598.y * 1.0499999523162842f;
  float _604 = _598.z * 1.0499999523162842f;
  float _612 = ((_35 * 0.00390625f) + -0.001953125f) + _602;
  float _613 = ((_57 * 0.00390625f) + -0.001953125f) + _603;
  float _614 = ((_58 * 0.00390625f) + -0.001953125f) + _604;
  [branch]
  if (!((uint)(cb0_090w) == 0)) {
    float _626 = (pow(_612, 0.012683313339948654f));
    float _627 = (pow(_613, 0.012683313339948654f));
    float _628 = (pow(_614, 0.012683313339948654f));
    float _661 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_626 + -0.8359375f)) / (18.8515625f - (_626 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _662 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_627 + -0.8359375f)) / (18.8515625f - (_627 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _663 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_628 + -0.8359375f)) / (18.8515625f - (_628 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    _689 = min((_661 * 12.920000076293945f), ((exp2(log2(max(_661, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _690 = min((_662 * 12.920000076293945f), ((exp2(log2(max(_662, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _691 = min((_663 * 12.920000076293945f), ((exp2(log2(max(_663, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _689 = _612;
    _690 = _613;
    _691 = _614;
  }
  SV_Target.x = _689;
  SV_Target.y = _690;
  SV_Target.z = _691;

  SV_Target.w = (dot(float3(_602, _603, _604), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
