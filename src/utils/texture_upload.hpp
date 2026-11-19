#pragma once

#include <cstdint>
#include <limits>
#include <optional>
#include <include/reshade_api.hpp>
#include "./hash.hpp"

namespace renodx::utils::texture_upload {
struct Layout {
  uint32_t row_bytes;
  uint32_t row_pitch;
  uint32_t rows;
  uint32_t packed_size;
  uint32_t read_extent;
};

// A 2D upload has no meaningful depth/slice pitch on D3D11. Never use it
// as a byte count. Read only logical rows, including BC block-row rounding.
inline std::optional<Layout> GetLayout(reshade::api::format pixel_format,
    uint32_t width, uint32_t height, uint32_t supplied_row_pitch) {
  using reshade::api::format;
  constexpr auto limit = std::numeric_limits<uint32_t>::max();
  if (width == 0 || height == 0 || width > limit / 16 || height > limit - 3) return std::nullopt;
  // These packed formats need a different row-size formula than ReShade's helper.
  if (pixel_format == format::r1_unorm || pixel_format == format::r8g8_b8g8_unorm
      || pixel_format == format::g8r8_g8b8_unorm) return std::nullopt;
  const uint32_t row_bytes = reshade::api::format_row_pitch(pixel_format, width);
  if (row_bytes == 0) return std::nullopt;
  const uint32_t row_pitch = supplied_row_pitch ? supplied_row_pitch : row_bytes;
  if (row_pitch < row_bytes) return std::nullopt;
  const uint32_t rows = reshade::api::format_is_block_compressed(pixel_format) ? (height + 3) / 4 : height;
  const uint64_t packed = uint64_t(row_bytes) * rows;
  const uint64_t extent = uint64_t(row_pitch) * (rows - 1) + row_bytes;
  if (packed > limit || extent > limit) return std::nullopt;
  return Layout{row_bytes, row_pitch, rows, uint32_t(packed), uint32_t(extent)};
}

inline std::optional<Layout> GetLayout(const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data& data, uint32_t subresource) {
  if (desc.type != reshade::api::resource_type::texture_2d || data.data == nullptr
      || desc.texture.width == 0 || desc.texture.height == 0) return std::nullopt;
  const uint32_t levels = desc.texture.levels ? desc.texture.levels : 1;
  const uint32_t layers = desc.texture.depth_or_layers ? desc.texture.depth_or_layers : 1;
  if (uint64_t(subresource) >= uint64_t(levels) * layers) return std::nullopt;
  const uint32_t mip = subresource % levels;
  if (mip >= 32) return std::nullopt;
  const uint32_t width = desc.texture.width >> mip;
  const uint32_t height = desc.texture.height >> mip;
  return GetLayout(desc.texture.format, width ? width : 1, height ? height : 1, data.row_pitch);
}

inline uint32_t ComputeCRC32(const void* data, const Layout& layout) {
  const auto* bytes = static_cast<const uint8_t*>(data);
  uint32_t crc = 0xFFFFFFFFu;
  for (uint32_t row = 0; row < layout.rows; ++row) {
    crc = hash::UpdateCRC32(crc, bytes + size_t(row) * layout.row_pitch, layout.row_bytes);
  }
  return hash::FinalizeCRC32(crc);
}
}  // namespace renodx::utils::texture_upload
