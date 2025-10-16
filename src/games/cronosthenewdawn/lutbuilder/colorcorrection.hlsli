#include "../shared.h"

// from Pumbo and Ersh
#if ENABLE_CUSTOM_COLOR_CORRECTION

// Restores the source color hue (and optionally brightness) through Oklab (this works on colors beyond SDR in brightness and gamut too).
// The strength sweet spot for a strong hue restoration seems to be 0.75, while for chrominance, going up to 1 is ok.
float3 RestoreHueAndChrominance(float3 targetColor, float3 sourceColor, float hueStrength = 0.75, float chrominanceStrength = 1.0, float minChrominanceChange = 0.0, float maxChrominanceChange = renodx::math::FLT32_MAX, float lightnessStrength = 0.0, float clampChrominanceLoss = 0.0) {
  if (hueStrength == 0.0 && chrominanceStrength == 0.0 && lightnessStrength == 0.0)  // Static optimization (useful if the param is const)
    return targetColor;

  // Invalid or black colors fail oklab conversions or ab blending so early out
  if (renodx::color::y::from::BT709(targetColor) <= renodx::math::FLT32_MIN)
    return targetColor;  // Optionally we could blend the target towards the source, or towards black, but there's no need until proven otherwise

  const float3 sourceOklab = renodx::color::oklab::from::BT709(sourceColor);
  float3 targetOklab = renodx::color::oklab::from::BT709(targetColor);

  targetOklab.x = lerp(targetOklab.x, sourceOklab.x, lightnessStrength);  // TODOFT5: the alt method was used by Bioshock 2, did it make sense? Should it be here?

  float currentChrominance = length(targetOklab.yz);

  if (hueStrength != 0.0) {
    // First correct both hue and chrominance at the same time (oklab a and b determine both, they are the color xy coordinates basically).
    // As long as we don't restore the hue to a 100% (which should be avoided?), this will always work perfectly even if the source color is pure white (or black, any "hueless" and "chromaless" color).
    // This method also works on white source colors because the center of the oklab ab diagram is a "white hue", thus we'd simply blend towards white (but never flipping beyond it (e.g. from positive to negative coordinates)),
    // and then restore the original chrominance later (white still conserving the original hue direction, so likely spitting out the same color as the original, or one very close to it).
    const float chrominancePre = currentChrominance;
    targetOklab.yz = lerp(targetOklab.yz, sourceOklab.yz, hueStrength);
    const float chrominancePost = length(targetOklab.yz);
    // Then restore chrominance to the original one
    float chrominanceRatio = renodx::math::SafeDivision(chrominancePre, chrominancePost, 1);
    targetOklab.yz *= chrominanceRatio;
    // currentChrominance = chrominancePre; // Redundant
  }

  if (chrominanceStrength != 0.0) {
    const float sourceChrominance = length(sourceOklab.yz);
    // Scale original chroma vector from 1.0 to ratio of target to new chroma
    // Note that this might either reduce or increase the chroma.
    float targetChrominanceRatio = renodx::math::SafeDivision(sourceChrominance, currentChrominance, 1);
    // Optional safe boundaries (0.333x to 2x is a decent range)
    targetChrominanceRatio = clamp(targetChrominanceRatio, minChrominanceChange, maxChrominanceChange);
    float chromaScale = lerp(1.0, targetChrominanceRatio, chrominanceStrength);

    if (clampChrominanceLoss > 0.0) {
      float needsClamp = 1.0f - step(1.0f, chromaScale);  // 1 when chromaScale < 1
      chromaScale = lerp(chromaScale, 1.0f, needsClamp * clampChrominanceLoss);
    }

    targetOklab.yz *= chromaScale;
  }

  return renodx::color::bt709::from::OkLab(targetOklab);
}

// Linear BT.709 in and out. Restore the fog hue and chrominance, to indeed have a look closer to vanilla
float3 FixColorFade(float3 Scene, float3 Fade, float clampChrominanceLoss = 0.0) {
  const float FogCorrectionAverageBrightness = SHADOW_COLOR_OFFSET_BRIGHTNESS_BIAS;  // increase to limit effect to darker parts
  const float FogCorrectionMinBrightness = 0.0;
  const float FogCorrectionHue = 1.0;  // 1 might break and turn brown due to divisions by 0 or something, anyway fog is usually grey in Cronos, even if there's a slight different white point between the working and output color spaces (D60 vs D65)
  const float FogCorrectionChrominance = 1.0;
  const float FogCorrectionIntensity = 1.0;

  float3 sceneWithFog = Scene + Fade;
  float3 prevSceneWithFog = sceneWithFog;

  float fadeMax = max(abs(Fade.x), max(abs(Fade.y), abs(Fade.z)));  // This might have values below zero but it should be ok
  float3 normalizedFade = fadeMax != 0.0 ? (Fade / fadeMax) : Fade;
  float3 fadeOklab = renodx::color::oklab::from::BT709(normalizedFade);

  float3 sceneOklab = renodx::color::oklab::from::BT709(Scene);

  const float fogBrightness = saturate((FogCorrectionAverageBrightness * sceneOklab.x) + FogCorrectionMinBrightness);  // Restore an optional min amount of fog on black and a good amount of fog on non black backgrounds
  const float fogHue = FogCorrectionHue * saturate(length(fadeOklab.yz) / sqrt(2.0));                                  // Restoring the fog hue might look good if the fog was colorful, but if it was just grey, then it'd randomly shift the background hue to an ugly value, so we scale the fog hue restoration by the chrominance of the fade (it seems like it's usually white/grey in Cronos)
  const float fogChrominance = FogCorrectionChrominance;                                                               // Restore the fog chrominance to a 100%, which means we'd either desaturate or saturate the background
  sceneWithFog = RestoreHueAndChrominance(Scene, sceneWithFog, fogHue, fogChrominance, 0.f, renodx::math::FLT32_MAX, fogBrightness, clampChrominanceLoss);

  return lerp(prevSceneWithFog, sceneWithFog, FogCorrectionIntensity);
}

float3 ColorCorrect(float3 WorkingColor,
                    float4 ColorSaturation,
                    float4 ColorContrast,
                    float4 ColorGamma,
                    float4 ColorGain,
                    float4 ColorOffset) {
  float Luma = renodx::color::y::from::AP1(WorkingColor);
  WorkingColor = max(0, lerp(Luma.xxx, WorkingColor, ColorSaturation.xyz * ColorSaturation.w));
  WorkingColor = pow(WorkingColor * (1.0 / 0.18), ColorContrast.xyz * ColorContrast.w) * 0.18;
  WorkingColor = pow(WorkingColor, 1.0 / (ColorGamma.xyz * ColorGamma.w));
  if (SHADOW_COLOR_OFFSET_FIX_TYPE == 1 && COLOR_OFFSET_MIDTONES_HIGHLIGHTS != 0.f) {
    WorkingColor = renodx::color::ap1::from::BT709(FixColorFade(renodx::color::bt709::from::AP1(WorkingColor * (ColorGain.xyz * ColorGain.w)), renodx::color::bt709::from::AP1(ColorOffset.xyz + ColorOffset.w)));  // pumbo haze fix
  } else {
    WorkingColor = WorkingColor * (ColorGain.xyz * ColorGain.w) + (ColorOffset.xyz + ColorOffset.w);  // original code
  }

  return WorkingColor;
}

float3 ColorCorrectShadows(float3 WorkingColor,
                           float4 ColorSaturationTonal,
                           float4 ColorSaturation,
                           float4 ColorContrastTonal,
                           float4 ColorContrast,
                           float4 ColorGammaTonal,
                           float4 ColorGamma,
                           float4 ColorGainTonal,
                           float4 ColorGain,
                           float4 ColorOffsetTonal,
                           float4 ColorOffset) {
  ColorOffset = ColorOffsetTonal + ColorOffset;
  ColorSaturation = ColorSaturationTonal * ColorSaturation;
  ColorContrast = ColorContrastTonal * ColorContrast;
  ColorGamma = ColorGammaTonal * ColorGamma;
  ColorGain = ColorGainTonal * ColorGain;

  float Luma = renodx::color::y::from::AP1(WorkingColor);
  WorkingColor = max(0, lerp(Luma.xxx, WorkingColor, ColorSaturation.xyz * ColorSaturation.w));
  WorkingColor = pow(WorkingColor * (1.0 / 0.18), ColorContrast.xyz * ColorContrast.w) * 0.18;
  WorkingColor = pow(WorkingColor, 1.0 / (ColorGamma.xyz * ColorGamma.w));
  if (SHADOW_COLOR_OFFSET_FIX_TYPE == 1) {
    WorkingColor = renodx::color::ap1::from::BT709(
        FixColorFade(renodx::color::bt709::from::AP1(WorkingColor * (ColorGain.xyz * ColorGain.w)),
                     renodx::color::bt709::from::AP1(ColorOffset.xyz + ColorOffset.w),
                     SHADOW_COLOR_OFFSET_CHROMINANCE_RESTORATION));  // pumbo haze fix
    WorkingColor = max(0, WorkingColor);                             // clamp to AP1
  } else {
    WorkingColor = WorkingColor * (ColorGain.xyz * ColorGain.w) + (ColorOffset.xyz + ColorOffset.w);  // original code
  }

  return WorkingColor;
}

float3 ColorCorrectAll(float3 WorkingColor,
                       float4 ColorSaturation,
                       float4 ColorContrast,
                       float4 ColorGamma,
                       float4 ColorGain,
                       float4 ColorOffset,
                       float4 ColorSaturationShadows,
                       float4 ColorContrastShadows,
                       float4 ColorGammaShadows,
                       float4 ColorGainShadows,
                       float4 ColorOffsetShadows,
                       float4 ColorSaturationHighlights,
                       float4 ColorContrastHighlights,
                       float4 ColorGammaHighlights,
                       float4 ColorGainHighlights,
                       float4 ColorOffsetHighlights,
                       float4 ColorSaturationMidtones,
                       float4 ColorContrastMidtones,
                       float4 ColorGammaMidtones,
                       float4 ColorGainMidtones,
                       float4 ColorOffsetMidtones,
                       float CCWeightShadows,
                       float CCWeightHighlights,
                       float CCWeightMidtones) {
  float3 CCColorShadows = ColorCorrectShadows(WorkingColor,
                                              ColorSaturationShadows, ColorSaturation,
                                              ColorContrastShadows, ColorContrast,
                                              ColorGammaShadows, ColorGamma,
                                              ColorGainShadows, ColorGain,
                                              ColorOffsetShadows, ColorOffset);

  float3 CCColorHighlights = ColorCorrect(WorkingColor,
                                          ColorSaturationHighlights * ColorSaturation,
                                          ColorContrastHighlights * ColorContrast,
                                          ColorGammaHighlights * ColorGamma,
                                          ColorGainHighlights * ColorGain,
                                          ColorOffsetHighlights + ColorOffset);

  float3 CCColorMidtones = ColorCorrect(WorkingColor,
                                        ColorSaturationMidtones * ColorSaturation,
                                        ColorContrastMidtones * ColorContrast,
                                        ColorGammaMidtones * ColorGamma,
                                        ColorGainMidtones * ColorGain,
                                        ColorOffsetMidtones + ColorOffset);

  WorkingColor = CCColorShadows * CCWeightShadows + CCColorMidtones * CCWeightMidtones + CCColorHighlights * CCWeightHighlights;

  return WorkingColor;
}

float3 ApplyColorCorrection(float3 WorkingColor,
                          float4 ColorSaturation,
                          float4 ColorContrast,
                          float4 ColorGamma,
                          float4 ColorGain,
                          float4 ColorOffset,
                          float4 ColorSaturationShadows,
                          float4 ColorContrastShadows,
                          float4 ColorGammaShadows,
                          float4 ColorGainShadows,
                          float4 ColorOffsetShadows,
                          float4 ColorSaturationHighlights,
                          float4 ColorContrastHighlights,
                          float4 ColorGammaHighlights,
                          float4 ColorGainHighlights,
                          float4 ColorOffsetHighlights,
                          float4 ColorSaturationMidtones,
                          float4 ColorContrastMidtones,
                          float4 ColorGammaMidtones,
                          float4 ColorGainMidtones,
                          float4 ColorOffsetMidtones,
                          float ColorCorrectionShadowsMax,
                          float ColorCorrectionHighlightsMin,
                          float ColorCorrectionHighlightsMax) {
  float lum = renodx::color::y::from::AP1(WorkingColor);
  float cc_a = saturate(lum / ColorCorrectionShadowsMax);
  float cc_b = (cc_a * cc_a) * (3.0f - (cc_a * 2.0f));
  float CCWeightShadows = 1.0f - cc_b;
  float cc_c = saturate((lum - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float CCWeightHighlights = (cc_c * cc_c) * (3.0f - (cc_c * 2.0f));
  float CCWeightMidtones = cc_b - CCWeightHighlights;

  WorkingColor = ColorCorrectAll(
      WorkingColor,
      ColorSaturation,
      ColorContrast,
      ColorGamma,
      ColorGain,
      ColorOffset,
      ColorSaturationShadows,
      ColorContrastShadows,
      ColorGammaShadows,
      ColorGainShadows,
      ColorOffsetShadows,
      ColorSaturationHighlights,
      ColorContrastHighlights,
      ColorGammaHighlights,
      ColorGainHighlights,
      ColorOffsetHighlights,
      ColorSaturationMidtones,
      ColorContrastMidtones,
      ColorGammaMidtones,
      ColorGainMidtones,
      ColorOffsetMidtones,
      CCWeightShadows,
      CCWeightHighlights,
      CCWeightMidtones);
      
  return WorkingColor;
}

#endif  // ENABLE_CUSTOM_COLOR_CORRECTION