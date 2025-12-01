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
  float _239;
  float _240;
  float _241;
  float _273;
  float _274;
  float _275;
  float _322;
  float _323;
  float _324;
  float _381;
  float _384;
  float _385;
  float _386;
  float _421;
  float _422;
  float _423;
  float _536;
  float _537;
  float _538;
  float _546;
  if (cb0_080x > 0.0f) {
    _57 = (((frac((sin(_32 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _35) * cb0_080x) + _35);
    _58 = (((frac((sin(_32 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _35) * cb0_080x) + _35);
  } else {
    _57 = _35;
    _58 = _35;
  }
  float _63 = cb0_079z * (1.0f - (_35 * _35));
  float _68 = (_63 * (TEXCOORD_2.x - _29)) + _29;
  float _69 = (_63 * (TEXCOORD_2.y - _30)) + _30;
  float4 _80 = t0.Sample(s0, float2(min(max(_68, cb0_053z), cb0_054x), min(max(_69, cb0_053w), cb0_054y)));

  float4 _108 = t1.Sample(s1, float2(min(max(((cb0_068z * _68) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _69) + cb0_069y), cb0_060w), cb0_061y)));
 _108.rgb *= RENODX_WUWA_BLOOM;

 float _136 = TEXCOORD_1.z + -1.0f;
  float _138 = TEXCOORD_1.w + -1.0f;
  float _141 = (((cb0_074x * 2.0f) + _136) * cb0_072z) * cb0_072x;
  float _143 = (((cb0_074y * 2.0f) + _138) * cb0_072w) * cb0_072x;
  float _150 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_141, _143), float2(_141, _143))) + 1.0f);
  float _151 = _150 * _150;
  float _152 = cb0_074z + 1.0f;
  float _180 = (((cb0_077x * 2.0f) + _136) * cb0_075z) * cb0_075x;
  float _182 = (((cb0_077y * 2.0f) + _138) * cb0_075w) * cb0_075x;
  float _189 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_180, _182), float2(_180, _182))) + 1.0f);
  float _190 = _189 * _189;
  float _191 = cb0_077z + 1.0f;
  float _202 = (((_151 * (_152 - cb0_073x)) + cb0_073x) * (_108.x + ((_80.x * TEXCOORD_1.x) * cb0_070x))) * ((_190 * (_191 - cb0_076x)) + cb0_076x);
  float _204 = (((_151 * (_152 - cb0_073y)) + cb0_073y) * (_108.y + ((_80.y * TEXCOORD_1.x) * cb0_070y))) * ((_190 * (_191 - cb0_076y)) + cb0_076y);
  float _206 = (((_151 * (_152 - cb0_073z)) + cb0_073z) * (_108.z + ((_80.z * TEXCOORD_1.x) * cb0_070z))) * ((_190 * (_191 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(float3(_202, _204, _206));

  [branch]
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    _239 = ((((_202 * 1.3600000143051147f) + 0.04699999839067459f) * _202) / ((((_202 * 0.9599999785423279f) + 0.5600000023841858f) * _202) + 0.14000000059604645f));
    _240 = ((((_204 * 1.3600000143051147f) + 0.04699999839067459f) * _204) / ((((_204 * 0.9599999785423279f) + 0.5600000023841858f) * _204) + 0.14000000059604645f));
    _241 = ((((_206 * 1.3600000143051147f) + 0.04699999839067459f) * _206) / ((((_206 * 0.9599999785423279f) + 0.5600000023841858f) * _206) + 0.14000000059604645f));
  } else {
    _239 = _202;
    _240 = _204;
    _241 = _206;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _251 = 1.0049500465393066f - (0.16398000717163086f / (_239 + -0.19505000114440918f));
    float _252 = 1.0049500465393066f - (0.16398000717163086f / (_240 + -0.19505000114440918f));
    float _253 = 1.0049500465393066f - (0.16398000717163086f / (_241 + -0.19505000114440918f));
    _273 = (((_239 - _251) * select((_239 > 0.6000000238418579f), 0.0f, 1.0f)) + _251);
    _274 = (((_240 - _252) * select((_240 > 0.6000000238418579f), 0.0f, 1.0f)) + _252);
    _275 = (((_241 - _253) * select((_241 > 0.6000000238418579f), 0.0f, 1.0f)) + _253);
  } else {
    _273 = _239;
    _274 = _240;
    _275 = _241;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _281 = cb0_037y * _273;
    float _282 = cb0_037y * _274;
    float _283 = cb0_037y * _275;
    float _286 = cb0_037z * cb0_037w;
    float _296 = cb0_038y * cb0_038x;
    float _307 = cb0_038z * cb0_038x;
    float _314 = cb0_038y / cb0_038z;
    _322 = (((((_286 + _281) * _273) + _296) / (((_281 + cb0_037z) * _273) + _307)) - _314);
    _323 = (((((_286 + _282) * _274) + _296) / (((_282 + cb0_037z) * _274) + _307)) - _314);
    _324 = (((((_286 + _283) * _275) + _296) / (((_283 + cb0_037z) * _275) + _307)) - _314);
  } else {
    _322 = _273;
    _323 = _274;
    _324 = _275;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!(cb0_090x == 1.0f)) {
      float _333 = dot(float3(_322, _323, _324), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_333 <= 9.999999747378752e-05f)) {
        float _342 = (pow(_322, 0.1593017578125f));
        float _343 = (pow(_323, 0.1593017578125f));
        float _344 = (pow(_324, 0.1593017578125f));
        float _366 = exp2(log2(((_342 * 18.8515625f) + 0.8359375f) / ((_342 * 18.6875f) + 1.0f)) * 78.84375f);
        float _367 = exp2(log2(((_343 * 18.8515625f) + 0.8359375f) / ((_343 * 18.6875f) + 1.0f)) * 78.84375f);
        float _368 = exp2(log2(((_344 * 18.8515625f) + 0.8359375f) / ((_344 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_333 * 200.0f) > 1.0f) {
          float _372 = 1.0f - cb0_090x;
          do {
            if (_366 > 0.44028136134147644f) {
              float _375 = _366 + -0.44028136134147644f;
              _381 = ((_375 / ((_375 * _372) + 1.0f)) + 0.44028136134147644f);
            } else {
              _381 = _366;
            }
            do {
              if (_367 > 0.44028136134147644f) {
                float _540 = _367 + -0.44028136134147644f;
                _546 = ((_540 / ((_540 * _372) + 1.0f)) + 0.44028136134147644f);
                if (_368 > 0.44028136134147644f) {
                  float _549 = _368 + -0.44028136134147644f;
                  _384 = ((_549 / ((_549 * _372) + 1.0f)) + 0.44028136134147644f);
                  _385 = _546;
                  _386 = _381;
                } else {
                  _384 = _368;
                  _385 = _546;
                  _386 = _381;
                }
              } else {
                _546 = _367;
                if (_368 > 0.44028136134147644f) {
                  float _549 = _368 + -0.44028136134147644f;
                  _384 = ((_549 / ((_549 * _372) + 1.0f)) + 0.44028136134147644f);
                  _385 = _546;
                  _386 = _381;
                } else {
                  _384 = _368;
                  _385 = _546;
                  _386 = _381;
                }
              }
              while(true) {
                float _393 = (pow(_386, 0.012683313339948654f));
                float _394 = (pow(_385, 0.012683313339948654f));
                float _395 = (pow(_384, 0.012683313339948654f));
                _421 = exp2(log2(max((_393 + -0.8359375f), 0.0f) / (18.8515625f - (_393 * 18.6875f))) * 6.277394771575928f);
                _422 = exp2(log2(max((_394 + -0.8359375f), 0.0f) / (18.8515625f - (_394 * 18.6875f))) * 6.277394771575928f);
                _423 = exp2(log2(max((_395 + -0.8359375f), 0.0f) / (18.8515625f - (_395 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _384 = _368;
          _385 = _367;
          _386 = _366;
          while(true) {
            float _393 = (pow(_386, 0.012683313339948654f));
            float _394 = (pow(_385, 0.012683313339948654f));
            float _395 = (pow(_384, 0.012683313339948654f));
            _421 = exp2(log2(max((_393 + -0.8359375f), 0.0f) / (18.8515625f - (_393 * 18.6875f))) * 6.277394771575928f);
            _422 = exp2(log2(max((_394 + -0.8359375f), 0.0f) / (18.8515625f - (_394 * 18.6875f))) * 6.277394771575928f);
            _423 = exp2(log2(max((_395 + -0.8359375f), 0.0f) / (18.8515625f - (_395 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _421 = _322;
        _422 = _323;
        _423 = _324;
      }
    } else {
      _421 = _322;
      _422 = _323;
      _423 = _324;
    }
  } else {
    _421 = _322;
    _422 = _323;
    _423 = _324;
  }

  CLAMP_IF_SDR(_421); CLAMP_IF_SDR(_422); CLAMP_IF_SDR(_423);
  CAPTURE_TONEMAPPED(float3(_421, _422, _423));

  float4 _445 = t2.Sample(s2, float3(((saturate((log2(_421 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_422 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_423 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _445.rgb = HandleLUTOutput(_445.rgb, untonemapped, tonemapped);

  float _449 = _445.x * 1.0499999523162842f;
  float _450 = _445.y * 1.0499999523162842f;
  float _451 = _445.z * 1.0499999523162842f;
  float _459 = ((_35 * 0.00390625f) + -0.001953125f) + _449;
  float _460 = ((_57 * 0.00390625f) + -0.001953125f) + _450;
  float _461 = ((_58 * 0.00390625f) + -0.001953125f) + _451;
  [branch]
  if (!((uint)(cb0_090w) == 0)) {
    float _473 = (pow(_459, 0.012683313339948654f));
    float _474 = (pow(_460, 0.012683313339948654f));
    float _475 = (pow(_461, 0.012683313339948654f));
    float _508 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_473 + -0.8359375f)) / (18.8515625f - (_473 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _509 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_474 + -0.8359375f)) / (18.8515625f - (_474 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _510 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_475 + -0.8359375f)) / (18.8515625f - (_475 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    _536 = min((_508 * 12.920000076293945f), ((exp2(log2(max(_508, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _537 = min((_509 * 12.920000076293945f), ((exp2(log2(max(_509, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _538 = min((_510 * 12.920000076293945f), ((exp2(log2(max(_510, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _536 = _459;
    _537 = _460;
    _538 = _461;
  }
  SV_Target.x = _536;
  SV_Target.y = _537;
  SV_Target.z = _538;

  SV_Target.w = (dot(float3(_449, _450, _451), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
