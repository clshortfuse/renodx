#ifndef SRC_GAMES_SNIPERELITE5_LILIUM_RCAS_HLSLI_
#define SRC_GAMES_SNIPERELITE5_LILIUM_RCAS_HLSLI_

// Based on Lilium's RCAS (EndlesslyFlowering)
// RCAS - Robust Contrast Adaptive Sharpening
// Input and output are linear BT.709.

float LiliumLuma(float3 c) {
  return dot(c, float3(0.2126f, 0.7152f, 0.0722f));
}

// b, d, e, f, h: linear taps (top, left, center, right, bottom).
// sharpness: linear lobe multiplier (0 = off).
// normalization: Lilium's SHARPENING_NORMALIZATION_POINT, i.e. RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS.
float3 ApplyLiliumRCAS(float3 b, float3 d, float3 e, float3 f, float3 h, float sharpness, float normalization) {
  b /= normalization;
  d /= normalization;
  e /= normalization;
  f /= normalization;
  h /= normalization;

  // Immediate constants for peak range.
  static const float2 peakC = float2(1.f, -4.f);

  float bLum = LiliumLuma(b);
  float dLum = LiliumLuma(d);
  float eLum = LiliumLuma(e);
  float fLum = LiliumLuma(f);
  float hLum = LiliumLuma(h);

  // Min and max of ring.
  float min4Lum = min(min(bLum, dLum), min(fLum, hLum));
  float max4Lum = max(max(bLum, dLum), max(fLum, hLum));

  // 0.99 found through testing -> see my latest desmos or https://www.desmos.com/calculator/4dyqhishpl
  // this helps reducing massive overshoot that would happen otherwise
  // normal CAS applies a limiter too so that there is no overshoot
  float limited_max4Lum = clamp(max4Lum, 1e-6f, 0.99f);

  float hitMinLum = min4Lum * (1.f / (4.f * limited_max4Lum));

  float hitMaxLum = (peakC.x - limited_max4Lum) * (1.f / (4.f * min4Lum + peakC.y));

  float localLobe = max(-hitMinLum, hitMaxLum);

// This is set at the limit of providing unnatural results for sharpening.
// 0.25f - (1.f / 16.f)
  static const float FSR_RCAS_LIMIT = 0.1875f;

  float lobe = max(float(-FSR_RCAS_LIMIT), min(localLobe, 0.f)) * sharpness;

  float bLuma2x = bLum * 2.f;
  float dLuma2x = dLum * 2.f;
  float eLuma2x = eLum * 2.f;
  float fLuma2x = fLum * 2.f;
  float hLuma2x = hLum * 2.f;
  // Noise detection.
  float nz = 0.25f * bLuma2x
             + 0.25f * dLuma2x
             + 0.25f * fLuma2x
             + 0.25f * hLuma2x
             - eLuma2x;

  float maxLuma2x = max(max(max(bLuma2x, dLuma2x), max(eLuma2x, fLuma2x)), hLuma2x);
  float minLuma2x = min(min(min(bLuma2x, dLuma2x), min(eLuma2x, fLuma2x)), hLuma2x);

  nz = saturate(abs(nz) * (1.f / max(maxLuma2x - minLuma2x, 1e-6f)));
  nz = -0.5f * nz + 1.f;

  lobe *= nz;

  // Resolve.
  float rcpL = 1.f / (4.f * lobe + 1.f);

  float pixLum = ((bLum + dLum + hLum + fLum) * lobe + eLum) * rcpL;
  float3 pix = clamp((pixLum / max(eLum, 1e-6f)), 0.f, 4.f) * e;

  pix *= normalization;

  return pix;
}

#endif  // SRC_GAMES_SNIPERELITE5_LILIUM_RCAS_HLSLI_
