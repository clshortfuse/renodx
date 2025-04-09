#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen) {
  float3 grainedColor = renodx::effects::ApplyFilmGrain(
        outputColor,
        screen,
        injectedData.random,
        injectedData.fxFilmGrain * 0.03f,
        1.f);
  return grainedColor;
}

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 FinalizeOutput(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  color *= injectedData.toneMapUINits;
  //color = min(color, injectedData.toneMapPeakNits);
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
  } else {
    color = renodx::color::bt709::clamp::BT2020(color);
  }
  color /= 80.f;
  return color;
}

//-----TONEMAP-----//
float UpgradeToneMapRatio(float ap1_color_hdr, float ap1_color_sdr, float ap1_post_process_color) {
  if (ap1_color_hdr < ap1_color_sdr) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return ap1_color_hdr / ap1_color_sdr;
  } else {
    float ap1_delta = ap1_color_hdr - ap1_color_sdr;
    ap1_delta = max(0, ap1_delta);  // Cleans up NaN
    const float ap1_new = ap1_post_process_color + ap1_delta;

    const bool ap1_valid = (ap1_post_process_color > 0);  // Cleans up NaN and ignore black
    return ap1_valid ? (ap1_new / ap1_post_process_color) : 0;
  }
}

float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  // float ratio = 1.f;

  float3 bt2020_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
  float3 bt2020_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
  float3 bt2020_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));

  float3 ratio = float3(
      UpgradeToneMapRatio(bt2020_hdr.r, bt2020_sdr.r, bt2020_post_process.r),
      UpgradeToneMapRatio(bt2020_hdr.g, bt2020_sdr.g, bt2020_post_process.g),
      UpgradeToneMapRatio(bt2020_hdr.b, bt2020_sdr.b, bt2020_post_process.b));

  float3 color_scaled = max(0, bt2020_post_process * ratio);
  color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
  float peak_correction = saturate(1.f - renodx::color::y::from::BT2020(bt2020_post_process));
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color, peak_correction);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 UpgradeToneMapByLuminance(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  // float ratio = 1.f;

  float3 bt2020_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
  float3 bt2020_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
  float3 bt2020_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));

  float ratio = UpgradeToneMapRatio(
      renodx::color::y::from::BT2020(bt2020_hdr),
      renodx::color::y::from::BT2020(bt2020_sdr),
      renodx::color::y::from::BT2020(bt2020_post_process));

  float3 color_scaled = max(0, bt2020_post_process * ratio);
  color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 Apply(float3 inputColor, renodx::tonemap::Config tm_config, renodx::lut::Config lut_config, Texture3D lutTexture, bool perChannel) {
  if (lut_config.strength == 0.f || tm_config.type == 1.f) {
    return renodx::tonemap::config::Apply(inputColor, tm_config);
  } else {
    renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(inputColor, tm_config);
    float3 color_hdr = tone_maps.color_hdr;
    float3 color_sdr = tone_maps.color_sdr;

    float previous_lut_config_strength = lut_config.strength;
    lut_config.strength = 1.f;
    float3 color_lut = renodx::lut::Sample(lutTexture, lut_config, color_sdr);
    if (tm_config.type == 0.f) {
      return lerp(inputColor, color_lut, previous_lut_config_strength);
    } else if (perChannel == true) {
      return UpgradeToneMapPerChannel(color_hdr, color_sdr, color_lut, previous_lut_config_strength);
    } else {
      return UpgradeToneMapByLuminance(color_hdr, color_sdr, color_lut, previous_lut_config_strength);
    }
  }
}

float3 applyUserTonemap(float3 untonemapped, Texture3D lutTexture, SamplerState lutSampler, float3 vanilla, float midGray) {
  float3 outputColor;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, injectedData.toneMapType);
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_contrast = 1.f;
  config.reno_drt_saturation = 1.2f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.1f * pow(injectedData.colorGradeFlare, 5.32192809489);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapPerChannel != 0.f
                                       ? (1.f - injectedData.toneMapHueCorrection)
                                       : injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, vanilla, injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = injectedData.colorGradeLUTStrength;
  lut_config.scaling = 0.f;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.size = 32;
  lut_config.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(vanilla);
  } else {
    outputColor = untonemapped;
  }
return Apply(outputColor, config, lut_config, lutTexture, injectedData.upgradePerChannel != 0.f);
}

float3 Apply(float3 inputColor, renodx::tonemap::Config tm_config, renodx::lut::Config lut_config, Texture3D lutTexture, bool perChannel, float3 bloom) {
  float peak = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
  if (injectedData.toneMapGammaCorrection != 0.f) {
    peak = renodx::color::correct::Gamma(peak, injectedData.toneMapGammaCorrection > 0.f, injectedData.toneMapGammaCorrection == 1.f ? 2.2f : 2.4f);
  }
  if (lut_config.strength == 0.f || tm_config.type == 1.f) {
    float3 outputColor = renodx::tonemap::config::Apply(inputColor, tm_config) + bloom;
    if (injectedData.toneMapType != 1.f) {
      outputColor = min(peak, outputColor);
    }
    return outputColor;
  } else {
    renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(inputColor, tm_config);
    float3 color_hdr = tone_maps.color_hdr + bloom;
    float3 color_sdr = tone_maps.color_sdr + bloom;

    color_hdr = min(peak, color_hdr);
    color_sdr = min(1.f, color_sdr);

    float previous_lut_config_strength = lut_config.strength;
    lut_config.strength = 1.f;
    float3 color_lut = renodx::lut::Sample(lutTexture, lut_config, color_sdr);
    if (tm_config.type == 0.f) {
      return lerp(inputColor, color_lut, previous_lut_config_strength);
    } else if (perChannel == true) {
      return UpgradeToneMapPerChannel(color_hdr, color_sdr, color_lut, previous_lut_config_strength);
    } else {
      return UpgradeToneMapByLuminance(color_hdr, color_sdr, color_lut, previous_lut_config_strength);
    }
  }
}

float3 applyUserTonemap(float3 untonemapped, Texture3D lutTexture, SamplerState lutSampler, float3 vanilla, float3 bloom, float midGray) {
  float3 outputColor = untonemapped;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, injectedData.toneMapType);
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_contrast = 1.f;
  config.reno_drt_saturation = 1.1f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.075f * pow(injectedData.colorGradeFlare, 4.32192809489);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapPerChannel != 0.f
                                       ? (1.f - injectedData.toneMapHueCorrection)
                                       : injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, vanilla, injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = injectedData.colorGradeLUTStrength;
  lut_config.scaling = 0.f;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.size = 32;
  lut_config.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(vanilla + bloom);
    outputColor = renodx::tonemap::config::Apply(outputColor, config, lut_config, lutTexture);
  } else {
    bloom = renodx::color::grade::UserColorGrading(bloom, config.exposure, 1.f, 1.f, 1.f, config.saturation, config.reno_drt_dechroma, injectedData.toneMapHueCorrection, renodx::tonemap::renodrt::NeutralSDR(bloom));
    outputColor = Apply(outputColor, config, lut_config, lutTexture, injectedData.upgradePerChannel != 0.f, bloom);
  }
  return outputColor;
}
