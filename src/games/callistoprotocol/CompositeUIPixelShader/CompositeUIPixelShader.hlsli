#include "../common.hlsli"
#include "./displaymapping.hlsli"

bool ComposeUIAndSceneSCRGB(float3 scene_color, float4 ui_color_gamma, inout float4 output_color, float2 position) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  ui_color_gamma = max(0, ui_color_gamma);
  float ui_alpha = ui_color_gamma.a;

  if (RENODX_GAMMA_CORRECTION_UI == 0.f) {
    ui_color_gamma.rgb = renodx::color::gamma::Encode(renodx::color::srgb::Decode(ui_color_gamma.rgb));
  }

  // Defer display mapping to compositing because PostProcessToneMap applies adjustments after tonemapping.
  const float MID_GRAY = 0.18f;
  const float PEAK_RATIO = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  const float CLIP = 100.f;
  if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {  // BT.709
    scene_color = ApplyAnchoredCubicShoulder(scene_color, PEAK_RATIO, MID_GRAY, 1.3f);
    // scene_color = ApplyAnchoredHillShoulder(scene_color, PEAK_RATIO, MID_GRAY);
  } else {  // LMS
    float3 scene_lms = renodx::color::lms::from::BT709(scene_color);
    const float3 ANCHOR_LMS = renodx::color::lms::from::BT2020(MID_GRAY);
    const float3 PEAK_LMS = renodx::color::lms::from::BT2020(PEAK_RATIO);
    const float3 CLIP_LMS = renodx::color::lms::from::BT2020(CLIP);
    scene_lms = ApplyAnchoredCubicShoulder(scene_lms, PEAK_LMS, ANCHOR_LMS, 1.3f);
    // scene_lms = ApplyAnchoredHillShoulder(scene_lms, PEAK_LMS, ANCHOR_LMS, CLIP_LMS);
    // scene_lms = renodx::tonemap::neutwo::PerChannel(scene_lms, PEAK_LMS);
    // scene_lms = ApplyAnchoredNeutwoShoulder(scene_lms, PEAK_LMS, ANCHOR_LMS, 0.15f);
    // scene_lms = ApplyNakaRushton(scene_lms, PEAK_LMS, ANCHOR_LMS, 1.5f);
    // scene_lms = ReinhardPiecewise(scene_lms, PEAK_LMS, ANCHOR_LMS);

    scene_color = renodx::color::bt709::from::LMS(scene_lms);
  }

  // Rescale that reference so 1.0 represents the configured diffuse white.
  scene_color *= RENODX_DIFFUSE_WHITE_NITS;

  // Blend UI and scene color in gamma space, then convert back to linear space.
  scene_color /= RENODX_GRAPHICS_WHITE_NITS;
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color);
  float3 composited_color_gamma = mad(scene_color_gamma, 1.f - ui_alpha, ui_color_gamma.rgb);
  float3 composited_color = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  composited_color *= RENODX_GRAPHICS_WHITE_NITS;

  output_color = float4(composited_color / 80.f, ui_alpha);
  return true;
}
