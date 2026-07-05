#include "./common.hlsli"

float4 PackedParameters : register(c0);
float4 MinZ_MaxZRatio : register(c2);
float4 MinMaxBlurClamp : register(c4);
sampler2D SceneColorTexture : register(s0);
sampler2D BlurredImage : register(s1);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float r2;

	r0 = tex2D(SceneColorTexture, i.texcoord1);
	r0.w = r0.w * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
	r0.w = 1 / r0.w;
	r1.x = min(r0.w, 65504);
	r0.w = r1.x + -MinMaxBlurClamp.z;
	r1.y = max(r0.w, 0);
	r0.w = r1.x + -PackedParameters.x;
	o.w = r1.x;
	r1.x = (r0.w >= 0) ? r1.y : r0.w;
	r1.y = (r0.w >= 0) ? PackedParameters.w : PackedParameters.y;
	r0.w = (r0.w >= 0) ? MinMaxBlurClamp.y : MinMaxBlurClamp.x;
	r1.x = saturate(r1.y * abs(r1.x));
	r1.y = r1.x + -9.99999997e-007;
	r2.x = pow(r1.x, PackedParameters.z);
	r1.x = (r1.y >= 0) ? r2.x : 0;
	r2.x = min(r1.x, r0.w);
	r0.w = saturate(-r2.x + 1);
	r1 = tex2D(BlurredImage, i.texcoord);
	r1.xyz = r1.xyz * 4 * CUSTOM_BLOOM;
	r1.w = r1.w * 4 * CUSTOM_BLOOM + r0.w;
	r0.xyz = r0.xyz * r0.w + r1.xyz;
	r0.w = r1.w + -0.00100000005;
	r1.x = 1 / r1.w;
	r0.w = (r0.w >= 0) ? r1.x : 1000;
	o.xyz = r0.w * r0.xyz;
	return o;
}
