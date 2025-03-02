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
    float4 UserMaterial_m0[4] : packoffset(c0);
};

Texture2D<float4> _Texture2D : register(t0, space0);
Texture2D<float4> _Texture2D_1 : register(t1, space0);
Texture2D<float4> _Texture2D_2 : register(t2, space0);
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
    float _90 = float(_82) + 0.5f;
    float _92 = float(_87) + 0.5f;
    float _99 = _90 * SceneInfo_m0[23u].z;
    float _100 = _92 * SceneInfo_m0[23u].w;
    float _146 = (UserMaterial_m0[2u].z * _99) + (1.0f - frac(EnvironmentInfo_m0[4u].y / UserMaterial_m0[2u].x));
    float _157 = min(max(UserMaterial_m0[3u].x * (_100 - (UserMaterial_m0[2u].y * (_Texture2D_1.SampleGrad(BilinearWrap, float2(_99 * UserMaterial_m0[2u].w, _100), 0.0f.xx, 0.0f.xx).x + (-0.5f)))), 0.0f), 1.0f);
    float4 _160 = _Texture2D_2.SampleGrad(BilinearWrap, float2(frac(float(asuint(EnvironmentInfo_m0[0u]).x) * (-3.3333333703922107815742492675781e-05f)) + (((SceneInfo_m0[23u].w * SceneInfo_m0[23u].x) * SceneInfo_m0[23u].z) * _90), (SceneInfo_m0[23u].w * 3.0f) * _92), 0.0f.xx, 0.0f.xx);
    float _179 = 1.0f - _Texture2D.SampleGrad(BilinearWrap, float2(_146, _157), 0.0f.xx, 0.0f.xx).w;
    float4 _184 = _Texture2D.SampleGrad(BilinearWrap, float2((((_160.x + (-0.5f)) * 0.02999999932944774627685546875f) * _179) + _146, (((_160.y + (-0.5f)) * 0.02999999932944774627685546875f) * _179) + _157), 0.0f.xx, 0.0f.xx);
    float _188 = _184.x;
    float _206 = (UserMaterial_m0[0u].x * _188) + UserMaterial_m0[1u].x;
    float _207 = (UserMaterial_m0[0u].y * _184.y) + UserMaterial_m0[1u].y;
    float _208 = (UserMaterial_m0[0u].z * _184.z) + UserMaterial_m0[1u].z;
    float _209 = (_188 + _160.w) * _184.w;
    float _227;
    float _228;
    float _229;
    if (_209 > 0.0f)
    {
        float _223 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _209)) + _209);
        _227 = _223 * _206;
        _228 = _223 * _207;
        _229 = _223 * _208;
    }
    else
    {
        _227 = _206;
        _228 = _207;
        _229 = _208;
    }
    bool _232 = max(max(_227, _228), _229) == 0.0f;
    bool _233 = _209 == 0.0f;
    if (!(_233 && _232))
    {
        float _241;
        float _243;
        float _245;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _241 = _227;
            _243 = _228;
            _245 = _229;
        }
        else
        {
            float _274 = exp2(log2(mad(0.0810546875f, _229, mad(0.623046875f, _228, _227 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _287 = clamp(exp2(log2(((_274 * 18.8515625f) + 0.8359375f) / ((_274 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _291 = exp2(log2(mad(0.116455078125f, _229, mad(0.727294921875f, _228, _227 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _300 = clamp(exp2(log2(((_291 * 18.8515625f) + 0.8359375f) / ((_291 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _304 = exp2(log2(mad(0.808349609375f, _229, mad(0.156494140625f, _228, _227 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _313 = clamp(exp2(log2(((_304 * 18.8515625f) + 0.8359375f) / ((_304 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _315 = (_300 + _287) * 0.5f;
            float _336 = exp2(log2(clamp(_315, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _347 = exp2(log2(max(0.0f, _336 + (-0.8359375f)) / (18.8515625f - (_336 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _362 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _347) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _209) * _347) + 1.0f)) * 0.1593017578125f);
            float _371 = clamp(exp2(log2(((_362 * 18.8515625f) + 0.8359375f) / ((_362 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _374 = min(_315 / _371, _371 / _315);
            float _375 = ((dot(float3(_287, _300, _313), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _374;
            float _376 = ((dot(float3(_287, _300, _313), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _374;
            float _392 = exp2(log2(clamp(mad(0.111000001430511474609375f, _376, mad(0.0089999996125698089599609375f, _375, _371)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _400 = exp2(log2(max(0.0f, _392 + (-0.8359375f)) / (18.8515625f - (_392 * 18.6875f))) * 6.277394771575927734375f);
            float _404 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _376, mad(-0.0089999996125698089599609375f, _375, _371)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _413 = exp2(log2(max(0.0f, _404 + (-0.8359375f)) / (18.8515625f - (_404 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _417 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _376, mad(0.560000002384185791015625f, _375, _371)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _426 = exp2(log2(max(0.0f, _417 + (-0.8359375f)) / (18.8515625f - (_417 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _431 = mad(0.20700000226497650146484375f, _426, mad(-1.32700002193450927734375f, _413, _400 * 207.100006103515625f));
            float _437 = mad(-0.04500000178813934326171875f, _426, mad(0.6809999942779541015625f, _413, _400 * 36.5f));
            float _443 = mad(1.1879999637603759765625f, _426, mad(-0.0500000007450580596923828125f, _413, _400 * (-4.900000095367431640625f)));
            _241 = mad(-0.498610794544219970703125f, _443, mad(-1.53738319873809814453125f, _437, _431 * 3.2409698963165283203125f));
            _243 = mad(0.0415550954639911651611328125f, _443, mad(1.8759677410125732421875f, _437, _431 * (-0.969243705272674560546875f)));
            _245 = mad(1.05697143077850341796875f, _443, mad(-0.2039768397808074951171875f, _437, _431 * 0.0556300692260265350341796875f));
        }
        float _557;
        float _561;
        float _565;
        if (_209 == 1.0f)
        {
            float _468 = mad(0.043313600122928619384765625f, _245, mad(0.329281985759735107421875f, _243, _241 * 0.6274039745330810546875f));
            float _474 = mad(0.0113612003624439239501953125f, _245, mad(0.919539988040924072265625f, _243, _241 * 0.06909699738025665283203125f));
            float _480 = mad(0.895595014095306396484375f, _245, mad(0.0880132019519805908203125f, _243, _241 * 0.01639159955084323883056640625f));
            float _507 = 10000.0f / HDRMapping_m0[10u].y;
            float _517 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_241 - _468)) + _468) * HDRMapping_m0[7u].y) / _507, 0.0f, 1.0f)) * 0.1593017578125f);
            float _526 = clamp(exp2(log2(((_517 * 18.8515625f) + 0.8359375f) / ((_517 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _529 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_243 - _474)) + _474) * HDRMapping_m0[7u].y) / _507, 0.0f, 1.0f)) * 0.1593017578125f);
            float _538 = clamp(exp2(log2(((_529 * 18.8515625f) + 0.8359375f) / ((_529 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _541 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_245 - _480)) + _480) * HDRMapping_m0[7u].y) / _507, 0.0f, 1.0f)) * 0.1593017578125f);
            float _550 = clamp(exp2(log2(((_541 * 18.8515625f) + 0.8359375f) / ((_541 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_7_ladder;
            float frontier_phi_9_7_ladder_1;
            float frontier_phi_9_7_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_7_ladder = _526;
                frontier_phi_9_7_ladder_1 = _538;
                frontier_phi_9_7_ladder_2 = _550;
            }
            else
            {
                float _583 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _592 = clamp(exp2(log2(((_583 * 18.8515625f) + 0.8359375f) / ((_583 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _598 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _608 = _592 - clamp(exp2(log2(((_598 * 18.8515625f) + 0.8359375f) / ((_598 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _612 = clamp(_526 / _592, 0.0f, 1.0f);
                float _613 = clamp(_538 / _592, 0.0f, 1.0f);
                float _614 = clamp(_550 / _592, 0.0f, 1.0f);
                frontier_phi_9_7_ladder = min((((2.0f - (_612 + _612)) * _608) + (_612 * _592)) * _612, _526);
                frontier_phi_9_7_ladder_1 = min((((2.0f - (_613 + _613)) * _608) + (_613 * _592)) * _613, _538);
                frontier_phi_9_7_ladder_2 = min((((2.0f - (_614 + _614)) * _608) + (_614 * _592)) * _614, _550);
            }
            _557 = frontier_phi_9_7_ladder;
            _561 = frontier_phi_9_7_ladder_1;
            _565 = frontier_phi_9_7_ladder_2;
        }
        else
        {
            bool _635;
            if (_233)
            {
                _635 = !_232;
            }
            else
            {
                _635 = false;
            }
            float4 _640 = RWResult[uint2(uint(_82), uint(_87))].xxxx;
            float _654 = exp2(log2(clamp(_640.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _655 = exp2(log2(clamp(_640.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _656 = exp2(log2(clamp(_640.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _684 = 10000.0f / HDRMapping_m0[10u].y;
            float _685 = _684 * exp2(log2(max(0.0f, _654 + (-0.8359375f)) / (18.8515625f - (_654 * 18.6875f))) * 6.277394771575927734375f);
            float _686 = _684 * exp2(log2(max(0.0f, _655 + (-0.8359375f)) / (18.8515625f - (_655 * 18.6875f))) * 6.277394771575927734375f);
            float _687 = _684 * exp2(log2(max(0.0f, _656 + (-0.8359375f)) / (18.8515625f - (_656 * 18.6875f))) * 6.277394771575927734375f);
            float _692 = mad(-0.07285170257091522216796875f, _687, mad(-0.587639987468719482421875f, _686, _685 * 1.66049098968505859375f));
            float _698 = mad(-0.008348000235855579376220703125f, _687, mad(1.1328999996185302734375f, _686, _685 * (-0.12454999983310699462890625f)));
            float _704 = mad(1.11872994899749755859375f, _687, mad(-0.100579001009464263916015625f, _686, _685 * (-0.01815100014209747314453125f)));
            float _706;
            float _708;
            float _710;
            if (_635)
            {
                _706 = _241;
                _708 = _243;
                _710 = _245;
            }
            else
            {
                _706 = (_241 - _692) * _209;
                _708 = (_243 - _698) * _209;
                _710 = (_245 - _704) * _209;
            }
            float _712 = _706 + _692;
            float _713 = _708 + _698;
            float _714 = _710 + _704;
            float _717 = mad(0.043313600122928619384765625f, _714, mad(0.329281985759735107421875f, _713, _712 * 0.6274039745330810546875f));
            float _720 = mad(0.0113612003624439239501953125f, _714, mad(0.919539988040924072265625f, _713, _712 * 0.06909699738025665283203125f));
            float _723 = mad(0.895595014095306396484375f, _714, mad(0.0880132019519805908203125f, _713, _712 * 0.01639159955084323883056640625f));
            float _756 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_712 - _717)) + _717) * HDRMapping_m0[7u].y) / _684, 0.0f, 1.0f)) * 0.1593017578125f);
            float _560 = clamp(exp2(log2(((_756 * 18.8515625f) + 0.8359375f) / ((_756 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _767 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_713 - _720)) + _720) * HDRMapping_m0[7u].y) / _684, 0.0f, 1.0f)) * 0.1593017578125f);
            float _564 = clamp(exp2(log2(((_767 * 18.8515625f) + 0.8359375f) / ((_767 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _778 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_714 - _723)) + _723) * HDRMapping_m0[7u].y) / _684, 0.0f, 1.0f)) * 0.1593017578125f);
            float _568 = clamp(exp2(log2(((_778 * 18.8515625f) + 0.8359375f) / ((_778 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_13_ladder;
            float frontier_phi_9_13_ladder_1;
            float frontier_phi_9_13_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_13_ladder = _560;
                frontier_phi_9_13_ladder_1 = _564;
                frontier_phi_9_13_ladder_2 = _568;
            }
            else
            {
                float _803 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _812 = clamp(exp2(log2(((_803 * 18.8515625f) + 0.8359375f) / ((_803 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _818 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _828 = _812 - clamp(exp2(log2(((_818 * 18.8515625f) + 0.8359375f) / ((_818 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _832 = clamp(_560 / _812, 0.0f, 1.0f);
                float _833 = clamp(_564 / _812, 0.0f, 1.0f);
                float _834 = clamp(_568 / _812, 0.0f, 1.0f);
                frontier_phi_9_13_ladder = min((((2.0f - (_832 + _832)) * _828) + (_832 * _812)) * _832, _560);
                frontier_phi_9_13_ladder_1 = min((((2.0f - (_833 + _833)) * _828) + (_833 * _812)) * _833, _564);
                frontier_phi_9_13_ladder_2 = min((((2.0f - (_834 + _834)) * _828) + (_834 * _812)) * _834, _568);
            }
            _557 = frontier_phi_9_13_ladder;
            _561 = frontier_phi_9_13_ladder_1;
            _565 = frontier_phi_9_13_ladder_2;
        }
        RWResult[uint2(uint(_82), uint(_87))] = float4(_557, _561, _565, _557).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
