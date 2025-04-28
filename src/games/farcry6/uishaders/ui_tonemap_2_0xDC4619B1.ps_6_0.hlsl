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
    float4 _80 = _8.Sample(_36, float2(TEXCOORD1_centroid.z, TEXCOORD1_centroid.w));
    float _83 = _80.x;
    float _84 = _80.y;
    float _85 = _80.z;
    float _86 = _80.w;
    float _95;
    float _97;
    float _99;
    if (asuint(_28_m0[30u]).x == 0u)
    {
        _95 = _83;
        _97 = _84;
        _99 = _85;
    }
    else
    {
        float _113 = (_86 == 0.0f) ? 1.0f : _86;
        _95 = _83 / _113;
        _97 = _84 / _113;
        _99 = _85 / _113;
    }
    float _101 = _95 * TEXCOORD0_centroid.x;
    float _102 = _97 * TEXCOORD0_centroid.y;
    float _103 = _99 * TEXCOORD0_centroid.z;
    float _104 = _86 * TEXCOORD0_centroid.w;
    uint4 _108 = asuint(_23_m0[18u]);
    uint _109 = _108.w;
    bool _110 = _109 == 4294967295u;
    float _119;
    float _120;
    float _121;
    if (_110)
    {
        _119 = clamp(_101, 0.0f, 1.0f);
        _120 = clamp(_102, 0.0f, 1.0f);
        _121 = clamp(_103, 0.0f, 1.0f);
    }
    else
    {
        _119 = _101;
        _120 = _102;
        _121 = _103;
    }
    float _124;
    float _127;
    float _130;
    float _133;
    if (_109 == 4294967294u)
    {
        _124 = _119;
        _127 = _120;
        _130 = _121;
        _133 = _104;
    }
    else
    {
        float _134;
        float _227;
        float _228;
        float _229;
        if (_28_m0[30u].z > 0.0f)
        {
          if (RENODX_TONE_MAP_TYPE == 0.f) {
            float _153 = _28_m0[30u].y * 0.100000001490116119384765625f;
            float _166 = log2(abs(exp2(((log2(_28_m0[30u].z) + (-13.28771209716796875f)) * 1.49297344684600830078125f) + 18.0f) * 0.180000007152557373046875f));
            float _169 = exp2(_166 * 1.5f);
            float _172 = ((_169 * _153) / _28_m0[30u].z) + (-0.076367549598217010498046875f);
            float _176 = exp2(_166 * 1.275000095367431640625f);
            float _183 = (_176 * 0.076367549598217010498046875f) - (((_28_m0[30u].y * 0.011232397519052028656005859375f) * _169) / _28_m0[30u].z);
            float _186 = (_176 + (-0.1123239696025848388671875f)) * _153;
            float _191 = log2(abs(_119));
            float _192 = log2(abs(_120));
            float _193 = log2(abs(_121));
            float _222 = 5000.0f / _28_m0[30u].y;
            _227 = (((exp2(_191 * 1.5f) * _186) / ((exp2(_191 * 1.275000095367431640625f) * _172) + _183)) * 9.9999997473787516355514526367188e-05f) * _222;
            _228 = (((exp2(_192 * 1.5f) * _186) / ((exp2(_192 * 1.275000095367431640625f) * _172) + _183)) * 9.9999997473787516355514526367188e-05f) * _222;
            _229 = (((exp2(_193 * 1.5f) * _186) / ((exp2(_193 * 1.275000095367431640625f) * _172) + _183)) * 9.9999997473787516355514526367188e-05f) * _222;
          } else {
            float3 tonemapped = renodx::color::bt709::from::AP1(ApplyCustomToneMap(renodx::color::ap1::from::BT709(float3(_119, _120, _121))));
            tonemapped = GameScale(tonemapped);
            _227 = tonemapped.x, _228 = tonemapped.y, _229 = tonemapped.z;
          }

            _134 = 1.0f;
        }
        else
        {
            _227 = _119;
            _228 = _120;
            _229 = _121;
            _134 = _104;
        }
        // float _126;
        // if (_227 < 0.003039932809770107269287109375f)
        // {
        //     _126 = _227 * 12.92321014404296875f;
        // }
        // else
        // {
        //     _126 = (exp2(log2(abs(_227)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        // }
        // float _129;
        // if (_228 < 0.003039932809770107269287109375f)
        // {
        //     _129 = _228 * 12.92321014404296875f;
        // }
        // else
        // {
        //     _129 = (exp2(log2(abs(_228)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        // }
        // float _132;
        // if (_229 < 0.003039932809770107269287109375f)
        // {
        //     _132 = _229 * 12.92321014404296875f;
        // }
        // else
        // {
        //     _132 = (exp2(log2(abs(_229)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        // }
        float _126 = renodx::color::srgb::EncodeSafe(_227);
        float _129 = renodx::color::srgb::EncodeSafe(_228);
        float _132 = renodx::color::srgb::EncodeSafe(_229);


        float frontier_phi_5_41_ladder;
        float frontier_phi_5_41_ladder_1;
        float frontier_phi_5_41_ladder_2;
        float frontier_phi_5_41_ladder_3;
        if (_110)
        {
            frontier_phi_5_41_ladder = _134;
            frontier_phi_5_41_ladder_1 = clamp((exp2(log2(abs(_132)) * _28_m0[27u].z) * _28_m0[27u].y) + _28_m0[27u].x, 0.0f, 1.0f);
            frontier_phi_5_41_ladder_2 = clamp((exp2(log2(abs(_129)) * _28_m0[27u].z) * _28_m0[27u].y) + _28_m0[27u].x, 0.0f, 1.0f);
            frontier_phi_5_41_ladder_3 = clamp((exp2(log2(abs(_126)) * _28_m0[27u].z) * _28_m0[27u].y) + _28_m0[27u].x, 0.0f, 1.0f);
        }
        else
        {
            frontier_phi_5_41_ladder = _134;
            frontier_phi_5_41_ladder_1 = _132;
            frontier_phi_5_41_ladder_2 = _129;
            frontier_phi_5_41_ladder_3 = _126;
        }
        _124 = frontier_phi_5_41_ladder_3;
        _127 = frontier_phi_5_41_ladder_2;
        _130 = frontier_phi_5_41_ladder_1;
        _133 = frontier_phi_5_41_ladder;
    }
    float _145;
    if (int(asuint(_33_m0[32u]).x) > int(0u))
    {
        float _146;
        float _397;
        float _232 = 1.0f;
        uint _233 = 0u;
        uint _240;
        float _249;
        float _252;
        bool _255;
        for (;;)
        {
            _240 = _233 + 8u;
            _249 = mad(_33_m0[_233].y, TEXCOORD1_centroid.y, _33_m0[_233].x * TEXCOORD1_centroid.x) + _33_m0[_233].z;
            _252 = mad(_33_m0[_240].y, TEXCOORD1_centroid.y, _33_m0[_240].x * TEXCOORD1_centroid.x) + _33_m0[_240].z;
            _255 = (_249 < 0.0f) || (_249 > 1.0f);
            if (_255)
            {
                discard_state = true;
            }
            if ((_252 < 0.0f) || (_252 > 1.0f))
            {
                discard_state = true;
            }
            uint _354 = _233 + 16u;
            uint _361 = _233 + 24u;
            float _370 = mad(_33_m0[_354].y, _252, _33_m0[_354].x * _249) + _33_m0[_354].z;
            float _373 = mad(_33_m0[_361].y, _252, _33_m0[_361].x * _249) + _33_m0[_361].z;
            float frontier_phi_30_pred;
            if (_233 == 0u)
            {
                frontier_phi_30_pred = _9.Sample(_36, float2(_370, _373)).w;
            }
            else
            {
                float frontier_phi_30_pred_27_ladder;
                if (_233 == 1u)
                {
                    frontier_phi_30_pred_27_ladder = _10.Sample(_36, float2(_370, _373)).w;
                }
                else
                {
                    float frontier_phi_30_pred_27_ladder_32_ladder;
                    if (_233 == 2u)
                    {
                        frontier_phi_30_pred_27_ladder_32_ladder = _11.Sample(_36, float2(_370, _373)).w;
                    }
                    else
                    {
                        float frontier_phi_30_pred_27_ladder_32_ladder_39_ladder;
                        if (_233 == 3u)
                        {
                            frontier_phi_30_pred_27_ladder_32_ladder_39_ladder = _12.Sample(_36, float2(_370, _373)).w;
                        }
                        else
                        {
                            float frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder;
                            if (_233 == 4u)
                            {
                                frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder = _13.Sample(_36, float2(_370, _373)).w;
                            }
                            else
                            {
                                float frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder_48_ladder;
                                if (_233 == 5u)
                                {
                                    frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder_48_ladder = _14.Sample(_36, float2(_370, _373)).w;
                                }
                                else
                                {
                                    float frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder_48_ladder_51_ladder;
                                    if (_233 == 6u)
                                    {
                                        frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder_48_ladder_51_ladder = _15.Sample(_36, float2(_370, _373)).w;
                                    }
                                    else
                                    {
                                        frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder_48_ladder_51_ladder = _16.Sample(_36, float2(_370, _373)).w;
                                    }
                                    frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder_48_ladder = frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder_48_ladder_51_ladder;
                                }
                                frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder = frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder_48_ladder;
                            }
                            frontier_phi_30_pred_27_ladder_32_ladder_39_ladder = frontier_phi_30_pred_27_ladder_32_ladder_39_ladder_43_ladder;
                        }
                        frontier_phi_30_pred_27_ladder_32_ladder = frontier_phi_30_pred_27_ladder_32_ladder_39_ladder;
                    }
                    frontier_phi_30_pred_27_ladder = frontier_phi_30_pred_27_ladder_32_ladder;
                }
                frontier_phi_30_pred = frontier_phi_30_pred_27_ladder;
            }
            _397 = frontier_phi_30_pred;
            float _414 = clamp((_397 - _33_m0[_233].w) / (_33_m0[_240].w - _33_m0[_233].w), 0.0f, 1.0f);
            _146 = ((_414 * _414) * _232) * (3.0f - (_414 * 2.0f));
            uint _234 = _233 + 1u;
            if (int(_234) < int(asuint(_33_m0[32u]).x))
            {
                _232 = _146;
                _233 = _234;
                continue;
            }
            else
            {
                break;
            }
        }
        _145 = _146;
    }
    else
    {
        _145 = 1.0f;
    }
    float _256;
    float _265;
    float _274;
    if (asuint(_28_m0[30u]).w == 0u)
    {
        _256 = _124;
        _265 = _127;
        _274 = _130;
    }
    else
    {
        float frontier_phi_12_13_ladder;
        float frontier_phi_12_13_ladder_1;
        float frontier_phi_12_13_ladder_2;
        if (_28_m0[33u].x < 0.0f)
        {
            frontier_phi_12_13_ladder = _124;
            frontier_phi_12_13_ladder_1 = _130;
            frontier_phi_12_13_ladder_2 = _127;
        }
        else
        {
            float _318 = dot(float3(_124, _127, _130), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
            float _325 = _28_m0[33u].x - _124;
            float _326 = _28_m0[33u].y - _127;
            float _327 = _28_m0[33u].z - _130;
            float _342 = clamp((sqrt(((_325 * _325) + (_326 * _326)) + (_327 * _327)) - _28_m0[49u].x) / (_28_m0[49u].y - _28_m0[49u].x), 0.0f, 1.0f);
            float _348 = (_342 * _342) * (3.0f - (_342 * 2.0f));
            float _349 = _318 * _28_m0[41u].x;
            float _350 = _318 * _28_m0[41u].y;
            float _351 = _318 * _28_m0[41u].z;
            float _394;
            if (_349 < 0.003039932809770107269287109375f)
            {
                _394 = _349 * 12.92321014404296875f;
            }
            else
            {
                _394 = (exp2(log2(abs(_349)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            float _446;
            if (_350 < 0.003039932809770107269287109375f)
            {
                _446 = _350 * 12.92321014404296875f;
            }
            else
            {
                _446 = (exp2(log2(abs(_350)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            float _489;
            if (_351 < 0.003039932809770107269287109375f)
            {
                _489 = _351 * 12.92321014404296875f;
            }
            else
            {
                _489 = (exp2(log2(abs(_351)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            float _257 = ((_124 - _394) * _348) + _394;
            float _266 = ((_127 - _446) * _348) + _446;
            float _275 = ((_130 - _489) * _348) + _489;
            float frontier_phi_12_13_ladder_49_ladder;
            float frontier_phi_12_13_ladder_49_ladder_1;
            float frontier_phi_12_13_ladder_49_ladder_2;
            if (_28_m0[34u].x < 0.0f)
            {
                frontier_phi_12_13_ladder_49_ladder = _257;
                frontier_phi_12_13_ladder_49_ladder_1 = _275;
                frontier_phi_12_13_ladder_49_ladder_2 = _266;
            }
            else
            {
                float _514 = dot(float3(_257, _266, _275), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                float _517 = _28_m0[34u].x - _257;
                float _518 = _28_m0[34u].y - _266;
                float _519 = _28_m0[34u].z - _275;
                float _534 = clamp((sqrt(((_517 * _517) + (_518 * _518)) + (_519 * _519)) - _28_m0[50u].x) / (_28_m0[50u].y - _28_m0[50u].x), 0.0f, 1.0f);
                float _538 = (_534 * _534) * (3.0f - (_534 * 2.0f));
                float _539 = _514 * _28_m0[42u].x;
                float _540 = _514 * _28_m0[42u].y;
                float _541 = _514 * _28_m0[42u].z;
                float _556;
                if (_539 < 0.003039932809770107269287109375f)
                {
                    _556 = _539 * 12.92321014404296875f;
                }
                else
                {
                    _556 = (exp2(log2(abs(_539)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                float _565;
                if (_540 < 0.003039932809770107269287109375f)
                {
                    _565 = _540 * 12.92321014404296875f;
                }
                else
                {
                    _565 = (exp2(log2(abs(_540)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                float _574;
                if (_541 < 0.003039932809770107269287109375f)
                {
                    _574 = _541 * 12.92321014404296875f;
                }
                else
                {
                    _574 = (exp2(log2(abs(_541)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                float _258 = ((_257 - _556) * _538) + _556;
                float _267 = ((_266 - _565) * _538) + _565;
                float _276 = ((_275 - _574) * _538) + _574;
                float frontier_phi_12_13_ladder_49_ladder_63_ladder;
                float frontier_phi_12_13_ladder_49_ladder_63_ladder_1;
                float frontier_phi_12_13_ladder_49_ladder_63_ladder_2;
                if (_28_m0[35u].x < 0.0f)
                {
                    frontier_phi_12_13_ladder_49_ladder_63_ladder = _258;
                    frontier_phi_12_13_ladder_49_ladder_63_ladder_1 = _276;
                    frontier_phi_12_13_ladder_49_ladder_63_ladder_2 = _267;
                }
                else
                {
                    float _594 = dot(float3(_258, _267, _276), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                    float _597 = _28_m0[35u].x - _258;
                    float _598 = _28_m0[35u].y - _267;
                    float _599 = _28_m0[35u].z - _276;
                    float _614 = clamp((sqrt(((_597 * _597) + (_598 * _598)) + (_599 * _599)) - _28_m0[51u].x) / (_28_m0[51u].y - _28_m0[51u].x), 0.0f, 1.0f);
                    float _618 = (_614 * _614) * (3.0f - (_614 * 2.0f));
                    float _619 = _594 * _28_m0[43u].x;
                    float _620 = _594 * _28_m0[43u].y;
                    float _621 = _594 * _28_m0[43u].z;
                    float _630;
                    if (_619 < 0.003039932809770107269287109375f)
                    {
                        _630 = _619 * 12.92321014404296875f;
                    }
                    else
                    {
                        _630 = (exp2(log2(abs(_619)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                    }
                    float _639;
                    if (_620 < 0.003039932809770107269287109375f)
                    {
                        _639 = _620 * 12.92321014404296875f;
                    }
                    else
                    {
                        _639 = (exp2(log2(abs(_620)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                    }
                    float _648;
                    if (_621 < 0.003039932809770107269287109375f)
                    {
                        _648 = _621 * 12.92321014404296875f;
                    }
                    else
                    {
                        _648 = (exp2(log2(abs(_621)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                    }
                    float _259 = ((_258 - _630) * _618) + _630;
                    float _268 = ((_267 - _639) * _618) + _639;
                    float _277 = ((_276 - _648) * _618) + _648;
                    float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder;
                    float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_1;
                    float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_2;
                    if (_28_m0[36u].x < 0.0f)
                    {
                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder = _259;
                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_1 = _277;
                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_2 = _268;
                    }
                    else
                    {
                        float _668 = dot(float3(_259, _268, _277), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                        float _671 = _28_m0[36u].x - _259;
                        float _672 = _28_m0[36u].y - _268;
                        float _673 = _28_m0[36u].z - _277;
                        float _688 = clamp((sqrt(((_671 * _671) + (_672 * _672)) + (_673 * _673)) - _28_m0[52u].x) / (_28_m0[52u].y - _28_m0[52u].x), 0.0f, 1.0f);
                        float _692 = (_688 * _688) * (3.0f - (_688 * 2.0f));
                        float _693 = _668 * _28_m0[44u].x;
                        float _694 = _668 * _28_m0[44u].y;
                        float _695 = _668 * _28_m0[44u].z;
                        float _704;
                        if (_693 < 0.003039932809770107269287109375f)
                        {
                            _704 = _693 * 12.92321014404296875f;
                        }
                        else
                        {
                            _704 = (exp2(log2(abs(_693)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                        }
                        float _713;
                        if (_694 < 0.003039932809770107269287109375f)
                        {
                            _713 = _694 * 12.92321014404296875f;
                        }
                        else
                        {
                            _713 = (exp2(log2(abs(_694)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                        }
                        float _722;
                        if (_695 < 0.003039932809770107269287109375f)
                        {
                            _722 = _695 * 12.92321014404296875f;
                        }
                        else
                        {
                            _722 = (exp2(log2(abs(_695)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                        }
                        float _260 = ((_259 - _704) * _692) + _704;
                        float _269 = ((_268 - _713) * _692) + _713;
                        float _278 = ((_277 - _722) * _692) + _722;
                        float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder;
                        float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_1;
                        float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_2;
                        if (_28_m0[37u].x < 0.0f)
                        {
                            frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder = _260;
                            frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_1 = _278;
                            frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_2 = _269;
                        }
                        else
                        {
                            float _742 = dot(float3(_260, _269, _278), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                            float _745 = _28_m0[37u].x - _260;
                            float _746 = _28_m0[37u].y - _269;
                            float _747 = _28_m0[37u].z - _278;
                            float _762 = clamp((sqrt(((_745 * _745) + (_746 * _746)) + (_747 * _747)) - _28_m0[53u].x) / (_28_m0[53u].y - _28_m0[53u].x), 0.0f, 1.0f);
                            float _766 = (_762 * _762) * (3.0f - (_762 * 2.0f));
                            float _767 = _742 * _28_m0[45u].x;
                            float _768 = _742 * _28_m0[45u].y;
                            float _769 = _742 * _28_m0[45u].z;
                            float _778;
                            if (_767 < 0.003039932809770107269287109375f)
                            {
                                _778 = _767 * 12.92321014404296875f;
                            }
                            else
                            {
                                _778 = (exp2(log2(abs(_767)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                            }
                            float _787;
                            if (_768 < 0.003039932809770107269287109375f)
                            {
                                _787 = _768 * 12.92321014404296875f;
                            }
                            else
                            {
                                _787 = (exp2(log2(abs(_768)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                            }
                            float _796;
                            if (_769 < 0.003039932809770107269287109375f)
                            {
                                _796 = _769 * 12.92321014404296875f;
                            }
                            else
                            {
                                _796 = (exp2(log2(abs(_769)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                            }
                            float _261 = ((_260 - _778) * _766) + _778;
                            float _270 = ((_269 - _787) * _766) + _787;
                            float _279 = ((_278 - _796) * _766) + _796;
                            float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder;
                            float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_1;
                            float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_2;
                            if (_28_m0[38u].x < 0.0f)
                            {
                                frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder = _261;
                                frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_1 = _279;
                                frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_2 = _270;
                            }
                            else
                            {
                                float _816 = dot(float3(_261, _270, _279), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                                float _819 = _28_m0[38u].x - _261;
                                float _820 = _28_m0[38u].y - _270;
                                float _821 = _28_m0[38u].z - _279;
                                float _836 = clamp((sqrt(((_819 * _819) + (_820 * _820)) + (_821 * _821)) - _28_m0[54u].x) / (_28_m0[54u].y - _28_m0[54u].x), 0.0f, 1.0f);
                                float _840 = (_836 * _836) * (3.0f - (_836 * 2.0f));
                                float _841 = _816 * _28_m0[46u].x;
                                float _842 = _816 * _28_m0[46u].y;
                                float _843 = _816 * _28_m0[46u].z;
                                float _852;
                                if (_841 < 0.003039932809770107269287109375f)
                                {
                                    _852 = _841 * 12.92321014404296875f;
                                }
                                else
                                {
                                    _852 = (exp2(log2(abs(_841)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                }
                                float _861;
                                if (_842 < 0.003039932809770107269287109375f)
                                {
                                    _861 = _842 * 12.92321014404296875f;
                                }
                                else
                                {
                                    _861 = (exp2(log2(abs(_842)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                }
                                float _870;
                                if (_843 < 0.003039932809770107269287109375f)
                                {
                                    _870 = _843 * 12.92321014404296875f;
                                }
                                else
                                {
                                    _870 = (exp2(log2(abs(_843)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                }
                                float _262 = ((_261 - _852) * _840) + _852;
                                float _271 = ((_270 - _861) * _840) + _861;
                                float _280 = ((_279 - _870) * _840) + _870;
                                float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder;
                                float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_1;
                                float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_2;
                                if (_28_m0[39u].x < 0.0f)
                                {
                                    frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder = _262;
                                    frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_1 = _280;
                                    frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_2 = _271;
                                }
                                else
                                {
                                    float _890 = dot(float3(_262, _271, _280), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                                    float _893 = _28_m0[39u].x - _262;
                                    float _894 = _28_m0[39u].y - _271;
                                    float _895 = _28_m0[39u].z - _280;
                                    float _910 = clamp((sqrt(((_893 * _893) + (_894 * _894)) + (_895 * _895)) - _28_m0[55u].x) / (_28_m0[55u].y - _28_m0[55u].x), 0.0f, 1.0f);
                                    float _914 = (_910 * _910) * (3.0f - (_910 * 2.0f));
                                    float _915 = _890 * _28_m0[47u].x;
                                    float _916 = _890 * _28_m0[47u].y;
                                    float _917 = _890 * _28_m0[47u].z;
                                    float _926;
                                    if (_915 < 0.003039932809770107269287109375f)
                                    {
                                        _926 = _915 * 12.92321014404296875f;
                                    }
                                    else
                                    {
                                        _926 = (exp2(log2(abs(_915)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                    }
                                    float _935;
                                    if (_916 < 0.003039932809770107269287109375f)
                                    {
                                        _935 = _916 * 12.92321014404296875f;
                                    }
                                    else
                                    {
                                        _935 = (exp2(log2(abs(_916)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                    }
                                    float _944;
                                    if (_917 < 0.003039932809770107269287109375f)
                                    {
                                        _944 = _917 * 12.92321014404296875f;
                                    }
                                    else
                                    {
                                        _944 = (exp2(log2(abs(_917)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                    }
                                    float _264 = ((_262 - _926) * _914) + _926;
                                    float _273 = ((_271 - _935) * _914) + _935;
                                    float _282 = ((_280 - _944) * _914) + _944;
                                    float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder;
                                    float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder_1;
                                    float frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder_2;
                                    if (_28_m0[40u].x < 0.0f)
                                    {
                                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder = _264;
                                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder_1 = _282;
                                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder_2 = _273;
                                    }
                                    else
                                    {
                                        float _964 = dot(float3(_264, _273, _282), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
                                        float _967 = _28_m0[40u].x - _264;
                                        float _968 = _28_m0[40u].y - _273;
                                        float _969 = _28_m0[40u].z - _282;
                                        float _984 = clamp((sqrt(((_967 * _967) + (_968 * _968)) + (_969 * _969)) - _28_m0[56u].x) / (_28_m0[56u].y - _28_m0[56u].x), 0.0f, 1.0f);
                                        float _988 = (_984 * _984) * (3.0f - (_984 * 2.0f));
                                        float _989 = _964 * _28_m0[48u].x;
                                        float _990 = _964 * _28_m0[48u].y;
                                        float _991 = _964 * _28_m0[48u].z;
                                        float _1000;
                                        if (_989 < 0.003039932809770107269287109375f)
                                        {
                                            _1000 = _989 * 12.92321014404296875f;
                                        }
                                        else
                                        {
                                            _1000 = (exp2(log2(abs(_989)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                        }
                                        float _1009;
                                        if (_990 < 0.003039932809770107269287109375f)
                                        {
                                            _1009 = _990 * 12.92321014404296875f;
                                        }
                                        else
                                        {
                                            _1009 = (exp2(log2(abs(_990)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                        }
                                        float _1018;
                                        if (_991 < 0.003039932809770107269287109375f)
                                        {
                                            _1018 = _991 * 12.92321014404296875f;
                                        }
                                        else
                                        {
                                            _1018 = (exp2(log2(abs(_991)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                                        }
                                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder = ((_264 - _1000) * _988) + _1000;
                                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder_1 = ((_282 - _1018) * _988) + _1018;
                                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder_2 = ((_273 - _1009) * _988) + _1009;
                                    }
                                    frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder;
                                    frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_1 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder_1;
                                    frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_2 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_113_ladder_2;
                                }
                                frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder;
                                frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_1 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_1;
                                frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_2 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_103_ladder_2;
                            }
                            frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder;
                            frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_1 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_1;
                            frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_2 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_93_ladder_2;
                        }
                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder;
                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_1 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_1;
                        frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_2 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_83_ladder_2;
                    }
                    frontier_phi_12_13_ladder_49_ladder_63_ladder = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder;
                    frontier_phi_12_13_ladder_49_ladder_63_ladder_1 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_1;
                    frontier_phi_12_13_ladder_49_ladder_63_ladder_2 = frontier_phi_12_13_ladder_49_ladder_63_ladder_73_ladder_2;
                }
                frontier_phi_12_13_ladder_49_ladder = frontier_phi_12_13_ladder_49_ladder_63_ladder;
                frontier_phi_12_13_ladder_49_ladder_1 = frontier_phi_12_13_ladder_49_ladder_63_ladder_1;
                frontier_phi_12_13_ladder_49_ladder_2 = frontier_phi_12_13_ladder_49_ladder_63_ladder_2;
            }
            frontier_phi_12_13_ladder = frontier_phi_12_13_ladder_49_ladder;
            frontier_phi_12_13_ladder_1 = frontier_phi_12_13_ladder_49_ladder_1;
            frontier_phi_12_13_ladder_2 = frontier_phi_12_13_ladder_49_ladder_2;
        }
        _256 = frontier_phi_12_13_ladder;
        _265 = frontier_phi_12_13_ladder_2;
        _274 = frontier_phi_12_13_ladder_1;
    }
    SV_Target.x = _256;
    SV_Target.y = _265;
    SV_Target.z = _274;
    SV_Target.w = _145 * _133;

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
