#ifndef FIRSTLIGHT_TONEMAP_COMBINED_HLSLI
#define FIRSTLIGHT_TONEMAP_COMBINED_HLSLI

#include "./tonemap.hlsli"

void CalculateFilmTonemapHDRHeadroom(inout float hdr_scale, inout float hdr_headroom, inout float film_white_clip) {
  float black_offset = cbPostChainMerge.vHDRParams.x;
  float peak_white = cbPostChainMerge.vHDRParams.y;
  float diffuse_white = cbPostChainMerge.vHDRParams.z;
  if (TONE_MAP_TYPE != 0.f) {
    hdr_scale = 1.f;
    hdr_headroom = 0.f;
    film_white_clip = cbPostChainMerge.fFilmWhiteClip;
  } else {
    hdr_scale = max((peak_white - black_offset), diffuse_white) / diffuse_white;
    hdr_headroom = hdr_scale - 1.f;
    film_white_clip = max(hdr_headroom, cbPostChainMerge.fFilmWhiteClip);
  }
}

float3 ApplyToneMap(float3 untonemapped, float film_white_clip) {
  float3 tonemapped;
#if POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_NONE
  if (TONE_MAP_TYPE != 0.f) {
    float3 hue_and_purity_reference = renodx::tonemap::neutwo::PerChannel(untonemapped, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    tonemapped = renodx::color::correct::Luminance(hue_and_purity_reference, renodx::color::yf::from::BT709(hue_and_purity_reference), renodx::color::yf::from::BT709(untonemapped));
  } else {
    tonemapped = untonemapped;
  }
#elif POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_REINHARD
  tonemapped = renodx::tonemap::Reinhard(untonemapped);
#elif POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_HABLE
  tonemapped = renodx::tonemap::ApplyCurve(untonemapped, 0.6f, 1.f, 0.1f, 1.f, 0.004f, 0.06f);
#elif POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_FILM

  if (TONE_MAP_TYPE != 0.f) {
    FilmTonemapConfig film_tonemap_config = CreateFilmTonemapConfig(100.f);
    const float sdr_blend_strength = 0.88f;

    // branch tonemapper at (0.18, f(0.18)) and blend towards SDR so it isn't overly bright
    float3 per_channel_tonemapped = ApplyFilmToneMapExtended(untonemapped, film_tonemap_config, sdr_blend_strength);

    // add extra hue shifts and blowout based on user's peak setting
    // restore luminance afterwards so that max channel scaling to user peak can be deferred to the end
    float3 hue_and_purity_reference = renodx::tonemap::neutwo::PerChannel(per_channel_tonemapped, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    if (RENODX_TONE_MAP_SCALING == 0.f) {  // luminance tonemapping with purity and some hues from per channel
      float y_in = renodx::color::yf::from::BT709(untonemapped);
      float y_out = ApplyFilmToneMapExtended(y_in, film_tonemap_config, sdr_blend_strength);
      float3 lum_tonemapped = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

      tonemapped = renodx::color::bt709::from::LMS(TransferPurityAndWeightedHueFromLMS(renodx::color::lms::from::BT709(hue_and_purity_reference),
                                                                                       renodx::color::lms::from::BT709(lum_tonemapped), 5.f, 0.75f));
    } else {
      tonemapped = renodx::color::correct::Luminance(hue_and_purity_reference,
                                                     renodx::color::yf::from::BT709(hue_and_purity_reference),
                                                     renodx::color::yf::from::BT709(per_channel_tonemapped));
    }
  } else {
    tonemapped = ApplyFilmToneMap(untonemapped, film_white_clip);
  }
#else
#error Unsupported POSTCHAINMERGE_TONEMAP_TYPE.
#endif

  return tonemapped;
}

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
    float3 adaptive_state_lms;
    float gamut_compression_scale;

#if USE_EXPENSIVE_LUT_GAMUT_RESTORATION
    adaptive_state_lms = LMS_WHITE_BT709 * 0.18f;
    gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(color, adaptive_state_lms, 1.f);
    color = renodx::color::gamut::GamutCompressBT709AdaptiveD65(color, adaptive_state_lms, gamut_compression_scale);
#endif

    color = max(0, color);
#if POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_FILM || POSTCHAINMERGE_TONEMAP_TYPE == POSTCHAINMERGE_TONEMAP_NONE
    float maxch_scale = ComputeMaxChCompressionScale(color);
#else  // don't use max channel scaling with SDR tonemappers
    float maxch_scale = 1.f;
#endif

    float3 lut_color = renodx::lut::Sample(srvColorCorrectionVolume, CreateLUTConfig(samplerLinearClampNode), color * maxch_scale) / maxch_scale;

#if USE_EXPENSIVE_LUT_GAMUT_RESTORATION
    lut_color = renodx::color::gamut::GamutDecompressBT709AdaptiveD65(lut_color, adaptive_state_lms, gamut_compression_scale);
#endif

    lut_color = renodx::color::srgb::EncodeSafe(lut_color);
    return lut_color;
  } else {
    // compress by maxch to fit into LUT range
    color = min(color, hdr_scale);
    float max_channel = max(color.r, max(color.g, color.b));
    float max_channel_scale = max(1.f, max_channel);
    float3 max_channel_scaled_color = color / max_channel_scale;
    float compression_start = saturate(hdr_headroom);
    float compression_amount = saturate((max_channel - compression_start) / (hdr_scale - compression_start));

    // lerp between maxch compression and clipping as color approaches peak
    float3 compressed_lut_color = lerp(max_channel_scaled_color, saturate(color), compression_amount);

    float compressed_lut_luminance = renodx::color::y::from::BT709(compressed_lut_color);

    float3 lut_color = renodx::color::srgb::EncodeSafe(compressed_lut_color);
    float3 lut_sample = srvColorCorrectionVolume.SampleLevel(samplerLinearClampNode, (saturate(lut_color) * 0.9375f) + 0.03125f, 0.f).rgb;

    // calculate luminance lost during compression to restore to HDR range
    float luminance_scale = pow(renodx::color::y::from::BT709(color) / select((compressed_lut_luminance > 0.f), compressed_lut_luminance, 1.f), 1.f / 2.2f);
    float hdr_black_offset = cbPostChainMerge.vHDRParams.x * 0.01f;
    float hdr_output_scale = pow(cbPostChainMerge.vHDRParams.w, 1.f / 2.2f);

    return hdr_output_scale * ((luminance_scale * lut_sample) + hdr_black_offset);
  }
}

float3 ApplyOptionalGammaAdjust(float3 color) {
  if (TONE_MAP_TYPE == 0.f) {
    if (cbPostChainMerge.fOptionalGammaAdjust > 0.f) {
      color = saturate(pow(max(color, 0.f), cbPostChainMerge.fOptionalGammaAdjust));
    }
  }

  return color;
}

float3 FinalizeOutput(float3 color) {
  if (TONE_MAP_TYPE != 0.f) {
    color = renodx::color::srgb::DecodeSafe(color);

    if (RENODX_TONE_MAP_SCALING == 1.f) {
      color = renodx::color::correct::GammaSafe(color);
    } else {  // luminance gamma correction with purity and some hues from per channel
      float y_in = renodx::color::yf::from::BT709(color);
      float y_out = renodx::color::correct::Gamma(max(0, y_in));
      float3 color_corrected_lum = renodx::color::correct::Luminance(color, y_in, y_out);

      float3 color_corrected_ch = renodx::color::correct::GammaSafe(color);

      color = renodx::color::bt709::from::LMS(TransferPurityAndWeightedHueFromLMS(renodx::color::lms::from::BT709(color_corrected_ch),
                                                                                  renodx::color::lms::from::BT709(color_corrected_lum), 1.f, 0.75f));
    }

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

[numthreads(8, 8, 1)]
void main(uint3 SV_DispatchThreadID: SV_DispatchThreadID,
          uint3 SV_GroupID: SV_GroupID,
          uint3 SV_GroupThreadID: SV_GroupThreadID,
          uint SV_GroupIndex: SV_GroupIndex) {
  float2 pixel_uv = (float2(SV_DispatchThreadID.xy) + 0.5f) * cbPostChainMerge.vPixelSize;

  float2 grid_uv = (pixel_uv * cbPostChainMerge.vUVToGridUV.xy) + cbPostChainMerge.vUVToGridUV.zw;
  float4 grid = mapGridTexture.SampleLevel(samplerLinearClampNode, grid_uv, 0.f);

  float2 scene_uv = pixel_uv + (grid.xy * cbPostChainMerge.fMaxUVDistortion);
  float3 scene_color = mapLinearLightTexture.SampleLevel(samplerLinearClampNode, scene_uv, 0.f).rgb;
  float3 glare_color = mapGlareTexture.SampleLevel(samplerLinearClampNode, scene_uv, 0.f).rgb;

  float hdr_scale, hdr_headroom, film_white_clip;
  CalculateFilmTonemapHDRHeadroom(hdr_scale, hdr_headroom, film_white_clip);

  float scene_exposure = 1.f;
  float glare_exposure = 1.f;
  if (cbPostChainMerge.nApplyExposure != 0) {
    scene_exposure = srvExposures.SampleLevel(samplerLinearClampNode, pixel_uv, 0.f).x;
    glare_exposure = srvHDRAdaptationState[0].m_fAdaptedExposure;
  }

  float3 exposed_scene_color = scene_color * scene_exposure;

  float3 glare_contribution = glare_color * glare_exposure * cbPostChainMerge.fGlareStrength * CUSTOM_BLOOM;
  float3 scene_with_glare = exposed_scene_color + glare_contribution;

  float3 tinted_scene_color = scene_with_glare * cbPostChainMerge.vColorTint.rgb;

  float3 tonemapped = ApplyToneMap(tinted_scene_color, film_white_clip);

  float3 post_vignette_color = ApplyVignetteWhitePointAndVerticalFade(tonemapped, grid);

  float3 color_corrected = SampleSRGBColorCorrectionLUT(post_vignette_color, hdr_scale, hdr_headroom);

  float3 output = ApplyOptionalGammaAdjust(color_corrected);

#if POSTCHAINMERGE_APPLY_SDR_DITHER
  float dither_noise = frac(sin(dot(pixel_uv, float2(12.9898f, 78.233f))) * 43758.5453f);
  float postchainmerge_dither = (dither_noise - 0.5f) / 255.0f;
  output += postchainmerge_dither;
#endif

  output *= cbPostChainMerge.fFadeValue;

#if POSTCHAINMERGE_DEBUG_FILM_TONEMAPPED_OUTPUT
  output = renodx::color::srgb::EncodeSafe(tonemapped);
#endif

#if POSTCHAINMERGE_ENABLE_CBUFFER_DEBUG
  output = DrawPostChainMergeCBufferDebug(output, float2(SV_DispatchThreadID.xy));
#endif

  output = FinalizeOutput(output);

  uavOutput1[int2(SV_DispatchThreadID.xy)] = float4(output, POSTCHAINMERGE_OUTPUT_ALPHA);
}

#endif  // FIRSTLIGHT_TONEMAP_COMBINED_HLSLI
