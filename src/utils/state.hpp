/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d10_1.h>
#include <d3d11_1.h>
#include <d3d12.h>
#include <d3d9.h>
#include <algorithm>
#include <array>
#include <bit>
#include <cassert>
#include <cstdint>
#include <cstdlib>
#include <filesystem>
#include <include/reshade.hpp>
#include <limits>
#include <memory>
#include <span>
#include <type_traits>
#include <unordered_map>
#include <utility>
#include <variant>
#include <vector>

#include "./bitwise.hpp"
#include "./cross_addon.hpp"
#include "./data.hpp"
#include "./flagged_array.hpp"
#include "./flagged_vector.hpp"
#include "./pipeline.hpp"
#include "./pipeline_layout.hpp"
#include "./resource.hpp"

namespace renodx::utils::state {

using DescriptorTableSlots = FlaggedVector<reshade::api::descriptor_table, cross_addon::allocator<reshade::api::descriptor_table>>;

using PipelineBindPoint = renodx::utils::pipeline::PipelineBindPoint;

static constexpr size_t D3D12_ROOT_DWORD_BUDGET = 64u;
// Every root parameter consumes at least one DWORD of the signature budget.
static constexpr size_t D3D12_ROOT_PARAMETER_COUNT = D3D12_ROOT_DWORD_BUDGET;
static constexpr size_t GRAPHICS_ROOT_DOMAIN = 0u;
static constexpr size_t COMPUTE_ROOT_DOMAIN = 1u;
static constexpr std::array D3D12_ROOT_STAGES = {
    reshade::api::shader_stage::all_graphics,
    reshade::api::shader_stage::all_compute | reshade::api::shader_stage::all_ray_tracing};
static constexpr uint32_t DESCRIPTOR_TABLE_REPLAY_BATCH_SIZE = 64u;

// Configure before Use(DLL_PROCESS_ATTACH); repeated initialization calls merge
// requirements. Snapshot capture requires the blanket opt-in before recording.
static bool use_snapshot = false;
static bool use_pipeline_tracking = false;
static bool use_render_target_tracking = false;
static bool use_dynamic_state_tracking = false;
static bool use_viewport_scissor_tracking = false;
static bool use_input_assembler_tracking = false;
static bool use_push_constants = false;
static bool use_push_descriptors = false;
static bool use_descriptor_tables = false;

struct __declspec(uuid("a23ef49c-44e1-4581-bf5b-bec964237b80")) SharedData {
  bool use_snapshot = false;
  bool use_pipeline_tracking = false;
  bool use_render_target_tracking = false;
  bool use_dynamic_state_tracking = false;
  bool use_viewport_scissor_tracking = false;
  bool use_input_assembler_tracking = false;
  bool use_push_constants = false;
  bool use_push_descriptors = false;
  bool use_descriptor_tables = false;
};

static cross_addon::Shared<SharedData> shared;

struct PipelineBind {
  reshade::api::pipeline_stage stages = reshade::api::pipeline_stage::all;
  reshade::api::pipeline pipeline = {0u};
  PipelineBindPoint bind_point = PipelineBindPoint::UNKNOWN;
  uint64_t sequence = 0u;
};

static bool vertex_and_index_buffer_events_registered = false;

static constexpr reshade::api::shader_stage TRACKED_SHADER_STAGES[] = {
    reshade::api::shader_stage::vertex,
    reshade::api::shader_stage::hull,
    reshade::api::shader_stage::domain,
    reshade::api::shader_stage::geometry,
    reshade::api::shader_stage::pixel,
    reshade::api::shader_stage::compute,
    reshade::api::shader_stage::amplification,
    reshade::api::shader_stage::mesh,
    reshade::api::shader_stage::raygen,
    reshade::api::shader_stage::any_hit,
    reshade::api::shader_stage::closest_hit,
    reshade::api::shader_stage::miss,
    reshade::api::shader_stage::intersection,
    reshade::api::shader_stage::callable,
};

static constexpr size_t TRACKED_SHADER_STAGE_COUNT = std::size(TRACKED_SHADER_STAGES);

static_assert([] {
  for (size_t index = 0u; index < TRACKED_SHADER_STAGE_COUNT; ++index) {
    if (static_cast<uint32_t>(TRACKED_SHADER_STAGES[index]) != (uint32_t{1} << index)) return false;
  }
  return true;
}());

static constexpr size_t GetSingleTrackedShaderStageIndex(reshade::api::shader_stage stage) {
  const auto value = static_cast<uint32_t>(stage);
  if (!std::has_single_bit(value)) return TRACKED_SHADER_STAGE_COUNT;

  // Shader stages are consecutive one-hot bits, so the trailing-zero count is their index.
  const auto index = static_cast<size_t>(std::countr_zero(value));
  return index < TRACKED_SHADER_STAGE_COUNT ? index : TRACKED_SHADER_STAGE_COUNT;
}

static constexpr size_t GetDescriptorSizeOf(reshade::api::descriptor_type type) {
  switch (type) {
    case reshade::api::descriptor_type::sampler:
      return sizeof(reshade::api::sampler);
    case reshade::api::descriptor_type::sampler_with_resource_view:
      return sizeof(reshade::api::sampler_with_resource_view);
    case reshade::api::descriptor_type::shader_resource_view:
    case reshade::api::descriptor_type::unordered_access_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::acceleration_structure:
      return sizeof(reshade::api::resource_view);
    case reshade::api::descriptor_type::constant_buffer:
    case reshade::api::descriptor_type::shader_storage_buffer:
#if RESHADE_API_VERSION >= 20
    case reshade::api::descriptor_type::constant_buffer_with_dynamic_offset:
    case reshade::api::descriptor_type::shader_storage_buffer_with_dynamic_offset:
#endif
      return sizeof(reshade::api::buffer_range);
    default:
      return 0u;
  }
}

static constexpr bool IsResourceViewDescriptorType(reshade::api::descriptor_type type) {
  switch (type) {
    case reshade::api::descriptor_type::sampler_with_resource_view:
    case reshade::api::descriptor_type::shader_resource_view:
    case reshade::api::descriptor_type::unordered_access_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::acceleration_structure:
      return true;
    default:
      return false;
  }
}

static constexpr reshade::api::descriptor_type GetResourceViewBindingType(reshade::api::descriptor_type type) {
  switch (type) {
    case reshade::api::descriptor_type::sampler_with_resource_view:
    case reshade::api::descriptor_type::shader_resource_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::acceleration_structure:
      return reshade::api::descriptor_type::shader_resource_view;
    case reshade::api::descriptor_type::unordered_access_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
      return reshade::api::descriptor_type::unordered_access_view;
    default:
      return type;
  }
}

struct DescriptorStorage {
  using Storage = std::variant<
      cross_addon::vector<reshade::api::sampler>,
      cross_addon::vector<reshade::api::resource_view>,
      cross_addon::vector<reshade::api::buffer_range>,
      cross_addon::vector<reshade::api::sampler_with_resource_view>>;

  Storage storage;

  void Reset(reshade::api::descriptor_type type) {
    switch (type) {
      case reshade::api::descriptor_type::sampler:
        storage.emplace<cross_addon::vector<reshade::api::sampler>>();
        break;
      case reshade::api::descriptor_type::sampler_with_resource_view:
        storage.emplace<cross_addon::vector<reshade::api::sampler_with_resource_view>>();
        break;
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::unordered_access_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::acceleration_structure:
        storage.emplace<cross_addon::vector<reshade::api::resource_view>>();
        break;
      case reshade::api::descriptor_type::constant_buffer:
      case reshade::api::descriptor_type::shader_storage_buffer:
#if RESHADE_API_VERSION >= 20
      case reshade::api::descriptor_type::constant_buffer_with_dynamic_offset:
      case reshade::api::descriptor_type::shader_storage_buffer_with_dynamic_offset:
#endif
        storage.emplace<cross_addon::vector<reshade::api::buffer_range>>();
        break;
      default:
        assert(false);
        storage.emplace<cross_addon::vector<reshade::api::sampler>>();
        break;
    }
  }

  void Clear() {
    std::visit([](auto& values) { values.clear(); }, storage);
  }

  [[nodiscard]] size_t Size() const {
    return std::visit([](const auto& values) { return values.size(); }, storage);
  }

  [[nodiscard]] const void* Data(size_t index = 0u) const {
    return std::visit(
        [&](const auto& values) -> const void* {
          assert(index <= values.size());
          return values.data() + index;
        },
        storage);
  }

  void Resize(reshade::api::descriptor_type type, size_t count) {
    if (!Matches(type)) {
      Reset(type);
    }
    std::visit([&](auto& values) { values.resize(count); }, storage);
  }

  void Assign(reshade::api::descriptor_type type, const void* descriptors, size_t count) {
    if (!Matches(type)) {
      Reset(type);
    }
    assert(descriptors != nullptr);
    std::visit(
        [&](auto& values) {
          using Descriptor = typename std::decay_t<decltype(values)>::value_type;
          const auto* source = static_cast<const Descriptor*>(descriptors);
          values.assign(source, source + count);
        },
        storage);
  }

  void Copy(reshade::api::descriptor_type type, size_t first, const void* descriptors, size_t count) {
    assert(Matches(type));
    assert(descriptors != nullptr);
    std::visit(
        [&](auto& values) {
          using Descriptor = typename std::decay_t<decltype(values)>::value_type;
          assert(first <= values.size() && count <= values.size() - first);
          const auto* source = static_cast<const Descriptor*>(descriptors);
          std::copy(source, source + count, values.begin() + first);
        },
        storage);
  }

  [[nodiscard]] bool Matches(reshade::api::descriptor_type type) const {
    switch (type) {
      case reshade::api::descriptor_type::sampler:
        return std::holds_alternative<cross_addon::vector<reshade::api::sampler>>(storage);
      case reshade::api::descriptor_type::sampler_with_resource_view:
        return std::holds_alternative<cross_addon::vector<reshade::api::sampler_with_resource_view>>(storage);
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::unordered_access_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::acceleration_structure:
        return std::holds_alternative<cross_addon::vector<reshade::api::resource_view>>(storage);
      case reshade::api::descriptor_type::constant_buffer:
      case reshade::api::descriptor_type::shader_storage_buffer:
#if RESHADE_API_VERSION >= 20
      case reshade::api::descriptor_type::constant_buffer_with_dynamic_offset:
      case reshade::api::descriptor_type::shader_storage_buffer_with_dynamic_offset:
#endif
        return std::holds_alternative<cross_addon::vector<reshade::api::buffer_range>>(storage);
      default:
        return false;
    }
  }
};

static void ReplayPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  cmd_list->push_descriptors(stages, layout, layout_param, update);

  if (update.type == reshade::api::descriptor_type::buffer_unordered_access_view
      && update.binding == 0u
      && update.array_offset == 0u
      && update.count == 1u
      && renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_graphics)
      && cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) {
    bool is_root_descriptor = false;
    renodx::utils::pipeline_layout::GetPipelineLayoutData(
        layout,
        [&](const auto* layout_data) {
          if (layout_param >= layout_data->params.size()) return;
          const auto& param = layout_data->params[layout_param];
          if (param.type != reshade::api::pipeline_layout_param_type::push_descriptors) return;
          is_root_descriptor = param.push_descriptors.binding == 0u
                               && param.push_descriptors.count == 1u
                               && param.push_descriptors.type
                                      == reshade::api::descriptor_type::buffer_unordered_access_view;
        });

    if (is_root_descriptor) {
      const auto gpu_address = cmd_list->get_device()->get_resource_view_gpu_address(
          *static_cast<const reshade::api::resource_view*>(update.descriptors));
      assert(gpu_address != 0u);
      if (gpu_address == 0u) return;

      // ReShade 6.7.3 incorrectly uses SetGraphicsRootShaderResourceView for
      // this case. Keep its bookkeeping call above, then correct the native
      // graphics root argument.
      auto* native_cmd_list = reinterpret_cast<ID3D12GraphicsCommandList*>(
          static_cast<uintptr_t>(cmd_list->get_native()));
      native_cmd_list->SetGraphicsRootUnorderedAccessView(layout_param, gpu_address);
    }
  }
}

struct PushedDescriptorSlots {
  uint32_t layout_param = 0u;
  reshade::api::descriptor_type type = reshade::api::descriptor_type::sampler;
  DescriptorStorage descriptor_data;
  cross_addon::vector<uint8_t> known_slots;

  void Reset(uint32_t new_layout_param, reshade::api::descriptor_type new_type) {
    layout_param = new_layout_param;
    type = new_type;
    descriptor_data.Resize(type, 0u);
    known_slots.clear();
  }

  void Update(uint32_t binding, uint32_t count, const void* descriptors) {
    assert(count != 0u);
    assert(descriptors != nullptr);
    const auto descriptor_size = GetDescriptorSizeOf(type);
    assert(descriptor_size != 0u);
    if (count == 0u || descriptors == nullptr || descriptor_size == 0u) return;

    const uint32_t total_count = binding + count;
    if (descriptor_data.Size() < total_count) {
      known_slots.resize(total_count);
      descriptor_data.Resize(type, total_count);
    }

    descriptor_data.Copy(type, binding, descriptors, count);
    std::fill(known_slots.begin() + binding, known_slots.begin() + total_count, 1u);
  }

  [[nodiscard]] reshade::api::resource_view GetResourceView(uint32_t binding) const {
    const auto descriptor_size = GetDescriptorSizeOf(type);
    if (binding >= known_slots.size() || known_slots[binding] == 0u) return {0};

    if (type == reshade::api::descriptor_type::sampler_with_resource_view) {
      if (descriptor_size != sizeof(reshade::api::sampler_with_resource_view)
          || descriptor_data.Size() <= binding) {
        return {0};
      }
      return static_cast<const reshade::api::sampler_with_resource_view*>(
                 descriptor_data.Data(binding))
          ->view;
    }

    if (!IsResourceViewDescriptorType(type)
        || descriptor_size != sizeof(reshade::api::resource_view)
        || descriptor_data.Size() <= binding) {
      return {0};
    }
    return *static_cast<const reshade::api::resource_view*>(descriptor_data.Data(binding));
  }

  [[nodiscard]] bool GetSamplerWithResourceView(
      uint32_t binding,
      reshade::api::sampler_with_resource_view* descriptor) const {
    if (descriptor == nullptr
        || type != reshade::api::descriptor_type::sampler_with_resource_view
        || binding >= known_slots.size()
        || known_slots[binding] == 0u
        || descriptor_data.Size() <= binding) {
      return false;
    }

    *descriptor = *static_cast<const reshade::api::sampler_with_resource_view*>(
        descriptor_data.Data(binding));
    return true;
  }
};

struct ResourceViewBind {
  reshade::api::descriptor_type type = reshade::api::descriptor_type::shader_resource_view;
  uint32_t slot = 0u;
  uint32_t space = 0u;
  reshade::api::resource_view view = {0u};
};

struct PushedDescriptorUpdate {
  uint32_t layout_param = 0u;
  uint32_t binding = 0u;
  uint32_t array_offset = 0u;
  uint32_t count = 0u;
  reshade::api::descriptor_type type = reshade::api::descriptor_type::sampler;
  DescriptorStorage descriptor_data;

  void Clear() {
    descriptor_data.Clear();
  }

  void Store(uint32_t new_layout_param,
             const reshade::api::descriptor_table_update& update) {
    assert(update.count != 0u);
    assert(update.descriptors != nullptr);
    const auto descriptor_size = GetDescriptorSizeOf(update.type);
    assert(descriptor_size != 0u);

    layout_param = new_layout_param;
    binding = update.binding;
    array_offset = update.array_offset;
    count = update.count;
    type = update.type;

    descriptor_data.Assign(type, update.descriptors, update.count);
  }
};

struct PushedConstants {
  uint32_t layout_param = 0u;
  FlaggedVector<uint32_t, cross_addon::allocator<uint32_t>> values;

  void Reset(uint32_t new_layout_param) {
    layout_param = new_layout_param;
    values.clear();
  }
};

struct DescriptorBank {
  static constexpr size_t WORD_BITS = std::numeric_limits<size_t>::digits;
  uint32_t layout_param = 0u;
  uint32_t binding = 0u;
  uint32_t count = 0u;
  reshade::api::descriptor_type type = reshade::api::descriptor_type::sampler;
  DescriptorStorage payload;
  cross_addon::vector<size_t> present;

  void AssertInvariants() const {
#ifndef NDEBUG
    const auto descriptor_size = GetDescriptorSizeOf(type);
    assert(descriptor_size != 0u);
    assert(payload.Matches(type));
    assert(payload.Size() == count);
    assert(present.size() == (static_cast<size_t>(count) / WORD_BITS) + (count % WORD_BITS != 0u ? 1u : 0u));
    if (count % WORD_BITS != 0u) {
      assert((present.back() >> (count % WORD_BITS)) == 0u);
    }
#endif
  }

  size_t Next(size_t first) const {
    if (first >= count) return count;
    size_t word_index = first / WORD_BITS;
    size_t word = present[word_index] & (std::numeric_limits<size_t>::max() << (first % WORD_BITS));
    while (word == 0u) {
      if (++word_index == present.size()) return count;
      word = present[word_index];
    }
    return (word_index * WORD_BITS) + std::countr_zero(word);
  }

  [[nodiscard]] const void* Data(size_t index = 0u) const {
    return payload.Data(index);
  }
};

struct D3D12RootDescriptor {
  reshade::api::descriptor_type type = reshade::api::descriptor_type::constant_buffer;
  reshade::api::buffer_range buffer = {};
  reshade::api::resource_view view = {};
};

struct ShaderStagePushState {
  reshade::api::shader_stage stage = reshade::api::shader_stage::all;
  reshade::api::pipeline_layout layout = {0};
  cross_addon::vector<PushedDescriptorSlots> descriptor_slots;
  cross_addon::vector<PushedDescriptorUpdate> descriptors;
  cross_addon::vector<PushedConstants> constants;
  cross_addon::vector<ResourceViewBind> resource_view_binds;
  size_t descriptor_slot_count = 0u;
  size_t descriptor_count = 0u;
  size_t constant_count = 0u;
  cross_addon::vector<DescriptorBank> descriptor_banks;
  bool has_unresolved_descriptors = false;
  FlaggedArray<D3D12RootDescriptor, D3D12_ROOT_PARAMETER_COUNT>* root_descriptors = nullptr;

  void AssertInvariants() const {
#ifndef NDEBUG
    assert(descriptor_slot_count <= descriptor_slots.size());
    assert(descriptor_count <= descriptors.size());
    assert(constant_count <= constants.size());
    for (size_t i = 0u; i < descriptor_slot_count; ++i) {
      const auto& slots = descriptor_slots[i];
      const auto descriptor_size = GetDescriptorSizeOf(slots.type);
      assert(descriptor_size != 0u);
      assert(slots.descriptor_data.Matches(slots.type));
      assert(slots.descriptor_data.Size() == slots.known_slots.size());
    }
    for (size_t i = 0u; i < descriptor_count; ++i) {
      const auto& descriptor = descriptors[i];
      const auto descriptor_size = GetDescriptorSizeOf(descriptor.type);
      assert(descriptor_size != 0u);
      assert(descriptor.descriptor_data.Matches(descriptor.type));
      assert(descriptor.descriptor_data.Size() == descriptor.count);
    }
    for (const auto& bank : descriptor_banks) bank.AssertInvariants();
#endif
  }

  reshade::api::resource_view GetResourceViewBind(reshade::api::descriptor_type type,
                                                  uint32_t slot,
                                                  uint32_t space) const {
    assert(IsResourceViewDescriptorType(type));
    if (!IsResourceViewDescriptorType(type)) return {0u};
    const auto bind_type = GetResourceViewBindingType(type);
    for (const auto& bind : resource_view_binds) {
      if (bind.type == bind_type && bind.slot == slot && bind.space == space) return bind.view;
    }
    return {0u};
  }

  PushedDescriptorSlots* GetDescriptorSlots(uint32_t layout_param, reshade::api::descriptor_type type) {
    for (size_t i = 0; i < descriptor_slot_count; ++i) {
      auto& slots = descriptor_slots[i];
      if (slots.layout_param == layout_param && slots.type == type) return &slots;
    }

    assert(GetDescriptorSizeOf(type) != 0u);
    if (descriptor_slot_count == descriptor_slots.size()) {
      descriptor_slots.emplace_back();
    }
    auto& slots = descriptor_slots[descriptor_slot_count++];
    slots.Reset(layout_param, type);
    return &slots;
  }

  PushedDescriptorUpdate* AddDescriptorUpdate() {
    if (descriptor_count == descriptors.size()) {
      descriptors.emplace_back();
    }
    return &descriptors[descriptor_count++];
  }

  PushedConstants* GetConstants(uint32_t layout_param) {
    for (size_t i = 0; i < constant_count; ++i) {
      auto& candidate = constants[i];
      if (candidate.layout_param == layout_param) return &candidate;
    }

    if (constant_count == constants.size()) {
      constants.emplace_back();
    }
    auto& candidate = constants[constant_count++];
    candidate.Reset(layout_param);
    return &candidate;
  }

  void SetLayout(reshade::api::pipeline_layout new_layout) {
    if (layout != new_layout) {
      ClearPushedState();
      descriptor_banks.clear();
    }
    layout = new_layout;
  }

  void Clear() {
    layout = {0};
    if (root_descriptors != nullptr
        && descriptor_slot_count == 0u && descriptor_count == 0u && constant_count == 0u
        && descriptor_banks.empty() && resource_view_binds.empty()) {
      root_descriptors->clear();
      has_unresolved_descriptors = false;
      return;
    }
    ClearPushedState();
    descriptor_banks.clear();
  }

  void ClearPushedState() {
    if (root_descriptors != nullptr) {
      root_descriptors->clear();
    }
    for (size_t i = 0; i < descriptor_slot_count; ++i) {
      descriptor_slots[i].descriptor_data.Clear();
      descriptor_slots[i].known_slots.clear();
    }
    for (size_t i = 0; i < descriptor_count; ++i) {
      descriptors[i].Clear();
    }
    for (size_t i = 0; i < constant_count; ++i) {
      constants[i].values.clear();
    }
    descriptor_slot_count = 0u;
    descriptor_count = 0u;
    for (auto& bank : descriptor_banks) std::fill(bank.present.begin(), bank.present.end(), size_t{0});
    has_unresolved_descriptors = false;
    constant_count = 0u;
    resource_view_binds.clear();
  }
};

template <typename T, size_t Count>
struct NativeDescriptorSlots {
  FlaggedArray<T, Count> slots;

  void Update(uint32_t first, uint32_t count, const void* source) {
    assert(first <= Count && count <= Count - first);
    if (first > Count || count > Count - first) return;
    if (count == 0u) return;
    assert(source != nullptr);
    if (source == nullptr) return;
    slots.setRange(first, {static_cast<const T*>(source), count});
  }

  void Apply(reshade::api::command_list* cmd_list, reshade::api::shader_stage stage,
             reshade::api::pipeline_layout layout, uint32_t param,
             reshade::api::descriptor_type type) const {
    slots.forEachRange([&](size_t first, std::span<const T> values) {
      cmd_list->push_descriptors(
          stage,
          layout,
          param,
          {
              .binding = static_cast<uint32_t>(first),
              .count = static_cast<uint32_t>(values.size()),
              .type = type,
              .descriptors = values.data(),
          });
    });
  }
};

static constexpr uint32_t D3D9_VERTEX_SAMPLER_LAYOUT_PARAM = 0u;
static constexpr uint32_t D3D9_PIXEL_SAMPLER_LAYOUT_PARAM = 1u;

struct D3D10And11DescriptorState {
  static constexpr uint32_t SAMPLER_LAYOUT_PARAM = 0u;
  static constexpr uint32_t SHADER_RESOURCE_VIEW_LAYOUT_PARAM = 1u;
  static constexpr uint32_t CONSTANT_BUFFER_LAYOUT_PARAM = 2u;
  static constexpr uint32_t UNORDERED_ACCESS_VIEW_LAYOUT_PARAM = 3u;
  static constexpr std::array SHADER_STAGES = {
      reshade::api::shader_stage::vertex,
      reshade::api::shader_stage::hull,
      reshade::api::shader_stage::domain,
      reshade::api::shader_stage::geometry,
      reshade::api::shader_stage::pixel,
      reshade::api::shader_stage::compute,
  };

  struct Stage {
    reshade::api::pipeline_layout layout = {};
    NativeDescriptorSlots<reshade::api::sampler, D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT> samplers;
    NativeDescriptorSlots<reshade::api::resource_view, D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT> srvs;
    NativeDescriptorSlots<reshade::api::buffer_range, 14u> cbvs;
  };
  std::array<Stage, SHADER_STAGES.size()> stages;
  NativeDescriptorSlots<reshade::api::resource_view, D3D11_1_UAV_SLOT_COUNT> graphics_uavs;
  NativeDescriptorSlots<reshade::api::resource_view, D3D11_1_UAV_SLOT_COUNT> compute_uavs;
};

namespace internal {

struct D3D12RootConstants {
  struct ParameterRange {
    uint8_t offset = 0u;
    uint8_t count = 0u;
  };
  FlaggedArray<ParameterRange, D3D12_ROOT_PARAMETER_COUNT> parameters;
  FlaggedArray<uint32_t, D3D12_ROOT_DWORD_BUDGET> values;
  uint32_t used = 0u;

  void Update(uint32_t layout_param, uint32_t first, std::span<const uint32_t> source) {
    assert(layout_param < D3D12_ROOT_PARAMETER_COUNT && first <= D3D12_ROOT_DWORD_BUDGET && source.size() <= D3D12_ROOT_DWORD_BUDGET - first);
    if (layout_param >= D3D12_ROOT_PARAMETER_COUNT || first > D3D12_ROOT_DWORD_BUDGET || source.size() > D3D12_ROOT_DWORD_BUDGET - first || source.empty()) return;
    const auto end = static_cast<uint32_t>(first + source.size());
    if (parameters.has(layout_param)) {
      auto& range = parameters.get(layout_param);
      if (end > range.count) {
        const uint32_t extra = end - range.count;
        assert(extra <= D3D12_ROOT_DWORD_BUDGET - used);
        if (extra > D3D12_ROOT_DWORD_BUDGET - used) return;
        const uint32_t insertion = range.offset + range.count;
        // Growth is rare; move later parameters backwards without reviving holes.
        for (uint32_t index = used; index > insertion;) {
          --index;
          if (values.has(index)) {
            values.set(index + extra, values.get(index));
          } else {
            values.reset(index + extra);
          }
        }
        values.clear(insertion, extra);
        for (auto& parameter : parameters.values()) {
          if (parameter.offset >= insertion) {
            parameter.offset = static_cast<uint8_t>(parameter.offset + extra);
          }
        }
        range.count = static_cast<uint8_t>(end);
        used += extra;
      }
      values.setRange(range.offset + first, source);
    } else {
      assert(end <= D3D12_ROOT_DWORD_BUDGET - used);
      if (end > D3D12_ROOT_DWORD_BUDGET - used) return;
      parameters.set(layout_param, ParameterRange{.offset = static_cast<uint8_t>(used), .count = static_cast<uint8_t>(end)});
      values.setRange(used + first, source);
      used += end;
    }
  }

  void Clear() {
    if (used == 0u) return;
    parameters.clear();
    values.clear();
    used = 0u;
  }

  void Apply(reshade::api::command_list* cmd_list, reshade::api::shader_stage stages,
             reshade::api::pipeline_layout layout) const {
    if (layout.handle == 0u) return;
    for (const auto& [param, range] : parameters.entries()) {
      // Each native call is bounded by its parameter even when payloads are adjacent.
      uint32_t first = 0u;
      while (first < range.count) {
        while (first < range.count && !values.has(range.offset + first)) ++first;
        if (first == range.count) break;
        uint32_t end = first + 1u;
        while (end < range.count && values.has(range.offset + end)) ++end;
        cmd_list->push_constants(stages, layout, static_cast<uint32_t>(param), first, end - first,
                                 &values.get(range.offset + first));
        first = end;
      }
    }
  }
};

struct CommandListSnapshotData {
  // Active borrowed range; typed snapshot copies rebind to their own storage.
  std::span<reshade::api::resource_view> render_targets;
  reshade::api::resource_view depth_stencil = {0};
  reshade::api::primitive_topology primitive_topology = reshade::api::primitive_topology::undefined;
  uint32_t blend_constant = 0;
  uint32_t sample_mask = 0xFFFFFFFF;
  uint32_t front_stencil_reference_value = 0;
  uint32_t back_stencil_reference_value = 0;
  cross_addon::vector<reshade::api::viewport> viewports;
  cross_addon::vector<uint8_t> known_viewport_slots;
  cross_addon::vector<reshade::api::rect> scissor_rects;
  cross_addon::vector<uint8_t> known_scissor_rect_slots;
  reshade::api::pipeline_layout graphics_pipeline_layout = {0};
  reshade::api::pipeline_layout compute_pipeline_layout = {0};
  reshade::api::pipeline_layout ray_tracing_pipeline_layout = {0};
  // Borrowed from BackendSnapshotData; owning copies must rebind this view.
  std::span<ShaderStagePushState> shader_stage_push_states;
  // Empty outside D3D12; rebound by the typed snapshot owner on every copy/move.
  std::span<D3D12RootConstants> root_constants;
  cross_addon::vector<reshade::api::resource> vertex_buffers;
  cross_addon::vector<uint64_t> vertex_buffer_offsets;
  cross_addon::vector<uint32_t> vertex_buffer_strides;
  cross_addon::vector<uint8_t> known_vertex_buffer_slots;
  reshade::api::resource index_buffer = {0};
  uint64_t index_buffer_offset = 0u;
  uint32_t index_size = 0u;
  bool render_targets_known = false;
  bool primitive_topology_known = false;
  bool blend_constant_known = false;
  bool sample_mask_known = false;
  bool front_stencil_reference_value_known = false;
  bool back_stencil_reference_value_known = false;
  bool viewports_known = false;
  bool scissor_rects_known = false;
  bool graphics_descriptor_tables_known = false;
  bool compute_descriptor_tables_known = false;
  bool ray_tracing_descriptor_tables_known = false;
  bool index_buffer_known = false;
  cross_addon::unordered_map<reshade::api::dynamic_state, uint32_t> dynamic_states;
  cross_addon::vector<reshade::api::dynamic_state> dynamic_state_order;
  reshade::api::device_api device_api = static_cast<reshade::api::device_api>(UINT32_MAX);
  reshade::api::pipeline_layout graphics_root_pipeline_layout = {0};
  reshade::api::pipeline_layout compute_root_pipeline_layout = {0};
#if RESHADE_API_VERSION >= 20
  cross_addon::vector<cross_addon::vector<uint32_t>> graphics_descriptor_table_dynamic_offsets;
  cross_addon::vector<cross_addon::vector<uint32_t>> compute_descriptor_table_dynamic_offsets;
  cross_addon::vector<cross_addon::vector<uint32_t>> ray_tracing_descriptor_table_dynamic_offsets;
#endif
  // Zero or one block: process-allocator ownership and independent snapshot copies.
  cross_addon::vector<D3D10And11DescriptorState> native_descriptors;
  FlaggedArray<reshade::api::viewport, D3D12_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE> fixed_viewports;
  FlaggedArray<reshade::api::rect, D3D12_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE> fixed_scissor_rects;
  cross_addon::vector<ResourceViewBind> resolved_resource_view_binds_scratch;
  uint32_t render_pass_depth = 0u;
  // Copyable canonical bind history for snapshots and compatibility consumers.
  cross_addon::vector<PipelineBind> pipeline_binds;
  // Retained for the UUID-backed layout.
  std::array<reshade::api::pipeline, 3u> bound_shader_pipelines = {};
  struct LayoutDataCacheEntry {
    reshade::api::pipeline_layout layout = {0u};
    // Borrowed node; valid only while the layout remains alive.
    const pipeline_layout::PipelineLayoutData* data = nullptr;
  };
  // Graphics, compute, ray tracing. D3D12 ray tracing uses the compute entry;
  // OpenGL uses the graphics entry for its global layout.
  std::array<LayoutDataCacheEntry, 3u> layout_data_by_domain = {};
  std::span<FlaggedArray<D3D12RootDescriptor, D3D12_ROOT_PARAMETER_COUNT>> root_descriptor_banks;

  [[nodiscard]] bool UsesFixedRasterLists() const {
    return device_api == reshade::api::device_api::d3d10
           || device_api == reshade::api::device_api::d3d11
           || device_api == reshade::api::device_api::d3d12;
  }

  void ApplyNativeDescriptors(
      reshade::api::command_list* cmd_list,
      reshade::api::shader_stage shader_stage) const {
    assert(native_descriptors.size() <= 1u);
    const auto index = GetSingleTrackedShaderStageIndex(shader_stage);
    if (native_descriptors.empty()
        || index >= D3D10And11DescriptorState::SHADER_STAGES.size()) return;
    const auto& state = native_descriptors[0];
    const auto& stage = state.stages[index];
    stage.samplers.Apply(cmd_list, shader_stage, stage.layout, D3D10And11DescriptorState::SAMPLER_LAYOUT_PARAM, reshade::api::descriptor_type::sampler);
    stage.srvs.Apply(cmd_list, shader_stage, stage.layout, D3D10And11DescriptorState::SHADER_RESOURCE_VIEW_LAYOUT_PARAM, reshade::api::descriptor_type::shader_resource_view);
    stage.cbvs.Apply(cmd_list, shader_stage, stage.layout, D3D10And11DescriptorState::CONSTANT_BUFFER_LAYOUT_PARAM, reshade::api::descriptor_type::constant_buffer);
    if (shader_stage == reshade::api::shader_stage::pixel) {
      state.graphics_uavs.Apply(cmd_list, shader_stage, stage.layout, D3D10And11DescriptorState::UNORDERED_ACCESS_VIEW_LAYOUT_PARAM, reshade::api::descriptor_type::unordered_access_view);
    } else if (shader_stage == reshade::api::shader_stage::compute) {
      state.compute_uavs.Apply(cmd_list, shader_stage, stage.layout, D3D10And11DescriptorState::UNORDERED_ACCESS_VIEW_LAYOUT_PARAM, reshade::api::descriptor_type::unordered_access_view);
    }
  }

  template <typename F>
  void ForEachPipelineBind(PipelineBindPoint bind_point, F&& callback) const {
    for (const auto& bind : pipeline_binds) {
      if (bind_point != PipelineBindPoint::UNKNOWN
          && bind.bind_point != PipelineBindPoint::UNKNOWN
          && bind.bind_point != bind_point) {
        continue;
      }
      callback(bind);
    }
  }

  void ApplyPipelines(
      reshade::api::command_list* cmd_list,
      PipelineBindPoint bind_point = PipelineBindPoint::UNKNOWN) const {
    if (cmd_list == nullptr) return;
    ForEachPipelineBind(bind_point, [&](const auto& bind) {
      cmd_list->bind_pipeline(bind.stages, bind.pipeline);
    });
  }

  void ApplyDynamicStates(
      reshade::api::command_list* cmd_list,
      PipelineBindPoint bind_point) const {
    if (device_api == reshade::api::device_api::d3d12
        && bind_point != PipelineBindPoint::GRAPHICS) return;

    cross_addon::vector<reshade::api::dynamic_state> states;
    cross_addon::vector<uint32_t> values;
    states.reserve(dynamic_states.size());
    values.reserve(dynamic_states.size());

    const auto append = [&](reshade::api::dynamic_state state) {
      const auto found = dynamic_states.find(state);
      if (found == dynamic_states.end()) return;
      states.push_back(state);
      values.push_back(found->second);
    };
    if (device_api == reshade::api::device_api::d3d12) {
      append(reshade::api::dynamic_state::primitive_topology);
      append(reshade::api::dynamic_state::blend_constant);
      const bool has_front_stencil = dynamic_states.contains(
          reshade::api::dynamic_state::front_stencil_reference_value);
      const bool has_back_stencil = dynamic_states.contains(
          reshade::api::dynamic_state::back_stencil_reference_value);
      if (has_front_stencil) {
        append(reshade::api::dynamic_state::front_stencil_reference_value);
        if (has_back_stencil) {
          append(reshade::api::dynamic_state::back_stencil_reference_value);
        }
      }
      const bool has_depth_bias = dynamic_states.contains(
          reshade::api::dynamic_state::depth_bias);
      const bool has_depth_bias_clamp = dynamic_states.contains(
          reshade::api::dynamic_state::depth_bias_clamp);
      const bool has_depth_bias_slope = dynamic_states.contains(
          reshade::api::dynamic_state::depth_bias_slope_scaled);
      if (has_depth_bias && has_depth_bias_clamp && has_depth_bias_slope) {
        append(reshade::api::dynamic_state::depth_bias);
        append(reshade::api::dynamic_state::depth_bias_clamp);
        append(reshade::api::dynamic_state::depth_bias_slope_scaled);
      }
    } else {
      if (bind_point == PipelineBindPoint::GRAPHICS) {
        append(reshade::api::dynamic_state::front_stencil_reference_value);
        append(reshade::api::dynamic_state::back_stencil_reference_value);
        append(reshade::api::dynamic_state::depth_bias);
        append(reshade::api::dynamic_state::depth_bias_clamp);
        append(reshade::api::dynamic_state::depth_bias_slope_scaled);
      } else if (bind_point == PipelineBindPoint::RAY_TRACING) {
        append(reshade::api::dynamic_state::ray_tracing_pipeline_stack_size);
      }

      for (const auto state : dynamic_state_order) {
        if (state == reshade::api::dynamic_state::front_stencil_reference_value
            || state == reshade::api::dynamic_state::back_stencil_reference_value
            || state == reshade::api::dynamic_state::depth_bias
            || state == reshade::api::dynamic_state::depth_bias_clamp
            || state == reshade::api::dynamic_state::depth_bias_slope_scaled
            || state == reshade::api::dynamic_state::ray_tracing_pipeline_stack_size) {
          continue;
        }
        if (bind_point == PipelineBindPoint::GRAPHICS) {
          append(state);
        }
      }
    }
    if (!states.empty()) {
      cmd_list->bind_pipeline_states(
          static_cast<uint32_t>(states.size()),
          states.data(),
          values.data());
    }
  }

  ShaderStagePushState* GetShaderStagePushState(reshade::api::shader_stage stage) {
    if (GetSingleTrackedShaderStageIndex(stage) >= TRACKED_SHADER_STAGE_COUNT) return nullptr;
    for (auto& push_state : shader_stage_push_states) {
      if (renodx::utils::bitwise::HasFlag(push_state.stage, stage)) return &push_state;
    }
    return nullptr;
  }

  const ShaderStagePushState* GetShaderStagePushState(reshade::api::shader_stage stage) const {
    if (GetSingleTrackedShaderStageIndex(stage) >= TRACKED_SHADER_STAGE_COUNT) return nullptr;
    for (const auto& push_state : shader_stage_push_states) {
      if (renodx::utils::bitwise::HasFlag(push_state.stage, stage)) return &push_state;
    }
    return nullptr;
  }

  reshade::api::resource_view GetPushedResourceView(reshade::api::shader_stage stage,
                                                    uint32_t layout_param,
                                                    reshade::api::descriptor_type type,
                                                    uint32_t binding) const {
    if (device_api == reshade::api::device_api::d3d11) {
      if ((type == reshade::api::descriptor_type::shader_resource_view
           && layout_param == D3D10And11DescriptorState::SHADER_RESOURCE_VIEW_LAYOUT_PARAM)
          || (type == reshade::api::descriptor_type::unordered_access_view
              && layout_param == D3D10And11DescriptorState::UNORDERED_ACCESS_VIEW_LAYOUT_PARAM)) {
        return GetBoundResourceView(stage, type, binding);
      }
      return {0};
    }
    const auto* push_state = GetShaderStagePushState(stage);
    if (device_api == reshade::api::device_api::d3d12) {
      if (GetSingleTrackedShaderStageIndex(stage) >= TRACKED_SHADER_STAGE_COUNT) return {0};
      const size_t domain = (bitwise::HasAnyFlag(stage, reshade::api::shader_stage::all_graphics) ? GRAPHICS_ROOT_DOMAIN : COMPUTE_ROOT_DOMAIN);
      const auto& roots = root_descriptor_banks[domain];
      if (roots.has(layout_param)) {
        const auto& descriptor = roots.get(layout_param);
        if (binding == 0u && descriptor.type == type && IsResourceViewDescriptorType(type)) return descriptor.view;
        return {0u};
      }
      if (push_state == nullptr) return {0};
      if (layout_param >= push_state->descriptor_count || !IsResourceViewDescriptorType(type)) return {0};
      const auto& descriptor = push_state->descriptors[layout_param];
      if (descriptor.type != type || descriptor.array_offset != 0u
          || binding < descriptor.binding || binding - descriptor.binding >= descriptor.count) return {0};
      if (type == reshade::api::descriptor_type::sampler_with_resource_view) {
        return static_cast<const reshade::api::sampler_with_resource_view*>(descriptor.descriptor_data.Data())[binding - descriptor.binding].view;
      }
      return static_cast<const reshade::api::resource_view*>(descriptor.descriptor_data.Data())[binding - descriptor.binding];
    }
    if (push_state == nullptr) return {0};
    for (size_t i = 0; i < push_state->descriptor_slot_count; ++i) {
      const auto& slots = push_state->descriptor_slots[i];
      if (slots.layout_param == layout_param && slots.type == type) {
        return slots.GetResourceView(binding);
      }
    }
    return {0};
  }

  reshade::api::resource_view GetBoundResourceView(reshade::api::shader_stage stage,
                                                   reshade::api::descriptor_type type,
                                                   uint32_t slot,
                                                   uint32_t space = 0u) const {
    if (device_api == reshade::api::device_api::d3d11) {
      const auto index = GetSingleTrackedShaderStageIndex(stage);
      if (space != 0u
          || index >= D3D10And11DescriptorState::SHADER_STAGES.size()
          || native_descriptors.empty()) return {0};
      const auto& state = native_descriptors[0];
      if (type == reshade::api::descriptor_type::shader_resource_view) {
        const auto& slots = state.stages[index].srvs;
        if (slots.slots.has(slot)) return slots.slots.get(slot);
      } else if (type == reshade::api::descriptor_type::unordered_access_view) {
        if (stage == reshade::api::shader_stage::pixel) {
          if (state.graphics_uavs.slots.has(slot)) return state.graphics_uavs.slots.get(slot);
        } else if (stage == reshade::api::shader_stage::compute) {
          if (state.compute_uavs.slots.has(slot)) return state.compute_uavs.slots.get(slot);
        }
      }
      return {0};
    }
    const auto* push_state = GetShaderStagePushState(stage);
    if (device_api == reshade::api::device_api::d3d12) {
      if (GetSingleTrackedShaderStageIndex(stage) >= TRACKED_SHADER_STAGE_COUNT) return {0};
      const size_t domain = (bitwise::HasAnyFlag(stage, reshade::api::shader_stage::all_graphics) ? GRAPHICS_ROOT_DOMAIN : COMPUTE_ROOT_DOMAIN);
      reshade::api::resource_view result = {};
      pipeline_layout::GetPipelineLayoutData(domain == GRAPHICS_ROOT_DOMAIN ? graphics_root_pipeline_layout : compute_root_pipeline_layout, [&](const auto* layout_data) {
        const auto resolve = [&](uint32_t parameter, const reshade::api::descriptor_table_update& update) {
          if (parameter >= layout_data->params.size()
              || !IsResourceViewDescriptorType(update.type)
              || GetResourceViewBindingType(update.type) != GetResourceViewBindingType(type)) return false;
          for (uint32_t index = 0u; index < update.count; ++index) {
            const auto location = pipeline_layout::FindDescriptorLocation(
                layout_data->params[parameter], reshade::api::device_api::d3d12, update, index);
            if (location && location->register_slot == slot && location->register_space == space) {
              result = (update.type == reshade::api::descriptor_type::sampler_with_resource_view
                            ? static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index].view
                            : static_cast<const reshade::api::resource_view*>(update.descriptors)[index]);
              return true;
            }
          }
          return false;
        };
        for (const auto& [parameter, descriptor] : root_descriptor_banks[domain].entries()) {
          if (resolve(static_cast<uint32_t>(parameter),
                      {.count = 1u, .type = descriptor.type, .descriptors = &descriptor.view})) return;
        }
        if (push_state == nullptr) return;
        for (size_t index = 0u; index < push_state->descriptor_count; ++index) {
          const auto& descriptor = push_state->descriptors[index];
          if (descriptor.count == 0u) continue;
          if (resolve(descriptor.layout_param,
                      {.binding = descriptor.binding, .array_offset = descriptor.array_offset, .count = descriptor.count, .type = descriptor.type, .descriptors = descriptor.descriptor_data.Data()})) return;
        }
      });
      return result;
    }
    return push_state != nullptr ? push_state->GetResourceViewBind(type, slot, space) : reshade::api::resource_view{0};
  }

  void ClearPushStates(reshade::api::shader_stage stages) {
    for (auto& push_state : shader_stage_push_states) {
      if (renodx::utils::bitwise::HasAnyFlag(stages, push_state.stage)) {
        push_state.Clear();
        if (!root_constants.empty()) {
          root_constants[&push_state - shader_stage_push_states.data()].Clear();
        }
      }
    }
  }

  template <reshade::api::device_api Api, typename Tables>
  static void ApplyDescriptorTables(
      reshade::api::command_list* cmd_list,
      reshade::api::shader_stage stages,
      reshade::api::pipeline_layout layout,
      const Tables& tables,
#if RESHADE_API_VERSION >= 20
      const cross_addon::vector<cross_addon::vector<uint32_t>>& dynamic_offsets,
#endif
      bool known) {
    if (!known || layout.handle == 0u) return;
    if (tables.isEmpty()) {
#if RESHADE_API_VERSION >= 20
      cmd_list->bind_descriptor_tables2(stages, layout, 0u, 0u, nullptr, 0u, nullptr);
#else
      cmd_list->bind_descriptor_tables(stages, layout, 0u, 0u, nullptr);
#endif
      return;
    }

    if constexpr (Api == reshade::api::device_api::d3d12) {
      for (auto&& [index, table] : tables.entries()) {
#if RESHADE_API_VERSION >= 20
        const auto* offsets = (index < dynamic_offsets.size() ? &dynamic_offsets[index] : nullptr);
        cmd_list->bind_descriptor_tables2(stages, layout, static_cast<uint32_t>(index), 1u, &table,
                                          offsets == nullptr ? 0u : static_cast<uint32_t>(offsets->size()),
                                          offsets == nullptr || offsets->empty() ? nullptr : offsets->data());
#else
        cmd_list->bind_descriptor_tables(stages, layout, static_cast<uint32_t>(index), 1u, &table);
#endif
      }
      return;
    }

    const reshade::api::descriptor_table* first_table = nullptr;
    size_t first = 0u;
    uint32_t count = 0u;
    const auto flush = [&]() {
      if (count == 0u) return;
#if RESHADE_API_VERSION >= 20
      cmd_list->bind_descriptor_tables2(stages, layout, static_cast<uint32_t>(first), count,
                                        first_table, 0u, nullptr);
#else
      cmd_list->bind_descriptor_tables(stages, layout, static_cast<uint32_t>(first), count,
                                       first_table);
#endif
      count = 0u;
    };
    for (auto&& [index, table] : tables.entries()) {
#if RESHADE_API_VERSION >= 20
      if (index < dynamic_offsets.size() && !dynamic_offsets[index].empty()) {
        flush();
        const auto& offsets = dynamic_offsets[index];
        cmd_list->bind_descriptor_tables2(stages, layout, static_cast<uint32_t>(index), 1u,
                                          &table, static_cast<uint32_t>(offsets.size()), offsets.data());
        continue;
      }
#endif
      if (count != 0u && (index != first + count || count == DESCRIPTOR_TABLE_REPLAY_BATCH_SIZE || &table != first_table + count)) {
        flush();
      }
      if (count == 0u) {
        first = index;
        first_table = &table;
      }
      ++count;
    }
    flush();
  }

  static void ApplyPushState(
      reshade::api::command_list* cmd_list,
      const ShaderStagePushState& push_state,
      bool replay_descriptor_slots = false) {
    push_state.AssertInvariants();
    if (push_state.layout.handle == 0u) return;

    if (push_state.root_descriptors != nullptr) {
      for (const auto& [index, descriptor] : push_state.root_descriptors->entries()) {
        ReplayPushDescriptors(cmd_list, push_state.stage, push_state.layout, static_cast<uint32_t>(index),
                              {.count = 1u,
                               .type = descriptor.type,
                               .descriptors = (descriptor.type == reshade::api::descriptor_type::constant_buffer
                                                   ? static_cast<const void*>(&descriptor.buffer)
                                                   : static_cast<const void*>(&descriptor.view))});
      }
    }

    for (const auto& bank : push_state.descriptor_banks) {
      if (push_state.has_unresolved_descriptors) break;
      for (size_t first = bank.Next(0u); first < bank.count;) {
        size_t end = first + 1u;
        while (end < bank.count && bank.Next(end) == end) ++end;
        ReplayPushDescriptors(
            cmd_list, push_state.stage, push_state.layout, bank.layout_param,
            {.binding = bank.binding,
             .array_offset = static_cast<uint32_t>(first),
             .count = static_cast<uint32_t>(end - first),
             .type = bank.type,
             .descriptors = bank.payload.Data(first)});
        first = bank.Next(end);
      }
    }

    if (replay_descriptor_slots) {
      for (size_t index = 0u; index < push_state.descriptor_slot_count; ++index) {
        const auto& slots = push_state.descriptor_slots[index];
        size_t first = 0u;
        while (first < slots.known_slots.size()) {
          while (first < slots.known_slots.size() && slots.known_slots[first] == 0u) ++first;
          if (first == slots.known_slots.size()) break;
          size_t end = first + 1u;
          while (end < slots.known_slots.size() && slots.known_slots[end] != 0u) ++end;
          cmd_list->push_descriptors(
              push_state.stage, push_state.layout, slots.layout_param,
              {.binding = static_cast<uint32_t>(first),
               .count = static_cast<uint32_t>(end - first),
               .type = slots.type,
               .descriptors = slots.descriptor_data.Data(first)});
          first = end;
        }
      }
    }
    for (size_t index = 0u; index < push_state.descriptor_count; ++index) {
      const auto& descriptor = push_state.descriptors[index];
      if (descriptor.count == 0u) continue;
      ReplayPushDescriptors(
          cmd_list,
          push_state.stage,
          push_state.layout,
          descriptor.layout_param,
          {
              .table = {},
              .binding = descriptor.binding,
              .array_offset = descriptor.array_offset,
              .count = descriptor.count,
              .type = descriptor.type,
              .descriptors = descriptor.descriptor_data.Data(),
          });
    }
    for (size_t index = 0u; index < push_state.constant_count; ++index) {
      const auto& constants = push_state.constants[index];
      for (const auto [first, values] : constants.values.ranges()) {
        cmd_list->push_constants(
            push_state.stage,
            push_state.layout,
            constants.layout_param,
            static_cast<uint32_t>(first),
            static_cast<uint32_t>(values.size()),
            values.data());
      }
    }
  }

  template <reshade::api::device_api Api, typename Tables>
  void ApplyGraphics(
      reshade::api::command_list* cmd_list,
      const Tables& graphics_descriptor_tables,
      bool apply_pipelines = true) const {
    if (cmd_list == nullptr) return;

    if (render_targets_known) {
      // Destroyed RTVs are not removed
      std::conditional_t<Api == reshade::api::device_api::d3d12,
                         std::array<reshade::api::resource_view, D3D12_SIMULTANEOUS_RENDER_TARGET_COUNT>,
                         std::vector<reshade::api::resource_view>>
          new_rtvs;
      if constexpr (Api != reshade::api::device_api::d3d12) {
        new_rtvs.resize(render_targets.size());
      }
      std::copy(render_targets.begin(), render_targets.end(), new_rtvs.begin());
      size_t len = render_targets.size();
      for (size_t i = 0; i < len; ++i) {
        const auto& rtv = render_targets[i];
        if (!renodx::utils::resource::IsKnownResourceView(rtv)) {
          new_rtvs[i] = {0};
        }
      }
      auto new_dsv = depth_stencil;
      if (new_dsv.handle != 0u
          && !renodx::utils::resource::IsKnownResourceView(new_dsv)) {
        new_dsv = {0u};
      }
      cmd_list->bind_render_targets_and_depth_stencil(
          static_cast<uint32_t>(render_targets.size()),
          new_rtvs.data(),
          new_dsv);
    }

    if (apply_pipelines) {
      ApplyPipelines(cmd_list, PipelineBindPoint::GRAPHICS);
    }
    ApplyDynamicStates(cmd_list, PipelineBindPoint::GRAPHICS);

    if (UsesFixedRasterLists()) {
#ifndef NDEBUG
      const auto assert_prefix = [](const auto& slots) {
        size_t expected = 0u;
        for (auto index : slots.indexes()) {
          assert(index == expected);
          ++expected;
        }
      };
      if (viewports_known) {
        assert_prefix(fixed_viewports);
      }
      if (scissor_rects_known) {
        assert_prefix(fixed_scissor_rects);
      }
#endif
      if (viewports_known) {
        cmd_list->bind_viewports(0u, static_cast<uint32_t>(fixed_viewports.flags().count()),
                                 fixed_viewports.isEmpty() ? nullptr : &fixed_viewports.get(0u));
      }
      if (scissor_rects_known) {
        cmd_list->bind_scissor_rects(0u, static_cast<uint32_t>(fixed_scissor_rects.flags().count()),
                                     fixed_scissor_rects.isEmpty() ? nullptr : &fixed_scissor_rects.get(0u));
      }
    }
    if (!UsesFixedRasterLists() && viewports_known) {
      if (known_viewport_slots.empty()) {
        cmd_list->bind_viewports(0u, 0u, nullptr);
      }
      size_t first = 0u;
      while (first < known_viewport_slots.size()) {
        while (first < known_viewport_slots.size() && known_viewport_slots[first] == 0u) ++first;
        if (first >= known_viewport_slots.size()) break;
        size_t end = first + 1u;
        while (end < known_viewport_slots.size() && known_viewport_slots[end] != 0u) ++end;
        cmd_list->bind_viewports(
            static_cast<uint32_t>(first),
            static_cast<uint32_t>(end - first),
            viewports.data() + first);
        first = end;
      }
    }
    if (!UsesFixedRasterLists() && scissor_rects_known) {
      if (known_scissor_rect_slots.empty()) {
        cmd_list->bind_scissor_rects(0u, 0u, nullptr);
      }
      size_t first = 0u;
      while (first < known_scissor_rect_slots.size()) {
        while (first < known_scissor_rect_slots.size() && known_scissor_rect_slots[first] == 0u) ++first;
        if (first >= known_scissor_rect_slots.size()) break;
        size_t end = first + 1u;
        while (end < known_scissor_rect_slots.size() && known_scissor_rect_slots[end] != 0u) ++end;
        cmd_list->bind_scissor_rects(
            static_cast<uint32_t>(first),
            static_cast<uint32_t>(end - first),
            scissor_rects.data() + first);
        first = end;
      }
    }

    size_t first_vertex_buffer = 0u;
    while (first_vertex_buffer < known_vertex_buffer_slots.size()) {
      while (first_vertex_buffer < known_vertex_buffer_slots.size()
             && known_vertex_buffer_slots[first_vertex_buffer] == 0u) {
        ++first_vertex_buffer;
      }
      if (first_vertex_buffer >= known_vertex_buffer_slots.size()) break;

      const bool unbind_d3d12 = device_api == reshade::api::device_api::d3d12
                                && vertex_buffers[first_vertex_buffer].handle == 0u;
      size_t end_vertex_buffer = first_vertex_buffer + 1u;
      while (end_vertex_buffer < known_vertex_buffer_slots.size()
             && known_vertex_buffer_slots[end_vertex_buffer] != 0u
             && (device_api != reshade::api::device_api::d3d12
                 || (vertex_buffers[end_vertex_buffer].handle == 0u) == unbind_d3d12)) {
        ++end_vertex_buffer;
      }
      if (unbind_d3d12) {
        // ReShade's D3D12 bind_vertex_buffers dereferences null resources for
        // GetDesc. Restore explicit unbindings through the native API instead.
        auto* native_cmd_list = reinterpret_cast<ID3D12GraphicsCommandList*>(
            static_cast<uintptr_t>(cmd_list->get_native()));
        const auto first_slot = static_cast<UINT>(first_vertex_buffer);
        const auto slot_count = static_cast<UINT>(end_vertex_buffer - first_vertex_buffer);
        native_cmd_list->IASetVertexBuffers(first_slot, slot_count, nullptr);
        first_vertex_buffer = end_vertex_buffer;
        continue;
      }
      cmd_list->bind_vertex_buffers(
          static_cast<uint32_t>(first_vertex_buffer),
          static_cast<uint32_t>(end_vertex_buffer - first_vertex_buffer),
          vertex_buffers.data() + first_vertex_buffer,
          vertex_buffer_offsets.data() + first_vertex_buffer,
          vertex_buffer_strides.data() + first_vertex_buffer);
      first_vertex_buffer = end_vertex_buffer;
    }
    if (index_buffer_known) {
      cmd_list->bind_index_buffer(index_buffer, index_buffer_offset, index_size);
    }

    if (device_api == reshade::api::device_api::d3d10
        || device_api == reshade::api::device_api::d3d11) {
      for (const auto stage : D3D10And11DescriptorState::SHADER_STAGES) {
        if (stage == reshade::api::shader_stage::compute) break;
        ApplyNativeDescriptors(cmd_list, stage);
      }
      return;
    }

    ApplyDescriptorTables<Api>(
        cmd_list,
        reshade::api::shader_stage::all_graphics,
        graphics_pipeline_layout,
        graphics_descriptor_tables,
#if RESHADE_API_VERSION >= 20
        graphics_descriptor_table_dynamic_offsets,
#endif
        graphics_descriptor_tables_known);

    if constexpr (Api == reshade::api::device_api::d3d12) {
      root_constants[GRAPHICS_ROOT_DOMAIN].Apply(cmd_list, reshade::api::shader_stage::all_graphics, graphics_root_pipeline_layout);
    }
    for (const auto& push_state : shader_stage_push_states) {
      if (renodx::utils::bitwise::HasAnyFlag(
              reshade::api::shader_stage::all_graphics,
              push_state.stage)) {
        ApplyPushState(cmd_list, push_state);
      }
    }
  }

  template <reshade::api::device_api Api, typename Tables>
  void ApplyCompute(
      reshade::api::command_list* cmd_list,
      const Tables& compute_descriptor_tables,
      bool apply_pipelines = true) const {
    if (cmd_list == nullptr) return;

    if (apply_pipelines) {
      ApplyPipelines(cmd_list, PipelineBindPoint::COMPUTE);
    }

    if (device_api == reshade::api::device_api::d3d10
        || device_api == reshade::api::device_api::d3d11) {
      ApplyNativeDescriptors(cmd_list, reshade::api::shader_stage::compute);
      return;
    }

    ApplyDescriptorTables<Api>(
        cmd_list,
        reshade::api::shader_stage::all_compute,
        compute_pipeline_layout,
        compute_descriptor_tables,
#if RESHADE_API_VERSION >= 20
        compute_descriptor_table_dynamic_offsets,
#endif
        compute_descriptor_tables_known);
    if constexpr (Api == reshade::api::device_api::d3d12) {
      root_constants[COMPUTE_ROOT_DOMAIN].Apply(cmd_list, reshade::api::shader_stage::all_compute | reshade::api::shader_stage::all_ray_tracing,
                                                compute_root_pipeline_layout);
    }
    if (const auto* push_state = GetShaderStagePushState(reshade::api::shader_stage::compute)) {
      ApplyPushState(cmd_list, *push_state);
    }
  }

  template <reshade::api::device_api Api, typename Tables>
  void ApplyRayTracing(
      reshade::api::command_list* cmd_list,
      const Tables& compute_descriptor_tables,
      const Tables& ray_tracing_descriptor_tables,
      bool apply_pipelines = true) const {
    if (cmd_list == nullptr) return;
    if (device_api == reshade::api::device_api::d3d11) return;

    if (apply_pipelines) {
      ApplyPipelines(cmd_list, PipelineBindPoint::RAY_TRACING);
    }
    ApplyDynamicStates(cmd_list, PipelineBindPoint::RAY_TRACING);

    if constexpr (Api == reshade::api::device_api::d3d12) {
      ApplyCompute<Api>(cmd_list, compute_descriptor_tables, false);
      return;
    }

    ApplyDescriptorTables<Api>(
        cmd_list,
        reshade::api::shader_stage::all_ray_tracing,
        ray_tracing_pipeline_layout,
        ray_tracing_descriptor_tables,
#if RESHADE_API_VERSION >= 20
        ray_tracing_descriptor_table_dynamic_offsets,
#endif
        ray_tracing_descriptor_tables_known);
    for (const auto& push_state : shader_stage_push_states) {
      if (renodx::utils::bitwise::HasAnyFlag(
              reshade::api::shader_stage::all_ray_tracing,
              push_state.stage)) {
        ApplyPushState(cmd_list, push_state);
      }
    }
  }

  template <bool RecordedD3D12Only = false>
  void Clear() {
    render_targets = {};
    fixed_viewports.clear();
    fixed_scissor_rects.clear();
    if constexpr (!RecordedD3D12Only) {
      if (!native_descriptors.empty()) {
        for (auto& stage : native_descriptors[0].stages) {
          stage.samplers.slots.clear();
          stage.srvs.slots.clear();
          stage.cbvs.slots.clear();
        }
        native_descriptors[0].graphics_uavs.slots.clear();
        native_descriptors[0].compute_uavs.slots.clear();
      }
      viewports.clear();
      known_viewport_slots.clear();
      scissor_rects.clear();
      known_scissor_rect_slots.clear();
      vertex_buffers.clear();
      vertex_buffer_offsets.clear();
      vertex_buffer_strides.clear();
      known_vertex_buffer_slots.clear();
      dynamic_states.clear();
      dynamic_state_order.clear();
      for (auto& constants : root_constants) {
        constants.Clear();
      }
    }
    depth_stencil = {0};
    pipeline_binds.clear();
    primitive_topology = reshade::api::primitive_topology::undefined;
    blend_constant = 0;
    sample_mask = 0xFFFFFFFF;
    front_stencil_reference_value = 0;
    back_stencil_reference_value = 0;
    graphics_pipeline_layout = {0};
#if RESHADE_API_VERSION >= 20
    graphics_descriptor_table_dynamic_offsets.clear();
#endif
    compute_pipeline_layout = {0};
#if RESHADE_API_VERSION >= 20
    compute_descriptor_table_dynamic_offsets.clear();
#endif
    ray_tracing_pipeline_layout = {0};
#if RESHADE_API_VERSION >= 20
    ray_tracing_descriptor_table_dynamic_offsets.clear();
#endif
    index_buffer = {0};
    index_buffer_offset = 0u;
    index_size = 0u;
    render_targets_known = false;
    primitive_topology_known = false;
    blend_constant_known = false;
    sample_mask_known = false;
    front_stencil_reference_value_known = false;
    back_stencil_reference_value_known = false;
    viewports_known = false;
    scissor_rects_known = false;
    graphics_descriptor_tables_known = false;
    compute_descriptor_tables_known = false;
    ray_tracing_descriptor_tables_known = false;
    index_buffer_known = false;
    graphics_root_pipeline_layout = {0};
    compute_root_pipeline_layout = {0};
    for (auto& push_state : shader_stage_push_states) {
      push_state.Clear();
    }
    layout_data_by_domain = {};
    resolved_resource_view_binds_scratch.clear();
    render_pass_depth = 0u;
  }

 protected:
  // Only the typed owner may copy this view and rebind its borrowed storage.
  CommandListSnapshotData() = default;
  CommandListSnapshotData(const CommandListSnapshotData&) = default;
  CommandListSnapshotData(CommandListSnapshotData&&) = default;
  CommandListSnapshotData& operator=(const CommandListSnapshotData&) = default;
  CommandListSnapshotData& operator=(CommandListSnapshotData&&) = default;
};

template <reshade::api::device_api Api, bool OwnsReplayStorage = true>
struct BackendSnapshotData : CommandListSnapshotData {
  std::conditional_t<Api == reshade::api::device_api::d3d12,
                     std::array<reshade::api::resource_view, D3D12_SIMULTANEOUS_RENDER_TARGET_COUNT>,
                     cross_addon::vector<reshade::api::resource_view>>
      render_target_storage = {};

  void ResizeRenderTargets(size_t count) {
    if constexpr (Api == reshade::api::device_api::d3d12) {
      assert(count <= render_target_storage.size());
    } else {
      render_target_storage.resize(count);
    }
    render_targets = {render_target_storage.data(), count};
  }
  // D3D12 graphics stages share one PSO; compute has its own cached node.
  // Borrowed nodes remain valid only while their pipelines remain alive.
  mutable std::array<const pipeline::PipelineInfo*,
                     Api == reshade::api::device_api::d3d12 ? D3D12_ROOT_STAGES.size() : pipeline::SHADER_STAGES.size()>
      bound_pipeline_infos = {};
  // A root signature has a 64-DWORD budget; each table consumes one DWORD.
  using TableStorage = std::conditional_t<Api == reshade::api::device_api::d3d12,
                                          FlaggedArray<reshade::api::descriptor_table, D3D12_ROOT_PARAMETER_COUNT>,
                                          DescriptorTableSlots>;
  TableStorage graphics_descriptor_tables;
  TableStorage compute_descriptor_tables;
  // Live D3D12 uses the compute bank; capture owns the compatibility bank.
  std::conditional_t<OwnsReplayStorage, TableStorage, std::span<TableStorage, 0u>> ray_tracing_descriptor_tables;
  std::conditional_t<OwnsReplayStorage,
                     std::array<D3D12RootConstants, Api == reshade::api::device_api::d3d12 ? D3D12_ROOT_STAGES.size() : 0u>,
                     std::span<D3D12RootConstants, 0u>>
      root_constant_storage;
  std::array<FlaggedArray<D3D12RootDescriptor, D3D12_ROOT_PARAMETER_COUNT>, Api == reshade::api::device_api::d3d12 ? D3D12_ROOT_STAGES.size() : 0u> root_descriptor_storage;

  void RebindRootDescriptors() {
    root_descriptor_banks = root_descriptor_storage;
    if constexpr (Api == reshade::api::device_api::d3d12) {
      for (size_t index = 0u; index < push_states.size(); ++index) {
        push_states[index].root_descriptors = &root_descriptor_storage[index];
      }
    }
  }

  void ApplyGraphics(reshade::api::command_list* cmd_list, bool apply_pipelines = true) const
    requires(Api != reshade::api::device_api::d3d12 || OwnsReplayStorage)
  {
    CommandListSnapshotData::ApplyGraphics<Api>(cmd_list, graphics_descriptor_tables, apply_pipelines);
  }
  void ApplyCompute(reshade::api::command_list* cmd_list, bool apply_pipelines = true) const
    requires(Api != reshade::api::device_api::d3d12 || OwnsReplayStorage)
  {
    CommandListSnapshotData::ApplyCompute<Api>(cmd_list, compute_descriptor_tables, apply_pipelines);
  }
  void ApplyRayTracing(reshade::api::command_list* cmd_list, bool apply_pipelines = true) const
    requires(Api != reshade::api::device_api::d3d12 || OwnsReplayStorage)
  {
    CommandListSnapshotData::ApplyRayTracing<Api>(cmd_list, compute_descriptor_tables, ray_tracing_descriptor_tables, apply_pipelines);
  }
  void Apply(reshade::api::command_list* cmd_list) const
    requires(Api != reshade::api::device_api::d3d12 || OwnsReplayStorage)
  {
    ApplyPipelines(cmd_list);
    ApplyGraphics(cmd_list, false);
    ApplyCompute(cmd_list, false);
    if constexpr (Api == reshade::api::device_api::d3d12) {
      ApplyDynamicStates(cmd_list, PipelineBindPoint::RAY_TRACING);
    } else {
      ApplyRayTracing(cmd_list, false);
    }
  }
  void Clear() {
    CommandListSnapshotData::Clear<Api == reshade::api::device_api::d3d12 && !OwnsReplayStorage>();
    for (auto& roots : root_descriptor_storage) {
      roots.clear();
    }
    ResizeRenderTargets(0u);
    bound_pipeline_infos = {};
    graphics_descriptor_tables.clear();
    compute_descriptor_tables.clear();
    if constexpr (OwnsReplayStorage) {
      ray_tracing_descriptor_tables.clear();
    }
  }
  static constexpr auto PUSH_STAGES = [] {
    using reshade::api::shader_stage;
    if constexpr (Api == reshade::api::device_api::d3d12) {
      return D3D12_ROOT_STAGES;
    } else if constexpr (Api == reshade::api::device_api::d3d9) {
      return std::array{shader_stage::vertex, shader_stage::pixel};
    } else if constexpr (Api == reshade::api::device_api::d3d10) {
      return std::array{shader_stage::vertex, shader_stage::geometry, shader_stage::pixel};
    } else if constexpr (Api == reshade::api::device_api::d3d11 || Api == reshade::api::device_api::opengl) {
      return D3D10And11DescriptorState::SHADER_STAGES;
    } else {
      return std::to_array(TRACKED_SHADER_STAGES);
    }
  }();
  std::conditional_t<OwnsReplayStorage, std::array<ShaderStagePushState, PUSH_STAGES.size()>,
                     cross_addon::vector<ShaderStagePushState>>
      push_states = [] {
        std::conditional_t<OwnsReplayStorage, std::array<ShaderStagePushState, PUSH_STAGES.size()>,
                           cross_addon::vector<ShaderStagePushState>>
            result{};
        for (size_t index = 0u; index < result.size(); ++index) {
          result[index].stage = PUSH_STAGES[index];
        }
        return result;
      }();

  BackendSnapshotData() {
    RebindRootDescriptors();
    device_api = Api;
    shader_stage_push_states = push_states;
    root_constants = root_constant_storage;
  }
  void ClearPushStates(reshade::api::shader_stage stages) {
    if constexpr (Api == reshade::api::device_api::d3d12) {
      if (renodx::utils::bitwise::HasAnyFlag(stages, PUSH_STAGES[GRAPHICS_ROOT_DOMAIN])) {
        root_descriptor_storage[GRAPHICS_ROOT_DOMAIN].clear();
        if (!push_states.empty()) {
          push_states[GRAPHICS_ROOT_DOMAIN].Clear();
        }
        if constexpr (OwnsReplayStorage) {
          root_constant_storage[GRAPHICS_ROOT_DOMAIN].Clear();
        }
      }
      if (renodx::utils::bitwise::HasAnyFlag(stages, PUSH_STAGES[COMPUTE_ROOT_DOMAIN])) {
        root_descriptor_storage[COMPUTE_ROOT_DOMAIN].clear();
        if (!push_states.empty()) {
          push_states[COMPUTE_ROOT_DOMAIN].Clear();
        }
        if constexpr (OwnsReplayStorage) {
          root_constant_storage[COMPUTE_ROOT_DOMAIN].Clear();
        }
      }
    } else {
      CommandListSnapshotData::ClearPushStates(stages);
    }
  }
  BackendSnapshotData(const BackendSnapshotData& other)
      : CommandListSnapshotData(other),
        render_target_storage(other.render_target_storage),
        bound_pipeline_infos(other.bound_pipeline_infos),
        graphics_descriptor_tables(other.graphics_descriptor_tables),
        compute_descriptor_tables(other.compute_descriptor_tables),
        ray_tracing_descriptor_tables(other.ray_tracing_descriptor_tables),
        root_constant_storage(other.root_constant_storage),
        root_descriptor_storage(other.root_descriptor_storage),
        push_states(other.push_states) {
    RebindRootDescriptors();
    ResizeRenderTargets(other.render_targets.size());
    shader_stage_push_states = push_states;
    root_constants = root_constant_storage;
  }
  // Capture copies common recorded state, but allocates packed constants only
  // in the replay owner. CommandListState::Capture fills those constants.
  explicit BackendSnapshotData(const BackendSnapshotData<Api, false>& other)
    requires(OwnsReplayStorage)
      : CommandListSnapshotData(other),
        render_target_storage(other.render_target_storage),
        bound_pipeline_infos(other.bound_pipeline_infos),
        graphics_descriptor_tables(other.graphics_descriptor_tables),
        compute_descriptor_tables(other.compute_descriptor_tables),
        root_descriptor_storage(other.root_descriptor_storage) {
    ray_tracing_descriptor_tables = other.compute_descriptor_tables;
    ray_tracing_pipeline_layout = other.compute_pipeline_layout;
    ray_tracing_descriptor_tables_known = other.compute_descriptor_tables_known;
    for (size_t index = 0u; index < push_states.size(); ++index) {
      if (!other.push_states.empty()) {
        push_states[index] = other.push_states[index];
      }
      push_states[index].layout = (index == GRAPHICS_ROOT_DOMAIN ? graphics_root_pipeline_layout : compute_root_pipeline_layout);
    }
    RebindRootDescriptors();
    ResizeRenderTargets(other.render_targets.size());
    shader_stage_push_states = push_states;
    root_constants = root_constant_storage;
  }
  BackendSnapshotData(BackendSnapshotData&& other) noexcept
      : CommandListSnapshotData(std::move(other)),
        render_target_storage(std::move(other.render_target_storage)),
        bound_pipeline_infos(other.bound_pipeline_infos),
        graphics_descriptor_tables(std::move(other.graphics_descriptor_tables)),
        compute_descriptor_tables(std::move(other.compute_descriptor_tables)),
        ray_tracing_descriptor_tables(std::move(other.ray_tracing_descriptor_tables)),
        root_constant_storage(std::move(other.root_constant_storage)),
        root_descriptor_storage(std::move(other.root_descriptor_storage)),
        push_states(std::move(other.push_states)) {
    RebindRootDescriptors();
    ResizeRenderTargets(other.render_targets.size());
    other.render_targets = {};
    shader_stage_push_states = push_states;
    root_constants = root_constant_storage;
  }
  BackendSnapshotData& operator=(const BackendSnapshotData& other) {
    CommandListSnapshotData::operator=(other);
    render_target_storage = other.render_target_storage;
    ResizeRenderTargets(other.render_targets.size());
    bound_pipeline_infos = other.bound_pipeline_infos;
    graphics_descriptor_tables = other.graphics_descriptor_tables;
    compute_descriptor_tables = other.compute_descriptor_tables;
    ray_tracing_descriptor_tables = other.ray_tracing_descriptor_tables;
    root_constant_storage = other.root_constant_storage;
    root_descriptor_storage = other.root_descriptor_storage;
    push_states = other.push_states;
    RebindRootDescriptors();
    shader_stage_push_states = push_states;
    root_constants = root_constant_storage;
    return *this;
  }
  BackendSnapshotData& operator=(BackendSnapshotData&& other) noexcept {
    CommandListSnapshotData::operator=(std::move(other));
    render_target_storage = std::move(other.render_target_storage);
    ResizeRenderTargets(other.render_targets.size());
    other.render_targets = {};
    bound_pipeline_infos = other.bound_pipeline_infos;
    graphics_descriptor_tables = std::move(other.graphics_descriptor_tables);
    compute_descriptor_tables = std::move(other.compute_descriptor_tables);
    ray_tracing_descriptor_tables = std::move(other.ray_tracing_descriptor_tables);
    root_constant_storage = std::move(other.root_constant_storage);
    root_descriptor_storage = std::move(other.root_descriptor_storage);
    push_states = std::move(other.push_states);
    RebindRootDescriptors();
    shader_stage_push_states = push_states;
    root_constants = root_constant_storage;
    return *this;
  }
};

// Versioned with SharedData: previous modules must not interpret the new owners.
struct __declspec(uuid("69cc992c-1de8-424c-82a6-723f25165a7b")) CommandListStateHandle {
  reshade::api::device_api api;
  void* state;
};

template <reshade::api::device_api Api>
struct CommandListState {
  CommandListStateHandle handle{.api = Api, .state = this};
  BackendSnapshotData<Api, Api != reshade::api::device_api::d3d12> snapshot;
  static constexpr size_t PIPELINE_SLOT_COUNT = [] {
    if constexpr (Api == reshade::api::device_api::d3d11 || Api == reshade::api::device_api::opengl) {
      return 10u;
    } else if constexpr (Api == reshade::api::device_api::d3d10) {
      return 7u;
    } else {
      return 3u;
    }
  }();
  FlaggedArray<PipelineBind, PIPELINE_SLOT_COUNT> bound_pipelines;
  uint64_t bind_sequence = 0u;

  static constexpr std::array D3D12_DYNAMIC_STATES = {
      reshade::api::dynamic_state::primitive_topology,
      reshade::api::dynamic_state::blend_constant,
      reshade::api::dynamic_state::front_stencil_reference_value,
      reshade::api::dynamic_state::back_stencil_reference_value,
      reshade::api::dynamic_state::depth_bias,
      reshade::api::dynamic_state::depth_bias_clamp,
      reshade::api::dynamic_state::depth_bias_slope_scaled};
  struct D3D12Recording {
    FlaggedArray<uint32_t, D3D12_DYNAMIC_STATES.size()> dynamic_states;
    struct VertexBuffer {
      reshade::api::resource buffer = {};
      uint64_t offset = 0u;
      uint32_t stride = 0u;
    };
    FlaggedArray<VertexBuffer, D3D12_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT> vertex_buffers;
    struct RootConstants {
      struct Parameter {
        uint8_t head = 0u;
        uint8_t tail = 0u;
        uint8_t count = 0u;
        uint8_t contiguous_count = 0u;
      };
      FlaggedArray<Parameter, D3D12_ROOT_PARAMETER_COUNT> parameters;
      FlaggedArray<uint32_t, D3D12_ROOT_DWORD_BUDGET> values;
      std::array<uint8_t, D3D12_ROOT_DWORD_BUDGET> next;
      uint32_t used = 0u;

      void Update(uint32_t layout_param, uint32_t first, std::span<const uint32_t> source) {
        assert(layout_param < D3D12_ROOT_PARAMETER_COUNT && first <= D3D12_ROOT_DWORD_BUDGET && source.size() <= D3D12_ROOT_DWORD_BUDGET - first);
        if (layout_param >= D3D12_ROOT_PARAMETER_COUNT || first > D3D12_ROOT_DWORD_BUDGET || source.size() > D3D12_ROOT_DWORD_BUDGET - first || source.empty()) return;
        const auto end = static_cast<uint32_t>(first + source.size());
        const uint32_t previous_count = (parameters.has(layout_param) ? parameters.get(layout_param).count : 0u);
        const uint32_t extra = (end > previous_count ? end - previous_count : 0u);
        assert(extra <= D3D12_ROOT_DWORD_BUDGET - used);
        if (extra > D3D12_ROOT_DWORD_BUDGET - used) return;
        if (previous_count == 0u) {
          parameters.set(layout_param, Parameter{.head = static_cast<uint8_t>(used)});
        }
        auto& parameter = parameters.get(layout_param);
        if (extra != 0u) {
          if (previous_count == 0u
              || (parameter.contiguous_count == previous_count && parameter.tail + 1u == used)) {
            parameter.contiguous_count = static_cast<uint8_t>(end);
          }
          if (previous_count != 0u) {
            next[parameter.tail] = static_cast<uint8_t>(used);
          }
          for (uint32_t index = used; index + 1u < used + extra; ++index) {
            next[index] = static_cast<uint8_t>(index + 1u);
          }
          used += extra;
          parameter.tail = static_cast<uint8_t>(used - 1u);
          parameter.count = static_cast<uint8_t>(end);
        }
        if (end <= parameter.contiguous_count) {
          values.setRange(parameter.head + first, source);
          return;
        }
        uint32_t slot = parameter.head;
        for (uint32_t word = 0u; word < first; ++word) {
          slot = next[slot];
        }
        for (size_t index = 0u; index < source.size(); ++index) {
          values.set(slot, source[index]);
          if (index + 1u < source.size()) {
            slot = next[slot];
          }
        }
      }

      void Clear() {
        if (used == 0u) return;
        parameters.clear();
        values.clear();
        used = 0u;
      }
    };
    std::array<RootConstants, D3D12_ROOT_STAGES.size()> root_constants;
  };
  std::array<D3D12Recording, Api == reshade::api::device_api::d3d12 ? 1u : 0u> recording;

  void PushDescriptors(reshade::api::shader_stage stages,
                       reshade::api::pipeline_layout layout,
                       uint32_t layout_param,
                       const reshade::api::descriptor_table_update& update) {
    if (update.count == 0u) return;
    const auto descriptor_size = GetDescriptorSizeOf(update.type);
    assert(update.descriptors != nullptr);
    assert(descriptor_size != 0u);
    if (update.descriptors == nullptr || descriptor_size == 0u) return;

    auto& current_state = snapshot;

    if constexpr (Api == reshade::api::device_api::d3d10
                  || Api == reshade::api::device_api::d3d11) {
      // Native getters address context-owned binding slots; they cannot recover
      // ReShade's synthetic layouts. See docs/plans/opaque-command-list-snapshot.md
      // for the decompiled paths and their interface/refcount bookkeeping.
      if (current_state.native_descriptors.empty()) {
        current_state.native_descriptors.emplace_back();
      }
      auto& descriptors = current_state.native_descriptors[0];
      const auto capture = [&](size_t index) {
        auto& stage = descriptors.stages[index];
        stage.layout = layout;
        if (shared.data != nullptr && !shared.data->use_push_descriptors) return;
        switch (update.type) {
          case reshade::api::descriptor_type::sampler:
            stage.samplers.Update(update.binding, update.count, update.descriptors);
            break;
          case reshade::api::descriptor_type::shader_resource_view:
          case reshade::api::descriptor_type::buffer_shader_resource_view:
            stage.srvs.Update(update.binding, update.count, update.descriptors);
            break;
          case reshade::api::descriptor_type::constant_buffer:
            stage.cbvs.Update(update.binding, update.count, update.descriptors);
            break;
          case reshade::api::descriptor_type::unordered_access_view:
          case reshade::api::descriptor_type::buffer_unordered_access_view:
            if (D3D10And11DescriptorState::SHADER_STAGES[index]
                == reshade::api::shader_stage::pixel) {
              descriptors.graphics_uavs.Update(update.binding, update.count, update.descriptors);
            } else if (D3D10And11DescriptorState::SHADER_STAGES[index]
                       == reshade::api::shader_stage::compute) {
              descriptors.compute_uavs.Update(update.binding, update.count, update.descriptors);
            }
            break;
          default:
            break;
        }
      };
      if (const auto index = GetSingleTrackedShaderStageIndex(stages);
          index < D3D10And11DescriptorState::SHADER_STAGES.size()) {
        capture(index);
      } else {
        for (size_t index = 0u;
             index < D3D10And11DescriptorState::SHADER_STAGES.size();
             ++index) {
          if (renodx::utils::bitwise::HasFlag(
                  stages, D3D10And11DescriptorState::SHADER_STAGES[index])) {
            capture(index);
          }
        }
      }
      return;
    }

    TransitionPipelineLayout(stages, layout);
    if constexpr (Api == reshade::api::device_api::d3d12) {
      assert(stages == reshade::api::shader_stage::all_graphics
             || stages == (reshade::api::shader_stage::all_compute | reshade::api::shader_stage::all_ray_tracing));
      if (layout.handle == 0u) return;
      if (stages != reshade::api::shader_stage::all_graphics
          && stages != (reshade::api::shader_stage::all_compute | reshade::api::shader_stage::all_ray_tracing)) return;
      if (layout_param < D3D12_ROOT_PARAMETER_COUNT && update.count == 1u && update.binding == 0u && update.array_offset == 0u
          && (update.type == reshade::api::descriptor_type::constant_buffer
              || update.type == reshade::api::descriptor_type::buffer_shader_resource_view
              || update.type == reshade::api::descriptor_type::buffer_unordered_access_view
              || update.type == reshade::api::descriptor_type::acceleration_structure)) {
        const size_t domain = (stages == reshade::api::shader_stage::all_graphics ? GRAPHICS_ROOT_DOMAIN : COMPUTE_ROOT_DOMAIN);
        D3D12RootDescriptor descriptor{.type = update.type};
        if (update.type == reshade::api::descriptor_type::constant_buffer) {
          descriptor.buffer = *static_cast<const reshade::api::buffer_range*>(update.descriptors);
        } else {
          descriptor.view = *static_cast<const reshade::api::resource_view*>(update.descriptors);
        }
        snapshot.root_descriptor_storage[domain].set(layout_param, descriptor);
        if (!snapshot.push_states.empty()) {
          auto& fallback = snapshot.push_states[domain];
          if (layout_param < fallback.descriptor_count) {
            fallback.descriptors[layout_param].count = 0u;
            fallback.descriptors[layout_param].Clear();
          }
        }
        return;
      }
    }
    std::span<ShaderStagePushState> update_states;
    if constexpr (Api == reshade::api::device_api::d3d12) {
      if (snapshot.push_states.empty()) {
        snapshot.push_states.resize(snapshot.PUSH_STAGES.size());
        for (size_t index = 0u; index < snapshot.PUSH_STAGES.size(); ++index) {
          snapshot.push_states[index].stage = snapshot.PUSH_STAGES[index];
          snapshot.push_states[index].layout = (index == GRAPHICS_ROOT_DOMAIN ? snapshot.graphics_root_pipeline_layout : snapshot.compute_root_pipeline_layout);
        }
        snapshot.RebindRootDescriptors();
        snapshot.shader_stage_push_states = snapshot.push_states;
      }
      if (stages == reshade::api::shader_stage::all_graphics) {
        update_states = {snapshot.push_states.data(), 1u};
      } else {
        update_states = {snapshot.push_states.data() + COMPUTE_ROOT_DOMAIN, 1u};
      }
    } else {
      update_states = snapshot.push_states;
    }

    const pipeline_layout::PipelineLayoutData* layout_data = nullptr;
    if (Api != reshade::api::device_api::d3d12 && layout.handle != 0u
        && (IsResourceViewDescriptorType(update.type)
            || Api == reshade::api::device_api::vulkan
            || Api == reshade::api::device_api::opengl)) {
      if constexpr (Api == reshade::api::device_api::d3d9) {
        layout_data = pipeline_layout::GetPipelineLayoutData(layout);
      } else {
        enum class LayoutDomain : uint8_t { GRAPHICS,
                                            COMPUTE,
                                            RAY_TRACING };
        auto domain = LayoutDomain::GRAPHICS;
        if constexpr (Api != reshade::api::device_api::opengl) {
          if (renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_compute)) {
            domain = LayoutDomain::COMPUTE;
          } else if (renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_ray_tracing)) {
            domain = (Api == reshade::api::device_api::d3d12
                          ? LayoutDomain::COMPUTE
                          : LayoutDomain::RAY_TRACING);
          }
        }
        auto& cached = current_state.layout_data_by_domain[static_cast<size_t>(domain)];
        if (cached.layout != layout) {
          cached.layout = layout;
          cached.data = nullptr;
        }
        if (cached.data == nullptr) {
          cached.data = pipeline_layout::GetPipelineLayoutData(layout);
        }
        layout_data = cached.data;
      }
    }

    auto& resolved_resource_view_binds = current_state.resolved_resource_view_binds_scratch;
    ResourceViewBind single_resolved_bind;
    std::span<const ResourceViewBind> resolved_binds;
    const bool use_single_binding = (Api == reshade::api::device_api::d3d12 && update.count == 1u);
    if (!use_single_binding) {
      resolved_resource_view_binds.clear();
    }
    if (IsResourceViewDescriptorType(update.type) && layout_data != nullptr
        && layout_param < layout_data->params.size()) {
      if (!use_single_binding) {
        resolved_resource_view_binds.reserve(update.count);
      }
      for (uint32_t index = 0u; index < update.count; ++index) {
        uint32_t slot = 0u;
        uint32_t space = 0u;
        bool resolved = false;
        if constexpr (Api == reshade::api::device_api::d3d9
                      || Api == reshade::api::device_api::d3d10
                      || Api == reshade::api::device_api::d3d11
                      || Api == reshade::api::device_api::d3d12) {
          const auto binding = renodx::utils::pipeline_layout::FindDescriptorLocation(
              layout_data->params[layout_param], Api, update, index);
          if (binding) {
            slot = binding->register_slot;
            space = binding->register_space;
            resolved = true;
          }
        } else {
          const auto element = renodx::utils::pipeline_layout::FindDescriptorLocation(
              layout_data->params[layout_param], Api, update, index);
          if (element) {
            slot = element->binding;
            space = element->array_offset;
            resolved = true;
          }
        }
        if (!resolved) {
          break;
        }
        const ResourceViewBind resolved_bind = {
            .type = GetResourceViewBindingType(update.type),
            .slot = slot,
            .space = space,
            .view = (update.type == reshade::api::descriptor_type::sampler_with_resource_view
                         ? static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index].view
                         : static_cast<const reshade::api::resource_view*>(update.descriptors)[index]),
        };
        if (use_single_binding) {
          single_resolved_bind = resolved_bind;
          resolved_binds = {&single_resolved_bind, 1u};
        } else {
          resolved_resource_view_binds.push_back(resolved_bind);
        }
      }
    }
    if (!use_single_binding) {
      resolved_binds = resolved_resource_view_binds;
    }

    const auto update_resource_view_bindings = [&](ShaderStagePushState* push_state) {
      for (const auto& resolved_bind : resolved_binds) {
        const auto bind_it = std::find_if(
            push_state->resource_view_binds.begin(),
            push_state->resource_view_binds.end(),
            [&](const ResourceViewBind& bind) {
              return bind.type == resolved_bind.type
                     && bind.slot == resolved_bind.slot
                     && bind.space == resolved_bind.space;
            });
        if (bind_it != push_state->resource_view_binds.end()) {
          if (resolved_bind.view.handle == 0u) {
            if (bind_it + 1 != push_state->resource_view_binds.end()) {
              *bind_it = push_state->resource_view_binds.back();
            }
            push_state->resource_view_binds.pop_back();
          } else {
            bind_it->view = resolved_bind.view;
          }
          continue;
        }

        if (resolved_bind.view.handle != 0u) {
          push_state->resource_view_binds.push_back(resolved_bind);
        }
      }
    };

    for (auto& selected_state : update_states) {
      const auto stage = selected_state.stage;
      if constexpr (Api != reshade::api::device_api::d3d12) {
        if (!renodx::utils::bitwise::HasFlag(stages, stage)) continue;
      }
      auto* push_state = &selected_state;
      push_state->SetLayout(layout);
      if constexpr (Api != reshade::api::device_api::d3d12) {
        update_resource_view_bindings(push_state);
      }
      if (layout.handle == 0u) continue;

      if constexpr (Api == reshade::api::device_api::d3d12) {
        if (layout_param < D3D12_ROOT_PARAMETER_COUNT) {
          push_state->root_descriptors->reset(layout_param);
        }
        if (push_state->descriptors.size() <= layout_param) {
          push_state->descriptors.resize(layout_param + 1u);
        }
        while (push_state->descriptor_count <= layout_param) {
          push_state->descriptors[push_state->descriptor_count++].count = 0u;
        }
        push_state->descriptors[layout_param].Store(layout_param, update);
        continue;
      }

      const auto store_descriptor_update = [&](uint32_t update_layout_param,
                                               const reshade::api::descriptor_table_update& descriptor_update) {
        const auto store = [&](const reshade::api::descriptor_table_update& element) {
          for (size_t index = 0u; index < push_state->descriptor_count; ++index) {
            auto& previous = push_state->descriptors[index];
            if (previous.layout_param == update_layout_param
                && previous.type == element.type
                && previous.binding == element.binding
                && previous.array_offset == element.array_offset
                && previous.count == element.count) {
              previous.Store(update_layout_param, element);
              // Preserve last-write ordering even for unresolved array batches.
              for (size_t next = index + 1u; next < push_state->descriptor_count; ++next) {
                std::swap(push_state->descriptors[next - 1u], push_state->descriptors[next]);
              }
              return;
            }
          }
          push_state->AddDescriptorUpdate()->Store(update_layout_param, element);
        };

        const auto descriptor_size = GetDescriptorSizeOf(descriptor_update.type);
        if constexpr (Api == reshade::api::device_api::vulkan
                      || Api == reshade::api::device_api::opengl) {
          bool resolved = false;
          if (layout_data != nullptr && update_layout_param < layout_data->params.size()) {
            const auto& param = layout_data->params[update_layout_param];
            // Validate the whole spill before changing any stored elements.
            bool can_resolve = renodx::utils::pipeline_layout::FindDescriptorLocation(
                                   param, Api, descriptor_update, descriptor_update.count - 1u)
                                   .has_value();
            if (can_resolve) {
              bool finite = !push_state->has_unresolved_descriptors
                            && std::any_of(push_state->descriptor_banks.begin(), push_state->descriptor_banks.end(),
                                           [&](const auto& bank) {
                                             return bank.layout_param == update_layout_param
                                                    && bank.type == descriptor_update.type;
                                           });
              if (!push_state->has_unresolved_descriptors && !finite) {
                const auto prepare = [&](uint32_t count, const auto* ranges) {
                  for (uint32_t i = 0; i < count; ++i) {
                    if (ranges[i].type == descriptor_update.type
                        && (ranges[i].count == UINT32_MAX
                            || ranges[i].count > std::numeric_limits<size_t>::max() / descriptor_size)) return false;
                  }
                  for (uint32_t i = 0; i < count; ++i) {
                    const auto& range = ranges[i];
                    if (range.type != descriptor_update.type || range.count == 0u) continue;
                    const auto found = std::find_if(push_state->descriptor_banks.begin(), push_state->descriptor_banks.end(),
                                                    [&](const auto& bank) {
                                                      return bank.layout_param == update_layout_param
                                                             && bank.type == range.type
                                                             && bank.binding == range.binding;
                                                    });
                    if (found != push_state->descriptor_banks.end()) continue;
                    // Publish only a fully allocated bank; failed allocation leaves no partial bank.
                    DescriptorBank bank;
                    bank.layout_param = update_layout_param;
                    bank.binding = range.binding;
                    bank.count = range.count;
                    bank.type = range.type;
                    bank.payload.Resize(bank.type, bank.count);
                    bank.present.resize(
                        (static_cast<size_t>(bank.count) / DescriptorBank::WORD_BITS)
                        + (bank.count % DescriptorBank::WORD_BITS != 0u ? 1u : 0u));
                    bank.AssertInvariants();
                    push_state->descriptor_banks.push_back(std::move(bank));
                  }
                  return true;
                };
                switch (param.type) {
                  case reshade::api::pipeline_layout_param_type::push_descriptors:
                    finite = prepare(1u, &param.push_descriptors);
                    break;
                  case reshade::api::pipeline_layout_param_type::descriptor_table:
                  case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
                    finite = prepare(param.descriptor_table.count, param.descriptor_table.ranges);
                    break;
#if RESHADE_API_VERSION >= 20
                  case reshade::api::pipeline_layout_param_type::descriptor_table_with_flags:
                  case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges_and_flags:
                    finite = prepare(param.descriptor_table_with_flags.count, param.descriptor_table_with_flags.ranges);
                    break;
#else
                  case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
                  case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
                    finite = prepare(param.descriptor_table_with_static_samplers.count, param.descriptor_table_with_static_samplers.ranges);
                    break;
#endif
                  default: break;
                }
                can_resolve = finite;
              }
              if (can_resolve) {
                const auto find_bank = [&](uint32_t resolved_binding) {
                  return std::find_if(push_state->descriptor_banks.begin(), push_state->descriptor_banks.end(),
                                      [&](const auto& candidate) {
                                        return candidate.layout_param == update_layout_param
                                               && candidate.type == descriptor_update.type
                                               && candidate.binding == resolved_binding;
                                      });
                };
                // Resolution success does not imply that the finite-bank representation can store it.
                // Validate the entire update before changing payloads. Failed resolution
                // keeps the history fallback below responsible for the original update.
                for (uint32_t index = 0u; index < descriptor_update.count; ++index) {
                  const auto element = renodx::utils::pipeline_layout::FindDescriptorLocation(
                      param, Api, descriptor_update, index);
                  if (!element) {
                    can_resolve = false;
                    break;
                  }
                  if (finite) {
                    const auto bank = find_bank(element->binding);
                    if (bank == push_state->descriptor_banks.end() || element->array_offset >= bank->count) {
                      can_resolve = false;
                      break;
                    }
                    bank->AssertInvariants();
                  }
                }
                for (uint32_t index = 0u; can_resolve && index < descriptor_update.count; ++index) {
                  const auto resolved_element = renodx::utils::pipeline_layout::FindDescriptorLocation(
                      param, Api, descriptor_update, index);
                  assert(resolved_element.has_value());
                  if (!resolved_element) {
                    can_resolve = false;
                    break;
                  }
                  auto element = descriptor_update;
                  element.binding = resolved_element->binding;
                  element.array_offset = resolved_element->array_offset;
                  element.count = 1u;
                  element.descriptors = static_cast<const uint8_t*>(descriptor_update.descriptors)
                                        + (static_cast<size_t>(index) * descriptor_size);
                  if (finite) {
                    const auto bank_it = find_bank(resolved_element->binding);
                    assert(bank_it != push_state->descriptor_banks.end());
                    if (bank_it == push_state->descriptor_banks.end()) {
                      can_resolve = false;
                      break;
                    }
                    assert(resolved_element->array_offset < bank_it->count);
                    if (resolved_element->array_offset >= bank_it->count) {
                      can_resolve = false;
                      break;
                    }
                    bank_it->payload.Copy(bank_it->type, resolved_element->array_offset, element.descriptors, 1u);
                    bank_it->present[resolved_element->array_offset / DescriptorBank::WORD_BITS] |= size_t{1} << (resolved_element->array_offset % DescriptorBank::WORD_BITS);
                  } else {
                    store(element);
                  }
                }
                resolved = can_resolve;
              }
            }
          }
          if (resolved) return;
          for (auto& bank : push_state->descriptor_banks) {
            if (push_state->has_unresolved_descriptors) break;
            bank.AssertInvariants();
            for (size_t index = bank.Next(0u); index < bank.count; index = bank.Next(index + 1u)) {
              push_state->AddDescriptorUpdate()->Store(
                  bank.layout_param,
                  {.binding = bank.binding,
                   .array_offset = static_cast<uint32_t>(index),
                   .count = 1u,
                   .type = bank.type,
                   .descriptors = bank.payload.Data(index)});
            }
            std::fill(bank.present.begin(), bank.present.end(), size_t{0});
          }
          push_state->has_unresolved_descriptors = true;
          // Only compare intervals with the same binding origin. Without layout
          // metadata, cross-binding spill boundaries cannot be reconstructed.
          size_t retained = 0u;
          for (size_t index = 0u; index < push_state->descriptor_count; ++index) {
            const auto& previous = push_state->descriptors[index];
            if (previous.layout_param == update_layout_param
                && previous.type == descriptor_update.type
                && previous.binding == descriptor_update.binding
                && previous.array_offset >= descriptor_update.array_offset
                && static_cast<uint64_t>(previous.array_offset) + previous.count
                       <= static_cast<uint64_t>(descriptor_update.array_offset) + descriptor_update.count) {
              continue;
            }
            if (retained != index) {
              std::swap(push_state->descriptors[retained], push_state->descriptors[index]);
            }
            ++retained;
          }
          push_state->descriptor_count = retained;
          push_state->AddDescriptorUpdate()->Store(update_layout_param, descriptor_update);
          return;
        }

        for (uint32_t index = 0u; index < descriptor_update.count; ++index) {
          auto element = descriptor_update;
          element.binding += index;
          element.count = 1u;
          element.descriptors = static_cast<const uint8_t*>(descriptor_update.descriptors)
                                + (static_cast<size_t>(index) * descriptor_size);
          store(element);
        }
      };

      const auto update_descriptor_slots = [&](uint32_t update_layout_param,
                                               reshade::api::descriptor_type type,
                                               const void* descriptors) {
        push_state->GetDescriptorSlots(update_layout_param, type)->Update(update.binding, update.count, descriptors);
      };

      if (update.array_offset != 0u) {
        store_descriptor_update(layout_param, update);
        continue;
      }

      if constexpr (Api == reshade::api::device_api::d3d9) {
        if ((stage == reshade::api::shader_stage::vertex
             && layout_param == D3D9_VERTEX_SAMPLER_LAYOUT_PARAM)
            || (stage == reshade::api::shader_stage::pixel
                && layout_param == D3D9_PIXEL_SAMPLER_LAYOUT_PARAM)) {
          switch (update.type) {
            case reshade::api::descriptor_type::sampler_with_resource_view:
              update_descriptor_slots(layout_param, update.type, update.descriptors);
              store_descriptor_update(layout_param, update);
              continue;
            case reshade::api::descriptor_type::shader_resource_view: {
              std::vector<reshade::api::sampler_with_resource_view> descriptors(update.count);
              const auto* resource_views = static_cast<const reshade::api::resource_view*>(update.descriptors);
              assert(resource_views != nullptr);
              for (uint32_t i = 0; i < update.count; ++i) {
                descriptors[i] = {
                    .sampler = {0},
                    .view = resource_views[i],
                };
              }
              update_descriptor_slots(layout_param, reshade::api::descriptor_type::sampler_with_resource_view, descriptors.data());
              store_descriptor_update(
                  layout_param,
                  {
                      .table = update.table,
                      .binding = update.binding,
                      .array_offset = update.array_offset,
                      .count = update.count,
                      .type = reshade::api::descriptor_type::sampler_with_resource_view,
                      .descriptors = descriptors.data(),
                  });
              continue;
            }
            default:
              break;
          }
        }
        update_descriptor_slots(layout_param, update.type, update.descriptors);
        store_descriptor_update(layout_param, update);
        continue;
      }

      if constexpr (Api != reshade::api::device_api::d3d12) {
        update_descriptor_slots(layout_param, update.type, update.descriptors);
      }
      store_descriptor_update(layout_param, update);
    }
    if (!use_single_binding) {
      resolved_resource_view_binds.clear();
    }
  }

  void BindDescriptorTables(reshade::api::shader_stage stages,
                            reshade::api::pipeline_layout layout,
                            uint32_t first, uint32_t count,
                            const reshade::api::descriptor_table* tables
#if RESHADE_API_VERSION >= 20
                            ,
                            uint32_t dynamic_offset_count, const uint32_t* dynamic_offsets
#endif
  ) {
    auto& current_state = snapshot;
    if constexpr (Api == reshade::api::device_api::d3d12) {
      assert(first <= D3D12_ROOT_PARAMETER_COUNT && count <= D3D12_ROOT_PARAMETER_COUNT - first);
      if (first > D3D12_ROOT_PARAMETER_COUNT || count > D3D12_ROOT_PARAMETER_COUNT - first) return;
    }
    TransitionPipelineLayout(stages, layout);
    // Push-only consumers still need root-signature invalidation, not tables.
    if (shared.data != nullptr && !shared.data->use_snapshot && !shared.data->use_descriptor_tables) return;
    const bool has_graphics = renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_graphics);
    const bool has_ray_tracing = renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_ray_tracing);
    const bool has_compute = renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_compute)
                             || (Api == reshade::api::device_api::d3d12 && has_ray_tracing);
    if (!has_graphics && !has_compute && !has_ray_tracing) return;
    // D3D12 emits this notification even for a redundant SetRootSignature.
    // TransitionPipelineLayout already invalidates arguments on a real change.
    const bool clear_descriptor_tables = count == 0u && tables == nullptr
                                         && Api != reshade::api::device_api::d3d12;

#if RESHADE_API_VERSION >= 20
    cross_addon::vector<cross_addon::vector<uint32_t>> table_dynamic_offsets;
    if (dynamic_offset_count != 0u && dynamic_offsets != nullptr) {
      table_dynamic_offsets.resize(count);
      const size_t domain_index = Api == reshade::api::device_api::opengl
                                      ? 0u
                                      : (has_compute || (has_ray_tracing && Api == reshade::api::device_api::d3d12)
                                             ? 1u
                                             : (has_ray_tracing ? 2u : 0u));
      auto& cached = current_state.layout_data_by_domain[domain_index];
      if (cached.layout != layout) {
        cached.layout = layout;
        cached.data = nullptr;
      }
      if (cached.data == nullptr) {
        pipeline_layout::GetPipelineLayoutData(layout, [&](const auto* layout_data) {
          cached.data = layout_data;
        });
      }
      if (const auto* layout_data = cached.data; layout_data != nullptr) {
        uint32_t source_offset = 0u;
        const auto count_ranges = [](uint32_t range_count, const auto* ranges) {
          uint32_t descriptor_count = 0u;
          for (uint32_t range_index = 0u; range_index < range_count; ++range_index) {
            const auto& range = ranges[range_index];
            if (range.type
                    != reshade::api::descriptor_type::constant_buffer_with_dynamic_offset
                && range.type
                       != reshade::api::descriptor_type::shader_storage_buffer_with_dynamic_offset) {
              continue;
            }
            if (range.count == UINT32_MAX
                || descriptor_count > UINT32_MAX - range.count) {
              return UINT32_MAX;
            }
            descriptor_count += range.count;
          }
          return descriptor_count;
        };
        for (uint32_t index = 0u;
             index < count && first + index < layout_data->params.size();
             ++index) {
          const auto& param = layout_data->params[first + index];
          uint32_t table_offset_count = 0u;
          switch (param.type) {
            case reshade::api::pipeline_layout_param_type::push_descriptors:
              if (param.push_descriptors.type
                      == reshade::api::descriptor_type::constant_buffer_with_dynamic_offset
                  || param.push_descriptors.type
                         == reshade::api::descriptor_type::shader_storage_buffer_with_dynamic_offset) {
                table_offset_count = param.push_descriptors.count;
              }
              break;
            case reshade::api::pipeline_layout_param_type::descriptor_table:
            case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
              table_offset_count = count_ranges(
                  param.descriptor_table.count,
                  param.descriptor_table.ranges);
              break;
            case reshade::api::pipeline_layout_param_type::descriptor_table_with_flags:
            case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges_and_flags:
              table_offset_count = count_ranges(
                  param.descriptor_table_with_flags.count,
                  param.descriptor_table_with_flags.ranges);
              break;
            case reshade::api::pipeline_layout_param_type::push_constants:
              break;
          }
          if (table_offset_count == UINT32_MAX
              || table_offset_count > dynamic_offset_count - source_offset) {
            table_offset_count = dynamic_offset_count - source_offset;
          }
          table_dynamic_offsets[index].assign(
              dynamic_offsets + source_offset,
              dynamic_offsets + source_offset + table_offset_count);
          source_offset += table_offset_count;
          if (source_offset == dynamic_offset_count) break;
        }
      }
    }
#endif

    const auto update_state = [&](reshade::api::pipeline_layout* tracked_layout,
                                  auto* tracked_tables
#if RESHADE_API_VERSION >= 20
                                  ,
                                  cross_addon::vector<cross_addon::vector<uint32_t>>* tracked_dynamic_offsets
#endif
                              ) {
      if (clear_descriptor_tables || layout != *tracked_layout) {
        tracked_tables->clear();  // Layout changed, which resets all descriptor table bindings
#if RESHADE_API_VERSION >= 20
        tracked_dynamic_offsets->clear();
#endif
      }
      *tracked_layout = layout;
      if (layout.handle == 0u || clear_descriptor_tables) return;
      tracked_tables->setRange(first, {tables, count});
#if RESHADE_API_VERSION >= 20
      const size_t total_count = static_cast<size_t>(first) + count;
      if (!table_dynamic_offsets.empty() && tracked_dynamic_offsets->size() < total_count) {
        tracked_dynamic_offsets->resize(total_count);
      }
      for (uint32_t i = 0; i < count; ++i) {
        if (table_dynamic_offsets.empty()) {
          if (i + first >= tracked_dynamic_offsets->size()) continue;
          (*tracked_dynamic_offsets)[i + first].clear();
        } else {
          (*tracked_dynamic_offsets)[i + first] = table_dynamic_offsets[i];
        }
      }
#endif
    };
    if (has_graphics) {
      current_state.graphics_descriptor_tables_known = true;
      if constexpr (Api != reshade::api::device_api::d3d12) {
        if (clear_descriptor_tables || layout != current_state.graphics_pipeline_layout) {
          current_state.ClearPushStates(reshade::api::shader_stage::all_graphics);
        }
      }
      update_state(
          &current_state.graphics_pipeline_layout,
          &current_state.graphics_descriptor_tables
#if RESHADE_API_VERSION >= 20
          ,
          &current_state.graphics_descriptor_table_dynamic_offsets
#endif
      );
    }
    if (has_compute) {
      current_state.compute_descriptor_tables_known = true;
      if constexpr (Api != reshade::api::device_api::d3d12) {
        if (clear_descriptor_tables || layout != current_state.compute_pipeline_layout) {
          current_state.ClearPushStates(reshade::api::shader_stage::all_compute);
        }
      }
      update_state(
          &current_state.compute_pipeline_layout,
          &current_state.compute_descriptor_tables
#if RESHADE_API_VERSION >= 20
          ,
          &current_state.compute_descriptor_table_dynamic_offsets
#endif
      );
    }
    if constexpr (Api != reshade::api::device_api::d3d12) {
      if (has_ray_tracing) {
        current_state.ray_tracing_descriptor_tables_known = true;
        if (clear_descriptor_tables || layout != current_state.ray_tracing_pipeline_layout) {
          current_state.ClearPushStates(reshade::api::shader_stage::all_ray_tracing);
        }
        update_state(
            &current_state.ray_tracing_pipeline_layout,
            &current_state.ray_tracing_descriptor_tables
#if RESHADE_API_VERSION >= 20
            ,
            &current_state.ray_tracing_descriptor_table_dynamic_offsets
#endif
        );
      }
    }
  }

  void BindPipelineStates(uint32_t count, const reshade::api::dynamic_state* states, const uint32_t* values) {
    for (uint32_t index = 0u; index < count; ++index) {
      if constexpr (Api == reshade::api::device_api::d3d12) {
        const auto found = std::find(D3D12_DYNAMIC_STATES.begin(), D3D12_DYNAMIC_STATES.end(), states[index]);
        if (found != D3D12_DYNAMIC_STATES.end()) {
          recording[0].dynamic_states.set(found - D3D12_DYNAMIC_STATES.begin(), values[index]);
        }
      } else {
        if (states[index] == reshade::api::dynamic_state::unknown) continue;
        const auto [entry, inserted] = snapshot.dynamic_states.try_emplace(states[index], values[index]);
        if (inserted) {
          snapshot.dynamic_state_order.push_back(states[index]);
        } else {
          entry->second = values[index];
        }
      }
    }
  }

  void BindRenderTargetsAndDepthStencil(uint32_t count, const reshade::api::resource_view* rtvs,
                                        reshade::api::resource_view dsv) {
    if constexpr (Api == reshade::api::device_api::d3d12) {
      assert(count <= snapshot.render_target_storage.size());
      if (count > snapshot.render_target_storage.size()) return;
    }
    snapshot.ResizeRenderTargets(rtvs != nullptr ? count : 0u);
    if (!snapshot.render_targets.empty()) {
      std::copy_n(rtvs, count, snapshot.render_targets.data());
    }
    snapshot.depth_stencil = dsv;
    snapshot.render_targets_known = true;
  }

  void BeginRenderPass(uint32_t count, const reshade::api::render_pass_render_target_desc* render_targets,
                       const reshade::api::render_pass_depth_stencil_desc* depth_stencil) {
    if constexpr (Api == reshade::api::device_api::d3d12) {
      assert(count <= snapshot.render_target_storage.size());
      if (count > snapshot.render_target_storage.size()) return;
    }
    if (snapshot.render_pass_depth++ != 0u) return;
    snapshot.ResizeRenderTargets(count);
    for (uint32_t index = 0u; index < count; ++index) {
      snapshot.render_targets[index] = render_targets[index].view;
    }
    snapshot.depth_stencil = (depth_stencil == nullptr ? reshade::api::resource_view{0u} : depth_stencil->view);
    snapshot.render_targets_known = true;
  }

  void EndRenderPass() {
    if (snapshot.render_pass_depth == 0u) return;
    if (--snapshot.render_pass_depth != 0u) return;
    snapshot.render_targets = {};
    snapshot.depth_stencil = {0u};
    snapshot.render_targets_known = true;
  }

  void BindViewports(uint32_t first, uint32_t count, const reshade::api::viewport* viewports) {
    if constexpr (Api == reshade::api::device_api::d3d10 || Api == reshade::api::device_api::d3d11) {
      if (shared.data != nullptr && !shared.data->use_viewport_scissor_tracking) return;
    }
    if constexpr (Api == reshade::api::device_api::d3d10 || Api == reshade::api::device_api::d3d11
                  || Api == reshade::api::device_api::d3d12) {
      assert(first == 0u && count <= D3D12_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE);
      if (first != 0u || count > D3D12_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE || (count != 0u && viewports == nullptr)) return;
      if (count != 0u) {
        snapshot.fixed_viewports.setRange(0u, {viewports, count});
      }
      snapshot.fixed_viewports.clear(count, D3D12_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE - count);
      snapshot.viewports_known = true;
    } else {
      if (first == 0u && count == 0u) {
        snapshot.viewports.clear();
        snapshot.known_viewport_slots.clear();
        snapshot.viewports_known = true;
        return;
      }
      if (count == 0u || viewports == nullptr) return;
      snapshot.viewports_known = true;
      const uint32_t total_count = first + count;
      if (snapshot.viewports.size() < total_count) {
        snapshot.viewports.resize(total_count);
        snapshot.known_viewport_slots.resize(total_count);
      }
      for (uint32_t index = 0u; index < count; ++index) {
        snapshot.viewports[first + index] = viewports[index];
        snapshot.known_viewport_slots[first + index] = 1u;
      }
    }
  }

  void BindScissorRects(uint32_t first, uint32_t count, const reshade::api::rect* rects) {
    if constexpr (Api == reshade::api::device_api::d3d10 || Api == reshade::api::device_api::d3d11
                  || Api == reshade::api::device_api::d3d12) {
      assert(first == 0u && count <= D3D12_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE);
      if (first != 0u || count > D3D12_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE || (count != 0u && rects == nullptr)) return;
      if (count != 0u) {
        snapshot.fixed_scissor_rects.setRange(0u, {rects, count});
      }
      snapshot.fixed_scissor_rects.clear(count, D3D12_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE - count);
      snapshot.scissor_rects_known = true;
    } else {
      if (first == 0u && count == 0u) {
        snapshot.scissor_rects.clear();
        snapshot.known_scissor_rect_slots.clear();
        snapshot.scissor_rects_known = true;
        return;
      }
      if (count == 0u || rects == nullptr) return;
      snapshot.scissor_rects_known = true;
      const uint32_t total_count = first + count;
      if (snapshot.scissor_rects.size() < total_count) {
        snapshot.scissor_rects.resize(total_count);
        snapshot.known_scissor_rect_slots.resize(total_count);
      }
      for (uint32_t index = 0u; index < count; ++index) {
        snapshot.scissor_rects[first + index] = rects[index];
        snapshot.known_scissor_rect_slots[first + index] = 1u;
      }
    }
  }

  void BindVertexBuffers(uint32_t first, uint32_t count, const reshade::api::resource* buffers,
                         const uint64_t* offsets, const uint32_t* strides) {
    // D3D9 draw-UP bindings can reference ReShade's overwritten synthetic handle.
    // D3D9/10/11 input-assembler state is captured through native getters instead.
    if constexpr (Api == reshade::api::device_api::d3d9
                  || Api == reshade::api::device_api::d3d10
                  || Api == reshade::api::device_api::d3d11) return;
    if (count == 0u) return;
    assert(buffers != nullptr && offsets != nullptr);
    if (buffers == nullptr || offsets == nullptr) return;
    if constexpr (Api == reshade::api::device_api::d3d12) {
      assert(first <= D3D12_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT && count <= D3D12_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT - first);
      if (first > D3D12_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT || count > D3D12_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT - first) return;
      auto& slots = recording[0].vertex_buffers;
      for (uint32_t index = 0u; index < count; ++index) {
        const auto slot = first + index;
        uint32_t stride = 0u;
        if (strides != nullptr) {
          stride = strides[index];
        } else if (slots.has(slot)) {
          stride = slots.get(slot).stride;
        }
        slots.set(slot, typename D3D12Recording::VertexBuffer{
                            .buffer = buffers[index], .offset = offsets[index], .stride = stride});
      }
    } else {
      const uint32_t total_count = first + count;
      if (snapshot.vertex_buffers.size() < total_count) {
        snapshot.vertex_buffers.resize(total_count);
        snapshot.vertex_buffer_offsets.resize(total_count);
        snapshot.vertex_buffer_strides.resize(total_count);
        snapshot.known_vertex_buffer_slots.resize(total_count);
      }
      for (uint32_t index = 0u; index < count; ++index) {
        const auto slot = first + index;
        snapshot.vertex_buffers[slot] = buffers[index];
        snapshot.vertex_buffer_offsets[slot] = offsets[index];
        if (strides != nullptr) {
          snapshot.vertex_buffer_strides[slot] = strides[index];
        }
        snapshot.known_vertex_buffer_slots[slot] = 1u;
      }
    }
  }

  void BindIndexBuffer(reshade::api::resource buffer, uint64_t offset, uint32_t index_size) {
    if constexpr (Api == reshade::api::device_api::d3d9
                  || Api == reshade::api::device_api::d3d10
                  || Api == reshade::api::device_api::d3d11) return;
    snapshot.index_buffer = buffer;
    snapshot.index_buffer_offset = offset;
    snapshot.index_size = index_size;
    snapshot.index_buffer_known = true;
  }

  void PushConstants(reshade::api::shader_stage stages, reshade::api::pipeline_layout layout,
                     uint32_t layout_param, uint32_t first, uint32_t count, const void* values) {
    assert(count != 0u);
    assert(values != nullptr);
    TransitionPipelineLayout(stages, layout);
    if constexpr (Api == reshade::api::device_api::d3d12) {
      assert(stages == reshade::api::shader_stage::all_graphics
             || stages == (reshade::api::shader_stage::all_compute | reshade::api::shader_stage::all_ray_tracing));
      if (stages != reshade::api::shader_stage::all_graphics
          && stages != (reshade::api::shader_stage::all_compute | reshade::api::shader_stage::all_ray_tracing)) return;
      if (layout.handle == 0u) return;
      recording[0].root_constants[stages == reshade::api::shader_stage::all_graphics ? GRAPHICS_ROOT_DOMAIN : COMPUTE_ROOT_DOMAIN].Update(
          layout_param, first, {static_cast<const uint32_t*>(values), count});
    } else {
      for (auto& push_state : snapshot.push_states) {
        if (!renodx::utils::bitwise::HasFlag(stages, push_state.stage)) continue;
        push_state.SetLayout(layout);
        if (layout.handle == 0u) continue;
        push_state.GetConstants(layout_param)->values.setRange(first, {static_cast<const uint32_t*>(values), count});
      }
    }
  }

  [[nodiscard]] constexpr size_t GetPipelineSlot(reshade::api::pipeline_stage stage) const {
    if constexpr (Api == reshade::api::device_api::d3d11 || Api == reshade::api::device_api::opengl) {
      switch (stage) {
        case reshade::api::pipeline_stage::vertex_shader:   return 0u;
        case reshade::api::pipeline_stage::hull_shader:     return 1u;
        case reshade::api::pipeline_stage::domain_shader:   return 2u;
        case reshade::api::pipeline_stage::geometry_shader: return 3u;
        case reshade::api::pipeline_stage::stream_output:
          if constexpr (Api == reshade::api::device_api::d3d11) return 3u;
          return PIPELINE_SLOT_COUNT;
        case reshade::api::pipeline_stage::pixel_shader:    return 4u;
        case reshade::api::pipeline_stage::compute_shader:  return 5u;
        case reshade::api::pipeline_stage::input_assembler: return 6u;
        case reshade::api::pipeline_stage::rasterizer:      return 7u;
        case reshade::api::pipeline_stage::depth_stencil:   return 8u;
        case reshade::api::pipeline_stage::output_merger:   return 9u;
        default:                                            return PIPELINE_SLOT_COUNT;
      }
    } else if constexpr (Api == reshade::api::device_api::d3d10) {
      switch (stage) {
        case reshade::api::pipeline_stage::vertex_shader:   return 0u;
        case reshade::api::pipeline_stage::geometry_shader:
        case reshade::api::pipeline_stage::stream_output:   return 1u;
        case reshade::api::pipeline_stage::pixel_shader:    return 2u;
        case reshade::api::pipeline_stage::input_assembler: return 3u;
        case reshade::api::pipeline_stage::rasterizer:      return 4u;
        case reshade::api::pipeline_stage::depth_stencil:   return 5u;
        case reshade::api::pipeline_stage::output_merger:   return 6u;
        default:                                            return PIPELINE_SLOT_COUNT;
      }
    } else if constexpr (Api == reshade::api::device_api::d3d9) {
      switch (stage) {
        case reshade::api::pipeline_stage::vertex_shader:   return 0u;
        case reshade::api::pipeline_stage::pixel_shader:    return 1u;
        case reshade::api::pipeline_stage::input_assembler: return 2u;
        default:                                            return PIPELINE_SLOT_COUNT;
      }
    }
    return PIPELINE_SLOT_COUNT;
  }

  CommandListState() { snapshot.device_api = Api; }
  CommandListState(const CommandListState&) = delete;
  CommandListState& operator=(const CommandListState&) = delete;

  void TransitionPipelineLayout(reshade::api::shader_stage stages, reshade::api::pipeline_layout layout) {
    if constexpr (Api == reshade::api::device_api::d3d12) {
      if (renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_graphics)
          && layout != snapshot.graphics_root_pipeline_layout) {
        snapshot.graphics_root_pipeline_layout = layout;
        snapshot.graphics_pipeline_layout = {0};
        snapshot.graphics_descriptor_tables.clear();
#if RESHADE_API_VERSION >= 20
        snapshot.graphics_descriptor_table_dynamic_offsets.clear();
#endif
        snapshot.graphics_descriptor_tables_known = false;
        snapshot.ClearPushStates(reshade::api::shader_stage::all_graphics);
        if (!snapshot.push_states.empty()) {
          snapshot.push_states[GRAPHICS_ROOT_DOMAIN].layout = layout;
        }
        recording[0].root_constants[GRAPHICS_ROOT_DOMAIN].Clear();
      }
      if ((renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_compute)
           || renodx::utils::bitwise::HasAnyFlag(stages, reshade::api::shader_stage::all_ray_tracing))
          && layout != snapshot.compute_root_pipeline_layout) {
        snapshot.compute_root_pipeline_layout = layout;
        snapshot.compute_pipeline_layout = {0};
        snapshot.compute_descriptor_tables.clear();
#if RESHADE_API_VERSION >= 20
        snapshot.compute_descriptor_table_dynamic_offsets.clear();
#endif
        snapshot.compute_descriptor_tables_known = false;
        snapshot.ray_tracing_pipeline_layout = {0};
#if RESHADE_API_VERSION >= 20
        snapshot.ray_tracing_descriptor_table_dynamic_offsets.clear();
#endif
        snapshot.ray_tracing_descriptor_tables_known = false;
        snapshot.ClearPushStates(reshade::api::shader_stage::all_compute
                                 | reshade::api::shader_stage::all_ray_tracing);
        if (!snapshot.push_states.empty()) {
          snapshot.push_states[COMPUTE_ROOT_DOMAIN].layout = layout;
        }
        recording[0].root_constants[COMPUTE_ROOT_DOMAIN].Clear();
      }
    }
  }

  void Clear() {
    snapshot.Clear();
    bound_pipelines.clear();
    bind_sequence = 0u;
    if constexpr (Api == reshade::api::device_api::d3d12) {
      recording[0].dynamic_states.clear();
      recording[0].vertex_buffers.clear();
      for (auto& constants : recording[0].root_constants) {
        constants.Clear();
      }
    }
  }

  void BindPipeline(reshade::api::pipeline_stage stages, reshade::api::pipeline pipeline, PipelineBindPoint bind_point) {
    if constexpr (Api == reshade::api::device_api::opengl) {
      // glUseProgram binds all shader stages, including the compute bit, even
      // for graphics programs. The program is shared by both replay domains.
      if (stages == reshade::api::pipeline_stage::all_shader_stages) {
        bind_point = PipelineBindPoint::UNKNOWN;
      }
    }
    if (stages == reshade::api::pipeline_stage::all && pipeline.handle == 0u) {
      bound_pipelines.clear();
      bind_sequence = 0u;
      snapshot.bound_pipeline_infos = {};
      if constexpr (Api == reshade::api::device_api::d3d11) {
        static constexpr std::array RESET_STAGES = {
            reshade::api::pipeline_stage::vertex_shader, reshade::api::pipeline_stage::hull_shader,
            reshade::api::pipeline_stage::domain_shader, reshade::api::pipeline_stage::geometry_shader,
            reshade::api::pipeline_stage::pixel_shader, reshade::api::pipeline_stage::compute_shader,
            reshade::api::pipeline_stage::input_assembler, reshade::api::pipeline_stage::rasterizer,
            reshade::api::pipeline_stage::depth_stencil, reshade::api::pipeline_stage::output_merger};
        for (size_t slot = 0u; slot < RESET_STAGES.size(); ++slot) {
          bound_pipelines.set(slot, PipelineBind{
                                        .stages = RESET_STAGES[slot],
                                        .bind_point = (slot == 5u ? PipelineBindPoint::COMPUTE : PipelineBindPoint::GRAPHICS),
                                        .sequence = ++bind_sequence,
                                    });
        }
      }
    } else {
      const PipelineBind bind{.stages = stages, .pipeline = pipeline, .bind_point = bind_point, .sequence = ++bind_sequence};
      if constexpr (Api == reshade::api::device_api::d3d12) {
        // Repeated handles still invalidate cached nodes: the old pipeline may
        // have been destroyed and a new pipeline created at the same handle.
        switch (bind_point) {
          case PipelineBindPoint::GRAPHICS:
            bound_pipelines.set(0u, bind);
            snapshot.bound_pipeline_infos[GRAPHICS_ROOT_DOMAIN] = nullptr;
            break;
          case PipelineBindPoint::COMPUTE:
            bound_pipelines.set(1u, bind);
            snapshot.bound_pipeline_infos[COMPUTE_ROOT_DOMAIN] = nullptr;
            break;
          case PipelineBindPoint::RAY_TRACING:
            bound_pipelines.set(2u, bind);
            break;
          default: assert(false); break;
        }
        return;
      } else if constexpr (Api == reshade::api::device_api::vulkan) {
        switch (bind_point) {
          case PipelineBindPoint::GRAPHICS:    bound_pipelines.set(0u, bind); break;
          case PipelineBindPoint::COMPUTE:     bound_pipelines.set(1u, bind); break;
          case PipelineBindPoint::RAY_TRACING: bound_pipelines.set(2u, bind); break;
          default:                             assert(false); break;
        }
      } else {
        size_t slot = GetPipelineSlot(stages);
        if constexpr (Api == reshade::api::device_api::d3d10 || Api == reshade::api::device_api::d3d11) {
          if (stages == (reshade::api::pipeline_stage::geometry_shader | reshade::api::pipeline_stage::stream_output)) {
            slot = (Api == reshade::api::device_api::d3d11 ? 3u : 1u);
          }
        }
        if (slot != PIPELINE_SLOT_COUNT) {
          bound_pipelines.set(slot, bind);
        } else {
          auto remaining = static_cast<uint32_t>(stages);
          while (remaining != 0u) {
            slot = GetPipelineSlot(static_cast<reshade::api::pipeline_stage>(uint32_t{1} << std::countr_zero(remaining)));
            remaining &= remaining - 1u;
            if (slot != PIPELINE_SLOT_COUNT) {
              bound_pipelines.set(slot, bind);
            }
          }
        }
      }
      auto affected_stages = stages;
      if constexpr (Api == reshade::api::device_api::d3d12
                    || Api == reshade::api::device_api::vulkan) {
        switch (bind_point) {
          case PipelineBindPoint::GRAPHICS:
            affected_stages = reshade::api::pipeline_stage::all_graphics
                              | reshade::api::pipeline_stage::amplification_shader
                              | reshade::api::pipeline_stage::mesh_shader;
            break;
          case PipelineBindPoint::COMPUTE:
            affected_stages = reshade::api::pipeline_stage::compute_shader;
            break;
          default: affected_stages = static_cast<reshade::api::pipeline_stage>(0u); break;
        }
      } else if constexpr (Api == reshade::api::device_api::d3d10
                           || Api == reshade::api::device_api::d3d11) {
        if (bitwise::HasAnyFlag(stages, reshade::api::pipeline_stage::stream_output)) {
          affected_stages |= reshade::api::pipeline_stage::geometry_shader;
        }
      }
      for (size_t index = 0u; index < pipeline::SHADER_STAGES.size(); ++index) {
        if (!bitwise::HasAnyFlag(affected_stages, pipeline::SHADER_STAGES[index])) continue;
        // A previously cached node may already have been destroyed.
        snapshot.bound_pipeline_infos[index] = nullptr;
      }
    }
  }

  [[nodiscard]] BackendSnapshotData<Api> Capture() const {
    BackendSnapshotData<Api> data(snapshot);
    CopyPipelineBinds(&data.pipeline_binds);
    if constexpr (Api == reshade::api::device_api::d3d12) {
      for (size_t domain = 0u; domain < recording[0].root_constants.size(); ++domain) {
        const auto& source = recording[0].root_constants[domain];
        auto& target = data.root_constant_storage[domain];
        target.Clear();
        for (const auto& [param, parameter] : source.parameters.entries()) {
          target.parameters.set(param, D3D12RootConstants::ParameterRange{
                                           .offset = static_cast<uint8_t>(target.used),
                                           .count = parameter.count});
          uint32_t slot = parameter.head;
          for (uint32_t word = 0u; word < parameter.count; ++word) {
            if (source.values.has(slot)) {
              target.values.set(target.used + word, source.values.get(slot));
            }
            if (word + 1u < parameter.count) {
              slot = source.next[slot];
            }
          }
          target.used += parameter.count;
        }
      }
      for (const auto& [slot, value] : recording[0].dynamic_states.entries()) {
        data.dynamic_states.insert_or_assign(D3D12_DYNAMIC_STATES[slot], value);
      }
      for (const auto& [slot, value] : recording[0].vertex_buffers.entries()) {
        if (data.vertex_buffers.size() <= slot) {
          data.vertex_buffers.resize(slot + 1u);
          data.vertex_buffer_offsets.resize(slot + 1u);
          data.vertex_buffer_strides.resize(slot + 1u);
          data.known_vertex_buffer_slots.resize(slot + 1u);
        }
        data.vertex_buffers[slot] = value.buffer;
        data.vertex_buffer_offsets[slot] = value.offset;
        data.vertex_buffer_strides[slot] = value.stride;
        data.known_vertex_buffer_slots[slot] = 1u;
      }
    }
    return data;
  }

  void CopyPipelineBinds(cross_addon::vector<PipelineBind>* binds) const {
    std::array<uint8_t, PIPELINE_SLOT_COUNT> ordered{};
    size_t count = 0u;
    for (const auto slot : bound_pipelines.indexes()) ordered[count++] = static_cast<uint8_t>(slot);
    std::sort(ordered.begin(), ordered.begin() + count,
              [&](uint8_t lhs, uint8_t rhs) { return bound_pipelines.get(lhs).sequence < bound_pipelines.get(rhs).sequence; });
    binds->clear();
    binds->reserve(count);
    uint64_t previous = 0u;
    for (size_t index = 0u; index < count; ++index) {
      const auto& bind = bound_pipelines.get(ordered[index]);
      if (bind.sequence == previous) continue;
      previous = bind.sequence;
      binds->push_back(bind);
    }
  }

  [[nodiscard]] reshade::api::pipeline GetBoundShaderPipeline(
      reshade::api::pipeline_stage stage, PipelineBind* bound_bind = nullptr) const {
    size_t slot;
    if constexpr (Api == reshade::api::device_api::d3d12 || Api == reshade::api::device_api::vulkan) {
      switch (stage) {
        case reshade::api::pipeline_stage::vertex_shader:
        case reshade::api::pipeline_stage::hull_shader:
        case reshade::api::pipeline_stage::domain_shader:
        case reshade::api::pipeline_stage::geometry_shader:
        case reshade::api::pipeline_stage::pixel_shader:
        case reshade::api::pipeline_stage::amplification_shader:
        case reshade::api::pipeline_stage::mesh_shader:          slot = 0u; break;
        case reshade::api::pipeline_stage::compute_shader:       slot = 1u; break;
        default:                                                 return {0u};
      }
    } else {
      slot = GetPipelineSlot(stage);
    }
    if (slot >= PIPELINE_SLOT_COUNT || !bound_pipelines.has(slot)) return {0u};
    const auto& bind = bound_pipelines.get(slot);
    if (bound_bind != nullptr) *bound_bind = bind;
    return bind.pipeline;
  }
};

template <typename F>
decltype(auto) WithCommandListState(const CommandListStateHandle* handle, F&& callback) {
  assert(handle != nullptr);
  switch (handle->api) {
    case reshade::api::device_api::d3d9:
      return callback(*static_cast<CommandListState<reshade::api::device_api::d3d9>*>(handle->state));
    case reshade::api::device_api::d3d10:
      return callback(*static_cast<CommandListState<reshade::api::device_api::d3d10>*>(handle->state));
    case reshade::api::device_api::d3d11:
      return callback(*static_cast<CommandListState<reshade::api::device_api::d3d11>*>(handle->state));
    case reshade::api::device_api::d3d12:
      return callback(*static_cast<CommandListState<reshade::api::device_api::d3d12>*>(handle->state));
    case reshade::api::device_api::opengl:
      return callback(*static_cast<CommandListState<reshade::api::device_api::opengl>*>(handle->state));
    case reshade::api::device_api::vulkan:
      return callback(*static_cast<CommandListState<reshade::api::device_api::vulkan>*>(handle->state));
    default:
      assert(false);
      std::abort();
  }
}

}  // namespace internal

// Module-local legacy view: preserve the pre-rewrite field types and order.
// Modern tracking and replay metadata belong to CommandListSnapshot, not this ABI.
struct CommandListState {
  std::vector<reshade::api::resource_view> render_targets;
  reshade::api::resource_view depth_stencil = {0};
  std::unordered_map<reshade::api::pipeline_stage, reshade::api::pipeline> pipelines;
  reshade::api::primitive_topology primitive_topology = reshade::api::primitive_topology::undefined;
  uint32_t blend_constant = 0;
  uint32_t sample_mask = 0xFFFFFFFF;
  uint32_t front_stencil_reference_value = 0;
  uint32_t back_stencil_reference_value = 0;
  std::vector<reshade::api::viewport> viewports;
  std::vector<reshade::api::rect> scissor_rects;
  reshade::api::pipeline_layout graphics_pipeline_layout = {0};
  std::vector<reshade::api::descriptor_table> graphics_descriptor_tables;
  reshade::api::pipeline_layout compute_pipeline_layout = {0};
  std::vector<reshade::api::descriptor_table> compute_descriptor_tables;
  std::unordered_map<reshade::api::shader_stage, std::pair<reshade::api::pipeline_layout, std::vector<reshade::api::descriptor_table>>> descriptor_tables;

  void Apply(reshade::api::command_list* cmd_list) const {
    if (!render_targets.empty() || depth_stencil.handle != 0u) {
      // Destroyed RTVs are not removed.
      std::vector<reshade::api::resource_view> new_rtvs = render_targets;
      for (size_t index = 0u; index < render_targets.size(); ++index) {
        if (!renodx::utils::resource::IsKnownResourceView(render_targets[index])) {
          new_rtvs[index] = {0};
        }
      }
      cmd_list->bind_render_targets_and_depth_stencil(
          static_cast<uint32_t>(new_rtvs.size()), new_rtvs.data(), depth_stencil);
    }
    for (const auto& [stages, pipeline] : pipelines) {
      cmd_list->bind_pipeline(stages, pipeline);
    }
    if (primitive_topology != reshade::api::primitive_topology::undefined) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::primitive_topology, static_cast<uint32_t>(primitive_topology));
    }
    if (blend_constant != 0u) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::blend_constant, blend_constant);
    }
    if (sample_mask != 0xFFFFFFFFu) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::sample_mask, sample_mask);
    }
    if (front_stencil_reference_value != 0u) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::front_stencil_reference_value, front_stencil_reference_value);
    }
    if (back_stencil_reference_value != 0u) {
      cmd_list->bind_pipeline_state(reshade::api::dynamic_state::back_stencil_reference_value, back_stencil_reference_value);
    }
    if (!viewports.empty()) {
      cmd_list->bind_viewports(0u, static_cast<uint32_t>(viewports.size()), viewports.data());
    }
    if (!scissor_rects.empty()) {
      cmd_list->bind_scissor_rects(0u, static_cast<uint32_t>(scissor_rects.size()), scissor_rects.data());
    }
    const bool is_d3d12 = cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12;
    const auto bind_descriptor_tables = [&](reshade::api::shader_stage stages,
                                            reshade::api::pipeline_layout layout,
                                            const std::vector<reshade::api::descriptor_table>& tables) {
      if (layout.handle == 0u) return;
      if (is_d3d12) {
        bool bound_table = false;
        for (uint32_t index = 0u; index < tables.size(); ++index) {
          if (tables[index].handle == 0u) continue;
          cmd_list->bind_descriptor_tables(stages, layout, index, 1u, &tables[index]);
          bound_table = true;
        }
        if (!bound_table) {
          cmd_list->bind_descriptor_tables(stages, layout, 0u, 0u, nullptr);
        }
        return;
      }
      size_t index = 0u;
      while (index < tables.size()) {
        while (index < tables.size() && tables[index].handle == 0u) ++index;
        if (index == tables.size()) break;
        const size_t first = index;
        while (index < tables.size() && tables[index].handle != 0u) ++index;
        cmd_list->bind_descriptor_tables(stages, layout, static_cast<uint32_t>(first),
                                         static_cast<uint32_t>(index - first), tables.data() + first);
      }
    };
    bind_descriptor_tables(reshade::api::shader_stage::all_graphics, graphics_pipeline_layout, graphics_descriptor_tables);
    bind_descriptor_tables(reshade::api::shader_stage::all_compute, compute_pipeline_layout, compute_descriptor_tables);
  }

  void Clear() {
    render_targets.clear();
    depth_stencil = {0};
    pipelines.clear();
    primitive_topology = reshade::api::primitive_topology::undefined;
    blend_constant = 0;
    sample_mask = 0xFFFFFFFF;
    front_stencil_reference_value = 0;
    back_stencil_reference_value = 0;
    viewports.clear();
    scissor_rects.clear();
    graphics_pipeline_layout = {0};
    graphics_descriptor_tables.clear();
    compute_pipeline_layout = {0};
    compute_descriptor_tables.clear();
  }
};

class CommandListSnapshot final {
 public:
  [[nodiscard]] reshade::api::primitive_topology GetPrimitiveTopology() const {
    const auto& data = GetData();
    const auto found = data.dynamic_states.find(reshade::api::dynamic_state::primitive_topology);
    return (found == data.dynamic_states.end() ? reshade::api::primitive_topology::undefined
                                               : static_cast<reshade::api::primitive_topology>(found->second));
  }

  [[nodiscard]] reshade::api::resource_view GetRenderTarget(uint32_t slot) const {
    const auto& data = GetData();
    return (data.render_targets_known && slot < data.render_targets.size() ? data.render_targets[slot]
                                                                           : reshade::api::resource_view{0u});
  }

  [[nodiscard]] reshade::api::resource_view GetPushedResourceView(
      reshade::api::shader_stage stage, uint32_t layout_param,
      reshade::api::descriptor_type type, uint32_t binding) const {
    return GetData().GetPushedResourceView(stage, layout_param, type, binding);
  }

  void ApplyNativeDescriptors(reshade::api::shader_stage stage) const {
    GetData().ApplyNativeDescriptors(command_list, stage);
  }

  void RestoreConstantBufferBindings(uint32_t slot, bool is_dispatch) const {
    const auto& state = GetData();
    if (slot >= D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT
        || (state.device_api != reshade::api::device_api::d3d10
            && state.device_api != reshade::api::device_api::d3d11)
        || (state.device_api == reshade::api::device_api::d3d10 && is_dispatch)
        || state.native_descriptors.empty()) return;

    const auto& stages = state.native_descriptors[0].stages;
    for (size_t index = 0u; index < stages.size(); ++index) {
      if (is_dispatch != (index == 5u)
          || (state.device_api == reshade::api::device_api::d3d10 && (index == 1u || index == 2u || index == 5u))) continue;
      if (!stages[index].cbvs.slots.has(slot)) continue;
      const auto& range = stages[index].cbvs.slots.get(slot);
      // A null layout makes the descriptor binding the native slot, independent
      // of the injected shader's synthetic pipeline layout.
      command_list->push_descriptors(
          D3D10And11DescriptorState::SHADER_STAGES[index], {}, 0u,
          {.binding = slot,
           .count = 1u,
           .type = reshade::api::descriptor_type::constant_buffer,
           .descriptors = &range});
    }
  }

  void Apply() const {
    std::visit([&](const auto& data) { data.Apply(command_list); }, state);
    ApplyD3D9Samplers(command_list);
  }

  bool ApplyGraphics(bool apply_pipelines = true, reshade::api::command_list* destination = nullptr) const {
    if (destination == nullptr) {
      destination = command_list;
    }
    if (destination == nullptr || command_list == nullptr
        || destination->get_device() != command_list->get_device()) return false;
    std::visit([&](const auto& data) { data.ApplyGraphics(destination, apply_pipelines); }, state);
    return ApplyD3D9Samplers(destination);
  }

  bool ApplyCompute(bool apply_pipelines = true, reshade::api::command_list* destination = nullptr) const {
    if (destination == nullptr) {
      destination = command_list;
    }
    if (destination == nullptr || command_list == nullptr
        || destination->get_device() != command_list->get_device()) return false;
    std::visit([&](const auto& data) { data.ApplyCompute(destination, apply_pipelines); }, state);
    return true;
  }

  void ApplyRayTracing(bool apply_pipelines = true) const {
    std::visit([&](const auto& data) { data.ApplyRayTracing(command_list, apply_pipelines); }, state);
  }

  void ApplyPipelines(PipelineBindPoint bind_point = PipelineBindPoint::UNKNOWN) const {
    GetData().ApplyPipelines(command_list, bind_point);
  }

 private:
  // These functions construct snapshots and materialize the deprecated compatibility view.
  friend std::optional<CommandListSnapshot> GetSnapshot(
      reshade::api::command_list* cmd_list);
  friend CommandListState* GetCurrentState(
      reshade::api::command_list* cmd_list);

  reshade::api::command_list* command_list = nullptr;
  struct D3D9SamplerValue {
    DWORD sampler;
    D3DSAMPLERSTATETYPE type;
    DWORD value;
  };
  std::vector<D3D9SamplerValue> d3d9_sampler_values;

  bool ApplyD3D9Samplers(reshade::api::command_list* destination) const {
    if (d3d9_sampler_values.empty()) return true;
    auto* native = reinterpret_cast<IDirect3DDevice9*>(static_cast<uintptr_t>(destination->get_native()));
    bool applied = true;
    // Descriptor replay may set SRGBTEXTURE; native captured values take precedence.
    for (const auto& sampler : d3d9_sampler_values) {
      applied &= SUCCEEDED(native->SetSamplerState(sampler.sampler, sampler.type, sampler.value));
    }
    return applied;
  }

  std::variant<
      internal::BackendSnapshotData<reshade::api::device_api::d3d9>,
      internal::BackendSnapshotData<reshade::api::device_api::d3d10>,
      internal::BackendSnapshotData<reshade::api::device_api::d3d11>,
      internal::BackendSnapshotData<reshade::api::device_api::d3d12>,
      internal::BackendSnapshotData<reshade::api::device_api::opengl>,
      internal::BackendSnapshotData<reshade::api::device_api::vulkan>>
      state;

  const internal::CommandListSnapshotData& GetData() const {
    return std::visit([](const auto& data) -> const internal::CommandListSnapshotData& { return data; }, state);
  }
};

struct BoundDescriptorTables {
  reshade::api::pipeline_layout layout = {0u};
  DescriptorTableSlots tables;
  bool known = false;
};

// Scope to one command invocation; an engaged null pointer also caches a missing state.
using CommandListStateCache = std::optional<const internal::CommandListStateHandle*>;

namespace internal {
inline const CommandListStateHandle* GetCommandListStateHandle(
    reshade::api::command_list* cmd_list,
    CommandListStateCache* cache = nullptr) {
  if (cache != nullptr && cache->has_value()) return **cache;
  const auto* state = cmd_list == nullptr
                          ? nullptr
                          : renodx::utils::data::Get<CommandListStateHandle>(cmd_list);
  if (cache != nullptr) {
    *cache = state;
  }
  return state;
}

inline CommandListSnapshotData* GetTrackedSnapshotData(
    reshade::api::command_list* cmd_list,
    CommandListStateCache* cache = nullptr) {
  const auto* handle = GetCommandListStateHandle(cmd_list, cache);
  if (handle == nullptr) return nullptr;
  return WithCommandListState(handle, [](auto& state) -> CommandListSnapshotData* { return &state.snapshot; });
}
}  // namespace internal

inline reshade::api::pipeline GetBoundShaderPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    CommandListStateCache* cache = nullptr,
    PipelineBind* bound_bind = nullptr) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list, cache);
  if (handle == nullptr) return {0u};
  return internal::WithCommandListState(handle, [&](const auto& state) {
    return state.GetBoundShaderPipeline(stage, bound_bind);
  });
}

// Borrowed metadata for the currently bound pipeline; valid only while that pipeline remains alive.
inline const pipeline::PipelineInfo* GetBoundPipelineInfo(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    CommandListStateCache* cache = nullptr) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list, cache);
  if (handle == nullptr) return nullptr;
  return internal::WithCommandListState(handle, [&]<reshade::api::device_api Api>(const internal::CommandListState<Api>& state) -> const pipeline::PipelineInfo* {
    auto index = pipeline::GetShaderStageIndex(stage);
    if (index >= pipeline::SHADER_STAGES.size()) return nullptr;
    if constexpr (Api == reshade::api::device_api::d3d12) {
      index = (stage == reshade::api::pipeline_stage::compute_shader ? COMPUTE_ROOT_DOMAIN : GRAPHICS_ROOT_DOMAIN);
    }
    auto& cached = state.snapshot.bound_pipeline_infos[index];
    if (cached != nullptr) return cached;
    const auto bound_pipeline = state.GetBoundShaderPipeline(stage);
    if (bound_pipeline.handle == 0u) return nullptr;
    pipeline::GetPipelineInfo(bound_pipeline, [&](const pipeline::PipelineInfo& info) {
      cached = &info;
    });
    return cached;
  });
}

// Zero when the stage is unbound, unsupported, or the bound pipeline has no known shader detail.
inline uint32_t GetCurrentShaderHash(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    CommandListStateCache* cache = nullptr) {
  const auto* info = GetBoundPipelineInfo(cmd_list, stage, cache);
  if (info == nullptr) return 0u;
  const auto index = pipeline::GetShaderStageIndex(stage);
  if (index >= pipeline::SHADER_STAGES.size()) return 0u;
  if (info->shader_detail_index_ready) {
    const auto& detail_index = info->shader_detail_by_stage[index];
    return detail_index.has_value() ? info->shader_details[*detail_index].shader_hash : 0u;
  }
  uint32_t shader_hash = 0u;
  for (const auto& detail : info->shader_details) {
    if (detail.stage == stage) {
      shader_hash = detail.shader_hash;
    }
  }
  return shader_hash;
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  const auto create = [&]<reshade::api::device_api Api>() {
    using State = internal::CommandListState<Api>;
    auto* state = cross_addon::allocator<State>().allocate(1u);
    std::construct_at(state);
    cmd_list->set_private_data(
        reinterpret_cast<const uint8_t*>(&__uuidof(internal::CommandListStateHandle)),
        reinterpret_cast<uintptr_t>(&state->handle));
  };
  switch (cmd_list->get_device()->get_api()) {
    case reshade::api::device_api::d3d9:   create.template operator()<reshade::api::device_api::d3d9>(); break;
    case reshade::api::device_api::d3d10:  create.template operator()<reshade::api::device_api::d3d10>(); break;
    case reshade::api::device_api::d3d11:  create.template operator()<reshade::api::device_api::d3d11>(); break;
    case reshade::api::device_api::d3d12:  create.template operator()<reshade::api::device_api::d3d12>(); break;
    case reshade::api::device_api::opengl: create.template operator()<reshade::api::device_api::opengl>(); break;
    case reshade::api::device_api::vulkan: create.template operator()<reshade::api::device_api::vulkan>(); break;
    default:                               assert(false); break;
  }
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [](auto& state) {
    using State = std::remove_reference_t<decltype(state)>;
    std::destroy_at(&state);
    cross_addon::allocator<State>().deallocate(&state, 1u);
  });
  cmd_list->set_private_data(reinterpret_cast<const uint8_t*>(&__uuidof(internal::CommandListStateHandle)), 0u);
}

static void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline,
    pipeline::PipelineBindPoint bind_point) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) {
    state.BindPipeline(stages, pipeline, bind_point);
  });
}

static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) { state.BindRenderTargetsAndDepthStencil(count, rtvs, dsv); });
}

static void OnBeginRenderPass(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::render_pass_render_target_desc* render_targets,
    const reshade::api::render_pass_depth_stencil_desc* depth_stencil) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) { state.BeginRenderPass(count, render_targets, depth_stencil); });
}

static void OnEndRenderPass(reshade::api::command_list* cmd_list) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [](auto& state) { state.EndRenderPass(); });
}

static void OnBindPipelineStates(
    reshade::api::command_list* cmd_list,
    uint32_t count, const reshade::api::dynamic_state* states,
    const uint32_t* values) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) { state.BindPipelineStates(count, states, values); });
}

static void OnBindViewports(
    reshade::api::command_list* cmd_list,
    uint32_t first, uint32_t count,
    const reshade::api::viewport* viewports) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) { state.BindViewports(first, count, viewports); });
}

static void OnBindScissorRects(
    reshade::api::command_list* cmd_list,
    uint32_t first, uint32_t count,
    const reshade::api::rect* rects) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) { state.BindScissorRects(first, count, rects); });
}

static void OnBindVertexBuffers(
    reshade::api::command_list* cmd_list,
    uint32_t first,
    uint32_t count,
    const reshade::api::resource* buffers,
    const uint64_t* offsets,
    const uint32_t* strides) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) { state.BindVertexBuffers(first, count, buffers, offsets, strides); });
}

static void OnBindIndexBuffer(
    reshade::api::command_list* cmd_list,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t index_size) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) { state.BindIndexBuffer(buffer, offset, index_size); });
}

static void OnBindDescriptorTables(reshade::api::command_list* cmd_list,
                                   reshade::api::shader_stage stages,
                                   reshade::api::pipeline_layout layout,
                                   uint32_t first, uint32_t count,
                                   const reshade::api::descriptor_table* tables
#if RESHADE_API_VERSION >= 20
                                   ,
                                   uint32_t dynamic_offset_count, const uint32_t* dynamic_offsets
#endif
) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) {
    state.BindDescriptorTables(stages, layout, first, count, tables
#if RESHADE_API_VERSION >= 20
                               ,
                               dynamic_offset_count, dynamic_offsets
#endif
    );
  });
}

static void OnPushConstants(reshade::api::command_list* cmd_list,
                            reshade::api::shader_stage stages,
                            reshade::api::pipeline_layout layout,
                            uint32_t layout_param,
                            uint32_t first,
                            uint32_t count,
                            const void* values) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) { state.PushConstants(stages, layout, layout_param, first, count, values); });
}

static void OnPushDescriptors(reshade::api::command_list* cmd_list,
                              reshade::api::shader_stage stages,
                              reshade::api::pipeline_layout layout,
                              uint32_t layout_param,
                              const reshade::api::descriptor_table_update& update) {
  const auto* handle = renodx::utils::data::Get<internal::CommandListStateHandle>(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [&](auto& state) {
    state.PushDescriptors(stages, layout, layout_param, update);
  });
}

static void OnResetCommandList(reshade::api::command_list* cmd_list) {
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return;
  internal::WithCommandListState(handle, [](auto& state) { state.Clear(); });
}

// Copies every currently bound table because descriptor-inspection consumers
// enumerate the pipeline layout's parameters and ranges to discover all bound
// resources. The copy remains valid after subsequent command-list callbacks.
[[nodiscard]] inline std::optional<BoundDescriptorTables> CopyBoundDescriptorTables(
    reshade::api::command_list* cmd_list,
    PipelineBindPoint bind_point,
    CommandListStateCache* cache = nullptr) {
  if (bind_point == PipelineBindPoint::UNKNOWN) return std::nullopt;
  const auto* handle = internal::GetCommandListStateHandle(cmd_list, cache);
  if (handle == nullptr) return std::nullopt;
  return internal::WithCommandListState(handle, [&](const auto& state) -> std::optional<BoundDescriptorTables> {
    const auto& data = state.snapshot;
    const auto copy = [](reshade::api::pipeline_layout layout, const auto& tables, bool known) {
      BoundDescriptorTables result{.layout = layout, .known = known};
      for (const auto& [index, table] : tables.entries()) {
        result.tables.set(index, table);
      }
      return result;
    };
    switch (bind_point) {
      case PipelineBindPoint::GRAPHICS:
        return copy(data.graphics_pipeline_layout, data.graphics_descriptor_tables, data.graphics_descriptor_tables_known);
      case PipelineBindPoint::COMPUTE:
        return copy(data.compute_pipeline_layout, data.compute_descriptor_tables, data.compute_descriptor_tables_known);
      case PipelineBindPoint::RAY_TRACING:
        if constexpr (std::is_same_v<std::remove_cvref_t<decltype(state)>, internal::CommandListState<reshade::api::device_api::d3d12>>) {
          return copy(data.compute_pipeline_layout, data.compute_descriptor_tables, data.compute_descriptor_tables_known);
        } else {
          return copy(data.ray_tracing_pipeline_layout, data.ray_tracing_descriptor_tables, data.ray_tracing_descriptor_tables_known);
        }
      case PipelineBindPoint::UNKNOWN:
        return std::nullopt;
    }
    return std::nullopt;
  });
}

[[nodiscard]] inline reshade::api::resource_view GetBoundResourceView(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stage,
    reshade::api::descriptor_type type,
    uint32_t slot,
    uint32_t space = 0u,
    CommandListStateCache* cache = nullptr) {
  const auto device_api = cmd_list->get_device()->get_api();
  switch (device_api) {
    case reshade::api::device_api::d3d9:
      break;
    case reshade::api::device_api::d3d10: {
      if (space != 0u) return {0u};
      if (type != reshade::api::descriptor_type::shader_resource_view) break;

      auto* native = reinterpret_cast<ID3D10Device*>(static_cast<uintptr_t>(cmd_list->get_native()));
      ID3D10ShaderResourceView* view = nullptr;
      switch (stage) {
        case reshade::api::shader_stage::vertex:
          native->VSGetShaderResources(slot, 1u, &view);
          break;
        case reshade::api::shader_stage::geometry:
          native->GSGetShaderResources(slot, 1u, &view);
          break;
        case reshade::api::shader_stage::pixel:
          native->PSGetShaderResources(slot, 1u, &view);
          break;
        default:
          return {0u};
      }
      const reshade::api::resource_view result = {reinterpret_cast<uintptr_t>(view)};
      if (view != nullptr) {
        view->Release();
      }
      return result;
    }
    case reshade::api::device_api::d3d11: {
      if (space != 0u) return {0u};

      auto* native = reinterpret_cast<ID3D11DeviceContext*>(static_cast<uintptr_t>(cmd_list->get_native()));

      switch (type) {
        case reshade::api::descriptor_type::shader_resource_view: {
          ID3D11ShaderResourceView* view = nullptr;
          switch (stage) {
            case reshade::api::shader_stage::vertex:
              native->VSGetShaderResources(slot, 1u, &view);
              break;
            case reshade::api::shader_stage::hull:
              native->HSGetShaderResources(slot, 1u, &view);
              break;
            case reshade::api::shader_stage::domain:
              native->DSGetShaderResources(slot, 1u, &view);
              break;
            case reshade::api::shader_stage::geometry:
              native->GSGetShaderResources(slot, 1u, &view);
              break;
            case reshade::api::shader_stage::pixel:
              native->PSGetShaderResources(slot, 1u, &view);
              break;
            case reshade::api::shader_stage::compute:
              native->CSGetShaderResources(slot, 1u, &view);
              break;
            default:
              return {0u};
          }
          const reshade::api::resource_view result = {reinterpret_cast<uintptr_t>(view)};
          if (view != nullptr) {
            view->Release();
          }
          return result;
        }
        case reshade::api::descriptor_type::unordered_access_view: {
          ID3D11UnorderedAccessView* view = nullptr;
          switch (stage) {
            case reshade::api::shader_stage::pixel:
              native->OMGetRenderTargetsAndUnorderedAccessViews(0u, nullptr, nullptr, slot, 1u, &view);
              break;
            case reshade::api::shader_stage::compute:
              native->CSGetUnorderedAccessViews(slot, 1u, &view);
              break;
            default:
              return {0u};
          }
          const reshade::api::resource_view result = {reinterpret_cast<uintptr_t>(view)};
          if (view != nullptr) {
            view->Release();
          }
          return result;
        }
        default:
          break;
      }
      break;
    }
    case reshade::api::device_api::d3d12:
    case reshade::api::device_api::opengl:
    case reshade::api::device_api::vulkan:
      break;
  }

  const auto* state = internal::GetTrackedSnapshotData(cmd_list, cache);
  if (state == nullptr) return {0u};
  return state->GetBoundResourceView(stage, type, slot, space);
}

[[nodiscard]] inline reshade::api::resource_view GetRenderTarget(
    reshade::api::command_list* cmd_list,
    uint32_t slot,
    CommandListStateCache* cache = nullptr) {
  switch (cmd_list->get_device()->get_api()) {
    case reshade::api::device_api::d3d9: {
      auto* native = reinterpret_cast<IDirect3DDevice9*>(
          static_cast<uintptr_t>(cmd_list->get_native()));
      IDirect3DSurface9* render_target = nullptr;
      if (FAILED(native->GetRenderTarget(slot, &render_target))) return {0u};
      DWORD srgb_write_enabled = FALSE;
      native->GetRenderState(D3DRS_SRGBWRITEENABLE, &srgb_write_enabled);
      const reshade::api::resource_view result = {
          reinterpret_cast<uintptr_t>(render_target) | (srgb_write_enabled != FALSE ? 1u : 0u)};
      if (render_target != nullptr) {
        render_target->Release();
      }
      return result;
    }
    case reshade::api::device_api::d3d10: {
      if (slot >= D3D10_SIMULTANEOUS_RENDER_TARGET_COUNT) return {0u};
      auto* native = reinterpret_cast<ID3D10Device*>(
          static_cast<uintptr_t>(cmd_list->get_native()));
      std::array<ID3D10RenderTargetView*, D3D10_SIMULTANEOUS_RENDER_TARGET_COUNT> render_targets = {};
      native->OMGetRenderTargets(slot + 1u, render_targets.data(), nullptr);
      const reshade::api::resource_view result = {reinterpret_cast<uintptr_t>(render_targets[slot])};
      for (uint32_t index = 0u; index <= slot; ++index) {
        if (render_targets[index] != nullptr) {
          render_targets[index]->Release();
        }
      }
      return result;
    }
    case reshade::api::device_api::d3d11: {
      if (slot >= D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT) return {0u};
      auto* native = reinterpret_cast<ID3D11DeviceContext*>(
          static_cast<uintptr_t>(cmd_list->get_native()));
      std::array<ID3D11RenderTargetView*, D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT> render_targets = {};
      native->OMGetRenderTargets(slot + 1u, render_targets.data(), nullptr);
      const reshade::api::resource_view result = {reinterpret_cast<uintptr_t>(render_targets[slot])};
      for (uint32_t index = 0u; index <= slot; ++index) {
        if (render_targets[index] != nullptr) {
          render_targets[index]->Release();
        }
      }
      return result;
    }
    case reshade::api::device_api::d3d12:
    case reshade::api::device_api::opengl:
    case reshade::api::device_api::vulkan:
      break;
  }

  const auto* state = internal::GetTrackedSnapshotData(cmd_list, cache);
  if (state == nullptr
      || !state->render_targets_known
      || slot >= state->render_targets.size()) return {0u};
  return state->render_targets[slot];
}

[[nodiscard]] inline std::vector<reshade::api::resource_view> GetRenderTargets(
    reshade::api::command_list* cmd_list,
    CommandListStateCache* cache = nullptr) {
  switch (cmd_list->get_device()->get_api()) {
    case reshade::api::device_api::d3d9: {
      auto* native = reinterpret_cast<IDirect3DDevice9*>(
          static_cast<uintptr_t>(cmd_list->get_native()));
      D3DCAPS9 caps = {};
      if (FAILED(native->GetDeviceCaps(&caps))) return {};
      DWORD srgb_write_enabled = FALSE;
      native->GetRenderState(D3DRS_SRGBWRITEENABLE, &srgb_write_enabled);
      std::vector<reshade::api::resource_view> result(caps.NumSimultaneousRTs);
      for (DWORD slot = 0u; slot < caps.NumSimultaneousRTs; ++slot) {
        IDirect3DSurface9* render_target = nullptr;
        if (SUCCEEDED(native->GetRenderTarget(slot, &render_target))) {
          result[slot] = {
              reinterpret_cast<uintptr_t>(render_target) | (srgb_write_enabled != FALSE ? 1u : 0u)};
        }
        if (render_target != nullptr) {
          render_target->Release();
        }
      }
      while (!result.empty() && result.back().handle == 0u) {
        result.pop_back();
      }
      return result;
    }
    case reshade::api::device_api::d3d10: {
      auto* native = reinterpret_cast<ID3D10Device*>(
          static_cast<uintptr_t>(cmd_list->get_native()));
      std::array<ID3D10RenderTargetView*, D3D10_SIMULTANEOUS_RENDER_TARGET_COUNT> render_targets = {};
      native->OMGetRenderTargets(static_cast<UINT>(render_targets.size()), render_targets.data(), nullptr);
      std::vector<reshade::api::resource_view> result(render_targets.size());
      for (size_t slot = 0u; slot < render_targets.size(); ++slot) {
        result[slot] = {reinterpret_cast<uintptr_t>(render_targets[slot])};
        if (render_targets[slot] != nullptr) {
          render_targets[slot]->Release();
        }
      }
      while (!result.empty() && result.back().handle == 0u) {
        result.pop_back();
      }
      return result;
    }
    case reshade::api::device_api::d3d11: {
      auto* native = reinterpret_cast<ID3D11DeviceContext*>(
          static_cast<uintptr_t>(cmd_list->get_native()));
      std::array<ID3D11RenderTargetView*, D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT> render_targets = {};
      native->OMGetRenderTargets(static_cast<UINT>(render_targets.size()), render_targets.data(), nullptr);
      std::vector<reshade::api::resource_view> result(render_targets.size());
      for (size_t slot = 0u; slot < render_targets.size(); ++slot) {
        result[slot] = {reinterpret_cast<uintptr_t>(render_targets[slot])};
        if (render_targets[slot] != nullptr) {
          render_targets[slot]->Release();
        }
      }
      while (!result.empty() && result.back().handle == 0u) {
        result.pop_back();
      }
      return result;
    }
    case reshade::api::device_api::d3d12:
    case reshade::api::device_api::opengl:
    case reshade::api::device_api::vulkan:
      break;
  }

  const auto* state = internal::GetTrackedSnapshotData(cmd_list, cache);
  if (state == nullptr || !state->render_targets_known) return {};
  return {state->render_targets.begin(), state->render_targets.end()};
}

[[nodiscard]] inline std::optional<CommandListSnapshot> GetSnapshot(
    reshade::api::command_list* cmd_list) {
  if (shared.data != nullptr && !shared.data->use_snapshot) return std::nullopt;
  const auto* handle = internal::GetCommandListStateHandle(cmd_list);
  if (handle == nullptr) return std::nullopt;

  CommandListSnapshot snapshot;
  snapshot.command_list = cmd_list;
  internal::WithCommandListState(handle, [&]<reshade::api::device_api Api>(const internal::CommandListState<Api>& live_state) {
    snapshot.state = live_state.Capture();
  });
  auto* state = std::visit([](auto& data) -> internal::CommandListSnapshotData* { return &data; }, snapshot.state);
  switch (state->device_api) {
    case reshade::api::device_api::d3d9: {
      auto* native_device = reinterpret_cast<IDirect3DDevice9*>(
          static_cast<uintptr_t>(cmd_list->get_native()));
      // D3D9 SetSamplerState does not emit ReShade events, and SetTexture
      // reports a zero sampler handle. Query these values at capture time.
      // Slots 0..15 are pixel samplers; 256..260 are displacement/vertex samplers.
      for (DWORD slot = 0u; slot <= D3DVERTEXTEXTURESAMPLER3 - D3DDMAPSAMPLER + 16u; ++slot) {
        const DWORD sampler = (slot < 16u ? slot : D3DDMAPSAMPLER + slot - 16u);
        for (DWORD type = D3DSAMP_ADDRESSU; type <= D3DSAMP_DMAPOFFSET; ++type) {
          DWORD value = 0u;
          if (SUCCEEDED(native_device->GetSamplerState(sampler, static_cast<D3DSAMPLERSTATETYPE>(type), &value))) {
            snapshot.d3d9_sampler_values.push_back({
                .sampler = sampler,
                .type = static_cast<D3DSAMPLERSTATETYPE>(type),
                .value = value,
            });
          }
        }
      }
      D3DCAPS9 caps = {};
      if (SUCCEEDED(native_device->GetDeviceCaps(&caps))) {
        state->vertex_buffers.resize(caps.MaxStreams);
        state->vertex_buffer_offsets.resize(caps.MaxStreams);
        state->vertex_buffer_strides.resize(caps.MaxStreams);
        state->known_vertex_buffer_slots.assign(caps.MaxStreams, 0u);
        for (DWORD slot = 0u; slot < caps.MaxStreams; ++slot) {
          IDirect3DVertexBuffer9* buffer = nullptr;
          UINT offset = 0u;
          UINT stride = 0u;
          if (SUCCEEDED(native_device->GetStreamSource(slot, &buffer, &offset, &stride))) {
            state->vertex_buffers[slot] = {reinterpret_cast<uintptr_t>(buffer)};
            state->vertex_buffer_offsets[slot] = offset;
            state->vertex_buffer_strides[slot] = stride;
            state->known_vertex_buffer_slots[slot] = 1u;
          }
          if (buffer != nullptr) {
            buffer->Release();
          }
        }
        IDirect3DIndexBuffer9* index_buffer = nullptr;
        if (SUCCEEDED(native_device->GetIndices(&index_buffer))) {
          state->index_buffer = {reinterpret_cast<uintptr_t>(index_buffer)};
          state->index_buffer_offset = 0u;
          state->index_size = 0u;
          if (index_buffer != nullptr) {
            D3DINDEXBUFFER_DESC desc = {};
            if (SUCCEEDED(index_buffer->GetDesc(&desc))) {
              state->index_size = (desc.Format == D3DFMT_INDEX16 ? 2u : 4u);
            }
            index_buffer->Release();
          }
          state->index_buffer_known = true;
        }
      }
      break;
    }
    default:
      break;
  }

  const auto capture_d3d10_and_11 = [&](auto* native) {
    using Native = std::remove_pointer_t<decltype(native)>;
    if constexpr (std::is_same_v<Native, ID3D10Device>
                  || std::is_same_v<Native, ID3D11DeviceContext>) {
      if (state->native_descriptors.empty()) {
        state->native_descriptors.emplace_back();
      }
      auto& descriptors = state->native_descriptors[0];

      // RSGetViewports copies cached context records, not a table lookup or GPU
      // query. Capture here instead of duplicating every viewport bind solely
      // for snapshots (see docs/plans/opaque-command-list-snapshot.md).
      using NativeViewport = std::conditional_t<std::is_same_v<Native, ID3D10Device>, D3D10_VIEWPORT, D3D11_VIEWPORT>;
      std::array<NativeViewport, D3D11_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE> viewports = {};
      UINT viewport_count = static_cast<UINT>(viewports.size());
      native->RSGetViewports(&viewport_count, viewports.data());
      state->fixed_viewports.clear();
      for (UINT index = 0u; index < viewport_count; ++index) {
        const auto& viewport = viewports[index];
        state->fixed_viewports.set(index, reshade::api::viewport{
                                              static_cast<float>(viewport.TopLeftX), static_cast<float>(viewport.TopLeftY),
                                              static_cast<float>(viewport.Width), static_cast<float>(viewport.Height),
                                              viewport.MinDepth, viewport.MaxDepth});
      }
      state->viewports_known = true;

      const auto store_vertex_buffers = [&](auto* native, uint32_t count) {
        using Native = std::remove_pointer_t<decltype(native)>;
        using Buffer = std::conditional_t<std::is_same_v<Native, ID3D10Device>, ID3D10Buffer, ID3D11Buffer>;
        std::array<Buffer*, D3D11_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT> buffers = {};
        std::array<UINT, D3D11_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT> strides = {};
        std::array<UINT, D3D11_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT> offsets = {};
        native->IAGetVertexBuffers(0u, count, buffers.data(), strides.data(), offsets.data());
        state->vertex_buffers.resize(count);
        state->vertex_buffer_offsets.resize(count);
        state->vertex_buffer_strides.resize(count);
        state->known_vertex_buffer_slots.assign(count, 1u);
        for (uint32_t index = 0u; index < count; ++index) {
          state->vertex_buffers[index] = {reinterpret_cast<uintptr_t>(buffers[index])};
          state->vertex_buffer_offsets[index] = offsets[index];
          state->vertex_buffer_strides[index] = strides[index];
          if (buffers[index] != nullptr) {
            buffers[index]->Release();
          }
        }
      };
      const auto store_index_buffer = [&](auto* native) {
        using Native = std::remove_pointer_t<decltype(native)>;
        using Buffer = std::conditional_t<std::is_same_v<Native, ID3D10Device>, ID3D10Buffer, ID3D11Buffer>;
        Buffer* buffer = nullptr;
        DXGI_FORMAT format = DXGI_FORMAT_UNKNOWN;
        UINT offset = 0u;
        native->IAGetIndexBuffer(&buffer, &format, &offset);
        state->index_buffer = {reinterpret_cast<uintptr_t>(buffer)};
        state->index_buffer_offset = offset;
        if (format == DXGI_FORMAT_R16_UINT) {
          state->index_size = 2u;
        } else if (format == DXGI_FORMAT_R32_UINT) {
          state->index_size = 4u;
        } else {
          state->index_size = 0u;
        }
        state->index_buffer_known = true;
        if (buffer != nullptr) {
          buffer->Release();
        }
      };
      const auto store_stage = [&](auto* native, reshade::api::shader_stage shader_stage) {
        using Native = std::remove_pointer_t<decltype(native)>;
        using Sampler = std::conditional_t<std::is_same_v<Native, ID3D10Device>, ID3D10SamplerState, ID3D11SamplerState>;
        using View = std::conditional_t<std::is_same_v<Native, ID3D10Device>, ID3D10ShaderResourceView, ID3D11ShaderResourceView>;
        using Buffer = std::conditional_t<std::is_same_v<Native, ID3D10Device>, ID3D10Buffer, ID3D11Buffer>;
        std::array<Sampler*, D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT> samplers = {};
        std::array<View*, D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT> views = {};
        std::array<Buffer*, 14u> buffers = {};
        switch (shader_stage) {
          case reshade::api::shader_stage::vertex:
            native->VSGetSamplers(0u, static_cast<UINT>(samplers.size()), samplers.data());
            native->VSGetShaderResources(0u, static_cast<UINT>(views.size()), views.data());
            native->VSGetConstantBuffers(0u, static_cast<UINT>(buffers.size()), buffers.data());
            break;
          case reshade::api::shader_stage::hull:
            if constexpr (std::is_same_v<Native, ID3D11DeviceContext>) {
              native->HSGetSamplers(0u, static_cast<UINT>(samplers.size()), samplers.data());
              native->HSGetShaderResources(0u, static_cast<UINT>(views.size()), views.data());
              native->HSGetConstantBuffers(0u, static_cast<UINT>(buffers.size()), buffers.data());
            }
            break;
          case reshade::api::shader_stage::domain:
            if constexpr (std::is_same_v<Native, ID3D11DeviceContext>) {
              native->DSGetSamplers(0u, static_cast<UINT>(samplers.size()), samplers.data());
              native->DSGetShaderResources(0u, static_cast<UINT>(views.size()), views.data());
              native->DSGetConstantBuffers(0u, static_cast<UINT>(buffers.size()), buffers.data());
            }
            break;
          case reshade::api::shader_stage::geometry:
            native->GSGetSamplers(0u, static_cast<UINT>(samplers.size()), samplers.data());
            native->GSGetShaderResources(0u, static_cast<UINT>(views.size()), views.data());
            native->GSGetConstantBuffers(0u, static_cast<UINT>(buffers.size()), buffers.data());
            break;
          case reshade::api::shader_stage::pixel:
            native->PSGetSamplers(0u, static_cast<UINT>(samplers.size()), samplers.data());
            native->PSGetShaderResources(0u, static_cast<UINT>(views.size()), views.data());
            native->PSGetConstantBuffers(0u, static_cast<UINT>(buffers.size()), buffers.data());
            break;
          case reshade::api::shader_stage::compute:
            if constexpr (std::is_same_v<Native, ID3D11DeviceContext>) {
              native->CSGetSamplers(0u, static_cast<UINT>(samplers.size()), samplers.data());
              native->CSGetShaderResources(0u, static_cast<UINT>(views.size()), views.data());
              native->CSGetConstantBuffers(0u, static_cast<UINT>(buffers.size()), buffers.data());
            }
            break;
          default: return;
        }
        const auto stage_index = GetSingleTrackedShaderStageIndex(shader_stage);
        auto& stage = descriptors.stages[stage_index];
        std::array<reshade::api::sampler, D3D11_COMMONSHADER_SAMPLER_SLOT_COUNT> sampler_handles = {};
        std::array<reshade::api::resource_view, D3D11_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT> view_handles = {};
        std::array<reshade::api::buffer_range, 14u> buffer_ranges = {};
        for (size_t index = 0u; index < samplers.size(); ++index) {
          sampler_handles[index] = {reinterpret_cast<uintptr_t>(samplers[index])};
          if (samplers[index] != nullptr) {
            samplers[index]->Release();
          }
        }
        for (size_t index = 0u; index < views.size(); ++index) {
          view_handles[index] = {reinterpret_cast<uintptr_t>(views[index])};
          if (views[index] != nullptr) {
            views[index]->Release();
          }
        }
        for (size_t index = 0u; index < buffers.size(); ++index) {
          buffer_ranges[index] = {
              .buffer = {reinterpret_cast<uintptr_t>(buffers[index])},
              .offset = 0u,
              .size = UINT64_MAX,
          };
          if (buffers[index] != nullptr) {
            buffers[index]->Release();
          }
        }
        stage.samplers.slots.setRange(0u, sampler_handles);
        stage.srvs.slots.setRange(0u, view_handles);
        stage.cbvs.slots.setRange(0u, buffer_ranges);
      };

      if constexpr (std::is_same_v<Native, ID3D10Device>) {
        store_vertex_buffers(native, D3D10_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT);
        store_index_buffer(native);
        store_stage(native, reshade::api::shader_stage::vertex);
        store_stage(native, reshade::api::shader_stage::geometry);
        store_stage(native, reshade::api::shader_stage::pixel);
      } else {
        store_vertex_buffers(native, D3D11_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT);
        store_index_buffer(native);
        for (const auto shader_stage : D3D10And11DescriptorState::SHADER_STAGES) {
          store_stage(native, shader_stage);
        }

        ID3D11DeviceContext1* native1 = nullptr;
        if (SUCCEEDED(native->QueryInterface(IID_PPV_ARGS(&native1)))) {
          const auto store_constant_buffer_ranges = [&](reshade::api::shader_stage shader_stage) {
            std::array<ID3D11Buffer*, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT> buffers = {};
            std::array<UINT, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT> first_constants = {};
            std::array<UINT, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT> constant_counts = {};
            switch (shader_stage) {
              case reshade::api::shader_stage::vertex:
                native1->VSGetConstantBuffers1(0u, static_cast<UINT>(buffers.size()), buffers.data(), first_constants.data(), constant_counts.data());
                break;
              case reshade::api::shader_stage::hull:
                native1->HSGetConstantBuffers1(0u, static_cast<UINT>(buffers.size()), buffers.data(), first_constants.data(), constant_counts.data());
                break;
              case reshade::api::shader_stage::domain:
                native1->DSGetConstantBuffers1(0u, static_cast<UINT>(buffers.size()), buffers.data(), first_constants.data(), constant_counts.data());
                break;
              case reshade::api::shader_stage::geometry:
                native1->GSGetConstantBuffers1(0u, static_cast<UINT>(buffers.size()), buffers.data(), first_constants.data(), constant_counts.data());
                break;
              case reshade::api::shader_stage::pixel:
                native1->PSGetConstantBuffers1(0u, static_cast<UINT>(buffers.size()), buffers.data(), first_constants.data(), constant_counts.data());
                break;
              case reshade::api::shader_stage::compute:
                native1->CSGetConstantBuffers1(0u, static_cast<UINT>(buffers.size()), buffers.data(), first_constants.data(), constant_counts.data());
                break;
              default:
                return;
            }
            std::array<reshade::api::buffer_range, D3D11_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT> ranges = {};
            for (size_t index = 0u; index < buffers.size(); ++index) {
              ranges[index] = {
                  .buffer = {reinterpret_cast<uintptr_t>(buffers[index])},
                  .offset = static_cast<uint64_t>(first_constants[index]) * D3D11_COMMONSHADER_CONSTANT_BUFFER_COMPONENTS * sizeof(uint32_t),
                  .size = buffers[index] == nullptr
                              ? UINT64_MAX
                              : static_cast<uint64_t>(constant_counts[index]) * D3D11_COMMONSHADER_CONSTANT_BUFFER_COMPONENTS * sizeof(uint32_t),
              };
              if (buffers[index] != nullptr) {
                buffers[index]->Release();
              }
            }
            const auto stage_index = GetSingleTrackedShaderStageIndex(shader_stage);
            descriptors.stages[stage_index].cbvs.slots.setRange(0u, ranges);
          };
          for (const auto shader_stage : D3D10And11DescriptorState::SHADER_STAGES) {
            store_constant_buffer_ranges(shader_stage);
          }
          native1->Release();
        }

        std::array<ID3D11UnorderedAccessView*, D3D11_1_UAV_SLOT_COUNT> uavs = {};
        std::array<reshade::api::resource_view, D3D11_1_UAV_SLOT_COUNT> handles = {};
        ID3D11Device* native_device = nullptr;
        native->GetDevice(&native_device);
        const auto feature_level = native_device->GetFeatureLevel();
        native_device->Release();
        UINT uav_count = 0u;
        if (feature_level >= D3D_FEATURE_LEVEL_11_1) {
          uav_count = D3D11_1_UAV_SLOT_COUNT;
        } else if (feature_level >= D3D_FEATURE_LEVEL_11_0) {
          uav_count = D3D11_PS_CS_UAV_REGISTER_COUNT;
        } else if (feature_level >= D3D_FEATURE_LEVEL_10_0) {
          uav_count = D3D11_CS_4_X_UAV_REGISTER_COUNT;
        }
        if (uav_count != 0u) {
          native->CSGetUnorderedAccessViews(0u, uav_count, uavs.data());
        }
        for (size_t index = 0u; index < uav_count; ++index) {
          handles[index] = {reinterpret_cast<uintptr_t>(uavs[index])};
          if (uavs[index] != nullptr) {
            uavs[index]->Release();
          }
        }
        descriptors.compute_uavs.slots.clear();
        descriptors.compute_uavs.slots.setRange(0u, {handles.data(), uav_count});
        uavs.fill(nullptr);
        handles.fill({0u});
        if (feature_level >= D3D_FEATURE_LEVEL_11_0) {
          native->OMGetRenderTargetsAndUnorderedAccessViews(
              0u, nullptr, nullptr, 0u, uav_count, uavs.data());
        }
        descriptors.graphics_uavs.slots.clear();
        for (size_t index = 0u; index < uavs.size(); ++index) {
          handles[index] = {reinterpret_cast<uintptr_t>(uavs[index])};
          if (uavs[index] != nullptr) {
            descriptors.graphics_uavs.slots.set(index, handles[index]);
            uavs[index]->Release();
          }
        }
      }
    }
  };

  switch (state->device_api) {
    case reshade::api::device_api::d3d10:
      capture_d3d10_and_11(reinterpret_cast<ID3D10Device*>(static_cast<uintptr_t>(cmd_list->get_native())));
      break;
    case reshade::api::device_api::d3d11:
      capture_d3d10_and_11(reinterpret_cast<ID3D11DeviceContext*>(static_cast<uintptr_t>(cmd_list->get_native())));
      break;
    case reshade::api::device_api::d3d9:
    case reshade::api::device_api::d3d12:
    case reshade::api::device_api::opengl:
    case reshade::api::device_api::vulkan:
      break;
  }
  return snapshot;
}

// Module-local borrowed compatibility view, overwritten by the next call on this
// thread (including calls for other command lists). Copy before retaining it.
// Prefer GetSnapshot for modern tracking metadata and complete replay.
[[deprecated("Use GetSnapshot().")]]
inline CommandListState* GetCurrentState(reshade::api::command_list* cmd_list) {
  auto snapshot = GetSnapshot(cmd_list);
  if (!snapshot.has_value()) return nullptr;

  thread_local CommandListState compatibility_state;
  std::visit([&](const auto& state) {
    compatibility_state.render_targets.assign(state.render_targets.begin(), state.render_targets.end());
    compatibility_state.depth_stencil = state.depth_stencil;
    if (state.UsesFixedRasterLists()) {
      compatibility_state.viewports.clear();
      for (const auto& viewport : state.fixed_viewports.values()) {
        compatibility_state.viewports.push_back(viewport);
      }
      compatibility_state.scissor_rects.clear();
      for (const auto& rect : state.fixed_scissor_rects.values()) {
        compatibility_state.scissor_rects.push_back(rect);
      }
    } else {
      compatibility_state.viewports.assign(state.viewports.begin(), state.viewports.end());
      compatibility_state.scissor_rects.assign(state.scissor_rects.begin(), state.scissor_rects.end());
    }
    compatibility_state.graphics_pipeline_layout = state.graphics_pipeline_layout;
    compatibility_state.compute_pipeline_layout = state.compute_pipeline_layout;
    if (const auto found = state.dynamic_states.find(
            reshade::api::dynamic_state::primitive_topology);
        found != state.dynamic_states.end()) {
      compatibility_state.primitive_topology = static_cast<reshade::api::primitive_topology>(found->second);
    } else {
      compatibility_state.primitive_topology = reshade::api::primitive_topology::undefined;
    }
    const auto materialize_dynamic_state = [&](reshade::api::dynamic_state dynamic_state,
                                               uint32_t default_value,
                                               uint32_t* value) {
      const auto found = state.dynamic_states.find(dynamic_state);
      *value = (found != state.dynamic_states.end() ? found->second : default_value);
    };
    materialize_dynamic_state(
        reshade::api::dynamic_state::blend_constant,
        0u,
        &compatibility_state.blend_constant);
    materialize_dynamic_state(
        reshade::api::dynamic_state::sample_mask,
        0xFFFFFFFFu,
        &compatibility_state.sample_mask);
    materialize_dynamic_state(
        reshade::api::dynamic_state::front_stencil_reference_value,
        0u,
        &compatibility_state.front_stencil_reference_value);
    materialize_dynamic_state(
        reshade::api::dynamic_state::back_stencil_reference_value,
        0u,
        &compatibility_state.back_stencil_reference_value);
    compatibility_state.pipelines.clear();
    state.ForEachPipelineBind(PipelineBindPoint::UNKNOWN, [&](const PipelineBind& bind) {
      compatibility_state.pipelines.insert_or_assign(bind.stages, bind.pipeline);
    });
    compatibility_state.descriptor_tables.clear();
    const auto materialize_descriptor_tables = [&](reshade::api::shader_stage stages,
                                                   reshade::api::pipeline_layout layout,
                                                   const auto& tables,
                                                   bool known,
                                                   std::vector<reshade::api::descriptor_table>* output) {
      std::vector<reshade::api::descriptor_table> compatibility_tables;
      for (const auto& [index, table] : tables.entries()) {
        compatibility_tables.resize(index + 1u);
        compatibility_tables[index] = table;
      }
      if (output != nullptr) {
        *output = compatibility_tables;
      }
      if (!known) return;
      compatibility_state.descriptor_tables.insert_or_assign(
          stages,
          std::pair{layout, std::move(compatibility_tables)});
    };
    materialize_descriptor_tables(
        reshade::api::shader_stage::all_graphics,
        state.graphics_pipeline_layout,
        state.graphics_descriptor_tables,
        state.graphics_descriptor_tables_known,
        &compatibility_state.graphics_descriptor_tables);
    materialize_descriptor_tables(
        reshade::api::shader_stage::all_compute,
        state.compute_pipeline_layout,
        state.compute_descriptor_tables,
        state.compute_descriptor_tables_known,
        &compatibility_state.compute_descriptor_tables);
    materialize_descriptor_tables(
        reshade::api::shader_stage::all_ray_tracing,
        state.ray_tracing_pipeline_layout,
        state.ray_tracing_descriptor_tables,
        state.ray_tracing_descriptor_tables_known,
        nullptr);
  },
             snapshot->state);
  return &compatibility_state;
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      attached = true;
      if (use_snapshot || use_pipeline_tracking) {
        renodx::utils::pipeline::EnableShaderHashTracking();
      }
      renodx::utils::pipeline::Use(fdw_reason);
      if (use_snapshot || use_push_constants || use_push_descriptors || use_descriptor_tables) {
        renodx::utils::pipeline_layout::Use(fdw_reason);
      }
      if (shared.RegisterModule([](SharedData& data) {
            data.use_snapshot |= use_snapshot;
            data.use_pipeline_tracking |= use_pipeline_tracking;
            data.use_render_target_tracking |= use_render_target_tracking;
            data.use_dynamic_state_tracking |= use_dynamic_state_tracking;
            data.use_viewport_scissor_tracking |= use_viewport_scissor_tracking;
            data.use_input_assembler_tracking |= use_input_assembler_tracking;
            data.use_push_constants |= use_push_constants;
            data.use_push_descriptors |= use_push_descriptors;
            data.use_descriptor_tables |= use_descriptor_tables;
          })) {
        reshade::log::message(reshade::log::level::info, "State attached.");
      }
      shared.RegisterEvent<reshade::addon_event::init_command_list>(OnInitCommandList);
      shared.RegisterEvent<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      shared.RegisterEvent<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil, use_snapshot || use_render_target_tracking);
      shared.RegisterEvent<reshade::addon_event::begin_render_pass>(OnBeginRenderPass, use_snapshot || use_render_target_tracking);
      shared.RegisterEvent<reshade::addon_event::end_render_pass>(OnEndRenderPass, use_snapshot || use_render_target_tracking);
      shared.RegisterEvent<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates, use_snapshot || use_dynamic_state_tracking);
      shared.RegisterEvent<reshade::addon_event::bind_viewports>(OnBindViewports, use_snapshot || use_viewport_scissor_tracking);
      shared.RegisterEvent<reshade::addon_event::bind_scissor_rects>(OnBindScissorRects, use_snapshot || use_viewport_scissor_tracking);
      // ReShade 6.8 allocates broken D3D9 Draw-UP buffers when either input-
      // assembler event has any subscribers. D3D9 snapshots use native getters,
      // so avoid registering the events at all on that backend.
      wchar_t reshade_module_path[MAX_PATH] = L"";
      GetModuleFileNameW(
          reshade::internal::get_reshade_module_handle(),
          reshade_module_path,
          ARRAYSIZE(reshade_module_path));
      vertex_and_index_buffer_events_registered =
          _wcsicmp(std::filesystem::path(reshade_module_path).filename().c_str(), L"d3d9.dll") != 0;
      if (vertex_and_index_buffer_events_registered) {
        shared.RegisterEvent<reshade::addon_event::bind_vertex_buffers>(OnBindVertexBuffers, use_snapshot || use_input_assembler_tracking);
        shared.RegisterEvent<reshade::addon_event::bind_index_buffer>(OnBindIndexBuffer, use_snapshot || use_input_assembler_tracking);
      }
      shared.RegisterEvent<reshade::addon_event::push_constants>(OnPushConstants, use_snapshot || use_push_constants);
      shared.RegisterEvent<reshade::addon_event::push_descriptors>(OnPushDescriptors, use_snapshot || use_push_descriptors);
      shared.RegisterEvent<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables,
                                                                         use_snapshot || use_descriptor_tables || use_push_constants || use_push_descriptors);
      shared.RegisterEvent<reshade::addon_event::reset_command_list>(OnResetCommandList);
      pipeline::RegisterOnBindCallback(OnBindPipeline, use_snapshot || use_pipeline_tracking);

      break;
    }
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      pipeline::UnregisterOnBindCallback(OnBindPipeline);
      shared.UnregisterEvent<reshade::addon_event::init_command_list>(OnInitCommandList);
      shared.UnregisterEvent<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      shared.UnregisterEvent<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      shared.UnregisterEvent<reshade::addon_event::begin_render_pass>(OnBeginRenderPass);
      shared.UnregisterEvent<reshade::addon_event::end_render_pass>(OnEndRenderPass);
      shared.UnregisterEvent<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
      shared.UnregisterEvent<reshade::addon_event::bind_viewports>(OnBindViewports);
      shared.UnregisterEvent<reshade::addon_event::bind_scissor_rects>(OnBindScissorRects);
      if (vertex_and_index_buffer_events_registered) {
        shared.UnregisterEvent<reshade::addon_event::bind_vertex_buffers>(OnBindVertexBuffers);
        shared.UnregisterEvent<reshade::addon_event::bind_index_buffer>(OnBindIndexBuffer);
        vertex_and_index_buffer_events_registered = false;
      }
      shared.UnregisterEvent<reshade::addon_event::push_constants>(OnPushConstants);
      shared.UnregisterEvent<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      shared.UnregisterEvent<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      shared.UnregisterEvent<reshade::addon_event::reset_command_list>(OnResetCommandList);
      shared.UnregisterModule();
      if (use_snapshot || use_push_constants || use_push_descriptors || use_descriptor_tables) {
        renodx::utils::pipeline_layout::Use(fdw_reason);
      }
      renodx::utils::pipeline::Use(fdw_reason);

      break;
  }
}

}  // namespace renodx::utils::state
