#version 450

#extension GL_GOOGLE_include_directive : require
#include "./tonemap.glsl"

layout(set = 1, binding = 31, std140) uniform _6_7 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec2 _m3;
  vec2 _m4;
  vec4 _m5;
  vec4 _m6;
  float _m7;
  float _m8;
  float _m9;
}
_7;

layout(set = 1, binding = 34) uniform sampler _9;
layout(set = 1, binding = 128) uniform texture2D _11;
layout(set = 1, binding = 130) uniform texture2D _12;
layout(set = 1, binding = 131) uniform texture2D _13;
layout(set = 1, binding = 132) uniform texture2D _14;
layout(set = 1, binding = 133) uniform texture2D _15;

layout(location = 0) in vec2 _4;
layout(location = 0) out vec4 _5;

void main() {
  vec4 _48 = texture(sampler2D(_11, _9), _4);
  float _50 = _48.z;
  float _52 = floor(_50 * 14.99989986419677734375);
  float _58 = (_52 * 0.0625) + (_48.x * 0.05859375);
  float _60 = _48.y * 0.9375;
  vec4 _64 = texture(sampler2D(_14, _9), vec2(0.001953125, 0.03125) + vec2(_58, _60));
  vec4 _70 = texture(sampler2D(_14, _9), vec2(0.001953125, 0.03125) + vec2(_58 + 0.0625, _60));
  vec3 _73 = mix(_64.xyz, _70.xyz, vec3((_50 * 15.0) - _52));
  vec4 _76 = texture(sampler2D(_15, _9), _4);
  float _77 = _76.x;
  float _79 = _73.z;
  float _81 = floor(_79 * 14.99989986419677734375);
  float _87 = (_81 * 0.0625) + (_73.x * 0.05859375);
  float _89 = _73.y * 0.9375;
  vec2 _91 = vec2(0.001953125, 0.03125) + vec2(_87, _89);
  vec4 _93 = texture(sampler2D(_12, _9), _91);
  vec2 _97 = vec2(0.001953125, 0.03125) + vec2(_87 + 0.0625, _89);
  vec4 _99 = texture(sampler2D(_12, _9), _97);
  vec3 _101 = vec3((_79 * 15.0) - _81);
  vec3 _102 = mix(_93.xyz, _99.xyz, _101);
  vec4 _105 = texture(sampler2D(_13, _9), _91);
  vec4 _108 = texture(sampler2D(_13, _9), _97);
  vec3 _110 = mix(_105.xyz, _108.xyz, _101);
  vec3 _123;
  vec3 _124;
  if (floatBitsToInt(_7._m9) != 0) {
    float _117 = _7._m9 * _77;
    _123 = _110 * ((1.0 + _117) - _7._m9);
    _124 = _102 * (1.0 - _117);
  } else {
    _123 = _110;
    _124 = _102;
  }
  _5 = vec4(mix(_124, _123, vec3(_77)), 1.0);

  _5.rgb = ApplyGradingAndDisplayMap(_5.rgb, _4.xy);
}

