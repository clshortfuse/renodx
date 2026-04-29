#pragma once

#include <cstdint>
#include <limits>
#include <sstream>
#include <string>
#include <utility>

#include <include/reshade.hpp>

namespace alienisolation::aliasisolation::logging {

template <typename... Args>
inline void Message(reshade::log::level level, Args&&... args) {
  std::ostringstream stream;
  stream << "AliasIsolation: ";
  (stream << ... << std::forward<Args>(args));
  const std::string message = stream.str();
  reshade::log::message(level, message.c_str());
}

template <typename... Args>
inline void Info(Args&&... args) {
  Message(reshade::log::level::info, std::forward<Args>(args)...);
}

template <typename... Args>
inline void Warn(Args&&... args) {
  Message(reshade::log::level::warning, std::forward<Args>(args)...);
}

template <typename T>
inline std::string Hex(T value) {
  std::ostringstream stream;
  stream << "0x" << std::hex << static_cast<uint64_t>(value);
  return stream.str();
}

inline const char* Bool(bool value) {
  return value ? "on" : "off";
}

inline bool ShouldLogFrame(uint64_t frame, uint64_t& last_frame, uint64_t interval = 120u) {
  if (last_frame == std::numeric_limits<uint64_t>::max() || frame >= last_frame + interval) {
    last_frame = frame;
    return true;
  }
  return false;
}

}  // namespace alienisolation::aliasisolation::logging
