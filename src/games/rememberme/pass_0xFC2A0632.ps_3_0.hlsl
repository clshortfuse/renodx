#include "./common.hlsl"

float3 ColorScale : register( c0 );
float4 OverlayColor : register( c7 );
sampler2D SceneColorTexture : register( s0 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;

	r0 = tex2D(SceneColorTexture, texcoord);
	r1.xyz = r0.xyz * ColorScale.xyz;
	r2.xyz = ColorScale.xyz;
	r0.xyz = r0.xyz * -r2.xyz + OverlayColor.xyz;
	o.xyz = OverlayColor.w * r0.xyz + r1.xyz;

	o.rgb = renodx::color::srgb::DecodeSafe(o.rgb);
	o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);

	o.w = 1;
	return o;
}
