#pragma once

/*
 * DXBC-checksum shader replacement for non-TAA Alias Isolation fixes.
 *
 * The original ASI replaces a few game shaders directly by matching the DXBC
 * header checksum. RenoDX normally uses CRC32-based shader replacement, but
 * these Alias Isolation replacements stay self-contained by cloning the runtime
 * pipeline when a matching shader subobject is created and rebinding the clone
 * while the Alias Isolation toggle is enabled.
 */

#include <array>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <span>
#include <unordered_map>
#include <vector>

#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../../../utils/bitwise.hpp"
#include "../../../../utils/pipeline.hpp"
#include "./constant_buffers.hpp"
#include "./logging.hpp"
#include "./shader_ids.hpp"

namespace alienisolation::aliasisolation::pipeline_replacer {

struct ReplacementShader {
  std::span<const uint8_t> code;
  const char* name = nullptr;
  reshade::api::pipeline_stage stage = static_cast<reshade::api::pipeline_stage>(0u);
};

struct ReplacementPipeline {
  // Keep both handles so we can destroy the clone with the right device and map
  // replacement handles back to originals during destruction callbacks.
  reshade::api::device* device = nullptr;
  reshade::api::pipeline original = {0u};
  reshade::api::pipeline replacement = {0u};
  reshade::api::pipeline_stage stages = static_cast<reshade::api::pipeline_stage>(0u);
  std::array<ShaderId, 3> shader_ids = {ShaderId::Unknown, ShaderId::Unknown, ShaderId::Unknown};
};

struct PendingReplacement {
  uint32_t subobject_index = 0u;
  ShaderId shader_id = ShaderId::Unknown;
  ReplacementShader replacement = {};
};

inline std::unordered_map<uint64_t, ReplacementPipeline> replacement_pipelines;
inline std::unordered_map<uint64_t, uint64_t> replacement_to_original;
inline thread_local bool creating_replacement = false;
inline thread_local bool rebinding_replacement = false;
inline std::array<bool, static_cast<size_t>(ShaderId::Count)> logged_created = {};
inline std::array<uint64_t, static_cast<size_t>(ShaderId::Count)> last_bind_log = [] {
  std::array<uint64_t, static_cast<size_t>(ShaderId::Count)> result = {};
  result.fill(std::numeric_limits<uint64_t>::max());
  return result;
}();

inline std::span<const uint8_t> SpanOf(const auto& shader) {
  return std::span<const uint8_t>(shader.data(), shader.size());
}

inline ReplacementShader ReplacementFor(ShaderId id) {
  switch (id) {
#if ALIENISOLATION_ENABLE_BARREL_DISTORTION_REMOVAL
    case ShaderId::MainPostVs:
      return {SpanOf(__aliasisolation_main_post), "aliasisolation_main_post", reshade::api::pipeline_stage::vertex_shader};
#endif
    case ShaderId::ShadowLinearizePs:
      return {SpanOf(__aliasisolation_shadow_linearize), "aliasisolation_shadow_linearize", reshade::api::pipeline_stage::pixel_shader};
    case ShaderId::ShadowDownsamplePs:
      return {SpanOf(__aliasisolation_shadow_downsample), "aliasisolation_shadow_downsample", reshade::api::pipeline_stage::pixel_shader};
#if ALIENISOLATION_ENABLE_BLOOM_MERGE_REPLACEMENT
    case ShaderId::BloomMergePs:
      return {SpanOf(__aliasisolation_bloom_merge), "aliasisolation_bloom_merge", reshade::api::pipeline_stage::pixel_shader};
#endif
    default:
      return {};
  }
}

inline ShaderId IdentifyShader(reshade::api::pipeline_subobject_type type, const reshade::api::shader_desc& desc) {
  if (desc.code == nullptr || desc.code_size == 0u) return ShaderId::Unknown;

  const auto bytes = std::span<const uint8_t>(static_cast<const uint8_t*>(desc.code), desc.code_size);
  switch (type) {
    case reshade::api::pipeline_subobject_type::vertex_shader:
      return IdentifyVertexShader(bytes);
    case reshade::api::pipeline_subobject_type::pixel_shader:
      return IdentifyPixelShader(bytes);
    default:
      return ShaderId::Unknown;
  }
}

inline bool IsReplacementStage(reshade::api::pipeline_subobject_type type) {
  return type == reshade::api::pipeline_subobject_type::vertex_shader
         || type == reshade::api::pipeline_subobject_type::pixel_shader;
}

inline void SetShaderId(std::array<ShaderId, 3>& ids, reshade::api::pipeline_subobject_type type, ShaderId id) {
  switch (type) {
    case reshade::api::pipeline_subobject_type::vertex_shader:
      ids[0] = id;
      break;
    case reshade::api::pipeline_subobject_type::pixel_shader:
      ids[1] = id;
      break;
    case reshade::api::pipeline_subobject_type::compute_shader:
      ids[2] = id;
      break;
    default:
      break;
  }
}

inline void ReplaceShaderCode(reshade::api::pipeline_subobject& subobject, std::span<const uint8_t> code) {
  auto* desc = static_cast<reshade::api::shader_desc*>(subobject.data);
  if (desc == nullptr) return;

  // ClonePipelineSubObjects allocates shader bytecode buffers; free the old one
  // before installing the embedded Alias Isolation bytecode into the clone.
  if (desc->code != nullptr) {
    free(const_cast<void*>(desc->code));
  }

  desc->code_size = code.size();
  if (code.empty()) {
    desc->code = nullptr;
    return;
  }

  void* copy = malloc(code.size());
  if (copy == nullptr) {
    desc->code = nullptr;
    desc->code_size = 0u;
    return;
  }

  memcpy(copy, code.data(), code.size());
  desc->code = copy;
}

inline void LogCreatedOnce(const PendingReplacement& pending, reshade::api::pipeline original, reshade::api::pipeline replacement) {
  const auto index = static_cast<size_t>(pending.shader_id);
  if (index >= logged_created.size() || logged_created[index]) return;

  logged_created[index] = true;
  logging::Info("created DXBC-checksum replacement ", ShaderIdName(pending.shader_id), " -> ", pending.replacement.name,
                " original=", logging::Hex(original.handle), " replacement=", logging::Hex(replacement.handle));
}

inline void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (creating_replacement || device == nullptr || pipeline.handle == 0u || subobjects == nullptr || subobject_count == 0u) return;

  std::vector<PendingReplacement> pending_replacements;
  std::array<ShaderId, 3> shader_ids = {ShaderId::Unknown, ShaderId::Unknown, ShaderId::Unknown};

  // Scan the incoming pipeline for any game shader that Alias Isolation knows
  // how to replace. Multiple subobjects can be replaced in the same clone.
  for (uint32_t i = 0; i < subobject_count; ++i) {
    const auto& subobject = subobjects[i];
    if (!IsReplacementStage(subobject.type) || subobject.data == nullptr || subobject.count == 0u) continue;

    const auto* desc = static_cast<const reshade::api::shader_desc*>(subobject.data);
    const ShaderId id = IdentifyShader(subobject.type, *desc);
    SetShaderId(shader_ids, subobject.type, id);

    const ReplacementShader replacement = ReplacementFor(id);
    if (replacement.code.empty()) continue;

    pending_replacements.push_back({i, id, replacement});
  }

  if (pending_replacements.empty()) return;

  // Build a separate replacement pipeline instead of mutating the original
  // pipeline object. That lets the toggle switch replacements on/off at bind
  // time without changing RenoDX core behavior.
  auto* replacement_subobjects = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);
  if (replacement_subobjects == nullptr) return;

  reshade::api::pipeline_stage replacement_stages = static_cast<reshade::api::pipeline_stage>(0u);
  for (const auto& pending : pending_replacements) {
    ReplaceShaderCode(replacement_subobjects[pending.subobject_index], pending.replacement.code);
    replacement_stages |= pending.replacement.stage;
  }

  reshade::api::pipeline replacement_pipeline = {0u};
  creating_replacement = true;
  const bool created = device->create_pipeline(layout, subobject_count, replacement_subobjects, &replacement_pipeline);
  creating_replacement = false;
  renodx::utils::pipeline::DestroyPipelineSubobjects(replacement_subobjects, subobject_count);

  if (!created || replacement_pipeline.handle == 0u) {
    for (const auto& pending : pending_replacements) {
      logging::Warn("failed to create DXBC-checksum replacement ", ShaderIdName(pending.shader_id), " -> ", pending.replacement.name,
                    " original=", logging::Hex(pipeline.handle));
    }
    return;
  }

  replacement_pipelines[pipeline.handle] = ReplacementPipeline{
      .device = device,
      .original = pipeline,
      .replacement = replacement_pipeline,
      .stages = replacement_stages,
      .shader_ids = shader_ids,
  };
  replacement_to_original[replacement_pipeline.handle] = pipeline.handle;

  for (const auto& pending : pending_replacements) {
    LogCreatedOnce(pending, pipeline, replacement_pipeline);
  }
}

inline void OnDestroyPipeline(reshade::api::device* device, reshade::api::pipeline pipeline) {
  if (pipeline.handle == 0u) return;

  if (auto replacement = replacement_pipelines.find(pipeline.handle); replacement != replacement_pipelines.end()) {
    const auto replacement_pipeline = replacement->second.replacement;
    replacement_to_original.erase(replacement_pipeline.handle);
    if (device != nullptr && replacement_pipeline.handle != 0u) {
      device->destroy_pipeline(replacement_pipeline);
    }
    replacement_pipelines.erase(replacement);
    return;
  }

  replacement_to_original.erase(pipeline.handle);
}

inline void Destroy(reshade::api::device* device) {
  if (device != nullptr) {
    for (auto& [_, replacement] : replacement_pipelines) {
      if (replacement.device == device && replacement.replacement.handle != 0u) {
        device->destroy_pipeline(replacement.replacement);
      }
    }
  }

  replacement_pipelines.clear();
  replacement_to_original.clear();
}

inline bool ShouldBindReplacement(reshade::api::pipeline_stage bound_stages, reshade::api::pipeline_stage replacement_stages) {
  if (bound_stages == reshade::api::pipeline_stage::all) return true;
  return (static_cast<uint32_t>(bound_stages) & static_cast<uint32_t>(replacement_stages)) != 0u;
}

inline void OnBindPipeline(reshade::api::command_list* cmd_list, reshade::api::pipeline_stage stages, reshade::api::pipeline pipeline) {
  if (rebinding_replacement || cmd_list == nullptr || pipeline.handle == 0u) return;
  if (!constant_buffers::IsEnabled()) return;

  const auto replacement = replacement_pipelines.find(pipeline.handle);
  if (replacement == replacement_pipelines.end()) return;
  if (!ShouldBindReplacement(stages, replacement->second.stages)) return;

  for (const ShaderId id : replacement->second.shader_ids) {
    if (id == ShaderId::Unknown) continue;
    const auto index = static_cast<size_t>(id);
    if (index < last_bind_log.size() && logging::ShouldLogFrame(constant_buffers::frame_state.frame_index, last_bind_log[index])) {
      logging::Info("binding DXBC-checksum replacement ", ShaderIdName(id),
                    " original=", logging::Hex(pipeline.handle),
                    " replacement=", logging::Hex(replacement->second.replacement.handle),
                    " stages=", static_cast<uint32_t>(stages));
    }
  }

  rebinding_replacement = true;
  // Re-entering bind_pipeline triggers the same ReShade callback, so the guard
  // above prevents an infinite rebinding loop.
  cmd_list->bind_pipeline(stages, replacement->second.replacement);
  rebinding_replacement = false;
}

}  // namespace alienisolation::aliasisolation::pipeline_replacer
