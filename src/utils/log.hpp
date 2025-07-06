/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>
#include <sstream>

#include <include/reshade.hpp>
#include "./format.hpp"

namespace renodx::utils::log {

template <typename T>
inline std::string AsHex(T value) {
  std::ostringstream oss;
  oss << "0x" << std::hex << std::setw(sizeof(T) * 2) << std::setfill('0') << value << std::dec;
  return oss.str();
}

template <typename T>
inline std::string AsPtr(T value) {
  std::ostringstream oss;
  oss << "0x" << std::hex << std::setw(sizeof(uint64_t) * 2) << std::setfill('0') << reinterpret_cast<uint64_t>(value) << std::dec;
  return oss.str();
}

inline std::string AsPtr(uint64_t value) {
  std::ostringstream oss;
  oss << "0x" << std::hex << std::setw(sizeof(uint64_t) * 2) << std::setfill('0') << value << std::dec;
  return oss.str();
}

inline std::string AsPtr(uint32_t value) {
  std::ostringstream oss;
  oss << "0x" << std::hex << std::setw(sizeof(uint32_t) * 2) << std::setfill('0') << value << std::dec;
  return oss.str();
}

template <typename... Args>
std::string BuildString(Args&&... args) {
  std::stringstream s;
  (s << ... << std::forward<Args>(args));
  return s.str();
}

template <typename... Args>
void i(Args&&... args) {
  reshade::log::message(reshade::log::level::info, BuildString(std::forward<Args>(args)...).c_str());
}

template <typename... Args>
void d(Args&&... args) {
  reshade::log::message(reshade::log::level::debug, BuildString(std::forward<Args>(args)...).c_str());
}

template <typename... Args>
void e(Args&&... args) {
  reshade::log::message(reshade::log::level::error, BuildString(std::forward<Args>(args)...).c_str());
}

template <typename... Args>
void w(Args&&... args) {
  reshade::log::message(reshade::log::level::warning, BuildString(std::forward<Args>(args)...).c_str());
}

}  // namespace renodx::utils::log