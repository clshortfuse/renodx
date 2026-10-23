#version 450
#extension GL_GOOGLE_include_directive : require
#extension GL_EXT_scalar_block_layout : require
#include "./ui.glsl"

struct _17 {
  vec4 _m0;
  float _m1;
  vec2 _m2;
  float _m3;
  vec3 _m4;
  float _m5;
  vec4 _m6;
  vec4 _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  vec3 _m13;
};

layout(set = 1, binding = 21, scalar) uniform _16_18 {
  _17 _m0;
}
_18;

layout(set = 1, binding = 33) uniform sampler _9;
layout(set = 1, binding = 36) uniform sampler _10;
layout(set = 1, binding = 129) uniform texture2D _12;
layout(set = 1, binding = 131) uniform texture2D _13;
layout(set = 1, binding = 132) uniform texture2D _14;
layout(set = 1, binding = 138) uniform texture2D _15;

layout(location = 0) in vec2 _4;
layout(location = 1) in vec2 _5;
layout(location = 2) in vec2 _6;
layout(location = 0) out vec4 _7;

void main() {
  vec4 _78 = mix(_18._m0._m6, _18._m0._m7, vec4((1.0 - smoothstep(_18._m0._m8 - _18._m0._m9, _18._m0._m8 + _18._m0._m9, texture(sampler2D(_15, _9), _4).x)) * max(texture(sampler2D(_12, _10), _5).x, clamp(texture(sampler2D(_13, _10), _5).x, 0.0, 1.0))));
  vec3 _83 = _78.xyz;
  _7 = vec4(mix(_83, _83 + vec3(texture(sampler2D(_14, _10), _6).x), vec3(_18._m0._m3)), _78.w * _18._m0._m1);
#if 1
  _7 = FinalizeUI(_7);
#endif
}

