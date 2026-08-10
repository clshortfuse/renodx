/*
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
#include <iostream>
#include <limits>
#include <type_traits>
#include <vector>

#include "utils/dlss/ngx_vulkan.hpp"
#include "utils/dlss/vulkan_barriers.hpp"

namespace dlss = renodx::utils::dlss::vulkan;

namespace {

template <typename Handle>
Handle FakeHandle(std::uintptr_t value) {
  if constexpr (std::is_pointer_v<Handle>) {
    return reinterpret_cast<Handle>(value);
  } else {
    return static_cast<Handle>(value);
  }
}

struct FakeState final {
  NVSDK_NGX_Result init_result = NVSDK_NGX_Result_Success;
  NVSDK_NGX_Result capability_result = NVSDK_NGX_Result_Success;
  NVSDK_NGX_Result availability_result = NVSDK_NGX_Result_Success;
  NVSDK_NGX_Result allocate_result = NVSDK_NGX_Result_Success;
  NVSDK_NGX_Result create_result = NVSDK_NGX_Result_Success;
  NVSDK_NGX_Result evaluate_result = NVSDK_NGX_Result_Success;
  VkResult create_pool_result = VK_SUCCESS;
  VkResult allocate_command_buffer_result = VK_SUCCESS;
  VkResult begin_result = VK_SUCCESS;
  VkResult end_result = VK_SUCCESS;
  VkResult create_fence_result = VK_SUCCESS;
  VkResult submit_result = VK_SUCCESS;
  VkResult wait_result = VK_SUCCESS;
  int available = 1;
  bool return_capability_pointer_on_failure = false;
  bool last_evaluate_reset = false;
  std::uint32_t initialize_calls = 0u;
  std::uint32_t shutdown_calls = 0u;
  std::uint32_t destroy_parameter_calls = 0u;
  std::uint32_t create_feature_calls = 0u;
  std::uint32_t evaluate_calls = 0u;
  std::uint32_t release_feature_calls = 0u;
  std::uint32_t submit_calls = 0u;
  std::uint32_t wait_calls = 0u;
  std::uint32_t free_command_buffer_calls = 0u;
  std::uint32_t destroy_fence_calls = 0u;
  std::uint32_t destroy_pool_calls = 0u;
  VkCommandPoolCreateFlags pool_flags = 0u;
  std::uint32_t pool_family = VK_QUEUE_FAMILY_IGNORED;
  VkCommandBufferLevel command_buffer_level = VK_COMMAND_BUFFER_LEVEL_SECONDARY;
  VkCommandBufferUsageFlags begin_flags = 0u;
  VkCommandBuffer submitted_command_buffer = VK_NULL_HANDLE;
  VkFence submitted_fence = VK_NULL_HANDLE;
  std::uint64_t wait_timeout = 0u;
  std::uintptr_t next_handle = 0x1000u;
};

bool Expect(bool condition, const char* message) {
  if (!condition) std::cerr << "FAIL: " << message << '\n';
  return condition;
}

NVSDK_NGX_Result InitializeProject(
    void* context,
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
    NVSDK_NGX_Version) {
  auto& fake = *static_cast<FakeState*>(context);
  ++fake.initialize_calls;
  return fake.init_result;
}

NVSDK_NGX_Result GetCapabilities(
    void* context, NVSDK_NGX_Parameter** parameters) {
  auto& fake = *static_cast<FakeState*>(context);
  if (NVSDK_NGX_SUCCEED(fake.capability_result)
      || fake.return_capability_pointer_on_failure) {
    *parameters = FakeHandle<NVSDK_NGX_Parameter*>(fake.next_handle++);
  }
  return fake.capability_result;
}

NVSDK_NGX_Result GetParameterI(
    void* context, NVSDK_NGX_Parameter*, const char*, int* value) {
  auto& fake = *static_cast<FakeState*>(context);
  if (value != nullptr) *value = fake.available;
  return fake.availability_result;
}

NVSDK_NGX_Result QueryMode(
    void*, NVSDK_NGX_Parameter*, const dlss::ModeQuery* query, dlss::ModeSettings* settings) {
  settings->optimal_width = query->output_width;
  settings->optimal_height = query->output_height;
  settings->minimum_width = query->output_width / 2u;
  settings->minimum_height = query->output_height / 2u;
  settings->maximum_width = query->output_width;
  settings->maximum_height = query->output_height;
  return NVSDK_NGX_Result_Success;
}

NVSDK_NGX_Result AllocateParameters(
    void* context, NVSDK_NGX_Parameter** parameters) {
  auto& fake = *static_cast<FakeState*>(context);
  if (NVSDK_NGX_SUCCEED(fake.allocate_result)) {
    *parameters = FakeHandle<NVSDK_NGX_Parameter*>(fake.next_handle++);
  }
  return fake.allocate_result;
}

NVSDK_NGX_Result DestroyParameters(void* context, NVSDK_NGX_Parameter*) {
  ++static_cast<FakeState*>(context)->destroy_parameter_calls;
  return NVSDK_NGX_Result_Success;
}

NVSDK_NGX_Result CreateFeature(
    void* context,
    VkDevice,
    VkCommandBuffer,
    NVSDK_NGX_Handle** feature,
    NVSDK_NGX_Parameter*,
    const dlss::FeatureConfig*) {
  auto& fake = *static_cast<FakeState*>(context);
  ++fake.create_feature_calls;
  if (NVSDK_NGX_SUCCEED(fake.create_result)) {
    *feature = FakeHandle<NVSDK_NGX_Handle*>(fake.next_handle++);
  }
  return fake.create_result;
}

NVSDK_NGX_Result EvaluateFeature(
    void* context,
    VkCommandBuffer,
    NVSDK_NGX_Handle*,
    NVSDK_NGX_Parameter*,
    const dlss::EvaluateInfo* info) {
  auto& fake = *static_cast<FakeState*>(context);
  ++fake.evaluate_calls;
  fake.last_evaluate_reset = info->reset;
  return fake.evaluate_result;
}

NVSDK_NGX_Result ReleaseFeature(void* context, NVSDK_NGX_Handle*) {
  ++static_cast<FakeState*>(context)->release_feature_calls;
  return NVSDK_NGX_Result_Success;
}

NVSDK_NGX_Result Shutdown(void* context, VkDevice) {
  ++static_cast<FakeState*>(context)->shutdown_calls;
  return NVSDK_NGX_Result_Success;
}

VkResult CreateCommandPool(
    void* context,
    VkDevice,
    const VkCommandPoolCreateInfo* info,
    const VkAllocationCallbacks*,
    VkCommandPool* pool) {
  auto& fake = *static_cast<FakeState*>(context);
  fake.pool_flags = info->flags;
  fake.pool_family = info->queueFamilyIndex;
  if (fake.create_pool_result == VK_SUCCESS) {
    *pool = FakeHandle<VkCommandPool>(fake.next_handle++);
  }
  return fake.create_pool_result;
}

void DestroyCommandPool(
    void* context, VkDevice, VkCommandPool, const VkAllocationCallbacks*) {
  ++static_cast<FakeState*>(context)->destroy_pool_calls;
}

VkResult AllocateCommandBuffers(
    void* context,
    VkDevice,
    const VkCommandBufferAllocateInfo* info,
    VkCommandBuffer* command_buffer) {
  auto& fake = *static_cast<FakeState*>(context);
  fake.command_buffer_level = info->level;
  if (fake.allocate_command_buffer_result == VK_SUCCESS) {
    *command_buffer = FakeHandle<VkCommandBuffer>(fake.next_handle++);
  }
  return fake.allocate_command_buffer_result;
}

void FreeCommandBuffers(
    void* context, VkDevice, VkCommandPool, std::uint32_t, const VkCommandBuffer*) {
  ++static_cast<FakeState*>(context)->free_command_buffer_calls;
}

VkResult BeginCommandBuffer(
    void* context,
    VkCommandBuffer,
    const VkCommandBufferBeginInfo* info) {
  auto& fake = *static_cast<FakeState*>(context);
  fake.begin_flags = info->flags;
  return fake.begin_result;
}

VkResult EndCommandBuffer(void* context, VkCommandBuffer) {
  return static_cast<FakeState*>(context)->end_result;
}

VkResult CreateFence(
    void* context,
    VkDevice,
    const VkFenceCreateInfo*,
    const VkAllocationCallbacks*,
    VkFence* fence) {
  auto& fake = *static_cast<FakeState*>(context);
  if (fake.create_fence_result == VK_SUCCESS) {
    *fence = FakeHandle<VkFence>(fake.next_handle++);
  }
  return fake.create_fence_result;
}

void DestroyFence(
    void* context, VkDevice, VkFence, const VkAllocationCallbacks*) {
  ++static_cast<FakeState*>(context)->destroy_fence_calls;
}

VkResult WaitForFences(
    void* context,
    VkDevice,
    std::uint32_t,
    const VkFence*,
    VkBool32,
    std::uint64_t timeout) {
  auto& fake = *static_cast<FakeState*>(context);
  ++fake.wait_calls;
  fake.wait_timeout = timeout;
  return fake.wait_result;
}

VkResult Submit(
    void* context,
    VkQueue,
    std::uint32_t submit_count,
    const VkSubmitInfo* submits,
    VkFence fence) {
  auto& fake = *static_cast<FakeState*>(context);
  ++fake.submit_calls;
  fake.submitted_fence = fence;
  if (submit_count == 1u && submits != nullptr
      && submits[0].commandBufferCount == 1u) {
    fake.submitted_command_buffer = submits[0].pCommandBuffers[0];
  }
  return fake.submit_result;
}

dlss::DeviceCreateInfo MakeCreateInfo(FakeState* fake) {
  return {
      .instance = FakeHandle<VkInstance>(1u),
      .physical_device = FakeHandle<VkPhysicalDevice>(2u),
      .device = FakeHandle<VkDevice>(3u),
      .graphics_queue = FakeHandle<VkQueue>(4u),
      .graphics_queue_family = 7u,
      .project_id = "910b88f3-e60e-4c9d-a959-9a46b3e7dcc3",
      .engine_version = "test",
      .application_data_path = L"test",
      .ngx = {
          .context = fake,
          .initialize_project = &InitializeProject,
          .get_capability_parameters = &GetCapabilities,
          .get_parameter_i = &GetParameterI,
          .query_mode = &QueryMode,
          .allocate_parameters = &AllocateParameters,
          .destroy_parameters = &DestroyParameters,
          .create_feature = &CreateFeature,
          .evaluate_feature = &EvaluateFeature,
          .release_feature = &ReleaseFeature,
          .shutdown = &Shutdown,
      },
      .vulkan = {
          .context = fake,
          .create_command_pool = &CreateCommandPool,
          .destroy_command_pool = &DestroyCommandPool,
          .allocate_command_buffers = &AllocateCommandBuffers,
          .free_command_buffers = &FreeCommandBuffers,
          .begin_command_buffer = &BeginCommandBuffer,
          .end_command_buffer = &EndCommandBuffer,
          .create_fence = &CreateFence,
          .destroy_fence = &DestroyFence,
          .wait_for_fences = &WaitForFences,
      },
      .submit_context = fake,
      .submit = &Submit,
  };
}

dlss::FeatureConfig MakeFeatureConfig(std::uint32_t width = 1920u) {
  return {
      .mode = NVSDK_NGX_PerfQuality_Value_DLAA,
      .render_width = width,
      .render_height = 1080u,
      .output_width = width,
      .output_height = 1080u,
      .create_flags = NVSDK_NGX_DLSS_Feature_Flags_IsHDR,
  };
}

dlss::EvaluateInfo MakeEvaluateInfo(std::uint64_t recording_key) {
  static dlss::ImageResource color;
  static dlss::ImageResource depth;
  static dlss::ImageResource motion_vectors;
  static dlss::ImageResource output;
  return {
      .recording_key = recording_key,
      .command_buffer = FakeHandle<VkCommandBuffer>(0x9000u + recording_key),
      .color = &color,
      .depth = &depth,
      .motion_vectors = &motion_vectors,
      .output = &output,
      .render_width = 1920u,
      .render_height = 1080u,
  };
}

bool TestPartialInitializationCleanup() {
  FakeState fake;
  fake.capability_result = NVSDK_NGX_Result_FAIL_PlatformError;
  fake.return_capability_pointer_on_failure = true;
  dlss::NgxContext context(MakeCreateInfo(&fake));
  const auto result = context.Initialize();
  return Expect(!result.Succeeded(), "capability failure must fail initialization")
         && Expect(!context.IsInitialized(), "partial initialization must roll back")
         && Expect(fake.destroy_parameter_calls == 1u, "partial capability parameter must be destroyed")
         && Expect(fake.shutdown_calls == 1u, "partial initialization must shut NGX down");
}

bool TestUnavailableCapabilityCleanup() {
  FakeState fake;
  fake.available = 0;
  dlss::NgxContext context(MakeCreateInfo(&fake));
  const auto result = context.Initialize();
  return Expect(!result.Succeeded(), "unavailable DLSS capability must fail closed")
         && Expect(fake.destroy_parameter_calls == 1u, "capability parameters must be destroyed")
         && Expect(fake.shutdown_calls == 1u, "unavailable capability must shut NGX down");
}

bool TestDedicatedFeatureCreationAndFirstReset() {
  FakeState fake;
  dlss::NgxContext context(MakeCreateInfo(&fake));
  bool passed = true;
  passed &= Expect(context.Initialize().Succeeded(), "NGX initialization must succeed");

  const auto premature = context.Evaluate(MakeEvaluateInfo(10u));
  passed &= Expect(!premature.Succeeded() && fake.evaluate_calls == 0u,
                   "Evaluate must be rejected before a feature is ready");

  const auto configured = context.ConfigureFeature(MakeFeatureConfig());
  passed &= Expect(configured.Succeeded() && configured.feature_created,
                   "ConfigureFeature must publish a completed feature generation");
  passed &= Expect((fake.pool_flags & VK_COMMAND_POOL_CREATE_TRANSIENT_BIT) != 0u
                       && fake.pool_family == 7u,
                   "feature creation must use a private graphics-family command pool");
  passed &= Expect(fake.command_buffer_level == VK_COMMAND_BUFFER_LEVEL_PRIMARY
                       && (fake.begin_flags & VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT) != 0u,
                   "feature creation must record a primary one-time command buffer");
  passed &= Expect(fake.submit_calls == 1u && fake.wait_calls == 1u
                       && fake.submitted_command_buffer != VK_NULL_HANDLE
                       && fake.submitted_fence != VK_NULL_HANDLE
                       && fake.wait_timeout == std::numeric_limits<std::uint64_t>::max(),
                   "feature creation must submit and wait on its private fence");
  passed &= Expect(fake.free_command_buffer_calls == 1u
                       && fake.destroy_fence_calls == 1u,
                   "completed private creation objects must be reclaimed");

  context.BeginRecording(10u, false);
  const auto first = context.Evaluate(MakeEvaluateInfo(10u));
  passed &= Expect(first.Succeeded() && first.output_valid && fake.last_evaluate_reset,
                   "first Evaluate after creation must force reset");
  const auto second = context.Evaluate(MakeEvaluateInfo(10u));
  passed &= Expect(second.Succeeded() && !fake.last_evaluate_reset,
                   "later Evaluate must preserve the caller reset value");
  return passed;
}

bool TestRetirementWaitsForReusableRecordingInvalidation() {
  FakeState fake;
  dlss::NgxContext context(MakeCreateInfo(&fake));
  bool passed = true;
  passed &= Expect(context.ConfigureFeature(MakeFeatureConfig()).Succeeded(),
                   "first feature must configure");
  const std::uint64_t old_generation = context.ActiveFeatureGeneration();
  context.BeginRecording(20u, false);
  passed &= Expect(context.Evaluate(MakeEvaluateInfo(20u)).Succeeded(),
                   "old feature must be recorded");
  const auto captured = context.CaptureSubmission({20u});
  const auto committed = context.NotifySubmitted(30u, captured);

  passed &= Expect(context.ConfigureFeature(MakeFeatureConfig(2560u)).Succeeded(),
                   "new resolution must create a new generation");
  passed &= Expect(fake.release_feature_calls == 0u,
                   "retired generation must survive while its recording is referenced");
  (void)context.NotifySubmissionCompleted(30u, committed);
  passed &= Expect(context.RecordedReferenceCount(old_generation) == 1u
                       && fake.release_feature_calls == 0u,
                   "reusable recording must survive submission completion");
  context.DiscardRecording(20u);
  passed &= Expect(fake.release_feature_calls == 1u,
                   "reset/free boundary must release the retired reusable generation");
  return passed;
}

bool TestOneTimeRetirementCompletesWithSubmission() {
  FakeState fake;
  dlss::NgxContext context(MakeCreateInfo(&fake));
  bool passed = true;
  passed &= Expect(context.ConfigureFeature(MakeFeatureConfig()).Succeeded(),
                   "first feature must configure");
  auto evaluate = MakeEvaluateInfo(40u);
  evaluate.one_time_submit = true;
  passed &= Expect(context.Evaluate(evaluate).Succeeded(),
                   "one-time recording discovered at Evaluate must be tracked");
  const auto captured = context.CaptureSubmission({40u});
  const auto committed = context.NotifySubmitted(50u, captured);
  passed &= Expect(context.ConfigureFeature(MakeFeatureConfig(1280u)).Succeeded(),
                   "replacement feature must configure");
  const auto completed = context.NotifySubmissionCompleted(50u, committed);
  passed &= Expect(completed == std::vector<std::uint64_t>{40u},
                   "one-time completion must expose its recyclable recording key");
  passed &= Expect(fake.release_feature_calls == 1u,
                   "one-time completion must release the retired generation");
  return passed;
}

bool TestExactComputeBarrierPlans() {
  dlss::TrackedImageState image = {
      .image = FakeHandle<VkImage>(0x7000u),
      .image_view = FakeHandle<VkImageView>(0x7001u),
      .range = {
          .aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
          .baseMipLevel = 2u,
          .levelCount = 1u,
          .baseArrayLayer = 3u,
          .layerCount = 1u,
      },
      .format = VK_FORMAT_R16G16B16A16_SFLOAT,
      .usage = VK_IMAGE_USAGE_SAMPLED_BIT | VK_IMAGE_USAGE_STORAGE_BIT,
      .layout = VK_IMAGE_LAYOUT_UNDEFINED,
      .queue_family = VK_QUEUE_FAMILY_IGNORED,
      .contents_valid = false,
  };
  bool passed = true;
  const auto fresh = dlss::PlanScratchStorageWrite(image);
  passed &= Expect(
      fresh.source_stage == VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT
          && fresh.destination_stage == VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT
          && fresh.barrier.srcAccessMask == 0u
          && fresh.barrier.dstAccessMask == VK_ACCESS_SHADER_WRITE_BIT
          && fresh.barrier.oldLayout == VK_IMAGE_LAYOUT_UNDEFINED
          && fresh.barrier.newLayout == VK_IMAGE_LAYOUT_GENERAL,
      "fresh scratch must discard contents into a compute storage write");

  image.layout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
  image.stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
  image.access = VK_ACCESS_SHADER_READ_BIT;
  image.contents_valid = true;
  const auto reused = dlss::PlanScratchStorageWrite(image);
  const auto prepared = dlss::PlanPreparedColorSampledRead(image);
  const auto ngx_output = dlss::PlanNgxOutputSampledRead(image);
  const auto native_output = dlss::PlanNativeOutputPackWrite(image);
  const auto downstream = dlss::PlanPackedOutputDownstream(image);
  passed &= Expect(
      reused.source_stage == VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT
          && reused.barrier.srcAccessMask == VK_ACCESS_SHADER_READ_BIT,
      "reused scratch must depend on its proven compute access");
  passed &= Expect(
      prepared.barrier.srcAccessMask == VK_ACCESS_SHADER_WRITE_BIT
          && prepared.barrier.dstAccessMask == VK_ACCESS_SHADER_READ_BIT
          && ngx_output.barrier.srcAccessMask == VK_ACCESS_SHADER_WRITE_BIT
          && ngx_output.barrier.dstAccessMask == VK_ACCESS_SHADER_READ_BIT,
      "prepared and NGX color must expose compute writes to sampled reads");
  passed &= Expect(
      native_output.barrier.srcAccessMask
              == (VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT)
          && native_output.barrier.dstAccessMask == VK_ACCESS_SHADER_WRITE_BIT
          && downstream.barrier.srcAccessMask == VK_ACCESS_SHADER_WRITE_BIT
          && downstream.barrier.dstAccessMask
                 == (VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT),
      "b16 pack dependencies must include prior and downstream compute access");
  for (const auto& plan : {fresh, reused, prepared, ngx_output, native_output, downstream}) {
    passed &= Expect(
        (plan.source_stage & VK_PIPELINE_STAGE_ALL_COMMANDS_BIT) == 0u
            && (plan.destination_stage & VK_PIPELINE_STAGE_ALL_COMMANDS_BIT) == 0u
            && (plan.barrier.srcAccessMask & VK_ACCESS_MEMORY_WRITE_BIT) == 0u
            && (plan.barrier.dstAccessMask & VK_ACCESS_MEMORY_WRITE_BIT) == 0u,
        "DLSS barrier plans must not use broad ALL_COMMANDS or MEMORY_WRITE masks");
  }
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestPartialInitializationCleanup();
  passed &= TestUnavailableCapabilityCleanup();
  passed &= TestDedicatedFeatureCreationAndFirstReset();
  passed &= TestRetirementWaitsForReusableRecordingInvalidation();
  passed &= TestOneTimeRetirementCompletesWithSubmission();
  passed &= TestExactComputeBarrierPlans();
  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
