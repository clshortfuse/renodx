// Tonemapper
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

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 0, binding = 25, std140) uniform fp_c6 {
  vec4 _m0[4096];
}
fp_c6_1;

layout(set = 0, binding = 24, std140) uniform fp_c5 {
  vec4 _m0[4096];
}
fp_c5_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 _33;
layout(location = 0) out vec4 _36;

void main() {
  float _43 = _33.x;
  float _45 = _33.y;
  vec4 _48 = textureLodOffset(fp_t_tcb_8, vec2(_43, _45), 0.0, ivec2(0)).xyzw;
  float _50 = _48.x;
  float _52 = _48.y;
  float _54 = _48.z;
  float _56 = _48.w;
  precise float _217 = 1.0 / fp_c3_1._m0[0].z;
  float _58 = _217;
  float _60 = -fp_c3_1._m0[0].x;
  precise float _223 = _43 + _60;
  float _62 = _223;
  precise float _227 = 1.0 / fp_c3_1._m0[0].w;
  float _64 = _227;
  float _66 = -fp_c3_1._m0[0].y;
  precise float _233 = _45 + _66;
  float _68 = _233;
  float _70 = fma(_62, _58, fp_c6_1._m0[1].x);
  float _72 = fma(_68, _64, fp_c6_1._m0[1].y);
  precise float _247 = _70 + (-0.5);
  float _74 = _247;
  precise float _249 = _72 + (-0.5);
  float _76 = _249;
  precise float _252 = _74 * _74;
  float _78 = _252;
  precise float _256 = _76 * fp_c6_1._m0[0].w;
  float _80 = _256;
  float _82 = fma(_80, _80, _78);
  float _84 = -fp_c6_1._m0[0].x;
  float _86 = fma(_82, _84, fp_c6_1._m0[0].x);
  float _88 = clamp(_86, 0.0, 1.0);
  float _90 = log2(_88);
  precise float _276 = _90 * fp_c6_1._m0[0].y;
  float _92 = _276;
  float _94 = exp2(_92);
  precise float _282 = _94 + fp_c6_1._m0[0].z;
  float _96 = _282;
  float _98 = clamp(_96, 0.0, 1.0);
  precise float _287 = _98 * _50;
  float _100 = _287;
  precise float _290 = _98 * _52;
  float _102 = _290;
  precise float _293 = _98 * _54;
  float _104 = _293;
  float _106 = fma(_100, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  float _108 = fma(_102, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  float _110 = fma(_104, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  float _112 = max(0.0, _106);
  float _114 = max(0.0, _110);
  float _116 = max(0.0, _108);
  float _118 = fma(_112, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _120 = fma(_114, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _122 = fma(_114, fp_c1_1._m0[0].x, 0.5);
  float _124 = fma(_116, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _126 = fma(_112, fp_c1_1._m0[0].x, 0.5);
  float _128 = fma(_112, _118, fp_c1_1._m0[0].y);
  float _130 = fma(_116, fp_c1_1._m0[0].x, 0.5);
  float _132 = fma(_114, _120, fp_c1_1._m0[0].y);
  precise float _350 = 1.0 / _128;
  float _134 = _350;
  precise float _353 = _114 * _122;
  float _136 = _353;
  float _138 = fma(_116, _124, fp_c1_1._m0[0].y);
  precise float _360 = 1.0 / _132;
  float _140 = _360;
  precise float _363 = _112 * _126;
  float _142 = _363;
  precise float _365 = 1.0 / _138;
  float _144 = _365;
  precise float _368 = _116 * _130;
  float _146 = _368;
  precise float _371 = _142 * _134;
  float _148 = _371;
  precise float _374 = _136 * _140;
  float _150 = _374;
  float _152 = abs(_148);
  float _154 = log2(_152);
  precise float _381 = _146 * _144;
  float _156 = _381;
  float _158 = abs(_150);
  float _160 = log2(_158);
  float _162 = abs(_156);
  float _164 = log2(_162);
  precise float _392 = _154 * 2.2000000476837158203125;
  float _166 = _392;
  precise float _394 = _160 * 2.2000000476837158203125;
  float _168 = _394;
  precise float _397 = _98 * _56;
  float _170 = _397;
  precise float _399 = _164 * 2.2000000476837158203125;
  float _172 = _399;
  float _174 = exp2(_166);
  float _176 = clamp(_174, 0.0, 1.0);
  precise float _407 = _170 * fp_c5_1._m0[0].x;
  float _178 = _407;
  float _180 = exp2(_168);
  float _182 = clamp(_180, 0.0, 1.0);
  float _184 = exp2(_172);
  float _186 = clamp(_184, 0.0, 1.0);
  _36.x = _176;
  _36.y = _186;
  _36.z = _182;
  _36.w = _178;

  float exposure = fp_c5_1._m0[0].x;
  float param_x = fp_c1_1._m0[0].x;
  float param_y = fp_c1_1._m0[0].y;

  vec3 untonemapped = _48.rgb * exposure;
  float vanilla_mid_gray = HejlDawsonCustom(0.18f, param_x, param_y).x;
  float3 vanilla = HejlDawsonCustom(untonemapped.rgb, param_x, param_y);

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    _36.rgb = saturate(vanilla);
  } else {
    _36.rgb = renodx::draw::ToneMapPass(untonemapped * vanilla_mid_gray / 0.18f, vanilla);
  }
  _36.rgb = renodx::draw::RenderIntermediatePass(_36.rgb);
}
