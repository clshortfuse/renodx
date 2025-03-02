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

Texture2D<float4> primSceneTex : register(t0, space0);
Texture2D<float4> Tex2D : register(t1, space0);
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
    uint _55 = uint(gl_LocalInvocationID.x);
    uint _58 = _55 >> 1u;
    uint _62 = _55 >> 2u;
    uint _66 = _55 >> 3u;
    uint _77 = ((((_55 & 1u) | (uint(gl_WorkGroupID.x) << 4u)) | (_58 & 2u)) | (_62 & 4u)) | (_66 & 8u);
    uint _82 = ((((_58 & 1u) | (uint(gl_WorkGroupID.y) << 4u)) | (_62 & 2u)) | (_66 & 4u)) | ((_55 >> 4u) & 8u);
    float _85 = float(_77) + 0.5f;
    float _87 = float(_82) + 0.5f;
    uint _106_dummy_parameter;
    uint2 _106 = spvTextureSize(primSceneTex, 0u, _106_dummy_parameter);
    float _110 = float(int(_106.y));
    float _112 = _110 / SceneInfo_m0[23u].y;
    float4 _121 = primSceneTex.SampleLevel(TrilinearClamp, float2(_85 * (_112 / float(int(_106.x))), (_112 / _110) * _87), 1.0f);
    uint _128_dummy_parameter;
    uint2 _128 = spvTextureSize(Tex2D, 0u, _128_dummy_parameter);
    float4 _170 = Tex2D.SampleGrad(BilinearWrap, float2((UserMaterial_m0[5u].y * (((UserMaterial_m0[1u].z * SceneInfo_m0[23u].z) * _85) + UserMaterial_m0[1u].x)) * (1.0f / float(_128.x)), (UserMaterial_m0[5u].y * (((UserMaterial_m0[1u].w * SceneInfo_m0[23u].w) * _87) + UserMaterial_m0[1u].y)) * (1.0f / float(_128.y))), 0.0f.xx, 0.0f.xx);
    float _174 = _170.x;
    float _175 = _170.y;
    float _176 = _170.z;
    float _177 = _170.w;
    float _191 = (UserMaterial_m0[4u].w * UserMaterial_m0[2u].x) + max((exp2(log2(_121.x) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
    float _193 = (UserMaterial_m0[4u].w * UserMaterial_m0[2u].y) + max((exp2(log2(_121.y) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
    float _195 = (UserMaterial_m0[4u].w * UserMaterial_m0[2u].z) + max((exp2(log2(_121.z) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
    float _214 = ((_191 * _174) + UserMaterial_m0[3u].x) + ((_174 * (UserMaterial_m0[2u].x - _191)) * UserMaterial_m0[5u].x);
    float _216 = ((_193 * _175) + UserMaterial_m0[3u].y) + ((_175 * (UserMaterial_m0[2u].y - _193)) * UserMaterial_m0[5u].x);
    float _218 = ((_195 * _176) + UserMaterial_m0[3u].z) + ((_176 * (UserMaterial_m0[2u].z - _195)) * UserMaterial_m0[5u].x);
    float _237;
    float _238;
    float _239;
    if (_177 > 0.0f)
    {
        float _233 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _177)) + _177);
        _237 = _233 * _214;
        _238 = _233 * _216;
        _239 = _233 * _218;
    }
    else
    {
        _237 = _214;
        _238 = _216;
        _239 = _218;
    }
    bool _242 = max(max(_237, _238), _239) == 0.0f;
    bool _243 = _177 == 0.0f;
    if (!(_243 && _242))
    {
        float _251;
        float _253;
        float _255;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _251 = _237;
            _253 = _238;
            _255 = _239;
        }
        else
        {
            float _284 = exp2(log2(mad(0.0810546875f, _239, mad(0.623046875f, _238, _237 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _297 = clamp(exp2(log2(((_284 * 18.8515625f) + 0.8359375f) / ((_284 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _301 = exp2(log2(mad(0.116455078125f, _239, mad(0.727294921875f, _238, _237 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _310 = clamp(exp2(log2(((_301 * 18.8515625f) + 0.8359375f) / ((_301 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _314 = exp2(log2(mad(0.808349609375f, _239, mad(0.156494140625f, _238, _237 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _323 = clamp(exp2(log2(((_314 * 18.8515625f) + 0.8359375f) / ((_314 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _325 = (_310 + _297) * 0.5f;
            float _346 = exp2(log2(clamp(_325, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _357 = exp2(log2(max(0.0f, _346 + (-0.8359375f)) / (18.8515625f - (_346 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _372 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _357) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _177) * _357) + 1.0f)) * 0.1593017578125f);
            float _381 = clamp(exp2(log2(((_372 * 18.8515625f) + 0.8359375f) / ((_372 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _384 = min(_325 / _381, _381 / _325);
            float _385 = ((dot(float3(_297, _310, _323), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _384;
            float _386 = ((dot(float3(_297, _310, _323), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _384;
            float _402 = exp2(log2(clamp(mad(0.111000001430511474609375f, _386, mad(0.0089999996125698089599609375f, _385, _381)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _410 = exp2(log2(max(0.0f, _402 + (-0.8359375f)) / (18.8515625f - (_402 * 18.6875f))) * 6.277394771575927734375f);
            float _414 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _386, mad(-0.0089999996125698089599609375f, _385, _381)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _423 = exp2(log2(max(0.0f, _414 + (-0.8359375f)) / (18.8515625f - (_414 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _427 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _386, mad(0.560000002384185791015625f, _385, _381)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _436 = exp2(log2(max(0.0f, _427 + (-0.8359375f)) / (18.8515625f - (_427 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _441 = mad(0.20700000226497650146484375f, _436, mad(-1.32700002193450927734375f, _423, _410 * 207.100006103515625f));
            float _447 = mad(-0.04500000178813934326171875f, _436, mad(0.6809999942779541015625f, _423, _410 * 36.5f));
            float _453 = mad(1.1879999637603759765625f, _436, mad(-0.0500000007450580596923828125f, _423, _410 * (-4.900000095367431640625f)));
            _251 = mad(-0.498610794544219970703125f, _453, mad(-1.53738319873809814453125f, _447, _441 * 3.2409698963165283203125f));
            _253 = mad(0.0415550954639911651611328125f, _453, mad(1.8759677410125732421875f, _447, _441 * (-0.969243705272674560546875f)));
            _255 = mad(1.05697143077850341796875f, _453, mad(-0.2039768397808074951171875f, _447, _441 * 0.0556300692260265350341796875f));
        }
        float _567;
        float _571;
        float _575;
        if (_177 == 1.0f)
        {
            float _478 = mad(0.043313600122928619384765625f, _255, mad(0.329281985759735107421875f, _253, _251 * 0.6274039745330810546875f));
            float _484 = mad(0.0113612003624439239501953125f, _255, mad(0.919539988040924072265625f, _253, _251 * 0.06909699738025665283203125f));
            float _490 = mad(0.895595014095306396484375f, _255, mad(0.0880132019519805908203125f, _253, _251 * 0.01639159955084323883056640625f));
            float _517 = 10000.0f / HDRMapping_m0[10u].y;
            float _527 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_251 - _478)) + _478) * HDRMapping_m0[7u].y) / _517, 0.0f, 1.0f)) * 0.1593017578125f);
            float _536 = clamp(exp2(log2(((_527 * 18.8515625f) + 0.8359375f) / ((_527 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _539 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_253 - _484)) + _484) * HDRMapping_m0[7u].y) / _517, 0.0f, 1.0f)) * 0.1593017578125f);
            float _548 = clamp(exp2(log2(((_539 * 18.8515625f) + 0.8359375f) / ((_539 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _551 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_255 - _490)) + _490) * HDRMapping_m0[7u].y) / _517, 0.0f, 1.0f)) * 0.1593017578125f);
            float _560 = clamp(exp2(log2(((_551 * 18.8515625f) + 0.8359375f) / ((_551 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_7_ladder;
            float frontier_phi_9_7_ladder_1;
            float frontier_phi_9_7_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_7_ladder = _536;
                frontier_phi_9_7_ladder_1 = _548;
                frontier_phi_9_7_ladder_2 = _560;
            }
            else
            {
                float _592 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _601 = clamp(exp2(log2(((_592 * 18.8515625f) + 0.8359375f) / ((_592 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _607 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _617 = _601 - clamp(exp2(log2(((_607 * 18.8515625f) + 0.8359375f) / ((_607 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _621 = clamp(_536 / _601, 0.0f, 1.0f);
                float _622 = clamp(_548 / _601, 0.0f, 1.0f);
                float _623 = clamp(_560 / _601, 0.0f, 1.0f);
                frontier_phi_9_7_ladder = min((((2.0f - (_621 + _621)) * _617) + (_621 * _601)) * _621, _536);
                frontier_phi_9_7_ladder_1 = min((((2.0f - (_622 + _622)) * _617) + (_622 * _601)) * _622, _548);
                frontier_phi_9_7_ladder_2 = min((((2.0f - (_623 + _623)) * _617) + (_623 * _601)) * _623, _560);
            }
            _567 = frontier_phi_9_7_ladder;
            _571 = frontier_phi_9_7_ladder_1;
            _575 = frontier_phi_9_7_ladder_2;
        }
        else
        {
            bool _644;
            if (_243)
            {
                _644 = !_242;
            }
            else
            {
                _644 = false;
            }
            float4 _649 = RWResult[uint2(uint(_77), uint(_82))].xxxx;
            float _663 = exp2(log2(clamp(_649.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _664 = exp2(log2(clamp(_649.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _665 = exp2(log2(clamp(_649.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _693 = 10000.0f / HDRMapping_m0[10u].y;
            float _694 = _693 * exp2(log2(max(0.0f, _663 + (-0.8359375f)) / (18.8515625f - (_663 * 18.6875f))) * 6.277394771575927734375f);
            float _695 = _693 * exp2(log2(max(0.0f, _664 + (-0.8359375f)) / (18.8515625f - (_664 * 18.6875f))) * 6.277394771575927734375f);
            float _696 = _693 * exp2(log2(max(0.0f, _665 + (-0.8359375f)) / (18.8515625f - (_665 * 18.6875f))) * 6.277394771575927734375f);
            float _701 = mad(-0.07285170257091522216796875f, _696, mad(-0.587639987468719482421875f, _695, _694 * 1.66049098968505859375f));
            float _707 = mad(-0.008348000235855579376220703125f, _696, mad(1.1328999996185302734375f, _695, _694 * (-0.12454999983310699462890625f)));
            float _713 = mad(1.11872994899749755859375f, _696, mad(-0.100579001009464263916015625f, _695, _694 * (-0.01815100014209747314453125f)));
            float _715;
            float _717;
            float _719;
            if (_644)
            {
                _715 = _251;
                _717 = _253;
                _719 = _255;
            }
            else
            {
                _715 = (_251 - _701) * _177;
                _717 = (_253 - _707) * _177;
                _719 = (_255 - _713) * _177;
            }
            float _721 = _715 + _701;
            float _722 = _717 + _707;
            float _723 = _719 + _713;
            float _726 = mad(0.043313600122928619384765625f, _723, mad(0.329281985759735107421875f, _722, _721 * 0.6274039745330810546875f));
            float _729 = mad(0.0113612003624439239501953125f, _723, mad(0.919539988040924072265625f, _722, _721 * 0.06909699738025665283203125f));
            float _732 = mad(0.895595014095306396484375f, _723, mad(0.0880132019519805908203125f, _722, _721 * 0.01639159955084323883056640625f));
            float _765 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_721 - _726)) + _726) * HDRMapping_m0[7u].y) / _693, 0.0f, 1.0f)) * 0.1593017578125f);
            float _570 = clamp(exp2(log2(((_765 * 18.8515625f) + 0.8359375f) / ((_765 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _776 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_722 - _729)) + _729) * HDRMapping_m0[7u].y) / _693, 0.0f, 1.0f)) * 0.1593017578125f);
            float _574 = clamp(exp2(log2(((_776 * 18.8515625f) + 0.8359375f) / ((_776 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _787 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_723 - _732)) + _732) * HDRMapping_m0[7u].y) / _693, 0.0f, 1.0f)) * 0.1593017578125f);
            float _578 = clamp(exp2(log2(((_787 * 18.8515625f) + 0.8359375f) / ((_787 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_13_ladder;
            float frontier_phi_9_13_ladder_1;
            float frontier_phi_9_13_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_13_ladder = _570;
                frontier_phi_9_13_ladder_1 = _574;
                frontier_phi_9_13_ladder_2 = _578;
            }
            else
            {
                float _812 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _821 = clamp(exp2(log2(((_812 * 18.8515625f) + 0.8359375f) / ((_812 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _827 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _837 = _821 - clamp(exp2(log2(((_827 * 18.8515625f) + 0.8359375f) / ((_827 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _841 = clamp(_570 / _821, 0.0f, 1.0f);
                float _842 = clamp(_574 / _821, 0.0f, 1.0f);
                float _843 = clamp(_578 / _821, 0.0f, 1.0f);
                frontier_phi_9_13_ladder = min((((2.0f - (_841 + _841)) * _837) + (_841 * _821)) * _841, _570);
                frontier_phi_9_13_ladder_1 = min((((2.0f - (_842 + _842)) * _837) + (_842 * _821)) * _842, _574);
                frontier_phi_9_13_ladder_2 = min((((2.0f - (_843 + _843)) * _837) + (_843 * _821)) * _843, _578);
            }
            _567 = frontier_phi_9_13_ladder;
            _571 = frontier_phi_9_13_ladder_1;
            _575 = frontier_phi_9_13_ladder_2;
        }
        RWResult[uint2(uint(_77), uint(_82))] = float4(_567, _571, _575, _567).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
