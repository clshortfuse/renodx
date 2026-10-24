// Final output pass with Lanczos resampling (0x3998EA61, ps_5_0): the game uses it when it renders below 100%
// (seen with DLSS Ultra Performance at render scale 66%, input 1268x716 to 1920x1080). Same HDR10 PQ output as 0x4564BB42.
// Hand-decompiled from the DevKit dump: a 4x4 Lanczos filter built from the weights in t2 (a 256x1 lookup),
// over a main texture that stores half-float bits packed in an r10g10b10a2 texture.
#include "./common.hlsli"

Texture1D<float4> g_lanczosTexture : register(t2);

// Four filter taps for a fractional position, normalised to sum to 1.
float4 LanczosWeights(float t) {
  float4 w = (g_lanczosTexture.SampleLevel(g_pointSampler, t, 0) - 0.5f) * 2.f;
  return w / dot(w, 1.f);
}

float4 main(float4 vpos : SV_Position, float2 uv : TEXCOORD0) : SV_Target {
  const float2 position = uv - g_mainTexInvSize * 0.5f;
  const float2 fraction = frac(g_mainTexSize * position);
  const float2 origin = position - (fraction + 0.5f) * g_mainTexInvSize;
  const float4 weights_x = LanczosWeights(fraction.x);
  const float4 weights_y = LanczosWeights(fraction.y);

  float3 filtered = 0.f;
  [unroll]
  for (int row = 0; row < 4; row++) {
    float3 line_sum = 0.f;
    [unroll]
    for (int column = 0; column < 4; column++) {
      line_sum += weights_x[column] * g_mainTexture.SampleLevel(g_linearSampler, origin + float2(column, row) * g_mainTexInvSize, 0).rgb;
    }
    filtered += weights_y[row] * line_sum;
  }

  // Unpack: the texture holds the bits of half-float values scaled to 0..1 (g_unpackFactors.y converts back to the bit pattern).
  const float3 unpacked = f16tof32(uint3(saturate(filtered) * g_unpackFactors.y));
  return FinalPass(uv, max(0.f, unpacked * g_planeWeights.x));
}
