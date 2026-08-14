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
layout(location = 8) in vec4 _31;
layout(location = 0) out vec4 _34;

void main() {
  if (Scale(_34, _29.xy)) {
    _34 *= _31;
    return;
  }

  float _41 = _29.x;
  float _43 = _29.y;
  precise float _108 = fp_c3_1._m0[21].z * (480.0);
  float _45 = _108;
  precise float _113 = fp_c3_1._m0[21].w * (270.0);
  float _47 = _113;
  float _49 = floor(_45);
  float _51 = floor(_47);
  float _53 = fma(_49, fp_c1_1._m0[0].x, (-0.00208333344198763370513916015625));
  float _55 = fma(_51, fp_c1_1._m0[0].y, (-0.0037037036381661891937255859375));
  precise float _132 = _41 * fp_c3_1._m0[21].z;
  float _57 = _132;
  precise float _136 = _43 * fp_c3_1._m0[21].w;
  float _59 = _136;
  float _61 = min(_53, _57);
  float _63 = min(_55, _59);
  float _65 = max(_61, fp_c1_1._m0[0].x);
  float _67 = max(_63, fp_c1_1._m0[0].y);
  vec4 _70 = texture(fp_t_tcb_8, vec2(_65, _67)).xyzw;
  float _72 = _70.x;
  float _74 = _70.y;
  float _76 = _70.z;
  float _78 = _70.w;
  float _80 = _31.x;
  float _82 = _31.y;
  float _84 = _31.z;
  float _86 = _31.w;
  precise float _176 = _72 * _80;
  float _88 = _176;
  precise float _179 = _74 * _82;
  float _90 = _179;
  precise float _182 = _76 * _84;
  float _92 = _182;
  precise float _185 = _78 * _86;
  float _94 = _185;
  _34.x = _88;
  _34.y = _90;
  _34.z = _92;
  _34.w = _94;
}

