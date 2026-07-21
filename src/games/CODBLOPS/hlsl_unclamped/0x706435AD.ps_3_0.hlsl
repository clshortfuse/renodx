// Decompiled from 0x706435AD.ps_3_0.cso.
// HDR edit: the original final RGB saturate was removed.
// Alpha remains the original constant 1.0.
// Entry point: main    Target: ps_3_0

sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
float4 c[224] : register(c0);

float4 main(float2 texcoord : TEXCOORD0) : COLOR0
{
    float4 secondaryColor = tex2D(s1, texcoord);
    float3 secondaryContribution = secondaryColor.rgb * (1.0f - c[5].z);
    float4 primaryColor = tex2D(s0, texcoord);
    float3 outputColor = primaryColor.rgb * c[5].z + secondaryContribution;
    return float4(outputColor, 1.0f);
}
