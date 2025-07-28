#include "./shared.h"

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 LUTBlackCorrection(float3 color_input, Texture3D lut_texture, renodx::lut::Config lut_config) {
  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);
    float3 lutBlackLinear = renodx::lut::LinearOutput(lutBlack, lut_config);
    float lutBlackY = max(0, renodx::color::y::from::BT709(lutBlackLinear));
    if (lutBlackY > 0.f) {
      float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_config, lut_texture);                                                            // use lutBlackY instead of 0.18 to avoid black crush
      float lutShift = (renodx::color::y::from::BT709(renodx::lut::SampleColor(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_config, lut_texture)) + lutBlackY) / lutBlackY;  // galaxy brain

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lutOutputColor, lut_config),
          renodx::lut::GammaOutput(lutBlack, lut_config),
          renodx::lut::GammaOutput(lutMid, lut_config),
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

  return lerp(color_input, color_output, lut_config.strength);
}

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.5f, float output_max = 1.f) {
  // color = max(0, renodx::color::correct::Hue(color, exp2(renodx::tonemap::ExponentialRollOff(log2(max(0, color) * 100.f), log2(1.5f * 100.f), log2(10.f * 100.f))) / 100.f, 0.75f));

  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return color * scale;
}

float3 LUTToneMap(float3 untonemapped) {
  return ToneMapMaxCLL(untonemapped);
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = max(0, renodx::color::y::from::BT709(incorrect_color));
  const float y_out = renodx::color::correct::Gamma(y_in);

  float3 lum = incorrect_color * (y_in > 0 ? y_out / y_in : 0.f);

  // use chrominance from per channel gamma correction
  // float3 result = ChrominanceOKLab(lum, ch, 1.f, 1.f);
  float3 result = renodx::color::correct::ChrominanceICtCp(lum, ch);

  return result;
}

/// Piecewise linear + exponential compression to a target value starting from a specified number.
/// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite
#define EXPONENTIALROLLOFF_GENERATOR(T)                                                                                 \
  T ExponentialRollOff(T input, float rolloff_start = 0.20f, float output_max = 1.0f, float rolloff_modulation = 1.f) { \
    T rolloff_size = output_max - rolloff_start;                                                                        \
    T overage = -max((T)0, input - rolloff_start);                                                                      \
    T rolloff_value = (T)1.0f - pow(exp(overage / rolloff_size), rolloff_modulation);                                   \
    T new_overage = mad(rolloff_size, rolloff_value, overage);                                                          \
    return input + new_overage;                                                                                         \
  }

EXPONENTIALROLLOFF_GENERATOR(float)
EXPONENTIALROLLOFF_GENERATOR(float3)
#undef EXPONENTIALROLLOFF_GENERATOR

float3 ApplyExponentialRolloff(float3 untonemapped, float diffuse_nits, float peak_nits) {
  // const float diffuse_nits = whitePaperNits;
  // const float peak_nits = max(displayMaxNits, whitePaperNits);
  const float rolloff_start = peak_nits * 0.465f;
  // const float rolloff_modulation = 1.25f;
  return exp2(ExponentialRollOff(log2(untonemapped * diffuse_nits), log2(rolloff_start), log2(peak_nits))) / diffuse_nits;
}
