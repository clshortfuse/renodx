#include "../common.hlsl"

float3 ScaleGameColorUI(float3 game_color) {

  game_color /= RENODX_DIFFUSE_WHITE_NITS;

  if (TONEMAP_UNDER_UI != 0.f) {
    float y_in = renodx::color::y::from::BT2020(game_color);
    const float peak = 1.f;
    float y_tonemapped = lerp(y_in, renodx::tonemap::Neutwo(y_in, peak), saturate(y_in));
    game_color = renodx::color::correct::Luminance(game_color, y_in, y_tonemapped);
  }
  game_color = renodx::color::srgb::EncodeSafe(game_color);
  return game_color;
}


bool HandleUICompositing(float4 ui_color, float3 scene_color, inout float4 output_color, float2 uv, Texture2D<float4> t1, SamplerState s1) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  ui_color.rgb = max(0, ui_color.rgb);
  const float ui_alpha = saturate(ui_color.a);
  const float one_minus_ui_alpha = 1.0 - ui_alpha;

  // linearize and normalize brightness
  float3 ui_color_linear;
  if (RENODX_GAMMA_CORRECTION != 0.f) {  // 2.2
    ui_color_linear = renodx::color::correct::GammaSafe(ui_color.rgb);
  } else {
    ui_color_linear = ui_color.rgb;
  }
  ui_color_linear = renodx::color::bt2020::from::BT709(ui_color_linear);
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color, RENODX_GRAPHICS_WHITE_NITS);
  scene_color_linear = CustomPostProcessing(scene_color_linear, uv, t1, s1);
  //scene_color_linear *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;

#if 1  // apply Neutwo under UI
  if (TONEMAP_UNDER_UI != 0.f) {
  //if (true) {
    float y_in = renodx::color::y::from::BT2020(scene_color_linear);

    const float peak = 1.f;  // UI white
    float y_tonemapped = lerp(y_in, renodx::tonemap::Neutwo(y_in, peak), saturate(y_in));

    float y_out = lerp(y_in, y_tonemapped, ui_alpha);

    scene_color_linear = renodx::color::correct::Luminance(scene_color_linear, y_in, y_out);
  }
#endif

  // blend in gamma
  float3 ui_color_gamma = renodx::color::gamma::EncodeSafe(ui_color_linear);
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);
  float3 composited_color_gamma = ui_color_gamma.rgb + (scene_color_gamma * one_minus_ui_alpha);

  // linearize and scale up brightness
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);

  composited_color_linear *= RENODX_GRAPHICS_WHITE_NITS;
  float max_channel = max(max(max(composited_color_linear.r, composited_color_linear.g), composited_color_linear.b), RENODX_PEAK_WHITE_NITS);
  composited_color_linear *= RENODX_PEAK_WHITE_NITS / max_channel;  // Clamp UI or Videos

  float3 pq_color = renodx::color::pq::EncodeSafe(composited_color_linear, 1.f);
  output_color = float4(pq_color, 1.f);

  return true;
}