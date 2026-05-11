// Original shader 0xF27041D0: mainCSFinal compositing pass
// Original code (decompiled): applies sharpening, film grain, vignette, then composites UI.
// Key UI compositing logic uses INVERTED alpha:
//
//   float3 scene = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;
//   // ... sharpening, grain, vignette applied to scene ...
//   if (g_ApplyGUI) {
//     float4 ui = g_TextureUI.SampleLevel(g_Sampler_LinearClamp, uv, 0);
//     scene = scene * ui.a + ui.rgb;  // inverted alpha: a=1 → show scene, a<1 → UI present
//   }
//   // ... fadeScene and fadeGUI lerps ...
//   g_OutputRW[dtid.xy] = float4(scene, 1.0);
//
// Replacement: skip sharpening/grain/vignette, PQ-encode UI at controlled brightness,
// composite with inverted alpha.

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
  result = saturate(result);  // Clamp to [0,1] to prevent buffer overflow

  g_OutputRW[dtid.xy] = float4(result, 1.0f);
}
