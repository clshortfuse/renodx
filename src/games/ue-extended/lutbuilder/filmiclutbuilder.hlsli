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

float3 ApplyPostToneMapDesaturation(float3 tonemapped) {
  float grayscale = renodx::color::y::from::AP1(tonemapped);
  return max(0.f, lerp(grayscale, tonemapped, 0.93f));
}

float3 LerpToneMapStrength(float3 tonemapped, float3 preRRT, UECbufferConfig cb_config) {
  preRRT = min(100.f, preRRT);  // prevents artifacts during night vision in Robocop
  return lerp(preRRT, tonemapped, saturate(cb_config.ue_tonecurveammount));
}

// AP1 -> AP0 -> Blue Corrected AP0 -> AP1
float3 ApplyBlueCorrectionPre(float3 untonemapped_ap1, UECbufferConfig cb_config) {
  float r = untonemapped_ap1.r, g = untonemapped_ap1.g, b = untonemapped_ap1.b;

  float corrected_r = ((mad(0.061360642313957214f, b, mad(-4.540197551250458e-09f, g, (r * 0.9386394023895264f))) - r) * cb_config.ue_bluecorrection) + r;
  float corrected_g = ((mad(0.169205904006958f, b, mad(0.8307942152023315f, g, (r * 6.775371730327606e-08f))) - g) * cb_config.ue_bluecorrection) + g;
  float corrected_b = (mad(-2.3283064365386963e-10f, g, (r * -9.313225746154785e-10f)) * cb_config.ue_bluecorrection) + b;

  return float3(corrected_r, corrected_g, corrected_b);
}

float3 ApplyBlueCorrectionPost(float3 tonemapped, UECbufferConfig cb_config) {
  float _1131 = tonemapped.r, _1132 = tonemapped.g, _1133 = tonemapped.b;
  // return tonemapped;

  float _1149 = ((mad(-0.06537103652954102f, _1133, mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))) - _1131) * cb_config.ue_bluecorrection) + _1131;
  float _1150 = ((mad(-0.20366770029067993f, _1133, mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))) - _1132) * cb_config.ue_bluecorrection) + _1132;
  float _1151 = ((mad(0.9999996423721313f, _1133, mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))) - _1133) * cb_config.ue_bluecorrection) + _1133;
  return float3(_1149, _1150, _1151);
}

void ApplyFilmToneMapWithBlueCorrect(float3 untonemapped,
                                     inout float3 tonemapped, UECbufferConfig cb_config) {
  float3 untonemapped_ap1 = untonemapped;
  renodx::color::grade::Config cg_config = CreateColorGradingConfig();
  float y = renodx::color::y::from::AP1(untonemapped_ap1);
  float3 hue_reference_color = untonemapped_ap1;

  float3 untonemapped_ap1_graded = untonemapped_ap1;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    untonemapped_ap1_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, y, cg_config, 0.18f);
  }

  float3 tonemapped_ap1;

  // Vanilla+ and UE Filmic
  float3 untonemapped_prebluecorrect_ap1 = ApplyBlueCorrectionPre(untonemapped_ap1_graded, cb_config);
  float3 untonemapped_rrt_prebluecorrect_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_prebluecorrect_ap1));

  float3 tonemapped_prebluecorrect_ap1;
  if (RENODX_TONE_MAP_TYPE == 0.f) {  // Vanilla
    tonemapped_prebluecorrect_ap1 =
        unrealengine::filmtonemap::ApplyToneCurve(untonemapped_rrt_prebluecorrect_ap1, cb_config.ue_filmslope, cb_config.ue_filmtoe, cb_config.ue_filmshoulder, cb_config.ue_filmblackclip, cb_config.ue_filmwhiteclip);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    tonemapped_prebluecorrect_ap1 =
        ApplyToneCurveExtendedWithHermite(untonemapped_rrt_prebluecorrect_ap1, cb_config.ue_filmslope, cb_config.ue_filmtoe, cb_config.ue_filmshoulder, cb_config.ue_filmblackclip, cb_config.ue_filmwhiteclip);
  }

  tonemapped_prebluecorrect_ap1 = ApplyPostToneMapDesaturation(tonemapped_prebluecorrect_ap1);
  tonemapped_prebluecorrect_ap1 = LerpToneMapStrength(tonemapped_prebluecorrect_ap1, untonemapped_ap1_graded, cb_config);
  tonemapped_ap1 = ApplyBlueCorrectionPost(tonemapped_prebluecorrect_ap1, cb_config);
  tonemapped_ap1 = max(0, tonemapped_ap1);

  // Moved to GenerateOutput
  // if (RENODX_TONE_MAP_TYPE != 0.f) {
  //   tonemapped_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(tonemapped_ap1, hue_reference_color, y, cg_config, RENODX_TONE_MAP_HUE_CORRECTION_TYPE);
  // }

  tonemapped = tonemapped_ap1;

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
  // if (RENODX_TONE_MAP_TYPE == 4.f || CUSTOM_LUT_GAMUT_RESTORATION == 0.f || !is_hdr) return color_linear;
  if (CUSTOM_LUT_GAMUT_RESTORATION == 0.f) return color_linear;

  const float MID_GRAY_GAMMA = log(1 / (pow(10, 0.75))) / log(0.5f);  // ~2.49f

  float3 encoded = renodx::color::gamma::EncodeSafe(color_linear, MID_GRAY_GAMMA);
  float encoded_gray = renodx::color::gamma::Encode(renodx::color::y::from::BT709(color_linear), MID_GRAY_GAMMA);

  gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(encoded, encoded_gray);

  float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray, gamut_compression_scale);

  return renodx::color::gamma::DecodeSafe(compressed, MID_GRAY_GAMMA);
}

float3 GamutDecompress(float3 color_linear, float gamut_compression_scale) {
  // if (RENODX_TONE_MAP_TYPE == 4.f || CUSTOM_LUT_GAMUT_RESTORATION == 0.f || !is_hdr) return color_linear;
  if (CUSTOM_LUT_GAMUT_RESTORATION == 0.f) return color_linear;

  const float MID_GRAY_GAMMA = log(1 / (pow(10, 0.75))) / log(0.5f);  // ~2.49f

  float3 encoded = renodx::color::gamma::EncodeSafe(color_linear, MID_GRAY_GAMMA);
  float encoded_gray = renodx::color::gamma::Encode(renodx::color::y::from::BT709(color_linear), MID_GRAY_GAMMA);

  float3 decompressed = renodx::color::correct::GamutDecompress(encoded, encoded_gray, gamut_compression_scale);

  return renodx::color::gamma::DecodeSafe(decompressed, MID_GRAY_GAMMA);
}

float3 ComputeMaxChannelScaleAndCompress(float3 color_srgb, inout float channel_compression_scale) {
  // if (RENODX_TONE_MAP_TYPE != 4.f && is_hdr) {
  channel_compression_scale = renodx::math::Max(color_srgb.r, color_srgb.g, color_srgb.b, 1.f);
  color_srgb /= channel_compression_scale;
  // }
  return color_srgb;
}

// single LUT
float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture,
    UECbufferConfig cb_config) {
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
  // float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  // float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float4 _966 = lut_texture.SampleLevel(lut_sampler, float2(_963, _952), 0.f);
  float4 _973 = lut_texture.SampleLevel(lut_sampler, float2((_963 + 0.0625f), _952), 0.f);
  float _992 = (((lerp(_966.x, _973.x, _961)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * color_srgb.r));
  float _993 = (((lerp(_966.y, _973.y, _961)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * color_srgb.g));
  float _994 = (((lerp(_966.z, _973.z, _961)) * (cb_config.ue_lutweights[0].y)) + ((cb_config.ue_lutweights[0].x) * color_srgb.b));

  float3 lutted_srgb = float3(_992, _993, _994);

  {
    lutted_srgb *= max_channel;
  }

  return lutted_srgb;
}

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input, UECbufferConfig cb_config) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float gamut_compression_scale = 1.f;
  {
    color_input = ComputeGamutCompressionScaleAndCompress(color_input, gamut_compression_scale);
  }

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = SamplePacked1DLut(lut_input_color, lut_config.lut_sampler, lut_texture, cb_config);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  color_output = GamutDecompress(color_output, gamut_compression_scale);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = SamplePacked1DLut(float3(0, 0, 0), lut_config.lut_sampler, lut_texture, cb_config);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = SamplePacked1DLut(lut_black, lut_config.lut_sampler, lut_texture, cb_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
        lut_mid = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(renodx::lut::LinearOutput(lut_mid, lut_config)), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  return color_output;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b, UECbufferConfig cb_config) {
  float3 color_output = color_lut_input;

  // Clip lut if SDR
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float3 sdr_lut = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input, cb_config);
    color_output = saturate(lerp(color_lut_input, sdr_lut, saturate(CUSTOM_LUT_STRENGTH)));
  } else {
    float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color_lut_input);

    float3 color_lut_input_tonemapped = (color_lut_input * scale);  // Tonemap MaxCh to 1

    float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input_tonemapped, cb_config);

    float3 lutted_inversed = (lutted / scale);  // Inverse scale

    color_output = lerp(color_lut_input, lutted_inversed, saturate(CUSTOM_LUT_STRENGTH));
  }

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// blending 2 LUTs
float3 Sample2Packed1DLuts(
    float3 color_srgb,
    SamplerState lut_sampler1,
    SamplerState lut_sampler2,
    Texture2D<float4> lut_texture1,
    Texture2D<float4> lut_texture2,
    UECbufferConfig cb_config) {
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

  {
    lutted_srgb *= max_channel;
  }

  return lutted_srgb;
}

float3 Sample2LUTSRGBInSRGBOut(Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, SamplerState lut_sampler1, SamplerState lut_sampler2, float3 color_input, UECbufferConfig cb_config) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float gamut_compression_scale = 1.f;
  {
    color_input = ComputeGamutCompressionScaleAndCompress(color_input, gamut_compression_scale);
  }

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample2Packed1DLuts(lut_input_color, lut_sampler1, lut_sampler2, lut_texture1, lut_texture2, cb_config);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  color_output = GamutDecompress(color_output, gamut_compression_scale);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = Sample2Packed1DLuts(float3(0, 0, 0), lut_sampler1, lut_sampler2, lut_texture1, lut_texture2, cb_config);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      // set lut_mid based on lut_black to target shadows more
      float3 lut_mid = Sample2Packed1DLuts(lut_black, lut_sampler1, lut_sampler2, lut_texture1, lut_texture2, cb_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
        lut_mid = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(renodx::lut::LinearOutput(lut_mid, lut_config)), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  return color_output;
}

void Sample2LUTsUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler1, SamplerState lut_sampler2, Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, inout float output_r, inout float output_g, inout float output_b, UECbufferConfig cb_config) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float3 sdr_lut = Sample2LUTSRGBInSRGBOut(lut_texture1, lut_texture2, lut_sampler1, lut_sampler2, color_lut_input, cb_config);
    color_output = saturate(lerp(color_lut_input, sdr_lut, saturate(CUSTOM_LUT_STRENGTH)));
  } else {
    float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color_lut_input);

    float3 color_lut_input_tonemapped = (color_lut_input * scale);  // Tonemap MaxCh to 1

    float3 lutted = Sample2LUTSRGBInSRGBOut(lut_texture1, lut_texture2, lut_sampler1, lut_sampler2, color_lut_input_tonemapped, cb_config);

    float3 lutted_inversed = (lutted / scale);  // Inverse scale

    color_output = lerp(color_lut_input, lutted_inversed, saturate(CUSTOM_LUT_STRENGTH));
  }

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// blending 3 LUTs
float3 Sample3Packed1DLuts(
    float3 color_srgb,
    SamplerState Samplers_1,
    SamplerState Samplers_2,
    SamplerState Samplers_3,
    Texture2D<float4> Textures_1,
    Texture2D<float4> Textures_2,
    Texture2D<float4> Textures_3,
    UECbufferConfig cb_config) {
  float max_channel = 1.f;
  {
    color_srgb = ComputeMaxChannelScaleAndCompress(color_srgb, max_channel);
  }

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

  {
    lutted_srgb *= max_channel;
  }

  return lutted_srgb;
}

float3 Sample3LUTSRGBInSRGBOut(
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3,
    float3 color_input, UECbufferConfig cb_config) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float gamut_compression_scale = 1.f;
  {
    color_input = ComputeGamutCompressionScaleAndCompress(color_input, gamut_compression_scale);
  }

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample3Packed1DLuts(
      lut_input_color,
      lut_sampler1, lut_sampler2, lut_sampler3,
      lut_texture1, lut_texture2, lut_texture3,
      cb_config);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  color_output = GamutDecompress(color_output, gamut_compression_scale);

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
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
        lut_mid = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(renodx::lut::LinearOutput(lut_mid, lut_config)), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  return color_output;
}

void Sample3LUTsUpgradeToneMap(
    float3 color_lut_input,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3,
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3,
    inout float output_r, inout float output_g, inout float output_b, UECbufferConfig cb_config) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float3 sdr_lut = Sample3LUTSRGBInSRGBOut(
        lut_texture1, lut_texture2, lut_texture3,
        lut_sampler1, lut_sampler2, lut_sampler3,
        color_lut_input,
        cb_config);

    color_output = saturate(lerp(color_lut_input, sdr_lut, saturate(CUSTOM_LUT_STRENGTH)));
  } else {
    float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color_lut_input);

    float3 color_lut_input_tonemapped = (color_lut_input * scale);  // Tonemap MaxCh to 1

    float3 lutted = Sample3LUTSRGBInSRGBOut(
        lut_texture1, lut_texture2, lut_texture3,
        lut_sampler1, lut_sampler2, lut_sampler3,
        color_lut_input_tonemapped,
        cb_config);

    float3 lutted_inversed = (lutted / scale);  // Inverse scale

    color_output = lerp(color_lut_input, lutted_inversed, saturate(CUSTOM_LUT_STRENGTH));
  }

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// // blending 4 LUTs
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
  float max_channel = 1.f;
  {
    color_srgb = ComputeMaxChannelScaleAndCompress(color_srgb, max_channel);
  }

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

  {
    lutted_srgb *= max_channel;
  }

  return lutted_srgb;
}

float3 Sample4LUTSRGBInSRGBOut(
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3, Texture2D<float4> lut_texture4,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3, SamplerState lut_sampler4,
    float3 color_input, UECbufferConfig cb_config) {
  renodx::lut::Config lut_config = CreateSRGBInSRGBOutLUTConfig();

  float gamut_compression_scale = 1.f;
  {
    color_input = ComputeGamutCompressionScaleAndCompress(color_input, gamut_compression_scale);
  }

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample4Packed1DLuts(
      lut_input_color,
      lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
      lut_texture1, lut_texture2, lut_texture3, lut_texture4,
      cb_config);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  color_output = GamutDecompress(color_output, gamut_compression_scale);

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
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
        lut_mid = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(renodx::lut::LinearOutput(lut_mid, lut_config)), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  return color_output;
}

void Sample4LUTsUpgradeToneMap(
    float3 color_lut_input,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3, SamplerState lut_sampler4,
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3, Texture2D<float4> lut_texture4,
    inout float output_r, inout float output_g, inout float output_b, UECbufferConfig cb_config) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float3 sdr_lut = Sample4LUTSRGBInSRGBOut(
        lut_texture1, lut_texture2, lut_texture3, lut_texture4,
        lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
        color_lut_input,
        cb_config);
    color_output = saturate(lerp(color_lut_input, sdr_lut, saturate(CUSTOM_LUT_STRENGTH)));
  } else {
    float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color_lut_input);

    float3 color_lut_input_tonemapped = (color_lut_input * scale);  // Tonemap MaxCh to 1

    float3 lutted = Sample4LUTSRGBInSRGBOut(
        lut_texture1, lut_texture2, lut_texture3, lut_texture4,
        lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
        color_lut_input_tonemapped,
        cb_config);

    float3 lutted_inversed = (lutted / scale);  // Inverse scale

    color_output = lerp(color_lut_input, lutted_inversed, saturate(CUSTOM_LUT_STRENGTH));
  }

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// //#endif  // End Use SDR Luts

#endif  // INCLUDE_FILMIC_LUTBUILDER