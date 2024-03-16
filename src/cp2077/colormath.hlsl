#include "../common/color.hlsl"
#include "../common/random.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

struct ConvertColorParams {
  uint outputTypeEnum;      // _20_m0[0u].x
  float paperWhiteScaling;  // _20_m0[0u].y
  float blackFloorAdjust;   // _20_m0[0u].z  // 1.25 always?
  float gammaCorrection;    // _20_m0[0u].w
  float pqSaturation;       // _20_m0[1u].x
  float3x3 colorMatrix;     // _20_m0[2u].xyzw _20_m0[3u].xyzw _20_m0[4u].xyzw
  float3 random3;
};

float3 randomDither(float3 color, float3 random3, float bits = 8.f) {
  float3 randomA = hash33(float3(
    random3.x * 64.f * 64.f,
    random3.y * 64.f * 64.f,
    random3.z * 64.f
  ));

  float3 randomB = hash33(float3(
    (random3.x + 64.f) * 64.f * 64.f,
    (random3.y + 64.f) * 64.f * 64.f,
    random3.z * 64.f
  ));

  float maxValue = pow(2.f, bits) - 1.f;
  float maxValueX2 = maxValue * 2.f;
  // return color + (((a - 0.5f) + (min(min(1.0f, color * maxValueX2), maxValueX2 - (color * maxValueX2)) * (b - 0.5f))) / maxValue);

  float3 newValue = min(min(1.0f, color * maxValueX2), maxValueX2 - (color * maxValueX2));
  newValue *= (randomB - 0.5f);
  newValue += (randomA - 0.5f);
  newValue /= maxValue;
  return color + newValue;
}

float3 gammaCorrectionHDRSafe(float3 inputColor) {
  float3 inputColorSign = sign(inputColor);
  inputColor = abs(inputColor);
  inputColor = srgbFromLinear(inputColor);  // encode as srgb (as originally outputted)
  inputColor = pow(inputColor, 2.2f);       // decode as 2.2 (as most monitors)
  inputColor *= inputColorSign;
  return inputColor;
}

float3 applyUserBrightness(float3 inputColor, float userBrightness = 1.f) {
  return (userBrightness != 1.f)
         ? pow(inputColor, userBrightness)
         : inputColor;
}

float3 convertColor(float3 inputColor, ConvertColorParams params) {
  float3 outputColor = inputColor;
  switch (params.outputTypeEnum) {
    case OUTPUT_TYPE_SRGB8:
      {
        outputColor = max(0, outputColor);  // clamp to BT709
        outputColor = applyUserBrightness(outputColor, params.gammaCorrection);
        if (injectedData.toneMapGammaCorrection == 2.f) {
          outputColor = pow(outputColor, 1.f / 2.2f);
        } else {
          outputColor = srgbFromLinear(outputColor);
        }
        outputColor = randomDither(outputColor.rgb, params.random3, 8.f);
      }
      break;
    case OUTPUT_TYPE_PQ:
      {
        if (injectedData.toneMapGammaCorrection == 2.f) {
          outputColor = gammaCorrectionHDRSafe(outputColor);
        }
        float3 rec2020 = bt2020FromBT709(outputColor.rgb);
        // Removed because this caps to 100 nits
        // Also because the matrix just seems to hue shift to green/yellow
        // float3 matrixedColor = mul(rec2020, params.colorMatrix);
        // matrixedColor = saturate(matrixedColor);
        // float3 newShiftedColor = lerp(rec2020, matrixedColor, params.pqSaturation);

        float3 grayscale = yFromBT2020(rec2020);
        float3 newShiftedColor = lerp(grayscale, rec2020, 1.f + (params.pqSaturation * 0.25f));
        float3 scaledShifted = newShiftedColor * params.paperWhiteScaling;
        float3 pqColor = pqFromLinear(scaledShifted);
        outputColor = pqColor;
      }
      break;
    case OUTPUT_TYPE_SCRGB:
      if (injectedData.toneMapGammaCorrection == 2.f) {
        outputColor = gammaCorrectionHDRSafe(outputColor);
      }
      outputColor *= params.paperWhiteScaling;
      break;
    case OUTPUT_TYPE_SRGB10:
      // Unknown usage
      {
        float3 correctedColor = applyUserBrightness(inputColor.rgb, params.gammaCorrection);
        float3 matrixedColor = mul(correctedColor, params.colorMatrix);
        float3 scaledColor = matrixedColor * params.paperWhiteScaling;
        float3 srgbColor = srgbFromLinear(scaledColor);
        float3 postProcessedSRGB = randomDither(srgbColor.rgb, params.random3, 10.f);
        outputColor.rgb = postProcessedSRGB.rgb;
      }
      break;
    default:
      // Unknown default case
      if (injectedData.toneMapGammaCorrection == 2.f) {
        outputColor = gammaCorrectionHDRSafe(outputColor);
      }
      outputColor *= params.paperWhiteScaling;
      outputColor += params.blackFloorAdjust;
  }
  return outputColor.rgb;
}
