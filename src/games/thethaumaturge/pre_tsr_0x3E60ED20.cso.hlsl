cbuffer _18_20 : register(b0, space0)
{
    float4 _20_m0[46] : packoffset(c0);
};

cbuffer _23_25 : register(b1, space0)
{
    float4 _25_m0[331] : packoffset(c0);
};

cbuffer _28_30 : register(b2, space0)
{
    float4 _30_m0[5] : packoffset(c0);
};

cbuffer _33_35 : register(b3, space0)
{
    float4 _35_m0[11] : packoffset(c0);
};

cbuffer _38_40 : register(b4, space0)
{
    float4 _40_m0[8] : packoffset(c0);
};

Texture2D<uint4> _8 : register(t0, space0);
Texture2D<float4> _12 : register(t1, space0);
Texture2D<float4> _13 : register(t2, space0);
Texture2D<float4> _14 : register(t3, space0);
SamplerState _43 : register(s0, space0);
SamplerState _44 : register(s1, space0);
SamplerState _45 : register(s2, space0);
SamplerState _46 : register(s3, space0);

static float4 gl_FragCoord;
static float4 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float4 TEXCOORD : TEXCOORD1;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    uint4 _64 = asuint(_20_m0[37u]);
    float _76 = (gl_FragCoord.x - float(_64.x)) * _20_m0[38u].z;
    float _77 = (gl_FragCoord.y - float(_64.y)) * _20_m0[38u].w;
    float4 _92 = _12.Sample(_43, float2((_76 + _25_m0[143u].y) * 3.0f, (_77 * 3.0f) + _25_m0[143u].y));
    float _95 = _92.x;
    float _96 = _92.y;
    float4 _116 = _13.Sample(_44, float2((_76 * 2.0f) - (_25_m0[143u].y * 3.0f), (_77 * 2.0f) - (_25_m0[143u].y * 0.20000000298023223876953125f)));
    float _127 = _30_m0[1u].w * 0.039999999105930328369140625f;
    float4 _161 = _14.Sample(_46, float2(min(max((((((_116.x - _95) + ((_95 * 2.0f) + (-1.0f))) * _127) + _76) * _20_m0[5u].x) + _20_m0[4u].x, _20_m0[6u].x), _20_m0[6u].z), min(max((((((_116.y - _96) + ((_96 * 2.0f) + (-1.0f))) * _127) + _77) * _20_m0[5u].y) + _20_m0[4u].y, _20_m0[6u].y), _20_m0[6u].w)));
    float _172 = clamp(1.0f - _30_m0[2u].x, 0.0f, 1.0f);
    float _173 = _172 * _161.x;
    float _174 = _172 * _161.y;
    float _175 = _172 * _161.z;
    uint4 _186 = asuint(_20_m0[37u]);
    float _197 = (gl_FragCoord.x - float(_186.x)) * _20_m0[38u].z;
    float _198 = (gl_FragCoord.y - float(_186.y)) * _20_m0[38u].w;
    float _252 = (abs((float(_8.Load(int3(uint2(uint(int(trunc(((((_197 * _25_m0[129u].x) + _25_m0[128u].x) * _25_m0[132u].z) * _25_m0[132u].x) * _25_m0[135u].x))), uint(int(trunc(((((_198 * _25_m0[129u].y) + _25_m0[128u].y) * _25_m0[132u].w) * _25_m0[132u].y) * _25_m0[135u].y)))), 0u)).y) * 0.0039215688593685626983642578125f) - _40_m0[3u].x) > 9.9999997473787516355514526367188e-06f) ? 0.0f : 1.0f;
    float _259 = (_252 * ((_40_m0[2u].x * _173) - _173)) + _173;
    float _260 = (_252 * ((_40_m0[2u].y * _174) - _174)) + _174;
    float _261 = (_252 * ((_40_m0[2u].z * _175) - _175)) + _175;
    float4 _276 = _14.Sample(_45, float2((_197 * _20_m0[5u].x) + _20_m0[4u].x, (_198 * _20_m0[5u].y) + _20_m0[4u].y));
    float _290 = (_35_m0[2u].y * (_276.x - _259)) + _259;
    float _291 = (_35_m0[2u].y * (_276.y - _260)) + _260;
    float _292 = (_35_m0[2u].y * (_276.z - _261)) + _261;
    SV_Target.x = max(((_40_m0[4u].x - _290) * _40_m0[3u].y) + _290, 0.0f);
    SV_Target.y = max(((_40_m0[4u].y - _291) * _40_m0[3u].y) + _291, 0.0f);
    SV_Target.z = max(((_40_m0[4u].z - _292) * _40_m0[3u].y) + _292, 0.0f);
    SV_Target.w = 1.0f;

    // SV_Target.rgb = 100.f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    TEXCOORD = stage_input.TEXCOORD;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
