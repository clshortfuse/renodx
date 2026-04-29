#include "./common.hlsli"

float4 UniformPixelVector_0 : register(c0);
float4 MinZ_MaxZRatio : register(c2);
sampler2D PixelTexture2D_0 : register(s0);

struct PS_IN
{
	float4 texcoord5 : TEXCOORD5;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;
	
	r0 = tex2D(PixelTexture2D_0, i.texcoord);
	r1.xyz = r0.xyz + -0.972000003;
	r2.xyz = r0.xyz * -1.02750003 + 1;
	r0.xyz = r0.xyz * 0.226050004;
	r1.xyz = (r1.xyz >= 0) ? 0.00126997079 : r2.xyz;
	r2.x = 1 / r1.x;
	r2.y = 1 / r1.y;
	r2.z = 1 / r1.z;
	o.xyz = r0.xyz * r2.xyz + UniformPixelVector_0.xyz;
	if (RENODX_TONE_MAP_TYPE > 0.f) {
	  o.rgb = renodx::tonemap::ExponentialRollOff(o.rgb);
	  o.rgb = ApplyHDRBoost(o.rgb);
	}	
	r0.x = 1 / i.texcoord5.w;
	o.w = MinZ_MaxZRatio.x * r0.x + MinZ_MaxZRatio.y;
	return o;
}
