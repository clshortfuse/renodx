cbuffer _13_15 : register(b1, space0)
{
    float4 _15_m0[22] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);

static float4 gl_FragCoord;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    float4 _33 = _8.Load(int3(uint2(uint(int(gl_FragCoord.x)), uint(int(gl_FragCoord.y))), 0u));
    float _36 = _33.x;
    float _37 = _33.y;
    float _38 = _33.z;
    float _53;
    if (_36 < 0.039285711944103240966796875f)
    {
        _53 = _36 * 0.077380113303661346435546875f;
    }
    else
    {
        _53 = exp2(log2(abs((_36 + 0.054999999701976776123046875f) * 0.947867333889007568359375f)) * 2.400000095367431640625f);
    }
    float _62;
    if (_37 < 0.039285711944103240966796875f)
    {
        _62 = _37 * 0.077380113303661346435546875f;
    }
    else
    {
        _62 = exp2(log2(abs((_37 + 0.054999999701976776123046875f) * 0.947867333889007568359375f)) * 2.400000095367431640625f);
    }
    float _71;
    if (_38 < 0.039285711944103240966796875f)
    {
        _71 = _38 * 0.077380113303661346435546875f;
    }
    else
    {
        _71 = exp2(log2(abs((_38 + 0.054999999701976776123046875f) * 0.947867333889007568359375f)) * 2.400000095367431640625f);
    }
    float _77 = _15_m0[18u].y * 2.f / 80.f;
    SV_Target.x = _77 * _53;
    SV_Target.y = _77 * _62;
    SV_Target.z = _77 * _71;
    SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
