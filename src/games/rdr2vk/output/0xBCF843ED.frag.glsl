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
  if (_94.w < 1.0) {
    discard;
  }
  vec4 _111;
  if (floatBitsToInt(_16._m10) != 0) {
    vec4 _109 = textureLod(sampler3D(_19, _7), _94.xyz, 0.0);
    _111 = vec4(_109.x, _109.y, _109.z, _94.w);
  } else {
    _111 = _94;
  }
  vec4 _161;
  if (floatBitsToInt(_16._m7) != 0) {
#if 1
    _111.rgb = GammaSafe(_111.rgb);
#endif

    vec3 _123 = _111.xyz * mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375));
#if 1
    vec3 _141;
    if (RENODX_TONE_MAP_TYPE != 0.f) {
      _141 = PQEncodeUI(_123);
    } else {
      float _134 = pow(abs((_123.x * _14._m0) / _14._m15), 0.1593017578125);
      _141.x = pow((0.8359375 + (18.8515625 * _134)) / (1.0 + (18.6875 * _134)), 78.84375);
      float _143 = pow(abs((_123.y * _14._m0) / _14._m15), 0.1593017578125);
      _141.y = pow((0.8359375 + (18.8515625 * _143)) / (1.0 + (18.6875 * _143)), 78.84375);
      float _152 = pow(abs((_123.z * _14._m0) / _14._m15), 0.1593017578125);
      _141.z = pow((0.8359375 + (18.8515625 * _152)) / (1.0 + (18.6875 * _152)), 78.84375);
    }
#else
    float _134 = pow(abs((_123.x * _14._m0) / _14._m15), 0.1593017578125);
    vec3 _141;
    _141.x = pow((0.8359375 + (18.8515625 * _134)) / (1.0 + (18.6875 * _134)), 78.84375);
    float _143 = pow(abs((_123.y * _14._m0) / _14._m15), 0.1593017578125);
    _141.y = pow((0.8359375 + (18.8515625 * _143)) / (1.0 + (18.6875 * _143)), 78.84375);
    float _152 = pow(abs((_123.z * _14._m0) / _14._m15), 0.1593017578125);
    _141.z = pow((0.8359375 + (18.8515625 * _152)) / (1.0 + (18.6875 * _152)), 78.84375);
#endif
    _161 = vec4(_141.x, _141.y, _141.z, _111.w);
  } else {
    _161 = _111;
  }
  vec3 _169 = mix(_161.xyz * _161.www, _161.xyz, bvec3(_16._m6 == 0.0));
  vec4 _170 = vec4(_169.x, _169.y, _169.z, _161.w);
  float _174 = _10._m0[0u]._m0.w * _161.w;
  _170.z = (_10._m0[0u]._m0.w != 1.0) ? (_174 * _174) : _169.z;
  float _183 = _161.w * _10._m0[0u]._m0.x;
  _170.w = _183;
  vec4 _213;
  if (floatBitsToInt(_16._m11) != 0) {
    vec4 _199;
    if (floatBitsToInt(_16._m8) != 0) {
      vec4 _198 = _170;
      _198.w = _183 * _16._m8;
      _199 = _198;
    } else {
      _199 = _170;
    }
    vec4 _212;
    if (floatBitsToInt(_16._m9) != 0) {
      vec4 _211 = _199;
      _211.w = (-0.5) * (cos(_199.w * 3.1415927410125732421875) - 1.0);
      _212 = _211;
    } else {
      _212 = _199;
    }
    _213 = _212;
  } else {
    _213 = _170;
  }
  vec4 _216 = _213;
  _216.w = clamp(_213.w, 0.0, 1.0);
  _5 = _216;
}

