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

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 in_attr0;
layout(location = 0) out vec4 out_attr0;

void main()
{
    const float green_weight = 0.715200006961822509765625;
    const vec4 zero = vec4(0.0);
    const vec4 max_weight = vec4(8.0);

    vec2 uv = in_attr0.xy;
    vec2 offset = fp_c3_1._m0[1].xy;
    vec2 uv_pp = uv + offset;
    vec2 uv_nn = uv - offset;

    vec4 sample_pp = texture(fp_t_tcb_8, uv_pp);
    vec4 sample_nn = texture(fp_t_tcb_8, uv_nn);
    vec4 sample_pn = texture(fp_t_tcb_8, vec2(uv_pp.x, uv_nn.y));
    vec4 sample_np = texture(fp_t_tcb_8, vec2(uv_nn.x, uv_pp.y));

    float luma_r_weight = fp_c1_1._m0[0].x;
    float luma_b_weight = fp_c1_1._m0[0].y;
    float min_metric = fp_c1_1._m0[0].z;
    float metric_scale = fp_c3_1._m0[0].x;
    float metric_bias = fp_c3_1._m0[0].y;

    vec4 sample_r = vec4(sample_pp.r, sample_nn.r, sample_pn.r, sample_np.r);
    vec4 sample_g = vec4(sample_pp.g, sample_nn.g, sample_pn.g, sample_np.g);
    vec4 sample_b = vec4(sample_pp.b, sample_nn.b, sample_pn.b, sample_np.b);
    vec4 sample_a = vec4(sample_pp.a, sample_nn.a, sample_pn.a, sample_np.a);

    precise vec4 metrics =
        fma(sample_b, vec4(luma_b_weight), fma(sample_r, vec4(luma_r_weight), sample_g * green_weight))
        * metric_scale;

    precise vec4 weights = max(zero, min(metrics - vec4(metric_bias), max_weight)) / max(metrics, vec4(min_metric));

    vec3 weighted_sum = vec3(
        dot(sample_r, weights),
        dot(sample_g, weights),
        dot(sample_b, weights));

    vec3 color_scale = fp_c3_1._m0[2].xyz * (metric_scale * 0.25);
    vec3 clamped_color = min(weighted_sum * color_scale, fp_c3_1._m0[3].xyz);
    float average_alpha = dot(sample_a, vec4(0.25));

    out_attr0 = vec4(clamped_color, average_alpha);
}

