cbuffer SignedDistanceFieldInfoUBO : register(b0, space0)
{
    float4 SignedDistanceFieldInfo_m0[29] : packoffset(c0);
};

Buffer<uint4> SDFBoundingAABBSRV : register(t0, space0);
Buffer<uint4> SDFValidIndexTblSRV : register(t1, space0);
Buffer<uint4> SDFInstanceMetadataSRV : register(t2, space0);
RWBuffer<uint> RWCulledInstanceNum : register(u0, space0);
RWBuffer<uint> RWCulledInstanceIndexTbl : register(u1, space0);

static uint3 gl_GlobalInvocationID;
static uint4 gl_SubgroupLtMask;
struct SPIRV_Cross_Input
{
    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main()
{
    if (gl_GlobalInvocationID.x < asuint(SignedDistanceFieldInfo_m0[2u]).z)
    {
        uint _43 = SDFValidIndexTblSRV.Load(gl_GlobalInvocationID.x).x & 1048575u;
        uint4 _46 = SDFInstanceMetadataSRV.Load(_43);
        uint _47 = _46.x;
        if (((_47 & 255u) != 0u) && ((_47 & 256u) != 0u))
        {
            uint _56 = _43 * 6u;
            float3 _69 = asfloat(uint3(SDFBoundingAABBSRV.Load(_56).x, SDFBoundingAABBSRV.Load(_56 + 1u).x, SDFBoundingAABBSRV.Load(_56 + 2u).x));
            float _70 = _69.x;
            float _71 = _69.y;
            float _72 = _69.z;
            uint _75 = (_43 * 6u) + 3u;
            float3 _85 = asfloat(uint3(SDFBoundingAABBSRV.Load(_75).x, SDFBoundingAABBSRV.Load(_75 + 1u).x, SDFBoundingAABBSRV.Load(_75 + 2u).x));
            float _86 = _85.x;
            float _87 = _85.y;
            float _88 = _85.z;
            uint _90;
            uint _89 = 0u;
            uint _91 = 0u;
            float _95;
            float4 _99;
            bool _117;
            for (;;)
            {
                _95 = SignedDistanceFieldInfo_m0[2u].y;
                uint _96 = _91 * 3u;
                _99 = SignedDistanceFieldInfo_m0[_96 + 6u];
                uint _100 = _96 + 5u;
                _117 = (min(min((_86 + _70) - SignedDistanceFieldInfo_m0[_100].x, (_87 + _71) - SignedDistanceFieldInfo_m0[_100].y), (_88 + _72) - SignedDistanceFieldInfo_m0[_100].z) + _95) > 0.0f;
                uint frontier_phi_6_pred;
                if (_117)
                {
                    uint frontier_phi_6_pred_5_ladder;
                    if ((min(min((_86 - _70) + _99.x, (_87 - _71) + _99.y), (_88 - _72) + _99.z) + _95) > 0.0f)
                    {
                        frontier_phi_6_pred_5_ladder = (1u << _91) | _89;
                    }
                    else
                    {
                        frontier_phi_6_pred_5_ladder = _89;
                    }
                    frontier_phi_6_pred = frontier_phi_6_pred_5_ladder;
                }
                else
                {
                    frontier_phi_6_pred = _89;
                }
                _90 = frontier_phi_6_pred;
                uint _92 = _91 + 1u;
                if (_92 == 7u)
                {
                    break;
                }
                else
                {
                    _89 = _90;
                    _91 = _92;
                    continue;
                }
            }
            uint _136 = _90 & _47;
            if (!(_136 == 0u))
            {
                uint _138 = 0u;
                bool _142;
                uint _144;
                uint _146;
                bool _148;
                for (;;)
                {
                    _142 = ((1u << _138) & _136) != 0u;
                    uint4 _143 = WaveActiveBallot(_142);
                    _144 = countbits(_143.x & gl_SubgroupLtMask.x) + countbits(_143.y & gl_SubgroupLtMask.y) + countbits(_143.z & gl_SubgroupLtMask.z) + countbits(_143.w & gl_SubgroupLtMask.w);
                    uint4 _145 = WaveActiveBallot(_142);
                    _146 = countbits(_145.x) + countbits(_145.y) + countbits(_145.z) + countbits(_145.w);
                    _148 = WaveReadLaneFirst(WaveGetLaneIndex()) == WaveGetLaneIndex();
                    uint _154;
                    if (_148)
                    {
                        uint _153;
                        InterlockedAdd(RWCulledInstanceNum[_138], _146, _153);
                        _154 = _153;
                    }
                    else
                    {
                        _154 = 0u;
                    }
                    uint _155 = WaveReadLaneFirst(_154);
                    uint _156 = _155 + _144;
                    uint4 _159 = asuint(SignedDistanceFieldInfo_m0[2u]);
                    uint _160 = _159.z;
                    if (_142 && (_156 < _160))
                    {
                        uint _164 = (_160 * _138) + _156;
                        RWCulledInstanceIndexTbl[_164] = _43.x;
                    }
                    uint _139 = _138 + 1u;
                    if (_139 == 7u)
                    {
                        break;
                    }
                    else
                    {
                        _138 = _139;
                        continue;
                    }
                }
            }
        }
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    gl_SubgroupLtMask = (1u << (WaveGetLaneIndex() - uint4(0, 32, 64, 96))) - 1u;
    if (WaveGetLaneIndex() >= 32) gl_SubgroupLtMask.x = ~0u;
    if (WaveGetLaneIndex() >= 64) gl_SubgroupLtMask.y = ~0u;
    if (WaveGetLaneIndex() >= 96) gl_SubgroupLtMask.z = ~0u;
    if (WaveGetLaneIndex() < 32) gl_SubgroupLtMask.y = 0u;
    if (WaveGetLaneIndex() < 64) gl_SubgroupLtMask.z = 0u;
    if (WaveGetLaneIndex() < 96) gl_SubgroupLtMask.w = 0u;
    comp_main();
}
