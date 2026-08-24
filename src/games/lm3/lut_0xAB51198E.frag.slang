#version 450
#include "./shared.h"
#include "./shared.slang"

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
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_C;

layout(location = 0) noperspective in vec4 in;
layout(location = 0) out vec4 out;

void main()
{
    vec2 uv = in.xy;

    vec3 scene = textureLod(fp_t_tcb_8, uv, 0.0).xyz;
    vec3 bloom = textureLod(fp_t_tcb_A, uv, 0.0).xyz;
    vec3 color = scene + bloom * 0.25 * CUSTOM_BLOOM;

    precise vec3 scaled = color * fp_c3_1._m0[0].w;
    vec3 hdr = lut(scaled, true);
    vec3 lutColor = lut(scaled);
    if (RENODX_TONE_MAP_TYPE != 0) lutColor = ColourCorrect(hdr, lutColor);

    precise vec2 centeredUv = uv + vec2(-0.5);
    float radial = sqrt(fma(centeredUv.y, centeredUv.y, centeredUv.x * centeredUv.x));
    float vignetteT = saturate(fma(radial, fp_c1_1._m0[0].x, -0.5) * (-3.3333332538604736328125));
    float smooth = vignetteT * vignetteT * fma(vignetteT, -2.0, 3.0);
    float vignetteScale = fma(smooth, fp_c3_1._m0[32].x, -fp_c3_1._m0[32].x);

    lutColor += lutColor * vignetteScale * CUSTOM_VIGNETTE;

    lutColor = ApplyColorGrade(lutColor);
    lutColor = DisplayMap(lutColor);
    lutColor = renodx::draw::RenderIntermediatePass(lutColor);

    out = vec4(lutColor, 1.0);
}

vec3 lut(vec3 color, bool scaled = false)
{
  float scale = (scaled) ? renodx::tonemap::neutwo::ComputeMaxChannelScale(color) : 1;
  vec3 encoded = sqrt(color * scale);
  vec3 lutCoord = fma(encoded, fp_c3_1._m0[0].xyz, fp_c3_1._m0[16].xyz);
  lutCoord = saturate(lutCoord);
  vec3 lut = textureLod(fp_t_tcb_C, lutCoord, 0.0).xyz / scale;
  if (!scaled) color = saturate(color);
  return lerp(color, lut, LUT_STRENGTH);
}