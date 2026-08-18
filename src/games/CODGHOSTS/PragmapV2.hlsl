#include "./shared.h"

static const float epsilon = 1e-6f;

float3 withLuminance(float3 color, float luminance) {
  return color * renodx::math::DivideSafe(luminance, renodx::color::y::from::BT709(color), 1.f);
}

// from Musa
float anchoredCInfinityShoulder(float color, float peak, float anchor, float compressionStrength) {
  float shoulderRange = peak - anchor;
  float distanceFromAnchor = max(color - anchor, 0.f);
  float flatWeight = exp2(-shoulderRange / (compressionStrength * distanceFromAnchor));
  float responseDenominator = mad(distanceFromAnchor, flatWeight, shoulderRange);
  return mad(shoulderRange, distanceFromAnchor / responseDenominator, color - distanceFromAnchor);
}

// from Musa
float3 anchoredCInfinityShoulder(float3 color, float3 peak, float3 anchor, float compressionStrength) {
  float3 shoulderRange = peak - anchor;
  float3 distanceFromAnchor = max(color - anchor, 0.f);
  float3 flatWeight = exp2(-shoulderRange / (compressionStrength * distanceFromAnchor));
  float3 responseDenominator = mad(distanceFromAnchor, flatWeight, shoulderRange);
  return mad(shoulderRange, distanceFromAnchor / responseDenominator, color - distanceFromAnchor);
}


float3 hueShiftBlowout(float3 color, float ratio, float hueStrength = 1.f, float blowoutStrength = 0.5f) {
  float3 perChannel = anchoredCInfinityShoulder(color, 1.0, 0.18, 1.5);
  float3 reference = withLuminance(perChannel, renodx::color::y::from::BT709(color));

  float3 oklabSource = renodx::color::oklab::from::BT709(color);
  float3 oklabReference = renodx::color::oklab::from::BT709(reference);

  float chromaSource = length(oklabSource.yz);
  float chromaReference = length(oklabReference.yz);

  if (max(chromaSource, chromaReference) >= epsilon) {
    float2 hueSource = chromaSource > epsilon ? oklabSource.yz / chromaSource : oklabReference.yz / chromaReference;
    float2 hueReference = chromaReference > epsilon ? oklabReference.yz / chromaReference : hueSource;

    float2 hueBlended = lerp(hueSource, hueReference, hueStrength * ratio);
    float hueBlendedLength = length(hueBlended);
    float2 hue = hueBlendedLength > epsilon ? hueBlended / hueBlendedLength : hueSource;

    oklabSource.yz = hue * chromaSource;
  }

  float3 hueShifted = renodx::color::bt709::from::OkLab(oklabSource);
  float colMax = max(hueShifted.r, max(hueShifted.g, hueShifted.b));
  float stops = max(log2(max(colMax, epsilon) / ratio), 0.f);
  float fade = 1.f - exp2(-blowoutStrength * stops);

  oklabSource.yz *= 1.f - fade;

  return renodx::color::bt709::from::OkLab(oklabSource);
}

float3 overshootCorrection(float3 color, float peak, float shoulder = 0.8f, float compressionStrength = 0.75f) {
  shoulder = clamp(shoulder, 0.01f, 0.99f);

  float shoulderLog2 = log2(shoulder);
  float3 shaped = log2(max(color / peak, 1e-10f));
  float3 rolled = anchoredCInfinityShoulder(shaped, 0.f, shoulderLog2, compressionStrength);

  rolled = min(shaped, min(rolled, 0.f));

  return lerp(peak * exp2(rolled), color, step(color, 0.f));
}

float3 pragmap(float3 color, float peak, float hueStrength = 0.25, float blowoutStrength = 0.20f) {
  float y0 = renodx::color::y::from::BT709(color);
  float ratio = renodx::math::DivideSafe(anchoredCInfinityShoulder(y0, peak, 0.18, 1.5), y0, 1.f);

  color = hueShiftBlowout(color, ratio, hueStrength, blowoutStrength);

  float y1 = renodx::color::y::from::BT709(color);
  color *= renodx::math::DivideSafe(anchoredCInfinityShoulder(y1, peak, 0.18, 1.5), y1, 1.f);

  return overshootCorrection(color, peak, 0.8f);
}