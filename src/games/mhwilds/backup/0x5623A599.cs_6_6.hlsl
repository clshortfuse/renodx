cbuffer HDRMappingUBO : register(b0, space0)
{
    float4 HDRMapping_m0[15] : packoffset(c0);
};

cbuffer UserMaterialUBO : register(b1, space0)
{
    float4 UserMaterial_m0[1] : packoffset(c0);
};

RWTexture2D<float4> RWResult : register(u0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main()
{
    uint _36 = uint(gl_LocalInvocationID.x);
    uint _39 = _36 >> 1u;
    uint _43 = _36 >> 2u;
    uint _47 = _36 >> 3u;
    float _78;
    float _80;
    float _82;
    if (asuint(HDRMapping_m0[14u]).y == 0u)
    {
        _78 = UserMaterial_m0[0u].x;
        _80 = UserMaterial_m0[0u].y;
        _82 = UserMaterial_m0[0u].z;
    }
    else
    {
        float _216 = exp2(log2(mad(0.0810546875f, UserMaterial_m0[0u].z, mad(0.623046875f, UserMaterial_m0[0u].y, UserMaterial_m0[0u].x * 0.295654296875f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
        float _225 = clamp(exp2(log2(((_216 * 18.8515625f) + 0.8359375f) / ((_216 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
        float _229 = exp2(log2(mad(0.116455078125f, UserMaterial_m0[0u].z, mad(0.727294921875f, UserMaterial_m0[0u].y, UserMaterial_m0[0u].x * 0.15625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
        float _238 = clamp(exp2(log2(((_229 * 18.8515625f) + 0.8359375f) / ((_229 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
        float _242 = exp2(log2(mad(0.808349609375f, UserMaterial_m0[0u].z, mad(0.156494140625f, UserMaterial_m0[0u].y, UserMaterial_m0[0u].x * 0.03515625f)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
        float _251 = clamp(exp2(log2(((_242 * 18.8515625f) + 0.8359375f) / ((_242 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
        float _253 = (_238 + _225) * 0.5f;
        float _275 = exp2(log2(clamp(_253, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
        float _286 = exp2(log2(max(0.0f, _275 + (-0.8359375f)) / (18.8515625f - (_275 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
        float _300 = exp2(log2(((HDRMapping_m0[14u].z * 0.00999999977648258209228515625f) * _286) * ((_286 * (HDRMapping_m0[14u].z + (-1.0f))) + 1.0f)) * 0.1593017578125f);
        float _309 = clamp(exp2(log2(((_300 * 18.8515625f) + 0.8359375f) / ((_300 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
        float _312 = min(_253 / _309, _309 / _253);
        float _313 = ((dot(float3(_225, _238, _251), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _312;
        float _314 = ((dot(float3(_225, _238, _251), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * HDRMapping_m0[14u].w) * _312;
        float _330 = exp2(log2(clamp(mad(0.111000001430511474609375f, _314, mad(0.0089999996125698089599609375f, _313, _309)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
        float _338 = exp2(log2(max(0.0f, _330 + (-0.8359375f)) / (18.8515625f - (_330 * 18.6875f))) * 6.277394771575927734375f);
        float _342 = exp2(log2(clamp(mad(-0.111000001430511474609375f, _314, mad(-0.0089999996125698089599609375f, _313, _309)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
        float _351 = exp2(log2(max(0.0f, _342 + (-0.8359375f)) / (18.8515625f - (_342 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
        float _355 = exp2(log2(clamp(mad(-0.3210000097751617431640625f, _314, mad(0.560000002384185791015625f, _313, _309)), 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
        float _364 = exp2(log2(max(0.0f, _355 + (-0.8359375f)) / (18.8515625f - (_355 * 18.6875f))) * 6.277394771575927734375f) * 100.0f;
        float _369 = mad(0.20700000226497650146484375f, _364, mad(-1.32700002193450927734375f, _351, _338 * 207.100006103515625f));
        float _375 = mad(-0.04500000178813934326171875f, _364, mad(0.6809999942779541015625f, _351, _338 * 36.5f));
        float _381 = mad(1.1879999637603759765625f, _364, mad(-0.0500000007450580596923828125f, _351, _338 * (-4.900000095367431640625f)));
        _78 = mad(-0.498610794544219970703125f, _381, mad(-1.53738319873809814453125f, _375, _369 * 3.2409698963165283203125f));
        _80 = mad(0.0415550954639911651611328125f, _381, mad(1.8759677410125732421875f, _375, _369 * (-0.969243705272674560546875f)));
        _82 = mad(1.05697143077850341796875f, _381, mad(-0.2039768397808074951171875f, _375, _369 * 0.0556300692260265350341796875f));
    }
    float _93 = mad(0.043313600122928619384765625f, _82, mad(0.329281985759735107421875f, _80, _78 * 0.6274039745330810546875f));
    float _99 = mad(0.0113612003624439239501953125f, _82, mad(0.919539988040924072265625f, _80, _78 * 0.06909699738025665283203125f));
    float _105 = mad(0.895595014095306396484375f, _82, mad(0.0880132019519805908203125f, _80, _78 * 0.01639159955084323883056640625f));
    float _133 = 10000.0f / HDRMapping_m0[10u].y;
    float _146 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_78 - _93)) + _93) * HDRMapping_m0[7u].y) / _133, 0.0f, 1.0f)) * 0.1593017578125f);
    float _159 = clamp(exp2(log2(((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
    float _162 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_80 - _99)) + _99) * HDRMapping_m0[7u].y) / _133, 0.0f, 1.0f)) * 0.1593017578125f);
    float _171 = clamp(exp2(log2(((_162 * 18.8515625f) + 0.8359375f) / ((_162 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
    float _174 = exp2(log2(clamp(exp2(log2((HDRMapping_m0[8u].y * (_82 - _105)) + _105) * HDRMapping_m0[7u].y) / _133, 0.0f, 1.0f)) * 0.1593017578125f);
    float _183 = clamp(exp2(log2(((_174 * 18.8515625f) + 0.8359375f) / ((_174 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
    float _398;
    float _400;
    float _402;
    if ((asuint(HDRMapping_m0[7u]).x & 2u) == 0u)
    {
        _398 = _159;
        _400 = _171;
        _402 = _183;
    }
    else
    {
        float _418 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
        float _427 = clamp(exp2(log2(((_418 * 18.8515625f) + 0.8359375f) / ((_418 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
        float _433 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
        float _443 = _427 - clamp(exp2(log2(((_433 * 18.8515625f) + 0.8359375f) / ((_433 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
        float _447 = clamp(_159 / _427, 0.0f, 1.0f);
        float _448 = clamp(_171 / _427, 0.0f, 1.0f);
        float _449 = clamp(_183 / _427, 0.0f, 1.0f);
        _398 = min((((2.0f - (_447 + _447)) * _443) + (_447 * _427)) * _447, _159);
        _400 = min((((2.0f - (_448 + _448)) * _443) + (_448 * _427)) * _448, _171);
        _402 = min((((2.0f - (_449 + _449)) * _443) + (_449 * _427)) * _449, _183);
    }
    RWResult[uint2(uint(((((_36 & 1u) | (uint(gl_WorkGroupID.x) << 4u)) | (_39 & 2u)) | (_43 & 4u)) | (_47 & 8u)), uint(((((_39 & 1u) | (uint(gl_WorkGroupID.y) << 4u)) | (_43 & 2u)) | (_47 & 4u)) | ((_36 >> 4u) & 8u)))] = float4(_398, _400, _402, _398);
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
