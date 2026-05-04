/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <vector>

#include "../../../utils/mcp/types.hpp"
#include "draw_summary.hpp"

namespace renodx::addons::devkit::mcp::shader_summary {

using json = renodx::utils::mcp::json;

struct DiskShaderSummary {
  std::string path;
  bool compilation_ok = false;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const DiskShaderSummary& value) {
  j = {
      {"path", value.path},
      {"isCompilationOk", value.compilation_ok},
  };
}

struct TrackedShaderSummary {
  std::string hash;
  std::uint32_t hash_value = 0u;
  std::string stage;
  std::string source;
  std::size_t shader_data_size = 0u;
  bool has_addon_shader = false;
  bool has_disk_shader = false;
  bool bypass_draw = false;
  std::string entrypoint;
  std::optional<std::string> program_version = std::nullopt;
  std::optional<std::size_t> resource_bind_count = std::nullopt;
  std::optional<std::vector<draw_summary::ResourceBindSummary>> resource_binds = std::nullopt;
  std::optional<DiskShaderSummary> disk_shader = std::nullopt;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const TrackedShaderSummary& value) {
  j = {
      {"hash", value.hash},
      {"hashValue", value.hash_value},
      {"stage", value.stage},
      {"source", value.source},
      {"shaderDataSize", value.shader_data_size},
      {"hasAddonShader", value.has_addon_shader},
      {"hasDiskShader", value.has_disk_shader},
      {"bypassDraw", value.bypass_draw},
      {"entrypoint", value.entrypoint},
  };
  if (value.program_version.has_value()) {
    j["programVersion"] = value.program_version.value();
  }
  if (value.resource_bind_count.has_value()) {
    j["resourceBindCount"] = value.resource_bind_count.value();
  }
  if (value.resource_binds.has_value()) {
    j["resourceBinds"] = value.resource_binds.value();
  }
  if (value.disk_shader.has_value()) {
    j["diskShader"] = value.disk_shader.value();
  }
}

}  // namespace renodx::addons::devkit::mcp::shader_summary
