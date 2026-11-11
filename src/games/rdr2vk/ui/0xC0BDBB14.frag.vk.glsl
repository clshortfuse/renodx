#version 450
#extension GL_GOOGLE_include_directive : require
#include "./ui.glsl"

layout(set = 1, binding = 17, std140) uniform _11_12 {
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
_12;

layout(set = 1, binding = 37) uniform sampler _8;
layout(set = 1, binding = 104) uniform texture2D _10;

layout(location = 0) in vec4 _4;
layout(location = 1) in vec2 _5;
layout(location = 0) out vec4 _6;

void main() {
  vec4 _49 = texture(sampler2D(_10, _8), vec2(_5.x, 1.0 - _5.y));
  vec3 _51 = pow(_49.xyz, vec3(2.2));
  _6 = vec4(mix((pow(_51, vec3(_12._m2.y)) * _12._m2.z) - vec3(_12._m2.w), _51 * _12._m2.x, lessThan(_51, vec3(0.0031308))), float(_49.w > 0.0));
#if 1
  _6 = FinalizeUI(_6);
#endif
}
