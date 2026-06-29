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

layout(location = 0) in vec4 _27;
layout(location = 0) out vec4 _30;

void main()
{
    float _37 = _27.x;
    float _39 = _27.y;
    float _41 = fma(0.0, fp_c3_1._m0[1].z, _37);
    float _43 = -fp_c3_1._m0[1].w;
    precise float _258 = _39 + _43;
    float _45 = _258;
    precise float _262 = _39 + fp_c3_1._m0[1].w;
    float _47 = _262;
    vec4 _50 = texture(fp_t_tcb_8, vec2(_41, _45)).xyzw;
    float _52 = _50.x;
    float _54 = _50.y;
    float _56 = _50.z;
    float _58 = _50.w;
    vec4 _60 = texture(fp_t_tcb_8, vec2(_41, _47)).xyzw;
    float _62 = _60.x;
    float _64 = _60.y;
    float _66 = _60.z;
    float _68 = _60.w;
    float _70 = -fp_c3_1._m0[1].z;
    precise float _297 = _37 + _70;
    float _72 = _297;
    float _74 = fma(0.0, fp_c3_1._m0[1].w, _39);
    vec4 _76 = texture(fp_t_tcb_8, vec2(_72, _74)).xyzw;
    float _78 = _76.x;
    float _80 = _76.y;
    float _82 = _76.z;
    float _84 = _76.w;
    precise float _319 = _37 + fp_c3_1._m0[1].z;
    float _86 = _319;
    vec4 _88 = texture(fp_t_tcb_8, vec2(_86, _74)).xyzw;
    float _90 = _88.x;
    float _92 = _88.y;
    float _94 = _88.z;
    float _96 = _88.w;
    vec4 _98 = texture(fp_t_tcb_8, vec2(_37, _39)).xyzw;
    float _100 = _98.x;
    float _102 = _98.y;
    float _104 = _98.z;
    float _106 = _98.w;
    precise float _350 = _52 + _62;
    float _108 = _350;
    precise float _353 = _54 + _64;
    float _110 = _353;
    precise float _356 = _108 + _78;
    float _112 = _356;
    precise float _359 = _110 + _80;
    float _114 = _359;
    precise float _362 = _90 + _112;
    float _116 = _362;
    precise float _365 = _92 + _114;
    float _118 = _365;
    float _120 = fma(_116, -0.25, _62);
    float _122 = fma(_118, -0.25, _54);
    float _124 = fma(_118, -0.25, _64);
    precise float _378 = _120 * _120;
    float _126 = _378;
    float _128 = fma(_124, _124, _126);
    precise float _385 = _56 + _66;
    float _130 = _385;
    float _132 = fma(_116, -0.25, _52);
    precise float _391 = _130 + _82;
    float _134 = _391;
    precise float _394 = _132 * _132;
    float _136 = _394;
    float _138 = fma(_116, -0.25, _90);
    precise float _400 = _94 + _134;
    float _140 = _400;
    float _142 = fma(_122, _122, _136);
    float _144 = fma(_118, -0.25, _92);
    precise float _410 = _138 * _138;
    float _146 = _410;
    float _148 = fma(_116, -0.25, _78);
    float _150 = fma(_140, -0.25, _56);
    float _152 = fma(_140, -0.25, _66);
    float _154 = fma(_118, -0.25, _80);
    float _156 = fma(_144, _144, _146);
    precise float _429 = _148 * _148;
    float _158 = _429;
    float _160 = fma(_140, -0.25, _94);
    float _162 = fma(_150, _150, _142);
    float _164 = fma(_152, _152, _128);
    float _166 = fma(_140, -0.25, _82);
    float _168 = fma(_154, _154, _158);
    float _170 = fma(_160, _160, _156);
    precise float _454 = _162 + _164;
    float _172 = _454;
    float _174 = fma(_166, _166, _168);
    precise float _461 = _172 + _170;
    float _176 = _461;
    precise float _464 = _174 + _176;
    float _178 = _464;
    precise float _468 = _178 * fp_c3_1._m0[0].z;
    float _180 = _468;
    float _182 = exp2(_180);
    precise float _473 = _182 + 0.001000000047497451305389404296875;
    float _184 = _473;
    precise float _476 = 1.0 / _184;
    float _186 = _476;
    precise float _479 = _58 + _68;
    float _188 = _479;
    precise float _482 = _188 + _84;
    float _190 = _482;
    precise float _486 = _186 * fp_c3_1._m0[0].y;
    float _192 = _486;
    float _194 = clamp(_192, 0.0, 1.0);
    precise float _491 = _194 * _100;
    float _196 = _491;
    precise float _494 = _194 * _102;
    float _198 = _494;
    precise float _497 = _194 * _104;
    float _200 = _497;
    precise float _500 = _194 * _106;
    float _202 = _500;
    precise float _503 = _96 + _190;
    float _204 = _503;
    float _206 = fma(_196, 4.0, _100);
    float _208 = fma(_198, 4.0, _102);
    float _210 = fma(_200, 4.0, _104);
    float _212 = fma(_202, 4.0, _106);
    float _214 = -_194;
    float _216 = fma(_116, _214, _206);
    float _218 = -_194;
    float _220 = fma(_118, _218, _208);
    float _222 = -_194;
    float _224 = fma(_140, _222, _210);
    float _226 = -_194;
    float _228 = fma(_204, _226, _212);
    float _230 = max(0.0, _216);
    float _232 = max(0.0, _220);
    float _234 = max(0.0, _224);
    float _236 = max(0.0, _228);
    _30.x = _230;
    _30.y = _232;
    _30.z = _234;
    _30.w = _236;

    //_30.xyz = 10;
    
}

