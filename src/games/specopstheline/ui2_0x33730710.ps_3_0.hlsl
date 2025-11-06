float4 UniformPixelVector_0 : register( c0 );
float4 UniformPixelVector_1 : register( c4 );
float4 UniformPixelVector_2 : register( c5 );
float4 UniformPixelScalars_0 : register( c6 );
float4 UniformPixelScalars_1 : register( c7 );
float MatInverseGamma : register(c8);
sampler2D Texture2D_0 : register(s0);
sampler2D Texture2D_1 : register(s1);

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
	float4 r2;
	float3 r3;

	r0.x = 1 / UniformPixelScalars_0.x;
	r0.xy = r0.x * UniformPixelVector_2.xz;
	r1.x = 1 / UniformPixelScalars_0.y;
	r0.zw = (r1.x * UniformPixelVector_2.xyyw).zw;
	r0.xy = i.texcoord.xy * r0.yw + r0.xz;
	r0.xy = r0.xy * float2(4, 1);
	r0 = tex2D(Texture2D_0, r0);
	r1.x = saturate(r0.w * UniformPixelScalars_1.y);
	r0.xyz = r0.xyz * r0.w;
	r2 = tex2D(Texture2D_1, i.texcoord);
	o.w = saturate(r1.x + r2.w);
	r0.w = dot(r2.xyz, float3(0.300000012, 0.589999974, 0.109999999));
	r1.xyz = lerp(r2.xyz, r0.w, 0.800000012);
	r3.xyz = UniformPixelScalars_0.z * r2.xyz + -r1.xyz;
	r1.xyz = UniformPixelScalars_0.w * r3.xyz + r1.xyz;
	r3.xyz = lerp(-0.00999999978, r1.xyz, r2.w);
	r1.xyz = float3(0.200000003, 0.00300000003, 0);
	r1.xyz = r2.w * r1.xyz + float3(0.100000001, 0.00150000001, 0);
	r1.xyz = r2.xyz * float3(0.0500000007, 0.0500000007, 0.0500000007) + r1.xyz;
	r2.xyz = lerp(r3.xyz, r1.xyz, UniformPixelScalars_1.x);
	r1.y = 1;
	r3.xyz = lerp(UniformPixelVector_1.xyz, r1.y, r0.xyz);
	r0.xyz = lerp(r3.xyz, r2.xyz, r2.w);
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
