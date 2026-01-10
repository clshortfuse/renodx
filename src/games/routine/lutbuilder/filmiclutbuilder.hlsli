#include "./Cbuffers/Cbuffers_LUTBuilder.hlsli"
#include "./filmtonemap.hlsli"
#include "./lutbuildercommon.hlsli"

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
  if (RENODX_TONE_MAP_TYPE != 4.f || RENODX_TONE_MAP_TYPE != 0.f) {
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

  if (RENODX_TONE_MAP_TYPE != 4.f || RENODX_TONE_MAP_TYPE != 0.f) {
    tonemapped_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(tonemapped_ap1, hue_reference_color, y, cg_config, RENODX_TONE_MAP_HUE_CORRECTION_TYPE);
  }

  tonemapped_r = tonemapped_ap1.r, tonemapped_g = tonemapped_ap1.g, tonemapped_b = tonemapped_ap1.b;

  return;
}

// color grading LUT stuff
#if 1

float3 RecolorUnclamped(float3 reference_color,
                        float3 unclamped_color,
                        float strength = 1.f) {
  float hue_correct_strength = 1.f;
  float chrominance_correct_strength = 1.f;
  if (strength == 0.f) return reference_color;

  float3 perceptual_new = renodx::color::oklab::from::BT709(unclamped_color);
  const float3 reference_oklab = renodx::color::oklab::from::BT709(reference_color);

  float chrominance_current = length(perceptual_new.yz);
  float chrominance_ratio = 1.0;

  {  // hue correction
    const float chrominance_pre = chrominance_current;
    perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, hue_correct_strength);
    const float chrominancePost = length(perceptual_new.yz);
    chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
    chrominance_current = chrominancePost;
  }

  {  // chrominance correction
    const float reference_chrominance = length(reference_oklab.yz);
    float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
    chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_correct_strength);
  }

  perceptual_new.yz *= chrominance_ratio;

  // lerp lightness
  perceptual_new.x = lerp(max(0, reference_oklab.x), max(0, perceptual_new.x), strength);

  unclamped_color = renodx::color::bt709::from::OkLab(perceptual_new);
  unclamped_color = renodx::color::bt709::clamp::AP1(unclamped_color);

  return unclamped_color;
}

/// Piecewise linear + exponential compression to a target value starting from a specified number.
/// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite
#define EXPONENTIALROLLOFF_GENERATOR(T)                                                                            \
  T ExponentialRollOffExtended(T input, float rolloff_start = 0.20f, float output_max = 1.f, float clip = 100.f) { \
    T rolloff_size = output_max - rolloff_start;                                                                   \
    T overage = -max((T)0, input - rolloff_start);                                                                 \
    T clip_size = rolloff_start - clip;                                                                            \
    T rolloff_value = (T)1.0f - exp(overage / rolloff_size);                                                       \
    T clip_value = (T)1.0f - exp(clip_size / rolloff_size);                                                        \
    T new_overage = mad(rolloff_size, rolloff_value / clip_value, overage);                                        \
    return input + new_overage;                                                                                    \
  }
EXPONENTIALROLLOFF_GENERATOR(float)
EXPONENTIALROLLOFF_GENERATOR(float3)
#undef EXPONENTIALROLLOFF_GENERATOR

/// Applies Exponential Roll-Off Extended tonemapping by luminance.
float3 LUTToneMap(float3 untonemapped, float rolloff_start = 0.5f, float output_max = 1.f) {
  float white_clip = (RENODX_TONE_MAP_TYPE == 1.f) ? 100.f : RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  float y_in = renodx::color::y::from::BT709(untonemapped);
  float y_out = exp2(ExponentialRollOffExtended(
      log2(y_in),
      log2(rolloff_start),
      log2(output_max),
      log2(white_clip)));
  float3 tonemapped = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

  return tonemapped;
}

renodx::lut::Config CreateSRGBInSRGBOutLUTConfig() {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;
  return lut_config;
}

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 ComputeGamutCompressionScaleAndCompress(float3 color_linear, inout float gamut_compression_scale) {
  if (RENODX_TONE_MAP_TYPE == 4.f || RENODX_TONE_MAP_TYPE == 0.f || CUSTOM_LUT_GAMUT_RESTORATION == 0.f) return color_linear;

  const float MID_GRAY_GAMMA = log(1 / (pow(10, 0.75))) / log(0.5f);  // ~2.49f

  float3 encoded = renodx::color::gamma::EncodeSafe(color_linear, MID_GRAY_GAMMA);
  float encoded_gray = renodx::color::gamma::Encode(renodx::color::y::from::BT709(color_linear), MID_GRAY_GAMMA);

  gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(encoded, encoded_gray);

  float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray, gamut_compression_scale);

  return renodx::color::gamma::DecodeSafe(compressed, MID_GRAY_GAMMA);
}

float3 GamutDecompress(float3 color_linear, float gamut_compression_scale) {
  if (RENODX_TONE_MAP_TYPE == 4.f || RENODX_TONE_MAP_TYPE == 0.f || CUSTOM_LUT_GAMUT_RESTORATION == 0.f || gamut_compression_scale == 1.f) return color_linear;

  const float MID_GRAY_GAMMA = log(1 / (pow(10, 0.75))) / log(0.5f);  // ~2.49f

  float3 encoded = renodx::color::gamma::EncodeSafe(color_linear, MID_GRAY_GAMMA);
  float encoded_gray = renodx::color::gamma::Encode(renodx::color::y::from::BT709(color_linear), MID_GRAY_GAMMA);

  float3 decompressed = renodx::color::correct::GamutDecompress(encoded, encoded_gray, gamut_compression_scale);

  return renodx::color::gamma::DecodeSafe(decompressed, MID_GRAY_GAMMA);
}

float3 ComputeMaxChannelScaleAndCompress(float3 color_srgb, inout float channel_compression_scale) {
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    channel_compression_scale = renodx::math::Max(color_srgb.r, color_srgb.g, color_srgb.b, 1.f);
    color_srgb /= channel_compression_scale;
  }
  return color_srgb;
}

// single LUT
float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture) {
  float max_channel = 1.f;
  {
    color_srgb = ComputeMaxChannelScaleAndCompress(color_srgb, max_channel);
  }

  color_srgb = saturate(color_srgb);

  float _952 = (color_srgb.g * 0.9375f) + 0.03125f;
  float _959 = color_srgb.b * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((color_srgb.r * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float _992 = (((lerp(_966.x, _973.x, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.r));
  float _993 = (((lerp(_966.y, _973.y, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.g));
  float _994 = (((lerp(_966.z, _973.z, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.b));

  float3 lutted_srgb = float3(_992, _993, _994);

  {
    lutted_srgb *= max_channel;
  }

  return lutted_srgb;
}

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float gamut_compression_scale = 1.f;
  {
    color_input = ComputeGamutCompressionScaleAndCompress(color_input, gamut_compression_scale);
  }

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = SamplePacked1DLut(lut_input_color, lut_config.lut_sampler, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = SamplePacked1DLut(float3(0, 0, 0), lut_config.lut_sampler, lut_texture);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
#if 0
      if (OVERRIDE_BLACK_CLIP) {
        float target_black_nits = 0.0001f / RENODX_DIFFUSE_WHITE_NITS;
        if (RENODX_GAMMA_CORRECTION) target_black_nits = renodx::color::correct::Gamma(target_black_nits, true);
        lut_black_linear += target_black_nits;
      }
#endif

#if 1
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = SamplePacked1DLut(lut_black, lut_config.lut_sampler, lut_texture);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
        lut_mid = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(0.06f), lut_config);
      }
#else
      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
      }

      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = lut_black;

#endif

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      float3 recolored = RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  color_output = GamutDecompress(color_output, gamut_compression_scale);

  return color_output;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = LUTToneMap(color_lut_input);
    float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_lut_input = saturate(color_lut_input);
    color_output = renodx::color::srgb::DecodeSafe(SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler, lut_texture));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// blending 2 LUTs
float3 Sample2Packed1DLuts(
    float3 color_srgb,
    SamplerState lut_sampler1,
    SamplerState lut_sampler2,
    Texture2D<float4> lut_texture1,
    Texture2D<float4> lut_texture2) {
  float max_channel = 1.f;
  {
    color_srgb = ComputeMaxChannelScaleAndCompress(color_srgb, max_channel);
  }

  color_srgb = saturate(color_srgb);
  float _928 = color_srgb.r;
  float _939 = color_srgb.g;
  float _950 = color_srgb.b;

  float _954 = (_939 * 0.9375f) + 0.03125f;
  float _961 = _950 * 15.0f;
  float _962 = floor(_961);
  float _963 = _961 - _962;
  float _965 = (_962 + ((_928 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _968 = lut_texture1.Sample(lut_sampler1, float2(_965, _954));
  float _972 = _965 + 0.0625f;
  float4 _975 = lut_texture1.Sample(lut_sampler1, float2(_972, _954));
  float4 _998 = lut_texture2.Sample(lut_sampler2, float2(_965, _954));
  float4 _1004 = lut_texture2.Sample(lut_sampler2, float2(_972, _954));
  float _1023 = ((((lerp(_968.x, _975.x, _963)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _928)) + ((lerp(_998.x, _1004.x, _963)) * (LUTWeights[0].z)));
  float _1024 = ((((lerp(_968.y, _975.y, _963)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _939)) + ((lerp(_998.y, _1004.y, _963)) * (LUTWeights[0].z)));
  float _1025 = ((((lerp(_968.z, _975.z, _963)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _950)) + ((lerp(_998.z, _1004.z, _963)) * (LUTWeights[0].z)));

  float3 lutted_srgb = float3(_1023, _1024, _1025);

  {
    lutted_srgb *= max_channel;
  }

  return lutted_srgb;
}

float3 Sample2LUTSRGBInSRGBOut(Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, SamplerState lut_sampler1, SamplerState lut_sampler2, float3 color_input) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float gamut_compression_scale = 1.f;
  {
    color_input = ComputeGamutCompressionScaleAndCompress(color_input, gamut_compression_scale);
  }

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample2Packed1DLuts(lut_input_color, lut_sampler1, lut_sampler2, lut_texture1, lut_texture2);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = Sample2Packed1DLuts(float3(0, 0, 0), lut_sampler1, lut_sampler2, lut_texture1, lut_texture2);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
#if 1
      if (OVERRIDE_BLACK_CLIP) {
        float target_black_nits = 0.0001f / RENODX_DIFFUSE_WHITE_NITS;
        if (RENODX_GAMMA_CORRECTION) target_black_nits = renodx::color::correct::Gamma(target_black_nits, true);
        lut_black_linear += target_black_nits;
      }
#endif

#if 1
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = Sample2Packed1DLuts(lut_black, lut_sampler1, lut_sampler2, lut_texture1, lut_texture2);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
        lut_mid = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(0.06f), lut_config);
      }
#else

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
      }
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = lut_black;
#endif

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      float3 recolored = RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  color_output = GamutDecompress(color_output, gamut_compression_scale);

  return color_output;
}

void Sample2LUTsUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler1, SamplerState lut_sampler2, Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f && RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = LUTToneMap(color_lut_input);
    float3 lutted = Sample2LUTSRGBInSRGBOut(lut_texture1, lut_texture2, lut_sampler1, lut_sampler2, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_lut_input = saturate(color_lut_input);
    color_output = renodx::color::srgb::DecodeSafe(Sample2Packed1DLuts(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler1, lut_sampler2, lut_texture1, lut_texture2));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}
#endif
