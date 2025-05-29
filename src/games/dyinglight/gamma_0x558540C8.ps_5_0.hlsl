#include "./DICE.hlsl"
#include "./extendGamut.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:10 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

// Applies the hue shifts from clamping input_color while minimizing broken gradients
float3 Hue(float3 input_color, float correct_amount = 1.f) {
  // If no correction is needed, return the original color
  if (correct_amount == 0) {
    return input_color;
  } else {
    // Calculate average channel values of the original (unclamped) input_color
    float avg_unclamped = renodx::math::Average(input_color);

    // calculate average channel values for the clamped input_color
    float3 clamped_color = saturate(input_color);
    float avg_clamped = renodx::math::Average(clamped_color);

    // Compute the hue clipping percentage based on the difference in averages
    float hue_clip_percentage = saturate((avg_unclamped - avg_clamped) / max(avg_unclamped, renodx::math::FLT_MIN));  // Prevent division by zero

    // Interpolate hue components (a, b in OkLab) based on correct_amount using clamped_color
    float3 correct_lab = renodx::color::oklab::from::BT709(clamped_color);
    float3 incorrect_lab = renodx::color::oklab::from::BT709(input_color);
    float3 new_lab = incorrect_lab;

    // Apply hue correction based on clipping percentage and interpolate based on correct_amount
    new_lab.yz = lerp(incorrect_lab.yz, correct_lab.yz, hue_clip_percentage);
    new_lab.yz = lerp(incorrect_lab.yz, new_lab.yz, abs(correct_amount));

    // Restore original chrominance from input_color in OkLCh space
    float3 incorrect_lch = renodx::color::oklch::from::OkLab(incorrect_lab);
    float3 new_lch = renodx::color::oklch::from::OkLab(new_lab);
    new_lch[1] = incorrect_lch[1];

    // Convert back to linear BT.709 space
    float3 color = renodx::color::bt709::from::OkLCh(new_lch);
    return color;
  }
}

/// Applies DICE tonemapper to the untonemapped HDR color.
///
/// @param untonemapped - The untonemapped color.
/// @return The HDR color tonemapped with DICE.
float3 applyDICE(float3 untonemapped) {
  // Declare DICE parameters
  DICESettings config = DefaultDICESettings();
  config.Type = 2u;
  config.ShoulderStart = 0.5f;
  config.DesaturationAmount = 0.f;
  config.DarkeningAmount = 0.f;

  const float dicePaperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  const float dicePeakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;

  // multiply paper white in for tonemapping and out for output
  return DICETonemap(untonemapped * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  o0.xyzw = r0.xyzw;

  // o0.xyz = sign(o0.xyz) * pow(abs(o0.xyz), cb0[0].xxx);  // disable in game gamma slider

  if (RENODX_GAMMA_CORRECTION) {  // 2.2 Gamma
    o0.xyz = renodx::color::correct::GammaSafe(o0.xyz);

    if (RENODX_TONE_MAP_TYPE == 0) {  // vanilla tonemap flickers if left unclamped
      o0.xyz = saturate(o0.xyz);
    } else if (RENODX_TONE_MAP_TYPE == 2) {  // tonemap after gamma correction for correct highlights
      o0.rgb = Hue(o0.rgb, RENODX_TONE_MAP_HUE_CORRECTION);
      o0.rgb = extendGamut(o0.rgb, RENODX_COLOR_GRADE_GAMUT_EXPANSION);
      o0.rgb = applyDICE(o0.rgb);
    }

    o0.xyz *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    o0.xyz = renodx::color::correct::GammaSafe(o0.xyz, true);

  } else {                                // sRGB Gamma
    if (RENODX_TONE_MAP_TYPE == 0) {  // vanilla tonemap flickers if left unclamped
      o0.xyz = saturate(o0.xyz);
    } else if (RENODX_TONE_MAP_TYPE == 2) {
      o0.rgb = Hue(o0.rgb, RENODX_TONE_MAP_HUE_CORRECTION);
      o0.rgb = extendGamut(o0.rgb, RENODX_COLOR_GRADE_GAMUT_EXPANSION);
      o0.rgb = applyDICE(o0.rgb);
    }

    o0.xyz *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  }
  o0.w = saturate(o0.w);
  return;
}
