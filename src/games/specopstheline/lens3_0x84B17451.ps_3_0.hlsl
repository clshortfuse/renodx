#include "./common.hlsli"

float OcclusionPercentage : register(c0);
float4 UniformPixelVector_0 : register(c4);
sampler2D Texture2D_0 : register(s0);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;

	r0.x = 1 + -i.texcoord2.y;
	r0.yzw = (i.texcoord1.xxyz * i.texcoord1.w).yzw;
	r0.xyz = r0.yzw * r0.x;
	r1 = tex2D(Texture2D_0, i.texcoord);
	r0.w = r1.x * OcclusionPercentage.x;
	r0.xyz = r0.w * r0.xyz + UniformPixelVector_0.xyz;
	o.xyz = r0.xyz * i.texcoord4.w;
	o.xyz *= CUSTOM_LENS_FLARE;
	o.w = 0;
	return o;
}
