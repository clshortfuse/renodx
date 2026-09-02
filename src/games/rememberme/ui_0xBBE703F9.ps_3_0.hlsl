float InverseGamma : register(c0);
float4 ColorScale : register(c7);
float4 ColorBias : register(c8);
sampler2D TextureImage : register(s0);

struct PS_IN
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;

	r0 = tex2D(TextureImage, i.texcoord);
	r0 = r0 + -i.color;
	r1 = i.color;
	r0 = i.color1.z * r0 + r1;
	r1 = ColorScale;
	r0 = r0 * r1 + ColorBias;
	o.w = r0.w * i.color1.w;
	r0.xyz = saturate(r0.xyz);
	r1.x = log2(r0.x);
	r1.y = log2(r0.y);
	r1.z = log2(r0.z);
	r0.xyz = r1.xyz * InverseGamma.x;
	o.x = exp2(r0.x);
	o.y = exp2(r0.y);
	o.z = exp2(r0.z);
	return saturate(o);
}
