#include "./shared.h"
#include "./prismTM.hlsl"
#include "../../shaders/tonemap/psychov/test35.hlsl"

// clang-format off
static struct UELutBuilderConfig {
  float3 ungraded_ap1;
  float3 untonemapped_ap1;
  float3 untonemapped_bt709;
  float3 tonemapped_bt709;
  float3 graded_bt709;
} RENODX_UE_CONFIG;
// clang-format on

// First instance of 0.272228718, 0.674081743, 0.0536895171
void SetUngradedAP1(float3 color) {
  RENODX_UE_CONFIG.ungraded_ap1 = color;
}

void SetUntonemappedAP1(float3 color) {
  RENODX_UE_CONFIG.untonemapped_ap1 = color;
  RENODX_UE_CONFIG.untonemapped_bt709 = renodx::color::bt709::from::AP1(RENODX_UE_CONFIG.untonemapped_ap1);
  RENODX_UE_CONFIG.tonemapped_bt709 = abs(RENODX_UE_CONFIG.untonemapped_bt709);
}

void SetTonemappedBT709(inout float color_red, inout float color_green, inout float color_blue) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 color = float3(color_red, color_green, color_blue);
  RENODX_UE_CONFIG.tonemapped_bt709 = color;

  if (CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION != 0.f
      || CUSTOM_COLOR_GRADE_HUE_CORRECTION != 0.f
      || CUSTOM_COLOR_GRADE_SATURATION_CORRECTION != 0.f
      || CUSTOM_COLOR_GRADE_HUE_SHIFT != 1.f) {
    color = renodx::draw::ApplyPerChannelCorrection(
        RENODX_UE_CONFIG.untonemapped_bt709,
        float3(color_red, color_green, color_blue),
        CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION,
        CUSTOM_COLOR_GRADE_HUE_CORRECTION,
        CUSTOM_COLOR_GRADE_SATURATION_CORRECTION,
        CUSTOM_COLOR_GRADE_HUE_SHIFT);
  }

  color = abs(color);
  color_red = color.r;
  color_green = color.g;
  color_blue = color.b;
}

void SetTonemappedBT709(inout float3 color) {
  SetTonemappedBT709(color.r, color.g, color.b);
}

// Used by LUTs
void SetTonemappedAP1(inout float color_red, inout float color_green, inout float color_blue) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 color = float3(color_red, color_green, color_blue);
  float3 bt709_color = renodx::color::bt709::from::AP1(color);
  SetTonemappedBT709(bt709_color);

  color = renodx::color::ap1::from::BT709(bt709_color);
  color_red = color.r;
  color_green = color.g;
  color_blue = color.b;
}

void SetTonemappedAP1(inout float3 color) {
  SetTonemappedAP1(color.r, color.g, color.b);
}

void SetGradedBT709(inout float3 color) {
  RENODX_UE_CONFIG.graded_bt709 = color;
  RENODX_UE_CONFIG.graded_bt709 *= sign(RENODX_UE_CONFIG.tonemapped_bt709);
}

// PsychoV35 and Prism are not ToneMapPass types, and ToneMapPass would apply only
// the user grade for them. They map the linear graded signal to the true display
// peak. Gamma correction stays after the tone map, in RenderIntermediatePass.
float3 Gears4ToneMapPass(float3 color, renodx::draw::Config config) {
  [branch]
  if (config.tone_map_type != GEARS4_TONE_MAP_PSYCHOV35 && config.tone_map_type != GEARS4_TONE_MAP_PRISM) {
    return renodx::draw::ToneMapPass(color, config);
  }

  // One shared grade, as in Gears Redux: both mappers receive the same signal.
  color = renodx::color::grade::UserColorGrading(
      color,
      config.tone_map_exposure,
      config.tone_map_highlights,
      config.tone_map_shadows,
      config.tone_map_contrast,
      config.tone_map_saturation,
      0.f,
      0.f);

  float peak = config.peak_white_nits / config.diffuse_white_nits;
  [branch]
  if (config.tone_map_type == GEARS4_TONE_MAP_PSYCHOV35) {
    // RenderIntermediatePass applies gamma correction after this mapper.
    // Invert that operation for the ceiling so the final LUT reaches the
    // requested display peak without scaling diffuse white or the whole image.
    if (config.gamma_correction == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) {
      peak = renodx::color::correct::GammaSafe(peak, true, 2.2f);
    } else if (config.gamma_correction == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) {
      peak = renodx::color::correct::GammaSafe(peak, true, 2.4f);
    }
    // Reconstructed legacy grades can leave the positive signal domain.
    // Test35's logarithmic cone response does not repair unsupported inputs.
    float3 psychov35_input = max(color, 0.f);
    color = renodx::tonemap::psychov::psychotm_test35(
        psychov35_input, peak, 1.f, 1.f, 1.f, 1.f,
        RENODX_PSYCHOV35_PURITY_SCALE, 1.f, 100.f, 1.f, 1.f, 0,
        RENODX_PSYCHOV35_CONE_RESPONSE, 0.18f, 0.18f,
        RENODX_PSYCHOV35_GAMUT_COMPRESSION,
        RENODX_PSYCHOV35_GAMUT_TARGET >= 0.5f ? 1 : 0, 1.f,
        RENODX_PSYCHOV35_COMPRESSION);
    // Reject the entire invalid triplet before writing the generated LUT;
    // a single NaN cell can contaminate many interpolated scene pixels.
    if (any((asuint(color) & 0x7F800000u) == 0x7F800000u)) {
      color = psychov35_input / (1.f + max(psychov35_input.r, max(psychov35_input.g, psychov35_input.b)) / peak);
    }
  } else {
    color = prism(color, peak);
  }

  [branch]
  if (config.tone_map_blowout != 0.f || config.tone_map_highlight_saturation != 1.f) {
    color = renodx::color::grade::config::ApplyUserColorGrading(
        color,
        renodx::color::grade::config::Create(
            1.f, 1.f, 1.f, 1.f, 0.f, 1.f, config.tone_map_blowout,
            0.f, 0.f, renodx::color::grade::config::hue_correction_type::INPUT,
            1.f - config.tone_map_highlight_saturation));
  }

  // PsychoV35 smoothly fits its selected target gamut. Its BT.709-encoded
  // output can exceed the BT.709 channel ceiling when targeting BT.2020;
  // clipping that representation would discard valid wide-gamut highlights.
  if (config.tone_map_type == GEARS4_TONE_MAP_PSYCHOV35) return color;

  // Prism's outset and the chroma controls can overshoot; scale RGB evenly so hue holds.
  return color * min(1.f, peak / max(max(color.r, max(color.g, color.b)), 1e-6f));
}

float3 GenerateToneMap() {
  renodx::draw::Config config = renodx::draw::BuildConfig();
  return Gears4ToneMapPass(
      renodx::draw::ComputeUntonemappedGraded(RENODX_UE_CONFIG.untonemapped_bt709, RENODX_UE_CONFIG.graded_bt709, config),
      config);
}

float3 GenerateToneMap(float3 graded_bt709) {
  SetGradedBT709(graded_bt709);
  return GenerateToneMap();
}

renodx::draw::Config GetOutputConfig(uint OutputDevice = 0u) {
  renodx::draw::Config config = renodx::draw::BuildConfig();
  bool is_hdr = (OutputDevice >= 3u && OutputDevice <= 6u);
  if (is_hdr) {
    config.intermediate_encoding = renodx::draw::ENCODING_PQ;
    if (CUSTOM_LUT_OPTIMIZATION == 0.f) {
      config.intermediate_scaling = 1.f;
    } else {
      config.intermediate_scaling = RENODX_DIFFUSE_WHITE_NITS;
    }
    config.intermediate_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
  }
  return config;
}

float4 GenerateOutput(uint OutputDevice = 0u) {
  renodx::draw::Config config = GetOutputConfig(OutputDevice);

  float3 untonemapped_graded = renodx::draw::ComputeUntonemappedGraded(RENODX_UE_CONFIG.untonemapped_bt709, RENODX_UE_CONFIG.graded_bt709, config);

  float3 color = untonemapped_graded;

  if (CUSTOM_LUT_OPTIMIZATION == 0.f) {
    config.gamma_correction = 0.f;
  } else {
    color = Gears4ToneMapPass(untonemapped_graded, config);
  }

  color = renodx::draw::RenderIntermediatePass(color, config);
  color *= 1.f / 1.05f;
  return float4(color, 1.f);
}

float4 GenerateOutput(float3 graded_bt709, uint OutputDevice = 0u) {
  SetGradedBT709(graded_bt709);
  return GenerateOutput(OutputDevice);
}

void HandleLocalExposure(float a, float b, inout float c) {
  c = lerp(b / a, c, CUSTOM_LOCAL_EXPOSURE);
}

void HandleLUTOutput(
    inout float red, inout float green, inout float blue,
    inout float luminance,
    float2 position,
    bool is_pq) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  if (CUSTOM_GRAIN_TYPE == 0.f && CUSTOM_LUT_OPTIMIZATION == 1.f) {
    return;
  }

  renodx::draw::Config config = GetOutputConfig(is_pq);
  if (CUSTOM_LUT_OPTIMIZATION == 0.f) {
    config.gamma_correction = 0.f;
  }

  float3 linear_color = renodx::draw::InvertIntermediatePass(float3(red, green, blue), config);
  float3 tonemapped;
  [branch]
  if (CUSTOM_LUT_OPTIMIZATION == 0.f) {
    config.gamma_correction = RENODX_GAMMA_CORRECTION;
    // config.tone_map_per_channel = 1.f;
    // config.tone_map_working_color_space = 2.f;
    // config.tone_map_hue_correction = 0.f;
    tonemapped = Gears4ToneMapPass(linear_color, config);
  } else {
    tonemapped = linear_color;
  }

  luminance = renodx::color::y::from::BT709(abs(tonemapped));

  if (CUSTOM_GRAIN_TYPE == 1.f && CUSTOM_GRAIN_STRENGTH != 0.f) {
    float3 grained = renodx::effects::ApplyFilmGrain(
        tonemapped,
        position,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f,
        1.f);
    tonemapped = grained;
  }

  if (is_pq) {
    config.intermediate_scaling = RENODX_DIFFUSE_WHITE_NITS;
  }

  tonemapped = renodx::draw::RenderIntermediatePass(tonemapped, config);

  red = tonemapped.r;
  green = tonemapped.g;
  blue = tonemapped.b;
}

bool HandleUICompositing(float4 ui_color, float4 scene_color, inout float4 output_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  float3 ui_color_linear = renodx::color::srgb::DecodeSafe(ui_color.rgb);

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    ui_color_linear = renodx::color::correct::GammaSafe(ui_color_linear, false, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    ui_color_linear = renodx::color::correct::GammaSafe(ui_color_linear, false, 2.4f);
  }

  ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  ui_color.rgb = renodx::color::srgb::EncodeSafe(ui_color_linear);

  float3 scene_color_linear_bt2020 = renodx::color::pq::DecodeSafe(scene_color.rgb, RENODX_DIFFUSE_WHITE_NITS);
  float3 scene_color_linear = renodx::color::bt709::from::BT2020(scene_color_linear_bt2020);
  float3 scene_color_srgb = renodx::color::srgb::EncodeSafe(scene_color_linear);

  // Blend in SRGB based on opacity
  float3 composited_color = lerp(scene_color_srgb, ui_color.rgb, saturate(ui_color.a));
  float3 linear_color = renodx::color::srgb::DecodeSafe(composited_color);

  float3 bt2020_color = renodx::color::bt2020::from::BT709(linear_color);
  float3 pq_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);
  output_color = float4(pq_color, 1.f);
  return true;
}
