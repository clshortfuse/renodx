#version 450
#extension GL_GOOGLE_include_directive : require
#include "./ui.glsl"

struct _8 {
  vec4 _m0;
  vec4 _m1;
  float _m2;
  float _m3;
};

vec2 _28;

layout(set = 1, binding = 22, std140) uniform _7_9 {
  _8 _m0;
}
_9;

layout(location = 0) in vec4 _4;
layout(location = 1) in vec3 _5;
layout(location = 0) out vec4 _6;

void main() {
  vec2 _39;
  _39.x = (_5.x * _9._m0._m1.z) + _9._m0._m1.x;
  _39.y = ((-_5.y) * _9._m0._m1.w) - _9._m0._m1.y;
  vec2 _50;
  _50.x = (_4.x * _9._m0._m1.z) + _9._m0._m1.x;
  _50.y = ((-_4.y) * _9._m0._m1.w) - _9._m0._m1.y;
  vec2 _62 = (_50 - _39) / vec2(_9._m0._m2 * _5.z);
  _6 = vec4(1.0 - smoothstep(_9._m0._m3, 1.0, dot(_62, _62))) * _4.z;
#if 1
  _6 = FinalizeUI(_6);
#endif
}

