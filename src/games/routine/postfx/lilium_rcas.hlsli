#include "./postfx.hlsli"

// from Lilium
// RCAS - Robust Contrast Adaptive Sharpening
float3 ApplyLiliumRCAS(
    float2 tex_coord,
    Texture2D<float4> scene_texture, SamplerState scene_sampler) {
  if (CUSTOM_SHARPNESS == 0.f) return scene_texture.SampleLevel(scene_sampler, tex_coord, 0).rgb;

#define ENABLE_NOISE_REMOVAL           1u  // Always good to be enabled
#define ENABLE_NORMALIZATION           1u
#define SHARPENING_NORMALIZATION_POINT (RENODX_TONE_MAP_TYPE == 0.f) ? 1.f : RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS

  uint width, height;
  scene_texture.GetDimensions(width, height);
  float2 texel_size = 1.0 / float2(width, height);

  // Algorithm uses minimal 3x3 pixel neighborhood.
  //    b
  //  d e f
  //    h
  float3 b = scene_texture.SampleLevel(scene_sampler, tex_coord + float2(0, -1) * texel_size, 0).rgb;
  float3 d = scene_texture.SampleLevel(scene_sampler, tex_coord + float2(-1, 0) * texel_size, 0).rgb;
  float3 e = scene_texture.SampleLevel(scene_sampler, tex_coord, 0).rgb;
  float3 f = scene_texture.SampleLevel(scene_sampler, tex_coord + float2(1, 0) * texel_size, 0).rgb;
  float3 h = scene_texture.SampleLevel(scene_sampler, tex_coord + float2(0, 1) * texel_size, 0).rgb;

#if 1
  b = ScaleSceneInverse(b);
  d = ScaleSceneInverse(d);
  e = ScaleSceneInverse(e);
  f = ScaleSceneInverse(f);
  h = ScaleSceneInverse(h);
#endif

#if 1
  b = renodx::color::srgb::DecodeSafe(b);
  d = renodx::color::srgb::DecodeSafe(d);
  e = renodx::color::srgb::DecodeSafe(e);
  f = renodx::color::srgb::DecodeSafe(f);
  h = renodx::color::srgb::DecodeSafe(h);
#endif

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
  float bLum = renodx::color::y::from::BT709(b);
  float dLum = renodx::color::y::from::BT709(d);
  float eLum = renodx::color::y::from::BT709(e);
  float fLum = renodx::color::y::from::BT709(f);
  float hLum = renodx::color::y::from::BT709(h);

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

// This is set at the limit of providing unnatural results for sharpening.
// 0.25f - (1.f / 16.f)
#define FSR_RCAS_LIMIT 0.1875f

  float lobe = max(float(-FSR_RCAS_LIMIT),
                   min(localLobe, 0.f))
               * CUSTOM_SHARPNESS;

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

#if ENABLE_NORMALIZATION
  pix *= SHARPENING_NORMALIZATION_POINT;
#endif

#if 1
  pix = renodx::color::srgb::EncodeSafe(pix);
#endif

  return pix;
}
