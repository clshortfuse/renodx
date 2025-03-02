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
    float4 UserMaterial_m0[7] : packoffset(c0);
};

Texture2D<float4> Tex2D_0 : register(t0, space0);
Texture2D<float4> Tex2D_1 : register(t1, space0);
Texture2D<float4> Tex2D_2 : register(t2, space0);
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
    float _101 = _99 * 2.0f;
    float _103 = _100 * 2.0f;
    float _111 = floor(clamp(_101, 0.0f, 1.0f)) + (-0.5f);
    float _113 = floor(clamp(_103, 0.0f, 1.0f)) + (-0.5f);
    float _129 = max(UserMaterial_m0[3u].x * 0.0024999999441206455230712890625f, 0.5f);
    float _130 = max(UserMaterial_m0[3u].y * 0.0024999999441206455230712890625f, 0.5f);
    float _131 = _99 * _129;
    float _132 = _100 * _130;
    float _133 = _101 + (-1.0f);
    float _135 = _103 + (-1.0f);
    float _141 = UserMaterial_m0[6u].z * 0.20000000298023223876953125f;
    float _169 = clamp((sqrt((((_99 * 6.0f) + (-3.0f)) + _133) * _133) + (-0.20000000298023223876953125f)) * 1.25f, 0.0f, 1.0f);
    float _177 = clamp((sqrt((((_100 * 6.0f) + (-3.0f)) + _135) * _135) + (-0.20000000298023223876953125f)) * 1.25f, 0.0f, 1.0f);
    float _208 = frac(EnvironmentInfo_m0[4u].y * (-1.9999999494757503271102905273438e-05f)) * (-6.283185482025146484375f);
    float _210 = sin(_208);
    float _211 = cos(_208);
    float _215 = (_99 + (-0.5f)) * _129;
    float _217 = (_100 + (-0.5f)) * _130;
    float _233 = ((((_169 * _169) * (3.0f - (_169 * 2.0f))) * Tex2D_1.SampleGrad(BilinearWrap, float2(_131, (((_111 * (-2.0f)) * _141) + _132) + frac(EnvironmentInfo_m0[4u].y / (_111 * (-60000.0f)))), 0.0f.xx, 0.0f.xx).x) + (((_177 * _177) * (3.0f - (_177 * 2.0f))) * Tex2D_1.SampleGrad(BilinearWrap, float2((((_113 * 2.0f) * _141) + _131) + frac(EnvironmentInfo_m0[4u].y / (_113 * 60000.0f)), _132), 0.0f.xx, 0.0f.xx).x)) * 0.25f;
    float _235 = round(UserMaterial_m0[3u].x);
    float _236 = round(UserMaterial_m0[3u].y);
    float _237 = 31.0f / _236;
    float _239 = 31.0f / _235;
    float _253 = (_237 < _100) ? 0.0f : 1.0f;
    float _271 = (frac((_235 / (_235 * 0.03125f)) * (_99 - _239)) * 0.03125f) + 0.484375f;
    float _278 = (frac((_236 / (_236 * 0.03125f)) * (_100 - _237)) * 0.03125f) + 0.484375f;
    float _283 = ((((_99 * 0.015625f) * _235) - _271) * ((_239 < _99) ? 0.0f : 1.0f)) + _271;
    float _286 = (((((_100 * 0.015625f) * _236) * _253) - _278) * _253) + _278;
    float4 _313 = Tex2D_1.SampleGrad(BilinearWrap, float2((dot(float4(_215, _217, 0.0f, 0.0f), float4(_211, _210, 0.0f, 0.0f)) + (_129 * 0.5f)) + _233, (_233 + (_130 * 0.5f)) + dot(float4(_215, _217, 0.0f, 0.0f), float4((-0.0f) - _210, _211, 0.0f, 0.0f))), 0.0f.xx, 0.0f.xx);
    float _317 = _313.x;
    float4 _320 = Tex2D_0.SampleGrad(BilinearWrap, float2(((((((_99 + (-1.0f)) * 0.015625f) * _235) + 1.0f) - _283) * ((_99 < (1.0f - _239)) ? 0.0f : 1.0f)) + _283, ((((((_100 + (-1.0f)) * 0.015625f) * _236) + 1.0f) - _286) * ((_100 < (1.0f - _237)) ? 0.0f : 1.0f)) + _286), 0.0f.xx, 0.0f.xx);
    float _324 = _320.x;
    float _412 = clamp((abs((frac(UserMaterial_m0[5u].z + 0.18527777493000030517578125f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f);
    float _413 = clamp((abs((frac(UserMaterial_m0[5u].z + 0.851944446563720703125f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f);
    float _414 = clamp((abs((frac(UserMaterial_m0[5u].z + 0.518611133098602294921875f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f);
    float _418 = 1.7999999523162841796875f - UserMaterial_m0[6u].z;
    float _422 = _317 * _317;
    float _432 = clamp(_324 * 10.0f, 0.0f, 1.0f);
    float _442 = ((((clamp((abs((frac(UserMaterial_m0[5u].z + 0.20861111581325531005859375f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f) * 0.52457511425018310546875f) - _412) + (((((clamp((abs((frac(UserMaterial_m0[5u].z + 0.13875205814838409423828125f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f) + (-1.0f)) * 0.7960784435272216796875f) + 1.0f) * _422) * _418)) * _432) + _412;
    float _443 = ((((clamp((abs((frac(UserMaterial_m0[5u].z + 0.875277817249298095703125f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f) * 0.52457511425018310546875f) - _413) + (((((clamp((abs((frac(UserMaterial_m0[5u].z + 0.8054187297821044921875f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f) + (-1.0f)) * 0.7960784435272216796875f) + 1.0f) * _422) * _418)) * _432) + _413;
    float _444 = ((((clamp((abs((frac(UserMaterial_m0[5u].z + 0.541944444179534912109375f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f) * 0.52457511425018310546875f) - _414) + (((((clamp((abs((frac(UserMaterial_m0[5u].z + 0.472085416316986083984375f) * 2.0f) + (-1.0f)) * 3.0f) + (-1.0f), 0.0f, 1.0f) + (-1.0f)) * 0.7960784435272216796875f) + 1.0f) * _422) * _418)) * _432) + _414;
    float _448 = ((_320.y * (1.0f - _324)) * ((UserMaterial_m0[4u].y * Tex2D_2.SampleGrad(BilinearWrap, float2((((_90 * 2.099999904632568359375f) * SceneInfo_m0[23u].x) * SceneInfo_m0[23u].w) * SceneInfo_m0[23u].z, (_92 * 2.099999904632568359375f) * SceneInfo_m0[23u].w), 0.0f.xx, 0.0f.xx).y) + UserMaterial_m0[4u].x)) + _324;
    float _466;
    float _467;
    float _468;
    if (_448 > 0.0f)
    {
        float _462 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _448)) + _448);
        _466 = _462 * _442;
        _467 = _462 * _443;
        _468 = _462 * _444;
    }
    else
    {
        _466 = _442;
        _467 = _443;
        _468 = _444;
    }
    bool _471 = max(max(_466, _467), _468) == 0.0f;
    bool _472 = _448 == 0.0f;
    if (!(_472 && _471))
    {
        float _480;
        float _482;
        float _484;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _480 = _466;
            _482 = _467;
            _484 = _468;
        }
        else
        {
            float _513 = exp2(log2(mad(0.0810546875f, _468, mad(0.623046875f, _467, _466 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _526 = clamp(exp2(log2(((_513 * 18.8515625f) + 0.8359375f) / ((_513 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _530 = exp2(log2(mad(0.116455078125f, _468, mad(0.727294921875f, _467, _466 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _539 = clamp(exp2(log2(((_530 * 18.8515625f) + 0.8359375f) / ((_530 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _543 = exp2(log2(mad(0.808349609375f, _468, mad(0.156494140625f, _467, _466 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _552 = clamp(exp2(log2(((_543 * 18.8515625f) + 0.8359375f) / ((_543 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _554 = (_539 + _526) * 0.5f;
            float _575 = exp2(log2(clamp(_554, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _586 = exp2(log2(max(0.0f, _575 + (-0.8359375f)) / (18.8515625f - (_575 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _600 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _586) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _448) * _586) + 1.0f)) * 0.1593017578125f);
            float _609 = clamp(exp2(log2(((_600 * 18.8515625f) + 0.8359375f) / ((_600 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _612 = min(_554 / _609, _609 / _554);
            float _613 = ((dot(float3(_526, _539, _552), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _612;
            float _614 = ((dot(float3(_526, _539, _552), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _612;
            float _630 = exp2(log2(clamp(mad(0.111000001430511474609375f, _614, mad(0.0089999996125698089599609375f, _613, _609)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _638 = exp2(log2(max(0.0f, _630 + (-0.8359375f)) / (18.8515625f - (_630 * 18.6875f))) * 6.277394771575927734375f);
            float _642 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _614, mad(-0.0089999996125698089599609375f, _613, _609)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _651 = exp2(log2(max(0.0f, _642 + (-0.8359375f)) / (18.8515625f - (_642 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _655 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _614, mad(0.560000002384185791015625f, _613, _609)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _664 = exp2(log2(max(0.0f, _655 + (-0.8359375f)) / (18.8515625f - (_655 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _669 = mad(0.20700000226497650146484375f, _664, mad(-1.32700002193450927734375f, _651, _638 * 207.100006103515625f));
            float _675 = mad(-0.04500000178813934326171875f, _664, mad(0.6809999942779541015625f, _651, _638 * 36.5f));
            float _681 = mad(1.1879999637603759765625f, _664, mad(-0.0500000007450580596923828125f, _651, _638 * (-4.900000095367431640625f)));
            _480 = mad(-0.498610794544219970703125f, _681, mad(-1.53738319873809814453125f, _675, _669 * 3.2409698963165283203125f));
            _482 = mad(0.0415550954639911651611328125f, _681, mad(1.8759677410125732421875f, _675, _669 * (-0.969243705272674560546875f)));
            _484 = mad(1.05697143077850341796875f, _681, mad(-0.2039768397808074951171875f, _675, _669 * 0.0556300692260265350341796875f));
        }
        float _795;
        float _799;
        float _803;
        if (_448 == 1.0f)
        {
            float _706 = mad(0.043313600122928619384765625f, _484, mad(0.329281985759735107421875f, _482, _480 * 0.6274039745330810546875f));
            float _712 = mad(0.0113612003624439239501953125f, _484, mad(0.919539988040924072265625f, _482, _480 * 0.06909699738025665283203125f));
            float _718 = mad(0.895595014095306396484375f, _484, mad(0.0880132019519805908203125f, _482, _480 * 0.01639159955084323883056640625f));
            float _744 = 10000.0f / HDRMapping_m0[10u].y;
            float _754 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_480 - _706)) + _706) * HDRMapping_m0[7u].y) / _744, 0.0f, 1.0f)) * 0.1593017578125f);
            float _763 = clamp(exp2(log2(((_754 * 18.8515625f) + 0.8359375f) / ((_754 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _766 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_482 - _712)) + _712) * HDRMapping_m0[7u].y) / _744, 0.0f, 1.0f)) * 0.1593017578125f);
            float _775 = clamp(exp2(log2(((_766 * 18.8515625f) + 0.8359375f) / ((_766 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _778 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_484 - _718)) + _718) * HDRMapping_m0[7u].y) / _744, 0.0f, 1.0f)) * 0.1593017578125f);
            float _787 = clamp(exp2(log2(((_778 * 18.8515625f) + 0.8359375f) / ((_778 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_7_ladder;
            float frontier_phi_9_7_ladder_1;
            float frontier_phi_9_7_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_7_ladder = _763;
                frontier_phi_9_7_ladder_1 = _775;
                frontier_phi_9_7_ladder_2 = _787;
            }
            else
            {
                float _821 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _830 = clamp(exp2(log2(((_821 * 18.8515625f) + 0.8359375f) / ((_821 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _836 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _846 = _830 - clamp(exp2(log2(((_836 * 18.8515625f) + 0.8359375f) / ((_836 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _850 = clamp(_763 / _830, 0.0f, 1.0f);
                float _851 = clamp(_775 / _830, 0.0f, 1.0f);
                float _852 = clamp(_787 / _830, 0.0f, 1.0f);
                frontier_phi_9_7_ladder = min((((2.0f - (_850 + _850)) * _846) + (_850 * _830)) * _850, _763);
                frontier_phi_9_7_ladder_1 = min((((2.0f - (_851 + _851)) * _846) + (_851 * _830)) * _851, _775);
                frontier_phi_9_7_ladder_2 = min((((2.0f - (_852 + _852)) * _846) + (_852 * _830)) * _852, _787);
            }
            _795 = frontier_phi_9_7_ladder;
            _799 = frontier_phi_9_7_ladder_1;
            _803 = frontier_phi_9_7_ladder_2;
        }
        else
        {
            bool _872;
            if (_472)
            {
                _872 = !_471;
            }
            else
            {
                _872 = false;
            }
            float4 _877 = RWResult[uint2(uint(_82), uint(_87))].xxxx;
            float _891 = exp2(log2(clamp(_877.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _892 = exp2(log2(clamp(_877.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _893 = exp2(log2(clamp(_877.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _921 = 10000.0f / HDRMapping_m0[10u].y;
            float _922 = _921 * exp2(log2(max(0.0f, _891 + (-0.8359375f)) / (18.8515625f - (_891 * 18.6875f))) * 6.277394771575927734375f);
            float _923 = _921 * exp2(log2(max(0.0f, _892 + (-0.8359375f)) / (18.8515625f - (_892 * 18.6875f))) * 6.277394771575927734375f);
            float _924 = _921 * exp2(log2(max(0.0f, _893 + (-0.8359375f)) / (18.8515625f - (_893 * 18.6875f))) * 6.277394771575927734375f);
            float _929 = mad(-0.07285170257091522216796875f, _924, mad(-0.587639987468719482421875f, _923, _922 * 1.66049098968505859375f));
            float _935 = mad(-0.008348000235855579376220703125f, _924, mad(1.1328999996185302734375f, _923, _922 * (-0.12454999983310699462890625f)));
            float _941 = mad(1.11872994899749755859375f, _924, mad(-0.100579001009464263916015625f, _923, _922 * (-0.01815100014209747314453125f)));
            float _943;
            float _945;
            float _947;
            if (_872)
            {
                _943 = _480;
                _945 = _482;
                _947 = _484;
            }
            else
            {
                _943 = (_480 - _929) * _448;
                _945 = (_482 - _935) * _448;
                _947 = (_484 - _941) * _448;
            }
            float _949 = _943 + _929;
            float _950 = _945 + _935;
            float _951 = _947 + _941;
            float _954 = mad(0.043313600122928619384765625f, _951, mad(0.329281985759735107421875f, _950, _949 * 0.6274039745330810546875f));
            float _957 = mad(0.0113612003624439239501953125f, _951, mad(0.919539988040924072265625f, _950, _949 * 0.06909699738025665283203125f));
            float _960 = mad(0.895595014095306396484375f, _951, mad(0.0880132019519805908203125f, _950, _949 * 0.01639159955084323883056640625f));
            float _993 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_949 - _954)) + _954) * HDRMapping_m0[7u].y) / _921, 0.0f, 1.0f)) * 0.1593017578125f);
            float _798 = clamp(exp2(log2(((_993 * 18.8515625f) + 0.8359375f) / ((_993 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _1004 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_950 - _957)) + _957) * HDRMapping_m0[7u].y) / _921, 0.0f, 1.0f)) * 0.1593017578125f);
            float _802 = clamp(exp2(log2(((_1004 * 18.8515625f) + 0.8359375f) / ((_1004 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _1015 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_951 - _960)) + _960) * HDRMapping_m0[7u].y) / _921, 0.0f, 1.0f)) * 0.1593017578125f);
            float _806 = clamp(exp2(log2(((_1015 * 18.8515625f) + 0.8359375f) / ((_1015 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_9_13_ladder;
            float frontier_phi_9_13_ladder_1;
            float frontier_phi_9_13_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_9_13_ladder = _798;
                frontier_phi_9_13_ladder_1 = _802;
                frontier_phi_9_13_ladder_2 = _806;
            }
            else
            {
                float _1040 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _1049 = clamp(exp2(log2(((_1040 * 18.8515625f) + 0.8359375f) / ((_1040 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _1055 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _1065 = _1049 - clamp(exp2(log2(((_1055 * 18.8515625f) + 0.8359375f) / ((_1055 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _1069 = clamp(_798 / _1049, 0.0f, 1.0f);
                float _1070 = clamp(_802 / _1049, 0.0f, 1.0f);
                float _1071 = clamp(_806 / _1049, 0.0f, 1.0f);
                frontier_phi_9_13_ladder = min((((2.0f - (_1069 + _1069)) * _1065) + (_1069 * _1049)) * _1069, _798);
                frontier_phi_9_13_ladder_1 = min((((2.0f - (_1070 + _1070)) * _1065) + (_1070 * _1049)) * _1070, _802);
                frontier_phi_9_13_ladder_2 = min((((2.0f - (_1071 + _1071)) * _1065) + (_1071 * _1049)) * _1071, _806);
            }
            _795 = frontier_phi_9_13_ladder;
            _799 = frontier_phi_9_13_ladder_1;
            _803 = frontier_phi_9_13_ladder_2;
        }
        RWResult[uint2(uint(_82), uint(_87))] = float4(_795, _799, _803, _795).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
