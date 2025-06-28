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

float3 applyVignette(float3 inputColor, float2 screen, float slider) {
  static float intensity = 1.f;    // internal
  static float roundness = 1.15f;  // parameters
  static float light = 0.1f;       // for now

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

// https://github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/sharpen_ps.hlsl
float4 applySharpen(Texture2D colorBuffer, SamplerState colorSampler, float2 texCoord, float intensity) {
  float4 output;
  uint screenWidth, screenHeight;
  colorBuffer.GetDimensions(screenWidth, screenHeight);
  const float2 texelSize = 1.0.xx / float2(screenWidth, screenHeight);
  float4 center = colorBuffer.SampleLevel(colorSampler, texCoord + float2(0,0) * texelSize, 0);
    if (intensity > 0.f)
      {
      float3 neighbors[4] =
          {
            (colorBuffer.SampleLevel(colorSampler, texCoord + float2(1, 1) * texelSize, 0).xyz),
            (colorBuffer.SampleLevel(colorSampler, texCoord + float2(-1, 1) * texelSize, 0).xyz),
            (colorBuffer.SampleLevel(colorSampler, texCoord + float2(1, -1) * texelSize, 0).xyz),
            (colorBuffer.SampleLevel(colorSampler, texCoord + float2(-1, -1) * texelSize, 0).xyz)
          };
      float neighborDiff = 0;
      [unroll]
      for (uint i = 0; i < 4; ++i)
          {
        neighborDiff += renodx::color::y::from::BT709(abs(neighbors[i] - center));
      }
  
      float sharpening = (1 - saturate(2 * neighborDiff)) * intensity;
  
      float3 sharpened = float3(
                             0.0.xxx
                             + neighbors[0] * -sharpening
                             + neighbors[1] * -sharpening
                             + neighbors[2] * -sharpening
                             + neighbors[3] * -sharpening
                             + center * 5
      ) * 1.0 / (5.0 + sharpening * -4.0);
  
      output = float4(sharpened, center.w);
    }
      else
      {
      output = center;
    }
  return output;
  }

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
  color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
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
  	if(injectedData.toneMapType == 0.f) {
  color = renodx::color::bt709::clamp::BT709(color);
  } else {
  color = renodx::color::bt709::clamp::BT2020(color);
  }
  color /= 80.f;
  return color;
}

//-----TONEMAP-----//
float3 vanillaTonemap(float3 color) {
  return 1 - exp(-color);
}

float3 applyFrostbite(float3 input, renodx::tonemap::Config FbConfig) {
  float3 color = input;
  float FbPeak = FbConfig.peak_nits / FbConfig.game_nits;
  if (FbConfig.gamma_correction == 0.f) {
    FbPeak = renodx::color::srgb::Encode(FbPeak);
    FbPeak = renodx::color::gamma::Decode(FbPeak, 2.2f);
  } else if (FbConfig.gamma_correction == 2.f) {
    FbPeak = renodx::color::gamma::Encode(FbPeak, 2.4f);
    FbPeak = renodx::color::gamma::Decode(FbPeak, 2.2f);
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

float3 applyDICE(float3 input, renodx::tonemap::Config DiceConfig) {
  float3 color = input;
  float DicePaperWhite = DiceConfig.game_nits / 80.f;
  float DicePeak = DiceConfig.peak_nits / 80.f;
    if (DiceConfig.gamma_correction == 0.f) {
      DicePeak = renodx::color::srgb::Encode(DicePeak);
      DicePeak = renodx::color::gamma::Decode(DicePeak, 2.2f);
      DicePaperWhite = renodx::color::srgb::Encode(DicePaperWhite);
      DicePaperWhite = renodx::color::gamma::Decode(DicePaperWhite, 2.2f);
    } else if (DiceConfig.gamma_correction == 2.f) {
      DicePeak = renodx::color::gamma::Encode(DicePeak, 2.4f);
      DicePeak = renodx::color::gamma::Decode(DicePeak, 2.2f);
      DicePaperWhite = renodx::color::gamma::Encode(DicePaperWhite, 2.4f);
      DicePaperWhite = renodx::color::gamma::Decode(DicePaperWhite, 2.2f);
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

float gammaCorrectPeak(float peak) {
  if (injectedData.toneMapGammaCorrection == 0.f) {
   return renodx::color::gamma::Decode(renodx::color::srgb::Encode(peak / injectedData.toneMapGameNits), 2.2f) * injectedData.toneMapGameNits;
  } else if (injectedData.toneMapGammaCorrection == 2.f) {
    return renodx::color::gamma::Decode(renodx::color::gamma::Encode(peak / injectedData.toneMapGameNits, 2.4), 2.2f) * injectedData.toneMapGameNits;
 } else {
   return peak;
 }
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;
  float3 hueCorrectionColor = vanillaTonemap(untonemapped);
  float midGray = vanillaTonemap(float3(0.18f,0.18f,0.18f)).x;
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
  config.mid_gray_nits = midGray * 100.f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(hueCorrectionColor);
  } else {
    outputColor = untonemapped;
  }
  if (injectedData.toneMapType == 2.f) {  // Frostbite
    outputColor = applyFrostbite(outputColor, config);
  } else if (injectedData.toneMapType == 5.f) {  // DICE
    outputColor = applyDICE(outputColor, config);
  } else {
    config.peak_nits = gammaCorrectPeak(injectedData.toneMapPeakNits);
    config.gamma_correction = 0.f;
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }
  return outputColor;
}
