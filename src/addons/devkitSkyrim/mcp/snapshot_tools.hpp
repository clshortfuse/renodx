/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cctype>
#include <cstddef>
#include <cstdint>
#include <format>
#include <functional>
#include <limits>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include "../../../utils/mcp/types.hpp"
#include "../../../utils/mcp/arguments.hpp"
#include "../../../utils/build_info.hpp"
#include "device_summary.hpp"
#include "device_selection.hpp"
#include "draw_summary.hpp"
#include "shader_summary.hpp"
#include "snapshot_summary.hpp"

namespace renodx::addons::devkit::mcp::snapshot_tools {

using json = renodx::utils::mcp::json;
using ToolResult = renodx::utils::mcp::ToolResult;
namespace mcp_arguments = renodx::utils::mcp::arguments;

struct ToolContext {
  std::function<std::size_t()> get_device_count;
  std::function<std::uint32_t()> get_selected_device_index;
  std::function<void(std::uint32_t)> set_selected_device_index;
  std::function<std::string()> get_pipe_name;
  std::function<bool()> is_connected;
  std::function<bool()> has_active_snapshot;
  std::function<bool()> has_queued_snapshot;
  std::function<bool(std::uint32_t)> is_snapshot_active;
  std::function<bool(std::uint32_t)> is_snapshot_queued;
  std::function<device_summary::DeviceSummary(std::uint32_t index, bool is_selected)> build_device_summary;
  std::function<std::vector<shader_summary::TrackedShaderSummary>(
      std::uint32_t device_index,
      const std::optional<std::string>& stage_filter)>
      list_shaders;
  std::function<std::vector<draw_summary::DrawSummary>(std::uint32_t device_index)> list_draws;
  std::function<draw_summary::DrawSummary(std::uint32_t device_index, std::uint32_t draw_index)> get_draw;
  std::function<snapshot_summary::SnapshotSummary(std::uint32_t device_index)> build_snapshot_summary;
  std::function<ToolResult(std::uint32_t device_index)> queue_snapshot;
};

namespace internal {

[[nodiscard]] inline std::string ToLowerAscii(std::string_view value) {
  std::string lowered;
  lowered.reserve(value.size());
  for (const auto character : value) {
    lowered.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(character))));
  }
  return lowered;
}

[[nodiscard]] inline bool EqualsInsensitive(std::string_view left, std::string_view right) {
  return ToLowerAscii(left) == ToLowerAscii(right);
}

struct DrawFilters {
  std::optional<std::string> method = std::nullopt;
  std::optional<std::string> shader_hash = std::nullopt;
  std::optional<std::string> active_shader_stage = std::nullopt;
  std::optional<std::uint32_t> min_srv_count = std::nullopt;
  std::optional<std::uint32_t> min_uav_count = std::nullopt;
  std::optional<std::uint32_t> min_constant_count = std::nullopt;
  std::optional<std::uint32_t> min_render_target_count = std::nullopt;
  std::optional<std::uint32_t> min_pipeline_count = std::nullopt;
};

[[nodiscard]] inline DrawFilters ParseDrawFilters(const json& arguments) {
  const auto parse_min_filter = [&arguments](std::string_view key) {
    const auto value = mcp_arguments::GetOptional<std::uint32_t>(arguments, key);
    if (!value.has_value()) return value;
    return std::optional<std::uint32_t>(mcp_arguments::ValidateRange(
        key,
        value.value(),
        0u,
        (std::numeric_limits<std::uint32_t>::max)()));
  };

  return DrawFilters{
      .method = mcp_arguments::GetOptional<std::string>(arguments, "method"),
      .shader_hash = mcp_arguments::GetOptional<std::string>(arguments, "shaderHash"),
      .active_shader_stage = mcp_arguments::GetOptional<std::string>(arguments, "activeShaderStage"),
      .min_srv_count = parse_min_filter("minSrvCount"),
      .min_uav_count = parse_min_filter("minUavCount"),
      .min_constant_count = parse_min_filter("minConstantCount"),
      .min_render_target_count = parse_min_filter("minRenderTargetCount"),
      .min_pipeline_count = parse_min_filter("minPipelineCount"),
  };
}

[[nodiscard]] inline bool MatchesDrawFilters(const draw_summary::DrawSummary& draw, const DrawFilters& filters) {
  if (filters.method.has_value() && !EqualsInsensitive(draw.method, filters.method.value())) {
    return false;
  }

  if (filters.shader_hash.has_value()) {
    const auto has_shader_hash = std::any_of(
        draw.shader_hashes.begin(),
        draw.shader_hashes.end(),
        [&filters](const std::string& shader_hash) {
          return EqualsInsensitive(shader_hash, filters.shader_hash.value());
        });
    if (!has_shader_hash) {
      return false;
    }
  }

  if (filters.active_shader_stage.has_value()) {
    if (!draw.active_shader_stage.has_value()) {
      return false;
    }
    if (!EqualsInsensitive(draw.active_shader_stage.value(), filters.active_shader_stage.value())) {
      return false;
    }
  }

  if (filters.min_srv_count.has_value() && draw.srv_count < filters.min_srv_count.value()) {
    return false;
  }
  if (filters.min_uav_count.has_value() && draw.uav_count < filters.min_uav_count.value()) {
    return false;
  }
  if (filters.min_constant_count.has_value() && draw.constant_count < filters.min_constant_count.value()) {
    return false;
  }
  if (filters.min_render_target_count.has_value() && draw.render_target_count < filters.min_render_target_count.value()) {
    return false;
  }
  if (filters.min_pipeline_count.has_value() && draw.pipeline_count < filters.min_pipeline_count.value()) {
    return false;
  }

  return true;
}

[[nodiscard]] inline std::uint32_t ResolveDeviceIndex(const json& arguments, const ToolContext& context) {
  if (!context.get_device_count || !context.get_selected_device_index) {
    throw std::runtime_error("The snapshot tool context is not configured.");
  }

  const auto device_count = context.get_device_count();
  const auto selected_index = device_count == 0u
                                  ? 0u
                                  : std::min<std::uint32_t>(
                                        context.get_selected_device_index(),
                                        static_cast<std::uint32_t>(device_count - 1u));
  return device_selection::ResolveRequestedDeviceIndex(arguments, device_count, selected_index);
}

}  // namespace internal

inline ToolResult HandleStatusTool([[maybe_unused]] const json& arguments, const ToolContext& context) {
  if (!context.get_device_count || !context.get_selected_device_index || !context.build_device_summary) {
    throw std::runtime_error("The snapshot tool context is not configured.");
  }

  const auto device_count = context.get_device_count();
  const auto selected_index = device_count == 0u
                                  ? 0u
                                  : std::min<std::uint32_t>(
                                        context.get_selected_device_index(),
                                        static_cast<std::uint32_t>(device_count - 1u));

  std::vector<device_summary::DeviceSummary> devices;
  devices.reserve(device_count);
  for (std::uint32_t index = 0u; index < device_count; ++index) {
    devices.emplace_back(context.build_device_summary(index, index == selected_index));
  }

  json result = {
      {"pipeName", context.get_pipe_name ? json(context.get_pipe_name()) : json(nullptr)},
      {"serverInfo", {
                 {"name", "renodx-devkit"},
                 {"title", "RenoDX DevKit"},
                 {"version", std::string(renodx::build_info::kBuildVersion)},
               }},
      {"connected", context.is_connected ? context.is_connected() : false},
      {"deviceCount", device_count},
      {"devices", devices},
      {"selectedDeviceIndex", device_count == 0u ? json(nullptr) : json(selected_index)},
      {"snapshot", {
                       {"active", context.has_active_snapshot ? context.has_active_snapshot() : false},
                       {"queued", context.has_queued_snapshot ? context.has_queued_snapshot() : false},
                   }},
  };

  if (renodx::build_info::HasKnownBuildTimestamp()) {
    result["serverInfo"]["buildTimestampUtc"] = renodx::build_info::kBuildTimestampUtc;
  }
  if (renodx::build_info::HasKnownSourceDateEpoch()) {
    result["serverInfo"]["sourceDateEpoch"] = renodx::build_info::kSourceDateEpoch;
  }

  if (device_count == 0u) {
    return ToolResult{
        .text = "No devices are currently tracked by devkit.",
        .structured_content = result,
    };
  }

  const auto& selected_device = devices[selected_index];
  auto text = std::format(
      "Tracking {} device(s). Selected device #{} ({}) has {} tracked shaders and {} captured draws.",
      device_count,
      selected_index,
      selected_device.api,
      selected_device.tracked_shaders,
      selected_device.captured_draws);
  return ToolResult{
      .text = text,
      .structured_content = result,
  };
}

inline ToolResult HandleSelectDeviceTool(const json& arguments, const ToolContext& context) {
  if (!context.set_selected_device_index || !context.build_device_summary) {
    throw std::runtime_error("The snapshot tool context is not configured.");
  }
  if (!arguments.contains("deviceIndex")) {
    throw std::runtime_error("deviceIndex is required.");
  }

  const auto device_index = internal::ResolveDeviceIndex(arguments, context);
  context.set_selected_device_index(device_index);
  const auto result = context.build_device_summary(device_index, true);
  auto text = std::format(
      "Selected device #{} ({}) for subsequent devkit tools.",
      device_index,
      result.api);
  return ToolResult{
      .text = text,
      .structured_content = result,
  };
}

inline ToolResult HandleListShadersTool(const json& arguments, const ToolContext& context) {
  if (!context.list_shaders) {
    throw std::runtime_error("The snapshot tool context is not configured.");
  }

  const auto limit = mcp_arguments::ValidateRange(
      "limit",
      mcp_arguments::GetOptional<std::uint32_t>(arguments, "limit").value_or(200u),
      1u,
      5000u);
  const auto offset = mcp_arguments::ValidateRange(
      "offset",
      mcp_arguments::GetOptional<std::uint32_t>(arguments, "offset").value_or(0u),
      0u,
      (std::numeric_limits<std::uint32_t>::max)());

  const auto stage_filter = mcp_arguments::GetOptional<std::string>(arguments, "stage");

  const auto device_index = internal::ResolveDeviceIndex(arguments, context);
  auto shaders = context.list_shaders(device_index, stage_filter);
  const auto total_count = shaders.size();
  const auto clamped_offset = std::min<std::size_t>(offset, total_count);
  const auto end_index = std::min<std::size_t>(clamped_offset + limit, total_count);

  std::vector<shader_summary::TrackedShaderSummary> paged_shaders;
  paged_shaders.reserve(end_index - clamped_offset);
  for (std::size_t index = clamped_offset; index < end_index; ++index) {
    paged_shaders.push_back(shaders[index]);
  }

  json result = {
      {"deviceIndex", device_index},
      {"totalTracked", total_count},
      {"offset", clamped_offset},
      {"limit", limit},
      {"returned", paged_shaders.size()},
      {"shaders", paged_shaders},
  };
  if (stage_filter.has_value()) {
    result["stage"] = stage_filter.value();
  }

  auto text = std::format(
      "Returned {} shader(s) from device #{} (offset {} of {}).",
      paged_shaders.size(),
      device_index,
      clamped_offset,
      total_count);
  return ToolResult{
      .text = text,
      .structured_content = result,
  };
}

inline ToolResult HandleListDrawsTool(const json& arguments, const ToolContext& context) {
  if (!context.list_draws) {
    throw std::runtime_error("The snapshot tool context is not configured.");
  }

  const auto limit = mcp_arguments::ValidateRange(
      "limit",
      mcp_arguments::GetOptional<std::uint32_t>(arguments, "limit").value_or(100u),
      1u,
      1000u);
  const auto offset = mcp_arguments::ValidateRange(
      "offset",
      mcp_arguments::GetOptional<std::uint32_t>(arguments, "offset").value_or(0u),
      0u,
      (std::numeric_limits<std::uint32_t>::max)());
  const auto filters = internal::ParseDrawFilters(arguments);
  const auto device_index = internal::ResolveDeviceIndex(arguments, context);
  auto draws = context.list_draws(device_index);
  const auto total_draws = draws.size();

  std::vector<draw_summary::DrawSummary> filtered_draws;
  filtered_draws.reserve(draws.size());
  std::copy_if(
      draws.begin(),
      draws.end(),
      std::back_inserter(filtered_draws),
      [&filters](const draw_summary::DrawSummary& draw) {
        return internal::MatchesDrawFilters(draw, filters);
      });

  const auto total_filtered_draws = filtered_draws.size();
  const auto clamped_offset = std::min<std::size_t>(offset, total_filtered_draws);
  const auto end_index = std::min<std::size_t>(clamped_offset + limit, total_filtered_draws);

  std::vector<draw_summary::DrawSummary> paged_draws;
  paged_draws.reserve(end_index - clamped_offset);
  for (std::size_t index = clamped_offset; index < end_index; ++index) {
    paged_draws.push_back(filtered_draws[index]);
  }

  json result = {
      {"deviceIndex", device_index},
      {"totalDraws", total_draws},
      {"totalFilteredDraws", total_filtered_draws},
      {"offset", clamped_offset},
      {"limit", limit},
      {"returned", paged_draws.size()},
      {"draws", paged_draws},
  };
  if (filters.method.has_value()
      || filters.shader_hash.has_value()
      || filters.active_shader_stage.has_value()
      || filters.min_srv_count.has_value()
      || filters.min_uav_count.has_value()
      || filters.min_constant_count.has_value()
      || filters.min_render_target_count.has_value()
      || filters.min_pipeline_count.has_value()) {
    json filters_json = json::object();
    if (filters.method.has_value()) {
      filters_json["method"] = filters.method.value();
    }
    if (filters.shader_hash.has_value()) {
      filters_json["shaderHash"] = filters.shader_hash.value();
    }
    if (filters.active_shader_stage.has_value()) {
      filters_json["activeShaderStage"] = filters.active_shader_stage.value();
    }
    if (filters.min_srv_count.has_value()) {
      filters_json["minSrvCount"] = filters.min_srv_count.value();
    }
    if (filters.min_uav_count.has_value()) {
      filters_json["minUavCount"] = filters.min_uav_count.value();
    }
    if (filters.min_constant_count.has_value()) {
      filters_json["minConstantCount"] = filters.min_constant_count.value();
    }
    if (filters.min_render_target_count.has_value()) {
      filters_json["minRenderTargetCount"] = filters.min_render_target_count.value();
    }
    if (filters.min_pipeline_count.has_value()) {
      filters_json["minPipelineCount"] = filters.min_pipeline_count.value();
    }
    result["filters"] = filters_json;
  }

  auto text = std::format(
      "Returned {} draw(s) from device #{} after filtering (offset {} of {}; snapshot had {}).",
      paged_draws.size(),
      device_index,
      clamped_offset,
      total_filtered_draws,
      total_draws);
  return ToolResult{
      .text = text,
      .structured_content = result,
  };
}

inline ToolResult HandleGetDrawTool(const json& arguments, const ToolContext& context) {
  if (!context.get_draw) {
    throw std::runtime_error("The snapshot tool context is not configured.");
  }
  const auto draw_index = mcp_arguments::GetRequired<std::uint32_t>(arguments, "drawIndex");
  const auto device_index = internal::ResolveDeviceIndex(arguments, context);
  const auto draw = context.get_draw(device_index, draw_index);
  json result = draw;
  result["deviceIndex"] = device_index;

  auto text = std::format(
      "Returned draw #{} from device #{} with {} render target(s), {} SRV bind(s), and {} UAV bind(s).",
      draw_index,
      device_index,
      draw.render_target_count,
      draw.srv_count,
      draw.uav_count);
  return ToolResult{
      .text = text,
      .structured_content = result,
  };
}

inline ToolResult HandleSnapshotSummaryTool(const json& arguments, const ToolContext& context) {
  if (!context.build_snapshot_summary) {
    throw std::runtime_error("The snapshot tool context is not configured.");
  }

  const auto device_index = internal::ResolveDeviceIndex(arguments, context);
  const auto result = context.build_snapshot_summary(device_index);
  auto text = std::format(
      "Device #{} currently has {} captured draw(s) and {} tracked shader(s) in the active snapshot cache.",
      device_index,
      result.captured_draws,
      result.tracked_shaders);
  return ToolResult{
      .text = text,
      .structured_content = result,
  };
}

inline ToolResult HandleQueueSnapshotTool(const json& arguments, const ToolContext& context) {
  if (!context.queue_snapshot) {
    throw std::runtime_error("The snapshot tool context is not configured.");
  }

  return context.queue_snapshot(internal::ResolveDeviceIndex(arguments, context));
}

}  // namespace renodx::addons::devkit::mcp::snapshot_tools
