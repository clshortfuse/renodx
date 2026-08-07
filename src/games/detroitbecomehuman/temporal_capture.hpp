/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <atomic>
#include <cstddef>
#include <cstdint>
#include <format>
#include <limits>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <Windows.h>

#include <include/reshade.hpp>

#include "../../utils/command_action.hpp"
#include "../../utils/data.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/pipeline_layout.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/state.hpp"
#include "dlss_bridge_client.hpp"
#include "supported_build.hpp"
#include "taa_contract.hpp"

namespace renodx::games::detroitbecomehuman::temporal_capture {

inline constexpr std::array<std::uint32_t, DETROIT_DLSS_TAA_SAMPLED_BINDING_COUNT>
    kSampledBindings = {0u, 1u, 2u, 3u, 4u, 5u, 6u, 7u, 9u};
inline constexpr std::array<std::uint32_t, DETROIT_DLSS_TAA_STORAGE_BINDING_COUNT>
    kStorageBindings = {16u, 17u, 18u, 19u};
inline constexpr std::array<std::string_view, kSampledBindings.size()>
    kSampledLabels = {
        "PrevAADepth",
        "CurrColor",
        "PrevColor",
        "CurrDepth",
        "MotionVectors",
        "AvgLuminance",
        "Flags",
        "PrevSpeedFlags",
        "Optional9",
};
inline constexpr std::array<std::string_view, kStorageBindings.size()>
    kStorageLabels = {
        "OutColorPass",
        "OutAADepth",
        "OutSpeedFlags",
        "OutContourHistory",
};
// SPIR-V reflection of the exact 37,236-byte 0xB5506A45 module proves the
// declared block size. A live snapshot is still required to prove the bound
// range, dynamic offset, payload and field meanings for the current dispatch.
inline constexpr std::uint64_t kReflectedTemporalConstantsSize = 496u;

// The exact SPIR-V establishes these semantics independent of frame state.
// Descriptor/layout, constants, jitter, dimensions, exposure policy and
// history are still enabled only after their current-frame checks pass below.
inline constexpr DetroitDlssVerificationFlags kStaticTemporalSemantics =
    DETROIT_DLSS_VERIFY_RESOURCE_SEMANTICS
    | DETROIT_DLSS_VERIFY_DEPTH_CONVENTION
    | DETROIT_DLSS_VERIFY_MOTION_VECTOR_DIRECTION_AND_SCALE
    | DETROIT_DLSS_VERIFY_MOTION_VECTORS_INCLUDE_CAMERA
    | DETROIT_DLSS_VERIFY_CURRENT_COLOR_IS_UI_FREE;

// Vulkan enum values observed and statically tied to the exact TAA interface.
inline constexpr std::uint32_t kVkFormatRg16Float = 83u;
inline constexpr std::uint32_t kVkFormatRgba16Float = 97u;
inline constexpr std::uint32_t kVkFormatR32Uint = 98u;
inline constexpr std::uint32_t kVkFormatRgb9e5 = 123u;
inline constexpr std::uint32_t kVkFormatD32FloatS8Uint = 130u;
inline constexpr std::uint32_t kVkImageLayoutGeneral = 1u;
inline constexpr std::uint32_t kVkImageLayoutShaderReadOnly = 5u;

enum class RuntimeStatus : std::uint32_t {
  kNative = 0u,
  kWaitingForDispatch,
  kDescriptorContractIncomplete,
  kTemporalContractUnverified,
  kSuperResolutionScaleUnavailable,
  kBridgeFallback,
  kDlssActive,
};

struct ResolvedSlot {
  reshade::api::descriptor_type type = reshade::api::descriptor_type::sampler;
  reshade::api::resource_view view = {0u};
  reshade::api::buffer_range buffer = {};
  reshade::api::descriptor_table table = {0u};
  std::uint32_t set_index = std::numeric_limits<std::uint32_t>::max();
  bool found = false;
};

struct ResolvedBindings {
  std::array<ResolvedSlot, kSampledBindings.size()> sampled = {};
  std::array<ResolvedSlot, kStorageBindings.size()> storage = {};
  ResolvedSlot constants = {};
  std::uint32_t constants_descriptor_type = 0u;
};

struct CapturedImage {
  std::uint64_t image = 0u;
  std::uint64_t image_view = 0u;
  std::uint32_t format = 0u;
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;
  std::uint32_t mip_level = 0u;
  std::uint32_t array_layer = 0u;
  std::uint32_t layout = 0u;
  bool valid = false;
};

struct ImageShape {
  std::uint32_t format = 0u;
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;
  std::uint32_t mip_level = 0u;
  std::uint32_t array_layer = 0u;
  std::uint32_t layout = 0u;

  bool operator==(const ImageShape&) const = default;
};

struct ContractShape {
  std::uint64_t pipeline_layout = 0u;
  std::array<ImageShape, kSampledBindings.size()> sampled = {};
  std::array<ImageShape, kStorageBindings.size()> storage = {};
  std::uint64_t constants_size = 0u;
  std::uint32_t constants_descriptor_type = 0u;

  bool operator==(const ContractShape&) const = default;
};

inline std::atomic<DetroitDlssMode> selected_mode = DETROIT_DLSS_MODE_NATIVE;
inline std::atomic<RuntimeStatus> runtime_status = RuntimeStatus::kNative;
// Multiple Vulkan frames may be recorded concurrently. Associate the valid
// DLSS result with the exact native command list that later records final CAS;
// a process-global frame boolean can suppress CAS on the wrong in-flight frame.
inline std::mutex dlss_output_mutex;
inline std::unordered_map<std::uint64_t, bool> dlss_output_by_command_list;
// Detroit records the main view and auxiliary full-resolution temporal passes
// into different Vulkan command buffers. Applying NGX to every matching TAA
// dispatch permanently pins one ~100 MiB scratch bundle to each reusable
// command buffer. Learn the command buffers that also record the verified
// scene composite, and run DLSS only on that main-view set.
inline std::shared_mutex main_temporal_command_list_mutex;
inline std::unordered_set<std::uint64_t> main_temporal_command_lists;
inline thread_local std::uint64_t latest_temporal_command_list = 0u;
inline thread_local std::uint64_t latest_temporal_dispatch_serial = 0u;
inline std::atomic_uint64_t frame_counter = 0u;
inline std::atomic_uint64_t evaluation_serial = 0u;
inline std::atomic_uint64_t sr_preflight_serial = 0u;
static_assert(std::atomic_uint64_t::is_always_lock_free);
inline std::mutex contract_mutex;
inline ContractShape last_contract_shape = {};
inline bool has_logged_contract = false;
inline bool has_logged_native_snapshot_failure = false;
inline constexpr std::uint64_t kUnloggedTelemetryKey =
    std::numeric_limits<std::uint64_t>::max();
inline std::atomic_uint64_t last_logged_dlss_success_key =
    kUnloggedTelemetryKey;
inline std::atomic_uint64_t last_logged_evaluation_key =
    kUnloggedTelemetryKey;

[[nodiscard]] inline std::uint64_t MixTelemetryKey(
    std::uint64_t key,
    std::uint64_t value) {
  // FNV-1a over fixed-width runtime values is sufficient for log deduplication;
  // it is deliberately unrelated to any render-path or ABI decision.
  constexpr std::uint64_t kFnvPrime = 1099511628211ull;
  for (std::uint32_t byte = 0u; byte < sizeof(value); ++byte) {
    key ^= value & 0xFFu;
    key *= kFnvPrime;
    value >>= 8u;
  }
  return key;
}

template <typename... Values>
[[nodiscard]] inline std::uint64_t MakeTelemetryKey(Values... values) {
  std::uint64_t key = 14695981039346656037ull;
  ((key = MixTelemetryKey(key, static_cast<std::uint64_t>(values))), ...);
  return key == kUnloggedTelemetryKey ? key - 1u : key;
}

inline void Log(reshade::log::level level, const std::string& message) {
  reshade::log::message(level, ("Detroit DLSS capture: " + message).c_str());
}

inline void ObserveTemporalCommandList(
    std::uint64_t command_list, std::uint64_t dispatch_serial) noexcept {
  latest_temporal_command_list = command_list;
  latest_temporal_dispatch_serial = dispatch_serial;
}

inline void MarkMainTemporalCommandList(std::uint64_t command_list) {
  if (command_list == 0u || latest_temporal_command_list != command_list
      || latest_temporal_dispatch_serial == 0u) {
    return;
  }
  latest_temporal_command_list = 0u;
  latest_temporal_dispatch_serial = 0u;

  bool inserted = false;
  std::size_t learned_count = 0u;
  {
    std::unique_lock lock(main_temporal_command_list_mutex);
    inserted = main_temporal_command_lists.insert(command_list).second;
    learned_count = main_temporal_command_lists.size();
  }
  if (inserted) {
    Log(
        reshade::log::level::info,
        std::format(
            "learned main-view temporal command list 0x{:X} ({} total); auxiliary TAA command lists remain native.",
            command_list,
            learned_count));
  }
}

[[nodiscard]] inline bool IsMainTemporalCommandList(
    std::uint64_t command_list) {
  if (command_list == 0u) return false;
  std::shared_lock lock(main_temporal_command_list_mutex);
  return main_temporal_command_lists.contains(command_list);
}

[[nodiscard]] inline RuntimeStatus GetStatus() {
  return runtime_status.load(std::memory_order_relaxed);
}

[[nodiscard]] inline DetroitDlssMode GetMode() {
  return selected_mode.load(std::memory_order_relaxed);
}

[[nodiscard]] inline std::uint64_t GetEvaluationSerial() {
  return evaluation_serial.load(std::memory_order_acquire);
}

[[nodiscard]] inline std::uint64_t GetSrPreflightSerial() {
  return sr_preflight_serial.load(std::memory_order_acquire);
}

inline void SetMode(DetroitDlssMode mode) {
  if (mode > DETROIT_DLSS_MODE_PERFORMANCE) mode = DETROIT_DLSS_MODE_NATIVE;
  const auto previous = selected_mode.exchange(mode, std::memory_order_acq_rel);
  if (mode == DETROIT_DLSS_MODE_NATIVE
      && previous != DETROIT_DLSS_MODE_NATIVE) {
    (void)dlss_bridge_client::client.TransitionToNative();
  }
  if (mode == DETROIT_DLSS_MODE_NATIVE) {
    runtime_status.store(RuntimeStatus::kNative, std::memory_order_relaxed);
  } else if (dlss_policy::IsSuperResolutionMode(mode)) {
    runtime_status.store(
        RuntimeStatus::kSuperResolutionScaleUnavailable,
        std::memory_order_relaxed);
  } else {
    runtime_status.store(RuntimeStatus::kWaitingForDispatch, std::memory_order_relaxed);
  }
}

inline void BeginNextFrame() {
  SetMode(selected_mode.load(std::memory_order_relaxed));
}

inline void RecordDlssOutputForCommandList(
    std::uint64_t command_list,
    bool output_valid) {
  if (command_list == 0u) return;
  std::scoped_lock lock(dlss_output_mutex);
  if (output_valid) {
    dlss_output_by_command_list[command_list] = true;
  } else {
    dlss_output_by_command_list.erase(command_list);
  }
}

[[nodiscard]] inline bool QueryDlssOutputForCommandList(
    std::uint64_t command_list) {
  if (command_list == 0u) return false;
  std::scoped_lock lock(dlss_output_mutex);
  const auto found = dlss_output_by_command_list.find(command_list);
  if (found == dlss_output_by_command_list.end()) return false;
  return found->second;
}

[[nodiscard]] inline bool ConsumeDlssOutputForCommandList(
    std::uint64_t command_list) {
  // A frame may execute more than one final-CAS dispatch on the same command
  // buffer. Keep the successful state until the next TAA dispatch explicitly
  // clears it through RecordDlssOutputForCommandList(..., false).
  return QueryDlssOutputForCommandList(command_list);
}

[[nodiscard]] inline bool RangeContainsBinding(
    const reshade::api::descriptor_range& range,
    std::uint32_t binding) {
  if (binding < range.binding || range.count == 0u) return false;
  const auto relative_binding = binding - range.binding;
  return range.count == std::numeric_limits<std::uint32_t>::max()
         || relative_binding < range.count;
}

inline void ResolveRange(
    reshade::api::device* device,
    renodx::utils::descriptor::DeviceData* descriptor_data,
    const reshade::api::descriptor_table table,
    std::uint32_t set_index,
    const reshade::api::descriptor_range& range,
    ResolvedBindings* output) {
  if (table.handle == 0u || range.count == 0u) return;
  if ((static_cast<std::uint32_t>(range.visibility)
       & static_cast<std::uint32_t>(reshade::api::shader_stage::compute))
      == 0u) {
    return;
  }

  const auto resolve = [&](std::uint32_t binding, ResolvedSlot* destination) {
    if (destination->found || !RangeContainsBinding(range, binding)) return;

    reshade::api::descriptor_heap heap = {0u};
    std::uint32_t offset = 0u;
    device->get_descriptor_heap_offset(table, binding, 0u, &heap, &offset);
    if (heap.handle == 0u) return;

    const std::shared_lock descriptor_lock(descriptor_data->mutex);
    const auto heap_it = descriptor_data->heaps.find(heap.handle);
    if (heap_it == descriptor_data->heaps.end() || offset >= heap_it->second.size()) {
      return;
    }
    const auto& slot = heap_it->second[offset];
    destination->type = slot.type;
    destination->table = table;
    destination->set_index = set_index;
    const auto range_type = static_cast<std::uint32_t>(range.type);
    if (range_type == static_cast<std::uint32_t>(reshade::api::descriptor_type::constant_buffer)
        || range_type == 8u) {
      if (static_cast<std::uint32_t>(slot.type) != range_type
          || slot.buffer_range.buffer.handle == 0u) {
        return;
      }
      destination->buffer = slot.buffer_range;
    } else {
      if (!slot.HasResourceView() || slot.resource_view.handle == 0u) return;
      destination->view = slot.resource_view;
    }
    destination->found = true;
  };

  if (range.type == reshade::api::descriptor_type::shader_resource_view
      || range.type == reshade::api::descriptor_type::sampler_with_resource_view) {
    for (std::size_t index = 0u; index < kSampledBindings.size(); ++index) {
      resolve(kSampledBindings[index], &output->sampled[index]);
    }
  } else if (range.type == reshade::api::descriptor_type::unordered_access_view) {
    for (std::size_t index = 0u; index < kStorageBindings.size(); ++index) {
      resolve(kStorageBindings[index], &output->storage[index]);
    }
  } else if (static_cast<std::uint32_t>(range.type)
                 == static_cast<std::uint32_t>(
                     reshade::api::descriptor_type::constant_buffer)
             || static_cast<std::uint32_t>(range.type) == 8u) {
    if (RangeContainsBinding(
            range, DETROIT_DLSS_TAA_CONSTANT_BINDING_52)) {
      output->constants_descriptor_type =
          static_cast<std::uint32_t>(range.type);
    }
    resolve(DETROIT_DLSS_TAA_CONSTANT_BINDING_52, &output->constants);
  }
}

[[nodiscard]] inline bool ResolveObservedBindings(
    reshade::api::device* device,
    const reshade::api::pipeline_layout layout,
    const std::vector<reshade::api::descriptor_table>& bound_tables,
    ResolvedBindings* output) {
  auto* descriptor_data =
      renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
  if (descriptor_data == nullptr) return false;

  return renodx::utils::pipeline_layout::GetPipelineLayoutData(
      layout,
      [&](const renodx::utils::pipeline_layout::PipelineLayoutData* layout_data) {
        const auto set_index = DETROIT_DLSS_TAA_DESCRIPTOR_SET;
        if (set_index >= layout_data->params.size()
            || set_index >= bound_tables.size()) {
          return;
        }

        const auto& param = layout_data->params[set_index];
        const auto table = bound_tables[set_index];
        switch (param.type) {
          case reshade::api::pipeline_layout_param_type::descriptor_table:
            for (std::uint32_t index = 0u;
                 index < param.descriptor_table.count;
                 ++index) {
              ResolveRange(
                  device,
                  descriptor_data,
                  table,
                  set_index,
                  param.descriptor_table.ranges[index],
                  output);
            }
            break;
          case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
            for (std::uint32_t index = 0u;
                 index < param.descriptor_table_with_static_samplers.count;
                 ++index) {
              ResolveRange(
                  device,
                  descriptor_data,
                  table,
                  set_index,
                  param.descriptor_table_with_static_samplers.ranges[index],
                  output);
            }
            break;
          default:
            break;
        }
      });
}

[[nodiscard]] inline CapturedImage CaptureImage(
    reshade::api::device* device,
    const ResolvedSlot& slot) {
  if (!slot.found || slot.view.handle == 0u) return {};

  const auto resource = device->get_resource_from_view(slot.view);
  if (resource.handle == 0u) return {};

  return {
      .image = resource.handle,
      .image_view = slot.view.handle,
      .valid = true,
  };
}

[[nodiscard]] inline const DetroitDlssImageBindingSnapshot* FindNativeImage(
    const DetroitDlssTemporalDescriptorSnapshot& snapshot,
    std::uint32_t binding) {
  for (std::uint32_t index = 0u;
       index < snapshot.image_binding_count
       && index < DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT;
       ++index) {
    if (snapshot.images[index].binding == binding) return &snapshot.images[index];
  }
  return nullptr;
}

[[nodiscard]] inline bool ApplyNativeImage(
    const DetroitDlssTemporalDescriptorSnapshot& snapshot,
    std::uint32_t binding,
    CapturedImage* image) {
  const auto* native = FindNativeImage(snapshot, binding);
  if (native == nullptr || image == nullptr) return false;
  const bool reshade_binding_present = image->image != 0u || image->image_view != 0u;
  if (reshade_binding_present
      && (image->image != native->resource.image
          || image->image_view != native->resource.image_view)) {
    return false;
  }
  if ((native->valid_flags & DETROIT_DLSS_IMAGE_MANDATORY_MASK)
          != DETROIT_DLSS_IMAGE_MANDATORY_MASK
      || native->resource.image == 0u
      || native->resource.image_view == 0u) {
    return !reshade_binding_present
           && (DETROIT_DLSS_TAA_OPTIONAL_IMAGE_MASK & (UINT64_C(1) << binding)) != 0u;
  }

  *image = {
      .image = native->resource.image,
      .image_view = native->resource.image_view,
      .format = native->resource.format,
      .width = native->resource.width,
      .height = native->resource.height,
      .mip_level = native->resource.mip_level,
      .array_layer = native->resource.array_layer,
      .layout = native->resource.layout,
      .valid = true,
  };
  return true;
}

[[nodiscard]] inline DetroitDlssResource ToResource(const CapturedImage& image) {
  return {
      .image = image.image,
      .image_view = image.image_view,
      .format = image.format,
      .layout = image.layout,
      .width = image.width,
      .height = image.height,
      .mip_level = image.mip_level,
      .array_layer = image.array_layer,
  };
}

[[nodiscard]] inline ImageShape GetShape(const CapturedImage& image) {
  return {
      .format = image.format,
      .width = image.width,
      .height = image.height,
      .mip_level = image.mip_level,
      .array_layer = image.array_layer,
      .layout = image.layout,
  };
}

inline void LogContract(
    const renodx::utils::command_action::DispatchArguments& dispatch,
    std::uint64_t pipeline_layout,
    std::uint64_t descriptor_set,
    const std::array<CapturedImage, kSampledBindings.size()>& sampled,
    const std::array<CapturedImage, kStorageBindings.size()>& storage,
    const DetroitDlssTemporalConstantsSnapshot* constants,
    const DetroitDlssTemporalConstantsDiagnostics* constants_diagnostics,
    std::uint32_t observed_constants_descriptor_type) {
  Log(
      reshade::log::level::info,
      std::format(
          "TAA 0x{:08X}: dispatch {}x{}x{}, VkPipelineLayout=0x{:X}, set0=0x{:X}.",
          supported_build::kTemporalAaShaderCrc,
          dispatch.group_count_x,
          dispatch.group_count_y,
          dispatch.group_count_z,
          pipeline_layout,
          descriptor_set));

  std::string sampled_text = "sampled";
  for (std::size_t index = 0u; index < sampled.size(); ++index) {
    sampled_text += std::format(
        " b{} {}=[img 0x{:X}, view 0x{:X}, VkFormat {}, {}x{}, mip {}, layout {}]",
        kSampledBindings[index],
        kSampledLabels[index],
        sampled[index].image,
        sampled[index].image_view,
        sampled[index].format,
        sampled[index].width,
        sampled[index].height,
        sampled[index].mip_level,
        sampled[index].layout);
  }
  Log(reshade::log::level::info, sampled_text + ".");

  std::string storage_text = "storage";
  for (std::size_t index = 0u; index < storage.size(); ++index) {
    storage_text += std::format(
        " b{} {}=[img 0x{:X}, view 0x{:X}, VkFormat {}, {}x{}, mip {}, layout {}]",
        kStorageBindings[index],
        kStorageLabels[index],
        storage[index].image,
        storage[index].image_view,
        storage[index].format,
        storage[index].width,
        storage[index].height,
        storage[index].mip_level,
        storage[index].layout);
  }
  if (constants == nullptr) {
    storage_text += std::format(
        " b52=[layer snapshot unavailable, layout descriptor type {}].",
        observed_constants_descriptor_type);
  } else {
    std::uint64_t payload_hash = UINT64_C(14695981039346656037);
    for (std::uint32_t index = 0u; index < constants->bytes_written; ++index) {
      payload_hash ^= constants->constants[index];
      payload_hash *= UINT64_C(1099511628211);
    }
    storage_text += std::format(
        " b52=[buffer 0x{:X}, descriptor offset {}, dynamic offset {}, effective offset {}, range {}, payload {}, reflected size {}, FNV1a 0x{:X}, descriptor type {}, valid 0x{:X}, source 0x{:X}].",
        constants->buffer,
        constants->descriptor_offset,
        constants->dynamic_offset,
        constants->effective_offset,
        constants->descriptor_range,
        constants->bytes_written,
        kReflectedTemporalConstantsSize,
        payload_hash,
        constants->descriptor_type,
        constants->valid_flags,
        constants->source_flags);
    if (constants_diagnostics != nullptr) {
      storage_text += std::format(
          " diagnostics=[detail {}, buffer size {}, usage 0x{:X}, allocation {}, memory flags 0x{:X}, mapped {}+{}, required {}, descriptor source 0x{:X}, update {}].",
          constants_diagnostics->detail_code,
          constants_diagnostics->buffer_size,
          constants_diagnostics->buffer_usage,
          constants_diagnostics->allocation_size,
          constants_diagnostics->memory_property_flags,
          constants_diagnostics->mapped_offset,
          constants_diagnostics->mapped_size,
          constants_diagnostics->required_payload_size,
          constants_diagnostics->descriptor_source_flags,
          constants_diagnostics->descriptor_update_serial);
    }

    if (constants->bytes_written >= taa_contract::kConstantsSize) {
      const auto bytes = std::as_bytes(std::span(constants->constants))
                             .first(taa_contract::kConstantsSize);
      const auto decoded = taa_contract::DecodeConstants(bytes);
      if (decoded.has_value()) {
        const auto& taa = decoded->raw;
        storage_text += std::format(
            " decoded=[renderTarget {:.3f}x{:.3f} inv {:.9f},{:.9f}; "
            "src {:.3f}x{:.3f} inv {:.9f},{:.9f}; viewport origin {},{} "
            "size {}x{}; jitter {:.9f},{:.9f}; upsample {:.6f} inv {:.6f} "
            "prev {:.6f}; exposure min {:.9f} prevComp {:.9f}; history "
            "{:.6f}; reset/debug frame {}; plausible finite={} size={} scale={}].",
            taa.render_target_size_inv.x,
            taa.render_target_size_inv.y,
            taa.render_target_size_inv.z,
            taa.render_target_size_inv.w,
            taa.src_texture_size_inv.x,
            taa.src_texture_size_inv.y,
            taa.src_texture_size_inv.z,
            taa.src_texture_size_inv.w,
            taa.viewport_origin_size.x,
            taa.viewport_origin_size.y,
            taa.viewport_origin_size.z,
            taa.viewport_origin_size.w,
            taa.jitter_x,
            taa.jitter_y,
            taa.upsampling,
            taa.inv_upsampling,
            taa.prev_upsampling,
            taa.min_exposure,
            taa.prev_exposure_comp,
            taa.history,
            taa.debug_frame,
            decoded->plausibility.all_float_candidates_finite,
            decoded->plausibility.size_candidates_positive,
            decoded->plausibility.scale_candidates_positive);
      }
    }
  }
  Log(reshade::log::level::info, storage_text);
  Log(
      reshade::log::level::info,
      "native TAA was preserved for its auxiliary history outputs; the current frame still has to pass every DLSS contract check before b16 may be replaced.");
}

inline void AfterNativeTemporalDispatch(
    renodx::utils::command_action::CommandContext<
        renodx::utils::command_action::DispatchArguments>& context,
    const void*) {
  if (context.cmd_list == nullptr) return;
  const auto dispatch_serial =
      evaluation_serial.fetch_add(1u, std::memory_order_acq_rel) + 1u;
  ObserveTemporalCommandList(
      context.cmd_list->get_native(), dispatch_serial);
  // A later temporal dispatch in the same presented frame supersedes an
  // earlier result. Re-arm CAS until this dispatch independently succeeds.
  RecordDlssOutputForCommandList(context.cmd_list->get_native(), false);
  auto* device = context.cmd_list->get_device();
  if (device == nullptr || device->get_api() != reshade::api::device_api::vulkan) {
    return;
  }

  DetroitDlssTemporalDescriptorSnapshot temporal_snapshot = {};
  const bool has_temporal_snapshot =
      dlss_bridge_client::client.CaptureTemporalSnapshot(
          context.cmd_list->get_native(),
          0u,
          0u,
          &temporal_snapshot);
  const bool has_temporal_diagnostics =
      temporal_snapshot.struct_size >= sizeof(temporal_snapshot)
      && temporal_snapshot.abi_version == DETROIT_DLSS_ABI_VERSION
      && temporal_snapshot.command_buffer == context.cmd_list->get_native()
      && temporal_snapshot.image_binding_count == DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT;
  constexpr DetroitDlssTemporalSnapshotFlags kNativeImageSnapshotFlags =
      DETROIT_DLSS_SNAPSHOT_COMMAND_TRACKED
      | DETROIT_DLSS_SNAPSHOT_SET_BOUND
      | DETROIT_DLSS_SNAPSHOT_EXPECTED_SET_MATCH
      | DETROIT_DLSS_SNAPSHOT_EXPECTED_PIPELINE_LAYOUT_MATCH
      | DETROIT_DLSS_SNAPSHOT_DESCRIPTOR_SET_TRACKED
      | DETROIT_DLSS_SNAPSHOT_PIPELINE_LAYOUT_TRACKED
      | DETROIT_DLSS_SNAPSHOT_REQUIRED_IMAGES_COMPLETE;
  bool native_images_match = has_temporal_snapshot
                             && has_temporal_diagnostics
                             && temporal_snapshot.descriptor_set != 0u
                             && temporal_snapshot.pipeline_layout != 0u
                             && (temporal_snapshot.snapshot_flags
                                 & kNativeImageSnapshotFlags)
                                    == kNativeImageSnapshotFlags
                             && (temporal_snapshot.complete_image_mask
                                 & DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK)
                                    == DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK;
  std::array<CapturedImage, kSampledBindings.size()> sampled = {};
  std::array<CapturedImage, kStorageBindings.size()> storage = {};
  if (native_images_match) {
    for (std::size_t index = 0u; index < sampled.size(); ++index) {
      native_images_match &= ApplyNativeImage(
          temporal_snapshot, kSampledBindings[index], &sampled[index]);
    }
    for (std::size_t index = 0u; index < storage.size(); ++index) {
      native_images_match &= ApplyNativeImage(
          temporal_snapshot, kStorageBindings[index], &storage[index]);
    }
  }
  if (!native_images_match) {
    std::scoped_lock lock(contract_mutex);
    if (!has_logged_native_snapshot_failure) {
      std::string image_flags;
      for (std::uint32_t index = 0u;
           index < temporal_snapshot.image_binding_count
           && index < DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT;
           ++index) {
        image_flags += std::format(
            " b{}=0x{:X}",
            temporal_snapshot.images[index].binding,
            temporal_snapshot.images[index].valid_flags);
      }
      Log(
          reshade::log::level::warning,
          std::format(
              "native descriptor snapshot incomplete (detail {}, flags 0x{:X}, present 0x{:X}, complete 0x{:X}, required 0x{:X}, valid:{}); native TAA remains active.",
              temporal_snapshot.detail_code,
              temporal_snapshot.snapshot_flags,
              temporal_snapshot.present_image_mask,
              temporal_snapshot.complete_image_mask,
              temporal_snapshot.required_image_mask,
              image_flags));
      has_logged_native_snapshot_failure = true;
    }
    runtime_status.store(
        RuntimeStatus::kDescriptorContractIncomplete,
        std::memory_order_relaxed);
    return;
  }

  const auto& constants_snapshot = temporal_snapshot.constants;
  const bool has_constants_snapshot = has_temporal_snapshot;
  const bool has_constants_diagnostics =
      constants_snapshot.struct_size >= sizeof(constants_snapshot)
      && constants_snapshot.abi_version == DETROIT_DLSS_ABI_VERSION
      && constants_snapshot.command_buffer == context.cmd_list->get_native();
  const auto constants_size = has_constants_snapshot
                                  ? constants_snapshot.descriptor_range
                                  : 0u;
  const auto constants_descriptor_type = has_constants_snapshot
                                             ? constants_snapshot.descriptor_type
                                             : 0u;

  const auto descriptor_set = temporal_snapshot.descriptor_set;
  const auto pipeline_layout = temporal_snapshot.pipeline_layout;

  ContractShape shape = {
      .pipeline_layout = pipeline_layout,
      .constants_size = constants_size,
      .constants_descriptor_type = constants_descriptor_type,
  };
  for (std::size_t index = 0u; index < sampled.size(); ++index) {
    shape.sampled[index] = GetShape(sampled[index]);
  }
  for (std::size_t index = 0u; index < storage.size(); ++index) {
    shape.storage[index] = GetShape(storage[index]);
  }

  {
    std::scoped_lock lock(contract_mutex);
    if (!has_logged_contract || shape != last_contract_shape) {
      LogContract(
          context.arguments,
          pipeline_layout,
          descriptor_set,
          sampled,
          storage,
          has_constants_diagnostics ? &constants_snapshot : nullptr,
          has_temporal_diagnostics
              ? &temporal_snapshot.constants_diagnostics
              : nullptr,
          constants_descriptor_type);
      last_contract_shape = shape;
      has_logged_contract = true;
    }
  }

  const auto mode = selected_mode.load(std::memory_order_relaxed);
  std::optional<taa_contract::DecodedConstants> decoded_constants;
  if ((constants_snapshot.valid_flags & DETROIT_DLSS_CONSTANTS_PAYLOAD_VALID) != 0u
      && constants_snapshot.bytes_written >= taa_contract::kConstantsSize) {
    const auto bytes = std::as_bytes(std::span(constants_snapshot.constants))
                           .first(taa_contract::kConstantsSize);
    decoded_constants = taa_contract::DecodeConstants(bytes);
  }

  const bool exact_resource_formats =
      sampled[1u].format == kVkFormatRgb9e5
      && sampled[3u].format == kVkFormatD32FloatS8Uint
      && sampled[4u].format == kVkFormatRg16Float
      && storage[0u].format == kVkFormatR32Uint;
  const bool exact_descriptor_layouts =
      sampled[1u].layout == kVkImageLayoutShaderReadOnly
      && sampled[3u].layout == kVkImageLayoutShaderReadOnly
      && sampled[4u].layout == kVkImageLayoutShaderReadOnly
      && storage[0u].layout == kVkImageLayoutGeneral;
  const bool exact_resource_extents =
      sampled[1u].width != 0u && sampled[1u].height != 0u
      && sampled[3u].width == sampled[1u].width
      && sampled[3u].height == sampled[1u].height
      && sampled[4u].width == sampled[1u].width
      && sampled[4u].height == sampled[1u].height
      && storage[0u].width != 0u && storage[0u].height != 0u;

  taa_contract::NgxFrameParameters frame_parameters = {};
  if (decoded_constants.has_value()) {
    frame_parameters = taa_contract::BuildNgxFrameParameters(
        decoded_constants->raw,
        sampled[1u].width,
        sampled[1u].height,
        storage[0u].width,
        storage[0u].height);
  }

  DetroitDlssVerificationFlags verification_flags = 0u;
  if (exact_resource_formats
      && supported_build::kTemporalInputsEmpiricallyVerified) {
    // The exact shader consumes the MV for previous-UV lookup, including
    // camera motion, before the later scene/HDR and UI passes execute.
    verification_flags |= kStaticTemporalSemantics;
  }
  if (exact_descriptor_layouts) {
    verification_flags |= DETROIT_DLSS_VERIFY_DESCRIPTOR_SET_AND_LAYOUTS;
  }
  if (decoded_constants.has_value() && frame_parameters.constants_valid) {
    verification_flags |= DETROIT_DLSS_VERIFY_CONSTANTS_DECODED;
  }
  if (frame_parameters.jitter_valid) {
    verification_flags |= DETROIT_DLSS_VERIFY_JITTER_DECODED;
  }
  if (exact_resource_formats) {
    // Detroit stores exposure in channel G, whereas NGX samples channel R.
    // NGX auto exposure is explicit, so b5 is diagnostic rather than a
    // required input and may have incomplete native descriptor metadata.
    verification_flags |= DETROIT_DLSS_VERIFY_EXPOSURE;
  }
  if (exact_resource_extents && frame_parameters.dimensions_valid
      && frame_parameters.viewport_valid && frame_parameters.scale_valid) {
    verification_flags |= DETROIT_DLSS_VERIFY_DIMENSIONS;
  }
  if (frame_parameters.history_valid) {
    verification_flags |= DETROIT_DLSS_VERIFY_HISTORY;
  }

  const bool native_history_resources_available =
      sampled[0u].valid && sampled[2u].valid && sampled[7u].valid;
  const bool is_main_temporal_command_list =
      IsMainTemporalCommandList(context.cmd_list->get_native());

  // The exact main-view command lists are learned from the later verified
  // scene composite. A newly seen list gets one native warm-up recording and
  // becomes eligible the next time Detroit records it. Auxiliary temporal
  // passes keep their native output and no longer consume persistent NGX
  // adapter scratch bundles.
  if (mode != DETROIT_DLSS_MODE_NATIVE
      && !is_main_temporal_command_list) {
    if (runtime_status.load(std::memory_order_relaxed)
        != RuntimeStatus::kDlssActive) {
      runtime_status.store(
          RuntimeStatus::kWaitingForDispatch,
          std::memory_order_relaxed);
    }
    return;
  }

  DetroitDlssTemporalFrameInputs inputs = {
      .struct_size = sizeof(DetroitDlssTemporalFrameInputs),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .shader_crc = supported_build::kTemporalAaShaderCrc,
      .descriptor_set_index = DETROIT_DLSS_TAA_DESCRIPTOR_SET,
      .command_buffer = context.cmd_list->get_native(),
      .descriptor_set = descriptor_set,
      .pipeline_layout = pipeline_layout,
      .constants_buffer = has_constants_snapshot ? constants_snapshot.buffer : 0u,
      .constants_offset = has_constants_snapshot
                              ? constants_snapshot.effective_offset
                              : 0u,
      .constants_size = has_constants_snapshot
                            ? constants_snapshot.descriptor_range
                            : 0u,
      .current_color = ToResource(sampled[1u]),
      .depth = ToResource(sampled[3u]),
      .motion_vectors = ToResource(sampled[4u]),
      .exposure = ToResource(sampled[5u]),
      .output = ToResource(storage[0u]),
      .render_width = sampled[1u].width,
      .render_height = sampled[1u].height,
      .output_width = storage[0u].width,
      .output_height = storage[0u].height,
      .jitter_x = frame_parameters.jitter_x,
      .jitter_y = frame_parameters.jitter_y,
      .motion_vector_scale_x = frame_parameters.motion_vector_scale.x,
      .motion_vector_scale_y = frame_parameters.motion_vector_scale.y,
      .pre_exposure = frame_parameters.pre_exposure,
      // NGX owns an independent temporal history, but missing native previous
      // outputs are a reliable scene-load/resource-recreation boundary. Reset
      // DLSS instead of seeding a new feature from an apparently stable 0.9
      // history scalar on that first frame.
      .reset = frame_parameters.reset || !native_history_resources_available,
      .frame_id = frame_counter.fetch_add(1u, std::memory_order_relaxed) + 1u,
      .flags = DETROIT_DLSS_FRAME_NATIVE_TAA_COMPLETED
               | DETROIT_DLSS_FRAME_ALLOW_AUTO_EXPOSURE,
      .verification_flags = verification_flags,
  };

  // This signal proves that the native-scale temporal pass is safe to use as
  // an SR scale-transition anchor. It intentionally precedes Evaluate: NGX's
  // queried SR extent is expected not to match while the game is still 1:1.
  const bool native_scale_preflight =
      taa_contract::IsNativeScaleExtent(
          inputs.render_width,
          inputs.render_height,
          inputs.output_width,
          inputs.output_height);
  if (dlss_policy::IsSuperResolutionMode(mode) && native_scale_preflight
      && (verification_flags & DETROIT_DLSS_VERIFY_MANDATORY_MASK)
             == DETROIT_DLSS_VERIFY_MANDATORY_MASK
      // IsValid also proves b52 render_target_size against the output extent
      // and src_texture_size/viewport against this 1:1 render extent.
      && frame_parameters.IsValid()) {
    sr_preflight_serial.store(dispatch_serial, std::memory_order_release);
  }

  const auto evaluation = dlss_bridge_client::client.Evaluate(mode, inputs);
  // The final CAS gate follows the latest temporal dispatch in this frame.
  // Never retain a successful earlier dispatch if a later one fell back to
  // Detroit's native b16 output.
  RecordDlssOutputForCommandList(
      inputs.command_buffer,
      evaluation.output_valid && evaluation.suppress_final_cas);
  if (evaluation.output_valid && evaluation.suppress_final_cas) {
    runtime_status.store(RuntimeStatus::kDlssActive, std::memory_order_relaxed);
    const auto success_key = MakeTelemetryKey(
        0x53554343455353ull,
        mode,
        inputs.render_width,
        inputs.render_height,
        inputs.output_width,
        inputs.output_height);
    if (last_logged_dlss_success_key.exchange(
            success_key,
            std::memory_order_acq_rel)
        != success_key) {
      Log(
          reshade::log::level::info,
          std::format(
              "DLSS produced a valid b16 replacement (mode {}, render {}x{}, output {}x{}, frame {}).",
              mode,
              inputs.render_width,
              inputs.render_height,
              inputs.output_width,
              inputs.output_height,
              inputs.frame_id));
    }
  } else if (mode == DETROIT_DLSS_MODE_NATIVE) {
    runtime_status.store(RuntimeStatus::kNative, std::memory_order_relaxed);
  } else if (evaluation.reason
             == dlss_policy::FallbackReason::kVerificationIncomplete) {
    runtime_status.store(
        RuntimeStatus::kTemporalContractUnverified,
        std::memory_order_relaxed);
  } else if (dlss_policy::IsSuperResolutionMode(mode)
             && (evaluation.reason
                     == dlss_policy::FallbackReason::kRenderScaleUnavailable
                 || evaluation.reason
                        == dlss_policy::FallbackReason::kInvalidModeSettings
                 || evaluation.reason == dlss_policy::FallbackReason::kExtentMismatch)) {
    runtime_status.store(
        RuntimeStatus::kSuperResolutionScaleUnavailable,
        std::memory_order_relaxed);
  } else {
    runtime_status.store(RuntimeStatus::kBridgeFallback, std::memory_order_relaxed);
  }
  if (mode != DETROIT_DLSS_MODE_NATIVE && !evaluation.output_valid) {
    const auto reason = static_cast<std::uint32_t>(evaluation.reason);
    const auto evaluation_key = MakeTelemetryKey(
        0x52454A454354ull,
        mode,
        reason,
        evaluation.bridge_detail,
        verification_flags,
        inputs.render_width,
        inputs.render_height,
        inputs.output_width,
        inputs.output_height);
    if (last_logged_evaluation_key.exchange(
            evaluation_key,
            std::memory_order_acq_rel)
        != evaluation_key) {
      Log(
          reshade::log::level::warning,
          std::format(
              "DLSS frame rejected safely (mode {}, reason {}, bridge detail 0x{:X}, verification 0x{:X}, render {}x{}, output {}x{}); native TAA b16 remains active.",
              mode,
              reason,
              evaluation.bridge_detail,
              verification_flags,
              inputs.render_width,
              inputs.render_height,
              inputs.output_width,
              inputs.output_height));
    }
  }
}

struct TemporalDispatchCallback {
  [[nodiscard]] renodx::utils::command_action::CallbackResult<
      renodx::utils::command_action::CommandContext<
          renodx::utils::command_action::DispatchArguments>>
  operator()(renodx::utils::command_action::CommandContext<
             renodx::utils::command_action::DispatchArguments>&) const {
    return {
        .post_callback = &AfterNativeTemporalDispatch,
        .replay = true,
    };
  }
};

inline constexpr TemporalDispatchCallback kTemporalDispatchCallback;

inline void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      {
        std::scoped_lock lock(dlss_output_mutex);
        dlss_output_by_command_list.clear();
      }
      {
        std::unique_lock lock(main_temporal_command_list_mutex);
        main_temporal_command_lists.clear();
      }
      last_logged_dlss_success_key.store(
          kUnloggedTelemetryKey,
          std::memory_order_relaxed);
      evaluation_serial.store(0u, std::memory_order_relaxed);
      sr_preflight_serial.store(0u, std::memory_order_relaxed);
      last_logged_evaluation_key.store(
          kUnloggedTelemetryKey,
          std::memory_order_relaxed);
      // The Vulkan layer already owns the authoritative descriptor snapshot.
      // Enabling RenoDX's global descriptor-table trace here makes every
      // descriptor update in the game take the diagnostic slow path.
      renodx::utils::command_action::Register(
          kTemporalDispatchCallback,
          {
              .shader_hash = supported_build::kTemporalAaShaderCrc,
              .command_types =
                  renodx::utils::command_action::COMMAND_TYPE_DISPATCH,
          });
      break;
    }
    case DLL_PROCESS_DETACH:
      renodx::utils::command_action::Unregister(kTemporalDispatchCallback);
      // The Vulkan layer owns NGX/Vulkan teardown at vkDestroyDevice. Do not
      // call its ABI while the Windows loader lock is held here.
      {
        std::scoped_lock lock(dlss_output_mutex);
        dlss_output_by_command_list.clear();
      }
      {
        std::unique_lock lock(main_temporal_command_list_mutex);
        main_temporal_command_lists.clear();
      }
      break;
  }
}

}  // namespace renodx::games::detroitbecomehuman::temporal_capture
