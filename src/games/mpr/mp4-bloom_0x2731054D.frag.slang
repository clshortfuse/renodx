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

layout(location = 0) noperspective in vec4 _27;
layout(location = 0) out vec4 _30;

void main()
{
    float _37 = _27.x;
    float _39 = _27.y;
    precise float _228 = _37 + fp_c3_1._m0[0].x;
    float _41 = _228;
    float _43 = -fp_c3_1._m0[0].x;
    precise float _234 = _37 + _43;
    float _45 = _234;
    float _47 = -fp_c3_1._m0[0].y;
    precise float _240 = _39 + _47;
    float _49 = _240;
    precise float _244 = _39 + fp_c3_1._m0[0].y;
    float _51 = _244;
    vec4 _54 = texture(fp_t_tcb_8, vec2(_41, _39)).xyzw;
    float _56 = _54.x;
    float _58 = _54.y;
    float _60 = _54.z;
    float _62 = _54.w;
    vec4 _64 = texture(fp_t_tcb_8, vec2(_45, _39)).xyzw;
    float _66 = _64.x;
    float _68 = _64.y;
    float _70 = _64.z;
    float _72 = _64.w;
    vec4 _74 = texture(fp_t_tcb_8, vec2(_37, _49)).xyzw;
    float _76 = _74.x;
    float _78 = _74.y;
    float _80 = _74.z;
    float _82 = _74.w;
    vec4 _84 = texture(fp_t_tcb_8, vec2(_37, _51)).xyzw;
    float _86 = _84.x;
    float _88 = _84.y;
    float _90 = _84.z;
    float _92 = _84.w;
    float _94 = -fp_c3_1._m0[0].z;
    precise float _308 = _37 + _94;
    float _96 = _308;
    float _98 = -fp_c3_1._m0[0].w;
    precise float _315 = _39 + _98;
    float _100 = _315;
    precise float _319 = _37 + fp_c3_1._m0[0].z;
    float _102 = _319;
    precise float _322 = _56 + _66;
    float _104 = _322;
    precise float _325 = _58 + _68;
    float _106 = _325;
    precise float _328 = _60 + _70;
    float _108 = _328;
    precise float _331 = _62 + _72;
    float _110 = _331;
    precise float _335 = _39 + fp_c3_1._m0[0].w;
    float _112 = _335;
    precise float _338 = _104 + _76;
    float _114 = _338;
    precise float _341 = _106 + _78;
    float _116 = _341;
    precise float _344 = _108 + _80;
    float _118 = _344;
    precise float _347 = _110 + _82;
    float _120 = _347;
    precise float _350 = _114 + _86;
    float _122 = _350;
    precise float _353 = _116 + _88;
    float _124 = _353;
    precise float _356 = _118 + _90;
    float _126 = _356;
    vec4 _128 = texture(fp_t_tcb_8, vec2(_96, _100)).xyzw;
    float _130 = _128.x;
    float _132 = _128.y;
    float _134 = _128.z;
    float _136 = _128.w;
    vec4 _138 = texture(fp_t_tcb_8, vec2(_96, _112)).xyzw;
    float _140 = _138.x;
    float _142 = _138.y;
    float _144 = _138.z;
    float _146 = _138.w;
    vec4 _148 = texture(fp_t_tcb_8, vec2(_102, _112)).xyzw;
    float _150 = _148.x;
    float _152 = _148.y;
    float _154 = _148.z;
    float _156 = _148.w;
    vec4 _158 = texture(fp_t_tcb_8, vec2(_102, _100)).xyzw;
    float _160 = _158.x;
    float _162 = _158.y;
    float _164 = _158.z;
    float _166 = _158.w;
    precise float _415 = _120 + _92;
    float _168 = _415;
    float _170 = fma(_130, 2.0, _122);
    float _172 = fma(_132, 2.0, _124);
    float _174 = fma(_134, 2.0, _126);
    float _176 = fma(_136, 2.0, _168);
    float _178 = fma(_150, 2.0, _170);
    float _180 = fma(_152, 2.0, _172);
    float _182 = fma(_154, 2.0, _174);
    float _184 = fma(_156, 2.0, _176);
    float _186 = fma(_140, 2.0, _178);
    float _188 = fma(_142, 2.0, _180);
    float _190 = fma(_144, 2.0, _182);
    float _192 = fma(_146, 2.0, _184);
    float _194 = fma(_160, 2.0, _186);
    float _196 = fma(_162, 2.0, _188);
    float _198 = fma(_164, 2.0, _190);
    float _200 = fma(_166, 2.0, _192);
    precise float _469 = _194 * fp_c3_1._m0[1].x;
    float _202 = _469;
    precise float _473 = _196 * fp_c3_1._m0[1].y;
    float _204 = _473;
    precise float _477 = _198 * fp_c3_1._m0[1].z;
    float _206 = _477;
    precise float _481 = _200 * fp_c3_1._m0[1].w;
    float _208 = _481;
    precise float _484 = _202 * 0.083333335816860198974609375;
    float _210 = _484;
    precise float _486 = _204 * 0.083333335816860198974609375;
    float _212 = _486;
    precise float _488 = _206 * 0.083333335816860198974609375;
    float _214 = _488;
    precise float _490 = _208 * 0.083333335816860198974609375;
    float _216 = _490;
    _30.x = _210;
    _30.y = _212;
    _30.z = _214;
    _30.w = _216;

    _30.xyz *= CUSTOM_BLOOM;
    _30 = renodx::draw::InvertIntermediatePass(_30);
    _30 = renodx::draw::RenderIntermediatePass(_30);
}

