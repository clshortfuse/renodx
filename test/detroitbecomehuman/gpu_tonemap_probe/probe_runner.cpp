#define VK_USE_PLATFORM_WIN32_KHR
#include <vulkan/vulkan.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>

namespace {

constexpr uint32_t kLocalSize = 64u;
constexpr float kGameNits = 203.0f;

struct alignas(16) ProbeRecord {
  std::array<float, 4> input_type;
  std::array<float, 4> parameters;
  std::array<float, 4> output_value;
};
static_assert(sizeof(ProbeRecord) == 48u);

struct Operator {
  const char* name;
  float selector;
  bool adapted_anchors;
};

constexpr std::array<Operator, 7> kOperators = {{
    {"AgX", 3.0f, true},
    {"ACES Fitted", 4.0f, true},
    {"Lottes", 5.0f, true},
    {"Hable / Uncharted 2", 6.0f, true},
    {"Khronos PBR Neutral", 7.0f, true},
    {"PsychoV-22", 8.0f, false},
    {"Detroit DRT", 9.0f, true},
}};

constexpr std::array<float, 3> kPeakNits = {600.0f, 1000.0f, 4000.0f};
constexpr std::array<float, 14> kNeutralRamp = {
    0.0f,
    0.001f,
    0.01f,
    0.18f,
    0.5f,
    1.0f,
    2.0f,
    4.0f,
    8.0f,
    16.0f,
    64.0f,
    256.0f,
    4096.0f,
    65504.0f,
};

constexpr std::array<std::array<float, 3>, 5> kFiniteStressColors = {{
    {-65504.0f, -1.0f, -0.001f},
    {-10.0f, 4.0f, 1.0f},
    {65504.0f, 0.0f, 1.0f},
    {0.0f, 65504.0f, 0.0f},
    {0.0f, 0.0f, 65504.0f},
}};

constexpr size_t kSamplesPerSet =
    kNeutralRamp.size() + kFiniteStressColors.size();

[[noreturn]] void Fail(const std::string& message) {
  throw std::runtime_error(message);
}

void CheckVk(VkResult result, const char* operation) {
  if (result != VK_SUCCESS) {
    Fail(std::string(operation) + " failed with VkResult "
         + std::to_string(static_cast<int>(result)));
  }
}

std::vector<uint32_t> ReadSpirv(const std::filesystem::path& path) {
  std::ifstream stream(path, std::ios::binary | std::ios::ate);
  if (!stream) Fail("cannot open SPIR-V module: " + path.string());

  const std::streamoff byte_count = stream.tellg();
  if (byte_count <= 0 || (byte_count % 4) != 0) {
    Fail("invalid SPIR-V byte count: " + std::to_string(byte_count));
  }
  stream.seekg(0, std::ios::beg);

  std::vector<uint32_t> words(static_cast<size_t>(byte_count) / sizeof(uint32_t));
  if (!stream.read(
          reinterpret_cast<char*>(words.data()),
          static_cast<std::streamsize>(byte_count))) {
    Fail("failed to read SPIR-V module: " + path.string());
  }
  return words;
}

uint32_t FindMemoryType(
    const VkPhysicalDeviceMemoryProperties& properties,
    uint32_t type_bits,
    VkMemoryPropertyFlags required,
    VkMemoryPropertyFlags preferred,
    bool* is_coherent) {
  uint32_t fallback = UINT32_MAX;
  for (uint32_t index = 0u; index < properties.memoryTypeCount; ++index) {
    if ((type_bits & (1u << index)) == 0u) continue;
    const VkMemoryPropertyFlags flags =
        properties.memoryTypes[index].propertyFlags;
    if ((flags & required) != required) continue;
    if ((flags & preferred) == preferred) {
      *is_coherent = (flags & VK_MEMORY_PROPERTY_HOST_COHERENT_BIT) != 0u;
      return index;
    }
    if (fallback == UINT32_MAX) fallback = index;
  }
  if (fallback != UINT32_MAX) {
    const VkMemoryPropertyFlags flags =
        properties.memoryTypes[fallback].propertyFlags;
    *is_coherent = (flags & VK_MEMORY_PROPERTY_HOST_COHERENT_BIT) != 0u;
  }
  return fallback;
}

struct VulkanState {
  VkInstance instance = VK_NULL_HANDLE;
  VkDevice device = VK_NULL_HANDLE;
  VkBuffer buffer = VK_NULL_HANDLE;
  VkDeviceMemory memory = VK_NULL_HANDLE;
  void* mapped = nullptr;
  VkDescriptorSetLayout descriptor_set_layout = VK_NULL_HANDLE;
  VkDescriptorPool descriptor_pool = VK_NULL_HANDLE;
  VkShaderModule shader_module = VK_NULL_HANDLE;
  VkPipelineLayout pipeline_layout = VK_NULL_HANDLE;
  VkPipeline pipeline = VK_NULL_HANDLE;
  VkCommandPool command_pool = VK_NULL_HANDLE;
  VkFence fence = VK_NULL_HANDLE;

  ~VulkanState() {
    if (device != VK_NULL_HANDLE) {
      vkDeviceWaitIdle(device);
      if (fence != VK_NULL_HANDLE) vkDestroyFence(device, fence, nullptr);
      if (command_pool != VK_NULL_HANDLE) {
        vkDestroyCommandPool(device, command_pool, nullptr);
      }
      if (pipeline != VK_NULL_HANDLE) vkDestroyPipeline(device, pipeline, nullptr);
      if (pipeline_layout != VK_NULL_HANDLE) {
        vkDestroyPipelineLayout(device, pipeline_layout, nullptr);
      }
      if (shader_module != VK_NULL_HANDLE) {
        vkDestroyShaderModule(device, shader_module, nullptr);
      }
      if (descriptor_pool != VK_NULL_HANDLE) {
        vkDestroyDescriptorPool(device, descriptor_pool, nullptr);
      }
      if (descriptor_set_layout != VK_NULL_HANDLE) {
        vkDestroyDescriptorSetLayout(device, descriptor_set_layout, nullptr);
      }
      if (mapped != nullptr && memory != VK_NULL_HANDLE) {
        vkUnmapMemory(device, memory);
      }
      if (buffer != VK_NULL_HANDLE) vkDestroyBuffer(device, buffer, nullptr);
      if (memory != VK_NULL_HANDLE) vkFreeMemory(device, memory, nullptr);
      vkDestroyDevice(device, nullptr);
    }
    if (instance != VK_NULL_HANDLE) vkDestroyInstance(instance, nullptr);
  }
};

struct SelectedDevice {
  VkPhysicalDevice physical_device = VK_NULL_HANDLE;
  uint32_t queue_family = UINT32_MAX;
  VkPhysicalDeviceProperties properties = {};
};

SelectedDevice SelectPhysicalDevice(VkInstance instance) {
  uint32_t device_count = 0u;
  CheckVk(
      vkEnumeratePhysicalDevices(instance, &device_count, nullptr),
      "vkEnumeratePhysicalDevices(count)");
  if (device_count == 0u) Fail("no Vulkan physical device is available");

  std::vector<VkPhysicalDevice> devices(device_count);
  CheckVk(
      vkEnumeratePhysicalDevices(instance, &device_count, devices.data()),
      "vkEnumeratePhysicalDevices(list)");

  SelectedDevice selected;
  int selected_score = -1;
  for (VkPhysicalDevice physical_device : devices) {
    VkPhysicalDeviceProperties properties = {};
    vkGetPhysicalDeviceProperties(physical_device, &properties);

    uint32_t queue_count = 0u;
    vkGetPhysicalDeviceQueueFamilyProperties(
        physical_device, &queue_count, nullptr);
    std::vector<VkQueueFamilyProperties> queues(queue_count);
    vkGetPhysicalDeviceQueueFamilyProperties(
        physical_device, &queue_count, queues.data());

    uint32_t queue_family = UINT32_MAX;
    for (uint32_t index = 0u; index < queue_count; ++index) {
      if ((queues[index].queueFlags & VK_QUEUE_COMPUTE_BIT) != 0u) {
        queue_family = index;
        if ((queues[index].queueFlags & VK_QUEUE_GRAPHICS_BIT) == 0u) break;
      }
    }
    if (queue_family == UINT32_MAX) continue;

    int score = 1;
    if (properties.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU) {
      score = 100;
    } else if (properties.deviceType
               == VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU) {
      score = 50;
    }
    if (score > selected_score) {
      selected = {physical_device, queue_family, properties};
      selected_score = score;
    }
  }
  if (selected.physical_device == VK_NULL_HANDLE) {
    Fail("no Vulkan device exposes a compute queue");
  }
  return selected;
}

size_t RecordIndex(size_t operator_index, size_t peak_index, size_t sample_index) {
  return (operator_index * kPeakNits.size() + peak_index) * kSamplesPerSet
         + sample_index;
}

std::vector<ProbeRecord> BuildProbeRecords() {
  std::vector<ProbeRecord> records;
  records.reserve(kOperators.size() * kPeakNits.size() * kSamplesPerSet);
  const float sentinel = std::numeric_limits<float>::quiet_NaN();

  for (const Operator& tone_mapper : kOperators) {
    for (float peak_nits : kPeakNits) {
      for (float input : kNeutralRamp) {
        records.push_back({
            {input, input, input, tone_mapper.selector},
            {peak_nits, kGameNits, 0.0f, 0.0f},
            {sentinel, sentinel, sentinel, sentinel},
        });
      }
      for (const auto& input : kFiniteStressColors) {
        records.push_back({
            {input[0], input[1], input[2], tone_mapper.selector},
            {peak_nits, kGameNits, 0.0f, 0.0f},
            {sentinel, sentinel, sentinel, sentinel},
        });
      }
    }
  }
  return records;
}

float NeutralValue(const ProbeRecord& record) {
  return (record.output_value[0]
          + record.output_value[1]
          + record.output_value[2])
         / 3.0f;
}

void ValidateProbeOutputs(const std::vector<ProbeRecord>& records) {
  constexpr float kFiniteTolerance = 2.0e-5f;
  constexpr float kBoundTolerance = 2.0e-3f;
  constexpr float kAnchorTolerance = 3.0e-3f;
  constexpr size_t kBlackIndex = 0u;
  constexpr size_t kMidGrayIndex = 3u;
  constexpr size_t kDiffuseWhiteIndex = 5u;
  constexpr size_t kHighlightIndex = 8u;

  size_t validation_count = 0u;
  for (size_t operator_index = 0u;
       operator_index < kOperators.size();
       ++operator_index) {
    const Operator& tone_mapper = kOperators[operator_index];
    std::array<float, kPeakNits.size()> highlights = {};

    for (size_t peak_index = 0u; peak_index < kPeakNits.size(); ++peak_index) {
      const float peak_ratio = kPeakNits[peak_index] / kGameNits;
      for (size_t sample_index = 0u;
           sample_index < kSamplesPerSet;
           ++sample_index) {
        const ProbeRecord& record = records[RecordIndex(
            operator_index, peak_index, sample_index)];
        for (size_t channel = 0u; channel < 3u; ++channel) {
          const float value = record.output_value[channel];
          if (!std::isfinite(value)) {
            Fail(std::string(tone_mapper.name)
                 + " emitted a non-finite channel at peak "
                 + std::to_string(kPeakNits[peak_index]));
          }
          if (value < -kFiniteTolerance) {
            Fail(std::string(tone_mapper.name)
                 + " emitted a negative channel: " + std::to_string(value));
          }
          if (value > peak_ratio + kBoundTolerance) {
            Fail(std::string(tone_mapper.name)
                 + " exceeded Peak/Game bound: " + std::to_string(value)
                 + " > " + std::to_string(peak_ratio));
          }
          ++validation_count;
        }
        if (std::abs(record.output_value[3] - 1.0f) > 1.0e-6f) {
          Fail(std::string(tone_mapper.name)
               + " did not execute the storage-buffer write");
        }
      }

      const ProbeRecord& black = records[RecordIndex(
          operator_index, peak_index, kBlackIndex)];
      for (size_t channel = 0u; channel < 3u; ++channel) {
        if (std::abs(black.output_value[channel]) > 2.0e-4f) {
          Fail(std::string(tone_mapper.name) + " does not preserve black");
        }
      }

      float previous = -std::numeric_limits<float>::infinity();
      for (size_t ramp_index = 0u;
           ramp_index < kNeutralRamp.size();
           ++ramp_index) {
        const ProbeRecord& record = records[RecordIndex(
            operator_index, peak_index, ramp_index)];
        const float neutral = NeutralValue(record);
        const float channel_span =
            std::max({record.output_value[0], record.output_value[1],
                      record.output_value[2]})
            - std::min({record.output_value[0], record.output_value[1],
                        record.output_value[2]});
        const float neutral_tolerance = std::max(3.0e-4f, neutral * 2.0e-3f);
        if (channel_span > neutral_tolerance) {
          Fail(std::string(tone_mapper.name)
               + " shifts the neutral axis at input "
               + std::to_string(kNeutralRamp[ramp_index]));
        }
        if (neutral + 3.0e-4f < previous) {
          Fail(std::string(tone_mapper.name)
               + " is not monotonic on the neutral ramp");
        }
        previous = neutral;
      }

      if (tone_mapper.adapted_anchors) {
        const float mid_gray = NeutralValue(records[RecordIndex(
            operator_index, peak_index, kMidGrayIndex)]);
        const float diffuse_white = NeutralValue(records[RecordIndex(
            operator_index, peak_index, kDiffuseWhiteIndex)]);
        if (std::abs(mid_gray - 0.18f) > kAnchorTolerance) {
          Fail(std::string(tone_mapper.name)
               + " moved the 0.18 anchor to " + std::to_string(mid_gray));
        }
        if (std::abs(diffuse_white - 1.0f) > kAnchorTolerance) {
          Fail(std::string(tone_mapper.name)
               + " moved the 1.0 anchor to "
               + std::to_string(diffuse_white));
        }
      }

      highlights[peak_index] = NeutralValue(records[RecordIndex(
          operator_index, peak_index, kHighlightIndex)]);
    }

    if (!(highlights[0] + 1.0e-3f < highlights[1]
          && highlights[1] + 1.0e-3f < highlights[2])) {
      Fail(std::string(tone_mapper.name)
           + " does not respond monotonically to 600/1000/4000-nit peaks");
    }

    std::cout << tone_mapper.name << ": highlight@8 = "
              << highlights[0] << " / " << highlights[1] << " / "
              << highlights[2] << " (600/1000/4000 nits)\n";
  }

  std::cout << "Validated " << validation_count
            << " GPU channels across " << records.size()
            << " storage-buffer records.\n";
}

void RunProbe(const std::filesystem::path& spirv_path) {
  VulkanState state;
  const VkApplicationInfo application_info = {
      VK_STRUCTURE_TYPE_APPLICATION_INFO,
      nullptr,
      "Detroit Tone Mapper GPU Probe",
      VK_MAKE_API_VERSION(0, 1, 0, 0),
      "RenoDX Test",
      VK_MAKE_API_VERSION(0, 1, 0, 0),
      VK_API_VERSION_1_3,
  };
  const VkInstanceCreateInfo instance_info = {
      VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
      nullptr,
      0u,
      &application_info,
      0u,
      nullptr,
      0u,
      nullptr,
  };
  CheckVk(vkCreateInstance(&instance_info, nullptr, &state.instance),
          "vkCreateInstance");

  const SelectedDevice selected = SelectPhysicalDevice(state.instance);
  std::cout << "Vulkan device: " << selected.properties.deviceName << '\n';

  constexpr float queue_priority = 1.0f;
  const VkDeviceQueueCreateInfo queue_info = {
      VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
      nullptr,
      0u,
      selected.queue_family,
      1u,
      &queue_priority,
  };
  const VkDeviceCreateInfo device_info = {
      VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
      nullptr,
      0u,
      1u,
      &queue_info,
      0u,
      nullptr,
      0u,
      nullptr,
      nullptr,
  };
  CheckVk(
      vkCreateDevice(
          selected.physical_device, &device_info, nullptr, &state.device),
      "vkCreateDevice");
  VkQueue queue = VK_NULL_HANDLE;
  vkGetDeviceQueue(state.device, selected.queue_family, 0u, &queue);

  std::vector<ProbeRecord> records = BuildProbeRecords();
  const VkDeviceSize buffer_size = records.size() * sizeof(ProbeRecord);
  const VkBufferCreateInfo buffer_info = {
      VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO,
      nullptr,
      0u,
      buffer_size,
      VK_BUFFER_USAGE_STORAGE_BUFFER_BIT,
      VK_SHARING_MODE_EXCLUSIVE,
      0u,
      nullptr,
  };
  CheckVk(
      vkCreateBuffer(state.device, &buffer_info, nullptr, &state.buffer),
      "vkCreateBuffer");

  VkMemoryRequirements memory_requirements = {};
  vkGetBufferMemoryRequirements(
      state.device, state.buffer, &memory_requirements);
  VkPhysicalDeviceMemoryProperties memory_properties = {};
  vkGetPhysicalDeviceMemoryProperties(
      selected.physical_device, &memory_properties);
  bool host_coherent = false;
  const uint32_t memory_type = FindMemoryType(
      memory_properties,
      memory_requirements.memoryTypeBits,
      VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT,
      VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
      &host_coherent);
  if (memory_type == UINT32_MAX) {
    Fail("no host-visible Vulkan memory type for probe SSBO");
  }

  const VkMemoryAllocateInfo allocation_info = {
      VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
      nullptr,
      memory_requirements.size,
      memory_type,
  };
  CheckVk(
      vkAllocateMemory(
          state.device, &allocation_info, nullptr, &state.memory),
      "vkAllocateMemory");
  CheckVk(
      vkBindBufferMemory(state.device, state.buffer, state.memory, 0u),
      "vkBindBufferMemory");
  CheckVk(
      vkMapMemory(
          state.device,
          state.memory,
          0u,
          memory_requirements.size,
          0u,
          &state.mapped),
      "vkMapMemory");
  std::memcpy(state.mapped, records.data(), static_cast<size_t>(buffer_size));
  if (!host_coherent) {
    const VkMappedMemoryRange flush_range = {
        VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE,
        nullptr,
        state.memory,
        0u,
        VK_WHOLE_SIZE,
    };
    CheckVk(
        vkFlushMappedMemoryRanges(state.device, 1u, &flush_range),
        "vkFlushMappedMemoryRanges");
  }

  const VkDescriptorSetLayoutBinding descriptor_binding = {
      0u,
      VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
      1u,
      VK_SHADER_STAGE_COMPUTE_BIT,
      nullptr,
  };
  const VkDescriptorSetLayoutCreateInfo descriptor_layout_info = {
      VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
      nullptr,
      0u,
      1u,
      &descriptor_binding,
  };
  CheckVk(
      vkCreateDescriptorSetLayout(
          state.device,
          &descriptor_layout_info,
          nullptr,
          &state.descriptor_set_layout),
      "vkCreateDescriptorSetLayout");

  const VkPipelineLayoutCreateInfo pipeline_layout_info = {
      VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
      nullptr,
      0u,
      1u,
      &state.descriptor_set_layout,
      0u,
      nullptr,
  };
  CheckVk(
      vkCreatePipelineLayout(
          state.device,
          &pipeline_layout_info,
          nullptr,
          &state.pipeline_layout),
      "vkCreatePipelineLayout");

  const std::vector<uint32_t> spirv = ReadSpirv(spirv_path);
  const VkShaderModuleCreateInfo shader_info = {
      VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
      nullptr,
      0u,
      spirv.size() * sizeof(uint32_t),
      spirv.data(),
  };
  CheckVk(
      vkCreateShaderModule(
          state.device, &shader_info, nullptr, &state.shader_module),
      "vkCreateShaderModule");

  const VkPipelineShaderStageCreateInfo shader_stage = {
      VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
      nullptr,
      0u,
      VK_SHADER_STAGE_COMPUTE_BIT,
      state.shader_module,
      "main",
      nullptr,
  };
  const VkComputePipelineCreateInfo pipeline_info = {
      VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO,
      nullptr,
      0u,
      shader_stage,
      state.pipeline_layout,
      VK_NULL_HANDLE,
      0,
  };
  CheckVk(
      vkCreateComputePipelines(
          state.device,
          VK_NULL_HANDLE,
          1u,
          &pipeline_info,
          nullptr,
          &state.pipeline),
      "vkCreateComputePipelines");

  const VkDescriptorPoolSize pool_size = {
      VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
      1u,
  };
  const VkDescriptorPoolCreateInfo pool_info = {
      VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
      nullptr,
      0u,
      1u,
      1u,
      &pool_size,
  };
  CheckVk(
      vkCreateDescriptorPool(
          state.device, &pool_info, nullptr, &state.descriptor_pool),
      "vkCreateDescriptorPool");
  VkDescriptorSet descriptor_set = VK_NULL_HANDLE;
  const VkDescriptorSetAllocateInfo descriptor_allocate_info = {
      VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
      nullptr,
      state.descriptor_pool,
      1u,
      &state.descriptor_set_layout,
  };
  CheckVk(
      vkAllocateDescriptorSets(
          state.device, &descriptor_allocate_info, &descriptor_set),
      "vkAllocateDescriptorSets");
  const VkDescriptorBufferInfo descriptor_buffer_info = {
      state.buffer,
      0u,
      buffer_size,
  };
  const VkWriteDescriptorSet descriptor_write = {
      VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
      nullptr,
      descriptor_set,
      0u,
      0u,
      1u,
      VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
      nullptr,
      &descriptor_buffer_info,
      nullptr,
  };
  vkUpdateDescriptorSets(state.device, 1u, &descriptor_write, 0u, nullptr);

  const VkCommandPoolCreateInfo command_pool_info = {
      VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
      nullptr,
      0u,
      selected.queue_family,
  };
  CheckVk(
      vkCreateCommandPool(
          state.device, &command_pool_info, nullptr, &state.command_pool),
      "vkCreateCommandPool");
  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  const VkCommandBufferAllocateInfo command_allocate_info = {
      VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
      nullptr,
      state.command_pool,
      VK_COMMAND_BUFFER_LEVEL_PRIMARY,
      1u,
  };
  CheckVk(
      vkAllocateCommandBuffers(
          state.device, &command_allocate_info, &command_buffer),
      "vkAllocateCommandBuffers");

  const VkCommandBufferBeginInfo begin_info = {
      VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
      nullptr,
      VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT,
      nullptr,
  };
  CheckVk(vkBeginCommandBuffer(command_buffer, &begin_info),
          "vkBeginCommandBuffer");
  vkCmdBindPipeline(
      command_buffer, VK_PIPELINE_BIND_POINT_COMPUTE, state.pipeline);
  vkCmdBindDescriptorSets(
      command_buffer,
      VK_PIPELINE_BIND_POINT_COMPUTE,
      state.pipeline_layout,
      0u,
      1u,
      &descriptor_set,
      0u,
      nullptr);
  vkCmdDispatch(
      command_buffer,
      static_cast<uint32_t>((records.size() + kLocalSize - 1u) / kLocalSize),
      1u,
      1u);

  const VkBufferMemoryBarrier host_read_barrier = {
      VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER,
      nullptr,
      VK_ACCESS_SHADER_WRITE_BIT,
      VK_ACCESS_HOST_READ_BIT,
      VK_QUEUE_FAMILY_IGNORED,
      VK_QUEUE_FAMILY_IGNORED,
      state.buffer,
      0u,
      buffer_size,
  };
  vkCmdPipelineBarrier(
      command_buffer,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_PIPELINE_STAGE_HOST_BIT,
      0u,
      0u,
      nullptr,
      1u,
      &host_read_barrier,
      0u,
      nullptr);
  CheckVk(vkEndCommandBuffer(command_buffer), "vkEndCommandBuffer");

  const VkFenceCreateInfo fence_info = {
      VK_STRUCTURE_TYPE_FENCE_CREATE_INFO,
      nullptr,
      0u,
  };
  CheckVk(
      vkCreateFence(state.device, &fence_info, nullptr, &state.fence),
      "vkCreateFence");
  const VkSubmitInfo submit_info = {
      VK_STRUCTURE_TYPE_SUBMIT_INFO,
      nullptr,
      0u,
      nullptr,
      nullptr,
      1u,
      &command_buffer,
      0u,
      nullptr,
  };
  CheckVk(vkQueueSubmit(queue, 1u, &submit_info, state.fence),
          "vkQueueSubmit");
  CheckVk(
      vkWaitForFences(
          state.device, 1u, &state.fence, VK_TRUE, UINT64_MAX),
      "vkWaitForFences");

  if (!host_coherent) {
    const VkMappedMemoryRange invalidate_range = {
        VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE,
        nullptr,
        state.memory,
        0u,
        VK_WHOLE_SIZE,
    };
    CheckVk(
        vkInvalidateMappedMemoryRanges(
            state.device, 1u, &invalidate_range),
        "vkInvalidateMappedMemoryRanges");
  }
  std::memcpy(records.data(), state.mapped, static_cast<size_t>(buffer_size));
  ValidateProbeOutputs(records);
}

}  // namespace

int main(int argc, char** argv) {
  if (argc != 2) {
    std::cerr << "usage: detroitbecomehuman_gpu_tonemap_probe <probe.spv>\n";
    return 2;
  }

  try {
    RunProbe(std::filesystem::absolute(argv[1]));
    std::cout << "Detroit tone-mapper GPU probe passed.\n";
    return 0;
  } catch (const std::exception& error) {
    std::cerr << "Detroit tone-mapper GPU probe failed: " << error.what()
              << '\n';
    return 1;
  }
}
