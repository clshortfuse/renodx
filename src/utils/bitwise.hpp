#pragma once
#include <bit>
#include <cstdint>
#include <type_traits>

namespace renodx::utils::bitwise {

template <typename T1 = int, typename T2 = int>
[[nodiscard]] static bool HasFlag(const T1 a, const T2 b) {
  if constexpr (std::is_same_v<T1, float>) {
    return (std::bit_cast<uint32_t>(a) & static_cast<uint32_t>(b)) == static_cast<uint32_t>(b);
  } else {
    return (a & b) == b;
  }
}

template <typename T1 = int, typename T2 = int>
static void SetFlag(T1* a, const T2 value) {
  if constexpr (std::is_same_v<T1, float>) {
    uint32_t bits = std::bit_cast<uint32_t>(*a);
    bits |= static_cast<uint32_t>(value);
    *a = std::bit_cast<float>(bits);
  } else {
    *a |= value;
  }
}

template <typename T1 = int, typename T2 = int>
static void UnsetFlag(T1* a, const T2 value) {
  if constexpr (std::is_same_v<T1, float>) {
    uint32_t bits = std::bit_cast<uint32_t>(*a);
    bits &= ~static_cast<uint32_t>(value);
    *a = std::bit_cast<float>(bits);
  } else {
    *a &= ~value;
  }
}

template <typename T1 = int, typename T2 = int>
[[nodiscard]] static T1 SetFlag(const T1 a, const T2 value) {
  if constexpr (std::is_same_v<T1, float>) {
    uint32_t bits = std::bit_cast<uint32_t>(a);
    bits |= static_cast<uint32_t>(value);
    return std::bit_cast<float>(bits);
  } else {
    return a | value;
  }
}

template <typename T1 = int, typename T2 = int>
[[nodiscard]] static T1 UnsetFlag(const T1 a, const T2 value) {
  if constexpr (std::is_same_v<T1, float>) {
    uint32_t bits = std::bit_cast<uint32_t>(a);
    bits &= ~static_cast<uint32_t>(value);
    return std::bit_cast<float>(bits);
  } else {
    return a & ~value;
  }
}

}  // namespace renodx::utils::bitwise
