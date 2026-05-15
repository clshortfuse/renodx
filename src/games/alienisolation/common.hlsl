#include "./shared.h"

float4 UIScale(float4 color) {
  color = saturate(color);
  color.rgb = renodx::color::gamma::Decode(color.rgb, 2.2f);
  color.rgb *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  color.rgb = renodx::color::gamma::Encode(color.rgb, 2.2f);

  return color;
}

float4 FinalizeOutput(float4 color) {
  color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2f);
  color.rgb *= RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;

  return color;
}

float3 ApplyCustomFilmGrain(float3 color, float2 uv) {
  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    if (CUSTOM_GRAIN_TYPE == 1.f) {  // B&W
      color = renodx::effects::ApplyFilmGrain(
          color, uv,
          CUSTOM_RANDOM,
          CUSTOM_GRAIN_STRENGTH * .04f);
    } else if (CUSTOM_GRAIN_TYPE == 2.f) {  // Colored
      color = renodx::effects::ApplyFilmGrainColored(
          color, uv,
          CUSTOM_RANDOM,
          CUSTOM_GRAIN_STRENGTH * .04f);
    }
  }
  return color;
}

namespace Lilium {
namespace RCAS {

#define LILIUM_RCAS_ENABLE_NOISE_REMOVAL 1u
#define LILIUM_RCAS_ENABLE_NORMALIZATION 1u

// This is set at the limit of providing unnatural results for sharpening.
// 0.25f - (1.f / 16.f)
#define LILIUM_RCAS_LIMIT 0.1875f

struct Neighborhood {
  float3 b;
  float3 d;
  float3 e;
  float3 f;
  float3 h;
};

Neighborhood SampleNeighborhood(
    float3 center_color,
    float2 tex_coord,
    uint width,
    uint height,
    Texture2D<float4> SamplerFrameBuffer_TEX,
    SamplerState SamplerFrameBuffer_SMP_s) {
  float2 texel_size = 1.0 / float2(width, height);

  Neighborhood samples;

  // Algorithm uses minimal 3x3 pixel neighborhood.
  //    b
  //  d e f
  //    h
  samples.b = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(0, -1) * texel_size, 0).rgb;
  samples.d = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(-1, 0) * texel_size, 0).rgb;
  samples.e = center_color;
  samples.f = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(1, 0) * texel_size, 0).rgb;
  samples.h = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(0, 1) * texel_size, 0).rgb;

  return samples;
}

// from Lilium
// RCAS - Robust Contrast Adaptive Sharpening
float3 ApplyCore(Neighborhood samples, float sharpening, float normalization_value = 1.f) {
  float3 b = samples.b;
  float3 d = samples.d;
  float3 e = samples.e;
  float3 f = samples.f;
  float3 h = samples.h;

#if LILIUM_RCAS_ENABLE_NORMALIZATION
  b /= normalization_value;
  d /= normalization_value;
  e /= normalization_value;
  f /= normalization_value;
  h /= normalization_value;
#endif

  // Immediate constants for peak range.
  static const float2 peakC = float2(1.f, -4.f);

  // Calculate luminance of center and neighbors
  float bLum = renodx::color::yf::from::BT709(b);
  float dLum = renodx::color::yf::from::BT709(d);
  float eLum = renodx::color::yf::from::BT709(e);
  float fLum = renodx::color::yf::from::BT709(f);
  float hLum = renodx::color::yf::from::BT709(h);

  // Min and max of ring.
  float min4Lum = renodx::math::Min(bLum, dLum, fLum, hLum);
  float max4Lum = renodx::math::Max(bLum, dLum, fLum, hLum);

  // 0.99 found through testing -> see my latest desmos or https://www.desmos.com/calculator/4dyqhishpl
  // this helps reducing massive overshoot that would happen otherwise
  // normal CAS applies a limiter too so that there is no overshoot
  float limited_max4Lum = min(max4Lum, 0.99f);

  float hitMinLum = min4Lum
                    * rcp(4.f * limited_max4Lum);

  float hitMaxLum = (peakC.x - limited_max4Lum)
                    * rcp(4.f * min4Lum + peakC.y);

  float localLobe = max(-hitMinLum, hitMaxLum);

  float lobe = max(float(-LILIUM_RCAS_LIMIT),
                   min(localLobe, 0.f))
               * sharpening;

#if LILIUM_RCAS_ENABLE_NOISE_REMOVAL
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

  float maxLuma2x = renodx::math::Max(renodx::math::Max(bLuma2x, dLuma2x, eLuma2x), fLuma2x, hLuma2x);
  float minLuma2x = renodx::math::Min(renodx::math::Min(bLuma2x, dLuma2x, eLuma2x), fLuma2x, hLuma2x);

  nz = saturate(abs(nz) * rcp(maxLuma2x - minLuma2x));
  nz = -0.5f * nz + 1.f;

  lobe *= nz;
#endif

  // Resolve, which needs the medium precision rcp approximation to avoid visible tonality changes.
  float rcpL = rcp(4.f * lobe + 1.f);

  float pixLum = ((bLum + dLum + hLum + fLum) * lobe + eLum) * rcpL;
  float3 pix = clamp((pixLum / eLum), 0.f, 4.f) * e;

#if LILIUM_RCAS_ENABLE_NORMALIZATION
  pix *= normalization_value;
#endif

  return pix;
}

float3 ApplyCore(float3 b, float3 d, float3 e, float3 f, float3 h, float sharpening, float normalization_value = 1.f) {
  Neighborhood samples;
  samples.b = b;
  samples.d = d;
  samples.e = e;
  samples.f = f;
  samples.h = h;
  return ApplyCore(samples, sharpening, normalization_value);
}

float3 Apply(
    float3 center_color, float2 tex_coord,
    Texture2D<float4> SamplerFrameBuffer_TEX, SamplerState SamplerFrameBuffer_SMP_s, float normalization_value = 1.f) {
  if (CUSTOM_SHARPENING == 0) return center_color;  // Skip sharpening if amount is zero

  uint width, height;
  SamplerFrameBuffer_TEX.GetDimensions(width, height);
  Neighborhood samples = SampleNeighborhood(center_color, tex_coord, width, height, SamplerFrameBuffer_TEX, SamplerFrameBuffer_SMP_s);
  return ApplyCore(samples, CUSTOM_SHARPENING, normalization_value);
}

}  // namespace RCAS
}  // namespace Lilium
