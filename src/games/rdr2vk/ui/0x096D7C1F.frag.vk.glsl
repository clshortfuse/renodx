// this shader is reused for other purposes
#version 450
#extension GL_GOOGLE_include_directive : require
#include "./ui.glsl"

layout(set = 1, binding = 17, std140) uniform _6_7 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  float _m5;
  float _m6;
  float _m7;
  vec4 _m8;
  vec4 _m9;
  vec4 _m10;
}
_7;

layout(location = 0) in vec4 _3;
layout(location = 1) in vec2 _4;
layout(location = 0) out vec4 _5;

void main() {
  _5 = _7._m2 * _3;
#if 1
  _5 = FinalizeUI(_5);
#endif
}
