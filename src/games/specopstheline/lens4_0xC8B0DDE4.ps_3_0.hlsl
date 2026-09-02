#include "./common.hlsli"

float OcclusionPercentage : register(c0);
float4 UniformPixelVector_0 : register(c4);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float r1;

	r0.x = -0.5 + i.texcoord.y;
	r0.x = r0.x * r0.x;
	r0.y = -0.5 + i.texcoord.x;
	r0.x = r0.y * r0.y + r0.x;
	r0.x = -r0.x + 1;
	r1.x = pow(abs(r0.x), 25);
	r0.x = abs(r0.x) + -9.99999997e-007;
	r0.yzw = (i.texcoord1.xxyz * i.texcoord1.w).yzw;
	r0.yzw = (r0.xyzw * r1.x).yzw;
	r0.yzw = (r0.xyzw * OcclusionPercentage.x).yzw;
	r0.xyz = (r0.x >= 0) ? r0.yzw : 0;
	r0.xyz = r0.xyz + UniformPixelVector_0.xyz;
	o.xyz = r0.xyz * i.texcoord4.w;
	o.xyz *= CUSTOM_LENS_FLARE;
	o.w = 0;
	return o;
}
