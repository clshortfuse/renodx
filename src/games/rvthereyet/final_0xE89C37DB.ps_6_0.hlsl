// Last scene pass before the UI: vignette and tint on the tonemapped image, written to the swapchain.
// Translated from the DXIL of the original shader (the DevKit cannot decompile it).
#include "./common.hlsli"

Texture2D<float4> t0 : register(t0);

SamplerState s0 : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[6];
};

cbuffer cb1 : register(b1) {
  float4 cb1[4];
};

float4 main(noperspective float4 position : SV_Position) : SV_Target {
  const float2 screen_uv = (position.xy - float2(asuint(cb0[5].xy))) * cb0[5].zw;
  const float4 scene = t0.Sample(s0, screen_uv * cb0[0].zw + cb0[0].xy);

  const float2 edge_distance = max(abs(screen_uv - 0.5f) - cb1[0].xy, 0.f);
  const float vignette = saturate(cb1[0].w * (1.f - saturate(cb1[0].z * length(edge_distance))));

  float3 color = scene.rgb + (cb1[1].rgb - scene.rgb) * (1.f - vignette) * cb1[1].w;
  color = lerp(color, cb1[2].yzw, cb1[2].x);

  // RenoDX: negative channels carry colors outside BT.709, so only clip them for vanilla
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = max(color, 0.f);
  }
  return float4(color, scene.a);
}
