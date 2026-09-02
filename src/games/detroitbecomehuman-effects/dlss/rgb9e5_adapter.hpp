/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <bit>
#include <cmath>
#include <cstdint>

namespace renodx::games::detroitbecomehuman::dlss::rgb9e5 {

inline constexpr float kMaxChannel = 65408.f;

[[nodiscard]] inline float SanitizeChannel(float value) noexcept {
  if (!std::isfinite(value)) return 0.f;
  return std::clamp(value, 0.f, kMaxChannel);
}

// CPU reference for the exact encoder in Detroit's 0xB5506A45 TAA shader.
[[nodiscard]] inline std::uint32_t Pack(std::array<float, 3u> value) noexcept {
  for (auto& channel : value) channel = SanitizeChannel(channel);

  const auto maximum = std::max(value[0u], std::max(value[1u], value[2u]));
  const auto exponent = std::max(
      UINT32_C(0x37800000),
      std::bit_cast<std::uint32_t>(maximum) & UINT32_C(0x7F800000));
  const auto bias = std::bit_cast<float>(exponent + UINT32_C(0x07800000));

  const auto encode_mantissa = [bias](float channel) {
    const auto truncated = std::bit_cast<float>(
        std::bit_cast<std::uint32_t>(channel) & UINT32_C(0xFFFF8000));
    return std::bit_cast<std::uint32_t>(truncated + bias);
  };
  const auto red = encode_mantissa(value[0u]);
  const auto green = encode_mantissa(value[1u]);
  const auto blue = encode_mantissa(value[2u]);

  return (((red | (green << 9u)) & UINT32_C(0x0003FFFF)) | (blue << 18u))
         | ((exponent - UINT32_C(0x37800000)) << 4u);
}

[[nodiscard]] inline std::array<float, 3u> Unpack(std::uint32_t packed) noexcept {
  const auto exponent = (packed >> 27u) & 31u;
  const auto scale = std::ldexp(1.f, static_cast<int>(exponent) - 24);
  return {
      static_cast<float>(packed & 511u) * scale,
      static_cast<float>((packed >> 9u) & 511u) * scale,
      static_cast<float>((packed >> 18u) & 511u) * scale,
  };
}

}  // namespace renodx::games::detroitbecomehuman::dlss::rgb9e5
