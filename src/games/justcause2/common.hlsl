#ifndef SRC_GAMES_JUSTCAUSE2_COMMON_HLSL_
#define SRC_GAMES_JUSTCAUSE2_COMMON_HLSL_

#include "./shared.h"

// The game encodes with sqrt(), then samples through an sRGB view in
// subsequent passes. Keep that combination: gamma 2.0 is not sRGB.
float3 Jc2CompositeIntermediate(float3 color) {
  float3 encoded = sqrt(max(color, 0.f));
  if (shader_injection.swap_chain_output_preset == 0.f || shader_injection.tone_map_type == 0.f) {
    encoded = saturate(encoded);
  }
  // The upgraded copy destination is linear FP16. Decode before filtering,
  // reproducing the original sRGB SRV instead of decoding bilinear samples.
  return renodx::color::srgb::DecodeSafe(encoded);
}

float3 Jc2FinalScene(float3 color) {
  float3 encoded = sqrt(max(color, 0.f));
  // Follow the effective display mode, including failed DXGI mode changes.
  if (shader_injection.swap_chain_output_preset == 0.f) return saturate(encoded);

  // This is the game's scene signal before its last UNORM write and before HUD.
  // Forward transfer decoding preserves its original SDR contrast response.
  float3 scene_linear = renodx::color::srgb::DecodeSafe(encoded);
  if (shader_injection.tone_map_type == 0.f) {
    scene_linear = saturate(scene_linear);
  } else {
    scene_linear *= shader_injection.exposure;
    scene_linear = 0.18f * pow(max(scene_linear, 0.f) / 0.18f, shader_injection.contrast);
    float luminance = dot(scene_linear, float3(0.2126f, 0.7152f, 0.0722f));
    scene_linear = max(lerp(luminance.xxx, scene_linear, shader_injection.saturation), 0.f);
  }

  // Extend the original hard-clip presentation. Values below reference white
  // stay unchanged; only highlights roll off to the requested display peak.
  float peak = max(shader_injection.peak_white_nits / shader_injection.diffuse_white_nits, 1.f);
  float maximum = max(scene_linear.r, max(scene_linear.g, scene_linear.b));
  if (maximum > 1.f) {
    float mapped = 1.f;
    if (peak > 1.0001f) {
      mapped += (peak - 1.f) * (1.f - exp(-(maximum - 1.f) / (peak - 1.f)));
    }
    scene_linear *= mapped / maximum;
  }

  // Unmodified HUD draws remain sRGB shaped; the output proxy scales them
  // by UI white while this scene scales independently by game white.
  scene_linear *= shader_injection.diffuse_white_nits / shader_injection.graphics_white_nits;
  return renodx::color::srgb::EncodeSafe(scene_linear);
}

#endif
