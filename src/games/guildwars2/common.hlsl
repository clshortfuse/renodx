#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen, bool colored) {
  float3 grainedColor;
  if (colored == true) {
    grainedColor = renodx::effects::ApplyFilmGrainColored(
        outputColor,
        screen,
        float3(
            CUSTOM_RANDOM1,
            CUSTOM_RANDOM2,
            CUSTOM_RANDOM3),
        CUSTOM_GRAIN_STRENGTH * 0.01f,
        1.f);
  } else {
    grainedColor = renodx::effects::ApplyFilmGrain(
        outputColor,
        screen,
        CUSTOM_RANDOM1,
        CUSTOM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }
  return grainedColor;
}

float3 applyVignette(float3 inputColor, float2 screen, float slider) {
  static float intensity = 1.f;	// internal
  static float roundness = 1.15f;	// parameters
  static float light = 0.1f;		// for now

  float Vintensity = intensity * min(1, slider);  // Slider below 1 to Vintensity
  float Vroundness = roundness * max(1, slider);  // Slider above 1 to Vroundness
  float2 Vcoord = screen - 0.5f;                  // get screen center
  Vcoord *= Vintensity;
  float v = dot(Vcoord, Vcoord);
  v = saturate(1 - v);
  v = pow(v, Vroundness);
  float3 output = inputColor * min(1, v + light);
  return output;
}

// based on https://github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/chromaticAberration_ps.hlsl
float3 applyCA(Texture2D colorBuffer, SamplerState colorSampler, float2 texCoord, float intensity) {
  float3 output;
  uint screenWidth, screenHeight;
  colorBuffer.GetDimensions(screenWidth, screenHeight);
  float ca_amount = 0.018 * intensity;
  float2 center_offset = texCoord - float2(0.5, 0.5);
  ca_amount *= saturate(length(center_offset) * 2);
  int num_colors = max(3, int(max(screenWidth, screenHeight) * 0.075 * sqrt(ca_amount)));
  if (intensity == 0.f) {
    output = colorBuffer.Sample(colorSampler, texCoord).rgb;
  } else {
    output.g = colorBuffer.Sample(colorSampler, texCoord).g;  // unchanged green and alpha
    float offset = float(7 - num_colors * 0.5) * ca_amount / num_colors;
    float2 sampleUvR = float2(0.5, 0.5) + center_offset * (1 + offset);
    float2 sampleUvB = float2(0.5, 0.5) + center_offset * (1 - offset);
    output.r = colorBuffer.Sample(colorSampler, sampleUvR).r;
    output.b = colorBuffer.Sample(colorSampler, sampleUvB).b;
  }
  return output;
}

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 HalfWayScale(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= (RENODX_DIFFUSE_WHITE_NITS + RENODX_GRAPHICS_WHITE_NITS) / (RENODX_GRAPHICS_WHITE_NITS * 2.f);
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= (RENODX_DIFFUSE_WHITE_NITS + RENODX_GRAPHICS_WHITE_NITS) / (RENODX_GRAPHICS_WHITE_NITS * 2.f);
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
    color *= (RENODX_DIFFUSE_WHITE_NITS + RENODX_GRAPHICS_WHITE_NITS) / (RENODX_GRAPHICS_WHITE_NITS * 2.f);
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 FinalizeOutput(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  color *= RENODX_GRAPHICS_WHITE_NITS;
  	if(RENODX_TONE_MAP_TYPE == 0.f) {
  color = renodx::color::bt709::clamp::BT709(color);
  color = min(max(RENODX_DIFFUSE_WHITE_NITS, RENODX_GRAPHICS_WHITE_NITS), color);
  } else if (RENODX_TONE_MAP_TYPE != 1.f) {
  color = renodx::color::bt709::clamp::BT2020(color);
  float y_max = RENODX_PEAK_WHITE_NITS;
  float old_y = renodx::color::y::from::BT709(abs(color));
  if (old_y > y_max) {
  float new_y = renodx::tonemap::ExponentialRollOff(old_y, y_max * 0.87f, y_max); 
  color *= renodx::math::DivideSafe(new_y, old_y, 1.f);
  }
  } else {
  color = renodx::color::bt709::clamp::BT2020(color);
  }
  color /= 80.f;
  return color;
}

float3 InverseToneMap(float3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
	float scaling = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
	float videoPeak = scaling * renodx::color::bt2408::REFERENCE_WHITE;
    videoPeak = renodx::color::correct::Gamma(videoPeak, false, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, false, 2.4f);
      if(RENODX_GAMMA_CORRECTION == 2.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.4f);
    } else if(RENODX_GAMMA_CORRECTION == 1.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.2f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.2f);
    }
    color = renodx::color::gamma::Decode(color, 2.4f);
    color = renodx::tonemap::inverse::bt2446a::BT709(color, renodx::color::bt709::REFERENCE_WHITE, videoPeak);
	color /= videoPeak;
	color *= scaling;
  color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {}
  color = renodx::color::srgb::DecodeSafe(color);
	return color;
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
  color = renodx::tonemap::frostbite::BT709(color, FbPeak, CUSTOM_TONE_MAP_SHOULDER_START, RENODX_TONE_MAP_HIGHLIGHT_SATURATION / 2.f, CUSTOM_COLOR_GRADE_HUE_CORRECTION);

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
  color = DICEMap(color * DicePaperWhite, DicePeak, CUSTOM_TONE_MAP_SHOULDER_START * DicePaperWhite, 1.f, DiceConfig.reno_drt_per_channel) / DicePaperWhite;

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

float3 applyUserTonemap(float3 untonemapped, Texture2D lutTexture, SamplerState lutSampler) {
  float3 outputColor;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, RENODX_TONE_MAP_TYPE);
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = RENODX_GAMMA_CORRECTION;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = shader_injection.colorGradeHighlights;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.hue_correction_type = RENODX_TONE_MAP_PER_CHANNEL != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = CUSTOM_COLOR_GRADE_HUE_CORRECTION;
  config.hue_correction_color = lerp(untonemapped, renodx::tonemap::renodrt::NeutralSDR(untonemapped, true), CUSTOM_COLOR_GRADE_HUE_SHIFT);
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  config.reno_drt_hue_correction_method = (int)RENODX_TONE_MAP_HUE_PROCESSOR;
  config.reno_drt_blowout = 1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0.f;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.size = 16;
  lut_config.tetrahedral = CUSTOM_LUT_SAMPLE != 0.f;
  lut_config.recolor = RENODX_TONE_MAP_TYPE != 0.f ? 1.f : 0.f;
    float y = renodx::color::y::from::BT709(untonemapped);
    float3 neutralSDR = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
    float3 sdrColor = lerp(untonemapped, neutralSDR, saturate(y));
    float3 lutInput = RENODX_TONE_MAP_TYPE <= 1.f ? untonemapped : sdrColor;
    if(config.type == 0.f){
      outputColor = renodx::lut::Sample(lutInput, lut_config, lutTexture);
    } else {
      lut_config.strength = 1.f;
      float3 lutColor = renodx::lut::Sample(lutInput, lut_config, lutTexture);
      outputColor = renodx::tonemap::UpgradeToneMap(untonemapped, lutInput, lutColor, CUSTOM_LUT_STRENGTH);
    }
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    outputColor = applyFrostbite(outputColor, config);
  } else if (RENODX_TONE_MAP_TYPE == 4.f) {
    outputColor = applyDICE(outputColor, config);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }
  return outputColor;
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, RENODX_TONE_MAP_TYPE);
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = RENODX_GAMMA_CORRECTION;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = shader_injection.colorGradeHighlights;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.hue_correction_type = RENODX_TONE_MAP_PER_CHANNEL != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = CUSTOM_COLOR_GRADE_HUE_CORRECTION;
  config.hue_correction_color = lerp(untonemapped, renodx::tonemap::renodrt::NeutralSDR(untonemapped, true), CUSTOM_COLOR_GRADE_HUE_SHIFT);
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  config.reno_drt_hue_correction_method = (int)RENODX_TONE_MAP_HUE_PROCESSOR;
  config.reno_drt_blowout = 1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0.f;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = saturate(untonemapped);
  } else {
    outputColor = untonemapped;
  }
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    outputColor = applyFrostbite(outputColor, config);
  } else if (RENODX_TONE_MAP_TYPE == 4.f) {
    outputColor = applyDICE(outputColor, config);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }
  return outputColor;
}