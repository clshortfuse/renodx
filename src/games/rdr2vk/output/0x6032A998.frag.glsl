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

vec3 _84;

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

layout(set = 1, binding = 34) uniform sampler _9;
layout(set = 1, binding = 37) uniform sampler _19;
layout(set = 1, binding = 128) uniform texture2D _20;
layout(set = 0, binding = 131) uniform texture3D _21;

layout(location = 0) in vec4 _4;
layout(location = 1) in vec4 _5;
layout(location = 2) in vec2 _6;
layout(location = 0) out vec4 _7;

void main() {
  vec4 _98 = (texture(sampler2D(_20, _19), _6).xxxx * _18._m5) + _18._m4;
  _98.w = _98.w * _5.w;
  vec4 _115;
  if (floatBitsToInt(_18._m10) != 0) {
    vec4 _113 = textureLod(sampler3D(_21, _9), _98.xyz, 0.0);
    _115 = vec4(_113.x, _113.y, _113.z, _98.w);
  } else {
    _115 = _98;
  }
  vec4 _165;
  if (floatBitsToInt(_18._m7) != 0) {
#if 1
    _115.rgb = GammaSafe(_115.rgb);
#endif

    vec3 _127 = _115.xyz * mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375));
    float _138 = pow(abs((_127.x * _16._m0) / _16._m15), 0.1593017578125);
    vec3 _145;
    _145.x = pow((0.8359375 + (18.8515625 * _138)) / (1.0 + (18.6875 * _138)), 78.84375);
    float _147 = pow(abs((_127.y * _16._m0) / _16._m15), 0.1593017578125);
    _145.y = pow((0.8359375 + (18.8515625 * _147)) / (1.0 + (18.6875 * _147)), 78.84375);
    float _156 = pow(abs((_127.z * _16._m0) / _16._m15), 0.1593017578125);
    _145.z = pow((0.8359375 + (18.8515625 * _156)) / (1.0 + (18.6875 * _156)), 78.84375);
    _165 = vec4(_145.x, _145.y, _145.z, _115.w);
  } else {
    _165 = _115;
  }
  vec3 _173 = mix(_165.xyz * _165.www, _165.xyz, bvec3(_18._m6 == 0.0));
  vec4 _174 = vec4(_173.x, _173.y, _173.z, _165.w);
  float _178 = _12._m0[0u]._m0.w * _165.w;
  _174.z = (_12._m0[0u]._m0.w != 1.0) ? (_178 * _178) : _173.z;
  float _187 = _165.w * _12._m0[0u]._m0.x;
  _174.w = _187;
  vec4 _217;
  if (floatBitsToInt(_18._m11) != 0) {
    vec4 _203;
    if (floatBitsToInt(_18._m8) != 0) {
      vec4 _202 = _174;
      _202.w = _187 * _18._m8;
      _203 = _202;
    } else {
      _203 = _174;
    }
    vec4 _216;
    if (floatBitsToInt(_18._m9) != 0) {
      vec4 _215 = _203;
      _215.w = (-0.5) * (cos(_203.w * 3.1415927410125732421875) - 1.0);
      _216 = _215;
    } else {
      _216 = _203;
    }
    _217 = _216;
  } else {
    _217 = _174;
  }
  vec4 _220 = _217;
  _220.w = clamp(_217.w, 0.0, 1.0);
  _7 = _220;
}

