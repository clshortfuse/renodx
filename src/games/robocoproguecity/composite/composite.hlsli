#include "../shared.h"

float4 OutputscRGB(float4 color) {
  return float4(color.rgb *= RENODX_DIFFUSE_WHITE_NITS / 80.f, color.a);
}

float4 OutputHDR10(float4 color) {
  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color.rgb), RENODX_DIFFUSE_WHITE_NITS);
  return float4(pq_color, color.a);
}

bool HandleUICompositing(float4 ui_color_gamma, float4 scene_color_pq, inout float4 output_color, uint output_mode = 0u) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  float ui_alpha = ui_color_gamma.a;

  float3 ui_color_linear;
  // linearize UI and scale to ratio of scene brightness
  if (RENODX_GAMMA_CORRECTION_UI) {
    ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);
  } else {
    ui_color_linear = renodx::color::srgb::DecodeSafe(ui_color_gamma.rgb);
  }
  ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

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

  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);
  // blend in gamma, choose between sRGB and gamma based on setting
  float3 scene_color_gamma;
  if (RENODX_GAMMA_CORRECTION) {
    scene_color_gamma = renodx::color::srgb::EncodeSafe(scene_color_linear);
  } else {
    scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);
  }
  float3 composited_color_gamma = ui_color_gamma.rgb + scene_color_gamma * (1.0 - ui_alpha);
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);

  // return ui alpha for better FG support
  if (output_mode == 0u) {  // HDR10
    output_color = OutputHDR10(float4(composited_color_linear, ui_alpha));
  } else {  // scRGB
    output_color = OutputscRGB(float4(composited_color_linear, ui_alpha));
  }

  return true;
}

bool HandleIntermediateCompositing(float4 ui_color_gamma, float4 scene_color_pq, inout float4 output_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  float ui_alpha = ui_color_gamma.a;

  // linearize UI and scale to ratio of scene brightness
  float3 ui_color_linear;
  if (RENODX_GAMMA_CORRECTION_UI) {
    ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb) * RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  } else {
    ui_color_linear = renodx::color::srgb::DecodeSafe(ui_color_gamma.rgb) * RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  }
  ui_color_linear = renodx::color::bt2020::from::BT709(ui_color_linear);

  // linearize scene, normalize brightness
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color_pq.rgb, RENODX_DIFFUSE_WHITE_NITS);

  ui_color_gamma.rgb = renodx::color::srgb::EncodeSafe(ui_color_linear.rgb);
  float3 scene_color_gamma = renodx::color::srgb::EncodeSafe(scene_color_linear);

  float3 composited_color_gamma = ui_color_linear + scene_color_linear * (1.0 - ui_alpha);
  float3 composited_color_linear = renodx::color::srgb::DecodeSafe(composited_color_gamma);

  output_color = float4(composited_color_linear, ui_alpha);

  return true;
}
