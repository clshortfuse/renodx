#include "../common.hlsli"
#include "./psycho_test17_custom.hlsli"

float3 ApplyGammaCorrectionForToneMap(float3 color_input) {
  float3 color_corrected;
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color_corrected = renodx::color::correct::GammaSafe(color_input);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    float y_in = renodx::color::yf::from::BT709(color_input);
    float y_out = renodx::color::correct::Gamma(max(0, y_in));
    float3 color_corrected_lum = renodx::color::correct::Luminance(color_input, y_in, y_out);

    float3 color_corrected_ch = renodx::color::correct::GammaSafe(color_input);

    color_corrected = renodx::color::bt709::from::BT2020(renodx_custom::tonemap::psycho::psycho17_ApplyPurityFromBT2020(
        renodx::color::bt2020::from::BT709(color_corrected_ch), renodx::color::bt2020::from::BT709(color_corrected_lum), 1.f, 1.f));
  } else {
    color_corrected = color_input;
  }

  return color_corrected;
}

float ComputeVanillaToneMapMaxChannelScale(float3 untonemapped_bt709,
                                           float InUniform_Constant_064_y,
                                           float InUniform_Constant_064_z,
                                           float InUniform_Constant_080_z,
                                           float InUniform_Constant_096_x,
                                           float InUniform_Constant_096_y,
                                           float InUniform_Constant_096_z) {
  float max_channel = renodx::math::Max(untonemapped_bt709);
  float InUniform_Constant_096_x_neg = -InUniform_Constant_096_x;
  float tonemapped_max = (max_channel < InUniform_Constant_080_z)
                             ? ((max_channel * InUniform_Constant_064_y) + InUniform_Constant_064_z)
                             : ((InUniform_Constant_096_x_neg / (max_channel + InUniform_Constant_096_y)) + InUniform_Constant_096_z);
  return renodx::math::DivideSafe(tonemapped_max, max_channel, 1.f);
}

float3 SampleGamma2LUT(float3 color_input, Texture3D<float4> _29,
                       SamplerState lut_sampler,
                       float _40_m0_10u_z, float _40_m0_10u_w) {
  float3 lut_input = sqrt(color_input);
  float3 lutted = _29.SampleLevel(lut_sampler, lut_input * _40_m0_10u_z + _40_m0_10u_w, 0.f).rgb;
  lutted = lutted * lutted;

  return lutted;
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

float3 SampleGamma2LUTWithScaling(
    float3 color_input, Texture3D<float4> _29,
    SamplerState lut_sampler,
    float _40_m0_10u_z, float _40_m0_10u_w) {
  const float3 color_output_original = SampleGamma2LUT(color_input, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);

  float3 color_output = color_output_original;

  if (RENODX_COLOR_GRADE_SCALING > 0.f) {
    float3 lut_black = SampleGamma2LUT(0.f, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);

    float lut_black_y = renodx::color::yf::from::BT709(lut_black);
    if (lut_black_y > 0.f) {
      float3 lut_mid = SampleGamma2LUT(lut_black_y, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        color_output = renodx::color::correct::GammaSafe(color_output);
        lut_black = renodx::color::correct::GammaSafe(lut_black);
        lut_mid = renodx::color::correct::GammaSafe(lut_mid);
        // color_input = renodx::color::correct::GammaSafe(color_input);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::color::srgb::EncodeSafe(color_output),
          renodx::color::srgb::EncodeSafe(lut_black),
          renodx::color::srgb::EncodeSafe(lut_mid),
          renodx::color::srgb::EncodeSafe(color_input));

      float3 unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped_gamma);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      color_output = color_output_original * lerp(1.f, renodx::math::DivideSafe(renodx::color::yf::from::BT709(unclamped_linear), renodx::color::yf::from::BT709(color_output_original), 1.f), RENODX_COLOR_GRADE_SCALING);
    }
  }

  return color_output;
}

void ApplyTonemapGamma2LUTAndInverseTonemap(
    SamplerState lut_sampler,
    Texture3D<float4> _29,
    float _643, float _644, float _645,
    float _40_m0_2u_w,
    float _40_m0_2u_x, float _40_m0_2u_y, float _40_m0_2u_z,
    float _40_m0_3u_x, float _40_m0_3u_y, float _40_m0_3u_z, float _40_m0_3u_w,
    float _40_m0_10u_z, float _40_m0_10u_w,
    inout float frontier_phi_14_15_ladder,
    inout float frontier_phi_14_15_ladder_1,
    inout float frontier_phi_14_15_ladder_2) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    // tonemap + gamma 2 encode + sample LUT
    float _729 = (-0.0f) - _40_m0_2u_w;
    float4 _762 = _29.SampleLevel(lut_sampler,
                                  float3((clamp(sqrt(max((_643 < _40_m0_3u_z) ? ((_643 * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_643 + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w,
                                         (clamp(sqrt(max((_644 < _40_m0_3u_z) ? ((_644 * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_644 + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w,
                                         (clamp(sqrt(max((_645 < _40_m0_3u_z) ? ((_645 * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_645 + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w),
                                  0.0f);

    // gamma 2 -> linear with clamp
    float _770 = min(_762.x * _762.x, _40_m0_2u_x);
    float _771 = min(_762.y * _762.y, _40_m0_2u_x);
    float _772 = min(_762.z * _762.z, _40_m0_2u_x);

    // inverse tonemap
    frontier_phi_14_15_ladder = (_772 < _40_m0_3u_w) ? ((_772 - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_772 - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_1 = (_771 < _40_m0_3u_w) ? ((_771 - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_771 - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_2 = (_770 < _40_m0_3u_w) ? ((_770 - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_770 - _40_m0_3u_y)) - _40_m0_3u_x);
  } else {
    float3 color = float3(_643, _644, _645);
    color = max(0, color);

    {  // apply gamma 2 lut
      float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color);
      float3 lutted = SampleGamma2LUTWithScaling(color * scale, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);
      //   lutted = min(lutted, _40_m0_2u_x);
      lutted /= scale;

      color = lerp(color, lutted, RENODX_COLOR_GRADE_STRENGTH);
    }

    frontier_phi_14_15_ladder = color.b, frontier_phi_14_15_ladder_1 = color.g, frontier_phi_14_15_ladder_2 = color.r;
  }
}

// Dual-path variant used by DLSSFG-style pipelines:
// - `frontier_phi_14_15_ladder{,_1,_2}`: inverse-tonemapped non-LUT path (B, G, R)
// - `frontier_phi_14_15_ladder{_3,_4,_5}`: inverse-tonemapped LUT path (B, G, R)
void ApplyTonemapGamma2LUTAndInverseTonemapDualOutputsOld(
    SamplerState lut_sampler,
    Texture3D<float4> _29,
    float _643_no_lut, float _644_no_lut, float _645_no_lut,
    float _643_lut, float _644_lut, float _645_lut,
    float _40_m0_2u_w,
    float _40_m0_2u_x, float _40_m0_2u_y, float _40_m0_2u_z,
    float _40_m0_3u_x, float _40_m0_3u_y, float _40_m0_3u_z, float _40_m0_3u_w,
    float _40_m0_10u_z, float _40_m0_10u_w,
    inout float frontier_phi_14_15_ladder,
    inout float frontier_phi_14_15_ladder_1,
    inout float frontier_phi_14_15_ladder_2,
    inout float frontier_phi_14_15_ladder_3,
    inout float frontier_phi_14_15_ladder_4,
    inout float frontier_phi_14_15_ladder_5) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float _729 = (-0.0f) - _40_m0_2u_w;

    // Non-LUT path: tonemap + gamma2 encode/decode.
    float _no_lut_r_gamma = sqrt(max((_643_no_lut < _40_m0_3u_z) ? ((_643_no_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_643_no_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f));
    float _no_lut_g_gamma = sqrt(max((_644_no_lut < _40_m0_3u_z) ? ((_644_no_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_644_no_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f));
    float _no_lut_b_gamma = sqrt(max((_645_no_lut < _40_m0_3u_z) ? ((_645_no_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_645_no_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f));

    float _no_lut_r_linear = _no_lut_r_gamma * _no_lut_r_gamma;
    float _no_lut_g_linear = _no_lut_g_gamma * _no_lut_g_gamma;
    float _no_lut_b_linear = _no_lut_b_gamma * _no_lut_b_gamma;

    // LUT path: tonemap + gamma2 encode + sample LUT + gamma2 decode.
    float4 _762 = _29.SampleLevel(lut_sampler,
                                  float3((clamp(sqrt(max((_643_lut < _40_m0_3u_z) ? ((_643_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_643_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w,
                                         (clamp(sqrt(max((_644_lut < _40_m0_3u_z) ? ((_644_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_644_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w,
                                         (clamp(sqrt(max((_645_lut < _40_m0_3u_z) ? ((_645_lut * _40_m0_2u_y) + _40_m0_2u_z) : ((_729 / (_645_lut + _40_m0_3u_x)) + _40_m0_3u_y), 0.0f)), 0.0f, 1.0f) * _40_m0_10u_z) + _40_m0_10u_w),
                                  0.0f);

    float _lut_r_linear = _762.x * _762.x;
    float _lut_g_linear = _762.y * _762.y;
    float _lut_b_linear = _762.z * _762.z;

    float _no_lut_r_clamped = min(_no_lut_r_linear, _40_m0_2u_x);
    float _no_lut_g_clamped = min(_no_lut_g_linear, _40_m0_2u_x);
    float _no_lut_b_clamped = min(_no_lut_b_linear, _40_m0_2u_x);

    float _lut_r_clamped = min(_lut_r_linear, _40_m0_2u_x);
    float _lut_g_clamped = min(_lut_g_linear, _40_m0_2u_x);
    float _lut_b_clamped = min(_lut_b_linear, _40_m0_2u_x);

    // Inverse tonemap: non-LUT output set.
    frontier_phi_14_15_ladder = (_no_lut_b_clamped < _40_m0_3u_w) ? ((_no_lut_b_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_no_lut_b_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_1 = (_no_lut_g_clamped < _40_m0_3u_w) ? ((_no_lut_g_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_no_lut_g_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_2 = (_no_lut_r_clamped < _40_m0_3u_w) ? ((_no_lut_r_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_no_lut_r_clamped - _40_m0_3u_y)) - _40_m0_3u_x);

    // Inverse tonemap: LUT output set.
    frontier_phi_14_15_ladder_3 = (_lut_b_clamped < _40_m0_3u_w) ? ((_lut_b_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_lut_b_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_4 = (_lut_g_clamped < _40_m0_3u_w) ? ((_lut_g_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_lut_g_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
    frontier_phi_14_15_ladder_5 = (_lut_r_clamped < _40_m0_3u_w) ? ((_lut_r_clamped - _40_m0_2u_z) / _40_m0_2u_y) : ((_729 / (_lut_r_clamped - _40_m0_3u_y)) - _40_m0_3u_x);
  } else {
    float3 no_lut_color = max(0, float3(_643_no_lut, _644_no_lut, _645_no_lut));
    float3 color = max(0, float3(_643_lut, _644_lut, _645_lut));

    {  // apply gamma 2 lut
      float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color);
      float3 lutted = SampleGamma2LUTWithScaling(color * scale, _29, lut_sampler, _40_m0_10u_z, _40_m0_10u_w);
      //   lutted = min(lutted, _40_m0_2u_x);
      lutted /= scale;

      color = lerp(color, lutted, RENODX_COLOR_GRADE_STRENGTH);
    }

    frontier_phi_14_15_ladder = no_lut_color.b, frontier_phi_14_15_ladder_1 = no_lut_color.g, frontier_phi_14_15_ladder_2 = no_lut_color.r;
    frontier_phi_14_15_ladder_3 = color.b, frontier_phi_14_15_ladder_4 = color.g, frontier_phi_14_15_ladder_5 = color.r;
  }
}

void ApplyTonemapGamma2LUTAndInverseTonemapDualOutputs(
    SamplerState lut_sampler,
    Texture3D<float4> _19,
    float _262, float _266, float _270,
    float _394, float _396, float _398,
    float _26_m0_14_x, float _26_m0_14_y, float _26_m0_14_z, float _26_m0_14_w,
    float _26_m0_15_x, float _26_m0_15_y, float _26_m0_15_z, float _26_m0_15_w,
    float _26_m0_18_x, float _26_m0_18_y,
    inout float frontier_phi_10_11_ladder,
    inout float frontier_phi_10_11_ladder_1,
    inout float frontier_phi_10_11_ladder_2,
    inout float frontier_phi_10_11_ladder_3,
    inout float frontier_phi_10_11_ladder_4,
    inout float frontier_phi_10_11_ladder_5) {
  ApplyTonemapGamma2LUTAndInverseTonemap(
      lut_sampler,
      _19,
      _262, _266, _270,
      _26_m0_14_w,
      _26_m0_14_x, _26_m0_14_y, _26_m0_14_z,
      _26_m0_15_x, _26_m0_15_y, _26_m0_15_z, _26_m0_15_w,
      _26_m0_18_x, _26_m0_18_y,
      frontier_phi_10_11_ladder,
      frontier_phi_10_11_ladder_1,
      frontier_phi_10_11_ladder_2);

  ApplyTonemapGamma2LUTAndInverseTonemap(
      lut_sampler,
      _19,
      _394, _396, _398,
      _26_m0_14_w,
      _26_m0_14_x, _26_m0_14_y, _26_m0_14_z,
      _26_m0_15_x, _26_m0_15_y, _26_m0_15_z, _26_m0_15_w,
      _26_m0_18_x, _26_m0_18_y,
      frontier_phi_10_11_ladder_3,
      frontier_phi_10_11_ladder_4,
      frontier_phi_10_11_ladder_5);
}

float3 ApplyVanillaToneMap(float3 untonemapped_bt709,
                           float InUniform_Constant_064_y,
                           float InUniform_Constant_064_z,
                           float InUniform_Constant_080_z,
                           float InUniform_Constant_096_x,
                           float InUniform_Constant_096_y,
                           float InUniform_Constant_096_z) {
  float InUniform_Constant_096_x_neg = -InUniform_Constant_096_x;
  return select(untonemapped_bt709 < InUniform_Constant_080_z,
                (untonemapped_bt709 * InUniform_Constant_064_y) + InUniform_Constant_064_z,
                (InUniform_Constant_096_x_neg / (untonemapped_bt709 + InUniform_Constant_096_y)) + InUniform_Constant_096_z);
}

float3 ApplyUserGradingAndToneMapAndScale(float3 untonemapped_bt709,
                                          float InUniform_Constant_064_y,
                                          float InUniform_Constant_064_z,
                                          float InUniform_Constant_080_z,
                                          float InUniform_Constant_096_x,
                                          float InUniform_Constant_096_y,
                                          float InUniform_Constant_096_z,
                                          bool use_scaling = true) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return ApplyVanillaToneMap(
        untonemapped_bt709,
        InUniform_Constant_064_y, InUniform_Constant_064_z,
        InUniform_Constant_080_z,
        InUniform_Constant_096_x, InUniform_Constant_096_y, InUniform_Constant_096_z);
  } else {
    untonemapped_bt709 = ApplyGammaCorrectionForToneMap(untonemapped_bt709);

    float3 untonemapped_bt2020 = renodx::color::bt2020::from::BT709(untonemapped_bt709);

    float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

    renodx_custom::tonemap::psycho::config17::Config psycho17_config =
        renodx_custom::tonemap::psycho::config17::Create();
    psycho17_config.peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    psycho17_config.clip_point = 100.f;
    psycho17_config.exposure = RENODX_TONE_MAP_EXPOSURE;
    psycho17_config.gamma = RENODX_TONE_MAP_GAMMA;
    psycho17_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
    psycho17_config.shadows = RENODX_TONE_MAP_SHADOWS;
    psycho17_config.contrast = RENODX_TONE_MAP_CONTRAST;
    psycho17_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
    psycho17_config.contrast_highlights = RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS;
    psycho17_config.contrast_shadows = RENODX_TONE_MAP_CONTRAST_SHADOWS;
    psycho17_config.purity_scale = RENODX_TONE_MAP_SATURATION;
    psycho17_config.purity_highlights = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
    psycho17_config.dechroma = 0.f;
    psycho17_config.adaptation_contrast = RENODX_TONE_MAP_ADAPTATION_CONTRAST;
    psycho17_config.bleaching_intensity = 0.f;
    psycho17_config.hue_emulation = RENODX_TONE_MAP_HUE_EMULATION;
    psycho17_config.pre_gamut_compress = false;
    psycho17_config.post_gamut_compress = true;
    psycho17_config.apply_tonemap = true;

    float3 hue_shift_source_bt2020 = untonemapped_bt2020;
    if (psycho17_config.hue_emulation != 0.f) {
      hue_shift_source_bt2020 = renodx::color::bt2020::from::BT709(renodx::tonemap::ReinhardPiecewise(untonemapped_bt709, 4.f, psycho17_config.mid_gray));
    }
    float3 tonemapped_bt2020 = renodx_custom::tonemap::psycho::ApplyTest17BT2020(untonemapped_bt2020, hue_shift_source_bt2020, psycho17_config);

    if (use_scaling) {
      tonemapped_bt2020 *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    }

    float3 tonemapped_bt709 = renodx::color::bt709::from::BT2020(tonemapped_bt2020);
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709, true);
    }

    return tonemapped_bt709;
  }
}

void ApplyUserGradingAndToneMapAndScale(
    float untonemapped_bt709_r, float untonemapped_bt709_g, float untonemapped_bt709_b,
    float InUniform_Constant_064_y, float InUniform_Constant_064_z,
    float InUniform_Constant_080_z,
    float InUniform_Constant_096_x, float InUniform_Constant_096_y, float InUniform_Constant_096_z,
    inout float tonemapped_bt709_r, inout float tonemapped_bt709_g, inout float tonemapped_bt709_b, bool use_scaling = true) {
  float3 untonemapped_bt709 = float3(untonemapped_bt709_r, untonemapped_bt709_g, untonemapped_bt709_b);

  float3 tonemapped_bt709 = ApplyUserGradingAndToneMapAndScale(
      untonemapped_bt709,
      InUniform_Constant_064_y, InUniform_Constant_064_z,
      InUniform_Constant_080_z,
      InUniform_Constant_096_x, InUniform_Constant_096_y, InUniform_Constant_096_z,
      use_scaling);

  tonemapped_bt709_r = tonemapped_bt709.r, tonemapped_bt709_g = tonemapped_bt709.g, tonemapped_bt709_b = tonemapped_bt709.b;
  return;
}

void ApplyUserGradingAndToneMapAndScaleDual(
    float untonemapped_bt709_r_0, float untonemapped_bt709_g_0, float untonemapped_bt709_b_0,
    float untonemapped_bt709_r_1, float untonemapped_bt709_g_1, float untonemapped_bt709_b_1,
    float InUniform_Constant_064_y, float InUniform_Constant_064_z,
    float InUniform_Constant_080_z,
    float InUniform_Constant_096_x, float InUniform_Constant_096_y, float InUniform_Constant_096_z,
    inout float tonemapped_bt709_r_0, inout float tonemapped_bt709_g_0, inout float tonemapped_bt709_b_0,
    inout float tonemapped_bt709_r_1, inout float tonemapped_bt709_g_1, inout float tonemapped_bt709_b_1) {
  ApplyUserGradingAndToneMapAndScale(
      untonemapped_bt709_r_0, untonemapped_bt709_g_0, untonemapped_bt709_b_0,
      InUniform_Constant_064_y, InUniform_Constant_064_z,
      InUniform_Constant_080_z,
      InUniform_Constant_096_x, InUniform_Constant_096_y, InUniform_Constant_096_z,
      tonemapped_bt709_r_0, tonemapped_bt709_g_0, tonemapped_bt709_b_0);

  ApplyUserGradingAndToneMapAndScale(
      untonemapped_bt709_r_1, untonemapped_bt709_g_1, untonemapped_bt709_b_1,
      InUniform_Constant_064_y, InUniform_Constant_064_z,
      InUniform_Constant_080_z,
      InUniform_Constant_096_x, InUniform_Constant_096_y, InUniform_Constant_096_z,
      tonemapped_bt709_r_1, tonemapped_bt709_g_1, tonemapped_bt709_b_1);

  return;
}
