// Intro
#version 450

#include "./common.slang"

layout(set = 2, binding = 0, std140) uniform _183_185 {
  vec4 _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10[3];
}
_185;

layout(set = 0, binding = 0, std140) uniform _242_244 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  vec4 _m5;
  vec4 _m6;
  vec4 _m7;
  vec4 _m8;
  vec4 _m9;
  vec4 _m10;
  vec4 _m11;
  vec4 _m12;
  vec4 _m13;
  vec4 _m14;
  float _m15;
  float _m16;
  float _m17;
  float _m18;
  float _m19;
  float _m20;
  float _m21;
  float _m22;
  float _m23;
  float _m24;
  float _m25;
  float _m26;
  float _m27;
  float _m28;
  float _m29;
  float _m30;
  float _m31;
  float _m32;
  uint _m33;
  float _m34;
  float _m35;
  float _m36;
  float _m37;
  float _m38;
  float _m39;
  float _m40;
  float _m41;
  float _m42;
  float _m43;
  float _m44;
  float _m45;
  float _m46[1];
}
_244;

layout(set = 0, binding = 1, std140) uniform _271_273 {
  vec4 _m0[64];
}
_273;

layout(set = 1, binding = 0, std140) uniform _275_277 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  float _m3;
  int _m4;
  uint _m5;
  float _m6[1];
}
_277;

layout(set = 2, binding = 1) uniform texture2D _74;
layout(set = 0, binding = 3) uniform SamplerState _78;
layout(set = 2, binding = 2) uniform texture2D _102;
layout(set = 2, binding = 3) uniform texture2D _121;
layout(set = 2, binding = 4) uniform texture2D _210;

layout(location = 2) in vec4 _84;
layout(location = 0) out vec4 _235;
layout(location = 0) in vec4 _237;
uint _14;
uint _16;
uint _18;
uint _20;
uint _22;
uint _24;
uint _26;
uint _27;
uint _29;
uint _30;
uint _32;
uint _34;
uint _36;
uint _38;
uint _40;
uint _42;
uint _44;
uint _46;
uint _48;

float _10(float _9) {
  return clamp(_9, 0.0, 1.0);
}

void main() {
  _14 = 2147483648u;
  _16 = 1073741824u;
  _18 = 0u;
  _20 = 268435456u;
  _22 = 536870912u;
  _24 = 805306368u;
  _26 = 1073741824u;
  _27 = 1342177280u;
  _29 = 0u;
  _30 = 16777216u;
  _32 = 33554432u;
  _34 = 50331648u;
  _36 = 67108864u;
  _38 = 83886080u;
  _40 = 100663296u;
  _42 = 117440512u;
  _44 = 134217728u;
  _46 = 150994944u;
  _48 = 167772160u;
  vec3 _58 = vec3(1.595794677734375, -0.8134765625, 0.0);
  vec3 _62 = vec3(0.0, -0.391448974609375, 2.017822265625);
  vec3 _66 = vec3(-0.870655059814453125, 0.529705047607421875, -1.081668853759765625);
  float _71 = _74.Sample(_78, _84.xy).x;
  float _101 = _102.Sample(_78, _84.xy).x;
  float _120 = _121.Sample(_78, _84.xy).x;
  vec3 _139 = vec3(_71 * 1.16412353515625);
  _139 += (((_58 * _101) + (_62 * _120)) + _66);
  bool _160 = _84.x >= 0.0;
  bool _166;
  if (_160) {
    _166 = _84.x <= 1.0;
  } else {
    _166 = _160;
  }
  bool _173;
  if (_166) {
    _173 = _84.y >= 0.0;
  } else {
    _173 = _166;
  }
  bool _179;
  if (_173) {
    _179 = _84.y <= 1.0;
  } else {
    _179 = _173;
  }
  float _155 = float(_179);
  float _181 = _185._m7;
  float _191 = float(_181 >= 2.0) * (1.0 - _155);
  _139 *= (1.0 - _191);
  float _203 = 1.0;
  if (_185._m9 > 0.0) {
    _203 = _210.Sample(_78, _84.xy).x;
  }
  float _222 = float(_181 == 3.0) * (1.0 - _155);
  _203 *= (1.0 - _222);
  vec3 _248 = (_139 * _237.xyz) * _244._m45;
  _235 = vec4(_248.x, _248.y, _248.z, _235.w);
  _235.w = _203 * _237.w;
  float _257 = _235.w;
  _235.w = _10(_257);
  vec3 _266 = _235.xyz * _235.w;
  _235 = vec4(_266.x, _266.y, _266.z, _235.w);

  // Special handling for intro, before final shader is spawned
  if (!CUSTOM_OUTPUT_SHADER_DRAWN) {
    _235.rgb = renodx::color::srgb::DecodeSafe(_235.rgb);
    _235 = saturate(_235);
    _235.xyz = renodx::color::correct::GammaSafe(_235.xyz);
    _235.xyz = renodx::color::bt2020::from::BT709(_235.xyz);
    _235.xyz = renodx::color::pq::EncodeSafe(_235.xyz, RENODX_GRAPHICS_WHITE_NITS);
  }
}

