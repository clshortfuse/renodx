#version 450
#include "../shared.h"
#include "../shared.slang"

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_E;
layout(set = 2, binding = 131) uniform sampler3D fp_t_tcb_C;

layout(location = 0) in vec4 uv;
layout(location = 0) out vec4 out;

void main()
{
    vec3 scene = texture(fp_t_tcb_8, uv.xy).xyz;
    vec3 blend_sample = texture(fp_t_tcb_A, uv.xy).xyz;

    float blend_seed = fma(blend_sample.y, 31.875, blend_sample.x * 0.125);
    blend_seed = fma(blend_sample.z, fp_c1_1._m0[0].x, blend_seed);

    float blend = clamp((blend_seed - fp_c3_1._m0[1].x) * fp_c3_1._m0[1].y, 0.0, 1.0);
    blend = exp2(log2(blend) * fp_c3_1._m0[1].z) * fp_c3_1._m0[1].w;

    float depth_numerator = fma(-2.0 * blend_seed, fp_c3_1._m0[2].y, fp_c3_1._m0[2].z);
    gl_FragDepth = depth_numerator / (2.0 * blend_seed);

    float exposure = fp_c3_1._m0[3].x;
    scene *= exposure;

    if (RENODX_TONE_MAP_TYPE == 0) scene = saturate(scene);
    vec3 finalColor = lut(scene);
    vec3 hdr = lut(scene, true);

    if (RENODX_TONE_MAP_TYPE != 0) finalColor = ColourCorrect(hdr, finalColor);
    finalColor = ApplyColorGrade(finalColor);
    finalColor = DisplayMap(finalColor);
    finalColor = renodx::draw::RenderIntermediatePass(finalColor);

    out = vec4(finalColor, 1.0);
}

vec3 lut(vec3 color, bool extended = false) {
  if (!extended) color = saturate(color);
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  vec3 input = color * scale;
  vec3 blend_sample = texture(fp_t_tcb_A, uv.xy).xyz;
  vec3 encoded = renodx::math::SafePow(input, fp_c3_1._m0[2].x);
  vec3 sampleCoord = encoded * fp_c3_1._m0[3].z + fp_c3_1._m0[3].w;
  vec3 lut_c = texture(fp_t_tcb_C, sampleCoord).xyz;
  vec3 lut_e = texture(fp_t_tcb_E, sampleCoord).xyz;

  float blend_seed = fma(blend_sample.y, 31.875, blend_sample.x * 0.125);
  blend_seed = fma(blend_sample.z, fp_c1_1._m0[0].x, blend_seed);
  float blend = saturate((blend_seed - fp_c3_1._m0[1].x) * fp_c3_1._m0[1].y);
  blend = pow(blend, fp_c3_1._m0[1].z) * fp_c3_1._m0[1].w;

  vec3 lutColor = mix(lut_c, lut_e, blend);
  lutColor = lerp(color, renodx::color::srgb::DecodeSafe(lutColor) / scale, LUT_STRENGTH);

  return lutColor;
}