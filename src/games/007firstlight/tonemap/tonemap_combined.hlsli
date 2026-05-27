#ifndef FIRSTLIGHT_TONEMAP_COMBINED_HLSLI
#define FIRSTLIGHT_TONEMAP_COMBINED_HLSLI

#include "./tonemap.hlsli"

// Defaults match PostChainMergeHDR_T3_CS_0x33CB3D22.
#define POSTCHAINMERGE_TONEMAP_NONE     0
#define POSTCHAINMERGE_TONEMAP_REINHARD 1
#define POSTCHAINMERGE_TONEMAP_HABLE    2
#define POSTCHAINMERGE_TONEMAP_FILM     3

#ifndef POSTCHAINMERGE_TONEMAP_TYPE
#define POSTCHAINMERGE_TONEMAP_TYPE POSTCHAINMERGE_TONEMAP_FILM
#endif

#ifndef POSTCHAINMERGE_FULL_POST
#define POSTCHAINMERGE_FULL_POST 1
#endif

#ifndef POSTCHAINMERGE_IS_SDR
#define POSTCHAINMERGE_IS_SDR 0
#endif

#ifndef POSTCHAINMERGE_APPLY_SDR_DITHER
#define POSTCHAINMERGE_APPLY_SDR_DITHER POSTCHAINMERGE_IS_SDR
#endif

#ifndef POSTCHAINMERGE_OUTPUT_ALPHA
#define POSTCHAINMERGE_OUTPUT_ALPHA 0.f
#endif

#ifndef POSTCHAINMERGE_ENABLE_CBUFFER_DEBUG
#define POSTCHAINMERGE_ENABLE_CBUFFER_DEBUG 0
#endif

#ifndef POSTCHAINMERGE_DEBUG_FILM_TONEMAPPED_OUTPUT
#define POSTCHAINMERGE_DEBUG_FILM_TONEMAPPED_OUTPUT 0
#endif

#ifndef POSTCHAINMERGE_DECLARE_RESOURCES
#define POSTCHAINMERGE_DECLARE_RESOURCES 1
#endif

#ifndef POSTCHAINMERGE_ENTRY_POINT
#define POSTCHAINMERGE_ENTRY_POINT main
#endif

#if !POSTCHAINMERGE_FULL_POST
#error tonemap_combined.hlsli currently reconstructs the full PostChainMerge T0-T3 path only.
#endif

#if POSTCHAINMERGE_DECLARE_RESOURCES
struct SHDRAdaptationState {
  float m_fLuminanceGeometricMean;
  float m_fAdaptedMiddleGray;
  float m_fAdaptedBloomPoint;
  float m_fAdaptedBloomPointThreshold;
  float m_fAdaptedBloomPointClamp;
  float m_fAdaptedLuminance;
  float m_fAdaptedExposure;
  float m_fAdaptedBrightPassThreshold;
  float m_fAdaptedBrightPassClamp;
};

Texture2D<float4> mapLinearLightTexture : register(t0);

Texture2D<float4> mapGlareTexture : register(t1);

Texture3D<float4> srvColorCorrectionVolume : register(t2);

Texture2D<float4> mapGridTexture : register(t3);

StructuredBuffer<SHDRAdaptationState> srvHDRAdaptationState : register(t6);

Texture2D<float> srvExposures : register(t14);

RWTexture2D<float4> uavOutput1 : register(u0);

SamplerState samplerLinearClampNode : register(s4);
#endif

float3 ApplyVignetteWhitePointAndVerticalFade(float3 color, float4 grid) {
  float radial_vignette = grid.z;
  float vertical_fade = grid.w;
  float3 vignette_scale = lerp(1.f, cbPostChainMerge.vVignetteParams.rgb, radial_vignette);
  float3 white_point_mapped_color = color * vignette_scale * cbPostChainMerge.fRcpMappedWhitePoint;
  float3 vertical_fade_additive = cbPostChainMerge.vParams2.rgb * vertical_fade;
  float3 output = white_point_mapped_color + vertical_fade_additive;

  return output;
}

float3 SampleSRGBColorCorrectionLUT(float3 color, float hdr_scale, float hdr_headroom) {
  if (TONE_MAP_TYPE != 0.f) {
    renodx::lut::Config lut_config = CreateLUTConfig(samplerLinearClampNode);

    float3 adaptive_state_lms = renodx::color::lms::from::BT709(max(0.18f.xxx, 1e-6f.xxx));
    float gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(
        color,
        adaptive_state_lms,
        1.f);
    color = renodx::color::gamut::GamutCompressBT709AdaptiveD65(
        color,
        adaptive_state_lms,
        gamut_compression_scale);

    color = max(0, color);
    float maxch_scale = ComputeMaxChCompressionScale(color);
    float3 lut_input = color * maxch_scale;
    float3 lut_color = renodx::lut::Sample(srvColorCorrectionVolume, lut_config, lut_input);
    lut_color /= maxch_scale;

    lut_color = renodx::color::gamut::GamutDecompressBT709AdaptiveD65(
        lut_color,
        adaptive_state_lms,
        gamut_compression_scale);

    lut_color = renodx::color::srgb::EncodeSafe(lut_color);
    return lut_color;

  } else {
    color = min(color, hdr_scale);
    float max_channel = max(color.r, max(color.g, color.b));
    float max_channel_scale = max(1.f, max_channel);
    float3 max_channel_scaled_color = color / max_channel_scale;
    float compression_start = saturate(hdr_headroom);
    float compression_amount = saturate((max_channel - compression_start) / (hdr_scale - compression_start));

    float3 compressed_lut_color = lerp(max_channel_scaled_color, saturate(color), compression_amount);
    float compressed_lut_luminance = renodx::color::y::from::BT709(compressed_lut_color);

    float3 lut_color = renodx::color::srgb::EncodeSafe(compressed_lut_color);
    float3 lut_sample = srvColorCorrectionVolume.SampleLevel(samplerLinearClampNode, (saturate(lut_color) * 0.9375f) + 0.03125f, 0.f).rgb;

    float luminance_scale = pow(renodx::color::y::from::BT709(color) / select((compressed_lut_luminance > 0.f), compressed_lut_luminance, 1.f), 1.f / 2.2f);
    float hdr_black_offset = cbPostChainMerge.vHDRParams.x * 0.01f;
    float hdr_output_scale = pow(cbPostChainMerge.vHDRParams.w, 1.f / 2.2f);

    return hdr_output_scale * ((luminance_scale * lut_sample) + hdr_black_offset);
  }
}

float3 ApplyOptionalGammaAdjust(float3 color) {
  if (TONE_MAP_TYPE == 0.f) {
    if (cbPostChainMerge.fOptionalGammaAdjust > 0.f) {
      color = saturate(pow(max(color, 0.0f), cbPostChainMerge.fOptionalGammaAdjust));
    }
  }

  return color;
}

struct CustomGradingConfig {
  float exposure;
  float highlights;
  float contrast_highlights;
  float shadows;
  float contrast_shadows;
  float contrast;
  float flare;
  float gamma;
  float saturation;
  float dechroma;
  float highlight_saturation;
};

float ApplyCustomHighlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {
    float b = mid_gray * pow(x / mid_gray, 2.f - highlights);
    float t = min(x, 1.f);
    return min(x, renodx::math::DivideSafe(x * x, lerp(x, b, t), x));
  }
}

float ApplyCustomShadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float ApplyCustomContrastAndFlare(float x, float contrast, float contrast_highlights, float contrast_shadows, float flare, float mid_gray) {
  if (contrast == 1.f && flare == 0.f && contrast_highlights == 1.f && contrast_shadows == 1.f) return x;

  const float x_normalized = x / mid_gray;
  const float split_contrast = renodx::math::Select(x < mid_gray, contrast_shadows, contrast_highlights);
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  float exponent = contrast * split_contrast * flare_ratio;
  return pow(x_normalized, exponent) * mid_gray;
}

float3 ApplyCustomLuminanceGrading(float3 color, float y_in, CustomGradingConfig config, float mid_gray) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f
      && config.contrast_highlights == 1.f && config.contrast_shadows == 1.f && config.flare == 0.f && config.gamma == 1.f) {
    return color;
  }

  color *= config.exposure;

  float y_gamma_adjusted = renodx::math::Select(y_in < 1.f, pow(y_in, config.gamma), y_in);
  float y_contrasted = ApplyCustomContrastAndFlare(y_gamma_adjusted, config.contrast, config.contrast_highlights, config.contrast_shadows, config.flare, mid_gray);
  float y_highlighted = ApplyCustomHighlights(y_contrasted, config.highlights, mid_gray);
  float y_out = ApplyCustomShadows(y_highlighted, config.shadows, mid_gray);

  return renodx::color::correct::Luminance(color, y_in, y_out);
}

float3 ApplyCustomChromaGrading(float3 color, float y, CustomGradingConfig config) {
  float chroma_scale = config.saturation;

  if (config.dechroma != 0.f) {
    chroma_scale *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
  }

  if (config.highlight_saturation != 0.f) {
    float percent_max = saturate(y * 100.f / 10000.f);
    float blowout_strength = 100.f;
    float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.highlight_saturation));
    if (config.highlight_saturation < 0.f) {
      blowout_change = 2.f - blowout_change;
    }
    chroma_scale *= blowout_change;
  }

  if (chroma_scale == 1.f) return color;

  return y + (color - y) * max(chroma_scale, 0.f);
}

float3 ApplyCustomGrading(float3 color_bt2020) {
  const CustomGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,
    RENODX_TONE_MAP_HIGHLIGHTS,
    RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
    RENODX_TONE_MAP_SHADOWS,
    RENODX_TONE_MAP_CONTRAST_SHADOWS,
    RENODX_TONE_MAP_CONTRAST,
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
    RENODX_TONE_MAP_GAMMA,
    RENODX_TONE_MAP_SATURATION,
    RENODX_TONE_MAP_DECHROMA,
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
  };

  float y = renodx::color::yf::from::BT2020(color_bt2020);
  color_bt2020 = ApplyCustomLuminanceGrading(color_bt2020, y, cg_config, 0.1f);
  y = renodx::color::yf::from::BT2020(color_bt2020);
  color_bt2020 = ApplyCustomChromaGrading(color_bt2020, y, cg_config);

  return color_bt2020;
}

float3 FinalizeOutput(float3 color) {
  if (TONE_MAP_TYPE != 0.f) {
    color = renodx::color::srgb::DecodeSafe(color);

    float3 color_lms = renodx::color::lms::from::BT709(color);

    if (RENODX_TONE_MAP_SCALING == 1.f) {
      color_lms = renodx::color::correct::GammaSafe(color_lms);
    } else {  // luminance gamma correction with LMS per-channel hue and purity
      float y_in = renodx::color::yf::from::LMS(color_lms);
      float y_out = renodx::color::correct::Gamma(max(0, y_in));
      float3 color_corrected_lum_lms = renodx::color::correct::Luminance(color_lms, y_in, y_out);

      float3 color_corrected_ch_lms = renodx::color::correct::GammaSafe(color_lms);

      color_lms = renodx::color::correct::Luminance(
          color_corrected_ch_lms,
          renodx::color::yf::from::LMS(color_corrected_ch_lms),
          renodx::color::yf::from::LMS(color_corrected_lum_lms));
    }

    color = renodx::color::bt709::from::LMS(color_lms);

    color = renodx::color::bt2020::from::BT709(color);

    color = ApplyCustomGrading(color);

    // bt.2020 max channel display mapping
    color = renodx::tonemap::neutwo::MaxChannel(max(0, color), RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;

    color = renodx::color::bt709::from::BT2020(color);
    color = renodx::color::gamma::EncodeSafe(color);
  }
  return color;
}

float3 ApplyToneMap(float3 untonemapped, float film_white_clip) {
  float3 tonemapped;
#if POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_NONE
  tonemapped = untonemapped;
#elif POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_REINHARD
  tonemapped = renodx::tonemap::Reinhard(untonemapped);
#elif POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_HABLE
  tonemapped = renodx::tonemap::ApplyCurve(untonemapped, 0.6f, 1.f, 0.1f, 1.f, 0.004f, 0.06f);
#elif POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_FILM

  if (TONE_MAP_TYPE != 0.f) {  // run tonemapper in lms normalized to BT.709 wh
    FilmTonemapConfig film_tonemap_config = CreateFilmTonemapConfig(100.f);
    const float sdr_blend_strength = 0.8f;

    float3 untonemapped_lms = renodx::color::lms::from::BT709(untonemapped);
    float3 untonemapped_lms_normalized = renodx::math::DivideSafe(untonemapped_lms, LMS_WHITE_BT709, 0.f.xxx);
    float3 per_channel_tonemapped_lms_normalized = ApplyFilmToneMapExtended(untonemapped_lms_normalized, film_tonemap_config, sdr_blend_strength);
    float3 per_channel_tonemapped_lms = per_channel_tonemapped_lms_normalized * LMS_WHITE_BT709;

#if 1
    float3 display_scaled_relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(
        per_channel_tonemapped_lms,
        LMS_WHITE_BT709);
    float3 lms_cones_relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(
        untonemapped_lms,
        LMS_WHITE_BT709);
    float3 mb_source = renodx::color::macleod_boynton::from::WeightedLMS(lms_cones_relative_weighted);
    float3 mb_display_target = renodx::color::macleod_boynton::from::WeightedLMS(display_scaled_relative_weighted);
    float3 mb_adapted_bg = renodx::color::macleod_boynton::from::LMS(1.f.xxx);

    float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
    float2 display_target_offset = mb_display_target.xy - mb_adapted_bg.xy;
    float src2 = dot(source_offset, source_offset);
    float display_tgt2 = dot(display_target_offset, display_target_offset);
    if (src2 > 1e-7f && display_tgt2 > 1e-7f) {
      float inv_target_radius = rsqrt(display_tgt2);
      float target_radius = display_tgt2 * inv_target_radius;
      float source_t_clip = renodx::tonemap::psychov::psycho17_RayExitTCIE1702(mb_adapted_bg.xy, source_offset);
      float display_t_clip = renodx::tonemap::psychov::psycho17_RayExitTCIE1702(mb_adapted_bg.xy, display_target_offset);
      float source_purity_signal = renodx::tonemap::psychov::psycho17_HueRelativePuritySignalFromTClip(source_t_clip);
      float display_purity_signal = renodx::tonemap::psychov::psycho17_HueRelativePuritySignalFromTClip(display_t_clip);
      float purity_signal_loss = saturate(display_purity_signal / source_purity_signal);
      float hue_sensitivity = renodx::tonemap::psychov::psycho17_AdaptiveHueSensitivityFromTClip(display_t_clip);
      float restore_weight = hue_sensitivity * 0.35f * purity_signal_loss;
      if (restore_weight > 0.f) {
        float inv_source_radius = rsqrt(src2);
        float2 source_dir = source_offset * inv_source_radius;
        float2 display_target_dir = display_target_offset * inv_target_radius;
        float2 blended_dir = lerp(display_target_dir, source_dir, restore_weight);
        float blended_len2 = dot(blended_dir, blended_dir);
        if (blended_len2 > 1e-7f) {
          blended_dir *= rsqrt(blended_len2);
        } else {
          blended_dir = display_target_dir;
        }

        float2 mb_restored_xy = mb_adapted_bg.xy + blended_dir * target_radius;
        float3 mb_restored = float3(mb_restored_xy, mb_display_target.z);
        display_scaled_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);
      }
    }

    per_channel_tonemapped_lms = renodx::color::macleod_boynton::UnweighLMS(
        renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(
            display_scaled_relative_weighted,
            LMS_WHITE_BT709));
#endif

    float3 peak_lms = LMS_WHITE_BT709 * (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    float3 hue_and_purity_reference = renodx::tonemap::neutwo::PerChannel(per_channel_tonemapped_lms, peak_lms);

    // roughly match bt709 tonemap saturation
    hue_and_purity_reference = lerp(renodx::color::yf::from::LMS(hue_and_purity_reference), hue_and_purity_reference, 0.9875f);

    if (RENODX_TONE_MAP_SCALING == 0.f) {
      float y_in = renodx::color::yf::from::LMS(untonemapped_lms);
      float y_out = ApplyFilmToneMapExtended(y_in, film_tonemap_config, sdr_blend_strength);
      float3 luminance_tonemapped_lms = renodx::color::correct::Luminance(untonemapped_lms, y_in, y_out);

      float3 tonemapped_lms = renodx::color::correct::Luminance(hue_and_purity_reference, renodx::color::yf::from::LMS(hue_and_purity_reference), renodx::color::yf::from::LMS(luminance_tonemapped_lms));
      tonemapped_lms = max(0, tonemapped_lms);
      tonemapped = renodx::color::bt709::from::LMS(tonemapped_lms);
    } else {
      float3 tonemapped_lms = renodx::color::correct::Luminance(hue_and_purity_reference, renodx::color::yf::from::LMS(hue_and_purity_reference), renodx::color::yf::from::LMS(per_channel_tonemapped_lms));
      tonemapped_lms = max(0, tonemapped_lms);
      tonemapped = renodx::color::bt709::from::LMS(tonemapped_lms);
    }
  } else {
    tonemapped = ApplyFilmToneMap(untonemapped, film_white_clip);
  }
#else
#error Unsupported POSTCHAINMERGE_TONEMAP_TYPE.
#endif

  return tonemapped;
}

[numthreads(8, 8, 1)]
void POSTCHAINMERGE_ENTRY_POINT(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _20;
  float _21;
  float4 _33;
  float _42;
  float _43;
  float4 _58;
  float4 _63;
  float _88;
  float _95;
  float _96;
  float _109;
  float _121;
  float _119;
  float _125;
  float _126;
  float _127;
  _20 = cbPostChainMerge.vPixelSize.x * (float((int)((int)(SV_DispatchThreadID.x))) + 0.5f);
  _21 = (float((int)((int)(SV_DispatchThreadID.y))) + 0.5f) * cbPostChainMerge.vPixelSize.y;
  _33 = mapGridTexture.SampleLevel(samplerLinearClampNode, float2(((_20 * cbPostChainMerge.vUVToGridUV.x) + cbPostChainMerge.vUVToGridUV.z), ((_21 * cbPostChainMerge.vUVToGridUV.y) + cbPostChainMerge.vUVToGridUV.w)), 0.0f);
  _42 = (cbPostChainMerge.fMaxUVDistortion * _33.x) + _20;
  _43 = (cbPostChainMerge.fMaxUVDistortion * _33.y) + _21;
  _58 = mapLinearLightTexture.SampleLevel(samplerLinearClampNode, float2(_42, _43), 0.0f);
  _63 = mapGlareTexture.SampleLevel(samplerLinearClampNode, float2(_42, _43), 0.0f);

  CalculateFilmTonemapHDRHeadroom(_88, _95, _96);

  if (!(cbPostChainMerge.nApplyExposure == 0)) {
    _109 = ((srvExposures.SampleLevel(samplerLinearClampNode, float2(_20, _21), 0.0f)).x);
  } else {
    _109 = 1.0f;
  }
  if (!(cbPostChainMerge.nApplyExposure == 0)) {
    _119 = srvHDRAdaptationState[0].m_fAdaptedExposure;
    _121 = _119;
  } else {
    _121 = 1.0f;
  }
  _125 = (((CUSTOM_BLOOM * cbPostChainMerge.fGlareStrength * _63.x) * cbPostChainMerge.vColorTint.x) * _121) + ((cbPostChainMerge.vColorTint.x * _58.x) * _109);
  _126 = (((CUSTOM_BLOOM * cbPostChainMerge.fGlareStrength * _63.y) * cbPostChainMerge.vColorTint.y) * _121) + ((cbPostChainMerge.vColorTint.y * _58.y) * _109);
  _127 = (((CUSTOM_BLOOM * cbPostChainMerge.fGlareStrength * _63.z) * cbPostChainMerge.vColorTint.z) * _121) + ((cbPostChainMerge.vColorTint.z * _58.z) * _109);

  float3 untonemapped = float3(_125, _126, _127);

  float3 tonemapped = ApplyToneMap(untonemapped, _96);

  float3 post_vignette_color = ApplyVignetteWhitePointAndVerticalFade(tonemapped, _33);

  float3 color_corrected = SampleSRGBColorCorrectionLUT(post_vignette_color, _88, _95);

  float3 output = ApplyOptionalGammaAdjust(color_corrected);

#if POSTCHAINMERGE_APPLY_SDR_DITHER
  float postchainmerge_dither = (frac(sin(dot(float2(_20, _21), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f) * 0.003921568859368563f) + -0.0019607844296842813f;
  output += postchainmerge_dither;
#endif

  output *= cbPostChainMerge.fFadeValue;

#if POSTCHAINMERGE_ENABLE_CBUFFER_DEBUG
#if POSTCHAINMERGE_DEBUG_FILM_TONEMAPPED_OUTPUT
  output = DrawPostChainMergeCBufferDebug(renodx::color::srgb::EncodeSafe(tonemapped), float2(SV_DispatchThreadID.xy));
#else
  output = DrawPostChainMergeCBufferDebug(output, float2((float)(SV_DispatchThreadID.x), (float)(SV_DispatchThreadID.y)));
#endif
#endif

  output = FinalizeOutput(output);

  //   output = renodx::color::srgb::EncodeSafe(tonemapped);

  uavOutput1[int2(SV_DispatchThreadID.xy)] = float4(output, POSTCHAINMERGE_OUTPUT_ALPHA);
}

#endif  // FIRSTLIGHT_TONEMAP_COMBINED_HLSLI
