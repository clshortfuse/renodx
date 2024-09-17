#ifndef SRC_SHADERS_TONEMAP_HLSL_
#define SRC_SHADERS_TONEMAP_HLSL_

#include "./aces.hlsl"
#include "./colorcorrect.hlsl"
#include "./colorgrade.hlsl"
#include "./lut.hlsl"
#include "./renodrt.hlsl"

namespace renodx {
namespace tonemap {

float ApplyCurve(float x, float a, float b, float c, float d, float e, float f) {
  return ((x * (a * x + c * b) + d * e) / (x * (a * x + b) + d * f)) - e / f;
}

float3 ApplyCurve(float3 x, float a, float b, float c, float d, float e, float f) {
  return ((x * (a * x + c * b) + d * e) / (x * (a * x + b) + d * f)) - e / f;
}

// https://www.glowybits.com/blog/2016/12/21/ifl_iss_hdr_1/
float SmoothClamp(float x) {
  const float u = 0.525;
  float q = (2.0 - u - 1.0 / u + x * (2.0 + 2.0 / u - x / u)) / 4.0;
  return (abs(1.0 - x) < u) ? q : saturate(x);
}

float3 Reinhard(float x) {
  return x / (1.0f + x);
}

float3 Reinhard(float3 color) {
  return color / (1.0f + color);
}

float3 ReinhardExtended(float3 color, float max_white = 1000.f / 203.f) {
  return (color * (1.0f + (color / (max_white * max_white))))
         / (1.0f + color);
}

// Narkowicz
float3 ACESFittedBT709(float3 color) {
  color *= 0.6f;
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  return clamp((color * (a * color + b)) / (color * (c * color + d) + e), 0.0f, 1.0f);
}

// Stephen Hill
float3 ACESFittedAP1(float3 color) {
  // sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
  const float3x3 ACESInputMat = {
      {0.59719, 0.35458, 0.04823},
      {0.07600, 0.90834, 0.01566},
      {0.02840, 0.13383, 0.83777}};

  // ODT_SAT => XYZ => D60_2_D65 => sRGB
  const float3x3 ACESOutputMat = {
      {1.60475, -0.53108, -0.07367},
      {-0.10208, 1.10813, -0.00605},
      {-0.00327, -0.07276, 1.07602}};

  color = mul(ACESInputMat, color);

  float3 a = color * (color + 0.0245786f) - 0.000090537f;
  float3 b = color * (0.983729f * color + 0.4329510f) + 0.238081f;
  color = a / b;

  color = mul(ACESOutputMat, color);

  color = saturate(color);
  return color;
}

// https://www.slideshare.net/ozlael/hable-john-uncharted2-hdr-lighting
// http://filmicworlds.com/blog/filmic-tonemapping-operators/

namespace uncharted2 {
static const float A = 0.22;  // Shoulder Strength
static const float B = 0.30;  // Linear Strength
static const float C = 0.10;  // Linear Angle
static const float D = 0.20;  // Toe Strength
static const float E = 0.01;  // Toe Numerator
static const float F = 0.30;  // Toe Denominator
static const float W = 11.2;  // Linear White
float BT709(float x, float linear_white = W) {
  return ApplyCurve(x, A, B, C, D, E, F)
         / ApplyCurve(linear_white, A, B, C, D, E, F);
}

float3 BT709(float3 x, float linear_white = W) {
  return ApplyCurve(x, A, B, C, D, E, F)
         / ApplyCurve(linear_white, A, B, C, D, E, F);
}
}  // namespace uncharted2

namespace unity {
static const float A = 0.20;   // Shoulder Strength
static const float B = 0.29;   // Linear Strength
static const float C = 0.24;   // Linear Angle
static const float D = 0.272;  // Toe Strength
static const float E = 0.02;   // Toe Numerator
static const float F = 0.03;   // Toe Denominator
// Neutral
float3 BT709(float3 x) {
  float3 r0, r1, r2 = x;
  r0.xyz = x.xyz;
  r1.xyz = float3(1.31338608, 1.31338608, 1.31338608) * r0.xyz;
  r2.xyz = r0.xyz * float3(0.262677222, 0.262677222, 0.262677222) + float3(0.0695999935, 0.0695999935, 0.0695999935);
  r2.xyz = r1.xyz * r2.xyz + float3(0.00543999998, 0.00543999998, 0.00543999998);
  r0.xyz = r0.xyz * float3(0.262677222, 0.262677222, 0.262677222) + float3(0.289999992, 0.289999992, 0.289999992);
  r0.xyz = r1.xyz * r0.xyz + float3(0.0816000104, 0.0816000104, 0.0816000104);
  r0.xyz = r2.xyz / r0.xyz;
  r0.xyz = float3(-0.0666666627, -0.0666666627, -0.0666666627) + r0.xyz;
  r0.xyz = float3(1.31338608, 1.31338608, 1.31338608) * r0.xyz;
  return r0.xyz;
}
}  // namespace unity

struct Config {
  float type;
  float peak_nits;
  float game_nits;
  float gamma_correction;
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float saturation;
  float mid_gray_value;
  float mid_gray_nits;
  float reno_drt_highlights;
  float reno_drt_shadows;
  float reno_drt_contrast;
  float reno_drt_saturation;
  float reno_drt_dechroma;
  float reno_drt_flare;
  float hue_correction_type;
  float hue_correction_strength;
  float3 hue_correction_color;
};

float3 UpgradeToneMap(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  float ratio = 1.f;

  float y_hdr = renodx::color::y::from::BT709(abs(color_hdr));
  float y_sdr = renodx::color::y::from::BT709(abs(color_sdr));
  float y_post_process = renodx::color::y::from::BT709(abs(post_process_color));

  if (y_hdr < y_sdr) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    ratio = y_hdr / y_sdr;
  } else {
    float y_delta = y_hdr - y_sdr;
    y_delta = max(0, y_delta);  // Cleans up NaN
    const float y_new = y_post_process + y_delta;

    const bool y_valid = (y_post_process > 0);  // Cleans up NaN and ignore black
    ratio = y_valid ? (y_new / y_post_process) : 0;
  }

  float3 color_scaled = post_process_color * ratio;
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

namespace config {
namespace type {
static const float VANILLA = 0.f;
static const float NONE = 1.f;
static const float ACES = 2.f;
static const float RENODRT = 3.f;
}  // namespace type

namespace hue_correction_type {
static const float INPUT = 0.f;
static const float CLAMPED = 1.f;
static const float CUSTOM = 2.f;
}  // namespace hue_correction_type

Config Create(
    float type = config::type::VANILLA,
    float peak_nits = 203.f,
    float game_nits = 203.f,
    float gamma_correction = 0,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float saturation = 1.f,
    float mid_gray_value = 0.18f,
    float mid_gray_nits = 18.f,
    float reno_drt_highlights = 1.f,
    float reno_drt_shadows = 1.f,
    float reno_drt_contrast = 1.f,
    float reno_drt_saturation = 1.f,
    float reno_drt_dechroma = 0.5f,
    float reno_drt_flare = 0.f,
    float hue_correction_type = config::hue_correction_type::INPUT,
    float hue_correction_strength = 1.f,
    float3 hue_correction_color = 0) {
  const Config config = {
      type,
      peak_nits,
      game_nits,
      gamma_correction,
      exposure,
      highlights,
      shadows,
      contrast,
      saturation,
      mid_gray_value,
      mid_gray_nits,
      reno_drt_highlights,
      reno_drt_shadows,
      reno_drt_contrast,
      reno_drt_saturation,
      reno_drt_dechroma,
      reno_drt_flare,
      hue_correction_type,
      hue_correction_strength,
      hue_correction_color};
  return config;
}

float3 ApplyRenoDRT(float3 color, Config config, bool sdr = false) {
  float reno_drt_max = sdr ? 1.f : (config.peak_nits / config.game_nits);
  if (!sdr && config.gamma_correction != 0) {
    reno_drt_max = renodx::color::correct::Gamma(reno_drt_max, config.gamma_correction == 1.f);
  }

  return renodx::tonemap::renodrt::BT709(
      color,
      reno_drt_max * 100.f,
      0.18f,
      config.mid_gray_nits,
      config.exposure,
      config.reno_drt_highlights,
      config.reno_drt_shadows,
      config.reno_drt_contrast,
      config.reno_drt_saturation,
      config.reno_drt_dechroma,
      config.reno_drt_flare,
      config.hue_correction_strength,
      (config.hue_correction_type == config::hue_correction_type::CUSTOM)    ? config.hue_correction_color
      : (config.hue_correction_type == config::hue_correction_type::CLAMPED) ? clamp(color, 0, 1)
                                                                             : color);
}

float3 ApplyACES(float3 color, Config config, bool sdr = false) {
  static const float ACES_MID_GRAY = 0.10f;
  const float mid_gray_scale = (config.mid_gray_value / ACES_MID_GRAY);
  const float reference_white = (sdr ? 1.f : config.game_nits);

  float aces_min = (0.0001f) / reference_white;
  float aces_max = (sdr ? 1.f : config.peak_nits) / reference_white;

  if (!sdr && config.gamma_correction != 0.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, config.gamma_correction == 1.f);
    aces_min = renodx::color::correct::Gamma(aces_min, config.gamma_correction == 1.f);
  }
  aces_max /= mid_gray_scale;
  aces_min /= mid_gray_scale;

  color = renodx::tonemap::aces::RGCAndRRTAndODT(color, aces_min * 48.f, aces_max * 48.f);
  color /= 48.f;
  color *= mid_gray_scale;

  return color;
}

float3 Apply(float3 untonemapped, Config config) {
  float3 color = untonemapped;

  if (config.type == config::type::RENODRT) {
    config.reno_drt_highlights *= config.highlights;
    config.reno_drt_shadows *= config.shadows;
    config.reno_drt_contrast *= config.contrast;
    config.reno_drt_saturation *= config.saturation;
    // config.reno_drt_dechroma *= config.dechroma;
    color = ApplyRenoDRT(color, config);
  } else {
    color = renodx::color::grade::UserColorGrading(
        color,
        config.exposure,
        config.highlights,
        config.shadows,
        config.contrast,
        config.saturation);
    if (config.type == config::type::ACES) {
      color = ApplyACES(color, config);
    }
  }
  return color;
}

struct DualToneMap {
  float3 color_hdr;
  float3 color_sdr;
};

DualToneMap ApplyToneMaps(float3 color_input, Config config) {
  DualToneMap dual_tone_map;
  float3 color_hdr;
  float3 color_sdr;
  if (config.type == config::type::RENODRT) {
    config.reno_drt_saturation *= config.saturation;

    color_sdr = ApplyRenoDRT(color_input, config, true);

    config.reno_drt_highlights *= config.highlights;
    config.reno_drt_shadows *= config.shadows;
    config.reno_drt_contrast *= config.contrast;
    uint previous_hue_correction_type = config.hue_correction_type;
    config.hue_correction_type = config::hue_correction_type::INPUT;

    color_hdr = ApplyRenoDRT(color_input, config);

    config.hue_correction_type = previous_hue_correction_type;

  } else {
    color_input = renodx::color::grade::UserColorGrading(
        color_input, config.exposure, config.highlights, config.shadows, config.contrast, config.saturation);

    if (config.type == config::type::ACES) {
      color_hdr = ApplyACES(color_input, config);
      color_sdr = ApplyACES(color_input, config, true);
    } else {
      color_hdr = color_input;
      color_sdr = color_input;
    }
  }
  dual_tone_map.color_hdr = color_hdr;
  dual_tone_map.color_sdr = color_sdr;
  return dual_tone_map;
}

#define TONE_MAP_FUNCTION_GENERATOR(textureType)                                                             \
  float3 Apply(float3 color_input, Config config, renodx::lut::Config lut_config, textureType lut_texture) { \
    if (lut_config.strength == 0.f || config.type == 1.f) {                                                  \
      return Apply(color_input, config);                                                                     \
    }                                                                                                        \
    float3 color_output = color_input;                                                                       \
                                                                                                             \
    DualToneMap tone_maps = ApplyToneMaps(color_input, config);                                              \
    float3 color_hdr = tone_maps.color_hdr;                                                                  \
    float3 color_sdr = tone_maps.color_sdr;                                                                  \
                                                                                                             \
    uint previous_lut_config_strength = lut_config.strength;                                                 \
    lut_config.strength = 1.f;                                                                               \
    float3 color_lut;                                                                                        \
    if (                                                                                                     \
        lut_config.type_input == lut::config::type::SRGB                                                     \
        || lut_config.type_input == lut::config::type::GAMMA_2_4                                             \
        || lut_config.type_input == lut::config::type::GAMMA_2_2                                             \
        || lut_config.type_input == lut::config::type::GAMMA_2_0) {                                          \
      color_lut = renodx::lut::Sample(lut_texture, lut_config, color_sdr);                                   \
    } else {                                                                                                 \
      color_lut = min(1.f, renodx::lut::Sample(lut_texture, lut_config, color_hdr));                         \
    }                                                                                                        \
                                                                                                             \
    if (config.type == config::type::VANILLA) {                                                              \
      color_output = lerp(color_output, color_lut, previous_lut_config_strength);                            \
    } else {                                                                                                 \
      color_output = UpgradeToneMap(color_hdr, color_sdr, color_lut, previous_lut_config_strength);          \
    }                                                                                                        \
    return color_output;                                                                                     \
  }

TONE_MAP_FUNCTION_GENERATOR(Texture2D<float4>);
TONE_MAP_FUNCTION_GENERATOR(Texture2D<float3>);
TONE_MAP_FUNCTION_GENERATOR(Texture3D<float4>);
TONE_MAP_FUNCTION_GENERATOR(Texture3D<float3>);

#undef TONE_MAP_FUNCTION_GENERATOR

}  // namespace config
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_SHADERS_TONEMAP_HLSL_
