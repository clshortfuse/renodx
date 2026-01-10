#include "../shared.h"

float4 OutputscRGB(float4 color, float scale) {
  return float4(color.rgb *= scale / 80.f, color.a);
}

float4 OutputHDR10(float4 color, float scale) {
  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color.rgb), scale);
  return float4(pq_color, color.a);
}

#if ENABLE_CUSTOM_GRAIN
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
#endif

bool HandleUICompositing(float4 ui_color_gamma, float4 scene_color_pq, inout float4 output_color, float2 position, float ui_level = 1.f, float ui_luminance = 203.f, uint output_mode = 0u) {
  if (FIX_UI == 0.f) return false;
  float ui_alpha = ui_color_gamma.a;
  float ui_brightness = RENODX_GRAPHICS_WHITE_NITS;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    ui_brightness = ui_level * ui_luminance;
  }

  float3 ui_color_linear;
  // linearize UI and scale to ratio of scene brightness
  if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
    ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);
  } else {
    ui_color_linear = renodx::color::srgb::DecodeSafe(ui_color_gamma.rgb);
  }

  // linearize scene, normalize game brightness as a ratio of ui brightness
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color_pq.rgb, ui_brightness);
  scene_color_linear = renodx::color::bt709::from::BT2020(scene_color_linear);

#if ENABLE_CUSTOM_GRAIN
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    scene_color_linear = ApplyFilmGrain(scene_color_linear, position, CUSTOM_RANDOM);
  }
#endif

  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);

  // blend in gamma, choose between sRGB and gamma based on setting
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);

  float3 composited_color_gamma = ui_color_gamma.rgb + scene_color_gamma * (1.0 - ui_alpha);
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);

  // return ui alpha for better FG support
  if (output_mode == 0u) {  // HDR10
    output_color = OutputHDR10(float4(composited_color_linear, ui_alpha), ui_brightness);
  } else {  // scRGB
    output_color = OutputscRGB(float4(composited_color_linear, ui_alpha), ui_brightness);
  }

  return true;
}

bool HandleIntermediateCompositing(float4 ui_color_gamma, float4 scene_color_pq, inout float4 output_color, float ui_level = 1.f, float ui_luminance = 203.f) {
  if (FIX_UI == 0.f) return false;
  float ui_alpha = ui_color_gamma.a;
  float ui_brightness = RENODX_GRAPHICS_WHITE_NITS;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    ui_brightness = ui_level * ui_luminance;
  }

  // linearize UI and scale to ratio of scene brightness
  float3 ui_color_linear;
  if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
    ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);
  } else {
    ui_color_linear = renodx::color::srgb::DecodeSafe(ui_color_gamma.rgb);
  }

  // linearize scene, normalize brightness
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color_pq.rgb, ui_brightness);
  scene_color_linear = renodx::color::bt709::from::BT2020(scene_color_linear);

  // blend in gamma
  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear);
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);
  float3 composited_color_gamma = ui_color_gamma.rgb + scene_color_gamma * (1.0 - ui_alpha);

  // back to linear BT.2020
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  composited_color_linear = renodx::color::bt2020::from::BT709(composited_color_linear);
  composited_color_linear *= ui_brightness / 80.f;  // shader originally divided by 80.f

  output_color = float4(composited_color_linear, ui_alpha);

  return true;
}
