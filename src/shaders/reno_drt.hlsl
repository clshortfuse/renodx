#ifndef SRC_SHADERS_RENO_DRT_HLSL_
#define SRC_SHADERS_RENO_DRT_HLSL_

#include "./color.hlsl"
#include "./color_convert.hlsl"
#include "./math.hlsl"
#include "./reinhard.hlsl"

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
  uint hue_correction_method;
  uint tone_map_method;
  uint hue_correction_type;
  uint working_color_space;
  bool per_channel;
  float blowout;
  float clamp_color_space;
  float clamp_peak;
  float white_clip;
};

namespace config {

namespace hue_correction_type {
static const uint INPUT = 0u;
static const uint CUSTOM = 1u;
}

namespace hue_correction_method {
static const uint OKLAB = 0u;
static const uint ICTCP = 1u;
static const uint DARKTABLE_UCS = 2u;
}

namespace tone_map_method {
static const uint DANIELE = 0u;
static const uint REINHARD = 1u;
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
    float3 hue_correction_source = 0,
    uint hue_correction_method = config::hue_correction_method::OKLAB,
    uint tone_map_method = config::tone_map_method::DANIELE,
    uint hue_correction_type = config::hue_correction_type::INPUT,
    uint working_color_space = 0u,
    bool per_channel = false,
    float blowout = 0,
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

float CustomizeLuminance(float value, float highlights = 1.f, float shadows = 1.f, float contrast = 1.f) {
  value = value / 0.18f;
  [branch]
  if (highlights != 1.f) {
    value = lerp(
        value,
        pow(value, highlights),
        saturate(value));
  }

  [branch]
  if (shadows != 1.f) {
    value = lerp(
        pow(value, 2.f - shadows),
        value,
        saturate(value));
  }

  [branch]
  if (contrast != 1.f) {
    value = pow(value, contrast);
  }
  value *= 0.18f;
  return value;
}

float3 BT709(float3 bt709, Config current_config) {
  const float n_r = 100.f;
  float n = 1000.f;

  // drt cam
  // n_r = 100
  // g = 1.15
  // c = 0.18
  // c_d = 10.013
  // w_g = 0.14
  // t_1 = 0.04
  // r_hit_min = 128
  // r_hit_max = 896

  float g = 1.1;            // gamma/contrast
  float c = 0.18;           // scene-referred gray
  float c_d = 10.013;       // output gray in nits
  const float w_g = 0.00f;  // gray change
  float t_1 = 0.01;         // shadow toe
  const float r_hit_min = 128;
  const float r_hit_max = 256;

  float white_clip = 100.f;

  g = current_config.contrast;
  c = current_config.mid_gray_value;
  c_d = current_config.mid_gray_nits;
  n = current_config.nits_peak;
  t_1 = current_config.flare;
  white_clip = current_config.white_clip;

  float3 input_color;
  float y_original;

  float current_color_space = current_config.working_color_space;

  if (current_config.working_color_space == 2u) {
    input_color = max(0, renodx::color::ap1::from::BT709(bt709));
    y_original = renodx::color::y::from::AP1(input_color);
  } else if (current_config.working_color_space == 1u) {
    input_color = renodx::color::bt2020::from::BT709(bt709);
    y_original = renodx::color::y::from::BT2020(abs(input_color));
  } else {
    input_color = bt709;
    y_original = renodx::color::y::from::BT709(abs(bt709));
  }

  float y = y_original;

  y *= current_config.exposure;
  y = CustomizeLuminance(y, current_config.highlights, current_config.shadows);

  float3 per_channel_color;
  [branch]
  if (current_config.per_channel) {
    per_channel_color = input_color * (y_original > 0 ? (y / y_original) : 0);
  } else {
    per_channel_color = input_color;
  }

  float m_0 = (n / n_r);

  float3 color_output;
  [branch]
  if (current_config.tone_map_method == config::tone_map_method::DANIELE) {
    float m_1 = 0.5 * (m_0 + sqrt(m_0 * (m_0 + (4.0 * t_1))));
    float r_hit = r_hit_min + ((r_hit_max - r_hit_min) * (log(m_0) / log(10000.0 / 100.0)));

    float u = pow((r_hit / m_1) / ((r_hit / m_1) + 1.0), g);
    const float m = m_1 / u;
    const float w_i = log(n / 100.0) / log(2.0);
    const float c_t = (c_d / n_r) * (1.0 + (w_i * w_g));
    const float g_ip = 0.5 * (c_t + sqrt(c_t * (c_t + (4.0 * t_1))));
    const float g_ipp2 = -m_1 * pow(g_ip / m, 1.0 / g) / (pow(g_ip / m, 1.0 / g) - 1.0);
    const float w_2 = c / g_ipp2;
    const float s_2 = w_2 * m_1;
    float u_2 = pow((r_hit / m_1) / ((r_hit / m_1) + w_2), g);
    float m_2 = m_1 / u_2;

    [branch]
    if (current_config.per_channel) {
      float3 ts3 = pow(max(0, per_channel_color) / (per_channel_color + s_2), g) * m_2;
      float3 flared3 = max(0, (ts3 * ts3) / (ts3 + t_1));

      color_output = clamp(flared3, 0, m_0);
    } else {
      float ts = pow(max(0, y) / (y + s_2), g) * m_2;
      float flared = max(0, (ts * ts) / (ts + t_1));

      float y_new = clamp(flared, 0, m_0);

      color_output = input_color * (y_original > 0 ? (y_new / y_original) : 0);
    }
  } else if (current_config.tone_map_method == config::tone_map_method::REINHARD) {
    white_clip = CustomizeLuminance(white_clip, current_config.highlights, current_config.shadows, current_config.contrast);

    [branch]
    if (current_config.per_channel) {
      color_output = per_channel_color;
      color_output /= 0.18f;
      float3 signs = sign(color_output);
      color_output = abs(color_output);

      // No guard for oversized flare
      float3 new_flare = math::DivideSafe(color_output + t_1, color_output, 1.f);

      float3 exponent = current_config.contrast * new_flare;

      color_output = pow(color_output, exponent);
      color_output *= signs;

      color_output *= 0.18f;

      color_output = ReinhardScalableExtended(
          color_output,
          white_clip,
          m_0,
          0,
          0.18f,
          current_config.mid_gray_nits / 100.f);
    } else {
      y /= 0.18f;

      // No guard for oversized flare
      float new_flare = math::DivideSafe(y + t_1, y, 1.f);
      float exponent = current_config.contrast * new_flare;
      y = math::SignPow(y, exponent);
      y *= 0.18f;

      float y_new = ReinhardScalableExtended(
          y,
          white_clip,
          m_0,
          0,
          0.18f,
          current_config.mid_gray_nits / 100.f);

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
      switch (current_config.hue_correction_method) {
        case config::hue_correction_method::OKLAB:
        default:
          perceptual_new = renodx::color::oklab::from::BT709(color_output);
          perceptual_old = renodx::color::oklab::from::BT709(source);
          break;
        case config::hue_correction_method::ICTCP:
          perceptual_new = renodx::color::ictcp::from::BT709(color_output);
          perceptual_old = renodx::color::ictcp::from::BT709(source);
          break;
        case config::hue_correction_method::DARKTABLE_UCS:
          perceptual_new = renodx::color::dtucs::uvY::from::BT709(color_output).zxy;
          perceptual_old = renodx::color::dtucs::uvY::from::BT709(source).zxy;
          break;
      }

      // Save chrominance to apply back
      float chrominance_pre_adjust = length(perceptual_new.yz);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, current_config.hue_correction_strength);

      float chrominance_post_adjust = length(perceptual_new.yz);

      // Apply back previous chrominance

      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    } else {
      [branch]
      switch (current_config.hue_correction_method) {
        default:
        case config::hue_correction_method::OKLAB:
          perceptual_new = renodx::color::oklab::from::BT709(color_output);
          break;
        case config::hue_correction_method::ICTCP:
          perceptual_new = renodx::color::ictcp::from::BT709(color_output);
          break;
        case config::hue_correction_method::DARKTABLE_UCS:
          perceptual_new = renodx::color::dtucs::uvY::from::BT709(color_output).zxy;
          break;
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
    if (current_config.hue_correction_method == config::hue_correction_method::OKLAB) {
      color_output = renodx::color::bt709::from::OkLab(perceptual_new);
    } else if (current_config.hue_correction_method == config::hue_correction_method::ICTCP) {
      color_output = renodx::color::bt709::from::ICtCp(perceptual_new);
    } else if (current_config.hue_correction_method == config::hue_correction_method::DARKTABLE_UCS) {
      color_output = renodx::color::bt709::from::dtucs::uvY(perceptual_new.yzx);
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
    color_output = min(color_output, m_0);
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
  renodrt_config.working_color_space = 0u;
  renodrt_config.clamp_color_space = 0u;

  return BT709(bt709, renodrt_config);
}

}  // namespace renodrt
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_SHADERS_RENO_DRT_HLSL_
