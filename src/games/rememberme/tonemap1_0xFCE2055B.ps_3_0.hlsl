#include "./common.hlsli"

float4 BloomTintAndScreenBlendThreshold : register(c0);
float4 ImageAdjustments1 : register(c7);
float4 ImageAdjustments2 : register(c8);
float4 HalfResMaskRect : register(c9);
float4 DNEImageGrainParameter : register(c10);
float4 DNEVignetColor : register(c11);
float4 DNEVignetMaskFactors : register(c12);
sampler2D SceneColorTexture : register(s0);
sampler2D FilterColor1Texture : register(s1);
sampler2D DNEImageGrainTexture : register(s2);
sampler2D DNEVignetTexture : register(s3);
sampler2D ColorGradingLUT : register(s4);
sampler2D LowResPostProcessBuffer : register(s5);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	
	r0 = float4(1, 1, 0, 0) * i.texcoord1.xyxx;
	r0 = tex2Dlod(SceneColorTexture, r0);
	r1.xy = max(i.texcoord1.zw, HalfResMaskRect.xy);
	r2.xy = min(HalfResMaskRect.zw, r1.xy);
	r1 = tex2D(LowResPostProcessBuffer, r2);
	// r0 = r1.zzxy * -4 + r0.zzxy;
	// r2 = r1.zzxy * 4;
	// r0 = r1.w * r0 + r2;
	float3 hdr_color = lerp(r1.xyz * 4, r0.rgb, r1.w);
	
	r1.x = dot(hdr_color, float3(0.300000012, 0.589999974, 0.109999999));
	r1.x = r1.x * -3;
	r1.x = exp2(r1.x);
	r1.x = saturate(r1.x * BloomTintAndScreenBlendThreshold.w);
	r2 = tex2D(FilterColor1Texture, i.texcoord.zwzw);
	r2 = r2.zzxy * BloomTintAndScreenBlendThreshold.zzxy;
	r2 = r2 * 4 * CUSTOM_BLOOM;
	
	hdr_color += r2.zwy * r1.x;
	float3 hdr_color_tm = renodx::tonemap::neutwo::ComputeMaxChannelScale(hdr_color);
	float3 pre_lut_color = hdr_color;
	if (RENODX_TONE_MAP_TYPE > 0) {
		pre_lut_color = (hdr_color * hdr_color_tm);
	}
	r0 = float4(pre_lut_color.b, pre_lut_color.b, pre_lut_color.r, pre_lut_color.g);

	r1.xyz = r0.zwy * ImageAdjustments2.y + ImageAdjustments2.x;
	r2.z = 1 / r1.x;
	r2.w = 1 / r1.y;
	r2.xy = 1 / r1.z;
	r0 = saturate(r0 * r2);
	r1.xyw = (r0.xwzz * float4(14.9998999, 0.234375, 0.234375, 0.05859375)).xyw;
	r0.x = frac(r1.x);
	r0.x = -r0.x + r1.x;
	r1.x = r0.x * 0.0625 + r1.w;
	r0.x = r0.y * 15 + -r0.x;
	r1 = r1.xyxy + float4(0.001953125, 0.0078125, 0.064453125, 0.0078125);
	r2 = tex2D(ColorGradingLUT, r1.xy);
	r1 = tex2D(ColorGradingLUT, r1.zwzw);
	r3 = lerp(r2, r1, r0.x);

	float3 sdr_color = renodx::color::srgb::DecodeSafe(r3.rgb);
	float3 output_color = DisplayMap(hdr_color, hdr_color_tm, sdr_color);
	r3.rgb = renodx::color::srgb::EncodeSafe(output_color);

	r0 = tex2D(DNEVignetTexture, i.texcoord2.zwzw);
	r0.x = saturate(dot(r0, DNEVignetMaskFactors));
	r1.xz = float4(1, 0, 4, -3).xz;
	r0.yzw = (-r1.x + DNEVignetColor.xxyz).yzw;
	r0.xyz = r0.x * r0.yzw + 1;
	r0.xyz = lerp(1.0, r0.xyz, CUSTOM_VIGNETTE);
	if (FILM_GRAIN_TYPE == 0) {
	  o.xyz = r3.xyz * r0.xyz;
	  output_color = renodx::color::srgb::DecodeSafe(o.rgb);	
	  float3 film_grain = FilmGrain(output_color, i.texcoord.xy, DNEImageGrainParameter.xy);
	  o.rgb = renodx::color::srgb::EncodeSafe(film_grain);	
	} else {
	  r1.xy = i.texcoord2.zw * r1.z + DNEImageGrainParameter.xy;
	  r1 = tex2D(DNEImageGrainTexture, r1);
	  r0.w = r1.x * 2 + -1;
	  r0.w = r0.w * ImageAdjustments1.w * (CUSTOM_FILM_GRAIN_STRENGTH * 2.f);
	  o.xyz = r3.xyz * r0.xyz + r0.w;	
	}
	o.w = r3.w;
	return o;
}
