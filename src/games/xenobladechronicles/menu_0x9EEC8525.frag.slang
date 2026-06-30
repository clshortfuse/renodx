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
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_E;

layout(location = 1) in vec4 _29;
layout(location = 0) in vec4 _31;
layout(location = 2) in vec4 _33;
layout(location = 0) out vec4 _36;

void main()
{
    vec4 sampled = texture(fp_t_tcb_8, _29.xy);
    float mask = texture(fp_t_tcb_E, _31.xy).x;
    vec3 color = fma(sampled.xyz, _33.xyz, fp_c3_1._m0[5].xyz);
    //color = saturate(color);
    float alpha = saturate(sampled.w * _33.w * mask);
    _36 = vec4(color, alpha);
}

