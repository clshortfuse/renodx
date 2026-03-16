/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <bit>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <span>
#include <stdexcept>
#include <string_view>
#include <type_traits>
#include <variant>

#include "./float16.hpp"

namespace renodx::utils::exr {

static_assert(std::endian::native == std::endian::little);

// https://openexr.com/en/latest/OpenEXRFileLayout.html

inline constexpr std::uint32_t MAGIC = 20000630u;
inline constexpr std::uint32_t VERSION = 2u;
inline constexpr std::int32_t HALF_PIXEL_TYPE = 1;
inline constexpr std::uint8_t NO_COMPRESSION = 0u;
inline constexpr std::uint8_t INCREASING_Y = 0u;
struct AttributeHeader {
  std::string_view name;
  std::string_view type;
  std::int32_t size;
};

struct ChannelEntry {
  std::string_view name;
};

inline constexpr std::array<ChannelEntry, 4> RGBA_CHANNEL_ENTRIES = {
    ChannelEntry{.name = "A"},
    ChannelEntry{.name = "B"},
    ChannelEntry{.name = "G"},
    ChannelEntry{.name = "R"},
};

struct ChannelList {
  std::span<const ChannelEntry> entries;
};

struct Box2i {
  std::int32_t min_x = 0;
  std::int32_t min_y = 0;
  std::int32_t max_x = 0;
  std::int32_t max_y = 0;
};

struct V2f {
  float x = 0.f;
  float y = 0.f;
};

using AttributeValue = std::variant<ChannelList, std::uint8_t, Box2i, float, V2f>;

struct Attribute {
  std::string_view name;
  std::string_view type;
  AttributeValue value;
};

template <std::size_t N>
using Header = std::array<Attribute, N>;

template <typename T>
struct Scanline {
  std::uint32_t y = 0u;
  std::uint32_t width = 0u;
  std::span<const T> rgba_pixels;
};

struct ScanLineLayout {
  std::uint64_t scanline_block_size = 0u;
  std::uint64_t pixel_data_offset = 0u;

  [[nodiscard]] std::uint64_t GetScanlineOffset(std::uint32_t y) const {
    return pixel_data_offset + (static_cast<std::uint64_t>(y) * scanline_block_size);
  }
};

struct LineOffsetTable {
  ScanLineLayout layout = {};
  std::uint32_t height = 0u;
};

static_assert(sizeof(Box2i) == 16u);
static_assert(sizeof(V2f) == 8u);

template <typename T>
  requires(std::is_trivially_copyable_v<T>)
[[nodiscard]] constexpr std::int32_t SerializedSize(const T& value) {
  return static_cast<std::int32_t>(sizeof(T));
}

[[nodiscard]] constexpr std::int32_t SerializedSize(std::string_view value) {
  return static_cast<std::int32_t>(value.size() + 1u);
}

[[nodiscard]] constexpr std::int32_t SerializedSize(const AttributeHeader& value) {
  return SerializedSize(value.name)
         + SerializedSize(value.type)
         + SerializedSize(std::int32_t{});
}

[[nodiscard]] constexpr std::int32_t SerializedSize(const ChannelEntry& value) {
  return SerializedSize(value.name)
         + SerializedSize(std::int32_t{})
         + (4 * SerializedSize(std::uint8_t{}))
         + (2 * SerializedSize(std::int32_t{}));
}

[[nodiscard]] constexpr std::int32_t SerializedSize(const ChannelList& value) {
  auto size = SerializedSize(std::uint8_t{});
  for (const auto& entry : value.entries) {
    size += SerializedSize(entry);
  }
  return size;
}

[[nodiscard]] constexpr std::int32_t SerializedSize(const AttributeValue& value) {
  return std::visit(
      [](const auto& payload) -> std::int32_t {
        return SerializedSize(payload);
      },
      value);
}

[[nodiscard]] constexpr std::int32_t SerializedSize(const Attribute& value) {
  const auto payload_size = SerializedSize(value.value);
  return SerializedSize(AttributeHeader{
             .name = value.name,
             .type = value.type,
             .size = payload_size,
         })
         + payload_size;
}

template <std::size_t N>
[[nodiscard]] constexpr std::int32_t SerializedSize(const Header<N>& value) {
  auto size = SerializedSize(std::uint8_t{});
  for (const auto& attribute : value) {
    size += SerializedSize(attribute);
  }
  return size;
}

template <std::size_t N>
[[nodiscard]] inline ScanLineLayout BuildScanLineLayout(std::uint32_t width, std::uint32_t height, const Header<N>& header) {
  static constexpr std::uint64_t FILE_PREAMBLE_SIZE = sizeof(std::int32_t) * 2u;            // magic + version field
  static constexpr std::uint64_t SCANLINE_BLOCK_PREAMBLE_SIZE = sizeof(std::int32_t) * 2u;  // y + packed size

  const auto scanline_data_size = static_cast<std::uint64_t>(width) * 4u * sizeof(std::uint16_t);
  const auto scanline_block_size = SCANLINE_BLOCK_PREAMBLE_SIZE + scanline_data_size;
  const auto pixel_data_offset = FILE_PREAMBLE_SIZE
                                 + static_cast<std::uint64_t>(SerializedSize(header))
                                 + (static_cast<std::uint64_t>(height) * sizeof(std::uint64_t));

  return {
      .scanline_block_size = scanline_block_size,
      .pixel_data_offset = pixel_data_offset,
  };
}

template <typename T>
  requires(std::is_same_v<T, std::uint16_t> || std::is_same_v<T, float>)
[[nodiscard]] constexpr std::uint16_t EncodeRgba16fChannel(T value) {
  if constexpr (std::is_same_v<T, std::uint16_t>) {
    return value;
  } else {
    return renodx::utils::float16::Encode(value);
  }
}

class OutputStream {
 public:
  explicit OutputStream(std::ostream& stream) : stream(stream) {}

  template <typename T>
    requires(std::is_arithmetic_v<T> || std::is_enum_v<T>)
  OutputStream& operator<<(const T& value) {
    stream.write(reinterpret_cast<const char*>(&value), static_cast<std::streamsize>(sizeof(T)));
    if (!stream.good()) {
      throw std::runtime_error("Failed to write EXR data.");
    }
    return *this;
  }

  template <typename T>
    requires(std::is_trivially_copyable_v<T>)
  OutputStream& operator<<(std::span<const T> value) {
    const auto bytes = std::as_bytes(value);
    if (!bytes.empty()) {
      stream.write(reinterpret_cast<const char*>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
    }
    if (!stream.good()) {
      throw std::runtime_error("Failed to write EXR span.");
    }
    return *this;
  }

  OutputStream& operator<<(std::string_view value) {
    if (!value.empty()) {
      stream.write(value.data(), static_cast<std::streamsize>(value.size()));
    }
    stream.put('\0');
    if (!stream.good()) {
      throw std::runtime_error("Failed to write EXR string.");
    }
    return *this;
  }

  OutputStream& operator<<(const AttributeHeader& value) {
    return *this
           << value.name
           << value.type
           << value.size;
  }

  OutputStream& operator<<(const AttributeValue& value) {
    std::visit(
        [this](const auto& payload) {
          *this << payload;
        },
        value);
    return *this;
  }

  OutputStream& operator<<(const ChannelEntry& value) {
    return *this
           << value.name
           << HALF_PIXEL_TYPE
           << static_cast<std::uint8_t>(0)  // pLinear
           << static_cast<std::uint8_t>(0)
           << static_cast<std::uint8_t>(0)
           << static_cast<std::uint8_t>(0)
           << static_cast<std::int32_t>(1)   // xSampling
           << static_cast<std::int32_t>(1);  // ySampling
  }

  OutputStream& operator<<(const ChannelList& value) {
    for (const auto& entry : value.entries) {
      *this << entry;
    }
    *this << static_cast<std::uint8_t>(0);
    return *this;
  }

  OutputStream& operator<<(Box2i value) {
    return *this << value.min_x << value.min_y << value.max_x << value.max_y;
  }

  OutputStream& operator<<(V2f value) {
    return *this << value.x << value.y;
  }

  OutputStream& operator<<(const Attribute& value) {
    return *this
           << AttributeHeader{
                  .name = value.name,
                  .type = value.type,
                  .size = SerializedSize(value.value),
              }
           << value.value;
  }

  template <std::size_t N>
  OutputStream& operator<<(const Header<N>& value) {
    for (const auto& attribute : value) {
      *this << attribute;
    }
    *this << static_cast<std::uint8_t>(0);
    return *this;
  }

  template <typename T>
    requires(std::is_same_v<T, std::uint16_t> || std::is_same_v<T, float>)
  OutputStream& operator<<(Scanline<T> value) {
    const auto expected_size = static_cast<std::size_t>(value.width) * 4u;
    if (value.rgba_pixels.size() != expected_size) {
      throw std::invalid_argument("Scanline input must contain width * 4 channels.");
    }

    const auto scanline_data_size = static_cast<std::int32_t>(expected_size * sizeof(std::uint16_t));
    *this << static_cast<std::int32_t>(value.y) << scanline_data_size;

    for (std::uint32_t x = 0; x < value.width; ++x) {
      const auto pixel_index = static_cast<std::size_t>(x) * 4u;
      *this << EncodeRgba16fChannel(value.rgba_pixels[pixel_index + 3u]);  // A
    }
    for (std::uint32_t x = 0; x < value.width; ++x) {
      const auto pixel_index = static_cast<std::size_t>(x) * 4u;
      *this << EncodeRgba16fChannel(value.rgba_pixels[pixel_index + 2u]);  // B
    }
    for (std::uint32_t x = 0; x < value.width; ++x) {
      const auto pixel_index = static_cast<std::size_t>(x) * 4u;
      *this << EncodeRgba16fChannel(value.rgba_pixels[pixel_index + 1u]);  // G
    }
    for (std::uint32_t x = 0; x < value.width; ++x) {
      const auto pixel_index = static_cast<std::size_t>(x) * 4u;
      *this << EncodeRgba16fChannel(value.rgba_pixels[pixel_index + 0u]);  // R
    }
    return *this;
  }

  OutputStream& operator<<(LineOffsetTable value) {
    for (std::uint32_t y = 0; y < value.height; ++y) {
      *this << value.layout.GetScanlineOffset(y);
    }
    return *this;
  }

 private:
  std::ostream& stream;
};

template <typename T>
  requires(std::is_same_v<T, std::uint16_t> || std::is_same_v<T, float>)
inline void WriteRgba16f(
    const std::filesystem::path& output_path,
    std::uint32_t width,
    std::uint32_t height,
    std::span<const T> rgba_pixels,
    std::size_t row_stride_values) {
  // Input is pixel-interleaved RGBA binary16. The EXR scanline payload is channel-major
  // and follows the header's channel-name order, so this writer repacks to A/B/G/R planes.
  // All scalar writes assume little-endian host layout, matching the OpenEXR file layout.
  const auto row_size = static_cast<std::size_t>(width) * 4u;
  if (rgba_pixels.size() < row_size * static_cast<std::size_t>(height)) {
    throw std::invalid_argument("RGBA16F EXR input must contain width * height * 4 channels.");
  }
  if (row_stride_values < row_size) {
    throw std::invalid_argument("RGBA16F EXR row stride must be at least width * 4 values.");
  }
  if (rgba_pixels.size() < row_stride_values * static_cast<std::size_t>(height)) {
    throw std::invalid_argument("RGBA16F EXR input does not contain the requested row stride for all rows.");
  }
  if (width == 0u || height == 0u) {
    throw std::invalid_argument("EXR dimensions must be non-zero.");
  }

  std::ofstream file(output_path, std::ios::binary);
  if (!file.is_open()) {
    throw std::runtime_error("Failed to open EXR output file.");
  }

  OutputStream output(file);

  output << MAGIC << VERSION;

  const auto bounds = Box2i{
      .max_x = static_cast<std::int32_t>(width - 1u),
      .max_y = static_cast<std::int32_t>(height - 1u),
  };

  const Header<8> header = {
      Attribute{.name = "channels", .type = "chlist", .value = ChannelList{.entries = RGBA_CHANNEL_ENTRIES}},
      Attribute{.name = "compression", .type = "compression", .value = NO_COMPRESSION},
      Attribute{.name = "dataWindow", .type = "box2i", .value = bounds},
      Attribute{.name = "displayWindow", .type = "box2i", .value = bounds},
      Attribute{.name = "lineOrder", .type = "lineOrder", .value = INCREASING_Y},
      Attribute{.name = "pixelAspectRatio", .type = "float", .value = 1.f},
      Attribute{.name = "screenWindowCenter", .type = "v2f", .value = V2f{}},
      Attribute{.name = "screenWindowWidth", .type = "float", .value = 1.f},
  };
  const auto scan_line_layout = BuildScanLineLayout(width, height, header);

  output << header;

  output << LineOffsetTable{
      .layout = scan_line_layout,
      .height = height,
  };

  for (std::uint32_t y = 0; y < height; ++y) {
    const auto row_index = static_cast<std::size_t>(y) * row_stride_values;
    output << Scanline<T>{
        .y = y,
        .width = width,
        .rgba_pixels = rgba_pixels.subspan(row_index, row_size),
    };
  }

  file.close();
  if (!file.good()) {
    throw std::runtime_error("Failed to finalize EXR output file.");
  }
}

template <typename T>
  requires(std::is_same_v<T, std::uint16_t> || std::is_same_v<T, float>)
inline void WriteRgba16f(
    const std::filesystem::path& output_path,
    std::uint32_t width,
    std::uint32_t height,
    std::span<const T> rgba_pixels) {
  WriteRgba16f(output_path, width, height, rgba_pixels, static_cast<std::size_t>(width) * 4u);
}

}  // namespace renodx::utils::exr
