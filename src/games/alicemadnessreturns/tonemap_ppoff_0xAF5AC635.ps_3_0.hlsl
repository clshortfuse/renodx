#include "./common.hlsl"

float3 ColorScale : register( c0 );
float4 OverlayColor : register(c4);
float InverseGamma : register(c5);
sampler2D SceneColorTexture : register( s0 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;

	r0 = tex2D(SceneColorTexture, texcoord);

	r0.rgb = max(r0.rgb, 0.000000999999997);
    float3 hdr_color = r0.rgb;
    float3 hdr_color_tm = HermiteSplineRolloff(r0.rgb);
	
	r1.xyz = r0.xyz * ColorScale.xyz;
	r2.xyz = ColorScale.xyz;
	r0.xyz = r0.xyz * -r2.xyz + OverlayColor.xyz;
	o.w = r0.w;
	if (SHADOWS_DESATURATION == 0) {
	  r0.xyz = OverlayColor.w * r0.xyz + r1.xyz;
	} else {
	  r0.xyz = saturate(OverlayColor.w * r0.xyz + r1.xyz);
	}
	r1.xyz = max(r0.xyz, 9.99999997e-007);
	r0.x = log2(r1.x);
	r0.y = log2(r1.y);
	r0.z = log2(r1.z);
	r0.xyz = r0.xyz * InverseGamma.x;
	o.x = exp2(r0.x);
	o.y = exp2(r0.y);
	o.z = exp2(r0.z);

    float3 sdr_color = renodx::color::srgb::DecodeSafe(o.rgb);
    o.rgb = ToneMapPass(hdr_color, sdr_color, hdr_color_tm, texcoord.xy);
    o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);
	return o;
}
