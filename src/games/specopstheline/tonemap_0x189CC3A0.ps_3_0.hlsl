#include "./common.hlsl"

float4 BloomTintAndScreenBlendThreshold : register( c0 );
float4 ImageAdjustments1 : register( c4 );
sampler2D SceneColorTexture : register( s0 );
sampler2D NoiseTexture : register( s1 );
sampler2D BlurredImageSeperateBloom : register( s2 );
sampler2D ColorGradingLUT : register( s3 );
sampler2D LowResSceneBuffer : register( s4 );

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

	r0 = tex2D(BlurredImageSeperateBloom, i.texcoord.zwzw);               // texld r0, v0.zwzw, s2
	r0.xyz = r0.xyz * BloomTintAndScreenBlendThreshold.xyz;               // mul r0.xyz, r0.xyz, c0.xyz
	r0.xyz = r0.xyz * 4 * CUSTOM_BLOOM;                                   // mul_pp r0.xyz, r0.xyz, c2.x
	r1 = tex2D(SceneColorTexture, i.texcoord1);                           // texld_pp r1, v1, s0
	r2 = tex2D(LowResSceneBuffer, i.texcoord1.zwzw);                      // texld_pp r2, v1.zwzw, s4
	r1.xyz = r1.xyz * r2.w + r2.xyz;                                      // mad_pp r1.xyz, r1.xyz, r2.w, r2.xyz
	r0.w = dot(r1.xyz, float3(0.300000012, 0.589999974, 0.109999999));    // dp3_pp r0.w, r1.xyz, c2.yzw
	r0.w = r0.w * -3;                                                     // mul_pp r0.w, r0.w, c1.x
	r0.w = exp2(r0.w);                                                    // exp_pp r0.w, r0.w
	r0.w = saturate(r0.w * BloomTintAndScreenBlendThreshold.w);           // mul_sat_pp r0.w, r0.w, c0.w
	r0.xyz = r0.xyz * r0.w + r1.xyz;                                      // mad_pp r0.xyz, r0.xyz, r0.w, r1.xyz
    r0.xyz = r0.xyz + 0.00400000019;                                      // add_pp r0.xyz, r0.xyz, c1.y

    float3 hdr_color = r0.rgb;
    float3 hdr_color_tm = HermiteSplineRolloff(r0.rgb);

	r1.xyz = max(r0.xyz, 0);                                              // max_pp r1.xyz, r0.xyz, c1.z
	r0.xyz = min(r1.xyz, 16);                                             // min_pp r0.xyz, r1.xyz, c1.w
	r1.xyz = r0.xyz * r0.xyz;                                             // mul_pp r1.xyz, r0.xyz, r0.xyz
	r2 = r1.zzxy * 8.10000038 + 0.0700000003;                             // mad_pp r2, r1.zzxy, c3.x, c3.y
	r2 = r0.zzxy * r2;                                                    // mul_pp r2, r0.zzxy, r2
	r0.xyz = r0.xyz * 6.5 + 2.20000005;                                   // mad_pp r0.xyz, r0.xyz, c3.z, c3.w
	r0.xyz = r1.xyz * r0.xyz + 0.0120000001;                              // mad_pp r0.xyz, r1.xyz, r0.xyz, c5.x
	r1.z = rcp(r0.x);                                                     // rcp r1.z, r0.x
	r1.w = rcp(r0.y);                                                     // rcp r1.w, r0.y
	r1.xy = rcp(r0.z);                                                    // rcp r1.xy, r0.z
	r0 = saturate(r1 * r2);                                               // mul_sat_pp r0, r1, r2
	r1 = -r0.yyzw + 1;                                                    // add_pp r1, -r0.yyzw, c5.y
	r1 = r1 * r1;                                                         // mul_pp r1, r1, r1
	r2.w = ImageAdjustments1.w;                                           // mov_pp r2.w, c4.w
	r1 = r1 * r2.w + 0.00390625;                                          // mad r1, r1, r2.w, c6.x
	r2.xy = ImageAdjustments1.xy + i.texcoord2.xy;                        // add r2.xy, c4.xy, v2.xy
	r2.xy = r2.xy * 0.015625;                                             // mul r2.xy, r2.xy, c5.z
	r2 = tex2D(NoiseTexture, r2);                                         // texld r2, r2, s1
	r2.x = r2.x + -0.5;                                                   // add r2.x, r2.x, c5.w
	r0 = saturate(r2.x * r1 + r0);                                        // mad_sat_pp r0, r2.x, r1, r0
    r1.xy = -0.5 + i.texcoord1.xy;                                        // add r1.xy, c5.w, v1.xy
    r1.x = dot(r1.xy, -r1.xy) + 1;                                        // dp2add r1.x, r1.x, -r1.x, c5.y
    r1.y = abs(r1.x) + -0.000000999999997;                                // add r1.y, r1.x_abs, c6.y
    r2.x = pow(abs(r1.x), ImageAdjustments1.z);                           // pow r2.x, r1.x_abs, c4.z
    r1.x = saturate((r1.y >= 0) ? r2.x : 0);                              // cmp_sat r1.x, r1.y, r2.x, c1.z
    r1.x = lerp(1.0, r1.x, CUSTOM_VIGNETTE);
    r0 = r0 * r1.x;                                                       // mul_pp r0, r0, r1.x
    r1.xyw = (r0.xwzz * float4(14.9998999, 0.9375, 0.9375, 0.05859375)).xyw; // mul r1.xyw, r0.xwz, c7.xzz
	r0.x = frac(r1.x);                                                    // frac r0.x, r1.x
	r0.x = -r0.x + r1.x;                                                  // add r0.x, -r0.x, r1.x
	r1.x = r0.x * 0.0625 + r1.w;                                          // mad r1.x, r0.x, c6.w, r1.w
	r0.x = r0.y * 15 + -r0.x;                                             // mad r0.x, r0.y, c6.z, -r0.x
	r0.yz = (r1.xxyw + float4(0.001953125, 0.064453125, 0.03125, 0)).yz;  // add r0.yz, r1.xxy, c8.xz
	r1.xy = r1.xy + float2(0.001953125, 0.03125);                         // add r1.xy, r1.xy, c8.xy
	r1 = tex2D(ColorGradingLUT, r1.xy);                                   // texld_pp r1, r1, s3
	r2 = tex2D(ColorGradingLUT, r0.yzzw);                                 // texld_pp r2, r0.yzzw, s3
	r0.yzw = (-r1.xxyz + r2.xxyz).yzw;                                    // add r0.yzw, -r1.xxy, r2.xxy
	o.xyz = r0.x * r0.yzw + r1.xyz;                                       // mad_pp oC0.xyz, r0.x, r0.yzw, r1.xyz

	float3 sdr_color = o.rgb;
    o.rgb = ToneMapPass(hdr_color, sdr_color, hdr_color_tm, i.texcoord1.xy);
    o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);
    o.rgb = renodx::color::srgb::DecodeSafe(o.rgb);
	
    o.w = 0;                                                              // mov oC0.w, c1.z
	return o;
}
