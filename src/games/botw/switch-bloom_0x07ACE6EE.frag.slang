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

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 _27;
layout(location = 1) in vec4 _29;
layout(location = 0) out vec4 _32;

void main()
{
    float _39 = _27.x;
    float _41 = _27.y;
    float _43 = _29.x;
    float _45 = _29.y;
    float _47 = _27.w;
    float _49 = _27.z;
    float _51 = _29.z;
    vec4 _54 = texture(fp_t_tcb_8, vec2(_39, _41)).xyzw;
    float _56 = _54.x;
    float _58 = _54.y;
    float _60 = _54.z;
    float _62 = _54.w;
    vec4 _64 = texture(fp_t_tcb_8, vec2(_43, _45)).xyzw;
    float _66 = _64.x;
    float _68 = _64.y;
    float _70 = _64.z;
    float _72 = _64.w;
    vec4 _74 = texture(fp_t_tcb_8, vec2(_39, _47)).xyzw;
    float _76 = _74.x;
    float _78 = _74.y;
    float _80 = _74.z;
    float _82 = _74.w;
    vec4 _84 = texture(fp_t_tcb_8, vec2(_39, _49)).xyzw;
    float _86 = _84.x;
    float _88 = _84.y;
    float _90 = _84.z;
    float _92 = _84.w;
    vec4 _94 = texture(fp_t_tcb_8, vec2(_43, _51)).xyzw;
    float _96 = _94.x;
    float _98 = _94.y;
    float _100 = _94.z;
    float _102 = _94.w;
    precise float _235 = _56 * 0.3162162303924560546875;
    float _104 = _235;
    precise float _237 = _58 * 0.3162162303924560546875;
    float _106 = _237;
    precise float _239 = _60 * 0.3162162303924560546875;
    float _108 = _239;
    precise float _241 = _62 * 0.3162162303924560546875;
    float _110 = _241;
    float _112 = fma(_66, fp_c1_1._m0[0].x, _104);
    float _114 = fma(_68, fp_c1_1._m0[0].x, _106);
    float _116 = fma(_70, fp_c1_1._m0[0].x, _108);
    float _118 = fma(_72, fp_c1_1._m0[0].x, _110);
    float _120 = fma(_76, fp_c1_1._m0[0].y, _112);
    float _122 = fma(_78, fp_c1_1._m0[0].y, _114);
    float _124 = fma(_80, fp_c1_1._m0[0].y, _116);
    float _126 = fma(_82, fp_c1_1._m0[0].y, _118);
    float _128 = fma(_86, fp_c1_1._m0[0].z, _120);
    float _130 = fma(_88, fp_c1_1._m0[0].z, _122);
    float _132 = fma(_90, fp_c1_1._m0[0].z, _124);
    float _134 = fma(_92, fp_c1_1._m0[0].z, _126);
    float _136 = fma(_96, fp_c1_1._m0[0].x, _128);
    float _138 = fma(_98, fp_c1_1._m0[0].x, _130);
    float _140 = fma(_100, fp_c1_1._m0[0].x, _132);
    float _142 = fma(_102, fp_c1_1._m0[0].x, _134);
    _32.x = _136;
    _32.y = _138;
    _32.z = _140;
    _32.w = _142;

    _32.xyz *= CUSTOM_BLOOM;
}

