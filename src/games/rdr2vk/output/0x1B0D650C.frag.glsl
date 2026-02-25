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

vec3 _75;

layout(set = 0, binding = 96, scalar) readonly buffer _8_10 {
  _9 _m0[];
}
_10;

layout(set = 0, binding = 23, std140) uniform _12_13 {
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
_13;

layout(set = 1, binding = 22, std140) uniform _14_15 {
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
_15;

layout(set = 1, binding = 34) uniform sampler _7;
layout(set = 0, binding = 131) uniform texture3D _16;

layout(location = 0) in vec4 _4;
layout(location = 0) out vec4 _5;

void main() {
  vec4 _83 = (_4 * _15._m5) + _15._m4;
  vec4 _96;
  if (floatBitsToInt(_15._m10) != 0) {
    vec4 _94 = textureLod(sampler3D(_16, _7), _83.xyz, 0.0);
    _96 = vec4(_94.x, _94.y, _94.z, _83.w);
  } else {
    _96 = _83;
  }
  vec4 _146;
  if (floatBitsToInt(_15._m7) != 0) {
#if 1
    _96.rgb = GammaSafe(_96.rgb);
#endif
    vec3 _108 = _96.xyz * mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375));
    float _119 = pow(abs((_108.x * _13._m0) / _13._m15), 0.1593017578125);
    vec3 _126;
    _126.x = pow((0.8359375 + (18.8515625 * _119)) / (1.0 + (18.6875 * _119)), 78.84375);
    float _128 = pow(abs((_108.y * _13._m0) / _13._m15), 0.1593017578125);
    _126.y = pow((0.8359375 + (18.8515625 * _128)) / (1.0 + (18.6875 * _128)), 78.84375);
    float _137 = pow(abs((_108.z * _13._m0) / _13._m15), 0.1593017578125);
    _126.z = pow((0.8359375 + (18.8515625 * _137)) / (1.0 + (18.6875 * _137)), 78.84375);
    _146 = vec4(_126.x, _126.y, _126.z, _96.w);
  } else {
    _146 = _96;
  }
  vec3 _154 = mix(_146.xyz * _146.www, _146.xyz, bvec3(_15._m6 == 0.0));
  vec4 _155 = vec4(_154.x, _154.y, _154.z, _146.w);
  float _159 = _10._m0[0u]._m0.w * _146.w;
  _155.z = (_10._m0[0u]._m0.w != 1.0) ? (_159 * _159) : _154.z;
  float _168 = _146.w * _10._m0[0u]._m0.x;
  _155.w = _168;
  vec4 _198;
  if (floatBitsToInt(_15._m11) != 0) {
    vec4 _184;
    if (floatBitsToInt(_15._m8) != 0) {
      vec4 _183 = _155;
      _183.w = _168 * _15._m8;
      _184 = _183;
    } else {
      _184 = _155;
    }
    vec4 _197;
    if (floatBitsToInt(_15._m9) != 0) {
      vec4 _196 = _184;
      _196.w = (-0.5) * (cos(_184.w * 3.1415927410125732421875) - 1.0);
      _197 = _196;
    } else {
      _197 = _184;
    }
    _198 = _197;
  } else {
    _198 = _155;
  }
  vec4 _201 = _198;
  _201.w = clamp(_198.w, 0.0, 1.0);
  _5 = _201;
}

