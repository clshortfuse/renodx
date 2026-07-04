#version 450
#include "./shared.h"

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
    precise vec2 clipXY = inUV.xy * fragW;
    precise float invW = 1.0 / fragW;
    precise vec2 uv = clipXY * invW;

    vec4 sampled = texture(fp_t_tcb_8, uv).xyzw;
    vec3 mappedColor = renodx::math::SignPow(sampled.xyz, fp_c3_1._m0[0].x);

    outColor = vec4(mappedColor, sampled.w);
   
}

