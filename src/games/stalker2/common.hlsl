#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.1f;      // Approximately 44%

float3 CorrectGamma(float3 color) {
  color = renodx::color::correct::GammaSafe(color);
  return color;
}

float3 DecodedTosRGB(float3 input_linear) {
  if (injectedData.toneMapType > 1.f) {
    input_linear = renodx::color::srgb::EncodeSafe(saturate(input_linear));
    input_linear = saturate(input_linear);
  }
  return input_linear;
}

float3 PQToDecoded(float3 input_pq) {
  float3 output = input_pq;
  if (injectedData.toneMapType > 1.f) {
    output = renodx::color::pq::Decode(input_pq, injectedData.toneMapGameNits);
  }

  return output;
}

float3 UpgradePostProcess(float3 tonemappedRender, float3 post_processed, float lerpValue = 1.f) {
  float3 output = post_processed;
  if (injectedData.toneMapType == 1.f) {
    output = tonemappedRender;
  } else if (injectedData.toneMapType > 1.f) {
    if (lerpValue == 0.f) {
      output = renodx::color::pq::Encode(tonemappedRender, injectedData.toneMapGameNits);
    } else {
      post_processed = renodx::color::srgb::DecodeSafe(post_processed);
      output = renodx::tonemap::UpgradeToneMap(tonemappedRender, saturate(tonemappedRender), saturate(post_processed), lerpValue);
      output = renodx::color::pq::Encode(output, injectedData.toneMapGameNits);
    }
  }

  return output;
}

// Adjust this function as needed
float3 ProcessLUT(SamplerState sampler, Texture2D texture, float3 color) {
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      sampler,
      injectedData.toneMapType == 2.f ? 0.f : injectedData.colorGradeLUTStrength,
      0.f,
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::SRGB,
      16.f);

  return renodx::lut::Sample(texture, lut_config, color);
}

bool TonemapConditon(uint output_type = 3u) {
  return injectedData.toneMapType != 0.f && (output_type >= 3u && output_type <= 6u);
}

// Adjust this function as needed
void Tonemap(in float3 ap1_graded_color, in float3 ap1_aces_colored, out float3 hdr_color, out float3 sdr_color, inout float3 sdr_ap1_color) {
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 1.f;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;

  if (injectedData.toneMapPerChannel == 1.f) {
    config.reno_drt_per_channel = true;
  }
  
  config.reno_drt_highlights = 1.0f;
  config.reno_drt_shadows = 1.0f;
  // config.reno_drt_contrast = 1.1f;
  config.reno_drt_saturation = 1.1f;
  config.reno_drt_dechroma = 0;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  // config.reno_drt_flare = 0.05f;
  config.reno_drt_working_color_space = 2u;

  float3 bt709_graded_color = renodx::color::bt709::from::AP1(ap1_graded_color);
  float3 bt709_aces_color = renodx::color::bt709::from::AP1(ap1_aces_colored);

  config.hue_correction_type =
      renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_color = bt709_aces_color;

  // config.hue_correction_color = color;
  /* if (injectedData.toneMapHueCorrectionMethod == 1.f) {
    config.hue_correction_color = renodx::tonemap::ACESFittedAP1(bt709_graded_color);
  } else if (injectedData.toneMapHueCorrectionMethod == 2.f) {
    config.hue_correction_color = renodx::tonemap::uncharted2::BT709(bt709_graded_color * 2.f);
  } else if (injectedData.toneMapHueCorrectionMethod == 3.f) {
    config.hue_correction_color = bt709_aces_color;
  } else {
    config.hue_correction_type =
        renodx::tonemap::config::hue_correction_type::INPUT;
  } */

  renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(bt709_graded_color, config);
  hdr_color = dual_tone_map.color_hdr;
  sdr_color = dual_tone_map.color_sdr;
  sdr_ap1_color = renodx::color::ap1::from::BT709(sdr_color);
}

// CorrectGamma in final shader causes bugs to FSR3 FG
void FinalizeTonemap(inout float3 final_color, in float3 film_graded_color, in float3 hdr_color, in float3 sdr_color) {
  final_color = saturate(film_graded_color);

  if (injectedData.toneMapType != 1.f) {
    final_color = renodx::tonemap::UpgradeToneMap(hdr_color, sdr_color, final_color, 1.f);
  } else {
    final_color = hdr_color;
  }
  final_color = renodx::color::bt2020::from::BT709(final_color);
  final_color = CorrectGamma(final_color);
  final_color = renodx::color::pq::Encode(final_color, injectedData.toneMapGameNits);
}

// For SDR -> HDR games
float3 FinalizeOutput(float3 color) {
  color = renodx::color::gamma::DecodeSafe(color);
  color *= injectedData.toneMapUINits;
  color = min(color, injectedData.toneMapPeakNits);  // Clamp UI or Videos

  color /= 80.f;  // or PQ
  return color;
}

// For SDR -> HDR games
float3 ScalePaperWhite(float3 color) {
  color = renodx::color::srgb::EncodeSafe(color);
  color = renodx::color::gamma::DecodeSafe(color);
  color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  color = renodx::color::gamma::EncodeSafe(color);

  return color.rgb;
}
