// Link's Awakening Tonemapper

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

layout(set = 0, binding = 24, std140) uniform fp_c5 {
  vec4 _m0[4096];
}
fp_c5_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 _29;
layout(location = 0) out vec4 _32;

void main() {
  float _39 = _29.x;
  float _41 = _29.y;

  vec4 _44 = textureLodOffset(fp_t_tcb_8, vec2(_39, _41), 0.0, ivec2(0)).xyzw;
  float _46 = _44.x;
  float _48 = _44.y;
  float _50 = _44.z;
  float _52 = _44.w;
  float _54 = fma(_46, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  float _56 = fma(_48, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  float _58 = fma(_50, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  precise float _176 = _52 * fp_c5_1._m0[0].x;
  float _60 = _176;
  float _62 = max(0.0, _54);
  float _64 = max(0.0, _56);
  float _66 = max(0.0, _58);
  float _68 = fma(_62, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _70 = fma(_62, fp_c1_1._m0[0].x, 0.5);
  float _72 = fma(_64, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _74 = fma(_66, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _76 = fma(_62, _68, fp_c1_1._m0[0].y);
  precise float _208 = _62 * _70;
  float _78 = _208;
  precise float _211 = 1.0 / _76;
  float _80 = _211;
  float _82 = fma(_64, _72, fp_c1_1._m0[0].y);
  float _84 = fma(_66, _74, fp_c1_1._m0[0].y);
  precise float _223 = 1.0 / _82;
  float _86 = _223;
  float _88 = fma(_66, fp_c1_1._m0[0].x, 0.5);
  precise float _229 = 1.0 / _84;
  float _90 = _229;
  float _92 = fma(_64, fp_c1_1._m0[0].x, 0.5);
  precise float _236 = _66 * _88;
  float _94 = _236;
  precise float _239 = _64 * _92;
  float _96 = _239;
  precise float _242 = _78 * _80;
  float _98 = _242;
  float _100 = abs(_98);
  float _102 = log2(_100);
  precise float _249 = _94 * _90;
  float _104 = _249;
  precise float _252 = _96 * _86;
  float _106 = _252;
  float _108 = abs(_104);
  float _110 = log2(_108);
  precise float _259 = _102 * 2.2000000476837158203125;
  float _112 = _259;
  float _114 = abs(_106);
  float _116 = log2(_114);
  precise float _265 = _110 * 2.2000000476837158203125;
  float _118 = _265;
  float _120 = exp2(_112);
  float _122 = clamp(_120, 0.0, 1.0);
  precise float _271 = _116 * 2.2000000476837158203125;
  float _124 = _271;
  float _126 = exp2(_118);
  float _128 = clamp(_126, 0.0, 1.0);
  float _130 = exp2(_124);
  float _132 = clamp(_130, 0.0, 1.0);
  _32.x = _122;
  _32.y = _132;
  _32.z = _128;
  _32.w = _60;

  float exposure = fp_c5_1._m0[0].x;
  float param_x = fp_c1_1._m0[0].x;
  float param_y = fp_c1_1._m0[0].y;

  vec3 untonemapped = _44.rgb * exposure;
  float vanilla_mid_gray = HejlDawsonCustom(0.18f, param_x, param_y).x;
  float3 vanilla = HejlDawsonCustom(untonemapped.rgb, param_x, param_y);

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    _32.rgb = saturate(vanilla);
  } else {
    _32.rgb = renodx::draw::ToneMapPass(untonemapped * vanilla_mid_gray / 0.18f, vanilla);
  }
  _32.rgb = renodx::draw::RenderIntermediatePass(_32.rgb);
}
