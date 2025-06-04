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

float3 vanillaBlend(float3 scene_linear, float4 ui_gamma) {
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

bool Tonemap(float3 untonemapped_linear, float4 sdr_graded_gamma, inout float4 SV_TARGET, float midgray_lum = 0.f, float vanilla_gamma = 2.2f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  /* if (midgray_lum > 0.f) {
    untonemapped_linear = untonemapped_linear * (midgray_lum / 0.18f);
  } */
  float3 sdr_linear = renodx::color::gamma::DecodeSafe(sdr_graded_gamma.rgb);
  renodx::draw::Config config = renodx::draw::BuildConfig();
  float3 outputColor = renodx::draw::ToneMapPass(untonemapped_linear, sdr_linear);
  // outputColor = renodx::color::correct::GammaSafe(outputColor);
  outputColor = renodx::draw::RenderIntermediatePass(outputColor);

  SV_TARGET = float4(outputColor, 1.f);
  return true;
}

bool HandleFinal(float4 scene_pq, float4 ui_gamma, inout float4 SV_TARGET) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  float3 scene_linear = renodx::draw::InvertIntermediatePass(scene_pq.rgb);
  HandleUIScale(ui_gamma);
  float3 blended_linear = vanillaBlend(scene_linear, ui_gamma);

  SV_TARGET.rgb = renodx::draw::SwapChainPass(blended_linear).rgb;
  SV_TARGET.a = 1.f;
  
  return true;
}
