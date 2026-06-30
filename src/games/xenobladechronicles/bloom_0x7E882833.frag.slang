#version 450
#include "./shared.h"

layout(set = 0, binding = 0, std140) uniform support_buffer
{
    uint _m0;
    uint _m1[8];
    vec4 _m2;
    vec4 _m3;
    int _m4;
    float _m5[73];
    ivec4 _m6;
    int _m7;
} support_buffer_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 uv;
layout(location = 0) out vec4 out;

void main()
{
    vec4 sampled = texture(fp_t_tcb_8, uv.xy);
    out = max(sampled, 0);
    out.xyz *= CUSTOM_BLOOM;
}

