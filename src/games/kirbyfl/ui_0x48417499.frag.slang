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
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_C;

layout(location = 2) in vec4 _31;
layout(location = 1) in vec4 _33;
layout(location = 3) in vec4 _35;
layout(location = 0) out vec4 _38;

void main()
{
    bool _46 = 0.0 != fp_c3_1._m0[0].y;
    bool _48 = isnan(0.0);
    bool _50 = _46 || _48;
    bool _52 = isnan(fp_c3_1._m0[0].y);
    bool _54 = _50 || _52;
    float _57 = 0.0;
    if (_54)
    {
        float _59 = _31.x;
        _57 = _59;
    }
    float _61 = _57;
    float _63 = 0.0;
    float _65 = _61;
    if (_54)
    {
        float _67 = _31.y;
        _63 = _67;
    }
    float _69 = _63;
    float _71 = _33.x;
    float _73 = _33.y;
    float _75 = 0.0;
    if (_54)
    {
        float _77 = _35.x;
        _75 = _77;
    }
    float _79 = _75;
    float _81 = 0.0;
    float _83 = _79;
    if (_54)
    {
        float _85 = _35.y;
        _81 = _85;
    }
    float _87 = _81;
    if (_54)
    {
        float _89 = texture(fp_t_tcb_A, vec2(_61, _69)).w;
        _65 = _89;
    }
    float _91 = _65;
    float _93 = 0.0;
    if (_54)
    {
        float _95 = texture(fp_t_tcb_8, vec2(_71, _73)).w;
        _93 = _95;
    }
    float _97 = _93;
    float _99 = _97;
    if (_54)
    {
        float _101 = texture(fp_t_tcb_C, vec2(_79, _87)).w;
        _83 = _101;
    }
    float _103 = _83;
    float _105 = texture(fp_t_tcb_8, vec2(_71, _73)).w;
    vec3 _109 = texture(fp_t_tcb_8, vec2(_71, _73)).xyz;
    float _111 = _109.x;
    float _113 = _109.y;
    float _115 = _109.z;
    float _117 = 0.0;
    if (_54)
    {
        precise float _255 = _97 + _91;
        float _119 = _255;
        _117 = _119;
    }
    float _121 = _117;
    if (_54)
    {
        precise float _263 = _121 + _103;
        float _123 = _263;
        _99 = _123;
    }
    float _125 = _99;
    float _127 = -_105;
    precise float _271 = _127 + 1.0;
    float _129 = _271;
    float _131 = 0.0;
    if (_54)
    {
        precise float _277 = _125 * fp_c3_1._m0[0].y;
        float _133 = _277;
        _131 = _133;
    }
    float _135 = _131;
    float _137 = fma(_111, fp_c3_1._m0[3].w, _129);
    float _139 = fma(_113, fp_c3_1._m0[3].w, _129);
    float _141 = fma(_115, fp_c3_1._m0[3].w, _129);
    precise float _300 = _135 + (-0.0);
    float _143 = _300;
    float _145 = clamp(_143, 0.0, 1.0);
    _38.x = _137;
    _38.y = _139;
    _38.z = _141;
    _38.w = _145;

    _38 = saturate(_38);
}

