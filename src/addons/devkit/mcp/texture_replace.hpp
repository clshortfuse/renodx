/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>
#include <filesystem>
#include <format>
#include <functional>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include "../../../utils/mcp/types.hpp"
#include "../../../utils/mcp/arguments.hpp"
#include "../../../utils/resource_replace.hpp"
#include "../formatting.hpp"

namespace renodx::addons::devkit::mcp::texture_replace {

using json = renodx::utils::mcp::json;
using ToolResult = renodx::utils::mcp::ToolResult;
namespace mcp_arguments = renodx::utils::mcp::arguments;
namespace resource_replace = renodx::utils::resource::replace;

struct ToolContext {
  std::function<std::uint32_t(const json& arguments)> resolve_device_index;
  std::function<ToolResult(bool enabled)> set_enabled;
  std::function<ToolResult()> reload_boot_cache;
  std::function<ToolResult(std::uint32_t device_index, const std::vector<resource_replace::ResourceReplaceRule>& rules)> set_rules;
  std::function<ToolResult(std::uint32_t device_index)> get_state;
  std::function<ToolResult(std::uint32_t device_index, std::uint32_t limit, std::uint32_t offset)> list_observations;
  std::function<ToolResult(std::uint32_t device_index)> clear_observations;
  std::function<ToolResult(std::uint32_t device_index, std::uint32_t observation_index, const std::filesystem::path& output_path)>
      dump_observation;
};

inline std::uint32_t ParseUploadPathName(std::string_view name) {
  if (name == "create_resource") return static_cast<std::uint32_t>(resource_replace::UploadPath::CREATE_RESOURCE);
  if (name == "update_texture_region") return static_cast<std::uint32_t>(resource_replace::UploadPath::UPDATE_TEXTURE_REGION);
  if (name == "copy_buffer_to_texture") return static_cast<std::uint32_t>(resource_replace::UploadPath::COPY_BUFFER_TO_TEXTURE);
  throw std::runtime_error(std::format("Unknown upload path '{}'.", std::string(name)));
}

inline std::uint32_t ParseUploadPaths(const json& input) {
  if (input.is_number_integer() || input.is_number_unsigned()) {
    return mcp_arguments::ParseRequired<std::uint32_t>(input, "uploadPaths");
  }
  if (!input.is_array()) {
    throw std::runtime_error("uploadPaths must be an integer bitmask or an array of strings.");
  }
  std::uint32_t bitmask = 0u;
  for (const auto& item : input) {
    if (!item.is_string()) {
      throw std::runtime_error("uploadPaths items must be strings.");
    }
    bitmask |= ParseUploadPathName(item.get<std::string>());
  }
  return bitmask;
}

inline resource_replace::ResourceReplaceRule ParseRuleObject(const json& object) {
  if (!object.is_object()) {
    throw std::runtime_error("Each rules entry must be an object.");
  }

  resource_replace::ResourceReplaceRule rule = {};
  rule.name = mcp_arguments::GetOptional<std::string>(object, "name").value_or("");
  rule.enabled = mcp_arguments::GetOptional<bool>(object, "enabled").value_or(true);
  rule.subresource = mcp_arguments::GetOptional<std::uint32_t>(object, "subresource").value_or(0u);
  rule.require_full_update = mcp_arguments::GetOptional<bool>(object, "requireFullUpdate").value_or(true);
  rule.require_upload_heap_source = mcp_arguments::GetOptional<bool>(object, "requireUploadHeapSource").value_or(true);
  rule.allow_dynamic = mcp_arguments::GetOptional<bool>(object, "allowDynamic").value_or(false);
  rule.allow_multisampled = mcp_arguments::GetOptional<bool>(object, "allowMultisampled").value_or(false);
  rule.width = mcp_arguments::GetOptional<std::int32_t>(object, "width").value_or(resource_replace::ANY_DIMENSION);
  rule.height = mcp_arguments::GetOptional<std::int32_t>(object, "height").value_or(resource_replace::ANY_DIMENSION);
  rule.depth_or_layers = mcp_arguments::GetOptional<std::int32_t>(object, "depthOrLayers").value_or(resource_replace::ANY_DIMENSION);

  if (const auto* upload_paths = mcp_arguments::FindValue(object, "uploadPaths");
      upload_paths != nullptr && !upload_paths->is_null()) {
    rule.upload_paths = ParseUploadPaths(*upload_paths);
  }

  if (const auto format = mcp_arguments::GetOptional<std::uint32_t>(object, "format"); format.has_value()) {
    rule.format = static_cast<reshade::api::format>(format.value());
  }
  if (const auto usage_include = mcp_arguments::GetOptional<std::uint32_t>(object, "usageInclude"); usage_include.has_value()) {
    rule.usage_include = static_cast<reshade::api::resource_usage>(usage_include.value());
  }
  if (const auto usage_exclude = mcp_arguments::GetOptional<std::uint32_t>(object, "usageExclude"); usage_exclude.has_value()) {
    rule.usage_exclude = static_cast<reshade::api::resource_usage>(usage_exclude.value());
  }
  return rule;
}

inline json RuleToJson(const resource_replace::ResourceReplaceRule& rule) {
  return json{
      {"name", rule.name},
      {"enabled", rule.enabled},
      {"uploadPaths", rule.upload_paths},
      {"subresource", rule.subresource},
      {"requireFullUpdate", rule.require_full_update},
      {"requireUploadHeapSource", rule.require_upload_heap_source},
      {"format", static_cast<std::uint32_t>(rule.format)},
      {"formatName", formatting::StreamToString(rule.format)},
      {"usageInclude", static_cast<std::uint32_t>(rule.usage_include)},
      {"usageExclude", static_cast<std::uint32_t>(rule.usage_exclude)},
      {"width", rule.width},
      {"height", rule.height},
      {"depthOrLayers", rule.depth_or_layers},
      {"allowDynamic", rule.allow_dynamic},
      {"allowMultisampled", rule.allow_multisampled},
  };
}

inline ToolResult HandleSetTextureReplaceEnabledTool(const json& arguments, const ToolContext& context) {
  if (!context.set_enabled) {
    throw std::runtime_error("Texture replace tool context is not configured.");
  }
  const auto enabled = mcp_arguments::GetRequired<bool>(arguments, "enabled");
  return context.set_enabled(enabled);
}

inline ToolResult HandleReloadBootTextureCacheTool([[maybe_unused]] const json& arguments, const ToolContext& context) {
  if (!context.reload_boot_cache) {
    throw std::runtime_error("Texture replace tool context is not configured.");
  }
  return context.reload_boot_cache();
}

inline ToolResult HandleSetTextureReplaceRulesTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.set_rules) {
    throw std::runtime_error("Texture replace tool context is not configured.");
  }
  const auto* rules_value = mcp_arguments::FindValue(arguments, "rules");
  if (rules_value == nullptr || rules_value->is_null() || !rules_value->is_array()) {
    throw std::runtime_error("rules is required and must be an array.");
  }

  std::vector<resource_replace::ResourceReplaceRule> rules = {};
  rules.reserve(rules_value->size());
  for (const auto& rule_json : *rules_value) {
    rules.push_back(ParseRuleObject(rule_json));
  }

  const auto device_index = context.resolve_device_index(arguments);
  return context.set_rules(device_index, rules);
}

inline ToolResult HandleGetTextureReplaceStateTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.get_state) {
    throw std::runtime_error("Texture replace tool context is not configured.");
  }
  const auto device_index = context.resolve_device_index(arguments);
  return context.get_state(device_index);
}

inline ToolResult HandleListTextureReplaceObservationsTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.list_observations) {
    throw std::runtime_error("Texture replace tool context is not configured.");
  }
  const auto device_index = context.resolve_device_index(arguments);
  const auto limit = mcp_arguments::GetOptional<std::uint32_t>(arguments, "limit").value_or(200u);
  const auto offset = mcp_arguments::GetOptional<std::uint32_t>(arguments, "offset").value_or(0u);
  return context.list_observations(device_index, limit, offset);
}

inline ToolResult HandleClearTextureReplaceObservationsTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.clear_observations) {
    throw std::runtime_error("Texture replace tool context is not configured.");
  }
  const auto device_index = context.resolve_device_index(arguments);
  return context.clear_observations(device_index);
}

inline ToolResult HandleDumpTextureReplaceObservationTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.dump_observation) {
    throw std::runtime_error("Texture replace tool context is not configured.");
  }
  const auto device_index = context.resolve_device_index(arguments);
  const auto observation_index = mcp_arguments::GetRequired<std::uint32_t>(arguments, "observationIndex");
  const auto output_path = mcp_arguments::GetRequired<std::string>(arguments, "outputPath");
  if (output_path.empty()) {
    throw std::runtime_error("outputPath must not be empty.");
  }
  auto path = std::filesystem::path(output_path);
  if (!path.is_absolute()) {
    throw std::runtime_error("outputPath must be an absolute path.");
  }
  path = path.lexically_normal();
  return context.dump_observation(device_index, observation_index, path);
}

}  // namespace renodx::addons::devkit::mcp::texture_replace
