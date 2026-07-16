#version 450

#extension GL_GOOGLE_include_directive : require
#include "./tonemap.glsl"

layout(set = 0, binding = 18, std140) uniform _11_12 {
  float _m0;
  float _m1;
  uint _m2;
  uint _m3;
  uint _m4;
  uint _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  float _m15;
  uint _m16;
  uint _m17;
  uint _m18;
  uint _m19;
}
_12;

layout(set = 1, binding = 17, std140) uniform _13_14 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  float _m5;
  float _m6;
  float _m7;
  vec4 _m8;
  vec4 _m9;
  vec4 _m10;
}
_14;

layout(set = 1, binding = 37) uniform sampler _8;
layout(set = 1, binding = 104) uniform texture2D _10;

layout(location = 0) in vec4 _4;
layout(location = 1) in vec2 _5;
layout(location = 0) out vec4 _6;

void main() {
  vec3 _60 = textureLod(sampler2D(_10, _8), _5, 0.0).xyz;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    _6 = vec4((_60 * ((_12._m5 != 0u) ? mix(_12._m6 * _14._m2.y, _12._m6, smoothstep(_14._m2.z, _14._m2.w, dot(_60, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)))) : 1.0)) * _14._m2.x, 1.0);
  } else if (RENODX_TONE_MAP_TYPE == 1.f || RENODX_TONE_MAP_TYPE == 2.f) {
    vec3 color = _60;

    vec3 color_untonemapped = InverseReinhardScalablePiecewise(color, 0.951f, 0.4f);

    float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    vec3 color_tonemapped;
    if (RENODX_TONE_MAP_TYPE == 1.f) {
      float precompression_yf = renodx_color_yf_from_BT709(color_untonemapped);
      color_tonemapped = Neutwo(color_untonemapped, peak_ratio);
      color_tonemapped *= DivideSafe(
          precompression_yf,
          renodx_color_yf_from_BT709(color_tonemapped),
          1.0);
    } else {
      vec3 bt709_white_lms = renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(1.0));
      vec3 precompression_lms = renodx_tonemap_psycho22_StockmanLMSFromBT709(color_untonemapped);
      float precompression_yf = renodx_color_yf_from_LMS(precompression_lms);
      vec3 peak_white_lms = renodx_tonemap_psycho22_StockmanLMSFromBT709(vec3(peak_ratio));
      vec3 compressed_lms = Neutwo(precompression_lms, peak_white_lms);

      vec3 tonemapped_lms = renodx_tonemap_psycho23_ApplySignedOpponentRetentionAndGamutCompressionLMS(
          precompression_lms,
          compressed_lms,
          bt709_white_lms,
          Neutwo(bt709_white_lms, peak_white_lms),
          peak_white_lms,
          1.0,
          1.0);
      tonemapped_lms *= DivideSafe(
          precompression_yf,
          renodx_color_yf_from_LMS(tonemapped_lms),
          1.0);
      color_tonemapped = renodx_tonemap_psycho22_BT709FromStockmanLMS(tonemapped_lms);
    }

    color_tonemapped = ApplyGradingAndDisplayMap(color_tonemapped, _5);

    _6 = vec4(color_tonemapped, 1.0);
  } else {
    _6 = vec4(_60, 1.0);
  }
}

