#include <vulkan/vulkan.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <iostream>
#include <limits>
#include <span>
#include <string>
#include <vector>

namespace {

struct alignas(16) Sample {
  float r;
  float g;
  float b;
  float a;
};

constexpr std::size_t kSampleCount = 64u;
constexpr std::size_t kNeutralBegin = 3u;
constexpr std::size_t kNeutralEnd = 21u;
constexpr std::size_t kAnchorIndex = 11u;
constexpr float kPeakRelative100 = 10.f;

std::vector<std::uint32_t> ReadSpirv(const std::string& path) {
  std::ifstream stream(path, std::ios::binary | std::ios::ate);
  if (!stream) return {};
  const auto bytes = stream.tellg();
  if (bytes <= 0 || (bytes % 4) != 0) return {};
  std::vector<std::uint32_t> result(
      static_cast<std::size_t>(bytes) / sizeof(std::uint32_t));
  stream.seekg(0, std::ios::beg);
  stream.read(
      reinterpret_cast<char*>(result.data()),
      static_cast<std::streamsize>(bytes));
  return stream.good() ? result : std::vector<std::uint32_t>{};
}

std::uint32_t FindMemoryType(
    const VkPhysicalDeviceMemoryProperties& properties,
    std::uint32_t type_bits,
    VkMemoryPropertyFlags required) {
  for (std::uint32_t index = 0u; index < properties.memoryTypeCount; ++index) {
    if ((type_bits & (1u << index)) != 0u
        && (properties.memoryTypes[index].propertyFlags & required)
               == required) {
      return index;
    }
  }
  return UINT32_MAX;
}

bool CreateHostBuffer(
    VkDevice device,
    const VkPhysicalDeviceMemoryProperties& memory_properties,
    VkDeviceSize size,
    VkBuffer* buffer,
    VkDeviceMemory* memory) {
  const VkBufferCreateInfo buffer_info = {
      .sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO,
      .size = size,
      .usage = VK_BUFFER_USAGE_STORAGE_BUFFER_BIT,
      .sharingMode = VK_SHARING_MODE_EXCLUSIVE,
  };
  if (vkCreateBuffer(device, &buffer_info, nullptr, buffer) != VK_SUCCESS) {
    return false;
  }
  VkMemoryRequirements requirements = {};
  vkGetBufferMemoryRequirements(device, *buffer, &requirements);
  const std::uint32_t memory_type = FindMemoryType(
      memory_properties,
      requirements.memoryTypeBits,
      VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT
          | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT);
  if (memory_type == UINT32_MAX) return false;
  const VkMemoryAllocateInfo allocation_info = {
      .sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
      .allocationSize = requirements.size,
      .memoryTypeIndex = memory_type,
  };
  return vkAllocateMemory(device, &allocation_info, nullptr, memory)
             == VK_SUCCESS
         && vkBindBufferMemory(device, *buffer, *memory, 0u) == VK_SUCCESS;
}

std::array<Sample, kSampleCount> BuildSamples() {
  std::array<Sample, kSampleCount> samples = {};
  const std::array<float, 24u> neutral = {
      -4.f,
      -1.f,
      -0.1f,
      0.f,
      1.0e-6f,
      1.0e-4f,
      0.001f,
      0.01f,
      0.02f,
      0.05f,
      0.1f,
      0.18f,
      0.25f,
      0.5f,
      1.f,
      2.f,
      4.f,
      8.f,
      16.f,
      64.f,
      65504.f,
      std::numeric_limits<float>::infinity(),
      -std::numeric_limits<float>::infinity(),
      std::numeric_limits<float>::quiet_NaN(),
  };
  for (std::size_t index = 0u; index < neutral.size(); ++index) {
    samples[index] = {neutral[index], neutral[index], neutral[index], 1.f};
  }

  const std::array<Sample, 18u> colors = {{
      {1.f, 0.f, 0.f, 1.f},
      {0.f, 1.f, 0.f, 1.f},
      {0.f, 0.f, 1.f, 1.f},
      {1.f, 1.f, 0.f, 1.f},
      {1.f, 0.f, 1.f, 1.f},
      {0.f, 1.f, 1.f, 1.f},
      {1.f, 1.f, 1.f, 1.f},
      {1.6605f, -0.1246f, -0.0182f, 1.f},
      {-0.5876f, 1.1329f, -0.1006f, 1.f},
      {-0.0728f, -0.0083f, 1.1187f, 1.f},
      {4.f, -1.f, 0.25f, 1.f},
      {-2.f, 3.f, 0.5f, 1.f},
      {32.f, 1.f, 0.f, 1.f},
      {0.f, 32.f, 1.f, 1.f},
      {1.f, 0.f, 32.f, 1.f},
      {65504.f, 0.f, 0.f, 1.f},
      {0.f, 65504.f, 0.f, 1.f},
      {0.f, 0.f, 65504.f, 1.f},
  }};
  std::copy(colors.begin(), colors.end(), samples.begin() + neutral.size());
  for (std::size_t index = neutral.size() + colors.size();
       index < samples.size();
       ++index) {
    const float x = static_cast<float>(index - neutral.size()) * 0.173f;
    samples[index] = {
        std::sin(x) * 8.f,
        std::cos(x * 1.7f) * 4.f,
        std::sin(x * 2.3f + 0.5f) * 16.f,
        1.f,
    };
  }
  return samples;
}

float Luminance(const Sample& sample) {
  return 0.2627f * sample.r + 0.6780f * sample.g + 0.0593f * sample.b;
}

bool Validate(
    const std::string& mode,
    std::span<const Sample> first,
    std::span<const Sample> second) {
  for (std::size_t index = 0u; index < first.size(); ++index) {
    const auto& value = first[index];
    if (!std::isfinite(value.r) || !std::isfinite(value.g)
        || !std::isfinite(value.b) || !std::isfinite(value.a)) {
      std::cerr << mode << ": non-finite output at sample " << index << '\n';
      return false;
    }
    if (std::min({value.r, value.g, value.b}) < -1.0e-4f
        || std::max({value.r, value.g, value.b})
               > kPeakRelative100 * 1.01f) {
      std::cerr << mode << ": peak/range violation at sample " << index
                << " = (" << value.r << ", " << value.g << ", "
                << value.b << ")\n";
      return false;
    }
    if (std::abs(value.a - 1.f) > 1.0e-6f) {
      std::cerr << mode << ": alpha contract failed at sample " << index << '\n';
      return false;
    }
    if (std::memcmp(&value, &second[index], sizeof(Sample)) != 0) {
      std::cerr << mode << ": non-deterministic output at sample " << index << '\n';
      return false;
    }
  }

  float previous_luminance = -1.f;
  for (std::size_t index = kNeutralBegin; index <= kNeutralEnd; ++index) {
    const auto& value = first[index];
    const float luminance = Luminance(value);
    if (luminance + 2.0e-4f < previous_luminance) {
      std::cerr << mode << ": neutral ramp is not monotonic at sample "
                << index << '\n';
      return false;
    }
    previous_luminance = luminance;
    const float tolerance = std::max(2.0e-3f, luminance * 2.0e-3f);
    if (std::abs(value.r - value.g) > tolerance
        || std::abs(value.g - value.b) > tolerance) {
      std::cerr << mode << ": D65 neutral drift at sample " << index << '\n';
      return false;
    }
  }

  const float anchor = Luminance(first[kAnchorIndex]);
  const float expected_anchor = 0.18f * 203.f / 100.f;
  if (std::abs(anchor - expected_anchor) > 0.025f) {
    std::cerr << mode << ": 18% anchor drifted: " << anchor
              << " expected " << expected_anchor << '\n';
    return false;
  }
  return true;
}

}  // namespace

int main(int argc, char** argv) {
  if (argc != 7) {
    std::cerr << "usage: doom2016_tonemap_math_vulkan <P17.spv> <P22.spv>"
                 " <P24.spv> <P25.spv> <P30.spv> <RenoDRT.spv>\n";
    return 2;
  }

  const VkApplicationInfo application_info = {
      .sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,
      .pApplicationName = "DOOM 2016 RenoDX Tone Mapper Math Test",
      .applicationVersion = VK_MAKE_API_VERSION(0, 1, 0, 0),
      .pEngineName = "RenoDX Test",
      .engineVersion = VK_MAKE_API_VERSION(0, 1, 0, 0),
      .apiVersion = VK_API_VERSION_1_1,
  };
  const VkInstanceCreateInfo instance_info = {
      .sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
      .pApplicationInfo = &application_info,
  };
  VkInstance instance = VK_NULL_HANDLE;
  if (vkCreateInstance(&instance_info, nullptr, &instance) != VK_SUCCESS) {
    std::cerr << "vkCreateInstance failed\n";
    return 3;
  }

  std::uint32_t physical_device_count = 0u;
  if (vkEnumeratePhysicalDevices(instance, &physical_device_count, nullptr)
          != VK_SUCCESS
      || physical_device_count == 0u) {
    std::cerr << "no Vulkan physical device\n";
    vkDestroyInstance(instance, nullptr);
    return 3;
  }
  std::vector<VkPhysicalDevice> physical_devices(physical_device_count);
  vkEnumeratePhysicalDevices(
      instance,
      &physical_device_count,
      physical_devices.data());
  const VkPhysicalDevice physical_device = physical_devices.front();

  std::uint32_t queue_family_count = 0u;
  vkGetPhysicalDeviceQueueFamilyProperties(
      physical_device,
      &queue_family_count,
      nullptr);
  std::vector<VkQueueFamilyProperties> queue_families(queue_family_count);
  vkGetPhysicalDeviceQueueFamilyProperties(
      physical_device,
      &queue_family_count,
      queue_families.data());
  std::uint32_t queue_family = UINT32_MAX;
  for (std::uint32_t index = 0u; index < queue_family_count; ++index) {
    if ((queue_families[index].queueFlags & VK_QUEUE_COMPUTE_BIT) != 0u) {
      queue_family = index;
      break;
    }
  }
  if (queue_family == UINT32_MAX) {
    std::cerr << "no Vulkan compute queue\n";
    vkDestroyInstance(instance, nullptr);
    return 3;
  }

  constexpr float queue_priority = 1.f;
  const VkDeviceQueueCreateInfo queue_info = {
      .sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
      .queueFamilyIndex = queue_family,
      .queueCount = 1u,
      .pQueuePriorities = &queue_priority,
  };
  const VkDeviceCreateInfo device_info = {
      .sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
      .queueCreateInfoCount = 1u,
      .pQueueCreateInfos = &queue_info,
  };
  VkDevice device = VK_NULL_HANDLE;
  if (vkCreateDevice(physical_device, &device_info, nullptr, &device)
      != VK_SUCCESS) {
    std::cerr << "vkCreateDevice failed\n";
    vkDestroyInstance(instance, nullptr);
    return 3;
  }
  VkQueue queue = VK_NULL_HANDLE;
  vkGetDeviceQueue(device, queue_family, 0u, &queue);

  VkPhysicalDeviceMemoryProperties memory_properties = {};
  vkGetPhysicalDeviceMemoryProperties(physical_device, &memory_properties);
  constexpr VkDeviceSize buffer_size = sizeof(Sample) * kSampleCount;
  VkBuffer input_buffer = VK_NULL_HANDLE;
  VkBuffer output_buffer = VK_NULL_HANDLE;
  VkDeviceMemory input_memory = VK_NULL_HANDLE;
  VkDeviceMemory output_memory = VK_NULL_HANDLE;
  if (!CreateHostBuffer(
          device,
          memory_properties,
          buffer_size,
          &input_buffer,
          &input_memory)
      || !CreateHostBuffer(
          device,
          memory_properties,
          buffer_size,
          &output_buffer,
          &output_memory)) {
    std::cerr << "host-visible storage buffer creation failed\n";
    return 3;
  }

  void* input_mapped = nullptr;
  void* output_mapped = nullptr;
  if (vkMapMemory(device, input_memory, 0u, buffer_size, 0u, &input_mapped)
          != VK_SUCCESS
      || vkMapMemory(
             device,
             output_memory,
             0u,
             buffer_size,
             0u,
             &output_mapped)
             != VK_SUCCESS) {
    std::cerr << "buffer mapping failed\n";
    return 3;
  }
  const auto samples = BuildSamples();
  std::memcpy(input_mapped, samples.data(), buffer_size);

  const std::array<VkDescriptorSetLayoutBinding, 2u> bindings = {{
      {
          .binding = 0u,
          .descriptorType = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
          .descriptorCount = 1u,
          .stageFlags = VK_SHADER_STAGE_COMPUTE_BIT,
      },
      {
          .binding = 1u,
          .descriptorType = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
          .descriptorCount = 1u,
          .stageFlags = VK_SHADER_STAGE_COMPUTE_BIT,
      },
  }};
  const VkDescriptorSetLayoutCreateInfo descriptor_layout_info = {
      .sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
      .bindingCount = static_cast<std::uint32_t>(bindings.size()),
      .pBindings = bindings.data(),
  };
  VkDescriptorSetLayout descriptor_layout = VK_NULL_HANDLE;
  if (vkCreateDescriptorSetLayout(
          device,
          &descriptor_layout_info,
          nullptr,
          &descriptor_layout)
      != VK_SUCCESS) {
    std::cerr << "descriptor layout creation failed\n";
    return 3;
  }
  const VkPipelineLayoutCreateInfo pipeline_layout_info = {
      .sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
      .setLayoutCount = 1u,
      .pSetLayouts = &descriptor_layout,
  };
  VkPipelineLayout pipeline_layout = VK_NULL_HANDLE;
  if (vkCreatePipelineLayout(
          device,
          &pipeline_layout_info,
          nullptr,
          &pipeline_layout)
      != VK_SUCCESS) {
    std::cerr << "pipeline layout creation failed\n";
    return 3;
  }

  const VkDescriptorPoolSize pool_size = {
      .type = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
      .descriptorCount = 2u,
  };
  const VkDescriptorPoolCreateInfo pool_info = {
      .sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
      .maxSets = 1u,
      .poolSizeCount = 1u,
      .pPoolSizes = &pool_size,
  };
  VkDescriptorPool descriptor_pool = VK_NULL_HANDLE;
  vkCreateDescriptorPool(device, &pool_info, nullptr, &descriptor_pool);
  const VkDescriptorSetAllocateInfo set_info = {
      .sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
      .descriptorPool = descriptor_pool,
      .descriptorSetCount = 1u,
      .pSetLayouts = &descriptor_layout,
  };
  VkDescriptorSet descriptor_set = VK_NULL_HANDLE;
  if (vkAllocateDescriptorSets(device, &set_info, &descriptor_set)
      != VK_SUCCESS) {
    std::cerr << "descriptor allocation failed\n";
    return 3;
  }
  const std::array<VkDescriptorBufferInfo, 2u> buffer_infos = {{
      {.buffer = input_buffer, .offset = 0u, .range = buffer_size},
      {.buffer = output_buffer, .offset = 0u, .range = buffer_size},
  }};
  const std::array<VkWriteDescriptorSet, 2u> writes = {{
      {
          .sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
          .dstSet = descriptor_set,
          .dstBinding = 0u,
          .descriptorCount = 1u,
          .descriptorType = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
          .pBufferInfo = &buffer_infos[0],
      },
      {
          .sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
          .dstSet = descriptor_set,
          .dstBinding = 1u,
          .descriptorCount = 1u,
          .descriptorType = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
          .pBufferInfo = &buffer_infos[1],
      },
  }};
  vkUpdateDescriptorSets(
      device,
      static_cast<std::uint32_t>(writes.size()),
      writes.data(),
      0u,
      nullptr);

  const VkCommandPoolCreateInfo command_pool_info = {
      .sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
      .flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
      .queueFamilyIndex = queue_family,
  };
  VkCommandPool command_pool = VK_NULL_HANDLE;
  vkCreateCommandPool(device, &command_pool_info, nullptr, &command_pool);
  const VkCommandBufferAllocateInfo command_buffer_info = {
      .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
      .commandPool = command_pool,
      .level = VK_COMMAND_BUFFER_LEVEL_PRIMARY,
      .commandBufferCount = 1u,
  };
  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  vkAllocateCommandBuffers(device, &command_buffer_info, &command_buffer);

  const std::array<const char*, 6u> mode_names = {
      "PsychoV-17", "PsychoV-22", "PsychoV-24",
      "PsychoV-25", "PsychoV-30", "RenoDRT",
  };
  bool passed = true;
  for (std::size_t mode = 0u; mode < mode_names.size(); ++mode) {
    bool mode_passed = true;
    const auto code = ReadSpirv(argv[mode + 1u]);
    if (code.empty()) {
      std::cerr << mode_names[mode] << ": failed to read SPIR-V\n";
      passed = false;
      continue;
    }
    const VkShaderModuleCreateInfo shader_info = {
        .sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
        .codeSize = code.size() * sizeof(std::uint32_t),
        .pCode = code.data(),
    };
    VkShaderModule shader = VK_NULL_HANDLE;
    if (vkCreateShaderModule(device, &shader_info, nullptr, &shader)
        != VK_SUCCESS) {
      std::cerr << mode_names[mode] << ": shader module creation failed\n";
      passed = false;
      continue;
    }
    const VkComputePipelineCreateInfo pipeline_info = {
        .sType = VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO,
        .stage = {
            .sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
            .stage = VK_SHADER_STAGE_COMPUTE_BIT,
            .module = shader,
            .pName = "main",
        },
        .layout = pipeline_layout,
    };
    VkPipeline pipeline = VK_NULL_HANDLE;
    if (vkCreateComputePipelines(
            device,
            VK_NULL_HANDLE,
            1u,
            &pipeline_info,
            nullptr,
            &pipeline)
        != VK_SUCCESS) {
      std::cerr << mode_names[mode] << ": compute pipeline creation failed\n";
      vkDestroyShaderModule(device, shader, nullptr);
      passed = false;
      continue;
    }

    std::array<std::array<Sample, kSampleCount>, 2u> results = {};
    for (std::size_t run = 0u; run < results.size(); ++run) {
      std::memset(output_mapped, 0xCD, buffer_size);
      vkResetCommandBuffer(command_buffer, 0u);
      const VkCommandBufferBeginInfo begin_info = {
          .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
          .flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT,
      };
      vkBeginCommandBuffer(command_buffer, &begin_info);
      vkCmdBindPipeline(
          command_buffer,
          VK_PIPELINE_BIND_POINT_COMPUTE,
          pipeline);
      vkCmdBindDescriptorSets(
          command_buffer,
          VK_PIPELINE_BIND_POINT_COMPUTE,
          pipeline_layout,
          0u,
          1u,
          &descriptor_set,
          0u,
          nullptr);
      vkCmdDispatch(command_buffer, 1u, 1u, 1u);
      const VkMemoryBarrier host_barrier = {
          .sType = VK_STRUCTURE_TYPE_MEMORY_BARRIER,
          .srcAccessMask = VK_ACCESS_SHADER_WRITE_BIT,
          .dstAccessMask = VK_ACCESS_HOST_READ_BIT,
      };
      vkCmdPipelineBarrier(
          command_buffer,
          VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
          VK_PIPELINE_STAGE_HOST_BIT,
          0u,
          1u,
          &host_barrier,
          0u,
          nullptr,
          0u,
          nullptr);
      vkEndCommandBuffer(command_buffer);
      const VkSubmitInfo submit_info = {
          .sType = VK_STRUCTURE_TYPE_SUBMIT_INFO,
          .commandBufferCount = 1u,
          .pCommandBuffers = &command_buffer,
      };
      if (vkQueueSubmit(queue, 1u, &submit_info, VK_NULL_HANDLE) != VK_SUCCESS
          || vkQueueWaitIdle(queue) != VK_SUCCESS) {
        std::cerr << mode_names[mode] << ": dispatch failed\n";
        mode_passed = false;
        break;
      }
      std::memcpy(results[run].data(), output_mapped, buffer_size);
    }
    if (mode_passed
        && !Validate(mode_names[mode], results[0], results[1])) {
      mode_passed = false;
    }
    passed = passed && mode_passed;
    std::cout << mode_names[mode] << ": "
              << (mode_passed ? "PASS" : "FAIL") << '\n';
    vkDestroyPipeline(device, pipeline, nullptr);
    vkDestroyShaderModule(device, shader, nullptr);
  }

  vkDeviceWaitIdle(device);
  vkUnmapMemory(device, output_memory);
  vkUnmapMemory(device, input_memory);
  vkDestroyCommandPool(device, command_pool, nullptr);
  vkDestroyDescriptorPool(device, descriptor_pool, nullptr);
  vkDestroyPipelineLayout(device, pipeline_layout, nullptr);
  vkDestroyDescriptorSetLayout(device, descriptor_layout, nullptr);
  vkDestroyBuffer(device, output_buffer, nullptr);
  vkDestroyBuffer(device, input_buffer, nullptr);
  vkFreeMemory(device, output_memory, nullptr);
  vkFreeMemory(device, input_memory, nullptr);
  vkDestroyDevice(device, nullptr);
  vkDestroyInstance(instance, nullptr);
  return passed ? 0 : 1;
}
