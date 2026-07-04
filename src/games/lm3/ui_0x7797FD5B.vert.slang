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

layout(set = 0, binding = 4, std140) uniform vp_c3
{
    vec4 _m0[4096];
} vp_c3_1;

layout(set = 0, binding = 2, std140) uniform vp_c1
{
    vec4 _m0[4096];
} vp_c1_1;

layout(location = 0) out vec4 _24;
layout(location = 1) out vec4 _26;
layout(location = 2) out vec4 _28;
layout(location = 1) in vec4 _31;
layout(location = 0) in vec4 _33;
layout(location = 2) in vec4 _35;

void main()
{
  if (HIDE_UI) {
    _24 = 0;
    _26 = 0;
    _28 = 0;
    return;
  }
    gl_PointSize = 1.0;
    gl_Position.x = 0.0;
    gl_Position.y = 0.0;
    gl_Position.z = 0.0;
    gl_Position.w = 1.0;
    _24.x = 0.0;
    _24.y = 0.0;
    _26.x = 0.0;
    _26.y = 0.0;
    _28.x = 0.0;
    _28.y = 0.0;
    _28.z = 0.0;
    _28.w = 1.0;
    float _49 = _31.x;
    float _51 = _31.y;
    float _53 = _33.x;
    float _55 = _33.y;
    float _57 = _35.x;
    precise float _277 = _49 * vp_c3_1._m0[5].x;
    float _59 = _277;
    float _61 = _33.z;
    precise float _284 = _49 * vp_c3_1._m0[4].x;
    float _63 = _284;
    float _65 = fma(_51, vp_c3_1._m0[5].y, _59);
    float _67 = _35.y;
    float _69 = fma(_51, vp_c3_1._m0[4].y, _63);
    float _71 = _35.z;
    precise float _304 = _53 * vp_c3_1._m0[6].x;
    float _73 = _304;
    float _75 = _35.w;
    precise float _310 = _55 * vp_c3_1._m0[1].x;
    float _77 = _310;
    precise float _314 = _65 + vp_c3_1._m0[5].z;
    float _79 = _314;
    precise float _318 = _55 * vp_c3_1._m0[1].y;
    float _81 = _318;
    _24.y = _79;
    float _83 = fma(_55, vp_c3_1._m0[6].y, _73);
    float _85 = fma(_53, vp_c3_1._m0[0].x, _77);
    precise float _334 = _69 + vp_c3_1._m0[4].z;
    float _87 = _334;
    precise float _338 = _55 * vp_c3_1._m0[1].z;
    float _89 = _338;
    _24.x = _87;
    float _91 = fma(_53, vp_c3_1._m0[0].y, _81);
    precise float _349 = _55 * vp_c3_1._m0[1].w;
    float _93 = _349;
    precise float _354 = _57 * vp_c3_1._m0[8].x;
    float _95 = _354;
    precise float _359 = _53 * vp_c3_1._m0[7].x;
    float _97 = _359;
    float _99 = fma(_53, vp_c3_1._m0[0].z, _89);
    float _101 = fma(_53, vp_c3_1._m0[0].w, _93);
    bool _105 = _95 <= vp_c1_1._m0[0].x;
    float _107 = fma(_61, vp_c3_1._m0[2].x, _85);
    float _109 = fma(_61, vp_c3_1._m0[2].y, _91);
    float _111 = fma(_61, vp_c3_1._m0[2].z, _99);
    float _113 = fma(_55, vp_c3_1._m0[7].y, _97);
    float _115 = fma(_61, vp_c3_1._m0[2].w, _101);
    precise float _402 = _83 + vp_c3_1._m0[6].z;
    float _117 = _402;
    precise float _406 = _107 + vp_c3_1._m0[3].x;
    float _119 = _406;
    _26.x = _117;
    precise float _412 = _113 + vp_c3_1._m0[7].z;
    float _121 = _412;
    gl_Position.x = _119;
    precise float _418 = _109 + vp_c3_1._m0[3].y;
    float _123 = _418;
    _26.y = _121;
    precise float _424 = _111 + vp_c3_1._m0[3].z;
    float _125 = _424;
    gl_Position.y = _123;
    precise float _430 = _115 + vp_c3_1._m0[3].w;
    float _127 = _430;
    gl_Position.z = _125;
    precise float _436 = _67 * vp_c3_1._m0[8].y;
    float _129 = _436;
    gl_Position.w = _127;
    precise float _442 = _71 * vp_c3_1._m0[8].z;
    float _131 = _442;
    precise float _446 = _75 * vp_c3_1._m0[8].w;
    float _133 = _446;
    int _136 = floatBitsToInt(_101);
    int _138 = floatBitsToInt(_127);
    int _140 = floatBitsToInt(_129);
    int _142 = floatBitsToInt(_131);
    if (_105)
    {
        precise float _459 = _95 * 0.077399380505084991455078125;
        float _144 = _459;
        _136 = floatBitsToInt(_144);
    }
    int _146 = _136;
    int _148 = _146;
    if (!_105)
    {
        precise float _470 = _95 + 0.054999999701976776123046875;
        float _150 = _470;
        float _152 = abs(_150);
        float _154 = log2(_152);
        precise float _477 = _154 * 2.400000095367431640625;
        float _156 = _477;
        float _158 = exp2(_156);
        precise float _482 = _158 * 0.879414975643157958984375;
        float _160 = _482;
        _148 = floatBitsToInt(_160);
        _138 = floatBitsToInt(_158);
    }
    int _162 = _148;
    int _164 = _138;
    bool _166 = _129 <= vp_c1_1._m0[0].x;
    int _168 = _164;
    if (_166)
    {
        precise float _498 = _129 * 0.077399380505084991455078125;
        float _170 = _498;
        _168 = floatBitsToInt(_170);
    }
    int _172 = _168;
    int _174 = _172;
    if (!_166)
    {
        precise float _508 = _129 + 0.054999999701976776123046875;
        float _176 = _508;
        float _178 = abs(_176);
        float _180 = log2(_178);
        precise float _514 = _180 * 2.400000095367431640625;
        float _182 = _514;
        float _184 = exp2(_182);
        precise float _518 = _184 * 0.879414975643157958984375;
        float _186 = _518;
        _174 = floatBitsToInt(_186);
        _140 = floatBitsToInt(_180);
    }
    int _188 = _174;
    int _190 = _140;
    bool _192 = _131 <= vp_c1_1._m0[0].x;
    int _194 = _190;
    if (_192)
    {
        precise float _534 = _131 * 0.077399380505084991455078125;
        float _196 = _534;
        _194 = floatBitsToInt(_196);
    }
    int _198 = _194;
    int _200 = _198;
    if (!_192)
    {
        precise float _544 = _131 + 0.054999999701976776123046875;
        float _202 = _544;
        float _204 = abs(_202);
        float _206 = log2(_204);
        precise float _550 = _206 * 2.400000095367431640625;
        float _208 = _550;
        float _210 = exp2(_208);
        precise float _554 = _210 * 0.879414975643157958984375;
        float _212 = _554;
        _200 = floatBitsToInt(_212);
        _142 = floatBitsToInt(_206);
    }
    int _214 = _200;
    int _216 = _142;
    bool _218 = _133 <= vp_c1_1._m0[0].x;
    _28.x = intBitsToFloat(_162);
    _28.y = intBitsToFloat(_188);
    _28.z = intBitsToFloat(_214);
    int _220 = _216;
    if (_218)
    {
        precise float _579 = _133 * 0.077399380505084991455078125;
        float _222 = _579;
        _220 = floatBitsToInt(_222);
    }
    int _224 = _220;
    int _226 = _224;
    if (!_218)
    {
        precise float _589 = _133 + 0.054999999701976776123046875;
        float _228 = _589;
        float _230 = abs(_228);
        float _232 = log2(_230);
        precise float _595 = _232 * 2.400000095367431640625;
        float _234 = _595;
        float _236 = exp2(_234);
        precise float _599 = _236 * 0.879414975643157958984375;
        float _238 = _599;
        _226 = floatBitsToInt(_238);
    }
    int _240 = _226;
    _28.w = intBitsToFloat(_240);

}

