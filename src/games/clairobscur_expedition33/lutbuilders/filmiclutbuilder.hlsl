#include "./filmtonemap.hlsli"
#include "./lutbuildercommon.hlsl"

static const uint LUT_WEIGHT_DEFAULT = 0;
static const uint LUT_WEIGHT_X_Y = 0;
static const uint LUT_WEIGHT_Z = 1;
static const uint LUT_WEIGHT_W = 2;

cbuffer _RootShaderParameters : register(b0) {
  float4 LUTWeights[2] : packoffset(c005.x);
  float4 ACESMinMaxData : packoffset(c008.x);
  float4 ACESMidData : packoffset(c009.x);
  float4 ACESCoefsLow_0 : packoffset(c010.x);
  float4 ACESCoefsHigh_0 : packoffset(c011.x);
  float ACESCoefsLow_4 : packoffset(c012.x);
  float ACESCoefsHigh_4 : packoffset(c012.y);
  float ACESSceneColorMultiplier : packoffset(c012.z);
  float ACESGamutCompression : packoffset(c012.w);
  float4 OverlayColor : packoffset(c013.x);
  float3 ColorScale : packoffset(c014.x);
  float4 ColorSaturation : packoffset(c015.x);
  float4 ColorContrast : packoffset(c016.x);
  float4 ColorGamma : packoffset(c017.x);
  float4 ColorGain : packoffset(c018.x);
  float4 ColorOffset : packoffset(c019.x);
  float4 ColorSaturationShadows : packoffset(c020.x);
  float4 ColorContrastShadows : packoffset(c021.x);
  float4 ColorGammaShadows : packoffset(c022.x);
  float4 ColorGainShadows : packoffset(c023.x);
  float4 ColorOffsetShadows : packoffset(c024.x);
  float4 ColorSaturationMidtones : packoffset(c025.x);
  float4 ColorContrastMidtones : packoffset(c026.x);
  float4 ColorGammaMidtones : packoffset(c027.x);
  float4 ColorGainMidtones : packoffset(c028.x);
  float4 ColorOffsetMidtones : packoffset(c029.x);
  float4 ColorSaturationHighlights : packoffset(c030.x);
  float4 ColorContrastHighlights : packoffset(c031.x);
  float4 ColorGammaHighlights : packoffset(c032.x);
  float4 ColorGainHighlights : packoffset(c033.x);
  float4 ColorOffsetHighlights : packoffset(c034.x);
  float LUTSize : packoffset(c035.x);
  float WhiteTemp : packoffset(c035.y);
  float WhiteTint : packoffset(c035.z);
  float ColorCorrectionShadowsMax : packoffset(c035.w);
  float ColorCorrectionHighlightsMin : packoffset(c036.x);
  float ColorCorrectionHighlightsMax : packoffset(c036.y);
  float BlueCorrection : packoffset(c036.z);
  float ExpandGamut : packoffset(c036.w);
  float ToneCurveAmount : packoffset(c037.x);
  float FilmSlope : packoffset(c037.y);
  float FilmToe : packoffset(c037.z);
  float FilmShoulder : packoffset(c037.w);
  float FilmBlackClip : packoffset(c038.x);
  float FilmWhiteClip : packoffset(c038.y);
  uint bUseMobileTonemapper : packoffset(c038.z);
  uint bIsTemperatureWhiteBalance : packoffset(c038.w);
  float3 MappingPolynomial : packoffset(c039.x);
  float3 InverseGamma : packoffset(c040.x);
  uint OutputDevice : packoffset(c040.w);
  uint OutputGamut : packoffset(c041.x);
  float OutputMaxLuminance : packoffset(c041.y);
};

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.5f, float output_max = 1.f) {
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float3 ApplyACESRRTAndODT(float3 untonemapped_ap1) {
  untonemapped_ap1 *= 1.5f;
  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  const float ACES_MID = 0.1f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  }

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

  return tonemapped_ap1;
}

float3 ApplyPostToneMapDesaturation(float3 tonemapped) {
  float grayscale = renodx::color::y::from::AP1(tonemapped);
  return max(0.f, lerp(grayscale, tonemapped, 0.93f));
}

float3 LerpToneMapStrength(float3 tonemapped, float3 preRRT) {
  preRRT = min(100.f, preRRT);  // prevents artifacts during night vision in Robocop
  return lerp(preRRT, tonemapped, ToneCurveAmount);
}

// AP1 -> AP0 -> Blue Corrected AP0 -> AP1
float3 ApplyBlueCorrectionPre(float3 untonemapped_ap1) {
  float r = untonemapped_ap1.r, g = untonemapped_ap1.g, b = untonemapped_ap1.b;

  float corrected_r = ((mad(0.061360642313957214f, b, mad(-4.540197551250458e-09f, g, (r * 0.9386394023895264f))) - r) * BlueCorrection) + r;
  float corrected_g = ((mad(0.169205904006958f, b, mad(0.8307942152023315f, g, (r * 6.775371730327606e-08f))) - g) * BlueCorrection) + g;
  float corrected_b = (mad(-2.3283064365386963e-10f, g, (r * -9.313225746154785e-10f)) * BlueCorrection) + b;

  return float3(corrected_r, corrected_g, corrected_b);
}

float3 ApplyBlueCorrectionPost(float3 tonemapped) {
  float _1131 = tonemapped.r, _1132 = tonemapped.g, _1133 = tonemapped.b;
  // return tonemapped;

  float _1149 = ((mad(-0.06537103652954102f, _1133, mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))) - _1131) * BlueCorrection) + _1131;
  float _1150 = ((mad(-0.20366770029067993f, _1133, mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))) - _1132) * BlueCorrection) + _1132;
  float _1151 = ((mad(0.9999996423721313f, _1133, mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))) - _1133) * BlueCorrection) + _1133;
  return float3(_1149, _1150, _1151);
}

void ApplyFilmToneMapWithBlueCorrect(float untonemapped_r, float untonemapped_g, float untonemapped_b,
                                     inout float tonemapped_r, inout float tonemapped_g, inout float tonemapped_b) {
  float3 untonemapped_ap1 = float3(untonemapped_r, untonemapped_g, untonemapped_b);
  renodx::color::grade::Config cg_config = CreateColorGradingConfig();
  float y = renodx::color::y::from::AP1(untonemapped_ap1);
  float3 hue_reference_color = untonemapped_ap1;

  float3 untonemapped_ap1_graded = untonemapped_ap1;
  if (RENODX_TONE_MAP_TYPE != 4.f && RENODX_TONE_MAP_TYPE != 0.f) {
    untonemapped_ap1_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, y, cg_config, 0.18f);
  }

  float3 tonemapped_ap1;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    tonemapped_ap1 = untonemapped_ap1_graded;
  } else if (RENODX_TONE_MAP_TYPE == 2.f) {  // ACES
    tonemapped_ap1 = ApplyACESRRTAndODT(untonemapped_ap1_graded);
  } else {  // Vanilla+ and UE Filmic
    float3 untonemapped_prebluecorrect_ap1 = ApplyBlueCorrectionPre(untonemapped_ap1_graded);
    float3 untonemapped_rrt_prebluecorrect_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_prebluecorrect_ap1));

    float3 tonemapped_prebluecorrect_ap1;
    if (RENODX_TONE_MAP_TYPE == 4.f || RENODX_TONE_MAP_TYPE == 0.f) {  // Vanilla
      tonemapped_prebluecorrect_ap1 =
          unrealengine::filmtonemap::ApplyToneCurve(untonemapped_rrt_prebluecorrect_ap1, FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
    } else {
      tonemapped_prebluecorrect_ap1 =
          ApplyToneCurveExtendedWithHermite(untonemapped_rrt_prebluecorrect_ap1, FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
    }

    tonemapped_prebluecorrect_ap1 = ApplyPostToneMapDesaturation(tonemapped_prebluecorrect_ap1);
    tonemapped_prebluecorrect_ap1 = LerpToneMapStrength(tonemapped_prebluecorrect_ap1, untonemapped_ap1_graded);
    tonemapped_ap1 = ApplyBlueCorrectionPost(tonemapped_prebluecorrect_ap1);
  }
  tonemapped_ap1 = max(0, tonemapped_ap1);

  if (RENODX_TONE_MAP_TYPE != 4.f && RENODX_TONE_MAP_TYPE != 0.f) {
    tonemapped_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(tonemapped_ap1, hue_reference_color, y, cg_config, RENODX_TONE_MAP_HUE_CORRECTION_TYPE);
  }

  tonemapped_r = tonemapped_ap1.r, tonemapped_g = tonemapped_ap1.g, tonemapped_b = tonemapped_ap1.b;

  return;
}

float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture,
    uint lut_weight = LUT_WEIGHT_DEFAULT) {
  const float lut_weights_x = LUTWeights[0].x;
  const float lut_weights_y = LUTWeights[0].y;
  const float lut_weights_z = LUTWeights[0].z;
  const float lut_weights_w = LUTWeights[0].w;

  color_srgb = saturate(color_srgb);

  float _952 = (color_srgb.g * 0.9375f) + 0.03125f;
  float _959 = color_srgb.b * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((color_srgb.r * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float3 lutted_srgb;

  switch (lut_weight) {
    case LUT_WEIGHT_X_Y: {
      lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_y)) + ((lut_weights_x)*color_srgb.rgb));
      break;
    }
    case LUT_WEIGHT_Z: {
      lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_z)));
      break;
    }
    case LUT_WEIGHT_W: {
      lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_w)));
      break;
    }
    default: {
      lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_y)) + ((lut_weights_x)*color_srgb.rgb));
      break;
    }
  }
  return lutted_srgb;
}

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input, uint lut_weight = LUT_WEIGHT_DEFAULT) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;

  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = SamplePacked1DLut(lutInputColor, lut_sampler, lut_texture, lut_weight);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = SamplePacked1DLut(renodx::lut::ConvertInput(0, lut_config), lut_sampler, lut_texture, lut_weight);
    float3 lutBlackLinear = renodx::lut::LinearOutput(lutBlack, lut_config);
    float lutBlackY = renodx::color::y::from::BT709(lutBlackLinear);
    if (lutBlackY > 0.f) {
      float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_config, lut_texture) + lutBlack;  // set midpoint based on black to avoid black crush
      float lutShift = renodx::color::y::from::BT709(SamplePacked1DLut(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_sampler, lut_texture, lut_weight) / lutBlack);
      float3 unclamped_gamma = renodx::lut::Unclamp(
          renodx::lut::GammaOutput(lutOutputColor, lut_config),
          renodx::lut::GammaOutput(lutBlack, lut_config),
          renodx::lut::GammaOutput(lutMid, lut_config),
          1.f,  // renodx::lut::GammaOutput(lutWhite, lut_config), // not adjusting whites, just lowering blacks
          renodx::lut::ConvertInput(color_input * lutShift, lut_config));
      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  }

  return color_output;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f && RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler, lut_texture));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler_1, SamplerState lut_sampler_2, Texture2D<float4> lut_texture_1, Texture2D<float4> lut_texture_2, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f && RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted_1 = SampleLUTSRGBInSRGBOut(lut_texture_1, lut_sampler_1, color_lut_input_tonemapped);
    float3 lutted_2 = SampleLUTSRGBInSRGBOut(lut_texture_2, lut_sampler_2, color_lut_input_tonemapped, LUT_WEIGHT_Z);
    float3 lutted = lutted_1 + lutted_2;
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(
        SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_1, lut_texture_1)
        + SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_2, lut_texture_2, LUT_WEIGHT_Z));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler_1, SamplerState lut_sampler_2, SamplerState lut_sampler_3, Texture2D<float4> lut_texture_1, Texture2D<float4> lut_texture_2, Texture2D<float4> lut_texture_3, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f && RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted_1 = SampleLUTSRGBInSRGBOut(lut_texture_1, lut_sampler_1, color_lut_input_tonemapped);
    float3 lutted_2 = SampleLUTSRGBInSRGBOut(lut_texture_2, lut_sampler_2, color_lut_input_tonemapped, LUT_WEIGHT_Z);
    float3 lutted_3 = SampleLUTSRGBInSRGBOut(lut_texture_3, lut_sampler_3, color_lut_input_tonemapped, LUT_WEIGHT_W);
    float3 lutted = lutted_1 + lutted_2 + lutted_3;
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(
        SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_1, lut_texture_1)
        + SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_2, lut_texture_2, LUT_WEIGHT_Z)
        + SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_3, lut_texture_3, LUT_WEIGHT_W));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}
