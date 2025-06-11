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
  float _60 = max(0.0, _54);
  float _62 = max(0.0, _56);
  float _64 = max(0.0, _58);
  float _66 = fma(_60, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _68 = fma(_62, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _70 = fma(_64, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _72 = fma(_60, fp_c1_1._m0[0].x, 0.5);
  float _74 = fma(_60, _66, fp_c1_1._m0[0].y);
  float _76 = fma(_62, _68, fp_c1_1._m0[0].y);
  precise float _209 = 1.0 / _74;
  float _78 = _209;
  float _80 = fma(_64, _70, fp_c1_1._m0[0].y);
  precise float _216 = 1.0 / _76;
  float _82 = _216;
  float _84 = fma(_64, fp_c1_1._m0[0].x, 0.5);
  precise float _222 = 1.0 / _80;
  float _86 = _222;
  float _88 = fma(_62, fp_c1_1._m0[0].x, 0.5);
  precise float _229 = _60 * _72;
  float _90 = _229;
  precise float _232 = _64 * _84;
  float _92 = _232;
  precise float _235 = _62 * _88;
  float _94 = _235;
  precise float _238 = _90 * _78;
  float _96 = _238;
  float _98 = abs(_96);
  float _100 = log2(_98);
  precise float _245 = _92 * _86;
  float _102 = _245;
  precise float _248 = _94 * _82;
  float _104 = _248;
  float _106 = abs(_102);
  float _108 = log2(_106);
  precise float _255 = _100 * 2.2000000476837158203125;
  float _110 = _255;
  float _112 = abs(_104);
  float _114 = log2(_112);
  precise float _261 = _108 * 2.2000000476837158203125;
  float _116 = _261;
  precise float _265 = _52 * fp_c5_1._m0[0].x;
  float _118 = _265;
  float _120 = exp2(_110);
  float _122 = clamp(_120, 0.0, 1.0);
  float _124 = exp2(_116);
  float _126 = clamp(_124, 0.0, 1.0);
  precise float _275 = _114 * 2.2000000476837158203125;
  float _128 = _275;
  float _130 = exp2(_128);
  float _132 = clamp(_130, 0.0, 1.0);
  _32.x = _122;
  _32.y = _132;
  _32.z = _126;
  _32.w = _118;

  vec3 untonemapped = vec3(_46, _48, _50);
  float vanilla_mid_gray =
      HejlDawsonCustom(0.18f, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y);  // 0.225f
  untonemapped *= fp_c5_1._m0[0].x;                                 // 2x exposure
  vec3 vanilla =
      vec3(HejlDawsonCustom(_32.r, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y),
           HejlDawsonCustom(_32.g, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y),
           HejlDawsonCustom(_32.b, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y));

  _32.rgb = CustomToneMap(untonemapped, vanilla, vanilla_mid_gray);

  // _32.rgb = renodx::color::bt2020::from::BT709(_32.rgb);


  // _32.rgb = renodx::draw::ToneMapPass(untonemapped, _32.rgb);

  

      // untonemapped, peak * 100.f, 0.18f, vanilla_mid_gray * 100.f,
      // 1.0f,  // float exposure,
      // 1.0f,  // float highlights,
      // 1.1f,  // float shadows,
      // 1.1f,  // float contrast,
      // 1.6f,  // float saturation,
      // 0.8,   // float dechroma,
      // 0.25,  // float flare,
      // 0.5f,  // float hue_correction_strength,
      // vanilla.rgb,
      // 1.f,
      // );


  // _32.rgb = renodx::color::srgb::EncodeSafe(_32.rgb);
  // _36.rgb = vec3(vanilla_mid_gray * 1.f / 80.f);
  // _36.rgb = ReinhardScalable(_36.rgb, (800.f / 203.f).xxx, (0).xxx,
  // (0.18f).xxx, (0.18f).xxx); _36.w = 0;
}

