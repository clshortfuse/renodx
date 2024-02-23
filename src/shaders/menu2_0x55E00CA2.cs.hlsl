cbuffer _16_18 : register(b6, space0)
{
    float4 cb6[11] : packoffset(c0);
};

Texture2D<float4> menuTexture : register(t0, space0);
RWTexture2D<float4> _11 : register(u0, space0);
SamplerState _21 : register(s0, space0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main()
{
    uint4 _48 = asuint(cb6[10u]);
    float _53 = ((float(gl_GlobalInvocationID.x) * 16.0f) + 8.0f) / float(_48.x);
    float _54 = ((float(gl_GlobalInvocationID.y) * 16.0f) + 8.0f) / float(_48.y);
    float _60 = _53 + (-0.5f);
    float _63 = (_54 + (-0.5f)) * 2.0f;
    float4 _77 = menuTexture.SampleLevel(_21, float2(_53 - (((_63 * _63) * _60) * cb6[3u].x), _54 - ((((_60 * _60) * 2.0f) * cb6[3u].y) * _63)), 4.0f);
    _11[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float((_77.w > 0.0f) || ((_77.z > 0.0f) || ((_77.x > 0.0f) || (_77.y > 0.0f)))).xxxx;
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}
