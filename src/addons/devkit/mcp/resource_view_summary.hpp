/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>
#include <optional>
#include <string>

#include <include/reshade.hpp>

#include "../formatting.hpp"
#include "../../../utils/mcp/types.hpp"

namespace renodx::addons::devkit::mcp::resource_view_summary {

using json = renodx::utils::mcp::json;

struct BufferViewSummary {
  std::uint64_t offset = 0u;
  std::optional<std::uint64_t> size = std::nullopt;
  bool full_range = false;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const BufferViewSummary& value) {
  j = {
      {"offset", value.offset},
      {"size", value.size.has_value() ? json(value.size.value()) : json(nullptr)},
      {"fullRange", value.full_range},
  };
}

struct TextureViewSummary {
  std::uint32_t first_level = 0u;
  std::uint32_t level_count = 0u;
  std::uint32_t first_layer = 0u;
  std::uint32_t layer_count = 0u;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const TextureViewSummary& value) {
  j = {
      {"firstLevel", value.first_level},
      {"levelCount", value.level_count},
      {"firstLayer", value.first_layer},
      {"layerCount", value.layer_count},
  };
}

struct ViewSummary {
  std::string type;
  std::string format;
  std::optional<BufferViewSummary> buffer = std::nullopt;
  std::optional<TextureViewSummary> texture = std::nullopt;

  ViewSummary() = default;

  explicit ViewSummary(const reshade::api::resource_view_desc& resource_view_desc)
      : type(formatting::StreamToString(resource_view_desc.type)),
        format(formatting::StreamToString(resource_view_desc.format)) {
    switch (resource_view_desc.type) {
      default:
      case reshade::api::resource_view_type::unknown:
        break;
      case reshade::api::resource_view_type::buffer:
        buffer = BufferViewSummary{
            .offset = resource_view_desc.buffer.offset,
            .size = resource_view_desc.buffer.size == UINT64_MAX
                        ? std::nullopt
                        : std::optional<std::uint64_t>(resource_view_desc.buffer.size),
            .full_range = resource_view_desc.buffer.size == UINT64_MAX,
        };
        break;
      case reshade::api::resource_view_type::texture_1d:
      case reshade::api::resource_view_type::texture_1d_array:
      case reshade::api::resource_view_type::texture_2d:
      case reshade::api::resource_view_type::texture_2d_array:
      case reshade::api::resource_view_type::texture_2d_multisample:
      case reshade::api::resource_view_type::texture_2d_multisample_array:
      case reshade::api::resource_view_type::texture_3d:
      case reshade::api::resource_view_type::texture_cube:
      case reshade::api::resource_view_type::texture_cube_array:
        texture = TextureViewSummary{
            .first_level = resource_view_desc.texture.first_level,
            .level_count = resource_view_desc.texture.level_count,
            .first_layer = resource_view_desc.texture.first_layer,
            .layer_count = resource_view_desc.texture.layer_count,
        };
        break;
    }
  }
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const ViewSummary& value) {
  j = {
      {"type", value.type},
      {"format", value.format},
  };
  if (value.buffer.has_value()) {
    j["buffer"] = value.buffer.value();
  }
  if (value.texture.has_value()) {
    j["texture"] = value.texture.value();
  }
}

struct ResourceSummary {
  std::string type;
  std::optional<std::uint64_t> size_bytes = std::nullopt;
  std::optional<std::string> format = std::nullopt;
  std::optional<std::uint32_t> width = std::nullopt;
  std::optional<std::uint32_t> height = std::nullopt;
  std::optional<std::uint32_t> depth_or_layers = std::nullopt;
  std::optional<std::uint32_t> levels = std::nullopt;
  std::optional<std::uint32_t> samples = std::nullopt;

  ResourceSummary() = default;

  explicit ResourceSummary(const reshade::api::resource_desc& resource_desc)
      : type(formatting::StreamToString(resource_desc.type)) {
    switch (resource_desc.type) {
      default:
      case reshade::api::resource_type::unknown:
        break;
      case reshade::api::resource_type::buffer:
        size_bytes = resource_desc.buffer.size;
        break;
      case reshade::api::resource_type::texture_1d:
      case reshade::api::resource_type::texture_2d:
      case reshade::api::resource_type::surface:
      case reshade::api::resource_type::texture_3d:
        format = formatting::StreamToString(resource_desc.texture.format);
        width = resource_desc.texture.width;
        height = resource_desc.texture.height;
        depth_or_layers = resource_desc.texture.depth_or_layers;
        levels = resource_desc.texture.levels;
        samples = resource_desc.texture.samples;
        break;
    }
  }
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const ResourceSummary& value) {
  j = {
      {"type", value.type},
  };
  if (value.size_bytes.has_value()) {
    j["sizeBytes"] = value.size_bytes.value();
  }
  if (value.format.has_value()) {
    j["format"] = value.format.value();
  }
  if (value.width.has_value()) {
    j["width"] = value.width.value();
  }
  if (value.height.has_value()) {
    j["height"] = value.height.value();
  }
  if (value.depth_or_layers.has_value()) {
    j["depthOrLayers"] = value.depth_or_layers.value();
  }
  if (value.levels.has_value()) {
    j["levels"] = value.levels.value();
  }
  if (value.samples.has_value()) {
    j["samples"] = value.samples.value();
  }
}

struct ModSummary {
  bool is_swapchain = false;
  bool is_render_target_upgraded = false;
  bool is_resource_upgraded = false;
  bool is_render_target_cloned = false;
  bool is_resource_cloned = false;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const ModSummary& value) {
  j = {
      {"isSwapchain", value.is_swapchain},
      {"isRenderTargetUpgraded", value.is_render_target_upgraded},
      {"isResourceUpgraded", value.is_resource_upgraded},
      {"isRenderTargetCloned", value.is_render_target_cloned},
      {"isResourceCloned", value.is_resource_cloned},
  };
}

struct CloneSummary {
  std::optional<std::string> resource_view_handle = std::nullopt;
  std::optional<std::string> resource_handle = std::nullopt;
  ViewSummary view;
  ResourceSummary resource;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const CloneSummary& value) {
  j = {
      {"resourceViewHandle", value.resource_view_handle.has_value() ? json(value.resource_view_handle.value()) : json(nullptr)},
      {"resourceHandle", value.resource_handle.has_value() ? json(value.resource_handle.value()) : json(nullptr)},
      {"view", value.view},
      {"resource", value.resource},
  };
}

struct ResourceViewSummary {
  std::string resource_view_handle;
  std::optional<std::string> resource_view_reflection = std::nullopt;
  ViewSummary view;
  std::optional<std::string> resource_handle = std::nullopt;
  std::optional<std::string> resource_reflection = std::nullopt;
  ResourceSummary resource;
  ModSummary mod;
  std::optional<CloneSummary> clone = std::nullopt;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const ResourceViewSummary& value) {
  j = {
      {"resourceViewHandle", value.resource_view_handle},
      {"resourceViewReflection", value.resource_view_reflection.has_value() ? json(value.resource_view_reflection.value()) : json(nullptr)},
      {"view", value.view},
      {"resourceHandle", value.resource_handle.has_value() ? json(value.resource_handle.value()) : json(nullptr)},
      {"resourceReflection", value.resource_reflection.has_value() ? json(value.resource_reflection.value()) : json(nullptr)},
      {"resource", value.resource},
      {"mod", value.mod},
      {"clone", value.clone.has_value() ? json(value.clone.value()) : json(nullptr)},
  };
}

}  // namespace renodx::addons::devkit::mcp::resource_view_summary
