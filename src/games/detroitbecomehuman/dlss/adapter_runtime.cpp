/*
 * SPDX-License-Identifier: MIT
 */

#include "adapter_runtime.hpp"

#include <algorithm>
#include <array>
#include <limits>
#include <mutex>
#include <span>
#include <type_traits>
#include <unordered_map>
#include <utility>
#include <vector>

#include "adapter_shaders.hpp"

namespace renodx::games::detroitbecomehuman::dlss {
namespace {

constexpr VkFormat kNativeCurrentColorFormat = VK_FORMAT_E5B9G9R9_UFLOAT_PACK32;
constexpr VkFormat kNativeMotionVectorFormat = VK_FORMAT_R16G16_SFLOAT;
constexpr VkFormat kNativeDepthFormat = VK_FORMAT_D32_SFLOAT_S8_UINT;
constexpr VkFormat kNativeOutputFormat = VK_FORMAT_R32_UINT;
constexpr VkFormat kAdaptedColorFormat = VK_FORMAT_R16G16B16A16_SFLOAT;
constexpr VkFormat kAdaptedMotionVectorFormat = VK_FORMAT_R16G16_SFLOAT;
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

VkImageSubresourceRange NativeColorSubresourceRange(const DetroitDlssResource& resource) {
  return {
      VK_IMAGE_ASPECT_COLOR_BIT,
      resource.mip_level,
      1u,
      resource.array_layer,
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
    PFN_vkCmdDispatch cmd_dispatch = nullptr;
    PFN_vkDeviceWaitIdle device_wait_idle = nullptr;
  } procedures;

  struct ImageAllocation {
    VkImage image = VK_NULL_HANDLE;
    VkDeviceMemory memory = VK_NULL_HANDLE;
    VkImageView view = VK_NULL_HANDLE;
    VkFormat format = VK_FORMAT_UNDEFINED;
    VkExtent2D extent = {};
    VkImageLayout layout = VK_IMAGE_LAYOUT_UNDEFINED;
  };

  struct ScratchBundle {
    VkCommandBuffer command_buffer = VK_NULL_HANDLE;
    ImageAllocation color;
    ImageAllocation motion_vectors;
    ImageAllocation dlss_output;
    VkDescriptorPool descriptor_pool = VK_NULL_HANDLE;
    VkDescriptorSet prepare_descriptor_set = VK_NULL_HANDLE;
    VkDescriptorSet pack_descriptor_set = VK_NULL_HANDLE;
    DetroitDlssResource native_output = {};
    std::uint64_t token = 0u;
    std::uint64_t recording_generation = 1u;
    std::uint64_t prepared_generation = 0u;
    bool diagnostic_spatial_output = false;
    bool active = false;
    bool tainted = false;
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
           && LoadDeviceProcedure(&procedures.cmd_dispatch, "vkCmdDispatch")
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
           && SupportsOptimalFormat(kAdaptedColorFormat, kSampledStorage)
           && SupportsOptimalFormat(kAdaptedMotionVectorFormat, kSampledStorage);
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

    const std::array<VkDescriptorSetLayoutBinding, 4u> prepare_bindings = {{
        {
            adapter_shaders::PrepareColorMotionBindings::kCurrentColor,
            VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            1u,
            VK_SHADER_STAGE_COMPUTE_BIT,
            nullptr,
        },
        {
            adapter_shaders::PrepareColorMotionBindings::kMotionVectors,
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
        {
            adapter_shaders::PrepareColorMotionBindings::kOutputMotionVectors,
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

    const VkPipelineLayoutCreateInfo pack_pipeline_layout_info = {
        VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
        nullptr,
        0u,
        1u,
        &pack_descriptor_set_layout,
        0u,
        nullptr,
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
    if (bundle->descriptor_pool != VK_NULL_HANDLE) {
      procedures.destroy_descriptor_pool(device, bundle->descriptor_pool, nullptr);
    }
    DestroyImage(&bundle->dlss_output);
    DestroyImage(&bundle->motion_vectors);
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

  std::uint32_t FindDeviceLocalMemoryType(std::uint32_t memory_type_bits) const {
    for (std::uint32_t index = 0u; index < memory_properties.memoryTypeCount; ++index) {
      const bool allowed = (memory_type_bits & (UINT32_C(1) << index)) != 0u;
      const auto flags = memory_properties.memoryTypes[index].propertyFlags;
      if (allowed && (flags & VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT) != 0u) return index;
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
        VK_IMAGE_USAGE_SAMPLED_BIT | VK_IMAGE_USAGE_STORAGE_BIT,
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
    const auto memory_type = FindDeviceLocalMemoryType(memory_requirements.memoryTypeBits);
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

    *allocation = created;
    return Success();
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
    auto result = CreateImage(
        kAdaptedColorFormat,
        {render_width, render_height},
        &created.color);
    if (!result.Succeeded()) {
      DestroyBundle(&created);
      return result;
    }
    result = CreateImage(
        kAdaptedMotionVectorFormat,
        {render_width, render_height},
        &created.motion_vectors);
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
        {VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER, 3u},
        {VK_DESCRIPTOR_TYPE_STORAGE_IMAGE, 3u},
    }};
    const VkDescriptorPoolCreateInfo pool_info = {
        VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
        nullptr,
        0u,
        2u,
        static_cast<std::uint32_t>(pool_sizes.size()),
        pool_sizes.data(),
    };
    VkResult vk_result = procedures.create_descriptor_pool(
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
    *bundle = created;
    return Success();
  }

  static bool BundleDimensionsMatch(
      const ScratchBundle& bundle,
      const AdapterPrepareInfo& prepare_info) {
    return bundle.color.extent.width == prepare_info.render_width
           && bundle.color.extent.height == prepare_info.render_height
           && bundle.motion_vectors.extent.width == prepare_info.render_width
           && bundle.motion_vectors.extent.height == prepare_info.render_height
           && bundle.dlss_output.extent.width == prepare_info.output_width
           && bundle.dlss_output.extent.height == prepare_info.output_height;
  }

  static void ResetBundleForDiscardedRecording(
      ScratchBundle* bundle,
      VkCommandBuffer command_buffer) {
    if (bundle == nullptr) return;
    bundle->command_buffer = command_buffer;
    bundle->native_output = {};
    bundle->token = 0u;
    bundle->recording_generation = 1u;
    bundle->prepared_generation = 0u;
    bundle->diagnostic_spatial_output = false;
    bundle->active = false;
    bundle->tainted = false;

    // A successful command-buffer/pool reset (and a successful Begin for an
    // existing command buffer) invalidates the old recording after it is no
    // longer pending. Every private image is fully overwritten on its next
    // use, so UNDEFINED safely discards its prior contents without requiring
    // knowledge of a partially recorded NGX layout sequence.
    bundle->color.layout = VK_IMAGE_LAYOUT_UNDEFINED;
    bundle->motion_vectors.layout = VK_IMAGE_LAYOUT_UNDEFINED;
    bundle->dlss_output.layout = VK_IMAGE_LAYOUT_UNDEFINED;
  }

  void RecycleBundle(VkCommandBuffer command_buffer) {
    const auto found = bundles.find(command_buffer);
    if (found == bundles.end()) return;

    ScratchBundle bundle = std::move(found->second);
    bundles.erase(found);
    ResetBundleForDiscardedRecording(&bundle, VK_NULL_HANDLE);
    // Initialize reserves maximum_scratch_bundles entries, and mapped + idle
    // can never exceed that limit. This push therefore performs no allocation
    // on a command-buffer reset hot path.
    idle_bundles.push_back(std::move(bundle));
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
           && ValidateDispatchDimensions(prepare_info);
  }

  void UpdateDescriptors(
      ScratchBundle* bundle,
      const AdapterPrepareInfo& prepare_info) const {
    const std::array<VkDescriptorImageInfo, 6u> images = {{
        {
            sampler,
            FromOpaque<VkImageView>(prepare_info.current_color.image_view),
            static_cast<VkImageLayout>(prepare_info.current_color.layout),
        },
        {
            sampler,
            FromOpaque<VkImageView>(prepare_info.motion_vectors.image_view),
            static_cast<VkImageLayout>(prepare_info.motion_vectors.layout),
        },
        {VK_NULL_HANDLE, bundle->color.view, VK_IMAGE_LAYOUT_GENERAL},
        {VK_NULL_HANDLE, bundle->motion_vectors.view, VK_IMAGE_LAYOUT_GENERAL},
        {
            sampler,
            prepare_info.diagnostic_spatial_output ? bundle->color.view
                                                   : bundle->dlss_output.view,
            VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
        },
        {
            VK_NULL_HANDLE,
            FromOpaque<VkImageView>(prepare_info.output_color_pass.image_view),
            VK_IMAGE_LAYOUT_GENERAL,
        },
    }};
    const std::array<VkWriteDescriptorSet, 6u> writes = {{
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
            bundle->prepare_descriptor_set,
            adapter_shaders::PrepareColorMotionBindings::kMotionVectors,
            0u,
            1u,
            VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            &images[1u],
            nullptr,
            nullptr,
        },
        {
            VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            nullptr,
            bundle->prepare_descriptor_set,
            adapter_shaders::PrepareColorMotionBindings::kOutputColor,
            0u,
            1u,
            VK_DESCRIPTOR_TYPE_STORAGE_IMAGE,
            &images[2u],
            nullptr,
            nullptr,
        },
        {
            VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            nullptr,
            bundle->prepare_descriptor_set,
            adapter_shaders::PrepareColorMotionBindings::kOutputMotionVectors,
            0u,
            1u,
            VK_DESCRIPTOR_TYPE_STORAGE_IMAGE,
            &images[3u],
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
            &images[4u],
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
            &images[5u],
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

  static VkImageMemoryBarrier ScratchBarrier(
      const ImageAllocation& allocation,
      VkImageLayout new_layout,
      VkAccessFlags source_access,
      VkAccessFlags destination_access) {
    return {
        VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        nullptr,
        source_access,
        destination_access,
        allocation.layout,
        new_layout,
        VK_QUEUE_FAMILY_IGNORED,
        VK_QUEUE_FAMILY_IGNORED,
        allocation.image,
        ColorSubresourceRange(),
    };
  }

  static VkImageMemoryBarrier NativeOutputBarrier(
      const DetroitDlssResource& output,
      VkAccessFlags source_access,
      VkAccessFlags destination_access) {
    return {
        VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        nullptr,
        source_access,
        destination_access,
        static_cast<VkImageLayout>(output.layout),
        static_cast<VkImageLayout>(output.layout),
        VK_QUEUE_FAMILY_IGNORED,
        VK_QUEUE_FAMILY_IGNORED,
        FromOpaque<VkImage>(output.image),
        NativeColorSubresourceRange(output),
    };
  }

  void RecordPrepare(
      ScratchBundle* bundle,
      const AdapterPrepareInfo& prepare_info) const {
    std::array<VkImageMemoryBarrier, 3u> before_prepare = {
        ScratchBarrier(
            bundle->color,
            VK_IMAGE_LAYOUT_GENERAL,
            bundle->color.layout == VK_IMAGE_LAYOUT_UNDEFINED
                ? 0u
                : VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT,
            VK_ACCESS_SHADER_WRITE_BIT),
        ScratchBarrier(
            bundle->motion_vectors,
            VK_IMAGE_LAYOUT_GENERAL,
            bundle->motion_vectors.layout == VK_IMAGE_LAYOUT_UNDEFINED
                ? 0u
                : VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT,
            VK_ACCESS_SHADER_WRITE_BIT),
        ScratchBarrier(
            bundle->dlss_output,
            VK_IMAGE_LAYOUT_GENERAL,
            bundle->dlss_output.layout == VK_IMAGE_LAYOUT_UNDEFINED
                ? 0u
                : VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT,
            VK_ACCESS_SHADER_WRITE_BIT),
    };
    procedures.cmd_pipeline_barrier(
        prepare_info.command_buffer,
        VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
        VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
        0u,
        0u,
        nullptr,
        0u,
        nullptr,
        static_cast<std::uint32_t>(before_prepare.size()),
        before_prepare.data());
    bundle->color.layout = VK_IMAGE_LAYOUT_GENERAL;
    bundle->motion_vectors.layout = VK_IMAGE_LAYOUT_GENERAL;
    bundle->dlss_output.layout = VK_IMAGE_LAYOUT_GENERAL;

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

    const std::array<VkImageMemoryBarrier, 2u> after_prepare = {
        ScratchBarrier(
            bundle->color,
            VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            VK_ACCESS_SHADER_WRITE_BIT,
            VK_ACCESS_SHADER_READ_BIT),
        ScratchBarrier(
            bundle->motion_vectors,
            VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            VK_ACCESS_SHADER_WRITE_BIT,
            VK_ACCESS_SHADER_READ_BIT),
    };
    procedures.cmd_pipeline_barrier(
        prepare_info.command_buffer,
        VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
        0u,
        0u,
        nullptr,
        0u,
        nullptr,
        static_cast<std::uint32_t>(after_prepare.size()),
        after_prepare.data());
    bundle->color.layout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
    bundle->motion_vectors.layout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
  }

  void RecordPack(ScratchBundle* bundle) const {
    auto& pack_source = bundle->diagnostic_spatial_output
                            ? bundle->color
                            : bundle->dlss_output;
    const std::array<VkImageMemoryBarrier, 2u> before_pack = {
        ScratchBarrier(
            pack_source,
            VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            // NGX is opaque to the adapter, while the diagnostic source was
            // written by Prepare. Conservatively expose the relevant writes
            // before the common pack shader samples either source.
            bundle->diagnostic_spatial_output ? VK_ACCESS_SHADER_WRITE_BIT
                                              : VK_ACCESS_MEMORY_WRITE_BIT,
            VK_ACCESS_SHADER_READ_BIT),
        NativeOutputBarrier(
            bundle->native_output,
            VK_ACCESS_SHADER_WRITE_BIT,
            VK_ACCESS_SHADER_WRITE_BIT),
    };
    procedures.cmd_pipeline_barrier(
        bundle->command_buffer,
        VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
        VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        0u,
        0u,
        nullptr,
        0u,
        nullptr,
        static_cast<std::uint32_t>(before_pack.size()),
        before_pack.data());
    pack_source.layout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;

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
    procedures.cmd_dispatch(
        bundle->command_buffer,
        DispatchCount(
            bundle->dlss_output.extent.width,
            adapter_shaders::kWorkgroupSize[0u]),
        DispatchCount(
            bundle->dlss_output.extent.height,
            adapter_shaders::kWorkgroupSize[1u]),
        1u);

    const auto after_pack = NativeOutputBarrier(
        bundle->native_output,
        VK_ACCESS_SHADER_WRITE_BIT,
        VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT);
    procedures.cmd_pipeline_barrier(
        bundle->command_buffer,
        VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
        0u,
        0u,
        nullptr,
        0u,
        nullptr,
        1u,
        &after_pack);
  }

  static DetroitDlssResource MakeScratchResource(const ImageAllocation& allocation) {
    return {
        ToOpaque(allocation.image),
        ToOpaque(allocation.view),
        static_cast<std::uint32_t>(allocation.format),
        static_cast<std::uint32_t>(allocation.layout),
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

AdapterRuntime::~AdapterRuntime() {
  Shutdown();
}

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
      created = std::move(*matching_idle);
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
        created = std::move(impl_->idle_bundles.back());
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
    found = impl_->bundles.emplace(prepare_info.command_buffer, std::move(created)).first;
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

  impl_->UpdateDescriptors(&bundle, prepare_info);
  impl_->RecordPrepare(&bundle, prepare_info);
  bundle.native_output = prepare_info.output_color_pass;
  bundle.diagnostic_spatial_output = prepare_info.diagnostic_spatial_output;
  bundle.active = true;
  bundle.prepared_generation = bundle.recording_generation;
  bundle.token = impl_->next_token++;
  if (impl_->next_token == 0u) impl_->next_token = 1u;

  prepared_frame->token = bundle.token;
  prepared_frame->command_buffer = prepare_info.command_buffer;
  prepared_frame->color = Impl::MakeScratchResource(bundle.color);
  prepared_frame->depth = prepare_info.depth;
  prepared_frame->motion_vectors = Impl::MakeScratchResource(bundle.motion_vectors);
  prepared_frame->output = Impl::MakeScratchResource(bundle.dlss_output);
  prepared_frame->render_width = prepare_info.render_width;
  prepared_frame->render_height = prepare_info.render_height;
  prepared_frame->output_width = prepare_info.output_width;
  prepared_frame->output_height = prepare_info.output_height;
  prepared_frame->diagnostic_spatial_output =
      prepare_info.diagnostic_spatial_output;
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
    return Fallback(AdapterDetail::kNgxEvaluationFailed);
  }

  const auto expected_color = Impl::MakeScratchResource(bundle.color);
  const auto expected_motion = Impl::MakeScratchResource(bundle.motion_vectors);
  const auto expected_output = Impl::MakeScratchResource(bundle.dlss_output);
  const bool prepared_resources_match =
      !prepared_frame.diagnostic_spatial_output
      && !bundle.diagnostic_spatial_output
      && prepared_frame.color.image == expected_color.image
      && prepared_frame.color.image_view == expected_color.image_view
      && prepared_frame.motion_vectors.image == expected_motion.image
      && prepared_frame.motion_vectors.image_view == expected_motion.image_view
      && prepared_frame.output.image == expected_output.image
      && prepared_frame.output.image_view == expected_output.image_view
      && prepared_frame.output_width == bundle.dlss_output.extent.width
      && prepared_frame.output_height == bundle.dlss_output.extent.height;
  if (!prepared_resources_match) {
    bundle.active = false;
    return Fallback(AdapterDetail::kStalePreparedFrame);
  }

  impl_->RecordPack(&bundle);
  bundle.active = false;
  return Success();
}

AdapterResult AdapterRuntime::CommitSpatialDiagnostic(
    const AdapterPreparedFrame& prepared_frame) {
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized) return Fallback(AdapterDetail::kNotInitialized);
  const auto found = impl_->bundles.find(prepared_frame.command_buffer);
  if (found == impl_->bundles.end() || !found->second.active
      || found->second.token != prepared_frame.token
      || prepared_frame.token == 0u) {
    return Fallback(AdapterDetail::kStalePreparedFrame);
  }

  auto& bundle = found->second;
  const auto expected_color = Impl::MakeScratchResource(bundle.color);
  const auto expected_motion = Impl::MakeScratchResource(bundle.motion_vectors);
  const auto expected_output = Impl::MakeScratchResource(bundle.dlss_output);
  const bool prepared_resources_match =
      prepared_frame.diagnostic_spatial_output
      && bundle.diagnostic_spatial_output
      && prepared_frame.color.image == expected_color.image
      && prepared_frame.color.image_view == expected_color.image_view
      && prepared_frame.motion_vectors.image == expected_motion.image
      && prepared_frame.motion_vectors.image_view == expected_motion.image_view
      && prepared_frame.output.image == expected_output.image
      && prepared_frame.output.image_view == expected_output.image_view
      && prepared_frame.output_width == bundle.dlss_output.extent.width
      && prepared_frame.output_height == bundle.dlss_output.extent.height;
  if (!prepared_resources_match) {
    bundle.active = false;
    return Fallback(AdapterDetail::kStalePreparedFrame);
  }

  impl_->RecordPack(&bundle);
  bundle.active = false;
  return Success();
}

AdapterResult AdapterRuntime::Discard(const AdapterPreparedFrame& prepared_frame) {
  return CommitAfterNgx(prepared_frame, false);
}

void AdapterRuntime::NotifyCommandBufferBegin(VkCommandBuffer command_buffer) noexcept {
  if (command_buffer == VK_NULL_HANDLE) return;
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized) return;
  // A successful Begin proves the previous recording is no longer pending.
  // Return its images to the extent-keyed idle pool instead of permanently
  // pinning one large output-sized bundle to every command-buffer handle.
  // Prepare will safely reacquire a matching idle bundle for this new
  // recording, keeping the cap proportional to concurrent frames rather than
  // the total number of command buffers Detroit has created.
  impl_->RecycleBundle(command_buffer);
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

void AdapterRuntime::Shutdown() noexcept {
  const std::lock_guard lock(impl_->mutex);
  if (!impl_->initialized) return;
  (void)impl_->procedures.device_wait_idle(impl_->device);
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

bool AdapterRuntime::IsInitialized() const noexcept {
  const std::lock_guard lock(impl_->mutex);
  return impl_->initialized;
}

}  // namespace renodx::games::detroitbecomehuman::dlss
