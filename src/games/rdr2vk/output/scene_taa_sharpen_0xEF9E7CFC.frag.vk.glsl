#version 450
#extension GL_GOOGLE_include_directive : require
#include "../common.glsl"

layout(set = 1, binding = 22, std140) uniform _9_10 {
  vec4 _m0;
}
_10;

layout(set = 1, binding = 32) uniform sampler _7;
layout(set = 1, binding = 156) uniform texture2D _11;

layout(location = 0) in vec2 _4;
layout(location = 0) out vec4 _5;

void main() {
  vec4 center_sample = texture(sampler2D(_11, _7), _4);
  vec4 positive_y_sample = texture(sampler2D(_11, _7), _4 + vec2(0.0, _10._m0.z));
  vec4 negative_y_sample = texture(sampler2D(_11, _7), _4 + vec2(0.0, -_10._m0.z));
  vec4 negative_x_sample = texture(sampler2D(_11, _7), _4 + vec2(-_10._m0.y, 0.0));
  vec4 positive_x_sample = texture(sampler2D(_11, _7), _4 + vec2(_10._m0.y, 0.0));

  _5 = center_sample + ((((((center_sample * 4.0) - positive_y_sample) - negative_y_sample) - negative_x_sample) - positive_x_sample) * _10._m0.x) * 1.0;
  // Clamp sharpening undershoot in BT.2020 rather than clipping wide-gamut
  // colors merely because their BT.709 representation has negative channels.
  if (RENODX_TONE_MAP_TYPE == 0.0) {
    _5 = max(_5, vec4(0.0));
  } else {
    vec3 color_bt2020 = BT709ToBT2020(SRGBDecodeSafe(_5.rgb));
    color_bt2020 = max(color_bt2020, vec3(0.0));
    _5.rgb = SRGBEncodeSafe(BT2020ToBT709(color_bt2020));
    _5.a = max(_5.a, 0.0);
  }
}
