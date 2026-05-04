/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>
#include <functional>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>

#include "../../../utils/mcp/types.hpp"
#include "../../../utils/mcp/arguments.hpp"
#include "../../../utils/resource.hpp"
#include "../formatting.hpp"
#include "./resource_handle.hpp"

namespace renodx::addons::devkit::mcp::resource_clone {

using json = renodx::utils::mcp::json;
using ToolResult = renodx::utils::mcp::ToolResult;
namespace mcp_arguments = renodx::utils::mcp::arguments;

struct ToolContext {
  std::function<std::uint32_t(const json& arguments)> resolve_device_index;
  std::function<ToolResult(std::uint32_t device_index, std::uint64_t resource_handle, bool enabled)> set_resource_clone;
};

struct TrackedResourceSummary {
  std::string resource_handle;
  std::string resource_type;
  std::string format;
  bool clone_enabled = false;
  bool has_clone = false;
  std::optional<std::string> clone_handle = std::nullopt;
  bool destroyed = false;
  bool upgraded = false;
  bool is_clone = false;
  bool is_swapchain = false;
  std::optional<std::string> clone_target_name = std::nullopt;
  std::optional<std::string> clone_format = std::nullopt;

  TrackedResourceSummary() = default;

  explicit TrackedResourceSummary(const renodx::utils::resource::ResourceInfo& info)
      : resource_handle(formatting::FormatHandle(info.resource.handle)),
        resource_type(formatting::StreamToString(info.desc.type)),
        format(formatting::StreamToString(info.desc.texture.format)),
        clone_enabled(info.clone_enabled),
        has_clone(info.clone.handle != 0u),
        clone_handle(info.clone.handle == 0u
                         ? std::nullopt
                         : std::optional<std::string>(formatting::FormatHandle(info.clone.handle))),
        destroyed(info.destroyed),
        upgraded(info.upgraded),
        is_clone(info.is_clone),
        is_swapchain(info.is_swap_chain),
        clone_target_name(
            info.clone_target == nullptr || info.clone_target->name.empty()
                ? std::nullopt
                : std::optional<std::string>(info.clone_target->name)),
        clone_format(
            info.clone_target == nullptr
                ? std::nullopt
                : std::optional<std::string>(formatting::StreamToString(info.clone_target->new_format))) {}
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const TrackedResourceSummary& value) {
  j = {
      {"resourceHandle", value.resource_handle},
      {"resourceType", value.resource_type},
      {"format", value.format},
      {"cloneEnabled", value.clone_enabled},
      {"hasClone", value.has_clone},
      {"cloneHandle", value.clone_handle.has_value() ? json(value.clone_handle.value()) : json(nullptr)},
      {"destroyed", value.destroyed},
      {"upgraded", value.upgraded},
      {"isClone", value.is_clone},
      {"isSwapchain", value.is_swapchain},
      {"cloneTargetName", value.clone_target_name.has_value() ? json(value.clone_target_name.value()) : json(nullptr)},
      {"cloneFormat", value.clone_format.has_value() ? json(value.clone_format.value()) : json(nullptr)},
  };
}

inline ToolResult HandleSetResourceCloneTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.set_resource_clone) {
    throw std::runtime_error("The resource clone tool context is not configured.");
  }

  const auto device_index = context.resolve_device_index(arguments);
  const auto resource_handle = resource_handle::GetRequired(arguments, "resourceHandle");
  const auto enabled = mcp_arguments::GetRequired<bool>(arguments, "enabled");
  return context.set_resource_clone(device_index, resource_handle, enabled);
}

}  // namespace renodx::addons::devkit::mcp::resource_clone
