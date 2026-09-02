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
layout(location = 0) in vec4 _33;
layout(location = 0) out vec4 _36;

void main()
{
    int _43 = floatBitsToInt(fp_c3_1._m0[8].x) & 128;
    float _46 = _29.x;
    float _48 = _29.y;
    float _50 = _31.x;
    float _52 = _31.y;
    vec4 _55 = texture(fp_t_tcb_A, vec2(_46, _48)).xyzw;
    float _57 = _55.x;
    float _59 = _55.y;
    float _61 = _55.z;
    float _63 = _55.w;
    vec4 _65 = texture(fp_t_tcb_8, vec2(_50, _52)).xyzw;
    float _67 = _65.x;
    float _69 = _65.y;
    float _71 = _65.z;
    float _73 = _65.w;
    bool _77 = _43 == 0;
    float _79 = _33.x;
    float _81 = _33.y;
    float _83 = _33.z;
    float _85 = _33.w;
    float _87 = fma(_57, _63, _67);
    float _89 = _67;
    if (_77)
    {
        float _91 = max(_63, _73);
        _89 = _91;
    }
    float _93 = _89;
    float _95 = _93;
    if (!_77)
    {
        float _97 = min(_63, _73);
        _95 = _97;
    }
    float _99 = _95;
    float _101 = fma(_59, _63, _69);
    float _103 = fma(_61, _63, _71);
    float _105 = fma(_103, fp_c3_1._m0[0].z, fp_c3_1._m0[1].z);
    float _107 = fma(_87, fp_c3_1._m0[0].x, fp_c3_1._m0[1].x);
    float _109 = fma(_101, fp_c3_1._m0[0].y, fp_c3_1._m0[1].y);
    float _111 = fma(_99, fp_c3_1._m0[0].w, fp_c3_1._m0[1].w);
    precise float _237 = _105 * _83;
    float _113 = _237;
    precise float _240 = _107 * _79;
    float _115 = _240;
    precise float _243 = _109 * _81;
    float _117 = _243;
    precise float _246 = _111 * _85;
    float _119 = _246;
    _36.x = _115;
    _36.y = _117;
    _36.z = _113;
    _36.w = saturate(_119); //saturate alpha
}

