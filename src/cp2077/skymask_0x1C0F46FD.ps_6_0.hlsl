cbuffer _14_16 : register(b12, space0)
{
    float4 _16_m0[99] : packoffset(c0);
};

cbuffer _19_21 : register(b6, space0)
{
    float4 _21_m0[15] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);
Texture2D<float4> _9 : register(t5, space0);

static float4 gl_FragCoord;
static float3 SV_Target;

struct SPIRV_Cross_Input
{
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float3 SV_Target : SV_Target0;
};

void frag_main()
{
    uint _36 = uint(gl_FragCoord.x);
    uint _37 = uint(gl_FragCoord.y);
    uint _50 = _36 >> 1u;
    float _197;
    float _198;
    float _199;
    if ((((_37 ^ _36) ^ asuint(_21_m0[12u]).w) & 1u) == 0u)
    {
        float4 _51 = _9.Load(int3(uint2(_50, _37), 0u));
        _197 = _51.x;
        _198 = _51.y;
        _199 = _51.z;
    }
    else
    {
        uint _57 = _36 + 4294967295u;
        float4 _60 = _9.Load(int3(uint2(_57 >> 1u, _37), 0u));
        uint _65 = _36 + 1u;
        float4 _67 = _9.Load(int3(uint2(_65 >> 1u, _37), 0u));
        uint _72 = _37 + 1u;
        float4 _73 = _9.Load(int3(uint2(_50, _72), 0u));
        uint _78 = _37 + 4294967295u;
        float4 _79 = _9.Load(int3(uint2(_50, _78), 0u));
        float _104 = 1.0f / max((((_16_m0[26u].x * _8.Load(int3(uint2(_36, _37), 0u)).x) + _16_m0[26u].y) * _16_m0[25u].x) + _16_m0[25u].y, 1.0000000116860974230803549289703e-07f);
        float _155 = _104 + 9.9999997473787516355514526367188e-06f;
        float _165 = max(0.001000000047497451305389404296875f, 1.0f - ((abs((1.0f / max((((_16_m0[26u].x * _8.Load(int3(uint2(_57, _37), 0u)).x) + _16_m0[26u].y) * _16_m0[25u].x) + _16_m0[25u].y, 1.0000000116860974230803549289703e-07f)) - _104) * 15.0f) / _155));
        float _167 = max(0.001000000047497451305389404296875f, 1.0f - ((abs((1.0f / max((((_16_m0[26u].x * _8.Load(int3(uint2(_65, _37), 0u)).x) + _16_m0[26u].y) * _16_m0[25u].x) + _16_m0[25u].y, 1.0000000116860974230803549289703e-07f)) - _104) * 15.0f) / _155));
        float _168 = max(0.001000000047497451305389404296875f, 1.0f - ((abs((1.0f / max((((_16_m0[26u].x * _8.Load(int3(uint2(_36, _72), 0u)).x) + _16_m0[26u].y) * _16_m0[25u].x) + _16_m0[25u].y, 1.0000000116860974230803549289703e-07f)) - _104) * 15.0f) / _155));
        float _169 = max(0.001000000047497451305389404296875f, 1.0f - ((abs((1.0f / max((((_16_m0[26u].x * _8.Load(int3(uint2(_36, _78), 0u)).x) + _16_m0[26u].y) * _16_m0[25u].x) + _16_m0[25u].y, 1.0000000116860974230803549289703e-07f)) - _104) * 15.0f) / _155));
        float _172 = ((_167 + _165) + _168) + _169;
        _197 = ((((_167 * _67.x) + (_165 * _60.x)) + (_168 * _73.x)) + (_169 * _79.x)) / _172;
        _198 = ((((_167 * _67.y) + (_165 * _60.y)) + (_168 * _73.y)) + (_169 * _79.y)) / _172;
        _199 = ((((_167 * _67.z) + (_165 * _60.z)) + (_168 * _73.z)) + (_169 * _79.z)) / _172;
    }
    SV_Target.x = _197;
    SV_Target.y = _198;
    SV_Target.z = _199;
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
