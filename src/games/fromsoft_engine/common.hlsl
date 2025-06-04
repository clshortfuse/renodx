#include "./shared.h"

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

float4 HandleEncoding(float3 final_color_linear) {
  float3 bt2020_color = renodx::color::bt2020::from::BT709(final_color_linear.rgb);
  float3 pq_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);
  return float4(pq_color, 1.f);
}

bool Tonemap(float3 untonemapped_linear, float4 sdr_graded_gamma, inout float4 SV_TARGET, float vanilla_gamma = 2.2f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  float3 sdr_linear = renodx::color::gamma::DecodeSafe(sdr_graded_gamma.rgb);
  renodx::draw::Config config = renodx::draw::BuildConfig();
  float3 outputColor = renodx::draw::ToneMapPass(untonemapped_linear, sdr_linear);
  // outputColor = renodx::color::correct::GammaSafe(outputColor);
  outputColor = renodx::color::pq::EncodeSafe(outputColor, RENODX_DIFFUSE_WHITE_NITS);

  SV_TARGET = float4(outputColor, 1.f);
  return true;
}

bool HandleFinal(float4 scene_pq, float4 ui_gamma, inout float4 SV_TARGET) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  float3 scene_linear = renodx::color::pq::DecodeSafe(scene_pq.rgb, RENODX_DIFFUSE_WHITE_NITS);
  HandleUIScale(ui_gamma);
  float3 blended_linear = vanillaBlend(scene_linear, ui_gamma);

  SV_TARGET = HandleEncoding(blended_linear);
  return true;
}
