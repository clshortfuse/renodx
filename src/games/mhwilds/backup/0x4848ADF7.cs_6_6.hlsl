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
    float4 UserMaterial_m0[3] : packoffset(c0);
};

Texture2D<float4> _Texture2D : register(t0, space0);
Texture2D<float4> _Texture2D_1 : register(t1, space0);
Texture2D<float4> Tex2D_0 : register(t2, space0);
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
    float _99 = (float(_82) + 0.5f) * SceneInfo_m0[23u].z;
    float _100 = (float(_87) + 0.5f) * SceneInfo_m0[23u].w;
    float _112 = (float(asuint(EnvironmentInfo_m0[0u]).x) * (-9.9999997473787516355514526367188e-05f)) * UserMaterial_m0[1u].z;
    float _117 = _99 * UserMaterial_m0[1u].x;
    float _118 = (_100 * UserMaterial_m0[1u].y) + UserMaterial_m0[1u].y;
    float4 _126 = Tex2D_0.SampleGrad(BilinearWrap, float2(_99, _100), 0.0f.xx, 0.0f.xx);
    float _134 = _126.x * 0.0199999995529651641845703125f;
    float _136 = _126.y * 0.0199999995529651641845703125f;
    float4 _143 = _Texture2D.SampleGrad(BilinearWrap, float2((_117 + (_112 * 0.5f)) + _134, (_118 + 0.5f) + _136), 0.0f.xx, 0.0f.xx);
    float _147 = _143.x;
    float4 _148 = _Texture2D.SampleGrad(BilinearWrap, float2((_117 + _112) + _134, _136 + _118), 0.0f.xx, 0.0f.xx);
    float _152 = _148.x;
    float _164 = (_152 > 0.5f) ? 0.0f : 1.0f;
    float _168 = ((1.0f - _164) * (1.0f - (((1.0f - _147) * 2.0f) * (1.0f - _152)))) + (((_147 * 2.0f) * _152) * _164);
    float4 _171 = _Texture2D_1.SampleLevel(BilinearWrap, float2(_99, _100), 0.0f);
    float _182 = _171.x * _171.y;
    float _189 = (UserMaterial_m0[2u].y * (_171.z - _182)) + _182;
    float _196 = UserMaterial_m0[1u].w - UserMaterial_m0[2u].x;
    float _199 = clamp(((_189 * _168) - UserMaterial_m0[2u].x) / _196, 0.0f, 1.0f);
    float _200 = clamp(((_189 * exp2(log2(max(_168, 9.9999999747524270787835121154785e-07f)) * 0.5f)) - UserMaterial_m0[2u].x) / _196, 0.0f, 1.0f);
    float _206 = UserMaterial_m0[0u].x + _199;
    float _207 = UserMaterial_m0[0u].y + _199;
    float _208 = UserMaterial_m0[0u].z + _199;
    float _225;
    float _226;
    float _227;
    if (_200 > 0.0f)
    {
        float _221 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _200)) + _200);
        _225 = _221 * _206;
        _226 = _221 * _207;
        _227 = _221 * _208;
    }
    else
    {
        _225 = _206;
        _226 = _207;
        _227 = _208;
    }
    bool _230 = max(max(_225, _226), _227) == 0.0f;
    bool _231 = _200 == 0.0f;
    if (!(_231 && _230))
    {
        float _239;
        float _241;
        float _243;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _239 = _225;
            _241 = _226;
            _243 = _227;
        }
        else
        {
            float _272 = exp2(log2(mad(0.0810546875f, _227, mad(0.623046875f, _226, _225 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _285 = clamp(exp2(log2(((_272 * 18.8515625f) + 0.8359375f) / ((_272 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _289 = exp2(log2(mad(0.116455078125f, _227, mad(0.727294921875f, _226, _225 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _298 = clamp(exp2(log2(((_289 * 18.8515625f) + 0.8359375f) / ((_289 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _302 = exp2(log2(mad(0.808349609375f, _227, mad(0.156494140625f, _226, _225 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _311 = clamp(exp2(log2(((_302 * 18.8515625f) + 0.8359375f) / ((_302 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _313 = (_298 + _285) * 0.5f;
            float _334 = exp2(log2(clamp(_313, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _345 = exp2(log2(max(0.0f, _334 + (-0.8359375f)) / (18.8515625f - (_334 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _360 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _345) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _200) * _345) + 1.0f)) * 0.1593017578125f);
            float _369 = clamp(exp2(log2(((_360 * 18.8515625f) + 0.8359375f) / ((_360 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _372 = min(_313 / _369, _369 / _313);
            float _373 = ((dot(float3(_285, _298, _311), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _372;
            float _374 = ((dot(float3(_285, _298, _311), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _372;
            float _390 = exp2(log2(clamp(mad(0.111000001430511474609375f, _374, mad(0.0089999996125698089599609375f, _373, _369)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _398 = exp2(log2(max(0.0f, _390 + (-0.8359375f)) / (18.8515625f - (_390 * 18.6875f))) * 6.277394771575927734375f);
            float _402 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _374, mad(-0.0089999996125698089599609375f, _373, _369)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _411 = exp2(log2(max(0.0f, _402 + (-0.8359375f)) / (18.8515625f - (_402 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _415 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _374, mad(0.560000002384185791015625f, _373, _369)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _424 = exp2(log2(max(0.0f, _415 + (-0.8359375f)) / (18.8515625f - (_415 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _429 = mad(0.20700000226497650146484375f, _424, mad(-1.32700002193450927734375f, _411, _398 * 207.100006103515625f));
            float _435 = mad(-0.04500000178813934326171875f, _424, mad(0.6809999942779541015625f, _411, _398 * 36.5f));
            float _441 = mad(1.1879999637603759765625f, _424, mad(-0.0500000007450580596923828125f, _411, _398 * (-4.900000095367431640625f)));
            _239 = mad(-0.498610794544219970703125f, _441, mad(-1.53738319873809814453125f, _435, _429 * 3.2409698963165283203125f));
            _241 = mad(0.0415550954639911651611328125f, _441, mad(1.8759677410125732421875f, _435, _429 * (-0.969243705272674560546875f)));
            _243 = mad(1.05697143077850341796875f, _441, mad(-0.2039768397808074951171875f, _435, _429 * 0.0556300692260265350341796875f));
        }
        float _555;
        float _559;
        float _563;
        if (_200 == 1.0f)
        {
            float _466 = mad(0.043313600122928619384765625f, _243, mad(0.329281985759735107421875f, _241, _239 * 0.6274039745330810546875f));
            float _472 = mad(0.0113612003624439239501953125f, _243, mad(0.919539988040924072265625f, _241, _239 * 0.06909699738025665283203125f));
            float _478 = mad(0.895595014095306396484375f, _243, mad(0.0880132019519805908203125f, _241, _239 * 0.01639159955084323883056640625f));
            float _505 = 10000.0f / HDRMapping_m0[10u].y;
            float _515 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_239 - _466)) + _466) * HDRMapping_m0[7u].y) / _505, 0.0f, 1.0f)) * 0.1593017578125f);
            float _524 = clamp(exp2(log2(((_515 * 18.8515625f) + 0.8359375f) / ((_515 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _527 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_241 - _472)) + _472) * HDRMapping_m0[7u].y) / _505, 0.0f, 1.0f)) * 0.1593017578125f);
            float _536 = clamp(exp2(log2(((_527 * 18.8515625f) + 0.8359375f) / ((_527 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _539 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_243 - _478)) + _478) * HDRMapping_m0[7u].y) / _505, 0.0f, 1.0f)) * 0.1593017578125f);
            float _548 = clamp(exp2(log2(((_539 * 18.8515625f) + 0.8359375f) / ((_539 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_7_ladder;
            float frontier_phi_9_7_ladder_1;
            float frontier_phi_9_7_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_7_ladder = _524;
                frontier_phi_9_7_ladder_1 = _536;
                frontier_phi_9_7_ladder_2 = _548;
            }
            else
            {
                float _581 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _590 = clamp(exp2(log2(((_581 * 18.8515625f) + 0.8359375f) / ((_581 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _596 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _606 = _590 - clamp(exp2(log2(((_596 * 18.8515625f) + 0.8359375f) / ((_596 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _610 = clamp(_524 / _590, 0.0f, 1.0f);
                float _611 = clamp(_536 / _590, 0.0f, 1.0f);
                float _612 = clamp(_548 / _590, 0.0f, 1.0f);
                frontier_phi_9_7_ladder = min((((2.0f - (_610 + _610)) * _606) + (_610 * _590)) * _610, _524);
                frontier_phi_9_7_ladder_1 = min((((2.0f - (_611 + _611)) * _606) + (_611 * _590)) * _611, _536);
                frontier_phi_9_7_ladder_2 = min((((2.0f - (_612 + _612)) * _606) + (_612 * _590)) * _612, _548);
            }
            _555 = frontier_phi_9_7_ladder;
            _559 = frontier_phi_9_7_ladder_1;
            _563 = frontier_phi_9_7_ladder_2;
        }
        else
        {
            bool _632;
            if (_231)
            {
                _632 = !_230;
            }
            else
            {
                _632 = false;
            }
            float4 _637 = RWResult[uint2(uint(_82), uint(_87))].xxxx;
            float _651 = exp2(log2(clamp(_637.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _652 = exp2(log2(clamp(_637.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _653 = exp2(log2(clamp(_637.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _681 = 10000.0f / HDRMapping_m0[10u].y;
            float _682 = _681 * exp2(log2(max(0.0f, _651 + (-0.8359375f)) / (18.8515625f - (_651 * 18.6875f))) * 6.277394771575927734375f);
            float _683 = _681 * exp2(log2(max(0.0f, _652 + (-0.8359375f)) / (18.8515625f - (_652 * 18.6875f))) * 6.277394771575927734375f);
            float _684 = _681 * exp2(log2(max(0.0f, _653 + (-0.8359375f)) / (18.8515625f - (_653 * 18.6875f))) * 6.277394771575927734375f);
            float _689 = mad(-0.07285170257091522216796875f, _684, mad(-0.587639987468719482421875f, _683, _682 * 1.66049098968505859375f));
            float _695 = mad(-0.008348000235855579376220703125f, _684, mad(1.1328999996185302734375f, _683, _682 * (-0.12454999983310699462890625f)));
            float _701 = mad(1.11872994899749755859375f, _684, mad(-0.100579001009464263916015625f, _683, _682 * (-0.01815100014209747314453125f)));
            float _703;
            float _705;
            float _707;
            if (_632)
            {
                _703 = _239;
                _705 = _241;
                _707 = _243;
            }
            else
            {
                _703 = (_239 - _689) * _200;
                _705 = (_241 - _695) * _200;
                _707 = (_243 - _701) * _200;
            }
            float _709 = _703 + _689;
            float _710 = _705 + _695;
            float _711 = _707 + _701;
            float _714 = mad(0.043313600122928619384765625f, _711, mad(0.329281985759735107421875f, _710, _709 * 0.6274039745330810546875f));
            float _717 = mad(0.0113612003624439239501953125f, _711, mad(0.919539988040924072265625f, _710, _709 * 0.06909699738025665283203125f));
            float _720 = mad(0.895595014095306396484375f, _711, mad(0.0880132019519805908203125f, _710, _709 * 0.01639159955084323883056640625f));
            float _753 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_709 - _714)) + _714) * HDRMapping_m0[7u].y) / _681, 0.0f, 1.0f)) * 0.1593017578125f);
            float _558 = clamp(exp2(log2(((_753 * 18.8515625f) + 0.8359375f) / ((_753 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _764 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_710 - _717)) + _717) * HDRMapping_m0[7u].y) / _681, 0.0f, 1.0f)) * 0.1593017578125f);
            float _562 = clamp(exp2(log2(((_764 * 18.8515625f) + 0.8359375f) / ((_764 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _775 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_711 - _720)) + _720) * HDRMapping_m0[7u].y) / _681, 0.0f, 1.0f)) * 0.1593017578125f);
            float _566 = clamp(exp2(log2(((_775 * 18.8515625f) + 0.8359375f) / ((_775 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_13_ladder;
            float frontier_phi_9_13_ladder_1;
            float frontier_phi_9_13_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_13_ladder = _558;
                frontier_phi_9_13_ladder_1 = _562;
                frontier_phi_9_13_ladder_2 = _566;
            }
            else
            {
                float _800 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _809 = clamp(exp2(log2(((_800 * 18.8515625f) + 0.8359375f) / ((_800 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _815 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _825 = _809 - clamp(exp2(log2(((_815 * 18.8515625f) + 0.8359375f) / ((_815 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _829 = clamp(_558 / _809, 0.0f, 1.0f);
                float _830 = clamp(_562 / _809, 0.0f, 1.0f);
                float _831 = clamp(_566 / _809, 0.0f, 1.0f);
                frontier_phi_9_13_ladder = min((((2.0f - (_829 + _829)) * _825) + (_829 * _809)) * _829, _558);
                frontier_phi_9_13_ladder_1 = min((((2.0f - (_830 + _830)) * _825) + (_830 * _809)) * _830, _562);
                frontier_phi_9_13_ladder_2 = min((((2.0f - (_831 + _831)) * _825) + (_831 * _809)) * _831, _566);
            }
            _555 = frontier_phi_9_13_ladder;
            _559 = frontier_phi_9_13_ladder_1;
            _563 = frontier_phi_9_13_ladder_2;
        }
        RWResult[uint2(uint(_82), uint(_87))] = float4(_555, _559, _563, _555).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
