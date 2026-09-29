/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <atomic>
#include <functional>
#include <include/reshade.hpp>
#include <include/reshade_api_device.hpp>
#include <include/reshade_api_pipeline.hpp>
#include <optional>
#include <shared_mutex>
#include <span>
#include <unordered_map>
#include <vector>

#include "./bitwise.hpp"
#include "./cross_addon.hpp"
#include "./cstring.hpp"
#include "./hash.hpp"
#include "./pipeline_layout.hpp"

namespace renodx::utils::pipeline {

static bool track_shader_hashes = false;
static bool cache_subobjects = false;
static bool retain_destroyed_subobjects = false;

enum class PipelineBindPoint : uint8_t {
  UNKNOWN,
  GRAPHICS,
  COMPUTE,
  RAY_TRACING,
};

struct PipelineShaderHashEntry {
  uint32_t subobject_index = 0u;
  uint32_t shader_hash = 0u;
  reshade::api::pipeline_stage stage = static_cast<reshade::api::pipeline_stage>(0u);
};

static constexpr std::array SHADER_STAGES = {
    reshade::api::pipeline_stage::vertex_shader,
    reshade::api::pipeline_stage::hull_shader,
    reshade::api::pipeline_stage::domain_shader,
    reshade::api::pipeline_stage::geometry_shader,
    reshade::api::pipeline_stage::pixel_shader,
    reshade::api::pipeline_stage::compute_shader,
    reshade::api::pipeline_stage::amplification_shader,
    reshade::api::pipeline_stage::mesh_shader,
};

static constexpr size_t GetShaderStageIndex(reshade::api::pipeline_stage stage) {
  return std::ranges::find(SHADER_STAGES, stage) - SHADER_STAGES.begin();
}

struct PipelineShaderDetails {
  reshade::api::pipeline pipeline = {0u};
  reshade::api::device* device = nullptr;
  [[deprecated("Use utils::pipeline::PipelineInfo::layout")]]
  reshade::api::pipeline_layout layout = {0};
  cross_addon::vector<reshade::api::pipeline_subobject> subobjects;
  cross_addon::vector<PipelineShaderHashEntry> subobject_shaders;
  reshade::api::pipeline replacement_pipeline = {0};
  reshade::api::pipeline_stage replacement_stages = static_cast<reshade::api::pipeline_stage>(0u);
  bool initialized_replacement = false;
  std::optional<cross_addon::string> tag;
  bool destroyed = false;
  bool is_replacement = false;
  reshade::api::pipeline_layout replacement_layout = {0u};
  reshade::api::pipeline_layout injection_layout = {0u};
  int32_t injection_index = -1;
  int32_t injection_register_index = -1;
  int32_t injection_constant_buffer_offset = 0;
  reshade::api::shader_stage injection_visibility = reshade::api::shader_stage::all;
  cross_addon::vector<reshade::api::descriptor_table> descriptor_tables;
  cross_addon::unordered_map<
      pipeline_layout::DescriptorBindingKey,
      pipeline_layout::DescriptorPushLocation,
      pipeline_layout::DescriptorBindingKeyHash>
      descriptor_push_locations;
  uint64_t replacement_revision = 0u;

  PipelineShaderDetails() = default;
  PipelineShaderDetails(
      reshade::api::pipeline pipeline,
      reshade::api::device* device,
      const reshade::api::pipeline_layout& layout,
      const reshade::api::pipeline_subobject* subobjects,
      const uint32_t& subobject_count,
      std::span<const PipelineShaderHashEntry> shader_details,
      std::span<const uint32_t> replaced_shader_subobject_indexes);
};

struct PipelineInfo {
  reshade::api::pipeline pipeline = {0u};
  reshade::api::device* device = nullptr;
  reshade::api::pipeline_layout layout = {0u};
  PipelineBindPoint bind_point = PipelineBindPoint::UNKNOWN;
  cross_addon::vector<PipelineShaderHashEntry> shader_details;
  cross_addon::vector<uint32_t> replaced_shader_subobject_indexes;
  PipelineShaderDetails details;
  uint64_t generation = 0u;
  std::array<std::optional<size_t>, SHADER_STAGES.size()> shader_detail_by_stage = {};
  bool shader_detail_index_ready = false;
};

using InitCallback = void (*)(
    PipelineInfo*,
    uint32_t,
    const reshade::api::pipeline_subobject*);
using CreateCallback = bool (*)(
    reshade::api::device*,
    reshade::api::pipeline_layout,
    uint32_t,
    const reshade::api::pipeline_subobject*);
using BindCallback = void (*)(
    reshade::api::command_list*,
    reshade::api::pipeline_stage,
    reshade::api::pipeline,
    PipelineBindPoint);
// A disengaged result requests an unlocked retry with info == nullptr.
// A zero handle means the pipeline is resolved without a replacement.
using BindInfoCallback = std::optional<reshade::api::pipeline> (*)(
    reshade::api::command_list*,
    reshade::api::pipeline_stage,
    reshade::api::pipeline,
    PipelineBindPoint,
    const PipelineInfo*);
using DestroyCallback = void (*)(const PipelineInfo&);
using AfterDestroyCallback = void (*)();

template <typename Callback>
using CallbackList = cross_addon::vector<Callback>;

using PipelineInfoMap = cross_addon::parallel_node_hash_map<
    uint64_t,  // reshade::api::pipeline::handle
    PipelineInfo,
    std::shared_mutex>;
namespace internal {
struct __declspec(uuid("a92dff63-bb92-4543-80aa-3948b089f964")) SharedData {
  PipelineInfoMap pipeline_infos;
  CallbackList<InitCallback> on_init_callbacks;
  CallbackList<BindCallback> on_bind_callbacks;
  CallbackList<DestroyCallback> on_destroy_callbacks;
  CallbackList<CreateCallback> on_create_callbacks;
  CallbackList<AfterDestroyCallback> on_after_destroy_callbacks;
  bool track_shader_hashes = false;
  bool retain_destroyed_subobjects = false;
  std::atomic_uint64_t next_pipeline_generation = 0u;
  CallbackList<BindInfoCallback> on_bind_pipeline_info_callbacks;
  bool cache_subobjects = false;
};

static cross_addon::Shared<SharedData> shared;
}  // namespace internal
static bool attached = false;
// RegisterEvent needs this module's interest; the shared callback list also contains other modules' callbacks.
static std::vector<CreateCallback> local_create_callbacks;
static std::vector<BindCallback> local_bind_callbacks;
static std::vector<BindInfoCallback> local_bind_info_callbacks;

static void EnableShaderHashTracking() {
  track_shader_hashes = true;
  if (internal::shared.data != nullptr) {
    internal::shared.data->track_shader_hashes = true;
  }
}

static void EnableSubobjectCaching() {
  cache_subobjects = true;
  if (internal::shared.data != nullptr) {
    internal::shared.data->cache_subobjects = true;
  }
}

static void EnableDestroyedSubobjectRetention() {
  retain_destroyed_subobjects = true;
  if (internal::shared.data != nullptr) {
    internal::shared.data->retain_destroyed_subobjects = true;
  }
}

template <typename F>
static bool UpdatePipelineInfo(reshade::api::pipeline pipeline, F&& callback) {
  if (internal::shared.data == nullptr || pipeline.handle == 0u) return false;
  bool updated = false;
  internal::shared.data->pipeline_infos.modify_if(pipeline.handle, [&](auto& entry) {
    std::invoke(std::forward<F>(callback), entry.second);
    updated = true;
  });
  return updated;
}

struct PendingOriginalShaderHashes {
  struct Shader {
    uint32_t subobject_index;
    uint32_t original_hash;
    const void* code;
    size_t code_size;
  };
  reshade::api::device* device;
  const reshade::api::pipeline_subobject* subobjects;
  uint32_t subobject_count;
  std::vector<Shader> shaders;
};

static thread_local std::optional<PendingOriginalShaderHashes> pending_original_shader_hashes;

template <typename F>
static bool GetPipelineInfo(reshade::api::pipeline pipeline, F&& callback) {
  if (pipeline.handle == 0u) return false;
  bool found = false;
  internal::shared.data->pipeline_infos.if_contains(
      pipeline.handle,
      [&](const std::pair<const uint64_t, PipelineInfo>& pair) {
        if (!pair.second.details.destroyed) {
          std::invoke(std::forward<F>(callback), pair.second);
          found = true;
        }
      });
  return found;
}

template <typename F>
static bool GetPipelineShaderDetails(reshade::api::pipeline pipeline, F&& callback) {
  if (pipeline.handle == 0u) return false;
  bool found = false;
  internal::shared.data->pipeline_infos.if_contains(pipeline.handle, [&](const auto& entry) {
    std::invoke(std::forward<F>(callback), entry.second.details);
    found = true;
  });
  return found;
}

template <typename F>
static bool UpdatePipelineShaderDetails(reshade::api::pipeline pipeline, F&& callback) {
  if (pipeline.handle == 0u) return false;
  bool updated = false;
  internal::shared.data->pipeline_infos.modify_if(pipeline.handle, [&](auto& entry) {
    std::invoke(std::forward<F>(callback), entry.second.details);
    updated = true;
  });
  return updated;
}

static uint32_t GetPipelineShaderHash(
    reshade::api::pipeline pipeline,
    reshade::api::pipeline_stage stage) {
  const auto index = GetShaderStageIndex(stage);
  if (index >= SHADER_STAGES.size()) return 0u;
  uint32_t shader_hash = 0u;
  GetPipelineInfo(pipeline, [&](const PipelineInfo& info) {
    if (info.shader_detail_index_ready) {
      if (const auto& detail_index = info.shader_detail_by_stage[index]; detail_index.has_value()) {
        shader_hash = info.shader_details[*detail_index].shader_hash;
      }
    } else {
      for (const auto& detail : info.shader_details) {
        if (detail.stage == stage) {
          shader_hash = detail.shader_hash;
        }
      }
    }
  });
  return shader_hash;
}

template <typename T>
static void ReplacePipelineSubobjectData(
    reshade::api::pipeline_subobject* subobject,
    std::span<const T> values) {
  assert(subobject != nullptr);
  if (subobject == nullptr) return;

  auto* replacement = cross_addon::Allocate(sizeof(T) * values.size());
  std::memcpy(replacement, values.data(), sizeof(T) * values.size());
  cross_addon::Free(subobject->data);
  subobject->count = static_cast<uint32_t>(values.size());
  subobject->data = replacement;
}

static reshade::api::pipeline_subobject* ClonePipelineSubObjects(const reshade::api::pipeline_subobject* subobjects, uint32_t subobject_count) {
  auto* new_subobjects = new reshade::api::pipeline_subobject[subobject_count];
  std::memcpy(new_subobjects, subobjects, sizeof(reshade::api::pipeline_subobject) * subobject_count);
  for (uint32_t i = 0; i < subobject_count; ++i) {
    const auto& subobject = subobjects[i];
#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::pipeline::ClonePipelineSubObjects(cloning " << subobjects[i].type << "[" << i << "]";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
    switch (subobject.type) {
      case reshade::api::pipeline_subobject_type::vertex_shader:
      case reshade::api::pipeline_subobject_type::hull_shader:
      case reshade::api::pipeline_subobject_type::domain_shader:
      case reshade::api::pipeline_subobject_type::geometry_shader:
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
      case reshade::api::pipeline_subobject_type::amplification_shader:
      case reshade::api::pipeline_subobject_type::mesh_shader:
      case reshade::api::pipeline_subobject_type::raygen_shader:
      case reshade::api::pipeline_subobject_type::any_hit_shader:
      case reshade::api::pipeline_subobject_type::closest_hit_shader:
      case reshade::api::pipeline_subobject_type::miss_shader:
      case reshade::api::pipeline_subobject_type::intersection_shader:
      case reshade::api::pipeline_subobject_type::callable_shader:      {
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::shader_desc));
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::shader_desc));
        auto* old_desc = static_cast<reshade::api::shader_desc*>(subobject.data);
        auto* new_desc = static_cast<reshade::api::shader_desc*>(new_subobjects[i].data);

        if (new_desc->entry_point != nullptr && new_desc->entry_point[0] == '\0') {
          // Reshade guards against nullptr entry points but not empty strings, so we convert as a workaround
          new_desc->entry_point = nullptr;
        } else if (new_desc->entry_point != nullptr) {
          new_desc->entry_point = renodx::utils::CloneCString(new_desc->entry_point);
        }

#ifdef DEBUG_LEVEL_2
        {
          std::stringstream s;
          s << "utils::pipeline::ClonePipelineSubObjects(entry point";
          s << " from " << (old_desc->entry_point != nullptr ? old_desc->entry_point : "(null)");
          s << " to " << (new_desc->entry_point != nullptr ? new_desc->entry_point : "(null)");
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
        }
#endif

        if (old_desc->code_size != 0u) {
          void* code_copy = malloc(old_desc->code_size);
          memcpy(code_copy, old_desc->code, old_desc->code_size);
          new_desc->code = code_copy;
        }

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::pipeline::ClonePipelineSubObjects(cloning ";
        s << subobject.type;
        s << " with " << PRINT_CRC32(renodx::utils::hash::ComputeCRC32(static_cast<const uint8_t*>(old_desc->code), old_desc->code_size));
        s << " => " << PRINT_CRC32(renodx::utils::hash::ComputeCRC32(static_cast<const uint8_t*>(new_desc->code), new_desc->code_size));
        s << " (" << old_desc->code_size << " bytes)";
        s << " from " << old_desc->code;
        s << " to " << new_desc->code;
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        break;
      }
      case reshade::api::pipeline_subobject_type::input_layout:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::input_element) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::input_element) * subobject.count);
        for (uint32_t j = 0; j < subobject.count; j++) {
          auto* old_input_elements = static_cast<reshade::api::input_element*>(subobject.data);
          auto* new_input_elements = static_cast<reshade::api::input_element*>(new_subobjects[i].data);
          new_input_elements[j].semantic = renodx::utils::CloneCString(old_input_elements[j].semantic);
        }
        break;
      case reshade::api::pipeline_subobject_type::stream_output_state:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::stream_output_desc) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::stream_output_desc) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::blend_state:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::blend_desc) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::blend_desc) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::rasterizer_state:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::rasterizer_desc) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::rasterizer_desc) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::depth_stencil_state:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::depth_stencil_desc) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::depth_stencil_desc) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::primitive_topology:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::primitive_topology) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::primitive_topology) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::depth_stencil_format:
      case reshade::api::pipeline_subobject_type::render_target_formats:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::format) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::format) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::sample_mask:
      case reshade::api::pipeline_subobject_type::sample_count:
      case reshade::api::pipeline_subobject_type::viewport_count:
      case reshade::api::pipeline_subobject_type::max_vertex_count:
      case reshade::api::pipeline_subobject_type::max_payload_size:
      case reshade::api::pipeline_subobject_type::max_attribute_size:
      case reshade::api::pipeline_subobject_type::max_recursion_depth:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(uint32_t) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(uint32_t) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::dynamic_pipeline_states:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::dynamic_state) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::dynamic_state) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::libraries:
      case reshade::api::pipeline_subobject_type::shader_groups:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::shader_group) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::shader_group) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::flags:
        new_subobjects[i].data = cross_addon::Allocate(sizeof(reshade::api::pipeline_flags) * subobject.count);
        memcpy(new_subobjects[i].data, subobject.data, sizeof(reshade::api::pipeline_flags) * subobject.count);
        break;
      case reshade::api::pipeline_subobject_type::unknown:
        break;
    }
  }

  return new_subobjects;
}

static void DestroyPipelineSubobjects(std::span<reshade::api::pipeline_subobject> subobjects) {
  for (auto& subobject : subobjects) {
    if (subobject.data == nullptr) continue;
    switch (subobject.type) {
      case reshade::api::pipeline_subobject_type::vertex_shader:
      case reshade::api::pipeline_subobject_type::hull_shader:
      case reshade::api::pipeline_subobject_type::domain_shader:
      case reshade::api::pipeline_subobject_type::geometry_shader:
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
      case reshade::api::pipeline_subobject_type::amplification_shader:
      case reshade::api::pipeline_subobject_type::mesh_shader:
      case reshade::api::pipeline_subobject_type::raygen_shader:
      case reshade::api::pipeline_subobject_type::any_hit_shader:
      case reshade::api::pipeline_subobject_type::closest_hit_shader:
      case reshade::api::pipeline_subobject_type::miss_shader:
      case reshade::api::pipeline_subobject_type::intersection_shader:
      case reshade::api::pipeline_subobject_type::callable_shader:      {
        auto* desc = static_cast<reshade::api::shader_desc*>(subobject.data);
        if (desc->entry_point != nullptr) {
          std::free(const_cast<char*>(desc->entry_point));
          desc->entry_point = nullptr;
        }
        free(const_cast<void*>(desc->code));
        desc->code = nullptr;
        break;
      }
      case reshade::api::pipeline_subobject_type::input_layout: {
        auto* input_elements = static_cast<reshade::api::input_element*>(subobject.data);
        for (uint32_t i = 0; i < subobject.count; ++i) {
          std::free(const_cast<char*>(input_elements[i].semantic));
          input_elements[i].semantic = nullptr;
        }
        break;
      }
      default:
        break;
    }

    cross_addon::Free(subobject.data);
    subobject.data = nullptr;
  }
}

static void DestroyPipelineSubobjects(reshade::api::pipeline_subobject* subobjects, uint32_t subobject_count) {
  DestroyPipelineSubobjects({subobjects, subobjects + subobject_count});
  delete[] subobjects;
}

static bool HasSDRAlphaBlend(std::span<const reshade::api::pipeline_subobject> subobjects) {
  for (const auto& subobject : subobjects) {
    if (subobject.type != reshade::api::pipeline_subobject_type::blend_state) continue;
    for (uint32_t j = 0; j < subobject.count; ++j) {
      auto& desc = static_cast<reshade::api::blend_desc*>(subobject.data)[j];
      if (!desc.blend_enable[0]) continue;

      if (((desc.render_target_write_mask[0] & 0x1) != 0)
          || ((desc.render_target_write_mask[0] & 0x2) != 0)
          || ((desc.render_target_write_mask[0] & 0x4) != 0)) {
        if (desc.color_blend_op[0] != reshade::api::blend_op::min
            && desc.color_blend_op[0] != reshade::api::blend_op::max) {
          if (
              desc.source_color_blend_factor[0] == reshade::api::blend_factor::dest_alpha
              || desc.source_color_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
              || desc.dest_color_blend_factor[0] == reshade::api::blend_factor::dest_alpha
              || desc.dest_color_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha) {
            return true;
          }
        }
      }
      if ((desc.render_target_write_mask[0] & 0x8) != 0) {
        if (desc.alpha_blend_op[0] == reshade::api::blend_op::min
            || desc.alpha_blend_op[0] == reshade::api::blend_op::max) {
          return true;
        }
        if (
            desc.source_alpha_blend_factor[0] == reshade::api::blend_factor::dest_alpha
            || desc.source_alpha_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::one
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::dest_alpha
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha) {
          return true;
        }
      }
    }
  }
  return false;
}

struct PipelineSubobjects {
  std::span<const uint8_t> vertex_shader;
  std::span<const uint8_t> pixel_shader;
  std::span<const uint8_t> compute_shader;
  std::vector<reshade::api::blend_desc> blend_states = {reshade::api::blend_desc{}};
  std::vector<reshade::api::input_element> input_layout;
  std::vector<reshade::api::depth_stencil_desc> depth_stencil_states = {reshade::api::depth_stencil_desc{.depth_enable = false}};
  std::vector<uint32_t> max_vertex_counts = {3};
  std::vector<reshade::api::primitive_topology> primitive_topologies = {reshade::api::primitive_topology::triangle_list};
  std::vector<reshade::api::rasterizer_desc> rasterizer_states = {reshade::api::rasterizer_desc{.cull_mode = reshade::api::cull_mode::none}};
  std::vector<reshade::api::format> render_target_formats = {reshade::api::format::r16g16b16a16_float};
};

static reshade::api::pipeline CreateRenderPipeline(
    reshade::api::device* device,
    const reshade::api::pipeline_layout layout,
    PipelineSubobjects& options) {
  std::vector<reshade::api::pipeline_subobject> subobjects = {
      {
          .type = reshade::api::pipeline_subobject_type::blend_state,
          .count = static_cast<uint32_t>(options.blend_states.size()),
          .data = options.blend_states.data(),
      },
      {
          .type = reshade::api::pipeline_subobject_type::depth_stencil_state,
          .count = static_cast<uint32_t>(options.depth_stencil_states.size()),
          .data = options.depth_stencil_states.data(),
      },
      {
          .type = reshade::api::pipeline_subobject_type::input_layout,
          .count = static_cast<uint32_t>(options.input_layout.size()),
          .data = options.input_layout.data(),
      },
      {
          .type = reshade::api::pipeline_subobject_type::max_vertex_count,
          .count = static_cast<uint32_t>(options.max_vertex_counts.size()),
          .data = options.max_vertex_counts.data(),
      },
      {
          .type = reshade::api::pipeline_subobject_type::primitive_topology,
          .count = static_cast<uint32_t>(options.primitive_topologies.size()),
          .data = options.primitive_topologies.data(),
      },
      {
          .type = reshade::api::pipeline_subobject_type::rasterizer_state,
          .count = static_cast<uint32_t>(options.rasterizer_states.size()),
          .data = options.rasterizer_states.data(),
      },

      {
          .type = reshade::api::pipeline_subobject_type::render_target_formats,
          .count = static_cast<uint32_t>(options.render_target_formats.size()),
          .data = options.render_target_formats.data(),
      },
  };

  std::vector<reshade::api::shader_desc> shader_descriptions = {};
  shader_descriptions.reserve(
      (options.vertex_shader.empty() ? 0 : 1)
      + (options.pixel_shader.empty() ? 0 : 1)
      + (options.compute_shader.empty() ? 0 : 1));

  if (!options.vertex_shader.empty()) {
    shader_descriptions.push_back({
        .code = options.vertex_shader.data(),
        .code_size = options.vertex_shader.size(),
    });
    subobjects.push_back({
        .type = reshade::api::pipeline_subobject_type::vertex_shader,
        .count = 1,
        .data = &shader_descriptions.back(),
    });
  }
  if (!options.pixel_shader.empty()) {
    shader_descriptions.push_back({
        .code = options.pixel_shader.data(),
        .code_size = options.pixel_shader.size(),
    });
    subobjects.push_back({
        .type = reshade::api::pipeline_subobject_type::pixel_shader,
        .count = 1,
        .data = &shader_descriptions.back(),
    });
  }
  if (!options.compute_shader.empty()) {
    shader_descriptions.push_back({
        .code = options.compute_shader.data(),
        .code_size = options.compute_shader.size(),
    });
    subobjects.push_back({
        .type = reshade::api::pipeline_subobject_type::compute_shader,
        .count = 1,
        .data = &shader_descriptions.back(),
    });
  }

  reshade::api::pipeline pipeline;
  if (device->create_pipeline(layout, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &pipeline)) {
    return pipeline;
  }
  return {0};
}

static reshade::api::pipeline CreateRenderPipeline(
    reshade::api::device* device,
    const reshade::api::pipeline_layout layout,
    const std::unordered_map<reshade::api::pipeline_subobject_type, std::span<const std::uint8_t>>& shaders,
    const reshade::api::format render_target_format = reshade::api::format::r16g16b16a16_float) {
  auto format = render_target_format;
  uint32_t num_vertices = 3;
  auto topology = reshade::api::primitive_topology::triangle_list;
  reshade::api::blend_desc blend_state = {};
  reshade::api::rasterizer_desc rasterizer_state = {.cull_mode = reshade::api::cull_mode::none};
  reshade::api::depth_stencil_desc depth_stencil_state = {.depth_enable = false};
  std::vector<reshade::api::input_element> input_layout;

  std::vector<reshade::api::pipeline_subobject> subobjects = {
      {reshade::api::pipeline_subobject_type::render_target_formats, 1, &format},
      {reshade::api::pipeline_subobject_type::max_vertex_count, 1, &num_vertices},
      {reshade::api::pipeline_subobject_type::primitive_topology, 1, &topology},
      {reshade::api::pipeline_subobject_type::blend_state, 1, &blend_state},
      {reshade::api::pipeline_subobject_type::rasterizer_state, 1, &rasterizer_state},
      {reshade::api::pipeline_subobject_type::depth_stencil_state, 1, &depth_stencil_state},
      {reshade::api::pipeline_subobject_type::input_layout, static_cast<uint32_t>(input_layout.size()), input_layout.data()},
  };

  subobjects.reserve(6 + shaders.size());

  std::vector<reshade::api::shader_desc> shader_descriptions;
  shader_descriptions.reserve(shaders.size());
  for (const auto& [type, shader] : shaders) {
    shader_descriptions.push_back({
        .code = shader.data(),
        .code_size = shader.size(),
    });
    subobjects.push_back({.type = type, .count = 1, .data = &shader_descriptions.back()});
  }

  reshade::api::pipeline pipeline;
  if (device->create_pipeline(layout, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &pipeline)) {
    return pipeline;
  }
  return {0};
}

static bool OnCreatePipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  pending_original_shader_hashes.reset();  // A failed create does not produce an init callback.
  std::vector<std::optional<uint32_t>> original_hashes(subobject_count);
  if (internal::shared.data->track_shader_hashes) {
    for (uint32_t index = 0u; index < subobject_count; ++index) {
      switch (subobjects[index].type) {
        case reshade::api::pipeline_subobject_type::vertex_shader:
        case reshade::api::pipeline_subobject_type::hull_shader:
        case reshade::api::pipeline_subobject_type::domain_shader:
        case reshade::api::pipeline_subobject_type::geometry_shader:
        case reshade::api::pipeline_subobject_type::pixel_shader:
        case reshade::api::pipeline_subobject_type::compute_shader:
        case reshade::api::pipeline_subobject_type::amplification_shader:
        case reshade::api::pipeline_subobject_type::mesh_shader:
          break;
        default: continue;
      }
      const auto* shader = static_cast<const reshade::api::shader_desc*>(subobjects[index].data);
      if (shader == nullptr || shader->code == nullptr || shader->code_size == 0u) continue;
      original_hashes[index] = hash::ComputeCRC32(static_cast<const uint8_t*>(shader->code), shader->code_size);
    }
  }
  bool modified = false;
  for (const auto callback : internal::shared.data->on_create_callbacks) {
    if (callback != nullptr && callback(device, layout, subobject_count, subobjects)) {
      modified = true;
    }
  }
  if (modified && internal::shared.data->track_shader_hashes) {
    PendingOriginalShaderHashes pending{.device = device, .subobjects = subobjects, .subobject_count = subobject_count};
    for (uint32_t index = 0u; index < subobject_count; ++index) {
      if (!original_hashes[index].has_value()) continue;
      const auto* shader = static_cast<const reshade::api::shader_desc*>(subobjects[index].data);
      if (shader == nullptr || shader->code == nullptr || shader->code_size == 0u) continue;
      pending.shaders.push_back({index, *original_hashes[index], shader->code, shader->code_size});
    }
    pending_original_shader_hashes = std::move(pending);
  }
  return modified;
}

static void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  std::optional<PendingOriginalShaderHashes> original_shader_hashes = std::move(pending_original_shader_hashes);
  pending_original_shader_hashes.reset();
  PipelineBindPoint bind_point = PipelineBindPoint::UNKNOWN;
  for (uint32_t index = 0u; index < subobject_count; ++index) {
    PipelineBindPoint subobject_bind_point = PipelineBindPoint::UNKNOWN;
    switch (subobjects[index].type) {
      case reshade::api::pipeline_subobject_type::compute_shader:
        subobject_bind_point = PipelineBindPoint::COMPUTE;
        break;
      case reshade::api::pipeline_subobject_type::raygen_shader:
      case reshade::api::pipeline_subobject_type::any_hit_shader:
      case reshade::api::pipeline_subobject_type::closest_hit_shader:
      case reshade::api::pipeline_subobject_type::miss_shader:
      case reshade::api::pipeline_subobject_type::intersection_shader:
      case reshade::api::pipeline_subobject_type::callable_shader:
      case reshade::api::pipeline_subobject_type::libraries:
      case reshade::api::pipeline_subobject_type::shader_groups:
        subobject_bind_point = PipelineBindPoint::RAY_TRACING;
        break;
      case reshade::api::pipeline_subobject_type::vertex_shader:
      case reshade::api::pipeline_subobject_type::hull_shader:
      case reshade::api::pipeline_subobject_type::domain_shader:
      case reshade::api::pipeline_subobject_type::geometry_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
      case reshade::api::pipeline_subobject_type::amplification_shader:
      case reshade::api::pipeline_subobject_type::mesh_shader:
      case reshade::api::pipeline_subobject_type::input_layout:
      case reshade::api::pipeline_subobject_type::stream_output_state:
      case reshade::api::pipeline_subobject_type::blend_state:
      case reshade::api::pipeline_subobject_type::rasterizer_state:
      case reshade::api::pipeline_subobject_type::depth_stencil_state:
      case reshade::api::pipeline_subobject_type::primitive_topology:
      case reshade::api::pipeline_subobject_type::depth_stencil_format:
      case reshade::api::pipeline_subobject_type::render_target_formats:
      case reshade::api::pipeline_subobject_type::sample_mask:
      case reshade::api::pipeline_subobject_type::sample_count:
      case reshade::api::pipeline_subobject_type::viewport_count:
      case reshade::api::pipeline_subobject_type::max_vertex_count:
        subobject_bind_point = PipelineBindPoint::GRAPHICS;
        break;
      default:
        break;
    }
    if (subobject_bind_point == PipelineBindPoint::UNKNOWN) continue;
    if (bind_point == PipelineBindPoint::UNKNOWN) {
      bind_point = subobject_bind_point;
    } else if (bind_point != subobject_bind_point) {
      bind_point = PipelineBindPoint::UNKNOWN;
      break;
    }
  }
  PipelineInfo info{
      .pipeline = pipeline,
      .device = device,
      .layout = layout,
      .bind_point = bind_point,
  };
  info.generation = internal::shared.data->next_pipeline_generation.fetch_add(1u) + 1u;
  if (internal::shared.data->track_shader_hashes) {
    for (uint32_t index = 0u; index < subobject_count; ++index) {
      const auto& subobject = subobjects[index];
      reshade::api::pipeline_stage stage;
      switch (subobject.type) {
        case reshade::api::pipeline_subobject_type::vertex_shader:        stage = reshade::api::pipeline_stage::vertex_shader; break;
        case reshade::api::pipeline_subobject_type::hull_shader:          stage = reshade::api::pipeline_stage::hull_shader; break;
        case reshade::api::pipeline_subobject_type::domain_shader:        stage = reshade::api::pipeline_stage::domain_shader; break;
        case reshade::api::pipeline_subobject_type::geometry_shader:      stage = reshade::api::pipeline_stage::geometry_shader; break;
        case reshade::api::pipeline_subobject_type::pixel_shader:         stage = reshade::api::pipeline_stage::pixel_shader; break;
        case reshade::api::pipeline_subobject_type::compute_shader:       stage = reshade::api::pipeline_stage::compute_shader; break;
        case reshade::api::pipeline_subobject_type::amplification_shader: stage = reshade::api::pipeline_stage::amplification_shader; break;
        case reshade::api::pipeline_subobject_type::mesh_shader:          stage = reshade::api::pipeline_stage::mesh_shader; break;
        default:                                                          continue;
      }
      const auto* shader = static_cast<const reshade::api::shader_desc*>(subobject.data);
      if (shader == nullptr || shader->code == nullptr || shader->code_size == 0u) continue;
      uint32_t shader_hash = hash::ComputeCRC32(static_cast<const uint8_t*>(shader->code), shader->code_size);
      if (original_shader_hashes.has_value()
          && original_shader_hashes->device == device
          && original_shader_hashes->subobjects == subobjects
          && original_shader_hashes->subobject_count == subobject_count) {
        const auto original = std::ranges::find_if(original_shader_hashes->shaders, [&](const auto& entry) {
          return entry.subobject_index == index && entry.code == shader->code && entry.code_size == shader->code_size;
        });
        if (original != original_shader_hashes->shaders.end()) {
          if (original->original_hash != shader_hash) {
            info.replaced_shader_subobject_indexes.push_back(index);
          }
          shader_hash = original->original_hash;
        }
      }
      info.shader_details.push_back({
          .subobject_index = index,
          .shader_hash = shader_hash,
          .stage = stage,
      });
    }
  }
  bool should_run_after_destroy_callbacks = false;
  const auto initialize = [&](PipelineInfo* current) {
    for (const auto callback : internal::shared.data->on_init_callbacks) {
      if (callback != nullptr) {
        callback(current, subobject_count, subobjects);
      }
    }
    current->shader_detail_by_stage.fill(std::nullopt);
    for (size_t index = 0u; index < current->shader_details.size(); ++index) {
      const auto stage_index = GetShaderStageIndex(current->shader_details[index].stage);
      if (stage_index < SHADER_STAGES.size()) {
        current->shader_detail_by_stage[stage_index] = index;
      }
    }
    current->shader_detail_index_ready = true;
  };
  internal::shared.data->pipeline_infos.lazy_emplace_l(
      pipeline.handle,
      [&](std::pair<const uint64_t, PipelineInfo>& pair) {
        if (!pair.second.details.destroyed) {
          for (const auto callback : internal::shared.data->on_destroy_callbacks) {
            if (callback != nullptr) {
              callback(pair.second);
            }
          }
          should_run_after_destroy_callbacks = true;
        }
        DestroyPipelineSubobjects(pair.second.details.subobjects);
        pair.second = std::move(info);
        initialize(&pair.second);
      },
      [&](const PipelineInfoMap::constructor& ctor) {
        const auto& entry = ctor(pipeline.handle, std::move(info));
        initialize(&const_cast<PipelineInfo&>(entry.second));
      });
  if (should_run_after_destroy_callbacks) {
    for (const auto callback : internal::shared.data->on_after_destroy_callbacks) {
      if (callback != nullptr) {
        callback();
      }
    }
  }
}

static void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline) {
  PipelineBindPoint bind_point = PipelineBindPoint::UNKNOWN;
  std::optional<reshade::api::pipeline> replacement;
  bool retry_unlocked = false;
  if (stages != reshade::api::pipeline_stage::all) {
    if (renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::pipeline_stage::all_ray_tracing)) {
      bind_point = PipelineBindPoint::RAY_TRACING;
    } else if (renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::pipeline_stage::all_compute)) {
      bind_point = PipelineBindPoint::COMPUTE;
    } else if (renodx::utils::bitwise::HasAnyFlag(
                   stages,
                   reshade::api::pipeline_stage::all_graphics
                       | reshade::api::pipeline_stage::amplification_shader
                       | reshade::api::pipeline_stage::mesh_shader)) {
      bind_point = PipelineBindPoint::GRAPHICS;
    }
  }
  bool found = false;
  if (stages == reshade::api::pipeline_stage::all
      || !internal::shared.data->on_bind_pipeline_info_callbacks.empty()) {
    found = GetPipelineInfo(pipeline, [&](const PipelineInfo& info) {
      if (stages == reshade::api::pipeline_stage::all) {
        bind_point = info.bind_point;
      }
      for (const auto callback : internal::shared.data->on_bind_pipeline_info_callbacks) {
        if (callback != nullptr) {
          replacement = callback(cmd_list, stages, pipeline, bind_point, &info);
          retry_unlocked = retry_unlocked || !replacement.has_value();
        }
      }
    });
    // assert(found && "Pipeline bind has no live PipelineInfo.");
  }
  for (const auto callback : internal::shared.data->on_bind_callbacks) {
    if (callback != nullptr) {
      callback(cmd_list, stages, pipeline, bind_point);
    }
  }
  if (found && retry_unlocked) {
    for (const auto callback : internal::shared.data->on_bind_pipeline_info_callbacks) {
      if (callback != nullptr) {
        replacement = callback(cmd_list, stages, pipeline, bind_point, nullptr);
      }
    }
  }
  if (replacement.has_value() && replacement->handle != 0u) {
    cmd_list->bind_pipeline(stages, *replacement);
  }
}

static void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  (void)device;
  std::optional<PipelineInfo> destroyed_info;
  internal::shared.data->pipeline_infos.modify_if(
      pipeline.handle,
      [&](auto& entry) {
        if (entry.second.details.destroyed) return;
        const auto& info = entry.second;
        destroyed_info.emplace(PipelineInfo{
            .pipeline = info.pipeline,
            .device = info.device,
            .layout = info.layout,
            .bind_point = info.bind_point,
            .shader_details = info.shader_details,
            .replaced_shader_subobject_indexes = info.replaced_shader_subobject_indexes,
            .generation = info.generation,
            .shader_detail_by_stage = info.shader_detail_by_stage,
            .shader_detail_index_ready = info.shader_detail_index_ready,
        });
        destroyed_info->details.replacement_pipeline = info.details.replacement_pipeline;
        entry.second.details.replacement_pipeline = {0u};
        entry.second.details.destroyed = true;
        ++entry.second.details.replacement_revision;
      });
  if (!destroyed_info.has_value()) return;
  for (const auto callback : internal::shared.data->on_destroy_callbacks) {
    if (callback != nullptr) {
      callback(*destroyed_info);
    }
  }
  bool retain_cache = false;
  internal::shared.data->pipeline_infos.modify_if(pipeline.handle, [&](auto& entry) {
    auto& details = entry.second.details;
    entry.second.shader_details.clear();
    entry.second.shader_detail_by_stage.fill(std::nullopt);
    entry.second.shader_detail_index_ready = false;
    entry.second.replaced_shader_subobject_indexes.clear();
    retain_cache = internal::shared.data->retain_destroyed_subobjects && !details.subobjects.empty();
    if (!retain_cache) {
      DestroyPipelineSubobjects(details.subobjects);
    }
  });
  if (!retain_cache) {
    internal::shared.data->pipeline_infos.erase(pipeline.handle);
  }
  for (const auto callback : internal::shared.data->on_after_destroy_callbacks) {
    if (callback != nullptr) {
      callback();
    }
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::vector<uint64_t> pipeline_handles;
  internal::shared.data->pipeline_infos.for_each_m([&](auto& entry) {
    auto& [pipeline_handle, info] = entry;
    if (info.device != device) return;
    pipeline_handles.push_back(pipeline_handle);
    DestroyPipelineSubobjects(info.details.subobjects);
  });
  for (const auto pipeline_handle : pipeline_handles) {
    internal::shared.data->pipeline_infos.erase(pipeline_handle);
  }
}

static void RegisterOnInitCallback(InitCallback callback) {
  internal::shared.RegisterCallback(&internal::SharedData::on_init_callbacks, callback);
}

static void RegisterOnCreateCallback(CreateCallback callback, bool active = true) {
  internal::shared.RegisterCallback(&internal::SharedData::on_create_callbacks, callback, active);
  if (active) {
    if (std::find(local_create_callbacks.begin(), local_create_callbacks.end(), callback) == local_create_callbacks.end()) {
      local_create_callbacks.push_back(callback);
    }
  } else {
    std::erase(local_create_callbacks, callback);
  }
  internal::shared.RegisterEvent<reshade::addon_event::create_pipeline>(OnCreatePipeline, !local_create_callbacks.empty());
}

static void RegisterOnBindCallback(BindCallback callback, bool active = true) {
  internal::shared.RegisterCallback(&internal::SharedData::on_bind_callbacks, callback, active);
  if (active) {
    if (std::find(local_bind_callbacks.begin(), local_bind_callbacks.end(), callback) == local_bind_callbacks.end()) {
      local_bind_callbacks.push_back(callback);
    }
  } else {
    std::erase(local_bind_callbacks, callback);
  }
  internal::shared.RegisterEvent<reshade::addon_event::bind_pipeline>(
      OnBindPipeline, !local_bind_callbacks.empty() || !local_bind_info_callbacks.empty());
}

static void RegisterOnBindInfoCallback(BindInfoCallback callback) {
  internal::shared.RegisterCallback(&internal::SharedData::on_bind_pipeline_info_callbacks, callback);
  if (std::find(local_bind_info_callbacks.begin(), local_bind_info_callbacks.end(), callback) == local_bind_info_callbacks.end()) {
    local_bind_info_callbacks.push_back(callback);
  }
  internal::shared.RegisterEvent<reshade::addon_event::bind_pipeline>(OnBindPipeline, true);
}

static void RegisterOnDestroyCallback(DestroyCallback callback) {
  internal::shared.RegisterCallback(&internal::SharedData::on_destroy_callbacks, callback);
}

static void RegisterOnAfterDestroyCallback(AfterDestroyCallback callback) {
  internal::shared.RegisterCallback(&internal::SharedData::on_after_destroy_callbacks, callback);
}

static void UnregisterOnInitCallback(InitCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_init_callbacks, callback);
}

static void UnregisterOnCreateCallback(CreateCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_create_callbacks, callback);
  std::erase(local_create_callbacks, callback);
  internal::shared.RegisterEvent<reshade::addon_event::create_pipeline>(OnCreatePipeline, !local_create_callbacks.empty());
}

static void UnregisterOnBindCallback(BindCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_bind_callbacks, callback);
  std::erase(local_bind_callbacks, callback);
  internal::shared.RegisterEvent<reshade::addon_event::bind_pipeline>(
      OnBindPipeline, !local_bind_callbacks.empty() || !local_bind_info_callbacks.empty());
}

static void UnregisterOnBindInfoCallback(BindInfoCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_bind_pipeline_info_callbacks, callback);
  std::erase(local_bind_info_callbacks, callback);
  internal::shared.RegisterEvent<reshade::addon_event::bind_pipeline>(
      OnBindPipeline, !local_bind_callbacks.empty() || !local_bind_info_callbacks.empty());
}

static void UnregisterOnDestroyCallback(DestroyCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_destroy_callbacks, callback);
}

static void UnregisterOnAfterDestroyCallback(AfterDestroyCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_after_destroy_callbacks, callback);
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) {
        if (track_shader_hashes) {
          internal::shared.data->track_shader_hashes = true;
        }
        if (cache_subobjects) {
          internal::shared.data->cache_subobjects = true;
        }
        if (retain_destroyed_subobjects) {
          internal::shared.data->retain_destroyed_subobjects = true;
        }
        return;
      }
      attached = true;
      if (internal::shared.RegisterModule([](internal::SharedData& data) {
            data.track_shader_hashes = data.track_shader_hashes || track_shader_hashes;
            data.retain_destroyed_subobjects = data.retain_destroyed_subobjects || retain_destroyed_subobjects;
            data.cache_subobjects = data.cache_subobjects || cache_subobjects;
          })) {
        reshade::log::message(reshade::log::level::info, "PipelineUtil attached.");
      }
      internal::shared.RegisterEvent<reshade::addon_event::init_pipeline>(OnInitPipeline);
      internal::shared.RegisterEvent<reshade::addon_event::create_pipeline>(OnCreatePipeline, !local_create_callbacks.empty());
      internal::shared.RegisterEvent<reshade::addon_event::bind_pipeline>(
          OnBindPipeline, !local_bind_callbacks.empty() || !local_bind_info_callbacks.empty());
      internal::shared.RegisterEvent<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
      internal::shared.RegisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      internal::shared.UnregisterEvent<reshade::addon_event::init_pipeline>(OnInitPipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::create_pipeline>(OnCreatePipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
      internal::shared.UnregisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      internal::shared.UnregisterModule();
      local_create_callbacks.clear();
      local_bind_callbacks.clear();
      local_bind_info_callbacks.clear();
      break;
  }
}
}  // namespace renodx::utils::pipeline
