/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <atomic>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
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

#include "../../../utils/command_action.hpp"
#include "../../../utils/data.hpp"
#include "../../../utils/shader.hpp"
#include "dlss_bridge_client.hpp"
#include "embedded_bootstrap.hpp"
#include "../../detroitbecomehuman/supported_build.hpp"
#include "taa_contract.hpp"
#include "temporal_mode_state.hpp"

namespace renodx::games::detroitbecomehuman::temporal_capture {

inline constexpr std::array<std::uint32_t, DETROIT_DLSS_TAA_SAMPLED_BINDING_COUNT>
    kSampledBindings = {0u, 1u, 2u, 3u, 4u, 5u, 6u, 7u, 9u};
inline constexpr std::array<std::uint32_t, DETROIT_DLSS_TAA_STORAGE_BINDING_COUNT>
    kStorageBindings = {16u, 17u, 18u, 19u};
inline constexpr std::array<std::uint32_t, 7u> kSparseBindings = {
    1u, 3u, 4u, 5u, 7u, 16u, 52u};
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
inline constexpr bool kStopBeforeBridgeEvaluateForDiagnostic = false;

enum class RuntimeStatus : std::uint32_t {
  kNative = 0u,
  kWaitingForDispatch,
  kDescriptorContractIncomplete,
  kBridgeInputReadyDiagnostic,
  kTemporalContractUnverified,
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

struct SparseDescriptorSlot {
  reshade::api::descriptor_type type = reshade::api::descriptor_type::sampler;
  reshade::api::resource_view view = {0u};
  reshade::api::buffer_range buffer = {};
  bool valid = false;
};

struct SparseDescriptorTable {
  std::uint64_t epoch = 0u;
  std::array<SparseDescriptorSlot, kSparseBindings.size()> slots = {};
};

struct __declspec(uuid("95bf0125-a20e-4db7-89ad-7d2a1fd73662"))
    SparseDescriptorDeviceData {
  std::shared_mutex mutex;
  std::unordered_map<std::uint64_t, SparseDescriptorTable> tables;
  std::uint64_t next_epoch = 1u;
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

struct TemporalConstantsCaptureDiagnostics {
  const char* detail = "not_attempted";
  dlss::embedded::MappedBufferReadDiagnostics persistent_read = {};
  std::uint64_t buffer = 0u;
  std::uint64_t resource_size = 0u;
  std::uint64_t descriptor_offset = 0u;
  std::uint64_t descriptor_range = 0u;
  std::uint64_t effective_offset = 0u;
  std::uint32_t dynamic_offset = 0u;
  std::uint32_t descriptor_type = 0u;
  std::uint32_t resource_type = 0u;
  std::uint32_t heap = 0u;
  std::uint32_t usage = 0u;
  bool slot_found = false;
  bool remap_attempted = false;
  bool remap_succeeded = false;
  bool remap_pointer_valid = false;
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

inline temporal_mode_state::Tracker mode_state;
inline std::atomic<RuntimeStatus> runtime_status = RuntimeStatus::kNative;
inline std::atomic_bool bridge_input_ready_diagnostic_reached = false;
inline std::atomic<float> dlaa_sharpening = 0.f;
inline std::atomic<float> dlaa_sharpening_normalization = 1.f;
// Multiple Vulkan frames may be recorded concurrently. Associate the valid
// DLSS result with the exact native command list that later records final CAS;
// a process-global frame boolean can suppress CAS on the wrong in-flight frame.
// Detroit records the main view and auxiliary full-resolution temporal passes
// into different Vulkan command buffers. Applying NGX to every matching TAA
// dispatch permanently pins one ~100 MiB scratch bundle to each reusable
// command buffer. Learn the command buffers that also record the verified
// scene composite, and run DLSS only on that main-view set.
inline std::shared_mutex main_temporal_command_list_mutex;
inline std::unordered_set<std::uint64_t> main_temporal_command_lists;
inline thread_local std::uint64_t latest_temporal_command_list = 0u;
inline thread_local std::uint64_t latest_temporal_dispatch_serial = 0u;
inline thread_local reshade::api::pipeline native_temporal_pipeline = {0u};
inline thread_local reshade::api::pipeline_layout native_temporal_pipeline_layout = {0u};
inline thread_local bool auxiliary_temporal_replacement_requested = false;
inline thread_local std::uint64_t auxiliary_temporal_replacement_generation = 0u;
inline std::atomic_uint64_t frame_counter = 0u;
inline std::atomic_uint64_t evaluation_serial = 0u;
inline std::atomic_bool evaluation_serial_tracking_enabled = false;
static_assert(std::atomic_uint64_t::is_always_lock_free);
inline std::mutex contract_mutex;
inline ContractShape last_contract_shape = {};
inline bool has_logged_contract = false;
inline constexpr std::uint64_t kUnloggedTelemetryKey =
    std::numeric_limits<std::uint64_t>::max();
inline constexpr std::uint32_t kMaximumSnapshotDiagnosticLogs = 16u;
inline constexpr std::uint32_t kMaximumBridgeDiagnosticAttempts = 3u;
inline std::atomic_uint64_t last_logged_snapshot_diagnostic_key =
    kUnloggedTelemetryKey;
inline std::atomic_uint32_t snapshot_diagnostic_log_count = 0u;
inline std::atomic_uint32_t bridge_diagnostic_attempt_count = 0u;
inline std::atomic_bool has_logged_bridge_input_ready = false;
inline std::atomic_uint64_t last_logged_dlss_success_key =
    kUnloggedTelemetryKey;
inline std::atomic_uint64_t last_logged_evaluation_key =
    kUnloggedTelemetryKey;
inline std::atomic_bool has_logged_auxiliary_fallback_replay = false;
inline std::atomic_bool has_logged_auxiliary_active = false;
// Serialize mode publication with one temporal evaluation. The tracker mutex
// itself must not cross ReShade/Vulkan calls: private command-buffer creation
// synchronously re-enters the command-list lifecycle callbacks below.
inline std::mutex mode_transition_mutex;

inline void Log(reshade::log::level level, const std::string& message) {
  reshade::log::message(level, ("Detroit DLSS capture: " + message).c_str());
}

inline void ClearObservedTemporalCommandList(
    std::uint64_t command_list) noexcept {
  if (latest_temporal_command_list != command_list) return;
  latest_temporal_command_list = 0u;
  latest_temporal_dispatch_serial = 0u;
}

inline void OnDestroyTemporalCommandList(reshade::api::command_list* cmd_list) {
  if (cmd_list == nullptr) return;
  const auto command_list = cmd_list->get_native();
  ClearObservedTemporalCommandList(command_list);
  dlss::embedded::RetireFeatureCommandBuffer(command_list);
  if (!temporal_mode_state::CanUseNativeModeFastPath(mode_state.GetMode())) {
    mode_state.DiscardCommandList(command_list);
  }

  std::size_t remaining = 0u;
  bool erased = false;
  {
    std::unique_lock lock(main_temporal_command_list_mutex);
    erased = main_temporal_command_lists.erase(command_list) != 0u;
    remaining = main_temporal_command_lists.size();
  }
  if (erased) {
    Log(
        reshade::log::level::info,
        std::format(
            "retired main-view temporal command list 0x{:X} ({} remain).",
            command_list,
            remaining));
  }
}

inline void OnResetTemporalCommandList(reshade::api::command_list* cmd_list) {
  if (cmd_list == nullptr) return;
  const auto command_list = cmd_list->get_native();
  ClearObservedTemporalCommandList(command_list);
  if (temporal_mode_state::CanUseNativeModeFastPath(mode_state.GetMode())) {
    return;
  }
  mode_state.BeginRecording(command_list);
}

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
  if (temporal_mode_state::CanUseNativeModeFastPath(mode_state.GetMode())) {
    return;
  }

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
  if constexpr (kStopBeforeBridgeEvaluateForDiagnostic) {
    if (bridge_input_ready_diagnostic_reached.load(std::memory_order_relaxed)) {
      return RuntimeStatus::kBridgeInputReadyDiagnostic;
    }
  }
  return runtime_status.load(std::memory_order_relaxed);
}

[[nodiscard]] inline DetroitDlssMode GetMode() {
  return mode_state.GetMode();
}

[[nodiscard]] inline std::uint64_t GetEvaluationSerial() {
  return evaluation_serial.load(std::memory_order_acquire);
}

inline void SetEvaluationSerialTracking(bool enabled) noexcept {
  evaluation_serial_tracking_enabled.store(enabled, std::memory_order_release);
}

[[nodiscard]] inline std::uint64_t NextTemporalDispatchSerial() noexcept {
  if (!evaluation_serial_tracking_enabled.load(std::memory_order_acquire)) {
    return 1u;
  }
  return evaluation_serial.fetch_add(1u, std::memory_order_acq_rel) + 1u;
}

inline void SetDlaaSharpening(
    float strength,
    float normalization) noexcept {
  if (!std::isfinite(strength)) strength = 0.f;
  if (!std::isfinite(normalization)) normalization = 1.f;
  dlaa_sharpening.store(
      std::clamp(strength, 0.f, 1.f),
      std::memory_order_release);
  dlaa_sharpening_normalization.store(
      std::max(normalization, 1.f),
      std::memory_order_release);
}

inline void SetMode(DetroitDlssMode mode) {
  mode = dlss_policy::NormalizeDlssMode(mode);
  std::scoped_lock transition_lock(mode_transition_mutex);
  const auto transition = mode_state.SetMode(mode);
  const auto current = transition.current;
  const auto previous = transition.previous;
  if (transition.changed) {
    bridge_input_ready_diagnostic_reached.store(false, std::memory_order_relaxed);
    last_logged_snapshot_diagnostic_key.store(
        kUnloggedTelemetryKey,
        std::memory_order_relaxed);
    snapshot_diagnostic_log_count.store(0u, std::memory_order_relaxed);
    bridge_diagnostic_attempt_count.store(0u, std::memory_order_relaxed);
    has_logged_bridge_input_ready.store(false, std::memory_order_relaxed);
  }
  if (current.mode == DETROIT_DLSS_MODE_NATIVE
      && transition.changed && previous != DETROIT_DLSS_MODE_NATIVE) {
    (void)dlss_bridge_client::client.TransitionToNative();
  }
  if (current.mode == DETROIT_DLSS_MODE_NATIVE) {
    runtime_status.store(RuntimeStatus::kNative, std::memory_order_relaxed);
  } else {
    runtime_status.store(RuntimeStatus::kWaitingForDispatch, std::memory_order_relaxed);
  }
}

[[nodiscard]] inline bool RecordDlssOutputForCommandList(
    std::uint64_t command_list,
    const temporal_mode_state::Snapshot& mode_snapshot,
    bool output_valid) {
  return mode_state.Record(command_list, mode_snapshot, output_valid);
}

[[nodiscard]] inline bool QueryDlssOutputForCommandList(
    std::uint64_t command_list) {
  return mode_state.QueryAuthorization(command_list).authorized;
}

[[nodiscard]] inline temporal_mode_state::Authorization
QueryDlssOutputAuthorizationForCommandList(std::uint64_t command_list) {
  return mode_state.QueryAuthorization(command_list);
}

[[nodiscard]] inline bool RequestAuxiliaryTemporalReplacement(
    reshade::api::command_list* command_list) {
  auxiliary_temporal_replacement_requested = false;
  auxiliary_temporal_replacement_generation = 0u;
  if (temporal_mode_state::CanUseNativeModeFastPath(mode_state.GetMode())) {
    return false;
  }
  if (command_list == nullptr
      || command_list->get_device() == nullptr
      || command_list->get_device()->get_api()
             != reshade::api::device_api::vulkan) {
    return false;
  }

  const auto native_command_list = command_list->get_native();
  const auto authorization =
      mode_state.QueryAuthorization(native_command_list);
  if (authorization.snapshot.mode == DETROIT_DLSS_MODE_NATIVE) return false;
  // Require a successful evaluation on this exact reusable command buffer
  // before replacing its native b16 output. The first eligible recording stays
  // native and proves the complete NGX path. Any later failure is replayed with
  // the original pipeline by NativeTemporalFallbackGuard below.
  auxiliary_temporal_replacement_requested =
      native_temporal_pipeline.handle != 0u
      && dlss::embedded::CanInsertComputeWriteBarrier(native_command_list)
      && IsMainTemporalCommandList(native_command_list)
      && authorization.replacement_eligible;
  if (auxiliary_temporal_replacement_requested) {
    auxiliary_temporal_replacement_generation =
        authorization.snapshot.generation;
  }
  return auxiliary_temporal_replacement_requested;
}

[[nodiscard]] inline bool ConsumeDlssOutputForCommandList(
    std::uint64_t command_list) {
  // A frame may execute more than one final-CAS dispatch on the same command
  // buffer. Keep the successful state until the next TAA dispatch explicitly
  // clears it through RecordDlssOutputForCommandList(..., false).
  return QueryDlssOutputForCommandList(command_list);
}

[[nodiscard]] inline std::optional<std::size_t> GetSparseBindingIndex(
    std::uint32_t binding) {
  const auto found = std::find(
      kSparseBindings.begin(), kSparseBindings.end(), binding);
  if (found == kSparseBindings.end()) return std::nullopt;
  return static_cast<std::size_t>(found - kSparseBindings.begin());
}

[[nodiscard]] inline SparseDescriptorSlot ReadSparseDescriptor(
    reshade::api::device* device,
    const reshade::api::descriptor_table_update& update) {
  if (update.array_offset != 0u) {
    return {};
  }

  SparseDescriptorSlot slot = {.type = update.type};
  if (update.count == 0u || update.descriptors == nullptr) {
    dlss::embedded::DynamicConstantBufferBinding binding = {};
    if (device != nullptr
        && update.binding == DETROIT_DLSS_TAA_CONSTANT_BINDING_52
        && static_cast<std::uint32_t>(update.type) == 8u
        && dlss::embedded::GetCurrentDynamicConstantBufferBinding(
            device->get_native(), update.table.handle, &binding)) {
      slot.buffer = {
          .buffer = reshade::api::resource{binding.buffer},
          .offset = binding.offset,
          .size = binding.range,
      };
      slot.valid = binding.buffer != 0u;
    }
    return slot;
  }
  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view:
      slot.view = static_cast<const reshade::api::sampler_with_resource_view*>(
                      update.descriptors)[0u]
                      .view;
      slot.valid = slot.view.handle != 0u;
      break;
    case reshade::api::descriptor_type::shader_resource_view:
    case reshade::api::descriptor_type::unordered_access_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
      slot.view = static_cast<const reshade::api::resource_view*>(
          update.descriptors)[0u];
      slot.valid = slot.view.handle != 0u;
      break;
    case reshade::api::descriptor_type::constant_buffer:
      slot.buffer = static_cast<const reshade::api::buffer_range*>(
          update.descriptors)[0u];
      slot.valid = slot.buffer.buffer.handle != 0u;
      break;
    default:
      // ReShade API 20 represents Vulkan dynamic constant buffers as type 8.
      if (static_cast<std::uint32_t>(update.type) == 8u) {
        slot.buffer = static_cast<const reshade::api::buffer_range*>(
            update.descriptors)[0u];
        slot.valid = slot.buffer.buffer.handle != 0u;
      }
      break;
  }
  return slot;
}

inline void OnInitSparseDescriptorDevice(reshade::api::device* device) {
  renodx::utils::data::Create<SparseDescriptorDeviceData>(device);
}

inline void OnDestroySparseDescriptorDevice(reshade::api::device* device) {
  renodx::utils::data::Delete<SparseDescriptorDeviceData>(device);
}

inline bool OnUpdateSparseDescriptorTables(
    reshade::api::device* device,
    std::uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (device == nullptr || count == 0u || updates == nullptr) return false;
  bool relevant = false;
  for (std::uint32_t index = 0u; index < count; ++index) {
    relevant |= updates[index].array_offset == 0u
                && GetSparseBindingIndex(updates[index].binding).has_value();
  }
  if (!relevant) return false;

  auto* data = renodx::utils::data::Get<SparseDescriptorDeviceData>(device);
  if (data == nullptr) return false;
  const std::unique_lock lock(data->mutex);
  auto epoch = data->next_epoch++;
  if (epoch == 0u) epoch = data->next_epoch++;
  for (std::uint32_t index = 0u; index < count; ++index) {
    const auto& update = updates[index];
    const auto slot_index = update.array_offset == 0u
                                ? GetSparseBindingIndex(update.binding)
                                : std::nullopt;
    if (!slot_index.has_value() || update.table.handle == 0u) continue;
    auto& table = data->tables[update.table.handle];
    // Vulkan descriptor updates preserve bindings not named by the write.
    table.epoch = epoch;
    table.slots[*slot_index] = ReadSparseDescriptor(device, update);
  }
  return false;
}

inline bool OnCopySparseDescriptorTables(
    reshade::api::device* device,
    std::uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (device == nullptr || count == 0u || copies == nullptr) return false;
  struct CopyOperation {
    std::uint64_t destination = 0u;
    std::size_t destination_index = 0u;
    SparseDescriptorSlot slot = {};
  };
  std::vector<CopyOperation> operations;
  operations.reserve(count);

  auto* data = renodx::utils::data::Get<SparseDescriptorDeviceData>(device);
  if (data == nullptr) return false;
  const std::unique_lock lock(data->mutex);
  for (std::uint32_t index = 0u; index < count; ++index) {
    const auto& copy = copies[index];
    if (copy.source_array_offset != 0u || copy.dest_array_offset != 0u
        || copy.count == 0u) {
      continue;
    }
    const auto source_index = GetSparseBindingIndex(copy.source_binding);
    const auto destination_index = GetSparseBindingIndex(copy.dest_binding);
    if (!source_index.has_value() || !destination_index.has_value()
        || copy.source_table.handle == 0u || copy.dest_table.handle == 0u) {
      continue;
    }
    const auto source = data->tables.find(copy.source_table.handle);
    operations.push_back({
        .destination = copy.dest_table.handle,
        .destination_index = *destination_index,
        .slot = source != data->tables.end()
                    ? source->second.slots[*source_index]
                    : SparseDescriptorSlot{},
    });
  }
  if (operations.empty()) return false;

  auto epoch = data->next_epoch++;
  if (epoch == 0u) epoch = data->next_epoch++;
  for (const auto& operation : operations) {
    auto& table = data->tables[operation.destination];
    table.epoch = epoch;
    table.slots[operation.destination_index] = operation.slot;
  }
  return false;
}

[[nodiscard]] inline bool ResolveSparseBindings(
    reshade::api::device* device,
    reshade::api::descriptor_table table,
    ResolvedBindings* output,
    std::uint64_t* epoch = nullptr) {
  if (device == nullptr || table.handle == 0u || output == nullptr) return false;
  auto* data = renodx::utils::data::Get<SparseDescriptorDeviceData>(device);
  if (data == nullptr) return false;

  SparseDescriptorTable snapshot = {};
  {
    const std::shared_lock lock(data->mutex);
    const auto found = data->tables.find(table.handle);
    if (found == data->tables.end()) return false;
    snapshot = found->second;
  }
  const bool complete =
      snapshot.epoch != 0u
      && std::all_of(
          snapshot.slots.begin(),
          snapshot.slots.end(),
          [](const SparseDescriptorSlot& slot) { return slot.valid; });
  if (epoch != nullptr) *epoch = snapshot.epoch;

  const auto assign = [&](std::uint32_t binding, ResolvedSlot* destination) {
    const auto sparse_index = GetSparseBindingIndex(binding);
    if (!sparse_index.has_value() || destination == nullptr) return;
    const auto& source = snapshot.slots[*sparse_index];
    destination->type = source.type;
    destination->view = source.view;
    destination->buffer = source.buffer;
    destination->table = table;
    destination->set_index = DETROIT_DLSS_TAA_DESCRIPTOR_SET;
    destination->found = source.valid;
  };
  assign(1u, &output->sampled[1u]);
  assign(3u, &output->sampled[3u]);
  assign(4u, &output->sampled[4u]);
  assign(5u, &output->sampled[5u]);
  assign(7u, &output->sampled[7u]);
  assign(16u, &output->storage[0u]);
  assign(52u, &output->constants);
  output->constants_descriptor_type =
      static_cast<std::uint32_t>(output->constants.type);
  return complete;
}

[[nodiscard]] inline std::uint32_t ToVulkanFormat(
    reshade::api::format format) noexcept {
  switch (format) {
    case reshade::api::format::r16g16_float:
      return kVkFormatRg16Float;
    case reshade::api::format::r16g16b16a16_float:
      return kVkFormatRgba16Float;
    case reshade::api::format::r32_uint:
      return kVkFormatR32Uint;
    case reshade::api::format::r9g9b9e5:
      return kVkFormatRgb9e5;
    case reshade::api::format::d32_float_s8_uint:
      return kVkFormatD32FloatS8Uint;
    default:
      return 0u;
  }
}

[[nodiscard]] inline CapturedImage CaptureImage(
    reshade::api::device* device,
    const ResolvedSlot& slot,
    std::uint32_t layout) {
  if (device == nullptr || !slot.found || slot.view.handle == 0u) return {};

  const auto resource = device->get_resource_from_view(slot.view);
  if (resource.handle == 0u) return {};
  const auto resource_desc = device->get_resource_desc(resource);
  const auto view_desc = device->get_resource_view_desc(slot.view);
  if (resource_desc.type != reshade::api::resource_type::texture_2d
      || view_desc.type != reshade::api::resource_view_type::texture_2d
      || resource_desc.texture.width == 0u || resource_desc.texture.height == 0u
      || view_desc.texture.first_level >= resource_desc.texture.levels
      || view_desc.texture.first_layer >= resource_desc.texture.depth_or_layers) {
    return {};
  }
  const auto reshade_format =
      view_desc.format != reshade::api::format::unknown
          ? view_desc.format
          : reshade::api::format_to_default_typed(resource_desc.texture.format);
  const auto format = ToVulkanFormat(reshade_format);
  if (format == 0u) return {};
  const auto mip = std::min(view_desc.texture.first_level, 31u);

  return {
      .image = resource.handle,
      .image_view = slot.view.handle,
      .format = format,
      .width = std::max(resource_desc.texture.width >> mip, 1u),
      .height = std::max(resource_desc.texture.height >> mip, 1u),
      .mip_level = view_desc.texture.first_level,
      .array_layer = view_desc.texture.first_layer,
      .layout = layout,
      .valid = true,
  };
}

[[nodiscard]] inline bool CaptureTemporalConstants(
    reshade::api::device* device,
    const ResolvedSlot& slot,
    const dlss::embedded::CommandRecordingMetadata& metadata,
    DetroitDlssTemporalConstantsSnapshot* snapshot,
    TemporalConstantsCaptureDiagnostics* diagnostics) {
  static_assert(
      kReflectedTemporalConstantsSize
      <= DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY);
  if (diagnostics != nullptr) {
    *diagnostics = {
        .buffer = slot.buffer.buffer.handle,
        .descriptor_offset = slot.buffer.offset,
        .descriptor_range = slot.buffer.size,
        .dynamic_offset = metadata.constants_dynamic_offset,
        .descriptor_type = static_cast<std::uint32_t>(slot.type),
        .slot_found = slot.found,
    };
  }
  const auto fail = [diagnostics](const char* detail) {
    if (diagnostics != nullptr) diagnostics->detail = detail;
    return false;
  };
  if (device == nullptr) return fail("device_missing");
  if (snapshot == nullptr) return fail("snapshot_missing");
  if (!slot.found) return fail("slot_missing");
  if (slot.buffer.buffer.handle == 0u) return fail("buffer_missing");
  if (slot.type != reshade::api::descriptor_type::constant_buffer
      && static_cast<std::uint32_t>(slot.type) != 8u) {
    return fail("descriptor_type_mismatch");
  }
  const auto desc = device->get_resource_desc(slot.buffer.buffer);
  if (diagnostics != nullptr) {
    diagnostics->resource_type = static_cast<std::uint32_t>(desc.type);
    diagnostics->heap = static_cast<std::uint32_t>(desc.heap);
    diagnostics->usage = static_cast<std::uint32_t>(desc.usage);
  }
  if (desc.type != reshade::api::resource_type::buffer) {
    return fail("resource_not_buffer");
  }
  if (diagnostics != nullptr) diagnostics->resource_size = desc.buffer.size;
  if (slot.buffer.offset > desc.buffer.size) {
    return fail("descriptor_offset_out_of_range");
  }
  if (metadata.constants_dynamic_offset
      > desc.buffer.size - slot.buffer.offset) {
    return fail("dynamic_offset_out_of_range");
  }
  const auto effective_offset =
      slot.buffer.offset + metadata.constants_dynamic_offset;
  const auto available = desc.buffer.size - effective_offset;
  const auto range = slot.buffer.size == UINT64_MAX
                         ? available
                         : slot.buffer.size;
  if (diagnostics != nullptr) {
    diagnostics->effective_offset = effective_offset;
    diagnostics->descriptor_range = range;
  }
  if (range < kReflectedTemporalConstantsSize) {
    return fail("descriptor_range_too_small");
  }
  if (range > available) return fail("descriptor_range_out_of_range");

  *snapshot = {
      .struct_size = sizeof(*snapshot),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .descriptor_set_index = DETROIT_DLSS_TAA_DESCRIPTOR_SET,
      .binding = DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
      .command_buffer = metadata.command_buffer,
      .descriptor_set = metadata.descriptor_set,
      .pipeline_layout = metadata.pipeline_layout,
      .buffer = slot.buffer.buffer.handle,
      .descriptor_offset = slot.buffer.offset,
      .dynamic_offset = metadata.constants_dynamic_offset,
      .effective_offset = effective_offset,
      .descriptor_range = range,
      .descriptor_type = static_cast<std::uint32_t>(slot.type),
      .valid_flags = DETROIT_DLSS_CONSTANTS_DESCRIPTOR_VALID
                     | DETROIT_DLSS_CONSTANTS_DYNAMIC_OFFSET_VALID
                     | DETROIT_DLSS_CONSTANTS_EFFECTIVE_OFFSET_VALID
                     | DETROIT_DLSS_CONSTANTS_RANGE_VALID,
  };
  const bool persistent_read =
      dlss::embedded::ReadPersistentlyMappedBufferRange(
          device->get_native(),
          slot.buffer.buffer.handle,
          effective_offset,
          kReflectedTemporalConstantsSize,
          snapshot->constants,
          diagnostics != nullptr ? &diagnostics->persistent_read : nullptr);
  if (!persistent_read) {
    void* mapped = nullptr;
    if (diagnostics != nullptr) diagnostics->remap_attempted = true;
    const bool remap_succeeded = device->map_buffer_region(
        slot.buffer.buffer,
        effective_offset,
        kReflectedTemporalConstantsSize,
        reshade::api::map_access::read_only,
        &mapped);
    if (diagnostics != nullptr) {
      diagnostics->remap_succeeded = remap_succeeded;
      diagnostics->remap_pointer_valid = mapped != nullptr;
    }
    if (!remap_succeeded) return fail("remap_failed");
    if (mapped == nullptr) return fail("remap_pointer_missing");
    std::memcpy(
        snapshot->constants,
        mapped,
        static_cast<std::size_t>(kReflectedTemporalConstantsSize));
    device->unmap_buffer_region(slot.buffer.buffer);
  }
  snapshot->bytes_written =
      static_cast<std::uint32_t>(kReflectedTemporalConstantsSize);
  snapshot->valid_flags |= DETROIT_DLSS_CONSTANTS_PAYLOAD_VALID;
  snapshot->source_flags = DETROIT_DLSS_CONSTANTS_SOURCE_MAPPED_MEMORY;
  if (diagnostics != nullptr) {
    diagnostics->detail = persistent_read ? "persistent_mapping" : "temporary_remap";
  }
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
      "the transitional DLAA pass preserves Detroit's b17-b19 history outputs while NGX owns b16; later failures replay the original pipeline.");
}

struct NativeTemporalFallbackGuard {
  using Context = renodx::utils::command_action::CommandContext<
      renodx::utils::command_action::DispatchArguments>;

  Context* context = nullptr;
  reshade::api::pipeline native_pipeline = {0u};
  temporal_mode_state::Snapshot mode_snapshot = {};
  bool armed = false;

  NativeTemporalFallbackGuard(
      Context& dispatch_context,
      reshade::api::pipeline pipeline,
      bool auxiliary_replacement_used,
      temporal_mode_state::Snapshot snapshot)
      : context(&dispatch_context),
        native_pipeline(pipeline),
        mode_snapshot(snapshot),
        armed(auxiliary_replacement_used && pipeline.handle != 0u) {}

  NativeTemporalFallbackGuard(const NativeTemporalFallbackGuard&) = delete;
  NativeTemporalFallbackGuard& operator=(const NativeTemporalFallbackGuard&) = delete;

  ~NativeTemporalFallbackGuard() {
    if (!armed || context == nullptr || context->cmd_list == nullptr) return;
    if (!dlss::embedded::InsertComputeWriteBarrier(
            context->cmd_list->get_native())) {
      Log(
          reshade::log::level::error,
          "DLAA auxiliary fallback barrier was unavailable; original TAA replay was suppressed to avoid a Vulkan WAW hazard.");
      return;
    }
    context->cmd_list->bind_pipeline(
        reshade::api::pipeline_stage::all_compute,
        native_pipeline);
    context->cmd_list->dispatch(
        context->arguments.group_count_x,
        context->arguments.group_count_y,
        context->arguments.group_count_z);
    (void)mode_state.Record(
        context->cmd_list->get_native(), mode_snapshot, false);
    if (!has_logged_auxiliary_fallback_replay.exchange(
            true, std::memory_order_acq_rel)) {
      Log(
          reshade::log::level::warning,
          "DLAA auxiliary pass fell back safely by replaying the original TAA pipeline.");
    }
  }

  void Disarm() noexcept { armed = false; }
};

inline void AfterNativeTemporalDispatch(
    renodx::utils::command_action::CommandContext<
        renodx::utils::command_action::DispatchArguments>& context,
    const void*) {
  if (context.cmd_list == nullptr) return;
  const bool auxiliary_replacement_used =
      auxiliary_temporal_replacement_requested;
  const auto replacement_generation =
      auxiliary_temporal_replacement_generation;
  auxiliary_temporal_replacement_requested = false;
  auxiliary_temporal_replacement_generation = 0u;
  const auto temporal_pipeline = native_temporal_pipeline;
  const auto temporal_pipeline_layout = native_temporal_pipeline_layout;
  native_temporal_pipeline = {0u};
  native_temporal_pipeline_layout = {0u};
  const auto dispatch_serial = NextTemporalDispatchSerial();
  ObserveTemporalCommandList(
      context.cmd_list->get_native(), dispatch_serial);
  if (temporal_mode_state::CanUseNativePostDispatchFastPath(
          mode_state.GetMode(), auxiliary_replacement_used)) {
    return;
  }
  std::scoped_lock transition_lock(mode_transition_mutex);
  const auto mode_snapshot = mode_state.GetSnapshot();
  NativeTemporalFallbackGuard native_fallback(
      context,
      temporal_pipeline,
      auxiliary_replacement_used,
      mode_snapshot);
  // A later temporal dispatch in the same presented frame supersedes an
  // earlier result. Re-arm CAS until this dispatch independently succeeds.
  (void)mode_state.Record(
      context.cmd_list->get_native(), mode_snapshot, false);
  if (auxiliary_replacement_used
      && replacement_generation != mode_snapshot.generation) {
    runtime_status.store(
        mode_snapshot.mode == DETROIT_DLSS_MODE_NATIVE
            ? RuntimeStatus::kNative
            : RuntimeStatus::kWaitingForDispatch,
        std::memory_order_relaxed);
    return;
  }
  if (mode_snapshot.mode == DETROIT_DLSS_MODE_NATIVE) {
    runtime_status.store(RuntimeStatus::kNative, std::memory_order_relaxed);
    return;
  }
  const auto native_command_list = context.cmd_list->get_native();
  // Resolve the rotating b52 constants slot only for a command list already
  // proven to feed the later scene composite. An auxiliary TAA callback must
  // not consume the one changed ring-buffer slot before the main-view callback.
  if (!IsMainTemporalCommandList(native_command_list)) {
    if (runtime_status.load(std::memory_order_relaxed)
        != RuntimeStatus::kDlssActive) {
      runtime_status.store(
          RuntimeStatus::kWaitingForDispatch,
          std::memory_order_relaxed);
    }
    return;
  }
  auto* device = context.cmd_list->get_device();
  if (device == nullptr || device->get_api() != reshade::api::device_api::vulkan) {
    return;
  }

  dlss::embedded::CommandRecordingMetadata recording = {};
  const bool recording_metadata_available =
      dlss::embedded::GetCommandRecordingMetadata(
          native_command_list, &recording);
  const reshade::api::pipeline_layout pipeline_layout = {
      recording.pipeline_layout};
  const reshade::api::descriptor_table descriptor_set = {
      recording.descriptor_set};
  ResolvedBindings bindings = {};
  std::uint64_t descriptor_epoch = 0u;
  const bool has_pipeline_layout = pipeline_layout.handle != 0u;
  const bool has_descriptor_set = descriptor_set.handle != 0u;
  const bool pipeline_layout_matches =
      temporal_pipeline_layout.handle == 0u
      || temporal_pipeline_layout == pipeline_layout;
  const bool sparse_bindings_complete =
      recording_metadata_available && has_pipeline_layout && has_descriptor_set
      && pipeline_layout_matches
      && ResolveSparseBindings(
          device, descriptor_set, &bindings, &descriptor_epoch);
  bool snapshot_complete = sparse_bindings_complete;
  std::array<CapturedImage, kSampledBindings.size()> sampled = {};
  std::array<CapturedImage, kStorageBindings.size()> storage = {};
  DetroitDlssTemporalConstantsSnapshot constants_snapshot = {};
  TemporalConstantsCaptureDiagnostics constants_diagnostics = {};
  bool constants_captured = false;
  if (snapshot_complete) {
    sampled[1u] = CaptureImage(
        device, bindings.sampled[1u], kVkImageLayoutShaderReadOnly);
    sampled[3u] = CaptureImage(
        device, bindings.sampled[3u], kVkImageLayoutShaderReadOnly);
    sampled[4u] = CaptureImage(
        device, bindings.sampled[4u], kVkImageLayoutShaderReadOnly);
    sampled[5u] = CaptureImage(
        device, bindings.sampled[5u], kVkImageLayoutShaderReadOnly);
    sampled[7u] = CaptureImage(
        device, bindings.sampled[7u], kVkImageLayoutShaderReadOnly);
    storage[0u] = CaptureImage(
        device, bindings.storage[0u], kVkImageLayoutGeneral);
    // b5 exposure and b7 native history are optional with NGX auto-exposure.
    // A missing b7 requests a DLSS history reset below; it must not block the
    // first valid evaluation after scene/resource recreation.
    const bool required_images_complete =
        sampled[1u].valid && sampled[3u].valid && sampled[4u].valid
        && storage[0u].valid;
    constants_captured =
        required_images_complete
        && CaptureTemporalConstants(
            device,
            bindings.constants,
            recording,
            &constants_snapshot,
            &constants_diagnostics);
    snapshot_complete = required_images_complete && constants_captured;
  }

  const auto slot_mask =
      (bindings.sampled[1u].found ? 1u << 0u : 0u)
      | (bindings.sampled[3u].found ? 1u << 1u : 0u)
      | (bindings.sampled[4u].found ? 1u << 2u : 0u)
      | (bindings.sampled[5u].found ? 1u << 3u : 0u)
      | (bindings.sampled[7u].found ? 1u << 4u : 0u)
      | (bindings.storage[0u].found ? 1u << 5u : 0u)
      | (bindings.constants.found ? 1u << 6u : 0u);
  const auto image_mask =
      (sampled[1u].valid ? 1u << 0u : 0u)
      | (sampled[3u].valid ? 1u << 1u : 0u)
      | (sampled[4u].valid ? 1u << 2u : 0u)
      | (sampled[5u].valid ? 1u << 3u : 0u)
      | (sampled[7u].valid ? 1u << 4u : 0u)
      | (storage[0u].valid ? 1u << 5u : 0u);
  const auto snapshot_diagnostic_key = MakeTelemetryKey(
      has_pipeline_layout,
      has_descriptor_set,
      pipeline_layout_matches,
      sparse_bindings_complete,
      recording_metadata_available,
      slot_mask,
      image_mask,
      constants_captured);
  if (last_logged_snapshot_diagnostic_key.exchange(
          snapshot_diagnostic_key,
          std::memory_order_relaxed)
      != snapshot_diagnostic_key) {
    const auto log_index =
        snapshot_diagnostic_log_count.fetch_add(1u, std::memory_order_relaxed);
    if (log_index < kMaximumSnapshotDiagnosticLogs) {
      Log(
          snapshot_complete ? reshade::log::level::info
                            : reshade::log::level::warning,
          std::format(
              "TAA snapshot state {}: layout={}, set0={}, layout_match={}, sparse={}, recording={}, slots=0x{:02X} [b1,b3,b4,b5,b7,b16,b52], images=0x{:02X} [b1,b3,b4,b5,b7,b16], b52_payload={}, epoch={}, command=0x{:X}, layout_handle=0x{:X}, set0_handle=0x{:X}, recording_gen={}, dynamic_offset={}; complete={}.",
              log_index + 1u,
              has_pipeline_layout,
              has_descriptor_set,
              pipeline_layout_matches,
              sparse_bindings_complete,
              recording_metadata_available,
              slot_mask,
              image_mask,
              constants_captured,
              descriptor_epoch,
              native_command_list,
              pipeline_layout.handle,
              descriptor_set.handle,
              recording.recording_generation,
              recording.constants_dynamic_offset,
              snapshot_complete));
      Log(
          constants_captured ? reshade::log::level::info
                             : reshade::log::level::warning,
          std::format(
              "TAA b52 capture {}: detail={}, slot={}, descriptor_type={}, buffer=0x{:X}, resource_type={}, resource_size={}, heap=0x{:X}, usage=0x{:X}, descriptor_offset={}, dynamic_offset={}, effective_offset={}, descriptor_range={}, persistent_detail={}, memory=0x{:X}, binding_offset={}, mapped_offset={}, mapped_size={}, absolute_offset={}, relative_offset={}, tracked_buffers={}, tracked_memories={}, remap_attempted={}, remap_succeeded={}, remap_pointer={}; payload={}.",
              log_index + 1u,
              constants_diagnostics.detail,
              constants_diagnostics.slot_found,
              constants_diagnostics.descriptor_type,
              constants_diagnostics.buffer,
              constants_diagnostics.resource_type,
              constants_diagnostics.resource_size,
              constants_diagnostics.heap,
              constants_diagnostics.usage,
              constants_diagnostics.descriptor_offset,
              constants_diagnostics.dynamic_offset,
              constants_diagnostics.effective_offset,
              constants_diagnostics.descriptor_range,
              dlss::embedded::MappedBufferReadDetailName(
                  constants_diagnostics.persistent_read.detail),
              constants_diagnostics.persistent_read.memory,
              constants_diagnostics.persistent_read.binding_offset,
              constants_diagnostics.persistent_read.mapped_offset,
              constants_diagnostics.persistent_read.mapped_size,
              constants_diagnostics.persistent_read.absolute_offset,
              constants_diagnostics.persistent_read.relative_offset,
              constants_diagnostics.persistent_read.tracked_buffer_count,
              constants_diagnostics.persistent_read.tracked_memory_count,
              constants_diagnostics.remap_attempted,
              constants_diagnostics.remap_succeeded,
              constants_diagnostics.remap_pointer_valid,
              constants_captured));
    }
  }
  if (!snapshot_complete) {
    runtime_status.store(
        RuntimeStatus::kDescriptorContractIncomplete,
        std::memory_order_relaxed);
    return;
  }
  const auto constants_size = constants_snapshot.descriptor_range;
  const auto constants_descriptor_type = constants_snapshot.descriptor_type;

  ContractShape shape = {
      .pipeline_layout = pipeline_layout.handle,
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
          pipeline_layout.handle,
          descriptor_set.handle,
          sampled,
          storage,
          &constants_snapshot,
          nullptr,
          constants_descriptor_type);
      last_contract_shape = shape;
      has_logged_contract = true;
    }
  }

  const auto mode = mode_snapshot.mode;
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

  const bool native_history_resources_available = sampled[7u].valid;
  DetroitDlssTemporalFrameInputs inputs = {
      .struct_size = sizeof(DetroitDlssTemporalFrameInputs),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .shader_crc = supported_build::kTemporalAaShaderCrc,
      .descriptor_set_index = DETROIT_DLSS_TAA_DESCRIPTOR_SET,
      .command_buffer = context.cmd_list->get_native(),
      .descriptor_set = descriptor_set.handle,
      .pipeline_layout = pipeline_layout.handle,
      .compute_pipeline = temporal_pipeline.handle,
      .constants_buffer = constants_snapshot.buffer,
      .constants_offset = constants_snapshot.effective_offset,
      .constants_size = constants_snapshot.descriptor_range,
      .constants_dynamic_offset = constants_snapshot.dynamic_offset,
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
      // NGX owns an independent temporal history. Native b7 is optional and
      // may be absent on every frame, so only decoded frame state may reset it.
      .reset = frame_parameters.reset,
      .frame_id = frame_counter.fetch_add(1u, std::memory_order_relaxed) + 1u,
      .flags = DETROIT_DLSS_FRAME_TEMPORAL_INPUTS_READY
               | DETROIT_DLSS_FRAME_ALLOW_AUTO_EXPOSURE
               | (auxiliary_replacement_used
                      ? 0u
                      : DETROIT_DLSS_FRAME_NATIVE_TAA_COMPLETED),
      .verification_flags = verification_flags,
      .dlaa_sharpening = mode == DETROIT_DLSS_MODE_DLAA
                             ? dlaa_sharpening.load(std::memory_order_acquire)
                             : 0.f,
      .dlaa_sharpening_normalization =
          dlaa_sharpening_normalization.load(std::memory_order_acquire),
  };

  const auto bridge_diagnostic_attempt =
      bridge_diagnostic_attempt_count.fetch_add(1u, std::memory_order_relaxed)
      + 1u;
  const bool trace_bridge_attempt =
      bridge_diagnostic_attempt <= kMaximumBridgeDiagnosticAttempts;
  if (trace_bridge_attempt) {
    Log(
        reshade::log::level::info,
        std::format(
            "DLSS client trace attempt={} event=input frame={} mode={} mode_generation={} auxiliary={} shader=0x{:08X} flags=0x{:X} verification=0x{:X} verification_missing=0x{:X} command=0x{:X} recording_generation={} begin_flags=0x{:X} pipeline=0x{:X} layout=0x{:X} set0=0x{:X} dispatch={}x{}x{} render={}x{} output={}x{} reset={} jitter=({}, {}) mv_scale=({}, {}) pre_exposure={} sharpening={} normalization={}.",
            bridge_diagnostic_attempt,
            inputs.frame_id,
            mode,
            mode_snapshot.generation,
            auxiliary_replacement_used,
            inputs.shader_crc,
            inputs.flags,
            inputs.verification_flags,
            DETROIT_DLSS_VERIFY_MANDATORY_MASK
                & ~inputs.verification_flags,
            inputs.command_buffer,
            recording.recording_generation,
            recording.begin_flags,
            inputs.compute_pipeline,
            inputs.pipeline_layout,
            inputs.descriptor_set,
            context.arguments.group_count_x,
            context.arguments.group_count_y,
            context.arguments.group_count_z,
            inputs.render_width,
            inputs.render_height,
            inputs.output_width,
            inputs.output_height,
            inputs.reset,
            inputs.jitter_x,
            inputs.jitter_y,
            inputs.motion_vector_scale_x,
            inputs.motion_vector_scale_y,
            inputs.pre_exposure,
            inputs.dlaa_sharpening,
            inputs.dlaa_sharpening_normalization));
    const auto log_resource = [&](std::string_view role,
                                  const DetroitDlssResource& resource) {
      Log(
          reshade::log::level::info,
          std::format(
              "DLSS client trace attempt={} event=resource role={} image=0x{:X} view=0x{:X} format={} layout={} extent={}x{} mip={} layer={} flags=0x{:X}.",
              bridge_diagnostic_attempt,
              role,
              resource.image,
              resource.image_view,
              resource.format,
              resource.layout,
              resource.width,
              resource.height,
              resource.mip_level,
              resource.array_layer,
              resource.flags));
    };
    log_resource("current_color_b1", inputs.current_color);
    log_resource("depth_b3", inputs.depth);
    log_resource("motion_vectors_b4", inputs.motion_vectors);
    log_resource("exposure_b5", inputs.exposure);
    log_resource("native_output_b16", inputs.output);
    Log(
        reshade::log::level::info,
        std::format(
            "DLSS client trace attempt={} event=constants buffer=0x{:X} descriptor_offset={} dynamic_offset={} effective_offset={} range={} bytes={} descriptor_type={} valid_flags=0x{:X} source_flags=0x{:X} descriptor_epoch={} history_available={}.",
            bridge_diagnostic_attempt,
            constants_snapshot.buffer,
            constants_snapshot.descriptor_offset,
            constants_snapshot.dynamic_offset,
            constants_snapshot.effective_offset,
            constants_snapshot.descriptor_range,
            constants_snapshot.bytes_written,
            constants_snapshot.descriptor_type,
            constants_snapshot.valid_flags,
            constants_snapshot.source_flags,
            descriptor_epoch,
            native_history_resources_available));
  }

  if constexpr (kStopBeforeBridgeEvaluateForDiagnostic) {
    bridge_input_ready_diagnostic_reached.store(true, std::memory_order_relaxed);
    if (!has_logged_bridge_input_ready.exchange(true, std::memory_order_relaxed)) {
      Log(
          reshade::log::level::info,
          std::format(
              "bridge boundary reached before Configure/Evaluate (frame {}, epoch {}, command 0x{:X}, recording_gen {}, verification 0x{:X}, render {}x{}, output {}x{}); diagnostic Native TAA fallback remains active.",
              inputs.frame_id,
              descriptor_epoch,
              inputs.command_buffer,
              recording.recording_generation,
              inputs.verification_flags,
              inputs.render_width,
              inputs.render_height,
              inputs.output_width,
              inputs.output_height));
    }
    runtime_status.store(
        RuntimeStatus::kBridgeInputReadyDiagnostic,
        std::memory_order_relaxed);
    return;
  }

  std::optional<dlss_bridge_client::EvaluationDiagnostics>
      evaluation_diagnostics;
  if (trace_bridge_attempt) evaluation_diagnostics.emplace();
  const auto evaluation = dlss_bridge_client::client.Evaluate(
      mode,
      inputs,
      evaluation_diagnostics ? &*evaluation_diagnostics : nullptr);
  if (evaluation_diagnostics) {
    const auto& diagnostics = *evaluation_diagnostics;
    Log(
        evaluation.output_valid ? reshade::log::level::info
                                : reshade::log::level::warning,
        std::format(
            "DLSS client trace attempt={} event=result frame={} stage={} status={} reason={} reason_raw={} bridge_detail=0x{:X} output_valid={} suppress_final_cas={} effective_reset={} connected={} context_refreshed={} capabilities=0x{:X} bridge_abi={} cache_reused={} query_called={} query_status={} configure_called={} configure_status={} feature_reconfigured={} evaluate_called={} evaluate_status={} result_size={} result_abi={} result_status={} result_detail=0x{:X} result_frame={} result_flags=0x{:X} eligibility={} eligibility_reason={} outcome={} outcome_reason={} settings_mode={} create_flags=0x{:X} settings_render={}x{} settings_output={}x{}.",
            bridge_diagnostic_attempt,
            inputs.frame_id,
            dlss_bridge_client::EvaluationStageName(
                diagnostics.stage),
            evaluation.status,
            dlss_policy::FallbackReasonName(evaluation.reason),
            static_cast<std::uint32_t>(evaluation.reason),
            evaluation.bridge_detail,
            evaluation.output_valid,
            evaluation.suppress_final_cas,
            evaluation.effective_reset,
            diagnostics.connected,
            diagnostics.context_refreshed,
            diagnostics.capability_flags,
            diagnostics.bridge_abi_version,
            diagnostics.settings_cache_reused,
            diagnostics.query_called,
            diagnostics.query_status,
            diagnostics.configure_called,
            diagnostics.configure_status,
            diagnostics.feature_reconfigured,
            diagnostics.evaluate_called,
            diagnostics.evaluate_status,
            diagnostics.result_struct_size,
            diagnostics.result_abi_version,
            diagnostics.result_status,
            diagnostics.result_detail,
            diagnostics.result_frame_id,
            diagnostics.result_flags,
            diagnostics.eligibility.evaluate_dlss,
            dlss_policy::FallbackReasonName(
                diagnostics.eligibility.reason),
            diagnostics.outcome.use_dlss_output,
            dlss_policy::FallbackReasonName(
                diagnostics.outcome.reason),
            diagnostics.settings.mode,
            diagnostics.settings.create_flags,
            diagnostics.settings.render_width,
            diagnostics.settings.render_height,
            diagnostics.settings.output_width,
            diagnostics.settings.output_height));
  }
  // The final CAS gate follows the latest temporal dispatch in this frame.
  // Never retain a successful earlier dispatch if a later one fell back to
  // Detroit's native b16 output.
  const bool output_authorized = mode_state.Record(
      inputs.command_buffer,
      mode_snapshot,
      evaluation.output_valid && evaluation.suppress_final_cas);
  if (evaluation.output_valid && evaluation.suppress_final_cas
      && output_authorized) {
    native_fallback.Disarm();
    if (auxiliary_replacement_used
        && !has_logged_auxiliary_active.exchange(true, std::memory_order_acq_rel)) {
      Log(
          reshade::log::level::info,
          "DLAA auxiliary history pass active; NGX owns b16 while Detroit retains b17-b19.");
    }
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
  } else if (evaluation.output_valid && evaluation.suppress_final_cas) {
    const auto current_mode = mode_state.GetMode();
    runtime_status.store(
        current_mode == DETROIT_DLSS_MODE_NATIVE
            ? RuntimeStatus::kNative
            : RuntimeStatus::kWaitingForDispatch,
        std::memory_order_relaxed);
  } else if (mode == DETROIT_DLSS_MODE_NATIVE) {
    runtime_status.store(RuntimeStatus::kNative, std::memory_order_relaxed);
  } else if (evaluation.reason
             == dlss_policy::FallbackReason::kVerificationIncomplete) {
    runtime_status.store(
        RuntimeStatus::kTemporalContractUnverified,
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
             renodx::utils::command_action::DispatchArguments>& context) const {
    auxiliary_temporal_replacement_requested = false;
    auxiliary_temporal_replacement_generation = 0u;
    native_temporal_pipeline = {0u};
    native_temporal_pipeline_layout = {0u};
    if (temporal_mode_state::CanUseNativeModeFastPath(mode_state.GetMode())) {
      if (context.cmd_list != nullptr) {
        ObserveTemporalCommandList(
            context.cmd_list->get_native(), NextTemporalDispatchSerial());
      }
      return {};
    }
    auto* shader_state =
        renodx::utils::command_action::GetShaderState(&context);
    if (shader_state != nullptr) {
      auto& compute_state =
          shader_state->stage_states[renodx::utils::shader::COMPUTE_INDEX];
      renodx::utils::shader::PopulateStageState(&compute_state);
      native_temporal_pipeline = compute_state.pipeline_details != nullptr
                                     ? compute_state.pipeline_details->pipeline
                                     : compute_state.pipeline;
      native_temporal_pipeline_layout =
          compute_state.pipeline_details != nullptr
              ? compute_state.pipeline_details->layout
              : reshade::api::pipeline_layout{0u};
    }
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
      mode_state.Reset();
      bridge_input_ready_diagnostic_reached.store(false, std::memory_order_relaxed);
      last_logged_snapshot_diagnostic_key.store(
          kUnloggedTelemetryKey,
          std::memory_order_relaxed);
      snapshot_diagnostic_log_count.store(0u, std::memory_order_relaxed);
      bridge_diagnostic_attempt_count.store(0u, std::memory_order_relaxed);
      has_logged_bridge_input_ready.store(false, std::memory_order_relaxed);
      {
        std::unique_lock lock(main_temporal_command_list_mutex);
        main_temporal_command_lists.clear();
      }
      last_logged_dlss_success_key.store(
          kUnloggedTelemetryKey,
          std::memory_order_relaxed);
      evaluation_serial.store(0u, std::memory_order_relaxed);
      evaluation_serial_tracking_enabled.store(false, std::memory_order_relaxed);
      last_logged_evaluation_key.store(
          kUnloggedTelemetryKey,
          std::memory_order_relaxed);
      Log(
          reshade::log::level::info,
          "using Vulkan TLS command metadata; global ReShade state tracking is disabled.");
      reshade::register_event<reshade::addon_event::init_device>(
          OnInitSparseDescriptorDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(
          OnDestroySparseDescriptorDevice);
      reshade::register_event<reshade::addon_event::update_descriptor_tables>(
          OnUpdateSparseDescriptorTables);
      reshade::register_event<reshade::addon_event::copy_descriptor_tables>(
          OnCopySparseDescriptorTables);
      renodx::utils::command_action::Register(
          kTemporalDispatchCallback,
          {
              .shader_hash = supported_build::kTemporalAaShaderCrc,
              .command_types =
                  renodx::utils::command_action::COMMAND_TYPE_DISPATCH,
          });
      reshade::register_event<reshade::addon_event::destroy_command_list>(
          OnDestroyTemporalCommandList);
      reshade::register_event<reshade::addon_event::reset_command_list>(
          OnResetTemporalCommandList);
      break;
    }
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::reset_command_list>(
          OnResetTemporalCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(
          OnDestroyTemporalCommandList);
      renodx::utils::command_action::Unregister(kTemporalDispatchCallback);
      reshade::unregister_event<reshade::addon_event::copy_descriptor_tables>(
          OnCopySparseDescriptorTables);
      reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(
          OnUpdateSparseDescriptorTables);
      reshade::unregister_event<reshade::addon_event::destroy_device>(
          OnDestroySparseDescriptorDevice);
      reshade::unregister_event<reshade::addon_event::init_device>(
          OnInitSparseDescriptorDevice);
      // The Vulkan layer owns NGX/Vulkan teardown at vkDestroyDevice. Do not
      // call its ABI while the Windows loader lock is held here.
      mode_state.Reset();
      {
        std::unique_lock lock(main_temporal_command_list_mutex);
        main_temporal_command_lists.clear();
      }
      break;
  }
}

}  // namespace renodx::games::detroitbecomehuman::temporal_capture
