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
  precise float _233 = fp_c3_1._m0[21].z * 60.0;
  float _43 = _233;
  precise float _238 = fp_c3_1._m0[21].w * 33.0;
  float _45 = _238;
  float _47 = floor(_43);
  float _49 = floor(_45);
  float _51 = fma(_49, fp_c1_1._m0[0].y, -0.0303030312061309814453125);
  precise float _252 = _39 * fp_c3_1._m0[21].w;
  float _53 = _252;
  precise float _256 = _41 * fp_c3_1._m0[21].z;
  float _55 = _256;
  float _57 = fma(_47, fp_c1_1._m0[0].x, -0.01666666753590106964111328125);
  float _59 = fma(fp_c3_1._m0[21].w, -0.0625, _53);
  float _61 = -fp_c1_1._m0[0].z;
  float _63 = fma(fp_c3_1._m0[21].z, _61, _55);
  float _65 = fma(fp_c3_1._m0[21].z, fp_c1_1._m0[0].z, _55);
  float _67 = min(_57, _55);
  float _69 = min(_51, _59);
  float _71 = min(_57, _63);
  float _73 = min(_57, _65);
  float _75 = max(_67, fp_c1_1._m0[0].x);
  float _77 = max(_69, fp_c1_1._m0[0].y);
  float _79 = max(_71, fp_c1_1._m0[0].x);
  float _81 = max(_73, fp_c1_1._m0[0].x);
  vec3 _85 = texture(fp_t_tcb_8, vec2(_79, _77)).xyz;
  float _87 = _85.x;
  float _89 = _85.y;
  float _91 = _85.z;
  vec3 _93 = texture(fp_t_tcb_8, vec2(_75, _77)).xyz;
  float _95 = _93.x;
  float _97 = _93.y;
  float _99 = _93.z;
  vec3 _101 = texture(fp_t_tcb_8, vec2(_81, _77)).xyz;
  float _103 = _101.x;
  float _105 = _101.y;
  float _107 = _101.z;
  float _109 = fma(fp_c3_1._m0[21].w, 0.0625, _53);
  float _111 = min(_51, _53);
  float _113 = max(_111, fp_c1_1._m0[0].y);
  float _115 = min(_51, _109);
  float _117 = max(_115, fp_c1_1._m0[0].y);
  float _119 = fma(_99, 2.0, _91);
  vec3 _121 = texture(fp_t_tcb_8, vec2(_79, _113)).xyz;
  float _123 = _121.x;
  float _125 = _121.y;
  float _127 = _121.z;
  precise float _383 = _107 + _119;
  float _129 = _383;
  vec3 _131 = texture(fp_t_tcb_8, vec2(_75, _113)).xyz;
  float _133 = _131.x;
  float _135 = _131.y;
  float _137 = _131.z;
  vec3 _139 = texture(fp_t_tcb_8, vec2(_81, _113)).xyz;
  float _141 = _139.x;
  float _143 = _139.y;
  float _145 = _139.z;
  float _147 = fma(_95, 2.0, _87);
  float _149 = fma(_97, 2.0, _89);
  vec3 _151 = texture(fp_t_tcb_8, vec2(_79, _117)).xyz;
  float _153 = _151.x;
  float _155 = _151.y;
  float _157 = _151.z;
  precise float _428 = _103 + _147;
  float _159 = _428;
  precise float _431 = _105 + _149;
  float _161 = _431;
  vec3 _163 = texture(fp_t_tcb_8, vec2(_75, _117)).xyz;
  float _165 = _163.x;
  float _167 = _163.y;
  float _169 = _163.z;
  vec3 _171 = texture(fp_t_tcb_8, vec2(_81, _117)).xyz;
  float _173 = _171.x;
  float _175 = _171.y;
  float _177 = _171.z;
  float _179 = fma(_123, 2.0, _159);
  float _181 = fma(_125, 2.0, _161);
  float _183 = fma(_127, 2.0, _129);
  float _185 = fma(_133, 4.0, _179);
  float _187 = fma(_135, 4.0, _181);
  float _189 = fma(_137, 4.0, _183);
  float _191 = fma(_141, 2.0, _185);
  float _193 = fma(_143, 2.0, _187);
  float _195 = fma(_145, 2.0, _189);
  precise float _486 = _191 + _153;
  float _197 = _486;
  precise float _489 = _193 + _155;
  float _199 = _489;
  precise float _492 = _195 + _157;
  float _201 = _492;
  float _203 = fma(_165, 2.0, _197);
  float _205 = fma(_167, 2.0, _199);
  float _207 = fma(_169, 2.0, _201);
  precise float _504 = _173 + _203;
  float _209 = _504;
  precise float _507 = _175 + _205;
  float _211 = _507;
  precise float _510 = _177 + _207;
  float _213 = _510;
  precise float _512 = _209 * 0.0625;
  float _215 = _512;
  precise float _514 = _211 * 0.0625;
  float _217 = _514;
  precise float _516 = _213 * 0.0625;
  float _219 = _516;
  _32.x = _215;
  _32.y = _217;
  _32.z = _219;
  _32.w = 1.0;
}

