#include "./shared.h"

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  // color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

void ApplyPerChannelCorrection(float3 untonemapped, inout float3 post_tonemap) {
  // Per channel correction messes up black and white scenes
  if (RENODX_TONE_MAP_TYPE && (CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION != 0.f || CUSTOM_COLOR_GRADE_HUE_CORRECTION != 0.f || CUSTOM_COLOR_GRADE_SATURATION_CORRECTION != 0.f || CUSTOM_COLOR_GRADE_HUE_SHIFT != 0.f)) {
    post_tonemap = renodx::draw::ApplyPerChannelCorrection(
        untonemapped,
        post_tonemap,
        CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION,
        CUSTOM_COLOR_GRADE_HUE_CORRECTION,
        CUSTOM_COLOR_GRADE_SATURATION_CORRECTION,
        CUSTOM_COLOR_GRADE_HUE_SHIFT);
  }
}

float3 ToneMapMaxCLLSafe(float3 color_linear) {
  color_linear = min(1.f, ToneMapMaxCLL(max(0.f, color_linear)));

  return color_linear;
}

float3 SampleLUT(float3 color_linear, Texture3D<float4> lut, SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.strength = CUSTOM_LUT_STRENGTH;

  color_linear = renodx::lut::Sample(
      lut,
      lut_config,
      ToneMapMaxCLLSafe(color_linear));
  color_linear = max(0, color_linear);  // Fix NaNs
  return color_linear;
}

float3 VanillaBlend(float3 scene_linear, float4 ui_gamma) {
  float3 scene_gamma = renodx::color::gamma::EncodeSafe(scene_linear);
  // Luminance of scene in linear space
  float scene_luminance = renodx::color::y::from::NTSC1953(scene_gamma);
  float luminance_difference = scene_luminance - 1.f;  // 1 is hardcoded here, but a cbuffer in vanilla
  float scale = luminance_difference;

  if (luminance_difference > 0.0f) {
    float blend_rate = 0.10000002384185791f;
    scale = (blend_rate * (1.0f - exp2(((-0.0f - luminance_difference) / blend_rate) * 1.4426950216293335f)));
  }

  float alphad_scale = (((1.f - scene_luminance) + scale) * (1.0f - (ui_gamma.a * ui_gamma.a))) + scene_luminance;
  float3 output = scene_gamma;
  output.rgb = scene_luminance > 0.f ? ((alphad_scale * output) / scene_luminance) : 0.0f;

  output = ((output * ui_gamma.a) + (1.f * ui_gamma.rgb));

  output = renodx::color::gamma::DecodeSafe(output);
  return output;
}

void HandleUIScale(inout float4 ui_color_gamma) {
  float3 ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);

  // ui_color_linear = renodx::color::correct::GammaSafe(ui_color_linear);
  ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);
}

bool ApplyLuminanceSaturationAdjustments(float3 luminance_tonemap_blend, inout float3 saturation_corrected) {
  if (RENODX_TONE_MAP_TYPE != 6.f) return false;

  luminance_tonemap_blend = renodx::color::grade::UserColorGrading(
      luminance_tonemap_blend,
      1.f,
      1.f,
      1.f,
      1.f,
      2.375f,  // saturation
      0.9f,    // blowout
      0.65f,   // hue shift strength
      renodx::tonemap::ExponentialRollOff(luminance_tonemap_blend, 1.f, 2.f));

  saturation_corrected = luminance_tonemap_blend;

  return true;
}

bool Tonemap(float3 untonemapped_linear, float4 sdr_linear, inout float4 SV_TARGET, float3 TEXCOORD, float midgray_lum = 0.f, float vanilla_gamma = 2.2f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  /* if (midgray_lum > 0.f) {
    untonemapped_linear = untonemapped_linear * (midgray_lum / 0.18f);
  } */
  renodx::draw::Config config = renodx::draw::BuildConfig();
  float3 outputColor = untonemapped_linear;

  config.peak_white_nits = 10000.f;
  outputColor = renodx::draw::UpgradeToneMapByLuminance(outputColor, ToneMapMaxCLLSafe(outputColor), sdr_linear.rgb, 1.f);

  renodx::color::grade::Config grading_config = renodx::color::grade::config::Create();
  grading_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  grading_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  grading_config.shadows = RENODX_TONE_MAP_SHADOWS;
  grading_config.contrast = RENODX_TONE_MAP_CONTRAST;
  grading_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  grading_config.saturation = RENODX_TONE_MAP_SATURATION;
  grading_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  grading_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  outputColor = renodx::color::grade::config::ApplyUserColorGrading(outputColor, grading_config);

  if (CUSTOM_GRAIN_TYPE) {
    outputColor = renodx::effects::ApplyFilmGrain(
        outputColor.rgb,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.01f,
        1.f);  // if 1.f = SDR range
  }
  outputColor = renodx::color::bt2020::from::BT709(outputColor.rgb);
  outputColor = max(0, outputColor);
  float shoulder_start = 0.375f;
  outputColor = exp2(renodx::tonemap::ExponentialRollOff(log2(outputColor * RENODX_DIFFUSE_WHITE_NITS), log2(RENODX_PEAK_WHITE_NITS * shoulder_start), log2(RENODX_PEAK_WHITE_NITS))) / RENODX_DIFFUSE_WHITE_NITS;

  outputColor = renodx::draw::RenderIntermediatePass(outputColor * 100.f);

  SV_TARGET = float4(outputColor, 1.f);
  return true;
}

bool HandleFinal(float4 scene_pq, float4 ui_gamma, inout float4 SV_TARGET, float4 SV_Position) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  float3 scene_linear = renodx::draw::InvertIntermediatePass(scene_pq.rgb) / 100.f;
  scene_linear = renodx::color::bt709::from::BT2020(scene_linear);

  HandleUIScale(ui_gamma);
  float3 blended_linear = VanillaBlend(scene_linear, ui_gamma);

  SV_TARGET.rgb = renodx::draw::SwapChainPass(blended_linear).rgb;
  if (!CUSTOM_GRAIN_TYPE) {
    float random = dot(float2(171.0f, 231.0f), float2(SV_Position.x, SV_Position.y));
    SV_TARGET.rgb = ((((frac(random * 0.009345794096589088f) + -0.5f) * 0.0009775171056389809f) * CUSTOM_GRAIN_STRENGTH) + SV_TARGET.rgb);
  }
  SV_TARGET.a = 1.f;
  return true;
}
