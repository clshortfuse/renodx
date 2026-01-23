#ifndef RE7_2R_3R_VILLAGE_SHARPENING_HLSLI_
#define RE7_2R_3R_VILLAGE_SHARPENING_HLSLI_

#include "../shared.h"

// Bilinear sample of the scaled source position for a given output pixel.
float3 SampleScaledSource(Texture2D<float4> src_image, int2 output_coord, int2 tex_max, uint4 uv_scale_offset) {
  float2 scale = float2(asfloat(uv_scale_offset.xy));
  float2 offset = float2(asfloat(uv_scale_offset.zw));

  float2 src = scale * float2(output_coord) + offset;
  float2 base = floor(src);
  float2 frac = src - base;
  int2 base_int = int2(base);

  int2 p00 = clamp(base_int, int2(0, 0), tex_max);
  int2 p10 = clamp(base_int + int2(1, 0), int2(0, 0), tex_max);
  int2 p01 = clamp(base_int + int2(0, 1), int2(0, 0), tex_max);
  int2 p11 = clamp(base_int + int2(1, 1), int2(0, 0), tex_max);

  float3 c00 = src_image.Load(int3(p00, 0)).rgb;
  float3 c10 = src_image.Load(int3(p10, 0)).rgb;
  float3 c01 = src_image.Load(int3(p01, 0)).rgb;
  float3 c11 = src_image.Load(int3(p11, 0)).rgb;

  float3 top = lerp(c00, c10, frac.x);
  float3 bottom = lerp(c01, c11, frac.x);
  return lerp(top, bottom, frac.y);
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

  return sharpened * normalization_point;
}

// RCAS using bilinear-scaled source samples (avoids truncating scaled coords to int).
float3 ApplyLiliumRCASScaled(Texture2D<float4> src_image, int2 output_coord, float sharpness_strength, int2 tex_max, uint4 uv_scale_offset) {
  static const float kNormalization = 100.0f;

  float3 b = SampleScaledSource(src_image, output_coord + int2(0, -1), tex_max, uv_scale_offset);
  float3 d = SampleScaledSource(src_image, output_coord + int2(-1, 0), tex_max, uv_scale_offset);
  float3 e = SampleScaledSource(src_image, output_coord, tex_max, uv_scale_offset);
  float3 f = SampleScaledSource(src_image, output_coord + int2(1, 0), tex_max, uv_scale_offset);
  float3 h = SampleScaledSource(src_image, output_coord + int2(0, 1), tex_max, uv_scale_offset);

  return ApplyLiliumRCASFromSamples(b, d, e, f, h, sharpness_strength, kNormalization);
}

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
  float3 b = texture.Load(int3(clamp(coord + int2(0, -1), int2(0, 0), tex_max), 0)).rgb;
  float3 d = texture.Load(int3(clamp(coord + int2(-1, 0), int2(0, 0), tex_max), 0)).rgb;
  float3 e = texture.Load(int3(clamp(coord, int2(0, 0), tex_max), 0)).rgb;
  float3 f = texture.Load(int3(clamp(coord + int2(1, 0), int2(0, 0), tex_max), 0)).rgb;
  float3 h = texture.Load(int3(clamp(coord + int2(0, 1), int2(0, 0), tex_max), 0)).rgb;

  return ApplyLiliumRCASFromSamples(b, d, e, f, h, sharpness_strength, normalization_point);
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
  static const float kDefaultNormalization = 100.0f;
  return ApplyLiliumRCAS(texture, coord, sharpness_strength, kDefaultNormalization);
}

// Optimized convenience wrapper that calculates texture dimensions once
float3 ApplyLiliumRCAS(
    Texture2D<float4> texture,
    int2 coord,
    float sharpness_strength,
    int2 tex_max) {
  static const float kDefaultNormalization = 100.0f;
  return ApplyLiliumRCAS(texture, coord, sharpness_strength, kDefaultNormalization, tex_max);
}

// Helper function for RE3's 4-pixel-per-thread compute shader pattern
// This function applies RCAS to 4 pixels at once using the RE3 coordinate scheme
void ApplyLiliumRCAS_RE3_Pattern(
    Texture2D<float4> src_texture,
    RWTexture2D<float4> output_texture,
    int2 base_coord,
    int2 offset_coord,
    float sharpness_strength) {
  static const float kDefaultNormalization = 100.0f;

  // Calculate texture dimensions once for all 4 pixels
  uint tex_width, tex_height;
  src_texture.GetDimensions(tex_width, tex_height);
  int2 tex_max = int2(tex_width - 1, tex_height - 1);

  // Process all 4 pixels in RE3's pattern using optimized function:
  output_texture[base_coord] =
      float4(ApplyLiliumRCAS(src_texture, base_coord, sharpness_strength, kDefaultNormalization, tex_max), 1.f);

  output_texture[int2(offset_coord.x, base_coord.y)] =
      float4(ApplyLiliumRCAS(src_texture, int2(offset_coord.x, base_coord.y), sharpness_strength, kDefaultNormalization, tex_max), 1.f);

  output_texture[offset_coord] =
      float4(ApplyLiliumRCAS(src_texture, offset_coord, sharpness_strength, kDefaultNormalization, tex_max), 1.f);

  output_texture[int2(base_coord.x, offset_coord.y)] =
      float4(ApplyLiliumRCAS(src_texture, int2(base_coord.x, offset_coord.y), sharpness_strength, kDefaultNormalization, tex_max), 1.f);
}

#endif  // RE7_2R_3R_VILLAGE_SHARPENING_HLSLI_
