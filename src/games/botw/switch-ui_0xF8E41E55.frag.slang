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

layout(location = 1) in vec4 _27;
layout(location = 0) in vec4 _29;
layout(location = 0) out vec4 _32;

void main()
{
    float _39 = _27.x;
    float _41 = _27.y;
    vec4 _44 = texture(fp_t_tcb_8, vec2(_39, _41)).xyzw;
    float _46 = _44.x;
    float _48 = _44.y;
    float _50 = _44.z;
    float _52 = _44.w;
    float _54 = _29.x;
    float _56 = _29.y;
    float _58 = _29.z;
    float _60 = _29.w;
    float _62 = fma(_46, fp_c3_1._m0[0].x, fp_c3_1._m0[1].x);
    float _64 = fma(_48, fp_c3_1._m0[0].y, fp_c3_1._m0[1].y);
    float _66 = fma(_50, fp_c3_1._m0[0].z, fp_c3_1._m0[1].z);
    float _68 = fma(_52, fp_c3_1._m0[0].w, fp_c3_1._m0[1].w);
    precise float _137 = _62 * _54;
    float _70 = _137;
    precise float _140 = _64 * _56;
    float _72 = _140;
    precise float _143 = _66 * _58;
    float _74 = _143;
    precise float _146 = _68 * _60;
    float _76 = _146;
    _32.x = _70;
    _32.y = _72;
    _32.z = _74;
    _32.w = saturate(_76); //saturate alpha
}

