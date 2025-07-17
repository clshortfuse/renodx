#include "./shared.h"

cbuffer _14_16 : register(b0, space0) { float4 _16_m0[45] : packoffset(c0); };

cbuffer _19_21 : register(b1, space0) { float4 _21_m0[235] : packoffset(c0); };

cbuffer _24_26 : register(b2, space0) { float4 _26_m0[8] : packoffset(c0); };

Texture2D<float4> _8 : register(t0, space0);  // noise
Texture2D<float4> _9 : register(t1, space0);  // render
SamplerState _29 : register(s0, space0);
SamplerState _30 : register(s1, space0);
SamplerState _31 : register(s2, space0);

float4 main(float4 gl_FragCoord : SV_Position) : SV_Target {
  uint4 _53 = asuint(_16_m0[37u]);
  float _65 = (gl_FragCoord.x - float(_53.x)) * _16_m0[38u].z;
  float _66 = (gl_FragCoord.y - float(_53.y)) * _16_m0[38u].w;
  float4 _96 = _9.Sample(
      _30, float2(min(max((_65 * _16_m0[5u].x) + _16_m0[4u].x, _16_m0[6u].x),
                      _16_m0[6u].z),
                  min(max((_66 * _16_m0[5u].y) + _16_m0[4u].y, _16_m0[6u].y),
                      _16_m0[6u].w)));
  if (CUSTOM_FISHEYE == 0.f) {
    return float4(_96.rgb, 1.f);
  }
  float _99 = _96.x;
  float _100 = _96.y;
  float _101 = _96.z;
  float _115 = _65 + (-0.5f);
  float _121 = _26_m0[2u].y * _115;
  float _122 = _66 + (-0.5f);
  float _129 =
      1.0f - (sqrt(dot(float2(_121, _122), float2(_121, _122))) / _26_m0[2u].z);
  float _132 = _26_m0[2u].w * _129;
  float _158 =
      _26_m0[3u].z * clamp(1.0f - clamp(((_26_m0[3u].x - _26_m0[3u].y) * (((_129 >= 0.0f) && (abs(_129) > 9.9999997473787516355514526367188e-06f)) ? (1.0f - (1.0f / exp2((_132 * _132) * 1.442695140838623046875f))) : 0.0f)) + _26_m0[3u].y, 0.0f, 1.0f), 0.0f, 1.0f);
  float _159 = (_21_m0[130u].x * 2.6041669798360089771449565887451e-07f) * _158;
  float _160 =
      ((_21_m0[130u].y / ((_21_m0[130u].y / _21_m0[130u].x) * 3840.0f)) * 0.001000000047497451305389404296875f) * _158;
  uint4 _163 = asuint(_16_m0[37u]);
  float _170 = (gl_FragCoord.x - float(_163.x)) * 0.015625f;
  float _172 = (gl_FragCoord.y - float(_163.y)) * 0.015625f;
  float4 _174 = _8.Sample(_29, float2(_170, _172));
  float _192 = _158 * 0.3333333432674407958984375f;
  float _207 =
      (((_174.x + (-0.5f)) / _26_m0[4u].x) * _159) * clamp(((_159 * _192) / _21_m0[130u].z) - _26_m0[4u].y, 0.0f, 1.0f);
  float _208 =
      (((_8.Sample(_29, float2(_170 + 0.5f, _172 + 0.5f)).x + (-0.5f)) / _26_m0[4u].x) * _160) * clamp(((_160 * _192) / _21_m0[130u].w) - _26_m0[4u].y, 0.0f, 1.0f);
  float _234 = min(max((_16_m0[5u].x * _65) + _16_m0[4u].x, _16_m0[6u].x),
                   _16_m0[6u].z)
               * 0.5f;
  float _235 = min(max((_16_m0[5u].y * _66) + _16_m0[4u].y, _16_m0[6u].y),
                   _16_m0[6u].w)
               * 0.5f;
  float _237;
  float _239;
  float _241;
  float _243;
  if (_26_m0[4u].y > 1.0f) {
    float _238;
    float _240;
    float _242;
    float _244;
    float _354;
    float _355;
    float _356;
    float _357;
    uint _358;
    float _344 = 0.0f;
    float _345 = 0.0f;
    float _346 = 0.0f;
    float _347 = 0.0f;
    uint _348 = 1u;
    float _350;
    float _353;
    for (;;) {
      _350 = float(int(_348));
      _353 = ((_350 / _26_m0[4u].y) + (-0.5f)) * _160;
      _354 = _344;
      _355 = _345;
      _356 = _346;
      _357 = _347;
      _358 = 1u;
      for (;;) {
        float _360 = float(int(_358));
        float _380 = _26_m0[4u].y * 0.5f;
        float _381 = _350 - _380;
        float _383 = _360 - _380;
        float _388 =
            clamp(_380 - sqrt((_383 * _383) + (_381 * _381)), 0.0f, 1.0f);
        float4 _390 = _9.Sample(
            _31,
            float2(min(max(((((_360 / _26_m0[4u].y) + (-0.5f)) * _159) + _207) + (_234 * 2.0f),
                           _16_m0[6u].x),
                       _16_m0[6u].z),
                   min(max((_353 + _208) + (_235 * 2.0f), _16_m0[6u].y),
                       _16_m0[6u].w)));
        _238 = (_390.x * _388) + _354;
        _240 = (_390.y * _388) + _355;
        _242 = (_390.z * _388) + _356;
        _244 = _388 + _357;
        uint _359 = _358 + 1u;
        if (float(int(_359)) < _26_m0[4u].y) {
          _354 = _238;
          _355 = _240;
          _356 = _242;
          _357 = _244;
          _358 = _359;
        } else {
          break;
        }
      }
      uint _349 = _348 + 1u;
      if (float(int(_349)) < _26_m0[4u].y) {
        _344 = _238;
        _345 = _240;
        _346 = _242;
        _347 = _244;
        _348 = _349;
        continue;
      } else {
        break;
      }
    }
    _237 = _238;
    _239 = _240;
    _241 = _242;
    _243 = _244;
  } else {
    _237 = 0.0f;
    _239 = 0.0f;
    _241 = 0.0f;
    _243 = 0.0f;
  }
  float _245 = _237 / _243;
  float _246 = _239 / _243;
  float _247 = _241 / _243;
  float _257 = _26_m0[5u].x * _115;
  float _264 =
      1.0f - (sqrt(dot(float2(_257, _122), float2(_257, _122))) / _26_m0[5u].y);
  float _266 = _26_m0[5u].z * _264;
  float _292 = clamp(
      (clamp(
           1.0f - clamp(((_26_m0[5u].w - _26_m0[6u].x) * (((_264 >= 0.0f) && (abs(_264) > 9.9999997473787516355514526367188e-06f)) ? (1.0f - (1.0f / exp2((_266 * _266) * 1.442695140838623046875f))) : 0.0f)) + _26_m0[6u].x, 0.0f, 1.0f),
           0.0f, 1.0f)
       - _26_m0[6u].y)
          / (_26_m0[6u].z - _26_m0[6u].y),
      0.0f, 1.0f);
  float _298 = (_292 * _292) * (3.0f - (_292 * 2.0f));
  float _315 = (((_245 - _99) + (_298 * ((_26_m0[4u].z * _245) - _245))) * _26_m0[6u].w) + _99;
  float _316 = (((_246 - _100) + (_298 * ((_26_m0[4u].z * _246) - _246))) * _26_m0[6u].w) + _100;
  float _317 = (((_247 - _101) + (_298 * ((_26_m0[4u].z * _247) - _247))) * _26_m0[6u].w) + _101;
  float4 SV_Target;
  SV_Target.x = max(((_26_m0[1u].x - _315) * _26_m0[7u].x) + _315, 0.0f);
  SV_Target.y = max(((_26_m0[1u].y - _316) * _26_m0[7u].x) + _316, 0.0f);
  SV_Target.z = max(((_26_m0[1u].z - _317) * _26_m0[7u].x) + _317, 0.0f);
  SV_Target.w = 1.0f;

  SV_Target.rgb = lerp(_96.rgb, SV_Target.rgb, CUSTOM_FISHEYE);

  return SV_Target;
}
