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
layout(location = 0) in vec4 _37;
layout(location = 0) out vec4 _40;

void main()
{
    bool _48 = 0.0 != fp_c3_1._m0[0].y;
    bool _50 = isnan(0.0);
    bool _52 = _48 || _50;
    bool _54 = isnan(fp_c3_1._m0[0].y);
    bool _56 = _52 || _54;
    float _59 = 0.0;
    if (_56)
    {
        float _61 = _31.x;
        _59 = _61;
    }
    float _63 = _59;
    float _65 = 0.0;
    float _67 = _63;
    if (_56)
    {
        float _69 = _31.y;
        _65 = _69;
    }
    float _71 = _65;
    float _73 = _33.x;
    float _75 = _33.y;
    float _77 = 0.0;
    if (_56)
    {
        float _79 = _35.x;
        _77 = _79;
    }
    float _81 = _77;
    float _83 = 0.0;
    float _85 = _81;
    if (_56)
    {
        float _87 = _35.y;
        _83 = _87;
    }
    float _89 = _83;
    if (_56)
    {
        float _91 = texture(fp_t_tcb_A, vec2(_63, _71)).w;
        _67 = _91;
    }
    float _93 = _67;
    float _95 = 0.0;
    if (_56)
    {
        float _97 = texture(fp_t_tcb_8, vec2(_73, _75)).w;
        _95 = _97;
    }
    float _99 = _95;
    float _101 = texture(fp_t_tcb_8, vec2(_73, _75)).w;
    float _103 = _99;
    if (_56)
    {
        float _105 = texture(fp_t_tcb_C, vec2(_81, _89)).w;
        _85 = _105;
    }
    float _107 = _85;
    vec3 _111 = texture(fp_t_tcb_8, vec2(_73, _75)).xyz;
    float _113 = _111.x;
    float _115 = _111.y;
    float _117 = _111.z;
    float _119 = _37.w;
    float _121 = -_119;
    precise float _274 = _121 + 1.0;
    float _123 = _274;
    precise float _278 = _123 * fp_c3_1._m0[3].w;
    float _125 = _278;
    if (_56)
    {
        precise float _283 = _99 + _93;
        float _127 = _283;
        _103 = _127;
    }
    float _129 = _103;
    float _131 = -_101;
    precise float _290 = _131 + 1.0;
    float _133 = _290;
    float _135 = 0.0;
    float _137 = _125;
    if (_56)
    {
        precise float _296 = _129 + _107;
        float _139 = _296;
        _135 = _139;
    }
    float _141 = _135;
    float _143 = fma(_113, fp_c3_1._m0[3].w, _133);
    float _145 = fma(_115, fp_c3_1._m0[3].w, _133);
    float _147 = fma(_117, fp_c3_1._m0[3].w, _133);
    if (_56)
    {
        float _149 = fma(_141, fp_c3_1._m0[0].y, _125);
        _137 = _149;
    }
    float _151 = _137;
    precise float _328 = _143 + _123;
    float _153 = _328;
    precise float _331 = _145 + _123;
    float _155 = _331;
    precise float _334 = _147 + _123;
    float _157 = _334;
    precise float _337 = _151 + (-0.0);
    float _159 = _337;
    float _161 = clamp(_159, 0.0, 1.0);
    _40.x = _153;
    _40.y = _155;
    _40.z = _157;
    _40.w = _161;
    
    _40 = saturate(_40);
}

