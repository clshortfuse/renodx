cbuffer _GlobalsUBO : register(b0, space0)
{
    float4 _Globals_m0[1] : packoffset(c0);
};

Texture2D<float4> UITexture : register(t0, space0);
Texture2D<float4> SceneTexture : register(t1, space0);
SamplerState UISampler : register(s0, space0);
SamplerState SceneSampler : register(s1, space0);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    noperspective float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    float4 _39 = UITexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));
    float _44 = _39.w;
    // float _46 = max(6.1035199905745685100555419921875e-05f, _39.x);
    // float _48 = max(6.1035199905745685100555419921875e-05f, _39.y);
    // float _49 = max(6.1035199905745685100555419921875e-05f, _39.z);
    // Remove unneeded raise
    float _46 = _39.x;
    float _48 = _39.y;
    float _49 = _39.z;

    float _77 = (_46 > 0.040449999272823333740234375f) ? exp2(log2((_46 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f) * 2.400000095367431640625f) : (_46 * 0.077399380505084991455078125f);
    float _78 = (_48 > 0.040449999272823333740234375f) ? exp2(log2((_48 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f) * 2.400000095367431640625f) : (_48 * 0.077399380505084991455078125f);
    float _79 = (_49 > 0.040449999272823333740234375f) ? exp2(log2((_49 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f) * 2.400000095367431640625f) : (_49 * 0.077399380505084991455078125f);
    float4 _108 = SceneTexture.Sample(SceneSampler, float2(TEXCOORD.x, TEXCOORD.y));
    float _120 = exp2(log2(_108.x) * 0.0126833133399486541748046875f);
    float _121 = exp2(log2(_108.y) * 0.0126833133399486541748046875f);
    float _122 = exp2(log2(_108.z) * 0.0126833133399486541748046875f);
    float _151 = exp2(log2(max(0.0f, _120 + (-0.8359375f)) / (18.8515625f - (_120 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
    float _153 = exp2(log2(max(0.0f, _121 + (-0.8359375f)) / (18.8515625f - (_121 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
    float _154 = exp2(log2(max(0.0f, _122 + (-0.8359375f)) / (18.8515625f - (_122 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
    float _181;
    float _182;
    float _183;
    if ((_44 > 0.0f) && (_44 < 1.0f))
    {
        float _160 = max(_151, 0.0f);
        float _161 = max(_153, 0.0f);
        float _162 = max(_154, 0.0f);
        float _177 = ((((1.0f / ((dot(float3(_160, _161, _162), float3(0.2626999914646148681640625f, 0.677999973297119140625f, 0.0593000017106533050537109375f)) / _Globals_m0[0u].x) + 1.0f)) * _Globals_m0[0u].x) + (-1.0f)) * _44) + 1.0f;
        _181 = _177 * _160;
        _182 = _177 * _161;
        _183 = _177 * _162;
    }
    else
    {
        _181 = _151;
        _182 = _153;
        _183 = _154;
    }
    float _184 = 1.0f - _44;
    float _205 = exp2(log2(((_181 * _184) + ((_Globals_m0[0u].y * mad(0.0433130562305450439453125f, _79, mad(0.3292830288410186767578125f, _78, _77 * 0.627403914928436279296875f))) * _Globals_m0[0u].x)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
    float _206 = exp2(log2(((_182 * _184) + ((_Globals_m0[0u].y * mad(0.01136231981217861175537109375f, _79, mad(0.91954028606414794921875f, _78, _77 * 0.0690973103046417236328125f))) * _Globals_m0[0u].x)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
    float _207 = exp2(log2(((_183 * _184) + ((_Globals_m0[0u].y * mad(0.8955953121185302734375f, _79, mad(0.088013313710689544677734375f, _78, _77 * 0.01639143936336040496826171875f))) * _Globals_m0[0u].x)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
    SV_Target.x = exp2(log2((1.0f / ((_205 * 18.6875f) + 1.0f)) * ((_205 * 18.8515625f) + 0.8359375f)) * 78.84375f);
    SV_Target.y = exp2(log2((1.0f / ((_206 * 18.6875f) + 1.0f)) * ((_206 * 18.8515625f) + 0.8359375f)) * 78.84375f);
    SV_Target.z = exp2(log2((1.0f / ((_207 * 18.6875f) + 1.0f)) * ((_207 * 18.8515625f) + 0.8359375f)) * 78.84375f);
    SV_Target.w = _44;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TEXCOORD = stage_input.TEXCOORD;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
