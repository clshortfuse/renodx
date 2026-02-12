#include "./shared.h"

float Max(float x, float y, float z) {
  return max(x, max(y, z));
}

float Max(float x, float y, float z, float w) {
  return max(x, max(y, max(z, w)));
}

float Min(float x, float y, float z) {
  return min(x, min(y, z));
}

float Min(float x, float y, float z, float w) {
  return min(x, min(y, min(z, w)));
}

// from Lilium
// RCAS - Robust Contrast Adaptive Sharpening
float3 ApplyRCAS(
    float3 center_color, float2 tex_coord,
    Texture2D<float4> SamplerFrameBuffer_TEX, SamplerState SamplerFrameBuffer_SMP_s) {
  if (CUSTOM_RCAS == 0.f) return center_color;  // Skip sharpening if amount is zero

#define ENABLE_NOISE_REMOVAL           1u // Always good to be enabled
#define ENABLE_NORMALIZATION           1u
//#define SHARPENING_NORMALIZATION_POINT RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS
#define SHARPENING_NORMALIZATION_POINT 125

  uint width, height;
  SamplerFrameBuffer_TEX.GetDimensions(width, height);
  float2 texel_size = 1.0 / float2(width, height);

  // Algorithm uses minimal 3x3 pixel neighborhood.
  //    b
  //  d e f
  //    h
  float3 b =
      renodx::color::pq::DecodeSafe(SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(0, -1) * texel_size, 0).rgb, 1.f);
  float3 d =
  renodx::color::pq::DecodeSafe(SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(-1, 0) * texel_size, 0).rgb, 1.f);
  float3 e =
      center_color;
  float3 f =
  renodx::color::pq::DecodeSafe(SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(1, 0) * texel_size, 0).rgb, 1.f);
  float3 h =
  renodx::color::pq::DecodeSafe(SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(0, 1) * texel_size, 0).rgb, 1.f);

#if ENABLE_NORMALIZATION
  b /= SHARPENING_NORMALIZATION_POINT;
  d /= SHARPENING_NORMALIZATION_POINT;
  e /= SHARPENING_NORMALIZATION_POINT;
  f /= SHARPENING_NORMALIZATION_POINT;
  h /= SHARPENING_NORMALIZATION_POINT;
#endif

  // Immediate constants for peak range.
  static const float2 peakC = float2(1.f, -4.f);

  // Calculate luminance of center and neighbors
  float bLum = renodx::color::y::from::BT2020(b);
  float dLum = renodx::color::y::from::BT2020(d);
  float eLum = renodx::color::y::from::BT2020(e);
  float fLum = renodx::color::y::from::BT2020(f);
  float hLum = renodx::color::y::from::BT2020(h);

  // Min and max of ring.
  float min4Lum = Min(bLum, dLum, fLum, hLum);
  float max4Lum = Max(bLum, dLum, fLum, hLum);

  // 0.99 found through testing -> see my latest desmos or https://www.desmos.com/calculator/4dyqhishpl
  // this helps reducing massive overshoot that would happen otherwise
  // normal CAS applies a limiter too so that there is no overshoot
  float limited_max4Lum = min(max4Lum, 0.99f);

  float hitMinLum = min4Lum
                    * rcp(4.f * limited_max4Lum);

  float hitMaxLum = (peakC.x - limited_max4Lum)
                    * rcp(4.f * min4Lum + peakC.y);

  float localLobe = max(-hitMinLum, hitMaxLum);

// This is set at the limit of providing unnatural results for sharpening.
// 0.25f - (1.f / 16.f)
#define FSR_RCAS_LIMIT 0.1875f

  float lobe = max(float(-FSR_RCAS_LIMIT),
                   min(localLobe, 0.f))
               * CUSTOM_RCAS;

#if ENABLE_NOISE_REMOVAL
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

  float maxLuma2x = Max(Max(bLuma2x, dLuma2x, eLuma2x), fLuma2x, hLuma2x);
  float minLuma2x = Min(Min(bLuma2x, dLuma2x, eLuma2x), fLuma2x, hLuma2x);

  nz = saturate(abs(nz) * rcp(maxLuma2x - minLuma2x));
  nz = -0.5f * nz + 1.f;

  lobe *= nz;
#endif

  // Resolve, which needs the medium precision rcp approximation to avoid visible tonality changes.
  float rcpL = rcp(4.f * lobe + 1.f);

  float pixLum = ((bLum + dLum + hLum + fLum) * lobe + eLum) * rcpL;
  float3 pix = clamp((pixLum / eLum), 0.f, 4.f) * e;

#if ENABLE_NORMALIZATION
  pix *= SHARPENING_NORMALIZATION_POINT;
#endif

  return pix;
}
