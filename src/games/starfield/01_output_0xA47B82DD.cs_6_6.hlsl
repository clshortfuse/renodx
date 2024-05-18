cbuffer _18_20 : register(b0, space0)
{
    float4 _20_m0[1] : packoffset(c0);
};

Buffer<uint4> _8 : register(t0, space8);
Buffer<uint4> _9 : register(t1, space8);
Buffer<uint4> _10 : register(t2, space8);
RWBuffer<uint> _13 : register(u0, space8);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main()
{
    uint4 _38 = _9.Load(gl_WorkGroupID.x);
    uint _39 = _38.x;
    uint _50;
    if ((gl_WorkGroupID.x << 2u) < asuint(_20_m0[0u]).x)
    {
        _50 = _10.Load(gl_WorkGroupID.x).x;
    }
    else
    {
        _50 = 0u;
    }
    uint _54 = 1u << (gl_LocalInvocationID.x & 31u);
    if (!(((_50 | _39) & _54) == 0u))
    {
        uint4 _61 = _13[(gl_GlobalInvocationID.x * 5u) + 1u].xxxx;
        uint _62 = _61.x;
        if ((_39 & _54) == 0u)
        {
            uint4 _70 = _8.Load((_62 * 13u) + 6u);
            uint _71 = _70.x;
            if (_71 == 0u)
            {
                _13[(gl_GlobalInvocationID.x * 5u) + 3u] = _8.Load(_62 * 13u).x.x;
            }
            else
            {
                _13[(gl_GlobalInvocationID.x * 5u) + 3u] = _71.x;
            }
        }
        else
        {
            _13[(gl_GlobalInvocationID.x * 5u) + 3u] = _13[(gl_GlobalInvocationID.x * 5u) + 2u].xxxx.x.x;
        }
        _13[(gl_GlobalInvocationID.x * 5u) + 2u] = _8.Load(_62 * 13u).x.x;
    }
}

[numthreads(32, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}
