#version 450
#include "./shared.h"

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 uv;
layout(location = 0) out vec4 out;

void main()
{
    vec4 bloom = texture(fp_t_tcb_8, uv.xy).xyzw;
    out = bloom * fp_c3_1._m0[0].x * CUSTOM_BLOOM;
}

