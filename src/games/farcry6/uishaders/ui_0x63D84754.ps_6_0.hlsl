#include "../common.hlsli"

cbuffer _21_23 : register(b1, space0)
{
    float4 _23_m0[22] : packoffset(c0);
};

cbuffer _26_28 : register(b0, space0)
{
    float4 _28_m0[57] : packoffset(c0);
};

cbuffer _31_33 : register(b2, space0)
{
    float4 _33_m0[33] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);
Texture2D<float4> _9 : register(t1, space0);
Texture2D<float4> _10 : register(t2, space0);
Texture2D<float4> _11 : register(t3, space0);
Texture2D<float4> _12 : register(t4, space0);
Texture2D<float4> _13 : register(t5, space0);
Texture2D<float4> _14 : register(t6, space0);
Texture2D<float4> _15 : register(t7, space0);
Texture2D<float4> _16 : register(t8, space0);
SamplerState _36 : register(s2, space2);

static float4 TEXCOORD0_centroid;
static float4 TEXCOORD1_centroid;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid;
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid;
  noperspective float4 SV_Position : SV_Position;
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

static bool discard_state;

void discard_exit()
{
    if (discard_state)
    {
        discard;
    }
}

void frag_main()
{
    discard_state = false;
    float4 _86 = _8.Sample(_36, float2(TEXCOORD1_centroid.z, TEXCOORD1_centroid.w));
    float _89 = _86.x;
    float _156;
    float _159;
    float _162;
    float _165;
    if (_28_m0[0u].x == (-1.0f))
    {
        _156 = _89 * TEXCOORD0_centroid.x;
        _159 = _86.y * TEXCOORD0_centroid.y;
        _162 = _86.z * TEXCOORD0_centroid.z;
        _165 = _86.w;
    }
    else
    {
        float _153 = 1.0f - _89;
        float _158;
        float _161;
        float _164;
        if (_28_m0[2u].x != (-1.0f))
        {
            float _213;
            if ((_28_m0[4u].x != 0.0f) || (_28_m0[5u].x != 0.0f))
            {
                _213 = 1.0f - _8.Sample(_36, float2(_28_m0[4u].x + TEXCOORD1_centroid.z, _28_m0[5u].x + TEXCOORD1_centroid.w)).x;
            }
            else
            {
                _213 = _153;
            }
            float frontier_phi_5_9_ladder;
            float frontier_phi_5_9_ladder_1;
            float frontier_phi_5_9_ladder_2;
            if (_213 < _28_m0[2u].x)
            {
                frontier_phi_5_9_ladder = TEXCOORD0_centroid.z;
                frontier_phi_5_9_ladder_1 = TEXCOORD0_centroid.y;
                frontier_phi_5_9_ladder_2 = TEXCOORD0_centroid.x;
            }
            else
            {
                float _402;
                if (_213 < _28_m0[3u].x)
                {
                    float _397 = clamp((_213 - _28_m0[2u].x) / (_28_m0[3u].x - _28_m0[2u].x), 0.0f, 1.0f);
                    _402 = (_397 * _397) * (3.0f - (_397 * 2.0f));
                }
                else
                {
                    _402 = 1.0f;
                }
                frontier_phi_5_9_ladder = (_402 * (_28_m0[12u].x - TEXCOORD0_centroid.z)) + TEXCOORD0_centroid.z;
                frontier_phi_5_9_ladder_1 = (_402 * (_28_m0[11u].x - TEXCOORD0_centroid.y)) + TEXCOORD0_centroid.y;
                frontier_phi_5_9_ladder_2 = (_402 * (_28_m0[10u].x - TEXCOORD0_centroid.x)) + TEXCOORD0_centroid.x;
            }
            _158 = frontier_phi_5_9_ladder_2;
            _161 = frontier_phi_5_9_ladder_1;
            _164 = frontier_phi_5_9_ladder;
        }
        else
        {
            _158 = TEXCOORD0_centroid.x;
            _161 = TEXCOORD0_centroid.y;
            _164 = TEXCOORD0_centroid.z;
        }
        float _167;
        if (_28_m0[0u].x != _28_m0[1u].x)
        {
            float _219 = clamp((_153 - _28_m0[1u].x) / (_28_m0[0u].x - _28_m0[1u].x), 0.0f, 1.0f);
            _167 = (_219 * _219) * (3.0f - (_219 * 2.0f));
        }
        else
        {
            _167 = float(_153 <= ((_28_m0[1u].x + _28_m0[0u].x) * 0.5f));
        }
        float frontier_phi_3_17_ladder;
        float frontier_phi_3_17_ladder_1;
        float frontier_phi_3_17_ladder_2;
        float frontier_phi_3_17_ladder_3;
        if (_28_m0[6u].x != (-1.0f))
        {
            float _464;
            if ((_28_m0[8u].x != 0.0f) || (_28_m0[9u].x != 0.0f))
            {
                _464 = 1.0f - _8.Sample(_36, float2(_28_m0[8u].x + TEXCOORD1_centroid.z, _28_m0[9u].x + TEXCOORD1_centroid.w)).x;
            }
            else
            {
                _464 = _153;
            }
            float frontier_phi_3_17_ladder_31_ladder;
            float frontier_phi_3_17_ladder_31_ladder_1;
            float frontier_phi_3_17_ladder_31_ladder_2;
            float frontier_phi_3_17_ladder_31_ladder_3;
            if (_464 > _28_m0[7u].x)
            {
                frontier_phi_3_17_ladder_31_ladder = _167;
                frontier_phi_3_17_ladder_31_ladder_1 = _164;
                frontier_phi_3_17_ladder_31_ladder_2 = _161;
                frontier_phi_3_17_ladder_31_ladder_3 = _158;
            }
            else
            {
                float _517;
                if (_464 > _28_m0[6u].x)
                {
                    float _512 = clamp((_464 - _28_m0[7u].x) / (_28_m0[6u].x - _28_m0[7u].x), 0.0f, 1.0f);
                    _517 = (_512 * _512) * (3.0f - (_512 * 2.0f));
                }
                else
                {
                    _517 = 1.0f;
                }
                frontier_phi_3_17_ladder_31_ladder = ((_167 - _517) * _167) + _517;
                frontier_phi_3_17_ladder_31_ladder_1 = (_167 * (_164 - _28_m0[16u].x)) + _28_m0[16u].x;
                frontier_phi_3_17_ladder_31_ladder_2 = (_167 * (_161 - _28_m0[15u].x)) + _28_m0[15u].x;
                frontier_phi_3_17_ladder_31_ladder_3 = (_167 * (_158 - _28_m0[14u].x)) + _28_m0[14u].x;
            }
            frontier_phi_3_17_ladder = frontier_phi_3_17_ladder_31_ladder;
            frontier_phi_3_17_ladder_1 = frontier_phi_3_17_ladder_31_ladder_1;
            frontier_phi_3_17_ladder_2 = frontier_phi_3_17_ladder_31_ladder_2;
            frontier_phi_3_17_ladder_3 = frontier_phi_3_17_ladder_31_ladder_3;
        }
        else
        {
            frontier_phi_3_17_ladder = _167;
            frontier_phi_3_17_ladder_1 = _164;
            frontier_phi_3_17_ladder_2 = _161;
            frontier_phi_3_17_ladder_3 = _158;
        }
        _156 = frontier_phi_3_17_ladder_3;
        _159 = frontier_phi_3_17_ladder_2;
        _162 = frontier_phi_3_17_ladder_1;
        _165 = frontier_phi_3_17_ladder;
    }
    precise float _168 = _165 * TEXCOORD0_centroid.w;
    uint4 _173 = asuint(_23_m0[18u]);
    uint _174 = _173.w;
    float _184;
    float _187;
    float _190;
    float _193;
    if (_174 == 4294967294u)
    {
        _184 = _156;
        _187 = _159;
        _190 = _162;
        _193 = _168;
    }
    else
    {
        float _194;
        float _313;
        float _314;
        float _315;
        if (_28_m0[30u].z > 0.0f)
        {
          if (RENODX_TONE_MAP_TYPE == 0.f) {
            float _239 = _28_m0[30u].y * 0.100000001490116119384765625f;
            float _252 = log2(abs(exp2(((log2(_28_m0[30u].z) + (-13.28771209716796875f)) * 1.49297344684600830078125f) + 18.0f) * 0.180000007152557373046875f));
            float _255 = exp2(_252 * 1.5f);
            float _258 = ((_255 * _239) / _28_m0[30u].z) + (-0.076367549598217010498046875f);
            float _262 = exp2(_252 * 1.275000095367431640625f);
            float _269 = (_262 * 0.076367549598217010498046875f) - (((_28_m0[30u].y * 0.011232397519052028656005859375f) * _255) / _28_m0[30u].z);
            float _272 = (_262 + (-0.1123239696025848388671875f)) * _239;
            float _277 = log2(abs(_156));
            float _278 = log2(abs(_159));
            float _279 = log2(abs(_162));
            float _308 = 5000.0f / _28_m0[30u].y;
            _313 = (((exp2(_277 * 1.5f) * _272) / ((exp2(_277 * 1.275000095367431640625f) * _258) + _269)) * 9.9999997473787516355514526367188e-05f) * _308;
            _314 = (((exp2(_278 * 1.5f) * _272) / ((exp2(_278 * 1.275000095367431640625f) * _258) + _269)) * 9.9999997473787516355514526367188e-05f) * _308;
            _315 = (((exp2(_279 * 1.5f) * _272) / ((exp2(_279 * 1.275000095367431640625f) * _258) + _269)) * 9.9999997473787516355514526367188e-05f) * _308;
          } else {
            float3 tonemapped = renodx::color::bt709::from::AP1(ApplyCustomToneMap(renodx::color::ap1::from::BT709(float3(_156, _159, _162))));
            tonemapped = GameScale(tonemapped);
            _313 = tonemapped.x, _314 = tonemapped.y, _315 = tonemapped.z;
          }
            _194 = 1.0f;
        }
        else
        {
            _313 = _156;
            _314 = _159;
            _315 = _162;
            _194 = _168;
        }
        float _186;
        if (_313 < 0.003039932809770107269287109375f)
        {
            _186 = _313 * 12.92321014404296875f;
        }
        else
        {
            _186 = (exp2(log2(abs(_313)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float _189;
        if (_314 < 0.003039932809770107269287109375f)
        {
            _189 = _314 * 12.92321014404296875f;
        }
        else
        {
            _189 = (exp2(log2(abs(_314)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float _192;
        if (_315 < 0.003039932809770107269287109375f)
        {
            _192 = _315 * 12.92321014404296875f;
        }
        else
        {
            _192 = (exp2(log2(abs(_315)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float frontier_phi_6_56_ladder;
        float frontier_phi_6_56_ladder_1;
        float frontier_phi_6_56_ladder_2;
        float frontier_phi_6_56_ladder_3;
        if (_174 == 4294967295u)
        {
            frontier_phi_6_56_ladder = _194;
            frontier_phi_6_56_ladder_1 = clamp((exp2(log2(abs(_192)) * _28_m0[27u].z) * _28_m0[27u].y) + _28_m0[27u].x, 0.0f, 1.0f);
            frontier_phi_6_56_ladder_2 = clamp((exp2(log2(abs(_189)) * _28_m0[27u].z) * _28_m0[27u].y) + _28_m0[27u].x, 0.0f, 1.0f);
            frontier_phi_6_56_ladder_3 = clamp((exp2(log2(abs(_186)) * _28_m0[27u].z) * _28_m0[27u].y) + _28_m0[27u].x, 0.0f, 1.0f);
        }
        else
        {
            frontier_phi_6_56_ladder = _194;
            frontier_phi_6_56_ladder_1 = _192;
            frontier_phi_6_56_ladder_2 = _189;
            frontier_phi_6_56_ladder_3 = _186;
        }
        _184 = frontier_phi_6_56_ladder_3;
        _187 = frontier_phi_6_56_ladder_2;
        _190 = frontier_phi_6_56_ladder_1;
        _193 = frontier_phi_6_56_ladder;
    }
    float _231;
    if (int(asuint(_33_m0[32u]).x) > int(0u))
    {
        float _232;
        float _526;
        float _320 = 1.0f;
        uint _321 = 0u;
        uint _328;
        float _336;
        float _339;
        bool _342;
        for (;;)
        {
            _328 = _321 + 8u;
            _336 = mad(_33_m0[_321].y, TEXCOORD1_centroid.y, _33_m0[_321].x * TEXCOORD1_centroid.x) + _33_m0[_321].z;
            _339 = mad(_33_m0[_328].y, TEXCOORD1_centroid.y, _33_m0[_328].x * TEXCOORD1_centroid.x) + _33_m0[_328].z;
            _342 = (_336 < 0.0f) || (_336 > 1.0f);
            if (_342)
            {
                discard_state = true;
            }
            if ((_339 < 0.0f) || (_339 > 1.0f))
            {
                discard_state = true;
            }
            uint _466 = _321 + 16u;
            uint _472 = _321 + 24u;
            float _481 = mad(_33_m0[_466].y, _339, _33_m0[_466].x * _336) + _33_m0[_466].z;
            float _484 = mad(_33_m0[_472].y, _339, _33_m0[_472].x * _336) + _33_m0[_472].z;
            float frontier_phi_45_pred;
            if (_321 == 0u)
            {
                frontier_phi_45_pred = _9.Sample(_36, float2(_481, _484)).w;
            }
            else
            {
                float frontier_phi_45_pred_40_ladder;
                if (_321 == 1u)
                {
                    frontier_phi_45_pred_40_ladder = _10.Sample(_36, float2(_481, _484)).w;
                }
                else
                {
                    float frontier_phi_45_pred_40_ladder_47_ladder;
                    if (_321 == 2u)
                    {
                        frontier_phi_45_pred_40_ladder_47_ladder = _11.Sample(_36, float2(_481, _484)).w;
                    }
                    else
                    {
                        float frontier_phi_45_pred_40_ladder_47_ladder_54_ladder;
                        if (_321 == 3u)
                        {
                            frontier_phi_45_pred_40_ladder_47_ladder_54_ladder = _12.Sample(_36, float2(_481, _484)).w;
                        }
                        else
                        {
                            float frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder;
                            if (_321 == 4u)
                            {
                                frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder = _13.Sample(_36, float2(_481, _484)).w;
                            }
                            else
                            {
                                float frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder_63_ladder;
                                if (_321 == 5u)
                                {
                                    frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder_63_ladder = _14.Sample(_36, float2(_481, _484)).w;
                                }
                                else
                                {
                                    float frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder_63_ladder_66_ladder;
                                    if (_321 == 6u)
                                    {
                                        frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder_63_ladder_66_ladder = _15.Sample(_36, float2(_481, _484)).w;
                                    }
                                    else
                                    {
                                        frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder_63_ladder_66_ladder = _16.Sample(_36, float2(_481, _484)).w;
                                    }
                                    frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder_63_ladder = frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder_63_ladder_66_ladder;
                                }
                                frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder = frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder_63_ladder;
                            }
                            frontier_phi_45_pred_40_ladder_47_ladder_54_ladder = frontier_phi_45_pred_40_ladder_47_ladder_54_ladder_58_ladder;
                        }
                        frontier_phi_45_pred_40_ladder_47_ladder = frontier_phi_45_pred_40_ladder_47_ladder_54_ladder;
                    }
                    frontier_phi_45_pred_40_ladder = frontier_phi_45_pred_40_ladder_47_ladder;
                }
                frontier_phi_45_pred = frontier_phi_45_pred_40_ladder;
            }
            _526 = frontier_phi_45_pred;
            float _543 = clamp((_526 - _33_m0[_321].w) / (_33_m0[_328].w - _33_m0[_321].w), 0.0f, 1.0f);
            _232 = ((_543 * _543) * _320) * (3.0f - (_543 * 2.0f));
            uint _322 = _321 + 1u;
            if (int(_322) < int(asuint(_33_m0[32u]).x))
            {
                _320 = _232;
                _321 = _322;
                continue;
            }
            else
            {
                break;
            }
        }
        _231 = _232;
    }
    else
    {
        _231 = 1.0f;
    }
    float _343;
    float _352;
    float _361;
    if (asuint(_28_m0[30u]).w == 0u)
    {
        _343 = _184;
        _352 = _187;
        _361 = _190;
    }
    else
    {
        float frontier_phi_19_20_ladder;
        float frontier_phi_19_20_ladder_1;
        float frontier_phi_19_20_ladder_2;
        if (_28_m0[33u].x < 0.0f)
        {
            frontier_phi_19_20_ladder = _184;
            frontier_phi_19_20_ladder_1 = _190;
            frontier_phi_19_20_ladder_2 = _187;
        }
        else
        {
            float _423 = dot(float3(_184, _187, _190), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
            float _430 = _28_m0[33u].x - _184;
            float _431 = _28_m0[33u].y - _187;
            float _432 = _28_m0[33u].z - _190;
            float _447 = clamp((sqrt(((_430 * _430) + (_431 * _431)) + (_432 * _432)) - _28_m0[49u].x) / (_28_m0[49u].y - _28_m0[49u].x), 0.0f, 1.0f);
            float _451 = (_447 * _447) * (3.0f - (_447 * 2.0f));
            float _452 = _423 * _28_m0[41u].x;
            float _453 = _423 * _28_m0[41u].y;
            float _454 = _423 * _28_m0[41u].z;
            float _506;
            if (_452 < 0.003039932809770107269287109375f)
            {
                _506 = _452 * 12.92321014404296875f;
            }
            else
            {
                _506 = (exp2(log2(abs(_452)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            float _575;
            if (_453 < 0.003039932809770107269287109375f)
            {
                _575 = _453 * 12.92321014404296875f;
            }
            else
            {
                _575 = (exp2(log2(abs(_453)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            float _618;
            if (_454 < 0.003039932809770107269287109375f)
            {
                _618 = _454 * 12.92321014404296875f;
            }
            else
            {
                _618 = (exp2(log2(abs(_454)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            float _344 = ((_184 - _506) * _451) + _506;
            float _353 = ((_187 - _575) * _451) + _575;
            float _362 = ((_190 - _618) * _451) + _618;
            float frontier_phi_19_20_ladder_64_ladder;
            float frontier_phi_19_20_ladder_64_ladder_1;
            float frontier_phi_19_20_ladder_64_ladder_2;
            if (_28_m0[34u].x < 0.0f)
            {
                frontier_phi_19_20_ladder_64_ladder = _344;
                frontier_phi_19_20_ladder_64_ladder_1 = _362;
                frontier_phi_19_20_ladder_64_ladder_2 = _353;
            }
            else
            {
                float _642 = dot(float3(_344, _353, _362), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                float _645 = _28_m0[34u].x - _344;
                float _646 = _28_m0[34u].y - _353;
                float _647 = _28_m0[34u].z - _362;
                float _662 = clamp((sqrt(((_645 * _645) + (_646 * _646)) + (_647 * _647)) - _28_m0[50u].x) / (_28_m0[50u].y - _28_m0[50u].x), 0.0f, 1.0f);
                float _666 = (_662 * _662) * (3.0f - (_662 * 2.0f));
                float _667 = _642 * _28_m0[42u].x;
                float _668 = _642 * _28_m0[42u].y;
                float _669 = _642 * _28_m0[42u].z;
                float _684;
                if (_667 < 0.003039932809770107269287109375f)
                {
                    _684 = _667 * 12.92321014404296875f;
                }
                else
                {
                    _684 = (exp2(log2(abs(_667)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                float _693;
                if (_668 < 0.003039932809770107269287109375f)
                {
                    _693 = _668 * 12.92321014404296875f;
                }
                else
                {
                    _693 = (exp2(log2(abs(_668)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                float _702;
                if (_669 < 0.003039932809770107269287109375f)
                {
                    _702 = _669 * 12.92321014404296875f;
                }
                else
                {
                    _702 = (exp2(log2(abs(_669)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                float _345 = ((_344 - _684) * _666) + _684;
                float _354 = ((_353 - _693) * _666) + _693;
                float _363 = ((_362 - _702) * _666) + _702;
                float frontier_phi_19_20_ladder_64_ladder_78_ladder;
                float frontier_phi_19_20_ladder_64_ladder_78_ladder_1;
                float frontier_phi_19_20_ladder_64_ladder_78_ladder_2;
                if (_28_m0[35u].x < 0.0f)
                {
                    frontier_phi_19_20_ladder_64_ladder_78_ladder = _345;
                    frontier_phi_19_20_ladder_64_ladder_78_ladder_1 = _363;
                    frontier_phi_19_20_ladder_64_ladder_78_ladder_2 = _354;
                }
                else
                {
                    float _722 = dot(float3(_345, _354, _363), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                    float _725 = _28_m0[35u].x - _345;
                    float _726 = _28_m0[35u].y - _354;
                    float _727 = _28_m0[35u].z - _363;
                    float _742 = clamp((sqrt(((_725 * _725) + (_726 * _726)) + (_727 * _727)) - _28_m0[51u].x) / (_28_m0[51u].y - _28_m0[51u].x), 0.0f, 1.0f);
                    float _746 = (_742 * _742) * (3.0f - (_742 * 2.0f));
                    float _747 = _722 * _28_m0[43u].x;
                    float _748 = _722 * _28_m0[43u].y;
                    float _749 = _722 * _28_m0[43u].z;
                    float _758;
                    if (_747 < 0.003039932809770107269287109375f)
                    {
                        _758 = _747 * 12.92321014404296875f;
                    }
                    else
                    {
                        _758 = (exp2(log2(abs(_747)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                    }
                    float _767;
                    if (_748 < 0.003039932809770107269287109375f)
                    {
                        _767 = _748 * 12.92321014404296875f;
                    }
                    else
                    {
                        _767 = (exp2(log2(abs(_748)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                    }
                    float _776;
                    if (_749 < 0.003039932809770107269287109375f)
                    {
                        _776 = _749 * 12.92321014404296875f;
                    }
                    else
                    {
                        _776 = (exp2(log2(abs(_749)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                    }
                    float _346 = ((_345 - _758) * _746) + _758;
                    float _355 = ((_354 - _767) * _746) + _767;
                    float _364 = ((_363 - _776) * _746) + _776;
                    float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder;
                    float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_1;
                    float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_2;
                    if (_28_m0[36u].x < 0.0f)
                    {
                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder = _346;
                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_1 = _364;
                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_2 = _355;
                    }
                    else
                    {
                        float _796 = dot(float3(_346, _355, _364), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                        float _799 = _28_m0[36u].x - _346;
                        float _800 = _28_m0[36u].y - _355;
                        float _801 = _28_m0[36u].z - _364;
                        float _816 = clamp((sqrt(((_799 * _799) + (_800 * _800)) + (_801 * _801)) - _28_m0[52u].x) / (_28_m0[52u].y - _28_m0[52u].x), 0.0f, 1.0f);
                        float _820 = (_816 * _816) * (3.0f - (_816 * 2.0f));
                        float _821 = _796 * _28_m0[44u].x;
                        float _822 = _796 * _28_m0[44u].y;
                        float _823 = _796 * _28_m0[44u].z;
                        float _832;
                        if (_821 < 0.003039932809770107269287109375f)
                        {
                            _832 = _821 * 12.92321014404296875f;
                        }
                        else
                        {
                            _832 = (exp2(log2(abs(_821)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                        }
                        float _841;
                        if (_822 < 0.003039932809770107269287109375f)
                        {
                            _841 = _822 * 12.92321014404296875f;
                        }
                        else
                        {
                            _841 = (exp2(log2(abs(_822)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                        }
                        float _850;
                        if (_823 < 0.003039932809770107269287109375f)
                        {
                            _850 = _823 * 12.92321014404296875f;
                        }
                        else
                        {
                            _850 = (exp2(log2(abs(_823)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                        }
                        float _347 = ((_346 - _832) * _820) + _832;
                        float _356 = ((_355 - _841) * _820) + _841;
                        float _365 = ((_364 - _850) * _820) + _850;
                        float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder;
                        float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_1;
                        float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_2;
                        if (_28_m0[37u].x < 0.0f)
                        {
                            frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder = _347;
                            frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_1 = _365;
                            frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_2 = _356;
                        }
                        else
                        {
                            float _870 = dot(float3(_347, _356, _365), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                            float _873 = _28_m0[37u].x - _347;
                            float _874 = _28_m0[37u].y - _356;
                            float _875 = _28_m0[37u].z - _365;
                            float _890 = clamp((sqrt(((_873 * _873) + (_874 * _874)) + (_875 * _875)) - _28_m0[53u].x) / (_28_m0[53u].y - _28_m0[53u].x), 0.0f, 1.0f);
                            float _894 = (_890 * _890) * (3.0f - (_890 * 2.0f));
                            float _895 = _870 * _28_m0[45u].x;
                            float _896 = _870 * _28_m0[45u].y;
                            float _897 = _870 * _28_m0[45u].z;
                            float _906;
                            if (_895 < 0.003039932809770107269287109375f)
                            {
                                _906 = _895 * 12.92321014404296875f;
                            }
                            else
                            {
                                _906 = (exp2(log2(abs(_895)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                            }
                            float _915;
                            if (_896 < 0.003039932809770107269287109375f)
                            {
                                _915 = _896 * 12.92321014404296875f;
                            }
                            else
                            {
                                _915 = (exp2(log2(abs(_896)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                            }
                            float _924;
                            if (_897 < 0.003039932809770107269287109375f)
                            {
                                _924 = _897 * 12.92321014404296875f;
                            }
                            else
                            {
                                _924 = (exp2(log2(abs(_897)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                            }
                            float _348 = ((_347 - _906) * _894) + _906;
                            float _357 = ((_356 - _915) * _894) + _915;
                            float _366 = ((_365 - _924) * _894) + _924;
                            float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder;
                            float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_1;
                            float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_2;
                            if (_28_m0[38u].x < 0.0f)
                            {
                                frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder = _348;
                                frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_1 = _366;
                                frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_2 = _357;
                            }
                            else
                            {
                                float _944 = dot(float3(_348, _357, _366), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                                float _947 = _28_m0[38u].x - _348;
                                float _948 = _28_m0[38u].y - _357;
                                float _949 = _28_m0[38u].z - _366;
                                float _964 = clamp((sqrt(((_947 * _947) + (_948 * _948)) + (_949 * _949)) - _28_m0[54u].x) / (_28_m0[54u].y - _28_m0[54u].x), 0.0f, 1.0f);
                                float _968 = (_964 * _964) * (3.0f - (_964 * 2.0f));
                                float _969 = _944 * _28_m0[46u].x;
                                float _970 = _944 * _28_m0[46u].y;
                                float _971 = _944 * _28_m0[46u].z;
                                float _980;
                                if (_969 < 0.003039932809770107269287109375f)
                                {
                                    _980 = _969 * 12.92321014404296875f;
                                }
                                else
                                {
                                    _980 = (exp2(log2(abs(_969)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                }
                                float _989;
                                if (_970 < 0.003039932809770107269287109375f)
                                {
                                    _989 = _970 * 12.92321014404296875f;
                                }
                                else
                                {
                                    _989 = (exp2(log2(abs(_970)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                }
                                float _998;
                                if (_971 < 0.003039932809770107269287109375f)
                                {
                                    _998 = _971 * 12.92321014404296875f;
                                }
                                else
                                {
                                    _998 = (exp2(log2(abs(_971)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                }
                                float _349 = ((_348 - _980) * _968) + _980;
                                float _358 = ((_357 - _989) * _968) + _989;
                                float _367 = ((_366 - _998) * _968) + _998;
                                float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder;
                                float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_1;
                                float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_2;
                                if (_28_m0[39u].x < 0.0f)
                                {
                                    frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder = _349;
                                    frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_1 = _367;
                                    frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_2 = _358;
                                }
                                else
                                {
                                    float _1018 = dot(float3(_349, _358, _367), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                                    float _1021 = _28_m0[39u].x - _349;
                                    float _1022 = _28_m0[39u].y - _358;
                                    float _1023 = _28_m0[39u].z - _367;
                                    float _1038 = clamp((sqrt(((_1021 * _1021) + (_1022 * _1022)) + (_1023 * _1023)) - _28_m0[55u].x) / (_28_m0[55u].y - _28_m0[55u].x), 0.0f, 1.0f);
                                    float _1042 = (_1038 * _1038) * (3.0f - (_1038 * 2.0f));
                                    float _1043 = _1018 * _28_m0[47u].x;
                                    float _1044 = _1018 * _28_m0[47u].y;
                                    float _1045 = _1018 * _28_m0[47u].z;
                                    float _1054;
                                    if (_1043 < 0.003039932809770107269287109375f)
                                    {
                                        _1054 = _1043 * 12.92321014404296875f;
                                    }
                                    else
                                    {
                                        _1054 = (exp2(log2(abs(_1043)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                    }
                                    float _1063;
                                    if (_1044 < 0.003039932809770107269287109375f)
                                    {
                                        _1063 = _1044 * 12.92321014404296875f;
                                    }
                                    else
                                    {
                                        _1063 = (exp2(log2(abs(_1044)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                    }
                                    float _1072;
                                    if (_1045 < 0.003039932809770107269287109375f)
                                    {
                                        _1072 = _1045 * 12.92321014404296875f;
                                    }
                                    else
                                    {
                                        _1072 = (exp2(log2(abs(_1045)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                    }
                                    float _351 = ((_349 - _1054) * _1042) + _1054;
                                    float _360 = ((_358 - _1063) * _1042) + _1063;
                                    float _369 = ((_367 - _1072) * _1042) + _1072;
                                    float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder;
                                    float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder_1;
                                    float frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder_2;
                                    if (_28_m0[40u].x < 0.0f)
                                    {
                                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder = _351;
                                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder_1 = _369;
                                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder_2 = _360;
                                    }
                                    else
                                    {
                                        float _1092 = dot(float3(_351, _360, _369), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                                        float _1095 = _28_m0[40u].x - _351;
                                        float _1096 = _28_m0[40u].y - _360;
                                        float _1097 = _28_m0[40u].z - _369;
                                        float _1112 = clamp((sqrt(((_1095 * _1095) + (_1096 * _1096)) + (_1097 * _1097)) - _28_m0[56u].x) / (_28_m0[56u].y - _28_m0[56u].x), 0.0f, 1.0f);
                                        float _1116 = (_1112 * _1112) * (3.0f - (_1112 * 2.0f));
                                        float _1117 = _1092 * _28_m0[48u].x;
                                        float _1118 = _1092 * _28_m0[48u].y;
                                        float _1119 = _1092 * _28_m0[48u].z;
                                        float _1128;
                                        if (_1117 < 0.003039932809770107269287109375f)
                                        {
                                            _1128 = _1117 * 12.92321014404296875f;
                                        }
                                        else
                                        {
                                            _1128 = (exp2(log2(abs(_1117)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                        }
                                        float _1137;
                                        if (_1118 < 0.003039932809770107269287109375f)
                                        {
                                            _1137 = _1118 * 12.92321014404296875f;
                                        }
                                        else
                                        {
                                            _1137 = (exp2(log2(abs(_1118)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                        }
                                        float _1146;
                                        if (_1119 < 0.003039932809770107269287109375f)
                                        {
                                            _1146 = _1119 * 12.92321014404296875f;
                                        }
                                        else
                                        {
                                            _1146 = (exp2(log2(abs(_1119)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                        }
                                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder = ((_351 - _1128) * _1116) + _1128;
                                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder_1 = ((_369 - _1146) * _1116) + _1146;
                                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder_2 = ((_360 - _1137) * _1116) + _1137;
                                    }
                                    frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder;
                                    frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_1 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder_1;
                                    frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_2 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_128_ladder_2;
                                }
                                frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder;
                                frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_1 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_1;
                                frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_2 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_118_ladder_2;
                            }
                            frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder;
                            frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_1 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_1;
                            frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_2 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_108_ladder_2;
                        }
                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder;
                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_1 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_1;
                        frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_2 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_98_ladder_2;
                    }
                    frontier_phi_19_20_ladder_64_ladder_78_ladder = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder;
                    frontier_phi_19_20_ladder_64_ladder_78_ladder_1 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_1;
                    frontier_phi_19_20_ladder_64_ladder_78_ladder_2 = frontier_phi_19_20_ladder_64_ladder_78_ladder_88_ladder_2;
                }
                frontier_phi_19_20_ladder_64_ladder = frontier_phi_19_20_ladder_64_ladder_78_ladder;
                frontier_phi_19_20_ladder_64_ladder_1 = frontier_phi_19_20_ladder_64_ladder_78_ladder_1;
                frontier_phi_19_20_ladder_64_ladder_2 = frontier_phi_19_20_ladder_64_ladder_78_ladder_2;
            }
            frontier_phi_19_20_ladder = frontier_phi_19_20_ladder_64_ladder;
            frontier_phi_19_20_ladder_1 = frontier_phi_19_20_ladder_64_ladder_1;
            frontier_phi_19_20_ladder_2 = frontier_phi_19_20_ladder_64_ladder_2;
        }
        _343 = frontier_phi_19_20_ladder;
        _352 = frontier_phi_19_20_ladder_2;
        _361 = frontier_phi_19_20_ladder_1;
    }
    SV_Target.x = _343;
    SV_Target.y = _352;
    SV_Target.z = _361;
    SV_Target.w = _231 * _193;

    SV_Target.rgb = UIScale(SV_Target.rgb);

    discard_exit();
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TEXCOORD0_centroid = stage_input.TEXCOORD0_centroid;
    TEXCOORD1_centroid = stage_input.TEXCOORD1_centroid;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
