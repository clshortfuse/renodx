#version 450
#include "./shared.h"
#include "./shared.slang"

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 inUV;
layout(location = 0) out vec4 outColor;

void main()
{
    precise float fragW = gl_FragCoord.w;
    precise float clipX = inUV.x * fragW;
    precise float clipY = inUV.y * fragW;
    precise float invW = 1.0 / fragW;
    precise vec2 uv = vec2(invW * clipX, invW * clipY);

    vec3 sampled = texture(fp_t_tcb_8, uv).xyz;
    vec3 bloom = sampled * fp_c3_1._m0[0].xyz;// * CUSTOM_BLOOM;

    bloom = renodx::color::srgb::DecodeSafe(bloom);
    if (RENODX_TONE_MAP_TYPE == 0) bloom = saturate(bloom);
    outColor = vec4(bloom * CUSTOM_BLOOM, 1.0);
    outColor.xyz = ApplyColorGrade(outColor.xyz);
    outColor.xyz = DisplayMap(outColor.xyz);
    outColor = renodx::draw::RenderIntermediatePass(outColor);
}

