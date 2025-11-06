float4 UniformPixelVector_0 : register(c0);
float4 UniformPixelScalars_1 : register(c4);
float MatInverseGamma : register(c5);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	
	r0.x = 0.319999993 + i.texcoord.x;
	r0.y = frac(r0.x);
	r0.x = -r0.y + r0.x;
	r1 = float4(0.680000007, 0.0130000003, 0.986999989, -1) + i.texcoord.xyyx;
	r0.yzw = frac(r1.xxyz).yzw;
	r0.yzw = (-r0.xyzw + r1.xxyz).yzw;
	r0.x = -r0.y + r0.x;
	r0.y = -r0.w + r0.z;
	r0.x = r0.x + 1;
	r0.x = r0.y + r0.x;
	r0.x = saturate(r0.x + 1);
	r0.y = frac(-r1.w);
	r0.y = r0.y + r1.w;
	r0.y = -r0.y + -r0.x;
	r0.x = -r0.x + 1;
	r0.y = saturate(r0.y + 1);
	r0.x = UniformPixelScalars_1.y * r0.x + r0.y;
	o.w = saturate(r0.x);
	r0.xyz = r0.x + UniformPixelVector_0.xyz;
	r0.xyz = r0.xyz * i.texcoord4.w + i.texcoord4.xyz;
	r1.xyz = max(abs(r0.xyz), 0.000000999999997);
	r0.x = log2(r1.x);
	r0.y = log2(r1.y);
	r0.z = log2(r1.z);
	r0.xyz = r0.xyz * MatInverseGamma.x;
	o.x = exp2(r0.x);
	o.y = exp2(r0.y);
	o.z = exp2(r0.z);
	return saturate(o);
}
