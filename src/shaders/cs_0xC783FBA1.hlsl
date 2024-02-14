// Film Grain overlay

cbuffer _27_29 : register(b0, space0)
{
    float4 _29_m0[30] : packoffset(c0);
};

cbuffer _32_34 : register(b12, space0)
{
    float4 _34_m0[99] : packoffset(c0);
};

cbuffer _36_38 : register(b6, space0)
{
    float4 _38_m0[30] : packoffset(c0);
};

Texture2D<float4> _8 : register(t32, space0);
Texture2D<uint4> _12 : register(t51, space0);
Texture2D<float4> _13 : register(t1, space0);
Texture2D<float4> _14 : register(t2, space0);
Texture2D<float4> _15 : register(t3, space0);
Buffer<uint4> _18 : register(t7, space0);
Texture2D<float4> _19 : register(t10, space0);
RWTexture2D<float4> _22 : register(u0, space0);
RWTexture2D<float4> _23 : register(u1, space0);
SamplerState _41 : register(s0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main()
{
    uint4 _73 = _18.Load(asuint(_38_m0[13u]).x + gl_WorkGroupID.x);
    uint _74 = _73.x;
    uint _82 = ((_74 << 4u) & 1048560u) + gl_LocalInvocationID.x;
    uint _83 = ((_74 >> 16u) << 4u) + gl_LocalInvocationID.y;
    float4 _84 = _8.Load(int3(uint2(_82, _83), 0u));
    float _87 = _84.x;
    float _88 = _84.y;
    float _89 = _84.z;
    float _97 = float(_82);
    float _98 = float(_83);
    float _282;
    float _283;
    float _284;
    if (_38_m0[12u].x > 0.0f)
    {
        uint _113 = 1u << (_12.Load(int3(uint2(uint(_34_m0[79u].x * _97), uint(_34_m0[79u].y * _98)), 0u)).y & 31u);
        float4 _117 = _13.Load(int3(uint2(_82 & 255u, _83 & 255u), 0u));
        float _119 = _117.x;
        float _120 = _117.y;
        float _121 = _117.z;
        float _124 = ((_119 + _120) + _121) * 0.3333333432674407958984375f;
        float _129 = _38_m0[12u].x * _87;
        float _130 = _38_m0[12u].x * _88;
        float _131 = _38_m0[12u].x * _89;
        float _148 = _119 - _124;
        float _149 = _120 - _124;
        float _150 = _121 - _124;
        float _154 = _124 + (-0.5f);
        uint4 _168 = asuint(_38_m0[17u]);
        float _172 = float(min((_168.x & _113), 1u));
        float _201 = float(min((_168.y & _113), 1u));
        float _230 = float(min((_168.z & _113), 1u));
        float _259 = float(min((_168.w & _113), 1u));
        float _266 = (((((((_154 + (_38_m0[18u].w * _148)) * _38_m0[18u].x) * _172) + 1.0f) * (_129 / max(1.0f - _129, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (_38_m0[19u].w * _148)) * _38_m0[19u].x) * _201) + 1.0f)) * ((((_154 + (_38_m0[20u].w * _148)) * _38_m0[20u].x) * _230) + 1.0f)) * ((((_154 + (_38_m0[21u].w * _148)) * _38_m0[21u].x) * _259) + 1.0f);
        float _267 = (((((((_154 + (_38_m0[18u].w * _149)) * _38_m0[18u].y) * _172) + 1.0f) * (_130 / max(1.0f - _130, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (_38_m0[19u].w * _149)) * _38_m0[19u].y) * _201) + 1.0f)) * ((((_154 + (_38_m0[20u].w * _149)) * _38_m0[20u].y) * _230) + 1.0f)) * ((((_154 + (_38_m0[21u].w * _149)) * _38_m0[21u].y) * _259) + 1.0f);
        float _268 = (((((((_154 + (_38_m0[18u].w * _150)) * _38_m0[18u].z) * _172) + 1.0f) * (_131 / max(1.0f - _131, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (_38_m0[19u].w * _150)) * _38_m0[19u].z) * _201) + 1.0f)) * ((((_154 + (_38_m0[20u].w * _150)) * _38_m0[20u].z) * _230) + 1.0f)) * ((((_154 + (_38_m0[21u].w * _150)) * _38_m0[21u].z) * _259) + 1.0f);
        _282 = _38_m0[12u].y * (_266 / max(_266 + 1.0f, 1.0f));
        _283 = _38_m0[12u].y * (_267 / max(_267 + 1.0f, 1.0f));
        _284 = _38_m0[12u].y * (_268 / max(_268 + 1.0f, 1.0f));
    }
    else
    {
        _282 = _87;
        _283 = _88;
        _284 = _89;
    }
    uint4 _290 = asuint(_38_m0[12u]);
    float _295 = (_97 + 0.5f) / float(_290.z);
    float _296 = (_98 + 0.5f) / float(_290.w);
    float _311;
    float _313;
    float _315;
    if (((_295 < _38_m0[9u].y) || (_296 < _38_m0[9u].z)) || (((1.0f - _38_m0[9u].y) < _295) || ((1.0f - _38_m0[9u].z) < _296)))
    {
        _311 = 0.0f;
        _313 = 0.0f;
        _315 = 0.0f;
    }
    else
    {
        float4 _324 = _15.SampleLevel(_41, float2(_295, _296), 0.0f);
        float4 _332 = _14.SampleLevel(_41, float2(_295, _296), 0.0f);
        float _337 = _332.w;
        float _338 = 1.0f - _337;
        float _343 = (_338 * _324.w) + _337;
        _311 = ((_343 * ((_332.x - _282) + (_338 * _324.x))) + _282) * _38_m0[1u].z;
        _313 = ((_343 * ((_332.y - _283) + (_338 * _324.y))) + _283) * _38_m0[1u].z;
        _315 = ((_343 * ((_332.z - _284) + (_338 * _324.z))) + _284) * _38_m0[1u].z;
    }
    float _374;
    float _376;
    float _378;
    if (_38_m0[14u].w > 0.0f)
    {
        uint4 _362 = asuint(_38_m0[10u]);
        uint _363 = _362.x;
        uint _365 = _362.z;
        uint _368 = _362.y;
        uint _371 = _362.w;
        float frontier_phi_6_5_ladder;
        float frontier_phi_6_5_ladder_1;
        float frontier_phi_6_5_ladder_2;
        if ((((_82 >= _363) && (_82 < _365)) && (_83 >= _368)) && (_83 < _371))
        {
            float4 _407 = _19.SampleLevel(_41, float2((_38_m0[11u].z * ((_97 - float(int(_363))) / float(int(_365 - _363)))) + _38_m0[11u].x, (_38_m0[11u].w * ((_98 - float(int(_368))) / float(int(_371 - _368)))) + _38_m0[11u].y), 0.0f);
            frontier_phi_6_5_ladder = _407.x * _38_m0[14u].w;
            frontier_phi_6_5_ladder_1 = _407.y * _38_m0[14u].w;
            frontier_phi_6_5_ladder_2 = _407.z * _38_m0[14u].w;
        }
        else
        {
            frontier_phi_6_5_ladder = _311;
            frontier_phi_6_5_ladder_1 = _313;
            frontier_phi_6_5_ladder_2 = _315;
        }
        _374 = frontier_phi_6_5_ladder;
        _376 = frontier_phi_6_5_ladder_1;
        _378 = frontier_phi_6_5_ladder_2;
    }
    else
    {
        _374 = _311;
        _376 = _313;
        _378 = _315;
    }
    uint4 _382 = asuint(_38_m0[13u]);
    float _412;
    float _418;
    float _424;
    if (_382.y == 0u)
    {
        _412 = _374;
        _418 = _376;
        _424 = _378;
    }
    else
    {
        uint _460 = _382.w;
        float _527;
        float _528;
        float _529;
        if (_38_m0[14u].z != 1.0f)
        {
            _527 = exp2(log2(abs(_374)) * _38_m0[14u].z);
            _528 = exp2(log2(abs(_376)) * _38_m0[14u].z);
            _529 = exp2(log2(abs(_378)) * _38_m0[14u].z);
        }
        else
        {
            _527 = _374;
            _528 = _376;
            _529 = _378;
        }
        float _539 = frac(_97 * 211.1488037109375f);
        float _540 = frac(_98 * 210.944000244140625f);
        float _541 = frac(_29_m0[0u].x * 6.227200031280517578125f);
        float _545 = _541 + 33.3300018310546875f;
        float _546 = dot(float3(_539, _540, _541), float3(_540 + 33.3300018310546875f, _539 + 33.3300018310546875f, _545));
        float _550 = _546 + _539;
        float _551 = _546 + _540;
        float _553 = _550 + _551;
        float _559 = frac(_553 * (_546 + _541));
        float _560 = frac((_550 * 2.0f) * _551);
        float _561 = frac(_553 * _550);
        float _567 = frac((_97 + 64.0f) * 211.1488037109375f);
        float _568 = frac((_98 + 64.0f) * 210.944000244140625f);
        float _571 = dot(float3(_567, _568, _541), float3(_568 + 33.3300018310546875f, _567 + 33.3300018310546875f, _545));
        float _574 = _571 + _567;
        float _575 = _571 + _568;
        float _577 = _574 + _575;
        float _582 = frac(_577 * (_571 + _541));
        float _583 = frac((_574 * 2.0f) * _575);
        float _584 = frac(_577 * _574);
        float frontier_phi_8_13_ladder;
        float frontier_phi_8_13_ladder_1;
        float frontier_phi_8_13_ladder_2;
        if (_460 == 0u)
        {
            float _681 = (_527 <= 0.003130800090730190277099609375f) ? (_527 * 12.9200000762939453125f) : ((exp2(log2(abs(_527)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _682 = (_528 <= 0.003130800090730190277099609375f) ? (_528 * 12.9200000762939453125f) : ((exp2(log2(abs(_528)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _683 = (_529 <= 0.003130800090730190277099609375f) ? (_529 * 12.9200000762939453125f) : ((exp2(log2(abs(_529)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _684 = _681 * 510.0f;
            float _686 = _682 * 510.0f;
            float _687 = _683 * 510.0f;
            frontier_phi_8_13_ladder = (((_559 + (-0.5f)) + (min(min(1.0f, _684), 510.0f - _684) * (_582 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _681;
            frontier_phi_8_13_ladder_1 = (((_560 + (-0.5f)) + (min(min(1.0f, _686), 510.0f - _686) * (_583 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _682;
            frontier_phi_8_13_ladder_2 = (((_561 + (-0.5f)) + (min(min(1.0f, _687), 510.0f - _687) * (_584 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _683;
        }
        else
        {
            float frontier_phi_8_13_ladder_19_ladder;
            float frontier_phi_8_13_ladder_19_ladder_1;
            float frontier_phi_8_13_ladder_19_ladder_2;
            if (_460 == 1u)
            {
                float _773 = mad(0.043306000530719757080078125f, _529, mad(0.329291999340057373046875f, _528, _527 * 0.627402007579803466796875f));
                float _779 = mad(0.011359999887645244598388671875f, _529, mad(0.9195439815521240234375f, _528, _527 * 0.06909500062465667724609375f));
                float _785 = mad(0.89557802677154541015625f, _529, mad(0.08802799880504608154296875f, _528, _527 * 0.0163940005004405975341796875f));
                float _821 = exp2(log2(abs((((clamp(mad(_785, _38_m0[22u].z, mad(_779, _38_m0[22u].y, _773 * _38_m0[22u].x)), 0.0f, 1.0f) - _773) * _38_m0[16u].x) + _773) * _38_m0[14u].x)) * 0.1593017578125f);
                float _822 = exp2(log2(abs((((clamp(mad(_785, _38_m0[23u].z, mad(_779, _38_m0[23u].y, _773 * _38_m0[23u].x)), 0.0f, 1.0f) - _779) * _38_m0[16u].x) + _779) * _38_m0[14u].x)) * 0.1593017578125f);
                float _823 = exp2(log2(abs((((clamp(mad(_785, _38_m0[24u].z, mad(_779, _38_m0[24u].y, _773 * _38_m0[24u].x)), 0.0f, 1.0f) - _785) * _38_m0[16u].x) + _785) * _38_m0[14u].x)) * 0.1593017578125f);
                frontier_phi_8_13_ladder_19_ladder = exp2(log2(abs(((_821 * 18.8515625f) + 0.8359375f) / ((_821 * 18.6875f) + 1.0f))) * 78.84375f);
                frontier_phi_8_13_ladder_19_ladder_1 = exp2(log2(abs(((_822 * 18.8515625f) + 0.8359375f) / ((_822 * 18.6875f) + 1.0f))) * 78.84375f);
                frontier_phi_8_13_ladder_19_ladder_2 = exp2(log2(abs(((_823 * 18.8515625f) + 0.8359375f) / ((_823 * 18.6875f) + 1.0f))) * 78.84375f);
            }
            else
            {
                float frontier_phi_8_13_ladder_19_ladder_23_ladder;
                float frontier_phi_8_13_ladder_19_ladder_23_ladder_1;
                float frontier_phi_8_13_ladder_19_ladder_23_ladder_2;
                if (_460 == 2u)
                {
                    frontier_phi_8_13_ladder_19_ladder_23_ladder = _527 * _38_m0[14u].x;
                    frontier_phi_8_13_ladder_19_ladder_23_ladder_1 = _528 * _38_m0[14u].x;
                    frontier_phi_8_13_ladder_19_ladder_23_ladder_2 = _529 * _38_m0[14u].x;
                }
                else
                {
                    float frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder;
                    float frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_1;
                    float frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_2;
                    if (_460 == 3u)
                    {
                        float _936 = mad(_529, _38_m0[22u].z, mad(_528, _38_m0[22u].y, _527 * _38_m0[22u].x)) * _38_m0[14u].x;
                        float _937 = mad(_529, _38_m0[23u].z, mad(_528, _38_m0[23u].y, _527 * _38_m0[23u].x)) * _38_m0[14u].x;
                        float _938 = mad(_529, _38_m0[24u].z, mad(_528, _38_m0[24u].y, _527 * _38_m0[24u].x)) * _38_m0[14u].x;
                        float _963 = (_936 <= 0.003130800090730190277099609375f) ? (_936 * 12.9200000762939453125f) : ((exp2(log2(abs(_936)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
                        float _964 = (_937 <= 0.003130800090730190277099609375f) ? (_937 * 12.9200000762939453125f) : ((exp2(log2(abs(_937)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
                        float _965 = (_938 <= 0.003130800090730190277099609375f) ? (_938 * 12.9200000762939453125f) : ((exp2(log2(abs(_938)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
                        float _966 = _963 * 2046.0f;
                        float _968 = _964 * 2046.0f;
                        float _969 = _965 * 2046.0f;
                        frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder = (((_559 + (-0.5f)) + (min(min(1.0f, _966), 2046.0f - _966) * (_582 + (-0.5f)))) * 0.000977517105638980865478515625f) + _963;
                        frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_1 = (((_560 + (-0.5f)) + (min(min(1.0f, _968), 2046.0f - _968) * (_583 + (-0.5f)))) * 0.000977517105638980865478515625f) + _964;
                        frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_2 = (((_561 + (-0.5f)) + (min(min(1.0f, _969), 2046.0f - _969) * (_584 + (-0.5f)))) * 0.000977517105638980865478515625f) + _965;
                    }
                    else
                    {
                        frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder = (_527 * _38_m0[14u].x) + _38_m0[14u].y;
                        frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_1 = (_528 * _38_m0[14u].x) + _38_m0[14u].y;
                        frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_2 = (_529 * _38_m0[14u].x) + _38_m0[14u].y;
                    }
                    frontier_phi_8_13_ladder_19_ladder_23_ladder = frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder;
                    frontier_phi_8_13_ladder_19_ladder_23_ladder_1 = frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_1;
                    frontier_phi_8_13_ladder_19_ladder_23_ladder_2 = frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_2;
                }
                frontier_phi_8_13_ladder_19_ladder = frontier_phi_8_13_ladder_19_ladder_23_ladder;
                frontier_phi_8_13_ladder_19_ladder_1 = frontier_phi_8_13_ladder_19_ladder_23_ladder_1;
                frontier_phi_8_13_ladder_19_ladder_2 = frontier_phi_8_13_ladder_19_ladder_23_ladder_2;
            }
            frontier_phi_8_13_ladder = frontier_phi_8_13_ladder_19_ladder;
            frontier_phi_8_13_ladder_1 = frontier_phi_8_13_ladder_19_ladder_1;
            frontier_phi_8_13_ladder_2 = frontier_phi_8_13_ladder_19_ladder_2;
        }
        _412 = frontier_phi_8_13_ladder;
        _418 = frontier_phi_8_13_ladder_1;
        _424 = frontier_phi_8_13_ladder_2;
    }
    float _462;
    float _468;
    float _474;
    if (asuint(_38_m0[15u]).x == 0u)
    {
        _462 = _311;
        _468 = _313;
        _474 = _315;
    }
    else
    {
        uint _513 = _382.w;
        float _600;
        float _601;
        float _602;
        if (_38_m0[15u].w != 1.0f)
        {
            _600 = exp2(log2(abs(_311)) * _38_m0[15u].w);
            _601 = exp2(log2(abs(_313)) * _38_m0[15u].w);
            _602 = exp2(log2(abs(_315)) * _38_m0[15u].w);
        }
        else
        {
            _600 = _311;
            _601 = _313;
            _602 = _315;
        }
        float _609 = frac(_97 * 211.1488037109375f);
        float _610 = frac(_98 * 210.944000244140625f);
        float _611 = frac(_29_m0[0u].x * 6.227200031280517578125f);
        float _614 = _611 + 33.3300018310546875f;
        float _615 = dot(float3(_609, _610, _611), float3(_610 + 33.3300018310546875f, _609 + 33.3300018310546875f, _614));
        float _618 = _615 + _609;
        float _619 = _615 + _610;
        float _621 = _618 + _619;
        float _626 = frac(_621 * (_615 + _611));
        float _627 = frac((_618 * 2.0f) * _619);
        float _628 = frac(_621 * _618);
        float _633 = frac((_97 + 64.0f) * 211.1488037109375f);
        float _634 = frac((_98 + 64.0f) * 210.944000244140625f);
        float _637 = dot(float3(_633, _634, _611), float3(_634 + 33.3300018310546875f, _633 + 33.3300018310546875f, _614));
        float _640 = _637 + _633;
        float _641 = _637 + _634;
        float _643 = _640 + _641;
        float _648 = frac(_643 * (_637 + _611));
        float _649 = frac((_640 * 2.0f) * _641);
        float _650 = frac(_643 * _640);
        float frontier_phi_10_17_ladder;
        float frontier_phi_10_17_ladder_1;
        float frontier_phi_10_17_ladder_2;
        if (_513 == 0u)
        {
            float _738 = (_600 <= 0.003130800090730190277099609375f) ? (_600 * 12.9200000762939453125f) : ((exp2(log2(abs(_600)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _739 = (_601 <= 0.003130800090730190277099609375f) ? (_601 * 12.9200000762939453125f) : ((exp2(log2(abs(_601)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _740 = (_602 <= 0.003130800090730190277099609375f) ? (_602 * 12.9200000762939453125f) : ((exp2(log2(abs(_602)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _741 = _738 * 510.0f;
            float _742 = _739 * 510.0f;
            float _743 = _740 * 510.0f;
            frontier_phi_10_17_ladder = (((_626 + (-0.5f)) + (min(min(1.0f, _741), 510.0f - _741) * (_648 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _738;
            frontier_phi_10_17_ladder_1 = (((_627 + (-0.5f)) + (min(min(1.0f, _742), 510.0f - _742) * (_649 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _739;
            frontier_phi_10_17_ladder_2 = (((_628 + (-0.5f)) + (min(min(1.0f, _743), 510.0f - _743) * (_650 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _740;
        }
        else
        {
            float frontier_phi_10_17_ladder_21_ladder;
            float frontier_phi_10_17_ladder_21_ladder_1;
            float frontier_phi_10_17_ladder_21_ladder_2;
            if (_513 == 1u)
            {
                float _856 = mad(0.043306000530719757080078125f, _602, mad(0.329291999340057373046875f, _601, _600 * 0.627402007579803466796875f));
                float _859 = mad(0.011359999887645244598388671875f, _602, mad(0.9195439815521240234375f, _601, _600 * 0.06909500062465667724609375f));
                float _862 = mad(0.89557802677154541015625f, _602, mad(0.08802799880504608154296875f, _601, _600 * 0.0163940005004405975341796875f));
                float _896 = exp2(log2(abs((((clamp(mad(_862, _38_m0[26u].z, mad(_859, _38_m0[26u].y, _856 * _38_m0[26u].x)), 0.0f, 1.0f) - _856) * _38_m0[16u].x) + _856) * _38_m0[15u].y)) * 0.1593017578125f);
                float _897 = exp2(log2(abs((((clamp(mad(_862, _38_m0[27u].z, mad(_859, _38_m0[27u].y, _856 * _38_m0[27u].x)), 0.0f, 1.0f) - _859) * _38_m0[16u].x) + _859) * _38_m0[15u].y)) * 0.1593017578125f);
                float _898 = exp2(log2(abs((((clamp(mad(_862, _38_m0[28u].z, mad(_859, _38_m0[28u].y, _856 * _38_m0[28u].x)), 0.0f, 1.0f) - _862) * _38_m0[16u].x) + _862) * _38_m0[15u].y)) * 0.1593017578125f);
                frontier_phi_10_17_ladder_21_ladder = exp2(log2(abs(((_896 * 18.8515625f) + 0.8359375f) / ((_896 * 18.6875f) + 1.0f))) * 78.84375f);
                frontier_phi_10_17_ladder_21_ladder_1 = exp2(log2(abs(((_897 * 18.8515625f) + 0.8359375f) / ((_897 * 18.6875f) + 1.0f))) * 78.84375f);
                frontier_phi_10_17_ladder_21_ladder_2 = exp2(log2(abs(((_898 * 18.8515625f) + 0.8359375f) / ((_898 * 18.6875f) + 1.0f))) * 78.84375f);
            }
            else
            {
                float frontier_phi_10_17_ladder_21_ladder_25_ladder;
                float frontier_phi_10_17_ladder_21_ladder_25_ladder_1;
                float frontier_phi_10_17_ladder_21_ladder_25_ladder_2;
                if (_513 == 2u)
                {
                    frontier_phi_10_17_ladder_21_ladder_25_ladder = _600 * _38_m0[15u].y;
                    frontier_phi_10_17_ladder_21_ladder_25_ladder_1 = _601 * _38_m0[15u].y;
                    frontier_phi_10_17_ladder_21_ladder_25_ladder_2 = _602 * _38_m0[15u].y;
                }
                else
                {
                    float frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder;
                    float frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_1;
                    float frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_2;
                    if (_513 == 3u)
                    {
                        float _1007 = mad(_602, _38_m0[26u].z, mad(_601, _38_m0[26u].y, _600 * _38_m0[26u].x)) * _38_m0[15u].y;
                        float _1008 = mad(_602, _38_m0[27u].z, mad(_601, _38_m0[27u].y, _600 * _38_m0[27u].x)) * _38_m0[15u].y;
                        float _1009 = mad(_602, _38_m0[28u].z, mad(_601, _38_m0[28u].y, _600 * _38_m0[28u].x)) * _38_m0[15u].y;
                        float _1034 = (_1007 <= 0.003130800090730190277099609375f) ? (_1007 * 12.9200000762939453125f) : ((exp2(log2(abs(_1007)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
                        float _1035 = (_1008 <= 0.003130800090730190277099609375f) ? (_1008 * 12.9200000762939453125f) : ((exp2(log2(abs(_1008)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
                        float _1036 = (_1009 <= 0.003130800090730190277099609375f) ? (_1009 * 12.9200000762939453125f) : ((exp2(log2(abs(_1009)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
                        float _1037 = _1034 * 2046.0f;
                        float _1038 = _1035 * 2046.0f;
                        float _1039 = _1036 * 2046.0f;
                        frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder = (((_626 + (-0.5f)) + (min(min(1.0f, _1037), 2046.0f - _1037) * (_648 + (-0.5f)))) * 0.000977517105638980865478515625f) + _1034;
                        frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_1 = (((_627 + (-0.5f)) + (min(min(1.0f, _1038), 2046.0f - _1038) * (_649 + (-0.5f)))) * 0.000977517105638980865478515625f) + _1035;
                        frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_2 = (((_628 + (-0.5f)) + (min(min(1.0f, _1039), 2046.0f - _1039) * (_650 + (-0.5f)))) * 0.000977517105638980865478515625f) + _1036;
                    }
                    else
                    {
                        frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder = (_600 * _38_m0[15u].y) + _38_m0[15u].z;
                        frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_1 = (_601 * _38_m0[15u].y) + _38_m0[15u].z;
                        frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_2 = (_602 * _38_m0[15u].y) + _38_m0[15u].z;
                    }
                    frontier_phi_10_17_ladder_21_ladder_25_ladder = frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder;
                    frontier_phi_10_17_ladder_21_ladder_25_ladder_1 = frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_1;
                    frontier_phi_10_17_ladder_21_ladder_25_ladder_2 = frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_2;
                }
                frontier_phi_10_17_ladder_21_ladder = frontier_phi_10_17_ladder_21_ladder_25_ladder;
                frontier_phi_10_17_ladder_21_ladder_1 = frontier_phi_10_17_ladder_21_ladder_25_ladder_1;
                frontier_phi_10_17_ladder_21_ladder_2 = frontier_phi_10_17_ladder_21_ladder_25_ladder_2;
            }
            frontier_phi_10_17_ladder = frontier_phi_10_17_ladder_21_ladder;
            frontier_phi_10_17_ladder_1 = frontier_phi_10_17_ladder_21_ladder_1;
            frontier_phi_10_17_ladder_2 = frontier_phi_10_17_ladder_21_ladder_2;
        }
        _462 = frontier_phi_10_17_ladder;
        _468 = frontier_phi_10_17_ladder_1;
        _474 = frontier_phi_10_17_ladder_2;
    }
    _22[uint2(_82, _83)] = float4(_412, _418, _424, 1.0f);
    if (!(asuint(_38_m0[15u]).x == 0u))
    {
        _23[uint2(_82, _83)] = float4(_462, _468, _474, 1.0f);
    }
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
