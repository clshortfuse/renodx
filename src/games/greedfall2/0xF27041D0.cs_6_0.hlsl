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
// Replacement: PQ-encode UI, composite with inverted alpha.

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
    // Vanilla
    float3 result = scene_pq * ui.a + ui.rgb;
    g_OutputRW[dtid.xy] = float4(result, 1.0f);
    return;
  }

  // Sharpening (CAS-style, applied in PQ space)
  float sharpness = shader_injection.custom_sharpening;
  if (sharpness > 0.f) {
    float2 texel = 1.f / float2(width, height);
    float3 n = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv + float2(0, -texel.y), 0).rgb;
    float3 s = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv + float2(0, texel.y), 0).rgb;
    float3 e = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv + float2(texel.x, 0), 0).rgb;
    float3 w = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv + float2(-texel.x, 0), 0).rgb;
    float3 blur = (n + s + e + w) * 0.25f;
    scene_pq += (scene_pq - blur) * sharpness;
    scene_pq = max(0, scene_pq);
  }

  // Vignette
  float vignette_strength = shader_injection.custom_vignette;
  if (vignette_strength > 0.f) {
    float2 vign_uv = uv * 2.f - 1.f;
    float vign = 1.f - dot(vign_uv, vign_uv) * vignette_strength;
    vign = saturate(vign);
    scene_pq *= vign;
  }

  // Film grain
  float grain_strength = shader_injection.custom_film_grain * 0.02f;
  if (grain_strength > 0.f) {
    float3 scene_linear = renodx::color::pq::DecodeSafe(scene_pq, 1.0f);
    scene_linear = renodx::effects::ApplyFilmGrain(scene_linear, uv, frac(scene_pq.r * 1000.f), grain_strength);
    scene_pq = renodx::color::pq::EncodeSafe(scene_linear, 1.0f);
  }

  // PQ-encode UI, inverted alpha composite
  float ui_scale = RENODX_GRAPHICS_WHITE_NITS / 203.f;
  float3 ui_linear = ui.rgb * ui_scale;
  float3 ui_pq = renodx::color::pq::EncodeSafe(ui_linear, 1.0f);

  // Inverted alpha composite
  float3 result = scene_pq * ui.a + ui_pq;
  result = saturate(result);

  g_OutputRW[dtid.xy] = float4(result, 1.0f);
}
