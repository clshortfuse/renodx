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

    precise float scale = fp_c3_1._m0[0].y;

    vec3 scaled = sampled * scale;

    vec3 luminance = vec3(0.2989999949932098388671875, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y);
    float alpha = dot(scaled, luminance);

    // scaled = renodx::color::srgb::DecodeSafe(scaled);
    //  scaled = ApplyColorGrade(scaled);
    //scaled =  DisplayMap(scaled);
    if (RENODX_TONE_MAP_TYPE == 0) scaled = saturate(scaled);
    outColor = vec4(scaled, alpha);
    //outColor = renodx::draw::RenderIntermediatePass(outColor);
    //outColor = saturate(outColor);
}

