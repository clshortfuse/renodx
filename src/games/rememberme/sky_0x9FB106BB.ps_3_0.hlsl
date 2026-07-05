#include "./common.hlsli"

float4 UniformPixelVector_0 : register(c0);
float4 MinZ_MaxZRatio : register(c2);
sampler2D PixelTexture2D_0 : register(s0);

struct PS_IN
{
	float4 texcoord5 : TEXCOORD5;
	float2 texcoord : TEXCOORD;
};

float4 BlurTexture(sampler2D source_texture, float2 texcoord, float2 texel_size, float radius = 1.f)
{
	float2 offset = texel_size * radius;
	float4 color = tex2D(source_texture, texcoord) * 4.f;

	color += tex2D(source_texture, texcoord + float2(-offset.x, -offset.y));
	color += tex2D(source_texture, texcoord + float2(0.f, -offset.y)) * 2.f;
	color += tex2D(source_texture, texcoord + float2(offset.x, -offset.y));
	color += tex2D(source_texture, texcoord + float2(-offset.x, 0.f)) * 2.f;
	color += tex2D(source_texture, texcoord + float2(offset.x, 0.f)) * 2.f;
	color += tex2D(source_texture, texcoord + float2(-offset.x, offset.y));
	color += tex2D(source_texture, texcoord + float2(0.f, offset.y)) * 2.f;
	color += tex2D(source_texture, texcoord + float2(offset.x, offset.y));

	return color * (1.f / 16.f);
}

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;
	
	// r0 = tex2D(PixelTexture2D_0, i.texcoord);
	r0 = BlurTexture(PixelTexture2D_0, i.texcoord, float2(1.f / 2048.f, 1.f / 2048.f), 0.5f);	
	r1.xyz = r0.xyz + -0.972000003;
	r2.xyz = r0.xyz * -1.02750003 + 1;
	r0.xyz = r0.xyz * 0.226050004;
	r1.xyz = (r1.xyz >= 0) ? 0.00126997079 : r2.xyz;
	r2.x = 1 / r1.x;
	r2.y = 1 / r1.y;
	r2.z = 1 / r1.z;
	o.xyz = r0.xyz * r2.xyz + UniformPixelVector_0.xyz;
	r0.x = 1 / i.texcoord5.w;
	o.w = MinZ_MaxZRatio.x * r0.x + MinZ_MaxZRatio.y;
	return o;
}
