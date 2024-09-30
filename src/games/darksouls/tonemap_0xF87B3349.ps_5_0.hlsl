#include "./DICE.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Sep 28 17:20:55 2024

cbuffer _Globals : register(b0) {
  float4 DL_FREG_007 : packoffset(c7);
  float4 DL_FREG_008 : packoffset(c8);
  float4 DL_FREG_009 : packoffset(c9);
  float4 DL_FREG_010 : packoffset(c10);
  float4 DL_FREG_011 : packoffset(c11);
  float4 DL_FREG_012 : packoffset(c12);
  float4 DL_FREG_013 : packoffset(c13);
  float4 DL_FREG_014 : packoffset(c14);
  float4 DL_FREG_015 : packoffset(c15);
  float4 DL_FREG_016 : packoffset(c16);
  float4 DL_FREG_017 : packoffset(c17);
  float4 DL_FREG_018 : packoffset(c18);
  float4 DL_FREG_019 : packoffset(c19);
  float4 DL_FREG_020 : packoffset(c20);
  float4 DL_FREG_021 : packoffset(c21);
  float4 DL_FREG_022 : packoffset(c22);
  float4 DL_FREG_023 : packoffset(c23);
  float4 DL_FREG_024 : packoffset(c24);
  float4 DL_FREG_025 : packoffset(c25);
  float4 DL_FREG_026 : packoffset(c26);
  float4 DL_FREG_027 : packoffset(c27);
  float4 DL_FREG_028 : packoffset(c28);
  float4 DL_FREG_029 : packoffset(c29);
  float4 DL_FREG_030 : packoffset(c30);
  float4 DL_FREG_031 : packoffset(c31);
  float4 DL_FREG_032 : packoffset(c32);
  float4 DL_FREG_033 : packoffset(c33);
  float4 DL_FREG_034 : packoffset(c34);
  float4 DL_FREG_035 : packoffset(c35);
  float4 DL_FREG_036 : packoffset(c36);
  float4 DL_FREG_037 : packoffset(c37);
  float4 DL_FREG_038 : packoffset(c38);
  float4 DL_FREG_039 : packoffset(c39);
  float4 DL_FREG_040 : packoffset(c40);
  float4 DL_FREG_041 : packoffset(c41);
  float4 DL_FREG_042 : packoffset(c42);
  float4 DL_FREG_043 : packoffset(c43);
  float4 DL_FREG_044 : packoffset(c44);
  float4 DL_FREG_045 : packoffset(c45);
  float4 DL_FREG_046 : packoffset(c46);
  float4 DL_FREG_047 : packoffset(c47);
  float4 DL_FREG_048 : packoffset(c48);
  float4 DL_FREG_049 : packoffset(c49);
  float4 DL_FREG_050 : packoffset(c50);
  float4 DL_FREG_051 : packoffset(c51);
  float4 DL_FREG_052 : packoffset(c52);
  float4 DL_FREG_053 : packoffset(c53);
  float4 DL_FREG_054 : packoffset(c54);
  float4 DL_FREG_055 : packoffset(c55);
  float4 DL_FREG_056 : packoffset(c56);
  float4 DL_FREG_057 : packoffset(c57);
  float4x4 DL_FREG_058 : packoffset(c58);
  float4x4 DL_FREG_062 : packoffset(c62);
  float4 DL_FREG_066 : packoffset(c66);
  float4 DL_FREG_067 : packoffset(c67);
  float4 DL_FREG_068 : packoffset(c68);
  float4 DL_FREG_069 : packoffset(c69);
  float4 DL_FREG_070 : packoffset(c70);
  float4 DL_FREG_071 : packoffset(c71);
  float4 DL_FREG_072 : packoffset(c72);
  float4 DL_FREG_073 : packoffset(c73);
  float4x4 DL_FREG_074 : packoffset(c74);
  float4 DL_FREG_078 : packoffset(c78);
  uint4 gFC_FrameIndex : packoffset(c81);
  float4x4 gVC_WorldViewClipMtx : packoffset(c82);
  float4 gVC_ScreenSize : packoffset(c86);
  float4 gVC_NoiseParam : packoffset(c87);
}

SamplerState gSMP_0Sampler_s : register(s0);
SamplerState gSMP_1Sampler_s : register(s1);
SamplerState gSMP_2Sampler_s : register(s2);
SamplerState gSMP_3Sampler_s : register(s3);
SamplerState gSMP_5Sampler_s : register(s5);
Texture2D<float4> gSMP_0 : register(t0);
Texture2D<float4> gSMP_1 : register(t1);
Texture2D<float4> gSMP_2 : register(t2);
Texture2D<float4> gSMP_3 : register(t3);
Texture2D<float4> gSMP_5 : register(t5);

// 3Dmigoto declarations
#define cmp -

/// Adjusts exposure by sampling a texture.
///
/// @param untonemapped - The HDR color before applying auto-exposure.
/// @return The HDR color with auto-exposure applied.
float3 applyAutoExposure(float3 untonemapped) {
  float4 r0;

  r0.w = gSMP_5.Sample(gSMP_5Sampler_s, float2(0.5, 0.5)).x;
  r0.w = max(DL_FREG_056.z, r0.w);
  r0.w = min(DL_FREG_056.w, r0.w);
  r0.w = 9.99999975e-005 + r0.w;
  r0.w = DL_FREG_054.x / r0.w;

  return untonemapped * r0.w;
}

/// Applies the vanilla tonemapper to the untonemapped HDR color.
/// Also applies `renodx::color::grade::UserColorGrading()` when
/// using DICE to allow sliders to work properly when blending.
///
/// @param untonemapped - The HDR color before applying the vanilla tonemapper.
/// @return The color processed through the vanilla tonemapper.
float3 applyVanillaTM(float3 untonemapped) {
  float4 r0, r1, r2, r3, r4, r5;

  switch ((uint)DL_FREG_057.x) {
    case 0:
      r2.xyz = untonemapped;
      r0.w = DL_FREG_055.z * DL_FREG_055.y;
      r3.xyz = DL_FREG_055.xxx * r2.xyz + r0.www;
      r4.xy = DL_FREG_055.ww * DL_FREG_054.zw;
      r3.xyz = r2.xyz * r3.xyz + r4.xxx;
      r5.xyz = DL_FREG_055.xxx * r2.xyz + DL_FREG_055.yyy;
      r2.xyz = r2.xyz * r5.xyz + r4.yyy;
      r2.xyz = r3.xyz / r2.xyz;
      r1.w = DL_FREG_054.z / DL_FREG_054.w;
      r2.xyz = r2.xyz + -r1.www;
      r0.w = DL_FREG_055.x * DL_FREG_054.y + r0.w;
      r0.w = DL_FREG_054.y * r0.w + r4.x;
      r2.w = DL_FREG_055.x * DL_FREG_054.y + DL_FREG_055.y;
      r2.w = DL_FREG_054.y * r2.w + r4.y;
      r0.w = r0.w / r2.w;
      r0.w = r0.w + -r1.w;
      r1.xyz = r2.xyz / r0.www;
      break;
    case 1:
      r2.xyz = untonemapped;
      r0.w = dot(r2.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
      r0.w = max(9.99999975e-005, r0.w);
      r1.w = 1 + r0.w;
      r1.w = r0.w / r1.w;
      r2.xyz = r1.www * r2.xyz;
      r1.xyz = r2.xyz / r0.www;
      break;
    case 2:
      r0.xyz = untonemapped;
      r0.w = dot(r0.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
      r0.w = max(9.99999975e-005, r0.w);
      r1.w = DL_FREG_054.y * DL_FREG_054.y;
      r1.w = r0.w / r1.w;
      r1.w = 1 + r1.w;
      r1.w = r1.w * r0.w;
      r2.x = 1 + r0.w;
      r1.w = r1.w / r2.x;
      r0.xyz = r1.www * r0.xyz;
      r1.xyz = r0.xyz / r0.www;
      break;
    default:
      r1.xyz = float3(1, 0, 1);
      break;
  }

  float3 outputColor = r1.xyz;

  if (injectedData.toneMapType == 2) {  // apply sliders to SDR and HDR when blending
    outputColor = renodx::color::grade::UserColorGrading(
        outputColor,
        injectedData.colorGradeExposure,  // exposure
        1.f,                              // only take highlights from HDR color when blending
        injectedData.colorGradeShadows,   // shadows
        injectedData.colorGradeContrast,  // contrast
        1.f,                              // apply saturation adjustment at end
        0.f);                             // apply dechroma adjustment at end
  }

  return outputColor;
}

/// Samples a texture to apply a color filter to the input color.
/// Adjusts the strength based on `injectedData.colorGradeLUTStrength`.
///
/// @param colorGradeInput - The input color before applying the color filter.
/// @param v1 - Texture coordinates used for sampling the color grading texture.
/// @return The color with the filter applied.
float3 applyColorFilter(float3 colorGradeInput, float4 v1) {
  if (injectedData.colorGradeLUTStrength == 0) {
    return colorGradeInput;
  }

  float4 r0;
  float3 r1, r2, r3, r4;

  r0.xyz = colorGradeInput;
  r0.w = 1;

  r1.x = dot(r0.xyzw, DL_FREG_062._m00_m10_m20_m30);
  r1.y = dot(r0.xyzw, DL_FREG_062._m01_m11_m21_m31);
  r1.z = dot(r0.xyzw, DL_FREG_062._m02_m12_m22_m32);
  r0.xyz = gSMP_2.Sample(gSMP_2Sampler_s, v1.zw).xyz;
  r2.xyz = r1.xyz * r0.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r3.xyz = float3(1, 1, 1) + -r0.xyz;
  r3.xyz = r3.xyz + r3.xyz;
  r4.xyz = float3(1, 1, 1) + -r1.xyz;
  r3.xyz = -r3.xyz * r4.xyz + float3(1, 1, 1);
  r0.xyz = cmp(float3(0.5, 0.5, 0.5) >= r0.xyz);
  r4.xyz = r0.xyz ? float3(1, 1, 1) : 0;
  r0.xyz = r0.xyz ? float3(0, 0, 0) : float3(1, 1, 1);
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r3.xyz * r4.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = DL_FREG_068.xxx * r0.xyz + r1.xyz;

  return lerp(colorGradeInput, r0.xyz, injectedData.colorGradeLUTStrength);
}

/// Applies `renodx::color::grade::UserColorGrading()` with custom settings based
/// on whether `injectedData.toneMapType` is set to "None" or "DICE".
///
/// @param untonemapped - The HDR color before grading.
/// @param vanillaTM - The vanilla tonemapped color to be blended.
/// @return The HDR color after grading adjustments.
float3 applyConditionalHDRColorGrade(float3 untonemapped, float3 vanillaTM) {
  // calculate midgray for vanilla tonemapper to line up tonemappers
  float vanillaMidGray = renodx::color::y::from::BT709(applyVanillaTM(float3(0.18, 0.18, 0.18)));

  float DICEHighlights = 1.f;
  float DICEContrast = 1.f;
  float DICESaturation = 1.f;
  float DICEBlowout = 0.f;

  // apply custom deafults when using DICE
  // only tonemap 1 from the switch case needs custom grading, others are neutral
  if (injectedData.toneMapType == 2 && (uint)DL_FREG_057.x == 0u) {
    DICEContrast = 1.16f;
    DICESaturation = 1.18f;
    DICEHighlights = 0.9f;
    DICEBlowout = 0.5f;
  }
  float3 hdrColor = renodx::color::grade::UserColorGrading(
      untonemapped,
      injectedData.colorGradeExposure,                     // exposure
      injectedData.colorGradeHighlights * DICEHighlights,  // highlights
      injectedData.colorGradeShadows,                      // shadows
      injectedData.colorGradeContrast * DICEContrast,      // contrast
      DICESaturation,                                      // saturation
      DICEBlowout,                                         // dechroma
      injectedData.toneMapHueCorrection,                   // hue correction
      vanillaTM);
  hdrColor *= vanillaMidGray / 0.18f;  // match vanilla midgray

  return hdrColor;
}

/// Applies DICE tonemapper to the untonemapped HDR color.
///
/// @param untonemapped - The untonemapped color.
/// @return The HDR color tonemapped with DICE.
float3 applyDICE(float3 untonemapped) {
  // Declare DICE parameters
  DICESettings config = DefaultDICESettings();
  config.Type = 3;
  config.ShoulderStart = 0.5f;
  const float dicePaperWhite = injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;
  const float dicePeakWhite = injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE;

  // multiply paper white in for tonemapping and out for output
  return DICETonemap(untonemapped * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
}

/// Blends HDR and SDR tonemapped colors after color grading and filtering.
/// Blends HDR color, processed with UserColorGrading and the game's color filter, with the SDR tonemapped color.
///
/// @param hdrUntonemapped - The untonemapped HDR color after `applyConditionalHDRColorGrade()` and `applyColorFilter()`.
/// @param sdrTonemapped - The vanilla color after `applyConditionalHDRColorGrade()` and `applyColorFilter()`.
/// @return The blended color in gamma space.
float3 blendTonemaps(float3 hdrUntonemapped, float3 sdrTonemapped) {
  hdrUntonemapped = renodx::math::SafePow(hdrUntonemapped, 2.2f);  // linearize HDR
  float3 hdrTonemapped = applyDICE(hdrUntonemapped);               // tonemap HDR

  sdrTonemapped = renodx::math::SafePow(sdrTonemapped, 2.2f);  // linearize SDR
  float3 negHDR = min(0, hdrTonemapped);                       // save WCG
  float3 blendedColor = lerp(saturate(sdrTonemapped), max(0, hdrTonemapped), saturate(sdrTonemapped));
  blendedColor += negHDR;  // add back WCG

  return renodx::math::SafePow(blendedColor, 1.f / 2.2f);  // back to gamma space
}

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  float3 outputColor;

  r0.xyz = gSMP_0.Sample(gSMP_0Sampler_s, v1.xy).xyz;
  r0.xyz = max(float3(9.99999997e-007, 9.99999997e-007, 9.99999997e-007), r0.xyz);
  r1.xyzw = gSMP_1.Sample(gSMP_1Sampler_s, v1.xy).wxyz;
  r1.yzw = max(float3(9.99999997e-007, 9.99999997e-007, 9.99999997e-007), r1.yzw);
  r1.x = saturate(r1.x);
  r2.xyz = gSMP_3.Sample(gSMP_3Sampler_s, v1.xy).xyz;
  r0.w = DL_FREG_071.y + -DL_FREG_056.x;
  r0.w = r1.x * r0.w + DL_FREG_056.x;
  r0.xyz = r0.www * r1.yzw + r0.xyz;
  r0.xyz = DL_FREG_056.yyy * r2.xyz + r0.xyz;
  r0.xyz = applyAutoExposure(r0.xyz);

  const float3 untonemapped = r0.xyz;

  r1.xyz = applyVanillaTM(r0.xyz);
  const float3 vanillaTM = r1.xyz;  // vanilla tonemapped color, used for hue correction
  r0.xyz = renodx::math::SafePow(r1.xyz, 1.f / 2.2f);
  r0.xyz = applyColorFilter(r0.xyz, v1);
  const float3 sdrColor = r0.xyz;  // final vanilla color

  // DICE and None
  if (injectedData.toneMapType != 0) {
    float3 hdrColor = applyConditionalHDRColorGrade(untonemapped, vanillaTM);
    hdrColor = renodx::math::SafePow(hdrColor, 1.f / 2.2f);
    hdrColor = applyColorFilter(hdrColor, v1);

    if (injectedData.toneMapType == 2) {  // DICE + Blend
      outputColor = blendTonemaps(hdrColor, sdrColor);
    } else {  // None
      outputColor = hdrColor;
    }
  } else {  // clamp vanilla tonemap to peak nits
    outputColor = min(max(0, sdrColor), max(injectedData.toneMapPeakNits / injectedData.toneMapGameNits, 1.f));
  }

  o0.w = dot(max(0, outputColor), float3(0.298999995, 0.587000012, 0.114));
  o0.xyz = outputColor;

  o0.xyz = renodx::math::SafePow(o0.xyz, 2.2f);                         // linearize
  o0.xyz *= injectedData.toneMapGameNits / injectedData.toneMapUINits;  // scale paper white
  // apply saturation and dechroma at the end
  if (injectedData.toneMapType != 0) {
    o0.xyz = renodx::color::grade::UserColorGrading(
        o0.xyz,
        1.f,                                // exposure
        1.f,                                // highlights
        1.f,                                // shadows
        1.f,                                // contrast
        injectedData.colorGradeSaturation,  // saturation
        injectedData.colorGradeBlowout);    // dechroma
  }
  o0.xyz = renodx::color::bt709::clamp::AP1(o0.xyz);   // clamp to AP1
  o0.xyz = renodx::math::SafePow(o0.xyz, 1.f / 2.2f);  // back to gamma
  return;
}
