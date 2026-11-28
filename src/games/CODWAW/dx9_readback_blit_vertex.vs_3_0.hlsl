// Call of Duty: World at War - D3D9 readback blit vertex shader
// vs_3_0
//
// c0.xy = inverse target size. The half-pixel correction aligns the fullscreen
// quad with D3D9 pixel centers so the point-sampled readback is not shifted.

float4 blitInvSize : register(c0);

struct VSInput
{
    float4 position : POSITION0;
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

    output.position = input.position;
    output.position.xy += float2(-blitInvSize.x, blitInvSize.y) * output.position.w;
    output.texCoord = input.texCoord;

    return output;
}
