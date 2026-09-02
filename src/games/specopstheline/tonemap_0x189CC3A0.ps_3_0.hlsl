#include "./common.hlsli"

float4 BloomTintAndScreenBlendThreshold : register(c0);
float4 ImageAdjustments1 : register(c4);
sampler2D SceneColorTexture : register(s0);
sampler2D NoiseTexture : register(s1);
sampler2D BlurredImageSeperateBloom : register(s2);
sampler2D ColorGradingLUT : register(s3);
sampler2D LowResSceneBuffer : register(s4);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;

	r0 = tex2D(BlurredImageSeperateBloom, i.texcoord.zwzw);
	r0.xyz = r0.xyz * BloomTintAndScreenBlendThreshold.xyz;
	r0.xyz = r0.xyz * 4 * CUSTOM_BLOOM;
	r1 = tex2D(SceneColorTexture, i.texcoord1);
	r2 = tex2D(LowResSceneBuffer, i.texcoord1.zwzw);
	r1.xyz = r1.xyz * r2.w + r2.xyz;
	r0.w = dot(r1.xyz, float3(0.300000012, 0.589999974, 0.109999999));
	if (RENODX_TONE_MAP_TYPE == 0) {
	  r0.w = r0.w * -3;
	} else {
	  r0.w = r0.w * -1;
	}
	r0.w = exp2(r0.w);
	r0.w = saturate(r0.w * BloomTintAndScreenBlendThreshold.w);
	r0.xyz = r0.xyz * r0.w + r1.xyz;
	r0.xyz = r0.xyz + 0.00400000019;

    float3 hdr_color = r0.rgb;
    float3 hdr_color_tm = renodx::tonemap::neutwo::ComputeBT709Scale(hdr_color);
    if (RENODX_TONE_MAP_TYPE > 0) {
      r0.rgb = (hdr_color * hdr_color_tm);
    }
	
	r1.xyz = max(r0.xyz, 0);
	r0.xyz = min(r1.xyz, 16);
	r1.xyz = r0.xyz * r0.xyz;
	r2 = r1.zzxy * 8.10000038 + 0.0700000003;
	r2 = r0.zzxy * r2;
	r0.xyz = r0.xyz * 6.5 + 2.20000005;
	r0.xyz = r1.xyz * r0.xyz + 0.0120000001;
    r1.z = 1.0 / r0.x;
    r1.w = 1.0 / r0.y;
    r1.xy = 1.0 / r0.z;
	r0 = saturate(r1 * r2);
	r1 = -r0.yyzw + 1;
	r1 = r1 * r1;
	r2.w = ImageAdjustments1.w;
	r1 = r1 * r2.w + 0.00390625;
	r2.xy = ImageAdjustments1.xy + i.texcoord2.xy;
	r2.xy = r2.xy * 0.015625;
	r2 = tex2D(NoiseTexture, r2);
	r2.x = r2.x + -0.5;
	r0 = saturate(r2.x * r1 + r0);
	r1.xy = -0.5 + i.texcoord1.xy;
	r1.x = dot(r1.xy, -r1.xy) + 1;
	r1.y = abs(r1.x) + -0.000000999999997;
	r2.x = pow(abs(r1.x), ImageAdjustments1.z);
	r1.x = saturate((r1.y >= 0) ? r2.x : 0);
	r1.x = lerp(1.0, r1.x, CUSTOM_VIGNETTE);
	r0 = r0 * r1.x;
	r1.xyw = (r0.xwzz * float4(14.9998999, 0.9375, 0.9375, 0.05859375)).xyw;
	r0.x = frac(r1.x);
	r0.x = -r0.x + r1.x;
	r1.x = r0.x * 0.0625 + r1.w;
	r0.x = r0.y * 15 + -r0.x;
	r0.yz = (r1.xxyw + float4(0.001953125, 0.064453125, 0.03125, 0)).yz;
	r1.xy = (r1 + float4(0.001953125, 0.03125, 0.064453125, 0)).xy;
	r1 = tex2D(ColorGradingLUT, r1.xy);
	r2 = tex2D(ColorGradingLUT, r0.yzzw);
	r0.yzw = (-r1.xxyz + r2.xxyz).yzw;
	o.xyz = r0.x * r0.yzw + r1.xyz;

	float3 sdr_color = o.rgb;
    o.rgb = DisplayMap(hdr_color, hdr_color_tm, sdr_color, i.texcoord.xy);
    o.w = 0;
	return o;
}
