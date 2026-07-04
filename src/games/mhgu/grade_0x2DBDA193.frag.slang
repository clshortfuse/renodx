#version 450
#include "./shared.h"
#include "./shared.slang"


layout(set = 0, binding = 23, std140) uniform fp_c4
{
    vec4 _m0[4096];
} fp_c4_1;

layout(set = 0, binding = 24, std140) uniform fp_c5
{
    vec4 _m0[4096];
} fp_c5_1;

layout(set = 0, binding = 25, std140) uniform fp_c6
{
    vec4 _m0[4096];
} fp_c6_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;

layout(location = 1) in vec4 inUV;
layout(location = 0) out vec4 outColor;

void main()
{
    vec4 sampled = texture(fp_t_tcb_A, inUV.xy).xyzw;
    vec3 src = sampled.xyz;

    precise vec3 row1 = src.y * fp_c4_1._m0[1].xyz;

    vec3 mixed = fma(src.x, fp_c4_1._m0[0].xyz, row1);
    mixed = fma(src.z, fp_c4_1._m0[2].xyz, mixed);

    float lerpFactor = fp_c5_1._m0[0].w;
    vec3 base = fma(src, vec3(-lerpFactor), src);

    precise vec3 graded = mixed + fp_c4_1._m0[3].xyz;

    vec3 blended = fma(graded, vec3(lerpFactor), base);

    outColor = vec4(renodx::math::SignPow(blended, fp_c6_1._m0[0].xyz), sampled.w);

    // outColor = renodx::draw::InvertIntermediatePass(outColor);
    outColor.xyz = lerp(src, outColor.xyz, GRADE_STRENGTH);
    outColor.xyz = renodx::color::srgb::DecodeSafe(outColor.xyz);
    outColor.xyz = ApplyColorGrade(outColor.xyz);
    if (RENODX_TONE_MAP_TYPE == 0) outColor.xyz = saturate(outColor.xyz);
    outColor.xyz = DisplayMap(outColor.xyz);

    outColor = renodx::draw::RenderIntermediatePass(outColor);
    
}

