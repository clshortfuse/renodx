/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <cstdint>
#include <memory>
#include <string>
#include <vector>

#include <vulkan/vulkan.h>

#include <nvsdk_ngx_helpers_vk.h>

#include "feature_lifetime.hpp"

namespace renodx::utils::dlss::vulkan {

struct TrackedImageState final {
  VkImage image = VK_NULL_HANDLE;
  VkImageView image_view = VK_NULL_HANDLE;
  VkImageSubresourceRange range = {};
  VkFormat format = VK_FORMAT_UNDEFINED;
  VkImageUsageFlags usage = 0u;
  VkImageLayout layout = VK_IMAGE_LAYOUT_UNDEFINED;
  VkPipelineStageFlags stage = 0u;
  VkAccessFlags access = 0u;
  std::uint32_t queue_family = VK_QUEUE_FAMILY_IGNORED;
  bool contents_valid = false;

  [[nodiscard]] bool operator==(const TrackedImageState& other) const noexcept {
    return image == other.image && image_view == other.image_view
           && range.aspectMask == other.range.aspectMask
           && range.baseMipLevel == other.range.baseMipLevel
           && range.levelCount == other.range.levelCount
           && range.baseArrayLayer == other.range.baseArrayLayer
           && range.layerCount == other.range.layerCount
           && format == other.format && usage == other.usage
           && layout == other.layout && stage == other.stage
           && access == other.access && queue_family == other.queue_family
           && contents_valid == other.contents_valid;
  }
};

struct ImageResource final {
  NVSDK_NGX_Resource_VK ngx = {};
  TrackedImageState state = {};
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;
};

struct FeatureConfig final {
  NVSDK_NGX_PerfQuality_Value mode = NVSDK_NGX_PerfQuality_Value_MaxQuality;
  std::uint32_t render_width = 0u;
  std::uint32_t render_height = 0u;
  std::uint32_t output_width = 0u;
  std::uint32_t output_height = 0u;
  std::uint32_t create_flags = 0u;
  std::array<NVSDK_NGX_DLSS_Hint_Render_Preset, 6u> presets = {
      NVSDK_NGX_DLSS_Hint_Render_Preset_Default,
      NVSDK_NGX_DLSS_Hint_Render_Preset_Default,
      NVSDK_NGX_DLSS_Hint_Render_Preset_Default,
      NVSDK_NGX_DLSS_Hint_Render_Preset_Default,
      NVSDK_NGX_DLSS_Hint_Render_Preset_Default,
      NVSDK_NGX_DLSS_Hint_Render_Preset_Default,
  };

  bool operator==(const FeatureConfig&) const = default;
};

struct ModeQuery final {
  NVSDK_NGX_PerfQuality_Value mode = NVSDK_NGX_PerfQuality_Value_MaxQuality;
  std::uint32_t output_width = 0u;
  std::uint32_t output_height = 0u;
};

struct ModeSettings final {
  std::uint32_t optimal_width = 0u;
  std::uint32_t optimal_height = 0u;
  std::uint32_t minimum_width = 0u;
  std::uint32_t minimum_height = 0u;
  std::uint32_t maximum_width = 0u;
  std::uint32_t maximum_height = 0u;
  float sharpness = 0.f;
};

struct EvaluateInfo final {
  std::uint64_t recording_key = 0u;
  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  const ImageResource* color = nullptr;
  const ImageResource* depth = nullptr;
  const ImageResource* motion_vectors = nullptr;
  const ImageResource* output = nullptr;
  const ImageResource* exposure = nullptr;
  float jitter_x = 0.f;
  float jitter_y = 0.f;
  float motion_vector_scale_x = 1.f;
  float motion_vector_scale_y = 1.f;
  float pre_exposure = 1.f;
  float exposure_scale = 1.f;
  std::uint32_t render_width = 0u;
  std::uint32_t render_height = 0u;
  bool one_time_submit = false;
  bool reset = false;
};

enum class OperationStage : std::uint8_t {
  kNone,
  kInitialize,
  kCapabilities,
  kQueryMode,
  kAllocateParameters,
  kCreateCommandPool,
  kAllocateCommandBuffer,
  kBeginCommandBuffer,
  kCreateFeature,
  kEndCommandBuffer,
  kCreateFence,
  kSubmitFeature,
  kWaitFeature,
  kFeatureReady,
  kEvaluate,
  kReleaseFeature,
  kShutdown,
};

struct OperationResult final {
  OperationStage stage = OperationStage::kNone;
  NVSDK_NGX_Result ngx_result = NVSDK_NGX_Result_Success;
  VkResult vk_result = VK_SUCCESS;
  std::uint64_t feature_generation = 0u;
  std::uint64_t recording_epoch = 0u;
  bool one_time_submit = false;
  bool feature_created = false;
  bool output_valid = false;

  [[nodiscard]] bool Succeeded() const noexcept {
    return NVSDK_NGX_SUCCEED(ngx_result) && vk_result == VK_SUCCESS;
  }
};

struct NgxDispatchTable final {
  void* context = nullptr;
  NVSDK_NGX_Result (*initialize_project)(
      void*,
      const char*,
      NVSDK_NGX_EngineType,
      const char*,
      const wchar_t*,
      VkInstance,
      VkPhysicalDevice,
      VkDevice,
      PFN_vkGetInstanceProcAddr,
      PFN_vkGetDeviceProcAddr,
      const NVSDK_NGX_FeatureCommonInfo*,
      NVSDK_NGX_Version) = nullptr;
  NVSDK_NGX_Result (*get_capability_parameters)(
      void*, NVSDK_NGX_Parameter**) = nullptr;
  NVSDK_NGX_Result (*get_parameter_i)(
      void*, NVSDK_NGX_Parameter*, const char*, int*) = nullptr;
  NVSDK_NGX_Result (*query_mode)(
      void*, NVSDK_NGX_Parameter*, const ModeQuery*, ModeSettings*) = nullptr;
  NVSDK_NGX_Result (*allocate_parameters)(
      void*, NVSDK_NGX_Parameter**) = nullptr;
  NVSDK_NGX_Result (*destroy_parameters)(
      void*, NVSDK_NGX_Parameter*) = nullptr;
  NVSDK_NGX_Result (*create_feature)(
      void*,
      VkDevice,
      VkCommandBuffer,
      NVSDK_NGX_Handle**,
      NVSDK_NGX_Parameter*,
      const FeatureConfig*) = nullptr;
  NVSDK_NGX_Result (*evaluate_feature)(
      void*,
      VkCommandBuffer,
      NVSDK_NGX_Handle*,
      NVSDK_NGX_Parameter*,
      const EvaluateInfo*) = nullptr;
  NVSDK_NGX_Result (*release_feature)(
      void*, NVSDK_NGX_Handle*) = nullptr;
  NVSDK_NGX_Result (*shutdown)(void*, VkDevice) = nullptr;
};

struct VulkanDispatchTable final {
  void* context = nullptr;
  VkResult (*create_command_pool)(
      void*,
      VkDevice,
      const VkCommandPoolCreateInfo*,
      const VkAllocationCallbacks*,
      VkCommandPool*) = nullptr;
  void (*destroy_command_pool)(
      void*, VkDevice, VkCommandPool, const VkAllocationCallbacks*) = nullptr;
  VkResult (*allocate_command_buffers)(
      void*, VkDevice, const VkCommandBufferAllocateInfo*, VkCommandBuffer*) = nullptr;
  void (*free_command_buffers)(
      void*, VkDevice, VkCommandPool, std::uint32_t, const VkCommandBuffer*) = nullptr;
  VkResult (*begin_command_buffer)(
      void*, VkCommandBuffer, const VkCommandBufferBeginInfo*) = nullptr;
  VkResult (*end_command_buffer)(void*, VkCommandBuffer) = nullptr;
  VkResult (*create_fence)(
      void*,
      VkDevice,
      const VkFenceCreateInfo*,
      const VkAllocationCallbacks*,
      VkFence*) = nullptr;
  void (*destroy_fence)(
      void*, VkDevice, VkFence, const VkAllocationCallbacks*) = nullptr;
  VkResult (*wait_for_fences)(
      void*, VkDevice, std::uint32_t, const VkFence*, VkBool32, std::uint64_t) = nullptr;
};

using HostQueueSubmit = VkResult (*)(
    void*, VkQueue, std::uint32_t, const VkSubmitInfo*, VkFence);

struct DeviceCreateInfo final {
  VkInstance instance = VK_NULL_HANDLE;
  VkPhysicalDevice physical_device = VK_NULL_HANDLE;
  VkDevice device = VK_NULL_HANDLE;
  VkQueue graphics_queue = VK_NULL_HANDLE;
  std::uint32_t graphics_queue_family = VK_QUEUE_FAMILY_IGNORED;
  PFN_vkGetInstanceProcAddr get_instance_proc_addr = nullptr;
  PFN_vkGetDeviceProcAddr get_device_proc_addr = nullptr;
  std::string project_id;
  std::string engine_version;
  std::wstring application_data_path;
  const NVSDK_NGX_FeatureCommonInfo* feature_info = nullptr;
  NVSDK_NGX_Version sdk_version = NVSDK_NGX_Version_API;
  NgxDispatchTable ngx = {};
  VulkanDispatchTable vulkan = {};
  void* submit_context = nullptr;
  HostQueueSubmit submit = nullptr;
};

class NgxContext final {
 public:
  using SubmissionSnapshot = FeatureLifetimeTracker::SubmissionSnapshot;
  using CompletedRecording = FeatureLifetimeTracker::CompletedRecording;

  explicit NgxContext(DeviceCreateInfo create_info);
  ~NgxContext();
  NgxContext(const NgxContext&) = delete;
  NgxContext& operator=(const NgxContext&) = delete;

  OperationResult Initialize();
  OperationResult QueryMode(const ModeQuery& query, ModeSettings* settings);
  OperationResult ConfigureFeature(const FeatureConfig& config);
  OperationResult Evaluate(const EvaluateInfo& info);

  void BeginRecording(std::uint64_t recording_key, bool one_time_submit);
  void DiscardRecording(std::uint64_t recording_key);
  void DiscardRecordings(const std::vector<std::uint64_t>& recording_keys);
  void DiscardAllRecordings();
  [[nodiscard]] SubmissionSnapshot CaptureSubmission(
      const std::vector<std::uint64_t>& recording_keys) const;
  SubmissionSnapshot NotifySubmitted(
      std::uint64_t queue_key, const SubmissionSnapshot& snapshot);
  std::vector<CompletedRecording> NotifySubmissionCompleted(
      std::uint64_t queue_key, const SubmissionSnapshot& snapshot);
  std::vector<CompletedRecording> NotifyQueueCompleted(
      std::uint64_t queue_key);
  std::vector<CompletedRecording> NotifyDeviceCompleted();

  void RetireActive();
  void RetireCompleted();
  void Shutdown();

  [[nodiscard]] bool IsInitialized() const noexcept;
  [[nodiscard]] bool IsAvailable() const noexcept;
  [[nodiscard]] bool HasFeatures() const noexcept;
  [[nodiscard]] std::uint64_t ActiveFeatureGeneration() const noexcept;
  [[nodiscard]] std::uint64_t RecordedReferenceCount(
      std::uint64_t generation) const;
  [[nodiscard]] std::uint64_t InFlightReferenceCount(
      std::uint64_t generation) const;

 private:
  struct Impl;
  std::unique_ptr<Impl> impl_;
};

}  // namespace renodx::utils::dlss::vulkan
