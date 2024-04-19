#ifndef SRC_COMMON_COLORGRADE_HLSL_
#define SRC_COMMON_COLORGRADE_HLSL_

#include "./color.hlsl"

float3 applyContrastSafe(float3 color, float contrast, float midGray = 0.18f, float3x3 colorspace = BT709_2_XYZ_MAT) {
  float3 workingColor = pow(abs(color) / midGray, contrast) * sign(color) * midGray;
  float workingLuminance = dot(abs(workingColor), float3(colorspace[1].r, colorspace[1].g, colorspace[1].b));
  float colorLuminance = dot(abs(color), float3(colorspace[1].r, colorspace[1].g, colorspace[1].b));
  return color * (colorLuminance ? (workingLuminance / colorLuminance) : 1.f);
}

float3 applySaturation(float3 bt709, float saturation = 1.f) {
  float3 okLCh = okLChFromBT709(bt709);
  okLCh[1] *= saturation;
  float3 color = bt709FromOKLCh(okLCh);
  color = mul(BT709_2_AP1_MAT, color);  // Convert to AP1
  color = max(0, color);                // Clamp to AP1
  color = mul(AP1_2_BT709_MAT, color);  // Convert BT709
  return color;
}

float3 applyUserColorGrading(
  float3 color,
  float userExposure = 1.f,
  float userHighlights = 1.f,
  float userShadows = 1.f,
  float userContrast = 1.f,
  float userSaturation = 1.f
) {
  if (userExposure == 1.f && userSaturation == 1.f && userShadows == 1.f && userHighlights == 1.f && userContrast == 1.f) {
    return color;
  }

  // Store original color
  float3 originalLCh = okLChFromBT709(color);

  color *= userExposure;

  float lum = yFromBT709(abs(color));
  float normalizedLum = lum / 0.18f;

  float contrastedLum = pow(normalizedLum, userContrast);

  float highlightedLum = pow(contrastedLum, userHighlights);
  highlightedLum = lerp(contrastedLum, highlightedLum, saturate(contrastedLum));

  float shadowedLum = pow(highlightedLum, -1.f * (userShadows - 2.f));
  shadowedLum = lerp(shadowedLum, highlightedLum, saturate(highlightedLum));

  shadowedLum *= 0.18f;

  color *= (lum > 0 ? (shadowedLum / lum) : 0);

  float3 newLCh = okLChFromBT709(color);
  newLCh[1] *= userSaturation;
  newLCh[2] = originalLCh[2];  // hue correction

  color = bt709FromOKLCh(newLCh);
  color = mul(BT709_2_AP1_MAT, color);  // Convert to AP1
  color = max(0, color);                // Clamp to AP1
  color = mul(AP1_2_BT709_MAT, color);  // Convert BT709

  return color;
}

#endif  // SRC_COMMON_COLORGRADE_HLSL_
