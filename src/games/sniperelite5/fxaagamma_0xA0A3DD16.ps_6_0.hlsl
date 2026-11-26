#include "./shared.h"

Texture2D<float4> g_xTexture : register(t0);

cbuffer FXAAGammaAndClampConsts : register(b0) {
  float g_fFXAALinearGamma : packoffset(c000.x);
  float g_fFXAAClampValue : packoffset(c000.y);
  float2 g_xRcpFrame : packoffset(c000.z);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _14 = dot(float3(_9.x, _9.y, _9.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float4 _15 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, 1));
  float _19 = dot(float3(_15.x, _15.y, _15.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float4 _20 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 0));
  float _24 = dot(float3(_20.x, _20.y, _20.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float4 _25 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, -1));
  float _29 = dot(float3(_25.x, _25.y, _25.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float4 _30 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 0));
  float _34 = dot(float3(_30.x, _30.y, _30.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _35 = max(_19, _14);
  float _36 = min(_19, _14);
  float _37 = max(_24, _35);
  float _38 = min(_24, _36);
  float _39 = max(_29, _34);
  float _40 = min(_29, _34);
  float _41 = max(_39, _37);
  float _42 = min(_40, _38);
  float _43 = _41 * 0.1666666716337204f;
  float _44 = _41 - _42;
  float _45 = max(0.0833333358168602f, _43);
  bool _46 = (_44 < _45);
  float _105;
  float _108;
  float _111;
  float _123;
  float _133;
  float _138;
  float _160;
  float _177;
  float _182;
  float _188;
  float _193;
  float _202;
  float _210;
  float _214;
  float _218;
  float _227;
  float _232;
  float _237;
  float _242;
  float _243;
  float _244;
  float _245;
  float _246;
  float _247;
  float _253;
  float _257;
  float _276;
  float _281;
  float _287;
  float _288;
  float _289;
  float _290;
  [branch]
  if (!_46) {
    float4 _48 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, -1));
    float _52 = dot(float3(_48.x, _48.y, _48.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float4 _53 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 1));
    float _57 = dot(float3(_53.x, _53.y, _53.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float4 _58 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, -1));
    float _62 = dot(float3(_58.x, _58.y, _58.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float4 _63 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 1));
    float _67 = dot(float3(_63.x, _63.y, _63.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float _68 = _29 + _19;
    float _69 = _34 + _24;
    float _70 = 1.0f / _44;
    float _71 = _69 + _68;
    float _72 = _14 * 2.0f;
    float _73 = _68 - _72;
    float _74 = _69 - _72;
    float _75 = _62 + _57;
    float _76 = _52 + _62;
    float _77 = _24 * 2.0f;
    float _78 = _75 - _77;
    float _79 = _29 * 2.0f;
    float _80 = _76 - _79;
    float _81 = _67 + _52;
    float _82 = _57 + _67;
    float _83 = abs(_73);
    float _84 = _83 * 2.0f;
    float _85 = abs(_78);
    float _86 = _84 + _85;
    float _87 = abs(_74);
    float _88 = _87 * 2.0f;
    float _89 = abs(_80);
    float _90 = _88 + _89;
    float _91 = _34 * 2.0f;
    float _92 = _81 - _91;
    float _93 = _19 * 2.0f;
    float _94 = _82 - _93;
    float _95 = abs(_92);
    float _96 = _86 + _95;
    float _97 = abs(_94);
    float _98 = _90 + _97;
    bool _99 = (_96 >= _98);
    float _100 = _71 * 2.0f;
    float _101 = _75 + _100;
    float _102 = _101 + _81;
    [branch]
    if (!_99) {
      _105 = _34;
    } else {
      _105 = _29;
    }
    [branch]
    if (!_99) {
      _108 = _24;
    } else {
      _108 = _19;
    }
    [branch]
    if (_99) {
      _111 = g_xRcpFrame.y;
    } else {
      _111 = g_xRcpFrame.x;
    }
    float _112 = _102 * 0.0833333358168602f;
    float _113 = _112 - _14;
    float _114 = _105 - _14;
    float _115 = _108 - _14;
    float _116 = abs(_114);
    float _117 = abs(_115);
    bool _118 = (_116 >= _117);
    float _119 = max(_116, _117);
    [branch]
    if (_118) {
      float _121 = -0.0f - _111;
      _123 = _121;
    } else {
      _123 = _111;
    }
    float _124 = abs(_113);
    float _125 = _124 * _70;
    float _126 = saturate(_125);
    float _127 = select(_99, g_xRcpFrame.x, 0.0f);
    float _128 = select(_99, 0.0f, g_xRcpFrame.y);
    [branch]
    if (!_99) {
      float _130 = _123 * 0.5f;
      float _131 = _130 + TEXCOORD.x;
      _133 = _131;
    } else {
      _133 = TEXCOORD.x;
    }
    [branch]
    if (_99) {
      float _135 = _123 * 0.5f;
      float _136 = _135 + TEXCOORD.y;
      _138 = _136;
    } else {
      _138 = TEXCOORD.y;
    }
    float _139 = _127 * 1.5f;
    float _140 = _133 - _139;
    float _141 = _128 * 1.5f;
    float _142 = _138 - _141;
    float _143 = _133 + _139;
    float _144 = _138 + _141;
    float _145 = _126 * 2.0f;
    float _146 = 3.0f - _145;
    float4 _147 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_140, _142), 0.0f);
    float _151 = dot(float3(_147.x, _147.y, _147.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float _152 = _126 * _126;
    float4 _153 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_143, _144), 0.0f);
    float _157 = dot(float3(_153.x, _153.y, _153.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    [branch]
    if (!_118) {
      _160 = _108;
    } else {
      _160 = _105;
    }
    float _161 = _14 + _160;
    float _162 = _119 * 0.25f;
    float _163 = _161 * 0.5f;
    float _164 = _14 - _163;
    float _165 = _152 * _146;
    bool _166 = (_164 < 0.0f);
    float _167 = _151 - _163;
    float _168 = _157 - _163;
    float _169 = abs(_167);
    bool _170 = (_169 >= _162);
    float _171 = abs(_168);
    bool _172 = (_171 >= _162);
    [branch]
    if (!_170) {
      float _174 = _127 * 2.0f;
      float _175 = _140 - _174;
      _177 = _175;
    } else {
      _177 = _140;
    }
    [branch]
    if (!_170) {
      float _179 = _128 * 2.0f;
      float _180 = _142 - _179;
      _182 = _180;
    } else {
      _182 = _142;
    }
    bool _183 = _170 && _172;
    [branch]
    if (!_172) {
      float _185 = _127 * 2.0f;
      float _186 = _143 + _185;
      _188 = _186;
    } else {
      _188 = _143;
    }
    [branch]
    if (!_172) {
      float _190 = _128 * 2.0f;
      float _191 = _144 + _190;
      _193 = _191;
    } else {
      _193 = _144;
    }
    [branch]
    if (!_183) {
      [branch]
      if (!_170) {
        float4 _196 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_177, _182), 0.0f);
        float _200 = dot(float3(_196.x, _196.y, _196.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
        _202 = _200;
      } else {
        _202 = _167;
      }
      [branch]
      if (!_172) {
        float4 _204 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_188, _193), 0.0f);
        float _208 = dot(float3(_204.x, _204.y, _204.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
        _210 = _208;
      } else {
        _210 = _168;
      }
      [branch]
      if (!_170) {
        float _212 = _202 - _163;
        _214 = _212;
      } else {
        _214 = _202;
      }
      [branch]
      if (!_172) {
        float _216 = _210 - _163;
        _218 = _216;
      } else {
        _218 = _210;
      }
      float _219 = abs(_214);
      bool _220 = (_219 >= _162);
      float _221 = abs(_218);
      bool _222 = (_221 >= _162);
      [branch]
      if (!_220) {
        float _224 = _127 * 8.0f;
        float _225 = _177 - _224;
        _227 = _225;
      } else {
        _227 = _177;
      }
      [branch]
      if (!_220) {
        float _229 = _128 * 8.0f;
        float _230 = _182 - _229;
        _232 = _230;
      } else {
        _232 = _182;
      }
      [branch]
      if (!_222) {
        float _234 = _127 * 8.0f;
        float _235 = _188 + _234;
        _237 = _235;
      } else {
        _237 = _188;
      }
      [branch]
      if (!_222) {
        float _239 = _128 * 8.0f;
        float _240 = _193 + _239;
        _242 = _227;
        _243 = _232;
        _244 = _237;
        _245 = _240;
        _246 = _214;
        _247 = _218;
      } else {
        _242 = _227;
        _243 = _232;
        _244 = _237;
        _245 = _193;
        _246 = _214;
        _247 = _218;
      }
    } else {
      _242 = _177;
      _243 = _182;
      _244 = _188;
      _245 = _193;
      _246 = _167;
      _247 = _168;
    }
    float _248 = TEXCOORD.x - _242;
    float _249 = _244 - TEXCOORD.x;
    [branch]
    if (!_99) {
      float _251 = TEXCOORD.y - _243;
      _253 = _251;
    } else {
      _253 = _248;
    }
    [branch]
    if (!_99) {
      float _255 = _245 - TEXCOORD.y;
      _257 = _255;
    } else {
      _257 = _249;
    }
    bool _258 = (_246 < 0.0f);
    float _259 = _257 + _253;
    bool _260 = (_247 < 0.0f);
    float _261 = 1.0f / _259;
    bool _262 = (_253 < _257);
    float _263 = min(_253, _257);
    bool _264 = select(_262, _258, _260);
    bool _265 = _166 ^ _264;
    float _266 = _263 * _261;
    float _267 = 0.5f - _266;
    float _268 = _165 * _165;
    float _269 = _268 * 0.75f;
    float _270 = select(_265, _267, 0.0f);
    float _271 = max(_270, _269);
    [branch]
    if (!_99) {
      float _273 = _271 * _123;
      float _274 = _273 + TEXCOORD.x;
      _276 = _274;
    } else {
      _276 = TEXCOORD.x;
    }
    [branch]
    if (_99) {
      float _278 = _271 * _123;
      float _279 = _278 + TEXCOORD.y;
      _281 = _279;
    } else {
      _281 = TEXCOORD.y;
    }
    float4 _282 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_276, _281), 0.0f);
    _287 = _282.x;
    _288 = _282.y;
    _289 = _282.z;
    _290 = _14;
  } else {
    _287 = _9.x;
    _288 = _9.y;
    _289 = _9.z;
    _290 = _9.w;
  }
  // RenoDX: output the FXAA colour before the gamma pow and clamp
  SV_Target.x = _287;
  SV_Target.y = _288;
  SV_Target.z = _289;
  SV_Target.w = 1.0f;
  return SV_Target;
}
