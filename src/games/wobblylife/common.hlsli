#ifndef SRC_GAMES_WOBBLYLIFE_COMMON_HLSLI_
#define SRC_GAMES_WOBBLYLIFE_COMMON_HLSLI_

#include "./shared.h"

static const float WOBBLY_LUT_MID_GRAY_LINEAR = 0.177827941f;
static const float WOBBLY_LUT_MID_GRAY_PERCENT = 0.5f;
static const float WOBBLY_SDR_GAMUT_COMPRESSION_STRENGTH = 1.f;
static const float WOBBLY_SDR_GAMUT_COMPRESSION_NONE = 0.f;
static const float WOBBLY_SDR_GAMUT_COMPRESSION_ADAPTIVE_D65 = 1.f;

struct WobblyGammaGamutCompressionState {
  float encode_gamma;
  float linear_grayscale;
  float compression_scale;
};

struct WobblyMaxChannelSdrState {
  float3 source_bt709;
  float3 compressed_bt709;
  float3 neutral_sdr_bt709;
  float3 adaptive_state_lms;
  float max_channel_scale;
  float gamut_compression_scale;
  float gamut_compression_mode;
};

float WobblyResolveGammaGamutEncode() {
  return log(WOBBLY_LUT_MID_GRAY_LINEAR) / log(WOBBLY_LUT_MID_GRAY_PERCENT);
}

float3 WobblyCompressGammaGamutForLut(float3 linear_color, out WobblyGammaGamutCompressionState state) {
  state.encode_gamma = WobblyResolveGammaGamutEncode();
  float input_linear_grayscale = renodx::color::convert::Luminance(linear_color, 0);

  float3 encoded = renodx::color::gamma::EncodeSafe(linear_color, state.encode_gamma);
  float encoded_grayscale = renodx::color::gamma::Encode(input_linear_grayscale, state.encode_gamma);
  state.compression_scale = renodx::color::correct::ComputeGamutCompressionScale(encoded, encoded_grayscale);

  float3 compressed = renodx::color::correct::GamutCompress(
      encoded,
      encoded_grayscale,
      state.compression_scale);
  float3 compressed_linear = renodx::color::gamma::DecodeSafe(compressed, state.encode_gamma);
  state.linear_grayscale = renodx::color::convert::Luminance(compressed_linear, 0);
  return compressed_linear;
}

float3 WobblyDecompressGammaGamutFromLut(float3 linear_color, WobblyGammaGamutCompressionState state) {
  float3 encoded = renodx::color::gamma::EncodeSafe(linear_color, state.encode_gamma);
  float encoded_grayscale = renodx::color::gamma::Encode(state.linear_grayscale, state.encode_gamma);
  float3 decompressed = renodx::color::correct::GamutDecompress(
      encoded,
      encoded_grayscale,
      state.compression_scale);
  return renodx::color::gamma::DecodeSafe(decompressed, state.encode_gamma);
}

float WobblyComputeMaxChannelSdrScale(float3 color_bt709) {
  return renodx::tonemap::neutwo::ComputeMaxChannelScale(color_bt709);
}

float3 WobblyComputeSdrGamutAdaptiveState() {
  return renodx::color::lms::from::BT709(max(float3(
      WOBBLY_LUT_MID_GRAY_LINEAR,
      WOBBLY_LUT_MID_GRAY_LINEAR,
      WOBBLY_LUT_MID_GRAY_LINEAR),
      1e-6f.xxx));
}

WobblyMaxChannelSdrState WobblyCompressToSdrMaxChannel(float3 untonemapped_bt709) {
  WobblyMaxChannelSdrState state;
  state.source_bt709 = untonemapped_bt709;
  state.adaptive_state_lms = WobblyComputeSdrGamutAdaptiveState();
  state.gamut_compression_scale = 1.f;
  state.gamut_compression_mode = CUSTOM_SDR_GAMUT_COMPRESSION;
  state.compressed_bt709 = untonemapped_bt709;

  if (state.gamut_compression_mode == WOBBLY_SDR_GAMUT_COMPRESSION_ADAPTIVE_D65) {
    // Adaptive D65 SDR bridge: compress BT.709 against an LMS adaptation state,
    // then let N2 max-channel scaling move the compressed HDR value into SDR LUT space.
    state.gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(
        untonemapped_bt709,
        state.adaptive_state_lms,
        WOBBLY_SDR_GAMUT_COMPRESSION_STRENGTH);
    state.compressed_bt709 = renodx::color::gamut::GamutCompressBT709AdaptiveD65(
        untonemapped_bt709,
        state.adaptive_state_lms,
        state.gamut_compression_scale);
  }

  state.max_channel_scale = WobblyComputeMaxChannelSdrScale(state.compressed_bt709);
  state.neutral_sdr_bt709 = state.compressed_bt709 * state.max_channel_scale;
  return state;
}

float3 WobblyReconstructFromSdrMaxChannel(float3 graded_sdr_bt709, WobblyMaxChannelSdrState state) {
  float3 graded_compressed_bt709 = renodx::math::DivideSafe(
      graded_sdr_bt709,
      float3(state.max_channel_scale, state.max_channel_scale, state.max_channel_scale),
      graded_sdr_bt709);
  if (state.gamut_compression_mode != WOBBLY_SDR_GAMUT_COMPRESSION_ADAPTIVE_D65) {
    return graded_compressed_bt709;
  }
  return renodx::color::gamut::GamutDecompressBT709AdaptiveD65(
      graded_compressed_bt709,
      state.adaptive_state_lms,
      state.gamut_compression_scale);
}

float WobblyComputePsychoV17PeakNits(bool is_sdr) {
  return is_sdr ? 1.f : (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
}

float3 WobblyApplyPsychoV17(float3 untonemapped_bt709, bool is_sdr = false) {
  float3 bt709_scene = untonemapped_bt709 * RENODX_TONE_MAP_EXPOSURE;

  float3 lms_in = renodx::color::lms::from::BT709(bt709_scene);
  float yf_input = renodx::color::yf::from::LMS(lms_in);
  float yf_midgray = renodx::color::yf::from::BT709(0.18f);
  float yf_target = yf_input;

  if (RENODX_TONE_MAP_HIGHLIGHTS != 1.f) {
    yf_target = renodx::color::grade::Highlights(yf_target, RENODX_TONE_MAP_HIGHLIGHTS, yf_midgray);
  }
  if (RENODX_TONE_MAP_SHADOWS != 1.f) {
    yf_target = renodx::color::grade::Shadows(yf_target, RENODX_TONE_MAP_SHADOWS, yf_midgray);
  }
  if (RENODX_TONE_MAP_CONTRAST != 1.f) {
    yf_target = renodx::color::grade::ContrastSafe(yf_target, RENODX_TONE_MAP_CONTRAST, yf_midgray);
  }

  float yf_scale = renodx::math::DivideSafe(yf_target, yf_input, 1.f);
  bt709_scene *= yf_scale;

  return renodx::tonemap::psychov::psychotm_test17(
      bt709_scene,
      WobblyComputePsychoV17PeakNits(is_sdr),
      1.f,
      1.f,
      1.f,
      1.f,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      100.f,
      1.f,
      1.f,
      1,
      max(0.f, CUSTOM_CONE_RESPONSE),
      0.18f.xxx,
      0.18f.xxx,
      1.f,
      (int)(!is_sdr));
}

float3 WobblyApplyOutputToneMap(float3 untonemapped_bt709) {
  float3 output_color = renodx::draw::ToneMapPass(untonemapped_bt709);
  if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV17) {
    bool is_sdr = RENODX_SWAP_CHAIN_OUTPUT_PRESET == renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_SDR;
    output_color = WobblyApplyPsychoV17(untonemapped_bt709, is_sdr);
  }
  return output_color;
}

#endif  // SRC_GAMES_WOBBLYLIFE_COMMON_HLSLI_