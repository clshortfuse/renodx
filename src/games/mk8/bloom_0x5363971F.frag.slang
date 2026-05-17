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

layout(location = 0) in vec4 _29;
layout(location = 0) out vec4 _32;

void main()
{
    float _39 = gl_FragCoord.w;
    float _41 = _29.x;
    float _43 = gl_FragCoord.w;
    precise float _85 = _41 * _43;
    float _45 = _85;
    float _47 = _29.y;
    float _49 = gl_FragCoord.w;
    precise float _93 = _47 * _49;
    float _51 = _93;
    precise float _96 = 1.0 / _39;
    float _53 = _96;
    precise float _99 = _53 * _45;
    float _55 = _99;
    precise float _102 = _53 * _51;
    float _57 = _102;
    vec3 _61 = texture(fp_t_tcb_8, vec2(_55, _57)).xyz;
    float _63 = _61.x;
    float _65 = _61.y;
    float _67 = _61.z;
    precise float _121 = _63 * fp_c3_1._m0[6].x;
    float _69 = _121;
    precise float _125 = _65 * fp_c3_1._m0[6].y;
    float _71 = _125;
    precise float _130 = _67 * fp_c3_1._m0[6].z;
    float _73 = _130;
    _32.x = _69;
    _32.y = _71;
    _32.z = _73;
    _32.w = 0.0;

    _32.xyz *= CUSTOM_BLOOM;
}

