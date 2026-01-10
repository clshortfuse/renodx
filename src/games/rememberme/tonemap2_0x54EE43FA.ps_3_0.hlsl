#include "./common.hlsl"

float4 BloomTintAndScreenBlendThreshold : register( c0 );
float4 MinZ_MaxZRatio : register( c2 );
float2 NvStereoEnabled : register( c3 );
float4 ImageAdjustments1 : register( c7 );
float4 ImageAdjustments2 : register( c8 );
float4 HalfResMaskRect : register( c9 );
float RainIntensity : register( c10 );
float4 UVScaleBias : register( c11 );
float4 SceneCoordinate1ScaleBias : register( c12 );
float4 SceneCoordinate2ScaleBias : register( c13 );
float4 SceneCoordinate3ScaleBias : register( c14 );
float4 RainLayersDist : register( c15 );
float4 RainAlphas : register( c16 );
float4 DNEScreenPositionScaleBias : register( c17 );
float4 DNEImageGrainParameter : register( c18 );
float4 DNEVignetColor : register( c19 );
float4 DNEVignetMaskFactors : register(c20);
sampler2D SceneColorTexture : register(s0);
sampler2D NvStereoFixTexture : register(s1);
sampler2D FilterColor1Texture : register(s2);
sampler2D RainTexture : register(s3);
sampler2D RainBlendTexture : register(s4);
sampler2D DNEImageGrainTexture : register(s5);
sampler2D DNEVignetTexture : register(s6);
sampler2D ColorGradingLUT : register(s7);
sampler2D LowResPostProcessBuffer : register(s8);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	float4 r8;

	r0.x = -RainLayersDist.x + RainLayersDist.y;
	r0.y = RainLayersDist.y + RainLayersDist.x;
	r0.z = -r0.y + RainLayersDist.z;
	r0.y = r0.y + RainLayersDist.z;
	r0.y = -r0.y + RainLayersDist.w;
	r0.w = abs(NvStereoEnabled.x);
	if (NvStereoEnabled.x != -NvStereoEnabled.x) {
		r1 = tex2D(NvStereoFixTexture, float4(0.0625, 0, 4, -3));
		r1.y = -r1.y + i.texcoord.w;
		r1.x = r1.x * r1.y + i.texcoord.x;
		r1.yz = (i.texcoord.xyww).yz;
	} else {
		r1.xyz = 0;
	}
	r1.xyz = (-r0.w >= 0) ? i.texcoord.xyw : r1.xyz;
	r0.w = 1 / r1.z;
	r1.xy = r0.w * r1.xy;
	r1.zw = (r1.xyxy * SceneCoordinate1ScaleBias.xyxy + SceneCoordinate1ScaleBias.xywz).zw;
	r2.xy = (r1.xyxy * UVScaleBias.xyxy + UVScaleBias.wzzw).xy;
	r3.xy = (r1.zwzw * SceneCoordinate2ScaleBias.xyxy + SceneCoordinate2ScaleBias.wzzw).xy;
	r3.zw = (r1.xyxy * SceneCoordinate3ScaleBias.xyxy + SceneCoordinate3ScaleBias.xywz).zw;
	r1.zw = (r1.xyxy * DNEScreenPositionScaleBias.xyxy + DNEScreenPositionScaleBias.xywz).zw;
	r4.xy = max(r3.xy, HalfResMaskRect.xy);
	r3.xy = min(HalfResMaskRect.zw, r4.xy);
	r2.zw = 0;
	r2 = tex2Dlod(SceneColorTexture, r2);
	r0.w = r2.w + -MinZ_MaxZRatio.y;
	r0.w = 1 / r0.w;
	r4 = tex2D(LowResPostProcessBuffer, r3);

    float3 hdr_color = r2.rgb;
    float3 hdr_color_tm = HermiteSplineRolloff(r2.rgb);

	r5 = r4.zzxy * 4;
	r2 = r4.zzxy * -4 + r2.zzxy;
	r2 = r4.w * r2 + r5;
	r3 = tex2D(FilterColor1Texture, r3.zwzw);
	r3 = r3.zzxy * BloomTintAndScreenBlendThreshold.zzxy;
	r3 = r3 * 4 * CUSTOM_BLOOM;
	r4.x = dot(r2.zwy, float3(0.300000012, 0.589999974, 0.109999999));
	r4.x = r4.x * -3;
	r4.x = exp2(r4.x);
	r4.x = saturate(r4.x * BloomTintAndScreenBlendThreshold.w);
	r2 = r3 * r4.x + r2;
	r3.xy = float2(0, 1);
	r4 = r3.xyyy * RainLayersDist.xxyz;
	r4 = MinZ_MaxZRatio.x * r0.w + -r4;
	r5.x = 1 / RainLayersDist.x;
	r5.y = 1 / r0.x;
	r5.z = 1 / r0.z;
	r5.w = 1 / r0.y;
	r0 = saturate(r4 * r5);
	r0 = r0 * RainAlphas;
	r1.xy = r1.xy * float2(0.5, -0.5) + 0.5;
	r4 = tex2D(RainBlendTexture, r1);
	r5 = tex2D(RainTexture, i.texcoord3);
	r6 = tex2D(RainTexture, i.texcoord3.zwzw);
	r7 = tex2D(RainTexture, i.texcoord4);
	r8 = tex2D(RainTexture, i.texcoord4.zwzw);
	r0 = r0 * r4;
	r5.y = r6.x;
	r5.z = r7.x;
	r5.w = r8.x;
	r0.x = dot(r5, r0);
	r0.x = r0.x * RainIntensity.x;
	r0 = r0.x * 0.0900000036 + r2;
	r2.xyz = r0.zwy * ImageAdjustments2.y + ImageAdjustments2.x;
	r4.z = 1 / r2.x;
	r4.w = 1 / r2.y;
	r4.xy = 1 / r2.z;
	r0 = saturate(r0 * r4);
	r2.xyw = (r0.xwzz * float4(14.9998999, 0.234375, 0.234375, 0.05859375)).xyw;
	r0.x = frac(r2.x);
	r0.x = -r0.x + r2.x;
	r0.y = r0.y * 15 + -r0.x;
	r2.x = r0.x * 0.0625 + r2.w;
	r2 = r2.xyxy + float4(0.001953125, 0.0078125, 0.064453125, 0.0078125);
	r4 = tex2D(ColorGradingLUT, r2.xy);
	r2 = tex2D(ColorGradingLUT, r2.zwzw);
	r5 = lerp(r4, r2, r0.y);
	r0.z = 4;
	//r0.xy = r1.zw * r0.z + DNEImageGrainParameter.xy;
	r1 = tex2D(DNEVignetTexture, r1.zwzw);
	r0.z = saturate(dot(r1, DNEVignetMaskFactors)) * CUSTOM_VIGNETTE;
	r1.xyz = -r3.y + DNEVignetColor.xyz;
	r1.xyz = r0.z * r1.xyz + 1;
	//r0 = tex2D(DNEImageGrainTexture, r0);
	//r0.x = r0.x * 2 + -1;
	//r0.x = r0.x * ImageAdjustments1.w;
	//o.xyz = saturate(r5.xyz * r1.xyz + r0.x);
	o.xyz = saturate(r5.xyz * r1.xyz);

	float3 sdr_color = renodx::color::srgb::DecodeSafe(o.rgb);
	o.rgb = ToneMapPass(hdr_color, sdr_color, hdr_color_tm, i.texcoord.xy);
	o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);

	o.w = r5.w;
	return o;
}
