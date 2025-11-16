#include "./shared.h"

// Particles
sampler2D DiffuseMapSampler : register( s0 );

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
	o = r0;
	float r0_luma = dot(o.xyz, float3(0.2126, 0.7152, 0.0722));
	if (r0_luma > 0.7f) {
            // o = r0;
            // o = pow(r0, 2.2) * float4(10, 10, 10, 1);            
            o.xyz = dot((r0_luma) / 1.5f / Custom_Particles_Intensity, 0.5f) * r0.xyz;
            o.xyz += (r0.xyz * (max(r0.x, max(r0.y, r0.z))) * (Custom_Particles_Intensity - 2.0f));
        }
	o = o * i.color;
	o = o * float4(2, 2, 2, 1);
	return o;
}
