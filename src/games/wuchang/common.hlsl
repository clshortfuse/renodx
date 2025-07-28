#include "./shared.h"

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
      || CUSTOM_COLOR_GRADE_HUE_SHIFT != 0.f) {
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

float3 GenerateToneMap() {
  return renodx::draw::ToneMapPass(RENODX_UE_CONFIG.untonemapped_bt709, RENODX_UE_CONFIG.graded_bt709);
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
    color = renodx::draw::ToneMapPass(untonemapped_graded, config);
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
    tonemapped = renodx::draw::ToneMapPass(linear_color, config);
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

// Musa's stuff

float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture,
    float4 LUTWeights) {
  color_srgb = saturate(color_srgb);

  float _952 = (color_srgb.g * 0.9375f) + 0.03125f;
  float _959 = color_srgb.b * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((color_srgb.r * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float _992 = (((lerp(_966.x, _973.x, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.r));
  float _993 = (((lerp(_966.y, _973.y, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.g));
  float _994 = (((lerp(_966.z, _973.z, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.b));

  float3 lutted_srgb = float3(_992, _993, _994);

  return lutted_srgb;
}

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 1.f;

  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = SamplePacked1DLut(lutInputColor, lut_sampler, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = SamplePacked1DLut(renodx::lut::ConvertInput(0, lut_config), lut_sampler, lut_texture);
    float3 lutBlackLinear = renodx::lut::LinearOutput(lutBlack, lut_config);
    float lutBlackY = renodx::color::y::from::BT709(lutBlackLinear);
    if (lutBlackY > 0.f) {
      float3 lutMid = SamplePacked1DLut(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_sampler, lut_texture);            // use lutBlackY instead of 0.18 to avoid black crush
      float lutShift = (renodx::color::y::from::BT709(renodx::lut::LinearOutput(lutMid, lut_config)) + lutBlackY) / lutBlackY;  // galaxy brain

      float3 unclamped_gamma = renodx::lut::Unclamp(
          renodx::lut::GammaOutput(lutOutputColor, lut_config),
          renodx::lut::GammaOutput(lutBlack, lut_config),
          renodx::lut::GammaOutput(lutMid, lut_config),
          1.f,  // renodx::lut::GammaOutput(lutWhite, lut_config),
          renodx::lut::ConvertInput(color_input * lutShift, lut_config));
      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  }

  return color_output;
}