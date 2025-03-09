static const float _28[3] = { 0.0f, 1.384615421295166015625f, 3.23076915740966796875f };
static const float _34[3] = { 0.2270270287990570068359375f, 0.3162162303924560546875f, 0.0702702701091766357421875f };

cbuffer TonemapUBO : register(b0, space0)
{
    float4 Tonemap_m0[6] : packoffset(c0);
};

Texture2D<float4> LuminanceSRV : register(t0, space0);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float2 TEXCOORD : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    uint4 _48 = asuint(Tonemap_m0[5u]);
    float _71;
    uint _73;
    _71 = LuminanceSRV.Load(int3(uint2(uint(((TEXCOORD.x * 64.0f) * float(int(_48.z))) + 0.5f) >> 6u, uint(((TEXCOORD.y * 64.0f) * float(int(_48.w))) + 0.5f) >> 6u), 0u)).x * 0.2270270287990570068359375f;
    _73 = 1u;
    float _72;
    for (;;)
    {
        uint4 _80 = asuint(Tonemap_m0[5u]);
        float _82 = float(int(_80.z));
        float _83 = _28[_73] / _82;
        float _88 = abs(_83 + TEXCOORD.x);
        float _89 = abs(TEXCOORD.y);
        min16float _93 = min16float(frac(_88));
        min16float _94 = min16float(frac(_89));
        float _105 = float((_89 > 1.0f) ? (min16float(1.0) - _94) : _94);
        uint4 _127 = asuint(Tonemap_m0[5u]);
        float _132 = abs(TEXCOORD.x - _83);
        min16float _134 = min16float(frac(_132));
        _72 = ((LuminanceSRV.Load(int3(uint2(uint(((_82 * 64.0f) * float((_88 > 1.0f) ? (min16float(1.0) - _93) : _93)) + 0.5f) >> 6u, uint(((float(int(_80.w)) * 64.0f) * _105) + 0.5f) >> 6u), 0u)).x * _34[_73]) + _71) + (LuminanceSRV.Load(int3(uint2(uint(((float(int(_127.z)) * 64.0f) * float((_132 > 1.0f) ? (min16float(1.0) - _134) : _134)) + 0.5f) >> 6u, uint(((float(int(_127.w)) * 64.0f) * _105) + 0.5f) >> 6u), 0u)).x * _34[_73]);
        uint _74 = _73 + 1u;
        if (_74 == 3u)
        {
            break;
        }
        else
        {
            _71 = _72;
            _73 = _74;
        }
    }
    SV_Target.x = _72;
    SV_Target.y = 0.0f;
    SV_Target.z = 0.0f;
    SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TEXCOORD = stage_input.TEXCOORD;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
