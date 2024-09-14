static float _472;
static float _473;
static float _474;

cbuffer _22_24 : register(b0, space0)
{
    float4 _24_m0[30] : packoffset(c0);
};

cbuffer _27_29 : register(b12, space0)
{
    float4 _29_m0[99] : packoffset(c0);
};

cbuffer _32_34 : register(b6, space0)
{
    float4 _34_m0[15] : packoffset(c0);
};

Texture2D<uint4> _8 : register(t51, space0);
Texture2D<float4> _12 : register(t0, space0);
Texture2D<float4> _13 : register(t1, space0);
Texture3D<float4> _18[3] : register(t4, space0);
SamplerState _37 : register(s11, space0);

static float4 gl_FragCoord;
static float2 SYS_TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    nointerpolation float2 SYS_TEXCOORD : TEXCOORD1;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    uint _58 = uint(int(gl_FragCoord.x));
    uint _59 = uint(int(gl_FragCoord.y));
    float _60 = float(int(_58));
    float _61 = float(int(_59));
    float _62 = _60 + 0.5f;
    float _64 = _61 + 0.5f;
    float4 _73 = _12.Load(int3(uint2(_58, _59), 0u));
    float4 _82 = _13.Sample(_37, float2(_62 * _34_m0[10u].z, _64 * _34_m0[10u].w));
    float _112 = (((_34_m0[0u].x * _82.x) + (_34_m0[0u].w * _73.x)) * _34_m0[11u].w) + _34_m0[11u].x;
    float _113 = (((_34_m0[0u].y * _82.y) + (_34_m0[0u].w * _73.y)) * _34_m0[11u].w) + _34_m0[11u].y;
    float _114 = (((_34_m0[0u].z * _82.z) + (_34_m0[0u].w * _73.z)) * _34_m0[11u].w) + _34_m0[11u].z;
    float _134 = (_34_m0[14u].x * _34_m0[10u].x) * (((_62 * 2.0f) * _34_m0[10u].z) + (-1.0f));
    float _136 = (_34_m0[14u].x * _34_m0[10u].y) * (((_64 * 2.0f) * _34_m0[10u].w) + (-1.0f));
    float _172;
    float _173;
    float _174;
    if (_34_m0[9u].x > 0.0f)
    {
        float _156 = exp2((-0.0f) - (_34_m0[9u].y * log2(abs((dot(float2(_134, _136), float2(_134, _136)) * _34_m0[9u].x) + 1.0f))));
        _172 = ((_112 - _34_m0[8u].x) * _156) + _34_m0[8u].x;
        _173 = ((_113 - _34_m0[8u].y) * _156) + _34_m0[8u].y;
        _174 = ((_114 - _34_m0[8u].z) * _156) + _34_m0[8u].z;
    }
    else
    {
        _172 = _112;
        _173 = _113;
        _174 = _114;
    }
    float _405;
    float _406;
    float _407;
    uint _199;
    float _326;
    float _327;
    float _328;
    float _340;
    float _341;
    float _342;
    float _350;
    float _351;
    float _352;
    uint _359;
    bool _360;
    for (;;)
    {
        _199 = 1u << (_8.Load(int3(uint2(uint(_29_m0[79u].x * _60), uint(_29_m0[79u].y * _61)), 0u)).y & 31u);
        float _212 = frac(_60 * 0.103100001811981201171875f);
        float _213 = frac(_61 * 0.10300000011920928955078125f);
        float _214 = frac(float(asuint(_24_m0[28u]).y) * 0.097300000488758087158203125f);
        float _219 = dot(float3(_212, _213, _214), float3(_213 + 33.3300018310546875f, _212 + 33.3300018310546875f, _214 + 33.3300018310546875f));
        float _223 = _219 + _212;
        float _224 = _219 + _213;
        float _226 = _223 + _224;
        float _234 = frac(_226 * (_219 + _214)) + (-0.5f);
        float _236 = frac((_223 * 2.0f) * _224) + (-0.5f);
        float _237 = frac(_226 * _223) + (-0.5f);
        uint4 _250 = asuint(_34_m0[13u]);
        float _254 = float(min((_250.x & _199), 1u));
        float _275 = float(min((_250.y & _199), 1u));
        float _297 = float(min((_250.z & _199), 1u));
        float _319 = float(min((_250.w & _199), 1u));
        _326 = (((((_172 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].x * _234) * _254) + 1.0f)) * (((_34_m0[3u].x * _234) * _275) + 1.0f)) * (((_34_m0[4u].x * _234) * _297) + 1.0f)) * (((_34_m0[5u].x * _234) * _319) + 1.0f);
        _327 = (((((_173 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].y * _236) * _254) + 1.0f)) * (((_34_m0[3u].y * _236) * _275) + 1.0f)) * (((_34_m0[4u].y * _236) * _297) + 1.0f)) * (((_34_m0[5u].y * _236) * _319) + 1.0f);
        _328 = (((((_174 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].z * _237) * _254) + 1.0f)) * (((_34_m0[3u].z * _237) * _275) + 1.0f)) * (((_34_m0[4u].z * _237) * _297) + 1.0f)) * (((_34_m0[5u].z * _237) * _319) + 1.0f);
        _340 = (_34_m0[6u].x * log2(_326)) + _34_m0[6u].y;
        _341 = (_34_m0[6u].x * log2(_327)) + _34_m0[6u].y;
        _342 = (_34_m0[6u].x * log2(_328)) + _34_m0[6u].y;
        float4 _348 = _18[4u].SampleLevel(_37, float3(_340, _341, _342), 0.0f);
        _350 = _348.x;
        _351 = _348.y;
        _352 = _348.z;
        _359 = min((asuint(_34_m0[12u]).x & _199), 1u);
        _360 = _359 == 0u;
        uint _376;
        float _378;
        float _380;
        float _382;
        if (_360)
        {
            float4 _364 = _18[5u].SampleLevel(_37, float3(_340, _341, _342), 0.0f);
            uint _374 = min((asuint(_34_m0[12u]).y & _199), 1u);
            uint frontier_phi_4_3_ladder;
            float frontier_phi_4_3_ladder_1;
            float frontier_phi_4_3_ladder_2;
            float frontier_phi_4_3_ladder_3;
            if (_374 == 0u)
            {
                float4 _397 = _18[6u].SampleLevel(_37, float3(_340, _341, _342), 0.0f);
                uint _377 = min((asuint(_34_m0[12u]).z & _199), 1u);
                if (_377 == 0u)
                {
                    _405 = _326;
                    _406 = _327;
                    _407 = _328;
                    break;
                }
                frontier_phi_4_3_ladder = _377;
                frontier_phi_4_3_ladder_1 = _397.z;
                frontier_phi_4_3_ladder_2 = _397.y;
                frontier_phi_4_3_ladder_3 = _397.x;
            }
            else
            {
                frontier_phi_4_3_ladder = _374;
                frontier_phi_4_3_ladder_1 = _364.z;
                frontier_phi_4_3_ladder_2 = _364.y;
                frontier_phi_4_3_ladder_3 = _364.x;
            }
            _376 = frontier_phi_4_3_ladder;
            _378 = frontier_phi_4_3_ladder_1;
            _380 = frontier_phi_4_3_ladder_2;
            _382 = frontier_phi_4_3_ladder_3;
        }
        else
        {
            _376 = _359;
            _378 = _352;
            _380 = _351;
            _382 = _350;
        }
        float _384 = float(_376);
        _405 = ((_382 - _326) * _384) + _326;
        _406 = ((_380 - _327) * _384) + _327;
        _407 = ((_378 - _328) * _384) + _328;
        break;
    }
    float _408 = dot(float3(_405, _406, _407), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _420 = max(9.9999997473787516355514526367188e-05f, dot(float3(_326, _327, _328), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
    SV_Target.x = asfloat(asuint(((_34_m0[1u].w * (((_408 * _326) / _420) - _405)) + _405) * _34_m0[1u].z) + 65536u);
    SV_Target.y = asfloat(asuint(((_34_m0[1u].w * (((_408 * _327) / _420) - _406)) + _406) * _34_m0[1u].z) + 65536u);
    SV_Target.z = asfloat(asuint(((_34_m0[1u].w * (((_408 * _328) / _420) - _407)) + _407) * _34_m0[1u].z) + 131072u);
    SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
