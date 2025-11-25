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
  float _216;
  float _217;
  float _218;
  float _250;
  float _251;
  float _252;
  float _299;
  float _300;
  float _301;
  float _358;
  float _361;
  float _362;
  float _363;
  float _398;
  float _399;
  float _400;
  float _513;
  float _514;
  float _515;
  float _523;
  if (cb0_080x > 0.0f) {
    _55 = (((frac((sin(_30 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _33) * cb0_080x) + _33);
    _56 = (((frac((sin(_30 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _33) * cb0_080x) + _33);
  } else {
    _55 = _33;
    _56 = _33;
  }
  float4 _57 = t0.Sample(s0, float2(_27, _28));

  float4 _85 = t1.Sample(s1, float2(min(max(((cb0_068z * _27) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _28) + cb0_069y), cb0_060w), cb0_061y)));
  _85.rgb *= RENODX_WUWA_BLOOM;

  float _113 = TEXCOORD_1.z + -1.0f;
  float _115 = TEXCOORD_1.w + -1.0f;
  float _118 = (((cb0_074x * 2.0f) + _113) * cb0_072z) * cb0_072x;
  float _120 = (((cb0_074y * 2.0f) + _115) * cb0_072w) * cb0_072x;
  float _127 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_118, _120), float2(_118, _120))) + 1.0f);
  float _128 = _127 * _127;
  float _129 = cb0_074z + 1.0f;
  float _157 = (((cb0_077x * 2.0f) + _113) * cb0_075z) * cb0_075x;
  float _159 = (((cb0_077y * 2.0f) + _115) * cb0_075w) * cb0_075x;
  float _166 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_157, _159), float2(_157, _159))) + 1.0f);
  float _167 = _166 * _166;
  float _168 = cb0_077z + 1.0f;
  float _179 = (((_128 * (_129 - cb0_073x)) + cb0_073x) * (_85.x + ((_57.x * TEXCOORD_1.x) * cb0_070x))) * ((_167 * (_168 - cb0_076x)) + cb0_076x);
  float _181 = (((_128 * (_129 - cb0_073y)) + cb0_073y) * (_85.y + ((_57.y * TEXCOORD_1.x) * cb0_070y))) * ((_167 * (_168 - cb0_076y)) + cb0_076y);
  float _183 = (((_128 * (_129 - cb0_073z)) + cb0_073z) * (_85.z + ((_57.z * TEXCOORD_1.x) * cb0_070z))) * ((_167 * (_168 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(float3(_179, _181, _183));

  [branch]
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    _216 = ((((_179 * 1.3600000143051147f) + 0.04699999839067459f) * _179) / ((((_179 * 0.9599999785423279f) + 0.5600000023841858f) * _179) + 0.14000000059604645f));
    _217 = ((((_181 * 1.3600000143051147f) + 0.04699999839067459f) * _181) / ((((_181 * 0.9599999785423279f) + 0.5600000023841858f) * _181) + 0.14000000059604645f));
    _218 = ((((_183 * 1.3600000143051147f) + 0.04699999839067459f) * _183) / ((((_183 * 0.9599999785423279f) + 0.5600000023841858f) * _183) + 0.14000000059604645f));
  } else {
    _216 = _179;
    _217 = _181;
    _218 = _183;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _228 = 1.0049500465393066f - (0.16398000717163086f / (_216 + -0.19505000114440918f));
    float _229 = 1.0049500465393066f - (0.16398000717163086f / (_217 + -0.19505000114440918f));
    float _230 = 1.0049500465393066f - (0.16398000717163086f / (_218 + -0.19505000114440918f));
    _250 = (((_216 - _228) * select((_216 > 0.6000000238418579f), 0.0f, 1.0f)) + _228);
    _251 = (((_217 - _229) * select((_217 > 0.6000000238418579f), 0.0f, 1.0f)) + _229);
    _252 = (((_218 - _230) * select((_218 > 0.6000000238418579f), 0.0f, 1.0f)) + _230);
  } else {
    _250 = _216;
    _251 = _217;
    _252 = _218;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _258 = cb0_037y * _250;
    float _259 = cb0_037y * _251;
    float _260 = cb0_037y * _252;
    float _263 = cb0_037z * cb0_037w;
    float _273 = cb0_038y * cb0_038x;
    float _284 = cb0_038z * cb0_038x;
    float _291 = cb0_038y / cb0_038z;
    _299 = (((((_263 + _258) * _250) + _273) / (((_258 + cb0_037z) * _250) + _284)) - _291);
    _300 = (((((_263 + _259) * _251) + _273) / (((_259 + cb0_037z) * _251) + _284)) - _291);
    _301 = (((((_263 + _260) * _252) + _273) / (((_260 + cb0_037z) * _252) + _284)) - _291);
  } else {
    _299 = _250;
    _300 = _251;
    _301 = _252;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!(cb0_090x == 1.0f)) {
      float _310 = dot(float3(_299, _300, _301), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_310 <= 9.999999747378752e-05f)) {
        float _319 = (pow(_299, 0.1593017578125f));
        float _320 = (pow(_300, 0.1593017578125f));
        float _321 = (pow(_301, 0.1593017578125f));
        float _343 = exp2(log2(((_319 * 18.8515625f) + 0.8359375f) / ((_319 * 18.6875f) + 1.0f)) * 78.84375f);
        float _344 = exp2(log2(((_320 * 18.8515625f) + 0.8359375f) / ((_320 * 18.6875f) + 1.0f)) * 78.84375f);
        float _345 = exp2(log2(((_321 * 18.8515625f) + 0.8359375f) / ((_321 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_310 * 200.0f) > 1.0f) {
          float _349 = 1.0f - cb0_090x;
          do {
            if (_343 > 0.44028136134147644f) {
              float _352 = _343 + -0.44028136134147644f;
              _358 = ((_352 / ((_352 * _349) + 1.0f)) + 0.44028136134147644f);
            } else {
              _358 = _343;
            }
            do {
              if (_344 > 0.44028136134147644f) {
                float _517 = _344 + -0.44028136134147644f;
                _523 = ((_517 / ((_517 * _349) + 1.0f)) + 0.44028136134147644f);
                if (_345 > 0.44028136134147644f) {
                  float _526 = _345 + -0.44028136134147644f;
                  _361 = ((_526 / ((_526 * _349) + 1.0f)) + 0.44028136134147644f);
                  _362 = _523;
                  _363 = _358;
                } else {
                  _361 = _345;
                  _362 = _523;
                  _363 = _358;
                }
              } else {
                _523 = _344;
                if (_345 > 0.44028136134147644f) {
                  float _526 = _345 + -0.44028136134147644f;
                  _361 = ((_526 / ((_526 * _349) + 1.0f)) + 0.44028136134147644f);
                  _362 = _523;
                  _363 = _358;
                } else {
                  _361 = _345;
                  _362 = _523;
                  _363 = _358;
                }
              }
              while(true) {
                float _370 = (pow(_363, 0.012683313339948654f));
                float _371 = (pow(_362, 0.012683313339948654f));
                float _372 = (pow(_361, 0.012683313339948654f));
                _398 = exp2(log2(max((_370 + -0.8359375f), 0.0f) / (18.8515625f - (_370 * 18.6875f))) * 6.277394771575928f);
                _399 = exp2(log2(max((_371 + -0.8359375f), 0.0f) / (18.8515625f - (_371 * 18.6875f))) * 6.277394771575928f);
                _400 = exp2(log2(max((_372 + -0.8359375f), 0.0f) / (18.8515625f - (_372 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _361 = _345;
          _362 = _344;
          _363 = _343;
          while(true) {
            float _370 = (pow(_363, 0.012683313339948654f));
            float _371 = (pow(_362, 0.012683313339948654f));
            float _372 = (pow(_361, 0.012683313339948654f));
            _398 = exp2(log2(max((_370 + -0.8359375f), 0.0f) / (18.8515625f - (_370 * 18.6875f))) * 6.277394771575928f);
            _399 = exp2(log2(max((_371 + -0.8359375f), 0.0f) / (18.8515625f - (_371 * 18.6875f))) * 6.277394771575928f);
            _400 = exp2(log2(max((_372 + -0.8359375f), 0.0f) / (18.8515625f - (_372 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _398 = _299;
        _399 = _300;
        _400 = _301;
      }
    } else {
      _398 = _299;
      _399 = _300;
      _400 = _301;
    }
  } else {
    _398 = _299;
    _399 = _300;
    _400 = _301;
  }

  CLAMP_IF_SDR(_398); CLAMP_IF_SDR(_399); CLAMP_IF_SDR(_400);
  CAPTURE_TONEMAPPED(float3(_398, _399, _400));

  float4 _422 = t2.Sample(s2, float3(((saturate((log2(_398 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_399 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_400 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _422.rgb = HandleLUTOutput(_422.rgb, untonemapped, tonemapped);

  float _426 = _422.x * 1.0499999523162842f;
  float _427 = _422.y * 1.0499999523162842f;
  float _428 = _422.z * 1.0499999523162842f;
  float _436 = ((_33 * 0.00390625f) + -0.001953125f) + _426;
  float _437 = ((_55 * 0.00390625f) + -0.001953125f) + _427;
  float _438 = ((_56 * 0.00390625f) + -0.001953125f) + _428;
  [branch]
  if (!((uint)(cb0_090w) == 0)) {
    float _450 = (pow(_436, 0.012683313339948654f));
    float _451 = (pow(_437, 0.012683313339948654f));
    float _452 = (pow(_438, 0.012683313339948654f));
    float _485 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_450 + -0.8359375f)) / (18.8515625f - (_450 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _486 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_451 + -0.8359375f)) / (18.8515625f - (_451 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _487 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_452 + -0.8359375f)) / (18.8515625f - (_452 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    _513 = min((_485 * 12.920000076293945f), ((exp2(log2(max(_485, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _514 = min((_486 * 12.920000076293945f), ((exp2(log2(max(_486, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _515 = min((_487 * 12.920000076293945f), ((exp2(log2(max(_487, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _513 = _436;
    _514 = _437;
    _515 = _438;
  }
  SV_Target.x = _513;
  SV_Target.y = _514;
  SV_Target.z = _515;

  SV_Target.w = (dot(float3(_426, _427, _428), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
