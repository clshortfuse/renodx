// zelda-eow bloom

#version 450

#include "./common.slangi"

layout(set = 0, binding = 0, std140) uniform support_buffer {
  uint _m0;
  uint _m1[8];
  vec4 _m2;
  vec4 _m3;
  int _m4;
  float _m5[73];
  ivec4 _m6;
  int _m7;
}
support_buffer_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 _23;
layout(location = 0) out vec4 _26;

void main() {
  float _33 = _23.x;
  float _35 = _23.y;
  vec4 _38 = textureLod(fp_t_tcb_A, vec2(_33, _35), 0.0).xyzw;
  _38 *= CUSTOM_BLOOM;
  float _40 = _38.x;
  float _42 = _38.y;
  float _44 = _38.z;
  float _46 = _38.w;
  vec4 _48 = textureLod(fp_t_tcb_8, vec2(_33, _35), 0.0).xyzw;
  float _50 = _48.x;
  float _52 = _48.y;
  float _54 = _48.z;
  float _56 = _48.w;
  precise float _104 = _40 + _50;
  float _58 = _104;
  precise float _107 = _42 + _52;
  float _60 = _107;
  precise float _110 = _44 + _54;
  float _62 = _110;
  precise float _113 = _46 + _56;
  float _64 = _113;
  _26.x = _58;
  _26.y = _60;
  _26.z = _62;
  _26.w = _64;
}

