#include "./shared.h"

float4 OutputscRGB(float4 color) {
  return float4(color.rgb *= RENODX_DIFFUSE_WHITE_NITS / 80.f, color.a);
}

float4 OutputHDR10(float4 color) {
  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color.rgb), RENODX_DIFFUSE_WHITE_NITS);
  return float4(pq_color, color.a);
}

bool HandleUICompositing(float4 ui_color_linear, float4 scene_color_pq, inout float4 output_color, bool use_hdr10 = true) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  float ui_alpha = ui_color_linear.a;

  // linearize UI and scale to ratio of scene brightness
  if (RENODX_GAMMA_CORRECTION_UI) {
    ui_color_linear.rgb = renodx::color::gamma::DecodeSafe(ui_color_linear.rgb);
  } else {
    ui_color_linear.rgb = renodx::color::srgb::DecodeSafe(ui_color_linear.rgb);
  }
  ui_color_linear.rgb *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  // linearize scene, normalize brightness, convert to BT.709
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color_pq.rgb, RENODX_DIFFUSE_WHITE_NITS);
#if 0
  if (RENODX_TONE_MAP_TYPE == 2.f || RENODX_TONE_MAP_TYPE == 3.f) {
    float peak_clamp = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION) peak_clamp = renodx::color::correct::Gamma(peak_clamp, true);
    scene_color_linear = min(peak_clamp, scene_color_linear);
  } else if (RENODX_TONE_MAP_TYPE == 4.f) {
    scene_color_linear = saturate(scene_color_linear);
  }
#endif
  scene_color_linear = renodx::color::bt709::from::BT2020(scene_color_linear);

  float3 ui_color_gamma = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);
  // blend in gamma, choose between sRGB and gamma based on setting
  float3 scene_color_gamma;
  if (RENODX_GAMMA_CORRECTION) {
    scene_color_gamma = renodx::color::srgb::EncodeSafe(scene_color_linear);
  } else {
    scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);
  }
  float3 composited_color_gamma = ui_color_gamma + scene_color_gamma * (1.0 - ui_alpha);

  // linearize and encode to pq
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);

  // return ui alpha for better FG support
  if (use_hdr10) {
    output_color = OutputHDR10(float4(composited_color_linear, ui_alpha));
  } else {
    output_color = OutputscRGB(float4(composited_color_linear, ui_alpha));
  }

  return true;
}
