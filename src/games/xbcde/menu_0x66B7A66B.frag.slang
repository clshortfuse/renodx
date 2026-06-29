#version 450

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 _29;
layout(location = 1) in vec4 _31;
layout(location = 0) out vec4 _34;

void main()
{
    vec4 sampled = texture(fp_t_tcb_8, _29.xy);
    vec3 color = fma(sampled.xyz, _31.xyz, fp_c3_1._m0[5].xyz);
    //color = saturate(color); // vanilla
    float alpha = saturate(sampled.w * _31.w);
    _34 = vec4(color, alpha);
}

