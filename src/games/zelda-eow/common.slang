#version 450

#include "./shared.h"
#include "./test17.hlsl"

static const float ZELDA_EOW_HEJL_DAWSON_BLACK_OFFSET = 0.004f;
static const float ZELDA_EOW_TONE_MAP_MID_GRAY = 0.18f;
//static const float CUSTOM_CONE_RESPONSE = 1.2f;

float3 HejlDawsonCustom(float3 color, vec2 param, bool extended = false) {
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  float x = param.x;
  float y = param.y;
  color *= scale;
  color = max(0, color - ZELDA_EOW_HEJL_DAWSON_BLACK_OFFSET);
  float3 a = fma(color, x, 1.7);
  float3 b = fma(color, x, 0.5);
  float3 c = fma(color, a, y);
  float3 d = color * b / c;

  return pow(abs(d), 2.2f) / scale;
}

float3 HejlDawsonCustom(float3 color, float x, float y, bool extended = false) {
  return HejlDawsonCustom(color, vec2(x,y), extended);
}

float HejlDawsonCustom(float color, float x, float y, bool extended = false) {
  return HejlDawsonCustom(color, vec2(x,y), extended);
}

float HejlDawsonCustom(float color, vec2 param, bool extended = false) {
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  float x = param.x;
  float y = param.y;
  color *= scale;
  color = max(0, color - 0.004f);
  float a = fma(color, x, 1.7);
  float b = fma(color, x, 0.5);
  float c = fma(color, a, y);
  float d = color * b / c;

  return pow(abs(d), 2.2f) / scale;
}

float3 ColorCorrect(float3 colour, float3 reference) {
  float3 corrected = renodx::color::correct::ChrominanceOKLab(colour, reference, RENODX_HUE_SHIFT);
  return renodx::color::correct::HueOKLab(corrected, reference, RENODX_HUE_SHIFT);
}

float3 ApplyColorGrade(float3 color)
{
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  return renodx::color::grade::config::ApplyUserColorGrading(color, config);

}


float3 DisplayMap(float3 color, bool ui = false)
{
  float peakRatio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  [branch]
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    peakRatio = renodx::color::correct::Gamma(
        peakRatio,
        true,
        renodx::math::Select(RENODX_GAMMA_CORRECTION == 1.f, 2.2f, 2.4f));
  }

  return renodx::tonemap::neutwo::PerChannel(color, peakRatio);
}

float HejlDawsonCustomMidGrayExponentialContrast(float x, float y) {
  const float input_value = ZELDA_EOW_TONE_MAP_MID_GRAY;
  const float color = input_value - ZELDA_EOW_HEJL_DAWSON_BLACK_OFFSET;
  const float numerator = color * (color * x + 0.5f);
  const float denominator = color * (color * x + 1.7f) + y;
  const float numerator_slope = fma(2.f * x, color, 0.5f);
  const float denominator_slope = fma(2.f * x, color, 1.7f);
  return max(
      0.f,
      2.2f * input_value * (
                 renodx::math::DivideSafe(numerator_slope, numerator, 0.f)
                 - renodx::math::DivideSafe(denominator_slope, denominator, 0.f)));
}

float ZeldaEOWComputePsychoV17Peak() {
  float peak = max(1.f, renodx::math::DivideSafe(RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS, 1.f));
  if (RENODX_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) {
    peak = renodx::color::correct::Gamma(peak, true, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) {
    peak = renodx::color::correct::Gamma(peak, true, 2.4f);
  }
  return peak;
}

float3 ZeldaEOWApplyPsychoV17HejlDawson(float3 untonemapped, float param_x, float param_y, float reference_mid_gray) {
  return renodx::tonemap::psychov::psychotm_test17(
      untonemapped,
      ZeldaEOWComputePsychoV17Peak(),
      RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      100.f,
      1.f,
      1.f,
      1,
      // Match vanilla's effective mid-gray slope with the black offset, but do not apply that offset to the PsychoV input.
      HejlDawsonCustomMidGrayExponentialContrast(param_x, param_y) * max(0.f, CUSTOM_CONE_RESPONSE),
      ZELDA_EOW_TONE_MAP_MID_GRAY.xxx,
      max(reference_mid_gray, renodx::math::FLT_EPSILON).xxx,
      1.f,
      1);
}

float3 ZeldaEOWApplyHejlDawsonToneMap(float3 untonemapped, float param_x, float param_y) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return saturate(HejlDawsonCustom(untonemapped, param_x, param_y));
  }
  const float vanilla_mid_gray = HejlDawsonCustom(ZELDA_EOW_TONE_MAP_MID_GRAY, param_x, param_y);
  if (RENODX_TONE_MAP_TYPE == 6.f) {
    return ZeldaEOWApplyPsychoV17HejlDawson(
        untonemapped,
        param_x,
        param_y,
        vanilla_mid_gray);
  }
  const float3 vanilla = HejlDawsonCustom(untonemapped, param_x, param_y);
  return renodx::draw::ToneMapPass(untonemapped * vanilla_mid_gray / ZELDA_EOW_TONE_MAP_MID_GRAY, vanilla);
}

float3 WobblyApplyPsychoV17(float3 untonemapped_bt709, bool is_sdr = false) {
  float3 bt709_scene = untonemapped_bt709 * RENODX_TONE_MAP_EXPOSURE;

  float3 lms_in = renodx::color::lms::from::BT709(bt709_scene);
  float yf_input = renodx::color::yf::from::LMS(lms_in);
  float yf_midgray = renodx::color::yf::from::BT709(0.18f);
  float yf_target = yf_input;

  if (RENODX_TONE_MAP_HIGHLIGHTS != 1.f) {
    yf_target = renodx::color::grade::Highlights(yf_target, RENODX_TONE_MAP_HIGHLIGHTS, yf_midgray);
  }
  if (RENODX_TONE_MAP_SHADOWS != 1.f) {
    yf_target = renodx::color::grade::Shadows(yf_target, RENODX_TONE_MAP_SHADOWS, yf_midgray);
  }
  if (RENODX_TONE_MAP_CONTRAST != 1.f) {
    yf_target = renodx::color::grade::ContrastSafe(yf_target, RENODX_TONE_MAP_CONTRAST, yf_midgray);
  }

  float yf_scale = renodx::math::DivideSafe(yf_target, yf_input, 1.f);
  bt709_scene *= yf_scale;

  return renodx::tonemap::psychov::psychotm_test17(
      bt709_scene,
      RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS,
      1.f,
      1.f,
      1.f,
      1.f,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      100.f,
      1.f,
      1.f,
      1,
      max(0.f, 1),
      0.18f.xxx,
      0.18f.xxx,
      1.f,
      (int)(!is_sdr));
}