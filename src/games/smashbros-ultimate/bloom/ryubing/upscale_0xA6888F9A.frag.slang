#version 450
#include "../postprocess_common.slang"

/* layout(set = 0, binding = 0, std140) uniform support_buffer {
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

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8; */

layout(location = 2) in vec4 _29;
layout(location = 0) out vec4 _32;

void main() {
  if (Scale(_32, _29.xy)) {
    return;
  }

  float _39 = _29.x;
  float _41 = _29.y;
  precise float _90 = fp_c3_1._m0[21].z * 960.0;
  float _43 = _90;
  precise float _95 = fp_c3_1._m0[21].w * 540.0;
  float _45 = _95;
  float _47 = (_43);
  float _49 = (_45);
  float _51 = fma(_47, fp_c1_1._m0[0].x, -0.001041666720993816852569580078125);
  float _53 = fma(_49, fp_c1_1._m0[0].y, -0.00185185181908309459686279296875);
  precise float _114 = _39 * fp_c3_1._m0[21].z;
  float _55 = _114;
  precise float _118 = _41 * fp_c3_1._m0[21].w;
  float _57 = _118;
  float _59 = min(_55, _51);
  float _61 = min(_57, _53);
  float _63 = max(_59, fp_c1_1._m0[0].x);
  float _65 = max(_61, fp_c1_1._m0[0].y);
  vec4 _68 = texture(fp_t_tcb_8, vec2(_63, _65)).xyzw;
  float _70 = _68.x;
  float _72 = _68.y;
  float _74 = _68.z;
  float _76 = _68.w;
  _32.x = _70;
  _32.y = _72;
  _32.z = _74;
  _32.w = _76;
}

