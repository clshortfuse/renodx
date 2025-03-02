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
    float4 UserMaterial_m0[11] : packoffset(c0);
};

Texture2D<float4> primSceneTex : register(t0, space0);
Texture2D<float4> Tex2D_0 : register(t1, space0);
Texture2D<float4> Tex2D_1 : register(t2, space0);
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
    float _93 = float(_88) + 0.5f;
    float _100 = _91 * SceneInfo_m0[23u].z;
    float _101 = _93 * SceneInfo_m0[23u].w;
    float _105 = ((SceneInfo_m0[23u].w * SceneInfo_m0[23u].x) * SceneInfo_m0[23u].z) * _91;
    float _106 = _100 + 1.0f;
    float _112 = sqrt((_106 * _106) + (_101 * _101));
    float _119 = clamp(((_101 + (-0.5f)) + _100) * 0.999999523162841796875f, 0.0f, 1.0f);
    float _125 = (_119 * _119) * (3.0f - (_119 * 2.0f));
    float4 _146 = Tex2D_0.SampleGrad(BilinearWrap, float2(_105 * 8.0f, _101 * 8.0f), 0.0f.xx, 0.0f.xx);
    float _151 = _146.x;
    float4 _152 = Tex2D_0.SampleGrad(BilinearWrap, float2(_105 * (-8.0f), _101 * (-8.0f)), 0.0f.xx, 0.0f.xx);
    float _156 = _152.x;
    float _165 = clamp(_156 + _151, 0.0f, 1.0f);
    float _240;
    float _241;
    float _242;
    if (UserMaterial_m0[10u].w > 0.0f)
    {
        _240 = UserMaterial_m0[8u].x;
        _241 = UserMaterial_m0[8u].y;
        _242 = UserMaterial_m0[8u].z;
    }
    else
    {
        uint _196_dummy_parameter;
        uint2 _196 = spvTextureSize(primSceneTex, 0u, _196_dummy_parameter);
        float _200 = float(int(_196.y));
        float _204 = _200 / SceneInfo_m0[23u].y;
        float4 _211 = primSceneTex.SampleLevel(TrilinearClamp, float2((_204 / float(int(_196.x))) * _91, (_204 / _200) * _93), 1.0f);
        _240 = max((exp2(log2(_211.x * ((_125 * 0.2733642756938934326171875f) + 0.4627451002597808837890625f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
        _241 = max((exp2(log2(_211.y * ((_125 * 0.2757305800914764404296875f) + 0.4392156898975372314453125f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
        _242 = max((exp2(log2(_211.z * ((_125 * 0.2649086415767669677734375f) + 0.3607843220233917236328125f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
    }
    float _248 = frac(EnvironmentInfo_m0[4u].y * 5.000000237487256526947021484375e-05f);
    float4 _261 = Tex2D_0.SampleGrad(BilinearWrap, float2(_248 - (_105 * 2.0f), (_248 + (-0.5f)) - (_101 * 2.0f)), 0.0f.xx, 0.0f.xx);
    float _265 = _261.x;
    float4 _280 = Tex2D_1.SampleGrad(BilinearWrap, float2(_105 * 5.0f, _101 * 5.0f), 0.0f.xx, 0.0f.xx);
    float _284 = _280.x;
    float _286 = (max(sin((frac(EnvironmentInfo_m0[4u].y * (-6.6666667407844215631484985351563e-05f)) * 6.280000209808349609375f) + _112), 0.0f) * _165) * UserMaterial_m0[9u].w;
    float _311 = (UserMaterial_m0[10u].w > 0.0f) ? 0.75f : 0.89999997615814208984375f;
    float _316 = ((_165 - _311) * _286) + _311;
    float _320 = min(max(1.0f - abs(_112 - (UserMaterial_m0[10u].x * 3.2000000476837158203125f)), 0.0f), 1.0f) * _165;
    float _343 = (_320 * (_165 - _316)) + _316;
    float _355 = (((UserMaterial_m0[6u].x + (-1.0f)) + ((UserMaterial_m0[7u].x - UserMaterial_m0[6u].x) * _125)) * 0.800000011920928955078125f) + (((_284 - _240) * 0.1500000059604644775390625f) + _240);
    float _356 = (((UserMaterial_m0[6u].y + (-1.0f)) + ((UserMaterial_m0[7u].y - UserMaterial_m0[6u].y) * _125)) * 0.800000011920928955078125f) + (((_284 - _241) * 0.1500000059604644775390625f) + _241);
    float _357 = (((UserMaterial_m0[6u].z + (-1.0f)) + ((UserMaterial_m0[7u].z - UserMaterial_m0[6u].z) * _125)) * 0.800000011920928955078125f) + (((_284 - _242) * 0.1500000059604644775390625f) + _242);
    float _358 = max(UserMaterial_m0[10u].x * _286, _320);
    float _365 = (((clamp((_156 * 0.5834286212921142578125f) + (_151 * 0.847058832645416259765625f), 0.0f, 1.0f) + _265) - _355) * _358) + _355;
    float _366 = (((clamp((_156 * 0.3925000131130218505859375f) + (_151 * 0.780392169952392578125f), 0.0f, 1.0f) + (_265 * 0.81176471710205078125f)) - _356) * _358) + _356;
    float _367 = (((clamp(_156 + (_151 * 0.18039216101169586181640625f), 0.0f, 1.0f) + (_265 * 0.596078455448150634765625f)) - _357) * _358) + _357;
    float _384;
    float _385;
    float _386;
    if (_343 > 0.0f)
    {
        float _380 = 1.0f / ((float((asuint(GUIConstant_m0[15u]).w >> 8u) & 1u) * (1.0f - _343)) + _343);
        _384 = _380 * _365;
        _385 = _380 * _366;
        _386 = _380 * _367;
    }
    else
    {
        _384 = _365;
        _385 = _366;
        _386 = _367;
    }
    bool _389 = max(max(_384, _385), _386) == 0.0f;
    bool _390 = _343 == 0.0f;
    if (!(_390 && _389))
    {
        float _398;
        float _400;
        float _402;
        if (asuint(HDRMapping_m0[14u]).y == 0u)
        {
            _398 = _384;
            _400 = _385;
            _402 = _386;
        }
        else
        {
            float _431 = exp2(log2(mad(0.0810546875f, _386, mad(0.623046875f, _385, _384 * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _444 = clamp(exp2(log2(((_431 * 18.8515625f) + 0.8359375f) / ((_431 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _448 = exp2(log2(mad(0.116455078125f, _386, mad(0.727294921875f, _385, _384 * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _457 = clamp(exp2(log2(((_448 * 18.8515625f) + 0.8359375f) / ((_448 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _461 = exp2(log2(mad(0.808349609375f, _386, mad(0.156494140625f, _385, _384 * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
            float _470 = clamp(exp2(log2(((_461 * 18.8515625f) + 0.8359375f) / ((_461 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _472 = (_457 + _444) * 0.5f;
            float _493 = exp2(log2(clamp(_472, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _504 = exp2(log2(max(0.0f, _493 + (-0.8359375f)) / (18.8515625f - (_493 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _518 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _504) * ((((HDRMapping_m0[14u].z + (-1.0f)) * _343) * _504) + 1.0f)) * 0.1593017578125f);
            float _527 = clamp(exp2(log2(((_518 * 18.8515625f) + 0.8359375f) / ((_518 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _530 = min(_472 / _527, _527 / _472);
            float _531 = ((dot(float3(_444, _457, _470), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _530;
            float _532 = ((dot(float3(_444, _457, _470), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _530;
            float _548 = exp2(log2(clamp(mad(0.111000001430511474609375f, _532, mad(0.0089999996125698089599609375f, _531, _527)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _556 = exp2(log2(max(0.0f, _548 + (-0.8359375f)) / (18.8515625f - (_548 * 18.6875f))) * 6.277394771575927734375f);
            float _560 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _532, mad(-0.0089999996125698089599609375f, _531, _527)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _569 = exp2(log2(max(0.0f, _560 + (-0.8359375f)) / (18.8515625f - (_560 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _573 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _532, mad(0.560000002384185791015625f, _531, _527)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _582 = exp2(log2(max(0.0f, _573 + (-0.8359375f)) / (18.8515625f - (_573 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
            float _587 = mad(0.20700000226497650146484375f, _582, mad(-1.32700002193450927734375f, _569, _556 * 207.100006103515625f));
            float _593 = mad(-0.04500000178813934326171875f, _582, mad(0.6809999942779541015625f, _569, _556 * 36.5f));
            float _599 = mad(1.1879999637603759765625f, _582, mad(-0.0500000007450580596923828125f, _569, _556 * (-4.900000095367431640625f)));
            _398 = mad(-0.498610794544219970703125f, _599, mad(-1.53738319873809814453125f, _593, _587 * 3.2409698963165283203125f));
            _400 = mad(0.0415550954639911651611328125f, _599, mad(1.8759677410125732421875f, _593, _587 * (-0.969243705272674560546875f)));
            _402 = mad(1.05697143077850341796875f, _599, mad(-0.2039768397808074951171875f, _593, _587 * 0.0556300692260265350341796875f));
        }
        float _712;
        float _716;
        float _720;
        if (_343 == 1.0f)
        {
            float _623 = mad(0.043313600122928619384765625f, _402, mad(0.329281985759735107421875f, _400, _398 * 0.6274039745330810546875f));
            float _629 = mad(0.0113612003624439239501953125f, _402, mad(0.919539988040924072265625f, _400, _398 * 0.06909699738025665283203125f));
            float _635 = mad(0.895595014095306396484375f, _402, mad(0.0880132019519805908203125f, _400, _398 * 0.01639159955084323883056640625f));
            float _661 = 10000.0f / HDRMapping_m0[10u].y;
            float _671 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_398 - _623)) + _623) * HDRMapping_m0[7u].y) / _661, 0.0f, 1.0f)) * 0.1593017578125f);
            float _680 = clamp(exp2(log2(((_671 * 18.8515625f) + 0.8359375f) / ((_671 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _683 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_400 - _629)) + _629) * HDRMapping_m0[7u].y) / _661, 0.0f, 1.0f)) * 0.1593017578125f);
            float _692 = clamp(exp2(log2(((_683 * 18.8515625f) + 0.8359375f) / ((_683 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _695 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_402 - _635)) + _635) * HDRMapping_m0[7u].y) / _661, 0.0f, 1.0f)) * 0.1593017578125f);
            float _704 = clamp(exp2(log2(((_695 * 18.8515625f) + 0.8359375f) / ((_695 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_12_10_ladder;
            float frontier_phi_12_10_ladder_1;
            float frontier_phi_12_10_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_12_10_ladder = _680;
                frontier_phi_12_10_ladder_1 = _692;
                frontier_phi_12_10_ladder_2 = _704;
            }
            else
            {
                float _737 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _746 = clamp(exp2(log2(((_737 * 18.8515625f) + 0.8359375f) / ((_737 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _752 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _762 = _746 - clamp(exp2(log2(((_752 * 18.8515625f) + 0.8359375f) / ((_752 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _766 = clamp(_680 / _746, 0.0f, 1.0f);
                float _767 = clamp(_692 / _746, 0.0f, 1.0f);
                float _768 = clamp(_704 / _746, 0.0f, 1.0f);
                frontier_phi_12_10_ladder = min((((2.0f - (_766 + _766)) * _762) + (_766 * _746)) * _766, _680);
                frontier_phi_12_10_ladder_1 = min((((2.0f - (_767 + _767)) * _762) + (_767 * _746)) * _767, _692);
                frontier_phi_12_10_ladder_2 = min((((2.0f - (_768 + _768)) * _762) + (_768 * _746)) * _768, _704);
            }
            _712 = frontier_phi_12_10_ladder;
            _716 = frontier_phi_12_10_ladder_1;
            _720 = frontier_phi_12_10_ladder_2;
        }
        else
        {
            bool _788;
            if (_390)
            {
                _788 = !_389;
            }
            else
            {
                _788 = false;
            }
            float4 _793 = RWResult[uint2(uint(_83), uint(_88))].xxxx;
            float _807 = exp2(log2(clamp(_793.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _808 = exp2(log2(clamp(_793.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _809 = exp2(log2(clamp(_793.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
            float _837 = 10000.0f / HDRMapping_m0[10u].y;
            float _838 = _837 * exp2(log2(max(0.0f, _807 + (-0.8359375f)) / (18.8515625f - (_807 * 18.6875f))) * 6.277394771575927734375f);
            float _839 = _837 * exp2(log2(max(0.0f, _808 + (-0.8359375f)) / (18.8515625f - (_808 * 18.6875f))) * 6.277394771575927734375f);
            float _840 = _837 * exp2(log2(max(0.0f, _809 + (-0.8359375f)) / (18.8515625f - (_809 * 18.6875f))) * 6.277394771575927734375f);
            float _845 = mad(-0.07285170257091522216796875f, _840, mad(-0.587639987468719482421875f, _839, _838 * 1.66049098968505859375f));
            float _851 = mad(-0.008348000235855579376220703125f, _840, mad(1.1328999996185302734375f, _839, _838 * (-0.12454999983310699462890625f)));
            float _857 = mad(1.11872994899749755859375f, _840, mad(-0.100579001009464263916015625f, _839, _838 * (-0.01815100014209747314453125f)));
            float _859;
            float _861;
            float _863;
            if (_788)
            {
                _859 = _398;
                _861 = _400;
                _863 = _402;
            }
            else
            {
                _859 = (_398 - _845) * _343;
                _861 = (_400 - _851) * _343;
                _863 = (_402 - _857) * _343;
            }
            float _865 = _859 + _845;
            float _866 = _861 + _851;
            float _867 = _863 + _857;
            float _870 = mad(0.043313600122928619384765625f, _867, mad(0.329281985759735107421875f, _866, _865 * 0.6274039745330810546875f));
            float _873 = mad(0.0113612003624439239501953125f, _867, mad(0.919539988040924072265625f, _866, _865 * 0.06909699738025665283203125f));
            float _876 = mad(0.895595014095306396484375f, _867, mad(0.0880132019519805908203125f, _866, _865 * 0.01639159955084323883056640625f));
            float _909 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_865 - _870)) + _870) * HDRMapping_m0[7u].y) / _837, 0.0f, 1.0f)) * 0.1593017578125f);
            float _715 = clamp(exp2(log2(((_909 * 18.8515625f) + 0.8359375f) / ((_909 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _920 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_866 - _873)) + _873) * HDRMapping_m0[7u].y) / _837, 0.0f, 1.0f)) * 0.1593017578125f);
            float _719 = clamp(exp2(log2(((_920 * 18.8515625f) + 0.8359375f) / ((_920 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float _931 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_867 - _876)) + _876) * HDRMapping_m0[7u].y) / _837, 0.0f, 1.0f)) * 0.1593017578125f);
            float _723 = clamp(exp2(log2(((_931 * 18.8515625f) + 0.8359375f) / ((_931 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
            float frontier_phi_12_16_ladder;
            float frontier_phi_12_16_ladder_1;
            float frontier_phi_12_16_ladder_2;
            if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
            {
                frontier_phi_12_16_ladder = _715;
                frontier_phi_12_16_ladder_1 = _719;
                frontier_phi_12_16_ladder_2 = _723;
            }
            else
            {
                float _956 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _965 = clamp(exp2(log2(((_956 * 18.8515625f) + 0.8359375f) / ((_956 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _971 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
                float _981 = _965 - clamp(exp2(log2(((_971 * 18.8515625f) + 0.8359375f) / ((_971 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
                float _985 = clamp(_715 / _965, 0.0f, 1.0f);
                float _986 = clamp(_719 / _965, 0.0f, 1.0f);
                float _987 = clamp(_723 / _965, 0.0f, 1.0f);
                frontier_phi_12_16_ladder = min((((2.0f - (_985 + _985)) * _981) + (_985 * _965)) * _985, _715);
                frontier_phi_12_16_ladder_1 = min((((2.0f - (_986 + _986)) * _981) + (_986 * _965)) * _986, _719);
                frontier_phi_12_16_ladder_2 = min((((2.0f - (_987 + _987)) * _981) + (_987 * _965)) * _987, _723);
            }
            _712 = frontier_phi_12_16_ladder;
            _716 = frontier_phi_12_16_ladder_1;
            _720 = frontier_phi_12_16_ladder_2;
        }
        RWResult[uint2(uint(_83), uint(_88))] = float4(_712, _716, _720, _712).x;
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
