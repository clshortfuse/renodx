#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_BSPLINE_UPSCALE_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_BSPLINE_UPSCALE_HLSLI_

// Faithful port of the vanilla 4-bilinear-tap upscale front-end (0x4BCF53E3 family): a uniform
// cubic B-spline evaluated with the Sigg-Hadwiger trick, where each pair of adjacent taps is folded
// into one offset bilinear fetch. Unlike bicubic_upscale.hlsli's cardinal cubic, this basis is
// non-interpolating (soft, ringing-free) and the taps do NOT land on texel centers - the sampler
// must be bilinear for the fold to work at all.
// Scale-agnostic via cb0[0] (.xy = source res px, .zw = texel 1/res).

// Uniform cubic B-spline basis (Mitchell B=1, C=0) for t in [0,1). Sums to 1; no normalization
// needed, and the vanilla shader does not do one either.
void BSplineWeights(float t, out float wm1, out float w0, out float w1, out float w2) {
  const float t2 = t * t;
  const float t3 = t2 * t;
  wm1 = (1.f / 6.f) * (1.f - 3.f * t + 3.f * t2 - t3);  // (1-t)^3 / 6
  w0 = (2.f / 3.f) - t2 + 0.5f * t3;
  w1 = (1.f / 6.f) + 0.5f * t + 0.5f * t2 - 0.5f * t3;
  w2 = (1.f / 6.f) * t3;
}

float4 SampleSceneFastBSpline(Texture2D<float4> tex, SamplerState smp, float2 uv, float4 cb0_0) {
  const float2 res = cb0_0.xy;    // source resolution (px)
  const float2 texel = cb0_0.zw;  // source texel size (1/res)

  const float2 f = frac(uv * res - 0.5f);

  float2 wm1;
  float2 w0;
  float2 w1;
  float2 w2;
  BSplineWeights(f.x, wm1.x, w0.x, w1.x, w2.x);
  BSplineWeights(f.y, wm1.y, w0.y, w1.y, w2.y);

  // Fold taps {-1,0} and {1,2} into one bilinear fetch each; g is the pair weight, d the offset.
  const float2 g0 = wm1 + w0;
  const float2 g1 = w1 + w2;
  const float2 d_a = 1.f + f - w0 / g0;
  const float2 d_b = 1.f - f + w2 / g1;

  // The offset signs are mirrored versus the canonical Sigg-Hadwiger placement (the g0 pair belongs
  // at uv - d_a, not +). Vanilla ships it this way in both axes: the kernel stays unbiased so the
  // image does not shift, it is just blurrier than a true B-spline, and it coincides with one
  // exactly at f = 0 and f = 0.5. Reproduced deliberately - "correcting" it stops matching vanilla.
  const float2 uv_a = uv + d_a * texel;
  const float2 uv_b = uv - d_b * texel;

  const float4 tap_bb = tex.SampleLevel(smp, uv_b, 0.f);
  const float4 tap_ab = tex.SampleLevel(smp, float2(uv_a.x, uv_b.y), 0.f);
  const float4 tap_ba = tex.SampleLevel(smp, float2(uv_b.x, uv_a.y), 0.f);
  const float4 tap_aa = tex.SampleLevel(smp, uv_a, 0.f);

  const float4 col_b = lerp(tap_bb, tap_ba, g0.y);
  const float4 col_a = lerp(tap_ab, tap_aa, g0.y);
  return max(0.f, lerp(col_b, col_a, g0.x));  // RGBA: this row carries scene alpha
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_BSPLINE_UPSCALE_HLSLI_
