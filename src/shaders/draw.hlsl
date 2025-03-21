#ifndef SRC_SHADERS_DRAW_HLSL_
#define SRC_SHADERS_DRAW_HLSL_

#include "./color.hlsl"
#include "./color_convert.hlsl"
#include "./colorcorrect.hlsl"
#include "./inverse_tonemap.hlsl"
#include "./math.hlsl"
#include "./tonemap.hlsl"

namespace renodx {
namespace draw {

struct Config {
  float peak_white_nits;                  // 1000
  float diffuse_white_nits;               // 203
  float graphics_white_nits;              // 203
  float color_grade_strength;             // 1.f
  float tone_map_type;                    // 3.f
  float tone_map_exposure;                // 1.f
  float tone_map_highlights;              // 1.f
  float tone_map_shadows;                 // 1.f
  float tone_map_contrast;                // 1.f
  float tone_map_saturation;              // 1.f
  float tone_map_highlight_saturation;    // 1.f
  float tone_map_blowout;                 // 0
  float tone_map_flare;                   // 0
  float tone_map_hue_correction;          // 1.f
  float tone_map_hue_shift;               // 0.f
  float tone_map_hue_shift_method;        // 0.f
  float tone_map_hue_shift_modifier;      // 0.5f
  float tone_map_working_color_space;     // 0.f
  float tone_map_clamp_color_space;       // -1 = none, bt709, bt2020, ap1
  float tone_map_clamp_peak;              // -1 = none, bt709, bt2020, ap1
  float tone_map_hue_processor;           // 0.f
  float tone_map_per_channel;             // 0.f
  float reno_drt_tone_map_method;         // 0.f
  float reno_drt_white_clip;              // 100.f
  float gamma_correction;                 // 0 = srgb/none, 1 = 2.2, 2 = 2.4
  float intermediate_scaling;             // generally game / ui nits
  float intermediate_encoding;            // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
  float intermediate_color_space;         // 0 = d65, 1 = bt2020, 2 = ap1
  float swap_chain_decoding;              // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
  float swap_chain_decoding_color_space;  // 0 = d65, 1 = bt2020, 2 = ap1
  float swap_chain_gamma_correction;      // 0 = srgb/none, 1 = 2.2, 2 = 2.4
  float swap_chain_custom_color_space;    // 0 = d65, 1 = d93, 2 = ntsc-u, 3 = ntsc-j
  float swap_chain_scaling_nits;          // generally ui nits
  float swap_chain_clamp_nits;            // generally peak nits
  float swap_chain_clamp_color_space;     // -1 = none, bt709, bt2020, ap1
  float swap_chain_encoding;              // 0 = none, 4 = hdr10, 5 = scrgb
  float swap_chain_encoding_color_space;  // 0 = none, 4 = hdr10, 5 = scrgb
};

static const float GAMMA_CORRECTION_NONE = 0;
static const float GAMMA_CORRECTION_SRGB = 0;
static const float GAMMA_CORRECTION_GAMMA_2_2 = 1.f;
static const float GAMMA_CORRECTION_GAMMA_2_4 = 2.f;

static const float ENCODING_NONE = 0;
static const float ENCODING_SRGB = 1.f;
static const float ENCODING_GAMMA_2_2 = 2.f;
static const float ENCODING_GAMMA_2_4 = 3.f;
static const float ENCODING_PQ = 4.f;
static const float ENCODING_SCRGB = 5.f;

static const float COLOR_SPACE_CUSTOM_BT709D65 = 0;
static const float COLOR_SPACE_CUSTOM_BT709D93 = 1.f;
static const float COLOR_SPACE_CUSTOM_NTSCU = 2.f;
static const float COLOR_SPACE_CUSTOM_NTSCJ = 3.f;

static const float HUE_PROCESSOR_NONE = -1.f;
static const float HUE_PROCESSOR_OKLAB = 0;
static const float HUE_PROCESSOR_ICTCP = 1.f;
static const float HUE_PROCESSOR_DTUCS = 2.f;

static const float HUE_SHIFT_METHOD_CLIP = 0.f;
static const float HUE_SHIFT_METHOD_SDR_MODIFIED = 1.f;
static const float HUE_SHIFT_METHOD_AP1_ROLL_OFF = 2.f;
static const float HUE_SHIFT_METHOD_ACES_FITTED_BT709 = 3.f;
static const float HUE_SHIFT_METHOD_ACES_FITTED_AP1 = 4.f;

static const float HUE_SHIFT_METHOD_MODIFIER = 0.f;

static const float TONE_MAP_TYPE_VANILLA = 0;
static const float TONE_MAP_TYPE_UNTONEMAPPED = 1.f;
static const float TONE_MAP_TYPE_ACES = 2.f;
static const float TONE_MAP_TYPE_RENO_DRT = 3.f;

Config BuildConfig() {
  Config config;

#if !defined(RENODX_PEAK_WHITE_NITS) && defined(RENODX_PEAK_NITS)
#define RENODX_PEAK_WHITE_NITS RENODX_PEAK_NITS
#elif !defined(RENODX_PEAK_WHITE_NITS)
#define RENODX_PEAK_WHITE_NITS 1000.f
#endif
  config.peak_white_nits = RENODX_PEAK_WHITE_NITS;

#if !defined(RENODX_DIFFUSE_WHITE_NITS) && defined(RENODX_GAME_NITS)
#define RENODX_DIFFUSE_WHITE_NITS RENODX_GAME_NITS
#elif !defined(RENODX_DIFFUSE_WHITE_NITS)
#define RENODX_DIFFUSE_WHITE_NITS renodx::color::bt2408::REFERENCE_WHITE
#endif
  config.diffuse_white_nits = RENODX_DIFFUSE_WHITE_NITS;

#if !defined(RENODX_GRAPHICS_WHITE_NITS) && defined(RENODX_UI_NITS)
#define RENODX_GRAPHICS_WHITE_NITS RENODX_UI_NITS
#elif !defined(RENODX_GRAPHICS_WHITE_NITS)
#define RENODX_GRAPHICS_WHITE_NITS renodx::color::bt2408::GRAPHICS_WHITE
#endif
  config.graphics_white_nits = RENODX_GRAPHICS_WHITE_NITS;

#if !defined(RENODX_COLOR_GRADE_STRENGTH)
#define RENODX_COLOR_GRADE_STRENGTH 1.f
#endif
  config.color_grade_strength = RENODX_COLOR_GRADE_STRENGTH;

#if !defined(RENODX_TONE_MAP_TYPE)
#define RENODX_TONE_MAP_TYPE renodx::draw::TONE_MAP_TYPE_RENO_DRT
#endif
  config.tone_map_type = RENODX_TONE_MAP_TYPE;

#if !defined(RENODX_TONE_MAP_EXPOSURE)
#define RENODX_TONE_MAP_EXPOSURE 1.f
#endif
  config.tone_map_exposure = RENODX_TONE_MAP_EXPOSURE;

#if !defined(RENODX_TONE_MAP_HIGHLIGHTS)
#define RENODX_TONE_MAP_HIGHLIGHTS 1.f
#endif
  config.tone_map_highlights = RENODX_TONE_MAP_HIGHLIGHTS;

#if !defined(RENODX_TONE_MAP_SHADOWS)
#define RENODX_TONE_MAP_SHADOWS 1.f
#endif
  config.tone_map_shadows = RENODX_TONE_MAP_SHADOWS;

#if !defined(RENODX_TONE_MAP_CONTRAST)
#define RENODX_TONE_MAP_CONTRAST 1.f
#endif
  config.tone_map_contrast = RENODX_TONE_MAP_CONTRAST;

#if !defined(RENODX_TONE_MAP_SATURATION)
#define RENODX_TONE_MAP_SATURATION 1.f
#endif
  config.tone_map_saturation = RENODX_TONE_MAP_SATURATION;

#if !defined(RENODX_TONE_MAP_HIGHLIGHT_SATURATION)
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
#endif
  config.tone_map_highlight_saturation = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;

#if !defined(RENODX_TONE_MAP_BLOWOUT)
#define RENODX_TONE_MAP_BLOWOUT 0
#endif
  config.tone_map_blowout = RENODX_TONE_MAP_BLOWOUT;

#if !defined(RENODX_TONE_MAP_FLARE)
#define RENODX_TONE_MAP_FLARE 0
#endif
  config.tone_map_flare = RENODX_TONE_MAP_FLARE;

#if !defined(RENODX_TONE_MAP_HUE_CORRECTION)
#define RENODX_TONE_MAP_HUE_CORRECTION 1.f
#endif
  config.tone_map_hue_correction = RENODX_TONE_MAP_HUE_CORRECTION;

#if !defined(RENODX_TONE_MAP_HUE_SHIFT)
#define RENODX_TONE_MAP_HUE_SHIFT 0
#endif
  config.tone_map_hue_shift = RENODX_TONE_MAP_HUE_SHIFT;

#if !defined(RENODX_TONE_MAP_HUE_SHIFT_METHOD)
#define RENODX_TONE_MAP_HUE_SHIFT_METHOD 0
#endif
  config.tone_map_hue_shift_method = RENODX_TONE_MAP_HUE_SHIFT_METHOD;

#if !defined(RENODX_TONE_MAP_HUE_SHIFT_MODIFIER)
#define RENODX_TONE_MAP_HUE_SHIFT_MODIFIER 1.0f
#endif
  config.tone_map_hue_shift_modifier = RENODX_TONE_MAP_HUE_SHIFT_MODIFIER;

#if !defined(RENODX_TONE_MAP_WORKING_COLOR_SPACE)
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#endif
  config.tone_map_working_color_space = RENODX_TONE_MAP_WORKING_COLOR_SPACE;

#if !defined(RENODX_TONE_MAP_CLAMP_COLOR_SPACE)
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE color::convert::COLOR_SPACE_NONE
#endif
  config.tone_map_clamp_color_space = RENODX_TONE_MAP_CLAMP_COLOR_SPACE;

#if !defined(RENODX_TONE_MAP_CLAMP_PEAK)
#define RENODX_TONE_MAP_CLAMP_PEAK color::convert::COLOR_SPACE_BT709
#endif
  config.tone_map_clamp_peak = RENODX_TONE_MAP_CLAMP_PEAK;

#if !defined(RENODX_TONE_MAP_HUE_PROCESSOR)
#define RENODX_TONE_MAP_HUE_PROCESSOR HUE_PROCESSOR_OKLAB
#endif
  config.tone_map_hue_processor = RENODX_TONE_MAP_HUE_PROCESSOR;

#if !defined(RENODX_TONE_MAP_PER_CHANNEL)
#define RENODX_TONE_MAP_PER_CHANNEL 0
#endif
  config.tone_map_per_channel = RENODX_TONE_MAP_PER_CHANNEL;

#if !defined(RENODX_RENO_DRT_TONE_MAP_METHOD)
#define RENODX_RENO_DRT_TONE_MAP_METHOD renodx::tonemap::renodrt::config::tone_map_method::DANIELE
#endif
  config.reno_drt_tone_map_method = RENODX_RENO_DRT_TONE_MAP_METHOD;

#if !defined(RENODX_RENO_DRT_WHITE_CLIP)
#define RENODX_RENO_DRT_WHITE_CLIP 100.f
#endif
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;

#if !defined(RENODX_GAMMA_CORRECTION)
#define RENODX_GAMMA_CORRECTION renodx::draw::GAMMA_CORRECTION_GAMMA_2_2
#endif
  config.gamma_correction = RENODX_GAMMA_CORRECTION;

#if !defined(RENODX_INTERMEDIATE_SCALING)
#define RENODX_INTERMEDIATE_SCALING (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS)
#endif
  config.intermediate_scaling = RENODX_INTERMEDIATE_SCALING;

#if !defined(RENODX_INTERMEDIATE_ENCODING)
#define RENODX_INTERMEDIATE_ENCODING (RENODX_GAMMA_CORRECTION + 1.f)
#endif
  config.intermediate_encoding = RENODX_INTERMEDIATE_ENCODING;

#if !defined(RENODX_INTERMEDIATE_COLOR_SPACE)
#define RENODX_INTERMEDIATE_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#endif
  config.intermediate_color_space = RENODX_INTERMEDIATE_COLOR_SPACE;

#if !defined(RENODX_SWAP_CHAIN_DECODING)
#define RENODX_SWAP_CHAIN_DECODING RENODX_INTERMEDIATE_ENCODING
#endif
  config.swap_chain_decoding = RENODX_SWAP_CHAIN_DECODING;

#if !defined(RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE)
#define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE RENODX_INTERMEDIATE_COLOR_SPACE
#endif
  config.swap_chain_decoding_color_space = RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE;

#if !defined(RENODX_SWAP_CHAIN_GAMMA_CORRECTION)
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION GAMMA_CORRECTION_NONE
#endif
  config.swap_chain_gamma_correction = RENODX_SWAP_CHAIN_GAMMA_CORRECTION;

#if !defined(RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE)
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE COLOR_SPACE_CUSTOM_BT709D65
#endif
  config.swap_chain_custom_color_space = RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE;

#if !defined(RENODX_SWAP_CHAIN_SCALING_NITS)
#define RENODX_SWAP_CHAIN_SCALING_NITS RENODX_GRAPHICS_WHITE_NITS
#endif
  config.swap_chain_scaling_nits = RENODX_SWAP_CHAIN_SCALING_NITS;

#if !defined(RENODX_SWAP_CHAIN_CLAMP_NITS)
#define RENODX_SWAP_CHAIN_CLAMP_NITS RENODX_PEAK_WHITE_NITS
#endif
  config.swap_chain_clamp_nits = RENODX_SWAP_CHAIN_CLAMP_NITS;

#if !defined(RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE)
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE color::convert::COLOR_SPACE_UNKNOWN
#endif
  config.swap_chain_clamp_color_space = RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE;

#if !defined(RENODX_SWAP_CHAIN_ENCODING)
#define RENODX_SWAP_CHAIN_ENCODING ENCODING_SCRGB
#endif
  config.swap_chain_encoding = RENODX_SWAP_CHAIN_ENCODING;

#if !defined(RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE)
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#endif
  config.swap_chain_encoding_color_space = RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE;

  return config;
};

float3 DecodeColor(float3 color, float encoding) {
  [branch]
  if (encoding == ENCODING_SRGB) {
    color = renodx::color::srgb::DecodeSafe(color);
  } else if (encoding == ENCODING_GAMMA_2_2) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else if (encoding == ENCODING_GAMMA_2_4) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (encoding == ENCODING_PQ) {
    color = renodx::color::pq::DecodeSafe(color, 1.f);
  } else if (encoding == ENCODING_SCRGB) {
    color = color * 80.f;
  } else {
    color = color;
  }
  return color;
}

float3 EncodeColor(float3 color, float encoding) {
  [branch]
  if (encoding == ENCODING_SRGB) {
    color = renodx::color::srgb::EncodeSafe(color);
  } else if (encoding == ENCODING_GAMMA_2_2) {
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (encoding == ENCODING_GAMMA_2_4) {
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (encoding == ENCODING_PQ) {
    color = renodx::color::pq::EncodeSafe(color, 1.f);
  } else if (encoding == ENCODING_SCRGB) {
    color = color / 80.f;
  } else {
    color = color;
  }
  return color;
}

float UpgradeToneMapRatio(float color_hdr, float color_sdr, float post_process_color) {
  if (color_hdr < color_sdr) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return color_hdr / color_sdr;
  } else {
    float delta = color_hdr - color_sdr;
    delta = max(0, delta);  // Cleans up NaN
    const float new_value = post_process_color + delta;

    const bool valid = (post_process_color > 0);  // Cleans up NaN and ignore black
    return valid ? (new_value / post_process_color) : 0;
  }
}

float3 UpgradeToneMapByLuminance(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  // float ratio = 1.f;

  float3 bt2020_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
  float3 bt2020_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
  float3 bt2020_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));

  float ratio = UpgradeToneMapRatio(
      renodx::color::y::from::BT2020(bt2020_hdr),
      renodx::color::y::from::BT2020(bt2020_sdr),
      renodx::color::y::from::BT2020(bt2020_post_process));

  float3 color_scaled = max(0, bt2020_post_process * ratio);
  color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 RenderIntermediatePass(float3 color, Config config) {
  [branch]
  if (config.gamma_correction == GAMMA_CORRECTION_GAMMA_2_2) {
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
  } else if (config.gamma_correction == GAMMA_CORRECTION_GAMMA_2_4) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  }

  color *= config.intermediate_scaling;

  color = renodx::color::convert::ColorSpaces(
      color,
      renodx::color::convert::COLOR_SPACE_BT709,
      config.intermediate_color_space);

  color = EncodeColor(color, config.intermediate_encoding);

  return color;
}

float3 InvertIntermediatePass(float3 color, Config config) {
  color = DecodeColor(color, config.intermediate_encoding);

  color = renodx::color::convert::ColorSpaces(
      color,
      config.intermediate_color_space,
      renodx::color::convert::COLOR_SPACE_BT709);

  color /= config.intermediate_scaling;

  [branch]
  if (config.gamma_correction == GAMMA_CORRECTION_GAMMA_2_2) {
    color = renodx::color::correct::GammaSafe(color, true, 2.2f);
  } else if (config.gamma_correction == GAMMA_CORRECTION_GAMMA_2_4) {
    color = renodx::color::correct::GammaSafe(color, true, 2.4f);
  }

  return color;
}

float3 SwapChainPass(float3 color, Config config) {
  color = DecodeColor(color, config.swap_chain_decoding);

  if (config.swap_chain_gamma_correction == GAMMA_CORRECTION_GAMMA_2_2) {
    color = color::convert::ColorSpaces(color, config.swap_chain_decoding_color_space, color::convert::COLOR_SPACE_BT709);
    config.swap_chain_decoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
  } else if (config.swap_chain_gamma_correction == GAMMA_CORRECTION_GAMMA_2_4) {
    color = color::convert::ColorSpaces(color, config.swap_chain_decoding_color_space, color::convert::COLOR_SPACE_BT709);
    config.swap_chain_decoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  }

  [branch]
  if (config.swap_chain_custom_color_space == COLOR_SPACE_CUSTOM_BT709D93) {
    color = color::convert::ColorSpaces(color, config.swap_chain_decoding_color_space, color::convert::COLOR_SPACE_BT709);
    color = renodx::color::bt709::from::BT709D93(color);
    config.swap_chain_decoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
  } else if (config.swap_chain_custom_color_space == COLOR_SPACE_CUSTOM_NTSCU) {
    color = color::convert::ColorSpaces(color, config.swap_chain_decoding_color_space, color::convert::COLOR_SPACE_BT709);
    color = renodx::color::bt709::from::BT601NTSCU(color);
    config.swap_chain_decoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
  } else if (config.swap_chain_custom_color_space == COLOR_SPACE_CUSTOM_NTSCJ) {
    color = color::convert::ColorSpaces(color, config.swap_chain_decoding_color_space, color::convert::COLOR_SPACE_BT709);
    color = renodx::color::bt709::from::ARIBTRB9(color);
    config.swap_chain_decoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
  }

  color *= config.swap_chain_scaling_nits;

  color = min(color, config.swap_chain_clamp_nits);  // Clamp UI or Videos

  [branch]
  if (config.swap_chain_clamp_color_space != renodx::color::convert::COLOR_SPACE_UNKNOWN) {
    [branch]
    if (config.swap_chain_clamp_color_space == config.swap_chain_encoding_color_space) {
      color = renodx::color::convert::ColorSpaces(color, config.swap_chain_decoding_color_space, config.swap_chain_encoding_color_space);
      color = max(0, color);
    } else {
      if (config.swap_chain_clamp_color_space == config.swap_chain_decoding_color_space) {
        color = max(0, color);
      }
      color = renodx::color::convert::ColorSpaces(color, config.swap_chain_decoding_color_space, config.swap_chain_encoding_color_space);
    }
  } else {
    color = renodx::color::convert::ColorSpaces(color, config.swap_chain_decoding_color_space, config.swap_chain_encoding_color_space);
  }

  color = EncodeColor(color, config.swap_chain_encoding);

  return color;
}

/* Input should be in Gamma */
float3 UpscaleVideoPass(float3 color, Config config) {
  color = renodx::color::gamma::Decode(color, 2.4f);  // 2.4 for BT2446a

  float scaling = config.peak_white_nits / config.diffuse_white_nits;
  float videoPeak = config.peak_white_nits / (config.diffuse_white_nits / renodx::color::bt2408::REFERENCE_WHITE);
  videoPeak = renodx::color::correct::Gamma(videoPeak, false, 2.4f);
  scaling = renodx::color::correct::Gamma(scaling, false, 2.4f);

  [branch]
  if (config.gamma_correction == ENCODING_GAMMA_2_2) {
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.2f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.2f);
  } else if (config.gamma_correction == ENCODING_GAMMA_2_4) {
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.4f);
  }

  color = renodx::tonemap::inverse::bt2446a::BT709(
      color,
      renodx::color::bt709::REFERENCE_WHITE,
      videoPeak);
  color /= videoPeak;  // Normalize to 1.0f = peak;
  color *= scaling;

  color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  return color;
}

float3 ToneMapPass(float3 color, Config draw_config) {
  renodx::tonemap::Config tone_map_config = renodx::tonemap::config::Create();
  tone_map_config.peak_nits = draw_config.peak_white_nits;
  tone_map_config.game_nits = draw_config.diffuse_white_nits;
  tone_map_config.type = draw_config.tone_map_type;
  tone_map_config.gamma_correction = draw_config.gamma_correction;
  tone_map_config.exposure = draw_config.tone_map_exposure;
  tone_map_config.highlights = draw_config.tone_map_highlights;
  tone_map_config.shadows = draw_config.tone_map_shadows;
  tone_map_config.contrast = draw_config.tone_map_contrast;
  tone_map_config.saturation = draw_config.tone_map_saturation;

  tone_map_config.reno_drt_highlights = 1.0f;
  tone_map_config.reno_drt_shadows = 1.0f;
  tone_map_config.reno_drt_contrast = 1.0f;
  tone_map_config.reno_drt_saturation = 1.0f;
  tone_map_config.reno_drt_blowout = -1.f * (draw_config.tone_map_highlight_saturation - 1.f);
  tone_map_config.reno_drt_dechroma = draw_config.tone_map_blowout;
  tone_map_config.reno_drt_flare = 0.10f * pow(draw_config.tone_map_flare, 10.f);
  tone_map_config.reno_drt_working_color_space = (uint)draw_config.tone_map_working_color_space;
  tone_map_config.reno_drt_per_channel = draw_config.tone_map_per_channel == 1.f;
  tone_map_config.reno_drt_hue_correction_method = (uint)draw_config.tone_map_hue_processor;
  tone_map_config.reno_drt_clamp_color_space = draw_config.tone_map_clamp_color_space;
  tone_map_config.reno_drt_clamp_peak = draw_config.tone_map_clamp_peak;
  tone_map_config.reno_drt_tone_map_method = (uint)draw_config.reno_drt_tone_map_method;
  tone_map_config.reno_drt_white_clip = draw_config.reno_drt_white_clip;

  tone_map_config.hue_correction_strength = draw_config.tone_map_hue_correction;

  if (draw_config.tone_map_hue_shift != 0) {
    tone_map_config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;

    float3 hue_shifted_color;
    if (draw_config.tone_map_hue_shift_method == HUE_SHIFT_METHOD_CLIP) {
      hue_shifted_color = saturate(color);
    } else if (draw_config.tone_map_hue_shift_method == HUE_SHIFT_METHOD_SDR_MODIFIED) {
      renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();
      renodrt_config.nits_peak = 100.f;
      renodrt_config.mid_gray_value = 0.18f;
      renodrt_config.mid_gray_nits = 18.f;
      renodrt_config.exposure = 1.f;
      renodrt_config.highlights = 1.f;
      renodrt_config.shadows = 1.f;
      renodrt_config.contrast = 1.0f;
      renodrt_config.saturation = draw_config.tone_map_hue_shift_modifier;
      renodrt_config.dechroma = 0.f;
      renodrt_config.flare = 0.f;
      renodrt_config.per_channel = false;
      renodrt_config.tone_map_method = 1u;
      renodrt_config.white_clip = 1.f;
      renodrt_config.hue_correction_strength = 0.f;
      renodrt_config.working_color_space = 0u;
      renodrt_config.clamp_color_space = 0u;
      hue_shifted_color = renodx::tonemap::renodrt::BT709(color, renodrt_config);
    } else if (draw_config.tone_map_hue_shift_method == HUE_SHIFT_METHOD_AP1_ROLL_OFF) {
      float3 incorrect_hue_ap1 = renodx::color::ap1::from::BT709(color * tone_map_config.mid_gray_value / 0.18f);
      hue_shifted_color = renodx::color::bt709::from::AP1(renodx::tonemap::ExponentialRollOff(incorrect_hue_ap1, tone_map_config.mid_gray_value, 2.f));
    } else if (draw_config.tone_map_hue_shift_method == HUE_SHIFT_METHOD_ACES_FITTED_BT709) {
      hue_shifted_color = renodx::tonemap::ACESFittedBT709(color);
    } else if (draw_config.tone_map_hue_shift_method == HUE_SHIFT_METHOD_ACES_FITTED_AP1) {
      hue_shifted_color = renodx::tonemap::ACESFittedAP1(color);
    }
    tone_map_config.hue_correction_color = lerp(
        color,
        hue_shifted_color,
        draw_config.tone_map_hue_shift);
  }

  float3 output_color = renodx::tonemap::config::Apply(color, tone_map_config);

  return output_color;
}

float3 ToneMapPass(float3 untonemapped, float3 graded_sdr_color, float3 neutral_sdr_color, Config config) {
  float3 untonemapped_graded;
  [branch]
  if (config.color_grade_strength != 0) {
    untonemapped_graded = renodx::tonemap::UpgradeToneMap(
        untonemapped,
        neutral_sdr_color,
        graded_sdr_color,
        config.color_grade_strength);
  } else {
    untonemapped_graded = untonemapped;
  }
  return ToneMapPass(untonemapped_graded, config);
}

float3 ToneMapPass(float3 untonemapped, float3 graded_sdr_color, Config config) {
  [branch]
  if (config.color_grade_strength == 0) {
    return ToneMapPass(untonemapped, config);
  } else {
    return ToneMapPass(
        untonemapped,
        renodx::tonemap::renodrt::NeutralSDR(untonemapped),
        graded_sdr_color,
        config);
  }
}

float3 ToneMapPass(float3 untonemapped, float3 graded_sdr_color, float3 neutral_sdr_color) {
  return ToneMapPass(untonemapped, graded_sdr_color, neutral_sdr_color, BuildConfig());
}

float3 RenderIntermediatePass(float3 color) {
  return RenderIntermediatePass(color, BuildConfig());
}

float4 RenderIntermediatePass(float4 color) {
  return float4(RenderIntermediatePass(color.rgb, BuildConfig()).rgb, 1.f);
}

float3 InvertIntermediatePass(float3 color) {
  return InvertIntermediatePass(color, BuildConfig());
}

float4 InvertIntermediatePass(float4 color) {
  return float4(InvertIntermediatePass(color.rgb, BuildConfig()).rgb, 1.f);
}

float3 SwapChainPass(float3 color) {
  return SwapChainPass(color, BuildConfig());
}

float4 SwapChainPass(float4 color) {
  return float4(SwapChainPass(color.rgb, BuildConfig()).rgb, 1.f);
}

float3 ToneMapPass(float3 untonemapped, float3 graded_sdr_color) {
  return ToneMapPass(untonemapped, graded_sdr_color, BuildConfig());
}

float3 ToneMapPass(float3 untonemapped) {
  return ToneMapPass(untonemapped, BuildConfig());
}

float4 ToneMapPass(float4 untonemapped, float4 graded_sdr_color, Config config) {
  return float4(ToneMapPass(untonemapped.rgb, graded_sdr_color.rgb, config).rgb, 1.f);
}

float4 ToneMapPass(float4 untonemapped, Config config) {
  return float4(ToneMapPass(untonemapped.rgb, config).rgb, 1.f);
}

float4 ToneMapPass(float4 untonemapped, float4 graded_sdr_color) {
  return float4(ToneMapPass(untonemapped.rgb, graded_sdr_color.rgb, BuildConfig()).rgb, 1.f);
}

float4 ToneMapPass(float4 untonemapped) {
  return ToneMapPass(untonemapped, BuildConfig());
}

float3 UpscaleVideoPass(float3 untonemapped) {
  return UpscaleVideoPass(untonemapped, BuildConfig());
}

}  // draw
}  // renodx

#endif  // SRC_SHADERS_DRAW_HLSL_
