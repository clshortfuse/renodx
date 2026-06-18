#include "./common.hlsli"

float4 UniformPixelVector_0 : register(c0);
float4 MinZ_MaxZRatio : register(c2);
sampler2D PixelTexture2D_0 : register(s0);

struct PS_IN
{
	float4 texcoord5 : TEXCOORD5;
	float2 texcoord : TEXCOORD;
};

float4 SampleSkyBlur(float2 uv)
{
	float2 blur_offset = (abs(ddx(uv)) + abs(ddy(uv))) * 3.5;
	float2 outer_offset = blur_offset * 2.0;
	float4 blurred = tex2D(PixelTexture2D_0, uv) * 0.1;
	blurred += tex2D(PixelTexture2D_0, uv + float2(blur_offset.x, 0)) * 0.1;
	blurred += tex2D(PixelTexture2D_0, uv - float2(blur_offset.x, 0)) * 0.1;
	blurred += tex2D(PixelTexture2D_0, uv + float2(0, blur_offset.y)) * 0.1;
	blurred += tex2D(PixelTexture2D_0, uv - float2(0, blur_offset.y)) * 0.1;
	blurred += tex2D(PixelTexture2D_0, uv + blur_offset) * 0.075;
	blurred += tex2D(PixelTexture2D_0, uv - blur_offset) * 0.075;
	blurred += tex2D(PixelTexture2D_0, uv + float2(blur_offset.x, -blur_offset.y)) * 0.075;
	blurred += tex2D(PixelTexture2D_0, uv + float2(-blur_offset.x, blur_offset.y)) * 0.075;
	blurred += tex2D(PixelTexture2D_0, uv + float2(outer_offset.x, 0)) * 0.05;
	blurred += tex2D(PixelTexture2D_0, uv - float2(outer_offset.x, 0)) * 0.05;
	blurred += tex2D(PixelTexture2D_0, uv + float2(0, outer_offset.y)) * 0.05;
	blurred += tex2D(PixelTexture2D_0, uv - float2(0, outer_offset.y)) * 0.05;
	return blurred;
}

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;
	
	if (RENODX_TONE_MAP_TYPE > 0.f) {
	r0 = SampleSkyBlur(i.texcoord);
	} else {
	r0 = tex2D(PixelTexture2D_0, i.texcoord);	
	}
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
