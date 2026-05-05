#pragma once

/*
 * Compile-time gated logging helpers for the Alias Isolation port.
 *
 * Logging is default-enabled while shader CRC32 matching and TAA runtime
 * capture are being verified. Set ALIENISOLATION_ALIAS_LOGGING to 0 for quiet
 * builds; the helpers then compile down to argument suppression.
 */

#include <cstdint>
#include <iomanip>
#include <limits>
#include <sstream>
#include <string>
#include <utility>

#include <include/reshade.hpp>

namespace alienisolation::aliasisolation::logging {

#ifndef ALIENISOLATION_ALIAS_LOGGING
#define ALIENISOLATION_ALIAS_LOGGING 0
#endif

inline constexpr bool enabled = ALIENISOLATION_ALIAS_LOGGING != 0;

template <typename... Args>
inline void Message(reshade::log::level level, Args&&... args) {
  // Keep the formatting call site simple while making the whole body disappear
  // when detailed Alias Isolation logging is disabled.
#if ALIENISOLATION_ALIAS_LOGGING
  std::ostringstream stream;
  stream << "AliasIsolation: ";
  (stream << ... << std::forward<Args>(args));
  const std::string message = stream.str();
  reshade::log::message(level, message.c_str());
#else
  (void)level;
  ((void)args, ...);
#endif
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

inline std::string Crc32(uint32_t value) {
  std::ostringstream stream;
  stream << "0x" << std::uppercase << std::hex << std::setw(8) << std::setfill('0') << value;
  return stream.str();
}

inline const char* Bool(bool value) {
  return value ? "on" : "off";
}

inline bool ShouldLogFrame(uint64_t frame, uint64_t& last_frame, uint64_t interval = 120u) {
  if constexpr (!enabled) {
    return false;
  }
  if (last_frame == std::numeric_limits<uint64_t>::max() || frame >= last_frame + interval) {
    last_frame = frame;
    return true;
  }
  return false;
}

}  // namespace alienisolation::aliasisolation::logging
