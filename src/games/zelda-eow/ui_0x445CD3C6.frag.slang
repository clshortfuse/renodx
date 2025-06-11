// zelda eow UI

#version 450

#include "./common.slangi"

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
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;

layout(location = 2) in vec4 _31;
layout(location = 3) in vec4 _33;
layout(location = 1) in vec4 _35;
layout(location = 0) out vec4 _38;

void main()
{
    bool _46 = 0.0 != fp_c3_1._m0[0].y;
    bool _48 = isnan(0.0);
    bool _50 = _46 || _48;
    bool _52 = isnan(fp_c3_1._m0[0].y);
    bool _54 = _50 || _52;
    float _57 = _31.x;
    float _59 = _31.y;
    float _61 = _33.x;
    float _63 = _33.y;
    float _65 = _35.x;
    float _67 = _35.y;
    float _69 = texture(fp_t_tcb_A, vec2(_57, _59)).w;
    vec3 _73 = texture(fp_t_tcb_C, vec2(_61, _63)).xyz;
    float _75 = _73.x;
    float _77 = _73.y;
    float _79 = _73.z;
    float _81 = 0.0;
    if (_54)
    {
        float _83 = texture(fp_t_tcb_8, vec2(_65, _67)).w;
        _81 = _83;
    }
    float _85 = _81;
    float _87 = texture(fp_t_tcb_8, vec2(_65, _67)).y;
    float _89 = texture(fp_t_tcb_8, vec2(_65, _67)).x;
    float _91 = 0.0;
    float _93 = _85;
    if (_54)
    {
        float _95 = texture(fp_t_tcb_C, vec2(_61, _63)).w;
        _91 = _95;
    }
    float _97 = _91;
    vec3 _99 = texture(fp_t_tcb_A, vec2(_57, _59)).xyz;
    float _101 = _99.x;
    float _103 = _99.y;
    float _105 = _99.z;
    precise float _256 = _77 * fp_c3_1._m0[3].y;
    float _107 = _256;
    precise float _260 = _75 * fp_c3_1._m0[3].x;
    float _109 = _260;
    precise float _265 = _79 * fp_c3_1._m0[3].z;
    float _111 = _265;
    if (_54)
    {
        precise float _270 = _69 + _85;
        float _113 = _270;
        _93 = _113;
    }
    float _115 = _93;
    precise float _276 = _107 * _69;
    float _117 = _276;
    float _119 = -_69;
    precise float _281 = _119 + 1.0;
    float _121 = _281;
    precise float _284 = _109 * _69;
    float _123 = _284;
    precise float _287 = _111 * _69;
    float _125 = _287;
    float _127 = _115;
    if (_54)
    {
        precise float _293 = _115 + _97;
        float _129 = _293;
        _127 = _129;
    }
    float _131 = _127;
    float _133 = fma(_117, fp_c3_1._m0[2].w, _103);
    float _135 = fma(_87, _121, _89);
    float _137 = fma(_123, fp_c3_1._m0[2].w, _101);
    float _139 = fma(_125, fp_c3_1._m0[2].w, _105);
    float _141 = fma(_87, fp_c3_1._m0[1].y, _133);
    float _143 = _135;
    if (_54)
    {
        float _145 = fma(_131, fp_c3_1._m0[0].y, _135);
        _143 = _145;
    }
    float _147 = _143;
    float _149 = fma(_87, fp_c3_1._m0[1].x, _137);
    float _151 = fma(_87, fp_c3_1._m0[1].z, _139);
    precise float _345 = _147 + (-0.0);
    float _153 = _345;
    float _155 = clamp(_153, 0.0, 1.0);
    _38.x = _149;
    _38.y = _141;
    _38.z = _151;
    _38.w = _155;

    // _38.rgb = renodx::color::bt2020::from::BT709(_38.rgb);

}

