#version 450

#extension GL_GOOGLE_include_directive : require
#include "./output.glsl"

#extension GL_EXT_scalar_block_layout : require

struct _7 {
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

vec3 _72;

layout(set = 0, binding = 96, scalar) readonly buffer _6_8 {
  _7 _m0[];
}
_8;

layout(set = 0, binding = 23, std140) uniform _10_11 {
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
_11;

layout(set = 1, binding = 22, std140) uniform _12_13 {
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
_13;

layout(set = 1, binding = 34) uniform sampler _5;
layout(set = 0, binding = 131) uniform texture3D _14;

layout(location = 0) out vec4 _3;

void main() {
  vec4 _81 = (_13._m3 * _13._m5) + _13._m4;
  vec4 _94;
  if (floatBitsToInt(_13._m10) != 0) {
    vec4 _92 = textureLod(sampler3D(_14, _5), _81.xyz, 0.0);
    _94 = vec4(_92.x, _92.y, _92.z, _81.w);
  } else {
    _94 = _81;
  }
  vec4 _144;
  if (floatBitsToInt(_13._m7) != 0) {
#if 1
    _94.rgb = GammaSafe(_94.rgb);
#endif

    vec3 _106 = _94.xyz * mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375));
    float _117 = pow(abs((_106.x * _11._m0) / _11._m15), 0.1593017578125);
    vec3 _124;
    _124.x = pow((0.8359375 + (18.8515625 * _117)) / (1.0 + (18.6875 * _117)), 78.84375);
    float _126 = pow(abs((_106.y * _11._m0) / _11._m15), 0.1593017578125);
    _124.y = pow((0.8359375 + (18.8515625 * _126)) / (1.0 + (18.6875 * _126)), 78.84375);
    float _135 = pow(abs((_106.z * _11._m0) / _11._m15), 0.1593017578125);
    _124.z = pow((0.8359375 + (18.8515625 * _135)) / (1.0 + (18.6875 * _135)), 78.84375);
    _144 = vec4(_124.x, _124.y, _124.z, _94.w);
  } else {
    _144 = _94;
  }
  vec3 _152 = mix(_144.xyz * _144.www, _144.xyz, bvec3(_13._m6 == 0.0));
  vec4 _153 = vec4(_152.x, _152.y, _152.z, _144.w);
  float _157 = _8._m0[0u]._m0.w * _144.w;
  _153.z = (_8._m0[0u]._m0.w != 1.0) ? (_157 * _157) : _152.z;
  float _166 = _144.w * _8._m0[0u]._m0.x;
  _153.w = _166;
  vec4 _196;
  if (floatBitsToInt(_13._m11) != 0) {
    vec4 _182;
    if (floatBitsToInt(_13._m8) != 0) {
      vec4 _181 = _153;
      _181.w = _166 * _13._m8;
      _182 = _181;
    } else {
      _182 = _153;
    }
    vec4 _195;
    if (floatBitsToInt(_13._m9) != 0) {
      vec4 _194 = _182;
      _194.w = (-0.5) * (cos(_182.w * 3.1415927410125732421875) - 1.0);
      _195 = _194;
    } else {
      _195 = _182;
    }
    _196 = _195;
  } else {
    _196 = _153;
  }
  vec4 _199 = _196;
  _199.w = clamp(_196.w, 0.0, 1.0);
  _3 = _199;
}

