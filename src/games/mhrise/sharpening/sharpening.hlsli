#ifndef RE4_SHARPENING_HLSLI_
#define RE4_SHARPENING_HLSLI_

#include "../shared.h"

// from Lilium
// RCAS - Robust Contrast Adaptive Sharpening
// Optimized version that accepts pre-calculated texture bounds
float3 ApplyLiliumRCAS(
    Texture2D<float4> texture,
    int2 coord,
    float sharpness_strength,
    float normalization_point,
    int2 tex_max) {
  // Algorithm uses minimal 3x3 pixel neighborhood
  //    b
  //  d e f
  //    h
  float3 b = texture.Load(int3(clamp(coord + int2(0, -1), int2(0, 0), tex_max), 0)).rgb / normalization_point;
  float3 d = texture.Load(int3(clamp(coord + int2(-1, 0), int2(0, 0), tex_max), 0)).rgb / normalization_point;
  float3 e = texture.Load(int3(clamp(coord, int2(0, 0), tex_max), 0)).rgb / normalization_point;
  float3 f = texture.Load(int3(clamp(coord + int2(1, 0), int2(0, 0), tex_max), 0)).rgb / normalization_point;
  float3 h = texture.Load(int3(clamp(coord + int2(0, 1), int2(0, 0), tex_max), 0)).rgb / normalization_point;

  // Immediate constants for peak range
  static const float2 kPeakConstants = float2(1.f, -4.f);

  // Calculate luminance of center and neighbors
  float b_lum = renodx::color::y::from::BT709(b);
  float d_lum = renodx::color::y::from::BT709(d);
  float e_lum = renodx::color::y::from::BT709(e);
  float f_lum = renodx::color::y::from::BT709(f);
  float h_lum = renodx::color::y::from::BT709(h);

  // Min and max of ring
  float min4_lum = renodx::math::Min(b_lum, d_lum, f_lum, h_lum);
  float max4_lum = renodx::math::Max(b_lum, d_lum, f_lum, h_lum);

  // 0.99 found through testing -> see my latest desmos or https://www.desmos.com/calculator/4dyqhishpl
  // this helps reducing massive overshoot that would happen otherwise
  // normal CAS applies a limiter too so that there is no overshoot
  float limited_max4_lum = min(max4_lum, 0.99f);

  float hit_min_lum = min4_lum * rcp(4.f * limited_max4_lum);
  float hit_max_lum = (kPeakConstants.x - limited_max4_lum) * rcp(4.f * min4_lum + kPeakConstants.y);
  float local_lobe = max(-hit_min_lum, hit_max_lum);

  // This is set at the limit of providing unnatural results for sharpening
  // 0.25f - (1.0f / 16.0f)
  static const float kFsrRcasLimit = 0.1875f;

  float lobe = max(-kFsrRcasLimit, min(local_lobe, 0.f)) * sharpness_strength;

  // Noise detection
  float b_luma_2x = b_lum * 2.0f;
  float d_luma_2x = d_lum * 2.0f;
  float e_luma_2x = e_lum * 2.0f;
  float f_luma_2x = f_lum * 2.0f;
  float h_luma_2x = h_lum * 2.0f;

  float nz = 0.25f * b_luma_2x
             + 0.25f * d_luma_2x
             + 0.25f * f_luma_2x
             + 0.25f * h_luma_2x
             - e_luma_2x;

  float max_luma_2x = renodx::math::Max(renodx::math::Max(b_luma_2x, d_luma_2x, e_luma_2x), f_luma_2x, h_luma_2x);
  float min_luma_2x = renodx::math::Min(renodx::math::Min(b_luma_2x, d_luma_2x, e_luma_2x), f_luma_2x, h_luma_2x);

  nz = saturate(abs(nz) * rcp(max_luma_2x - min_luma_2x));
  nz = -0.5f * nz + 1.f;

  lobe *= nz;

  // Resolve, which needs the medium precision rcp approximation to avoid visible tonality changes
  float rcp_l = rcp(4.0f * lobe + 1.f);
  float pix_lum = ((b_lum + d_lum + h_lum + f_lum) * lobe + e_lum) * rcp_l;
  float3 sharpened = clamp(pix_lum / e_lum, 0.f, 4.f) * e;

  if (TONE_MAP_TYPE != 0.f) sharpened = min(1, sharpened);
  sharpened *= normalization_point;

  return sharpened;
}

// Original version with built-in dimension calculation (for backwards compatibility)
float3 ApplyLiliumRCAS(
    Texture2D<float4> texture,
    int2 coord,
    float sharpness_strength,
    float normalization_point) {
  // Get texture dimensions and calculate max valid coordinates
  uint tex_width, tex_height;
  texture.GetDimensions(tex_width, tex_height);
  int2 tex_max = int2(tex_width - 1, tex_height - 1);

  return ApplyLiliumRCAS(texture, coord, sharpness_strength, normalization_point, tex_max);
}

// Convenience wrapper with default parameters for RE games
float3 ApplyLiliumRCAS(
    Texture2D<float4> texture,
    int2 coord,
    float sharpness_strength) {
  float kDefaultNormalization = 100.f;
  if (TONE_MAP_TYPE != 0.f) {
    kDefaultNormalization = RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      kDefaultNormalization = renodx::color::correct::Gamma(kDefaultNormalization, true);
    }
  }

  return ApplyLiliumRCAS(texture, coord, sharpness_strength, kDefaultNormalization);
}

// Optimized convenience wrapper that calculates texture dimensions once
float3 ApplyLiliumRCAS(
    Texture2D<float4> texture,
    int2 coord,
    float sharpness_strength,
    int2 tex_max) {
  float kDefaultNormalization = 100.f;
  if (TONE_MAP_TYPE != 0.f) {
    kDefaultNormalization = RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      kDefaultNormalization = renodx::color::correct::Gamma(kDefaultNormalization, true);
    }
  }
  return ApplyLiliumRCAS(texture, coord, sharpness_strength, kDefaultNormalization, tex_max);
}

// from Lilium
// RCAS - Robust Contrast Adaptive Sharpening
// Optimized version that accepts pre-calculated texture bounds
float3 ApplyLiliumRCASFromSamples(
    float3 b,
    float3 d,
    float3 e,
    float3 f,
    float3 h,
    float sharpness_strength,
    float normalization_point) {
  b /= normalization_point;
  d /= normalization_point;
  e /= normalization_point;
  f /= normalization_point;
  h /= normalization_point;

  // Immediate constants for peak range
  static const float2 kPeakConstants = float2(1.f, -4.f);
  static const float kFsrRcasLimit = 0.1875f;

  // Calculate luminance of center and neighbors
  float b_lum = renodx::color::y::from::BT709(b);
  float d_lum = renodx::color::y::from::BT709(d);
  float e_lum = renodx::color::y::from::BT709(e);
  float f_lum = renodx::color::y::from::BT709(f);
  float h_lum = renodx::color::y::from::BT709(h);

  float min4_lum = renodx::math::Min(b_lum, d_lum, f_lum, h_lum);
  float max4_lum = renodx::math::Max(b_lum, d_lum, f_lum, h_lum);

  float limited_max4_lum = min(max4_lum, 0.99f);

  float hit_min_lum = min4_lum * rcp(4.f * limited_max4_lum);
  float hit_max_lum = (kPeakConstants.x - limited_max4_lum) * rcp(4.f * min4_lum + kPeakConstants.y);
  float local_lobe = max(-hit_min_lum, hit_max_lum);

  float sharpness = (sharpness_strength == 0.f) ? 0.f : exp2(-(1.f - sharpness_strength));
  float lobe = max(-kFsrRcasLimit, min(local_lobe, 0.f)) * sharpness;

  // Noise detection
  float b_luma_2x = b_lum * 2.0f;
  float d_luma_2x = d_lum * 2.0f;
  float e_luma_2x = e_lum * 2.0f;
  float f_luma_2x = f_lum * 2.0f;
  float h_luma_2x = h_lum * 2.0f;

  float nz = 0.25f * b_luma_2x
             + 0.25f * d_luma_2x
             + 0.25f * f_luma_2x
             + 0.25f * h_luma_2x
             - e_luma_2x;

  float max_luma_2x = renodx::math::Max(renodx::math::Max(b_luma_2x, d_luma_2x, e_luma_2x), f_luma_2x, h_luma_2x);
  float min_luma_2x = renodx::math::Min(renodx::math::Min(b_luma_2x, d_luma_2x, e_luma_2x), f_luma_2x, h_luma_2x);

  nz = saturate(abs(nz) * rcp(max_luma_2x - min_luma_2x));
  nz = -0.5f * nz + 1.f;

  lobe *= nz;

  // Resolve, which needs the medium precision rcp approximation to avoid visible tonality changes
  float rcp_l = rcp(4.0f * lobe + 1.f);
  float pix_lum = ((b_lum + d_lum + h_lum + f_lum) * lobe + e_lum) * rcp_l;
  float3 sharpened = clamp(pix_lum / e_lum, 0.f, 4.f) * e;

  if (TONE_MAP_TYPE != 0.f) sharpened = min(1, sharpened);
  sharpened *= normalization_point;

  return sharpened;
}

// from Lilium
// RCAS - Robust Contrast Adaptive Sharpening
// Optimized version that accepts pre-calculated texture bounds
float3 ApplyLiliumRCASFromSamples(
    float3 b,
    float3 d,
    float3 e,
    float3 f,
    float3 h,
    float sharpness_strength) {
  float kDefaultNormalization = 100.f;
  if (TONE_MAP_TYPE != 0.f) {
    kDefaultNormalization = RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      kDefaultNormalization = renodx::color::correct::Gamma(kDefaultNormalization, true);
    }
  }

  return ApplyLiliumRCASFromSamples(b, d, e, f, h, sharpness_strength, kDefaultNormalization);
}

#endif  // RE4_SHARPENING_HLSLI_