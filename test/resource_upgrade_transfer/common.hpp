#pragma once

#include <windows.h>

#include <array>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <string>
#include <string_view>

namespace renodx::test::resource_upgrade_transfer {

constexpr uint32_t WIDTH = 4;
constexpr uint32_t HEIGHT = 4;
constexpr uint64_t UPLOAD_OFFSET = 512;
constexpr uint64_t READBACK_OFFSET = 1024;
constexpr uint8_t SENTINEL = 0xCD;

enum class Format { RGBA8,
                    RGB10A2 };

inline Format GetFormat() {
  wchar_t value[32] = {};
  GetEnvironmentVariableW(L"RENODX_TRANSFER_FORMAT", value, static_cast<DWORD>(std::size(value)));
  return std::wstring_view(value) == L"rgb10a2" ? Format::RGB10A2 : Format::RGBA8;
}

inline std::array<float, 4> Expected(uint32_t x, uint32_t y, Format format) {
  if (format == Format::RGBA8) {
    return {
        static_cast<float>((17u + x * 41u + y * 13u) & 0xFFu) / 255.f,
        static_cast<float>((29u + x * 19u + y * 47u) & 0xFFu) / 255.f,
        static_cast<float>((53u + x * 23u + y * 31u) & 0xFFu) / 255.f,
        static_cast<float>((1u + x + y) & 0xFFu) / 255.f,
    };
  }

  return {
      static_cast<float>((71u + x * 137u + y * 53u) & 0x3FFu) / 1023.f,
      static_cast<float>((113u + x * 73u + y * 149u) & 0x3FFu) / 1023.f,
      static_cast<float>((191u + x * 97u + y * 61u) & 0x3FFu) / 1023.f,
      static_cast<float>((x + y) & 0x3u) / 3.f,
  };
}

inline uint32_t Packed(uint32_t x, uint32_t y, Format format) {
  const auto expected = Expected(x, y, format);
  if (format == Format::RGBA8) {
    return static_cast<uint32_t>(std::lround(expected[0] * 255.f))
           | (static_cast<uint32_t>(std::lround(expected[1] * 255.f)) << 8u)
           | (static_cast<uint32_t>(std::lround(expected[2] * 255.f)) << 16u)
           | (static_cast<uint32_t>(std::lround(expected[3] * 255.f)) << 24u);
  }
  return static_cast<uint32_t>(std::lround(expected[0] * 1023.f))
         | (static_cast<uint32_t>(std::lround(expected[1] * 1023.f)) << 10u)
         | (static_cast<uint32_t>(std::lround(expected[2] * 1023.f)) << 20u)
         | (static_cast<uint32_t>(std::lround(expected[3] * 3.f)) << 30u);
}

inline std::filesystem::path ResultPath() {
  wchar_t value[32768] = {};
  GetEnvironmentVariableW(L"RENODX_TRANSFER_RESULT", value, static_cast<DWORD>(std::size(value)));
  return value;
}

inline int Finish(bool passed, const std::string& detail) {
  std::ofstream output(ResultPath(), std::ios::binary);
  output << (passed ? "PASS" : "FAIL") << '\n'
         << detail << '\n';
  return passed ? 0 : 1;
}

}  // namespace renodx::test::resource_upgrade_transfer