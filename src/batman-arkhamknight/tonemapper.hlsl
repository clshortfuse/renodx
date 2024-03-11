#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "./shared.h"

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

float3 applyUserToneMap(float3 inputColor, float3 untonemapped) {
  float3 outputColor = saturate(inputColor);

  const float uncharted2Scaler = 1.66289866f;
  if (injectedData.toneMapperEnum == 0) {
    // noop
  } else {
    if (injectedData.toneMapperEnum == 1) {
      outputColor = untonemapped;  // Untonemapped
    } else {
      // OutputColor was intended for 2.2 displays, using 2.2 numbers
      outputColor = pow(outputColor, 2.2f);  // Now in linear
      float inputY = yFromBT709(abs(untonemapped));
      float outputY = yFromBT709(outputColor);
      outputColor *= (outputY ? inputY / outputY : 1);
      if (injectedData.toneMapperEnum == 2) {
        outputColor = aces_rrt_odt(
          outputColor * uncharted2Scaler,
          0.0001f,  // minY
          48.f * (injectedData.gamePeakWhite / injectedData.gamePaperWhite),
          AP1_2_BT2020_MAT
        );
      } else {
        outputColor = mul(BT709_2_BT2020_MAT, outputColor);
        outputColor = open_drt_transform_custom(
          outputColor * uncharted2Scaler,
          100.f * (injectedData.gamePeakWhite / injectedData.gamePaperWhite),
          0
        );
      }
      outputColor = mul(BT2020_2_BT709_MAT, outputColor);
      outputColor *= injectedData.gamePeakWhite / injectedData.uiPaperWhite;
    }
    // Send as 2.2 numbers
    outputColor = sign(outputColor) * pow(abs(outputColor), 1.f / 2.2f);
  }
  return outputColor;
}
