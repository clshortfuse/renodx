#include "./CBuffers/CBuffers_LUTbuilder.hlsli"
#if USES_SDR_LUTS

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

// single LUT
float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture) {
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

  return lutted_srgb;
}

float3 SampleLUTSRGBInSRGBOut(
    Texture2D<float4> lut_texture,
    SamplerState lut_sampler,
    float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = SamplePacked1DLut(lut_input_color, lut_config.lut_sampler, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = SamplePacked1DLut(renodx::lut::ConvertInput(0, lut_config), lut_config.lut_sampler, lut_texture);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      float3 lut_mid = SamplePacked1DLut(renodx::lut::ConvertInput(lut_black_y, lut_config), lut_config.lut_sampler, lut_texture);  // set midpoint based on black to avoid black crush
      float lut_shift = (renodx::color::y::from::BT709(renodx::lut::LinearOutput(lut_mid, lut_config)) + lut_black_y) / lut_black_y;

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input * lut_shift, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  }

  return color_output;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
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
  return lutted_srgb;
}

float3 Sample2LUTSRGBInSRGBOut(
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2,
    SamplerState lut_sampler1, SamplerState lut_sampler2,
    float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample2Packed1DLuts(lut_input_color, lut_sampler1, lut_sampler2, lut_texture1, lut_texture2);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = Sample2Packed1DLuts(renodx::lut::ConvertInput(0, lut_config), lut_sampler1, lut_sampler2, lut_texture1, lut_texture2);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      float3 lut_mid = Sample2Packed1DLuts(renodx::lut::ConvertInput(lut_black_y, lut_config), lut_sampler1, lut_sampler2, lut_texture1, lut_texture2);  // set midpoint based on black to avoid black crush
      float lut_shift = (renodx::color::y::from::BT709(renodx::lut::LinearOutput(lut_mid, lut_config)) + lut_black_y) / lut_black_y;

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input * lut_shift, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  }

  return color_output;
}

void Sample2LUTsUpgradeToneMap(
    float3 color_lut_input,
    SamplerState lut_sampler1, SamplerState lut_sampler2,
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2,
    inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted = Sample2LUTSRGBInSRGBOut(lut_texture1, lut_texture2, lut_sampler1, lut_sampler2, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(Sample2Packed1DLuts(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler1, lut_sampler2, lut_texture1, lut_texture2));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

// blending 4 LUTs
float3 Sample4Packed1DLuts(
    float3 color_srgb,
    SamplerState Samplers_1,
    SamplerState Samplers_2,
    SamplerState Samplers_3,
    SamplerState Samplers_4,
    Texture2D<float4> Textures_1,
    Texture2D<float4> Textures_2,
    Texture2D<float4> Textures_3,
    Texture2D<float4> Textures_4) {
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
  float _1027 = (((((((lerp(_924.x, _929.x, _919)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _884)) + ((lerp(_951.x, _955.x, _919)) * (LUTWeights[0].z))) + ((lerp(_977.x, _981.x, _919)) * (LUTWeights[0].w))) + ((lerp(_1004.x, _1008.x, _919)) * (LUTWeights[1].x))));
  float _1028 = (((((((lerp(_924.y, _929.y, _919)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _895)) + ((lerp(_951.y, _955.y, _919)) * (LUTWeights[0].z))) + ((lerp(_977.y, _981.y, _919)) * (LUTWeights[0].w))) + ((lerp(_1004.y, _1008.y, _919)) * (LUTWeights[1].x))));
  float _1029 = (((((((lerp(_924.z, _929.z, _919)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _906)) + ((lerp(_951.z, _955.z, _919)) * (LUTWeights[0].z))) + ((lerp(_977.z, _981.z, _919)) * (LUTWeights[0].w))) + ((lerp(_1004.z, _1008.z, _919)) * (LUTWeights[1].x))));

  float3 lutted_srgb = float3(_1027, _1028, _1029);
  return lutted_srgb;
}

float3 Sample4LUTSRGBInSRGBOut(
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3, Texture2D<float4> lut_texture4,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3, SamplerState lut_sampler4,
    float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = Sample4Packed1DLuts(
      lut_input_color,
      lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
      lut_texture1, lut_texture2, lut_texture3, lut_texture4);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = Sample4Packed1DLuts(
        renodx::lut::ConvertInput(0, lut_config),
        lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
        lut_texture1, lut_texture2, lut_texture3, lut_texture4);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      float3 lut_mid = Sample4Packed1DLuts(
          renodx::lut::ConvertInput(lut_black_y, lut_config),
          lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
          lut_texture1, lut_texture2, lut_texture3, lut_texture4);  // set midpoint based on black to avoid black crush
      float lut_shift = (renodx::color::y::from::BT709(renodx::lut::LinearOutput(lut_mid, lut_config)) + lut_black_y) / lut_black_y;

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input * lut_shift, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  }

  return color_output;
}

void Sample4LUTsUpgradeToneMap(
    float3 color_lut_input,
    SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3, SamplerState lut_sampler4,
    Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3, Texture2D<float4> lut_texture4,
    inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted = Sample4LUTSRGBInSRGBOut(
        lut_texture1, lut_texture2, lut_texture3, lut_texture4,
        lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
        color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(Sample4Packed1DLuts(
        renodx::color::srgb::EncodeSafe(color_lut_input),
        lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4,
        lut_texture1, lut_texture2, lut_texture3, lut_texture4));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

#endif  // USES_SDR_LUTS
