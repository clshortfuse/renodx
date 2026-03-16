#include "./common.hlsl"

float4 BloomTintAndScreenBlendThreshold : register( c8 );
float4 ImageAdjustments2 : register( c9 );
float4 ImageAdjustments3 : register( c10 );
float4 HalfResMaskRect : register( c11 );
float4 DOFKernelSize : register( c12 );
float4 VignetteSettings : register( c13 );
float4 VignetteColor : register(c14);
sampler2D SceneColorTexture : register(s0);
sampler2D FilterColor1Texture : register(s1);
sampler2D VignetteTexture : register(s2);
sampler2D ColorGradingLUT : register(s3);
sampler2D LowResPostProcessBuffer : register(s4);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	
	r0.y = DOFKernelSize.w + i.texcoord.w;
	r0.x = i.texcoord.z;
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * DOFKernelSize.z;
	r0.x = saturate(dot(r0.x, r0.x) + 0);
	r0.x = -r0.x + 1;
	r0.yz = max(i.texcoord1.xzww, HalfResMaskRect.xxyw).yz;
	r1.xy = min(HalfResMaskRect.zw, r0.yz);
	r1 = tex2D(LowResPostProcessBuffer, r1);
	r0.x = saturate(r0.x + r1.w);
	r2 = float4(1, 1, 0, 0) * i.texcoord1.xyxx;
	r2 = tex2Dlod(SceneColorTexture, r2);
	r0.yzw = (r1.xxyz * -4 + r2.xxyz).yzw;
	r1.xyz = r1.xyz * 4;
	r0.xyz = r0.x * r0.yzw + r1.xyz;

	float3 hdr_color = r0.rgb;
    float3 hdr_color_tm = renodx::tonemap::neutwo::MaxChannel(r0.rgb);
    if (RENODX_TONE_MAP_TYPE > 0) {
      r0.rgb = hdr_color_tm;
    }

	r0.w = dot(r0.xyz, float3(0.300000012, 0.589999974, 0.109999999));
	r0.w = r0.w * -3;
	r0.w = exp2(r0.w);
	r0.w = saturate(r0.w * BloomTintAndScreenBlendThreshold.w);
	r1 = tex2D(FilterColor1Texture, i.texcoord.zwzw);
	r1.xyz = r1.xyz * BloomTintAndScreenBlendThreshold.xyz;
	r1.xyz = r1.xyz * 4 * CUSTOM_BLOOM;
	r0.xyz = r1.xyz * r0.w + r0.xyz;
	r1.xyz = r0.xyz * VignetteColor.xyz;
	r2.xyz = r0.xyz * -VignetteColor.xyz + r0.xyz;
	r1.xyz = i.texcoord1.y * r2.xyz + r1.xyz;
	r2.xyz = r0.xyz * r1.xyz;
	r1.xyz = r0.xyz * -r1.xyz + r0.xyz;
	r3.xy = i.texcoord1.xy + i.texcoord1.xy;
	r3 = tex2D(VignetteTexture, r3);
	r0.w = saturate(r3.x + VignetteSettings.y);
	r1.xyz = r0.w * r1.xyz + r2.xyz;
	r2.y = 0.00999999978;
	r0.w = r2.y + -VignetteSettings.x;
    r0.xyz = (r0.w >= 0) ? r0.xyz : r1.xyz;
	r0.xyz = lerp(hdr_color, r0.xyz, CUSTOM_VIGNETTE);
	r1 = r0.zzxy + -ImageAdjustments2.z;
	r1 = saturate(r1 * 10000);
	r2.xyz = r0.xyz + ImageAdjustments2.x;
	r3.z = 1 / abs(r2.x);
	r3.w = 1 / abs(r2.y);
	r3.xy = 1 / abs(r2.z);
	r2 = r0.zzxy * r3;
	r0.xyz = r0.xyz * ImageAdjustments2.w;
	r3.x = log2(r0.x);
	r3.y = log2(r0.y);
	r3.z = log2(r0.z);
	r0.xyz = r3.xyz * 0.454545468;
	r3.z = exp2(r0.x);
	r3.w = exp2(r0.y);
	r3.xy = exp2(r0.z);
	r0 = r2.yyzw * ImageAdjustments2.y + -r3.yyzw;
	r0 = r1 * r0 + r3;
	r1 = r2 * ImageAdjustments2.y + -r0.yyzw;
	r0 = saturate(ImageAdjustments3.x * r1 + r0);
	r1.xyw = (r0.xwzz * float4(14.9998999, 0.9375, 0.9375, 0.05859375)).xyw;
	r0.x = frac(r1.x);
	r0.x = -r0.x + r1.x;
	r1.x = r0.x * 0.0625 + r1.w;
	r0.x = r0.y * 15 + -r0.x;
	r1 = r1.xyxy + float4(0.001953125, 0.03125, 0.064453125, 0.03125);
	r2 = tex2D(ColorGradingLUT, r1.zwzw);
	r1 = tex2D(ColorGradingLUT, r1.xy);
	r0.yzw = (-r1.xxyz + r2.xxyz).yzw;
	o.xyz = r0.x * r0.yzw + r1.xyz;

	float3 sdr_color = renodx::color::srgb::DecodeSafe(o.rgb);
	o.rgb = UpgradeToneMap(hdr_color, hdr_color_tm, sdr_color, i.texcoord.xy);
	o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);
	
	o.w = 0;
	return o;
}
