#version 450
#include "./shared.h"

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_C;

layout(location = 0) noperspective in vec4 uv;
layout(location = 0) out vec4 out;

void main()
{
    float _39 = texture(fp_t_tcb_8, uv.xy).x;
    float _41 = texture(fp_t_tcb_A, uv.xy).x;
    vec3 _45 = texture(fp_t_tcb_C, uv.xy).xyz;
    out.xyz = _39 * _41 * _45;
    out.w = 1.0;
}

