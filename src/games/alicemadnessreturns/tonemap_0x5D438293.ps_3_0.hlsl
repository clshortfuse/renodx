#include "./common.hlsl"

float4 SceneShadowsAndDesaturation : register( c0 );
float4 SceneInverseHighLights : register( c4 );
float4 SceneMidTones : register( c5 );
float4 SceneScaledLuminanceWeights : register( c6 );
float4 GammaColorScaleAndInverse : register( c7 );
float4 GammaOverlayColor : register( c8 );
sampler2D SceneColorTexture : register( s0 );

float4 main(float4 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;

	r0 = tex2D(SceneColorTexture, texcoord.zwzw);
	
	r0.rgb = max(r0.rgb, 0.000000999999997);
    float3 hdr_color = r0.rgb;
    float3 hdr_color_tm = HermiteSplineRolloff(r0.rgb);

    if (SHADOWS_DESATURATION == 0) {
      r0.xyz = r0.xyz + saturate(-SceneShadowsAndDesaturation.xyz);
    } else {
      r0.xyz = saturate(r0.xyz + -SceneShadowsAndDesaturation.xyz);
    }
	r0.xyz = r0.xyz * SceneInverseHighLights.xyz;
	r1.xyz = max(abs(r0.xyz), 0.000000999999997);
	r0.x = log2(r1.x);
	r0.y = log2(r1.y);
	r0.z = log2(r1.z);
	r0.xyz = r0.xyz * SceneMidTones.xyz;
	r1.x = exp2(r0.x);
	r1.y = exp2(r0.y);
	r1.z = exp2(r0.z);
	r0.x = dot(r1.xyz, SceneScaledLuminanceWeights.xyz);
	r0.w = SceneShadowsAndDesaturation.w;
	r0.yzw = (r1.xxyz * r0.w + GammaOverlayColor.xxyz).yzw;
	r0.xyz = r0.x + r0.yzw;
	if (RENODX_TONE_MAP_TYPE == 0) {
	  r0.xyz = saturate(r0.xyz * GammaColorScaleAndInverse.xyz);
	} else {
	  r0.xyz = r0.xyz * GammaColorScaleAndInverse.xyz;
	}
	r1.xyz = max(r0.xyz, 0.000000999999997);
	r0.x = log2(r1.x);
	r0.y = log2(r1.y);
	r0.z = log2(r1.z);
	r0.xyz = r0.xyz * GammaColorScaleAndInverse.w;
	o.x = exp2(r0.x);
	o.y = exp2(r0.y);
	o.z = exp2(r0.z);

	float3 sdr_color = renodx::color::srgb::DecodeSafe(o.rgb);
	o.rgb = ToneMapPass(hdr_color, sdr_color, hdr_color_tm, texcoord.xy);
	o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);

	o.w = 0;
	return o;
}
