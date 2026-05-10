// Original shader 0xF27041D0: mainCSFinal compositing pass
// Original UI compositing uses INVERTED alpha:
//   result = scene * ui.a + ui.rgb
//   alpha=1 in empty areas (scene passes through)
//   alpha<1 in UI areas (scene dimmed, UI added)

#include "./shared.h"

Texture2D<float4> g_Texture : register(t2);
Texture2D<float4> g_TextureUI : register(t3);
SamplerState g_Sampler_LinearClamp : register(s1);
RWTexture2D<float4> g_OutputRW : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 dtid : SV_DispatchThreadID) {
  uint width, height;
  g_OutputRW.GetDimensions(width, height);
  if (dtid.x >= width || dtid.y >= height) return;

  float2 uv = (float2(dtid.xy) + 0.5f) / float2(width, height);

  // Scene is PQ-encoded from 0x6DE32B48
  float3 scene_pq = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;
  float4 ui = g_TextureUI.SampleLevel(g_Sampler_LinearClamp, uv, 0);

  if (RENODX_TONE_MAP_TYPE == 0) {
    // Vanilla: standard inverted alpha composite
    float3 result = scene_pq * ui.a + ui.rgb;
    g_OutputRW[dtid.xy] = float4(result, 1.0f);
    return;
  }

  // HDR path: PQ-encode UI at controlled brightness, then inverted alpha composite
  float ui_scale = RENODX_GRAPHICS_WHITE_NITS / 203.f;
  float3 ui_linear = ui.rgb * ui_scale;
  float3 ui_pq = renodx::color::pq::EncodeSafe(ui_linear, 1.0f);

  // Inverted alpha: scene * alpha + ui_pq
  float3 result = scene_pq * ui.a + ui_pq;

  g_OutputRW[dtid.xy] = float4(result, 1.0f);
}
