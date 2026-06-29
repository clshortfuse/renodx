#version 450

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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 _27;
layout(location = 0) out vec4 _30;

void main()
{
    vec2 uv = _27.xy;
    vec2 texel_offset = fp_c3_1._m0[1].zw;

    vec4 sample_up = texture(fp_t_tcb_8, uv + vec2(0.0, texel_offset.y));
    vec4 sample_down = texture(fp_t_tcb_8, uv - vec2(0.0, texel_offset.y));
    vec4 sample_left = texture(fp_t_tcb_8, uv - vec2(texel_offset.x, 0.0));
    vec4 sample_right = texture(fp_t_tcb_8, uv + vec2(texel_offset.x, 0.0));
    vec4 sample_center = texture(fp_t_tcb_8, uv);

    vec4 neighbor_sum = sample_up + sample_down + sample_left + sample_right;
    vec4 filtered = fma(sample_center, vec4(fp_c3_1._m0[0].x), -neighbor_sum * fp_c3_1._m0[0].y);

    _30 = max(filtered, vec4(0.0));
}

