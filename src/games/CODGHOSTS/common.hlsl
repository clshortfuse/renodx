#ifndef SRC_GAMES_CODGHOSTS_COMMON_HLSL_
#define SRC_GAMES_CODGHOSTS_COMMON_HLSL_

#include "./shared.h"

static const float GHOSTS_EPSILON = 1e-8f;

// Bit checks survive FXC's fast-math optimization of isfinite()/NaN comparisons.
bool GhostsIsFinite(float value) {
  return (asuint(value) & 0x7F800000u) != 0x7F800000u;
}
bool GhostsIsFinite(float3 value) {
  return all((asuint(value) & 0x7F800000u) != 0x7F800000u);
}
// 65504 is the FP16 storage limit, not SDR white or the display peak.
float GhostsFiniteSigned(float value) {
  uint bits = asuint(value);
  if ((bits & 0x7F800000u) == 0x7F800000u) {
    if ((bits & 0x007FFFFFu) != 0u) return 0.f;
    return (bits & 0x80000000u) != 0u ? -65504.f : 65504.f;
  }
  return clamp(value, -65504.f, 65504.f);
}
float2 GhostsFiniteSigned(float2 value) {
  return float2(GhostsFiniteSigned(value.x), GhostsFiniteSigned(value.y));
}
float3 GhostsFiniteSigned(float3 color) {
  return float3(GhostsFiniteSigned(color.r), GhostsFiniteSigned(color.g), GhostsFiniteSigned(color.b));
}
float3 GhostsSafeColor(float3 color) { return max(GhostsFiniteSigned(color), 0.f); }
float GhostsSafeDivide(float numerator, float denominator, float fallback = 0.f) {
  if (!GhostsIsFinite(numerator) || !GhostsIsFinite(denominator) || abs(denominator) < GHOSTS_EPSILON) return fallback;
  float value = numerator / denominator;
  return GhostsIsFinite(value) ? value : fallback;
}
float GhostsSafePow(float base, float exponent) {
  base = max(GhostsFiniteSigned(base), 0.f);
  exponent = GhostsFiniteSigned(exponent);
  if (base == 0.f) return exponent == 0.f ? 1.f : 0.f;
  return max(GhostsFiniteSigned(pow(base, exponent)), 0.f);
}
bool GhostsHasOutputConfig() {
  // Unbound/invalid injection falls back to the game's original pass.
  return GhostsIsFinite(RENODX_PEAK_WHITE_NITS) && RENODX_PEAK_WHITE_NITS > 0.f
      && GhostsIsFinite(RENODX_DIFFUSE_WHITE_NITS) && RENODX_DIFFUSE_WHITE_NITS > 0.f
      && GhostsIsFinite(RENODX_GRAPHICS_WHITE_NITS) && RENODX_GRAPHICS_WHITE_NITS > 0.f;
}
bool GhostsUseHDR() {
  return GhostsHasOutputConfig() && GhostsIsFinite(RENODX_TONE_MAP_TYPE) && RENODX_TONE_MAP_TYPE >= 0.5f;
}
float GhostsDisplayPeak() {
  float peak = GhostsSafeDivide(RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS, 1.f);
  // RenderIntermediatePass applies the opposite gamma correction before scaling.
  // Express the peak in its input domain so the final nits remain correct.
  if (RENODX_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) {
    peak = renodx::color::correct::GammaSafe(peak, true, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) {
    peak = renodx::color::correct::GammaSafe(peak, true, 2.4f);
  }
  return clamp(GhostsFiniteSigned(peak), 0.0001f, 65504.f);
}
float GhostsExposure(float exposure) {
  exposure = max(GhostsFiniteSigned(exposure), 0.f);
  float strength = saturate(GhostsFiniteSigned(RENODX_GHOSTS_AUTO_EXPOSURE_STRENGTH));
  if (strength >= 0.999999f) return exposure;
  return GhostsSafePow(max(exposure, GHOSTS_EPSILON), strength);
}

// Stable positive root, including linear/degenerate coefficients.
float GhostsPositiveRoot(float a, float b, float c, float fallback) {
  if (abs(a) < GHOSTS_EPSILON) {
    float root = GhostsSafeDivide(-c, b, fallback);
    return root > 0.f && GhostsIsFinite(root) ? root : fallback;
  }
  float disc = b * b - 4.f * a * c;
  if (!GhostsIsFinite(disc) || disc < 0.f) return fallback;
  float q = -0.5f * (b + (b < 0.f ? -sqrt(disc) : sqrt(disc)));
  float r1 = GhostsSafeDivide(q, a, -1.f), r2 = GhostsSafeDivide(c, q, -1.f);
  if (r1 > 0.f && r2 > 0.f) return min(r1, r2);
  return r1 > 0.f ? r1 : (r2 > 0.f ? r2 : fallback);
}

// Supplied UC2 basis: keep the toe, extend its tangent at 0.18 output.
float GhostsExtendedUC2Channel(float x, float exposure, float W, float a, float b,
                              float c, float d, float e, float f, float midgray) {
  x = max(GhostsFiniteSigned(x), 0.f);
  exposure = max(GhostsFiniteSigned(exposure), 0.f);
  if (exposure < GHOSTS_EPSILON) return 0.f;
  float e_over_f = GhostsSafeDivide(e, f);
  float num_w = W * (a * W + c * b) + d * e;
  float den_w = W * (a * W + b) + d * f;
  float whiteScale = GhostsSafeDivide(1.f, GhostsSafeDivide(num_w, den_w) - e_over_f, 1.f);
  float yp = GhostsSafeDivide(midgray, whiteScale) + e_over_f;
  float u_mid = GhostsPositiveRoot(a * (yp - 1.f), b * (yp - c), d * (f * yp - e), midgray);
  float x_mid = GhostsSafeDivide(u_mid, exposure, midgray);
  float d_num = a * b * (1.f - c) * u_mid * u_mid
              + 2.f * a * d * (f - e) * u_mid + b * d * (c * f - e);
  float d_den = u_mid * (a * u_mid + b) + d * f;
  float slope = max(GhostsSafeDivide(exposure * d_num * whiteScale, d_den * d_den), 0.f);
  float u = exposure * x;
  float base = (GhostsSafeDivide(u * (a * u + c * b) + d * e, u * (a * u + b) + d * f) - e_over_f) * whiteScale;
  return max(GhostsFiniteSigned(x >= x_mid ? midgray + slope * (x - x_mid) : base), 0.f);
}
float3 uncharted2Extended(float3 x, float exposure, float W = 11.2f, float a = 0.15f,
                         float b = 0.50f, float c = 0.10f, float d = 0.20f,
                         float e = 0.02f, float f = 0.30f, float midgray = 0.18f) {
  return float3(GhostsExtendedUC2Channel(x.r, exposure, W, a, b, c, d, e, f, midgray),
                GhostsExtendedUC2Channel(x.g, exposure, W, a, b, c, d, e, f, midgray),
                GhostsExtendedUC2Channel(x.b, exposure, W, a, b, c, d, e, f, midgray));
}
float3 GhostsOriginalHable(float3 scene, float exposure, float3 toeNumerator, float3 toeDenominator,
                          float3 offset, float3 linearStrength, float3 linearAngle,
                          float3 shoulderStrength, float3 whiteScale) {
  float3 x = GhostsSafeColor(scene * exposure);
  float3 quadratic = shoulderStrength * x * x, linearTerm = linearStrength * x;
  float3 numerator = quadratic + linearAngle * linearTerm + toeNumerator;
  float3 denominator = quadratic + linearTerm + toeDenominator;
  return GhostsSafeColor((float3(GhostsSafeDivide(numerator.r, denominator.r),
      GhostsSafeDivide(numerator.g, denominator.g), GhostsSafeDivide(numerator.b, denominator.b)) - offset) * whiteScale);
}
float3 GhostsExtendedHable(float3 scene, float exposure, float3 toeNumerator, float3 toeDenominator,
                          float3 linearStrength, float3 linearAngle, float3 shoulderStrength, float3 whiteScale) {
  float3 result;
  // Same UC2 basis with the game's separate R/G/B coefficients.
  [unroll] for (uint channel = 0; channel < 3; ++channel) {
    float k = GhostsSafeDivide(1.f, whiteScale[channel]) + GhostsSafeDivide(toeNumerator[channel], toeDenominator[channel]);
    float W = GhostsPositiveRoot(shoulderStrength[channel] * (1.f - k),
        linearStrength[channel] * (linearAngle[channel] - k), toeNumerator[channel] - k * toeDenominator[channel], 11.2f);
    result[channel] = GhostsExtendedUC2Channel(scene[channel], exposure, W, shoulderStrength[channel],
        linearStrength[channel], linearAngle[channel], 1.f, toeNumerator[channel], toeDenominator[channel], 0.18f);
  }
  return GhostsSafeColor(result);
}
float reinhardPiecewiseSmooth(float x, float peak, float anchor) {
  x = max(GhostsFiniteSigned(x), 0.f);
  peak = max(GhostsFiniteSigned(peak), GHOSTS_EPSILON);
  anchor = clamp(GhostsFiniteSigned(anchor), 0.f, peak);
  if (x <= anchor) return x;
  float range = peak - anchor;
  if (range < GHOSTS_EPSILON) return peak;
  float t = (x - anchor) / range;
  float s = exp(-0.01f / max(t * t, GHOSTS_EPSILON * GHOSTS_EPSILON));
  return min(anchor + range * GhostsSafeDivide(t, 1.f + t * s), peak);
}
float3 reinhardPiecewiseSmooth(float3 color, float peak, float anchor) {
  return float3(reinhardPiecewiseSmooth(color.r, peak, anchor), reinhardPiecewiseSmooth(color.g, peak, anchor),
                reinhardPiecewiseSmooth(color.b, peak, anchor));
}

#include "./prismTM.hlsl"

float3 GhostsPreControls(float3 scene) {
  scene = GhostsSafeColor(scene);
  float exposure = max(GhostsFiniteSigned(RENODX_TONE_MAP_EXPOSURE), 0.f);
  float exposedY = renodx::color::y::from::BT709(scene) * exposure;
  float y = exposedY / 0.18f;
  float flareScale = GhostsSafeDivide(y + GhostsFiniteSigned(RENODX_TONE_MAP_FLARE), y, 1.f);
  float contrastY = GhostsSafePow(y, GhostsFiniteSigned(RENODX_TONE_MAP_CONTRAST) * flareScale);
  float highY = lerp(contrastY, GhostsSafePow(contrastY, RENODX_TONE_MAP_HIGHLIGHTS), saturate(contrastY * 0.18f));
  float shadowY = lerp(GhostsSafePow(highY, 2.f - RENODX_TONE_MAP_SHADOWS), highY, saturate(highY / 0.18f));
  return GhostsSafeColor(scene * exposure * GhostsSafeDivide(shadowY * 0.18f, exposedY));
}
float3 GhostsPostControls(float3 color) {
  color = GhostsSafeColor(color);
  if (RENODX_TONE_MAP_SATURATION == 1.f && RENODX_TONE_MAP_BLOWOUT == 0.f && RENODX_TONE_MAP_HIGHLIGHT_SATURATION == 1.f) return color;
  float y = renodx::color::y::from::BT709(color);
  // Lab/JzAzBz chroma is signed; positive RGB cleanup must not erase its hue.
  float3 lab = GhostsFiniteSigned(renodx::color::oklab::from::BT709(color));
  float dechroma = GhostsFiniteSigned(RENODX_TONE_MAP_BLOWOUT);
  float blowout = 1.f - GhostsFiniteSigned(RENODX_TONE_MAP_HIGHLIGHT_SATURATION);
  if (dechroma != 0.f) lab.yz *= 1.f - saturate(GhostsSafePow(y / 100.f, 1.f - dechroma));
  if (blowout != 0.f) {
    float amount = GhostsSafePow(1.f - saturate(y / 100.f), 100.f * abs(blowout));
    lab.yz *= blowout < 0.f ? 2.f - amount : amount;
  }
  lab.yz *= max(GhostsFiniteSigned(RENODX_TONE_MAP_SATURATION), 0.f);
  return GhostsSafeColor(renodx::color::bt709::clamp::AP1(renodx::color::bt709::from::OkLab(GhostsFiniteSigned(lab))));
}
float GhostsLUTScale(float3 color) {
  float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(GhostsSafeColor(color));
  return GhostsIsFinite(scale) ? clamp(scale, GHOSTS_EPSILON, 1.f) : 1.f;
}
float3 GhostsRestoreGrade(float3 proxy, float3 graded, float scale) {
  return GhostsSafeColor(lerp(proxy, GhostsSafeColor(graded), saturate(GhostsFiniteSigned(RENODX_COLOR_GRADE_STRENGTH)))
      / max(scale, GHOSTS_EPSILON));
}
float3 GhostsDisplayMap(float3 color) {
  color = GhostsPostControls(color);
  // Keep the existing saturated-color gamut guard before perceptual transforms.
  color = GhostsSafeColor(renodx::color::bt709::clamp::AP1(color));
  float peak = GhostsDisplayPeak();
  float3 mapped = 0.f;
  if (abs(RENODX_TONE_MAP_TYPE - RENODX_TONE_MAP_TYPE_PRISM) < 0.5f) {
    // Keep the supplied Prism matrix/curve/matrix sequence. The outset can
    // overshoot peak: scale RGB together rather than clipping separate channels.
    mapped = GhostsSafeColor(prism(color, peak));
    float maximum = max(mapped.r, max(mapped.g, mapped.b));
    mapped *= min(1.f, GhostsSafeDivide(peak, maximum, 1.f));
  } else {
    // Preserve brightness through diffuse white before entering the shoulder.
    // This releases the earlier 0.18-anchor compression without changing the toe,
    // exposure, UI white, or configured HDR peak.
    float anchor = min(1.f, peak);
    if (RENODX_TONE_MAP_PER_CHANNEL >= 0.5f) {
      mapped = reinhardPiecewiseSmooth(color, peak, anchor);
    } else {
      float y = renodx::color::y::from::BT709(color);
      mapped = color * GhostsSafeDivide(reinhardPiecewiseSmooth(y, peak, anchor), y);
      // Limit RGB uniformly, keeping saturated highlight hue intact.
      float maximum = max(mapped.r, max(mapped.g, mapped.b));
      mapped *= min(1.f, GhostsSafeDivide(peak, maximum, 1.f));
    }
  }
  // Fall back as an RGB triplet, so an invalid saturated color cannot lose one channel.
  if (!GhostsIsFinite(mapped)) mapped = reinhardPiecewiseSmooth(color, peak, 0.18f);
  return GhostsSafeColor(mapped);
}
float3 GhostsRenderEncodedOutput(float3 encoded) {
  encoded = GhostsSafeColor(encoded);
  float3 output = encoded;
  if (GhostsHasOutputConfig()) {
    // This decodes our own output encode, not the game's finished SDR frame.
    // RenoDX scales scene by Game/UI brightness before the later UI composite;
    // the final output scales both by UI brightness, keeping them independent.
    float3 linearColor = GhostsSafeColor(renodx::color::srgb::DecodeSafe(encoded));
    output = renodx::draw::RenderIntermediatePass(linearColor);
  }
  return GhostsSafeColor(output);
}
float3 GhostsEncodeOutput(float3 linearColor, float offset = 0.f, float gain = 1.f) {
  float3 encoded = renodx::color::srgb::EncodeSafe(GhostsSafeColor(linearColor));
  encoded = GhostsSafeColor((encoded - GhostsFiniteSigned(offset)) * GhostsFiniteSigned(gain));
  if (!GhostsUseHDR()) encoded = saturate(encoded);
  // Clamp the SDR signal before scaling, so Game Brightness above UI Brightness
  // can still occupy HDR intermediate values even with the Vanilla curve.
  return GhostsRenderEncodedOutput(encoded);
}

#endif  // SRC_GAMES_CODGHOSTS_COMMON_HLSL_
