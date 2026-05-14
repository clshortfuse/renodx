#version 450
#extension GL_EXT_nonuniform_qualifier : require

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

layout(location = 0) in vec4 _27;
layout(location = 0) out vec4 _30;

void main()
{
    float _37 = _27.z;
    float _39 = _27.w;
    float _41 = _27.x;
    float _43 = _27.y;
    vec3 _47 = textureOffset(fp_t_tcb_8, vec2(_37, _39), ivec2(1)).xyz;
    float _49 = _47.x;
    float _51 = _47.y;
    float _53 = _47.z;
    vec3 _55 = textureOffset(fp_t_tcb_8, vec2(_37, _39), ivec2(1, 0)).xyz;
    float _57 = _55.x;
    float _59 = _55.y;
    float _61 = _55.z;
    vec3 _63 = textureOffset(fp_t_tcb_8, vec2(_37, _39), ivec2(0, 1)).xyz;
    float _65 = _63.x;
    float _67 = _63.y;
    float _69 = _63.z;
    vec3 _71 = textureOffset(fp_t_tcb_8, vec2(_37, _39), ivec2(0)).xyz;
    float _73 = _71.x;
    float _75 = _71.y;
    float _77 = _71.z;
    vec4 _80 = texture(fp_t_tcb_8, vec2(_41, _43)).xyzw;
    float _82 = _80.x;
    float _84 = _80.y;
    float _86 = _80.z;
    float _88 = _80.w;
    precise float _415 = _51 * fp_c3_1._m0[2].y;
    float _90 = _415;
    precise float _419 = _59 * fp_c3_1._m0[2].y;
    float _92 = _419;
    precise float _423 = _67 * fp_c3_1._m0[2].y;
    float _94 = _423;
    precise float _427 = _75 * fp_c3_1._m0[2].y;
    float _96 = _427;
    float _98 = fma(_49, fp_c3_1._m0[2].x, _90);
    float _100 = fma(_57, fp_c3_1._m0[2].x, _92);
    float _102 = fma(_65, fp_c3_1._m0[2].x, _94);
    float _104 = fma(_73, fp_c3_1._m0[2].x, _96);
    precise float _452 = _84 * fp_c3_1._m0[2].y;
    float _106 = _452;
    float _108 = fma(_53, fp_c3_1._m0[2].z, _98);
    float _110 = fma(_61, fp_c3_1._m0[2].z, _100);
    float _112 = fma(_69, fp_c3_1._m0[2].z, _102);
    float _114 = fma(_77, fp_c3_1._m0[2].z, _104);
    float _116 = fma(_82, fp_c3_1._m0[2].x, _106);
    float _118 = max(_108, _110);
    float _120 = max(_112, _114);
    float _122 = min(_108, _110);
    float _124 = min(_112, _114);
    float _126 = max(_120, _118);
    float _128 = fma(_86, fp_c3_1._m0[2].z, _116);
    float _130 = min(_124, _122);
    float _132 = max(_128, _126);
    float _134 = min(_128, _130);
    precise float _510 = _126 * fp_c3_1._m0[3].x;
    float _136 = _510;
    float _138 = -_134;
    precise float _515 = _132 + _138;
    float _140 = _515;
    float _142 = max(_136, fp_c3_1._m0[3].y);
    bool _146 = _140 > _142;
    if (!_146)
    {
        _30.x = _82;
        _30.y = _84;
        _30.z = _86;
        _30.w = _88;
        return;
    }
    precise float _538 = _114 + _110;
    float _148 = _538;
    float _150 = -_110;
    precise float _543 = _112 + _150;
    float _152 = _543;
    float _154 = -_114;
    precise float _548 = _108 + _154;
    float _156 = _548;
    precise float _551 = _112 + _148;
    float _158 = _551;
    precise float _554 = _156 + _152;
    float _160 = _554;
    float _162 = -_156;
    precise float _559 = _162 + _152;
    float _164 = _559;
    precise float _562 = _108 + _158;
    float _166 = _562;
    float _168 = abs(_160);
    float _170 = abs(_164);
    float _172 = min(_168, _170);
    precise float _574 = _166 * fp_c3_1._m0[4].z;
    float _174 = _574;
    float _176 = fma(_174, 0.25, fp_c3_1._m0[4].w);
    float _178 = max(_176, _172);
    precise float _585 = 1.0 / _178;
    float _180 = _585;
    precise float _588 = _160 * _180;
    float _182 = _588;
    precise float _591 = _164 * _180;
    float _184 = _591;
    float _186 = min(_182, fp_c3_1._m0[4].y);
    float _188 = min(_184, fp_c3_1._m0[4].y);
    float _190 = -fp_c3_1._m0[4].y;
    float _192 = max(_186, _190);
    float _194 = -fp_c3_1._m0[4].y;
    float _196 = max(_188, _194);
    float _198 = fma(_192, fp_c3_1._m0[1].z, _41);
    float _200 = -fp_c3_1._m0[1].z;
    float _202 = fma(_192, _200, _41);
    float _204 = fma(_196, fp_c3_1._m0[1].w, _43);
    float _206 = fma(_192, fp_c3_1._m0[1].x, _41);
    float _208 = -fp_c3_1._m0[1].x;
    float _210 = fma(_192, _208, _41);
    float _212 = -fp_c3_1._m0[1].w;
    float _214 = fma(_196, _212, _43);
    float _216 = fma(_196, fp_c3_1._m0[1].y, _43);
    float _218 = -fp_c3_1._m0[1].y;
    float _220 = fma(_196, _218, _43);
    vec4 _222 = texture(fp_t_tcb_8, vec2(_198, _204)).xyzw;
    float _224 = _222.x;
    float _226 = _222.y;
    float _228 = _222.z;
    float _230 = _222.w;
    vec4 _232 = texture(fp_t_tcb_8, vec2(_202, _214)).xyzw;
    float _234 = _232.x;
    float _236 = _232.y;
    float _238 = _232.z;
    float _240 = _232.w;
    vec4 _242 = texture(fp_t_tcb_8, vec2(_206, _216)).xyzw;
    float _244 = _242.x;
    float _246 = _242.y;
    float _248 = _242.z;
    float _250 = _242.w;
    vec4 _252 = texture(fp_t_tcb_8, vec2(_210, _220)).xyzw;
    float _254 = _252.x;
    float _256 = _252.y;
    float _258 = _252.z;
    float _260 = _252.w;
    precise float _718 = _226 + _236;
    float _262 = _718;
    precise float _721 = _224 + _234;
    float _264 = _721;
    precise float _724 = _246 + _256;
    float _266 = _724;
    precise float _727 = _244 + _254;
    float _268 = _727;
    precise float _730 = _248 + _258;
    float _270 = _730;
    precise float _733 = _230 + _240;
    float _272 = _733;
    precise float _736 = _262 * 0.5;
    float _274 = _736;
    precise float _739 = _228 + _238;
    float _276 = _739;
    precise float _741 = _264 * 0.5;
    float _278 = _741;
    precise float _744 = _250 + _260;
    float _280 = _744;
    float _282 = fma(_266, 0.5, _274);
    precise float _749 = _276 * 0.5;
    float _284 = _749;
    float _286 = fma(_268, 0.5, _278);
    precise float _754 = _282 * 0.5;
    float _288 = _754;
    float _290 = fma(_270, 0.5, _284);
    precise float _759 = _286 * 0.5;
    float _292 = _759;
    precise float _763 = _288 * fp_c3_1._m0[2].y;
    float _294 = _763;
    precise float _765 = _290 * 0.5;
    float _296 = _765;
    float _298 = fma(_292, fp_c3_1._m0[2].x, _294);
    float _300 = fma(_296, fp_c3_1._m0[2].z, _298);
    bool _302 = _300 <= _126;
    precise float _780 = _272 * 0.5;
    float _304 = _780;
    float _306 = fma(_280, 0.5, _304);
    bool _308 = _130 <= _300;
    bool _310 = _308 && _302;
    precise float _791 = _306 * 0.5;
    float _312 = _791;
    int _315 = floatBitsToInt(_292);
    int _317 = floatBitsToInt(_288);
    int _319 = floatBitsToInt(_296);
    int _321 = floatBitsToInt(_312);
    if (!_310)
    {
        _315 = floatBitsToInt(_278);
    }
    int _323 = _315;
    if (!_310)
    {
        _317 = floatBitsToInt(_274);
    }
    int _325 = _317;
    if (!_310)
    {
        _319 = floatBitsToInt(_284);
    }
    int _327 = _319;
    if (!_310)
    {
        _321 = floatBitsToInt(_304);
    }
    int _329 = _321;
    _30.x = intBitsToFloat(_323);
    _30.y = intBitsToFloat(_325);
    _30.z = intBitsToFloat(_327);
    _30.w = intBitsToFloat(_329);
}

