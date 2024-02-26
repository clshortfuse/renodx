cbuffer _13_15 : register(b6, space0)
{
    float4 _15_m0[2] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);
SamplerState _18 : register(s0, space0);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float4 gl_FragCoord : SV_Position;
    float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    float4 _38 = _8.Sample(_18, float2(TEXCOORD.x, TEXCOORD.y));
    float _40 = _38.x;
    float _41 = _38.y;
    float _42 = _38.z;
    float _52;
    float _54;
    float _56;
    if (asuint(_15_m0[1u]).x == 0u)
    {
        _52 = _40;
        _54 = _41;
        _56 = _42;
    }
    else
    {
        float _73 = 1.0f / (dot(float3(_40, _41, _42), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) + 1.0f);
        _52 = _73 * _40;
        _54 = _73 * _41;
        _56 = _73 * _42;
    }
    SV_Target.x = _52;
    SV_Target.y = _54;
    SV_Target.z = _56;
    SV_Target.w = _38.w;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TEXCOORD = stage_input.TEXCOORD;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
