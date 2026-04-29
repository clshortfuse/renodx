#include "./common.hlsli"

float4 SceneShadowsAndDesaturation : register(c0);
float4 SceneInverseHighLights : register(c4);
float4 SceneMidTones : register(c5);
float4 SceneScaledLuminanceWeights : register(c6);
float4 GammaColorScaleAndInverse : register(c7);
float4 GammaOverlayColor : register(c8);
sampler2D SceneColorTexture : register(s0);

float4 main(float4 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;

	r0 = tex2D(SceneColorTexture, texcoord.zwzw);	
	float3 scene_color = r0.rgb;
    if (RENODX_TONE_MAP_TYPE == 0) {
      r0.xyz = saturate(r0.xyz + -SceneShadowsAndDesaturation.xyz);
      r0.xyz = r0.xyz * SceneInverseHighLights.xyz;
      r1.xyz = max(abs(r0.xyz), 0.000000999999997);
    } else {
      r0.xyz = max(0, r0.xyz + -SceneShadowsAndDesaturation.xyz);
      r0.xyz = r0.xyz * SceneInverseHighLights.xyz;
      r1.xyz = max(abs(r0.xyz), 0);
    }
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
	if (RENODX_TONE_MAP_TYPE > 0) {
    r0.rgb = lerp(max(0, scene_color), r0.rgb, RENODX_COLOR_GRADE_STRENGTH);
	}
	if (RENODX_TONE_MAP_TYPE == 0) {
	  r0.xyz = saturate(r0.xyz * GammaColorScaleAndInverse.xyz);
	  r1.xyz = max(r0.xyz, 0.000000999999997);
	} else {
	  r0.xyz = max(0, r0.xyz * GammaColorScaleAndInverse.xyz);
	  r1.xyz = max(r0.xyz, 0);
	}
	r0.x = log2(r1.x);
	r0.y = log2(r1.y);
	r0.z = log2(r1.z);
	r0.xyz = r0.xyz * GammaColorScaleAndInverse.w;
	o.x = exp2(r0.x);
	o.y = exp2(r0.y);
	o.z = exp2(r0.z);

	float3 hdr_color = renodx::color::srgb::DecodeSafe(o.rgb);
    o.rgb = DisplayMap(hdr_color, texcoord.xy);
    o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);

	o.w = 0;
	return o;
}
