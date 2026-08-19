#ifndef INCLUDE_FILMIC_LUTBUILDER
#define INCLUDE_FILMIC_LUTBUILDER

#include "./filmtonemap.hlsli"
#include "./lutbuildercommon.hlsli"

// Tonemap to 1 using N2 Max Channel
float3 MaxChTonemapToOne(float3 color) {
  return renodx::tonemap::neutwo::MaxChannel(color);
}

// Create cbuffer struct

struct UECbufferConfig {
  // Filmic paramaters
  float ue_filmblackclip;
  float ue_filmtoe;
  float ue_filmshoulder;
  float ue_filmslope;
  float ue_filmwhiteclip;
  float ue_tonecurveammount;
  // "SDR Luts"
  float4 ue_lutweights[2];
  // "etc"
  float3 ue_mappingpolynomial;
  float4 ue_overlaycolor;
  float3 ue_colorscale;
  float ue_bluecorrection;
  bool ue_haslut;
};

// // Config builder

UECbufferConfig CreateCbufferConfig(
    float ue_filmblackclip = 1.f,
    float ue_filmtoe = 1.f,
    float ue_filmshoulder = 1.f,
    float ue_filmslope = 1.f,
    float ue_filmwhiteclip = 1.f,
    float ue_tonecurveammount = 1.f,
    // float4 ue_lutweights[2], Doesn't work
    float4 ue_lutweights0 = float4(1.0, 1.0, 1.0, 1.0),  // First member of LutWeights[2] array
    float4 ue_lutweights1 = float4(1.0, 1.0, 1.0, 1.0),  // Second member of LutWeights[2] array
    float3 ue_mappingpolynomail = 1.f,
    float4 ue_overlaycolor = 1.f,
    float3 ue_colorscale = 1.f,
    float ue_bluecorrection = 1.f,
    bool ue_haslut = false) {
  UECbufferConfig cb_config;
  cb_config.ue_filmblackclip = ue_filmblackclip;
  cb_config.ue_filmtoe = ue_filmtoe;
  cb_config.ue_filmshoulder = ue_filmshoulder;
  cb_config.ue_filmslope = ue_filmslope;
  cb_config.ue_filmwhiteclip = ue_filmwhiteclip;
  cb_config.ue_tonecurveammount = ue_tonecurveammount;
  cb_config.ue_lutweights[0] = ue_lutweights0;
  cb_config.ue_lutweights[1] = ue_lutweights1;
  cb_config.ue_mappingpolynomial = ue_mappingpolynomail;
  cb_config.ue_overlaycolor = ue_overlaycolor;
  cb_config.ue_colorscale = ue_colorscale;
  cb_config.ue_bluecorrection = ue_bluecorrection;
  cb_config.ue_haslut = ue_haslut;

  return cb_config;
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

// input: blue-corrected AP1 linear
// output: blue-corrected AP1 linear
float3 ApplyPostToneMapDesaturation(float3 tonemapped_blue_corrected_ap1) {
  float grayscale = renodx::color::y::from::AP1(tonemapped_blue_corrected_ap1);
  return max(0.f, lerp(grayscale, tonemapped_blue_corrected_ap1, 0.93f));
}

// input: white-normalized LMS linear
// output: white-normalized LMS linear
float3 ApplyPostToneMapDesaturationLMS(float3 tonemapped_lms_normalized) {
  float y_white = renodx::color::xyz::from::LMS(RENODX_BT709_LMS_WHITE).y;

  float y = renodx::color::xyz::from::LMS(tonemapped_lms_normalized * RENODX_BT709_LMS_WHITE).y;

  float grayscale = renodx::math::DivideSafe(y, y_white, 0.f);

  return max(0.f, lerp(grayscale, tonemapped_lms_normalized, 0.93f));
}

// input/output: same linear working space
float3 LerpToneMapStrength(float3 tonemapped, float3 pre_tonemap, UECbufferConfig cb_config) {
  pre_tonemap = min(100.f, pre_tonemap);  // prevents artifacts during night vision in Robocop
  return lerp(pre_tonemap, tonemapped, saturate(cb_config.ue_tonecurveammount));
}

// input: AP1 linear
// output: blue-corrected AP1 linear
float3 PrepareFilmicInputMaxChannelPath(float3 untonemapped_ap1, UECbufferConfig cb_config) {
  renodx::color::grade::Config cg_config = CreateColorGradingConfig();
  return ApplyBlueCorrectionPre(
      ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, cg_config, 0.18f),
      cb_config.ue_bluecorrection);
}

// input: AP1 linear
// output: blue-corrected AP1 linear
float3 PrepareFilmicInputAP1Path(float3 untonemapped_ap1, UECbufferConfig cb_config) {
  renodx::color::grade::Config cg_config = CreateColorGradingConfig();
  return ApplyAnchoredContrast(
      ApplyBlueCorrectionPre(
          untonemapped_ap1,
          cb_config.ue_bluecorrection)
          * cg_config.exposure,
      cg_config);
}

// input: AP1 linear
// output: white-normalized LMS linear
float3 PrepareFilmicInputLMSPath(float3 untonemapped_ap1) {
  renodx::color::grade::Config cg_config = CreateColorGradingConfig();
  float3 untonemapped_lms_normalized =
      renodx::color::lms::from::AP1(untonemapped_ap1) / RENODX_BT709_LMS_WHITE;
  return ApplyAnchoredContrast(
      untonemapped_lms_normalized * cg_config.exposure,
      cg_config);
}

// input: AP1 linear
// output: AP1 linear
void ApplyFilmicToneMap(
    float3 untonemapped_ap1,
    inout float3 tonemapped_ap1,
    UECbufferConfig cb_config) {
  untonemapped_ap1 = max(0.f, untonemapped_ap1);  // Clamp input from lutbuilder just to be safe / potentially catch NaNs

  if (RENODX_TONE_MAP_TYPE == 1.f && RENODX_TONE_MAP_SCALING == 2.f) {
    float3 untonemapped_lms_normalized = PrepareFilmicInputLMSPath(untonemapped_ap1);
    float filmic_black_clip = cb_config.ue_filmblackclip;
    if (OVERRIDE_BLACK_CLIP) filmic_black_clip = 0.f;
    unrealengine::filmtonemap::Config filmic_params =
        unrealengine::filmtonemap::config::Create(
            cb_config.ue_filmslope,
            cb_config.ue_filmtoe,
            cb_config.ue_filmshoulder,
            filmic_black_clip,
            cb_config.ue_filmwhiteclip);
    float3 tonemapped_lms_normalized = ApplyExtendedToneCurveLMS(
        untonemapped_lms_normalized,
        filmic_params);
    tonemapped_lms_normalized = ApplyPostToneMapDesaturationLMS(
        tonemapped_lms_normalized);
    tonemapped_lms_normalized = LerpToneMapStrength(
        tonemapped_lms_normalized,
        untonemapped_lms_normalized,
        cb_config);
    tonemapped_ap1 = renodx::color::ap1::from::LMS(
        max(0.f, tonemapped_lms_normalized) * RENODX_BT709_LMS_WHITE);
    return;
  }

  float3 untonemapped_blue_corrected_ap1;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    untonemapped_blue_corrected_ap1 = ApplyBlueCorrectionPre(untonemapped_ap1, cb_config.ue_bluecorrection);
  } else if (RENODX_TONE_MAP_SCALING == 0.f) {
    untonemapped_blue_corrected_ap1 = PrepareFilmicInputMaxChannelPath(untonemapped_ap1, cb_config);
  } else {
    untonemapped_blue_corrected_ap1 = PrepareFilmicInputAP1Path(untonemapped_ap1, cb_config);
  }

  // Vanilla+ and UE Filmic
  float3 untonemapped_rrt_blue_corrected_ap1 = renodx::tonemap::aces::RRT(
      mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_blue_corrected_ap1));

  float3 tonemapped_blue_corrected_ap1;
  if (RENODX_TONE_MAP_TYPE == 0.f) {  // Vanilla
    tonemapped_blue_corrected_ap1 =
        unrealengine::filmtonemap::ApplyToneCurve(untonemapped_rrt_blue_corrected_ap1, cb_config.ue_filmslope, cb_config.ue_filmtoe, cb_config.ue_filmshoulder, cb_config.ue_filmblackclip, cb_config.ue_filmwhiteclip);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    tonemapped_blue_corrected_ap1 =
        ApplyToneCurveExtendedWithHermite(untonemapped_rrt_blue_corrected_ap1, cb_config.ue_bluecorrection, cb_config.ue_filmslope, cb_config.ue_filmtoe, cb_config.ue_filmshoulder, cb_config.ue_filmblackclip, cb_config.ue_filmwhiteclip);
  }

  tonemapped_blue_corrected_ap1 = ApplyPostToneMapDesaturation(tonemapped_blue_corrected_ap1);
  tonemapped_blue_corrected_ap1 = LerpToneMapStrength(tonemapped_blue_corrected_ap1, untonemapped_blue_corrected_ap1, cb_config);
  tonemapped_ap1 = ApplyBlueCorrectionPost(tonemapped_blue_corrected_ap1, cb_config.ue_bluecorrection);
  tonemapped_ap1 = max(0, tonemapped_ap1);

  // Moved to GenerateOutput
  // if (RENODX_TONE_MAP_TYPE != 0.f) {
  //   tonemapped_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(tonemapped_ap1, hue_reference_color, y, cg_config, RENODX_TONE_MAP_HUE_CORRECTION_TYPE);
  // }

  return;
}

// SDR Luts
// #if 1

renodx::lut::Config CreateSRGBInSRGBOutLUTConfig() {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;
  lut_config.max_channel = 0.f;
  lut_config.gamut_compress = 0.f;
  return lut_config;
}

// input: BT.709 sRGB encoded
// output: BT.709 sRGB encoded
float3 UnclampLegacy(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

// input: BT.709 sRGB encoded
// output: BT.709 sRGB encoded
float3 UnclampYfAnchoredAP1(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma, float blue_correction) {
  float3 original_blue_corrected_ap1 = BlueCorrectedAP1FromBT709(original_gamma, blue_correction);
  float3 black_blue_corrected_ap1 = BlueCorrectedAP1FromBT709(black_gamma, blue_correction);
  float3 mid_gray_blue_corrected_ap1 = BlueCorrectedAP1FromBT709(mid_gray_gamma, blue_correction);
  float3 neutral_blue_corrected_ap1 = BlueCorrectedAP1FromBT709(neutral_gamma, blue_correction);

  float black_floor = min(black_blue_corrected_ap1.r, min(black_blue_corrected_ap1.g, black_blue_corrected_ap1.b));
  float mid_yf = renodx::color::yf::from::AP1(mid_gray_blue_corrected_ap1);
  float neutral_yf = renodx::color::yf::from::AP1(neutral_blue_corrected_ap1);
  float anchor_weight = mid_yf > 0.f ? saturate((mid_yf - neutral_yf) / mid_yf) : 0.f;
  float3 unclamped_blue_corrected_ap1 = max(0.f, original_blue_corrected_ap1 - black_floor * anchor_weight);

  return BT709FromBlueCorrectedAP1(unclamped_blue_corrected_ap1, blue_correction);
}

// input: BT.709 sRGB encoded
// output: BT.709 sRGB encoded
float3 UnclampYfAnchoredLMS(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 lms_white = RENODX_BT709_LMS_WHITE;
  float3 original_lms_normalized = renodx::color::lms::from::BT709(original_gamma) / lms_white;
  float3 black_lms_normalized = renodx::color::lms::from::BT709(black_gamma) / lms_white;
  float3 mid_gray_lms_normalized = renodx::color::lms::from::BT709(mid_gray_gamma) / lms_white;
  float3 neutral_lms_normalized = renodx::color::lms::from::BT709(neutral_gamma) / lms_white;

  float black_floor = min(black_lms_normalized.r, min(black_lms_normalized.g, black_lms_normalized.b));
  float mid_yf = renodx::color::yf::from::LMS(mid_gray_lms_normalized * lms_white);
  float neutral_yf = renodx::color::yf::from::LMS(neutral_lms_normalized * lms_white);
  float anchor_weight = mid_yf > 0.f ? saturate((mid_yf - neutral_yf) / mid_yf) : 0.f;
  float3 unclamped_lms_normalized = max(0.f, original_lms_normalized - black_floor * anchor_weight);

  return renodx::color::bt709::from::LMS(unclamped_lms_normalized * lms_white);
}

// input: BT.709 sRGB encoded
// output: BT.709 sRGB encoded
float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma, float blue_correction) {
  if (CUSTOM_LUT_SCALING_METHOD == 1.f) {
    if (RENODX_TONE_MAP_SCALING == 2.f) {
      return UnclampYfAnchoredLMS(original_gamma, black_gamma, mid_gray_gamma, neutral_gamma);
    }
    return UnclampYfAnchoredAP1(original_gamma, black_gamma, mid_gray_gamma, neutral_gamma, blue_correction);
  }
  return UnclampLegacy(original_gamma, black_gamma, mid_gray_gamma, neutral_gamma);
}

float3 ApplyUnclampedScaling(float3 original_linear, float3 unclamped_linear, float strength) {
  if (CUSTOM_LUT_SCALING_METHOD == 0.f) {
    return renodx::lut::RecolorUnclamped(original_linear, unclamped_linear, strength);
  }
  return lerp(original_linear, unclamped_linear, saturate(strength));
}

struct LUTBridgeState {
  float3 adaptive_state_lms;
  float gamut_compression_scale;
  float max_channel_scale;
};

// input: BT.709 linear
// output: compressed BT.709 linear
float3 PrepareLUTInput(float3 color_bt709, out LUTBridgeState state) {
  state.adaptive_state_lms = renodx::color::lms::from::BT709(0.18f.xxx);
  state.gamut_compression_scale = 1.f;

  if (CUSTOM_LUT_GAMUT_RESTORATION != 0.f) {
    if (CUSTOM_LUT_GAMUT_COMPRESSION_METHOD == 0.f) {
      const float mid_gray_gamma = log(1.f / pow(10.f, 0.75f)) / log(0.5f);
      float3 encoded = renodx::color::gamma::EncodeSafe(color_bt709, mid_gray_gamma);
      float encoded_gray = renodx::color::gamma::Encode(
          renodx::color::y::from::BT709(color_bt709),
          mid_gray_gamma);
      state.gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(
          encoded,
          encoded_gray);
      color_bt709 = renodx::color::gamma::DecodeSafe(
          renodx::color::correct::GamutCompress(
              encoded,
              encoded_gray,
              state.gamut_compression_scale),
          mid_gray_gamma);
    } else {
      state.gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(
          color_bt709,
          state.adaptive_state_lms,
          1.f);
      color_bt709 = renodx::color::gamut::GamutCompressBT709AdaptiveD65(
          color_bt709,
          state.adaptive_state_lms,
          state.gamut_compression_scale);
    }
  }

  state.max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color_bt709);
  return color_bt709 * state.max_channel_scale;
}

// input: compressed BT.709 linear
// output: restored BT.709 linear
float3 RestoreLUTOutput(float3 color_bt709, LUTBridgeState state) {
  color_bt709 = renodx::math::DivideSafe(
      color_bt709,
      state.max_channel_scale.xxx,
      color_bt709);
  if (CUSTOM_LUT_GAMUT_RESTORATION == 0.f) return color_bt709;

  if (CUSTOM_LUT_GAMUT_COMPRESSION_METHOD == 0.f) {
    const float mid_gray_gamma = log(1.f / pow(10.f, 0.75f)) / log(0.5f);
    float3 encoded = renodx::color::gamma::EncodeSafe(color_bt709, mid_gray_gamma);
    float encoded_gray = renodx::color::gamma::Encode(
        renodx::color::y::from::BT709(color_bt709),
        mid_gray_gamma);
    return renodx::color::gamma::DecodeSafe(
        renodx::color::correct::GamutDecompress(
            encoded,
            encoded_gray,
            state.gamut_compression_scale),
        mid_gray_gamma);
  }

  return renodx::color::gamut::GamutDecompressBT709AdaptiveD65(
      color_bt709,
      state.adaptive_state_lms,
      state.gamut_compression_scale);
}

// single LUT
// input: BT.709 sRGB encoded
// output: BT.709 sRGB encoded
float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture,
    UECbufferConfig cb_config) {
  color_srgb = saturate(color_srgb);

  float _952 = (color_srgb.g * 0.9375f) + 0.03125f;
  float _959 = color_srgb.b * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((color_srgb.r * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  // float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  // float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float4 _966 = lut_texture.SampleLevel(lut_sampler, float2(_963, _952), 0.f);
  float4 _973 = lut_texture.SampleLevel(lut_sampler, float2((_963 + 0.0625f), _952), 0.f);
  float _992 = (((lerp(_966.x, _973.x, _961)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * color_srgb.r));
  float _993 = (((lerp(_966.y, _973.y, _961)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * color_srgb.g));
  float _994 = (((lerp(_966.z, _973.z, _961)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * color_srgb.b));

  float3 lutted_srgb = float3(_992, _993, _994);

  return lutted_srgb;
}

// input: BT.709 linear
// output: BT.709 linear
float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input, UECbufferConfig cb_config) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = SamplePacked1DLut(lut_input_color, lut_config.lut_sampler, lut_texture, cb_config);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = SamplePacked1DLut(float3(0, 0, 0), lut_config.lut_sampler, lut_texture, cb_config);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = SamplePacked1DLut(lut_black, lut_config.lut_sampler, lut_texture, cb_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(ApplyGammaCorrection(color_output, false, cb_config.ue_bluecorrection), lut_config);
        lut_black = renodx::lut::ConvertInput(ApplyGammaCorrection(lut_black_linear, false, cb_config.ue_bluecorrection), lut_config);
        lut_mid = renodx::lut::ConvertInput(ApplyGammaCorrection(renodx::lut::LinearOutput(lut_mid, lut_config), false, cb_config.ue_bluecorrection), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config),
          cb_config.ue_bluecorrection);

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = ApplyGammaCorrection(unclamped_linear, true, cb_config.ue_bluecorrection);
      }

      color_output = ApplyUnclampedScaling(color_output, unclamped_linear, lut_config.scaling);
    }
  } else {
  }

  return color_output;
}

// input: BT.709 linear
// output: BT.709 linear
void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b, UECbufferConfig cb_config) {
  LUTBridgeState bridge_state;
  float3 lut_input = PrepareLUTInput(color_lut_input, bridge_state);
  float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, lut_input, cb_config);
  float3 color_output = lerp(
      color_lut_input,
      RestoreLUTOutput(lutted, bridge_state),
      saturate(CUSTOM_LUT_STRENGTH));

  if (RENODX_TONE_MAP_TYPE == 0.f) color_output = saturate(color_output);

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// blending 2 LUTs
// input: BT.709 sRGB encoded
// output: BT.709 sRGB encoded
float3 Sample2Packed1DLuts(
    float3 color_srgb,
    SamplerState lut_sampler1,
    SamplerState lut_sampler2,
    Texture2D<float4> lut_texture1,
    Texture2D<float4> lut_texture2,
    UECbufferConfig cb_config) {
  color_srgb = saturate(color_srgb);

  float _928 = color_srgb.r;
  float _939 = color_srgb.g;
  float _950 = color_srgb.b;

  float _954 = (_939 * 0.9375f) + 0.03125f;
  float _961 = _950 * 15.0f;
  float _962 = floor(_961);
  float _963 = _961 - _962;
  float _965 = (_962 + ((_928 * 0.9375f) + 0.03125f)) * 0.0625f;
  // float4 _968 = lut_texture1.Sample(lut_sampler1, float2(_965, _954));
  float4 _968 = lut_texture1.SampleLevel(lut_sampler1, float2(_965, _954), 0.f);
  float _972 = _965 + 0.0625f;
  // float4 _975 = lut_texture1.Sample(lut_sampler1, float2(_972, _954));
  float4 _975 = lut_texture1.SampleLevel(lut_sampler1, float2(_972, _954), 0.f);
  // float4 _998 = lut_texture2.Sample(lut_sampler2, float2(_965, _954));
  float4 _998 = lut_texture2.SampleLevel(lut_sampler2, float2(_965, _954), 0.f);
  // float4 _1004 = lut_texture2.Sample(lut_sampler2, float2(_972, _954));
  float4 _1004 = lut_texture2.SampleLevel(lut_sampler2, float2(_972, _954), 0.f);
  float _1023 = ((((lerp(_968.x, _975.x, _963)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * _928)) + ((lerp(_998.x, _1004.x, _963)) * (cb_config.ue_lutweights[0].z)));
  float _1024 = ((((lerp(_968.y, _975.y, _963)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * _939)) + ((lerp(_998.y, _1004.y, _963)) * (cb_config.ue_lutweights[0].z)));
  float _1025 = ((((lerp(_968.z, _975.z, _963)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * _950)) + ((lerp(_998.z, _1004.z, _963)) * (cb_config.ue_lutweights[0].z)));

  float3 lutted_srgb = float3(_1023, _1024, _1025);

  return lutted_srgb;
}

// input: BT.709 linear
// output: BT.709 linear
float3 Sample2LUTSRGBInSRGBOut(Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, SamplerState lut_sampler1, SamplerState lut_sampler2, float3 color_input, UECbufferConfig cb_config) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample2Packed1DLuts(lut_input_color, lut_sampler1, lut_sampler2, lut_texture1, lut_texture2, cb_config);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = Sample2Packed1DLuts(float3(0, 0, 0), lut_sampler1, lut_sampler2, lut_texture1, lut_texture2, cb_config);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = Sample2Packed1DLuts(lut_black, lut_sampler1, lut_sampler2, lut_texture1, lut_texture2, cb_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(ApplyGammaCorrection(color_output, false, cb_config.ue_bluecorrection), lut_config);
        lut_black = renodx::lut::ConvertInput(ApplyGammaCorrection(lut_black_linear, false, cb_config.ue_bluecorrection), lut_config);
        lut_mid = renodx::lut::ConvertInput(ApplyGammaCorrection(renodx::lut::LinearOutput(lut_mid, lut_config), false, cb_config.ue_bluecorrection), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config),
          cb_config.ue_bluecorrection);

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = ApplyGammaCorrection(unclamped_linear, true, cb_config.ue_bluecorrection);
      }

      color_output = ApplyUnclampedScaling(color_output, unclamped_linear, lut_config.scaling);
    }
  } else {
  }

  return color_output;
}

// input: BT.709 linear
// output: BT.709 linear
void Sample2LUTsUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler1, SamplerState lut_sampler2, Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, inout float output_r, inout float output_g, inout float output_b, UECbufferConfig cb_config) {
  LUTBridgeState bridge_state;
  float3 lut_input = PrepareLUTInput(color_lut_input, bridge_state);
  float3 lutted = Sample2LUTSRGBInSRGBOut(
      lut_texture1,
      lut_texture2,
      lut_sampler1,
      lut_sampler2,
      lut_input,
      cb_config);
  float3 color_output = lerp(
      color_lut_input,
      RestoreLUTOutput(lutted, bridge_state),
      saturate(CUSTOM_LUT_STRENGTH));

  if (RENODX_TONE_MAP_TYPE == 0.f) color_output = saturate(color_output);

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// blending 3 LUTs
// input: BT.709 sRGB encoded
// output: BT.709 sRGB encoded
float3 Sample3Packed1DLuts(
    float3 color_srgb,
    SamplerState Samplers_1,
    SamplerState Samplers_2,
    SamplerState Samplers_3,
    Texture2D<float4> Textures_1,
    Texture2D<float4> Textures_2,
    Texture2D<float4> Textures_3,
    UECbufferConfig cb_config) {
  color_srgb = saturate(color_srgb);

  float _1189 = color_srgb.r, _1200 = color_srgb.g, _1211 = color_srgb.b;

  float _1215 = (_1200 * 0.9375f) + 0.03125f;
  float _1222 = _1211 * 15.0f;
  float _1223 = floor(_1222);
  float _1224 = _1222 - _1223;
  float _1226 = (_1223 + ((_1189 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1229 = Textures_1.SampleLevel(Samplers_1, float2(_1226, _1215), 0.0f);
  float _1233 = _1226 + 0.0625f;
  float4 _1234 = Textures_1.SampleLevel(Samplers_1, float2(_1233, _1215), 0.0f);
  float4 _1256 = Textures_2.SampleLevel(Samplers_2, float2(_1226, _1215), 0.0f);
  float4 _1260 = Textures_2.SampleLevel(Samplers_2, float2(_1233, _1215), 0.0f);
  float4 _1282 = Textures_3.SampleLevel(Samplers_3, float2(_1226, _1215), 0.0f);
  float4 _1286 = Textures_3.SampleLevel(Samplers_3, float2(_1233, _1215), 0.0f);
  // float _1305 = ((((((lerp(_1229.x, _1234.x, _1224)) * cb0_005y) + (cb0_005x * _1189)) + ((lerp(_1256.x, _1260.x, _1224)) * cb0_005z)) + ((lerp(_1282.x, _1286.x, _1224)) * cb0_005w)));
  // float _1306 = ((((((lerp(_1229.y, _1234.y, _1224)) * cb0_005y) + (cb0_005x * _1200)) + ((lerp(_1256.y, _1260.y, _1224)) * cb0_005z)) + ((lerp(_1282.y, _1286.y, _1224)) * cb0_005w)));
  // float _1307 = ((((((lerp(_1229.z, _1234.z, _1224)) * cb0_005y) + (cb0_005x * _1211)) + ((lerp(_1256.z, _1260.z, _1224)) * cb0_005z)) + ((lerp(_1282.z, _1286.z, _1224)) * cb0_005w)));
  float _1305 = ((((((lerp(_1229.x, _1234.x, _1224)) * cb_config.ue_lutweights[0].y) + (cb_config.ue_lutweights[0].x * _1189)) + ((lerp(_1256.x, _1260.x, _1224)) * cb_config.ue_lutweights[0].z)) + ((lerp(_1282.x, _1286.x, _1224)) * cb_config.ue_lutweights[0].w)));
  float _1306 = ((((((lerp(_1229.y, _1234.y, _1224)) * cb_config.ue_lutweights[0].y) + (cb_config.ue_lutweights[0].x * _1200)) + ((lerp(_1256.y, _1260.y, _1224)) * cb_config.ue_lutweights[0].z)) + ((lerp(_1282.y, _1286.y, _1224)) * cb_config.ue_lutweights[0].w)));
  float _1307 = ((((((lerp(_1229.z, _1234.z, _1224)) * cb_config.ue_lutweights[0].y) + (cb_config.ue_lutweights[0].x * _1211)) + ((lerp(_1256.z, _1260.z, _1224)) * cb_config.ue_lutweights[0].z)) + ((lerp(_1282.z, _1286.z, _1224)) * cb_config.ue_lutweights[0].w)));

  float3 lutted_srgb = float3(_1305, _1306, _1307);

  return lutted_srgb;
}

// input: BT.709 linear
// output: BT.709 linear
float3 Sample3LUTSRGBInSRGBOut(
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3,
    float3 color_input, UECbufferConfig cb_config) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample3Packed1DLuts(
      lut_input_color,
      lut_sampler1, lut_sampler2, lut_sampler3,
      lut_texture1, lut_texture2, lut_texture3,
      cb_config);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = Sample3Packed1DLuts(float3(0, 0, 0),
                                           lut_sampler1, lut_sampler2, lut_sampler3,
                                           lut_texture1, lut_texture2, lut_texture3,
                                           cb_config);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = Sample3Packed1DLuts(lut_black,
                                           lut_sampler1, lut_sampler2, lut_sampler3,
                                           lut_texture1, lut_texture2, lut_texture3,
                                           cb_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(ApplyGammaCorrection(color_output, false, cb_config.ue_bluecorrection), lut_config);
        lut_black = renodx::lut::ConvertInput(ApplyGammaCorrection(lut_black_linear, false, cb_config.ue_bluecorrection), lut_config);
        lut_mid = renodx::lut::ConvertInput(ApplyGammaCorrection(renodx::lut::LinearOutput(lut_mid, lut_config), false, cb_config.ue_bluecorrection), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config),
          cb_config.ue_bluecorrection);

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = ApplyGammaCorrection(unclamped_linear, true, cb_config.ue_bluecorrection);
      }

      color_output = ApplyUnclampedScaling(color_output, unclamped_linear, lut_config.scaling);
    }
  } else {
  }

  return color_output;
}

// input: BT.709 linear
// output: BT.709 linear
void Sample3LUTsUpgradeToneMap(
    float3 color_lut_input,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3,
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3,
    inout float output_r, inout float output_g, inout float output_b, UECbufferConfig cb_config) {
  LUTBridgeState bridge_state;
  float3 lut_input = PrepareLUTInput(color_lut_input, bridge_state);
  float3 lutted = Sample3LUTSRGBInSRGBOut(
      lut_texture1, lut_texture2, lut_texture3,
      lut_sampler1, lut_sampler2, lut_sampler3,
      lut_input,
      cb_config);
  float3 color_output = lerp(
      color_lut_input,
      RestoreLUTOutput(lutted, bridge_state),
      saturate(CUSTOM_LUT_STRENGTH));

  if (RENODX_TONE_MAP_TYPE == 0.f) color_output = saturate(color_output);

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// // blending 4 LUTs
// input: BT.709 sRGB encoded
// output: BT.709 sRGB encoded
float3 Sample4Packed1DLuts(
    float3 color_srgb,
    SamplerState Samplers_1,
    SamplerState Samplers_2,
    SamplerState Samplers_3,
    SamplerState Samplers_4,
    Texture2D<float4> Textures_1,
    Texture2D<float4> Textures_2,
    Texture2D<float4> Textures_3,
    Texture2D<float4> Textures_4,
    UECbufferConfig cb_config) {
  color_srgb = saturate(color_srgb);

  float _884 = color_srgb.r, _895 = color_srgb.g, _906 = color_srgb.b;

  float _910 = (_895 * 0.9375f) + 0.03125f;
  float _917 = _906 * 15.0f;
  float _918 = floor(_917);
  float _919 = _917 - _918;
  float _921 = (_918 + ((_884 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _924 = Textures_1.SampleLevel(Samplers_1, float2(_921, _910), 0.0f);
  float _928 = _921 + 0.0625f;
  float4 _929 = Textures_1.SampleLevel(Samplers_1, float2(_928, _910), 0.0f);
  float4 _951 = Textures_2.SampleLevel(Samplers_2, float2(_921, _910), 0.0f);
  float4 _955 = Textures_2.SampleLevel(Samplers_2, float2(_928, _910), 0.0f);
  float4 _977 = Textures_3.SampleLevel(Samplers_3, float2(_921, _910), 0.0f);
  float4 _981 = Textures_3.SampleLevel(Samplers_3, float2(_928, _910), 0.0f);
  float4 _1004 = Textures_4.SampleLevel(Samplers_4, float2(_921, _910), 0.0f);
  float4 _1008 = Textures_4.SampleLevel(Samplers_4, float2(_928, _910), 0.0f);
  float _1027 = (((((((lerp(_924.x, _929.x, _919)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * _884)) + ((lerp(_951.x, _955.x, _919)) * (cb_config.ue_lutweights[0].z))) + ((lerp(_977.x, _981.x, _919)) * (cb_config.ue_lutweights[0].w))) + ((lerp(_1004.x, _1008.x, _919)) * (cb_config.ue_lutweights[1].x))));
  float _1028 = (((((((lerp(_924.y, _929.y, _919)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * _895)) + ((lerp(_951.y, _955.y, _919)) * (cb_config.ue_lutweights[0].z))) + ((lerp(_977.y, _981.y, _919)) * (cb_config.ue_lutweights[0].w))) + ((lerp(_1004.y, _1008.y, _919)) * (cb_config.ue_lutweights[1].x))));
  float _1029 = (((((((lerp(_924.z, _929.z, _919)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * _906)) + ((lerp(_951.z, _955.z, _919)) * (cb_config.ue_lutweights[0].z))) + ((lerp(_977.z, _981.z, _919)) * (cb_config.ue_lutweights[0].w))) + ((lerp(_1004.z, _1008.z, _919)) * (cb_config.ue_lutweights[1].x))));

  float3 lutted_srgb = float3(_1027, _1028, _1029);

  return lutted_srgb;
}

// input: BT.709 linear
// output: BT.709 linear
float3 Sample4LUTSRGBInSRGBOut(
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3, Texture2D<float4> lut_texture4,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3, SamplerState lut_sampler4,
    float3 color_input, UECbufferConfig cb_config) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample4Packed1DLuts(
      lut_input_color,
      lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
      lut_texture1, lut_texture2, lut_texture3, lut_texture4,
      cb_config);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = Sample4Packed1DLuts(float3(0, 0, 0),
                                           lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
                                           lut_texture1, lut_texture2, lut_texture3, lut_texture4,
                                           cb_config);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = Sample4Packed1DLuts(lut_black,
                                           lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
                                           lut_texture1, lut_texture2, lut_texture3, lut_texture4,
                                           cb_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(ApplyGammaCorrection(color_output, false, cb_config.ue_bluecorrection), lut_config);
        lut_black = renodx::lut::ConvertInput(ApplyGammaCorrection(lut_black_linear, false, cb_config.ue_bluecorrection), lut_config);
        lut_mid = renodx::lut::ConvertInput(ApplyGammaCorrection(renodx::lut::LinearOutput(lut_mid, lut_config), false, cb_config.ue_bluecorrection), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config),
          cb_config.ue_bluecorrection);

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = ApplyGammaCorrection(unclamped_linear, true, cb_config.ue_bluecorrection);
      }

      color_output = ApplyUnclampedScaling(color_output, unclamped_linear, lut_config.scaling);
    }
  } else {
  }

  return color_output;
}

// input: BT.709 linear
// output: BT.709 linear
void Sample4LUTsUpgradeToneMap(
    float3 color_lut_input,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3, SamplerState lut_sampler4,
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3, Texture2D<float4> lut_texture4,
    inout float output_r, inout float output_g, inout float output_b, UECbufferConfig cb_config) {
  LUTBridgeState bridge_state;
  float3 lut_input = PrepareLUTInput(color_lut_input, bridge_state);
  float3 lutted = Sample4LUTSRGBInSRGBOut(
      lut_texture1, lut_texture2, lut_texture3, lut_texture4,
      lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
      lut_input,
      cb_config);
  float3 color_output = lerp(
      color_lut_input,
      RestoreLUTOutput(lutted, bridge_state),
      saturate(CUSTOM_LUT_STRENGTH));

  if (RENODX_TONE_MAP_TYPE == 0.f) color_output = saturate(color_output);

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// //#endif  // End Use SDR Luts

#endif  // INCLUDE_FILMIC_LUTBUILDER