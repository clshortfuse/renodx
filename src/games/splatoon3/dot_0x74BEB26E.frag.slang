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

layout(set = 0, binding = 28, std140) uniform fp_c9
{
    vec4 _m0[4096];
} fp_c9_1;

layout(set = 0, binding = 34, std140) uniform fp_c15
{
    vec4 _m0[4096];
} fp_c15_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 2) in vec4 _29;
layout(location = 0) in vec4 _31;
layout(location = 1) in vec4 _33;
layout(location = 3) in vec4 _35;
layout(location = 0) out vec4 out;

void main()
{
    float _45 = _29.x;
    float _47 = _29.y;
    vec4 _50 = texture(fp_t_tcb_8, vec2(_45, _47)).xyzw;
    float _52 = _50.x;
    float _54 = _50.y;
    float _56 = _50.z;
    float _58 = _50.w;
    float _60 = _31.w;
    float _62 = _33.w;
    float _64 = _35.x;
    float _66 = _33.x;
    float _68 = _33.y;
    float _70 = -_60;
    precise float _167 = _58 + _70;
    float _72 = _167;
    float _74 = _33.z;
    precise float _173 = _72 * _62;
    float _76 = _173;
    float _78 = clamp(_76, 0.0, 1.0);
    float _80 = _31.y;
    precise float _183 = _78 * _64;
    float _82 = _183;
    float _84 = _31.x;
    bool _88 = _82 <= fp_c9_1._m0[138].z;
    float _90 = _31.z;
    int _93 = 0;
    int _95 = floatBitsToInt(_80);
    int _97 = floatBitsToInt(_90);
    if (_88)
    {
        _93 = 0;
    }
    int _99 = _93;
    if (_88)
    {
        discard;
    }
    float _101 = -_66;
    precise float _209 = _101 + _84;
    float _103 = _209;
    float _105 = fma(_52, _103, _66);
    float _107 = -_68;
    precise float _218 = _107 + _80;
    float _109 = _218;
    float _111 = -_74;
    precise float _223 = _111 + _90;
    float _113 = _223;
    int _115 = floatBitsToInt(_103);
    if (_88)
    {
        _115 = 0;
    }
    int _117 = _115;
    if (_88)
    {
        _95 = 0;
    }
    int _119 = _95;
    if (_88)
    {
        _97 = 0;
    }
    int _121 = _97;
    if (_88)
    {
        out.x = intBitsToFloat(_117);
        out.y = intBitsToFloat(_119);
        out.z = intBitsToFloat(_121);
        out.w = intBitsToFloat(_99);
        out.xyz = renodx::tonemap::neutwo::PerChannel(out.xyz, RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
        return;
    }
    float _123 = fma(_54, _109, _68);
    float _125 = fma(_56, _113, _74);
    float _127 = fma(_82, fp_c15_1._m0[11].x, fp_c15_1._m0[11].y);
    float _129 = clamp(_127, 0.0, 1.0);
    out.x = _105;
    out.y = _123;
    out.z = _125;
    out.w = _129;

    out.xyz = renodx::tonemap::neutwo::PerChannel(out.xyz, RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
}

