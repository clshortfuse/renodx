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
  float _380;
  float _381;
  float _382;
  float _414;
  float _415;
  float _416;
  float _463;
  float _464;
  float _465;
  float _522;
  float _525;
  float _526;
  float _527;
  float _562;
  float _563;
  float _564;
  float _677;
  float _678;
  float _679;
  float _687;
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
  float _343 = (((_292 * (_293 - cb0_073x)) + cb0_073x) * (_249.x + ((_223 * TEXCOORD_1.x) * cb0_070x))) * ((_331 * (_332 - cb0_076x)) + cb0_076x);
  float _345 = (((_292 * (_293 - cb0_073y)) + cb0_073y) * (_249.y + ((_224 * TEXCOORD_1.x) * cb0_070y))) * ((_331 * (_332 - cb0_076y)) + cb0_076y);
  float _347 = (((_292 * (_293 - cb0_073z)) + cb0_073z) * (_249.z + ((_165.z * TEXCOORD_1.x) * cb0_070z))) * ((_331 * (_332 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(float3(_343, _345, _347));

  [branch]
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    _380 = ((((_343 * 1.3600000143051147f) + 0.04699999839067459f) * _343) / ((((_343 * 0.9599999785423279f) + 0.5600000023841858f) * _343) + 0.14000000059604645f));
    _381 = ((((_345 * 1.3600000143051147f) + 0.04699999839067459f) * _345) / ((((_345 * 0.9599999785423279f) + 0.5600000023841858f) * _345) + 0.14000000059604645f));
    _382 = ((((_347 * 1.3600000143051147f) + 0.04699999839067459f) * _347) / ((((_347 * 0.9599999785423279f) + 0.5600000023841858f) * _347) + 0.14000000059604645f));
  } else {
    _380 = _343;
    _381 = _345;
    _382 = _347;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _392 = 1.0049500465393066f - (0.16398000717163086f / (_380 + -0.19505000114440918f));
    float _393 = 1.0049500465393066f - (0.16398000717163086f / (_381 + -0.19505000114440918f));
    float _394 = 1.0049500465393066f - (0.16398000717163086f / (_382 + -0.19505000114440918f));
    _414 = (((_380 - _392) * select((_380 > 0.6000000238418579f), 0.0f, 1.0f)) + _392);
    _415 = (((_381 - _393) * select((_381 > 0.6000000238418579f), 0.0f, 1.0f)) + _393);
    _416 = (((_382 - _394) * select((_382 > 0.6000000238418579f), 0.0f, 1.0f)) + _394);
  } else {
    _414 = _380;
    _415 = _381;
    _416 = _382;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _422 = cb0_037y * _414;
    float _423 = cb0_037y * _415;
    float _424 = cb0_037y * _416;
    float _427 = cb0_037z * cb0_037w;
    float _437 = cb0_038y * cb0_038x;
    float _448 = cb0_038z * cb0_038x;
    float _455 = cb0_038y / cb0_038z;
    _463 = (((((_427 + _422) * _414) + _437) / (((_422 + cb0_037z) * _414) + _448)) - _455);
    _464 = (((((_427 + _423) * _415) + _437) / (((_423 + cb0_037z) * _415) + _448)) - _455);
    _465 = (((((_427 + _424) * _416) + _437) / (((_424 + cb0_037z) * _416) + _448)) - _455);
  } else {
    _463 = _414;
    _464 = _415;
    _465 = _416;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!(cb0_090x == 1.0f)) {
      float _474 = dot(float3(_463, _464, _465), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_474 <= 9.999999747378752e-05f)) {
        float _483 = (pow(_463, 0.1593017578125f));
        float _484 = (pow(_464, 0.1593017578125f));
        float _485 = (pow(_465, 0.1593017578125f));
        float _507 = exp2(log2(((_483 * 18.8515625f) + 0.8359375f) / ((_483 * 18.6875f) + 1.0f)) * 78.84375f);
        float _508 = exp2(log2(((_484 * 18.8515625f) + 0.8359375f) / ((_484 * 18.6875f) + 1.0f)) * 78.84375f);
        float _509 = exp2(log2(((_485 * 18.8515625f) + 0.8359375f) / ((_485 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_474 * 200.0f) > 1.0f) {
          float _513 = 1.0f - cb0_090x;
          do {
            if (_507 > 0.44028136134147644f) {
              float _516 = _507 + -0.44028136134147644f;
              _522 = ((_516 / ((_516 * _513) + 1.0f)) + 0.44028136134147644f);
            } else {
              _522 = _507;
            }
            do {
              if (_508 > 0.44028136134147644f) {
                float _681 = _508 + -0.44028136134147644f;
                _687 = ((_681 / ((_681 * _513) + 1.0f)) + 0.44028136134147644f);
                if (_509 > 0.44028136134147644f) {
                  float _690 = _509 + -0.44028136134147644f;
                  _525 = ((_690 / ((_690 * _513) + 1.0f)) + 0.44028136134147644f);
                  _526 = _687;
                  _527 = _522;
                } else {
                  _525 = _509;
                  _526 = _687;
                  _527 = _522;
                }
              } else {
                _687 = _508;
                if (_509 > 0.44028136134147644f) {
                  float _690 = _509 + -0.44028136134147644f;
                  _525 = ((_690 / ((_690 * _513) + 1.0f)) + 0.44028136134147644f);
                  _526 = _687;
                  _527 = _522;
                } else {
                  _525 = _509;
                  _526 = _687;
                  _527 = _522;
                }
              }
              while(true) {
                float _534 = (pow(_527, 0.012683313339948654f));
                float _535 = (pow(_526, 0.012683313339948654f));
                float _536 = (pow(_525, 0.012683313339948654f));
                _562 = exp2(log2(max((_534 + -0.8359375f), 0.0f) / (18.8515625f - (_534 * 18.6875f))) * 6.277394771575928f);
                _563 = exp2(log2(max((_535 + -0.8359375f), 0.0f) / (18.8515625f - (_535 * 18.6875f))) * 6.277394771575928f);
                _564 = exp2(log2(max((_536 + -0.8359375f), 0.0f) / (18.8515625f - (_536 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _525 = _509;
          _526 = _508;
          _527 = _507;
          while(true) {
            float _534 = (pow(_527, 0.012683313339948654f));
            float _535 = (pow(_526, 0.012683313339948654f));
            float _536 = (pow(_525, 0.012683313339948654f));
            _562 = exp2(log2(max((_534 + -0.8359375f), 0.0f) / (18.8515625f - (_534 * 18.6875f))) * 6.277394771575928f);
            _563 = exp2(log2(max((_535 + -0.8359375f), 0.0f) / (18.8515625f - (_535 * 18.6875f))) * 6.277394771575928f);
            _564 = exp2(log2(max((_536 + -0.8359375f), 0.0f) / (18.8515625f - (_536 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _562 = _463;
        _563 = _464;
        _564 = _465;
      }
    } else {
      _562 = _463;
      _563 = _464;
      _564 = _465;
    }
  } else {
    _562 = _463;
    _563 = _464;
    _564 = _465;
  }

  CLAMP_IF_SDR(_562); CLAMP_IF_SDR(_563); CLAMP_IF_SDR(_564);
  CAPTURE_TONEMAPPED(float3(_562, _563, _564));

  float4 _586 = t2.Sample(s2, float3(((saturate((log2(_562 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_563 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_564 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _586.rgb = HandleLUTOutput(_586.rgb, untonemapped, tonemapped);

  float _590 = _586.x * 1.0499999523162842f;
  float _591 = _586.y * 1.0499999523162842f;
  float _592 = _586.z * 1.0499999523162842f;
  float _600 = ((_35 * 0.00390625f) + -0.001953125f) + _590;
  float _601 = ((_57 * 0.00390625f) + -0.001953125f) + _591;
  float _602 = ((_58 * 0.00390625f) + -0.001953125f) + _592;
  [branch]
  if (!((uint)(cb0_090w) == 0)) {
    float _614 = (pow(_600, 0.012683313339948654f));
    float _615 = (pow(_601, 0.012683313339948654f));
    float _616 = (pow(_602, 0.012683313339948654f));
    float _649 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_614 + -0.8359375f)) / (18.8515625f - (_614 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _650 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_615 + -0.8359375f)) / (18.8515625f - (_615 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _651 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_616 + -0.8359375f)) / (18.8515625f - (_616 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    _677 = min((_649 * 12.920000076293945f), ((exp2(log2(max(_649, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _678 = min((_650 * 12.920000076293945f), ((exp2(log2(max(_650, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _679 = min((_651 * 12.920000076293945f), ((exp2(log2(max(_651, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _677 = _600;
    _678 = _601;
    _679 = _602;
  }
  SV_Target.x = _677;
  SV_Target.y = _678;
  SV_Target.z = _679;

  SV_Target.w = (dot(float3(_590, _591, _592), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
