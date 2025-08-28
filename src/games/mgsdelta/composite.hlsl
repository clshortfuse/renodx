#include "./shared.h"

float4 OutputscRGB(float4 color) {
  return float4(color.rgb *= RENODX_DIFFUSE_WHITE_NITS / 80.f, color.a);
}

float4 OutputHDR10(float4 color) {
  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color.rgb), RENODX_DIFFUSE_WHITE_NITS);
  return float4(pq_color, color.a);
}

renodx::draw::Config GetIntermediateConfig(bool is_unreal = CUSTOM_UNREAL_HDR == 1.f) {
  renodx::draw::Config config = renodx::draw::BuildConfig();
  if (is_unreal) {
    config.intermediate_encoding = renodx::draw::ENCODING_PQ;
    config.intermediate_scaling = RENODX_DIFFUSE_WHITE_NITS;
    config.intermediate_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
  }
  return config;
}

renodx::draw::Config GetSwapchainConfig(bool is_pq = true) {
  renodx::draw::Config config = GetIntermediateConfig(is_pq);
  config.swap_chain_decoding = renodx::draw::ENCODING_NONE;

  if (is_pq) {
    config.swap_chain_encoding = renodx::draw::ENCODING_PQ;
    config.swap_chain_scaling_nits = RENODX_DIFFUSE_WHITE_NITS;
    config.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
  } else {
    config.swap_chain_encoding = renodx::draw::ENCODING_SCRGB;
    config.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
  }
  return config;
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
  float3 scene_color_linear = renodx::draw::InvertIntermediatePass(scene_color_pq.rgb, GetIntermediateConfig(CUSTOM_UNREAL_HDR == 1.f));
  float3 scene_color_bt2020 = renodx::color::bt2020::from::BT709(scene_color_linear);

  // #if 0
  if (RENODX_TONE_MAP_TYPE == 2.f || RENODX_TONE_MAP_TYPE == 3.f) {
    float peak_clamp = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION) peak_clamp = renodx::color::correct::Gamma(peak_clamp, true);
    scene_color_bt2020 = min(peak_clamp, scene_color_bt2020);
  } else if (RENODX_TONE_MAP_TYPE == 4.f) {
    scene_color_bt2020 = saturate(scene_color_bt2020);
  }
  // #endif
  scene_color_linear = renodx::color::bt709::from::BT2020(scene_color_bt2020);

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

  renodx::draw::Config swapchain_config;
  // return ui alpha for better FG support
  if (output_mode == 0u) {  // HDR10
    swapchain_config = GetSwapchainConfig(true);
  } else {  // scRGB
    swapchain_config = GetSwapchainConfig(false);
  }
  output_color = float4(renodx::draw::SwapChainPass(composited_color_linear, swapchain_config), ui_alpha);

  return true;
}
