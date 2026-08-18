/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <limits>

namespace renodx::games::detroitbecomehuman::retinal {

inline constexpr float kDefaultHorizontalScreenAngleDegrees = 70.f;
inline constexpr float kMinimumHorizontalScreenAngleDegrees = 30.f;
inline constexpr float kMaximumHorizontalScreenAngleDegrees = 120.f;
inline constexpr float kMaximumEccentricityDegrees = 120.f;
inline constexpr float kMaximumSigmaPixels = 8.f;
inline constexpr std::uint32_t kMaximumKernelRadius = 32u;

inline constexpr float kPi = 3.14159265358979323846f;
inline constexpr float kRadiansToDegrees = 180.f / kPi;
inline constexpr float kDegreesToRadians = kPi / 180.f;
inline constexpr float kSqrtTwo = 1.4142135623730950488f;
inline constexpr float kSqrtThree = 1.7320508075688772935f;
// Gaussian MTF is 0.5 at the selected cutoff frequency.
inline constexpr float kGaussianHalfMtfScale = 0.18739062512927757f;

inline constexpr float kWatsonPeakConeDensityPerSquareDegree = 14804.6f;
inline constexpr float kWatsonMidgetFractionScaleDegrees = 41.03f;

struct Float2 {
  float x = 0.f;
  float y = 0.f;
};

struct Float3 {
  float x = 0.f;
  float y = 0.f;
  float z = 1.f;
};

enum class Meridian : std::uint32_t {
  kTemporal = 0u,
  kSuperior = 1u,
  kNasal = 2u,
  kInferior = 3u,
};

struct MeridianParameters {
  float mixture;
  float rational_scale_degrees;
  float exponential_scale_degrees;
};

inline constexpr std::array<MeridianParameters, 4u> kWatsonMeridianParameters = {{
    {0.9851f, 1.058f, 22.14f},
    {0.9935f, 1.035f, 16.35f},
    {0.9729f, 1.084f, 7.633f},
    {0.9960f, 0.9932f, 12.13f},
}};

struct FilterSample {
  float horizontal_eccentricity_degrees = 0.f;
  float vertical_eccentricity_degrees = 0.f;
  float eccentricity_degrees = 0.f;
  float retinal_nyquist_cycles_per_degree = 65.37f;
  float horizontal_pixels_per_degree = 0.f;
  float vertical_pixels_per_degree = 0.f;
  float horizontal_sigma_pixels = 0.f;
  float vertical_sigma_pixels = 0.f;
};

[[nodiscard]] inline float FiniteOr(float value, float fallback) noexcept {
  return std::isfinite(value) ? value : fallback;
}

[[nodiscard]] inline float SanitizeHorizontalScreenAngle(float degrees) noexcept {
  return std::clamp(
      FiniteOr(degrees, kDefaultHorizontalScreenAngleDegrees),
      kMinimumHorizontalScreenAngleDegrees,
      kMaximumHorizontalScreenAngleDegrees);
}

[[nodiscard]] inline Float2 SanitizeFixationUv(Float2 fixation_uv) noexcept {
  return {
      std::clamp(FiniteOr(fixation_uv.x, 0.5f), 0.f, 1.f),
      std::clamp(FiniteOr(fixation_uv.y, 0.5f), 0.f, 1.f),
  };
}

[[nodiscard]] inline float SanitizeFixationBlend(float blend) noexcept {
  return std::clamp(FiniteOr(blend, 0.f), 0.f, 1.f);
}

[[nodiscard]] inline const MeridianParameters& GetMeridianParameters(
    Meridian meridian) noexcept {
  const auto index = std::min(
      static_cast<std::uint32_t>(meridian),
      static_cast<std::uint32_t>(kWatsonMeridianParameters.size() - 1u));
  return kWatsonMeridianParameters[index];
}

// Watson (2014), Equation 8. Density is for all midget RGC receptive fields.
[[nodiscard]] inline float ComputeMidgetDensityPerSquareDegree(
    float eccentricity_degrees,
    Meridian meridian) noexcept {
  const float r = std::clamp(
      FiniteOr(eccentricity_degrees, 0.f), 0.f, kMaximumEccentricityDegrees);
  const auto& parameters = GetMeridianParameters(meridian);
  const float midget_fraction = 1.f / (1.f + r / kWatsonMidgetFractionScaleDegrees);
  const float rational = 1.f + r / parameters.rational_scale_degrees;
  const float meridian_density =
      parameters.mixture / (rational * rational)
      + (1.f - parameters.mixture)
            * std::exp(-r / parameters.exponential_scale_degrees);
  const float density = 2.f * kWatsonPeakConeDensityPerSquareDegree
                        * midget_fraction * meridian_density;
  return std::max(FiniteOr(density, 1.f), 1.f);
}

// Equations 9 and A4, with sqrt(2) for one on- or off-center mosaic.
[[nodiscard]] inline float ComputeOnOffMosaicSpacingDegrees(
    float eccentricity_degrees,
    Meridian meridian) noexcept {
  const float density = ComputeMidgetDensityPerSquareDegree(
      eccentricity_degrees, meridian);
  const float spacing = std::sqrt(4.f / (kSqrtThree * density));
  return std::max(FiniteOr(spacing, 1.f), std::numeric_limits<float>::min());
}

// Watson Equation 15, using visual-field coordinates. Positive horizontal
// eccentricity denotes the temporal visual field for the evaluated eye.
[[nodiscard]] inline float ComputeMonocularSpacingDegrees(
    float horizontal_eccentricity_degrees,
    float vertical_eccentricity_degrees) noexcept {
  const float x = std::clamp(
      FiniteOr(horizontal_eccentricity_degrees, 0.f),
      -kMaximumEccentricityDegrees,
      kMaximumEccentricityDegrees);
  const float y = std::clamp(
      FiniteOr(vertical_eccentricity_degrees, 0.f),
      -kMaximumEccentricityDegrees,
      kMaximumEccentricityDegrees);
  const float r = std::min(std::hypot(x, y), kMaximumEccentricityDegrees);
  if (r <= std::numeric_limits<float>::epsilon()) {
    return ComputeOnOffMosaicSpacingDegrees(0.f, Meridian::kTemporal);
  }

  const Meridian horizontal_meridian = x >= 0.f
                                           ? Meridian::kTemporal
                                           : Meridian::kNasal;
  const Meridian vertical_meridian = y >= 0.f
                                         ? Meridian::kSuperior
                                         : Meridian::kInferior;
  const float horizontal_spacing = ComputeOnOffMosaicSpacingDegrees(
      r, horizontal_meridian);
  const float vertical_spacing = ComputeOnOffMosaicSpacingDegrees(
      r, vertical_meridian);
  const float spacing = std::sqrt(
                            x * x * horizontal_spacing * horizontal_spacing
                            + y * y * vertical_spacing * vertical_spacing)
                        / r;
  return std::max(
      FiniteOr(spacing, horizontal_spacing),
      std::numeric_limits<float>::min());
}

// Watson Equation 16 combines corresponding monocular densities.
[[nodiscard]] inline float ComputeBinocularSpacingDegrees(
    float horizontal_eccentricity_degrees,
    float vertical_eccentricity_degrees) noexcept {
  const float right_eye_spacing = ComputeMonocularSpacingDegrees(
      horizontal_eccentricity_degrees, vertical_eccentricity_degrees);
  const float left_eye_spacing = ComputeMonocularSpacingDegrees(
      -horizontal_eccentricity_degrees, vertical_eccentricity_degrees);
  const float right_squared = right_eye_spacing * right_eye_spacing;
  const float left_squared = left_eye_spacing * left_eye_spacing;
  const float denominator = std::max(
      right_squared + left_squared, std::numeric_limits<float>::min());
  const float spacing = kSqrtTwo * std::sqrt((right_squared * left_squared) / denominator);
  return std::max(
      FiniteOr(spacing, right_eye_spacing),
      std::numeric_limits<float>::min());
}

// Watson Appendix 5, Equation A3.
[[nodiscard]] inline float ComputeRetinalNyquistCyclesPerDegree(
    float horizontal_eccentricity_degrees,
    float vertical_eccentricity_degrees) noexcept {
  const float spacing = ComputeBinocularSpacingDegrees(
      horizontal_eccentricity_degrees, vertical_eccentricity_degrees);
  const float nyquist = 1.f / (kSqrtThree * spacing);
  return std::clamp(FiniteOr(nyquist, 0.f), 0.f, 65.5f);
}

[[nodiscard]] inline float ComputeAdditionalGaussianSigmaPixels(
    float retinal_nyquist_cycles_per_degree,
    float pixels_per_degree,
    float fixation_blend,
    float maximum_sigma_pixels = kMaximumSigmaPixels) noexcept {
  const float retinal_nyquist = FiniteOr(
      retinal_nyquist_cycles_per_degree, 0.f);
  const float ppd = FiniteOr(pixels_per_degree, 0.f);
  const float blend = SanitizeFixationBlend(fixation_blend);
  const float sigma_limit = std::clamp(
      FiniteOr(maximum_sigma_pixels, kMaximumSigmaPixels),
      0.f,
      kMaximumSigmaPixels);
  if (retinal_nyquist <= 0.f || ppd <= 0.f || blend <= 0.f
      || sigma_limit <= 0.f) {
    return 0.f;
  }

  const float display_nyquist = ppd * 0.5f;
  const float inverse_retinal_squared =
      1.f / (retinal_nyquist * retinal_nyquist);
  const float inverse_display_squared =
      1.f / (display_nyquist * display_nyquist);
  const float added_variance_frequency = std::max(
      inverse_retinal_squared - inverse_display_squared, 0.f);
  const float sigma = kGaussianHalfMtfScale * ppd
                      * std::sqrt(added_variance_frequency)
                      * std::sqrt(blend);
  return std::clamp(FiniteOr(sigma, 0.f), 0.f, sigma_limit);
}

[[nodiscard]] inline Float3 Normalize(Float3 value) noexcept {
  const float length = std::sqrt(
      value.x * value.x + value.y * value.y + value.z * value.z);
  if (!std::isfinite(length) || length <= std::numeric_limits<float>::epsilon()) {
    return {0.f, 0.f, 1.f};
  }
  return {value.x / length, value.y / length, value.z / length};
}

[[nodiscard]] inline FilterSample ComputeFilterSample(
    Float2 uv,
    Float2 fixation_uv,
    std::uint32_t width,
    std::uint32_t height,
    float horizontal_screen_angle_degrees,
    float fixation_blend,
    float maximum_sigma_pixels = kMaximumSigmaPixels) noexcept {
  FilterSample result = {};
  if (width == 0u || height == 0u) return result;

  uv = SanitizeFixationUv(uv);
  fixation_uv = SanitizeFixationUv(fixation_uv);
  const float horizontal_angle = SanitizeHorizontalScreenAngle(
      horizontal_screen_angle_degrees);
  const float aspect = static_cast<float>(width) / static_cast<float>(height);
  const float tan_half_horizontal = std::tan(
      horizontal_angle * kDegreesToRadians * 0.5f);
  const float vertical_angle = 2.f * std::atan(tan_half_horizontal / aspect)
                               * kRadiansToDegrees;

  const auto screen_point = [&](Float2 point) {
    return Float3{
        (point.x * 2.f - 1.f) * tan_half_horizontal,
        (1.f - point.y * 2.f) * tan_half_horizontal / aspect,
        1.f,
    };
  };
  const Float3 sample_plane = screen_point(uv);
  const Float3 fixation_plane = screen_point(fixation_uv);
  const Float3 sample_ray = Normalize(sample_plane);
  const Float3 fixation_ray = Normalize(fixation_plane);
  const float ray_dot = std::clamp(
      sample_ray.x * fixation_ray.x
          + sample_ray.y * fixation_ray.y
          + sample_ray.z * fixation_ray.z,
      -1.f,
      1.f);
  const float eccentricity = std::clamp(
      std::acos(ray_dot) * kRadiansToDegrees,
      0.f,
      kMaximumEccentricityDegrees);
  const float plane_x = sample_plane.x - fixation_plane.x;
  const float plane_y = sample_plane.y - fixation_plane.y;
  const float plane_distance = std::hypot(plane_x, plane_y);
  if (plane_distance > std::numeric_limits<float>::epsilon()) {
    result.horizontal_eccentricity_degrees = eccentricity * plane_x / plane_distance;
    result.vertical_eccentricity_degrees = eccentricity * plane_y / plane_distance;
  }
  result.eccentricity_degrees = eccentricity;
  result.retinal_nyquist_cycles_per_degree =
      ComputeRetinalNyquistCyclesPerDegree(
          result.horizontal_eccentricity_degrees,
          result.vertical_eccentricity_degrees);
  result.horizontal_pixels_per_degree = static_cast<float>(width) / horizontal_angle;
  result.vertical_pixels_per_degree = static_cast<float>(height)
                                      / std::max(vertical_angle, std::numeric_limits<float>::epsilon());
  result.horizontal_sigma_pixels = ComputeAdditionalGaussianSigmaPixels(
      result.retinal_nyquist_cycles_per_degree,
      result.horizontal_pixels_per_degree,
      fixation_blend,
      maximum_sigma_pixels);
  result.vertical_sigma_pixels = ComputeAdditionalGaussianSigmaPixels(
      result.retinal_nyquist_cycles_per_degree,
      result.vertical_pixels_per_degree,
      fixation_blend,
      maximum_sigma_pixels);
  return result;
}

[[nodiscard]] inline std::uint32_t ComputeKernelRadius(
    float sigma_pixels,
    bool high_quality) noexcept {
  const float sigma = std::clamp(
      FiniteOr(sigma_pixels, 0.f), 0.f, kMaximumSigmaPixels);
  const float support = high_quality ? 4.f : 3.f;
  return std::min(
      static_cast<std::uint32_t>(std::ceil(sigma * support)),
      kMaximumKernelRadius);
}

[[nodiscard]] inline float ComputeGaussianWeight(
    float offset_pixels,
    float sigma_pixels) noexcept {
  const float sigma = FiniteOr(sigma_pixels, 0.f);
  const float offset = FiniteOr(offset_pixels, 0.f);
  if (sigma <= std::numeric_limits<float>::epsilon()) {
    return std::abs(offset) <= std::numeric_limits<float>::epsilon() ? 1.f : 0.f;
  }
  const float exponent = -(offset * offset) / (2.f * sigma * sigma);
  return FiniteOr(std::exp(exponent), 0.f);
}

}  // namespace renodx::games::detroitbecomehuman::retinal
