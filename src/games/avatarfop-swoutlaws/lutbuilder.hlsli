#include "./psycho_test17_custom.hlsli"
#include "./shared.h"

float3 ApplySDREOTFEmulation(float3 color_input) {
  float3 color_corrected;
  if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    color_corrected = renodx::color::correct::GammaSafe(color_input);
  } else if (RENODX_SDR_EOTF_EMULATION == 2.f) {
    float y_in = renodx::color::yf::from::BT709(color_input);
    float y_out = renodx::color::correct::Gamma(max(0, y_in));
    float3 color_corrected_lum = renodx::color::correct::Luminance(color_input, y_in, y_out);

    float3 color_corrected_ch = renodx::color::correct::GammaSafe(color_input);

    color_corrected = renodx::color::bt709::from::BT2020(renodx_custom::tonemap::psycho::psycho17_ApplyPurityFromBT2020(
        renodx::color::bt2020::from::BT709(color_corrected_ch), renodx::color::bt2020::from::BT709(color_corrected_lum), 1.f, 1.f));
  } else {
    color_corrected = color_input;
  }

  return color_corrected;
}

#define SPLIT_CONTRAST_FUNCTION_GENERATOR(T)                                                       \
  T SplitContrast(T input, float contrast_shadows = 1.f, float contrast_highlights = 1.f,          \
                  float split_point = 0.18f) {                                                     \
    T contrast = renodx::math::Select(input < split_point, contrast_shadows, contrast_highlights); \
    T contrasted = pow(input / split_point, contrast) * split_point;                               \
    return contrasted;                                                                             \
  }

SPLIT_CONTRAST_FUNCTION_GENERATOR(float)
SPLIT_CONTRAST_FUNCTION_GENERATOR(float3)

#undef SPLIT_CONTRAST_FUNCTION_GENERATOR

float3 GenerateOutputAvatar(float3 ungraded_bt709, float contrast) {
  float3 graded_bt709;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    graded_bt709 = ungraded_bt709;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      float lum_in = renodx::color::y::from::BT709(ungraded_bt709);
      float lum_out = renodx::color::correct::GammaSafe(lum_in);
      float3 corrected_lum = renodx::color::correct::Luminance(ungraded_bt709, lum_in, lum_out);

      float3 corrected_ch = renodx::color::correct::GammaSafe(ungraded_bt709);
      graded_bt709 = renodx::color::bt709::from::BT2020(
          renodx_custom::tonemap::psycho::psycho17_ApplyPurityFromBT2020(renodx::color::bt2020::from::BT709(corrected_lum),
                                                                         renodx::color::bt2020::from::BT709(corrected_ch), 1.f, 1.f));
    }
  } else {  // RenoDX
    // `pow(c, contrast) * exposure_adjustment` per channel will essentially give uncapped version of vanilla
    float shadow_contrast = contrast;
    // lower highlight contrast so image isn't overly harsh, but make sure sun still reaches 100.f (10k nits with 100 game brightness)
    float highlight_contrast = contrast * 0.681f;
    float exposure_adjustment = 2.f;

    // apply by yf to keep hues intact and scale lightness evenly
    float lum_in = renodx::color::yf::from::BT709(ungraded_bt709);
    float lum_out = SplitContrast(lum_in, shadow_contrast, highlight_contrast, 1.f) * exposure_adjustment;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      lum_out = renodx::color::correct::GammaSafe(lum_out);
    }
    float3 contrasted_lum = renodx::color::correct::Luminance(ungraded_bt709, lum_in, lum_out);

    // apply grading per channel as reference color to take purity from
    float3 contrasted_ch = SplitContrast(ungraded_bt709, shadow_contrast, highlight_contrast, 1.f) * exposure_adjustment;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      contrasted_ch = renodx::color::correct::GammaSafe(contrasted_ch);
    }

    // apply purity of per channel contrasted to yf contrasted
    // this gives us our graded color which will be tonemapped to monitor peak later
    graded_bt709 = renodx::color::bt709::from::BT2020(
        renodx_custom::tonemap::psycho::psycho17_ApplyPurityFromBT2020(
            renodx::color::bt2020::from::BT709(contrasted_ch),
            renodx::color::bt2020::from::BT709(contrasted_lum), 1.f, 1.f));
  }

  if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    graded_bt709 = renodx::color::correct::GammaSafe(graded_bt709);
  }

  float3 final_bt709 = graded_bt709;

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(final_bt709);

  renodx_custom::tonemap::psycho::config17::Config psycho17_config =
      renodx_custom::tonemap::psycho::config17::Create();
  psycho17_config.peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  psycho17_config.clip_point = RENODX_TONE_MAP_WHITE_CLIP;
  psycho17_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  psycho17_config.gamma = RENODX_TONE_MAP_GAMMA;
  psycho17_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  psycho17_config.shadows = RENODX_TONE_MAP_SHADOWS;
  psycho17_config.contrast = RENODX_TONE_MAP_CONTRAST;
  psycho17_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  psycho17_config.contrast_highlights = RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS;
  psycho17_config.contrast_shadows = RENODX_TONE_MAP_CONTRAST_SHADOWS;
  psycho17_config.purity_scale = RENODX_TONE_MAP_SATURATION;
  psycho17_config.purity_highlights = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  psycho17_config.dechroma = RENODX_TONE_MAP_DECHROMA;
  psycho17_config.adaptation_contrast = RENODX_TONE_MAP_ADAPTATION_CONTRAST;
  psycho17_config.bleaching_intensity = 0.f;
  psycho17_config.hue_emulation = RENODX_TONE_MAP_HUE_EMULATION;
  psycho17_config.pre_gamut_compress = false;
  psycho17_config.post_gamut_compress = true;

  if (RENODX_TONE_MAP_TYPE == 1.f) {
    psycho17_config.apply_tonemap = false;
  }

  float3 hue_shift_source_bt2020 = color_bt2020;
  if (psycho17_config.hue_emulation != 0.f) {
    hue_shift_source_bt2020 = renodx::tonemap::ReinhardPiecewise(color_bt2020, 2.5f, psycho17_config.mid_gray);
  }
  color_bt2020 = renodx_custom::tonemap::psycho::ApplyTest17BT2020(color_bt2020, hue_shift_source_bt2020, psycho17_config);

  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_DIFFUSE_WHITE_NITS);

  return color_pq;
}

float3 GenerateOutputOutlaws(float3 ungraded_bt709, float contrast) {
  float3 graded_bt709;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    graded_bt709 = ungraded_bt709;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      float lum_in = renodx::color::y::from::BT709(ungraded_bt709);
      float lum_out = renodx::color::correct::GammaSafe(lum_in);
      float3 corrected_lum = renodx::color::correct::Luminance(ungraded_bt709, lum_in, lum_out);

      float3 corrected_ch = renodx::color::correct::GammaSafe(ungraded_bt709);
      graded_bt709 = renodx::color::bt709::from::BT2020(
          renodx_custom::tonemap::psycho::psycho17_ApplyPurityFromBT2020(renodx::color::bt2020::from::BT709(corrected_lum),
                                                                         renodx::color::bt2020::from::BT709(corrected_ch), 1.f, 1.f));
    }
  } else {  // RenoDX
    // `pow(c, contrast) * exposure_adjustment` per channel will essentially give uncapped version of vanilla
    float shadow_contrast = contrast;
    // lower highlight contrast so image isn't overly harsh, but make sure sun still reaches 100.f (10k nits with 100 game brightness)
    float highlight_contrast = contrast * 0.7375f;
    float exposure_adjustment = 1.7f;

    // apply by yf to keep hues intact and scale lightness evenly
    float lum_in = renodx::color::yf::from::BT709(ungraded_bt709);
    float lum_out = SplitContrast(lum_in, shadow_contrast, highlight_contrast, 1.f) * exposure_adjustment;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      lum_out = renodx::color::correct::GammaSafe(lum_out);
    }
    float3 contrasted_lum = renodx::color::correct::Luminance(ungraded_bt709, lum_in, lum_out);

    // apply grading per channel as reference color to take purity from
    float3 contrasted_ch = SplitContrast(ungraded_bt709, shadow_contrast, highlight_contrast, 1.f) * exposure_adjustment;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      contrasted_ch = renodx::color::correct::GammaSafe(contrasted_ch);
    }

    // apply purity of per channel contrasted to yf contrasted
    // this gives us our graded color which will be tonemapped to monitor peak later
    graded_bt709 = renodx::color::bt709::from::BT2020(
        renodx_custom::tonemap::psycho::psycho17_ApplyPurityFromBT2020(
            renodx::color::bt2020::from::BT709(contrasted_ch),
            renodx::color::bt2020::from::BT709(contrasted_lum), 1.f, 1.f));
  }

  if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    graded_bt709 = renodx::color::correct::GammaSafe(graded_bt709);
  }

  float3 final_bt709 = graded_bt709;

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(final_bt709);

  renodx_custom::tonemap::psycho::config17::Config psycho17_config =
      renodx_custom::tonemap::psycho::config17::Create();
  psycho17_config.peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  psycho17_config.clip_point = RENODX_TONE_MAP_WHITE_CLIP;
  psycho17_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  psycho17_config.gamma = RENODX_TONE_MAP_GAMMA;
  psycho17_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  psycho17_config.shadows = RENODX_TONE_MAP_SHADOWS;
  psycho17_config.contrast = RENODX_TONE_MAP_CONTRAST;
  psycho17_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  psycho17_config.contrast_highlights = RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS;
  psycho17_config.contrast_shadows = RENODX_TONE_MAP_CONTRAST_SHADOWS;
  psycho17_config.purity_scale = RENODX_TONE_MAP_SATURATION;
  psycho17_config.purity_highlights = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  psycho17_config.dechroma = RENODX_TONE_MAP_DECHROMA;
  psycho17_config.adaptation_contrast = RENODX_TONE_MAP_ADAPTATION_CONTRAST;
  psycho17_config.bleaching_intensity = 0.f;
  psycho17_config.hue_emulation = RENODX_TONE_MAP_HUE_EMULATION;
  psycho17_config.pre_gamut_compress = false;
  psycho17_config.post_gamut_compress = true;

  if (RENODX_TONE_MAP_TYPE == 1.f) {
    psycho17_config.apply_tonemap = false;
  }

  float3 hue_shift_source_bt2020 = color_bt2020;
  if (psycho17_config.hue_emulation != 0.f) {
    hue_shift_source_bt2020 = renodx::tonemap::ReinhardPiecewise(color_bt2020, 2.5f, psycho17_config.mid_gray);
  }
  color_bt2020 = renodx_custom::tonemap::psycho::ApplyTest17BT2020(color_bt2020, hue_shift_source_bt2020, psycho17_config);

  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_DIFFUSE_WHITE_NITS);

  return color_pq;
}
