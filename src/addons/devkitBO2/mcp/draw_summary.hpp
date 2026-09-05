/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <vector>

#include "../../../utils/mcp/types.hpp"
#include "resource_view_summary.hpp"

namespace renodx::addons::devkit::mcp::draw_summary {

using json = renodx::utils::mcp::json;

struct ResourceBindSummary {
  std::string type;
  std::uint32_t slot = 0u;
  std::uint32_t space = 0u;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const ResourceBindSummary& value) {
  j = {
      {"type", value.type},
      {"slot", value.slot},
      {"space", value.space},
  };
}

struct SlotResourceBindingSummary {
  std::uint32_t slot = 0u;
  std::uint32_t space = 0u;
  bool used_by_active_shader = false;
  resource_view_summary::ResourceViewSummary resource_view;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const SlotResourceBindingSummary& value) {
  j = value.resource_view;
  j["slot"] = value.slot;
  j["space"] = value.space;
  j["usedByActiveShader"] = value.used_by_active_shader;
}

struct ConstantBufferSummary {
  std::uint32_t slot = 0u;
  std::uint32_t space = 0u;
  std::string buffer_handle;
  std::uint64_t offset = 0u;
  std::optional<std::uint64_t> size = std::nullopt;
  bool full_range = false;
  bool used_by_active_shader = false;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const ConstantBufferSummary& value) {
  j = {
      {"slot", value.slot},
      {"space", value.space},
      {"bufferHandle", value.buffer_handle},
      {"offset", value.offset},
      {"size", value.size.has_value() ? json(value.size.value()) : json(nullptr)},
      {"fullRange", value.full_range},
      {"usedByActiveShader", value.used_by_active_shader},
  };
}

struct PipelineBindSummary {
  std::string pipeline_handle;
  std::string stage;
  std::vector<std::string> shader_hashes;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const PipelineBindSummary& value) {
  j = {
      {"pipelineHandle", value.pipeline_handle},
      {"stage", value.stage},
      {"shaderHashes", value.shader_hashes},
  };
}

struct BlendAttachmentSummary {
  std::uint32_t rtv_index = 0u;
  bool blend_enable = false;
  bool logic_op_enable = false;
  std::string source_color_blend_factor;
  std::string dest_color_blend_factor;
  std::string color_blend_op;
  std::string source_alpha_blend_factor;
  std::string dest_alpha_blend_factor;
  std::string alpha_blend_op;
  std::string logic_op;
  std::uint32_t render_target_write_mask = 0u;
  std::string render_target_write_mask_hex;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const BlendAttachmentSummary& value) {
  j = {
      {"rtvIndex", value.rtv_index},
      {"blendEnable", value.blend_enable},
      {"logicOpEnable", value.logic_op_enable},
      {"sourceColorBlendFactor", value.source_color_blend_factor},
      {"destColorBlendFactor", value.dest_color_blend_factor},
      {"colorBlendOp", value.color_blend_op},
      {"sourceAlphaBlendFactor", value.source_alpha_blend_factor},
      {"destAlphaBlendFactor", value.dest_alpha_blend_factor},
      {"alphaBlendOp", value.alpha_blend_op},
      {"logicOp", value.logic_op},
      {"renderTargetWriteMask", value.render_target_write_mask},
      {"renderTargetWriteMaskHex", value.render_target_write_mask_hex},
  };
}

struct BlendStateSummary {
  bool alpha_to_coverage_enable = false;
  std::array<float, 4> blend_constant = {};
  std::vector<BlendAttachmentSummary> attachments;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const BlendStateSummary& value) {
  j = {
      {"alphaToCoverageEnable", value.alpha_to_coverage_enable},
      {"blendConstant", value.blend_constant},
      {"attachments", value.attachments},
  };
}

struct RenderTargetSummary {
  std::uint32_t rtv_index = 0u;
  resource_view_summary::ResourceViewSummary resource_view;
  std::optional<BlendAttachmentSummary> blend = std::nullopt;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const RenderTargetSummary& value) {
  j = value.resource_view;
  j["rtvIndex"] = value.rtv_index;
  if (value.blend.has_value()) {
    j["blend"] = value.blend.value();
  }
}

struct DrawSummary {
  std::size_t index = 0u;
  std::string method;
  std::int64_t timestamp_ms = 0;
  std::size_t srv_count = 0u;
  std::size_t uav_count = 0u;
  std::size_t constant_count = 0u;
  std::size_t render_target_count = 0u;
  std::size_t pipeline_count = 0u;
  std::vector<std::string> shader_hashes;
  std::optional<std::string> copy_source_handle = std::nullopt;
  std::optional<std::string> copy_destination_handle = std::nullopt;
  std::optional<std::string> active_shader_stage = std::nullopt;
  std::optional<std::vector<SlotResourceBindingSummary>> srv_bindings = std::nullopt;
  std::optional<std::vector<SlotResourceBindingSummary>> uav_bindings = std::nullopt;
  std::optional<std::vector<ConstantBufferSummary>> constant_buffers = std::nullopt;
  std::optional<std::vector<RenderTargetSummary>> render_targets = std::nullopt;
  std::optional<std::vector<PipelineBindSummary>> pipelines = std::nullopt;
  std::optional<std::vector<ResourceBindSummary>> shader_resource_binds = std::nullopt;
  std::optional<BlendStateSummary> blend_state = std::nullopt;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const DrawSummary& value) {
  j = {
      {"index", value.index},
      {"method", value.method},
      {"timestampMs", value.timestamp_ms},
      {"srvCount", value.srv_count},
      {"uavCount", value.uav_count},
      {"constantCount", value.constant_count},
      {"renderTargetCount", value.render_target_count},
      {"pipelineCount", value.pipeline_count},
      {"shaderHashes", value.shader_hashes},
  };
  if (value.copy_source_handle.has_value()) {
    j["copySourceHandle"] = value.copy_source_handle.value();
  }
  if (value.copy_destination_handle.has_value()) {
    j["copyDestinationHandle"] = value.copy_destination_handle.value();
  }
  if (value.active_shader_stage.has_value()) {
    j["activeShaderStage"] = value.active_shader_stage.value();
  }
  if (value.srv_bindings.has_value()) {
    j["srvBindings"] = value.srv_bindings.value();
  }
  if (value.uav_bindings.has_value()) {
    j["uavBindings"] = value.uav_bindings.value();
  }
  if (value.constant_buffers.has_value()) {
    j["constantBuffers"] = value.constant_buffers.value();
  }
  if (value.render_targets.has_value()) {
    j["renderTargets"] = value.render_targets.value();
  }
  if (value.pipelines.has_value()) {
    j["pipelines"] = value.pipelines.value();
  }
  if (value.shader_resource_binds.has_value()) {
    j["shaderResourceBinds"] = value.shader_resource_binds.value();
  }
  if (value.blend_state.has_value()) {
    j["blendState"] = value.blend_state.value();
  }
}

struct LoadedDiskShaderSummary {
  std::string hash;
  std::uint32_t hash_value = 0u;
  std::string path;
  bool removed = false;
  bool compilation_ok = false;
  bool activated = false;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const LoadedDiskShaderSummary& value) {
  j = {
      {"hash", value.hash},
      {"hashValue", value.hash_value},
      {"path", value.path},
      {"removed", value.removed},
      {"isCompilationOk", value.compilation_ok},
      {"activated", value.activated},
  };
}

}  // namespace renodx::addons::devkit::mcp::draw_summary
