#include "../shared.h"

float4 OutputscRGB(float4 color, float scale) {
  return float4(color.rgb *= scale / 80.f, color.a);
}

float4 OutputHDR10(float4 color, float scale) {
  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color.rgb), scale);
  return float4(pq_color, color.a);
}

float3 ApplyFilmGrain(float3 color, float2 position, float random) {
  if (CUSTOM_GRAIN_TYPE != 0.f && CUSTOM_GRAIN_STRENGTH != 0.f) {
    color = renodx::effects::ApplyFilmGrain(
        color,
        position,
        random,
        CUSTOM_GRAIN_STRENGTH * 0.0175f,
        RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS  // input has been scaled relative to graphics white,
    );
  }
  return color;
}

bool HandleUICompositing(float4 ui_color_gamma, float4 scene_color_pq, inout float4 output_color, float2 position, uint output_mode = 0u) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  float ui_alpha = ui_color_gamma.a;

  float3 ui_color_linear;
  // linearize UI and scale to ratio of scene brightness
  if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
    ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);
  } else {
    ui_color_linear = renodx::color::srgb::DecodeSafe(ui_color_gamma.rgb);
  }

  // linearize scene, normalize game brightness as a ratio of ui brightness
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color_pq.rgb, RENODX_GRAPHICS_WHITE_NITS);
  scene_color_linear = renodx::color::bt709::from::BT2020(scene_color_linear);

  scene_color_linear = ApplyFilmGrain(scene_color_linear, position, CUSTOM_RANDOM);

  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);

  // blend in gamma, choose between sRGB and gamma based on setting
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);

  float3 composited_color_gamma = ui_color_gamma.rgb + scene_color_gamma * (1.0 - ui_alpha);
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);

  // return ui alpha for better FG support
  if (output_mode == 0u) {  // HDR10
    output_color = OutputHDR10(float4(composited_color_linear, ui_alpha), RENODX_GRAPHICS_WHITE_NITS);
  } else {  // scRGB
    output_color = OutputscRGB(float4(composited_color_linear, ui_alpha), RENODX_GRAPHICS_WHITE_NITS);
  }

  return true;
}

bool HandleIntermediateCompositing(float4 ui_color_gamma, float4 scene_color_pq, inout float4 output_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  float ui_alpha = ui_color_gamma.a;

  // linearize UI and scale to ratio of scene brightness
  float3 ui_color_linear;
  if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
    ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);
  } else {
    ui_color_linear = renodx::color::srgb::DecodeSafe(ui_color_gamma.rgb);
  }

  // linearize scene, normalize brightness
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color_pq.rgb, RENODX_GRAPHICS_WHITE_NITS);
  scene_color_linear = renodx::color::bt709::from::BT2020(scene_color_linear);

  // blend in gamma
  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear);
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);
  float3 composited_color_gamma = ui_color_gamma.rgb + scene_color_gamma * (1.0 - ui_alpha);

  // back to linear BT.2020
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  composited_color_linear = renodx::color::bt2020::from::BT709(composited_color_linear);
  composited_color_linear *= RENODX_GRAPHICS_WHITE_NITS / 80.f;  // shader originally divided by 80.f

  output_color = float4(composited_color_linear, ui_alpha);

  return true;
}
