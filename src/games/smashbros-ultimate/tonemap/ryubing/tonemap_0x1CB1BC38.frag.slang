#version 450

#include "../common.slang"

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

layout(set = 0, binding = 24, std140) uniform fp_c5 {
  vec4 _m0[4096];
}
fp_c5_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler3D fp_t_tcb_12;

layout(location = 2) in vec4 _36;
layout(location = 0) out vec4 _39;

void main() {
  precise float _195 = fp_c3_1._m0[21].z * 1920.0;
  float _46 = _195;
  precise float _200 = fp_c3_1._m0[21].w * 1080.0;
  float _48 = _200;
  float _50 = floor(_46);
  float _52 = floor(_48);
  float _54 = _36.x;
  float _56 = _36.y;
  float _58 = fma(_50, fp_c1_1._m0[0].x, -0.0005208333604969084262847900390625);
  float _60 = fma(_52, fp_c1_1._m0[0].y, -0.000925925909541547298431396484375);
  float _62 = min(_58, _54);
  float _64 = min(_60, _56);
  float _66 = max(_62, fp_c1_1._m0[0].x);
  float _68 = max(_64, fp_c1_1._m0[0].y);
  vec4 _71 = texture(fp_t_tcb_8, vec2(_66, _68)).xyzw;
  TonemapVanilla(_71);
  float _73 = _71.x;
  float _75 = _71.y;
  float _77 = _71.z;
  float _79 = _71.w;

  // gamma 2.2 encode
  float _81 = abs(_73);
  float _83 = log2(_81);
  float _85 = abs(_77);
  float _87 = log2(_85);
  float _89 = abs(_75);
  float _91 = log2(_89);
  precise float _265 = _83 * 0.4545449912548065185546875;
  float _93 = _265;
  precise float _267 = _87 * 0.4545449912548065185546875;
  float _95 = _267;
  precise float _269 = _91 * 0.4545449912548065185546875;
  float _97 = _269;
  float _99 = exp2(_93);
  float _101 = exp2(_95);
  float _103 = exp2(_97);
  float _105 = fma(_99, 0.9375, 0.03125);
  float _107 = fma(_101, 0.9375, 0.03125);
  float _109 = fma(_103, 0.9375, 0.03125);
  // Lut?
  vec3 _113 = texture(fp_t_tcb_12, vec3(_105, _109, _107)).xyz;
  float _115 = _113.x;
  float _117 = _113.y;
  float _119 = _113.z;
  float _121 = -_99;
  precise float _301 = _121 + _115;
  float _123 = _301;
  float _125 = -_103;
  precise float _306 = _125 + _117;
  float _127 = _306;
  float _129 = -_101;
  precise float _311 = _129 + _119;
  float _131 = _311;
  float _133 = fma(_123, fp_c5_1._m0[5].y, _99);
  float _135 = fma(_127, fp_c5_1._m0[5].y, _103);
  float _137 = fma(_131, fp_c5_1._m0[5].y, _101);
  precise float _330 = _133 * EXPOSURE;
  float _139 = _330;
  precise float _332 = _135 * EXPOSURE;
  float _141 = _332;
  float _143 = abs(_139);
  float _145 = log2(_143);
  precise float _338 = _137 * EXPOSURE;
  float _147 = _338;
  float _149 = abs(_141);
  float _151 = log2(_149);
  bool _155 = _79 >= fp_c1_1._m0[0].z;
  float _157 = float(_155);
  float _159 = abs(_147);
  float _161 = log2(_159);
  precise float _357 = _145 * 2.2000000476837158203125;
  float _163 = _357;
  precise float _359 = _151 * 2.2000000476837158203125;
  float _165 = _359;
  precise float _361 = _161 * 2.2000000476837158203125;
  float _167 = _361;
  float _169 = exp2(_163);
  float _171 = exp2(_165);
  precise float _369 = _157 * fp_c5_1._m0[5].x;
  float _173 = _369;
  float _175 = exp2(_167);
  float _177 = -_173;
  float _179 = fma(_169, _177, _169);
  float _181 = -_173;
  float _183 = fma(_171, _181, _171);
  float _185 = -_173;
  float _187 = fma(_175, _185, _175);
  _39.x = _179;
  _39.y = _183;
  _39.z = _187;
  _39.w = _79;

  ApplyTonemap(_39, _71, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

