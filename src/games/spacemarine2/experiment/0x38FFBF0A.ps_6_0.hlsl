static const float _40[8] = { -0.5f, -0.5f, 0.5f, -0.5f, 0.5f, 0.5f, -0.5f, 0.5f };

cbuffer CB_COMMONUBO : register(b0, space0)
{
    float4 CB_COMMON_m0[3856] : packoffset(c0);
};

cbuffer CB_PASS_HDRUBO : register(b4, space0)
{
    float4 CB_PASS_HDR_m0[12] : packoffset(c0);
};

Texture2D<float4> HDR_TEX1 : register(t0, space2);
Texture2D<float4> HDR_TEX2 : register(t1, space2);
Texture2D<float4> HDR_TEX3 : register(t2, space2);
SamplerState PS_SAMPLERS[12] : register(s0, space1);

static float2 TEXCOORD[2];
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float2 TEXCOORD[2] : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    float4 _71 = HDR_TEX3.SampleLevel(PS_SAMPLERS[4u], float2(TEXCOORD[0u].x, TEXCOORD[0u].y), 0.0f);
    float _82 = TEXCOORD[0u].x - (CB_PASS_HDR_m0[2u].x * 3.0f);
    float _83 = TEXCOORD[0u].y - (CB_PASS_HDR_m0[2u].y * 3.0f);
    float4 _85 = HDR_TEX2.SampleLevel(PS_SAMPLERS[4u], float2(_82, _83), 0.0f);
    float _90 = CB_PASS_HDR_m0[2u].x + TEXCOORD[0u].x;
    float4 _91 = HDR_TEX2.SampleLevel(PS_SAMPLERS[4u], float2(_90, _83), 0.0f);
    float _99 = CB_PASS_HDR_m0[2u].y + TEXCOORD[0u].y;
    float4 _100 = HDR_TEX2.SampleLevel(PS_SAMPLERS[4u], float2(_82, _99), 0.0f);
    float4 _108 = HDR_TEX2.SampleLevel(PS_SAMPLERS[4u], float2(_90, _99), 0.0f);
    float _127;
    float _129;
    float _131;
    float _133;
    uint _135;
    _127 = 0.0f;
    _129 = 0.0f;
    _131 = 0.0f;
    _133 = 0.0f;
    _135 = 0u;
    float _128;
    float _130;
    float _132;
    float _134;
    float _49[4];
    float _50[4];
    float _51[4];
    float _52[4];
    for (;;)
    {
        float4 _151 = HDR_TEX1.SampleLevel(PS_SAMPLERS[4u], float2((_40[0u + (_135 * 2u)] * CB_PASS_HDR_m0[2u].x) + TEXCOORD[0u].x, (_40[1u + (_135 * 2u)] * CB_PASS_HDR_m0[2u].y) + TEXCOORD[0u].y), 0.0f);
        float _161 = max(0.0f, min(_151.x, 64512.0f));
        float _162 = max(0.0f, min(_151.y, 64512.0f));
        float _163 = max(0.0f, min(_151.z, 64512.0f));
        _128 = _161 + _127;
        _130 = _162 + _129;
        _132 = _163 + _131;
        float _167 = max(dot(float3(_161, _162, _163), float3(0.21267099678516387939453125f, 0.71516001224517822265625f, 0.072168998420238494873046875f)), 9.9999999747524270787835121154785e-07f);
        _134 = max(_133, _167);
        _52[_135] = _167;
        _49[_135] = _161 / _167;
        _50[_135] = _162 / _167;
        _51[_135] = _163 / _167;
        uint _136 = _135 + 1u;
        if (_136 == 4u)
        {
            break;
        }
        else
        {
            _127 = _128;
            _129 = _130;
            _131 = _132;
            _133 = _134;
            _135 = _136;
        }
    }
    float _179 = dot(float3((((_91.x + _85.x) + _100.x) + _108.x) * 0.25f, (((_91.y + _85.y) + _100.y) + _108.y) * 0.25f, (((_91.z + _85.z) + _100.z) + _108.z) * 0.25f), float3(0.21267099678516387939453125f, 0.71516001224517822265625f, 0.072168998420238494873046875f)) + 9.9999999747524270787835121154785e-07f;
    float _184 = clamp((_134 / _179) * 0.100000001490116119384765625f, 0.0f, 1.0f);
    float _185 = _184 * _184;
    float _209 = max((CB_COMMON_m0[21u].x * ((_185 * (min(_52[0u], _179) - _52[0u])) + _52[0u])) - CB_COMMON_m0[21u].y, 0.0f) / CB_COMMON_m0[21u].x;
    float _232 = max((CB_COMMON_m0[21u].x * ((_185 * (min(_52[1u], _179) - _52[1u])) + _52[1u])) - CB_COMMON_m0[21u].y, 0.0f) / CB_COMMON_m0[21u].x;
    float _258 = max((CB_COMMON_m0[21u].x * ((_185 * (min(_52[2u], _179) - _52[2u])) + _52[2u])) - CB_COMMON_m0[21u].y, 0.0f) / CB_COMMON_m0[21u].x;
    float _285 = max((CB_COMMON_m0[21u].x * ((_185 * (min(_52[3u], _179) - _52[3u])) + _52[3u])) - CB_COMMON_m0[21u].y, 0.0f) / CB_COMMON_m0[21u].x;
    float _294 = ((_285 * _49[3u]) + ((_258 * _49[2u]) + ((_232 * _49[1u]) + (_209 * _49[0u])))) * 0.25f;
    float _295 = ((_285 * _50[3u]) + ((_258 * _50[2u]) + ((_232 * _50[1u]) + (_209 * _50[0u])))) * 0.25f;
    float _296 = ((_285 * _51[3u]) + ((_258 * _51[2u]) + ((_232 * _51[1u]) + (_209 * _51[0u])))) * 0.25f;
    float _304 = (1.0f - clamp(dot(float3(_294, _295, _296), float3(0.21267099678516387939453125f, 0.71516001224517822265625f, 0.072168998420238494873046875f)) * 0.039999999105930328369140625f, 0.0f, 1.0f)) * _71.w;
    float _306 = (_304 * _304) * 3.0f;
    float _310 = CB_COMMON_m0[21u].x + 1.0f;
    SV_Target.x = ((_71.x + ((_128 * 0.25f) * _306)) / _310) + (CB_PASS_HDR_m0[6u].z * _294);
    SV_Target.y = ((_71.y + ((_130 * 0.25f) * _306)) / _310) + (CB_PASS_HDR_m0[6u].z * _295);
    SV_Target.z = ((_71.z + ((_132 * 0.25f) * _306)) / _310) + (CB_PASS_HDR_m0[6u].z * _296);
    SV_Target.w = 0.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TEXCOORD = stage_input.TEXCOORD;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
