cbuffer SceneInfoUBO : register(b0, space0)
{
    float4 SceneInfo_m0[39] : packoffset(c0);
};

cbuffer HDRMappingUBO : register(b1, space0)
{
    float4 HDRMapping_m0[15] : packoffset(c0);
};

cbuffer GUIConstantUBO : register(b2, space0)
{
    float4 GUIConstant_m0[18] : packoffset(c0);
};

cbuffer UserMaterialUBO : register(b3, space0)
{
    float4 UserMaterial_m0[6] : packoffset(c0);
};

Texture2D<float4> Tex2D_0 : register(t0, space0);
RWTexture2D<float> RWResult : register(u0, space0);
SamplerState BilinearWrap : register(s4, space32);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main()
{
    uint _53 = uint(gl_LocalInvocationID.x);
    uint _56 = _53 >> 1u;
    uint _60 = _53 >> 2u;
    uint _64 = _53 >> 3u;
    uint _75 = ((((_53 & 1u) | (uint(gl_WorkGroupID.x) << 4u)) | (_56 & 2u)) | (_60 & 4u)) | (_64 & 8u);
    uint _80 = ((((_56 & 1u) | (uint(gl_WorkGroupID.y) << 4u)) | (_60 & 2u)) | (_64 & 4u)) | ((_53 >> 4u) & 8u);
    float4 _106 = Tex2D_0.SampleLevel(BilinearWrap, float2((UserMaterial_m0[4u].x * SceneInfo_m0[23u].z) * (float(_75) + 0.5f), (UserMaterial_m0[4u].y * SceneInfo_m0[23u].w) * (float(_80) + 0.5f)), 0.0f);
    float _125 = clamp(UserMaterial_m0[0u].x, 0.0f, 1.0f) * _106.x;
    float _131 = ((clamp(UserMaterial_m0[0u].y, 0.0f, 1.0f) * _106.y) * (1.0f - _125)) + _125;
    float _141 = UserMaterial_m0[3u].x + 1.0f;
    float _144 = ((clamp(UserMaterial_m0[0u].z, 0.0f, 1.0f) * _106.z) * (1.0f - _131)) + _131;
    float _145 = _141 * (1.0f - UserMaterial_m0[5u].x);
    float _147 = UserMaterial_m0[5u].y * _141;
    float _150 = ((clamp(UserMaterial_m0[0u].w, 0.0f, 1.0f) * _106.w) * (1.0f - _144)) + _144;
    float _151 = _145 - UserMaterial_m0[3u].x;
    float _152 = _147 - UserMaterial_m0[3u].x;
    float _161 = clamp((_150 - _151) / (((_151 == _145) ? (_151 + 9.9999997473787516355514526367188e-05f) : _145) - _151), 0.0f, 1.0f);
    float _172 = clamp((_150 - _147) / (((_147 == _152) ? (_147 + 9.9999997473787516355514526367188e-05f) : _152) - _147), 0.0f, 1.0f);
    precise float _175 = _161 * _172;
    precise float _176 = _175 * _175;
    float _178 = ((3.0f - (_172 * 2.0f)) * (3.0f - (_161 * 2.0f))) * _176;
    float _181 = (UserMaterial_m0[3u].y < _178) ? 0.0f : 1.0f;
    float _199 = (_181 * (UserMaterial_m0[2u].x - UserMaterial_m0[1u].x)) + UserMaterial_m0[1u].x;
    float _200 = (_181 * (UserMaterial_m0[2u].y - UserMaterial_m0[1u].y)) + UserMaterial_m0[1u].y;
    float _201 = (_181 * (UserMaterial_m0[2u].z - UserMaterial_m0[1u].z)) + UserMaterial_m0[1u].z;
    float _219;
    float _220;
    float _221;
    if (_178 > 0.0f)
    {
        float _215 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _178)) + _178);
        _219 = _215 * _199;
        _220 = _215 * _200;
        _221 = _215 * _201;
    }
    else
    {
        _219 = _199;
        _220 = _200;
        _221 = _201;
    }
    bool _224 = max(max(_219, _220), _221) == 0.0f;
    bool _225 = _178 == 0.0f;
    if (!(_225 && _224))
    {
        float _233;
        float _235;
        float _237;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _233 = _219;
            _235 = _220;
            _237 = _221;
        }
        else
        {
            float _266 = exp2(log2(mad(0.0810546875f, _221, mad(0.623046875f, _220, _219 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _279 = clamp(exp2(log2(((_266 * 18.8515625f) + 0.8359375f) / ((_266 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _283 = exp2(log2(mad(0.116455078125f, _221, mad(0.727294921875f, _220, _219 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _292 = clamp(exp2(log2(((_283 * 18.8515625f) + 0.8359375f) / ((_283 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _296 = exp2(log2(mad(0.808349609375f, _221, mad(0.156494140625f, _220, _219 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _305 = clamp(exp2(log2(((_296 * 18.8515625f) + 0.8359375f) / ((_296 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _307 = (_292 + _279) * 0.5f;
            float _328 = exp2(log2(clamp(_307, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _339 = exp2(log2(max(0.0f, _328 + (-0.8359375f)) / (18.8515625f - (_328 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _354 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _339) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _178) * _339) + 1.0f)) * 0.1593017578125f);
            float _363 = clamp(exp2(log2(((_354 * 18.8515625f) + 0.8359375f) / ((_354 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _366 = min(_307 / _363, _363 / _307);
            float _367 = ((dot(float3(_279, _292, _305), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _366;
            float _368 = ((dot(float3(_279, _292, _305), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _366;
            float _384 = exp2(log2(clamp(mad(0.111000001430511474609375f, _368, mad(0.0089999996125698089599609375f, _367, _363)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _392 = exp2(log2(max(0.0f, _384 + (-0.8359375f)) / (18.8515625f - (_384 * 18.6875f))) * 6.277394771575927734375f);
            float _396 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _368, mad(-0.0089999996125698089599609375f, _367, _363)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _405 = exp2(log2(max(0.0f, _396 + (-0.8359375f)) / (18.8515625f - (_396 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _409 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _368, mad(0.560000002384185791015625f, _367, _363)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _418 = exp2(log2(max(0.0f, _409 + (-0.8359375f)) / (18.8515625f - (_409 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _423 = mad(0.20700000226497650146484375f, _418, mad(-1.32700002193450927734375f, _405, _392 * 207.100006103515625f));
            float _429 = mad(-0.04500000178813934326171875f, _418, mad(0.6809999942779541015625f, _405, _392 * 36.5f));
            float _435 = mad(1.1879999637603759765625f, _418, mad(-0.0500000007450580596923828125f, _405, _392 * (-4.900000095367431640625f)));
            _233 = mad(-0.498610794544219970703125f, _435, mad(-1.53738319873809814453125f, _429, _423 * 3.2409698963165283203125f));
            _235 = mad(0.0415550954639911651611328125f, _435, mad(1.8759677410125732421875f, _429, _423 * (-0.969243705272674560546875f)));
            _237 = mad(1.05697143077850341796875f, _435, mad(-0.2039768397808074951171875f, _429, _423 * 0.0556300692260265350341796875f));
        }
        float _549;
        float _553;
        float _557;
        if (_178 == 1.0f)
        {
            float _460 = mad(0.043313600122928619384765625f, _237, mad(0.329281985759735107421875f, _235, _233 * 0.6274039745330810546875f));
            float _466 = mad(0.0113612003624439239501953125f, _237, mad(0.919539988040924072265625f, _235, _233 * 0.06909699738025665283203125f));
            float _472 = mad(0.895595014095306396484375f, _237, mad(0.0880132019519805908203125f, _235, _233 * 0.01639159955084323883056640625f));
            float _499 = 10000.0f / HDRMapping_m0[10u].y;
            float _509 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_233 - _460)) + _460) * HDRMapping_m0[7u].y) / _499, 0.0f, 1.0f)) * 0.1593017578125f);
            float _518 = clamp(exp2(log2(((_509 * 18.8515625f) + 0.8359375f) / ((_509 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _521 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_235 - _466)) + _466) * HDRMapping_m0[7u].y) / _499, 0.0f, 1.0f)) * 0.1593017578125f);
            float _530 = clamp(exp2(log2(((_521 * 18.8515625f) + 0.8359375f) / ((_521 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _533 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_237 - _472)) + _472) * HDRMapping_m0[7u].y) / _499, 0.0f, 1.0f)) * 0.1593017578125f);
            float _542 = clamp(exp2(log2(((_533 * 18.8515625f) + 0.8359375f) / ((_533 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_7_ladder;
            float frontier_phi_9_7_ladder_1;
            float frontier_phi_9_7_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_7_ladder = _518;
                frontier_phi_9_7_ladder_1 = _530;
                frontier_phi_9_7_ladder_2 = _542;
            }
            else
            {
                float _574 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _583 = clamp(exp2(log2(((_574 * 18.8515625f) + 0.8359375f) / ((_574 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _589 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _599 = _583 - clamp(exp2(log2(((_589 * 18.8515625f) + 0.8359375f) / ((_589 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _603 = clamp(_518 / _583, 0.0f, 1.0f);
                float _604 = clamp(_530 / _583, 0.0f, 1.0f);
                float _605 = clamp(_542 / _583, 0.0f, 1.0f);
                frontier_phi_9_7_ladder = min((((2.0f - (_603 + _603)) * _599) + (_603 * _583)) * _603, _518);
                frontier_phi_9_7_ladder_1 = min((((2.0f - (_604 + _604)) * _599) + (_604 * _583)) * _604, _530);
                frontier_phi_9_7_ladder_2 = min((((2.0f - (_605 + _605)) * _599) + (_605 * _583)) * _605, _542);
            }
            _549 = frontier_phi_9_7_ladder;
            _553 = frontier_phi_9_7_ladder_1;
            _557 = frontier_phi_9_7_ladder_2;
        }
        else
        {
            bool _625;
            if (_225)
            {
                _625 = !_224;
            }
            else
            {
                _625 = false;
            }
            float4 _630 = RWResult[uint2(uint(_75), uint(_80))].xxxx;
            float _644 = exp2(log2(clamp(_630.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _645 = exp2(log2(clamp(_630.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _646 = exp2(log2(clamp(_630.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _674 = 10000.0f / HDRMapping_m0[10u].y;
            float _675 = _674 * exp2(log2(max(0.0f, _644 + (-0.8359375f)) / (18.8515625f - (_644 * 18.6875f))) * 6.277394771575927734375f);
            float _676 = _674 * exp2(log2(max(0.0f, _645 + (-0.8359375f)) / (18.8515625f - (_645 * 18.6875f))) * 6.277394771575927734375f);
            float _677 = _674 * exp2(log2(max(0.0f, _646 + (-0.8359375f)) / (18.8515625f - (_646 * 18.6875f))) * 6.277394771575927734375f);
            float _682 = mad(-0.07285170257091522216796875f, _677, mad(-0.587639987468719482421875f, _676, _675 * 1.66049098968505859375f));
            float _688 = mad(-0.008348000235855579376220703125f, _677, mad(1.1328999996185302734375f, _676, _675 * (-0.12454999983310699462890625f)));
            float _694 = mad(1.11872994899749755859375f, _677, mad(-0.100579001009464263916015625f, _676, _675 * (-0.01815100014209747314453125f)));
            float _696;
            float _698;
            float _700;
            if (_625)
            {
                _696 = _233;
                _698 = _235;
                _700 = _237;
            }
            else
            {
                _696 = (_233 - _682) * _178;
                _698 = (_235 - _688) * _178;
                _700 = (_237 - _694) * _178;
            }
            float _702 = _696 + _682;
            float _703 = _698 + _688;
            float _704 = _700 + _694;
            float _707 = mad(0.043313600122928619384765625f, _704, mad(0.329281985759735107421875f, _703, _702 * 0.6274039745330810546875f));
            float _710 = mad(0.0113612003624439239501953125f, _704, mad(0.919539988040924072265625f, _703, _702 * 0.06909699738025665283203125f));
            float _713 = mad(0.895595014095306396484375f, _704, mad(0.0880132019519805908203125f, _703, _702 * 0.01639159955084323883056640625f));
            float _746 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_702 - _707)) + _707) * HDRMapping_m0[7u].y) / _674, 0.0f, 1.0f)) * 0.1593017578125f);
            float _552 = clamp(exp2(log2(((_746 * 18.8515625f) + 0.8359375f) / ((_746 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _757 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_703 - _710)) + _710) * HDRMapping_m0[7u].y) / _674, 0.0f, 1.0f)) * 0.1593017578125f);
            float _556 = clamp(exp2(log2(((_757 * 18.8515625f) + 0.8359375f) / ((_757 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _768 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_704 - _713)) + _713) * HDRMapping_m0[7u].y) / _674, 0.0f, 1.0f)) * 0.1593017578125f);
            float _560 = clamp(exp2(log2(((_768 * 18.8515625f) + 0.8359375f) / ((_768 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_13_ladder;
            float frontier_phi_9_13_ladder_1;
            float frontier_phi_9_13_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_13_ladder = _552;
                frontier_phi_9_13_ladder_1 = _556;
                frontier_phi_9_13_ladder_2 = _560;
            }
            else
            {
                float _793 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _802 = clamp(exp2(log2(((_793 * 18.8515625f) + 0.8359375f) / ((_793 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _808 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _818 = _802 - clamp(exp2(log2(((_808 * 18.8515625f) + 0.8359375f) / ((_808 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _822 = clamp(_552 / _802, 0.0f, 1.0f);
                float _823 = clamp(_556 / _802, 0.0f, 1.0f);
                float _824 = clamp(_560 / _802, 0.0f, 1.0f);
                frontier_phi_9_13_ladder = min((((2.0f - (_822 + _822)) * _818) + (_822 * _802)) * _822, _552);
                frontier_phi_9_13_ladder_1 = min((((2.0f - (_823 + _823)) * _818) + (_823 * _802)) * _823, _556);
                frontier_phi_9_13_ladder_2 = min((((2.0f - (_824 + _824)) * _818) + (_824 * _802)) * _824, _560);
            }
            _549 = frontier_phi_9_13_ladder;
            _553 = frontier_phi_9_13_ladder_1;
            _557 = frontier_phi_9_13_ladder_2;
        }
        RWResult[uint2(uint(_75), uint(_80))] = float4(_549, _553, _557, _549).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
