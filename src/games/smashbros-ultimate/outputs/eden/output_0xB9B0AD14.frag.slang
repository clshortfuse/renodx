#define USE_OUTPUT_PUSHCONSTANTS

#version 450
#include "../../shared.h"

// #extension GL_EXT_scalar_block_layout : require

layout(set = 0, binding = 1) uniform fs_cbuf_block_4f {
  vec4 data[4096];
}
c3;

layout(set = 0, binding = 2) uniform c10 {
  vec4 data[4096];
}
c10_1;

layout(set = 0, binding = 3) uniform sampler2D fs_tex2_20;

layout(location = 2) in vec4 in_attr2;
layout(location = 0) out vec4 frag_color0;

float c3_data(uint index) {
  vec4 v = c3.data[index >> 2u];
  return v[int(index & 3u)];
}

float c10_data(uint index) {
  vec4 v = c10_1.data[index >> 2u];
  return v[int(index & 3u)];
}

void main() {
  precise float _53 = c3_data(84u) * 1920.0;
  precise float _58 = c3_data(85u) * 1080.0;
  precise float _72 = in_attr2.x * c3_data(84u);
  precise float _75 = in_attr2.y * c3_data(85u);
  vec4 _82 = texture(fs_tex2_20, vec2(max(min(fma(floor(_53), 0.0005208333604969084262847900390625, -0.0005208333604969084262847900390625), _72), 0.0005208333604969084262847900390625), max(min(fma(floor(_58), 0.000925925909541547298431396484375, -0.000925925909541547298431396484375), _75), 0.000925925909541547298431396484375)));
  // frag_color0.rgb = renodx::draw::SwapChainPass(_82.rgb);
  // frag_color0.w = _82.w;
  frag_color0 = _82;
  return;
  precise float _96 = log2(abs(_82.x)) * c10_data(51u);
  precise float _99 = log2(abs(_82.y)) * c10_data(51u);
  precise float _102 = log2(abs(_82.z)) * c10_data(51u);
  frag_color0.x = exp2(_96);
  frag_color0.y = exp2(_99);
  frag_color0.z = exp2(_102);
}

