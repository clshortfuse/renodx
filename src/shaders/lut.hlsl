#ifndef SRC_SHADERS_LUT_HLSL_
#define SRC_SHADERS_LUT_HLSL_

#include "./color.hlsl"

namespace renodx {
namespace lut {
struct Config {
  SamplerState lut_sampler;
  float strength;
  float scaling;
  uint type_input;
  uint type_output;
  float size;
  float3 precompute;
};

namespace config {
namespace type {
static const uint LINEAR = 0u;
static const uint SRGB = 1u;
static const uint GAMMA_2_4 = 2u;
static const uint GAMMA_2_2 = 3u;
static const uint GAMMA_2_0 = 4u;
static const uint ARRI_C800 = 5u;
static const uint ARRI_C1000 = 6u;
static const uint ARRI_C800_NO_CUT = 7u;
static const uint ARRI_C1000_NO_CUT = 8u;
static const uint PQ = 9u;
}  // namespace type

Config Create(SamplerState lut_sampler, float strength, float scaling, uint type_input, uint type_output, float size = 0) {
  Config config = {lut_sampler, strength, scaling, type_input, type_output, size, float3(0, 0, 0)};
  return config;
}

Config Create(SamplerState lut_sampler, float strength, float scaling, uint type_input, uint type_output, float3 precompute) {
  Config config = {lut_sampler, strength, scaling, type_input, type_output, 0, precompute};
  return config;
}
}  // namespace config

float3 CenterTexel(float3 color, float size) {
  float scale = (size - 1.f) / size;
  float offset = 1.f / (2.f * size);
  return scale * color + offset;
}

#define SAMPLE_TEXTURE_3D_FUNCTION_GENERATOR(TextureType)                            \
  float3 Sample(TextureType lut, SamplerState state, float3 color, float size = 0) { \
    if (size == 0) {                                                                 \
      /* Removed by compiler if specified */                                         \
      float width;                                                                   \
      float height;                                                                  \
      float depth;                                                                   \
      lut.GetDimensions(width, height, depth);                                       \
      size = height;                                                                 \
    }                                                                                \
                                                                                     \
    float3 position = CenterTexel(color, size);                                      \
                                                                                     \
    return lut.SampleLevel(state, position, 0.0f).rgb;                               \
  }

#define SAMPLE_TEXTURE_2D_PRECOMPUTED_FUNCTION_GENERATOR(TextureType)                   \
  float3 Sample(TextureType lut, SamplerState state, float3 color, float3 precompute) { \
    float texel_size = precompute.x;                                                    \
    float slice = precompute.y;                                                         \
    float max_index = precompute.z;                                                     \
                                                                                        \
    float z_position = color.z * max_index;                                             \
    float z_integer = floor(z_position);                                                \
    float z_fraction = z_position - z_integer;                                          \
                                                                                        \
    const float x_offset = (color.r * max_index * texel_size) + (texel_size * 0.5f);    \
    const float y_offset = (color.g * max_index * slice) + (slice * 0.5f);              \
    const float z_offset = z_integer * slice;                                           \
                                                                                        \
    float2 uv = float2(z_offset + x_offset, y_offset);                                  \
                                                                                        \
    float3 color0 = lut.SampleLevel(state, uv, 0).rgb;                                  \
    uv.x += slice;                                                                      \
    float3 color1 = lut.SampleLevel(state, uv, 0).rgb;                                  \
                                                                                        \
    return lerp(color0, color1, z_fraction);                                            \
  }

#define SAMPLE_TEXTURE_2D_FUNCTION_GENERATOR(TextureType)                            \
  float3 Sample(TextureType lut, SamplerState state, float3 color, float size = 0) { \
    if (size == 0) {                                                                 \
      /* Removed by compiler if specified */                                         \
      float width;                                                                   \
      float height;                                                                  \
      lut.GetDimensions(width, height);                                              \
      size = min(width, height);                                                     \
    }                                                                                \
                                                                                     \
    const float max_index = size - 1.f;                                              \
    const float slice = 1.f / size;                                                  \
    const float texel_size = slice * slice;                                          \
                                                                                     \
    return Sample(lut, state, color, float3(texel_size, slice, max_index));          \
  }

#define SAMPLE_COLOR_3D_FUNCTION_GENERATOR(TextureType)                      \
  float3 SampleColor(float3 color, Config config, TextureType lut_texture) { \
    return Sample(lut_texture, config.lut_sampler, color.rgb, config.size);  \
  }

#define SAMPLE_COLOR_2D_FUNCTION_GENERATOR(TextureType)                                 \
  float3 SampleColor(float3 color, Config config, TextureType lut_texture) {            \
    if (config.precompute.x) {                                                          \
      return Sample(lut_texture, config.lut_sampler, color.rgb, config.precompute.xyz); \
    }                                                                                   \
    return Sample(lut_texture, config.lut_sampler, color.rgb, config.size);             \
  }

SAMPLE_TEXTURE_3D_FUNCTION_GENERATOR(Texture3D<float4>);
SAMPLE_TEXTURE_3D_FUNCTION_GENERATOR(Texture3D<float3>);
SAMPLE_TEXTURE_2D_PRECOMPUTED_FUNCTION_GENERATOR(Texture2D<float4>);
SAMPLE_TEXTURE_2D_PRECOMPUTED_FUNCTION_GENERATOR(Texture2D<float3>);
SAMPLE_TEXTURE_2D_FUNCTION_GENERATOR(Texture2D<float4>);
SAMPLE_TEXTURE_2D_FUNCTION_GENERATOR(Texture2D<float3>);
SAMPLE_COLOR_3D_FUNCTION_GENERATOR(Texture3D<float4>);
SAMPLE_COLOR_3D_FUNCTION_GENERATOR(Texture3D<float3>);
SAMPLE_COLOR_2D_FUNCTION_GENERATOR(Texture2D<float4>);
SAMPLE_COLOR_2D_FUNCTION_GENERATOR(Texture2D<float3>);

#undef SAMPLE_TEXTURE_3D_FUNCTION_GENERATOR
#undef SAMPLE_TEXTURE_2D_PRECOMPUTED_FUNCTION_GENERATOR
#undef SAMPLE_TEXTURE_2D_FUNCTION_GENERATOR
#undef SAMPLE_COLOR_3D_FUNCTION_GENERATOR
#undef SAMPLE_COLOR_2D_FUNCTION_GENERATOR

float3 SampleUnreal(Texture2D lut, SamplerState state, float3 color, float size = 0) {
  if (size == 0) {
    // Removed by compiler if specified
    float width;
    float height;
    lut.GetDimensions(width, height);
    size = min(width, height);
  }
  float slice = 1.f / size;

  float z_position = color.z * size - 0.5;
  float z_integer = floor(z_position);
  half fraction = z_position - z_integer;

  float2 uv = float2((color.r + z_integer) * slice, color.g);

  float3 color0 = lut.SampleLevel(state, uv, 0).rgb;
  uv.x += slice;
  float3 color1 = lut.SampleLevel(state, uv, 0).rgb;

  return lerp(color0, color1, fraction);
}

float3 CorrectBlack(float3 color_input, float3 lut_color, float lut_black_y, float strength) {
  const float input_y = renodx::color::y::from::BT709(color_input);
  const float color_y = renodx::color::y::from::BT709(lut_color);
  const float a = lut_black_y;
  const float b = lerp(0, lut_black_y, strength);
  const float g = input_y;
  const float h = color_y;
  const float new_y = h - pow(lut_black_y, pow(1.f + g, b / a));
  lut_color *= (color_y > 0) ? min(color_y, new_y) / color_y : 1.f;
  return lut_color;
}

float3 CorrectWhite(float3 color_input, float3 lut_color, float lut_white_y, float target_white_y, float strength) {
  const float input_y = min(target_white_y, renodx::color::y::from::BT709(color_input));
  const float color_y = renodx::color::y::from::BT709(lut_color);
  const float a = lut_white_y / target_white_y;
  const float b = lerp(1.f, 0.f, strength);
  const float g = input_y;
  const float h = color_y;
  const float new_y = h * pow((1.f / a), pow(g / target_white_y, b / a));
  lut_color *= (color_y > 0) ? max(color_y, new_y) / color_y : 1.f;
  return lut_color;
}

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 white_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;
  const float3 removed_gamma = 1.f - min(1.f, white_gamma);

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove relative to distance to inverse midgray
  const float shadow_length = 1.f - mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  // Add back relative to distance from midgray
  const float highlights_length = mid_gray_average;
  const float highlights_stop = 1.f - min(neutral_gamma.r, min(neutral_gamma.g, neutral_gamma.b));
  const float3 ceiling_add = removed_gamma * (max(0, highlights_length - highlights_stop) / highlights_length);

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove) + ceiling_add;
  return unclamped_gamma;
}

float3 RecolorUnclamped(float3 original_linear, float3 unclamped_linear) {
  const float3 original_lab = renodx::color::oklab::from::BT709(original_linear);

  float3 retinted_lab = renodx::color::oklab::from::BT709(unclamped_linear);
  retinted_lab[0] = max(0, retinted_lab[0]);
  retinted_lab[1] = original_lab[1];
  retinted_lab[2] = original_lab[2];

  float3 retinted_linear = renodx::color::bt709::from::OkLab(retinted_lab);
  retinted_linear = renodx::color::bt709::clamp::AP1(retinted_linear);
  return retinted_linear;
}

float3 ConvertInput(float3 color, Config config) {
  if (config.type_input == config::type::SRGB) {
    color = renodx::color::srgb::from::BT709(saturate(color));
  } else if (config.type_input == config::type::GAMMA_2_4) {
    color = pow(saturate(color), 1.f / 2.4f);
  } else if (config.type_input == config::type::GAMMA_2_2) {
    color = pow(saturate(color), 1.f / 2.2f);
  } else if (config.type_input == config::type::GAMMA_2_0) {
    color = sqrt(saturate(color));
  } else if (config.type_input == config::type::ARRI_C800) {
    color = renodx::color::arri::logc::c800::Encode(max(0, color));
  } else if (config.type_input == config::type::ARRI_C1000) {
    color = renodx::color::arri::logc::c1000::Encode(max(0, color));
  } else if (config.type_input == config::type::ARRI_C800_NO_CUT) {
    color = renodx::color::arri::logc::c800::Encode(max(0, color), 0);
  } else if (config.type_input == config::type::ARRI_C1000_NO_CUT) {
    color = renodx::color::arri::logc::c1000::Encode(max(0, color), 0);
  } else if (config.type_input == config::type::PQ) {
    float3 bt2020 = renodx::color::bt2020::from::BT709(color);
    color = renodx::color::pq::from::BT2020((bt2020 * 100.f) / 10000.f);
  }
  return color;
}

float3 GammaOutput(float3 color, Config config) {
  if (config.type_output == config::type::LINEAR) {
    color = renodx::color::srgb::from::BT709(max(0, color));
  }
  return color;
}

float3 LinearOutput(float3 color, Config config) {
  if (config.type_output == config::type::SRGB) {
    color = sign(color) * renodx::color::bt709::from::SRGB(abs(color));
  } else if (config.type_output == config::type::GAMMA_2_4) {
    color = sign(color) * pow(abs(color), 2.4f);
  } else if (config.type_output == config::type::GAMMA_2_2) {
    color = sign(color) * pow(abs(color), 2.2f);
  } else if (config.type_output == config::type::GAMMA_2_0) {
    color = sign(color) * color * color;
  }
  return color;
}

float3 GammaInput(float3 color_input, float3 color_input_converted, Config config) {
  if (
      config.type_input == config::type::SRGB
      || config.type_input == config::type::GAMMA_2_4
      || config.type_input == config::type::GAMMA_2_2
      || config.type_input == config::type::GAMMA_2_0) {
    return color_input_converted;
  }
  return renodx::color::srgb::from::BT709(max(0, color_input));
}

float3 LinearUnclampedOutput(float3 color, Config config) {
  if (config.type_output == config::type::GAMMA_2_4) {
    color = sign(color) * pow(abs(color), 2.4f);
  } else if (config.type_output == config::type::GAMMA_2_2) {
    color = sign(color) * pow(abs(color), 2.2f);
  } else {
    color = sign(color) * renodx::color::bt709::from::SRGB(abs(color));
  }
  return color;
}

float3 RestoreSaturationLoss(float3 color_input, float3 color_output, Config config) {
  // Saturation (distance from grayscale)
  float y_in = renodx::color::y::from::BT709(abs(color_input));
  float3 sat_in = color_input - y_in;

  float3 clamped = color_input;
  if (config.type_input == config::type::SRGB) {
    clamped = saturate(clamped);
  } else if (config.type_input == config::type::GAMMA_2_4) {
    clamped = saturate(clamped);
  } else if (config.type_input == config::type::GAMMA_2_2) {
    clamped = saturate(clamped);
  } else if (config.type_input == config::type::GAMMA_2_0) {
    clamped = saturate(clamped);
  } else if (config.type_input == config::type::ARRI_C800) {
    clamped = max(0, clamped);
  } else if (config.type_input == config::type::ARRI_C1000) {
    clamped = max(0, clamped);
  } else if (config.type_input == config::type::ARRI_C800_NO_CUT) {
    clamped = max(0, clamped);
  } else if (config.type_input == config::type::ARRI_C1000_NO_CUT) {
    clamped = max(0, clamped);
  } else if (config.type_input == config::type::PQ) {
    clamped = max(0, renodx::color::bt709::from::BT2020(clamped));
  }

  float3 sat_clamped = clamped - y_in;

  float y_out = renodx::color::y::from::BT709(abs(color_output));
  float3 sat_out = color_output - y_out;
  float3 sat_new = float3(
      sat_out.r * (sat_clamped.r ? (sat_in.r / sat_clamped.r) : 1.f),
      sat_out.g * (sat_clamped.g ? (sat_in.g / sat_clamped.g) : 1.f),
      sat_out.b * (sat_clamped.b ? (sat_in.b / sat_clamped.b) : 1.f));
  return (y_out + sat_new);
}

#define SAMPLE_FUNCTION_GENERATOR(textureType)                                                     \
  float3 Sample(textureType lut_texture, Config config, float3 color_input) {                      \
    float3 lutInputColor = ConvertInput(color_input, config);                                      \
    float3 lutOutputColor = SampleColor(lutInputColor, config, lut_texture);                       \
    float3 color_output = LinearOutput(lutOutputColor, config);                                    \
    if (config.scaling) {                                                                          \
      float3 lutBlack = SampleColor(ConvertInput(0, config), config, lut_texture);                 \
      float3 lutMid = SampleColor(ConvertInput(0.18f, config), config, lut_texture);               \
      float3 lutWhite = SampleColor(ConvertInput(1.f, config), config, lut_texture);               \
      float3 unclamped = Unclamp(                                                                  \
          GammaOutput(lutOutputColor, config),                                                     \
          GammaOutput(lutBlack, config),                                                           \
          GammaOutput(lutMid, config),                                                             \
          GammaOutput(lutWhite, config),                                                           \
          GammaInput(color_input, lutInputColor, config));                                         \
      float3 recolored = RecolorUnclamped(color_output, LinearUnclampedOutput(unclamped, config)); \
      color_output = lerp(color_output, recolored, config.scaling);                                \
    }                                                                                              \
    color_output = RestoreSaturationLoss(color_input, color_output, config);                       \
    if (config.strength != 1.f) {                                                                  \
      color_output = lerp(color_input, color_output, config.strength);                             \
    }                                                                                              \
    return color_output;                                                                           \
  }

SAMPLE_FUNCTION_GENERATOR(Texture3D<float4>);
SAMPLE_FUNCTION_GENERATOR(Texture3D<float3>);
SAMPLE_FUNCTION_GENERATOR(Texture2D<float4>);
SAMPLE_FUNCTION_GENERATOR(Texture2D<float3>);

#undef SAMPLE_FUNCTION_GENERATOR

// Deprecated
#define SAMPLE_DEPRECATED_FUNCTION_GENERATOR(textureType)                     \
  float3 Sample(float3 color_input, Config config, textureType lut_texture) { \
    return Sample(lut_texture, config, color_input);                          \
  }

SAMPLE_DEPRECATED_FUNCTION_GENERATOR(Texture3D<float4>);
SAMPLE_DEPRECATED_FUNCTION_GENERATOR(Texture3D<float3>);
SAMPLE_DEPRECATED_FUNCTION_GENERATOR(Texture2D<float4>);
SAMPLE_DEPRECATED_FUNCTION_GENERATOR(Texture2D<float3>);

#undef SAMPLE_DEPRECATED_FUNCTION_GENERATOR
}  // namespace lut
}  // namespace renodx

#endif  // SRC_SHADERS_LUT_HLSL_
