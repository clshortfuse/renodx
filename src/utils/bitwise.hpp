#pragma once

namespace renodx::utils::bitwise {
template <typename T1 = int, typename T2 = int>
static bool HasFlag(const T1 a, T2 b) {
  return (a & b) == b;
}

template <typename T1 = int, typename T2 = int>
static T1 SetFlag(const T1 a, const T2 value) {
  return a | value;
}

template <typename T1 = int, typename T2 = int>
static T1 UnsetFlag(const T1 a, T2 value) {
  return a & ~value;
}
}  // namespace renodx::utils::bitwise