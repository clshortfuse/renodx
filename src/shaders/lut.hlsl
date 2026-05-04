#ifndef SRC_SHADERS_LUT_HLSL_
#define SRC_SHADERS_LUT_HLSL_

#include "./color.hlsl"
#include "./colorcorrect.hlsl"
#include "./math.hlsl"

namespace renodx {
namespace lut {
struct Config {
  SamplerState lut_sampler;
  float strength;
  float scaling;
  int type_input;
  int type_output;
  uint size;
  float3 precompute;
  bool tetrahedral;
  float recolor; // Deprecated
  float max_channel;
  float gamut_compress;
};

namespace config {
namespace type {
static const int LINEAR = 0u;
static const int SRGB = 1u;
static const int GAMMA_2_4 = 2;
static const int GAMMA_2_2 = 3;
static const int GAMMA_2_0 = 4;
static const int ARRI_C800 = 5;
static const int ARRI_C1000 = 6;
static const int ARRI_C800_NO_CUT = 7;
static const int ARRI_C1000_NO_CUT = 8;
static const int PQ = 9;
static const int ACES_CCT = 10;
}  // namespace type

Config Create(SamplerState lut_sampler, float strength, float scaling, int type_input, int type_output, uint size = 0) {
  Config lut_config = { lut_sampler, strength, scaling, type_input, type_output, size, float3(0, 0, 0), false, 0.f, 1.f, 1.f };
  return lut_config;
}

Config Create(SamplerState lut_sampler, float strength, float scaling, int type_input, int type_output, float size) {
  Config lut_config = { lut_sampler, strength, scaling, type_input, type_output, (uint)size, float3(0, 0, 0), false, 0.f, 1.f, 1.f };
  return lut_config;
}

Config Create(SamplerState lut_sampler, float strength, float scaling, int type_input, int type_output, float3 precompute) {
  Config lut_config = { lut_sampler, strength, scaling, type_input, type_output, 0, precompute, false, 0.f, 1.f, 1.f };
  return lut_config;
}

#if defined(__SHADER_TARGET_MAJOR) && (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic push
#pragma dxc diagnostic ignored "-Weffects-syntax"
#endif

SamplerState NULL_SAMPLER_STATE;

#if defined(__SHADER_TARGET_MAJOR) && (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic pop
#endif

Config Create() {
  Config lut_config = {
    NULL_SAMPLER_STATE,  // lut_sampler
    1.f,                 // strength
    1.f,                 // scaling
    config::type::SRGB,  // type_input
    config::type::SRGB,  // type_output
    0,                   // size
    float3(0, 0, 0),     // precompute
    true,                // tetrahedral
    0.f,                 // recolor
    1.f,                 // max_channel
    1.f                  // gamut_compress
  };
  return lut_config;
}
}  // namespace config

float3 CenterTexel(float3 color, float size) {
  float scale = (size - 1.f) / size;
  float offset = 1.f / (2.f * size);
  return mad(color, scale, offset);
}

#define LOAD_TEXEL_3D_FUNCTION_GENERATOR(TextureType)           \
  float3 LoadTexel(TextureType lut, int3 position, uint size) { \
    return lut.Load(uint4(position.rgb, 0)).rgb;                \
  }

#define LOAD_TEXEL_2D_FUNCTION_GENERATOR(TextureType)       \
  float3 LoadTexel(TextureType lut, uint2 uv) {             \
    return lut.Load(uint3(uv, 0)).rgb;                      \
  }                                                         \
                                                            \
  float3 LoadTexel(TextureType lut, uint3 uvw, uint size) { \
    uint2 uv = uint2(size * uvw.z + uvw.x, uvw.y);          \
    return LoadTexel(lut, uv);                              \
  }

#define GET_LUT_SIZE_3D_FUNCTION_GENERATOR(TextureType) \
  uint GetLutSize(TextureType lut) {                    \
    uint width, height, depth;                          \
    lut.GetDimensions(width, height, depth);            \
    return height;                                      \
  }

#define GET_LUT_SIZE_2D_FUNCTION_GENERATOR(TextureType) \
  uint GetLutSize(TextureType lut) {                    \
    uint width, height;                                 \
    lut.GetDimensions(width, height);                   \
    return height;                                      \
  }

#define SAMPLE_TEXTURE_TETRAHEDRAL_FUNCTION_GENERATOR(TextureType)         \
  float3 SampleTetrahedral(TextureType lut, float3 color, uint size = 0) { \
    /* Removed by compiler if specified */                                 \
    if (size == 0) {                                                       \
      size = GetLutSize(lut);                                              \
    }                                                                      \
                                                                           \
    /* Convert color to coordinates */                                     \
    float3 coordinates = saturate(color.rgb) * (float)(size - 1u);         \
                                                                           \
    /* Truncate to texel closest to origin */                              \
    int3 point0 = (int3)floor(coordinates);                                \
                                                                           \
    /* Fractional number */                                                \
    float3 fraction = frac(coordinates);                                   \
                                                                           \
    int3 offset0 = int3(0, 0, 0);                                          \
    /* Will correct to closest point */                                    \
    int3 offset1 = int3(0, 0, 0);                                          \
    /* Will correct to next closest point */                               \
    int3 offset2 = int3(1, 1, 1);                                          \
    /* Opposite from origin */                                             \
    int3 offset3 = int3(1, 1, 1);                                          \
                                                                           \
    /* Sort channels by distance from point (desc) */                      \
    float3 sorted;                                                         \
                                                                           \
    if (fraction.r > fraction.g) {                                         \
      if (fraction.g > fraction.b) {                                       \
        offset1.r = 1;                                                     \
        offset2.b = 0;                                                     \
        sorted = fraction.rgb;                                             \
      } else if (fraction.r > fraction.b) {                                \
        offset1.r = 1;                                                     \
        offset2.g = 0;                                                     \
        sorted = fraction.rbg;                                             \
      } else {                                                             \
        offset1.b = 1;                                                     \
        offset2.g = 0;                                                     \
        sorted = fraction.brg;                                             \
      }                                                                    \
    } else {                                                               \
      if (fraction.g <= fraction.b) {                                      \
        offset1.b = 1;                                                     \
        offset2.r = 0;                                                     \
        sorted = fraction.bgr;                                             \
      } else if (fraction.r >= fraction.b) {                               \
        offset1.g = 1;                                                     \
        offset2.b = 0;                                                     \
        sorted = fraction.grb;                                             \
      } else {                                                             \
        offset1.g = 1;                                                     \
        offset2.r = 0;                                                     \
        sorted = fraction.gbr;                                             \
      }                                                                    \
    }                                                                      \
                                                                           \
    /* Sample 4 points */                                                  \
    float3 texel0 = LoadTexel(lut, point0 + offset0, size);                \
    float3 texel1 = LoadTexel(lut, point0 + offset1, size);                \
    float3 texel2 = LoadTexel(lut, point0 + offset2, size);                \
    float3 texel3 = LoadTexel(lut, point0 + offset3, size);                \
                                                                           \
    /* Compute weights */                                                  \
    float weight0 = 1.f - sorted[0];                                       \
    float weight1 = sorted[0] - sorted[1];                                 \
    float weight2 = sorted[1] - sorted[2];                                 \
    float weight3 = sorted[2];                                             \
                                                                           \
    float3 value0 = texel0 * weight0;                                      \
    float3 value1 = texel1 * weight1;                                      \
    float3 value2 = texel2 * weight2;                                      \
    float3 value3 = texel3 * weight3;                                      \
                                                                           \
    return value0 + value1 + value2 + value3;                              \
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
    float3 position = CenterTexel(saturate(color), size);                            \
                                                                                     \
    return lut.SampleLevel(state, position, 0.0f).rgb;                               \
  }

#define SAMPLE_TEXTURE_2D_PRECOMPUTED_FUNCTION_GENERATOR(TextureType)                   \
  float3 Sample(TextureType lut, SamplerState state, float3 color, float3 precompute) { \
    color = saturate(color);                                                            \
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

#define SAMPLE_COLOR_3D_FUNCTION_GENERATOR(TextureType)                                                     \
  float3 SampleColor(float3 color, Config lut_config, TextureType lut_texture) {                            \
    float3 sampled_color;                                                                                   \
    float max_channel = 1.f;                                                                                \
    float gamut_compression_scale = 1.f;                                                                    \
    if (lut_config.max_channel > 0.f) {                                                                     \
      max_channel = renodx::math::Max(color.r, color.g, color.b, 1.f);                                      \
      color /= max_channel;                                                                                 \
    }                                                                                                       \
    if (lut_config.gamut_compress > 1.f) {                                                                  \
      float grayscale = renodx::color::y::from::BT709(color.rgb);                                           \
      gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(color.rgb, grayscale); \
      color = renodx::color::correct::GamutCompress(color, grayscale, gamut_compression_scale);             \
    }                                                                                                       \
    [branch]                                                                                                \
    if (lut_config.tetrahedral) {                                                                           \
      sampled_color = SampleTetrahedral(lut_texture, color, lut_config.size);                               \
    } else {                                                                                                \
      sampled_color = Sample(lut_texture, lut_config.lut_sampler, color.rgb, lut_config.size);              \
    }                                                                                                       \
    if (lut_config.gamut_compress > 1.f) {                                                                  \
      sampled_color = renodx::color::correct::GamutDecompress(sampled_color, gamut_compression_scale);      \
    }                                                                                                       \
    return sampled_color * max_channel;                                                                     \
  }

#define SAMPLE_COLOR_2D_FUNCTION_GENERATOR(TextureType)                                           \
  float3 SampleColor(float3 color, Config lut_config, TextureType lut_texture) {                  \
    if (lut_config.precompute.x == 0) {                                                           \
      if (lut_config.tetrahedral) {                                                               \
        return SampleTetrahedral(lut_texture, color, lut_config.size);                            \
      } else {                                                                                    \
        return Sample(lut_texture, lut_config.lut_sampler, color.rgb, lut_config.size);           \
      }                                                                                           \
    } else {                                                                                      \
      if (lut_config.tetrahedral) {                                                               \
        return SampleTetrahedral(lut_texture, color, (uint)lut_config.precompute.z + 1u);         \
      } else {                                                                                    \
        return Sample(lut_texture, lut_config.lut_sampler, color.rgb, lut_config.precompute.xyz); \
      }                                                                                           \
    }                                                                                             \
  }

LOAD_TEXEL_3D_FUNCTION_GENERATOR(Texture3D<float4>);
LOAD_TEXEL_3D_FUNCTION_GENERATOR(Texture3D<float3>);
LOAD_TEXEL_2D_FUNCTION_GENERATOR(Texture2D<float4>);
LOAD_TEXEL_2D_FUNCTION_GENERATOR(Texture2D<float3>);
GET_LUT_SIZE_3D_FUNCTION_GENERATOR(Texture3D<float4>);
GET_LUT_SIZE_3D_FUNCTION_GENERATOR(Texture3D<float3>);
GET_LUT_SIZE_2D_FUNCTION_GENERATOR(Texture2D<float4>);
GET_LUT_SIZE_2D_FUNCTION_GENERATOR(Texture2D<float3>);
SAMPLE_TEXTURE_TETRAHEDRAL_FUNCTION_GENERATOR(Texture3D<float4>);
SAMPLE_TEXTURE_TETRAHEDRAL_FUNCTION_GENERATOR(Texture3D<float3>);
SAMPLE_TEXTURE_TETRAHEDRAL_FUNCTION_GENERATOR(Texture2D<float4>);
SAMPLE_TEXTURE_TETRAHEDRAL_FUNCTION_GENERATOR(Texture2D<float3>);
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

#undef GET_LUT_SIZE_2D_FUNCTION_GENERATOR
#undef GET_LUT_SIZE_3D_FUNCTION_GENERATOR
#undef LOAD_TEXEL_2D_FUNCTION_GENERATOR
#undef LOAD_TEXEL_3D_FUNCTION_GENERATOR
#undef SAMPLE_TEXTURE_TETRAHEDRAL_FUNCTION_GENERATOR
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
  float fraction = z_position - z_integer;

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

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  // Add back from mid-gray to 1.f
  const float highlights_length = 1.f - mid_gray_average;
  const float highlights_stop = 1.f - min(neutral_gamma.r, min(neutral_gamma.g, neutral_gamma.b));
  const float3 ceiling_add = removed_gamma * (max(0, highlights_length - highlights_stop) / highlights_length);

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove) + ceiling_add;
  return unclamped_gamma;
}

float3 RecolorUnclamped(float3 original_linear, float3 unclamped_linear, float strength = 1.f) {
  const float3 original_perceptual = renodx::color::oklab::from::BT709(original_linear);

  // Hue correction
  float3 retinted_perceptual = renodx::color::oklab::from::BT709(unclamped_linear);
  retinted_perceptual[0] = max(0, retinted_perceptual[0]);
  retinted_perceptual[1] = original_perceptual[1];
  retinted_perceptual[2] = original_perceptual[2];

  // Blend values
  retinted_perceptual = lerp(original_perceptual, retinted_perceptual, strength);

  float3 retinted_linear = renodx::color::bt709::from::OkLab(retinted_perceptual);
  retinted_linear = renodx::color::bt709::clamp::BT2020(retinted_linear);
  return retinted_linear;
}

float3 ConvertInput(float3 color, Config lut_config) {
  if (lut_config.type_input == config::type::SRGB) {
    color = renodx::color::srgb::EncodeSafe(color);
  } else if (lut_config.type_input == config::type::GAMMA_2_4) {
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (lut_config.type_input == config::type::GAMMA_2_2) {
    color = renodx::color::gamma::EncodeSafe(color);
  } else if (lut_config.type_input == config::type::GAMMA_2_0) {
    color = renodx::math::SignSqrt(color);
  } else if (lut_config.type_input == config::type::ARRI_C800) {
    color = renodx::color::arri::logc::c800::Encode(max(0, color));
  } else if (lut_config.type_input == config::type::ARRI_C1000) {
    color = renodx::color::arri::logc::c1000::Encode(max(0, color));
  } else if (lut_config.type_input == config::type::ARRI_C800_NO_CUT) {
    color = renodx::color::arri::logc::c800::Encode(max(0, color), false);
  } else if (lut_config.type_input == config::type::ARRI_C1000_NO_CUT) {
    color = renodx::color::arri::logc::c1000::Encode(max(0, color), false);
  } else if (lut_config.type_input == config::type::PQ) {
    float3 bt2020 = renodx::color::bt2020::from::BT709(color);
    color = renodx::color::pq::Encode(bt2020, 100.f);
  } else if (lut_config.type_input == config::type::ACES_CCT) {
    float3 ap1 = renodx::color::ap1::from::BT709(color);
    color = renodx::color::acescct::Encode(ap1);
  }
  return color;
}

float3 LinearOutput(float3 color, Config lut_config) {
  if (lut_config.type_output == config::type::SRGB) {
    color = renodx::color::srgb::DecodeSafe(color);
  } else if (lut_config.type_output == config::type::GAMMA_2_4) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (lut_config.type_output == config::type::GAMMA_2_2) {
    color = renodx::color::gamma::DecodeSafe(color);
  } else if (lut_config.type_output == config::type::GAMMA_2_0) {
    color = renodx::math::CopySign(color * color, color);
  } else if (lut_config.type_output == config::type::ARRI_C800) {
    color = renodx::math::CopySign(renodx::color::arri::logc::c800::Decode(abs(color)), color);
  } else if (lut_config.type_output == config::type::ARRI_C1000) {
    color = renodx::math::CopySign(renodx::color::arri::logc::c1000::Decode(abs(color)), color);
  } else if (lut_config.type_output == config::type::ARRI_C800_NO_CUT) {
    color = renodx::math::CopySign(renodx::color::arri::logc::c800::Decode(abs(color), false), color);
  } else if (lut_config.type_output == config::type::ARRI_C1000_NO_CUT) {
    color = renodx::math::CopySign(renodx::color::arri::logc::c1000::Decode(abs(color), false), color);
  } else if (lut_config.type_output == config::type::PQ) {
    color = renodx::color::pq::Decode(color, 100.f);
    color = renodx::color::bt709::from::BT2020(color);
  } else if (lut_config.type_output == config::type::ACES_CCT) {
    color = renodx::color::acescct::Decode(color);
    color = renodx::color::bt709::from::AP1(color);
  }
  return color;
}

float3 GammaOutput(float3 lut_output_color, Config lut_config) {
  if (
      lut_config.type_output == config::type::SRGB
      || lut_config.type_output == config::type::GAMMA_2_4
      || lut_config.type_output == config::type::GAMMA_2_2
      || lut_config.type_output == config::type::GAMMA_2_0) {
    return lut_output_color;
  } else {
    float3 linear_color = LinearOutput(lut_output_color, lut_config);
    return renodx::color::srgb::Encode(max(0, linear_color));
  }
}

float3 GammaInput(float3 color_input, float3 color_input_converted, Config lut_config) {
  if (
      lut_config.type_input == config::type::SRGB
      || lut_config.type_input == config::type::GAMMA_2_4
      || lut_config.type_input == config::type::GAMMA_2_2
      || lut_config.type_input == config::type::GAMMA_2_0) {
    return color_input_converted;
  } else {
    return renodx::color::srgb::Encode(max(0, color_input));
  }
}

float3 LinearUnclampedOutput(float3 color, Config lut_config) {
  if (lut_config.type_output == config::type::GAMMA_2_4) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (lut_config.type_output == config::type::GAMMA_2_2) {
    color = renodx::color::gamma::DecodeSafe(color);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  return color;
}

float3 RestoreSaturationLoss(float3 color_input, float3 color_output, Config lut_config) {
  float3 clamped = color_input;
  if (lut_config.type_input == config::type::SRGB) {
    clamped = saturate(clamped);
  } else if (lut_config.type_input == config::type::GAMMA_2_4) {
    clamped = saturate(clamped);
  } else if (lut_config.type_input == config::type::GAMMA_2_2) {
    clamped = saturate(clamped);
  } else if (lut_config.type_input == config::type::GAMMA_2_0) {
    clamped = saturate(clamped);
  } else if (lut_config.type_input == config::type::ARRI_C800) {
    clamped = max(0, clamped);
  } else if (lut_config.type_input == config::type::ARRI_C1000) {
    clamped = max(0, clamped);
  } else if (lut_config.type_input == config::type::ARRI_C800_NO_CUT) {
    clamped = max(0, clamped);
  } else if (lut_config.type_input == config::type::ARRI_C1000_NO_CUT) {
    clamped = max(0, clamped);
  } else if (lut_config.type_input == config::type::PQ) {
    clamped = max(0, renodx::color::bt709::from::BT2020(clamped));
  } else if (lut_config.type_input == config::type::ACES_CCT) {
    clamped = max(0, renodx::color::bt709::from::AP1(clamped));
  }

  float3 perceptual_in = renodx::color::oklab::from::BT709(color_input);
  float3 perceptual_clamped = renodx::color::oklab::from::BT709(clamped);
  float3 perceptual_out = renodx::color::oklab::from::BT709(color_output);

  float chroma_in = distance(perceptual_in.yz, 0);
  float chroma_clamped = distance(perceptual_clamped.yz, 0);
  float chroma_out = distance(perceptual_out.yz, 0);
  float chroma_loss = renodx::math::DivideSafe(chroma_in, chroma_clamped, 0.f);
  float chroma_new = chroma_out * chroma_loss;

  perceptual_out.yz *= lerp(1.f, renodx::math::DivideSafe(chroma_new, chroma_out, 1.f), lut_config.recolor);

  return renodx::color::bt709::from::OkLab(perceptual_out);
}

#define SAMPLE_FUNCTION_GENERATOR(textureType)                                                 \
  float3 Sample(textureType lut_texture, Config lut_config, float3 color_input) {              \
    float3 lutInputColor = ConvertInput(color_input, lut_config);                              \
    float3 lutOutputColor = SampleColor(lutInputColor, lut_config, lut_texture);               \
    float3 color_output = LinearOutput(lutOutputColor, lut_config);                            \
    [branch]                                                                                   \
    if (lut_config.scaling != 0.f) {                                                           \
      float3 lutBlack = SampleColor(ConvertInput(0, lut_config), lut_config, lut_texture);     \
      float3 lutMid = SampleColor(ConvertInput(0.18f, lut_config), lut_config, lut_texture);   \
      float3 lutWhite = SampleColor(ConvertInput(1.f, lut_config), lut_config, lut_texture);   \
      float3 unclamped_gamma = Unclamp(                                                        \
          GammaOutput(lutOutputColor, lut_config),                                             \
          GammaOutput(lutBlack, lut_config),                                                   \
          GammaOutput(lutMid, lut_config),                                                     \
          GammaOutput(lutWhite, lut_config),                                                   \
          GammaInput(color_input, lutInputColor, lut_config));                                 \
      float3 unclamped_linear = LinearUnclampedOutput(unclamped_gamma, lut_config);            \
      float3 recolored = RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling); \
      color_output = recolored;                                                                \
    } else {                                                                                   \
    }                                                                                          \
    if (lut_config.recolor != 0.f) {                                                           \
      color_output = RestoreSaturationLoss(color_input, color_output, lut_config);             \
    }                                                                                          \
                                                                                               \
    return lerp(color_input, color_output, lut_config.strength);                               \
  }

SAMPLE_FUNCTION_GENERATOR(Texture3D<float4>);
SAMPLE_FUNCTION_GENERATOR(Texture3D<float3>);
SAMPLE_FUNCTION_GENERATOR(Texture2D<float4>);
SAMPLE_FUNCTION_GENERATOR(Texture2D<float3>);

#undef SAMPLE_FUNCTION_GENERATOR

// Deprecated
#define SAMPLE_DEPRECATED_FUNCTION_GENERATOR(textureType)                         \
  float3 Sample(float3 color_input, Config lut_config, textureType lut_texture) { \
    return Sample(lut_texture, lut_config, color_input);                          \
  }

SAMPLE_DEPRECATED_FUNCTION_GENERATOR(Texture3D<float4>);
SAMPLE_DEPRECATED_FUNCTION_GENERATOR(Texture3D<float3>);
SAMPLE_DEPRECATED_FUNCTION_GENERATOR(Texture2D<float4>);
SAMPLE_DEPRECATED_FUNCTION_GENERATOR(Texture2D<float3>);

#undef SAMPLE_DEPRECATED_FUNCTION_GENERATOR
}  // namespace lut
}  // namespace renodx

#endif  // SRC_SHADERS_LUT_HLSL_