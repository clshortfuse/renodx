#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
#include "./shared.h"

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

float3 applyUserToneMap(float3 inputColor, float3 untonemapped) {
  float3 outputColor = saturate(inputColor);

  const float uncharted2Scaler = 1.66289866f;

  if (injectedData.toneMapType == 0) {
    // noop
  } else {
    if (injectedData.toneMapType == 1.f) {
      outputColor = untonemapped;  // Untonemapped
      outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    } else {
      // OutputColor was intended for 2.2 displays, using 2.2 numbers
      outputColor = pow(outputColor, 2.2f);  // Now in linear

      float inputY = yFromBT709(abs(untonemapped));
      float outputY = yFromBT709(outputColor);
      outputY = lerp(inputY, outputY, saturate(inputY));
      outputColor *= (outputY ? inputY / outputY : 1);

      if (injectedData.colorGradeSaturation != 1.f) {
        float grayscale = yFromBT709(outputColor);
        outputColor = lerp(grayscale, outputColor, injectedData.colorGradeSaturation);
        outputColor = max(0, outputColor);
      }

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

      if (injectedData.toneMapType == 2) {
        outputColor = aces_rrt_odt(
          outputColor * uncharted2Scaler,
          0.0001f,  // minY
          48.f * (injectedData.toneMapPeakNits / injectedData.toneMapGameNits),
          AP1_2_BT2020_MAT
        );
      } else {
        outputColor = max(0, outputColor);
        outputColor = apply_aces_highlights(outputColor);
        outputColor = mul(BT709_2_BT2020_MAT, outputColor);
        outputColor = open_drt_transform(
          outputColor * uncharted2Scaler,
          100.f * (injectedData.toneMapPeakNits / injectedData.toneMapGameNits),
          0,
          1.f,
          0
        );
      }
      outputColor = mul(BT2020_2_BT709_MAT, outputColor);
      outputColor *= injectedData.toneMapPeakNits / injectedData.toneMapUINits;
    }
    // Send as 2.2 numbers
    outputColor = sign(outputColor) * pow(abs(outputColor), 1.f / 2.2f);
  }
  return outputColor;
}
