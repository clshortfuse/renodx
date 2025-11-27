#include "./shared.h"

// Mostly Inside tonemapper
float4 g_LevelsInMax : register(c6);
float4 g_LevelsInMin : register(c5);
float4 g_LevelsOutMax : register(c8);
float4 g_LevelsOutMin : register(c7);
float g_LevelsPow : register(c9);
float g_fBloomScale : register(c1);
float g_fBrightness : register(c3);
float g_fContrast : register(c4);
float g_fMiddleGray : register(c0);
float g_fStarScale : register(c2);
sampler2D s0 : register(s0);  // main input color
sampler2D s1 : register(s1);  // bloom buffer
sampler2D s2 : register(s2);  // star streak buffer
sampler2D s3 : register(s3);  // auto-exposure 1x1 buffer

float4 main(float2 texcoord: TEXCOORD) : COLOR
{
  float4 o;   // final output
  float4 r0;  // temp register
  float4 r1;  // temp register
  float4 r2;  // temp register
  // =====================================================
  // Exposure
  // =====================================================
  r0 = tex2D(s3, 0.5);                // exposure buffer at center (single pixel)
  r0.xy = r0.x + float2(1.5, 0.01);   // added constants to the exposure value
  r2.w = r0.x * -0.24390244 + 1;      // exposure scale (1 - 0.2439 * exposure)
  r1 = tex2D(s0, texcoord);
  r0.z = dot(r1.xyz, float3(0.2126, 0.7152, 0.0722));  // Fixed vanilla Bt.601 to Rev.709
  r0.w = 1 / r0.y;                                     // inverse of the modified exposure value (r0.y)
  // =====================================================
  // Color shift
  // =====================================================
  r0.xyz = lerp(r1.xyz, r0.z * float3(1.05, 0.97, 1.27) + -r1.xyz, Custom_Color_Tint_Intensity);
  r0.xyz = ((r2.w * r0.xyz) * Custom_Color_Tint_Intensity ) + r1.xyz;
  r0.w = r0.w * g_fMiddleGray.x;
  r1.xyz = r0.xyz * r0.w;
  // =====================================================
  // Star streak texture
  // =====================================================
  r0 = tex2D(s2, texcoord);
  r1 = (g_fStarScale.x * Custom_Star_Dispersion) * r0 + r1;
  // =====================================================
  // Bloom texture
  // =====================================================
  r0 = tex2D(s1, texcoord);
  r0 = (g_fBloomScale.x * Custom_Bloom) * r0 + r1;
  // =====================================================
  // Levels input normalization
  // =====================================================
  r1 = g_LevelsInMin;
  r1 = -r1 + g_LevelsInMax;  // r1 = (InMax - InMin)
  r0 = r0 + -g_LevelsInMin;  // subtract input min
  r1.x = 1 / r1.x;           // invert (InMax - InMin) per channel
  r1.y = 1 / r1.y;
  r1.z = 1 / r1.z;
  r1.w = 1 / r1.w;
  r0 = r0 * r1;              // normalize input to 0–1 range
  // =====================================================
  // Levels output mapping
  // =====================================================
  r1 = g_LevelsOutMin;
  r1 = -r1 + g_LevelsOutMax;                                                // r1 = (OutMax - OutMin)
  r0 = lerp(r0, r0 * r1 + g_LevelsOutMin, Custom_Color_Tint2_Intensity);  	// apply output range
  // =====================================================
  // Brightness & Contrast
  // =====================================================
  r0 = lerp(r0, r0 + g_fBrightness.x, saturate(Custom_Contrast_Intensity));
  r0 = r0 + (-0.5 * Custom_Contrast_Intensity);  // shift around 0.5 before contrast
  r1.w = (0.5 * Custom_Contrast_Intensity);      // 0.5 constant
  float4 unclamped = g_fContrast.x * r0 + r1.w;
  r0 = saturate(g_fContrast.x * r0 + r1.w);      // apply contrast and shift back

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
