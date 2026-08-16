/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <bit>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <optional>
#include <span>
#include <string_view>
#include <type_traits>

namespace renodx::games::detroitbecomehuman::taa_contract {

inline constexpr std::uint32_t kShaderCrc = 0xB5506A45u;
inline constexpr std::array<std::uint32_t, 3u> kWorkgroupSize = {8u, 8u, 1u};
inline constexpr std::uint32_t kConstantsBinding = 52u;
inline constexpr std::size_t kConstantsSize = 496u;
inline constexpr std::uint32_t kInactiveSampledBinding9 = 9u;
inline constexpr std::uint32_t kExposureTextureChannel = 1u;

// Exact 0xB5506A45 SPIR-V behavior:
//   previous_uv = current_uv - MotionVectorTex.xy
// so Detroit stores current-minus-previous displacement in normalized UV
// space. DLSS expects current-to-previous displacement in render pixels.
// The shader also selects the greatest neighboring depth as the foreground,
// proving that near depth is greater than far depth for this pass.
inline constexpr bool kDepthIsInverted = true;

struct Float2 {
  float x;
  float y;

  bool operator==(const Float2&) const = default;
};

// Detroit b52 stores the current projection jitter in pixel space. Keep the
// captured convention unchanged while temporal reset/lifecycle is tested in
// isolation.
[[nodiscard]] constexpr Float2 GetNgxJitterOffset(
    float detroit_jitter_x,
    float detroit_jitter_y) noexcept {
  return {detroit_jitter_x, detroit_jitter_y};
}

[[nodiscard]] constexpr Float2 GetNgxMotionVectorScale(
    std::uint32_t render_width,
    std::uint32_t render_height) noexcept {
  return {
      -static_cast<float>(render_width),
      -static_cast<float>(render_height),
  };
}

struct SampledBinding {
  std::uint32_t binding;
  std::string_view shader_name;

  bool operator==(const SampledBinding&) const = default;
};

struct StorageBinding {
  std::uint32_t binding;
  std::string_view shader_name;
  std::string_view storage_format;

  bool operator==(const StorageBinding&) const = default;
};

inline constexpr std::array<SampledBinding, 8u> kRequiredSampledBindings = {{
    {0u, "PrevAADepthTex"},
    {1u, "CurrColorTex"},
    {2u, "PrevColorTex"},
    {3u, "CurrZBuffer"},
    {4u, "MotionVectorTex"},
    {5u, "AvgLumMap"},
    {6u, "TAAFlagsTexture"},
    {7u, "PrevSpeedAndFlagsTex"},
}};

inline constexpr std::array<StorageBinding, 4u> kRequiredStorageBindings = {{
    {16u, "OutColorPass", "r32ui"},
    {17u, "OutAADepth", "r16f"},
    {18u, "OutPrevSpeedAndFlagsTex", "r16ui"},
    {19u, "HalfResContours", "r8ui"},
}};

[[nodiscard]] constexpr bool IsRequiredSampledBinding(
    std::uint32_t binding) noexcept {
  for (const auto& candidate : kRequiredSampledBindings) {
    if (candidate.binding == binding) return true;
  }
  return false;
}

struct Float4 {
  float x;
  float y;
  float z;
  float w;

  bool operator==(const Float4&) const = default;
};

struct Int4 {
  std::int32_t x;
  std::int32_t y;
  std::int32_t z;
  std::int32_t w;

  bool operator==(const Int4&) const = default;
};

// Reflection establishes two 128-byte matrix regions but not their runtime
// meaning. Preserve their four-byte object representations as raw words.
using RawMatrix = std::array<std::uint32_t, 32u>;

struct Constants {
  std::array<RawMatrix, 2u> matrices;
  Float4 proj_setup;
  Float4 render_target_size_inv;
  Float4 src_texture_size_inv;
  Int4 viewport_origin_size;
  Int4 viewport_top_left_minus_one;
  Float4 viewport_origin_top_left_upsampled;
  float history;
  float responsive;
  float rain;
  float disocclusion;
  Float4 dejitter0;
  Float4 dejitter1;
  Float4 pixel_to_clip;
  float contour_depth;
  float min_exposure;
  float prev_exposure_comp;
  std::uint32_t padding_428;
  float jitter_x;
  float jitter_y;
  float upsampling;
  float inv_upsampling;
  Float4 resampled_uv_scale;
  std::uint32_t debug_frame;
  std::uint32_t contour_enable;
  float prev_upsampling;
  std::uint32_t padding_476;
  std::uint32_t debug_options;
  std::uint32_t features;
  std::uint32_t debug_coord_x;
  std::uint32_t debug_coord_y;
};

static_assert(sizeof(float) == 4u);
static_assert(std::numeric_limits<float>::is_iec559);
static_assert(std::endian::native == std::endian::little);
static_assert(sizeof(Float4) == 16u);
static_assert(sizeof(Int4) == 16u);
static_assert(sizeof(RawMatrix) == 128u);
static_assert(std::is_standard_layout_v<Constants>);
static_assert(std::is_trivially_copyable_v<Constants>);
static_assert(alignof(Constants) == alignof(std::uint32_t));
static_assert(sizeof(Constants) == kConstantsSize);

static_assert(offsetof(Constants, matrices) == 0u);
static_assert(offsetof(Constants, proj_setup) == 256u);
static_assert(offsetof(Constants, render_target_size_inv) == 272u);
static_assert(offsetof(Constants, src_texture_size_inv) == 288u);
static_assert(offsetof(Constants, viewport_origin_size) == 304u);
static_assert(offsetof(Constants, viewport_top_left_minus_one) == 320u);
static_assert(offsetof(Constants, viewport_origin_top_left_upsampled) == 336u);
static_assert(offsetof(Constants, history) == 352u);
static_assert(offsetof(Constants, responsive) == 356u);
static_assert(offsetof(Constants, rain) == 360u);
static_assert(offsetof(Constants, disocclusion) == 364u);
static_assert(offsetof(Constants, dejitter0) == 368u);
static_assert(offsetof(Constants, dejitter1) == 384u);
static_assert(offsetof(Constants, pixel_to_clip) == 400u);
static_assert(offsetof(Constants, contour_depth) == 416u);
static_assert(offsetof(Constants, min_exposure) == 420u);
static_assert(offsetof(Constants, prev_exposure_comp) == 424u);
static_assert(offsetof(Constants, padding_428) == 428u);
static_assert(offsetof(Constants, jitter_x) == 432u);
static_assert(offsetof(Constants, jitter_y) == 436u);
static_assert(offsetof(Constants, upsampling) == 440u);
static_assert(offsetof(Constants, inv_upsampling) == 444u);
static_assert(offsetof(Constants, resampled_uv_scale) == 448u);
static_assert(offsetof(Constants, debug_frame) == 464u);
static_assert(offsetof(Constants, contour_enable) == 468u);
static_assert(offsetof(Constants, prev_upsampling) == 472u);
static_assert(offsetof(Constants, padding_476) == 476u);
static_assert(offsetof(Constants, debug_options) == 480u);
static_assert(offsetof(Constants, features) == 484u);
static_assert(offsetof(Constants, debug_coord_x) == 488u);
static_assert(offsetof(Constants, debug_coord_y) == 492u);

struct Plausibility {
  bool all_float_candidates_finite = false;
  bool size_candidates_positive = false;
  bool scale_candidates_positive = false;

  [[nodiscard]] constexpr bool IsPlausible() const noexcept {
    return all_float_candidates_finite
           && size_candidates_positive
           && scale_candidates_positive;
  }
};

struct DecodedConstants {
  Constants raw;
  Plausibility plausibility;
};

struct NgxFrameParameters {
  float jitter_x = 0.f;
  float jitter_y = 0.f;
  Float2 motion_vector_scale = {};
  float pre_exposure = 1.f;
  std::uint32_t reset = 0u;
  bool constants_valid = false;
  bool jitter_valid = false;
  bool dimensions_valid = false;
  bool viewport_valid = false;
  bool history_valid = false;
  bool scale_valid = false;

  [[nodiscard]] constexpr bool IsValid() const noexcept {
    return constants_valid && jitter_valid && dimensions_valid
           && viewport_valid && history_valid && scale_valid;
  }
};

[[nodiscard]] inline bool NearlyEqual(
    float observed,
    float expected,
    float relative_tolerance = 0.0025f) noexcept {
  if (!std::isfinite(observed) || !std::isfinite(expected)) return false;
  const float scale = std::max(1.f, std::abs(expected));
  return std::abs(observed - expected) <= relative_tolerance * scale;
}

// Converts only the fields whose offsets and meanings are established by the
// exact 0xB5506A45 SPIR-V and the live Build 12158144 b52 capture. Raw matrix
// words and debug/padding words are intentionally excluded: their bit patterns
// are not DLSS inputs and must not invalidate otherwise well-formed constants.
[[nodiscard]] inline NgxFrameParameters BuildNgxFrameParameters(
    const Constants& constants,
    std::uint32_t render_width,
    std::uint32_t render_height,
    std::uint32_t output_width,
    std::uint32_t output_height) noexcept {
  const auto ngx_jitter =
      GetNgxJitterOffset(constants.jitter_x, constants.jitter_y);
  NgxFrameParameters result = {
      .jitter_x = ngx_jitter.x,
      .jitter_y = ngx_jitter.y,
      .motion_vector_scale = GetNgxMotionVectorScale(render_width, render_height),
      .pre_exposure = 1.f,
  };
  if (render_width == 0u || render_height == 0u || output_width == 0u
      || output_height == 0u) {
    return result;
  }

  const float render_width_f = static_cast<float>(render_width);
  const float render_height_f = static_cast<float>(render_height);
  const float output_width_f = static_cast<float>(output_width);
  const float output_height_f = static_cast<float>(output_height);
  const float extent_scale_x =
      static_cast<float>(output_width) / render_width_f;
  const float extent_scale_y =
      static_cast<float>(output_height) / render_height_f;

  result.constants_valid =
      std::isfinite(constants.render_target_size_inv.x)
      && std::isfinite(constants.render_target_size_inv.y)
      && std::isfinite(constants.render_target_size_inv.z)
      && std::isfinite(constants.render_target_size_inv.w)
      && std::isfinite(constants.src_texture_size_inv.x)
      && std::isfinite(constants.src_texture_size_inv.y)
      && std::isfinite(constants.src_texture_size_inv.z)
      && std::isfinite(constants.src_texture_size_inv.w)
      && std::isfinite(constants.upsampling)
      && std::isfinite(constants.inv_upsampling)
      && std::isfinite(constants.prev_upsampling)
      && std::isfinite(constants.history);
  result.jitter_valid =
      std::isfinite(constants.jitter_x) && std::isfinite(constants.jitter_y)
      && constants.jitter_x >= -0.5f && constants.jitter_x <= 0.5f
      && constants.jitter_y >= -0.5f && constants.jitter_y <= 0.5f;
  result.dimensions_valid =
      NearlyEqual(constants.render_target_size_inv.x, output_width_f)
      && NearlyEqual(constants.render_target_size_inv.y, output_height_f)
      && NearlyEqual(constants.render_target_size_inv.z, 1.f / output_width_f)
      && NearlyEqual(constants.render_target_size_inv.w, 1.f / output_height_f)
      && NearlyEqual(constants.src_texture_size_inv.x, render_width_f)
      && NearlyEqual(constants.src_texture_size_inv.y, render_height_f)
      && NearlyEqual(constants.src_texture_size_inv.z, 1.f / render_width_f)
      && NearlyEqual(constants.src_texture_size_inv.w, 1.f / render_height_f);
  result.viewport_valid =
      output_width <= static_cast<std::uint32_t>(std::numeric_limits<std::int32_t>::max())
      && output_height
             <= static_cast<std::uint32_t>(std::numeric_limits<std::int32_t>::max())
      && constants.viewport_origin_size.x == 0
      && constants.viewport_origin_size.y == 0
      // Build 12158144 keeps this viewport at the full TAA output extent even
      // when src_texture_size and the current color/depth/MV resources use the
      // reduced render extent.
      && constants.viewport_origin_size.z == static_cast<std::int32_t>(output_width)
      && constants.viewport_origin_size.w == static_cast<std::int32_t>(output_height);
  result.history_valid =
      constants.history >= 0.f && constants.history <= 1.f;
  result.scale_valid =
      // The exact runtime capture keeps these two temporal tuning fields at
      // 1/1 while the real SR factor is expressed by the independently
      // verified output and source extents. Require a sane reciprocal pair,
      // but never reinterpret it as output/render scaling.
      NearlyEqual(extent_scale_x, extent_scale_y, 0.01f)
      && constants.upsampling > 0.f && constants.inv_upsampling > 0.f
      && NearlyEqual(
          constants.upsampling * constants.inv_upsampling, 1.f, 0.01f);
  result.reset =
      constants.history <= 0.001f
              || constants.prev_upsampling <= 0.f
              || !NearlyEqual(constants.prev_upsampling, constants.upsampling, 0.01f)
          ? 1u
          : 0u;
  return result;
}

[[nodiscard]] inline Plausibility CheckPlausibility(
    const Constants& constants) noexcept {
  Plausibility result = {
      .all_float_candidates_finite = true,
      .size_candidates_positive =
          constants.render_target_size_inv.x > 0.f
          && constants.render_target_size_inv.y > 0.f
          && constants.src_texture_size_inv.x > 0.f
          && constants.src_texture_size_inv.y > 0.f
          && constants.viewport_origin_size.z > 0
          && constants.viewport_origin_size.w > 0,
      .scale_candidates_positive =
          constants.upsampling > 0.f
          && constants.inv_upsampling > 0.f
          && constants.resampled_uv_scale.x > 0.f
          && constants.resampled_uv_scale.y > 0.f,
  };

  for (const auto& matrix : constants.matrices) {
    for (const auto word : matrix) {
      result.all_float_candidates_finite &=
          std::isfinite(std::bit_cast<float>(word));
    }
  }

  const std::array<const Float4*, 8u> vectors = {
      &constants.proj_setup,
      &constants.render_target_size_inv,
      &constants.src_texture_size_inv,
      &constants.viewport_origin_top_left_upsampled,
      &constants.dejitter0,
      &constants.dejitter1,
      &constants.pixel_to_clip,
      &constants.resampled_uv_scale,
  };
  for (const auto* vector : vectors) {
    result.all_float_candidates_finite &=
        std::isfinite(vector->x)
        && std::isfinite(vector->y)
        && std::isfinite(vector->z)
        && std::isfinite(vector->w);
  }

  const std::array<float, 12u> scalars = {
      constants.history,
      constants.responsive,
      constants.rain,
      constants.disocclusion,
      constants.contour_depth,
      constants.min_exposure,
      constants.prev_exposure_comp,
      constants.jitter_x,
      constants.jitter_y,
      constants.upsampling,
      constants.inv_upsampling,
      constants.prev_upsampling,
  };
  for (const auto value : scalars) {
    result.all_float_candidates_finite &= std::isfinite(value);
  }
  return result;
}

// This is a structural decoder only. Plausibility is a heuristic over raw
// values and deliberately cannot establish runtime dimensions, semantics, or
// any runtime verification flag.
[[nodiscard]] inline std::optional<DecodedConstants> DecodeConstants(
    std::span<const std::byte> payload) noexcept {
  if (payload.size() != kConstantsSize) return std::nullopt;

  DecodedConstants decoded = {};
  std::memcpy(&decoded.raw, payload.data(), sizeof(decoded.raw));
  decoded.plausibility = CheckPlausibility(decoded.raw);
  return decoded;
}

static_assert(!IsRequiredSampledBinding(kInactiveSampledBinding9));

}  // namespace renodx::games::detroitbecomehuman::taa_contract
