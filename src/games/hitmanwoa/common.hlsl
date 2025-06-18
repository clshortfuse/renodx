#include "./shared.h"

float3 ChrominanceOKLab(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 correct_ab = correct_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(correct_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chrominance_ratio, strength);
  incorrect_lab.yz = incorrect_ab * scale;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 HueAndChrominanceOKLab(
    float3 incorrect_color,
    float3 chrominance_reference_color,
    float3 hue_reference_color,
    float hue_correct_strength = 1.f) {
  if (hue_correct_strength == 0.f)
    return ChrominanceOKLab(incorrect_color, chrominance_reference_color);

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 hue_lab = renodx::color::oklab::from::BT709(hue_reference_color);
  float3 chrominance_lab = renodx::color::oklab::from::BT709(chrominance_reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 hue_ab = hue_lab.yz;

  // Always use chrominance magnitude from chroma reference
  float target_chrominance = length(chrominance_lab.yz);

  // Compute blended hue direction
  float2 blended_ab_dir = normalize(lerp(normalize(incorrect_ab), normalize(hue_ab), hue_correct_strength));

  // Apply chrominance magnitude from chroma_reference_color
  float2 final_ab = blended_ab_dir * target_chrominance;

  incorrect_lab.yz = final_ab;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 HueChrominanceOKLab(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  incorrect_lab.yz = correct_lab.yz;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}
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

float3 CorrectBlackChrominance(float3 color_input, float3 lut_color, float3 lut_black_rgb, float lut_black_y, float strength) {
  float3 input_rgb = abs(color_input);
  float3 lut_rgb = abs(lut_color);

  float3 a = lut_black_rgb;
  float3 b = lerp(0.0f, lut_black_rgb, strength);
  float3 g = input_rgb;
  float3 h = lut_rgb;

  float3 new_rgb = h - pow(lut_black_rgb, pow(1.0f + g, b / a));

  float3 scale_raw = min(h, new_rgb) / h;
  float3 scale = lerp(1.0f, scale_raw, step(0.0f, h));  // fast select

  float3 per_channel = lut_color * scale;
  float3 lum = renodx::lut::CorrectBlack(color_input, lut_color, lut_black_y, strength);

  float3 corrected = HueAndChrominanceOKLab(lum, per_channel, lut_color);

  return corrected;
}

// float ToneMapHitman2(float x) {
//   float scaled = x * 0.6f;
//   float num = (scaled + 0.1f) * x + 0.004f;
//   float den = (scaled + 1.0f) * x + 0.06f;
//   float result = num / den;
//   result -= 2.f / 30.f;
//   return saturate(result);
// }

// float3 ToneMapHitman2(float3 x) {
//   float3 scaled = x * 0.6f;
//   float3 num = (scaled + 0.1f) * x + 0.004f;
//   float3 den = (scaled + 1.0f) * x + 0.06f;
//   float3 result = num / den;
//   result -= 2.f / 30.f;
//   return saturate(result);
// }

float ToneMapHitman2(float x) {
  float scaled = x * 0.6f;
  float num = (scaled + 0.1f) * x + 0.00395f;  //   float3 num = (scaled + 0.1f) * x + 0.004f;
  float den = (scaled + 1.0f) * x + 0.06f;
  float result = num / den;
  result -= 0.0655f;  // result -= 2.f / 30.f;
  return saturate(result);
}

float3 ToneMapHitman2(float3 x) {
  float3 scaled = x * 0.6f;
  float3 num = (scaled + 0.1f) * x + 0.00395f;  //   float num = (scaled + 0.1f) * x + 0.004f;
  float3 den = (scaled + 1.0f) * x + 0.06f;
  float3 result = num / den;
  result -= 0.0655f;  // result -= 2.f / 30.f;
#if 0                 // blended luminance and channel
  const float y_in = renodx::color::y::from::BT709(x);
  const float y_out = ToneMapHitman2(y_in);

  float3 lum = x * select(y_in > 0, y_out / y_in, 0.f);
  lum = ChrominanceOKLab(lum, result);

  result = lerp(lum, result, saturate(lum / 0.4f));

#endif
  return saturate(result);
}

float3 SampleGamma2LUT16(Texture3D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_0;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 0.f;
  lut_config.lut_sampler = lut_sampler;
  lut_config.size = 16u;

  float3 lutted = renodx::lut::Sample(lut_texture, lut_config, color_input);
#if 1
  if (RENODX_COLOR_GRADE_STRENGTH > 0.f && RENODX_COLOR_GRADE_SCALING > 0.f) {
    float3 min_black = lut_texture.SampleLevel(lut_sampler, float3(0.03125f, 0.03125f, 0.03125f), 0.0f).rgb;
    float3 lut_min_rgb = pow(min_black, 2.2f);
    float lut_min_y = renodx::color::y::from::BT709(abs(lut_min_rgb));
    if (lut_min_y > 0) {
      float3 gamma_corrected_color_input = renodx::color::correct::GammaSafe(color_input);
      float3 gamma_corrected_lutted = renodx::color::correct::GammaSafe(lutted);
      float3 corrected_black = CorrectBlackChrominance(gamma_corrected_color_input, gamma_corrected_lutted, lut_min_rgb, lut_min_y, 50.f);
      // float3 corrected_black = HueChrominanceOKLab(renodx::lut::CorrectBlack(gamma_corrected_color_input, gamma_corrected_lutted, lut_min_y, 25.f), lutted, 1.f);
      lutted = lerp(lutted, corrected_black, RENODX_COLOR_GRADE_SCALING);
      lutted = renodx::color::correct::GammaSafe(lutted, true);
    }
  }
#endif
  return lutted;
}

float3 SampleLinearLUT16(Texture3D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 0.f;
  lut_config.lut_sampler = lut_sampler;
  lut_config.size = 16u;

  float3 lutted = renodx::lut::Sample(lut_texture, lut_config, color_input);
#if 1
  if (RENODX_COLOR_GRADE_STRENGTH > 0.f && RENODX_COLOR_GRADE_SCALING > 0.f) {
    float3 min_black = lut_texture.SampleLevel(lut_sampler, float3(0.03125f, 0.03125f, 0.03125f), 0.0f).rgb;
    float3 lut_min_rgb = pow(min_black, 2.2f);
    float lut_min_y = renodx::color::y::from::BT709(abs(lut_min_rgb));
    if (lut_min_y > 0) {
      float3 gamma_corrected_color_input = renodx::color::correct::GammaSafe(color_input);
      float3 gamma_corrected_lutted = renodx::color::correct::GammaSafe(lutted);
      float3 corrected_black = CorrectBlackChrominance(gamma_corrected_color_input, gamma_corrected_lutted, lut_min_rgb, lut_min_y, 50.f);
      // float3 corrected_black = HueChrominanceOKLab(renodx::lut::CorrectBlack(gamma_corrected_color_input, gamma_corrected_lutted, lut_min_y, 25.f), lutted, 1.f);
      lutted = lerp(lutted, corrected_black, RENODX_COLOR_GRADE_SCALING);
      lutted = renodx::color::correct::GammaSafe(lutted, true);
    }
  }
#endif
  return lutted;
}

float3 ApplyDisplayMap(float3 color_input) {
  float3 signs = sign(color_input);
  color_input = abs(color_input);

  color_input *= RENODX_DIFFUSE_WHITE_NITS;
  float3 display_mapped = exp2(renodx::tonemap::ExponentialRollOff(
      log2(color_input),
      log2(RENODX_PEAK_WHITE_NITS * RENODX_TONE_MAP_SHOULDER_START),
      log2(RENODX_PEAK_WHITE_NITS)));
  display_mapped /= RENODX_DIFFUSE_WHITE_NITS;
  display_mapped *= signs;

  display_mapped = renodx::color::correct::Hue(display_mapped, color_input, RENODX_TONE_MAP_HUE_CORRECTION);

  return display_mapped;
}

float3 FinalizeOutput(float3 color_input) {
  // color_input = renodx::color::bt2020::from::BT709(color_input);
  color_input *= 2.5f;
  return color_input;
}

float3 ToneMapMaxCLLAndSampleGamma2LUT16AndFinalizeOutput(
    float3 hdr_tonemapped,
    Texture3D<float4> lut_texture, SamplerState lut_sampler) {
  float3 sdr_tonemapped = ToneMapMaxCLL(hdr_tonemapped, 0.5f);

  float3 lutted = SampleGamma2LUT16(lut_texture, lut_sampler, sdr_tonemapped);
  float3 upgraded = renodx::tonemap::UpgradeToneMap(hdr_tonemapped, sdr_tonemapped, lutted, RENODX_COLOR_GRADE_STRENGTH, 0.f);
  float3 display_mapped = ApplyDisplayMap(upgraded);
  display_mapped = FinalizeOutput(display_mapped);

  return display_mapped;
}

float3 ToneMapMaxCLLAndSampleLinearLUT16AndFinalizeOutput(
    float3 hdr_tonemapped,
    Texture3D<float4> lut_texture, SamplerState lut_sampler) {
  float3 sdr_tonemapped = ToneMapMaxCLL(hdr_tonemapped, 0.5f);

  float3 lutted = SampleLinearLUT16(lut_texture, lut_sampler, sdr_tonemapped);
  float3 upgraded = renodx::tonemap::UpgradeToneMap(hdr_tonemapped, sdr_tonemapped, lutted, RENODX_COLOR_GRADE_STRENGTH, 0.f);
  float3 display_mapped = ApplyDisplayMap(upgraded);
  display_mapped = FinalizeOutput(display_mapped);

  return display_mapped;
}

float3 ChrominanceOKLabLerp(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 correct_ab = correct_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(correct_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chrominance_ratio, strength);
  incorrect_lab.yz = incorrect_ab * scale;

  incorrect_lab.x = lerp(incorrect_lab.x, correct_lab.x, 0.5f);

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 GammaCorrectChrominance(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = renodx::color::y::from::BT709(incorrect_color);
  const float y_out = max(0, renodx::color::correct::Gamma(y_in));

  float3 lum = incorrect_color * select(y_in > 0, y_out / y_in, 0.f);

  // use chrominance from channel gamma correction
  float3 result = ChrominanceOKLabLerp(lum, ch);

  return result;
}
