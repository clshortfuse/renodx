#include "./common.hlsl"

float4 tor : register( c0 );
float4 tog : register( c1 );
float4 tob : register( c2 );
float4 consts : register( c3 );
float4 DNEGrainOffset : register( c4 );
float4 DNEBlur : register( c5 );
sampler2D tex0 : register( s0 );
sampler2D tex1 : register( s1 );
sampler2D tex2 : register( s2 );
sampler2D DNEGrainTexture : register( s3 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float4 r2;
	float4 r3;
	float4 r4;

	r0.xy = float2(0.00156250002, 0.00277777785);
	r0.xy = r0.xy * DNEBlur.x;
	r1.xyz = 0;
	r2.x = 0;
	for (int i0 = 0; i0 < 5; i0++) {
		r2.xw = r2.x + 1;
		r3.xyz = r1.xyz;
		r3.w = 0;
		for (int i1 = 0; i1 < 5; i1++) {
			r2.yz = r3.w + -2;
			r0.zw = r2.xy * r0.xy + texcoord.xy;
			r4 = tex2D(tex0, r0.zwzw);
			r3.x = r3.x + r4.x;
			r4 = tex2D(tex1, r0.zwzw);
			r3.y = r3.y + r4.x;
			r4 = tex2D(tex2, r0.zwzw);
			r3.z = r3.z + r4.x;
			r3.w = r2.z;
		}
		r1.xyz = r3.xyz;
	}
	r0.xyz = r1.xyz * 0.0399999991;
	r0.w = consts.x;
	r1.x = dot(tor, r0);
	r1.y = dot(tog, r0);
	r1.z = dot(tob, r0);
	r0.x = dot(r1.xyz, 0.166666672);
	r0.x = r0.x + 0.5;
	r2.xyz = lerp(r1.xyz, r0.x, DNEBlur.x);
	//r0.xy = DNEGrainOffset.xy;
	//r0.xy = texcoord.xy * 4 + r0.xy;
	//r0 = tex2D(DNEGrainTexture, r0);
	//r0.x = r0.x * 2 + -1;
	//o.xyz = saturate(r0.x * DNEGrainOffset.w + r2.xyz);
	o.xyz = saturate(r2.xyz);

	float3 output_color = o.rgb;
	o.rgb = FilmGrain(output_color, texcoord.xy);
	
	o.w = consts.w;
	return o;
}
