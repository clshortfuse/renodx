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

layout(location = 0) out vec4 _22;

void main()
{
    _22.x = fp_c3_1._m0[10].x;
    _22.y = fp_c3_1._m0[10].y;
    _22.z = fp_c3_1._m0[10].z;
    _22.w = fp_c3_1._m0[10].w;
    _22 = 10;
}

