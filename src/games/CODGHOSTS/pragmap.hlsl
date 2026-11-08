// Pragmap (Pragmatic Display Mapping)

// The pipeline is as follows:
// Bezold-Brucke hue shift -> max channel blowout -> luminance tonemapping -> overshoot correction

#include "./shared.h"

// ---------------------------------------------------------------- constants

static const float epsilon = 1e-6f;

static const float pi = 3.14159265358979324f;
static const float twoPi = 6.28318530717958648f;
static const float invTwoPi = 0.15915494309189534f;

static const float bbPurpleHue = 0.19199f; //  11.0 deg  repeller (494c)
static const float bbYellowHue = 1.86750f; // 107.0 deg  ATTRACTOR (571nm)
static const float bbGreenHue = 2.95833f;  // 169.5 deg  repeller (506nm)
static const float bbBlueHue = 4.45932f; // 255.5 deg  ATTRACTOR (474nm)

static const float bbArcToYellow = bbYellowHue - bbPurpleHue;
static const float bbArcToGreen = bbGreenHue - bbPurpleHue;
static const float bbArcToBlue = bbBlueHue - bbPurpleHue;

static const float jzazbzExponentScale = 1.7f;
static const float jzazbzEpsilon = 1.6295499532821566e-11f;

static const float toneAnchor = 0.18f;
static const float toneCompression = 1.5f;
static const float overshootShoulder = 0.8f;

// ------------------------------------------------------- tonemap

// from Musa
float anchoredCInfinityShoulder(float color, float peak, float anchor, float compressionStrength) {
  float shoulderRange = peak - anchor;
  float distanceFromAnchor = max(color - anchor, 0.f);
  float flatWeight = exp2(-renodx::math::DivideSafe(shoulderRange, compressionStrength * distanceFromAnchor));
  float responseDenominator = mad(distanceFromAnchor, flatWeight, shoulderRange);
  return mad(shoulderRange, renodx::math::DivideSafe(distanceFromAnchor, responseDenominator, 0.f), color - distanceFromAnchor);
}

// from Musa
float3 anchoredCInfinityShoulder(float3 color, float3 peak, float3 anchor, float compressionStrength) {
  float3 shoulderRange = peak - anchor;
  float3 distanceFromAnchor = max(color - anchor, 0.f);
  float3 flatWeight = exp2(-renodx::math::DivideSafe(shoulderRange, compressionStrength * distanceFromAnchor));
  float3 responseDenominator = mad(distanceFromAnchor, flatWeight, shoulderRange);
  return mad(shoulderRange, renodx::math::DivideSafe(distanceFromAnchor, responseDenominator, 0.f.xxx), color - distanceFromAnchor);
}

// ------------------------------------------------------- JzAzBz
float3 jzazbzFromBt709(float3 bt709, float referenceLuminance, float exponentScaleFactor) {
  float3 rgb = renodx::color::bt2020::from::BT709(bt709);

  float3 lms;
  lms.x = rgb.x * 0.530004f + rgb.y * 0.355704f + rgb.z * 0.086090f;
  lms.y = rgb.x * 0.289388f + rgb.y * 0.525395f + rgb.z * 0.157481f;
  lms.z = rgb.x * 0.091098f + rgb.y * 0.147588f + rgb.z * 0.734234f;

  float3 lmsPq = renodx::math::SafePow(saturate(renodx::color::pq::EncodeSafe(lms, referenceLuminance)), exponentScaleFactor);

  float iz = 0.5f * lmsPq.x + 0.5f * lmsPq.y;
  float jz = (0.44f * iz) / max(1.f - 0.56f * iz, epsilon) - jzazbzEpsilon;
  float az = 3.524000f * lmsPq.x - 4.066708f * lmsPq.y + 0.542708f * lmsPq.z;
  float bz = 0.199076f * lmsPq.x + 1.096799f * lmsPq.y - 1.295875f * lmsPq.z;

  return float3(jz, az, bz);
}

float3 jzazbzFromBt709(float3 bt709) {
  return jzazbzFromBt709(bt709, RENODX_DIFFUSE_WHITE_NITS, jzazbzExponentScale);
}

float3 bt709FromJzAzBz(float3 jzazbz, float referenceLuminance, float exponentScaleFactor) {
  float jz = jzazbz.x + jzazbzEpsilon;
  float iz = jz / max(0.44f + 0.56f * jz, epsilon);
  float az = jzazbz.y;
  float bz = jzazbz.z;

  float lPq = iz + az * 0.1386050432715393f + bz * 0.05804731615611869f;
  float mPq = iz - az * 0.1386050432715393f - bz * 0.05804731615611869f;
  float sPq = iz - az * 0.09601924202631895f - bz * 0.8118918960560390f;

  float inverseExponentScale = 1.f / max(exponentScaleFactor, epsilon);

  float3 lmsPq = renodx::math::SafePow(clamp(float3(lPq, mPq, sPq), -1.f, 1.f), inverseExponentScale);
  float3 lms = sign(lmsPq) * renodx::color::pq::Decode(abs(lmsPq), referenceLuminance);

  float3 bt2020;
  bt2020.r = lms.x * 2.990669f - lms.y * 2.049742f + lms.z * 0.088977f;
  bt2020.g = -lms.x * 1.634525f + lms.y * 3.145627f - lms.z * 0.483037f;
  bt2020.b = -lms.x * 0.042505f - lms.y * 0.377983f + lms.z * 1.448019f;

  return renodx::color::bt709::from::BT2020(bt2020);
}

float3 bt709FromJzAzBz(float3 jzazbz) {
  return bt709FromJzAzBz(jzazbz, RENODX_DIFFUSE_WHITE_NITS, jzazbzExponentScale);
}


// --------------------------------------------------- Bezold-Brucke hue shift

float bezoldBruckeShift(float hue, float amount) {
  float h = hue - bbPurpleHue;
  h -= twoPi * floor(h * invTwoPi);

  float arcStart, arcEnd, arcSign;
  if (h < bbArcToYellow) {  // purple -> yellow   (reds, oranges)      attractor at the far end
    arcStart = 0.f;
    arcEnd = bbArcToYellow;
    arcSign = 1.f;
  } else if (h < bbArcToGreen) {  // yellow -> green    (yellow-greens)     attractor at the near end
    arcStart = bbArcToYellow;
    arcEnd = bbArcToGreen;
    arcSign = -1.f;
  } else if (h < bbArcToBlue) {  // green -> blue      (greens, cyans)     attractor at the far end
    arcStart = bbArcToGreen;
    arcEnd = bbArcToBlue;
    arcSign = 1.f;
  } else {  // blue -> purple     (violets, magentas) attractor at the near end
    arcStart = bbArcToBlue;
    arcEnd = twoPi;
    arcSign = -1.f;
  }

  float arcLength = arcEnd - arcStart;
  float t = (h - arcStart) / arcLength;
  float distanceToAttractor = arcSign > 0.f ? (1.f - t) : t;

  return arcSign * arcLength * min(0.5f * sin(pi * t) * amount, distanceToAttractor);
}

float3 hueShiftBezoldBrucke(float3 jzazbz, float driver, float cap) {
  float chroma = length(jzazbz.yz);
  if (chroma < epsilon) return jzazbz;

  float hue = atan2(jzazbz.z, jzazbz.y);
  float shifted = hue + bezoldBruckeShift(hue, saturate(cap * driver));

  float sinHue, cosHue;
  sincos(shifted, sinHue, cosHue);
  jzazbz.yz = float2(cosHue, sinHue) * chroma;

  return jzazbz;
}

// ------------------------------------------------------- overshoot correction


float3 overshootCorrection(float3 color, float peak, float shoulder = 0.8f, float compressionStrength = 0.75f) {
  peak = max(peak, epsilon);
  shoulder = clamp(shoulder, 0.01f, 0.99f);

  compressionStrength = max(compressionStrength, 0.7f);

  float shoulderStart = peak * shoulder;

  return anchoredCInfinityShoulder(color, peak.xxx, shoulderStart.xxx, compressionStrength);
}

// --------------------------------------------------------------------- main

float3 pragmap(float3 color, float peak, float hueStrength = 0.75f, float blowoutStrength = 0.75f) {
  float y1 = renodx::color::y::from::BT709(color);
  float y2 = anchoredCInfinityShoulder(y1, peak, toneAnchor, toneCompression);

  float m1 = max(color.r, max(color.g, color.b));
  float m2 = anchoredCInfinityShoulder(m1, peak, toneAnchor, toneCompression);
  float mDiff = saturate(renodx::math::DivideSafe(m2, m1, 1.f));

  float hueDriver = renodx::math::DivideSafe(y2 - toneAnchor, peak - toneAnchor, 0.f);
  float3 jzazbz = jzazbzFromBt709(color);
  jzazbz = hueShiftBezoldBrucke(jzazbz, hueDriver, hueStrength);
  float3 bCol = jzazbz;
  bCol.yz *= mDiff;
  jzazbz = lerp(jzazbz, bCol, blowoutStrength);

  color = bt709FromJzAzBz(jzazbz);

  color *= renodx::math::DivideSafe(y2, renodx::color::y::from::BT709(color), 1.f);
  return overshootCorrection(color, peak, overshootShoulder);
}
