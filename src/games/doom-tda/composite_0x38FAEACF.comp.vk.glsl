#version 450

#extension GL_GOOGLE_include_directive : require
#include "./include/common.glsl"
#include "./include/psychov_17.glsl"
#include "./shared.h"

#extension GL_EXT_buffer_reference2 : require
#if defined(GL_EXT_control_flow_attributes)
#extension GL_EXT_control_flow_attributes : require
#define SPIRV_CROSS_FLATTEN [[flatten]]
#define SPIRV_CROSS_BRANCH [[dont_flatten]]
#define SPIRV_CROSS_UNROLL [[unroll]]
#define SPIRV_CROSS_LOOP [[dont_unroll]]
#else
#define SPIRV_CROSS_FLATTEN
#define SPIRV_CROSS_BRANCH
#define SPIRV_CROSS_UNROLL
#define SPIRV_CROSS_LOOP
#endif
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

struct _1632
{
    uint _m0;
    uint _m1;
};

struct _1827
{
    float _m0;
    float _m1;
};

struct _1828
{
    float _m0[6];
    float _m1[6];
    _1827 _m2;
    _1827 _m3;
    _1827 _m4;
    float _m5;
    float _m6;
};

layout(set = 1, binding = 0, std140) uniform _633_635
{
    uvec4 _m0;
    vec4 _m1;
    vec4 _m2;
    vec4 _m3;
    vec4 _m4;
    vec4 _m5;
    vec4 _m6;
    float _m7;
    float _m8;
    float _m9;
    float _m10;
    float _m11;
    float _m12;
    float _m13;
    float _m14;
    uint _m15;
    float _m16;
    float _m17;
    uint _m18;
} _635;

layout(set = 0, binding = 0, std140) uniform _960_962
{
    uvec4 _m0;
    vec4 _m1;
    vec4 _m2;
    vec4 _m3;
    vec4 _m4;
    vec4 _m5;
    vec4 _m6;
    vec4 _m7;
    vec4 _m8;
    vec4 _m9;
    vec4 _m10;
    vec4 _m11;
    vec4 _m12;
    vec4 _m13;
    vec4 _m14;
    vec4 _m15;
    vec4 _m16;
    vec4 _m17;
    vec4 _m18;
    vec4 _m19;
    float _m20;
    float _m21;
    float _m22;
    float _m23;
    float _m24;
    float _m25;
    float _m26;
    float _m27;
    float _m28;
    float _m29;
    float _m30;
    float _m31;
    float _m32;
    float _m33;
    float _m34;
    float _m35;
    float _m36;
    float _m37;
    float _m38;
    uint _m39;
    uint _m40;
    float _m41;
    uint _m42;
    float _m43;
    float _m44;
    float _m45;
    float _m46;
    float _m47;
    float _m48;
    float _m49;
    float _m50;
    float _m51;
    float _m52;
    float _m53;
    float _m54;
    float _m55;
    float _m56;
    float _m57;
    float _m58;
    float _m59;
    uint _m60;
    float _m61;
    float _m62;
    float _m63;
    float _m64;
    float _m65;
    uint _m66;
    uint _m67;
    uint _m68;
    float _m69;
    uint _m70;
} _962;

layout(set = 0, binding = 2, std430) restrict readonly buffer _1634_1636
{
    _1632 _m0[];
} _1636;

layout(set = 0, binding = 3, std140) uniform _1639_1641
{
    vec4 _m0[1024];
} _1641;

layout(set = 0, binding = 4, std140) uniform _1644_1646
{
    vec4 _m0[64];
} _1646;

layout(set = 1, binding = 6) uniform texture2D _814;
layout(set = 0, binding = 5) uniform sampler _818;
layout(set = 1, binding = 5) uniform texture2D _1015;
layout(set = 0, binding = 8) uniform sampler _1017;
// Optional debug/side outputs: SDR linear scene (_1332), HDR10/PQ scene (_1552), and final composite (_1610).
layout(set = 1, binding = 3, rgba8) uniform writeonly image2D _1332;
layout(set = 1, binding = 2) uniform texture3D _1458;
layout(set = 0, binding = 9) uniform sampler _1460;
layout(set = 1, binding = 4, rgb10_a2) uniform writeonly image2D _1552;
layout(set = 1, binding = 1, r11f_g11f_b10f) uniform writeonly image2D _1610;
layout(set = 0, binding = 1) uniform texture2D _1631;
layout(set = 0, binding = 6) uniform sampler _1647;
layout(set = 0, binding = 7) uniform texture2D _1648;

uint _91;
uint _93;
uint _95;
int _99;
int _101;
int _103;
uint _1655;

float _47(float _46)
{
    return 0.16666667163372039794921875 * ((_46 * ((_46 * ((-_46) + 3.0)) - 3.0)) + 1.0);
}

float _50(float _49)
{
    return 0.16666667163372039794921875 * (((_49 * _49) * ((3.0 * _49) - 6.0)) + 4.0);
}

float _59(float _58)
{
    float _255 = _58;
    float _258 = _58;
    return _47(_255) + _50(_258);
}

float _53(float _52)
{
    return 0.16666667163372039794921875 * ((_52 * ((_52 * (((-3.0) * _52) + 3.0)) + 3.0)) + 1.0);
}

float _56(float _55)
{
    return 0.16666667163372039794921875 * ((_55 * _55) * _55);
}

float _62(float _61)
{
    float _264 = _61;
    float _267 = _61;
    return _53(_264) + _56(_267);
}

float _65(float _64)
{
    float _274 = _64;
    float _277 = _64;
    float _280 = _64;
    return (-1.0) + (_50(_274) / (_47(_277) + _50(_280)));
}

float _68(float _67)
{
    float _288 = _67;
    float _291 = _67;
    float _294 = _67;
    return 1.0 + (_56(_288) / (_53(_291) + _56(_294)));
}

float _78(float _77)
{
    // PQ/ST.2084 decode: normalized PQ code value -> linear nits.
    float _547 = pow(_77, 0.0126833133399486541748046875);
    float _551 = max(0.0, _547 - 0.8359375);
    _551 /= (18.8515625 - (18.6875 * _547));
    _551 = pow(_551, 6.277394771575927734375);
    return _551 * 10000.0;
}

vec3 _87(vec3 _86)
{
    float _607 = _86.x;
    float _611 = _86.y;
    float _615 = _86.z;
    return vec3(_78(_607), _78(_611), _78(_615));
}

float _75(inout vec2 _73, inout vec2 _74)
{
    if (_74.x == _74.y)
    {
        return length(_73) - _74.x;
    }
    _73 = abs(_73);
    if (_73.x > _73.y)
    {
        _73 = _73.yx;
        _74 = _74.yx;
    }
    float _328 = (_74.y * _74.y) - (_74.x * _74.x);
    float _340 = (_74.x * _73.x) / _328;
    float _348 = _340 * _340;
    float _352 = (_74.y * _73.y) / _328;
    float _360 = _352 * _352;
    float _364 = ((_348 + _360) - 1.0) / 3.0;
    float _370 = (_364 * _364) * _364;
    float _376 = _370 + ((_348 * _360) * 2.0);
    float _384 = _370 + (_348 * _360);
    float _390 = _340 + (_340 * _360);
    float _436;
    if (_384 < 0.0)
    {
        float _400 = acos(_376 / _370) / 3.0;
        float _406 = cos(_400);
        float _409 = sin(_400) * 1.73205077648162841796875;
        float _414 = sqrt(((-_364) * ((_406 + _409) + 2.0)) + _348);
        float _425 = sqrt(((-_364) * ((_406 - _409) + 2.0)) + _348);
        _436 = (((_425 + (sign(_328) * _414)) + (abs(_390) / (_414 * _425))) - _340) / 2.0;
    }
    else
    {
        float _454 = ((2.0 * _340) * _352) * sqrt(_384);
        float _462 = sign(_376 + _454) * pow(abs(_376 + _454), 0.3333333432674407958984375);
        float _474 = sign(_376 - _454) * pow(abs(_376 - _454), 0.3333333432674407958984375);
        float _485 = (((-_462) - _474) - (_364 * 4.0)) + (2.0 * _348);
        float _496 = (_462 - _474) * 1.73205077648162841796875;
        float _501 = sqrt((_485 * _485) + (_496 * _496));
        _436 = (((_496 / sqrt(_501 - _485)) + ((2.0 * _390) / _501)) - _340) / 2.0;
    }
    vec2 _524 = _74 * vec2(_436, sqrt(1.0 - (_436 * _436)));
    return length(_524 - _73) * sign(_73.y - _524.y);
}

float _10(float _9)
{
    return clamp(_9, 0.0, 1.0);
}

float _25(float _24)
{
    // sRGB/BT.709 OETF encode: linear -> gamma encoded.
    float _159;
    if (_24 > 0.003130800090730190277099609375)
    {
        _159 = (pow(_24, 0.4166666567325592041015625) * 1.05499994754791259765625) - 0.054999999701976776123046875;
    }
    else
    {
        _159 = _24 * 12.9200000762939453125;
    }
    return _159;
}

vec3 _28(vec3 _27)
{
    float _174 = _27.x;
    float _178 = _27.y;
    float _182 = _27.z;
    return vec3(_25(_174), _25(_178), _25(_182));
}

float _19(float _18)
{
    // sRGB/BT.709 EOTF decode: gamma encoded -> linear.
    float _121;

    if (RENODX_SDR_EOTF_EMULATION_UI == 0.f) {
        if (_18 <= 0.040449999272823333740234375)
        {
            _121 = _18 / 12.9200000762939453125;
        }
        else
        {
            _121 = pow((_18 / 1.05499994754791259765625) + 0.0521326996386051177978515625, 2.400000095367431640625);
        }
    } else {
        _121 = pow(_18, 2.2f);
    }
    return _121;
}

vec3 _22(vec3 _21)
{
    float _138 = _21.x;
    float _143 = _21.y;
    float _148 = _21.z;
    return vec3(_19(_138), _19(_143), _19(_148));
}

vec3 _35(mat3 _33, vec3 _34)
{
    return _33 * _34;
}

vec3 _16(vec3 _15)
{
    // RGB channel clamp to display range. This is not a gamut conversion, but it can destroy out-of-range/wide-gamut values.
    return clamp(_15, vec3(0.0), vec3(1.0));
}

float _44(vec3 _43)
{
    return dot(_43, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
}

vec3 _40(vec3 _38, mat3 _39)
{
    return _38 * _39;
}

float _81(float _80)
{
    // PQ/ST.2084 encode: linear nits -> normalized PQ code value.
    float _571 = _80 / 10000.0;
    float _574 = pow(_571, 0.1593017578125);
    float _578 = (0.8359375 + (18.8515625 * _574)) / (1.0 + (18.6875 * _574));
    _578 = pow(_578, 78.84375);
    return _578;
}

vec3 _84(vec3 _83)
{
    float _592 = _83.x;
    float _596 = _83.y;
    float _600 = _83.z;
    return vec3(_81(_592), _81(_596), _81(_600));
}

void main()
{
    _91 = 2147483648u;
    _93 = 1073741824u;
    _95 = 536870912u;
    _99 = 0;
    _101 = 1;
    _103 = 2;
    ivec3 _624 = ivec3(gl_GlobalInvocationID);
    vec2 _630 = _635._m6.xy + (_635._m6.zw * (vec2(_624.xy) + vec2(0.5)));
    vec2 _653 = _635._m2.zw * (vec2(_624.xy) + vec2(0.5));
    vec3 _663 = vec3(0.0);
    // Scene/render input UV bounds check for the game render sample path.
    bool _672 = min(_630.x, _630.y) < 0.0;
    bool _682;
    if (!_672)
    {
        _682 = max(_630.x, _630.y) >= 1.0;
    }
    else
    {
        _682 = _672;
    }
    bool _666 = _682;
    float _683 = _635._m5.z;
    vec2 _688 = _630;
    vec2 _690 = (_688 * vec2(_635._m16, _635._m17)) + vec2(0.5);
    vec2 _702 = floor(_690);
    vec2 _705 = fract(_690);
    float _709 = _705.x;
    float _708 = _59(_709);
    float _714 = _705.x;
    float _713 = _62(_714);
    float _719 = _705.x;
    float _718 = _65(_719);
    float _724 = _705.x;
    float _723 = _68(_724);
    float _729 = _705.y;
    float _728 = _65(_729);
    float _734 = _705.y;
    float _733 = _68(_734);
    vec2 _738 = (vec2(_702.x + _718, _702.y + _728) - vec2(0.5)) / vec2(_635._m16, _635._m17);
    vec2 _756 = (vec2(_702.x + _723, _702.y + _728) - vec2(0.5)) / vec2(_635._m16, _635._m17);
    vec2 _774 = (vec2(_702.x + _718, _702.y + _733) - vec2(0.5)) / vec2(_635._m16, _635._m17);
    vec2 _792 = (vec2(_702.x + _723, _702.y + _733) - vec2(0.5)) / vec2(_635._m16, _635._m17);
    vec4 _811 = textureLod(sampler2D(_814, _818), vec4(_738, 0.0, 0.0).xy, vec4(_738, 0.0, 0.0).w);
    vec4 _834 = textureLod(sampler2D(_814, _818), vec4(_756, 0.0, 0.0).xy, vec4(_756, 0.0, 0.0).w);
    vec4 _849 = textureLod(sampler2D(_814, _818), vec4(_774, 0.0, 0.0).xy, vec4(_774, 0.0, 0.0).w);
    vec4 _864 = textureLod(sampler2D(_814, _818), vec4(_792, 0.0, 0.0).xy, vec4(_792, 0.0, 0.0).w);
    float _880 = _705.y;
    float _892 = _705.y;
    // Cubic-filtered scene/render sample and direct scene sample from _814.
    vec4 _879 = (((_811 * _708) + (_834 * _713)) * _59(_880)) + (((_849 * _708) + (_864 * _713)) * _62(_892));
    vec3 _905 = textureLod(sampler2D(_814, _818), vec4(_688, 0.0, 0.0).xy, vec4(_688, 0.0, 0.0).w).xyz;
    if (((_635._m18 & 1u) != 0u) == true)
    {
        // HDR/PQ input mode for the scene: decode sampled PQ values to linear nits before compositing/output.
        vec3 _932 = _905;
        vec3 _931 = _87(_932);
        vec3 _936 = _879.xyz;
        vec3 _935 = _87(_936);
        _663 = mix(_935, _931, max(vec3(1.0), vec3(_683)));
    }
    else
    {
        // SDR/linear input mode for the scene: use sampled values directly.
        _663 = mix(_879.xyz, _905, max(vec3(1.0), vec3(_683)));
    }
    // Scene negative clamp and out-of-bounds mask before UI composition.
    _663 = max(vec3(0.0), _663);
    _663 = _666 ? vec3(0.0) : _663;
    if (((_962._m70 & 4u) != 0u) == false)
    {
        bool _973 = false;
        bool _979 = _653.x < _635._m4.x;
        bool _988;
        if (!_979)
        {
            _988 = _653.y < _635._m4.y;
        }
        else
        {
            _988 = _979;
        }
        bool _997;
        if (!_988)
        {
            _997 = _653.x >= _635._m4.z;
        }
        else
        {
            _997 = _988;
        }
        bool _1006;
        if (!_997)
        {
            _1006 = _653.y >= _635._m4.w;
        }
        else
        {
            _1006 = _997;
        }
        if (_1006)
        {
            _973 = true;
        }
        _663 = _973 ? vec3(0.0) : _663;
    }
    vec2 _1012 = _630;
    // UI/HUD input. Alpha is later used as the UI-over-scene composite mask.
    vec4 _1014 = textureLod(sampler2D(_1015, _1017), vec4(_653, 0.0, 0.0).xy, vec4(_653, 0.0, 0.0).w);
    SPIRV_CROSS_BRANCH
    if (_635._m14 > 0.0)
    {
        // Optional UI warning/tint overlay, authored in linear then sRGB-encoded before the UI decode below.
        vec2 _1037 = _653 - vec2(0.5);
        vec2 _1047 = _1037;
        vec2 _1049 = vec2(1.02374994754791259765625, 1.31624996662139892578125);
        float _1050 = _75(_1047, _1049);
        float _1054 = smoothstep(-1.39999997615814208984375, 3.5, _1050 / 0.75);
        float _1041 = _10(_1054);
        vec3 _1064 = vec3(1.0, 0.20000000298023223876953125, 0.04500000178813934326171875) * (_635._m14 * _1041);
        vec4 _1066 = _1014;
        vec3 _1068 = _1066.xyz + _28(_1064);
        _1014.x = _1068.x;
        _1014.y = _1068.y;
        _1014.z = _1068.z;
    }
    // Decode UI from sRGB/gamma to linear for composition.
    vec3 _1075 = _1014.xyz;
    vec3 _1078 = _22(_1075);
    _1014.x = _1078.x;
    _1014.y = _1078.y;
    _1014.z = _1078.z;
    vec3 _1085 = _1014.xyz;
    SPIRV_CROSS_BRANCH
    if (_635._m5.x > 0.0)
    {
        // Optional color-blindness/accessibility correction applied to the linear UI color.
        float _1093 = _635._m10;
        float _1097 = _635._m9;
        float _1101 = mix(0.949999988079071044921875, 1.0499999523162841796875, _635._m8);
        float _1108 = mix(1.0, 3.0, _635._m7);
        _1085 = max(vec3(0.0), mix(vec3(0.5), _1085, vec3(_1101))) * _1108;
        vec3 _1121 = vec3(0.0);
        vec3 _1145;
        vec3 _1158;
        SPIRV_CROSS_BRANCH
        if (_635._m5.x == 1.0)
        {
            mat3 _1141 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875), vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625), vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
            vec3 _1142 = _1085;
            vec3 _1127 = _35(_1141, _1142);
            _1145.x = dot(_1127, vec3(0.0, 1.0511829853057861328125, -0.051160991191864013671875));
            _1145.y = _1127.y;
            _1145.z = _1127.z;
            mat3 _1172 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875), vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875), vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
            vec3 _1173 = _1145;
            _1158 = _35(_1172, _1173);
            vec3 _1176 = _1085 - _1158;
            _1121.x = 0.0;
            _1121.y = (_1176.x * _1093) + _1176.y;
            _1121.z = (_1176.x * _1093) + _1176.z;
        }
        else
        {
            SPIRV_CROSS_BRANCH
            if (_635._m5.x == 2.0)
            {
                mat3 _1204 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875), vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625), vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
                vec3 _1205 = _1085;
                vec3 _1203 = _35(_1204, _1205);
                _1145.x = _1203.x;
                _1145.y = dot(_1203, vec3(0.9513092041015625, 0.0, 0.04866991937160491943359375));
                _1145.z = _1203.z;
                mat3 _1220 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875), vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875), vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
                vec3 _1221 = _1145;
                _1158 = _35(_1220, _1221);
                vec3 _1224 = _1085 - _1158;
                _1121.x = (_1224.y * _1093) + _1224.x;
                _1121.y = 0.0;
                _1121.z = (_1224.y * _1093) + _1224.z;
            }
            else
            {
                SPIRV_CROSS_BRANCH
                if (_635._m5.x == 3.0)
                {
                    mat3 _1252 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875), vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625), vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
                    vec3 _1253 = _1085;
                    vec3 _1251 = _35(_1252, _1253);
                    _1145.x = _1251.x;
                    _1145.y = _1251.y;
                    _1145.z = dot(_1251, vec3(-0.867447376251220703125, 1.867270946502685546875, 0.0));
                    mat3 _1268 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875), vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875), vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
                    vec3 _1269 = _1145;
                    _1158 = _35(_1268, _1269);
                    vec3 _1272 = _1085 - _1158;
                    _1121.x = (_1272.z * _1093) + _1272.x;
                    _1121.y = (_1272.z * _1093) + _1272.y;
                    _1121.z = 0.0;
                }
            }
        }
        vec3 _1293 = max(vec3(0.0), _1085 + _1121);
        vec3 _1302 = mix(_1085, _1293, vec3(_1097));
        _1014.x = _1302.x;
        _1014.y = _1302.y;
        _1014.z = _1302.z;
    }
    uint _1310 = _635._m15;
    vec4 _1350;
    SPIRV_CROSS_BRANCH
    if ((_1310 & 1u) == 0u)
    {
        // SDR/sRGB output branch. Scene is clamped to [0,1], decoded as sRGB/BT.709, composited with linear UI, then sRGB-encoded.
        vec3 _1319 = _663;
        vec3 _1322 = _16(_1319);
        _663 = _22(_1322);
        if ((_635._m18 & 2u) != 0u)
        {
            // Optional side output of the clamped/decoded SDR scene before UI composite.
            imageStore(_1332, _624.xy, vec4(_663, 1.0));
        }
        // Linear UI-over-scene composite using UI alpha.
        vec3 _1341 = (_663 * (1.0 - _1014.w)) + _1014.xyz;
        vec3 _1351 = _1341;
        vec3 _1353 = _28(_1351);
        _1350.x = _1353.x;
        _1350.y = _1353.y;
        _1350.z = _1353.z;
        SPIRV_CROSS_FLATTEN
        if (_635._m13 != 1.0)
        {
            vec4 _1366 = _1350;
            vec3 _1371 = pow(_1366.xyz, vec3(_635._m13));
            _1350.x = _1371.x;
            _1350.y = _1371.y;
            _1350.z = _1371.z;
        }
        vec4 _1381 = _1350;
        vec3 _1383 = _1381.xyz * _962._m54;
        _1350.x = _1383.x;
        _1350.y = _1383.y;
        _1350.z = _1383.z;
        bool _1392 = _635._m5.w > 0.0;
        bool _1400;
        if (_1392)
        {
            _1400 = ((_962._m70 & 1u) != 0u) == false;
        }
        else
        {
            _1400 = _1392;
        }
        SPIRV_CROSS_BRANCH
        if (_1400)
        {
            // SDR post-composite 3D LUT/noise effect, followed by another [0,1] clamp.
            vec2 _1403 = _653 + (vec2(ivec2(_635._m3.xy) & ivec2(1023)) / vec2(1023.0));
            vec2 _1418 = (_653 * vec2(_962._m32 * _962._m69, _962._m32)) + vec2(_635._m11, _635._m12);
            vec3 _1440 = _1350.xyz;
            float _1445 = 1.0 - _44(_1440);
            float _1439 = _10(_1445);
            vec3 _1447 = (vec3(1.0, 0.550000011920928955078125, 1.0) * _1439) * _635._m5.w;
            vec3 _1455 = (textureLod(sampler3D(_1458, _1460), vec4(_1418, _1439, 0.0).xyz, vec4(_1418, _1439, 0.0).w).xyz * 2.0) - vec3(1.0);
            vec3 _1486 = _1350.xyz + (_1455 * _1447);
            vec3 _1487 = _16(_1486);
            _1350.x = _1487.x;
            _1350.y = _1487.y;
            _1350.z = _1487.z;
        }
    }
    else
    {
        // HDR/PQ output branch. Scene/UI are prepared for BT.2020-style HDR composition, then PQ-encoded.
        if (((_635._m18 & 1u) != 0u) == true)
        {
            // Convert scene from BT.709 primaries to BT.2020 primaries when the scene was decoded from PQ above.
            vec3 _1515 = _663;
            mat3 _1517 = mat3(vec3(0.627403914928436279296875, 0.3292829096317291259765625, 0.043313108384609222412109375), vec3(0.069097340106964111328125, 0.919540345668792724609375, 0.011362309567630290985107421875), vec3(0.01639143936336040496826171875, 0.088013269007205963134765625, 0.895595550537109375));
            _663 = _40(_1515, _1517);
        }
        _663 = max(vec3(0.0), _663);
        // Convert UI from BT.709 primaries to BT.2020 primaries for HDR composition.
        vec3 _1521 = _1014.xyz;
        mat3 _1524 = mat3(vec3(0.627403914928436279296875, 0.3292829096317291259765625, 0.043313108384609222412109375), vec3(0.069097340106964111328125, 0.919540345668792724609375, 0.011362309567630290985107421875), vec3(0.01639143936336040496826171875, 0.088013269007205963134765625, 0.895595550537109375));
        vec3 _1525 = _40(_1521, _1524);
        _1014.x = _1525.x;
        _1014.y = _1525.y;
        _1014.z = _1525.z;
        vec4 _1535 = _1014;
        vec3 _1537 = _1535.xyz * _962._m59;
        _1014.x = _1537.x;
        _1014.y = _1537.y;
        _1014.z = _1537.z;
        if ((_635._m18 & 2u) != 0u)
        {
            // Optional side output of scene-only HDR data encoded to PQ/RGB10A2.
            vec3 _1556 = _663;
            imageStore(_1552, _624.xy, vec4(_84(_1556), 1.0));
        }
        if (((_962._m70 & 8u) != 0u) == false)
        {
            // HDR scene brightness scale before compositing UI.
            _663 *= _962._m55;
        }
        // Linear BT.2020 UI-over-scene composite using UI alpha, then PQ encode for HDR output.
        vec3 _1583 = (_663 * (1.0 - _1014.w)) + _1014.xyz;
        _1350.x = _1583.x;
        _1350.y = _1583.y;
        _1350.z = _1583.z;
        vec3 _1590 = _1350.xyz;
        vec3 _1593 = _84(_1590);
        _1350.x = _1593.x;
        _1350.y = _1593.y;
        _1350.z = _1593.z;
    }
    _1350.w = 1.0;
    if (((_962._m70 & 2u) != 0u) == true)
    {
        // Debug split/bar path: left strip uses _635._m1, rest uses the selected SDR or HDR composite.
        vec4 _1618;
        if (_630.x <= 0.0500000007450580596923828125)
        {
            _1618 = _635._m1;
        }
        else
        {
            _1618 = _1350;
        }
        imageStore(_1610, _624.xy, _1618);
    }
    else
    {
        // Final write. In SDR branch this is sRGB-like encoded color; in HDR branch this is PQ-encoded BT.2020-style color.
        imageStore(_1610, _624.xy, _1350);
    }
}

