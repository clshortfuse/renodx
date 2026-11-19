// MW3 DX9 HDR clone -> SDR readback blit vertex shader.
// Mirrors the runtime-compiled shader in addon.cpp.

struct VSInput
{
    float3 position : POSITION0;
    float2 texCoord : TEXCOORD0;
};

struct VSOutput
{
    float4 position : POSITION0;
    float2 texCoord : TEXCOORD0;
};

VSOutput main(VSInput input)
{
    VSOutput output;
    output.position = float4(input.position, 1.0);
    output.texCoord = input.texCoord;
    return output;
}
