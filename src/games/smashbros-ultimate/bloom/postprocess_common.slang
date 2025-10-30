#version 450

#include "../shared.h"

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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

bool ApplyBloom(inout float4 out_color, float2 coords) {
  float _39 = coords.y;
  float _41 = coords.x;

  // Get texture size dynamically
  vec2 texSize = vec2(textureSize(fp_t_tcb_8, 0));
  texSize = floor(texSize / 2);
  vec2 pixelOffset = 1.0 / texSize;

  // Time-based animation (smooth, no floor)
  precise float _235 = fp_c3_1._m0[21].z * texSize.x;
  precise float _240 = fp_c3_1._m0[21].w * texSize.y;
  float _43 = _235;
  float _45 = _240;

  // Calculate time offsets in UV space
  float time_offset_x = _43 * pixelOffset.x;
  float time_offset_y = _45 * pixelOffset.y;

  // Blend time offset with input UV
  precise float _254 = _39 * fp_c3_1._m0[21].w;
  precise float _258 = _41 * fp_c3_1._m0[21].z;

  float center_x = min(_41, _258 * pixelOffset.x + time_offset_x);
  float center_y = min(_39, _254 * pixelOffset.y + time_offset_y);

  // Calculate 3x3 grid positions
  float left_x = center_x - pixelOffset.x;
  float right_x = center_x + pixelOffset.x;
  float top_y = center_y - pixelOffset.y;
  float bottom_y = center_y + pixelOffset.y;

  float3 _87, _95, _103, _123, _133, _141, _153, _165, _173;

  // Sample 3x3 grid
  // Top row
  _87 = texture(fp_t_tcb_8, vec2(left_x, top_y)).xyz;
  _95 = texture(fp_t_tcb_8, vec2(center_x, top_y)).xyz;
  _103 = texture(fp_t_tcb_8, vec2(right_x, top_y)).xyz;

  // Middle row
  _123 = texture(fp_t_tcb_8, vec2(left_x, center_y)).xyz;
  _133 = texture(fp_t_tcb_8, vec2(center_x, center_y)).xyz;
  _141 = texture(fp_t_tcb_8, vec2(right_x, center_y)).xyz;

  // Bottom row
  _153 = texture(fp_t_tcb_8, vec2(left_x, bottom_y)).xyz;
  _165 = texture(fp_t_tcb_8, vec2(center_x, bottom_y)).xyz;
  _173 = texture(fp_t_tcb_8, vec2(right_x, bottom_y)).xyz;

  // Apply Gaussian blur weights [1 2 1 / 2 4 2 / 1 2 1]
  vec3 sum = _87 * 1.0 + _95 * 2.0 + _103 * 1.0 + _123 * 2.0 + _133 * 4.0 + _141 * 2.0 + _153 * 1.0 + _165 * 2.0 + _173 * 1.0;

  // Divide by 16 (sum of weights)
  vec3 result = sum * 0.0625;
  out_color = float4(result, 1.f);

  return true;
}

bool Scale(inout float4 out_color, float2 coords) {
  float _39 = coords.x;
  float _41 = coords.y;

  // Get texture size dynamically
  vec2 texSize = vec2(textureSize(fp_t_tcb_8, 0));
  texSize = floor(texSize / 2);
  vec2 pixelSize = 1.0 / texSize;

  // Time-based animation (smooth, no floor)
  precise float _90 = fp_c3_1._m0[21].z * texSize.x;  // Half of width
  float _43 = _90;
  precise float _95 = fp_c3_1._m0[21].w * texSize.y;  // Half of height
  float _45 = _95;

  float _47 = _43;
  float _49 = _45;

  // Convert to UV offsets
  float _51 = _47 * pixelSize.x;
  float _53 = _49 * pixelSize.y;

  // Blend input UV with time offset
  precise float _114 = _39 * fp_c3_1._m0[21].z;
  float _55 = _114;
  precise float _118 = _41 * fp_c3_1._m0[21].w;
  float _57 = _118;

  float _59 = min(_55, _51);
  float _61 = min(_57, _53);

  // Clamp to valid UV range
  float _63 = max(_59, pixelSize.x);
  float _65 = max(_61, pixelSize.y);

  vec4 _68 = texture(fp_t_tcb_8, vec2(_63, _65)).xyzw;

  out_color = _68;
  return true;
}
