Texture2D<float4> _8 : register(t0, space0);
Texture2D<float4> _9 : register(t1, space0);
SamplerState _12 : register(s3, space2);

static float2 TEXCOORD0_centroid;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float2 TEXCOORD0_centroid : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    float4 _38 = _8.Sample(_12, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
    SV_Target.x = _38.x;
    SV_Target.y = _38.y;
    SV_Target.z = _38.z;
    SV_Target.w = _9.Sample(_12, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y)).x;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TEXCOORD0_centroid = stage_input.TEXCOORD0_centroid;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
