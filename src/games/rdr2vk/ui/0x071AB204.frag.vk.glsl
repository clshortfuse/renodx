#version 450
#extension GL_GOOGLE_include_directive : require
#include "./ui.glsl"

layout(set = 1, binding = 17, std140) uniform _10_11 {
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
_11;

layout(set = 1, binding = 37) uniform sampler _7;
layout(set = 1, binding = 104) uniform texture2D _9;

layout(location = 0) in vec4 _3;
layout(location = 1) in vec2 _4;
layout(location = 0) out vec4 _5;

void main() {
  _5 = (textureLod(sampler2D(_9, _7), _4, _11._m3.x) * _3) * _11._m2;
#if 1
  _5 = FinalizeUI(_5);
#endif
}