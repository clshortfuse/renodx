float4 ps_movieAlpha : register( c8 );
sampler2D TextureSampler0 : register( s0 );
sampler2D TextureSampler1 : register( s1 );
sampler2D TextureSampler2 : register( s2 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;

	r0 = tex2D(TextureSampler1, texcoord);
	r0.x = r0.w + -0.5;
	r0.y = r0.x * 1.59599996;
	r1 = tex2D(TextureSampler0, texcoord);
	r0.z = r1.w + -0.0625;
	o.x = r0.z * 1.16400003 + r0.y;
	r1 = tex2D(TextureSampler2, texcoord);
	r0.y = r1.w + -0.5;
	r0.yw = (r0.y * float4(0.391000003, 0.391000003, 0.813000023, 2.01799989)).yw;
	r0.y = r0.z * 1.16400003 + -r0.y;
	o.z = r0.z * 1.16400003 + r0.w;
	o.y = r0.x * -0.813000023 + r0.y;
	o.w = ps_movieAlpha.x;
	return saturate(o);
}