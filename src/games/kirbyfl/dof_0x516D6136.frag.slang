#version 450
#include "./shared.h"

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
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_C;

layout(location = 0) in vec4 _33;
layout(location = 0) out vec4 _36;

void main()
{
    float _43 = gl_FragCoord.w;
    precise float _335 = 1.0 / _43;
    float _45 = _335;
    float _47 = _33.x;
    float _49 = _33.y;
    float _51 = texture(fp_t_tcb_8, vec2(_47, _49)).x;
    float _53 = fma(_51, 2.0, -1.0);
    float _55 = fma(_53, fp_c3_1._m0[0].z, fp_c3_1._m0[0].w);
    precise float _363 = 1.0 / _55;
    float _57 = _363;
    float _59 = fma(_53, fp_c3_1._m0[0].x, fp_c3_1._m0[0].y);
    float _61 = -_57;
    precise float _374 = _59 * _61;
    float _63 = _374;
    bool _67 = _63 < fp_c3_1._m0[2].y;
    float _69 = _45;
    float _71 = _57;
    float _73 = _55;
    float _75 = fp_c3_1._m0[0].x;
    float _77 = _63;
    float _79 = fp_c3_1._m0[0].x;
    float _81 = _63;
    int _84 = floatBitsToInt(_47);
    int _86 = floatBitsToInt(_49);
    if (_67)
    {
        _69 = fp_c3_1._m0[2].x;
    }
    float _88 = _69;
    float _90 = _88;
    if (_67)
    {
        float _92 = -fp_c3_1._m0[2].y;
        precise float _406 = _63 + _92;
        float _94 = _406;
        _71 = _94;
    }
    float _96 = _71;
    float _98 = _96;
    if (_67)
    {
        float _100 = -fp_c3_1._m0[2].y;
        precise float _418 = _88 + _100;
        float _102 = _418;
        _90 = _102;
    }
    float _104 = _90;
    float _106 = _104;
    if (_67)
    {
        precise float _428 = _96 * fp_c3_1._m0[2].z;
        float _108 = _428;
        _98 = _108;
    }
    float _110 = _98;
    float _112 = _110;
    if (_67)
    {
        precise float _436 = 1.0 / _104;
        float _114 = _436;
        _106 = _114;
    }
    float _116 = _106;
    if (_67)
    {
        precise float _444 = _110 * _116;
        float _118 = _444;
        _112 = _118;
    }
    float _120 = _112;
    float _122 = _120;
    float _124 = _120;
    if (!_67)
    {
        bool _126 = _63 < fp_c3_1._m0[1].y;
        float _128 = fp_c3_1._m0[1].y;
        if (!_126)
        {
            float _130 = -fp_c3_1._m0[1].y;
            precise float _468 = _130 + fp_c3_1._m0[1].z;
            float _132 = _468;
            _128 = _132;
        }
        float _134 = _128;
        float _136 = _134;
        if (_126)
        {
            float _138 = -fp_c3_1._m0[1].x;
            precise float _480 = _134 + _138;
            float _140 = _480;
            _73 = _140;
        }
        float _142 = _73;
        float _144 = _142;
        if (!_126)
        {
            precise float _489 = 1.0 / _134;
            float _146 = _489;
            _136 = _146;
        }
        float _148 = _136;
        if (_126)
        {
            float _150 = -fp_c3_1._m0[1].x;
            precise float _500 = _63 + _150;
            float _152 = _500;
            _122 = _152;
        }
        float _154 = _122;
        float _156 = _154;
        if (_126)
        {
            precise float _508 = 1.0 / _142;
            float _158 = _508;
            _144 = _158;
        }
        float _160 = _144;
        if (!_126)
        {
            _75 = fp_c3_1._m0[1].w;
        }
        float _162 = _75;
        float _164 = _162;
        if (!_126)
        {
            float _166 = -fp_c3_1._m0[1].z;
            precise float _528 = _63 + _166;
            float _168 = _528;
            _77 = _168;
        }
        float _170 = _77;
        float _172 = _170;
        if (_126)
        {
            precise float _538 = _154 * fp_c3_1._m0[1].w;
            float _174 = _538;
            _156 = _174;
        }
        float _176 = _156;
        float _178 = _176;
        if (!_126)
        {
            float _180 = -_162;
            precise float _551 = _180 + fp_c3_1._m0[2].w;
            float _182 = _551;
            _164 = _182;
        }
        float _184 = _164;
        _79 = _184;
        if (!_126)
        {
            precise float _561 = _170 * _148;
            float _186 = _561;
            float _188 = clamp(_186, 0.0, 1.0);
            _172 = _188;
        }
        float _190 = _172;
        _81 = _190;
        if (_126)
        {
            precise float _573 = _176 * _160;
            float _192 = _573;
            _178 = _192;
        }
        float _194 = _178;
        float _196 = _194;
        if (!_126)
        {
            float _198 = fma(_190, _184, fp_c3_1._m0[1].w);
            _196 = _198;
        }
        float _200 = _196;
        _124 = _200;
    }
    float _202 = _124;
    float _204 = _79;
    float _206 = _81;
    precise float _596 = _202 + (-0.0);
    float _208 = _596;
    float _210 = clamp(_208, 0.0, 1.0);
    bool _212 = _210 <= 0.0;
    float _214 = _204;
    float _216 = _206;
    float _218 = _210;
    int _220 = floatBitsToInt(_202);
    if (_212)
    {
        discard;
    }
    bool _222 = _210 > 0.5;
    vec3 _226 = texture(fp_t_tcb_A, vec2(_47, _49)).xyz;
    float _228 = _226.x;
    float _230 = _226.y;
    float _232 = _226.z;
    float _234 = 0.0;
    if (_222)
    {
        vec3 _236 = texture(fp_t_tcb_C, vec2(_47, _49)).xyz;
        float _238 = _236.x;
        float _240 = _236.y;
        float _242 = _236.z;
        _214 = _238;
        _234 = _240;
        _216 = _242;
    }
    float _244 = _214;
    float _246 = _234;
    float _248 = _216;
    float _250 = _248;
    float _252 = _244;
    float _254 = _246;
    if (_222)
    {
        precise float _652 = _210 + (-0.5);
        float _256 = _652;
        _218 = _256;
    }
    float _258 = _218;
    if (_222)
    {
        _220 = 1065353216;
    }
    int _260 = _220;
    int _262 = _260;
    if (!_222)
    {
        precise float _666 = _258 * 2.0;
        float _264 = _666;
        _262 = floatBitsToInt(_264);
    }
    int _266 = _262;
    if (!_222)
    {
        _250 = _228;
    }
    float _268 = _250;
    float _270 = _268;
    if (!_222)
    {
        _84 = floatBitsToInt(_230);
    }
    int _272 = _84;
    int _274 = _272;
    if (!_222)
    {
        _86 = floatBitsToInt(_232);
    }
    int _276 = _86;
    int _278 = _276;
    if (_222)
    {
        float _280 = -_228;
        precise float _700 = _280 + _244;
        float _282 = _700;
        _252 = _282;
    }
    float _284 = _252;
    float _286 = _284;
    if (_222)
    {
        float _288 = -_230;
        precise float _711 = _288 + _246;
        float _290 = _711;
        _254 = _290;
    }
    float _292 = _254;
    float _294 = _292;
    if (_222)
    {
        float _296 = -_232;
        precise float _722 = _296 + _268;
        float _298 = _722;
        _270 = _298;
    }
    float _300 = _270;
    int _302 = floatBitsToInt(_300);
    if (_222)
    {
        precise float _732 = _284 * _258;
        float _304 = _732;
        _286 = _304;
    }
    float _306 = _286;
    if (_222)
    {
        precise float _740 = _292 * _258;
        float _308 = _740;
        _294 = _308;
    }
    float _310 = _294;
    float _312 = 0.0;
    if (_222)
    {
        precise float _748 = _300 * _258;
        float _314 = _748;
        _312 = _314;
    }
    float _316 = _312;
    if (_222)
    {
        float _318 = fma(_306, 2.0, _228);
        _302 = floatBitsToInt(_318);
    }
    int _320 = _302;
    if (_222)
    {
        float _322 = fma(_310, 2.0, _230);
        _274 = floatBitsToInt(_322);
    }
    int _324 = _274;
    if (_222)
    {
        float _326 = fma(_316, 2.0, _232);
        _278 = floatBitsToInt(_326);
    }
    int _328 = _278;
    _36.x = intBitsToFloat(_320);
    _36.y = intBitsToFloat(_324);
    _36.z = intBitsToFloat(_328);
    _36.w = intBitsToFloat(_266);

    _36.w *= CUSTOM_DOF;
}

