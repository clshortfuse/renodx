#include "./brightnesslimiter.hlsli"
#include "./common.hlsli"


float4 PackedParameters : register(c0);
float4 MinZ_MaxZRatio : register(c2);
float2 MinMaxBlurClamp : register(c4);
float4 SceneShadowsAndDesaturation : register(c5);
float4 SceneInverseHighLights : register(c6);
float4 SceneMidTones : register(c7);
float4 SceneScaledLuminanceWeights : register(c8);
float4 GammaColorScaleAndInverse : register(c9);
float4 GammaOverlayColor : register(c10);
float4 AtmosphericForegroundColour : register(c11);
float4 AtmosphericBackgroundColour : register(c12);
float4 AtmosphericTransitionSettings : register(c13);

sampler2D SceneColorTexture : register(s0);
sampler2D BlurredImage : register(s1);

struct PS_IN {
  float4 texcoord : TEXCOORD;
  float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i)
    : COLOR {
  float4 o;

  float4 r0;
  float4 r1;
  float4 r2;
  r0 = tex2D(SceneColorTexture, i.texcoord.zwzw);

  r0.w = r0.w * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.w = 1 / r0.w;
  r1.x = r0.w + -PackedParameters.x;
  r2.x = -0.0001;
  r1.y = r0.w * -r2.x + -AtmosphericTransitionSettings.x;
  r1.z = r0.w * -r2.x + -AtmosphericTransitionSettings.z;
  r0.w = saturate(abs(r1.x) * PackedParameters.y);  // mul_sat_pp r0.w, r1.x_abs, c0.y
  r1.x = (r1.x >= 0) ? MinMaxBlurClamp.y : MinMaxBlurClamp.x;
  r1.w = r0.w + -0.0001;
  r0.w = log2(r0.w);
  r0.w = (r1.w >= 0) ? r0.w : -13.287712;
  r0.w = r0.w * PackedParameters.z;
  r0.w = exp2(r0.w);
  r2.x = min(r0.w, r1.x);
  r0.w = saturate(-r2.x + 1);  // add_sat_pp r0.w, -r2.x, c1.z
  r2 = tex2D(BlurredImage, i.texcoord1);
  r2.xyz = r2.xyz * 4;
  r1.x = r2.w * 4 + r0.w;
  r0.xyz = r0.xyz * r0.w + r2.xyz;
  r0.w = 1 / r1.x;

  r0.rgb = r0.rgb * r0.w;
  float3 input = r0.rgb;

  r0.xyz = ConditionalSaturate(r0.rgb - SceneShadowsAndDesaturation.xyz);  // r0.xyz = saturate(r0.xyz * r0.w + -SceneShadowsAndDesaturation.xyz);  // mad_sat r0.xyz, r0.xyz, r0.w, -c5.xyz
  r0.xyz = r0.xyz * SceneInverseHighLights.xyz;
  r2.xyz = ConditionalClipShadows(r0.xyz);  //   r2.xyz = max(abs(r0.xyz), 0.0001);
  r2.rgb = pow(r2.rgb, SceneMidTones.xyz);  // pow(r2.rgb, SceneMidTones.xyz)
  r0.x = dot(r2.xyz, SceneScaledLuminanceWeights.xyz);
  r0.w = SceneShadowsAndDesaturation.w;
  r0.yzw = r2.xyz * r0.w + GammaOverlayColor.xyz;
  r0.xyz = r0.x + r0.yzw;

  r0.xyz = lerp(max(0, input), r0.xyz, RENODX_COLOR_GRADE_STRENGTH);
  float3 graded = r0.rgb;

  r2.x = 1 / AtmosphericTransitionSettings.y;
  r2.y = 1 / AtmosphericTransitionSettings.w;
  r1.xy = r1.yz * r2.xy;
  r2.xy = max(r1.xy, 0);
  r1.xy = r2.xy * 0.15915494 + 0.25;
  r1.zw = r2.xy + -3.1415927;
  r1.xy = frac(r1.xy);
  r1.xy = r1.xy * 6.2831855 + -3.1415927;
  r1.xy = (r1.zw >= 0) ? 1.5707964 : r1.xy;
  r1.xy = r1.xy * r1.xy;
  r1.zw = r1.xy * -2.523985E-07 + 2.47609E-05;
  r1.zw = r1.xy * r1.zw + -0.0013888397;
  r1.zw = r1.xy * r1.zw + 0.04166664;
  r1.zw = r1.xy * r1.zw + -0.5;
  r1.xy = r1.xy * r1.zw + 1;
  r1.xy = r1.xy * AtmosphericForegroundColour.w;
  float3 backgroundContribution = AtmosphericBackgroundColour.xyz * r1.x;
  float3 foregroundContribution = AtmosphericForegroundColour.xyz * r1.y;
  float3 color_fog = foregroundContribution + backgroundContribution;
#if 0
  r0.xyz = graded + color_fog;
#else  // scale foreground fog but not background
  if (CUSTOM_FOG_SCALING > 0.f && RENODX_TONE_MAP_TYPE != 0.f) {
    float3 original = graded + color_fog;

    float3 foreground = FixColorFade(graded, foregroundContribution, 1.f);
    foreground = renodx::color::bt709::clamp::AP1(foreground);

    float3 foreground_and_background = FixColorFade(foreground, backgroundContribution, 1.f, 1.f);
    foreground_and_background = renodx::color::bt709::clamp::AP1(foreground_and_background);

    float3 scaled_final = foreground_and_background;

    scaled_final = lerp(scaled_final, original, saturate(scaled_final / 0.015f));

    r0.rgb = lerp(original, scaled_final, min(0.995f, CUSTOM_FOG_SCALING));
  } else {
    r0.rgb = graded + color_fog;
  }

#endif
  r0.rgb = ConditionalSaturate(r0.rgb * GammaColorScaleAndInverse.xyz, false);  //   r0.xyz = saturate(r0.xyz * GammaColorScaleAndInverse.xyz);  // mul_sat_pp r0.xyz, r0.xyz, c9.xyz

  r1.rgb = ConditionalClipShadows(r0.rgb, false);  //   r1.xyz = max(r0.xyz, 0.0001);

  float3 linear_color = r1.rgb;
  o.rgb = renodx::math::SignPow(linear_color.rgb, GammaColorScaleAndInverse.w);
  o.w = 0;

  o.rgb = ApplyToneMap(o.rgb, i.texcoord.zw, SceneColorTexture);

  return o;
}
