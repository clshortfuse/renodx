#include "./shared.h"

// UI
sampler2D DiffuseMapSampler : register( s0 );
float4 Levels : register( c0 );

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(DiffuseMapSampler, i.texcoord1);
	r1.w = i.texcoord.w * Levels.x + -Levels.x;
	r1.w = r1.w + 1;
	o.xyz = r0.xyz * i.texcoord.xyz;
	o.w = r0.w * r1.w;
	if (Custom_UI_Disable >= 0.001f) {
		o.w = 0.f;
		} else {
		o.w = r0.w * r1.w;
	}

	return o;
}
