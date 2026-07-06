#version 450
#include "./shared.h"

layout(set = 0, binding = 19, std140) uniform fp_c0
{
    vec4 _m0[4096];
} fp_c0_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;

layout(location = 0) noperspective in vec4 _29;
layout(location = 1) noperspective in vec4 _31;
layout(location = 0) out vec4 out;

void main()
{
    vec2 uv = _29.xy;

    vec3 baseSample = texture(fp_t_tcb_8, uv).xyz;
    vec4 overlaySample = texture(fp_t_tcb_A, uv);

    vec4 clampedInput = saturate(_31);
    float blend = clampedInput.w;

    vec3 denom = renodx::math::Select(RENODX_TONE_MAP_TYPE == 0, baseSample / baseSample + 1, baseSample);
    vec3 mixed = fma(baseSample, denom, overlaySample.xyz);
    if (RENODX_TONE_MAP_TYPE == 0) mixed = saturate(mixed);
    vec3 outRgb = fma(clampedInput.xyz, vec3(blend), mixed);
    out = vec4(outRgb, overlaySample.w);
}

