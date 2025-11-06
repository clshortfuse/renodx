float4 tor : register( c0 );
float4 tog : register( c1 );
float4 tob : register( c2 );
float4 consts : register( c3 );
sampler2D tex0 : register( s0 );
sampler2D tex1 : register( s1 );
sampler2D tex2 : register( s2 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;

	r0 = tex2D(tex0, texcoord);
	r1 = tex2D(tex1, texcoord);
	r0.y = r1.x;
	r1 = tex2D(tex2, texcoord);
	r0.z = r1.x;
	r0.w = consts.x;
	o.x = dot(tor, r0);
	o.y = dot(tog, r0);
	o.z = dot(tob, r0);
	o.w = consts.w;
	return saturate(o);
}
