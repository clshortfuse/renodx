#ifndef SRC_GAMES_GUARDIANSOFTHEGALAXY_HEX_DOF_HLSLI_
#define SRC_GAMES_GUARDIANSOFTHEGALAXY_HEX_DOF_HLSLI_

// Requires shared.h, a g_vUvScale cbuffer field (zw = UV scale), and MaterialSamplers declared before inclusion.

// CUSTOM: original 5 taps per axis are spaced one CoC stride apart, so large CoC (1.5 at half res here) leaves gaps
// of several pixels and produces ribbed stripes. Taps now scale with the gather length (<= ~1 px spacing, capped at 32).
float3 HexGatherAxis(Texture2D<float4> tex, float2 centre, float2 dir, float centreCoC) {
  int tapCount = clamp((int)ceil(5.f * length(dir)), 5, max(5, (int)RENODX_BOKEH_MAX_SAMPLES));
  float3 colourSum = 0.f;
  float weightSum = 0.f;
  [loop]
  for (int k = 0; k < tapCount; k++) {
    float offset = ((float)k + 0.5f) * 5.f / (float)tapCount;
    float4 tap = tex.SampleLevel(MaterialSamplers[11u], (centre + offset * dir) * g_vUvScale.zw, 0.0f);
    float weight = offset < 1.f ? 1.f : float(centreCoC <= tap.w);
    colourSum += tap.xyz * weight;
    weightSum += weight;
  }
  return colourSum / max(weightSum, 1e-4f);
}

#endif  // SRC_GAMES_GUARDIANSOFTHEGALAXY_HEX_DOF_HLSLI_
