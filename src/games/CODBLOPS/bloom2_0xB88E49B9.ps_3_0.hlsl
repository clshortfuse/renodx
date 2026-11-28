// Stock five-tap filter from 0xB88E49B9, including filtered alpha.
sampler2D bloomSampler : register(s0);
float4 postFxControl0 : register(c5);
float4 postFxControl1 : register(c6);
struct PS_INPUT { float2 texcoord : TEXCOORD0; };

float4 main(PS_INPUT input) : COLOR0
{
    float4 center = tex2D(bloomSampler, input.texcoord);
    float4 uv0 = input.texcoord.xyxy + postFxControl0;
    float4 sum = center * 0.25f + tex2D(bloomSampler, uv0.xy);
    sum = tex2D(bloomSampler, uv0.zw) + sum;
    float4 uv1 = input.texcoord.xyxy + postFxControl1;
    sum += tex2D(bloomSampler, uv1.xy);
    sum = tex2D(bloomSampler, uv1.zw) + sum;
    return sum * 0.235294119f;
}
