#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_BICUBIC_UPSCALE_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_BICUBIC_UPSCALE_HLSLI_

// Faithful ports of the vanilla cardinal-cubic upscale front-ends: 16-tap separable
// (0xAFFFA4AB / 0x667C56AF) and 4-tap Y-only (0xEE044AAF family). Scale-agnostic via cb0[0]
// (.xy = source res px, .zw = texel 1/res). Returns the raw resampled texel (caller decodes:
// LUT vs sRGB). The game's remaining upscale row uses a non-interpolating basis instead — see
// bspline_upscale.hlsli.

// 4-tap Keys cubic-convolution weights with a = -1 (a cardinal spline of tension 1 - NOT
// Catmull-Rom, which is a = -0.5). Interpolating, and sums to exactly 1 for all t, which is why
// the vanilla shader's divide-by-sum is skipped here.
float4 BicubicWeights(float t) {
  const float t2 = t * t;
  const float t3 = t2 * t;
  return float4(
      -t3 + 2.f * t2 - t,   // tap -1
      t3 - 2.f * t2 + 1.f,  // tap  0
      -t3 + t2 + t,         // tap +1
      t3 - t2);             // tap +2
}

float3 SampleSceneBicubic(Texture2D<float4> tex, SamplerState smp, float2 uv, float4 cb0_0) {
  const float2 res = cb0_0.xy;    // source resolution (px)
  const float2 texel = cb0_0.zw;  // source texel size (1/res)

  // Sub-texel fraction at the resolved sample (texel-centered).
  const float2 f = frac(uv * res - 0.5f);

  // Base = the tap -1 UV; four columns/rows at +0,+1,+2,+3 texels.
  const float2 base = uv - (1.f + f) * texel;
  const float4 xs = base.x + float4(0.f, 1.f, 2.f, 3.f) * texel.x;
  const float4 ys = base.y + float4(0.f, 1.f, 2.f, 3.f) * texel.y;

  const float4 wx = BicubicWeights(f.x);
  const float4 wy = BicubicWeights(f.y);

  float3 result = 0.f;
  [unroll] for (int j = 0; j < 4; ++j) {
    float3 row = wx.x * tex.SampleLevel(smp, float2(xs.x, ys[j]), 0.f).rgb
                 + wx.y * tex.SampleLevel(smp, float2(xs.y, ys[j]), 0.f).rgb
                 + wx.z * tex.SampleLevel(smp, float2(xs.z, ys[j]), 0.f).rgb
                 + wx.w * tex.SampleLevel(smp, float2(xs.w, ys[j]), 0.f).rgb;
    result += wy[j] * row;
  }
  return max(0.f, result);
}

// Vertical-only sibling: same weights, 4 taps, X passed through untouched (the vanilla row leaves
// horizontal resampling to the sampler's bilinear filter and never reads the source width).
float3 SampleSceneCubicY(Texture2D<float4> tex, SamplerState smp, float2 uv, float4 cb0_0) {
  const float res_y = cb0_0.y;    // source height (px)
  const float texel_y = cb0_0.w;  // source texel height (1/height)

  const float f = frac(uv.y * res_y - 0.5f);
  const float base = uv.y - (1.f + f) * texel_y;  // center of texel i-1
  const float4 w = BicubicWeights(f);

  float3 result = w.x * tex.SampleLevel(smp, float2(uv.x, base), 0.f).rgb
                  + w.y * tex.SampleLevel(smp, float2(uv.x, base + texel_y), 0.f).rgb
                  + w.z * tex.SampleLevel(smp, float2(uv.x, base + 2.f * texel_y), 0.f).rgb
                  + w.w * tex.SampleLevel(smp, float2(uv.x, base + 3.f * texel_y), 0.f).rgb;
  return max(0.f, result);
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_BICUBIC_UPSCALE_HLSLI_
