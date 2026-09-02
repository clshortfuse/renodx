#version 450
#include "../../shared.h"

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

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
fp_c1_1;

layout(set = 0, binding = 29, std140) uniform fp_c10 {
  vec4 _m0[4096];
}
fp_c10_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_E;

layout(location = 2) in vec4 _37;
layout(location = 0) out vec4 _40;

void main() {
  vec4 weights = fp_c10_1._m0[9];  // .xyzw are weight factors
  weights *= CUSTOM_BLOOM;

  float weightY = weights.y;
  // weightY = 0.f;
  float weightX = weights.x;
  // weightX = 1.f;
  float weightZ = weights.z;
  // weightZ = 0.f;
  float weightW = weights.w;
  // weightW = 0.f;

  precise float _229 = fp_c3_1._m0[21].z * 240.0;
  float _47 = _229;
  float _49 = (_47);
  float _51 = fma(_49, fp_c1_1._m0[0].x, -0.0041666668839752674102783203125);
  float _53 = _37.y;
  float _55 = _37.x;
  precise float _247 = fp_c3_1._m0[21].z * 30.0;
  float _57 = _247;
  float _59 = floor(_57);
  precise float _253 = fp_c3_1._m0[21].z * 120.0;
  float _61 = _253;
  precise float _258 = fp_c3_1._m0[21].w * 135.0;
  float _63 = _258;
  float _65 = floor(_61);
  precise float _264 = fp_c3_1._m0[21].w * 67.0;
  float _67 = _264;
  float _69 = floor(_63);
  precise float _270 = fp_c3_1._m0[21].w * 16.0;
  float _71 = _270;
  float _73 = floor(_67);
  precise float _276 = fp_c3_1._m0[21].w * 33.0;
  float _75 = _276;
  float _77 = floor(_75);
  precise float _282 = fp_c3_1._m0[21].z * 60.0;
  float _79 = _282;
  float _81 = floor(_79);
  float _83 = fma(_65, fp_c1_1._m0[0].z, -0.008333333767950534820556640625);
  float _85 = floor(_71);
  float _87 = fma(_59, fp_c1_1._m0[1].z, -0.0333333350718021392822265625);
  float _89 = fma(_69, fp_c1_1._m0[0].y, -0.007407407276332378387451171875);
  precise float _305 = _55 * fp_c3_1._m0[21].z;
  float _91 = _305;
  float _93 = fma(_73, fp_c1_1._m0[0].w, -0.014925372786819934844970703125);
  float _95 = fma(_77, fp_c1_1._m0[1].y, -0.0303030312061309814453125);
  precise float _319 = _53 * fp_c3_1._m0[21].w;
  float _97 = _319;
  float _99 = fma(_81, fp_c1_1._m0[1].x, -0.01666666753590106964111328125);
  float _101 = min(_91, _83);
  float _103 = min(_91, _87);
  float _105 = min(_97, _89);
  float _107 = min(_97, _93);
  float _109 = min(_97, _95);
  float _111 = fma(_85, 0.0625, -0.0625);
  float _113 = min(_91, _51);
  float _115 = min(_91, _99);
  float _117 = max(_105, fp_c1_1._m0[0].y);
  float _119 = max(_101, fp_c1_1._m0[0].z);
  float _121 = max(_107, fp_c1_1._m0[0].w);
  float _123 = max(_109, fp_c1_1._m0[1].y);
  float _125 = max(_103, fp_c1_1._m0[1].z);
  vec3 _129 = texture(fp_t_tcb_A, vec2(_119, _121)).xyz;  // bloom
  float _131 = _129.x;
  float _133 = _129.y;
  float _135 = _129.z;
  float _137 = min(_97, _111);
  float _139 = max(_113, fp_c1_1._m0[0].x);
  float _141 = max(_115, fp_c1_1._m0[1].x);
  vec3 _143 = texture(fp_t_tcb_8, vec2(_139, _117)).xyz;  // bloom
  float _145 = _143.x;
  float _147 = _143.y;
  float _149 = _143.z;
  vec3 _151 = texture(fp_t_tcb_C, vec2(_141, _123)).xyz;
  float _153 = _151.x;
  float _155 = _151.y;
  float _157 = _151.z;
  float _159 = max(_137, 0.0625);
  vec3 _161 = texture(fp_t_tcb_E, vec2(_125, _159)).xyz;
  float _163 = _161.x;
  float _165 = _161.y;
  float _167 = _161.z;
  precise float _436 = _131 * weightY;
  float _169 = _436;
  precise float _440 = _133 * weightY;
  float _171 = _440;
  precise float _444 = _135 * weightY;
  float _173 = _444;
  float _175 = fma(_145, weightX, _169);
  float _177 = fma(_147, weightX, _171);
  float _179 = fma(_149, weightX, _173);
  float _181 = fma(_153, weightZ, _175);
  float _183 = fma(_155, weightZ, _177);
  float _185 = fma(_157, weightZ, _179);
  float _187 = fma(_163, weightW, _181);
  // float _189 = clamp(_187, 0.0, 1.0);
  float _189 = _187;
  float _191 = fma(_165, weightW, _183);
  // float _193 = clamp(_191, 0.0, 1.0);
  float _193 = _191;
  float _195 = abs(_189);
  float _197 = log2(_195);
  float _199 = fma(_167, weightW, _185);
  // float _201 = clamp(_199, 0.0, 1.0);
  float _201 = _199;
  float _203 = abs(_193);
  float _205 = log2(_203);
  float _207 = abs(_201);
  float _209 = log2(_207);
  precise float _512 = _197 * 2.2000000476837158203125;
  float _211 = _512;
  precise float _514 = _205 * 2.2000000476837158203125;
  float _213 = _514;
  precise float _516 = _209 * 2.2000000476837158203125;
  float _215 = _516;
  float _217 = exp2(_211);
  float _219 = exp2(_213);
  float _221 = exp2(_215);
  _40.x = _217;
  _40.y = _219;
  _40.z = _221;
  _40.w = 1.0;
}

