#ifndef SRC_GAMES_SNIPERELITE5_FXAA_HLSLI_
#define SRC_GAMES_SNIPERELITE5_FXAA_HLSLI_

// RenoDX: bilinear fetch where brighter-than-SDR-white taps are down-weighted.
float4 SampleHighlightWeighted(float2 uv) {
  uint width, height;
  g_xPostToneMapFrameBufferTexture.GetDimensions(width, height);
  float2 position = uv * float2(width, height) - 0.5f;
  int2 base = int2(floor(position));
  float2 f = position - float2(base);
  int2 last = int2(width, height) - 1;
  float4 sum = 0.f;
  float weightSum = 0.f;
  [unroll]
  for (int i = 0; i < 4; i++) {
    int2 offset = int2(i & 1, i >> 1);
    float4 tap = g_xPostToneMapFrameBufferTexture.Load(int3(clamp(base + offset, int2(0, 0), last), 0));
    float2 b = select(offset == 1, f, 1.f - f);
    float w = b.x * b.y * pow(max(1.f, renodx::color::y::from::BT709(tap.rgb)), -CUSTOM_AA_HIGHLIGHT_WEIGHT);
    sum += tap * w;
    weightSum += w;
  }
  return sum / max(weightSum, 1e-6f);
}

#endif  // SRC_GAMES_SNIPERELITE5_FXAA_HLSLI_
