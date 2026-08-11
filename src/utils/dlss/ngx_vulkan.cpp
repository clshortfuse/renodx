/*
 * SPDX-License-Identifier: MIT
 */

#include "ngx_vulkan.hpp"

#include <limits>
#include <mutex>
#include <optional>
#include <unordered_map>
#include <utility>

namespace renodx::utils::dlss::vulkan {

namespace {

OperationResult NgxFailure(OperationStage stage, NVSDK_NGX_Result result) {
  return {
      .stage = stage,
      .ngx_result = result,
  };
}

OperationResult VulkanFailure(
    OperationStage stage,
    VkResult result,
    std::uint64_t generation = 0u) {
  return {
      .stage = stage,
      .vk_result = result,
      .feature_generation = generation,
  };
}

}  // namespace

struct NgxContext::Impl final {
  struct FeatureGeneration final {
    std::uint64_t generation = 0u;
    FeatureConfig config = {};
    NVSDK_NGX_Parameter* parameters = nullptr;
    NVSDK_NGX_Handle* feature = nullptr;
    bool reset_pending = true;
    bool retired = false;
  };

  explicit Impl(DeviceCreateInfo info) : create_info(std::move(info)) {}

  [[nodiscard]] bool HasInitializationDispatch() const noexcept {
    return create_info.ngx.initialize_project != nullptr
           && create_info.ngx.get_capability_parameters != nullptr
           && create_info.ngx.get_parameter_i != nullptr
           && create_info.ngx.destroy_parameters != nullptr
           && create_info.ngx.shutdown != nullptr;
  }

  [[nodiscard]] bool HasFeatureDispatch() const noexcept {
    return create_info.ngx.allocate_parameters != nullptr
           && create_info.ngx.destroy_parameters != nullptr
           && create_info.ngx.create_feature != nullptr
           && create_info.ngx.release_feature != nullptr
           && create_info.vulkan.create_command_pool != nullptr
           && create_info.vulkan.destroy_command_pool != nullptr
           && create_info.vulkan.allocate_command_buffers != nullptr
           && create_info.vulkan.free_command_buffers != nullptr
           && create_info.vulkan.begin_command_buffer != nullptr
           && create_info.vulkan.end_command_buffer != nullptr
           && create_info.vulkan.create_fence != nullptr
           && create_info.vulkan.destroy_fence != nullptr
           && create_info.vulkan.wait_for_fences != nullptr
           && create_info.submit != nullptr;
  }

  OperationResult InitializeLocked() {
    if (initialized) {
      return available
                 ? OperationResult{.stage = OperationStage::kCapabilities}
                 : NgxFailure(
                       OperationStage::kCapabilities,
                       NVSDK_NGX_Result_FAIL_FeatureNotSupported);
    }
    if (!HasInitializationDispatch() || create_info.device == VK_NULL_HANDLE
        || create_info.instance == VK_NULL_HANDLE
        || create_info.physical_device == VK_NULL_HANDLE
        || create_info.project_id.empty()) {
      return NgxFailure(
          OperationStage::kInitialize,
          NVSDK_NGX_Result_FAIL_InvalidParameter);
    }

    const NVSDK_NGX_Result init_result = create_info.ngx.initialize_project(
        create_info.ngx.context,
        create_info.project_id.c_str(),
        NVSDK_NGX_ENGINE_TYPE_CUSTOM,
        create_info.engine_version.c_str(),
        create_info.application_data_path.c_str(),
        create_info.instance,
        create_info.physical_device,
        create_info.device,
        create_info.get_instance_proc_addr,
        create_info.get_device_proc_addr,
        create_info.feature_info,
        create_info.sdk_version);
    if (NVSDK_NGX_FAILED(init_result)) {
      return NgxFailure(OperationStage::kInitialize, init_result);
    }
    initialized = true;

    NVSDK_NGX_Parameter* parameters = nullptr;
    const NVSDK_NGX_Result capability_result =
        create_info.ngx.get_capability_parameters(
            create_info.ngx.context, &parameters);
    if (NVSDK_NGX_FAILED(capability_result) || parameters == nullptr) {
      if (parameters != nullptr) {
        (void)create_info.ngx.destroy_parameters(
            create_info.ngx.context, parameters);
      }
      (void)create_info.ngx.shutdown(
          create_info.ngx.context, create_info.device);
      initialized = false;
      return NgxFailure(
          OperationStage::kCapabilities,
          NVSDK_NGX_FAILED(capability_result)
              ? capability_result
              : NVSDK_NGX_Result_FAIL_InvalidParameter);
    }
    capability_parameters = parameters;

    int dlss_available = 0;
    const NVSDK_NGX_Result availability_result = create_info.ngx.get_parameter_i(
        create_info.ngx.context,
        capability_parameters,
        NVSDK_NGX_Parameter_SuperSampling_Available,
        &dlss_available);
    if (NVSDK_NGX_FAILED(availability_result) || dlss_available == 0) {
      (void)create_info.ngx.destroy_parameters(
          create_info.ngx.context, capability_parameters);
      capability_parameters = nullptr;
      (void)create_info.ngx.shutdown(
          create_info.ngx.context, create_info.device);
      initialized = false;
      return NgxFailure(
          OperationStage::kCapabilities,
          NVSDK_NGX_FAILED(availability_result)
              ? availability_result
              : NVSDK_NGX_Result_FAIL_FeatureNotSupported);
    }

    available = true;
    return {.stage = OperationStage::kCapabilities};
  }

  [[nodiscard]] std::uint64_t AllocateGenerationLocked() {
    for (;;) {
      const std::uint64_t generation = next_generation++;
      if (next_generation == 0u) next_generation = 1u;
      if (generation != 0u && !features.contains(generation)) {
        return generation;
      }
    }
  }

  void ReleaseFeatureLocked(std::uint64_t generation) {
    const auto found = features.find(generation);
    if (found == features.end()) return;
    if (found->second.feature != nullptr
        && create_info.ngx.release_feature != nullptr) {
      (void)create_info.ngx.release_feature(
          create_info.ngx.context, found->second.feature);
    }
    if (found->second.parameters != nullptr
        && create_info.ngx.destroy_parameters != nullptr) {
      (void)create_info.ngx.destroy_parameters(
          create_info.ngx.context, found->second.parameters);
    }
    features.erase(found);
  }

  void RetireCompletedLocked() {
    std::vector<std::uint64_t> releasable;
    releasable.reserve(features.size());
    for (const auto& [generation, feature] : features) {
      if (feature.retired && !lifetime.IsReferenced(generation)) {
        releasable.push_back(generation);
      }
    }
    for (const std::uint64_t generation : releasable) {
      ReleaseFeatureLocked(generation);
    }
  }

  void RetireActiveLocked() {
    const auto found = features.find(active_generation);
    if (found != features.end()) found->second.retired = true;
    active_generation = 0u;
    RetireCompletedLocked();
  }

  void CleanupCreationObjects(
      VkCommandBuffer command_buffer,
      VkFence fence) const {
    if (fence != VK_NULL_HANDLE) {
      create_info.vulkan.destroy_fence(
          create_info.vulkan.context,
          create_info.device,
          fence,
          nullptr);
    }
    if (command_buffer != VK_NULL_HANDLE) {
      create_info.vulkan.free_command_buffers(
          create_info.vulkan.context,
          create_info.device,
          feature_command_pool,
          1u,
          &command_buffer);
    }
  }

  void CleanupUnpublishedFeature(
      NVSDK_NGX_Handle* feature,
      NVSDK_NGX_Parameter* parameters) const {
    if (feature != nullptr) {
      (void)create_info.ngx.release_feature(
          create_info.ngx.context, feature);
    }
    if (parameters != nullptr) {
      (void)create_info.ngx.destroy_parameters(
          create_info.ngx.context, parameters);
    }
  }

  void ShutdownLocked() {
    lifetime.DiscardAllCommandBuffers();
    active_generation = 0u;
    std::vector<std::uint64_t> generations;
    generations.reserve(features.size());
    for (const auto& [generation, feature] : features) {
      generations.push_back(generation);
    }
    for (const std::uint64_t generation : generations) {
      ReleaseFeatureLocked(generation);
    }

    if (feature_command_pool != VK_NULL_HANDLE
        && create_info.vulkan.destroy_command_pool != nullptr) {
      create_info.vulkan.destroy_command_pool(
          create_info.vulkan.context,
          create_info.device,
          feature_command_pool,
          nullptr);
      feature_command_pool = VK_NULL_HANDLE;
    }
    if (capability_parameters != nullptr
        && create_info.ngx.destroy_parameters != nullptr) {
      (void)create_info.ngx.destroy_parameters(
          create_info.ngx.context, capability_parameters);
      capability_parameters = nullptr;
    }
    if (initialized && create_info.ngx.shutdown != nullptr) {
      (void)create_info.ngx.shutdown(
          create_info.ngx.context, create_info.device);
    }
    initialized = false;
    available = false;
  }

  DeviceCreateInfo create_info;
  mutable std::mutex mutex;
  bool initialized = false;
  bool available = false;
  NVSDK_NGX_Parameter* capability_parameters = nullptr;
  VkCommandPool feature_command_pool = VK_NULL_HANDLE;
  std::uint64_t active_generation = 0u;
  std::uint64_t next_generation = 1u;
  std::unordered_map<std::uint64_t, FeatureGeneration> features;
  FeatureLifetimeTracker lifetime;
};

NgxContext::NgxContext(DeviceCreateInfo create_info)
    : impl_(std::make_unique<Impl>(std::move(create_info))) {}

NgxContext::~NgxContext() { Shutdown(); }

OperationResult NgxContext::Initialize() {
  const std::lock_guard lock(impl_->mutex);
  return impl_->InitializeLocked();
}

OperationResult NgxContext::QueryMode(
    const ModeQuery& query, ModeSettings* settings) {
  const std::lock_guard lock(impl_->mutex);
  const OperationResult initialized = impl_->InitializeLocked();
  if (!initialized.Succeeded()) return initialized;
  if (settings == nullptr || impl_->create_info.ngx.query_mode == nullptr
      || query.output_width == 0u || query.output_height == 0u) {
    return NgxFailure(
        OperationStage::kQueryMode,
        NVSDK_NGX_Result_FAIL_InvalidParameter);
  }
  const NVSDK_NGX_Result result = impl_->create_info.ngx.query_mode(
      impl_->create_info.ngx.context,
      impl_->capability_parameters,
      &query,
      settings);
  return {
      .stage = OperationStage::kQueryMode,
      .ngx_result = result,
  };
}

OperationResult NgxContext::ConfigureFeature(const FeatureConfig& config) {
  const std::lock_guard lock(impl_->mutex);
  const OperationResult initialized = impl_->InitializeLocked();
  if (!initialized.Succeeded()) return initialized;
  if (!impl_->HasFeatureDispatch()
      || impl_->create_info.graphics_queue == VK_NULL_HANDLE
      || impl_->create_info.graphics_queue_family == VK_QUEUE_FAMILY_IGNORED
      || config.render_width == 0u || config.render_height == 0u
      || config.output_width == 0u || config.output_height == 0u) {
    return NgxFailure(
        OperationStage::kCreateFeature,
        NVSDK_NGX_Result_FAIL_InvalidParameter);
  }

  const auto active = impl_->features.find(impl_->active_generation);
  if (active != impl_->features.end() && !active->second.retired
      && active->second.config == config) {
    return {
        .stage = OperationStage::kFeatureReady,
        .feature_generation = active->second.generation,
    };
  }

  impl_->RetireActiveLocked();

  NVSDK_NGX_Parameter* parameters = nullptr;
  const NVSDK_NGX_Result allocate_result =
      impl_->create_info.ngx.allocate_parameters(
          impl_->create_info.ngx.context, &parameters);
  if (NVSDK_NGX_FAILED(allocate_result) || parameters == nullptr) {
    if (parameters != nullptr) {
      (void)impl_->create_info.ngx.destroy_parameters(
          impl_->create_info.ngx.context, parameters);
    }
    return NgxFailure(
        OperationStage::kAllocateParameters,
        NVSDK_NGX_FAILED(allocate_result)
            ? allocate_result
            : NVSDK_NGX_Result_FAIL_InvalidParameter);
  }

  if (impl_->feature_command_pool == VK_NULL_HANDLE) {
    const VkCommandPoolCreateInfo pool_info = {
        .sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .pNext = nullptr,
        .flags = VK_COMMAND_POOL_CREATE_TRANSIENT_BIT,
        .queueFamilyIndex = impl_->create_info.graphics_queue_family,
    };
    const VkResult pool_result = impl_->create_info.vulkan.create_command_pool(
        impl_->create_info.vulkan.context,
        impl_->create_info.device,
        &pool_info,
        nullptr,
        &impl_->feature_command_pool);
    if (pool_result != VK_SUCCESS) {
      impl_->CleanupUnpublishedFeature(nullptr, parameters);
      return VulkanFailure(OperationStage::kCreateCommandPool, pool_result);
    }
  }

  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  const VkCommandBufferAllocateInfo allocation_info = {
      .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
      .pNext = nullptr,
      .commandPool = impl_->feature_command_pool,
      .level = VK_COMMAND_BUFFER_LEVEL_PRIMARY,
      .commandBufferCount = 1u,
  };
  VkResult vk_result = impl_->create_info.vulkan.allocate_command_buffers(
      impl_->create_info.vulkan.context,
      impl_->create_info.device,
      &allocation_info,
      &command_buffer);
  if (vk_result != VK_SUCCESS || command_buffer == VK_NULL_HANDLE) {
    impl_->CleanupUnpublishedFeature(nullptr, parameters);
    return VulkanFailure(
        OperationStage::kAllocateCommandBuffer,
        vk_result != VK_SUCCESS ? vk_result : VK_ERROR_INITIALIZATION_FAILED);
  }

  const VkCommandBufferBeginInfo begin_info = {
      .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
      .pNext = nullptr,
      .flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT,
      .pInheritanceInfo = nullptr,
  };
  vk_result = impl_->create_info.vulkan.begin_command_buffer(
      impl_->create_info.vulkan.context, command_buffer, &begin_info);
  if (vk_result != VK_SUCCESS) {
    impl_->CleanupCreationObjects(command_buffer, VK_NULL_HANDLE);
    impl_->CleanupUnpublishedFeature(nullptr, parameters);
    return VulkanFailure(OperationStage::kBeginCommandBuffer, vk_result);
  }

  NVSDK_NGX_Handle* feature = nullptr;
  const NVSDK_NGX_Result create_result = impl_->create_info.ngx.create_feature(
      impl_->create_info.ngx.context,
      impl_->create_info.device,
      command_buffer,
      &feature,
      parameters,
      &config);
  if (NVSDK_NGX_FAILED(create_result) || feature == nullptr) {
    (void)impl_->create_info.vulkan.end_command_buffer(
        impl_->create_info.vulkan.context, command_buffer);
    impl_->CleanupCreationObjects(command_buffer, VK_NULL_HANDLE);
    impl_->CleanupUnpublishedFeature(feature, parameters);
    return NgxFailure(
        OperationStage::kCreateFeature,
        NVSDK_NGX_FAILED(create_result)
            ? create_result
            : NVSDK_NGX_Result_FAIL_UnableToInitializeFeature);
  }

  vk_result = impl_->create_info.vulkan.end_command_buffer(
      impl_->create_info.vulkan.context, command_buffer);
  if (vk_result != VK_SUCCESS) {
    impl_->CleanupCreationObjects(command_buffer, VK_NULL_HANDLE);
    impl_->CleanupUnpublishedFeature(feature, parameters);
    return VulkanFailure(OperationStage::kEndCommandBuffer, vk_result);
  }

  VkFence fence = VK_NULL_HANDLE;
  const VkFenceCreateInfo fence_info = {
      .sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO,
      .pNext = nullptr,
      .flags = 0u,
  };
  vk_result = impl_->create_info.vulkan.create_fence(
      impl_->create_info.vulkan.context,
      impl_->create_info.device,
      &fence_info,
      nullptr,
      &fence);
  if (vk_result != VK_SUCCESS || fence == VK_NULL_HANDLE) {
    impl_->CleanupCreationObjects(command_buffer, fence);
    impl_->CleanupUnpublishedFeature(feature, parameters);
    return VulkanFailure(
        OperationStage::kCreateFence,
        vk_result != VK_SUCCESS ? vk_result : VK_ERROR_INITIALIZATION_FAILED);
  }

  const VkSubmitInfo submit_info = {
      .sType = VK_STRUCTURE_TYPE_SUBMIT_INFO,
      .pNext = nullptr,
      .waitSemaphoreCount = 0u,
      .pWaitSemaphores = nullptr,
      .pWaitDstStageMask = nullptr,
      .commandBufferCount = 1u,
      .pCommandBuffers = &command_buffer,
      .signalSemaphoreCount = 0u,
      .pSignalSemaphores = nullptr,
  };
  vk_result = impl_->create_info.submit(
      impl_->create_info.submit_context,
      impl_->create_info.graphics_queue,
      1u,
      &submit_info,
      fence);
  if (vk_result != VK_SUCCESS) {
    impl_->CleanupCreationObjects(command_buffer, fence);
    impl_->CleanupUnpublishedFeature(feature, parameters);
    return VulkanFailure(OperationStage::kSubmitFeature, vk_result);
  }

  vk_result = impl_->create_info.vulkan.wait_for_fences(
      impl_->create_info.vulkan.context,
      impl_->create_info.device,
      1u,
      &fence,
      VK_TRUE,
      std::numeric_limits<std::uint64_t>::max());
  impl_->CleanupCreationObjects(command_buffer, fence);
  if (vk_result != VK_SUCCESS) {
    impl_->CleanupUnpublishedFeature(feature, parameters);
    return VulkanFailure(OperationStage::kWaitFeature, vk_result);
  }

  const std::uint64_t generation = impl_->AllocateGenerationLocked();
  impl_->features.emplace(
      generation,
      Impl::FeatureGeneration{
          .generation = generation,
          .config = config,
          .parameters = parameters,
          .feature = feature,
          .reset_pending = true,
      });
  impl_->active_generation = generation;
  return {
      .stage = OperationStage::kFeatureReady,
      .feature_generation = generation,
      .feature_created = true,
  };
}

OperationResult NgxContext::Evaluate(const EvaluateInfo& info) {
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->available || impl_->create_info.ngx.evaluate_feature == nullptr) {
    return NgxFailure(
        OperationStage::kEvaluate,
        NVSDK_NGX_Result_FAIL_NotInitialized);
  }
  const auto active = impl_->features.find(impl_->active_generation);
  if (active == impl_->features.end() || active->second.retired) {
    return NgxFailure(
        OperationStage::kEvaluate,
        NVSDK_NGX_Result_FAIL_FeatureNotFound);
  }
  if (info.recording_key == 0u || info.command_buffer == VK_NULL_HANDLE
      || info.color == nullptr || info.depth == nullptr
      || info.motion_vectors == nullptr || info.output == nullptr
      || info.render_width == 0u || info.render_height == 0u) {
    return NgxFailure(
        OperationStage::kEvaluate,
        NVSDK_NGX_Result_FAIL_InvalidParameter);
  }

  EvaluateInfo evaluation = info;
  evaluation.reset = evaluation.reset || active->second.reset_pending;
  const auto recording_epoch =
      impl_->lifetime.RecordFeatureUse(
          evaluation.recording_key,
          active->second.generation,
          evaluation.one_time_submit);
  const NVSDK_NGX_Result result = impl_->create_info.ngx.evaluate_feature(
      impl_->create_info.ngx.context,
      evaluation.command_buffer,
      active->second.feature,
      active->second.parameters,
      &evaluation);
  if (NVSDK_NGX_SUCCEED(result)) active->second.reset_pending = false;
  return {
      .stage = OperationStage::kEvaluate,
      .ngx_result = result,
      .feature_generation = active->second.generation,
      .recording_epoch = recording_epoch,
      .one_time_submit = evaluation.one_time_submit,
      .output_valid = NVSDK_NGX_SUCCEED(result),
  };
}

void NgxContext::BeginRecording(
    std::uint64_t recording_key, bool one_time_submit) {
  const std::lock_guard lock(impl_->mutex);
  impl_->lifetime.BeginCommandBuffer(recording_key, one_time_submit);
  impl_->RetireCompletedLocked();
}

void NgxContext::DiscardRecording(std::uint64_t recording_key) {
  const std::lock_guard lock(impl_->mutex);
  impl_->lifetime.DiscardCommandBuffer(recording_key);
  impl_->RetireCompletedLocked();
}

void NgxContext::DiscardRecordings(
    const std::vector<std::uint64_t>& recording_keys) {
  const std::lock_guard lock(impl_->mutex);
  impl_->lifetime.DiscardCommandBuffers(recording_keys);
  impl_->RetireCompletedLocked();
}

void NgxContext::DiscardAllRecordings() {
  const std::lock_guard lock(impl_->mutex);
  impl_->lifetime.DiscardAllCommandBuffers();
  impl_->RetireCompletedLocked();
}

NgxContext::SubmissionSnapshot NgxContext::CaptureSubmission(
    const std::vector<std::uint64_t>& recording_keys) const {
  const std::lock_guard lock(impl_->mutex);
  return impl_->lifetime.CaptureSubmission(recording_keys);
}

NgxContext::SubmissionSnapshot NgxContext::NotifySubmitted(
    std::uint64_t queue_key, const SubmissionSnapshot& snapshot) {
  const std::lock_guard lock(impl_->mutex);
  auto committed = impl_->lifetime.CommitSuccessfulSubmit(queue_key, snapshot);
  impl_->RetireCompletedLocked();
  return committed;
}

std::vector<NgxContext::CompletedRecording>
NgxContext::NotifySubmissionCompleted(
    std::uint64_t queue_key, const SubmissionSnapshot& snapshot) {
  const std::lock_guard lock(impl_->mutex);
  auto completed = impl_->lifetime.CompleteSubmission(queue_key, snapshot);
  impl_->RetireCompletedLocked();
  return completed;
}

std::vector<NgxContext::CompletedRecording> NgxContext::NotifyQueueCompleted(
    std::uint64_t queue_key) {
  const std::lock_guard lock(impl_->mutex);
  auto completed = impl_->lifetime.CompleteQueue(queue_key);
  impl_->RetireCompletedLocked();
  return completed;
}

std::vector<NgxContext::CompletedRecording> NgxContext::NotifyDeviceCompleted() {
  const std::lock_guard lock(impl_->mutex);
  auto completed = impl_->lifetime.CompleteDevice();
  impl_->RetireCompletedLocked();
  return completed;
}

void NgxContext::RetireActive() {
  const std::lock_guard lock(impl_->mutex);
  impl_->RetireActiveLocked();
}

void NgxContext::RetireCompleted() {
  const std::lock_guard lock(impl_->mutex);
  impl_->RetireCompletedLocked();
}

void NgxContext::Shutdown() {
  if (impl_ == nullptr) return;
  const std::lock_guard lock(impl_->mutex);
  impl_->ShutdownLocked();
}

bool NgxContext::IsInitialized() const noexcept {
  const std::lock_guard lock(impl_->mutex);
  return impl_->initialized;
}

bool NgxContext::IsAvailable() const noexcept {
  const std::lock_guard lock(impl_->mutex);
  return impl_->available;
}

bool NgxContext::HasFeatures() const noexcept {
  const std::lock_guard lock(impl_->mutex);
  return !impl_->features.empty();
}

std::uint64_t NgxContext::ActiveFeatureGeneration() const noexcept {
  const std::lock_guard lock(impl_->mutex);
  return impl_->active_generation;
}

std::uint64_t NgxContext::RecordedReferenceCount(
    std::uint64_t generation) const {
  const std::lock_guard lock(impl_->mutex);
  return impl_->lifetime.RecordedReferenceCount(generation);
}

std::uint64_t NgxContext::InFlightReferenceCount(
    std::uint64_t generation) const {
  const std::lock_guard lock(impl_->mutex);
  return impl_->lifetime.InFlightReferenceCount(generation);
}

}  // namespace renodx::utils::dlss::vulkan
