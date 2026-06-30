#version 450
#include "../shared.h"

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 _29;
layout(location = 0) out vec4 _32;
layout(location = 1) out vec4 _34;

void main()
{
    vec2 uv = _29.xy;
    vec4 sample_color = texture(fp_t_tcb_8, uv);
    vec4 scaled_color = sample_color * fp_c3_1._m0[1].x;

    precise float _116 = scaled_color.x * 0.2989999949932098388671875;
    float _64 = _116;
    float _66 = fma(scaled_color.y, fp_c1_1._m0[0].x, _64);
    float _68 = fma(scaled_color.z, fp_c1_1._m0[0].y, _66);
    precise float _131 = _68 * fp_c3_1._m0[1].y;
    float _70 = _131;
    precise float _134 = _70 * 25.0;
    float bloom_mask = saturate(_134);

    _32 = scaled_color * CUSTOM_BLOOM;
    _34 = vec4(bloom_mask) * CUSTOM_BLOOM;
}

