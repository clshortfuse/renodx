#include "./shared.h"
#include "./common.hlsl"

float3 liftGammaGain(float3 input, float3 lift, float3 gamma, float3 gain){
  return sign(input) * pow(abs(input * gain + lift), gamma);
}

float3 liftGammaGainScaling(float3 lifted, float3 original, float3 lift, float3 gamma, float3 gain, int encoding = 0){
  // 0 - linear bt709, 1 - linear ap1, 2 - srgb
  if(injectedData.colorGradeInternalLUTScaling == 0.f){return lifted;} else {
    float3 new_gain = 2.f * (pow(liftGammaGain(0.5f, lift, gamma, gain), 1 / gamma) - liftGammaGain(0.f, lift, gamma, gain));
    float3 new_lift = pow(liftGammaGain(0.f, lift, gamma, gain), 1 / gamma);
    float3 unclamped = original < (0.5).xxx ? liftGammaGain(original, new_lift, gamma, new_gain) : lifted;
    float3 unclamped_linear;
    float3 lifted_linear;
    if(encoding == 2){
      lifted_linear = renodx::color::srgb::DecodeSafe(lifted);
      unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped);
    } else if (encoding == 1){
      lifted_linear = renodx::color::bt709::from::AP1(lifted);
      unclamped_linear = renodx::color::bt709::from::AP1(unclamped);
    } else if (encoding == 0) {
      lifted_linear = lifted;
      unclamped_linear = unclamped;
    }
    float lifted_y = renodx::color::y::from::BT709(abs(lifted_linear));
    float unclamped_y = renodx::color::y::from::BT709(abs(unclamped_linear));
    float3 scaled_linear = lifted_linear * renodx::math::DivideSafe(unclamped_y, lifted_y, 1.f);
    float3 output = lerp(lifted_linear, scaled_linear, injectedData.colorGradeInternalLUTScaling);
  if(encoding == 2){
    output = renodx::color::srgb::EncodeSafe(output);
  } else if (encoding == 1){
    output = renodx::color::ap1::from::BT709(output);
  } else if (encoding == 0) {}
  return output;
}
}

//-----TONEMAP-----//
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
    if (DiceConfig.reno_drt_hue_correction_method == 0) {
      perceptual_new = renodx::color::oklab::from::BT709(color);
    } else if (DiceConfig.reno_drt_hue_correction_method == 1) {
      perceptual_new = renodx::color::ictcp::from::BT709(color);
    } else if (DiceConfig.reno_drt_hue_correction_method == 2) {
      perceptual_new = renodx::color::dtucs::uvY::from::BT709(color).zxy;
    }
    if (DiceConfig.hue_correction_strength != 0.f) {
      float3 perceptual_old;
      if (DiceConfig.hue_correction_type == renodx::tonemap::config::hue_correction_type::INPUT) {
        DiceConfig.hue_correction_color = input;
      }
      if (DiceConfig.reno_drt_hue_correction_method == 0) {
        perceptual_old = renodx::color::oklab::from::BT709(DiceConfig.hue_correction_color);
      } else if (DiceConfig.reno_drt_hue_correction_method == 1) {
        perceptual_old = renodx::color::ictcp::from::BT709(DiceConfig.hue_correction_color);
      } else if (DiceConfig.reno_drt_hue_correction_method == 2) {
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
    if (DiceConfig.reno_drt_hue_correction_method == 0) {
      color = renodx::color::bt709::from::OkLab(perceptual_new);
    } else if (DiceConfig.reno_drt_hue_correction_method == 1) {
      color = renodx::color::bt709::from::ICtCp(perceptual_new);
    } else if (DiceConfig.reno_drt_hue_correction_method == 2) {
      color = renodx::color::bt709::from::dtucs::uvY(perceptual_new.yzx);
    }
  }
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

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

float3 vanillaACES(float3 color, int curve = 0, float DSG = 0.9811f) {
  float a;
  float b;
  float c;
  float d;
  float e;
  if (curve == 0) {
  a = 278.5085;
  b = 10.7772;
  c = 293.6045;
  d = 88.7122;
  e = 80.6889;
  } else if (curve == 1) {
  a = 2.785085;
  b = 0.107772;
  c = 2.936045;
  d = 0.887122;
  e = 0.806889;
  } else if (curve == 2 || curve == 3) {
  a = 0.0245786;
  b = 0.000090537;
  c = 0.983729;
  d = 0.4329510;
  e = 0.238081;
  } else if (curve == 4){
  a = 2.51;
  b = 0.03;
  c = 2.43;
  d = 0.59;
  e = 0.14;
  }
  color = mul(SRGB_to_ACES_MAT, color);
  color = RRT(color);
  if(curve == 2 || curve == 3){
    color = (color * (color + a) - b) / (color * (c * color + d) + e);
    color = max(0, color);
  } else {
    color = (color * (a * color + b)) / (color * (c * color + d) + e);
  }
  color = mul(renodx::color::AP1_TO_XYZ_MAT, color);
  color = renodx::tonemap::aces::DarkToDim(color, DSG);
  color = mul(renodx::color::XYZ_TO_AP1_MAT, color);
  float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;
  color = lerp(dot(color, AP1_RGB2Y).rrr, color, 0.93);
  if(curve == 4){
    color = renodx::color::bt709::from::AP1(color);
  } else {
    color = mul(renodx::color::AP1_TO_XYZ_MAT, color);
    color = mul(renodx::color::D60_TO_D65_MAT, color);
    color = mul(renodx::color::XYZ_TO_BT709_MAT, color);
  }
  return color;
}

float3 applyUserTonemapACES(float3 untonemapped, int curve = 0, float DSG = 0.9811f) {
  float3 outputColor;
  float midGray = vanillaACES(float3(0.18f, 0.18f, 0.18f), curve, DSG).x;
  float3 hueCorrectionColor = vanillaACES(untonemapped, curve, DSG);
  float defaultClip;
  if(curve == 2){
    defaultClip = 26.f;
  } else if (curve == 4){
    defaultClip = 8.f;
  } else {
    defaultClip = 100.f;
  }
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
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout * 0.875f;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  if (curve < 2) {
    config.reno_drt_shadows = 1.025f;
  }
  config.reno_drt_contrast = 1.6f;
  config.reno_drt_saturation = 0.9f;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = (int)injectedData.toneMapColorSpace;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? defaultClip : injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f && curve != 3) {
    outputColor = saturate(hueCorrectionColor);
  } else {
    outputColor = untonemapped;
  }
  return renodx::tonemap::config::Apply(outputColor, config);
}

float3 HDRBoost(float3 linear_color, float power = 0.20f, float normalization_point = 0.10f) {
  if (power == 0.f) return linear_color;
  const float MID_GRAY_LINEAR = 1 / (pow(10, 0.75));                          // ~0.18f
  const float MID_GRAY_PERCENT = 0.5f;                                        // 50%
  const float MID_GRAY_GAMMA = log(MID_GRAY_LINEAR) / log(MID_GRAY_PERCENT);  // ~2.49f
  float encode_gamma = MID_GRAY_GAMMA;
  float grayscale = renodx::color::y::from::BT709(linear_color.rgb);
  float encoded_gray = renodx::color::gamma::Encode(grayscale, encode_gamma);
  float3 gamma_color = renodx::color::gamma::EncodeSafe(linear_color, encode_gamma);
  float compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, encoded_gray);
  gamma_color = renodx::color::correct::GamutCompress(gamma_color, encoded_gray, compression_scale);
  linear_color = renodx::color::gamma::DecodeSafe(gamma_color, encode_gamma);
  float smoothing = power * 2.f;
  linear_color = max(linear_color, lerp(linear_color, normalization_point * pow(linear_color / normalization_point, 1.f + power), linear_color / ((linear_color / smoothing) + 1)));
  gamma_color = renodx::color::gamma::EncodeSafe(linear_color, encode_gamma);
  gamma_color = renodx::color::correct::GamutDecompress(gamma_color, compression_scale);
  linear_color = renodx::color::gamma::DecodeSafe(gamma_color, encode_gamma);
  return linear_color;
}

float3 applyUserTonemapNeutral(float3 untonemapped, float peak = 0) {
  float3 outputColor;
  float midGray = renodx::tonemap::unity::BT709(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = renodx::tonemap::unity::BT709(untonemapped);
  if(peak == 0){
    peak = injectedData.toneMapPeakNits;
  }
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType >= 2.f ? 3.f : injectedData.toneMapType;
  config.peak_nits = peak;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType - 2.f;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 4.f : injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(hueCorrectionColor);
  } else {
    outputColor = untonemapped;
  }
return renodx::tonemap::config::Apply(outputColor, config);
}

float3 applyUserNoTonemap(float3 untonemapped) {
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
  config.hue_correction_color = lerp(untonemapped, renodx::tonemap::renodrt::NeutralSDR(untonemapped, true), injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 2.f * (injectedData.toneMapPeakNits / injectedData.toneMapGameNits) : injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
    outputColor = max(0.f, outputColor);
  } else {
    outputColor = HDRBoost(outputColor, injectedData.fxHdrBoost);
  }
  if (injectedData.toneMapType == 2.f) {
    outputColor = applyFrostbite(outputColor, config);
  } else if (injectedData.toneMapType == 4.f) {
    outputColor = applyDICE(outputColor, config);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }
  return outputColor;
}

float3 vanillaNarkACES(float3 color) {
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  return (color * (a * color + b)) / (color * (c * color + d) + e);
}

// Windbound
float3 applyUserTonemapSapphire(float3 untonemapped) {
  float3 outputColor;
  float midGray = vanillaNarkACES(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaNarkACES(untonemapped);
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
  config.reno_drt_contrast = 1.6f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 8.f : injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(hueCorrectionColor);
  } else {
    outputColor = untonemapped;
  }
return renodx::tonemap::config::Apply(outputColor, config);
}