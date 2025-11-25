#include "./shared.h"

// Emissives
sampler2D GlowMapSampler : register( s3 );
float4 LightColor : register( c0 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(GlowMapSampler, texcoord);
	o = r0 * LightColor.w * pow(Custom_Emissives_Intensity, 2.3);

	return o;
}
