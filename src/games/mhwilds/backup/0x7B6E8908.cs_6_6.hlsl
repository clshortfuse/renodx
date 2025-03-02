cbuffer HDRMappingUBO : register(b0, space0)
{
    float4 HDRMapping_m0[15] : packoffset(c0);
};

RWTexture2D<float> RWResult : register(u0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main()
{
    uint _32 = uint(gl_LocalInvocationID.x);
    uint _35 = _32 >> 1u;
    uint _39 = _32 >> 2u;
    uint _43 = _32 >> 3u;
    uint _54 = ((((_32 & 1u) | (uint(gl_WorkGroupID.x) << 4u)) | (_35 & 2u)) | (_39 & 4u)) | (_43 & 8u);
    uint _59 = ((((_35 & 1u) | (uint(gl_WorkGroupID.y) << 4u)) | (_39 & 2u)) | (_43 & 4u)) | ((_32 >> 4u) & 8u);
    uint _60 = uint(_54);
    uint _61 = uint(_59);
    float4 _63 = RWResult[uint2(_60, _61)].xxxx;
    float _66 = _63.x;
    float _67 = _63.y;
    float _68 = _63.z;
    float _77 = float(_54) * HDRMapping_m0[8u].z;
    float _78 = float(_59) * HDRMapping_m0[8u].w;
    float _94;
    float _97;
    float _98;
    if ((((_77 < HDRMapping_m0[6u].x) || (_77 > HDRMapping_m0[6u].z)) || (_78 < HDRMapping_m0[6u].y)) || (_78 > HDRMapping_m0[6u].w))
    {
        _94 = _66;
        _97 = _67;
        _98 = _68;
    }
    else
    {
        float _109 = max(max(_66, _67), _68);
        float frontier_phi_1_2_ladder;
        float frontier_phi_1_2_ladder_1;
        float frontier_phi_1_2_ladder_2;
        if (_109 < HDRMapping_m0[7u].z)
        {
            float frontier_phi_1_2_ladder_5_ladder;
            float frontier_phi_1_2_ladder_5_ladder_1;
            float frontier_phi_1_2_ladder_5_ladder_2;
            if (_109 > HDRMapping_m0[7u].w)
            {
                frontier_phi_1_2_ladder_5_ladder = _66;
                frontier_phi_1_2_ladder_5_ladder_1 = _67;
                frontier_phi_1_2_ladder_5_ladder_2 = _68;
            }
            else
            {
                frontier_phi_1_2_ladder_5_ladder = 0.0f;
                frontier_phi_1_2_ladder_5_ladder_1 = 0.0f;
                frontier_phi_1_2_ladder_5_ladder_2 = 0.5f;
            }
            frontier_phi_1_2_ladder = frontier_phi_1_2_ladder_5_ladder;
            frontier_phi_1_2_ladder_1 = frontier_phi_1_2_ladder_5_ladder_1;
            frontier_phi_1_2_ladder_2 = frontier_phi_1_2_ladder_5_ladder_2;
        }
        else
        {
            frontier_phi_1_2_ladder = 0.5f;
            frontier_phi_1_2_ladder_1 = 0.0f;
            frontier_phi_1_2_ladder_2 = 0.0f;
        }
        _94 = frontier_phi_1_2_ladder;
        _97 = frontier_phi_1_2_ladder_1;
        _98 = frontier_phi_1_2_ladder_2;
    }
    float _115;
    float _117;
    float _119;
    if ((asuint(HDRMapping_m0[8u]).x & 2u) == 0u)
    {
        _115 = _94;
        _117 = _97;
        _119 = _98;
    }
    else
    {
        float _133 = exp2(log2(clamp(HDRMapping_m0[0u].z * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
        float _146 = clamp(exp2(log2(((_133 * 18.8515625f) + 0.8359375f) / ((_133 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
        float _152 = exp2(log2(clamp(HDRMapping_m0[0u].w * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
        float _162 = _146 - clamp(exp2(log2(((_152 * 18.8515625f) + 0.8359375f) / ((_152 * 18.6875f) + 1.0f)) * 78.84375f), 0.0f, 1.0f);
        float _166 = clamp(_94 / _146, 0.0f, 1.0f);
        float _167 = clamp(_97 / _146, 0.0f, 1.0f);
        float _168 = clamp(_98 / _146, 0.0f, 1.0f);
        _115 = min((((2.0f - (_166 + _166)) * _162) + (_166 * _146)) * _166, _94);
        _117 = min((((2.0f - (_167 + _167)) * _162) + (_167 * _146)) * _167, _97);
        _119 = min((((2.0f - (_168 + _168)) * _162) + (_168 * _146)) * _168, _98);
    }
    RWResult[uint2(_60, _61)] = float4(_115, _117, _119, _115).x;
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}
