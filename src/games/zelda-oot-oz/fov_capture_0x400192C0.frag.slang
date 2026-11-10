#version 450
#extension GL_EXT_scalar_block_layout : require

// CUSTOM: Original fog rendering remains intact; capture its actual ray scales.
#include "./adaptation.slangi"

layout(set = 0, binding = 1, scalar) uniform fs_cbuf_block_4u
{
    uint data[16384];
} c3;

layout(set = 0, binding = 2, scalar) uniform c4
{
    uint data[16384];
} c4_1;

layout(set = 0, binding = 1, scalar) uniform fs_cbuf_block_4f
{
    float data[16384];
} c3_1;

layout(set = 0, binding = 2, scalar) uniform c4_2
{
    float data[16384];
} c4_3;

layout(set = 0, binding = 3) uniform sampler3D fs_tex2_20;
layout(set = 0, binding = 4) uniform sampler3D fs_tex2_28;
layout(set = 0, binding = 5) uniform sampler3D fs_tex2_30;
layout(set = 0, binding = 6) uniform sampler2D fs_tex2_38;
layout(set = 0, binding = 7) uniform sampler2D fs_tex2_40;
layout(set = 0, binding = 8) uniform sampler2D fs_tex2_48;
layout(set = 0, binding = 9) uniform sampler2D fs_tex2_50;
layout(set = 0, binding = 10) uniform sampler2D fs_tex2_58;
layout(set = 0, binding = 11) uniform sampler2D fs_tex2_60;
layout(set = 0, binding = 12) uniform sampler2D fs_tex2_68;
layout(set = 0, binding = 13) uniform sampler2D fs_tex2_70;

layout(location = 0) noperspective in vec4 in_attr0;
layout(location = 1) noperspective in vec4 in_attr1;
layout(location = 0) out vec4 frag_color0;

void main()
{
    vec4 _121 = texture(fs_tex2_50, vec2(in_attr1.x, in_attr1.y));
    float _122 = _121.x;
    uint _123 = floatBitsToUint(_122);
    vec4 _126 = textureGather(fs_tex2_58, vec2(in_attr1.x, in_attr1.y));
    precise float _143 = in_attr0.x + uintBitsToFloat(floatBitsToUint(floor(in_attr0.x)) ^ 2147483648u);
    precise float _147 = in_attr0.y + uintBitsToFloat(floatBitsToUint(floor(in_attr0.y)) ^ 2147483648u);
    precise float _161 = _122 + c3_1.data[635u];
    precise float _168 = fma(_122, c3_1.data[634u], c3_1.data[628u]);
    precise float _176 = _161 * c3_1.data[641u];
    precise float _183 = (1.0 / fma(texture(fs_tex2_38, vec2(in_attr1.x, in_attr1.y)).x, c3_1.data[757u], c3_1.data[756u])) * uintBitsToFloat(c3.data[764u] ^ 2147483648u);
    uint _184 = floatBitsToUint(_183);
    bool _191 = (_122 > 0.99989998340606689453125) || ((_168 <= uintBitsToFloat(_184 ^ 2147483648u)) && (!(_122 > 0.99989998340606689453125)));
    precise float _194 = uintBitsToFloat(_123 ^ 2147483648u) + _126.w;
    precise float _198 = uintBitsToFloat(_123 ^ 2147483648u) + _126.y;
    precise float _202 = uintBitsToFloat(_123 ^ 2147483648u) + _126.x;
    precise float _206 = uintBitsToFloat(_123 ^ 2147483648u) + _126.z;
    precise float _210 = (1.0 / _176) * 2.0;
    precise float _217 = uintBitsToFloat((floatBitsToUint(_198) & 2147483647u) ^ 2147483648u) + uintBitsToFloat(floatBitsToUint(_194) & 2147483647u);
    precise float _223 = uintBitsToFloat(floatBitsToUint(_202) & 2147483647u) + uintBitsToFloat((floatBitsToUint(_206) & 2147483647u) ^ 2147483648u);
    precise float _225 = _217 + _223;
    uint _232;
    if (!_191)
    {
        _232 = floatBitsToUint(texture(fs_tex2_40, vec2(in_attr1.x, in_attr1.y)).x);
    }
    else
    {
        _232 = 0u;
    }
    precise float _235 = _217 + uintBitsToFloat(floatBitsToUint(_223) ^ 2147483648u);
    precise float _242 = uintBitsToFloat(floatBitsToUint(_143) ^ 2147483648u) + clamp(fma(_210, _225, _143), 0.0, 1.0);
    precise float _245 = uintBitsToFloat(floatBitsToUint(_147) ^ 2147483648u) + clamp(fma(_210, _235, _147), 0.0, 1.0);
    precise float _249 = fma(_242, c3_1.data[74u], in_attr1.x);
    precise float _253 = fma(_245, c3_1.data[75u], in_attr1.y);
    vec4 _256 = texture(fs_tex2_70, vec2(in_attr1.x, in_attr1.y));
    float _257 = _256.x;
    uint _258 = floatBitsToUint(_257);
    float _259 = _256.y;
    uint _260 = floatBitsToUint(_259);
    float _261 = _256.z;
    uint _262 = floatBitsToUint(_261);
    vec4 _265 = texture(fs_tex2_60, vec2(_249, _253));
    vec4 _276 = texture(fs_tex2_68, vec2(_249, _253));
    float _280 = _276.w;
    bool _282 = !(!(_122 <= 0.99989998340606689453125));
    bool _287;
    if (!_191)
    {
        _287 = (!(uintBitsToFloat(_232) > 0.0)) && _282;
    }
    else
    {
        _287 = _282;
    }
    uint _1035;
    uint _1036;
    uint _1037;
    if (_287)
    {
        uint _292 = floatBitsToUint(log2(c4_3.data[380u]));
        precise float _296 = in_attr1.x * c4_3.data[384u];
        precise float _300 = in_attr1.y * c4_3.data[385u];
        precise float _308 = fma(in_attr1.y, 2.0, -1.0) * c3_1.data[69u];
        precise float _312 = fma(in_attr1.x, 2.0, -1.0) * c3_1.data[68u];
        precise float _317 = _168 * _308;
        precise float _318 = _168 * _312;
        precise float _319 = _308 * _308;
        precise float _320 = _317 * _317;
        precise float _324 = fma(_312, _312, _319) + 1.0;
        float _326 = inversesqrt(_324);
        uint _327 = floatBitsToUint(_326);
        precise float _330 = uintBitsToFloat(_292 ^ 2147483648u) + log2(c4_3.data[381u]);
        precise float _333 = _330 * 0.693147182464599609375;
        float _334 = sqrt(fma(_168, _168, fma(_318, _318, _320)));
        precise float _339 = _334 * uintBitsToFloat(_327 ^ 2147483648u);
        uint _340 = floatBitsToUint(_339);
        precise float _352 = uintBitsToFloat(_292 ^ 2147483648u) + log2(min(max(uintBitsToFloat(_340 ^ 2147483648u), c4_3.data[380u]), c4_3.data[381u]));
        precise float _357 = _352 * 0.693147182464599609375;
        precise float _358 = _357 * (1.0 / _333);
        precise float _363 = log2(uintBitsToFloat(floatBitsToUint(_358) & 2147483647u)) * (1.0 / c4_3.data[382u]);
        precise float _368 = exp2(_363) * c4_3.data[386u];
        precise float _382 = uintBitsToFloat(_340 ^ 2147483648u) + uintBitsToFloat(c4_1.data[381u] ^ 2147483648u);
        bool _386 = 0.0 != c4_3.data[406u];
        precise float _392 = c4_3.data[377u] * c3_1.data[1u];
        precise float _398 = c4_3.data[377u] * c3_1.data[5u];
        precise float _404 = c4_3.data[377u] * c3_1.data[9u];
        precise float _430 = fma(c4_3.data[378u], c3_1.data[6u], fma(c4_3.data[376u], c3_1.data[4u], _398));
        precise float _437 = fma(c4_3.data[378u], c3_1.data[10u], fma(c4_3.data[376u], c3_1.data[8u], _404));
        precise float _439 = texture(fs_tex2_30, vec3(_296, _300, _368)).x + max(0.0, _382);
        precise float _445 = fma(c4_3.data[378u], c3_1.data[2u], fma(c4_3.data[376u], c3_1.data[0u], _392));
        precise float _447 = _312 * _326;
        precise float _449 = _308 * _326;
        uint _450 = floatBitsToUint(_449);
        precise float _451 = _439 * (1.0 / uintBitsToFloat(_340 ^ 2147483648u));
        float _452 = clamp(_451, 0.0, 1.0);
        uint _631;
        uint _632;
        uint _633;
        uint _634;
        uint _635;
        uint _636;
        uint _637;
        uint _638;
        if (!_386)
        {
            precise float _457 = _430 * uintBitsToFloat(_450 ^ 2147483648u);
            precise float _472 = uintBitsToFloat(floatBitsToUint(clamp(fma(_334, c4_3.data[400u], uintBitsToFloat(c4_1.data[401u] ^ 2147483648u)), 0.0, 1.0)) ^ 2147483648u) + 1.0;
            float _482 = log2(uintBitsToFloat(floatBitsToUint(_472) & 2147483647u));
            float _488 = clamp(fma(fma(_437, uintBitsToFloat(_327 ^ 2147483648u), fma(_445, _447, _457)), -0.5, 0.5), 0.0, 1.0);
            precise float _492 = uintBitsToFloat(floatBitsToUint(_488) ^ 2147483648u) + 1.0;
            precise float _501 = uintBitsToFloat(c4_1.data[411u] ^ 2147483648u) + 1.0;
            precise float _513 = _482 * c4_3.data[409u];
            precise float _517 = sqrt(_492) * 0.636619746685028076171875;
            vec4 _527 = texture(fs_tex2_48, vec2(fma(_517, uintBitsToFloat(floatBitsToUint(fma(_488, fma(_488, fma(_488, -0.0187292993068695068359375, 0.07426099479198455810546875), -0.212114393711090087890625), 1.570728778839111328125)) ^ 2147483648u), 1.0), fma(fma(exp2(_513), _501, c4_3.data[411u]), 0.5, 0.5)));
            float _530 = _527.z;
            precise float _537 = _482 * c4_3.data[408u];
            precise float _554 = uintBitsToFloat(floatBitsToUint(clamp(fma(_334, c4_3.data[404u], uintBitsToFloat(c4_1.data[405u] ^ 2147483648u)), 0.0, 1.0)) ^ 2147483648u) + 1.0;
            precise float _562 = log2(uintBitsToFloat(floatBitsToUint(clamp(_449, 0.0, 1.0)) & 2147483647u)) * c4_3.data[414u];
            precise float _568 = log2(uintBitsToFloat(floatBitsToUint(_554) & 2147483647u)) * c4_3.data[412u];
            uint _570 = floatBitsToUint(exp2(_562));
            precise float _575 = uintBitsToFloat(floatBitsToUint(exp2(_537)) ^ 2147483648u) + 1.0;
            precise float _579 = _575 * c4_3.data[410u];
            float _580 = clamp(_579, 0.0, 1.0);
            precise float _590 = uintBitsToFloat(floatBitsToUint(_580) ^ 2147483648u) + 1.0;
            precise float _594 = uintBitsToFloat(floatBitsToUint(exp2(_568)) ^ 2147483648u) + 1.0;
            precise float _595 = _594 * fma(uintBitsToFloat(_570 ^ 2147483648u), c4_3.data[415u], 1.0);
            precise float _599 = _595 * c4_3.data[419u];
            float _600 = clamp(_599, 0.0, 1.0);
            precise float _604 = uintBitsToFloat(floatBitsToUint(_600) ^ 2147483648u) + 1.0;
            precise float _608 = _600 * c4_3.data[417u];
            precise float _613 = _580 * _604;
            precise float _617 = _600 * c4_3.data[416u];
            precise float _621 = _600 * c4_3.data[418u];
            precise float _623 = _452 * fma(uintBitsToFloat(floatBitsToUint(_590) ^ 2147483648u), _604, 1.0);
            _631 = _570;
            _632 = floatBitsToUint(_621);
            _633 = floatBitsToUint(_530);
            _634 = floatBitsToUint(_608);
            _635 = floatBitsToUint(fma(_527.x, _613, _617));
            _636 = floatBitsToUint(fma(_530, _613, _621));
            _637 = floatBitsToUint(fma(_527.y, _613, _608));
            _638 = floatBitsToUint(_623);
        }
        else
        {
            _631 = floatBitsToUint(_445);
            _632 = floatBitsToUint(_430);
            _633 = floatBitsToUint(_437);
            _634 = floatBitsToUint(_447);
            _635 = _450;
            _636 = floatBitsToUint(_452);
            _637 = _327;
            _638 = floatBitsToUint(_334);
        }
        uint _1010;
        uint _1011;
        uint _1012;
        uint _1013;
        if (_386)
        {
            precise float _645 = uintBitsToFloat(_632 ^ 2147483648u) + uintBitsToFloat(c3.data[5u] ^ 2147483648u);
            precise float _652 = uintBitsToFloat(_631 ^ 2147483648u) + uintBitsToFloat(c3.data[1u] ^ 2147483648u);
            precise float _657 = fma(_645, c4_3.data[402u], uintBitsToFloat(_632));
            precise float _661 = fma(_652, c4_3.data[402u], uintBitsToFloat(_631));
            precise float _668 = uintBitsToFloat(_633 ^ 2147483648u) + uintBitsToFloat(c3.data[9u] ^ 2147483648u);
            precise float _669 = _657 * _657;
            precise float _673 = fma(_668, c4_3.data[402u], uintBitsToFloat(_633));
            precise float _680 = uintBitsToFloat(_635) * uintBitsToFloat(c3.data[49u] ^ 2147483648u);
            float _695 = inversesqrt(fma(_673, _673, fma(_661, _661, _669)));
            precise float _701 = _657 * _695;
            precise float _703 = _661 * _695;
            precise float _704 = _673 * _695;
            precise float _708 = uintBitsToFloat(_635) * uintBitsToFloat(floatBitsToUint(_701) ^ 2147483648u);
            precise float _713 = log2(uintBitsToFloat(floatBitsToUint(fma(clamp(fma(uintBitsToFloat(_637 ^ 2147483648u), c3_1.data[50u], fma(uintBitsToFloat(_634), c3_1.data[48u], _680)), 0.0, 1.0), 0.5, 0.5)) & 2147483647u)) * c4_3.data[409u];
            precise float _716 = fma(uintBitsToFloat(_637 ^ 2147483648u), _704, fma(uintBitsToFloat(_634), _703, _708));
            float _719 = clamp(fma(_716, -0.5, 0.5), 0.0, 1.0);
            precise float _723 = uintBitsToFloat(floatBitsToUint(_719) ^ 2147483648u) + 1.0;
            precise float _730 = sqrt(_723) * 0.636619746685028076171875;
            vec4 _736 = texture(fs_tex2_48, vec2(fma(_730, uintBitsToFloat(floatBitsToUint(fma(_719, fma(_719, fma(_719, -0.0187292993068695068359375, 0.07426099479198455810546875), -0.212114393711090087890625), 1.570728778839111328125)) ^ 2147483648u), 1.0), fma(exp2(_713), 0.5, 0.5)));
            float _742 = 1.0 / c4_3.data[400u];
            precise float _752 = 1.0 + c4_3.data[401u];
            precise float _756 = (-1.0) + c4_3.data[403u];
            precise float _762 = _752 * _742;
            precise float _775 = (1.0 / max(c4_3.data[408u], 0.100000001490116119384765625)) * 30.0;
            precise float _781 = max(0.0, fma(uintBitsToFloat(floatBitsToUint(_742) ^ 2147483648u), c4_3.data[401u], uintBitsToFloat(_638))) * (1.0 / _762);
            precise float _786 = log2(uintBitsToFloat(floatBitsToUint(_775) & 2147483647u)) * 0.5;
            precise float _788 = exp2(_786) * log2(uintBitsToFloat(floatBitsToUint(_781) & 2147483647u));
            precise float _791 = log2(uintBitsToFloat(floatBitsToUint(clamp(uintBitsToFloat(_635), 0.0, 1.0)) & 2147483647u)) * c4_3.data[414u];
            precise float _795 = _762 * exp2(_788);
            precise float _796 = _795 * fma(fma(_716, 0.5, 0.5), _756, 1.0);
            precise float _811 = c4_3.data[410u] * 1.1764705181121826171875;
            precise float _819 = uintBitsToFloat(floatBitsToUint(clamp(fma(uintBitsToFloat(_638), c4_3.data[404u], uintBitsToFloat(c4_1.data[405u] ^ 2147483648u)), 0.0, 1.0)) ^ 2147483648u) + 1.0;
            precise float _821 = _796 * _811;
            precise float _824 = _821 * (-0.0002164042671211063861846923828125);
            precise float _830 = _821 * (-0.00015000000712461769580841064453125);
            precise float _832 = uintBitsToFloat(_636) * _830;
            uint _834 = floatBitsToUint(exp2(_824));
            precise float _837 = _832 * 1.44269502162933349609375;
            precise float _840 = log2(uintBitsToFloat(floatBitsToUint(_819) & 2147483647u)) * c4_3.data[412u];
            precise float _845 = uintBitsToFloat(_834 ^ 2147483648u) + 1.0;
            precise float _854 = uintBitsToFloat(floatBitsToUint(exp2(_837)) ^ 2147483648u) + 1.0;
            precise float _857 = _854 * 1.3333332538604736328125;
            float _858 = 1.0 / min(max(_845, 9.9999997473787516355514526367188e-05), 1.0);
            precise float _861 = uintBitsToFloat(floatBitsToUint(exp2(_840)) ^ 2147483648u) + 1.0;
            precise float _862 = _861 * fma(uintBitsToFloat(floatBitsToUint(exp2(_791)) ^ 2147483648u), c4_3.data[415u], 1.0);
            precise float _865 = _862 * c4_3.data[419u];
            precise float _868 = uintBitsToFloat(_636) * clamp(_865, 0.0, 1.0);
            precise float _870 = _858 * _857;
            precise float _871 = _736.y * _870;
            precise float _873 = _736.x * _870;
            precise float _875 = _736.z * _857;
            precise float _880 = uintBitsToFloat(floatBitsToUint(_871) ^ 2147483648u) + c4_3.data[417u];
            precise float _885 = uintBitsToFloat(floatBitsToUint(_873) ^ 2147483648u) + c4_3.data[416u];
            precise float _886 = _875 * _858;
            precise float _888 = fma(_868, _880, _871);
            precise float _890 = fma(_868, _885, _873);
            precise float _896 = uintBitsToFloat(floatBitsToUint(_886) ^ 2147483648u) + c4_3.data[418u];
            precise float _899 = uintBitsToFloat(floatBitsToUint(_868) ^ 2147483648u) + 1.0;
            precise float _902 = _888 * 0.586610972881317138671875;
            precise float _903 = fma(_868, _896, _886);
            precise float _911 = fma(_890, 0.298911988735198974609375, _902);
            precise float _915 = fma(_903, 0.114477999508380889892578125, _911);
            bool _918 = _915 > 5.0;
            uint _920;
            if (!_918)
            {
                _920 = floatBitsToUint(_890);
            }
            else
            {
                _920 = floatBitsToUint(_911);
            }
            uint _1007;
            uint _1008;
            uint _1009;
            if (_918)
            {
                precise float _923 = _915 + (-5.0);
                uint _924 = floatBitsToUint(_923);
                bool _928 = uintBitsToFloat(_924 & 2147483647u) > 1.0;
                uint _929 = _924 & 2147483647u;
                uint _935;
                if (!_928)
                {
                    _935 = 0u;
                }
                else
                {
                    _935 = _929;
                }
                uint _938;
                if (!_928)
                {
                    _938 = _935 ^ 2147483648u;
                }
                else
                {
                    _938 = _935;
                }
                uint _940;
                if (!_928)
                {
                    _940 = _924;
                }
                else
                {
                    _940 = 2139095040u;
                }
                uint _943;
                if (!_928)
                {
                    _943 = _940 & 2147483647u;
                }
                else
                {
                    _943 = _940;
                }
                uint _949;
                if (!_928)
                {
                    precise float _947 = uintBitsToFloat(_938) + uintBitsToFloat(_943);
                    _949 = floatBitsToUint(_947);
                }
                else
                {
                    _949 = _920;
                }
                uint _950;
                if (_928)
                {
                    _950 = _924;
                }
                else
                {
                    _950 = _943;
                }
                uint _952;
                if (_928)
                {
                    _952 = _950 & 2147483647u;
                }
                else
                {
                    _952 = _950;
                }
                uint _956;
                if (_928)
                {
                    _956 = floatBitsToUint(1.0 / uintBitsToFloat(_952));
                }
                else
                {
                    _956 = _949;
                }
                precise float _960 = uintBitsToFloat(_956) * uintBitsToFloat(_956);
                precise float _963 = _960 + 11.33538818359375;
                precise float _979 = _960 * fma(_960, fma(_960, -0.82336294651031494140625, -5.674867153167724609375), -6.565555095672607421875);
                precise float _981 = _979 * uintBitsToFloat(_956);
                uint _984 = floatBitsToUint(fma(_981, 1.0 / fma(_960, fma(_960, _963, 28.84246826171875), 19.6966705322265625), uintBitsToFloat(_956)));
                uint _986;
                if (_928)
                {
                    _986 = _984;
                }
                else
                {
                    _986 = _938;
                }
                uint _988;
                if (_928)
                {
                    _988 = _986 ^ 2147483648u;
                }
                else
                {
                    _988 = _986;
                }
                uint _989;
                if (_928)
                {
                    _989 = 1070141403u;
                }
                else
                {
                    _989 = 3234994439u;
                }
                uint _994;
                if (_928)
                {
                    precise float _992 = uintBitsToFloat(_988) + uintBitsToFloat(_989);
                    _994 = floatBitsToUint(_992);
                }
                else
                {
                    _994 = _984;
                }
                uint _997;
                if (!(!(uintBitsToFloat(_929) <= uintBitsToFloat(0x7f800000u /* inf */))))
                {
                    _997 = (_924 & 2147483648u) | _994;
                }
                else
                {
                    _997 = _994;
                }
                precise float _999 = uintBitsToFloat(_997) + 5.0;
                precise float _1000 = _999 * (1.0 / _915);
                precise float _1001 = _890 * _1000;
                precise float _1003 = _888 * _1000;
                precise float _1005 = _903 * _1000;
                _1007 = floatBitsToUint(_1001);
                _1008 = floatBitsToUint(_1005);
                _1009 = floatBitsToUint(_1003);
            }
            else
            {
                _1007 = _920;
                _1008 = floatBitsToUint(_903);
                _1009 = floatBitsToUint(_888);
            }
            _1010 = floatBitsToUint(fma(uintBitsToFloat(_834 ^ 2147483648u), _899, 1.0));
            _1011 = _1008;
            _1012 = _1009;
            _1013 = _1007;
        }
        else
        {
            _1010 = _638;
            _1011 = _636;
            _1012 = _637;
            _1013 = _635;
        }
        precise float _1017 = uintBitsToFloat(_258 ^ 2147483648u) + uintBitsToFloat(_1013);
        precise float _1021 = uintBitsToFloat(_260 ^ 2147483648u) + uintBitsToFloat(_1012);
        precise float _1025 = uintBitsToFloat(_262 ^ 2147483648u) + uintBitsToFloat(_1011);
        _1035 = floatBitsToUint(fma(_1025, uintBitsToFloat(_1010), _261));
        _1036 = floatBitsToUint(fma(_1021, uintBitsToFloat(_1010), _259));
        _1037 = floatBitsToUint(fma(_1017, uintBitsToFloat(_1010), _257));
    }
    else
    {
        _1035 = _262;
        _1036 = _260;
        _1037 = _258;
    }
    uint _1130;
    uint _1131;
    uint _1132;
    uint _1133;
    uint _1134;
    uint _1135;
    if (_191)
    {
        uint _1042 = floatBitsToUint(log2(c4_3.data[380u]));
        precise float _1057 = uintBitsToFloat(_1042 ^ 2147483648u) + log2(c4_3.data[381u]);
        precise float _1061 = _1057 * 0.693147182464599609375;
        precise float _1064 = uintBitsToFloat(_1042 ^ 2147483648u) + log2(min(max(_168, c4_3.data[380u]), c4_3.data[381u]));
        precise float _1066 = _1064 * 0.693147182464599609375;
        precise float _1069 = clamp(in_attr1.y, 0.0, 1.0) * c4_3.data[385u];
        precise float _1070 = _1066 * (1.0 / _1061);
        precise float _1074 = clamp(in_attr1.x, 0.0, 1.0) * c4_3.data[384u];
        precise float _1078 = log2(uintBitsToFloat(floatBitsToUint(_1070) & 2147483647u)) * (1.0 / c4_3.data[382u]);
        precise float _1082 = exp2(_1078) * c4_3.data[386u];
        vec4 _1085 = texture(fs_tex2_28, vec3(_1074, _1069, _1082));
        vec4 _1091 = texture(fs_tex2_20, vec3(_1074, _1069, _1082));
        precise float _1098 = _168 * (1.0 / c4_3.data[380u]);
        float _1099 = clamp(_1098, 0.0, 1.0);
        precise float _1101 = _1085.x * _1099;
        precise float _1103 = _1085.y * _1099;
        precise float _1105 = _1085.z * _1099;
        precise float _1116 = _1091.x * _1099;
        precise float _1117 = _1091.y * _1099;
        precise float _1119 = _1091.z * _1099;
        _1130 = floatBitsToUint(_1117);
        _1131 = floatBitsToUint(_1119);
        _1132 = floatBitsToUint(_1099);
        _1133 = floatBitsToUint(fma(exp2(uintBitsToFloat(floatBitsToUint(_1101) ^ 2147483648u)), uintBitsToFloat(_1037), _1116));
        _1134 = floatBitsToUint(fma(exp2(uintBitsToFloat(floatBitsToUint(_1105) ^ 2147483648u)), uintBitsToFloat(_1035), _1119));
        _1135 = floatBitsToUint(fma(exp2(uintBitsToFloat(floatBitsToUint(_1103) ^ 2147483648u)), uintBitsToFloat(_1036), _1117));
    }
    else
    {
        _1130 = floatBitsToUint(in_attr1.x);
        _1131 = floatBitsToUint(in_attr1.y);
        _1132 = floatBitsToUint(_168);
        _1133 = _184;
        _1134 = _1035;
        _1135 = _1037;
    }
    uint _1293;
    uint _1294;
    uint _1295;
    if (!_191)
    {
        uint _1139 = floatBitsToUint(log2(c4_3.data[380u]));
        precise float _1151 = clamp(uintBitsToFloat(_1130), 0.0, 1.0) * c4_3.data[384u];
        precise float _1158 = uintBitsToFloat(_1139 ^ 2147483648u) + log2(c4_3.data[381u]);
        float _1161 = 1.0 / c4_3.data[382u];
        precise float _1162 = _1158 * 0.693147182464599609375;
        precise float _1170 = uintBitsToFloat(_1139 ^ 2147483648u) + log2(min(max(uintBitsToFloat(_1132), c4_3.data[380u]), c4_3.data[381u]));
        precise float _1176 = (1.0 / _1162) * 0.693147182464599609375;
        precise float _1180 = _1170 * _1176;
        precise float _1184 = uintBitsToFloat(_1139 ^ 2147483648u) + log2(min(max(uintBitsToFloat(_1133 ^ 2147483648u), c4_3.data[380u]), c4_3.data[381u]));
        precise float _1188 = _1184 * _1176;
        precise float _1198 = c4_3.data[139u] * 0.013888888992369174957275390625;
        precise float _1202 = _1161 * log2(uintBitsToFloat(floatBitsToUint(_1180) & 2147483647u));
        precise float _1205 = clamp(fma(_1198, 1.0 / c4_3.data[385u], uintBitsToFloat(_1131)), 0.0, 1.0) * c4_3.data[385u];
        precise float _1207 = log2(uintBitsToFloat(floatBitsToUint(_1188) & 2147483647u)) * _1161;
        precise float _1211 = exp2(_1202) * c4_3.data[386u];
        vec4 _1214 = texture(fs_tex2_28, vec3(_1151, _1205, _1211));
        precise float _1220 = exp2(_1207) * c4_3.data[386u];
        vec4 _1223 = texture(fs_tex2_28, vec3(_1151, _1205, _1220));
        vec4 _1229 = texture(fs_tex2_20, vec3(_1151, _1205, _1220));
        vec4 _1235 = texture(fs_tex2_20, vec3(_1151, _1205, _1211));
        float _1241 = 1.0 / c4_3.data[380u];
        precise float _1244 = uintBitsToFloat(_1132) * _1241;
        float _1245 = clamp(_1244, 0.0, 1.0);
        precise float _1249 = uintBitsToFloat(_1133) * uintBitsToFloat(floatBitsToUint(_1241) ^ 2147483648u);
        float _1250 = clamp(_1249, 0.0, 1.0);
        precise float _1251 = _1245 * _1214.x;
        precise float _1253 = _1245 * _1214.y;
        precise float _1258 = _1245 * _1214.z;
        precise float _1268 = _1229.x * _1250;
        precise float _1270 = _1229.y * _1250;
        precise float _1272 = _1229.z * _1250;
        _1293 = floatBitsToUint(fma(exp2(fma(_1223.z, _1250, uintBitsToFloat(floatBitsToUint(_1258) ^ 2147483648u))), uintBitsToFloat(_1134), fma(_1245, _1235.z, uintBitsToFloat(floatBitsToUint(_1272) ^ 2147483648u))));
        _1294 = floatBitsToUint(fma(exp2(fma(_1223.x, _1250, uintBitsToFloat(floatBitsToUint(_1251) ^ 2147483648u))), uintBitsToFloat(_1135), fma(_1245, _1235.x, uintBitsToFloat(floatBitsToUint(_1268) ^ 2147483648u))));
        _1295 = floatBitsToUint(fma(exp2(fma(_1223.y, _1250, uintBitsToFloat(floatBitsToUint(_1253) ^ 2147483648u))), uintBitsToFloat(_1036), fma(_1245, _1235.y, uintBitsToFloat(floatBitsToUint(_1270) ^ 2147483648u))));
    }
    else
    {
        _1293 = _1134;
        _1294 = _1133;
        _1295 = _1135;
    }
    uint _1301 = _191 ? floatBitsToUint(_265.w) : 1065353216u;
    frag_color0.x = fma(uintBitsToFloat(_1301), fma(_280, uintBitsToFloat(_1294), _276.x), uintBitsToFloat(_191 ? floatBitsToUint(_265.x) : 0u));
    frag_color0.y = fma(uintBitsToFloat(_1301), fma(_280, uintBitsToFloat(_1295), _276.y), uintBitsToFloat(_191 ? floatBitsToUint(_265.y) : 0u));
    frag_color0.z = fma(uintBitsToFloat(_1301), fma(_280, uintBitsToFloat(_1293), _276.z), uintBitsToFloat(_191 ? floatBitsToUint(_265.z) : 0u));
    frag_color0.w = 1.0;
    // CUSTOM: A single claimed draw/sample writes a separate next-frame pixel.
    // No same-frame consumer reads this record and no render-pass barrier is needed.
    if (custom_adaptation.capture_fov == 1.f
        && all(equal(ivec2(gl_FragCoord.xy), ivec2(0, 0))) && gl_SampleID == 0) {
        imageStore(custom_adaptation_next, ivec2(1, 0), float4(
            c3_1.data[68u], c3_1.data[69u], _287 ? 1.f : 0.f, custom_adaptation.generation));
    }
}

