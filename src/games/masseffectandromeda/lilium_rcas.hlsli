#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_LILIUM_RCAS_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_LILIUM_RCAS_HLSLI_

// Lilium HDR RCAS (FSR Robust Contrast Adaptive Sharpening) for MEA.
// center_color = LUT-linearized scene (1.0 ~= diffuse white). Neighbors linearize through the same
// SampleOutputLut + scene_scale as the center, so sharpness 0 is a pure passthrough. Scene is
// diffuse-relative, so luma is normalized by the HDR headroom ratio for the FSR math (else min4 > 1
// silently disables sharpening). Caller gates to Vanilla+ AND the swapchain present.
// Requires shared.h (renodx + CUSTOM_SHARPNESS + injectedData) first.

#define MEA_RCAS_LIMIT 0.1875f  // FSR_RCAS_LIMIT: limit of natural-looking sharpening
#define MEA_RCAS_EPS 1e-6f      // denominator guard (black / flat neighborhoods -> 0 * rcp(0) = NaN)

// One RCAS tap: scene sample -> scene_scale -> shared SampleOutputLut -> BT.709 luma (same path as
// the present center, so they can't drift).
float RcasTapLuma(
    Texture2D<float4> scene_tex, SamplerState scene_smp,
    Texture1D<float4> lut_tex, SamplerState lut_smp,
    float2 uv, float scene_scale) {
  const float3 c = SampleOutputLut(
      lut_tex, lut_smp, max(0.f, scene_tex.SampleLevel(scene_smp, uv, 0.f).rgb * scene_scale));
  return renodx::color::y::from::BT709(max(0.f, c));
}

float3 ApplyRCAS(
    float3 center_color, float2 tex_coord,
    Texture2D<float4> scene_tex, SamplerState scene_smp,
    Texture1D<float4> lut_tex, SamplerState lut_smp,
    float scene_scale) {
  if (CUSTOM_SHARPNESS == 0.f) return center_color;

  uint width, height;
  scene_tex.GetDimensions(width, height);
  const float2 texel_size = 1.f / float2(width, height);

  // Normalize luma to ~[0,1] by the HDR headroom ratio so the FSR math behaves above diffuse white.
  // RCAS is scale-covariant (lobe + blend are pure luma ratios), so the un-normalized center blends directly.
  const float rcp_norm = rcp(max(injectedData.toneMapPeakNits / max(injectedData.toneMapGameNits, 1.f), 1.f));

  // Minimal 3x3 cross:  b / d e f / h. All neighbors go through the one shared linearizer (RcasTapLuma).
  const float bLum = RcasTapLuma(scene_tex, scene_smp, lut_tex, lut_smp, tex_coord + float2(0.f, -1.f) * texel_size, scene_scale) * rcp_norm;
  const float dLum = RcasTapLuma(scene_tex, scene_smp, lut_tex, lut_smp, tex_coord + float2(-1.f, 0.f) * texel_size, scene_scale) * rcp_norm;
  const float eLum = renodx::color::y::from::BT709(center_color) * rcp_norm;
  const float fLum = RcasTapLuma(scene_tex, scene_smp, lut_tex, lut_smp, tex_coord + float2(1.f, 0.f) * texel_size, scene_scale) * rcp_norm;
  const float hLum = RcasTapLuma(scene_tex, scene_smp, lut_tex, lut_smp, tex_coord + float2(0.f, 1.f) * texel_size, scene_scale) * rcp_norm;

  const float min4 = min(min(min(bLum, dLum), fLum), hLum);
  const float max4 = max(max(max(bLum, dLum), fLum), hLum);

  // 0.99 limiter bounds overshoot; eps-guard the black-neighborhood denominator (4*max4 -> 0 -> NaN).
  const float limited_max4 = min(max4, 0.99f);
  const float hitMin = min4 * rcp(max(4.f * limited_max4, MEA_RCAS_EPS));
  // Guard the min4==1 singularity (denom 0 -> rcp inf) sign-preservingly: min4 can be <1 or >1, so
  // only nudge sub-eps magnitudes; non-singular pixels stay bit-identical.
  float hitMaxDenom = 4.f * min4 - 4.f;
  hitMaxDenom = (abs(hitMaxDenom) < MEA_RCAS_EPS) ? -MEA_RCAS_EPS : hitMaxDenom;
  const float hitMax = (1.f - limited_max4) * rcp(hitMaxDenom);
  float lobe = max(-MEA_RCAS_LIMIT, min(max(-hitMin, hitMax), 0.f)) * CUSTOM_SHARPNESS;

  // Noise removal: damp the lobe where the center is a local outlier (grain). Eps-guard the
  // flat-region denominator (max - min over the 5 taps -> 0 -> NaN).
  float nz = 0.25f * (bLum + dLum + fLum + hLum) - eLum;
  const float maxLuma = max(max(max(bLum, dLum), max(eLum, fLum)), hLum);
  const float minLuma = min(min(min(bLum, dLum), min(eLum, fLum)), hLum);
  nz = saturate(abs(nz) * rcp(max(maxLuma - minLuma, MEA_RCAS_EPS)));
  nz = -0.5f * nz + 1.f;
  lobe *= nz;

  const float rcpL = rcp(4.f * lobe + 1.f);
  const float pixLum = ((bLum + dLum + hLum + fLum) * lobe + eLum) * rcpL;
  // Norm-independent luma ratio applied to the un-normalized center (norm cancels in the ratio).
  return clamp(renodx::math::DivideSafe(pixLum, eLum, 1.f), 0.f, 4.f) * center_color;
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_LILIUM_RCAS_HLSLI_
