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
  if (ApplyBloom(_32, _29.xy)) {
    return;
  }

  float _39 = _29.y;
  float _41 = _29.x;
  precise float _235 = fp_c3_1._m0[21].z * 480.0;
  float _43 = _235;
  precise float _240 = fp_c3_1._m0[21].w * 270.0;
  float _45 = _240;
  float _47 = floor(_43);
  float _49 = floor(_45);
  float _51 = fma(_49, fp_c1_1._m0[0].y, -0.0037037036381661891937255859375);
  precise float _254 = _39 * fp_c3_1._m0[21].w;
  float _53 = _254;
  precise float _258 = _41 * fp_c3_1._m0[21].z;
  float _55 = _258;
  float _57 = fma(_47, fp_c1_1._m0[0].x, -0.00208333344198763370513916015625);
  float _59 = -fp_c1_1._m0[0].w;
  float _61 = fma(fp_c3_1._m0[21].w, _59, _53);
  float _63 = -fp_c1_1._m0[0].z;
  float _65 = fma(fp_c3_1._m0[21].z, _63, _55);
  float _67 = fma(fp_c3_1._m0[21].z, fp_c1_1._m0[0].z, _55);
  float _69 = min(_57, _55);
  float _71 = min(_51, _61);
  float _73 = min(_57, _65);
  float _75 = min(_57, _67);
  float _77 = max(_69, fp_c1_1._m0[0].x);
  float _79 = max(_71, fp_c1_1._m0[0].y);
  float _81 = max(_73, fp_c1_1._m0[0].x);
  float _83 = max(_75, fp_c1_1._m0[0].x);
  vec3 _87 = texture(fp_t_tcb_8, vec2(_81, _79)).xyz;
  float _89 = _87.x;
  float _91 = _87.y;
  float _93 = _87.z;
  vec3 _95 = texture(fp_t_tcb_8, vec2(_77, _79)).xyz;
  float _97 = _95.x;
  float _99 = _95.y;
  float _101 = _95.z;
  vec3 _103 = texture(fp_t_tcb_8, vec2(_83, _79)).xyz;
  float _105 = _103.x;
  float _107 = _103.y;
  float _109 = _103.z;
  float _111 = fma(fp_c3_1._m0[21].w, fp_c1_1._m0[0].w, _53);
  float _113 = min(_51, _53);
  float _115 = max(_113, fp_c1_1._m0[0].y);
  float _117 = min(_51, _111);
  float _119 = max(_117, fp_c1_1._m0[0].y);
  float _121 = fma(_101, 2.0, _93);
  vec3 _123 = texture(fp_t_tcb_8, vec2(_81, _115)).xyz;
  float _125 = _123.x;
  float _127 = _123.y;
  float _129 = _123.z;
  precise float _389 = _109 + _121;
  float _131 = _389;
  vec3 _133 = texture(fp_t_tcb_8, vec2(_77, _115)).xyz;
  float _135 = _133.x;
  float _137 = _133.y;
  float _139 = _133.z;
  vec3 _141 = texture(fp_t_tcb_8, vec2(_83, _115)).xyz;
  float _143 = _141.x;
  float _145 = _141.y;
  float _147 = _141.z;
  float _149 = fma(_97, 2.0, _89);
  float _151 = fma(_99, 2.0, _91);
  vec3 _153 = texture(fp_t_tcb_8, vec2(_81, _119)).xyz;
  float _155 = _153.x;
  float _157 = _153.y;
  float _159 = _153.z;
  precise float _434 = _105 + _149;
  float _161 = _434;
  precise float _437 = _107 + _151;
  float _163 = _437;
  vec3 _165 = texture(fp_t_tcb_8, vec2(_77, _119)).xyz;
  float _167 = _165.x;
  float _169 = _165.y;
  float _171 = _165.z;
  vec3 _173 = texture(fp_t_tcb_8, vec2(_83, _119)).xyz;
  float _175 = _173.x;
  float _177 = _173.y;
  float _179 = _173.z;
  float _181 = fma(_125, 2.0, _161);
  float _183 = fma(_127, 2.0, _163);
  float _185 = fma(_129, 2.0, _131);
  float _187 = fma(_135, 4.0, _181);
  float _189 = fma(_137, 4.0, _183);
  float _191 = fma(_139, 4.0, _185);
  float _193 = fma(_143, 2.0, _187);
  float _195 = fma(_145, 2.0, _189);
  float _197 = fma(_147, 2.0, _191);
  precise float _492 = _193 + _155;
  float _199 = _492;
  precise float _495 = _195 + _157;
  float _201 = _495;
  precise float _498 = _197 + _159;
  float _203 = _498;
  float _205 = fma(_167, 2.0, _199);
  float _207 = fma(_169, 2.0, _201);
  float _209 = fma(_171, 2.0, _203);
  precise float _510 = _175 + _205;
  float _211 = _510;
  precise float _513 = _177 + _207;
  float _213 = _513;
  precise float _516 = _179 + _209;
  float _215 = _516;
  precise float _519 = _211 * 0.0625;
  float _217 = _519;
  precise float _521 = _213 * 0.0625;
  float _219 = _521;
  precise float _523 = _215 * 0.0625;
  float _221 = _523;
  _32.x = _217;
  _32.y = _219;
  _32.z = _221;
  _32.w = 1.0;
}

