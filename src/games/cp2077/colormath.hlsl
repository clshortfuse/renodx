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
  float3 randomA = renodx::random::Hash33(float3(
      random3.x * 64.f * 64.f,
      random3.y * 64.f * 64.f,
      random3.z * 64.f));

  float3 randomB = renodx::random::Hash33(float3(
      (random3.x + 64.f) * 64.f * 64.f,
      (random3.y + 64.f) * 64.f * 64.f,
      random3.z * 64.f));

  float maxValue = pow(2.f, bits) - 1.f;
  float maxValueX2 = maxValue * 2.f;
  // return color + (((a - 0.5f) + (min(min(1.0f, color * maxValueX2), maxValueX2 - (color * maxValueX2)) * (b - 0.5f))) / maxValue);

  float3 newValue = min(min(1.0f, color * maxValueX2), maxValueX2 - (color * maxValueX2));
  newValue *= (randomB - 0.5f);
  newValue += (randomA - 0.5f);
  newValue /= maxValue;
  return color + newValue;
}

float3 applyUserBrightness(float3 inputColor, float userBrightness = 1.f) {
  return (userBrightness != 1.f)
             ? pow(inputColor, userBrightness)
             : inputColor;
}

float3 convertColor(float3 inputColor, ConvertColorParams params) {
  float3 outputColor = inputColor;
  if (injectedData.toneMapGammaCorrection == 2.f) {
    outputColor = renodx::color::correct::GammaSafe(outputColor);
  }
  switch (params.outputTypeEnum) {
    case OUTPUT_TYPE_SRGB8: {
      outputColor = max(0, outputColor);  // clamp to BT709
      outputColor = applyUserBrightness(outputColor, params.gammaCorrection);
      outputColor = renodx::color::srgb::from::BT709(outputColor);
      outputColor = randomDither(outputColor.rgb, params.random3, 8.f);
      break;
    }
    case OUTPUT_TYPE_PQ: {
      float3 rec2020 = renodx::color::bt2020::from::BT709(outputColor.rgb);
      // Removed because this caps to 100 nits
      // Also because the matrix just seems to hue shift to green/yellow
      // float3 matrixedColor = mul(rec2020, params.colorMatrix);
      // matrixedColor = saturate(matrixedColor);
      // float3 newShiftedColor = lerp(rec2020, matrixedColor, params.pqSaturation);

      float3 grayscale = renodx::color::y::from::BT2020(rec2020);
      float3 newShiftedColor = lerp(grayscale, rec2020, 1.f + (params.pqSaturation * 0.25f));
      float3 scaledShifted = newShiftedColor * params.paperWhiteScaling;
      float3 pqColor = renodx::color::pq::from::BT2020(scaledShifted);
      outputColor = pqColor;
      break;
    }
    case OUTPUT_TYPE_SCRGB:
      outputColor *= params.paperWhiteScaling;
      break;
    case OUTPUT_TYPE_SRGB10:
      // Unknown usage
      {
        outputColor = max(0, outputColor);  // clamp to BT709
        outputColor = applyUserBrightness(outputColor, params.gammaCorrection);
        outputColor = mul(outputColor, params.colorMatrix);
        outputColor *= params.paperWhiteScaling;
        outputColor = renodx::color::srgb::from::BT709(outputColor);
        outputColor = randomDither(outputColor, params.random3, 10.f);
      }
      break;
    default:
      // Unknown default case
      outputColor *= params.paperWhiteScaling;
      outputColor += params.blackFloorAdjust;
  }
  return outputColor.rgb;
}
