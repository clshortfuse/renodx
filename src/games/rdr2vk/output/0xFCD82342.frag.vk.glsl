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
  vec4 _97 = (texture(sampler2D(_20, _19), _6) * _18._m5) + _18._m4;
  _97.w = _97.w * _5.w;
  vec4 _114;
  if (floatBitsToInt(_18._m10) != 0) {
    vec4 _112 = textureLod(sampler3D(_21, _9), _97.xyz, 0.0);
    _114 = vec4(_112.x, _112.y, _112.z, _97.w);
  } else {
    _114 = _97;
  }
  vec4 _164;
  if (floatBitsToInt(_18._m7) != 0) {
#if 1
    _114.rgb = GammaSafe(_114.rgb);
#endif

    vec3 _126 = _114.xyz * mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375));
#if 1
    vec3 _144;
    if (RENODX_TONE_MAP_TYPE != 0.f) {
      _144 = PQEncodeUI(_126);
    } else {
      float _137 = pow(abs((_126.x * _16._m0) / _16._m15), 0.1593017578125);
      _144.x = pow((0.8359375 + (18.8515625 * _137)) / (1.0 + (18.6875 * _137)), 78.84375);
      float _146 = pow(abs((_126.y * _16._m0) / _16._m15), 0.1593017578125);
      _144.y = pow((0.8359375 + (18.8515625 * _146)) / (1.0 + (18.6875 * _146)), 78.84375);
      float _155 = pow(abs((_126.z * _16._m0) / _16._m15), 0.1593017578125);
      _144.z = pow((0.8359375 + (18.8515625 * _155)) / (1.0 + (18.6875 * _155)), 78.84375);
    }
#else
    float _137 = pow(abs((_126.x * _16._m0) / _16._m15), 0.1593017578125);
    vec3 _144;
    _144.x = pow((0.8359375 + (18.8515625 * _137)) / (1.0 + (18.6875 * _137)), 78.84375);
    float _146 = pow(abs((_126.y * _16._m0) / _16._m15), 0.1593017578125);
    _144.y = pow((0.8359375 + (18.8515625 * _146)) / (1.0 + (18.6875 * _146)), 78.84375);
    float _155 = pow(abs((_126.z * _16._m0) / _16._m15), 0.1593017578125);
    _144.z = pow((0.8359375 + (18.8515625 * _155)) / (1.0 + (18.6875 * _155)), 78.84375);
#endif
    _164 = vec4(_144.x, _144.y, _144.z, _114.w);
  } else {
    _164 = _114;
  }
  vec3 _172 = mix(_164.xyz * _164.www, _164.xyz, bvec3(_18._m6 == 0.0));
  vec4 _173 = vec4(_172.x, _172.y, _172.z, _164.w);
  float _177 = _12._m0[0u]._m0.w * _164.w;
  _173.z = (_12._m0[0u]._m0.w != 1.0) ? (_177 * _177) : _172.z;
  float _186 = _164.w * _12._m0[0u]._m0.x;
  _173.w = _186;
  vec4 _216;
  if (floatBitsToInt(_18._m11) != 0) {
    vec4 _202;
    if (floatBitsToInt(_18._m8) != 0) {
      vec4 _201 = _173;
      _201.w = _186 * _18._m8;
      _202 = _201;
    } else {
      _202 = _173;
    }
    vec4 _215;
    if (floatBitsToInt(_18._m9) != 0) {
      vec4 _214 = _202;
      _214.w = (-0.5) * (cos(_202.w * 3.1415927410125732421875) - 1.0);
      _215 = _214;
    } else {
      _215 = _202;
    }
    _216 = _215;
  } else {
    _216 = _173;
  }
  vec4 _219 = _216;
  _219.w = clamp(_216.w, 0.0, 1.0);
  _7 = _219;
}

