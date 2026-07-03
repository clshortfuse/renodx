#version 450
#include "../common.slang"

#extension GL_EXT_scalar_block_layout : require

layout(set = 0, binding = 2, scalar) uniform fs_cbuf_block_4f {
  float data[16384];
}
c3;

layout(set = 0, binding = 3, scalar) uniform c5 {
  float data[16384];
}
c5_1;

layout(set = 0, binding = 4) uniform sampler2D fs_tex2_20;
layout(set = 0, binding = 5) uniform sampler3D fs_tex2_48;

layout(location = 2) in vec4 in_attr2;
layout(location = 0) out vec4 frag_color0;

/* 1920.0 and 1080.0 — used to convert c3 values into pixel-space coordinates (looks like the shader assumes a 1920×1080 frame).
0.0005208333604969 ≈ 1/1920, 0.0009259259095415 ≈ 1/1080 — texel-size offsets (used with floor()).
0.03125 and 0.9375 (i.e. mapping factor 0.9375 and offset 0.03125) — map [0,1] into [1/32, 31/32] before 3D-LUT sampling (avoid edge samples).
0.009999999776482582 ≈ 0.01 — alpha threshold for enabling the mask.
1065353216u — uint bit pattern for float(1.0). Used to conditionally produce 1.0 or 0.0 without branching.
1.3703000545501709 — a final per-channel gain applied after LUT blending.
c5_1.data[21] — LUT blend weight (0..1 typical).
c5_1.data[20] — mask/attenuation strength applied when alpha >= 0.01. */
void main() {
  precise float _52 = c3.data[86u] * 1920.0;
  precise float _57 = c3.data[87u] * 1080.0;
  vec4 _80 = texture(fs_tex2_20, vec2(max(min(fma(floor(_52), 0.0005208333604969084262847900390625, -0.0005208333604969084262847900390625), in_attr2.x), 0.0005208333604969084262847900390625), max(min(fma(floor(_57), 0.000925925909541547298431396484375, -0.000925925909541547298431396484375), in_attr2.y), 0.000925925909541547298431396484375)));
  TonemapVanilla(_80);
  float _84 = _80.w;
  precise float _92 = log2(abs(_80.x)) * 0.4545449912548065185546875;
  precise float _93 = log2(abs(_80.z)) * 0.4545449912548065185546875;
  precise float _94 = log2(abs(_80.y)) * 0.4545449912548065185546875;
  float _95 = exp2(_92);
  float _96 = exp2(_93);
  float _97 = exp2(_94);
  vec4 _106 = texture(fs_tex2_48, vec3(fma(_95, 0.9375, 0.03125), fma(_97, 0.9375, 0.03125), fma(_96, 0.9375, 0.03125)));
  precise float _111 = (-_95) + _106.x;
  precise float _113 = (-_97) + _106.y;
  precise float _115 = (-_96) + _106.z;
  precise float _127 = fma(_111, c5_1.data[21u], _95) * EXPOSURE;
  precise float _128 = fma(_113, c5_1.data[21u], _97) * EXPOSURE;
  precise float _131 = fma(_115, c5_1.data[21u], _96) * EXPOSURE;
  precise float _141 = log2(abs(_127)) * 2.2000000476837158203125;
  precise float _142 = log2(abs(_128)) * 2.2000000476837158203125;
  precise float _143 = log2(abs(_131)) * 2.2000000476837158203125;
  float _144 = exp2(_141);
  float _145 = exp2(_142);
  precise float _150 = uintBitsToFloat((_84 >= 0.00999999977648258209228515625) ? 1065353216u : 0u) * c5_1.data[20u];
  float _151 = exp2(_143);
  frag_color0.x = fma(_144, -_150, _144);
  frag_color0.y = fma(_145, -_150, _145);
  frag_color0.z = fma(_151, -_150, _151);
  frag_color0.w = clamp(_84, 0, 1);

  ApplyTonemap(frag_color0, _80, fs_tex2_48, c5_1.data[21u]);
}

