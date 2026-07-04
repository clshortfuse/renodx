#version 450
#include "./shared.h"
#include "./shared.slang"

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler3D fp_t_tcb_A;

layout(location = 0) noperspective in vec4 in;
layout(location = 0) out vec4 out;

void main() {
  vec4 scene = texture(fp_t_tcb_8, in.xy);

  vec3 color = Tonemap(scene.rgb);
  vec3 hdr = Tonemap(scene.rgb, true);
  color = lut(color);
  hdr = lut(hdr, true);

  if (RENODX_TONE_MAP_TYPE != 0) color = ColourCorrect(hdr, color);
  out.xyz = ApplyColorGrade(color);
  out.w = scene.w;
  out.xyz = DisplayMap(out.xyz);
  out = renodx::draw::RenderIntermediatePass(out);
}

vec3 Tonemap(vec3 color, bool extended = false) {
  color *= fp_c3_1._m0[0].x;
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  color *= scale;
  vec4 curve0_params = fp_c3_1._m0[1];
  vec4 curve1_params = fp_c3_1._m0[2];
  vec4 curve2_params = fp_c3_1._m0[3];

  precise vec3 base_curve = fma(color * color, fma(color, curve0_params.x, curve0_params.y), fma(color, curve0_params.z, curve0_params.w));

  precise vec3 mid_curve = fma(color, curve1_params.x, curve1_params.y);

  precise vec3 ratio_input = fma(color, curve2_params.y, curve2_params.z);
  precise vec3 high_curve = fma(ratio_input / (ratio_input + 1.0), curve2_params.x, curve2_params.w);

  vec3 mid_mask = step(vec3(curve1_params.z), color);
  vec3 high_mask = step(vec3(curve1_params.w), color);

  vec3 result = base_curve + (mid_curve - base_curve) * mid_mask + (high_curve - mid_curve) * high_mask;
  return result / scale;
}

vec3 lut(vec3 color, bool extended = false) {
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  color *= scale;
  vec4 lut_params = fp_c3_1._m0[4];
  vec3 lut_coords = fma(color, lut_params.y, lut_params.x);
  vec3 graded = texture(fp_t_tcb_A, lut_coords).xyz;
  graded = lerp(color, graded, LUT_STRENGTH);
  graded = renodx::math::PowSafe(graded, fp_c3_1._m0[0].z);
  return graded / scale;
}