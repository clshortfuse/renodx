#include "./shared.h"


float3 ColorPicker(float3 color, float3 sdr_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return sdr_color;
  }
  return color;
}

// float GetPostProcessingMaxCLL() {
//   return CUSTOM_POST_MAXCLL;
// }

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float3 UpgradeToneMapWithoutHueCorrection(
    float3 color_untonemapped,
    float3 color_tonemapped,
    float3 color_tonemapped_graded,
    float post_process_strength = 1.f,
    float auto_correction = 0.f) {
  float ratio = 1.f;

  float y_untonemapped = renodx::color::y::from::BT709(abs(color_untonemapped));
  float y_tonemapped = renodx::color::y::from::BT709(abs(color_tonemapped));
  float y_tonemapped_graded = renodx::color::y::from::BT709(abs(color_tonemapped_graded));

  if (y_untonemapped < y_tonemapped) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    ratio = y_untonemapped / y_tonemapped;
  } else {
    float y_delta = y_untonemapped - y_tonemapped;
    y_delta = max(0, y_delta);  // Cleans up NaN
    const float y_new = y_tonemapped_graded + y_delta;

    const bool y_valid = (y_tonemapped_graded > 0);  // Cleans up NaN and ignore black
    ratio = y_valid ? (y_new / y_tonemapped_graded) : 0;
  }
  float auto_correct_ratio = lerp(1.f, ratio, saturate(y_untonemapped));
  ratio = lerp(ratio, auto_correct_ratio, auto_correction);

  float3 color_scaled = color_tonemapped_graded * ratio;
  // Match hue
  //color_scaled = renodx::color::correct::Hue(color_scaled, color_tonemapped_graded);
  return lerp(color_untonemapped, color_scaled, post_process_strength);
}

float3 CustomUpgradeToneMap(float3 untonemapped, float3 tonemapped_bt709, float mid_gray) {
  if (RENODX_TONE_MAP_TYPE == 0) {
    return tonemapped_bt709;
  }
  else {
    float mid_gray_scale = mid_gray / 0.18f;
    float3 untonemapped_midgray = untonemapped * mid_gray_scale;
    float3 hdr_color;
    float3 outputColor;
    //tonemapped_bt709 = saturate(tonemapped_bt709);
    if (CUSTOM_SCENE_GRADE_METHOD == 1.f) {
      tonemapped_bt709 = renodx::draw::ApplyPerChannelCorrection(
          untonemapped_midgray,
          tonemapped_bt709,
          CUSTOM_SCENE_GRADE_BLOWOUT_RESTORATION,
          CUSTOM_SCENE_GRADE_HUE_CORRECTION,
          CUSTOM_SCENE_GRADE_SATURATION_CORRECTION,
          CUSTOM_SCENE_GRADE_HUE_SHIFT);
      
      //hdr_color = lerp(tonemapped_bt709, untonemapped_midgray, saturate(tonemapped_bt709));
      //outputColor = renodx::color::correct::Hue(hdr_color, tonemapped_bt709, CUSTOM_SCENE_GRADE_HUE_CORRECTION, 0);

      outputColor = renodx::tonemap::UpgradeToneMap(untonemapped_midgray, ToneMapMaxCLL(untonemapped_midgray), tonemapped_bt709, RENODX_COLOR_GRADE_STRENGTH);
    }
    else {
      //hdr_color = lerp(tonemapped_bt709, untonemapped_midgray, saturate(tonemapped_bt709));
      //outputColor = renodx::color::correct::Hue(hdr_color, tonemapped_bt709, CUSTOM_SCENE_GRADE_HUE_CORRECTION, 0);
      //outputColor = hdr_color;
      outputColor = renodx::tonemap::UpgradeToneMap(untonemapped_midgray, ToneMapMaxCLL(untonemapped_midgray), tonemapped_bt709, RENODX_COLOR_GRADE_STRENGTH);


      //outputColor = renodx::color::correct::Hue(outputColor, tonemapped_bt709);
    }
    return outputColor;
  }
}

float3 CustomUpgradeGrading(float3 ungraded, float3 ungraded_sdr, float3 graded) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return lerp(ungraded, graded, CUSTOM_LUT_STRENGTH);
  }
  //float3 neutral_sdr = ToneMapMaxCLL(ungraded);
  return renodx::draw::UpgradeToneMapByLuminance(ungraded, ungraded_sdr, graded, CUSTOM_LUT_STRENGTH);
}

float3 applyDice(float3 color, float paperWhite = RENODX_DIFFUSE_WHITE_NITS, float peakWhite = RENODX_PEAK_WHITE_NITS) {
  paperWhite = paperWhite / renodx::color::srgb::REFERENCE_WHITE;
  peakWhite = peakWhite / renodx::color::srgb::REFERENCE_WHITE;
  const float highlightsShoulderStart = paperWhite;
  return renodx::tonemap::dice::BT709(color * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
}

renodx::draw::Config SdrConfig() {
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.peak_white_nits = 80.f;
  config.diffuse_white_nits = 80.f;
  config.graphics_white_nits = 80.f;
  config.reno_drt_white_clip = 1.5f;
  return config;
}

float3 CustomTonemap(float3 color, renodx::draw::Config config = renodx::draw::BuildConfig()) {
  // renodx::draw::Config config = renodx::draw::BuildConfig();
  // config.reno_drt_tone_map_method = renodx::draw::TONE_MAP_TYPE_UNTONEMAPPED;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  //config.peak_white_nits = 10000.f;
  float3 outputColor = renodx::draw::ToneMapPass(color, config);
  //float3 outputColor = applyDice(color, RENODX_DIFFUSE_WHITE_NITS, RENODX_PEAK_WHITE_NITS);

  //float peakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  //float paperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  return outputColor;
  //return ToneMapMaxCLL(outputColor, paperWhite, peakWhite);
}



// float3 CustomDisplayMap(float3 color) {
//   if (RENODX_TONE_MAP_TYPE == 0.f || RENODX_TONE_MAP_TYPE == 1.f) {
//     return color;
//   }
//   if (RENODX_TONE_MAP_TYPE == 2.f) {
//     return applyDice(color);
//   }
//   return color;
// }

float GetSunshaftScale() {
  return CUSTOM_SUNSHAFTS_STRENGTH;
}

float GetBloomScale() {
  return CUSTOM_BLOOM;
}

// float3 CustomColorTemp(float3 color) {
//   if (RENODX_TONE_MAP_TYPE == 0.f) {
//     return color;
//   }
//   if (RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE == renodx::draw::COLOR_SPACE_CUSTOM_BT709D93) {
//     color = renodx::color::convert::ColorSpaces(color, RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE, renodx::color::convert::COLOR_SPACE_BT709);
//     color = renodx::color::bt709::from::BT709D93(color);
//     RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE = renodx::color::convert::COLOR_SPACE_BT709;
//   } else if (RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE == renodx::draw::COLOR_SPACE_CUSTOM_NTSCU) {
//     color = renodx::color::convert::ColorSpaces(color, RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE, renodx::color::convert::COLOR_SPACE_BT709);
//     color = renodx::color::bt709::from::BT601NTSCU(color);
//     RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE = renodx::color::convert::COLOR_SPACE_BT709;
//   } else if (RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE == renodx::draw::COLOR_SPACE_CUSTOM_NTSCJ) {
//     color = renodx::color::convert::ColorSpaces(color, RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE, renodx::color::convert::COLOR_SPACE_BT709);
//     color = renodx::color::bt709::from::ARIBTRB9(color);
//     RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE = renodx::color::convert::COLOR_SPACE_BT709;
//   }
//   return color;
// }

float3 CustomBloomTonemap(float3 color, float exposure = 0.2f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  // return ToneMapMaxCLL(color, 0.2f, GetPostProcessingMaxCLL());
  // return ToneMapMaxCLL(color, exposure, GetPostProcessingMaxCLL());
  return min(color, CUSTOM_BLOOM);
}

float3 CustomSunshaftsTonemap(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  // return ToneMapMaxCLL(color, 0.2f, GetPostProcessingMaxCLL());
  // return ToneMapMaxCLL(color, 0.2f, GetPostProcessingMaxCLL());
  //return color;
  return min(color, CUSTOM_SUNSHAFTS_STRENGTH);
}

float4 HandleUICompositing(float4 ui_color_linear, float4 scene_color_linear) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    ui_color_linear = renodx::color::correct::GammaSafe(ui_color_linear, false, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    ui_color_linear = renodx::color::correct::GammaSafe(ui_color_linear, false, 2.4f);
  }

  ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  float3 ui_color;
  ui_color.rgb = renodx::color::srgb::EncodeSafe(ui_color_linear.rgb);

  float3 scene_color_srgb = renodx::color::srgb::EncodeSafe(scene_color_linear.rgb);

  // Blend in SRGB based on opacity
  float3 composited_color = lerp(scene_color_srgb, ui_color.rgb, saturate(ui_color_linear.a));
  float3 linear_color = renodx::color::srgb::DecodeSafe(composited_color);

  float4 output_color;
  output_color.rgb = linear_color;
  output_color.a = ui_color_linear.a;

  // float3 bt2020_color = renodx::color::bt2020::from::BT709(linear_color);
  // float3 pq_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);
  // output_color = float4(pq_color, 1.f);
  return output_color;
}

float hdrSaturate(float color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return saturate(color);
  }
  color = max(color, 0.f);
  //color = min(color, 100.f);
  return color;
}