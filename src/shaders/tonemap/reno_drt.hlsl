#ifndef SRC_SHADERS_RENO_DRT_HLSL_
#define SRC_SHADERS_RENO_DRT_HLSL_

#include "../color.hlsl"
#include "../color_convert.hlsl"
#include "../colorgrade.hlsl"
#include "../math.hlsl"
#include "./daniele.hlsl"
#include "./hermite_spline.hlsl"
#include "./reinhard.hlsl"

#ifndef RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK 0.f
#endif

#ifndef RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE 0.f
#endif

#ifndef RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD 0.f
#endif

#ifndef RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP
#define RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP 100.f
#endif

#ifndef RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK 0.f
#endif

#ifndef RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE 0.f
#endif

#ifndef RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD 0.f
#endif

#ifndef RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP
#define RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP 100.f
#endif

namespace renodx {
namespace tonemap {
namespace renodrt {

struct Config {
  float nits_peak;
  float mid_gray_value;
  float mid_gray_nits;
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float saturation;
  float dechroma;
  float flare;
  float hue_correction_strength;
  float3 hue_correction_source;
  float hue_correction_method;
  float tone_map_method;
  float hue_correction_type;
  float working_color_space;
  bool per_channel;
  float blowout;
  float clamp_color_space;
  float clamp_peak;
  float white_clip;
};

namespace config {

namespace hue_correction_type {
static const float INPUT = 0.f;
static const float CUSTOM = 1.f;
}

namespace hue_correction_method {
static const float OKLAB = 0.f;
static const float ICTCP = 1.f;
static const float DARKTABLE_UCS = 2.f;
}

namespace tone_map_method {
static const float NONE = -1.f;
static const float DANIELE = 0.f;
static const float REINHARD = 1.f;
static const float HERMITE_SPLINE = 2.f;
}

Config Create(
    float nits_peak = 1000.f / 203.f * 100.f,
    float mid_gray_value = 0.18f,
    float mid_gray_nits = 10.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.1f,
    float saturation = 1.f,
    float dechroma = 0.5f,
    float flare = 0.f,
    float hue_correction_strength = 1.f,
    float3 hue_correction_source = 0.f,
    float hue_correction_method = config::hue_correction_method::OKLAB,
    float tone_map_method = config::tone_map_method::DANIELE,
    float hue_correction_type = config::hue_correction_type::INPUT,
    float working_color_space = 0.f,
    bool per_channel = false,
    float blowout = 0.f,
    float clamp_color_space = 2.f,
    float clamp_peak = 0.f,
    float white_clip = 100.f) {
  const Config renodrt_config = {
    nits_peak,
    mid_gray_value,
    mid_gray_nits,
    exposure,
    highlights,
    shadows,
    contrast,
    saturation,
    dechroma,
    flare,
    hue_correction_strength,
    hue_correction_source,
    hue_correction_method,
    tone_map_method,
    hue_correction_type,
    working_color_space,
    per_channel,
    blowout,
    clamp_color_space,
    clamp_peak,
    white_clip
  };
  return renodrt_config;
}
}

float3 BT709(float3 bt709, Config current_config) {
  const float reference_white = 100.f;

  float peak = (current_config.nits_peak / reference_white);

  float3 input_color;
  float y_original;

  float current_color_space = current_config.working_color_space;

  if (current_color_space == 2.f) {
    input_color = max(0, renodx::color::ap1::from::BT709(bt709));
    y_original = renodx::color::y::from::AP1(input_color);
  } else if (current_color_space == 1.f) {
    input_color = renodx::color::bt2020::from::BT709(bt709);
    y_original = renodx::color::y::from::BT2020(input_color);
  } else {
    input_color = bt709;
    y_original = renodx::color::y::from::BT709(bt709);
  }

  float y = y_original;

  y *= current_config.exposure;
  [branch]
  if (current_config.highlights != 1.f) {
    y = renodx::color::grade::Highlights(y, current_config.highlights, current_config.mid_gray_value);
  }

  [branch]
  if (current_config.shadows != 1.f) {
    y = renodx::color::grade::Shadows(y, current_config.shadows, current_config.mid_gray_value);
  }

  float3 per_channel_color;
  [branch]
  if (current_config.per_channel) {
    per_channel_color = input_color * (y_original > 0 ? (y / y_original) : 0);
  } else {
    per_channel_color = input_color;
  }

  float3 color_output;

  [branch]
  if (current_config.tone_map_method == config::tone_map_method::DANIELE) {
    renodx::tonemap::daniele::Config daniele_config = renodx::tonemap::daniele::config::Create();

    daniele_config.n_r = reference_white;               // reference nits
    daniele_config.n = current_config.nits_peak;        // peak nits
    daniele_config.g = current_config.contrast;         // surround/contrast
    daniele_config.c = current_config.mid_gray_value;   // scene-referred gray
    daniele_config.c_d = current_config.mid_gray_nits;  // output gray in nits
    daniele_config.w_g = 0;                             // gray change
    daniele_config.t_1 = current_config.flare;          // shadow toe

    [branch]
    if (current_config.per_channel) {
      float3 ts3 = float3(
          renodx::tonemap::daniele::ToneMap(per_channel_color.r, daniele_config),
          renodx::tonemap::daniele::ToneMap(per_channel_color.g, daniele_config),
          renodx::tonemap::daniele::ToneMap(per_channel_color.b, daniele_config));

      color_output = clamp(ts3, 0, peak);
    } else {
      float ts = renodx::tonemap::daniele::ToneMap(y, daniele_config);

      float y_new = clamp(ts, 0, peak);

      color_output = input_color * (y_original > 0 ? (y_new / y_original) : 0);
    }
  } else {
    float white_clip = current_config.white_clip;
    [branch]
    if (current_config.highlights != 1.f) {
      white_clip = renodx::color::grade::Highlights(white_clip, current_config.highlights, current_config.mid_gray_value);
    }

    [branch]
    if (current_config.shadows != 1.f) {
      white_clip = renodx::color::grade::Shadows(white_clip, current_config.shadows, current_config.mid_gray_value);
    }

    float computed_contrast = 1.f;
    [branch]
    if (current_config.contrast != 1.f || current_config.flare != 0.f) {
      y /= current_config.mid_gray_value;
      float computed_flare = renodx::math::DivideSafe(y + current_config.flare, y, 1.f);
      computed_flare = lerp(computed_flare, 1.f, saturate(y));
      y *= current_config.mid_gray_value;
      computed_contrast = current_config.contrast * computed_flare;

      white_clip = renodx::color::grade::Contrast(white_clip, current_config.contrast, current_config.mid_gray_value);
    }

    [branch]
    if (current_config.per_channel) {
      color_output = per_channel_color;
      float3 signs = sign(color_output);
      color_output = abs(color_output);
      [branch]
      if (current_config.contrast != 1.f || current_config.flare != 0.f) {
        color_output /= current_config.mid_gray_value;
        color_output = pow(color_output, computed_contrast);
        color_output *= current_config.mid_gray_value;
      }
      [branch]
      if (current_config.tone_map_method == config::tone_map_method::NONE) {
        // noop
      } else if (current_config.tone_map_method == config::tone_map_method::REINHARD) {
        color_output = ReinhardScalableExtended(
            color_output,
            max(white_clip, peak),
            peak,
            0,
            current_config.mid_gray_value,
            current_config.mid_gray_nits / 100.f);
      } else {
        // HERMITE_SPLINE
        color_output = HermiteSplinePerChannelRolloff(
            color_output,
            peak,
            clamp(white_clip, peak, 500.f));
      }

      color_output *= signs;

    } else {
      if (current_config.contrast != 1.f || current_config.flare != 0.f) {
        y = renodx::color::grade::Contrast(y, computed_contrast, current_config.mid_gray_value);
      }
      float y_new = y;
      [branch]
      if (current_config.tone_map_method == config::tone_map_method::NONE) {
        // noop
      } else if (current_config.tone_map_method == config::tone_map_method::REINHARD) {
        y_new = ReinhardScalableExtended(
            y,
            max(white_clip, peak),
            peak,
            0,
            current_config.mid_gray_value,
            current_config.mid_gray_nits / 100.f);
      } else {
        // HERMITE_SPLINE
        y_new = HermiteSplineLuminanceRolloff(
            y,
            peak,
            clamp(white_clip, peak, 500.f));
      }

      color_output = input_color * (y_original > 0 ? (y_new / y_original) : 0);
    }
  }

  [branch]
  if (current_config.dechroma != 0.f
      || current_config.saturation != 1.f
      || current_config.hue_correction_strength != 0.f
      || current_config.blowout != 0.f) {
    color_output = renodx::color::convert::ColorSpaces(color_output, current_color_space, renodx::color::convert::COLOR_SPACE_BT709);
    current_color_space = renodx::color::convert::COLOR_SPACE_BT709;

    float3 perceptual_new;

    if (current_config.hue_correction_strength != 0.f) {
      float3 perceptual_old;
      float3 source = (current_config.hue_correction_type == config::hue_correction_type::INPUT)
                          ? bt709
                          : current_config.hue_correction_source;

      [branch]
      if (current_config.hue_correction_method == config::hue_correction_method::ICTCP) {
        perceptual_new = renodx::color::ictcp::from::BT709(color_output);
        perceptual_old = renodx::color::ictcp::from::BT709(source);
      } else if (current_config.hue_correction_method == config::hue_correction_method::DARKTABLE_UCS) {
        perceptual_new = renodx::color::dtucs::uvY::from::BT709(color_output).zxy;
        perceptual_old = renodx::color::dtucs::uvY::from::BT709(source).zxy;
      } else {  // OKLab
        perceptual_new = renodx::color::oklab::from::BT709(color_output);
        perceptual_old = renodx::color::oklab::from::BT709(source);
      }

      // Save chrominance to apply back
      float chrominance_pre_adjust = length(perceptual_new.yz);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, current_config.hue_correction_strength);

      float chrominance_post_adjust = length(perceptual_new.yz);

      // Apply back previous chrominance

      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    } else {
      [branch]
      if (current_config.hue_correction_method == config::hue_correction_method::ICTCP) {
        perceptual_new = renodx::color::ictcp::from::BT709(color_output);
      } else if (current_config.hue_correction_method == config::hue_correction_method::DARKTABLE_UCS) {
        perceptual_new = renodx::color::dtucs::uvY::from::BT709(color_output).zxy;
      } else {  // OKLab
        perceptual_new = renodx::color::oklab::from::BT709(color_output);
      }
    }

    if (current_config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y_original / (10000.f / 100.f), (1.f - current_config.dechroma))));
    }

    if (current_config.blowout != 0.f) {
      float percent_max = saturate(y_original * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(current_config.blowout));
      if (current_config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= current_config.saturation;

    [branch]
    if (current_config.hue_correction_method == config::hue_correction_method::ICTCP) {
      color_output = renodx::color::bt709::from::ICtCp(perceptual_new);
    } else if (current_config.hue_correction_method == config::hue_correction_method::DARKTABLE_UCS) {
      color_output = renodx::color::bt709::from::dtucs::uvY(perceptual_new.yzx);
    } else {  // OKLab
      color_output = renodx::color::bt709::from::OkLab(perceptual_new);
    }

  } else {
    // noop
  }

  [branch]
  if (current_config.clamp_color_space != -1.f) {
    color_output = renodx::color::convert::ColorSpaces(color_output, current_color_space, current_config.clamp_color_space);
    color_output = max(0, color_output);
    current_color_space = current_config.clamp_color_space;
  }

  [branch]
  if (current_config.clamp_peak != -1.f) {
    color_output = renodx::color::convert::ColorSpaces(color_output, current_color_space, current_config.clamp_peak);
    color_output = min(color_output, peak);
    current_color_space = current_config.clamp_peak;
  }

  color_output = renodx::color::convert::ColorSpaces(color_output, current_color_space, renodx::color::convert::COLOR_SPACE_BT709);

  return color_output;
}

float3 BT709(
    float3 bt709,
    float nits_peak,
    float mid_gray_value,
    float mid_gray_nits,
    float exposure,
    float highlights,
    float shadows,  // 0 = 0.10, 1.f = 0, >1 = contrast
    float contrast,
    float saturation,
    float dechroma,
    float flare,
    float hue_correction_strength,
    float3 hue_correction_source) {
  Config config = config::Create();
  config.nits_peak = nits_peak;
  config.mid_gray_value = mid_gray_value;
  config.mid_gray_nits = mid_gray_nits;
  config.exposure = exposure;
  config.highlights = highlights;
  config.shadows = shadows;
  config.contrast = contrast;
  config.saturation = saturation;
  config.dechroma = dechroma;
  config.flare = flare;
  config.hue_correction_strength = hue_correction_strength;
  config.hue_correction_source = hue_correction_source;
  config.hue_correction_type = renodrt::config::hue_correction_type::CUSTOM;
  return BT709(bt709, config);
}
float3 BT709(
    float3 bt709,
    float nits_peak = 1000.f / 203.f * 100.f,
    float mid_gray_value = 0.18f,
    float mid_gray_nits = 10.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.1f,
    float saturation = 1.f,
    float dechroma = 0.5f,
    float flare = 0.f,
    float hue_correction_strength = 1.f) {
  return BT709(
      bt709,
      nits_peak,
      mid_gray_value,
      mid_gray_nits,
      exposure,
      highlights,
      shadows,
      contrast,
      saturation,
      dechroma,
      flare,
      hue_correction_strength,
      bt709);
}

float3 NeutralSDR(float3 bt709, bool per_channel = false) {
  Config renodrt_config = config::Create();
  renodrt_config.nits_peak = 100.f;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.f;
  renodrt_config.saturation = 1.f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.per_channel = per_channel;
  renodrt_config.hue_correction_strength = 0.f;
  renodrt_config.working_color_space = 0.f;
  renodrt_config.tone_map_method = RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD;
  renodrt_config.clamp_peak = RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK;
  renodrt_config.clamp_color_space = RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE;
  renodrt_config.white_clip = RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP;

  return BT709(bt709, renodrt_config);
}

}  // namespace renodrt
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_SHADERS_RENO_DRT_HLSL_
