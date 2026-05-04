/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <functional>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>

#include "../../../utils/mcp/server.hpp"
#include "../../../utils/mcp/arguments.hpp"
#include "live_shaders.hpp"
#include "resource_analysis.hpp"
#include "resource_clone.hpp"
#include "shader_inspection.hpp"
#include "snapshot_tools.hpp"
#include "tool_catalog.hpp"

namespace renodx::addons::devkit::mcp::runtime {

struct RegistrationContext {
  std::function<snapshot_tools::ToolContext()> build_snapshot_tools_context;
  std::function<shader_inspection::ToolContext()> build_shader_inspection_tool_context;
  std::function<live_shaders::ToolContext()> build_live_shaders_tool_context;
  std::function<resource_analysis::ToolContext()> build_analyze_resource_tool_context;
  std::function<resource_clone::ToolContext()> build_resource_clone_tool_context;
  std::function<renodx::utils::mcp::ToolResult(const std::optional<std::string>&)> set_tools_path;
};

inline void RegisterTools(renodx::utils::mcp::Server& server, const RegistrationContext& context) {
  server.ClearTools();

  auto register_tool = [&server](std::string_view tool_name, const auto& handler) {
    const auto metadata_iterator = tool_catalog::METADATA.find(tool_name);
    if (metadata_iterator == tool_catalog::METADATA.end()) {
      throw std::logic_error("Unknown devkit MCP tool metadata");
    }

    const auto& metadata = metadata_iterator->second;
    server.RegisterTool(renodx::utils::mcp::Tool{
        .name = std::string(tool_name),
        .title = std::string(metadata.title),
        .description = std::string(metadata.description),
        .input_schema = metadata.input_schema,
        .annotations = metadata.annotations,
        .handler = handler,
    });
  };

  register_tool("devkit_status", [build_snapshot_tools_context = context.build_snapshot_tools_context](
                                      const renodx::utils::mcp::json& arguments) {
    return snapshot_tools::HandleStatusTool(arguments, build_snapshot_tools_context());
  });
  register_tool("devkit_select_device", [build_snapshot_tools_context = context.build_snapshot_tools_context](
                                             const renodx::utils::mcp::json& arguments) {
    return snapshot_tools::HandleSelectDeviceTool(arguments, build_snapshot_tools_context());
  });
  register_tool("devkit_list_shaders", [build_snapshot_tools_context = context.build_snapshot_tools_context](
                                            const renodx::utils::mcp::json& arguments) {
    return snapshot_tools::HandleListShadersTool(arguments, build_snapshot_tools_context());
  });
  register_tool("devkit_get_shader", [build_shader_inspection_tool_context = context.build_shader_inspection_tool_context](
                                         const renodx::utils::mcp::json& arguments) {
    return shader_inspection::HandleGetShaderTool(arguments, build_shader_inspection_tool_context());
  });
  register_tool("devkit_dump_shader", [build_live_shaders_tool_context = context.build_live_shaders_tool_context](
                                          const renodx::utils::mcp::json& arguments) {
    return live_shaders::HandleDumpShaderTool(arguments, build_live_shaders_tool_context());
  });
  register_tool("devkit_set_tools_path", [set_tools_path = context.set_tools_path](const renodx::utils::mcp::json& arguments) {
    const auto path = renodx::utils::mcp::arguments::GetOptional<std::string>(arguments, "path");
    return set_tools_path(path);
  });
  register_tool("devkit_set_live_shader_path", [build_live_shaders_tool_context = context.build_live_shaders_tool_context](
                                                    const renodx::utils::mcp::json& arguments) {
    return live_shaders::HandleSetLiveShaderPathTool(arguments, build_live_shaders_tool_context());
  });
  register_tool("devkit_load_live_shaders", [build_live_shaders_tool_context = context.build_live_shaders_tool_context](
                                                const renodx::utils::mcp::json& arguments) {
    return live_shaders::HandleLoadLiveShadersTool(arguments, build_live_shaders_tool_context());
  });
  register_tool("devkit_unload_live_shaders", [build_live_shaders_tool_context = context.build_live_shaders_tool_context](
                                                  const renodx::utils::mcp::json& arguments) {
    return live_shaders::HandleUnloadLiveShadersTool(arguments, build_live_shaders_tool_context());
  });
  register_tool("devkit_list_draws", [build_snapshot_tools_context = context.build_snapshot_tools_context](
                                          const renodx::utils::mcp::json& arguments) {
    return snapshot_tools::HandleListDrawsTool(arguments, build_snapshot_tools_context());
  });
  register_tool("devkit_get_draw", [build_snapshot_tools_context = context.build_snapshot_tools_context](
                                        const renodx::utils::mcp::json& arguments) {
    return snapshot_tools::HandleGetDrawTool(arguments, build_snapshot_tools_context());
  });
  register_tool("devkit_analyze_resource", [build_analyze_resource_tool_context = context.build_analyze_resource_tool_context](
                                               const renodx::utils::mcp::json& arguments) {
    return resource_analysis::HandleAnalyzeResourceTool(arguments, build_analyze_resource_tool_context());
  });
  register_tool("devkit_set_resource_clone", [build_resource_clone_tool_context = context.build_resource_clone_tool_context](
                                                 const renodx::utils::mcp::json& arguments) {
    return resource_clone::HandleSetResourceCloneTool(arguments, build_resource_clone_tool_context());
  });
  register_tool("devkit_snapshot_summary", [build_snapshot_tools_context = context.build_snapshot_tools_context](
                                               const renodx::utils::mcp::json& arguments) {
    return snapshot_tools::HandleSnapshotSummaryTool(arguments, build_snapshot_tools_context());
  });
  register_tool("devkit_queue_snapshot", [build_snapshot_tools_context = context.build_snapshot_tools_context](
                                             const renodx::utils::mcp::json& arguments) {
    return snapshot_tools::HandleQueueSnapshotTool(arguments, build_snapshot_tools_context());
  });
}

}  // namespace renodx::addons::devkit::mcp::runtime
