#include "./shared.h"

// Motion Blur
// It's here mostly to increase the sampling count and increase HDR highlights.
sampler2D FillSampler : register( s0 );
sampler2D SceneSampler : register( s1 );
float gBlurPower : register( c0 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r2;
	float4 r0;
	float4 r1;
	float2 r5;
	float4 r3;
	float4 r4;
	r2 = tex2D(SceneSampler, texcoord);
	r0 = tex2D(FillSampler, texcoord);
	r1.xy = -r0.yw + r0.xz;
	r1.xy = r1.xy * gBlurPower.x;
	r0.w = dot(r0, r0);
	r5.xy = r1.xy * float2(0.25, -0.25);
	r1.w = (-r0.w >= 0) ? 0 : 1;
	r1.xyz = r2.xyz;
	r0.z = 1;
	r0.w = -6;
	for (int i0 = 0; i0 < 24; i0++) {
		r0.xy = r0.w * r5.xy + texcoord.xy;
		r3 = tex2D(FillSampler, r0);
		r3.xz = -r3.y + r3.xy;
		r3.y = -r3.z;
		r2.w = dot(r5.x, r3.x) + 0;
		r2.w = (-r2.w >= 0) ? 0 : 1;
		r3 = tex2D(SceneSampler, r0);
		if (r2.w != -r2.w) {
			r1.xyz = r1.xyz + r3.xyz;
			r0.z = r0.z + 1;
		}
		r0.w = r0.w + 1;
	}
	r4.xyz = r1.xyz;
	r4.w = r0.z;
	r1.xyz = r4.xyz;
	r0.z = r4.w;
	r0.w = 1;
	for (int i0 = 0; i0 < 24; i0++) {
		r0.xy = r0.w * r5.xy + texcoord.xy;
		r3 = tex2D(FillSampler, r0);
		r3.xz = -r3.y + r3.xy;
		r3.y = -r3.z;
		r2.w = dot(r5.x, r3.x) + 0;
		r2.w = (-r2.w >= 0) ? 0 : 1;
		r3 = tex2D(SceneSampler, r0);
		if (r2.w != -r2.w) {
			r1.xyz = r1.xyz + r3.xyz;
			r0.z = r0.z + 1;
		}
		r0.w = r0.w + 1;
	}
	r0.w = r0.z;
	if (r1.w != -r1.w) {
		r0.w = 1 / r0.w;
		r0.xyz = r1.xyz * r0.w;
	} else {
		r0.xyz = r2.xyz;
	}
	r0.w = 1;
	o = r0;

	return o;
}