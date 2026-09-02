// RenoDX SDR LUT bridge starting shapes.
// Use only after draw/resource analysis proves the LUT input/output domains.
// This is a snippet asset, not a standalone shader. Rename Game* symbols for
// the target addon and adapt the source gamut/transfer before use.
// Keep one-off shader edits inline. Only move this into a game-local helper if
// multiple shaders share the same proven bridge.

#if 0

// Around a vanilla sRGB LUT sample. Adapt texture/sampler/uv names.
// Preferred shape for pushing HDR BT.709 through an SDR LUT:
// compress saturated HDR into the SDR gamut if needed, max-channel scale into
// LUT-safe range, sample the LUT, then undo the scale/compression.
float3 original_lut_input_srgb = lut_input.rgb;
float3 lut_source_bt709 = renodx::color::srgb::DecodeSafe(original_lut_input_srgb);

// AdaptiveD65 uses the D65 white direction. A uniform gray magnitude such as
// 0.18 or 1.0 cancels out in the relative LMS compression/decompression math.
float3 adaptive_state_lms = renodx::color::lms::from::BT709(float3(1.f, 1.f, 1.f));
float gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(
    lut_source_bt709,
    adaptive_state_lms,
    1.f);
float3 compressed_bt709 = renodx::color::gamut::GamutCompressBT709AdaptiveD65(
    lut_source_bt709,
    adaptive_state_lms,
    gamut_compression_scale);
float max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(compressed_bt709);
lut_input.rgb = renodx::color::srgb::EncodeSafe(max(0.f, compressed_bt709 * max_channel_scale));

float4 lut_sample = ColorGradingLUT.Sample(Sampler, lut_uv);
float3 lut_sample_bt709 = renodx::color::srgb::DecodeSafe(lut_sample.rgb);
lut_sample.rgb = renodx::color::srgb::EncodeSafe(renodx::color::gamut::GamutDecompressBT709AdaptiveD65(
    renodx::math::DivideSafe(lut_sample_bt709, float3(max_channel_scale, max_channel_scale, max_channel_scale), lut_sample_bt709),
    adaptive_state_lms,
    gamut_compression_scale));
lut_input.rgb = original_lut_input_srgb;

// Known-domain LUT config pattern. Use this when the game LUT is not an SDR
// sRGB LUT, e.g. PQ/HDR or ARRI/log. Fill in the actual proven domain; do not
// force these LUTs through the SDR bridge above.
renodx::lut::Config lut_config = renodx::lut::config::Create(
    LUTSampler,
    CUSTOM_LUT_STRENGTH,
    CUSTOM_LUT_SCALING,
    renodx::lut::config::type::SRGB,   // Or PQ / ARRI_C1000_NO_CUT / game-proven domain.
    renodx::lut::config::type::SRGB,   // Or LINEAR / PQ / game-proven domain.
    16u);
lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;
float3 known_domain_lut_output = renodx::lut::Sample(LUTTexture, lut_config, known_domain_lut_input);

#endif