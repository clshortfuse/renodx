#include "./shared.h"

float4 DynamicTonemappingParam : register( c0 );
sampler2D SceneColorTexture : register( s0 );
sampler2D Tex0 : register( s1 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;

	r0 = tex2D(Tex0, 0.5);
	r0.y = r0.x + -0.0000999999975;
	r0.x = 1 / r0.x;
	r0.x = (r0.y >= 0) ? r0.x : 10000;
	r0.x = r0.x * DynamicTonemappingParam.x;
	r1.x = max(r0.x, DynamicTonemappingParam.y);
	r0.x = min(DynamicTonemappingParam.z, r1.x);
	r1 = tex2D(SceneColorTexture, texcoord);
	
	r1.rgb = max(r1.rgb, 0.000000999999997);
	r0.x = lerp(1.f, r0.x, CUSTOM_AUTO_EXPOSURE);

	o.xyz = r0.x * r1.xyz;
	o.w = r1.w;
	return o;
}
