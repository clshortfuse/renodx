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
layout(set = 1, binding = 129) uniform texture1D _13;
layout(set = 1, binding = 130) uniform texture2D _14;
layout(set = 1, binding = 131) uniform texture2D _15;
layout(set = 1, binding = 132) uniform texture2D _16;
layout(set = 1, binding = 133) uniform texture2D _17;

layout(location = 0) in vec2 _4;
layout(location = 0) out vec4 _5;

void main() {
  vec2 _88 = ((_4 - _7._m3) * mat2(vec2(_7._m5.x, _7._m5.y), vec2(_7._m5.z, _7._m5.w))) * _7._m4;
  vec3 _104 = mix(texture(sampler2D(_11, _9), _4).xyz, _7._m6.xyz, vec3(texture(sampler1D(_13, _9), min(1.0, max((dot(_88, _88) - _7._m7) * _7._m8, 0.0))).w * _7._m6.w));
  float _106 = _104.z;
  float _108 = floor(_106 * 14.99989986419677734375);
  float _114 = (_108 * 0.0625) + (_104.x * 0.05859375);
  float _116 = _104.y * 0.9375;
  vec3 _129 = mix(texture(sampler2D(_16, _9), vec2(0.001953125, 0.03125) + vec2(_114, _116)).xyz, texture(sampler2D(_16, _9), vec2(0.001953125, 0.03125) + vec2(_114 + 0.0625, _116)).xyz, vec3((_106 * 15.0) - _108));
  vec4 _132 = texture(sampler2D(_17, _9), _4);
  float _133 = _132.x;
  float _135 = _129.z;
  float _137 = floor(_135 * 14.99989986419677734375);
  float _143 = (_137 * 0.0625) + (_129.x * 0.05859375);
  float _145 = _129.y * 0.9375;
  vec2 _147 = vec2(0.001953125, 0.03125) + vec2(_143, _145);
  vec4 _149 = texture(sampler2D(_14, _9), _147);
  vec2 _153 = vec2(0.001953125, 0.03125) + vec2(_143 + 0.0625, _145);
  vec4 _155 = texture(sampler2D(_14, _9), _153);
  vec3 _157 = vec3((_135 * 15.0) - _137);
  vec3 _158 = mix(_149.xyz, _155.xyz, _157);
  vec4 _161 = texture(sampler2D(_15, _9), _147);
  vec4 _164 = texture(sampler2D(_15, _9), _153);
  vec3 _166 = mix(_161.xyz, _164.xyz, _157);
  vec3 _179;
  vec3 _180;
  if (floatBitsToInt(_7._m9) != 0) {
    float _173 = _7._m9 * _133;
    _179 = _166 * ((1.0 + _173) - _7._m9);
    _180 = _158 * (1.0 - _173);
  } else {
    _179 = _166;
    _180 = _158;
  }
  _5 = vec4(mix(_180, _179, vec3(_133)), 1.0);

  _5.rgb = ApplyGradingAndDisplayMap(_5.rgb, _4.xy);
}

