/*
 * SPDX-License-Identifier: MIT
 */

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#ifndef NOMINMAX
#define NOMINMAX
#endif
#ifndef VK_NO_PROTOTYPES
#define VK_NO_PROTOTYPES
#endif
#include <Windows.h>

#include <bcrypt.h>
#include <detours.h>

#include <vulkan/vulkan.h>

#include <nvsdk_ngx_helpers.h>
#include <nvsdk_ngx_helpers_vk.h>
#include <include/reshade.hpp>

#include <algorithm>
#include <array>
#include <atomic>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <format>
#include <limits>
#include <memory>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <string>
#include <string_view>
#include <type_traits>
#include <unordered_map>
#include <utility>
#include <vector>

#include "../dlss_bridge_abi.h"
#include "../supported_build.hpp"
#include "../taa_contract.hpp"
#include "adapter_runtime.hpp"
#include "embedded_bootstrap.hpp"
#include "evaluation_trace.hpp"
#include "feature_lifetime.hpp"
#include "feature_recording_registry.hpp"
#include "utils/dlss/ngx_vulkan.hpp"

namespace {

constexpr char kProjectId[] = "910b88f3-e60e-4c9d-a959-9a46b3e7dcc3";
constexpr char kEngineVersion[] = "Build12158144";
constexpr std::uint64_t kInstanceExtensionsEnabled = UINT64_C(1) << 0u;
constexpr std::uint64_t kDeviceExtensionsEnabled = UINT64_C(1) << 1u;
constexpr std::uint64_t kReflectedTemporalConstantsSize = 496u;
constexpr char kInternalFenceEnvironment[] =
    "RENODX_DETROIT_DLSS_INTERNAL_SUBMISSION_FENCES";
constexpr std::size_t kMaximumCachedExtensionListBytes = 16u * 1024u;
constexpr std::size_t kMaximumCachedExtensionCount = 64u;
constexpr std::uint64_t kMaximumTemporalConstantsShadowSize = 64u * 1024u;
constexpr std::size_t kTrackedDescriptorSetBloomWordCount = 64u;
constexpr std::size_t kMaximumInternalFeatureFencePoolSize = 8u;
constexpr std::size_t kMaximumAdapterScratchBundles = 8u;
// Lifecycle cleanup can make all eight bundles reusable before its stale
// exact-registry entries are removed. Keep room for both the retiring and the
// newly assigned owners without increasing the actual GPU scratch allocation.
constexpr std::size_t kMaximumFeatureRecordingCandidates =
    kMaximumAdapterScratchBundles * 2u;
constexpr std::uint32_t kRetiredFeatureFencePollSubmitInterval = 8u;
static_assert(
    (kRetiredFeatureFencePollSubmitInterval
     & (kRetiredFeatureFencePollSubmitInterval - 1u))
    == 0u);
constexpr std::array<std::uint32_t, DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT>
    kTemporalImageBindings = {0u, 1u, 2u, 3u, 4u, 5u, 6u, 7u, 9u, 16u, 17u, 18u, 19u};

using BootstrapStatus =
    renodx::games::detroitbecomehuman::dlss::embedded::BootstrapStatus;
using renodx::games::detroitbecomehuman::dlss::embedded::
    RestoreVulkanLayerDispatchPointer;

std::mutex bootstrap_mutex;
std::string cached_instance_extensions;
std::string cached_device_extensions;
std::atomic<BootstrapStatus> bootstrap_status = BootstrapStatus::kFirstRunSetup;
std::atomic<bool> executable_verified = false;
std::atomic<bool> hooks_attached = false;
std::atomic<bool> loaded_early = false;
std::atomic<bool> cached_extensions_ready = false;
std::atomic_uint64_t bootstrap_status_revision = 1u;
std::atomic<bool> runtime_command_tracking_enabled = false;
std::atomic<bool> native_command_hooks_installed = false;
std::atomic<std::uintptr_t> fast_command_dispatch_key = 0u;
std::atomic<PFN_vkBeginCommandBuffer> fast_begin_command_buffer = nullptr;
std::atomic<PFN_vkUpdateDescriptorSets> fast_update_descriptor_sets = nullptr;
[[maybe_unused]] std::atomic<PFN_vkCmdBindPipeline>
    fast_cmd_bind_pipeline = nullptr;
std::atomic<PFN_vkCmdBindDescriptorSets> fast_cmd_bind_descriptor_sets = nullptr;

static_assert(std::atomic<PFN_vkBeginCommandBuffer>::is_always_lock_free);
static_assert(std::atomic<PFN_vkUpdateDescriptorSets>::is_always_lock_free);
static_assert(std::atomic<PFN_vkCmdBindDescriptorSets>::is_always_lock_free);

PFN_vkCreateInstance reshade_create_instance = nullptr;
PFN_vkCreateDevice reshade_create_device = nullptr;
PFN_vkGetInstanceProcAddr reshade_get_instance_proc_addr = nullptr;
PFN_vkGetDeviceProcAddr reshade_get_device_proc_addr = nullptr;

void SetBootstrapStatus(BootstrapStatus status, std::string detail);

enum class BridgeDetail : std::uint32_t {
  kNone = 0u,
  kNoActiveDevice = 0xD1550001u,
  kUnsupportedExecutable = 0xD1550002u,
  kExtensionsUnavailable = 0xD1550003u,
  kNgxInitializationFailed = 0xD1550004u,
  kNgxCapabilityUnavailable = 0xD1550005u,
  kInvalidAbi = 0xD1550006u,
  kNotConfigured = 0xD1550007u,
  kNativeMode = 0xD1550008u,
  kTemporalContractUnverified = 0xD1550009u,
  kInvalidFrame = 0xD155000Au,
  kFeatureCreationFailed = 0xD155000Bu,
  kEvaluationFailed = 0xD155000Cu,
  kCommandStateUnrestorable = 0xD155000Du,
  kAdapterUnavailable = 0xD155000Eu,
  kAdapterPrepareFailed = 0xD155000Fu,
  kAdapterCommitFailed = 0xD1550010u,
  kDeviceIdentityMismatch = 0xD1550011u,
  kFeatureCreationPending = 0xD1550012u,
};

constexpr std::uint32_t kAdapterPrepareDetailBase = 0xD1551000u;
constexpr std::uint32_t kAdapterCommitDetailBase = 0xD1552000u;

HMODULE layer_module = nullptr;
std::mutex trace_mutex;
HANDLE trace_file = INVALID_HANDLE_VALUE;
std::atomic_bool fenceless_submission_logged = false;

template <typename Handle>
std::uint64_t ToOpaque(Handle handle) {
  if constexpr (std::is_pointer_v<Handle>) {
    return static_cast<std::uint64_t>(reinterpret_cast<std::uintptr_t>(handle));
  } else {
    return static_cast<std::uint64_t>(handle);
  }
}

template <typename Handle>
Handle FromOpaque(std::uint64_t handle) {
  if constexpr (std::is_pointer_v<Handle>) {
    return reinterpret_cast<Handle>(static_cast<std::uintptr_t>(handle));
  } else {
    return static_cast<Handle>(handle);
  }
}

template <typename Dispatchable>
std::uintptr_t DispatchKey(Dispatchable handle) {
  if (handle == VK_NULL_HANDLE) return 0u;
  return reinterpret_cast<std::uintptr_t>(*reinterpret_cast<void* const*>(handle));
}

std::wstring GetModulePath(HMODULE module) {
  std::vector<wchar_t> buffer(1024u);
  for (;;) {
    const DWORD length = GetModuleFileNameW(module, buffer.data(), static_cast<DWORD>(buffer.size()));
    if (length == 0u) return {};
    if (length < buffer.size() - 1u) return std::wstring(buffer.data(), length);
    buffer.resize(buffer.size() * 2u);
  }
}

std::wstring GetLayerDirectory() {
  const std::filesystem::path module_path(GetModulePath(layer_module));
  return module_path.empty() ? std::wstring() : module_path.parent_path().wstring();
}

void Trace(std::string_view message) {
  const auto directory = GetLayerDirectory();
  if (directory.empty()) return;
  const auto path = std::filesystem::path(directory) / L"DetroitDLSSBootstrap.log";
  const std::lock_guard lock(trace_mutex);
  if (trace_file == INVALID_HANDLE_VALUE) {
    trace_file = CreateFileW(
        path.c_str(),
        FILE_APPEND_DATA,
        FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
        nullptr,
        OPEN_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        nullptr);
  }
  if (trace_file == INVALID_HANDLE_VALUE) return;
  DWORD written = 0u;
  (void)WriteFile(
      trace_file,
      message.data(),
      static_cast<DWORD>(std::min<std::size_t>(message.size(), MAXDWORD)),
      &written,
      nullptr);
  static constexpr char newline[] = "\r\n";
  (void)WriteFile(trace_file, newline, 2u, &written, nullptr);
}

void TraceEvaluationMessage(
    std::string_view message,
    reshade::log::level level = reshade::log::level::info) noexcept {
  try {
    Trace(message);
    const std::string reshade_message =
        std::string("Detroit DLSS bridge: ") + std::string(message);
    reshade::log::message(level, reshade_message.c_str());
  } catch (...) {
    // Diagnostics must not change bridge control flow.
  }
}

void CloseTraceFile() {
  const std::lock_guard lock(trace_mutex);
  if (trace_file == INVALID_HANDLE_VALUE) return;
  (void)FlushFileBuffers(trace_file);
  CloseHandle(trace_file);
  trace_file = INVALID_HANDLE_VALUE;
}

struct EvaluationTraceConfiguration final {
  bool first_three = false;
  bool readback = false;
};

const EvaluationTraceConfiguration& GetEvaluationTraceConfiguration() {
  static const EvaluationTraceConfiguration configuration = [] {
    const auto module_path = std::filesystem::path(GetModulePath(layer_module));
    if (module_path.empty()) return EvaluationTraceConfiguration{};
    const auto ini_path = module_path.parent_path() / L"ReShade.ini";
    // Temporary diagnostic build: always trace exactly three DLAA attempts.
    const bool first_three = true;
    const bool readback = first_three
                          && GetPrivateProfileIntW(
                                 L"renodx-dev",
                                 L"DetroitDLSSTraceReadback",
                                 0,
                                 ini_path.c_str())
                                 == 1;
    return EvaluationTraceConfiguration{
        .first_three = first_three,
        .readback = readback,
    };
  }();
  return configuration;
}

enum class TraceNgxCall : std::uint8_t {
  kNone,
  kInitialize,
  kCreate,
  kEvaluate,
};

constexpr std::string_view TraceNgxCallName(TraceNgxCall call) noexcept {
  switch (call) {
    case TraceNgxCall::kNone:
      return "none";
    case TraceNgxCall::kInitialize:
      return "initialize";
    case TraceNgxCall::kCreate:
      return "create";
    case TraceNgxCall::kEvaluate:
      return "evaluate";
  }
  return "invalid_call";
}

struct EvaluationTraceRecord final {
  std::uint32_t trace_window = 0u;
  std::uint32_t attempt = 0u;
  std::uint64_t frame = 0u;
  DetroitDlssMode mode = DETROIT_DLSS_MODE_NATIVE;
  std::uint64_t recording_generation = 0u;
  std::uint64_t feature_generation = 0u;
  TraceNgxCall ngx_call = TraceNgxCall::kNone;
  NVSDK_NGX_Result ngx_result = NVSDK_NGX_Result_Success;
  VkResult vk_result = VK_SUCCESS;
  renodx::games::detroitbecomehuman::dlss::AdapterResult prepare = {};
  renodx::games::detroitbecomehuman::dlss::AdapterResult commit = {};
  std::uint64_t command_buffer = 0u;
  std::uint64_t consumer_image = 0u;
  std::uint64_t consumer_view = 0u;
  bool ngx_called = false;
  bool prepare_called = false;
  bool commit_called = false;
  bool readback_requested = false;
};

void TraceEvaluationTerminal(
    const EvaluationTraceRecord& record,
    renodx::games::detroitbecomehuman::dlss::EvaluationTerminal terminal) noexcept {
  if (record.attempt == 0u) return;
  try {
    TraceEvaluationMessage(std::format(
        "DLSS trace_window={} attempt={} terminal={} ngx_call={} ngx_called={} "
        "frame={} mode={} "
        "recording_generation={} feature_generation={} ngx_result={} vk_result={} "
        "prepare_called={} prepare_status={} prepare_detail={} prepare_vk={} "
        "commit_called={} commit_status={} commit_detail={} commit_vk={} "
        "command_buffer=0x{:X} consumer_binding=b16 consumer_image=0x{:X} "
        "consumer_view=0x{:X} readback_requested={}",
        record.trace_window,
        record.attempt,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminalName(terminal),
        TraceNgxCallName(record.ngx_call),
        record.ngx_called,
        record.frame,
        static_cast<std::uint32_t>(record.mode),
        record.recording_generation,
        record.feature_generation,
        static_cast<std::int32_t>(record.ngx_result),
        static_cast<std::int32_t>(record.vk_result),
        record.prepare_called,
        static_cast<std::uint32_t>(record.prepare.status),
        static_cast<std::uint32_t>(record.prepare.detail),
        static_cast<std::int32_t>(record.prepare.vk_result),
        record.commit_called,
        static_cast<std::uint32_t>(record.commit.status),
        static_cast<std::uint32_t>(record.commit.detail),
        static_cast<std::int32_t>(record.commit.vk_result),
        record.command_buffer,
        record.consumer_image,
        record.consumer_view,
        record.readback_requested),
        terminal
                == renodx::games::detroitbecomehuman::dlss::
                       EvaluationTerminal::kSuccess
            ? reshade::log::level::info
            : reshade::log::level::warning);
  } catch (...) {
    // Observability must never alter the post-pack success classification.
  }
}

void TraceEvaluationPhase(
    const EvaluationTraceRecord& record,
    std::string_view phase,
    std::string_view state = "begin") noexcept {
  if (record.attempt == 0u) return;
  try {
    TraceEvaluationMessage(std::format(
        "DLSS trace_window={} attempt={} event=phase phase={} state={} "
        "frame={} command_buffer=0x{:X} recording_generation={}",
        record.trace_window,
        record.attempt,
        phase,
        state,
        record.frame,
        record.command_buffer,
        record.recording_generation));
  } catch (...) {
    // Diagnostics must not change bridge control flow.
  }
}

void TraceEvaluationInputs(
    const EvaluationTraceRecord& record,
    const DetroitDlssTemporalFrameInputs& inputs) noexcept {
  if (record.attempt == 0u) return;
  try {
    TraceEvaluationMessage(std::format(
        "DLSS trace_window={} attempt={} event=bridge_input frame={} mode={} "
        "shader=0x{:08X} flags=0x{:X} verification=0x{:X} "
        "verification_missing=0x{:X} command_buffer=0x{:X} "
        "descriptor_set=0x{:X} pipeline_layout=0x{:X} pipeline=0x{:X} "
        "constants_buffer=0x{:X} constants_offset={} constants_size={} "
        "dynamic_offset={} render={}x{} output={}x{} reset={} "
        "jitter=({}, {}) mv_scale=({}, {}) pre_exposure={} sharpening={} "
        "normalization={} color=0x{:X}/0x{:X} depth=0x{:X}/0x{:X} "
        "mv=0x{:X}/0x{:X} exposure=0x{:X}/0x{:X} output=0x{:X}/0x{:X}",
        record.trace_window,
        record.attempt,
        inputs.frame_id,
        static_cast<std::uint32_t>(record.mode),
        inputs.shader_crc,
        inputs.flags,
        inputs.verification_flags,
        DETROIT_DLSS_VERIFY_MANDATORY_MASK & ~inputs.verification_flags,
        inputs.command_buffer,
        inputs.descriptor_set,
        inputs.pipeline_layout,
        inputs.compute_pipeline,
        inputs.constants_buffer,
        inputs.constants_offset,
        inputs.constants_size,
        inputs.constants_dynamic_offset,
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
        inputs.dlaa_sharpening_normalization,
        inputs.current_color.image,
        inputs.current_color.image_view,
        inputs.depth.image,
        inputs.depth.image_view,
        inputs.motion_vectors.image,
        inputs.motion_vectors.image_view,
        inputs.exposure.image,
        inputs.exposure.image_view,
        inputs.output.image,
        inputs.output.image_view));
  } catch (...) {
    // Diagnostics must not change bridge control flow.
  }
}

bool ForceInternalFeatureFences() {
  static const bool enabled = [] {
    std::array<char, 16u> value = {};
    const DWORD length = GetEnvironmentVariableA(
        kInternalFenceEnvironment,
        value.data(),
        static_cast<DWORD>(value.size()));
    if (length == 0u || length >= value.size()) return false;
    return _stricmp(value.data(), "1") == 0
           || _stricmp(value.data(), "true") == 0;
  }();
  return enabled;
}

std::wstring GetNgxDataDirectory() {
  DWORD required = GetEnvironmentVariableW(L"LOCALAPPDATA", nullptr, 0u);
  std::wstring base;
  if (required != 0u) {
    base.resize(required);
    const DWORD written = GetEnvironmentVariableW(L"LOCALAPPDATA", base.data(), required);
    if (written != 0u && written < required) base.resize(written);
  }
  if (base.empty()) base = GetLayerDirectory();

  const auto path = std::filesystem::path(base) / L"RenoDX" / L"DetroitBecomeHuman" / L"NGX";
  std::error_code error;
  std::filesystem::create_directories(path, error);
  return error ? base : path.wstring();
}

bool HashFileSha256(
    const std::filesystem::path& path, std::array<std::uint8_t, 32u>* digest) {
  if (digest == nullptr) return false;

  BCRYPT_ALG_HANDLE algorithm = nullptr;
  BCRYPT_HASH_HANDLE hash = nullptr;
  HANDLE file = INVALID_HANDLE_VALUE;
  std::vector<std::uint8_t> hash_object;
  bool success = false;
  do {
    if (BCryptOpenAlgorithmProvider(&algorithm, BCRYPT_SHA256_ALGORITHM, nullptr, 0u) < 0) break;
    DWORD object_size = 0u;
    DWORD copied = 0u;
    if (BCryptGetProperty(
            algorithm,
            BCRYPT_OBJECT_LENGTH,
            reinterpret_cast<PUCHAR>(&object_size),
            sizeof(object_size),
            &copied,
            0u)
        < 0) {
      break;
    }
    hash_object.resize(object_size);
    if (BCryptCreateHash(
            algorithm,
            &hash,
            hash_object.data(),
            static_cast<ULONG>(hash_object.size()),
            nullptr,
            0u,
            0u)
        < 0) {
      break;
    }

    file = CreateFileW(
        path.c_str(),
        GENERIC_READ,
        FILE_SHARE_READ | FILE_SHARE_DELETE,
        nullptr,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,
        nullptr);
    if (file == INVALID_HANDLE_VALUE) break;

    std::array<std::uint8_t, 64u * 1024u> buffer = {};
    for (;;) {
      DWORD bytes_read = 0u;
      if (ReadFile(file, buffer.data(), static_cast<DWORD>(buffer.size()), &bytes_read, nullptr)
          == FALSE) {
        break;
      }
      if (bytes_read == 0u) {
        success = BCryptFinishHash(
                      hash, digest->data(), static_cast<ULONG>(digest->size()), 0u)
                  >= 0;
        break;
      }
      if (BCryptHashData(hash, buffer.data(), bytes_read, 0u) < 0) break;
    }
  } while (false);

  if (file != INVALID_HANDLE_VALUE) CloseHandle(file);
  if (hash != nullptr) BCryptDestroyHash(hash);
  if (algorithm != nullptr) BCryptCloseAlgorithmProvider(algorithm, 0u);
  return success;
}

bool CheckSupportedHostExecutable() {
  const std::filesystem::path executable(GetModulePath(nullptr));
  if (_wcsicmp(
          executable.filename().c_str(),
          std::filesystem::path(
              renodx::games::detroitbecomehuman::supported_build::kExecutableName)
              .wstring()
              .c_str())
      != 0) {
    return false;
  }

  WIN32_FILE_ATTRIBUTE_DATA attributes = {};
  if (GetFileAttributesExW(executable.c_str(), GetFileExInfoStandard, &attributes) == FALSE) {
    return false;
  }
  const std::uint64_t size =
      static_cast<std::uint64_t>(attributes.nFileSizeHigh) << 32u | attributes.nFileSizeLow;
  if (size != renodx::games::detroitbecomehuman::supported_build::kExecutableSize) return false;

  std::array<std::uint8_t, 32u> digest = {};
  return HashFileSha256(executable, &digest)
         && renodx::games::detroitbecomehuman::supported_build::MatchesExecutableIdentity(
             size, digest);
}

bool IsSupportedHostExecutable() {
  static std::once_flag once;
  static bool supported = false;
  std::call_once(once, [] { supported = CheckSupportedHostExecutable(); });
  return supported;
}

struct NgxDiscovery {
  std::wstring feature_path = GetLayerDirectory();
  std::wstring data_path = GetNgxDataDirectory();
  const wchar_t* feature_paths[1] = {feature_path.c_str()};
  NVSDK_NGX_FeatureCommonInfo feature_info = {};
  NVSDK_NGX_FeatureDiscoveryInfo discovery_info = {};

  NgxDiscovery() {
    feature_info.PathListInfo.Path = feature_paths;
    feature_info.PathListInfo.Length = 1u;

    discovery_info.SDKVersion = NVSDK_NGX_Version_API;
    discovery_info.FeatureID = NVSDK_NGX_Feature_SuperSampling;
    discovery_info.Identifier.IdentifierType = NVSDK_NGX_Application_Identifier_Type_Project_Id;
    discovery_info.Identifier.v.ProjectDesc.ProjectId = kProjectId;
    discovery_info.Identifier.v.ProjectDesc.EngineType = NVSDK_NGX_ENGINE_TYPE_CUSTOM;
    discovery_info.Identifier.v.ProjectDesc.EngineVersion = kEngineVersion;
    discovery_info.ApplicationDataPath = data_path.c_str();
    discovery_info.FeatureInfo = &feature_info;
  }
};

struct InstanceState {
  VkInstance instance = VK_NULL_HANDLE;
  PFN_vkGetInstanceProcAddr next_get_instance_proc_addr = nullptr;
  bool ngx_extensions_enabled = false;
};

struct DescriptorLayoutBinding {
  std::uint32_t binding = 0u;
  VkDescriptorType descriptor_type = VK_DESCRIPTOR_TYPE_MAX_ENUM;
  std::uint32_t descriptor_count = 0u;
};

struct DescriptorSetLayoutState {
  std::vector<DescriptorLayoutBinding> bindings;
  bool temporal_candidate = false;
  bool dof_composite_candidate = false;
};

struct PipelineLayoutState {
  std::vector<VkDescriptorSetLayout> set_layouts;
  std::vector<VkPushConstantRange> push_constant_ranges;
};

struct BufferDescriptorState {
  VkDescriptorType descriptor_type = VK_DESCRIPTOR_TYPE_MAX_ENUM;
  VkBuffer buffer = VK_NULL_HANDLE;
  VkDeviceSize offset = 0u;
  VkDeviceSize range = 0u;
  DetroitDlssDescriptorSourceFlags source_flags = 0u;
  std::uint64_t update_serial = 0u;
};

struct ImageDescriptorState {
  VkDescriptorType descriptor_type = VK_DESCRIPTOR_TYPE_MAX_ENUM;
  VkSampler sampler = VK_NULL_HANDLE;
  VkImageView image_view = VK_NULL_HANDLE;
  VkImageLayout image_layout = VK_IMAGE_LAYOUT_UNDEFINED;
  DetroitDlssDescriptorSourceFlags source_flags = 0u;
  std::uint64_t update_serial = 0u;
};

struct DescriptorSetState {
  VkDescriptorPool pool = VK_NULL_HANDLE;
  VkDescriptorSetLayout layout = VK_NULL_HANDLE;
  std::unordered_map<std::uint64_t, BufferDescriptorState> buffer_descriptors;
  std::unordered_map<std::uint64_t, ImageDescriptorState> image_descriptors;
};

struct BufferState {
  VkDeviceSize size = 0u;
  VkBufferUsageFlags usage = 0u;
  VkDeviceMemory memory = VK_NULL_HANDLE;
  VkDeviceSize memory_offset = 0u;
  bool temporal_constants_candidate = false;
  std::vector<std::uint8_t> shadow_bytes;
  std::vector<std::uint8_t> shadow_valid_bytes;
  std::vector<VkDeviceSize> temporal_slot_offsets;
  std::vector<std::uint64_t> temporal_slot_hashes;
  std::vector<VkDeviceSize> temporal_slot_scratch_offsets;
  std::vector<std::uint64_t> temporal_slot_scratch_hashes;
  bool temporal_slot_hashes_primed = false;
};

struct ImageState {
  VkImageCreateFlags flags = 0u;
  VkImageType type = VK_IMAGE_TYPE_2D;
  VkFormat format = VK_FORMAT_UNDEFINED;
  VkExtent3D extent = {};
  std::uint32_t mip_levels = 0u;
  std::uint32_t array_layers = 0u;
  VkSampleCountFlagBits samples = VK_SAMPLE_COUNT_1_BIT;
  VkImageUsageFlags usage = 0u;
};

struct ImageViewState {
  VkImage image = VK_NULL_HANDLE;
  VkImageViewType type = VK_IMAGE_VIEW_TYPE_2D;
  VkFormat format = VK_FORMAT_UNDEFINED;
  VkImageSubresourceRange subresource_range = {};
};

struct MemoryState {
  VkDeviceSize allocation_size = 0u;
  std::uint32_t memory_type_index = 0u;
  VkMemoryPropertyFlags property_flags = 0u;
  void* mapped_pointer = nullptr;
  VkDeviceSize mapped_offset = 0u;
  VkDeviceSize mapped_size = 0u;
  std::vector<std::uint64_t> temporal_uniform_buffers;
};

struct BoundDescriptorState {
  VkDescriptorSet descriptor_set = VK_NULL_HANDLE;
  VkPipelineLayout pipeline_layout = VK_NULL_HANDLE;
  VkDeviceSize dynamic_offset = 0u;
  bool dynamic_offset_valid = false;
};

struct ComputeCommandRestoreState {
  VkPipeline pipeline = VK_NULL_HANDLE;
  VkPipelineLayout descriptor_layout = VK_NULL_HANDLE;
  std::uint32_t first_set = 0u;
  std::vector<VkDescriptorSet> descriptor_sets;
  std::vector<std::uint32_t> dynamic_offsets;
  std::uint64_t recording_generation = 0u;
  bool one_time_submit = false;
};

struct DofCompositeCommandState {
  VkPipeline pipeline = VK_NULL_HANDLE;
  VkPipelineLayout pipeline_layout = VK_NULL_HANDLE;
  VkDescriptorSet descriptor_set = VK_NULL_HANDLE;
  std::uint32_t dynamic_offset = 0u;
  bool dynamic_offset_valid = false;
};

struct CommandPoolState {
  std::uint32_t queue_family_index = std::numeric_limits<std::uint32_t>::max();
  VkCommandPoolCreateFlags flags = 0u;
};

struct FencedFeatureSubmission {
  std::uint64_t queue = 0u;
  renodx::games::detroitbecomehuman::dlss::FeatureLifetimeTracker::
      SubmissionSnapshot snapshot;
  bool owned_by_layer = false;
};

struct DynamicDescriptorTemplateEntry {
  std::size_t offset = 0u;
};

struct NarrowBufferMemoryBinding {
  VkDeviceMemory memory = VK_NULL_HANDLE;
  VkDeviceSize offset = 0u;
};

struct NarrowMappedMemory {
  const void* pointer = nullptr;
  VkDeviceSize offset = 0u;
  VkDeviceSize size = 0u;
};

struct DeviceState {
  VkInstance instance = VK_NULL_HANDLE;
  VkPhysicalDevice physical_device = VK_NULL_HANDLE;
  VkDevice device = VK_NULL_HANDLE;
  VkQueue graphics_queue = VK_NULL_HANDLE;
  std::uint32_t graphics_queue_family = std::numeric_limits<std::uint32_t>::max();
  std::uint32_t graphics_queue_index = 0u;
  PFN_vkGetInstanceProcAddr next_get_instance_proc_addr = nullptr;
  PFN_vkGetDeviceProcAddr next_get_device_proc_addr = nullptr;
  PFN_vkUpdateDescriptorSets next_update_descriptor_sets = nullptr;
  PFN_vkCreateDescriptorUpdateTemplate next_create_descriptor_update_template = nullptr;
  PFN_vkDestroyDescriptorUpdateTemplate next_destroy_descriptor_update_template = nullptr;
  PFN_vkUpdateDescriptorSetWithTemplate next_update_descriptor_set_with_template = nullptr;
  PFN_vkBindBufferMemory next_bind_buffer_memory = nullptr;
  PFN_vkBindBufferMemory2 next_bind_buffer_memory2 = nullptr;
  PFN_vkDestroyBuffer next_destroy_buffer = nullptr;
  PFN_vkFreeMemory next_free_memory = nullptr;
  PFN_vkMapMemory next_map_memory = nullptr;
  PFN_vkUnmapMemory next_unmap_memory = nullptr;
  PFN_vkBeginCommandBuffer next_begin_command_buffer = nullptr;
  PFN_vkEndCommandBuffer next_end_command_buffer = nullptr;
  PFN_vkResetCommandBuffer next_reset_command_buffer = nullptr;
  PFN_vkQueueSubmit next_queue_submit = nullptr;
#if defined(VK_VERSION_1_3)
  PFN_vkQueueSubmit2 next_queue_submit2 = nullptr;
#endif
#if defined(VK_KHR_synchronization2)
  PFN_vkQueueSubmit2KHR next_queue_submit2_khr = nullptr;
#endif
  PFN_vkQueueWaitIdle next_queue_wait_idle = nullptr;
  PFN_vkDeviceWaitIdle next_device_wait_idle = nullptr;
  PFN_vkWaitForFences next_wait_for_fences = nullptr;
  PFN_vkGetFenceStatus next_get_fence_status = nullptr;
  PFN_vkResetFences next_reset_fences = nullptr;
  PFN_vkCreateFence next_create_fence = nullptr;
  PFN_vkDestroyFence next_destroy_fence = nullptr;
  PFN_vkCmdPipelineBarrier next_cmd_pipeline_barrier = nullptr;
  PFN_vkCreateCommandPool next_create_command_pool = nullptr;
  PFN_vkAllocateCommandBuffers next_allocate_command_buffers = nullptr;
  PFN_vkFreeCommandBuffers next_free_command_buffers = nullptr;
  PFN_vkResetCommandPool next_reset_command_pool = nullptr;
  PFN_vkDestroyCommandPool next_destroy_command_pool = nullptr;
  PFN_vkCmdBindPipeline next_cmd_bind_pipeline = nullptr;
  PFN_vkCmdBindDescriptorSets next_cmd_bind_descriptor_sets = nullptr;
  PFN_vkCmdPushConstants next_cmd_push_constants = nullptr;
  bool supported_executable = false;
  bool ngx_extensions_enabled = false;
  bool adapter_available = false;
  bool configured = false;
  std::uint64_t identity = 0u;
  std::uint64_t context_identity = 0u;
  std::uint64_t configured_identity = 0u;
  std::atomic<bool> destroying = false;
  DetroitDlssModeSettings settings = {};
  std::unique_ptr<NgxDiscovery> ngx_discovery;
  std::unique_ptr<renodx::utils::dlss::vulkan::NgxContext> ngx_context;
  renodx::utils::dlss::vulkan::OperationResult last_ngx_initialization = {};
  std::atomic<bool> feature_evaluation_active = false;
  std::atomic<bool> feature_submission_tracking_active = false;
  std::atomic<bool> feature_lifecycle_tracking_active = false;
  std::atomic<bool> internal_feature_fences_pending = false;
  std::atomic<std::uint32_t> retired_feature_fence_poll_serial = 0u;
  // False-positive-only filter for command buffers that have ever recorded
  // NGX work. A missing bit proves an arbitrary submission cannot reference a
  // feature and keeps that hot path allocation- and lock-free.
  std::atomic<std::uint64_t> feature_command_buffer_bloom = 0u;
  renodx::games::detroitbecomehuman::dlss::FeatureRecordingRegistry<
      kMaximumFeatureRecordingCandidates>
      feature_recording_candidates;
  std::unordered_map<std::uint64_t, FencedFeatureSubmission>
      fenced_feature_submissions;
  std::vector<VkFence> available_internal_feature_fences;
  bool logged_one_time_feature_submission = false;
  bool logged_reusable_feature_submission = false;
  bool ngx_shutdown_requested = false;
  renodx::games::detroitbecomehuman::dlss::AdapterRuntime adapter_runtime;
  std::atomic<std::uint64_t> last_adapter_failure = 0u;
  std::atomic<std::uint64_t> last_ngx_failure = 0u;
  renodx::games::detroitbecomehuman::dlss::FirstThreeAttemptWindow
      evaluation_trace_window;
  renodx::games::detroitbecomehuman::dlss::SubmissionTraceTracker
      submission_trace_tracker;
  // BridgeEvaluate holds mutex while this reusable snapshot is populated and
  // consumed, so steady-state evaluation does not allocate copies of the
  // command buffer's descriptor and dynamic-offset vectors every frame.
  ComputeCommandRestoreState evaluation_restore_state;
  std::mutex mutex;
  std::mutex queue_mutex;

  std::shared_mutex descriptor_template_mutex;
  std::unordered_map<std::uint64_t, DynamicDescriptorTemplateEntry>
      dynamic_descriptor_templates;
  std::shared_mutex mapped_buffer_mutex;
  std::unordered_map<std::uint64_t, NarrowBufferMemoryBinding>
      narrow_buffer_bindings;
  std::unordered_map<std::uint64_t, NarrowMappedMemory> narrow_mapped_memories;

  VkPhysicalDeviceMemoryProperties memory_properties = {};
  VkDeviceSize min_uniform_buffer_offset_alignment = 1u;
  std::mutex tracking_mutex;
  // False-positive-only filter for command buffers with shared temporal or
  // DOF recording metadata. Ordinary recordings stay thread-local.
  std::atomic<std::uint64_t> published_command_buffer_bloom = 0u;
  std::unordered_map<std::uint64_t, DescriptorSetLayoutState> descriptor_set_layouts;
  std::unordered_map<std::uint64_t, PipelineLayoutState> pipeline_layouts;
  std::unordered_map<std::uint64_t, DescriptorSetState> descriptor_sets;
  std::unordered_map<std::uint64_t, BufferState> buffers;
  std::unordered_map<std::uint64_t, ImageState> images;
  std::unordered_map<std::uint64_t, ImageViewState> image_views;
  std::unordered_map<std::uint64_t, MemoryState> memories;
  std::unordered_map<
      std::uint64_t,
      std::unordered_map<std::uint64_t, BoundDescriptorState>>
      command_buffer_descriptors;
  std::unordered_map<std::uint64_t, ComputeCommandRestoreState>
      command_buffer_restore_states;
  std::unordered_map<std::uint64_t, DofCompositeCommandState>
      command_buffer_dof_composite_states;
  std::unordered_map<std::uint64_t, std::vector<VkCommandBuffer>>
      command_pool_buffers;
  std::unordered_map<std::uint64_t, CommandPoolState> command_pools;
  std::unordered_map<std::uint64_t, std::uint64_t> command_buffer_pools;
  std::unordered_map<std::uint64_t, VkCommandBufferLevel> command_buffer_levels;
  std::unordered_map<std::uint64_t, VkCommandBufferUsageFlags>
      command_buffer_usage_flags;
  std::unordered_map<std::uint64_t, std::uint64_t>
      command_buffer_recording_generations;
  std::uint64_t next_recording_generation = 1u;
  std::uint64_t descriptor_update_serial = 0u;
  // False-positive-only union of temporal and DOF descriptor-set candidates.
  // The exact layout is still checked under tracking_mutex on a filter hit.
  std::array<std::atomic<std::uint64_t>, kTrackedDescriptorSetBloomWordCount>
      tracked_descriptor_set_bloom = {};
};

BridgeDetail MakeAdapterBridgeDetail(
    bool preparing,
    renodx::games::detroitbecomehuman::dlss::AdapterDetail detail) {
  const std::uint32_t base = preparing ? kAdapterPrepareDetailBase : kAdapterCommitDetailBase;
  return static_cast<BridgeDetail>(base | (static_cast<std::uint32_t>(detail) & 0xFFu));
}

void TraceAdapterFailureOnce(
    DeviceState* state,
    bool preparing,
    const renodx::games::detroitbecomehuman::dlss::AdapterResult& result) {
  if (state == nullptr) return;
  const std::uint64_t stage = preparing ? 1u : 2u;
  const std::uint64_t key = stage << 56u
                            | static_cast<std::uint64_t>(result.detail) << 32u
                            | static_cast<std::uint32_t>(result.vk_result);
  if (state->last_adapter_failure.exchange(key, std::memory_order_acq_rel) == key) return;

  std::string message = preparing ? "DLSS adapter prepare failed" : "DLSS adapter commit failed";
  message += ": status ";
  message += std::to_string(static_cast<std::uint32_t>(result.status));
  message += ", detail ";
  message += std::to_string(static_cast<std::uint32_t>(result.detail));
  message += ", VkResult ";
  message += std::to_string(static_cast<std::int32_t>(result.vk_result));
  Trace(message);
}

void TraceNgxFailureOnce(
    DeviceState* state,
    std::uint32_t stage,
    std::string_view stage_name,
    NVSDK_NGX_Result ngx_result) {
  if (state == nullptr) return;
  const std::uint64_t key = static_cast<std::uint64_t>(stage) << 32u
                            | static_cast<std::uint32_t>(ngx_result);
  if (state->last_ngx_failure.exchange(key, std::memory_order_acq_rel) == key) return;

  std::string message = "DLSS NGX ";
  message.append(stage_name);
  message += " failed: result ";
  message += std::to_string(static_cast<std::int32_t>(ngx_result));
  Trace(message);
}

std::mutex state_mutex;
std::unordered_map<std::uintptr_t, std::shared_ptr<InstanceState>> instances;
std::unordered_map<std::uintptr_t, std::shared_ptr<DeviceState>> devices;
std::weak_ptr<DeviceState> active_device;
std::atomic<std::uint64_t> active_device_identity = 0u;
std::atomic<std::uint64_t> device_registry_generation = 1u;
std::atomic<std::uint64_t> next_device_identity = 1u;

std::shared_ptr<InstanceState> FindInstance(VkInstance instance) {
  const std::lock_guard lock(state_mutex);
  const auto found = instances.find(DispatchKey(instance));
  return found == instances.end() ? nullptr : found->second;
}

std::shared_ptr<InstanceState> FindInstance(VkPhysicalDevice physical_device) {
  const std::lock_guard lock(state_mutex);
  const auto found = instances.find(DispatchKey(physical_device));
  return found == instances.end() ? nullptr : found->second;
}

std::shared_ptr<DeviceState> FindDevice(VkDevice device) {
  const std::lock_guard lock(state_mutex);
  const auto found = devices.find(DispatchKey(device));
  return found == devices.end() ? nullptr : found->second;
}

template <typename Dispatchable>
const std::shared_ptr<DeviceState>& FindDeviceCached(Dispatchable handle) {
  struct ThreadCache {
    std::uintptr_t dispatch_key = 0u;
    std::uint64_t generation = 0u;
    std::shared_ptr<DeviceState> state;
  };
  thread_local ThreadCache cache;

  const std::uintptr_t dispatch_key = DispatchKey(handle);
  const std::uint64_t generation =
      device_registry_generation.load(std::memory_order_acquire);
  if (cache.dispatch_key == dispatch_key && cache.generation == generation) {
    return cache.state;
  }

  const std::lock_guard lock(state_mutex);
  const auto found = devices.find(dispatch_key);
  cache.dispatch_key = dispatch_key;
  cache.generation = device_registry_generation.load(std::memory_order_relaxed);
  cache.state = found == devices.end() ? nullptr : found->second;
  return cache.state;
}

template <typename Dispatchable>
DeviceState* FindDeviceFast(Dispatchable handle) {
  return FindDeviceCached(handle).get();
}

template <typename Dispatchable>
std::shared_ptr<DeviceState> FindDeviceSharedFast(Dispatchable handle) {
  return FindDeviceCached(handle);
}

struct ThreadComputeCommandState {
  std::uint64_t command_buffer = 0u;
  VkPipeline pipeline = VK_NULL_HANDLE;
  VkPipelineLayout descriptor_layout = VK_NULL_HANDLE;
  VkDescriptorSet descriptor_set = VK_NULL_HANDLE;
  std::uint32_t constants_dynamic_offset = 0u;
  VkCommandBufferUsageFlags begin_flags = 0u;
  std::uint64_t recording_generation = 0u;
  bool recording_active = false;
  bool descriptor_bound_after_begin = false;
  bool evaluation_claimed = false;
  bool temporal_descriptor_set_bound = false;
  bool dof_composite_descriptor_set_bound = false;
};

struct ThreadDynamicDescriptorUpdateScope {
  VkDevice device = VK_NULL_HANDLE;
  std::uint32_t write_count = 0u;
  const VkWriteDescriptorSet* writes = nullptr;
  VkDescriptorSet template_descriptor_set = VK_NULL_HANDLE;
  VkDescriptorUpdateTemplate descriptor_update_template = VK_NULL_HANDLE;
  const void* template_data = nullptr;
};

ThreadDynamicDescriptorUpdateScope& GetCurrentDynamicDescriptorUpdateScope() {
  thread_local ThreadDynamicDescriptorUpdateScope scope;
  return scope;
}

ThreadComputeCommandState& GetCurrentThreadComputeCommandState() {
  thread_local ThreadComputeCommandState state;
  return state;
}

bool ReadCommandRecordingMetadata(
    std::uint64_t command_buffer,
    std::uint64_t pipeline_layout,
    std::uint64_t descriptor_set,
    bool claim_evaluation,
    renodx::games::detroitbecomehuman::dlss::embedded::
        CommandRecordingMetadata* metadata) {
  if (metadata == nullptr) return false;
  *metadata = {};
  auto& local = GetCurrentThreadComputeCommandState();
  if (command_buffer == 0u || pipeline_layout == 0u || descriptor_set == 0u
      || !local.recording_active || !local.descriptor_bound_after_begin
      || local.recording_generation == 0u
      || local.command_buffer != command_buffer
      || ToOpaque(local.descriptor_layout) != pipeline_layout
      || ToOpaque(local.descriptor_set) != descriptor_set
      || (claim_evaluation && local.evaluation_claimed)) {
    return false;
  }
  if (claim_evaluation) local.evaluation_claimed = true;
  *metadata = {
      .command_buffer = command_buffer,
      .pipeline_layout = pipeline_layout,
      .descriptor_set = descriptor_set,
      .recording_generation = local.recording_generation,
      .begin_flags = local.begin_flags,
      .constants_dynamic_offset = local.constants_dynamic_offset,
      .descriptor_bound_after_begin = true,
      .evaluation_claimed = local.evaluation_claimed,
  };
  return true;
}

class ThreadComputeCommandStates final {
 public:
  ThreadComputeCommandState& operator[](std::uint64_t command_buffer) {
    if (cached_command_buffer_ == command_buffer && cached_state_ != nullptr) {
      return *cached_state_;
    }
    auto [entry, inserted] = states_.try_emplace(command_buffer);
    (void)inserted;
    cached_command_buffer_ = command_buffer;
    // Rehash invalidates iterators, but unordered_map keeps references and
    // pointers to elements valid. Erase explicitly invalidates this cache.
    cached_state_ = &entry->second;
    return *cached_state_;
  }

  ThreadComputeCommandState& BeginRecording(
      std::uint64_t command_buffer, VkCommandBufferUsageFlags begin_flags) {
    auto& state = (*this)[command_buffer];
    state = {};
    state.begin_flags = begin_flags;
    state.recording_active = true;
    return state;
  }

  ThreadComputeCommandState* Find(std::uint64_t command_buffer) {
    if (cached_command_buffer_ == command_buffer && cached_state_ != nullptr) {
      return cached_state_;
    }
    const auto found = states_.find(command_buffer);
    if (found == states_.end()) return nullptr;
    cached_command_buffer_ = command_buffer;
    cached_state_ = &found->second;
    return cached_state_;
  }

  void ResetRecording(std::uint64_t command_buffer) {
    if (auto* state = Find(command_buffer); state != nullptr) {
      *state = {};
    }
  }

  std::size_t erase(std::uint64_t command_buffer) {
    if (cached_command_buffer_ == command_buffer) {
      cached_command_buffer_ = 0u;
      cached_state_ = nullptr;
    }
    return states_.erase(command_buffer);
  }

 private:
  std::unordered_map<std::uint64_t, ThreadComputeCommandState> states_;
  std::uint64_t cached_command_buffer_ = 0u;
  ThreadComputeCommandState* cached_state_ = nullptr;
};

ThreadComputeCommandStates& GetThreadComputeCommandStates() {
  thread_local ThreadComputeCommandStates states;
  return states;
}

constexpr std::uint64_t DescriptorSlotKey(
    std::uint32_t binding, std::uint32_t array_element) {
  return static_cast<std::uint64_t>(binding) << 32u | array_element;
}

constexpr std::uint64_t CommandDescriptorKey(
    std::uint32_t set_index, std::uint32_t binding) {
  return static_cast<std::uint64_t>(set_index) << 32u | binding;
}

bool IsBufferDescriptorType(VkDescriptorType descriptor_type) {
  return descriptor_type == VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER
         || descriptor_type == VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC
         || descriptor_type == VK_DESCRIPTOR_TYPE_STORAGE_BUFFER
         || descriptor_type == VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC;
}

bool IsDynamicBufferDescriptorType(VkDescriptorType descriptor_type) {
  return descriptor_type == VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC
         || descriptor_type == VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC;
}

bool IsImageDescriptorType(VkDescriptorType descriptor_type) {
  return descriptor_type == VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER
         || descriptor_type == VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE
         || descriptor_type == VK_DESCRIPTOR_TYPE_STORAGE_IMAGE
         || descriptor_type == VK_DESCRIPTOR_TYPE_INPUT_ATTACHMENT;
}

constexpr std::uint64_t BindingMask(std::uint32_t binding) {
  return binding < 64u ? UINT64_C(1) << binding : 0u;
}

constexpr std::uint32_t MipExtent(std::uint32_t extent, std::uint32_t mip_level) {
  return mip_level >= 32u ? 1u : std::max(extent >> mip_level, 1u);
}

const DescriptorLayoutBinding* FindLayoutBinding(
    const DescriptorSetLayoutState& layout, std::uint32_t binding) {
  const auto found = std::lower_bound(
      layout.bindings.begin(),
      layout.bindings.end(),
      binding,
      [](const DescriptorLayoutBinding& candidate, std::uint32_t value) {
        return candidate.binding < value;
      });
  return found != layout.bindings.end() && found->binding == binding ? &*found : nullptr;
}

bool IsSampledImageDescriptorType(VkDescriptorType descriptor_type) {
  return descriptor_type == VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER
         || descriptor_type == VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
}

bool IsTemporalDescriptorSetLayout(const DescriptorSetLayoutState& layout) {
  for (std::uint32_t binding = 0u; binding <= 7u; ++binding) {
    const auto* reflected = FindLayoutBinding(layout, binding);
    if (reflected == nullptr || reflected->descriptor_count == 0u
        || !IsSampledImageDescriptorType(reflected->descriptor_type)) {
      return false;
    }
  }
  for (std::uint32_t binding = 16u; binding <= 19u; ++binding) {
    const auto* reflected = FindLayoutBinding(layout, binding);
    if (reflected == nullptr || reflected->descriptor_count == 0u
        || reflected->descriptor_type != VK_DESCRIPTOR_TYPE_STORAGE_IMAGE) {
      return false;
    }
  }
  const auto* constants =
      FindLayoutBinding(layout, DETROIT_DLSS_TAA_CONSTANT_BINDING_52);
  return constants != nullptr && constants->descriptor_count != 0u
         && constants->descriptor_type == VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC;
}

bool IsDofCompositeDescriptorSetLayout(const DescriptorSetLayoutState& layout) {
  // Exact reflection contract of Detroit Build 12158144 shader 0xAC7A8193:
  // sampled images b0-b5, one storage image b16 and the dynamic UBO at b52.
  // Requiring the complete shape keeps unrelated compute descriptors out of
  // the narrow Retinal snapshot path.
  if (layout.bindings.size() != 8u) return false;
  for (std::uint32_t binding = 0u; binding <= 5u; ++binding) {
    const auto* reflected = FindLayoutBinding(layout, binding);
    if (reflected == nullptr || reflected->descriptor_count != 1u
        || reflected->descriptor_type
            != VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER) {
      return false;
    }
  }
  const auto* output = FindLayoutBinding(layout, 16u);
  const auto* constants = FindLayoutBinding(layout, 52u);
  return output != nullptr && output->descriptor_count == 1u
         && output->descriptor_type == VK_DESCRIPTOR_TYPE_STORAGE_IMAGE
         && constants != nullptr && constants->descriptor_count == 1u
         && constants->descriptor_type == VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC;
}

bool HasDofCompositePushConstantRange(const PipelineLayoutState& layout) {
  if (layout.push_constant_ranges.size() != 1u) return false;
  const auto& range = layout.push_constant_ranges[0u];
  return range.offset == 0u && range.size == 112u
      && (range.stageFlags & VK_SHADER_STAGE_COMPUTE_BIT) != 0u;
}

std::size_t TrackedDescriptorSetBloomBit(std::uint64_t descriptor_set) {
  descriptor_set ^= descriptor_set >> 33u;
  descriptor_set *= UINT64_C(0xFF51AFD7ED558CCD);
  descriptor_set ^= descriptor_set >> 33u;
  return static_cast<std::size_t>(
      descriptor_set % (kTrackedDescriptorSetBloomWordCount * 64u));
}

void MarkTrackedDescriptorSet(DeviceState* state, VkDescriptorSet descriptor_set) {
  const std::size_t bit = TrackedDescriptorSetBloomBit(ToOpaque(descriptor_set));
  state->tracked_descriptor_set_bloom[bit / 64u].fetch_or(
      UINT64_C(1) << (bit % 64u), std::memory_order_release);
}

bool MayBeTrackedDescriptorSet(
    const DeviceState& state, VkDescriptorSet descriptor_set) {
  if (descriptor_set == VK_NULL_HANDLE) return false;
  const std::size_t bit = TrackedDescriptorSetBloomBit(ToOpaque(descriptor_set));
  return (state.tracked_descriptor_set_bloom[bit / 64u].load(
              std::memory_order_acquire)
          & (UINT64_C(1) << (bit % 64u)))
         != 0u;
}

std::vector<std::uint64_t> EnumerateDescriptorSlots(
    const DescriptorSetLayoutState& layout,
    std::uint32_t first_binding,
    std::uint32_t first_array_element,
    std::uint32_t descriptor_count,
    VkDescriptorType descriptor_type) {
  std::vector<std::uint64_t> slots;
  slots.reserve(descriptor_count);
  auto binding = std::lower_bound(
      layout.bindings.begin(),
      layout.bindings.end(),
      first_binding,
      [](const DescriptorLayoutBinding& candidate, std::uint32_t value) {
        return candidate.binding < value;
      });
  if (binding == layout.bindings.end() || binding->binding != first_binding) return {};

  std::uint32_t array_element = first_array_element;
  while (slots.size() < descriptor_count && binding != layout.bindings.end()) {
    if (binding->descriptor_type != descriptor_type || array_element >= binding->descriptor_count) {
      return {};
    }
    while (array_element < binding->descriptor_count && slots.size() < descriptor_count) {
      slots.push_back(DescriptorSlotKey(binding->binding, array_element++));
    }
    ++binding;
    array_element = 0u;
  }
  return slots.size() == descriptor_count ? slots : std::vector<std::uint64_t>{};
}

std::shared_ptr<DeviceState> GetActiveDevice() {
  const std::lock_guard lock(state_mutex);
  return active_device.lock();
}

bool IsActiveDevice(const std::shared_ptr<DeviceState>& state) {
  return state != nullptr && state->identity != 0u
         && active_device_identity.load(std::memory_order_acquire)
                == state->identity;
}

bool ReadCachedNgxExtensions(
    bool instance_extensions,
    std::vector<std::string>* required_extensions) {
  if (required_extensions == nullptr) return false;
  std::string serialized;
  {
    const std::lock_guard lock(bootstrap_mutex);
    serialized = instance_extensions
                     ? cached_instance_extensions
                     : cached_device_extensions;
  }
  if (serialized.size() >= kMaximumCachedExtensionListBytes) return false;
  if (serialized.empty()) return true;

  std::string_view list(serialized);
  std::size_t start = 0u;
  while (start <= list.size()) {
    const auto end = list.find(';', start);
    const auto item = list.substr(
        start,
        end == std::string_view::npos ? list.size() - start : end - start);
    if (item.empty() || item.size() >= VK_MAX_EXTENSION_NAME_SIZE) return false;
    if (std::any_of(
            item.begin(), item.end(), [](char character) {
              return character < 0x21 || character > 0x7Eu;
            })) {
      return false;
    }
    if (std::none_of(
            required_extensions->begin(),
            required_extensions->end(),
            [item](const std::string& existing) { return existing == item; })) {
      required_extensions->emplace_back(item);
      if (required_extensions->size() > kMaximumCachedExtensionCount) return false;
    }
    if (end == std::string_view::npos) break;
    start = end + 1u;
  }
  return true;
}

bool BuildCachedExtensionList(
    std::uint32_t original_count,
    const char* const* original_names,
    const std::vector<std::string>& required,
    std::vector<std::string>* storage,
    std::vector<const char*>* enabled_names) {
  if (storage == nullptr || enabled_names == nullptr
      || (original_count != 0u && original_names == nullptr)) {
    return false;
  }
  storage->reserve(static_cast<std::size_t>(original_count) + required.size());
  for (std::uint32_t index = 0u; index < original_count; ++index) {
    if (original_names[index] == nullptr || original_names[index][0] == '\0') return false;
    storage->emplace_back(original_names[index]);
  }
  for (const auto& name : required) {
    if (std::none_of(storage->begin(), storage->end(), [&name](const std::string& item) {
          return item == name;
        })) {
      storage->push_back(name);
    }
  }
  enabled_names->reserve(storage->size());
  for (const auto& name : *storage) enabled_names->push_back(name.c_str());
  return true;
}

bool PhysicalDeviceSupportsRequiredExtensions(
    PFN_vkGetInstanceProcAddr get_instance_proc_addr,
    VkInstance instance,
    VkPhysicalDevice physical_device,
    const std::vector<std::string>& required) {
  if (required.empty()) return true;
  if (get_instance_proc_addr == nullptr || instance == VK_NULL_HANDLE
      || physical_device == VK_NULL_HANDLE) {
    return false;
  }
  const auto enumerate = reinterpret_cast<PFN_vkEnumerateDeviceExtensionProperties>(
      get_instance_proc_addr(instance, "vkEnumerateDeviceExtensionProperties"));
  if (enumerate == nullptr) return false;

  std::vector<VkExtensionProperties> available;
  for (std::uint32_t attempt = 0u; attempt < 3u; ++attempt) {
    std::uint32_t count = 0u;
    if (enumerate(physical_device, nullptr, &count, nullptr) != VK_SUCCESS) return false;
    available.resize(count);
    const VkResult result = enumerate(
        physical_device,
        nullptr,
        &count,
        available.empty() ? nullptr : available.data());
    available.resize(count);
    if (result == VK_SUCCESS) break;
    if (result != VK_INCOMPLETE || attempt == 2u) return false;
  }

  return std::all_of(required.begin(), required.end(), [&available](const std::string& name) {
    return std::any_of(
        available.begin(),
        available.end(),
        [&name](const VkExtensionProperties& property) {
          return name == property.extensionName;
        });
  });
}

NVSDK_NGX_PerfQuality_Value ToNgxQuality() {
  return NVSDK_NGX_PerfQuality_Value_DLAA;
}

std::uint32_t ToNgxCreateFlags(DetroitDlssCreateFlags flags) {
  std::uint32_t ngx_flags = NVSDK_NGX_DLSS_Feature_Flags_None;
  if ((flags & DETROIT_DLSS_CREATE_HDR) != 0u) {
    ngx_flags |= NVSDK_NGX_DLSS_Feature_Flags_IsHDR;
  }
  if ((flags & DETROIT_DLSS_CREATE_MOTION_VECTORS_LOW_RESOLUTION) != 0u) {
    ngx_flags |= NVSDK_NGX_DLSS_Feature_Flags_MVLowRes;
  }
  if ((flags & DETROIT_DLSS_CREATE_DEPTH_INVERTED) != 0u) {
    ngx_flags |= NVSDK_NGX_DLSS_Feature_Flags_DepthInverted;
  }
  if ((flags & DETROIT_DLSS_CREATE_MOTION_VECTORS_JITTERED) != 0u) {
    ngx_flags |= NVSDK_NGX_DLSS_Feature_Flags_MVJittered;
  }
  if ((flags & DETROIT_DLSS_CREATE_AUTO_EXPOSURE) != 0u) {
    ngx_flags |= NVSDK_NGX_DLSS_Feature_Flags_AutoExposure;
  }
  return ngx_flags;
}

std::uint64_t CommandBufferBloomBit(std::uint64_t command_buffer) {
  command_buffer ^= command_buffer >> 33u;
  command_buffer *= UINT64_C(0xff51afd7ed558ccd);
  command_buffer ^= command_buffer >> 33u;
  return UINT64_C(1) << (command_buffer & 63u);
}

bool MayHavePublishedCommandBufferState(
    const DeviceState& state, std::uint64_t command_buffer) {
  return (state.published_command_buffer_bloom.load(std::memory_order_acquire)
          & CommandBufferBloomBit(command_buffer))
         != 0u;
}

void ClearPublishedCommandBufferBloomIfEmptyLocked(DeviceState* state) {
  if (state->command_buffer_descriptors.empty()
      && state->command_buffer_restore_states.empty()
      && state->command_buffer_dof_composite_states.empty()
      && state->command_buffer_usage_flags.empty()
      && state->command_buffer_recording_generations.empty()) {
    state->published_command_buffer_bloom.store(0u, std::memory_order_release);
  }
}

void ErasePublishedCommandBufferStateLocked(
    DeviceState* state, std::uint64_t command_buffer) {
  state->command_buffer_descriptors.erase(command_buffer);
  state->command_buffer_restore_states.erase(command_buffer);
  state->command_buffer_dof_composite_states.erase(command_buffer);
  state->command_buffer_usage_flags.erase(command_buffer);
  state->command_buffer_recording_generations.erase(command_buffer);
  ClearPublishedCommandBufferBloomIfEmptyLocked(state);
}

bool PublishThreadCommandRecordingLocked(
    DeviceState* state,
    std::uint64_t command_buffer,
    ThreadComputeCommandState* local) {
  if (state == nullptr || command_buffer == 0u || local == nullptr
      || !local->recording_active) {
    return false;
  }

  const auto published_generation =
      state->command_buffer_recording_generations.find(command_buffer);
  if (local->recording_generation == 0u) {
    if (published_generation
        != state->command_buffer_recording_generations.end()) {
      return false;
    }
    auto generation = state->next_recording_generation++;
    if (generation == 0u) {
      generation = state->next_recording_generation++;
    }
    local->recording_generation = generation;
  } else if (
      published_generation
          == state->command_buffer_recording_generations.end()
      || published_generation->second != local->recording_generation) {
    // A begin/reset on another recording thread invalidated this TLS entry.
    return false;
  }

  state->command_buffer_usage_flags[command_buffer] = local->begin_flags;
  state->command_buffer_recording_generations[command_buffer] =
      local->recording_generation;
  state->published_command_buffer_bloom.fetch_or(
      CommandBufferBloomBit(command_buffer), std::memory_order_release);
  return true;
}

void MarkFeatureRecordingCandidateLocked(
    DeviceState* state,
    VkCommandBuffer command_buffer,
    std::uint64_t recording_epoch,
    bool requires_submission_tracking) {
  const auto handle = ToOpaque(command_buffer);
  (void)state->feature_recording_candidates.Insert(
      handle, recording_epoch, requires_submission_tracking);
  // Overflow intentionally falls back to Bloom-only matching, so even the
  // candidate that exhausted the exact registry must publish its bit.
  state->feature_command_buffer_bloom.fetch_or(
      CommandBufferBloomBit(handle), std::memory_order_release);
}

bool MayBeFeatureRecordingCandidate(
    const DeviceState& state, VkCommandBuffer command_buffer) {
  if (command_buffer == VK_NULL_HANDLE
      || !state.feature_lifecycle_tracking_active.load(
          std::memory_order_acquire)) {
    return false;
  }
  const auto bloom = state.feature_command_buffer_bloom.load(
      std::memory_order_acquire);
  const auto handle = ToOpaque(command_buffer);
  if ((bloom & CommandBufferBloomBit(handle)) == 0u) return false;
  return state.feature_recording_candidates.Overflowed()
         || state.feature_recording_candidates.Contains(handle);
}

void UnmarkFeatureRecordingCandidateLocked(
    DeviceState* state, std::uint64_t command_buffer) {
  if (state == nullptr || command_buffer == 0u) return;
  (void)state->feature_recording_candidates.Erase(command_buffer);
  if (!state->feature_recording_candidates.Overflowed()
      && state->feature_recording_candidates.Empty()) {
    state->feature_command_buffer_bloom.store(0u, std::memory_order_release);
  }
}

NVSDK_NGX_Result CoreInitializeProject(
    void*,
    const char* project_id,
    NVSDK_NGX_EngineType engine_type,
    const char* engine_version,
    const wchar_t* application_data_path,
    VkInstance instance,
    VkPhysicalDevice physical_device,
    VkDevice device,
    PFN_vkGetInstanceProcAddr get_instance_proc_addr,
    PFN_vkGetDeviceProcAddr get_device_proc_addr,
    const NVSDK_NGX_FeatureCommonInfo* feature_info,
    NVSDK_NGX_Version sdk_version) {
  return NVSDK_NGX_VULKAN_Init_with_ProjectID(
      project_id,
      engine_type,
      engine_version,
      application_data_path,
      instance,
      physical_device,
      device,
      get_instance_proc_addr,
      get_device_proc_addr,
      feature_info,
      sdk_version);
}

NVSDK_NGX_Result CoreGetCapabilityParameters(
    void*, NVSDK_NGX_Parameter** parameters) {
  return NVSDK_NGX_VULKAN_GetCapabilityParameters(parameters);
}

NVSDK_NGX_Result CoreGetParameterI(
    void*, NVSDK_NGX_Parameter* parameters, const char* name, int* value) {
  return NVSDK_NGX_Parameter_GetI(parameters, name, value);
}

NVSDK_NGX_Result CoreQueryMode(
    void*,
    NVSDK_NGX_Parameter* parameters,
    const renodx::utils::dlss::vulkan::ModeQuery* query,
    renodx::utils::dlss::vulkan::ModeSettings* settings) {
  return NGX_DLSS_GET_OPTIMAL_SETTINGS(
      parameters,
      query->output_width,
      query->output_height,
      query->mode,
      &settings->optimal_width,
      &settings->optimal_height,
      &settings->maximum_width,
      &settings->maximum_height,
      &settings->minimum_width,
      &settings->minimum_height,
      &settings->sharpness);
}

NVSDK_NGX_Result CoreAllocateParameters(
    void*, NVSDK_NGX_Parameter** parameters) {
  return NVSDK_NGX_VULKAN_AllocateParameters(parameters);
}

NVSDK_NGX_Result CoreDestroyParameters(
    void*, NVSDK_NGX_Parameter* parameters) {
  return NVSDK_NGX_VULKAN_DestroyParameters(parameters);
}

NVSDK_NGX_Result CoreCreateFeature(
    void*,
    VkDevice device,
    VkCommandBuffer command_buffer,
    NVSDK_NGX_Handle** feature,
    NVSDK_NGX_Parameter* parameters,
    const renodx::utils::dlss::vulkan::FeatureConfig* config) {
  NVSDK_NGX_DLSS_Create_Params create_parameters = {};
  create_parameters.Feature.InWidth = config->render_width;
  create_parameters.Feature.InHeight = config->render_height;
  create_parameters.Feature.InTargetWidth = config->output_width;
  create_parameters.Feature.InTargetHeight = config->output_height;
  create_parameters.Feature.InPerfQualityValue = config->mode;
  create_parameters.InFeatureCreateFlags = static_cast<int>(config->create_flags);
  return NGX_VULKAN_CREATE_DLSS_EXT1(
      device,
      command_buffer,
      1u,
      1u,
      feature,
      parameters,
      &create_parameters);
}

NVSDK_NGX_Result CoreEvaluateFeature(
    void*,
    VkCommandBuffer command_buffer,
    NVSDK_NGX_Handle* feature,
    NVSDK_NGX_Parameter* parameters,
    const renodx::utils::dlss::vulkan::EvaluateInfo* info) {
  auto* color = const_cast<NVSDK_NGX_Resource_VK*>(&info->color->ngx);
  auto* depth = const_cast<NVSDK_NGX_Resource_VK*>(&info->depth->ngx);
  auto* motion_vectors =
      const_cast<NVSDK_NGX_Resource_VK*>(&info->motion_vectors->ngx);
  auto* output = const_cast<NVSDK_NGX_Resource_VK*>(&info->output->ngx);
  auto* exposure = info->exposure == nullptr
                       ? nullptr
                       : const_cast<NVSDK_NGX_Resource_VK*>(&info->exposure->ngx);
  NVSDK_NGX_VK_DLSS_Eval_Params evaluation = {};
  evaluation.Feature.pInColor = color;
  evaluation.Feature.pInOutput = output;
  evaluation.pInDepth = depth;
  evaluation.pInMotionVectors = motion_vectors;
  evaluation.pInExposureTexture = exposure;
  evaluation.InJitterOffsetX = info->jitter_x;
  evaluation.InJitterOffsetY = info->jitter_y;
  evaluation.InRenderSubrectDimensions = {
      info->render_width, info->render_height};
  evaluation.InReset = info->reset;
  evaluation.InMVScaleX = info->motion_vector_scale_x;
  evaluation.InMVScaleY = info->motion_vector_scale_y;
  evaluation.InPreExposure = info->pre_exposure;
  evaluation.InExposureScale = info->exposure_scale;
  return NGX_VULKAN_EVALUATE_DLSS_EXT(
      command_buffer, feature, parameters, &evaluation);
}

NVSDK_NGX_Result CoreReleaseFeature(void*, NVSDK_NGX_Handle* feature) {
  return NVSDK_NGX_VULKAN_ReleaseFeature(feature);
}

NVSDK_NGX_Result CoreShutdown(void*, VkDevice device) {
  return NVSDK_NGX_VULKAN_Shutdown1(device);
}

VkResult CoreCreateCommandPool(
    void* context,
    VkDevice device,
    const VkCommandPoolCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkCommandPool* command_pool) {
  auto* state = static_cast<DeviceState*>(context);
  return state->next_create_command_pool(
      device, create_info, allocator, command_pool);
}

void CoreDestroyCommandPool(
    void* context,
    VkDevice device,
    VkCommandPool command_pool,
    const VkAllocationCallbacks* allocator) {
  static_cast<DeviceState*>(context)->next_destroy_command_pool(
      device, command_pool, allocator);
}

VkResult CoreAllocateCommandBuffers(
    void* context,
    VkDevice device,
    const VkCommandBufferAllocateInfo* allocate_info,
    VkCommandBuffer* command_buffers) {
  auto* const state = static_cast<DeviceState*>(context);
  const VkResult result = state->next_allocate_command_buffers(
      device, allocate_info, command_buffers);
  if (result != VK_SUCCESS || allocate_info == nullptr
      || command_buffers == nullptr) {
    return result;
  }

  // This callback invokes ReShade's layer trampoline internally rather than
  // returning through the Vulkan loader. ReShade registers each command buffer
  // during allocation, but the loader therefore never replaces the downstream
  // dispatch pointer with ReShade's device dispatch pointer. Without this fix,
  // ReShade's vkBeginCommandBuffer cannot resolve its device and dereferences a
  // null device_impl before NGX feature creation reaches Evaluate.
  for (std::uint32_t index = 0u; index < allocate_info->commandBufferCount;
       ++index) {
    if (!RestoreVulkanLayerDispatchPointer(device, command_buffers[index])) {
      return VK_ERROR_INITIALIZATION_FAILED;
    }
  }
  return result;
}

void CoreFreeCommandBuffers(
    void* context,
    VkDevice device,
    VkCommandPool command_pool,
    std::uint32_t command_buffer_count,
    const VkCommandBuffer* command_buffers) {
  static_cast<DeviceState*>(context)->next_free_command_buffers(
      device, command_pool, command_buffer_count, command_buffers);
}

VkResult CoreBeginCommandBuffer(
    void* context,
    VkCommandBuffer command_buffer,
    const VkCommandBufferBeginInfo* begin_info) {
  return static_cast<DeviceState*>(context)->next_begin_command_buffer(
      command_buffer, begin_info);
}

VkResult CoreEndCommandBuffer(void* context, VkCommandBuffer command_buffer) {
  return static_cast<DeviceState*>(context)->next_end_command_buffer(
      command_buffer);
}

VkResult CoreCreateFence(
    void* context,
    VkDevice device,
    const VkFenceCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkFence* fence) {
  return static_cast<DeviceState*>(context)->next_create_fence(
      device, create_info, allocator, fence);
}

void CoreDestroyFence(
    void* context,
    VkDevice device,
    VkFence fence,
    const VkAllocationCallbacks* allocator) {
  static_cast<DeviceState*>(context)->next_destroy_fence(
      device, fence, allocator);
}

VkResult CoreWaitForFences(
    void* context,
    VkDevice device,
    std::uint32_t fence_count,
    const VkFence* fences,
    VkBool32 wait_all,
    std::uint64_t timeout) {
  return static_cast<DeviceState*>(context)->next_wait_for_fences(
      device, fence_count, fences, wait_all, timeout);
}

VkResult CoreSubmit(
    void* context,
    VkQueue queue,
    std::uint32_t submit_count,
    const VkSubmitInfo* submits,
    VkFence fence) {
  auto* state = static_cast<DeviceState*>(context);
  return state->next_queue_submit(queue, submit_count, submits, fence);
}

void UpdateFeatureTrackingStateLocked(DeviceState* state) {
  const bool has_features =
      state->ngx_context != nullptr && state->ngx_context->HasFeatures();
  const bool has_active_feature =
      state->ngx_context != nullptr
      && state->ngx_context->ActiveFeatureGeneration() != 0u;
  const bool has_lifecycle_candidates =
      has_features
      || state->feature_recording_candidates.HasLifecycleCandidates();
  const bool requires_submission_tracking =
      has_active_feature
      || (state->feature_recording_candidates.Overflowed()
              ? has_features
              : state->feature_recording_candidates
                    .AnyRequiresSubmissionTracking());
  state->feature_evaluation_active.store(
      has_active_feature, std::memory_order_release);
  state->feature_submission_tracking_active.store(
      requires_submission_tracking, std::memory_order_release);
  state->feature_lifecycle_tracking_active.store(
      has_lifecycle_candidates, std::memory_order_release);
  const bool has_internal_feature_fences = std::any_of(
      state->fenced_feature_submissions.begin(),
      state->fenced_feature_submissions.end(),
      [](const auto& submission) { return submission.second.owned_by_layer; });
  state->internal_feature_fences_pending.store(
      has_internal_feature_fences, std::memory_order_release);
  if (!has_internal_feature_fences) {
    state->retired_feature_fence_poll_serial.store(
        0u, std::memory_order_relaxed);
  }
  if (state->ngx_shutdown_requested && !has_features
      && state->ngx_context != nullptr) {
    state->ngx_context->Shutdown();
    state->ngx_context.reset();
    state->ngx_discovery.reset();
    state->ngx_shutdown_requested = false;
  }
}

bool EnsureNgxInitialized(DeviceState* state) {
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)) {
    return false;
  }
  if (state->ngx_context != nullptr) {
    state->last_ngx_initialization = {
        .stage = renodx::utils::dlss::vulkan::OperationStage::kInitialize,
        .ngx_result = state->ngx_context->IsAvailable()
                          ? NVSDK_NGX_Result_Success
                          : NVSDK_NGX_Result_FAIL_NotInitialized,
    };
    return state->ngx_context->IsAvailable();
  }
  if (!state->supported_executable || !state->ngx_extensions_enabled
      || state->graphics_queue == VK_NULL_HANDLE
      || state->graphics_queue_family == std::numeric_limits<std::uint32_t>::max()
      || state->next_queue_submit == nullptr
      || state->next_create_command_pool == nullptr
      || state->next_destroy_command_pool == nullptr
      || state->next_allocate_command_buffers == nullptr
      || state->next_free_command_buffers == nullptr
      || state->next_begin_command_buffer == nullptr
      || state->next_end_command_buffer == nullptr
      || state->next_create_fence == nullptr
      || state->next_destroy_fence == nullptr
      || state->next_wait_for_fences == nullptr) {
    state->last_ngx_initialization = {
        .stage = renodx::utils::dlss::vulkan::OperationStage::kInitialize,
        .ngx_result = NVSDK_NGX_Result_FAIL_InvalidParameter,
    };
    return false;
  }

  state->ngx_discovery = std::make_unique<NgxDiscovery>();
  state->ngx_shutdown_requested = false;
  renodx::utils::dlss::vulkan::DeviceCreateInfo create_info = {
      .instance = state->instance,
      .physical_device = state->physical_device,
      .device = state->device,
      .graphics_queue = state->graphics_queue,
      .graphics_queue_family = state->graphics_queue_family,
      .get_instance_proc_addr = state->next_get_instance_proc_addr,
      .get_device_proc_addr = state->next_get_device_proc_addr,
      .project_id = kProjectId,
      .engine_version = kEngineVersion,
      .application_data_path = state->ngx_discovery->data_path,
      .feature_info = &state->ngx_discovery->feature_info,
      .sdk_version = NVSDK_NGX_Version_API,
      .ngx = {
          .context = state,
          .initialize_project = &CoreInitializeProject,
          .get_capability_parameters = &CoreGetCapabilityParameters,
          .get_parameter_i = &CoreGetParameterI,
          .query_mode = &CoreQueryMode,
          .allocate_parameters = &CoreAllocateParameters,
          .destroy_parameters = &CoreDestroyParameters,
          .create_feature = &CoreCreateFeature,
          .evaluate_feature = &CoreEvaluateFeature,
          .release_feature = &CoreReleaseFeature,
          .shutdown = &CoreShutdown,
      },
      .vulkan = {
          .context = state,
          .create_command_pool = &CoreCreateCommandPool,
          .destroy_command_pool = &CoreDestroyCommandPool,
          .allocate_command_buffers = &CoreAllocateCommandBuffers,
          .free_command_buffers = &CoreFreeCommandBuffers,
          .begin_command_buffer = &CoreBeginCommandBuffer,
          .end_command_buffer = &CoreEndCommandBuffer,
          .create_fence = &CoreCreateFence,
          .destroy_fence = &CoreDestroyFence,
          .wait_for_fences = &CoreWaitForFences,
      },
      .submit_context = state,
      .submit = &CoreSubmit,
  };
  state->ngx_context =
      std::make_unique<renodx::utils::dlss::vulkan::NgxContext>(
          std::move(create_info));
  const auto result = state->ngx_context->Initialize();
  state->last_ngx_initialization = result;
  if (!result.Succeeded()) {
    TraceNgxFailureOnce(state, 0u, "initialization", result.ngx_result);
    state->ngx_context.reset();
    state->ngx_discovery.reset();
    return false;
  }
  return true;
}

void RetireActiveFeatureLocked(DeviceState* state) {
  if (state->ngx_context != nullptr) {
    state->ngx_context->RetireActive();
  }
  UpdateFeatureTrackingStateLocked(state);
}

void RequestNgxShutdown(DeviceState* state) {
  const std::lock_guard lock(state->mutex);
  state->ngx_shutdown_requested = true;
  RetireActiveFeatureLocked(state);
  state->configured = false;
  state->context_identity = 0u;
  state->configured_identity = 0u;
}

void ForceShutdownNgxForDeviceDestroy(DeviceState* state) {
  const std::lock_guard lock(state->mutex);
  if (state->ngx_context != nullptr) {
    state->ngx_context->DiscardAllRecordings();
    state->ngx_context->Shutdown();
    state->ngx_context.reset();
  }
  state->ngx_discovery.reset();
  state->ngx_shutdown_requested = false;
  state->feature_evaluation_active.store(false, std::memory_order_release);
  state->feature_submission_tracking_active.store(false, std::memory_order_release);
  state->feature_lifecycle_tracking_active.store(false, std::memory_order_release);
  state->internal_feature_fences_pending.store(false, std::memory_order_release);
  state->retired_feature_fence_poll_serial.store(0u, std::memory_order_relaxed);
  state->feature_recording_candidates.Clear();
  state->feature_command_buffer_bloom.store(0u, std::memory_order_release);
  state->submission_trace_tracker.Clear();
  state->configured = false;
  state->context_identity = 0u;
  state->configured_identity = 0u;
}

void DiscardFeatureCommandBuffers(
    DeviceState* state, const std::vector<VkCommandBuffer>& command_buffers) {
  if (state == nullptr || command_buffers.empty()) return;
  std::vector<std::uint64_t> handles;
  handles.reserve(command_buffers.size());
  for (const VkCommandBuffer command_buffer : command_buffers) {
    if (MayBeFeatureRecordingCandidate(*state, command_buffer)) {
      handles.push_back(ToOpaque(command_buffer));
    }
  }
  if (handles.empty()) return;
  const std::lock_guard lock(state->mutex);
  if (state->ngx_context != nullptr) {
    state->ngx_context->DiscardRecordings(handles);
  }
  for (const std::uint64_t handle : handles) {
    (void)state->submission_trace_tracker.Discard(handle);
    UnmarkFeatureRecordingCandidateLocked(state, handle);
  }
  UpdateFeatureTrackingStateLocked(state);
}

void DiscardFeatureCommandBuffer(
    DeviceState* state, VkCommandBuffer command_buffer) {
  if (state == nullptr || !MayBeFeatureRecordingCandidate(*state, command_buffer)) {
    return;
  }
  const std::lock_guard lock(state->mutex);
  if (state->ngx_context != nullptr) {
    state->ngx_context->DiscardRecording(ToOpaque(command_buffer));
  }
  const auto handle = ToOpaque(command_buffer);
  (void)state->submission_trace_tracker.Discard(handle);
  UnmarkFeatureRecordingCandidateLocked(state, handle);
  UpdateFeatureTrackingStateLocked(state);
}

bool IsValidResource(const DetroitDlssResource& resource, std::uint32_t width, std::uint32_t height) {
  return resource.image != 0u && resource.image_view != 0u
         && resource.format != VK_FORMAT_UNDEFINED
         && resource.layout != VK_IMAGE_LAYOUT_UNDEFINED && resource.width >= width
         && resource.height >= height;
}

NVSDK_NGX_Resource_VK MakeNgxResource(
    const DetroitDlssResource& resource,
    VkImageAspectFlags aspect,
    bool read_write) {
  const VkImageSubresourceRange range = {
      aspect,
      resource.mip_level,
      1u,
      resource.array_layer,
      1u,
  };
  return NVSDK_NGX_Create_ImageView_Resource_VK(
      FromOpaque<VkImageView>(resource.image_view),
      FromOpaque<VkImage>(resource.image),
      range,
      static_cast<VkFormat>(resource.format),
      resource.width,
      resource.height,
      read_write);
}

renodx::utils::dlss::vulkan::ImageResource MakeCoreImageResource(
    const DetroitDlssResource& resource,
    VkImageAspectFlags aspect,
    bool read_write,
    VkImageUsageFlags usage,
    VkAccessFlags access) {
  return {
      .ngx = MakeNgxResource(resource, aspect, read_write),
      .state = {
          .image = FromOpaque<VkImage>(resource.image),
          .image_view = FromOpaque<VkImageView>(resource.image_view),
          .range = {
              .aspectMask = aspect,
              .baseMipLevel = resource.mip_level,
              .levelCount = 1u,
              .baseArrayLayer = resource.array_layer,
              .layerCount = 1u,
          },
          .format = static_cast<VkFormat>(resource.format),
          .usage = usage,
          .layout = static_cast<VkImageLayout>(resource.layout),
          .stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
          .access = access,
          .queue_family = VK_QUEUE_FAMILY_IGNORED,
          .contents_valid = true,
      },
      .width = resource.width,
      .height = resource.height,
  };
}

std::optional<renodx::utils::dlss::vulkan::TrackedImageState>
LegacyCaptureNativeOutputTrackedState(
    DeviceState* state,
    const DetroitDlssResource& resource) {
  if (state == nullptr || resource.image == 0u || resource.image_view == 0u
      || resource.layout != VK_IMAGE_LAYOUT_GENERAL) {
    return std::nullopt;
  }

  const std::lock_guard lock(state->tracking_mutex);
  const auto image = state->images.find(resource.image);
  const auto view = state->image_views.find(resource.image_view);
  if (image == state->images.end() || view == state->image_views.end()) {
    return std::nullopt;
  }

  const auto native_image = FromOpaque<VkImage>(resource.image);
  const auto native_view = FromOpaque<VkImageView>(resource.image_view);
  const VkImageSubresourceRange expected_range = {
      .aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
      .baseMipLevel = resource.mip_level,
      .levelCount = 1u,
      .baseArrayLayer = resource.array_layer,
      .layerCount = 1u,
  };
  const auto& tracked_image = image->second;
  const auto& tracked_view = view->second;
  const bool exact_view =
      tracked_view.image == native_image
      && tracked_view.type == VK_IMAGE_VIEW_TYPE_2D
      && tracked_view.format == static_cast<VkFormat>(resource.format)
      && tracked_view.subresource_range.aspectMask == expected_range.aspectMask
      && tracked_view.subresource_range.baseMipLevel
             == expected_range.baseMipLevel
      && tracked_view.subresource_range.levelCount == expected_range.levelCount
      && tracked_view.subresource_range.baseArrayLayer
             == expected_range.baseArrayLayer
      && tracked_view.subresource_range.layerCount == expected_range.layerCount;
  const bool exact_image =
      tracked_image.type == VK_IMAGE_TYPE_2D
      && tracked_image.format == static_cast<VkFormat>(resource.format)
      && tracked_image.samples == VK_SAMPLE_COUNT_1_BIT
      && resource.mip_level < tracked_image.mip_levels
      && resource.array_layer < tracked_image.array_layers
      && (tracked_image.usage & VK_IMAGE_USAGE_STORAGE_BIT) != 0u;
  if (!exact_view || !exact_image) return std::nullopt;

  return renodx::utils::dlss::vulkan::TrackedImageState{
      .image = native_image,
      .image_view = native_view,
      .range = expected_range,
      .format = tracked_image.format,
      .usage = tracked_image.usage,
      .layout = VK_IMAGE_LAYOUT_GENERAL,
      // b16 is captured at Detroit's temporal compute pass. The adapter is
      // allowed to replace only this exact compute read/write dependency.
      .stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      .access = VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT,
      .queue_family = VK_QUEUE_FAMILY_IGNORED,
      .contents_valid = true,
  };
}

std::optional<renodx::utils::dlss::vulkan::TrackedImageState>
CaptureNativeOutputTrackedState(const DetroitDlssResource& resource) {
  if (resource.image == 0u || resource.image_view == 0u
      || resource.format != VK_FORMAT_R32_UINT
      || resource.layout != VK_IMAGE_LAYOUT_GENERAL
      || resource.width == 0u || resource.height == 0u) {
    return std::nullopt;
  }
  return renodx::utils::dlss::vulkan::TrackedImageState{
      .image = FromOpaque<VkImage>(resource.image),
      .image_view = FromOpaque<VkImageView>(resource.image_view),
      .range = {
          .aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
          .baseMipLevel = resource.mip_level,
          .levelCount = 1u,
          .baseArrayLayer = resource.array_layer,
          .layerCount = 1u,
      },
      .format = static_cast<VkFormat>(resource.format),
      .usage = VK_IMAGE_USAGE_STORAGE_BIT,
      .layout = VK_IMAGE_LAYOUT_GENERAL,
      .stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      .access = VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT,
      .queue_family = VK_QUEUE_FAMILY_IGNORED,
      .contents_valid = true,
  };
}

std::uint64_t GetCommandBufferRecordingGeneration(
    DeviceState* state, std::uint64_t command_buffer) {
  if (state == nullptr || command_buffer == 0u) return 0u;
  const std::lock_guard lock(state->tracking_mutex);
  const auto found =
      state->command_buffer_recording_generations.find(command_buffer);
  return found == state->command_buffer_recording_generations.end()
             ? 0u
             : found->second;
}

void SetEvaluationResult(
    DetroitDlssEvaluateResult* result,
    DetroitDlssResultCode status,
    BridgeDetail detail,
    std::uint64_t frame_id,
    DetroitDlssEvaluateFlags flags = 0u) {
  if (result == nullptr || result->struct_size < sizeof(*result)
      || result->abi_version != DETROIT_DLSS_ABI_VERSION) {
    return;
  }
  const auto caller_struct_size = result->struct_size;
  *result = {};
  result->struct_size = caller_struct_size;
  result->abi_version = DETROIT_DLSS_ABI_VERSION;
  result->status = status;
  result->detail_code = static_cast<std::uint32_t>(detail);
  result->frame_id = frame_id;
  result->flags = flags;
}

bool AddWithoutOverflow(
    std::uint64_t left, std::uint64_t right, std::uint64_t* result) {
  if (result == nullptr || left > std::numeric_limits<std::uint64_t>::max() - right) {
    return false;
  }
  *result = left + right;
  return true;
}

void DetachTemporalConstantsBufferLocked(
    DeviceState* state, std::uint64_t buffer_handle, const BufferState& buffer) {
  if (buffer.memory == VK_NULL_HANDLE) return;
  const auto memory = state->memories.find(ToOpaque(buffer.memory));
  if (memory == state->memories.end()) return;
  auto& buffers = memory->second.temporal_uniform_buffers;
  buffers.erase(
      std::remove(buffers.begin(), buffers.end(), buffer_handle), buffers.end());
}

void RegisterTemporalConstantsBufferLocked(
    DeviceState* state, std::uint64_t buffer_handle) {
  const auto buffer = state->buffers.find(buffer_handle);
  if (buffer == state->buffers.end()) return;
  auto& tracked_buffer = buffer->second;
  tracked_buffer.temporal_constants_candidate = true;
  if (tracked_buffer.memory == VK_NULL_HANDLE || tracked_buffer.size == 0u
      || tracked_buffer.size > kMaximumTemporalConstantsShadowSize
      || (tracked_buffer.usage & VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT) == 0u) {
    return;
  }

  const auto memory = state->memories.find(ToOpaque(tracked_buffer.memory));
  if (memory == state->memories.end()
      || (memory->second.property_flags & VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT) == 0u) {
    return;
  }
  std::uint64_t buffer_end = 0u;
  if (!AddWithoutOverflow(
          tracked_buffer.memory_offset, tracked_buffer.size, &buffer_end)
      || buffer_end > memory->second.allocation_size) {
    return;
  }

  const auto shadow_size = static_cast<std::size_t>(tracked_buffer.size);
  if (tracked_buffer.shadow_bytes.size() != shadow_size) {
    tracked_buffer.shadow_bytes.assign(shadow_size, 0u);
    tracked_buffer.shadow_valid_bytes.assign(shadow_size, 0u);
  }
  auto& buffers = memory->second.temporal_uniform_buffers;
  if (std::find(buffers.begin(), buffers.end(), buffer_handle) == buffers.end()) {
    buffers.push_back(buffer_handle);
  }
}

void TrackBufferMemoryBindingLocked(
    DeviceState* state,
    VkBuffer buffer,
    VkDeviceMemory memory,
    VkDeviceSize memory_offset) {
  const auto tracked = state->buffers.find(ToOpaque(buffer));
  if (tracked == state->buffers.end()) return;
  const bool binding_changed = tracked->second.memory != memory
                               || tracked->second.memory_offset != memory_offset;
  DetachTemporalConstantsBufferLocked(state, ToOpaque(buffer), tracked->second);
  tracked->second.memory = memory;
  tracked->second.memory_offset = memory_offset;
  if (binding_changed) {
    std::fill(
        tracked->second.shadow_valid_bytes.begin(),
        tracked->second.shadow_valid_bytes.end(),
        std::uint8_t{0u});
    tracked->second.temporal_slot_offsets.clear();
    tracked->second.temporal_slot_hashes.clear();
    tracked->second.temporal_slot_hashes_primed = false;
  }
  if (tracked->second.temporal_constants_candidate) {
    RegisterTemporalConstantsBufferLocked(state, ToOpaque(buffer));
  }
}

void ShadowTemporalConstantsBeforeUnmapLocked(
    DeviceState* state, VkDeviceMemory memory_handle, MemoryState* memory) {
  if (memory == nullptr || memory->mapped_pointer == nullptr
      || memory->mapped_size == 0u
      || (memory->property_flags & VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT) == 0u) {
    return;
  }
  std::uint64_t mapped_end = 0u;
  if (!AddWithoutOverflow(memory->mapped_offset, memory->mapped_size, &mapped_end)
      || mapped_end > memory->allocation_size) {
    return;
  }

  for (const std::uint64_t buffer_handle : memory->temporal_uniform_buffers) {
    const auto buffer = state->buffers.find(buffer_handle);
    if (buffer == state->buffers.end()
        || buffer->second.memory != memory_handle
        || !buffer->second.temporal_constants_candidate
        || buffer->second.shadow_bytes.size() != buffer->second.size
        || buffer->second.shadow_valid_bytes.size() != buffer->second.size) {
      continue;
    }
    std::uint64_t buffer_end = 0u;
    if (!AddWithoutOverflow(
            buffer->second.memory_offset, buffer->second.size, &buffer_end)
        || buffer_end > memory->allocation_size) {
      continue;
    }
    const std::uint64_t copy_begin =
        std::max<std::uint64_t>(memory->mapped_offset, buffer->second.memory_offset);
    const std::uint64_t copy_end = std::min(mapped_end, buffer_end);
    if (copy_begin >= copy_end) continue;

    const auto source_offset =
        static_cast<std::size_t>(copy_begin - memory->mapped_offset);
    const auto destination_offset =
        static_cast<std::size_t>(copy_begin - buffer->second.memory_offset);
    const auto copy_size = static_cast<std::size_t>(copy_end - copy_begin);
    std::memcpy(
        buffer->second.shadow_bytes.data() + destination_offset,
        static_cast<const std::uint8_t*>(memory->mapped_pointer) + source_offset,
        copy_size);
    std::fill_n(
        buffer->second.shadow_valid_bytes.begin() + destination_offset,
        copy_size,
        std::uint8_t{1u});
  }
}

DetroitDlssResultCode DETROIT_DLSS_CALL BridgeGetContext(DetroitDlssBootstrapContext* context) {
  if (context == nullptr || context->struct_size < sizeof(*context)
      || context->abi_version != DETROIT_DLSS_ABI_VERSION) {
    return DETROIT_DLSS_RESULT_ERROR;
  }

  const auto state = GetActiveDevice();
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const std::lock_guard lock(state->mutex);
  if (state->destroying.load(std::memory_order_acquire)) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const bool ngx_available = EnsureNgxInitialized(state.get());
  SetBootstrapStatus(
      ngx_available ? BootstrapStatus::kDlaaReady : BootstrapStatus::kNativeFallback,
      ngx_available ? "DLAA ready" : "NGX initialization or capability check failed");

  const auto struct_size = context->struct_size;
  *context = {};
  context->struct_size = struct_size;
  context->abi_version = DETROIT_DLSS_ABI_VERSION;
  context->vk_instance = ToOpaque(state->instance);
  context->vk_physical_device = ToOpaque(state->physical_device);
  context->vk_device = ToOpaque(state->device);
  context->vk_graphics_queue = ToOpaque(state->graphics_queue);
  context->vk_get_instance_proc_addr = ToOpaque(state->next_get_instance_proc_addr);
  context->vk_get_device_proc_addr = ToOpaque(state->next_get_device_proc_addr);
  context->graphics_queue_family_index = state->graphics_queue_family;
  context->graphics_queue_index = state->graphics_queue_index;
  if (state->supported_executable) {
    context->capability_flags |= DETROIT_DLSS_CAPABILITY_SUPPORTED_EXECUTABLE;
  }
  if (ngx_available && state->adapter_available
      && renodx::games::detroitbecomehuman::supported_build::
          kTemporalInputsEmpiricallyVerified) {
    context->capability_flags |= DETROIT_DLSS_CAPABILITY_DLAA
                                 | DETROIT_DLSS_CAPABILITY_AUTO_EXPOSURE
                                 | DETROIT_DLSS_CAPABILITY_TEMPORAL_INPUTS_VERIFIED;
  }
  if (state->ngx_extensions_enabled) {
    context->enabled_extension_flags =
        kInstanceExtensionsEnabled | kDeviceExtensionsEnabled;
  }
  state->context_identity = state->identity;
  return ngx_available ? DETROIT_DLSS_RESULT_SUCCESS : DETROIT_DLSS_RESULT_FALLBACK;
}

DetroitDlssResultCode FillTemporalConstantsForBindingLocked(
    const DeviceState& state,
    std::uint64_t command_buffer,
    std::uint32_t descriptor_set_index,
    std::uint32_t binding,
    std::uint64_t descriptor_set_handle,
    std::uint64_t pipeline_layout_handle,
    VkDeviceSize dynamic_offset,
    bool dynamic_offset_valid,
    DetroitDlssTemporalConstantsSnapshot* snapshot,
    DetroitDlssTemporalConstantsDiagnostics* diagnostics) {
  const auto set_detail = [&](DetroitDlssTemporalConstantsDetail detail) {
    if (diagnostics != nullptr && diagnostics->detail_code == DETROIT_DLSS_CONSTANTS_DETAIL_NONE) {
      diagnostics->detail_code = detail;
    }
  };

  snapshot->descriptor_set = descriptor_set_handle;
  snapshot->pipeline_layout = pipeline_layout_handle;
  snapshot->dynamic_offset = dynamic_offset;
  if (!dynamic_offset_valid) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_DYNAMIC_OFFSET_INVALID);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const auto descriptor_set = state.descriptor_sets.find(snapshot->descriptor_set);
  if (descriptor_set == state.descriptor_sets.end()) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_DESCRIPTOR_SET_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const auto descriptor =
      descriptor_set->second.buffer_descriptors.find(DescriptorSlotKey(binding, 0u));
  if (descriptor == descriptor_set->second.buffer_descriptors.end()
      || !IsBufferDescriptorType(descriptor->second.descriptor_type)
      || descriptor->second.buffer == VK_NULL_HANDLE) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_DESCRIPTOR_MISSING);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  snapshot->buffer = ToOpaque(descriptor->second.buffer);
  snapshot->descriptor_offset = descriptor->second.offset;
  snapshot->descriptor_type = static_cast<std::uint32_t>(descriptor->second.descriptor_type);
  snapshot->valid_flags = DETROIT_DLSS_CONSTANTS_DESCRIPTOR_VALID
                          | DETROIT_DLSS_CONSTANTS_DYNAMIC_OFFSET_VALID;
  if (diagnostics != nullptr) {
    diagnostics->descriptor_source_flags = descriptor->second.source_flags;
    diagnostics->descriptor_update_serial = descriptor->second.update_serial;
  }

  std::uint64_t effective_offset = 0u;
  if (!AddWithoutOverflow(
          snapshot->descriptor_offset, snapshot->dynamic_offset, &effective_offset)) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_OFFSET_OVERFLOW);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  snapshot->effective_offset = effective_offset;
  snapshot->valid_flags |= DETROIT_DLSS_CONSTANTS_EFFECTIVE_OFFSET_VALID;

  const auto buffer = state.buffers.find(snapshot->buffer);
  if (buffer == state.buffers.end() || effective_offset > buffer->second.size
      || buffer->second.memory == VK_NULL_HANDLE) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_BUFFER_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (diagnostics != nullptr) {
    diagnostics->buffer_size = buffer->second.size;
    diagnostics->buffer_usage = buffer->second.usage;
    diagnostics->buffer_memory_offset = buffer->second.memory_offset;
  }

  const std::uint64_t available_buffer_bytes = buffer->second.size - effective_offset;
  const std::uint64_t resolved_range = descriptor->second.range == VK_WHOLE_SIZE
                                           ? available_buffer_bytes
                                           : descriptor->second.range;
  if (resolved_range == 0u || resolved_range > available_buffer_bytes) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_RANGE_INVALID);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  snapshot->descriptor_range = resolved_range;
  snapshot->valid_flags |= DETROIT_DLSS_CONSTANTS_RANGE_VALID;

  const bool supported_temporal_binding =
      descriptor_set_index == DETROIT_DLSS_TAA_DESCRIPTOR_SET
      && binding == DETROIT_DLSS_TAA_CONSTANT_BINDING_52;
  if (supported_temporal_binding && resolved_range < kReflectedTemporalConstantsSize) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_RANGE_TOO_SMALL);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const std::uint64_t bytes_to_copy = supported_temporal_binding
                                          ? kReflectedTemporalConstantsSize
                                          : std::min<std::uint64_t>(
                                                resolved_range,
                                                DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY);
  if (diagnostics != nullptr) diagnostics->required_payload_size = bytes_to_copy;

  const auto memory = state.memories.find(ToOpaque(buffer->second.memory));
  if (memory == state.memories.end()) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_MEMORY_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (diagnostics != nullptr) {
    diagnostics->allocation_size = memory->second.allocation_size;
    diagnostics->memory_property_flags = memory->second.property_flags;
    diagnostics->mapped_offset = memory->second.mapped_offset;
    diagnostics->mapped_size = memory->second.mapped_size;
  }
  if ((memory->second.property_flags & VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT) == 0u) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_MEMORY_NOT_HOST_VISIBLE);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  std::uint64_t memory_absolute_offset = 0u;
  if (!AddWithoutOverflow(
          buffer->second.memory_offset, effective_offset, &memory_absolute_offset)) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_OFFSET_OVERFLOW);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (memory_absolute_offset > memory->second.allocation_size
      || bytes_to_copy > memory->second.allocation_size - memory_absolute_offset) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_MAPPED_RANGE_MISS);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  if (memory->second.mapped_pointer != nullptr) {
    if (memory_absolute_offset < memory->second.mapped_offset) {
      set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_MAPPED_RANGE_MISS);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
    const std::uint64_t mapped_relative_offset =
        memory_absolute_offset - memory->second.mapped_offset;
    if (mapped_relative_offset > memory->second.mapped_size
        || bytes_to_copy > memory->second.mapped_size - mapped_relative_offset) {
      set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_MAPPED_RANGE_MISS);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
    std::memcpy(
        snapshot->constants,
        static_cast<const std::uint8_t*>(memory->second.mapped_pointer)
            + mapped_relative_offset,
        static_cast<std::size_t>(bytes_to_copy));
    snapshot->source_flags = DETROIT_DLSS_CONSTANTS_SOURCE_MAPPED_MEMORY;
  } else {
    const auto shadow_offset = static_cast<std::size_t>(effective_offset);
    const auto shadow_size = static_cast<std::size_t>(bytes_to_copy);
    if (shadow_offset > buffer->second.shadow_bytes.size()
        || shadow_size > buffer->second.shadow_bytes.size() - shadow_offset
        || buffer->second.shadow_valid_bytes.size()
               != buffer->second.shadow_bytes.size()
        || !std::all_of(
            buffer->second.shadow_valid_bytes.begin() + shadow_offset,
            buffer->second.shadow_valid_bytes.begin() + shadow_offset + shadow_size,
            [](std::uint8_t value) { return value != 0u; })) {
      set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_MEMORY_NOT_MAPPED);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
    std::memcpy(
        snapshot->constants,
        buffer->second.shadow_bytes.data() + shadow_offset,
        shadow_size);
    snapshot->source_flags = DETROIT_DLSS_CONSTANTS_SOURCE_SHADOW_COPY;
  }
  snapshot->bytes_written = static_cast<std::uint32_t>(bytes_to_copy);
  snapshot->valid_flags |= DETROIT_DLSS_CONSTANTS_PAYLOAD_VALID;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

DetroitDlssResultCode FillTemporalConstantsLocked(
    const DeviceState& state,
    std::uint64_t command_buffer,
    std::uint32_t descriptor_set_index,
    std::uint32_t binding,
    DetroitDlssTemporalConstantsSnapshot* snapshot,
    DetroitDlssTemporalConstantsDiagnostics* diagnostics) {
  const auto command = state.command_buffer_descriptors.find(command_buffer);
  if (command == state.command_buffer_descriptors.end()) {
    if (diagnostics != nullptr) {
      diagnostics->detail_code = DETROIT_DLSS_CONSTANTS_DETAIL_BINDING_UNTRACKED;
    }
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const auto bound = command->second.find(CommandDescriptorKey(descriptor_set_index, binding));
  if (bound == command->second.end()) {
    if (diagnostics != nullptr) {
      diagnostics->detail_code = DETROIT_DLSS_CONSTANTS_DETAIL_BINDING_UNTRACKED;
    }
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  return FillTemporalConstantsForBindingLocked(
      state,
      command_buffer,
      descriptor_set_index,
      binding,
      ToOpaque(bound->second.descriptor_set),
      ToOpaque(bound->second.pipeline_layout),
      bound->second.dynamic_offset,
      bound->second.dynamic_offset_valid,
      snapshot,
      diagnostics);
}

DetroitDlssResultCode DETROIT_DLSS_CALL BridgeGetTemporalConstants(
    std::uint64_t command_buffer,
    std::uint32_t descriptor_set_index,
    std::uint32_t binding,
    DetroitDlssTemporalConstantsSnapshot* snapshot) {
  if (snapshot == nullptr || snapshot->struct_size < sizeof(*snapshot)
      || snapshot->abi_version != DETROIT_DLSS_ABI_VERSION || command_buffer == 0u) {
    return DETROIT_DLSS_RESULT_ERROR;
  }

  const auto struct_size = snapshot->struct_size;
  *snapshot = {};
  snapshot->struct_size = struct_size;
  snapshot->abi_version = DETROIT_DLSS_ABI_VERSION;
  snapshot->descriptor_set_index = descriptor_set_index;
  snapshot->binding = binding;
  snapshot->command_buffer = command_buffer;

  const auto state =
      FindDeviceSharedFast(FromOpaque<VkCommandBuffer>(command_buffer));
  if (state == nullptr || !state->supported_executable
      || state->destroying.load(std::memory_order_acquire)) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const std::lock_guard lock(state->tracking_mutex);
  return FillTemporalConstantsLocked(
      *state, command_buffer, descriptor_set_index, binding, snapshot, nullptr);
}

bool FillImageBindingLocked(
    const DeviceState& state,
    const DescriptorSetState& descriptor_set,
    VkDescriptorSet descriptor_set_handle,
    std::uint32_t binding,
    DetroitDlssImageBindingSnapshot* snapshot) {
  snapshot->struct_size = sizeof(*snapshot);
  snapshot->binding = binding;
  snapshot->descriptor_set = ToOpaque(descriptor_set_handle);

  const auto descriptor =
      descriptor_set.image_descriptors.find(DescriptorSlotKey(binding, 0u));
  if (descriptor == descriptor_set.image_descriptors.end()
      || !IsImageDescriptorType(descriptor->second.descriptor_type)) {
    return false;
  }

  snapshot->descriptor_type = static_cast<std::uint32_t>(descriptor->second.descriptor_type);
  snapshot->sampler = ToOpaque(descriptor->second.sampler);
  snapshot->resource.image_view = ToOpaque(descriptor->second.image_view);
  snapshot->resource.layout = static_cast<std::uint32_t>(descriptor->second.image_layout);
  snapshot->source_flags = descriptor->second.source_flags;
  snapshot->update_serial = descriptor->second.update_serial;
  snapshot->valid_flags |= DETROIT_DLSS_IMAGE_DESCRIPTOR_VALID;
  if (descriptor->second.image_layout != VK_IMAGE_LAYOUT_UNDEFINED) {
    snapshot->valid_flags |= DETROIT_DLSS_IMAGE_DESCRIPTOR_LAYOUT_VALID;
  }

  const auto image_view = state.image_views.find(snapshot->resource.image_view);
  if (image_view == state.image_views.end()
      || image_view->second.image == VK_NULL_HANDLE) {
    return false;
  }
  snapshot->resource.image = ToOpaque(image_view->second.image);
  snapshot->resource.format = static_cast<std::uint32_t>(image_view->second.format);
  snapshot->resource.mip_level = image_view->second.subresource_range.baseMipLevel;
  snapshot->resource.array_layer = image_view->second.subresource_range.baseArrayLayer;
  snapshot->view_type = static_cast<std::uint32_t>(image_view->second.type);
  snapshot->aspect_mask = image_view->second.subresource_range.aspectMask;
  snapshot->valid_flags |= DETROIT_DLSS_IMAGE_VIEW_VALID;
  if (image_view->second.format != VK_FORMAT_UNDEFINED) {
    snapshot->valid_flags |= DETROIT_DLSS_IMAGE_FORMAT_VALID;
  }

  const auto image = state.images.find(snapshot->resource.image);
  if (image == state.images.end()) return false;
  snapshot->image_format = static_cast<std::uint32_t>(image->second.format);
  snapshot->image_type = static_cast<std::uint32_t>(image->second.type);
  snapshot->image_mip_levels = image->second.mip_levels;
  snapshot->image_array_layers = image->second.array_layers;
  snapshot->image_width = image->second.extent.width;
  snapshot->image_height = image->second.extent.height;
  snapshot->image_depth = image->second.extent.depth;
  snapshot->sample_count = static_cast<std::uint32_t>(image->second.samples);
  snapshot->image_usage = image->second.usage;
  snapshot->image_create_flags = image->second.flags;
  snapshot->valid_flags |= DETROIT_DLSS_IMAGE_VALID;

  const auto& range = image_view->second.subresource_range;
  if (range.baseMipLevel < image->second.mip_levels
      && range.baseArrayLayer < image->second.array_layers) {
    const std::uint32_t available_levels =
        image->second.mip_levels - range.baseMipLevel;
    const std::uint32_t available_layers =
        image->second.array_layers - range.baseArrayLayer;
    snapshot->level_count = range.levelCount == VK_REMAINING_MIP_LEVELS
                                ? available_levels
                                : range.levelCount;
    snapshot->layer_count = range.layerCount == VK_REMAINING_ARRAY_LAYERS
                                ? available_layers
                                : range.layerCount;
    if (snapshot->level_count != 0u && snapshot->level_count <= available_levels
        && snapshot->layer_count != 0u && snapshot->layer_count <= available_layers) {
      snapshot->valid_flags |= DETROIT_DLSS_IMAGE_SUBRESOURCE_VALID;
    }
  }

  snapshot->resource.width = MipExtent(image->second.extent.width, range.baseMipLevel);
  snapshot->resource.height = MipExtent(image->second.extent.height, range.baseMipLevel);
  if (snapshot->resource.width != 0u && snapshot->resource.height != 0u
      && image->second.extent.depth != 0u) {
    snapshot->valid_flags |= DETROIT_DLSS_IMAGE_EXTENT_VALID;
  }
  return (snapshot->valid_flags & DETROIT_DLSS_IMAGE_MANDATORY_MASK)
         == DETROIT_DLSS_IMAGE_MANDATORY_MASK;
}

bool HasRequiredTemporalDescriptors(const DescriptorSetState& descriptor_set) {
  for (const std::uint32_t binding : kTemporalImageBindings) {
    if ((BindingMask(binding) & DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK) == 0u) {
      continue;
    }
    const auto image = descriptor_set.image_descriptors.find(
        DescriptorSlotKey(binding, 0u));
    if (image == descriptor_set.image_descriptors.end()
        || !IsImageDescriptorType(image->second.descriptor_type)
        || image->second.image_view == VK_NULL_HANDLE) {
      return false;
    }
  }
  const auto constants = descriptor_set.buffer_descriptors.find(
      DescriptorSlotKey(DETROIT_DLSS_TAA_CONSTANT_BINDING_52, 0u));
  return constants != descriptor_set.buffer_descriptors.end()
         && IsDynamicBufferDescriptorType(constants->second.descriptor_type)
         && constants->second.buffer != VK_NULL_HANDLE;
}

std::optional<std::pair<VkDescriptorSet, DescriptorSetState*>>
ResolveExpectedTemporalDescriptorSetLocked(
    DeviceState* state,
    std::uint32_t descriptor_set_index,
    VkDescriptorSet expected_descriptor_set,
    VkPipelineLayout expected_pipeline_layout) {
  if (expected_descriptor_set == VK_NULL_HANDLE) return std::nullopt;
  const auto pipeline_layout =
      state->pipeline_layouts.find(ToOpaque(expected_pipeline_layout));
  if (pipeline_layout == state->pipeline_layouts.end()
      || descriptor_set_index >= pipeline_layout->second.set_layouts.size()) {
    return std::nullopt;
  }
  const auto descriptor_set =
      state->descriptor_sets.find(ToOpaque(expected_descriptor_set));
  if (descriptor_set == state->descriptor_sets.end()
      || descriptor_set->second.layout
             != pipeline_layout->second.set_layouts[descriptor_set_index]
      || !HasRequiredTemporalDescriptors(descriptor_set->second)) {
    return std::nullopt;
  }
  return std::pair{expected_descriptor_set, &descriptor_set->second};
}

std::uint64_t HashTemporalConstants(std::span<const std::uint8_t> bytes) {
  std::uint64_t hash = UINT64_C(14695981039346656037);
  for (const std::uint8_t byte : bytes) {
    hash ^= byte;
    hash *= UINT64_C(1099511628211);
  }
  return hash;
}

bool ReadTemporalConstantsBytesLocked(
    const DeviceState& state,
    const BufferState& buffer,
    VkDeviceSize effective_offset,
    std::array<std::uint8_t, kReflectedTemporalConstantsSize>* bytes) {
  if (bytes == nullptr || buffer.memory == VK_NULL_HANDLE
      || effective_offset > buffer.size
      || kReflectedTemporalConstantsSize > buffer.size - effective_offset) {
    return false;
  }
  const auto memory = state.memories.find(ToOpaque(buffer.memory));
  if (memory == state.memories.end()) return false;
  std::uint64_t absolute_offset = 0u;
  if (!AddWithoutOverflow(
          buffer.memory_offset, effective_offset, &absolute_offset)) {
    return false;
  }
  if (memory->second.mapped_pointer != nullptr) {
    if (absolute_offset < memory->second.mapped_offset) return false;
    const std::uint64_t relative =
        absolute_offset - memory->second.mapped_offset;
    if (relative > memory->second.mapped_size
        || kReflectedTemporalConstantsSize
               > memory->second.mapped_size - relative) {
      return false;
    }
    std::memcpy(
        bytes->data(),
        static_cast<const std::uint8_t*>(memory->second.mapped_pointer)
            + relative,
        bytes->size());
    return true;
  }
  const auto offset = static_cast<std::size_t>(effective_offset);
  if (offset > buffer.shadow_bytes.size()
      || bytes->size() > buffer.shadow_bytes.size() - offset
      || buffer.shadow_valid_bytes.size() != buffer.shadow_bytes.size()
      || !std::all_of(
          buffer.shadow_valid_bytes.begin() + offset,
          buffer.shadow_valid_bytes.begin() + offset + bytes->size(),
          [](std::uint8_t valid) { return valid != 0u; })) {
    return false;
  }
  std::memcpy(bytes->data(), buffer.shadow_bytes.data() + offset, bytes->size());
  return true;
}

std::optional<VkDeviceSize> ResolveChangedTemporalConstantsSlotLocked(
    DeviceState* state,
    DescriptorSetState* descriptor_set,
    const DetroitDlssTemporalDescriptorSnapshot& snapshot) {
  const auto descriptor = descriptor_set->buffer_descriptors.find(
      DescriptorSlotKey(DETROIT_DLSS_TAA_CONSTANT_BINDING_52, 0u));
  if (descriptor == descriptor_set->buffer_descriptors.end()
      || !IsDynamicBufferDescriptorType(descriptor->second.descriptor_type)) {
    return std::nullopt;
  }
  const auto tracked_buffer =
      state->buffers.find(ToOpaque(descriptor->second.buffer));
  if (tracked_buffer == state->buffers.end()) return std::nullopt;
  auto& buffer = tracked_buffer->second;
  const VkDeviceSize alignment =
      std::max<VkDeviceSize>(state->min_uniform_buffer_offset_alignment, 1u);
  if (alignment > std::numeric_limits<VkDeviceSize>::max()
                      - (kReflectedTemporalConstantsSize - 1u)) {
    return std::nullopt;
  }
  const VkDeviceSize stride =
      ((kReflectedTemporalConstantsSize + alignment - 1u) / alignment)
      * alignment;
  if (stride == 0u || descriptor->second.offset > buffer.size) {
    return std::nullopt;
  }

  auto& offsets = buffer.temporal_slot_scratch_offsets;
  auto& hashes = buffer.temporal_slot_scratch_hashes;
  offsets.clear();
  hashes.clear();
  offsets.reserve(buffer.temporal_slot_offsets.size());
  hashes.reserve(buffer.temporal_slot_hashes.size());
  bool topology_changed = !buffer.temporal_slot_hashes_primed;
  std::optional<VkDeviceSize> changed_slot;
  bool ambiguous = false;
  const std::uint32_t render_width = snapshot.images[1u].resource.width;
  const std::uint32_t render_height = snapshot.images[1u].resource.height;
  const std::uint32_t output_width = snapshot.images[9u].resource.width;
  const std::uint32_t output_height = snapshot.images[9u].resource.height;
  for (VkDeviceSize dynamic_offset = 0u;;) {
    std::uint64_t effective_offset = 0u;
    if (!AddWithoutOverflow(
            descriptor->second.offset, dynamic_offset, &effective_offset)
        || effective_offset > buffer.size
        || kReflectedTemporalConstantsSize > buffer.size - effective_offset) {
      break;
    }
    std::array<std::uint8_t, kReflectedTemporalConstantsSize> bytes = {};
    if (!ReadTemporalConstantsBytesLocked(
            *state, buffer, effective_offset, &bytes)) {
      return std::nullopt;
    }
    const std::size_t slot_index = offsets.size();
    const std::uint64_t hash = HashTemporalConstants(bytes);
    offsets.push_back(dynamic_offset);
    hashes.push_back(hash);
    if (!topology_changed) {
      if (slot_index >= buffer.temporal_slot_offsets.size()
          || slot_index >= buffer.temporal_slot_hashes.size()
          || buffer.temporal_slot_offsets[slot_index] != dynamic_offset) {
        topology_changed = true;
      } else if (hash != buffer.temporal_slot_hashes[slot_index]) {
        const auto decoded =
            renodx::games::detroitbecomehuman::taa_contract::DecodeConstants(
                std::as_bytes(std::span(bytes)));
        const bool frame_valid =
            decoded.has_value()
            && renodx::games::detroitbecomehuman::taa_contract::
                   BuildNgxFrameParameters(
                       decoded->raw,
                       render_width,
                       render_height,
                       output_width,
                       output_height)
                       .IsValid();
        if (!frame_valid || changed_slot.has_value()) {
          ambiguous = true;
        } else {
          changed_slot = dynamic_offset;
        }
      }
    }
    if (dynamic_offset > std::numeric_limits<VkDeviceSize>::max() - stride) {
      break;
    }
    dynamic_offset += stride;
  }
  if (offsets.empty()) return std::nullopt;

  topology_changed |= buffer.temporal_slot_offsets.size() != offsets.size()
                      || buffer.temporal_slot_hashes.size() != hashes.size();
  buffer.temporal_slot_offsets.swap(offsets);
  buffer.temporal_slot_hashes.swap(hashes);
  buffer.temporal_slot_hashes_primed = true;
  if (topology_changed) return std::nullopt;
  return !ambiguous ? changed_slot : std::nullopt;
}

DetroitDlssResultCode DETROIT_DLSS_CALL BridgeGetTemporalSnapshot(
    std::uint64_t command_buffer,
    std::uint32_t descriptor_set_index,
    std::uint64_t expected_descriptor_set,
    std::uint64_t expected_pipeline_layout,
    DetroitDlssTemporalDescriptorSnapshot* snapshot) {
  if (snapshot == nullptr || snapshot->struct_size < sizeof(*snapshot)
      || snapshot->abi_version != DETROIT_DLSS_ABI_VERSION || command_buffer == 0u) {
    return DETROIT_DLSS_RESULT_ERROR;
  }

  const auto struct_size = snapshot->struct_size;
  *snapshot = {};
  snapshot->struct_size = struct_size;
  snapshot->abi_version = DETROIT_DLSS_ABI_VERSION;
  snapshot->descriptor_set_index = descriptor_set_index;
  snapshot->image_binding_count = DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT;
  snapshot->command_buffer = command_buffer;
  snapshot->required_image_mask = DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK;
  snapshot->constants = {
      .struct_size = sizeof(DetroitDlssTemporalConstantsSnapshot),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .descriptor_set_index = descriptor_set_index,
      .binding = DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
      .command_buffer = command_buffer,
  };
  snapshot->constants_diagnostics.struct_size =
      sizeof(DetroitDlssTemporalConstantsDiagnostics);

  const auto set_detail = [&](DetroitDlssTemporalSnapshotDetail detail) {
    if (snapshot->detail_code == DETROIT_DLSS_SNAPSHOT_DETAIL_NONE) {
      snapshot->detail_code = detail;
    }
  };
  const auto state =
      FindDeviceSharedFast(FromOpaque<VkCommandBuffer>(command_buffer));
  if (state == nullptr || !state->supported_executable
      || state->destroying.load(std::memory_order_acquire)) {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_DEVICE_UNAVAILABLE);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  auto* local_recording =
      GetThreadComputeCommandStates().Find(command_buffer);
  if (local_recording == nullptr || !local_recording->recording_active) {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_COMMAND_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const std::lock_guard lock(state->tracking_mutex);
  VkDescriptorSet resolved_descriptor_set = VK_NULL_HANDLE;
  DescriptorSetState* resolved_descriptor_state = nullptr;
  bool targeted_update_resolved = false;
  std::optional<VkDeviceSize> targeted_constants_dynamic_offset;
  const auto command = state->command_buffer_descriptors.find(command_buffer);
  if (command != state->command_buffer_descriptors.end()) {
    snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_COMMAND_TRACKED;
    const auto anchor_bound = command->second.find(CommandDescriptorKey(
        descriptor_set_index, DETROIT_DLSS_TAA_SAMPLED_BINDING_1));
    if (anchor_bound == command->second.end()) {
      set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_SET_UNBOUND);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
    snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_SET_BOUND;
    resolved_descriptor_set = anchor_bound->second.descriptor_set;
    snapshot->pipeline_layout = ToOpaque(anchor_bound->second.pipeline_layout);
    const auto restore = state->command_buffer_restore_states.find(command_buffer);
    if (restore != state->command_buffer_restore_states.end()) {
      snapshot->compute_pipeline = ToOpaque(restore->second.pipeline);
    }
  } else {
    if (expected_descriptor_set == 0u || expected_pipeline_layout == 0u) {
      set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_COMMAND_UNTRACKED);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
    const auto targeted = ResolveExpectedTemporalDescriptorSetLocked(
        state.get(),
        descriptor_set_index,
        FromOpaque<VkDescriptorSet>(expected_descriptor_set),
        FromOpaque<VkPipelineLayout>(expected_pipeline_layout));
    if (!targeted.has_value()) {
      set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_TARGETED_SET_UNAVAILABLE);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
    resolved_descriptor_set = targeted->first;
    resolved_descriptor_state = targeted->second;
    snapshot->pipeline_layout = expected_pipeline_layout;
    snapshot->snapshot_flags |=
        DETROIT_DLSS_SNAPSHOT_TARGETED_UPDATE_RESOLVED;
    targeted_update_resolved = true;
  }
  snapshot->descriptor_set = ToOpaque(resolved_descriptor_set);

  if (expected_descriptor_set == 0u || snapshot->descriptor_set == expected_descriptor_set) {
    snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_EXPECTED_SET_MATCH;
  } else {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_DESCRIPTOR_SET_MISMATCH);
  }
  if (expected_pipeline_layout == 0u
      || snapshot->pipeline_layout == expected_pipeline_layout) {
    snapshot->snapshot_flags |=
        DETROIT_DLSS_SNAPSHOT_EXPECTED_PIPELINE_LAYOUT_MATCH;
  } else {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_PIPELINE_LAYOUT_MISMATCH);
  }

  const auto descriptor_set = state->descriptor_sets.find(snapshot->descriptor_set);
  if (descriptor_set == state->descriptor_sets.end()) {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_DESCRIPTOR_SET_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  resolved_descriptor_state = &descriptor_set->second;
  snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_DESCRIPTOR_SET_TRACKED;

  const auto pipeline_layout = state->pipeline_layouts.find(snapshot->pipeline_layout);
  if (pipeline_layout != state->pipeline_layouts.end()
      && descriptor_set_index < pipeline_layout->second.set_layouts.size()
      && pipeline_layout->second.set_layouts[descriptor_set_index]
             == descriptor_set->second.layout) {
    snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_PIPELINE_LAYOUT_TRACKED;
  } else {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_PIPELINE_LAYOUT_UNTRACKED);
  }

  for (std::size_t index = 0u; index < kTemporalImageBindings.size(); ++index) {
    const std::uint32_t binding = kTemporalImageBindings[index];
    const bool required =
        (BindingMask(binding) & DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK) != 0u;
    auto& image_snapshot = snapshot->images[index];
    const bool complete = FillImageBindingLocked(
        *state,
         *resolved_descriptor_state,
         resolved_descriptor_set,
        binding,
        &image_snapshot);
    if ((image_snapshot.valid_flags & DETROIT_DLSS_IMAGE_DESCRIPTOR_VALID) != 0u) {
      snapshot->present_image_mask |= BindingMask(binding);
    } else if (required) {
      set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_IMAGE_DESCRIPTOR_MISSING);
    }
    if (complete) {
      snapshot->complete_image_mask |= BindingMask(binding);
    } else if (required) {
      if ((image_snapshot.valid_flags & DETROIT_DLSS_IMAGE_VIEW_VALID) == 0u
          && (image_snapshot.valid_flags & DETROIT_DLSS_IMAGE_DESCRIPTOR_VALID) != 0u) {
        set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_IMAGE_VIEW_UNTRACKED);
      } else if ((image_snapshot.valid_flags & DETROIT_DLSS_IMAGE_VALID) == 0u
                 && (image_snapshot.valid_flags & DETROIT_DLSS_IMAGE_VIEW_VALID) != 0u) {
        set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_IMAGE_UNTRACKED);
      } else {
        set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_IMAGE_METADATA_INCOMPLETE);
      }
    }
  }
  if ((snapshot->complete_image_mask & snapshot->required_image_mask)
      == snapshot->required_image_mask) {
    snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_REQUIRED_IMAGES_COMPLETE;
  } else {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_REQUIRED_IMAGES_INCOMPLETE);
  }

  if (targeted_update_resolved) {
    targeted_constants_dynamic_offset = ResolveChangedTemporalConstantsSlotLocked(
        state.get(), resolved_descriptor_state, *snapshot);
    if (!targeted_constants_dynamic_offset.has_value()) {
      set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_CONSTANTS_SLOT_AMBIGUOUS);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
  }

  const auto constants_status = targeted_update_resolved
      ? FillTemporalConstantsForBindingLocked(
            *state,
            command_buffer,
            descriptor_set_index,
            DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
            snapshot->descriptor_set,
            snapshot->pipeline_layout,
            *targeted_constants_dynamic_offset,
            true,
            &snapshot->constants,
            &snapshot->constants_diagnostics)
      : FillTemporalConstantsLocked(
            *state,
            command_buffer,
            descriptor_set_index,
            DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
            &snapshot->constants,
            &snapshot->constants_diagnostics);
  if ((snapshot->constants.valid_flags & DETROIT_DLSS_CONSTANTS_DESCRIPTOR_VALID) != 0u) {
    snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_CONSTANTS_DESCRIPTOR_VALID;
  }
  if (constants_status == DETROIT_DLSS_RESULT_SUCCESS
      && (snapshot->constants.valid_flags & DETROIT_DLSS_CONSTANTS_PAYLOAD_VALID) != 0u) {
    snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_CONSTANTS_PAYLOAD_VALID;
  } else {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_CONSTANTS_UNAVAILABLE);
  }

  const bool command_acquired =
      (snapshot->snapshot_flags
       & DETROIT_DLSS_SNAPSHOT_COMMAND_ACQUISITION_MASK)
          == DETROIT_DLSS_SNAPSHOT_COMMAND_ACQUISITION_MASK
      || (snapshot->snapshot_flags
          & DETROIT_DLSS_SNAPSHOT_TARGETED_UPDATE_RESOLVED)
             != 0u;
  const bool snapshot_complete =
      snapshot->detail_code == DETROIT_DLSS_SNAPSHOT_DETAIL_NONE
      && command_acquired
      && (snapshot->snapshot_flags
          & DETROIT_DLSS_SNAPSHOT_COMMON_MANDATORY_MASK)
             == DETROIT_DLSS_SNAPSHOT_COMMON_MANDATORY_MASK;
  if (!snapshot_complete) return DETROIT_DLSS_RESULT_FALLBACK;
  if (!PublishThreadCommandRecordingLocked(
          state.get(), command_buffer, local_recording)) {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_COMMAND_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  return DETROIT_DLSS_RESULT_SUCCESS;
}

DetroitDlssResultCode DETROIT_DLSS_CALL BridgeQueryMode(
    DetroitDlssMode mode,
    std::uint32_t output_width,
    std::uint32_t output_height,
    DetroitDlssModeSettings* settings) {
  if (settings == nullptr || settings->struct_size < sizeof(*settings)
      || settings->abi_version != DETROIT_DLSS_ABI_VERSION || output_width == 0u
      || output_height == 0u) {
    return DETROIT_DLSS_RESULT_ERROR;
  }
  TraceEvaluationMessage(std::format(
      "DLSS event=query_mode_begin mode={} output={}x{}",
      static_cast<std::uint32_t>(mode),
      output_width,
      output_height));

  const auto struct_size = settings->struct_size;
  *settings = {};
  settings->struct_size = struct_size;
  settings->abi_version = DETROIT_DLSS_ABI_VERSION;
  settings->mode = mode;
  settings->output_width = output_width;
  settings->output_height = output_height;
  if (mode != DETROIT_DLSS_MODE_NATIVE
      && mode != DETROIT_DLSS_MODE_DLAA) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (mode == DETROIT_DLSS_MODE_NATIVE) {
    settings->render_width = output_width;
    settings->render_height = output_height;
    settings->min_render_width = output_width;
    settings->min_render_height = output_height;
    settings->max_render_width = output_width;
    settings->max_render_height = output_height;
    return DETROIT_DLSS_RESULT_SUCCESS;
  }

  // The exact native TAA computes history UV as current_uv - MotionVectorTex
  // and never applies its b52 jitter coordinates to that lookup. Therefore b4
  // already includes the inter-frame jitter displacement; tell NGX explicitly
  // so it does not apply a second jitter correction to those motion vectors.
  settings->create_flags = DETROIT_DLSS_CREATE_HDR
                           | DETROIT_DLSS_CREATE_MOTION_VECTORS_LOW_RESOLUTION
                           | DETROIT_DLSS_CREATE_DEPTH_INVERTED
                           | DETROIT_DLSS_CREATE_MOTION_VECTORS_JITTERED
                           | DETROIT_DLSS_CREATE_AUTO_EXPOSURE;

  const auto state = GetActiveDevice();
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const std::lock_guard lock(state->mutex);
  if (state->destroying.load(std::memory_order_acquire)) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (!EnsureNgxInitialized(state.get())) return DETROIT_DLSS_RESULT_FALLBACK;

  renodx::utils::dlss::vulkan::ModeSettings queried = {};
  const auto query_result = state->ngx_context->QueryMode(
      {
          .mode = ToNgxQuality(),
          .output_width = output_width,
          .output_height = output_height,
      },
      &queried);
  if (!query_result.Succeeded()
      || queried.optimal_width == 0u || queried.optimal_height == 0u
      || queried.optimal_width != output_width
      || queried.optimal_height != output_height) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  // This Detroit integration is DLAA-only. Query NGX to prove support, but
  // never publish a reduced internal render extent.
  settings->render_width = output_width;
  settings->render_height = output_height;
  settings->max_render_width = output_width;
  settings->max_render_height = output_height;
  settings->min_render_width = output_width;
  settings->min_render_height = output_height;
  TraceEvaluationMessage(std::format(
      "DLSS event=query_mode_end status=success mode={} create_flags=0x{:X} render={}x{} output={}x{}",
      static_cast<std::uint32_t>(mode),
      settings->create_flags,
      settings->render_width,
      settings->render_height,
      settings->output_width,
      settings->output_height));
  return DETROIT_DLSS_RESULT_SUCCESS;
}

DetroitDlssResultCode DETROIT_DLSS_CALL BridgeConfigure(
    const DetroitDlssModeSettings* settings) {
  if (settings == nullptr || settings->struct_size < sizeof(*settings)
      || settings->abi_version != DETROIT_DLSS_ABI_VERSION
      || (settings->create_flags & ~DETROIT_DLSS_CREATE_KNOWN_MASK) != 0u
      || settings->output_width == 0u || settings->output_height == 0u
      || settings->render_width == 0u || settings->render_height == 0u) {
    return DETROIT_DLSS_RESULT_ERROR;
  }
  TraceEvaluationMessage(std::format(
      "DLSS event=configure_begin mode={} create_flags=0x{:X} render={}x{} output={}x{}",
      static_cast<std::uint32_t>(settings->mode),
      settings->create_flags,
      settings->render_width,
      settings->render_height,
      settings->output_width,
      settings->output_height));

  const auto state = GetActiveDevice();
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const std::lock_guard lock(state->mutex);
  if (state->destroying.load(std::memory_order_acquire)
      || state->context_identity != state->identity) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (settings->mode != DETROIT_DLSS_MODE_NATIVE
      && settings->mode != DETROIT_DLSS_MODE_DLAA) {
    RetireActiveFeatureLocked(state.get());
    state->configured = false;
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const bool fixed_native_extent =
      settings->render_width == settings->output_width
      && settings->render_height == settings->output_height
      && settings->min_render_width == settings->output_width
      && settings->min_render_height == settings->output_height
      && settings->max_render_width == settings->output_width
      && settings->max_render_height == settings->output_height;
  if (!fixed_native_extent) {
    RetireActiveFeatureLocked(state.get());
    state->configured = false;
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (settings->mode != DETROIT_DLSS_MODE_NATIVE
      && !EnsureNgxInitialized(state.get())) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const bool settings_changed =
      !state->configured
      || std::memcmp(&state->settings, settings, sizeof(*settings)) != 0;
  if (state->configured && settings_changed) {
    RetireActiveFeatureLocked(state.get());
  }
  if (settings->mode == DETROIT_DLSS_MODE_NATIVE) {
    RetireActiveFeatureLocked(state.get());
  }
  if (settings_changed && GetEvaluationTraceConfiguration().first_three) {
    // A process-wide counter can be exhausted while the user is still in a
    // different AA mode. Start a fresh bounded window on the actual non-native
    // configuration transition and discard only old diagnostic tombstones.
    state->submission_trace_tracker.Clear();
    if (settings->mode != DETROIT_DLSS_MODE_NATIVE) {
      const auto trace_window = state->evaluation_trace_window.Arm();
      try {
        TraceEvaluationMessage(std::format(
            "DLSS trace_window={} event=armed mode={} render={}x{} output={}x{}",
            trace_window,
            static_cast<std::uint32_t>(settings->mode),
            settings->render_width,
            settings->render_height,
            settings->output_width,
            settings->output_height));
      } catch (...) {
        // Diagnostic formatting must not affect a mode transition.
      }
    }
  }
  state->settings = *settings;
  state->configured = true;
  state->configured_identity = state->context_identity;
  TraceEvaluationMessage(std::format(
      "DLSS event=configure_end status=success mode={} settings_changed={} identity={}",
      static_cast<std::uint32_t>(settings->mode),
      settings_changed,
      state->configured_identity));
  return DETROIT_DLSS_RESULT_SUCCESS;
}

[[maybe_unused]] bool LegacyCaptureComputeRestoreState(
    DeviceState* state,
    const DetroitDlssTemporalFrameInputs& inputs,
    ComputeCommandRestoreState* restore) {
  if (state == nullptr || restore == nullptr) return false;
  const std::lock_guard lock(state->tracking_mutex);
  const auto command_pool = state->command_buffer_pools.find(inputs.command_buffer);
  const auto command_level = state->command_buffer_levels.find(inputs.command_buffer);
  const auto command_usage =
      state->command_buffer_usage_flags.find(inputs.command_buffer);
  const auto command_generation =
      state->command_buffer_recording_generations.find(inputs.command_buffer);
  if (command_pool == state->command_buffer_pools.end()
      || command_level == state->command_buffer_levels.end()
      || command_level->second != VK_COMMAND_BUFFER_LEVEL_PRIMARY
      || command_usage == state->command_buffer_usage_flags.end()
      || command_generation
             == state->command_buffer_recording_generations.end()
      || command_generation->second == 0u) {
    return false;
  }
  const auto pool = state->command_pools.find(command_pool->second);
  if (pool == state->command_pools.end()
      || pool->second.queue_family_index != state->graphics_queue_family
      || (pool->second.flags & VK_COMMAND_POOL_CREATE_PROTECTED_BIT) != 0u) {
    return false;
  }
  const auto found = state->command_buffer_restore_states.find(inputs.command_buffer);
  if (found != state->command_buffer_restore_states.end()) {
    if (found->second.pipeline == VK_NULL_HANDLE
        || found->second.descriptor_layout == VK_NULL_HANDLE
        || found->second.descriptor_sets.empty()
        || ToOpaque(found->second.descriptor_layout) != inputs.pipeline_layout
        || inputs.descriptor_set_index < found->second.first_set) {
      return false;
    }
    const std::uint64_t relative_set =
        static_cast<std::uint64_t>(inputs.descriptor_set_index)
        - found->second.first_set;
    if (relative_set >= found->second.descriptor_sets.size()
        || ToOpaque(found->second.descriptor_sets[relative_set])
               != inputs.descriptor_set) {
      return false;
    }
    restore->pipeline = found->second.pipeline;
    restore->descriptor_layout = found->second.descriptor_layout;
    restore->first_set = found->second.first_set;
    restore->descriptor_sets.assign(
        found->second.descriptor_sets.begin(),
        found->second.descriptor_sets.end());
    restore->dynamic_offsets.assign(
        found->second.dynamic_offsets.begin(), found->second.dynamic_offsets.end());
    restore->one_time_submit = found->second.one_time_submit;
    return true;
  }

  if (inputs.compute_pipeline == 0u || inputs.pipeline_layout == 0u
      || inputs.descriptor_set == 0u
      || inputs.constants_dynamic_offset
             > std::numeric_limits<std::uint32_t>::max()) {
    return false;
  }
  const auto pipeline_layout =
      state->pipeline_layouts.find(inputs.pipeline_layout);
  const auto descriptor_set = state->descriptor_sets.find(inputs.descriptor_set);
  if (pipeline_layout == state->pipeline_layouts.end()
      || descriptor_set == state->descriptor_sets.end()
      || inputs.descriptor_set_index != DETROIT_DLSS_TAA_DESCRIPTOR_SET
      || pipeline_layout->second.set_layouts.size() != 1u
      || inputs.descriptor_set_index
             >= pipeline_layout->second.set_layouts.size()
      || pipeline_layout->second.set_layouts[inputs.descriptor_set_index]
             != descriptor_set->second.layout) {
    return false;
  }
  const auto descriptor_layout = state->descriptor_set_layouts.find(
      ToOpaque(descriptor_set->second.layout));
  if (descriptor_layout == state->descriptor_set_layouts.end()) {
    return false;
  }
  std::uint64_t dynamic_descriptor_count = 0u;
  bool constants_is_only_dynamic_descriptor = false;
  for (const auto& binding : descriptor_layout->second.bindings) {
    if (!IsDynamicBufferDescriptorType(binding.descriptor_type)) continue;
    dynamic_descriptor_count += binding.descriptor_count;
    constants_is_only_dynamic_descriptor =
        binding.binding == DETROIT_DLSS_TAA_CONSTANT_BINDING_52
        && binding.descriptor_count == 1u;
  }
  if (dynamic_descriptor_count != 1u
      || !constants_is_only_dynamic_descriptor) {
    return false;
  }
  restore->pipeline = FromOpaque<VkPipeline>(inputs.compute_pipeline);
  restore->descriptor_layout =
      FromOpaque<VkPipelineLayout>(inputs.pipeline_layout);
  restore->first_set = inputs.descriptor_set_index;
  restore->descriptor_sets.assign(
      1u, FromOpaque<VkDescriptorSet>(inputs.descriptor_set));
  restore->dynamic_offsets.assign(
      1u, static_cast<std::uint32_t>(inputs.constants_dynamic_offset));
  restore->one_time_submit =
      (command_usage->second & VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT)
             != 0u;
  return true;
}

bool CaptureComputeRestoreState(
    DeviceState* state,
    const DetroitDlssTemporalFrameInputs& inputs,
    ComputeCommandRestoreState* restore) {
  if (state == nullptr || restore == nullptr || inputs.compute_pipeline == 0u
      || inputs.pipeline_layout == 0u || inputs.descriptor_set == 0u
      || inputs.descriptor_set_index != DETROIT_DLSS_TAA_DESCRIPTOR_SET
      || inputs.constants_dynamic_offset
             > std::numeric_limits<std::uint32_t>::max()) {
    return false;
  }

  renodx::games::detroitbecomehuman::dlss::embedded::
      CommandRecordingMetadata metadata = {};
  if (!renodx::games::detroitbecomehuman::dlss::embedded::
          ClaimCommandRecordingEvaluation(
              inputs.command_buffer,
              inputs.pipeline_layout,
              inputs.descriptor_set,
              &metadata)
      || metadata.constants_dynamic_offset
             != inputs.constants_dynamic_offset) {
    return false;
  }

  restore->pipeline = FromOpaque<VkPipeline>(inputs.compute_pipeline);
  restore->descriptor_layout =
      FromOpaque<VkPipelineLayout>(inputs.pipeline_layout);
  restore->first_set = inputs.descriptor_set_index;
  restore->descriptor_sets.assign(
      1u, FromOpaque<VkDescriptorSet>(inputs.descriptor_set));
  restore->dynamic_offsets.assign(1u, metadata.constants_dynamic_offset);
  restore->recording_generation = metadata.recording_generation;
  restore->one_time_submit =
      (metadata.begin_flags & VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT)
      != 0u;
  return true;
}

bool RestoreComputeCommandState(
    DeviceState* state,
    VkCommandBuffer command_buffer,
    const ComputeCommandRestoreState& restore) {
  const auto bind_pipeline = state->next_cmd_bind_pipeline;
  const auto bind_descriptor_sets = state->next_cmd_bind_descriptor_sets;
  if (bind_pipeline == nullptr || bind_descriptor_sets == nullptr
      || restore.pipeline == VK_NULL_HANDLE || restore.descriptor_layout == VK_NULL_HANDLE
      || restore.descriptor_sets.empty()) {
    return false;
  }
  bind_pipeline(command_buffer, VK_PIPELINE_BIND_POINT_COMPUTE, restore.pipeline);
  bind_descriptor_sets(
      command_buffer,
      VK_PIPELINE_BIND_POINT_COMPUTE,
      restore.descriptor_layout,
      restore.first_set,
      static_cast<std::uint32_t>(restore.descriptor_sets.size()),
      restore.descriptor_sets.data(),
      static_cast<std::uint32_t>(restore.dynamic_offsets.size()),
      restore.dynamic_offsets.empty() ? nullptr : restore.dynamic_offsets.data());
  return true;
}

bool CanRestoreComputeCommandState(
    const DeviceState* state,
    const ComputeCommandRestoreState& restore) {
  return state != nullptr && state->next_cmd_bind_pipeline != nullptr
         && state->next_cmd_bind_descriptor_sets != nullptr
         && restore.pipeline != VK_NULL_HANDLE
         && restore.descriptor_layout != VK_NULL_HANDLE
         && !restore.descriptor_sets.empty();
}

void PollCompletedInternalFeatureFences(DeviceState* state);

DetroitDlssResultCode DETROIT_DLSS_CALL BridgeEvaluate(
    const DetroitDlssTemporalFrameInputs* inputs,
    DetroitDlssEvaluateResult* result) {
  if (result == nullptr || result->struct_size < sizeof(*result)
      || result->abi_version != DETROIT_DLSS_ABI_VERSION) {
    return DETROIT_DLSS_RESULT_ERROR;
  }
  if (inputs == nullptr || inputs->struct_size < sizeof(*inputs)
      || inputs->abi_version != DETROIT_DLSS_ABI_VERSION) {
    SetEvaluationResult(result, DETROIT_DLSS_RESULT_ERROR, BridgeDetail::kInvalidAbi, 0u);
    return DETROIT_DLSS_RESULT_ERROR;
  }
  const std::uint64_t frame_id = inputs->frame_id;

  if ((inputs->verification_flags & DETROIT_DLSS_VERIFY_MANDATORY_MASK)
      != DETROIT_DLSS_VERIFY_MANDATORY_MASK) {
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kTemporalContractUnverified,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const auto command_buffer = FromOpaque<VkCommandBuffer>(inputs->command_buffer);
  const auto state = inputs->command_buffer == 0u
                         ? nullptr
                         : FindDeviceSharedFast(command_buffer);
  if (state == nullptr) {
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kNoActiveDevice, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (!IsActiveDevice(state)) {
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kDeviceIdentityMismatch,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  std::array<VkCommandBuffer, kMaximumAdapterScratchBundles>
      completed_one_time_command_buffers = {};
  const auto completed_one_time_count =
      state->adapter_runtime.PollCompletedOneTimeCommandBuffers(
          completed_one_time_command_buffers);

  const std::lock_guard lock(state->mutex);
  EvaluationTraceRecord trace_record = {
      .frame = frame_id,
      .mode = state->settings.mode,
      .command_buffer = inputs->command_buffer,
      .consumer_image = inputs->output.image,
      .consumer_view = inputs->output.image_view,
      .readback_requested = GetEvaluationTraceConfiguration().readback,
  };
  if (GetEvaluationTraceConfiguration().first_three) {
    const auto attempt = state->evaluation_trace_window.Begin();
    if (attempt.has_value()) {
      trace_record.trace_window = attempt->window;
      trace_record.attempt = attempt->attempt;
      TraceEvaluationInputs(trace_record, *inputs);
    }
  }
  if (state->destroying.load(std::memory_order_acquire)
      || state->context_identity != state->identity) {
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kDeviceIdentityMismatch);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kDeviceIdentityMismatch,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  for (std::size_t index = 0u; index < completed_one_time_count; ++index) {
    const auto completed = ToOpaque(completed_one_time_command_buffers[index]);
    if (state->ngx_context != nullptr) {
      state->ngx_context->DiscardRecording(completed);
    }
    (void)state->submission_trace_tracker.Discard(completed);
    UnmarkFeatureRecordingCandidateLocked(state.get(), completed);
  }
  if (completed_one_time_count != 0u) {
    UpdateFeatureTrackingStateLocked(state.get());
  }
  if (!state->configured) {
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kNotConfigured);
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kNotConfigured, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (state->configured_identity != state->identity) {
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kDeviceIdentityMismatch);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kDeviceIdentityMismatch,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (state->settings.mode != DETROIT_DLSS_MODE_DLAA) {
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kNativeMode);
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kNativeMode, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (!state->adapter_available) {
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kAdapterUnavailable);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kAdapterUnavailable,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const bool auto_exposure =
      (state->settings.create_flags & DETROIT_DLSS_CREATE_AUTO_EXPOSURE) != 0u;
  const bool valid_frame =
      inputs->shader_crc == DETROIT_DLSS_TEMPORAL_AA_SHADER_CRC
      && inputs->descriptor_set_index == DETROIT_DLSS_TAA_DESCRIPTOR_SET
      && inputs->command_buffer != 0u && inputs->descriptor_set != 0u
      && inputs->pipeline_layout != 0u && inputs->compute_pipeline != 0u
      && inputs->constants_buffer != 0u
      && inputs->constants_size != 0u
      && (inputs->flags & DETROIT_DLSS_FRAME_TEMPORAL_INPUTS_READY) != 0u
      && inputs->render_width == state->settings.render_width
      && inputs->render_height == state->settings.render_height
      && inputs->output_width == state->settings.output_width
      && inputs->output_height == state->settings.output_height
      && IsValidResource(inputs->current_color, inputs->render_width, inputs->render_height)
      && IsValidResource(inputs->depth, inputs->render_width, inputs->render_height)
      && IsValidResource(inputs->motion_vectors, inputs->render_width, inputs->render_height)
      && IsValidResource(inputs->output, inputs->output_width, inputs->output_height)
      && (auto_exposure
              ? (inputs->flags & DETROIT_DLSS_FRAME_ALLOW_AUTO_EXPOSURE) != 0u
              : IsValidResource(inputs->exposure, 1u, 1u))
      && std::isfinite(inputs->jitter_x) && std::isfinite(inputs->jitter_y)
      && std::isfinite(inputs->motion_vector_scale_x)
      && std::isfinite(inputs->motion_vector_scale_y) && std::isfinite(inputs->pre_exposure)
      && inputs->pre_exposure > 0.f;
  if (!valid_frame) {
    if (trace_record.attempt != 0u) {
      std::uint64_t failed = 0u;
      const auto mark = [&failed](std::uint32_t bit, bool condition) {
        if (!condition) failed |= UINT64_C(1) << bit;
      };
      mark(0u, inputs->shader_crc == DETROIT_DLSS_TEMPORAL_AA_SHADER_CRC);
      mark(1u, inputs->descriptor_set_index == DETROIT_DLSS_TAA_DESCRIPTOR_SET);
      mark(2u, inputs->command_buffer != 0u);
      mark(3u, inputs->descriptor_set != 0u);
      mark(4u, inputs->pipeline_layout != 0u);
      mark(5u, inputs->compute_pipeline != 0u);
      mark(6u, inputs->constants_buffer != 0u && inputs->constants_size != 0u);
      mark(
          7u,
          (inputs->flags & DETROIT_DLSS_FRAME_TEMPORAL_INPUTS_READY) != 0u);
      mark(
          8u,
          inputs->render_width == state->settings.render_width
              && inputs->render_height == state->settings.render_height);
      mark(
          9u,
          inputs->output_width == state->settings.output_width
              && inputs->output_height == state->settings.output_height);
      mark(
          10u,
          IsValidResource(
              inputs->current_color,
              inputs->render_width,
              inputs->render_height));
      mark(
          11u,
          IsValidResource(
              inputs->depth, inputs->render_width, inputs->render_height));
      mark(
          12u,
          IsValidResource(
              inputs->motion_vectors,
              inputs->render_width,
              inputs->render_height));
      mark(
          13u,
          IsValidResource(
              inputs->output, inputs->output_width, inputs->output_height));
      mark(
          14u,
          auto_exposure
              ? (inputs->flags & DETROIT_DLSS_FRAME_ALLOW_AUTO_EXPOSURE) != 0u
              : IsValidResource(inputs->exposure, 1u, 1u));
      mark(15u, std::isfinite(inputs->jitter_x));
      mark(16u, std::isfinite(inputs->jitter_y));
      mark(17u, std::isfinite(inputs->motion_vector_scale_x));
      mark(18u, std::isfinite(inputs->motion_vector_scale_y));
      mark(
          19u,
          std::isfinite(inputs->pre_exposure) && inputs->pre_exposure > 0.f);
      TraceEvaluationMessage(
          std::format(
              "DLSS trace_window={} attempt={} event=invalid_frame failed_mask=0x{:X} labels=shader,set,command,descriptor,layout,pipeline,constants,ready,render_extent,output_extent,color,depth,mv,output,exposure,jitter_x,jitter_y,mv_scale_x,mv_scale_y,pre_exposure",
              trace_record.trace_window,
              trace_record.attempt,
              failed),
          reshade::log::level::warning);
    }
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kInvalidFrame);
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kInvalidFrame, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  auto& restore_state = state->evaluation_restore_state;
  TraceEvaluationPhase(trace_record, "capture_restore_state");
  if (!CaptureComputeRestoreState(state.get(), *inputs, &restore_state)
      || !CanRestoreComputeCommandState(state.get(), restore_state)) {
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kCommandStateUnrestorable);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kCommandStateUnrestorable,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  trace_record.recording_generation = restore_state.recording_generation;
  TraceEvaluationPhase(trace_record, "capture_restore_state", "end");

  TraceEvaluationPhase(trace_record, "native_output_state");
  const auto native_output_state =
      CaptureNativeOutputTrackedState(inputs->output);
  if (!native_output_state.has_value()) {
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kResourceRejected);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kInvalidFrame,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  TraceEvaluationPhase(trace_record, "native_output_state", "end");

  const bool initializes_ngx = state->ngx_context == nullptr;
  TraceEvaluationPhase(trace_record, "ensure_ngx_initialized");
  if (!EnsureNgxInitialized(state.get())) {
    trace_record.ngx_call = TraceNgxCall::kInitialize;
    trace_record.ngx_called = initializes_ngx;
    trace_record.ngx_result = state->last_ngx_initialization.ngx_result;
    trace_record.vk_result = state->last_ngx_initialization.vk_result;
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kNgxInitializationFailed);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kNgxInitializationFailed,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  TraceEvaluationPhase(trace_record, "ensure_ngx_initialized", "end");

  const std::uint32_t create_flags = ToNgxCreateFlags(state->settings.create_flags);
  TraceEvaluationPhase(trace_record, "configure_feature");
  const auto configure_result = state->ngx_context->ConfigureFeature({
      .mode = ToNgxQuality(),
      .render_width = state->settings.render_width,
      .render_height = state->settings.render_height,
      .output_width = state->settings.output_width,
      .output_height = state->settings.output_height,
      .create_flags = create_flags,
  });
  TraceEvaluationPhase(trace_record, "configure_feature", "end");
  UpdateFeatureTrackingStateLocked(state.get());
  trace_record.feature_generation = configure_result.feature_generation;
  trace_record.ngx_result = configure_result.ngx_result;
  trace_record.vk_result = configure_result.vk_result;
  const auto configure_stage = configure_result.stage;
  const bool create_called =
      configure_result.feature_created
      || configure_stage
             == renodx::utils::dlss::vulkan::OperationStage::kCreateFeature
      || configure_stage
             == renodx::utils::dlss::vulkan::OperationStage::kEndCommandBuffer
      || configure_stage
             == renodx::utils::dlss::vulkan::OperationStage::kCreateFence
      || configure_stage
             == renodx::utils::dlss::vulkan::OperationStage::kSubmitFeature
      || configure_stage
             == renodx::utils::dlss::vulkan::OperationStage::kWaitFeature;
  if (create_called) {
    trace_record.ngx_call = TraceNgxCall::kCreate;
    trace_record.ngx_called = true;
  }
  if (!configure_result.Succeeded()) {
    TraceNgxFailureOnce(
        state.get(),
        1u,
        "feature creation",
        configure_result.ngx_result);
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kFeatureCreationFailed);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kFeatureCreationFailed,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  // NVIDIA's Vulkan create call records GPU work. The reusable core records
  // it on a private primary command buffer, submits it with a private fence,
  // and waits for that fence. This first Detroit frame still replays native
  // TAA; NGX Evaluate starts on the next frame with reset forced by the core.
  if (configure_result.feature_created) {
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kFeatureCreationPending);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kFeatureCreationPending,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  state->ngx_context->BeginRecording(
      inputs->command_buffer, restore_state.one_time_submit);

  using renodx::games::detroitbecomehuman::dlss::AdapterPreparedFrame;
  using renodx::games::detroitbecomehuman::dlss::AdapterPrepareInfo;
  AdapterPreparedFrame prepared_frame = {};
  TraceEvaluationPhase(trace_record, "adapter_prepare");
  const auto prepare_result = state->adapter_runtime.Prepare(
      AdapterPrepareInfo{
          .command_buffer = command_buffer,
          .current_color = inputs->current_color,
          .depth = inputs->depth,
          .motion_vectors = inputs->motion_vectors,
          .output_color_pass = inputs->output,
          .output_color_pass_state = *native_output_state,
          .render_width = inputs->render_width,
          .render_height = inputs->render_height,
          .output_width = inputs->output_width,
          .output_height = inputs->output_height,
          .dlaa_sharpening = inputs->dlaa_sharpening,
          .dlaa_sharpening_normalization =
              inputs->dlaa_sharpening_normalization,
          .one_time_submit = restore_state.one_time_submit,
          .trace_readback = trace_record.attempt != 0u
                            && GetEvaluationTraceConfiguration().readback,
          .trace_attempt = trace_record.attempt,
      },
      &prepared_frame);
  TraceEvaluationPhase(trace_record, "adapter_prepare", "end");
  trace_record.prepare_called = true;
  trace_record.prepare = prepare_result;
  if (!prepare_result.Succeeded()) {
    TraceAdapterFailureOnce(state.get(), true, prepare_result);
    // The complete restore contract was validated before Prepare. Both Vulkan
    // bind commands are void, so recording this restoration cannot fail after
    // the adapter has changed command state.
    TraceEvaluationPhase(trace_record, "restore_compute_state");
    (void)RestoreComputeCommandState(state.get(), command_buffer, restore_state);
    TraceEvaluationPhase(trace_record, "restore_compute_state", "end");
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kPrepareFailed);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        MakeAdapterBridgeDetail(true, prepare_result.detail),
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  auto color = MakeCoreImageResource(
      prepared_frame.color,
      VK_IMAGE_ASPECT_COLOR_BIT,
      false,
      VK_IMAGE_USAGE_SAMPLED_BIT,
      VK_ACCESS_SHADER_READ_BIT);
  color.state = prepared_frame.color_state;
  auto depth = MakeCoreImageResource(
      prepared_frame.depth,
      VK_IMAGE_ASPECT_DEPTH_BIT,
      false,
      VK_IMAGE_USAGE_SAMPLED_BIT,
      VK_ACCESS_SHADER_READ_BIT);
  auto motion_vectors = MakeCoreImageResource(
      prepared_frame.motion_vectors,
      VK_IMAGE_ASPECT_COLOR_BIT,
      false,
      VK_IMAGE_USAGE_SAMPLED_BIT,
      VK_ACCESS_SHADER_READ_BIT);
  auto output = MakeCoreImageResource(
      prepared_frame.output,
      VK_IMAGE_ASPECT_COLOR_BIT,
      true,
      VK_IMAGE_USAGE_STORAGE_BIT | VK_IMAGE_USAGE_SAMPLED_BIT,
      VK_ACCESS_SHADER_WRITE_BIT);
  output.state = prepared_frame.output_state;
  auto exposure = MakeCoreImageResource(
      inputs->exposure,
      VK_IMAGE_ASPECT_COLOR_BIT,
      false,
      VK_IMAGE_USAGE_SAMPLED_BIT,
      VK_ACCESS_SHADER_READ_BIT);

  TraceEvaluationPhase(trace_record, "ngx_evaluate");
  const auto evaluate_result = state->ngx_context->Evaluate({
      .recording_key = ToOpaque(command_buffer),
      .command_buffer = command_buffer,
      .color = &color,
      .depth = &depth,
      .motion_vectors = &motion_vectors,
      .output = &output,
      .exposure = auto_exposure ? nullptr : &exposure,
      .jitter_x = inputs->jitter_x,
      .jitter_y = inputs->jitter_y,
      .motion_vector_scale_x = inputs->motion_vector_scale_x,
      .motion_vector_scale_y = inputs->motion_vector_scale_y,
      .pre_exposure = inputs->pre_exposure,
      .exposure_scale = 1.f,
      .render_width = inputs->render_width,
      .render_height = inputs->render_height,
      .one_time_submit = restore_state.one_time_submit,
      .reset = inputs->reset != 0u
               || (inputs->flags
                   & (DETROIT_DLSS_FRAME_CAMERA_CUT
                      | DETROIT_DLSS_FRAME_SCENE_LOADED))
                      != 0u,
  });
  TraceEvaluationPhase(trace_record, "ngx_evaluate", "end");
  MarkFeatureRecordingCandidateLocked(
      state.get(),
      command_buffer,
      evaluate_result.recording_epoch,
      evaluate_result.one_time_submit);
  UpdateFeatureTrackingStateLocked(state.get());
  trace_record.ngx_call = TraceNgxCall::kEvaluate;
  trace_record.ngx_called = true;
  trace_record.ngx_result = evaluate_result.ngx_result;
  trace_record.vk_result = evaluate_result.vk_result;
  trace_record.feature_generation = evaluate_result.feature_generation;
  if (trace_record.attempt != 0u) {
    state->submission_trace_tracker.Associate(
        inputs->command_buffer,
        trace_record.trace_window,
        trace_record.attempt,
        trace_record.recording_generation,
        restore_state.one_time_submit);
  }
  const bool ngx_succeeded = evaluate_result.Succeeded()
                              && evaluate_result.output_valid;
  TraceEvaluationPhase(trace_record, "adapter_commit");
  const auto commit_result =
      state->adapter_runtime.CommitAfterNgx(prepared_frame, ngx_succeeded);
  TraceEvaluationPhase(trace_record, "adapter_commit", "end");
  trace_record.commit_called = true;
  trace_record.commit = commit_result;
  // Commit may write b16, so no fallible decision is allowed after this point.
  // The restore contract was proved before any adapter/NGX commands were
  // recorded and these Vulkan bind calls have no failure return.
  TraceEvaluationPhase(trace_record, "restore_compute_state");
  (void)RestoreComputeCommandState(state.get(), command_buffer, restore_state);
  TraceEvaluationPhase(trace_record, "restore_compute_state", "end");
  if (!evaluate_result.Succeeded()) {
    TraceNgxFailureOnce(
        state.get(), 2u, "evaluation", evaluate_result.ngx_result);
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kEvaluateFailed);
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kEvaluationFailed, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (!commit_result.Succeeded()) {
    TraceAdapterFailureOnce(state.get(), false, commit_result);
    TraceEvaluationTerminal(
        trace_record,
        renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::
            kCommitFailed);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        MakeAdapterBridgeDetail(false, commit_result.detail),
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  TraceEvaluationTerminal(
      trace_record,
      renodx::games::detroitbecomehuman::dlss::EvaluationTerminal::kSuccess);
  SetEvaluationResult(
      result,
      DETROIT_DLSS_RESULT_SUCCESS,
      BridgeDetail::kNone,
      frame_id,
      DETROIT_DLSS_EVALUATE_OUTPUT_VALID
          | (auto_exposure ? DETROIT_DLSS_EVALUATE_USED_AUTO_EXPOSURE : 0u));
  return DETROIT_DLSS_RESULT_SUCCESS;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerCreateDescriptorSetLayout(
    VkDevice device,
    const VkDescriptorSetLayoutCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkDescriptorSetLayout* layout) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkCreateDescriptorSetLayout>(
      state->next_get_device_proc_addr(device, "vkCreateDescriptorSetLayout"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, create_info, allocator, layout);
  if (result != VK_SUCCESS || create_info == nullptr || layout == nullptr) return result;

  DescriptorSetLayoutState tracked = {};
  tracked.bindings.reserve(create_info->bindingCount);
  for (std::uint32_t index = 0u; index < create_info->bindingCount; ++index) {
    const auto& source = create_info->pBindings[index];
    tracked.bindings.push_back({source.binding, source.descriptorType, source.descriptorCount});
  }
  std::sort(
      tracked.bindings.begin(),
      tracked.bindings.end(),
      [](const DescriptorLayoutBinding& left, const DescriptorLayoutBinding& right) {
        return left.binding < right.binding;
      });
  tracked.temporal_candidate = IsTemporalDescriptorSetLayout(tracked);
  tracked.dof_composite_candidate = IsDofCompositeDescriptorSetLayout(tracked);
  const std::lock_guard lock(state->tracking_mutex);
  state->descriptor_set_layouts[ToOpaque(*layout)] = std::move(tracked);
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyDescriptorSetLayout(
    VkDevice device,
    VkDescriptorSetLayout layout,
    const VkAllocationCallbacks* allocator) {
  const auto state = FindDevice(device);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkDestroyDescriptorSetLayout>(
      state->next_get_device_proc_addr(device, "vkDestroyDescriptorSetLayout"));
  if (trampoline != nullptr) trampoline(device, layout, allocator);
  const std::lock_guard lock(state->tracking_mutex);
  state->descriptor_set_layouts.erase(ToOpaque(layout));
}

VKAPI_ATTR VkResult VKAPI_CALL LayerCreatePipelineLayout(
    VkDevice device,
    const VkPipelineLayoutCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkPipelineLayout* layout) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkCreatePipelineLayout>(
      state->next_get_device_proc_addr(device, "vkCreatePipelineLayout"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, create_info, allocator, layout);
  if (result != VK_SUCCESS || create_info == nullptr || layout == nullptr) return result;

  PipelineLayoutState tracked = {};
  if (create_info->setLayoutCount != 0u) {
    tracked.set_layouts.assign(
        create_info->pSetLayouts,
        create_info->pSetLayouts + create_info->setLayoutCount);
  }
  if (create_info->pushConstantRangeCount != 0u) {
    tracked.push_constant_ranges.assign(
        create_info->pPushConstantRanges,
        create_info->pPushConstantRanges
            + create_info->pushConstantRangeCount);
  }
  const std::lock_guard lock(state->tracking_mutex);
  if (allocator == nullptr && tracked.set_layouts.size() == 1u
      && tracked.push_constant_ranges.empty()) {
    const auto descriptor_layout = state->descriptor_set_layouts.find(
        ToOpaque(tracked.set_layouts[0u]));
    if (descriptor_layout != state->descriptor_set_layouts.end()
        && descriptor_layout->second.dof_composite_candidate) {
      // This embedded layer is outside ReShade. With the default allocator,
      // the successful downstream trampoline can insert RenoDX's 112-byte
      // compute push range while the original create_info observed here
      // remains empty. Mirror only that proven effective contract so the
      // exact DOF composite state survives LayerCmdBindDescriptorSets.
      // Executable support and all image/depth gates are checked at capture.
      tracked.push_constant_ranges.push_back(
          {VK_SHADER_STAGE_COMPUTE_BIT, 0u, 112u});
    }
  }
  state->pipeline_layouts[ToOpaque(*layout)] = std::move(tracked);
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyPipelineLayout(
    VkDevice device,
    VkPipelineLayout layout,
    const VkAllocationCallbacks* allocator) {
  const auto state = FindDevice(device);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkDestroyPipelineLayout>(
      state->next_get_device_proc_addr(device, "vkDestroyPipelineLayout"));
  if (trampoline != nullptr) trampoline(device, layout, allocator);
  const std::lock_guard lock(state->tracking_mutex);
  state->pipeline_layouts.erase(ToOpaque(layout));
}

VKAPI_ATTR VkResult VKAPI_CALL LayerAllocateDescriptorSets(
    VkDevice device,
    const VkDescriptorSetAllocateInfo* allocate_info,
    VkDescriptorSet* descriptor_sets) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkAllocateDescriptorSets>(
      state->next_get_device_proc_addr(device, "vkAllocateDescriptorSets"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, allocate_info, descriptor_sets);
  if (result != VK_SUCCESS || allocate_info == nullptr || descriptor_sets == nullptr) return result;

  const std::lock_guard lock(state->tracking_mutex);
  for (std::uint32_t index = 0u; index < allocate_info->descriptorSetCount; ++index) {
    const auto layout =
        state->descriptor_set_layouts.find(ToOpaque(allocate_info->pSetLayouts[index]));
    if (layout == state->descriptor_set_layouts.end()
        || (!layout->second.temporal_candidate
            && !layout->second.dof_composite_candidate)) {
      continue;
    }
    state->descriptor_sets[ToOpaque(descriptor_sets[index])] = {
        allocate_info->descriptorPool, allocate_info->pSetLayouts[index], {}};
    MarkTrackedDescriptorSet(state.get(), descriptor_sets[index]);
  }
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerFreeDescriptorSets(
    VkDevice device,
    VkDescriptorPool pool,
    std::uint32_t descriptor_set_count,
    const VkDescriptorSet* descriptor_sets) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkFreeDescriptorSets>(
      state->next_get_device_proc_addr(device, "vkFreeDescriptorSets"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, pool, descriptor_set_count, descriptor_sets);
  if (result != VK_SUCCESS || descriptor_sets == nullptr) return result;

  const std::lock_guard lock(state->tracking_mutex);
  for (std::uint32_t index = 0u; index < descriptor_set_count; ++index) {
    state->descriptor_sets.erase(ToOpaque(descriptor_sets[index]));
  }
  return result;
}

void EraseDescriptorPoolSets(DeviceState* state, VkDescriptorPool pool) {
  for (auto descriptor_set = state->descriptor_sets.begin();
       descriptor_set != state->descriptor_sets.end();) {
    if (descriptor_set->second.pool == pool) {
      descriptor_set = state->descriptor_sets.erase(descriptor_set);
    } else {
      ++descriptor_set;
    }
  }
}

VKAPI_ATTR VkResult VKAPI_CALL LayerResetDescriptorPool(
    VkDevice device, VkDescriptorPool pool, VkDescriptorPoolResetFlags flags) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkResetDescriptorPool>(
      state->next_get_device_proc_addr(device, "vkResetDescriptorPool"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, pool, flags);
  if (result == VK_SUCCESS) {
    const std::lock_guard lock(state->tracking_mutex);
    EraseDescriptorPoolSets(state.get(), pool);
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyDescriptorPool(
    VkDevice device,
    VkDescriptorPool pool,
    const VkAllocationCallbacks* allocator) {
  const auto state = FindDevice(device);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkDestroyDescriptorPool>(
      state->next_get_device_proc_addr(device, "vkDestroyDescriptorPool"));
  if (trampoline != nullptr) trampoline(device, pool, allocator);
  const std::lock_guard lock(state->tracking_mutex);
  EraseDescriptorPoolSets(state.get(), pool);
}

VKAPI_ATTR void VKAPI_CALL LayerUpdateDescriptorSets(
    VkDevice device,
    std::uint32_t descriptor_write_count,
    const VkWriteDescriptorSet* descriptor_writes,
    std::uint32_t descriptor_copy_count,
    const VkCopyDescriptorSet* descriptor_copies) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return;
  const auto trampoline = state->next_update_descriptor_sets;
  if (trampoline == nullptr) return;
  trampoline(
      device,
      descriptor_write_count,
      descriptor_writes,
      descriptor_copy_count,
      descriptor_copies);

  bool may_touch_tracked_set = false;
  if (descriptor_writes != nullptr) {
    for (std::uint32_t index = 0u; index < descriptor_write_count; ++index) {
      if (MayBeTrackedDescriptorSet(*state, descriptor_writes[index].dstSet)) {
        may_touch_tracked_set = true;
        break;
      }
    }
  }
  if (!may_touch_tracked_set && descriptor_copies != nullptr) {
    for (std::uint32_t index = 0u; index < descriptor_copy_count; ++index) {
      if (MayBeTrackedDescriptorSet(*state, descriptor_copies[index].srcSet)
          || MayBeTrackedDescriptorSet(
              *state, descriptor_copies[index].dstSet)) {
        may_touch_tracked_set = true;
        break;
      }
    }
  }
  if (!may_touch_tracked_set) return;

  const std::lock_guard lock(state->tracking_mutex);
  for (std::uint32_t write_index = 0u; write_index < descriptor_write_count; ++write_index) {
    const auto& write = descriptor_writes[write_index];
    const bool buffer_descriptor = IsBufferDescriptorType(write.descriptorType);
    const bool image_descriptor = IsImageDescriptorType(write.descriptorType);
    if ((!buffer_descriptor && !image_descriptor)
        || (buffer_descriptor && write.pBufferInfo == nullptr)
        || (image_descriptor && write.pImageInfo == nullptr)) {
      continue;
    }
    const auto set = state->descriptor_sets.find(ToOpaque(write.dstSet));
    if (set == state->descriptor_sets.end()) continue;
    const auto layout = state->descriptor_set_layouts.find(ToOpaque(set->second.layout));
    if (layout == state->descriptor_set_layouts.end()) continue;
    const auto slots = EnumerateDescriptorSlots(
        layout->second,
        write.dstBinding,
        write.dstArrayElement,
        write.descriptorCount,
        write.descriptorType);
    if (slots.size() != write.descriptorCount) continue;
    for (std::uint32_t descriptor_index = 0u;
         descriptor_index < write.descriptorCount;
         ++descriptor_index) {
      const std::uint64_t update_serial = ++state->descriptor_update_serial;
      if (buffer_descriptor) {
        const auto& buffer = write.pBufferInfo[descriptor_index];
        set->second.buffer_descriptors[slots[descriptor_index]] = {
            write.descriptorType,
            buffer.buffer,
            buffer.offset,
            buffer.range,
            DETROIT_DLSS_DESCRIPTOR_SOURCE_DIRECT_WRITE,
            update_serial};
        set->second.image_descriptors.erase(slots[descriptor_index]);
        if (slots[descriptor_index]
            == DescriptorSlotKey(DETROIT_DLSS_TAA_CONSTANT_BINDING_52, 0u)) {
          RegisterTemporalConstantsBufferLocked(state, ToOpaque(buffer.buffer));
        }
      } else {
        const auto& image = write.pImageInfo[descriptor_index];
        set->second.image_descriptors[slots[descriptor_index]] = {
            write.descriptorType,
            image.sampler,
            image.imageView,
            image.imageLayout,
            DETROIT_DLSS_DESCRIPTOR_SOURCE_DIRECT_WRITE,
            update_serial};
        set->second.buffer_descriptors.erase(slots[descriptor_index]);
      }
    }
  }

  for (std::uint32_t copy_index = 0u; copy_index < descriptor_copy_count; ++copy_index) {
    const auto& copy = descriptor_copies[copy_index];
    const auto source_set = state->descriptor_sets.find(ToOpaque(copy.srcSet));
    const auto destination_set = state->descriptor_sets.find(ToOpaque(copy.dstSet));
    if (source_set == state->descriptor_sets.end()
        || destination_set == state->descriptor_sets.end()) {
      continue;
    }
    const auto source_layout =
        state->descriptor_set_layouts.find(ToOpaque(source_set->second.layout));
    const auto destination_layout =
        state->descriptor_set_layouts.find(ToOpaque(destination_set->second.layout));
    if (source_layout == state->descriptor_set_layouts.end()
        || destination_layout == state->descriptor_set_layouts.end()) {
      continue;
    }
    const auto* source_binding = FindLayoutBinding(source_layout->second, copy.srcBinding);
    const auto* destination_binding =
        FindLayoutBinding(destination_layout->second, copy.dstBinding);
    if (source_binding == nullptr || destination_binding == nullptr
        || source_binding->descriptor_type != destination_binding->descriptor_type
        || (!IsBufferDescriptorType(source_binding->descriptor_type)
            && !IsImageDescriptorType(source_binding->descriptor_type))) {
      continue;
    }
    const auto source_slots = EnumerateDescriptorSlots(
        source_layout->second,
        copy.srcBinding,
        copy.srcArrayElement,
        copy.descriptorCount,
        source_binding->descriptor_type);
    const auto destination_slots = EnumerateDescriptorSlots(
        destination_layout->second,
        copy.dstBinding,
        copy.dstArrayElement,
        copy.descriptorCount,
        source_binding->descriptor_type);
    if (source_slots.size() != copy.descriptorCount
        || destination_slots.size() != copy.descriptorCount) {
      continue;
    }
    if (IsBufferDescriptorType(source_binding->descriptor_type)) {
      std::vector<std::optional<BufferDescriptorState>> copied(copy.descriptorCount);
      for (std::uint32_t descriptor_index = 0u;
           descriptor_index < copy.descriptorCount;
           ++descriptor_index) {
        const auto source =
            source_set->second.buffer_descriptors.find(source_slots[descriptor_index]);
        if (source != source_set->second.buffer_descriptors.end()) {
          copied[descriptor_index] = source->second;
        }
      }
      for (std::uint32_t descriptor_index = 0u;
           descriptor_index < copy.descriptorCount;
           ++descriptor_index) {
        if (copied[descriptor_index].has_value()) {
          auto value = *copied[descriptor_index];
          value.source_flags |= DETROIT_DLSS_DESCRIPTOR_SOURCE_COPY;
          value.update_serial = ++state->descriptor_update_serial;
          destination_set->second.buffer_descriptors[destination_slots[descriptor_index]] =
              value;
          destination_set->second.image_descriptors.erase(destination_slots[descriptor_index]);
          if (destination_slots[descriptor_index]
              == DescriptorSlotKey(DETROIT_DLSS_TAA_CONSTANT_BINDING_52, 0u)) {
            RegisterTemporalConstantsBufferLocked(state, ToOpaque(value.buffer));
          }
        } else {
          destination_set->second.buffer_descriptors.erase(destination_slots[descriptor_index]);
        }
      }
    } else {
      std::vector<std::optional<ImageDescriptorState>> copied(copy.descriptorCount);
      for (std::uint32_t descriptor_index = 0u;
           descriptor_index < copy.descriptorCount;
           ++descriptor_index) {
        const auto source =
            source_set->second.image_descriptors.find(source_slots[descriptor_index]);
        if (source != source_set->second.image_descriptors.end()) {
          copied[descriptor_index] = source->second;
        }
      }
      for (std::uint32_t descriptor_index = 0u;
           descriptor_index < copy.descriptorCount;
           ++descriptor_index) {
        if (copied[descriptor_index].has_value()) {
          auto value = *copied[descriptor_index];
          value.source_flags |= DETROIT_DLSS_DESCRIPTOR_SOURCE_COPY;
          value.update_serial = ++state->descriptor_update_serial;
          destination_set->second.image_descriptors[destination_slots[descriptor_index]] =
              value;
          destination_set->second.buffer_descriptors.erase(destination_slots[descriptor_index]);
        } else {
          destination_set->second.image_descriptors.erase(destination_slots[descriptor_index]);
        }
      }
    }
  }
}

VKAPI_ATTR VkResult VKAPI_CALL LayerCreateImage(
    VkDevice device,
    const VkImageCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkImage* image) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkCreateImage>(
      state->next_get_device_proc_addr(device, "vkCreateImage"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, create_info, allocator, image);
  if (result == VK_SUCCESS && create_info != nullptr && image != nullptr) {
    const std::lock_guard lock(state->tracking_mutex);
    state->images[ToOpaque(*image)] = {
        create_info->flags,
        create_info->imageType,
        create_info->format,
        create_info->extent,
        create_info->mipLevels,
        create_info->arrayLayers,
        create_info->samples,
        create_info->usage};
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyImage(
    VkDevice device, VkImage image, const VkAllocationCallbacks* allocator) {
  const auto state = FindDevice(device);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkDestroyImage>(
      state->next_get_device_proc_addr(device, "vkDestroyImage"));
  if (trampoline != nullptr) trampoline(device, image, allocator);
  const std::lock_guard lock(state->tracking_mutex);
  state->images.erase(ToOpaque(image));
}

VKAPI_ATTR VkResult VKAPI_CALL LayerCreateImageView(
    VkDevice device,
    const VkImageViewCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkImageView* image_view) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkCreateImageView>(
      state->next_get_device_proc_addr(device, "vkCreateImageView"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, create_info, allocator, image_view);
  if (result == VK_SUCCESS && create_info != nullptr && image_view != nullptr) {
    const std::lock_guard lock(state->tracking_mutex);
    state->image_views[ToOpaque(*image_view)] = {
        create_info->image,
        create_info->viewType,
        create_info->format,
        create_info->subresourceRange};
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyImageView(
    VkDevice device,
    VkImageView image_view,
    const VkAllocationCallbacks* allocator) {
  const auto state = FindDevice(device);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkDestroyImageView>(
      state->next_get_device_proc_addr(device, "vkDestroyImageView"));
  if (trampoline != nullptr) trampoline(device, image_view, allocator);
  const std::lock_guard lock(state->tracking_mutex);
  state->image_views.erase(ToOpaque(image_view));
}

VKAPI_ATTR VkResult VKAPI_CALL LayerCreateBuffer(
    VkDevice device,
    const VkBufferCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkBuffer* buffer) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkCreateBuffer>(
      state->next_get_device_proc_addr(device, "vkCreateBuffer"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, create_info, allocator, buffer);
  if (result == VK_SUCCESS && create_info != nullptr && buffer != nullptr) {
    const std::lock_guard lock(state->tracking_mutex);
    state->buffers[ToOpaque(*buffer)] = {
        .size = create_info->size,
        .usage = create_info->usage,
    };
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyBuffer(
    VkDevice device, VkBuffer buffer, const VkAllocationCallbacks* allocator) {
  const auto state = FindDevice(device);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkDestroyBuffer>(
      state->next_get_device_proc_addr(device, "vkDestroyBuffer"));
  if (trampoline != nullptr) trampoline(device, buffer, allocator);
  const std::lock_guard lock(state->tracking_mutex);
  const auto tracked = state->buffers.find(ToOpaque(buffer));
  if (tracked != state->buffers.end()) {
    DetachTemporalConstantsBufferLocked(state.get(), ToOpaque(buffer), tracked->second);
    state->buffers.erase(tracked);
  }
}

VKAPI_ATTR VkResult VKAPI_CALL LayerAllocateMemory(
    VkDevice device,
    const VkMemoryAllocateInfo* allocate_info,
    const VkAllocationCallbacks* allocator,
    VkDeviceMemory* memory) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkAllocateMemory>(
      state->next_get_device_proc_addr(device, "vkAllocateMemory"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, allocate_info, allocator, memory);
  if (result != VK_SUCCESS || allocate_info == nullptr || memory == nullptr) return result;

  MemoryState tracked = {};
  tracked.allocation_size = allocate_info->allocationSize;
  tracked.memory_type_index = allocate_info->memoryTypeIndex;
  if (tracked.memory_type_index < state->memory_properties.memoryTypeCount) {
    tracked.property_flags =
        state->memory_properties.memoryTypes[tracked.memory_type_index].propertyFlags;
  }
  const std::lock_guard lock(state->tracking_mutex);
  state->memories[ToOpaque(*memory)] = tracked;
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerFreeMemory(
    VkDevice device, VkDeviceMemory memory, const VkAllocationCallbacks* allocator) {
  const auto state = FindDevice(device);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkFreeMemory>(
      state->next_get_device_proc_addr(device, "vkFreeMemory"));
  if (trampoline != nullptr) trampoline(device, memory, allocator);
  const std::lock_guard lock(state->tracking_mutex);
  const auto tracked_memory = state->memories.find(ToOpaque(memory));
  if (tracked_memory != state->memories.end()) {
    for (const std::uint64_t buffer_handle :
         tracked_memory->second.temporal_uniform_buffers) {
      const auto buffer = state->buffers.find(buffer_handle);
      if (buffer != state->buffers.end() && buffer->second.memory == memory) {
        buffer->second.memory = VK_NULL_HANDLE;
        buffer->second.memory_offset = 0u;
        buffer->second.shadow_valid_bytes.assign(
            buffer->second.shadow_valid_bytes.size(), 0u);
      }
    }
    state->memories.erase(tracked_memory);
  }
}

VKAPI_ATTR VkResult VKAPI_CALL LayerBindBufferMemory(
    VkDevice device, VkBuffer buffer, VkDeviceMemory memory, VkDeviceSize memory_offset) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = reinterpret_cast<PFN_vkBindBufferMemory>(
      state->next_get_device_proc_addr(device, "vkBindBufferMemory"));
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, buffer, memory, memory_offset);
  if (result == VK_SUCCESS) {
    const std::lock_guard lock(state->tracking_mutex);
    TrackBufferMemoryBindingLocked(
        state.get(), buffer, memory, memory_offset);
  }
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerBindBufferMemory2(
    VkDevice device,
    std::uint32_t bind_info_count,
    const VkBindBufferMemoryInfo* bind_infos) {
  const auto state = FindDevice(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  auto trampoline = reinterpret_cast<PFN_vkBindBufferMemory2>(
      state->next_get_device_proc_addr(device, "vkBindBufferMemory2"));
  if (trampoline == nullptr) {
    trampoline = reinterpret_cast<PFN_vkBindBufferMemory2>(
        state->next_get_device_proc_addr(device, "vkBindBufferMemory2KHR"));
  }
  if (trampoline == nullptr) return VK_ERROR_EXTENSION_NOT_PRESENT;
  const VkResult result = trampoline(device, bind_info_count, bind_infos);
  if (result == VK_SUCCESS && bind_infos != nullptr) {
    const std::lock_guard lock(state->tracking_mutex);
    for (std::uint32_t index = 0u; index < bind_info_count; ++index) {
      TrackBufferMemoryBindingLocked(
          state.get(),
          bind_infos[index].buffer,
          bind_infos[index].memory,
          bind_infos[index].memoryOffset);
    }
  }
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerMapMemory(
    VkDevice device,
    VkDeviceMemory memory,
    VkDeviceSize offset,
    VkDeviceSize size,
    VkMemoryMapFlags flags,
    void** data) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = state->next_map_memory;
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, memory, offset, size, flags, data);
  if (result != VK_SUCCESS || data == nullptr) return result;

  const std::lock_guard lock(state->tracking_mutex);
  const auto tracked = state->memories.find(ToOpaque(memory));
  if (tracked != state->memories.end() && offset <= tracked->second.allocation_size) {
    const VkDeviceSize remaining = tracked->second.allocation_size - offset;
    if (size == VK_WHOLE_SIZE || size <= remaining) {
      tracked->second.mapped_pointer = *data;
      tracked->second.mapped_offset = offset;
      tracked->second.mapped_size = size == VK_WHOLE_SIZE ? remaining : size;
    }
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerUnmapMemory(VkDevice device, VkDeviceMemory memory) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return;
  const auto trampoline = state->next_unmap_memory;
  {
    const std::lock_guard lock(state->tracking_mutex);
    const auto tracked = state->memories.find(ToOpaque(memory));
    if (tracked != state->memories.end()) {
      ShadowTemporalConstantsBeforeUnmapLocked(state, memory, &tracked->second);
      tracked->second.mapped_pointer = nullptr;
      tracked->second.mapped_offset = 0u;
      tracked->second.mapped_size = 0u;
    }
  }
  if (trampoline != nullptr) trampoline(device, memory);
}

using FeatureSubmissionSnapshot =
    renodx::games::detroitbecomehuman::dlss::FeatureLifetimeTracker::SubmissionSnapshot;
using CompletedFeatureRecording =
    renodx::games::detroitbecomehuman::dlss::FeatureLifetimeTracker::CompletedRecording;

struct TraceSubmissionCandidate final {
  std::uint64_t command_buffer = 0u;
  std::uint64_t recording_generation = 0u;
};

void CaptureTraceSubmissionCandidates(
    DeviceState* state,
    const std::vector<std::uint64_t>& command_buffers,
    std::vector<TraceSubmissionCandidate>* candidates) {
  if (state == nullptr || candidates == nullptr || command_buffers.empty()
      || !GetEvaluationTraceConfiguration().first_three) {
    return;
  }
  const std::lock_guard lock(state->tracking_mutex);
  for (const auto command_buffer : command_buffers) {
    const auto generation =
        state->command_buffer_recording_generations.find(command_buffer);
    if (generation != state->command_buffer_recording_generations.end()
        && generation->second != 0u) {
      candidates->push_back({
          .command_buffer = command_buffer,
          .recording_generation = generation->second,
      });
    }
  }
}

FeatureSubmissionSnapshot CaptureFeatureSubmission(
    DeviceState* state,
    const std::vector<std::uint64_t>& command_buffers) {
  const std::lock_guard lock(state->mutex);
  return state->ngx_context != nullptr
             ? state->ngx_context->CaptureSubmission(command_buffers)
             : FeatureSubmissionSnapshot{};
}

void AppendFeatureSubmissionCandidate(
    const DeviceState& state,
    VkCommandBuffer command_buffer,
    std::uint64_t bloom,
    std::vector<std::uint64_t>* candidates) {
  if (command_buffer == VK_NULL_HANDLE || candidates == nullptr) return;
  const auto handle = ToOpaque(command_buffer);
  if ((bloom & CommandBufferBloomBit(handle)) != 0u
      && (state.feature_recording_candidates.Overflowed()
          || state.feature_recording_candidates.Contains(handle))) {
    candidates->push_back(handle);
  }
}

void LogFencelessFeatureSubmissionOnce(
    VkFence application_fence,
    VkFence internal_fence,
    const FeatureSubmissionSnapshot& snapshot) {
  if (application_fence != VK_NULL_HANDLE || internal_fence != VK_NULL_HANDLE
      || snapshot.Empty()
      || fenceless_submission_logged.exchange(
          true, std::memory_order_acq_rel)) {
    return;
  }
  Trace(
      "DLAA private VkFence creation failed; a synchronous queue-idle "
      "completion fallback will protect adapter scratch lifetime");
}

bool SubmissionNeedsInternalFeatureFence(
    DeviceState* state, const FeatureSubmissionSnapshot& snapshot) {
  if (snapshot.Empty()) return false;
  if (ForceInternalFeatureFences()) return true;
  // Detroit rotates one-time primary command buffers without immediately
  // beginning or resetting them again. Track their completion explicitly so
  // the bounded adapter scratch pool cannot fill permanently after eight
  // successful evaluations.
  for (const auto& command : snapshot.commands) {
    if (command.one_time_submit) return true;
  }
  if (state == nullptr || !GetEvaluationTraceConfiguration().readback) return false;
  const std::lock_guard lock(state->mutex);
  for (const auto& command : snapshot.commands) {
    if (state->submission_trace_tracker.NeedsCompletion(
            command.command_buffer, command.recording_epoch)) {
      return true;
    }
  }
  return false;
}

void TraceFeatureSubmissionResult(
    DeviceState* state,
    const FeatureSubmissionSnapshot& snapshot,
    VkQueue queue,
    VkFence fence,
    VkResult result) noexcept {
  if (state == nullptr || snapshot.Empty()
      || !GetEvaluationTraceConfiguration().first_three) {
    return;
  }
  try {
    struct TracedSubmit final {
      std::uint64_t command_buffer = 0u;
      renodx::games::detroitbecomehuman::dlss::SubmissionTraceRecord record;
    };
    std::vector<TracedSubmit> traced;
    {
      const std::lock_guard lock(state->mutex);
      for (const auto& command : snapshot.commands) {
        const auto record = state->submission_trace_tracker.MarkSubmitted(
            command.command_buffer,
            command.recording_epoch,
            command.one_time_submit);
        if (record.has_value()) {
          traced.push_back({
              .command_buffer = command.command_buffer,
              .record = *record,
          });
          if (result != VK_SUCCESS) {
            (void)state->submission_trace_tracker.Discard(
                command.command_buffer, command.recording_epoch);
          }
        }
      }
    }
    for (const auto& command : traced) {
      TraceEvaluationMessage(std::format(
          "DLSS trace_window={} attempt={} event=submit command_buffer=0x{:X} "
          "submit_count={} vk_result={} queue=0x{:X} fence=0x{:X} "
          "recording_generation={} recording_epoch={} one_time={}",
          command.record.window,
          command.record.attempt,
          command.command_buffer,
          command.record.submit_count,
          static_cast<std::int32_t>(result),
          ToOpaque(queue),
          ToOpaque(fence),
          command.record.recording_generation,
          command.record.recording_epoch,
          command.record.one_time_submit));
    }
  } catch (...) {
    // Trace formatting must not affect queue submission.
  }
}

bool SubmissionContainsCommandBuffer(
    const FeatureSubmissionSnapshot& snapshot,
    std::uint64_t command_buffer) noexcept {
  return std::ranges::any_of(
      snapshot.commands,
      [command_buffer](const auto& command) {
        return command.command_buffer == command_buffer;
      });
}

void TracePostCompletionResubmissionResult(
    DeviceState* state,
    const std::vector<TraceSubmissionCandidate>& candidates,
    const FeatureSubmissionSnapshot& snapshot,
    VkQueue queue,
    VkFence fence,
    VkResult result) noexcept {
  if (state == nullptr || candidates.empty()
      || !GetEvaluationTraceConfiguration().first_three) {
    return;
  }
  try {
    struct TracedResubmit final {
      std::uint64_t command_buffer = 0u;
      renodx::games::detroitbecomehuman::dlss::SubmissionTraceRecord record;
    };
    std::vector<TracedResubmit> traced;
    {
      const std::lock_guard lock(state->mutex);
      for (const auto& candidate : candidates) {
        // A live core snapshot is handled by TraceFeatureSubmissionResult,
        // including repeated submits before completion. This path exists only
        // for the post-completion tombstone that the core intentionally drops.
        if (SubmissionContainsCommandBuffer(
                snapshot, candidate.command_buffer)) {
          continue;
        }
        const auto record =
            state->submission_trace_tracker.MarkPostCompletionResubmitted(
                candidate.command_buffer, candidate.recording_generation);
        if (record.has_value()) {
          traced.push_back({
              .command_buffer = candidate.command_buffer,
              .record = *record,
          });
        }
      }
    }
    for (const auto& command : traced) {
      TraceEvaluationMessage(std::format(
          "DLSS trace_window={} attempt={} event=post_completion_resubmit "
          "command_buffer=0x{:X} submit_count={} core_snapshot=false "
          "vk_result={} queue=0x{:X} fence=0x{:X} recording_generation={} "
          "recording_epoch={} one_time={}",
          command.record.window,
          command.record.attempt,
          command.command_buffer,
          command.record.submit_count,
          static_cast<std::int32_t>(result),
          ToOpaque(queue),
          ToOpaque(fence),
          command.record.recording_generation,
          command.record.recording_epoch,
          command.record.one_time_submit));
    }
  } catch (...) {
    // A bounded replay diagnostic must not affect queue submission.
  }
}

std::uint64_t HashTraceReadbackTile(
    const renodx::games::detroitbecomehuman::dlss::AdapterTraceReadback& readback,
    std::uint32_t tile) noexcept {
  constexpr std::size_t kWordsPerTile =
      renodx::games::detroitbecomehuman::dlss::kTraceReadbackTileWidth
      * renodx::games::detroitbecomehuman::dlss::kTraceReadbackTileHeight
      * renodx::games::detroitbecomehuman::dlss::kTraceReadbackWordsPerPixel;
  std::uint64_t hash = UINT64_C(14695981039346656037);
  const std::size_t first = static_cast<std::size_t>(tile) * kWordsPerTile;
  for (std::size_t index = 0u; index < kWordsPerTile; ++index) {
    std::uint32_t word = readback.words[first + index];
    for (std::uint32_t byte = 0u; byte < sizeof(word); ++byte) {
      hash ^= word & 0xFFu;
      hash *= UINT64_C(1099511628211);
      word >>= 8u;
    }
  }
  return hash;
}

void TraceFeatureCompletion(
    DeviceState* state,
    std::uint64_t command_buffer,
    std::uint64_t recording_epoch = 0u) noexcept {
  if (state == nullptr || command_buffer == 0u) return;
  std::optional<
      renodx::games::detroitbecomehuman::dlss::SubmissionTraceRecord>
      trace_record;
  std::optional<renodx::games::detroitbecomehuman::dlss::AdapterTraceReadback>
      readback;
  {
    const std::lock_guard lock(state->mutex);
    trace_record = state->submission_trace_tracker.Complete(
        command_buffer, recording_epoch);
    if (trace_record.has_value()) {
      // Keep the exact trace record and its command-buffer scratch generation
      // in one state->adapter critical section. A completed old epoch must not
      // consume readback belonging to a freshly begun recording of the same
      // Vulkan handle.
      readback = state->adapter_runtime.TakeCompletedTraceReadback(
          FromOpaque<VkCommandBuffer>(command_buffer));
    }
  }
  if (!trace_record.has_value()) return;
  try {
    if (!readback.has_value()) {
      TraceEvaluationMessage(std::format(
          "DLSS trace_window={} attempt={} event=completion "
          "command_buffer=0x{:X} submit_count={} recording_generation={} "
          "recording_epoch={} readback=none",
          trace_record->window,
          trace_record->attempt,
          command_buffer,
          trace_record->submit_count,
          trace_record->recording_generation,
          trace_record->recording_epoch));
      return;
    }
    constexpr auto kTileCount =
        renodx::games::detroitbecomehuman::dlss::kTraceReadbackTileCount;
    std::array<std::uint64_t, kTileCount> hashes = {};
    for (std::uint32_t tile = 0u; tile < hashes.size(); ++tile) {
      hashes[tile] = HashTraceReadbackTile(*readback, tile);
    }
    TraceEvaluationMessage(std::format(
        "DLSS trace_window={} attempt={} event=completion "
        "command_buffer=0x{:X} submit_count={} recording_generation={} "
        "recording_epoch={} "
        "readback=host_scratch tiles={:016X},{:016X},{:016X},{:016X},{:016X}",
        trace_record->window,
        trace_record->attempt,
        command_buffer,
        trace_record->submit_count,
        trace_record->recording_generation,
        trace_record->recording_epoch,
        hashes[0u],
        hashes[1u],
        hashes[2u],
        hashes[3u],
        hashes[4u]));
  } catch (...) {
    // Readback logging happens only after completion and cannot affect output.
  }
}

void TraceFeatureSubmissionCompletion(
    DeviceState* state, const FeatureSubmissionSnapshot& snapshot) noexcept {
  for (const auto& command : snapshot.commands) {
    TraceFeatureCompletion(
        state, command.command_buffer, command.recording_epoch);
  }
}

struct TraceCompletionCandidate final {
  std::uint64_t command_buffer = 0u;
  std::uint64_t recording_epoch = 0u;
};

void AppendTraceCompletionCandidates(
    const FeatureSubmissionSnapshot& snapshot,
    std::vector<TraceCompletionCandidate>* command_buffers) {
  if (command_buffers == nullptr
      || !GetEvaluationTraceConfiguration().first_three) {
    return;
  }
  for (const auto& command : snapshot.commands) {
    command_buffers->push_back({
        .command_buffer = command.command_buffer,
        .recording_epoch = command.recording_epoch,
    });
  }
}

void RecycleCompletedCommandBuffers(
    DeviceState* state,
    const std::vector<CompletedFeatureRecording>& command_buffers) {
  if (state == nullptr || command_buffers.empty()) return;
  const std::lock_guard lock(state->mutex);
  for (const auto& command : command_buffers) {
    if (!state->feature_recording_candidates.Matches(
            command.command_buffer, command.recording_epoch)) {
      continue;
    }
    state->adapter_runtime.RecycleCommandBuffer(
        FromOpaque<VkCommandBuffer>(command.command_buffer));
    (void)state->feature_recording_candidates.EraseIfMatches(
        command.command_buffer, command.recording_epoch);
  }
  if (!state->feature_recording_candidates.Overflowed()
      && state->feature_recording_candidates.Empty()) {
    state->feature_command_buffer_bloom.store(0u, std::memory_order_release);
  }
  UpdateFeatureTrackingStateLocked(state);
}

void RecycleInternalFeatureFence(DeviceState* state, VkFence fence);
void DestroyInternalFeatureFencePool(DeviceState* state);

void CommitFeatureSubmission(
    DeviceState* state,
    VkQueue queue,
    VkFence fence,
    bool fence_owned_by_layer,
    const FeatureSubmissionSnapshot& snapshot) {
  if (snapshot.Empty()) return;
  std::vector<CompletedFeatureRecording> completed_command_buffers;
  std::vector<VkFence> stale_internal_fences;
  std::vector<TraceCompletionCandidate> trace_completed_command_buffers;
  bool log_one_time_submission = false;
  bool log_reusable_submission = false;
  {
    const std::lock_guard lock(state->mutex);
    const auto committed = state->ngx_context != nullptr
                               ? state->ngx_context->NotifySubmitted(
                                     ToOpaque(queue), snapshot)
                               : FeatureSubmissionSnapshot{};
    for (const auto& command : committed.commands) {
      (void)state->feature_recording_candidates.MarkSubmittedIfMatches(
          command.command_buffer, command.recording_epoch);
      if (command.one_time_submit
          && !state->logged_one_time_feature_submission) {
        state->logged_one_time_feature_submission = true;
        log_one_time_submission = true;
      } else if (!command.one_time_submit
                 && !state->logged_reusable_feature_submission) {
        state->logged_reusable_feature_submission = true;
        log_reusable_submission = true;
      }
    }
    if (fence != VK_NULL_HANDLE && !committed.Empty()) {
      const auto fence_key = ToOpaque(fence);
      const auto previous = state->fenced_feature_submissions.find(fence_key);
      if (previous != state->fenced_feature_submissions.end()) {
        // Valid Vulkan fence reuse requires the previous submission to have
        // completed and the fence to have been reset. Complete defensively in
        // case the reset was reached through an untracked dispatch path.
        auto stale = state->ngx_context != nullptr
                         ? state->ngx_context->NotifySubmissionCompleted(
                               previous->second.queue,
                               previous->second.snapshot)
                         : std::vector<CompletedFeatureRecording>{};
        completed_command_buffers.insert(
            completed_command_buffers.end(), stale.begin(), stale.end());
        if (previous->second.owned_by_layer) {
          stale_internal_fences.push_back(fence);
        }
        AppendTraceCompletionCandidates(
            previous->second.snapshot, &trace_completed_command_buffers);
        state->fenced_feature_submissions.erase(previous);
      }
      state->fenced_feature_submissions.emplace(
          fence_key,
          FencedFeatureSubmission{
              .queue = ToOpaque(queue),
              .snapshot = committed,
              .owned_by_layer = fence_owned_by_layer,
          });
    }
    UpdateFeatureTrackingStateLocked(state);
  }
  if (log_one_time_submission) {
    Trace("DLAA feature submissions use ONE_TIME_SUBMIT; private scratch can recycle at fence completion");
  }
  if (log_reusable_submission) {
    Trace("DLAA feature submission is reusable; its private scratch remains pinned until command-buffer reset");
  }
  for (const auto& command : trace_completed_command_buffers) {
    TraceFeatureCompletion(
        state, command.command_buffer, command.recording_epoch);
  }
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
  for (const VkFence stale_fence : stale_internal_fences) {
    RecycleInternalFeatureFence(state, stale_fence);
  }
}

void CompleteFeatureQueue(DeviceState* state, VkQueue queue) {
  if (state == nullptr
      || !state->feature_lifecycle_tracking_active.load(
          std::memory_order_acquire)) {
    return;
  }
  std::vector<CompletedFeatureRecording> completed_command_buffers;
  std::vector<VkFence> completed_internal_fences;
  std::vector<TraceCompletionCandidate> trace_completed_command_buffers;
  {
    const std::lock_guard lock(state->mutex);
    const auto queue_key = ToOpaque(queue);
    if (state->ngx_context != nullptr) {
      completed_command_buffers =
          state->ngx_context->NotifyQueueCompleted(queue_key);
    }
    for (auto submission = state->fenced_feature_submissions.begin();
         submission != state->fenced_feature_submissions.end();) {
      if (submission->second.queue != queue_key) {
        ++submission;
        continue;
      }
      if (submission->second.owned_by_layer) {
        completed_internal_fences.push_back(
            FromOpaque<VkFence>(submission->first));
      }
      AppendTraceCompletionCandidates(
          submission->second.snapshot, &trace_completed_command_buffers);
      submission = state->fenced_feature_submissions.erase(submission);
    }
    UpdateFeatureTrackingStateLocked(state);
  }
  for (const auto& command : trace_completed_command_buffers) {
    TraceFeatureCompletion(
        state, command.command_buffer, command.recording_epoch);
  }
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
  for (const VkFence fence : completed_internal_fences) {
    RecycleInternalFeatureFence(state, fence);
  }
}

void CompleteFeatureDevice(DeviceState* state) {
  if (state == nullptr
      || !state->feature_lifecycle_tracking_active.load(
          std::memory_order_acquire)) {
    return;
  }
  std::vector<CompletedFeatureRecording> completed_command_buffers;
  std::vector<VkFence> completed_internal_fences;
  std::vector<TraceCompletionCandidate> trace_completed_command_buffers;
  {
    const std::lock_guard lock(state->mutex);
    if (state->ngx_context != nullptr) {
      completed_command_buffers = state->ngx_context->NotifyDeviceCompleted();
    }
    for (const auto& [fence, submission] : state->fenced_feature_submissions) {
      if (submission.owned_by_layer) {
        completed_internal_fences.push_back(FromOpaque<VkFence>(fence));
      }
      AppendTraceCompletionCandidates(
          submission.snapshot, &trace_completed_command_buffers);
    }
    state->fenced_feature_submissions.clear();
    UpdateFeatureTrackingStateLocked(state);
  }
  for (const auto& command : trace_completed_command_buffers) {
    TraceFeatureCompletion(
        state, command.command_buffer, command.recording_epoch);
  }
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
  for (const VkFence fence : completed_internal_fences) {
    RecycleInternalFeatureFence(state, fence);
  }
}

void CompleteFeatureFence(DeviceState* state, VkFence fence) {
  if (state == nullptr || fence == VK_NULL_HANDLE
      || !state->feature_lifecycle_tracking_active.load(
          std::memory_order_acquire)) {
    return;
  }
  std::vector<CompletedFeatureRecording> completed_command_buffers;
  bool destroy_internal_fence = false;
  FeatureSubmissionSnapshot trace_completed_submission;
  {
    const std::lock_guard lock(state->mutex);
    const auto found = state->fenced_feature_submissions.find(ToOpaque(fence));
    if (found == state->fenced_feature_submissions.end()) return;
    auto submission = std::move(found->second);
    state->fenced_feature_submissions.erase(found);
    destroy_internal_fence = submission.owned_by_layer;
    if (state->ngx_context != nullptr) {
      completed_command_buffers =
          state->ngx_context->NotifySubmissionCompleted(
              submission.queue, submission.snapshot);
    }
    if (GetEvaluationTraceConfiguration().first_three) {
      trace_completed_submission = std::move(submission.snapshot);
    }
    UpdateFeatureTrackingStateLocked(state);
  }
  TraceFeatureSubmissionCompletion(state, trace_completed_submission);
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
  if (destroy_internal_fence) {
    RecycleInternalFeatureFence(state, fence);
  }
}

void PollCompletedInternalFeatureFences(DeviceState* state) {
  if (state == nullptr || state->next_get_fence_status == nullptr
      || !state->internal_feature_fences_pending.load(
          std::memory_order_acquire)) {
    return;
  }

  std::vector<CompletedFeatureRecording> completed_command_buffers;
  std::vector<VkFence> completed_fences;
  std::vector<TraceCompletionCandidate> trace_completed_command_buffers;
  {
    const std::lock_guard lock(state->mutex);
    for (auto submission = state->fenced_feature_submissions.begin();
         submission != state->fenced_feature_submissions.end();) {
      const auto fence = FromOpaque<VkFence>(submission->first);
      if (state->next_get_fence_status(state->device, fence) != VK_SUCCESS) {
        ++submission;
        continue;
      }
      auto completed = state->ngx_context != nullptr
                           ? state->ngx_context->NotifySubmissionCompleted(
                                 submission->second.queue,
                                 submission->second.snapshot)
                           : std::vector<CompletedFeatureRecording>{};
      completed_command_buffers.insert(
          completed_command_buffers.end(), completed.begin(), completed.end());
      if (submission->second.owned_by_layer) {
        completed_fences.push_back(fence);
      }
      AppendTraceCompletionCandidates(
          submission->second.snapshot, &trace_completed_command_buffers);
      submission = state->fenced_feature_submissions.erase(submission);
    }
    UpdateFeatureTrackingStateLocked(state);
  }
  for (const auto& command : trace_completed_command_buffers) {
    TraceFeatureCompletion(
        state, command.command_buffer, command.recording_epoch);
  }
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
  for (const VkFence fence : completed_fences) {
    RecycleInternalFeatureFence(state, fence);
  }
}

void PollRetiredFeatureFencesOnQueueSubmit(DeviceState* state) {
  if (state == nullptr
      || !state->internal_feature_fences_pending.load(
          std::memory_order_acquire)
      || state->feature_evaluation_active.load(std::memory_order_acquire)) {
    return;
  }
  const auto serial = state->retired_feature_fence_poll_serial.fetch_add(
      1u, std::memory_order_relaxed);
  if ((serial & (kRetiredFeatureFencePollSubmitInterval - 1u)) != 0u) return;
  PollCompletedInternalFeatureFences(state);
}

void CompleteUnfencedFeatureSubmissionFallback(
    DeviceState* state,
    VkQueue queue,
    bool internal_fence_required,
    VkFence internal_fence,
    VkResult submit_result) {
  if (state == nullptr || !internal_fence_required
      || internal_fence != VK_NULL_HANDLE || submit_result != VK_SUCCESS
      || state->next_queue_wait_idle == nullptr) {
    return;
  }
  VkResult wait_result = VK_ERROR_INITIALIZATION_FAILED;
  {
    const std::lock_guard queue_lock(state->queue_mutex);
    wait_result = state->next_queue_wait_idle(queue);
  }
  if (wait_result == VK_SUCCESS) CompleteFeatureQueue(state, queue);
}

void RecycleInternalFeatureFence(DeviceState* state, VkFence fence) {
  if (state == nullptr || fence == VK_NULL_HANDLE) return;
  bool pooled = false;
  if (!state->destroying.load(std::memory_order_acquire)
      && state->next_reset_fences != nullptr
      && state->next_reset_fences(state->device, 1u, &fence) == VK_SUCCESS) {
    const std::lock_guard lock(state->mutex);
    if (!state->destroying.load(std::memory_order_relaxed)
        && state->available_internal_feature_fences.size()
               < kMaximumInternalFeatureFencePoolSize) {
      state->available_internal_feature_fences.push_back(fence);
      pooled = true;
    }
  }
  if (!pooled && state->next_destroy_fence != nullptr) {
    state->next_destroy_fence(state->device, fence, nullptr);
  }
}

void DestroyInternalFeatureFencePool(DeviceState* state) {
  if (state == nullptr) return;
  std::vector<VkFence> fences;
  {
    const std::lock_guard lock(state->mutex);
    fences.swap(state->available_internal_feature_fences);
  }
  if (state->next_destroy_fence != nullptr) {
    for (const VkFence fence : fences) {
      state->next_destroy_fence(state->device, fence, nullptr);
    }
  }
}

VkFence CreateInternalFeatureFence(
    DeviceState* state, const FeatureSubmissionSnapshot& snapshot) {
  if (state == nullptr || snapshot.Empty() || state->next_create_fence == nullptr
      || state->next_destroy_fence == nullptr) {
    return VK_NULL_HANDLE;
  }
  {
    const std::lock_guard lock(state->mutex);
    if (!state->available_internal_feature_fences.empty()) {
      const VkFence fence = state->available_internal_feature_fences.back();
      state->available_internal_feature_fences.pop_back();
      return fence;
    }
  }
  const VkFenceCreateInfo create_info = {
      VK_STRUCTURE_TYPE_FENCE_CREATE_INFO,
      nullptr,
      0u,
  };
  VkFence fence = VK_NULL_HANDLE;
  return state->next_create_fence(state->device, &create_info, nullptr, &fence)
                 == VK_SUCCESS
             ? fence
             : VK_NULL_HANDLE;
}

VkResult SubmitQueueLocked(
    DeviceState* state,
    VkQueue queue,
    std::uint32_t submit_count,
    const VkSubmitInfo* submits,
    VkFence fence) {
  if (queue != state->graphics_queue) {
    return state->next_queue_submit(queue, submit_count, submits, fence);
  }
  const std::lock_guard queue_lock(state->queue_mutex);
  return state->next_queue_submit(queue, submit_count, submits, fence);
}

#if defined(VK_VERSION_1_3)
VkResult SubmitQueue2Locked(
    DeviceState* state,
    VkQueue queue,
    std::uint32_t submit_count,
    const VkSubmitInfo2* submits,
    VkFence fence) {
  if (queue != state->graphics_queue) {
    return state->next_queue_submit2(queue, submit_count, submits, fence);
  }
  const std::lock_guard queue_lock(state->queue_mutex);
  return state->next_queue_submit2(queue, submit_count, submits, fence);
}
#endif

#if defined(VK_KHR_synchronization2)
VkResult SubmitQueue2KhrLocked(
    DeviceState* state,
    VkQueue queue,
    std::uint32_t submit_count,
    const VkSubmitInfo2KHR* submits,
    VkFence fence) {
  if (queue != state->graphics_queue) {
    return state->next_queue_submit2_khr(queue, submit_count, submits, fence);
  }
  const std::lock_guard queue_lock(state->queue_mutex);
  return state->next_queue_submit2_khr(queue, submit_count, submits, fence);
}
#endif

VKAPI_ATTR VkResult VKAPI_CALL LayerQueueSubmit(
    VkQueue queue,
    std::uint32_t submit_count,
    const VkSubmitInfo* submits,
    VkFence fence) {
  auto* state = FindDeviceFast(queue);
  if (state == nullptr || state->next_queue_submit == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  PollRetiredFeatureFencesOnQueueSubmit(state);
  if (!state->feature_submission_tracking_active.load(std::memory_order_acquire)) {
    return SubmitQueueLocked(state, queue, submit_count, submits, fence);
  }

  const auto feature_bloom = state->feature_command_buffer_bloom.load(
      std::memory_order_acquire);
  thread_local std::vector<std::uint64_t> command_buffers;
  command_buffers.clear();
  if (submits != nullptr) {
    for (std::uint32_t submit_index = 0u; submit_index < submit_count; ++submit_index) {
      const auto& submit = submits[submit_index];
      if (submit.pCommandBuffers == nullptr) continue;
      for (std::uint32_t command_index = 0u;
           command_index < submit.commandBufferCount;
           ++command_index) {
        AppendFeatureSubmissionCandidate(
            *state,
            submit.pCommandBuffers[command_index],
            feature_bloom,
            &command_buffers);
      }
    }
  }
  if (command_buffers.empty()) {
    return SubmitQueueLocked(state, queue, submit_count, submits, fence);
  }
  thread_local std::vector<TraceSubmissionCandidate> trace_candidates;
  trace_candidates.clear();
  CaptureTraceSubmissionCandidates(
      state, command_buffers, &trace_candidates);
  const auto snapshot = CaptureFeatureSubmission(state, command_buffers);
  const bool needs_internal_fence = fence == VK_NULL_HANDLE && !snapshot.Empty()
                                    && SubmissionNeedsInternalFeatureFence(
                                        state, snapshot);
  const VkFence internal_fence =
      needs_internal_fence ? CreateInternalFeatureFence(state, snapshot)
                           : VK_NULL_HANDLE;
  const VkFence tracked_fence =
      internal_fence != VK_NULL_HANDLE ? internal_fence : fence;
  LogFencelessFeatureSubmissionOnce(fence, internal_fence, snapshot);
  const VkResult result = SubmitQueueLocked(
      state, queue, submit_count, submits, tracked_fence);
  TraceFeatureSubmissionResult(
      state, snapshot, queue, tracked_fence, result);
  TracePostCompletionResubmissionResult(
      state,
      trace_candidates,
      snapshot,
      queue,
      tracked_fence,
      result);
  if (result == VK_SUCCESS) {
    CommitFeatureSubmission(
        state,
        queue,
        tracked_fence,
        internal_fence != VK_NULL_HANDLE,
        snapshot);
    CompleteUnfencedFeatureSubmissionFallback(
        state, queue, needs_internal_fence, internal_fence, result);
  } else if (internal_fence != VK_NULL_HANDLE) {
    RecycleInternalFeatureFence(state, internal_fence);
  }
  return result;
}

#if defined(VK_VERSION_1_3)
VKAPI_ATTR VkResult VKAPI_CALL LayerQueueSubmit2(
    VkQueue queue,
    std::uint32_t submit_count,
    const VkSubmitInfo2* submits,
    VkFence fence) {
  auto* state = FindDeviceFast(queue);
  if (state == nullptr || state->next_queue_submit2 == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  PollRetiredFeatureFencesOnQueueSubmit(state);
  if (!state->feature_submission_tracking_active.load(std::memory_order_acquire)) {
    return SubmitQueue2Locked(state, queue, submit_count, submits, fence);
  }

  const auto feature_bloom = state->feature_command_buffer_bloom.load(
      std::memory_order_acquire);
  thread_local std::vector<std::uint64_t> command_buffers;
  command_buffers.clear();
  if (submits != nullptr) {
    for (std::uint32_t submit_index = 0u; submit_index < submit_count; ++submit_index) {
      const auto& submit = submits[submit_index];
      if (submit.pCommandBufferInfos == nullptr) continue;
      for (std::uint32_t command_index = 0u;
           command_index < submit.commandBufferInfoCount;
           ++command_index) {
        AppendFeatureSubmissionCandidate(
            *state,
            submit.pCommandBufferInfos[command_index].commandBuffer,
            feature_bloom,
            &command_buffers);
      }
    }
  }
  if (command_buffers.empty()) {
    return SubmitQueue2Locked(state, queue, submit_count, submits, fence);
  }
  thread_local std::vector<TraceSubmissionCandidate> trace_candidates;
  trace_candidates.clear();
  CaptureTraceSubmissionCandidates(
      state, command_buffers, &trace_candidates);
  const auto snapshot = CaptureFeatureSubmission(state, command_buffers);
  const bool needs_internal_fence = fence == VK_NULL_HANDLE && !snapshot.Empty()
                                    && SubmissionNeedsInternalFeatureFence(
                                        state, snapshot);
  const VkFence internal_fence =
      needs_internal_fence ? CreateInternalFeatureFence(state, snapshot)
                           : VK_NULL_HANDLE;
  const VkFence tracked_fence =
      internal_fence != VK_NULL_HANDLE ? internal_fence : fence;
  LogFencelessFeatureSubmissionOnce(fence, internal_fence, snapshot);
  const VkResult result = SubmitQueue2Locked(
      state, queue, submit_count, submits, tracked_fence);
  TraceFeatureSubmissionResult(
      state, snapshot, queue, tracked_fence, result);
  TracePostCompletionResubmissionResult(
      state,
      trace_candidates,
      snapshot,
      queue,
      tracked_fence,
      result);
  if (result == VK_SUCCESS) {
    CommitFeatureSubmission(
        state,
        queue,
        tracked_fence,
        internal_fence != VK_NULL_HANDLE,
        snapshot);
    CompleteUnfencedFeatureSubmissionFallback(
        state, queue, needs_internal_fence, internal_fence, result);
  } else if (internal_fence != VK_NULL_HANDLE) {
    RecycleInternalFeatureFence(state, internal_fence);
  }
  return result;
}
#endif

#if defined(VK_KHR_synchronization2)
VKAPI_ATTR VkResult VKAPI_CALL LayerQueueSubmit2KHR(
    VkQueue queue,
    std::uint32_t submit_count,
    const VkSubmitInfo2KHR* submits,
    VkFence fence) {
  auto* state = FindDeviceFast(queue);
  if (state == nullptr || state->next_queue_submit2_khr == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  PollRetiredFeatureFencesOnQueueSubmit(state);
  if (!state->feature_submission_tracking_active.load(std::memory_order_acquire)) {
    return SubmitQueue2KhrLocked(state, queue, submit_count, submits, fence);
  }

  const auto feature_bloom = state->feature_command_buffer_bloom.load(
      std::memory_order_acquire);
  thread_local std::vector<std::uint64_t> command_buffers;
  command_buffers.clear();
  if (submits != nullptr) {
    for (std::uint32_t submit_index = 0u; submit_index < submit_count; ++submit_index) {
      const auto& submit = submits[submit_index];
      if (submit.pCommandBufferInfos == nullptr) continue;
      for (std::uint32_t command_index = 0u;
           command_index < submit.commandBufferInfoCount;
           ++command_index) {
        AppendFeatureSubmissionCandidate(
            *state,
            submit.pCommandBufferInfos[command_index].commandBuffer,
            feature_bloom,
            &command_buffers);
      }
    }
  }
  if (command_buffers.empty()) {
    return SubmitQueue2KhrLocked(state, queue, submit_count, submits, fence);
  }
  thread_local std::vector<TraceSubmissionCandidate> trace_candidates;
  trace_candidates.clear();
  CaptureTraceSubmissionCandidates(
      state, command_buffers, &trace_candidates);
  const auto snapshot = CaptureFeatureSubmission(state, command_buffers);
  const bool needs_internal_fence = fence == VK_NULL_HANDLE && !snapshot.Empty()
                                    && SubmissionNeedsInternalFeatureFence(
                                        state, snapshot);
  const VkFence internal_fence =
      needs_internal_fence ? CreateInternalFeatureFence(state, snapshot)
                           : VK_NULL_HANDLE;
  const VkFence tracked_fence =
      internal_fence != VK_NULL_HANDLE ? internal_fence : fence;
  LogFencelessFeatureSubmissionOnce(fence, internal_fence, snapshot);
  const VkResult result = SubmitQueue2KhrLocked(
      state, queue, submit_count, submits, tracked_fence);
  TraceFeatureSubmissionResult(
      state, snapshot, queue, tracked_fence, result);
  TracePostCompletionResubmissionResult(
      state,
      trace_candidates,
      snapshot,
      queue,
      tracked_fence,
      result);
  if (result == VK_SUCCESS) {
    CommitFeatureSubmission(
        state,
        queue,
        tracked_fence,
        internal_fence != VK_NULL_HANDLE,
        snapshot);
    CompleteUnfencedFeatureSubmissionFallback(
        state, queue, needs_internal_fence, internal_fence, result);
  } else if (internal_fence != VK_NULL_HANDLE) {
    RecycleInternalFeatureFence(state, internal_fence);
  }
  return result;
}
#endif

VKAPI_ATTR VkResult VKAPI_CALL LayerQueueWaitIdle(VkQueue queue) {
  auto* state = FindDeviceFast(queue);
  if (state == nullptr || state->next_queue_wait_idle == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  VkResult result = VK_ERROR_INITIALIZATION_FAILED;
  {
    const std::lock_guard queue_lock(state->queue_mutex);
    result = state->next_queue_wait_idle(queue);
  }
  if (result == VK_SUCCESS) CompleteFeatureQueue(state, queue);
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerDeviceWaitIdle(VkDevice device) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_device_wait_idle == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  const VkResult result = state->next_device_wait_idle(device);
  if (result == VK_SUCCESS) CompleteFeatureDevice(state);
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerWaitForFences(
    VkDevice device,
    std::uint32_t fence_count,
    const VkFence* fences,
    VkBool32 wait_all,
    std::uint64_t timeout) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_wait_for_fences == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  const VkResult result =
      state->next_wait_for_fences(device, fence_count, fences, wait_all, timeout);
  if (result != VK_SUCCESS || fences == nullptr) return result;

  if (wait_all == VK_TRUE || fence_count == 1u) {
    for (std::uint32_t index = 0u; index < fence_count; ++index) {
      CompleteFeatureFence(state, fences[index]);
    }
    return result;
  }

  // wait_all == false only proves that at least one fence is signaled. Query
  // each fence through the downstream trampoline before releasing resources.
  if (state->next_get_fence_status != nullptr) {
    for (std::uint32_t index = 0u; index < fence_count; ++index) {
      if (state->next_get_fence_status(device, fences[index]) == VK_SUCCESS) {
        CompleteFeatureFence(state, fences[index]);
      }
    }
  }
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerGetFenceStatus(
    VkDevice device, VkFence fence) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_get_fence_status == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  const VkResult result = state->next_get_fence_status(device, fence);
  if (result == VK_SUCCESS) CompleteFeatureFence(state, fence);
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerResetFences(
    VkDevice device,
    std::uint32_t fence_count,
    const VkFence* fences) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_reset_fences == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  const VkResult result = state->next_reset_fences(device, fence_count, fences);
  if (result == VK_SUCCESS && fences != nullptr) {
    for (std::uint32_t index = 0u; index < fence_count; ++index) {
      CompleteFeatureFence(state, fences[index]);
    }
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyFence(
    VkDevice device,
    VkFence fence,
    const VkAllocationCallbacks* allocator) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_destroy_fence == nullptr) return;
  // Destroying a fence while its queue submission is pending is invalid.
  // Therefore the successful-use boundary is already sufficient to retire a
  // tracked one-time recording before forwarding destruction.
  CompleteFeatureFence(state, fence);
  state->next_destroy_fence(device, fence, allocator);
}

void RemoveCommandBufferPoolMappingLocked(
    DeviceState* state,
    VkCommandBuffer command_buffer) {
  const auto command_buffer_key = ToOpaque(command_buffer);
  ErasePublishedCommandBufferStateLocked(state, command_buffer_key);
  state->command_buffer_levels.erase(command_buffer_key);
  const auto mapped_pool = state->command_buffer_pools.find(command_buffer_key);
  if (mapped_pool == state->command_buffer_pools.end()) return;
  const auto pool_key = mapped_pool->second;
  const auto pool = state->command_pool_buffers.find(pool_key);
  if (pool != state->command_pool_buffers.end()) {
    auto& buffers = pool->second;
    std::erase(buffers, command_buffer);
    if (buffers.empty()) state->command_pool_buffers.erase(pool);
  }
  state->command_buffer_pools.erase(mapped_pool);
}

VKAPI_ATTR VkResult VKAPI_CALL LayerCreateCommandPool(
    VkDevice device,
    const VkCommandPoolCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkCommandPool* command_pool) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = state->next_create_command_pool;
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, create_info, allocator, command_pool);
  if (result != VK_SUCCESS || create_info == nullptr || command_pool == nullptr) {
    return result;
  }

  const std::lock_guard lock(state->tracking_mutex);
  state->command_pools[ToOpaque(*command_pool)] = {
      .queue_family_index = create_info->queueFamilyIndex,
      .flags = create_info->flags,
  };
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerAllocateCommandBuffers(
    VkDevice device,
    const VkCommandBufferAllocateInfo* allocate_info,
    VkCommandBuffer* command_buffers) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = state->next_allocate_command_buffers;
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(device, allocate_info, command_buffers);
  if (result != VK_SUCCESS || allocate_info == nullptr || command_buffers == nullptr) {
    return result;
  }

  const auto pool_key = ToOpaque(allocate_info->commandPool);
  {
    const std::lock_guard lock(state->tracking_mutex);
    for (std::uint32_t index = 0u; index < allocate_info->commandBufferCount; ++index) {
      RemoveCommandBufferPoolMappingLocked(state, command_buffers[index]);
    }
    auto& pool_buffers = state->command_pool_buffers[pool_key];
    for (std::uint32_t index = 0u; index < allocate_info->commandBufferCount; ++index) {
      state->command_buffer_pools[ToOpaque(command_buffers[index])] = pool_key;
      state->command_buffer_levels[ToOpaque(command_buffers[index])] =
          allocate_info->level;
      pool_buffers.push_back(command_buffers[index]);
    }
  }
  DiscardFeatureCommandBuffers(
      state,
      std::vector<VkCommandBuffer>(
          command_buffers, command_buffers + allocate_info->commandBufferCount));
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerResetCommandPool(
    VkDevice device,
    VkCommandPool command_pool,
    VkCommandPoolResetFlags flags) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = state->next_reset_command_pool;
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;

  const VkResult result = trampoline(device, command_pool, flags);
  if (result != VK_SUCCESS) return result;

  std::vector<VkCommandBuffer> command_buffers;
  {
    const std::lock_guard lock(state->tracking_mutex);
    const auto pool = state->command_pool_buffers.find(ToOpaque(command_pool));
    if (pool != state->command_pool_buffers.end()) {
      command_buffers = pool->second;
    }
    for (const auto command_buffer : command_buffers) {
      ErasePublishedCommandBufferStateLocked(
          state, ToOpaque(command_buffer));
    }
  }

  // A successful pool reset guarantees that none of its command buffers are
  // pending and invalidates all their old recordings. Do not hold the layer
  // tracking mutex while taking the adapter mutex.
  PollCompletedInternalFeatureFences(state);
  auto& thread_states = GetThreadComputeCommandStates();
  for (const auto command_buffer : command_buffers) {
    if (MayBeFeatureRecordingCandidate(*state, command_buffer)) {
      if (GetEvaluationTraceConfiguration().first_three) {
        TraceFeatureCompletion(state, ToOpaque(command_buffer));
      }
      state->adapter_runtime.RecycleCommandBuffer(command_buffer);
    }
    thread_states.ResetRecording(ToOpaque(command_buffer));
  }
  DiscardFeatureCommandBuffers(state, command_buffers);
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyCommandPool(
    VkDevice device,
    VkCommandPool command_pool,
    const VkAllocationCallbacks* allocator) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return;
  const auto trampoline = state->next_destroy_command_pool;
  if (trampoline == nullptr) return;

  std::vector<VkCommandBuffer> command_buffers;
  {
    const std::lock_guard lock(state->tracking_mutex);
    const auto pool_key = ToOpaque(command_pool);
    const auto pool = state->command_pool_buffers.find(pool_key);
    if (pool != state->command_pool_buffers.end()) {
      command_buffers = std::move(pool->second);
      state->command_pool_buffers.erase(pool);
    }
    for (const auto command_buffer : command_buffers) {
      const auto key = ToOpaque(command_buffer);
      state->command_buffer_pools.erase(key);
      state->command_buffer_levels.erase(key);
      ErasePublishedCommandBufferStateLocked(state, key);
    }
    state->command_pools.erase(pool_key);
  }
  PollCompletedInternalFeatureFences(state);
  auto& thread_states = GetThreadComputeCommandStates();
  for (const auto command_buffer : command_buffers) {
    if (MayBeFeatureRecordingCandidate(*state, command_buffer)) {
      if (GetEvaluationTraceConfiguration().first_three) {
        TraceFeatureCompletion(state, ToOpaque(command_buffer));
      }
      (void)state->adapter_runtime.RetireCommandBuffer(command_buffer);
    }
    thread_states.erase(ToOpaque(command_buffer));
  }
  trampoline(device, command_pool, allocator);
  DiscardFeatureCommandBuffers(state, command_buffers);
}

VKAPI_ATTR VkResult VKAPI_CALL LayerCreateDynamicDescriptorUpdateTemplate(
    VkDevice device,
    const VkDescriptorUpdateTemplateCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkDescriptorUpdateTemplate* descriptor_update_template) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_create_descriptor_update_template == nullptr) {
    return VK_ERROR_EXTENSION_NOT_PRESENT;
  }
  const VkResult result = state->next_create_descriptor_update_template(
      device, create_info, allocator, descriptor_update_template);
  if (result != VK_SUCCESS || create_info == nullptr
      || descriptor_update_template == nullptr) {
    return result;
  }

  std::optional<DynamicDescriptorTemplateEntry> dynamic_entry;
  for (std::uint32_t index = 0u;
       index < create_info->descriptorUpdateEntryCount;
       ++index) {
    const auto& entry = create_info->pDescriptorUpdateEntries[index];
    if (entry.dstBinding == DETROIT_DLSS_TAA_CONSTANT_BINDING_52
        && entry.dstArrayElement == 0u && entry.descriptorCount == 1u
        && entry.descriptorType == VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC) {
      dynamic_entry = {.offset = entry.offset};
    }
  }
  const std::unique_lock lock(state->descriptor_template_mutex);
  const auto key = ToOpaque(*descriptor_update_template);
  if (dynamic_entry.has_value()) {
    state->dynamic_descriptor_templates[key] = *dynamic_entry;
  } else {
    state->dynamic_descriptor_templates.erase(key);
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerDestroyDynamicDescriptorUpdateTemplate(
    VkDevice device,
    VkDescriptorUpdateTemplate descriptor_update_template,
    const VkAllocationCallbacks* allocator) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return;
  {
    const std::unique_lock lock(state->descriptor_template_mutex);
    state->dynamic_descriptor_templates.erase(
        ToOpaque(descriptor_update_template));
  }
  if (state->next_destroy_descriptor_update_template != nullptr) {
    state->next_destroy_descriptor_update_template(
        device, descriptor_update_template, allocator);
  }
}

VKAPI_ATTR void VKAPI_CALL LayerUpdateDynamicDescriptorSetWithTemplate(
    VkDevice device,
    VkDescriptorSet descriptor_set,
    VkDescriptorUpdateTemplate descriptor_update_template,
    const void* descriptor_data) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr
      || state->next_update_descriptor_set_with_template == nullptr) {
    return;
  }

  auto& current = GetCurrentDynamicDescriptorUpdateScope();
  const auto previous = current;
  current = {
      .device = device,
      .template_descriptor_set = descriptor_set,
      .descriptor_update_template = descriptor_update_template,
      .template_data = descriptor_data,
  };
  state->next_update_descriptor_set_with_template(
      device, descriptor_set, descriptor_update_template, descriptor_data);
  current = previous;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerObserveBindBufferMemory(
    VkDevice device,
    VkBuffer buffer,
    VkDeviceMemory memory,
    VkDeviceSize memory_offset) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_bind_buffer_memory == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  const VkResult result =
      state->next_bind_buffer_memory(device, buffer, memory, memory_offset);
  if (result == VK_SUCCESS) {
    const std::unique_lock lock(state->mapped_buffer_mutex);
    state->narrow_buffer_bindings[ToOpaque(buffer)] = {
        .memory = memory,
        .offset = memory_offset,
    };
  }
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerObserveBindBufferMemory2(
    VkDevice device,
    std::uint32_t bind_info_count,
    const VkBindBufferMemoryInfo* bind_infos) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_bind_buffer_memory2 == nullptr) {
    return VK_ERROR_EXTENSION_NOT_PRESENT;
  }
  const VkResult result =
      state->next_bind_buffer_memory2(device, bind_info_count, bind_infos);
  if (result == VK_SUCCESS && bind_infos != nullptr) {
    const std::unique_lock lock(state->mapped_buffer_mutex);
    for (std::uint32_t index = 0u; index < bind_info_count; ++index) {
      state->narrow_buffer_bindings[ToOpaque(bind_infos[index].buffer)] = {
          .memory = bind_infos[index].memory,
          .offset = bind_infos[index].memoryOffset,
      };
    }
  }
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerObserveMapMemory(
    VkDevice device,
    VkDeviceMemory memory,
    VkDeviceSize offset,
    VkDeviceSize size,
    VkMemoryMapFlags flags,
    void** data) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr || state->next_map_memory == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  const VkResult result =
      state->next_map_memory(device, memory, offset, size, flags, data);
  if (result == VK_SUCCESS && data != nullptr && *data != nullptr) {
    const std::unique_lock lock(state->mapped_buffer_mutex);
    state->narrow_mapped_memories[ToOpaque(memory)] = {
        .pointer = *data,
        .offset = offset,
        .size = size,
    };
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerObserveUnmapMemory(
    VkDevice device, VkDeviceMemory memory) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return;
  {
    const std::unique_lock lock(state->mapped_buffer_mutex);
    const auto mapped = state->narrow_mapped_memories.find(ToOpaque(memory));
    if (mapped != state->narrow_mapped_memories.end()) {
      mapped->second.pointer = nullptr;
    }
  }
  if (state->next_unmap_memory != nullptr) {
    state->next_unmap_memory(device, memory);
  }
}

VKAPI_ATTR void VKAPI_CALL LayerObserveDestroyBuffer(
    VkDevice device,
    VkBuffer buffer,
    const VkAllocationCallbacks* allocator) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return;
  if (state->next_destroy_buffer != nullptr) {
    state->next_destroy_buffer(device, buffer, allocator);
  }
  const std::unique_lock lock(state->mapped_buffer_mutex);
  state->narrow_buffer_bindings.erase(ToOpaque(buffer));
}

VKAPI_ATTR void VKAPI_CALL LayerObserveFreeMemory(
    VkDevice device,
    VkDeviceMemory memory,
    const VkAllocationCallbacks* allocator) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return;
  {
    const std::unique_lock lock(state->mapped_buffer_mutex);
    state->narrow_mapped_memories.erase(ToOpaque(memory));
  }
  if (state->next_free_memory != nullptr) {
    state->next_free_memory(device, memory, allocator);
  }
}

VKAPI_ATTR void VKAPI_CALL LayerUpdateDynamicConstantBufferDescriptorSets(
    VkDevice device,
    std::uint32_t descriptor_write_count,
    const VkWriteDescriptorSet* descriptor_writes,
    std::uint32_t descriptor_copy_count,
    const VkCopyDescriptorSet* descriptor_copies) {
  PFN_vkUpdateDescriptorSets trampoline = nullptr;
  if (fast_command_dispatch_key.load(std::memory_order_acquire)
      == DispatchKey(device)) {
    trampoline = fast_update_descriptor_sets.load(std::memory_order_relaxed);
  }
  if (trampoline == nullptr) {
    auto* state = FindDeviceFast(device);
    if (state != nullptr) trampoline = state->next_update_descriptor_sets;
  }
  if (trampoline == nullptr) return;

  auto& current = GetCurrentDynamicDescriptorUpdateScope();
  const auto previous = current;
  current = {
      .device = device,
      .write_count = descriptor_write_count,
      .writes = descriptor_writes,
  };
  trampoline(
      device,
      descriptor_write_count,
      descriptor_writes,
      descriptor_copy_count,
      descriptor_copies);
  current = previous;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerBeginCommandBuffer(
    VkCommandBuffer command_buffer, const VkCommandBufferBeginInfo* begin_info) {
  PFN_vkBeginCommandBuffer trampoline = nullptr;
  if (fast_command_dispatch_key.load(std::memory_order_acquire)
      == DispatchKey(command_buffer)) {
    trampoline = fast_begin_command_buffer.load(std::memory_order_relaxed);
  }
  if (trampoline == nullptr) {
    auto* state = FindDeviceFast(command_buffer);
    if (state != nullptr) trampoline = state->next_begin_command_buffer;
  }
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(command_buffer, begin_info);
  if (result == VK_SUCCESS) {
    auto& local = GetCurrentThreadComputeCommandState();
    auto next_generation = local.recording_generation + 1u;
    if (next_generation == 0u) next_generation = 1u;
    local = {
        .command_buffer = ToOpaque(command_buffer),
        .begin_flags = begin_info != nullptr ? begin_info->flags : 0u,
        .recording_generation = next_generation,
        .recording_active = true,
    };
  }
  return result;
}

VKAPI_ATTR VkResult VKAPI_CALL LayerResetCommandBuffer(
    VkCommandBuffer command_buffer, VkCommandBufferResetFlags flags) {
  auto* state = FindDeviceFast(command_buffer);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = state->next_reset_command_buffer;
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(command_buffer, flags);
  if (result == VK_SUCCESS) {
    const auto command_buffer_handle = ToOpaque(command_buffer);
    const bool may_have_feature_recording =
        MayBeFeatureRecordingCandidate(*state, command_buffer);
    if (may_have_feature_recording) {
      PollCompletedInternalFeatureFences(state);
      if (GetEvaluationTraceConfiguration().first_three) {
        TraceFeatureCompletion(state, command_buffer_handle);
      }
      state->adapter_runtime.RecycleCommandBuffer(command_buffer);
    }
    GetThreadComputeCommandStates().ResetRecording(command_buffer_handle);
    if (MayHavePublishedCommandBufferState(
            *state, command_buffer_handle)) {
      const std::lock_guard lock(state->tracking_mutex);
      ErasePublishedCommandBufferStateLocked(
          state, command_buffer_handle);
    }
    DiscardFeatureCommandBuffer(state, command_buffer);
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL LayerFreeCommandBuffers(
    VkDevice device,
    VkCommandPool command_pool,
    std::uint32_t command_buffer_count,
    const VkCommandBuffer* command_buffers) {
  auto* state = FindDeviceFast(device);
  if (state == nullptr) return;
  const auto trampoline = state->next_free_command_buffers;
  if (trampoline == nullptr) return;
  // Freeing command buffers while pending is invalid, so any layer-owned
  // completion fence for this valid call is ready to be observed first.
  PollCompletedInternalFeatureFences(state);
  if (command_buffers != nullptr) {
    for (std::uint32_t index = 0u; index < command_buffer_count; ++index) {
      if (MayBeFeatureRecordingCandidate(*state, command_buffers[index])) {
        if (GetEvaluationTraceConfiguration().first_three) {
          TraceFeatureCompletion(
              state, ToOpaque(command_buffers[index]));
        }
        (void)state->adapter_runtime.RetireCommandBuffer(command_buffers[index]);
      }
    }
  }
  trampoline(device, command_pool, command_buffer_count, command_buffers);
  if (command_buffers == nullptr) return;
  auto& thread_states = GetThreadComputeCommandStates();
  for (std::uint32_t index = 0u; index < command_buffer_count; ++index) {
    thread_states.erase(ToOpaque(command_buffers[index]));
  }
  {
    const std::lock_guard lock(state->tracking_mutex);
    for (std::uint32_t index = 0u; index < command_buffer_count; ++index) {
      RemoveCommandBufferPoolMappingLocked(state, command_buffers[index]);
    }
  }
  DiscardFeatureCommandBuffers(
      state,
      std::vector<VkCommandBuffer>(
          command_buffers, command_buffers + command_buffer_count));
}

VKAPI_ATTR void VKAPI_CALL LayerCmdBindPipeline(
    VkCommandBuffer command_buffer,
    VkPipelineBindPoint pipeline_bind_point,
    VkPipeline pipeline) {
  const bool tracking_enabled =
      runtime_command_tracking_enabled.load(std::memory_order_acquire);
  if (!tracking_enabled
      && fast_command_dispatch_key.load(std::memory_order_acquire)
             == DispatchKey(command_buffer)) {
    const auto trampoline =
        fast_cmd_bind_pipeline.load(std::memory_order_relaxed);
    if (trampoline != nullptr) {
      trampoline(command_buffer, pipeline_bind_point, pipeline);
      return;
    }
  }
  auto* state = FindDeviceFast(command_buffer);
  if (state == nullptr) return;
  const auto trampoline = state->next_cmd_bind_pipeline;
  if (trampoline == nullptr) return;
  trampoline(command_buffer, pipeline_bind_point, pipeline);
  if (pipeline_bind_point != VK_PIPELINE_BIND_POINT_COMPUTE) return;
  if (!tracking_enabled) return;

  const std::uint64_t command_buffer_handle = ToOpaque(command_buffer);
  auto& local = GetThreadComputeCommandStates()[command_buffer_handle];
  local.pipeline = pipeline;
  if (!local.temporal_descriptor_set_bound
      && !local.dof_composite_descriptor_set_bound) {
    return;
  }
  const std::lock_guard lock(state->tracking_mutex);
  if (local.temporal_descriptor_set_bound) {
    const auto restore =
        state->command_buffer_restore_states.find(command_buffer_handle);
    if (restore != state->command_buffer_restore_states.end()) {
      restore->second.pipeline = pipeline;
    }
  }
  if (local.dof_composite_descriptor_set_bound) {
    const auto composite =
        state->command_buffer_dof_composite_states.find(command_buffer_handle);
    if (composite != state->command_buffer_dof_composite_states.end()) {
      composite->second.pipeline = pipeline;
    }
  }
}

VKAPI_ATTR void VKAPI_CALL LegacyLayerCmdBindDescriptorSets(
    VkCommandBuffer command_buffer,
    VkPipelineBindPoint pipeline_bind_point,
    VkPipelineLayout layout,
    std::uint32_t first_set,
    std::uint32_t descriptor_set_count,
    const VkDescriptorSet* descriptor_sets,
    std::uint32_t dynamic_offset_count,
    const std::uint32_t* dynamic_offsets) {
  const bool tracking_enabled =
      runtime_command_tracking_enabled.load(std::memory_order_acquire);
  if (!tracking_enabled
      && fast_command_dispatch_key.load(std::memory_order_acquire)
             == DispatchKey(command_buffer)) {
    const auto trampoline =
        fast_cmd_bind_descriptor_sets.load(std::memory_order_relaxed);
    if (trampoline != nullptr) {
      trampoline(
          command_buffer,
          pipeline_bind_point,
          layout,
          first_set,
          descriptor_set_count,
          descriptor_sets,
          dynamic_offset_count,
          dynamic_offsets);
      return;
    }
  }
  auto* state = FindDeviceFast(command_buffer);
  if (state == nullptr) return;
  const auto trampoline = state->next_cmd_bind_descriptor_sets;
  if (trampoline == nullptr) return;
  trampoline(
      command_buffer,
      pipeline_bind_point,
      layout,
      first_set,
      descriptor_set_count,
      descriptor_sets,
      dynamic_offset_count,
      dynamic_offsets);
  if (pipeline_bind_point != VK_PIPELINE_BIND_POINT_COMPUTE || descriptor_sets == nullptr) return;
  if (!tracking_enabled) return;

  const std::uint64_t command_buffer_handle = ToOpaque(command_buffer);
  auto& local = GetThreadComputeCommandStates()[command_buffer_handle];
  const bool updates_tracked_set = first_set == DETROIT_DLSS_TAA_DESCRIPTOR_SET
                                   && descriptor_set_count != 0u;
  if (!updates_tracked_set) return;

  const bool may_bind_tracked_set =
      MayBeTrackedDescriptorSet(*state, descriptor_sets[0u]);
  if (!may_bind_tracked_set
      && !local.temporal_descriptor_set_bound
      && !local.dof_composite_descriptor_set_bound) {
    return;
  }

  const std::lock_guard lock(state->tracking_mutex);
  const auto descriptor_set =
      state->descriptor_sets.find(ToOpaque(descriptor_sets[0u]));
  const auto descriptor_layout =
      descriptor_set == state->descriptor_sets.end()
          ? state->descriptor_set_layouts.end()
          : state->descriptor_set_layouts.find(
                ToOpaque(descriptor_set->second.layout));
  const auto pipeline_layout =
      state->pipeline_layouts.find(ToOpaque(layout));
  const bool temporal_candidate =
      may_bind_tracked_set
      && descriptor_layout != state->descriptor_set_layouts.end()
      && descriptor_layout->second.temporal_candidate;
  const bool dof_composite_candidate =
      may_bind_tracked_set
      && descriptor_layout != state->descriptor_set_layouts.end()
      && descriptor_layout->second.dof_composite_candidate
      && descriptor_set_count == 1u
      && dynamic_offsets != nullptr && dynamic_offset_count == 1u
      && pipeline_layout != state->pipeline_layouts.end()
      && pipeline_layout->second.set_layouts.size() == 1u
      && pipeline_layout->second.set_layouts[0u]
          == descriptor_set->second.layout
      && HasDofCompositePushConstantRange(pipeline_layout->second);

  if ((temporal_candidate || dof_composite_candidate)
      && !PublishThreadCommandRecordingLocked(
          state, command_buffer_handle, &local)) {
    local.temporal_descriptor_set_bound = false;
    local.dof_composite_descriptor_set_bound = false;
    ErasePublishedCommandBufferStateLocked(
        state, command_buffer_handle);
    return;
  }

  local.dof_composite_descriptor_set_bound = dof_composite_candidate;
  if (dof_composite_candidate) {
    state->command_buffer_dof_composite_states[command_buffer_handle] = {
        .pipeline = local.pipeline,
        .pipeline_layout = layout,
        .descriptor_set = descriptor_sets[0u],
        .dynamic_offset = dynamic_offsets[0u],
        .dynamic_offset_valid = true,
    };
  } else {
    state->command_buffer_dof_composite_states.erase(command_buffer_handle);
  }

  local.temporal_descriptor_set_bound = temporal_candidate;
  if (!temporal_candidate) {
    state->command_buffer_descriptors.erase(command_buffer_handle);
    state->command_buffer_restore_states.erase(command_buffer_handle);
    return;
  }

  auto& restore = state->command_buffer_restore_states[command_buffer_handle];
  restore.pipeline = local.pipeline;
  restore.descriptor_layout = layout;
  restore.first_set = first_set;
  restore.descriptor_sets.assign(descriptor_sets, descriptor_sets + descriptor_set_count);
  restore.dynamic_offsets.clear();
  restore.one_time_submit =
      (local.begin_flags & VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT)
             != 0u;
  if (dynamic_offsets != nullptr && dynamic_offset_count != 0u) {
    restore.dynamic_offsets.assign(dynamic_offsets, dynamic_offsets + dynamic_offset_count);
  }

  std::uint64_t constants_dynamic_offset_index = 0u;
  bool constants_dynamic_offset_valid = false;
  for (const auto& binding : descriptor_layout->second.bindings) {
    if (!IsDynamicBufferDescriptorType(binding.descriptor_type)) continue;
    if (binding.binding == DETROIT_DLSS_TAA_CONSTANT_BINDING_52) {
      constants_dynamic_offset_valid = dynamic_offsets != nullptr
                                       && constants_dynamic_offset_index
                                              < dynamic_offset_count;
      break;
    }
    constants_dynamic_offset_index += binding.descriptor_count;
  }
  const VkDeviceSize constants_dynamic_offset =
      constants_dynamic_offset_valid
          ? dynamic_offsets[static_cast<std::size_t>(constants_dynamic_offset_index)]
          : 0u;

  auto& command = state->command_buffer_descriptors[command_buffer_handle];
  command.clear();
  for (const std::uint32_t binding : kTemporalImageBindings) {
    if (FindLayoutBinding(descriptor_layout->second, binding) == nullptr) continue;
    command[CommandDescriptorKey(DETROIT_DLSS_TAA_DESCRIPTOR_SET, binding)] = {
        descriptor_sets[0u], layout, 0u, true};
  }
  command[CommandDescriptorKey(
      DETROIT_DLSS_TAA_DESCRIPTOR_SET,
      DETROIT_DLSS_TAA_CONSTANT_BINDING_52)] = {
      descriptor_sets[0u],
      layout,
      constants_dynamic_offset,
      constants_dynamic_offset_valid};
}

VKAPI_ATTR void VKAPI_CALL LayerCmdBindDescriptorSets(
    VkCommandBuffer command_buffer,
    VkPipelineBindPoint pipeline_bind_point,
    VkPipelineLayout layout,
    std::uint32_t first_set,
    std::uint32_t descriptor_set_count,
    const VkDescriptorSet* descriptor_sets,
    std::uint32_t dynamic_offset_count,
    const std::uint32_t* dynamic_offsets) {
  PFN_vkCmdBindDescriptorSets trampoline = nullptr;
  if (fast_command_dispatch_key.load(std::memory_order_acquire)
      == DispatchKey(command_buffer)) {
    trampoline =
        fast_cmd_bind_descriptor_sets.load(std::memory_order_relaxed);
  }
  if (trampoline == nullptr) {
    auto* state = FindDeviceFast(command_buffer);
    if (state != nullptr) trampoline = state->next_cmd_bind_descriptor_sets;
  }
  if (trampoline == nullptr) return;
  trampoline(
      command_buffer,
      pipeline_bind_point,
      layout,
      first_set,
      descriptor_set_count,
      descriptor_sets,
      dynamic_offset_count,
      dynamic_offsets);

  if (pipeline_bind_point != VK_PIPELINE_BIND_POINT_COMPUTE
      || first_set != DETROIT_DLSS_TAA_DESCRIPTOR_SET
      || descriptor_set_count == 0u || descriptor_sets == nullptr
      || dynamic_offset_count != 1u || dynamic_offsets == nullptr) {
    return;
  }
  auto& local = GetCurrentThreadComputeCommandState();
  if (!local.recording_active
      || local.command_buffer != ToOpaque(command_buffer)) {
    return;
  }
  local.descriptor_layout = layout;
  local.descriptor_set = descriptor_sets[0u];
  local.constants_dynamic_offset = dynamic_offsets[0u];
  local.descriptor_bound_after_begin = true;
  local.evaluation_claimed = false;
}

[[maybe_unused]] PFN_vkVoidFunction FindLegacyTrackedDeviceFunction(
    const char* name) {
  if (std::strcmp(name, "vkCreateDescriptorSetLayout") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCreateDescriptorSetLayout);
  }
  if (std::strcmp(name, "vkDestroyDescriptorSetLayout") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDestroyDescriptorSetLayout);
  }
  if (std::strcmp(name, "vkCreatePipelineLayout") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCreatePipelineLayout);
  }
  if (std::strcmp(name, "vkDestroyPipelineLayout") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDestroyPipelineLayout);
  }
  if (std::strcmp(name, "vkAllocateDescriptorSets") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerAllocateDescriptorSets);
  }
  if (std::strcmp(name, "vkFreeDescriptorSets") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerFreeDescriptorSets);
  }
  if (std::strcmp(name, "vkResetDescriptorPool") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerResetDescriptorPool);
  }
  if (std::strcmp(name, "vkDestroyDescriptorPool") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDestroyDescriptorPool);
  }
  if (std::strcmp(name, "vkUpdateDescriptorSets") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerUpdateDescriptorSets);
  }
  if (std::strcmp(name, "vkCreateImage") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCreateImage);
  }
  if (std::strcmp(name, "vkDestroyImage") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDestroyImage);
  }
  if (std::strcmp(name, "vkCreateImageView") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCreateImageView);
  }
  if (std::strcmp(name, "vkDestroyImageView") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDestroyImageView);
  }
  if (std::strcmp(name, "vkCreateBuffer") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCreateBuffer);
  }
  if (std::strcmp(name, "vkDestroyBuffer") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDestroyBuffer);
  }
  if (std::strcmp(name, "vkAllocateMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerAllocateMemory);
  }
  if (std::strcmp(name, "vkFreeMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerFreeMemory);
  }
  if (std::strcmp(name, "vkBindBufferMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerBindBufferMemory);
  }
  if (std::strcmp(name, "vkBindBufferMemory2") == 0
      || std::strcmp(name, "vkBindBufferMemory2KHR") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerBindBufferMemory2);
  }
  if (std::strcmp(name, "vkMapMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerMapMemory);
  }
  if (std::strcmp(name, "vkUnmapMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerUnmapMemory);
  }
  if (std::strcmp(name, "vkQueueSubmit") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerQueueSubmit);
  }
#if defined(VK_VERSION_1_3)
  if (std::strcmp(name, "vkQueueSubmit2") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerQueueSubmit2);
  }
#endif
#if defined(VK_KHR_synchronization2)
  if (std::strcmp(name, "vkQueueSubmit2KHR") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerQueueSubmit2KHR);
  }
#endif
  if (std::strcmp(name, "vkQueueWaitIdle") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerQueueWaitIdle);
  }
  if (std::strcmp(name, "vkDeviceWaitIdle") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDeviceWaitIdle);
  }
  if (std::strcmp(name, "vkWaitForFences") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerWaitForFences);
  }
  if (std::strcmp(name, "vkGetFenceStatus") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerGetFenceStatus);
  }
  if (std::strcmp(name, "vkResetFences") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerResetFences);
  }
  if (std::strcmp(name, "vkDestroyFence") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDestroyFence);
  }
  if (std::strcmp(name, "vkBeginCommandBuffer") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerBeginCommandBuffer);
  }
  if (std::strcmp(name, "vkResetCommandBuffer") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerResetCommandBuffer);
  }
  if (std::strcmp(name, "vkCreateCommandPool") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCreateCommandPool);
  }
  if (std::strcmp(name, "vkAllocateCommandBuffers") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerAllocateCommandBuffers);
  }
  if (std::strcmp(name, "vkFreeCommandBuffers") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerFreeCommandBuffers);
  }
  if (std::strcmp(name, "vkResetCommandPool") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerResetCommandPool);
  }
  if (std::strcmp(name, "vkDestroyCommandPool") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerDestroyCommandPool);
  }
  if (native_command_hooks_installed.load(std::memory_order_acquire)
      && std::strcmp(name, "vkCmdBindDescriptorSets") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCmdBindDescriptorSets);
  }
  if (native_command_hooks_installed.load(std::memory_order_acquire)
      && std::strcmp(name, "vkCmdBindPipeline") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCmdBindPipeline);
  }
  return nullptr;
}

PFN_vkVoidFunction FindTrackedDeviceFunction(const char* name) {
  if (!native_command_hooks_installed.load(std::memory_order_acquire)) {
    return nullptr;
  }
  if (std::strcmp(name, "vkBeginCommandBuffer") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerBeginCommandBuffer);
  }
  if (std::strcmp(name, "vkCmdBindDescriptorSets") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCmdBindDescriptorSets);
  }
  if (std::strcmp(name, "vkUpdateDescriptorSets") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(
        &LayerUpdateDynamicConstantBufferDescriptorSets);
  }
  if (std::strcmp(name, "vkCreateDescriptorUpdateTemplate") == 0
      || std::strcmp(name, "vkCreateDescriptorUpdateTemplateKHR") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(
        &LayerCreateDynamicDescriptorUpdateTemplate);
  }
  if (std::strcmp(name, "vkDestroyDescriptorUpdateTemplate") == 0
      || std::strcmp(name, "vkDestroyDescriptorUpdateTemplateKHR") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(
        &LayerDestroyDynamicDescriptorUpdateTemplate);
  }
  if (std::strcmp(name, "vkUpdateDescriptorSetWithTemplate") == 0
      || std::strcmp(name, "vkUpdateDescriptorSetWithTemplateKHR") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(
        &LayerUpdateDynamicDescriptorSetWithTemplate);
  }
  if (std::strcmp(name, "vkBindBufferMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerObserveBindBufferMemory);
  }
  if (std::strcmp(name, "vkBindBufferMemory2") == 0
      || std::strcmp(name, "vkBindBufferMemory2KHR") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerObserveBindBufferMemory2);
  }
  if (std::strcmp(name, "vkMapMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerObserveMapMemory);
  }
  if (std::strcmp(name, "vkUnmapMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerObserveUnmapMemory);
  }
  if (std::strcmp(name, "vkDestroyBuffer") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerObserveDestroyBuffer);
  }
  if (std::strcmp(name, "vkFreeMemory") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerObserveFreeMemory);
  }
  return nullptr;
}

void DETROIT_DLSS_CALL BridgeShutdown() {
  const auto state = GetActiveDevice();
  if (state != nullptr) RequestNgxShutdown(state.get());
}

std::mutex bootstrap_detail_mutex;
std::string bootstrap_detail = "First-run setup";

void SetBootstrapStatus(BootstrapStatus status, std::string detail) {
  const std::lock_guard lock(bootstrap_detail_mutex);
  if (bootstrap_status.load(std::memory_order_relaxed) == status
      && bootstrap_detail == detail) {
    return;
  }
  bootstrap_detail = std::move(detail);
  bootstrap_status.store(status, std::memory_order_release);
  bootstrap_status_revision.fetch_add(1u, std::memory_order_release);
}

std::shared_ptr<InstanceState> EnsureInstanceState(VkInstance instance) {
  if (instance == VK_NULL_HANDLE || reshade_get_instance_proc_addr == nullptr) return nullptr;
  if (const auto existing = FindInstance(instance); existing != nullptr) return existing;
  auto state = std::make_shared<InstanceState>();
  state->instance = instance;
  state->next_get_instance_proc_addr = reshade_get_instance_proc_addr;
  state->ngx_extensions_enabled = false;
  const std::lock_guard lock(state_mutex);
  const auto [iterator, inserted] = instances.emplace(DispatchKey(instance), state);
  return inserted ? state : iterator->second;
}

VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL HookGetDeviceProcAddr(
    VkDevice device, const char* name);
VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL HookGetInstanceProcAddr(
    VkInstance instance, const char* name);

VKAPI_ATTR VkResult VKAPI_CALL HookCreateInstance(
    const VkInstanceCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkInstance* instance) {
  Trace("HookCreateInstance: enter");
  if (create_info == nullptr || instance == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  if (reshade_create_instance == nullptr) return VK_ERROR_INITIALIZATION_FAILED;

  bool ngx_extensions_enabled = false;
  std::vector<std::string> extension_storage;
  std::vector<const char*> enabled_extensions;
  VkInstanceCreateInfo amended_create_info = *create_info;
  if (cached_extensions_ready.load(std::memory_order_acquire)) {
    std::vector<std::string> required;
    ngx_extensions_enabled = ReadCachedNgxExtensions(true, &required)
                             && BuildCachedExtensionList(
                                 create_info->enabledExtensionCount,
                                 create_info->ppEnabledExtensionNames,
                                 required,
                                 &extension_storage,
                                 &enabled_extensions);
    if (ngx_extensions_enabled) {
      amended_create_info.enabledExtensionCount =
          static_cast<std::uint32_t>(enabled_extensions.size());
      amended_create_info.ppEnabledExtensionNames = enabled_extensions.data();
    }
    Trace(ngx_extensions_enabled ? "HookCreateInstance: NGX extensions appended"
                                 : "HookCreateInstance: invalid cache; native fallback");
  }

  loaded_early.store(true, std::memory_order_release);
  const VkResult result = reshade_create_instance(&amended_create_info, allocator, instance);
  if (result == VK_SUCCESS) {
    auto state = std::make_shared<InstanceState>();
    state->instance = *instance;
    state->next_get_instance_proc_addr = reshade_get_instance_proc_addr;
    state->ngx_extensions_enabled = ngx_extensions_enabled;
    const std::lock_guard lock(state_mutex);
    instances[DispatchKey(*instance)] = std::move(state);
  }
  return result;
}

VKAPI_ATTR void VKAPI_CALL HookDestroyInstance(
    VkInstance instance,
    const VkAllocationCallbacks* allocator) {
  const auto state = FindInstance(instance);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkDestroyInstance>(
      state->next_get_instance_proc_addr(instance, "vkDestroyInstance"));
  {
    const std::lock_guard lock(state_mutex);
    instances.erase(DispatchKey(instance));
  }
  if (trampoline != nullptr) trampoline(instance, allocator);
}

VKAPI_ATTR VkResult VKAPI_CALL HookCreateDevice(
    VkPhysicalDevice physical_device,
    const VkDeviceCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkDevice* device) {
  Trace("HookCreateDevice: enter");
  if (create_info == nullptr || device == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto instance_state = FindInstance(physical_device);
  if (instance_state == nullptr || reshade_create_device == nullptr
      || reshade_get_instance_proc_addr == nullptr || reshade_get_device_proc_addr == nullptr) {
    Trace("HookCreateDevice: bootstrap state unavailable");
    return reshade_create_device != nullptr
               ? reshade_create_device(physical_device, create_info, allocator, device)
               : VK_ERROR_INITIALIZATION_FAILED;
  }

  bool ngx_extensions_enabled = false;
  std::vector<std::string> extension_storage;
  std::vector<const char*> enabled_extensions;
  VkDeviceCreateInfo amended_create_info = *create_info;
  if (instance_state->ngx_extensions_enabled) {
    std::vector<std::string> required;
    ngx_extensions_enabled = ReadCachedNgxExtensions(false, &required)
                             && PhysicalDeviceSupportsRequiredExtensions(
                                 reshade_get_instance_proc_addr,
                                 instance_state->instance,
                                 physical_device,
                                 required)
                             && BuildCachedExtensionList(
                                 create_info->enabledExtensionCount,
                                 create_info->ppEnabledExtensionNames,
                                 required,
                                 &extension_storage,
                                 &enabled_extensions);
    if (ngx_extensions_enabled) {
      amended_create_info.enabledExtensionCount =
          static_cast<std::uint32_t>(enabled_extensions.size());
      amended_create_info.ppEnabledExtensionNames = enabled_extensions.data();
    }
    Trace(ngx_extensions_enabled
              ? "vkCreateDevice: NGX device extensions appended"
              : "vkCreateDevice: NGX device extensions unavailable; native fallback");
  }

  const VkResult result =
      reshade_create_device(physical_device, &amended_create_info, allocator, device);
  if (result != VK_SUCCESS) return result;

  auto state = std::make_shared<DeviceState>();
  state->instance = instance_state->instance;
  state->physical_device = physical_device;
  state->device = *device;
  state->next_get_instance_proc_addr = reshade_get_instance_proc_addr;
  state->next_get_device_proc_addr = reshade_get_device_proc_addr;
  state->next_update_descriptor_sets =
      reinterpret_cast<PFN_vkUpdateDescriptorSets>(
          reshade_get_device_proc_addr(*device, "vkUpdateDescriptorSets"));
  state->next_create_descriptor_update_template =
      reinterpret_cast<PFN_vkCreateDescriptorUpdateTemplate>(
          reshade_get_device_proc_addr(
              *device, "vkCreateDescriptorUpdateTemplate"));
  if (state->next_create_descriptor_update_template == nullptr) {
    state->next_create_descriptor_update_template =
        reinterpret_cast<PFN_vkCreateDescriptorUpdateTemplate>(
            reshade_get_device_proc_addr(
                *device, "vkCreateDescriptorUpdateTemplateKHR"));
  }
  state->next_destroy_descriptor_update_template =
      reinterpret_cast<PFN_vkDestroyDescriptorUpdateTemplate>(
          reshade_get_device_proc_addr(
              *device, "vkDestroyDescriptorUpdateTemplate"));
  if (state->next_destroy_descriptor_update_template == nullptr) {
    state->next_destroy_descriptor_update_template =
        reinterpret_cast<PFN_vkDestroyDescriptorUpdateTemplate>(
            reshade_get_device_proc_addr(
                *device, "vkDestroyDescriptorUpdateTemplateKHR"));
  }
  state->next_update_descriptor_set_with_template =
      reinterpret_cast<PFN_vkUpdateDescriptorSetWithTemplate>(
          reshade_get_device_proc_addr(
              *device, "vkUpdateDescriptorSetWithTemplate"));
  if (state->next_update_descriptor_set_with_template == nullptr) {
    state->next_update_descriptor_set_with_template =
        reinterpret_cast<PFN_vkUpdateDescriptorSetWithTemplate>(
            reshade_get_device_proc_addr(
                *device, "vkUpdateDescriptorSetWithTemplateKHR"));
  }
  state->next_bind_buffer_memory = reinterpret_cast<PFN_vkBindBufferMemory>(
      reshade_get_device_proc_addr(*device, "vkBindBufferMemory"));
  state->next_bind_buffer_memory2 = reinterpret_cast<PFN_vkBindBufferMemory2>(
      reshade_get_device_proc_addr(*device, "vkBindBufferMemory2"));
  if (state->next_bind_buffer_memory2 == nullptr) {
    state->next_bind_buffer_memory2 =
        reinterpret_cast<PFN_vkBindBufferMemory2>(
            reshade_get_device_proc_addr(*device, "vkBindBufferMemory2KHR"));
  }
  state->next_destroy_buffer = reinterpret_cast<PFN_vkDestroyBuffer>(
      reshade_get_device_proc_addr(*device, "vkDestroyBuffer"));
  state->next_free_memory = reinterpret_cast<PFN_vkFreeMemory>(
      reshade_get_device_proc_addr(*device, "vkFreeMemory"));
  state->next_map_memory = reinterpret_cast<PFN_vkMapMemory>(
      reshade_get_device_proc_addr(*device, "vkMapMemory"));
  state->next_unmap_memory = reinterpret_cast<PFN_vkUnmapMemory>(
      reshade_get_device_proc_addr(*device, "vkUnmapMemory"));
  state->next_begin_command_buffer =
      reinterpret_cast<PFN_vkBeginCommandBuffer>(
          reshade_get_device_proc_addr(*device, "vkBeginCommandBuffer"));
  state->next_end_command_buffer = reinterpret_cast<PFN_vkEndCommandBuffer>(
      reshade_get_device_proc_addr(*device, "vkEndCommandBuffer"));
  state->next_reset_command_buffer =
      reinterpret_cast<PFN_vkResetCommandBuffer>(
          reshade_get_device_proc_addr(*device, "vkResetCommandBuffer"));
  state->next_queue_submit = reinterpret_cast<PFN_vkQueueSubmit>(
      reshade_get_device_proc_addr(*device, "vkQueueSubmit"));
#if defined(VK_VERSION_1_3)
  state->next_queue_submit2 = reinterpret_cast<PFN_vkQueueSubmit2>(
      reshade_get_device_proc_addr(*device, "vkQueueSubmit2"));
#endif
#if defined(VK_KHR_synchronization2)
  state->next_queue_submit2_khr = reinterpret_cast<PFN_vkQueueSubmit2KHR>(
      reshade_get_device_proc_addr(*device, "vkQueueSubmit2KHR"));
#endif
  state->next_queue_wait_idle = reinterpret_cast<PFN_vkQueueWaitIdle>(
      reshade_get_device_proc_addr(*device, "vkQueueWaitIdle"));
  state->next_device_wait_idle = reinterpret_cast<PFN_vkDeviceWaitIdle>(
      reshade_get_device_proc_addr(*device, "vkDeviceWaitIdle"));
  state->next_wait_for_fences = reinterpret_cast<PFN_vkWaitForFences>(
      reshade_get_device_proc_addr(*device, "vkWaitForFences"));
  state->next_get_fence_status = reinterpret_cast<PFN_vkGetFenceStatus>(
      reshade_get_device_proc_addr(*device, "vkGetFenceStatus"));
  state->next_reset_fences = reinterpret_cast<PFN_vkResetFences>(
      reshade_get_device_proc_addr(*device, "vkResetFences"));
  state->next_create_fence = reinterpret_cast<PFN_vkCreateFence>(
      reshade_get_device_proc_addr(*device, "vkCreateFence"));
  state->next_destroy_fence = reinterpret_cast<PFN_vkDestroyFence>(
      reshade_get_device_proc_addr(*device, "vkDestroyFence"));
  state->next_cmd_pipeline_barrier = reinterpret_cast<PFN_vkCmdPipelineBarrier>(
      reshade_get_device_proc_addr(*device, "vkCmdPipelineBarrier"));
  state->next_create_command_pool = reinterpret_cast<PFN_vkCreateCommandPool>(
      reshade_get_device_proc_addr(*device, "vkCreateCommandPool"));
  state->next_allocate_command_buffers =
      reinterpret_cast<PFN_vkAllocateCommandBuffers>(
          reshade_get_device_proc_addr(*device, "vkAllocateCommandBuffers"));
  state->next_free_command_buffers =
      reinterpret_cast<PFN_vkFreeCommandBuffers>(
          reshade_get_device_proc_addr(*device, "vkFreeCommandBuffers"));
  state->next_reset_command_pool =
      reinterpret_cast<PFN_vkResetCommandPool>(
          reshade_get_device_proc_addr(*device, "vkResetCommandPool"));
  state->next_destroy_command_pool =
      reinterpret_cast<PFN_vkDestroyCommandPool>(
          reshade_get_device_proc_addr(*device, "vkDestroyCommandPool"));
  state->next_cmd_bind_pipeline = reinterpret_cast<PFN_vkCmdBindPipeline>(
      reshade_get_device_proc_addr(*device, "vkCmdBindPipeline"));
  state->next_cmd_bind_descriptor_sets =
      reinterpret_cast<PFN_vkCmdBindDescriptorSets>(
          reshade_get_device_proc_addr(*device, "vkCmdBindDescriptorSets"));
  state->next_cmd_push_constants = reinterpret_cast<PFN_vkCmdPushConstants>(
      reshade_get_device_proc_addr(*device, "vkCmdPushConstants"));
  state->supported_executable = executable_verified.load(std::memory_order_acquire);
  state->ngx_extensions_enabled = ngx_extensions_enabled;
  state->identity = next_device_identity.fetch_add(1u, std::memory_order_relaxed);

  const auto get_memory_properties =
      reinterpret_cast<PFN_vkGetPhysicalDeviceMemoryProperties>(
          reshade_get_instance_proc_addr(
              instance_state->instance, "vkGetPhysicalDeviceMemoryProperties"));
  if (get_memory_properties != nullptr) {
    Trace("vkCreateDevice: query memory properties");
    get_memory_properties(physical_device, &state->memory_properties);
  }

  const auto get_physical_device_properties =
      reinterpret_cast<PFN_vkGetPhysicalDeviceProperties>(
          reshade_get_instance_proc_addr(
              instance_state->instance, "vkGetPhysicalDeviceProperties"));
  if (get_physical_device_properties != nullptr) {
    VkPhysicalDeviceProperties properties = {};
    get_physical_device_properties(physical_device, &properties);
    state->min_uniform_buffer_offset_alignment = std::max<VkDeviceSize>(
        properties.limits.minUniformBufferOffsetAlignment, 1u);
  }

  const auto get_queue_family_properties =
      reinterpret_cast<PFN_vkGetPhysicalDeviceQueueFamilyProperties>(
          reshade_get_instance_proc_addr(
              instance_state->instance, "vkGetPhysicalDeviceQueueFamilyProperties"));
  if (get_queue_family_properties != nullptr) {
    Trace("vkCreateDevice: query queue families");
    std::uint32_t family_count = 0u;
    get_queue_family_properties(physical_device, &family_count, nullptr);
    std::vector<VkQueueFamilyProperties> families(family_count);
    get_queue_family_properties(physical_device, &family_count, families.data());
    for (std::uint32_t index = 0u; index < create_info->queueCreateInfoCount; ++index) {
      const auto& queue = create_info->pQueueCreateInfos[index];
      if (queue.queueCount != 0u && queue.queueFamilyIndex < families.size()
          && (families[queue.queueFamilyIndex].queueFlags & VK_QUEUE_GRAPHICS_BIT) != 0u) {
        state->graphics_queue_family = queue.queueFamilyIndex;
        break;
      }
    }
  }

  if (state->graphics_queue_family != std::numeric_limits<std::uint32_t>::max()) {
    Trace("vkCreateDevice: resolve graphics queue");
    const auto get_device_queue = reinterpret_cast<PFN_vkGetDeviceQueue>(
        reshade_get_device_proc_addr(*device, "vkGetDeviceQueue"));
    if (get_device_queue != nullptr) {
      get_device_queue(
          *device,
          state->graphics_queue_family,
          state->graphics_queue_index,
          &state->graphics_queue);
    }
  }

  const auto adapter_result = state->adapter_runtime.Initialize({
      .instance = state->instance,
      .physical_device = state->physical_device,
      .device = state->device,
      .get_instance_proc_addr = state->next_get_instance_proc_addr,
      .get_device_proc_addr = state->next_get_device_proc_addr,
      .memory_properties = state->memory_properties,
      .maximum_scratch_bundles = static_cast<std::uint32_t>(
          kMaximumAdapterScratchBundles),
  });
  state->adapter_available = adapter_result.Succeeded();
  Trace(state->adapter_available
            ? "vkCreateDevice: DLSS format adapter initialized"
            : "vkCreateDevice: DLSS format adapter unavailable; native fallback");

  bool installed_as_fast_device = false;
  const auto device_dispatch_key = DispatchKey(*device);
  {
    const std::lock_guard lock(state_mutex);
    devices[device_dispatch_key] = state;
    if (state->graphics_queue != VK_NULL_HANDLE && active_device.expired()) {
      active_device = state;
      active_device_identity.store(state->identity, std::memory_order_release);
      installed_as_fast_device = true;
    }
    device_registry_generation.fetch_add(1u, std::memory_order_release);
  }
  if (installed_as_fast_device) {
    fast_begin_command_buffer.store(
        state->next_begin_command_buffer, std::memory_order_relaxed);
    fast_update_descriptor_sets.store(
        state->next_update_descriptor_sets, std::memory_order_relaxed);
    fast_cmd_bind_descriptor_sets.store(
        state->next_cmd_bind_descriptor_sets, std::memory_order_relaxed);
    fast_command_dispatch_key.store(
        device_dispatch_key, std::memory_order_release);
  }
  Trace("vkCreateDevice: state installed; return success");
  return VK_SUCCESS;
}

VKAPI_ATTR void VKAPI_CALL HookDestroyDevice(
    VkDevice device,
    const VkAllocationCallbacks* allocator) {
  Trace("vkDestroyDevice: enter");
  const auto state = FindDevice(device);
  PFN_vkDestroyDevice trampoline = nullptr;
  if (state != nullptr && state->next_get_device_proc_addr != nullptr) {
    trampoline = reinterpret_cast<PFN_vkDestroyDevice>(
        state->next_get_device_proc_addr(device, "vkDestroyDevice"));
  }
  if (trampoline == nullptr && reshade_get_device_proc_addr != nullptr) {
    trampoline = reinterpret_cast<PFN_vkDestroyDevice>(
        reshade_get_device_proc_addr(device, "vkDestroyDevice"));
  }
  if (state == nullptr) {
    if (trampoline != nullptr
        && trampoline != reinterpret_cast<PFN_vkDestroyDevice>(
                             &HookDestroyDevice)) {
      trampoline(device, allocator);
      Trace("vkDestroyDevice: untracked device forwarded");
    } else {
      Trace("vkDestroyDevice: untracked device downstream unavailable");
    }
    return;
  }
  if (trampoline == nullptr
      || trampoline
          == reinterpret_cast<PFN_vkDestroyDevice>(&HookDestroyDevice)) {
    Trace("vkDestroyDevice: downstream destroy unavailable; cleanup skipped");
    return;
  }
  state->destroying.store(true, std::memory_order_release);
  const auto device_dispatch_key = DispatchKey(device);
  auto expected_fast_key = device_dispatch_key;
  if (fast_command_dispatch_key.compare_exchange_strong(
          expected_fast_key,
          0u,
          std::memory_order_acq_rel,
          std::memory_order_acquire)) {
    fast_begin_command_buffer.store(nullptr, std::memory_order_relaxed);
    fast_update_descriptor_sets.store(nullptr, std::memory_order_relaxed);
    fast_cmd_bind_descriptor_sets.store(nullptr, std::memory_order_relaxed);
  }
  {
    const std::lock_guard lock(state_mutex);
    if (active_device.lock() == state) {
      active_device.reset();
      active_device_identity.store(0u, std::memory_order_release);
    }
    devices.erase(DispatchKey(device));
    device_registry_generation.fetch_add(1u, std::memory_order_release);
  }
  // Vulkan requires the application to finish every submitted command before
  // vkDestroyDevice. Do not add a second device-idle wait at this terminal
  // boundary: it is redundant for a valid application and was able to strand
  // Detroit's shutdown thread inside the NVIDIA driver after Alt+F4.
  Trace("vkDestroyDevice: NGX cleanup begin");
  ForceShutdownNgxForDeviceDestroy(state.get());
  Trace("vkDestroyDevice: NGX cleanup complete");
  Trace("vkDestroyDevice: adapter cleanup begin");
  state->adapter_runtime.Shutdown(false);
  Trace("vkDestroyDevice: adapter cleanup complete");
  state->adapter_available = false;
  Trace("vkDestroyDevice: forwarding terminal destroy");
  trampoline(device, allocator);
  Trace("vkDestroyDevice: complete");
  CloseTraceFile();
}

VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL HookGetDeviceProcAddr(
    VkDevice device, const char* name) {
  if (name == nullptr) return nullptr;
  if (std::strcmp(name, "vkGetDeviceProcAddr") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookGetDeviceProcAddr);
  }
  if (reshade_get_device_proc_addr == nullptr) return nullptr;
  const auto downstream = reshade_get_device_proc_addr(device, name);
  if (device == VK_NULL_HANDLE) return downstream;
  const auto state = FindDevice(device);
  if (state == nullptr) return downstream;
  if (downstream == nullptr) return nullptr;
  if (std::strcmp(name, "vkDestroyDevice") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookDestroyDevice);
  }
  if (const auto tracked = FindTrackedDeviceFunction(name); tracked != nullptr) return tracked;
  return downstream;
}

VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL HookGetInstanceProcAddr(
    VkInstance instance, const char* name) {
  if (name == nullptr) return nullptr;
  if (std::strcmp(name, "vkGetInstanceProcAddr") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookGetInstanceProcAddr);
  }
  if (std::strcmp(name, "vkGetDeviceProcAddr") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookGetDeviceProcAddr);
  }
  if (std::strcmp(name, "vkCreateInstance") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookCreateInstance);
  }
  if (reshade_get_instance_proc_addr == nullptr) return nullptr;
  const auto downstream = reshade_get_instance_proc_addr(instance, name);
  if (std::strcmp(name, "vkCreateDevice") == 0 && downstream != nullptr) {
    reshade_create_device = reinterpret_cast<PFN_vkCreateDevice>(downstream);
    (void)EnsureInstanceState(instance);
    return reinterpret_cast<PFN_vkVoidFunction>(&HookCreateDevice);
  }
  if (instance == VK_NULL_HANDLE) return downstream;
  const auto state = EnsureInstanceState(instance);
  if (state == nullptr) return downstream;
  if (downstream == nullptr) return nullptr;
  if (std::strcmp(name, "vkDestroyInstance") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookDestroyInstance);
  }
  if (std::strcmp(name, "vkDestroyDevice") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&HookDestroyDevice);
  }
  if (const auto tracked = FindTrackedDeviceFunction(name); tracked != nullptr) return tracked;
  return downstream;
}

bool SerializeExtensions(
    const VkExtensionProperties* properties,
    std::uint32_t count,
    std::string* serialized) {
  if (serialized == nullptr || (count != 0u && properties == nullptr)
      || count > kMaximumCachedExtensionCount) {
    return false;
  }
  serialized->clear();
  std::vector<std::string_view> seen;
  for (std::uint32_t index = 0u; index < count; ++index) {
    const std::string_view name(properties[index].extensionName);
    if (name.empty() || name.size() >= VK_MAX_EXTENSION_NAME_SIZE
        || name.find(';') != std::string_view::npos) return false;
    if (std::find(seen.begin(), seen.end(), name) != seen.end()) continue;
    if (!serialized->empty()) serialized->push_back(';');
    serialized->append(name);
    seen.push_back(name);
  }
  return serialized->size() < kMaximumCachedExtensionListBytes;
}

}  // namespace

namespace renodx::games::detroitbecomehuman::dlss::embedded {

void SetRuntimeCommandTracking(bool enabled) {
  runtime_command_tracking_enabled.store(enabled, std::memory_order_release);
}

bool GetCommandRecordingMetadata(
    std::uint64_t command_buffer,
    std::uint64_t pipeline_layout,
    std::uint64_t descriptor_set,
    CommandRecordingMetadata* metadata) {
  return ReadCommandRecordingMetadata(
      command_buffer,
      pipeline_layout,
      descriptor_set,
      false,
      metadata);
}

bool GetCurrentDynamicConstantBufferBinding(
    std::uint64_t device,
    std::uint64_t descriptor_set,
    DynamicConstantBufferBinding* binding) {
  if (binding == nullptr) return false;
  *binding = {};
  const auto& current = GetCurrentDynamicDescriptorUpdateScope();
  if (device == 0u || descriptor_set == 0u
      || ToOpaque(current.device) != device) {
    return false;
  }

  bool found = false;
  if (current.writes != nullptr) {
    for (std::uint32_t index = 0u; index < current.write_count; ++index) {
      const auto& write = current.writes[index];
      if (ToOpaque(write.dstSet) != descriptor_set
          || write.dstBinding != DETROIT_DLSS_TAA_CONSTANT_BINDING_52
          || write.dstArrayElement != 0u || write.descriptorCount != 1u
          || write.descriptorType != VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC
          || write.pBufferInfo == nullptr
          || write.pBufferInfo[0u].buffer == VK_NULL_HANDLE) {
        continue;
      }
      *binding = {
          .buffer = ToOpaque(write.pBufferInfo[0u].buffer),
          .offset = write.pBufferInfo[0u].offset,
          .range = write.pBufferInfo[0u].range,
          .descriptor_type = static_cast<std::uint32_t>(write.descriptorType),
      };
      found = true;
    }
  }
  if (current.template_data != nullptr
      && current.descriptor_update_template != VK_NULL_HANDLE
      && ToOpaque(current.template_descriptor_set) == descriptor_set) {
    const auto state = FindDeviceSharedFast(current.device);
    if (state != nullptr) {
      const std::shared_lock lock(state->descriptor_template_mutex);
      const auto entry = state->dynamic_descriptor_templates.find(
          ToOpaque(current.descriptor_update_template));
      if (entry != state->dynamic_descriptor_templates.end()) {
        VkDescriptorBufferInfo buffer_info = {};
        std::memcpy(
            &buffer_info,
            static_cast<const std::uint8_t*>(current.template_data)
                + entry->second.offset,
            sizeof(buffer_info));
        if (buffer_info.buffer != VK_NULL_HANDLE) {
          *binding = {
              .buffer = ToOpaque(buffer_info.buffer),
              .offset = buffer_info.offset,
              .range = buffer_info.range,
              .descriptor_type = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC,
          };
          found = true;
        }
      }
    }
  }
  return found;
}

bool ReadPersistentlyMappedBufferRange(
    std::uint64_t device,
    std::uint64_t buffer,
    std::uint64_t offset,
    std::uint64_t size,
    void* destination,
    MappedBufferReadDiagnostics* diagnostics) {
  if (diagnostics != nullptr) *diagnostics = {};
  const auto fail = [diagnostics](MappedBufferReadDetail detail) {
    if (diagnostics != nullptr) diagnostics->detail = detail;
    return false;
  };
  if (device == 0u || buffer == 0u || size == 0u || destination == nullptr) {
    return fail(MappedBufferReadDetail::kInvalidArgument);
  }
  const auto state = FindDeviceSharedFast(FromOpaque<VkDevice>(device));
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)) {
    return fail(MappedBufferReadDetail::kDeviceUnavailable);
  }

  const std::shared_lock lock(state->mapped_buffer_mutex);
  if (diagnostics != nullptr) {
    diagnostics->tracked_buffer_count = state->narrow_buffer_bindings.size();
    diagnostics->tracked_memory_count = state->narrow_mapped_memories.size();
  }
  const auto binding = state->narrow_buffer_bindings.find(buffer);
  if (binding == state->narrow_buffer_bindings.end()
      || binding->second.memory == VK_NULL_HANDLE) {
    return fail(MappedBufferReadDetail::kBufferBindingMissing);
  }
  if (diagnostics != nullptr) {
    diagnostics->memory = ToOpaque(binding->second.memory);
    diagnostics->binding_offset = binding->second.offset;
  }
  const auto mapped = state->narrow_mapped_memories.find(
      ToOpaque(binding->second.memory));
  if (mapped == state->narrow_mapped_memories.end()) {
    return fail(MappedBufferReadDetail::kMappedMemoryMissing);
  }
  if (diagnostics != nullptr) {
    diagnostics->mapped_offset = mapped->second.offset;
    diagnostics->mapped_size = mapped->second.size;
  }
  if (mapped->second.pointer == nullptr) {
    return fail(MappedBufferReadDetail::kMappedPointerMissing);
  }

  std::uint64_t absolute_offset = 0u;
  if (!AddWithoutOverflow(binding->second.offset, offset, &absolute_offset)) {
    return fail(MappedBufferReadDetail::kOffsetOverflow);
  }
  if (diagnostics != nullptr) diagnostics->absolute_offset = absolute_offset;
  if (absolute_offset < mapped->second.offset) {
    return fail(MappedBufferReadDetail::kBeforeMappedRange);
  }
  const std::uint64_t relative_offset =
      absolute_offset - mapped->second.offset;
  if (diagnostics != nullptr) diagnostics->relative_offset = relative_offset;
  if (mapped->second.size != VK_WHOLE_SIZE
      && (relative_offset > mapped->second.size
          || size > mapped->second.size - relative_offset)) {
    return fail(MappedBufferReadDetail::kMappedRangeExceeded);
  }
  if (relative_offset > std::numeric_limits<std::size_t>::max()
      || size > std::numeric_limits<std::size_t>::max()) {
    return fail(MappedBufferReadDetail::kAddressRangeUnsupported);
  }
  std::memcpy(
      destination,
      static_cast<const std::uint8_t*>(mapped->second.pointer)
          + static_cast<std::size_t>(relative_offset),
      static_cast<std::size_t>(size));
  if (diagnostics != nullptr) {
    diagnostics->detail = MappedBufferReadDetail::kSuccess;
  }
  return true;
}

bool ClaimCommandRecordingEvaluation(
    std::uint64_t command_buffer,
    std::uint64_t pipeline_layout,
    std::uint64_t descriptor_set,
    CommandRecordingMetadata* metadata) {
  return ReadCommandRecordingMetadata(
      command_buffer,
      pipeline_layout,
      descriptor_set,
      true,
      metadata);
}

void RecycleFeatureCommandBuffer(std::uint64_t command_buffer) {
  if (command_buffer == 0u) return;
  const auto native = FromOpaque<VkCommandBuffer>(command_buffer);
  const auto state = FindDeviceSharedFast(native);
  if (state == nullptr || !MayBeFeatureRecordingCandidate(*state, native)) {
    return;
  }
  const std::lock_guard lock(state->mutex);
  state->adapter_runtime.RecycleCommandBuffer(native);
  if (state->ngx_context != nullptr) {
    state->ngx_context->DiscardRecording(command_buffer);
  }
  (void)state->submission_trace_tracker.Discard(command_buffer);
  UnmarkFeatureRecordingCandidateLocked(state.get(), command_buffer);
  UpdateFeatureTrackingStateLocked(state.get());
}

void RetireFeatureCommandBuffer(std::uint64_t command_buffer) {
  if (command_buffer == 0u) return;
  const auto native = FromOpaque<VkCommandBuffer>(command_buffer);
  const auto state = FindDeviceSharedFast(native);
  if (state == nullptr || !MayBeFeatureRecordingCandidate(*state, native)) {
    return;
  }
  const std::lock_guard lock(state->mutex);
  (void)state->adapter_runtime.RetireCommandBuffer(native);
  if (state->ngx_context != nullptr) {
    state->ngx_context->DiscardRecording(command_buffer);
  }
  (void)state->submission_trace_tracker.Discard(command_buffer);
  UnmarkFeatureRecordingCandidateLocked(state.get(), command_buffer);
  UpdateFeatureTrackingStateLocked(state.get());
}

bool AttachEarlyHooks(
    HMODULE addon_module,
    const ExtensionCache& cache,
    bool install_native_command_hooks) {
  layer_module = addon_module;
  const bool runtime_hooks_enabled = install_native_command_hooks;
  native_command_hooks_installed.store(
      runtime_hooks_enabled, std::memory_order_release);
  Trace(runtime_hooks_enabled
            ? "DLAA-only Vulkan begin/b52 hooks installed"
            : "Targeted Vulkan command hooks disabled");
  if (hooks_attached.load(std::memory_order_acquire)) return true;
  const bool cache_valid = CanAttachEarlyHooks(cache);
  {
    const std::lock_guard lock(bootstrap_mutex);
    cached_extensions_ready.store(cache_valid, std::memory_order_release);
    cached_instance_extensions = cache_valid ? cache.instance_extensions : std::string();
    cached_device_extensions = cache_valid ? cache.device_extensions : std::string();
  }
  if (!cache_valid) {
    SetBootstrapStatus(BootstrapStatus::kFirstRunSetup, "First-run setup");
    return false;
  }

  const HMODULE reshade = GetModuleHandleW(L"ReShade64.dll");
  if (reshade == nullptr) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "ReShade64.dll is not loaded");
    return false;
  }
  reshade_create_instance = reinterpret_cast<PFN_vkCreateInstance>(
      GetProcAddress(reshade, "vkCreateInstance"));
  reshade_get_instance_proc_addr = reinterpret_cast<PFN_vkGetInstanceProcAddr>(
      GetProcAddress(reshade, "vkGetInstanceProcAddr"));
  reshade_get_device_proc_addr = reinterpret_cast<PFN_vkGetDeviceProcAddr>(
      GetProcAddress(reshade, "vkGetDeviceProcAddr"));
  if (reshade_create_instance == nullptr || reshade_get_instance_proc_addr == nullptr
      || reshade_get_device_proc_addr == nullptr) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "ReShade Vulkan exports are missing");
    return false;
  }

  if (DetourTransactionBegin() != NO_ERROR
      || DetourUpdateThread(GetCurrentThread()) != NO_ERROR
      || DetourAttach(
             reinterpret_cast<PVOID*>(&reshade_create_instance),
             reinterpret_cast<PVOID>(&HookCreateInstance))
             != NO_ERROR
      || DetourAttach(
             reinterpret_cast<PVOID*>(&reshade_get_instance_proc_addr),
             reinterpret_cast<PVOID>(&HookGetInstanceProcAddr))
             != NO_ERROR
      || DetourAttach(
             reinterpret_cast<PVOID*>(&reshade_get_device_proc_addr),
             reinterpret_cast<PVOID>(&HookGetDeviceProcAddr))
             != NO_ERROR
      || DetourTransactionCommit() != NO_ERROR) {
    (void)DetourTransactionAbort();
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "Failed to attach ReShade Vulkan hooks");
    return false;
  }
  hooks_attached.store(true, std::memory_order_release);
  SetBootstrapStatus(
      cache_valid ? BootstrapStatus::kEarlyHookActive : BootstrapStatus::kFirstRunSetup,
      cache_valid ? "Early hook active" : "First-run setup");
  return true;
}

void DetachEarlyHooks(bool process_terminating) {
  if (!process_terminating || !hooks_attached.exchange(false)) return;
  if (DetourTransactionBegin() != NO_ERROR) return;
  (void)DetourUpdateThread(GetCurrentThread());
  (void)DetourDetach(
      reinterpret_cast<PVOID*>(&reshade_create_instance),
      reinterpret_cast<PVOID>(&HookCreateInstance));
  (void)DetourDetach(
      reinterpret_cast<PVOID*>(&reshade_get_instance_proc_addr),
      reinterpret_cast<PVOID>(&HookGetInstanceProcAddr));
  (void)DetourDetach(
      reinterpret_cast<PVOID*>(&reshade_get_device_proc_addr),
      reinterpret_cast<PVOID>(&HookGetDeviceProcAddr));
  (void)DetourTransactionCommit();
}

bool VerifySupportedExecutable() {
  const bool supported = IsSupportedHostExecutable();
  executable_verified.store(supported, std::memory_order_release);
  {
    const std::lock_guard lock(state_mutex);
    for (const auto& [_, state] : devices) state->supported_executable = supported;
  }
  if (!supported) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "Unsupported Detroit executable");
  }
  return supported;
}

bool QueryRequiredExtensions(ExtensionCache* cache) {
  if (cache == nullptr || !VerifySupportedExecutable()) return false;
  const auto state = GetActiveDevice();
  if (state == nullptr || state->instance == VK_NULL_HANDLE
      || state->physical_device == VK_NULL_HANDLE) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "Vulkan device is not available");
    return false;
  }

  NgxDiscovery discovery;
  std::uint32_t instance_count = 0u;
  VkExtensionProperties* instance_properties = nullptr;
  if (NVSDK_NGX_FAILED(NVSDK_NGX_VULKAN_GetFeatureInstanceExtensionRequirements(
          &discovery.discovery_info, &instance_count, &instance_properties))
      || (instance_count != 0u && instance_properties == nullptr)) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "NGX instance requirements failed");
    return false;
  }
  NVSDK_NGX_FeatureRequirement requirements = {};
  if (NVSDK_NGX_FAILED(NVSDK_NGX_VULKAN_GetFeatureRequirements(
          state->instance, state->physical_device, &discovery.discovery_info, &requirements))
      || requirements.FeatureSupported != NVSDK_NGX_FeatureSupportResult_Supported) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "DLSS is unsupported on this GPU");
    return false;
  }
  std::uint32_t device_count = 0u;
  VkExtensionProperties* device_properties = nullptr;
  if (NVSDK_NGX_FAILED(NVSDK_NGX_VULKAN_GetFeatureDeviceExtensionRequirements(
          state->instance,
          state->physical_device,
          &discovery.discovery_info,
          &device_count,
          &device_properties))
      || (device_count != 0u && device_properties == nullptr)) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "NGX device requirements failed");
    return false;
  }
  std::vector<std::string> required_device_extensions;
  required_device_extensions.reserve(device_count);
  for (std::uint32_t index = 0u; index < device_count; ++index) {
    required_device_extensions.emplace_back(device_properties[index].extensionName);
  }
  if (!PhysicalDeviceSupportsRequiredExtensions(
          state->next_get_instance_proc_addr,
          state->instance,
          state->physical_device,
          required_device_extensions)
      || !SerializeExtensions(instance_properties, instance_count, &cache->instance_extensions)
      || !SerializeExtensions(device_properties, device_count, &cache->device_extensions)) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "Required Vulkan extensions are unavailable");
    return false;
  }
  cache->schema_version = kCacheSchemaVersion;
  cache->executable_sha256 = std::string(kSupportedExecutableSha256);
  cache->ready = true;
  SetBootstrapStatus(BootstrapStatus::kRestartRequired, "Restart required");
  return true;
}

void RefreshDeferredStatus() {
  if (!VerifySupportedExecutable()) return;
  const auto state = GetActiveDevice();
  if (state == nullptr) {
    SetBootstrapStatus(BootstrapStatus::kFirstRunSetup, "Waiting for Vulkan device");
  } else if (!loaded_early.load(std::memory_order_acquire)) {
    SetBootstrapStatus(BootstrapStatus::kRestartRequired, "Restart required");
  } else if (!state->ngx_extensions_enabled) {
    SetBootstrapStatus(BootstrapStatus::kNativeFallback, "NGX extension cache was not applied");
  } else {
    SetBootstrapStatus(BootstrapStatus::kEarlyHookActive, "Early hook active; checking NGX");
  }
}

void SetNativeFallback(const char* reason) {
  SetBootstrapStatus(
      BootstrapStatus::kNativeFallback,
      reason != nullptr && reason[0] != '\0' ? reason : "Native TAA fallback");
}

void SetRestartRequired() {
  SetBootstrapStatus(BootstrapStatus::kRestartRequired, "Restart required");
}

BootstrapStatus GetStatus() { return bootstrap_status.load(std::memory_order_acquire); }

std::uint64_t GetStatusRevision() {
  return bootstrap_status_revision.load(std::memory_order_acquire);
}

const char* GetStatusText() {
  thread_local std::string copy;
  const std::lock_guard lock(bootstrap_detail_mutex);
  copy = bootstrap_detail;
  return copy.c_str();
}

bool WasLoadedEarly() { return loaded_early.load(std::memory_order_acquire); }

bool IsBridgeReady() {
  return GetStatus() == BootstrapStatus::kDlaaReady && GetActiveDevice() != nullptr;
}

bool CanInsertComputeWriteBarrier(std::uint64_t command_buffer) {
  if (command_buffer == 0u) return false;
  const auto state =
      FindDeviceSharedFast(FromOpaque<VkCommandBuffer>(command_buffer));
  return state != nullptr
         && !state->destroying.load(std::memory_order_acquire)
         && state->next_cmd_pipeline_barrier != nullptr;
}

bool CaptureDofCompositeImageSnapshot(
    std::uint64_t command_buffer,
    DofCompositeImageSnapshot* snapshot,
    DofCompositeCaptureDetail* detail) {
  if (detail != nullptr) {
    *detail = DofCompositeCaptureDetail::kNotAttempted;
  }
  const auto fail = [detail](DofCompositeCaptureDetail failure) {
    if (detail != nullptr) *detail = failure;
    return false;
  };
  if (snapshot == nullptr || command_buffer == 0u) {
    return fail(DofCompositeCaptureDetail::kInvalidArgument);
  }
  *snapshot = {};
  const auto state =
      FindDeviceSharedFast(FromOpaque<VkCommandBuffer>(command_buffer));
  if (state == nullptr) {
    return fail(DofCompositeCaptureDetail::kDeviceStateUnavailable);
  }
  if (!state->supported_executable) {
    return fail(DofCompositeCaptureDetail::kUnsupportedExecutable);
  }
  if (state->destroying.load(std::memory_order_acquire)) {
    return fail(DofCompositeCaptureDetail::kDeviceDestroying);
  }
  if (state->next_cmd_push_constants == nullptr) {
    return fail(DofCompositeCaptureDetail::kPushConstantsUnavailable);
  }

  const std::lock_guard lock(state->tracking_mutex);
  const auto command =
      state->command_buffer_dof_composite_states.find(command_buffer);
  if (command == state->command_buffer_dof_composite_states.end()) {
    return fail(DofCompositeCaptureDetail::kCommandStateMissing);
  }
  if (command->second.pipeline == VK_NULL_HANDLE
      || command->second.pipeline_layout == VK_NULL_HANDLE
      || command->second.descriptor_set == VK_NULL_HANDLE
      || !command->second.dynamic_offset_valid) {
    return fail(DofCompositeCaptureDetail::kCommandStateIncomplete);
  }
  const auto descriptor_set =
      state->descriptor_sets.find(ToOpaque(command->second.descriptor_set));
  if (descriptor_set == state->descriptor_sets.end()) {
    return fail(DofCompositeCaptureDetail::kDescriptorSetMissing);
  }
  const auto descriptor_layout = state->descriptor_set_layouts.find(
      ToOpaque(descriptor_set->second.layout));
  if (descriptor_layout == state->descriptor_set_layouts.end()) {
    return fail(DofCompositeCaptureDetail::kDescriptorSetLayoutMissing);
  }
  if (!descriptor_layout->second.dof_composite_candidate) {
    return fail(DofCompositeCaptureDetail::kDescriptorSetLayoutMismatch);
  }
  const auto pipeline_layout = state->pipeline_layouts.find(
      ToOpaque(command->second.pipeline_layout));
  if (pipeline_layout == state->pipeline_layouts.end()) {
    return fail(DofCompositeCaptureDetail::kPipelineLayoutMissing);
  }
  if (pipeline_layout->second.set_layouts.size() != 1u
      || pipeline_layout->second.set_layouts[0u] != descriptor_set->second.layout
      || !HasDofCompositePushConstantRange(pipeline_layout->second)) {
    return fail(DofCompositeCaptureDetail::kPipelineLayoutMismatch);
  }
  const auto& push_constant_range =
      pipeline_layout->second.push_constant_ranges[0u];

  DofCompositeImageSnapshot candidate = {
      .command_buffer = command_buffer,
      .descriptor_set = ToOpaque(command->second.descriptor_set),
      .pipeline_layout = ToOpaque(command->second.pipeline_layout),
      .compute_pipeline = ToOpaque(command->second.pipeline),
      .descriptor_set_index = 0u,
      .binding = 16u,
      .dynamic_offset_count = 1u,
      .dynamic_offset = command->second.dynamic_offset,
      .push_constant_stage_flags = push_constant_range.stageFlags,
      .push_constant_offset = push_constant_range.offset,
      .push_constant_size = push_constant_range.size,
  };
  if (!FillImageBindingLocked(
          *state,
          descriptor_set->second,
           command->second.descriptor_set,
           candidate.binding,
           &candidate.image)) {
    return fail(DofCompositeCaptureDetail::kOutputBindingUnavailable);
  }
  if (!FillImageBindingLocked(
          *state,
          descriptor_set->second,
           command->second.descriptor_set,
           3u,
           &candidate.depth)) {
    return fail(DofCompositeCaptureDetail::kDepthBindingUnavailable);
  }
  if (candidate.image.descriptor_type
      != static_cast<std::uint32_t>(VK_DESCRIPTOR_TYPE_STORAGE_IMAGE)) {
    return fail(DofCompositeCaptureDetail::kOutputDescriptorTypeMismatch);
  }
  if (candidate.image.resource.layout != VK_IMAGE_LAYOUT_GENERAL) {
    return fail(DofCompositeCaptureDetail::kOutputLayoutMismatch);
  }
  if (candidate.depth.descriptor_type
      != static_cast<std::uint32_t>(
          VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER)) {
    return fail(DofCompositeCaptureDetail::kDepthDescriptorTypeMismatch);
  }
  *snapshot = candidate;
  // Freeze the verified game state while the add-on records its private
  // pipelines. If ReShade happens to route those binds through this embedded
  // layer, they must not overwrite the restore snapshot. Native restore thaws
  // tracking after rebinding Detroit's original state.
  GetThreadComputeCommandStates()[command_buffer]
      .dof_composite_descriptor_set_bound = false;
  if (detail != nullptr) *detail = DofCompositeCaptureDetail::kSuccess;
  return true;
}

bool ReleaseDofCompositeImageSnapshot(
    const DofCompositeImageSnapshot& snapshot) {
  if (snapshot.command_buffer == 0u || snapshot.descriptor_set == 0u
      || snapshot.pipeline_layout == 0u || snapshot.compute_pipeline == 0u
      || snapshot.descriptor_set_index != 0u
      || snapshot.dynamic_offset_count != 1u) {
    return false;
  }
  const auto state = FindDeviceSharedFast(
      FromOpaque<VkCommandBuffer>(snapshot.command_buffer));
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)) {
    return false;
  }
  {
    const std::lock_guard lock(state->tracking_mutex);
    const auto command = state->command_buffer_dof_composite_states.find(
        snapshot.command_buffer);
    if (command == state->command_buffer_dof_composite_states.end()
        || !command->second.dynamic_offset_valid
        || ToOpaque(command->second.pipeline) != snapshot.compute_pipeline
        || ToOpaque(command->second.pipeline_layout) != snapshot.pipeline_layout
        || ToOpaque(command->second.descriptor_set) != snapshot.descriptor_set
        || command->second.dynamic_offset != snapshot.dynamic_offset) {
      return false;
    }
    const auto layout = state->pipeline_layouts.find(
        ToOpaque(command->second.pipeline_layout));
    if (layout == state->pipeline_layouts.end()
        || !HasDofCompositePushConstantRange(layout->second)) {
      return false;
    }
  }
  auto& local = GetThreadComputeCommandStates()[snapshot.command_buffer];
  local.pipeline = FromOpaque<VkPipeline>(snapshot.compute_pipeline);
  local.dof_composite_descriptor_set_bound = true;
  return true;
}

bool RestoreDofCompositeComputeState(
    const DofCompositeImageSnapshot& snapshot,
    const void* push_constant_data,
    std::uint32_t push_constant_size) {
  if (snapshot.command_buffer == 0u || snapshot.descriptor_set == 0u
      || snapshot.pipeline_layout == 0u || snapshot.compute_pipeline == 0u
      || snapshot.descriptor_set_index != 0u
      || snapshot.dynamic_offset_count != 1u
      || snapshot.push_constant_stage_flags == 0u
      || snapshot.push_constant_offset != 0u
      || snapshot.push_constant_size != 112u
      || push_constant_data == nullptr
      || push_constant_size != snapshot.push_constant_size) {
    return false;
  }
  const auto command_buffer =
      FromOpaque<VkCommandBuffer>(snapshot.command_buffer);
  const auto state = FindDeviceSharedFast(command_buffer);
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)
      || state->next_cmd_bind_pipeline == nullptr
      || state->next_cmd_bind_descriptor_sets == nullptr
      || state->next_cmd_push_constants == nullptr) {
    return false;
  }

  VkPipeline pipeline = VK_NULL_HANDLE;
  VkPipelineLayout pipeline_layout = VK_NULL_HANDLE;
  VkDescriptorSet descriptor_set = VK_NULL_HANDLE;
  std::uint32_t dynamic_offset = 0u;
  {
    const std::lock_guard lock(state->tracking_mutex);
    const auto command = state->command_buffer_dof_composite_states.find(
        snapshot.command_buffer);
    if (command == state->command_buffer_dof_composite_states.end()
        || !command->second.dynamic_offset_valid
        || ToOpaque(command->second.pipeline) != snapshot.compute_pipeline
        || ToOpaque(command->second.pipeline_layout) != snapshot.pipeline_layout
        || ToOpaque(command->second.descriptor_set) != snapshot.descriptor_set
        || command->second.dynamic_offset != snapshot.dynamic_offset) {
      return false;
    }
    const auto layout = state->pipeline_layouts.find(
        ToOpaque(command->second.pipeline_layout));
    if (layout == state->pipeline_layouts.end()
        || !HasDofCompositePushConstantRange(layout->second)) {
      return false;
    }
    const auto& push_constant_range = layout->second.push_constant_ranges[0u];
    if (push_constant_range.stageFlags != snapshot.push_constant_stage_flags
        || push_constant_range.offset != snapshot.push_constant_offset
        || push_constant_range.size != snapshot.push_constant_size) {
      return false;
    }
    pipeline = command->second.pipeline;
    pipeline_layout = command->second.pipeline_layout;
    descriptor_set = command->second.descriptor_set;
    dynamic_offset = command->second.dynamic_offset;
  }

  state->next_cmd_bind_pipeline(
      command_buffer, VK_PIPELINE_BIND_POINT_COMPUTE, pipeline);
  state->next_cmd_bind_descriptor_sets(
      command_buffer,
      VK_PIPELINE_BIND_POINT_COMPUTE,
      pipeline_layout,
      snapshot.descriptor_set_index,
      1u,
      &descriptor_set,
      1u,
      &dynamic_offset);
  state->next_cmd_push_constants(
      command_buffer,
      pipeline_layout,
      static_cast<VkShaderStageFlags>(snapshot.push_constant_stage_flags),
      snapshot.push_constant_offset,
      snapshot.push_constant_size,
      push_constant_data);
  auto& local = GetThreadComputeCommandStates()[snapshot.command_buffer];
  local.pipeline = pipeline;
  local.dof_composite_descriptor_set_bound = true;
  {
    const std::lock_guard lock(state->tracking_mutex);
    state->command_buffer_dof_composite_states[snapshot.command_buffer] = {
        .pipeline = pipeline,
        .pipeline_layout = pipeline_layout,
        .descriptor_set = descriptor_set,
        .dynamic_offset = dynamic_offset,
        .dynamic_offset_valid = true,
    };
  }
  return true;
}

bool InsertComputeWriteBarrier(std::uint64_t command_buffer) {
  if (command_buffer == 0u) return false;
  const auto vk_command_buffer =
      FromOpaque<VkCommandBuffer>(command_buffer);
  const auto state = FindDeviceSharedFast(vk_command_buffer);
  if (state == nullptr
      || state->destroying.load(std::memory_order_acquire)
      || state->next_cmd_pipeline_barrier == nullptr) {
    return false;
  }
  const VkMemoryBarrier barrier = {
      VK_STRUCTURE_TYPE_MEMORY_BARRIER,
      nullptr,
      VK_ACCESS_SHADER_WRITE_BIT,
      VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT,
  };
  state->next_cmd_pipeline_barrier(
      vk_command_buffer,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      0u,
      1u,
      &barrier,
      0u,
      nullptr,
      0u,
      nullptr);
  return true;
}

DetroitDlssResultCode DETROIT_DLSS_CALL GetApi(
    std::uint32_t requested_version, DetroitDlssApiV2* api) {
  if (api == nullptr || api->struct_size < sizeof(*api)
      || requested_version != DETROIT_DLSS_ABI_VERSION
      || !executable_verified.load(std::memory_order_acquire)) {
    return DETROIT_DLSS_RESULT_ERROR;
  }
  const auto struct_size = api->struct_size;
  *api = {};
  api->struct_size = struct_size;
  api->abi_version = DETROIT_DLSS_ABI_VERSION;
  api->get_context = &BridgeGetContext;
  api->get_temporal_constants = &BridgeGetTemporalConstants;
  api->get_temporal_snapshot = &BridgeGetTemporalSnapshot;
  api->query_mode = &BridgeQueryMode;
  api->configure = &BridgeConfigure;
  api->evaluate = &BridgeEvaluate;
  api->shutdown = &BridgeShutdown;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

}  // namespace renodx::games::detroitbecomehuman::dlss::embedded
