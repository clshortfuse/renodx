/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

// IEEE 754 binary16 reference:
// https://en.wikipedia.org/wiki/Half-precision_floating-point_format

#pragma once

#include <bit>
#include <cstdint>

namespace renodx::utils::float16 {

// Converts an IEEE 754 float32 value to IEEE 754 binary16 using round-to-nearest-even.
[[nodiscard]] inline std::uint16_t Encode(float value) {
  static constexpr std::uint32_t FLOAT32_EXPONENT_MASK = 0b01111111'10000000'00000000'00000000u;
  static constexpr std::uint32_t FLOAT32_MAGNITUDE_MASK = 0b01111111'11111111'11111111'11111111u;
  static constexpr std::uint32_t FLOAT32_MANTISSA_MASK = 0b00000000'01111111'11111111'11111111u;
  static constexpr std::uint32_t FLOAT32_IMPLICIT_ONE = 0b00000000'10000000'00000000'00000000u;
  static constexpr std::uint32_t FLOAT32_HALF_UNDERFLOW_THRESHOLD = 0b00110011'00000000'00000000'00000000u;
  static constexpr std::uint32_t ROUND_TO_EVEN_TIE = 0b10000000'00000000'00000000'00000000u;

  static constexpr std::uint16_t HALF_SIGN_MASK = 0b10000000'00000000u;
  static constexpr std::uint16_t HALF_INFINITY = 0b01111100'00000000u;
  static constexpr std::uint16_t HALF_QUIET_NAN = 0b01111110'00000000u;
  static constexpr std::uint16_t HALF_NAN_PAYLOAD_MASK = 0b00000001'11111111u;

  auto bits = std::bit_cast<std::uint32_t>(value);
  auto encoded = static_cast<std::uint16_t>((bits >> 16) & HALF_SIGN_MASK);

  // Preserve IEEE special values before rebiasing the exponent.
  if ((bits & FLOAT32_EXPONENT_MASK) == FLOAT32_EXPONENT_MASK) {
    if ((bits & FLOAT32_MAGNITUDE_MASK) == FLOAT32_EXPONENT_MASK) {
      encoded |= HALF_INFINITY;  // infinity
    } else {
      // quiet NaN with preserved payload bits
      encoded |= static_cast<std::uint16_t>(HALF_QUIET_NAN | ((bits >> 13) & HALF_NAN_PAYLOAD_MASK));
    }
    return encoded;
  }

  // Values below the half-float denormal range round to signed zero.
  if ((bits & FLOAT32_EXPONENT_MASK) < FLOAT32_HALF_UNDERFLOW_THRESHOLD) {
    return encoded;
  }

  const int exponent = static_cast<int>((bits >> 23) & 0xFFu) - 127;
  if (exponent > 15) {
    return static_cast<std::uint16_t>(encoded | HALF_INFINITY);
  }

  // Reinsert the implicit leading 1 so the mantissa can be shifted into half layout.
  bits = (bits & FLOAT32_MANTISSA_MASK) | FLOAT32_IMPLICIT_ONE;
  if (exponent < -14) {
    // Denormals keep the exponent at zero and shift the mantissa down instead.
    const auto shift = static_cast<unsigned>(-1 - exponent);
    encoded = static_cast<std::uint16_t>(encoded | (bits >> shift));
    bits <<= (32u - shift);
  } else {
    static constexpr unsigned MANTISSA_SHIFT = 13u;
    encoded = static_cast<std::uint16_t>(encoded | (bits >> MANTISSA_SHIFT));
    bits <<= (32u - MANTISSA_SHIFT);
    encoded = static_cast<std::uint16_t>(encoded + ((14 + exponent) << 10));
  }

  // Round-to-nearest-even using the remaining truncated bits.
  if ((bits > ROUND_TO_EVEN_TIE) || ((bits == ROUND_TO_EVEN_TIE) && ((encoded & 1u) != 0u))) {
    ++encoded;
  }

  return encoded;
}

// Converts an IEEE 754 binary16 value to IEEE 754 float32.
[[nodiscard]] inline float Decode(std::uint16_t value) {
  static constexpr std::uint16_t HALF_SIGN_MASK = 0b10000000'00000000u;
  static constexpr std::uint16_t HALF_EXPONENT_MASK = 0b01111100'00000000u;
  static constexpr std::uint16_t HALF_MANTISSA_MASK = 0b00000011'11111111u;

  static constexpr std::uint32_t FLOAT32_SIGN_MASK = 0x80000000u;
  static constexpr std::uint32_t FLOAT32_EXPONENT_MASK = 0x7F800000u;
  static constexpr std::uint32_t FLOAT32_MANTISSA_MASK = 0x007FFFFFu;

  std::uint32_t bits = static_cast<std::uint32_t>(value & HALF_SIGN_MASK) << 16u;
  const auto exponent = static_cast<std::uint16_t>((value & HALF_EXPONENT_MASK) >> 10u);
  const auto mantissa = static_cast<std::uint16_t>(value & HALF_MANTISSA_MASK);

  if (exponent == 0u) {
    if (mantissa == 0u) {
      return std::bit_cast<float>(bits);
    }

    // Renormalize denormals into float32 format.
    std::uint32_t normalized_mantissa = mantissa;
    int normalized_exponent = -14;
    while ((normalized_mantissa & 0x400u) == 0u) {
      normalized_mantissa <<= 1u;
      --normalized_exponent;
    }
    normalized_mantissa &= HALF_MANTISSA_MASK;
    bits |= static_cast<std::uint32_t>(normalized_exponent + 127) << 23u;
    bits |= normalized_mantissa << 13u;
    return std::bit_cast<float>(bits);
  }

  if (exponent == 0x1Fu) {
    bits |= FLOAT32_EXPONENT_MASK;
    if (mantissa != 0u) {
      bits |= static_cast<std::uint32_t>(mantissa) << 13u;
      bits |= 0x00400000u;  // quiet NaN
    }
    return std::bit_cast<float>(bits);
  }

  bits |= static_cast<std::uint32_t>(exponent + (127 - 15)) << 23u;
  bits |= static_cast<std::uint32_t>(mantissa) << 13u;
  bits &= (FLOAT32_SIGN_MASK | FLOAT32_EXPONENT_MASK | FLOAT32_MANTISSA_MASK);
  return std::bit_cast<float>(bits);
}

}  // namespace renodx::utils::float16
