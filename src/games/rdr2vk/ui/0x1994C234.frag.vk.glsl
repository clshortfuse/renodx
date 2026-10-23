#version 450
#extension GL_GOOGLE_include_directive : require
#include "./ui.glsl"

layout(set = 1, binding = 23, std140) uniform _13_14 {
  mat4 _m0;
  vec4 _m1;
  vec2 _m2;
  vec2 _m3;
  vec4 _m4;
  vec4 _m5;
  vec4 _m6;
  vec4 _m7;
  vec4 _m8;
  vec4 _m9;
  vec4 _m10;
  vec4 _m11;
  vec4 _m12;
  vec4 _m13;
  vec4 _m14;
  vec2 _m15;
  vec2 _m16;
  float _m17;
  float _m18;
  float _m19;
  float _m20;
  float _m21;
  float _m22;
  float _m23;
  float _m24;
  float _m25;
  float _m26;
  float _m27;
  float _m28;
  float _m29;
  float _m30;
  float _m31;
  float _m32;
  uint _m33;
  uint _m34;
  uint _m35;
  uint _m36;
}
_14;

layout(set = 1, binding = 32) uniform sampler _11;
layout(set = 1, binding = 128) uniform texture2D _15;
layout(set = 1, binding = 135) uniform texture2D _16;
layout(set = 1, binding = 137) uniform texture2D _17;
layout(set = 1, binding = 37) uniform sampler _18;

layout(location = 0) in vec2 _5;
layout(location = 1) in vec4 _6;
layout(location = 2) in vec4 _7;
layout(location = 3) in vec4 _8;
layout(location = 0) out vec4 _9;

void main() {
  vec4 _66 = gl_FragCoord;
  _66.w = 1.0 / _66.w;
  vec4 _80 = textureLod(sampler2D(_15, _18), (_5 * _14._m2) + _14._m3, 0.0);
  vec3 _90 = clamp((_80.xyz * _14._m19) + vec3(_14._m20), vec3(0.0), vec3(1.0)).xyz;
  vec4 _98 = texture(sampler2D(_16, _11), vec2(dot(_90, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), _14._m21));
  vec3 _102 = mix(_90, _98.xyz, bvec3(_14._m21 > 0.0));
  vec4 _106 = vec4(_102.x, _102.y, _102.z, _80.w) * _14._m1;
  vec3 _107 = _106.xyz;
  vec3 _114;
  if (_14._m34 != 0u) {
    _114 = pow(_107, vec3(2.2000000476837158203125));
  } else {
    _114 = _107;
  }
  float _118 = _106.w * _14._m18;
  if (_118 <= 0.0) {
    discard;
  }
  _9 = vec4(mix(vec4(texture(sampler2D(_17, _11), _66.xy * _14._m16).xyz, 1.0).xyz, _114.xyz, vec3(_118)), 1.0);
#if 1
  _9 = FinalizeUI(_9);
#endif
}