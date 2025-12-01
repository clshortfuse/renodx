#include "./shared.h"

// Particles
sampler2D DiffuseMapSampler : register(s0);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(DiffuseMapSampler, i.texcoord);
	r0 = r0 * i.color;
	r0 = r0 * float4(2, 2, 2, 1);

	float Y = dot(r0.xyz, float3(0.2126, 0.7152, 0.0722));
	// Chromatic component
	float3 C = r0.xyz - float3(Y, Y, Y);
	float Ch = length(C);
	float YScale = length(r0.xyz);  // overall magnitude
	float chromaWeight = saturate(Ch / (Ch + Y + 1e-6));
	float perceptualWeight = saturate(pow(chromaWeight * YScale, 4.0));
	// Boosting luminance based on chroma and luma
	float HDRBoost = lerp(1.f, pow(Custom_Particles_Intensity, 4.f), perceptualWeight);
	r0.xyz *= HDRBoost;

	o = r0;
	return o;
}
