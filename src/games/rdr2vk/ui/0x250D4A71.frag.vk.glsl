#version 450
#extension GL_GOOGLE_include_directive : require
#include "./ui.glsl"

layout(set = 1, binding = 28, std140) uniform _15_16 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  vec4 _m5;
  vec4 _m6;
  uvec4 _m7;
  vec4 _m8;
}
_16;

layout(set = 1, binding = 34) uniform sampler _8;
layout(set = 1, binding = 96) uniform texture2D _10;
layout(set = 1, binding = 97) uniform texture2D _11;
layout(set = 1, binding = 98) uniform texture2D _12;
layout(set = 1, binding = 101) uniform texture3D _14;

layout(location = 0) in vec4 _4;
layout(location = 1) in vec4 _5;
layout(location = 0) out vec4 _6;

void main() {
  vec4 _81 = (((_16._m3 * max(_16._m8.x, texture(sampler2D(_10, _8), _5.xy).x)) + (_16._m0 * texture(sampler2D(_11, _8), _5.zw).x)) + (_16._m1 * texture(sampler2D(_12, _8), _5.zw).x)) + _16._m2;
  _81.w = 1.0;
  vec4 _83 = _81 * _4;
  vec4 _94;
  if (_16._m7.x != 0u) {
    vec4 _92 = textureLod(sampler3D(_14, _8), _83.xyz, 0.0);
    _94 = vec4(_92.x, _92.y, _92.z, _83.w);
  } else {
    _94 = _83;
  }
  _6 = _94;
#if 1
  _6 = FinalizeUI(_6);
#endif
}
