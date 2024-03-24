#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
#include "../common/tonemap.hlsl"
#include "./shared.h"

float3 applyUserToneMap(float3 inputColor, float3 untonemapped) {
  float3 outputColor = saturate(inputColor);

  float vanillaMidGray = uncharted2Tonemap(0.18f) / uncharted2Tonemap(2.2f);
  if (injectedData.toneMapType == 0) {
    outputColor = max(0, outputColor);     // should only have bt709 colors
    outputColor = pow(outputColor, 2.2f);  // Now in linear
    // noop
  } else {
    if (injectedData.toneMapType == 1.f) {
      outputColor = untonemapped;  // Untonemapped
    } else {
      // OutputColor was intended for 2.2 displays, using 2.2 numbers
      outputColor = max(0, outputColor);     // should only have bt709 colors
      outputColor = pow(outputColor, 2.2f);  // Now in linear
      outputColor *= 0.18f / vanillaMidGray; // rescale to match midgray

      float inputY = yFromBT709(abs(untonemapped));
      float outputY = yFromBT709(outputColor);
      outputY = lerp(inputY, outputY, saturate(inputY));
      outputColor *= (outputY ? inputY / outputY : 1);

      if (injectedData.colorGradeShadows != 1.f) {
        outputColor = apply_user_shadows(outputColor, injectedData.colorGradeShadows);
      }
      if (injectedData.colorGradeHighlights != 1.f) {
        outputColor = apply_user_highlights(outputColor, injectedData.colorGradeHighlights);
      }
      if (injectedData.colorGradeContrast != 1.f) {
        float3 workingColor = pow(outputColor / 0.18f, injectedData.colorGradeContrast) * 0.18f;
        // Working in BT709 still
        float workingColorY = yFromBT709(workingColor);
        float outputColorY = yFromBT709(outputColor);
        outputColor *= outputColorY ? workingColorY / outputColorY : 1.f;
      }

      if (injectedData.colorGradeSaturation != 1.f) {
        float grayscale = yFromBT709(outputColor);
        outputColor = lerp(grayscale, outputColor, injectedData.colorGradeSaturation);
        outputColor = max(0, outputColor);
      }
      
      if (injectedData.toneMapType == 2) {
        float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / 0.10); // ACES mid gray is 10%
        float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
        outputColor = aces_rgc_rrt_odt(
          outputColor,
          0.0001f / hdrScale,  // minY
          48.f * hdrScale
        );
        outputColor /= 48.f;
        outputColor *= (vanillaMidGray / 0.10);
      } else {
        // outputColor = apply_aces_highlights(outputColor);
        outputColor = mul(BT709_2_BT2020_MAT, outputColor);
        outputColor = max(0, outputColor);
        const float openDRTMidGray = 11.696f / 100.f; // open_drt_transform(0.18);
        float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / openDRTMidGray);
        float hdrScale = (injectedData.toneMapPeakNits / paperWhite);

        outputColor = open_drt_transform(
          outputColor,
          100.f * hdrScale,
          0,
          1.f,
          0
        );
        outputColor *= hdrScale;
        outputColor *= (vanillaMidGray / openDRTMidGray);
        outputColor = mul(BT2020_2_BT709_MAT, outputColor);
      }
    }
    // Send as 2.2 numbers
  }
  outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  outputColor = sign(outputColor) * pow(abs(outputColor), 1.f / 2.2f);
  return outputColor;
}
