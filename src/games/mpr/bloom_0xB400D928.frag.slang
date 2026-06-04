#version 450
#include "./shared.h"
#include "./shared.slang"

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

layout(set = 0, binding = 19, std140) uniform fp_c0
{
    vec4 _m0[4096];
} fp_c0_1;

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 _29;
layout(location = 0) out vec4 _32;

void main()
{
    float _39 = _29.x;
    float _41 = _29.y;
    float _43 = -fp_c3_1._m0[0].x;
    precise float _158 = _39 + _43;
    float _45 = _158;
    float _47 = -fp_c3_1._m0[0].y;
    precise float _164 = _41 + _47;
    float _49 = _164;
    precise float _168 = _39 + fp_c3_1._m0[0].x;
    float _51 = _168;
    precise float _172 = _41 + fp_c3_1._m0[0].y;
    float _53 = _172;
    vec4 _56 = texture(fp_t_tcb_8, vec2(_39, _41)).xyzw;
    float _58 = _56.x;
    float _60 = _56.y;
    float _62 = _56.z;
    float _64 = _56.w;
    vec4 _66 = texture(fp_t_tcb_8, vec2(_45, _49)).xyzw;
    float _68 = _66.x;
    float _70 = _66.y;
    float _72 = _66.z;
    float _74 = _66.w;
    vec4 _76 = texture(fp_t_tcb_8, vec2(_45, _53)).xyzw;
    float _78 = _76.x;
    float _80 = _76.y;
    float _82 = _76.z;
    float _84 = _76.w;
    vec4 _86 = texture(fp_t_tcb_8, vec2(_51, _53)).xyzw;
    float _88 = _86.x;
    float _90 = _86.y;
    float _92 = _86.z;
    float _94 = _86.w;
    vec4 _96 = texture(fp_t_tcb_8, vec2(_51, _49)).xyzw;
    float _98 = _96.x;
    float _100 = _96.y;
    float _102 = _96.z;
    float _104 = _96.w;
    float _106 = fma(_58, 4.0, _68);
    float _108 = fma(_60, 4.0, _70);
    float _110 = fma(_62, 4.0, _72);
    float _112 = fma(_64, 4.0, _74);
    precise float _260 = _88 + _106;
    float _114 = _260;
    precise float _263 = _90 + _108;
    float _116 = _263;
    precise float _266 = _92 + _110;
    float _118 = _266;
    precise float _269 = _94 + _112;
    float _120 = _269;
    precise float _272 = _114 + _78;
    float _122 = _272;
    precise float _275 = _116 + _80;
    float _124 = _275;
    precise float _278 = _118 + _82;
    float _126 = _278;
    precise float _281 = _120 + _84;
    float _128 = _281;
    precise float _284 = _98 + _122;
    float _130 = _284;
    precise float _287 = _100 + _124;
    float _132 = _287;
    precise float _290 = _102 + _126;
    float _134 = _290;
    precise float _293 = _104 + _128;
    float _136 = _293;
    precise float _296 = _130 * 0.125;
    float _138 = _296;
    precise float _298 = _132 * 0.125;
    float _140 = _298;
    precise float _300 = _134 * 0.125;
    float _142 = _300;
    precise float _302 = _136 * 0.125;
    float _144 = _302;
    _32.x = _138;
    _32.y = _140;
    _32.z = _142;
    _32.w = _144;
    //_32.xyz = ApplyColorGrade(_32.xyz);
    _32.xyz *= CUSTOM_BLOOM;
    _32 = renodx::draw::InvertIntermediatePass(_32);
    _32 = renodx::draw::RenderIntermediatePass(_32);
}

