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
    float4 UserMaterial_m0[4] : packoffset(c0);
};

Texture2D<float4> primSceneTex : register(t0, space0);
RWTexture2D<float> RWResult : register(u0, space0);
SamplerState TrilinearClamp : register(s9, space32);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param)
{
    uint2 ret;
    Tex.GetDimensions(Level, ret.x, ret.y, Param);
    return ret;
}

void comp_main()
{
    uint _53 = uint(gl_LocalInvocationID.x);
    uint _56 = _53 >> 1u;
    uint _60 = _53 >> 2u;
    uint _64 = _53 >> 3u;
    uint _75 = ((((_53 & 1u) | (uint(gl_WorkGroupID.x) << 4u)) | (_56 & 2u)) | (_60 & 4u)) | (_64 & 8u);
    uint _80 = ((((_56 & 1u) | (uint(gl_WorkGroupID.y) << 4u)) | (_60 & 2u)) | (_64 & 4u)) | ((_53 >> 4u) & 8u);
    float _83 = float(_75) + 0.5f;
    float _85 = float(_80) + 0.5f;
    float _94 = (SceneInfo_m0[23u].z * 2.0f) * _83;
    float _96 = (SceneInfo_m0[23u].w * 2.0f) * _85;
    float _97 = _94 + (-1.0f);
    float _99 = _96 + (-1.0f);
    float _100 = _94 + (-0.980000019073486328125f);
    float _102 = _96 + (-0.980000019073486328125f);
    float _103 = _94 + (-1.019999980926513671875f);
    float _105 = _96 + (-1.019999980926513671875f);
    float _110 = sqrt((_97 * _97) + (_99 * _99));
    float _123 = UserMaterial_m0[3u].x * (-6.280000209808349609375f);
    float _138 = sin((UserMaterial_m0[0u].x * sqrt((_100 * _100) + (_102 * _102))) + _123) + 0.003921568393707275390625f;
    float _140 = sin((UserMaterial_m0[0u].x * sqrt((_103 * _103) + (_105 * _105))) + _123) + 0.003921568393707275390625f;
    uint _155_dummy_parameter;
    uint2 _155 = spvTextureSize(primSceneTex, 0u, _155_dummy_parameter);
    float _159 = float(int(_155.y));
    float _161 = _159 / SceneInfo_m0[23u].y;
    float _169 = rsqrt(dot(float4(_138, _140, 1.0039215087890625f, -0.996078431606292724609375f), float4(_138, _140, 1.0039215087890625f, -0.996078431606292724609375f)));
    float4 _182 = primSceneTex.SampleLevel(TrilinearClamp, float2((_83 - ((UserMaterial_m0[1u].x * _138) * _169)) * (_161 / float(int(_155.x))), (_85 - ((UserMaterial_m0[1u].x * _140) * _169)) * (_161 / _159)), 0.0f);
    float _194 = clamp((1.0f - _110) * 2.0f, 0.0f, 1.0f);
    float _224 = ((_194 * _194) * (3.0f - (_194 * 2.0f))) * clamp(sin((_110 + 1.0f) - (UserMaterial_m0[3u].y * 3.1400001049041748046875f)), 0.0f, 1.0f);
    float _225 = sin((UserMaterial_m0[0u].x * _110) + _123) * 0.00999999977648258209228515625f;
    float _227 = _225 + max((exp2(log2(_182.x * UserMaterial_m0[2u].x) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
    float _228 = _225 + max((exp2(log2(_182.y * UserMaterial_m0[2u].y) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
    float _229 = _225 + max((exp2(log2(_182.z * UserMaterial_m0[2u].z) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
    float _248;
    float _249;
    float _250;
    if (_224 > 0.0f)
    {
        float _244 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _224)) + _224);
        _248 = _244 * _227;
        _249 = _244 * _228;
        _250 = _244 * _229;
    }
    else
    {
        _248 = _227;
        _249 = _228;
        _250 = _229;
    }
    bool _253 = max(max(_248, _249), _250) == 0.0f;
    bool _254 = _224 == 0.0f;
    if (!(_254 && _253))
    {
        float _262;
        float _264;
        float _266;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _262 = _248;
            _264 = _249;
            _266 = _250;
        }
        else
        {
            float _294 = exp2(log2(mad(0.0810546875f, _250, mad(0.623046875f, _249, _248 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _307 = clamp(exp2(log2(((_294 * 18.8515625f) + 0.8359375f) / ((_294 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _311 = exp2(log2(mad(0.116455078125f, _250, mad(0.727294921875f, _249, _248 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _320 = clamp(exp2(log2(((_311 * 18.8515625f) + 0.8359375f) / ((_311 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _324 = exp2(log2(mad(0.808349609375f, _250, mad(0.156494140625f, _249, _248 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _333 = clamp(exp2(log2(((_324 * 18.8515625f) + 0.8359375f) / ((_324 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _335 = (_320 + _307) * 0.5f;
            float _356 = exp2(log2(clamp(_335, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _367 = exp2(log2(max(0.0f, _356 + (-0.8359375f)) / (18.8515625f - (_356 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _381 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _367) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _224) * _367) + 1.0f)) * 0.1593017578125f);
            float _390 = clamp(exp2(log2(((_381 * 18.8515625f) + 0.8359375f) / ((_381 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _393 = min(_335 / _390, _390 / _335);
            float _394 = ((dot(float3(_307, _320, _333), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _393;
            float _395 = ((dot(float3(_307, _320, _333), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _393;
            float _411 = exp2(log2(clamp(mad(0.111000001430511474609375f, _395, mad(0.0089999996125698089599609375f, _394, _390)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _419 = exp2(log2(max(0.0f, _411 + (-0.8359375f)) / (18.8515625f - (_411 * 18.6875f))) * 6.277394771575927734375f);
            float _423 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _395, mad(-0.0089999996125698089599609375f, _394, _390)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _432 = exp2(log2(max(0.0f, _423 + (-0.8359375f)) / (18.8515625f - (_423 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _436 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _395, mad(0.560000002384185791015625f, _394, _390)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _445 = exp2(log2(max(0.0f, _436 + (-0.8359375f)) / (18.8515625f - (_436 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _450 = mad(0.20700000226497650146484375f, _445, mad(-1.32700002193450927734375f, _432, _419 * 207.100006103515625f));
            float _456 = mad(-0.04500000178813934326171875f, _445, mad(0.6809999942779541015625f, _432, _419 * 36.5f));
            float _462 = mad(1.1879999637603759765625f, _445, mad(-0.0500000007450580596923828125f, _432, _419 * (-4.900000095367431640625f)));
            _262 = mad(-0.498610794544219970703125f, _462, mad(-1.53738319873809814453125f, _456, _450 * 3.2409698963165283203125f));
            _264 = mad(0.0415550954639911651611328125f, _462, mad(1.8759677410125732421875f, _456, _450 * (-0.969243705272674560546875f)));
            _266 = mad(1.05697143077850341796875f, _462, mad(-0.2039768397808074951171875f, _456, _450 * 0.0556300692260265350341796875f));
        }
        float _576;
        float _580;
        float _584;
        if (_224 == 1.0f)
        {
            float _487 = mad(0.043313600122928619384765625f, _266, mad(0.329281985759735107421875f, _264, _262 * 0.6274039745330810546875f));
            float _493 = mad(0.0113612003624439239501953125f, _266, mad(0.919539988040924072265625f, _264, _262 * 0.06909699738025665283203125f));
            float _499 = mad(0.895595014095306396484375f, _266, mad(0.0880132019519805908203125f, _264, _262 * 0.01639159955084323883056640625f));
            float _526 = 10000.0f / HDRMapping_m0[10u].y;
            float _536 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_262 - _487)) + _487) * HDRMapping_m0[7u].y) / _526, 0.0f, 1.0f)) * 0.1593017578125f);
            float _545 = clamp(exp2(log2(((_536 * 18.8515625f) + 0.8359375f) / ((_536 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _548 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_264 - _493)) + _493) * HDRMapping_m0[7u].y) / _526, 0.0f, 1.0f)) * 0.1593017578125f);
            float _557 = clamp(exp2(log2(((_548 * 18.8515625f) + 0.8359375f) / ((_548 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _560 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_266 - _499)) + _499) * HDRMapping_m0[7u].y) / _526, 0.0f, 1.0f)) * 0.1593017578125f);
            float _569 = clamp(exp2(log2(((_560 * 18.8515625f) + 0.8359375f) / ((_560 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_7_ladder;
            float frontier_phi_9_7_ladder_1;
            float frontier_phi_9_7_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_7_ladder = _545;
                frontier_phi_9_7_ladder_1 = _557;
                frontier_phi_9_7_ladder_2 = _569;
            }
            else
            {
                float _601 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _610 = clamp(exp2(log2(((_601 * 18.8515625f) + 0.8359375f) / ((_601 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _616 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _626 = _610 - clamp(exp2(log2(((_616 * 18.8515625f) + 0.8359375f) / ((_616 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _630 = clamp(_545 / _610, 0.0f, 1.0f);
                float _631 = clamp(_557 / _610, 0.0f, 1.0f);
                float _632 = clamp(_569 / _610, 0.0f, 1.0f);
                frontier_phi_9_7_ladder = min((((2.0f - (_630 + _630)) * _626) + (_630 * _610)) * _630, _545);
                frontier_phi_9_7_ladder_1 = min((((2.0f - (_631 + _631)) * _626) + (_631 * _610)) * _631, _557);
                frontier_phi_9_7_ladder_2 = min((((2.0f - (_632 + _632)) * _626) + (_632 * _610)) * _632, _569);
            }
            _576 = frontier_phi_9_7_ladder;
            _580 = frontier_phi_9_7_ladder_1;
            _584 = frontier_phi_9_7_ladder_2;
        }
        else
        {
            bool _652;
            if (_254)
            {
                _652 = !_253;
            }
            else
            {
                _652 = false;
            }
            float4 _657 = RWResult[uint2(uint(_75), uint(_80))].xxxx;
            float _671 = exp2(log2(clamp(_657.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _672 = exp2(log2(clamp(_657.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _673 = exp2(log2(clamp(_657.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _701 = 10000.0f / HDRMapping_m0[10u].y;
            float _702 = _701 * exp2(log2(max(0.0f, _671 + (-0.8359375f)) / (18.8515625f - (_671 * 18.6875f))) * 6.277394771575927734375f);
            float _703 = _701 * exp2(log2(max(0.0f, _672 + (-0.8359375f)) / (18.8515625f - (_672 * 18.6875f))) * 6.277394771575927734375f);
            float _704 = _701 * exp2(log2(max(0.0f, _673 + (-0.8359375f)) / (18.8515625f - (_673 * 18.6875f))) * 6.277394771575927734375f);
            float _709 = mad(-0.07285170257091522216796875f, _704, mad(-0.587639987468719482421875f, _703, _702 * 1.66049098968505859375f));
            float _715 = mad(-0.008348000235855579376220703125f, _704, mad(1.1328999996185302734375f, _703, _702 * (-0.12454999983310699462890625f)));
            float _721 = mad(1.11872994899749755859375f, _704, mad(-0.100579001009464263916015625f, _703, _702 * (-0.01815100014209747314453125f)));
            float _723;
            float _725;
            float _727;
            if (_652)
            {
                _723 = _262;
                _725 = _264;
                _727 = _266;
            }
            else
            {
                _723 = (_262 - _709) * _224;
                _725 = (_264 - _715) * _224;
                _727 = (_266 - _721) * _224;
            }
            float _729 = _723 + _709;
            float _730 = _725 + _715;
            float _731 = _727 + _721;
            float _734 = mad(0.043313600122928619384765625f, _731, mad(0.329281985759735107421875f, _730, _729 * 0.6274039745330810546875f));
            float _737 = mad(0.0113612003624439239501953125f, _731, mad(0.919539988040924072265625f, _730, _729 * 0.06909699738025665283203125f));
            float _740 = mad(0.895595014095306396484375f, _731, mad(0.0880132019519805908203125f, _730, _729 * 0.01639159955084323883056640625f));
            float _773 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_729 - _734)) + _734) * HDRMapping_m0[7u].y) / _701, 0.0f, 1.0f)) * 0.1593017578125f);
            float _579 = clamp(exp2(log2(((_773 * 18.8515625f) + 0.8359375f) / ((_773 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _784 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_730 - _737)) + _737) * HDRMapping_m0[7u].y) / _701, 0.0f, 1.0f)) * 0.1593017578125f);
            float _583 = clamp(exp2(log2(((_784 * 18.8515625f) + 0.8359375f) / ((_784 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _795 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_731 - _740)) + _740) * HDRMapping_m0[7u].y) / _701, 0.0f, 1.0f)) * 0.1593017578125f);
            float _587 = clamp(exp2(log2(((_795 * 18.8515625f) + 0.8359375f) / ((_795 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_13_ladder;
            float frontier_phi_9_13_ladder_1;
            float frontier_phi_9_13_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_13_ladder = _579;
                frontier_phi_9_13_ladder_1 = _583;
                frontier_phi_9_13_ladder_2 = _587;
            }
            else
            {
                float _820 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _829 = clamp(exp2(log2(((_820 * 18.8515625f) + 0.8359375f) / ((_820 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _835 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _845 = _829 - clamp(exp2(log2(((_835 * 18.8515625f) + 0.8359375f) / ((_835 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _849 = clamp(_579 / _829, 0.0f, 1.0f);
                float _850 = clamp(_583 / _829, 0.0f, 1.0f);
                float _851 = clamp(_587 / _829, 0.0f, 1.0f);
                frontier_phi_9_13_ladder = min((((2.0f - (_849 + _849)) * _845) + (_849 * _829)) * _849, _579);
                frontier_phi_9_13_ladder_1 = min((((2.0f - (_850 + _850)) * _845) + (_850 * _829)) * _850, _583);
                frontier_phi_9_13_ladder_2 = min((((2.0f - (_851 + _851)) * _845) + (_851 * _829)) * _851, _587);
            }
            _576 = frontier_phi_9_13_ladder;
            _580 = frontier_phi_9_13_ladder_1;
            _584 = frontier_phi_9_13_ladder_2;
        }
        RWResult[uint2(uint(_75), uint(_80))] = float4(_576, _580, _584, _576).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
