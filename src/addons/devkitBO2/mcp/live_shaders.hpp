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
#include "./shader_hash.hpp"

namespace renodx::addons::devkit::mcp::live_shaders {

using json = renodx::utils::mcp::json;
using ToolResult = renodx::utils::mcp::ToolResult;
namespace mcp_arguments = renodx::utils::mcp::arguments;

struct ToolContext {
  std::function<std::uint32_t(const json& arguments)> resolve_device_index;
  std::function<ToolResult(std::uint32_t device_index, std::uint32_t shader_hash, const std::optional<std::string>& output_path)> dump_shader;
  std::function<ToolResult(const std::optional<std::string>& live_path)> set_live_shader_path;
  std::function<ToolResult(std::uint32_t device_index)> load_live_shaders;
  std::function<ToolResult(std::uint32_t device_index)> unload_live_shaders;
};

inline ToolResult HandleDumpShaderTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.dump_shader) {
    throw std::runtime_error("The live shader tool context is not configured.");
  }

  const auto device_index = context.resolve_device_index(arguments);
  const auto shader_hash = shader_hash::GetRequired(arguments, "shaderHash");
  const auto output_path = mcp_arguments::GetOptional<std::string>(arguments, "outputPath");
  return context.dump_shader(device_index, shader_hash, output_path);
}

inline ToolResult HandleSetLiveShaderPathTool(const json& arguments, const ToolContext& context) {
  if (!context.set_live_shader_path) {
    throw std::runtime_error("The live shader tool context is not configured.");
  }

  const auto live_path = mcp_arguments::GetOptional<std::string>(arguments, "path");
  return context.set_live_shader_path(live_path);
}

inline ToolResult HandleLoadLiveShadersTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.load_live_shaders) {
    throw std::runtime_error("The live shader tool context is not configured.");
  }

  return context.load_live_shaders(context.resolve_device_index(arguments));
}

inline ToolResult HandleUnloadLiveShadersTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.unload_live_shaders) {
    throw std::runtime_error("The live shader tool context is not configured.");
  }

  return context.unload_live_shaders(context.resolve_device_index(arguments));
}

}  // namespace renodx::addons::devkit::mcp::live_shaders
