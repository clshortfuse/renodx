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
  vec4 _69 = gl_FragCoord;
  _69.w = 1.0 / _69.w;
  vec4 _83 = textureLod(sampler2D(_15, _18), (_5 * _14._m2) + _14._m3, 0.0);
  vec3 _93 = clamp((_83.xyz * _14._m19) + vec3(_14._m20), vec3(0.0), vec3(1.0)).xyz;
  vec4 _101 = texture(sampler2D(_16, _11), vec2(dot(_93, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), _14._m21));
  vec3 _105 = mix(_93, _101.xyz, bvec3(_14._m21 > 0.0));
  vec4 _109 = vec4(_105.x, _105.y, _105.z, _83.w) * _14._m1;
  vec3 _110 = _109.xyz;
  vec3 _117;
  if (_14._m34 != 0u) {
    _117 = pow(_110, vec3(2.2000000476837158203125));
  } else {
    _117 = _110;
  }
  float _121 = _109.w * _14._m18;
  if (_121 <= 0.0) {
    discard;
  }
  vec3 _136 = vec4(texture(sampler2D(_17, _11), _69.xy * _14._m16).xyz, 1.0).xyz;
  _9 = vec4(mix(_136, mix(vec3(1.0) - (((vec3(1.0) - _117.xyz) * 2.0) * (vec3(1.0) - _136)), (_117.xyz * 2.0) * _136, lessThan(_136, vec3(0.5))), vec3(_121)), 1.0);
#if 1
  _9 = FinalizeUI(_9);
#endif
}