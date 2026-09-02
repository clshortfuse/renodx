#version 450

#include "./shared.h"

layout(set = 0, binding = 25, std140) uniform fp_c6
{
    vec4 _m0[4096];
} fp_c6_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;

layout(location = 0) noperspective in vec4 uv;
layout(location = 0) out vec4 out;

void main()
{
    vec4 bloom = textureLod(fp_t_tcb_8, uv.xy, 0.0);
    vec4 scene = textureLod(fp_t_tcb_A, uv.xy, 0.0);
    out = fma(bloom, fp_c6_1._m0[0], scene);
}

