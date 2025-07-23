#include "../shared.h"

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.75f, float output_max = 1.f) {
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float4 SampleAndConvertToSRGBWithToneMap(inout float3 unclamped_linear_sample, inout float3 tonemapped_linear_sample, Texture2D<float4> scene_texture, SamplerState sampler, float2 location) {
  float4 pq_color = scene_texture.Sample(sampler, location);
  float tex_alpha = pq_color.a;

  float3 linear_color = renodx::color::pq::DecodeSafe(pq_color.rgb, RENODX_DIFFUSE_WHITE_NITS);
  if (FIX_POST_PROCESS == 1.f) linear_color = renodx::color::bt709::from::BT2020(linear_color);
  unclamped_linear_sample = linear_color;  // output uncapped for UpgradeToneMap()
  linear_color = saturate(ToneMapMaxCLL(linear_color));
  tonemapped_linear_sample = linear_color;  // output capped for UpgradeToneMap()

  if (RENODX_TONE_MAP_TYPE == 0.f || FIX_POST_PROCESS == 0.f) return pq_color;

  return float4(renodx::color::srgb::EncodeSafe(linear_color), tex_alpha);
}

float4 SampleAndConvertToSRGB(Texture2D<float4> scene_texture, SamplerState sampler, float2 location) {
  float4 pq_color = scene_texture.Sample(sampler, location);
  float tex_alpha = pq_color.a;

  
  float3 linear_color = renodx::color::pq::DecodeSafe(pq_color.rgb, RENODX_DIFFUSE_WHITE_NITS);
  if (FIX_POST_PROCESS == 1.f) linear_color = renodx::color::bt709::from::BT2020(linear_color);
  
  if (RENODX_TONE_MAP_TYPE == 0.f || FIX_POST_PROCESS == 0.f) return pq_color;

  return float4(renodx::color::srgb::EncodeSafe(linear_color), tex_alpha);
}

float3 ConvertSRGBtoPQAndUpgradeToneMap(float3 srgb_color, float3 unclamped_linear_sample, float3 tonemapped_linear_sample) {
  
  float3 linear_color = renodx::color::srgb::DecodeSafe(srgb_color);
  if (FIX_POST_PROCESS == 2.f) {  // all in BT.2020
    linear_color = renodx::color::bt709::from::BT2020(linear_color);
    unclamped_linear_sample = renodx::color::bt709::from::BT2020(unclamped_linear_sample);
    tonemapped_linear_sample = renodx::color::bt709::from::BT2020(tonemapped_linear_sample);
  }
  if (RENODX_TONE_MAP_TYPE == 0.f || FIX_POST_PROCESS == 0.f) return max(0, srgb_color);
  
  linear_color = renodx::tonemap::UpgradeToneMap(unclamped_linear_sample, tonemapped_linear_sample, linear_color, 1.f);
  return renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(linear_color), RENODX_DIFFUSE_WHITE_NITS);
}

float3 ConvertSRGBtoPQ(float3 srgb_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f || FIX_POST_PROCESS == 0.f) return max(0, srgb_color);

  float3 linear_color = renodx::color::srgb::DecodeSafe(srgb_color);
  if (FIX_POST_PROCESS == 2.f) linear_color = renodx::color::bt709::from::BT2020(linear_color);
  return renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(linear_color), RENODX_DIFFUSE_WHITE_NITS);
}

float3 ConditionalConvertSRGBToBT2020(float3 srgb_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f || FIX_POST_PROCESS != 2.f) return srgb_color;

  float3 linear_color = renodx::color::srgb::DecodeSafe(srgb_color);
  linear_color = renodx::color::bt709::from::BT2020(linear_color);
  return renodx::color::srgb::EncodeSafe(linear_color);
}

float4 ConditionalConvertSRGBToBT2020(float4 srgb_color) {
  ConditionalConvertSRGBToBT2020(srgb_color.rgb);
  return float4(srgb_color.rgb, srgb_color.a);
}
