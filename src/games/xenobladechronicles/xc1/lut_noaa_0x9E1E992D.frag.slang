#version 450
#include "../shared.h"
#include "../shared.slang"

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_10;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 131) uniform sampler3D fp_t_tcb_C;
layout(set = 2, binding = 132) uniform sampler3D fp_t_tcb_E;

layout(location = 0) in vec4 uv;
layout(location = 0) out vec4 _46;

void main() {
  vec3 tcbA = texture(fp_t_tcb_A, uv.xy).xyz;
  float blendSeed = fma(tcbA.y, 31.875, tcbA.x * 0.125);
  blendSeed = fma(tcbA.z, fp_c1_1._m0[0].x, blendSeed);

  float depthNumerator = fma(-2.0 * blendSeed, fp_c3_1._m0[2].y, fp_c3_1._m0[2].z);
  gl_FragDepth = depthNumerator / (2.0 * blendSeed);

  
  vec3 scene = texture(fp_t_tcb_8, uv.xy).xyz;
  float exposure = 1.0 / texture(fp_t_tcb_10, vec2(0.0)).x;
  scene *= exposure;

  if (RENODX_TONE_MAP_TYPE == 0) scene = saturate(scene);
  vec3 finalColor = lut(scene);
  vec3 hdr = lut(scene, true);

  if (RENODX_TONE_MAP_TYPE != 0) finalColor = ColourCorrect(hdr, finalColor);
  finalColor = ApplyColorGrade(finalColor);
  finalColor = DisplayMap(finalColor);
  finalColor = renodx::draw::RenderIntermediatePass(finalColor);

  _46 = vec4(finalColor, 1.0);
}

vec3 lut(vec3 color, bool extended = false) {
  vec3 tcbA = texture(fp_t_tcb_A, uv.xy).xyz;
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  color *= scale;
  vec3 encoded = renodx::math::SafePow(color, fp_c3_1._m0[2].x);

  vec3 sampleCoord = encoded * fp_c3_1._m0[3].z + fp_c3_1._m0[3].w;
  vec3 tcbC = texture(fp_t_tcb_C, sampleCoord).xyz;
  vec3 tcbE = texture(fp_t_tcb_E, sampleCoord).xyz;

  float blendSeed = fma(tcbA.y, 31.875, tcbA.x * 0.125);
  blendSeed = fma(tcbA.z, fp_c1_1._m0[0].x, blendSeed);
  float blend;
  // blend = exp2(log2(clamp((blendSeed - fp_c3_1._m0[1].x) * fp_c3_1._m0[1].y, 0.0, 1.0)) * fp_c3_1._m0[1].z) * fp_c3_1._m0[1].w;
  blend = saturate((blendSeed - fp_c3_1._m0[1].x) * fp_c3_1._m0[1].y);
  blend = pow(blend, fp_c3_1._m0[1].z) * fp_c3_1._m0[1].w;

  vec3 mixed = mix(tcbC, tcbE, blend);
  vec3 base = renodx::math::SafePow(color, fp_c3_1._m0[2].x);
  // finalColor = renodx::color::srgb::DecodeSafe(finalColor);
  vec3 finalColor = mix(base, mixed, fp_c3_1._m0[2].w);
  // finalColor = renodx::color::gamma::DecodeSafe(finalColor, 1 / fp_c3_1._m0[2].x);
  finalColor = renodx::color::srgb::DecodeSafe(finalColor);
  finalColor = lerp(color, finalColor, LUT_STRENGTH) / scale;

  return finalColor;
}
