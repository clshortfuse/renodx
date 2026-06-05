#version 450
#include "./shared.h"
#include "./shared.slang"



layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 in;
layout(location = 0) out vec4 out;

void main()
{
    vec4 scene = texture(fp_t_tcb_8, in.xy);

    precise vec3 curved = scene.rgb / (scene.rgb + 1.0);
    vec3 clamped = min(curved, fp_c3_1._m0[0].xyz);

    scene.rgb = ColourCorrect(scene.rgb, clamped);
    if (RENODX_TONE_MAP_TYPE != 0) clamped = scene.rgb;

    out = vec4(clamped, scene.a);
    out.xyz = ApplyColorGrade(out.xyz);
    out = renodx::draw::RenderIntermediatePass(out);
}

