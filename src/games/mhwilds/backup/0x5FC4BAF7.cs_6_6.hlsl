cbuffer SceneInfoUBO : register(b0, space0)
{
    float4 SceneInfo_m0[39] : packoffset(c0);
};

cbuffer EnvironmentInfoUBO : register(b1, space0)
{
    float4 EnvironmentInfo_m0[324] : packoffset(c0);
};

cbuffer HDRMappingUBO : register(b2, space0)
{
    float4 HDRMapping_m0[15] : packoffset(c0);
};

cbuffer GUIConstantUBO : register(b3, space0)
{
    float4 GUIConstant_m0[18] : packoffset(c0);
};

cbuffer UserMaterialUBO : register(b4, space0)
{
    float4 UserMaterial_m0[2] : packoffset(c0);
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
    uint _58 = uint(gl_LocalInvocationID.x);
    uint _61 = _58 >> 1u;
    uint _65 = _58 >> 2u;
    uint _69 = _58 >> 3u;
    uint _80 = ((((_58 & 1u) | (uint(gl_WorkGroupID.x) << 4u)) | (_61 & 2u)) | (_65 & 4u)) | (_69 & 8u);
    uint _85 = ((((_61 & 1u) | (uint(gl_WorkGroupID.y) << 4u)) | (_65 & 2u)) | (_69 & 4u)) | ((_58 >> 4u) & 8u);
    float _97 = (float(_80) + 0.5f) * SceneInfo_m0[23u].z;
    float _98 = (float(_85) + 0.5f) * SceneInfo_m0[23u].w;
    bool _106 = abs(UserMaterial_m0[1u].x) > 0.0f;
    float _118;
    if (_106)
    {
        _118 = frac((UserMaterial_m0[1u].x * 0.001000000047497451305389404296875f) * float(asuint(EnvironmentInfo_m0[0u]).x));
    }
    else
    {
        _118 = 0.0f;
    }
    float _127;
    if (_106)
    {
        _127 = frac((UserMaterial_m0[1u].x * 0.001000000047497451305389404296875f) * float(asuint(EnvironmentInfo_m0[0u]).x));
    }
    else
    {
        _127 = 0.0f;
    }
    float _143 = (Tex2D_0.SampleLevel(BilinearWrap, float2(_118 + (_97 * UserMaterial_m0[1u].y), _127 + (_98 * UserMaterial_m0[1u].y)), 0.0f).x + (-0.5f)) * UserMaterial_m0[1u].z;
    float _149 = ((_143 + _97) * 2.0f) + (-1.0f);
    float _151 = ((_143 + _98) * 2.0f) + (-1.0f);
    float _155 = sqrt((_149 * _149) + (_151 * _151));
    float _175 = sin(((frac(float(asuint(EnvironmentInfo_m0[0u]).x) / UserMaterial_m0[0u].z) * (-6.280000209808349609375f)) - UserMaterial_m0[0u].w) + (UserMaterial_m0[0u].y * _155));
    float _179;
    if (UserMaterial_m0[0u].x > 0.0f)
    {
        _179 = abs(_175);
    }
    else
    {
        _179 = _175;
    }
    float _182 = clamp(1.0f - _155, 0.0f, 1.0f) * clamp(_179, 0.0f, 1.0f);
    float _196;
    if (_182 > 0.0f)
    {
        _196 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _182)) + _182);
    }
    else
    {
        _196 = 1.0f;
    }
    bool _199 = max(max(_196, _196), _196) == 0.0f;
    bool _200 = _182 == 0.0f;
    if (!(_200 && _199))
    {
        float _208;
        float _210;
        float _212;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _208 = _196;
            _210 = _196;
            _212 = _196;
        }
        else
        {
            float _241 = exp2(log2(mad(0.0810546875f, _196, mad(0.623046875f, _196, _196 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _254 = clamp(exp2(log2(((_241 * 18.8515625f) + 0.8359375f) / ((_241 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _258 = exp2(log2(mad(0.116455078125f, _196, mad(0.727294921875f, _196, _196 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _267 = clamp(exp2(log2(((_258 * 18.8515625f) + 0.8359375f) / ((_258 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _271 = exp2(log2(mad(0.808349609375f, _196, mad(0.156494140625f, _196, _196 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _280 = clamp(exp2(log2(((_271 * 18.8515625f) + 0.8359375f) / ((_271 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _282 = (_267 + _254) * 0.5f;
            float _303 = exp2(log2(clamp(_282, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _314 = exp2(log2(max(0.0f, _303 + (-0.8359375f)) / (18.8515625f - (_303 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _328 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _314) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _182) * _314) + 1.0f)) * 0.1593017578125f);
            float _337 = clamp(exp2(log2(((_328 * 18.8515625f) + 0.8359375f) / ((_328 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _340 = min(_282 / _337, _337 / _282);
            float _341 = ((dot(float3(_254, _267, _280), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _340;
            float _342 = ((dot(float3(_254, _267, _280), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _340;
            float _358 = exp2(log2(clamp(mad(0.111000001430511474609375f, _342, mad(0.0089999996125698089599609375f, _341, _337)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _366 = exp2(log2(max(0.0f, _358 + (-0.8359375f)) / (18.8515625f - (_358 * 18.6875f))) * 6.277394771575927734375f);
            float _370 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _342, mad(-0.0089999996125698089599609375f, _341, _337)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _379 = exp2(log2(max(0.0f, _370 + (-0.8359375f)) / (18.8515625f - (_370 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _383 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _342, mad(0.560000002384185791015625f, _341, _337)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _392 = exp2(log2(max(0.0f, _383 + (-0.8359375f)) / (18.8515625f - (_383 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _397 = mad(0.20700000226497650146484375f, _392, mad(-1.32700002193450927734375f, _379, _366 * 207.100006103515625f));
            float _403 = mad(-0.04500000178813934326171875f, _392, mad(0.6809999942779541015625f, _379, _366 * 36.5f));
            float _409 = mad(1.1879999637603759765625f, _392, mad(-0.0500000007450580596923828125f, _379, _366 * (-4.900000095367431640625f)));
            _208 = mad(-0.498610794544219970703125f, _409, mad(-1.53738319873809814453125f, _403, _397 * 3.2409698963165283203125f));
            _210 = mad(0.0415550954639911651611328125f, _409, mad(1.8759677410125732421875f, _403, _397 * (-0.969243705272674560546875f)));
            _212 = mad(1.05697143077850341796875f, _409, mad(-0.2039768397808074951171875f, _403, _397 * 0.0556300692260265350341796875f));
        }
        float _523;
        float _527;
        float _531;
        if (_182 == 1.0f)
        {
            float _434 = mad(0.043313600122928619384765625f, _212, mad(0.329281985759735107421875f, _210, _208 * 0.6274039745330810546875f));
            float _440 = mad(0.0113612003624439239501953125f, _212, mad(0.919539988040924072265625f, _210, _208 * 0.06909699738025665283203125f));
            float _446 = mad(0.895595014095306396484375f, _212, mad(0.0880132019519805908203125f, _210, _208 * 0.01639159955084323883056640625f));
            float _473 = 10000.0f / HDRMapping_m0[10u].y;
            float _483 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_208 - _434)) + _434) * HDRMapping_m0[7u].y) / _473, 0.0f, 1.0f)) * 0.1593017578125f);
            float _492 = clamp(exp2(log2(((_483 * 18.8515625f) + 0.8359375f) / ((_483 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _495 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_210 - _440)) + _440) * HDRMapping_m0[7u].y) / _473, 0.0f, 1.0f)) * 0.1593017578125f);
            float _504 = clamp(exp2(log2(((_495 * 18.8515625f) + 0.8359375f) / ((_495 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _507 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_212 - _446)) + _446) * HDRMapping_m0[7u].y) / _473, 0.0f, 1.0f)) * 0.1593017578125f);
            float _516 = clamp(exp2(log2(((_507 * 18.8515625f) + 0.8359375f) / ((_507 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_15_13_ladder;
            float frontier_phi_15_13_ladder_1;
            float frontier_phi_15_13_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_15_13_ladder = _492;
                frontier_phi_15_13_ladder_1 = _504;
                frontier_phi_15_13_ladder_2 = _516;
            }
            else
            {
                float _549 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _558 = clamp(exp2(log2(((_549 * 18.8515625f) + 0.8359375f) / ((_549 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _564 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _574 = _558 - clamp(exp2(log2(((_564 * 18.8515625f) + 0.8359375f) / ((_564 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _578 = clamp(_492 / _558, 0.0f, 1.0f);
                float _579 = clamp(_504 / _558, 0.0f, 1.0f);
                float _580 = clamp(_516 / _558, 0.0f, 1.0f);
                frontier_phi_15_13_ladder = min((((2.0f - (_578 + _578)) * _574) + (_578 * _558)) * _578, _492);
                frontier_phi_15_13_ladder_1 = min((((2.0f - (_579 + _579)) * _574) + (_579 * _558)) * _579, _504);
                frontier_phi_15_13_ladder_2 = min((((2.0f - (_580 + _580)) * _574) + (_580 * _558)) * _580, _516);
            }
            _523 = frontier_phi_15_13_ladder;
            _527 = frontier_phi_15_13_ladder_1;
            _531 = frontier_phi_15_13_ladder_2;
        }
        else
        {
            bool _600;
            if (_200)
            {
                _600 = !_199;
            }
            else
            {
                _600 = false;
            }
            float4 _605 = RWResult[uint2(uint(_80), uint(_85))].xxxx;
            float _619 = exp2(log2(clamp(_605.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _620 = exp2(log2(clamp(_605.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _621 = exp2(log2(clamp(_605.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _649 = 10000.0f / HDRMapping_m0[10u].y;
            float _650 = _649 * exp2(log2(max(0.0f, _619 + (-0.8359375f)) / (18.8515625f - (_619 * 18.6875f))) * 6.277394771575927734375f);
            float _651 = _649 * exp2(log2(max(0.0f, _620 + (-0.8359375f)) / (18.8515625f - (_620 * 18.6875f))) * 6.277394771575927734375f);
            float _652 = _649 * exp2(log2(max(0.0f, _621 + (-0.8359375f)) / (18.8515625f - (_621 * 18.6875f))) * 6.277394771575927734375f);
            float _657 = mad(-0.07285170257091522216796875f, _652, mad(-0.587639987468719482421875f, _651, _650 * 1.66049098968505859375f));
            float _663 = mad(-0.008348000235855579376220703125f, _652, mad(1.1328999996185302734375f, _651, _650 * (-0.12454999983310699462890625f)));
            float _669 = mad(1.11872994899749755859375f, _652, mad(-0.100579001009464263916015625f, _651, _650 * (-0.01815100014209747314453125f)));
            float _671;
            float _673;
            float _675;
            if (_600)
            {
                _671 = _208;
                _673 = _210;
                _675 = _212;
            }
            else
            {
                _671 = (_208 - _657) * _182;
                _673 = (_210 - _663) * _182;
                _675 = (_212 - _669) * _182;
            }
            float _677 = _671 + _657;
            float _678 = _673 + _663;
            float _679 = _675 + _669;
            float _682 = mad(0.043313600122928619384765625f, _679, mad(0.329281985759735107421875f, _678, _677 * 0.6274039745330810546875f));
            float _685 = mad(0.0113612003624439239501953125f, _679, mad(0.919539988040924072265625f, _678, _677 * 0.06909699738025665283203125f));
            float _688 = mad(0.895595014095306396484375f, _679, mad(0.0880132019519805908203125f, _678, _677 * 0.01639159955084323883056640625f));
            float _721 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_677 - _682)) + _682) * HDRMapping_m0[7u].y) / _649, 0.0f, 1.0f)) * 0.1593017578125f);
            float _526 = clamp(exp2(log2(((_721 * 18.8515625f) + 0.8359375f) / ((_721 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _732 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_678 - _685)) + _685) * HDRMapping_m0[7u].y) / _649, 0.0f, 1.0f)) * 0.1593017578125f);
            float _530 = clamp(exp2(log2(((_732 * 18.8515625f) + 0.8359375f) / ((_732 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _743 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_679 - _688)) + _688) * HDRMapping_m0[7u].y) / _649, 0.0f, 1.0f)) * 0.1593017578125f);
            float _534 = clamp(exp2(log2(((_743 * 18.8515625f) + 0.8359375f) / ((_743 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_15_19_ladder;
            float frontier_phi_15_19_ladder_1;
            float frontier_phi_15_19_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_15_19_ladder = _526;
                frontier_phi_15_19_ladder_1 = _530;
                frontier_phi_15_19_ladder_2 = _534;
            }
            else
            {
                float _768 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _777 = clamp(exp2(log2(((_768 * 18.8515625f) + 0.8359375f) / ((_768 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _783 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _793 = _777 - clamp(exp2(log2(((_783 * 18.8515625f) + 0.8359375f) / ((_783 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _797 = clamp(_526 / _777, 0.0f, 1.0f);
                float _798 = clamp(_530 / _777, 0.0f, 1.0f);
                float _799 = clamp(_534 / _777, 0.0f, 1.0f);
                frontier_phi_15_19_ladder = min((((2.0f - (_797 + _797)) * _793) + (_797 * _777)) * _797, _526);
                frontier_phi_15_19_ladder_1 = min((((2.0f - (_798 + _798)) * _793) + (_798 * _777)) * _798, _530);
                frontier_phi_15_19_ladder_2 = min((((2.0f - (_799 + _799)) * _793) + (_799 * _777)) * _799, _534);
            }
            _523 = frontier_phi_15_19_ladder;
            _527 = frontier_phi_15_19_ladder_1;
            _531 = frontier_phi_15_19_ladder_2;
        }
        RWResult[uint2(uint(_80), uint(_85))] = float4(_523, _527, _531, _523).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
