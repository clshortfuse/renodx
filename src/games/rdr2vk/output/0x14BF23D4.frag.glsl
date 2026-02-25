#version 450

#extension GL_GOOGLE_include_directive : require
#include "./output.glsl"

#extension GL_EXT_scalar_block_layout : require

struct _11 {
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

vec3 _83;

layout(set = 0, binding = 96, scalar) readonly buffer _10_12 {
  _11 _m0[];
}
_12;

layout(set = 0, binding = 23, std140) uniform _15_16 {
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
_16;

layout(set = 1, binding = 22, std140) uniform _17_18 {
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
_18;

layout(set = 1, binding = 34) uniform sampler _8;
layout(set = 1, binding = 36) uniform sampler _9;
layout(set = 0, binding = 131) uniform texture3D _19;
layout(set = 1, binding = 135) uniform texture2D _20;

layout(location = 0) in vec4 _4;
layout(location = 1) in vec2 _5;
layout(location = 0) out vec4 _6;

void main() {
  vec4 _92 = (_4 * _18._m5) + _18._m4;
  _92.w = _92.w * texture(sampler2D(_20, _9), _5).x;
  vec4 _113;
  if (floatBitsToInt(_18._m10) != 0) {
    vec4 _111 = textureLod(sampler3D(_19, _8), _92.xyz, 0.0);
    _113 = vec4(_111.x, _111.y, _111.z, _92.w);
  } else {
    _113 = _92;
  }
  vec4 _163;
  if (floatBitsToInt(_18._m7) != 0) {
#if 1
    _113.rgb = GammaSafe(_113.rgb);
#endif

    vec3 _125 = _113.xyz * mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375));
    float _136 = pow(abs((_125.x * _16._m0) / _16._m15), 0.1593017578125);
    vec3 _143;
    _143.x = pow((0.8359375 + (18.8515625 * _136)) / (1.0 + (18.6875 * _136)), 78.84375);
    float _145 = pow(abs((_125.y * _16._m0) / _16._m15), 0.1593017578125);
    _143.y = pow((0.8359375 + (18.8515625 * _145)) / (1.0 + (18.6875 * _145)), 78.84375);
    float _154 = pow(abs((_125.z * _16._m0) / _16._m15), 0.1593017578125);
    _143.z = pow((0.8359375 + (18.8515625 * _154)) / (1.0 + (18.6875 * _154)), 78.84375);
    _163 = vec4(_143.x, _143.y, _143.z, _113.w);
  } else {
    _163 = _113;
  }
  vec3 _171 = mix(_163.xyz * _163.www, _163.xyz, bvec3(_18._m6 == 0.0));
  vec4 _172 = vec4(_171.x, _171.y, _171.z, _163.w);
  float _176 = _12._m0[0u]._m0.w * _163.w;
  _172.z = (_12._m0[0u]._m0.w != 1.0) ? (_176 * _176) : _171.z;
  float _185 = _163.w * _12._m0[0u]._m0.x;
  _172.w = _185;
  vec4 _215;
  if (floatBitsToInt(_18._m11) != 0) {
    vec4 _201;
    if (floatBitsToInt(_18._m8) != 0) {
      vec4 _200 = _172;
      _200.w = _185 * _18._m8;
      _201 = _200;
    } else {
      _201 = _172;
    }
    vec4 _214;
    if (floatBitsToInt(_18._m9) != 0) {
      vec4 _213 = _201;
      _213.w = (-0.5) * (cos(_201.w * 3.1415927410125732421875) - 1.0);
      _214 = _213;
    } else {
      _214 = _201;
    }
    _215 = _214;
  } else {
    _215 = _172;
  }
  vec4 _218 = _215;
  _218.w = clamp(_215.w, 0.0, 1.0);
  _6 = _218;
}

