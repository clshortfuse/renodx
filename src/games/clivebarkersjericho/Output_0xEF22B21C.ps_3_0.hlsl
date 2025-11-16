#include "./shared.h"

// Outside tonemapper
float4 g_LevelsInMax : register(c5);
float4 g_LevelsInMin : register(c4);
float4 g_LevelsOutMax : register(c7);
float4 g_LevelsOutMin : register(c6);
float g_LevelsPow : register(c8);
float g_fBloomScale : register(c0);
float g_fBrightness : register(c2);
float g_fContrast : register(c3);
float g_fStarScale : register(c1);

sampler2D s0 : register(s0);  // main scene color
sampler2D s1 : register(s1);  // bloom buffer
sampler2D s2 : register(s2);  // star/streak buffer
sampler2D s3 : register(s3);  // auto-exposure 1×1 buffer

float4 main(float2 texcoord: TEXCOORD) : COLOR
{
  float4 o;   // output color
  float4 r0;  // temp
  float4 r1;  // temp

  // =======================================================
  // Read exposure buffer
  // =======================================================
  r0 = tex2D(s3, 0.5);  // sample 1×1 auto-exposure texture
  r0.w = r0.x + 1.5;    // add constant to exposure value
  // =======================================================
  // Load main scene color
  // =======================================================
  r1 = tex2D(s0, texcoord);  // original pixel color
  // Compute luminance using BT.709 coefficients
  r0.z = dot(r1.xyz, float3(0.2126, 0.7152, 0.0722));
  // Compute exposure scale: (1 - 0.24390244 * (exposure + 1.5))
  r0.w = r0.w * -0.24390244 + 1;
  // =======================================================
  // Exposure-dependent color shift
  // =======================================================
  r0.xyz = r0.z * float3(1.05, 0.97, 1.27) + -r1.xyz;
  r1.xyz = r0.w * r0.xyz + r1.xyz;
  // =======================================================
  // Add star/streak buffer
  // =======================================================
  r0 = tex2D(s2, texcoord);
  r1 = (g_fStarScale.x * Custom_Star_Dispersion) * r0 + r1;
  // =======================================================
  // Add bloom buffer
  // =======================================================
  r0 = tex2D(s1, texcoord);
  r0 = (g_fBloomScale.x * Custom_Bloom) * r0 + r1;
  // =======================================================
  // Levels: Input normalization
  // =======================================================
  r1 = g_LevelsInMin;
  r1 = -r1 + g_LevelsInMax;  // r1 = (InMax - InMin)
  r0 = r0 + -g_LevelsInMin;  // subtract InMin
  r1.x = 1 / r1.x;  		// invert (InMax - InMin)
  r1.y = 1 / r1.y;
  r1.z = 1 / r1.z;
  r1.w = 1 / r1.w;
  r0 = r0 * r1;  			// scale into [0..1] range
  // =======================================================
  // Levels: Output remapping
  // =======================================================
  r1 = g_LevelsOutMin;
  r1 = -r1 + g_LevelsOutMax;  		// r1 = (OutMax - OutMin)
  r0 = r0 * r1 + g_LevelsOutMin;  	// apply output range
  // =======================================================
  // Brightness & contrast
  // =======================================================
  r0 = r0 + g_fBrightness.x;  		// apply brightness

  r0 = r0 + (-0.5 * Custom_Contrast_Intensity );                  // shift around 0.5 before contrast
  r1.w = 0.5;                                                     // 0.5 constant
  float4 unclamped = g_fContrast.x * r0 + (r1.w * Custom_Contrast_Intensity);
  r0 = saturate(g_fContrast.x * r0 + (r1.w * Custom_Contrast_Intensity));  // apply contrast and shift back

  r0.x = log2(r0.x);
  r0.y = log2(r0.y);
  r0.z = log2(r0.z);
  r0.w = log2(r0.w);
  r0 = r0 * g_LevelsPow.x;
  o.x = exp2(r0.x);
  o.y = exp2(r0.y);
  o.z = exp2(r0.z);
  o.w = exp2(r0.w);
  float4 saturated = o;

  float4 untonemapped_sRGB = max(0, unclamped);
  float4 untonemapped = renodx::color::srgba::Decode(untonemapped_sRGB);
  float3 tonemapped = renodx::tonemap::renodrt::NeutralSDR(untonemapped.rgb);
  float4 tonemapped_sRGB = renodx::color::srgba::Encode(float4(tonemapped.rgb, 1));
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    o.rgb = renodx::draw::ToneMapPass(untonemapped.rgb);
  } else {
    o = renodx::color::srgba::Decode(float4(saturated));
  }
  o.a = renodx::color::y::from::BT709(o.rgb);
  o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);

  return o;
}
