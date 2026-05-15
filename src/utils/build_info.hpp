/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <string_view>

#ifndef RENODX_BUILD_VERSION
#define RENODX_BUILD_VERSION "unknown"
#endif

#ifndef RENODX_BUILD_TIMESTAMP_UTC
#define RENODX_BUILD_TIMESTAMP_UTC "unknown"
#endif

#ifndef RENODX_SOURCE_DATE_EPOCH
#define RENODX_SOURCE_DATE_EPOCH "unknown"
#endif

namespace renodx::build_info {

inline constexpr std::string_view kUnknownValue = "unknown";
inline constexpr std::string_view kBuildVersion = RENODX_BUILD_VERSION;
inline constexpr std::string_view kBuildTimestampUtc = RENODX_BUILD_TIMESTAMP_UTC;
inline constexpr std::string_view kSourceDateEpoch = RENODX_SOURCE_DATE_EPOCH;

[[nodiscard]] inline constexpr bool HasKnownBuildVersion() {
  return kBuildVersion != kUnknownValue;
}

[[nodiscard]] inline constexpr bool HasKnownBuildTimestamp() {
  return kBuildTimestampUtc != kUnknownValue;
}

[[nodiscard]] inline constexpr bool HasKnownSourceDateEpoch() {
  return kSourceDateEpoch != kUnknownValue;
}

}  // namespace renodx::build_info