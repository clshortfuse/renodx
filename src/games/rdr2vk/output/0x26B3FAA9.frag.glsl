#version 450

#extension GL_GOOGLE_include_directive : require
#include "./output.glsl"

#extension GL_EXT_scalar_block_layout : require

struct _9 {
  vec4 _m0;
  ivec4 _m1;
  vec4 _m2;
  ivec4 _m3;
  int _m4;
  int _m5;
  int _m6;
  int _m7;
  int _m8;
  uint _m9;
  float _m10;
};

vec3 _82;

layout(set = 0, binding = 96, scalar) readonly buffer _8_10 {
  _9 _m0[];
}
_10;

layout(set = 0, binding = 23, std140) uniform _13_14 {
  float _m0;
  float _m1;
  uint _m2;
  uint _m3;
  uint _m4;
  uint _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  float _m15;
  uint _m16;
  uint _m17;
  uint _m18;
  uint _m19;
}
_14;

layout(set = 1, binding = 22, std140) uniform _15_16 {
  vec4 _m0[2];
  vec4 _m1[2];
  vec4 _m2[2];
  vec4 _m3;
  vec4 _m4;
  vec4 _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
}
_16;

layout(set = 1, binding = 34) uniform sampler _7;
layout(set = 1, binding = 37) uniform sampler _17;
layout(set = 1, binding = 128) uniform texture2D _18;
layout(set = 0, binding = 131) uniform texture3D _19;

layout(location = 0) in vec2 _4;
layout(location = 0) out vec4 _5;

void main() {
  vec4 _88 = texture(sampler2D(_18, _17), _4);
  vec4 _94 = (_88 * _16._m5) + _16._m4;
  vec4 _107;
  if (floatBitsToInt(_16._m10) != 0) {
    vec4 _105 = textureLod(sampler3D(_19, _7), _94.xyz, 0.0);
    _107 = vec4(_105.x, _105.y, _105.z, _94.w);
  } else {
    _107 = _94;
  }
  vec4 _157;
  if (floatBitsToInt(_16._m7) != 0) {
#if 1
    _107.rgb = GammaSafe(_107.rgb);
#endif

    vec3 _119 = _107.xyz * mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375));
    float _130 = pow(abs((_119.x * _14._m0) / _14._m15), 0.1593017578125);
    vec3 _137;
    _137.x = pow((0.8359375 + (18.8515625 * _130)) / (1.0 + (18.6875 * _130)), 78.84375);
    float _139 = pow(abs((_119.y * _14._m0) / _14._m15), 0.1593017578125);
    _137.y = pow((0.8359375 + (18.8515625 * _139)) / (1.0 + (18.6875 * _139)), 78.84375);
    float _148 = pow(abs((_119.z * _14._m0) / _14._m15), 0.1593017578125);
    _137.z = pow((0.8359375 + (18.8515625 * _148)) / (1.0 + (18.6875 * _148)), 78.84375);
    _157 = vec4(_137.x, _137.y, _137.z, _107.w);
  } else {
    _157 = _107;
  }
  vec3 _165 = mix(_157.xyz * _157.www, _157.xyz, bvec3(_16._m6 == 0.0));
  vec4 _166 = vec4(_165.x, _165.y, _165.z, _157.w);
  float _170 = _10._m0[0u]._m0.w * _157.w;
  _166.z = (_10._m0[0u]._m0.w != 1.0) ? (_170 * _170) : _165.z;
  float _179 = _157.w * _10._m0[0u]._m0.x;
  _166.w = _179;
  vec4 _209;
  if (floatBitsToInt(_16._m11) != 0) {
    vec4 _195;
    if (floatBitsToInt(_16._m8) != 0) {
      vec4 _194 = _166;
      _194.w = _179 * _16._m8;
      _195 = _194;
    } else {
      _195 = _166;
    }
    vec4 _208;
    if (floatBitsToInt(_16._m9) != 0) {
      vec4 _207 = _195;
      _207.w = (-0.5) * (cos(_195.w * 3.1415927410125732421875) - 1.0);
      _208 = _207;
    } else {
      _208 = _195;
    }
    _209 = _208;
  } else {
    _209 = _166;
  }
  vec4 _212 = _209;
  _212.w = clamp(_209.w, 0.0, 1.0);
  _5 = _212;
}

