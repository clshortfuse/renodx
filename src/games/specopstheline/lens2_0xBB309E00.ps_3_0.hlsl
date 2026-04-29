#include "./common.hlsli"

float OcclusionPercentage : register(c0);
float4 UniformPixelVector_0 : register(c4);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;

	r0.xy = i.texcoord.xy * float2(1.20000005, 1) + float2(-0.270000011, 0.349999994);
	r0.zw = float2(1 + -1.10000002 * i.texcoord.x, 1 + -i.texcoord.y);
	r0.xy = r0.zw * r0.xy;
	r0.x = (r0.x + r0.y) * 2;
	r0.y = abs(r0.x) + -9.99999997e-007;
	r1.x = pow(abs(r0.x), 12);
	r0.x = saturate((r0.y >= 0) ? r1.x : 0);
	r0.xy = -r0.x + float2(1, 0.999998987);
	r1.x = pow(r0.x, 15);
	r0.x = (r0.y >= 0) ? r1.x : 0;
	r0.yz = 1 + -i.texcoord.xy;
	r0.yz = r0.yz * i.texcoord.xy;
	r0.y = (r0.y + r0.z) * 2;
	r0.z = abs(r0.y) + -9.99999997e-007;
	r1.x = pow(abs(r0.y), 10);
	r0.y = (r0.z >= 0) ? r1.x : 0;
	r0.x = saturate(r0.x * r0.y);
	r0.x = r0.x * OcclusionPercentage.x;
	r1.xyz = i.texcoord1.xyz * i.texcoord1.w;
	r0.yzw = (r0.y * r1.xxyz).yzw;
	r1.x = 10;
	r0.yzw = (r0.xyzw * r1.x + UniformPixelVector_0.xxyz).yzw;
	r0.yzw = (r0.xyzw * i.texcoord4.w).yzw;
	o.xyz = r0.x * r0.yzw;
	o.xyz *= CUSTOM_LENS_FLARE;
	o.w = 0;
	return o;
}
