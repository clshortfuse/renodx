float4 UniformPixelVector_0 : register( c0 );
float4 UniformPixelVector_1 : register( c4 );
float4 UniformPixelVector_2 : register( c5 );
float4 UniformPixelScalars_0 : register( c6 );
float4 UniformPixelScalars_1 : register( c7 );
float MatInverseGamma : register( c8 );

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;

	r0.x = -0.5 + i.texcoord.x;
	r0.x = r0.x + r0.x;
	r0.y = abs(r0.x) + -0.000000999999997;
	r1.x = pow(abs(r0.x), UniformPixelScalars_0.x);
	r0.x = (r0.y >= 0) ? r1.x : 0;
	r0.y = -0.5 + i.texcoord.y;
	r0.y = r0.y + r0.y;
	r0.z = abs(r0.y) + -0.000000999999997;
	r1.x = pow(abs(r0.y), UniformPixelScalars_0.y);
	r0.y = (r0.z >= 0) ? r1.x : 0;
	r0.z = r0.y + r0.x;
	r0.x = r0.x * r0.y + r0.z;
	r0.xy = r0.x + float2(0.0299999993, 0.349999994);
	o.w = saturate(r0.y * UniformPixelScalars_1.x);
	r0.x = saturate(r0.x);
	r0.x = UniformPixelScalars_0.z * r0.x + UniformPixelScalars_0.w;
	r1.xyz = UniformPixelVector_1.xyz;
	r0.yzw = (-r1.xxyz + UniformPixelVector_2.xxyz).yzw;
	r0.xyz = r0.x * r0.yzw + UniformPixelVector_1.xyz;
	r0.xyz = r0.xyz + UniformPixelVector_0.xyz;
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
