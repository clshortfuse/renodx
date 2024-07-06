cbuffer _16_18 : register(b0, space0)
{
    float4 _18_m0[162] : packoffset(c0);
};

Texture2D<float4> _9[] : register(t0, space11);
Texture2D<float4> _11 : register(t0, space0);
SamplerState _21 : register(s0, space0);

static float4 TEXCOORD;
static uint INSTANCE_ID;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    noperspective float4 TEXCOORD : TEXCOORD0;
    nointerpolation uint INSTANCE_ID : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    uint _48 = INSTANCE_ID + 66u;
    float _95;
    if (_18_m0[_48].w == 0.0f)
    {
        bool _59 = WaveGetLaneIndex() < 32u;
        uint _63 = 1u << (WaveGetLaneIndex() & 31u);
        uint _64 = _59 ? _63 : 0u;
        uint _65 = _59 ? 0u : _63;
        uint4 _71 = WaveActiveBallot(true && (!IsHelperLane()));
        uint _72 = _71.x;
        uint _73 = _71.y;
        float frontier_phi_3_1_ladder;
        if (((_64 & _72) | (_65 & _73)) == 0u)
        {
            frontier_phi_3_1_ladder = 0.0f;
        }
        else
        {
            float _96;
            float _139 = 0.0f;
            uint _140 = _72;
            uint _142 = _73;
            uint _141;
            uint _143;
            uint _144;
            bool _145;
            for (;;)
            {
                _144 = WaveReadLaneFirst(INSTANCE_ID);
                _145 = _144 == INSTANCE_ID;
                uint4 _149 = WaveActiveBallot(_145 && (!IsHelperLane()));
                _141 = _140 & (_149.x ^ 4294967295u);
                _143 = _142 & (_149.y ^ 4294967295u);
                float frontier_phi_7_pred;
                if (_145)
                {
                    frontier_phi_7_pred = _9[_144 + 0u].Sample(_21, float2(TEXCOORD.x, TEXCOORD.y)).x;
                }
                else
                {
                    frontier_phi_7_pred = _139;
                }
                _96 = frontier_phi_7_pred;
                if (((_141 & _64) | (_143 & _65)) == 0u)
                {
                    break;
                }
                else
                {
                    _139 = _96;
                    _140 = _141;
                    _142 = _143;
                    continue;
                }
            }
            frontier_phi_3_1_ladder = _96;
        }
        _95 = frontier_phi_3_1_ladder;
    }
    else
    {
        float _81 = (TEXCOORD.x + (-0.5f)) * 2.0f;
        float _83 = (TEXCOORD.y + (-0.5f)) * 2.0f;
        _95 = exp2(log2(clamp(1.0f - dot(float2(_81, _83), float2(_81, _83)), 0.0f, 1.0f)) * _18_m0[_48].w);
    }
    uint _100 = INSTANCE_ID + 98u;
    float _112 = clamp(1.0f - dot(float2(TEXCOORD.z, TEXCOORD.w), float2(TEXCOORD.z, TEXCOORD.w)), 0.0f, 1.0f);
    float _117 = (((_112 * _112) + (-1.0f)) * _18_m0[_48].z) + 1.0f;
    uint _118 = INSTANCE_ID + 130u;
    float _124 = (_95 * _11.Load(int3(uint2(0u, 0u), 0u)).x) * _18_m0[_100].w;
    SV_Target.x = ((_124 * _18_m0[_100].x) * _18_m0[_118].x) * _117;
    SV_Target.y = ((_124 * _18_m0[_100].y) * _18_m0[_118].x) * _117;
    SV_Target.z = ((_124 * _18_m0[_100].z) * _18_m0[_118].x) * _117;
    SV_Target.w = 0.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TEXCOORD = stage_input.TEXCOORD;
    INSTANCE_ID = stage_input.INSTANCE_ID;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
