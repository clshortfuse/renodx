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

#include <vulkan/vk_layer.h>
#include <vulkan/vulkan.h>

#include <nvsdk_ngx_helpers.h>
#include <nvsdk_ngx_helpers_vk.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <limits>
#include <memory>
#include <mutex>
#include <optional>
#include <string>
#include <string_view>
#include <type_traits>
#include <unordered_map>
#include <utility>
#include <vector>

#include "../dlss_bridge_abi.h"
#include "../supported_build.hpp"
#include "adapter_runtime.hpp"
#include "feature_lifetime.hpp"

namespace {

constexpr char kProjectId[] = "910b88f3-e60e-4c9d-a959-9a46b3e7dcc3";
constexpr char kEngineVersion[] = "Build12158144";
constexpr std::uint64_t kInstanceExtensionsEnabled = UINT64_C(1) << 0u;
constexpr std::uint64_t kDeviceExtensionsEnabled = UINT64_C(1) << 1u;
constexpr std::uint64_t kReflectedTemporalConstantsSize = 496u;
constexpr char kCachedDeviceExtensionsReadyEnvironment[] =
    "RENODX_DETROIT_NGX_DEVICE_EXTENSIONS_READY";
constexpr char kCachedInstanceExtensionsEnvironment[] =
    "RENODX_DETROIT_NGX_INSTANCE_EXTENSIONS";
constexpr char kCachedDeviceExtensionsEnvironment[] =
    "RENODX_DETROIT_NGX_DEVICE_EXTENSIONS";
constexpr char kDiagnosticOutputEnvironment[] =
    "RENODX_DETROIT_DLSS_DIAGNOSTIC_OUTPUT";
constexpr std::size_t kMaximumCachedExtensionListBytes = 16u * 1024u;
constexpr std::size_t kMaximumCachedExtensionCount = 64u;
constexpr std::uint64_t kMaximumTemporalConstantsShadowSize = 64u * 1024u;
constexpr std::size_t kTemporalDescriptorSetBloomWordCount = 64u;
constexpr std::array<std::uint32_t, DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT>
    kTemporalImageBindings = {0u, 1u, 2u, 3u, 4u, 5u, 6u, 7u, 9u, 16u, 17u, 18u, 19u};

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
std::atomic_bool spatial_diagnostic_logged = false;

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
  const HANDLE file = CreateFileW(
      path.c_str(),
      FILE_APPEND_DATA,
      FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
      nullptr,
      OPEN_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      nullptr);
  if (file == INVALID_HANDLE_VALUE) return;
  DWORD written = 0u;
  (void)WriteFile(
      file,
      message.data(),
      static_cast<DWORD>(std::min<std::size_t>(message.size(), MAXDWORD)),
      &written,
      nullptr);
  static constexpr char newline[] = "\r\n";
  (void)WriteFile(file, newline, 2u, &written, nullptr);
  CloseHandle(file);
}

bool UseSpatialDiagnosticOutput() {
  static const bool enabled = [] {
    std::array<char, 32u> value = {};
    const DWORD length = GetEnvironmentVariableA(
        kDiagnosticOutputEnvironment,
        value.data(),
        static_cast<DWORD>(value.size()));
    return length != 0u && length < value.size()
           && _stricmp(value.data(), "spatial") == 0;
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
};

struct PipelineLayoutState {
  std::vector<VkDescriptorSetLayout> set_layouts;
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
};

struct CommandPoolState {
  std::uint32_t queue_family_index = std::numeric_limits<std::uint32_t>::max();
  VkCommandPoolCreateFlags flags = 0u;
};

struct FeatureGenerationState {
  std::uint64_t generation = 0u;
  NVSDK_NGX_Parameter* parameters = nullptr;
  NVSDK_NGX_Handle* feature = nullptr;
  std::uint32_t create_flags = 0u;
  renodx::games::detroitbecomehuman::dlss::FeatureCreationGate creation;
  bool retired = false;
};

struct FencedFeatureSubmission {
  std::uint64_t queue = 0u;
  renodx::games::detroitbecomehuman::dlss::FeatureLifetimeTracker::
      SubmissionSnapshot snapshot;
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
  PFN_vkMapMemory next_map_memory = nullptr;
  PFN_vkUnmapMemory next_unmap_memory = nullptr;
  PFN_vkBeginCommandBuffer next_begin_command_buffer = nullptr;
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
  PFN_vkDestroyFence next_destroy_fence = nullptr;
  PFN_vkCreateCommandPool next_create_command_pool = nullptr;
  PFN_vkAllocateCommandBuffers next_allocate_command_buffers = nullptr;
  PFN_vkFreeCommandBuffers next_free_command_buffers = nullptr;
  PFN_vkResetCommandPool next_reset_command_pool = nullptr;
  PFN_vkDestroyCommandPool next_destroy_command_pool = nullptr;
  PFN_vkCmdBindPipeline next_cmd_bind_pipeline = nullptr;
  PFN_vkCmdBindDescriptorSets next_cmd_bind_descriptor_sets = nullptr;
  bool supported_executable = false;
  bool ngx_extensions_enabled = false;
  bool ngx_initialized = false;
  bool ngx_available = false;
  bool adapter_available = false;
  bool configured = false;
  std::uint64_t identity = 0u;
  std::uint64_t context_identity = 0u;
  std::uint64_t configured_identity = 0u;
  std::atomic<bool> destroying = false;
  DetroitDlssModeSettings settings = {};
  NVSDK_NGX_Parameter* capability_parameters = nullptr;
  std::uint64_t active_feature_generation = 0u;
  std::uint64_t next_feature_generation = 1u;
  std::unordered_map<std::uint64_t, FeatureGenerationState> feature_generations;
  std::atomic<bool> feature_submission_tracking_active = false;
  renodx::games::detroitbecomehuman::dlss::FeatureLifetimeTracker
      feature_lifetime;
  std::unordered_map<std::uint64_t, FencedFeatureSubmission>
      fenced_feature_submissions;
  bool ngx_shutdown_requested = false;
  renodx::games::detroitbecomehuman::dlss::AdapterRuntime adapter_runtime;
  std::atomic<std::uint64_t> last_adapter_failure = 0u;
  std::atomic<std::uint64_t> last_ngx_failure = 0u;
  std::mutex mutex;

  VkPhysicalDeviceMemoryProperties memory_properties = {};
  std::mutex tracking_mutex;
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
  std::unordered_map<std::uint64_t, std::vector<VkCommandBuffer>>
      command_pool_buffers;
  std::unordered_map<std::uint64_t, CommandPoolState> command_pools;
  std::unordered_map<std::uint64_t, std::uint64_t> command_buffer_pools;
  std::unordered_map<std::uint64_t, VkCommandBufferLevel> command_buffer_levels;
  std::uint64_t descriptor_update_serial = 0u;
  std::array<std::atomic<std::uint64_t>, kTemporalDescriptorSetBloomWordCount>
      temporal_descriptor_set_bloom = {};
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
std::atomic<std::uint64_t> device_registry_generation = 1u;
std::atomic<std::uint64_t> next_device_identity = 1u;

template <typename LayerCreateInfo>
LayerCreateInfo* FindLayerCreateInfo(const void* chain, VkStructureType type) {
  auto* current = reinterpret_cast<const VkBaseInStructure*>(chain);
  while (current != nullptr) {
    if (current->sType == type) {
      auto* layer_info = const_cast<LayerCreateInfo*>(reinterpret_cast<const LayerCreateInfo*>(current));
      if (layer_info->function == VK_LAYER_LINK_INFO) return layer_info;
    }
    current = current->pNext;
  }
  return nullptr;
}

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

std::shared_ptr<DeviceState> FindDevice(VkCommandBuffer command_buffer) {
  const std::lock_guard lock(state_mutex);
  const auto found = devices.find(DispatchKey(command_buffer));
  return found == devices.end() ? nullptr : found->second;
}

template <typename Dispatchable>
DeviceState* FindDeviceFast(Dispatchable handle) {
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
    return cache.state.get();
  }

  const std::lock_guard lock(state_mutex);
  const auto found = devices.find(dispatch_key);
  cache.dispatch_key = dispatch_key;
  cache.generation = device_registry_generation.load(std::memory_order_relaxed);
  cache.state = found == devices.end() ? nullptr : found->second;
  return cache.state.get();
}

struct ThreadComputeCommandState {
  VkPipeline pipeline = VK_NULL_HANDLE;
  bool temporal_descriptor_set_bound = false;
};

std::unordered_map<std::uint64_t, ThreadComputeCommandState>&
GetThreadComputeCommandStates() {
  thread_local std::unordered_map<std::uint64_t, ThreadComputeCommandState> states;
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

std::size_t TemporalDescriptorSetBloomBit(std::uint64_t descriptor_set) {
  descriptor_set ^= descriptor_set >> 33u;
  descriptor_set *= UINT64_C(0xFF51AFD7ED558CCD);
  descriptor_set ^= descriptor_set >> 33u;
  return static_cast<std::size_t>(
      descriptor_set % (kTemporalDescriptorSetBloomWordCount * 64u));
}

void MarkTemporalDescriptorSet(DeviceState* state, VkDescriptorSet descriptor_set) {
  const std::size_t bit = TemporalDescriptorSetBloomBit(ToOpaque(descriptor_set));
  state->temporal_descriptor_set_bloom[bit / 64u].fetch_or(
      UINT64_C(1) << (bit % 64u), std::memory_order_release);
}

bool MayBeTemporalDescriptorSet(
    const DeviceState& state, VkDescriptorSet descriptor_set) {
  if (descriptor_set == VK_NULL_HANDLE) return false;
  const std::size_t bit = TemporalDescriptorSetBloomBit(ToOpaque(descriptor_set));
  return (state.temporal_descriptor_set_bloom[bit / 64u].load(
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
  if (state == nullptr) return false;
  const std::lock_guard lock(state_mutex);
  return active_device.lock() == state;
}

bool ReadCachedNgxExtensions(
    const char* environment_name,
    std::vector<std::string>* required_extensions) {
  if (environment_name == nullptr || required_extensions == nullptr) return false;
  std::array<char, 8u> ready = {};
  const DWORD ready_size = GetEnvironmentVariableA(
      kCachedDeviceExtensionsReadyEnvironment,
      ready.data(),
      static_cast<DWORD>(ready.size()));
  if (ready_size != 1u || ready[0] != '1') return false;

  const DWORD required_size = GetEnvironmentVariableA(environment_name, nullptr, 0u);
  if (required_size == 0u) return true;
  if (required_size > kMaximumCachedExtensionListBytes) return false;
  std::vector<char> buffer(required_size, '\0');
  const DWORD written = GetEnvironmentVariableA(
      environment_name,
      buffer.data(),
      required_size);
  if (written == 0u || written >= required_size) return false;

  std::string_view list(buffer.data(), written);
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

NVSDK_NGX_PerfQuality_Value ToNgxQuality(DetroitDlssMode mode) {
  switch (mode) {
    case DETROIT_DLSS_MODE_DLAA:
      return NVSDK_NGX_PerfQuality_Value_DLAA;
    case DETROIT_DLSS_MODE_QUALITY:
      return NVSDK_NGX_PerfQuality_Value_MaxQuality;
    case DETROIT_DLSS_MODE_BALANCED:
      return NVSDK_NGX_PerfQuality_Value_Balanced;
    case DETROIT_DLSS_MODE_PERFORMANCE:
      return NVSDK_NGX_PerfQuality_Value_MaxPerf;
    default:
      return NVSDK_NGX_PerfQuality_Value_MaxQuality;
  }
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

FeatureGenerationState* GetActiveFeatureLocked(DeviceState* state) {
  if (state == nullptr || state->active_feature_generation == 0u) return nullptr;
  const auto found =
      state->feature_generations.find(state->active_feature_generation);
  return found == state->feature_generations.end() ? nullptr : &found->second;
}

std::uint64_t AllocateFeatureGenerationLocked(DeviceState* state) {
  for (;;) {
    const std::uint64_t generation = state->next_feature_generation++;
    if (state->next_feature_generation == 0u) {
      state->next_feature_generation = 1u;
    }
    if (generation != 0u && !state->feature_generations.contains(generation)) {
      return generation;
    }
  }
}

void DestroyFeatureGenerationLocked(
    DeviceState* state, std::uint64_t generation) {
  const auto found = state->feature_generations.find(generation);
  if (found == state->feature_generations.end()) return;
  // NGX was initialized with next_get_*_proc_addr, not this layer's exported
  // dispatch functions. Keeping the device mutex held therefore serializes
  // NGX create/evaluate/release without re-entering the tracked Vulkan hooks.
  if (found->second.feature != nullptr) {
    const auto result = NVSDK_NGX_VULKAN_ReleaseFeature(found->second.feature);
    if (NVSDK_NGX_FAILED(result)) {
      TraceNgxFailureOnce(state, 3u, "feature release", result);
    }
  }
  if (found->second.parameters != nullptr) {
    NVSDK_NGX_VULKAN_DestroyParameters(found->second.parameters);
  }
  state->feature_generations.erase(found);
  if (state->feature_generations.empty()) {
    state->feature_submission_tracking_active.store(
        false, std::memory_order_release);
  }
}

void FinishNgxShutdownLocked(DeviceState* state) {
  if (!state->ngx_shutdown_requested || !state->feature_generations.empty()) return;
  if (state->capability_parameters != nullptr) {
    NVSDK_NGX_VULKAN_DestroyParameters(state->capability_parameters);
    state->capability_parameters = nullptr;
  }
  if (state->ngx_initialized) {
    const auto result = NVSDK_NGX_VULKAN_Shutdown1(state->device);
    if (NVSDK_NGX_FAILED(result)) {
      TraceNgxFailureOnce(state, 4u, "shutdown", result);
    }
  }
  state->ngx_initialized = false;
  state->ngx_available = false;
  state->ngx_shutdown_requested = false;
}

void CollectRetiredFeaturesLocked(DeviceState* state) {
  std::vector<std::uint64_t> releasable;
  releasable.reserve(state->feature_generations.size());
  for (const auto& [generation, feature] : state->feature_generations) {
    if (feature.retired && !state->feature_lifetime.IsReferenced(generation)) {
      releasable.push_back(generation);
    }
  }
  for (const std::uint64_t generation : releasable) {
    DestroyFeatureGenerationLocked(state, generation);
  }
  FinishNgxShutdownLocked(state);
}

void RetireActiveFeatureLocked(DeviceState* state) {
  if (auto* feature = GetActiveFeatureLocked(state); feature != nullptr) {
    feature->retired = true;
  }
  state->active_feature_generation = 0u;
  CollectRetiredFeaturesLocked(state);
}

void InvalidateUnsubmittedFeatureCreationsLocked(
    DeviceState* state, const std::vector<std::uint64_t>& command_buffers) {
  if (state == nullptr || command_buffers.empty()) return;
  for (auto& [generation, feature] : state->feature_generations) {
    if (feature.creation.submitted) continue;
    const bool invalidated = std::any_of(
        command_buffers.begin(),
        command_buffers.end(),
        [&feature](std::uint64_t command_buffer) {
          return feature.creation.InvalidatedByDiscard(command_buffer);
        });
    if (!invalidated) continue;
    feature.retired = true;
    if (state->active_feature_generation == generation) {
      state->active_feature_generation = 0u;
    }
  }
}

void RequestNgxShutdown(DeviceState* state) {
  const std::lock_guard lock(state->mutex);
  RetireActiveFeatureLocked(state);
  state->configured = false;
  state->context_identity = 0u;
  state->configured_identity = 0u;
  state->ngx_shutdown_requested = true;
  CollectRetiredFeaturesLocked(state);
}

void ForceShutdownNgxForDeviceDestroy(DeviceState* state) {
  const std::lock_guard lock(state->mutex);
  state->feature_lifetime.DiscardAllCommandBuffers();
  if (auto* feature = GetActiveFeatureLocked(state); feature != nullptr) {
    feature->retired = true;
  }
  state->active_feature_generation = 0u;
  for (auto& [generation, feature] : state->feature_generations) {
    feature.retired = true;
  }
  state->ngx_shutdown_requested = true;
  CollectRetiredFeaturesLocked(state);
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
    handles.push_back(ToOpaque(command_buffer));
  }
  const std::lock_guard lock(state->mutex);
  InvalidateUnsubmittedFeatureCreationsLocked(state, handles);
  state->feature_lifetime.DiscardCommandBuffers(handles);
  CollectRetiredFeaturesLocked(state);
}

void DiscardFeatureCommandBuffer(
    DeviceState* state, VkCommandBuffer command_buffer) {
  if (state == nullptr || command_buffer == VK_NULL_HANDLE) return;
  const std::lock_guard lock(state->mutex);
  const std::uint64_t handle = ToOpaque(command_buffer);
  InvalidateUnsubmittedFeatureCreationsLocked(state, {handle});
  state->feature_lifetime.DiscardCommandBuffer(handle);
  CollectRetiredFeaturesLocked(state);
}

bool EnsureNgxInitialized(DeviceState* state) {
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)) return false;
  if (state->ngx_initialized) {
    // A later non-Native configuration may reuse the initialized NGX context
    // while retired generations wait for their recorded command buffers to be
    // reset or freed.
    state->ngx_shutdown_requested = false;
    return state->ngx_available;
  }
  if (!state->supported_executable || !state->ngx_extensions_enabled) return false;

  state->ngx_shutdown_requested = false;

  NgxDiscovery discovery;
  const auto init_result = NVSDK_NGX_VULKAN_Init_with_ProjectID(
      kProjectId,
      NVSDK_NGX_ENGINE_TYPE_CUSTOM,
      kEngineVersion,
      discovery.data_path.c_str(),
      state->instance,
      state->physical_device,
      state->device,
      state->next_get_instance_proc_addr,
      state->next_get_device_proc_addr,
      &discovery.feature_info,
      NVSDK_NGX_Version_API);
  if (NVSDK_NGX_FAILED(init_result)) return false;
  state->ngx_initialized = true;

  if (NVSDK_NGX_FAILED(
          NVSDK_NGX_VULKAN_GetCapabilityParameters(&state->capability_parameters))) {
    if (state->capability_parameters != nullptr) {
      NVSDK_NGX_VULKAN_DestroyParameters(state->capability_parameters);
      state->capability_parameters = nullptr;
    }
    NVSDK_NGX_VULKAN_Shutdown1(state->device);
    state->ngx_initialized = false;
    return false;
  }

  int available = 0;
  if (NVSDK_NGX_FAILED(NVSDK_NGX_Parameter_GetI(
          state->capability_parameters,
          NVSDK_NGX_Parameter_SuperSampling_Available,
          &available))
      || available == 0) {
    NVSDK_NGX_VULKAN_DestroyParameters(state->capability_parameters);
    state->capability_parameters = nullptr;
    NVSDK_NGX_VULKAN_Shutdown1(state->device);
    state->ngx_initialized = false;
    return false;
  }

  state->ngx_available = true;
  return true;
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
    context->capability_flags |= DETROIT_DLSS_CAPABILITY_SUPER_RESOLUTION
                                 | DETROIT_DLSS_CAPABILITY_DLAA
                                 | DETROIT_DLSS_CAPABILITY_AUTO_EXPOSURE
                                 | DETROIT_DLSS_CAPABILITY_RENDER_SCALE_CONTROL
                                 | DETROIT_DLSS_CAPABILITY_TEMPORAL_INPUTS_VERIFIED;
  }
  if (state->ngx_extensions_enabled) {
    context->enabled_extension_flags =
        kInstanceExtensionsEnabled | kDeviceExtensionsEnabled;
  }
  state->context_identity = state->identity;
  return ngx_available ? DETROIT_DLSS_RESULT_SUCCESS : DETROIT_DLSS_RESULT_FALLBACK;
}

DetroitDlssResultCode FillTemporalConstantsLocked(
    const DeviceState& state,
    std::uint64_t command_buffer,
    std::uint32_t descriptor_set_index,
    std::uint32_t binding,
    DetroitDlssTemporalConstantsSnapshot* snapshot,
    DetroitDlssTemporalConstantsDiagnostics* diagnostics) {
  const auto set_detail = [&](DetroitDlssTemporalConstantsDetail detail) {
    if (diagnostics != nullptr && diagnostics->detail_code == DETROIT_DLSS_CONSTANTS_DETAIL_NONE) {
      diagnostics->detail_code = detail;
    }
  };

  const auto command = state.command_buffer_descriptors.find(command_buffer);
  if (command == state.command_buffer_descriptors.end()) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_BINDING_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const auto bound = command->second.find(CommandDescriptorKey(descriptor_set_index, binding));
  if (bound == command->second.end()) {
    set_detail(DETROIT_DLSS_CONSTANTS_DETAIL_BINDING_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  snapshot->descriptor_set = ToOpaque(bound->second.descriptor_set);
  snapshot->pipeline_layout = ToOpaque(bound->second.pipeline_layout);
  snapshot->dynamic_offset = bound->second.dynamic_offset;
  if (!bound->second.dynamic_offset_valid) {
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

  const auto state = FindDevice(FromOpaque<VkCommandBuffer>(command_buffer));
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
  const auto state = FindDevice(FromOpaque<VkCommandBuffer>(command_buffer));
  if (state == nullptr || !state->supported_executable
      || state->destroying.load(std::memory_order_acquire)) {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_DEVICE_UNAVAILABLE);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const std::lock_guard lock(state->tracking_mutex);
  const auto command = state->command_buffer_descriptors.find(command_buffer);
  if (command == state->command_buffer_descriptors.end()) {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_COMMAND_UNTRACKED);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_COMMAND_TRACKED;

  const auto anchor_bound = command->second.find(CommandDescriptorKey(
      descriptor_set_index, DETROIT_DLSS_TAA_SAMPLED_BINDING_1));
  if (anchor_bound == command->second.end()) {
    set_detail(DETROIT_DLSS_SNAPSHOT_DETAIL_SET_UNBOUND);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  snapshot->snapshot_flags |= DETROIT_DLSS_SNAPSHOT_SET_BOUND;
  snapshot->descriptor_set = ToOpaque(anchor_bound->second.descriptor_set);
  snapshot->pipeline_layout = ToOpaque(anchor_bound->second.pipeline_layout);
  const auto restore = state->command_buffer_restore_states.find(command_buffer);
  if (restore != state->command_buffer_restore_states.end()) {
    snapshot->compute_pipeline = ToOpaque(restore->second.pipeline);
  }

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
        descriptor_set->second,
        anchor_bound->second.descriptor_set,
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

  const auto constants_status = FillTemporalConstantsLocked(
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

  return snapshot->detail_code == DETROIT_DLSS_SNAPSHOT_DETAIL_NONE
                 && (snapshot->snapshot_flags & DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK)
                        == DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK
             ? DETROIT_DLSS_RESULT_SUCCESS
             : DETROIT_DLSS_RESULT_FALLBACK;
}

DetroitDlssResultCode DETROIT_DLSS_CALL BridgeQueryMode(
    DetroitDlssMode mode,
    std::uint32_t output_width,
    std::uint32_t output_height,
    DetroitDlssModeSettings* settings) {
  if (settings == nullptr || settings->struct_size < sizeof(*settings)
      || settings->abi_version != DETROIT_DLSS_ABI_VERSION || output_width == 0u
      || output_height == 0u || mode > DETROIT_DLSS_MODE_PERFORMANCE) {
    return DETROIT_DLSS_RESULT_ERROR;
  }

  const auto struct_size = settings->struct_size;
  *settings = {};
  settings->struct_size = struct_size;
  settings->abi_version = DETROIT_DLSS_ABI_VERSION;
  settings->mode = mode;
  settings->output_width = output_width;
  settings->output_height = output_height;
  if (mode == DETROIT_DLSS_MODE_NATIVE) {
    settings->render_width = output_width;
    settings->render_height = output_height;
    settings->min_render_width = output_width;
    settings->min_render_height = output_height;
    settings->max_render_width = output_width;
    settings->max_render_height = output_height;
    return DETROIT_DLSS_RESULT_SUCCESS;
  }

  settings->create_flags = DETROIT_DLSS_CREATE_HDR
                           | DETROIT_DLSS_CREATE_MOTION_VECTORS_LOW_RESOLUTION
                           | DETROIT_DLSS_CREATE_DEPTH_INVERTED
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

  float sharpness = 0.f;
  const auto query_result = NGX_DLSS_GET_OPTIMAL_SETTINGS(
      state->capability_parameters,
      output_width,
      output_height,
      ToNgxQuality(mode),
      &settings->render_width,
      &settings->render_height,
      &settings->max_render_width,
      &settings->max_render_height,
      &settings->min_render_width,
      &settings->min_render_height,
      &sharpness);
  return NVSDK_NGX_SUCCEED(query_result) ? DETROIT_DLSS_RESULT_SUCCESS
                                         : DETROIT_DLSS_RESULT_FALLBACK;
}

DetroitDlssResultCode DETROIT_DLSS_CALL BridgeConfigure(
    const DetroitDlssModeSettings* settings) {
  if (settings == nullptr || settings->struct_size < sizeof(*settings)
      || settings->abi_version != DETROIT_DLSS_ABI_VERSION
      || settings->mode > DETROIT_DLSS_MODE_PERFORMANCE
      || (settings->create_flags & ~DETROIT_DLSS_CREATE_KNOWN_MASK) != 0u
      || settings->output_width == 0u || settings->output_height == 0u
      || settings->render_width == 0u || settings->render_height == 0u) {
    return DETROIT_DLSS_RESULT_ERROR;
  }

  const auto state = GetActiveDevice();
  if (state == nullptr || state->destroying.load(std::memory_order_acquire)) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  const std::lock_guard lock(state->mutex);
  if (state->destroying.load(std::memory_order_acquire)
      || state->context_identity != state->identity) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (settings->mode != DETROIT_DLSS_MODE_NATIVE && !EnsureNgxInitialized(state.get())) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  if (state->configured
      && std::memcmp(&state->settings, settings, sizeof(*settings)) != 0) {
    RetireActiveFeatureLocked(state.get());
  }
  if (settings->mode == DETROIT_DLSS_MODE_NATIVE) {
    RetireActiveFeatureLocked(state.get());
  }
  state->settings = *settings;
  state->configured = true;
  state->configured_identity = state->context_identity;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

std::optional<ComputeCommandRestoreState> CaptureComputeRestoreState(
    DeviceState* state, const DetroitDlssTemporalFrameInputs& inputs) {
  const std::lock_guard lock(state->tracking_mutex);
  const auto command_pool = state->command_buffer_pools.find(inputs.command_buffer);
  const auto command_level = state->command_buffer_levels.find(inputs.command_buffer);
  if (command_pool == state->command_buffer_pools.end()
      || command_level == state->command_buffer_levels.end()
      || command_level->second != VK_COMMAND_BUFFER_LEVEL_PRIMARY) {
    return std::nullopt;
  }
  const auto pool = state->command_pools.find(command_pool->second);
  if (pool == state->command_pools.end()
      || pool->second.queue_family_index != state->graphics_queue_family
      || (pool->second.flags & VK_COMMAND_POOL_CREATE_PROTECTED_BIT) != 0u) {
    return std::nullopt;
  }
  const auto found = state->command_buffer_restore_states.find(inputs.command_buffer);
  if (found == state->command_buffer_restore_states.end()
      || found->second.pipeline == VK_NULL_HANDLE
      || found->second.descriptor_layout == VK_NULL_HANDLE
      || found->second.descriptor_sets.empty()
      || ToOpaque(found->second.descriptor_layout) != inputs.pipeline_layout
      || inputs.descriptor_set_index < found->second.first_set) {
    return std::nullopt;
  }
  const std::uint64_t relative_set =
      static_cast<std::uint64_t>(inputs.descriptor_set_index) - found->second.first_set;
  if (relative_set >= found->second.descriptor_sets.size()
      || ToOpaque(found->second.descriptor_sets[relative_set]) != inputs.descriptor_set) {
    return std::nullopt;
  }
  return found->second;
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
  const auto state = inputs->command_buffer == 0u ? nullptr : FindDevice(command_buffer);
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

  const std::lock_guard lock(state->mutex);
  if (state->destroying.load(std::memory_order_acquire)
      || state->context_identity != state->identity) {
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kDeviceIdentityMismatch,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (!state->configured) {
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kNotConfigured, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (state->configured_identity != state->identity) {
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kDeviceIdentityMismatch,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (state->settings.mode == DETROIT_DLSS_MODE_NATIVE) {
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kNativeMode, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (!state->adapter_available) {
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
      && inputs->pipeline_layout != 0u && inputs->constants_buffer != 0u
      && inputs->constants_size != 0u
      && (inputs->flags & DETROIT_DLSS_FRAME_NATIVE_TAA_COMPLETED) != 0u
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
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kInvalidFrame, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const auto restore_state = CaptureComputeRestoreState(state.get(), *inputs);
  if (!restore_state.has_value()
      || !CanRestoreComputeCommandState(state.get(), *restore_state)) {
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kCommandStateUnrestorable,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (!EnsureNgxInitialized(state.get())) {
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kNgxInitializationFailed,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  const std::uint32_t create_flags = ToNgxCreateFlags(state->settings.create_flags);
  auto* active_feature = GetActiveFeatureLocked(state.get());
  if (active_feature != nullptr && active_feature->create_flags != create_flags) {
    RetireActiveFeatureLocked(state.get());
    active_feature = nullptr;
  }
  if (active_feature == nullptr) {
    NVSDK_NGX_Parameter* feature_parameters = nullptr;
    const auto allocate_result =
        NVSDK_NGX_VULKAN_AllocateParameters(&feature_parameters);
    if (NVSDK_NGX_FAILED(allocate_result) || feature_parameters == nullptr) {
      if (feature_parameters != nullptr) {
        NVSDK_NGX_VULKAN_DestroyParameters(feature_parameters);
      }
      SetEvaluationResult(
          result,
          DETROIT_DLSS_RESULT_FALLBACK,
          BridgeDetail::kFeatureCreationFailed,
          frame_id);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }

    NVSDK_NGX_DLSS_Create_Params create_parameters = {};
    create_parameters.Feature.InWidth = state->settings.render_width;
    create_parameters.Feature.InHeight = state->settings.render_height;
    create_parameters.Feature.InTargetWidth = state->settings.output_width;
    create_parameters.Feature.InTargetHeight = state->settings.output_height;
    create_parameters.Feature.InPerfQualityValue = ToNgxQuality(state->settings.mode);
    create_parameters.InFeatureCreateFlags = static_cast<int>(create_flags);
    NVSDK_NGX_Handle* feature = nullptr;
    const auto create_result = NGX_VULKAN_CREATE_DLSS_EXT1(
        state->device,
        command_buffer,
        1u,
        1u,
        &feature,
        feature_parameters,
        &create_parameters);
    if (NVSDK_NGX_FAILED(create_result) || feature == nullptr) {
      if (NVSDK_NGX_FAILED(create_result)) {
        TraceNgxFailureOnce(state.get(), 1u, "feature creation", create_result);
      } else {
        Trace("DLSS NGX feature creation returned a null handle");
      }
      (void)RestoreComputeCommandState(state.get(), command_buffer, *restore_state);
      if (feature != nullptr) {
        const std::uint64_t generation =
            AllocateFeatureGenerationLocked(state.get());
        state->feature_generations.emplace(
            generation,
            FeatureGenerationState{
                .generation = generation,
                .parameters = feature_parameters,
                .feature = feature,
                .create_flags = create_flags,
                .creation = {.command_buffer = ToOpaque(command_buffer)},
                .retired = true,
            });
        state->feature_submission_tracking_active.store(
            true, std::memory_order_release);
        // A failed NGX call may still have recorded work. Conservatively retain
        // any returned handle until this command buffer is invalidated.
        state->feature_lifetime.RecordFeatureUse(
            ToOpaque(command_buffer), generation);
      } else {
        NVSDK_NGX_VULKAN_DestroyParameters(feature_parameters);
      }
      CollectRetiredFeaturesLocked(state.get());
      SetEvaluationResult(
          result,
          DETROIT_DLSS_RESULT_FALLBACK,
          BridgeDetail::kFeatureCreationFailed,
          frame_id);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
    const std::uint64_t generation =
        AllocateFeatureGenerationLocked(state.get());
    auto [created, inserted] = state->feature_generations.emplace(
        generation,
        FeatureGenerationState{
            .generation = generation,
            .parameters = feature_parameters,
            .feature = feature,
            .create_flags = create_flags,
            .creation = {.command_buffer = ToOpaque(command_buffer)},
        });
    (void)inserted;
    state->feature_submission_tracking_active.store(
        true, std::memory_order_release);
    state->active_feature_generation = generation;
    active_feature = &created->second;
    // Feature creation itself is command-buffer based and therefore owns a
    // recorded reference even if later adapter preparation fails.
    state->feature_lifetime.RecordFeatureUse(
        ToOpaque(command_buffer), generation);
  }

  if (!active_feature->creation.AllowsUseFrom(ToOpaque(command_buffer))) {
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        BridgeDetail::kFeatureCreationPending,
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  using renodx::games::detroitbecomehuman::dlss::AdapterPreparedFrame;
  using renodx::games::detroitbecomehuman::dlss::AdapterPrepareInfo;
  AdapterPreparedFrame prepared_frame = {};
  const bool diagnostic_spatial_output = UseSpatialDiagnosticOutput();
  const auto prepare_result = state->adapter_runtime.Prepare(
      AdapterPrepareInfo{
          .command_buffer = command_buffer,
          .current_color = inputs->current_color,
          .depth = inputs->depth,
          .motion_vectors = inputs->motion_vectors,
          .output_color_pass = inputs->output,
          .render_width = inputs->render_width,
          .render_height = inputs->render_height,
          .output_width = inputs->output_width,
          .output_height = inputs->output_height,
          .diagnostic_spatial_output = diagnostic_spatial_output,
      },
      &prepared_frame);
  if (!prepare_result.Succeeded()) {
    TraceAdapterFailureOnce(state.get(), true, prepare_result);
    // The complete restore contract was validated before Prepare. Both Vulkan
    // bind commands are void, so recording this restoration cannot fail after
    // the adapter has changed command state.
    (void)RestoreComputeCommandState(state.get(), command_buffer, *restore_state);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        MakeAdapterBridgeDetail(true, prepare_result.detail),
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

  if (diagnostic_spatial_output) {
    const auto commit_result =
        state->adapter_runtime.CommitSpatialDiagnostic(prepared_frame);
    (void)RestoreComputeCommandState(state.get(), command_buffer, *restore_state);
    if (!commit_result.Succeeded()) {
      TraceAdapterFailureOnce(state.get(), false, commit_result);
      SetEvaluationResult(
          result,
          DETROIT_DLSS_RESULT_FALLBACK,
          MakeAdapterBridgeDetail(false, commit_result.detail),
          frame_id);
      return DETROIT_DLSS_RESULT_FALLBACK;
    }
    if (!spatial_diagnostic_logged.exchange(true, std::memory_order_acq_rel)) {
      Trace(
          "Diagnostic spatial output is active: prepared CurrColor is being "
          "scaled into b16 without NGX evaluation");
    }
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_SUCCESS,
        BridgeDetail::kNone,
        frame_id,
        DETROIT_DLSS_EVALUATE_OUTPUT_VALID);
    return DETROIT_DLSS_RESULT_SUCCESS;
  }

  auto color = MakeNgxResource(prepared_frame.color, VK_IMAGE_ASPECT_COLOR_BIT, false);
  auto depth = MakeNgxResource(prepared_frame.depth, VK_IMAGE_ASPECT_DEPTH_BIT, false);
  auto motion_vectors =
      MakeNgxResource(prepared_frame.motion_vectors, VK_IMAGE_ASPECT_COLOR_BIT, false);
  auto output = MakeNgxResource(prepared_frame.output, VK_IMAGE_ASPECT_COLOR_BIT, true);
  auto exposure = auto_exposure
                      ? NVSDK_NGX_Resource_VK{}
                      : MakeNgxResource(inputs->exposure, VK_IMAGE_ASPECT_COLOR_BIT, false);

  NVSDK_NGX_VK_DLSS_Eval_Params evaluation = {};
  evaluation.Feature.pInColor = &color;
  evaluation.Feature.pInOutput = &output;
  evaluation.pInDepth = &depth;
  evaluation.pInMotionVectors = &motion_vectors;
  evaluation.pInExposureTexture = auto_exposure ? nullptr : &exposure;
  evaluation.InJitterOffsetX = inputs->jitter_x;
  evaluation.InJitterOffsetY = inputs->jitter_y;
  evaluation.InRenderSubrectDimensions = {inputs->render_width, inputs->render_height};
  evaluation.InReset = inputs->reset != 0u
                       || (inputs->flags
                           & (DETROIT_DLSS_FRAME_CAMERA_CUT
                              | DETROIT_DLSS_FRAME_SCENE_LOADED))
                              != 0u;
  evaluation.InMVScaleX = inputs->motion_vector_scale_x;
  evaluation.InMVScaleY = inputs->motion_vector_scale_y;
  evaluation.InPreExposure = inputs->pre_exposure;
  evaluation.InExposureScale = 1.f;

  state->feature_lifetime.RecordFeatureUse(
      ToOpaque(command_buffer), active_feature->generation);
  const auto evaluate_result = NGX_VULKAN_EVALUATE_DLSS_EXT(
      command_buffer,
      active_feature->feature,
      active_feature->parameters,
      &evaluation);
  const bool ngx_succeeded = NVSDK_NGX_SUCCEED(evaluate_result);
  const auto commit_result =
      state->adapter_runtime.CommitAfterNgx(prepared_frame, ngx_succeeded);
  // Commit may write b16, so no fallible decision is allowed after this point.
  // The restore contract was proved before any adapter/NGX commands were
  // recorded and these Vulkan bind calls have no failure return.
  (void)RestoreComputeCommandState(state.get(), command_buffer, *restore_state);
  if (NVSDK_NGX_FAILED(evaluate_result)) {
    TraceNgxFailureOnce(state.get(), 2u, "evaluation", evaluate_result);
    SetEvaluationResult(
        result, DETROIT_DLSS_RESULT_FALLBACK, BridgeDetail::kEvaluationFailed, frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  if (!commit_result.Succeeded()) {
    TraceAdapterFailureOnce(state.get(), false, commit_result);
    SetEvaluationResult(
        result,
        DETROIT_DLSS_RESULT_FALLBACK,
        MakeAdapterBridgeDetail(false, commit_result.detail),
        frame_id);
    return DETROIT_DLSS_RESULT_FALLBACK;
  }

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
  tracked.set_layouts.assign(
      create_info->pSetLayouts, create_info->pSetLayouts + create_info->setLayoutCount);
  const std::lock_guard lock(state->tracking_mutex);
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
         || !layout->second.temporal_candidate) {
      continue;
    }
    state->descriptor_sets[ToOpaque(descriptor_sets[index])] = {
        allocate_info->descriptorPool, allocate_info->pSetLayouts[index], {}};
    if (layout->second.temporal_candidate) {
      MarkTemporalDescriptorSet(state.get(), descriptor_sets[index]);
    }
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
      may_touch_tracked_set |=
          MayBeTemporalDescriptorSet(*state, descriptor_writes[index].dstSet);
    }
  }
  if (!may_touch_tracked_set && descriptor_copies != nullptr) {
    for (std::uint32_t index = 0u; index < descriptor_copy_count; ++index) {
      may_touch_tracked_set |=
          MayBeTemporalDescriptorSet(*state, descriptor_copies[index].srcSet)
          || MayBeTemporalDescriptorSet(*state, descriptor_copies[index].dstSet);
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

FeatureSubmissionSnapshot CaptureFeatureSubmission(
    DeviceState* state, const std::vector<VkCommandBuffer>& command_buffers) {
  std::vector<std::uint64_t> handles;
  handles.reserve(command_buffers.size());
  for (const VkCommandBuffer command_buffer : command_buffers) {
    handles.push_back(ToOpaque(command_buffer));
  }
  const std::lock_guard lock(state->mutex);
  return state->feature_lifetime.CaptureSubmission(handles);
}

void RecycleCompletedCommandBuffers(
    DeviceState* state, const std::vector<std::uint64_t>& command_buffers) {
  if (state == nullptr) return;
  for (const std::uint64_t command_buffer : command_buffers) {
    state->adapter_runtime.RecycleCommandBuffer(
        FromOpaque<VkCommandBuffer>(command_buffer));
  }
}

void CommitFeatureSubmission(
    DeviceState* state,
    VkQueue queue,
    VkFence fence,
    const FeatureSubmissionSnapshot& snapshot) {
  if (snapshot.Empty()) return;
  std::vector<std::uint64_t> completed_command_buffers;
  {
    const std::lock_guard lock(state->mutex);
    const auto committed =
        state->feature_lifetime.CommitSuccessfulSubmit(ToOpaque(queue), snapshot);
    for (auto& [generation, feature] : state->feature_generations) {
      if (!feature.creation.submitted
          && renodx::games::detroitbecomehuman::dlss::FeatureLifetimeTracker::
              SubmissionContains(
                  committed, feature.creation.command_buffer, generation)) {
        feature.creation.MarkSubmitted();
      }
    }

    if (fence != VK_NULL_HANDLE && !committed.Empty()) {
      const auto fence_key = ToOpaque(fence);
      const auto previous = state->fenced_feature_submissions.find(fence_key);
      if (previous != state->fenced_feature_submissions.end()) {
        // Valid Vulkan fence reuse requires the previous submission to have
        // completed and the fence to have been reset. Complete defensively in
        // case the reset was reached through an untracked dispatch path.
        auto stale = state->feature_lifetime.CompleteSubmission(
            previous->second.queue, previous->second.snapshot);
        completed_command_buffers.insert(
            completed_command_buffers.end(), stale.begin(), stale.end());
        state->fenced_feature_submissions.erase(previous);
      }
      state->fenced_feature_submissions.emplace(
          fence_key,
          FencedFeatureSubmission{
              .queue = ToOpaque(queue),
              .snapshot = committed,
          });
    }
    CollectRetiredFeaturesLocked(state);
  }
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
}

void CompleteFeatureQueue(DeviceState* state, VkQueue queue) {
  std::vector<std::uint64_t> completed_command_buffers;
  {
    const std::lock_guard lock(state->mutex);
    const auto queue_key = ToOpaque(queue);
    completed_command_buffers = state->feature_lifetime.CompleteQueue(queue_key);
    std::erase_if(
        state->fenced_feature_submissions,
        [queue_key](const auto& entry) {
          return entry.second.queue == queue_key;
        });
    CollectRetiredFeaturesLocked(state);
  }
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
}

void CompleteFeatureDevice(DeviceState* state) {
  std::vector<std::uint64_t> completed_command_buffers;
  {
    const std::lock_guard lock(state->mutex);
    completed_command_buffers = state->feature_lifetime.CompleteDevice();
    state->fenced_feature_submissions.clear();
    CollectRetiredFeaturesLocked(state);
  }
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
}

void CompleteFeatureFence(DeviceState* state, VkFence fence) {
  if (state == nullptr || fence == VK_NULL_HANDLE) return;
  std::vector<std::uint64_t> completed_command_buffers;
  {
    const std::lock_guard lock(state->mutex);
    const auto found = state->fenced_feature_submissions.find(ToOpaque(fence));
    if (found == state->fenced_feature_submissions.end()) return;
    auto submission = std::move(found->second);
    state->fenced_feature_submissions.erase(found);
    completed_command_buffers = state->feature_lifetime.CompleteSubmission(
        submission.queue, submission.snapshot);
    CollectRetiredFeaturesLocked(state);
  }
  RecycleCompletedCommandBuffers(state, completed_command_buffers);
}

VKAPI_ATTR VkResult VKAPI_CALL LayerQueueSubmit(
    VkQueue queue,
    std::uint32_t submit_count,
    const VkSubmitInfo* submits,
    VkFence fence) {
  auto* state = FindDeviceFast(queue);
  if (state == nullptr || state->next_queue_submit == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  if (!state->feature_submission_tracking_active.load(std::memory_order_acquire)) {
    return state->next_queue_submit(queue, submit_count, submits, fence);
  }

  std::vector<VkCommandBuffer> command_buffers;
  if (submits != nullptr) {
    for (std::uint32_t submit_index = 0u; submit_index < submit_count; ++submit_index) {
      const auto& submit = submits[submit_index];
      if (submit.pCommandBuffers == nullptr) continue;
      command_buffers.insert(
          command_buffers.end(),
          submit.pCommandBuffers,
          submit.pCommandBuffers + submit.commandBufferCount);
    }
  }
  const auto snapshot = CaptureFeatureSubmission(state, command_buffers);
  const VkResult result =
      state->next_queue_submit(queue, submit_count, submits, fence);
  if (result == VK_SUCCESS) {
    CommitFeatureSubmission(state, queue, fence, snapshot);
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
  if (!state->feature_submission_tracking_active.load(std::memory_order_acquire)) {
    return state->next_queue_submit2(queue, submit_count, submits, fence);
  }

  std::vector<VkCommandBuffer> command_buffers;
  if (submits != nullptr) {
    for (std::uint32_t submit_index = 0u; submit_index < submit_count; ++submit_index) {
      const auto& submit = submits[submit_index];
      if (submit.pCommandBufferInfos == nullptr) continue;
      for (std::uint32_t command_index = 0u;
           command_index < submit.commandBufferInfoCount;
           ++command_index) {
        command_buffers.push_back(
            submit.pCommandBufferInfos[command_index].commandBuffer);
      }
    }
  }
  const auto snapshot = CaptureFeatureSubmission(state, command_buffers);
  const VkResult result =
      state->next_queue_submit2(queue, submit_count, submits, fence);
  if (result == VK_SUCCESS) {
    CommitFeatureSubmission(state, queue, fence, snapshot);
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
  if (!state->feature_submission_tracking_active.load(std::memory_order_acquire)) {
    return state->next_queue_submit2_khr(queue, submit_count, submits, fence);
  }

  std::vector<VkCommandBuffer> command_buffers;
  if (submits != nullptr) {
    for (std::uint32_t submit_index = 0u; submit_index < submit_count; ++submit_index) {
      const auto& submit = submits[submit_index];
      if (submit.pCommandBufferInfos == nullptr) continue;
      for (std::uint32_t command_index = 0u;
           command_index < submit.commandBufferInfoCount;
           ++command_index) {
        command_buffers.push_back(
            submit.pCommandBufferInfos[command_index].commandBuffer);
      }
    }
  }
  const auto snapshot = CaptureFeatureSubmission(state, command_buffers);
  const VkResult result =
      state->next_queue_submit2_khr(queue, submit_count, submits, fence);
  if (result == VK_SUCCESS) {
    CommitFeatureSubmission(state, queue, fence, snapshot);
  }
  return result;
}
#endif

VKAPI_ATTR VkResult VKAPI_CALL LayerQueueWaitIdle(VkQueue queue) {
  auto* state = FindDeviceFast(queue);
  if (state == nullptr || state->next_queue_wait_idle == nullptr) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  const VkResult result = state->next_queue_wait_idle(queue);
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
      const auto key = ToOpaque(command_buffer);
      state->command_buffer_descriptors.erase(key);
      state->command_buffer_restore_states.erase(key);
    }
  }

  // A successful pool reset guarantees that none of its command buffers are
  // pending and invalidates all their old recordings. Do not hold the layer
  // tracking mutex while taking the adapter mutex.
  auto& thread_states = GetThreadComputeCommandStates();
  for (const auto command_buffer : command_buffers) {
    state->adapter_runtime.RecycleCommandBuffer(command_buffer);
    thread_states.erase(ToOpaque(command_buffer));
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
      state->command_buffer_descriptors.erase(key);
      state->command_buffer_restore_states.erase(key);
    }
    state->command_pools.erase(pool_key);
  }
  auto& thread_states = GetThreadComputeCommandStates();
  for (const auto command_buffer : command_buffers) {
    (void)state->adapter_runtime.RetireCommandBuffer(command_buffer);
    thread_states.erase(ToOpaque(command_buffer));
  }
  trampoline(device, command_pool, allocator);
  DiscardFeatureCommandBuffers(state, command_buffers);
}

VKAPI_ATTR VkResult VKAPI_CALL LayerBeginCommandBuffer(
    VkCommandBuffer command_buffer, const VkCommandBufferBeginInfo* begin_info) {
  auto* state = FindDeviceFast(command_buffer);
  if (state == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const auto trampoline = state->next_begin_command_buffer;
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  const VkResult result = trampoline(command_buffer, begin_info);
  if (result == VK_SUCCESS) {
    state->adapter_runtime.NotifyCommandBufferBegin(command_buffer);
    GetThreadComputeCommandStates().erase(ToOpaque(command_buffer));
    {
      const std::lock_guard lock(state->tracking_mutex);
      state->command_buffer_descriptors.erase(ToOpaque(command_buffer));
      state->command_buffer_restore_states.erase(ToOpaque(command_buffer));
    }
    {
      const std::lock_guard lock(state->mutex);
      InvalidateUnsubmittedFeatureCreationsLocked(
          state, {ToOpaque(command_buffer)});
      state->feature_lifetime.BeginCommandBuffer(
          ToOpaque(command_buffer),
          begin_info != nullptr
              && (begin_info->flags & VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT)
                     != 0u);
      CollectRetiredFeaturesLocked(state);
    }
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
    state->adapter_runtime.RecycleCommandBuffer(command_buffer);
    GetThreadComputeCommandStates().erase(ToOpaque(command_buffer));
    {
      const std::lock_guard lock(state->tracking_mutex);
      state->command_buffer_descriptors.erase(ToOpaque(command_buffer));
      state->command_buffer_restore_states.erase(ToOpaque(command_buffer));
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
  if (command_buffers != nullptr) {
    for (std::uint32_t index = 0u; index < command_buffer_count; ++index) {
      (void)state->adapter_runtime.RetireCommandBuffer(command_buffers[index]);
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
      state->command_buffer_descriptors.erase(ToOpaque(command_buffers[index]));
      state->command_buffer_restore_states.erase(ToOpaque(command_buffers[index]));
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
  auto* state = FindDeviceFast(command_buffer);
  if (state == nullptr) return;
  const auto trampoline = state->next_cmd_bind_pipeline;
  if (trampoline == nullptr) return;
  trampoline(command_buffer, pipeline_bind_point, pipeline);
  if (pipeline_bind_point != VK_PIPELINE_BIND_POINT_COMPUTE) return;

  const std::uint64_t command_buffer_handle = ToOpaque(command_buffer);
  auto& local = GetThreadComputeCommandStates()[command_buffer_handle];
  local.pipeline = pipeline;
  if (!local.temporal_descriptor_set_bound) return;
  const std::lock_guard lock(state->tracking_mutex);
  const auto restore =
      state->command_buffer_restore_states.find(command_buffer_handle);
  if (restore != state->command_buffer_restore_states.end()) {
    restore->second.pipeline = pipeline;
  }
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

  const std::uint64_t command_buffer_handle = ToOpaque(command_buffer);
  auto& local = GetThreadComputeCommandStates()[command_buffer_handle];
  const bool updates_temporal_set = first_set == DETROIT_DLSS_TAA_DESCRIPTOR_SET
                                    && descriptor_set_count != 0u;
  if (!updates_temporal_set) return;

  const bool may_bind_temporal_set =
      MayBeTemporalDescriptorSet(*state, descriptor_sets[0u]);
  if (!may_bind_temporal_set) {
    if (!local.temporal_descriptor_set_bound) return;
    local.temporal_descriptor_set_bound = false;
    const std::lock_guard lock(state->tracking_mutex);
    state->command_buffer_descriptors.erase(command_buffer_handle);
    state->command_buffer_restore_states.erase(command_buffer_handle);
    return;
  }

  const std::lock_guard lock(state->tracking_mutex);
  const auto descriptor_set =
      state->descriptor_sets.find(ToOpaque(descriptor_sets[0u]));
  if (descriptor_set == state->descriptor_sets.end()) {
    local.temporal_descriptor_set_bound = false;
    state->command_buffer_descriptors.erase(command_buffer_handle);
    state->command_buffer_restore_states.erase(command_buffer_handle);
    return;
  }
  const auto descriptor_layout =
      state->descriptor_set_layouts.find(ToOpaque(descriptor_set->second.layout));
  if (descriptor_layout == state->descriptor_set_layouts.end()
      || !descriptor_layout->second.temporal_candidate) {
    local.temporal_descriptor_set_bound = false;
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
  local.temporal_descriptor_set_bound = true;
}

PFN_vkVoidFunction FindTrackedDeviceFunction(const char* name) {
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
  if (std::strcmp(name, "vkCmdBindDescriptorSets") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCmdBindDescriptorSets);
  }
  if (std::strcmp(name, "vkCmdBindPipeline") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&LayerCmdBindPipeline);
  }
  return nullptr;
}

void DETROIT_DLSS_CALL BridgeShutdown() {
  const auto state = GetActiveDevice();
  if (state != nullptr) RequestNgxShutdown(state.get());
}

}  // namespace

extern "C" __declspec(dllexport) DetroitDlssResultCode DETROIT_DLSS_CALL
DetroitDlssGetApi(std::uint32_t requested_version, DetroitDlssApiV2* api) {
  if (api == nullptr || api->struct_size < sizeof(*api)
      || requested_version != DETROIT_DLSS_ABI_VERSION) {
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

extern "C" __declspec(dllexport) VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL
vkGetDeviceProcAddr(VkDevice device, const char* name);
extern "C" __declspec(dllexport) VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL
vkGetInstanceProcAddr(VkInstance instance, const char* name);

extern "C" __declspec(dllexport) VKAPI_ATTR VkResult VKAPI_CALL vkCreateInstance(
    const VkInstanceCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkInstance* instance) {
  Trace("vkCreateInstance: enter");
  if (create_info == nullptr || instance == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  auto* link_info = FindLayerCreateInfo<VkLayerInstanceCreateInfo>(
      create_info->pNext, VK_STRUCTURE_TYPE_LOADER_INSTANCE_CREATE_INFO);
  if (link_info == nullptr || link_info->u.pLayerInfo == nullptr) {
    Trace("vkCreateInstance: missing loader link info");
    return VK_ERROR_INITIALIZATION_FAILED;
  }

  const auto next_get_instance_proc_addr =
      link_info->u.pLayerInfo->pfnNextGetInstanceProcAddr;
  const auto trampoline = reinterpret_cast<PFN_vkCreateInstance>(
      next_get_instance_proc_addr(VK_NULL_HANDLE, "vkCreateInstance"));
  link_info->u.pLayerInfo = link_info->u.pLayerInfo->pNext;
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;

  const bool supported_executable = IsSupportedHostExecutable();
  bool ngx_extensions_enabled = false;
  std::vector<std::string> extension_storage;
  std::vector<const char*> enabled_extensions;
  VkInstanceCreateInfo amended_create_info = *create_info;
  if (supported_executable) {
    Trace("vkCreateInstance: read launcher-cached NGX instance extensions");
    std::vector<std::string> required;
    ngx_extensions_enabled = ReadCachedNgxExtensions(
                                 kCachedInstanceExtensionsEnvironment, &required)
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
              ? "vkCreateInstance: NGX instance extensions appended"
              : "vkCreateInstance: NGX instance extensions unavailable; native fallback");
  }

  Trace("vkCreateInstance: call next layer");
  const VkResult result = trampoline(&amended_create_info, allocator, instance);
  Trace(result == VK_SUCCESS ? "vkCreateInstance: next layer succeeded"
                             : "vkCreateInstance: next layer failed");
  if (result == VK_SUCCESS) {
    auto state = std::make_shared<InstanceState>();
    state->instance = *instance;
    state->next_get_instance_proc_addr = next_get_instance_proc_addr;
    state->ngx_extensions_enabled = ngx_extensions_enabled;
    const std::lock_guard lock(state_mutex);
    instances[DispatchKey(*instance)] = std::move(state);
  }
  return result;
}

extern "C" __declspec(dllexport) VKAPI_ATTR void VKAPI_CALL vkDestroyInstance(
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

extern "C" __declspec(dllexport) VKAPI_ATTR VkResult VKAPI_CALL vkCreateDevice(
    VkPhysicalDevice physical_device,
    const VkDeviceCreateInfo* create_info,
    const VkAllocationCallbacks* allocator,
    VkDevice* device) {
  Trace("vkCreateDevice: enter");
  if (create_info == nullptr || device == nullptr) return VK_ERROR_INITIALIZATION_FAILED;
  auto* link_info = FindLayerCreateInfo<VkLayerDeviceCreateInfo>(
      create_info->pNext, VK_STRUCTURE_TYPE_LOADER_DEVICE_CREATE_INFO);
  const auto instance_state = FindInstance(physical_device);
  if (link_info == nullptr || link_info->u.pLayerInfo == nullptr || instance_state == nullptr) {
    Trace("vkCreateDevice: missing loader link or instance state");
    return VK_ERROR_INITIALIZATION_FAILED;
  }

  const auto next_get_instance_proc_addr =
      link_info->u.pLayerInfo->pfnNextGetInstanceProcAddr;
  const auto next_get_device_proc_addr = link_info->u.pLayerInfo->pfnNextGetDeviceProcAddr;
  const auto trampoline = reinterpret_cast<PFN_vkCreateDevice>(
      next_get_instance_proc_addr(instance_state->instance, "vkCreateDevice"));
  link_info->u.pLayerInfo = link_info->u.pLayerInfo->pNext;
  if (trampoline == nullptr) return VK_ERROR_INITIALIZATION_FAILED;

  bool ngx_extensions_enabled = false;
  std::vector<std::string> extension_storage;
  std::vector<const char*> enabled_extensions;
  VkDeviceCreateInfo amended_create_info = *create_info;
  if (instance_state->ngx_extensions_enabled) {
    Trace("vkCreateDevice: read launcher-cached NGX device extensions");
    std::vector<std::string> required;
    ngx_extensions_enabled = ReadCachedNgxExtensions(
                                 kCachedDeviceExtensionsEnvironment, &required)
                             && PhysicalDeviceSupportsRequiredExtensions(
                                 next_get_instance_proc_addr,
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

  Trace("vkCreateDevice: call next layer");
  const VkResult result = trampoline(physical_device, &amended_create_info, allocator, device);
  Trace(result == VK_SUCCESS ? "vkCreateDevice: next layer succeeded"
                             : "vkCreateDevice: next layer failed");
  if (result != VK_SUCCESS) return result;

  auto state = std::make_shared<DeviceState>();
  state->instance = instance_state->instance;
  state->physical_device = physical_device;
  state->device = *device;
  state->next_get_instance_proc_addr = next_get_instance_proc_addr;
  state->next_get_device_proc_addr = next_get_device_proc_addr;
  state->next_update_descriptor_sets =
      reinterpret_cast<PFN_vkUpdateDescriptorSets>(
          next_get_device_proc_addr(*device, "vkUpdateDescriptorSets"));
  state->next_map_memory = reinterpret_cast<PFN_vkMapMemory>(
      next_get_device_proc_addr(*device, "vkMapMemory"));
  state->next_unmap_memory = reinterpret_cast<PFN_vkUnmapMemory>(
      next_get_device_proc_addr(*device, "vkUnmapMemory"));
  state->next_begin_command_buffer =
      reinterpret_cast<PFN_vkBeginCommandBuffer>(
          next_get_device_proc_addr(*device, "vkBeginCommandBuffer"));
  state->next_reset_command_buffer =
      reinterpret_cast<PFN_vkResetCommandBuffer>(
          next_get_device_proc_addr(*device, "vkResetCommandBuffer"));
  state->next_queue_submit = reinterpret_cast<PFN_vkQueueSubmit>(
      next_get_device_proc_addr(*device, "vkQueueSubmit"));
#if defined(VK_VERSION_1_3)
  state->next_queue_submit2 = reinterpret_cast<PFN_vkQueueSubmit2>(
      next_get_device_proc_addr(*device, "vkQueueSubmit2"));
#endif
#if defined(VK_KHR_synchronization2)
  state->next_queue_submit2_khr = reinterpret_cast<PFN_vkQueueSubmit2KHR>(
      next_get_device_proc_addr(*device, "vkQueueSubmit2KHR"));
#endif
  state->next_queue_wait_idle = reinterpret_cast<PFN_vkQueueWaitIdle>(
      next_get_device_proc_addr(*device, "vkQueueWaitIdle"));
  state->next_device_wait_idle = reinterpret_cast<PFN_vkDeviceWaitIdle>(
      next_get_device_proc_addr(*device, "vkDeviceWaitIdle"));
  state->next_wait_for_fences = reinterpret_cast<PFN_vkWaitForFences>(
      next_get_device_proc_addr(*device, "vkWaitForFences"));
  state->next_get_fence_status = reinterpret_cast<PFN_vkGetFenceStatus>(
      next_get_device_proc_addr(*device, "vkGetFenceStatus"));
  state->next_reset_fences = reinterpret_cast<PFN_vkResetFences>(
      next_get_device_proc_addr(*device, "vkResetFences"));
  state->next_destroy_fence = reinterpret_cast<PFN_vkDestroyFence>(
      next_get_device_proc_addr(*device, "vkDestroyFence"));
  state->next_create_command_pool = reinterpret_cast<PFN_vkCreateCommandPool>(
      next_get_device_proc_addr(*device, "vkCreateCommandPool"));
  state->next_allocate_command_buffers =
      reinterpret_cast<PFN_vkAllocateCommandBuffers>(
          next_get_device_proc_addr(*device, "vkAllocateCommandBuffers"));
  state->next_free_command_buffers =
      reinterpret_cast<PFN_vkFreeCommandBuffers>(
          next_get_device_proc_addr(*device, "vkFreeCommandBuffers"));
  state->next_reset_command_pool =
      reinterpret_cast<PFN_vkResetCommandPool>(
          next_get_device_proc_addr(*device, "vkResetCommandPool"));
  state->next_destroy_command_pool =
      reinterpret_cast<PFN_vkDestroyCommandPool>(
          next_get_device_proc_addr(*device, "vkDestroyCommandPool"));
  state->next_cmd_bind_pipeline = reinterpret_cast<PFN_vkCmdBindPipeline>(
      next_get_device_proc_addr(*device, "vkCmdBindPipeline"));
  state->next_cmd_bind_descriptor_sets =
      reinterpret_cast<PFN_vkCmdBindDescriptorSets>(
          next_get_device_proc_addr(*device, "vkCmdBindDescriptorSets"));
  state->supported_executable = IsSupportedHostExecutable();
  state->ngx_extensions_enabled = ngx_extensions_enabled;
  state->identity = next_device_identity.fetch_add(1u, std::memory_order_relaxed);

  const auto get_memory_properties =
      reinterpret_cast<PFN_vkGetPhysicalDeviceMemoryProperties>(
          next_get_instance_proc_addr(
              instance_state->instance, "vkGetPhysicalDeviceMemoryProperties"));
  if (get_memory_properties != nullptr) {
    Trace("vkCreateDevice: query memory properties");
    get_memory_properties(physical_device, &state->memory_properties);
  }

  const auto get_queue_family_properties =
      reinterpret_cast<PFN_vkGetPhysicalDeviceQueueFamilyProperties>(
          next_get_instance_proc_addr(
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
        next_get_device_proc_addr(*device, "vkGetDeviceQueue"));
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
      .maximum_scratch_bundles = 8u,
  });
  state->adapter_available = adapter_result.Succeeded();
  Trace(state->adapter_available
            ? "vkCreateDevice: DLSS format adapter initialized"
            : "vkCreateDevice: DLSS format adapter unavailable; native fallback");

  {
    const std::lock_guard lock(state_mutex);
    devices[DispatchKey(*device)] = state;
    if (state->supported_executable && state->graphics_queue != VK_NULL_HANDLE
        && active_device.expired()) {
      active_device = state;
    }
    device_registry_generation.fetch_add(1u, std::memory_order_release);
  }
  Trace("vkCreateDevice: state installed; return success");
  return VK_SUCCESS;
}

extern "C" __declspec(dllexport) VKAPI_ATTR void VKAPI_CALL vkDestroyDevice(
    VkDevice device,
    const VkAllocationCallbacks* allocator) {
  const auto state = FindDevice(device);
  if (state == nullptr) return;
  const auto trampoline = reinterpret_cast<PFN_vkDestroyDevice>(
      state->next_get_device_proc_addr(device, "vkDestroyDevice"));
  state->destroying.store(true, std::memory_order_release);
  {
    const std::lock_guard lock(state_mutex);
    if (active_device.lock() == state) active_device.reset();
    devices.erase(DispatchKey(device));
    device_registry_generation.fetch_add(1u, std::memory_order_release);
  }
  if (state->next_device_wait_idle != nullptr) {
    (void)state->next_device_wait_idle(device);
  }
  // vkDestroyDevice is the terminal boundary: no recorded command buffer can
  // be submitted after this call. A device-lost idle result does not change
  // that guarantee, so all deferred generations can now be released.
  ForceShutdownNgxForDeviceDestroy(state.get());
  state->adapter_runtime.Shutdown();
  state->adapter_available = false;
  if (trampoline != nullptr) trampoline(device, allocator);
}

extern "C" __declspec(dllexport) VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL
vkGetDeviceProcAddr(VkDevice device, const char* name) {
  if (name == nullptr) return nullptr;
  if (std::strcmp(name, "vkGetDeviceProcAddr") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&vkGetDeviceProcAddr);
  }
  if (device == VK_NULL_HANDLE) return nullptr;
  const auto state = FindDevice(device);
  if (state == nullptr) return nullptr;
  const auto downstream = state->next_get_device_proc_addr(device, name);
  if (downstream == nullptr) return nullptr;
  if (std::strcmp(name, "vkDestroyDevice") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&vkDestroyDevice);
  }
  if (const auto tracked = FindTrackedDeviceFunction(name); tracked != nullptr) return tracked;
  return downstream;
}

extern "C" __declspec(dllexport) VKAPI_ATTR PFN_vkVoidFunction VKAPI_CALL
vkGetInstanceProcAddr(VkInstance instance, const char* name) {
  if (name == nullptr) return nullptr;
  if (std::strcmp(name, "vkGetInstanceProcAddr") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&vkGetInstanceProcAddr);
  }
  if (std::strcmp(name, "vkCreateInstance") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&vkCreateInstance);
  }
  if (std::strcmp(name, "vkCreateDevice") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&vkCreateDevice);
  }
  if (instance == VK_NULL_HANDLE) return nullptr;
  const auto state = FindInstance(instance);
  if (state == nullptr) return nullptr;
  const auto downstream = state->next_get_instance_proc_addr(instance, name);
  if (downstream == nullptr) return nullptr;
  if (std::strcmp(name, "vkDestroyInstance") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&vkDestroyInstance);
  }
  if (std::strcmp(name, "vkDestroyDevice") == 0) {
    return reinterpret_cast<PFN_vkVoidFunction>(&vkDestroyDevice);
  }
  if (const auto tracked = FindTrackedDeviceFunction(name); tracked != nullptr) return tracked;
  return downstream;
}

extern "C" VKAPI_ATTR VkResult VKAPI_CALL
vkNegotiateLoaderLayerInterfaceVersion(VkNegotiateLayerInterface* version) {
  if (version == nullptr || version->sType != LAYER_NEGOTIATE_INTERFACE_STRUCT) {
    return VK_ERROR_INITIALIZATION_FAILED;
  }
  version->loaderLayerInterfaceVersion = std::min(version->loaderLayerInterfaceVersion, 2u);
  version->pfnGetInstanceProcAddr = &vkGetInstanceProcAddr;
  version->pfnGetDeviceProcAddr = &vkGetDeviceProcAddr;
  version->pfnGetPhysicalDeviceProcAddr = nullptr;
  return VK_SUCCESS;
}

BOOL WINAPI DllMain(HINSTANCE module, DWORD reason, LPVOID) {
  if (reason == DLL_PROCESS_ATTACH) layer_module = module;
  return TRUE;
}
