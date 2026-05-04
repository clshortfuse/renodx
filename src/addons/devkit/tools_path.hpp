/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <filesystem>
#include <format>
#include <optional>
#include <string>
#include <string_view>

#include <include/reshade.hpp>

#include "../../utils/mcp/types.hpp"
#include "../../utils/path.hpp"
#include "../../utils/shader_compiler_directx.hpp"

namespace renodx::addons::devkit::tools_path {

using json = renodx::utils::mcp::json;
using ToolResult = renodx::utils::mcp::ToolResult;

struct Status {
  std::filesystem::path configured_path;
  bool has_dxcompiler_dll = false;
  bool has_cmd_decompiler = false;
  bool has_dxil_spirv = false;
  bool has_spirv_cross = false;
};

[[nodiscard]] inline std::string TrimTrailingWhitespace(std::string value) {
  const auto pos = value.find_last_not_of("\t\n\v\f\r ");
  if (pos == std::string_view::npos) {
    return {};
  }
  value.resize(pos + 1);
  return value;
}

[[nodiscard]] inline Status GetStatus() {
  Status status = {
      .configured_path = renodx::utils::shader::compiler::directx::GetToolsPath(),
  };
  if (status.configured_path.empty()) {
    return status;
  }

  status.has_dxcompiler_dll = renodx::utils::path::CheckExistsFile(status.configured_path / "dxcompiler.dll");
  status.has_cmd_decompiler = renodx::utils::path::CheckExistsFile(status.configured_path / "cmd_Decompiler.exe");
  status.has_dxil_spirv = renodx::utils::path::CheckExistsFile(status.configured_path / "dxil-spirv.exe");
  status.has_spirv_cross = renodx::utils::path::CheckExistsFile(status.configured_path / "spirv-cross.exe");

  return status;
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const Status& status) {
  j = {
      {"configuredPath", status.configured_path.empty() ? json(nullptr) : json(status.configured_path.string())},
      {"hasDxcompilerDll", status.has_dxcompiler_dll},
      {"hasCmdDecompiler", status.has_cmd_decompiler},
      {"hasDxilSpirv", status.has_dxil_spirv},
      {"hasSpirvCross", status.has_spirv_cross},
  };
}

[[nodiscard]] inline ToolResult SetToolsPath(const std::optional<std::string>& tools_path) {
  if (tools_path.has_value()) {
    const auto trimmed_path = TrimTrailingWhitespace(*tools_path);
    renodx::utils::shader::compiler::directx::SetToolsPath(trimmed_path);
    reshade::set_config_value(nullptr, "renodx-dev", "ToolsPath", trimmed_path.c_str());
  }

  const auto status = GetStatus();
  if (status.configured_path.empty()) {
    return ToolResult{
        .text = "No devkit tools directory is configured. DXC will use the process DLL search path.",
        .structured_content = status,
    };
  }

  return ToolResult{
      .text = tools_path.has_value()
                  ? std::format("Set the devkit tools directory to '{}'.", status.configured_path.string())
                  : std::format("The devkit tools directory is '{}'.", status.configured_path.string()),
      .structured_content = status,
  };
}

}  // namespace renodx::addons::devkit::tools_path
