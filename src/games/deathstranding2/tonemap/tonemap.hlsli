#include "../common.hlsli"
#include "./psycho_test11.hlsli"

float3 ApplyGammaCorrectionForToneMap(float3 color_input) {
  float3 color_corrected;
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color_corrected = renodx::color::correct::GammaSafe(color_input);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    float y_in = renodx_custom::tonemap::psycho::psycho11_StockmanLuminanceFromBT709(color_input);
    float y_out = renodx::color::correct::Gamma(max(0, y_in));
    float3 color_corrected_lum = renodx::color::correct::Luminance(color_input, y_in, y_out);

    float3 color_corrected_ch = renodx::color::correct::GammaSafe(color_input);

    color_corrected = renodx::color::bt709::from::BT2020(renodx_custom::tonemap::psycho::psycho11_ApplyPurityFromBT2020(
        renodx::color::bt2020::from::BT709(color_corrected_ch), renodx::color::bt2020::from::BT709(color_corrected_lum), 1.f));
  } else {
    color_corrected = color_input;
  }

  return color_corrected;
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.18f, float output_max = 1.f, float white_clip = 0.f) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);

  float mapped_peak;
  if (white_clip == 0.f) {
    mapped_peak = renodx::tonemap::ReinhardPiecewise(peak, output_max, rolloff_start);
  } else {
    mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  }
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 HermiteSplineMaxCLL(float3 color, float peak_ratio, float white_clip = 100.f) {
  float maxch = renodx::math::Max(color);

  float tonemapped = exp2(renodx::tonemap::HermiteSplineRolloff(log2(maxch), log2(peak_ratio), log2(white_clip)));

  float scale = renodx::math::DivideSafe(tonemapped, maxch, 1.f);
  return color * scale;
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

void ApplyTonemapGamma2LUTAndInverseTonemap(
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
    float4 _762 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u],
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

    {  // apply gamma 2 lut
       //   float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color);
      float scale = ComputeReinhardSmoothClampScale(color);

      float3 lut_input = sqrt(max(0, color * scale));
      float3 lutted = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], lut_input * _40_m0_10u_z + _40_m0_10u_w, 0.f).rgb;
      lutted = lutted * lutted;
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
void ApplyTonemapGamma2LUTAndInverseTonemapDualOutputs(
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
    float4 _762 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u],
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
    float3 no_lut_color = float3(_643_no_lut, _644_no_lut, _645_no_lut);
    float3 color = float3(_643_lut, _644_lut, _645_lut);

    {  // apply gamma 2 lut
       //   float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color);
      float scale = ComputeReinhardSmoothClampScale(color);

      float3 lut_input = sqrt(max(0, color * scale));
      float3 lutted = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], lut_input * _40_m0_10u_z + _40_m0_10u_w, 0.f).rgb;
      lutted = lutted * lutted;
      //   lutted = min(lutted, _40_m0_2u_x);
      lutted /= scale;

      color = lerp(color, lutted, RENODX_COLOR_GRADE_STRENGTH);
    }

    frontier_phi_14_15_ladder = no_lut_color.b, frontier_phi_14_15_ladder_1 = no_lut_color.g, frontier_phi_14_15_ladder_2 = no_lut_color.r;
    frontier_phi_14_15_ladder_3 = color.b, frontier_phi_14_15_ladder_4 = color.g, frontier_phi_14_15_ladder_5 = color.r;
  }
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

#if 1
    untonemapped_bt2020 = renodx_custom::tonemap::psycho::psycho11_RestoreHueBT2020(renodx::tonemap::ReinhardPiecewise(untonemapped_bt2020, 12.5f, 1.f), untonemapped_bt2020, RENODX_TONE_MAP_HUE_SHIFT);

    float3 tonemapped_bt2020;
    if (RENODX_TONE_MAP_TYPE == 2.f) {  // Psycho
      tonemapped_bt2020 = renodx_custom::tonemap::psycho::psychotm_test11_bt2020(
          untonemapped_bt2020, peak_ratio,
          RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_GAMMA, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS, RENODX_TONE_MAP_CONTRAST,
          0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, RENODX_TONE_MAP_CONTRAST_SHADOWS, RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_ADAPTATION_CONTRAST,
          RENODX_TONE_MAP_HUE_CORRECTION, 0.f, 100.f);
    } else {  // None
      untonemapped_bt2020 = renodx_custom::tonemap::psycho::psycho11_GradeBT2020(
          untonemapped_bt2020, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_GAMMA, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS, RENODX_TONE_MAP_CONTRAST,
          0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, RENODX_TONE_MAP_CONTRAST_SHADOWS, 0.18f, RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_ADAPTATION_CONTRAST, RENODX_TONE_MAP_HUE_CORRECTION, 0.f);

      tonemapped_bt2020 = untonemapped_bt2020;
    }

    // tonemapped_bt2020 *= peak_ratio / (max(max(max(untonemapped_bt2020.r, untonemapped_bt2020.g), untonemapped_bt2020.b), peak_ratio));  // Clamp overshoot
#else

    {  // blow out and hue shift
      float3 purity_and_hue_source = renodx::tonemap::ReinhardPiecewise(untonemapped_bt2020, 12.5f, 1.f);
      //   float3 purity_and_hue_source = renodx::tonemap::neutwo::PerChannel(untonemapped_bt2020, 10.f);
      untonemapped_bt2020 = renodx::color::correct::Luminance(
          purity_and_hue_source,
          renodx_custom::tonemap::psycho::psycho11_StockmanLuminanceFromBT2020(purity_and_hue_source),
          renodx_custom::tonemap::psycho::psycho11_StockmanLuminanceFromBT2020(untonemapped_bt2020));
    }

    {
      untonemapped_bt2020 = renodx_custom::tonemap::psycho::psycho11_GradeBT2020(
          untonemapped_bt2020, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS, RENODX_TONE_MAP_CONTRAST,
          RENODX_TONE_MAP_FLARE, RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, RENODX_TONE_MAP_CONTRAST_SHADOWS, 0.1f, RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_ADAPTATION_CONTRAST, 1.f, 0.f);
    }

    float3 tonemapped_bt2020 = renodx::tonemap::neutwo::MaxChannel(untonemapped_bt2020, peak_ratio);
    // float3 tonemapped_bt2020 = HermiteSplineMaxCLL(untonemapped_bt2020, peak_ratio);

#endif

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
