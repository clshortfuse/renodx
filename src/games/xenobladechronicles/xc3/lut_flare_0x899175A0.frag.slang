#version 450
#include "../shared.h"
#include "../shared.slang"

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_10;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_C;

layout(location = 0) in vec4 _34;
layout(location = 0) out vec4 out;

void main()
{
    vec2 uv = _34.xy;
    float exposure = 1.f / texture(fp_t_tcb_10, vec2(0.0)).x;
    float flare_scale = saturate(fp_c3_1._m0[4].x);
    vec3 color = texture(fp_t_tcb_8, uv).xyz;
    vec3 scene = color * flare_scale;
    vec3 lut_in = scene * exposure;
    color = lut(lut_in);
    vec3 hdr = lut(lut_in, true);
    if (RENODX_TONE_MAP_TYPE != 0.f) color = ColourCorrect(hdr, color);
    float flare_bias = max(0.0, fp_c3_1._m0[4].x - 1.0);
    vec3 flare_add = fma(scene, flare_bias, fp_c3_1._m0[4].y) * exposure;
    color = renodx::color::gamma::DecodeSafe(color, 1.0 / fp_c3_1._m0[2].x);
    color += flare_add;
    if (RENODX_TONE_MAP_TYPE == 0.f) color = saturate(color);
    color = renodx::math::SafePow(color, fp_c3_1._m0[2].x);
    color = renodx::color::srgb::DecodeSafe(color);
    color = ApplyColorGrade(color);
    color = DisplayMap(color);
    color = renodx::draw::RenderIntermediatePass(color);
    out = vec4(color, 1.0);
}

vec3 lut(vec3 color, bool extended = false) {
  if (!extended) color = saturate(color);
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  vec3 input = color * scale;
  vec3 encoded = renodx::math::SafePow(input, fp_c3_1._m0[2].x);
  vec3 sampleCoord = encoded * fp_c3_1._m0[3].z + fp_c3_1._m0[3].w;
  vec3 lutColor = texture(fp_t_tcb_C, sampleCoord).xyz;
  color = renodx::math::SafePow(color * scale, fp_c3_1._m0[2].x);
  lutColor = lerp(color, lutColor, LUT_STRENGTH);
  lutColor = renodx::color::srgb::DecodeSafe(lutColor) / scale;
  lutColor = renodx::color::srgb::EncodeSafe(lutColor);

  return lutColor;
}