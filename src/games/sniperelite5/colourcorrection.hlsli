#ifndef SRC_GAMES_SNIPERELITE5_COLOURCORRECTION_HLSLI_
#define SRC_GAMES_SNIPERELITE5_COLOURCORRECTION_HLSLI_

// RenoDX: gamut-compress + max-channel bridge into the LUT, then undo both.
float3 ApplyColourCorrectionLut(float3 hdr, Texture3D<float4> lut, SamplerState lut_sampler, float lut_strength) {
  float3 adaptive_state_lms = renodx::color::lms::from::BT709(float3(1.f, 1.f, 1.f));
  float gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(hdr, adaptive_state_lms, 1.f);
  float3 compressed = renodx::color::gamut::GamutCompressBT709AdaptiveD65(hdr, adaptive_state_lms, gamut_compression_scale);
  float max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(compressed);
  float3 lut_input = max(0.f, compressed * max_channel_scale);
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      lut_sampler,
      lut_strength,
      0.f,
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::LINEAR,
      16u);
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;
  float3 graded = renodx::lut::Sample(lut, lut_config, lut_input);
  return renodx::color::gamut::GamutDecompressBT709AdaptiveD65(
      renodx::math::DivideSafe(graded, float3(max_channel_scale, max_channel_scale, max_channel_scale), graded),
      adaptive_state_lms,
      gamut_compression_scale);
}

#endif  // SRC_GAMES_SNIPERELITE5_COLOURCORRECTION_HLSLI_
