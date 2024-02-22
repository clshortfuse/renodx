#include "../common/color.hlsl"
#include "../common/random.hlsl"
#include "./cp2077.h"

struct ConvertColorParams {
  uint outputTypeEnum;      // _20_m0[0u].x
  float paperWhiteScaling;  // _20_m0[0u].y
  float blackFloorAdjust;   // _20_m0[0u].z  // 1.25 always?
  float gammaCorrection;    // _20_m0[0u].w
  float pqSaturation;       // _20_m0[1u].x
  float3x3 colorMatrix;     // _20_m0[2u].xyzw _20_m0[3u].xyzw _20_m0[4u].xyzw
  float3 random3;
};

float3 srgbPostProcess(float3 srgb, float3 random3, float bits = 8.f) {
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
  // return srgb + (((a - 0.5f) + (min(min(1.0f, srgb * maxValueX2), maxValueX2 - (srgb * maxValueX2)) * (b - 0.5f))) / maxValue);

  float3 newValue = min(min(1.0f, srgb * maxValueX2), maxValueX2 - (srgb * maxValueX2));
  newValue *= (randomB - 0.5f);
  newValue += (randomA - 0.5f);
  newValue /= maxValue;
  return srgb + newValue;
}

float3 applyGammaCorrection(float3 inputColor, float gammaCorrection) {
  return (gammaCorrection != 1.0f)
         ? pow(inputColor, gammaCorrection)
         : inputColor;
}

float3 convertColor(float3 inputColor, ConvertColorParams params) {
  float3 outputColor;
  switch (params.outputTypeEnum) {
    case OUTPUT_TYPE_SRGB8:
      {
        float3 correctedColor = applyGammaCorrection(inputColor.rgb, params.gammaCorrection);
        float3 srgbColor = srgbFromLinear(correctedColor);
        float3 postProcessedSRGB = srgbPostProcess(srgbColor.rgb, params.random3, 8.f);
        outputColor.rgb = postProcessedSRGB.rgb;
      }
      break;
    case OUTPUT_TYPE_PQ:
      {
        float3 rec2020 = bt2020FromBT709(inputColor.rgb);
        // Removed because this caps to 100 nits
        // Also because the matrix just seems to hue shift to green/yellow
        // float3 matrixedColor = mul(rec2020, params.colorMatrix);
        // matrixedColor = saturate(matrixedColor);
        // float3 newShiftedColor = lerp(rec2020, matrixedColor, params.pqSaturation);

        float3 grayscale = yFromBT2020(rec2020);
        float3 newShiftedColor = lerp(grayscale, rec2020, 1.f + (params.pqSaturation * 0.25f));
        float3 scaledShifted = newShiftedColor * params.paperWhiteScaling;
        float3 pqColor = pqFromLinear(scaledShifted);
        outputColor.rgb = pqColor.rgb;
      }
      break;
    case OUTPUT_TYPE_SCRGB:
      outputColor.rgb = inputColor.rgb * params.paperWhiteScaling;
      break;
    case OUTPUT_TYPE_SRGB10:
      {
        float3 correctedColor = applyGammaCorrection(inputColor.rgb, params.gammaCorrection);
        float3 matrixedColor = mul(correctedColor, params.colorMatrix);
        float3 scaledColor = matrixedColor * params.paperWhiteScaling;
        float3 srgbColor = srgbFromLinear(scaledColor);
        float3 postProcessedSRGB = srgbPostProcess(srgbColor.rgb, params.random3, 10.f);
        outputColor.rgb = postProcessedSRGB.rgb;
      }
      break;
    default:
      // Unknown default case
      outputColor.rgb = (inputColor.rgb * params.paperWhiteScaling) + params.blackFloorAdjust;
  }
  return outputColor.rgb;
}
