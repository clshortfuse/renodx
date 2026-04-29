#include "./common.hlsli"

float OcclusionPercentage : register(c0);
float4 UniformPixelVector_0 : register(c4);

struct PS_IN
{
	float4 texcoord4 : TEXCOORD4;
	float3 texcoord6 : TEXCOORD6;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	float angleSin;
    float angleCos;

	r0.x = dot(i.texcoord6.xyz, i.texcoord6.xyz);
	r0.x = 1 / sqrt(r0.x);
	r0.xy = i.texcoord6.xy * -r0.x + -0.5;
	r0.x = saturate(dot(r0.xy, r0.xy) + 0);
	// sincos(r0.x, r1.xy, r1.xy);
	sincos(r0.x, angleSin, angleCos);
    r1.xy = float2(angleCos, angleSin);
	r0.xy = r1.xy * float2(1, -1);
	r2.xyz = float3(-0.5, 0.5, -0.5) + i.texcoord.xyy;
	r0.x = dot(r0.xy, r2.xy) + 0;
	r0.y = dot(r1.yx, r2.xy) + 0;
	r0.zw = (r2.xyxz * r2.xyxz).zw;
	r0.z = r0.w + r0.z;
	r0.z = -r0.z + 1;
	r1.xy = r0.xy + float2(0.5, -0.5);
	r1.z = 1;
	r1.w = pow(abs(r0.z), 25);
	r0.x = abs(r0.z) + -9.99999997e-007, 25;
	r0.y = r1.w * OcclusionPercentage.x;
	r0.yzw = (r1.xxyz * r0.y).yzw;
	r1.xyz = i.texcoord1.xyz * i.texcoord1.w;
	r0.yzw = (r0.xyzw * r1.xxyz).yzw;
	r0.xyz = (r0.x >= 0) ? r0.yzw : 0;
	r0.xyz = r0.xyz + UniformPixelVector_0.xyz;
	o.xyz = r0.xyz * i.texcoord4.w;
	o.xyz *= CUSTOM_LENS_FLARE;
	o.w = 0;
	return o;
}
