#pragma once

namespace renodx::utils::bitwise {
template <typename T = int>
static bool HasFlag(const T a, T b) {
  return (a & b) == b;
}

template <typename T = int>
static T SetFlag(const T a, const T value) {
  return a | value;
}

template <typename T = int>
static T UnsetFlag(const T a, T value) {
  return a & ~value;
}
}  // namespace renodx::utils::bitwise