/*
 * SPDX-License-Identifier: MIT
 */

#include "adapter_runtime.hpp"

#include <algorithm>
#include <array>
#include <cmath>
#include <limits>
#include <mutex>
#include <span>
#include <type_traits>
#include <unordered_map>
#include <vector>

#include "adapter_shaders.hpp"
#include "utils/dlss/vulkan_barriers.hpp"

namespace renodx::games::detroitbecomehuman::dlss {
namespace {

constexpr VkFormat kNativeCurrentColorFormat = VK_FORMAT_E5B9G9R9_UFLOAT_PACK32;
constexpr VkFormat kNativeMotionVectorFormat = VK_FORMAT_R16G16_SFLOAT;
constexpr VkFormat kNativeDepthFormat = VK_FORMAT_D32_SFLOAT_S8_UINT;
constexpr VkFormat kNativeOutputFormat = VK_FORMAT_R32_UINT;
constexpr VkFormat kAdaptedColorFormat = VK_FORMAT_R16G16B16A16_SFLOAT;
constexpr std::uint32_t kMaximumScratchBundlesHardLimit = 8u;

template <typename Handle>
Handle FromOpaque(std::uint64_t handle) {
  if constexpr (std::is_pointer_v<Handle>) {
    return reinterpret_cast<Handle>(static_cast<std::uintptr_t>(handle));
  } else {
    return static_cast<Handle>(handle);
  }
}

template <typename Handle>
std::uint64_t ToOpaque(Handle handle) {
  if constexpr (std::is_pointer_v<Handle>) {
    return static_cast<std::uint64_t>(reinterpret_cast<std::uintptr_t>(handle));
  } else {
    return static_cast<std::uint64_t>(handle);
  }
}

constexpr AdapterResult Success() {
  return {AdapterStatus::kSuccess, AdapterDetail::kNone, VK_SUCCESS};
}

constexpr AdapterResult Fallback(AdapterDetail detail) {
  return {AdapterStatus::kFallback, detail, VK_SUCCESS};
}

constexpr AdapterResult VulkanError(VkResult result) {
  return {AdapterStatus::kError, AdapterDetail::kVulkanFailure, result};
}

bool IsSampledLayout(VkImageLayout layout) {
  return layout == VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL
         || layout == VK_IMAGE_LAYOUT_GENERAL;
}

bool IsDepthReadLayout(VkImageLayout layout) {
  return layout == VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL
         || layout == VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL
         || layout == VK_IMAGE_LAYOUT_GENERAL;
}

std::uint32_t DispatchCount(std::uint32_t extent, std::uint32_t group_size) {
  return extent / group_size + (extent % group_size == 0u ? 0u : 1u);
}

VkImageSubresourceRange ColorSubresourceRange() {
  return {
      VK_IMAGE_ASPECT_COLOR_BIT,
      0u,
      1u,
      0u,
      1u,
  };
}

}  // namespace

struct AdapterRuntime::Impl {
  struct Procedures {
    PFN_vkGetPhysicalDeviceFormatProperties get_physical_device_format_properties = nullptr;
    PFN_vkGetPhysicalDeviceProperties get_physical_device_properties = nullptr;
    PFN_vkCreateSampler create_sampler = nullptr;
    PFN_vkDestroySampler destroy_sampler = nullptr;
    PFN_vkCreateDescriptorSetLayout create_descriptor_set_layout = nullptr;
    PFN_vkDestroyDescriptorSetLayout destroy_descriptor_set_layout = nullptr;
    PFN_vkCreatePipelineLayout create_pipeline_layout = nullptr;
    PFN_vkDestroyPipelineLayout destroy_pipeline_layout = nullptr;
    PFN_vkCreateShaderModule create_shader_module = nullptr;
    PFN_vkDestroyShaderModule destroy_shader_module = nullptr;
    PFN_vkCreateComputePipelines create_compute_pipelines = nullptr;
    PFN_vkDestroyPipeline destroy_pipeline = nullptr;
    PFN_vkCreateDescriptorPool create_descriptor_pool = nullptr;
    PFN_vkDestroyDescriptorPool destroy_descriptor_pool = nullptr;
    PFN_vkAllocateDescriptorSets allocate_descriptor_sets = nullptr;
    PFN_vkUpdateDescriptorSets update_descriptor_sets = nullptr;
    PFN_vkCreateImage create_image = nullptr;
    PFN_vkDestroyImage destroy_image = nullptr;
    PFN_vkGetImageMemoryRequirements get_image_memory_requirements = nullptr;
    PFN_vkAllocateMemory allocate_memory = nullptr;
    PFN_vkFreeMemory free_memory = nullptr;
    PFN_vkBindImageMemory bind_image_memory = nullptr;
    PFN_vkCreateImageView create_image_view = nullptr;
    PFN_vkDestroyImageView destroy_image_view = nullptr;
    PFN_vkCmdPipelineBarrier cmd_pipeline_barrier = nullptr;
    PFN_vkCmdBindPipeline cmd_bind_pipeline = nullptr;
    PFN_vkCmdBindDescriptorSets cmd_bind_descriptor_sets = nullptr;
    PFN_vkCmdPushConstants cmd_push_constants = nullptr;
    PFN_vkCmdDispatch cmd_dispatch = nullptr;
    PFN_vkCreateEvent create_event = nullptr;
    PFN_vkDestroyEvent destroy_event = nullptr;
    PFN_vkGetEventStatus get_event_status = nullptr;
    PFN_vkResetEvent reset_event = nullptr;
    PFN_vkCmdSetEvent cmd_set_event = nullptr;
    PFN_vkDeviceWaitIdle device_wait_idle = nullptr;
  } procedures;

  struct ImageAllocation {
    VkImage image = VK_NULL_HANDLE;
    VkDeviceMemory memory = VK_NULL_HANDLE;
    VkImageView view = VK_NULL_HANDLE;
    VkFormat format = VK_FORMAT_UNDEFINED;
    VkExtent2D extent = {};
    renodx::utils::dlss::vulkan::TrackedImageState state = {};
  };

  struct PackConstants {
    float sharpening = 0.f;
    float normalization = 1.f;
  };
  static_assert(sizeof(PackConstants) == adapter_shaders::kPackPushConstantSize);

  struct ScratchBundle {
    VkCommandBuffer command_buffer = VK_NULL_HANDLE;
    ImageAllocation color;
    ImageAllocation dlss_output;
    VkDescriptorPool descriptor_pool = VK_NULL_HANDLE;
    VkDescriptorSet prepare_descriptor_set = VK_NULL_HANDLE;
    VkDescriptorSet pack_descriptor_set = VK_NULL_HANDLE;
    VkEvent completion_event = VK_NULL_HANDLE;
    DetroitDlssResource native_motion_vectors = {};
    DetroitDlssResource native_output = {};
    renodx::utils::dlss::vulkan::TrackedImageState native_output_state = {};
    std::uint64_t token = 0u;
    std::uint64_t recording_generation = 1u;
    std::uint64_t prepared_generation = 0u;
    PackConstants pack_constants = {};
    bool active = false;
    bool tainted = false;
    bool completion_pending = false;
    bool one_time_submit = false;
  };

  mutable std::mutex mutex;
  bool initialized = false;
  VkInstance instance = VK_NULL_HANDLE;
  VkPhysicalDevice physical_device = VK_NULL_HANDLE;
  VkDevice device = VK_NULL_HANDLE;
  PFN_vkGetInstanceProcAddr get_instance_proc_addr = nullptr;
  PFN_vkGetDeviceProcAddr get_device_proc_addr = nullptr;
  VkPhysicalDeviceMemoryProperties memory_properties = {};
  VkPhysicalDeviceProperties physical_device_properties = {};
  std::uint32_t maximum_scratch_bundles = 0u;
  std::uint64_t next_token = 1u;

  VkSampler sampler = VK_NULL_HANDLE;
  VkDescriptorSetLayout prepare_descriptor_set_layout = VK_NULL_HANDLE;
  VkDescriptorSetLayout pack_descriptor_set_layout = VK_NULL_HANDLE;
  VkPipelineLayout prepare_pipeline_layout = VK_NULL_HANDLE;
  VkPipelineLayout pack_pipeline_layout = VK_NULL_HANDLE;
  VkPipeline prepare_pipeline = VK_NULL_HANDLE;
  VkPipeline pack_pipeline = VK_NULL_HANDLE;

  std::unordered_map<VkCommandBuffer, ScratchBundle> bundles;
  std::vector<ScratchBundle> idle_bundles;

  template <typename Procedure>
  bool LoadDeviceProcedure(Procedure* procedure, const char* name) {
    *procedure = reinterpret_cast<Procedure>(get_device_proc_addr(device, name));
    return *procedure != nullptr;
  }

  template <typename Procedure>
  bool LoadInstanceProcedure(Procedure* procedure, const char* name) {
    *procedure = reinterpret_cast<Procedure>(get_instance_proc_addr(instance, name));
    return *procedure != nullptr;
  }

  bool LoadProcedures() {
    return LoadInstanceProcedure(
               &procedures.get_physical_device_format_properties,
               "vkGetPhysicalDeviceFormatProperties")
           && LoadInstanceProcedure(
               &procedures.get_physical_device_properties,
               "vkGetPhysicalDeviceProperties")
           && LoadDeviceProcedure(&procedures.create_sampler, "vkCreateSampler")
           && LoadDeviceProcedure(&procedures.destroy_sampler, "vkDestroySampler")
           && LoadDeviceProcedure(
               &procedures.create_descriptor_set_layout,
               "vkCreateDescriptorSetLayout")
           && LoadDeviceProcedure(
               &procedures.destroy_descriptor_set_layout,
               "vkDestroyDescriptorSetLayout")
           && LoadDeviceProcedure(
               &procedures.create_pipeline_layout,
               "vkCreatePipelineLayout")
           && LoadDeviceProcedure(
               &procedures.destroy_pipeline_layout,
               "vkDestroyPipelineLayout")
           && LoadDeviceProcedure(&procedures.create_shader_module, "vkCreateShaderModule")
           && LoadDeviceProcedure(&procedures.destroy_shader_module, "vkDestroyShaderModule")
           && LoadDeviceProcedure(
               &procedures.create_compute_pipelines,
               "vkCreateComputePipelines")
           && LoadDeviceProcedure(&procedures.destroy_pipeline, "vkDestroyPipeline")
           && LoadDeviceProcedure(
               &procedures.create_descriptor_pool,
               "vkCreateDescriptorPool")
           && LoadDeviceProcedure(
               &procedures.destroy_descriptor_pool,
               "vkDestroyDescriptorPool")
           && LoadDeviceProcedure(
               &procedures.allocate_descriptor_sets,
               "vkAllocateDescriptorSets")
           && LoadDeviceProcedure(
               &procedures.update_descriptor_sets,
               "vkUpdateDescriptorSets")
           && LoadDeviceProcedure(&procedures.create_image, "vkCreateImage")
           && LoadDeviceProcedure(&procedures.destroy_image, "vkDestroyImage")
           && LoadDeviceProcedure(
               &procedures.get_image_memory_requirements,
               "vkGetImageMemoryRequirements")
           && LoadDeviceProcedure(&procedures.allocate_memory, "vkAllocateMemory")
           && LoadDeviceProcedure(&procedures.free_memory, "vkFreeMemory")
           && LoadDeviceProcedure(&procedures.bind_image_memory, "vkBindImageMemory")
           && LoadDeviceProcedure(&procedures.create_image_view, "vkCreateImageView")
           && LoadDeviceProcedure(&procedures.destroy_image_view, "vkDestroyImageView")
           && LoadDeviceProcedure(
               &procedures.cmd_pipeline_barrier,
               "vkCmdPipelineBarrier")
           && LoadDeviceProcedure(&procedures.cmd_bind_pipeline, "vkCmdBindPipeline")
           && LoadDeviceProcedure(
               &procedures.cmd_bind_descriptor_sets,
               "vkCmdBindDescriptorSets")
           && LoadDeviceProcedure(
               &procedures.cmd_push_constants,
               "vkCmdPushConstants")
           && LoadDeviceProcedure(&procedures.cmd_dispatch, "vkCmdDispatch")
           && LoadDeviceProcedure(&procedures.create_event, "vkCreateEvent")
           && LoadDeviceProcedure(&procedures.destroy_event, "vkDestroyEvent")
           && LoadDeviceProcedure(&procedures.get_event_status, "vkGetEventStatus")
           && LoadDeviceProcedure(&procedures.reset_event, "vkResetEvent")
           && LoadDeviceProcedure(&procedures.cmd_set_event, "vkCmdSetEvent")
           && LoadDeviceProcedure(&procedures.device_wait_idle, "vkDeviceWaitIdle");
  }

  bool SupportsOptimalFormat(VkFormat format, VkFormatFeatureFlags required) const {
    VkFormatProperties properties = {};
    procedures.get_physical_device_format_properties(
        physical_device,
        format,
        &properties);
    return (properties.optimalTilingFeatures & required) == required;
  }

  bool ValidateFormatSupport() const {
    constexpr VkFormatFeatureFlags kSampled = VK_FORMAT_FEATURE_SAMPLED_IMAGE_BIT;
    constexpr VkFormatFeatureFlags kSampledStorage =
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_BIT | VK_FORMAT_FEATURE_STORAGE_IMAGE_BIT;
    return SupportsOptimalFormat(kNativeCurrentColorFormat, kSampled)
           && SupportsOptimalFormat(kNativeMotionVectorFormat, kSampled)
           && SupportsOptimalFormat(kNativeDepthFormat, kSampled)
           && SupportsOptimalFormat(kNativeOutputFormat, VK_FORMAT_FEATURE_STORAGE_IMAGE_BIT)
           && SupportsOptimalFormat(kAdaptedColorFormat, kSampledStorage);
  }

  AdapterResult CreateComputePipeline(
      std::span<const std::uint32_t> spirv,
      VkPipelineLayout layout,
      VkPipeline* pipeline) const {
    if (spirv.empty() || spirv.front() != UINT32_C(0x07230203) || layout == VK_NULL_HANDLE
        || pipeline == nullptr) {
      return Fallback(AdapterDetail::kInvalidArgument);
    }

    const VkShaderModuleCreateInfo module_info = {
        VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
        nullptr,
        0u,
        spirv.size_bytes(),
        spirv.data(),
    };
    VkShaderModule shader_module = VK_NULL_HANDLE;
    VkResult result = procedures.create_shader_module(
        device,
        &module_info,
        nullptr,
        &shader_module);
    if (result != VK_SUCCESS) return VulkanError(result);

    const VkPipelineShaderStageCreateInfo stage_info = {
        VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        nullptr,
        0u,
        VK_SHADER_STAGE_COMPUTE_BIT,
        shader_module,
        "main",
        nullptr,
    };
    const VkComputePipelineCreateInfo pipeline_info = {
        VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO,
        nullptr,
        0u,
        stage_info,
        layout,
        VK_NULL_HANDLE,
        0,
    };
    result = procedures.create_compute_pipelines(
        device,
        VK_NULL_HANDLE,
        1u,
        &pipeline_info,
        nullptr,
        pipeline);
    procedures.destroy_shader_module(device, shader_module, nullptr);
    if (result != VK_SUCCESS) {
      if (*pipeline != VK_NULL_HANDLE) {
        procedures.destroy_pipeline(device, *pipeline, nullptr);
        *pipeline = VK_NULL_HANDLE;
      }
      return VulkanError(result);
    }
    return Success();
  }

  AdapterResult CreateSharedObjects() {
    const VkSamplerCreateInfo sampler_info = {
        VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO,
        nullptr,
        0u,
        // Prepare uses texelFetch, so filtering is irrelevant there. The pack
        // shader uses this sampler only for the explicitly enabled spatial
        // diagnostic path; the regular DLSS path remains an exact texelFetch.
        VK_FILTER_LINEAR,
        VK_FILTER_LINEAR,
        VK_SAMPLER_MIPMAP_MODE_NEAREST,
        VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
        VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
        VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
        0.f,
        VK_FALSE,
        1.f,
        VK_FALSE,
        VK_COMPARE_OP_NEVER,
        0.f,
        0.f,
        VK_BORDER_COLOR_FLOAT_TRANSPARENT_BLACK,
        VK_FALSE,
    };
    VkResult result = procedures.create_sampler(device, &sampler_info, nullptr, &sampler);
    if (result != VK_SUCCESS) return VulkanError(result);

    const std::array<VkDescriptorSetLayoutBinding, 2u> prepare_bindings = {{
        {
            adapter_shaders::PrepareColorMotionBindings::kCurrentColor,
            VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            1u,
            VK_SHADER_STAGE_COMPUTE_BIT,
            nullptr,
        },
        {
            adapter_shaders::PrepareColorMotionBindings::kOutputColor,
            VK_DESCRIPTOR_TYPE_STORAGE_IMAGE,
            1u,
            VK_SHADER_STAGE_COMPUTE_BIT,
            nullptr,
        },
    }};
    const VkDescriptorSetLayoutCreateInfo prepare_layout_info = {
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
        nullptr,
        0u,
        static_cast<std::uint32_t>(prepare_bindings.size()),
        prepare_bindings.data(),
    };
    result = procedures.create_descriptor_set_layout(
        device,
        &prepare_layout_info,
        nullptr,
        &prepare_descriptor_set_layout);
    if (result != VK_SUCCESS) return VulkanError(result);

    const std::array<VkDescriptorSetLayoutBinding, 2u> pack_bindings = {{
        {
            adapter_shaders::PackColorBindings::kDlssColor,
            VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            1u,
            VK_SHADER_STAGE_COMPUTE_BIT,
            nullptr,
        },
        {
            adapter_shaders::PackColorBindings::kOutputColorPass,
            VK_DESCRIPTOR_TYPE_STORAGE_IMAGE,
            1u,
            VK_SHADER_STAGE_COMPUTE_BIT,
            nullptr,
        },
    }};
    const VkDescriptorSetLayoutCreateInfo pack_layout_info = {
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
        nullptr,
        0u,
        static_cast<std::uint32_t>(pack_bindings.size()),
        pack_bindings.data(),
    };
    result = procedures.create_descriptor_set_layout(
        device,
        &pack_layout_info,
        nullptr,
        &pack_descriptor_set_layout);
    if (result != VK_SUCCESS) return VulkanError(result);

    const VkPipelineLayoutCreateInfo prepare_pipeline_layout_info = {
        VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
        nullptr,
        0u,
        1u,
        &prepare_descriptor_set_layout,
        0u,
        nullptr,
    };
    result = procedures.create_pipeline_layout(
        device,
        &prepare_pipeline_layout_info,
        nullptr,
        &prepare_pipeline_layout);
    if (result != VK_SUCCESS) return VulkanError(result);

    const VkPushConstantRange pack_push_constant_range = {
        VK_SHADER_STAGE_COMPUTE_BIT,
        0u,
        adapter_shaders::kPackPushConstantRangeSize,
    };
    const VkPipelineLayoutCreateInfo pack_pipeline_layout_info = {
        VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
        nullptr,
        0u,
        1u,
        &pack_descriptor_set_layout,
        1u,
        &pack_push_constant_range,
    };
    result = procedures.create_pipeline_layout(
        device,
        &pack_pipeline_layout_info,
        nullptr,
        &pack_pipeline_layout);
    if (result != VK_SUCCESS) return VulkanError(result);

    auto pipeline_result = CreateComputePipeline(
        adapter_shaders::GetPrepareColorMotionSpirv(),
        prepare_pipeline_layout,
        &prepare_pipeline);
    if (!pipeline_result.Succeeded()) return pipeline_result;
    return CreateComputePipeline(
        adapter_shaders::GetPackColorSpirv(),
        pack_pipeline_layout,
        &pack_pipeline);
  }

  void DestroyImage(ImageAllocation* allocation) const {
    if (allocation == nullptr) return;
    if (allocation->view != VK_NULL_HANDLE) {
      procedures.destroy_image_view(device, allocation->view, nullptr);
    }
    if (allocation->image != VK_NULL_HANDLE) {
      procedures.destroy_image(device, allocation->image, nullptr);
    }
    if (allocation->memory != VK_NULL_HANDLE) {
      procedures.free_memory(device, allocation->memory, nullptr);
    }
    *allocation = {};
  }

  void DestroyBundle(ScratchBundle* bundle) const {
    if (bundle == nullptr) return;
    if (bundle->completion_event != VK_NULL_HANDLE) {
      procedures.destroy_event(device, bundle->completion_event, nullptr);
    }
    if (bundle->descriptor_pool != VK_NULL_HANDLE) {
      procedures.destroy_descriptor_pool(device, bundle->descriptor_pool, nullptr);
    }
    DestroyImage(&bundle->dlss_output);
    DestroyImage(&bundle->color);
    *bundle = {};
  }

  void DestroySharedObjects() {
    for (auto& [command_buffer, bundle] : bundles) {
      (void)command_buffer;
      DestroyBundle(&bundle);
    }
    bundles.clear();
    for (auto& bundle : idle_bundles) {
      DestroyBundle(&bundle);
    }
    idle_bundles.clear();
    if (pack_pipeline != VK_NULL_HANDLE) {
      procedures.destroy_pipeline(device, pack_pipeline, nullptr);
      pack_pipeline = VK_NULL_HANDLE;
    }
    if (prepare_pipeline != VK_NULL_HANDLE) {
      procedures.destroy_pipeline(device, prepare_pipeline, nullptr);
      prepare_pipeline = VK_NULL_HANDLE;
    }
    if (pack_pipeline_layout != VK_NULL_HANDLE) {
      procedures.destroy_pipeline_layout(device, pack_pipeline_layout, nullptr);
      pack_pipeline_layout = VK_NULL_HANDLE;
    }
    if (prepare_pipeline_layout != VK_NULL_HANDLE) {
      procedures.destroy_pipeline_layout(device, prepare_pipeline_layout, nullptr);
      prepare_pipeline_layout = VK_NULL_HANDLE;
    }
    if (pack_descriptor_set_layout != VK_NULL_HANDLE) {
      procedures.destroy_descriptor_set_layout(
          device,
          pack_descriptor_set_layout,
          nullptr);
      pack_descriptor_set_layout = VK_NULL_HANDLE;
    }
    if (prepare_descriptor_set_layout != VK_NULL_HANDLE) {
      procedures.destroy_descriptor_set_layout(
          device,
          prepare_descriptor_set_layout,
          nullptr);
      prepare_descriptor_set_layout = VK_NULL_HANDLE;
    }
    if (sampler != VK_NULL_HANDLE) {
      procedures.destroy_sampler(device, sampler, nullptr);
      sampler = VK_NULL_HANDLE;
    }
  }

  std::uint32_t FindMemoryType(
      std::uint32_t memory_type_bits,
      VkMemoryPropertyFlags required_flags) const {
    for (std::uint32_t index = 0u; index < memory_properties.memoryTypeCount; ++index) {
      const bool allowed = (memory_type_bits & (UINT32_C(1) << index)) != 0u;
      const auto flags = memory_properties.memoryTypes[index].propertyFlags;
      if (allowed && (flags & required_flags) == required_flags) return index;
    }
    return std::numeric_limits<std::uint32_t>::max();
  }

  AdapterResult CreateImage(
      VkFormat format,
      VkExtent2D extent,
      ImageAllocation* allocation) const {
    if (allocation == nullptr || extent.width == 0u || extent.height == 0u) {
      return Fallback(AdapterDetail::kInvalidArgument);
    }

    ImageAllocation created = {};
    created.format = format;
    created.extent = extent;
    const VkImageCreateInfo image_info = {
        VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO,
        nullptr,
        0u,
        VK_IMAGE_TYPE_2D,
        format,
        {extent.width, extent.height, 1u},
        1u,
        1u,
        VK_SAMPLE_COUNT_1_BIT,
        VK_IMAGE_TILING_OPTIMAL,
        VK_IMAGE_USAGE_SAMPLED_BIT | VK_IMAGE_USAGE_STORAGE_BIT
            | VK_IMAGE_USAGE_TRANSFER_SRC_BIT,
        VK_SHARING_MODE_EXCLUSIVE,
        0u,
        nullptr,
        VK_IMAGE_LAYOUT_UNDEFINED,
    };
    VkResult result = procedures.create_image(device, &image_info, nullptr, &created.image);
    if (result != VK_SUCCESS) return VulkanError(result);

    VkMemoryRequirements memory_requirements = {};
    procedures.get_image_memory_requirements(
        device,
        created.image,
        &memory_requirements);
    const auto memory_type = FindMemoryType(
        memory_requirements.memoryTypeBits,
        VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT);
    if (memory_type == std::numeric_limits<std::uint32_t>::max()) {
      DestroyImage(&created);
      return Fallback(AdapterDetail::kUnsupportedFormat);
    }

    const VkMemoryAllocateInfo memory_info = {
        VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        nullptr,
        memory_requirements.size,
        memory_type,
    };
    result = procedures.allocate_memory(device, &memory_info, nullptr, &created.memory);
    if (result != VK_SUCCESS) {
      DestroyImage(&created);
      return VulkanError(result);
    }
    result = procedures.bind_image_memory(device, created.image, created.memory, 0u);
    if (result != VK_SUCCESS) {
      DestroyImage(&created);
      return VulkanError(result);
    }

    const VkImageViewCreateInfo view_info = {
        VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
        nullptr,
        0u,
        created.image,
        VK_IMAGE_VIEW_TYPE_2D,
        format,
        {
            VK_COMPONENT_SWIZZLE_IDENTITY,
            VK_COMPONENT_SWIZZLE_IDENTITY,
            VK_COMPONENT_SWIZZLE_IDENTITY,
            VK_COMPONENT_SWIZZLE_IDENTITY,
        },
        ColorSubresourceRange(),
    };
    result = procedures.create_image_view(device, &view_info, nullptr, &created.view);
    if (result != VK_SUCCESS) {
      DestroyImage(&created);
      return VulkanError(result);
    }

    created.state = {
        .image = created.image,
        .image_view = created.view,
        .range = ColorSubresourceRange(),
        .format = format,
        .usage = image_info.usage,
        .layout = VK_IMAGE_LAYOUT_UNDEFINED,
        .stage = VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT,
        .access = 0u,
        .queue_family = VK_QUEUE_FAMILY_IGNORED,
        .contents_valid = false,
    };

    *allocation = created;
    return Success();
  }

  void UpdateStableDescriptors(ScratchBundle* bundle) const {
    const std::array<VkDescriptorImageInfo, 2u> images = {{
        {VK_NULL_HANDLE, bundle->color.view, VK_IMAGE_LAYOUT_GENERAL},
        {
            sampler,
            bundle->dlss_output.view,
            VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
        },
    }};
    const std::array<VkWriteDescriptorSet, 2u> writes = {{
        {
            VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            nullptr,
            bundle->prepare_descriptor_set,
            adapter_shaders::PrepareColorMotionBindings::kOutputColor,
            0u,
            1u,
            VK_DESCRIPTOR_TYPE_STORAGE_IMAGE,
            &images[0u],
            nullptr,
            nullptr,
        },
        {
            VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            nullptr,
            bundle->pack_descriptor_set,
            adapter_shaders::PackColorBindings::kDlssColor,
            0u,
            1u,
            VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            &images[1u],
            nullptr,
            nullptr,
        },
    }};
    procedures.update_descriptor_sets(
        device,
        static_cast<std::uint32_t>(writes.size()),
        writes.data(),
        0u,
        nullptr);
  }

  AdapterResult CreateBundle(
      VkCommandBuffer command_buffer,
      std::uint32_t render_width,
      std::uint32_t render_height,
      std::uint32_t output_width,
      std::uint32_t output_height,
      ScratchBundle* bundle) const {
    if (bundle == nullptr) return Fallback(AdapterDetail::kInvalidArgument);
    ScratchBundle created = {};
    created.command_buffer = command_buffer;
    const VkEventCreateInfo event_info = {
        VK_STRUCTURE_TYPE_EVENT_CREATE_INFO,
        nullptr,
        0u,
    };
    VkResult vk_result = procedures.create_event(
        device, &event_info, nullptr, &created.completion_event);
    if (vk_result != VK_SUCCESS) {
      DestroyBundle(&created);
      return VulkanError(vk_result);
    }
    auto result = CreateImage(
        kAdaptedColorFormat,
        {render_width, render_height},
        &created.color);
    if (!result.Succeeded()) {
      DestroyBundle(&created);
      return result;
    }
    result = CreateImage(
        kAdaptedColorFormat,
        {output_width, output_height},
        &created.dlss_output);
    if (!result.Succeeded()) {
      DestroyBundle(&created);
      return result;
    }

    const std::array<VkDescriptorPoolSize, 2u> pool_sizes = {{
        {VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER, 2u},
        {VK_DESCRIPTOR_TYPE_STORAGE_IMAGE, 2u},
    }};
    const VkDescriptorPoolCreateInfo pool_info = {
        VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
        nullptr,
        0u,
        2u,
        static_cast<std::uint32_t>(pool_sizes.size()),
        pool_sizes.data(),
    };
    vk_result = procedures.create_descriptor_pool(
        device,
        &pool_info,
        nullptr,
        &created.descriptor_pool);
    if (vk_result != VK_SUCCESS) {
      DestroyBundle(&created);
      return VulkanError(vk_result);
    }

    const std::array<VkDescriptorSetLayout, 2u> layouts = {
        prepare_descriptor_set_layout,
        pack_descriptor_set_layout,
    };
    const VkDescriptorSetAllocateInfo allocate_info = {
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
        nullptr,
        created.descriptor_pool,
        static_cast<std::uint32_t>(layouts.size()),
        layouts.data(),
    };
    std::array<VkDescriptorSet, 2u> sets = {};
    vk_result = procedures.allocate_descriptor_sets(device, &allocate_info, sets.data());
    if (vk_result != VK_SUCCESS) {
      DestroyBundle(&created);
      return VulkanError(vk_result);
    }
    created.prepare_descriptor_set = sets[0u];
    created.pack_descriptor_set = sets[1u];
    UpdateStableDescriptors(&created);
    *bundle = created;
    return Success();
  }

  static bool BundleDimensionsMatch(
      const ScratchBundle& bundle,
      const AdapterPrepareInfo& prepare_info) {
    return bundle.color.extent.width == prepare_info.render_width
           && bundle.color.extent.height == prepare_info.render_height
           && bundle.dlss_output.extent.width == prepare_info.output_width
           && bundle.dlss_output.extent.height == prepare_info.output_height;
  }

  static void ResetBundleForDiscardedRecording(
      ScratchBundle* bundle,
      VkCommandBuffer command_buffer) {
    if (bundle == nullptr) return;
    bundle->command_buffer = command_buffer;
    bundle->native_motion_vectors = {};
    bundle->native_output = {};
    bundle->native_output_state = {};
    bundle->token = 0u;
    bundle->recording_generation = 1u;
    bundle->prepared_generation = 0u;
    bundle->pack_constants = {};
    bundle->active = false;
    bundle->tainted = false;
    bundle->completion_pending = false;
    bundle->one_time_submit = false;

    // An explicit command-buffer reset or a signaled one-time completion event
    // invalidates the old recording. Every private image is fully overwritten
    // on its next use, so UNDEFINED safely discards its prior contents without
    // requiring knowledge of a partially recorded NGX layout sequence.
    for (auto* allocation : {&bundle->color, &bundle->dlss_output}) {
      allocation->state.layout = VK_IMAGE_LAYOUT_UNDEFINED;
      allocation->state.stage = VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;
      allocation->state.access = 0u;
      allocation->state.contents_valid = false;
    }
  }

  void RecycleBundle(VkCommandBuffer command_buffer) {
    const auto found = bundles.find(command_buffer);
    if (found == bundles.end()) return;

    ScratchBundle bundle = found->second;
    bundles.erase(found);
    if (bundle.completion_event != VK_NULL_HANDLE
        && procedures.reset_event(device, bundle.completion_event)
               != VK_SUCCESS) {
      DestroyBundle(&bundle);
      return;
    }
    ResetBundleForDiscardedRecording(&bundle, VK_NULL_HANDLE);
    // Initialize reserves maximum_scratch_bundles entries, and mapped + idle
    // can never exceed that limit. This push therefore performs no allocation
    // on a command-buffer reset hot path.
    idle_bundles.push_back(bundle);
  }

  void RecordCompletion(ScratchBundle* bundle) const {
    if (bundle == nullptr || bundle->completion_event == VK_NULL_HANDLE) return;
    procedures.cmd_set_event(
        bundle->command_buffer,
        bundle->completion_event,
        // NGX owns its internal command sequence, so completion must cover
        // every earlier stage before its private resources can be recycled.
        VK_PIPELINE_STAGE_ALL_COMMANDS_BIT);
    bundle->completion_pending = true;
  }

  bool ValidateDispatchDimensions(const AdapterPrepareInfo& prepare_info) const {
    if (prepare_info.render_width > physical_device_properties.limits.maxImageDimension2D
        || prepare_info.render_height > physical_device_properties.limits.maxImageDimension2D
        || prepare_info.output_width > physical_device_properties.limits.maxImageDimension2D
        || prepare_info.output_height > physical_device_properties.limits.maxImageDimension2D) {
      return false;
    }
    const auto render_groups_x = DispatchCount(
        prepare_info.render_width,
        adapter_shaders::kWorkgroupSize[0u]);
    const auto render_groups_y = DispatchCount(
        prepare_info.render_height,
        adapter_shaders::kWorkgroupSize[1u]);
    const auto output_groups_x = DispatchCount(
        prepare_info.output_width,
        adapter_shaders::kWorkgroupSize[0u]);
    const auto output_groups_y = DispatchCount(
        prepare_info.output_height,
        adapter_shaders::kWorkgroupSize[1u]);
    return render_groups_x <= physical_device_properties.limits.maxComputeWorkGroupCount[0u]
           && render_groups_y
                  <= physical_device_properties.limits.maxComputeWorkGroupCount[1u]
           && output_groups_x
                  <= physical_device_properties.limits.maxComputeWorkGroupCount[0u]
           && output_groups_y
                  <= physical_device_properties.limits.maxComputeWorkGroupCount[1u];
  }

  bool ValidatePrepareInfo(const AdapterPrepareInfo& prepare_info) const {
    if (prepare_info.command_buffer == VK_NULL_HANDLE || prepare_info.render_width == 0u
        || prepare_info.render_height == 0u || prepare_info.output_width == 0u
        || prepare_info.output_height == 0u) {
      return false;
    }
    const auto& color = prepare_info.current_color;
    const auto& depth = prepare_info.depth;
    const auto& motion = prepare_info.motion_vectors;
    const auto& output = prepare_info.output_color_pass;
    const auto& output_state = prepare_info.output_color_pass_state;
    const VkAccessFlags output_access =
        VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT;
    const bool exact_output_state =
        output_state.image == FromOpaque<VkImage>(output.image)
        && output_state.image_view == FromOpaque<VkImageView>(output.image_view)
        && output_state.range.aspectMask == VK_IMAGE_ASPECT_COLOR_BIT
        && output_state.range.baseMipLevel == output.mip_level
        && output_state.range.levelCount == 1u
        && output_state.range.baseArrayLayer == output.array_layer
        && output_state.range.layerCount == 1u
        && output_state.format == kNativeOutputFormat
        && (output_state.usage & VK_IMAGE_USAGE_STORAGE_BIT) != 0u
        && output_state.layout == VK_IMAGE_LAYOUT_GENERAL
        && output_state.stage == VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT
        && (output_state.access & output_access) != 0u
        && (output_state.access & ~output_access) == 0u
        && output_state.queue_family == VK_QUEUE_FAMILY_IGNORED
        && output_state.contents_valid;
    return color.image != 0u && color.image_view != 0u
           && color.format == kNativeCurrentColorFormat
           && color.width >= prepare_info.render_width
           && color.height >= prepare_info.render_height
           && IsSampledLayout(static_cast<VkImageLayout>(color.layout))
           && depth.image != 0u && depth.image_view != 0u
           && depth.format == kNativeDepthFormat
           && depth.width >= prepare_info.render_width
           && depth.height >= prepare_info.render_height
           && IsDepthReadLayout(static_cast<VkImageLayout>(depth.layout))
           && motion.image != 0u && motion.image_view != 0u
           && motion.format == kNativeMotionVectorFormat
           && motion.width >= prepare_info.render_width
           && motion.height >= prepare_info.render_height
           && IsSampledLayout(static_cast<VkImageLayout>(motion.layout))
           && output.image != 0u && output.image_view != 0u
           && output.format == kNativeOutputFormat
           && output.width >= prepare_info.output_width
           && output.height >= prepare_info.output_height
           && output.layout == VK_IMAGE_LAYOUT_GENERAL
           && exact_output_state
           && std::isfinite(prepare_info.dlaa_sharpening)
           && prepare_info.dlaa_sharpening >= 0.f
           && prepare_info.dlaa_sharpening <= 1.f
           && std::isfinite(prepare_info.dlaa_sharpening_normalization)
           && prepare_info.dlaa_sharpening_normalization >= 1.f
           && ValidateDispatchDimensions(prepare_info);
  }

  void UpdateFrameDescriptors(
      ScratchBundle* bundle,
      const AdapterPrepareInfo& prepare_info) const {
    const std::array<VkDescriptorImageInfo, 2u> images = {{
        {
            sampler,
            FromOpaque<VkImageView>(prepare_info.current_color.image_view),
            static_cast<VkImageLayout>(prepare_info.current_color.layout),
        },
        {
            VK_NULL_HANDLE,
            FromOpaque<VkImageView>(prepare_info.output_color_pass.image_view),
            VK_IMAGE_LAYOUT_GENERAL,
        },
    }};
    const std::array<VkWriteDescriptorSet, 2u> writes = {{
        {
            VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            nullptr,
            bundle->prepare_descriptor_set,
            adapter_shaders::PrepareColorMotionBindings::kCurrentColor,
            0u,
            1u,
            VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            &images[0u],
            nullptr,
            nullptr,
        },
        {
            VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            nullptr,
            bundle->pack_descriptor_set,
            adapter_shaders::PackColorBindings::kOutputColorPass,
            0u,
            1u,
            VK_DESCRIPTOR_TYPE_STORAGE_IMAGE,
            &images[1u],
            nullptr,
            nullptr,
        },
    }};
    procedures.update_descriptor_sets(
        device,
        static_cast<std::uint32_t>(writes.size()),
        writes.data(),
        0u,
        nullptr);
  }

  void RecordPrepare(
      ScratchBundle* bundle,
      const AdapterPrepareInfo& prepare_info) const {
    const std::array before_prepare_plans = {
        renodx::utils::dlss::vulkan::PlanScratchStorageWrite(bundle->color.state),
        renodx::utils::dlss::vulkan::PlanScratchStorageWrite(
            bundle->dlss_output.state),
    };
    const std::array before_prepare = {
        before_prepare_plans[0u].barrier,
        before_prepare_plans[1u].barrier,
    };
    procedures.cmd_pipeline_barrier(
        prepare_info.command_buffer,
        before_prepare_plans[0u].source_stage
            | before_prepare_plans[1u].source_stage,
        VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        0u,
        0u,
        nullptr,
        0u,
        nullptr,
        static_cast<std::uint32_t>(before_prepare.size()),
        before_prepare.data());
    for (auto* state : {&bundle->color.state, &bundle->dlss_output.state}) {
      state->layout = VK_IMAGE_LAYOUT_GENERAL;
      state->stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
      state->access = VK_ACCESS_SHADER_WRITE_BIT;
    }

    procedures.cmd_bind_pipeline(
        prepare_info.command_buffer,
        VK_PIPELINE_BIND_POINT_COMPUTE,
        prepare_pipeline);
    procedures.cmd_bind_descriptor_sets(
        prepare_info.command_buffer,
        VK_PIPELINE_BIND_POINT_COMPUTE,
        prepare_pipeline_layout,
        0u,
        1u,
        &bundle->prepare_descriptor_set,
        0u,
        nullptr);
    procedures.cmd_dispatch(
        prepare_info.command_buffer,
        DispatchCount(prepare_info.render_width, adapter_shaders::kWorkgroupSize[0u]),
        DispatchCount(prepare_info.render_height, adapter_shaders::kWorkgroupSize[1u]),
        1u);
    bundle->color.state.contents_valid = true;
    // Prepare does not write the NGX output, but its transition established the
    // exact GENERAL/storage state that Evaluate will consume and overwrite.
    bundle->dlss_output.state.contents_valid = false;

    const auto after_prepare_plan =
        renodx::utils::dlss::vulkan::PlanPreparedColorSampledRead(
            bundle->color.state);
    const std::array after_prepare = {after_prepare_plan.barrier};
    procedures.cmd_pipeline_barrier(
        prepare_info.command_buffer,
        after_prepare_plan.source_stage,
        after_prepare_plan.destination_stage,
        0u,
        0u,
        nullptr,
        0u,
        nullptr,
        static_cast<std::uint32_t>(after_prepare.size()),
        after_prepare.data());
    bundle->color.state.layout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
    bundle->color.state.stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
    bundle->color.state.access = VK_ACCESS_SHADER_READ_BIT;
  }

  void RecordPack(ScratchBundle* bundle) const {
    auto& pack_source = bundle->dlss_output;
    const auto source_plan =
        renodx::utils::dlss::vulkan::PlanNgxOutputSampledRead(
            pack_source.state);
    const auto native_output_plan =
        renodx::utils::dlss::vulkan::PlanNativeOutputPackWrite(
            bundle->native_output_state);
    const std::array before_pack = {
        source_plan.barrier,
        native_output_plan.barrier,
    };
    procedures.cmd_pipeline_barrier(
        bundle->command_buffer,
        VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        0u,
        0u,
        nullptr,
        0u,
        nullptr,
        static_cast<std::uint32_t>(before_pack.size()),
        before_pack.data());
    pack_source.state.layout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
    pack_source.state.stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
    pack_source.state.access = VK_ACCESS_SHADER_READ_BIT;

    procedures.cmd_bind_pipeline(
        bundle->command_buffer,
        VK_PIPELINE_BIND_POINT_COMPUTE,
        pack_pipeline);
    procedures.cmd_bind_descriptor_sets(
        bundle->command_buffer,
        VK_PIPELINE_BIND_POINT_COMPUTE,
        pack_pipeline_layout,
        0u,
        1u,
        &bundle->pack_descriptor_set,
        0u,
        nullptr);
    procedures.cmd_push_constants(
        bundle->command_buffer,
        pack_pipeline_layout,
        VK_SHADER_STAGE_COMPUTE_BIT,
        adapter_shaders::kPackPushConstantOffset,
        adapter_shaders::kPackPushConstantSize,
        &bundle->pack_constants);
    procedures.cmd_dispatch(
        bundle->command_buffer,
        DispatchCount(
            bundle->dlss_output.extent.width,
            adapter_shaders::kWorkgroupSize[0u]),
        DispatchCount(
            bundle->dlss_output.extent.height,
            adapter_shaders::kWorkgroupSize[1u]),
        1u);
    bundle->native_output_state.stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
    bundle->native_output_state.access = VK_ACCESS_SHADER_WRITE_BIT;
    bundle->native_output_state.layout = VK_IMAGE_LAYOUT_GENERAL;
    bundle->native_output_state.contents_valid = true;

    const auto after_pack =
        renodx::utils::dlss::vulkan::PlanPackedOutputDownstream(
            bundle->native_output_state);
    procedures.cmd_pipeline_barrier(
        bundle->command_buffer,
        after_pack.source_stage,
        after_pack.destination_stage,
        0u,
        0u,
        nullptr,
        0u,
        nullptr,
        1u,
        &after_pack.barrier);
    bundle->native_output_state.access =
        VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT;
  }

  static DetroitDlssResource MakeScratchResource(const ImageAllocation& allocation) {
    return {
        ToOpaque(allocation.image),
        ToOpaque(allocation.view),
        static_cast<std::uint32_t>(allocation.format),
        static_cast<std::uint32_t>(allocation.state.layout),
        allocation.extent.width,
        allocation.extent.height,
        0u,
        0u,
        0u,
        0u,
    };
  }
};

AdapterRuntime::AdapterRuntime() : impl_(std::make_unique<Impl>()) {}

// Vulkan teardown is explicit in HookDestroyDevice. A global DeviceState may
// otherwise reach this destructor during CRT process detach under the Windows
// loader lock, where waiting on or calling into the driver can deadlock exit.
// The OS reclaims any remaining process resources on that exceptional path.
AdapterRuntime::~AdapterRuntime() = default;

AdapterResult AdapterRuntime::Initialize(const AdapterRuntimeCreateInfo& create_info) {
  const std::lock_guard lock(impl_->mutex);
  if (impl_->initialized) return Fallback(AdapterDetail::kAlreadyInitialized);
  if (create_info.instance == VK_NULL_HANDLE
      || create_info.physical_device == VK_NULL_HANDLE
      || create_info.device == VK_NULL_HANDLE
      || create_info.get_instance_proc_addr == nullptr
      || create_info.get_device_proc_addr == nullptr
      || create_info.memory_properties.memoryTypeCount == 0u
      || create_info.maximum_scratch_bundles == 0u
      || create_info.maximum_scratch_bundles > kMaximumScratchBundlesHardLimit) {
    return Fallback(AdapterDetail::kInvalidArgument);
  }

  impl_->instance = create_info.instance;
  impl_->physical_device = create_info.physical_device;
  impl_->device = create_info.device;
  impl_->get_instance_proc_addr = create_info.get_instance_proc_addr;
  impl_->get_device_proc_addr = create_info.get_device_proc_addr;
  impl_->memory_properties = create_info.memory_properties;
  impl_->maximum_scratch_bundles = create_info.maximum_scratch_bundles;
  impl_->idle_bundles.reserve(impl_->maximum_scratch_bundles);
  if (!impl_->LoadProcedures()) {
    impl_->instance = VK_NULL_HANDLE;
    impl_->physical_device = VK_NULL_HANDLE;
    impl_->device = VK_NULL_HANDLE;
    return Fallback(AdapterDetail::kMissingProcedure);
  }
  impl_->procedures.get_physical_device_properties(
      impl_->physical_device,
      &impl_->physical_device_properties);
  if (!impl_->ValidateFormatSupport()) {
    impl_->instance = VK_NULL_HANDLE;
    impl_->physical_device = VK_NULL_HANDLE;
    impl_->device = VK_NULL_HANDLE;
    return Fallback(AdapterDetail::kUnsupportedFormat);
  }

  auto result = impl_->CreateSharedObjects();
  if (!result.Succeeded()) {
    impl_->DestroySharedObjects();
    impl_->instance = VK_NULL_HANDLE;
    impl_->physical_device = VK_NULL_HANDLE;
    impl_->device = VK_NULL_HANDLE;
    return result;
  }
  impl_->initialized = true;
  return Success();
}

AdapterResult AdapterRuntime::Prepare(
    const AdapterPrepareInfo& prepare_info,
    AdapterPreparedFrame* prepared_frame) {
  if (prepared_frame == nullptr) return Fallback(AdapterDetail::kInvalidArgument);
  *prepared_frame = {};
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized) return Fallback(AdapterDetail::kNotInitialized);
  if (!impl_->ValidatePrepareInfo(prepare_info)) {
    return Fallback(AdapterDetail::kUnexpectedResource);
  }

  auto found = impl_->bundles.find(prepare_info.command_buffer);
  if (found == impl_->bundles.end()) {
    Impl::ScratchBundle created = {};
    const auto matching_idle = std::find_if(
        impl_->idle_bundles.begin(),
        impl_->idle_bundles.end(),
        [&](const Impl::ScratchBundle& bundle) {
          return !bundle.tainted
                 && Impl::BundleDimensionsMatch(bundle, prepare_info);
        });
    if (matching_idle != impl_->idle_bundles.end()) {
      created = *matching_idle;
      impl_->idle_bundles.erase(matching_idle);
      Impl::ResetBundleForDiscardedRecording(
          &created,
          prepare_info.command_buffer);
    } else {
      const std::size_t allocated_bundle_count =
          impl_->bundles.size() + impl_->idle_bundles.size();
      if (allocated_bundle_count >= impl_->maximum_scratch_bundles) {
        if (impl_->idle_bundles.empty()) {
          return Fallback(AdapterDetail::kScratchCapacityExceeded);
        }

        // All mapped bundles may still be referenced by pending work. An idle
        // bundle, however, crossed a successful explicit reset boundary and is
        // safe to rebuild for a new extent without increasing the cap.
        created = impl_->idle_bundles.back();
        impl_->idle_bundles.pop_back();
        impl_->DestroyBundle(&created);
      }

      auto create_result = impl_->CreateBundle(
          prepare_info.command_buffer,
          prepare_info.render_width,
          prepare_info.render_height,
          prepare_info.output_width,
          prepare_info.output_height,
          &created);
      if (!create_result.Succeeded()) return create_result;
    }
    found = impl_->bundles.emplace(prepare_info.command_buffer, created).first;
  }

  auto& bundle = found->second;
  if (bundle.active || bundle.prepared_generation == bundle.recording_generation) {
    return Fallback(AdapterDetail::kUnsafeCommandBufferReuse);
  }
  if (bundle.tainted || !Impl::BundleDimensionsMatch(bundle, prepare_info)) {
    const auto recording_generation = bundle.recording_generation;
    impl_->DestroyBundle(&bundle);
    auto create_result = impl_->CreateBundle(
        prepare_info.command_buffer,
        prepare_info.render_width,
        prepare_info.render_height,
        prepare_info.output_width,
        prepare_info.output_height,
        &bundle);
    if (!create_result.Succeeded()) {
      impl_->bundles.erase(found);
      return create_result;
    }
    bundle.recording_generation = recording_generation;
  }

  impl_->UpdateFrameDescriptors(&bundle, prepare_info);
  impl_->RecordPrepare(&bundle, prepare_info);
  bundle.native_motion_vectors = prepare_info.motion_vectors;
  bundle.native_output = prepare_info.output_color_pass;
  bundle.native_output_state = prepare_info.output_color_pass_state;
  bundle.pack_constants = {
      .sharpening = prepare_info.dlaa_sharpening,
      .normalization = prepare_info.dlaa_sharpening_normalization,
  };
  bundle.one_time_submit = prepare_info.one_time_submit;
  bundle.active = true;
  bundle.prepared_generation = bundle.recording_generation;
  bundle.token = impl_->next_token++;
  if (impl_->next_token == 0u) impl_->next_token = 1u;

  prepared_frame->token = bundle.token;
  prepared_frame->command_buffer = prepare_info.command_buffer;
  prepared_frame->color = Impl::MakeScratchResource(bundle.color);
  prepared_frame->depth = prepare_info.depth;
  prepared_frame->motion_vectors = bundle.native_motion_vectors;
  prepared_frame->output = Impl::MakeScratchResource(bundle.dlss_output);
  prepared_frame->color_state = bundle.color.state;
  prepared_frame->output_state = bundle.dlss_output.state;
  prepared_frame->native_output_state = bundle.native_output_state;
  prepared_frame->output_width = prepare_info.output_width;
  prepared_frame->output_height = prepare_info.output_height;
  return Success();
}

AdapterResult AdapterRuntime::CommitAfterNgx(
    const AdapterPreparedFrame& prepared_frame,
    bool ngx_succeeded) {
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized) return Fallback(AdapterDetail::kNotInitialized);
  const auto found = impl_->bundles.find(prepared_frame.command_buffer);
  if (found == impl_->bundles.end() || !found->second.active
      || found->second.token != prepared_frame.token
      || prepared_frame.token == 0u) {
    return Fallback(AdapterDetail::kStalePreparedFrame);
  }
  auto& bundle = found->second;
  if (!ngx_succeeded) {
    bundle.active = false;
    // NGX can fail after recording only part of its command sequence. Do not
    // guess which layout it left the private images in; discard its tracked
    // layouts at the next safe command-buffer recording boundary.
    bundle.tainted = true;
    impl_->RecordCompletion(&bundle);
    return Fallback(AdapterDetail::kNgxEvaluationFailed);
  }

  const auto expected_color = Impl::MakeScratchResource(bundle.color);
  const auto expected_output = Impl::MakeScratchResource(bundle.dlss_output);
  const bool prepared_resources_match =
      prepared_frame.color.image == expected_color.image
      && prepared_frame.color.image_view == expected_color.image_view
      && prepared_frame.motion_vectors.image == bundle.native_motion_vectors.image
      && prepared_frame.motion_vectors.image_view
             == bundle.native_motion_vectors.image_view
      && prepared_frame.motion_vectors.layout == bundle.native_motion_vectors.layout
      && prepared_frame.motion_vectors.format == bundle.native_motion_vectors.format
      && prepared_frame.output.image == expected_output.image
      && prepared_frame.output.image_view == expected_output.image_view
      && prepared_frame.color_state == bundle.color.state
      && prepared_frame.output_state == bundle.dlss_output.state
      && prepared_frame.native_output_state == bundle.native_output_state
      && prepared_frame.output_width == bundle.dlss_output.extent.width
      && prepared_frame.output_height == bundle.dlss_output.extent.height;
  if (!prepared_resources_match) {
    bundle.active = false;
    bundle.tainted = true;
    impl_->RecordCompletion(&bundle);
    return Fallback(AdapterDetail::kStalePreparedFrame);
  }

  // A successful NGX Evaluate recorded a compute storage write to this private
  // output. This is the only point where its contents become valid.
  bundle.dlss_output.state.layout = VK_IMAGE_LAYOUT_GENERAL;
  bundle.dlss_output.state.stage = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
  bundle.dlss_output.state.access = VK_ACCESS_SHADER_WRITE_BIT;
  bundle.dlss_output.state.contents_valid = true;
  impl_->RecordPack(&bundle);
  impl_->RecordCompletion(&bundle);
  bundle.active = false;
  return Success();
}

std::size_t AdapterRuntime::PollCompletedOneTimeCommandBuffers(
    std::span<VkCommandBuffer> completed) noexcept {
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized || completed.empty()) return 0u;

  std::size_t count = 0u;
  for (auto bundle = impl_->bundles.begin();
       bundle != impl_->bundles.end() && count < completed.size();) {
    auto& state = bundle->second;
    if (!state.one_time_submit || !state.completion_pending
        || impl_->procedures.get_event_status(
               impl_->device, state.completion_event)
               != VK_EVENT_SET) {
      ++bundle;
      continue;
    }
    if (impl_->procedures.reset_event(
            impl_->device, state.completion_event)
        != VK_SUCCESS) {
      ++bundle;
      continue;
    }

    completed[count++] = bundle->first;
    auto recycled = state;
    bundle = impl_->bundles.erase(bundle);
    Impl::ResetBundleForDiscardedRecording(&recycled, VK_NULL_HANDLE);
    impl_->idle_bundles.push_back(recycled);
  }
  return count;
}

void AdapterRuntime::RecycleCommandBuffer(VkCommandBuffer command_buffer) noexcept {
  if (command_buffer == VK_NULL_HANDLE) return;
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized) return;
  impl_->RecycleBundle(command_buffer);
}

AdapterResult AdapterRuntime::RetireCommandBuffer(VkCommandBuffer command_buffer) {
  if (command_buffer == VK_NULL_HANDLE) return Fallback(AdapterDetail::kInvalidArgument);
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized) return Fallback(AdapterDetail::kNotInitialized);
  const auto found = impl_->bundles.find(command_buffer);
  if (found == impl_->bundles.end()) return Success();
  // The caller contract guarantees that the command buffer is not pending.
  // Unlike RecycleCommandBuffer, this path may run before the downstream
  // free/destroy call has invalidated the old recording, so do not expose its
  // descriptor sets to another command buffer through the idle pool.
  impl_->DestroyBundle(&found->second);
  impl_->bundles.erase(found);
  return Success();
}

void AdapterRuntime::Shutdown(bool wait_for_idle) noexcept {
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized) return;
  if (wait_for_idle) {
    (void)impl_->procedures.device_wait_idle(impl_->device);
  }
  impl_->DestroySharedObjects();
  impl_->procedures = {};
  impl_->physical_device_properties = {};
  impl_->memory_properties = {};
  impl_->instance = VK_NULL_HANDLE;
  impl_->physical_device = VK_NULL_HANDLE;
  impl_->device = VK_NULL_HANDLE;
  impl_->get_instance_proc_addr = nullptr;
  impl_->get_device_proc_addr = nullptr;
  impl_->maximum_scratch_bundles = 0u;
  impl_->next_token = 1u;
  impl_->initialized = false;
}

}  // namespace renodx::games::detroitbecomehuman::dlss
