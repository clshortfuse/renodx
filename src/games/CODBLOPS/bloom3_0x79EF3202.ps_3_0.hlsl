// Stock premultiplied sprite from 0x79EF3202.
// Preserve the authored relationship between RGB and alpha.
sampler2D colorMapSampler : register(s0);
struct PS_INPUT
{
    float4 color : COLOR0;
    float2 texcoord : TEXCOORD0;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 color = tex2D(colorMapSampler, input.texcoord) * input.color;
    return float4(color.rgb * color.a, color.a);
}
