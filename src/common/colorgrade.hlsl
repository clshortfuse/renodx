#ifndef SRC_COMMON_COLORGRADE_HLSL_
#define SRC_COMMON_COLORGRADE_HLSL_

#include "./color.hlsl"

float3 applyContrastSafe(float3 color, float contrast, float midGray = 0.18f, float3x3 colorspace = BT709_2_XYZ_MAT) {
  float3 workingColor = pow(abs(color) / midGray, contrast) * sign(color) * midGray;
  float workingLuminance = dot(abs(workingColor), float3(colorspace[1].r, colorspace[1].g, colorspace[1].b));
  float colorLuminance = dot(abs(color), float3(colorspace[1].r, colorspace[1].g, colorspace[1].b));
  return color * (colorLuminance ? (workingLuminance / colorLuminance) : 1.f);
}

/* Shadow Contrast
    Invertible cubic shadow exposure function
    https://www.desmos.com/calculator/ubgteikoke
    https://colab.research.google.com/drive/1JT_-S96RZyfHPkZ620QUPIRfxmS_rKlx
*/
float3 shd_con(float3 rgb, float ex, float str) {
  // Parameter setup
  const float m = exp2(ex);
  // Perf: explicit cube
  // const float w = pow(str, 3.0f);
  const float w = str * str * str;

  const float n = max(rgb.x, max(rgb.y, rgb.z));
  const float n2 = n * n;
  const float dividend = n2 + w;
  const float s = dividend ? (n2 + m * w) / dividend : 1.f;  // Implicit divide by n
  return rgb * s;
}

/* Highlight Contrast
    Invertible quadratic highlight contrast function. Same as ex_high without lin ext
    https://www.desmos.com/calculator/p7j4udnwkm
*/
float3 hl_con(float3 rgb, float ex, float th) {
  // Parameter setup
  const float p = exp2(-ex);
  const float t0 = 0.18f * exp2(th);
  const float a = pow(t0, 1.0f - p) / p;
  const float b = t0 * (1.0f - 1.0f / p);

  const float n = max(rgb.x, max(rgb.y, rgb.z));
  if (n == 0.0f || n < t0) return rgb;
  return rgb * (pow((n - b) / a, 1.0f / p) / n);
}

float3 apply_user_shadows(float3 rgb, float shadows = 1.f) {
  // Perf: explicit cube
  // rgb = shd_con(rgb, -1.8f, pow(2.f - shadows, 3) * 0.04); // 0.04 @ 1
  rgb = sign(rgb) * shd_con(abs(rgb), -1.8f, pow(2.f - 2 * min(shadows, 1.f), 4.f) * 0.025);  // 0.04 @ 1
  rgb = sign(rgb) * shd_con(abs(rgb), -0.50f * shadows * (1.f - shadows), 0.25f);             // 0 @ 1

  return rgb;
}

float3 apply_user_highlights(float3 rgb, float highlights = 1.f) {
  rgb = sign(rgb) * hl_con(abs(rgb), (highlights - 1.f) * 4.f, 2.f);
  return rgb;
}

float3 applySaturation(float3 bt709, float saturation = 1.f) {
  float3 okLCh = okLChFromBT709(bt709);
  okLCh[1] *= saturation;
  return bt709FromOKLCh(okLCh);
}

float3 applyUserColorGrading(
  float3 color,
  float userExposure = 1.f,
  float userSaturation = 1.f,
  float userShadows = 1.f,
  float userHighlights = 1.f,
  float userContrast = 1.f
) {
  if (userExposure != 1.f) {
    color *= userExposure;
  }
  if (userSaturation != 1.f) {
    color = applySaturation(color, userSaturation);
  }
  if (userShadows != 1.f) {
    color = apply_user_shadows(color, userShadows);
  }
  if (userHighlights != 1.f) {
    color = apply_user_highlights(color, userHighlights);
  }
  if (userContrast != 1.f) {
    color = applyContrastSafe(color, userContrast);
  }
  return color;
}

#endif  // SRC_COMMON_COLORGRADE_HLSL_
