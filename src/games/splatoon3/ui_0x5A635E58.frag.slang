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

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_C;

layout(location = 1) in vec4 _33;
layout(location = 2) in vec4 _35;
layout(location = 3) in vec4 _37;
layout(location = 0) in vec4 _39;
layout(location = 0) out vec4 _42;

void main()
{
    bool _50 = 0.0 != fp_c3_1._m0[0].x;
    bool _52 = isnan(0.0);
    bool _54 = _50 || _52;
    bool _56 = isnan(fp_c3_1._m0[0].x);
    bool _58 = _54 || _56;
    float _61 = _33.x;
    float _63 = _33.y;
    float _65 = 0.0;
    float _67 = _61;
    if (_58)
    {
        float _69 = _35.x;
        _65 = _69;
    }
    float _71 = _65;
    float _73 = 0.0;
    if (_58)
    {
        float _75 = _35.y;
        _73 = _75;
    }
    float _77 = _73;
    float _79 = 0.0;
    if (_58)
    {
        float _81 = _37.x;
        _79 = _81;
    }
    float _83 = _79;
    float _85 = floor(_61);
    precise float _256 = _63 * fp_c3_1._m0[18].z;
    float _87 = _256;
    float _89 = floor(_87);
    precise float _261 = _85 * 12.98980045318603515625;
    float _91 = _261;
    float _93 = 0.0;
    float _95 = _89;
    float _97 = _83;
    if (_58)
    {
        float _99 = texture(fp_t_tcb_A, vec2(_71, _77)).w;
        _93 = _99;
    }
    float _101 = _93;
    float _103 = fma(_89, fp_c1_1._m0[0].x, _91);
    float _105 = _101;
    if (_58)
    {
        float _107 = _37.y;
        _95 = _107;
    }
    float _109 = _95;
    float _111 = sin(_103);
    precise float _293 = _111 * 43758.546875;
    float _113 = _293;
    float _115 = floor(_113);
    float _117 = -_115;
    precise float _300 = _113 + _117;
    float _119 = _300;
    bool _121 = _119 <= fp_c3_1._m0[18].x;
    float _123 = float(_121);
    precise float _311 = _123 * fp_c3_1._m0[18].y;
    float _125 = _311;
    float _127 = fma(_125, fp_c1_1._m0[0].y, _61);
    if (_58)
    {
        float _129 = texture(fp_t_tcb_8, vec2(_61, _63)).w;
        _67 = _129;
    }
    float _131 = _67;
    vec4 _134 = texture(fp_t_tcb_8, vec2(_127, _63)).xyzw;
    float _136 = _134.x;
    float _138 = _134.y;
    float _140 = _134.z;
    float _142 = _134.w;
    if (_58)
    {
        float _144 = texture(fp_t_tcb_C, vec2(_83, _109)).w;
        _97 = _144;
    }
    float _146 = _97;
    float _148 = _39.w;
    float _150 = _39.y;
    float _152 = -fp_c3_1._m0[1].w;
    precise float _364 = fp_c3_1._m0[2].w + _152;
    float _154 = _364;
    float _156 = _39.z;
    float _158 = _39.x;
    float _160 = _146;
    if (_58)
    {
        precise float _374 = _131 + _101;
        float _162 = _374;
        _105 = _162;
    }
    float _164 = _105;
    float _166 = fma(_154, _142, fp_c3_1._m0[1].w);
    if (_58)
    {
        precise float _387 = _164 + _146;
        float _168 = _387;
        _160 = _168;
    }
    float _170 = _160;
    precise float _393 = _166 * _148;
    float _172 = _393;
    float _174 = -fp_c3_1._m0[1].x;
    precise float _400 = fp_c3_1._m0[2].x + _174;
    float _176 = _400;
    float _178 = -fp_c3_1._m0[1].y;
    precise float _407 = fp_c3_1._m0[2].y + _178;
    float _180 = _407;
    float _182 = -fp_c3_1._m0[1].z;
    precise float _414 = fp_c3_1._m0[2].z + _182;
    float _184 = _414;
    int _187 = floatBitsToInt(_172);
    if (_58)
    {
        float _189 = fma(_170, fp_c3_1._m0[0].x, _172);
        _187 = floatBitsToInt(_189);
    }
    int _191 = _187;
    float _193 = fma(_176, _136, fp_c3_1._m0[1].x);
    float _195 = fma(_180, _138, fp_c3_1._m0[1].y);
    float _197 = fma(_184, _140, fp_c3_1._m0[1].z);
    precise float _445 = _193 * _158;
    float _199 = _445;
    precise float _448 = _195 * _150;
    float _201 = _448;
    precise float _451 = _197 * _156;
    float _203 = _451;
    _42.x = _199;
    _42.y = _201;
    _42.z = _203;
    _42.w = intBitsToFloat(_191);
}

