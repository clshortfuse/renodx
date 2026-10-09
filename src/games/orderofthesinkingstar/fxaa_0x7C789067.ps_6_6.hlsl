// CUSTOM: RenoDX control data.
#include "./shared.h"

Texture2D<float4> tex : register(t0);

cbuffer cb_shader : register(b0) {
  float2 texel_size : packoffset(c000.x);
};

SamplerState Sampler_Linear_Clamp : register(s6);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _12;
  float4 _15;
  float4 _18;
  float4 _22;
  float4 _25;
  float _29;
  float _31;
  float _33;
  float _35;
  float _37;
  float _45;
  float _46;
  float _173;
  float _174;
  float _175;
  float _176;
  float _177;
  float _178;
  int _179;
  int _180;
  int _181;
  float _192;
  float _203;
  bool _209;
  bool _216;
  float _231;
  float _232;
  float _233;
  float _234;
  float _279;
  float _280;
  float _281;
  float _55;
  float _65;
  float4 _66;
  float4 _70;
  float4 _74;
  float4 _78;
  float _107;
  float _109;
  float _111;
  float _113;
  bool _145;
  float _146;
  float _148;
  float _149;
  float _151;
  float _153;
  bool _154;
  float _158;
  float _159;
  float _160;
  float _162;
  float _164;
  float _165;
  float _166;
  float _167;
  bool _182;
  float4 _186;
  bool _193;
  float4 _197;
  int _210;
  int _219;
  float _222;
  float _223;
  float _226;
  float _227;
  int _228;
  float _239;
  float _240;
  bool _241;
  float _254;
  float4 _261;
  float _268;
  _12 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, -1));
  _15 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 0));
  _18 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  _22 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 0));
  _25 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, 1));
  _29 = (_12.y * 1.9632108211517334f) + _12.x;
  _31 = (_15.y * 1.9632108211517334f) + _15.x;
  _33 = (_18.y * 1.9632108211517334f) + _18.x;
  _35 = (_22.y * 1.9632108211517334f) + _22.x;
  _37 = (_25.y * 1.9632108211517334f) + _25.x;
  _45 = max(_33, max(max(_29, _31), max(_37, _35)));
  _46 = _45 - min(_33, min(min(_29, _31), min(_37, _35)));
  if (!(_46 < max(0.0416666679084301f, (_45 * 0.125f)))) {
    _55 = _35 + _31;
    _65 = min(0.75f, (max(0.0f, ((abs((((_55 + _29) + _37) * 0.25f) - _33) / _46) + -0.25f)) * 1.3333333730697632f));
    _66 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, -1));
    _70 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, -1));
    _74 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 1));
    _78 = tex.SampleLevel(Sampler_Linear_Clamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 1));
    _107 = (_66.y * 1.9632108211517334f) + _66.x;
    _109 = (_70.y * 1.9632108211517334f) + _70.x;
    _111 = (_74.y * 1.9632108211517334f) + _74.x;
    _113 = (_78.y * 1.9632108211517334f) + _78.x;
    _145 = (((abs(((_37 + _29) * 0.5f) - _33) + abs(((_111 + _107) * 0.25f) - (_31 * 0.5f))) + abs(((_113 + _109) * 0.25f) - (_35 * 0.5f))) >= ((abs((_55 * 0.5f) - _33) + abs(((_109 + _107) * 0.25f) - (_29 * 0.5f))) + abs(((_113 + _111) * 0.25f) - (_37 * 0.5f))));
    _146 = select(_145, texel_size.y, texel_size.x);
    _148 = select(_145, _29, _31);
    _149 = select(_145, _37, _35);
    _151 = abs(_148 - _33);
    _153 = abs(_149 - _33);
    _154 = (_151 >= _153);
    _158 = (_33 + select(_154, _148, _149)) * 0.5f;
    _159 = select(_154, (-0.0f - _146), _146);
    _160 = _159 * 0.5f;
    _162 = select(_145, 0.0f, _160) + TEXCOORD.x;
    _164 = select(_145, _160, 0.0f) + TEXCOORD.y;
    _165 = select(_154, _151, _153) * 0.25f;
    _166 = select(_145, texel_size.x, 0.0f);
    _167 = select(_145, 0.0f, texel_size.y);
    _173 = (_162 - _166);
    _174 = (_164 - _167);
    _175 = (_162 + _166);
    _176 = (_164 + _167);
    _177 = _158;
    _178 = _158;
    _179 = 0;
    _180 = 0;
    _181 = 0;
    bool _loop_break_0 = false;
    bool _loop_exit_0 = false;
    while (true) {
      _182 = (_179 == 0);
      do {
        _192 = _177;
        if (_182) {
          _186 = tex.SampleLevel(Sampler_Linear_Clamp, float2(_173, _174), 0.0f);
          _192 = ((_186.y * 1.9632108211517334f) + _186.x);
        }
        _193 = (_180 == 0);
        do {
          _203 = _178;
          if (_193) {
            _197 = tex.SampleLevel(Sampler_Linear_Clamp, float2(_175, _176), 0.0f);
            _203 = ((_197.y * 1.9632108211517334f) + _197.x);
          }
          do {
            _209 = true;
            if (_182) {
              _209 = (abs(_192 - _158) >= _165);
            }
            _210 = (int)(uint)(_209);
            do {
              _216 = true;
              if (_193) {
                _216 = (abs(_203 - _158) >= _165);
              }
              do {
                _231 = _173;
                _232 = _174;
                _233 = _175;
                _234 = _176;
                if (!(_209 && _216)) {
                  _219 = (int)(uint)(_216);
                  _222 = select(_209, _173, (_173 - _166));
                  _223 = select(_209, _174, (_174 - _167));
                  _226 = select(_216, _175, (_175 + _166));
                  _227 = select(_216, _176, (_176 + _167));
                  _228 = _181 + 1;
                  if ((int)_228 < (int)16) {
                    _173 = _222;
                    _174 = _223;
                    _175 = _226;
                    _176 = _227;
                    _177 = _192;
                    _178 = _203;
                    _179 = _210;
                    _180 = _219;
                    _181 = _228;
                    _loop_break_0 = true;
                    break;
                  } else {
                    _231 = _222;
                    _232 = _223;
                    _233 = _226;
                    _234 = _227;
                  }
                }
                _239 = select(_145, (TEXCOORD.x - _231), (TEXCOORD.y - _232));
                _240 = select(_145, (_233 - TEXCOORD.x), (_234 - TEXCOORD.y));
                _241 = (_239 < _240);
                _254 = select((((_33 - _158) < 0.0f) ^ ((select(_241, _192, _203) - _158) < 0.0f)), _159, 0.0f) * ((select(_241, _239, _240) * (-1.0f / (_240 + _239))) + 0.5f);
                _261 = tex.SampleLevel(Sampler_Linear_Clamp, float2((select(_145, 0.0f, _254) + TEXCOORD.x), (select(_145, _254, 0.0f) + TEXCOORD.y)), 0.0f);
                _268 = _65 * 0.1111111119389534f;
                _279 = ((_261.x + (((((((((_15.x + _12.x) + _18.x) + _22.x) + _25.x) + _66.x) + _70.x) + _74.x) + _78.x) * _268)) - (_261.x * _65));
                _280 = ((_261.y + (((((((((_15.y + _12.y) + _18.y) + _22.y) + _25.y) + _66.y) + _70.y) + _74.y) + _78.y) * _268)) - (_261.y * _65));
                _281 = ((_261.z + (((((((((_15.z + _12.z) + _18.z) + _22.z) + _25.z) + _66.z) + _70.z) + _74.z) + _78.z) * _268)) - (_261.z * _65));
              } while (false);
              if ((_loop_break_0 || _loop_exit_0)) break;
            } while (false);
            if ((_loop_break_0 || _loop_exit_0)) break;
          } while (false);
          if ((_loop_break_0 || _loop_exit_0)) break;
        } while (false);
        if ((_loop_break_0 || _loop_exit_0)) break;
      } while (false);
      if (_loop_break_0) {
        _loop_break_0 = false;
        continue;
      }
      break;
    }
  } else {
    _279 = _18.x;
    _280 = _18.y;
    _281 = _18.z;
  }
  SV_Target.x = _279;
  SV_Target.y = _280;
  SV_Target.z = _281;
  SV_Target.w = 1.0f;
  // CUSTOM: Blend the center sample with the untouched vanilla FXAA result.
  if (RENODX_PEAK_WHITE_NITS > 0.f && CUSTOM_FXAA < 1.0f) {
    SV_Target.rgb = lerp(_18.rgb, SV_Target.rgb, CUSTOM_FXAA);
  }
  return SV_Target;
}
