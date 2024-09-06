#include "./shared.h"
#include "./DICE.hlsl"

// Restores the source color hue through Oklab (this works on colors beyond SDR in brightness and gamut too)
float3 RestoreHue(float3 targetColor, float3 sourceColor, float amount = 0.5)
{
  const float3 targetOklab = renodx::color::oklab::from::BT709(targetColor);
  const float3 targetOklch = renodx::color::oklch::from::OkLab(targetOklab);
  const float3 sourceOklab = renodx::color::oklab::from::BT709(sourceColor);

  // First correct both hue and chrominance at the same time (oklab a and b determine both, they are the color xy coordinates basically).
  // As long as we don't restore the hue to a 100% (which should be avoided), this will always work perfectly even if the source color is pure white (or black, any "hueless" and "chromaless" color).
  // This method also works on white source colors because the center of the oklab ab diagram is a "white hue", thus we'd simply blend towards white (but never flipping beyond it (e.g. from positive to negative coordinates)),
  // and then restore the original chrominance later (white still conserving the original hue direction).
  float3 correctedTargetOklab = float3(targetOklab.x, lerp(targetOklab.yz, sourceOklab.yz, amount));

  // Then restore chrominance
  float3 correctedTargetOklch = renodx::color::oklch::from::OkLab(correctedTargetOklab);
  correctedTargetOklch.y = targetOklch.y;

  return renodx::color::bt709::from::OkLCh(correctedTargetOklch);
}

// from Musa
float3 extendGamut(float3 color, float extendGamutAmount)
{
  float3 colorOKLab = renodx::color::oklab::from::BT709(color);

  // Extract L, C, h from OKLab
  float L = colorOKLab[0];
  float a = colorOKLab[1];
  float b = colorOKLab[2];
  float C = sqrt(a * a + b * b);
  float h = atan2(b, a);

  // Calculate the exponential weighting factor based on luminance and chroma
  float chromaWeight = 1.0f - exp(-4.0f * C);
  float luminanceWeight = 1.0f - exp(-4.0f * L * L);
  float weight = chromaWeight * luminanceWeight * extendGamutAmount;

  // Apply the expansion factor
  C *= (1.0f + weight);

  // Convert back to OKLab with adjusted chroma
  a = C * cos(h);
  b = C * sin(h);
  float3 adjustedOKLab = float3(L, a, b);

  float3 adjustedColor = renodx::color::bt709::from::OkLab(adjustedOKLab);
  float3 colorAP1 = renodx::color::ap1::from::BT709(adjustedColor);
  colorAP1 = max(0, colorAP1); // Clamp to AP1
  return renodx::color::bt709::from::AP1(colorAP1);
}

void OnCopy(inout float3 color)
{
  if (injectedData.copyTracker == 1) {
    // linearize
    color = renodx::math::SafePow(color, 2.2f);

    if (injectedData.toneMapType > 0) {
      float3 sdrColor = saturate(color);
      
      if (injectedData.toneMapType > 1) {
        // color grading
        color = renodx::color::grade::UserColorGrading(color, injectedData.colorGradeExposure, injectedData.colorGradeHighlights, injectedData.colorGradeShadows, injectedData.colorGradeContrast, injectedData.colorGradeSaturation, injectedData.colorGradeBlowout, 0.f);
      
        // tonemap
        DICESettings config = DefaultDICESettings();
        config.Type = 3;
        config.ShoulderStart = injectedData.diceShoulderStart;
      
        float dicePaperWhite = injectedData.toneMapGameNits / 80.f;
        float dicePeakWhite = injectedData.toneMapPeakNits / 80.f;
        color.rgb = DICETonemap(color.rgb * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
      
        color = RestoreHue(color, sdrColor, injectedData.hueCorrectionStrength);
      
        color = extendGamut(color, injectedData.gamutExpansion);
      }
    }

    // apply game paperwhite brightness with inverse UI brightness (ui brightness is re-applied in the final shader)
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;

    // back to gamma space
    color = renodx::math::SafePow(color, 1.f / 2.2f);
  }
}