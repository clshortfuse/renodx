#version 450

#include "../postprocess_common.slang"

// layout(set = 0, binding = 0, std140) uniform support_buffer {
//   uint _m0;
//   uint _m1[8];
//   vec4 _m2;
//   vec4 _m3;
//   int _m4;
//   float _m5[73];
//   ivec4 _m6;
//   int _m7;
// }
// support_buffer_1;

// layout(set = 0, binding = 22, std140) uniform fp_c3 {
//   vec4 _m0[4096];
// }
// fp_c3_1;

// layout(set = 0, binding = 20, std140) uniform fp_c1 {
//   vec4 _m0[4096];
// }
// fp_c1_1;

layout(set = 0, binding = 29, std140) uniform fp_c10 {
  vec4 _m0[4096];
}
fp_c10_1;

// layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 2) in vec4 _31;
layout(location = 8) in vec4 _33;
layout(location = 0) out vec4 _36;

void main() {
  float _43 = _31.x;
  float _45 = _31.y;
  precise float _135 = fp_c3_1._m0[21].z * 1920.0;
  float _47 = _135;
  precise float _140 = fp_c3_1._m0[21].w * 1080.0;
  float _49 = _140;
  float _51 = floor(_47);
  float _53 = floor(_49);
  float _55 = fma(_51, fp_c1_1._m0[0].x, -0.0005208333604969084262847900390625);
  float _57 = fma(_53, fp_c1_1._m0[0].y, -0.000925925909541547298431396484375);
  precise float _159 = _43 * fp_c3_1._m0[21].z;
  float _59 = _159;
  precise float _163 = _45 * fp_c3_1._m0[21].w;
  float _61 = _163;
  float _63 = min(_55, _59);
  float _65 = min(_57, _61);
  float _67 = max(_63, fp_c1_1._m0[0].x);
  float _69 = max(_65, fp_c1_1._m0[0].y);
  vec3 _73 = texture(fp_t_tcb_8, vec2(_67, _69)).xyz;
  vec2 uv = vec2(_67, _69);

  /* vec2 texelSize = 1 / vec2(1920.0, 1080.0);

  vec3 center = texture(fp_t_tcb_8, uv).rgb;
  vec3 sum = center * 4.0;  // center weighted 4x
  sum += texture(fp_t_tcb_8, uv + texelSize * vec2(-1, 0)).rgb;
  sum += texture(fp_t_tcb_8, uv + texelSize * vec2(1, 0)).rgb;
  sum += texture(fp_t_tcb_8, uv + texelSize * vec2(0, -1)).rgb;
  sum += texture(fp_t_tcb_8, uv + texelSize * vec2(0, 1)).rgb;
  _73 = sum / 8.0;  // normalize weights
  _73 = clamp(_73, 0.0, 1.0); */

  vec3 center = texture(fp_t_tcb_8, uv).rgb;
  vec2 texelSize = 1.0 / vec2(1920.0, 1080.0);
  float2 offset = texelSize;
  // Neighbor samples for stability (1 texel offset; adjust if needed)
  vec3 right = texture(fp_t_tcb_8, uv + vec2(offset.x, 0.0)).rgb;
  vec3 up = texture(fp_t_tcb_8, uv + vec2(0.0, offset.y)).rgb;
  vec3 left = texture(fp_t_tcb_8, uv - vec2(offset.x, 0.0)).rgb;
  vec3 down = texture(fp_t_tcb_8, uv - vec2(0.0, offset.y)).rgb;

  // Average them (basic 5-tap blur)
  vec3 avg = (center + right + left + up + down) / 5.0;

  float _75, _77, _79, _81;
  // Compute luminance or max brightness
  if (true) {
    _75 = avg.x;
    _77 = avg.y;
    _79 = avg.z;
  } else {
    _75 = _73.x;
    _77 = _73.y;
    _79 = _73.z;
  }
  _81 = _33.w;

  float _83 = max(_77, _79);
  float _85 = max(_75, fp_c1_1._m0[0].z);
  float _87 = max(_83, _85);
  precise float _205 = 1.0 / _87;
  float _89 = _205;
  float _91 = fma(fp_c10_1._m0[8].x, -0.5, _87);
  float _93 = max(0.0, _91);

  float thresholdBase = fp_c10_1._m0[8].x * 0.5;
  float thresholdRange = 0.15;  // increase softness for low-res bloom
  _93 = smoothstep(thresholdBase - thresholdRange, thresholdBase + thresholdRange, _87);

  precise float _217 = _93 * _89;
  float _95 = _217;
  bool _99 = _91 >= fp_c1_1._m0[0].z;
  float _101 = float(_99);
  precise float _226 = _75 * _95;
  float _103 = _226;
  precise float _229 = _77 * _95;
  float _105 = _229;
  precise float _232 = _79 * _95;
  float _107 = _232;
  precise float _236 = _101 * fp_c10_1._m0[8].z;
  float _109 = _236;
  precise float _240 = _103 * fp_c10_1._m0[8].y;
  float _111 = _240;
  precise float _244 = _105 * fp_c10_1._m0[8].y;
  float _113 = _244;
  precise float _248 = _107 * fp_c10_1._m0[8].y;
  float _115 = _248;
  float _117 = fma(_111, 2.0, _109);
  float _119 = fma(_113, 2.0, _109);
  float _121 = fma(_115, 2.0, _109);
  _36.x = _117;
  _36.y = _119;
  _36.z = _121;
  _36.w = _81;
}

