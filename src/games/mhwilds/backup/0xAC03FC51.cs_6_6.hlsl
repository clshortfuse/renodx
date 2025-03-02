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
    float4 UserMaterial_m0[12] : packoffset(c0);
};

Texture2D<float4> Tex2D_1 : register(t0, space0);
Texture2D<float4> Tex2D_0 : register(t1, space0);
Texture2D<float4> Tex2D_2 : register(t2, space0);
RWTexture2D<float> RWResult : register(u0, space0);
SamplerState BilinearWrap : register(s4, space32);
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
    uint _61 = uint(gl_LocalInvocationID.x);
    uint _64 = _61 >> 1u;
    uint _68 = _61 >> 2u;
    uint _72 = _61 >> 3u;
    uint _83 = ((((_61 & 1u) | (uint(gl_WorkGroupID.x) << 4u)) | (_64 & 2u)) | (_68 & 4u)) | (_72 & 8u);
    uint _88 = ((((_64 & 1u) | (uint(gl_WorkGroupID.y) << 4u)) | (_68 & 2u)) | (_72 & 4u)) | ((_61 >> 4u) & 8u);
    float _91 = float(_83) + 0.5f;
    float _100 = _91 * SceneInfo_m0[23u].z;
    float _101 = (float(_88) + 0.5f) * SceneInfo_m0[23u].w;
    float _107 = min(UserMaterial_m0[0u].z, UserMaterial_m0[0u].w);
    float _109 = UserMaterial_m0[0u].z / _107;
    float _110 = UserMaterial_m0[0u].w / _107;
    float _118 = ((SceneInfo_m0[23u].w * SceneInfo_m0[23u].x) * _91) * SceneInfo_m0[23u].z;
    float _125 = ((_109 * 2.0f) * _100) - _109;
    float _126 = ((_110 * 2.0f) * _101) - _110;
    float _137 = frac(EnvironmentInfo_m0[4u].x * 5.000000237487256526947021484375e-05f);
    float _138 = _118 * 3.0f;
    float _140 = _101 * 3.0f;
    float _173 = (Tex2D_2.SampleLevel(BilinearWrap, float2((_137 + 0.0500000007450580596923828125f) - _138, ((0.5f - UserMaterial_m0[7u].z) + _137) - _140), 0.0f).x + Tex2D_2.SampleLevel(BilinearWrap, float2((UserMaterial_m0[7u].z + _138) + _137, (_140 + 3.0f) + _137), 0.0f).x) * 0.5f;
    float _174 = _173 + (-0.5f);
    float _176 = UserMaterial_m0[7u].w * sin((UserMaterial_m0[6u].x * sqrt((_126 * _126) + (_125 * _125))) + (UserMaterial_m0[6u].y * UserMaterial_m0[7u].w));
    uint _187_dummy_parameter;
    uint2 _187 = spvTextureSize(Tex2D_1, 0u, _187_dummy_parameter);
    float _192 = 1.0f / float(_187.x);
    float _194 = 1.0f / float(_187.y);
    float _214 = (UserMaterial_m0[8u].x * _174) + (_176 * 0.00999999977648258209228515625f);
    float _218 = UserMaterial_m0[8u].y * _174;
    float _221 = 0.25f - UserMaterial_m0[7u].z;
    bool _231 = abs(UserMaterial_m0[8u].w * (-0.0500000007450580596923828125f)) > 0.0f;
    float _236;
    if (_231)
    {
        _236 = frac((UserMaterial_m0[8u].w * (-5.000000237487256526947021484375e-05f)) * EnvironmentInfo_m0[4u].x);
    }
    else
    {
        _236 = 0.0f;
    }
    float _240;
    if (_231)
    {
        _240 = frac((UserMaterial_m0[8u].w * (-5.000000237487256526947021484375e-05f)) * EnvironmentInfo_m0[4u].x);
    }
    else
    {
        _240 = 0.0f;
    }
    float _241 = _118 * 3.5f;
    float _243 = _101 * 3.5f;
    bool _245 = abs(UserMaterial_m0[8u].w * 0.0500000007450580596923828125f) > 0.0f;
    float _249;
    if (_245)
    {
        _249 = frac((UserMaterial_m0[8u].w * 5.000000237487256526947021484375e-05f) * EnvironmentInfo_m0[4u].x);
    }
    else
    {
        _249 = 0.0f;
    }
    float _253;
    if (_245)
    {
        _253 = frac((UserMaterial_m0[8u].w * 5.000000237487256526947021484375e-05f) * EnvironmentInfo_m0[4u].x);
    }
    else
    {
        _253 = 0.0f;
    }
    float4 _272 = Tex2D_1.SampleLevel(TrilinearClamp, float2(min(max((_192 * (UserMaterial_m0[11u].x * ((UserMaterial_m0[0u].z * _100) + UserMaterial_m0[0u].x))) + _214, (UserMaterial_m0[11u].x * UserMaterial_m0[0u].x) * _192), (UserMaterial_m0[11u].x * (UserMaterial_m0[0u].x + UserMaterial_m0[0u].z)) * _192), min(max((_194 * (UserMaterial_m0[11u].x * ((UserMaterial_m0[0u].w * _101) + UserMaterial_m0[0u].y))) + _214, (UserMaterial_m0[11u].x * UserMaterial_m0[0u].y) * _194), (UserMaterial_m0[11u].x * (UserMaterial_m0[0u].y + UserMaterial_m0[0u].w)) * _194)), 0.0f);
    float _274 = _272.x;
    float _275 = _272.y;
    float _276 = _272.z;
    float _279 = UserMaterial_m0[7u].y * 1.35000002384185791015625f;
    float _283 = _279 + (-0.3499999940395355224609375f);
    float _291 = (_173 < (_279 + (-0.25f))) ? 0.0f : 1.0f;
    float _299 = clamp((_173 - _283) / (((_283 == _279) ? (_279 + (-0.3499000072479248046875f)) : _279) - _283), 0.0f, 1.0f);
    bool _308 = UserMaterial_m0[7u].x > 0.0f;
    float _344;
    float _345;
    float _346;
    if (_308)
    {
        float _326 = ((UserMaterial_m0[2u].x - UserMaterial_m0[1u].x) * _275) + UserMaterial_m0[1u].x;
        float _327 = ((UserMaterial_m0[2u].y - UserMaterial_m0[1u].y) * _275) + UserMaterial_m0[1u].y;
        float _328 = ((UserMaterial_m0[2u].z - UserMaterial_m0[1u].z) * _275) + UserMaterial_m0[1u].z;
        _344 = ((UserMaterial_m0[3u].x - _326) * _276) + _326;
        _345 = ((UserMaterial_m0[3u].y - _327) * _276) + _327;
        _346 = ((UserMaterial_m0[3u].z - _328) * _276) + _328;
    }
    else
    {
        _344 = _274;
        _345 = _275;
        _346 = _276;
    }
    float _356 = _176 * 0.20000000298023223876953125f;
    float _374;
    if (_308)
    {
        float _363 = UserMaterial_m0[5u].x * _274;
        float _368 = ((UserMaterial_m0[5u].y * _275) * (1.0f - _363)) + _363;
        _374 = ((UserMaterial_m0[5u].z * _276) * (1.0f - _368)) + _368;
    }
    else
    {
        _374 = _272.w;
    }
    float _376 = UserMaterial_m0[8u].z * clamp(Tex2D_0.SampleLevel(BilinearWrap, float2(((_241 + _221) + _218) + _236, ((_243 + _221) + _218) + _240), 0.0f).x + Tex2D_0.SampleLevel(BilinearWrap, float2(((UserMaterial_m0[7u].z + _241) + _218) + _249, (((UserMaterial_m0[7u].z + 0.5f) + _243) + _218) + _253), 0.0f).x, 0.0f, 1.0f);
    float _379 = ((_344 + _356) + (UserMaterial_m0[4u].x * _291)) + _376;
    float _382 = ((_345 + _356) + (UserMaterial_m0[4u].y * _291)) + _376;
    float _385 = ((_346 + _356) + (UserMaterial_m0[4u].z * _291)) + _376;
    float _386 = _374 - ((_299 * _299) * (3.0f - (_299 * 2.0f)));
    float _403;
    float _404;
    float _405;
    if (_386 > 0.0f)
    {
        float _399 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _386)) + _386);
        _403 = _399 * _379;
        _404 = _399 * _382;
        _405 = _399 * _385;
    }
    else
    {
        _403 = _379;
        _404 = _382;
        _405 = _385;
    }
    bool _408 = max(max(_403, _404), _405) == 0.0f;
    bool _409 = _386 == 0.0f;
    if (!(_409 && _408))
    {
        float _417;
        float _419;
        float _421;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _417 = _403;
            _419 = _404;
            _421 = _405;
        }
        else
        {
            float _449 = exp2(log2(mad(0.0810546875f, _405, mad(0.623046875f, _404, _403 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _462 = clamp(exp2(log2(((_449 * 18.8515625f) + 0.8359375f) / ((_449 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _466 = exp2(log2(mad(0.116455078125f, _405, mad(0.727294921875f, _404, _403 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _475 = clamp(exp2(log2(((_466 * 18.8515625f) + 0.8359375f) / ((_466 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _479 = exp2(log2(mad(0.808349609375f, _405, mad(0.156494140625f, _404, _403 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _488 = clamp(exp2(log2(((_479 * 18.8515625f) + 0.8359375f) / ((_479 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _490 = (_475 + _462) * 0.5f;
            float _511 = exp2(log2(clamp(_490, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _522 = exp2(log2(max(0.0f, _511 + (-0.8359375f)) / (18.8515625f - (_511 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _537 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _522) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _386) * _522) + 1.0f)) * 0.1593017578125f);
            float _546 = clamp(exp2(log2(((_537 * 18.8515625f) + 0.8359375f) / ((_537 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _549 = min(_490 / _546, _546 / _490);
            float _550 = ((dot(float3(_462, _475, _488), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _549;
            float _551 = ((dot(float3(_462, _475, _488), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _549;
            float _567 = exp2(log2(clamp(mad(0.111000001430511474609375f, _551, mad(0.0089999996125698089599609375f, _550, _546)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _575 = exp2(log2(max(0.0f, _567 + (-0.8359375f)) / (18.8515625f - (_567 * 18.6875f))) * 6.277394771575927734375f);
            float _579 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _551, mad(-0.0089999996125698089599609375f, _550, _546)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _588 = exp2(log2(max(0.0f, _579 + (-0.8359375f)) / (18.8515625f - (_579 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _592 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _551, mad(0.560000002384185791015625f, _550, _546)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _601 = exp2(log2(max(0.0f, _592 + (-0.8359375f)) / (18.8515625f - (_592 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _606 = mad(0.20700000226497650146484375f, _601, mad(-1.32700002193450927734375f, _588, _575 * 207.100006103515625f));
            float _612 = mad(-0.04500000178813934326171875f, _601, mad(0.6809999942779541015625f, _588, _575 * 36.5f));
            float _617 = mad(1.1879999637603759765625f, _601, mad(-0.0500000007450580596923828125f, _588, _575 * (-4.900000095367431640625f)));
            _417 = mad(-0.498610794544219970703125f, _617, mad(-1.53738319873809814453125f, _612, _606 * 3.2409698963165283203125f));
            _419 = mad(0.0415550954639911651611328125f, _617, mad(1.8759677410125732421875f, _612, _606 * (-0.969243705272674560546875f)));
            _421 = mad(1.05697143077850341796875f, _617, mad(-0.2039768397808074951171875f, _612, _606 * 0.0556300692260265350341796875f));
        }
        float _730;
        float _734;
        float _738;
        if (_386 == 1.0f)
        {
            float _642 = mad(0.043313600122928619384765625f, _421, mad(0.329281985759735107421875f, _419, _417 * 0.6274039745330810546875f));
            float _648 = mad(0.0113612003624439239501953125f, _421, mad(0.919539988040924072265625f, _419, _417 * 0.06909699738025665283203125f));
            float _654 = mad(0.895595014095306396484375f, _421, mad(0.0880132019519805908203125f, _419, _417 * 0.01639159955084323883056640625f));
            float _680 = 10000.0f / HDRMapping_m0[10u].y;
            float _690 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_417 - _642)) + _642) * HDRMapping_m0[7u].y) / _680, 0.0f, 1.0f)) * 0.1593017578125f);
            float _699 = clamp(exp2(log2(((_690 * 18.8515625f) + 0.8359375f) / ((_690 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _702 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_419 - _648)) + _648) * HDRMapping_m0[7u].y) / _680, 0.0f, 1.0f)) * 0.1593017578125f);
            float _711 = clamp(exp2(log2(((_702 * 18.8515625f) + 0.8359375f) / ((_702 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _714 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_421 - _654)) + _654) * HDRMapping_m0[7u].y) / _680, 0.0f, 1.0f)) * 0.1593017578125f);
            float _723 = clamp(exp2(log2(((_714 * 18.8515625f) + 0.8359375f) / ((_714 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_21_19_ladder;
            float frontier_phi_21_19_ladder_1;
            float frontier_phi_21_19_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_21_19_ladder = _699;
                frontier_phi_21_19_ladder_1 = _723;
                frontier_phi_21_19_ladder_2 = _711;
            }
            else
            {
                float _755 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _764 = clamp(exp2(log2(((_755 * 18.8515625f) + 0.8359375f) / ((_755 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _770 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _780 = _764 - clamp(exp2(log2(((_770 * 18.8515625f) + 0.8359375f) / ((_770 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _784 = clamp(_699 / _764, 0.0f, 1.0f);
                float _785 = clamp(_711 / _764, 0.0f, 1.0f);
                float _786 = clamp(_723 / _764, 0.0f, 1.0f);
                frontier_phi_21_19_ladder = min((((2.0f - (_784 + _784)) * _780) + (_784 * _764)) * _784, _699);
                frontier_phi_21_19_ladder_1 = min((((2.0f - (_786 + _786)) * _780) + (_786 * _764)) * _786, _723);
                frontier_phi_21_19_ladder_2 = min((((2.0f - (_785 + _785)) * _780) + (_785 * _764)) * _785, _711);
            }
            _730 = frontier_phi_21_19_ladder;
            _734 = frontier_phi_21_19_ladder_2;
            _738 = frontier_phi_21_19_ladder_1;
        }
        else
        {
            bool _806;
            if (_409)
            {
                _806 = !_408;
            }
            else
            {
                _806 = false;
            }
            float4 _811 = RWResult[uint2(uint(_83), uint(_88))].xxxx;
            float _825 = exp2(log2(clamp(_811.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _826 = exp2(log2(clamp(_811.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _827 = exp2(log2(clamp(_811.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _855 = 10000.0f / HDRMapping_m0[10u].y;
            float _856 = _855 * exp2(log2(max(0.0f, _825 + (-0.8359375f)) / (18.8515625f - (_825 * 18.6875f))) * 6.277394771575927734375f);
            float _857 = _855 * exp2(log2(max(0.0f, _826 + (-0.8359375f)) / (18.8515625f - (_826 * 18.6875f))) * 6.277394771575927734375f);
            float _858 = _855 * exp2(log2(max(0.0f, _827 + (-0.8359375f)) / (18.8515625f - (_827 * 18.6875f))) * 6.277394771575927734375f);
            float _863 = mad(-0.07285170257091522216796875f, _858, mad(-0.587639987468719482421875f, _857, _856 * 1.66049098968505859375f));
            float _869 = mad(-0.008348000235855579376220703125f, _858, mad(1.1328999996185302734375f, _857, _856 * (-0.12454999983310699462890625f)));
            float _875 = mad(1.11872994899749755859375f, _858, mad(-0.100579001009464263916015625f, _857, _856 * (-0.01815100014209747314453125f)));
            float _877;
            float _879;
            float _881;
            if (_806)
            {
                _877 = _417;
                _879 = _419;
                _881 = _421;
            }
            else
            {
                _877 = (_417 - _863) * _386;
                _879 = (_419 - _869) * _386;
                _881 = (_421 - _875) * _386;
            }
            float _883 = _877 + _863;
            float _884 = _879 + _869;
            float _885 = _881 + _875;
            float _888 = mad(0.043313600122928619384765625f, _885, mad(0.329281985759735107421875f, _884, _883 * 0.6274039745330810546875f));
            float _891 = mad(0.0113612003624439239501953125f, _885, mad(0.919539988040924072265625f, _884, _883 * 0.06909699738025665283203125f));
            float _894 = mad(0.895595014095306396484375f, _885, mad(0.0880132019519805908203125f, _884, _883 * 0.01639159955084323883056640625f));
            float _927 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_883 - _888)) + _888) * HDRMapping_m0[7u].y) / _855, 0.0f, 1.0f)) * 0.1593017578125f);
            float _733 = clamp(exp2(log2(((_927 * 18.8515625f) + 0.8359375f) / ((_927 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _938 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_884 - _891)) + _891) * HDRMapping_m0[7u].y) / _855, 0.0f, 1.0f)) * 0.1593017578125f);
            float _737 = clamp(exp2(log2(((_938 * 18.8515625f) + 0.8359375f) / ((_938 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _949 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_885 - _894)) + _894) * HDRMapping_m0[7u].y) / _855, 0.0f, 1.0f)) * 0.1593017578125f);
            float _741 = clamp(exp2(log2(((_949 * 18.8515625f) + 0.8359375f) / ((_949 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_21_25_ladder;
            float frontier_phi_21_25_ladder_1;
            float frontier_phi_21_25_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_21_25_ladder = _733;
                frontier_phi_21_25_ladder_1 = _741;
                frontier_phi_21_25_ladder_2 = _737;
            }
            else
            {
                float _974 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _983 = clamp(exp2(log2(((_974 * 18.8515625f) + 0.8359375f) / ((_974 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _989 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _999 = _983 - clamp(exp2(log2(((_989 * 18.8515625f) + 0.8359375f) / ((_989 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _1003 = clamp(_733 / _983, 0.0f, 1.0f);
                float _1004 = clamp(_737 / _983, 0.0f, 1.0f);
                float _1005 = clamp(_741 / _983, 0.0f, 1.0f);
                frontier_phi_21_25_ladder = min((((2.0f - (_1003 + _1003)) * _999) + (_1003 * _983)) * _1003, _733);
                frontier_phi_21_25_ladder_1 = min((((2.0f - (_1005 + _1005)) * _999) + (_1005 * _983)) * _1005, _741);
                frontier_phi_21_25_ladder_2 = min((((2.0f - (_1004 + _1004)) * _999) + (_1004 * _983)) * _1004, _737);
            }
            _730 = frontier_phi_21_25_ladder;
            _734 = frontier_phi_21_25_ladder_2;
            _738 = frontier_phi_21_25_ladder_1;
        }
        RWResult[uint2(uint(_83), uint(_88))] = float4(_730, _734, _738, _730).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
