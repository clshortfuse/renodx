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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;

layout(location = 2) in vec4 _29;
layout(location = 1) in vec4 _31;
layout(location = 0) out vec4 _34;

void main()
{
    int _41 = floatBitsToInt(fp_c3_1._m0[8].x) & 128;
    float _44 = _29.x;
    float _46 = _29.y;
    float _48 = _31.x;
    float _50 = _31.y;
    vec4 _53 = texture(fp_t_tcb_A, vec2(_44, _46)).xyzw;
    float _55 = _53.x;
    float _57 = _53.y;
    float _59 = _53.z;
    float _61 = _53.w;
    vec4 _63 = texture(fp_t_tcb_8, vec2(_48, _50)).xyzw;
    float _65 = _63.x;
    float _67 = _63.y;
    float _69 = _63.z;
    float _71 = _63.w;
    bool _75 = _41 == 0;
    float _77 = intBitsToFloat(_41);
    if (_75)
    {
        float _79 = max(_61, _71);
        _77 = _79;
    }
    float _81 = _77;
    float _83 = fma(_55, _61, _65);
    float _85 = fma(_57, _61, _67);
    float _87 = fma(_59, _61, _69);
    float _89 = _81;
    if (!_75)
    {
        float _91 = min(_61, _71);
        _89 = _91;
    }
    float _93 = _89;
    float _95 = fma(_83, fp_c3_1._m0[0].x, fp_c3_1._m0[1].x);
    float _97 = fma(_85, fp_c3_1._m0[0].y, fp_c3_1._m0[1].y);
    float _99 = fma(_87, fp_c3_1._m0[0].z, fp_c3_1._m0[1].z);
    float _101 = fma(_93, fp_c3_1._m0[0].w, fp_c3_1._m0[1].w);
    _34.x = _95;
    _34.y = _97;
    _34.z = _99;
    _34.w = saturate(_101); //saturate alpha
}

