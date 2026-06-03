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
#include <limits>
#include <span>
#include <stdexcept>
#include <string>
#include <string_view>
#include <type_traits>
#include <variant>
#include <vector>

#include "./float16.hpp"

namespace renodx::utils::exr {

static_assert(std::endian::native == std::endian::little);

// https://openexr.com/en/latest/OpenEXRFileLayout.html

inline constexpr std::uint32_t MAGIC = 20000630u;
inline constexpr std::uint32_t VERSION = 2u;
inline constexpr std::uint32_t LONG_NAMES_FLAG = 0x00000400u;
inline constexpr std::int32_t HALF_PIXEL_TYPE = 1;
inline constexpr std::uint8_t INCREASING_Y = 0u;
inline constexpr std::uint8_t DECREASING_Y = 1u;
inline constexpr std::uint8_t RANDOM_Y = 2u;
inline constexpr std::uint8_t NO_COMPRESSION = 0u;
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

struct Rgba32fImage {
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;
  Box2i data_window = {};
  Box2i display_window = {};
  float pixel_aspect_ratio = 1.f;
  V2f screen_window_center = {};
  float screen_window_width = 1.f;
  std::vector<float> rgba_pixels;
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

class InputStream {
 public:
  explicit InputStream(std::istream& stream) : stream(stream) {}

  template <typename T>
    requires(std::is_arithmetic_v<T> || std::is_enum_v<T>)
  InputStream& operator>>(T& value) {
    stream.read(reinterpret_cast<char*>(&value), static_cast<std::streamsize>(sizeof(T)));
    if (!stream.good()) {
      throw std::runtime_error("Failed to read EXR data.");
    }
    return *this;
  }

  InputStream& ReadExact(std::span<std::byte> bytes) {
    if (!bytes.empty()) {
      stream.read(reinterpret_cast<char*>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
    }
    if (!stream.good()) {
      throw std::runtime_error("Failed to read EXR byte span.");
    }
    return *this;
  }

  [[nodiscard]] std::string ReadStringZ() {
    std::string value;
    char ch = '\0';
    do {
      stream.get(ch);
      if (!stream.good()) {
        throw std::runtime_error("Failed to read EXR string.");
      }
      if (ch != '\0') {
        value.push_back(ch);
      }
    } while (ch != '\0');
    return value;
  }

  [[nodiscard]] std::string ReadString(std::size_t size) {
    std::string value(size, '\0');
    if (size != 0u) {
      stream.read(value.data(), static_cast<std::streamsize>(size));
    }
    if (!stream.good()) {
      throw std::runtime_error("Failed to read EXR string payload.");
    }
    return value;
  }

  [[nodiscard]] std::streampos Tell() {
    return stream.tellg();
  }

  void Seek(std::streampos position) {
    stream.seekg(position);
    if (!stream.good()) {
      throw std::runtime_error("Failed to seek EXR stream.");
    }
  }

  InputStream& operator>>(Box2i& value) {
    return *this >> value.min_x >> value.min_y >> value.max_x >> value.max_y;
  }

  InputStream& operator>>(V2f& value) {
    return *this >> value.x >> value.y;
  }

 private:
  std::istream& stream;
};

[[nodiscard]] inline Rgba32fImage ReadRgba32f(std::istream& stream) {
  InputStream input(stream);

  std::uint32_t magic = 0u;
  std::uint32_t version_field = 0u;
  input >> magic >> version_field;
  if (magic != MAGIC) {
    throw std::runtime_error("Invalid EXR magic.");
  }

  const auto version = version_field & 0xFFu;
  const auto flags = version_field & ~0xFFu;
  if (version != VERSION) {
    throw std::runtime_error("Unsupported EXR version.");
  }
  if ((flags & ~LONG_NAMES_FLAG) != 0u) {
    throw std::runtime_error("Unsupported EXR version flags.");
  }

  bool has_channels = false;
  bool has_compression = false;
  bool has_data_window = false;
  bool has_display_window = false;
  bool has_line_order = false;
  bool has_pixel_aspect_ratio = false;
  bool has_screen_window_center = false;
  bool has_screen_window_width = false;
  std::vector<std::string> channel_names_storage;

  Rgba32fImage image{};
  while (true) {
    const auto attribute_name = input.ReadStringZ();
    if (attribute_name.empty()) {
      break;
    }

    const auto attribute_type = input.ReadStringZ();
    std::int32_t attribute_size = 0;
    input >> attribute_size;
    if (attribute_size < 0) {
      throw std::runtime_error("Invalid EXR attribute size.");
    }

    if (attribute_name == "channels") {
      if (attribute_type != "chlist") {
        throw std::runtime_error("Unexpected EXR channels attribute type.");
      }

      const auto payload_start = input.Tell();
      channel_names_storage.clear();
      while (true) {
        const auto channel_name = input.ReadStringZ();
        if (channel_name.empty()) {
          break;
        }

        std::int32_t pixel_type = 0;
        std::uint8_t p_linear = 0u;
        std::uint8_t reserved0 = 0u;
        std::uint8_t reserved1 = 0u;
        std::uint8_t reserved2 = 0u;
        std::int32_t x_sampling = 0;
        std::int32_t y_sampling = 0;
        input >> pixel_type >> p_linear >> reserved0 >> reserved1 >> reserved2 >> x_sampling >> y_sampling;

        if (pixel_type != HALF_PIXEL_TYPE) {
          throw std::runtime_error("Unsupported EXR channel pixel type.");
        }
        if (p_linear != 0u || reserved0 != 0u || reserved1 != 0u || reserved2 != 0u) {
          throw std::runtime_error("Unsupported EXR channel flags.");
        }
        if (x_sampling != 1 || y_sampling != 1) {
          throw std::runtime_error("Unsupported EXR channel sampling.");
        }

        channel_names_storage.push_back(channel_name);
      }

      const auto payload_end = input.Tell();
      const auto payload_size = static_cast<std::int64_t>(payload_end - payload_start);
      if (payload_size != attribute_size) {
        throw std::runtime_error("Unexpected EXR channel list size.");
      }
      if (channel_names_storage.size() != RGBA_CHANNEL_ENTRIES.size()
          || channel_names_storage[0] != "A"
          || channel_names_storage[1] != "B"
          || channel_names_storage[2] != "G"
          || channel_names_storage[3] != "R") {
        throw std::runtime_error("Unsupported EXR channel layout.");
      }

      has_channels = true;
      continue;
    }

    if (attribute_name == "compression") {
      if (attribute_type != "compression" || attribute_size != SerializedSize(std::uint8_t{})) {
        throw std::runtime_error("Unexpected EXR compression attribute.");
      }
      std::uint8_t compression = 0u;
      input >> compression;
      if (compression != NO_COMPRESSION) {
        throw std::runtime_error("Unsupported EXR compression.");
      }
      has_compression = true;
      continue;
    }

    if (attribute_name == "dataWindow") {
      if (attribute_type != "box2i" || attribute_size != SerializedSize(Box2i{})) {
        throw std::runtime_error("Unexpected EXR dataWindow attribute.");
      }
      input >> image.data_window;
      has_data_window = true;
      continue;
    }

    if (attribute_name == "displayWindow") {
      if (attribute_type != "box2i" || attribute_size != SerializedSize(Box2i{})) {
        throw std::runtime_error("Unexpected EXR displayWindow attribute.");
      }
      input >> image.display_window;
      has_display_window = true;
      continue;
    }

    if (attribute_name == "lineOrder") {
      if (attribute_type != "lineOrder" || attribute_size != SerializedSize(std::uint8_t{})) {
        throw std::runtime_error("Unexpected EXR lineOrder attribute.");
      }
      std::uint8_t line_order = 0u;
      input >> line_order;
      if (line_order != INCREASING_Y) {
        throw std::runtime_error("Unsupported EXR line order.");
      }
      has_line_order = true;
      continue;
    }

    if (attribute_name == "pixelAspectRatio") {
      if (attribute_type != "float" || attribute_size != SerializedSize(float{})) {
        throw std::runtime_error("Unexpected EXR pixelAspectRatio attribute.");
      }
      input >> image.pixel_aspect_ratio;
      has_pixel_aspect_ratio = true;
      continue;
    }

    if (attribute_name == "screenWindowCenter") {
      if (attribute_type != "v2f" || attribute_size != SerializedSize(V2f{})) {
        throw std::runtime_error("Unexpected EXR screenWindowCenter attribute.");
      }
      input >> image.screen_window_center;
      has_screen_window_center = true;
      continue;
    }

    if (attribute_name == "screenWindowWidth") {
      if (attribute_type != "float" || attribute_size != SerializedSize(float{})) {
        throw std::runtime_error("Unexpected EXR screenWindowWidth attribute.");
      }
      input >> image.screen_window_width;
      has_screen_window_width = true;
      continue;
    }

    input.Seek(input.Tell() + static_cast<std::streamoff>(attribute_size));
  }

  if (!has_channels || !has_compression || !has_data_window || !has_display_window || !has_line_order
      || !has_pixel_aspect_ratio || !has_screen_window_center || !has_screen_window_width) {
    throw std::runtime_error("Missing required EXR header attributes.");
  }

  if (image.data_window.min_x != 0 || image.data_window.min_y != 0) {
    throw std::runtime_error("Unsupported EXR dataWindow origin.");
  }

  const auto width_i64 = static_cast<std::int64_t>(image.data_window.max_x) - static_cast<std::int64_t>(image.data_window.min_x) + 1;
  const auto height_i64 = static_cast<std::int64_t>(image.data_window.max_y) - static_cast<std::int64_t>(image.data_window.min_y) + 1;
  if (width_i64 <= 0 || height_i64 <= 0) {
    throw std::runtime_error("Invalid EXR dimensions.");
  }
  if (width_i64 > static_cast<std::int64_t>((std::numeric_limits<std::uint32_t>::max)())
      || height_i64 > static_cast<std::int64_t>((std::numeric_limits<std::uint32_t>::max)())) {
    throw std::runtime_error("EXR dimensions are too large.");
  }

  image.width = static_cast<std::uint32_t>(width_i64);
  image.height = static_cast<std::uint32_t>(height_i64);

  std::vector<std::uint64_t> offsets(image.height);
  for (auto& offset : offsets) {
    input >> offset;
  }

  image.rgba_pixels.resize(static_cast<std::size_t>(image.width) * static_cast<std::size_t>(image.height) * 4u);
  std::vector<std::uint16_t> channel_buffer(static_cast<std::size_t>(image.width));
  for (std::uint32_t y = 0; y < image.height; ++y) {
    input.Seek(static_cast<std::streampos>(offsets[y]));

    std::int32_t stored_y = 0;
    std::int32_t packed_size = 0;
    input >> stored_y >> packed_size;
    if (stored_y != static_cast<std::int32_t>(y)) {
      throw std::runtime_error("Unexpected EXR scanline index.");
    }

    const auto expected_size = static_cast<std::int32_t>(image.width * 4u * sizeof(std::uint16_t));
    if (packed_size != expected_size) {
      throw std::runtime_error("Unexpected EXR scanline size.");
    }

    const auto row_start = static_cast<std::size_t>(y) * static_cast<std::size_t>(image.width) * 4u;
    for (std::uint32_t channel_index = 0; channel_index < 4u; ++channel_index) {
      input.ReadExact(std::as_writable_bytes(std::span(channel_buffer)));
      for (std::uint32_t x = 0; x < image.width; ++x) {
        const auto pixel_index = row_start + (static_cast<std::size_t>(x) * 4u);
        const auto value = renodx::utils::float16::Decode(channel_buffer[x]);
        switch (channel_index) {
          case 0u:
            image.rgba_pixels[pixel_index + 3u] = value;
            break;
          case 1u:
            image.rgba_pixels[pixel_index + 2u] = value;
            break;
          case 2u:
            image.rgba_pixels[pixel_index + 1u] = value;
            break;
          case 3u:
            image.rgba_pixels[pixel_index + 0u] = value;
            break;
        }
      }
    }
  }

  return image;
}

[[nodiscard]] inline Rgba32fImage ReadRgba32f(const std::filesystem::path& input_path) {
  std::ifstream file(input_path, std::ios::binary);
  if (!file.is_open()) {
    throw std::runtime_error("Failed to open EXR input file.");
  }

  auto image = ReadRgba32f(file);
  if (!file.good() && !file.eof()) {
    throw std::runtime_error("Failed while reading EXR input file.");
  }
  return image;
}

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
