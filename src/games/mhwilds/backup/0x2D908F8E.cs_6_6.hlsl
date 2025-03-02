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
    float4 UserMaterial_m0[6] : packoffset(c0);
};

Texture2D<float4> Tex2D_Noise : register(t0, space0);
Texture2D<float4> Tex2D_Color : register(t1, space0);
Texture2D<float4> Tex2D_Alpha : register(t2, space0);
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
    uint _60 = uint(gl_LocalInvocationID.x);
    uint _63 = _60 >> 1u;
    uint _67 = _60 >> 2u;
    uint _71 = _60 >> 3u;
    uint _82 = ((((_60 & 1u) | (uint(gl_WorkGroupID.x) << 4u)) | (_63 & 2u)) | (_67 & 4u)) | (_71 & 8u);
    uint _87 = ((((_63 & 1u) | (uint(gl_WorkGroupID.y) << 4u)) | (_67 & 2u)) | (_71 & 4u)) | ((_60 >> 4u) & 8u);
    float _101 = (float(_87) + 0.5f) * SceneInfo_m0[23u].w;
    float _104 = ((SceneInfo_m0[23u].x / SceneInfo_m0[23u].y) * SceneInfo_m0[23u].z) * (float(_82) + 0.5f);
    float _138;
    if (abs(UserMaterial_m0[2u].x * (-0.20000000298023223876953125f)) > 0.0f)
    {
        _138 = frac((UserMaterial_m0[2u].x * (-0.000200000009499490261077880859375f)) * EnvironmentInfo_m0[4u].y);
    }
    else
    {
        _138 = 0.0f;
    }
    float _147;
    if (abs(UserMaterial_m0[2u].y * (-0.20000000298023223876953125f)) > 0.0f)
    {
        _147 = frac((UserMaterial_m0[2u].y * (-0.000200000009499490261077880859375f)) * EnvironmentInfo_m0[4u].y);
    }
    else
    {
        _147 = 0.0f;
    }
    float _148 = _104 * UserMaterial_m0[3u].y;
    float _149 = _101 * UserMaterial_m0[3u].y;
    float _163 = UserMaterial_m0[3u].z * Tex2D_Noise.SampleLevel(BilinearWrap, float2((((UserMaterial_m0[2u].z * 2.0f) + 0.1500000059604644775390625f) - _148) + _138, (((UserMaterial_m0[2u].w * 2.0f) + 0.1500000059604644775390625f) - _149) + _147), 0.0f).x;
    float _176;
    if (abs(UserMaterial_m0[2u].x) > 0.0f)
    {
        _176 = frac((UserMaterial_m0[2u].x * 0.001000000047497451305389404296875f) * EnvironmentInfo_m0[4u].y);
    }
    else
    {
        _176 = 0.0f;
    }
    float _185;
    if (abs(UserMaterial_m0[2u].y) > 0.0f)
    {
        _185 = frac((UserMaterial_m0[2u].y * 0.001000000047497451305389404296875f) * EnvironmentInfo_m0[4u].y);
    }
    else
    {
        _185 = 0.0f;
    }
    float4 _194 = Tex2D_Color.SampleLevel(BilinearWrap, float2((UserMaterial_m0[2u].z + ((_163 - _104) * UserMaterial_m0[3u].x)) + _176, (((_163 - _101) * UserMaterial_m0[3u].x) + UserMaterial_m0[2u].w) + _185), 0.0f);
    float _196 = _194.x;
    float _197 = _194.y;
    float _198 = _194.z;
    float _205 = UserMaterial_m0[4u].x * _196;
    float _208 = ((_197 - _205) * UserMaterial_m0[4u].y) + _205;
    float _211 = ((_198 - _208) * UserMaterial_m0[4u].z) + _208;
    float _218 = ((_196 - _211) * UserMaterial_m0[4u].w) + _211;
    float _219 = ((_197 - _211) * UserMaterial_m0[4u].w) + _211;
    float4 _228 = Tex2D_Alpha.SampleLevel(BilinearWrap, float2((_218 * UserMaterial_m0[3u].w) + _148, (_219 * UserMaterial_m0[3u].w) + _149), 0.0f);
    float _247 = (_218 * UserMaterial_m0[1u].x) + UserMaterial_m0[0u].x;
    float _248 = (_219 * UserMaterial_m0[1u].y) + UserMaterial_m0[0u].y;
    float _249 = ((((_198 - _211) * UserMaterial_m0[4u].w) + _211) * UserMaterial_m0[1u].z) + UserMaterial_m0[0u].z;
    float _257 = UserMaterial_m0[5u].x * _228.x;
    float _260 = ((_228.y - _257) * UserMaterial_m0[5u].y) + _257;
    float _263 = ((_228.z - _260) * UserMaterial_m0[5u].z) + _260;
    float _266 = ((_228.w - _263) * UserMaterial_m0[5u].w) + _263;
    float _285;
    float _286;
    float _287;
    if (_266 > 0.0f)
    {
        float _281 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _266)) + _266);
        _285 = _281 * _247;
        _286 = _281 * _248;
        _287 = _281 * _249;
    }
    else
    {
        _285 = _247;
        _286 = _248;
        _287 = _249;
    }
    bool _290 = max(max(_285, _286), _287) == 0.0f;
    bool _291 = _266 == 0.0f;
    if (!(_291 && _290))
    {
        float _299;
        float _301;
        float _303;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _299 = _285;
            _301 = _286;
            _303 = _287;
        }
        else
        {
            float _332 = exp2(log2(mad(0.0810546875f, _287, mad(0.623046875f, _286, _285 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _345 = clamp(exp2(log2(((_332 * 18.8515625f) + 0.8359375f) / ((_332 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _349 = exp2(log2(mad(0.116455078125f, _287, mad(0.727294921875f, _286, _285 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _358 = clamp(exp2(log2(((_349 * 18.8515625f) + 0.8359375f) / ((_349 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _362 = exp2(log2(mad(0.808349609375f, _287, mad(0.156494140625f, _286, _285 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _371 = clamp(exp2(log2(((_362 * 18.8515625f) + 0.8359375f) / ((_362 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _373 = (_358 + _345) * 0.5f;
            float _394 = exp2(log2(clamp(_373, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _405 = exp2(log2(max(0.0f, _394 + (-0.8359375f)) / (18.8515625f - (_394 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _420 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _405) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _266) * _405) + 1.0f)) * 0.1593017578125f);
            float _429 = clamp(exp2(log2(((_420 * 18.8515625f) + 0.8359375f) / ((_420 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _432 = min(_373 / _429, _429 / _373);
            float _433 = ((dot(float3(_345, _358, _371), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _432;
            float _434 = ((dot(float3(_345, _358, _371), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _432;
            float _450 = exp2(log2(clamp(mad(0.111000001430511474609375f, _434, mad(0.0089999996125698089599609375f, _433, _429)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _458 = exp2(log2(max(0.0f, _450 + (-0.8359375f)) / (18.8515625f - (_450 * 18.6875f))) * 6.277394771575927734375f);
            float _462 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _434, mad(-0.0089999996125698089599609375f, _433, _429)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _471 = exp2(log2(max(0.0f, _462 + (-0.8359375f)) / (18.8515625f - (_462 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _475 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _434, mad(0.560000002384185791015625f, _433, _429)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _484 = exp2(log2(max(0.0f, _475 + (-0.8359375f)) / (18.8515625f - (_475 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _489 = mad(0.20700000226497650146484375f, _484, mad(-1.32700002193450927734375f, _471, _458 * 207.100006103515625f));
            float _495 = mad(-0.04500000178813934326171875f, _484, mad(0.6809999942779541015625f, _471, _458 * 36.5f));
            float _501 = mad(1.1879999637603759765625f, _484, mad(-0.0500000007450580596923828125f, _471, _458 * (-4.900000095367431640625f)));
            _299 = mad(-0.498610794544219970703125f, _501, mad(-1.53738319873809814453125f, _495, _489 * 3.2409698963165283203125f));
            _301 = mad(0.0415550954639911651611328125f, _501, mad(1.8759677410125732421875f, _495, _489 * (-0.969243705272674560546875f)));
            _303 = mad(1.05697143077850341796875f, _501, mad(-0.2039768397808074951171875f, _495, _489 * 0.0556300692260265350341796875f));
        }
        float _615;
        float _619;
        float _623;
        if (_266 == 1.0f)
        {
            float _526 = mad(0.043313600122928619384765625f, _303, mad(0.329281985759735107421875f, _301, _299 * 0.6274039745330810546875f));
            float _532 = mad(0.0113612003624439239501953125f, _303, mad(0.919539988040924072265625f, _301, _299 * 0.06909699738025665283203125f));
            float _538 = mad(0.895595014095306396484375f, _303, mad(0.0880132019519805908203125f, _301, _299 * 0.01639159955084323883056640625f));
            float _565 = 10000.0f / HDRMapping_m0[10u].y;
            float _575 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_299 - _526)) + _526) * HDRMapping_m0[7u].y) / _565, 0.0f, 1.0f)) * 0.1593017578125f);
            float _584 = clamp(exp2(log2(((_575 * 18.8515625f) + 0.8359375f) / ((_575 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _587 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_301 - _532)) + _532) * HDRMapping_m0[7u].y) / _565, 0.0f, 1.0f)) * 0.1593017578125f);
            float _596 = clamp(exp2(log2(((_587 * 18.8515625f) + 0.8359375f) / ((_587 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _599 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_303 - _538)) + _538) * HDRMapping_m0[7u].y) / _565, 0.0f, 1.0f)) * 0.1593017578125f);
            float _608 = clamp(exp2(log2(((_599 * 18.8515625f) + 0.8359375f) / ((_599 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_17_15_ladder;
            float frontier_phi_17_15_ladder_1;
            float frontier_phi_17_15_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_17_15_ladder = _584;
                frontier_phi_17_15_ladder_1 = _608;
                frontier_phi_17_15_ladder_2 = _596;
            }
            else
            {
                float _641 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _650 = clamp(exp2(log2(((_641 * 18.8515625f) + 0.8359375f) / ((_641 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _656 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _666 = _650 - clamp(exp2(log2(((_656 * 18.8515625f) + 0.8359375f) / ((_656 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _670 = clamp(_584 / _650, 0.0f, 1.0f);
                float _671 = clamp(_596 / _650, 0.0f, 1.0f);
                float _672 = clamp(_608 / _650, 0.0f, 1.0f);
                frontier_phi_17_15_ladder = min((((2.0f - (_670 + _670)) * _666) + (_670 * _650)) * _670, _584);
                frontier_phi_17_15_ladder_1 = min((((2.0f - (_672 + _672)) * _666) + (_672 * _650)) * _672, _608);
                frontier_phi_17_15_ladder_2 = min((((2.0f - (_671 + _671)) * _666) + (_671 * _650)) * _671, _596);
            }
            _615 = frontier_phi_17_15_ladder;
            _619 = frontier_phi_17_15_ladder_2;
            _623 = frontier_phi_17_15_ladder_1;
        }
        else
        {
            bool _692;
            if (_291)
            {
                _692 = !_290;
            }
            else
            {
                _692 = false;
            }
            float4 _697 = RWResult[uint2(uint(_82), uint(_87))].xxxx;
            float _711 = exp2(log2(clamp(_697.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _712 = exp2(log2(clamp(_697.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _713 = exp2(log2(clamp(_697.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _741 = 10000.0f / HDRMapping_m0[10u].y;
            float _742 = _741 * exp2(log2(max(0.0f, _711 + (-0.8359375f)) / (18.8515625f - (_711 * 18.6875f))) * 6.277394771575927734375f);
            float _743 = _741 * exp2(log2(max(0.0f, _712 + (-0.8359375f)) / (18.8515625f - (_712 * 18.6875f))) * 6.277394771575927734375f);
            float _744 = _741 * exp2(log2(max(0.0f, _713 + (-0.8359375f)) / (18.8515625f - (_713 * 18.6875f))) * 6.277394771575927734375f);
            float _749 = mad(-0.07285170257091522216796875f, _744, mad(-0.587639987468719482421875f, _743, _742 * 1.66049098968505859375f));
            float _755 = mad(-0.008348000235855579376220703125f, _744, mad(1.1328999996185302734375f, _743, _742 * (-0.12454999983310699462890625f)));
            float _761 = mad(1.11872994899749755859375f, _744, mad(-0.100579001009464263916015625f, _743, _742 * (-0.01815100014209747314453125f)));
            float _763;
            float _765;
            float _767;
            if (_692)
            {
                _763 = _299;
                _765 = _301;
                _767 = _303;
            }
            else
            {
                _763 = (_299 - _749) * _266;
                _765 = (_301 - _755) * _266;
                _767 = (_303 - _761) * _266;
            }
            float _769 = _763 + _749;
            float _770 = _765 + _755;
            float _771 = _767 + _761;
            float _774 = mad(0.043313600122928619384765625f, _771, mad(0.329281985759735107421875f, _770, _769 * 0.6274039745330810546875f));
            float _777 = mad(0.0113612003624439239501953125f, _771, mad(0.919539988040924072265625f, _770, _769 * 0.06909699738025665283203125f));
            float _780 = mad(0.895595014095306396484375f, _771, mad(0.0880132019519805908203125f, _770, _769 * 0.01639159955084323883056640625f));
            float _813 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_769 - _774)) + _774) * HDRMapping_m0[7u].y) / _741, 0.0f, 1.0f)) * 0.1593017578125f);
            float _618 = clamp(exp2(log2(((_813 * 18.8515625f) + 0.8359375f) / ((_813 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _824 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_770 - _777)) + _777) * HDRMapping_m0[7u].y) / _741, 0.0f, 1.0f)) * 0.1593017578125f);
            float _622 = clamp(exp2(log2(((_824 * 18.8515625f) + 0.8359375f) / ((_824 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _835 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_771 - _780)) + _780) * HDRMapping_m0[7u].y) / _741, 0.0f, 1.0f)) * 0.1593017578125f);
            float _626 = clamp(exp2(log2(((_835 * 18.8515625f) + 0.8359375f) / ((_835 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_17_21_ladder;
            float frontier_phi_17_21_ladder_1;
            float frontier_phi_17_21_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_17_21_ladder = _618;
                frontier_phi_17_21_ladder_1 = _626;
                frontier_phi_17_21_ladder_2 = _622;
            }
            else
            {
                float _860 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _869 = clamp(exp2(log2(((_860 * 18.8515625f) + 0.8359375f) / ((_860 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _875 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _885 = _869 - clamp(exp2(log2(((_875 * 18.8515625f) + 0.8359375f) / ((_875 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _889 = clamp(_618 / _869, 0.0f, 1.0f);
                float _890 = clamp(_622 / _869, 0.0f, 1.0f);
                float _891 = clamp(_626 / _869, 0.0f, 1.0f);
                frontier_phi_17_21_ladder = min((((2.0f - (_889 + _889)) * _885) + (_889 * _869)) * _889, _618);
                frontier_phi_17_21_ladder_1 = min((((2.0f - (_891 + _891)) * _885) + (_891 * _869)) * _891, _626);
                frontier_phi_17_21_ladder_2 = min((((2.0f - (_890 + _890)) * _885) + (_890 * _869)) * _890, _622);
            }
            _615 = frontier_phi_17_21_ladder;
            _619 = frontier_phi_17_21_ladder_2;
            _623 = frontier_phi_17_21_ladder_1;
        }
        RWResult[uint2(uint(_82), uint(_87))] = float4(_615, _619, _623, _615).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
