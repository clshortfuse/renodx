#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen, bool colored) {
  float3 grainedColor;
  if (colored == true) {
    grainedColor = renodx::effects::ApplyFilmGrainColored(
        outputColor,
        screen,
        float3(
            injectedData.random_1,
            injectedData.random_2,
            injectedData.random_3),
        injectedData.fxFilmGrain * 0.01f,
        1.f);
  } else {
    grainedColor = renodx::effects::ApplyFilmGrain(
        outputColor,
        screen,
        injectedData.random_1,
        injectedData.fxFilmGrain * 0.03f,
        1.f);
  }
  return grainedColor;
}

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
      if(injectedData.toneMapGammaCorrection == 2.f){
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::correct::GammaSafe(color, true, 2.4f);
    } else if(injectedData.toneMapGammaCorrection == 1.f){
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::correct::GammaSafe(color, true, 2.2f);
    } else {
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    }
  return color;
}

float3 FinalizeOutput(float3 color) {
  	  if(injectedData.toneMapGammaCorrection == 2.f){
	  color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  	} else if(injectedData.toneMapGammaCorrection == 1.f){
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
    }
    color *= injectedData.toneMapUINits;
      if(injectedData.toneMapType == 0.f){
    color = renodx::color::bt709::clamp::BT709(color);
    } else {
    color = renodx::color::bt709::clamp::BT2020(color);
    }
  	color /= 80.f;
  	return color;
}

// logc c1000 custom encoding
static const float arri_a = renodx::color::arri::logc::c1000::PARAMS.a;
static const float arri_b = renodx::color::arri::logc::c1000::PARAMS.b;
static const float arri_c = renodx::color::arri::logc::c1000::PARAMS.c;
static const float arri_d = renodx::color::arri::logc::c1000::PARAMS.d;

float3 arriDecode(float3 color) {
  return (pow(10.f, (color - arri_d) / arri_c) - arri_b) / arri_a;
}

float3 lutShaper(float3 color, bool builder = false){
		if(injectedData.colorGradeLUTShaper == 0.f){
    color = builder ? arriDecode(color)
					: saturate(renodx::color::arri::logc::c1000::Encode(color));
    } else {
    color = builder ? renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(color, 100.f))
					: renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color), 100.f);
    }
return color;
}

//-----TONEMAP-----//
static const float3x3 ACES_to_ACEScg_MAT = float3x3(
    1.4514393161f, -0.2365107469f, -0.2149285693f,
    -0.0765537734f, 1.1762296998f, -0.0996759264f,
    0.0083161484f, -0.0060324498f, 0.9977163014f);

static const float3x3 SRGB_to_ACES_MAT = float3x3(
    0.4397010, 0.3829780, 0.1773350,
    0.0897923, 0.8134230, 0.0967616,
    0.0175440, 0.1115440, 0.8707040);

static const float3x3 ACES_to_SRGB_MAT = float3x3(
    2.52169, -1.13413, -0.38756,
    -0.27648, 1.37272, -0.09624,
    -0.01538, -0.15298, 1.16835);

float3 RRT(float3 aces) {
  static const float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;

  // --- Glow module --- //
  // "Glow" module constants
  static const float RRT_GLOW_GAIN = 0.05;
  static const float RRT_GLOW_MID = 0.08;
  float saturation = renodx::tonemap::aces::Rgb2Saturation(aces);
  float yc_in = renodx::tonemap::aces::Rgb2Yc(aces);
  const float s = renodx::tonemap::aces::SigmoidShaper((saturation - 0.4) / 0.2);
  float added_glow = 1.0 + renodx::tonemap::aces::GlowFwd(yc_in, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= added_glow;

  // --- Red modifier --- //
  // Red modifier constants
  static const float RRT_RED_SCALE = 0.82;
  static const float RRT_RED_PIVOT = 0.03;
  static const float RRT_RED_HUE = 0.;
  static const float RRT_RED_WIDTH = 135.;
  float hue = renodx::tonemap::aces::Rgb2Hue(aces);
  const float centered_hue = renodx::tonemap::aces::CenterHue(hue, RRT_RED_HUE);
  float hue_weight;
  {
    // hueWeight = cubic_basis_shaper(centeredHue, RRT_RED_WIDTH);
    hue_weight = smoothstep(0.0, 1.0, 1.0 - abs(2.0 * centered_hue / RRT_RED_WIDTH));
    hue_weight *= hue_weight;
  }

  aces.r += hue_weight * saturation * (RRT_RED_PIVOT - aces.r) * (1. - RRT_RED_SCALE);

  // --- ACES to RGB rendering space --- //
  aces = clamp(aces, 0, 65535.0f);
  float3 rgb_pre = mul(ACES_to_ACEScg_MAT, aces);
  rgb_pre = clamp(rgb_pre, 0, 65504.0f);

  // --- Global desaturation --- //
  // rgbPre = mul( RRT_SAT_MAT, rgbPre);
  static const float RRT_SAT_FACTOR = 0.96f;
  rgb_pre = lerp(dot(rgb_pre, AP1_RGB2Y).xxx, rgb_pre, RRT_SAT_FACTOR);

  return rgb_pre;
}

float3 vanillaTonemap(float3 color){
static const float a = 278.5085;
static const float b = 10.7772;
static const float c = 293.6045;
static const float d = 88.7122;
static const float e = 80.6889;
	color = mul(SRGB_to_ACES_MAT, color);
	color = RRT(color);
  color = (color * (a * color + b)) / (color * (c * color + d) + e);
  color = mul(renodx::color::AP1_TO_XYZ_MAT, color);
  color = renodx::tonemap::aces::DarkToDim(color);
  color = mul(renodx::color::XYZ_TO_AP1_MAT, color);
  float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;
  color = lerp(dot(color, AP1_RGB2Y).rrr, color, 0.93);
  color = mul(renodx::color::AP1_TO_XYZ_MAT, color);
  color = mul(renodx::color::D60_TO_D65_MAT, color);
  color = mul(renodx::color::XYZ_TO_BT709_MAT, color);
return color;
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;
  float midGray = renodx::color::y::from::BT709(vanillaTonemap(float3(0.18f, 0.18f, 0.18f)));
  float3 hueCorrectionColor = vanillaTonemap(untonemapped);
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
  config.reno_drt_shadows = 1.06f;
  config.reno_drt_contrast = 1.6f;
  config.reno_drt_saturation = 0.92f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = (uint)injectedData.toneMapColorSpace;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(hueCorrectionColor);
  } else {
    outputColor = untonemapped;
  }
return renodx::tonemap::config::Apply(outputColor, config);
}

float3 applyFrostbite(float3 input, renodx::tonemap::Config FbConfig, bool sdr = false) {
  float3 color = input;
  float FbPeak = sdr ? 1.f : FbConfig.peak_nits / FbConfig.game_nits;
  if (FbConfig.gamma_correction != 0.f && sdr == false) {
    FbPeak = renodx::color::correct::Gamma(FbPeak, FbConfig.gamma_correction > 0.f, abs(FbConfig.gamma_correction) == 1.f ? 2.2f : 2.4f);
  }
  float y = renodx::color::y::from::BT709(color * FbConfig.exposure);
  color = renodx::color::grade::UserColorGrading(color, FbConfig.exposure, FbConfig.highlights, FbConfig.shadows, FbConfig.contrast);
  color = renodx::tonemap::frostbite::BT709(color, FbPeak, injectedData.toneMapShoulderStart, injectedData.colorGradeBlowout / 2.f, injectedData.toneMapHueCorrection);

  if (FbConfig.saturation != 1.f || FbConfig.reno_drt_dechroma != 0.f) {
    float3 perceptual_new = renodx::color::ictcp::from::BT709(color);

    if (FbConfig.reno_drt_dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - FbConfig.reno_drt_dechroma))));
    }

    perceptual_new.yz *= FbConfig.saturation;

    color = renodx::color::bt709::from::ICtCp(perceptual_new);
  }
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 DICEMap(float3 color, float output_luminance_max, float highlights_shoulder_start = 0.f,
               float highlights_modulation_pow = 1.f, bool perChannel = true) {
  if (!perChannel) {
    const float source_luminance = renodx::color::y::from::BT709(color);
    if (source_luminance > 0.0f) {
      const float compressed_luminance =
          renodx::tonemap::dice::internal::LuminanceCompress(source_luminance, output_luminance_max, highlights_shoulder_start, false,
                                                             renodx::math::FLT_MAX, highlights_modulation_pow);
      color *= compressed_luminance / source_luminance;
    }
    return color;
  } else {
    color.r = renodx::tonemap::dice::internal::LuminanceCompress(color.r, output_luminance_max, highlights_shoulder_start, false,
                                                                 renodx::math::FLT_MAX, highlights_modulation_pow);
    color.g = renodx::tonemap::dice::internal::LuminanceCompress(color.g, output_luminance_max, highlights_shoulder_start, false,
                                                                 renodx::math::FLT_MAX, highlights_modulation_pow);
    color.b = renodx::tonemap::dice::internal::LuminanceCompress(color.b, output_luminance_max, highlights_shoulder_start, false,
                                                                 renodx::math::FLT_MAX, highlights_modulation_pow);
    return color;
  }
}

float3 applyDICE(float3 input, renodx::tonemap::Config DiceConfig, bool sdr = false) {
  float3 color = input;
  float DicePaperWhite = DiceConfig.game_nits / 80.f;
  float DicePeak = sdr ? DicePaperWhite : DiceConfig.peak_nits / 80.f;
  if (DiceConfig.gamma_correction != 0.f && sdr == false) {
    DicePaperWhite = renodx::color::correct::Gamma(DicePaperWhite, DiceConfig.gamma_correction > 0.f, abs(DiceConfig.gamma_correction) == 1.f ? 2.2f : 2.4f);
    DicePeak = renodx::color::correct::Gamma(DicePeak, DiceConfig.gamma_correction > 0.f, abs(DiceConfig.gamma_correction) == 1.f ? 2.2f : 2.4f);
  }

  float y = renodx::color::y::from::BT709(color * DiceConfig.exposure);
  color = renodx::color::grade::UserColorGrading(color, DiceConfig.exposure, DiceConfig.highlights, DiceConfig.shadows, DiceConfig.contrast);
  color = DICEMap(color * DicePaperWhite, DicePeak, injectedData.toneMapShoulderStart * DicePaperWhite, 1.f, DiceConfig.reno_drt_per_channel) / DicePaperWhite;

  if (DiceConfig.saturation != 1.f || DiceConfig.hue_correction_strength != 0.f || DiceConfig.reno_drt_blowout != 0.f || DiceConfig.reno_drt_dechroma != 0.f) {
    float3 perceptual_new;

    if (DiceConfig.reno_drt_hue_correction_method == 0u) {
      perceptual_new = renodx::color::oklab::from::BT709(color);
    } else if (DiceConfig.reno_drt_hue_correction_method == 1u) {
      perceptual_new = renodx::color::ictcp::from::BT709(color);
    } else if (DiceConfig.reno_drt_hue_correction_method == 2u) {
      perceptual_new = renodx::color::dtucs::uvY::from::BT709(color).zxy;
    }

    if (DiceConfig.hue_correction_strength != 0.f) {
      float3 perceptual_old;
      if (DiceConfig.hue_correction_type == renodx::tonemap::config::hue_correction_type::INPUT) {
        DiceConfig.hue_correction_color = input;
      }
      if (DiceConfig.reno_drt_hue_correction_method == 0u) {
        perceptual_old = renodx::color::oklab::from::BT709(DiceConfig.hue_correction_color);
      } else if (DiceConfig.reno_drt_hue_correction_method == 1u) {
        perceptual_old = renodx::color::ictcp::from::BT709(DiceConfig.hue_correction_color);
      } else if (DiceConfig.reno_drt_hue_correction_method == 2u) {
        perceptual_old = renodx::color::dtucs::uvY::from::BT709(DiceConfig.hue_correction_color).zxy;
      }

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, DiceConfig.hue_correction_strength);

      float chrominance_post_adjust = distance(perceptual_new.yz, 0);

      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }

    if (DiceConfig.reno_drt_dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - DiceConfig.reno_drt_dechroma))));
    }

    if (DiceConfig.reno_drt_blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(DiceConfig.reno_drt_blowout));
      if (DiceConfig.reno_drt_blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= DiceConfig.saturation;

    if (DiceConfig.reno_drt_hue_correction_method == 0u) {
      color = renodx::color::bt709::from::OkLab(perceptual_new);
    } else if (DiceConfig.reno_drt_hue_correction_method == 1u) {
      color = renodx::color::bt709::from::ICtCp(perceptual_new);
    } else if (DiceConfig.reno_drt_hue_correction_method == 2u) {
      color = renodx::color::bt709::from::dtucs::uvY(perceptual_new.yzx);
    }
  }
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 applyUserTonemapAlt(float3 untonemapped) {
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
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, renodx::tonemap::renodrt::NeutralSDR(untonemapped), injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(outputColor);
  }
  if (injectedData.toneMapType == 2.f) {  // Frostbite
    outputColor = applyFrostbite(outputColor, config);
  } else if (injectedData.toneMapType == 5.f) {  // DICE
    outputColor = applyDICE(outputColor, config);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }
  return outputColor;
}

float3 applyUserTonemapTC(float3 untonemapped, Texture2D lutTexture, SamplerState lutSampler, float3 preCompute) {
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
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, renodx::tonemap::renodrt::NeutralSDR(untonemapped), injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = injectedData.colorGradeLUTStrength;
  lut_config.scaling = injectedData.colorGradeLUTScaling;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.precompute = preCompute;
  lut_config.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(untonemapped);
  } else {
    outputColor = untonemapped;
  }
  if (injectedData.toneMapType == 2.f) {  // Frostbite
    float previous_lut_config_strength = lut_config.strength;
    lut_config.strength = 1.f;
    float3 sdrColor = applyFrostbite(outputColor, config, true);
    float3 hdrColor = applyFrostbite(outputColor, config);
    float3 lutColor = renodx::lut::Sample(lutTexture, lut_config, sdrColor);
    outputColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, lutColor, previous_lut_config_strength);
  } else if (injectedData.toneMapType == 5.f) {  // DICE
    float previous_lut_config_strength = lut_config.strength;
    lut_config.strength = 1.f;
    float3 sdrColor = applyDICE(outputColor, config, true);
    float3 hdrColor = applyDICE(outputColor, config);
    float3 lutColor = renodx::lut::Sample(lutTexture, lut_config, sdrColor);
    outputColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, lutColor, previous_lut_config_strength);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config, lut_config, lutTexture);
  }
  return outputColor;
}