#include "../common.hlsli"

bool ComposeUIAndSceneSCRGB(float3 scene_color, float4 ui_color_gamma, inout float4 output_color, float2 position) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  ui_color_gamma = max(0, ui_color_gamma);
  float ui_alpha = ui_color_gamma.a;

  if (RENODX_GAMMA_CORRECTION_UI == 0.f) {
    ui_color_gamma.rgb = renodx::color::gamma::Encode(renodx::color::srgb::Decode(ui_color_gamma.rgb));
  }

  // defer display mapping to compositing shader as PostProcessToneMap applies adjustments after tonemap
  scene_color = renodx::tonemap::neutwo::PerChannel(scene_color, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  // The game stores scene color with 1.0 representing 250 nits.
  // Rescale that reference so 1.0 represents the configured diffuse white.
  scene_color *= RENODX_DIFFUSE_WHITE_NITS;

  // blend UI and scene color in gamma space, then convert back to linear space
  scene_color /= RENODX_GRAPHICS_WHITE_NITS;
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color);
  float3 composited_color_gamma = ui_color_gamma.rgb + scene_color_gamma * (1.0 - ui_alpha);
  float3 composited_color = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  composited_color *= RENODX_GRAPHICS_WHITE_NITS;

  output_color = float4(composited_color / 80.f, ui_alpha);
  return true;
}
